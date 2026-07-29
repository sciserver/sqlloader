-------------------------------------------------------------------------------
--  add_indexmap_allspec_nci.sql
--
--  Adds the 7 missing IndexMap rows for allspec's nonclustered indexes.
--  TODO item 2.
--
--  allspec had only its code='K' row (allspec_id). All 7 NCIs exist on disk but
--  were undocumented, so a rebuild driven from IndexMap would silently drop
--  them -- the same gap the 7 eROSITA tables had in add_indexmap_erosita.sql.
--
--  fieldList is taken from the live nonclustered index keys:
--
--    ix_allspec_specobjid          specobjid
--    ix_allspec_htmid              htmid
--    ix_allspec_apogee_id          apogee_id
--    ix_allspec_apstar_id          apstar_id
--    ix_allspec_mangaid            mangaid
--    ix_allspec_sdssid             sdss_id
--    ix_allspec_mjd_fiberid_plate  mjd,fiberid,plate_or_fps_field
--
--  Note the last two index NAMES do not follow from their field lists
--  (ix_allspec_sdssid keys sdss_id; ix_allspec_mjd_fiberid_plate keys
--  plate_or_fps_field). fieldList records what the index actually keys on,
--  which is what a rebuild needs. See the note at the end about what this does
--  to spCheckDBIndexes.
--
--  compression is recorded as 'page' on all 7, matching every sibling SPECTRO
--  row and the 1M-row convention. NOTE that ix_allspec_htmid is currently
--  uncompressed on disk while the other six are PAGE; see the note at the end.
--
--  Safe to re-run: each row is inserted only if an identical one is absent.
--
--  Companion change: the same 7 rows were added to schema/sql/IndexMap.sql.
--
--  Run with:  sqlcmd -S <server> -b -i add_indexmap_allspec_nci.sql
--
--  Suzanne Werner, 2026-07-29
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

DECLARE @new TABLE (fieldList varchar(1000) PRIMARY KEY);
INSERT @new (fieldList) VALUES
    ('specobjid'),
    ('htmid'),
    ('apogee_id'),
    ('apstar_id'),
    ('mangaid'),
    ('sdss_id'),
    ('mjd,fiberid,plate_or_fps_field');

-- The live nonclustered key lists, comma-joined in key order.
DECLARE @live TABLE (indexName sysname, fieldList varchar(1000));
INSERT @live (indexName, fieldList)
SELECT i.name,
       STUFF((SELECT ',' + c.name
              FROM sys.index_columns ic
              JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
              WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id
                AND ic.is_included_column = 0
              ORDER BY ic.key_ordinal
              FOR XML PATH('')), 1, 1, '')
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('allspec') AND i.type = 2;   -- nonclustered

-- Refuse to document an index that does not exist as described.
IF EXISTS (SELECT 1 FROM @new n
           WHERE NOT EXISTS (SELECT 1 FROM @live l
                             WHERE l.fieldList = n.fieldList COLLATE latin1_general_ci_as))
BEGIN
    SELECT n.fieldList AS claimed_but_not_on_disk FROM @new n
    WHERE NOT EXISTS (SELECT 1 FROM @live l
                      WHERE l.fieldList = n.fieldList COLLATE latin1_general_ci_as);
    RAISERROR('fieldList does not match any live allspec nonclustered index - nothing inserted',16,1);
    RETURN;
END

-- Refuse if allspec has NCIs we are not documenting - the point is to close the
-- gap completely, not partially.
IF EXISTS (SELECT 1 FROM @live l
           WHERE NOT EXISTS (SELECT 1 FROM @new n
                             WHERE n.fieldList = l.fieldList COLLATE latin1_general_ci_as))
BEGIN
    SELECT l.indexName, l.fieldList AS on_disk_but_undocumented FROM @live l
    WHERE NOT EXISTS (SELECT 1 FROM @new n
                      WHERE n.fieldList = l.fieldList COLLATE latin1_general_ci_as);
    RAISERROR('allspec has nonclustered indexes not covered by this script - nothing inserted',16,1);
    RETURN;
END

BEGIN TRANSACTION;

INSERT IndexMap (code, type, tableName, fieldList, foreignKey, indexgroup, compression, filegroup, common)
SELECT 'I', 'index', 'allspec', n.fieldList, '', 'SPECTRO', 'page', 'SPEC', 0
FROM @new n
WHERE NOT EXISTS (SELECT 1 FROM IndexMap im
                  WHERE im.tableName = 'allspec' COLLATE latin1_general_ci_as
                    AND im.code = 'I'
                    AND im.fieldList = n.fieldList COLLATE latin1_general_ci_as);

PRINT CAST(@@ROWCOUNT AS varchar(10)) + ' IndexMap row(s) inserted (expected 7 on a first run)';

COMMIT;
GO

-- Result: 1 K row + 7 I rows, and every index on disk accounted for.
SELECT im.code, im.tableName, im.fieldList, im.compression, im.filegroup
FROM IndexMap im WHERE im.tableName = 'allspec'
ORDER BY im.code, im.fieldList;
GO

-------------------------------------------------------------------------------
--  Two follow-ups, both deliberately NOT done here.
--
--  1. ix_allspec_htmid is uncompressed on disk while allspec's other six NCIs
--     are PAGE. It is a bigint index over 27.7M rows, so this looks like an
--     oversight rather than intent. IndexMap now records the intended 'page'.
--     To make disk agree:
--
--       ALTER INDEX ix_allspec_htmid ON allspec
--           REBUILD WITH (DATA_COMPRESSION = PAGE, SORT_IN_TEMPDB = ON);
--
--  2. These rows will ADD discrepancies to spCheckDBIndexes, which is expected
--     and not a regression. That check builds an expected index name from
--     tableName + fieldList via dbo.fIndexName, so it expects
--     ix_allspec_sdss_id (real name: ix_allspec_sdssid) and
--     ix_allspec_mjd_fiberid_plate_or_fps_field (real name:
--     ix_allspec_mjd_fiberid_plate, and the expected name is 41 characters,
--     past fIndexName's 32-char truncation anyway). The indexes are correct;
--     the check's name derivation is what is wrong. Same effect as the +7 from
--     add_indexmap_erosita.sql. See the spCheckDBIndexes section of
--     session_summary_20260728.md.
-------------------------------------------------------------------------------
