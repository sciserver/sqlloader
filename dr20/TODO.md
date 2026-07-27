# DR20 Loading - TODO List

**Last Updated:** July 27, 2026 (loading complete)

State below was verified by querying BestDR20 directly on 2026-07-27, not
carried forward from earlier notes.

---

## Current Status

**Loading is complete.** 400 user tables across 8 filegroups. Something may still
sneak in under the wire, and a missing index may turn up here and there, but the
bulk load is done.

| Filegroup | Tables | Contents |
|---|---|---|
| MINIDB | 172 | `mos_*` tables — CI + PAGE compression + 992 NCIs |
| SPEC | 118 | spAll, allspec, astra/VAC, APOGEE, eFEDS/eROSITA tables |
| DATAFG | 69 | general data tables |
| PRIMARY | 31 | metadata and system tables |
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
- 10 APOGEE tables moved from PRIMARY heaps to SPEC with clustered PKs (2026-07-27)
- 8 VAC tables loaded that had been missed entirely — 2 DL1_eROSITA_eRASS3_*
  and 6 efeds_spiders_agn_* (2026-07-27). All 29 entries in the VAC loading
  manifest now match by name and row count.
- Metadata loaded: DBObjects 891, DBColumns 30,579, DBViewCols 234
- Repo cleaned up, committed and pushed (2026-07-27)

**Filegroup sizing:** this is a write-once, read-only database. Once a DR is
loaded it does not grow, so filegroups are *meant* to end up full — allocated
but unused space is waste. SPEC at 446.29/446.50 GB is the desired end state,
not a problem.

---

## Immediate Next Steps

### 1. ~~APOGEE tables on PRIMARY as uncompressed heaps~~ — DONE 2026-07-27

Ten tables carried over in the BestDR19 to BestDR20 rename had never been
rebuilt, so they sat on PRIMARY as uncompressed heaps (13.6M rows, 25.65 GB).
Moved to SPEC with clustered primary keys named `pk_<table>_spectrum_pk`,
PAGE compression on the 8 at or above 1M rows. 25.65 GB became 18.07 GB.

Scripts: `gen_apogee_move.py` -> `move_apogee_tables.sql`, then
`drop_apogee_old_tables.sql` for the renamed originals. The move created the PK
before loading so rows landed in key order already compressed, verified row
count and key checksum before any rename, and kept the originals as `<t>_old`
until verified.

**These tables are not reloaded from BESTTEST.** The DR19 APOGEE products are
what ships for DR20. They therefore keep the vestigial `PK` column that the
newer BESTTEST schema drops — the move was deliberately faithful to the
existing schema. If that column should not ship, dropping it is a separate
decision.

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

### 4. `the_cannon_apogee_star` — almost certainly not in DR20

Has an IndexMap entry (`spectrum_PK`, PAGE, SPEC) but no table in BestDR20 and
0 rows in BESTTEST. That is the same profile as the products struck out on the
source spreadsheet, so it is very likely struck out too.

- [ ] Confirm against the spreadsheet, then drop the stale IndexMap row so a
      rebuild does not expect a table that will never exist.

### 5. multiplex NCIs

Waiting on the column list from the tool owner. multiplex currently has only its
CI on `multiplex_id`.

### 6. Reclaim unused space in PRIMARY — end-of-load step

PRIMARY is 190.54 GB allocated, 117.66 GB used, **72.88 GB free** (61.8% used).
Moving the APOGEE tables out opened ~25.6 GB of that; the rest predates this
release — the file is still named `BESTDR8_Data1`.

Since the database is write-once and read-only, allocated-but-unused space is
pure waste, and a one-time shrink after loading carries none of the usual
fragmentation cost because nothing is modified afterwards.

- [ ] Confirm nothing further is going to land on PRIMARY
- [ ] `DBCC SHRINKFILE (BESTDR8_Data1, <target>)` to a small headroom margin
- [ ] Re-check every other filegroup for the same waste — SPEC is already at
      99.95%, which is correct; the others are worth a look

### 7. VAC table list — verified 2026-07-27

Checked the published VAC table list (41 entries) against BestDR20:
**39 present**, all on SPEC with clustered indexes and row counts matching
source exactly.

