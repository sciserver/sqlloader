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

-- 3. Rows per local hour, yesterday and today, next to the same hour a
--    week earlier (copied by the old proc).  No hour should be empty.
--    The test of the time-zone fix is YESTERDAY's hours 20-23: weekAgo
--    should be 0 or near it there (the bug), and jobs should not be.
--    The yy/mm/dd columns are compared bare so the filter stays seekable
--    (SqlLogAll is over a billion rows).
DECLARE @today date = GETDATE()
DECLARE @d1 date = DATEADD(day, -1, @today), @w0 date = DATEADD(day, -7, @today),
        @w1 date = DATEADD(day, -8, @today)
;WITH h AS (
    SELECT DATEFROMPARTS(yy, mm, dd) AS d, hh, COUNT(*) AS n
    FROM   weblog.dbo.SqlLogAll
    WHERE  logID = 2061
      AND (   (yy = YEAR(@today) AND mm = MONTH(@today) AND dd = DAY(@today))
           OR (yy = YEAR(@d1)    AND mm = MONTH(@d1)    AND dd = DAY(@d1))
           OR (yy = YEAR(@w0)    AND mm = MONTH(@w0)    AND dd = DAY(@w0))
           OR (yy = YEAR(@w1)    AND mm = MONTH(@w1)    AND dd = DAY(@w1)))
    GROUP BY yy, mm, dd, hh
)
SELECT cur.d AS day, cur.hh, cur.n AS jobs, ISNULL(wk.n, 0) AS weekAgo
FROM   h cur
LEFT JOIN h wk ON wk.d = DATEADD(day, -7, cur.d) AND wk.hh = cur.hh
WHERE  cur.d >= DATEADD(day, -1, @today)
ORDER BY cur.d, cur.hh

-- 4. Staging is emptied at the end of a real run.  Should be 0.
SELECT COUNT(*) AS stagedLeftOver FROM weblog.dbo.CasJobsSqlLogStage
