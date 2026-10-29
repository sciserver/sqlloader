# Weblog: what needs fixing (TL;DR, 2026-10-29)

Short version of `weblog_collection_findings_20261027.md` (details, evidence and how to check are there).

## The problem

- **The real SkyServer page traffic has never been loaded.** `weblogAll` gets page traffic only from the old web
  servers (dsa001/003/005), and about 98% of that is load-balancer health checks. The real traffic is in `W3SVC2` on
  idieswww01-03 (about 4-5 M requests per server per day). So `trafficBase` (`hits`, the language columns,
  `SkyServer`) mostly counts health checks. Query traffic (`SqlLogAll`) is collected correctly.
- **Two things stop it, and both need fixing:**
  1. The current loader (`BcpWeblogNew.exe`) can't read the new servers' logs. They're named `u_ex*.log`, so it
     skips them, reports no error, and loads 0 rows. It also reads fields by position, while the servers log
     different field lists.
  2. **The account the loader runs as (`sdss\mssql`) can read idieswww01's log folder but gets "Access is
     denied" on idieswww02 and idieswww03.** That's probably why only idieswww01 was ever set up in `LogSource`.

## Needed now

1. **Read access (web server owner).** Read on `\\idieswww01`, `02` and `03` `\LogFiles\W3SVC2` for the loader's account.
   Today 01 allows `BUILTIN\Users` and `SDSS\victor`, while 02/03 allow only Administrators and SYSTEM. Suggest a
   dedicated service account or group, used through a SQL Agent proxy for the weblog step only.
2. **Approve the replacement loader (boss / job owner).** A Python rewrite is built and tested on sdss4c:
   - same rows as the old exe on an old-format log;
   - row counts equal to the raw lines on all three new servers;
   - kills and forced failures leave no gaps and no duplicates;
   - an hourly Agent job is running there now.

   It reads only the new lines each hour instead of re-reading every file. To deploy it:
   - is Python OK on lumberjack?
   - replace step 1 (`xp_cmdshell` running the exe) with a CmdExec step;
   - create its tables and procedures in `weblog`.
3. **Decisions before cut-over (weblog owner):**
   - **Sources:** add idieswww01-03 `W3SVC2`, and decide what happens to dsa001/003/005. Also deactivate one logID in each
     duplicate pair: 3 web pairs make about 15% of `hits` duplicates, and 2 SQL pairs double the DR17/DR18 query counts.
     8 active sources point at folders that no longer exist.
   - **Health checks:** drop them at load time? Real traffic would be about 10-15 M rows/day against about 1.5 M now,
     so the size problem behind the Oct-2025 table swap would come back quickly.
   - **History:** how far back to load, given the gaps in the log files, and whether to recompute or annotate
     `trafficBase`.
   - **`bytesIn`:** fix it? Today it's always a copy of `bytesOut`.

## Also worth raising

- **SQL Server Agent on lumberjack runs as `sdss\victor`.** If that account's password changes or it's disabled, Agent
  won't start at its next restart, and every Agent job on lumberjack stops. Moving it to a service account would
  remove that dependency.
- **IIS logging differs between servers (web admins; not blocking):** idieswww01 rolls over monthly (25 GB this
  month) and doesn't log `sc-bytes`/`cs-bytes`, while 02 and 03 roll over daily and do log them. idieswww01 also
  wrote no SkyServer log from 10-23 to 10-28.
