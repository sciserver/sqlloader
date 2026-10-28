# bcpweblog: specification for the Python rewrite of `BcpWeblogNew.exe`

Status: **DRAFT for review**, 2026-10-28. Nothing here is deployed. Decisions marked **(proposal)** need an
OK; the ones that belong to the weblog / `LogSource` owner are collected in [Open questions](#7-open-questions).

Background: `schema/log/lumberjack_2026/weblog_collection_findings_20261027.md` and
`bcpweblog_rewrite_handoff.md` on the `dr20` branch.

## 1. Why a rewrite

Step 1 of the lumberjack job "Hourly Weblog Update2" (`spCopyWebLogs` -> `BcpWeblogNew.exe`) has three problems:

1. **It can't read the current web servers.** The real SkyServer traffic is IIS site `W3SVC2` on idieswww01-03.
   The exe matches only `^ex.*\.log$` (the new files are `u_ex*`), and it maps columns by fixed position, which
   doesn't fit their field lists (section 3.3).
2. **It's slow.** Every hour it opens every matching file in every source folder, and for each file that
   qualifies it copies the **whole file** to local disk and reloads it from line 1. That would not work for
   idieswww01's monthly log (23.5 GB on 2026-10-28) or idieswww02's 1.3 GB/day.
3. **Known defects:** `bytesIn` is never loaded (section 2.6), every bcp file starts with a BOM, and failures are silent
   (section 2.7).

## 2. Current behaviour (what is being replaced)

Sources: the 2009 C# (`H:\bcpweblog_reference\from_boss\bcpWeblog\bcpWeblog.cs`), checked against the
disassembly of the deployed 2017 exe (`H:\bcpweblog_reference\bcpWeblogNew.il`), and the deployed proc
(`H:\bcpweblog_reference\spCopyWeblogs.sql`). The 2017 source is lost; every 2017 difference below was read
from the IL.

### 2.1 The hourly contract (`spCopyWebLogs`)

1. `TRUNCATE weblogTemp`.
2. `@date` = the date part of `min(tstamp)` over `LogSource` rows with `method='XCOPY' and isvisible=1 and
   status='ACTIVE'` (in practice: the start of the previous run, UTC).
3. `DELETE weblogAll` rows of those logIDs dated `>= @date`.
4. For each such source (cursor): `xp_cmdshell 'C:\ClusterStorage\Volume1\WebLogImport\BcpWeblogNew.exe
   <pathname> C:\ClusterStorage\Volume1\WebLogImport <@date>'`, then `INSERT weblogAll ... SELECT FROM
   weblogTemp` adding: `hh/mi/ss` from `Second`, `theTime`, `@logID`, `command` with anything after
   `password=` cut off, `isVisible = 0` for `/collab%` URLs, else 1. `weblogTemp.Seq` is dropped (`weblogAll.seq`
   is an identity). Then `TRUNCATE weblogTemp` and `UPDATE LogSource SET tstamp = GETUTCDATE()`.

So each run **deletes and reloads everything from the start of the current UTC day** (and the previous one
just after midnight). That only works because the exe rereads whole files. **An incremental loader can't run
under this DELETE**; see section 4.6.

### 2.2 Arguments (2017)

`BcpWeblogNew.exe <dataTree> <tempDir> <minAge> [-SuppressBcp]`. Fewer than 3 args, or a missing `dataTree`,
prints usage and exits 1. `-SuppressBcp` lists the matching files and does nothing else.

### 2.3 File selection

- `ScanFolder` matches file names with `^ex.*\.log$` (case-insensitive) and **recurses into every
  subfolder**.
- For each match, `MakeLoadFile` opens the file and reads 5 lines. Fewer than 5 lines, or a 5th line not
  starting with `20`, means "not a good log file, skipping it". So the header must be exactly 4 lines
  (`#Software`, `#Version`, `#Date`, `#Fields`).
- **Date rule (2017):** `stamp = (first 19 chars of line 5 as a datetime) + 1 day`, formatted `yyyy-MM-dd`.
  The file is skipped if `stamp < minAge` (ordinal string compare).
  - Why: daily files start with a few lines from just before midnight (e.g. idieswww02's `u_ex261028_x.log`
    starts `2026-10-27 23:59:48`), so the first line plus a day is the file's date. The 2009 rule used the
    `#Date:` header, which isn't reliable: dsa001's `ex261028_x.log` says `#Date: 2026-06-02 21:25:54`.
  - **Side effect:** `stamp` is also the date written on **every row** of the file (section 2.5). The
    pre-midnight lines get the next day's date: 2026-10-28 has 20 rows for logID 4 at hour 23, loaded at
    16:58 UTC on the 28th. If a file ever started after midnight, the whole file would be dated a day late.
    For a monthly file, every row would get the 1st of the month.

### 2.4 Reading

The whole file is copied to `<tempDir>\weblog.txt` (`CopyTo`, overwrite) and read from the start. Per line:

- Skipped: lines starting with `#`, 20 chars or shorter, or 8000 chars or longer (the last get a "Line too long"
  message).
- A `#Fields` line sets the format: `new` if it contains `sc-bytes`, else `old`. Nothing else in the field
  list is used.
- `remap()` splits on spaces and takes fields **by position**: 16 fields for `new`, 11 for `old`. Lines with fewer
  fields return `""`.

`new` assumes exactly: `date time s-sitename s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip
cs(User-Agent) cs(Referer) sc-status sc-bytes cs-bytes time-taken`. That is dsa001's list (plus a trailing
`XForwardedFor`, ignored).

