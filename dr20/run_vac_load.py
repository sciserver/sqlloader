"""
Load VAC/astra tables from BESTTEST into BestDR20 via pymssql.

Strategy per table:
  1. Check vac_loaded.json -- skip if already loaded (unless --force)
  2. Query IndexMap for CI key column (skip if missing)
  3. Read schema from BESTTEST INFORMATION_SCHEMA.COLUMNS
  4. Refuse if the BESTTEST source is empty while the target holds rows
  5. DROP > CREATE TABLE ON [SPEC] > CREATE CI (PAGE compression if >= 1M rows) > INSERT SELECT
  6. Verify row count, record success in vac_loaded.json

Usage:
  python run_vac_load.py              # load only NEW tables (not in vac_loaded.json)
  python run_vac_load.py --dry-run    # print SQL without executing
  python run_vac_load.py --force      # reload ALL tables, even previously loaded ones
"""

import argparse
import json
import os
import time
from datetime import datetime

import pymssql

# -- Tables to load --------------------------------------------------
# Add more table names here as they become available in BESTTEST + IndexMap.
TABLES = [
    # astra (batch 1)
    'boss_net_boss_star',
    'boss_net_boss_visit',
    'corv_boss_visit',
    'line_forest_boss_star',
    'line_forest_boss_visit',
    'm_dwarf_type_boss_star',
    'm_dwarf_type_boss_visit',
    'slam_boss_star',
    'snow_white_boss_star',
    'mwm_boss_allstar',
    'mwm_boss_allvisit',
    'LVM_DAPall',
    'LVM_DRPall',
    'spAll_epoch',
    'spAll_allepoch',
    # VACs (batch 2)
    'boss_clam_lite',
    'boss_clam_params',
    'boss_ISM_NaI_absorption',
    'boss_occam_cluster',
    'boss_occam_member',
    'boss_vi_results',
    'da_dwd_candidates',
    'da_dwd_rvs',
    'DR20Q_prop',
    'efeds_spiders_agn_fit_params',
    'eROSITA_CVs',
    'fermi_blazar',
    'grav_pot_16',
    'gyro_age_dwarf',
    'mdwarf_active_params',
    'mdwarf_contin_summary',
    'minesweeper',
    'payne4GAIN_summary',
    'qms_hg_h_hb_indices',
    'qms_hg_index_diagram',
    'yso_ob_kin',
]

FILEGROUP = 'SPEC'
COMPRESSION_THRESHOLD = 1_000_000  # PAGE compression if >= this many rows

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
LOADED_JSON = os.path.join(SCRIPT_DIR, 'vac_loaded.json')


# -- Tracking --------------------------------------------------------

def load_tracking():
    """Read vac_loaded.json. Returns {} if file doesn't exist."""
    if os.path.exists(LOADED_JSON):
        with open(LOADED_JSON, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {}


def save_tracking(data):
    """Write vac_loaded.json atomically (temp file + rename)."""
    tmp = LOADED_JSON + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)
    os.replace(tmp, LOADED_JSON)


# -- Helpers --------------------------------------------------------─

def col_type(row):
    """Format a SQL Server column type string from INFORMATION_SCHEMA metadata."""
    dt = row['DATA_TYPE']
    if dt in ('varchar', 'nvarchar', 'char', 'nchar', 'varbinary', 'binary'):
        n = row['CHARACTER_MAXIMUM_LENGTH']
        return f"{dt}(max)" if n == -1 else f"{dt}({n})"
    elif dt in ('decimal', 'numeric'):
        return f"{dt}({row['NUMERIC_PRECISION']},{row['NUMERIC_SCALE']})"
    elif dt == 'float':
        p = row['NUMERIC_PRECISION']
        return f"float({p})" if p and p != 53 else 'float'
    elif dt in ('datetime2', 'time', 'datetimeoffset'):
        p = row['DATETIME_PRECISION']
        return f"{dt}({p})" if p is not None else dt
    else:
        return dt


def get_indexmap_pks(conn, tables):
    """Query BestDR20.IndexMap for PK definitions.
    Returns {tableName: fieldList}."""
    cur = conn.cursor(as_dict=True)
    placeholders = ', '.join(['%s'] * len(tables))
    cur.execute(
        f"SELECT tableName, fieldList FROM dbo.IndexMap "
        f"WHERE code = 'K' AND tableName IN ({placeholders})",
        tables,
    )
    return {r['tableName']: r['fieldList'].strip() for r in cur.fetchall()}


def get_columns(conn, table):
    """Read column metadata from BESTTEST."""
    cur = conn.cursor(as_dict=True)
    cur.execute("""
        SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,
               NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION, IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = %s
        ORDER BY ORDINAL_POSITION
    """, (table,))
    return cur.fetchall()


def get_row_count(conn, table):
    """Get exact row count via COUNT(*)."""
    cur = conn.cursor(as_dict=True)
    cur.execute(f"SELECT COUNT(*) AS row_count FROM dbo.[{table}]")
    r = cur.fetchone()
    return r['row_count'] if r and r['row_count'] else 0


