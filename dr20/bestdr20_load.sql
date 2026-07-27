-- ============================================================
-- Load data: minidb_dr20_v2 -> BestDR20
-- Run AFTER tables and PKs are created, BEFORE nonclustered indexes
-- For minimal logging: database recovery model must be SIMPLE
--   ALTER DATABASE BestDR20 SET RECOVERY SIMPLE;
-- ============================================================

USE BestDR20;
GO

SET NOCOUNT ON;
GO

PRINT 'Loading mos_allstar_dr17_synspec_rev1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_allstar_dr17_synspec_rev1;
INSERT INTO dbo.mos_allstar_dr17_synspec_rev1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_allstar_dr17_synspec_rev1;
GO

PRINT 'Loading mos_allwise... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_allwise;
INSERT INTO dbo.mos_allwise WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_allwise;
GO

PRINT 'Loading mos_assignment... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_assignment;
INSERT INTO dbo.mos_assignment WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_assignment;
GO

PRINT 'Loading mos_bailer_jones_edr3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bailer_jones_edr3;
INSERT INTO dbo.mos_bailer_jones_edr3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bailer_jones_edr3;
GO

PRINT 'Loading mos_best_brightest... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_best_brightest;
INSERT INTO dbo.mos_best_brightest WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_best_brightest;
GO

PRINT 'Loading mos_bhm_csc... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_csc;
INSERT INTO dbo.mos_bhm_csc WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_csc;
GO

PRINT 'Loading mos_bhm_csc_v2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_csc_v2;
INSERT INTO dbo.mos_bhm_csc_v2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_csc_v2;
GO

PRINT 'Loading mos_bhm_csc_v3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_csc_v3;
INSERT INTO dbo.mos_bhm_csc_v3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_csc_v3;
GO

PRINT 'Loading mos_bhm_efeds_veto... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_efeds_veto;
INSERT INTO dbo.mos_bhm_efeds_veto WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_efeds_veto;
GO

PRINT 'Loading mos_bhm_rm_tweaks... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_rm_tweaks;
INSERT INTO dbo.mos_bhm_rm_tweaks WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_rm_tweaks;
GO

PRINT 'Loading mos_bhm_rm_v0... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_rm_v0;
INSERT INTO dbo.mos_bhm_rm_v0 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_rm_v0;
GO

PRINT 'Loading mos_bhm_rm_v0_2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_rm_v0_2;
INSERT INTO dbo.mos_bhm_rm_v0_2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_rm_v0_2;
GO

PRINT 'Loading mos_bhm_rm_v1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_rm_v1;
INSERT INTO dbo.mos_bhm_rm_v1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_rm_v1;
GO

PRINT 'Loading mos_bhm_rm_v1_1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_rm_v1_1;
INSERT INTO dbo.mos_bhm_rm_v1_1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_rm_v1_1;
GO

PRINT 'Loading mos_bhm_rm_v1_3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_rm_v1_3;
INSERT INTO dbo.mos_bhm_rm_v1_3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_rm_v1_3;
GO

PRINT 'Loading mos_bhm_spiders_agn_superset... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_spiders_agn_superset;
INSERT INTO dbo.mos_bhm_spiders_agn_superset WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_spiders_agn_superset;
GO

PRINT 'Loading mos_bhm_spiders_clusters_superset... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_bhm_spiders_clusters_superset;
INSERT INTO dbo.mos_bhm_spiders_clusters_superset WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_bhm_spiders_clusters_superset;
GO

PRINT 'Loading mos_cadence... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_cadence;
INSERT INTO dbo.mos_cadence WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_cadence;
GO

PRINT 'Loading mos_cadence_epoch... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_cadence_epoch;
INSERT INTO dbo.mos_cadence_epoch WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_cadence_epoch;
GO

PRINT 'Loading mos_carton... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_carton;
INSERT INTO dbo.mos_carton WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_carton;
GO

PRINT 'Loading mos_carton_csv... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_carton_csv;
INSERT INTO dbo.mos_carton_csv WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_carton_csv;
GO

PRINT 'Loading mos_carton_to_target... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_carton_to_target;
INSERT INTO dbo.mos_carton_to_target WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_carton_to_target;
GO

PRINT 'Loading mos_cataclysmic_variables... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_cataclysmic_variables;
INSERT INTO dbo.mos_cataclysmic_variables WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_cataclysmic_variables;
GO

