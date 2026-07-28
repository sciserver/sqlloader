-------------------------------------------------------------------------------
--  drop_metadata_fks.sql
--
--  Drops the three foreign keys that reference DBObjects, so that the
--  metadata load scripts (loaddbobjects.sql / loaddbcolumns.sql /
--  loaddbviewcols.sql) can run.
--
--  Why dropping, not disabling: SQL Server refuses TRUNCATE TABLE on any
--  table referenced by a FOREIGN KEY constraint, and it checks that the
--  constraint EXISTS, not that it is enabled. ALTER TABLE ... NOCHECK
--  CONSTRAINT does not help -- verified: TRUNCATE fails with error 4712
--  either way. loaddbobjects.sql truncates DBObjects, so all three must go.
--
--  All three are currently disabled and untrusted, so they enforce nothing
--  at the moment; dropping them changes no behaviour beyond unblocking the
--  load.
--
--  Run recreate_metadata_fks.sql AFTER the metadata load has completed.
--
--  Suzanne Werner, 2026-07-28
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
GO

IF OBJECT_ID('fk_DBColumns_tablename_DBObjects', 'F') IS NOT NULL
BEGIN
    ALTER TABLE DBColumns DROP CONSTRAINT fk_DBColumns_tablename_DBObjects;
    PRINT 'dropped fk_DBColumns_tablename_DBObjects';
END
ELSE
    PRINT 'fk_DBColumns_tablename_DBObjects already absent';
GO

IF OBJECT_ID('fk_DBViewCols_viewname_DBObjects', 'F') IS NOT NULL
BEGIN
    ALTER TABLE DBViewCols DROP CONSTRAINT fk_DBViewCols_viewname_DBObjects;
    PRINT 'dropped fk_DBViewCols_viewname_DBObjects';
END
ELSE
    PRINT 'fk_DBViewCols_viewname_DBObjects already absent';
GO

IF OBJECT_ID('fk_Inventory_name_DBObjects_name', 'F') IS NOT NULL
BEGIN
    ALTER TABLE Inventory DROP CONSTRAINT fk_Inventory_name_DBObjects_name;
    PRINT 'dropped fk_Inventory_name_DBObjects_name';
END
ELSE
    PRINT 'fk_Inventory_name_DBObjects_name already absent';
GO

-- Confirm nothing else references DBObjects, or TRUNCATE will still fail.
IF EXISTS (SELECT 1 FROM sys.foreign_keys
           WHERE referenced_object_id = OBJECT_ID('DBObjects'))
BEGIN
    SELECT name AS still_referencing_DBObjects,
           OBJECT_NAME(parent_object_id) AS child_table
    FROM sys.foreign_keys
    WHERE referenced_object_id = OBJECT_ID('DBObjects');
    RAISERROR('DBObjects is still referenced by a FOREIGN KEY - TRUNCATE will fail',16,1);
END
ELSE
    PRINT 'DBObjects is no longer referenced by any FOREIGN KEY - load can proceed';
GO