def get_target_rows(conn, table):
    """Rows currently in the BestDR20 target table.

    Returns None if the table does not exist, which is different from 0 -- an
    empty target has nothing to lose, a missing one likewise, but a populated
    one does.  Uses catalog metadata rather than COUNT(*) so this stays cheap
    on large tables.
    """
    cur = conn.cursor(as_dict=True)
    cur.execute("""
        SELECT SUM(p.rows) AS rows
        FROM sys.tables t
        JOIN sys.indexes i ON t.object_id = i.object_id AND i.index_id IN (0, 1)
        JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
        WHERE t.name = %s
    """, (table,))
    r = cur.fetchone()
    return r['rows'] if r and r['rows'] is not None else None


def build_sql(table, pk_field_list, columns, source_rows):
    """Build the list of (description, sql) tuples for one table.
    pk_field_list may be a single column or comma-separated for composite keys."""
    col_defs = []
    col_names = []
    for c in columns:
        name = c['COLUMN_NAME']
        col_names.append(f"[{name}]")
        null = 'NULL' if c['IS_NULLABLE'] == 'YES' else 'NOT NULL'
        col_defs.append(f"    [{name}] {col_type(c)} {null}")
    col_block = ',\n'.join(col_defs)
    col_list = ', '.join(col_names)

    drop_sql = f"IF OBJECT_ID('dbo.[{table}]') IS NOT NULL DROP TABLE dbo.[{table}];"

    table_sql = (
        f"CREATE TABLE dbo.[{table}] (\n"
        f"{col_block}\n"
        f") ON [{FILEGROUP}];"
    )

    # Handle composite PKs: "exposure_num,sdss_id" -> "[exposure_num], [sdss_id]"
    pk_cols = [c.strip() for c in pk_field_list.split(',')]
    pk_col_sql = ', '.join(f'[{c}]' for c in pk_cols)
    ci_name_suffix = '_'.join(pk_cols)

    compress = ''
    if source_rows >= COMPRESSION_THRESHOLD:
        compress = ' WITH (DATA_COMPRESSION = PAGE)'
    ci_sql = (
        f"CREATE CLUSTERED INDEX [ci_{table}_{ci_name_suffix}] ON dbo.[{table}] ({pk_col_sql})"
        f"{compress} ON [{FILEGROUP}];"
    )

    insert_sql = (
        f"INSERT INTO dbo.[{table}] WITH (TABLOCK)\n"
        f"SELECT {col_list} FROM BESTTEST.dbo.[{table}];"
    )

    verify_sql = f"SELECT COUNT(*) AS cnt FROM dbo.[{table}];"

    return [
        ('DROP',   drop_sql),
        ('CREATE', table_sql),
        ('CI',     ci_sql),
        ('INSERT', insert_sql),
        ('VERIFY', verify_sql),
    ]


