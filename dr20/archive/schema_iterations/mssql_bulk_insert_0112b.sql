-- DR20 Bulk Insert Statements
-- Generated: 2026-01-12 12:09:23
-- Files validated: 5/5
-- Test mode: First 10 rows passed

-- Total data volume: ~6454.9 MB validated

================================================================================

-- File: minidb_dr20.dr20_allstar_dr17_synspec_rev1.csv (5581.7 MB)
-- Table: dbo.dr20_allstar_dr17_synspec_rev1
-- Delimiter: pipe (|)
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_allstar_dr17_synspec_rev1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_allstar_dr17_synspec_rev1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR='|',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_allstar_dr17_synspec_rev1', COUNT(*) AS row_count FROM dbo.dr20_allstar_dr17_synspec_rev1;
GO


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


-- File: minidb_dr20.dr20_gaia_dr3_nss_two_body_orbit.csv (328.3 MB)
-- Table: dbo.dr20_gaia_dr3_nss_two_body_orbit
-- Delimiter: pipe (|)
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_dr3_nss_two_body_orbit
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_dr3_nss_two_body_orbit.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR='|',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_dr3_nss_two_body_orbit', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr3_nss_two_body_orbit;
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
-- Total files: 5
-- Total size: ~6454.9 MB
