-- DR20 Bulk Insert Statements
-- Generated: 2025-12-17 12:57:37
-- Files validated: 157/171
-- Test mode: First 10 rows passed

-- WARNING: 14 files failed validation
-- Review test_results_1217.md before proceeding

-- Total data volume: ~801583.7 MB validated

================================================================================

-- File: minidb_dr20.dr20_allwise.csv (96905.9 MB)
-- Table: dbo.dr20_allwise
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_allwise
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_allwise.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_allwise', COUNT(*) AS row_count FROM dbo.dr20_allwise;
GO


-- File: minidb_dr20.dr20_assignment.csv (9715.0 MB)
-- Table: dbo.dr20_assignment
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_assignment
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_assignment.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_assignment', COUNT(*) AS row_count FROM dbo.dr20_assignment;
GO


-- File: minidb_dr20.dr20_bailer_jones_edr3.csv (5242.9 MB)
-- Table: dbo.dr20_bailer_jones_edr3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bailer_jones_edr3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bailer_jones_edr3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bailer_jones_edr3', COUNT(*) AS row_count FROM dbo.dr20_bailer_jones_edr3;
GO


-- File: minidb_dr20.dr20_best_brightest.csv (180.9 MB)
-- Table: dbo.dr20_best_brightest
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_best_brightest
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_best_brightest.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_best_brightest', COUNT(*) AS row_count FROM dbo.dr20_best_brightest;
GO


-- File: minidb_dr20.dr20_bhm_csc.csv (9.4 MB)
-- Table: dbo.dr20_bhm_csc
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_csc
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_csc.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_csc', COUNT(*) AS row_count FROM dbo.dr20_bhm_csc;
GO


-- File: minidb_dr20.dr20_bhm_csc_v2.csv (27.8 MB)
-- Table: dbo.dr20_bhm_csc_v2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_csc_v2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_csc_v2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_csc_v2', COUNT(*) AS row_count FROM dbo.dr20_bhm_csc_v2;
GO


-- File: minidb_dr20.dr20_bhm_csc_v3.csv (39.7 MB)
-- Table: dbo.dr20_bhm_csc_v3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_csc_v3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_csc_v3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_csc_v3', COUNT(*) AS row_count FROM dbo.dr20_bhm_csc_v3;
GO


-- File: minidb_dr20.dr20_bhm_efeds_veto.csv (2.0 MB)
-- Table: dbo.dr20_bhm_efeds_veto
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_efeds_veto
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_efeds_veto.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_efeds_veto', COUNT(*) AS row_count FROM dbo.dr20_bhm_efeds_veto;
GO


-- File: minidb_dr20.dr20_bhm_rm_tweaks.csv (0.2 MB)
-- Table: dbo.dr20_bhm_rm_tweaks
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_rm_tweaks
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_rm_tweaks.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_rm_tweaks', COUNT(*) AS row_count FROM dbo.dr20_bhm_rm_tweaks;
GO


-- File: minidb_dr20.dr20_bhm_rm_v0.csv (284.7 MB)
-- Table: dbo.dr20_bhm_rm_v0
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_rm_v0
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_rm_v0.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_rm_v0', COUNT(*) AS row_count FROM dbo.dr20_bhm_rm_v0;
GO


-- File: minidb_dr20.dr20_bhm_rm_v0_2.csv (284.7 MB)
-- Table: dbo.dr20_bhm_rm_v0_2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_rm_v0_2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_rm_v0_2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_rm_v0_2', COUNT(*) AS row_count FROM dbo.dr20_bhm_rm_v0_2;
GO


-- File: minidb_dr20.dr20_bhm_rm_v1.csv (1.0 MB)
-- Table: dbo.dr20_bhm_rm_v1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_rm_v1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_rm_v1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_rm_v1', COUNT(*) AS row_count FROM dbo.dr20_bhm_rm_v1;
GO


-- File: minidb_dr20.dr20_bhm_rm_v1_1.csv (1.1 MB)
-- Table: dbo.dr20_bhm_rm_v1_1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_rm_v1_1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_rm_v1_1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_rm_v1_1', COUNT(*) AS row_count FROM dbo.dr20_bhm_rm_v1_1;
GO


-- File: minidb_dr20.dr20_bhm_rm_v1_3.csv (1.1 MB)
-- Table: dbo.dr20_bhm_rm_v1_3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_rm_v1_3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_rm_v1_3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_rm_v1_3', COUNT(*) AS row_count FROM dbo.dr20_bhm_rm_v1_3;
GO


-- File: minidb_dr20.dr20_bhm_spiders_agn_superset.csv (6.2 MB)
-- Table: dbo.dr20_bhm_spiders_agn_superset
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_spiders_agn_superset
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_spiders_agn_superset.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_spiders_agn_superset', COUNT(*) AS row_count FROM dbo.dr20_bhm_spiders_agn_superset;
GO


-- File: minidb_dr20.dr20_bhm_spiders_clusters_superset.csv (3.9 MB)
-- Table: dbo.dr20_bhm_spiders_clusters_superset
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_bhm_spiders_clusters_superset
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_bhm_spiders_clusters_superset.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_bhm_spiders_clusters_superset', COUNT(*) AS row_count FROM dbo.dr20_bhm_spiders_clusters_superset;
GO


-- File: minidb_dr20.dr20_cadence.csv (0.5 MB)
-- Table: dbo.dr20_cadence
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_cadence
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_cadence.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_cadence', COUNT(*) AS row_count FROM dbo.dr20_cadence;
GO


-- File: minidb_dr20.dr20_cadence_epoch.csv (17.4 MB)
-- Table: dbo.dr20_cadence_epoch
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_cadence_epoch
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_cadence_epoch.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_cadence_epoch', COUNT(*) AS row_count FROM dbo.dr20_cadence_epoch;
GO


-- File: minidb_dr20.dr20_carton.csv (0.0 MB)
-- Table: dbo.dr20_carton
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_carton
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_carton.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_carton', COUNT(*) AS row_count FROM dbo.dr20_carton;
GO


-- File: minidb_dr20.dr20_carton_to_target.csv (17077.0 MB)
-- Table: dbo.dr20_carton_to_target
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_carton_to_target
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_carton_to_target.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_carton_to_target', COUNT(*) AS row_count FROM dbo.dr20_carton_to_target;
GO


