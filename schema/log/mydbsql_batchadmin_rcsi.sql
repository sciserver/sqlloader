--=====================================================================
-- MYDBSQL: turn on READ_COMMITTED_SNAPSHOT (RCSI) for BatchAdmin.
--
-- Why: after the scheduler plan guide (2026-10-13), the deadlocks that
-- remain are serial key-lookup deadlocks.  The scheduler's read-committed
-- SELECT holds a page S lock on a nonclustered index of batch.Jobs and
-- waits for a key S lock on PK_Jobs.  The web app's REPEATABLE READ
-- UPDATE holds that key X lock and waits for IX on the page.  Under RCSI,
-- read-committed readers take no S locks, so that cycle can't form.
--
-- What it does NOT change: the web app's REPEATABLE READ transactions
-- (SqlFactory.insert) still lock exactly as before.  Only plain
-- read-committed reads change: they see the last committed version
-- instead of waiting for a writer.
--
-- CasJobs code review (develop @ a8929b0):
--  * Status updates (JobAdmin.StartJobStatement, CancelStatement, ...)
--    are single statements with no "AND status = x" guard.  Today's
--    locking read committed already releases S locks right after each
--    read, so the read-then-update race exists now.  RCSI only widens
--    it by however long a single-row UPDATE holds its X lock
--    (milliseconds).
--  * The Jobs Service keeps one long-lived connection.  Section 2 kills
--    it (ROLLBACK IMMEDIATE).  CJobsDBThread.EnsureConnectionIsOpen
--    reopens a Closed/Broken connection on the next 10-second cycle, and
--    that cycle's exception is caught and logged.  Section 3 checks it
--    recovered.  If it didn't, restart the CasJobs Jobs Service.
--
-- Run sections one at a time, as a sysadmin, in a quiet period.
-- Agree it with the CasJobs owner first.
--=====================================================================

-- 1. Pre-checks.
--    a) Current setting (expect 0).
SELECT name, is_read_committed_snapshot_on, snapshot_isolation_state_desc
FROM   sys.databases WHERE name = N'BatchAdmin'

--    b) Open transactions in BatchAdmin.  ROLLBACK IMMEDIATE rolls these
--       back.  Expect only short ones.
SELECT s.session_id, s.host_name, s.program_name, s.login_name,
       t.transaction_begin_time,
       DATEDIFF(second, t.transaction_begin_time, GETDATE()) AS open_s
FROM   sys.dm_tran_active_transactions t
JOIN   sys.dm_tran_session_transactions st ON st.transaction_id = t.transaction_id
JOIN   sys.dm_exec_sessions s ON s.session_id = st.session_id
WHERE  s.database_id = DB_ID(N'BatchAdmin')
ORDER BY t.transaction_begin_time

--    c) tempdb free space (the version store lives there).  batch.Jobs
--       sees thousands of updates a day, so this should stay tiny.
SELECT SUM(unallocated_extent_page_count) * 8 / 1024 AS tempdb_free_mb,
       SUM(version_store_reserved_page_count) * 8 / 1024 AS version_store_mb
FROM   tempdb.sys.dm_db_file_space_usage

--    d) Baseline: the scheduler's last cycle (keep this to compare with
--       section 3).
SELECT [name], State, LastCycle FROM BatchAdmin.dbo.ServiceStatus

-- 2. The change.  It needs a moment alone in the database, so it ends
--    every BatchAdmin session (rolling back what they had open).
--    Usually takes a second or two.
ALTER DATABASE BatchAdmin SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE

-- 3. Post-checks (wait ~30 s first).
--    a) Setting is on (expect 1).
SELECT name, is_read_committed_snapshot_on
FROM   sys.databases WHERE name = N'BatchAdmin'

--    b) The Jobs Service reconnected: LastCycle should keep advancing
--       for all five services.  Run Jobs, Cancel Jobs, Output, and Output
--       Cleanup cycle every ~10-15 s; Job Cleanup every ~10 min.  (On
--       2026-10-14 the baseline was 4-14 s, and 573 s for Job Cleanup.)
SELECT [name], State, LastCycle, DATEDIFF(second, LastCycle, GETDATE()) AS secondsAgo
FROM   BatchAdmin.dbo.ServiceStatus

--    c) The scheduler is back (a session from JOBSSERVICEPROD).
SELECT session_id, host_name, login_time, last_request_end_time
FROM   sys.dm_exec_sessions
WHERE  database_id = DB_ID(N'BatchAdmin') AND host_name = N'JOBSSERVICEPROD'

-- 4. Rollback (same exclusive-access caveat as section 2).
-- ALTER DATABASE BatchAdmin SET READ_COMMITTED_SNAPSHOT OFF WITH ROLLBACK IMMEDIATE
