# DR20 Session Summary — July 29, 2026

## Session Goals

Apply the fixes found on 2026-07-28 to the restored production copies, and clear
whatever else surfaced before launch.

**DR20 goes live Thursday 2026-07-30.** The user has signed off **sdss5a and
sdss5b as ready for production and for a fresh backup**.

---

## Headline

Both production databases are complete and verified. Along the way the day
turned up **five defects that were not known this morning**, two of which were
in the checks themselves — including one that reported a fully broken database
as clean.

| | sdss5a | sdss5b |
|---|---|---|
| Runbook steps 1–11 | complete | complete |
| `verify_spatial.sql` | 35 OK / 0 errors / 0 regressions | same |
| Statistics missing a histogram | 0 | 0 |
| Transaction logs | 816.95 GB → 2.50 GB | 816.95 GB → 2.50 GB |
| SPEC | 447.50 GB alloc, 4.24 GB free | same |

---

## 1. The post-backup ledger and runbook

The 2026-07-28 backup predates every fix, so a restore reintroduces all of them.
Two documents now cover this, deliberately in different shapes:

- **`dr20/post_backup_fixes.md`** — the reasoning, measurements and rejected
  alternatives for each change.
- **`dr20/post_backup_runbook.md`** — the punchlist: 11 numbered steps with
  times, the exact command per step, and the output to expect.

Both cross-reference each other. The runbook is what you actually work from at
2am in front of a freshly restored database.

## 2. `boss_clam_params` retired

The VAC owner confirmed it is not shipping. `dr20/drop_boss_clam_params.sql`
removes the table (1,708,214 rows / 1,674 MB on SPEC) and its metadata —
DBObjects 1, DBColumns 169, IndexMap 1. Its sibling `boss_clam_lite` **is**
still shipping and is guarded against explicitly in the script.

Also removed from `VacTables.sql`, `IndexMap.sql`, `spValidate.sql`,
`spPublish.sql` and `dr20/gen_vac_pk.sql` so it cannot come back on a reload.

## 3. `allspec.specobjid` varchar(29) → numeric(30,0)

**Not `numeric(20)`, and that distinction mattered.** The obvious move is to
match `SpecObjAll` (numeric(20,0)) — it would have overflowed 65% of the
non-null rows. The column holds a union of two id schemes:

| digits | rows | matches |
|---:|---:|---|
| 18–20 | 5,810,967 | `SpecObjAll` (numeric(20,0)) |
| 25–29 | 10,766,741 | `spAll` (numeric(30,0)) |

`numeric(30,0)` is the only type that holds both, and is already what
`fGetNearbyAllspecXYZ` declares in its `RETURNS` clause.

**ALTER in place, not the drop-and-reload favoured on 2026-07-28**, because
checking first changed the answer: **BESTTEST's own `allspec.specobjid` is also
`varchar(29)`**, so a reload fixes nothing unless the schema file is corrected
first — which the reload needed anyway. Add that allspec's NCIs were missing
from IndexMap and the reload had no advantage left.

Verified by fingerprinting the values *as numbers* before and after:
`23825456152409926`, identical, and identical again on both production boxes.

## 4. allspec's 7 nonclustered indexes documented in IndexMap

Closes TODO item 2. They existed on disk but not in IndexMap, so a rebuild would
have dropped them. The script guards **both directions**: it refuses if a
claimed `fieldList` has no live index, and refuses if allspec has any NCI the
script does not cover, so a partial fix cannot pass silently.

`ix_allspec_htmid` was also the one allspec NCI still uncompressed —
PAGE-compressed, 2,599.74 MB → 1,807.80 MB.

## 5. `spCheckDBIndexes` analysed — 217 discrepancies, ~4 real

`dr20/spcheckdbindexes_analysis.md`, built from live numbers. **Three**
independent naming defects, not the two identified yesterday:

1. **`fIndexName` truncates to `varchar(32)`** then compares against untruncated
   real names. Over-length: K 181/348, I 33/88, F 30/33.
2. **The `K` branch selects only `pk_*`**, so 52 clustered indexes named `ci_*`
   are invisible.
3. **NEW: `fIndexName` emits `i_` for code `I`**, and the check matches
   `i.name LIKE 'i[_]%'` — which does **not** match `ix_*`, the modern
   convention. 34 real indexes are invisible.

The 190 "in schema" K rows decompose to 125 PostgreSQL `_pkey` names, 44 `ci_*`,
17 pure truncation, 2 oddly named, and **2 tables with no clustered index at
all** — the only genuinely missing thing in the whole report.

**The deeper point:** the check compares *names*, not *definitions*. An index on
the wrong columns with the right name passes. Comparing `fieldList` against
`sys.index_columns` would be immune to all three. That is the DR21 fix.

## 6. `verify_spatial.sql` — the fGetNearby/fGetNearest family generalised

The old `verify_spatial_fixes.sql` tested only spAll. The new suite covers all
**49 functions** and the 11 tables behind them, driven by a table so adding a
table is one row.

