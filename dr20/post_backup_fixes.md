# DR20 — fixes applied AFTER the 2026-07-28 backup

**Purpose:** the running ledger of every change made to BestDR20 on sdss4c that
is *not* in the backup, so the same changes can be replayed on the restored
production copies (sdss5a, sdss5b).

**Baseline:** `\\dss007.pha.jhu.edu\sql_backups_tmp\BestDR20_20260728\`
— 64 stripes, 6,580.9 GB compressed, verified complete. Everything in the
2026-07-28 session summary items 1–9 (metadata batching, FK drops, IndexMap
corrections, clustered-key fixes, eROSITA PAGE compression) **is** in this
backup and does **not** need replaying. The backup was taken *before* the
late-session spatial work below.

**No re-backup is planned.** Pre-launch fixes are applied in situ to the live
copies.

**Go-live: Thursday 2026-07-30.**

---

## How to replay on sdss5a / sdss5b

> **For the actual replay, use [`post_backup_runbook.md`](post_backup_runbook.md)** —
> the ordered command list, with the metadata reload, verification and log
> reclaim at the end. **This file is the reasoning and the evidence**; the
> runbook is the punchlist. Keep both in step when a new fix is added.

Two things to get right:

- **Use `-b`** so a failure sets a non-zero exit code on an unattended run. The
  guard in `fix_spall_htm.sql` no longer depends on it: guard, `UPDATE`,
  `COMMIT` and index rebuild are all one batch, so `RETURN` stops the whole
  thing. Do not add a `GO` between them — that reintroduces the bug where the
  `UPDATE` ran even after the guard refused.
- **Check the `USE` line.** Both scripts open with `USE BestDR20`. If the
  restored copy carries a different database name, change it or the script
  silently targets the wrong database.

`verify_spatial_fixes.sql` must print **PASS on all 5 rows**. Anything else means
stop and look before going live.

---

## 1. spAll htmid/cx/cy/cz rebuilt from racat/deccat

**Script:** `dr20/fix_spall_htm.sql`
**Applied on sdss4c:** 2026-07-28, 5,357,037 rows in 8.8 min
**Also does:** `ALTER INDEX ix_spAll_htmid ... REBUILD`

The spatial index was computed from `plug_ra`/`plug_dec`, which in SDSS-V hold
the null sentinel −9999 for 4,905,907 of 5,357,037 rows (91.6%). −9999 is a
valid float, so nothing ever errored.

| | before | after |
|---|---:|---:|
| biggest htmid pile | 4,905,907 | 172 |
| cone search finds a known spAll object | 0 rows | 1 row |
| cone search at the bogus ra=81/dec=81 | 4.9M spurious | 0 |
| distinct htmid | 1 + tail | 3,223,326 |

Rebuilt from `racat`/`deccat`, not `fiber_ra`/`fiber_dec`: `racat`/`deccat` is
consistently ICRS at `coord_epoch`, whereas `fiber_*` is documented "J2000 for
plate; at exp for FPS" — a mixed frame. `fGetNearbySpAllXYZ` also already
*returned* `racat`/`deccat`, so indexing on them makes search and output agree.
Both pairs have zero invalid values across all rows.

**Expect the table to grow.** htmid/cx/cy/cz were identical across 4.9M rows,
which PAGE compression handled almost for free; distinct values compress far
less well. Confirm SPEC has headroom on the target server before running —
SPEC on sdss4c had only ~1.5 GB free.

## 2. Four `fGetNearby*XYZ` distance expressions corrected

**Script:** `dr20/fix_nearby_distance.sql`
**Applied on sdss4c:** 2026-07-28, via `ALTER FUNCTION`
**Functions:** `fGetNearbyMosTargetXYZ`, `fGetNearbyAllspecXYZ`,
`fGetNearbyApogeeDrpAllstarXYZ`, `fGetNearbySpAllXYZ`

All four recomputed the returned `distance` from ra/dec using `COS()`/`SIN()`
**without converting degrees to radians**, while `@nx/@ny/@nz` were built *with*
the conversion. The other five use the precomputed `cx/cy/cz` and were correct.

The row *filter* uses `cx/cy/cz`, so the right rows came back in the right
order — only the reported `distance` was garbage (9825.39 arcmin for a
zero-separation self-match). Replaced with the `cx/cy/cz` form the correct five
already use. Verified to match true great-circle separation to 1e-6.

Safe to re-run; `ALTER FUNCTION` preserves permissions and dependencies.

### Also changed outside the database

`C:\sqlloader\schema\sql\spNearby.sql` — same 4 expressions, applied by the same
regex. **Not in the repo snapshot `308df88`.** Backup of the original is in the
session scratchpad. Tell Ani, since `C:\sqlloader` is shared and an open editor
could revert it.

---

## 3. boss_clam_params dropped — VAC retired

**Script:** `dr20/drop_boss_clam_params.sql`
**Applied on sdss4c:** 2026-07-29
**Reason:** the VAC owner confirmed the product is no longer needed for DR20.
**Its sibling `boss_clam_lite` IS still shipping and is untouched.**

Removed from BestDR20:

| Object | Amount |
|---|---:|
| table `boss_clam_params` on SPEC | 1,708,214 rows / 1,674.09 MB |
| `ci_boss_clam_params_PK` (CI), `ix_boss_clam_params_htmid` (NCI) | dropped with the table |
| `DBObjects` | 1 row |
| `DBColumns` | 169 rows |
| `IndexMap` (`K`, `PK`, SPECTRO/SPEC) | 1 row |
| `DBViewCols`, `Inventory` | 0 rows — nothing to remove |

No foreign key referenced it and it referenced none, so the drop was clean.
Every deleted count matched the expected value on the run.

The script is idempotent and guarded: it refuses if any FK still points at the
table, and refuses if `boss_clam_lite` is missing (wrong-database check).
Metadata children are deleted before parents, so it works whether or not
`recreate_metadata_fks.sql` has been run. Same one-batch structure as
`fix_spall_htm.sql`, and for the same reason.

### Also changed outside the database

Editing these does not affect the running database — it stops the table coming
back on a reload or in DR21.

On `C:\sqlloader` (**shared with Ani — tell him**):

- `schema/sql/VacTables.sql` — the whole `boss_clam_params` block removed
  (was lines 2659–2852, a live region, not one of the commented-out copies).
  Original backed up to the session scratchpad as `VacTables.sql.bak`.
- `schema/sql/IndexMap.sql` — its INSERT commented out, following the same
  convention used for the stale rows on 2026-07-28.
- `schema/sql/spValidate.sql` — the live `ALTER TABLE boss_clam_params ADD PK
  IDENTITY` commented out. It would have failed against the dropped table.
- `schema/sql/spPublish.sql` — the live `spCopyATable ... 'boss_clam_params'`
  commented out, same reason; the neighbouring "first 3 VACs" comment reworded.

In the repo:

- `dr20/gen_vac_pk.sql` — removed from the VAC 36 table list.

**Not touched, deliberately:**

- `schema/csv/loaddbobjects.sql`, `loaddbcolumns.sql`, `loadinventory.sql` are
  **generated** from the schema `.sql` files. They still carry the table.
  Regenerating from the edited `VacTables.sql` is the correct fix and now takes
  ~12 seconds; hand-editing them would create drift. The live database is
  already correct either way.
- `schema/sql/dr20vacs/` (`boss_clam_params.sql`, `VacTables.sql`,
  `VacTablesDR20.sql`, `IndexMapDR20VACs.sql`) — reference copies that
  `xschema.txt` never reads. Worth cleaning up, not urgent.
- `dr20/htm_added.json` and the loading-status CSVs are run records of what was
  done at the time. Left as history.

## 4. allspec.specobjid converted from varchar(29) to numeric(30,0)

**Script:** `dr20/fix_allspec_specobjid.sql`
**Applied on sdss4c:** 2026-07-29, 27,671,504 rows
**Originally raised by Ani 2026-07-28** (TODO item 0a), deferred to decide fresh.

### Why numeric(30) and not numeric(20)

The obvious guess is to match `SpecObjAll.specObjID`, which is `numeric(20,0)`.
**That would have failed.** `allspec.specobjid` holds a union of two id schemes:

| digits | rows | matches |
|---:|---:|---|
| 18–20 | 5,810,967 | `SpecObjAll` (numeric(20,0)) |
| 25–29 | 10,766,741 | `spAll` (numeric(30,0)) |

`numeric(20)` overflows on 10,766,741 rows — 65% of the non-null values. Max
observed value is `10000192401073606060100060201`, 29 digits.

`numeric(30,0)` matches `spAll` / `spAll_epoch` / `spAll_allepoch`, and is
already what `fGetNearbyAllspecXYZ` declares in its `RETURNS` clause — that
function was doing the varchar→numeric conversion on every row.

Column stays **NULLable**: 11,093,796 of the 27.7M rows are NULL.

### Why ALTER in place rather than reload from BESTTEST

The 2026-07-28 note leaned toward drop-and-reload. Checking first changed the
answer:

- **BESTTEST's own `allspec.specobjid` is also `varchar(29)`.** A reload fixes
  nothing unless `SpectroTables.sql` is corrected first, so the reload buys no
  schema correction it doesn't already require.
- allspec's 6 NCIs and `ix_allspec_htmid` are **absent from IndexMap**, so an
  IndexMap-driven reload would silently drop them (TODO item 2).
- `htmid`/`cx`/`cy`/`cz` would need a fresh 27.7M-row HTM pass.
- SPEC had 3.26 GB free against a 7.51 GB table.

### What the script did

Only `ix_allspec_specobjid` was touched — it has `specobjid` as its key, so it
blocks the `ALTER`. Dropped, column converted, recreated identically (PAGE,
SPEC, default fill factor, no included columns). The clustered index, the other
6 NCIs and the HTM columns were left alone.

Guarded: refuses if the column is missing or an unexpected type, no-ops if
already numeric, and refuses if any value would not convert. Fingerprints the
values **as numbers** before and after (`SUM(CAST(CHECKSUM(...) AS bigint))`)
and raises if anything moved.

Result — fingerprint identical, all 8 indexes present:

```
before: 27671504 rows, 16577708 non-null, fingerprint 23825456152409926
after:  27671504 rows, 16577708 non-null, fingerprint 23825456152409926  - unchanged
```

### Also changed outside the database

- `C:\sqlloader\schema\sql\SpectroTables.sql` — the live `allspec` block now
  says `specobjid numeric(30) NULL`. **Shared with Ani — tell him.**
  Original backed up to the session scratchpad as `SpectroTables.sql.bak`.

  **The comment-block trap again:** there are two `allspec` blocks in this file.
  Line 3016 declares `specobjid varchar(32)` and is inside a `/* */` region;
  the live one is line 3067. Only the live one was changed. Anything editing
  this file must be comment-aware.

- **Ani needs to re-run the CasJobs piece** afterwards, per the original TODO.
- BESTTEST still has `varchar(29)`. Not changed — out of scope for go-live, but
  it will re-introduce the varchar if allspec is ever reloaded from it before
  `SpectroTables.sql` is used to rebuild the table.

## 5. allspec's 7 nonclustered indexes documented in IndexMap

**Script:** `dr20/add_indexmap_allspec_nci.sql`
**Applied on sdss4c:** 2026-07-29, 7 rows inserted
**Closes TODO item 2.**

allspec had only its `K` row (`allspec_id`). All 7 NCIs existed on disk but were
undocumented, so a rebuild driven from IndexMap would have silently dropped
them — the same gap the 7 eROSITA tables had yesterday.

| code | fieldList | index on disk |
|---|---|---|
| I | `specobjid` | `ix_allspec_specobjid` |
| I | `htmid` | `ix_allspec_htmid` |
| I | `apogee_id` | `ix_allspec_apogee_id` |
| I | `apstar_id` | `ix_allspec_apstar_id` |
| I | `mangaid` | `ix_allspec_mangaid` |
| I | `sdss_id` | `ix_allspec_sdssid` |
| I | `mjd,fiberid,plate_or_fps_field` | `ix_allspec_mjd_fiberid_plate` |

All `SPECTRO` / `page` / `SPEC`, matching every sibling row.

The script has two guards, and both directions must hold: it refuses if any
claimed `fieldList` has no matching live index, **and** refuses if allspec has
any nonclustered index the script does not cover — the point is to close the gap
completely, not partially.

**Note the last two names do not follow from their field lists.**
`ix_allspec_sdssid` keys `sdss_id`; `ix_allspec_mjd_fiberid_plate` keys
`plate_or_fps_field`. `fieldList` records what the index actually keys on, which
is what a rebuild needs.

### Also changed outside the database

- `C:\sqlloader\schema\sql\IndexMap.sql` — same 7 rows added after allspec's `K`
  row, with a comment explaining the name/fieldList mismatch.
  **Shared with Ani — tell him.**

### `ix_allspec_htmid` PAGE-compressed — done 2026-07-29

It was the one allspec NCI still uncompressed while its six siblings were PAGE —
a bigint index over 27.7M rows, an oversight rather than intent. Rebuilt so disk
agrees with the `page` IndexMap now records:

```sql
ALTER INDEX ix_allspec_htmid ON allspec
    REBUILD WITH (DATA_COMPRESSION = PAGE, SORT_IN_TEMPDB = ON);
