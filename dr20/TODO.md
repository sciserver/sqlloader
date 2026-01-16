# DR20 Loading - TODO List

**Last Updated:** December 17, 2024

---

## Immediate Actions (Blocked - Waiting for Utah)

- [ ] **Send regeneration request email to Utah team**
  - Use draft from session_summary_2024-12-17.md
  - Request 4 files with pipe delimiters + NaN→NULL
  - Get ETA for regenerated files

- [ ] **Wait for regenerated CSV files from Utah**
  - dr20_field (28.4 MB)
  - dr20_gaia_dr3_nss_two_body_orbit (329.3 MB)
  - dr20_gaia_dr3_vari_rrlyrae (158.5 MB)
  - dr20_sdss_apogeeallstarmerge_r13 (367.4 MB)

---

## After Receiving Regenerated Files

### 1. Update bulk_loader.py for Pipe Delimiters

- [ ] Add `--delimiter` parameter to bulk_loader.py
  - Support comma (,) - default
  - Support pipe (|) - for special files
  - Auto-detect from first line? (optional enhancement)

- [ ] Create file list of pipe-delimited tables
  - dr20_allstar_dr17_synspec_rev1 (existing)
  - dr20_field (regenerated)
  - dr20_gaia_dr3_nss_two_body_orbit (regenerated)
  - dr20_gaia_dr3_vari_rrlyrae (regenerated)
  - dr20_sdss_apogeeallstarmerge_r13 (regenerated)

### 2. Test Regenerated Files

- [ ] Test 4 regenerated files in test mode (10 rows)
  ```bash
  cd "H:\GitHub\sqlloader\dr20"

  # Test with pipe delimiter
  python bulk_loader.py "E:\DR20\minidb_dr20\casload" . \
    --test-mode --delimiter "|" \
    --files dr20_field,dr20_gaia_dr3_nss_two_body_orbit,dr20_gaia_dr3_vari_rrlyrae,dr20_sdss_apogeeallstarmerge_r13 \
    --connection "Server=localhost;Database=minidb_dr20;Trusted_Connection=yes"
  ```

- [ ] Verify NaN values were replaced with NULL
  - Check sample data in test_results
  - Query loaded rows to confirm NULL instead of "NaN"

- [ ] Regenerate full bulk insert SQL
  ```bash
  python bulk_loader.py "E:\DR20\minidb_dr20\casload" . \
    --test-mode --generate-sql \
    --connection "Server=localhost;Database=minidb_dr20;Trusted_Connection=yes" \
    --date MMDD
  ```

---

## Full Data Load (After Testing Passes)

### 3. Execute Production Data Load

- [ ] **Backup database before loading** (if needed)

- [ ] **Load comma-delimited files (157 files)**
  - Option A: Execute mssql_bulk_insert_1217.sql in SSMS
  - Option B: Run bulk_loader.py without --test-mode
  - Estimated time: 2-4 hours for 782.8 GB

- [ ] **Load pipe-delimited files (5 files)**
  - Create separate bulk insert script with FIELDTERMINATOR='|'
  - Load dr20_allstar_dr17_synspec_rev1 (5.5 GB)
  - Load 4 regenerated files (~883.6 MB)
  - Estimated time: 30-60 minutes

- [ ] **Verify row counts**
  ```sql
  -- Compare row counts to source CSV files
  SELECT
    t.name AS table_name,
    SUM(p.rows) AS row_count
  FROM sys.tables t
  INNER JOIN sys.partitions p ON t.object_id = p.object_id
  WHERE t.name LIKE 'dr20_%' AND p.index_id IN (0,1)
  GROUP BY t.name
  ORDER BY row_count DESC;
  ```

---

## Database Objects Creation

### 4. Create Primary Keys

- [ ] Review mssql_pk_1217.sql for any issues

- [ ] Execute primary key creation
  ```sql
  -- In SSMS, execute:
  -- H:\GitHub\sqlloader\dr20\mssql_pk_1217.sql
  ```

