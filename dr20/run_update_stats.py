#!/usr/bin/env python
"""
run_update_stats.py -- build statistics on the DR20-loaded tables.

WHY THIS IS NEEDED
------------------
The loaders create the clustered index BEFORE inserting rows (see the
"create the CI with PAGE compression on the target filegroup first" convention).
That is right for storage -- rows land in key order, already compressed -- but it
means the index's statistics object is created against an EMPTY table. Bulk
loading with TABLOCK does not build a histogram, so those statistics are left
with no histogram at all: sys.dm_db_stats_properties returns NULL for them.

Measured on BestDR20 / sdss4c, 2026-07-29:

    group                     stats   never built   rows behind them
    mos_*                       397            96      1,886,070,000
    VAC / astra / spectro     2,309            27         74,055,504
    legacy (PhotoObjAll etc)    494             0                  0

The legacy carried-over tables are CLEAN and are deliberately excluded -- they
were not touched in DR20, and including PhotoObjAll alone would take this job
from under an hour to most of a day for no benefit.

Missing histograms matter more than stale ones. auto_update_statistics is ON but
ASYNC is OFF (the SQL Server default), so the first query to touch one of these
tables blocks while the statistic is built. Worse, until it is built the
optimizer guesses tiny row counts, which on a 279M-row table can produce a plan
that runs for hours. Building them ahead of go-live avoids both.

ONE STATISTIC AT A TIME, NOT ONE TABLE
--------------------------------------
FULLSCAN scans the table once PER STATISTIC. `UPDATE STATISTICS mos_allwise
WITH FULLSCAN` therefore reads its 60.4 GB nine times -- roughly 540 GB -- when
only ONE of those nine statistics is actually missing a histogram.

So the work unit here is the statistic, not the table:

    UPDATE STATISTICS [mos_allwise] ([mos_allwise_pkey]) WITH FULLSCAN;

Every one of the missing histograms is a single statistic on its table, so
--scope unbuilt costs one scan per affected table instead of one per statistic
on it. On the DR20 set that is about an order of magnitude less I/O.

TIMING, measured on sdss4c
--------------------------
The first version of this script estimated from mos_supercosmos (14.1 GB, 2
stats, 63s = 229 MB/s). That table was NOT representative and the estimate was
more than 2x optimistic. Across 215 real tables the observed rate was

    104 MB/s

with wide tables such as mos_catalog (272M rows, 9.3 GB) running at 79 MB/s.
Estimates below use 104 MB/s and count I/O as (table size x statistics scanned).

    --scope unbuilt (default)  one scan per affected table
    --scope dr20               every statistic on every DR20 table -- hours
    --sample                   any scope, minutes, weaker histograms

FULLSCAN is the right default here: this is a write-once, read-only database
that will serve the same data for a year, so exact histograms are worth the
extra time, and sampling is weakest exactly where it matters most -- the
hundred-million-row tables.

USAGE
    python run_update_stats.py                    # unbuilt only, FULLSCAN
    python run_update_stats.py --scope dr20       # every DR20-loaded table
    python run_update_stats.py --sample           # default sampling instead
    python run_update_stats.py --dry-run          # list what would be done
    python run_update_stats.py --server sdss5a    # target a restored copy
    python run_update_stats.py --force            # redo already-done tables

Resumable: each table is recorded in stats_updated.json as it completes, so an
interrupted run picks up where it left off. Tracking is keyed by server, since
sdss4c, sdss5a and sdss5b each need their own pass -- statistics live inside the
database, so a restore carries the missing histograms with it.
"""

import argparse
import json
import os
import sys
from datetime import datetime

import pymssql

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
TRACKING_JSON = os.path.join(SCRIPT_DIR, 'stats_updated.json')
DATABASE = 'BestDR20'

# Measured across 215 real tables on sdss4c, 2026-07-29. Do not raise this on
# the basis of one fast table: calibrating on mos_supercosmos alone gave
# 229 MB/s and an estimate that was more than 2x optimistic.
OBSERVED_MB_PER_SEC = 104

