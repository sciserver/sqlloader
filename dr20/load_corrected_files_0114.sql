-- Load 6 corrected CSV files from Utah (2026-01-14)
-- Files in E:\DR20\minidb_dr20\casload_20260114\
--
-- 5 Gaia files: Truncated downloads have been corrected
-- 1 lamost_dr6: Regenerated with pipe delimiters to fix CSV quoting issue
--
-- Total: ~210 GB of data
-- Created: 2026-01-15

USE minidb_dr20;
GO

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'Loading 6 corrected CSV files from Utah';
PRINT 'Started: ' + CONVERT(varchar, GETDATE(), 120);
PRINT '========================================';
GO

-------------------------------------------------
-- 1. dr20_gaiadr2_tmass_best_neighbour (4.5 GB)
-- Original issue: EOF error (truncated at column 5)
-------------------------------------------------
PRINT '';
PRINT '1/6: Loading dr20_gaiadr2_tmass_best_neighbour...';
GO

TRUNCATE TABLE dbo.dr20_gaiadr2_tmass_best_neighbour;
GO

BULK INSERT dbo.dr20_gaiadr2_tmass_best_neighbour
FROM 'E:\DR20\minidb_dr20\casload_20260114\minidb_dr20.dr20_gaiadr2_tmass_best_neighbour.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'dr20_gaiadr2_tmass_best_neighbour', COUNT(*) AS row_count FROM dbo.dr20_gaiadr2_tmass_best_neighbour;
GO

-------------------------------------------------
-- 2. dr20_gaia_dr2_source (57.7 GB)
-- Original issue: EOF error (truncated at column 2)
-------------------------------------------------
PRINT '';
PRINT '2/6: Loading dr20_gaia_dr2_source...';
GO

TRUNCATE TABLE dbo.dr20_gaia_dr2_source;
GO

BULK INSERT dbo.dr20_gaia_dr2_source
FROM 'E:\DR20\minidb_dr20\casload_20260114\minidb_dr20.dr20_gaia_dr2_source.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'dr20_gaia_dr2_source', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr2_source;
GO

-------------------------------------------------
-- 3. dr20_gaia_dr3_astrophysical_parameters (53.3 GB)
-- Original issue: EOF error (truncated at column 207)
-------------------------------------------------
PRINT '';
PRINT '3/6: Loading dr20_gaia_dr3_astrophysical_parameters...';
GO

TRUNCATE TABLE dbo.dr20_gaia_dr3_astrophysical_parameters;
GO

BULK INSERT dbo.dr20_gaia_dr3_astrophysical_parameters
FROM 'E:\DR20\minidb_dr20\casload_20260114\minidb_dr20.dr20_gaia_dr3_astrophysical_parameters.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'dr20_gaia_dr3_astrophysical_parameters', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr3_astrophysical_parameters;
GO

-------------------------------------------------
-- 4. dr20_gaia_dr3_source (72.1 GB)
-- Original issue: EOF error (truncated at column 8)
-------------------------------------------------
PRINT '';
PRINT '4/6: Loading dr20_gaia_dr3_source...';
GO

TRUNCATE TABLE dbo.dr20_gaia_dr3_source;
GO

BULK INSERT dbo.dr20_gaia_dr3_source
FROM 'E:\DR20\minidb_dr20\casload_20260114\minidb_dr20.dr20_gaia_dr3_source.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'dr20_gaia_dr3_source', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr3_source;
GO

-------------------------------------------------
-- 5. dr20_gaia_dr3_synthetic_photometry_gspc (19.3 GB)
-- Original issue: EOF error (truncated at column 24)
-------------------------------------------------
PRINT '';
PRINT '5/6: Loading dr20_gaia_dr3_synthetic_photometry_gspc...';
GO

TRUNCATE TABLE dbo.dr20_gaia_dr3_synthetic_photometry_gspc;
GO

BULK INSERT dbo.dr20_gaia_dr3_synthetic_photometry_gspc
FROM 'E:\DR20\minidb_dr20\casload_20260114\minidb_dr20.dr20_gaia_dr3_synthetic_photometry_gspc.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'dr20_gaia_dr3_synthetic_photometry_gspc', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr3_synthetic_photometry_gspc;
GO

-------------------------------------------------
-- 6. dr20_lamost_dr6 (3.2 GB)
-- Original issue: CSV quoting with internal commas (153,732 rows)
-- Fixed: Regenerated with pipe delimiters
-------------------------------------------------
PRINT '';
PRINT '6/6: Loading dr20_lamost_dr6...';
GO

TRUNCATE TABLE dbo.dr20_lamost_dr6;
GO

BULK INSERT dbo.dr20_lamost_dr6
FROM 'E:\DR20\minidb_dr20\casload_20260114\minidb_dr20.dr20_lamost_dr6.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR='|',  -- PIPE DELIMITER (not comma)
    ROWTERMINATOR='0x0a',
    TABLOCK
    -- NO FIELDQUOTE needed with pipe delimiters
);
GO

SELECT 'dr20_lamost_dr6', COUNT(*) AS row_count FROM dbo.dr20_lamost_dr6;
GO

-------------------------------------------------
-- Summary
-------------------------------------------------
PRINT '';
PRINT '========================================';
PRINT 'All 6 files loaded successfully';
PRINT 'Completed: ' + CONVERT(varchar, GETDATE(), 120);
PRINT '========================================';
GO

-- Final row count summary
PRINT '';
PRINT 'Final row counts:';
GO

SELECT
    'dr20_gaiadr2_tmass_best_neighbour' AS table_name,
    COUNT(*) AS row_count
FROM dbo.dr20_gaiadr2_tmass_best_neighbour
UNION ALL
SELECT
    'dr20_gaia_dr2_source',
    COUNT(*)
FROM dbo.dr20_gaia_dr2_source
UNION ALL
SELECT
    'dr20_gaia_dr3_astrophysical_parameters',
    COUNT(*)
FROM dbo.dr20_gaia_dr3_astrophysical_parameters
UNION ALL
SELECT
    'dr20_gaia_dr3_source',
    COUNT(*)
FROM dbo.dr20_gaia_dr3_source
UNION ALL
SELECT
    'dr20_gaia_dr3_synthetic_photometry_gspc',
    COUNT(*)
FROM dbo.dr20_gaia_dr3_synthetic_photometry_gspc
UNION ALL
SELECT
    'dr20_lamost_dr6',
    COUNT(*)
FROM dbo.dr20_lamost_dr6;
GO
