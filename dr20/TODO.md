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

### 0a. ~~`allspec.specobjid` is varchar, should be numeric~~ — FIXED 2026-07-29

**Fixed 2026-07-29** via `dr20/fix_allspec_specobjid.sql`: converted in place to
`numeric(30,0)` NULL, 27,671,504 rows, value fingerprint unchanged, all 8
indexes intact. `SpectroTables.sql` corrected in the same pass.

**Not `numeric(20)`.** Matching `SpecObjAll` would have overflowed 10,766,741
rows — allspec carries a union of legacy 18–20 digit ids and SDSS-V 25–29 digit
ids, so `numeric(30,0)` (matching `spAll`) is the only type that holds them all.

Route was ALTER in place, not the drop-and-reload originally favoured: BESTTEST's
own `allspec.specobjid` is *also* `varchar(29)`, so a reload fixes nothing on its
own, and allspec's NCIs are missing from IndexMap so a reload risks losing them.

- [ ] **Still to do:** Ani re-runs the CasJobs piece
- [ ] **Still to do:** apply to the restored copies on sdss5a/sdss5b — see
      `dr20/post_backup_fixes.md`
- [ ] BESTTEST still has `varchar(29)`; out of scope for go-live

The original analysis follows, for the record.

| | |
|---|---|
| Current | `varchar(29)`, nullable |
| Should be | `numeric(30,0)` — matches `spAll`, `spAll_epoch`, `spAll_allepoch` |
| Values | 18-29 digits, max `13772942901091276070601060201` |
| Convertibility | **27,671,504 rows, 0 failures**, 0 empty strings, 0 leading zeros |

`bigint` will not do — 29 digits far exceeds its 19-digit range.

**Why it matters:** joins from allspec to spAll/SpecObjAll on `specobjid` force
an implicit varchar->numeric conversion, which can defeat an index seek on the
numeric side, and `specobjid = 1234...` unquoted behaves unexpectedly.
`fGetNearbyAllspecXYZ` already declares `specobjid numeric(30)` in its RETURNS
clause, so it is doing that conversion on every row today.

**Two routes — the user leaned toward the second:**

1. **ALTER in place.** Drop `ix_allspec_specobjid` -> `ALTER COLUMN` ->
   recreate index. ~10-20 min on 15.10 GB / 27.7M rows. Then `SpectroTables.sql`
   must be corrected *separately* or the next load regresses it.
2. **Drop and reload from BESTTEST** with the correct type in the CREATE TABLE.
   Fixes the table and the schema source in one pass, and the load path is
   already exercised. Likely the better option, and worth checking what
   BESTTEST's own `allspec.specobjid` type is before deciding.

Either way:
- [ ] Correct `specobjid` in `C:\sqlloader\schema\sql\SpectroTables.sql`
- [ ] Ani re-runs the CasJobs piece afterwards
- [ ] allspec's HTM columns and its 6 NCIs must survive or be recreated —
      note `ix_allspec_*` indexes are still absent from IndexMap (TODO item 2),
      so a reload driven from IndexMap would silently drop them
- [ ] SPEC has only ~1.5 GB free; either route will autogrow the filegroup

### 00. ~~spAll htmid/cx/cy/cz computed from a null sentinel~~ — FIXED 2026-07-28

**Found and fixed 2026-07-28**, via `dr20/fix_spall_htm.sql`. Rebuilt from
`racat`/`deccat`; 5,357,037 rows updated in 8.8 min, `ix_spAll_htmid` rebuilt.

| | before | after |
|---|---:|---:|
| biggest htmid pile | 4,905,907 | **172** |
| cone search finds a known spAll object | 0 rows | **1 row** |
| cone search at the bogus ra=81/dec=81 | 4.9M spurious | **0** |
| distinct htmid | 1 + tail | 3,223,326 |

The 4 wrong-distance functions were fixed at the same time (see below), and
verified: reported distances now match true great-circle separation to 1e-6.

- [ ] **Still to do:** apply both fixes to the restored production copies on
      sdss5a and sdss5b — the 2026-07-28 backup predates them.
