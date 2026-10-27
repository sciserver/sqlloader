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
