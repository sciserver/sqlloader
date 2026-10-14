# lumberjack "Hourly Weblog Update2": steps 1, 2 (and 6) review

Date: 2026-10-14. This was a read-only review; nothing on lumberjack was changed.
Follows on from `lumberjack_mydbsql_findings.md` (the step 5 rework).

## Job layout and timings

| Step | Command | Avg duration (msdb, 2026-10-07 .. 10-14) |
|---|---|---|
| 1 | `EXEC spCopyWeblogs` | ~640 s (570-700 s) |
| 2 | `EXEC spCopySqlLogs` | ~300 s (140-1500 s, highly variable) |
| 3 | `-- EXEC spCopyRemoteWeblogs` | commented out |
| 4 | `-- EXEC spCopyRemoteSqlLogs` | commented out |
| 5 | `EXEC dbo.spCopyLocalCasJobsSqlLogs2` | ~1 s (after the 2026-10-13 switch) |
| 6 | `EXEC spUpdateTrafficStats` | ~200 s, flat (not reviewed yet) |

The job starts on the hour. Steps 1+2 finish around :16, which explains the blocking
clusters at :13-:20.

---

## Step 1: `spCopyWebLogs` (IIS web logs, method = XCOPY)

### What it does

1. `TRUNCATE WebLogTemp`.
2. Deletes **all of the current UTC day** from `weblogAll` for every ACTIVE XCOPY source
   (the date of `min(LogSource.tstamp)`).
3. Uses a cursor over the 36 ACTIVE XCOPY sources. For each one, it runs
   `xp_cmdshell BcpWeblogNew.exe <unc path> c:\ClusterStorage\Volume1\WebLogImport <yyyy-mm-dd>`,
   then does `INSERT weblogAll WITH (TABLOCK) SELECT ... FROM WebLogTemp`, truncates the temp
   table, and sets `tstamp = getutcdate()`.

So yes, step 1 rewrites the whole day every hour.

### Findings

- **The DELETE is cheap.** It seeks on the clustered key `(yy, mm, dd, ...)`, and the step log shows
  "deleting" and "done deleting" in the same minute.
- **The rewrite is not where most of the time goes.** The duration by hour of day (local time, EDT):

  | Local hour | UTC hour | Avg step 1 |
  |---|---|---|
  | 21 | 01 | 571 s (1 h of data) |
  | 08-17 | 12-21 | 645-665 s |
  | 18-20 | 22-00 | 676-706 s (00 UTC run rewrites all of yesterday) |

  Rewriting a full day costs about 110 s. **About 570 s is a fixed cost that doesn't scale with
  rows.**
- **21 of the 36 ACTIVE XCOPY sources are dead.** They loaded 0 rows in the past 7 days:

  | Pattern | logIDs |
  |---|---|
  | W3SVC1338999339 | 1, 12, 22 |
  | W3SVC1892442164 | 6, 13, 24 |
  | W3SVC469019628 (ORG) | 1002, 1022, 2022 |
  | W3SVC469008127 (NET) | 1003, 1023, 2023 |
  | W3SVC1528735556 (OSQ) | 1011, 1012, 1013 (3 rows in 7 days in total) |
  | W3SVC6 (SSx) | 2091, 2092, 2093 |
  | W3SVC8 (SSy) | 2101, 2102, 2103 |

  `\\dsa001\LogFiles\W3SVC1338999339` holds only 2 files: `ex260226_x.log` and `ex260227_x.log`.

- **15 live sources** load ~50k-125k rows/day each: 4, 14, 15, 16, 17, 23, 31, 32, 33, 1001,
  2009, 2011, 2019, 2021, 2029.
  (W3SVC1, W3SVC463916812, W3SVC713567506 and W3SVC1858982642 on dsa001/003/005.)
- **`BcpWeblogNew.exe` is not built from any source in this repo.** `schema/log` has five candidates
  (`bcpWeblog.cs`, `bcpWeblogIIS5.cs`, `bcpWeblog.js`, `bcpWeblogIIS6.js`, `bcpCopy.js`), all from
  the 2015 initial commit. All five take `<folder> <minDate> [flag]`, and in all of them a third
  argument turns bcp OFF. The deployed call passes `<folder> <output dir> <date>`. With the old code,
  the output folder would be read as the date and bcp would be disabled, yet rows do get loaded.
  So the exe was rewritten (it now has an output-directory argument). Its internals, and so the fixed
  570 s, are unknown. Note: the old `^ex.*\.log$` pattern does match `ex*_x.log`, so the file naming
  is not evidence either way. "BcpWeblogNew" doesn't appear anywhere in `C:\sqlloader` either.
  The source is probably beside the exe in `c:\ClusterStorage\Volume1\WebLogImport` on lumberjack,
  or with the job owner (`SDSS\victor`).