# -- Main ------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description='Load VAC tables from BESTTEST into BestDR20')
    parser.add_argument('--dry-run', action='store_true', help='Print SQL without executing')
    parser.add_argument('--force', action='store_true', help='Reload all tables, even previously loaded ones')
    args = parser.parse_args()

    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    log_path = os.path.join(SCRIPT_DIR, f'vac_load_{timestamp}.log')
    log_lines = []

    def log(msg):
        print(msg, flush=True)
        log_lines.append(msg)

    mode = '(DRY RUN)' if args.dry_run else '(FORCE)' if args.force else ''
    log(f"=== VAC Loader {mode} -- {datetime.now():%Y-%m-%d %H:%M:%S} ===")
    log(f"Target: BestDR20, filegroup: {FILEGROUP}")
    log(f"Tables requested: {len(TABLES)}")

    # Load tracking
    tracking = load_tracking()
    if tracking:
        log(f"Previously loaded: {len(tracking)} tables (in {os.path.basename(LOADED_JSON)})")
    log('')

    CONN_TIMEOUT = 0  # no query timeout -- INSERT SELECT can take hours

    def connect_best():
        return pymssql.connect(server='localhost', database='BestDR20',
                               login_timeout=30, timeout=CONN_TIMEOUT)

    # Connect
    best = connect_best()
    test = pymssql.connect(server='localhost', database='BESTTEST',
                           login_timeout=30, timeout=CONN_TIMEOUT)

    # Get PKs from IndexMap
    pk_map = get_indexmap_pks(best, TABLES)
    log(f"IndexMap matches: {len(pk_map)} of {len(TABLES)} tables")
    for t in TABLES:
        if t not in pk_map:
            log(f"  WARNING: {t} -- no IndexMap entry, SKIPPING")
    log('')

    # Process each table
    results = []  # (table, status, source_rows, loaded_rows, duration_s, error)

    for table in TABLES:
        if table not in pk_map:
            results.append((table, 'SKIPPED', 0, 0, 0, 'no IndexMap entry'))
            continue

        # Check tracking -- skip if already loaded (unless --force)
        if table in tracking and not args.force:
            prev = tracking[table]
            log(f"-- {table} -- already loaded on {prev['loaded_at']} ({prev['rows']:,} rows), skipping")
            results.append((table, 'ALREADY', prev['rows'], prev['rows'], 0, ''))
            continue

        pk_field_list = pk_map[table]
        log(f"-- {table} (CI: {pk_field_list}) --")

        # Read schema
        columns = get_columns(test, table)
        if not columns:
            log(f"  ERROR: no columns found in BESTTEST, skipping")
            results.append((table, 'ERROR', 0, 0, 0, 'no columns in BESTTEST'))
            continue

        source_rows = get_row_count(test, table)
        compress_flag = 'PAGE' if source_rows >= COMPRESSION_THRESHOLD else 'NONE'
        log(f"  {len(columns)} columns, ~{source_rows:,} rows in BESTTEST, compression: {compress_flag}")

        # The load is DROP > CREATE > CI > INSERT, so an empty source silently
        # replaces the target with nothing -- and because an empty INSERT is not
        # an error, it would commit and be recorded as a success in the tracking
        # file.  Refuse when the target actually holds rows.  A missing or empty
        # target has nothing to lose, so creating the shell there is fine.
        # --force deliberately does not override this: it exists to re-load
        # already-loaded tables, not to permit destroying data.
        if source_rows == 0:
            target_rows = get_target_rows(best, table)
            if target_rows:
                log(f"  REFUSED: BESTTEST source is empty, but the target holds "
                    f"{target_rows:,} rows -- loading would drop them and replace "
                    f"with 0. Wait for the upstream load to finish.")
                results.append((table, 'REFUSED', 0, target_rows, 0,
                                f'empty source, target has {target_rows:,} rows'))
                log('')
                continue
            log(f"  source is empty and target is {'empty' if target_rows == 0 else 'absent'}"
                f" -- creating empty table")

        steps = build_sql(table, pk_field_list, columns, source_rows)

        if args.dry_run:
            for desc, sql in steps:
                log(f"  [{desc}]")
                for line in sql.split('\n'):
                    log(f"    {line}")
            results.append((table, 'DRY-RUN', source_rows, 0, 0, ''))
            log('')
            continue

        # Execute -- single transaction so DROP is rolled back on failure
        t0 = time.time()
        loaded_rows = 0
        error = ''
        status = 'OK'

        try:
            cur = best.cursor(as_dict=True)
            for desc, sql in steps:
                log(f"  [{desc}] executing...")
                cur.execute(sql)
                if desc == 'VERIFY':
                    row = cur.fetchone()
                    loaded_rows = row['cnt'] if row else 0
            # Commit only after all steps succeed
            best.commit()
            cur.close()
            elapsed = time.time() - t0
            log(f"  DONE: {loaded_rows:,} rows loaded in {elapsed:.1f}s")
            if loaded_rows != source_rows:
                log(f"  WARNING: row count mismatch! source={source_rows:,} loaded={loaded_rows:,}")

            # Record success
            tracking[table] = {
                'loaded_at': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                'rows': loaded_rows,
                'source_rows': source_rows,
                'pk_col': pk_field_list,
                'compression': compress_flag,
                'elapsed_s': round(elapsed, 1),
            }
            save_tracking(tracking)

        except Exception as e:
            elapsed = time.time() - t0
            error = str(e)
            status = 'ERROR'
            log(f"  ERROR after {elapsed:.1f}s: {error}")
            # Try to rollback (preserves old table if DROP hasn't committed)
            # If connection is dead, reconnect for the next table
            try:
                best.rollback()
            except Exception:
                log(f"  Rollback failed -- reconnecting...")
                try:
                    best.close()
                except Exception:
                    pass
                best = connect_best()

        results.append((table, status, source_rows, loaded_rows, elapsed, error))
        log('')

    # Summary
    log('=' * 70)
    log('SUMMARY')
    log(f"{'Table':<35} {'Status':<10} {'Source':>12} {'Loaded':>12} {'Time':>8}")
    log('-' * 70)
    for table, status, src, loaded, dur, err in results:
        time_str = f"{dur:.0f}s" if dur else ''
        log(f"{table:<35} {status:<10} {src:>12,} {loaded:>12,} {time_str:>8}")
        if err:
            log(f"  -> {err}")
    log('')

    ok = sum(1 for r in results if r[1] == 'OK')
    already = sum(1 for r in results if r[1] == 'ALREADY')
    skip = sum(1 for r in results if r[1] == 'SKIPPED')
    refused = sum(1 for r in results if r[1] == 'REFUSED')
    fail = sum(1 for r in results if r[1] == 'ERROR')
    log(f"OK: {ok}  Already loaded: {already}  Skipped: {skip}  "
        f"Refused: {refused}  Errors: {fail}")
    if refused:
        log(f"{refused} table(s) refused because the BESTTEST source was empty "
            f"while the target held data. Re-run once they are populated upstream.")

    # Close connections
    test.close()
    best.close()

    # Write log file
    if not args.dry_run:
        with open(log_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(log_lines))
        print(f"\nLog written to {log_path}")


if __name__ == '__main__':
    main()
