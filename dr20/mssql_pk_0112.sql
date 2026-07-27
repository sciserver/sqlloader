

ALTER TABLE dbo.dr20_allstar_dr17_synspec_rev1
    ADD CONSTRAINT dr20_allstar_dr17_synspec_rev1_pkey PRIMARY KEY CLUSTERED (apstar_id) ON [MINIDB];


ALTER TABLE dbo.dr20_allwise
    ADD CONSTRAINT dr20_allwise_pkey PRIMARY KEY CLUSTERED (cntr)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_assignment
    ADD CONSTRAINT dr20_assignment_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_bailer_jones_edr3
    ADD CONSTRAINT dr20_bailer_jones_edr3_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_best_brightest
    ADD CONSTRAINT dr20_best_brightest_pkey PRIMARY KEY CLUSTERED (cntr) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_csc
    ADD CONSTRAINT dr20_bhm_csc_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_csc_v2
    ADD CONSTRAINT dr20_bhm_csc_v2_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_csc_v3
    ADD CONSTRAINT dr20_bhm_csc_v3_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_efeds_veto
    ADD CONSTRAINT dr20_bhm_efeds_veto_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_rm_tweaks
    ADD CONSTRAINT dr20_bhm_rm_tweaks_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_rm_v0_2
    ADD CONSTRAINT dr20_bhm_rm_v0_2_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_rm_v0
    ADD CONSTRAINT dr20_bhm_rm_v0_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_rm_v1_1
    ADD CONSTRAINT dr20_bhm_rm_v1_1_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_rm_v1_3
    ADD CONSTRAINT dr20_bhm_rm_v1_3_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_rm_v1
    ADD CONSTRAINT dr20_bhm_rm_v1_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_spiders_agn_superset
    ADD CONSTRAINT dr20_bhm_spiders_agn_superset_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_bhm_spiders_clusters_superset
    ADD CONSTRAINT dr20_bhm_spiders_clusters_superset_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_cadence_epoch
    ADD CONSTRAINT dr20_cadence_epoch_pkey PRIMARY KEY CLUSTERED (label, epoch) ON [MINIDB];


ALTER TABLE dbo.dr20_cadence
    ADD CONSTRAINT dr20_cadence_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_carton_csv
    ADD CONSTRAINT dr20_carton_csv_pkey PRIMARY KEY CLUSTERED (carton_pk, version_pk) ON [MINIDB];


ALTER TABLE dbo.dr20_carton
    ADD CONSTRAINT dr20_carton_pkey PRIMARY KEY CLUSTERED (carton_pk) ON [MINIDB];