- [ ] **Still to do:** fix the source. spAll is not in `run_htm_add.py`'s
      `HTM_TABLES`, so the `plug_ra` choice came from the spAll load path —
      `gen_spec_load.py` / `load_spec_tables.sql`. Otherwise DR21 repeats it.

The original diagnosis follows, for the record.

`spAll.cx/cy/cz` and `htmid` were computed from **`plug_ra`/`plug_dec`**, which is
**-9999** for **4,905,907 of 5,357,037 rows (91.6%)**. `plug_*` is the old
plugmap column, superseded in SDSS-V by `fiber_ra`/`fiber_dec`; it now holds the
null sentinel. -9999 is a valid float, so nothing errored.

Consequences:

- All 4.9M bad rows share **one** htmid, `16776973019819`. Next most common
  value: 64 rows.
- Those rows are **invisible to cone search** — found by probing
  `fGetNearbySpAllEq` with coordinates taken straight out of spAll and getting
  zero rows back.
- cos/sin of -9999 degrees does not wrap somewhere harmless. It lands at
  **ra = 81.000, dec = 81.000**, an ordinary point in the northern sky, so a
  cone search near there returns **4.9M spurious rows at zero separation**.

**Use `racat`/`deccat`** (confirm with Ani, but the data question is settled):

- **Consistently ICRS** at `coord_epoch`. `fiber_ra`/`fiber_dec` is documented
  as *"J2000 for plate; at exp for FPS"* — a **mixed reference frame**, which
  would index high-proper-motion FPS-era targets at their observed epoch rather
  than a common frame.
- **`fGetNearbySpAllXYZ` already returns `racat`/`deccat`** as its `ra`/`dec`
  output columns. Indexing on them makes search and results agree; today the
  function indexes on `plug_*` and reports `racat`, and that inconsistency is
  how this survived unnoticed.
- **Zero invalid values** across all 5,357,037 rows — no nulls, no -9999, none
  out of range. Same for `fiber_*`. Only `plug_*` is broken. So no fallback or
  special-casing is needed.

(An earlier draft of this item recommended `fiber_ra`/`fiber_dec` on the basis
of "3 bad racat / 18 bad deccat values". That was a bad check — it treated
`0` as a sentinel, but RA=0 and Dec=0 are valid positions and those 21 rows are
simply objects on the celestial equator and at the RA origin.)

- [ ] `UPDATE spAll SET htmid = dbo.fHtmEq(racat, deccat), cx = ..., cy = ..., cz = ...`
      following the pattern in `run_htm_add.py` (5.4M rows, minutes)
- [ ] Rebuild `ix_spAll_htmid`
- [ ] Re-verify: probe `fGetNearbySpAllEq` with a known spAll position and
      confirm it returns the object; confirm no htmid has a large pile
- [ ] Fix the source: spAll is **not** in `run_htm_add.py`'s `HTM_TABLES`, so
      this came from the spAll load path — check `gen_spec_load.py` /
      `load_spec_tables.sql`
- [ ] Apply the same fix to the restored production copies. The 2026-07-28
      backup contains the bad spAll data, so sdss5a and sdss5b will each need
      it. No re-backup required — spAll is 7 GB of an 11.5 TB database, and
      pre-launch fixes are being applied in situ to the live copies.

#### Found 2026-07-29 by `dr20/verify_spatial.sql` — 4 open defects

The generalized spatial test suite (see below) found four things. None blocks
go-live; all are real.

- [ ] **3 `fGetNearest*Eq` return an arbitrary object, not the nearest.**
      `fGetNearestAllspecEq`, `fGetNearestApogeeDrpAllstarEq` and
      `fGetNearestSpAllEq` do `SELECT TOP 1` over the Nearby XYZ function with
      **no `ORDER BY distance`**. Their XYZ counterparts all have it. Inserting
      into a table variable in order does not guarantee reading it back in that
      order, so these are genuinely unreliable. Same three families as the
      radians bug fixed 2026-07-28. One-line fix each.
