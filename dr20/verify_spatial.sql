-------------------------------------------------------------------------------
--  verify_spatial.sql
--
--  Generalized verification of the fGetNearby* / fGetNearest* family and the
--  spatial index columns they depend on. Supersedes verify_spatial_fixes.sql,
--  which only tested the two 2026-07-28 fixes on spAll.
--
--  WHY THIS EXISTS
--  The spAll bug found 2026-07-28 was invisible for years: htmid/cx/cy/cz were
--  computed from plug_ra/plug_dec (the -9999 null sentinel) while the function
--  returned racat/deccat, so 91.6% of the table was unreachable by cone search
--  and a cone search at ra=81,dec=81 returned 4.9M spurious rows. Nothing
--  errored, because -9999 is a valid float.
--
--  The generic form of that bug is: THE SPATIAL INDEX WAS BUILT FROM DIFFERENT
--  COLUMNS THAN THE ONES THE FUNCTION REPORTS. Check B below tests exactly that,
--  directly and cheaply, on every table in the family.
--
--  HOW THE FAMILY IS STRUCTURED (verified 2026-07-29, 49 functions)
--    fGetNearby<X>XYZ  - the only functions with real logic: HTM cover join,
--                        distance, radius filter
--    fGetNearby<X>Eq   - converts ra/dec to xyz, calls the XYZ one
--    fGetNearest<X>*   - SELECT TOP 1 over the Nearby XYZ one
--  So there are ~12 real implementations and ~37 thin wrappers. Testing through
--  the Eq entry point exercises the whole chain for a given table.
--
--  ADDING A TABLE
--  Add one row to @driver. That is the only edit required.
--
--  Run with:  sqlcmd -S <server> -b -i verify_spatial.sql
--  Every row of the final summary must read OK.
--
--  Suzanne Werner, 2026-07-29
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;

DECLARE @sampleRows int = 1000;   -- rows sampled per table for checks B1-B3
DECLARE @probeRows  int = 5;      -- objects probed per table for check C
DECLARE @probeArcmin float = 0.1; -- cone radius for the self-match probe

-------------------------------------------------------------------------------
--  DRIVER - the one thing to edit when a table joins the family.
--
--  raCol/decCol MUST be the columns the function RETURNS as its ra/dec.
--  That is the whole point: if the spatial index was built from something else,
--  check B fails. Naming the wrong columns here would hide the bug it exists
--  to catch.
--
--  expected values:
--    PASS       the normal case
--    KNOWN-GAP  a documented unpopulated or wrongly-sourced spatial index
--    DEAD       the function itself does not work and we have decided to leave
--               it that way; the check is expected to ERROR
--    SKIP       not applicable to this table
--  A KNOWN-GAP or DEAD entry that starts passing is ALSO reported, so a stale
--  exemption cannot sit here unnoticed.
-------------------------------------------------------------------------------
DECLARE @driver TABLE (
    seq          int IDENTITY(1,1),
    tableName    sysname,
    raCol        sysname,
    decCol       sysname,
    hasXyz       bit,
    callTemplate nvarchar(400),   -- %RA% %DEC% %R% are substituted
    expHtmid     varchar(10),     -- expected result of check B1
    expXyz       varchar(10),     -- expected result of check B2
    expProbe     varchar(10),     -- expected result of check C
    note         varchar(200)
);

