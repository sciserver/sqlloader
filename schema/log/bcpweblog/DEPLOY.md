# bcpweblog: deployment runbook for lumberjack

DRAFT 2026-10-30. Nothing in this file has been done on lumberjack yet. Every fact under "Verified" was read on
2026-10-30 (reads only: metadata, `LogSource`, msdb, file listings).

Order matters: the new loader is installed and running **before** any more sources are given to it. The old job step
(`spCopyWebLogs` -> `BcpWeblogNew.exe`) keeps running untouched; it only reads `method = 'XCOPY'` rows, the new loader only
reads `method = 'TAIL'` rows (SPEC 4.2), so the two never see each other's sources.

## 0. Decisions needed first

| # | Decision | Who | Notes |
|---|---|---|---|
| D1 | logIDs for idieswww01-03 `W3SVC2` | Victor | `LogSource.logID` is **not** an identity; IDs are chosen by hand. In use: 1-43, 1001-1025, 2001-2202, 8001-8002, 9001. 3000-7999 is free. Choose once: `LogFileState` and `weblogAll` are keyed by it |
| D2 | `method` value (`'TAIL'` proposed) | boss / Victor | must not be `'XCOPY'`: as XCOPY the old exe matches no `u_ex*` file, yet `tstamp` moves hourly, so the sources look collected but aren't |
| D3 | Exit code when a source folder can't be listed | us | today: warning + exit 0. Proposed: load what is readable, then exit 1 so the step fails and the alert fires |
| D4 | Where the new job step goes (section 5) | Victor | recommendation: new step 2, right after "Local weblogs" |
| D5 | Volume: 10-15 M rows/day more in `weblogAll` | boss | affects table size and steps 5/6 (SPEC 4.6) |
| D6 | SPEC 7 open questions 1-2 (`bytesIn`, health checks) | boss | v1 loads `bytesIn` and keeps health-check rows |
| D7 | How far back to backfill | boss | backfill is optional and can run any time after go-live (section 7) |

## Verified 2026-10-30

- lumberjack = failover cluster, nodes SCISERVER05 / SCISERVER06 (active: 06). Windows Server 2016 (build 14393),
  SQL Server 2019 RTM-CU10 (15.0.4123.1). Python 3.13+ needs Windows 10 / Server 2016 or later: supported, at the minimum.
- `C:\ClusterStorage\Volume1\WebLogImport` is on the Cluster Shared Volume (both nodes show the same files), so the
  install moves with failover. 47 TB free.
- bcp 15.0.2000.5 (ODBC 17) on both nodes; supports `-C 65001` (bcp 13+).
- SQL Agent and SQL Server both run as `sdss\mssql` (Agent changed by Victor 2026-10-30). `SDSS\mssql` has read on
  `\\idieswww02\LogFiles\W3SVC2` and `\\idieswww03\...` (explicit ACE, Victor 2026-10-30); idieswww01 via `BUILTIN\Users`.
- `weblog.dbo.LogSource`: 139 rows, `logID int` PK (not identity), unique key `(location, service, instance, product)`.
  No row has instance W1/W2/W3 under JHU/SKYSERVER. Every existing idieswww row is INACTIVE and none is `W3SVC2`.
- Job "Hourly Weblog Update2": owner sa, hourly at :00, email on failure. 6 T-SQL steps, all "quit reporting failure"
  on error: 1 `spCopyWeblogs`, 2 `spCopySqlLogs`, 3-4 commented out, 5 `spCopyLocalCasJobsSqlLogs2`,
  6 `spUpdateTrafficStats`. Step 1 takes ~11-12 min.
- Python: `python-3.14.10-embed-amd64.zip` from python.org, saved as `H:\bcpweblog_reference\python-3.14.10-embed-amd64.zip`,
  SHA256 `90905e64a840557d8c1bc4f5b74db3d7ee85e3ffb217611cac1c7813acea4159`. All 34 exe/dll/pyd files carry a valid
  Authenticode signature (32 Python Software Foundation, 2 Microsoft VC runtime). `python314.zip` (stdlib) is covered only by
  `python.cat`, which PowerShell can't check; it came in the same HTTPS download.
