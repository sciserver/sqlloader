# DR20 Session Summary - June 29, 2026

## Session Goals
- Use BestDR20.dbo.IndexMap as authoritative PK source for VAC table loading
- Update gen_vac_load.py to be IndexMap-driven
- Plan unattended/automated execution for next ~2 weeks while user is on tour

---

## What We Accomplished

### 1. gen_vac_pk.sql — query IndexMap for VAC PKs
Created `dr20/gen_vac_pk.sql`: a diagnostic SELECT against `BestDR20.dbo.IndexMap`
for `code='K'` across all VAC/astra table names from the tracking spreadsheet.
Run it in SSMS to see which tables have PK definitions available.

Result from today's run — **13 tables found in IndexMap**:

| Table | CI Key Column |
|---|---|
| boss_net_boss_star | PK |
| boss_net_boss_visit | PK |
| corv_boss_visit | PK |
| line_forest_boss_star | PK |
| line_forest_boss_visit | PK |
| m_dwarf_type_boss_star | PK |
| m_dwarf_type_boss_visit | PK |
| minesweeper | source_id |
| mwm_boss_allstar | PK |
| mwm_boss_allvisit | PK |
| slam_boss_star | PK |
| snow_white_boss_star | PK |
| spAll | specObjID |

Notes:
- `spAll` is already loaded in BestDR20 — skip
- `minesweeper` is NOT in BESTTEST (new VAC) — needs CSV BULK INSERT, NOT INSERT SELECT
- `corv_boss_visit` was missing from TABLES list — added

### 2. gen_vac_load.py — refactored to use IndexMap
`dr20/gen_vac_load.py` now:
- Queries `BestDR20.dbo.IndexMap` (code='K') at runtime to get CI key column + filegroup
- Only generates SQL for tables found in IndexMap (automatic filter)
- No more hardcoded `[SPEC]` filegroup — uses whatever IndexMap says
- Removed `PK_OVERRIDES` dict and `get_pk_column()` from BESTTEST

**TABLES list (11 tables, all in BESTTEST, all have IndexMap entries):**
```python
TABLES = [
    'boss_net_boss_star', 'boss_net_boss_visit', 'corv_boss_visit',
    'line_forest_boss_star', 'line_forest_boss_visit',
    'm_dwarf_type_boss_star', 'm_dwarf_type_boss_visit',
    'slam_boss_star', 'snow_white_boss_star',
    'mwm_boss_allstar', 'mwm_boss_allvisit',
]
```

**Tables NOT yet processable (no IndexMap entry):**
- `spall_epoch`, `spall_allepoch` — need IndexMap entries added
- `lvm_drpall`, `lvm_dapall` — need IndexMap entries added

Generated output: `dr20/load_vac_tables.sql`

---

## Current BestDR20 State (as of 2026-06-29)

| Layer | Status |
|---|---|
| 171 mos_* tables (minidb) | ✅ Done — CI + PAGE compression + NCIs |
| spAll, allspec, multiplex, mwm_targets | ✅ Done — SPEC filegroup |
| 11 astra tables (gen_vac_load.py) | ⏳ NEXT — run gen_vac_load.py then load_vac_tables.sql |
| minesweeper | ⏳ Needs CSV BULK INSERT (CSV at staging path below) |
| spall_epoch, spall_allepoch, lvm_drpall, lvm_dapall | ⏳ Blocked — need IndexMap entries |
| All other VACs (gyro_age_dwarf etc.) | ⏳ Pending — need IndexMap entries + CSV BULK INSERT |
| APOGEE tables | ⏳ Still loading in BESTTEST |

---

## Automation Goal for Next Session

**Context:** User will be out of WiFi range most of each day for ~2 weeks.
The goal is to eliminate manual SSMS copy/paste and run everything unattended via sqlcmd or Python.

### Current manual workflow (what we want to replace):
1. Run gen script in Python → produces a .sql file
2. Open .sql file in SSMS → paste → execute
3. Watch it run

### Target automated workflow:
1. Python script generates SQL AND executes it directly via pymssql
2. OR: sqlcmd -S localhost -d BestDR20 -E -i script.sql -o log.txt
3. Scheduled/sequenced runs with output logging
4. Exit codes / error detection so failures are visible in output files

### Key scripts needing automation:
- `gen_vac_load.py` → generates `load_vac_tables.sql` → run sqlcmd to execute
- `gen_vac_pk.sql` is diagnostic only, leave as-is
- Minesweeper BULK INSERT (one-off, small table — 169 rows in LVM tables, minesweeper TBD)
- Future: other VAC tables via BULK INSERT from CSV staging path

### CSV staging path (for BULK INSERT):
```
\\SDSS4C\d$\sql_db\staging\sdss5\casload\dr20\
```

Subdirectories per VAC type:
- `mwmCSV\` — MWM VACs (gyro_age_dwarf, yso_ob_kin, minesweeper, etc.)
- `bhmCSV\` — BHM VACs (efeds_spiders_*, DR20Q_prop, etc.)
- `mosCSV\` — MOS VACs (DL1_spec_SDSSV_*)
- `lvmCSV\` — LVM (lvm_drpall, lvm_dapall)
- `asCSV\` — Astra tables (already processed)

### Suggested automation architecture:
1. **Master Python runner** (`run_vac_pipeline.py` or similar):
   - Calls gen_vac_load.py to produce SQL
   - Executes via pymssql or subprocess sqlcmd
   - Logs stdout + errors to timestamped .txt files
   - Prints summary: tables loaded, rows, errors

2. **BULK INSERT generator** for new VACs:
   - Input: table name, CSV path, filegroup, CI column from IndexMap
   - Generates: DROP > CREATE TABLE (from casload GitHub SQL) > CI > BULK INSERT
   - Problem: need to get schema from casload GitHub SQL files (not BESTTEST)
   - The casload SQL files define the schema; can be fetched from GitHub or pre-downloaded

3. **Sequencing** (tables must be created before data loaded):
   - Phase 1: Create tables + CIs (from BESTTEST or from casload SQL)
   - Phase 2: Load data (INSERT SELECT from BESTTEST, or BULK INSERT from CSV)
   - Phase 3: Row count verification

### Key reference files:
- `dr20/dr20_loading_062406.csv` — master tracking spreadsheet
  - Column "DB table Name(s)" = SQL table name
  - Column "SQL" = GitHub URL for casload schema SQL
  - Column "CSV" = Utah path; "Downloaded CSV" = local staging path
- `dr20/gen_spec_load.py` — gold standard pattern for DROP>CREATE>CI>INSERT
- `dr20/gen_vac_load.py` — updated this session, IndexMap-driven
- `schema/sql/comp/createPK.sql` — reference for IndexMap-driven PK generation

### Things to decide/design in next session:
1. Should new VAC tables come from casload GitHub SQL (fetch & parse) or be pre-downloaded?
2. Should the runner use pymssql directly or subprocess sqlcmd? (sqlcmd is simpler, pymssql gives better error capture)
3. How to handle tables where IndexMap entry doesn't exist yet (skip vs. fail vs. prompt)?
4. Logging format — per-table log files vs. single master log?
5. Should lvm/spall_epoch/etc. be blocked until IndexMap is updated, or should we add a manual PK_OVERRIDES fallback?

---

## Files Modified This Session
- `dr20/gen_vac_load.py` — refactored: IndexMap-driven PKs, corv_boss_visit added, spall_epoch etc. removed
- `dr20/gen_vac_pk.sql` — new: diagnostic query for VAC PKs in IndexMap
- `dr20/session_summary_20260629.md` — this file
