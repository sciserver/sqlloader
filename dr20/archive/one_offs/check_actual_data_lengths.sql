-- =====================================================================================
-- Check actual maximum data lengths in source tables
-- =====================================================================================
-- This will show us the actual longest values so we know how big to make columns
-- =====================================================================================

USE minidb_dr20;
GO

SET NOCOUNT ON;
GO

PRINT '=== Checking actual maximum data lengths in SOURCE tables ==='
PRINT ''

-- dr20_guvcat.groupgid (the one we KNOW is too small)
PRINT '-- dr20_guvcat.groupgid --'
SELECT
    'groupgid' AS column_name,
    MAX(LEN(groupgid)) AS max_length,
    MIN(LEN(groupgid)) AS min_length,
    AVG(LEN(groupgid)) AS avg_length,
    COUNT(*) AS row_count,
    COUNT(CASE WHEN LEN(groupgid) > 100 THEN 1 END) AS rows_over_100,
    COUNT(CASE WHEN LEN(groupgid) > 500 THEN 1 END) AS rows_over_500,
    COUNT(CASE WHEN LEN(groupgid) > 1000 THEN 1 END) AS rows_over_1000
FROM dr20_guvcat
WHERE groupgid IS NOT NULL;

PRINT ''

-- Sample the longest value to see what it looks like
PRINT 'Sample of longest groupgid value:'
SELECT TOP 1
    LEN(groupgid) AS length,
    LEFT(groupgid, 200) AS first_200_chars
FROM dr20_guvcat
WHERE groupgid IS NOT NULL
ORDER BY LEN(groupgid) DESC;

PRINT ''
PRINT '-- Checking all varchar columns in the 6 failed tables --'
PRINT ''

-- Dynamic SQL to check all varchar columns in all 6 tables
DECLARE @table_name NVARCHAR(128)
DECLARE @column_name NVARCHAR(128)
DECLARE @sql NVARCHAR(MAX)

DECLARE col_cursor CURSOR FOR
SELECT
    t.name AS table_name,
    c.name AS column_name
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
AND ty.name IN ('varchar', 'nvarchar')
ORDER BY t.name, c.column_id;

OPEN col_cursor
FETCH NEXT FROM col_cursor INTO @table_name, @column_name

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'
    SELECT
        ''' + @table_name + '.' + @column_name + ''' AS column_name,
        MAX(LEN(' + QUOTENAME(@column_name) + ')) AS max_length,
        COUNT(CASE WHEN LEN(' + QUOTENAME(@column_name) + ') > 100 THEN 1 END) AS rows_over_100,
        COUNT(CASE WHEN LEN(' + QUOTENAME(@column_name) + ') > 500 THEN 1 END) AS rows_over_500
    FROM ' + QUOTENAME(@table_name) + '
    WHERE ' + QUOTENAME(@column_name) + ' IS NOT NULL
    HAVING MAX(LEN(' + QUOTENAME(@column_name) + ')) > 0'

    EXEC sp_executesql @sql

    FETCH NEXT FROM col_cursor INTO @table_name, @column_name
END

CLOSE col_cursor
DEALLOCATE col_cursor
GO