- Tested with that exact Python on sdss4c (`bcpweblog_compat150`, compatibility level 150): 28 unit tests; schema deploy and
  redeploy; capped incrementals resuming at the stored offset; backfill twice (delete + reload); bad-time rollback; abort;
  12 h stale sweep; backfill range check; unreachable server -> exit 1. Run from another working directory with full paths,
  as a job step would. Code: branch `bcpweblog` commit 953b483.
- The embeddable Python's `._pth` file puts it in isolated mode: `PYTHONPATH` is ignored and the current directory is not on
  `sys.path`. `bcpweblog.py` imports only the standard library, so this doesn't matter; leave `._pth` as shipped.

## 1. Pre-flight (read-only, any time)

As the account the job will run as, via the existing xp_cmdshell (it runs as the service account, `sdss\mssql`):

```sql
EXEC master..xp_cmdshell 'where bcp & where sqlcmd & bcp -v'
EXEC master..xp_cmdshell 'dir /o-d \\idieswww01\LogFiles\W3SVC2\u_ex26*'
EXEC master..xp_cmdshell 'dir /o-d \\idieswww02\LogFiles\W3SVC2\u_ex26*'
EXEC master..xp_cmdshell 'dir /o-d \\idieswww03\LogFiles\W3SVC2\u_ex26*'
```

Expect: `bcp`/`sqlcmd` found on the PATH (ODBC 17 `Tools\Binn` first), and a file list (not "Access is denied") from all three.

## 2. Install the files (no effect on anything running)

```
C:\ClusterStorage\Volume1\WebLogImport\bcpweblog\
    python\                 contents of python-3.14.10-embed-amd64.zip, as shipped
    bcpweblog.py            from branch bcpweblog, commit noted in VERSION.txt
    bcpweblog_schema.sql
    VERSION.txt             git commit, Python zip SHA256, date installed
    work\                   load files, run log (bcpweblog.log); cleaned by the loader
```

Do not copy `test_bcpweblog.py` or `check_counts.py` (`check_counts.py` does a full scan of `weblogAll`: test databases only).

Check from an admin prompt on the active node:

```
C:\ClusterStorage\Volume1\WebLogImport\bcpweblog\python\python.exe C:\ClusterStorage\Volume1\WebLogImport\bcpweblog\bcpweblog.py --help
```

## 3. Database objects (no effect on anything running)

```
sqlcmd -S lumberjack -E -C -b -d weblog -i C:\ClusterStorage\Volume1\WebLogImport\bcpweblog\bcpweblog_schema.sql
```

Creates only new objects: `LoadRun`, `LogFileState`, `weblogStage`, `LogFileStateStage`, `spStartWeblogRun`,
`spLoadWeblogStage`, `spAbortWeblogRun`. Rerunnable (tables only if missing, procs `CREATE OR ALTER`). It changes nothing
existing, but run it outside :00-:20 anyway (step 1 is busy with `weblogAll`).

## 4. Sources and catch-up (manual runs, before the job step exists)

4.1 Insert the sources (D1, D2). The old step ignores them.

```sql
INSERT INTO dbo.LogSource (logID,location,service,instance,uri,framework,product,method,pathname,tstamp,isvisible,status) VALUES
 (<id1>,'JHU','SKYSERVER','W1','skyserver.sdss.org','ASP+','DRx','TAIL','\\idieswww01\LogFiles\W3SVC2\',GETUTCDATE(),1,'ACTIVE'),
 (<id2>,'JHU','SKYSERVER','W2','skyserver.sdss.org','ASP+','DRx','TAIL','\\idieswww02\LogFiles\W3SVC2\',GETUTCDATE(),1,'ACTIVE'),
 (<id3>,'JHU','SKYSERVER','W3','skyserver.sdss.org','ASP+','DRx','TAIL','\\idieswww03\LogFiles\W3SVC2\',GETUTCDATE(),1,'ACTIVE');
```

4.2 Dry run (reads and parses, loads nothing; as yourself, so it also proves your own access):

