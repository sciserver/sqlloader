USE weblog;
-- Window from the 2026-10-13 dry run.  Re-run the dry run first if the
-- staging table has been redeployed/truncated since.
DECLARE @from datetime = '2026-10-12 23:27:53.950',
        @upTo datetime = '2026-10-13 11:27:53.950';

-- 1. Old-proc rows the cut-over would delete and NOT re-insert.
--    Expected: a handful, all near @upTo (jobs still running at the dry run).
SELECT CASE WHEN s.theTime >= DATEADD(hour, -1, @upTo) THEN 'last hour' ELSE 'earlier' END AS bucket,
       COUNT(*) AS oldRowsNotRestaged, MIN(s.theTime) AS earliest, MAX(s.theTime) AS latest
FROM SqlLogAll s
WHERE ((s.yy > YEAR(@from)) OR (s.yy = YEAR(@from) AND s.mm > MONTH(@from))
    OR (s.yy = YEAR(@from) AND s.mm = MONTH(@from) AND s.dd >= DAY(@from)))
  AND s.theTime >= @from AND s.logID = 2061
  AND NOT EXISTS (SELECT 1 FROM dbo.CasJobsSqlLogStage g
                  WHERE g.theTime = s.theTime AND g.clientIP = s.clientIP)
GROUP BY CASE WHEN s.theTime >= DATEADD(hour, -1, @upTo) THEN 'last hour' ELSE 'earlier' END;

-- 2. New rows the old proc never copied, by local start hour.
--    Expected: Monday 23:xx (the UTC/local bug) and the last ~half hour.
SELECT CONVERT(char(13), g.theTime, 120) AS startHour, COUNT(*) AS newOnly
FROM dbo.CasJobsSqlLogStage g
WHERE NOT EXISTS (SELECT 1 FROM SqlLogAll s
                  WHERE s.logID = 2061
                    AND s.yy = g.yy AND s.mm = g.mm AND s.dd = g.dd
                    AND s.theTime = g.theTime AND s.clientIP = g.clientIP)
GROUP BY CONVERT(char(13), g.theTime, 120)
ORDER BY startHour;