### 2.5 Output row (`<tempDir>\bcp.tmp`, tab-separated, UTF-8 **with BOM**)

| # | weblogTemp column | value |
|---|---|---|
| 1-3 | `YY`, `MM`, `DD` | `stamp` (section 2.3), the same for every row of the file |
| 4 | `Seq` | 0-based row counter within the file |
| 5 | `Second` | `time` (hh:mm:ss) |
| 6 | `clientIP` | `c-ip` |
| 7 | `op` | `cs-method` |
| 8 | `command` | `cs-uri-stem` + `?` + `cs-uri-query` unless the query is 3 digits; cut to 255 chars, but only when the query was appended |
| 9 | `error` | `sc-status` |
| 10 | `browser` | `cs(User-Agent)` |
| 11 | `referer` | `cs(Referer)` (`old`: `-`) |
| 12 | `bytesOut` | `sc-bytes` (`old`: `0`) |
| 13 | `bytesIn` | **`sc-bytes` again** (bug; `old`: `0`) |
| 14 | `elapsed` | `time-taken` (`old`: `0`) |

Then `bcp weblog.dbo.weblogTemp in <tempDir>\bcp.tmp -S localhost -T -c -e <tempDir>\rejectedBcpRecords.txt`,
one bcp per file.

### 2.6 Known defects and quirks (all confirmed)

| Quirk | Evidence | v1 |
|---|---|---|
| `bytesIn` = `bytesOut` on every row | `remap` appends `bytesOut` twice (2009 lines 215-216, IL_0327/IL_0335); 0 of 1.55 M rows differ on 2026-10-26 | **fix** (pending OK, open question 1) |
| BOM on the bcp file | `new StreamWriter(..., Encoding.UTF8)`; row 1 of each file goes to the rejects file | **fix** |
| `?-` on URLs | IIS writes `-` for an empty query and it's appended; 98.5% of logID 2009 rows on 2026-10-27 end in `?-` | **fix** (proposal): append `?query` only when the query isn't `-` |
| Date on every row from the first line + 1 day | section 2.3 | **fix**: each line's own `date` |
| Short lines still written | `remap` returns `""` and `"".IndexOf("\t")` is -1, so a 5-field row is written; bcp then rejects it or misaligns it | **fix**: count and skip (section 4.5) |
| Header must be exactly 4 lines | section 2.3 | **fix**: header lines can appear anywhere |
| Recurses into subfolders | `ScanFolder` | **drop**: none of the 33 active source folders has a subfolder (checked 2026-10-28) |
| A missing folder is silent | `Directory.Exists` fails, so it prints usage and exits 1, which nobody sees. **8 of the 33 active folders don't exist** (2026-10-28) | **fix**: reported in the run summary as a warning (not a failure, or the step would fail every hour until `LogSource` is cleaned up) |
| Failures are silent | `Main` returns void (exit 0); a bcp failure is only printed; the proc ignores `xp_cmdshell`'s result | **fix**: non-zero exit, step fails, the existing alert fires |
| Fixed-position columns | section 2.4 | **fix**: map by `#Fields` name |

## 3. The input: IIS W3C logs as they are now

### 3.1 Folders and names (read 2026-10-28)

| Server / folder | Newest file | Rollover |
|---|---|---|
| `\\idieswww01\LogFiles\W3SVC2` | `u_ex2610_x.log`, 23.5 GB, written 2026-10-28 | **monthly** since 2025-11-10 16:54 (daily before) |
| `\\idieswww02\LogFiles\W3SVC2` | `u_ex261028_x.log` | daily, UTC midnight |
| `\\idieswww03\LogFiles\W3SVC2` | `u_ex261028_x.log` | daily, UTC midnight |
| `\\dsa001\LogFiles\W3SVC1858982642` (and dsa003/005) | `ex261028_x.log` | daily |

