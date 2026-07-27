

CREATE NONCLUSTERED INDEX idx_allstar_dr17_synspec_rev1_apogee_id ON dbo.dr20_allstar_dr17_synspec_rev1  (apogee_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_allstar_dr17_synspec_rev1_aspcap_id ON dbo.dr20_allstar_dr17_synspec_rev1  (aspcap_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_allwise_designation ON dbo.dr20_allwise  (designation) ON [MINIDB];




CREATE NONCLUSTERED INDEX idx_allwise_ph_qual ON dbo.dr20_allwise  (ph_qual) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_allwise_w1mpro ON dbo.dr20_allwise  (w1mpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_allwise_w1sigmpro ON dbo.dr20_allwise  (w1sigmpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_allwise_w2mpro ON dbo.dr20_allwise  (w2mpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_allwise_w2sigmpro ON dbo.dr20_allwise  (w2sigmpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_allwise_w3mpro ON dbo.dr20_allwise  (w3mpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_allwise_w3sigmpro ON dbo.dr20_allwise  (w3sigmpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_assignment_carton_to_target_pk ON dbo.dr20_assignment  (carton_to_target_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_assignment_design_id ON dbo.dr20_assignment  (design_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_assignment_hole_pk ON dbo.dr20_assignment  (hole_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_assignment_instrument_pk ON dbo.dr20_assignment  (instrument_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bailer_jones_edr3_flag ON dbo.dr20_bailer_jones_edr3  (flag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bailer_jones_edr3_r_hi_geo ON dbo.dr20_bailer_jones_edr3  (r_hi_geo) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bailer_jones_edr3_r_hi_photogeo ON dbo.dr20_bailer_jones_edr3  (r_hi_photogeo) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bailer_jones_edr3_r_lo_geo ON dbo.dr20_bailer_jones_edr3  (r_lo_geo) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bailer_jones_edr3_r_lo_photogeo ON dbo.dr20_bailer_jones_edr3  (r_lo_photogeo) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bailer_jones_edr3_r_med_geo ON dbo.dr20_bailer_jones_edr3  (r_med_geo) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bailer_jones_edr3_r_med_photogeo ON dbo.dr20_bailer_jones_edr3  (r_med_photogeo) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_best_brightest_gmag ON dbo.dr20_best_brightest  (gmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_best_brightest_version ON dbo.dr20_best_brightest  (version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_mag_g ON dbo.dr20_bhm_csc  (mag_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_mag_h ON dbo.dr20_bhm_csc  (mag_h) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_mag_i ON dbo.dr20_bhm_csc  (mag_i) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_mag_r ON dbo.dr20_bhm_csc  (mag_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_mag_z ON dbo.dr20_bhm_csc  (mag_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v2_cxoid ON dbo.dr20_bhm_csc_v2  (cxoid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v2_designation2m ON dbo.dr20_bhm_csc_v2  (designation2m) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v2_hmag ON dbo.dr20_bhm_csc_v2  (hmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v2_idg2 ON dbo.dr20_bhm_csc_v2  (idg2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v2_idps ON dbo.dr20_bhm_csc_v2  (idps) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v2_ocat ON dbo.dr20_bhm_csc_v2  (ocat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v2_oid ON dbo.dr20_bhm_csc_v2  (oid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v2_omag ON dbo.dr20_bhm_csc_v2  (omag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v3_best_mag ON dbo.dr20_bhm_csc_v3  (best_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v3_best_oir_cat ON dbo.dr20_bhm_csc_v3  (best_oir_cat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v3_csc21p_id ON dbo.dr20_bhm_csc_v3  (csc21p_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v3_gaia_dr3_srcid ON dbo.dr20_bhm_csc_v3  (gaia_dr3_srcid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v3_ls_dr10_lsid ON dbo.dr20_bhm_csc_v3  (ls_dr10_lsid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v3_ps21p_ippobjid ON dbo.dr20_bhm_csc_v3  (ps21p_ippobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v3_ps21p_objid ON dbo.dr20_bhm_csc_v3  (ps21p_objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_csc_v3_tmass_designation ON dbo.dr20_bhm_csc_v3  (tmass_designation) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_catalogid ON dbo.dr20_bhm_rm_tweaks  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_date_set ON dbo.dr20_bhm_rm_tweaks  (date_set) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_fiberid ON dbo.dr20_bhm_rm_tweaks  (fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_firstcarton ON dbo.dr20_bhm_rm_tweaks  (firstcarton) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_gaia_g ON dbo.dr20_bhm_rm_tweaks  (gaia_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_in_plate ON dbo.dr20_bhm_rm_tweaks  (in_plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_mjd ON dbo.dr20_bhm_rm_tweaks  (mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_plate ON dbo.dr20_bhm_rm_tweaks  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_rm_field_name ON dbo.dr20_bhm_rm_tweaks  (rm_field_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_tweaks_rm_suitability ON dbo.dr20_bhm_rm_tweaks  (rm_suitability) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_2_coadd_object_id ON dbo.dr20_bhm_rm_v0_2  (coadd_object_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_2_id_nsc ON dbo.dr20_bhm_rm_v0_2  (id_nsc) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_2_objid_ps1 ON dbo.dr20_bhm_rm_v0_2  (objid_ps1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_2_objid_sdss ON dbo.dr20_bhm_rm_v0_2  (objid_sdss) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_2_objid_unwise ON dbo.dr20_bhm_rm_v0_2  (objid_unwise) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_2_source_id_gaia ON dbo.dr20_bhm_rm_v0_2  (source_id_gaia) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_2_sourceid_ir ON dbo.dr20_bhm_rm_v0_2  (sourceid_ir) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_mi ON dbo.dr20_bhm_rm_v0  (mi) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_objid_sdss ON dbo.dr20_bhm_rm_v0  (objid_sdss) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_objid_unwise ON dbo.dr20_bhm_rm_v0  (objid_unwise) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_photo_bitmask ON dbo.dr20_bhm_rm_v0  (photo_bitmask) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_plxsig ON dbo.dr20_bhm_rm_v0  (plxsig) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_pmsig ON dbo.dr20_bhm_rm_v0  (pmsig) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_skewt_qso ON dbo.dr20_bhm_rm_v0  (skewt_qso) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_source_id_gaia ON dbo.dr20_bhm_rm_v0  (source_id_gaia) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v0_spec_q ON dbo.dr20_bhm_rm_v0  (spec_q) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_catalogidv05 ON dbo.dr20_bhm_rm_v1_1  (catalogidv05) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_gaia_dr2_source_id ON dbo.dr20_bhm_rm_v1_1  (gaia_dr2_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_gaia_dr3_source_id ON dbo.dr20_bhm_rm_v1_1  (gaia_dr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_gaia_g ON dbo.dr20_bhm_rm_v1_1  (gaia_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_ls_id_dr10 ON dbo.dr20_bhm_rm_v1_1  (ls_id_dr10) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_ls_id_dr8 ON dbo.dr20_bhm_rm_v1_1  (ls_id_dr8) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_mag_g ON dbo.dr20_bhm_rm_v1_1  (mag_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_mag_i ON dbo.dr20_bhm_rm_v1_1  (mag_i) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_mag_r ON dbo.dr20_bhm_rm_v1_1  (mag_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_panstarrs1_catid_objid ON dbo.dr20_bhm_rm_v1_1  (panstarrs1_catid_objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_rm_ancillary ON dbo.dr20_bhm_rm_v1_1  (rm_ancillary) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_rm_core ON dbo.dr20_bhm_rm_v1_1  (rm_core) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_rm_field_name ON dbo.dr20_bhm_rm_v1_1  (rm_field_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_rm_known_spec ON dbo.dr20_bhm_rm_v1_1  (rm_known_spec) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_rm_unsuitable ON dbo.dr20_bhm_rm_v1_1  (rm_unsuitable) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_rm_var ON dbo.dr20_bhm_rm_v1_1  (rm_var) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_1_rm_xrayqso ON dbo.dr20_bhm_rm_v1_1  (rm_xrayqso) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_catalogidv05 ON dbo.dr20_bhm_rm_v1_3  (catalogidv05) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_gaia_dr2_source_id ON dbo.dr20_bhm_rm_v1_3  (gaia_dr2_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_gaia_dr3_source_id ON dbo.dr20_bhm_rm_v1_3  (gaia_dr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_gaia_g ON dbo.dr20_bhm_rm_v1_3  (gaia_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_ls_id_dr10 ON dbo.dr20_bhm_rm_v1_3  (ls_id_dr10) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_ls_id_dr8 ON dbo.dr20_bhm_rm_v1_3  (ls_id_dr8) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_mag_g ON dbo.dr20_bhm_rm_v1_3  (mag_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_mag_i ON dbo.dr20_bhm_rm_v1_3  (mag_i) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_mag_r ON dbo.dr20_bhm_rm_v1_3  (mag_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_panstarrs1_catid_objid ON dbo.dr20_bhm_rm_v1_3  (panstarrs1_catid_objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_rm_ancillary ON dbo.dr20_bhm_rm_v1_3  (rm_ancillary) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_rm_core ON dbo.dr20_bhm_rm_v1_3  (rm_core) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_rm_field_name ON dbo.dr20_bhm_rm_v1_3  (rm_field_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_rm_known_spec ON dbo.dr20_bhm_rm_v1_3  (rm_known_spec) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_rm_unsuitable ON dbo.dr20_bhm_rm_v1_3  (rm_unsuitable) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_rm_var ON dbo.dr20_bhm_rm_v1_3  (rm_var) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_3_rm_xrayqso ON dbo.dr20_bhm_rm_v1_3  (rm_xrayqso) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_catalogidv05 ON dbo.dr20_bhm_rm_v1  (catalogidv05) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_gaia_dr2_source_id ON dbo.dr20_bhm_rm_v1  (gaia_dr2_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_gaia_dr3_source_id ON dbo.dr20_bhm_rm_v1  (gaia_dr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_gaia_g ON dbo.dr20_bhm_rm_v1  (gaia_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_ls_id_dr10 ON dbo.dr20_bhm_rm_v1  (ls_id_dr10) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_ls_id_dr8 ON dbo.dr20_bhm_rm_v1  (ls_id_dr8) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_mag_g ON dbo.dr20_bhm_rm_v1  (mag_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_mag_i ON dbo.dr20_bhm_rm_v1  (mag_i) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_mag_r ON dbo.dr20_bhm_rm_v1  (mag_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_panstarrs1_catid_objid ON dbo.dr20_bhm_rm_v1  (panstarrs1_catid_objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_rm_ancillary ON dbo.dr20_bhm_rm_v1  (rm_ancillary) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_rm_core ON dbo.dr20_bhm_rm_v1  (rm_core) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_rm_field_name ON dbo.dr20_bhm_rm_v1  (rm_field_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_rm_known_spec ON dbo.dr20_bhm_rm_v1  (rm_known_spec) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_rm_unsuitable ON dbo.dr20_bhm_rm_v1  (rm_unsuitable) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_rm_var ON dbo.dr20_bhm_rm_v1  (rm_var) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_rm_v1_rm_xrayqso ON dbo.dr20_bhm_rm_v1  (rm_xrayqso) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_spiders_agn_superset_ero_flux ON dbo.dr20_bhm_spiders_agn_superset  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_spiders_agn_superset_gaia_dr2_source_id ON dbo.dr20_bhm_spiders_agn_superset  (gaia_dr2_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_spiders_agn_superset_ls_id ON dbo.dr20_bhm_spiders_agn_superset  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_spiders_clusters_superset_ero_flux ON dbo.dr20_bhm_spiders_clusters_superset  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_spiders_clusters_superset_gaia_dr2_source_id ON dbo.dr20_bhm_spiders_clusters_superset  (gaia_dr2_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_bhm_spiders_clusters_superset_ls_id ON dbo.dr20_bhm_spiders_clusters_superset  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_cadence_epoch_cadence_pk ON dbo.dr20_cadence_epoch  (cadence_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_cadence_epoch_label ON dbo.dr20_cadence_epoch  (label) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_carton_csv_carton ON dbo.dr20_carton_csv  (carton) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_carton_csv_carton_pk ON dbo.dr20_carton_csv  (carton_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_carton_csv_version_pk ON dbo.dr20_carton_csv  (version_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_carton_to_target_cadence_pk ON dbo.dr20_carton_to_target  (cadence_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_carton_to_target_carton_pk ON dbo.dr20_carton_to_target  (carton_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_carton_to_target_instrument_pk ON dbo.dr20_carton_to_target  (instrument_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_carton_to_target_target_pk ON dbo.dr20_carton_to_target  (target_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_cataclysmic_variables_source_id ON dbo.dr20_cataclysmic_variables  (source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_from_sdss_dr19p_speclite_best ON dbo.dr20_catalog_from_sdss_dr19p_speclite  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_from_sdss_dr19p_speclite_catalogid ON dbo.dr20_catalog_from_sdss_dr19p_speclite  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_from_sdss_dr19p_speclite_target_id ON dbo.dr20_catalog_from_sdss_dr19p_speclite  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_from_sdss_dr19p_speclite_version_id ON dbo.dr20_catalog_from_sdss_dr19p_speclite  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_allstar_dr17_synspec_rev1_catalogid ON dbo.dr20_catalog_to_allstar_dr17_synspec_rev1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_allstar_dr17_synspec_rev1_target_id ON dbo.dr20_catalog_to_allstar_dr17_synspec_rev1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_allstar_dr17_synspec_rev1_version_id ON dbo.dr20_catalog_to_allstar_dr17_synspec_rev1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_allwise_best ON dbo.dr20_catalog_to_allwise  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_best_idx1 ON dbo.dr20_catalog_to_allwise  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_allwise_catalogid ON dbo.dr20_catalog_to_allwise  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_catalogid_idx1 ON dbo.dr20_catalog_to_allwise  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_allwise_target_id ON dbo.dr20_catalog_to_allwise  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_target_id_idx1 ON dbo.dr20_catalog_to_allwise  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_allwise_version_id ON dbo.dr20_catalog_to_allwise  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_version_id_idx1 ON dbo.dr20_catalog_to_allwise  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_allwise_version_id_target_id_best ON dbo.dr20_catalog_to_allwise  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_csc_best ON dbo.dr20_catalog_to_bhm_csc  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_best_idx1 ON dbo.dr20_catalog_to_bhm_csc  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_csc_catalogid ON dbo.dr20_catalog_to_bhm_csc  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_catalogid_idx1 ON dbo.dr20_catalog_to_bhm_csc  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_csc_target_id ON dbo.dr20_catalog_to_bhm_csc  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_target_id_idx1 ON dbo.dr20_catalog_to_bhm_csc  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_csc_version_id ON dbo.dr20_catalog_to_bhm_csc  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_version_id_idx1 ON dbo.dr20_catalog_to_bhm_csc  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_csc_version_id_target_id_best ON dbo.dr20_catalog_to_bhm_csc  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_efeds_veto_best ON dbo.dr20_catalog_to_bhm_efeds_veto  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_efeds_veto_catalogid ON dbo.dr20_catalog_to_bhm_efeds_veto  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_efeds_veto_target_id ON dbo.dr20_catalog_to_bhm_efeds_veto  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_efeds_veto_version_id ON dbo.dr20_catalog_to_bhm_efeds_veto  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_efeds_veto_version_id_target_id_best ON dbo.dr20_catalog_to_bhm_efeds_veto  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_2_best ON dbo.dr20_catalog_to_bhm_rm_v0_2  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_best_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0_2  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_2_catalogid ON dbo.dr20_catalog_to_bhm_rm_v0_2  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_catalogid_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0_2  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_2_target_id ON dbo.dr20_catalog_to_bhm_rm_v0_2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_target_id_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0_2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_2_version_id ON dbo.dr20_catalog_to_bhm_rm_v0_2  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_version_id_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0_2  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_2_version_id_target_id_best ON dbo.dr20_catalog_to_bhm_rm_v0_2  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_best ON dbo.dr20_catalog_to_bhm_rm_v0  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_best_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_catalogid ON dbo.dr20_catalog_to_bhm_rm_v0  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_catalogid_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_target_id ON dbo.dr20_catalog_to_bhm_rm_v0  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_target_id_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_version_id ON dbo.dr20_catalog_to_bhm_rm_v0  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_version_id_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_bhm_rm_v0_version_id_target_id_best ON dbo.dr20_catalog_to_bhm_rm_v0  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_catwise2020_best ON dbo.dr20_catalog_to_catwise2020  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_best_idx1 ON dbo.dr20_catalog_to_catwise2020  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_catwise2020_catalogid ON dbo.dr20_catalog_to_catwise2020  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_catalogid_idx1 ON dbo.dr20_catalog_to_catwise2020  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_catwise2020_target_id ON dbo.dr20_catalog_to_catwise2020  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_target_id_idx1 ON dbo.dr20_catalog_to_catwise2020  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_catwise2020_version_id ON dbo.dr20_catalog_to_catwise2020  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_version_id_idx1 ON dbo.dr20_catalog_to_catwise2020  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_catwise2020_version_id_target_id_best ON dbo.dr20_catalog_to_catwise2020  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_best_idx1 ON dbo.dr20_catalog_to_gaia_dr2_source  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_catalogid_idx1 ON dbo.dr20_catalog_to_gaia_dr2_source  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_gaia_dr2_source_part1_target_id ON dbo.dr20_catalog_to_gaia_dr2_source_part1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_gaia_dr2_source_part2_target_id ON dbo.dr20_catalog_to_gaia_dr2_source_part2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_target_id_idx1 ON dbo.dr20_catalog_to_gaia_dr2_source  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_version_id_idx1 ON dbo.dr20_catalog_to_gaia_dr2_source  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_gaia_dr3_source_best ON dbo.dr20_catalog_to_gaia_dr3_source  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_best_idx1 ON dbo.dr20_catalog_to_gaia_dr3_source  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_gaia_dr3_source_catalogid ON dbo.dr20_catalog_to_gaia_dr3_source  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_catalogid_idx1 ON dbo.dr20_catalog_to_gaia_dr3_source  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_gaia_dr3_source_target_id ON dbo.dr20_catalog_to_gaia_dr3_source  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_target_id_idx1 ON dbo.dr20_catalog_to_gaia_dr3_source  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_gaia_dr3_source_version_id ON dbo.dr20_catalog_to_gaia_dr3_source  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_version_id_idx1 ON dbo.dr20_catalog_to_gaia_dr3_source  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_gaia_dr3_source_version_id_target_id_best ON dbo.dr20_catalog_to_gaia_dr3_source  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_glimpse_best ON dbo.dr20_catalog_to_glimpse  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_best_idx1 ON dbo.dr20_catalog_to_glimpse  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_glimpse_catalogid ON dbo.dr20_catalog_to_glimpse  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_catalogid_idx1 ON dbo.dr20_catalog_to_glimpse  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_glimpse_target_id ON dbo.dr20_catalog_to_glimpse  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_target_id_idx1 ON dbo.dr20_catalog_to_glimpse  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_glimpse_version_id ON dbo.dr20_catalog_to_glimpse  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_version_id_idx1 ON dbo.dr20_catalog_to_glimpse  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_glimpse_version_id_target_id_best ON dbo.dr20_catalog_to_glimpse  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_guvcat_best ON dbo.dr20_catalog_to_guvcat  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_best_idx1 ON dbo.dr20_catalog_to_guvcat  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_guvcat_catalogid ON dbo.dr20_catalog_to_guvcat  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_catalogid_idx1 ON dbo.dr20_catalog_to_guvcat  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_guvcat_target_id ON dbo.dr20_catalog_to_guvcat  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_target_id_idx1 ON dbo.dr20_catalog_to_guvcat  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_guvcat_version_id ON dbo.dr20_catalog_to_guvcat  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_version_id_idx1 ON dbo.dr20_catalog_to_guvcat  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_guvcat_version_id_target_id_best ON dbo.dr20_catalog_to_guvcat  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr10_best ON dbo.dr20_catalog_to_legacy_survey_dr10  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_best_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr10  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr10_catalogid ON dbo.dr20_catalog_to_legacy_survey_dr10  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_catalogid_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr10  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr10_target_id ON dbo.dr20_catalog_to_legacy_survey_dr10  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_target_id_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr10  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr10_version_id ON dbo.dr20_catalog_to_legacy_survey_dr10  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_version_id_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr10  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr1_version_id_target_id_best ON dbo.dr20_catalog_to_legacy_survey_dr10  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr8_best ON dbo.dr20_catalog_to_legacy_survey_dr8  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_best_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr8  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr8_catalogid ON dbo.dr20_catalog_to_legacy_survey_dr8  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_catalogid_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr8  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr8_target_id ON dbo.dr20_catalog_to_legacy_survey_dr8  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_target_id_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr8  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr8_version_id ON dbo.dr20_catalog_to_legacy_survey_dr8  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_version_id_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr8  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_legacy_survey_dr8_version_id_target_id_best ON dbo.dr20_catalog_to_legacy_survey_dr8  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_mangatarget_catalogid ON dbo.dr20_catalog_to_mangatarget  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_mangatarget_target_id ON dbo.dr20_catalog_to_mangatarget  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_mangatarget_version_id ON dbo.dr20_catalog_to_mangatarget  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_marvels_dr11_star_catalogid ON dbo.dr20_catalog_to_marvels_dr11_star  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_marvels_dr11_star_target_id ON dbo.dr20_catalog_to_marvels_dr11_star  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_marvels_dr11_star_version_id ON dbo.dr20_catalog_to_marvels_dr11_star  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_marvels_dr12_star_catalogid ON dbo.dr20_catalog_to_marvels_dr12_star  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_marvels_dr12_star_target_id ON dbo.dr20_catalog_to_marvels_dr12_star  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_marvels_dr12_star_version_id ON dbo.dr20_catalog_to_marvels_dr12_star  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_mastar_goodstars_catalogid ON dbo.dr20_catalog_to_mastar_goodstars  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_mastar_goodstars_target_id ON dbo.dr20_catalog_to_mastar_goodstars  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_mastar_goodstars_version_id ON dbo.dr20_catalog_to_mastar_goodstars  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_milliquas_7_7_best ON dbo.dr20_catalog_to_milliquas_7_7  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_best_idx1 ON dbo.dr20_catalog_to_milliquas_7_7  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_milliquas_7_7_catalogid ON dbo.dr20_catalog_to_milliquas_7_7  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_catalogid_idx1 ON dbo.dr20_catalog_to_milliquas_7_7  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_milliquas_7_7_target_id ON dbo.dr20_catalog_to_milliquas_7_7  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_target_id_idx1 ON dbo.dr20_catalog_to_milliquas_7_7  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_milliquas_7_7_version_id ON dbo.dr20_catalog_to_milliquas_7_7  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_version_id_idx1 ON dbo.dr20_catalog_to_milliquas_7_7  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_milliquas_7_7_version_id_target_id_best ON dbo.dr20_catalog_to_milliquas_7_7  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_panstarrs1_best ON dbo.dr20_catalog_to_panstarrs1  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_best_idx1 ON dbo.dr20_catalog_to_panstarrs1  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_panstarrs1_catalogid ON dbo.dr20_catalog_to_panstarrs1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_catalogid_idx1 ON dbo.dr20_catalog_to_panstarrs1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_panstarrs1_target_id ON dbo.dr20_catalog_to_panstarrs1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_target_id_idx1 ON dbo.dr20_catalog_to_panstarrs1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_panstarrs1_version_id ON dbo.dr20_catalog_to_panstarrs1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_version_id_idx1 ON dbo.dr20_catalog_to_panstarrs1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_panstarrs1_version_id_target_id_best ON dbo.dr20_catalog_to_panstarrs1  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr13_photoob_version_id_target_id_best ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr13_photoobj_primary_best ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_best_idx1 ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr13_photoobj_primary_catalogid ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_catalogid_idx1 ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr13_photoobj_primary_target_id ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_target_id_idx1 ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr13_photoobj_primary_version_id ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_version_id_idx1 ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr16_specobj_best ON dbo.dr20_catalog_to_sdss_dr16_specobj  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_best_idx1 ON dbo.dr20_catalog_to_sdss_dr16_specobj  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr16_specobj_catalogid ON dbo.dr20_catalog_to_sdss_dr16_specobj  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_catalogid_idx1 ON dbo.dr20_catalog_to_sdss_dr16_specobj  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr16_specobj_target_id ON dbo.dr20_catalog_to_sdss_dr16_specobj  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_target_id_idx1 ON dbo.dr20_catalog_to_sdss_dr16_specobj  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr16_specobj_version_id ON dbo.dr20_catalog_to_sdss_dr16_specobj  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_version_id_idx1 ON dbo.dr20_catalog_to_sdss_dr16_specobj  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr16_specobj_version_id_target_id_best ON dbo.dr20_catalog_to_sdss_dr16_specobj  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr17_specobj_catalogid ON dbo.dr20_catalog_to_sdss_dr17_specobj  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr17_specobj_target_id ON dbo.dr20_catalog_to_sdss_dr17_specobj  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_sdss_dr17_specobj_version_id ON dbo.dr20_catalog_to_sdss_dr17_specobj  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v1_best ON dbo.dr20_catalog_to_skies_v1  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_best_idx1 ON dbo.dr20_catalog_to_skies_v1  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v1_catalogid ON dbo.dr20_catalog_to_skies_v1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_catalogid_idx1 ON dbo.dr20_catalog_to_skies_v1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v1_target_id ON dbo.dr20_catalog_to_skies_v1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_target_id_idx1 ON dbo.dr20_catalog_to_skies_v1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v1_version_id ON dbo.dr20_catalog_to_skies_v1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_version_id_idx1 ON dbo.dr20_catalog_to_skies_v1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v1_version_id_target_id_best ON dbo.dr20_catalog_to_skies_v1  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v2_best ON dbo.dr20_catalog_to_skies_v2  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_best_idx1 ON dbo.dr20_catalog_to_skies_v2  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v2_catalogid ON dbo.dr20_catalog_to_skies_v2  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_catalogid_idx1 ON dbo.dr20_catalog_to_skies_v2  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v2_target_id ON dbo.dr20_catalog_to_skies_v2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_target_id_idx1 ON dbo.dr20_catalog_to_skies_v2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v2_version_id ON dbo.dr20_catalog_to_skies_v2  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_version_id_idx1 ON dbo.dr20_catalog_to_skies_v2  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skies_v2_version_id_target_id_best ON dbo.dr20_catalog_to_skies_v2  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skymapper_dr2_best ON dbo.dr20_catalog_to_skymapper_dr2  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_best_idx1 ON dbo.dr20_catalog_to_skymapper_dr2  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skymapper_dr2_catalogid ON dbo.dr20_catalog_to_skymapper_dr2  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_catalogid_idx1 ON dbo.dr20_catalog_to_skymapper_dr2  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skymapper_dr2_target_id ON dbo.dr20_catalog_to_skymapper_dr2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_target_id_idx1 ON dbo.dr20_catalog_to_skymapper_dr2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skymapper_dr2_version_id ON dbo.dr20_catalog_to_skymapper_dr2  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_version_id_idx1 ON dbo.dr20_catalog_to_skymapper_dr2  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_skymapper_dr2_version_id_target_id_best ON dbo.dr20_catalog_to_skymapper_dr2  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_supercosmos_best ON dbo.dr20_catalog_to_supercosmos  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_best_idx1 ON dbo.dr20_catalog_to_supercosmos  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_supercosmos_catalogid ON dbo.dr20_catalog_to_supercosmos  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_catalogid_idx1 ON dbo.dr20_catalog_to_supercosmos  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_supercosmos_target_id ON dbo.dr20_catalog_to_supercosmos  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_target_id_idx1 ON dbo.dr20_catalog_to_supercosmos  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_supercosmos_version_id ON dbo.dr20_catalog_to_supercosmos  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_version_id_idx1 ON dbo.dr20_catalog_to_supercosmos  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_supercosmos_version_id_target_id_best ON dbo.dr20_catalog_to_supercosmos  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tic_v8_best ON dbo.dr20_catalog_to_tic_v8  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_best_idx1 ON dbo.dr20_catalog_to_tic_v8  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tic_v8_catalogid ON dbo.dr20_catalog_to_tic_v8  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_catalogid_idx1 ON dbo.dr20_catalog_to_tic_v8  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tic_v8_target_id ON dbo.dr20_catalog_to_tic_v8  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_target_id_idx1 ON dbo.dr20_catalog_to_tic_v8  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tic_v8_version_id ON dbo.dr20_catalog_to_tic_v8  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_version_id_idx1 ON dbo.dr20_catalog_to_tic_v8  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tic_v8_version_id_target_id_best ON dbo.dr20_catalog_to_tic_v8  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_best_idx1 ON dbo.dr20_catalog_to_twomass_psc  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_catalogid_idx1 ON dbo.dr20_catalog_to_twomass_psc  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_twomass_psc_part1_target_id ON dbo.dr20_catalog_to_twomass_psc_part1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_twomass_psc_part2_target_id ON dbo.dr20_catalog_to_twomass_psc_part2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_target_id_idx1 ON dbo.dr20_catalog_to_twomass_psc  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_version_id_idx1 ON dbo.dr20_catalog_to_twomass_psc  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tycho2_best ON dbo.dr20_catalog_to_tycho2  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_best_idx1 ON dbo.dr20_catalog_to_tycho2  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tycho2_catalogid ON dbo.dr20_catalog_to_tycho2  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_catalogid_idx1 ON dbo.dr20_catalog_to_tycho2  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tycho2_target_id ON dbo.dr20_catalog_to_tycho2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_target_id_idx1 ON dbo.dr20_catalog_to_tycho2  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tycho2_version_id ON dbo.dr20_catalog_to_tycho2  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_version_id_idx1 ON dbo.dr20_catalog_to_tycho2  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_tycho2_version_id_target_id_best ON dbo.dr20_catalog_to_tycho2  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_unwise_best ON dbo.dr20_catalog_to_unwise  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_best_idx1 ON dbo.dr20_catalog_to_unwise  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_unwise_catalogid ON dbo.dr20_catalog_to_unwise  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_catalogid_idx1 ON dbo.dr20_catalog_to_unwise  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_unwise_target_id ON dbo.dr20_catalog_to_unwise  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_target_id_idx1 ON dbo.dr20_catalog_to_unwise  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_unwise_version_id ON dbo.dr20_catalog_to_unwise  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_version_id_idx1 ON dbo.dr20_catalog_to_unwise  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_unwise_version_id_target_id_best ON dbo.dr20_catalog_to_unwise  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_uvotssc1_best ON dbo.dr20_catalog_to_uvotssc1  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_best_idx1 ON dbo.dr20_catalog_to_uvotssc1  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_uvotssc1_catalogid ON dbo.dr20_catalog_to_uvotssc1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_catalogid_idx1 ON dbo.dr20_catalog_to_uvotssc1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_uvotssc1_target_id ON dbo.dr20_catalog_to_uvotssc1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_target_id_idx1 ON dbo.dr20_catalog_to_uvotssc1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_uvotssc1_version_id ON dbo.dr20_catalog_to_uvotssc1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_version_id_idx1 ON dbo.dr20_catalog_to_uvotssc1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_uvotssc1_version_id_target_id_best ON dbo.dr20_catalog_to_uvotssc1  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_4_1_best ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_best_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_4_1_catalogid ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_catalogid_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_4_1_target_id ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_target_id_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_4_1_version_id ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_version_id_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_4_1_version_id_target_id_best ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_5_0_best ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_best_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_5_0_catalogid ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_catalogid_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_5_0_target_id ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_target_id_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (target_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_5_0_version_id ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_version_id_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_to_xmm_om_suss_5_0_version_id_target_id_best ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (version_id, target_id, best) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catalog_version_id ON dbo.dr20_catalog  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catwise2020_source_name ON dbo.dr20_catwise2020  (source_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catwise2020_w1mpro ON dbo.dr20_catwise2020  (w1mpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catwise2020_w1sigmpro ON dbo.dr20_catwise2020  (w1sigmpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catwise2020_w2mpro ON dbo.dr20_catwise2020  (w2mpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_catwise2020_w2sigmpro ON dbo.dr20_catwise2020  (w2sigmpro) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_design_assignment_hash ON dbo.dr20_design  (assignment_hash) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_design_to_field_design_id ON dbo.dr20_design_to_field  (design_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_design_to_field_field_pk ON dbo.dr20_design_to_field  (field_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_ebosstarget_v5_eboss_target1 ON dbo.dr20_ebosstarget_v5  (eboss_target1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_ebosstarget_v5_objc_type ON dbo.dr20_ebosstarget_v5  (objc_type) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_ebosstarget_v5_objid_targeting ON dbo.dr20_ebosstarget_v5  (objid_targeting) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_ebosstarget_v5_resolve_status ON dbo.dr20_ebosstarget_v5  (resolve_status) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_agn_catwise2020_id ON dbo.dr20_erosita_superset_agn  (catwise2020_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_agn_ero_det_like ON dbo.dr20_erosita_superset_agn  (ero_det_like) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_agn_ero_detuid ON dbo.dr20_erosita_superset_agn  (ero_detuid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_agn_ero_flux ON dbo.dr20_erosita_superset_agn  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_agn_ero_version ON dbo.dr20_erosita_superset_agn  (ero_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_agn_gaia_dr2_id ON dbo.dr20_erosita_superset_agn  (gaia_dr2_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_agn_ls_id ON dbo.dr20_erosita_superset_agn  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_clusters_catwise2020_id ON dbo.dr20_erosita_superset_clusters  (catwise2020_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_clusters_ero_det_like ON dbo.dr20_erosita_superset_clusters  (ero_det_like) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_clusters_ero_detuid ON dbo.dr20_erosita_superset_clusters  (ero_detuid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_clusters_ero_flux ON dbo.dr20_erosita_superset_clusters  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_clusters_ero_version ON dbo.dr20_erosita_superset_clusters  (ero_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_clusters_gaia_dr2_id ON dbo.dr20_erosita_superset_clusters  (gaia_dr2_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_clusters_ls_id ON dbo.dr20_erosita_superset_clusters  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_compactobjects_catwise2020_id ON dbo.dr20_erosita_superset_compactobjects  (catwise2020_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_compactobjects_ero_det_like ON dbo.dr20_erosita_superset_compactobjects  (ero_det_like) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_compactobjects_ero_detuid ON dbo.dr20_erosita_superset_compactobjects  (ero_detuid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_compactobjects_ero_flux ON dbo.dr20_erosita_superset_compactobjects  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_compactobjects_ero_version ON dbo.dr20_erosita_superset_compactobjects  (ero_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_compactobjects_gaia_dr2_id ON dbo.dr20_erosita_superset_compactobjects  (gaia_dr2_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_compactobjects_ls_id ON dbo.dr20_erosita_superset_compactobjects  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_stars_catwise2020_id ON dbo.dr20_erosita_superset_stars  (catwise2020_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_stars_ero_det_like ON dbo.dr20_erosita_superset_stars  (ero_det_like) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_stars_ero_detuid ON dbo.dr20_erosita_superset_stars  (ero_detuid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_stars_ero_flux ON dbo.dr20_erosita_superset_stars  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_stars_ero_version ON dbo.dr20_erosita_superset_stars  (ero_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_stars_gaia_dr2_id ON dbo.dr20_erosita_superset_stars  (gaia_dr2_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_stars_ls_id ON dbo.dr20_erosita_superset_stars  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_ero_det_like ON dbo.dr20_erosita_superset_v1_agn  (ero_det_like) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_ero_detuid ON dbo.dr20_erosita_superset_v1_agn  (ero_detuid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_ero_flags ON dbo.dr20_erosita_superset_v1_agn  (ero_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_ero_flux ON dbo.dr20_erosita_superset_v1_agn  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_ero_morph ON dbo.dr20_erosita_superset_v1_agn  (ero_morph) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_ero_version ON dbo.dr20_erosita_superset_v1_agn  (ero_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_gaia_dr3_source_id ON dbo.dr20_erosita_superset_v1_agn  (gaia_dr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_ls_id ON dbo.dr20_erosita_superset_v1_agn  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_opt_cat ON dbo.dr20_erosita_superset_v1_agn  (opt_cat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_xmatch_flags ON dbo.dr20_erosita_superset_v1_agn  (xmatch_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_xmatch_metric ON dbo.dr20_erosita_superset_v1_agn  (xmatch_metric) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_agn_xmatch_version ON dbo.dr20_erosita_superset_v1_agn  (xmatch_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_ero_det_like ON dbo.dr20_erosita_superset_v1_clusters  (ero_det_like) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_ero_detuid ON dbo.dr20_erosita_superset_v1_clusters  (ero_detuid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_ero_flags ON dbo.dr20_erosita_superset_v1_clusters  (ero_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_ero_flux ON dbo.dr20_erosita_superset_v1_clusters  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_ero_version ON dbo.dr20_erosita_superset_v1_clusters  (ero_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_eromapper_lambda ON dbo.dr20_erosita_superset_v1_clusters  (eromapper_lambda) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_eromapper_z_lambda ON dbo.dr20_erosita_superset_v1_clusters  (eromapper_z_lambda) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_gaia_dr3_source_id ON dbo.dr20_erosita_superset_v1_clusters  (gaia_dr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_ls_id ON dbo.dr20_erosita_superset_v1_clusters  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_opt_cat ON dbo.dr20_erosita_superset_v1_clusters  (opt_cat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_target_priority ON dbo.dr20_erosita_superset_v1_clusters  (target_priority) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_xmatch_metric ON dbo.dr20_erosita_superset_v1_clusters  (xmatch_metric) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_clusters_xmatch_version ON dbo.dr20_erosita_superset_v1_clusters  (xmatch_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_ero_det_like ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_det_like) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_ero_detuid ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_detuid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_ero_flags ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_ero_flux ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_ero_version ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_gaia_dr3_source_id ON dbo.dr20_erosita_superset_v1_compactobjects  (gaia_dr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_ls_id ON dbo.dr20_erosita_superset_v1_compactobjects  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_opt_cat ON dbo.dr20_erosita_superset_v1_compactobjects  (opt_cat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_compactobjects_xmatch_metric ON dbo.dr20_erosita_superset_v1_compactobjects  (xmatch_metric) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_ero_det_like ON dbo.dr20_erosita_superset_v1_stars  (ero_det_like) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_ero_detuid ON dbo.dr20_erosita_superset_v1_stars  (ero_detuid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_ero_flags ON dbo.dr20_erosita_superset_v1_stars  (ero_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_ero_flux ON dbo.dr20_erosita_superset_v1_stars  (ero_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_ero_version ON dbo.dr20_erosita_superset_v1_stars  (ero_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_gaia_dr3_source_id ON dbo.dr20_erosita_superset_v1_stars  (gaia_dr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_ls_id ON dbo.dr20_erosita_superset_v1_stars  (ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_opt_cat ON dbo.dr20_erosita_superset_v1_stars  (opt_cat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_xmatch_metric ON dbo.dr20_erosita_superset_v1_stars  (xmatch_metric) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_erosita_superset_v1_stars_xmatch_version ON dbo.dr20_erosita_superset_v1_stars  (xmatch_version) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_field_cadence_pk ON dbo.dr20_field  (cadence_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_field_field_id ON dbo.dr20_field  (field_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_field_observatory_pk ON dbo.dr20_field  (observatory_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_assas_sn_cepheids_source ON dbo.dr20_gaia_assas_sn_cepheids  (source) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_ruwe_ruwe ON dbo.dr20_gaia_dr2_ruwe  (ruwe) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_source_astrometric_chi2_al ON dbo.dr20_gaia_dr2_source  (astrometric_chi2_al) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_source_astrometric_excess_noise ON dbo.dr20_gaia_dr2_source  (astrometric_excess_noise) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_source_bp_rp ON dbo.dr20_gaia_dr2_source  (bp_rp) ON [MINIDB];




CREATE NONCLUSTERED INDEX idx_gaia_dr2_source_parallax ON dbo.dr20_gaia_dr2_source  (parallax) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_source_phot_bp_mean_flux_over_error ON dbo.dr20_gaia_dr2_source  (phot_bp_mean_flux_over_error) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_source_phot_bp_mean_mag ON dbo.dr20_gaia_dr2_source  (phot_bp_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_source_phot_rp_mean_mag ON dbo.dr20_gaia_dr2_source  (phot_rp_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_wd_gmag ON dbo.dr20_gaia_dr2_wd  (gmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr2_wd_pwd ON dbo.dr20_gaia_dr2_wd  (pwd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_paramet_vsini_esphs_uncertainty ON dbo.dr20_gaia_dr3_astrophysical_parameters  (vsini_esphs_uncertainty) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_paramete_logg_esphs_uncertainty ON dbo.dr20_gaia_dr3_astrophysical_parameters  (logg_esphs_uncertainty) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_paramete_teff_esphs_uncertainty ON dbo.dr20_gaia_dr3_astrophysical_parameters  (teff_esphs_uncertainty) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_parameters_logg_esphs ON dbo.dr20_gaia_dr3_astrophysical_parameters  (logg_esphs) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_parameters_logg_gspphot ON dbo.dr20_gaia_dr3_astrophysical_parameters  (logg_gspphot) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_parameters_mh_gspphot ON dbo.dr20_gaia_dr3_astrophysical_parameters  (mh_gspphot) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_parameters_teff_esphs ON dbo.dr20_gaia_dr3_astrophysical_parameters  (teff_esphs) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_parameters_teff_gspphot ON dbo.dr20_gaia_dr3_astrophysical_parameters  (teff_gspphot) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_astrophysical_parameters_vsini_esphs ON dbo.dr20_gaia_dr3_astrophysical_parameters  (vsini_esphs) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_nss_two_body_orbit_period ON dbo.dr20_gaia_dr3_nss_two_body_orbit  (period) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_nss_two_body_orbit_source_id ON dbo.dr20_gaia_dr3_nss_two_body_orbit  (source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_astrometric_chi2_al ON dbo.dr20_gaia_dr3_source  (astrometric_chi2_al) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_astrometric_excess_noise ON dbo.dr20_gaia_dr3_source  (astrometric_excess_noise) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_bp_g ON dbo.dr20_gaia_dr3_source  (bp_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_bp_rp ON dbo.dr20_gaia_dr3_source  (bp_rp) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_g_rp ON dbo.dr20_gaia_dr3_source  (g_rp) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_parallax ON dbo.dr20_gaia_dr3_source  (parallax) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_parallax_over_error ON dbo.dr20_gaia_dr3_source  (parallax_over_error) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_bp_mean_flux ON dbo.dr20_gaia_dr3_source  (phot_bp_mean_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_bp_mean_flux_over_error ON dbo.dr20_gaia_dr3_source  (phot_bp_mean_flux_over_error) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_bp_mean_mag ON dbo.dr20_gaia_dr3_source  (phot_bp_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_g_mean_flux ON dbo.dr20_gaia_dr3_source  (phot_g_mean_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_g_mean_flux_over_error ON dbo.dr20_gaia_dr3_source  (phot_g_mean_flux_over_error) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_g_mean_mag ON dbo.dr20_gaia_dr3_source  (phot_g_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_rp_mean_flux ON dbo.dr20_gaia_dr3_source  (phot_rp_mean_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_rp_mean_flux_over_error ON dbo.dr20_gaia_dr3_source  (phot_rp_mean_flux_over_error) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_phot_rp_mean_mag ON dbo.dr20_gaia_dr3_source  (phot_rp_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_ruwe ON dbo.dr20_gaia_dr3_source  (ruwe) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_source_solution_id ON dbo.dr20_gaia_dr3_source  (solution_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_synthetic_photometry_gspc_g_sdss_flag ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (g_sdss_flag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_synthetic_photometry_gspc_g_sdss_mag ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (g_sdss_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_synthetic_photometry_gspc_i_sdss_flag ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (i_sdss_flag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_synthetic_photometry_gspc_i_sdss_mag ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (i_sdss_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_synthetic_photometry_gspc_r_sdss_flag ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (r_sdss_flag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_synthetic_photometry_gspc_r_sdss_mag ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (r_sdss_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_dr3_vari_rrlyrae_solution_id ON dbo.dr20_gaia_dr3_vari_rrlyrae  (solution_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_unwise_agn_g ON dbo.dr20_gaia_unwise_agn  (g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_unwise_agn_prob_rf ON dbo.dr20_gaia_unwise_agn  (prob_rf) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaia_unwise_agn_unwise_objid ON dbo.dr20_gaia_unwise_agn  (unwise_objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaiadr2_tmass_best_neighbour_angular_distance ON dbo.dr20_gaiadr2_tmass_best_neighbour  (angular_distance) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaiadr2_tmass_best_neighbour_source_id ON dbo.dr20_gaiadr2_tmass_best_neighbour  (source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gaiadr2_tmass_best_neighbour_tmass_pts_key ON dbo.dr20_gaiadr2_tmass_best_neighbour  (tmass_pts_key) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_galah_dr3_star_id ON dbo.dr20_galah_dr3  (star_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_galex_gr7_gaia_dr3_fuv_mag ON dbo.dr20_galex_gr7_gaia_dr3  (fuv_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_galex_gr7_gaia_dr3_gaia_edr3_source_id ON dbo.dr20_galex_gr7_gaia_dr3  (gaia_edr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_galex_gr7_gaia_dr3_galex_objid ON dbo.dr20_galex_gr7_gaia_dr3  (galex_objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_galex_gr7_gaia_dr3_galex_separation ON dbo.dr20_galex_gr7_gaia_dr3  (galex_separation) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_galex_gr7_gaia_dr3_nuv_mag ON dbo.dr20_galex_gr7_gaia_dr3  (nuv_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_galex_gr7_gaia_dr3_nuv_magerr ON dbo.dr20_galex_gr7_gaia_dr3  (nuv_magerr) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gedr3spur_main_fidelity_v1 ON dbo.dr20_gedr3spur_main  (fidelity_v1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_gedr3spur_main_fidelity_v2 ON dbo.dr20_gedr3spur_main  (fidelity_v2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_geometric_distances_gaia_dr2_r_est ON dbo.dr20_geometric_distances_gaia_dr2  (r_est) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_geometric_distances_gaia_dr2_r_hi ON dbo.dr20_geometric_distances_gaia_dr2  (r_hi) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_geometric_distances_gaia_dr2_r_len ON dbo.dr20_geometric_distances_gaia_dr2  (r_len) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_geometric_distances_gaia_dr2_r_lo ON dbo.dr20_geometric_distances_gaia_dr2  (r_lo) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_glimpse_designation ON dbo.dr20_glimpse  (designation) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_glimpse_tmass_cntr ON dbo.dr20_glimpse  (tmass_cntr) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_glimpse_tmass_designation ON dbo.dr20_glimpse  (tmass_designation) ON [MINIDB];




CREATE NONCLUSTERED INDEX idx_guvcat_fuv_mag ON dbo.dr20_guvcat  (fuv_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_guvcat_nuv_mag ON dbo.dr20_guvcat  (nuv_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_f_astrom ON dbo.dr20_hecate_1_1  (f_astrom) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_id_2mass ON dbo.dr20_hecate_1_1  (id_2mass) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_id_iras ON dbo.dr20_hecate_1_1  (id_iras) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_id_ned ON dbo.dr20_hecate_1_1  (id_ned) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_id_nedd ON dbo.dr20_hecate_1_1  (id_nedd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_objname ON dbo.dr20_hecate_1_1  (objname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_pa ON dbo.dr20_hecate_1_1  (pa) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_pgc ON dbo.dr20_hecate_1_1  (pgc) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_r1 ON dbo.dr20_hecate_1_1  (r1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_r2 ON dbo.dr20_hecate_1_1  (r2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_rflag ON dbo.dr20_hecate_1_1  (rflag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_rsource ON dbo.dr20_hecate_1_1  (rsource) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_sdss_photid ON dbo.dr20_hecate_1_1  (sdss_photid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hecate_1_1_sdss_specid ON dbo.dr20_hecate_1_1  (sdss_specid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hole_holeid ON dbo.dr20_hole  (holeid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_hole_observatory_pk ON dbo.dr20_hole  (observatory_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_lamost_dr6_obsid ON dbo.dr20_lamost_dr6  (obsid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_lamost_dr6_source_id ON dbo.dr20_lamost_dr6  (source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_ebv ON dbo.dr20_legacy_survey_dr10  (ebv) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_fiberflux_g ON dbo.dr20_legacy_survey_dr10  (fiberflux_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_fiberflux_i ON dbo.dr20_legacy_survey_dr10  (fiberflux_i) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_fiberflux_r ON dbo.dr20_legacy_survey_dr10  (fiberflux_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_fiberflux_z ON dbo.dr20_legacy_survey_dr10  (fiberflux_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_flux_g ON dbo.dr20_legacy_survey_dr10  (flux_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_flux_i ON dbo.dr20_legacy_survey_dr10  (flux_i) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_flux_r ON dbo.dr20_legacy_survey_dr10  (flux_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_flux_w1 ON dbo.dr20_legacy_survey_dr10  (flux_w1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_flux_z ON dbo.dr20_legacy_survey_dr10  (flux_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_gaia_dr2_source_id ON dbo.dr20_legacy_survey_dr10  (gaia_dr2_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_gaia_dr3_source_id ON dbo.dr20_legacy_survey_dr10  (gaia_dr3_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_gaia_phot_bp_mean_mag ON dbo.dr20_legacy_survey_dr10  (gaia_phot_bp_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_gaia_phot_g_mean_mag ON dbo.dr20_legacy_survey_dr10  (gaia_phot_g_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_gaia_phot_rp_mean_mag ON dbo.dr20_legacy_survey_dr10  (gaia_phot_rp_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_maskbits ON dbo.dr20_legacy_survey_dr10  (maskbits) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_nobs_g ON dbo.dr20_legacy_survey_dr10  (nobs_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_nobs_i ON dbo.dr20_legacy_survey_dr10  (nobs_i) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_nobs_r ON dbo.dr20_legacy_survey_dr10  (nobs_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_nobs_z ON dbo.dr20_legacy_survey_dr10  (nobs_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_parallax ON dbo.dr20_legacy_survey_dr10  (parallax) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_ref_cat ON dbo.dr20_legacy_survey_dr10  (ref_cat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_ref_id ON dbo.dr20_legacy_survey_dr10  (ref_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_shape_r ON dbo.dr20_legacy_survey_dr10  (shape_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_shape_r_ivar ON dbo.dr20_legacy_survey_dr10  (shape_r_ivar) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_survey_primary ON dbo.dr20_legacy_survey_dr10  (survey_primary) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr10_type ON dbo.dr20_legacy_survey_dr10  (type) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_fibertotflux_g ON dbo.dr20_legacy_survey_dr8  (fibertotflux_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_fibertotflux_r ON dbo.dr20_legacy_survey_dr8  (fibertotflux_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_fibertotflux_z ON dbo.dr20_legacy_survey_dr8  (fibertotflux_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_flux_g ON dbo.dr20_legacy_survey_dr8  (flux_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_flux_r ON dbo.dr20_legacy_survey_dr8  (flux_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_flux_w1 ON dbo.dr20_legacy_survey_dr8  (flux_w1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_flux_z ON dbo.dr20_legacy_survey_dr8  (flux_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_gaia_phot_g_mean_mag ON dbo.dr20_legacy_survey_dr8  (gaia_phot_g_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_gaia_phot_g_mean_mag_idx1 ON dbo.dr20_legacy_survey_dr8  (gaia_phot_g_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_gaia_phot_rp_mean_mag ON dbo.dr20_legacy_survey_dr8  (gaia_phot_rp_mean_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_gaia_sourceid ON dbo.dr20_legacy_survey_dr8  (gaia_sourceid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_maskbits ON dbo.dr20_legacy_survey_dr8  (maskbits) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_nobs_g ON dbo.dr20_legacy_survey_dr8  (nobs_g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_nobs_r ON dbo.dr20_legacy_survey_dr8  (nobs_r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_nobs_z ON dbo.dr20_legacy_survey_dr8  (nobs_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_parallax ON dbo.dr20_legacy_survey_dr8  (parallax) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_ref_cat ON dbo.dr20_legacy_survey_dr8  (ref_cat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_ref_epoch ON dbo.dr20_legacy_survey_dr8  (ref_epoch) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_legacy_survey_dr8_ref_id ON dbo.dr20_legacy_survey_dr8  (ref_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_magnitude_carton_to_target_pk ON dbo.dr20_magnitude  (carton_to_target_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_magnitude_h ON dbo.dr20_magnitude  (h) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangadapall_daptype ON dbo.dr20_mangadapall  (daptype) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangadapall_mangaid ON dbo.dr20_mangadapall  (mangaid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangadapall_nsa_z ON dbo.dr20_mangadapall  (nsa_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangadapall_plate ON dbo.dr20_mangadapall  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangadrpall_ifudsgn ON dbo.dr20_mangadrpall  (ifudsgn) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangadrpall_mangaid ON dbo.dr20_mangadrpall  (mangaid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangadrpall_nsa_z ON dbo.dr20_mangadrpall  (nsa_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangadrpall_plate ON dbo.dr20_mangadrpall  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangatarget_nsa_iauname ON dbo.dr20_mangatarget  (nsa_iauname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangatarget_nsa_nsaid ON dbo.dr20_mangatarget  (nsa_nsaid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangatarget_nsa_pid ON dbo.dr20_mangatarget  (nsa_pid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mangatarget_nsa_z ON dbo.dr20_mangatarget  (nsa_z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr11_star_gsc_name ON dbo.dr20_marvels_dr11_star  (gsc_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr11_star_hip_name ON dbo.dr20_marvels_dr11_star  (hip_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr11_star_plate ON dbo.dr20_marvels_dr11_star  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr11_star_twomass_designation ON dbo.dr20_marvels_dr11_star  (twomass_designation) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr11_star_twomass_name ON dbo.dr20_marvels_dr11_star  (twomass_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr11_star_tyc_name ON dbo.dr20_marvels_dr11_star  (tyc_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr11_star_tycho2_designation ON dbo.dr20_marvels_dr11_star  (tycho2_designation) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr12_star_gsc_name ON dbo.dr20_marvels_dr12_star  (gsc_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr12_star_hip_name ON dbo.dr20_marvels_dr12_star  (hip_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr12_star_plate ON dbo.dr20_marvels_dr12_star  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr12_star_starname ON dbo.dr20_marvels_dr12_star  (starname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr12_star_twomass_designation ON dbo.dr20_marvels_dr12_star  (twomass_designation) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr12_star_twomass_name ON dbo.dr20_marvels_dr12_star  (twomass_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr12_star_tyc_name ON dbo.dr20_marvels_dr12_star  (tyc_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_marvels_dr12_star_tycho2_designation ON dbo.dr20_marvels_dr12_star  (tycho2_designation) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_drpver ON dbo.dr20_mastar_goodstars  (drpver) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_epoch ON dbo.dr20_mastar_goodstars  (epoch) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_input_alpha_m ON dbo.dr20_mastar_goodstars  (input_alpha_m) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_input_fe_h ON dbo.dr20_mastar_goodstars  (input_fe_h) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_input_logg ON dbo.dr20_mastar_goodstars  (input_logg) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_input_teff ON dbo.dr20_mastar_goodstars  (input_teff) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_maxmjd ON dbo.dr20_mastar_goodstars  (maxmjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_minmjd ON dbo.dr20_mastar_goodstars  (minmjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_mngtarg2 ON dbo.dr20_mastar_goodstars  (mngtarg2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_mprocver ON dbo.dr20_mastar_goodstars  (mprocver) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_nplates ON dbo.dr20_mastar_goodstars  (nplates) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_nvisits ON dbo.dr20_mastar_goodstars  (nvisits) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodstars_photocat ON dbo.dr20_mastar_goodstars  (photocat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_coord_source ON dbo.dr20_mastar_goodvisits  (coord_source) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_drpver ON dbo.dr20_mastar_goodvisits  (drpver) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_epoch ON dbo.dr20_mastar_goodvisits  (epoch) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_exptime ON dbo.dr20_mastar_goodvisits  (exptime) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_heliov ON dbo.dr20_mastar_goodvisits  (heliov) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_heliov_visit ON dbo.dr20_mastar_goodvisits  (heliov_visit) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_ifudesign ON dbo.dr20_mastar_goodvisits  (ifudesign) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_mangaid ON dbo.dr20_mastar_goodvisits  (mangaid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_mjd ON dbo.dr20_mastar_goodvisits  (mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_mjdqual ON dbo.dr20_mastar_goodvisits  (mjdqual) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_mngtarg2 ON dbo.dr20_mastar_goodvisits  (mngtarg2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_mprocver ON dbo.dr20_mastar_goodvisits  (mprocver) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_nexp_used ON dbo.dr20_mastar_goodvisits  (nexp_used) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_nexp_visit ON dbo.dr20_mastar_goodvisits  (nexp_visit) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_nvelgood ON dbo.dr20_mastar_goodvisits  (nvelgood) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_photocat ON dbo.dr20_mastar_goodvisits  (photocat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mastar_goodvisits_plate ON dbo.dr20_mastar_goodvisits  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_b ON dbo.dr20_milliquas_7_7  (b) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_bmag ON dbo.dr20_milliquas_7_7  (bmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_name ON dbo.dr20_milliquas_7_7  (name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_qpct ON dbo.dr20_milliquas_7_7  (qpct) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_r ON dbo.dr20_milliquas_7_7  (r) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_rmag ON dbo.dr20_milliquas_7_7  (rmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_rname ON dbo.dr20_milliquas_7_7  (rname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_rxpct ON dbo.dr20_milliquas_7_7  (rxpct) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_type ON dbo.dr20_milliquas_7_7  (type) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_xname ON dbo.dr20_milliquas_7_7  (xname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_milliquas_7_7_z ON dbo.dr20_milliquas_7_7  (z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mipsgal_glat ON dbo.dr20_mipsgal  (glat) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mipsgal_glimpse ON dbo.dr20_mipsgal  (glimpse) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mipsgal_glon ON dbo.dr20_mipsgal  (glon) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mipsgal_hmag ON dbo.dr20_mipsgal  (hmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mipsgal_twomass_name ON dbo.dr20_mipsgal  (twomass_name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_mwm_tess_ob_h_mag ON dbo.dr20_mwm_tess_ob  (h_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_opsdb_apo_camera_frame_exposure_pk ON dbo.dr20_opsdb_apo_camera_frame  (exposure_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_opsdb_apo_configuration_design_id ON dbo.dr20_opsdb_apo_configuration  (design_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_opsdb_apo_exposure_configuration_id ON dbo.dr20_opsdb_apo_exposure  (configuration_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_opsdb_apo_exposure_start_time ON dbo.dr20_opsdb_apo_exposure  (start_time) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_opsdb_lco_camera_frame_exposure_pk ON dbo.dr20_opsdb_lco_camera_frame  (exposure_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_opsdb_lco_configuration_design_id ON dbo.dr20_opsdb_lco_configuration  (design_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_opsdb_lco_exposure_configuration_id ON dbo.dr20_opsdb_lco_exposure  (configuration_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_opsdb_lco_exposure_start_time ON dbo.dr20_opsdb_lco_exposure  (start_time) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_extid_hi_lo ON dbo.dr20_panstarrs1  (extid_hi_lo) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_flags ON dbo.dr20_panstarrs1  (flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_g_flags ON dbo.dr20_panstarrs1  (g_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_g_stk_psf_flux ON dbo.dr20_panstarrs1  (g_stk_psf_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_i_flags ON dbo.dr20_panstarrs1  (i_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_i_stk_psf_flux ON dbo.dr20_panstarrs1  (i_stk_psf_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_r_flags ON dbo.dr20_panstarrs1  (r_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_r_stk_psf_flux ON dbo.dr20_panstarrs1  (r_stk_psf_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_stargal ON dbo.dr20_panstarrs1  (stargal) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_z_flags ON dbo.dr20_panstarrs1  (z_flags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_panstarrs1_z_stk_psf_flux ON dbo.dr20_panstarrs1  (z_stk_psf_flux) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_al_h_chisq_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (al_h_chisq_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_al_h_error_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (al_h_error_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_al_h_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (al_h_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_al_h_nl_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (al_h_nl_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_alpha_fe_chisq_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (alpha_fe_chisq_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_alpha_fe_error_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (alpha_fe_error_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_alpha_fe_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (alpha_fe_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_fe_h_chisq_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (fe_h_chisq_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_fe_h_error_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (fe_h_error_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_fe_h_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (fe_h_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_fe_h_nl_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (fe_h_nl_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_n_elements_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (n_elements_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_ni_h_chisq_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (ni_h_chisq_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_ni_h_error_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (ni_h_error_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_ni_h_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (ni_h_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_ni_h_nl_gauguin ON dbo.dr20_rave_dr6_gauguin_madera  (ni_h_nl_gauguin) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_gauguin_madera_rave_obs_id ON dbo.dr20_rave_dr6_gauguin_madera  (rave_obs_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_rave_dr6_xgaiae3_gaiae3 ON dbo.dr20_rave_dr6_xgaiae3  (gaiae3) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_revised_magnitude_carton_to_target_pk ON dbo.dr20_revised_magnitude  (carton_to_target_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_revised_magnitude_h ON dbo.dr20_revised_magnitude  (h) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_av ON dbo.dr20_sagitta  (av) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_edr3_age ON dbo.dr20_sagitta_edr3  (age) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_edr3_age_std ON dbo.dr20_sagitta_edr3  (age_std) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_edr3_av ON dbo.dr20_sagitta_edr3  (av) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_edr3_av_std ON dbo.dr20_sagitta_edr3  (av_std) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_edr3_pms ON dbo.dr20_sagitta_edr3  (pms) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_edr3_pms_std ON dbo.dr20_sagitta_edr3  (pms_std) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_yso ON dbo.dr20_sagitta  (yso) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sagitta_yso_std ON dbo.dr20_sagitta  (yso_std) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_apogeeallstarmerge_r13_h ON dbo.dr20_sdss_apogeeallstarmerge_r13  (h) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_apogeeallstarmerge_r13_j ON dbo.dr20_sdss_apogeeallstarmerge_r13  (j) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_apogeeallstarmerge_r13_k ON dbo.dr20_sdss_apogeeallstarmerge_r13  (k) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr13_photoobj_primary_objid ON dbo.dr20_sdss_dr13_photoobj_primary  (objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_qso_fiberid ON dbo.dr20_sdss_dr16_qso  (fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_qso_mjd ON dbo.dr20_sdss_dr16_qso  (mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_qso_mjd_plate_fiberid ON dbo.dr20_sdss_dr16_qso  (mjd, plate, fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_qso_plate ON dbo.dr20_sdss_dr16_qso  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_bestobjid ON dbo.dr20_sdss_dr16_specobj  (bestobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_fiberid ON dbo.dr20_sdss_dr16_specobj  (fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_fluxobjid ON dbo.dr20_sdss_dr16_specobj  (fluxobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_mjd ON dbo.dr20_sdss_dr16_specobj  (mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_plate ON dbo.dr20_sdss_dr16_specobj  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_run2d ON dbo.dr20_sdss_dr16_specobj  (run2d) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_scienceprimary ON dbo.dr20_sdss_dr16_specobj  (scienceprimary) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_snmedian ON dbo.dr20_sdss_dr16_specobj  (snmedian) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_targetobjid ON dbo.dr20_sdss_dr16_specobj  (targetobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_z ON dbo.dr20_sdss_dr16_specobj  (z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_zerr ON dbo.dr20_sdss_dr16_specobj  (zerr) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr16_specobj_zwarning ON dbo.dr20_sdss_dr16_specobj  (zwarning) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_apogee_allstarmerge_gaia_source_id ON dbo.dr20_sdss_dr17_apogee_allstarmerge  (gaia_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_bestobjid ON dbo.dr20_sdss_dr17_specobj  (bestobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_bestobjid_idx1 ON dbo.dr20_sdss_dr17_specobj  (bestobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_fiberid ON dbo.dr20_sdss_dr17_specobj  (fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_fluxobjid ON dbo.dr20_sdss_dr17_specobj  (fluxobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_mjd ON dbo.dr20_sdss_dr17_specobj  (mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_mjd_plate_fiberid ON dbo.dr20_sdss_dr17_specobj  (mjd, plate, fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_mjd_plate_fiberid_run2d ON dbo.dr20_sdss_dr17_specobj  (mjd, plate, fiberid, run2d) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_plateid ON dbo.dr20_sdss_dr17_specobj  (plateid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_run2d ON dbo.dr20_sdss_dr17_specobj  (run2d) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr17_specobj_targetobjid ON dbo.dr20_sdss_dr17_specobj  (targetobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr19p_speclite_bestobjid ON dbo.dr20_sdss_dr19p_speclite  (bestobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr19p_speclite_catalogid ON dbo.dr20_sdss_dr19p_speclite  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr19p_speclite_mjd ON dbo.dr20_sdss_dr19p_speclite  (mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr19p_speclite_plate_mjd_fiberid ON dbo.dr20_sdss_dr19p_speclite  (plate, mjd, fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr19p_speclite_sn_median_all ON dbo.dr20_sdss_dr19p_speclite  (sn_median_all) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr19p_speclite_z_err ON dbo.dr20_sdss_dr19p_speclite  (z_err) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr19p_speclite_z ON dbo.dr20_sdss_dr19p_speclite  (z) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_dr19p_speclite_zwarning ON dbo.dr20_sdss_dr19p_speclite  (zwarning) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_flat_catalogid ON dbo.dr20_sdss_id_flat  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_catalogid_idx1 ON dbo.dr20_sdss_id_flat  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_flat_dec_catalogid ON dbo.dr20_sdss_id_flat  (dec_catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_flat_dec_sdss_id ON dbo.dr20_sdss_id_flat  (dec_sdss_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_flat_initial_catalogid ON dbo.dr20_sdss_id_flat_initial  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_flat_initial_sdss_id ON dbo.dr20_sdss_id_flat_initial  (sdss_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_flat_n_associated ON dbo.dr20_sdss_id_flat  (n_associated) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_flat_ra_catalogid ON dbo.dr20_sdss_id_flat  (ra_catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_flat_sdss_id ON dbo.dr20_sdss_id_flat  (sdss_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_stacked_catalogid21 ON dbo.dr20_sdss_id_stacked  (catalogid21) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_stacked_catalogid25 ON dbo.dr20_sdss_id_stacked  (catalogid25) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_sdss_id_stacked_catalogid25_idx1 ON dbo.dr20_sdss_id_stacked  (catalogid25) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_stacked_catalogid31 ON dbo.dr20_sdss_id_stacked  (catalogid31) ON [MINIDB];


CREATE NONCLUSTERED INDEX dr20_sdss_id_stacked_catalogid31_idx1 ON dbo.dr20_sdss_id_stacked  (catalogid31) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_allstar_dr17_synspec_rev1__apstar_i ON dbo.dr20_sdss_id_to_catalog  (allstar_dr17_synspec_rev1__apstar_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_allwise__cntr ON dbo.dr20_sdss_id_to_catalog  (allwise__cntr) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_bhm_rm_v0_2__pk ON dbo.dr20_sdss_id_to_catalog  (bhm_rm_v0_2__pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_bhm_rm_v0__pk ON dbo.dr20_sdss_id_to_catalog  (bhm_rm_v0__pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_catalogid ON dbo.dr20_sdss_id_to_catalog  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_catwise2020__source_id ON dbo.dr20_sdss_id_to_catalog  (catwise2020__source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_catwise__source_id ON dbo.dr20_sdss_id_to_catalog  (catwise__source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_full_catalogid ON dbo.dr20_sdss_id_to_catalog_full  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_gaia_dr2_source__source_id ON dbo.dr20_sdss_id_to_catalog  (gaia_dr2_source__source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_gaia_dr3_source__source_id ON dbo.dr20_sdss_id_to_catalog  (gaia_dr3_source__source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_glimpse__pk ON dbo.dr20_sdss_id_to_catalog  (glimpse__pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_guvcat__objid ON dbo.dr20_sdss_id_to_catalog  (guvcat__objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_legacy_survey_dr10__ls_id ON dbo.dr20_sdss_id_to_catalog  (legacy_survey_dr10__ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_legacy_survey_dr8__ls_id ON dbo.dr20_sdss_id_to_catalog  (legacy_survey_dr8__ls_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_mangatarget__mangaid ON dbo.dr20_sdss_id_to_catalog  (mangatarget__mangaid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_marvels_dr11_star__starname ON dbo.dr20_sdss_id_to_catalog  (marvels_dr11_star__starname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_marvels_dr12_star__pk ON dbo.dr20_sdss_id_to_catalog  (marvels_dr12_star__pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_mastar_goodstars__mangaid ON dbo.dr20_sdss_id_to_catalog  (mastar_goodstars__mangaid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_panstarrs1__catid_objid ON dbo.dr20_sdss_id_to_catalog  (panstarrs1__catid_objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_pk ON dbo.dr20_sdss_id_to_catalog  (pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_ps1_g18__objid ON dbo.dr20_sdss_id_to_catalog  (ps1_g18__objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_sdss_dr13_photoobj__objid ON dbo.dr20_sdss_id_to_catalog  (sdss_dr13_photoobj__objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_sdss_dr17_specobj__specobjid ON dbo.dr20_sdss_id_to_catalog  (sdss_dr17_specobj__specobjid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_sdss_id ON dbo.dr20_sdss_id_to_catalog  (sdss_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_skymapper_dr1_1__object_id ON dbo.dr20_sdss_id_to_catalog  (skymapper_dr1_1__object_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_skymapper_dr2__object_id ON dbo.dr20_sdss_id_to_catalog  (skymapper_dr2__object_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_supercosmos__objid ON dbo.dr20_sdss_id_to_catalog  (supercosmos__objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_tic_v8__id ON dbo.dr20_sdss_id_to_catalog  (tic_v8__id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_twomass_psc__pts_key ON dbo.dr20_sdss_id_to_catalog  (twomass_psc__pts_key) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_tycho2__designation ON dbo.dr20_sdss_id_to_catalog  (tycho2__designation) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_unwise__unwise_objid ON dbo.dr20_sdss_id_to_catalog  (unwise__unwise_objid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdss_id_to_catalog_version_id ON dbo.dr20_sdss_id_to_catalog  (version_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_designid ON dbo.dr20_sdssv_boss_conflist  (designid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_mjd ON dbo.dr20_sdssv_boss_conflist  (mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_plate ON dbo.dr20_sdssv_boss_conflist  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_plate_mjd ON dbo.dr20_sdssv_boss_conflist  (plate, mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_platesn2 ON dbo.dr20_sdssv_boss_conflist  (platesn2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_programname ON dbo.dr20_sdssv_boss_conflist  (programname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_sn2_g1 ON dbo.dr20_sdssv_boss_conflist  (sn2_g1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_sn2_i1 ON dbo.dr20_sdssv_boss_conflist  (sn2_i1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_conflist_sn2_r1 ON dbo.dr20_sdssv_boss_conflist  (sn2_r1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_catalogid ON dbo.dr20_sdssv_boss_spall  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_fiberid ON dbo.dr20_sdssv_boss_spall  (fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_firstcarton ON dbo.dr20_sdssv_boss_spall  (firstcarton) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_mjd ON dbo.dr20_sdssv_boss_spall  (mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_plate ON dbo.dr20_sdssv_boss_spall  (plate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_plate_mjd_fiberid ON dbo.dr20_sdssv_boss_spall  (plate, mjd, fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_plate_mjd ON dbo.dr20_sdssv_boss_spall  (plate, mjd) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_programname ON dbo.dr20_sdssv_boss_spall  (programname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_sn_median_all ON dbo.dr20_sdssv_boss_spall  (sn_median_all) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_specprimary ON dbo.dr20_sdssv_boss_spall  (specprimary) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_z_err ON dbo.dr20_sdssv_boss_spall  (z_err) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_boss_spall_zwarning ON dbo.dr20_sdssv_boss_spall  (zwarning) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_block ON dbo.dr20_sdssv_plateholes  (block) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_catalogid ON dbo.dr20_sdssv_plateholes  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_fiberid ON dbo.dr20_sdssv_plateholes  (fiberid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_firstcarton ON dbo.dr20_sdssv_plateholes  (firstcarton) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_holetype ON dbo.dr20_sdssv_plateholes  (holetype) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_meta_defaultsurveymode ON dbo.dr20_sdssv_plateholes_meta  (defaultsurveymode) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_meta_designid ON dbo.dr20_sdssv_plateholes_meta  (designid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_meta_isvalid ON dbo.dr20_sdssv_plateholes_meta  (isvalid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_meta_locationid ON dbo.dr20_sdssv_plateholes_meta  (locationid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_meta_plateid ON dbo.dr20_sdssv_plateholes_meta  (plateid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_meta_programname ON dbo.dr20_sdssv_plateholes_meta  (programname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_sdssv_apogee_target0 ON dbo.dr20_sdssv_plateholes  (sdssv_apogee_target0) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_sdssv_boss_target0 ON dbo.dr20_sdssv_plateholes  (sdssv_boss_target0) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_sourcetype ON dbo.dr20_sdssv_plateholes  (sourcetype) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_targettype ON dbo.dr20_sdssv_plateholes  (targettype) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_sdssv_plateholes_yanny_uid ON dbo.dr20_sdssv_plateholes  (yanny_uid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_down_pix ON dbo.dr20_skies_v1  (down_pix) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_mag_neighbour_gaia ON dbo.dr20_skies_v1  (mag_neighbour_gaia) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_mag_neighbour_ls8 ON dbo.dr20_skies_v1  (mag_neighbour_ls8) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_mag_neighbour_tmass ON dbo.dr20_skies_v1  (mag_neighbour_tmass) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_mag_neighbour_tmass_xsc ON dbo.dr20_skies_v1  (mag_neighbour_tmass_xsc) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_mag_neighbour_tycho2 ON dbo.dr20_skies_v1  (mag_neighbour_tycho2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_sep_neighbour_gaia ON dbo.dr20_skies_v1  (sep_neighbour_gaia) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_sep_neighbour_ls8 ON dbo.dr20_skies_v1  (sep_neighbour_ls8) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_sep_neighbour_tmass ON dbo.dr20_skies_v1  (sep_neighbour_tmass) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_sep_neighbour_tmass_xsc ON dbo.dr20_skies_v1  (sep_neighbour_tmass_xsc) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_sep_neighbour_tycho2 ON dbo.dr20_skies_v1  (sep_neighbour_tycho2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v1_tile_32 ON dbo.dr20_skies_v1  (tile_32) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_down_pix ON dbo.dr20_skies_v2  (down_pix) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_mag_neighbour_gaia ON dbo.dr20_skies_v2  (mag_neighbour_gaia) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_mag_neighbour_ls8 ON dbo.dr20_skies_v2  (mag_neighbour_ls8) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_mag_neighbour_ps1dr2 ON dbo.dr20_skies_v2  (mag_neighbour_ps1dr2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_mag_neighbour_tmass ON dbo.dr20_skies_v2  (mag_neighbour_tmass) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_mag_neighbour_tycho2 ON dbo.dr20_skies_v2  (mag_neighbour_tycho2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_sep_neighbour_gaia ON dbo.dr20_skies_v2  (sep_neighbour_gaia) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_sep_neighbour_ls8 ON dbo.dr20_skies_v2  (sep_neighbour_ls8) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_sep_neighbour_ps1dr2 ON dbo.dr20_skies_v2  (sep_neighbour_ps1dr2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_sep_neighbour_tmass ON dbo.dr20_skies_v2  (sep_neighbour_tmass) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_sep_neighbour_tmass_xsc ON dbo.dr20_skies_v2  (sep_neighbour_tmass_xsc) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_sep_neighbour_tycho2 ON dbo.dr20_skies_v2  (sep_neighbour_tycho2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skies_v2_tile_32 ON dbo.dr20_skies_v2  (tile_32) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_allwise_cntr ON dbo.dr20_skymapper_dr2  (allwise_cntr) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_flags_psf ON dbo.dr20_skymapper_dr2  (flags_psf) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_g_psf ON dbo.dr20_skymapper_dr2  (g_psf) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_gaia_dr2_id1 ON dbo.dr20_skymapper_dr2  (gaia_dr2_id1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_gaia_dr2_id2 ON dbo.dr20_skymapper_dr2  (gaia_dr2_id2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_i_psf ON dbo.dr20_skymapper_dr2  (i_psf) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_nimaflags ON dbo.dr20_skymapper_dr2  (nimaflags) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_r_psf ON dbo.dr20_skymapper_dr2  (r_psf) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_smss_j ON dbo.dr20_skymapper_dr2  (smss_j) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_dr2_z_psf ON dbo.dr20_skymapper_dr2  (z_psf) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_gaia_feh ON dbo.dr20_skymapper_gaia  (feh) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_gaia_gaia_source_id ON dbo.dr20_skymapper_gaia  (gaia_source_id) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_skymapper_gaia_teff ON dbo.dr20_skymapper_gaia  (teff) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_supercosmos_classb ON dbo.dr20_supercosmos  (classb) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_supercosmos_classi ON dbo.dr20_supercosmos  (classi) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_supercosmos_classmagb ON dbo.dr20_supercosmos  (classmagb) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_supercosmos_classmagi ON dbo.dr20_supercosmos  (classmagi) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_supercosmos_classmagr1 ON dbo.dr20_supercosmos  (classmagr1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_supercosmos_classmagr2 ON dbo.dr20_supercosmos  (classmagr2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_supercosmos_classr1 ON dbo.dr20_supercosmos  (classr1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_supercosmos_classr2 ON dbo.dr20_supercosmos  (classr2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_target_catalogid ON dbo.dr20_target  (catalogid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_targeting_generation_to_carton_carton_pk ON dbo.dr20_targeting_generation_to_carton  (carton_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_targeting_generation_to_carton_generation_pk ON dbo.dr20_targeting_generation_to_carton  (generation_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_targeting_generation_to_version_generation_pk ON dbo.dr20_targeting_generation_to_version  (generation_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_targeting_generation_to_version_version_pk ON dbo.dr20_targeting_generation_to_version  (version_pk) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_ticid ON dbo.dr20_tess_toi  (ticid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v05_ctoi ON dbo.dr20_tess_toi_v05  (ctoi) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v05_num_sectors ON dbo.dr20_tess_toi_v05  (num_sectors) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v05_target_type ON dbo.dr20_tess_toi_v05  (target_type) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v05_tess_disposition ON dbo.dr20_tess_toi_v05  (tess_disposition) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v05_tfopwg_disposition ON dbo.dr20_tess_toi_v05  (tfopwg_disposition) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v05_ticid ON dbo.dr20_tess_toi_v05  (ticid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v05_toi ON dbo.dr20_tess_toi_v05  (toi) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v05_user_disposition ON dbo.dr20_tess_toi_v05  (user_disposition) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v1_ctoi ON dbo.dr20_tess_toi_v1  (ctoi) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v1_num_sectors ON dbo.dr20_tess_toi_v1  (num_sectors) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v1_target_type ON dbo.dr20_tess_toi_v1  (target_type) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v1_tess_disposition ON dbo.dr20_tess_toi_v1  (tess_disposition) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v1_tfopwg_disposition ON dbo.dr20_tess_toi_v1  (tfopwg_disposition) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v1_ticid ON dbo.dr20_tess_toi_v1  (ticid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v1_toi ON dbo.dr20_tess_toi_v1  (toi) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tess_toi_v1_user_disposition ON dbo.dr20_tess_toi_v1  (user_disposition) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_allwise ON dbo.dr20_tic_v8  (allwise) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_gaia_int ON dbo.dr20_tic_v8  (gaia_int) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_gaiamag ON dbo.dr20_tic_v8  (gaiamag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_hmag ON dbo.dr20_tic_v8  (hmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_kic ON dbo.dr20_tic_v8  (kic) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_logg ON dbo.dr20_tic_v8  (logg) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_objtype ON dbo.dr20_tic_v8  (objtype) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_plx ON dbo.dr20_tic_v8  (plx) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_posflag ON dbo.dr20_tic_v8  (posflag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_sdss ON dbo.dr20_tic_v8  (sdss) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_teff ON dbo.dr20_tic_v8  (teff) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_tmag ON dbo.dr20_tic_v8  (tmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_twomass_psc ON dbo.dr20_tic_v8  (twomass_psc) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_twomass_psc_pts_key ON dbo.dr20_tic_v8  (twomass_psc_pts_key) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tic_v8_tycho2_tycid ON dbo.dr20_tic_v8  (tycho2_tycid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_twomass_psc_cc_flg ON dbo.dr20_twomass_psc  (cc_flg) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_twomass_psc_gal_contam ON dbo.dr20_twomass_psc  (gal_contam) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_twomass_psc_jdate ON dbo.dr20_twomass_psc  (jdate) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_twomass_psc_ph_qual ON dbo.dr20_twomass_psc  (ph_qual) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_twomass_psc_rd_flg ON dbo.dr20_twomass_psc  (rd_flg) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tycho2_btmag ON dbo.dr20_tycho2  (btmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tycho2_tycid ON dbo.dr20_tycho2  (tycid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_tycho2_vtmag ON dbo.dr20_tycho2  (vtmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_unwise_flux_w1 ON dbo.dr20_unwise  (flux_w1) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_unwise_flux_w2 ON dbo.dr20_unwise  (flux_w2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_uvotssc1_name ON dbo.dr20_uvotssc1  (name) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_uvotssc1_obsid ON dbo.dr20_uvotssc1  (obsid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_uvotssc1_srcid ON dbo.dr20_uvotssc1  (srcid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_visual_binary_gaia_dr3_source_id2 ON dbo.dr20_visual_binary_gaia_dr3  (source_id2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_wd_gaia_dr3_gaiadr2 ON dbo.dr20_wd_gaia_dr3  (gaiadr2) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_4_1_iauname ON dbo.dr20_xmm_om_suss_4_1  (iauname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_iauname ON dbo.dr20_xmm_om_suss_5_0  (iauname) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_n_summary ON dbo.dr20_xmm_om_suss_5_0  (n_summary) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_obsid ON dbo.dr20_xmm_om_suss_5_0  (obsid) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_srcnum ON dbo.dr20_xmm_om_suss_5_0  (srcnum) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvm2_ab_mag ON dbo.dr20_xmm_om_suss_5_0  (uvm2_ab_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvm2_quality_flag_st ON dbo.dr20_xmm_om_suss_5_0  (uvm2_quality_flag_st) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvm2_signif ON dbo.dr20_xmm_om_suss_5_0  (uvm2_signif) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvw1_ab_mag ON dbo.dr20_xmm_om_suss_5_0  (uvw1_ab_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvw1_quality_flag_st ON dbo.dr20_xmm_om_suss_5_0  (uvw1_quality_flag_st) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvw1_signif ON dbo.dr20_xmm_om_suss_5_0  (uvw1_signif) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvw2_ab_mag ON dbo.dr20_xmm_om_suss_5_0  (uvw2_ab_mag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvw2_quality_flag_st ON dbo.dr20_xmm_om_suss_5_0  (uvw2_quality_flag_st) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xmm_om_suss_5_0_uvw2_signif ON dbo.dr20_xmm_om_suss_5_0  (uvw2_signif) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xpfeh_gaia_dr3_in_training_sample ON dbo.dr20_xpfeh_gaia_dr3  (in_training_sample) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xpfeh_gaia_dr3_logg_xgboost ON dbo.dr20_xpfeh_gaia_dr3  (logg_xgboost) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xpfeh_gaia_dr3_mh_xgboost ON dbo.dr20_xpfeh_gaia_dr3  (mh_xgboost) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_xpfeh_gaia_dr3_teff_xgboost ON dbo.dr20_xpfeh_gaia_dr3  (teff_xgboost) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_yso_clustering_bp ON dbo.dr20_yso_clustering  (bp) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_yso_clustering_g ON dbo.dr20_yso_clustering  (g) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_yso_clustering_h ON dbo.dr20_yso_clustering  (h) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_yso_clustering_j ON dbo.dr20_yso_clustering  (j) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_yso_clustering_k ON dbo.dr20_yso_clustering  (k) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_yso_clustering_rp ON dbo.dr20_yso_clustering  (rp) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_zari18pms_bp_over_rp ON dbo.dr20_zari18pms  (bp_over_rp) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_zari18pms_bp_rp ON dbo.dr20_zari18pms  (bp_rp) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_zari18pms_bpmag ON dbo.dr20_zari18pms  (bpmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_zari18pms_gmag ON dbo.dr20_zari18pms  (gmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_zari18pms_rpmag ON dbo.dr20_zari18pms  (rpmag) ON [MINIDB];


CREATE NONCLUSTERED INDEX idx_zari18pms_source ON dbo.dr20_zari18pms  (source) ON [MINIDB];