- **Update (same day): the deployed exe was disassembled.** `bcpWeblogNew.exe` (14 Aug 2017, 20 KB) was
  copied from `C:\ClusterStorage\Volume1\WebLogImport` and read with `ildasm`; it was not executed.
  It is a .NET 2.0 build of a **modified `bcpWeblog.cs`** (assembly `bcpWeblog.exe`, version
  1.0.6435.31112). Usage: `bcpWeblog <data-directory> <temp-directory> MinAge [-SuppressBcp]`.
  The folder also holds earlier builds (`bcpWeblogNewMar07.exe` 2007, `Old` 2009, `Keep`/`Prev` 2016),
  but no source code. For each source, the exe does the following:
  1. `ScanFolder`: `GetFiles()` on the UNC folder **and every subfolder**. For each `^ex.*\.log$` file it
     opens the file and reads the first 5 lines.
  2. **Date logic:** it takes the timestamp of the first data line, **adds 1 day**, and uses that date for
     **every row** in the file. Files whose date is earlier than MinAge are skipped. This assumes each IIS file
     starts with a buffered line from 23:59 the previous evening. If a file ever started after midnight,
     its whole day would be stamped as the next day. Checked: there are no future-dated rows, and logID 2009
     has complete, normal daily counts for 2026-09-15 .. 10-14. So it holds in practice, but it's a latent
     bug for a quiet site.
  3. Copies the whole log file to `<tempDir>\weblog.txt`, parses it, and writes `<tempDir>\bcp.tmp`
     **as UTF-8 with a BOM**, then runs `bcp.exe weblog.dbo.weblogTemp in ... -c`. Because the file is
     on the CSV volume, every hour each live day-file goes through a full copy, a rewrite, and a bcp.
  4. **The BOM makes bcp reject row 1 of every file**: `rejectedBcpRecords.txt` shows
     `Row 1, Column 1: Invalid character value for cast specification` on `ï»¿2026 10 14 0 23:59:54 ...`.
     That costs one row per file per day (the 23:59 straggler), and the step reports success regardless.
     Easy to fix if the exe is ever rebuilt (`new UTF8Encoding(false)`).
- **The fixed ~570 s is (very probably) the exe opening every old log file.** File counts in the 12 live
  folders (gathered on lumberjack, 2026-10-14):

  | Server | W3SVC1 | W3SVC463916812 | W3SVC713567506 | W3SVC1858982642 | Oldest |
  |---|---|---|---|---|---|
  | dsa001 | 1578 (31.8 GB) | 1577 (13.0 GB) | 1577 (16.5 GB) | 1577 (8.5 GB) | 2022-05-22 |
  | dsa003 | 1300 (6.9 GB) | 1608 (12.3 GB) | 1608 (17.4 GB) | 1608 (9.2 GB) | 2022-05-21 |
  | dsa005 | 1104 (6.9 GB) | 1608 (12.4 GB) | 1610 (17.3 GB) | 1610 (9.1 GB) | 2015-01-27 |

  Folder listing takes under 1 s. But `ScanFolder` opens **every** file to read 5 lines, before checking
  the date. 18,365 files in distinct folders plus 4,795 from the duplicate-registered W3SVC1858982642
  folders makes **~23,160 SMB file opens per hour**. 570 s / 23,160 ≈ 25 ms per open, which is normal for
  SMB. It also fits the step log (about 1 min per live source).
  Not yet proven by a direct timing; see "Proving it" below.
  **The fix needs no code change:** move the already-loaded old logs out of the scanned tree. `ScanFolder`
  recurses, so an `old\` subfolder would still be scanned; use a sibling folder, e.g.
  `\\dsaNNN\LogFiles\archive\W3SVCxxx`. Keeping ~7 days would cut ~23k opens to ~100.
  That's ~210 GB on the web servers; retention is the web team's call.
- **Step 1 also double-loads three folders.** Each is registered under two ACTIVE logIDs:

  | Folder | logIDs | Rows on 2026-10-13 (each) |
  |---|---|---|
  | `\\dsa001\LogFiles\W3SVC1858982642\` | 4 (V15), 15 (V2) | 79,707 |
  | `\\dsa003\LogFiles\W3SVC1858982642\` | 16 (V12), 23 (V10) | 80,191 |
  | `\\dsa005\LogFiles\W3SVC1858982642\` | 14 (V8), 17 (V13) | 81,088 |

  The counts are identical, so every hour 3 of the 15 live sources are processed a second time for
  nothing, and ~240k duplicate rows/day land in `weblogAll`. This is the same pattern as SDSS4J/4K in step 2.
- In the step log (1-minute resolution), dead sources finish within the same minute and live ones take
  about 1 minute each. **The step log in `sysjobhistory` is truncated** at ~4000 characters (about 6
  minutes into the step), so no full per-source breakdown is available.
- Minor: a handful of rows per day (7 for logID 2009 on 10-14) are stamped 23:59:5x on the current day.
  These are probably lines buffered across the IIS file rollover that take the new file's `#Date:`.
  This is harmless and is noted for completeness.

