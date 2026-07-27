-- =====================================================================================
-- Test loading ONE table with maximum isolation
-- =====================================================================================
-- Run AFTER restarting SQL Server service
-- Make sure NO other SSMS windows are open
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

-- Table 1: dr20_guvcat (one of the smaller failed tables)
PRINT '-- Loading: dr20_guvcat'
PRINT '-- Started: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121)
DECLARE @start DATETIME2 = SYSDATETIME();

BEGIN TRY
    -- MAXDOP 1 forces single-threaded execution (no parallel workers = no parallel deadlocks)
    -- TABLOCKX gives exclusive table access
    INSERT INTO minidb_dr20_v2.dbo.dr20_guvcat WITH (TABLOCKX)
    SELECT * FROM minidb_dr20.dbo.dr20_guvcat
    OPTION (MAXDOP 1);

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE()
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10))
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10))
END CATCH

PRINT '-- Ended: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121)
GO