The family collapsed usefully: ~12 real implementations (`fGetNearby<X>XYZ`) and
~37 thin wrappers — the Eq variants convert ra/dec to xyz and call the XYZ one,
the Nearest variants are `TOP 1` over it. Probing through the Eq entry point
exercises the whole chain.

Three checks: **A** static definition checks; **B** does the spatial index agree
with the coordinates the function *reports* — the generic form of the spAll bug,
sampled so it is seconds even on PhotoObjAll's 1.23B rows; **C** end-to-end,
probe an object at its own position and require it back at ~zero distance.

Known gaps are declared **per check**, and an exemption that starts passing is
also reported, so the list cannot rot.

It found four real defects on its first run.

## 7. Three `fGetNearest*Eq` returned an arbitrary object, not the nearest

`fGetNearestAllspecEq`, `fGetNearestApogeeDrpAllstarEq`, `fGetNearestSpAllEq`
did `SELECT TOP 1` over the Nearby XYZ function with **no `ORDER BY distance`**.
Inserting into a table variable in order does not guarantee reading it back in
that order, so this was real, not theoretical. Same three families as
yesterday's radians bug.

`dr20/fix_nearest_orderby.sql` rebuilds each function from its own live
definition with one targeted substitution rather than retyping three long
`RETURNS TABLE` clauses, and refuses unless the substitution matches exactly
once.

## 8. ⚠ A check that could never fire — the most important lesson of the day

The test for yesterday's radians bug was

```sql
definition LIKE '%COS([%' AND definition NOT LIKE '%@nx-cx%'
```

**This cannot work.** The broken functions still contain `@nx-cx` in their
`WHERE` and `ORDER BY` clauses — only the returned distance expression was
wrong — so the second clause never held. It returned **0 on a fully broken
database**.

Caught during the sdss5a pre-flight: it reported `bad_distance_expr = 0` while
all four functions there plainly computed `COS([deccat]) * COS(racat)` with no
`RADIANS()`. **Had the pre-flight been skipped, step 5 would have "verified"
itself clean and production would have shipped wrong cone-search distances.**

It read clean on sdss4c only because the fix there was genuine — check C proves
it empirically, which is why the suite as a whole was not fooled.

The reliable signal is `@nx-(`: the broken form opens a subexpression there,
the correct form reads `power(@nx-cx,2)`. Validated 0 on sdss4c, 4 on sdss5a and
4 on sdss5b. Fixed in all three places it appeared.

**Generalisable:** a static check that has never been seen to fail is not a
passing check, it is an untested one. Check C caught this because it tests
behaviour rather than text.

## 9. `boss_ISM_NaI_absorption` reloaded

Ani dropped it by mistake. The default trace pinned it exactly —
`2026-07-29 12:16:08, EventClass 47, SDSS\thakar, SSMS` — which also proved the
production copies did **not** need it, since the drop postdates the backup.

Reloaded from BESTTEST using the loaders as designed: removing the single entry
from `vac_loaded.json` made `run_vac_load.py` skip all 43 others as "ALREADY"
and load only this one; same trick with `htm_added.json` for the HTM columns.
1,373,392 rows, PAGE on SPEC, htmid rebuilt and compressed.

## 10. Statistics — 123 with no histogram at all

Not stale. **Absent.** `sys.dm_db_stats_properties` returns NULL.

Cause is structural: the loaders create the clustered index **before** inserting
rows (right for storage — rows land in key order, already compressed) so the
statistics object is created against an empty table, and bulk loading with
`TABLOCK` never builds a histogram.

| group | stats | never built | rows behind them |
|---|---:|---:|---:|
| `mos_*` | 397 | 96 | 1,886,070,000 |
| VAC / astra / spectro | 2,309 | 27 | 74,055,504 |
| legacy (PhotoObjAll, SpecObjAll…) | 494 | **0** | 0 |

**The user's scoping call saved the day here** — the legacy carried-over tables
are entirely clean, and including PhotoObjAll would have turned an hour into
most of a day for nothing.

**Missing histograms are worse than stale ones.** `auto_update_statistics` is ON
but async is OFF (the SQL Server default, not a decision), so the first query
touching one of these blocks while it builds — and until then the optimizer
guesses tiny row counts, which on a 279M-row table can produce a plan that runs
for hours. Async would be *worse* here, not better, for exactly that reason.

`dr20/run_update_stats.py`, resumable, tracked per server.

### Two errors of mine in that script, both caught by watching the real run

1. **The work unit was the table.** FULLSCAN scans the table once *per
   statistic*, so fixing one missing histogram on `mos_allwise` (60.4 GB,
   9 statistics) read ~540 GB instead of 60 GB. Now targets the single
   statistic.
2. **The estimate was 10x wrong.** Calibrated on one unrepresentative table
   (`mos_supercosmos`, 229 MB/s) and costed distinct table size rather than scan
   volume. Corrected to 104 MB/s and scan volume:

| scope | statistics | scan volume | published | actual |
|---|---:|---:|---:|---:|
| `unbuilt` | 122 | 252.5 GB | "17 min" | **11–18 min** |
| `dr20` | 585 | 3,109.5 GB | "50 min" | **hours** |

