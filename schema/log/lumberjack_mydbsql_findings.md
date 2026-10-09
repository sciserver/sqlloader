# LUMBERJACK and MYDBSQL: findings and recommendations

**Date:** 2026-10-09
**Started from:** step 5 of the SQL Agent job `Hourly Weblog Update2` on LUMBERJACK
failing with deadlocks, and the job "slamming the server".
**Scope:** server-wide observations on both machines, the specific issues found,
what has been changed so far, and recommendations (including for the planned
migration).

---

## Summary

1. **Step 5's deadlocks happen on MYDBSQL, not on LUMBERJACK.** Its linked-server
   read scans all 82.7M rows of `BatchAdmin.batch.jobs` every hour, and loses
   deadlocks to the CasJobs web app.
2. **Step 5 rewrites about 250k rows a day to record about 23k jobs.** It deletes
   and re-inserts every CasJobs row "since midnight" in a fully logged,
   uncompressed 1.2 TB table, every hour.
3. **A time-zone bug has silently dropped CasJobs usage rows every evening since
   at least 2020.** Typically 7–20% of each day's CasJobs jobs are missing from
   `weblog.dbo.SqlLogAll`.
4. **Every database file on LUMBERJACK is on one volume, tempdb included.** Heavy
   weblog writes slow down `turblog`'s log flushes, which produces the blocking
   alerts there.
5. **MYDBSQL is deadlocking about once a minute on its own workload**
   (parallelism defaults, no RCSI).
6. A replacement for step 5, `spCopyLocalCasJobsSqlLogs2`, is **deployed but not
   yet switched on.** It is insert-only, copies each job exactly once, reads only
   recent rows, and fixes the time-zone bug. It cuts the daily write volume by
   about 20×.

---

## LUMBERJACK

### Server-wide

| Item | Finding |
|---|---|
| Version | SQL Server 2019 Enterprise **RTM-CU10** (March 2021) on Windows Server 2016. About 20 CUs behind |
| Storage | **Every file for `weblog`, `turblog` and tempdb is on one Cluster Shared Volume**, `C:\ClusterStorage\Volume1` (67 TB, 44 TB free) |
| tempdb | 8 data files of **8 MB each**: tiny, so presumably growing constantly. **Average write latency ~480 ms** on the data files, 46 ms on the log |
| weblog files | Data-file write latency up to **69 ms** average. **4 transaction log files** (SQL Server writes a log sequentially, one file at a time, so extra log files add nothing) |
| turblog log | 16 ms average write latency, but it shares the volume with everything above |

*Latencies are cumulative averages since the last SQL Server restart, from
`sys.dm_io_virtual_file_stats`.*

### `weblog`: the `Hourly Weblog Update2` job

