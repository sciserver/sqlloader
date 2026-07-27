-- =====================================================================================
-- Drop All Foreign Keys in minidb_dr20_v2
-- =====================================================================================

USE minidb_dr20_v2;
GO

DECLARE @sql NVARCHAR(MAX) = (
    SELECT
        'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' +
        QUOTENAME(OBJECT_NAME(parent_object_id)) +
        ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
    FROM sys.foreign_keys
    FOR XML PATH('')
);

PRINT @sql;
EXEC sp_executesql @sql;

PRINT '';
PRINT 'All foreign keys dropped.';
GO
