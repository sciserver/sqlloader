-- =====================================================================================
-- Create Nonclustered Indexes on minidb_dr20_v2
-- =====================================================================================
-- Total: 989 indexes (3 computed expression indexes removed)
-- Plus: 1 HTM spatial index on dr20_target
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

PRINT '-- ==============================================================================';
PRINT '-- Creating Nonclustered Indexes';
PRINT '-- Started: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';

-- =====================================================================================
-- Step 1: Create HTM spatial index on dr20_target (for cone searches)
-- =====================================================================================

PRINT '-- Creating HTM spatial index on dr20_target';
DECLARE @start DATETIME2 = SYSDATETIME();

BEGIN TRY
    CREATE NONCLUSTERED INDEX idx_target_htmid
        ON dbo.dr20_target (htmid)
        INCLUDE (cx, cy, cz)
        ON [MINIDB];

    PRINT 'SUCCESS: idx_target_htmid created in ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT '';
END CATCH
GO

-- =====================================================================================
-- Step 2: Create all 989 standard nonclustered indexes
-- =====================================================================================

PRINT '-- Creating 989 nonclustered indexes from mssql_indexes_0112_no_computed.sql';
PRINT '-- This will take 2-4 hours...';
PRINT '';
GO

-- Include the filtered index file here
:r mssql_indexes_0112_final.sql

PRINT '';
PRINT '-- ==============================================================================';
PRINT '-- Index Creation Complete!';
PRINT '-- Ended: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
GO
