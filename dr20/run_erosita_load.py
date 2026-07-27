"""
Load eROSITA tables from VIRGO02.erosita into BestDR20 via linked server.

Schema comes from casload SQL files.
Strategy per table:
  1. Check erosita_loaded.json -- skip if already loaded (unless --force)
  2. Parse CREATE TABLE from casload SQL file
  3. DROP > CREATE TABLE ON [SPEC] > INSERT SELECT from linked server
  4. CREATE CLUSTERED INDEX (PK) with PAGE compression if >= 1M rows
  5. Verify row count

Usage:
  python run_erosita_load.py              # load only NEW tables
  python run_erosita_load.py --dry-run    # print SQL without executing
  python run_erosita_load.py --force      # reload ALL tables
"""

import argparse
import json
import os
import re
import time
from datetime import datetime

import pymssql

# ── Tables to load ──────────────────────────────────────────────────
# Format: table_name: (pk_column, is_primary_key)
TABLES = {
    'efeds_c001_hard_pointsources_ctp_redshift_v17': ('ero_id_src', True),
    'efeds_c001_hard_v7_5':                          ('id_src',     True),
    'efeds_c001_main_pointsources_ctp_redshift_v17': ('ero_id_src', True),
    'efeds_c001_main_v7_4':                          ('id_src',     True),
    'erass1_hard_v1_0':                              ('uid',        True),
    'erass1_main_v1_2':                              ('uid',        True),
    'salvato_etal2025_dr1_ls10':                     ('uid',        False),
}

LINKED_SERVER = 'VIRGO02'
SOURCE_DB = 'erosita'
FILEGROUP = 'SPEC'
COMPRESSION_THRESHOLD = 1_000_000
SQL_DIR = r'H:\GitHub\casload\sql\erosita\dr1'

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
LOADED_JSON = os.path.join(SCRIPT_DIR, 'erosita_loaded.json')


# ── Tracking ────────────────────────────────────────────────────────

def load_tracking():
    if os.path.exists(LOADED_JSON):
        with open(LOADED_JSON, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {}


def save_tracking(data):
    tmp = LOADED_JSON + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)
    os.replace(tmp, LOADED_JSON)


# ── SQL file parsing ────────────────────────────────────────────────