PRINT 'Loading mos_catalog... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog;
INSERT INTO dbo.mos_catalog WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog;
GO

PRINT 'Loading mos_catalog_from_sdss_dr19p_speclite... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_from_sdss_dr19p_speclite;
INSERT INTO dbo.mos_catalog_from_sdss_dr19p_speclite WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_from_sdss_dr19p_speclite;
GO

PRINT 'Loading mos_catalog_to_allstar_dr17_synspec_rev1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_allstar_dr17_synspec_rev1;
INSERT INTO dbo.mos_catalog_to_allstar_dr17_synspec_rev1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_allstar_dr17_synspec_rev1;
GO

PRINT 'Loading mos_catalog_to_allwise... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_allwise;
INSERT INTO dbo.mos_catalog_to_allwise WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_allwise;
GO

PRINT 'Loading mos_catalog_to_bhm_csc... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_bhm_csc;
INSERT INTO dbo.mos_catalog_to_bhm_csc WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_bhm_csc;
GO

PRINT 'Loading mos_catalog_to_bhm_efeds_veto... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_bhm_efeds_veto;
INSERT INTO dbo.mos_catalog_to_bhm_efeds_veto WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_bhm_efeds_veto;
GO

PRINT 'Loading mos_catalog_to_bhm_rm_v0... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_bhm_rm_v0;
INSERT INTO dbo.mos_catalog_to_bhm_rm_v0 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_bhm_rm_v0;
GO

PRINT 'Loading mos_catalog_to_bhm_rm_v0_2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_bhm_rm_v0_2;
INSERT INTO dbo.mos_catalog_to_bhm_rm_v0_2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_bhm_rm_v0_2;
GO

PRINT 'Loading mos_catalog_to_catwise2020... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_catwise2020;
INSERT INTO dbo.mos_catalog_to_catwise2020 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_catwise2020;
GO

PRINT 'Loading mos_catalog_to_gaia_dr2_source... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_gaia_dr2_source;
INSERT INTO dbo.mos_catalog_to_gaia_dr2_source WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_gaia_dr2_source;
GO

PRINT 'Loading mos_catalog_to_gaia_dr2_source_part1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_gaia_dr2_source_part1;
INSERT INTO dbo.mos_catalog_to_gaia_dr2_source_part1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_gaia_dr2_source_part1;
GO

PRINT 'Loading mos_catalog_to_gaia_dr2_source_part2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_gaia_dr2_source_part2;
INSERT INTO dbo.mos_catalog_to_gaia_dr2_source_part2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_gaia_dr2_source_part2;
GO

PRINT 'Loading mos_catalog_to_gaia_dr3_source... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_gaia_dr3_source;
INSERT INTO dbo.mos_catalog_to_gaia_dr3_source WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_gaia_dr3_source;
GO

PRINT 'Loading mos_catalog_to_glimpse... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_glimpse;
INSERT INTO dbo.mos_catalog_to_glimpse WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_glimpse;
GO

PRINT 'Loading mos_catalog_to_guvcat... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_guvcat;
INSERT INTO dbo.mos_catalog_to_guvcat WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_guvcat;
GO

PRINT 'Loading mos_catalog_to_legacy_survey_dr10... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_legacy_survey_dr10;
INSERT INTO dbo.mos_catalog_to_legacy_survey_dr10 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_legacy_survey_dr10;
GO

PRINT 'Loading mos_catalog_to_legacy_survey_dr8... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_legacy_survey_dr8;
INSERT INTO dbo.mos_catalog_to_legacy_survey_dr8 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_legacy_survey_dr8;
GO

PRINT 'Loading mos_catalog_to_mangatarget... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_mangatarget;
INSERT INTO dbo.mos_catalog_to_mangatarget WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_mangatarget;
GO

PRINT 'Loading mos_catalog_to_marvels_dr11_star... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_marvels_dr11_star;
INSERT INTO dbo.mos_catalog_to_marvels_dr11_star WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_marvels_dr11_star;
GO

PRINT 'Loading mos_catalog_to_marvels_dr12_star... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_marvels_dr12_star;
INSERT INTO dbo.mos_catalog_to_marvels_dr12_star WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_marvels_dr12_star;
GO

PRINT 'Loading mos_catalog_to_mastar_goodstars... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_mastar_goodstars;
INSERT INTO dbo.mos_catalog_to_mastar_goodstars WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_mastar_goodstars;
GO

