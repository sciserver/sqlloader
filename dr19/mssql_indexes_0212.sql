

CREATE NONCLUSTERED INDEX dr19_allstar_dr17_synspec_rev1_apogee_id_idx ON dbo.dr19_allstar_dr17_synspec_rev1  (apogee_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_allstar_dr17_synspec_rev1_aspcap_id_idx ON dbo.dr19_allstar_dr17_synspec_rev1  (aspcap_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_allwise_designation_idx ON dbo.dr19_allwise  (designation) ON [SPEC];


--CREATE NONCLUSTERED INDEX dr19_allwise_expr_idx ON dbo.dr19_allwise  (((w1mpro - w2mpro))) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_allwise_ph_qual_idx ON dbo.dr19_allwise  (ph_qual) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_allwise_w1mpro_idx ON dbo.dr19_allwise  (w1mpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_allwise_w1sigmpro_idx ON dbo.dr19_allwise  (w1sigmpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_allwise_w2mpro_idx ON dbo.dr19_allwise  (w2mpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_allwise_w2sigmpro_idx ON dbo.dr19_allwise  (w2sigmpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_allwise_w3mpro_idx ON dbo.dr19_allwise  (w3mpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_allwise_w3sigmpro_idx ON dbo.dr19_allwise  (w3sigmpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_assignment_carton_to_target_pk_idx ON dbo.dr19_assignment  (carton_to_target_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_assignment_design_id_idx ON dbo.dr19_assignment  (design_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_assignment_hole_pk_idx ON dbo.dr19_assignment  (hole_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_assignment_instrument_pk_idx ON dbo.dr19_assignment  (instrument_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_best_brightest_gmag_idx ON dbo.dr19_best_brightest  (gmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_best_brightest_version_idx ON dbo.dr19_best_brightest  (version) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_mag_g_idx ON dbo.dr19_bhm_csc  (mag_g) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_mag_h_idx ON dbo.dr19_bhm_csc  (mag_h) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_mag_i_idx ON dbo.dr19_bhm_csc  (mag_i) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_mag_r_idx ON dbo.dr19_bhm_csc  (mag_r) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_mag_z_idx ON dbo.dr19_bhm_csc  (mag_z) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_cxoid_idx ON dbo.dr19_bhm_csc_v2  (cxoid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_designation2m_idx ON dbo.dr19_bhm_csc_v2  (designation2m) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_hmag_idx ON dbo.dr19_bhm_csc_v2  (hmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_idg2_idx ON dbo.dr19_bhm_csc_v2  (idg2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_idps_idx ON dbo.dr19_bhm_csc_v2  (idps) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_ocat_idx ON dbo.dr19_bhm_csc_v2  (ocat) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_oid_idx ON dbo.dr19_bhm_csc_v2  (oid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_omag_idx ON dbo.dr19_bhm_csc_v2  (omag) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_bhm_efeds_veto_fiberid_idx ON dbo.dr19_bhm_efeds_veto  (fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_efeds_veto_mjd_idx ON dbo.dr19_bhm_efeds_veto  (mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_efeds_veto_plate_idx ON dbo.dr19_bhm_efeds_veto  (plate) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_bhm_efeds_veto_run2d_idx ON dbo.dr19_bhm_efeds_veto  (run2d) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_efeds_veto_tile_idx ON dbo.dr19_bhm_efeds_veto  (tile) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_catalogid_idx ON dbo.dr19_bhm_rm_tweaks  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_date_set_idx ON dbo.dr19_bhm_rm_tweaks  (date_set) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_fiberid_idx ON dbo.dr19_bhm_rm_tweaks  (fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_firstcarton_idx ON dbo.dr19_bhm_rm_tweaks  (firstcarton) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_gaia_g_idx ON dbo.dr19_bhm_rm_tweaks  (gaia_g) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_in_plate_idx ON dbo.dr19_bhm_rm_tweaks  (in_plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_mjd_idx ON dbo.dr19_bhm_rm_tweaks  (mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_plate_idx ON dbo.dr19_bhm_rm_tweaks  (plate) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_rm_field_name_idx ON dbo.dr19_bhm_rm_tweaks  (rm_field_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_rm_suitability_idx ON dbo.dr19_bhm_rm_tweaks  (rm_suitability) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_2_coadd_object_id_idx ON dbo.dr19_bhm_rm_v0_2  (coadd_object_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_2_id_nsc_idx ON dbo.dr19_bhm_rm_v0_2  (id_nsc) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_2_objid_ps1_idx ON dbo.dr19_bhm_rm_v0_2  (objid_ps1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_2_objid_sdss_idx ON dbo.dr19_bhm_rm_v0_2  (objid_sdss) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_2_objid_unwise_idx ON dbo.dr19_bhm_rm_v0_2  (objid_unwise) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_2_source_id_gaia_idx ON dbo.dr19_bhm_rm_v0_2  (source_id_gaia) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_2_sourceid_ir_idx ON dbo.dr19_bhm_rm_v0_2  (sourceid_ir) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_mi_idx ON dbo.dr19_bhm_rm_v0  (mi) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_objid_sdss_idx ON dbo.dr19_bhm_rm_v0  (objid_sdss) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_objid_unwise_idx ON dbo.dr19_bhm_rm_v0  (objid_unwise) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_photo_bitmask_idx ON dbo.dr19_bhm_rm_v0  (photo_bitmask) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_plxsig_idx ON dbo.dr19_bhm_rm_v0  (plxsig) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_pmsig_idx ON dbo.dr19_bhm_rm_v0  (pmsig) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_skewt_qso_idx ON dbo.dr19_bhm_rm_v0  (skewt_qso) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_source_id_gaia_idx ON dbo.dr19_bhm_rm_v0  (source_id_gaia) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_spec_q_idx ON dbo.dr19_bhm_rm_v0  (spec_q) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_spiders_agn_superset_ero_flux_idx ON dbo.dr19_bhm_spiders_agn_superset  (ero_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_spiders_agn_superset_gaia_dr2_source_id_idx ON dbo.dr19_bhm_spiders_agn_superset  (gaia_dr2_source_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_spiders_agn_superset_ls_id_idx ON dbo.dr19_bhm_spiders_agn_superset  (ls_id) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_bhm_spiders_clusters_superset_ero_flux_idx ON dbo.dr19_bhm_spiders_clusters_superset  (ero_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_spiders_clusters_superset_gaia_dr2_source_id_idx ON dbo.dr19_bhm_spiders_clusters_superset  (gaia_dr2_source_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_bhm_spiders_clusters_superset_ls_id_idx ON dbo.dr19_bhm_spiders_clusters_superset  (ls_id) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_cadence_epoch_cadence_pk_idx ON dbo.dr19_cadence_epoch  (cadence_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_cadence_epoch_label_idx ON dbo.dr19_cadence_epoch  (label) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_carton_csv_carton_idx ON dbo.dr19_carton_csv  (carton) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_carton_csv_carton_pk_idx ON dbo.dr19_carton_csv  (carton_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_carton_csv_version_pk_idx ON dbo.dr19_carton_csv  (version_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_carton_to_target_cadence_pk_idx ON dbo.dr19_carton_to_target  (cadence_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_carton_to_target_carton_pk_idx ON dbo.dr19_carton_to_target  (carton_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_carton_to_target_instrument_pk_idx ON dbo.dr19_carton_to_target  (instrument_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_carton_to_target_target_pk_idx ON dbo.dr19_carton_to_target  (target_pk) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_cataclysmic_variables_source_id_idx ON dbo.dr19_cataclysmic_variables  (source_id) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_catalog_to_allstar_dr17_synspec_rev1_catalogid_idx ON dbo.dr19_catalog_to_allstar_dr17_synspec_rev1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allstar_dr17_synspec_rev1_target_id_idx ON dbo.dr19_catalog_to_allstar_dr17_synspec_rev1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allstar_dr17_synspec_rev1_version_id_idx ON dbo.dr19_catalog_to_allstar_dr17_synspec_rev1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_best_idx ON dbo.dr19_catalog_to_allwise  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_best_idx1 ON dbo.dr19_catalog_to_allwise  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_catalogid_idx ON dbo.dr19_catalog_to_allwise  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_catalogid_idx1 ON dbo.dr19_catalog_to_allwise  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_target_id_idx ON dbo.dr19_catalog_to_allwise  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_target_id_idx1 ON dbo.dr19_catalog_to_allwise  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_version_id_idx ON dbo.dr19_catalog_to_allwise  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_version_id_idx1 ON dbo.dr19_catalog_to_allwise  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_allwise_version_id_target_id_best_idx ON dbo.dr19_catalog_to_allwise  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_best_idx ON dbo.dr19_catalog_to_bhm_csc  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_best_idx1 ON dbo.dr19_catalog_to_bhm_csc  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_catalogid_idx ON dbo.dr19_catalog_to_bhm_csc  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_catalogid_idx1 ON dbo.dr19_catalog_to_bhm_csc  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_target_id_idx ON dbo.dr19_catalog_to_bhm_csc  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_target_id_idx1 ON dbo.dr19_catalog_to_bhm_csc  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_version_id_idx ON dbo.dr19_catalog_to_bhm_csc  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_version_id_idx1 ON dbo.dr19_catalog_to_bhm_csc  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_csc_version_id_target_id_best_idx ON dbo.dr19_catalog_to_bhm_csc  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_best_idx ON dbo.dr19_catalog_to_bhm_efeds_veto  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_best_idx1 ON dbo.dr19_catalog_to_bhm_efeds_veto  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_catalogid_idx ON dbo.dr19_catalog_to_bhm_efeds_veto  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_catalogid_idx1 ON dbo.dr19_catalog_to_bhm_efeds_veto  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_target_id_idx ON dbo.dr19_catalog_to_bhm_efeds_veto  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_target_id_idx1 ON dbo.dr19_catalog_to_bhm_efeds_veto  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_version_id_idx ON dbo.dr19_catalog_to_bhm_efeds_veto  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_version_id_idx1 ON dbo.dr19_catalog_to_bhm_efeds_veto  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_efeds_veto_version_id_target_id_best_idx ON dbo.dr19_catalog_to_bhm_efeds_veto  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_best_idx ON dbo.dr19_catalog_to_bhm_rm_v0_2  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_best_idx1 ON dbo.dr19_catalog_to_bhm_rm_v0_2  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_catalogid_idx ON dbo.dr19_catalog_to_bhm_rm_v0_2  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_catalogid_idx1 ON dbo.dr19_catalog_to_bhm_rm_v0_2  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_target_id_idx ON dbo.dr19_catalog_to_bhm_rm_v0_2  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_target_id_idx1 ON dbo.dr19_catalog_to_bhm_rm_v0_2  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_version_id_idx ON dbo.dr19_catalog_to_bhm_rm_v0_2  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_version_id_idx1 ON dbo.dr19_catalog_to_bhm_rm_v0_2  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_2_version_id_target_id_best_idx ON dbo.dr19_catalog_to_bhm_rm_v0_2  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_best_idx ON dbo.dr19_catalog_to_bhm_rm_v0  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_best_idx1 ON dbo.dr19_catalog_to_bhm_rm_v0  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_catalogid_idx ON dbo.dr19_catalog_to_bhm_rm_v0  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_catalogid_idx1 ON dbo.dr19_catalog_to_bhm_rm_v0  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_target_id_idx ON dbo.dr19_catalog_to_bhm_rm_v0  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_target_id_idx1 ON dbo.dr19_catalog_to_bhm_rm_v0  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_version_id_idx ON dbo.dr19_catalog_to_bhm_rm_v0  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_version_id_idx1 ON dbo.dr19_catalog_to_bhm_rm_v0  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_bhm_rm_v0_version_id_target_id_best_idx ON dbo.dr19_catalog_to_bhm_rm_v0  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_best_idx ON dbo.dr19_catalog_to_catwise2020  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_best_idx1 ON dbo.dr19_catalog_to_catwise2020  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_catalogid_idx ON dbo.dr19_catalog_to_catwise2020  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_catalogid_idx1 ON dbo.dr19_catalog_to_catwise2020  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_target_id_idx ON dbo.dr19_catalog_to_catwise2020  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_target_id_idx1 ON dbo.dr19_catalog_to_catwise2020  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_version_id_idx ON dbo.dr19_catalog_to_catwise2020  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_version_id_idx1 ON dbo.dr19_catalog_to_catwise2020  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_catwise2020_version_id_target_id_best_idx ON dbo.dr19_catalog_to_catwise2020  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_gaia_dr2_source_best_idx ON dbo.dr19_catalog_to_gaia_dr2_source  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_gaia_dr2_source_catalogid_idx ON dbo.dr19_catalog_to_gaia_dr2_source  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_gaia_dr2_source_target_id_idx ON dbo.dr19_catalog_to_gaia_dr2_source  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_gaia_dr2_source_version_id_idx ON dbo.dr19_catalog_to_gaia_dr2_source  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_best_idx ON dbo.dr19_catalog_to_glimpse  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_best_idx1 ON dbo.dr19_catalog_to_glimpse  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_catalogid_idx ON dbo.dr19_catalog_to_glimpse  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_catalogid_idx1 ON dbo.dr19_catalog_to_glimpse  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_target_id_idx ON dbo.dr19_catalog_to_glimpse  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_target_id_idx1 ON dbo.dr19_catalog_to_glimpse  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_version_id_idx ON dbo.dr19_catalog_to_glimpse  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_version_id_idx1 ON dbo.dr19_catalog_to_glimpse  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_glimpse_version_id_target_id_best_idx ON dbo.dr19_catalog_to_glimpse  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_best_idx ON dbo.dr19_catalog_to_guvcat  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_best_idx1 ON dbo.dr19_catalog_to_guvcat  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_catalogid_idx ON dbo.dr19_catalog_to_guvcat  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_catalogid_idx1 ON dbo.dr19_catalog_to_guvcat  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_target_id_idx ON dbo.dr19_catalog_to_guvcat  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_target_id_idx1 ON dbo.dr19_catalog_to_guvcat  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_version_id_idx ON dbo.dr19_catalog_to_guvcat  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_version_id_idx1 ON dbo.dr19_catalog_to_guvcat  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_guvcat_version_id_target_id_best_idx ON dbo.dr19_catalog_to_guvcat  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_best_idx ON dbo.dr19_catalog_to_legacy_survey_dr8  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_best_idx1 ON dbo.dr19_catalog_to_legacy_survey_dr8  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_catalogid_idx ON dbo.dr19_catalog_to_legacy_survey_dr8  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_catalogid_idx1 ON dbo.dr19_catalog_to_legacy_survey_dr8  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_target_id_idx ON dbo.dr19_catalog_to_legacy_survey_dr8  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_target_id_idx1 ON dbo.dr19_catalog_to_legacy_survey_dr8  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_version_id_idx ON dbo.dr19_catalog_to_legacy_survey_dr8  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_version_id_idx1 ON dbo.dr19_catalog_to_legacy_survey_dr8  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_legacy_survey_dr8_version_id_target_id_best_idx ON dbo.dr19_catalog_to_legacy_survey_dr8  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_mangatarget_catalogid_idx ON dbo.dr19_catalog_to_mangatarget  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_mangatarget_target_id_idx ON dbo.dr19_catalog_to_mangatarget  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_mangatarget_version_id_idx ON dbo.dr19_catalog_to_mangatarget  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_marvels_dr11_star_catalogid_idx ON dbo.dr19_catalog_to_marvels_dr11_star  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_marvels_dr11_star_target_id_idx ON dbo.dr19_catalog_to_marvels_dr11_star  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_marvels_dr11_star_version_id_idx ON dbo.dr19_catalog_to_marvels_dr11_star  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_marvels_dr12_star_catalogid_idx ON dbo.dr19_catalog_to_marvels_dr12_star  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_marvels_dr12_star_target_id_idx ON dbo.dr19_catalog_to_marvels_dr12_star  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_marvels_dr12_star_version_id_idx ON dbo.dr19_catalog_to_marvels_dr12_star  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_mastar_goodstars_catalogid_idx ON dbo.dr19_catalog_to_mastar_goodstars  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_mastar_goodstars_target_id_idx ON dbo.dr19_catalog_to_mastar_goodstars  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_mastar_goodstars_version_id_idx ON dbo.dr19_catalog_to_mastar_goodstars  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_best_idx ON dbo.dr19_catalog_to_panstarrs1  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_best_idx1 ON dbo.dr19_catalog_to_panstarrs1  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_catalogid_idx ON dbo.dr19_catalog_to_panstarrs1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_catalogid_idx1 ON dbo.dr19_catalog_to_panstarrs1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_target_id_idx ON dbo.dr19_catalog_to_panstarrs1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_target_id_idx1 ON dbo.dr19_catalog_to_panstarrs1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_version_id_idx ON dbo.dr19_catalog_to_panstarrs1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_version_id_idx1 ON dbo.dr19_catalog_to_panstarrs1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_panstarrs1_version_id_target_id_best_idx ON dbo.dr19_catalog_to_panstarrs1  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoob_version_id_target_id_best_idx ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoobj_primary_best_idx ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoobj_primary_best_idx1 ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoobj_primary_catalogid_idx ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoobj_primary_catalogid_idx1 ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoobj_primary_target_id_idx ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoobj_primary_target_id_idx1 ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoobj_primary_version_id_idx ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr13_photoobj_primary_version_id_idx1 ON dbo.dr19_catalog_to_sdss_dr13_photoobj_primary  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_best_idx ON dbo.dr19_catalog_to_sdss_dr16_specobj  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_best_idx1 ON dbo.dr19_catalog_to_sdss_dr16_specobj  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_catalogid_idx ON dbo.dr19_catalog_to_sdss_dr16_specobj  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_catalogid_idx1 ON dbo.dr19_catalog_to_sdss_dr16_specobj  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_target_id_idx ON dbo.dr19_catalog_to_sdss_dr16_specobj  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_target_id_idx1 ON dbo.dr19_catalog_to_sdss_dr16_specobj  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_version_id_idx ON dbo.dr19_catalog_to_sdss_dr16_specobj  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_version_id_idx1 ON dbo.dr19_catalog_to_sdss_dr16_specobj  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr16_specobj_version_id_target_id_best_idx ON dbo.dr19_catalog_to_sdss_dr16_specobj  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr17_specobj_catalogid_idx ON dbo.dr19_catalog_to_sdss_dr17_specobj  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr17_specobj_target_id_idx ON dbo.dr19_catalog_to_sdss_dr17_specobj  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_sdss_dr17_specobj_version_id_idx ON dbo.dr19_catalog_to_sdss_dr17_specobj  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_best_idx ON dbo.dr19_catalog_to_skies_v1  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_best_idx1 ON dbo.dr19_catalog_to_skies_v1  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_catalogid_idx ON dbo.dr19_catalog_to_skies_v1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_catalogid_idx1 ON dbo.dr19_catalog_to_skies_v1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_target_id_idx ON dbo.dr19_catalog_to_skies_v1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_target_id_idx1 ON dbo.dr19_catalog_to_skies_v1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_version_id_idx ON dbo.dr19_catalog_to_skies_v1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_version_id_idx1 ON dbo.dr19_catalog_to_skies_v1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v1_version_id_target_id_best_idx ON dbo.dr19_catalog_to_skies_v1  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_best_idx ON dbo.dr19_catalog_to_skies_v2  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_best_idx1 ON dbo.dr19_catalog_to_skies_v2  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_catalogid_idx ON dbo.dr19_catalog_to_skies_v2  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_catalogid_idx1 ON dbo.dr19_catalog_to_skies_v2  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_target_id_idx ON dbo.dr19_catalog_to_skies_v2  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_target_id_idx1 ON dbo.dr19_catalog_to_skies_v2  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_version_id_idx ON dbo.dr19_catalog_to_skies_v2  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_version_id_idx1 ON dbo.dr19_catalog_to_skies_v2  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skies_v2_version_id_target_id_best_idx ON dbo.dr19_catalog_to_skies_v2  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_best_idx ON dbo.dr19_catalog_to_skymapper_dr2  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_best_idx1 ON dbo.dr19_catalog_to_skymapper_dr2  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_catalogid_idx ON dbo.dr19_catalog_to_skymapper_dr2  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_catalogid_idx1 ON dbo.dr19_catalog_to_skymapper_dr2  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_target_id_idx ON dbo.dr19_catalog_to_skymapper_dr2  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_target_id_idx1 ON dbo.dr19_catalog_to_skymapper_dr2  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_version_id_idx ON dbo.dr19_catalog_to_skymapper_dr2  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_version_id_idx1 ON dbo.dr19_catalog_to_skymapper_dr2  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_skymapper_dr2_version_id_target_id_best_idx ON dbo.dr19_catalog_to_skymapper_dr2  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_best_idx ON dbo.dr19_catalog_to_supercosmos  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_best_idx1 ON dbo.dr19_catalog_to_supercosmos  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_catalogid_idx ON dbo.dr19_catalog_to_supercosmos  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_catalogid_idx1 ON dbo.dr19_catalog_to_supercosmos  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_target_id_idx ON dbo.dr19_catalog_to_supercosmos  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_target_id_idx1 ON dbo.dr19_catalog_to_supercosmos  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_version_id_idx ON dbo.dr19_catalog_to_supercosmos  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_version_id_idx1 ON dbo.dr19_catalog_to_supercosmos  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_supercosmos_version_id_target_id_best_idx ON dbo.dr19_catalog_to_supercosmos  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_best_idx ON dbo.dr19_catalog_to_tic_v8  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_best_idx1 ON dbo.dr19_catalog_to_tic_v8  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_catalogid_idx ON dbo.dr19_catalog_to_tic_v8  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_catalogid_idx1 ON dbo.dr19_catalog_to_tic_v8  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_target_id_idx ON dbo.dr19_catalog_to_tic_v8  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_target_id_idx1 ON dbo.dr19_catalog_to_tic_v8  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_version_id_idx ON dbo.dr19_catalog_to_tic_v8  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_version_id_idx1 ON dbo.dr19_catalog_to_tic_v8  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tic_v8_version_id_target_id_best_idx ON dbo.dr19_catalog_to_tic_v8  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_twomass_psc_best_idx ON dbo.dr19_catalog_to_twomass_psc  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_twomass_psc_catalogid_idx ON dbo.dr19_catalog_to_twomass_psc  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_twomass_psc_target_id_idx ON dbo.dr19_catalog_to_twomass_psc  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_twomass_psc_version_id_idx ON dbo.dr19_catalog_to_twomass_psc  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_best_idx ON dbo.dr19_catalog_to_tycho2  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_best_idx1 ON dbo.dr19_catalog_to_tycho2  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_catalogid_idx ON dbo.dr19_catalog_to_tycho2  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_catalogid_idx1 ON dbo.dr19_catalog_to_tycho2  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_target_id_idx ON dbo.dr19_catalog_to_tycho2  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_target_id_idx1 ON dbo.dr19_catalog_to_tycho2  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_version_id_idx ON dbo.dr19_catalog_to_tycho2  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_version_id_idx1 ON dbo.dr19_catalog_to_tycho2  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_tycho2_version_id_target_id_best_idx ON dbo.dr19_catalog_to_tycho2  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_best_idx ON dbo.dr19_catalog_to_unwise  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_best_idx1 ON dbo.dr19_catalog_to_unwise  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_catalogid_idx ON dbo.dr19_catalog_to_unwise  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_catalogid_idx1 ON dbo.dr19_catalog_to_unwise  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_target_id_idx ON dbo.dr19_catalog_to_unwise  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_target_id_idx1 ON dbo.dr19_catalog_to_unwise  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_version_id_idx ON dbo.dr19_catalog_to_unwise  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_version_id_idx1 ON dbo.dr19_catalog_to_unwise  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_unwise_version_id_target_id_best_idx ON dbo.dr19_catalog_to_unwise  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_best_idx ON dbo.dr19_catalog_to_uvotssc1  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_best_idx1 ON dbo.dr19_catalog_to_uvotssc1  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_catalogid_idx ON dbo.dr19_catalog_to_uvotssc1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_catalogid_idx1 ON dbo.dr19_catalog_to_uvotssc1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_target_id_idx ON dbo.dr19_catalog_to_uvotssc1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_target_id_idx1 ON dbo.dr19_catalog_to_uvotssc1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_version_id_idx ON dbo.dr19_catalog_to_uvotssc1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_version_id_idx1 ON dbo.dr19_catalog_to_uvotssc1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_uvotssc1_version_id_target_id_best_idx ON dbo.dr19_catalog_to_uvotssc1  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_best_idx ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_best_idx1 ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_catalogid_idx ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_catalogid_idx1 ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_target_id_idx ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_target_id_idx1 ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (target_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_version_id_idx ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_version_id_idx1 ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_to_xmm_om_suss_4_1_version_id_target_id_best_idx ON dbo.dr19_catalog_to_xmm_om_suss_4_1  (version_id, target_id, best) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catalog_version_id_idx ON dbo.dr19_catalog  (version_id) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_catwise2020_source_name_idx ON dbo.dr19_catwise2020  (source_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catwise2020_w1mpro_idx ON dbo.dr19_catwise2020  (w1mpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catwise2020_w1sigmpro_idx ON dbo.dr19_catwise2020  (w1sigmpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catwise2020_w2mpro_idx ON dbo.dr19_catwise2020  (w2mpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_catwise2020_w2sigmpro_idx ON dbo.dr19_catwise2020  (w2sigmpro) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_design_assignment_hash_idx ON dbo.dr19_design  (assignment_hash) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_design_to_field_design_id_idx ON dbo.dr19_design_to_field  (design_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_design_to_field_field_pk_idx ON dbo.dr19_design_to_field  (field_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_ebosstarget_v5_eboss_target1_idx ON dbo.dr19_ebosstarget_v5  (eboss_target1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_ebosstarget_v5_objc_type_idx ON dbo.dr19_ebosstarget_v5  (objc_type) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_ebosstarget_v5_objid_targeting_idx ON dbo.dr19_ebosstarget_v5  (objid_targeting) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_ebosstarget_v5_resolve_status_idx ON dbo.dr19_ebosstarget_v5  (resolve_status) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_catwise2020_id_idx ON dbo.dr19_erosita_superset_agn  (catwise2020_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_ero_det_like_idx ON dbo.dr19_erosita_superset_agn  (ero_det_like) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_ero_detuid_idx ON dbo.dr19_erosita_superset_agn  (ero_detuid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_ero_flux_idx ON dbo.dr19_erosita_superset_agn  (ero_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_ero_version_idx ON dbo.dr19_erosita_superset_agn  (ero_version) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_gaia_dr2_id_idx ON dbo.dr19_erosita_superset_agn  (gaia_dr2_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_ls_id_idx ON dbo.dr19_erosita_superset_agn  (ls_id) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_catwise2020_id_idx ON dbo.dr19_erosita_superset_clusters  (catwise2020_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_ero_det_like_idx ON dbo.dr19_erosita_superset_clusters  (ero_det_like) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_ero_detuid_idx ON dbo.dr19_erosita_superset_clusters  (ero_detuid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_ero_flux_idx ON dbo.dr19_erosita_superset_clusters  (ero_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_ero_version_idx ON dbo.dr19_erosita_superset_clusters  (ero_version) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_gaia_dr2_id_idx ON dbo.dr19_erosita_superset_clusters  (gaia_dr2_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_ls_id_idx ON dbo.dr19_erosita_superset_clusters  (ls_id) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_catwise2020_id_idx ON dbo.dr19_erosita_superset_compactobjects  (catwise2020_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_ero_det_like_idx ON dbo.dr19_erosita_superset_compactobjects  (ero_det_like) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_ero_detuid_idx ON dbo.dr19_erosita_superset_compactobjects  (ero_detuid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_ero_flux_idx ON dbo.dr19_erosita_superset_compactobjects  (ero_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_ero_version_idx ON dbo.dr19_erosita_superset_compactobjects  (ero_version) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_gaia_dr2_id_idx ON dbo.dr19_erosita_superset_compactobjects  (gaia_dr2_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_ls_id_idx ON dbo.dr19_erosita_superset_compactobjects  (ls_id) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_catwise2020_id_idx ON dbo.dr19_erosita_superset_stars  (catwise2020_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_ero_det_like_idx ON dbo.dr19_erosita_superset_stars  (ero_det_like) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_ero_detuid_idx ON dbo.dr19_erosita_superset_stars  (ero_detuid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_ero_flux_idx ON dbo.dr19_erosita_superset_stars  (ero_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_ero_version_idx ON dbo.dr19_erosita_superset_stars  (ero_version) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_gaia_dr2_id_idx ON dbo.dr19_erosita_superset_stars  (gaia_dr2_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_ls_id_idx ON dbo.dr19_erosita_superset_stars  (ls_id) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_field_cadence_pk_idx ON dbo.dr19_field  (cadence_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_field_field_id_idx ON dbo.dr19_field  (field_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_field_observatory_pk_idx ON dbo.dr19_field  (observatory_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_assas_sn_cepheids_source_idx ON dbo.dr19_gaia_assas_sn_cepheids  (source) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_ruwe_ruwe_idx ON dbo.dr19_gaia_dr2_ruwe  (ruwe) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_astrometric_chi2_al_idx ON dbo.dr19_gaia_dr2_source  (astrometric_chi2_al) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_astrometric_excess_noise_idx ON dbo.dr19_gaia_dr2_source  (astrometric_excess_noise) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_bp_rp_idx ON dbo.dr19_gaia_dr2_source  (bp_rp) ON [SPEC];


--CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_expr_idx ON dbo.dr19_gaia_dr2_source  (((parallax - parallax_error))) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_parallax_idx ON dbo.dr19_gaia_dr2_source  (parallax) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_phot_bp_mean_flux_over_error_idx ON dbo.dr19_gaia_dr2_source  (phot_bp_mean_flux_over_error) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_phot_bp_mean_mag_idx ON dbo.dr19_gaia_dr2_source  (phot_bp_mean_mag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_phot_rp_mean_mag_idx ON dbo.dr19_gaia_dr2_source  (phot_rp_mean_mag) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_gaia_dr2_wd_gmag_idx ON dbo.dr19_gaia_dr2_wd  (gmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_dr2_wd_pwd_idx ON dbo.dr19_gaia_dr2_wd  (pwd) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_gaia_unwise_agn_g_idx ON dbo.dr19_gaia_unwise_agn  (g) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaia_unwise_agn_prob_rf_idx ON dbo.dr19_gaia_unwise_agn  (prob_rf) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_gaia_unwise_agn_unwise_objid_idx ON dbo.dr19_gaia_unwise_agn  (unwise_objid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaiadr2_tmass_best_neighbour_angular_distance_idx ON dbo.dr19_gaiadr2_tmass_best_neighbour  (angular_distance) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaiadr2_tmass_best_neighbour_source_id_idx ON dbo.dr19_gaiadr2_tmass_best_neighbour  (source_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_gaiadr2_tmass_best_neighbour_tmass_pts_key_idx ON dbo.dr19_gaiadr2_tmass_best_neighbour  (tmass_pts_key) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_geometric_distances_gaia_dr2_r_est_idx ON dbo.dr19_geometric_distances_gaia_dr2  (r_est) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_geometric_distances_gaia_dr2_r_hi_idx ON dbo.dr19_geometric_distances_gaia_dr2  (r_hi) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_geometric_distances_gaia_dr2_r_len_idx ON dbo.dr19_geometric_distances_gaia_dr2  (r_len) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_geometric_distances_gaia_dr2_r_lo_idx ON dbo.dr19_geometric_distances_gaia_dr2  (r_lo) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_glimpse_designation_idx ON dbo.dr19_glimpse  (designation) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_glimpse_tmass_cntr_idx ON dbo.dr19_glimpse  (tmass_cntr) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_glimpse_tmass_designation_idx ON dbo.dr19_glimpse  (tmass_designation) ON [SPEC];


--CREATE NONCLUSTERED INDEX dr19_guvcat_expr_idx ON dbo.dr19_guvcat  (((fuv_mag - nuv_mag))) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_guvcat_fuv_mag_idx ON dbo.dr19_guvcat  (fuv_mag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_guvcat_nuv_mag_idx ON dbo.dr19_guvcat  (nuv_mag) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_hole_holeid_idx ON dbo.dr19_hole  (holeid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_hole_observatory_pk_idx ON dbo.dr19_hole  (observatory_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_fibertotflux_g_idx ON dbo.dr19_legacy_survey_dr8  (fibertotflux_g) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_fibertotflux_r_idx ON dbo.dr19_legacy_survey_dr8  (fibertotflux_r) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_fibertotflux_z_idx ON dbo.dr19_legacy_survey_dr8  (fibertotflux_z) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_flux_g_idx ON dbo.dr19_legacy_survey_dr8  (flux_g) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_flux_r_idx ON dbo.dr19_legacy_survey_dr8  (flux_r) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_flux_w1_idx ON dbo.dr19_legacy_survey_dr8  (flux_w1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_flux_z_idx ON dbo.dr19_legacy_survey_dr8  (flux_z) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_gaia_phot_g_mean_mag_idx ON dbo.dr19_legacy_survey_dr8  (gaia_phot_g_mean_mag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_gaia_phot_g_mean_mag_idx1 ON dbo.dr19_legacy_survey_dr8  (gaia_phot_g_mean_mag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_gaia_phot_rp_mean_mag_idx ON dbo.dr19_legacy_survey_dr8  (gaia_phot_rp_mean_mag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_gaia_sourceid_idx ON dbo.dr19_legacy_survey_dr8  (gaia_sourceid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_maskbits_idx ON dbo.dr19_legacy_survey_dr8  (maskbits) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_nobs_g_idx ON dbo.dr19_legacy_survey_dr8  (nobs_g) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_nobs_r_idx ON dbo.dr19_legacy_survey_dr8  (nobs_r) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_nobs_z_idx ON dbo.dr19_legacy_survey_dr8  (nobs_z) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_parallax_idx ON dbo.dr19_legacy_survey_dr8  (parallax) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_ref_cat_idx ON dbo.dr19_legacy_survey_dr8  (ref_cat) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_ref_epoch_idx ON dbo.dr19_legacy_survey_dr8  (ref_epoch) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_ref_id_idx ON dbo.dr19_legacy_survey_dr8  (ref_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_magnitude_carton_to_target_pk_idx ON dbo.dr19_magnitude  (carton_to_target_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_magnitude_h_idx ON dbo.dr19_magnitude  (h) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangadapall_daptype_idx ON dbo.dr19_mangadapall  (daptype) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangadapall_mangaid_idx ON dbo.dr19_mangadapall  (mangaid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangadapall_nsa_z_idx ON dbo.dr19_mangadapall  (nsa_z) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangadapall_plate_idx ON dbo.dr19_mangadapall  (plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangadrpall_ifudsgn_idx ON dbo.dr19_mangadrpall  (ifudsgn) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangadrpall_mangaid_idx ON dbo.dr19_mangadrpall  (mangaid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangadrpall_nsa_z_idx ON dbo.dr19_mangadrpall  (nsa_z) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangadrpall_plate_idx ON dbo.dr19_mangadrpall  (plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangatarget_nsa_iauname_idx ON dbo.dr19_mangatarget  (nsa_iauname) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangatarget_nsa_nsaid_idx ON dbo.dr19_mangatarget  (nsa_nsaid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangatarget_nsa_pid_idx ON dbo.dr19_mangatarget  (nsa_pid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mangatarget_nsa_z_idx ON dbo.dr19_mangatarget  (nsa_z) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr11_star_gsc_name_idx ON dbo.dr19_marvels_dr11_star  (gsc_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr11_star_hip_name_idx ON dbo.dr19_marvels_dr11_star  (hip_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr11_star_plate_idx ON dbo.dr19_marvels_dr11_star  (plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr11_star_twomass_designation_idx ON dbo.dr19_marvels_dr11_star  (twomass_designation) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr11_star_twomass_name_idx ON dbo.dr19_marvels_dr11_star  (twomass_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr11_star_tyc_name_idx ON dbo.dr19_marvels_dr11_star  (tyc_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr11_star_tycho2_designation_idx ON dbo.dr19_marvels_dr11_star  (tycho2_designation) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr12_star_gsc_name_idx ON dbo.dr19_marvels_dr12_star  (gsc_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr12_star_hip_name_idx ON dbo.dr19_marvels_dr12_star  (hip_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr12_star_plate_idx ON dbo.dr19_marvels_dr12_star  (plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr12_star_starname_idx ON dbo.dr19_marvels_dr12_star  (starname) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr12_star_twomass_designation_idx ON dbo.dr19_marvels_dr12_star  (twomass_designation) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr12_star_twomass_name_idx ON dbo.dr19_marvels_dr12_star  (twomass_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr12_star_tyc_name_idx ON dbo.dr19_marvels_dr12_star  (tyc_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_marvels_dr12_star_tycho2_designation_idx ON dbo.dr19_marvels_dr12_star  (tycho2_designation) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_drpver_idx ON dbo.dr19_mastar_goodstars  (drpver) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_epoch_idx ON dbo.dr19_mastar_goodstars  (epoch) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_input_alpha_m_idx ON dbo.dr19_mastar_goodstars  (input_alpha_m) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_input_fe_h_idx ON dbo.dr19_mastar_goodstars  (input_fe_h) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_input_logg_idx ON dbo.dr19_mastar_goodstars  (input_logg) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_input_teff_idx ON dbo.dr19_mastar_goodstars  (input_teff) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_maxmjd_idx ON dbo.dr19_mastar_goodstars  (maxmjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_minmjd_idx ON dbo.dr19_mastar_goodstars  (minmjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_mngtarg2_idx ON dbo.dr19_mastar_goodstars  (mngtarg2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_mprocver_idx ON dbo.dr19_mastar_goodstars  (mprocver) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_nplates_idx ON dbo.dr19_mastar_goodstars  (nplates) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_nvisits_idx ON dbo.dr19_mastar_goodstars  (nvisits) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodstars_photocat_idx ON dbo.dr19_mastar_goodstars  (photocat) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_coord_source_idx ON dbo.dr19_mastar_goodvisits  (coord_source) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_drpver_idx ON dbo.dr19_mastar_goodvisits  (drpver) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_epoch_idx ON dbo.dr19_mastar_goodvisits  (epoch) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_exptime_idx ON dbo.dr19_mastar_goodvisits  (exptime) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_heliov_idx ON dbo.dr19_mastar_goodvisits  (heliov) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_heliov_visit_idx ON dbo.dr19_mastar_goodvisits  (heliov_visit) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_ifudesign_idx ON dbo.dr19_mastar_goodvisits  (ifudesign) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_mangaid_idx ON dbo.dr19_mastar_goodvisits  (mangaid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_mjd_idx ON dbo.dr19_mastar_goodvisits  (mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_mjdqual_idx ON dbo.dr19_mastar_goodvisits  (mjdqual) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_mngtarg2_idx ON dbo.dr19_mastar_goodvisits  (mngtarg2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_mprocver_idx ON dbo.dr19_mastar_goodvisits  (mprocver) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_nexp_used_idx ON dbo.dr19_mastar_goodvisits  (nexp_used) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_nexp_visit_idx ON dbo.dr19_mastar_goodvisits  (nexp_visit) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_nvelgood_idx ON dbo.dr19_mastar_goodvisits  (nvelgood) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_photocat_idx ON dbo.dr19_mastar_goodvisits  (photocat) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mastar_goodvisits_plate_idx ON dbo.dr19_mastar_goodvisits  (plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mipsgal_glat_idx ON dbo.dr19_mipsgal  (glat) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mipsgal_glimpse_idx ON dbo.dr19_mipsgal  (glimpse) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mipsgal_glon_idx ON dbo.dr19_mipsgal  (glon) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mipsgal_hmag_idx ON dbo.dr19_mipsgal  (hmag) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_mipsgal_twomass_name_idx ON dbo.dr19_mipsgal  (twomass_name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_mwm_tess_ob_h_mag_idx ON dbo.dr19_mwm_tess_ob  (h_mag) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_opsdb_apo_camera_frame_exposure_pk_idx ON dbo.dr19_opsdb_apo_camera_frame  (exposure_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_opsdb_apo_configuration_design_id_idx ON dbo.dr19_opsdb_apo_configuration  (design_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_opsdb_apo_exposure_configuration_id_idx ON dbo.dr19_opsdb_apo_exposure  (configuration_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_opsdb_apo_exposure_start_time_idx ON dbo.dr19_opsdb_apo_exposure  (start_time) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_extid_hi_lo_idx ON dbo.dr19_panstarrs1  (extid_hi_lo) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_flags_idx ON dbo.dr19_panstarrs1  (flags) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_g_flags_idx ON dbo.dr19_panstarrs1  (g_flags) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_g_stk_psf_flux_idx ON dbo.dr19_panstarrs1  (g_stk_psf_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_i_flags_idx ON dbo.dr19_panstarrs1  (i_flags) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_i_stk_psf_flux_idx ON dbo.dr19_panstarrs1  (i_stk_psf_flux) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_panstarrs1_r_flags_idx ON dbo.dr19_panstarrs1  (r_flags) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_r_stk_psf_flux_idx ON dbo.dr19_panstarrs1  (r_stk_psf_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_stargal_idx ON dbo.dr19_panstarrs1  (stargal) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_z_flags_idx ON dbo.dr19_panstarrs1  (z_flags) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_panstarrs1_z_stk_psf_flux_idx ON dbo.dr19_panstarrs1  (z_stk_psf_flux) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_revised_magnitude_carton_to_target_pk_idx ON dbo.dr19_revised_magnitude  (carton_to_target_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_revised_magnitude_h_idx ON dbo.dr19_revised_magnitude  (h) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sagitta_av_idx ON dbo.dr19_sagitta  (av) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_sagitta_yso_idx ON dbo.dr19_sagitta  (yso) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sagitta_yso_std_idx ON dbo.dr19_sagitta  (yso_std) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_apogeeallstarmerge_r13_h_idx ON dbo.dr19_sdss_apogeeallstarmerge_r13  (h) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_apogeeallstarmerge_r13_j_idx ON dbo.dr19_sdss_apogeeallstarmerge_r13  (j) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_apogeeallstarmerge_r13_k_idx ON dbo.dr19_sdss_apogeeallstarmerge_r13  (k) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_sdss_dr13_photoobj_primary_objid_idx ON dbo.dr19_sdss_dr13_photoobj_primary  (objid) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_sdss_dr16_qso_fiberid_idx ON dbo.dr19_sdss_dr16_qso  (fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_qso_mjd_idx ON dbo.dr19_sdss_dr16_qso  (mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_qso_mjd_plate_fiberid_idx ON dbo.dr19_sdss_dr16_qso  (mjd, plate, fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_qso_plate_idx ON dbo.dr19_sdss_dr16_qso  (plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_bestobjid_idx ON dbo.dr19_sdss_dr16_specobj  (bestobjid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_fiberid_idx ON dbo.dr19_sdss_dr16_specobj  (fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_fluxobjid_idx ON dbo.dr19_sdss_dr16_specobj  (fluxobjid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_mjd_idx ON dbo.dr19_sdss_dr16_specobj  (mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_plate_idx ON dbo.dr19_sdss_dr16_specobj  (plate) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_run2d_idx ON dbo.dr19_sdss_dr16_specobj  (run2d) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_scienceprimary_idx ON dbo.dr19_sdss_dr16_specobj  (scienceprimary) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_snmedian_idx ON dbo.dr19_sdss_dr16_specobj  (snmedian) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_targetobjid_idx ON dbo.dr19_sdss_dr16_specobj  (targetobjid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_z_idx ON dbo.dr19_sdss_dr16_specobj  (z) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_zerr_idx ON dbo.dr19_sdss_dr16_specobj  (zerr) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_zwarning_idx ON dbo.dr19_sdss_dr16_specobj  (zwarning) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_bestobjid_idx ON dbo.dr19_sdss_dr17_specobj  (bestobjid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_bestobjid_idx1 ON dbo.dr19_sdss_dr17_specobj  (bestobjid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_fiberid_idx ON dbo.dr19_sdss_dr17_specobj  (fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_fluxobjid_idx ON dbo.dr19_sdss_dr17_specobj  (fluxobjid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_mjd_idx ON dbo.dr19_sdss_dr17_specobj  (mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_mjd_plate_fiberid_idx ON dbo.dr19_sdss_dr17_specobj  (mjd, plate, fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_mjd_plate_fiberid_run2d_idx ON dbo.dr19_sdss_dr17_specobj  (mjd, plate, fiberid, run2d) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_plateid_idx ON dbo.dr19_sdss_dr17_specobj  (plateid) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_run2d_idx ON dbo.dr19_sdss_dr17_specobj  (run2d) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_targetobjid_idx ON dbo.dr19_sdss_dr17_specobj  (targetobjid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_flat_catalogid_idx ON dbo.dr19_sdss_id_flat  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_flat_dec_catalogid_idx ON dbo.dr19_sdss_id_flat  (dec_catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_flat_dec_sdss_id_idx ON dbo.dr19_sdss_id_flat  (dec_sdss_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_flat_n_associated_idx ON dbo.dr19_sdss_id_flat  (n_associated) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_sdss_id_flat_ra_catalogid_idx ON dbo.dr19_sdss_id_flat  (ra_catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_stacked_catalogid21_idx ON dbo.dr19_sdss_id_stacked  (catalogid21) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_stacked_catalogid25_idx ON dbo.dr19_sdss_id_stacked  (catalogid25) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_allstar_dr17_synspec_rev1__apstar_i_idx ON dbo.dr19_sdss_id_to_catalog  (allstar_dr17_synspec_rev1__apstar_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_allwise__cntr_idx ON dbo.dr19_sdss_id_to_catalog  (allwise__cntr) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_bhm_rm_v0_2__pk_idx ON dbo.dr19_sdss_id_to_catalog  (bhm_rm_v0_2__pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_bhm_rm_v0__pk_idx ON dbo.dr19_sdss_id_to_catalog  (bhm_rm_v0__pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_catalogid_idx ON dbo.dr19_sdss_id_to_catalog  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_catwise2020__source_id_idx ON dbo.dr19_sdss_id_to_catalog  (catwise2020__source_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_catwise__source_id_idx ON dbo.dr19_sdss_id_to_catalog  (catwise__source_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_full_catalogid_idx ON dbo.dr19_sdss_id_to_catalog_full  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_gaia_dr2_source__source_id_idx ON dbo.dr19_sdss_id_to_catalog  (gaia_dr2_source__source_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_gaia_dr3_source__source_id_idx ON dbo.dr19_sdss_id_to_catalog  (gaia_dr3_source__source_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_glimpse__pk_idx ON dbo.dr19_sdss_id_to_catalog  (glimpse__pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_guvcat__objid_idx ON dbo.dr19_sdss_id_to_catalog  (guvcat__objid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_legacy_survey_dr10__ls_id_idx ON dbo.dr19_sdss_id_to_catalog  (legacy_survey_dr10__ls_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_legacy_survey_dr8__ls_id_idx ON dbo.dr19_sdss_id_to_catalog  (legacy_survey_dr8__ls_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_mangatarget__mangaid_idx ON dbo.dr19_sdss_id_to_catalog  (mangatarget__mangaid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_marvels_dr11_star__starname_idx ON dbo.dr19_sdss_id_to_catalog  (marvels_dr11_star__starname) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_marvels_dr12_star__pk_idx ON dbo.dr19_sdss_id_to_catalog  (marvels_dr12_star__pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_mastar_goodstars__mangaid_idx ON dbo.dr19_sdss_id_to_catalog  (mastar_goodstars__mangaid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_panstarrs1__catid_objid_idx ON dbo.dr19_sdss_id_to_catalog  (panstarrs1__catid_objid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_pk_idx ON dbo.dr19_sdss_id_to_catalog  (pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_ps1_g18__objid_idx ON dbo.dr19_sdss_id_to_catalog  (ps1_g18__objid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_sdss_dr13_photoobj__objid_idx ON dbo.dr19_sdss_id_to_catalog  (sdss_dr13_photoobj__objid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_sdss_dr17_specobj__specobjid_idx ON dbo.dr19_sdss_id_to_catalog  (sdss_dr17_specobj__specobjid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_sdss_id_idx ON dbo.dr19_sdss_id_to_catalog  (sdss_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_skymapper_dr1_1__object_id_idx ON dbo.dr19_sdss_id_to_catalog  (skymapper_dr1_1__object_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_skymapper_dr2__object_id_idx ON dbo.dr19_sdss_id_to_catalog  (skymapper_dr2__object_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_supercosmos__objid_idx ON dbo.dr19_sdss_id_to_catalog  (supercosmos__objid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_tic_v8__id_idx ON dbo.dr19_sdss_id_to_catalog  (tic_v8__id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_twomass_psc__pts_key_idx ON dbo.dr19_sdss_id_to_catalog  (twomass_psc__pts_key) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_tycho2__designation_idx ON dbo.dr19_sdss_id_to_catalog  (tycho2__designation) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_unwise__unwise_objid_idx ON dbo.dr19_sdss_id_to_catalog  (unwise__unwise_objid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdss_id_to_catalog_version_id_idx ON dbo.dr19_sdss_id_to_catalog  (version_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_designid_idx ON dbo.dr19_sdssv_boss_conflist  (designid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_mjd_idx ON dbo.dr19_sdssv_boss_conflist  (mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_plate_idx ON dbo.dr19_sdssv_boss_conflist  (plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_plate_mjd_idx ON dbo.dr19_sdssv_boss_conflist  (plate, mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_platesn2_idx ON dbo.dr19_sdssv_boss_conflist  (platesn2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_programname_idx ON dbo.dr19_sdssv_boss_conflist  (programname) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_sn2_g1_idx ON dbo.dr19_sdssv_boss_conflist  (sn2_g1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_sn2_i1_idx ON dbo.dr19_sdssv_boss_conflist  (sn2_i1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_sn2_r1_idx ON dbo.dr19_sdssv_boss_conflist  (sn2_r1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_catalogid_idx ON dbo.dr19_sdssv_boss_spall  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_fiberid_idx ON dbo.dr19_sdssv_boss_spall  (fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_firstcarton_idx ON dbo.dr19_sdssv_boss_spall  (firstcarton) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_mjd_idx ON dbo.dr19_sdssv_boss_spall  (mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_plate_idx ON dbo.dr19_sdssv_boss_spall  (plate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_plate_mjd_fiberid_idx ON dbo.dr19_sdssv_boss_spall  (plate, mjd, fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_plate_mjd_idx ON dbo.dr19_sdssv_boss_spall  (plate, mjd) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_programname_idx ON dbo.dr19_sdssv_boss_spall  (programname) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_sn_median_all_idx ON dbo.dr19_sdssv_boss_spall  (sn_median_all) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_specprimary_idx ON dbo.dr19_sdssv_boss_spall  (specprimary) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_z_err_idx ON dbo.dr19_sdssv_boss_spall  (z_err) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_zwarning_idx ON dbo.dr19_sdssv_boss_spall  (zwarning) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_block_idx ON dbo.dr19_sdssv_plateholes  (block) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_catalogid_idx ON dbo.dr19_sdssv_plateholes  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_fiberid_idx ON dbo.dr19_sdssv_plateholes  (fiberid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_firstcarton_idx ON dbo.dr19_sdssv_plateholes  (firstcarton) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_holetype_idx ON dbo.dr19_sdssv_plateholes  (holetype) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_meta_defaultsurveymode_idx ON dbo.dr19_sdssv_plateholes_meta  (defaultsurveymode) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_meta_designid_idx ON dbo.dr19_sdssv_plateholes_meta  (designid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_meta_isvalid_idx ON dbo.dr19_sdssv_plateholes_meta  (isvalid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_meta_locationid_idx ON dbo.dr19_sdssv_plateholes_meta  (locationid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_meta_plateid_idx ON dbo.dr19_sdssv_plateholes_meta  (plateid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_meta_programname_idx ON dbo.dr19_sdssv_plateholes_meta  (programname) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_sdssv_apogee_target0_idx ON dbo.dr19_sdssv_plateholes  (sdssv_apogee_target0) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_sdssv_boss_target0_idx ON dbo.dr19_sdssv_plateholes  (sdssv_boss_target0) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_sourcetype_idx ON dbo.dr19_sdssv_plateholes  (sourcetype) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_targettype_idx ON dbo.dr19_sdssv_plateholes  (targettype) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_yanny_uid_idx ON dbo.dr19_sdssv_plateholes  (yanny_uid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_down_pix_idx ON dbo.dr19_skies_v1  (down_pix) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_mag_neighbour_gaia_idx ON dbo.dr19_skies_v1  (mag_neighbour_gaia) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_mag_neighbour_ls8_idx ON dbo.dr19_skies_v1  (mag_neighbour_ls8) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_mag_neighbour_tmass_idx ON dbo.dr19_skies_v1  (mag_neighbour_tmass) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_mag_neighbour_tmass_xsc_idx ON dbo.dr19_skies_v1  (mag_neighbour_tmass_xsc) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_mag_neighbour_tycho2_idx ON dbo.dr19_skies_v1  (mag_neighbour_tycho2) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_skies_v1_sep_neighbour_gaia_idx ON dbo.dr19_skies_v1  (sep_neighbour_gaia) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_sep_neighbour_ls8_idx ON dbo.dr19_skies_v1  (sep_neighbour_ls8) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_sep_neighbour_tmass_idx ON dbo.dr19_skies_v1  (sep_neighbour_tmass) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_sep_neighbour_tmass_xsc_idx ON dbo.dr19_skies_v1  (sep_neighbour_tmass_xsc) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_sep_neighbour_tycho2_idx ON dbo.dr19_skies_v1  (sep_neighbour_tycho2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v1_tile_32_idx ON dbo.dr19_skies_v1  (tile_32) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_down_pix_idx ON dbo.dr19_skies_v2  (down_pix) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_mag_neighbour_gaia_idx ON dbo.dr19_skies_v2  (mag_neighbour_gaia) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_mag_neighbour_ls8_idx ON dbo.dr19_skies_v2  (mag_neighbour_ls8) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_mag_neighbour_ps1dr2_idx ON dbo.dr19_skies_v2  (mag_neighbour_ps1dr2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_mag_neighbour_tmass_idx ON dbo.dr19_skies_v2  (mag_neighbour_tmass) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_mag_neighbour_tycho2_idx ON dbo.dr19_skies_v2  (mag_neighbour_tycho2) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_skies_v2_sep_neighbour_gaia_idx ON dbo.dr19_skies_v2  (sep_neighbour_gaia) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_sep_neighbour_ls8_idx ON dbo.dr19_skies_v2  (sep_neighbour_ls8) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_sep_neighbour_ps1dr2_idx ON dbo.dr19_skies_v2  (sep_neighbour_ps1dr2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_sep_neighbour_tmass_idx ON dbo.dr19_skies_v2  (sep_neighbour_tmass) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_sep_neighbour_tmass_xsc_idx ON dbo.dr19_skies_v2  (sep_neighbour_tmass_xsc) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_sep_neighbour_tycho2_idx ON dbo.dr19_skies_v2  (sep_neighbour_tycho2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skies_v2_tile_32_idx ON dbo.dr19_skies_v2  (tile_32) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_allwise_cntr_idx ON dbo.dr19_skymapper_dr2  (allwise_cntr) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_flags_psf_idx ON dbo.dr19_skymapper_dr2  (flags_psf) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_g_psf_idx ON dbo.dr19_skymapper_dr2  (g_psf) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_gaia_dr2_id1_idx ON dbo.dr19_skymapper_dr2  (gaia_dr2_id1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_gaia_dr2_id2_idx ON dbo.dr19_skymapper_dr2  (gaia_dr2_id2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_i_psf_idx ON dbo.dr19_skymapper_dr2  (i_psf) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_nimaflags_idx ON dbo.dr19_skymapper_dr2  (nimaflags) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_r_psf_idx ON dbo.dr19_skymapper_dr2  (r_psf) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_smss_j_idx ON dbo.dr19_skymapper_dr2  (smss_j) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_z_psf_idx ON dbo.dr19_skymapper_dr2  (z_psf) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_gaia_feh_idx ON dbo.dr19_skymapper_gaia  (feh) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_gaia_gaia_source_id_idx ON dbo.dr19_skymapper_gaia  (gaia_source_id) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_skymapper_gaia_teff_idx ON dbo.dr19_skymapper_gaia  (teff) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_supercosmos_classb_idx ON dbo.dr19_supercosmos  (classb) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_supercosmos_classi_idx ON dbo.dr19_supercosmos  (classi) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_supercosmos_classmagb_idx ON dbo.dr19_supercosmos  (classmagb) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_supercosmos_classmagi_idx ON dbo.dr19_supercosmos  (classmagi) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_supercosmos_classmagr1_idx ON dbo.dr19_supercosmos  (classmagr1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_supercosmos_classmagr2_idx ON dbo.dr19_supercosmos  (classmagr2) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_supercosmos_classr1_idx ON dbo.dr19_supercosmos  (classr1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_supercosmos_classr2_idx ON dbo.dr19_supercosmos  (classr2) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_target_catalogid_idx ON dbo.dr19_target  (catalogid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_targeting_generation_to_carton_carton_pk_idx ON dbo.dr19_targeting_generation_to_carton  (carton_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_targeting_generation_to_carton_generation_pk_idx ON dbo.dr19_targeting_generation_to_carton  (generation_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_targeting_generation_to_version_generation_pk_idx ON dbo.dr19_targeting_generation_to_version  (generation_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_targeting_generation_to_version_version_pk_idx ON dbo.dr19_targeting_generation_to_version  (version_pk) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_ticid_idx ON dbo.dr19_tess_toi  (ticid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_v05_ctoi_idx ON dbo.dr19_tess_toi_v05  (ctoi) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_v05_num_sectors_idx ON dbo.dr19_tess_toi_v05  (num_sectors) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_v05_target_type_idx ON dbo.dr19_tess_toi_v05  (target_type) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_v05_tess_disposition_idx ON dbo.dr19_tess_toi_v05  (tess_disposition) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_v05_tfopwg_disposition_idx ON dbo.dr19_tess_toi_v05  (tfopwg_disposition) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_v05_ticid_idx ON dbo.dr19_tess_toi_v05  (ticid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_v05_toi_idx ON dbo.dr19_tess_toi_v05  (toi) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tess_toi_v05_user_disposition_idx ON dbo.dr19_tess_toi_v05  (user_disposition) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_allwise_idx ON dbo.dr19_tic_v8  (allwise) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_gaia_int_idx ON dbo.dr19_tic_v8  (gaia_int) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_gaiamag_idx ON dbo.dr19_tic_v8  (gaiamag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_hmag_idx ON dbo.dr19_tic_v8  (hmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_kic_idx ON dbo.dr19_tic_v8  (kic) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_logg_idx ON dbo.dr19_tic_v8  (logg) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_objtype_idx ON dbo.dr19_tic_v8  (objtype) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_plx_idx ON dbo.dr19_tic_v8  (plx) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_posflag_idx ON dbo.dr19_tic_v8  (posflag) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_tic_v8_sdss_idx ON dbo.dr19_tic_v8  (sdss) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_teff_idx ON dbo.dr19_tic_v8  (teff) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_tmag_idx ON dbo.dr19_tic_v8  (tmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_twomass_psc_idx ON dbo.dr19_tic_v8  (twomass_psc) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_twomass_psc_pts_key_idx ON dbo.dr19_tic_v8  (twomass_psc_pts_key) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tic_v8_tycho2_tycid_idx ON dbo.dr19_tic_v8  (tycho2_tycid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_twomass_psc_cc_flg_idx ON dbo.dr19_twomass_psc  (cc_flg) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_twomass_psc_designation_idx1 ON dbo.dr19_twomass_psc  (designation) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_twomass_psc_gal_contam_idx ON dbo.dr19_twomass_psc  (gal_contam) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_twomass_psc_jdate_idx ON dbo.dr19_twomass_psc  (jdate) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_twomass_psc_ph_qual_idx ON dbo.dr19_twomass_psc  (ph_qual) ON [SPEC];



ALTER TABLE dbo.dr19_twomass_psc
ADD CONSTRAINT UQ_dr19_twomass_psc_designation UNIQUE (designation) ON [SPEC];

CREATE NONCLUSTERED INDEX dr19_twomass_psc_rd_flg_idx ON dbo.dr19_twomass_psc  (rd_flg) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tycho2_btmag_idx ON dbo.dr19_tycho2  (btmag) ON [SPEC];






CREATE NONCLUSTERED INDEX dr19_tycho2_tycid_idx ON dbo.dr19_tycho2  (tycid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_tycho2_vtmag_idx ON dbo.dr19_tycho2  (vtmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_unwise_flux_w1_idx ON dbo.dr19_unwise  (flux_w1) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_unwise_flux_w2_idx ON dbo.dr19_unwise  (flux_w2) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_uvotssc1_name_idx ON dbo.dr19_uvotssc1  (name) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_uvotssc1_obsid_idx ON dbo.dr19_uvotssc1  (obsid) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_uvotssc1_srcid_idx ON dbo.dr19_uvotssc1  (srcid) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_xmm_om_suss_4_1_iauname_idx ON dbo.dr19_xmm_om_suss_4_1  (iauname) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_yso_clustering_bp_idx ON dbo.dr19_yso_clustering  (bp) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_yso_clustering_g_idx ON dbo.dr19_yso_clustering  (g) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_yso_clustering_h_idx ON dbo.dr19_yso_clustering  (h) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_yso_clustering_j_idx ON dbo.dr19_yso_clustering  (j) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_yso_clustering_k_idx ON dbo.dr19_yso_clustering  (k) ON [SPEC];




CREATE NONCLUSTERED INDEX dr19_yso_clustering_rp_idx ON dbo.dr19_yso_clustering  (rp) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_zari18pms_bp_over_rp_idx ON dbo.dr19_zari18pms  (bp_over_rp) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_zari18pms_bp_rp_idx ON dbo.dr19_zari18pms  (bp_rp) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_zari18pms_bpmag_idx ON dbo.dr19_zari18pms  (bpmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_zari18pms_gmag_idx ON dbo.dr19_zari18pms  (gmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_zari18pms_rpmag_idx ON dbo.dr19_zari18pms  (rpmag) ON [SPEC];


CREATE NONCLUSTERED INDEX dr19_zari18pms_source_idx ON dbo.dr19_zari18pms  (source) ON [SPEC];
