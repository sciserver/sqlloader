"""Tests for bcpweblog.py. Run: python -m unittest test_bcpweblog  (from this folder).

Addresses are from the documentation ranges (RFC 5737), not real clients.
"""

import datetime
import io
import os
import tempfile
import unittest

import bcpweblog as b

# The three field lists seen on the servers (SPEC 3.3).
F_DSA = ('#Fields: date time s-sitename s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip '
         'cs(User-Agent) cs(Referer) sc-status sc-bytes cs-bytes time-taken XForwardedFor')
F_WWW01 = ('#Fields: date time s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs(User-Agent) '
           'cs(Referer) sc-status sc-substatus sc-win32-status time-taken XForwardedFor')
F_WWW02 = ('#Fields: date time s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs(User-Agent) '
           'cs(Referer) sc-status sc-substatus sc-win32-status sc-bytes cs-bytes time-taken XForwardedFor')

LB = '198.51.100.10'        # stands in for the load balancer
CLIENT = '203.0.113.7'
PROXY = '192.0.2.200'


def www02(xff='-', query='-', status='200', sc='5120', cs='432', taken='15', date='2026-10-27'):
    return ' '.join([date, '13:45:07', '192.0.2.1', 'GET', '/dr20/en/tools/chart/navi.aspx', query, '443', '-',
                     LB, 'Mozilla/5.0+(Windows+NT+10.0)', 'https://example.org/', status, '0', '0',
                     sc, cs, taken, xff])


def row_dict(row):
    return dict(zip(b.COLUMNS, row))


class NameDates(unittest.TestCase):
    def test_daily(self):
        d = datetime.date(2026, 10, 28)
        self.assertEqual(b.name_dates('u_ex261028_x.log'), (d, d))
        self.assertEqual(b.name_dates('ex261028_x.log'), (d, d))
        self.assertEqual(b.name_dates('u_ex261028.log'), (d, d))

    def test_monthly_covers_whole_month(self):
        self.assertEqual(b.name_dates('u_ex2610_x.log'), (datetime.date(2026, 10, 1), datetime.date(2026, 10, 31)))
        self.assertEqual(b.name_dates('u_ex2612_x.log'), (datetime.date(2026, 12, 1), datetime.date(2026, 12, 31)))
        self.assertEqual(b.name_dates('u_ex2802.log'), (datetime.date(2028, 2, 1), datetime.date(2028, 2, 29)))

    def test_not_log_names(self):
        for n in ('rejectedBcpRecords.txt', 'u_ex261028_x.log.bak', 'ex26102.log', 'u_ex261332.log', 'httperr1.log'):
            self.assertIsNone(b.name_dates(n), n)


