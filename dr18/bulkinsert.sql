


TRUNCATE TABLE dr18_best_brightest;BULK INSERT dr18_best_brightest FROM 'd:\dr18loading\minidb\csv\minidb.dr18_best_brightest.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_bhm_csc_v2;BULK INSERT dr18_bhm_csc_v2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_bhm_csc_v2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_bhm_efeds_veto;BULK INSERT dr18_bhm_efeds_veto FROM 'd:\dr18loading\minidb\csv\minidb.dr18_bhm_efeds_veto.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_bhm_rm_v0_2;BULK INSERT dr18_bhm_rm_v0_2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_bhm_rm_v0_2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_cadence;BULK INSERT dr18_cadence FROM 'd:\dr18loading\minidb\csv\minidb.dr18_cadence.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_cadence_epoch;BULK INSERT dr18_cadence_epoch FROM 'd:\dr18loading\minidb\csv\minidb.dr18_cadence_epoch.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_carton;BULK INSERT dr18_carton FROM 'd:\dr18loading\minidb\csv\minidb.dr18_carton.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_carton_to_target;BULK INSERT dr18_carton_to_target FROM 'd:\dr18loading\minidb\csv\minidb.dr18_carton_to_target.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_cataclysmic_variables;BULK INSERT dr18_cataclysmic_variables FROM 'd:\dr18loading\minidb\csv\minidb.dr18_cataclysmic_variables.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog;BULK INSERT dr18_catalog FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_allwise;BULK INSERT dr18_catalog_to_allwise FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_allwise.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_bhm_efeds_veto;BULK INSERT dr18_catalog_to_bhm_efeds_veto FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_bhm_efeds_veto.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_bhm_rm_v0_2;BULK INSERT dr18_catalog_to_bhm_rm_v0_2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_bhm_rm_v0_2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_catwise2020;BULK INSERT dr18_catalog_to_catwise2020 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_catwise2020.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_glimpse;BULK INSERT dr18_catalog_to_glimpse FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_glimpse.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_guvcat;BULK INSERT dr18_catalog_to_guvcat FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_guvcat.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_legacy_survey_dr8;BULK INSERT dr18_catalog_to_legacy_survey_dr8 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_legacy_survey_dr8.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_panstarrs1;BULK INSERT dr18_catalog_to_panstarrs1 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_panstarrs1.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_sdss_dr13_photoobj_primary;BULK INSERT dr18_catalog_to_sdss_dr13_photoobj_primary FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_sdss_dr13_photoobj_primary.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_sdss_dr16_specobj;BULK INSERT dr18_catalog_to_sdss_dr16_specobj FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_sdss_dr16_specobj.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_skies_v2;BULK INSERT dr18_catalog_to_skies_v2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_skies_v2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_skymapper_dr2;BULK INSERT dr18_catalog_to_skymapper_dr2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_skymapper_dr2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_supercosmos;BULK INSERT dr18_catalog_to_supercosmos FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_supercosmos.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_tic_v8;BULK INSERT dr18_catalog_to_tic_v8 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_tic_v8.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_tycho2;BULK INSERT dr18_catalog_to_tycho2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_tycho2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_uvotssc1;BULK INSERT dr18_catalog_to_uvotssc1 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_uvotssc1.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catalog_to_xmm_om_suss_4_1;BULK INSERT dr18_catalog_to_xmm_om_suss_4_1 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catalog_to_xmm_om_suss_4_1.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_category;BULK INSERT dr18_category FROM 'd:\dr18loading\minidb\csv\minidb.dr18_category.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_catwise2020;BULK INSERT dr18_catwise2020 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_catwise2020.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_ebosstarget_v5;BULK INSERT dr18_ebosstarget_v5 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_ebosstarget_v5.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_gaia_dr2_ruwe;BULK INSERT dr18_gaia_dr2_ruwe FROM 'd:\dr18loading\minidb\csv\minidb.dr18_gaia_dr2_ruwe.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_gaia_dr2_source;BULK INSERT dr18_gaia_dr2_source FROM 'd:\dr18loading\minidb\csv\minidb.dr18_gaia_dr2_source.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_gaiadr2_tmass_best_neighbour;BULK INSERT dr18_gaiadr2_tmass_best_neighbour FROM 'd:\dr18loading\minidb\csv\minidb.dr18_gaiadr2_tmass_best_neighbour.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_gaia_dr2_wd;BULK INSERT dr18_gaia_dr2_wd FROM 'd:\dr18loading\minidb\csv\minidb.dr18_gaia_dr2_wd.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_gaia_unwise_agn;BULK INSERT dr18_gaia_unwise_agn FROM 'd:\dr18loading\minidb\csv\minidb.dr18_gaia_unwise_agn.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_geometric_distances_gaia_dr2;BULK INSERT dr18_geometric_distances_gaia_dr2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_geometric_distances_gaia_dr2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_glimpse;BULK INSERT dr18_glimpse FROM 'd:\dr18loading\minidb\csv\minidb.dr18_glimpse.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_guvcat;BULK INSERT dr18_guvcat FROM 'd:\dr18loading\minidb\csv\minidb.dr18_guvcat.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_instrument;BULK INSERT dr18_instrument FROM 'd:\dr18loading\minidb\csv\minidb.dr18_instrument.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_legacy_survey_dr8;BULK INSERT dr18_legacy_survey_dr8 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_legacy_survey_dr8.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_magnitude;BULK INSERT dr18_magnitude FROM 'd:\dr18loading\minidb\csv\minidb.dr18_magnitude.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_mapper;BULK INSERT dr18_mapper FROM 'd:\dr18loading\minidb\csv\minidb.dr18_mapper.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_panstarrs1;BULK INSERT dr18_panstarrs1 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_panstarrs1.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_sagitta;BULK INSERT dr18_sagitta FROM 'd:\dr18loading\minidb\csv\minidb.dr18_sagitta.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_sdss_apogeeallstarmerge_r13;BULK INSERT dr18_sdss_apogeeallstarmerge_r13 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_sdss_apogeeallstarmerge_r13.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_sdss_dr13_photoobj_primary;BULK INSERT dr18_sdss_dr13_photoobj_primary FROM 'd:\dr18loading\minidb\csv\minidb.dr18_sdss_dr13_photoobj_primary.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_sdss_dr16_qso;BULK INSERT dr18_sdss_dr16_qso FROM 'd:\dr18loading\minidb\csv\minidb.dr18_sdss_dr16_qso.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_sdss_dr16_specobj;BULK INSERT dr18_sdss_dr16_specobj FROM 'd:\dr18loading\minidb\csv\minidb.dr18_sdss_dr16_specobj.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_skies_v2;BULK INSERT dr18_skies_v2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_skies_v2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_skymapper_dr2;BULK INSERT dr18_skymapper_dr2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_skymapper_dr2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_supercosmos;BULK INSERT dr18_supercosmos FROM 'd:\dr18loading\minidb\csv\minidb.dr18_supercosmos.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_target;BULK INSERT dr18_target FROM 'd:\dr18loading\minidb\csv\minidb.dr18_target.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_tic_v8;BULK INSERT dr18_tic_v8 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_tic_v8.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_twomass_psc;BULK INSERT dr18_twomass_psc FROM 'd:\dr18loading\minidb\csv\minidb.dr18_twomass_psc.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_tycho2;BULK INSERT dr18_tycho2 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_tycho2.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_uvotssc1;BULK INSERT dr18_uvotssc1 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_uvotssc1.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_xmm_om_suss_4_1;BULK INSERT dr18_xmm_om_suss_4_1 FROM 'd:\dr18loading\minidb\csv\minidb.dr18_xmm_om_suss_4_1.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_yso_clustering;BULK INSERT dr18_yso_clustering FROM 'd:\dr18loading\minidb\csv\minidb.dr18_yso_clustering.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	
TRUNCATE TABLE dr18_zari18pms;BULK INSERT dr18_zari18pms FROM 'd:\dr18loading\minidb\csv\minidb.dr18_zari18pms.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
	


