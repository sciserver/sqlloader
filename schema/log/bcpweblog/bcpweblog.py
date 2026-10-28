"""bcpweblog: load IIS W3C web logs into weblog.dbo.weblogAll.

Replacement for BcpWeblogNew.exe. See SPEC.md in this folder.
Standard library only; loading (later) goes through bcp.exe and sqlcmd.exe.

This version has the parser and a dry run:

    python bcpweblog.py parse <logfile> [<logfile> ...] --out <dir> [--logid N] [--offset BYTES]

which writes <dir>/<file>.bcp (what would be loaded), <dir>/<file>.rejects.txt and prints a summary.
"""

import argparse
import collections
import datetime
import os
import re
import sys
import time

# ---------------------------------------------------------------------------------------------
# File names (SPEC 3.1)
# ---------------------------------------------------------------------------------------------

LOG_NAME = re.compile(r'^(u_)?ex(\d{6}|\d{4})(_x)?\.log$', re.IGNORECASE)


def name_dates(name):
    """Return (first_date, last_date) a log file name covers, or None if it isn't a log file name.

    Daily names (yymmdd) cover that day; monthly names (yymm) cover the whole month.
    """
    m = LOG_NAME.match(name)
    if not m:
        return None
    digits = m.group(2)
    year, month = 2000 + int(digits[0:2]), int(digits[2:4])
    try:
        if len(digits) == 6:
            day = datetime.date(year, month, int(digits[4:6]))
            return day, day
        first = datetime.date(year, month, 1)
    except ValueError:
        return None
    next_month = datetime.date(year + month // 12, month % 12 + 1, 1)
    return first, next_month - datetime.timedelta(days=1)


# ---------------------------------------------------------------------------------------------
# Lines -> rows (SPEC 4.5)
# ---------------------------------------------------------------------------------------------

# Output columns, in load order: logID first, then weblogTemp's columns.
COLUMNS = ('logID', 'YY', 'MM', 'DD', 'Seq', 'Second', 'clientIP', 'op', 'command',
           'error', 'browser', 'referer', 'bytesOut', 'bytesIn', 'elapsed')

MAX_LINE = 8000         # longer lines are rejected, as in the old exe
MAX_OP = 8              # weblogTemp.op char(8)
MAX_COMMAND = 255       # the old exe's cut (SPEC 7, decided); the column holds 7000
MAX_CLIENTIP = 256
MAX_BROWSER = 2000
MAX_REFERER = 500
INT_MAX = 2 ** 31 - 1   # bytesIn, error, elapsed are int

DATE = re.compile(r'^\d{4}-\d{2}-\d{2}$')
TIME = re.compile(r'^\d{2}:\d{2}:\d{2}$')
IPV4_PORT = re.compile(r'^(\d{1,3}(?:\.\d{1,3}){3}):\d+$')
DIGITS = re.compile(r'^\d+$')


class Reject(Exception):
    """A data line that can't be loaded; the message is the reason (used as a counter key)."""


def clean(value, limit):
    """IIS writes '-' for empty. Tabs and line breaks would break the load file."""
    if value == '-':
        return ''
    if '\t' in value or '\r' in value or '\n' in value:
        value = value.replace('\t', ' ').replace('\r', ' ').replace('\n', ' ')
    return value[:limit]


def number(value, limit=None):
    """A non-negative integer field, or '' (column default) if missing, not a number, or too big."""
    if not DIGITS.match(value):
        return ''
    if limit is not None and int(value) > limit:
        return ''
    return value


def client_ip(xff, c_ip):
    """First XForwardedFor entry without :port (SPEC 4.5); c-ip if there's none."""
    if xff and xff != '-':
        first = xff.split(',', 1)[0].strip().strip('+')
        m = IPV4_PORT.match(first)
        if m:
            first = m.group(1)
        if first:
            return first[:MAX_CLIENTIP]
    return clean(c_ip or '', MAX_CLIENTIP)


class FieldMap:
    """Positions of the fields named in a '#Fields:' line."""

    def __init__(self, fields_line):
        names = fields_line.split(':', 1)[1].split()
        self.text = ' '.join(names)
        self.count = len(names)
        pos = {n.lower(): i for i, n in enumerate(names)}
        self.date = pos.get('date')
        self.time = pos.get('time')
        self.c_ip = pos.get('c-ip')
        self.xff = pos.get('xforwardedfor')
        self.method = pos.get('cs-method')
        self.stem = pos.get('cs-uri-stem')
        self.query = pos.get('cs-uri-query')
        self.status = pos.get('sc-status')
        self.agent = pos.get('cs(user-agent)')
        self.referer = pos.get('cs(referer)')
        self.sc_bytes = pos.get('sc-bytes')
        self.cs_bytes = pos.get('cs-bytes')
        self.time_taken = pos.get('time-taken')


def field(parts, i):
    return parts[i] if i is not None else ''


def convert(line, fm, log_id, seq):
    """One data line -> one output row (a tuple of strings in COLUMNS order). Raises Reject."""
    if fm is None:
        raise Reject('no #Fields before data')
    if len(line) >= MAX_LINE:
        raise Reject('line too long')
    parts = line.split(' ')
    if len(parts) != fm.count:
        raise Reject('field count')
    date = field(parts, fm.date)
    if not DATE.match(date):
        raise Reject('bad date')
    tod = field(parts, fm.time)
    if not TIME.match(tod):
        raise Reject('bad time')

    command = field(parts, fm.stem)
    query = field(parts, fm.query)
    if query and query != '-':
        command = command + '?' + query

    return (
        str(log_id),
        date[0:4], str(int(date[5:7])), str(int(date[8:10])),
        str(seq),
        tod,
        client_ip(field(parts, fm.xff), field(parts, fm.c_ip)),
        clean(field(parts, fm.method), MAX_OP),
        clean(command, MAX_COMMAND),
        number(field(parts, fm.status), INT_MAX),
        clean(field(parts, fm.agent), MAX_BROWSER),
        clean(field(parts, fm.referer), MAX_REFERER),
        number(field(parts, fm.sc_bytes)),
        number(field(parts, fm.cs_bytes), INT_MAX),
        number(field(parts, fm.time_taken), INT_MAX),
    )


# ---------------------------------------------------------------------------------------------
# Reading (SPEC 3.4, 4.3)
# ---------------------------------------------------------------------------------------------

CHUNK = 8 * 1024 * 1024


def complete_lines(f, offset, end):
    """Yield (line_offset, line_bytes) for each complete line between offset and end.

    A last line without '\\n' is left for the next run. The caller's next offset is the offset of the
    last line yielded plus its length plus one.
    """
    f.seek(offset)
    pos = offset
    tail = b''
    while pos < end:
        chunk = f.read(min(CHUNK, end - pos))
        if not chunk:
            break
        pos += len(chunk)
        buf = tail + chunk
        start = 0
        base = pos - len(buf)
        while True:
            nl = buf.find(b'\n', start)
            if nl < 0:
                break
            yield base + start, buf[start:nl]
            start = nl + 1
        tail = buf[start:]


class FileResult:
    def __init__(self):
        self.bytes_read = 0
        self.lines = 0
        self.header_lines = 0
        self.rows = 0
        self.rejects = collections.Counter()
        self.rows_per_day = collections.Counter()
        self.fields_seen = []
        self.next_offset = 0
        self.fields_at_end = None


def parse_file(path, log_id, out, rejects_out, offset=0, fields_line=None):
    """Parse one log file from offset to its current end; write rows to out (a binary file)."""
    r = FileResult()
    fm = FieldMap(fields_line) if fields_line else None
    with open(path, 'rb') as f:
        end = os.fstat(f.fileno()).st_size      # real size from the open handle, not the listing
        r.next_offset = offset
        for line_offset, raw in complete_lines(f, offset, end):
            r.next_offset = line_offset + len(raw) + 1
            r.lines += 1
            line = raw.rstrip(b'\r').decode('utf-8', errors='replace')
            if line.startswith('#'):
                r.header_lines += 1
                if line.startswith('#Fields:'):
                    fm = FieldMap(line)
                    if fm.text not in r.fields_seen:
                        r.fields_seen.append(fm.text)
                continue
            if not line.strip():
                continue
            try:
                row = convert(line, fm, log_id, line_offset)
            except Reject as e:
                r.rejects[str(e)] += 1
                rejects_out.write('%s\t%d\t%s\t%s\n' % (path, line_offset, e, line[:500]))
                continue
            out.write(('\t'.join(row) + '\n').encode('utf-8'))
            r.rows += 1
            r.rows_per_day['%s-%02d-%02d' % (row[1], int(row[2]), int(row[3]))] += 1
        r.bytes_read = r.next_offset - offset
    r.fields_at_end = fm.text if fm else None
    return r


# ---------------------------------------------------------------------------------------------
# Command line
# ---------------------------------------------------------------------------------------------

def cmd_parse(args):
    os.makedirs(args.out, exist_ok=True)
    for path in args.files:
        base = os.path.join(args.out, os.path.basename(path))
        started = time.monotonic()
        with open(base + '.bcp', 'wb') as out, \
                open(base + '.rejects.txt', 'w', encoding='utf-8') as rej:
            r = parse_file(path, args.logid, out, rej, offset=args.offset)
        secs = time.monotonic() - started
        mb = r.bytes_read / 1e6
        print('== %s' % path)
        print('   name covers   : %s' % (name_dates(os.path.basename(path)) or 'not a log file name',))
        print('   read          : %.1f MB in %.1f s (%.1f MB/s)' % (mb, secs, mb / secs if secs else 0))
        print('   lines         : %d (%d header)' % (r.lines, r.header_lines))
        print('   rows          : %d' % r.rows)
        print('   rejects       : %s' % (dict(r.rejects) or 0))
        print('   next offset   : %d' % r.next_offset)
        for f in r.fields_seen:
            print('   #Fields       : %s' % f)
        for day in sorted(r.rows_per_day):
            print('   rows %s : %d' % (day, r.rows_per_day[day]))
    return 0


def main(argv=None):
    p = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    sub = p.add_subparsers(dest='command', required=True)
    pp = sub.add_parser('parse', help='dry run: parse log files into load files, load nothing')
    pp.add_argument('files', nargs='+')
    pp.add_argument('--out', required=True, help='folder for the .bcp and .rejects.txt files')
    pp.add_argument('--logid', type=int, default=0)
    pp.add_argument('--offset', type=int, default=0, help='start at this byte offset (a line start)')
    pp.set_defaults(func=cmd_parse)
    args = p.parse_args(argv)
    return args.func(args)


if __name__ == '__main__':
    sys.exit(main())