- [ ] **`fGetNearbyTiledTargetsEq` has never worked.** It joins a table called
      `TiledTarget`, which does not exist in BestDR20 — the real table is
      `sdssTiledTargetAll`. Deferred name resolution let it be created; every
      call fails with "Invalid object name 'TiledTarget'". This also makes
      `sdssTiledTargetAll`'s empty htmid moot — nothing can query it.
- [ ] **`mangaDRPall.htmid` is built from `ifura`/`ifudec`, but
      `fGetNearbyMangaObjEq` returns `objra`/`objdec`.** A mild version of the
      spAll bug: **483 of 11,273 rows (4.3%)** have an htmid that does not match
      their own reported position, so a cone search at the object position can
      miss them. The rest agree only because the IFU centre and the object
      usually fall in the same HTM triangle.
- [ ] `sdssTiledTargetAll.htmid` is 0 on all 1,056,872 rows. **Its `cx/cy/cz`
      are correct**, so only htmid was never populated.

**Corrections to the 2026-07-28 sweep:** it recorded `mos_mangadapall` and
`mos_mangadrpall` as "htmid = 0 on every row, no cx/cy/cz". For `mangaDRPall`
that is wrong — htmid is fully populated (0 zeros), just from the wrong columns.
Worth re-checking the other four tables in that list the same way.

#### Related, lower priority

Six tables have `htmid = 0` on every row — never populated:
`mos_sdss_dr17_specobj` (5.8M), `mos_sdss_dr16_specobj` (5.3M),
`sdssTiledTargetAll` (1.06M), `mos_mangadapall` (43k), `mos_mangadrpall` (11k),
`sdssTileAll` (1.9k). The last two have no `cx/cy/cz` at all. **No
`fGetNearby*` function reads any of them**, so nothing returns wrong answers —
an inert gap, not a live bug.

The other 29 tables with `htmid` are clean (largest pile 338 rows), including
PhotoObjAll 1.23B, mos_target 186.8M, Mask 35.5M, allspec 27.7M.

#### Also found: 4 of 9 `fGetNearby*XYZ` compute the returned distance wrong

`fGetNearbyAllspecXYZ`, `fGetNearbyApogeeDrpAllstarXYZ`, `fGetNearbyMosTargetXYZ`
and `fGetNearbySpAllXYZ` recompute distance from ra/dec **without converting
degrees to radians**, while `@nx/@ny/@nz` were built with the conversion. The
other 5 use the precomputed `cx/cy/cz` and are correct. The row *filter* uses
`cx/cy/cz` either way, so the right rows come back in the right order — only
the reported `distance` value is wrong.

- [ ] Change those 4 to use `cx/cy/cz` like the correct ones

#### And: generalise the fGetNearby family

22 `fGetNearby*` functions, ~95% boilerplate — only the table name and the
returned column list vary. T-SQL functions cannot take a table name or use
dynamic SQL, so a single generic TVF is impossible, but:

- **Generate them** from a table list, exactly like `run_htm_add.py`'s
  `HTM_TABLES`. Adding a table becomes a one-line dict entry.
- **Or document the generic join** — it already works on any table with
  htmid/cx/cy/cz and needs no new objects:

```sql
SELECT t.*, 2*DEGREES(ASIN(SQRT(POWER(@nx-t.cx,2)+POWER(@ny-t.cy,2)+POWER(@nz-t.cz,2))/2))*60 AS distance
FROM dbo.fHtmCoverCircleEq(@ra,@dec,@r) H
JOIN <any_table> t ON t.htmid BETWEEN H.HtmIDStart AND H.HtmIDEnd
WHERE POWER(@nx-t.cx,2)+POWER(@ny-t.cy,2)+POWER(@nz-t.cz,2) < POWER(2*SIN(RADIANS(@r/120)),2)
```

Generating them would have caught the spAll bug: the generator must be told
which ra/dec columns each table uses, making `plug_ra` a reviewable line of
data instead of something buried in a hand-written function.


### 0. Fix the metadata load: scoped upsert instead of whole-table TRUNCATE

**Highest priority — this one silently loses edits.**

