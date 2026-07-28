-------------------------------------------------------------------------------
--  recreate_metadata_fks.sql
--
--  Restores the foreign keys dropped by drop_metadata_fks.sql.
--  Run this AFTER the metadata load has finished -- DBColumns and DBViewCols
--  reference DBObjects, which the load truncates and repopulates.
--
--  Created WITH CHECK, so existing rows are validated and the constraints
--  come back trusted rather than in the untrusted state they were in before.
--  Measured 2026-07-28: DBColumns and DBViewCols have 0 rows orphaned against
--  DBObjects, so both validate cleanly. If either fails here, the load left
--  child rows whose parent object is missing -- find them with:
--
--      SELECT DISTINCT tablename FROM DBColumns c
--       WHERE NOT EXISTS (SELECT 1 FROM DBObjects o WHERE o.name = c.tablename);
--
--  fk_Inventory_name_DBObjects_name is deliberately NOT recreated. Inventory
--  had 63 rows orphaned against DBObjects as of 2026-07-28, so it cannot be
--  validated, and it is no longer tracked. The original definition is kept
--  below, commented, in case that changes.
--
--  Suzanne Werner, 2026-07-28
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('fk_DBColumns_tablename_DBObjects', 'F') IS NULL
BEGIN
    ALTER TABLE DBColumns WITH CHECK
        ADD CONSTRAINT fk_DBColumns_tablename_DBObjects
        FOREIGN KEY (tablename) REFERENCES DBObjects ([name]);
    PRINT 'recreated fk_DBColumns_tablename_DBObjects';
END
ELSE
    PRINT 'fk_DBColumns_tablename_DBObjects already present';
GO

IF OBJECT_ID('fk_DBViewCols_viewname_DBObjects', 'F') IS NULL
BEGIN
    ALTER TABLE DBViewCols WITH CHECK
        ADD CONSTRAINT fk_DBViewCols_viewname_DBObjects
        FOREIGN KEY (viewname) REFERENCES DBObjects ([name]);
    PRINT 'recreated fk_DBViewCols_viewname_DBObjects';
END
ELSE
    PRINT 'fk_DBViewCols_viewname_DBObjects already present';
GO

-- Not recreated -- 63 orphaned Inventory rows, and Inventory is no longer
-- tracked. Clean the orphans first if this is ever wanted back:
--
-- ALTER TABLE Inventory WITH CHECK
--     ADD CONSTRAINT fk_Inventory_name_DBObjects_name
--     FOREIGN KEY ([name]) REFERENCES DBObjects ([name]);

-- Report the resulting state.
SELECT fk.name,
       OBJECT_NAME(fk.parent_object_id) AS child_table,
       fk.is_disabled,
       fk.is_not_trusted
FROM sys.foreign_keys fk
WHERE fk.referenced_object_id = OBJECT_ID('DBObjects')
ORDER BY fk.name;
GO
