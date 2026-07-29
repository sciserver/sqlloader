-------------------------------------------------------------------------------
--  fix_nearest_orderby.sql
--
--  Three fGetNearest*Eq functions returned an ARBITRARY object from the cone
--  rather than the nearest one:
--
--      fGetNearestAllspecEq
--      fGetNearestApogeeDrpAllstarEq
--      fGetNearestSpAllEq
--
--  Each did
--      SELECT top 1 * FROM dbo.fGetNearby<X>XYZ(@nx,@ny,@nz,@r)
--  with NO ORDER BY. Their XYZ counterparts all have `ORDER BY distance ASC`,
--  and so do the other fGetNearest* functions.
--
--  It is not enough that fGetNearby<X>XYZ populates its table variable in
--  distance order: inserting into a table variable in a given order does not
--  guarantee reading it back in that order. Without ORDER BY the engine is free
--  to return any qualifying row, and is more likely to under parallelism or
--  after an index change. So this is a real defect, not a theoretical one.
--
--  Found 2026-07-29 by dr20/verify_spatial.sql check A2. Same three families as
--  the radians bug fixed 2026-07-28.
--
--  HOW THIS WORKS
--  Rather than retype three long RETURNS TABLE clauses - which is where a
--  transcription error would silently change a column type - each function is
--  rebuilt from its own live definition with one targeted substitution. The
--  script refuses unless the substitution matches exactly once, and verifies
--  the result afterwards.
--
--  Idempotent: a function that already has ORDER BY is skipped.
--
--  Run with:  sqlcmd -S <server> -b -i fix_nearest_orderby.sql
--
--  Suzanne Werner, 2026-07-29
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

DECLARE @targets TABLE (fn sysname PRIMARY KEY, inner_fn sysname);
INSERT @targets (fn, inner_fn) VALUES
    ('fGetNearestAllspecEq',           'fGetNearbyAllspecXYZ'),
    ('fGetNearestApogeeDrpAllstarEq',  'fGetNearbyApogeeDrpAllstarXYZ'),
    ('fGetNearestSpAllEq',             'fGetNearbySpAllXYZ');

DECLARE @fn sysname, @inner sysname, @def nvarchar(max), @new nvarchar(max),
        @find nvarchar(400), @repl nvarchar(400), @done int = 0, @skipped int = 0;

DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT fn, inner_fn FROM @targets;
OPEN c;
FETCH NEXT FROM c INTO @fn, @inner;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @def = m.definition
    FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
    WHERE o.name = @fn;

    IF @def IS NULL
    BEGIN
        RAISERROR('%s does not exist - nothing changed', 16, 1, @fn);
        RETURN;
    END

    IF @def LIKE '%ORDER BY%'
    BEGIN
        PRINT @fn + ': already has ORDER BY, skipped';
        SET @skipped += 1;
        FETCH NEXT FROM c INTO @fn, @inner;
        CONTINUE;
    END

    SET @find = 'dbo.' + @inner + '(@nx,@ny,@nz,@r)';
    SET @repl = @find + ' ORDER BY distance ASC';

    -- The call must appear exactly once, or the substitution is ambiguous.
    IF (LEN(@def) - LEN(REPLACE(@def, @find, ''))) / LEN(@find) <> 1
    BEGIN
        RAISERROR('%s: expected exactly one call to the inner function - nothing changed', 16, 1, @fn);
        RETURN;
    END

    SET @new = REPLACE(@def, @find, @repl);

    -- Turn the stored CREATE into an ALTER, preserving permissions and
    -- dependencies. Exactly one occurrence, or refuse.
    IF (LEN(@new) - LEN(REPLACE(@new, 'CREATE FUNCTION', ''))) / LEN('CREATE FUNCTION') <> 1
    BEGIN
        RAISERROR('%s: could not locate a single CREATE FUNCTION header - nothing changed', 16, 1, @fn);
        RETURN;
    END
    SET @new = REPLACE(@new, 'CREATE FUNCTION', 'ALTER FUNCTION');

    EXEC sp_executesql @new;
    PRINT @fn + ': ORDER BY distance ASC added';
    SET @done += 1;

    FETCH NEXT FROM c INTO @fn, @inner;
END
CLOSE c; DEALLOCATE c;

PRINT '';
PRINT CAST(@done AS varchar(10)) + ' altered, ' + CAST(@skipped AS varchar(10)) + ' already correct';
GO

-- Verify: no fGetNearest* may take TOP 1 without ordering.
DECLARE @bad int;
SELECT @bad = COUNT(*)
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE o.name LIKE 'fGetNearest%'
  AND m.definition LIKE '%top 1%'
  AND m.definition NOT LIKE '%ORDER BY%';

IF @bad > 0
BEGIN
    SELECT o.name AS still_unordered
    FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
    WHERE o.name LIKE 'fGetNearest%'
      AND m.definition LIKE '%top 1%' AND m.definition NOT LIKE '%ORDER BY%';
    RAISERROR('%d fGetNearest* function(s) still take TOP 1 without ORDER BY', 16, 1, @bad);
END
ELSE
    PRINT 'verified: every fGetNearest* taking TOP 1 now orders by distance';
GO
