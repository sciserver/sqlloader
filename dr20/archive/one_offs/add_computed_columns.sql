-- =====================================================================================
-- Add Persisted Computed Columns and Create Indexes
-- =====================================================================================
-- 3 tables need computed columns for expression indexes
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT '-- ==============================================================================';
PRINT '-- Adding Persisted Computed Columns';
PRINT '-- Started: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';

-- =====================================================================================
-- 1. dr20_allwise: w1mpro - w2mpro
-- =====================================================================================

PRINT '-- Table: dr20_allwise';
PRINT '-- Adding computed column: w1mpro_w2mpro';

BEGIN TRY
    ALTER TABLE dbo.dr20_allwise ADD
        w1mpro_w2mpro AS (w1mpro - w2mpro) PERSISTED;

    PRINT 'SUCCESS: Column added';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
END CATCH

PRINT '-- Creating index: idx_allwise_w1mpro_w2mpro';

BEGIN TRY
    CREATE NONCLUSTERED INDEX idx_allwise_w1mpro_w2mpro
        ON dbo.dr20_allwise (w1mpro_w2mpro)
        ON [MINIDB];

    PRINT 'SUCCESS: Index created';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT '';
END CATCH

-- =====================================================================================
-- 2. dr20_gaia_dr2_source: parallax - parallax_error
-- =====================================================================================

PRINT '-- Table: dr20_gaia_dr2_source';
PRINT '-- Adding computed column: parallax_parallax_error';

BEGIN TRY
    ALTER TABLE dbo.dr20_gaia_dr2_source ADD
        parallax_parallax_error AS (parallax - parallax_error) PERSISTED;

    PRINT 'SUCCESS: Column added';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
END CATCH

PRINT '-- Creating index: idx_gaia_dr2_source_parallax_parallax_error';

BEGIN TRY
    CREATE NONCLUSTERED INDEX idx_gaia_dr2_source_parallax_parallax_error
        ON dbo.dr20_gaia_dr2_source (parallax_parallax_error)
        ON [MINIDB];

    PRINT 'SUCCESS: Index created';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT '';
END CATCH

-- =====================================================================================
-- 3. dr20_guvcat: fuv_mag - nuv_mag
-- =====================================================================================

PRINT '-- Table: dr20_guvcat';
PRINT '-- Adding computed column: fuv_mag_nuv_mag';

BEGIN TRY
    ALTER TABLE dbo.dr20_guvcat ADD
        fuv_mag_nuv_mag AS (fuv_mag - nuv_mag) PERSISTED;

    PRINT 'SUCCESS: Column added';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
END CATCH

PRINT '-- Creating index: idx_guvcat_fuv_mag_nuv_mag';

BEGIN TRY
    CREATE NONCLUSTERED INDEX idx_guvcat_fuv_mag_nuv_mag
        ON dbo.dr20_guvcat (fuv_mag_nuv_mag)
        ON [MINIDB];

    PRINT 'SUCCESS: Index created';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE();
    PRINT '';
END CATCH

-- =====================================================================================
-- Summary
-- =====================================================================================

PRINT '-- ==============================================================================';
PRINT '-- Computed Columns Complete!';
PRINT '-- Ended: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';
PRINT '3 persisted computed columns added and indexed';
GO
