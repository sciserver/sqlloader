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


def www02(xff='-', query='-', status='200', sc='5120', cs='432', taken='15', date='2026-10-27', tod='13:45:07'):
    return ' '.join([date, tod,'192.0.2.1', 'GET', '/dr20/en/tools/chart/navi.aspx', query, '443', '-',
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
                 (www02(date='2026-02-30'), 'bad date'),     # right shape, not a day: would fail the load
                 (www02(tod='10:61:99'), 'bad time'),
                 (www02(tod='24:00:00'), 'bad time'),
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
        r = b.parse_file(path, 1, b.file_sink(out), rej, **kw)
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
        r_b, rows_b = self.parse(path, offset=cut, fields=F_WWW02[9:])
        self.assertEqual(rows_all[2:], rows_b)                     # same rows, same Seq (byte offsets)
        self.assertEqual(r_b.next_offset, r_all.next_offset)

    def test_max_bytes_runs_add_up_to_one_pass(self):
        # The per-run cap: several capped runs, each resuming at the last offset, give the same rows.
        lines = [www02(query='n=%d' % i) for i in range(20)]
        path = self.write('#Fields: ' + F_WWW02[9:] + '\r\n' + ''.join(l + '\r\n' for l in lines))
        r_all, rows_all = self.parse(path)
        rows, offset, fields = [], 0, None
        while True:
            r, part = self.parse(path, offset=offset, fields=fields, max_bytes=500)
            if r.next_offset == offset:
                break
            rows += part
            offset, fields = r.next_offset, r.fields_at_end
        self.assertEqual(rows, rows_all)
        self.assertEqual(offset, r_all.next_offset)

    def test_no_bom_and_tabs(self):
        path = self.write('#Fields: ' + F_WWW02[9:] + '\n' + www02() + '\n')
        out, rej = io.BytesIO(), io.StringIO()
        b.parse_file(path, 1, b.file_sink(out), rej)
        data = out.getvalue()
        self.assertFalse(data.startswith(b'\xef\xbb\xbf'))
        self.assertEqual(data.count(b'\t'), len(b.COLUMNS) - 1)


class PlanIncremental(unittest.TestCase):
    TODAY = datetime.date(2026, 10, 28)

    def plan(self, sizes, state, days=2):
        first = self.TODAY - datetime.timedelta(days=days - 1)
        return b.plan_incremental(list(sizes), state, first, self.TODAY, sizes.__getitem__)

    def test_window_and_offsets(self):
        sizes = {'u_ex261026_x.log': 900,           # before the window: never opened
                 'u_ex261027_x.log': 500,           # finished: offset == size
                 'u_ex261028_x.log': 300}           # growing
        state = {'u_ex261027_x.log': (500, 'f'), 'u_ex261028_x.log': (100, 'f')}
        reads, warnings = self.plan(sizes, state)
        self.assertEqual([(r.name, r.offset, r.fields) for r in reads], [('u_ex261028_x.log', 100, 'f')])
        self.assertEqual(warnings, [])

    def test_new_file_from_zero_and_monthly(self):
        reads, _ = self.plan({'u_ex2610_x.log': 10 ** 10, 'u_ex261028_x.log': 50}, {})
        self.assertEqual([(r.name, r.offset, r.file_date) for r in reads],
                         [('u_ex2610_x.log', 0, datetime.date(2026, 10, 1)),
                          ('u_ex261028_x.log', 0, datetime.date(2026, 10, 28))])

    def test_last_months_file_still_read_on_the_1st(self):
        first = datetime.date(2026, 11, 1)
        reads, _ = b.plan_incremental(['u_ex2610_x.log'], {'u_ex2610_x.log': (5, None)},
                                      first - datetime.timedelta(days=1), first, lambda n: 9)
        self.assertEqual(len(reads), 1)

    def test_shrunk_file_is_reread_with_warning(self):
        reads, warnings = self.plan({'u_ex261028_x.log': 50}, {'u_ex261028_x.log': (400, 'f')})
        self.assertEqual((reads[0].offset, reads[0].fields), (0, None))
        self.assertEqual(len(warnings), 1)


class Backfill(unittest.TestCase):
    """DayLoader routing, in dry-run mode (no database): days, outside rows, STOP."""

    def row(self, date, tod):
        return b.convert(www02(date=date, tod=tod), b.FieldMap(F_WWW02), 3002, 0)

    def test_days_close_and_stop(self):
        work = tempfile.mkdtemp()
        msgs = []
        d = b.DayLoader(None, work, 3002, datetime.date(2026, 10, 26), datetime.date(2026, 10, 27), True, msgs.append)
        feed = [('2026-10-25', '23:59:50'),         # outside (head of file 26)
                ('2026-10-26', '00:00:01'), ('2026-10-26', '23:59:59'),
                ('2026-10-26', '23:59:58'),         # head of file 27: still day 26
                ('2026-10-27', '00:03:00'),         # within the slack: 26 stays open
                ('2026-10-27', '00:06:00'),         # past 27 00:05 -> 26 is complete and loaded
                ('2026-10-27', '23:59:59'),
                ('2026-10-28', '00:01:00'),         # head of file 28: outside, within the slack
                ('2026-10-28', '00:06:00')]         # past --to + slack: stop reading
        results = [d.sink(self.row(*x)) for x in feed]
        self.assertIs(results[-1], b.STOP)
        self.assertNotIn(b.STOP, results[:-1])
        self.assertEqual([x[0].day for x in d.loaded], [26])
        d.finish()
        self.assertEqual([(x[0].day, x[1]) for x in d.loaded], [(26, 3), (27, 3)])
        self.assertEqual((d.outside, d.late), (2, 0))

    def test_late_row_is_counted(self):
        d = b.DayLoader(None, tempfile.mkdtemp(), 1, datetime.date(2026, 10, 26), datetime.date(2026, 10, 28),
                        True, lambda m: None)
        for x in [('2026-10-26', '10:00:00'), ('2026-10-27', '00:10:00'), ('2026-10-26', '10:00:01')]:
            d.sink(self.row(*x))
        d.finish()
        self.assertEqual(d.late, 1)


class FakeDb:
    def __init__(self, status=None, fail=False):
        self.status, self.fail, self.asked = status or {}, fail, None

    def run_status(self, run_ids):
        if self.fail:
            raise b.LoadError('sqlcmd failed')
        self.asked = run_ids
        return {r: s for r, s in self.status.items() if r in run_ids}


class CleanWorkdir(unittest.TestCase):
    NOW = 1800000000                # 2027-01-15 08:00 UTC
    OLD = NOW - 31 * 86400
    NEW = NOW - 3600

    def make(self, files, empty=()):
        """files: {name: mtime}, all one byte long except the names in empty; returns the workdir."""
        work = tempfile.mkdtemp()
        for name, mtime in files.items():
            path = os.path.join(work, name)
            with open(path, 'w') as f:
                f.write('' if name in empty else 'x')
            os.utime(path, (mtime, mtime))
        return work

    def clean(self, work, db):
        msgs = []
        b.clean_workdir(db, work, msgs.append, 30, now=self.NOW)
        return sorted(os.listdir(work)), msgs

    def test_load_files_go_when_run_is_not_started(self):
        work = self.make({'run1.weblog.bcp': self.NEW, 'run1.state.bcp': self.NEW,     # loaded
                          'run2.weblog.bcp': self.NEW,                                  # failed
                          'run3.weblog.bcp': self.OLD,                                  # abandoned
                          'run4.weblog.bcp': self.NEW, 'run4.state.bcp': self.OLD,     # started: another run
                          'backfill_3002_2026-10-26_run5.weblog.bcp': self.NEW,         # started: a backfill
                          'backfill_3002_2026-10-25_run6.weblog.bcp': self.NEW})        # loaded
        db = FakeDb({1: 'loaded', 2: 'failed', 3: 'abandoned', 4: 'started', 5: 'started', 6: 'loaded'})
        left, msgs = self.clean(work, db)
        self.assertEqual(left, ['backfill_3002_2026-10-26_run5.weblog.bcp', 'run4.state.bcp', 'run4.weblog.bcp'])
        self.assertEqual(db.asked, [1, 2, 3, 4, 5, 6])
        self.assertIn('removed 5 old files', msgs[0])

    def test_small_files_and_unknown_runs_go_by_age(self):
        work = self.make({'run2.weblog.bcp.err': self.NEW, 'run2.rejects.txt': self.NEW,
                          'run1.weblog.bcp.err': self.OLD, 'run1.rejects.txt': self.OLD,
                          'backfill_20261028_213000.rejects.txt': self.OLD,
                          'dryrun_20261028_213000.weblog.bcp': self.OLD,
                          'dryrun_20261201_100000.weblog.bcp': self.NEW,
                          'run9.weblog.bcp': self.NEW,                  # not in LoadRun (another database?)
                          'run8.weblog.bcp': self.OLD,
                          'notes.txt': self.OLD, 'u_ex261027_x.log': self.OLD})     # not ours: never touched
        left, _ = self.clean(work, FakeDb({1: 'failed', 2: 'failed'}))
        self.assertEqual(left, ['dryrun_20261201_100000.weblog.bcp', 'notes.txt', 'run2.rejects.txt',
                                'run2.weblog.bcp.err', 'run9.weblog.bcp', 'u_ex261027_x.log'])

    def test_log_trimmed_with_multiline_messages(self):
        work = tempfile.mkdtemp()
        path = os.path.join(work, 'bcpweblog.log')
        with open(path, 'w', encoding='utf-8') as f:
            f.write('2026-12-01 10:00:00 FAILED run1: bcp error\nSQLState = S1000\n'
                    '2027-01-14 10:00:00 loaded run2\n2027-01-15 07:00:00 FAILED run3: x\nsecond line\n')
        self.clean(work, FakeDb())
        with open(path, encoding='utf-8') as f:
            self.assertEqual(f.read(), '2027-01-14 10:00:00 loaded run2\n2027-01-15 07:00:00 FAILED run3: x\nsecond line\n')

    def test_database_error_never_fails_and_removes_nothing(self):
        work = self.make({'run1.weblog.bcp': self.OLD})
        left, msgs = self.clean(work, FakeDb(fail=True))
        self.assertEqual(left, ['run1.weblog.bcp'])
        self.assertIn('cleanup skipped', msgs[0])

    def test_empty_small_files_go_when_run_is_done(self):
        files = {'run1.rejects.txt': self.NEW, 'run1.weblog.bcp.err': self.NEW,      # failed, empty: go
                 'run2.weblog.bcp.err': self.NEW,                                    # failed, has rows: stays
                 'run3.rejects.txt': self.NEW,                                       # started, empty: stays
                 'run9.rejects.txt': self.NEW}                                       # unknown, empty: stays
        work = self.make(files, empty={'run1.rejects.txt', 'run1.weblog.bcp.err', 'run3.rejects.txt',
                                       'run9.rejects.txt'})
        left, _ = self.clean(work, FakeDb({1: 'failed', 2: 'failed', 3: 'started'}))
        self.assertEqual(left, ['run2.weblog.bcp.err', 'run3.rejects.txt', 'run9.rejects.txt'])

    def test_remove_quietly_when_already_gone(self):
        b.remove_quietly(os.path.join(tempfile.mkdtemp(), 'run1.weblog.bcp'))


if __name__ == '__main__':
    unittest.main()
