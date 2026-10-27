--=====================================================================
-- MYDBSQL / BatchAdmin: force MAXDOP 1 on the CasJobs scheduler's
-- "waiting jobs" query with a plan guide.
--
-- WHY: ~99% of MYDBSQL deadlocks (2026-10-10..13) have this query as the
-- victim.  Deadlock graph 2026-10-13 14:49 UTC: the query (JOBSSERVICEPROD,
-- READ COMMITTED, 44+ parallel threads) holds page S locks on batch.Jobs
-- and waits on a key X lock held by the web app's UPDATE jobs SET status
-- (IDIESWWW01, REPEATABLE READ), which waits on one of those page locks.
-- Exchange waits between the parallel threads close the cycle.  Serial,
-- it is a short block instead of a deadlock.
--
-- HOW: SQL 2019 has no Query Store hints, so a plan guide.  A SQL plan
-- guide only matches if @stmt and @module_or_batch are byte-for-byte the
-- text the app sends, so this script copies both from the plan cache
-- rather than retyping them.  If the CasJobs app ever changes that text,
-- the guide silently stops matching (check with section 3).
--
-- The guide lives in BatchAdmin (not the instance), so it moves with the
-- database in the planned AG migration and needs no re-creating there.
--
-- Run section 1, check the output, then section 2, then section 3 after
-- the scheduler has run a few times (it polls every ~10 s).
-- ROLLBACK: section 4.
--=====================================================================
USE BatchAdmin
GO

---------------------------------------------------------------
-- 1. Find the statement in the plan cache.  Expect ONE row:
--    stmt starts "select j.*", last_dop > 1, offsets 1510 / 2694
--    (the deadlock graph's stmtstart/stmtend).
--    NOTE: dm_exec_sql_text.dbid is NULL for ad hoc batches, so the
--    database comes from the plan attributes instead.
--    SEVERAL rows with different sql_handles = the app sends a slightly
--    different batch each time (embedded values), and a plan guide
--    CANNOT match it.  Stop and check with Claude in that case.
SELECT	qs.statement_start_offset, qs.statement_end_offset,
	qs.execution_count, qs.last_dop, qs.max_dop,
	qs.total_elapsed_time / NULLIF(qs.execution_count, 0) / 1000 AS avg_ms,
	-- avg_cpu_ms ~ what one run would take serially (MAXDOP 1)
	qs.total_worker_time  / NULLIF(qs.execution_count, 0) / 1000 AS avg_cpu_ms,
	qs.total_logical_reads / NULLIF(qs.execution_count, 0) AS avg_reads,
	qs.creation_time, qs.last_execution_time, CONVERT(int, pa.value) AS plan_dbid,
	LEFT(SUBSTRING(st.text, qs.statement_start_offset/2 + 1,
		(CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
		 ELSE qs.statement_end_offset END - qs.statement_start_offset)/2 + 1), 200) AS stmt,
	qs.sql_handle
FROM	sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa
WHERE	pa.attribute = 'dbid'
  AND	st.text LIKE '%tuple as string thing is very nasty%'
  AND	SUBSTRING(st.text, qs.statement_start_offset/2 + 1, 200) LIKE '%select j.*%'
ORDER BY qs.last_execution_time DESC
GO

-- 1b. Only if 1 is STILL empty: is the batch cached at all, in any form?
--     (Every statement of it, any database.)
SELECT	qs.statement_start_offset, qs.execution_count, qs.last_execution_time,
	LEFT(SUBSTRING(st.text, qs.statement_start_offset/2 + 1, 80), 80) AS stmt_start
FROM	sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE	st.text LIKE '%tuple as string%'
ORDER BY qs.last_execution_time DESC
GO

---------------------------------------------------------------
-- 2. Create the guide from the exact cached text.
/*
DECLARE @batch nvarchar(max), @stmt nvarchar(max)

SELECT TOP (1)
	@batch = st.text,
	@stmt  = SUBSTRING(st.text, qs.statement_start_offset/2 + 1,
		(CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
		 ELSE qs.statement_end_offset END - qs.statement_start_offset)/2 + 1)
FROM	sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa
WHERE	pa.attribute = 'dbid' AND CONVERT(int, pa.value) = DB_ID()
  AND	st.text LIKE '%tuple as string thing is very nasty%'
  AND	SUBSTRING(st.text, qs.statement_start_offset/2 + 1, 200) LIKE '%select j.*%'
ORDER BY qs.last_execution_time DESC

IF @stmt IS NULL
	THROW 50000, 'Scheduler statement not in plan cache; run section 1 again in a minute.', 1

EXEC sp_create_plan_guide
	@name            = N'PG_CasJobsScheduler_WaitingJobs_MAXDOP1',
	@stmt            = @stmt,
	@type            = N'SQL',
	@module_or_batch = @batch,
	@params          = NULL,
	@hints           = N'OPTION (MAXDOP 1)'
GO
*/

---------------------------------------------------------------
-- 3. Verify.  The guide should be enabled and valid (no error row), and
--    after the next few scheduler runs section 1 should show last_dop = 1
--    on a NEW cache entry (creating the guide evicts the old plan).
/*
SELECT	pg.name, pg.is_disabled, pg.create_date, v.message AS validation_error
FROM	sys.plan_guides pg
OUTER APPLY sys.fn_validate_plan_guide(pg.plan_guide_id) v
WHERE	pg.name = N'PG_CasJobsScheduler_WaitingJobs_MAXDOP1'
GO
*/

---------------------------------------------------------------
-- 4. Rollback.
/*
EXEC sp_control_plan_guide N'DROP', N'PG_CasJobsScheduler_WaitingJobs_MAXDOP1'
GO
*/