- [ ] **Note:** 16 tables have PAGE compression on PKs
  - Tier 1 (>20 GB): 12 tables
  - Tier 2 (10-20 GB): 4 tables
  - Expected space savings: 200-300 GB

- [ ] Verify all PKs created successfully
  ```sql
  SELECT
    t.name AS table_name,
    i.name AS pk_name,
    p.data_compression_desc
  FROM sys.tables t
  INNER JOIN sys.indexes i ON t.object_id = i.object_id
  INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
  WHERE i.is_primary_key = 1 AND t.name LIKE 'dr20_%'
  ORDER BY t.name;
  ```

### 5. Create Indexes

- [ ] Review mssql_indexes_1217.sql

- [ ] **Note:** 53 tables missing q3c spatial indexes
  - q3c_ang2ipix is PostgreSQL-specific
  - Need HTM functions or SQL Server spatial indexes
  - Document which tables need spatial indexes

- [ ] Execute index creation (992 indexes)
  ```sql
  -- In SSMS, execute:
  -- H:\GitHub\sqlloader\dr20\mssql_indexes_1217.sql
  ```

- [ ] **Note:** Some computed column indexes may fail
  - E.g., parallax - parallax_error
  - Create persisted computed columns first if needed

- [ ] Monitor index creation progress
  - This will take several hours for large tables
  - Check for errors and document any failures

### 6. Create Foreign Keys

- [ ] Review mssql_fk_1217.sql (102 foreign keys)

- [ ] **Known Issue:** Some FKs may fail due to orphaned records
  - Document from DR19: Some catalog_to_* tables have orphaned references
  - Check for orphaned records before creating FK:
  ```sql
  SELECT target_id
  FROM dr20_catalog_to_[table_name]
  WHERE target_id NOT IN (SELECT pk FROM dr20_[table_name]);
  ```

- [ ] Execute foreign key creation
  ```sql
  -- In SSMS, execute:
  -- H:\GitHub\sqlloader\dr20\mssql_fk_1217.sql
  ```

- [ ] Document any FKs that fail
  - Add to issues.md with details
  - Decide whether to fix data or skip FK

---

## Spatial Indexes (Optional - Deferred)

### 7. Add HTM Spatial Indexes

- [ ] Review htm/ directory for CLR stored procedures

- [ ] Identify tables with RA/DEC columns needing spatial indexes
  - 53 tables from mssql_indexes_1217.sql have q3c indexes commented out
  - Prioritize large catalog tables

- [ ] Deploy HTM functions
  ```bash
  cd H:\GitHub\sqlloader\htm
  # Run install.bat or spSphericalDeploy.sql
  ```

- [ ] Add HTM indexes to key tables
  ```sql
  -- Example:
  ALTER TABLE dr20_catalog ADD htmid bigint;
  UPDATE dr20_catalog SET htmid = dbo.fHtmEq(ra, dec);
  CREATE INDEX dr20_catalog_htmid_idx ON dr20_catalog(htmid);
  ```

---

## Metadata Loading (Optional)

### 8. Load Database Metadata

- [ ] Load table/column descriptions
  ```sql
  -- H:\GitHub\sqlloader\schema\csv\loaddbobjects.sql
  ```

- [ ] Load algorithm documentation
  ```sql
  -- H:\GitHub\sqlloader\schema\csv\loadalgorithm.sql
  ```

- [ ] Load glossary
  ```sql
  -- H:\GitHub\sqlloader\schema\csv\loadglossary.sql
  ```

- [ ] Load extended table descriptions
  ```sql
  -- H:\GitHub\sqlloader\schema\csv\loadtabledesc.sql
  ```

---

## Validation & Documentation

### 9. Final Validation

- [ ] **Verify total row counts match expected**
  - Compare to PostgreSQL source if available
  - Compare to CSV line counts

