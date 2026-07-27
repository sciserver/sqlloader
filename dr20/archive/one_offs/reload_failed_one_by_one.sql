-- =====================================================================================
-- Reload Failed Tables ONE AT A TIME with aggressive locking
-- =====================================================================================
-- Run this if you keep getting deadlocks
-- Each table in a separate batch to minimize lock contention
-- =====================================================================================

USE minidb_dr20_v2;
GO

PRINT 'Close ALL other SSMS windows and connections before proceeding!'
PRINT 'Press Ctrl+C to cancel, or wait 10 seconds to continue...'
WAITFOR DELAY '00:00:10';
GO

-- Table 1
PRINT '-- Loading: dr20_allstar_dr17_synspec_rev1'
DECLARE @start DATETIME2 = SYSDATETIME();
INSERT INTO minidb_dr20_v2.dbo.dr20_allstar_dr17_synspec_rev1 WITH (TABLOCKX)
SELECT * FROM minidb_dr20.dbo.dr20_allstar_dr17_synspec_rev1;
PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' + CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
GO

-- Table 2
PRINT '-- Loading: dr20_guvcat'
DECLARE @start DATETIME2 = SYSDATETIME();
INSERT INTO minidb_dr20_v2.dbo.dr20_guvcat WITH (TABLOCKX)
SELECT * FROM minidb_dr20.dbo.dr20_guvcat;
PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' + CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
GO

-- Table 3
PRINT '-- Loading: dr20_opsdb_apo_camera_frame'
DECLARE @start DATETIME2 = SYSDATETIME();
INSERT INTO minidb_dr20_v2.dbo.dr20_opsdb_apo_camera_frame WITH (TABLOCKX)
SELECT * FROM minidb_dr20.dbo.dr20_opsdb_apo_camera_frame;
PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' + CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
GO

-- Table 4
PRINT '-- Loading: dr20_sdss_apogeeallstarmerge_r13'
DECLARE @start DATETIME2 = SYSDATETIME();
INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_apogeeallstarmerge_r13 WITH (TABLOCKX)
SELECT * FROM minidb_dr20.dbo.dr20_sdss_apogeeallstarmerge_r13;
PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' + CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
GO

-- Table 5
PRINT '-- Loading: dr20_sdss_dr16_qso'
DECLARE @start DATETIME2 = SYSDATETIME();
INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_dr16_qso WITH (TABLOCKX)
SELECT * FROM minidb_dr20.dbo.dr20_sdss_dr16_qso;
PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' + CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
GO

-- Table 6
PRINT '-- Loading: dr20_sdss_dr17_apogee_allstarmerge'
DECLARE @start DATETIME2 = SYSDATETIME();
INSERT INTO minidb_dr20_v2.dbo.dr20_sdss_dr17_apogee_allstarmerge WITH (TABLOCKX)
SELECT * FROM minidb_dr20.dbo.dr20_sdss_dr17_apogee_allstarmerge;
PRINT 'SUCCESS: ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows, ' + CAST(DATEDIFF(SECOND, @start, SYSDATETIME()) AS VARCHAR(20)) + ' seconds'
GO

PRINT '-- All 6 deadlocked tables reloaded successfully!'
GO