ALTER TABLE dbo.dr20_carton_to_target
    ADD CONSTRAINT dr20_carton_to_target_pkey PRIMARY KEY CLUSTERED (carton_to_target_pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_cataclysmic_variables
    ADD CONSTRAINT dr20_cataclysmic_variables_pkey PRIMARY KEY CLUSTERED (ref_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog
    ADD CONSTRAINT dr20_catalog_pkey PRIMARY KEY CLUSTERED (catalogid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_allstar_dr17_synspec_rev1
    ADD CONSTRAINT dr20_catalog_to_allstar_dr17_synspec_rev1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_allwise
    ADD CONSTRAINT dr20_catalog_to_allwise_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_bhm_csc
    ADD CONSTRAINT dr20_catalog_to_bhm_csc_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_bhm_efeds_veto
    ADD CONSTRAINT dr20_catalog_to_bhm_efeds_veto_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_bhm_rm_v0_2
    ADD CONSTRAINT dr20_catalog_to_bhm_rm_v0_2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_bhm_rm_v0
    ADD CONSTRAINT dr20_catalog_to_bhm_rm_v0_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_catwise2020
    ADD CONSTRAINT dr20_catalog_to_catwise2020_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_gaia_dr2_source_part1
    ADD CONSTRAINT dr20_catalog_to_gaia_dr2_source_part1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_gaia_dr2_source_part2
    ADD CONSTRAINT dr20_catalog_to_gaia_dr2_source_part2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_gaia_dr2_source
    ADD CONSTRAINT dr20_catalog_to_gaia_dr2_source_pkey1 PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_gaia_dr3_source
    ADD CONSTRAINT dr20_catalog_to_gaia_dr3_source_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_glimpse
    ADD CONSTRAINT dr20_catalog_to_glimpse_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_guvcat
    ADD CONSTRAINT dr20_catalog_to_guvcat_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_legacy_survey_dr10
    ADD CONSTRAINT dr20_catalog_to_legacy_survey_dr10_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_legacy_survey_dr8
    ADD CONSTRAINT dr20_catalog_to_legacy_survey_dr8_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_mangatarget
    ADD CONSTRAINT dr20_catalog_to_mangatarget_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_marvels_dr11_star
    ADD CONSTRAINT dr20_catalog_to_marvels_dr11_star_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_marvels_dr12_star
    ADD CONSTRAINT dr20_catalog_to_marvels_dr12_star_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_mastar_goodstars
    ADD CONSTRAINT dr20_catalog_to_mastar_goodstars_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_milliquas_7_7
    ADD CONSTRAINT dr20_catalog_to_milliquas_7_7_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_panstarrs1
    ADD CONSTRAINT dr20_catalog_to_panstarrs1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr20_catalog_to_sdss_dr13_photoobj_primary_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_sdss_dr16_specobj
    ADD CONSTRAINT dr20_catalog_to_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_sdss_dr17_specobj
    ADD CONSTRAINT dr20_catalog_to_sdss_dr17_specobj_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_skies_v1
    ADD CONSTRAINT dr20_catalog_to_skies_v1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_skies_v2
    ADD CONSTRAINT dr20_catalog_to_skies_v2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_skymapper_dr2
    ADD CONSTRAINT dr20_catalog_to_skymapper_dr2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_supercosmos
    ADD CONSTRAINT dr20_catalog_to_supercosmos_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_tic_v8
    ADD CONSTRAINT dr20_catalog_to_tic_v8_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_twomass_psc_part1
    ADD CONSTRAINT dr20_catalog_to_twomass_psc_part1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_twomass_psc_part2
    ADD CONSTRAINT dr20_catalog_to_twomass_psc_part2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_twomass_psc
    ADD CONSTRAINT dr20_catalog_to_twomass_psc_pkey1 PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_tycho2
    ADD CONSTRAINT dr20_catalog_to_tycho2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_unwise
    ADD CONSTRAINT dr20_catalog_to_unwise_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_uvotssc1
    ADD CONSTRAINT dr20_catalog_to_uvotssc1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_xmm_om_suss_4_1
    ADD CONSTRAINT dr20_catalog_to_xmm_om_suss_4_1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalog_to_xmm_om_suss_5_0
    ADD CONSTRAINT dr20_catalog_to_xmm_om_suss_5_0_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id) ON [MINIDB];


ALTER TABLE dbo.dr20_catalogdb_version
    ADD CONSTRAINT dr20_catalogdb_version_pkey PRIMARY KEY CLUSTERED (id) ON [MINIDB];


ALTER TABLE dbo.dr20_category
    ADD CONSTRAINT dr20_category_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_catwise2020
    ADD CONSTRAINT dr20_catwise2020_pkey PRIMARY KEY CLUSTERED (source_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_design_mode_check_results
    ADD CONSTRAINT dr20_design_mode_check_results_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_design_mode
    ADD CONSTRAINT dr20_design_mode_pkey PRIMARY KEY CLUSTERED (label) ON [MINIDB];


ALTER TABLE dbo.dr20_design
    ADD CONSTRAINT dr20_design_pkey PRIMARY KEY CLUSTERED (design_id) ON [MINIDB];


ALTER TABLE dbo.dr20_design_to_field
    ADD CONSTRAINT dr20_design_to_field_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_ebosstarget_v5
    ADD CONSTRAINT dr20_ebosstarget_v5_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_erosita_superset_agn
    ADD CONSTRAINT dr20_erosita_superset_agn_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_erosita_superset_clusters
    ADD CONSTRAINT dr20_erosita_superset_clusters_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_erosita_superset_compactobjects
    ADD CONSTRAINT dr20_erosita_superset_compactobjects_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_erosita_superset_stars
    ADD CONSTRAINT dr20_erosita_superset_stars_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_erosita_superset_v1_agn
    ADD CONSTRAINT dr20_erosita_superset_v1_agn_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_erosita_superset_v1_clusters
    ADD CONSTRAINT dr20_erosita_superset_v1_clusters_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_erosita_superset_v1_compactobjects
    ADD CONSTRAINT dr20_erosita_superset_v1_compactobjects_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_erosita_superset_v1_stars
    ADD CONSTRAINT dr20_erosita_superset_v1_stars_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_field
    ADD CONSTRAINT dr20_field_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_assas_sn_cepheids
    ADD CONSTRAINT dr20_gaia_assas_sn_cepheids_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr2_ruwe
    ADD CONSTRAINT dr20_gaia_dr2_ruwe_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr2_source_part1
    ADD CONSTRAINT dr20_gaia_dr2_source_part1_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr2_source_part2
    ADD CONSTRAINT dr20_gaia_dr2_source_part2_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr2_source
    ADD CONSTRAINT dr20_gaia_dr2_source_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr2_wd
    ADD CONSTRAINT dr20_gaia_dr2_wd_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr3_astrophysical_parameters
    ADD CONSTRAINT dr20_gaia_dr3_astrophysical_parameters_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr3_nss_two_body_orbit
    ADD CONSTRAINT dr20_gaia_dr3_nss_two_body_orbit_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr3_source
    ADD CONSTRAINT dr20_gaia_dr3_source_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr3_synthetic_photometry_gspc
    ADD CONSTRAINT dr20_gaia_dr3_synthetic_photometry_gspc_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_dr3_vari_rrlyrae
    ADD CONSTRAINT dr20_gaia_dr3_vari_rrlyrae_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_gaia_unwise_agn
    ADD CONSTRAINT dr20_gaia_unwise_agn_pkey PRIMARY KEY CLUSTERED (gaia_sourceid) ON [MINIDB];


ALTER TABLE dbo.dr20_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr20_gaiadr2_tmass_best_neighbour_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_galah_dr3
    ADD CONSTRAINT dr20_galah_dr3_pkey PRIMARY KEY CLUSTERED (sobject_id) ON [MINIDB];


ALTER TABLE dbo.dr20_galex_gr7_gaia_dr3
    ADD CONSTRAINT dr20_galex_gr7_gaia_dr3_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_gedr3spur_main
    ADD CONSTRAINT dr20_gedr3spur_main_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_geometric_distances_gaia_dr2
    ADD CONSTRAINT dr20_geometric_distances_gaia_dr2_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_glimpse
    ADD CONSTRAINT dr20_glimpse_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_guvcat
    ADD CONSTRAINT dr20_guvcat_pkey PRIMARY KEY CLUSTERED (objid) ON [MINIDB];


ALTER TABLE dbo.dr20_hecate_1_1
    ADD CONSTRAINT dr20_hecate_1_1_pkey PRIMARY KEY CLUSTERED (pgc) ON [MINIDB];


ALTER TABLE dbo.dr20_hole
    ADD CONSTRAINT dr20_hole_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_instrument
    ADD CONSTRAINT dr20_instrument_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_lamost_dr6
    ADD CONSTRAINT dr20_lamost_dr6_pkey PRIMARY KEY CLUSTERED (obsid, source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_legacy_catalog_catalogid
    ADD CONSTRAINT dr20_legacy_catalog_catalogid_pkey PRIMARY KEY CLUSTERED (catalogid) ON [MINIDB];


ALTER TABLE dbo.dr20_legacy_survey_dr10
    ADD CONSTRAINT dr20_legacy_survey_dr10_pkey PRIMARY KEY CLUSTERED (ls_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_legacy_survey_dr8
    ADD CONSTRAINT dr20_legacy_survey_dr8_pkey PRIMARY KEY CLUSTERED (ls_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_magnitude
    ADD CONSTRAINT dr20_magnitude_pkey PRIMARY KEY CLUSTERED (magnitude_pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_mangadapall
    ADD CONSTRAINT dr20_mangadapall_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_mangadrpall
    ADD CONSTRAINT dr20_mangadrpall_pkey PRIMARY KEY CLUSTERED (mangaid, plate) ON [MINIDB];


ALTER TABLE dbo.dr20_mangatarget
    ADD CONSTRAINT dr20_mangatarget_pkey PRIMARY KEY CLUSTERED (mangaid) ON [MINIDB];


ALTER TABLE dbo.dr20_mapper
    ADD CONSTRAINT dr20_mapper_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_marvels_dr11_star
    ADD CONSTRAINT dr20_marvels_dr11_star_pkey PRIMARY KEY CLUSTERED (starname) ON [MINIDB];


ALTER TABLE dbo.dr20_marvels_dr12_star
    ADD CONSTRAINT dr20_marvels_dr12_star_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_mastar_goodstars
    ADD CONSTRAINT dr20_mastar_goodstars_pkey PRIMARY KEY CLUSTERED (mangaid) ON [MINIDB];


ALTER TABLE dbo.dr20_mastar_goodvisits
    ADD CONSTRAINT dr20_mastar_goodvisits_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_milliquas_7_7
    ADD CONSTRAINT dr20_milliquas_7_7_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_mipsgal
    ADD CONSTRAINT dr20_mipsgal_pkey PRIMARY KEY CLUSTERED (mipsgal) ON [MINIDB];


ALTER TABLE dbo.dr20_mwm_tess_ob
    ADD CONSTRAINT dr20_mwm_tess_ob_pkey PRIMARY KEY CLUSTERED (gaia_dr2_id) ON [MINIDB];


ALTER TABLE dbo.dr20_observatory
    ADD CONSTRAINT dr20_observatory_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_obsmode
    ADD CONSTRAINT dr20_obsmode_pkey PRIMARY KEY CLUSTERED (label) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_apo_camera_frame
    ADD CONSTRAINT dr20_opsdb_apo_camera_frame_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_apo_camera
    ADD CONSTRAINT dr20_opsdb_apo_camera_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_apo_completion_status
    ADD CONSTRAINT dr20_opsdb_apo_completion_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_apo_configuration
    ADD CONSTRAINT dr20_opsdb_apo_configuration_pkey PRIMARY KEY CLUSTERED (configuration_id) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_apo_design_to_status
    ADD CONSTRAINT dr20_opsdb_apo_design_to_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_apo_exposure_flavor
    ADD CONSTRAINT dr20_opsdb_apo_exposure_flavor_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_lco_camera_frame
    ADD CONSTRAINT dr20_opsdb_lco_camera_frame_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_lco_camera
    ADD CONSTRAINT dr20_opsdb_lco_camera_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_lco_completion_status
    ADD CONSTRAINT dr20_opsdb_lco_completion_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_lco_configuration
    ADD CONSTRAINT dr20_opsdb_lco_configuration_pkey PRIMARY KEY CLUSTERED (configuration_id) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_lco_design_to_status
    ADD CONSTRAINT dr20_opsdb_lco_design_to_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_lco_exposure_flavor
    ADD CONSTRAINT dr20_opsdb_lco_exposure_flavor_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_opsdb_lco_exposure
    ADD CONSTRAINT dr20_opsdb_lco_exposure_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_panstarrs1
    ADD CONSTRAINT dr20_panstarrs1_pkey PRIMARY KEY CLUSTERED (catid_objid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_positioner_status
    ADD CONSTRAINT dr20_positioner_status_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_rave_dr6_gauguin_madera
    ADD CONSTRAINT dr20_rave_dr6_gauguin_madera_pkey PRIMARY KEY CLUSTERED (rave_obs_id) ON [MINIDB];


ALTER TABLE dbo.dr20_rave_dr6_xgaiae3
    ADD CONSTRAINT dr20_rave_dr6_xgaiae3_pkey PRIMARY KEY CLUSTERED (obsid) ON [MINIDB];


ALTER TABLE dbo.dr20_revised_magnitude
    ADD CONSTRAINT dr20_revised_magnitude_pkey PRIMARY KEY CLUSTERED (revised_magnitude_pk) ON [MINIDB];


ALTER TABLE dbo.dr20_sagitta_edr3
    ADD CONSTRAINT dr20_sagitta_edr3_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_sagitta
    ADD CONSTRAINT dr20_sagitta_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_apogeeallstarmerge_r13
    ADD CONSTRAINT dr20_sdss_apogeeallstarmerge_r13_pkey PRIMARY KEY CLUSTERED (apogee_id) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr20_sdss_dr13_photoobj_primary_pkey PRIMARY KEY CLUSTERED (objid) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_dr16_qso
    ADD CONSTRAINT dr20_sdss_dr16_qso_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_dr16_specobj
    ADD CONSTRAINT dr20_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (specobjid) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_dr17_apogee_allstarmerge
    ADD CONSTRAINT dr20_sdss_dr17_apogee_allstarmerge_pkey PRIMARY KEY CLUSTERED (apogee_id) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_dr17_specobj
    ADD CONSTRAINT dr20_sdss_dr17_specobj_pkey PRIMARY KEY CLUSTERED (specobjid) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_dr19p_speclite
    ADD CONSTRAINT dr20_sdss_dr19p_speclite_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_id_flat
    ADD CONSTRAINT dr20_sdss_id_flat_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_id_stacked
    ADD CONSTRAINT dr20_sdss_id_stacked_pkey PRIMARY KEY CLUSTERED (sdss_id) ON [MINIDB];


ALTER TABLE dbo.dr20_sdss_id_to_catalog
    ADD CONSTRAINT dr20_sdss_id_to_catalog_pkey PRIMARY KEY CLUSTERED (pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_sdssv_boss_conflist
    ADD CONSTRAINT dr20_sdssv_boss_conflist_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_sdssv_boss_spall
    ADD CONSTRAINT dr20_sdssv_boss_spall_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_sdssv_plateholes_meta
    ADD CONSTRAINT dr20_sdssv_plateholes_meta_pkey PRIMARY KEY CLUSTERED (yanny_uid) ON [MINIDB];


ALTER TABLE dbo.dr20_sdssv_plateholes
    ADD CONSTRAINT dr20_sdssv_plateholes_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_skies_v1
    ADD CONSTRAINT dr20_skies_v1_pkey PRIMARY KEY CLUSTERED (pix_32768) ON [MINIDB];


ALTER TABLE dbo.dr20_skies_v2
    ADD CONSTRAINT dr20_skies_v2_pkey PRIMARY KEY CLUSTERED (pix_32768) ON [MINIDB];


ALTER TABLE dbo.dr20_skymapper_dr2
    ADD CONSTRAINT dr20_skymapper_dr2_pkey PRIMARY KEY CLUSTERED (object_id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_skymapper_gaia
    ADD CONSTRAINT dr20_skymapper_gaia_pkey PRIMARY KEY CLUSTERED (skymapper_object_id) ON [MINIDB];


ALTER TABLE dbo.dr20_supercosmos
    ADD CONSTRAINT dr20_supercosmos_pkey PRIMARY KEY CLUSTERED (objid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_target
    ADD CONSTRAINT dr20_target_pkey PRIMARY KEY CLUSTERED (target_pk)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_targetdb_version
    ADD CONSTRAINT dr20_targetdb_version_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_targeting_generation
    ADD CONSTRAINT dr20_targeting_generation_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_targeting_generation_to_carton
    ADD CONSTRAINT dr20_targeting_generation_to_carton_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_targeting_generation_to_version
    ADD CONSTRAINT dr20_targeting_generation_to_version_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_tess_toi
    ADD CONSTRAINT dr20_tess_toi_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_tess_toi_v05
    ADD CONSTRAINT dr20_tess_toi_v05_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_tess_toi_v1
    ADD CONSTRAINT dr20_tess_toi_v1_pkey PRIMARY KEY CLUSTERED (pkey) ON [MINIDB];


ALTER TABLE dbo.dr20_tic_v8
    ADD CONSTRAINT dr20_tic_v8_pkey PRIMARY KEY CLUSTERED (id)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_twomass_psc_part1
    ADD CONSTRAINT dr20_twomass_psc_part1_pkey PRIMARY KEY CLUSTERED (pts_key) ON [MINIDB];


ALTER TABLE dbo.dr20_twomass_psc_part2
    ADD CONSTRAINT dr20_twomass_psc_part2_pkey PRIMARY KEY CLUSTERED (pts_key) ON [MINIDB];


ALTER TABLE dbo.dr20_twomass_psc
    ADD CONSTRAINT dr20_twomass_psc_pkey PRIMARY KEY CLUSTERED (pts_key)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_tycho2
    ADD CONSTRAINT dr20_tycho2_pkey PRIMARY KEY CLUSTERED (designation) ON [MINIDB];


ALTER TABLE dbo.dr20_unwise
    ADD CONSTRAINT dr20_unwise_pkey PRIMARY KEY CLUSTERED (unwise_objid)
WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];


ALTER TABLE dbo.dr20_uvotssc1
    ADD CONSTRAINT dr20_uvotssc1_pkey PRIMARY KEY CLUSTERED (id) ON [MINIDB];


ALTER TABLE dbo.dr20_visual_binary_gaia_dr3
    ADD CONSTRAINT dr20_visual_binary_gaia_dr3_pkey PRIMARY KEY CLUSTERED (source_id1) ON [MINIDB];


ALTER TABLE dbo.dr20_wd_gaia_dr3
    ADD CONSTRAINT dr20_wd_gaia_dr3_pkey PRIMARY KEY CLUSTERED (gaiaedr3) ON [MINIDB];


ALTER TABLE dbo.dr20_xmm_om_suss_4_1
    ADD CONSTRAINT dr20_xmm_om_suss_4_1_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_xmm_om_suss_5_0
    ADD CONSTRAINT dr20_xmm_om_suss_5_0_pkey PRIMARY KEY CLUSTERED (pk) ON [MINIDB];


ALTER TABLE dbo.dr20_xpfeh_gaia_dr3
    ADD CONSTRAINT dr20_xpfeh_gaia_dr3_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_yso_clustering
    ADD CONSTRAINT dr20_yso_clustering_pkey PRIMARY KEY CLUSTERED (source_id) ON [MINIDB];


ALTER TABLE dbo.dr20_zari18pms
    ADD CONSTRAINT dr20_zari18pms_pkey PRIMARY KEY CLUSTERED (source) ON [MINIDB];