-- File: minidb_dr20.dr20_cataclysmic_variables.csv (4.1 MB)
-- Table: dbo.dr20_cataclysmic_variables
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_cataclysmic_variables
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_cataclysmic_variables.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_cataclysmic_variables', COUNT(*) AS row_count FROM dbo.dr20_cataclysmic_variables;
GO


-- File: minidb_dr20.dr20_catalog.csv (22334.6 MB)
-- Table: dbo.dr20_catalog
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog', COUNT(*) AS row_count FROM dbo.dr20_catalog;
GO


-- File: minidb_dr20.dr20_catalog_from_sdss_dr19p_speclite.csv (189.8 MB)
-- Table: dbo.dr20_catalog_from_sdss_dr19p_speclite
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_from_sdss_dr19p_speclite
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_from_sdss_dr19p_speclite.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_from_sdss_dr19p_speclite', COUNT(*) AS row_count FROM dbo.dr20_catalog_from_sdss_dr19p_speclite;
GO


-- File: minidb_dr20.dr20_catalog_to_allstar_dr17_synspec_rev1.csv (55.1 MB)
-- Table: dbo.dr20_catalog_to_allstar_dr17_synspec_rev1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_allstar_dr17_synspec_rev1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_allstar_dr17_synspec_rev1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_allstar_dr17_synspec_rev1', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_allstar_dr17_synspec_rev1;
GO


-- File: minidb_dr20.dr20_catalog_to_allwise.csv (7267.3 MB)
-- Table: dbo.dr20_catalog_to_allwise
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_allwise
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_allwise.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_allwise', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_allwise;
GO


-- File: minidb_dr20.dr20_catalog_to_bhm_csc.csv (8.1 MB)
-- Table: dbo.dr20_catalog_to_bhm_csc
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_bhm_csc
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_bhm_csc.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_bhm_csc', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_bhm_csc;
GO


-- File: minidb_dr20.dr20_catalog_to_bhm_efeds_veto.csv (0.5 MB)
-- Table: dbo.dr20_catalog_to_bhm_efeds_veto
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_bhm_efeds_veto
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_bhm_efeds_veto.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_bhm_efeds_veto', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_bhm_efeds_veto;
GO


-- File: minidb_dr20.dr20_catalog_to_bhm_rm_v0.csv (9.4 MB)
-- Table: dbo.dr20_catalog_to_bhm_rm_v0
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_bhm_rm_v0
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_bhm_rm_v0.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_bhm_rm_v0', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_bhm_rm_v0;
GO


-- File: minidb_dr20.dr20_catalog_to_bhm_rm_v0_2.csv (9.4 MB)
-- Table: dbo.dr20_catalog_to_bhm_rm_v0_2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_bhm_rm_v0_2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_bhm_rm_v0_2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_bhm_rm_v0_2', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_bhm_rm_v0_2;
GO


-- File: minidb_dr20.dr20_catalog_to_catwise2020.csv (4380.9 MB)
-- Table: dbo.dr20_catalog_to_catwise2020
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_catwise2020
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_catwise2020.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_catwise2020', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_catwise2020;
GO


-- File: minidb_dr20.dr20_catalog_to_gaia_dr2_source.csv (7323.2 MB)
-- Table: dbo.dr20_catalog_to_gaia_dr2_source
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_gaia_dr2_source
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_gaia_dr2_source.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_gaia_dr2_source', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_gaia_dr2_source;
GO


-- File: minidb_dr20.dr20_catalog_to_gaia_dr3_source.csv (2815.4 MB)
-- Table: dbo.dr20_catalog_to_gaia_dr3_source
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_gaia_dr3_source
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_gaia_dr3_source.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_gaia_dr3_source', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_gaia_dr3_source;
GO


-- File: minidb_dr20.dr20_catalog_to_glimpse.csv (297.6 MB)
-- Table: dbo.dr20_catalog_to_glimpse
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_glimpse
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_glimpse.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_glimpse', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_glimpse;
GO


-- File: minidb_dr20.dr20_catalog_to_guvcat.csv (2407.7 MB)
-- Table: dbo.dr20_catalog_to_guvcat
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_guvcat
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_guvcat.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_guvcat', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_guvcat;
GO


-- File: minidb_dr20.dr20_catalog_to_legacy_survey_dr10.csv (1532.1 MB)
-- Table: dbo.dr20_catalog_to_legacy_survey_dr10
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_legacy_survey_dr10
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_legacy_survey_dr10.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_legacy_survey_dr10', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_legacy_survey_dr10;
GO


-- File: minidb_dr20.dr20_catalog_to_legacy_survey_dr8.csv (3255.1 MB)
-- Table: dbo.dr20_catalog_to_legacy_survey_dr8
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_legacy_survey_dr8
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_legacy_survey_dr8.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_legacy_survey_dr8', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_legacy_survey_dr8;
GO


-- File: minidb_dr20.dr20_catalog_to_mangatarget.csv (1.7 MB)
-- Table: dbo.dr20_catalog_to_mangatarget
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_mangatarget
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_mangatarget.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_mangatarget', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_mangatarget;
GO


-- File: minidb_dr20.dr20_catalog_to_marvels_dr11_star.csv (0.4 MB)
-- Table: dbo.dr20_catalog_to_marvels_dr11_star
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_marvels_dr11_star
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_marvels_dr11_star.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_marvels_dr11_star', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_marvels_dr11_star;
GO


-- File: minidb_dr20.dr20_catalog_to_marvels_dr12_star.csv (0.4 MB)
-- Table: dbo.dr20_catalog_to_marvels_dr12_star
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_marvels_dr12_star
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_marvels_dr12_star.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_marvels_dr12_star', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_marvels_dr12_star;
GO


-- File: minidb_dr20.dr20_catalog_to_mastar_goodstars.csv (1.6 MB)
-- Table: dbo.dr20_catalog_to_mastar_goodstars
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_mastar_goodstars
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_mastar_goodstars.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_mastar_goodstars', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_mastar_goodstars;
GO


