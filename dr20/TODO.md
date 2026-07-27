# DR20 Loading - TODO List

**Last Updated:** June 4, 2026

---

## Current Status

✅ **Completed:**
- All 171 tables loaded on E: drive (minidb_dr20) - heap tables
- Database created on D: drive (minidb_dr20_v2) with MINIDB filegroup
- Tables created with fixed varchar sizes (mssql_tables_0116.sql - no more varchar(max))
- Primary keys created with ON [MINIDB] and PAGE compression on 16 tables
- Data load E: → D: drive complete (load_from_heap_tables.sql)
- Nonclustered indexes created (mssql_indexes_0112.sql)
- Foreign keys created (mssql_fk_0112.sql)
- HTM spatial library deployed
- Spatial stored procedures deployed
- HTM spatial indexes added
- **BestDR20 load complete** (renamed from BestDR19):
  - 171 mos_* tables created ON [MINIDB] filegroup
  - PAGE compression on 73 tables >= 1M rows (up from 16 in minidb_dr20_v2)
  - 14 WIP/staging tables dropped and removed from schema
  - Data loaded via INSERT...SELECT WITH (TABLOCK), SIMPLE recovery
  - PKs created (179 total, 73 with PAGE compression)
  - Nonclustered indexes running (992 NCIs) — in progress as of 2026-06-04

🔄 **In Progress:**
- BestDR20 nonclustered index creation (992 indexes, running)
- Metadata loading (step 7) — see details below

---

## Immediate Next Steps

### 1. Load Database Metadata

New workflow using `pg_schema_descriptions.sql` from Utah (2026-04-22):

- [x] Generated `create_minidb_descriptions_ms.sql` using `pg2mos_descriptions.py`
  - 186 tables, `mos_` prefix, MSSQL types substituted from `mssql_tables_0116.sql`
  - `plan` → `planname` rename applied
- [ ] Waiting on Utah re: schema discrepancies (email sent 2026-04-22)
  - `dr20_target_2025dec9` in pg schema but not in our MSSQL schema
  - 14 tables with undocumented columns (partition/junction tables — probably fine)
- [ ] Update `vbs/xschema.txt` to point to `dr20/create_minidb_descriptions_ms.sql`
- [ ] Run `cscript parseSchema2sql.vbs` from `vbs/` directory
- [ ] Load generated metadata into minidb_dr20_v2:
  ```bash
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i H:\GitHub\sqlloader\schema\csv\loaddbobjects.sql
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i H:\GitHub\sqlloader\schema\csv\loaddbcolumns.sql
  ```

---

## Database Objects Creation (DONE)

### 2. Create Nonclustered Indexes ✅

- [x] Execute mssql_indexes_0112.sql (992 indexes)
  ```bash
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i mssql_indexes_0112.sql -o index_results_0116.txt
  ```

- [ ] **Note:** Some computed column indexes may fail
  - E.g., indexes on expressions like (parallax - parallax_error)
  - Will need to create persisted computed columns first
  - Document any failures in issues.md

- [ ] Monitor index creation progress
  - Expected time: 2-4 hours for large tables
  - Check for errors and document failures

### 3. Create Foreign Keys ✅

- [x] Execute mssql_fk_0112.sql (102 foreign keys)
  ```bash
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i mssql_fk_0112.sql -o fk_results_0116.txt
  ```

- [ ] **Known Issue:** Some FKs may fail due to orphaned records
  - Check for orphaned records before creating FK:
  ```sql
  SELECT target_id
  FROM dr20_catalog_to_[table_name]
  WHERE target_id NOT IN (SELECT pk FROM dr20_[table_name]);
  ```

- [ ] Document any FKs that fail
  - Add to issues.md with details
  - Decide whether to fix data or skip FK

---

## Spatial Functions and HTM Indexes

### 4. Deploy Spherical Library (HTM CLR Functions) ✅

- [x] Deploy HTM CLR assembly to minidb_dr20_v2
  ```bash
  cd H:\GitHub\sqlloader\htm
  # Run install.bat or execute spSphericalDeploy.sql
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i spSphericalDeploy.sql
  ```

