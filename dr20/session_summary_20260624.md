# DR20 Session Summary - June 24, 2026

## Session Goals
Apply database metadata (DBObjects/DBColumns) to BestDR20, and begin migrating updated DR20 tables from BESTTEST.

---

## What We Accomplished

### 1. Fixed bestdr20_indexes.sql
- Removed 4 stale entries: `mos_catalog_to_gaia_dr2_source_part1`, `mos_catalog_to_twomass_psc_part1`, and their part2 equivalents
- Also removed those 4 entries from the source file `mssql_indexes_0112_portable.sql` so they won't reappear on regeneration
- The two "already exists" errors (`parallax_parallax_error_idx`, `fuv_mag_nuv_mag_idx`) were a partial-run artifact — those indexes belong in the file and were restored

### 2. Improved pg2mos_descriptions.py
- Updated `INPUT_MS` from `mssql_tables_0116.sql` → `mssql_tables_0603.sql` (canonical schema)
- Added `INPUT_DB_TYPES = 'actual_column_types.tsv'` — reads actual MSSQL types from live BestDR20 DB, takes priority over SQL file
- Added `parse_db_types()` function
- Added `SKIP_TABLES` set — 15 WIP/partition tables that exist in PG schema but not in BestDR20; skipped from output
- Fixed `-- Name:` comment lines for skipped tables also being suppressed

### 3. Created get_db_types.sql
- New file: `dr20/get_db_types.sql`
- Exports table/column/type_string for all `mos_*` tables from BestDR20
- Usage: `sqlcmd -S localhost -d BestDR20 -E -i get_db_types.sql -s "|" -W -h -1 -o actual_column_types.tsv`

### 4. Generated clean metadata files
- `sqlcmd` run against BestDR20 → `dr20/actual_column_types.tsv` (8,277 columns, 171 tables)
- `python pg2mos_descriptions.py` → `dr20/create_minidb_descriptions_ms.sql`
  - 171 tables (WIP tables excluded)
  - 8,274 columns substituted with real MSSQL types
  - 0 type misses
- Copied to `schema/sql/create_minidb_descriptions_ms.sql`
- Created `schema/sql/xschema_mos.txt` (single-file xschema for VBS)

### 5. Ran parseSchema2sql.vbs
- Command: `cd vbs && cscript parseSchema2sql.vbs xschema_mos.txt`
- Completed successfully (took ~15 minutes — VBScript is slow)
- Generated:
  - `schema/csv/loaddbobjects.sql` — 180 lines, 171 `INSERT DBObjects` with `mos_` prefix
  - `schema/csv/loaddbcolumns.sql` — 8,283 lines, 8,274 `INSERT DBColumns`
  - `schema/csv/loaddbviewcols.sql` — 9 lines (header only, no views)

### 6. Loaded mos_ metadata into BestDR20
- `DBObjects.description` column was varchar(256) — widened to varchar(512) to accommodate `mos_catalog` and `mos_target` descriptions
- Deleted existing `mos_*` rows (needed to disable 4 FK constraints temporarily: DBColumns, DBViewCols, Inventory, IndexMap)
- Loaded `loaddbobjects.sql` (grep -v TRUNCATE to skip the TRUNCATE line) → 171 mos_ objects
- Loaded `loaddbcolumns.sql` → 8,274 mos_ columns
- Final counts: DBObjects 869 total (171 mos_), DBColumns 27,962 total (8,274 mos_)

### 7. Analyzed BESTTEST vs BestDR20 for DR20 table migration
- Reviewed `dr20_loading_062406.csv` (the DR20 loading tracking spreadsheet)
- BESTTEST has 195 non-mos_ tables; 3 are new vs BestDR20: `LVM_DAPall`, `LVM_DRPall`, `the_cannon_apogee_star`
- Identified 17 tables where BESTTEST has updated DR20 data vs BestDR20's older data
- Key insight: all 17 have schema differences (column count mismatches) — can't do simple TRUNCATE+INSERT

### 8. Started SPEC filegroup table migration
- Strategy: for large tables going on SPEC filegroup, create CI with PAGE compression BEFORE loading to avoid PRIMARY bloat
- Tables currently in PRIMARY (astra/mwm_boss/corv/slam/snow_white/spAll_epoch/spAll_allepoch) — decision deferred on where they should live
- **4 SPEC tables to migrate now**: `spAll` (5.36M rows), `allspec` (27.6M rows), `multiplex` (54K rows), `mwm_targets` (2.09M rows)
- Created `dr20/gen_spec_load.py` — Python script that reads BESTTEST column metadata and generates load SQL
- Generated `dr20/load_spec_tables.sql` — DROP > CREATE TABLE ON SPEC > CI WITH PAGE COMPRESSION > INSERT SELECT WITH TABLOCK
- **Load completed in ~25 minutes** — ~35M rows total across 4 tables including CI creation

---

## Immediate Next Steps

