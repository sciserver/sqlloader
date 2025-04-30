

ALTER TABLE  dbo.dr19_assignment
    ADD CONSTRAINT dr19_assignment_carton_to_target_pk_fkey FOREIGN KEY (carton_to_target_pk) REFERENCES dbo.dr19_carton_to_target(carton_to_target_pk);


ALTER TABLE  dbo.dr19_assignment
    ADD CONSTRAINT dr19_assignment_design_id_fkey FOREIGN KEY (design_id) REFERENCES dbo.dr19_design(design_id);


ALTER TABLE  dbo.dr19_assignment
    ADD CONSTRAINT dr19_assignment_hole_pk_fkey FOREIGN KEY (hole_pk) REFERENCES dbo.dr19_hole(pk);


ALTER TABLE  dbo.dr19_best_brightest
    ADD CONSTRAINT dr19_best_brightest_cntr_fkey FOREIGN KEY (cntr) REFERENCES dbo.dr19_allwise(cntr);


ALTER TABLE  dbo.dr19_bhm_spiders_agn_superset
    ADD CONSTRAINT dr19_bhm_spiders_agn_superset_gaia_dr2_source_id_fkey FOREIGN KEY (gaia_dr2_source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_bhm_spiders_agn_superset
    ADD CONSTRAINT dr19_bhm_spiders_agn_superset_ls_id_fkey FOREIGN KEY (ls_id) REFERENCES dbo.dr19_legacy_survey_dr8(ls_id);


ALTER TABLE  dbo.dr19_bhm_spiders_clusters_superset
    ADD CONSTRAINT dr19_bhm_spiders_clusters_superset_gaia_dr2_source_id_fkey FOREIGN KEY (gaia_dr2_source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_bhm_spiders_clusters_superset
    ADD CONSTRAINT dr19_bhm_spiders_clusters_superset_ls_id_fkey FOREIGN KEY (ls_id) REFERENCES dbo.dr19_legacy_survey_dr8(ls_id);


ALTER TABLE  dbo.dr19_carton
    ADD CONSTRAINT dr19_carton_target_selection_plan_fkey FOREIGN KEY (target_selection_plan) REFERENCES dbo.dr19_targetdb_version(plan);


ALTER TABLE  dbo.dr19_cataclysmic_variables
    ADD CONSTRAINT dr19_cataclysmic_variables_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_catalog_to_allstar_dr17_synspec_rev1
    ADD CONSTRAINT dr19_catalog_to_allstar_dr17_synspec_rev1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_allstar_dr17_synspec_rev1(apstar_id);


ALTER TABLE  dbo.dr19_catalog_to_allwise
    ADD CONSTRAINT dr19_catalog_to_allwise_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_allwise(cntr);


ALTER TABLE  dbo.dr19_catalog_to_bhm_csc
    ADD CONSTRAINT dr19_catalog_to_bhm_csc_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_bhm_csc(pk);


ALTER TABLE  dbo.dr19_catalog_to_bhm_efeds_veto
    ADD CONSTRAINT dr19_catalog_to_bhm_efeds_veto_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_bhm_efeds_veto(pk);


ALTER TABLE  dbo.dr19_catalog_to_bhm_rm_v0_2
    ADD CONSTRAINT dr19_catalog_to_bhm_rm_v0_2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_bhm_rm_v0_2(pk);


ALTER TABLE  dbo.dr19_catalog_to_bhm_rm_v0
    ADD CONSTRAINT dr19_catalog_to_bhm_rm_v0_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_bhm_rm_v0(pk);


ALTER TABLE  dbo.dr19_catalog_to_catwise2020
    ADD CONSTRAINT dr19_catalog_to_catwise2020_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_catwise2020(source_id);


ALTER TABLE  dbo.dr19_catalog_to_gaia_dr2_source
    ADD CONSTRAINT dr19_catalog_to_gaia_dr2_source_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_catalog_to_glimpse
    ADD CONSTRAINT dr19_catalog_to_glimpse_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_glimpse(pk);


ALTER TABLE  dbo.dr19_catalog_to_guvcat
    ADD CONSTRAINT dr19_catalog_to_guvcat_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_guvcat(objid);


ALTER TABLE  dbo.dr19_catalog_to_legacy_survey_dr8
    ADD CONSTRAINT dr19_catalog_to_legacy_survey_dr8_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_legacy_survey_dr8(ls_id);


ALTER TABLE  dbo.dr19_catalog_to_mangatarget
    ADD CONSTRAINT dr19_catalog_to_mangatarget_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_mangatarget(mangaid);


ALTER TABLE  dbo.dr19_catalog_to_marvels_dr11_star
    ADD CONSTRAINT dr19_catalog_to_marvels_dr11_star_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_marvels_dr11_star(starname);


ALTER TABLE  dbo.dr19_catalog_to_marvels_dr12_star
    ADD CONSTRAINT dr19_catalog_to_marvels_dr12_star_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_marvels_dr12_star(pk);


ALTER TABLE  dbo.dr19_catalog_to_mastar_goodstars
    ADD CONSTRAINT dr19_catalog_to_mastar_goodstars_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_mastar_goodstars(mangaid);


ALTER TABLE  dbo.dr19_catalog_to_panstarrs1
    ADD CONSTRAINT dr19_catalog_to_panstarrs1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_panstarrs1(catid_objid);


ALTER TABLE  dbo.dr19_catalog_to_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr19_catalog_to_sdss_dr13_photoobj_primary_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_sdss_dr13_photoobj_primary(objid);


ALTER TABLE  dbo.dr19_catalog_to_sdss_dr16_specobj
    ADD CONSTRAINT dr19_catalog_to_sdss_dr16_specobj_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_sdss_dr16_specobj(specobjid);


ALTER TABLE  dbo.dr19_catalog_to_skies_v1
    ADD CONSTRAINT dr19_catalog_to_skies_v1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_skies_v1(pix_32768);


ALTER TABLE  dbo.dr19_catalog_to_skies_v2
    ADD CONSTRAINT dr19_catalog_to_skies_v2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_skies_v2(pix_32768);


ALTER TABLE  dbo.dr19_catalog_to_skymapper_dr2
    ADD CONSTRAINT dr19_catalog_to_skymapper_dr2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_skymapper_dr2(object_id);


ALTER TABLE  dbo.dr19_catalog_to_supercosmos
    ADD CONSTRAINT dr19_catalog_to_supercosmos_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_supercosmos(objid);


ALTER TABLE  dbo.dr19_catalog_to_tic_v8
    ADD CONSTRAINT dr19_catalog_to_tic_v8_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_tic_v8(id);


ALTER TABLE  dbo.dr19_catalog_to_twomass_psc
    ADD CONSTRAINT dr19_catalog_to_twomass_psc_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_twomass_psc(pts_key);


ALTER TABLE  dbo.dr19_catalog_to_tycho2
    ADD CONSTRAINT dr19_catalog_to_tycho2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_tycho2(designation);


ALTER TABLE  dbo.dr19_catalog_to_unwise
    ADD CONSTRAINT dr19_catalog_to_unwise_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_unwise(unwise_objid);


ALTER TABLE  dbo.dr19_catalog_to_uvotssc1
    ADD CONSTRAINT dr19_catalog_to_uvotssc1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_uvotssc1(id);


ALTER TABLE  dbo.dr19_catalog_to_xmm_om_suss_4_1
    ADD CONSTRAINT dr19_catalog_to_xmm_om_suss_4_1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_xmm_om_suss_4_1(pk);


ALTER TABLE  dbo.dr19_design
    ADD CONSTRAINT dr19_design_design_mode_label_fkey FOREIGN KEY (design_mode_label) REFERENCES dbo.dr19_design_mode(label);


ALTER TABLE  dbo.dr19_design_mode_check_results
    ADD CONSTRAINT dr19_design_mode_check_results_design_id_fkey FOREIGN KEY (design_id) REFERENCES dbo.dr19_design(design_id);


ALTER TABLE  dbo.dr19_design_to_field
    ADD CONSTRAINT dr19_design_to_field_design_id_fkey FOREIGN KEY (design_id) REFERENCES dbo.dr19_design(design_id);


ALTER TABLE  dbo.dr19_design_to_field
    ADD CONSTRAINT dr19_design_to_field_field_pk_fkey FOREIGN KEY (field_pk) REFERENCES dbo.dr19_field(pk);


ALTER TABLE  dbo.dr19_ebosstarget_v5
    ADD CONSTRAINT dr19_ebosstarget_v5_objid_targeting_fkey FOREIGN KEY (objid_targeting) REFERENCES dbo.dr19_sdss_dr13_photoobj_primary(objid);


ALTER TABLE  dbo.dr19_erosita_superset_compactobjects
    ADD CONSTRAINT dr19_erosita_superset_compactobjects_gaia_dr2_id_fkey FOREIGN KEY (gaia_dr2_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_erosita_superset_stars
    ADD CONSTRAINT dr19_erosita_superset_stars_gaia_dr2_id_fkey FOREIGN KEY (gaia_dr2_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_field
    ADD CONSTRAINT dr19_field_observatory_pk_fkey FOREIGN KEY (observatory_pk) REFERENCES dbo.dr19_observatory(pk);


ALTER TABLE  dbo.dr19_field
    ADD CONSTRAINT dr19_field_version_pk_fkey FOREIGN KEY (version_pk) REFERENCES dbo.dr19_targetdb_version(pk);


ALTER TABLE  dbo.dr19_gaia_assas_sn_cepheids
    ADD CONSTRAINT dr19_gaia_assas_sn_cepheids_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_gaia_dr2_ruwe
    ADD CONSTRAINT dr19_gaia_dr2_ruwe_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_gaia_dr2_wd
    ADD CONSTRAINT dr19_gaia_dr2_wd_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_gaia_unwise_agn
    ADD CONSTRAINT dr19_gaia_unwise_agn_gaia_sourceid_fkey FOREIGN KEY (gaia_sourceid) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr19_gaiadr2_tmass_best_neighbour_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_geometric_distances_gaia_dr2
    ADD CONSTRAINT dr19_geometric_distances_gaia_dr2_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_hole
    ADD CONSTRAINT dr19_hole_observatory_pk_fkey FOREIGN KEY (observatory_pk) REFERENCES dbo.dr19_observatory(pk);


ALTER TABLE  dbo.dr19_mipsgal
    ADD CONSTRAINT dr19_mipsgal_twomass_name_fkey FOREIGN KEY (twomass_name) REFERENCES dbo.dr19_twomass_psc(designation);


ALTER TABLE  dbo.dr19_mwm_tess_ob
    ADD CONSTRAINT dr19_mwm_tess_ob_gaia_dr2_id_fkey FOREIGN KEY (gaia_dr2_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_opsdb_apo_camera_frame
    ADD CONSTRAINT dr19_opsdb_apo_camera_frame_camera_pk_fkey FOREIGN KEY (camera_pk) REFERENCES dbo.dr19_opsdb_apo_camera(pk);


ALTER TABLE  dbo.dr19_opsdb_apo_camera_frame
    ADD CONSTRAINT dr19_opsdb_apo_camera_frame_exposure_pk_fkey FOREIGN KEY (exposure_pk) REFERENCES dbo.dr19_opsdb_apo_exposure(pk);


ALTER TABLE  dbo.dr19_opsdb_apo_design_to_status
    ADD CONSTRAINT dr19_opsdb_apo_design_to_status_completion_status_pk_fkey FOREIGN KEY (completion_status_pk) REFERENCES dbo.dr19_opsdb_apo_completion_status(pk);


ALTER TABLE  dbo.dr19_opsdb_apo_exposure
    ADD CONSTRAINT dr19_opsdb_apo_exposure_configuration_id_fkey FOREIGN KEY (configuration_id) REFERENCES dbo.dr19_opsdb_apo_configuration(configuration_id);


ALTER TABLE  dbo.dr19_opsdb_apo_exposure
    ADD CONSTRAINT dr19_opsdb_apo_exposure_exposure_flavor_pk_fkey FOREIGN KEY (exposure_flavor_pk) REFERENCES dbo.dr19_opsdb_apo_exposure_flavor(pk);


ALTER TABLE  dbo.dr19_sagitta
    ADD CONSTRAINT dr19_sagitta_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_sdss_dr16_qso
    ADD CONSTRAINT dr19_sdss_dr16_qso_plate_fiberid_mjd_fkey FOREIGN KEY (plate, fiberid, mjd) REFERENCES dbo.dr19_sdss_dr16_specobj(plate, fiberid, mjd);


ALTER TABLE  dbo.dr19_sdssv_plateholes
    ADD CONSTRAINT dr19_sdssv_plateholes_yanny_uid_fkey FOREIGN KEY (yanny_uid) REFERENCES dbo.dr19_sdssv_plateholes_meta(yanny_uid);


ALTER TABLE  dbo.dr19_skymapper_gaia
    ADD CONSTRAINT dr19_skymapper_gaia_gaia_source_id_fkey FOREIGN KEY (gaia_source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_targeting_generation_to_carton
    ADD CONSTRAINT dr19_targeting_generation_to_carton_carton_pk_fkey FOREIGN KEY (carton_pk) REFERENCES dbo.dr19_carton(carton_pk);


ALTER TABLE  dbo.dr19_targeting_generation_to_version
    ADD CONSTRAINT dr19_targeting_generation_to_version_version_pk_fkey FOREIGN KEY (version_pk) REFERENCES dbo.dr19_targetdb_version(pk);


ALTER TABLE  dbo.dr19_tess_toi
    ADD CONSTRAINT dr19_tess_toi_ticid_fkey FOREIGN KEY (ticid) REFERENCES dbo.dr19_tic_v8(id);


ALTER TABLE  dbo.dr19_tess_toi_v05
    ADD CONSTRAINT dr19_tess_toi_v05_ticid_fkey FOREIGN KEY (ticid) REFERENCES dbo.dr19_tic_v8(id);


ALTER TABLE  dbo.dr19_tic_v8
    ADD CONSTRAINT dr19_tic_v8_gaia_int_fkey FOREIGN KEY (gaia_int) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_tic_v8
    ADD CONSTRAINT dr19_tic_v8_twomass_psc_fkey FOREIGN KEY (twomass_psc) REFERENCES dbo.dr19_twomass_psc(designation);


ALTER TABLE  dbo.dr19_yso_clustering
    ADD CONSTRAINT dr19_yso_clustering_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr19_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr19_zari18pms
    ADD CONSTRAINT dr19_zari18pms_source_fkey FOREIGN KEY (source) REFERENCES dbo.dr19_gaia_dr2_source(source_id);
