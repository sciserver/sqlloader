# DR20 Session Summary - July 27, 2026

## Session Goals

Clean up the GitHub repo. Everything since January was uncommitted, and the
git/file organization item had been deferred from four previous sessions.

What it turned into: the repo cleanup, plus two audits of BestDR20's actual
state — one that surfaced 10 APOGEE tables sitting on the wrong filegroup, and
one that surfaced 8 VAC tables never loaded at all. Both fixed end to end.

---

## What We Accomplished

### 1. Repo cleanup — 13 commits on `dr20`

The branch had 12 modified tracked files, 1 unstaged deletion, and ~120
untracked files. Now clean.

- **Deleted ~35 regenerable artifacts** — `fk_results_*.txt`, `vac_load_*.log`,
  `*_count.txt`, `actual_column_types.tsv`, `__pycache__/`, and a
  `bash.exe.stackdump` that had actually been committed. Added `.gitignore`
  patterns so they stop coming back. The three `*_loaded.json` loader-state
  files were kept — they are the record of which VAC/HTM/eROSITA tables
  completed.
- **Archived ~55 superseded files** into `dr20/archive/`:
  - `schema_iterations/` — Dec 2025/Jan 2026 generated schema, PK, index, FK
    and bulk-insert files, superseded by `mssql_tables_0603.sql`,
    `mssql_indexes_0112_portable.sql` and `bulk_loader.py`
  - `one_offs/` — diagnostic and repair scripts from the initial load (FK
    orphan investigation, varchar(max) sizing, deadlock tracing, failed-table
    reloads, the LAMOST DR6 pipe-delimited fix)
  - `archive/README.md` maps each superseded file to its canonical replacement
- `dr20/` went from ~160 files to 60 plus `archive/`.

Commit `89a9784` (parseSchema2sql.py + vbs/README.md + xschema.txt) was
deliberately isolated as the cherry-pick candidate for master. **Still not
cherry-picked** — deferred.

### 2. Guarded `03-perms.bestdrx.sql` against patching the wrong DR

The file had a hardcoded `use bestdr20`, which would silently patch DR20 while
the operator believed they were patching a newer DR — invisible if you had
already selected BestDR21 in SSMS.

Now it patches the *current* database and refuses anything not matching
`BestDR[0-9][0-9]`. Uses `SET NOEXEC ON` so the refusal carries across the ~15
`GO` batches; a bare RAISERROR would only stop the batch it is in and the rest
would still recreate every proc. Also checks that the server-level `logger`
login exists, since `CREATE USER FOR LOGIN` would otherwise fail later with a
vaguer message.

Tested against `master`: refuses, blocks the body, releases the session.

### 3. Found and fixed 10 APOGEE tables on the wrong filegroup

Rewriting TODO.md from live queries rather than old notes turned this up.

Ten tables carried over in the BestDR19 to BestDR20 rename had never been
rebuilt: **uncompressed heaps on PRIMARY, 13.6M rows, 25.65 GB**, while
IndexMap said clustered on `spectrum_PK`, PAGE, on SPEC.

Pre-checks (read-only) before touching anything:
- `spectrum_pk` is `bigint NOT NULL`, unique with zero nulls on all 10 — PKs
  will build
- no nonclustered indexes and no FKs referencing any of them — a swap loses
  nothing

**The move** (`gen_apogee_move.py` -> `move_apogee_tables.sql`), per table end
to end:

```
CREATE <t>_move ON [SPEC]
ADD CONSTRAINT pk_<t>_spectrum_pk PRIMARY KEY CLUSTERED (spectrum_pk) [WITH PAGE] ON [SPEC]
INSERT ... WITH (TABLOCK)
VERIFY row count + key checksum   <- before any rename
sp_rename <t> -> <t>_old          <- kept, not dropped
sp_rename <t>_move -> <t>
```

PK created before the load so rows land in key order already compressed, rather
than building a heap and rebuilding. Compression on the 1M row rule: 8 got PAGE,
`astro_nn_apogee_visit` (810K) and `the_payne_apogee_visit` (793K) did not.

