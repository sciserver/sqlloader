# What goes from the dr20 branch to master (draft, 2026-10-29)

dr20 is **never merged** into master. Master gets a branch built from master with only the paths
ticked below copied over from dr20 (`git checkout dr20 -- <paths>`). Everything else stays on
the dr20 branch.

`[x]` = goes to master, `[ ]` = stays on dr20. Tick or untick, then the master branch is built
from this list.

Rule: reusable code and the DR20 load work go to master; session notes, WIP and run output
stay. Files with **dr20 in the name** outside `dr20/` (section C) also go to master (decided
2026-11-05), so master can rebuild the DR20 VAC/Astra tables its loaders expect; clean up later
if needed.

## A. `dr20/` folder

### Conversion (PostgreSQL -> SQL Server)
- [x] `pg2mssql.py`
- [x] `pg2mos_descriptions.py`
- [x] `fix_tables_schema.py`
- [x] `pg_schema_descriptions.sql`
- [x] `create_minidb_descriptions_ms.sql`
- [x] `get_db_types.sql`
- [x] `mos_metadata/` (11 files: DBObjects/DBColumns metadata for mos and lvm)

### Canonical schema
- [x] `mssql_tables_0603.sql` (canonical: 171 tables, all fixes)
- [x] `mssql_pk_0112.sql`
- [x] `mssql_indexes_0112.sql`
- [x] `mssql_indexes_0112_portable.sql`
- [x] `mssql_fk_0112.sql`

### BestDR20 build
- [x] `create_production_db.sql`
- [x] `bestdr20_tables.sql`
- [x] `bestdr20_pk.sql`
- [x] `bestdr20_indexes.sql`
- [x] `bestdr20_load.sql`
- [x] `bestdr20_drop.sql`
- [x] `gen_bestdr20.py`
- [x] `build_photomain.sql`

### Loading
- [x] `bulk_loader.py`
- [x] `gen_spec_load.py`
- [x] `gen_vac_load.py`
- [x] `gen_vac_pk.sql`
- [x] `gen_apogee_move.py`
- [x] `run_vac_load.py` (the live unattended VAC loader)
- [x] `run_erosita_load.py`
- [x] `run_htm_add.py`
- [x] `run_update_stats.py`
- [x] `load_spec_tables.sql`
- [x] `load_vac_tables.sql`
- [x] `load_from_heap_tables.sql`
- [x] `move_apogee_tables.sql`
- [x] `vac_loaded.json` (record of which VAC tables completed)
- [x] `erosita_loaded.json` (same, eROSITA)
- [x] `htm_added.json` (same, HTM columns)

### Fixes applied during DR20
- [x] `fix_allspec_specobjid.sql`
- [x] `fix_clustered_keys.sql`
- [x] `fix_nearby_distance.sql`
- [x] `fix_nearest_orderby.sql`
- [x] `fix_spall_htm.sql`
- [x] `add_indexmap_allspec_nci.sql`
- [x] `add_indexmap_erosita.sql`
- [x] `allspec_nci.sql`
- [x] `cleanup_indexmap_stale.sql`
- [x] `drop_apogee_old_tables.sql`
- [x] `drop_boss_clam_params.sql`
- [x] `drop_metadata_fks.sql`
- [x] `recreate_metadata_fks.sql`
- [x] `verify_spatial.sql`
- [x] `verify_spatial_fixes.sql`

### Docs worth keeping
- [x] `issues.md`
- [x] `post_backup_fixes.md` (every change made after the 2026-07-28 backup)
- [x] `post_backup_runbook.md`
- [x] `compression_analysis.md`
- [x] `spcheckdbindexes_analysis.md`
- [x] `fk_analysis_report.md`
- [x] `FK_FAILURES_REPORT.md`

