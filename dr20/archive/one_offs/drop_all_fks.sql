-- =====================================================================================
-- Drop All Foreign Keys
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

PRINT '-- Dropping all existing foreign keys...';

DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql +
    'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' +
    QUOTENAME(OBJECT_NAME(parent_object_id)) +
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE name LIKE 'dr20_%';

PRINT @sql;
EXEC sp_executesql @sql;

PRINT 'All foreign keys dropped.';
GO
