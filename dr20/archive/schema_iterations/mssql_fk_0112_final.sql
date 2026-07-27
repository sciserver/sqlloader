

ALTER TABLE dbo.dr20_assignment
    ADD CONSTRAINT dr20_assignment_carton_to_target_pk_fkey FOREIGN KEY (carton_to_target_pk) REFERENCES dbo.dr20_carton_to_target(carton_to_target_pk);


ALTER TABLE dbo.dr20_assignment
    ADD CONSTRAINT dr20_assignment_design_id_fkey FOREIGN KEY (design_id) REFERENCES dbo.dr20_design(design_id);


ALTER TABLE dbo.dr20_assignment
    ADD CONSTRAINT dr20_assignment_hole_pk_fkey FOREIGN KEY (hole_pk) REFERENCES dbo.dr20_hole(pk);


ALTER TABLE dbo.dr20_bailer_jones_edr3
    ADD CONSTRAINT dr20_bailer_jones_edr3_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_best_brightest
    ADD CONSTRAINT dr20_best_brightest_cntr_fkey FOREIGN KEY (cntr) REFERENCES dbo.dr20_allwise(cntr);


ALTER TABLE dbo.dr20_bhm_rm_v1_1
    ADD CONSTRAINT dr20_bhm_rm_v1_1_panstarrs1_catid_objid_fkey FOREIGN KEY (panstarrs1_catid_objid) REFERENCES dbo.dr20_panstarrs1(catid_objid);


ALTER TABLE dbo.dr20_bhm_rm_v1_3
    ADD CONSTRAINT dr20_bhm_rm_v1_3_ls_id_dr8_fkey FOREIGN KEY (ls_id_dr8) REFERENCES dbo.dr20_legacy_survey_dr8(ls_id);


ALTER TABLE dbo.dr20_bhm_rm_v1_3
    ADD CONSTRAINT dr20_bhm_rm_v1_3_panstarrs1_catid_objid_fkey FOREIGN KEY (panstarrs1_catid_objid) REFERENCES dbo.dr20_panstarrs1(catid_objid);


ALTER TABLE dbo.dr20_bhm_rm_v1
    ADD CONSTRAINT dr20_bhm_rm_v1_panstarrs1_catid_objid_fkey FOREIGN KEY (panstarrs1_catid_objid) REFERENCES dbo.dr20_panstarrs1(catid_objid);


