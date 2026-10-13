--=====================================================================
-- After switching step 5 to spCopyLocalCasJobsSqlLogs2 (2026-10-13):
-- run after the first scheduled run (the cut-over), and again after a
-- few more.
--=====================================================================

-- 1. Step outcomes for the last day.  Step 5 should succeed every run,
--    and step 6 should now appear after it.  run_status 1 = succeeded.
SELECT TOP 50 h.step_id, h.step_name, h.run_status,
       msdb.dbo.agent_datetime(h.run_date, h.run_time) AS started,
       h.run_duration AS hhmmss, LEFT(h.message, 200) AS message
FROM   msdb.dbo.sysjobhistory h
JOIN   msdb.dbo.sysjobs j ON j.job_id = h.job_id
WHERE  j.name = 'Hourly Weblog Update2' AND h.step_id IN (5, 6)
ORDER BY h.instance_id DESC

-- 2. Watermark.  lastEnd should be ~5 min before the last run (local
--    time), lastRunUtc that same run in UTC, and lowJobID creeping up.
SELECT * FROM weblog.dbo.CasJobsCopyState

-- 3. Rows per local hour today.  No hour should be suspiciously empty;
--    hours after 20:00 local should now fill in too.
SELECT hh, COUNT(*) AS jobs
FROM   weblog.dbo.SqlLogAll
WHERE  logID = 2061 AND yy = YEAR(GETDATE()) AND mm = MONTH(GETDATE()) AND dd = DAY(GETDATE())
GROUP BY hh
ORDER BY hh

-- 4. Staging is emptied at the end of a real run.  Should be 0.
SELECT COUNT(*) AS stagedLeftOver FROM weblog.dbo.CasJobsSqlLogStage
