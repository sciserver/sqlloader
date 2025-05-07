

ALTER TABLE  dbo.dr19_allstar_dr17_synspec_rev1
    ADD CONSTRAINT dr19_allstar_dr17_synspec_rev1_pkey PRIMARY KEY CLUSTERED (apstar_id);


ALTER TABLE  dbo.dr19_allwise
    ADD CONSTRAINT dr19_allwise_pkey PRIMARY KEY CLUSTERED (cntr);


ALTER TABLE  dbo.dr19_assignment
    ADD CONSTRAINT dr19_assignment_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_best_brightest
    ADD CONSTRAINT dr19_best_brightest_pkey PRIMARY KEY CLUSTERED (cntr);


ALTER TABLE  dbo.dr19_bhm_csc
    ADD CONSTRAINT dr19_bhm_csc_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_bhm_csc_v2
    ADD CONSTRAINT dr19_bhm_csc_v2_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_bhm_efeds_veto
    ADD CONSTRAINT dr19_bhm_efeds_veto_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_bhm_rm_tweaks
    ADD CONSTRAINT dr19_bhm_rm_tweaks_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_bhm_rm_v0_2
    ADD CONSTRAINT dr19_bhm_rm_v0_2_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_bhm_rm_v0
    ADD CONSTRAINT dr19_bhm_rm_v0_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_bhm_spiders_agn_superset
    ADD CONSTRAINT dr19_bhm_spiders_agn_superset_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_bhm_spiders_clusters_superset
    ADD CONSTRAINT dr19_bhm_spiders_clusters_superset_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_cadence_epoch
    ADD CONSTRAINT dr19_cadence_epoch_pkey PRIMARY KEY CLUSTERED (label, epoch);


ALTER TABLE  dbo.dr19_cadence
    ADD CONSTRAINT dr19_cadence_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_carton_csv
    ADD CONSTRAINT dr19_carton_csv_pkey PRIMARY KEY CLUSTERED (carton_pk, version_pk);


ALTER TABLE  dbo.dr19_carton
    ADD CONSTRAINT dr19_carton_pkey PRIMARY KEY CLUSTERED (carton_pk);


ALTER TABLE  dbo.dr19_carton_to_target
    ADD CONSTRAINT dr19_carton_to_target_pkey PRIMARY KEY CLUSTERED (carton_to_target_pk);


ALTER TABLE  dbo.dr19_cataclysmic_variables
    ADD CONSTRAINT dr19_cataclysmic_variables_pkey PRIMARY KEY CLUSTERED (ref_id);


ALTER TABLE  dbo.dr19_catalog
    ADD CONSTRAINT dr19_catalog_pkey PRIMARY KEY CLUSTERED (catalogid);