# VAC / astra / spectro tables loaded for DR20. Taken from run_vac_load.py's
# TABLES list -- keep the two in step when a release adds or drops a VAC.
# boss_clam_params is deliberately absent: retired 2026-07-29.
DR20_TABLES = [
    'boss_net_boss_star', 'boss_net_boss_visit', 'corv_boss_visit',
    'line_forest_boss_star', 'line_forest_boss_visit', 'm_dwarf_type_boss_star',
    'm_dwarf_type_boss_visit', 'slam_boss_star', 'snow_white_boss_star',
    'snow_white_boss_visit', 'mwm_boss_allstar', 'mwm_boss_allvisit',
    'LVM_DAPall', 'LVM_DRPall', 'spAll_epoch', 'spAll_allepoch',
    'boss_clam_lite', 'boss_ISM_NaI_absorption',
    'boss_occam_cluster', 'boss_occam_member', 'boss_vi_results',
    'da_dwd_candidates', 'da_dwd_rvs', 'DR20Q_prop',
    'efeds_spiders_agn_fit_params', 'eROSITA_CVs', 'fermi_blazar',
    'grav_pot_16', 'gyro_age_dwarf', 'mdwarf_active_params',
    'mdwarf_contin_summary', 'minesweeper', 'payne4GAIN_summary',
    'qms_hg_h_hb_indices', 'qms_hg_index_diagram', 'yso_ob_kin',
    'DL1_eROSITA_eRASS3_allepoch', 'DL1_eROSITA_eRASS3_daily',
    'efeds_spiders_agn_ctp_salvato', 'efeds_spiders_agn_hard_xray_cat',
    'efeds_spiders_agn_host_decomp', 'efeds_spiders_agn_line_props',
    'efeds_spiders_agn_main_xray_cat', 'efeds_spiders_agn_xray_props',
    # eROSITA DR1
    'efeds_c001_hard_pointsources_ctp_redshift_v17', 'efeds_c001_hard_v7_5',
    'efeds_c001_main_pointsources_ctp_redshift_v17', 'efeds_c001_main_v7_4',
    'erass1_hard_v1_0', 'erass1_main_v1_2', 'salvato_etal2025_dr1_ls10',
    # spectro core
    'spAll', 'allspec', 'multiplex', 'mwm_targets',
]

# Never touch these, whatever the scope says. Carried over from DR19 untouched,
# and enormous -- PhotoObjAll alone is ~5 TB.
EXCLUDE = {
    'PhotoObjAll', 'SpecObjAll', 'PhotoTag', 'PhotoPrimary', 'PhotoObj',
    'Frame', 'Field', 'FieldProfile', 'Mask', 'RegionPatch',
}


def tracking_path(server):
    """One tracking file PER SERVER.

    A single shared file cannot be used: this script writes tracking after every
    statistic, and save_tracking is a read-modify-write of the whole file. Two
    runs against different servers at the same time -- which is the normal way to
    do sdss5a and sdss5b -- would silently clobber each other's progress.
    """
    return os.path.join(SCRIPT_DIR, f'stats_updated_{server.lower()}.json')


def load_tracking(server):
    path = tracking_path(server)
    if os.path.exists(path):
        with open(path) as fh:
            return json.load(fh)
    # Fall back to the older single shared file, so a run started before the
    # split can still resume.
    if os.path.exists(TRACKING_JSON):
        with open(TRACKING_JSON) as fh:
            return json.load(fh).get(server.lower(), {})
    return {}


def save_tracking(server, done):
    with open(tracking_path(server), 'w') as fh:
        json.dump(done, fh, indent=2)


def get_targets(conn, scope):
    """Return [(table, stat_name, rows, mb, is_unbuilt)] -- one row per STATISTIC.

    The statistic is the unit of work because FULLSCAN scans the table once per
    statistic, so updating a whole 9-statistic table to fix 1 missing histogram
    costs 9x more I/O than needed.
    """
    cur = conn.cursor()
    cur.execute("""
        SELECT t.name, s.name AS stat_name,
               p.rows,
               CAST(a.mb AS decimal(12,1)) AS mb,
               CASE WHEN sp.last_updated IS NULL THEN 1 ELSE 0 END AS unbuilt
        FROM sys.stats s
        JOIN sys.tables t ON t.object_id = s.object_id
        OUTER APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
        JOIN (SELECT object_id, MAX(rows) AS rows FROM sys.partitions
              WHERE index_id IN (0,1) GROUP BY object_id) p
             ON p.object_id = t.object_id
        JOIN (SELECT p2.object_id, SUM(au.total_pages)*8.0/1024 AS mb
              FROM sys.partitions p2
              JOIN sys.allocation_units au ON au.container_id = p2.partition_id
              GROUP BY p2.object_id) a ON a.object_id = t.object_id
        WHERE p.rows > 0
    """)
    rows = cur.fetchall()

    dr20 = {n.lower() for n in DR20_TABLES}
    out = []
    for tname, sname, nrows, mb, unbuilt in rows:
        if tname in EXCLUDE:
            continue
        is_mos = tname.lower().startswith('mos_')
        in_dr20 = tname.lower() in dr20
        if scope == 'unbuilt':
            keep = bool(unbuilt)
        else:  # dr20
            keep = bool(unbuilt) or is_mos or in_dr20
        if keep:
            out.append((tname, sname, int(nrows), float(mb), bool(unbuilt)))
    # cheapest first, so an interrupted run has already banked the quick wins
    out.sort(key=lambda r: r[3])
    return out