```

| | before | after | saved |
|---|---:|---:|---:|
| `ix_allspec_htmid` | 2,599.74 MB | 1,807.80 MB | **791.94 MB (30.5%)** |

All 7 allspec NCIs and the clustered index are now PAGE.

### Follow-up deliberately not done

- **This adds discrepancies to `spCheckDBIndexes`, which is expected.** That
  check derives an expected index name from tableName + fieldList via
  `dbo.fIndexName`, so it will expect `ix_allspec_sdss_id` and
  `ix_allspec_mjd_fiberid_plate_or_fps_field` (41 chars — past `fIndexName`'s
  32-char truncation anyway). The indexes are correct; the check's name
  derivation is what is broken. Same effect as the +7 from the eROSITA rows.

### Still open in this area

- **42 `mos_*` tables have a clustered index but no IndexMap `K` row**
  (TODO 4c). Verified again today: the `K`-row gap is now *exclusively* `mos_*` —
  nothing on the spectro/VAC side is missing one. Needs a decision on whether
  `mos_*` belongs in IndexMap at all, since some already are.
- **`spAll_epoch` and `spAll_allepoch`** are in the live IndexMap but missing
  from `schema/sql/IndexMap.sql` (TODO 4a). A rebuild from the file would lose
  them. Not touched today.

## 6. Three `fGetNearest*Eq` functions ordered by distance

**Script:** `dr20/fix_nearest_orderby.sql`
**Applied on sdss4c:** 2026-07-29, 3 functions altered
**Found by:** `dr20/verify_spatial.sql` check A2

`fGetNearestAllspecEq`, `fGetNearestApogeeDrpAllstarEq` and
`fGetNearestSpAllEq` did `SELECT TOP 1` over their Nearby XYZ function with
**no `ORDER BY distance`** — so they returned an arbitrary object from the cone
rather than the nearest one. Their XYZ counterparts all had it.

It is not enough that the inner function populates its table variable in
distance order: **inserting into a table variable in a given order does not
guarantee reading it back in that order.** The engine is free to return any
qualifying row, and is more likely to under parallelism or after an index
change. A real defect, not a theoretical one.

Same three families as the radians bug fixed 2026-07-28.

The script rebuilds each function from its own live definition with one targeted
substitution, rather than retyping three long `RETURNS TABLE` clauses where a
transcription slip would silently change a column type. It refuses unless the
substitution matches exactly once, and verifies afterwards that no
`fGetNearest*` still takes `TOP 1` unordered. Idempotent.

### Also changed outside the database

- `C:\sqlloader\schema\sql\spNearby.sql` — same three lines.
  **Shared with Ani — tell him.** This is the second change to this file
  (the first was the 2026-07-28 distance expressions, entry 2).

### Not done, deliberately: `fGetNearbyTiledTargetsEq`

The same test run showed this function fails on every call — it joins a table
named `TiledTarget`, which does not exist. The `sdssTiledTarget` view was
**deliberately commented out in 2010** (`Views.sql` line 47, "broken, no
unTiled col"), so it has been dead roughly 15 years.

**Decision 2026-07-29: leave it alone**, and do not populate
`sdssTiledTargetAll.htmid` either, since nothing can query it. Reviving a view
removed on purpose is not a go-live-eve change.

## 7. (2026-07-29 session — append below as we go)

<!--
Template for each entry:

## N. <what>

**Script:** dr20/<file>.sql
**Applied on sdss4c:** <date>, <scale/duration>
**Objects touched:** <tables / indexes / functions>
**Verification:** <how we know it worked>
**Also changed outside the database:** <schema files on C:\sqlloader, etc.>
-->