ALTER TABLE  dbo.dr19_catalog_to_allstar_dr17_synspec_rev1
    ADD CONSTRAINT dr19_catalog_to_allstar_dr17_synspec_rev1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_allwise
    ADD CONSTRAINT dr19_catalog_to_allwise_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_bhm_csc
    ADD CONSTRAINT dr19_catalog_to_bhm_csc_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_bhm_efeds_veto
    ADD CONSTRAINT dr19_catalog_to_bhm_efeds_veto_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_bhm_rm_v0_2
    ADD CONSTRAINT dr19_catalog_to_bhm_rm_v0_2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_bhm_rm_v0
    ADD CONSTRAINT dr19_catalog_to_bhm_rm_v0_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_catwise2020
    ADD CONSTRAINT dr19_catalog_to_catwise2020_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_gaia_dr2_source
    ADD CONSTRAINT dr19_catalog_to_gaia_dr2_source_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_glimpse
    ADD CONSTRAINT dr19_catalog_to_glimpse_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_guvcat
    ADD CONSTRAINT dr19_catalog_to_guvcat_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_legacy_survey_dr8
    ADD CONSTRAINT dr19_catalog_to_legacy_survey_dr8_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_mangatarget
    ADD CONSTRAINT dr19_catalog_to_mangatarget_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_marvels_dr11_star
    ADD CONSTRAINT dr19_catalog_to_marvels_dr11_star_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_marvels_dr12_star
    ADD CONSTRAINT dr19_catalog_to_marvels_dr12_star_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_mastar_goodstars
    ADD CONSTRAINT dr19_catalog_to_mastar_goodstars_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_panstarrs1
    ADD CONSTRAINT dr19_catalog_to_panstarrs1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr19_catalog_to_sdss_dr13_photoobj_primary_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_sdss_dr16_specobj
    ADD CONSTRAINT dr19_catalog_to_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_sdss_dr17_specobj
    ADD CONSTRAINT dr19_catalog_to_sdss_dr17_specobj_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_skies_v1
    ADD CONSTRAINT dr19_catalog_to_skies_v1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_skies_v2
    ADD CONSTRAINT dr19_catalog_to_skies_v2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_skymapper_dr2
    ADD CONSTRAINT dr19_catalog_to_skymapper_dr2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_supercosmos
    ADD CONSTRAINT dr19_catalog_to_supercosmos_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_tic_v8
    ADD CONSTRAINT dr19_catalog_to_tic_v8_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_twomass_psc
    ADD CONSTRAINT dr19_catalog_to_twomass_psc_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_tycho2
    ADD CONSTRAINT dr19_catalog_to_tycho2_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_unwise
    ADD CONSTRAINT dr19_catalog_to_unwise_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_uvotssc1
    ADD CONSTRAINT dr19_catalog_to_uvotssc1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_xmm_om_suss_4_1
    ADD CONSTRAINT dr19_catalog_to_xmm_om_suss_4_1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalogdb_version
    ADD CONSTRAINT dr19_catalogdb_version_pkey PRIMARY KEY CLUSTERED (id);


ALTER TABLE  dbo.dr19_category
    ADD CONSTRAINT dr19_category_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_catwise2020
    ADD CONSTRAINT dr19_catwise2020_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_design_mode_check_results
    ADD CONSTRAINT dr19_design_mode_check_results_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_design_mode
    ADD CONSTRAINT dr19_design_mode_pkey PRIMARY KEY CLUSTERED (label);


ALTER TABLE  dbo.dr19_design
    ADD CONSTRAINT dr19_design_pkey PRIMARY KEY CLUSTERED (design_id);


ALTER TABLE  dbo.dr19_design_to_field
    ADD CONSTRAINT dr19_design_to_field_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_ebosstarget_v5
    ADD CONSTRAINT dr19_ebosstarget_v5_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_erosita_superset_agn
    ADD CONSTRAINT dr19_erosita_superset_agn_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_erosita_superset_clusters
    ADD CONSTRAINT dr19_erosita_superset_clusters_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_erosita_superset_compactobjects
    ADD CONSTRAINT dr19_erosita_superset_compactobjects_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_erosita_superset_stars
    ADD CONSTRAINT dr19_erosita_superset_stars_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_field
    ADD CONSTRAINT dr19_field_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_gaia_assas_sn_cepheids
    ADD CONSTRAINT dr19_gaia_assas_sn_cepheids_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_gaia_dr2_ruwe
    ADD CONSTRAINT dr19_gaia_dr2_ruwe_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_gaia_dr2_source
    ADD CONSTRAINT dr19_gaia_dr2_source_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_gaia_dr2_wd
    ADD CONSTRAINT dr19_gaia_dr2_wd_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_gaia_unwise_agn
    ADD CONSTRAINT dr19_gaia_unwise_agn_pkey PRIMARY KEY CLUSTERED (gaia_sourceid);


ALTER TABLE  dbo.dr19_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr19_gaiadr2_tmass_best_neighbour_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_geometric_distances_gaia_dr2
    ADD CONSTRAINT dr19_geometric_distances_gaia_dr2_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_glimpse
    ADD CONSTRAINT dr19_glimpse_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_guvcat
    ADD CONSTRAINT dr19_guvcat_pkey PRIMARY KEY CLUSTERED (objid);


ALTER TABLE  dbo.dr19_hole
    ADD CONSTRAINT dr19_hole_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_instrument
    ADD CONSTRAINT dr19_instrument_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_legacy_catalog_catalogid
    ADD CONSTRAINT dr19_legacy_catalog_catalogid_pkey PRIMARY KEY CLUSTERED (catalogid);