- [ ] Verify CLR functions installed
  ```sql
  USE minidb_dr20_v2;
  SELECT name, type_desc
  FROM sys.objects
  WHERE name LIKE 'fHtm%' OR name LIKE 'fCartesian%'
  ORDER BY name;
  ```

### 5. Add Spatial Stored Procedures ✅

- [x] Deploy spNearby.sql and related spatial functions
  ```bash
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i H:\GitHub\sqlloader\schema\spNearby.sql
  ```

- [ ] Verify spatial functions installed
  ```sql
  USE minidb_dr20_v2;
  SELECT name, type_desc
  FROM sys.objects
  WHERE name LIKE 'sp%Nearby%' OR name LIKE 'fGet%'
  ORDER BY name;
  ```

### 6. Add HTM Spatial Indexes ✅

- [x] Identify tables with RA/DEC columns needing spatial indexes
  - Review mssql_indexes_0112.sql for commented-out q3c indexes
  - 53+ tables have q3c indexes in PostgreSQL source
  - Prioritize large catalog tables (gaia, target, catalog, etc.)

- [ ] Add HTM columns and indexes to key tables
  ```sql
  -- Example for dr20_catalog:
  ALTER TABLE dr20_catalog ADD htmid bigint;
  UPDATE dr20_catalog SET htmid = dbo.fHtmEq(ra, dec);
  CREATE INDEX dr20_catalog_htmid_idx ON dr20_catalog(htmid);
  ```

- [ ] Add Cartesian coordinate columns where needed
  ```sql
  -- Example using fCartesianX, fCartesianY, fCartesianZ functions
  ALTER TABLE dr20_target ADD cx real, cy real, cz real;
  UPDATE dr20_target SET
    cx = dbo.fCartesianX(ra, dec),
    cy = dbo.fCartesianY(ra, dec),
    cz = dbo.fCartesianZ(ra, dec);
  ```

- [ ] Document HTM index creation in issues.md
  - Which tables got HTM indexes
  - Performance characteristics

---

## Metadata Loading (Optional)

### 7. Load Database Metadata — see step 1 above for current status

- [ ] Load table/column descriptions
  ```bash
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i H:\GitHub\sqlloader\schema\csv\loaddbobjects.sql
  ```

- [ ] Load algorithm documentation
  ```bash
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i H:\GitHub\sqlloader\schema\csv\loadalgorithm.sql
  ```

- [ ] Load glossary
  ```bash
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i H:\GitHub\sqlloader\schema\csv\loadglossary.sql
  ```

- [ ] Load extended table descriptions
  ```bash
  sqlcmd -S localhost -d minidb_dr20_v2 -E -i H:\GitHub\sqlloader\schema\csv\loadtabledesc.sql
  ```

---

## Validation & Documentation

### 8. Final Validation

- [ ] **Verify total row counts match expected**
  - Compare to E: drive source (minidb_dr20)
  - All 171 tables should match exactly

- [ ] **Check data integrity**
  - Sample random rows from large tables
  - Verify numeric values (no NaN)
  - Verify NULL handling is correct

- [ ] **Test key queries**
  - Cone searches (if HTM indexes added)
  - Common catalog joins
  - Performance benchmarks

- [ ] **Check database size and compression**
  ```sql
  USE minidb_dr20_v2;
  EXEC sp_spaceused;

  -- Per-table sizes
  SELECT
    t.name AS table_name,
    SUM(p.rows) AS row_count,
    SUM(a.total_pages) * 8 / 1024 AS size_mb,
    SUM(a.total_pages) * 8 / 1024 / 1024 AS size_gb,
    p.data_compression_desc
  FROM sys.tables t
  INNER JOIN sys.indexes i ON t.object_id = i.object_id
  INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
  INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
  WHERE t.name LIKE 'dr20_%' AND i.index_id IN (0,1)
  GROUP BY t.name, p.data_compression_desc
  ORDER BY size_gb DESC;
  ```

- [ ] **Verify PAGE compression savings**
  - 16 tables should show PAGE compression
  - Expected savings: 50-70% on large tables (~517 GB → ~207 GB)

