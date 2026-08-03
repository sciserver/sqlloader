# Session handoff — 2026-08-02

Written for the next session. **Read this first**, then
`dr20/session_summary_20260729.md` for the DR20 launch work.

---

## 1. Where things stand

**DR20 went live Thursday 2026-07-30.** sdss5a and sdss5b were signed off ready
for production and for a fresh backup on 2026-07-29, after both were taken
through the full 11-step replay in `dr20/post_backup_runbook.md`.

**Machine roles matter for what is safe to do where:**

| server | role | |
|---|---|---|
| **sdss4c** | loading machine | free rein — the user has said so explicitly |
| **sdss5a**, **sdss5b** | production | live since 2026-07-30 |

You are running **on sdss4c** — the user RDPs into it, so `localhost` is 4c and
their desktop session is there too. Everything can be driven remotely from here
with `sqlcmd -S <server>` under their Windows auth; they are sysadmin on all
three. Exceptions: `run_vac_load.py` and `run_htm_add.py` hardcode `localhost`
and read BESTTEST on the same instance, so they are sdss4c-only.

Transaction logs are at 2.50 GB on all three servers. Nothing is running.

---

## 2. The current work: a crossmatch subset experiment

**Goal, in the user's words:** "one of the things with SDSS is that it is known
as like super huge db and ppl are used to queries taking a long time." They want
a subset of DR20 to experiment with for crossmatching, without needing to
involve the astronomers in a column-by-column negotiation — hence using the
existing `PhotoTag` view, which is already an agreed column set. They know it
could be trimmed further; that is deliberate for now.

### What was built, on sdss4c

New database **`TestXmatch`** (created by the user, 976.56 GB across two files
on D: and E:, SIMPLE recovery). Two tables, both **1,231,051,050 rows** — an
exact match to PhotoObjAll:

| table | index | compression | size |
|---|---|---|---:|
| `photoMain` | `pk_photoMain_objID` (clustered, on objID) | PAGE | **440.30 GB** |
| | `ix_photoMain_htmid` (on htmID) | PAGE | 15.55 GB |
| | | | **455.85 GB** |
| `photoMain_cci` | `cci_photoMain_cci` (clustered columnstore) | COLUMNSTORE_ARCHIVE | **352.16 GB** |
| | `ix_photoMain_cci_htmid` (on htmID) | PAGE | 15.78 GB |
| | | | **367.94 GB** |

Build script: `dr20/build_photomain.sql`.

`photoMain_cci` has **no primary key** — a table cannot have both a clustered PK
and a clustered columnstore, so the CCI is its clustered structure.

### How they were built, and why

`photoMain_cci` was built **from `photoMain`**, not from the view again. The
`PhotoTag` view cannot be answered from the existing 528.39 GB
`i_PhotoObjAll_PhotoTag` covering index — that index holds 93 of the 98 columns
and is missing `skyVersion`, `rerun`, `clean`, `insideMask`, `size`. So every
pass over `PhotoTag` is a full scan of PhotoObjAll's **3,069 GB** clustered
index. Building the second table from the first read 440 GB instead.

That mattered enormously:

- **Step 1** (photoMain, from the view): **10 h 51 m.** Single-threaded —
  `INSERT ... SELECT` into a **clustered rowstore index does not parallelise**.
  CPU time equalled elapsed time throughout.
- **Step 2** (photoMain_cci, from photoMain): **70 minutes.** Insert into a
  clustered *columnstore* **does** parallelise, and it read 440 GB not 3 TB.

---

## 3. Measurements — the hard-won part

### PhotoObjAll

| | |
|---|---:|
| rows | 1,231,051,050 |
| columns | 509 |
| data (clustered PK on objID, PAGE) | 3,069.42 GB |
| indexes (16 nonclustered, **all uncompressed**) | 1,778.59 GB |
| **total** | **4,848.01 GB (4.73 TB)** |

Fixed column width is 2,117 bytes but stored is 2,677 B/row **with PAGE
compression** — i.e. PAGE achieves essentially nothing here. Dense float
measurement data is near its floor. Same pattern seen on `erass1_main_v1_2`
(8.6%) during the DR20 load.

