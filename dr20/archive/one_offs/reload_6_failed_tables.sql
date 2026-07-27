-- =====================================================================================
-- Reload 6 Failed Tables After Fixing VARCHAR Column Sizes
-- =====================================================================================
-- dr20_target already loaded successfully - not included
-- These 6 tables failed with truncation errors due to undersized varchar columns
-- Column sizes have been fixed with fix_undersized_columns.sql
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

PRINT '-- ==============================================================================';
PRINT '-- Reloading 6 Failed Tables';
PRINT '-- Started: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';

-- =====================================================================================
-- 1. dr20_allstar_dr17_synspec_rev1
-- =====================================================================================

PRINT '-- Loading: dr20_allstar_dr17_synspec_rev1';
DECLARE @start DATETIME2 = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_allstar_dr17_synspec_rev1 WITH (TABLOCK)
    SELECT * FROM minidb_dr20.dbo.dr20_allstar_dr17_synspec_rev1;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT '';
END CATCH

-- =====================================================================================
-- 2. dr20_guvcat
-- =====================================================================================

PRINT '-- Loading: dr20_guvcat';
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_guvcat WITH (TABLOCK)
    SELECT * FROM minidb_dr20.dbo.dr20_guvcat;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT '';
END CATCH

-- =====================================================================================
-- 3. dr20_opsdb_apo_camera_frame
-- =====================================================================================

PRINT '-- Loading: dr20_opsdb_apo_camera_frame';
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_opsdb_apo_camera_frame WITH (TABLOCK)
    SELECT * FROM minidb_dr20.dbo.dr20_opsdb_apo_camera_frame;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT '';
END CATCH

-- =====================================================================================
-- 4. dr20_sdss_apogeeallstarmerge_r13
-- =====================================================================================

PRINT '-- Loading: dr20_sdss_apogeeallstarmerge_r13';
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_apogeeallstarmerge_r13 WITH (TABLOCK)
    SELECT * FROM minidb_dr20.dbo.dr20_sdss_apogeeallstarmerge_r13;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT '';
END CATCH

-- =====================================================================================
-- 5. dr20_sdss_dr16_qso
-- =====================================================================================

PRINT '-- Loading: dr20_sdss_dr16_qso';
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_dr16_qso WITH (TABLOCK)
    SELECT * FROM minidb_dr20.dbo.dr20_sdss_dr16_qso;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT '';
END CATCH

-- =====================================================================================
-- 6. dr20_sdss_dr17_apogee_allstarmerge
-- =====================================================================================

PRINT '-- Loading: dr20_sdss_dr17_apogee_allstarmerge';
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_dr17_apogee_allstarmerge WITH (TABLOCK)
    SELECT * FROM minidb_dr20.dbo.dr20_sdss_dr17_apogee_allstarmerge;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT '';
END CATCH

-- =====================================================================================
-- Summary
-- =====================================================================================

PRINT '-- ==============================================================================';
PRINT '-- Reload Complete!';
PRINT '-- Ended: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
GO