PRINT 'Loading mos_catalog_to_milliquas_7_7... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_milliquas_7_7;
INSERT INTO dbo.mos_catalog_to_milliquas_7_7 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_milliquas_7_7;
GO

PRINT 'Loading mos_catalog_to_panstarrs1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_panstarrs1;
INSERT INTO dbo.mos_catalog_to_panstarrs1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_panstarrs1;
GO

PRINT 'Loading mos_catalog_to_sdss_dr13_photoobj_primary... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_sdss_dr13_photoobj_primary;
INSERT INTO dbo.mos_catalog_to_sdss_dr13_photoobj_primary WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_sdss_dr13_photoobj_primary;
GO

PRINT 'Loading mos_catalog_to_sdss_dr16_specobj... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_sdss_dr16_specobj;
INSERT INTO dbo.mos_catalog_to_sdss_dr16_specobj WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_sdss_dr16_specobj;
GO

PRINT 'Loading mos_catalog_to_sdss_dr17_specobj... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_sdss_dr17_specobj;
INSERT INTO dbo.mos_catalog_to_sdss_dr17_specobj WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_sdss_dr17_specobj;
GO

PRINT 'Loading mos_catalog_to_skies_v1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_skies_v1;
INSERT INTO dbo.mos_catalog_to_skies_v1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_skies_v1;
GO

PRINT 'Loading mos_catalog_to_skies_v2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_skies_v2;
INSERT INTO dbo.mos_catalog_to_skies_v2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_skies_v2;
GO

PRINT 'Loading mos_catalog_to_skymapper_dr2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_skymapper_dr2;
INSERT INTO dbo.mos_catalog_to_skymapper_dr2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_skymapper_dr2;
GO

PRINT 'Loading mos_catalog_to_supercosmos... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_supercosmos;
INSERT INTO dbo.mos_catalog_to_supercosmos WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_supercosmos;
GO

PRINT 'Loading mos_catalog_to_tic_v8... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_tic_v8;
INSERT INTO dbo.mos_catalog_to_tic_v8 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_tic_v8;
GO

PRINT 'Loading mos_catalog_to_twomass_psc... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_twomass_psc;
INSERT INTO dbo.mos_catalog_to_twomass_psc WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_twomass_psc;
GO

PRINT 'Loading mos_catalog_to_twomass_psc_part1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_twomass_psc_part1;
INSERT INTO dbo.mos_catalog_to_twomass_psc_part1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_twomass_psc_part1;
GO

PRINT 'Loading mos_catalog_to_twomass_psc_part2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_twomass_psc_part2;
INSERT INTO dbo.mos_catalog_to_twomass_psc_part2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_twomass_psc_part2;
GO

PRINT 'Loading mos_catalog_to_tycho2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_tycho2;
INSERT INTO dbo.mos_catalog_to_tycho2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_tycho2;
GO

PRINT 'Loading mos_catalog_to_unwise... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_unwise;
INSERT INTO dbo.mos_catalog_to_unwise WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_unwise;
GO

PRINT 'Loading mos_catalog_to_uvotssc1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_uvotssc1;
INSERT INTO dbo.mos_catalog_to_uvotssc1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_uvotssc1;
GO

PRINT 'Loading mos_catalog_to_xmm_om_suss_4_1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_xmm_om_suss_4_1;
INSERT INTO dbo.mos_catalog_to_xmm_om_suss_4_1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_xmm_om_suss_4_1;
GO

PRINT 'Loading mos_catalog_to_xmm_om_suss_5_0... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalog_to_xmm_om_suss_5_0;
INSERT INTO dbo.mos_catalog_to_xmm_om_suss_5_0 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalog_to_xmm_om_suss_5_0;
GO

PRINT 'Loading mos_catalogdb_version... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catalogdb_version;
INSERT INTO dbo.mos_catalogdb_version WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catalogdb_version;
GO

PRINT 'Loading mos_category... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_category;
INSERT INTO dbo.mos_category WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_category;
GO

PRINT 'Loading mos_catwise2020... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_catwise2020;
INSERT INTO dbo.mos_catwise2020 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_catwise2020;
GO

PRINT 'Loading mos_design... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_design;
INSERT INTO dbo.mos_design WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_design;
GO

PRINT 'Loading mos_design_mode... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_design_mode;
INSERT INTO dbo.mos_design_mode WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_design_mode;
GO