-- File: minidb_dr20.dr20_catalog_to_milliquas_7_7.csv (65.8 MB)
-- Table: dbo.dr20_catalog_to_milliquas_7_7
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_milliquas_7_7
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_milliquas_7_7.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_milliquas_7_7', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_milliquas_7_7;
GO


-- File: minidb_dr20.dr20_catalog_to_panstarrs1.csv (4576.3 MB)
-- Table: dbo.dr20_catalog_to_panstarrs1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_panstarrs1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_panstarrs1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_panstarrs1', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_panstarrs1;
GO


-- File: minidb_dr20.dr20_catalog_to_sdss_dr13_photoobj_primary.csv (2932.4 MB)
-- Table: dbo.dr20_catalog_to_sdss_dr13_photoobj_primary
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_sdss_dr13_photoobj_primary
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_sdss_dr13_photoobj_primary.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_sdss_dr13_photoobj_primary', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_sdss_dr13_photoobj_primary;
GO


-- File: minidb_dr20.dr20_catalog_to_sdss_dr16_specobj.csv (407.8 MB)
-- Table: dbo.dr20_catalog_to_sdss_dr16_specobj
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_sdss_dr16_specobj
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_sdss_dr16_specobj.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_sdss_dr16_specobj', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_sdss_dr16_specobj;
GO


-- File: minidb_dr20.dr20_catalog_to_sdss_dr17_specobj.csv (290.4 MB)
-- Table: dbo.dr20_catalog_to_sdss_dr17_specobj
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_sdss_dr17_specobj
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_sdss_dr17_specobj.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_sdss_dr17_specobj', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_sdss_dr17_specobj;
GO


-- File: minidb_dr20.dr20_catalog_to_skies_v1.csv (640.5 MB)
-- Table: dbo.dr20_catalog_to_skies_v1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_skies_v1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_skies_v1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_skies_v1', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_skies_v1;
GO


-- File: minidb_dr20.dr20_catalog_to_skies_v2.csv (844.5 MB)
-- Table: dbo.dr20_catalog_to_skies_v2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_skies_v2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_skies_v2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_skies_v2', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_skies_v2;
GO


-- File: minidb_dr20.dr20_catalog_to_skymapper_dr2.csv (1222.2 MB)
-- Table: dbo.dr20_catalog_to_skymapper_dr2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_skymapper_dr2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_skymapper_dr2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_skymapper_dr2', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_skymapper_dr2;
GO


-- File: minidb_dr20.dr20_catalog_to_supercosmos.csv (4028.4 MB)
-- Table: dbo.dr20_catalog_to_supercosmos
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_supercosmos
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_supercosmos.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_supercosmos', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_supercosmos;
GO


-- File: minidb_dr20.dr20_catalog_to_tic_v8.csv (6048.0 MB)
-- Table: dbo.dr20_catalog_to_tic_v8
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_tic_v8
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_tic_v8.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_tic_v8', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_tic_v8;
GO


-- File: minidb_dr20.dr20_catalog_to_twomass_psc.csv (5099.4 MB)
-- Table: dbo.dr20_catalog_to_twomass_psc
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_twomass_psc
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_twomass_psc.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_twomass_psc', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_twomass_psc;
GO


-- File: minidb_dr20.dr20_catalog_to_tycho2.csv (252.3 MB)
-- Table: dbo.dr20_catalog_to_tycho2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_tycho2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_tycho2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_tycho2', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_tycho2;
GO


-- File: minidb_dr20.dr20_catalog_to_unwise.csv (4413.4 MB)
-- Table: dbo.dr20_catalog_to_unwise
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_unwise
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_unwise.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_unwise', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_unwise;
GO


-- File: minidb_dr20.dr20_catalog_to_uvotssc1.csv (321.3 MB)
-- Table: dbo.dr20_catalog_to_uvotssc1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_uvotssc1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_uvotssc1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_uvotssc1', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_uvotssc1;
GO


-- File: minidb_dr20.dr20_catalog_to_xmm_om_suss_4_1.csv (94.0 MB)
-- Table: dbo.dr20_catalog_to_xmm_om_suss_4_1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_xmm_om_suss_4_1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_xmm_om_suss_4_1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_xmm_om_suss_4_1', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_xmm_om_suss_4_1;
GO


-- File: minidb_dr20.dr20_catalog_to_xmm_om_suss_5_0.csv (53.8 MB)
-- Table: dbo.dr20_catalog_to_xmm_om_suss_5_0
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catalog_to_xmm_om_suss_5_0
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catalog_to_xmm_om_suss_5_0.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catalog_to_xmm_om_suss_5_0', COUNT(*) AS row_count FROM dbo.dr20_catalog_to_xmm_om_suss_5_0;
GO


-- File: minidb_dr20.dr20_category.csv (0.0 MB)
-- Table: dbo.dr20_category
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_category
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_category.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_category', COUNT(*) AS row_count FROM dbo.dr20_category;
GO


-- File: minidb_dr20.dr20_catwise2020.csv (77186.5 MB)
-- Table: dbo.dr20_catwise2020
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_catwise2020
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_catwise2020.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_catwise2020', COUNT(*) AS row_count FROM dbo.dr20_catwise2020;
GO


-- File: minidb_dr20.dr20_design.csv (49.2 MB)
-- Table: dbo.dr20_design
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_design
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_design.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_design', COUNT(*) AS row_count FROM dbo.dr20_design;
GO


-- File: minidb_dr20.dr20_design_mode.csv (0.0 MB)
-- Table: dbo.dr20_design_mode
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_design_mode
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_design_mode.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_design_mode', COUNT(*) AS row_count FROM dbo.dr20_design_mode;
GO


-- File: minidb_dr20.dr20_design_mode_check_results.csv (74.5 MB)
-- Table: dbo.dr20_design_mode_check_results
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_design_mode_check_results
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_design_mode_check_results.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_design_mode_check_results', COUNT(*) AS row_count FROM dbo.dr20_design_mode_check_results;
GO


-- File: minidb_dr20.dr20_design_to_field.csv (18.7 MB)
-- Table: dbo.dr20_design_to_field
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_design_to_field
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_design_to_field.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_design_to_field', COUNT(*) AS row_count FROM dbo.dr20_design_to_field;
GO


