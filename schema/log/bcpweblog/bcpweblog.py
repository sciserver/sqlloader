"""bcpweblog: load IIS W3C web logs into weblog.dbo.weblogAll.

Replacement for BcpWeblogNew.exe. See SPEC.md in this folder.
Standard library only; loading goes through bcp.exe and sqlcmd.exe (Windows auth).

    python bcpweblog.py incremental [--logid N ...] [--dry-run]     (hourly)
    python bcpweblog.py backfill --logid N --from yyyy-mm-dd --to yyyy-mm-dd
    python bcpweblog.py parse <logfile> ... --out <dir>             (parser check, no database)

Common options: --server (localhost), --database (weblog), --workdir (load files, rejects, run log).
Exit code 0 = loaded (warnings are printed), 1 = failed, nothing committed for the failing run.
"""

import argparse
import collections
import datetime
import os
import re
import subprocess
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
    # Checked strictly here: spLoadWeblogStage loads a run all-or-nothing, so one row the database
    # can't turn into a datetime would fail that source's run every hour, on the same bytes.
    date = field(parts, fm.date)
    if not DATE.match(date):
        raise Reject('bad date')
    try:
        datetime.date(int(date[0:4]), int(date[5:7]), int(date[8:10]))
    except ValueError:
        raise Reject('bad date')
    tod = field(parts, fm.time)
    if not TIME.match(tod) or int(tod[0:2]) > 23 or int(tod[3:5]) > 59 or int(tod[6:8]) > 59:
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
        self.stopped = False


def row_date(row):
    return datetime.date(int(row[1]), int(row[2]), int(row[3]))


STOP = object()     # a sink returns this to stop reading the file (backfill past --to)


def file_sink(out):
    """A sink that writes rows to a binary file, prefixed with prefix (e.g. the runID)."""
    def sink(row, prefix=''):
        out.write((prefix + '\t'.join(row) + '\n').encode('utf-8'))
    return sink


def parse_file(path, log_id, sink, rejects_out, offset=0, fields=None, max_bytes=None):
    """Parse one log file from offset to its current end (or offset + max_bytes); pass each row to sink.

    fields is the '#Fields' list in effect at offset (LogFileState.fields), without the '#Fields:' prefix.
    sink(row) may return STOP; next_offset is then the start of the line that wasn't used.
    """
    r = FileResult()
    fm = FieldMap('#Fields: ' + fields) if fields else None
    with open(path, 'rb') as f:
        end = os.fstat(f.fileno()).st_size      # real size from the open handle, not the listing
        if max_bytes is not None:
            end = min(end, offset + max_bytes)
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
            if sink(row) is STOP:
                r.next_offset = line_offset
                r.stopped = True
                break
            r.rows += 1
            r.rows_per_day[row_date(row).isoformat()] += 1
        r.bytes_read = r.next_offset - offset
    r.fields_at_end = fm.text if fm else None
    return r


# ---------------------------------------------------------------------------------------------
# Database: sqlcmd and bcp (SPEC 4.6)
# ---------------------------------------------------------------------------------------------

class LoadError(Exception):
    pass


def sql_str(s):
    return "'" + s.replace("'", "''") + "'"