PRINT 'Loading mos_design_mode_check_results... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_design_mode_check_results;
INSERT INTO dbo.mos_design_mode_check_results WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_design_mode_check_results;
GO

PRINT 'Loading mos_design_to_field... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_design_to_field;
INSERT INTO dbo.mos_design_to_field WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_design_to_field;
GO

PRINT 'Loading mos_ebosstarget_v5... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_ebosstarget_v5;
INSERT INTO dbo.mos_ebosstarget_v5 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_ebosstarget_v5;
GO

PRINT 'Loading mos_erosita_superset_agn... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_erosita_superset_agn;
INSERT INTO dbo.mos_erosita_superset_agn WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_erosita_superset_agn;
GO

PRINT 'Loading mos_erosita_superset_clusters... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_erosita_superset_clusters;
INSERT INTO dbo.mos_erosita_superset_clusters WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_erosita_superset_clusters;
GO

PRINT 'Loading mos_erosita_superset_compactobjects... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_erosita_superset_compactobjects;
INSERT INTO dbo.mos_erosita_superset_compactobjects WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_erosita_superset_compactobjects;
GO

PRINT 'Loading mos_erosita_superset_stars... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_erosita_superset_stars;
INSERT INTO dbo.mos_erosita_superset_stars WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_erosita_superset_stars;
GO

PRINT 'Loading mos_erosita_superset_v1_agn... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_erosita_superset_v1_agn;
INSERT INTO dbo.mos_erosita_superset_v1_agn WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_erosita_superset_v1_agn;
GO

PRINT 'Loading mos_erosita_superset_v1_clusters... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_erosita_superset_v1_clusters;
INSERT INTO dbo.mos_erosita_superset_v1_clusters WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_erosita_superset_v1_clusters;
GO

PRINT 'Loading mos_erosita_superset_v1_compactobjects... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_erosita_superset_v1_compactobjects;
INSERT INTO dbo.mos_erosita_superset_v1_compactobjects WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_erosita_superset_v1_compactobjects;
GO

PRINT 'Loading mos_erosita_superset_v1_stars... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_erosita_superset_v1_stars;
INSERT INTO dbo.mos_erosita_superset_v1_stars WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_erosita_superset_v1_stars;
GO

PRINT 'Loading mos_field... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_field;
INSERT INTO dbo.mos_field WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_field;
GO

PRINT 'Loading mos_gaia_assas_sn_cepheids... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_assas_sn_cepheids;
INSERT INTO dbo.mos_gaia_assas_sn_cepheids WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_assas_sn_cepheids;
GO

PRINT 'Loading mos_gaia_dr2_ruwe... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr2_ruwe;
INSERT INTO dbo.mos_gaia_dr2_ruwe WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr2_ruwe;
GO

PRINT 'Loading mos_gaia_dr2_source... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr2_source;
INSERT INTO dbo.mos_gaia_dr2_source WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr2_source;
GO

PRINT 'Loading mos_gaia_dr2_source_part1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr2_source_part1;
INSERT INTO dbo.mos_gaia_dr2_source_part1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr2_source_part1;
GO

PRINT 'Loading mos_gaia_dr2_source_part2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr2_source_part2;
INSERT INTO dbo.mos_gaia_dr2_source_part2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr2_source_part2;
GO

PRINT 'Loading mos_gaia_dr2_wd... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr2_wd;
INSERT INTO dbo.mos_gaia_dr2_wd WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr2_wd;
GO

PRINT 'Loading mos_gaia_dr3_astrophysical_parameters... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr3_astrophysical_parameters;
INSERT INTO dbo.mos_gaia_dr3_astrophysical_parameters WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr3_astrophysical_parameters;
GO

PRINT 'Loading mos_gaia_dr3_nss_two_body_orbit... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr3_nss_two_body_orbit;
INSERT INTO dbo.mos_gaia_dr3_nss_two_body_orbit WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr3_nss_two_body_orbit;
GO

PRINT 'Loading mos_gaia_dr3_source... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr3_source;
INSERT INTO dbo.mos_gaia_dr3_source WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr3_source;
GO

PRINT 'Loading mos_gaia_dr3_synthetic_photometry_gspc... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr3_synthetic_photometry_gspc;
INSERT INTO dbo.mos_gaia_dr3_synthetic_photometry_gspc WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr3_synthetic_photometry_gspc;
GO

