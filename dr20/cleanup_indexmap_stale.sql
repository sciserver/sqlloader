-------------------------------------------------------------------------------
--  cleanup_indexmap_stale.sql
--
--  Removes IndexMap rows that name a table which does not exist in BestDR20.
--  A rebuild driven from IndexMap would otherwise expect a table that will
--  never be created.
--
--  Three rows as of 2026-07-28, all code='K' (primary key):
--
--    mos_legacy_catalog_catalogid   empty in minidb_dr20 / BESTTEST / TEST_EBOS1
--    mos_sdss_id_to_catalog_full    empty in minidb_dr20 / BESTTEST / TEST_EBOS1
--    the_cannon_apogee_star         0 rows in BESTTEST, no table anywhere
--
--  The two mos_ tables were dropped in the minidb_dr20 -> minidb_dr20_v2
--  rebuild (185 tables -> 171), which is the set BestDR20 was copied from.
--  Both are empty in every source database, which is the established DR20
--  signal for "not shipping". the_cannon_apogee_star has the same profile and
--  is TODO item 4.
--
--  Safe to re-run. Each row is deleted only if its table genuinely does not
--  exist at run time; if one has since been created, the row is kept and
--  reported rather than removed.
--
--  NOTE: schema/sql/IndexMap.sql carries the same three rows (lines 611, 727,
--  761). They are commented out there in the same change, otherwise a rebuild
--  from the source file puts them straight back.
--
--  Suzanne Werner, 2026-07-28
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

DECLARE @stale TABLE (tableName varchar(128) PRIMARY KEY);
INSERT @stale (tableName) VALUES
    ('mos_legacy_catalog_catalogid'),
    ('mos_sdss_id_to_catalog_full'),
    ('the_cannon_apogee_star');

-- What is there now, and does the object actually exist?
SELECT im.indexmapid,
       im.code,
       im.tableName,
       im.fieldList,
       CASE WHEN EXISTS (SELECT 1 FROM sys.tables t
                          WHERE t.name = im.tableName COLLATE latin1_general_ci_as)
              OR EXISTS (SELECT 1 FROM sys.views v
                          WHERE v.name = im.tableName COLLATE latin1_general_ci_as)
            THEN 'EXISTS - will be kept'
            ELSE 'missing - will be deleted'
       END AS disposition
FROM IndexMap im
JOIN @stale s ON s.tableName = im.tableName COLLATE latin1_general_ci_as
ORDER BY im.tableName, im.code;

BEGIN TRANSACTION;

DELETE im
FROM IndexMap im
JOIN @stale s ON s.tableName = im.tableName COLLATE latin1_general_ci_as
WHERE NOT EXISTS (SELECT 1 FROM sys.tables t
                   WHERE t.name = im.tableName COLLATE latin1_general_ci_as)
  AND NOT EXISTS (SELECT 1 FROM sys.views v
                   WHERE v.name = im.tableName COLLATE latin1_general_ci_as);

PRINT CAST(@@ROWCOUNT AS varchar(10)) + ' stale IndexMap row(s) deleted';

-- Anything left among the three means the object exists after all, so the row
-- was correctly kept. Report it rather than failing -- keeping is the safe
-- outcome, but it should not pass unnoticed.
IF EXISTS (SELECT 1 FROM IndexMap im
           JOIN @stale s ON s.tableName = im.tableName COLLATE latin1_general_ci_as)
BEGIN
    PRINT 'WARNING: rows kept because the object now exists --';
    SELECT im.indexmapid, im.code, im.tableName
    FROM IndexMap im
    JOIN @stale s ON s.tableName = im.tableName COLLATE latin1_general_ci_as;
END

COMMIT;
GO

-- Sweep for any OTHER IndexMap row naming a missing object, so future strays
-- surface here rather than during a rebuild.
SELECT DISTINCT im.tableName AS remaining_stale_tableName
FROM IndexMap im
WHERE NOT EXISTS (SELECT 1 FROM sys.tables t
                   WHERE t.name = im.tableName COLLATE latin1_general_ci_as)
  AND NOT EXISTS (SELECT 1 FROM sys.views v
                   WHERE v.name = im.tableName COLLATE latin1_general_ci_as)
ORDER BY im.tableName;
GO