INSERT @driver (tableName, raCol, decCol, hasXyz, callTemplate, expHtmid, expXyz, expProbe, note) VALUES
 ('allspec',            'ra',    '[dec]',  1, 'dbo.fGetNearbyAllspecEq(%RA%,%DEC%,%R%)',          'PASS','PASS','PASS', ''),
 ('spAll',              'racat', 'deccat', 1, 'dbo.fGetNearbySpAllEq(%RA%,%DEC%,%R%)',            'PASS','PASS','PASS', 'rebuilt from racat/deccat 2026-07-28'),
 ('mos_target',         'ra',    '[dec]',  1, 'dbo.fGetNearbyMosTargetEq(%RA%,%DEC%,%R%)',        'PASS','PASS','PASS', 'cx/cy/cz are real, not float - tolerance widens automatically'),
 ('apogee_drp_allstar', 'ra',    '[dec]',  1, 'dbo.fGetNearbyApogeeDrpAllstarEq(%RA%,%DEC%,%R%)', 'PASS','PASS','PASS', ''),
 ('apogeeStar',         'ra',    '[dec]',  1, 'dbo.fGetNearbyApogeeStarEq(%RA%,%DEC%,%R%)',       'PASS','PASS','PASS', ''),
 ('SpecObjAll',         'ra',    '[dec]',  1, 'dbo.fGetNearbySpecObjAllEq(%RA%,%DEC%,%R%)',       'PASS','PASS','PASS', 'also covers the SpecObj view'),
 ('PhotoObjAll',        'ra',    '[dec]',  1, 'dbo.fGetNearbyObjAllEq(%RA%,%DEC%,%R%)',           'PASS','PASS','PASS', 'also covers the PhotoPrimary view'),
 ('mastar_goodstars',   'ra',    '[dec]',  1, 'dbo.fGetNearbyMaStarObjEq(%RA%,%DEC%,%R%)',        'PASS','PASS','PASS', ''),
 ('Frame',              'ra',    '[dec]',  1, 'dbo.fGetNearbyFrameEq(%RA%,%DEC%,%R%,0)',          'PASS','PASS','PASS', 'takes a 4th @zoom argument'),
 ('mangaDRPall',        'objra', 'objdec', 0, 'dbo.fGetNearbyMangaObjEq(%RA%,%DEC%,%R%)',         'KNOWN-GAP','SKIP','PASS',
    'htmid is built from ifura/ifudec but the function returns objra/objdec; 483 of 11,273 rows differ. No cx/cy/cz.'),
 ('sdssTiledTargetAll', 'ra',    '[dec]',  1, 'dbo.fGetNearbyTiledTargetsEq(%RA%,%DEC%,%R%)',     'KNOWN-GAP','PASS','DEAD',
    'fGetNearbyTiledTargetsEq joins TiledTarget, a view deliberately dropped in 2010; dead ever since. htmid=0 on all rows, left alone 2026-07-29. cx/cy/cz are correct.');

-------------------------------------------------------------------------------
CREATE TABLE #r (
    seq      int IDENTITY(1,1),
    part     char(1),
    check_name varchar(60),
    subject  varchar(80),
    result   varchar(10),
    expected varchar(10),
    detail   varchar(400)
);

-------------------------------------------------------------------------------
--  PART A - static checks on the function definitions. No data access.
-------------------------------------------------------------------------------

-- A1. No fGetNearby*XYZ may recompute distance from ra/dec. Four of them did:
--     they used COS()/SIN() without converting degrees to radians while
--     @nx/@ny/@nz were built with the conversion, so the reported distance was
--     garbage (9825 arcmin for a zero-separation self-match). Fixed 2026-07-28
--     to use the precomputed cx/cy/cz like the correct five.
INSERT #r (part, check_name, subject, result, expected, detail)
SELECT 'A', 'distance uses cx/cy/cz, not raw ra/dec', o.name,
       'FAIL', 'PASS', 'recomputes distance from ra/dec without RADIANS()'
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE o.name LIKE 'fGetNearby%XYZ'
  AND m.definition LIKE '%COS([%' AND m.definition NOT LIKE '%@nx-cx%';

