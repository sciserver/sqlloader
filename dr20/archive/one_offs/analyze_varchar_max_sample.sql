-- =====================================================================================
-- Analyze varchar(max) columns in minidb_dr20 using SAMPLING (first 1000 rows)
-- =====================================================================================
-- This script finds all varchar(max) columns and checks a SAMPLE of rows
-- to determine appropriate varchar(n) sizes.
--
-- Strategy:
--   1. Find all varchar(max) columns in dr20_* tables
--   2. Query TOP 1000 rows from each table to find MAX(LEN(column))
--   3. Recommend varchar(n) size with headroom
--   4. Flag columns used in primary keys (critical to fix)
-- =====================================================================================

USE minidb_dr20;
GO

SET NOCOUNT ON;
GO

-- Create temp table to store results
CREATE TABLE #VarcharMaxAnalysis (
    table_name SYSNAME,
    column_name SYSNAME,
    max_length_found INT,
    sample_size INT,
    recommended_size INT,
    is_in_pk BIT,
    recommendation VARCHAR(100)
);
GO

-- Find all varchar(max) columns
DECLARE @table_name SYSNAME;
DECLARE @column_name SYSNAME;
DECLARE @sql NVARCHAR(MAX);
DECLARE @max_len INT;
DECLARE @sample_count INT;
DECLARE @is_pk BIT;

DECLARE col_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT
        t.name AS table_name,
        c.name AS column_name,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM sys.index_columns ic
                JOIN sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
                WHERE ic.object_id = t.object_id
                AND ic.column_id = c.column_id
                AND i.is_primary_key = 1
            ) THEN 1
            ELSE 0
        END AS is_in_pk
    FROM sys.tables t
    JOIN sys.columns c ON t.object_id = c.object_id
    JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE t.name LIKE 'dr20_%'
    AND ty.name = 'varchar'
    AND c.max_length = -1  -- varchar(max)
    ORDER BY t.name, c.name;

OPEN col_cursor;
FETCH NEXT FROM col_cursor INTO @table_name, @column_name, @is_pk;

PRINT '-- Analyzing varchar(max) columns (sampling first 1000 rows per table)...'
PRINT ''

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        -- Build dynamic SQL to find max length in SAMPLE
        SET @sql = N'
            SELECT
                @max_len_out = ISNULL(MAX(LEN(' + QUOTENAME(@column_name) + ')), 0),
                @sample_count_out = COUNT(*)
            FROM (
                SELECT TOP 1000 ' + QUOTENAME(@column_name) + '
                FROM dbo.' + QUOTENAME(@table_name) + '
            ) AS sample';

        EXEC sp_executesql @sql,
            N'@max_len_out INT OUTPUT, @sample_count_out INT OUTPUT',
            @max_len_out = @max_len OUTPUT,
            @sample_count_out = @sample_count OUTPUT;

        -- Determine recommended size
        DECLARE @recommended INT;
        DECLARE @recommendation VARCHAR(100);

        IF @max_len = 0
            BEGIN
                SET @recommended = 500;
                SET @recommendation = 'Empty - default 500';
            END
        ELSE IF @max_len <= 50
            BEGIN
                SET @recommended = 100;
                SET @recommendation = 'Small (<=50)';
            END
        ELSE IF @max_len <= 200
            BEGIN
                SET @recommended = 500;
                SET @recommendation = 'Medium (<=200)';
            END
        ELSE IF @max_len <= 1000
            BEGIN
                SET @recommended = 2000;
                SET @recommendation = 'Large (<=1000)';
            END
        ELSE IF @max_len <= 4000
            BEGIN
                SET @recommended = 8000;
                SET @recommendation = 'Very large (<=4000)';
            END
        ELSE
            BEGIN
                SET @recommended = -1;  -- Keep as varchar(max)
                SET @recommendation = 'Exceeds 4000 - keep MAX';
            END

        -- Insert result
        INSERT INTO #VarcharMaxAnalysis
        VALUES (@table_name, @column_name, @max_len, @sample_count, @recommended, @is_pk, @recommendation);

        PRINT 'Analyzed: ' + @table_name + '.' + @column_name + ' (max: ' + CAST(@max_len AS VARCHAR(10)) + ', sample: ' + CAST(@sample_count AS VARCHAR(10)) + ')';

    END TRY
    BEGIN CATCH
        -- Log errors but continue
        INSERT INTO #VarcharMaxAnalysis
        VALUES (@table_name, @column_name, NULL, 0, 500, @is_pk, 'ERROR: ' + ERROR_MESSAGE());

        PRINT 'ERROR analyzing: ' + @table_name + '.' + @column_name;
    END CATCH

    FETCH NEXT FROM col_cursor INTO @table_name, @column_name, @is_pk;
END

CLOSE col_cursor;
DEALLOCATE col_cursor;
GO

-- =====================================================================================
-- Report Results
-- =====================================================================================

PRINT ''
PRINT '-- =============================================================================='
PRINT '-- VARCHAR(MAX) COLUMNS ANALYSIS SUMMARY'
PRINT '-- =============================================================================='
PRINT ''

-- Summary
SELECT
    COUNT(*) AS total_varchar_max_columns,
    SUM(CASE WHEN is_in_pk = 1 THEN 1 ELSE 0 END) AS in_primary_keys,
    SUM(CASE WHEN recommended_size = -1 THEN 1 ELSE 0 END) AS keep_as_max,
    SUM(CASE WHEN recommended_size <> -1 THEN 1 ELSE 0 END) AS can_be_fixed
FROM #VarcharMaxAnalysis;

PRINT ''
PRINT '-- =============================================================================='
PRINT '-- CRITICAL: VARCHAR(MAX) COLUMNS IN PRIMARY KEYS (MUST FIX)'
PRINT '-- =============================================================================='
PRINT ''

SELECT
    table_name,
    column_name,
    max_length_found AS max_len,
    recommended_size AS rec_size,
    sample_size,
    recommendation
FROM #VarcharMaxAnalysis
WHERE is_in_pk = 1
ORDER BY table_name, column_name;

PRINT ''
PRINT '-- =============================================================================='
PRINT '-- ALL VARCHAR(MAX) COLUMNS (sorted by recommended size)'
PRINT '-- =============================================================================='
PRINT ''

SELECT
    table_name,
    column_name,
    max_length_found AS max_len,
    recommended_size AS rec_size,
    CASE WHEN is_in_pk = 1 THEN 'PK**' ELSE '' END AS pk_flag,
    sample_size,
    recommendation
FROM #VarcharMaxAnalysis
ORDER BY
    is_in_pk DESC,  -- PKs first
    recommended_size DESC,  -- Largest recommended sizes first
    table_name,
    column_name;

-- Cleanup
DROP TABLE #VarcharMaxAnalysis;
GO

PRINT ''
PRINT '-- Analysis complete! Use results to update mssql_tables_0112.sql'
GO