**DL1 naming — resolved, no action.** The published list showed
`DL1_spec_SDSSV_eROSITA_eRASS3_*`, but **the loading manifest name is
canonical**: `DL1_eROSITA_eRASS3_*`. That is what BESTTEST, IndexMap, the
existing eRASS1 pair and BestDR20 all use, so nothing needs renaming. If the
published list is regenerated, it should use the short form.

**`efeds_spiders_agn_classification_props` — not in DR20, closed.** It is
struck out on the source spreadsheet; the strikethrough was lost when the list
was copied. Same for `efeds_spiders_agn_xray_spec_props`. Both have 0 rows in
BESTTEST and no IndexMap entry, which is consistent — nothing to do.

**Useful signal:** the struck-out products are exactly the ones with 0 rows in
BESTTEST. An empty BESTTEST source reliably means "not shipping", which is what
the empty-source guard in `run_vac_load.py` now enforces automatically.

---

## Repo / Git

- [x] Clean up dr20 branch — archive superseded files, gitignore run output (2026-07-27)
- [x] Push dr20 branch to origin (2026-07-27)
- [ ] Cherry-pick commit `89a9784` (parseSchema2sql.py + vbs/README.md +
      xschema.txt) to master — it is deliberately isolated for this
- [ ] Decide whether the rest of dr20 merges to master or stays on the branch

---

## Validation

- [ ] Spot-check data integrity on large tables (numeric values, NULL handling)
- [ ] Test cone searches against the HTM-indexed tables
- [ ] Sweep for missing indexes — the most likely remaining gap now that loading
      is done. Compare `sys.indexes` against IndexMap per table; the allspec
      NCIs in step 2 were found exactly this way.
- [ ] Final `sp_spaceused` and per-filegroup size report

---

## Future Enhancements (DR21 Planning)

### Process improvements

- [x] **Replace `parseSchema2sql.vbs` with Python** — done, `vbs/parseSchema2sql.py`,
      ~1 second vs 15 minutes, validated against VBS output

- [ ] **Decide what IndexMap is actually authoritative for.** Right now it is
      half-trusted, which is the worst of both. Measured 2026-07-27 across the
      294 tables with a `code='K'` row and a compression value set:

      - **Compression — sound.** IndexMap says PAGE for essentially everything
        with a filegroup assigned (275 `page`/SPEC + 30 `PAGE`/PHOTO; the 40
        blanks are legacy CAS system tables). But 116 tables are uncompressed
        on disk, totalling 2,378 GB. 102 of those are below 1M rows, i.e. the
        loaders' row-count threshold overriding IndexMap; the other 14 were
        simply missed. Worth adopting IndexMap and dropping the threshold.
      - **Filegroup — not sound.** Only 97 of 294 tables sit where IndexMap
        says. It claims SPEC for 129 `mos_*` tables that correctly live on
        MINIDB by design, plus PHOTO for tables on DATAFG/WISE/ATLAS/FRAME.
        The column looks like a stale default that never tracked the real
        placement scheme. `run_vac_load.py` hardcoding `FILEGROUP='SPEC'` is
        the safer behaviour; following IndexMap here would scatter tables.

      Either fix the filegroup column or stop reading it. Then add a post-load
      check that flags any table whose actual compression or index type
      disagrees with its IndexMap row.

- [ ] **Consolidate the two VAC loaders.** `gen_vac_load.py` (writes SQL for
      SSMS) and `run_vac_load.py` (executes unattended, with `--force` and
      `vac_loaded.json` tracking) implement the same pattern and have drifted:
      different filegroup sources, different compression rules. Neither reads
      IndexMap's `compression` column. `run_vac_load.py --dry-run` already
      prints the exact SQL, so the SSMS path could be `--dry-run > load.sql`
      rather than a second implementation.

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
- `gen_apogee_move.py` + `move_apogee_tables.sql` — PRIMARY heap to SPEC move
- `drop_apogee_old_tables.sql` — self-verifying cleanup of the `_old` originals
- `gen_vac_load.py` — IndexMap-driven loader generator (superseded by run_vac_load.py)
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