History on the servers (for backfill): W3SVC2 logs start 2025-04-17 (02/03) and 2025-04-30 (01), with **no files**
from 2025-07-10 (01: 04-30) to 2025-08-26. `XForwardedFor` (the `_x` names) was added on all three on 2025-11-04 at ~19:00.
idieswww01 has had no byte fields in every file checked.

File name pattern: `^(u_)?ex(\d{6}|\d{4})(_x)?\.log$`, case-insensitive. The digits are `yymmdd` (daily) or `yymm`
(monthly); `_x` means the log has custom fields.

### 3.2 Header

```
#Software: Microsoft Internet Information Services 10.0
#Version: 1.0
#Date: 2026-10-28 00:00:20
#Fields: date time s-ip cs-method ...
```

IIS can write a new header block in the middle of a file (e.g. after a restart or a config change), and the field list can change there.

### 3.3 Field lists

| Field | dsa001 | idieswww01 W3SVC2 | idieswww02/03 W3SVC2 |
|---|---|---|---|
| `s-sitename` | yes | - | - |
| `sc-substatus`, `sc-win32-status` | - | yes | yes |
| `sc-bytes`, `cs-bytes` | yes | **-** | yes |
| `XForwardedFor` (custom) | yes | yes | yes |

All have `date time s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs(User-Agent)
cs(Referer) sc-status time-taken`. Values contain no spaces (IIS writes `+` for spaces in the user agent) and `-`
for empty.

### 3.4 Reading a file IIS has open

