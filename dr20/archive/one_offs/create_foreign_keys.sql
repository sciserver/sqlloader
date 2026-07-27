-- =====================================================================================
-- Create Foreign Keys on minidb_dr20_v2
-- =====================================================================================
-- Total: 102 foreign keys
-- Some may fail due to orphaned references in cross-match tables
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

PRINT '-- ==============================================================================';
PRINT '-- Creating Foreign Keys';
PRINT '-- Started: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';

-- Track success/failure counts
DECLARE @success INT = 0;
DECLARE @failed INT = 0;

-- Include the FK file
:r mssql_fk_0112.sql

-- Note: mssql_fk_0112.sql contains all 102 ALTER TABLE...ADD CONSTRAINT statements
-- If any fail due to orphaned records, they will be reported in the output

PRINT '';
PRINT '-- ==============================================================================';
PRINT '-- Foreign Key Creation Complete!';
PRINT '-- Ended: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';
PRINT 'Review output for any failed constraints';
PRINT 'Failed constraints are typically due to orphaned references';
GO
