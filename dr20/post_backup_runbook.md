# RUNBOOK — replay the post-backup fixes on a restored BestDR20

**Use this on sdss5a and sdss5b**, each restored from
`BestDR20_20260728`. That backup predates every change below, so a fresh
restore brings back the broken spAll spatial index, the wrong distance
expressions, `boss_clam_params`, and the varchar `allspec.specobjid`.

No re-backup is planned — these go in **in situ**.

**Rationale, evidence and measurements for every step: `post_backup_fixes.md`.**
This file is only the sequence.

**Total run time: roughly 30–45 minutes**, dominated by steps 2 and 3.

---

## Before you start

```powershell
cd H:\GitHub\sqlloader\dr20
```

- [ ] Confirm you are on the **restored copy**, not sdss4c.
- [ ] Every script opens with `USE BestDR20;` — **if the restored database has a
      different name, change it in each script** or it silently targets the
      wrong database.
- [ ] Always pass **`-b`** so a failure returns a non-zero exit code and you
      don't run the next step on top of a failure.
- [ ] Check the metadata foreign keys are absent (they were dropped 2026-07-28,
      *before* the backup, so a restore should already lack them). Step 8 needs
      them gone:

```powershell
sqlcmd -S <server> -d BestDR20 -E -Q "SELECT name FROM sys.foreign_keys WHERE referenced_object_id=OBJECT_ID('DBObjects');"
```
Expect **no rows**. If any appear, run `drop_metadata_fks.sql` first.

---

## Punchlist

| # | Step | Script | ~Time |
|---|---|---|---|
| 1 | Drop the retired `boss_clam_params` VAC | `drop_boss_clam_params.sql` | 1 min |
| 2 | Rebuild spAll's spatial index from `racat`/`deccat` | `fix_spall_htm.sql` | 10 min |
| 3 | `allspec.specobjid` varchar → `numeric(30,0)` | `fix_allspec_specobjid.sql` | 10–20 min |
| 4 | PAGE-compress `ix_allspec_htmid` | inline, below | 1 min |
| 5 | Fix 4 `fGetNearby*XYZ` distance expressions | `fix_nearby_distance.sql` | seconds |
| 6 | Fix 3 `fGetNearest*Eq` missing `ORDER BY` | `fix_nearest_orderby.sql` | seconds |
| 7 | Document allspec's 7 NCIs in IndexMap | `add_indexmap_allspec_nci.sql` | seconds |
| 8 | Regenerate and reload the metadata | see below | 1 min |
| 9 | **Verify everything** | `verify_spatial.sql` | 1 min |
| 10 | Build the statistics | `run_update_stats.py` | ~41 min |
| 11 | Checkpoint and reclaim the transaction logs | see below | minutes |

> **Step 11 must follow step 10.** Building statistics generates log activity,
> so shrinking the log before it just means growing it again. On sdss5a the log
> shrink was run before step 10 existed, so 5a needs step 11 repeated after its
> statistics pass.

---

## 1. Drop the retired `boss_clam_params` VAC

The VAC owner confirmed it is not shipping in DR20. Removes the table
(1,708,214 rows / 1,674 MB on SPEC) and its metadata rows. Its sibling
`boss_clam_lite` **is** still shipping and is untouched.

```powershell
sqlcmd -S <server> -d BestDR20 -E -b -i drop_boss_clam_params.sql
```

Expect: `169 DBColumns`, `1 IndexMap`, `1 DBObjects` deleted, `boss_clam_params
dropped`, and the final row showing `absent | 0 | 0 | 0 | 64`.

## 2. Rebuild spAll's spatial index

The most serious of the fixes. `htmid`/`cx`/`cy`/`cz` were computed from
`plug_ra`/`plug_dec`, which hold the `-9999` null sentinel for 91.6% of rows —
so 4.9M rows were invisible to cone search, and a search at ra=81/dec=81
returned them all as spurious hits. Rebuilt from `racat`/`deccat`.

```powershell
sqlcmd -S <server> -d BestDR20 -E -b -i fix_spall_htm.sql
```

Expect: `5357037 rows updated`, then the "after" biggest-htmid-pile in the
**hundreds**, not millions.

> Do not add a `GO` inside this script. The guard, the `UPDATE`, the `COMMIT`
> and the index rebuild are deliberately one batch — `RETURN` only exits its own
> batch, so a `GO` would let the `UPDATE` run after the guard refused.

## 3. Convert `allspec.specobjid` to `numeric(30,0)`