-- File: minidb_dr20.dr20_ebosstarget_v5.csv (1691.1 MB)
-- Table: dbo.dr20_ebosstarget_v5
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_ebosstarget_v5
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_ebosstarget_v5.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_ebosstarget_v5', COUNT(*) AS row_count FROM dbo.dr20_ebosstarget_v5;
GO


-- File: minidb_dr20.dr20_erosita_superset_agn.csv (725.1 MB)
-- Table: dbo.dr20_erosita_superset_agn
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_erosita_superset_agn
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_erosita_superset_agn.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_erosita_superset_agn', COUNT(*) AS row_count FROM dbo.dr20_erosita_superset_agn;
GO


-- File: minidb_dr20.dr20_erosita_superset_clusters.csv (80.5 MB)
-- Table: dbo.dr20_erosita_superset_clusters
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_erosita_superset_clusters
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_erosita_superset_clusters.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_erosita_superset_clusters', COUNT(*) AS row_count FROM dbo.dr20_erosita_superset_clusters;
GO


-- File: minidb_dr20.dr20_erosita_superset_compactobjects.csv (32.4 MB)
-- Table: dbo.dr20_erosita_superset_compactobjects
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_erosita_superset_compactobjects
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_erosita_superset_compactobjects.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_erosita_superset_compactobjects', COUNT(*) AS row_count FROM dbo.dr20_erosita_superset_compactobjects;
GO


-- File: minidb_dr20.dr20_erosita_superset_stars.csv (64.5 MB)
-- Table: dbo.dr20_erosita_superset_stars
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_erosita_superset_stars
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_erosita_superset_stars.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_erosita_superset_stars', COUNT(*) AS row_count FROM dbo.dr20_erosita_superset_stars;
GO


-- File: minidb_dr20.dr20_erosita_superset_v1_agn.csv (1705.9 MB)
-- Table: dbo.dr20_erosita_superset_v1_agn
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_erosita_superset_v1_agn
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_erosita_superset_v1_agn.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_erosita_superset_v1_agn', COUNT(*) AS row_count FROM dbo.dr20_erosita_superset_v1_agn;
GO


-- File: minidb_dr20.dr20_erosita_superset_v1_clusters.csv (95.0 MB)
-- Table: dbo.dr20_erosita_superset_v1_clusters
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_erosita_superset_v1_clusters
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_erosita_superset_v1_clusters.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_erosita_superset_v1_clusters', COUNT(*) AS row_count FROM dbo.dr20_erosita_superset_v1_clusters;
GO


-- File: minidb_dr20.dr20_erosita_superset_v1_compactobjects.csv (3.1 MB)
-- Table: dbo.dr20_erosita_superset_v1_compactobjects
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_erosita_superset_v1_compactobjects
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_erosita_superset_v1_compactobjects.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_erosita_superset_v1_compactobjects', COUNT(*) AS row_count FROM dbo.dr20_erosita_superset_v1_compactobjects;
GO


-- File: minidb_dr20.dr20_erosita_superset_v1_stars.csv (103.7 MB)
-- Table: dbo.dr20_erosita_superset_v1_stars
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_erosita_superset_v1_stars
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_erosita_superset_v1_stars.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_erosita_superset_v1_stars', COUNT(*) AS row_count FROM dbo.dr20_erosita_superset_v1_stars;
GO


-- File: minidb_dr20.dr20_gaia_assas_sn_cepheids.csv (2.0 MB)
-- Table: dbo.dr20_gaia_assas_sn_cepheids
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_assas_sn_cepheids
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_assas_sn_cepheids.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_assas_sn_cepheids', COUNT(*) AS row_count FROM dbo.dr20_gaia_assas_sn_cepheids;
GO


-- File: minidb_dr20.dr20_gaia_dr2_ruwe.csv (1764.6 MB)
-- Table: dbo.dr20_gaia_dr2_ruwe
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_dr2_ruwe
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_dr2_ruwe.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_dr2_ruwe', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr2_ruwe;
GO


-- File: minidb_dr20.dr20_gaia_dr2_source.csv (5431.4 MB)
-- Table: dbo.dr20_gaia_dr2_source
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_dr2_source
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_dr2_source.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_dr2_source', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr2_source;
GO


-- File: minidb_dr20.dr20_gaia_dr2_wd.csv (151.4 MB)
-- Table: dbo.dr20_gaia_dr2_wd
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_dr2_wd
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_dr2_wd.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_dr2_wd', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr2_wd;
GO


-- File: minidb_dr20.dr20_gaia_dr3_astrophysical_parameters.csv (5781.3 MB)
-- Table: dbo.dr20_gaia_dr3_astrophysical_parameters
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_dr3_astrophysical_parameters
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_dr3_astrophysical_parameters.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_dr3_astrophysical_parameters', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr3_astrophysical_parameters;
GO


-- File: minidb_dr20.dr20_gaia_dr3_source.csv (4065.7 MB)
-- Table: dbo.dr20_gaia_dr3_source
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_dr3_source
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_dr3_source.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_dr3_source', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr3_source;
GO


-- File: minidb_dr20.dr20_gaia_dr3_synthetic_photometry_gspc.csv (4533.2 MB)
-- Table: dbo.dr20_gaia_dr3_synthetic_photometry_gspc
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_dr3_synthetic_photometry_gspc
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_dr3_synthetic_photometry_gspc.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_dr3_synthetic_photometry_gspc', COUNT(*) AS row_count FROM dbo.dr20_gaia_dr3_synthetic_photometry_gspc;
GO


-- File: minidb_dr20.dr20_gaia_unwise_agn.csv (1251.3 MB)
-- Table: dbo.dr20_gaia_unwise_agn
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaia_unwise_agn
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaia_unwise_agn.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaia_unwise_agn', COUNT(*) AS row_count FROM dbo.dr20_gaia_unwise_agn;
GO


-- File: minidb_dr20.dr20_gaiadr2_tmass_best_neighbour.csv (3099.2 MB)
-- Table: dbo.dr20_gaiadr2_tmass_best_neighbour
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gaiadr2_tmass_best_neighbour
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gaiadr2_tmass_best_neighbour.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gaiadr2_tmass_best_neighbour', COUNT(*) AS row_count FROM dbo.dr20_gaiadr2_tmass_best_neighbour;
GO


