# Handoff: schema/log cleanup and the bcpWeblog Python rewrite

Written 2026-10-27 at the end of the lumberjack weblog-job session. Updated the same day after
checking the branch state. Read this first in the next session, then `lumberjack_steps1_2_findings.md` (step 1 section) for the details behind it.

## Where things stand

- **Owner of the rewrite:** suzanne (agreed 2026-10-27; the boss asked whether a rewrite could
  replace moving the old IIS logs).
- Steps 2 and 6 of "Hourly Weblog Update2" are fixed (RECOMPILE, deployed 2026-10-16, holding).
  Step 1 (`spCopyWebLogs` -> `BcpWeblogNew.exe`) is now ~95% of the job, ~720 s per run.
- About 570 s of step 1 is (very probably) the exe opening **every** `ex*.log` in 12 live folders
  (~23k SMB opens per hour, ~25 ms each) only to read the date from 5 lines. Not yet proven by a
  direct timing.
- Separate open item: step 1 got ~140 s slower in **one step between 10-23 and 10-24** (daily
  minimum 585 -> ~720 s). Not file growth and not row volume. Cause not found. Look at the web
  servers, SMB and the CSV volume around 10-23/24 before blaming the rewrite's baseline on it.

## Plan agreed so far (order matters)

0. **Deal with the 33 uncommitted files in `C:\sqlloader` first** (see below). This one needs the boss.
1. **Clean up `schema/log`** (on dr20).
2. **Merge dr20 into master**, as a PR so the boss sees it. This is the never-done DR20 release
   step, not only a weblog thing.
3. **New branch off master** for the rewrite. No code before steps 0-3.
4. Write the **spec** from the disassembly, then `bcpweblog.py`, then the comparison and validation.

### 0. Uncommitted work in `C:\sqlloader` (checked 2026-10-27, read-only)

**Status 2026-10-27:** the boss has been asked to commit them or confirm they're obsolete. They're
the boss's (the user works only in the H: checkout). Waiting on the answer; step 2 is blocked
until then.

- `C:\sqlloader` is the shared checkout (the user and the boss), on **master** at `8d328b9`, with
  **33 modified, uncommitted files**: `schema/sql/ApogeeTables.sql`, `AstraTables.sql`,
  `IndexMap.sql`, `MastarTables.sql`, `SpectroTables.sql`, `schema/csv/load*.sql`,
  `schema/etc/loadMetadata.sql`, `setVersion.sql`, `loadadmin/loadsupport-sp.sql`,
  `admin/connection.js`, and more (`git -C C:\sqlloader status --short`).
- They're on no branch on GitHub, so this is the one place work can actually be lost.
- Not yet checked: how many of them already match what's on dr20 (the boss's July "DR20" commits
  `0a08ae7`, `cdbe5e6` and their merges). Compare with line endings normalised (C: is CRLF, the
  repo is LF; see memory `project-repo-scope`) before concluding anything differs.
- It also blocks step 2: once master moves on GitHub, a pull in `C:\sqlloader` refuses to
  overwrite those files. So the boss commits them (to dr20 or their own branch) or confirms they're
  obsolete **before** the merge. **Don't touch `C:\sqlloader` without the boss**; they may have
  files open in an editor.

### 1. Cleanup: DONE 2026-10-27