ALTER TABLE dbo.dr20_bhm_spiders_agn_superset
    ADD CONSTRAINT dr20_bhm_spiders_agn_superset_gaia_dr2_source_id_fkey FOREIGN KEY (gaia_dr2_source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_bhm_spiders_agn_superset
    ADD CONSTRAINT dr20_bhm_spiders_agn_superset_ls_id_fkey FOREIGN KEY (ls_id) REFERENCES dbo.dr20_legacy_survey_dr8(ls_id);


ALTER TABLE dbo.dr20_bhm_spiders_clusters_superset
    ADD CONSTRAINT dr20_bhm_spiders_clusters_superset_gaia_dr2_source_id_fkey FOREIGN KEY (gaia_dr2_source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_bhm_spiders_clusters_superset
    ADD CONSTRAINT dr20_bhm_spiders_clusters_superset_ls_id_fkey FOREIGN KEY (ls_id) REFERENCES dbo.dr20_legacy_survey_dr8(ls_id);


ALTER TABLE dbo.dr20_carton
    ADD CONSTRAINT dr20_carton_target_selection_plan_fkey FOREIGN KEY (target_selection_plan) REFERENCES dbo.dr20_targetdb_version(planname);


ALTER TABLE dbo.dr20_cataclysmic_variables
    ADD CONSTRAINT dr20_cataclysmic_variables_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_catalog_to_allstar_dr17_synspec_rev1
    ADD CONSTRAINT dr20_catalog_to_allstar_dr17_synspec_rev1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_allstar_dr17_synspec_rev1(apstar_id);


ALTER TABLE dbo.dr20_catalog_to_allwise
    ADD CONSTRAINT dr20_catalog_to_allwise_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_allwise(cntr);


ALTER TABLE dbo.dr20_catalog_to_bhm_csc
    ADD CONSTRAINT dr20_catalog_to_bhm_csc_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_bhm_csc(pk);


ALTER TABLE dbo.dr20_catalog_to_bhm_rm_v0_2
    ADD CONSTRAINT dr20_catalog_to_bhm_rm_v0_2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_bhm_rm_v0_2(pk);


ALTER TABLE dbo.dr20_catalog_to_bhm_rm_v0
    ADD CONSTRAINT dr20_catalog_to_bhm_rm_v0_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_bhm_rm_v0(pk);


ALTER TABLE dbo.dr20_catalog_to_catwise2020
    ADD CONSTRAINT dr20_catalog_to_catwise2020_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_catwise2020(source_id);


ALTER TABLE dbo.dr20_catalog_to_gaia_dr2_source
    ADD CONSTRAINT dr20_catalog_to_gaia_dr2_source_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_catalog_to_gaia_dr3_source
    ADD CONSTRAINT dr20_catalog_to_gaia_dr3_source_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_catalog_to_glimpse
    ADD CONSTRAINT dr20_catalog_to_glimpse_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_glimpse(pk);


ALTER TABLE dbo.dr20_catalog_to_guvcat
    ADD CONSTRAINT dr20_catalog_to_guvcat_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_guvcat(objid);


ALTER TABLE dbo.dr20_catalog_to_legacy_survey_dr10
    ADD CONSTRAINT dr20_catalog_to_legacy_survey_dr10_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_legacy_survey_dr10(ls_id);


ALTER TABLE dbo.dr20_catalog_to_legacy_survey_dr8
    ADD CONSTRAINT dr20_catalog_to_legacy_survey_dr8_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_legacy_survey_dr8(ls_id);


ALTER TABLE dbo.dr20_catalog_to_mangatarget
    ADD CONSTRAINT dr20_catalog_to_mangatarget_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_mangatarget(mangaid);


ALTER TABLE dbo.dr20_catalog_to_marvels_dr11_star
    ADD CONSTRAINT dr20_catalog_to_marvels_dr11_star_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_marvels_dr11_star(starname);


ALTER TABLE dbo.dr20_catalog_to_marvels_dr12_star
    ADD CONSTRAINT dr20_catalog_to_marvels_dr12_star_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_marvels_dr12_star(pk);


ALTER TABLE dbo.dr20_catalog_to_mastar_goodstars
    ADD CONSTRAINT dr20_catalog_to_mastar_goodstars_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_mastar_goodstars(mangaid);


ALTER TABLE dbo.dr20_catalog_to_milliquas_7_7
    ADD CONSTRAINT dr20_catalog_to_milliquas_7_7_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_milliquas_7_7(pk);


ALTER TABLE dbo.dr20_catalog_to_panstarrs1
    ADD CONSTRAINT dr20_catalog_to_panstarrs1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_panstarrs1(catid_objid);


ALTER TABLE dbo.dr20_catalog_to_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr20_catalog_to_sdss_dr13_photoobj_primary_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_sdss_dr13_photoobj_primary(objid);


ALTER TABLE dbo.dr20_catalog_to_sdss_dr16_specobj
    ADD CONSTRAINT dr20_catalog_to_sdss_dr16_specobj_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_sdss_dr16_specobj(specobjid);


ALTER TABLE dbo.dr20_catalog_to_sdss_dr17_specobj
    ADD CONSTRAINT dr20_catalog_to_sdss_dr17_specobj_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_sdss_dr17_specobj(specobjid);


ALTER TABLE dbo.dr20_catalog_to_skies_v1
    ADD CONSTRAINT dr20_catalog_to_skies_v1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_skies_v1(pix_32768);


ALTER TABLE dbo.dr20_catalog_to_skies_v2
    ADD CONSTRAINT dr20_catalog_to_skies_v2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_skies_v2(pix_32768);


ALTER TABLE dbo.dr20_catalog_to_skymapper_dr2
    ADD CONSTRAINT dr20_catalog_to_skymapper_dr2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_skymapper_dr2(object_id);


ALTER TABLE dbo.dr20_catalog_to_supercosmos
    ADD CONSTRAINT dr20_catalog_to_supercosmos_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_supercosmos(objid);


ALTER TABLE dbo.dr20_catalog_to_tic_v8
    ADD CONSTRAINT dr20_catalog_to_tic_v8_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_tic_v8(id);


ALTER TABLE dbo.dr20_catalog_to_twomass_psc
    ADD CONSTRAINT dr20_catalog_to_twomass_psc_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_twomass_psc(pts_key);


ALTER TABLE dbo.dr20_catalog_to_tycho2
    ADD CONSTRAINT dr20_catalog_to_tycho2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_tycho2(designation);


ALTER TABLE dbo.dr20_catalog_to_unwise
    ADD CONSTRAINT dr20_catalog_to_unwise_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_unwise(unwise_objid);


ALTER TABLE dbo.dr20_catalog_to_uvotssc1
    ADD CONSTRAINT dr20_catalog_to_uvotssc1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_uvotssc1(id);


ALTER TABLE dbo.dr20_catalog_to_xmm_om_suss_4_1
    ADD CONSTRAINT dr20_catalog_to_xmm_om_suss_4_1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_xmm_om_suss_4_1(pk);


ALTER TABLE dbo.dr20_catalog_to_xmm_om_suss_5_0
    ADD CONSTRAINT dr20_catalog_to_xmm_om_suss_5_0_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr20_xmm_om_suss_5_0(pk);


ALTER TABLE dbo.dr20_design
    ADD CONSTRAINT dr20_design_design_mode_label_fkey FOREIGN KEY (design_mode_label) REFERENCES dbo.dr20_design_mode(label);


ALTER TABLE dbo.dr20_design_mode_check_results
    ADD CONSTRAINT dr20_design_mode_check_results_design_id_fkey FOREIGN KEY (design_id) REFERENCES dbo.dr20_design(design_id);


ALTER TABLE dbo.dr20_design_to_field
    ADD CONSTRAINT dr20_design_to_field_design_id_fkey FOREIGN KEY (design_id) REFERENCES dbo.dr20_design(design_id);


ALTER TABLE dbo.dr20_design_to_field
    ADD CONSTRAINT dr20_design_to_field_field_pk_fkey FOREIGN KEY (field_pk) REFERENCES dbo.dr20_field(pk);


ALTER TABLE dbo.dr20_ebosstarget_v5
    ADD CONSTRAINT dr20_ebosstarget_v5_objid_targeting_fkey FOREIGN KEY (objid_targeting) REFERENCES dbo.dr20_sdss_dr13_photoobj_primary(objid);


ALTER TABLE dbo.dr20_erosita_superset_compactobjects
    ADD CONSTRAINT dr20_erosita_superset_compactobjects_gaia_dr2_id_fkey FOREIGN KEY (gaia_dr2_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_erosita_superset_stars
    ADD CONSTRAINT dr20_erosita_superset_stars_gaia_dr2_id_fkey FOREIGN KEY (gaia_dr2_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_erosita_superset_v1_agn
    ADD CONSTRAINT dr20_erosita_superset_v1_agn_gaia_dr3_source_id_fkey FOREIGN KEY (gaia_dr3_source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_erosita_superset_v1_agn
    ADD CONSTRAINT dr20_erosita_superset_v1_agn_ls_id_fkey FOREIGN KEY (ls_id) REFERENCES dbo.dr20_legacy_survey_dr10(ls_id);


ALTER TABLE dbo.dr20_erosita_superset_v1_clusters
    ADD CONSTRAINT dr20_erosita_superset_v1_clusters_gaia_dr3_source_id_fkey FOREIGN KEY (gaia_dr3_source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_erosita_superset_v1_clusters
    ADD CONSTRAINT dr20_erosita_superset_v1_clusters_ls_id_fkey FOREIGN KEY (ls_id) REFERENCES dbo.dr20_legacy_survey_dr10(ls_id);


ALTER TABLE dbo.dr20_erosita_superset_v1_compactobjects
    ADD CONSTRAINT dr20_erosita_superset_v1_compactobjects_gaia_dr3_source_id_fkey FOREIGN KEY (gaia_dr3_source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_erosita_superset_v1_compactobjects
    ADD CONSTRAINT dr20_erosita_superset_v1_compactobjects_ls_id_fkey FOREIGN KEY (ls_id) REFERENCES dbo.dr20_legacy_survey_dr10(ls_id);


ALTER TABLE dbo.dr20_erosita_superset_v1_stars
    ADD CONSTRAINT dr20_erosita_superset_v1_stars_gaia_dr3_source_id_fkey FOREIGN KEY (gaia_dr3_source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_erosita_superset_v1_stars
    ADD CONSTRAINT dr20_erosita_superset_v1_stars_ls_id_fkey FOREIGN KEY (ls_id) REFERENCES dbo.dr20_legacy_survey_dr10(ls_id);


ALTER TABLE dbo.dr20_field
    ADD CONSTRAINT dr20_field_observatory_pk_fkey FOREIGN KEY (observatory_pk) REFERENCES dbo.dr20_observatory(pk);


ALTER TABLE dbo.dr20_field
    ADD CONSTRAINT dr20_field_version_pk_fkey FOREIGN KEY (version_pk) REFERENCES dbo.dr20_targetdb_version(pk);


ALTER TABLE dbo.dr20_gaia_assas_sn_cepheids
    ADD CONSTRAINT dr20_gaia_assas_sn_cepheids_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_gaia_dr2_ruwe
    ADD CONSTRAINT dr20_gaia_dr2_ruwe_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_gaia_dr2_wd
    ADD CONSTRAINT dr20_gaia_dr2_wd_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_gaia_dr3_astrophysical_parameters
    ADD CONSTRAINT dr20_gaia_dr3_astrophysical_parameters_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_gaia_dr3_nss_two_body_orbit
    ADD CONSTRAINT dr20_gaia_dr3_nss_two_body_orbit_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_gaia_dr3_synthetic_photometry_gspc
    ADD CONSTRAINT dr20_gaia_dr3_synthetic_photometry_gspc_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_gaia_dr3_vari_rrlyrae
    ADD CONSTRAINT dr20_gaia_dr3_vari_rrlyrae_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_gaia_unwise_agn
    ADD CONSTRAINT dr20_gaia_unwise_agn_gaia_sourceid_fkey FOREIGN KEY (gaia_sourceid) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr20_gaiadr2_tmass_best_neighbour_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_galah_dr3
    ADD CONSTRAINT dr20_galah_dr3_dr2_source_id_fkey FOREIGN KEY (dr2_source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_galah_dr3
    ADD CONSTRAINT dr20_galah_dr3_dr3_source_id_fkey FOREIGN KEY (dr3_source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_galex_gr7_gaia_dr3
    ADD CONSTRAINT dr20_galex_gr7_gaia_dr3_gaia_edr3_source_id_fkey FOREIGN KEY (gaia_edr3_source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_gedr3spur_main
    ADD CONSTRAINT dr20_gedr3spur_main_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_geometric_distances_gaia_dr2
    ADD CONSTRAINT dr20_geometric_distances_gaia_dr2_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_hole
    ADD CONSTRAINT dr20_hole_observatory_pk_fkey FOREIGN KEY (observatory_pk) REFERENCES dbo.dr20_observatory(pk);


ALTER TABLE dbo.dr20_mipsgal
    ADD CONSTRAINT dr20_mipsgal_twomass_name_fkey FOREIGN KEY (twomass_name) REFERENCES dbo.dr20_twomass_psc(designation);


ALTER TABLE dbo.dr20_mwm_tess_ob
    ADD CONSTRAINT dr20_mwm_tess_ob_gaia_dr2_id_fkey FOREIGN KEY (gaia_dr2_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_opsdb_apo_camera_frame
    ADD CONSTRAINT dr20_opsdb_apo_camera_frame_camera_pk_fkey FOREIGN KEY (camera_pk) REFERENCES dbo.dr20_opsdb_apo_camera(pk);


ALTER TABLE dbo.dr20_opsdb_apo_exposure
    ADD CONSTRAINT dr20_opsdb_apo_exposure_exposure_flavor_pk_fkey FOREIGN KEY (exposure_flavor_pk) REFERENCES dbo.dr20_opsdb_apo_exposure_flavor(pk);


ALTER TABLE dbo.dr20_opsdb_lco_camera_frame
    ADD CONSTRAINT dr20_opsdb_lco_camera_frame_camera_pk_fkey FOREIGN KEY (camera_pk) REFERENCES dbo.dr20_opsdb_lco_camera(pk);


ALTER TABLE dbo.dr20_opsdb_lco_camera_frame
    ADD CONSTRAINT dr20_opsdb_lco_camera_frame_exposure_pk_fkey FOREIGN KEY (exposure_pk) REFERENCES dbo.dr20_opsdb_lco_exposure(pk);


ALTER TABLE dbo.dr20_opsdb_lco_design_to_status
    ADD CONSTRAINT dr20_opsdb_lco_design_to_status_completion_status_pk_fkey FOREIGN KEY (completion_status_pk) REFERENCES dbo.dr20_opsdb_lco_completion_status(pk);


ALTER TABLE dbo.dr20_opsdb_lco_exposure
    ADD CONSTRAINT dr20_opsdb_lco_exposure_configuration_id_fkey FOREIGN KEY (configuration_id) REFERENCES dbo.dr20_opsdb_lco_configuration(configuration_id);


ALTER TABLE dbo.dr20_opsdb_lco_exposure
    ADD CONSTRAINT dr20_opsdb_lco_exposure_exposure_flavor_pk_fkey FOREIGN KEY (exposure_flavor_pk) REFERENCES dbo.dr20_opsdb_lco_exposure_flavor(pk);


ALTER TABLE dbo.dr20_sagitta_edr3
    ADD CONSTRAINT dr20_sagitta_edr3_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_sagitta
    ADD CONSTRAINT dr20_sagitta_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_sdss_dr16_qso
    ADD CONSTRAINT dr20_sdss_dr16_qso_plate_fiberid_mjd_fkey FOREIGN KEY (plate, fiberid, mjd) REFERENCES dbo.dr20_sdss_dr16_specobj(plate, fiberid, mjd);


ALTER TABLE dbo.dr20_sdssv_plateholes
    ADD CONSTRAINT dr20_sdssv_plateholes_yanny_uid_fkey FOREIGN KEY (yanny_uid) REFERENCES dbo.dr20_sdssv_plateholes_meta(yanny_uid);


ALTER TABLE dbo.dr20_skymapper_gaia
    ADD CONSTRAINT dr20_skymapper_gaia_gaia_source_id_fkey FOREIGN KEY (gaia_source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_targeting_generation_to_carton
    ADD CONSTRAINT dr20_targeting_generation_to_carton_carton_pk_fkey FOREIGN KEY (carton_pk) REFERENCES dbo.dr20_carton(carton_pk);


ALTER TABLE dbo.dr20_targeting_generation_to_version
    ADD CONSTRAINT dr20_targeting_generation_to_version_version_pk_fkey FOREIGN KEY (version_pk) REFERENCES dbo.dr20_targetdb_version(pk);


ALTER TABLE dbo.dr20_tess_toi
    ADD CONSTRAINT dr20_tess_toi_ticid_fkey FOREIGN KEY (ticid) REFERENCES dbo.dr20_tic_v8(id);


ALTER TABLE dbo.dr20_tess_toi_v05
    ADD CONSTRAINT dr20_tess_toi_v05_ticid_fkey FOREIGN KEY (ticid) REFERENCES dbo.dr20_tic_v8(id);


ALTER TABLE dbo.dr20_tess_toi_v1
    ADD CONSTRAINT dr20_tess_toi_v1_ticid_fkey FOREIGN KEY (ticid) REFERENCES dbo.dr20_tic_v8(id);


ALTER TABLE dbo.dr20_wd_gaia_dr3
    ADD CONSTRAINT dr20_wd_gaia_dr3_gaiaedr3_fkey FOREIGN KEY (gaiaedr3) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_xpfeh_gaia_dr3
    ADD CONSTRAINT dr20_xpfeh_gaia_dr3_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr3_source(source_id);


ALTER TABLE dbo.dr20_yso_clustering
    ADD CONSTRAINT dr20_yso_clustering_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr20_gaia_dr2_source(source_id);


ALTER TABLE dbo.dr20_zari18pms
    ADD CONSTRAINT dr20_zari18pms_source_fkey FOREIGN KEY (source) REFERENCES dbo.dr20_gaia_dr2_source(source_id);
