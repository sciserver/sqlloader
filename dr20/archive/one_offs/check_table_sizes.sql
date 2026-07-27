-- =====================================================================================
-- Check row counts and sizes for the 6 failed tables
-- =====================================================================================

USE minidb_dr20;
GO

SET NOCOUNT ON;
GO

PRINT '=== Row Counts in SOURCE Tables (minidb_dr20) ===';
PRINT '';

SELECT
    'dr20_allstar_dr17_synspec_rev1' AS table_name,
    COUNT(*) AS row_count,
    COUNT(*) / 1000000.0 AS millions_of_rows
FROM dr20_allstar_dr17_synspec_rev1
UNION ALL
SELECT
    'dr20_guvcat',
    COUNT(*),
    COUNT(*) / 1000000.0
FROM dr20_guvcat
UNION ALL
SELECT
    'dr20_opsdb_apo_camera_frame',
    COUNT(*),
    COUNT(*) / 1000000.0
FROM dr20_opsdb_apo_camera_frame
UNION ALL
SELECT
    'dr20_sdss_apogeeallstarmerge_r13',
    COUNT(*),
    COUNT(*) / 1000000.0
FROM dr20_sdss_apogeeallstarmerge_r13
UNION ALL
SELECT
    'dr20_sdss_dr16_qso',
    COUNT(*),
    COUNT(*) / 1000000.0
FROM dr20_sdss_dr16_qso
UNION ALL
SELECT
    'dr20_sdss_dr17_apogee_allstarmerge',
    COUNT(*),
    COUNT(*) / 1000000.0
FROM dr20_sdss_dr17_apogee_allstarmerge
ORDER BY row_count DESC;
GO