**Result: 25.65 GB -> 18.07 GB**, all 10 on SPEC with correctly named clustered
PKs, row counts exact. Originals then removed via
`drop_apogee_old_tables.sql`, which re-verifies each pair at runtime (moved
table on SPEC with a clustered PK, `_old` exists, `COUNT(*)` matches) and skips
rather than drops on any mismatch.

**Decision: these are NOT reloaded from BESTTEST.** The DR19 APOGEE products are
what ships for DR20. They keep the vestigial `PK` column that the newer BESTTEST
schema drops — the move was deliberately faithful to the existing schema.

### 4. Empty-source guard in `run_vac_load.py`

The per-table load is DROP > CREATE > CI > INSERT SELECT. With an empty BESTTEST
source that drops the target and inserts nothing — and since an empty INSERT is
not an error, it commits and records success in `vac_loaded.json`. The
destructive case was the one that looked like success.

Now refuses when the source is empty **and** the target holds rows. A missing or
empty target still creates the shell. `--force` does not override it — force
exists to re-load already-loaded tables, not to permit replacing data with
nothing. Refusals are counted separately in the run summary.

Verified read-only against live data: the three populated APOGEE targets with
empty sources refuse, `the_cannon_apogee_star` passes as an absent target,
tables with data in both are unaffected.

### 5. Measured what IndexMap is actually authoritative for

Across the 294 tables with a `code='K'` row and a compression value:

- **Compression — sound.** IndexMap says PAGE for essentially everything with a
  filegroup assigned (275 `page`/SPEC + 30 `PAGE`/PHOTO; the 40 blanks are
  legacy CAS system tables). No size nuance — it is "compress everything". But
  116 tables are uncompressed on disk, **2,378 GB** worth. 102 of those are
  below 1M rows, i.e. the loaders' threshold overriding IndexMap; 14 were just
  missed.
- **Filegroup — not sound.** Only 97 of 294 tables sit where IndexMap says. It
  claims SPEC for 129 `mos_*` tables that correctly live on MINIDB by design,
  and PHOTO for tables on DATAFG/WISE/ATLAS/FRAME.

Consequence: `run_vac_load.py` hardcoding `FILEGROUP='SPEC'` is the *safer*
behaviour. Do not "fix" it to read IndexMap's filegroup without fixing that
column first.

### 6. Found and loaded 8 VAC tables that had been missed entirely

Checking the VAC loading manifest (CSV -> `dbTableName` -> row count) against
BestDR20 was expected to turn up tables needing a rename. It did not — all 21
manifest tables that existed already carried the correct `dbTableName` with
exact row counts.

What it found instead: **8 tables that were never loaded at all.**

| Table | Rows |
|---|---:|
| DL1_eROSITA_eRASS3_allepoch | 263,310 |
| DL1_eROSITA_eRASS3_daily | 478,255 |
| efeds_spiders_agn_ctp_salvato | 13,143 |
| efeds_spiders_agn_host_decomp | 13,143 |
| efeds_spiders_agn_line_props | 13,143 |
| efeds_spiders_agn_xray_props | 13,143 |
| efeds_spiders_agn_main_xray_cat | 12,866 |
| efeds_spiders_agn_hard_xray_cat | 277 |

Of the 7 `efeds_spiders_agn_*` tables in the manifest, only `fit_params` had
ever been loaded. They were not misnamed — no table anywhere in BestDR20 had
those row counts, and a pattern search on `%efeds%`, `%erass%`, `%DL1%`,
`%xray%` turned up nothing. They were simply never in `run_vac_load.py`'s
`TABLES` list, so they were never attempted. `vac_loaded.json` recorded 36
successes out of a 36-entry list — the list itself was the gap, which is why
nothing ever flagged it.

All 8 were sitting in BESTTEST fully populated with matching counts, with
IndexMap entries and their CI key columns present.

**Loaded in ~24 seconds, 0 errors**, every table's loaded count equal to its
source count. All 29 manifest entries now match by name and row count:
0 missing, 0 mismatches.

### 7. Made compression IndexMap-driven

