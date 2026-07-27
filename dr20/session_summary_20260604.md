# DR20 Session Summary - June 4, 2026

## Session Goals
Load the minidb DR20 tables into BestDR20 (renamed from BestDR19).

---

## What We Accomplished

### 1. Generated BestDR20 Load Scripts

Created two new Python scripts:

**`fix_tables_schema.py`**
- Produces `mssql_tables_0603.sql` from `mssql_tables_0116.sql`
- Bakes in all 19 varchar column size fixes discovered during minidb_dr20_v2 load
- Removes 14 WIP/staging tables that don't exist in minidb_dr20_v2
- This is now the canonical, correct schema file — run unpatched

**`gen_bestdr20.py`**
- Reads `mssql_tables_0603.sql`, `mssql_pk_0112.sql`, `mssql_indexes_0112_portable.sql`
- Generates 5 SQL files with `dr20_` → `mos_` prefix substitution:
  - `bestdr20_drop.sql` — drops existing mos_* tables
  - `bestdr20_tables.sql` — CREATE TABLE ON [MINIDB] with extra columns injected
  - `bestdr20_pk.sql` — PKs with GO batches, PAGE compression on all >= 1M row tables
  - `bestdr20_load.sql` — TRUNCATE + INSERT...SELECT WITH (TABLOCK) per table
  - `bestdr20_indexes.sql` — 992 NCIs

**Extra columns injected** (to match minidb_dr20_v2 which had these added post-load):
- `mos_target`: htmid bigint, cx real, cy real, cz real
- `mos_allwise`: w1mpro_w2mpro real
- `mos_gaia_dr2_source`: parallax_parallax_error real
- `mos_guvcat`: fuv_mag_nuv_mag real

### 2. PAGE Compression Strategy Improved

Original minidb_dr20_v2 had PAGE compression on only 16 tables — these were the source
catalog tables, missing almost all the large catalog_to_* cross-match tables.

Ran row count query against minidb_dr20_v2, identified all tables >= 1M rows.
BestDR20 now has PAGE compression on **73 tables** (vs 16 before).

Notable gaps in original 16: dr20_assignment (308M rows!), dr20_catalog_to_tic_v8 (200M),
dr20_catalog_to_gaia_dr2_source (185M), and many others.

### 3. Load Execution

Order: DROP → CREATE TABLES → CREATE PKs → LOAD DATA → CREATE NCIs

**Key design decision**: Create PKs (clustered indexes) BEFORE loading data.
- Pros: Data lands sorted, no post-load rebuild
- Cons: Sort overhead during INSERT (30-40 MB/s vs 1.8 GB/s for heap inserts)
- Alternative (heap-first + CREATE CLUSTERED INDEX) requires 2x disk space temporarily
- SIMPLE recovery model already set on BestDR20 — no change needed

**Steps 1-3** (drop/create tables/PKs): Completed in minutes, no errors.

**Step 4** (data load): Ran overnight in SSMS. All 171 tables loaded successfully.
- One truncation error on mos_allstar_dr17_synspec_rev1.targflags (varchar too small)
- Fixed by running ALTER TABLE on BestDR20 directly, then restarting load
- Root cause: fix_tables_schema.py already had the fix, but bestdr20_tables.sql had been
  generated from old mssql_tables_0116.sql before the fix script was run
- Resolution: regenerated all scripts from mssql_tables_0603.sql (which has fixes baked in)

**Step 5** (NCIs): Running as of end of session — 992 indexes, expected several hours.

### 4. WIP Tables Removed

14 tables existed in the PostgreSQL schema but were never loaded in minidb_dr20_v2:
- All `*_part1/part2` partition tables (8 tables)
- `dr20_carton_csv`, `dr20_legacy_catalog_catalogid`
- `dr20_target_union_legacy`, `dr20_target_union_legacy_initial`
- `dr20_sdss_id_flat_initial`, `dr20_sdss_id_to_catalog_full`

Actions: Dropped from BestDR20, removed from `mssql_tables_0603.sql`.
Schema now has 171 tables — matches minidb_dr20_v2 exactly.

---

## Key Technical Notes

### PAGE Compression Threshold
- 1M rows is the right threshold for a read-heavy analytics database
- Below 1M: tables likely fully cached in buffer pool, compression overhead not worth it
- Above 1M: I/O savings outweigh decompression CPU cost, especially for wide tables
- allwise (61M rows, 52 GB) took ~1 hour to load due to width + compression overhead

### INSERT...SELECT vs BULK INSERT
- TABLOCK hint enables minimal logging with SIMPLE recovery model
- Bottleneck on large tables is the clustered index sort, not logging
- For wide tables (allwise at ~900 bytes/row) expect 30-60 min even at 30-40 MB/s

### SQL Server Cannot Pre-Sort for INSERT
- No hint exists to tell optimizer incoming data is pre-sorted for INSERT purposes
- The sort into the B-tree is inherent to clustered index maintenance
- Only alternative (heap-first) has 2x disk space cost during index build

---

## Future Work Identified

### Columnstore Index Experiment (BestDR20)
- User has done prior experiment: CCI on native DR20 tables (PhotoObjAll etc.)
  produced "screamingly great" query performance
- PhotoObjAll: 1.23B rows, 5 TB total (1.87 TB just indexes!)
- CCI would reduce to ~600 GB - 1 TB, eliminate most NCIs
- Cone search fix: add nonclustered rowstore index on htmid alongside CCI
  (optimizer uses rowstore for spatial range, columnstore for rest)
- Planned as separate BestDR20 variant when time allows

### Denormalized minidb Schema Proposal
- Current minidb schema requires ~50-table joins for common queries
- Appropriate for OLTP/write use at Utah, but wrong for read-only SkyServer
- Idea: propose denormalized, analytics-friendly schema to Utah team
- CCI would compound performance gains on a flatter schema

---

## Files Created/Modified This Session

### New Files
- `fix_tables_schema.py` — generates corrected schema from mssql_tables_0116.sql
- `mssql_tables_0603.sql` — canonical schema: 171 tables, all varchar fixes, no WIP tables
- `gen_bestdr20.py` — generates all bestdr20_*.sql scripts
- `bestdr20_drop.sql`
- `bestdr20_tables.sql`
- `bestdr20_pk.sql`
- `bestdr20_load.sql`
- `bestdr20_indexes.sql`
- `session_summary_20260604.md` — this file

### Modified Files
- `mssql_indexes_0112_portable.sql` — removed 3 carton_csv indexes
- `TODO.md` — updated status, added CCI/denormalized schema future work