Largest indexes: `i_PhotoObjAll_PhotoTag` **528.39 GB**, then
`i_PhotoObjAll_SpecObjID_cx_cy_cz` 117.42, and three at 110.53
(`cx_cy_cz_htmID_mod`, `htmID_cx_cy_cz_typ`, `mode_cy_cx_cz_htmI`).

### PhotoTag

A **view**, 98 columns, 437 bytes fixed width per row. 61 `real`, 9 `bigint`,
6 `float`, 11 `int`, 1 `numeric`, 6 `smallint`, 4 `tinyint`. Only one nullable
column (`size`). Carries `objID`, `htmID`, `cx`, `cy`, `cz`, `ra`, `dec`,
`mode`, `type` — everything spatial.

### Bytes per row, measured on a 5,000,000-row sample in tempdb

| form | B/row | full table |
|---|---:|---:|
| uncompressed rowstore | 481.91 | 552.5 GB |
| rowstore PAGE | 390.68 | 447.9 GB |
| rowstore ROW | 431.09 | 494.3 GB |
| clustered columnstore | 531.52 | 609.4 GB |
| **COLUMNSTORE_ARCHIVE** | **311.05** | **356.6 GB** |

The sample extrapolation held up well at 246x scale: it predicted 356.6 GB for
ARCHIVE, actual was 352.16 GB.

### ⚠ The counterintuitive finding: plain CCI is WORSE than PAGE here

Plain clustered columnstore measured **larger than uncompressed rowstore**
(531.52 vs 481.91 B/row) and **+36% vs PAGE**. Reproduced across two runs.

**Why:** columnstore compresses via dictionary encoding, value/bit-packing and
RLE — all of which need repetition or restricted range. This column set is 61
`real` + 6 `float` columns of high-entropy measurements, giving them nothing, so
each segment stores essentially raw values *plus* per-segment dictionary and
metadata overhead. ARCHIVE wins only because it layers LZ77 on top.

**This contradicts the assumption recorded in `dr20/TODO.md`** — "PhotoObjAll
~5 TB; CCI expected to bring that to ~600 GB – 1 TB". On this column set that
expectation looks unsafe. Worth re-testing on a different column mix before
generalising.

### ⚠ The rowgroups are only half full

`photoMain_cci`: **2,319 rowgroups, average 50.6% full**, 454 near-full
(≥1,000,000 rows), 1,237 under half. At 1.23B rows there should be ~1,174 full
rowgroups; there are twice that.

Cause is **parallel insert** — each thread closes its own partial rowgroups at
the end. (The 5M-row sample showed the same symptom for a different reason: a
small sample with MAXDOP 1 still produced 9 undersized groups.)

**This is the first queued task** — see below.

---

## 4. Queued work, in the user's priority order

### 4.1 Consolidate the CCI rowgroups

```sql
ALTER INDEX cci_photoMain_cci ON TestXmatch.dbo.photoMain_cci REBUILD;
```

The user's view: *"the consolidation of the cci i think, we'd want to go for
that for space reasons but it probably won't make too much of a diff in
performance."* Agreed on both counts. Segment overhead is paid 98 columns at a
time per rowgroup, so halving the rowgroup count should be a real space win.

Serial and multi-hour, but a one-time cost on read-only data. **Measure before
and after** — currently 352.16 GB for the CCI itself.

### 4.2 The read comparison — `photoMain` vs `photoMain_cci`

This is the number the ARCHIVE decision actually turns on, and it has **not been
measured at all**. Two query shapes:

- **cone search via htmid** — the crossmatch-shaped access pattern, a range seek
  returning few rows
- **wide aggregate scan** — the analytics-shaped pattern

ARCHIVE's cost is decompression CPU on every read, paid forever, in exchange for
a one-time 87.91 GB (19.3%). The user's position: *"i think archive might be the
correct setting though — this will be read only."* That is right about the write
cost. The read cost is the open question.

Note columnstore of any flavour is poor at the cone-search pattern; that is why
both tables carry a **rowstore** nonclustered index on htmID.