The 8 tables above forced the issue: all are under 1M rows, so the old
row-count rule would have created them uncompressed, contradicting the IndexMap
rows that say `page` for every one.

`run_vac_load.py` now takes compression from IndexMap where it specifies one,
falling back to the 1M rule only where IndexMap says nothing. Values are
validated against `NONE`/`ROW`/`PAGE` before reaching DDL, since IndexMap is
free text and inconsistently cased (`page` on SPEC rows, `PAGE` on PHOTO rows).

IndexMap's `filegroup` column is deliberately still **not** used — it claims
SPEC for 129 `mos_*` tables that correctly live on MINIDB, so the hardcoded
target stays until that column is fixed.

These 8 are the first tables in BestDR20 built under the new rule.

### 8. Verified the published VAC table list (41 entries)

39 of 41 present in BestDR20, all on SPEC with clustered indexes and exact
row counts.

**DL1 naming — resolved, no action needed.** The published list used
`DL1_spec_SDSSV_eROSITA_eRASS3_*` where BestDR20 has
`DL1_eROSITA_eRASS3_*`. Investigated: BESTTEST, IndexMap (all 4 DL1 rows),
the pre-existing eRASS1 pair and the loading manifest all use the short
form; only the published list used the long one. **Decision: the loading
manifest name is canonical**, so nothing is renamed. Had it gone the other
way it would have been a 4-table change plus 4 IndexMap rows, not 2 —
the whole DL1 family shares the convention.

**`efeds_spiders_agn_classification_props` — blocked upstream.** BESTTEST
has it as `efeds_spiders_agn_class_props` with 0 rows, and neither
spelling has an IndexMap entry. Not a naming problem at our end. Same for
`efeds_spiders_agn_xray_spec_props`, also 0 rows.

### 9. Recorded the filegroup sizing intent

This is a **write-once, read-only** database — once a DR is loaded it does not
grow, so filegroups are meant to end up *full*. Allocated-but-unused space is
waste, not headroom. SPEC at 446.29/446.50 GB (99.95%) is the desired end state.

By that standard PRIMARY is the outlier: 190.54 GB allocated, 117.66 used,
**72.88 GB free** (61.8%), its file still named `BESTDR8_Data1`. Moving the
APOGEE tables out opened ~25.6 GB of it. Queued as an end-of-load shrink — safe
here precisely because nothing is modified after load.

---

## Current BestDR20 State

**Loading is complete.** 400 user tables:

| Filegroup | Tables |
|---|---|
| MINIDB | 172 |
| SPEC | 118 |
| DATAFG | 69 |
| PRIMARY | 31 |
| PHOTO | 6 |
| WISE | 2 |
| ATLAS, FRAME | 1 each |

Metadata: DBObjects 891, DBColumns 30,579, DBViewCols 234.

Something may still sneak in under the wire, and a missing index may turn up
here and there, but the bulk load is done.

---

## Files Created

- `dr20/gen_apogee_move.py` — generates the PRIMARY-heap-to-SPEC move
- `dr20/move_apogee_tables.sql` — generated, 10 self-contained blocks
- `dr20/drop_apogee_old_tables.sql` — self-verifying cleanup of `_old` originals
- `dr20/archive/README.md` — maps superseded files to replacements
- `dr20/session_summary_20260727.md` — this file

## Files Modified

- `.gitignore` — regenerable load output
- `schema/patches/03-perms.bestdrx.sql` — target-DR guard
- `dr20/run_vac_load.py` — empty-source guard, `get_target_rows()`,
  IndexMap-driven compression, 8 tables added to `TABLES`
- `dr20/vac_loaded.json` — 8 new entries, now 44
- `dr20/TODO.md` — rewritten twice: once from verified DB state, then again once
  loading was declared complete

## Files Moved

~55 into `dr20/archive/schema_iterations/` and `dr20/archive/one_offs/`, via
`git mv` where tracked so history follows.

---

## TODO Next Session

1. **Rework the metadata load** — scoped upsert instead of whole-table
   TRUNCATE, plus multi-row batched INSERTs. Highest priority; see the section
   below and `TODO.md` item 0.