### 9. Update Documentation

- [ ] Update issues.md with final notes
  - Document any skipped indexes
  - Document any orphaned FK issues
  - Document any data quality issues found
  - Document HTM index decisions

- [ ] Create final session summary
  - Total load time (E: → D: drive)
  - Final statistics (rows, size, objects)
  - Any remaining issues or warnings
  - Performance metrics (load speed, compression ratios)

- [ ] Update CLAUDE.md if needed
  - Document varchar(max) → varchar(n) conversion process
  - Update sampling strategy for size determination
  - Document MINIDB filegroup strategy
  - Update HTM deployment notes

---

## Git Commit

### 10. Commit DR20 Work

- [ ] Review all changes
  ```bash
  git status
  git diff
  ```

- [ ] Stage files for commit
  ```bash
  git add dr20/pg2mssql.py
  git add dr20/mssql_tables_0116.sql
  git add dr20/mssql_pk_0112.sql
  git add dr20/mssql_indexes_0112.sql
  git add dr20/mssql_fk_0112.sql
  git add dr20/create_production_db.sql
  git add dr20/load_from_heap_tables.sql
  git add dr20/analyze_varchar_max_sample.sql
  git add dr20/fix_varchar_max.py
  git add dr20/fix_pk_file.py
  git add dr20/session_summary_*.md
  git add dr20/TODO.md
  git add dr20/issues.md
  ```

- [ ] Create commit
  ```bash
  git commit -m "DR20: Production database build on D: drive with MINIDB filegroup

  - Created minidb_dr20_v2 on D: drive with MINIDB filegroup (4x280GB files)
  - Fixed varchar(max) columns: analyzed 497 columns, converted to appropriate sizes
  - Fixed primary keys: added ON [MINIDB] to all 179 PKs
  - Loaded 171 tables from E: drive heap → D: drive clustered tables
  - PAGE compression on 16 large tables
  - Ready for nonclustered indexes, FKs, and HTM spatial functions

  🤖 Generated with Claude Code
  Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
  ```

- [ ] Push to remote (if applicable)
  ```bash
  git push origin dr20
  ```

---

## Future Enhancements (DR21 Planning)

### 11. Process Improvements for DR21

- [ ] **Replace `parseSchema2sql.vbs` with Python** — the 2001-era VBScript takes 15+ minutes to process 8,000 columns due to per-line regex in an interpreted loop. A Python replacement would run in seconds and be easier to maintain. It just needs to parse `--/H`, `--/D`, `--/U` annotations from `CREATE TABLE` blocks and emit `INSERT DBObjects` / `INSERT DBColumns` statements.

- [ ] **Metadata workflow** — `pg2mos_descriptions.py` is a good start but needs improvement:
  - Utah should ideally provide `pg_schema_descriptions.sql` earlier so discrepancies can be caught before load
  - Coordinate column renames (reserved words etc.) between `pg2mssql.py` and `pg2mos_descriptions.py` — currently `COLUMN_RENAMES` is maintained in two places
  - Partition tables (`*_part1/part2`) have no column-level `--/D` annotations — ask Utah to add them
  - Consider having Utah supply a pre-validated descriptions file rather than raw pg dump

- [ ] **Avoid varchar(max) from the start**
  - Update pg2mssql.py to convert text → varchar(500) by default
  - Or analyze PostgreSQL source columns for actual max lengths
  - Document in export guidelines

- [ ] **MINIDB filegroup strategy**
  - Document filegroup separation (PRIMARY for system, MINIDB for data)
  - Include explicit ON [MINIDB] in all generated scripts
  - Makes database portable to other servers (BestDR20)

- [ ] **Automated varchar sizing**
  - Integrate varchar(max) analysis into schema conversion
  - Sample data before creating production tables
  - Generate appropriately-sized varchar() columns automatically

- [ ] **HTM index automation**
  - Script to automatically add HTM indexes to all tables with RA/DEC
  - Standard naming conventions (htmid, cx, cy, cz)
  - Document which tables need spatial indexes