-- File: minidb_dr20.dr20_galah_dr3.csv (794.3 MB)
-- Table: dbo.dr20_galah_dr3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_galah_dr3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_galah_dr3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_galah_dr3', COUNT(*) AS row_count FROM dbo.dr20_galah_dr3;
GO


-- File: minidb_dr20.dr20_galex_gr7_gaia_dr3.csv (1688.4 MB)
-- Table: dbo.dr20_galex_gr7_gaia_dr3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_galex_gr7_gaia_dr3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_galex_gr7_gaia_dr3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_galex_gr7_gaia_dr3', COUNT(*) AS row_count FROM dbo.dr20_galex_gr7_gaia_dr3;
GO


-- File: minidb_dr20.dr20_gedr3spur_main.csv (3925.6 MB)
-- Table: dbo.dr20_gedr3spur_main
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_gedr3spur_main
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_gedr3spur_main.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_gedr3spur_main', COUNT(*) AS row_count FROM dbo.dr20_gedr3spur_main;
GO


-- File: minidb_dr20.dr20_geometric_distances_gaia_dr2.csv (3508.6 MB)
-- Table: dbo.dr20_geometric_distances_gaia_dr2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_geometric_distances_gaia_dr2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_geometric_distances_gaia_dr2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_geometric_distances_gaia_dr2', COUNT(*) AS row_count FROM dbo.dr20_geometric_distances_gaia_dr2;
GO


-- File: minidb_dr20.dr20_glimpse.csv (1419.5 MB)
-- Table: dbo.dr20_glimpse
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_glimpse
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_glimpse.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_glimpse', COUNT(*) AS row_count FROM dbo.dr20_glimpse;
GO


-- File: minidb_dr20.dr20_guvcat.csv (8459.8 MB)
-- Table: dbo.dr20_guvcat
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_guvcat
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_guvcat.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_guvcat', COUNT(*) AS row_count FROM dbo.dr20_guvcat;
GO


-- File: minidb_dr20.dr20_hecate_1_1.csv (84.9 MB)
-- Table: dbo.dr20_hecate_1_1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_hecate_1_1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_hecate_1_1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_hecate_1_1', COUNT(*) AS row_count FROM dbo.dr20_hecate_1_1;
GO


-- File: minidb_dr20.dr20_hole.csv (0.0 MB)
-- Table: dbo.dr20_hole
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_hole
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_hole.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_hole', COUNT(*) AS row_count FROM dbo.dr20_hole;
GO


-- File: minidb_dr20.dr20_lamost_dr6.csv (3090.6 MB)
-- Table: dbo.dr20_lamost_dr6
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_lamost_dr6
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_lamost_dr6.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_lamost_dr6', COUNT(*) AS row_count FROM dbo.dr20_lamost_dr6;
GO


-- File: minidb_dr20.dr20_legacy_survey_dr10.csv (37153.5 MB)
-- Table: dbo.dr20_legacy_survey_dr10
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_legacy_survey_dr10
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_legacy_survey_dr10.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_legacy_survey_dr10', COUNT(*) AS row_count FROM dbo.dr20_legacy_survey_dr10;
GO


-- File: minidb_dr20.dr20_legacy_survey_dr8.csv (25847.0 MB)
-- Table: dbo.dr20_legacy_survey_dr8
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_legacy_survey_dr8
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_legacy_survey_dr8.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_legacy_survey_dr8', COUNT(*) AS row_count FROM dbo.dr20_legacy_survey_dr8;
GO


-- File: minidb_dr20.dr20_magnitude.csv (25976.4 MB)
-- Table: dbo.dr20_magnitude
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_magnitude
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_magnitude.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_magnitude', COUNT(*) AS row_count FROM dbo.dr20_magnitude;
GO


-- File: minidb_dr20.dr20_mangadapall.csv (324.7 MB)
-- Table: dbo.dr20_mangadapall
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_mangadapall
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_mangadapall.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_mangadapall', COUNT(*) AS row_count FROM dbo.dr20_mangadapall;
GO


-- File: minidb_dr20.dr20_mangadrpall.csv (14.2 MB)
-- Table: dbo.dr20_mangadrpall
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_mangadrpall
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_mangadrpall.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_mangadrpall', COUNT(*) AS row_count FROM dbo.dr20_mangadrpall;
GO


-- File: minidb_dr20.dr20_mangatarget.csv (63.6 MB)
-- Table: dbo.dr20_mangatarget
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_mangatarget
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_mangatarget.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_mangatarget', COUNT(*) AS row_count FROM dbo.dr20_mangatarget;
GO


-- File: minidb_dr20.dr20_marvels_dr11_star.csv (2.5 MB)
-- Table: dbo.dr20_marvels_dr11_star
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_marvels_dr11_star
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_marvels_dr11_star.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_marvels_dr11_star', COUNT(*) AS row_count FROM dbo.dr20_marvels_dr11_star;
GO


-- File: minidb_dr20.dr20_marvels_dr12_star.csv (3.9 MB)
-- Table: dbo.dr20_marvels_dr12_star
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_marvels_dr12_star
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_marvels_dr12_star.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_marvels_dr12_star', COUNT(*) AS row_count FROM dbo.dr20_marvels_dr12_star;
GO


-- File: minidb_dr20.dr20_mastar_goodstars.csv (3.8 MB)
-- Table: dbo.dr20_mastar_goodstars
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_mastar_goodstars
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_mastar_goodstars.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_mastar_goodstars', COUNT(*) AS row_count FROM dbo.dr20_mastar_goodstars;
GO


-- File: minidb_dr20.dr20_mastar_goodvisits.csv (15.8 MB)
-- Table: dbo.dr20_mastar_goodvisits
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_mastar_goodvisits
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_mastar_goodvisits.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_mastar_goodvisits', COUNT(*) AS row_count FROM dbo.dr20_mastar_goodvisits;
GO


-- File: minidb_dr20.dr20_milliquas_7_7.csv (153.5 MB)
-- Table: dbo.dr20_milliquas_7_7
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_milliquas_7_7
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_milliquas_7_7.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_milliquas_7_7', COUNT(*) AS row_count FROM dbo.dr20_milliquas_7_7;
GO