**Not `numeric(20)`.** The column holds a union of two id schemes — 5.8M legacy
values of ≤20 digits and 10.8M SDSS-V values of 25–29 digits — so `numeric(20)`
overflows 65% of the non-null rows.

```powershell
sqlcmd -S <server> -d BestDR20 -E -b -i fix_allspec_specobjid.sql
```

Expect the before and after **fingerprints to be identical**, and 8 indexes
listed at the end. The script aborts by itself if either differs.

## 4. PAGE-compress `ix_allspec_htmid`

The one allspec NCI still uncompressed while its six siblings were PAGE.

```powershell
sqlcmd -S <server> -d BestDR20 -E -b -Q "USE BestDR20; ALTER INDEX ix_allspec_htmid ON allspec REBUILD WITH (DATA_COMPRESSION = PAGE, SORT_IN_TEMPDB = ON);"
```

On sdss4c this took 2,599.74 MB → 1,807.80 MB.

## 5. Fix the four `fGetNearby*XYZ` distance expressions

They recomputed the returned distance from ra/dec **without converting degrees
to radians**, so a zero-separation self-match reported 9825 arcmin. The row
*filter* was correct, so only the reported number was wrong.

```powershell
sqlcmd -S <server> -d BestDR20 -E -b -i fix_nearby_distance.sql
```

## 6. Fix the three `fGetNearest*Eq` missing `ORDER BY`

They did `SELECT TOP 1` over the Nearby XYZ function with no ordering, returning
an **arbitrary** object from the cone rather than the nearest.

```powershell
sqlcmd -S <server> -d BestDR20 -E -b -i fix_nearest_orderby.sql
```

Expect `3 altered, 0 already correct` and
`verified: every fGetNearest* taking TOP 1 now orders by distance`.

## 7. Document allspec's 7 nonclustered indexes in IndexMap

They exist on disk but were undocumented, so a rebuild driven from IndexMap
would silently drop them.

```powershell
sqlcmd -S <server> -d BestDR20 -E -b -i add_indexmap_allspec_nci.sql
```

Expect `7 IndexMap row(s) inserted`, then 1 `K` row and 7 `I` rows for allspec.

## 8. Regenerate and reload the metadata

**Do this after steps 1–7, not before.** `VacTables.sql` and
`SpectroTables.sql` were both edited (boss_clam_params removed, allspec's
specobjid retyped), so the generated metadata must be rebuilt from them or it
will still describe the old schema.

This also supersedes the DBObjects/DBColumns deletions in step 1 — those tables
are truncated and reloaded wholesale.

```powershell
cd C:\sqlloader\vbs
python parseSchema2sql.py xschema.txt 

cd C:\sqlloader\schema\csv
sqlcmd -S <server> -d BestDR20 -E -b -i loaddbobjects.sql
sqlcmd -S <server> -d BestDR20 -E -b -i loaddbcolumns.sql
sqlcmd -S <server> -d BestDR20 -E -b -i loaddbviewcols.sql
```

- Always run the **full** `xschema.txt`. The emitted `TRUNCATE` is whole-table,
  so a partial run wipes the metadata for every file not included.
- The whole load is ~12 seconds. Each file asserts its own row count before
  committing and rolls back if it disagrees.
- Then confirm both directions are clean:

```powershell
sqlcmd -S <server> -d BestDR20 -E -Q "USE BestDR20; EXEC spCheckDBObjects; EXEC spCheckDBColumns;"
```

Expect **0 and 0**.

> `IndexMap` is **not** part of this step — it loads separately from
> `schema/sql/IndexMap.sql`. Step 7 already handled the live table.

## 9. Verify

```powershell
cd H:\GitHub\sqlloader\dr20
sqlcmd -S <server> -d BestDR20 -E -b -i verify_spatial.sql
```

**Every row of the summary must read OK**, and the last line must be
`verify_spatial: all checks as expected`. The sdss4c baseline is
**35 OK, 0 errors, 0 regressions**. Anything else, stop and read the detail
table before going further.

The two remaining exemptions are expected and declared in the script:
`mangaDRPall` (htmid built from `ifura`/`ifudec`) and `sdssTiledTargetAll`
(`fGetNearbyTiledTargetsEq` has been dead since 2010 — deliberately left alone).

## 10. Build the statistics

**The restore carries this problem with it** — statistics live inside the
database, so a restored copy has exactly the same missing histograms the backup
had. This is not something the restore fixes.

