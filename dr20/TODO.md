# DR20 Loading - TODO List

**Last Updated:** July 27, 2026

State below was verified by querying BestDR20 directly on 2026-07-27, not
carried forward from earlier notes.

---

## Current Status

**BestDR20 is substantially complete.** 392 user tables across 8 filegroups:

| Filegroup | Tables | Contents |
|---|---|---|
| MINIDB | 172 | `mos_*` tables — CI + PAGE compression + 992 NCIs |
| SPEC | 100 | spAll, allspec, astra/VAC tables |
| DATAFG | 69 | general data tables |
| PRIMARY | 41 | metadata and system tables — **plus 10 that do not belong there, see below** |
| PHOTO | 6 | photometric |
| WISE | 2 | |
| ATLAS, FRAME | 1 each | |

Done:
- 171 `mos_*` tables — CI, PAGE compression on the 73 tables at or above 1M rows, 992 NCIs
- SPEC tables: spAll, allspec (27.7M), multiplex, mwm_targets
- allspec NCIs — 6 created plus htmid
- 36 VAC tables via `run_vac_load.py`; 7 eROSITA tables; 10 HTM indexes
- spAll_epoch (4.9M), spAll_allepoch (507K), LVM_DAPall/DRPall, minesweeper (56K) — all on SPEC
- Astra boss tables (boss_net, corv, line_forest, m_dwarf_type, slam, snow_white, mwm_boss_*) — all on SPEC
- Metadata loaded: DBObjects 891, DBColumns 30,579, DBViewCols 234
- Repo cleaned up and committed (2026-07-27)

---

## Immediate Next Steps

### 1. Fix 10 APOGEE tables loaded onto the wrong filegroup as uncompressed heaps

**This is the highest-value item.** These tables bypassed the `gen_vac_load.py`
path and were loaded directly, so they got none of the standard treatment.
IndexMap already says what they should be — CI on `spectrum_PK`, PAGE
compression, filegroup SPEC — but on disk they are heaps, uncompressed, on
PRIMARY, occupying ~25.6 GB:

| Table | Rows | Current size |
|---|---|---|
| aspcap_apogee_star | 1,095,480 | 4.18 GB |
| astro_nn_apogee_star | 1,585,505 | 4.03 GB |
| lite_all_star | 1,365,542 | 3.47 GB |
| mwm_apogee_allvisit | 3,515,606 | 3.35 GB |
| the_payne_apogee_star | 1,111,879 | 2.13 GB |
| astro_nn_apogee_visit | 810,651 | 2.06 GB |
| the_payne_apogee_visit | 793,385 | 2.02 GB |
| apogee_net_apogee_star | 1,122,317 | 1.71 GB |
| astro_nn_dist_apogee_star | 1,112,053 | 1.70 GB |
| mwm_apogee_allstar | 1,122,272 | 1.00 GB |

They are also bloating PRIMARY, which is meant to hold metadata only.

- [ ] Re-run `gen_vac_load.py` for these 10 — it is IndexMap-driven, so it will
      generate DROP > CREATE ON [SPEC] > CI WITH PAGE > INSERT WITH TABLOCK
      with no hand-editing
- [ ] Source is BESTTEST via INSERT...SELECT (same as the other astra tables)
- [ ] Expect roughly 50-70% size reduction from PAGE compression
- [ ] Verify row counts against the table above afterwards
- [ ] Confirm PRIMARY shrinks back to metadata-only

Verification query:
```sql
USE BestDR20;
SELECT t.name, i.type_desc, p.data_compression_desc, fg.name AS filegroup_name,
       SUM(p.rows) AS rows
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id AND i.index_id IN (0,1)
JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.data_spaces fg ON i.data_space_id = fg.data_space_id
WHERE t.name LIKE '%apogee%' OR t.name = 'lite_all_star'
GROUP BY t.name, i.type_desc, p.data_compression_desc, fg.name
ORDER BY t.name;
```

### 2. Add the 6 allspec NCIs to IndexMap

IndexMap has only the `code='K'` PK row for allspec. All 6 nonclustered indexes
exist on disk but are undocumented, so a rebuild from IndexMap would silently
drop them.

- [ ] Insert 6 rows with `code='I'`, `compression='page'`, `filegroup='SPEC'`:
      `ix_allspec_apogee_id`, `ix_allspec_apstar_id`, `ix_allspec_mangaid`,
      `ix_allspec_sdssid`, `ix_allspec_specobjid`, `ix_allspec_mjd_fiberid_plate`
- [ ] Definitions are in `dr20/allspec_nci.sql`
- [ ] `ix_allspec_htmid` also exists on disk — check whether it is in IndexMap
      under a different tableName spelling before adding a duplicate

### 3. Re-enable the three disabled FK constraints on DBObjects

Disabled during the metadata load and never turned back on:

- `fk_DBColumns_tablename_DBObjects`
- `fk_DBViewCols_viewname_DBObjects`
- `fk_Inventory_name_DBObjects_name`

```sql
USE BestDR20;
ALTER TABLE DBColumns  WITH CHECK CHECK CONSTRAINT fk_DBColumns_tablename_DBObjects;
ALTER TABLE DBViewCols WITH CHECK CHECK CONSTRAINT fk_DBViewCols_viewname_DBObjects;
ALTER TABLE Inventory  WITH CHECK CHECK CONSTRAINT fk_Inventory_name_DBObjects_name;
```