ALTER TABLE  dbo.dr19_legacy_survey_dr8
    ADD CONSTRAINT dr19_legacy_survey_dr8_pkey PRIMARY KEY CLUSTERED (ls_id);


ALTER TABLE  dbo.dr19_magnitude
    ADD CONSTRAINT dr19_magnitude_pkey PRIMARY KEY CLUSTERED (magnitude_pk);


ALTER TABLE  dbo.dr19_mangadapall
    ADD CONSTRAINT dr19_mangadapall_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_mangadrpall
    ADD CONSTRAINT dr19_mangadrpall_pkey PRIMARY KEY CLUSTERED (mangaid, plate);


ALTER TABLE  dbo.dr19_mangatarget
    ADD CONSTRAINT dr19_mangatarget_pkey PRIMARY KEY CLUSTERED (mangaid);


ALTER TABLE  dbo.dr19_mapper
    ADD CONSTRAINT dr19_mapper_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_marvels_dr11_star
    ADD CONSTRAINT dr19_marvels_dr11_star_pkey PRIMARY KEY CLUSTERED (starname);


ALTER TABLE  dbo.dr19_marvels_dr12_star
    ADD CONSTRAINT dr19_marvels_dr12_star_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_mastar_goodstars
    ADD CONSTRAINT dr19_mastar_goodstars_pkey PRIMARY KEY CLUSTERED (mangaid);


ALTER TABLE  dbo.dr19_mastar_goodvisits
    ADD CONSTRAINT dr19_mastar_goodvisits_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_mipsgal
    ADD CONSTRAINT dr19_mipsgal_pkey PRIMARY KEY CLUSTERED (mipsgal);


ALTER TABLE  dbo.dr19_mwm_tess_ob
    ADD CONSTRAINT dr19_mwm_tess_ob_pkey PRIMARY KEY CLUSTERED (gaia_dr2_id);


ALTER TABLE  dbo.dr19_observatory
    ADD CONSTRAINT dr19_observatory_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_obsmode
    ADD CONSTRAINT dr19_obsmode_pkey PRIMARY KEY CLUSTERED (label);


ALTER TABLE  dbo.dr19_opsdb_apo_camera_frame
    ADD CONSTRAINT dr19_opsdb_apo_camera_frame_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_opsdb_apo_camera
    ADD CONSTRAINT dr19_opsdb_apo_camera_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_opsdb_apo_completion_status
    ADD CONSTRAINT dr19_opsdb_apo_completion_status_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_opsdb_apo_configuration
    ADD CONSTRAINT dr19_opsdb_apo_configuration_pkey PRIMARY KEY CLUSTERED (configuration_id);


ALTER TABLE  dbo.dr19_opsdb_apo_design_to_status
    ADD CONSTRAINT dr19_opsdb_apo_design_to_status_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_opsdb_apo_exposure_flavor
    ADD CONSTRAINT dr19_opsdb_apo_exposure_flavor_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_opsdb_apo_exposure
    ADD CONSTRAINT dr19_opsdb_apo_exposure_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_panstarrs1
    ADD CONSTRAINT dr19_panstarrs1_pkey PRIMARY KEY CLUSTERED (catid_objid);


ALTER TABLE  dbo.dr19_positioner_status
    ADD CONSTRAINT dr19_positioner_status_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_revised_magnitude
    ADD CONSTRAINT dr19_revised_magnitude_pkey PRIMARY KEY CLUSTERED (revised_magnitude_pk);


ALTER TABLE  dbo.dr19_sagitta
    ADD CONSTRAINT dr19_sagitta_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_sdss_apogeeallstarmerge_r13
    ADD CONSTRAINT dr19_sdss_apogeeallstarmerge_r13_pkey PRIMARY KEY CLUSTERED (apogee_id);


ALTER TABLE  dbo.dr19_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr19_sdss_dr13_photoobj_primary_pkey PRIMARY KEY CLUSTERED (objid);


ALTER TABLE  dbo.dr19_sdss_dr16_qso
    ADD CONSTRAINT dr19_sdss_dr16_qso_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_sdss_dr16_specobj
    ADD CONSTRAINT dr19_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (specobjid);


ALTER TABLE  dbo.dr19_sdss_dr17_specobj
    ADD CONSTRAINT dr19_sdss_dr17_specobj_pkey PRIMARY KEY CLUSTERED (specobjid);