class Db:
    def __init__(self, server, database):
        self.server = server
        self.database = database

    def query(self, sql):
        """Run sql; return the result rows as lists of strings (tab-separated output, no headers)."""
        cmd = ['sqlcmd', '-S', self.server, '-d', self.database, '-E', '-C', '-b', '-r1', '-h', '-1', '-W',
               '-s', '\t', '-f', '65001', '-Q', 'SET NOCOUNT ON; ' + sql]
        p = subprocess.run(cmd, capture_output=True, encoding='utf-8', errors='replace')
        if p.returncode != 0:
            raise LoadError('sqlcmd failed (exit %d): %s' % (p.returncode, (p.stderr or p.stdout).strip()[:2000]))
        return [line.split('\t') for line in p.stdout.splitlines() if line.strip()]

    def bcp_in(self, table, path, expected):
        """bcp a load file into a staging table; fail unless exactly expected rows arrived."""
        cmd = ['bcp', '%s.dbo.%s' % (self.database, table), 'in', path, '-S', self.server, '-T',
               '-c', '-C', '65001', '-t', '\\t', '-r', '0x0a', '-b', '500000', '-m', '1', '-e', path + '.err']
        p = subprocess.run(cmd, capture_output=True, encoding='utf-8', errors='replace')
        m = re.search(r'^(\d+) rows copied', p.stdout, re.MULTILINE)
        copied = int(m.group(1)) if m else -1
        if p.returncode != 0 or copied != expected:
            raise LoadError('bcp into %s: %d of %d rows (exit %d): %s'
                            % (table, copied, expected, p.returncode, (p.stdout + p.stderr).strip()[-2000:]))
        remove_if_empty(path + '.err')

    def sources(self, method, log_ids=None):
        """[(logID, pathname)] of the active sources read by this loader."""
        sql = ("SELECT logID, pathname FROM dbo.LogSource WHERE method = %s AND status = 'ACTIVE' AND isvisible = 1"
               % sql_str(method))
        if log_ids:
            sql += ' AND logID IN (%s)' % ','.join(str(int(i)) for i in log_ids)
        return [(int(r[0]), r[1]) for r in self.query(sql + ' ORDER BY logID')]

    def file_state(self, log_ids):
        """{logID: {fileName: (byteOffset, fields or None)}}"""
        state = collections.defaultdict(dict)
        if log_ids:
            for r in self.query("SELECT logID, fileName, byteOffset, ISNULL(fields, '') FROM dbo.LogFileState "
                                "WHERE logID IN (%s)" % ','.join(str(i) for i in log_ids)):
                state[int(r[0])][r[1]] = (int(r[2]), r[3] or None)
        return state

    def first_state_date(self, log_id):
        """The earliest fileDate incremental has state for (backfill must stay before it), or None."""
        rows = self.query('SELECT CONVERT(char(10), MIN(fileDate), 23) FROM dbo.LogFileState WHERE logID = %d'
                          % log_id)
        value = rows[0][0] if rows else 'NULL'
        return None if value == 'NULL' else datetime.date.fromisoformat(value)

    def start_run(self, mode):
        return int(self.query('EXEC dbo.spStartWeblogRun %s' % sql_str(mode))[0][0])

    def load_run(self, run_id, replace_from=None, replace_to=None):
        """spLoadWeblogStage; returns (files, rows, deleted)."""
        sql = 'EXEC dbo.spLoadWeblogStage %d' % run_id
        if replace_from:
            sql += ", '%s', '%s'" % (replace_from.isoformat(), replace_to.isoformat())
        r = self.query(sql)[0]
        return int(r[1]), int(r[2]), int(r[3])

    def abort_run(self, run_id, message):
        self.query('EXEC dbo.spAbortWeblogRun %d, %s' % (run_id, sql_str(message[:2000])))

    def run_status(self, run_ids):
        """{runID: status} for the runIDs LoadRun has."""
        status = {}
        for i in range(0, len(run_ids), 500):
            ids = ','.join(str(int(r)) for r in run_ids[i:i + 500])
            for r in self.query('SELECT runID, status FROM dbo.LoadRun WHERE runID IN (%s)' % ids):
                status[int(r[0])] = r[1]
        return status


# ---------------------------------------------------------------------------------------------
# Which files are read (SPEC 4.4)
# ---------------------------------------------------------------------------------------------

Read = collections.namedtuple('Read', 'name offset fields file_date size')


def name_key(name):
    return name_dates(name)[0], name.lower()


def plan_incremental(names, state, first_day, last_day, size_of):
    """Pick the files to read and where to start.

    names: log file names in the folder; state: {fileName: (byteOffset, fields)};
    size_of(name): the real size. A file is read if the dates its name covers overlap first_day..last_day
    and it has bytes past its offset. Files outside the window are never opened.
    Returns (reads, warnings).
    """
    reads, warnings = [], []
    for name in sorted(names, key=name_key):
        first, last = name_dates(name)
        if last < first_day or first > last_day:
            continue
        size = size_of(name)
        offset, fields = state.get(name, (0, None))
        if size < offset:
            warnings.append('%s: size %d is below the stored offset %d (file replaced?); reading it from 0'
                            % (name, size, offset))
            offset, fields = 0, None
        if size > offset:
            reads.append(Read(name, offset, fields, first, size))
    return reads, warnings


def list_logs(folder):
    """(names of all files, names matching the log pattern). Raises OSError if the folder can't be listed."""
    names = [e.name for e in os.scandir(folder) if e.is_file()]
    return names, [n for n in names if name_dates(n)]