`parseSchema2sql.py` is a per-file tool, but the SQL it emits begins with a
**whole-table** `TRUNCATE TABLE DBColumns` / `DBObjects`. Those two facts are
incompatible: regenerating one schema file forces a choice between wiping the
metadata for every other file, or skipping the TRUNCATE and living with stale
rows.

Skipping the TRUNCATE is not safe. `pk_DBColumns_tableName_name` is on
`(tablename, name)`, so:

| Case | What happens |
|---|---|
| New column | INSERT succeeds |
| **Changed description** | **PK violation, old text silently kept** |
| Removed column | stale row persists indefinitely |

The failures are indistinguishable from the thousands of expected duplicate
errors, so a swallowed edit is invisible in the output.

**The fix** — replace the global truncate with a delete scoped to the tables in
the current run:

```sql
DELETE FROM DBColumns WHERE tableName IN (<tables in this xschema file>);
DELETE FROM DBObjects WHERE name       IN (<same list>);
-- then the INSERTs as they are now
```

Re-running one file becomes idempotent and complete: edits land, removed
columns disappear, other files are untouched. Because it deletes children
before parents it also **never needs the FK-disabling workaround** used on
2026-07-24 (`ALTER TABLE ... NOCHECK CONSTRAINT ALL` on DBColumns, DBViewCols,
Inventory, IndexMap) — that workaround was a symptom of this same design.

- [x] Re-ran the full metadata (all 50 files, `xschema.txt`) on 2026-07-27
      rather than the VAC file alone, so the TRUNCATE is correct and nothing
      is swallowed. 901 objects / 31,306 columns / 234 viewcols, 0 orphans.
- [ ] Emit scoped DELETEs instead of TRUNCATE (~15 lines in the emitter).
      **Deferred 2026-07-28** — the batching went in first. Second argument
      for doing this: a scoped DELETE works with the foreign keys in place,
      whereas TRUNCATE requires dropping them (see item 3). It would also
      make a scoped DELETE on DBObjects pointless-but-harmless rather than
      necessary, since an object removed from a .sql file is simply absent
      from the run's scope and undetectable by scoping either way.

#### ~~The load is also far too slow~~ — DONE 2026-07-28

31,306 separate `INSERT` statements, each its own autocommit transaction.
That is 31,306 round trips and, more importantly, 31,306 synchronous
transaction-log flushes for about 4 MB of data. The flushes dominate.

- [x] **Multi-row `VALUES`** — 1,000 rows per INSERT, so DBColumns' 31,306
      statements collapse to 32. Output is still a plain .sql file.

- [x] **One explicit transaction per file, `TRUNCATE` included.** The plan was
      a commit per batch; wrapping the whole file is the same flush saving and
      also makes a mid-load failure roll back to the previously loaded
      contents, instead of leaving the table truncated and half populated.
      `SET XACT_ABORT ON` is what makes that hold for run-time errors, and no
      `GO` appears between `BEGIN` and `COMMIT` — splitting the transaction
      across batches would let statements after a failure run outside it.
      Tested by injecting a duplicate key: fails, exits non-zero, table keeps
      its previous rows, `@@TRANCOUNT` back to 0.

- [x] **A row-count assertion before `COMMIT`.** The truncate is inside the
      transaction, so the expected count is exactly what was emitted; anything
      else rolls back with a named error.

- [x] **Quoting** — moved out of the parser and applied once at emit time to
      *every* field. Object, column and view names were not being escaped at
      all, which was survivable at one row per statement and fatal to a
      1,000-row batch. Verified by decoding every emitted row back to tuples
      and diffing against the pre-change output: 901 / 31,306 / 234, identical.

- [x] **Duplicate keys deduped in Python, with a warning.** Forced by batching:
      one INSERT per row silently dropped a duplicate and carried on, but one
      duplicate fails an entire 1,000-row batch. The current schema has none,
      so this is purely defensive.

- [x] **Provenance header** — `-- generated by <script> <args> at <timestamp>`
      at the top of each file, taken from `sys.argv` as typed so it records
      which schema list was used. That is what determines the TRUNCATE's scope.

**Measured 2026-07-28**, same server and database, sqlcmd, full 50-file output:

| Script | Before | After | Speedup |
|---|---:|---:|---:|
| `loaddbobjects.sql` | 23,626 ms | 508 ms | 46x |
| `loaddbcolumns.sql` | 797,903 ms (13m 18s) | 11,349 ms | 70x |
| `loaddbviewcols.sql` | 3,147 ms | 189 ms | 17x |
| **total** | **13m 45s** | **12.0 s** | **68x** |

- [ ] Optional, bigger change: a `--load` flag writing straight to SQL Server
      via pymssql in one transaction, the way `run_vac_load.py` does. Fastest,
      and drops the paste-into-SSMS step, but loses the inspectable artifact —
      only worth it if the .sql file is no longer wanted.

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

### 2. ~~Add the allspec NCIs to IndexMap~~ — DONE 2026-07-29

All **7** (the 6 plus `ix_allspec_htmid`, which was not in IndexMap under any
spelling) added to the live table via `dr20/add_indexmap_allspec_nci.sql` and to
`schema/sql/IndexMap.sql`. Recorded `code='I'`, `compression='page'`,
`filegroup='SPEC'`, `indexgroup='SPECTRO'`.

- [x] 7 rows inserted; allspec now has 1 `K` + 7 `I` rows and every index on
      disk is accounted for
- [x] Added to `schema/sql/IndexMap.sql`
- [x] `ix_allspec_htmid` PAGE-compressed 2026-07-29 — it was the only allspec
      NCI still uncompressed. 2,599.74 MB -> 1,807.80 MB, 791.94 MB saved
      (30.5%). All 7 NCIs and the CI are now PAGE.

Two index names do not follow from their field lists — `ix_allspec_sdssid` keys
`sdss_id`, `ix_allspec_mjd_fiberid_plate` keys `plate_or_fps_field`. `fieldList`
records the real key list, so this adds a few `spCheckDBIndexes` discrepancies
of the known `fIndexName` class (see item 4b and the 2026-07-28 summary).

### 3. ~~Re-enable the three disabled FK constraints on DBObjects~~ — DROPPED 2026-07-28

All three have been **dropped**, not re-enabled, because they blocked the
metadata load:

- `fk_DBColumns_tablename_DBObjects`
- `fk_DBViewCols_viewname_DBObjects`
- `fk_Inventory_name_DBObjects_name`

SQL Server refuses `TRUNCATE TABLE` on any table referenced by a foreign key,
and it tests whether the constraint **exists**, not whether it is enabled —
verified 2026-07-28, `NOCHECK` makes no difference, error 4712 either way.
Since `loaddbobjects.sql` truncates DBObjects, all three had to go, not just
Inventory's. They were already disabled and untrusted, so they were enforcing
nothing and dropping them changed no behaviour.

Scripts: `dr20/drop_metadata_fks.sql` and `dr20/recreate_metadata_fks.sql`.
The drop script fails loudly if anything still references DBObjects.

- [x] Dropped, and `TRUNCATE` verified permitted on all three metadata tables
      (tested inside a rolled-back transaction; 901/31,306/234 rows intact)
- [ ] Optional: run `recreate_metadata_fks.sql` after the next metadata load.
      DBColumns and DBViewCols have **0 orphans**, so they come back `WITH
      CHECK` and trusted — better than the untrusted state they were in.
      `fk_Inventory_name_DBObjects_name` is deliberately not recreated:
      Inventory has 63 orphaned rows and is no longer tracked.

Note that ~29 other FKs across the DB are enabled but `is_not_trusted` — that
is expected from bulk loads and does not affect correctness, only optimizer
plan choices.

### 4. ~~Stale IndexMap rows~~ — DONE 2026-07-28

Three IndexMap rows named tables that do not exist in BestDR20. All removed
from the live IndexMap by `dr20/cleanup_indexmap_stale.sql`, and commented out
(not deleted) in `schema/sql/IndexMap.sql` so a rebuild does not put them back.

| Row | Why it went |
|---|---|
| `the_cannon_apogee_star` | no table, 0 rows in BESTTEST |
| `mos_legacy_catalog_catalogid` | dropped in the minidb_dr20 -> _v2 rebuild |
| `mos_sdss_id_to_catalog_full` | dropped in the minidb_dr20 -> _v2 rebuild |