- [ ] **Parallel data loading**
  - Identify independent tables that can load concurrently
  - Use multiple sessions to maximize throughput
  - Particularly useful for the INSERT...SELECT phase

- [ ] **Pre-index heap tables before loading to clustered tables**
  - **KEY INSIGHT:** Loading from heap → clustered table requires tempdb sort (very slow)
  - Create nonclustered indexes on PK columns in heap tables BEFORE INSERT...SELECT
  - Index scan delivers rows in sorted order → eliminates tempdb sort overhead
  - Trade-off: Index creation time vs massive sort time savings on large tables
  - Expected benefit: 2-3x faster loads for large unsorted tables
  - Process:
    1. Load CSV → heap tables (fast, no indexes)
    2. Create nonclustered indexes on heap PK columns (30-60 min for large tables)
    3. INSERT...SELECT from heap → clustered (fast, pre-sorted via index scan)
    4. Drop heap tables when complete
  - Observed performance: Without indexes: 30-40 MB/s (5+ hours for 650GB)
  - Expected with indexes: 100-150 MB/s (1-2 hours for same data)

---

### 12. BestDR20 Columnstore Experiment

- [ ] **Clustered Columnstore Index (CCI) version of BestDR20**
  - Experiment already done on native DR20 tables (PhotoObjAll etc.) with excellent results
  - PhotoObjAll: 1.23B rows, ~5 TB total (3.1 TB data + 1.87 TB indexes)
  - CCI expected to reduce to ~600 GB - 1 TB total (5-8x compression on float-heavy data)
  - Most NCIs become redundant with CCI — drop them
  - **Cone search fix**: Add nonclustered rowstore index on `htmid` alongside CCI
    - Optimizer uses rowstore for spatial range predicate, columnstore for everything else
    - Tested and confirmed to work well
  - Apply to largest tables first: PhotoObjAll, SpecObjAll, etc.
  - Also worth proposing to Utah: denormalized mos_* schema designed for query performance
    - Highly normalized minidb schema requires 50-table joins for common queries
    - Read-only SkyServer use case calls for denormalized, analytics-friendly design
    - CCI would compound the performance gains on a denormalized schema

---

## Notes

**Current Databases:**
- **minidb_dr20_v2** (D: drive RAID-0): 171 dr20_* tables, ~999 GB data, PAGE compression on 16 tables
- **BestDR20** (renamed from BestDR19): 171 mos_* tables, PAGE compression on 73 tables (>= 1M rows), NCIs in progress

**Key Files (BestDR20):**
- mssql_tables_0603.sql - Canonical schema with all varchar fixes, 171 tables (14 WIP tables removed)
- fix_tables_schema.py - Generates mssql_tables_0603.sql from mssql_tables_0116.sql
- gen_bestdr20.py - Generates all bestdr20_*.sql scripts from schema/pk/index files
- bestdr20_tables.sql - CREATE TABLE with mos_ prefix, ON [MINIDB]
- bestdr20_pk.sql - PKs with PAGE compression on 73 large tables
- bestdr20_load.sql - INSERT...SELECT WITH (TABLOCK), includes TRUNCATE
- bestdr20_indexes.sql - 992 NCIs (carton_csv indexes removed)

**Key Files (minidb_dr20_v2):**
- mssql_tables_0116.sql - Fixed varchar(max) columns (superseded by mssql_tables_0603.sql)
- mssql_pk_0112.sql - PKs with ON [MINIDB] and compression
- mssql_indexes_0112_portable.sql - 992 nonclustered indexes with ON [MINIDB]
- mssql_fk_0112.sql - 102 foreign keys
- load_from_heap_tables.sql - Data load script (complete)

**Performance Notes:**
- RAID-0 throughput: Peak 1.8 GB/s during INSERT...SELECT
- Expected load time: 30-60 minutes for ~999 GB
- Index creation: 2-4 hours estimated
- PAGE compression: Expected 50-70% savings on large tables

**Reference Documents:**
- session_summary_20260115.md - Previous session (6 corrected files loaded)
- session_summary_20260116.md - This session (production build on D: drive)
- CLAUDE.md - Repository guidance and best practices
