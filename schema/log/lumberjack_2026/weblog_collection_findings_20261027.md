# Weblog collection: findings, 2026-10-27

These came up while looking into why step 1 of the lumberjack SQL Agent job "Hourly Weblog Update2"
takes ~12 minutes (the follow-up to the blocking work in `lumberjack_steps1_2_findings.md`). They are
about what the weblog collects, not about the job's performance.

Everything was checked with read-only queries on lumberjack (`weblog` database, `NOLOCK`) and directory
listings / log headers of the web servers' `LogFiles` shares. **Nothing has been changed.**

## Summary

1. **Web page traffic is collected from the old web servers (dsa001/003/005), not the current
   ones (idieswww01-03).** About 98% of what the old servers log is health-check requests. The real
   SkyServer traffic is on the idieswww servers, and the weblog collects none of it.
2. **DR20 query traffic *is* collected correctly**, through a separate path (the SQL Servers' own query
   logs). So the query numbers look fine, and they've masked problem 1.
3. Smaller issues: duplicate log sources (web and SQL), no rows from SDSS5B, and a `bytesIn` column
   that has never been loaded correctly.

Consequence: since at least 2025-10-21, the web-traffic numbers in `weblogAll` and `trafficBase` (`hits`,
the language columns, `SkyServer`) mostly count health checks. `trafficBase` keeps history back to 2001, so
those numbers stay in it unless recomputed.

## Background: two collection paths

| | Page traffic | Query traffic |
|---|---|---|
| Table | `weblogAll` | `SqlLogAll` |
| Source | IIS log files on the web servers (`LogSource.method = 'XCOPY'`) | Each SQL Server's own `weblog` DB (`method = 'TSQL'`) |
| Job step | 1 (`spCopyWebLogs` -> `BcpWeblogNew.exe`) | 2 (`spCopySqlLogs`) |
| Feeds `trafficBase` | `hits`, language columns, `SkyServer`, `SkyService` | `SQL` |
| State | **Pointed at the old servers** | Current (SDSS5A, 4J, 4K, ...) |

## 1. Page traffic comes from the old web servers

**What `LogSource` collects.** All 36 active `XCOPY` sources point at `\\dsa001`, `\\dsa003` and `\\dsa005`.
idieswww01 has 16 entries, all `INACTIVE`, 12 of them last collected **2025-10-21 16:00** (also the
first day `weblogAll` holds). idieswww02 and idieswww03 have no entries at all.

**What the old servers log.** On dsa001 (logID 4), 2026-10-26: 98.3% of rows are `GET /` -> 200 with no
client IP and no user agent, a flat ~3,100 per hour around the clock (a health-check pattern), plus
Zabbix. Only a few hundred rows a day look like real visitors. Only 105 `weblogAll` rows that day mention
`dr20`.

**What the new servers log** (`\\idieswww0N\LogFiles`, reachable from lumberjack):

| IIS folder | Content | Size |
|---|---|---|
| `W3SVC2` on 01, 02, 03 | **SkyServer** (`/DR20/SkyserverWS/...`, `/dr17/VisualTools/...`, real browsers) | idieswww02: **1.29 GB** for 2026-10-26 |
| `W3SVC1` on 01, 02, 03 | `GET /` -> 302 from the load balancer (health check) | ~1.4 MB/day |
| `W3SVC3` on 01, `W3SVC4` on 02/03 | `GET /dr12/imgcutout/imgcutout.asmx` -> **500**, about every second | ~2 MB/day |
| other `W3SVC*` | not written since 2025 | |

**Why the current loader can't simply be pointed at them.** `BcpWeblogNew.exe` would load nothing, or
load it wrong:

- New log files are named `u_ex*.log`; the exe only matches `^ex.*\.log$`, so it would skip all of them
  without an error.
- The exe reads columns by fixed position. The new logs have custom fields (`XForwardedFor`, hence
  the `_x` file names) and **different field lists on different servers**: idieswww01's `W3SVC2` has no
  `sc-bytes` / `cs-bytes`, while idieswww02's does.
- `c-ip` is always the load balancer (172.23.10.x). The real client address is the first entry of
  `XForwardedFor`.
- idieswww01's `W3SVC2` log rolls over **monthly** (`u_ex2610_x.log` is 17.7 GB). The exe re-reads every
  file in full every hour.

Volume: around 5 million lines per server per day, so perhaps 10-15 million rows/day in total,
compared with ~1.5 million (mostly health checks) now. That matters for `weblogAll` size and for the
aggregation steps.

## 2. Duplicate log sources

Some `LogSource` entries point at the same source, so the same log is loaded twice under two logIDs.
The copies are row-for-row identical.

