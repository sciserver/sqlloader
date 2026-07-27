-- =====================================================================================
-- Check column sizes for the 6 failed tables
-- =====================================================================================

USE minidb_dr20_v2;
GO

PRINT '=== Checking column sizes in TARGET (minidb_dr20_v2) ==='
PRINT ''

-- Check each of the 6 failed tables for varchar columns
SELECT
    t.name AS table_name,
    c.name AS column_name,
    ty.name AS data_type,
    c.max_length,
    CASE
        WHEN ty.name IN ('varchar', 'nvarchar') THEN
            CASE c.max_length
                WHEN -1 THEN 'MAX'
                ELSE CAST(c.max_length AS VARCHAR(10))
            END
        ELSE ''
    END AS varchar_size
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE t.name IN (
    'dr20_allstar_dr17_synspec_rev1',
    'dr20_guvcat',
    'dr20_opsdb_apo_camera_frame',
    'dr20_sdss_apogeeallstarmerge_r13',
    'dr20_sdss_dr16_qso',
    'dr20_sdss_dr17_apogee_allstarmerge'
)
AND ty.name IN ('varchar', 'nvarchar', 'char', 'nchar')
ORDER BY t.name, c.column_id;

PRINT ''
PRINT '=== Now checking SOURCE table sizes (minidb_dr20) ==='
PRINT ''

USE minidb_dr20;
GO

SELECT
    t.name AS table_name,
    c.name AS column_name,
    ty.name AS data_type,
    c.max_length,
    CASE
        WHEN ty.name IN ('varchar', 'nvarchar') THEN
            CASE c.max_length
                WHEN -1 THEN 'MAX'
                ELSE CAST(c.max_length AS VARCHAR(10))
            END
        ELSE ''
    END AS varchar_size
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE t.name IN (
    'dr20_allstar_dr17_synspec_rev1',
    'dr20_guvcat',
    'dr20_opsdb_apo_camera_frame',
    'dr20_sdss_apogeeallstarmerge_r13',
    'dr20_sdss_dr16_qso',
    'dr20_sdss_dr17_apogee_allstarmerge'
)
AND ty.name IN ('varchar', 'nvarchar', 'char', 'nchar')
ORDER BY t.name, c.column_id;
GO