def main():
    ap = argparse.ArgumentParser(description='Build statistics on DR20-loaded tables')
    ap.add_argument('--server', default='localhost', help='target server (default localhost)')
    ap.add_argument('--scope', choices=['unbuilt', 'dr20'], default='unbuilt',
                    help="'unbuilt' = only tables with a missing histogram (default); "
                         "'dr20' = every DR20-loaded table")
    ap.add_argument('--sample', action='store_true',
                    help='use default sampling instead of FULLSCAN (much faster, weaker)')
    ap.add_argument('--dry-run', action='store_true', help='list the work, change nothing')
    ap.add_argument('--force', action='store_true', help='redo tables already recorded as done')
    args = ap.parse_args()

    mode = 'default sample' if args.sample else 'FULLSCAN'
    stamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    log_path = os.path.join(SCRIPT_DIR, f'update_stats_{stamp}.log')
    log_lines = []

    def log(msg):
        print(msg, flush=True)
        log_lines.append(msg)

    log(f"=== Statistics Builder {'(DRY RUN) ' if args.dry_run else ''}"
        f"-- {datetime.now():%Y-%m-%d %H:%M:%S} ===")
    log(f"Server: {args.server}   Database: {DATABASE}")
    log(f"Scope: {args.scope}   Mode: {mode}")

    conn = pymssql.connect(server=args.server, database=DATABASE,
                           login_timeout=30, timeout=0)
    conn.autocommit(True)

    targets = get_targets(conn, args.scope)
    tracking = {} if args.force else load_tracking(args.server)

    todo = [t for t in targets if f"{t[0]}.{t[1]}" not in tracking]
    skipped = len(targets) - len(todo)
    # Each statistic costs one full scan of its table, so scan volume is the
    # sum of the table size per statistic -- not the distinct table size.
    scan_mb = sum(t[3] for t in todo)
    tables = len({t[0] for t in todo})

    log(f"Statistics in scope: {len(targets)}"
        + (f"   already done: {skipped}" if skipped else ""))
    log(f"To process: {len(todo)} statistics across {tables} tables, "
        f"{sum(1 for t in todo if t[4])} missing histogram(s)")
    log(f"Scan volume: {scan_mb/1024:.1f} GB "
        f"(one full scan of the table per statistic)")
    if not args.sample and scan_mb:
        log(f"Estimated FULLSCAN time at ~{OBSERVED_MB_PER_SEC} MB/s: "
            f"{scan_mb/OBSERVED_MB_PER_SEC/60:.0f} min")
    log('')

    if args.dry_run:
        log(f"{'table':<40}{'statistic':<40}{'rows':>14}{'MB':>9}{'unbuilt':>8}")
        for tname, sname, nrows, mb, un in todo:
            log(f"{tname:<40}{sname:<40}{nrows:>14,}{mb:>9,.0f}"
                f"{('yes' if un else ''):>8}")
        log('')
        log("DRY RUN -- nothing changed")
        return 0

    done = dict(tracking)
    failures = []
    run_start = datetime.now()

    for i, (tname, sname, nrows, mb, un) in enumerate(todo, 1):
        opt = '' if args.sample else ' WITH FULLSCAN'
        # Target the single statistic, not the whole table -- see the module
        # docstring. One scan instead of one per statistic on the table.
        sql = f"UPDATE STATISTICS [{tname}] ([{sname}]){opt};"
        key = f"{tname}.{sname}"
        t0 = datetime.now()
        try:
            cur = conn.cursor()
            cur.execute(sql)
            elapsed = (datetime.now() - t0).total_seconds()
            log(f"[{i:>4}/{len(todo)}] {tname:<38} {sname:<38} "
                f"{mb:>8,.0f} MB {'unbuilt' if un else '       '} {elapsed:>7.1f}s")
            done[key] = {
                'updated_at': t0.strftime('%Y-%m-%d %H:%M:%S'),
                'table': tname, 'statistic': sname,
                'rows': nrows, 'mb': mb, 'unbuilt_before': un,
                'mode': mode, 'elapsed_s': round(elapsed, 1),
            }
            save_tracking(args.server, done)   # after each stat, so a kill is safe
        except Exception as exc:
            elapsed = (datetime.now() - t0).total_seconds()
            log(f"[{i:>4}/{len(todo)}] {tname}.{sname} FAILED after {elapsed:.1f}s: {exc}")
            failures.append((key, str(exc)))

    total_elapsed = (datetime.now() - run_start).total_seconds()
    log('')
    log('=' * 70)
    log(f"Processed {len(todo) - len(failures)} of {len(todo)} tables "
        f"in {total_elapsed/60:.1f} min")
    if failures:
        log(f"FAILURES ({len(failures)}):")
        for name, err in failures:
            log(f"  {name}: {err}")

    # Did it actually achieve the goal?
    cur = conn.cursor()
    cur.execute("""
        SELECT COUNT(*) FROM sys.stats s
        JOIN sys.tables t ON t.object_id = s.object_id
        OUTER APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
        JOIN (SELECT object_id, MAX(rows) AS rows FROM sys.partitions
              WHERE index_id IN (0,1) GROUP BY object_id) p ON p.object_id = t.object_id
        WHERE p.rows > 0 AND sp.last_updated IS NULL AND t.name NOT IN ({})
    """.format(','.join(f"'{n}'" for n in sorted(EXCLUDE))))
    remaining = cur.fetchone()[0]
    log(f"Statistics still with no histogram (excluding legacy): {remaining}")
    if remaining == 0:
        log("OK -- every statistic in scope now has a histogram")

    with open(log_path, 'w') as fh:
        fh.write('\n'.join(log_lines) + '\n')
    print(f"\nLog written to {log_path}")
    return 1 if failures else 0


if __name__ == '__main__':
    sys.exit(main())
