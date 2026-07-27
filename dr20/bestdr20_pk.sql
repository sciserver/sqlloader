USE BestDR20;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

ALTER TABLE dbo.mos_allstar_dr17_synspec_rev1
    ADD CONSTRAINT mos_allstar_dr17_synspec_rev1_pkey PRIMARY KEY CLUSTERED (apstar_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_allwise
    ADD CONSTRAINT mos_allwise_pkey PRIMARY KEY CLUSTERED (cntr)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_assignment
    ADD CONSTRAINT mos_assignment_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bailer_jones_edr3
    ADD CONSTRAINT mos_bailer_jones_edr3_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_best_brightest
    ADD CONSTRAINT mos_best_brightest_pkey PRIMARY KEY CLUSTERED (cntr) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_csc
    ADD CONSTRAINT mos_bhm_csc_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_csc_v2
    ADD CONSTRAINT mos_bhm_csc_v2_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_csc_v3
    ADD CONSTRAINT mos_bhm_csc_v3_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_efeds_veto
    ADD CONSTRAINT mos_bhm_efeds_veto_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_rm_tweaks
    ADD CONSTRAINT mos_bhm_rm_tweaks_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_rm_v0_2
    ADD CONSTRAINT mos_bhm_rm_v0_2_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_rm_v0
    ADD CONSTRAINT mos_bhm_rm_v0_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_rm_v1_1
    ADD CONSTRAINT mos_bhm_rm_v1_1_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_rm_v1_3
    ADD CONSTRAINT mos_bhm_rm_v1_3_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_rm_v1
    ADD CONSTRAINT mos_bhm_rm_v1_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_spiders_agn_superset
    ADD CONSTRAINT mos_bhm_spiders_agn_superset_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_bhm_spiders_clusters_superset
    ADD CONSTRAINT mos_bhm_spiders_clusters_superset_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_cadence_epoch
    ADD CONSTRAINT mos_cadence_epoch_pkey PRIMARY KEY CLUSTERED (label, epoch) ON [MINIDB];
GO

ALTER TABLE dbo.mos_cadence
    ADD CONSTRAINT mos_cadence_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_carton_csv
    ADD CONSTRAINT mos_carton_csv_pkey PRIMARY KEY CLUSTERED (carton_pk, version_pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_carton
    ADD CONSTRAINT mos_carton_pkey PRIMARY KEY CLUSTERED (carton_pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_carton_to_target
    ADD CONSTRAINT mos_carton_to_target_pkey PRIMARY KEY CLUSTERED (carton_to_target_pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_cataclysmic_variables
    ADD CONSTRAINT mos_cataclysmic_variables_pkey PRIMARY KEY CLUSTERED (ref_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog
    ADD CONSTRAINT mos_catalog_pkey PRIMARY KEY CLUSTERED (catalogid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_allstar_dr17_synspec_rev1
    ADD CONSTRAINT mos_catalog_to_allstar_dr17_synspec_rev1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_allwise
    ADD CONSTRAINT mos_catalog_to_allwise_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_bhm_csc
    ADD CONSTRAINT mos_catalog_to_bhm_csc_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_bhm_efeds_veto
    ADD CONSTRAINT mos_catalog_to_bhm_efeds_veto_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_bhm_rm_v0_2
    ADD CONSTRAINT mos_catalog_to_bhm_rm_v0_2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_bhm_rm_v0
    ADD CONSTRAINT mos_catalog_to_bhm_rm_v0_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_catwise2020
    ADD CONSTRAINT mos_catalog_to_catwise2020_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_gaia_dr2_source_part1
    ADD CONSTRAINT mos_catalog_to_gaia_dr2_source_part1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_gaia_dr2_source_part2
    ADD CONSTRAINT mos_catalog_to_gaia_dr2_source_part2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_gaia_dr2_source
    ADD CONSTRAINT mos_catalog_to_gaia_dr2_source_pkey1 PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_gaia_dr3_source
    ADD CONSTRAINT mos_catalog_to_gaia_dr3_source_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_glimpse
    ADD CONSTRAINT mos_catalog_to_glimpse_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_guvcat
    ADD CONSTRAINT mos_catalog_to_guvcat_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_legacy_survey_dr10
    ADD CONSTRAINT mos_catalog_to_legacy_survey_dr10_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_legacy_survey_dr8
    ADD CONSTRAINT mos_catalog_to_legacy_survey_dr8_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_mangatarget
    ADD CONSTRAINT mos_catalog_to_mangatarget_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_marvels_dr11_star
    ADD CONSTRAINT mos_catalog_to_marvels_dr11_star_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_marvels_dr12_star
    ADD CONSTRAINT mos_catalog_to_marvels_dr12_star_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_mastar_goodstars
    ADD CONSTRAINT mos_catalog_to_mastar_goodstars_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_milliquas_7_7
    ADD CONSTRAINT mos_catalog_to_milliquas_7_7_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_panstarrs1
    ADD CONSTRAINT mos_catalog_to_panstarrs1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_sdss_dr13_photoobj_primary
    ADD CONSTRAINT mos_catalog_to_sdss_dr13_photoobj_primary_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_sdss_dr16_specobj
    ADD CONSTRAINT mos_catalog_to_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_sdss_dr17_specobj
    ADD CONSTRAINT mos_catalog_to_sdss_dr17_specobj_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_skies_v1
    ADD CONSTRAINT mos_catalog_to_skies_v1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_skies_v2
    ADD CONSTRAINT mos_catalog_to_skies_v2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_skymapper_dr2
    ADD CONSTRAINT mos_catalog_to_skymapper_dr2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_supercosmos
    ADD CONSTRAINT mos_catalog_to_supercosmos_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_tic_v8
    ADD CONSTRAINT mos_catalog_to_tic_v8_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_twomass_psc_part1
    ADD CONSTRAINT mos_catalog_to_twomass_psc_part1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_twomass_psc_part2
    ADD CONSTRAINT mos_catalog_to_twomass_psc_part2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_twomass_psc
    ADD CONSTRAINT mos_catalog_to_twomass_psc_pkey1 PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_tycho2
    ADD CONSTRAINT mos_catalog_to_tycho2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_unwise
    ADD CONSTRAINT mos_catalog_to_unwise_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_uvotssc1
    ADD CONSTRAINT mos_catalog_to_uvotssc1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_xmm_om_suss_4_1
    ADD CONSTRAINT mos_catalog_to_xmm_om_suss_4_1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalog_to_xmm_om_suss_5_0
    ADD CONSTRAINT mos_catalog_to_xmm_om_suss_5_0_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catalogdb_version
    ADD CONSTRAINT mos_catalogdb_version_pkey PRIMARY KEY CLUSTERED (id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_category
    ADD CONSTRAINT mos_category_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_catwise2020
    ADD CONSTRAINT mos_catwise2020_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_design_mode_check_results
    ADD CONSTRAINT mos_design_mode_check_results_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_design_mode
    ADD CONSTRAINT mos_design_mode_pkey PRIMARY KEY CLUSTERED (label) ON [MINIDB];
GO

ALTER TABLE dbo.mos_design
    ADD CONSTRAINT mos_design_pkey PRIMARY KEY CLUSTERED (design_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_design_to_field
    ADD CONSTRAINT mos_design_to_field_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_ebosstarget_v5
    ADD CONSTRAINT mos_ebosstarget_v5_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_erosita_superset_agn
    ADD CONSTRAINT mos_erosita_superset_agn_pkey PRIMARY KEY CLUSTERED (pkey)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_erosita_superset_clusters
    ADD CONSTRAINT mos_erosita_superset_clusters_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_erosita_superset_compactobjects
    ADD CONSTRAINT mos_erosita_superset_compactobjects_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_erosita_superset_stars
    ADD CONSTRAINT mos_erosita_superset_stars_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_erosita_superset_v1_agn
    ADD CONSTRAINT mos_erosita_superset_v1_agn_pkey PRIMARY KEY CLUSTERED (pkey)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_erosita_superset_v1_clusters
    ADD CONSTRAINT mos_erosita_superset_v1_clusters_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_erosita_superset_v1_compactobjects
    ADD CONSTRAINT mos_erosita_superset_v1_compactobjects_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_erosita_superset_v1_stars
    ADD CONSTRAINT mos_erosita_superset_v1_stars_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_field
    ADD CONSTRAINT mos_field_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_assas_sn_cepheids
    ADD CONSTRAINT mos_gaia_assas_sn_cepheids_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr2_ruwe
    ADD CONSTRAINT mos_gaia_dr2_ruwe_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr2_source_part1
    ADD CONSTRAINT mos_gaia_dr2_source_part1_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr2_source_part2
    ADD CONSTRAINT mos_gaia_dr2_source_part2_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr2_source
    ADD CONSTRAINT mos_gaia_dr2_source_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr2_wd
    ADD CONSTRAINT mos_gaia_dr2_wd_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr3_astrophysical_parameters
    ADD CONSTRAINT mos_gaia_dr3_astrophysical_parameters_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr3_nss_two_body_orbit
    ADD CONSTRAINT mos_gaia_dr3_nss_two_body_orbit_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr3_source
    ADD CONSTRAINT mos_gaia_dr3_source_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr3_synthetic_photometry_gspc
    ADD CONSTRAINT mos_gaia_dr3_synthetic_photometry_gspc_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_dr3_vari_rrlyrae
    ADD CONSTRAINT mos_gaia_dr3_vari_rrlyrae_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaia_unwise_agn
    ADD CONSTRAINT mos_gaia_unwise_agn_pkey PRIMARY KEY CLUSTERED (gaia_sourceid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT mos_gaiadr2_tmass_best_neighbour_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_galah_dr3
    ADD CONSTRAINT mos_galah_dr3_pkey PRIMARY KEY CLUSTERED (sobject_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_galex_gr7_gaia_dr3
    ADD CONSTRAINT mos_galex_gr7_gaia_dr3_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_gedr3spur_main
    ADD CONSTRAINT mos_gedr3spur_main_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_geometric_distances_gaia_dr2
    ADD CONSTRAINT mos_geometric_distances_gaia_dr2_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_glimpse
    ADD CONSTRAINT mos_glimpse_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_guvcat
    ADD CONSTRAINT mos_guvcat_pkey PRIMARY KEY CLUSTERED (objid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_hecate_1_1
    ADD CONSTRAINT mos_hecate_1_1_pkey PRIMARY KEY CLUSTERED (pgc) ON [MINIDB];
GO

ALTER TABLE dbo.mos_hole
    ADD CONSTRAINT mos_hole_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_instrument
    ADD CONSTRAINT mos_instrument_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_lamost_dr6
    ADD CONSTRAINT mos_lamost_dr6_pkey PRIMARY KEY CLUSTERED (obsid, source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_legacy_catalog_catalogid
    ADD CONSTRAINT mos_legacy_catalog_catalogid_pkey PRIMARY KEY CLUSTERED (catalogid) ON [MINIDB];
GO

ALTER TABLE dbo.mos_legacy_survey_dr10
    ADD CONSTRAINT mos_legacy_survey_dr10_pkey PRIMARY KEY CLUSTERED (ls_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_legacy_survey_dr8
    ADD CONSTRAINT mos_legacy_survey_dr8_pkey PRIMARY KEY CLUSTERED (ls_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_magnitude
    ADD CONSTRAINT mos_magnitude_pkey PRIMARY KEY CLUSTERED (magnitude_pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_mangadapall
    ADD CONSTRAINT mos_mangadapall_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_mangadrpall
    ADD CONSTRAINT mos_mangadrpall_pkey PRIMARY KEY CLUSTERED (mangaid, plate) ON [MINIDB];
GO

ALTER TABLE dbo.mos_mangatarget
    ADD CONSTRAINT mos_mangatarget_pkey PRIMARY KEY CLUSTERED (mangaid) ON [MINIDB];
GO

ALTER TABLE dbo.mos_mapper
    ADD CONSTRAINT mos_mapper_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_marvels_dr11_star
    ADD CONSTRAINT mos_marvels_dr11_star_pkey PRIMARY KEY CLUSTERED (starname) ON [MINIDB];
GO

ALTER TABLE dbo.mos_marvels_dr12_star
    ADD CONSTRAINT mos_marvels_dr12_star_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_mastar_goodstars
    ADD CONSTRAINT mos_mastar_goodstars_pkey PRIMARY KEY CLUSTERED (mangaid) ON [MINIDB];
GO

ALTER TABLE dbo.mos_mastar_goodvisits
    ADD CONSTRAINT mos_mastar_goodvisits_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_milliquas_7_7
    ADD CONSTRAINT mos_milliquas_7_7_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_mipsgal
    ADD CONSTRAINT mos_mipsgal_pkey PRIMARY KEY CLUSTERED (mipsgal) ON [MINIDB];
GO

ALTER TABLE dbo.mos_mwm_tess_ob
    ADD CONSTRAINT mos_mwm_tess_ob_pkey PRIMARY KEY CLUSTERED (gaia_dr2_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_observatory
    ADD CONSTRAINT mos_observatory_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_obsmode
    ADD CONSTRAINT mos_obsmode_pkey PRIMARY KEY CLUSTERED (label) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_apo_camera_frame
    ADD CONSTRAINT mos_opsdb_apo_camera_frame_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_apo_camera
    ADD CONSTRAINT mos_opsdb_apo_camera_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_apo_completion_status
    ADD CONSTRAINT mos_opsdb_apo_completion_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_apo_configuration
    ADD CONSTRAINT mos_opsdb_apo_configuration_pkey PRIMARY KEY CLUSTERED (configuration_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_apo_design_to_status
    ADD CONSTRAINT mos_opsdb_apo_design_to_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_apo_exposure_flavor
    ADD CONSTRAINT mos_opsdb_apo_exposure_flavor_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_lco_camera_frame
    ADD CONSTRAINT mos_opsdb_lco_camera_frame_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_lco_camera
    ADD CONSTRAINT mos_opsdb_lco_camera_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_lco_completion_status
    ADD CONSTRAINT mos_opsdb_lco_completion_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_lco_configuration
    ADD CONSTRAINT mos_opsdb_lco_configuration_pkey PRIMARY KEY CLUSTERED (configuration_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_lco_design_to_status
    ADD CONSTRAINT mos_opsdb_lco_design_to_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_lco_exposure_flavor
    ADD CONSTRAINT mos_opsdb_lco_exposure_flavor_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_opsdb_lco_exposure
    ADD CONSTRAINT mos_opsdb_lco_exposure_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_panstarrs1
    ADD CONSTRAINT mos_panstarrs1_pkey PRIMARY KEY CLUSTERED (catid_objid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_positioner_status
    ADD CONSTRAINT mos_positioner_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_rave_dr6_gauguin_madera
    ADD CONSTRAINT mos_rave_dr6_gauguin_madera_pkey PRIMARY KEY CLUSTERED (rave_obs_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_rave_dr6_xgaiae3
    ADD CONSTRAINT mos_rave_dr6_xgaiae3_pkey PRIMARY KEY CLUSTERED (obsid) ON [MINIDB];
GO

ALTER TABLE dbo.mos_revised_magnitude
    ADD CONSTRAINT mos_revised_magnitude_pkey PRIMARY KEY CLUSTERED (revised_magnitude_pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sagitta_edr3
    ADD CONSTRAINT mos_sagitta_edr3_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sagitta
    ADD CONSTRAINT mos_sagitta_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_apogeeallstarmerge_r13
    ADD CONSTRAINT mos_sdss_apogeeallstarmerge_r13_pkey PRIMARY KEY CLUSTERED (apogee_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_dr13_photoobj_primary
    ADD CONSTRAINT mos_sdss_dr13_photoobj_primary_pkey PRIMARY KEY CLUSTERED (objid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_dr16_qso
    ADD CONSTRAINT mos_sdss_dr16_qso_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_dr16_specobj
    ADD CONSTRAINT mos_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (specobjid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_dr17_apogee_allstarmerge
    ADD CONSTRAINT mos_sdss_dr17_apogee_allstarmerge_pkey PRIMARY KEY CLUSTERED (apogee_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_dr17_specobj
    ADD CONSTRAINT mos_sdss_dr17_specobj_pkey PRIMARY KEY CLUSTERED (specobjid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_dr19p_speclite
    ADD CONSTRAINT mos_sdss_dr19p_speclite_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_id_flat
    ADD CONSTRAINT mos_sdss_id_flat_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_id_stacked
    ADD CONSTRAINT mos_sdss_id_stacked_pkey PRIMARY KEY CLUSTERED (sdss_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdss_id_to_catalog
    ADD CONSTRAINT mos_sdss_id_to_catalog_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdssv_boss_conflist
    ADD CONSTRAINT mos_sdssv_boss_conflist_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdssv_boss_spall
    ADD CONSTRAINT mos_sdssv_boss_spall_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdssv_plateholes_meta
    ADD CONSTRAINT mos_sdssv_plateholes_meta_pkey PRIMARY KEY CLUSTERED (yanny_uid) ON [MINIDB];
GO

ALTER TABLE dbo.mos_sdssv_plateholes
    ADD CONSTRAINT mos_sdssv_plateholes_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_skies_v1
    ADD CONSTRAINT mos_skies_v1_pkey PRIMARY KEY CLUSTERED (pix_32768)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_skies_v2
    ADD CONSTRAINT mos_skies_v2_pkey PRIMARY KEY CLUSTERED (pix_32768)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_skymapper_dr2
    ADD CONSTRAINT mos_skymapper_dr2_pkey PRIMARY KEY CLUSTERED (object_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_skymapper_gaia
    ADD CONSTRAINT mos_skymapper_gaia_pkey PRIMARY KEY CLUSTERED (skymapper_object_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_supercosmos
    ADD CONSTRAINT mos_supercosmos_pkey PRIMARY KEY CLUSTERED (objid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_target
    ADD CONSTRAINT mos_target_pkey PRIMARY KEY CLUSTERED (target_pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_targetdb_version
    ADD CONSTRAINT mos_targetdb_version_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_targeting_generation
    ADD CONSTRAINT mos_targeting_generation_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_targeting_generation_to_carton
    ADD CONSTRAINT mos_targeting_generation_to_carton_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_targeting_generation_to_version
    ADD CONSTRAINT mos_targeting_generation_to_version_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_tess_toi
    ADD CONSTRAINT mos_tess_toi_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_tess_toi_v05
    ADD CONSTRAINT mos_tess_toi_v05_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_tess_toi_v1
    ADD CONSTRAINT mos_tess_toi_v1_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];
GO

ALTER TABLE dbo.mos_tic_v8
    ADD CONSTRAINT mos_tic_v8_pkey PRIMARY KEY CLUSTERED (id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_twomass_psc_part1
    ADD CONSTRAINT mos_twomass_psc_part1_pkey PRIMARY KEY CLUSTERED (pts_key) ON [MINIDB];
GO

ALTER TABLE dbo.mos_twomass_psc_part2
    ADD CONSTRAINT mos_twomass_psc_part2_pkey PRIMARY KEY CLUSTERED (pts_key) ON [MINIDB];
GO

ALTER TABLE dbo.mos_twomass_psc
    ADD CONSTRAINT mos_twomass_psc_pkey PRIMARY KEY CLUSTERED (pts_key)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_tycho2
    ADD CONSTRAINT mos_tycho2_pkey PRIMARY KEY CLUSTERED (designation)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_unwise
    ADD CONSTRAINT mos_unwise_pkey PRIMARY KEY CLUSTERED (unwise_objid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_uvotssc1
    ADD CONSTRAINT mos_uvotssc1_pkey PRIMARY KEY CLUSTERED (id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_visual_binary_gaia_dr3
    ADD CONSTRAINT mos_visual_binary_gaia_dr3_pkey PRIMARY KEY CLUSTERED (source_id1)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_wd_gaia_dr3
    ADD CONSTRAINT mos_wd_gaia_dr3_pkey PRIMARY KEY CLUSTERED (gaiaedr3) ON [MINIDB];
GO

ALTER TABLE dbo.mos_xmm_om_suss_4_1
    ADD CONSTRAINT mos_xmm_om_suss_4_1_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];
GO

ALTER TABLE dbo.mos_xmm_om_suss_5_0
    ADD CONSTRAINT mos_xmm_om_suss_5_0_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_xpfeh_gaia_dr3
    ADD CONSTRAINT mos_xpfeh_gaia_dr3_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
GO

ALTER TABLE dbo.mos_yso_clustering
    ADD CONSTRAINT mos_yso_clustering_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];
GO

ALTER TABLE dbo.mos_zari18pms
    ADD CONSTRAINT mos_zari18pms_pkey PRIMARY KEY CLUSTERED (source) ON [MINIDB];
GO

PRINT 'Primary keys created. Compressed: 179 total (73 with PAGE compression).';