PRINT 'Loading mos_gaia_dr3_vari_rrlyrae... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_dr3_vari_rrlyrae;
INSERT INTO dbo.mos_gaia_dr3_vari_rrlyrae WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_dr3_vari_rrlyrae;
GO

PRINT 'Loading mos_gaia_unwise_agn... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaia_unwise_agn;
INSERT INTO dbo.mos_gaia_unwise_agn WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaia_unwise_agn;
GO

PRINT 'Loading mos_gaiadr2_tmass_best_neighbour... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gaiadr2_tmass_best_neighbour;
INSERT INTO dbo.mos_gaiadr2_tmass_best_neighbour WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gaiadr2_tmass_best_neighbour;
GO

PRINT 'Loading mos_galah_dr3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_galah_dr3;
INSERT INTO dbo.mos_galah_dr3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_galah_dr3;
GO

PRINT 'Loading mos_galex_gr7_gaia_dr3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_galex_gr7_gaia_dr3;
INSERT INTO dbo.mos_galex_gr7_gaia_dr3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_galex_gr7_gaia_dr3;
GO

PRINT 'Loading mos_gedr3spur_main... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_gedr3spur_main;
INSERT INTO dbo.mos_gedr3spur_main WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_gedr3spur_main;
GO

PRINT 'Loading mos_geometric_distances_gaia_dr2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_geometric_distances_gaia_dr2;
INSERT INTO dbo.mos_geometric_distances_gaia_dr2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_geometric_distances_gaia_dr2;
GO

PRINT 'Loading mos_glimpse... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_glimpse;
INSERT INTO dbo.mos_glimpse WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_glimpse;
GO

PRINT 'Loading mos_guvcat... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_guvcat;
INSERT INTO dbo.mos_guvcat WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_guvcat;
GO

PRINT 'Loading mos_hecate_1_1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_hecate_1_1;
INSERT INTO dbo.mos_hecate_1_1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_hecate_1_1;
GO

PRINT 'Loading mos_hole... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_hole;
INSERT INTO dbo.mos_hole WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_hole;
GO

PRINT 'Loading mos_instrument... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_instrument;
INSERT INTO dbo.mos_instrument WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_instrument;
GO

PRINT 'Loading mos_lamost_dr6... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_lamost_dr6;
INSERT INTO dbo.mos_lamost_dr6 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_lamost_dr6;
GO

PRINT 'Loading mos_legacy_catalog_catalogid... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_legacy_catalog_catalogid;
INSERT INTO dbo.mos_legacy_catalog_catalogid WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_legacy_catalog_catalogid;
GO

PRINT 'Loading mos_legacy_survey_dr10... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_legacy_survey_dr10;
INSERT INTO dbo.mos_legacy_survey_dr10 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_legacy_survey_dr10;
GO

PRINT 'Loading mos_legacy_survey_dr8... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_legacy_survey_dr8;
INSERT INTO dbo.mos_legacy_survey_dr8 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_legacy_survey_dr8;
GO

PRINT 'Loading mos_magnitude... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_magnitude;
INSERT INTO dbo.mos_magnitude WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_magnitude;
GO

PRINT 'Loading mos_mangadapall... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_mangadapall;
INSERT INTO dbo.mos_mangadapall WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_mangadapall;
GO

PRINT 'Loading mos_mangadrpall... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_mangadrpall;
INSERT INTO dbo.mos_mangadrpall WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_mangadrpall;
GO

PRINT 'Loading mos_mangatarget... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_mangatarget;
INSERT INTO dbo.mos_mangatarget WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_mangatarget;
GO

PRINT 'Loading mos_mapper... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_mapper;
INSERT INTO dbo.mos_mapper WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_mapper;
GO

PRINT 'Loading mos_marvels_dr11_star... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_marvels_dr11_star;
INSERT INTO dbo.mos_marvels_dr11_star WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_marvels_dr11_star;
GO

PRINT 'Loading mos_marvels_dr12_star... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_marvels_dr12_star;
INSERT INTO dbo.mos_marvels_dr12_star WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_marvels_dr12_star;
GO

PRINT 'Loading mos_mastar_goodstars... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_mastar_goodstars;
INSERT INTO dbo.mos_mastar_goodstars WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_mastar_goodstars;
GO

PRINT 'Loading mos_mastar_goodvisits... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_mastar_goodvisits;
INSERT INTO dbo.mos_mastar_goodvisits WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_mastar_goodvisits;
GO

