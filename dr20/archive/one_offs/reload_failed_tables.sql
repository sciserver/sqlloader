-- =====================================================================================
-- Reload 7 Failed Tables from load_from_heap_tables.sql
-- =====================================================================================
-- 6 tables failed due to deadlocks (simple retry)
-- 1 table (dr20_target) failed due to column mismatch (computed columns)
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

PRINT '-- =============================================================================='
PRINT '-- Reloading Failed Tables'
PRINT '-- Started: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121)
PRINT '-- =============================================================================='
PRINT ''

-- =====================================================================================
-- 1. dr20_allstar_dr17_synspec_rev1 (Deadlock retry)
-- =====================================================================================

PRINT '-- Loading: dr20_allstar_dr17_synspec_rev1'
DECLARE @start DATETIME2 = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_allstar_dr17_synspec_rev1 WITH (TABLOCKX)
    SELECT * FROM minidb_dr20.dbo.dr20_allstar_dr17_synspec_rev1;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

-- =====================================================================================
-- 2. dr20_guvcat (Deadlock retry)
-- =====================================================================================

PRINT '-- Loading: dr20_guvcat'
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_guvcat WITH (TABLOCKX)
    SELECT * FROM minidb_dr20.dbo.dr20_guvcat;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

-- =====================================================================================
-- 3. dr20_opsdb_apo_camera_frame (Deadlock retry)
-- =====================================================================================

PRINT '-- Loading: dr20_opsdb_apo_camera_frame'
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_opsdb_apo_camera_frame WITH (TABLOCKX)
    SELECT * FROM minidb_dr20.dbo.dr20_opsdb_apo_camera_frame;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

-- =====================================================================================
-- 4. dr20_sdss_apogeeallstarmerge_r13 (Deadlock retry)
-- =====================================================================================

PRINT '-- Loading: dr20_sdss_apogeeallstarmerge_r13'
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_apogeeallstarmerge_r13 WITH (TABLOCKX)
    SELECT * FROM minidb_dr20.dbo.dr20_sdss_apogeeallstarmerge_r13;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

-- =====================================================================================
-- 5. dr20_sdss_dr16_qso (Deadlock retry)
-- =====================================================================================

PRINT '-- Loading: dr20_sdss_dr16_qso'
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_dr16_qso WITH (TABLOCKX)
    SELECT * FROM minidb_dr20.dbo.dr20_sdss_dr16_qso;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

-- =====================================================================================
-- 6. dr20_sdss_dr17_apogee_allstarmerge (Deadlock retry)
-- =====================================================================================

PRINT '-- Loading: dr20_sdss_dr17_apogee_allstarmerge'
SET @start = SYSDATETIME();

BEGIN TRY
    INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_dr17_apogee_allstarmerge WITH (TABLOCKX)
    SELECT * FROM minidb_dr20.dbo.dr20_sdss_dr17_apogee_allstarmerge;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

-- =====================================================================================
-- 7. dr20_target (Add regular HTM columns, then copy pre-computed values)
-- =====================================================================================

PRINT '-- Loading: dr20_target'
PRINT '-- NOTE: E: drive has HTM values already computed'
PRINT '-- NOTE: Adding as regular columns and copying values (no recomputation)'
PRINT ''

PRINT '-- Step 1: Add regular HTM columns to dr20_target'

BEGIN TRY
    -- Add HTM columns as regular columns (not computed)
    -- Values are already computed on E: drive, just copy them
    --ALTER TABLE minidb_dr20_v2.dbo.dr20_target ADD
    --    htmid bigint NULL,
    --    cx real NULL,
    --    cy real NULL,
    --    cz real NULL;

    PRINT 'SUCCESS: Added 4 regular columns (htmid, cx, cy, cz)'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT 'FAILED adding columns: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

PRINT '-- Step 2: Copy all 12 columns including pre-computed HTM values'
SET @start = SYSDATETIME();

BEGIN TRY
    -- Copy all columns including already-computed HTM values
    INSERT INTO minidb_dr20_v2.dbo.dr20_target WITH (TABLOCKX)
        (target_pk, ra, [dec], pmra, pmdec, epoch, parallax, catalogid, htmid, cx, cy, cz)
    SELECT
        target_pk, ra, [dec], pmra, pmdec, epoch, parallax, catalogid, htmid, cx, cy, cz
    FROM minidb_dr20.dbo.dr20_target;

    PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' +
          CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
    PRINT 'HTM values copied from E: drive (no recomputation needed)'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT 'FAILED: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

-- =====================================================================================
-- Summary
-- =====================================================================================

PRINT '-- =============================================================================='
PRINT '-- Reload complete!'
PRINT '-- Ended: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121)
PRINT '-- =============================================================================='
PRINT ''
PRINT 'dr20_target now has HTM columns with pre-computed values from E: drive'
PRINT ''
PRINT 'Next step: Create index on htmid for cone searches:'
PRINT '  CREATE INDEX dr20_target_htmid_idx ON dr20_target(htmid);'
GO