-- File: minidb_dr20.dr20_mipsgal.csv (385.0 MB)
-- Table: dbo.dr20_mipsgal
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_mipsgal
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_mipsgal.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_mipsgal', COUNT(*) AS row_count FROM dbo.dr20_mipsgal;
GO


-- File: minidb_dr20.dr20_mwm_tess_ob.csv (0.0 MB)
-- Table: dbo.dr20_mwm_tess_ob
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_mwm_tess_ob
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_mwm_tess_ob.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_mwm_tess_ob', COUNT(*) AS row_count FROM dbo.dr20_mwm_tess_ob;
GO


-- File: minidb_dr20.dr20_obsmode.csv (0.0 MB)
-- Table: dbo.dr20_obsmode
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_obsmode
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_obsmode.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_obsmode', COUNT(*) AS row_count FROM dbo.dr20_obsmode;
GO


-- File: minidb_dr20.dr20_opsdb_apo_camera_frame.csv (2.0 MB)
-- Table: dbo.dr20_opsdb_apo_camera_frame
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_apo_camera_frame
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_apo_camera_frame.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_apo_camera_frame', COUNT(*) AS row_count FROM dbo.dr20_opsdb_apo_camera_frame;
GO


-- File: minidb_dr20.dr20_opsdb_apo_configuration.csv (0.8 MB)
-- Table: dbo.dr20_opsdb_apo_configuration
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_apo_configuration
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_apo_configuration.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_apo_configuration', COUNT(*) AS row_count FROM dbo.dr20_opsdb_apo_configuration;
GO


-- File: minidb_dr20.dr20_opsdb_apo_design_to_status.csv (14.2 MB)
-- Table: dbo.dr20_opsdb_apo_design_to_status
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_apo_design_to_status
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_apo_design_to_status.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_apo_design_to_status', COUNT(*) AS row_count FROM dbo.dr20_opsdb_apo_design_to_status;
GO


-- File: minidb_dr20.dr20_opsdb_apo_exposure.csv (2.9 MB)
-- Table: dbo.dr20_opsdb_apo_exposure
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_apo_exposure
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_apo_exposure.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_apo_exposure', COUNT(*) AS row_count FROM dbo.dr20_opsdb_apo_exposure;
GO


-- File: minidb_dr20.dr20_opsdb_apo_exposure_flavor.csv (0.0 MB)
-- Table: dbo.dr20_opsdb_apo_exposure_flavor
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_apo_exposure_flavor
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_apo_exposure_flavor.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_apo_exposure_flavor', COUNT(*) AS row_count FROM dbo.dr20_opsdb_apo_exposure_flavor;
GO


-- File: minidb_dr20.dr20_opsdb_lco_camera_frame.csv (1.5 MB)
-- Table: dbo.dr20_opsdb_lco_camera_frame
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_lco_camera_frame
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_lco_camera_frame.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_lco_camera_frame', COUNT(*) AS row_count FROM dbo.dr20_opsdb_lco_camera_frame;
GO


-- File: minidb_dr20.dr20_opsdb_lco_configuration.csv (0.6 MB)
-- Table: dbo.dr20_opsdb_lco_configuration
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_lco_configuration
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_lco_configuration.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_lco_configuration', COUNT(*) AS row_count FROM dbo.dr20_opsdb_lco_configuration;
GO


-- File: minidb_dr20.dr20_opsdb_lco_design_to_status.csv (14.2 MB)
-- Table: dbo.dr20_opsdb_lco_design_to_status
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_lco_design_to_status
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_lco_design_to_status.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_lco_design_to_status', COUNT(*) AS row_count FROM dbo.dr20_opsdb_lco_design_to_status;
GO


-- File: minidb_dr20.dr20_opsdb_lco_exposure.csv (0.8 MB)
-- Table: dbo.dr20_opsdb_lco_exposure
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_lco_exposure
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_lco_exposure.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_lco_exposure', COUNT(*) AS row_count FROM dbo.dr20_opsdb_lco_exposure;
GO


-- File: minidb_dr20.dr20_opsdb_lco_exposure_flavor.csv (0.0 MB)
-- Table: dbo.dr20_opsdb_lco_exposure_flavor
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_opsdb_lco_exposure_flavor
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_opsdb_lco_exposure_flavor.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_opsdb_lco_exposure_flavor', COUNT(*) AS row_count FROM dbo.dr20_opsdb_lco_exposure_flavor;
GO


-- File: minidb_dr20.dr20_panstarrs1.csv (69075.0 MB)
-- Table: dbo.dr20_panstarrs1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_panstarrs1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_panstarrs1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_panstarrs1', COUNT(*) AS row_count FROM dbo.dr20_panstarrs1;
GO


-- File: minidb_dr20.dr20_rave_dr6_gauguin_madera.csv (51.1 MB)
-- Table: dbo.dr20_rave_dr6_gauguin_madera
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_rave_dr6_gauguin_madera
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_rave_dr6_gauguin_madera.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_rave_dr6_gauguin_madera', COUNT(*) AS row_count FROM dbo.dr20_rave_dr6_gauguin_madera;
GO


-- File: minidb_dr20.dr20_rave_dr6_xgaiae3.csv (121.2 MB)
-- Table: dbo.dr20_rave_dr6_xgaiae3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_rave_dr6_xgaiae3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_rave_dr6_xgaiae3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_rave_dr6_xgaiae3', COUNT(*) AS row_count FROM dbo.dr20_rave_dr6_xgaiae3;
GO


-- File: minidb_dr20.dr20_revised_magnitude.csv (7068.2 MB)
-- Table: dbo.dr20_revised_magnitude
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_revised_magnitude
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_revised_magnitude.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_revised_magnitude', COUNT(*) AS row_count FROM dbo.dr20_revised_magnitude;
GO


-- File: minidb_dr20.dr20_sagitta.csv (18.4 MB)
-- Table: dbo.dr20_sagitta
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sagitta
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sagitta.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sagitta', COUNT(*) AS row_count FROM dbo.dr20_sagitta;
GO


-- File: minidb_dr20.dr20_sagitta_edr3.csv (19.0 MB)
-- Table: dbo.dr20_sagitta_edr3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sagitta_edr3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sagitta_edr3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sagitta_edr3', COUNT(*) AS row_count FROM dbo.dr20_sagitta_edr3;
GO