PRINT 'Loading mos_milliquas_7_7... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_milliquas_7_7;
INSERT INTO dbo.mos_milliquas_7_7 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_milliquas_7_7;
GO

PRINT 'Loading mos_mipsgal... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_mipsgal;
INSERT INTO dbo.mos_mipsgal WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_mipsgal;
GO

PRINT 'Loading mos_mwm_tess_ob... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_mwm_tess_ob;
INSERT INTO dbo.mos_mwm_tess_ob WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_mwm_tess_ob;
GO

PRINT 'Loading mos_observatory... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_observatory;
INSERT INTO dbo.mos_observatory WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_observatory;
GO

PRINT 'Loading mos_obsmode... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_obsmode;
INSERT INTO dbo.mos_obsmode WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_obsmode;
GO

PRINT 'Loading mos_opsdb_apo_camera... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_apo_camera;
INSERT INTO dbo.mos_opsdb_apo_camera WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_apo_camera;
GO

PRINT 'Loading mos_opsdb_apo_camera_frame... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_apo_camera_frame;
INSERT INTO dbo.mos_opsdb_apo_camera_frame WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_apo_camera_frame;
GO

PRINT 'Loading mos_opsdb_apo_completion_status... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_apo_completion_status;
INSERT INTO dbo.mos_opsdb_apo_completion_status WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_apo_completion_status;
GO

PRINT 'Loading mos_opsdb_apo_configuration... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_apo_configuration;
INSERT INTO dbo.mos_opsdb_apo_configuration WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_apo_configuration;
GO

PRINT 'Loading mos_opsdb_apo_design_to_status... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_apo_design_to_status;
INSERT INTO dbo.mos_opsdb_apo_design_to_status WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_apo_design_to_status;
GO

PRINT 'Loading mos_opsdb_apo_exposure... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_apo_exposure;
INSERT INTO dbo.mos_opsdb_apo_exposure WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_apo_exposure;
GO

PRINT 'Loading mos_opsdb_apo_exposure_flavor... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_apo_exposure_flavor;
INSERT INTO dbo.mos_opsdb_apo_exposure_flavor WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_apo_exposure_flavor;
GO

PRINT 'Loading mos_opsdb_lco_camera... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_lco_camera;
INSERT INTO dbo.mos_opsdb_lco_camera WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_lco_camera;
GO

PRINT 'Loading mos_opsdb_lco_camera_frame... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_lco_camera_frame;
INSERT INTO dbo.mos_opsdb_lco_camera_frame WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_lco_camera_frame;
GO

PRINT 'Loading mos_opsdb_lco_completion_status... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_lco_completion_status;
INSERT INTO dbo.mos_opsdb_lco_completion_status WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_lco_completion_status;
GO

PRINT 'Loading mos_opsdb_lco_configuration... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_lco_configuration;
INSERT INTO dbo.mos_opsdb_lco_configuration WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_lco_configuration;
GO

PRINT 'Loading mos_opsdb_lco_design_to_status... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_lco_design_to_status;
INSERT INTO dbo.mos_opsdb_lco_design_to_status WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_lco_design_to_status;
GO

PRINT 'Loading mos_opsdb_lco_exposure... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_lco_exposure;
INSERT INTO dbo.mos_opsdb_lco_exposure WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_lco_exposure;
GO

PRINT 'Loading mos_opsdb_lco_exposure_flavor... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_opsdb_lco_exposure_flavor;
INSERT INTO dbo.mos_opsdb_lco_exposure_flavor WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_opsdb_lco_exposure_flavor;
GO

PRINT 'Loading mos_panstarrs1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_panstarrs1;
INSERT INTO dbo.mos_panstarrs1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_panstarrs1;
GO

PRINT 'Loading mos_positioner_status... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_positioner_status;
INSERT INTO dbo.mos_positioner_status WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_positioner_status;
GO

PRINT 'Loading mos_rave_dr6_gauguin_madera... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_rave_dr6_gauguin_madera;
INSERT INTO dbo.mos_rave_dr6_gauguin_madera WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_rave_dr6_gauguin_madera;
GO

PRINT 'Loading mos_rave_dr6_xgaiae3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_rave_dr6_xgaiae3;
INSERT INTO dbo.mos_rave_dr6_xgaiae3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_rave_dr6_xgaiae3;
GO

PRINT 'Loading mos_revised_magnitude... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_revised_magnitude;
INSERT INTO dbo.mos_revised_magnitude WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_revised_magnitude;
GO

