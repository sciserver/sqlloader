"""
Add HTM spatial columns (htmid, cx, cy, cz) and NCI to tables in BestDR20.

Per table:
  1. Check if htmid column already exists (skip unless --force)
  2. ALTER TABLE ADD htmid bigint, cx float, cy float, cz float
  3. UPDATE via fHtmEq + CROSS APPLY fHtmEqToXyz
  4. CREATE NONCLUSTERED INDEX on htmid INCLUDE (cx, cy, cz)
  5. Record success in htm_added.json

Usage:
  python run_htm_add.py              # add to tables not yet processed
  python run_htm_add.py --dry-run    # print SQL without executing
  python run_htm_add.py --force      # redo all tables, even previously processed
"""

import argparse
import json
import os
import time
from datetime import datetime

import pymssql

# ── Tables needing HTM columns ──────────────────────────────────────
# Format: table_name: (ra_col, dec_col, filegroup_for_index)
# filegroup can be None to use default
HTM_TABLES = {
    'allspec':               ('ra', 'dec', 'SPEC'),
    'mastar_goodstars':      ('ra', 'dec', 'SPEC'),
    'boss_clam_lite':        ('ra', 'dec', 'SPEC'),
    'boss_clam_params':      ('ra', 'dec', 'SPEC'),
    'boss_ISM_NaI_absorption': ('ra', 'dec', 'SPEC'),
    'da_dwd_candidates':     ('ra', 'dec', 'SPEC'),
    'DR20Q_prop':            ('ra', 'dec', 'SPEC'),
    'mdwarf_contin_summary': ('ra', 'dec', 'SPEC'),
    'minesweeper':           ('ra', 'dec', 'SPEC'),
    'qms_hg_h_hb_indices':   ('ra', 'dec', 'SPEC'),
    'qms_hg_index_diagram':  ('ra', 'dec', 'SPEC'),
    'yso_ob_kin':            ('ra', 'dec', 'SPEC'),
    # Add more as they come online:
    # 'ApogeeDrpAllStar': ('ra', 'dec', 'SPEC'),
    # 'mangaObjAll':      ('objra', 'objdec', 'SPEC'),
    # 'TiledTarget':      ('ra', 'dec', None),
}

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
LOADED_JSON = os.path.join(SCRIPT_DIR, 'htm_added.json')


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