ALTER TABLE  dbo.dr19_sdss_id_flat
    ADD CONSTRAINT dr19_sdss_id_flat_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_sdss_id_stacked
    ADD CONSTRAINT dr19_sdss_id_stacked_pkey PRIMARY KEY CLUSTERED (sdss_id);


ALTER TABLE  dbo.dr19_sdss_id_to_catalog
    ADD CONSTRAINT dr19_sdss_id_to_catalog_pkey PRIMARY KEY CLUSTERED (pk);

	ALTER TABLE  dbo.dr19_sdss_id_to_catalog_full
    ADD CONSTRAINT dr19_sdss_id_to_catalog_full_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_sdssv_boss_conflist
    ADD CONSTRAINT dr19_sdssv_boss_conflist_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_sdssv_boss_spall
    ADD CONSTRAINT dr19_sdssv_boss_spall_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_sdssv_plateholes_meta
    ADD CONSTRAINT dr19_sdssv_plateholes_meta_pkey PRIMARY KEY CLUSTERED (yanny_uid);


ALTER TABLE  dbo.dr19_sdssv_plateholes
    ADD CONSTRAINT dr19_sdssv_plateholes_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_skies_v1
    ADD CONSTRAINT dr19_skies_v1_pkey PRIMARY KEY CLUSTERED (pix_32768);


ALTER TABLE  dbo.dr19_skies_v2
    ADD CONSTRAINT dr19_skies_v2_pkey PRIMARY KEY CLUSTERED (pix_32768);


ALTER TABLE  dbo.dr19_skymapper_dr2
    ADD CONSTRAINT dr19_skymapper_dr2_pkey PRIMARY KEY CLUSTERED (object_id);


ALTER TABLE  dbo.dr19_skymapper_gaia
    ADD CONSTRAINT dr19_skymapper_gaia_pkey PRIMARY KEY CLUSTERED (skymapper_object_id);


ALTER TABLE  dbo.dr19_supercosmos
    ADD CONSTRAINT dr19_supercosmos_pkey PRIMARY KEY CLUSTERED (objid);


ALTER TABLE  dbo.dr19_target
    ADD CONSTRAINT dr19_target_pkey PRIMARY KEY CLUSTERED (target_pk);


ALTER TABLE  dbo.dr19_targetdb_version
    ADD CONSTRAINT dr19_targetdb_version_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_targeting_generation
    ADD CONSTRAINT dr19_targeting_generation_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_targeting_generation_to_carton
    ADD CONSTRAINT dr19_targeting_generation_to_carton_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_targeting_generation_to_version
    ADD CONSTRAINT dr19_targeting_generation_to_version_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_tess_toi
    ADD CONSTRAINT dr19_tess_toi_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_tess_toi_v05
    ADD CONSTRAINT dr19_tess_toi_v05_pkey PRIMARY KEY CLUSTERED (pkey);


ALTER TABLE  dbo.dr19_tic_v8
    ADD CONSTRAINT dr19_tic_v8_pkey PRIMARY KEY CLUSTERED (id);


ALTER TABLE  dbo.dr19_twomass_psc
    ADD CONSTRAINT dr19_twomass_psc_pkey PRIMARY KEY CLUSTERED (pts_key);


ALTER TABLE  dbo.dr19_tycho2
    ADD CONSTRAINT dr19_tycho2_pkey PRIMARY KEY CLUSTERED (designation);


ALTER TABLE  dbo.dr19_unwise
    ADD CONSTRAINT dr19_unwise_pkey PRIMARY KEY CLUSTERED (unwise_objid);


ALTER TABLE  dbo.dr19_uvotssc1
    ADD CONSTRAINT dr19_uvotssc1_pkey PRIMARY KEY CLUSTERED (id);


ALTER TABLE  dbo.dr19_xmm_om_suss_4_1
    ADD CONSTRAINT dr19_xmm_om_suss_4_1_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_yso_clustering
    ADD CONSTRAINT dr19_yso_clustering_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr19_zari18pms
    ADD CONSTRAINT dr19_zari18pms_pkey PRIMARY KEY CLUSTERED (source);
