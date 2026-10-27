-- verify_duplicate_logsources.sql
-- Read-only checks for LogSource rows that point at the same folder (found 2026-10-27).
-- Run on lumberjack, database weblog. Every query is a SELECT with NOLOCK, so it can't block the
-- hourly "Weblog Update2" job. weblogAll queries always filter on yy/mm/dd (the PK prefix); a
-- filter on logID or theTime alone scans the whole table.
--
-- Change @yy/@mm/@dd to check another day (weblogAll keeps about a year).

USE weblog;
SET NOCOUNT ON;

DECLARE @yy smallint = 2026, @mm tinyint = 10, @dd tinyint = 26;

-- Sources the job loads: the same filter as the spCopyWebLogs cursor. "folder" ignores case
-- and trailing backslashes, so W3SVC1\ and W3SVC1\\ count as the same folder.
IF OBJECT_ID('tempdb..#src') IS NOT NULL DROP TABLE #src;
SELECT logID, location, service, instance, pathname,
       REPLACE(REPLACE(REPLACE(LOWER(pathname) + '|', '\\|', '|'), '\|', '|'), '|', '') AS folder
INTO #src
FROM LogSource WITH (NOLOCK)
WHERE method = 'XCOPY' AND isvisible = 1 AND status = 'ACTIVE';

------------------------------------------------------------------------------------------------
-- 1. Which active sources share a folder?  Expect: no rows.
------------------------------------------------------------------------------------------------
SELECT folder,
       COUNT(*) AS sources,
       STRING_AGG(CAST(logID AS varchar(10)) + ' (' + instance + ')', ', ')
           WITHIN GROUP (ORDER BY logID) AS logIDs
FROM #src
GROUP BY folder
HAVING COUNT(*) > 1
ORDER BY folder;

------------------------------------------------------------------------------------------------
-- 1b. Same check for the SQL query-log sources (method TSQL, loaded into SqlLogAll by step 2).
--     Expect: no rows.  (2026-10-27: SDSS4J.weblog 2179/2181 and SDSS4K.weblog 2180/2182.)
------------------------------------------------------------------------------------------------
SELECT LOWER(pathname) AS source_,
       COUNT(*) AS sources,
       STRING_AGG(CAST(logID AS varchar(10)) + ' (' + instance + ')', ', ')
           WITHIN GROUP (ORDER BY logID) AS logIDs
FROM LogSource WITH (NOLOCK)
WHERE method = 'TSQL' AND isvisible = 1 AND status = 'ACTIVE'
GROUP BY LOWER(pathname)
HAVING COUNT(*) > 1
ORDER BY source_;

------------------------------------------------------------------------------------------------
-- 2. Rows per source for one day.  Sources that share a folder show identical counts.
------------------------------------------------------------------------------------------------
SELECT s.folder, w.logID, s.instance, COUNT_BIG(*) AS rows_
FROM weblogAll w WITH (NOLOCK)
JOIN #src s ON s.logID = w.logID
WHERE w.yy = @yy AND w.mm = @mm AND w.dd = @dd
  AND s.folder IN (SELECT folder FROM #src GROUP BY folder HAVING COUNT(*) > 1)
GROUP BY s.folder, w.logID, s.instance
ORDER BY s.folder, w.logID;

------------------------------------------------------------------------------------------------
-- 3. Row-level proof for each pair: rows in one logID that are missing from the other, comparing
--    every loaded column except logID and seq.  Expect 0 / 0 if they really are the same log.
------------------------------------------------------------------------------------------------
;WITH pairs AS (
    SELECT a.logID AS idA, b.logID AS idB
    FROM #src a JOIN #src b ON a.folder = b.folder AND a.logID < b.logID
)
SELECT p.idA, p.idB,
    (SELECT COUNT_BIG(*) FROM (
        SELECT hh, mi, ss, clientIP, op, command, error, browser, referer, bytesOut, bytesIn, elapsed
        FROM weblogAll WITH (NOLOCK) WHERE yy = @yy AND mm = @mm AND dd = @dd AND logID = p.idA
        EXCEPT
        SELECT hh, mi, ss, clientIP, op, command, error, browser, referer, bytesOut, bytesIn, elapsed
        FROM weblogAll WITH (NOLOCK) WHERE yy = @yy AND mm = @mm AND dd = @dd AND logID = p.idB
    ) x) AS only_in_A,
    (SELECT COUNT_BIG(*) FROM (
        SELECT hh, mi, ss, clientIP, op, command, error, browser, referer, bytesOut, bytesIn, elapsed
        FROM weblogAll WITH (NOLOCK) WHERE yy = @yy AND mm = @mm AND dd = @dd AND logID = p.idB
        EXCEPT
        SELECT hh, mi, ss, clientIP, op, command, error, browser, referer, bytesOut, bytesIn, elapsed
        FROM weblogAll WITH (NOLOCK) WHERE yy = @yy AND mm = @mm AND dd = @dd AND logID = p.idA
    ) x) AS only_in_B
FROM pairs p
ORDER BY p.idA;

------------------------------------------------------------------------------------------------
-- 4. Effect on trafficBase for that day: hits as published vs hits without the extra copy
--    (keeping the lowest logID per folder).  trafficBase.hits = count(*) of weblogAll, not split
--    by logID, so the extra copies are counted as hits.
------------------------------------------------------------------------------------------------
;WITH extra AS (
    SELECT logID FROM #src s
    WHERE logID > (SELECT MIN(logID) FROM #src s2 WHERE s2.folder = s.folder)
)
SELECT
    (SELECT SUM(CAST(hits AS bigint)) FROM trafficBase WITH (NOLOCK)
      WHERE yy = @yy AND mm = @mm AND dd = @dd)                       AS trafficBase_hits,
    (SELECT COUNT_BIG(*) FROM weblogAll WITH (NOLOCK)
      WHERE yy = @yy AND mm = @mm AND dd = @dd)                       AS weblogAll_rows,
    (SELECT COUNT_BIG(*) FROM weblogAll WITH (NOLOCK)
      WHERE yy = @yy AND mm = @mm AND dd = @dd
        AND logID IN (SELECT logID FROM extra))                       AS duplicate_rows;

------------------------------------------------------------------------------------------------
-- 5. How long has it been going on?  Rows per paired source on the 1st of each month that weblogAll
--    still holds.  Equal counts in a pair = already duplicated that day.  Earlier history
--    is only in trafficBase (aggregated), so it can't be checked this way.
------------------------------------------------------------------------------------------------
;WITH days AS (
    SELECT DATEFROMPARTS(yy, mm, 1) AS d
    FROM (SELECT DISTINCT TOP 100 yy, mm FROM trafficBase WITH (NOLOCK)
          WHERE DATEFROMPARTS(yy, mm, 1) >= DATEADD(month, -13, GETDATE())
          ORDER BY yy, mm) t
)
SELECT d.d AS day_, w.logID, COUNT_BIG(*) AS rows_
FROM days d
JOIN weblogAll w WITH (NOLOCK)
  ON w.yy = YEAR(d.d) AND w.mm = MONTH(d.d) AND w.dd = 1
WHERE w.logID IN (SELECT logID FROM #src
                  WHERE folder IN (SELECT folder FROM #src GROUP BY folder HAVING COUNT(*) > 1))
GROUP BY d.d, w.logID
ORDER BY d.d, w.logID;

DROP TABLE #src;