INSERT #r (part, check_name, subject, result, expected, detail)
SELECT 'A', 'distance uses cx/cy/cz, not raw ra/dec', '(all fGetNearby*XYZ)',
       'PASS', 'PASS', CAST(COUNT(*) AS varchar(10)) + ' function(s) checked, none broken'
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE o.name LIKE 'fGetNearby%XYZ'
HAVING NOT EXISTS (SELECT 1 FROM #r WHERE part='A' AND result='FAIL');

-- A2. Every fGetNearest* takes TOP 1, so it MUST order by distance. Without it
--     SQL Server may return any row from the cone -- inserting into a table
--     variable in order does not guarantee reading it back in that order.
INSERT #r (part, check_name, subject, result, expected, detail)
SELECT 'A', 'fGetNearest* orders by distance', o.name,
       'FAIL', 'PASS', 'SELECT TOP 1 with no ORDER BY - returns an arbitrary row, not the nearest'
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE o.name LIKE 'fGetNearest%'
  AND m.definition LIKE '%top 1%'
  AND m.definition NOT LIKE '%ORDER BY%';

INSERT #r (part, check_name, subject, result, expected, detail)
SELECT 'A', 'fGetNearest* orders by distance', '(all fGetNearest*)',
       'PASS', 'PASS', CAST(COUNT(*) AS varchar(10)) + ' function(s) checked, all ordered'
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE o.name LIKE 'fGetNearest%' AND m.definition LIKE '%top 1%'
HAVING NOT EXISTS (SELECT 1 FROM #r WHERE check_name='fGetNearest* orders by distance' AND result='FAIL');

-- A3. Every function named in the driver must exist.
INSERT #r (part, check_name, subject, result, expected, detail)
SELECT 'A', 'driver function exists', d.tableName, 'FAIL', 'PASS',
       'no such function: ' + LEFT(d.callTemplate, CHARINDEX('(', d.callTemplate) - 1)
FROM @driver d
WHERE OBJECT_ID(REPLACE(LEFT(d.callTemplate, CHARINDEX('(', d.callTemplate) - 1), 'dbo.', 'dbo.')) IS NULL;

-------------------------------------------------------------------------------
--  PARTS B and C - per table, driven by @driver.
-------------------------------------------------------------------------------
DECLARE @seq int = 1, @maxSeq int = (SELECT MAX(seq) FROM @driver);
DECLARE @tbl sysname, @ra sysname, @dec sysname, @hasXyz bit,
        @tmpl nvarchar(400), @expH varchar(10), @expX varchar(10),
        @expP varchar(10), @note varchar(200);
DECLARE @sql nvarchar(max), @tol float, @func sysname, @hasDist bit;

WHILE @seq <= @maxSeq
BEGIN
    SELECT @tbl = tableName, @ra = raCol, @dec = decCol, @hasXyz = hasXyz,
           @tmpl = callTemplate, @expH = expHtmid, @expX = expXyz,
           @expP = expProbe, @note = note
    FROM @driver WHERE seq = @seq;

    IF OBJECT_ID(@tbl) IS NULL
    BEGIN
        INSERT #r (part, check_name, subject, result, expected, detail)
        VALUES ('B', 'table exists', @tbl, 'FAIL', 'PASS', 'no such table');
        SET @seq += 1;
        CONTINUE;
    END

    -- Tolerance follows the storage type. cx/cy/cz are float on most tables but
    -- real on the mos_* ones, and real carries only ~7 significant digits, so a
    -- float-tight tolerance would report every row as mismatched.
    SELECT @tol = CASE WHEN ty.name = 'real' THEN 1e-6 ELSE 1e-9 END
    FROM sys.columns c JOIN sys.types ty ON ty.user_type_id = c.user_type_id
    WHERE c.object_id = OBJECT_ID(@tbl) AND c.name = 'cx';
    SET @tol = ISNULL(@tol, 1e-9);

    -- Not every function in the family returns a distance column.
    SET @func = LEFT(@tmpl, CHARINDEX('(', @tmpl) - 1);
    SET @hasDist = CASE WHEN EXISTS (SELECT 1 FROM sys.columns
                                     WHERE object_id = OBJECT_ID(@func) AND name = 'distance')
                        THEN 1 ELSE 0 END;

    ---------------------------------------------------------------------------
    -- B. Does the spatial index agree with the coordinates the function
    --    reports? This is the direct test for the spAll bug class.
    ---------------------------------------------------------------------------
    BEGIN TRY
        SET @sql = N'
        DECLARE @n int, @badHtm int, @badXyz int, @nullish int, @zeroHtm int;
        SELECT TOP (@sample) ' + QUOTENAME(@ra) + N' AS ra, ' + @dec + N' AS dcl,
               htmid AS h' + CASE WHEN @hasXyz = 1 THEN N', cx, cy, cz' ELSE N'' END + N'
        INTO #s FROM ' + QUOTENAME(@tbl) + N'
        WHERE ' + QUOTENAME(@ra) + N' IS NOT NULL AND ' + @dec + N' IS NOT NULL;

        SELECT @n = COUNT(*),
               @nullish = SUM(CASE WHEN h IS NULL THEN 1 ELSE 0 END),
               @zeroHtm = SUM(CASE WHEN h = 0 THEN 1 ELSE 0 END)
        FROM #s;

        SELECT @badHtm = COUNT(*) FROM #s WHERE h <> dbo.fHtmEq(ra, dcl);
        ' + CASE WHEN @hasXyz = 1 THEN N'
        SELECT @badXyz = COUNT(*) FROM #s s
        CROSS APPLY dbo.fHtmEqToXyz(s.ra, s.dcl) x
        WHERE ABS(s.cx - x.x) > @tolerance OR ABS(s.cy - x.y) > @tolerance
           OR ABS(s.cz - x.z) > @tolerance;'
        ELSE N' SET @badXyz = NULL;' END + N'

        INSERT #r (part, check_name, subject, result, expected, detail)
        VALUES (''B'', ''htmid matches its own ra/dec'', @t,
                CASE WHEN @n = 0 THEN ''SKIP''
                     WHEN @nullish > 0 OR @zeroHtm = @n OR @badHtm > 0 THEN ''FAIL''
                     ELSE ''PASS'' END,
                @eh,
                CAST(@n AS varchar(10)) + '' sampled, '' + CAST(@badHtm AS varchar(10))
                + '' htmid mismatched, '' + CAST(ISNULL(@nullish,0) AS varchar(10)) + '' null, ''
                + CAST(ISNULL(@zeroHtm,0) AS varchar(10)) + '' zero'');

        INSERT #r (part, check_name, subject, result, expected, detail)
        VALUES (''B'', ''cx/cy/cz match their own ra/dec'', @t,
                CASE WHEN @hasXyz = 0 THEN ''SKIP''
                     WHEN @n = 0 THEN ''SKIP''
                     WHEN @badXyz > 0 THEN ''FAIL'' ELSE ''PASS'' END,
                @ex,
                CASE WHEN @hasXyz = 0 THEN ''table has no cx/cy/cz''
                     ELSE CAST(@n AS varchar(10)) + '' sampled, ''
                          + CAST(ISNULL(@badXyz,0) AS varchar(10)) + '' mismatched (tolerance ''
                          + CAST(@tolerance AS varchar(20)) + '')'' END);
        DROP TABLE #s;';

        EXEC sp_executesql @sql,
             N'@sample int, @t sysname, @eh varchar(10), @ex varchar(10), @hasXyz bit, @tolerance float',
             @sampleRows, @tbl, @expH, @expX, @hasXyz, @tol;
    END TRY
    BEGIN CATCH
        INSERT #r (part, check_name, subject, result, expected, detail)
        VALUES ('B', 'htmid matches its own ra/dec', @tbl, 'ERROR', @expH, LEFT(ERROR_MESSAGE(), 400));
    END CATCH

    ---------------------------------------------------------------------------
    -- C. End-to-end: probe the function at an object's own position and
    --    require the object back at essentially zero distance. This is what
    --    returned 0 rows for spAll before the fix.
    ---------------------------------------------------------------------------
    BEGIN TRY
        DECLARE @call nvarchar(400) = REPLACE(REPLACE(REPLACE(@tmpl,
                        '%RA%', '@pra'), '%DEC%', '@pdec'), '%R%', '@prad');
        SET @sql = N'
        DECLARE @pra float, @pdec float, @prad float = @radius;
        DECLARE @found int = 0, @tried int = 0, @worst float = NULL, @mind float;
        DECLARE c CURSOR LOCAL FAST_FORWARD FOR
            SELECT TOP (@probe) ' + QUOTENAME(@ra) + N', ' + @dec + N'
            FROM ' + QUOTENAME(@tbl) + N'
            WHERE ' + QUOTENAME(@ra) + N' IS NOT NULL AND ' + @dec + N' IS NOT NULL;
        OPEN c; FETCH NEXT FROM c INTO @pra, @pdec;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @tried += 1;
            ' + CASE WHEN @hasDist = 1
                     THEN N'SELECT @mind = MIN(distance) FROM ' + @call + N';'
                     -- no distance column: the best we can assert is that the
                     -- object comes back at all
                     ELSE N'SELECT @mind = CASE WHEN COUNT(*) > 0 THEN 0 END FROM ' + @call + N';'
                END + N'
            IF @mind IS NOT NULL
            BEGIN
                SET @found += 1;
                IF @worst IS NULL OR @mind > @worst SET @worst = @mind;
            END
            FETCH NEXT FROM c INTO @pra, @pdec;
        END
        CLOSE c; DEALLOCATE c;

        INSERT #r (part, check_name, subject, result, expected, detail)
        VALUES (''C'', ''cone search finds the object itself'', @t,
                CASE WHEN @tried = 0 THEN ''SKIP''
                     WHEN @found < @tried THEN ''FAIL''
                     WHEN @worst > 0.001 THEN ''FAIL''
                     ELSE ''PASS'' END,
                @e,
                CAST(@found AS varchar(10)) + ''/'' + CAST(@tried AS varchar(10))
                + '' probes found themselves'' + '
                + CASE WHEN @hasDist = 1
                       THEN N'''; worst reported distance ''
                            + ISNULL(CAST(CAST(@worst AS decimal(18,8)) AS varchar(30)), ''n/a'') + '' arcmin'''
                       ELSE N''' (function returns no distance column - presence only)'''
                  END + N');';

        EXEC sp_executesql @sql,
             N'@probe int, @radius float, @t sysname, @e varchar(10)',
             @probeRows, @probeArcmin, @tbl, @expP;
    END TRY
    BEGIN CATCH
        INSERT #r (part, check_name, subject, result, expected, detail)
        VALUES ('C', 'cone search finds the object itself', @tbl, 'ERROR', @expP, LEFT(ERROR_MESSAGE(), 400));
    END CATCH

    SET @seq += 1;
END

-------------------------------------------------------------------------------
--  REPORT
-------------------------------------------------------------------------------
PRINT '';
PRINT '--- detail -------------------------------------------------------------';
SELECT part, check_name, subject, result, expected,
       CASE WHEN result = expected                             THEN 'OK'
            WHEN expected = 'KNOWN-GAP' AND result = 'FAIL'    THEN 'OK'
            WHEN expected = 'DEAD'      AND result = 'ERROR'   THEN 'OK'
            WHEN expected IN ('KNOWN-GAP','DEAD') AND result = 'PASS'
                 THEN '>> NOW PASSES - update the driver'
            ELSE '>> UNEXPECTED' END AS verdict,
       detail
FROM #r ORDER BY part, check_name, subject;

PRINT '';
PRINT '--- summary ------------------------------------------------------------';
SELECT
    SUM(CASE WHEN result = expected
               OR (expected = 'KNOWN-GAP' AND result = 'FAIL')
               OR (expected = 'DEAD'      AND result = 'ERROR') THEN 1 ELSE 0 END) AS ok,
    SUM(CASE WHEN expected IN ('KNOWN-GAP','DEAD') AND result = 'PASS' THEN 1 ELSE 0 END) AS exemption_now_passes,
    SUM(CASE WHEN result = 'ERROR' AND expected <> 'DEAD' THEN 1 ELSE 0 END) AS errors,
    SUM(CASE WHEN expected = 'PASS' AND result = 'FAIL' THEN 1 ELSE 0 END) AS regressions,
    COUNT(*) AS total
FROM #r;

DECLARE @bad int = (SELECT COUNT(*) FROM #r
                    WHERE (expected = 'PASS' AND result NOT IN ('PASS','SKIP'))
                       OR (result = 'ERROR' AND expected <> 'DEAD')
                       OR (expected IN ('KNOWN-GAP','DEAD') AND result = 'PASS'));
IF @bad > 0
    RAISERROR('verify_spatial: %d unexpected result(s) - see the detail above', 16, 1, @bad);
ELSE
    PRINT 'verify_spatial: all checks as expected';

DROP TABLE #r;
GO