class Convert(unittest.TestCase):
    fm02 = b.FieldMap(F_WWW02)

    def test_columns_by_name(self):
        r = row_dict(b.convert(www02(), self.fm02, 7, 99))
        self.assertEqual((r['logID'], r['YY'], r['MM'], r['DD'], r['Seq'], r['Second']),
                         ('7', '2026', '10', '27', '99', '13:45:07'))
        self.assertEqual(r['op'], 'GET')
        self.assertEqual(r['error'], '200')
        self.assertEqual(r['browser'], 'Mozilla/5.0+(Windows+NT+10.0)')
        self.assertEqual(r['referer'], 'https://example.org/')

    def test_bytes_in_is_cs_bytes(self):
        # The old exe wrote sc-bytes into both columns.
        r = row_dict(b.convert(www02(sc='5120', cs='432'), self.fm02, 0, 0))
        self.assertEqual((r['bytesOut'], r['bytesIn'], r['elapsed']), ('5120', '432', '15'))

    def test_missing_fields_load_defaults(self):
        line = www02().split(' ')
        del line[14:16]                         # drop sc-bytes, cs-bytes -> the idieswww01 list
        r = row_dict(b.convert(' '.join(line), b.FieldMap(F_WWW01), 0, 0))
        self.assertEqual((r['bytesOut'], r['bytesIn'], r['elapsed']), ('', '', '15'))

    def test_query_appended_only_when_present(self):
        self.assertEqual(row_dict(b.convert(www02(), self.fm02, 0, 0))['command'],
                         '/dr20/en/tools/chart/navi.aspx')
        self.assertEqual(row_dict(b.convert(www02(query='ra=10&dec=2'), self.fm02, 0, 0))['command'],
                         '/dr20/en/tools/chart/navi.aspx?ra=10&dec=2')

    def test_command_cut_to_255(self):
        r = row_dict(b.convert(www02(query='q=' + 'x' * 1000), self.fm02, 0, 0))
        self.assertEqual(len(r['command']), 255)

    def test_client_ip_from_xff(self):
        cases = {'-': LB,
                 CLIENT: CLIENT,
                 CLIENT + ':51234': CLIENT,
                 CLIENT + ',+' + PROXY + ':40000': CLIENT,
                 '2001:db8::1': '2001:db8::1'}
        for xff, want in cases.items():
            self.assertEqual(row_dict(b.convert(www02(xff=xff), self.fm02, 0, 0))['clientIP'], want, xff)

    def test_old_format_dsa(self):
        line = ' '.join(['2026-10-27', '00:00:01', 'W3SVC1858982642', '192.0.2.1', 'GET', '/', '-', '80', '-',
                         LB, '-', '-', '200', '1024', '150', '0', '-'])
        r = row_dict(b.convert(line, b.FieldMap(F_DSA), 4, 0))
        self.assertEqual((r['command'], r['clientIP'], r['bytesOut'], r['bytesIn'], r['browser']),
                         ('/', LB, '1024', '150', ''))

    def test_non_numeric_is_default(self):
        r = row_dict(b.convert(www02(sc='-', taken='abc'), self.fm02, 0, 0))
        self.assertEqual((r['bytesOut'], r['elapsed']), ('', ''))

    def test_rejects(self):
        cases = [(www02() + ' extra', 'field count'),
                 (www02(date='27/10/2026'), 'bad date'),
                 (www02(query='q=' + 'x' * 8000), 'line too long')]
        for line, reason in cases:
            with self.assertRaises(b.Reject) as cm:
                b.convert(line, self.fm02, 0, 0)
            self.assertEqual(str(cm.exception), reason)
        with self.assertRaises(b.Reject):
            b.convert(www02(), None, 0, 0)


class Files(unittest.TestCase):
    def write(self, text):
        fd, path = tempfile.mkstemp(suffix='.log')
        with os.fdopen(fd, 'wb') as f:
            f.write(text.encode('utf-8'))
        self.addCleanup(os.remove, path)
        return path

    def parse(self, path, **kw):
        out, rej = io.BytesIO(), io.StringIO()
        r = b.parse_file(path, 1, out, rej, **kw)
        return r, out.getvalue().decode('utf-8').splitlines()

    def test_header_midfile_and_partial_last_line(self):
        text = ('#Software: IIS\r\n#Fields: ' + F_WWW02[9:] + '\r\n' + www02() + '\r\n'
                + '#Fields: ' + F_WWW01[9:] + '\r\n'
                + ' '.join(www02().split(' ')[:14] + www02().split(' ')[16:]) + '\r\n'
                + www02()[:40])                                   # half-written last line
        path = self.write(text)
        r, rows = self.parse(path)
        self.assertEqual(r.rows, 2)
        self.assertEqual(len(r.fields_seen), 2)
        self.assertEqual(r.next_offset, len(text.encode()) - 40)   # stops before the partial line
        self.assertEqual(rows[1].split('\t')[12], '')               # second row: no sc-bytes

    def test_resume_from_offset_gives_same_rows(self):
        lines = [www02(query='n=%d' % i) for i in range(5)]
        head = '#Fields: ' + F_WWW02[9:] + '\r\n'
        path = self.write(head + ''.join(l + '\r\n' for l in lines))
        r_all, rows_all = self.parse(path)
        cut = len(head) + 2 * (len(lines[0]) + 2)
        r_b, rows_b = self.parse(path, offset=cut, fields_line=F_WWW02)
        self.assertEqual(rows_all[2:], rows_b)                     # same rows, same Seq (byte offsets)
        self.assertEqual(r_b.next_offset, r_all.next_offset)

    def test_no_bom_and_tabs(self):
        path = self.write('#Fields: ' + F_WWW02[9:] + '\n' + www02() + '\n')
        out, rej = io.BytesIO(), io.StringIO()
        b.parse_file(path, 1, out, rej)
        data = out.getvalue()
        self.assertFalse(data.startswith(b'\xef\xbb\xbf'))
        self.assertEqual(data.count(b'\t'), len(b.COLUMNS) - 1)


if __name__ == '__main__':
    unittest.main()