---

## Step 2: `spCopySqlLogs` (SQL logs from SkyServer DB servers, method = TSQL)

### What it does

A cursor runs over the ACTIVE `service='SQL'` / `method='TSQL'` sources. For each one:

1. `DELETE SqlLogAll WHERE logid = @logID AND theTime > cast(@tStamp as varchar(35))`
2. `sp_testlinkedserver`. If that fails, it writes an `ErrorLog` row and moves to the next source.
3. Runs a dynamic `INSERT SqlLogAll SELECT ... FROM <server>.weblog.dbo.sqlLogUtc WHERE theTime > @tStamp ORDER BY theTime DESC`
4. `UPDATE LogSource SET tstamp = getutcdate()`

This is incremental (only rows since the last run), not a whole-day rewrite.

### Findings

- **The DELETE reads all of a source's history every hour.** The estimated plan is
  `Index Seek(I_SQLlogAll_LogID) SEEK: logID = @x  WHERE: theTime > ...`. `theTime` is a
  residual, so every row ever logged for that source is read to find about an hour's worth.
  `I_SQLlogAll_LogID` is keyed `(logID)` plus the clustered key `(yy, mm, dd, hh, ...)`, so a
  `yy/mm/dd` predicate can seek.
  Row counts per live source (stats histogram, 2026-10-13): 2179 and 2181 ~138M each, 2080 109M,
  2173 105M, 2174 74M, 2079 40M, and others smaller. That's **~700M index rows read per hour.**
  How much of that is already in the buffer pool probably explains the 140-1500 s spread.

- **Measured fix** (logID 2177, ~15M rows, `@t = '2026-10-14 15:11'`, read-only `count(*)`):

  | Predicate | Logical reads | CPU | Elapsed | Rows |
  |---|---|---|---|---|
  | current: `theTime > cast(@t as varchar(35))` | 252,491 | 2,763 ms | 878 ms | 27 |
  | + `yy/mm/dd` OR predicate (as in step 1) | 252,491 | 1,791 ms | 668 ms | 27 |
  | + `yy/mm/dd` OR predicate + `OPTION (RECOMPILE)` | **117** | **0 ms** | **4 ms** | 27 |

  `RECOMPILE` is required. With local variables behind an `OR`, the optimizer doesn't build seek
  ranges unless it can see the values.

- **Four dead linked servers** fail every hour at ~15-20 s each and write 4 `ErrorLog` rows/hour
  (168 each over the past 7 days):

  | logID | Server | Error | Last good tstamp |
  |---|---|---|---|
  | 2081 | SDSS3U | Failed to connect | 2024-08-28 |
  | 2082 | SDSS3V | Login timeout / server not found | 2018-08-30 |
  | 2170 | SDSS4A | Failed to connect | 2022-04-15 |
  | 2178 | SDSS4I | Cannot generate SSPI context | 2023-12-12 |

  The failures land in `ErrorLog` and the step still reports success.