PRINT 'Loading mos_sagitta... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sagitta;
INSERT INTO dbo.mos_sagitta WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sagitta;
GO

PRINT 'Loading mos_sagitta_edr3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sagitta_edr3;
INSERT INTO dbo.mos_sagitta_edr3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sagitta_edr3;
GO

PRINT 'Loading mos_sdss_apogeeallstarmerge_r13... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_apogeeallstarmerge_r13;
INSERT INTO dbo.mos_sdss_apogeeallstarmerge_r13 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_apogeeallstarmerge_r13;
GO

PRINT 'Loading mos_sdss_dr13_photoobj_primary... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_dr13_photoobj_primary;
INSERT INTO dbo.mos_sdss_dr13_photoobj_primary WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_dr13_photoobj_primary;
GO

PRINT 'Loading mos_sdss_dr16_qso... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_dr16_qso;
INSERT INTO dbo.mos_sdss_dr16_qso WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_dr16_qso;
GO

PRINT 'Loading mos_sdss_dr16_specobj... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_dr16_specobj;
INSERT INTO dbo.mos_sdss_dr16_specobj WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_dr16_specobj;
GO

PRINT 'Loading mos_sdss_dr17_apogee_allstarmerge... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_dr17_apogee_allstarmerge;
INSERT INTO dbo.mos_sdss_dr17_apogee_allstarmerge WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_dr17_apogee_allstarmerge;
GO

PRINT 'Loading mos_sdss_dr17_specobj... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_dr17_specobj;
INSERT INTO dbo.mos_sdss_dr17_specobj WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_dr17_specobj;
GO

PRINT 'Loading mos_sdss_dr19p_speclite... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_dr19p_speclite;
INSERT INTO dbo.mos_sdss_dr19p_speclite WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_dr19p_speclite;
GO

PRINT 'Loading mos_sdss_id_flat... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_id_flat;
INSERT INTO dbo.mos_sdss_id_flat WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_id_flat;
GO

PRINT 'Loading mos_sdss_id_flat_initial... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_id_flat_initial;
INSERT INTO dbo.mos_sdss_id_flat_initial WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_id_flat_initial;
GO

PRINT 'Loading mos_sdss_id_stacked... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_id_stacked;
INSERT INTO dbo.mos_sdss_id_stacked WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_id_stacked;
GO

PRINT 'Loading mos_sdss_id_to_catalog... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_id_to_catalog;
INSERT INTO dbo.mos_sdss_id_to_catalog WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_id_to_catalog;
GO

PRINT 'Loading mos_sdss_id_to_catalog_full... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdss_id_to_catalog_full;
INSERT INTO dbo.mos_sdss_id_to_catalog_full WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdss_id_to_catalog_full;
GO

PRINT 'Loading mos_sdssv_boss_conflist... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdssv_boss_conflist;
INSERT INTO dbo.mos_sdssv_boss_conflist WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdssv_boss_conflist;
GO

PRINT 'Loading mos_sdssv_boss_spall... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdssv_boss_spall;
INSERT INTO dbo.mos_sdssv_boss_spall WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdssv_boss_spall;
GO

PRINT 'Loading mos_sdssv_plateholes... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdssv_plateholes;
INSERT INTO dbo.mos_sdssv_plateholes WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdssv_plateholes;
GO

PRINT 'Loading mos_sdssv_plateholes_meta... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_sdssv_plateholes_meta;
INSERT INTO dbo.mos_sdssv_plateholes_meta WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_sdssv_plateholes_meta;
GO

PRINT 'Loading mos_skies_v1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_skies_v1;
INSERT INTO dbo.mos_skies_v1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_skies_v1;
GO

PRINT 'Loading mos_skies_v2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_skies_v2;
INSERT INTO dbo.mos_skies_v2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_skies_v2;
GO

PRINT 'Loading mos_skymapper_dr2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_skymapper_dr2;
INSERT INTO dbo.mos_skymapper_dr2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_skymapper_dr2;
GO

PRINT 'Loading mos_skymapper_gaia... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_skymapper_gaia;
INSERT INTO dbo.mos_skymapper_gaia WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_skymapper_gaia;
GO

PRINT 'Loading mos_supercosmos... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_supercosmos;
INSERT INTO dbo.mos_supercosmos WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_supercosmos;
GO