# ── Main ────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description='Add HTM spatial columns to BestDR20 tables')
    parser.add_argument('--dry-run', action='store_true', help='Print SQL without executing')
    parser.add_argument('--force', action='store_true', help='Redo all tables, even previously processed')
    args = parser.parse_args()

    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    log_path = os.path.join(SCRIPT_DIR, f'htm_add_{timestamp}.log')
    log_lines = []

    def log(msg):
        print(msg, flush=True)
        log_lines.append(msg)

    mode = '(DRY RUN)' if args.dry_run else '(FORCE)' if args.force else ''
    log(f"=== HTM Column Adder {mode} -- {datetime.now():%Y-%m-%d %H:%M:%S} ===")
    log(f"Tables configured: {len(HTM_TABLES)}")

    tracking = load_tracking()
    if tracking:
        log(f"Previously processed: {len(tracking)} tables (in {os.path.basename(LOADED_JSON)})")
    log('')

    CONN_TIMEOUT = 0

    def connect():
        return pymssql.connect(server='localhost', database='BestDR20',
                               login_timeout=30, timeout=CONN_TIMEOUT)

    conn = connect()
    results = []

    for table, (ra_col, dec_col, filegroup) in HTM_TABLES.items():
        # Check tracking
        if table in tracking and not args.force:
            prev = tracking[table]
            log(f"-- {table} -- already processed on {prev['processed_at']}, skipping")
            results.append((table, 'ALREADY', 0, 0, ''))
            continue

        log(f"-- {table} (ra={ra_col}, dec={dec_col}) --")

        # Build SQL steps
        alter_sql = (
            f"ALTER TABLE dbo.[{table}] ADD "
            f"htmid bigint NULL, cx float NULL, cy float NULL, cz float NULL;"
        )

        update_sql = (
            f"UPDATE s SET\n"
            f"    s.htmid = dbo.fHtmEq(s.[{ra_col}], s.[{dec_col}]),\n"
            f"    s.cx = h.x,\n"
            f"    s.cy = h.y,\n"
            f"    s.cz = h.z\n"
            f"FROM dbo.[{table}] s\n"
            f"CROSS APPLY dbo.fHtmEqToXyz(s.[{ra_col}], s.[{dec_col}]) h;"
        )

        fg_clause = f" ON [{filegroup}]" if filegroup else ""
        index_sql = (
            f"CREATE NONCLUSTERED INDEX [ix_{table}_htmid] "
            f"ON dbo.[{table}] (htmid) INCLUDE (cx, cy, cz){fg_clause};"
        )

        count_sql = f"SELECT COUNT(*) AS cnt FROM dbo.[{table}] WHERE htmid IS NOT NULL;"

        steps = [
            ('ALTER',  alter_sql),
            ('UPDATE', update_sql),
            ('INDEX',  index_sql),
            ('VERIFY', count_sql),
        ]

        if args.dry_run:
            for desc, sql in steps:
                log(f"  [{desc}]")
                for line in sql.split('\n'):
                    log(f"    {line}")
            results.append((table, 'DRY-RUN', 0, 0, ''))
            log('')
            continue

        # Execute
        t0 = time.time()
        rows_updated = 0
        error = ''
        status = 'OK'

        try:
            cur = conn.cursor(as_dict=True)

            # Check if htmid already exists (maybe --force after partial run)
            cur.execute(
                "SELECT COUNT(*) AS cnt FROM INFORMATION_SCHEMA.COLUMNS "
                "WHERE TABLE_NAME = %s AND COLUMN_NAME = 'htmid'",
                (table,)
            )
            has_htmid = cur.fetchone()['cnt'] > 0

            if has_htmid and args.force:
                log("  htmid column exists -- dropping and re-adding")
                cur.execute(f"DROP INDEX IF EXISTS [ix_{table}_htmid] ON dbo.[{table}]")
                cur.execute(
                    f"ALTER TABLE dbo.[{table}] DROP COLUMN htmid, cx, cy, cz;"
                )
                conn.commit()

            # ALTER
            log("  [ALTER] executing...")
            cur.execute(alter_sql)
            conn.commit()

            # UPDATE -- this is the slow one
            log("  [UPDATE] executing (this may take a while)...")
            cur.execute(update_sql)
            conn.commit()

            # INDEX
            log("  [INDEX] executing...")
            cur.execute(index_sql)
            conn.commit()

            # VERIFY
            log("  [VERIFY] executing...")
            cur.execute(count_sql)
            rows_updated = cur.fetchone()['cnt']
            cur.close()

            elapsed = time.time() - t0
            log(f"  DONE: {rows_updated:,} rows with htmid in {elapsed:.1f}s")

            tracking[table] = {
                'processed_at': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                'rows': rows_updated,
                'ra_col': ra_col,
                'dec_col': dec_col,
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

        results.append((table, status, rows_updated, elapsed, error))
        log('')

    # Summary
    log('=' * 60)
    log('SUMMARY')
    log(f"{'Table':<25} {'Status':<10} {'Rows':>12} {'Time':>8}")
    log('-' * 60)
    for r in results:
        table, status = r[0], r[1]
        rows = r[2] if len(r) > 2 else 0
        dur = r[3] if len(r) > 3 else 0
        err = r[4] if len(r) > 4 else ''
        time_str = f"{dur:.0f}s" if dur else ''
        log(f"{table:<25} {status:<10} {rows:>12,} {time_str:>8}")
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