The loaders create the clustered index *before* inserting rows (right for
storage: rows land in key order, already compressed). But that means the
statistics object is created against an **empty** table, and bulk loading with
`TABLOCK` never builds a histogram. Measured on sdss4c 2026-07-29:

| group | stats | never built | rows behind them |
|---|---:|---:|---:|
| `mos_*` | 397 | 96 | 1,886,070,000 |
| VAC / astra / spectro | 2,309 | 27 | 74,055,504 |
| legacy (PhotoObjAll, SpecObjAll…) | 494 | **0** | 0 |

**Missing histograms are worse than stale ones.** `auto_update_statistics` is ON
but **async is OFF** (the SQL Server default), so the first query touching one of
these tables blocks while the statistic builds — and until then the optimizer
guesses tiny row counts, which on a 279M-row table can produce a plan that runs
for hours. Both are avoided by building them before anyone connects.

```powershell
cd H:\GitHub\sqlloader\dr20
python run_update_stats.py --server <server> --dry-run
python run_update_stats.py --server <server>
```

**Use the default `--scope unbuilt`.** It targets each missing statistic
individually rather than rebuilding whole tables, which matters far more than it
sounds: **FULLSCAN scans the table once per statistic.**

| scope | statistics | scan volume | time |
|---|---:|---:|---:|
| `unbuilt` (default) | 122 | 252.5 GB | **~41 min** |
| `dr20` | 585 | 3,109.5 GB | **~8.5 hours** |

`mos_allwise` is the clearest case: 60.4 GB with 9 statistics, of which exactly
1 is missing. Whole-table FULLSCAN reads ~540 GB; targeting the one statistic
reads 60 GB. `--scope dr20` refreshes statistics that were already built
correctly at load time and is not worth 8 hours on a production box.
- **The legacy carried-over tables are excluded deliberately** — they have 0
  missing histograms, and PhotoObjAll alone would take this from under an hour
  to most of a day for no benefit.
- FULLSCAN is the default and is the right call: write-once data that will serve
  for a year deserves exact histograms, and sampling is weakest exactly on the
  hundred-million-row tables where it matters most. `--sample` is the fast,
  weaker alternative.
- **Resumable.** Each table is recorded in `stats_updated.json` as it finishes,
  keyed by server, so an interrupted run resumes and each of 4c / 5a / 5b is
  tracked separately. Smallest tables run first, so a kill has already banked
  the quick wins.
- The script reports, at the end, how many statistics still lack a histogram.
  **That number must be 0.**

## 11. Checkpoint and reclaim the transaction logs

**Do this last**, after everything above has succeeded and verified. Step 10
rewrites nothing but reads a great deal; steps 2–4 are what grow the log.

BestDR20 is in **SIMPLE** recovery, so a `CHECKPOINT` truncates the log; the
files then need shrinking to actually return the space. Steps 2, 3 and 4 each
rewrite a large amount of data, so the log will have grown.

```powershell
sqlcmd -S <server> -d BestDR20 -E -b -Q "USE BestDR20; CHECKPOINT; DBCC SHRINKFILE (BESTDR8_Log1, 512); DBCC SHRINKFILE (BESTDR8_Log2, 512); DBCC SHRINKFILE (BESTDR8_Log3, 512); DBCC SHRINKFILE (BESTDR8_Log4, 512);"
```

Then confirm what came back:

```powershell
sqlcmd -S <server> -d BestDR20 -E -Q "USE BestDR20; SELECT name, CAST(size*8.0/1024/1024 AS decimal(10,2)) AS gb, CAST(FILEPROPERTY(name,'SpaceUsed')*8.0/1024/1024 AS decimal(10,2)) AS used_gb FROM sys.database_files WHERE type_desc='LOG';"
```

On sdss4c the four log files total **~817 GB allocated against ~0.2 GB used**,
so there is a great deal to reclaim. This is a write-once read-only database
after load, so a one-time shrink carries none of the usual fragmentation cost.

- [ ] Also worth a final `sp_spaceused` and per-filegroup size report.

---

## If something fails

- Every script is **idempotent** — re-running one that already succeeded is safe
  and reports "already done" rather than acting twice.
- Every script **guards before it acts** and refuses rather than half-applying.
  A refusal means nothing changed.
- Steps 1–7 are independent of each other except that **8 must follow 1–7**.
  If one fails you can fix it and resume from that step.
- Nothing here is destructive beyond `boss_clam_params`, which is in the backup.