### 4.3 Re-examine the data file layout for NVMe

The user's framing, and it is a good one: *"apart from data compression and the
cci experiments we haven't meaningfully re-examined the data file layout in
years, and we've moved fully to ssd / nvme since then."*

**The key connection: the compression and CCI experiments ARE storage-layout
questions in disguise.** Compression trades CPU for I/O. On spinning disk that
was nearly a free win; on NVMe the ratio has moved by an order of magnitude, so
PAGE and especially ARCHIVE need re-justifying rather than assuming.

What changed, and is worth checking:

- **Many files per filegroup.** BestDR20's SPEC has **12 files**
  (`SPEC_01`..`SPEC_12`); PRIMARY's is still named `BESTDR8_Data1`. That layout
  exists to spread I/O across spindles. A single NVMe device has enormous
  internal parallelism, so 12 files on one device buys nothing. **Check whether
  those files are on distinct physical devices or just distinct paths.**
- **The sequential/random gap** was ~100:1 on spinning disk, ~2–3:1 on NVMe.
  SQL Server's cost model still assumes the old ratio, so the optimizer is
  systematically biased toward scans on this hardware.
- **Fragmentation** is close to irrelevant on NVMe — any rebuild/defrag effort
  spent on it is wasted.
- **Filegroup separation for I/O isolation** is a spindle-era technique.
- **Does NOT change: tempdb's multiple files.** That is about PFS/GAM latch
  contention, not I/O, so it stays regardless of storage.

Grounding measurement is `sys.dm_io_virtual_file_stats` — actual read latency
per file. Sub-millisecond means most of the layout is vestigial and the
interesting questions become CPU and the cost model.

---

## 5. New tooling: Erik Darling's PerformanceMonitor

Installed on **sdss4c** on 2026-08-02. https://github.com/erikdarlingdata/PerformanceMonitor