- [ ] **Check data integrity**
  - Sample random rows from large tables
  - Verify numeric values (no NaN)
  - Verify NULL handling is correct

- [ ] **Test key queries**
  - Cone searches (if HTM indexes added)
  - Common catalog joins
  - Performance benchmarks

- [ ] **Check database size**
  ```sql
  EXEC sp_spaceused;

  -- Per-table sizes
  SELECT
    t.name AS table_name,
    SUM(p.rows) AS row_count,
    SUM(a.total_pages) * 8 / 1024 / 1024 AS size_gb
  FROM sys.tables t
  INNER JOIN sys.indexes i ON t.object_id = i.object_id
  INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
  INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
  WHERE t.name LIKE 'dr20_%'
  GROUP BY t.name
  ORDER BY size_gb DESC;
  ```

### 10. Update Documentation

- [ ] Update issues.md with final notes
  - Document any skipped indexes
  - Document any orphaned FK issues
  - Document any data quality issues found

- [ ] Create final session summary
  - Total load time
  - Final statistics (rows, size, objects)
  - Any remaining issues or warnings

- [ ] Update CLAUDE.md if needed
  - Document any new lessons learned
  - Update NaN handling guidance
  - Update pipe delimiter guidance

---

## Git Commit

### 11. Commit DR20 Work

- [ ] Review all changes
  ```bash
  git status
  git diff
  ```

- [ ] Stage files for commit
  ```bash
  git add dr20/pg2mssql.py
  git add dr20/mssql_*_1217.sql
  git add dr20/test_results_1217.md
  git add dr20/mssql_bulk_insert_1217.sql
  git add dr20/session_summary_*.md
  git add dr20/TODO.md
  git add dr20/issues.md
  ```

- [ ] Create commit
  ```bash
  git commit -m "DR20: Fix varchar conversion bug, validate 157/171 files

  - Fixed pg2mssql.py varchar without size defaulting to varchar(1)
  - Regenerated schema with proper varchar(500) defaults
  - Validated 157 files (91.8% success rate)
  - Identified 4 files needing pipe delimiter + NaN→NULL
  - Documented issues and prepared Utah regeneration request

  🤖 Generated with Claude Code
  Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
  ```

- [ ] Push to remote (if applicable)
  ```bash
  git push origin dr20
  ```

---

## Future Enhancements (DR21 Planning)

### 12. Process Improvements for DR21

- [ ] **Use pipe delimiters for ALL files from the start**
  - Document in export guidelines
  - Avoids delimiter conflicts entirely

- [ ] **Standardize NaN handling in export process**
  - Add validation step in PostgreSQL export
  - Convert NaN→NULL automatically

- [ ] **Automated testing pipeline**
  - Script to detect delimiter mismatches
  - Script to validate data types
  - Script to check for NaN in numeric columns

- [ ] **Enhanced bulk_loader.py**
  - Auto-detect delimiter from file
  - Better error reporting with row/column samples
  - Parallel loading for independent tables
  - Automatic retry with adjusted parameters

- [ ] **Schema validation tool**
  - Compare PostgreSQL DDL to SQL Server DDL
  - Flag potential conversion issues before load
  - Validate data type mappings

---

## Notes

**Key Dependencies:**
- Utah team regeneration (blocking full load)
- Testing passes on regenerated files
- No blocking issues found during full load

**Estimated Timeline:**
- After receiving files: 1-2 days for testing and full load
- Index creation: 4-8 hours (depends on data volume)
- Total: 2-3 days for complete DR20 setup

**Critical Path:**
1. Utah regenerates 4 files → 2. Test files → 3. Full data load → 4. Create PKs → 5. Create indexes → 6. Create FKs

**Reference Documents:**
- session_summary_2024-12-16.md (previous session)
- session_summary_2024-12-17.md (this session)
- test_results_1217.md (detailed test results)
- CLAUDE.md (repository guidance)