Layout chosen: the 11 legacy files stay at the top of `schema/log` (same paths as
`C:\sqlloader\schema\log`, so the merge moves nothing in the boss's tree); the 2026-10 docs and
scripts are in `schema/log/lumberjack_2026/`; the Python code will go in `schema/log/bcpweblog/`.
The table below is the inventory as it was before the move.

| Group | Files | Proposal |
|---|---|---|
| 2015 legacy (also in `C:\sqlloader\schema\log`) | `bcpCopy.js`, `bcpWeblog.cs`, `bcpWeblog.js`, `bcpWeblogIIS5.cs`, `bcpWeblogIIS6.js`, `createWeblog.bat`, `grantAccess.sql`, `journal.txt`, `weblogAllIndices.sql`, `webLogDBCreate.sql`, `webLogHarvesterCreate.sql` | Keep until the Python version is live (`bcpWeblog.cs` is the base the deployed exe was modified from). Possibly move the bcp* sources to a `legacy/` subfolder |
| Findings docs (2026-10) | `lumberjack_mydbsql_findings.md`, `lumberjack_steps1_2_findings.md`, this file | Keep. They're the record of what changed on prod |
| Deployed change scripts (2026-10) | `fix_steps2_6_recompile.sql`, `spCopyLocalCasJobsSqlLogs2.sql`, `switch_step5_to_v2.sql`, `verify_step5_v2.sql`, `cutover_checks.sql`, `mydbsql_scheduler_plan_guide.sql`, `mydbsql_batchadmin_rcsi.sql` | Keep (each has verify and rollback sections). RCSI is NOT deployed yet; the others are |


### 2. Merging dr20 into master: facts that matter

- Nothing is lost: local dr20 == `origin/dr20` (pushed through `fe4e334`).
- `dr20` is **69 commits ahead of master and 0 behind** (65 the user's, 4 the boss's). Master's
  newest commit is "DR19 final state" (2025-12-16). The convention looks like **master = latest
  released DR**, and DR20 went live 2026-07-30, so the full dr20 -> master merge is the
  outstanding release step. It's a fast-forward unless master moves first.
  (An earlier draft of this note said "don't merge all of dr20". That was only about not pulling
  in all of DR20 just for the weblog files. Superseded.)
- The 2026-10 weblog/MYDBSQL work is **9 new files plus this handoff under `schema/log/lumberjack_2026`**
  (`git diff --stat origin/master...dr20 -- schema/log`). It comes along with the merge.
- Other remote branches exist (`DR14`, `DR18`, `DRx`, `develop-sue`, `release`, `xmatch`,
  `apogee_fire`). Leave them alone.
- **Repo scope caveat** (memory `project-repo-scope`): the repo is the source of truth only for
  `dr20/`; `schema/` normally lives at `C:\sqlloader` and the boss commits from there.
  `C:\sqlloader\schema\log` has only the 11 legacy files, none of the 2026-10 work. Agree with the
  boss where the weblog work and the new Python code live, so the two trees don't drift.

### 3. Rewrite: decisions already made

- **Python**, standard library only (`os.scandir`, string splitting, `subprocess` -> `bcp.exe`).
  No pyodbc in v1.
- **Runtime:** the embeddable Python zip in `C:\ClusterStorage\Volume1\WebLogImport\python\`
  (lumberjack is a failover cluster, so the cluster volume moves with the instance; no per-node
  install, no PATH). Check first: is Python already on lumberjack? Any policy against it?
- **Drop-in replacement in v1:** same command line
  (`<unc folder> <output dir> <yyyy-mm-dd>`), same `weblogTemp` load, so `spCopyWebLogs` doesn't
  change. Cut-over and rollback are both a one-line edit to the step 1 command.
- **v1 changes, decided deliberately and written in the spec:**
  - skip files by name or last-modified time before opening them (the main win);
  - no BOM (`bcp -c` rejects row 1 today);
  - the date comes from the file name or `#Date:`, not "first data line + 1 day".
- **Later (v2):** only load the lines added since the last run (recommendation #8); maybe
  SqlBulkCopy-style loading.

#### REVISED 2026-10-27: the premise changed (see `weblog_collection_findings_20261027.md`)

The decisions above assumed the job reads the right servers. It doesn't: all active XCOPY sources are
the old dsa servers (mostly health checks); the real SkyServer traffic is `W3SVC2` on idieswww01-03 and
isn't collected. The rewrite has to be able to read those logs, so for v1:

- **Match `u_ex*.log` too** (every idieswww log; the exe's `^ex.*\.log$` matches none).
- **Parse `#Fields:` and map columns by name**, re-reading it at every `#Fields` line. The field lists
  differ between servers (idieswww01 `W3SVC2` has no `sc-bytes`/`cs-bytes`; 02 has them) and include
  the custom field `XForwardedFor`. Missing fields load as the column default.
- **clientIP = first `XForwardedFor` entry** (strip any `:port`), falling back to `c-ip`, which is always the load balancer.
- **Incremental reading is v1, not v2:** keep a byte offset per file. idieswww01's `W3SVC2` rolls over
  monthly (17.7 GB file); idieswww02's daily file is 1.29 GB. Re-reading whole files hourly is out.
- **Write `bytesIn` correctly** (pending the boss's OK).
- **Not a drop-in for the current `LogSource` rows any more.** The source list changes (that's a
  `LogSource` decision for its owner), and volume goes from ~1.5 M to perhaps 10-15 M rows/day, which
  affects `weblogAll` size and steps 3/6. Keeping the same command line and `weblogTemp` load is still a
  good v1 shape.
- Validation changes too: there is no old output for the idieswww logs to compare against. Validate
  against the raw files (line counts per file/hour) instead of against the exe.

### 4. Spec inputs (outside the repo, durable)

- `H:\bcpweblog_reference\bcpWeblogNew.il` + `.res`: ildasm disassembly of the deployed exe.
  First step for the spec: decompile the exe to C# with ILSpy for readability. That's static
  only; **never execute the exe** (it's a copy treated as untrusted).
- `H:\bcpweblog_reference\spCopyWeblogs.sql`: the deployed step 1 proc (the call, and the
  `weblogTemp` -> `weblogAll` insert).
- `H:\bcpweblog_reference\spCopySqlLogs_orig.sql`, `spUpdateTrafficStats_orig.sql`: the pre-fix
  procs (rollback text is also in `fix_steps2_6_recompile.sql` section 4).
- `H:\bcpweblog_inspect\bcpWeblogNew.exe` (copy, 2017-08-14, 20 KB) and
  `rejectedBcpRecords.txt` (the BOM rejects).
- `schema/log/bcpWeblog.cs`: the 2015 source the deployed exe was modified from.
- `H:\bcpweblog_reference\from_boss\bcpWeblog\` (from the boss's Google Drive, 2026-10-27; original zip
  `H:\bcpWeblog-20261027T161114Z-1-001.zip`): the VS project, 2004-2009. Never execute its exes.
  Findings, checked against `bcpWeblogNew.il`:
  - **Lineage:** `Backup/bcpWeblog.cs` (2005) -> `bcpWeblog.cs` (2009-05-04) -> deployed exe (2017).
    The deployed exe has the 2009 code (`-SuppressBcp`, the same messages) plus the
    `<temp-directory>` arg, `"yyyy-MM-dd"` and the `"C:\Temp"` default, which the 2009 source lacks. **The 2017
    source is still missing** (asked the boss 10-27, not hopeful). Not a blocker: the 2017 changes are small and
    all visible in the IL. Same 6 methods and signatures; new field `tempDir`; `Main` args become
    `<data> <temp> <minAge> [-SuppressBcp]`; `MakeLoadFile` adds the +1 day rule (IL 389-397:
    `ToDateTime` -> `AddDays` -> `"yyyy-MM-dd"`); temp files go to `tempDir`. **Spec approach:** use the 2009 C#
    as the readable base and check each 2017 change against the IL.
    The repo's 2015 `schema/log/bcpWeblog.cs` is a separate branch (`-nobcp`).
  - **BOM cause:** 2009 changed `fo.CreateText()` to `new StreamWriter(fo.Create(), Encoding.UTF8)`;
    deployed IL 447-450 has the same call.
  - **bytesIn bug:** `remap()` appends `bytesOut` twice and never writes `bytesIn` (2009 source
    lines 215-216; deployed IL_0327/IL_0335 both `ldloc.s V_8`). So weblogAll's bytesIn = bytesOut for
    every row this exe loaded. The repo's 2015 source is correct. **v1 decision needed:** fix it
    (recommended; write it into the spec and the validation diff as an expected difference) or keep it. Ask
    the boss.
    **Confirmed in data 2026-10-27** (lumberjack `weblog`, 2026-10-26, read-only, NOLOCK): 1,550,569 rows in 15
    sources, `bytesIn <> bytesOut` = **0** everywhere; ~1.31 M are equal and non-zero. SKYSERVICE sources
    (1001/2011/2021) have bytesOut ~ 0 (no byte fields in those logs, so both columns are the default "0").
    (`spCopyWeblogs`'s `InsertFNALWeblog` call is commented out, so every weblogAll row comes from the exe.)

## Found 2026-10-27: duplicate LogSource rows (separate from the rewrite)

Three pairs of ACTIVE, visible `LogSource` rows point at the **same folder**, so each folder is scanned
and loaded twice every hour under two logIDs:

| Folder | logIDs | rows on 10-26 (each) |
|---|---|---|
| `\\dsa001\LogFiles\W3SVC1858982642\` | 4 (V15), 15 (V2) | 75,476 |
| `\\dsa003\LogFiles\W3SVC1858982642\` | 16 (V12), 23 (V10) | 78,904 |
| `\\dsa005\LogFiles\W3SVC1858982642\` | 14 (V8), 17 (V13) | 78,771 |

- About 233k duplicate weblogAll rows/day. `trafficBase.hits` = count(*) of weblogAll, so published hits
  are ~18% too high (2026-10-26), for at least the full year weblogAll keeps; `trafficBase` (back to 2001) keeps it.
- Step 1: 36 active XCOPY sources / 33 distinct folders (only 15 had rows on 10-26), so 3 of 36 scans are
  repeats; time cost not measured (depends on file count in those folders). An earlier "3 of 12, ~1/4" note was wrong.
- Write-up for the boss: `weblog_collection_findings_20261027.md`; checks: `verify_duplicate_logsources.sql`.
  Fix is a `LogSource` status change, but which logID to keep (and whether to recompute trafficBase) is the
  boss's call. Nothing changed yet.
- The `W3SVC1\\` rows (2009/2019/2029) are a different IIS site on the same servers, not duplicates.

What the spec must pin down: every argument; the folder recursion (`ScanFolder` recurses, so an
`old\` subfolder is still scanned); the MinAge/date rule; the IIS field -> `weblogTemp` column
mapping (`YY, MM, DD, Seq bigint, Second char(8), clientIP varchar(256), ...`); bad-line handling;
the 23:59 rollover lines; what the temp files are called and where they go (`weblog.txt`,
`bcp.tmp`); the exact bcp command line.

### Validation plan

1. Run with loading off for one live source and one day, and compare the new `bcp.tmp` with the
   exe's line by line. The only expected differences: no BOM, and row 1 no longer rejected.
2. Load a few days into a copy of `weblogTemp`, and compare row counts per logID and day with
   `weblogAll`.
3. Swap the step 1 command, then watch step 1's time and the row counts for a day.

## Environment traps (learned the hard way)

- `sqlcmd`: `-h`, `-W` and `-y` don't combine. Under Git Bash, pass Windows paths to `-i`
  (MSYS paths break). Read-only `sqlcmd -E` on lumberjack and MYDBSQL is OK'd.
- Listing `\\lumberjack\c$` from here hangs. The user runs file-share checks on lumberjack as
  PowerShell one-liners (they like to grab them with `/copy`).
- `xp_cmdshell` runs as the SQL service account (or proxy), not the user, so use absolute paths
  everywhere.
- msdb keeps only ~6 days of this job's history (24 runs/day x 7 steps hits the default cap).
- sql-monitor (PerformanceMonitor Lite MCP, `localhost:5151`) works only while the app is open on
  sdss4c. mydbsql was removed from it on 10-16 on purpose.
- No Co-Authored-By trailers in commits.
- `SqlLog`/`SqlLogAll`: always filter on `yy`/`mm`/`dd`. `theTime` alone scans 120 GB and
  shows up as turblog blocking (10-17).