-- File: minidb_dr20.dr20_sdss_dr13_photoobj_primary.csv (1090.1 MB)
-- Table: dbo.dr20_sdss_dr13_photoobj_primary
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_dr13_photoobj_primary
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_dr13_photoobj_primary.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_dr13_photoobj_primary', COUNT(*) AS row_count FROM dbo.dr20_sdss_dr13_photoobj_primary;
GO


-- File: minidb_dr20.dr20_sdss_dr16_qso.csv (1156.8 MB)
-- Table: dbo.dr20_sdss_dr16_qso
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_dr16_qso
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_dr16_qso.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_dr16_qso', COUNT(*) AS row_count FROM dbo.dr20_sdss_dr16_qso;
GO


-- File: minidb_dr20.dr20_sdss_dr16_specobj.csv (6653.9 MB)
-- Table: dbo.dr20_sdss_dr16_specobj
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_dr16_specobj
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_dr16_specobj.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_dr16_specobj', COUNT(*) AS row_count FROM dbo.dr20_sdss_dr16_specobj;
GO


-- File: minidb_dr20.dr20_sdss_dr17_apogee_allstarmerge.csv (290.9 MB)
-- Table: dbo.dr20_sdss_dr17_apogee_allstarmerge
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_dr17_apogee_allstarmerge
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_dr17_apogee_allstarmerge.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_dr17_apogee_allstarmerge', COUNT(*) AS row_count FROM dbo.dr20_sdss_dr17_apogee_allstarmerge;
GO


-- File: minidb_dr20.dr20_sdss_dr17_specobj.csv (7454.3 MB)
-- Table: dbo.dr20_sdss_dr17_specobj
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_dr17_specobj
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_dr17_specobj.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_dr17_specobj', COUNT(*) AS row_count FROM dbo.dr20_sdss_dr17_specobj;
GO


-- File: minidb_dr20.dr20_sdss_dr19p_speclite.csv (1433.5 MB)
-- Table: dbo.dr20_sdss_dr19p_speclite
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_dr19p_speclite
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_dr19p_speclite.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_dr19p_speclite', COUNT(*) AS row_count FROM dbo.dr20_sdss_dr19p_speclite;
GO


-- File: minidb_dr20.dr20_sdss_id_flat.csv (30622.4 MB)
-- Table: dbo.dr20_sdss_id_flat
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_id_flat
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_id_flat.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_id_flat', COUNT(*) AS row_count FROM dbo.dr20_sdss_id_flat;
GO


-- File: minidb_dr20.dr20_sdss_id_stacked.csv (9829.7 MB)
-- Table: dbo.dr20_sdss_id_stacked
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_id_stacked
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_id_stacked.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_id_stacked', COUNT(*) AS row_count FROM dbo.dr20_sdss_id_stacked;
GO


-- File: minidb_dr20.dr20_sdss_id_to_catalog.csv (42689.3 MB)
-- Table: dbo.dr20_sdss_id_to_catalog
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdss_id_to_catalog
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdss_id_to_catalog.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdss_id_to_catalog', COUNT(*) AS row_count FROM dbo.dr20_sdss_id_to_catalog;
GO


-- File: minidb_dr20.dr20_sdssv_boss_conflist.csv (0.3 MB)
-- Table: dbo.dr20_sdssv_boss_conflist
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdssv_boss_conflist
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdssv_boss_conflist.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdssv_boss_conflist', COUNT(*) AS row_count FROM dbo.dr20_sdssv_boss_conflist;
GO


-- File: minidb_dr20.dr20_sdssv_boss_spall.csv (197.6 MB)
-- Table: dbo.dr20_sdssv_boss_spall
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdssv_boss_spall
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdssv_boss_spall.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdssv_boss_spall', COUNT(*) AS row_count FROM dbo.dr20_sdssv_boss_spall;
GO


-- File: minidb_dr20.dr20_sdssv_plateholes.csv (195.4 MB)
-- Table: dbo.dr20_sdssv_plateholes
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdssv_plateholes
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdssv_plateholes.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdssv_plateholes', COUNT(*) AS row_count FROM dbo.dr20_sdssv_plateholes;
GO


-- File: minidb_dr20.dr20_sdssv_plateholes_meta.csv (0.7 MB)
-- Table: dbo.dr20_sdssv_plateholes_meta
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_sdssv_plateholes_meta
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_sdssv_plateholes_meta.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_sdssv_plateholes_meta', COUNT(*) AS row_count FROM dbo.dr20_sdssv_plateholes_meta;
GO


-- File: minidb_dr20.dr20_skies_v1.csv (3250.6 MB)
-- Table: dbo.dr20_skies_v1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_skies_v1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_skies_v1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_skies_v1', COUNT(*) AS row_count FROM dbo.dr20_skies_v1;
GO


-- File: minidb_dr20.dr20_skies_v2.csv (3919.2 MB)
-- Table: dbo.dr20_skies_v2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_skies_v2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_skies_v2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_skies_v2', COUNT(*) AS row_count FROM dbo.dr20_skies_v2;
GO


-- File: minidb_dr20.dr20_skymapper_dr2.csv (16527.0 MB)
-- Table: dbo.dr20_skymapper_dr2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_skymapper_dr2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_skymapper_dr2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_skymapper_dr2', COUNT(*) AS row_count FROM dbo.dr20_skymapper_dr2;
GO


-- File: minidb_dr20.dr20_skymapper_gaia.csv (161.9 MB)
-- Table: dbo.dr20_skymapper_gaia
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_skymapper_gaia
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_skymapper_gaia.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_skymapper_gaia', COUNT(*) AS row_count FROM dbo.dr20_skymapper_gaia;
GO


-- File: minidb_dr20.dr20_supercosmos.csv (34644.2 MB)
-- Table: dbo.dr20_supercosmos
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_supercosmos
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_supercosmos.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_supercosmos', COUNT(*) AS row_count FROM dbo.dr20_supercosmos;
GO


-- File: minidb_dr20.dr20_target.csv (15807.3 MB)
-- Table: dbo.dr20_target
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_target
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_target.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_target', COUNT(*) AS row_count FROM dbo.dr20_target;
GO