| Step | Command | Avg | Max | Notes |
|---|---|---|---|---|
| 1 | `spCopyWeblogs` | 10.6 min | 16.4 min | |
| 2 | `spCopySqlLogs` | 6 min | 25 min | Highly variable |
| 3 | `-- EXEC spCopyRemoteWeblogs` | 0 | 0 | Commented out |
| 4 | `-- EXEC spCopyRemoteSqlLogs` | 0 | 0 | Commented out |
| 5 | `spCopyLocalCasJobsSqlLogs` | 46 s | 3 min | **12 of 145 runs failed (error 1205, deadlock victim)** |
| 6 | `spUpdateTrafficStats` | 3.3 min | 4.5 min | **Skipped whenever step 5 fails** (step 5's on-failure action is "quit with failure") |

A whole run averages about 20 minutes and can take up to 41.

**`weblog.dbo.SqlLogAll`:** 1.28 billion rows, about **1.2 TB, no compression**,
SIMPLE recovery, RCSI on. The clustered key is 12 columns wide
(`yy, mm, dd, hh, mi, ss, seq, theTime, logID, clientIP, requestor, server`),
plus two nonclustered indexes.

#### Issue 1: step 5 rewrites the whole day, every hour

The original `spCopyLocalCasJobsSqlLogs` deletes every CasJobs row dated on or
after the last run's date, then re-inserts all CasJobs jobs since midnight from
`MYDBSQL.batchadmin.batch.jobs`. It does this because it copies jobs while they
are still running and has to fix them up later.

Measured on 2026-10-07 (22,670 CasJobs jobs that day):

| Design | Row writes to `SqlLogAll` per day |
|---|---|
| Original (reload since midnight, hourly) | ~253k deletes + ~253k inserts (each job rewritten ~11 times) |
| Rolling 9-hour window (first draft, abandoned) | ~227k + ~227k, only ~10% better |
| **Insert-only, copy each job once when it finishes (deployed)** | **~22.7k inserts, no deletes** |

#### Issue 2: time-zone bug, evening jobs never copied

- `LogSource.tstamp` is written with `GETUTCDATE()` (**UTC**). CasJobs
  `TimeStart` is **local Eastern time**.
- Each run takes the *date* of the UTC `tstamp` and reloads jobs since midnight
  of that date in local time. From 20:00 EDT (19:00 EST) onward the UTC date is
  already tomorrow, so each later run looks only at "tomorrow" (which is empty),
  and the rest of the local day is never revisited.
- **Result:** every CasJobs job starting after the last run before the UTC date
  rollover is never copied. The gap moves by exactly one hour at each daylight
  saving change, which confirms the cause.

Sample days, source (`batch.jobs`) vs `SqlLogAll`:

| Date | Source | Copied | Missing | % | Gap starts (local) |
|---|---|---|---|---|---|
| 2020-07-15 | 7,168 | 7,168 | 0 | 0 | none |
| 2020-10-15 | 18,791 | 17,203 | 1,588 | 8.5 | 20:00 |
| 2021-04-15 | 7,388 | 6,003 | 1,385 | 18.7 | 20:00 |
| 2022-01-15 | 4,078 | 3,326 | 752 | 18.4 | 19:00 (EST) |
| 2023-04-18 | 23,628 | 20,630 | 2,998 | 12.7 | 20:00 |
| 2025-11-15 | 50,793 | 50,246 | 547 | 1.1 | 19:00 (EST) |
| 2026-01-15 | 5,602 | 4,393 | 1,209 | 21.6 | 19:00 (EST) |
| 2026-07-15 | 3,434 | 3,009 | 425 | 12.4 | 20:00 |
| 2026-09-15 | 51,162 | 45,085 | 6,077 | 11.9 | 20:00 |
| 2026-10-07 | 22,670 | 21,974 | 696 | 3.1 | 20:00 |

- Present in every sampled month from 2020-10 onward. The proc was last
  modified **2014-03-07**, so it may go back further. Occasional complete days
  (2020-07-15, 2021-01-15) are probably accidental catch-ups after a job outage
  (not verified).
- Rough scale: on the order of **a million or more rows since 2020** (estimate
  from samples).
- Jobs that start before midnight and finish after it are also never refreshed:
  their elapsed time, row count and error flag stay frozen at "still running".
- **Effect downstream:** `spUpdateTrafficStats` (step 6) builds from this table,
  so evening CasJobs usage is under-reported in the traffic statistics.
- **Recoverable:** `batch.jobs` goes back to 2003-10-09.

#### Background: where the "delete and rewrite every hour" pattern came from

`spCopyLocalCasJobsSqlLogs` (created 2012) is a near word-for-word copy of
`spCopyWebLogs` (created **2003**). Both have the same header ("deletes entries
from that log created since the minday of that log… advances the minday
timestamp") and the same `GETUTCDATE()` / `datepart(min(tstamp))` date logic.
`spCopyFNALCasJobsSqlLogs` (2008) is from the same family.

The pattern was **correct for its original source, IIS web log files**:

- **Log lines have no key.** When a growing daily file is re-copied, there's no
  way to tell which lines were already loaded. "Delete today, reload today's
  file" is the simplest way to never create duplicates.
- **IIS writes W3C logs in UTC and rolls the files over at UTC midnight** (its
  default, unless "use local time for file naming and rollover" is on; not
  checked on our web servers). So comparing UTC `tstamp` dates to log dates was
  right for web logs.
- **The table was small in 2003**, so rewriting a day of rows every hour was
  cheap.

When the template was reused for CasJobs, those assumptions quietly stopped
holding:

| Assumption in the template | Web logs | CasJobs `batch.jobs` |
|---|---|---|
| Rows have no key, so delete and reload | true | false: `JobID` is a key |
| Rows are final once written | true | false at first: jobs are copied while running, so fix-ups are needed |
| Timestamps are UTC | true (IIS default) | **false: `TimeStart` is local time**, which caused Issue 2 |
| Re-copying a day is cheap | true in 2003 | false: 82.7M-row remote scan and ~250k rewrites/day into a 1.2 TB table |

Reasons it may have been kept for CasJobs: `SqlLogAll` has no `JobID` column to
de-duplicate on; it shows running jobs the same day (with "copy when finished",
an 8-hour job appears only when it ends); jobs that never finish still get
recorded; and it matches every other copy proc in `weblog`. None of these
*require* the pattern. Nothing in the code recorded *why* the dates are UTC or
why it deletes and reloads, so whoever reused it had no warning.

**Trade-off of the new design:** a CasJobs job appears in `SqlLogAll` only
once it has finished, so up to ~8 hours late on the long queue (83 h for
`Stripe82_Long`). Jobs that never get a `TimeEnd` (about 1 in 800k recently) are
never copied.

#### Issue 3: whole days of CasJobs rows missing

**2014-07-15 (74,806 jobs) and 2017-07-18 (12,494 jobs) have no CasJobs rows in
`SqlLogAll` under any logID.** This is not the time-zone bug; it looks like a
logging outage or lost data. Other days in those years were not checked.

### `turblog`

- `dbo.particlecount` is a 2,433-row table of counters keyed by `uid`. The app
  (`turbweb`, hosts DSA003–005) increments it with
  `UPDATE ... SET records = records + @records WHERE uid = @uid`, concentrated on
  a few very hot rows (uid 10090 is at 2.6 × 10^14).
- Blocking chains observed 2026-10-09:
  - `SELECT SUM(records) FROM particlecount` waiting on `LCK_M_S` behind the
    updaters (RCSI was off).
  - Updaters queued on `LCK_M_X` behind each other.
  - **The head of each chain waiting on `WRITELOG`**, so the real bottleneck is
    log-flush latency on the shared volume, not locking itself.
- An unneeded unique nonclustered index on `uid` repeats the primary key. It's
  harmless for these updates (`records` isn't in it); it's just clutter.

---

## MYDBSQL (CasJobs, `BatchAdmin`)

### Server-wide

| Item | Finding |
|---|---|
| Version | SQL Server 2019 Enterprise CU29-GDR (October 2024) |
| Parallelism | **MAXDOP 0** (unlimited), **cost threshold for parallelism 5**. Both are factory defaults |
| `BatchAdmin` | RCSI **off**, snapshot isolation off, compatibility level 130 |
| Deadlocks | **About 456 in the ~9 hours system_health retained** (08:00–17:15 UTC on 2026-10-09), roughly one a minute. Most are **parallel exchange deadlocks**. The most common participant (2,815 appearances) is CasJobs' own "ordered list of waiting jobs" query |
| Monitoring | **Added to sql-monitor on the afternoon of 2026-10-09.** There's no history before that, and system_health only holds about 9 hours here, so earlier deadlock history is gone. Trends need a few days to build up |

### `batch.jobs`

- **82.7 million rows.** Clustered on `JobID` (bigint identity, in submit order).
- Other indexes: `WebServicesID`; `Status` (with includes); `Created_Table, TimeEnd`.
- **No index leading on `TimeStart` or `TimeEnd`.** Any query filtering on job
  times, like the original step 5 read, scans the whole table.

### Step 5's deadlocks, confirmed

Deadlock graphs on MYDBSQL from host **LUMBERJACK** match step 5's failures
(UTC): 08:23, 11:15, 12:37, 13:37, 16:14.

| | Victim | Winner |
|---|---|---|
| Host | LUMBERJACK (step 5's linked-server read) | IDIESWWW01 (CasJobs web app) |
| Statement | `SELECT Status, HostIP, TimeStart, TimeEnd, ... FROM batchadmin.batch.jobs` (full scan) | Parameterized job update (`@JobId, @TimeEnd, @Status, ...`) |
| Isolation | read committed | **repeatable read** |

LUMBERJACK's own system_health has no deadlocks, because they are detected and
recorded on MYDBSQL. The 1205 message in the job history doesn't say which
server raised it.

### `batch.Servers` (queue configuration)

- `Queue` is the job time limit **in minutes**: 1 = quick queue (~214
  contexts), 500 = long queue, 8.3 h (~206 contexts). This matches the cluster
  of jobs that stopped at exactly 8 hours.
- **Outliers that look wrong:** `Stripe82_Long` = 5000 (83 h; one job ran 83 h
  in the last 30 days), `DR8loc_Long` and `DR10collab_long` = 1500 (25 h),
  `ApogeeFire_quick` = 2.
- **Security:** the table stores **SQL login passwords in plain text** (`Password`
  column), readable by anyone with SELECT on the table.

---

## What has been done so far (2026-10-09)

| Where | Change | Status |
|---|---|---|
| sql-monitor | LUMBERJACK added to PerformanceMonitor | Done (from ~12:00 local) |
| sql-monitor | MYDBSQL added to PerformanceMonitor | Done (afternoon of 2026-10-09) |
| LUMBERJACK `turblog` | `ALTER DATABASE turblog SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK AFTER 5 SECONDS` | **Done.** Readers no longer block behind the counter updates. Any in-flight transactions at that moment were rolled back |
| LUMBERJACK `weblog` | New proc `dbo.spCopyLocalCasJobsSqlLogs2` and tables `dbo.CasJobsSqlLogStage`, `dbo.CasJobsCopyState` | **Deployed, not in use.** Live proc and job unchanged |
| MYDBSQL | Nothing | Read-only investigation only |

Source: `schema/log/spCopyLocalCasJobsSqlLogs2.sql`.

### How `spCopyLocalCasJobsSqlLogs2` works

- **Insert-only.** Every finished job (status 3, 4 or 5) has a `TimeEnd` and
  doesn't change afterwards. Each run copies jobs with
  `last cutoff < TimeEnd <= now − 5 min`, so every job is copied exactly once.
  The 5-minute lag allows for the `TimeEnd` update committing slightly after its
  timestamp.
- **Seek, not scan, on MYDBSQL.** It reads `JobID >= low-water mark`, which is
  the oldest job still unfinished at the last run (jobs submitted more than 4
  days ago are ignored as stuck), minus a 1,000-JobID safety margin. Typically a
  few thousand recent rows instead of 82.7M.
- **Local time on both sides,** which fixes the time-zone bug. (It assumes both
  servers stay in the same time zone.)
- **Staging first:** the remote read goes into `CasJobsSqlLogStage` (a permanent
  table, because tempdb is slow on this box) with no locks held on `SqlLogAll`.
  Then the insert and the state update run in **one short transaction, in
  2,000-row batches**, below the lock-escalation threshold.
- **Cut-over (first run only):** deletes the last 12 hours of CasJobs rows,
  which the old proc may have copied mid-run, and reloads them. A job running
  longer than 12 hours at that moment could end up duplicated.
- **Watermark** is kept in `CasJobsCopyState`. `LogSource.tstamp` is still set
  to the run time in UTC for anything else that reads it.
- `@dryRun = 1` reads and reports without writing to `SqlLogAll`, `LogSource`
  or the state table.
- **Its header records why**: the old pattern's web-log origin, why its times
  are local (not UTC), and that a job appears only after it finishes. This is so
  the next person to reuse it is warned.

---

## Recommendations

### Now: finish the step 5 change

1. **Dry run from a session on LUMBERJACK itself** (RDP and SSMS, or Agent).
   Remote sessions can't pass Windows credentials through the linked server
   (double hop).
   ```sql
   EXEC weblog.dbo.spCopyLocalCasJobsSqlLogs2 @dryRun = 1
   ```
   Expected: `isCutOver = 1`, roughly 85–90k `rowsToDelete` and a similar
   `rowsToInsert` (the last 12 hours).
2. **Switch step 5** to `EXEC spCopyLocalCasJobsSqlLogs2`.
3. **Add retries** to step 5:
   ```sql
   EXEC msdb.dbo.sp_update_jobstep @job_name = N'Hourly Weblog Update2',
        @step_id = 5, @retry_attempts = 2, @retry_interval = 1
   ```
4. **Consider letting step 6 run even if step 5 fails** (step 5's on-failure
   action → "go to next step"), so traffic stats aren't skipped.
5. **Remove the empty steps 3 and 4.**
6. **Watch for remaining deadlocks** after the switch. If short reads still
   collide with the web app, read `batch.jobs` with `NOLOCK`. The risk is
   copying a job whose finishing update later rolls back, which is acceptable for
   usage logs.

### Data repair (optional, team decision)

- **Backfill the missing evening rows** from `batch.jobs` (available back to
  2003). It should insert only rows that are missing, not delete and reload, and
  run off-hours in monthly chunks. An exact day-by-day count of the damage is
  also possible, but it reads every CasJobs row in `SqlLogAll`, so it should run
  off-hours too.
- **Investigate the whole-day gaps** (2014-07-15, 2017-07-18), and check other
  days in those years.
- Note in any traffic reports that evening CasJobs usage has been under-counted.

### LUMBERJACK (weblog stays here; the "new LUMBERJACK" build)

**Storage layout:** the most important change.
- **Separate volumes for data, transaction log, and tempdb**, at minimum.
  Ideally tempdb goes on fast local NVMe. Today one volume holds all three, so
  weblog's bulk writes slow down every other database's commits.
- **tempdb:** 8 equal data files (one per core up to 8), **pre-sized to several
  GB each**, with equal fixed autogrowth. Replace the current 8 × 8 MB files,
  which are growing constantly at ~480 ms per write. Put the tempdb log on the
  tempdb volume.
- **One log file per database.** Collapse weblog's 4 log files into one,
  pre-sized so it doesn't need to grow during the hourly load.

**`SqlLogAll`:**
- **PAGE compression.** It's write-once log data at 1.2 TB uncompressed. Test on
  a copy first; on SDSS tables PAGE has done better than columnstore on
  numeric-heavy data, but this table is text-heavy (`statement` varchar(8000)),
  so measure both.
- **Partition by date (e.g. monthly).** That allows per-partition compression,
  cheap removal of old data, and index maintenance on recent partitions only.
- **Narrower clustered key.** The current 12-column key is repeated in every
  nonclustered index row. Something like `(theTime, seq)` would shrink both
  nonclustered indexes. It's a large rebuild, so best done during the migration.
- **Store `JobID` for CasJobs rows** (new column). This would allow exact
  de-duplication and simple `MERGE` logic in future.

**Maintenance:** patch SQL Server from CU10 to the latest 2019 CU, or upgrade
along with the rest of the estate.

### MYDBSQL / CasJobs (for the CasJobs owners)

- **Parallelism:** set **MAXDOP** to the cores per NUMA node, no more than 8,
  and **cost threshold for parallelism** to around 50. This should remove most
  of the about one-a-minute parallel deadlocks.
- **RCSI on `BatchAdmin`:** stops read-committed readers (including step 5 and
  the job-list queries) taking shared locks. It needs testing with the CasJobs
  app; its repeatable-read transactions keep their behaviour.
- **Index on `batch.jobs (TimeEnd)` or `(TimeStart)`:** not needed by the new
  step 5, but any other job-time query scans 82.7M rows today.
- **Queue limits:** review the Stripe82 (83 h), DR8loc and DR10collab (25 h) and
  ApogeeFire_quick entries.
- **Plain-text passwords in `batch.Servers`:** restrict access, and move to
  Windows authentication or encrypted credentials.
- **Use the sql-monitor history** (MYDBSQL added 2026-10-09) to get a
  baseline of deadlocks and waits *before* changing MAXDOP, cost threshold or
  RCSI, so the effect of each change can be measured.

### Migration to the new servers (latest SQL Server, Always On AGs)

- **RCSI settings move with the databases** (backup/restore or AG seeding), so
  `turblog`'s RCSI comes along.
- **Synchronous-commit AGs make commits slower:** each commit also waits for the
  secondary to harden the log (`HADR_SYNC_COMMIT`). Hot-row workloads like
  `turblog.particlecount` will hold locks longer.
- **Delayed durability for `turblog`:** deferred until after the migration.
  - It would cut both the log-flush and the AG round-trip from each commit, but
    it **removes the "no data loss" promise of synchronous commit** for those
    transactions: recent increments can be lost on crash or failover.
  - First measure `HADR_SYNC_COMMIT` and blocking on the new hardware. With its
    own storage, `turblog` may not need it.
  - Alternative: put `turblog` in its **own AG with asynchronous commit**, which
    accepts the same trade-off explicitly and only for that database.
- **If the target is SQL Server 2025:** consider **Accelerated Database Recovery
  + optimized locking**. It reduces lock memory and blocking for updates, and
  keeps row versions in the user database instead of tempdb. Updates to the same
  hot row still queue, though.
- **Apply the storage layout recommendations above** to every new server:
  separate data, log and tempdb volumes; one log file per database; pre-sized
  tempdb.
- **Longer term for `turblog`:** have the app add up increments and write
  periodically, rather than updating a hot row per event. That removes the
  contention entirely.

---

## Open questions

- Who owns CasJobs/MYDBSQL configuration, and can they look at MAXDOP, cost
  threshold and RCSI?
- Are the Stripe82 / DR8loc / DR10collab / ApogeeFire queue limits intentional?
- Does anyone know about the 2014 and 2017 whole-day gaps?
- Is losing a fraction of a second of `turblog` counts on failover acceptable
  (decides delayed durability)?
- Does anything besides the weblog procs read `LogSource.tstamp`? (The new proc
  keeps it as "last run, UTC" to be safe.)
