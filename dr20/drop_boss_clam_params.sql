-------------------------------------------------------------------------------
--  drop_boss_clam_params.sql
--
--  Removes the boss_clam_params VAC table and all of its metadata.
--
--  The VAC owner confirmed 2026-07-29 that the product is no longer needed for
--  DR20. Its sibling boss_clam_lite IS still shipping and is untouched here.
--
--  At the time of writing the table held 1,708,214 rows / 1,674.09 MB on SPEC,
--  with a clustered index ci_boss_clam_params_PK and a nonclustered
--  ix_boss_clam_params_htmid; both go with the table. No foreign key references
--  it and it references none, so the DROP is clean.
--
--  Metadata removed: DBObjects 1 row, DBColumns 169 rows, IndexMap 1 row.
--  DBViewCols and Inventory had no rows for it.
--
--  Children are deleted before parents so this works whether or not the
--  DBObjects foreign keys have been recreated (see recreate_metadata_fks.sql).
--
--  Idempotent - safe to re-run, and safe to run on a server where the table
--  was already removed.
--
--  Run with:  sqlcmd -S <server> -b -i drop_boss_clam_params.sql
--
--  Suzanne Werner, 2026-07-29
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

-- One batch from here down. RETURN only exits the batch it appears in, so a GO
-- between the guard and the work below would let the work run after a refusal.

-- Refuse if anything still points at the table.
IF EXISTS (SELECT 1 FROM sys.foreign_keys
           WHERE referenced_object_id = OBJECT_ID('boss_clam_params'))
BEGIN
    RAISERROR('boss_clam_params is still referenced by a foreign key - nothing changed',16,1);
    RETURN;
END

-- Guard against the obvious typo: never touch the sibling that is still shipping.
IF OBJECT_ID('boss_clam_lite') IS NULL
BEGIN
    RAISERROR('boss_clam_lite is missing - wrong database? nothing changed',16,1);
    RETURN;
END

PRINT 'before:';
SELECT CASE WHEN OBJECT_ID('boss_clam_params') IS NULL THEN 'table absent'
            ELSE 'table present' END AS tbl,
       (SELECT COUNT(*) FROM DBObjects WHERE name      = 'boss_clam_params') AS dbobjects,
       (SELECT COUNT(*) FROM DBColumns WHERE tableName = 'boss_clam_params') AS dbcolumns,
       (SELECT COUNT(*) FROM IndexMap  WHERE tableName = 'boss_clam_params') AS indexmap;

BEGIN TRANSACTION;

DELETE FROM DBColumns  WHERE tableName = 'boss_clam_params';
PRINT CAST(@@ROWCOUNT AS varchar(20)) + ' DBColumns rows deleted (expected 169)';

DELETE FROM DBViewCols WHERE viewName  = 'boss_clam_params';
PRINT CAST(@@ROWCOUNT AS varchar(20)) + ' DBViewCols rows deleted (expected 0)';

DELETE FROM IndexMap   WHERE tableName = 'boss_clam_params';
PRINT CAST(@@ROWCOUNT AS varchar(20)) + ' IndexMap rows deleted (expected 1)';

DELETE FROM Inventory  WHERE name      = 'boss_clam_params';
PRINT CAST(@@ROWCOUNT AS varchar(20)) + ' Inventory rows deleted (expected 0)';

DELETE FROM DBObjects  WHERE name      = 'boss_clam_params';
PRINT CAST(@@ROWCOUNT AS varchar(20)) + ' DBObjects rows deleted (expected 1)';

COMMIT;

-- Outside the transaction: DROP TABLE releases 1.6 GB and does not want to be
-- rolled back alongside the metadata delete.
IF OBJECT_ID('boss_clam_params') IS NOT NULL
BEGIN
    DROP TABLE boss_clam_params;
    PRINT 'boss_clam_params dropped';
END
ELSE
    PRINT 'boss_clam_params already absent - nothing dropped';

PRINT 'after (all zeros expected, and boss_clam_lite untouched):';
SELECT CASE WHEN OBJECT_ID('boss_clam_params') IS NULL THEN 'absent' ELSE 'STILL PRESENT' END AS tbl,
       (SELECT COUNT(*) FROM DBObjects WHERE name      = 'boss_clam_params') AS dbobjects,
       (SELECT COUNT(*) FROM DBColumns WHERE tableName = 'boss_clam_params') AS dbcolumns,
       (SELECT COUNT(*) FROM IndexMap  WHERE tableName = 'boss_clam_params') AS indexmap,
       (SELECT COUNT(*) FROM DBColumns WHERE tableName = 'boss_clam_lite')   AS lite_dbcolumns_still_64;
GO