A directory listing shows **stale size and time** for the file IIS is writing: idieswww02's current file listed as
0 MB while it had data. So file selection can't trust the listing for the newest file; the loader reads the real size
from an open handle (`os.stat` on the path does this on Windows; `os.scandir()` entries don't). The last line may be
half-written; only complete lines (ending in `\n`) are consumed.

## 4. v1 design

### 4.1 Shape

- One Python script, `bcpweblog.py`, **standard library only**. It runs `bcp.exe` and `sqlcmd.exe` (both already on
  lumberjack) through `subprocess`. No pyodbc.
- Runtime: the embeddable Python zip on the cluster volume (`C:\ClusterStorage\Volume1\WebLogImport\python\`), so it moves
  with the clustered instance. **Check first:** is Python allowed on lumberjack?
- Two modes, one engine:
  - `incremental` (hourly): for each source, read new complete lines since the stored offset.
  - `backfill --from yyyy-mm-dd --to yyyy-mm-dd` (one-off): load closed days from offset 0, deleting those
    days for those sources first, so it can be rerun.
- `--dry-run`: read and parse, write the bcp file and a summary, load nothing.

### 4.2 Sources (proposal)

The loader reads its source list from `LogSource` with a **new `method` value** (e.g. `'TAIL'`, name to be agreed).
`spCopyWebLogs` only touches `method = 'XCOPY'`, so the old and new loaders can run side by side during the change-over, and
moving a source is a one-row `UPDATE`. Which sources to add is the `LogSource` owner's call (findings doc questions 5-8).

### 4.3 State: per-file offsets in the database (proposal)

New table `weblog.dbo.LogFileState` (DDL in `bcpweblog_schema.sql`):

| column | type | meaning |
|---|---|---|
| `logID` | int | `LogSource.logID` |
| `fileName` | varchar(260) | name within the source folder |
| `byteOffset` | bigint | bytes consumed (always at a line boundary) |
| `fields` | varchar(2000) | the `#Fields` list in effect at `byteOffset` |
| `fileDate` | date | from the name: `yymmdd`, or the 1st for `yymm` |
| `updated` | datetime2(0) | UTC |
| `runID` | int | the `LoadRun` that last moved it |

Primary key `(logID, fileName)`. The offsets are moved **in the same transaction as the rows** (section 4.6), so a failed run
leaves both unchanged and the next run repeats it: no gaps, no duplicates. A file whose real size is now smaller than its
offset was replaced: it's logged as a warning and read again from 0.

Each run also gets a row in `LoadRun` (`runID`, mode, host, started/finished UTC, status `started | loaded | failed |
abandoned`, files/rows loaded, rows deleted, error message). That's the run log, and it's what a daily check should read
("did rows arrive?") instead of `LogSource.tstamp`, which moves even when nothing was loaded.

Alternative: a JSON state file on the cluster volume. Simpler, but it can't be committed together with the rows.

### 4.4 Which files are read

Per source: list the folder (no recursion), keep names that match section 3.1, and read a file if any of these is true:

- it has no state row and the dates its name covers overlap the window (incremental: the last 2 days; backfill:
  `--from`/`--to`). A daily name covers that day; a **monthly** name (`yymm`) covers the whole month, so the current
  month's file is always picked up;
- its real size is greater than its stored offset.

Files whose name date is older than the window are **never opened**. Today's exe opens every file in every folder every
hour, so that's the main time saving.

### 4.5 Parsing

- `#Fields:` sets the field list (by name) until the next `#Fields:`. Other `#` lines are ignored.
- A data line whose field count doesn't match the field list is **rejected**: counted, and written (path, offset, first 500
  chars) to a rejects file. Lines of 8000+ chars likewise.
- The date comes from each line's own `date` field.

Column mapping (`weblogTemp` order, plus `logID`, see section 4.6):

| column | from | when missing |
|---|---|---|
| `YY`/`MM`/`DD` | `date` | (reject the line) |
| `Seq` | per-file line number | |
| `Second` | `time` | (reject the line) |
| `clientIP` | first entry of `XForwardedFor`, with any `:port` removed; else `c-ip` | `0.0.0.0` |
| `op` | `cs-method`, max 8 chars | `''` |
| `command` | `cs-uri-stem`, plus `?` + `cs-uri-query` if the query isn't `-`; max 255 chars (open question 4) | `''` |
| `error` | `sc-status` | 0 |
| `browser` | `cs(User-Agent)`, max 2000 | `''` |
| `referer` | `cs(Referer)`, max 500 | `' '` |
| `bytesOut` | `sc-bytes` | 0 |
| `bytesIn` | `cs-bytes` | 0 |
| `elapsed` | `time-taken` | 0 |

Missing values are written as empty fields; `bcp` without `-k` loads the column default. Any tab, CR or LF in a value is
replaced by a space. The load file is UTF-8 **without** a BOM, loaded with `-C 65001`.

On c-ip: on the idieswww servers `c-ip` is always the load balancer, so the client is in `XForwardedFor`. Checked on 20,000
lines of idieswww02 (2026-10-27): the value is `-` (4%), `client` (69%), `client:port` (4%), or `client,+proxy:port`
(24%; `+` is IIS's encoding of the space after the comma). The second entry is an upstream proxy, so **take the first
entry, remove `:port`** (IPv4 only; an IPv6 value is kept as it is). This matches the usual meaning of the header (left-most =
original client).

### 4.6 Loading (proposal)

Built and tested on sdss4c `bcpweblog_test` (2026-10-28): `bcpweblog_schema.sql` (the objects to deploy to `weblog`) and
`bcpweblog_test_setup.sql` (sdss4c only: the database, copies of `weblogAll`/`LogSource`, test sources).

1. `EXEC spStartWeblogRun @mode` returns a new `runID`. It also marks `started` runs older than 12 h `abandoned` and deletes
   their staged rows (a run killed between bcp and step 3).
2. The loader writes one bcp file per run (all sources; each row starts with `runID`, `logID`) and a small offsets file
   (only files whose offset moved), and `bcp`s them into `weblogStage` (`runID`, `logID` + `weblogTemp`'s columns) and
   `LogFileStateStage`. bcp options: `-c -C 65001 -t \t -r 0x0a`, no `-k`, so empty fields load the column default.
3. `EXEC spLoadWeblogStage @runID` does in **one transaction**: insert the run's rows into `weblogAll` (with the same `theTime`,
   `password=` and `isVisible` rules as `spCopyWebLogs`; `TABLOCK` as before), upsert `LogFileState`, update `LogSource.tstamp`,
   delete the run's staged rows, mark the run `loaded`. On any error it rolls back, deletes the run's staged rows, marks the
   run `failed` with the message, and re-raises (`sqlcmd -b` exits non-zero).
4. Any non-zero exit from bcp or sqlcmd stops the run with a non-zero exit code, and nothing is committed.

**Why `runID`:** the staging tables are shared. Tagging rows by run means a backfill and the hourly run can stage at the same
time without loading each other's rows, and leftovers from a killed run are never picked up by the next one.

**Backfill:** `spLoadWeblogStage @runID, @replaceFrom, @replaceTo` first checks that every staged row is dated inside the
range (otherwise it fails before deleting anything), then deletes those days for the run's logIDs, one day and logID at a time
(a seek on the `yy/mm/dd` key prefix), in batches of 100,000, **outside** the transaction to keep the log small, then loads as
above. A failure after the delete leaves the days empty, and rerunning the same backfill repairs that (tested: two identical
runs give the same rows). Because daily files start with a few seconds of the previous day, the loader must read the files
around the range and stage only rows dated inside it.

**One bad row fails the whole run**, and the next run rereads the same bytes and fails again. So the parser must reject
anything the database can't convert. `convert()` checks the date and time are real values, not just the right shape
(`2026-02-30` and `10:61:99` are rejected; tested by sending `10:61:99` through the proc, which failed the run as expected).

Volume: the idieswww servers could add 10-15 M rows/day to `weblogAll` (unless health checks are dropped, open question 2).
That affects table size and steps 3/6.

### 4.7 Invocation

Proposal: a new job step (CmdExec, `python.exe bcpweblog.py incremental`) instead of `xp_cmdshell` from a proc, so the exit
code fails the step and the existing "Weblog Job failure alert" fires. `bcp`/`sqlcmd` connect with `-S localhost -E` as the
Agent account, as bcp does today.

### 4.8 Run summary

One line per source to stdout (the job history) and appended to a log file:
`logID, folder, files listed, files matched, files read, bytes read, lines, rows, rejects, seconds`.
"Listed vs matched" catches a source whose file names stop matching (what happened with `u_ex*`).

## 5. Validation plan

1. **Old-format parity.** Dry run on one dsa001 source for a closed day; compare with `weblogAll` for that logID and day.
   Expected differences only: the pre-midnight rows' date, no `?-`, `bytesIn`, and the row 1 BOM reject.
   **Done 2026-10-28** (logID 4, `ex261027_x.log`, compared with `weblogAll` dd=27): 78,128 rows new vs 78,127 old. The extra
   row is line 1 (the BOM reject). With `?-` removed, `-` read as empty, and the proc's `password=` cut applied, **every
   row matches** on time, method, URL, status, user agent, referer, bytesOut and elapsed. Old `bytesIn` = `bytesOut` on
   100% of rows. `clientIP` differs as intended: the old rows have a literal `-` (76,299 health-check rows, empty `c-ip`),
   and the new rows have the internal address from `XForwardedFor`; the 1,392 public-address rows are identical.
2. **New-format first look.** Done 2026-10-28 on idieswww02 `u_ex261027_x.log` (1.29 GB): 4,213,324 rows, 0 rejects,
   57 s (22 MB/s over SMB); 93 pre-midnight rows dated 10-26. No dominant probe URL on `W3SVC2`; 44% of requests have no
   user agent, ~9% are a headless browser (`Lightpanda`), ~2% self-declared crawlers.
3. **New-format counts.** For idieswww02/03 and 01, compare rows per file and hour with an independent line count of the raw
   files.
4. **Incremental = backfill.** Run hourly into a scratch database for 2 days; backfill the same days into another; the
   row sets must match exactly. This is the test that proves the offsets.
5. **Failure and restart.** Kill a run partway, and fail bcp on purpose: the next run must leave no gap and no duplicate.
6. **Time.** Step 1 time before and after, on the same sources.

## 6. Out of scope for v1

- Changing `spCopySqlLogs`, the CasJobs step, or `spUpdateTrafficStats` (beyond reading the new rows).
- Recomputing `trafficBase` history (findings doc question 6).
- Dropping health-check rows, unless the owner says so (open question 2); the parser can take a filter list later.

## 7. Questions

### Decided (2026-10-28)

- **`command` length:** keep the 255-char cut in v1, as today. Raising it later is one constant; worth asking the boss,
  since SkyServer SQL queries arrive in the URL and the cut loses most of them.
- **Test server:** sdss4c (SQL Server 2022, same collation as lumberjack's `weblog`, `bcp` and Python 3.14 installed,
  reads the log shares). Use a **new** database, `bcpweblog_test`; sdss4c already has `weblog`, `dev_weblog`,
  `weblog_old` and `Weblog_Rescue` from earlier work, which are left alone.
- **Python on lumberjack:** probably fine (no known policy against it). Still to confirm on lumberjack itself; the
  embeddable zip should be the same minor version as the one tested on sdss4c.
- **Invocation:** a CmdExec job step (section 4.7). The job change is made by whoever owns the job.
- **Subfolders:** not needed (section 2.6).
- **`XForwardedFor`:** first entry, port removed (section 4.5).

### Open (for the boss / the weblog owner)

1. Fix `bytesIn`? (Recommended. It changes the meaning of the column for new rows only.)
2. Drop load-balancer health checks at load time (findings doc question 7)?
3. Which sources, and the new `method` value (findings doc questions 5-8)? Also: 8 of the 33 active `XCOPY` folders
   don't exist any more.