# ---------------------------------------------------------------------------------------------
# Modes
# ---------------------------------------------------------------------------------------------

def utc_today():
    return datetime.datetime.now(datetime.timezone.utc).date()


class RunLog:
    """Prints to stdout (the job history) and appends to <workdir>/bcpweblog.log."""

    def __init__(self, workdir):
        self.path = os.path.join(workdir, 'bcpweblog.log')

    def __call__(self, msg):
        line = '%s %s' % (datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%d %H:%M:%S'), msg)
        print(line, flush=True)
        with open(self.path, 'a', encoding='utf-8') as f:
            f.write(line + '\n')


def remove_if_empty(path):
    if os.path.exists(path) and os.path.getsize(path) == 0:
        remove_quietly(path)


def remove_quietly(path):
    """Remove a file that may already be gone (another run's clean_workdir can get there first)."""
    try:
        os.remove(path)
    except FileNotFoundError:
        pass


# Files this loader writes to the workdir. Nothing else there is touched.
WORK_FILE = re.compile(r'^(?:run(\d+)|backfill_\d+_[\d-]+_run(\d+)|backfill_[\d_]+|dryrun_[\d_]+)'
                       r'\.(weblog\.bcp|state\.bcp|rejects\.txt)(\.err)?$')


def clean_workdir(db, workdir, log, keep_days, now=None):
    """Remove old files from the workdir (SPEC 4.9). Never fails the run: problems are logged.

    A load file (.weblog.bcp / .state.bcp) is removed once its run is no longer 'started' in LoadRun:
    loaded, failed, or abandoned by the 12 h sweep. It can be rebuilt with --dry-run, because a failed
    run doesn't move the offsets. So is an empty .err or rejects file (a killed run leaves them).
    Everything else (.err, rejects, dry-run files, load files of runs LoadRun doesn't know) is removed
    after keep_days, and bcpweblog.log is trimmed to keep_days. A 'started' run's files are never touched.
    runIDs belong to one database, so a workdir must serve only one database.
    """
    now = time.time() if now is None else now
    cutoff = now - keep_days * 86400
    try:
        found = []
        for name in os.listdir(workdir):
            m = WORK_FILE.match(name)
            if m:
                run_id = m.group(1) or m.group(2)
                is_load = m.group(3) != 'rejects.txt' and not m.group(4)
                found.append((name, int(run_id) if run_id else None, is_load))
        status = db.run_status(sorted({r for _, r, _ in found if r is not None}))
        removed = size = 0
        for name, run_id, is_load in found:
            path = os.path.join(workdir, name)
            st = os.stat(path)
            if status.get(run_id) == 'started':
                continue
            run_done = run_id in status
            if (run_done and (is_load or st.st_size == 0)) or st.st_mtime < cutoff:
                try:
                    os.remove(path)
                except FileNotFoundError:
                    continue
                except OSError as e:
                    log('  WARNING workdir: cannot remove %s (%s)' % (name, e.strerror or e))
                    continue
                removed += 1
                size += st.st_size
        if removed:
            log('workdir: removed %d old files, %.1f MB' % (removed, size / 1e6))
        trim_log(os.path.join(workdir, 'bcpweblog.log'), cutoff)
    except Exception as e:      # noqa: BLE001 - housekeeping must not stop the load
        log('  WARNING workdir cleanup skipped: %s: %s' % (type(e).__name__, e))


def trim_log(path, cutoff):
    """Drop bcpweblog.log lines older than cutoff (epoch seconds). Lines without a timestamp
    (a multi-line message) go with the line before them."""
    oldest = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(cutoff))
    if not os.path.exists(path):
        return
    with open(path, encoding='utf-8', errors='replace') as f:
        first = f.readline()
        if not first or first[:19] >= oldest:
            return
        f.seek(0)
        lines = f.readlines()
    kept, keep = [], False
    for line in lines:
        if re.match(r'\d{4}-\d\d-\d\d \d\d:\d\d:\d\d ', line):
            keep = line[:19] >= oldest
        if keep:
            kept.append(line)
    with open(path + '.tmp', 'w', encoding='utf-8') as f:
        f.writelines(kept)
    os.replace(path + '.tmp', path)


