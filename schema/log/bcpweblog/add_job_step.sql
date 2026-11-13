/*
bcpweblog: add the loader as step 2 of "Hourly Weblog Update2" on lumberjack (DEPLOY.md section 5, D4).

Run in SSMS or sqlcmd, ONE SECTION AT A TIME, between :25 and :55 (not while the job runs).
Only after the catch-up (DEPLOY section 4.3) is done: the first job run then reads about an hour of logs.

Flow after the change (every step: on success go to the next step, on failure quit reporting failure, as before):
    1 Local weblogs, 2 IIS weblogs (bcpweblog) [new, CmdExec], 3 Local SQL logs, 4 Remote weblogs, 5 Remote SQL logs,
    6 Copy Local CasJobs Sql Logs, 7 Update traffic stats
Inserting at step_id 2 renumbers the old steps 2-6 to 3-7. No step jumps to a step number (checked 2026-11-13), so the flow
is unchanged. Job history rows written before the change keep their old step numbers.

No output file: the loader appends everything to work\bcpweblog.log itself (trimmed after --keep-days); the step's
stdout also lands in the job history (truncated by Agent).
*/

USE msdb;
GO

-- ============================================================================================================
-- Section 1: pre-checks (read-only). Expect: 6 steps, step 2 = 'Local SQL logs', no bcpweblog step, not running.
-- ============================================================================================================
SELECT s.step_id, s.step_name, s.subsystem, s.on_success_action, s.on_fail_action
FROM dbo.sysjobsteps s JOIN dbo.sysjobs j ON j.job_id = s.job_id
WHERE j.name = N'Hourly Weblog Update2' ORDER BY s.step_id;

SELECT ja.start_execution_date, ja.stop_execution_date        -- a row with start and no stop = running now
FROM dbo.sysjobactivity ja JOIN dbo.sysjobs j ON j.job_id = ja.job_id
WHERE j.name = N'Hourly Weblog Update2'
  AND ja.session_id = (SELECT MAX(session_id) FROM dbo.syssessions)
  AND ja.start_execution_date IS NOT NULL AND ja.stop_execution_date IS NULL;
GO

-- ============================================================================================================
-- Section 2: add the step. Refuses if the job doesn't look as expected or is running.
-- ============================================================================================================
SET XACT_ABORT ON;
DECLARE @job sysname = N'Hourly Weblog Update2';
IF (SELECT COUNT(*) FROM dbo.sysjobsteps s JOIN dbo.sysjobs j ON j.job_id = s.job_id WHERE j.name = @job) <> 6
    THROW 50001, 'Expected 6 steps; the job has changed since this script was written. Stop and check.', 1;
IF NOT EXISTS (SELECT 1 FROM dbo.sysjobsteps s JOIN dbo.sysjobs j ON j.job_id = s.job_id
               WHERE j.name = @job AND s.step_id = 2 AND s.step_name = N'Local SQL logs')
    THROW 50002, 'Step 2 is not ''Local SQL logs''. Stop and check.', 1;
IF EXISTS (SELECT 1 FROM dbo.sysjobactivity ja JOIN dbo.sysjobs j ON j.job_id = ja.job_id
           WHERE j.name = @job AND ja.session_id = (SELECT MAX(session_id) FROM dbo.syssessions)
             AND ja.start_execution_date IS NOT NULL AND ja.stop_execution_date IS NULL)
    THROW 50003, 'The job is running. Wait until it finishes.', 1;

EXEC dbo.sp_add_jobstep
    @job_name          = @job,
    @step_id           = 2,
    @step_name         = N'IIS weblogs (bcpweblog)',
    @subsystem         = N'CmdExec',
    @command           = N'C:\ClusterStorage\Volume1\WebLogImport\bcpweblog\python\python.exe C:\ClusterStorage\Volume1\WebLogImport\bcpweblog\bcpweblog.py incremental',
    @cmdexec_success_code = 0,
    @on_success_action = 3,     -- go to the next step
    @on_fail_action    = 2,     -- quit the job reporting failure (the operator email fires), like every other step
    @retry_attempts    = 0;     -- a failed run moved no offsets; the next hour's run continues where it was
GO

-- ============================================================================================================
-- Section 3: verify. Expect 7 steps as listed in the header; step 2 CmdExec, actions 3 / 2.
-- ============================================================================================================
SELECT s.step_id, s.step_name, s.subsystem, s.on_success_action, s.on_fail_action, s.command
FROM dbo.sysjobsteps s JOIN dbo.sysjobs j ON j.job_id = s.job_id
WHERE j.name = N'Hourly Weblog Update2' ORDER BY s.step_id;
GO

-- ============================================================================================================
-- Section 4: ROLLBACK (only if needed). Removes the step by name; the old steps renumber back to 2-6.
-- Stopping the loader without touching the job also works: UPDATE weblog.dbo.LogSource SET status = 'INACTIVE'
-- WHERE logID IN (3001, 3002, 3003)  (the step then finds no sources and exits 0).
-- ============================================================================================================
/*
DECLARE @id int = (SELECT s.step_id FROM dbo.sysjobsteps s JOIN dbo.sysjobs j ON j.job_id = s.job_id
                   WHERE j.name = N'Hourly Weblog Update2' AND s.step_name = N'IIS weblogs (bcpweblog)');
IF @id IS NULL THROW 50004, 'No bcpweblog step to remove.', 1;
EXEC dbo.sp_delete_jobstep @job_name = N'Hourly Weblog Update2', @step_id = @id;
*/