### Stays on dr20
- [ ] `archive/` (56 files: superseded schema iterations and one-off scripts)
- [ ] `CLAUDE.md`
- [ ] `TODO.md`
- [ ] `c_sqlloader_uncommitted_20261027.md`
- [ ] `master_manifest_20261029.md` (this file)
- [ ] `session_handoff_20260802.md`
- [ ] `session_summary_*.md` (15 files)
- [ ] `test_results_0112.md`, `test_results_0112b.md`, `test_results_1216.md`, `test_results_1217.md`
- [ ] `load_results_0113_0038.md`
- [ ] `stats_updated_localhost.json`, `stats_updated_sdss5a.json`, `stats_updated_sdss5b.json`
- [ ] `compare_file_sizes.py` (one-off check)
- [ ] `minidb_dr20_file_size.txt`
- [ ] `DR20 CAS loading status - Tables.csv`
- [ ] `dr20_loading_062406.csv`

## B. Shared folders (outside `dr20/`)

Files that differ between master and dr20.

### `schema/sql`
- [x] `ApogeeTables.sql`
- [x] `AstraTables.sql`
- [x] `IndexMap.sql`
- [x] `LvmTables.sql` (on master since `e3cf3d0`, Ani 07-28; dr20 drops an empty 2016 history line, 2026-11-05)
- [x] `MastarTables.sql`
- [x] `mosTables.sql`
- [x] `resolveTables.sql`
- [x] `SpectroTables.sql`
- [x] `VacTables.sql`
- [x] `spNearby.sql`
- [x] `spPublish.sql`
- [x] `spValidate.sql`
- [x] `dropAstra.sql`
- [x] `create_minidb_descriptions_ms.sql`
- [x] `xschema.txt`
- [x] `xschema_mos.txt`
- [x] `spiders_quasar.sql` (**deleted** on dr20; ticking it deletes it on master)

### `schema/csv`
- [x] `loaddbcolumns.sql`, `loaddbobjects.sql`, `loaddbviewcols.sql`
- [x] `loaddependency.sql`, `loadhistory.sql`, `loadinventory.sql`
- [x] `vac/` (3 files: VAC versions of the loaddb* scripts)

### `schema/etc`, `schema/patches`
- [x] `etc/loadMetadata.sql`
- [x] `etc/setVersion.sql`
- [x] `patches/03-perms.bestdrx.sql`

### `vbs`
- [x] `csvrobot.vbs`
- [x] `parseSchema2sql.py` (new)
- [x] `README.md` (new)
- [x] `xschema.txt`
- [x] `xschema_vac.txt` (new; UTF-16, so git shows it as binary)

### Other
- [x] `loadadmin/loadsupport-sp.sql`
- [x] `htm/spXYZ.sql`
- [x] `.gitignore`

### Stays on dr20
- [ ] `schema/log/lumberjack_2026/` (14 files: weblog investigation notes and findings)

## C. dr20 in the name, outside `dr20/` (go to master, decided 2026-11-05)

- [x] `schema/sql/dr20vacs/` (35 files: DR20 VAC table scripts, `IndexMapDR20VACs.sql`, `VacTablesDR20.sql`)
- [x] `schema/sql/astra_dr20/` (15 files: bossnet, slam, snowwhite, mwm_*, ...)
- [x] `schema/sql/allspecDR20.sql`
- [x] `schema/sql/spall_allepoch_dr20.sql`
- [x] `schema/sql/spall_epoch_dr20.sql`

## Not on either branch

- `dr20/DR20 schema description discrepancies (f.txt` (untracked)
- `C:\sqlloader\admin\connection.js` (machine-specific edit, `SDSSAD2` -> `SDSS5B`)
- Logs and `*.out` files in `dr20/` (gitignored)

## Next release (DR21): how to proceed

1. **Each time master is updated:** build a branch from master, copy the ticked paths from dr20
   (`git checkout dr20 -- <paths>`), and open a PR to master.
2. **Right after that PR merges, merge master back into dr20** (`git checkout dr20`, then
   `git merge master`). The contents are identical at that point, so the merge is clean, and it
   records the common point for later merges. If you skip this, the next merge compares
   against DR19 and every file edited on dr20 since the copy conflicts.
3. **To start DR21:** merge master into dr20 one last time, then branch `dr21` off `dr20`. dr21
   starts with all of dr20's notes and WIP, history included.
4. Copy this file to `dr21/master_manifest_<date>.md` and update it as DR21 goes. The dr20 files
   already on master aren't affected.
