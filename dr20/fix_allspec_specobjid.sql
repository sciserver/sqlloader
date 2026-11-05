-------------------------------------------------------------------------------
--  fix_allspec_specobjid.sql
--
--  Changes allspec.specobjid from varchar(29) to numeric(30,0), nullable.
--
--  WHY numeric(30) AND NOT numeric(20):
--  allspec.specobjid holds a union of two id schemes -
--      5,810,967 legacy values of <= 20 digits, which match SpecObjAll
--                                               (itself numeric(20,0))
--     10,766,741 SDSS-V values of 25-29 digits,  which match spAll
--                                               (itself numeric(30,0))
--  numeric(20) would overflow on 10,766,741 rows, 65% of the non-null values.
--  numeric(30,0) matches spAll / spAll_epoch / spAll_allepoch, and is already
--  what fGetNearbyAllspecXYZ declares in its RETURNS clause - so that function
--  is doing this conversion on every row today.
--
--  Verified on the live data before writing this: 27,671,504 rows,
--  11,093,796 NULL, 0 empty strings, 0 unconvertible, 0 longer than 29 digits.
--  The column stays NULLable because a third of the rows are NULL.
--
--  ALTER in place rather than a reload from BESTTEST, because BESTTEST's own
--  allspec.specobjid is ALSO varchar(29) - a reload would not fix anything
--  unless SpectroTables.sql were corrected first - and because allspec's 6
--  nonclustered indexes and ix_allspec_htmid are absent from IndexMap, so an
--  IndexMap-driven reload would silently drop them.
--
--  Only ix_allspec_specobjid is touched. The clustered index, the other 6 NCIs
--  and the htmid/cx/cy/cz values are all left alone.
--
--  Idempotent: re-running against an already-converted column does nothing.
--
--  Run with:  sqlcmd -S <server> -b -i fix_allspec_specobjid.sql
--
--  Suzanne Werner, 2026-07-29
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

-- One batch from here down. RETURN only exits the batch it appears in, so a GO
-- between the guards and the work below would let the work run after a refusal.

DECLARE @type sysname, @before_sum bigint, @before_rows bigint, @before_nonnull bigint;

SELECT @type = ty.name
FROM sys.columns c JOIN sys.types ty ON ty.user_type_id = c.user_type_id
WHERE c.object_id = OBJECT_ID('allspec') AND c.name = 'specobjid';

IF @type IS NULL
BEGIN
    RAISERROR('allspec.specobjid not found - wrong database? nothing changed',16,1);
    RETURN;
END

IF @type = 'numeric'
BEGIN
    PRINT 'allspec.specobjid is already numeric - nothing to do';
    RETURN;
END

IF @type <> 'varchar'
BEGIN
    RAISERROR('allspec.specobjid is an unexpected type - nothing changed',16,1);
    RETURN;
END

-- Refuse unless every value survives the conversion.
IF EXISTS (SELECT 1 FROM allspec
           WHERE specobjid IS NOT NULL
             AND (TRY_CONVERT(numeric(30,0), specobjid) IS NULL OR LEN(specobjid) > 30))
BEGIN
    RAISERROR('allspec.specobjid has values that will not convert - nothing changed',16,1);
    RETURN;
END

-- Fingerprint the values as numbers, to prove afterwards that none changed.
SELECT @before_rows    = COUNT(*),
       @before_nonnull = COUNT(specobjid),
       @before_sum     = SUM(CAST(CHECKSUM(TRY_CONVERT(numeric(30,0), specobjid)) AS bigint))
FROM allspec;

PRINT 'before: ' + CAST(@before_rows AS varchar(20)) + ' rows, '
    + CAST(@before_nonnull AS varchar(20)) + ' non-null, fingerprint '
    + CAST(@before_sum AS varchar(30));

-- 1. the index has specobjid as its key, so it blocks the ALTER
DROP INDEX ix_allspec_specobjid ON allspec;
PRINT 'ix_allspec_specobjid dropped';

-- 2. the conversion itself - size-of-data, ~27.7M rows
ALTER TABLE allspec ALTER COLUMN specobjid numeric(30,0) NULL;
PRINT 'specobjid converted to numeric(30,0)';

-- 3. rebuild the index exactly as it was: PAGE compression, on SPEC,
--    default fill factor, no included columns
CREATE NONCLUSTERED INDEX ix_allspec_specobjid ON allspec (specobjid)
    WITH (DATA_COMPRESSION = PAGE, SORT_IN_TEMPDB = ON) ON SPEC;
PRINT 'ix_allspec_specobjid recreated';

-- 4. prove nothing moved
DECLARE @after_sum bigint, @after_rows bigint, @after_nonnull bigint;
SELECT @after_rows    = COUNT(*),
       @after_nonnull = COUNT(specobjid),
       @after_sum     = SUM(CAST(CHECKSUM(specobjid) AS bigint))
FROM allspec;

IF @after_rows <> @before_rows OR @after_nonnull <> @before_nonnull OR @after_sum <> @before_sum
    RAISERROR('allspec: row count or value fingerprint CHANGED - investigate before shipping',16,1);
ELSE
    PRINT 'after:  ' + CAST(@after_rows AS varchar(20)) + ' rows, '
        + CAST(@after_nonnull AS varchar(20)) + ' non-null, fingerprint '
        + CAST(@after_sum AS varchar(30)) + '  - unchanged';
GO

PRINT '=== final state ===';
SELECT ty.name AS type, c.precision, c.scale, c.is_nullable
FROM sys.columns c JOIN sys.types ty ON ty.user_type_id = c.user_type_id
WHERE c.object_id = OBJECT_ID('allspec') AND c.name = 'specobjid';

SELECT i.name, i.type_desc, p.data_compression_desc, ds.name AS filegroup
FROM sys.indexes i
JOIN sys.partitions p ON p.object_id=i.object_id AND p.index_id=i.index_id
JOIN sys.data_spaces ds ON ds.data_space_id=i.data_space_id
WHERE i.object_id=OBJECT_ID('allspec') AND i.type>0
ORDER BY i.index_id;
GO