-- File: minidb_dr20.dr20_targetdb_version.csv (0.0 MB)
-- Table: dbo.dr20_targetdb_version
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_targetdb_version
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_targetdb_version.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_targetdb_version', COUNT(*) AS row_count FROM dbo.dr20_targetdb_version;
GO


-- File: minidb_dr20.dr20_targeting_generation.csv (0.0 MB)
-- Table: dbo.dr20_targeting_generation
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_targeting_generation
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_targeting_generation.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_targeting_generation', COUNT(*) AS row_count FROM dbo.dr20_targeting_generation;
GO


-- File: minidb_dr20.dr20_targeting_generation_to_carton.csv (0.0 MB)
-- Table: dbo.dr20_targeting_generation_to_carton
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_targeting_generation_to_carton
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_targeting_generation_to_carton.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_targeting_generation_to_carton', COUNT(*) AS row_count FROM dbo.dr20_targeting_generation_to_carton;
GO


-- File: minidb_dr20.dr20_targeting_generation_to_version.csv (0.0 MB)
-- Table: dbo.dr20_targeting_generation_to_version
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_targeting_generation_to_version
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_targeting_generation_to_version.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_targeting_generation_to_version', COUNT(*) AS row_count FROM dbo.dr20_targeting_generation_to_version;
GO


-- File: minidb_dr20.dr20_tess_toi.csv (6.0 MB)
-- Table: dbo.dr20_tess_toi
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_tess_toi
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_tess_toi.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_tess_toi', COUNT(*) AS row_count FROM dbo.dr20_tess_toi;
GO


-- File: minidb_dr20.dr20_tess_toi_v05.csv (28.2 MB)
-- Table: dbo.dr20_tess_toi_v05
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_tess_toi_v05
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_tess_toi_v05.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_tess_toi_v05', COUNT(*) AS row_count FROM dbo.dr20_tess_toi_v05;
GO


-- File: minidb_dr20.dr20_tess_toi_v1.csv (42.9 MB)
-- Table: dbo.dr20_tess_toi_v1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_tess_toi_v1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_tess_toi_v1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_tess_toi_v1', COUNT(*) AS row_count FROM dbo.dr20_tess_toi_v1;
GO


-- File: minidb_dr20.dr20_tic_v8.csv (50517.9 MB)
-- Table: dbo.dr20_tic_v8
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_tic_v8
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_tic_v8.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_tic_v8', COUNT(*) AS row_count FROM dbo.dr20_tic_v8;
GO


-- File: minidb_dr20.dr20_twomass_psc.csv (17826.9 MB)
-- Table: dbo.dr20_twomass_psc
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_twomass_psc
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_twomass_psc.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_twomass_psc', COUNT(*) AS row_count FROM dbo.dr20_twomass_psc;
GO


-- File: minidb_dr20.dr20_tycho2.csv (498.6 MB)
-- Table: dbo.dr20_tycho2
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_tycho2
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_tycho2.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_tycho2', COUNT(*) AS row_count FROM dbo.dr20_tycho2;
GO


-- File: minidb_dr20.dr20_unwise.csv (39463.1 MB)
-- Table: dbo.dr20_unwise
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_unwise
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_unwise.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_unwise', COUNT(*) AS row_count FROM dbo.dr20_unwise;
GO


-- File: minidb_dr20.dr20_uvotssc1.csv (554.2 MB)
-- Table: dbo.dr20_uvotssc1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_uvotssc1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_uvotssc1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_uvotssc1', COUNT(*) AS row_count FROM dbo.dr20_uvotssc1;
GO


-- File: minidb_dr20.dr20_visual_binary_gaia_dr3.csv (3687.0 MB)
-- Table: dbo.dr20_visual_binary_gaia_dr3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_visual_binary_gaia_dr3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_visual_binary_gaia_dr3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_visual_binary_gaia_dr3', COUNT(*) AS row_count FROM dbo.dr20_visual_binary_gaia_dr3;
GO


-- File: minidb_dr20.dr20_wd_gaia_dr3.csv (319.6 MB)
-- Table: dbo.dr20_wd_gaia_dr3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_wd_gaia_dr3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_wd_gaia_dr3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_wd_gaia_dr3', COUNT(*) AS row_count FROM dbo.dr20_wd_gaia_dr3;
GO


-- File: minidb_dr20.dr20_xmm_om_suss_4_1.csv (439.1 MB)
-- Table: dbo.dr20_xmm_om_suss_4_1
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_xmm_om_suss_4_1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_xmm_om_suss_4_1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_xmm_om_suss_4_1', COUNT(*) AS row_count FROM dbo.dr20_xmm_om_suss_4_1;
GO


-- File: minidb_dr20.dr20_xmm_om_suss_5_0.csv (556.3 MB)
-- Table: dbo.dr20_xmm_om_suss_5_0
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_xmm_om_suss_5_0
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_xmm_om_suss_5_0.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_xmm_om_suss_5_0', COUNT(*) AS row_count FROM dbo.dr20_xmm_om_suss_5_0;
GO


-- File: minidb_dr20.dr20_xpfeh_gaia_dr3.csv (1313.1 MB)
-- Table: dbo.dr20_xpfeh_gaia_dr3
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_xpfeh_gaia_dr3
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_xpfeh_gaia_dr3.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_xpfeh_gaia_dr3', COUNT(*) AS row_count FROM dbo.dr20_xpfeh_gaia_dr3;
GO


-- File: minidb_dr20.dr20_yso_clustering.csv (195.9 MB)
-- Table: dbo.dr20_yso_clustering
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_yso_clustering
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_yso_clustering.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_yso_clustering', COUNT(*) AS row_count FROM dbo.dr20_yso_clustering;
GO


-- File: minidb_dr20.dr20_zari18pms.csv (7.0 MB)
-- Table: dbo.dr20_zari18pms
-- Test result: PASSED (10/10 rows)
BULK INSERT dbo.dr20_zari18pms
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_zari18pms.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_zari18pms', COUNT(*) AS row_count FROM dbo.dr20_zari18pms;
GO



-- SUMMARY
-- Total files: 157
-- Total size: ~801583.7 MB
-- Failed files: 14 (see test_results_1217.md)
