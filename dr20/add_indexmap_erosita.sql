-------------------------------------------------------------------------------
--  add_indexmap_erosita.sql
--
--  Adds the missing IndexMap rows for the 7 eROSITA DR1 tables. All 7 are
--  loaded in BestDR20 with clustered indexes but had no IndexMap entry, so a
--  rebuild driven from IndexMap would have silently dropped those indexes --
--  the same gap as the allspec NCIs in TODO item 2.
--
--  fieldList is taken from the live clustered index keys:
--
--    efeds_c001_hard_pointsources_ctp_redshift_v17  ero_id_src   (PK)
--    efeds_c001_hard_v7_5                           id_src       (PK)
--    efeds_c001_main_pointsources_ctp_redshift_v17  ero_id_src   (PK)
--    efeds_c001_main_v7_4                           id_src       (PK)
--    erass1_hard_v1_0                               uid          (PK)
--    erass1_main_v1_2                               uid          (PK)
--    salvato_etal2025_dr1_ls10                      uid          (CI, not a PK)
--
--  salvato_etal2025_dr1_ls10 gets code='K' like the rest even though its
--  clustered index is not a primary key. That matches the existing convention
--  -- every ci_* clustered index built by run_vac_load.py is recorded as a
--  'K' row, and 'K' is what the loader reads to find the clustering key.
--
--  compression is recorded as 'page' to match every sibling VAC row. NOTE that
--  all 7 are currently uncompressed on disk; see the note at the end.
--
--  Safe to re-run: each row is inserted only if absent, and only if the table
--  actually exists.
--
--  Companion change: the same 7 rows were added to schema/sql/IndexMap.sql.
--
--  Suzanne Werner, 2026-07-28
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

DECLARE @new TABLE (tableName varchar(128) PRIMARY KEY, fieldList varchar(256));
INSERT @new (tableName, fieldList) VALUES
    ('efeds_c001_hard_pointsources_ctp_redshift_v17', 'ero_id_src'),
    ('efeds_c001_hard_v7_5',                          'id_src'),
    ('efeds_c001_main_pointsources_ctp_redshift_v17', 'ero_id_src'),
    ('efeds_c001_main_v7_4',                          'id_src'),
    ('erass1_hard_v1_0',                              'uid'),
    ('erass1_main_v1_2',                              'uid'),
    ('salvato_etal2025_dr1_ls10',                     'uid');

-- Refuse to document a key column that is not the real clustered key.
IF EXISTS (
    SELECT 1 FROM @new n
    WHERE NOT EXISTS (
        SELECT 1
        FROM sys.indexes i
        JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
        WHERE i.object_id = OBJECT_ID(n.tableName)
          AND i.type = 1                       -- clustered
          AND ic.is_included_column = 0
          AND ic.key_ordinal = 1
          AND COL_NAME(ic.object_id, ic.column_id) = n.fieldList COLLATE latin1_general_ci_as))
BEGIN
    SELECT n.tableName, n.fieldList AS claimed_key
    FROM @new n
    WHERE NOT EXISTS (
        SELECT 1
        FROM sys.indexes i
        JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
        WHERE i.object_id = OBJECT_ID(n.tableName)
          AND i.type = 1 AND ic.is_included_column = 0 AND ic.key_ordinal = 1
          AND COL_NAME(ic.object_id, ic.column_id) = n.fieldList COLLATE latin1_general_ci_as);
    RAISERROR('fieldList does not match the live clustered key - nothing inserted',16,1);
    RETURN;
END

BEGIN TRANSACTION;

INSERT IndexMap (code, type, tableName, fieldList, foreignKey, indexgroup, compression, filegroup, common)
SELECT 'K', 'primary key', n.tableName, n.fieldList, '', 'SPECTRO', 'page', 'SPEC', 0
FROM @new n
WHERE NOT EXISTS (SELECT 1 FROM IndexMap im
                   WHERE im.tableName = n.tableName COLLATE latin1_general_ci_as);

PRINT CAST(@@ROWCOUNT AS varchar(10)) + ' IndexMap row(s) inserted';

COMMIT;
GO

-- Result
SELECT im.code, im.tableName, im.fieldList, im.compression, im.filegroup
FROM IndexMap im
WHERE im.tableName IN (
    'efeds_c001_hard_pointsources_ctp_redshift_v17','efeds_c001_hard_v7_5',
    'efeds_c001_main_pointsources_ctp_redshift_v17','efeds_c001_main_v7_4',
    'erass1_hard_v1_0','erass1_main_v1_2','salvato_etal2025_dr1_ls10')
ORDER BY im.tableName;
GO

-- These 7 are recorded as 'page' but are uncompressed on disk. Two are big
-- enough to be worth acting on -- erass1_main_v1_2 (930,203 rows) and
-- salvato_etal2025_dr1_ls10 (966,194 rows). Rebuilding is a separate decision:
--
--   ALTER INDEX pk_erass1_main_v1_2 ON erass1_main_v1_2
--       REBUILD WITH (DATA_COMPRESSION = PAGE);
--   ALTER INDEX ci_salvato_etal2025_dr1_ls10_uid ON salvato_etal2025_dr1_ls10
--       REBUILD WITH (DATA_COMPRESSION = PAGE);
GO