`WITH CHECK CHECK` re-validates existing rows and clears `is_not_trusted`. If it
fails, there are orphaned metadata rows to clean up first. Note that ~29 other
FKs across the DB are enabled but `is_not_trusted` — that is expected from bulk
loads and does not affect correctness, only optimizer plan choices.

### 4. Load `the_cannon_apogee_star`

Has an IndexMap entry (CI on `spectrum_PK`, PAGE, SPEC) but does not exist in
BestDR20. Was still loading in BESTTEST as of June. Load it with the other 10
in step 1 if it is ready.

### 5. multiplex NCIs

Waiting on the column list from the tool owner. multiplex currently has only its
CI on `multiplex_id`.

---

## Repo / Git

- [x] Clean up dr20 branch — archive superseded files, gitignore run output (2026-07-27)
- [ ] Cherry-pick commit `89a9784` (parseSchema2sql.py + vbs/README.md +
      xschema.txt) to master — it is deliberately isolated for this
- [ ] Push dr20 branch to origin
- [ ] Decide whether the rest of dr20 merges to master or stays on the branch

---

## Validation

- [ ] Row count comparison against BESTTEST for the migrated tables
- [ ] Spot-check data integrity on large tables (numeric values, NULL handling)
- [ ] Test cone searches against the HTM-indexed tables
- [ ] Final `sp_spaceused` and per-filegroup size report once step 1 is done

---

## Future Enhancements (DR21 Planning)

### Process improvements

- [x] **Replace `parseSchema2sql.vbs` with Python** — done, `vbs/parseSchema2sql.py`,
      ~1 second vs 15 minutes, validated against VBS output

- [ ] **Everything goes through the IndexMap-driven loader.** The step 1 problem
      above happened because 10 tables were loaded outside `gen_vac_load.py`.
      IndexMap had the right answer the whole time. Make the IndexMap-driven
      path the only path, and add a post-load check that fails loudly when a
      table's actual filegroup, compression or index type disagrees with its
      IndexMap row.

- [ ] **Metadata workflow** — `pg2mos_descriptions.py` needs:
  - Utah to supply `pg_schema_descriptions.sql` earlier, so discrepancies are
    caught before the load rather than after
  - `COLUMN_RENAMES` is maintained in both `pg2mssql.py` and
    `pg2mos_descriptions.py` — consolidate to one place
  - Partition tables (`*_part1/part2`) have no column-level `--/D` annotations

- [ ] **Avoid varchar(max) from the start** — convert text to varchar(500) by
      default in `pg2mssql.py`, or analyze PG source columns for real max lengths

- [ ] **Automated varchar sizing** — fold the sampling analysis into schema
      conversion instead of running it as a post-hoc repair

- [ ] **HTM index automation** — script to add htmid/cx/cy/cz and indexes to
      every table with RA/DEC, with standard naming

- [ ] **Parallel data loading** — identify independent tables and load them
      concurrently, particularly during INSERT...SELECT

- [ ] **Pre-index heap tables before loading to clustered tables**
  - Loading heap to clustered requires a tempdb sort, which dominates the time
  - Creating an NCI on the PK columns of the heap first lets the index scan
    deliver rows already sorted
  - Observed without: 30-40 MB/s. Expected with: 100-150 MB/s

### BestDR20 columnstore experiment

- [ ] **Clustered Columnstore Index version of BestDR20**
  - Already tried on native DR20 tables with excellent results
  - PhotoObjAll: 1.23B rows, ~5 TB (3.1 TB data + 1.87 TB indexes); CCI expected
    to bring that to ~600 GB - 1 TB on float-heavy data
  - Most NCIs become redundant under CCI — drop them
  - **Cone search fix**: add a nonclustered rowstore index on `htmid` alongside
    the CCI. The optimizer uses rowstore for the spatial range predicate and
    columnstore for everything else. Tested, works well.
  - Worth proposing to Utah: a denormalized `mos_*` schema. The highly
    normalized minidb schema needs 50-table joins for common queries, and the
    read-only SkyServer use case calls for an analytics-friendly design. CCI
    would compound the gains.

---

## Notes

**Databases:**
- **BestDR20** — the production target. 392 tables across 8 filegroups.
- **minidb_dr20_v2** (D: RAID-0) — 171 `dr20_*` tables, ~999 GB, superseded by
  BestDR20 for `mos_*` content
- **BESTTEST** — staging source for the migration

**Key files:**
- `mssql_tables_0603.sql` — canonical schema, 171 tables, all varchar fixes
- `gen_bestdr20.py` — generates the four `bestdr20_*.sql` scripts
- `gen_vac_load.py` — IndexMap-driven loader generator; use this for step 1
- `gen_spec_load.py` — the original DROP > CREATE > CI > INSERT pattern
- `run_vac_load.py`, `run_htm_add.py`, `run_erosita_load.py` — unattended
  executors, resumable via `*_loaded.json`
- `pg2mos_descriptions.py` + `vbs/parseSchema2sql.py` — metadata pipeline
- `dr20_loading_062406.csv` — master tracking spreadsheet
- `dr20/archive/` — superseded files, see its README

**Conventions:**
- Create the CI with PAGE compression on the target filegroup *before* loading.
  Never build a heap and rebuild it later — that bloats PRIMARY.
- PAGE compression at 1M rows and above.
- `GO` after every CREATE INDEX so one failure does not abort the batch.
