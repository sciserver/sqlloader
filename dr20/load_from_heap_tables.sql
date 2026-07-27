-- =====================================================================================
-- Load Data from E: Drive Heap Tables to D: Drive Clustered Tables
-- =====================================================================================
-- This script generates INSERT...SELECT statements to copy data from the temporary
-- database on E: drive (heap tables) to the production database on D: drive
-- (clustered tables with compression).
--
-- Source DB: minidb_dr20 (E: drive, heap tables, no indexes)
-- Target DB: minidb_dr20_v2 (D: drive, clustered indexes with PAGE compression)
--
-- Benefits over re-reading CSV files:
--   - No CSV parsing overhead
--   - No delimiter/encoding issues
--   - Much faster (memory-to-memory transfer)
--   - Data already validated and loaded
--
-- Prerequisites:
--   1. minidb_dr20_v2 database created with MINIDB filegroup
--   2. Tables created in minidb_dr20_v2 (mssql_tables_0112.sql)
--   3. Primary keys added to minidb_dr20_v2 (mssql_pk_0112.sql) - creates clustered indexes
--   4. minidb_dr20 source database still exists on E: drive with all data loaded
--
-- Usage:
--   sqlcmd -S localhost -d minidb_dr20_v2 -E -i load_from_heap_tables.sql -o load_results.txt
--
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

-- =====================================================================================
-- Generate INSERT Statements for All dr20_* Tables
-- =====================================================================================

DECLARE @sql NVARCHAR(MAX);
DECLARE @table_name SYSNAME;
DECLARE @start_time DATETIME2;
DECLARE @end_time DATETIME2;
DECLARE @rows_affected BIGINT;

-- Create temp table to track progress
CREATE TABLE #LoadProgress (
    table_name SYSNAME,
    start_time DATETIME2,
    end_time DATETIME2,
    duration_seconds INT,
    rows_loaded BIGINT,
    status VARCHAR(20)
);

-- Cursor to iterate through all dr20_* tables
DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT name
    FROM sys.tables
    WHERE name LIKE 'dr20_%'
    ORDER BY name;

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @table_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        SET @start_time = SYSDATETIME();

        PRINT '-- ==============================================================================';
        PRINT '-- Loading: ' + @table_name;
        PRINT '-- Started: ' + CONVERT(VARCHAR(30), @start_time, 121);
        PRINT '-- ==============================================================================';

        -- Build INSERT statement with TABLOCK for minimal logging
        -- Source: minidb_dr20 (E: drive heap tables)
        -- Target: minidb_dr20_v2 (D: drive clustered tables)
        SET @sql = N'
            INSERT INTO minidb_dr20_v2.dbo.' + QUOTENAME(@table_name) + N' WITH (TABLOCK)
            SELECT *
            FROM minidb_dr20.dbo.' + QUOTENAME(@table_name) + N';
        ';

        -- Execute the insert
        EXEC sp_executesql @sql;

        SET @rows_affected = @@ROWCOUNT;
        SET @end_time = SYSDATETIME();

        -- Log success
        INSERT INTO #LoadProgress (table_name, start_time, end_time, duration_seconds, rows_loaded, status)
        VALUES (
            @table_name,
            @start_time,
            @end_time,
            DATEDIFF(SECOND, @start_time, @end_time),
            @rows_affected,
            'SUCCESS'
        );

        PRINT 'Completed: ' + @table_name;
        PRINT 'Rows loaded: ' + CAST(@rows_affected AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR(20)) + ' seconds';
        PRINT '';

    END TRY
    BEGIN CATCH
        SET @end_time = SYSDATETIME();

        -- Log failure
        INSERT INTO #LoadProgress (table_name, start_time, end_time, duration_seconds, rows_loaded, status)
        VALUES (
            @table_name,
            @start_time,
            @end_time,
            DATEDIFF(SECOND, @start_time, @end_time),
            0,
            'FAILED'
        );

        PRINT 'ERROR loading ' + @table_name + ':';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT '';

    END CATCH

    FETCH NEXT FROM table_cursor INTO @table_name;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;

-- =====================================================================================
-- Summary Report
-- =====================================================================================

PRINT '-- ==============================================================================';
PRINT '-- LOAD SUMMARY';
PRINT '-- ==============================================================================';

SELECT
    status,
    COUNT(*) AS table_count,
    SUM(rows_loaded) AS total_rows,
    SUM(duration_seconds) AS total_seconds,
    SUM(duration_seconds) / 60 AS total_minutes,
    SUM(duration_seconds) / 3600.0 AS total_hours
FROM #LoadProgress
GROUP BY status
ORDER BY status;

PRINT '';
PRINT '-- Top 20 Largest Tables by Row Count';
SELECT TOP 20
    table_name,
    rows_loaded,
    duration_seconds,
    CASE
        WHEN duration_seconds > 0 THEN rows_loaded / duration_seconds
        ELSE 0
    END AS rows_per_second,
    status
FROM #LoadProgress
WHERE status = 'SUCCESS'
ORDER BY rows_loaded DESC;

PRINT '';
PRINT '-- Failed Tables (if any)';
SELECT
    table_name,
    start_time,
    end_time,
    status
FROM #LoadProgress
WHERE status = 'FAILED'
ORDER BY table_name;

-- Cleanup
DROP TABLE #LoadProgress;
GO

PRINT '';
PRINT '-- ==============================================================================';
PRINT '-- Data load complete!';
PRINT '-- Next steps:';
PRINT '-- 1. Verify row counts match source: SELECT name, SUM(rows) FROM sys.partitions';
PRINT '-- 2. Add nonclustered indexes: mssql_indexes_0112.sql';
PRINT '-- 3. Add foreign keys: mssql_fk_0112.sql';
PRINT '-- ==============================================================================';
GO
