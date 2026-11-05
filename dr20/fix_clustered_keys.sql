-------------------------------------------------------------------------------
--  fix_clustered_keys.sql
--
--  Two clustered-key defects found by checking the 15 tables that report a
--  'PK' column in spCheckDBColumns against what the database actually has.
--
--  1. snow_white_boss_visit was a HEAP on PRIMARY, uncompressed, with no
--     indexes at all -- while its siblings snow_white_boss_star,
--     slam_boss_star and corv_boss_visit are all clustered on spectrum_PK,
--     on SPEC, PAGE compressed. IndexMap says spectrum_PK / SPEC / page.
--     Same defect class as the 10 APOGEE heaps moved on 2026-07-27; this one
--     is an astra table so that sweep did not cover it.
--
--  2. mwm_targets was clustered on PK, an opaque sequential row number, while
--     IndexMap claimed spectrum_PK -- a column that does not exist on this
--     table. schema/sql/IndexMap.sql already says sdss_id, which is the real
--     SDSS identifier, is bigint NOT NULL and is unique across all 2,086,349
--     rows. Re-clustering on sdss_id makes the table, IndexMap and the schema
--     file agree for the first time.
--
--  Both key columns are already NOT NULL and verified unique, so both get a
--  real PRIMARY KEY CLUSTERED constraint named pk_<table>_<fieldlist>, which
--  is the convention the other astra tables use.
--
--  Re-runnable: each step is skipped if it has already been applied, and every
--  precondition is re-checked at run time rather than trusted from this
--  comment.
--
--  Suzanne Werner, 2026-07-28
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

-------------------------------------------------------------------------------
-- 1. snow_white_boss_visit : heap on PRIMARY -> PK CLUSTERED on SPEC, PAGE
-------------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.indexes
           WHERE object_id = OBJECT_ID('snow_white_boss_visit') AND type = 1)
    PRINT 'snow_white_boss_visit: already clustered, skipped';
ELSE IF EXISTS (SELECT spectrum_pk FROM snow_white_boss_visit
                GROUP BY spectrum_pk HAVING COUNT(*) > 1)
    RAISERROR('snow_white_boss_visit: spectrum_pk is not unique - not indexed',16,1);
ELSE
BEGIN
    ALTER TABLE snow_white_boss_visit
        ADD CONSTRAINT pk_snow_white_boss_visit_spectrum_pk
        PRIMARY KEY CLUSTERED (spectrum_pk)
        WITH (DATA_COMPRESSION = PAGE, SORT_IN_TEMPDB = ON)
        ON [SPEC];
    PRINT 'snow_white_boss_visit: created pk_snow_white_boss_visit_spectrum_pk on SPEC';
END
GO

-------------------------------------------------------------------------------
-- 2. mwm_targets : clustered on PK -> PK CLUSTERED on sdss_id, same filegroup
-------------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.indexes
           WHERE object_id = OBJECT_ID('mwm_targets')
             AND name = 'pk_mwm_targets_sdss_id')
    PRINT 'mwm_targets: already keyed on sdss_id, skipped';
ELSE IF EXISTS (SELECT sdss_id FROM mwm_targets GROUP BY sdss_id HAVING COUNT(*) > 1)
    RAISERROR('mwm_targets: sdss_id is not unique - key not changed',16,1);
ELSE
BEGIN
    -- Dropping the clustered index leaves a heap; the new key is created
    -- immediately after, in the same transaction, so a failure rolls back to
    -- the original clustered index rather than stranding a heap.
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID('mwm_targets') AND name = 'pk_mwm_targets_PK')
        DROP INDEX pk_mwm_targets_PK ON mwm_targets;

    ALTER TABLE mwm_targets
        ADD CONSTRAINT pk_mwm_targets_sdss_id
        PRIMARY KEY CLUSTERED (sdss_id)
        WITH (DATA_COMPRESSION = PAGE, SORT_IN_TEMPDB = ON)
        ON [SPEC];

    COMMIT;
    PRINT 'mwm_targets: re-keyed on sdss_id as pk_mwm_targets_sdss_id';
END
GO

-------------------------------------------------------------------------------
-- 3. IndexMap: mwm_targets was recorded as spectrum_PK, a non-existent column
-------------------------------------------------------------------------------
UPDATE IndexMap
   SET fieldList = 'sdss_id'
 WHERE tableName = 'mwm_targets'
   AND fieldList <> 'sdss_id';
PRINT CAST(@@ROWCOUNT AS varchar(10)) + ' IndexMap row(s) corrected for mwm_targets';
GO

-------------------------------------------------------------------------------
-- Result
-------------------------------------------------------------------------------
SELECT t.name AS [table],
       fg.name AS filegroup,
       i.name AS [index],
       i.type_desc,
       i.is_primary_key,
       i.is_unique,
       (SELECT TOP 1 p.data_compression_desc FROM sys.partitions p
         WHERE p.object_id = i.object_id AND p.index_id = i.index_id) AS compression,
       (SELECT im.fieldList FROM IndexMap im
         WHERE im.tableName = t.name COLLATE latin1_general_ci_as) AS indexmap_says
FROM sys.tables t
JOIN sys.indexes i ON i.object_id = t.object_id AND i.type = 1
JOIN sys.filegroups fg ON fg.data_space_id = i.data_space_id
WHERE t.name IN ('snow_white_boss_visit', 'mwm_targets');
GO