PRINT 'Loading mos_target... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_target;
INSERT INTO dbo.mos_target WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_target;
GO

PRINT 'Loading mos_target_union_legacy... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_target_union_legacy;
INSERT INTO dbo.mos_target_union_legacy WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_target_union_legacy;
GO

PRINT 'Loading mos_target_union_legacy_initial... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_target_union_legacy_initial;
INSERT INTO dbo.mos_target_union_legacy_initial WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_target_union_legacy_initial;
GO

PRINT 'Loading mos_targetdb_version... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_targetdb_version;
INSERT INTO dbo.mos_targetdb_version WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_targetdb_version;
GO

PRINT 'Loading mos_targeting_generation... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_targeting_generation;
INSERT INTO dbo.mos_targeting_generation WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_targeting_generation;
GO

PRINT 'Loading mos_targeting_generation_to_carton... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_targeting_generation_to_carton;
INSERT INTO dbo.mos_targeting_generation_to_carton WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_targeting_generation_to_carton;
GO

PRINT 'Loading mos_targeting_generation_to_version... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_targeting_generation_to_version;
INSERT INTO dbo.mos_targeting_generation_to_version WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_targeting_generation_to_version;
GO

PRINT 'Loading mos_tess_toi... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_tess_toi;
INSERT INTO dbo.mos_tess_toi WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_tess_toi;
GO

PRINT 'Loading mos_tess_toi_v05... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_tess_toi_v05;
INSERT INTO dbo.mos_tess_toi_v05 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_tess_toi_v05;
GO

PRINT 'Loading mos_tess_toi_v1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_tess_toi_v1;
INSERT INTO dbo.mos_tess_toi_v1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_tess_toi_v1;
GO

PRINT 'Loading mos_tic_v8... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_tic_v8;
INSERT INTO dbo.mos_tic_v8 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_tic_v8;
GO

PRINT 'Loading mos_twomass_psc... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_twomass_psc;
INSERT INTO dbo.mos_twomass_psc WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_twomass_psc;
GO

PRINT 'Loading mos_twomass_psc_part1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_twomass_psc_part1;
INSERT INTO dbo.mos_twomass_psc_part1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_twomass_psc_part1;
GO

PRINT 'Loading mos_twomass_psc_part2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_twomass_psc_part2;
INSERT INTO dbo.mos_twomass_psc_part2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_twomass_psc_part2;
GO

PRINT 'Loading mos_tycho2... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_tycho2;
INSERT INTO dbo.mos_tycho2 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_tycho2;
GO

PRINT 'Loading mos_unwise... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_unwise;
INSERT INTO dbo.mos_unwise WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_unwise;
GO

PRINT 'Loading mos_uvotssc1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_uvotssc1;
INSERT INTO dbo.mos_uvotssc1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_uvotssc1;
GO

PRINT 'Loading mos_visual_binary_gaia_dr3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_visual_binary_gaia_dr3;
INSERT INTO dbo.mos_visual_binary_gaia_dr3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_visual_binary_gaia_dr3;
GO

PRINT 'Loading mos_wd_gaia_dr3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_wd_gaia_dr3;
INSERT INTO dbo.mos_wd_gaia_dr3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_wd_gaia_dr3;
GO

PRINT 'Loading mos_xmm_om_suss_4_1... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_xmm_om_suss_4_1;
INSERT INTO dbo.mos_xmm_om_suss_4_1 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_xmm_om_suss_4_1;
GO

PRINT 'Loading mos_xmm_om_suss_5_0... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_xmm_om_suss_5_0;
INSERT INTO dbo.mos_xmm_om_suss_5_0 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_xmm_om_suss_5_0;
GO

PRINT 'Loading mos_xpfeh_gaia_dr3... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_xpfeh_gaia_dr3;
INSERT INTO dbo.mos_xpfeh_gaia_dr3 WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_xpfeh_gaia_dr3;
GO

PRINT 'Loading mos_yso_clustering... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_yso_clustering;
INSERT INTO dbo.mos_yso_clustering WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_yso_clustering;
GO

PRINT 'Loading mos_zari18pms... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);
TRUNCATE TABLE dbo.mos_zari18pms;
INSERT INTO dbo.mos_zari18pms WITH (TABLOCK)
SELECT * FROM minidb_dr20_v2.dbo.dr20_zari18pms;
GO

PRINT 'All tables loaded. ' + CONVERT(VARCHAR, SYSDATETIME(), 121);