def parse_create_table(sql_path, table_name):
    """Parse a casload SQL file and return (create_sql, column_names).
    Preserves --/D comments, adds ON [filegroup]."""
    with open(sql_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract everything between CREATE TABLE ... ( and the closing );
    match = re.search(r'CREATE\s+TABLE\s+\S+\s*\((.*)\)\s*;', content, re.DOTALL)
    if not match:
        return None, []

    body = match.group(1)

    # Parse column lines: skip pure comment/header lines (--/H, --/T, dashes)
    col_lines = []
    col_names = []
    for line in body.split('\n'):
        stripped = line.strip()
        if not stripped:
            continue
        # Skip pure comment/header lines
        if stripped.startswith('--'):
            continue
        if stripped.startswith('---------'):
            continue
        # This is a column definition line (may have trailing --/D comments)
        clean = line.rstrip()
        # Remove trailing comma for re-joining
        # Comma may be before or after --/D comment
        clean_no_comment = re.sub(r'\s*--/.*$', '', clean)
        comment_match = re.search(r'(--/.*)$', clean)
        comment = comment_match.group(1) if comment_match else ''
        base = clean_no_comment.rstrip().rstrip(',').strip()
        if base:
            col_lines.append(f"{base} {comment}".rstrip() if comment else base)
            # Extract column name
            name_match = re.match(r'\[?(\w+)\]?', base)
            if name_match:
                col_names.append(name_match.group(1))

    # Join with commas between column defs, before any --/D comment
    out_lines = []
    for i, c in enumerate(col_lines):
        comma = ',' if i < len(col_lines) - 1 else ''
        # Insert comma before the --/ comment if present
        comment_match = re.search(r'(\s*--/.*)$', c)
        if comment_match and comma:
            base = c[:comment_match.start()]
            comment = comment_match.group(1)
            out_lines.append(f'    {base}{comma}{comment}')
        else:
            out_lines.append(f'    {c}{comma}')
    col_block = '\n'.join(out_lines)
    create_sql = (
        f"CREATE TABLE dbo.[{table_name}] (\n"
        f"{col_block}\n"
        f") ON [{FILEGROUP}];"
    )
    return create_sql, col_names


# ── Main ────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description='Load eROSITA tables from VIRGO02 into BestDR20')
    parser.add_argument('--dry-run', action='store_true', help='Print SQL without executing')
    parser.add_argument('--force', action='store_true', help='Reload all tables')
    args = parser.parse_args()

    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    log_path = os.path.join(SCRIPT_DIR, f'erosita_load_{timestamp}.log')
    log_lines = []

    def log(msg):
        print(msg, flush=True)
        log_lines.append(msg)

    mode = '(DRY RUN)' if args.dry_run else '(FORCE)' if args.force else ''
    log(f"=== eROSITA Loader {mode} -- {datetime.now():%Y-%m-%d %H:%M:%S} ===")
    log(f"Source: {LINKED_SERVER}.{SOURCE_DB}")
    log(f"Target: BestDR20, filegroup: {FILEGROUP}")
    log(f"Tables: {len(TABLES)}")

    tracking = load_tracking()
    if tracking:
        log(f"Previously loaded: {len(tracking)} tables")
    log('')

    CONN_TIMEOUT = 0

    def connect():
        return pymssql.connect(server='localhost', database='BestDR20',
                               login_timeout=30, timeout=CONN_TIMEOUT)

    conn = connect()
    results = []

    for table, (pk_col, is_pk) in TABLES.items():
        # Check tracking
        if table in tracking and not args.force:
            prev = tracking[table]
            log(f"-- {table} -- already loaded on {prev['loaded_at']} ({prev['rows']:,} rows), skipping")
            results.append((table, 'ALREADY', prev['rows'], 0, ''))
            continue

        log(f"-- {table} (PK: {pk_col}) --")

        # Parse SQL file
        sql_path = os.path.join(SQL_DIR, f'{table}.sql')
        if not os.path.exists(sql_path):
            log(f"  ERROR: SQL file not found: {sql_path}")
            results.append((table, 'ERROR', 0, 0, f'SQL file not found: {sql_path}'))
            continue

        create_sql, col_names = parse_create_table(sql_path, table)
        if not create_sql:
            log(f"  ERROR: could not parse CREATE TABLE from {sql_path}")
            results.append((table, 'ERROR', 0, 0, 'parse error'))
            continue

        log(f"  {len(col_names)} columns from {os.path.basename(sql_path)}")

        col_list = ', '.join(f'[{c}]' for c in col_names)

        # Get source row count
        try:
            cur = conn.cursor(as_dict=True)
            cur.execute(f'SELECT COUNT(*) AS cnt FROM {LINKED_SERVER}.{SOURCE_DB}.dbo.[{table}]')
            source_rows = cur.fetchone()['cnt']
        except Exception as e:
            log(f"  ERROR getting source row count: {e}")
            results.append((table, 'ERROR', 0, 0, str(e)))
            continue

        compress = source_rows >= COMPRESSION_THRESHOLD
        compress_flag = 'PAGE' if compress else 'NONE'
        log(f"  {source_rows:,} rows on {LINKED_SERVER}, compression: {compress_flag}")

        # Build SQL steps
        drop_sql = f"IF OBJECT_ID('dbo.[{table}]') IS NOT NULL DROP TABLE dbo.[{table}];"

        compress_clause = ' WITH (DATA_COMPRESSION = PAGE)' if compress else ''
        pk_type = 'PRIMARY KEY' if is_pk else 'INDEX'
        if is_pk:
            ci_sql = (
                f"ALTER TABLE dbo.[{table}] ADD CONSTRAINT [pk_{table}] "
                f"PRIMARY KEY CLUSTERED ([{pk_col}]){compress_clause} ON [{FILEGROUP}];"
            )
        else:
            ci_sql = (
                f"CREATE CLUSTERED INDEX [ci_{table}_{pk_col}] ON dbo.[{table}] ([{pk_col}])"
                f"{compress_clause} ON [{FILEGROUP}];"
            )

        insert_sql = (
            f"INSERT INTO dbo.[{table}] WITH (TABLOCK)\n"
            f"SELECT {col_list} FROM {LINKED_SERVER}.{SOURCE_DB}.dbo.[{table}];"
        )

        verify_sql = f"SELECT COUNT(*) AS cnt FROM dbo.[{table}];"

        steps = [
            ('DROP',   drop_sql),
            ('CREATE', create_sql),
            ('INSERT', insert_sql),
            ('PK/CI',  ci_sql),
            ('VERIFY', verify_sql),
        ]

        if args.dry_run:
            for desc, sql in steps:
                log(f"  [{desc}]")
                for line in sql.split('\n'):
                    log(f"    {line}")
            results.append((table, 'DRY-RUN', source_rows, 0, ''))
            log('')
            continue

        # Execute
        t0 = time.time()
        loaded_rows = 0
        error = ''
        status = 'OK'

        try:
            cur = conn.cursor(as_dict=True)
            for desc, sql in steps:
                log(f"  [{desc}] executing...")
                cur.execute(sql)
                if desc == 'VERIFY':
                    loaded_rows = cur.fetchone()['cnt']
            conn.commit()
            cur.close()
            elapsed = time.time() - t0
            log(f"  DONE: {loaded_rows:,} rows loaded in {elapsed:.1f}s")
            if loaded_rows != source_rows:
                log(f"  WARNING: row count mismatch! source={source_rows:,} loaded={loaded_rows:,}")

            tracking[table] = {
                'loaded_at': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                'rows': loaded_rows,
                'source_rows': source_rows,
                'pk_col': pk_col,
                'compression': compress_flag,
                'elapsed_s': round(elapsed, 1),
            }
            save_tracking(tracking)

        except Exception as e:
            elapsed = time.time() - t0
            error = str(e)
            status = 'ERROR'
            log(f"  ERROR after {elapsed:.1f}s: {error}")
            try:
                conn.rollback()
            except Exception:
                log("  Rollback failed -- reconnecting...")
                try:
                    conn.close()
                except Exception:
                    pass
                conn = connect()

        results.append((table, status, loaded_rows, elapsed, error))
        log('')

    # Summary
    log('=' * 70)
    log('SUMMARY')
    log(f"{'Table':<55} {'Status':<10} {'Rows':>10} {'Time':>8}")
    log('-' * 70)
    for r in results:
        table, status, rows, dur, err = r
        time_str = f"{dur:.0f}s" if dur else ''
        log(f"{table:<55} {status:<10} {rows:>10,} {time_str:>8}")
        if err:
            log(f"  -> {err}")
    log('')

    conn.close()

    if not args.dry_run:
        with open(log_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(log_lines))
        print(f"\nLog written to {log_path}")


if __name__ == '__main__':
    main()