```
cd /d C:\ClusterStorage\Volume1\WebLogImport\bcpweblog
python\python.exe bcpweblog.py incremental --dry-run
```

4.3 Catch-up. **The first incremental run reads yesterday's and today's file of every source from byte 0** (window = 2 days).
At today's sizes that's ~1 day + some hours per source, ~3.5 GB and ~12 M rows for three sources; in one run that is one
transaction holding a table lock on `weblogAll` for ~15 min or more. So catch up by hand in smaller pieces, one source at a
time, each run started between :25 and :50 (after step 1, before the next :00), repeating until the log no longer says
"capped". `--max-bytes` is per file and a source has 2 files in the window, so this is at most 600 MB (~2 M rows) per run:

```
python\python.exe bcpweblog.py incremental --logid <id1> --max-bytes 300000000
```

The files the first run reads set the cut-over: yesterday is the first day the new loader owns. Earlier days are backfill
(section 7), which refuses to touch a day the loader owns.

4.4 Check:

```sql
SELECT TOP 20 * FROM dbo.LoadRun ORDER BY runID DESC;          -- all 'loaded'
SELECT * FROM dbo.LogFileState ORDER BY logID, fileName;       -- one row per file read
```

Row counts: by logID and day only (seek on the `yy, mm, dd` key prefix), never a filter on `logID` alone (full scan of a
very large table: this caused blocking on lumberjack on 2026-10-28).

## 5. Job step (Victor; D4)

New CmdExec step in "Hourly Weblog Update2":

- Command:
  `C:\ClusterStorage\Volume1\WebLogImport\bcpweblog\python\python.exe C:\ClusterStorage\Volume1\WebLogImport\bcpweblog\bcpweblog.py incremental`
- Runs as the Agent service account (`sdss\mssql`), no proxy. Process exit code 0 = success (the default).
- Output file (optional): `...\bcpweblog\work\job_output.txt`, append. The loader also writes `work\bcpweblog.log` itself.
- **Position (recommendation): new step 2, after "Local weblogs"**, so step 6 (traffic stats) sees the new rows the same
  hour. On success: go to next step. On failure: quit reporting failure, like every other step today, so the email fires.
  Trade-off: while the new step fails, steps 2-6 (SQL logs, CasJobs logs, traffic stats) are skipped for that hour, as they
  already are when step 1 fails. Alternative: on failure "go to next step"; then the remaining steps run but the job may
  report success (the outcome follows the last step), so the failure would only show in the step history. Victor's call.

Runtime once caught up (measured on sdss4c, idieswww01 only): ~1 s read + ~2-3 s load per hour per source.

## 6. After go-live: checks

- First 2-3 runs: job history green; `LoadRun` one `loaded` row per hour; `work\bcpweblog.log` shows each source "listed N,
  matched N" and 0 rejects.
- A source the account can't list is today a WARNING only (D3). Look for it in the log until D3 is decided.
- Known harmless case (seen on sdss4c 2026-10-30): a log file created just before a run can show size 0 and is skipped once
  with no message; the next run reads it from byte 0.
- `weblogAll` growth and steps 5/6 duration (D5).

## 7. Backfill (optional, D7)

```
python\python.exe bcpweblog.py backfill --logid <id> --from 2026-10-01 --to <day before the cut-over>
```

One transaction per day, ~95 s read + ~225 s load per idieswww02 day on sdss4c. It deletes those days for those logIDs before
loading, so a rerun is safe. Run outside :00-:25 (it locks `weblogAll` while inserting). idieswww01 was monthly until
2026-10-30 13:38 UTC (`u_ex2610_x.log`) and daily since (`u_ex261030_x.log`); backfill handles both names.

## 8. Rollback

- Stop: disable or delete the new job step, or `UPDATE dbo.LogSource SET status = 'INACTIVE' WHERE logID IN (<ids>)` (the
  loader then has nothing to do and exits 0). The old step is never affected.
- Remove loaded rows, if wanted: per day and logID, the same batched seek delete as `spLoadWeblogStage` uses for backfill.
- The new tables and procs can stay; nothing else uses them.
