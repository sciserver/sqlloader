--=====================================================================
-- Switch step 5 of "Hourly Weblog Update2" (lumberjack) from
-- spCopyLocalCasJobsSqlLogs to spCopyLocalCasJobsSqlLogs2.
--
-- Run section 1, check the output, then run section 2.
--
-- The next scheduled run is the cut-over (no CasJobsCopyState row yet):
-- it deletes the last 12h of old-proc CasJobs rows and reloads them.
-- Verified by dry run + cutover_checks.sql on 2026-10-13.
--
-- ROLLBACK: run section 3.  The old proc rewrites the whole day each run,
-- so it repairs itself.  Also delete the CasJobsCopyState row, so a later
-- switch back to v2 does a fresh cut-over instead of resuming from a
-- stale watermark.
--=====================================================================
USE msdb
GO

---------------------------------------------------------------
-- 1. Look first: confirm step 5 is the one that calls the old proc.
SELECT j.name, s.step_id, s.step_name, s.database_name, s.command,
       s.on_success_action, s.on_fail_action
FROM   dbo.sysjobs j
JOIN   dbo.sysjobsteps s ON s.job_id = j.job_id
WHERE  j.name = 'Hourly Weblog Update2'
ORDER BY s.step_id
GO

---------------------------------------------------------------
-- 2. Switch.  Only the command changes; step name, database and
--    flow (on success/fail) stay as they are.
/*
EXEC dbo.sp_update_jobstep
	@job_name = 'Hourly Weblog Update2',
	@step_id  = 5,
	@command  = N'EXEC dbo.spCopyLocalCasJobsSqlLogs2'
GO
*/

---------------------------------------------------------------
-- 3. Rollback.  Put the original command back exactly as section 1
--    showed it (paste it in below), then clear the v2 state.
/*
EXEC dbo.sp_update_jobstep
	@job_name = 'Hourly Weblog Update2',
	@step_id  = 5,
	@command  = N'<original command from section 1>'
GO
DELETE weblog.dbo.CasJobsCopyState WHERE logID = 2061
GO
*/