Then corrected *again* — the prod boxes are much faster than sdss4c
(sdss5b sustained 387 MB/s), so the script's own estimate over-predicts by 2–4x.
**sdss5b 11.1 min, sdss5a 17.6 min.**

I also claimed step 11 must follow step 10 because statistics grow the log.
**Withdrawn** — `UPDATE STATISTICS` is essentially a read. sdss5a's logs were
shrunk to 2.50 GB, ran the full 252.5 GB pass, and were still 2.50 GB. All four
shrinks in the repeat run were no-ops.

## 11. Both production boxes taken through the runbook

sdss5a and sdss5b, steps 1–11 each, driven **remotely from sdss4c** — nothing
was copied to the production machines. Every result matched across all three
databases, including the allspec fingerprint.

The pre-flight is what made this safe, and is worth keeping as a habit: it
confirmed the restore was complete, no other sessions were connected, the FK
precondition held, and every fix was still un-applied — and it caught the broken
check in §8.

---

## Corrections to yesterday's notes

- **`mangaDRPall` does not have `htmid = 0` on every row.** It is fully
  populated — from `ifura`/`ifudec`, while `fGetNearbyMangaObjEq` returns
  `objra`/`objdec`. 483 of 11,273 rows (4.3%) disagree. A mild form of the spAll
  bug. Worth re-checking the other tables in that list the same way.
- **`sdssTiledTargetAll`** does have htmid = 0 on all 1,056,872 rows, but its
  `cx/cy/cz` are correct — only htmid was never populated.

## Things deliberately not done

- **`fGetNearbyTiledTargetsEq` has never worked.** It joins a table named
  `TiledTarget`, which does not exist — the `sdssTiledTarget` view was
  deliberately commented out in 2010 ("broken, no unTiled col"). Dead ~15 years.
  Recorded as `DEAD` in the suite rather than revived on go-live eve.
- **`mangaDRPall` htmid source** — a science question (object position vs IFU
  centre), not an obvious bug. Declared `KNOWN-GAP`.
- **The two stored procedures in the database** still reference
  `boss_clam_params`; the `.sql` sources are fixed but the compiled copies are
  not.

---

## Repository

Eight commits pushed to `dr20`. One wrinkle: the push was rejected because Ani
had pushed two commits meanwhile — resolved by **rebasing our six onto his**,
not force-pushing.

**Discovered: `C:\sqlloader` is a git working copy on `master`, not `dr20`.**
Committing there would have put the whole DR20 schema state on master in one go
— along with a file deletion and several months-old edits — settling the open
"does dr20 merge to master" question by accident. The user has redirected Ani to
commit to `dr20`.

Of his 21 modified files, **16 already match `dr20` in content** and only look
modified because of the branch. A first comparison suggested many real
differences; that was **line endings** — this repo has mixed CRLF/LF and
`git show` returns the stored blob. Re-checked with `--strip-trailing-cr`.

Warning worth passing on: `git checkout dr20` with 21 modified files may refuse
outright. Safe sequence is `git stash -u` → `git checkout dr20` →
`git stash pop`. Backups of all 25 changed files, including the deleted
`spiders_quasar.sql` recovered from git, are in the session scratchpad at
`csqlloader_backup_20260729_1500`.

## Also

`CLAUDE_CODE_DISABLE_MOUSE_CLICKS=1` added to a new
`~\Documents\WindowsPowerShell\profile.ps1` (all-hosts). Clicking the terminal
merely to focus it was being consumed as an answer to permission prompts —
a known open issue, anthropics/claude-code#70685. Several tool calls today were
rejected that way. `Ctrl+`` focuses the terminal from the keyboard instead.

---

## Current state

- **sdss5a, sdss5b: signed off as ready for production and for a fresh backup.**
- **sdss4c**: statistics still running at 226/236, the last handful being the
  largest tables. Loading machine only. `dr20/stats_updated.json` is left
  untracked until it lands.
- Metadata: **907 objects / 32,466 columns / 234 viewcols** on both prod boxes,
  `spCheckDBObjects` and `spCheckDBColumns` both 0.

## Next session

1. **Thursday 2026-07-30: DR20 goes live.**
2. Fresh backup of sdss5a/5b now that they are signed off.
3. Commit `stats_updated.json` once sdss4c finishes.
4. Ani commits his working copy to `dr20`, not master.
5. Re-run the two stored procedures so the compiled copies drop
   `boss_clam_params`.
6. Post-launch: **~325 GB of uncompressed htmid indexes** — `run_htm_add.py`
   creates every one without compression (24 of them, PhotoObjAll's three
   accounting for ~314 GB). One clause in the script fixes the source.
7. Post-launch: `mangaDRPall` htmid source; `spCheckDBIndexes` with Ani;
   the `fIndexName` widening.

Still open from before: scoped DELETE for the metadata load, 42 `mos_*` tables
with a clustered index but no IndexMap row, the 2 spAll rows missing from
`IndexMap.sql`, PRIMARY reclaim, cherry-pick to master, generating the
fGetNearby family from a table list.
