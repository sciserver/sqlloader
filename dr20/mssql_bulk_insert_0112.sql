-- DR20 Bulk Insert Statements
-- Generated: 2026-01-12 12:00:33
-- Files validated: 3/5
-- Test mode: First 10 rows passed

-- WARNING: 2 files failed validation
-- Review test_results_0112.md before proceeding

-- Total data volume: ~544.9 MB validated

================================================================================

-- File: minidb_dr20.dr20_field.csv (28.2 MB)
-- Table: dbo.dr20_field
-- Delimiter: pipe (|)
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_field
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_field.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR='|',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_field', COUNT(*) AS row_count FROM dbo.dr20_field;
GO


-- File: minidb_dr20.dr20_gaia_dr3_vari_rrlyrae.csv (152.1 MB)
-- Table: dbo.dr20_gaia_dr3_vari_rrlyrae
-- Delimiter: pipe (|)
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_dr3_vari_rrlyrae
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_dr3_vari_rrlyrae.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR='|',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_dr3_vari_rrlyrae', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr3_vari_rrlyrae;
GO


-- File: minidb_dr20.dr20_sdss_apogeeallstarmerge_r13.csv (364.7 MB)
-- Table: dbo.dr20_sdss_apogeeallstarmerge_r13
-- Delimiter: pipe (|)
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_apogeeallstarmerge_r13
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_apogeeallstarmerge_r13.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR='|',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_apogeeallstarmerge_r13', COUNT(*) AS row_count FROM dbo.dr20_sdss_apogeeallstarmerge_r13;
GO



-- SUMMARY
-- Total files: 3
-- Total size: ~544.9 MB
-- Failed files: 2 (see test_results_0112.md)