| Source | logIDs | Effect |
|---|---|---|
| `\\dsa001\LogFiles\W3SVC1858982642\` | 4, 15 | ~75k duplicate rows/day in `weblogAll` |
| `\\dsa003\LogFiles\W3SVC1858982642\` | 16, 23 | ~79k |
| `\\dsa005\LogFiles\W3SVC1858982642\` | 14, 17 | ~79k |
| `SDSS4J.weblog` | 2179, 2181 | DR17 query counts doubled in `SqlLogAll` |
| `SDSS4K.weblog` | 2180, 2182 | DR18 query counts doubled |

The SDSS4J/4K pairs are **not** the CasJobs quick and long queues: `spCopySqlLogs` copies all of
`<pathname>.dbo.sqlLogUtc` for each source (no per-source filter), both logIDs have identical counts for
every `access` type, and `EXCEPT` both ways is 0 / 0. The rows are SkyServer / SkyserverWS queries; CasJobs
is collected separately (logID 2061, `batch.jobs`). SDSS4J also has only a quick queue in `batch.servers`.

`trafficBase.hits` is `count(*)` over `weblogAll` and `trafficBase.SQL` is `count(*)` over `SqlLogAll`, with
no split by logID, so both include the duplicates. On 2026-10-26, 233,151 of 1,550,570 `hits` (15%) were
duplicates. Every month checked back to 2025-11-01 shows the same pattern.

## 3. No query log rows from SDSS5B

`SDSS5B.weblog` (logID 2184) is `ACTIVE` and its timestamp is current, but `SqlLogAll` has 0 rows from it
for 2026-10-26 (SDSS5A: 2,841). Either 5B gets no query traffic by design, or its query logging isn't
working.

**Checked in sql-monitor (2026-10-27):** 5B gets no query traffic, so the logging is accurate. Over 48 h,
sdss5b ran a flat ~0.4 batch requests/sec (background: monitoring and Agent), against 4-95/sec on sdss5a
following the day's pattern (peak 310). 5B's only connections were SSMS sessions, with no
SkyServer/web-service connections and no cached query stats in 24 h. So the question is whether all query
traffic going to 5A is intended (5B as standby) or a connection-string / load-balancing gap.

**CasJobs routing (`batchadmin.batch.servers` on MYDBSQL):** sdss5b is the host for only 2 of 426 contexts,
both long queue (500): `DR20Collab_long` and `DR19_long`. Every quick queue and `DR20_long`,
`DR19collab_long` and `minidb_dr19_long` go to sdss5a. Long jobs in those two contexts are rare, which fits
5B being nearly idle. SkyServer's own pages and web services don't go through `batch.servers`; they use
their own connection strings, which evidently point at 5A.

## 4. `bytesIn` has never been loaded correctly

`BcpWeblogNew.exe` writes `bytesOut` (`sc-bytes`) into both `bytesOut` and `bytesIn`. This is visible in the
2009 source and in the deployed binary. `bytesIn` therefore always equals `bytesOut` (all 1.55 M rows on
2026-10-26). Low impact: `trafficBase` uses neither column.

## Questions

**Web servers / IIS (web admins):**
1. idieswww01's SkyServer log (`W3SVC2`) was last written **2026-10-23 09:53**. Is 01 out of the load balancer,
   or has its logging stopped?
2. Can IIS logging on the three servers be made the same: daily rollover, and the same fields
   (including `sc-bytes`, `cs-bytes`, `XForwardedFor`)?
3. The `imgcutout.asmx` probe gets HTTP 500 about once a second. Is that a health check on a broken endpoint?
4. Are dsa001/003/005 still meant to be in service?

**Weblog configuration (owner of `LogSource` / the weblog):**
5. What happened on 2025-10-21, when the idieswww01 entries were set `INACTIVE`?
6. Should `trafficBase` history be recomputed or annotated? `weblogAll` only goes back to 2025-10-21, so earlier
   web numbers can't be corrected from row data.
7. Duplicates: which logID in each pair stays active?
8. SDSS5B is up but receives almost no query traffic (sql-monitor). In CasJobs it only takes the
   `DR20Collab_long` and `DR19_long` queues. Is that split intended (and should `DR20_long`, the busiest long
   queue, be on 5B?), and should SkyServer / the web services send any queries to 5B?

**bcpWeblog rewrite** (in progress; see `bcpweblog_rewrite_handoff.md`):
9. The rewrite will handle `u_ex*` names, parse `#Fields` by name, take the client IP from `XForwardedFor`,
   and read only the lines added since the last run. Should it also write `bytesIn` correctly
   (recommended), and are the larger volumes OK for `weblogAll` and the aggregation steps?

## How to check

- `verify_duplicate_logsources.sql` (same folder): read-only, about 40 s. Shares of sources per folder,
  row-level comparison of each pair, the `trafficBase` effect, and history back through `weblogAll`.
- On lumberjack, PowerShell (runs as whoever runs it, not as the SQL service account):

```powershell
# Reachable shares and their IIS folders
foreach ($h in 'idieswww01','idieswww02','idieswww03') { $p = "\\$h\LogFiles"; "{0}: {1}" -f $p, (Test-Path $p); if (Test-Path $p) { Get-ChildItem $p -Directory | Select-Object -ExpandProperty Name } }

# Per folder: file count and newest log
foreach ($h in 'idieswww01','idieswww02','idieswww03') { Get-ChildItem "\\$h\LogFiles" -Directory | ForEach-Object { $f = @(Get-ChildItem $_.FullName -File -Filter *.log); $n = $f | Sort-Object LastWriteTime -Descending | Select-Object -First 1; "{0}\{1}: {2} files, newest {3} {4:yyyy-MM-dd HH:mm} {5:N0} KB" -f $h, $_.Name, $f.Count, $n.Name, $n.LastWriteTime, ($n.Length/1KB) } }
```
