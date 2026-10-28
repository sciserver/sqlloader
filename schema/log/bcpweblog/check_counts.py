"""Independent row-count check (SPEC 5.3). Does NOT use bcpweblog.py.

For a logID: read LogSource.pathname and LogFileState offsets, count raw data lines (not '#', not empty)
per 'yyyy-mm-dd hh' in each file up to its stored offset, and compare with weblogAll rows per hour.
"""
import collections
import os
import subprocess
import sys

server, db, log_id = sys.argv[1], sys.argv[2], int(sys.argv[3])


def q(sql):
    p = subprocess.run(['sqlcmd', '-S', server, '-d', db, '-E', '-C', '-b', '-h', '-1', '-W', '-s', '\t',
                        '-Q', 'SET NOCOUNT ON; ' + sql], capture_output=True, text=True, check=True)
    return [l.split('\t') for l in p.stdout.splitlines() if l.strip()]


folder = q('SELECT pathname FROM LogSource WHERE logID = %d' % log_id)[0][0]
files = q('SELECT fileName, byteOffset FROM LogFileState WHERE logID = %d ORDER BY fileName' % log_id)

raw = collections.Counter()
for name, offset in files:
    offset = int(offset)
    n = 0
    with open(os.path.join(folder, name), 'rb') as f:
        left, tail = offset, b''
        while left > 0:
            chunk = f.read(min(16 << 20, left))
            if not chunk:
                break
            left -= len(chunk)
            lines = (tail + chunk).split(b'\n')
            tail = lines.pop()          # offset is a line start, so the tail is empty at the end
            for line in lines:
                if line and line[:1] != b'#' and line.strip():
                    raw[line[:13].decode('ascii', 'replace')] += 1
                    n += 1
        if tail:
            print('  WARNING %s: offset %d is not at a line start' % (name, offset))
    print('%s: %d data lines up to offset %d' % (name, n, offset))

db_counts = collections.Counter()
for yy, mm, dd, hh, n in q('SELECT yy, mm, dd, hh, count_big(*) FROM weblogAll WHERE logID = %d '
                           'GROUP BY yy, mm, dd, hh' % log_id):
    db_counts['%04d-%02d-%02d %02d' % (int(yy), int(mm), int(dd), int(hh))] = int(n)

diff = {k: (raw[k], db_counts[k]) for k in set(raw) | set(db_counts) if raw[k] != db_counts[k]}
print('logID %d: raw %d lines, weblogAll %d rows, %d hours compared, %d hours differ'
      % (log_id, sum(raw.values()), sum(db_counts.values()), len(set(raw) | set(db_counts)), len(diff)))
for k in sorted(diff)[:20]:
    print('  %s raw %d db %d' % (k, *diff[k]))