def cmd_incremental(args):
    os.makedirs(args.workdir, exist_ok=True)
    log = RunLog(args.workdir)
    db = Db(args.server, args.database)
    today = utc_today()
    first_day = today - datetime.timedelta(days=args.days - 1)

    sources = db.sources(args.method, args.logid)
    if not sources:
        log('incremental: no active %s sources%s; nothing to do' % (args.method, ' with those logIDs' if args.logid else ''))
        return 0
    state = db.file_state([s[0] for s in sources])
    if not args.dry_run:
        clean_workdir(db, args.workdir, log, args.keep_days)

    run_id = 0 if args.dry_run else db.start_run('incremental')
    tag = ('run%d' % run_id) if run_id else 'dryrun_' + time.strftime('%Y%m%d_%H%M%S')
    rows_path = os.path.join(args.workdir, tag + '.weblog.bcp')
    state_path = os.path.join(args.workdir, tag + '.state.bcp')
    rejects_path = os.path.join(args.workdir, tag + '.rejects.txt')
    log('incremental %s: %d sources, window %s..%s, max %d MB per file'
        % (tag, len(sources), first_day, today, args.max_bytes // 1000000))

    total_rows = total_states = total_rejects = 0
    try:
        with open(rows_path, 'wb') as out, open(state_path, 'wb') as st, \
                open(rejects_path, 'w', encoding='utf-8') as rej:
            write = file_sink(out)
            prefix = '%d\t' % run_id
            sink = lambda row: write(row, prefix)
            for log_id, folder in sources:
                started = time.monotonic()
                try:
                    listed, matched = list_logs(folder)
                except OSError as e:
                    log('  WARNING logID %d: cannot list %s (%s); skipped' % (log_id, folder, e.strerror or e))
                    continue
                stored = state.get(log_id, {})
                reads, warnings = plan_incremental(matched, stored, first_day, today,
                                                   lambda n: os.stat(os.path.join(folder, n)).st_size)
                for w in warnings:
                    log('  WARNING logID %d: %s' % (log_id, w))
                n_bytes = n_lines = n_rows = n_rej = 0
                for rd in reads:
                    r = parse_file(os.path.join(folder, rd.name), log_id, sink, rej,
                                   offset=rd.offset, fields=rd.fields, max_bytes=args.max_bytes)
                    if r.next_offset != stored.get(rd.name, (0, None))[0]:
                        st.write(('%d\t%d\t%s\t%d\t%s\t%s\n' % (run_id, log_id, rd.name, r.next_offset,
                                                                r.fields_at_end or '', rd.file_date)).encode('utf-8'))
                        total_states += 1
                    n_bytes += r.bytes_read
                    n_lines += r.lines
                    n_rows += r.rows
                    n_rej += sum(r.rejects.values())
                    if rd.offset + args.max_bytes < rd.size:
                        log('  logID %d: %s capped at %d of %d bytes; the next run continues'
                            % (log_id, rd.name, r.next_offset, rd.size))
                total_rows += n_rows
                total_rejects += n_rej
                log('  logID %d %s: listed %d, matched %d, read %d files, %.1f MB, %d lines, %d rows, %d rejects, %.1f s'
                    % (log_id, folder, len(listed), len(matched), len(reads), n_bytes / 1e6, n_lines, n_rows,
                       n_rej, time.monotonic() - started))

        if args.dry_run:
            log('dry run: %d rows, %d file offsets in %s (nothing loaded)' % (total_rows, total_states, rows_path))
            remove_if_empty(rejects_path)
            return 0
        if total_rows:
            db.bcp_in('weblogStage', rows_path, total_rows)
        if total_states:
            db.bcp_in('LogFileStateStage', state_path, total_states)
        files, rows, _ = db.load_run(run_id)
    except Exception as e:      # noqa: BLE001 - every failure must fail the step
        msg = '%s: %s' % (type(e).__name__, e)
        log('FAILED %s: %s' % (tag, msg))
        if run_id:
            try:
                db.abort_run(run_id, msg)
            except Exception as e2:     # noqa: BLE001
                log('  (could not mark run %d failed: %s)' % (run_id, e2))
            # The load files can be rebuilt (the offsets didn't move); keep only the small .err and rejects files.
            for p in (rows_path, state_path):
                remove_quietly(p)
        return 1

    for p in (rows_path, state_path):
        remove_quietly(p)
    remove_if_empty(rejects_path)
    log('loaded %s: %d rows, %d file offsets, %d rejects%s'
        % (tag, rows, files, total_rejects, ' (see %s)' % rejects_path if total_rejects else ''))
    return 0


CLOSE_SLACK = datetime.timedelta(minutes=5)     # a day is complete once rows are 5 min into the day after next


class DayLoader:
    """Backfill sink: routes rows to one load file per day and loads each day once it is complete.

    Day D's rows are in file D and at the head of file D+1 (the last seconds before midnight), so D is
    loaded once a row timestamped after D+1 00:05 has been seen. Each day is its own run and transaction:
    spLoadWeblogStage deletes that day for this logID and inserts the new rows.
    """

    def __init__(self, db, workdir, log_id, first, last, dry_run, log):
        self.db, self.workdir, self.log_id = db, workdir, log_id
        self.first, self.last, self.dry_run, self.log = first, last, dry_run, log
        self.open = {}          # date -> [run_id, path, file, rows]
        self.closed = set()
        self.outside = self.late = 0
        self.loaded = []        # (date, rows, deleted)

    def sink(self, row):
        d = row_date(row)
        ts = datetime.datetime.combine(d, datetime.time.fromisoformat(row[5]))
        if ts > datetime.datetime.combine(self.last + datetime.timedelta(days=1), datetime.time()) + CLOSE_SLACK:
            return STOP
        for day in [x for x in self.open if ts > datetime.datetime.combine(x + datetime.timedelta(days=1),
                                                                           datetime.time()) + CLOSE_SLACK]:
            self.load(day)
        if d < self.first or d > self.last:
            self.outside += 1
            return None
        if d in self.closed:
            self.late += 1
            return None
        entry = self.open.get(d) or self._open(d)
        entry[2].write(('%d\t' % entry[0] + '\t'.join(row) + '\n').encode('utf-8'))
        entry[3] += 1
        return None

    def _open(self, d):
        run_id = 0 if self.dry_run else self.db.start_run('backfill')
        path = os.path.join(self.workdir, 'backfill_%d_%s_run%d.weblog.bcp' % (self.log_id, d, run_id))
        entry = self.open[d] = [run_id, path, open(path, 'wb'), 0]
        return entry

    def load(self, d):
        run_id, path, f, rows = self.open.pop(d)
        f.close()
        self.closed.add(d)
        started = time.monotonic()
        if self.dry_run:
            self.loaded.append((d, rows, 0))
            self.log('  %s: %d rows (dry run, %s)' % (d, rows, path))
            return
        try:
            self.db.bcp_in('weblogStage', path, rows)
            _, loaded, deleted = self.db.load_run(run_id, d, d)
        except Exception as e:      # noqa: BLE001
            try:
                self.db.abort_run(run_id, '%s: %s' % (type(e).__name__, e))
            except Exception:       # noqa: BLE001
                pass
            remove_quietly(path)
            raise
        remove_quietly(path)
        self.loaded.append((d, loaded, deleted))
        self.log('  %s: run %d, %d rows loaded, %d deleted, %.1f s' % (d, run_id, loaded, deleted,
                                                                       time.monotonic() - started))

    def finish(self):
        for d in sorted(self.open):
            self.load(d)

    def abort(self, msg):
        for d in list(self.open):
            run_id, path, f, _ = self.open.pop(d)
            f.close()
            if not self.dry_run:
                remove_quietly(path)
            if run_id:
                try:
                    self.db.abort_run(run_id, msg)
                except Exception:   # noqa: BLE001
                    pass


def cmd_backfill(args):
    first, last = args.date_from, args.date_to
    if first > last or last >= utc_today():
        print('backfill: need --from <= --to < today (UTC)', file=sys.stderr)
        return 1
    os.makedirs(args.workdir, exist_ok=True)
    log = RunLog(args.workdir)
    db = Db(args.server, args.database)

    sources = db.sources(args.method, args.logid)
    missing = set(args.logid) - {s[0] for s in sources}
    if missing:
        log('backfill: no active %s source with logID %s' % (args.method, sorted(missing)))
        return 1
    for log_id, _ in sources:
        owned = db.first_state_date(log_id)
        if owned and last >= owned:
            log('backfill: logID %d has incremental state from %s; --to must be before that' % (log_id, owned))
            return 1
    if not args.dry_run:
        clean_workdir(db, args.workdir, log, args.keep_days)

    rejects_path = os.path.join(args.workdir, 'backfill_%s.rejects.txt' % time.strftime('%Y%m%d_%H%M%S'))
    log('backfill %s..%s for logIDs %s%s' % (first, last, [s[0] for s in sources], ' (dry run)' if args.dry_run else ''))
    with open(rejects_path, 'w', encoding='utf-8') as rej:
        for log_id, folder in sources:
            days = DayLoader(db, args.workdir, log_id, first, last, args.dry_run, log)
            try:
                _, matched = list_logs(folder)
                # Files dated first..last+1: the day after holds the last seconds of `last`.
                names = sorted((n for n in matched
                                if name_dates(n)[1] >= first and name_dates(n)[0] <= last + datetime.timedelta(days=1)),
                               key=name_key)
                for name in names:
                    started = time.monotonic()
                    r = parse_file(os.path.join(folder, name), log_id, days.sink, rej)
                    log('  logID %d %s: %.1f MB, %d rows, %d rejects, %.1f s%s'
                        % (log_id, name, r.bytes_read / 1e6, r.rows, sum(r.rejects.values()),
                           time.monotonic() - started, ' (stopped past --to)' if r.stopped else ''))
                    if r.stopped:
                        break
                days.finish()
            except Exception as e:      # noqa: BLE001
                msg = '%s: %s' % (type(e).__name__, e)
                days.abort(msg)
                log('FAILED logID %d: %s. Days loaded before the failure stay loaded; rerun the same backfill.'
                    % (log_id, msg))
                return 1
            empty = [first + datetime.timedelta(days=i) for i in range((last - first).days + 1)]
            empty = [d for d in empty if d not in {x[0] for x in days.loaded}]
            log('  logID %d done: %d days, %d rows; %d rows outside the range skipped%s%s'
                % (log_id, len(days.loaded), sum(x[1] for x in days.loaded), days.outside,
                   '; WARNING %d rows arrived after their day was loaded (lost)' % days.late if days.late else '',
                   '; WARNING no rows for %s' % ', '.join(map(str, empty)) if empty else ''))
    remove_if_empty(rejects_path)
    return 0


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
            r = parse_file(path, args.logid, file_sink(out), rej, offset=args.offset)
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

    def common(sp):
        sp.add_argument('--server', default='localhost')
        sp.add_argument('--database', default='weblog')
        sp.add_argument('--method', default='TAIL', help="LogSource.method of the sources this loader reads")
        sp.add_argument('--workdir', default=os.path.join(os.path.dirname(os.path.abspath(__file__)), 'work'),
                        help='load files, rejects files and bcpweblog.log; one workdir per database')
        sp.add_argument('--keep-days', type=int, default=30,
                        help='keep .err, rejects and dry-run files and bcpweblog.log lines this long')
        sp.add_argument('--dry-run', action='store_true', help='read and parse, write the load files, load nothing')

    pi = sub.add_parser('incremental', help='hourly: load new complete lines since the stored offsets')
    common(pi)
    pi.add_argument('--logid', type=int, nargs='+', help='only these sources')
    pi.add_argument('--days', type=int, default=2, help='window of file dates, ending today (UTC)')
    pi.add_argument('--max-bytes', type=int, default=1000 * 1000 * 1000,
                    help='per file per run; a bigger backlog is caught up over several runs')
    pi.set_defaults(func=cmd_incremental)

    pb = sub.add_parser('backfill', help='load closed days from offset 0, replacing those days')
    common(pb)
    pb.add_argument('--logid', type=int, nargs='+', required=True)
    pb.add_argument('--from', dest='date_from', type=datetime.date.fromisoformat, required=True)
    pb.add_argument('--to', dest='date_to', type=datetime.date.fromisoformat, required=True)
    pb.set_defaults(func=cmd_backfill)

    pp = sub.add_parser('parse', help='parser check: parse log files into load files, no database')
    pp.add_argument('files', nargs='+')
    pp.add_argument('--out', required=True, help='folder for the .bcp and .rejects.txt files')
    pp.add_argument('--logid', type=int, default=0)
    pp.add_argument('--offset', type=int, default=0, help='start at this byte offset (a line start)')
    pp.set_defaults(func=cmd_parse)
    args = p.parse_args(argv)
    return args.func(args)


if __name__ == '__main__':
    sys.exit(main())