The two `mos_` rows surfaced from a validate run reporting four `mos_` tables
"in schema". They were dropped in the `minidb_dr20` (185 tables, `dr20_*`) ->
`minidb_dr20_v2` (171) rebuild, which is the set BestDR20 was copied from, and
are **empty in minidb_dr20, BESTTEST and TEST_EBOS1** — the established DR20
signal for "not shipping". BestDR20 is correct to lack them; `spCheckDB`
returns 0 "in schema" against it. Note `mos_sdss_id_to_catalog` (no `_full`) is
a different table and *is* in DR20.

- [x] Removed from live IndexMap; sweep for other stale rows returns empty
- [x] Commented out in `schema/sql/IndexMap.sql`

### 4a. IndexMap drift between the live table and `IndexMap.sql`

Found while doing the above. Comparing the source file's active INSERTs against
the live IndexMap:

- **In the DB, missing from the file** — a rebuild would silently lose these:
  `spAll_epoch` (`specobjid`) and `spAll_allepoch` (`specobjid`). Both match
  the real clustered indexes, so the **file** is what needs fixing.
- **`mwm_targets` disagrees three ways.** The file says `sdss_id`, the live
  IndexMap row says `spectrum_PK`, and the actual clustered index
  `pk_mwm_targets_PK` is on a column called `PK`. **Nothing matches reality** —
  needs a decision on what the key is meant to be before either is corrected.

- [ ] Add the two spAll rows to `schema/sql/IndexMap.sql`
- [ ] Decide the intended `mwm_targets` key, then fix file and table together

### 4b. IndexMap rows for the 7 eROSITA DR1 tables — DONE 2026-07-28

All 7 were loaded in BestDR20 with clustered indexes but had **no IndexMap
row**, so a rebuild from IndexMap would have dropped those indexes — the same
gap as the allspec NCIs in item 2. Added to both the live table
(`dr20/add_indexmap_erosita.sql`, idempotent, and it refuses to insert if a
`fieldList` disagrees with the live clustered key) and `schema/sql/IndexMap.sql`.

| Table | Key | Rows |
|---|---|---:|
| `efeds_c001_hard_pointsources_ctp_redshift_v17` | `ero_id_src` | 246 |
| `efeds_c001_hard_v7_5` | `id_src` | 246 |
| `efeds_c001_main_pointsources_ctp_redshift_v17` | `ero_id_src` | 27,369 |
| `efeds_c001_main_v7_4` | `id_src` | 27,910 |
| `erass1_hard_v1_0` | `uid` | 5,466 |
| `erass1_main_v1_2` | `uid` | 930,203 |
| `salvato_etal2025_dr1_ls10` | `uid` (CI, not a PK) | 966,194 |

`salvato` gets `code='K'` like the rest even though its clustered index is not
a primary key — that matches the existing convention, where every `ci_*` index
built by `run_vac_load.py` is recorded as a `K` row, and `K` is what the loader
reads to find the clustering key.

- [ ] All 7 are recorded as `compression='page'` (matching every sibling VAC
      row) but are **uncompressed on disk**. Worth rebuilding the two big ones:
      `erass1_main_v1_2` (930K) and `salvato_etal2025_dr1_ls10` (966K). The
      `ALTER INDEX ... REBUILD WITH (DATA_COMPRESSION = PAGE)` statements are at
      the end of `add_indexmap_erosita.sql`.

### 4c. 42 `mos_*` tables have a clustered index but no IndexMap row

Found by sweeping `sys.indexes` against IndexMap after the above. **Every**
table in BestDR20 with a clustered index and no IndexMap row is a `mos_*` one —
42 of the 171. Nothing on the spectro/VAC side is missing any more.

Same consequence as item 2: a rebuild driven from IndexMap would not recreate
those clustered indexes.

- [ ] Decide whether `mos_*` tables are meant to be in IndexMap at all. Some
      already are, so the current state is inconsistent either way.

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