### When load_spec_tables.sql completes
Verify row counts:
```sql
USE BestDR20;
SELECT 'spAll' AS tbl, COUNT(*) FROM spAll
UNION ALL SELECT 'allspec', COUNT(*) FROM allspec
UNION ALL SELECT 'multiplex', COUNT(*) FROM multiplex
UNION ALL SELECT 'mwm_targets', COUNT(*) FROM mwm_targets;
-- spAll: expect ~5,357,037
-- allspec: expect ~27,671,504
-- multiplex: expect ~54,297
-- mwm_targets: expect ~2,086,349
```

### Tables still pending migration from BESTTEST
Decision needed on which filegroup for:
- `spAll_epoch` (4.9M rows) — currently PRIMARY in BestDR20
- `spAll_allepoch` (506K rows) — currently PRIMARY in BestDR20
- Astra tables currently in PRIMARY: `boss_net_boss_star`, `boss_net_boss_visit`, `corv_boss_visit`, `line_forest_boss_star`, `line_forest_boss_visit`, `m_dwarf_type_boss_star`, `m_dwarf_type_boss_visit`, `mwm_boss_allstar`, `mwm_boss_allvisit`, `slam_boss_star`, `snow_white_boss_star`

New tables (not yet in BestDR20), filegroup TBD:
- `LVM_DAPall` (169 rows)
- `LVM_DRPall` (169 rows)

Still loading in BESTTEST (0 rows — wait for boss to finish):
- `the_cannon_apogee_star`, all APOGEE tables, `mwm_apogee_allstar`, `mwm_apogee_allvisit`, `allVisit_MADGICS_*`

### Also still pending
- VACs from the spreadsheet (VAC 05, 18, 20, 21, 22, etc.) — most have Testload=FALSE, boss still working on them
- Git/file organization (merge to main vs wip/) — deferred from earlier session

---

## Key Context

### BestDR20 Filegroup Structure
| Filegroup | Purpose | Size |
|---|---|---|
| PRIMARY | Metadata, system, small tables | 190 GB |
| SPEC | Spectroscopic tables (spAll, allspec, etc.) | ~395 GB |
| DATAFG | General data tables | ~1.5 TB |
| MINIDB | mos_* tables | ~781 GB |
| PHOTO | Photometric tables | ~5.7 TB |
| ATLAS, FRAME, WISE | Survey-specific | various |

### Migration approach for SPEC tables
Script: `dr20/gen_spec_load.py` generates `dr20/load_spec_tables.sql`
- Uses `pymssql` (same as bulk_loader.py) to query BESTTEST column metadata
- Pattern: DROP > CREATE TABLE ON [SPEC] > CREATE CLUSTERED INDEX WITH (DATA_COMPRESSION=PAGE) ON [SPEC] > INSERT WITH TABLOCK
- Reason: avoids PRIMARY filegroup bloat from heap creation before CI rebuild

### DR20 loading spreadsheet
File: `dr20/dr20_loading_062406.csv` — tracks all products/VACs, their CSV locations, testload status, and BestDR20 publish status.
Local CSV staging path: `\\SDSS4C\d$\sql_db\staging\sdss5\casload\dr20\`

---

## TODO Items

- Replace `parseSchema2sql.vbs` with Python for DR21 (VBScript takes 15+ min for 8k columns)
- After SPEC tables load: decide filegroup for PRIMARY tables, then migrate those
- After boss finishes BESTTEST: migrate remaining tables (APOGEE, mwm_apogee_*, MADGICS, VACs)
- Git/file organization (still pending)

---

## Files Created/Modified This Session

### New Files
- `dr20/get_db_types.sql` — exports actual MSSQL types from live DB
- `dr20/actual_column_types.tsv` — generated output (don't push to git)
- `schema/sql/xschema_mos.txt` — minimal xschema for VBS
- `dr20/gen_spec_load.py` — generates load SQL for SPEC filegroup tables from BESTTEST
- `dr20/load_spec_tables.sql` — generated load script (DROP > CREATE > CI > INSERT) for spAll, allspec, multiplex, mwm_targets
- `dr20/dr20_loading_062406.csv` — copy of DR20 loading tracking spreadsheet

### Modified Files
- `dr20/pg2mos_descriptions.py` — DB types support, SKIP_TABLES, INPUT_MS updated
- `dr20/create_minidb_descriptions_ms.sql` — regenerated clean, 171 tables, real MSSQL types
- `schema/sql/create_minidb_descriptions_ms.sql` — updated to DR20 content
- `schema/csv/loaddbobjects.sql` — regenerated for DR20 (mos_* prefix)
- `schema/csv/loaddbcolumns.sql` — regenerated for DR20
- `dr20/bestdr20_indexes.sql` — removed stale part1/part2 entries
- `dr20/mssql_indexes_0112_portable.sql` — removed part1/part2 entries
- `dr20/TODO.md` — added VBS→Python replacement item
