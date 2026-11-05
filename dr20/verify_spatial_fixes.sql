-------------------------------------------------------------------------------
--  verify_spatial_fixes.sql
--
--  Run AFTER fix_spall_htm.sql and fix_nearby_distance.sql.
--  Every row should say PASS.
--
--  Suzanne Werner, 2026-07-28
-------------------------------------------------------------------------------
USE BestDR20;
GO
SET NOCOUNT ON;
GO

-- 1. spAll htmid must not be piled on one value
SELECT '1. spAll htmid spread' AS check_name,
       CASE WHEN MAX(cnt) < 10000 THEN 'PASS' ELSE 'FAIL' END AS result,
       'biggest pile = ' + CAST(MAX(cnt) AS varchar(20))
       + ' (was 4,905,907 before the fix)' AS detail
FROM (SELECT COUNT(*) AS cnt FROM spAll GROUP BY htmid) x;

-- 2. nothing should sit at the bogus ra=81 dec=81 position
SELECT '2. no pile at ra=81,dec=81' AS check_name,
       CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS result,
       CAST(COUNT(*) AS varchar(20)) + ' rows returned (was 4.9M)' AS detail
FROM dbo.fGetNearbySpAllEq(81.0, 81.0, 1);

-- 3. a known spAll object must be findable at its own position
DECLARE @ra float, @dec float, @id numeric(30);
SELECT TOP 1 @id = specobjid, @ra = racat, @dec = deccat
FROM spAll WHERE htmid IS NOT NULL;
SELECT '3. spAll cone search finds itself' AS check_name,
       CASE WHEN EXISTS (SELECT 1 FROM dbo.fGetNearbySpAllEq(@ra,@dec,1)
                          WHERE specobjid = @id) THEN 'PASS' ELSE 'FAIL' END AS result,
       'probe specobjid ' + CAST(@id AS varchar(40)) AS detail;

-- 4. self-match distance must be ~0, not thousands of arcmin
SELECT '4. reported distance is correct' AS check_name,
       CASE WHEN MIN(distance) < 0.001 THEN 'PASS' ELSE 'FAIL' END AS result,
       'nearest distance = ' + CAST(MIN(distance) AS varchar(30))
       + ' arcmin (was 9825 before the fix)' AS detail
FROM dbo.fGetNearbySpAllEq(@ra, @dec, 1);

-- 5. no fGetNearby*XYZ may still recompute distance from ra/dec
SELECT '5. no broken distance expressions' AS check_name,
       CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS result,
       CAST(COUNT(*) AS varchar(10)) + ' function(s) still broken' AS detail
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE o.name LIKE 'fGetNearby%XYZ'
  AND m.definition LIKE '%@nx-(%';   -- see the note in fix_nearby_distance.sql;
                                     -- the old COS([ / NOT @nx-cx test never fired
GO