- **Lite edition** — desktop WPF app, .NET 10, MIT licence. Installs to
  `%LocalAppData%\PerformanceMonitorLite`; config in
  `%ProgramData%\PerformanceMonitorLite\config\` (`servers.json`,
  `settings.json`, `collection_schedule.json`, `ignored_wait_types.json`).
  Local DuckDB + Parquet storage.
- **All three servers added** (4c, 5a, 5b). Windows auth; the user is sysadmin
  everywhere so `VIEW SERVER STATE` is implicit.
- **MCP server enabled on port 5151**, registered in Claude Code user config as
  `sql-monitor`. 74 tools.
- It auto-installs `sp_WhoIsActive`, `sp_BlitzLock`, `sp_HealthParser`,
  `sp_HumanEventsBlockViewer`. **The user is happy with this** — they install
  those manually anyway.
- Query Store, Extended Events and SQL Agent are all optional and degrade
  gracefully, so nothing needed enabling on BestDR20.

**⚠ The MCP server runs inside the WPF app — the endpoint exists only while that
app is open.** If the tools are missing, check the app is running:

```powershell
Get-NetTCPConnection -LocalPort 5151 -State Listen
```

**This handoff exists because adding the MCP server required restarting Claude
Code** to enumerate its tools.

Use it for task 4.3 in particular — per-file read latency is exactly what
`sp_PressureDetector` reports, and `sp_QuickieStore` is the real answer to "SDSS
queries are slow" now that DR20 has had several days of live traffic on 5a/5b.

---

## 6. Environment gotchas learned the hard way

**DMV and metadata traps:**

- `sys.partitions` **double-counts rows for a columnstore** — a bytes-per-row
  figure computed from `SUM(p.rows)` comes out roughly half. Use
  `sys.dm_db_partition_stats` and a known row count instead.
- `FILEPROPERTY(name,'SpaceUsed')` **hangs under heavy I/O.** A progress query
  using it timed out at 5 minutes during the photoMain load.
- A `TABLOCK` insert **blocks metadata reads**, so row counts are unavailable
  mid-load. Use `logical_reads` from `sys.dm_exec_requests` as the progress
  signal instead.
- `sys.column_store_row_groups` has no `state_desc` column on this build.

**Estimation:** my duration estimates on this hardware were repeatedly
optimistic — 3–6 h became 10 h 51 m for the photoMain load, and an
extrapolation from 22% understated the total by ~3 hours because the scan slowed
in its second half. **Discount ETAs on this workload.** Also: a statistics
timing estimate calibrated on one fast table was wrong by 10x. Measure across a
real mix, and say which machine a rate came from.

**Repo layout:** the repo is source of truth **only for `dr20/`**. `schema/`,
`vbs/` and `htm/` live on `C:\sqlloader` and are edited there, then snapshotted
in. **`C:\sqlloader` is a git working copy on `master`**, shared with Ani —
committing there puts DR20 work on master. The user has asked him to commit to
`dr20`. When comparing files between `C:\sqlloader` and the repo, **use
`diff --strip-trailing-cr`** — this repo has mixed line endings and a naive
comparison shows spurious differences.

**Schema files hide commented-out `/* */` copies of live tables.** Any tool
grepping them for `CREATE TABLE` must skip comment regions. `SpectroTables.sql`
has two `allspec` blocks; the one at line 3016 is dead.

**Terminal clicks:** clicking the terminal to focus it was being consumed as an
answer to permission prompts (known issue anthropics/claude-code#70685). Fixed
by `CLAUDE_CODE_DISABLE_MOUSE_CLICKS=1` in a new
`~\Documents\WindowsPowerShell\profile.ps1`. Several tool calls were rejected
that way before it was diagnosed — **if a call is rejected with no explanation,
consider asking rather than assuming it was deliberate.**

---

## 7. Still open from DR20 itself

Not blocking anything, but unfinished:

- **~325 GB of uncompressed htmid indexes.** `run_htm_add.py` creates every one
  without compression — 24 of them, of which PhotoObjAll's three account for
  ~314 GB. One clause in the script fixes the source for DR21.
- **Two stored procedures in the database still reference `boss_clam_params`**
  (`spValidateDR20VACs`, `spPublishDR20VACs`). The `.sql` sources are fixed; the
  compiled copies are not.
- **`mangaDRPall.htmid` is built from `ifura`/`ifudec`** while
  `fGetNearbyMangaObjEq` returns `objra`/`objdec` — 483 of 11,273 rows disagree.
  A science question (object position vs IFU centre), declared `KNOWN-GAP` in
  `verify_spatial.sql`.
- **`spCheckDBIndexes`** — 217 discrepancies of which ~4 are real. Full analysis
  in `dr20/spcheckdbindexes_analysis.md`; needs a conversation with Ani.
- Scoped DELETE for the metadata load; 42 `mos_*` tables with a clustered index
  but no IndexMap row; 2 spAll rows missing from `IndexMap.sql`; PRIMARY reclaim.

---

## 8. Documents worth reading

| file | what it is |
|---|---|
| `dr20/session_summary_20260729.md` | the DR20 launch session in full |
| `dr20/post_backup_runbook.md` | 11-step replay procedure for a restored copy |
| `dr20/post_backup_fixes.md` | the reasoning and measurements behind each fix |
| `dr20/spcheckdbindexes_analysis.md` | why that check reports 217 and ~4 are real |
| `dr20/verify_spatial.sql` | the fGetNearby/fGetNearest test suite, 35 checks |
| `dr20/build_photomain.sql` | how photoMain and photoMain_cci were built |
| `dr20/TODO.md` | the long-running list |

Everything is committed and pushed to `dr20`.

---

## 9. Working style

The user prefers **concise answers**. They said so directly:
*"i just needed a ballpark number, and saying 'around 500-550 GB depending on
indexes and compression' is a perfectly fine answer for what i'm looking at."*
Lead with the number; offer detail rather than delivering it unasked.

**Say where things are going before creating them.** Materialising a 5M-row
sample into tempdb without saying so prompted a reasonable "are you actually
creating the table??? where?"

They are an expert DBA — no need to explain SQL Server basics, but do flag
non-obvious mechanics (parallel insert restrictions, rowgroup behaviour) since
those are what actually drive the decisions here.