- **Duplicate data.** Two servers each have two ACTIVE LogSource rows (DR17 and DR18 product labels)
  pointing at the same `pathname`:

  | Server | logIDs | Total rows each (approx) |
  |---|---|---|
  | SDSS4J | 2179 (DR17), 2181 (DR18) | ~138M / ~138M |
  | SDSS4K | 2180 (DR17), 2182 (DR18) | ~26M / ~22M |

  For 2026-10-13 14:00 UTC, 2179 and 2181 each have 9,362 rows with identical time ranges, and the
  `INTERSECT` on (theTime, clientIP, statement) matched 9,274 distinct rows. So every SDSS4J/4K query
  has been logged twice, and any SqlLog statistics for those servers are doubled. The DR18 row was
  evidently added later (4K's totals differ), without retiring the DR17 row.

- Minor: `ORDER BY theTime DESC` on the remote SELECT only adds a remote sort.
  `cast(@tStamp as varchar(35))` truncates to the minute, which is harmless (a slightly larger
  overlap, and it's consistent between the DELETE and the INSERT).

---

## Recommended steps

None of these have been applied.

| # | Step | Expected gain | Risk / notes |
|---|---|---|---|
| 1 | **Step 2 DELETE:** add the `yy/mm/dd` OR predicate on `@tStamp` and `OPTION (RECOMPILE)` | Most of step 2 (measured ~2000x fewer reads per source) | Low. Same rows, now a seek. Script with rollback to be drafted, like `switch_step5_to_v2.sql` |
| 2 | **Set an output file on job step 1** (Advanced, then Output file) | Full per-source timing from the existing `print`s | Logging only. Needed to find the 570 s |
| 3 | **Mark the 4 dead linked-server sources INACTIVE** (2081, 2082, 2170, 2178) | ~60-80 s/hour; stops `ErrorLog` noise | Very low; reversible |
| 4 | **Mark the 21 dead XCOPY sources INACTIVE** (list above) | Probably under a minute, but less noise | Very low; reversible. Confirm with the web team that these sites are retired |
| 5 | **Retire the duplicate LogSource rows** (2181/2182 or 2179/2180) | Ends the double-logging | Decide which ID to keep, and whether to delete the ~160M duplicate rows already stored (large DELETE; plan it separately) |
| 4b | **Move IIS logs older than ~7 days out of the 12 live folders** to a sibling `archive\` tree (not a subfolder) | Most of step 1's fixed ~570 s (~23k file opens/hour down to ~100) | Low for the load (old days are already in `weblogAll`). The web team decides retention and where the archive lives |
| 5b | **Retire one logID of each step 1 duplicate pair** (4/15, 16/23, 14/17) | ~20% of step 1's live-source work; ends ~240k dup rows/day | Same decision as #5 (which ID to keep; historical cleanup separate) |
| 6 | ~~Find the source for `BcpWeblogNew.exe`~~ **Done.** It's disassembled (see step 1). If it is rebuilt: write UTF-8 without a BOM, take the date from the file name or `#Date:` instead of first line + 1 day, and stop opening every file in the folder | Removes the row-1 rejects and the latent date bug | Needs a rebuild and redeploy; a separate decision |
| 7 | **Review step 6** `spUpdateTrafficStats` (~200 s flat) | Unknown | Not started |

### Reproducing the checks

```sql
-- step durations by hour of day
select datepart(hh, msdb.dbo.agent_datetime(h.run_date,h.run_time)) hr, h.step_id,
       avg((h.run_duration/10000)*3600+(h.run_duration/100%100)*60+h.run_duration%100) avg_s
from msdb.dbo.sysjobhistory h join msdb.dbo.sysjobs j on j.job_id=h.job_id
where j.name like 'Hourly Weblog Update2%' and h.step_id in (1,2,6) and h.run_date>=20261007
group by datepart(hh, msdb.dbo.agent_datetime(h.run_date,h.run_time)), h.step_id;

-- rows per XCOPY source over the last 7 days (seeks on the yy/mm/dd clustered key)
select s.logID, s.instance, s.pathname, count(w.logID) rows_7d
from LogSource s left join weblogAll w on w.logID=s.logID and w.yy=2026 and w.mm=10 and w.dd>=7
where s.method='XCOPY' and s.isvisible=1 and s.status='ACTIVE'
group by s.logID, s.instance, s.pathname order by rows_7d desc;

-- step 2 DELETE predicate, current vs seekable (read-only count)
SET STATISTICS IO, TIME ON;
declare @t datetime = '2026-10-14 15:11';
select count(*) from SqlLogAll where logid=2177 and theTime > cast(@t as varchar(35));
select count(*) from SqlLogAll where logid=2177 and theTime > @t
  and (yy > datepart(yyyy,@t) or (yy = datepart(yyyy,@t) and mm > datepart(mm,@t))
       or (yy = datepart(yyyy,@t) and mm = datepart(mm,@t) and dd >= datepart(dd,@t)))
option (recompile);
```