2. **Cherry-pick `89a9784` to master** — deferred, it is isolated and ready
3. **Add the 6 allspec NCIs to IndexMap** (`code='I'`) — they exist on disk but
   are undocumented, so a rebuild from IndexMap would silently drop them
4. **Re-enable the 3 disabled DBObjects FKs** — `fk_DBColumns_tablename_DBObjects`,
   `fk_DBViewCols_viewname_DBObjects`, `fk_Inventory_name_DBObjects_name`
5. **Sweep for missing indexes** — most likely remaining gap; compare
   `sys.indexes` against IndexMap per table. The allspec NCIs were found this way.
6. **multiplex NCIs** — waiting on the column list from the tool owner
7. **`the_cannon_apogee_star`** — IndexMap row with no table and no source.
   Either it is not part of DR20 and the row should go, or it needs a source.
   Same question for `efeds_spiders_agn_classification_props` and
   `efeds_spiders_agn_xray_spec_props`, both 0 rows in BESTTEST.
8. **Reclaim PRIMARY** — once nothing more will land there
9. **DR21:** decide whether to fix IndexMap's filegroup column or stop reading
   it, and consolidate the two VAC loaders (`run_vac_load.py --dry-run` already
   prints the SQL, so the SSMS path need not be a second implementation)

---

## The metadata process needs rework

Raised at the end of the session. Recording it properly because one half is a
correctness issue, not just ergonomics.

### It silently loses edits

`parseSchema2sql.py` is a **per-file** tool, but the SQL it emits opens with a
**whole-table** `TRUNCATE TABLE DBColumns` / `DBObjects`. Regenerating one
schema file forces a choice: wipe the metadata for every other file, or skip
the TRUNCATE and accept stale rows.

Skipping it is not benign. `pk_DBColumns_tableName_name` is on
`(tablename, name)`:

| Case | What happens |
|---|---|
| New column | INSERT succeeds |
| **Changed description** | **PK violation, old text silently kept** |
| Removed column | stale row persists indefinitely |

Those failures are indistinguishable from the thousands of expected duplicate
errors, so a swallowed edit cannot be spotted in the output.

**Resolved for now** by re-running the *full* set (all 50 files in
`xschema.txt`, which includes `VacTables.sql`, `LvmTables.sql` and
`mosTables.sql`) rather than the VAC file alone — 901 objects, 31,306 columns,
234 viewcols, 0 orphans, TRUNCATE correct. **Fix properly** by scoping the
DELETE to the tables in the current run, children before parents, which also
removes the need for the FK-disabling workaround used on 2026-07-24.

### The load is far too slow

31,306 separate INSERT statements, each its own autocommit transaction — so
31,306 round trips and 31,306 synchronous log flushes for ~4 MB of data. The
flushes dominate.

Fix with multi-row `VALUES` (1,000 rows per statement, collapsing 31,306
statements to ~32) plus explicit `BEGIN TRAN`/`COMMIT` per batch. Output stays
a plain .sql file that can be inspected and pasted, so nothing about the
workflow changes. Care needed on quote-doubling: descriptions contain
apostrophes and HTML links, and one bad escape in a 1,000-row statement kills
the whole batch rather than one row.

Both changes live in the same statement-emitting code, so they should be done
in one pass.

The Python rewrite fixed the *parse* time (15 minutes to ~1 second) but
inherited the VBScript's load model unchanged. That is the part still to do.

---

## Notes

Branch `dr20` was pushed mid-session; everything from `4676498` onward (the
APOGEE move, the drop script, the TODO updates, the IndexMap-driven compression
change and the 8-table load) was committed after that push and is still local.

**Worth carrying into DR21:** both of today's real findings came from diffing an
external source of truth against the database — IndexMap for the APOGEE tables,
the loading manifest for the VACs. Neither was visible from inside the process.
`vac_loaded.json` showed 36 successes out of a 36-entry list and looked
perfectly healthy; the gap was in the list itself. A completeness check against
the manifest belongs in the pipeline, not in an ad-hoc session.
