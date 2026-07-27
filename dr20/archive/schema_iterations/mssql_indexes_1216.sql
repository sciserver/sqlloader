

CREATE NONCLUSTERED INDEX dr20_allstar_dr17_synspec_rev1_apogee_id_idx ON dbo.dr20_allstar_dr17_synspec_rev1  (apogee_id);


CREATE NONCLUSTERED INDEX dr20_allstar_dr17_synspec_rev1_aspcap_id_idx ON dbo.dr20_allstar_dr17_synspec_rev1  (aspcap_id);


CREATE NONCLUSTERED INDEX dr20_allwise_designation_idx ON dbo.dr20_allwise  (designation);


CREATE NONCLUSTERED INDEX dr20_allwise_expr_idx ON dbo.dr20_allwise  (((w1mpro - w2mpro)));


CREATE NONCLUSTERED INDEX dr20_allwise_ph_qual_idx ON dbo.dr20_allwise  (ph_qual);


CREATE NONCLUSTERED INDEX dr20_allwise_w1mpro_idx ON dbo.dr20_allwise  (w1mpro);


CREATE NONCLUSTERED INDEX dr20_allwise_w1sigmpro_idx ON dbo.dr20_allwise  (w1sigmpro);


CREATE NONCLUSTERED INDEX dr20_allwise_w2mpro_idx ON dbo.dr20_allwise  (w2mpro);


CREATE NONCLUSTERED INDEX dr20_allwise_w2sigmpro_idx ON dbo.dr20_allwise  (w2sigmpro);


CREATE NONCLUSTERED INDEX dr20_allwise_w3mpro_idx ON dbo.dr20_allwise  (w3mpro);


CREATE NONCLUSTERED INDEX dr20_allwise_w3sigmpro_idx ON dbo.dr20_allwise  (w3sigmpro);


CREATE NONCLUSTERED INDEX dr20_assignment_carton_to_target_pk_idx ON dbo.dr20_assignment  (carton_to_target_pk);


CREATE NONCLUSTERED INDEX dr20_assignment_design_id_idx ON dbo.dr20_assignment  (design_id);


CREATE NONCLUSTERED INDEX dr20_assignment_hole_pk_idx ON dbo.dr20_assignment  (hole_pk);


CREATE NONCLUSTERED INDEX dr20_assignment_instrument_pk_idx ON dbo.dr20_assignment  (instrument_pk);


CREATE NONCLUSTERED INDEX dr20_bailer_jones_edr3_flag_idx ON dbo.dr20_bailer_jones_edr3  (flag);


CREATE NONCLUSTERED INDEX dr20_bailer_jones_edr3_r_hi_geo_idx ON dbo.dr20_bailer_jones_edr3  (r_hi_geo);


CREATE NONCLUSTERED INDEX dr20_bailer_jones_edr3_r_hi_photogeo_idx ON dbo.dr20_bailer_jones_edr3  (r_hi_photogeo);


CREATE NONCLUSTERED INDEX dr20_bailer_jones_edr3_r_lo_geo_idx ON dbo.dr20_bailer_jones_edr3  (r_lo_geo);


CREATE NONCLUSTERED INDEX dr20_bailer_jones_edr3_r_lo_photogeo_idx ON dbo.dr20_bailer_jones_edr3  (r_lo_photogeo);


CREATE NONCLUSTERED INDEX dr20_bailer_jones_edr3_r_med_geo_idx ON dbo.dr20_bailer_jones_edr3  (r_med_geo);


CREATE NONCLUSTERED INDEX dr20_bailer_jones_edr3_r_med_photogeo_idx ON dbo.dr20_bailer_jones_edr3  (r_med_photogeo);


CREATE NONCLUSTERED INDEX dr20_best_brightest_gmag_idx ON dbo.dr20_best_brightest  (gmag);


CREATE NONCLUSTERED INDEX dr20_best_brightest_version_idx ON dbo.dr20_best_brightest  (version);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_mag_g_idx ON dbo.dr20_bhm_csc  (mag_g);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_mag_h_idx ON dbo.dr20_bhm_csc  (mag_h);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_mag_i_idx ON dbo.dr20_bhm_csc  (mag_i);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_mag_r_idx ON dbo.dr20_bhm_csc  (mag_r);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_mag_z_idx ON dbo.dr20_bhm_csc  (mag_z);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v2_cxoid_idx ON dbo.dr20_bhm_csc_v2  (cxoid);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v2_designation2m_idx ON dbo.dr20_bhm_csc_v2  (designation2m);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v2_hmag_idx ON dbo.dr20_bhm_csc_v2  (hmag);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v2_idg2_idx ON dbo.dr20_bhm_csc_v2  (idg2);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v2_idps_idx ON dbo.dr20_bhm_csc_v2  (idps);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v2_ocat_idx ON dbo.dr20_bhm_csc_v2  (ocat);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v2_oid_idx ON dbo.dr20_bhm_csc_v2  (oid);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v2_omag_idx ON dbo.dr20_bhm_csc_v2  (omag);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v3_best_mag_idx ON dbo.dr20_bhm_csc_v3  (best_mag);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v3_best_oir_cat_idx ON dbo.dr20_bhm_csc_v3  (best_oir_cat);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v3_csc21p_id_idx ON dbo.dr20_bhm_csc_v3  (csc21p_id);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v3_gaia_dr3_srcid_idx ON dbo.dr20_bhm_csc_v3  (gaia_dr3_srcid);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v3_ls_dr10_lsid_idx ON dbo.dr20_bhm_csc_v3  (ls_dr10_lsid);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v3_ps21p_ippobjid_idx ON dbo.dr20_bhm_csc_v3  (ps21p_ippobjid);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v3_ps21p_objid_idx ON dbo.dr20_bhm_csc_v3  (ps21p_objid);


CREATE NONCLUSTERED INDEX dr20_bhm_csc_v3_tmass_designation_idx ON dbo.dr20_bhm_csc_v3  (tmass_designation);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_catalogid_idx ON dbo.dr20_bhm_rm_tweaks  (catalogid);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_date_set_idx ON dbo.dr20_bhm_rm_tweaks  (date_set);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_fiberid_idx ON dbo.dr20_bhm_rm_tweaks  (fiberid);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_firstcarton_idx ON dbo.dr20_bhm_rm_tweaks  (firstcarton);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_gaia_g_idx ON dbo.dr20_bhm_rm_tweaks  (gaia_g);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_in_plate_idx ON dbo.dr20_bhm_rm_tweaks  (in_plate);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_mjd_idx ON dbo.dr20_bhm_rm_tweaks  (mjd);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_plate_idx ON dbo.dr20_bhm_rm_tweaks  (plate);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_rm_field_name_idx ON dbo.dr20_bhm_rm_tweaks  (rm_field_name);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_tweaks_rm_suitability_idx ON dbo.dr20_bhm_rm_tweaks  (rm_suitability);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_2_coadd_object_id_idx ON dbo.dr20_bhm_rm_v0_2  (coadd_object_id);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_2_id_nsc_idx ON dbo.dr20_bhm_rm_v0_2  (id_nsc);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_2_objid_ps1_idx ON dbo.dr20_bhm_rm_v0_2  (objid_ps1);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_2_objid_sdss_idx ON dbo.dr20_bhm_rm_v0_2  (objid_sdss);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_2_objid_unwise_idx ON dbo.dr20_bhm_rm_v0_2  (objid_unwise);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_2_source_id_gaia_idx ON dbo.dr20_bhm_rm_v0_2  (source_id_gaia);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_2_sourceid_ir_idx ON dbo.dr20_bhm_rm_v0_2  (sourceid_ir);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_mi_idx ON dbo.dr20_bhm_rm_v0  (mi);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_objid_sdss_idx ON dbo.dr20_bhm_rm_v0  (objid_sdss);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_objid_unwise_idx ON dbo.dr20_bhm_rm_v0  (objid_unwise);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_photo_bitmask_idx ON dbo.dr20_bhm_rm_v0  (photo_bitmask);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_plxsig_idx ON dbo.dr20_bhm_rm_v0  (plxsig);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_pmsig_idx ON dbo.dr20_bhm_rm_v0  (pmsig);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_skewt_qso_idx ON dbo.dr20_bhm_rm_v0  (skewt_qso);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_source_id_gaia_idx ON dbo.dr20_bhm_rm_v0  (source_id_gaia);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v0_spec_q_idx ON dbo.dr20_bhm_rm_v0  (spec_q);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_catalogidv05_idx ON dbo.dr20_bhm_rm_v1_1  (catalogidv05);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_gaia_dr2_source_id_idx ON dbo.dr20_bhm_rm_v1_1  (gaia_dr2_source_id);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_gaia_dr3_source_id_idx ON dbo.dr20_bhm_rm_v1_1  (gaia_dr3_source_id);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_gaia_g_idx ON dbo.dr20_bhm_rm_v1_1  (gaia_g);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_ls_id_dr10_idx ON dbo.dr20_bhm_rm_v1_1  (ls_id_dr10);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_ls_id_dr8_idx ON dbo.dr20_bhm_rm_v1_1  (ls_id_dr8);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_mag_g_idx ON dbo.dr20_bhm_rm_v1_1  (mag_g);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_mag_i_idx ON dbo.dr20_bhm_rm_v1_1  (mag_i);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_mag_r_idx ON dbo.dr20_bhm_rm_v1_1  (mag_r);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_panstarrs1_catid_objid_idx ON dbo.dr20_bhm_rm_v1_1  (panstarrs1_catid_objid);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_rm_ancillary_idx ON dbo.dr20_bhm_rm_v1_1  (rm_ancillary);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_rm_core_idx ON dbo.dr20_bhm_rm_v1_1  (rm_core);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_rm_field_name_idx ON dbo.dr20_bhm_rm_v1_1  (rm_field_name);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_rm_known_spec_idx ON dbo.dr20_bhm_rm_v1_1  (rm_known_spec);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_rm_unsuitable_idx ON dbo.dr20_bhm_rm_v1_1  (rm_unsuitable);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_rm_var_idx ON dbo.dr20_bhm_rm_v1_1  (rm_var);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_1_rm_xrayqso_idx ON dbo.dr20_bhm_rm_v1_1  (rm_xrayqso);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_catalogidv05_idx ON dbo.dr20_bhm_rm_v1_3  (catalogidv05);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_gaia_dr2_source_id_idx ON dbo.dr20_bhm_rm_v1_3  (gaia_dr2_source_id);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_gaia_dr3_source_id_idx ON dbo.dr20_bhm_rm_v1_3  (gaia_dr3_source_id);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_gaia_g_idx ON dbo.dr20_bhm_rm_v1_3  (gaia_g);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_ls_id_dr10_idx ON dbo.dr20_bhm_rm_v1_3  (ls_id_dr10);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_ls_id_dr8_idx ON dbo.dr20_bhm_rm_v1_3  (ls_id_dr8);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_mag_g_idx ON dbo.dr20_bhm_rm_v1_3  (mag_g);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_mag_i_idx ON dbo.dr20_bhm_rm_v1_3  (mag_i);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_mag_r_idx ON dbo.dr20_bhm_rm_v1_3  (mag_r);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_panstarrs1_catid_objid_idx ON dbo.dr20_bhm_rm_v1_3  (panstarrs1_catid_objid);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_rm_ancillary_idx ON dbo.dr20_bhm_rm_v1_3  (rm_ancillary);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_rm_core_idx ON dbo.dr20_bhm_rm_v1_3  (rm_core);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_rm_field_name_idx ON dbo.dr20_bhm_rm_v1_3  (rm_field_name);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_rm_known_spec_idx ON dbo.dr20_bhm_rm_v1_3  (rm_known_spec);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_rm_unsuitable_idx ON dbo.dr20_bhm_rm_v1_3  (rm_unsuitable);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_rm_var_idx ON dbo.dr20_bhm_rm_v1_3  (rm_var);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_3_rm_xrayqso_idx ON dbo.dr20_bhm_rm_v1_3  (rm_xrayqso);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_catalogidv05_idx ON dbo.dr20_bhm_rm_v1  (catalogidv05);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_gaia_dr2_source_id_idx ON dbo.dr20_bhm_rm_v1  (gaia_dr2_source_id);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_gaia_dr3_source_id_idx ON dbo.dr20_bhm_rm_v1  (gaia_dr3_source_id);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_gaia_g_idx ON dbo.dr20_bhm_rm_v1  (gaia_g);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_ls_id_dr10_idx ON dbo.dr20_bhm_rm_v1  (ls_id_dr10);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_ls_id_dr8_idx ON dbo.dr20_bhm_rm_v1  (ls_id_dr8);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_mag_g_idx ON dbo.dr20_bhm_rm_v1  (mag_g);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_mag_i_idx ON dbo.dr20_bhm_rm_v1  (mag_i);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_mag_r_idx ON dbo.dr20_bhm_rm_v1  (mag_r);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_panstarrs1_catid_objid_idx ON dbo.dr20_bhm_rm_v1  (panstarrs1_catid_objid);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_rm_ancillary_idx ON dbo.dr20_bhm_rm_v1  (rm_ancillary);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_rm_core_idx ON dbo.dr20_bhm_rm_v1  (rm_core);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_rm_field_name_idx ON dbo.dr20_bhm_rm_v1  (rm_field_name);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_rm_known_spec_idx ON dbo.dr20_bhm_rm_v1  (rm_known_spec);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_rm_unsuitable_idx ON dbo.dr20_bhm_rm_v1  (rm_unsuitable);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_rm_var_idx ON dbo.dr20_bhm_rm_v1  (rm_var);


CREATE NONCLUSTERED INDEX dr20_bhm_rm_v1_rm_xrayqso_idx ON dbo.dr20_bhm_rm_v1  (rm_xrayqso);


CREATE NONCLUSTERED INDEX dr20_bhm_spiders_agn_superset_ero_flux_idx ON dbo.dr20_bhm_spiders_agn_superset  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_bhm_spiders_agn_superset_gaia_dr2_source_id_idx ON dbo.dr20_bhm_spiders_agn_superset  (gaia_dr2_source_id);


CREATE NONCLUSTERED INDEX dr20_bhm_spiders_agn_superset_ls_id_idx ON dbo.dr20_bhm_spiders_agn_superset  (ls_id);


CREATE NONCLUSTERED INDEX dr20_bhm_spiders_clusters_superset_ero_flux_idx ON dbo.dr20_bhm_spiders_clusters_superset  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_bhm_spiders_clusters_superset_gaia_dr2_source_id_idx ON dbo.dr20_bhm_spiders_clusters_superset  (gaia_dr2_source_id);


CREATE NONCLUSTERED INDEX dr20_bhm_spiders_clusters_superset_ls_id_idx ON dbo.dr20_bhm_spiders_clusters_superset  (ls_id);


CREATE NONCLUSTERED INDEX dr20_cadence_epoch_cadence_pk_idx ON dbo.dr20_cadence_epoch  (cadence_pk);


CREATE NONCLUSTERED INDEX dr20_cadence_epoch_label_idx ON dbo.dr20_cadence_epoch  (label);


CREATE NONCLUSTERED INDEX dr20_carton_csv_carton_idx ON dbo.dr20_carton_csv  (carton);


CREATE NONCLUSTERED INDEX dr20_carton_csv_carton_pk_idx ON dbo.dr20_carton_csv  (carton_pk);


CREATE NONCLUSTERED INDEX dr20_carton_csv_version_pk_idx ON dbo.dr20_carton_csv  (version_pk);


CREATE NONCLUSTERED INDEX dr20_carton_to_target_cadence_pk_idx ON dbo.dr20_carton_to_target  (cadence_pk);


CREATE NONCLUSTERED INDEX dr20_carton_to_target_carton_pk_idx ON dbo.dr20_carton_to_target  (carton_pk);


CREATE NONCLUSTERED INDEX dr20_carton_to_target_instrument_pk_idx ON dbo.dr20_carton_to_target  (instrument_pk);


CREATE NONCLUSTERED INDEX dr20_carton_to_target_target_pk_idx ON dbo.dr20_carton_to_target  (target_pk);


CREATE NONCLUSTERED INDEX dr20_cataclysmic_variables_source_id_idx ON dbo.dr20_cataclysmic_variables  (source_id);


CREATE NONCLUSTERED INDEX dr20_catalog_from_sdss_dr19p_speclite_best_idx ON dbo.dr20_catalog_from_sdss_dr19p_speclite  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_from_sdss_dr19p_speclite_catalogid_idx ON dbo.dr20_catalog_from_sdss_dr19p_speclite  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_from_sdss_dr19p_speclite_target_id_idx ON dbo.dr20_catalog_from_sdss_dr19p_speclite  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_from_sdss_dr19p_speclite_version_id_idx ON dbo.dr20_catalog_from_sdss_dr19p_speclite  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allstar_dr17_synspec_rev1_catalogid_idx ON dbo.dr20_catalog_to_allstar_dr17_synspec_rev1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allstar_dr17_synspec_rev1_target_id_idx ON dbo.dr20_catalog_to_allstar_dr17_synspec_rev1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allstar_dr17_synspec_rev1_version_id_idx ON dbo.dr20_catalog_to_allstar_dr17_synspec_rev1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_best_idx ON dbo.dr20_catalog_to_allwise  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_best_idx1 ON dbo.dr20_catalog_to_allwise  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_catalogid_idx ON dbo.dr20_catalog_to_allwise  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_catalogid_idx1 ON dbo.dr20_catalog_to_allwise  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_target_id_idx ON dbo.dr20_catalog_to_allwise  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_target_id_idx1 ON dbo.dr20_catalog_to_allwise  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_version_id_idx ON dbo.dr20_catalog_to_allwise  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_version_id_idx1 ON dbo.dr20_catalog_to_allwise  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_allwise_version_id_target_id_best_idx ON dbo.dr20_catalog_to_allwise  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_best_idx ON dbo.dr20_catalog_to_bhm_csc  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_best_idx1 ON dbo.dr20_catalog_to_bhm_csc  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_catalogid_idx ON dbo.dr20_catalog_to_bhm_csc  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_catalogid_idx1 ON dbo.dr20_catalog_to_bhm_csc  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_target_id_idx ON dbo.dr20_catalog_to_bhm_csc  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_target_id_idx1 ON dbo.dr20_catalog_to_bhm_csc  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_version_id_idx ON dbo.dr20_catalog_to_bhm_csc  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_version_id_idx1 ON dbo.dr20_catalog_to_bhm_csc  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_csc_version_id_target_id_best_idx ON dbo.dr20_catalog_to_bhm_csc  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_efeds_veto_best_idx ON dbo.dr20_catalog_to_bhm_efeds_veto  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_efeds_veto_catalogid_idx ON dbo.dr20_catalog_to_bhm_efeds_veto  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_efeds_veto_target_id_idx ON dbo.dr20_catalog_to_bhm_efeds_veto  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_efeds_veto_version_id_idx ON dbo.dr20_catalog_to_bhm_efeds_veto  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_efeds_veto_version_id_target_id_best_idx ON dbo.dr20_catalog_to_bhm_efeds_veto  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_best_idx ON dbo.dr20_catalog_to_bhm_rm_v0_2  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_best_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0_2  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_catalogid_idx ON dbo.dr20_catalog_to_bhm_rm_v0_2  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_catalogid_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0_2  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_target_id_idx ON dbo.dr20_catalog_to_bhm_rm_v0_2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_target_id_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0_2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_version_id_idx ON dbo.dr20_catalog_to_bhm_rm_v0_2  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_version_id_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0_2  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_2_version_id_target_id_best_idx ON dbo.dr20_catalog_to_bhm_rm_v0_2  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_best_idx ON dbo.dr20_catalog_to_bhm_rm_v0  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_best_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_catalogid_idx ON dbo.dr20_catalog_to_bhm_rm_v0  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_catalogid_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_target_id_idx ON dbo.dr20_catalog_to_bhm_rm_v0  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_target_id_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_version_id_idx ON dbo.dr20_catalog_to_bhm_rm_v0  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_version_id_idx1 ON dbo.dr20_catalog_to_bhm_rm_v0  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_bhm_rm_v0_version_id_target_id_best_idx ON dbo.dr20_catalog_to_bhm_rm_v0  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_best_idx ON dbo.dr20_catalog_to_catwise2020  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_best_idx1 ON dbo.dr20_catalog_to_catwise2020  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_catalogid_idx ON dbo.dr20_catalog_to_catwise2020  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_catalogid_idx1 ON dbo.dr20_catalog_to_catwise2020  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_target_id_idx ON dbo.dr20_catalog_to_catwise2020  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_target_id_idx1 ON dbo.dr20_catalog_to_catwise2020  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_version_id_idx ON dbo.dr20_catalog_to_catwise2020  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_version_id_idx1 ON dbo.dr20_catalog_to_catwise2020  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_catwise2020_version_id_target_id_best_idx ON dbo.dr20_catalog_to_catwise2020  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_best_idx1 ON dbo.dr20_catalog_to_gaia_dr2_source  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_catalogid_idx1 ON dbo.dr20_catalog_to_gaia_dr2_source  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_part1_target_id_idx ON dbo.dr20_catalog_to_gaia_dr2_source_part1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_part2_target_id_idx ON dbo.dr20_catalog_to_gaia_dr2_source_part2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_target_id_idx1 ON dbo.dr20_catalog_to_gaia_dr2_source  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr2_source_version_id_idx1 ON dbo.dr20_catalog_to_gaia_dr2_source  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_best_idx ON dbo.dr20_catalog_to_gaia_dr3_source  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_best_idx1 ON dbo.dr20_catalog_to_gaia_dr3_source  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_catalogid_idx ON dbo.dr20_catalog_to_gaia_dr3_source  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_catalogid_idx1 ON dbo.dr20_catalog_to_gaia_dr3_source  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_target_id_idx ON dbo.dr20_catalog_to_gaia_dr3_source  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_target_id_idx1 ON dbo.dr20_catalog_to_gaia_dr3_source  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_version_id_idx ON dbo.dr20_catalog_to_gaia_dr3_source  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_version_id_idx1 ON dbo.dr20_catalog_to_gaia_dr3_source  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_gaia_dr3_source_version_id_target_id_best_idx ON dbo.dr20_catalog_to_gaia_dr3_source  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_best_idx ON dbo.dr20_catalog_to_glimpse  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_best_idx1 ON dbo.dr20_catalog_to_glimpse  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_catalogid_idx ON dbo.dr20_catalog_to_glimpse  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_catalogid_idx1 ON dbo.dr20_catalog_to_glimpse  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_target_id_idx ON dbo.dr20_catalog_to_glimpse  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_target_id_idx1 ON dbo.dr20_catalog_to_glimpse  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_version_id_idx ON dbo.dr20_catalog_to_glimpse  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_version_id_idx1 ON dbo.dr20_catalog_to_glimpse  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_glimpse_version_id_target_id_best_idx ON dbo.dr20_catalog_to_glimpse  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_best_idx ON dbo.dr20_catalog_to_guvcat  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_best_idx1 ON dbo.dr20_catalog_to_guvcat  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_catalogid_idx ON dbo.dr20_catalog_to_guvcat  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_catalogid_idx1 ON dbo.dr20_catalog_to_guvcat  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_target_id_idx ON dbo.dr20_catalog_to_guvcat  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_target_id_idx1 ON dbo.dr20_catalog_to_guvcat  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_version_id_idx ON dbo.dr20_catalog_to_guvcat  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_version_id_idx1 ON dbo.dr20_catalog_to_guvcat  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_guvcat_version_id_target_id_best_idx ON dbo.dr20_catalog_to_guvcat  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_best_idx ON dbo.dr20_catalog_to_legacy_survey_dr10  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_best_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr10  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_catalogid_idx ON dbo.dr20_catalog_to_legacy_survey_dr10  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_catalogid_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr10  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_target_id_idx ON dbo.dr20_catalog_to_legacy_survey_dr10  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_target_id_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr10  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_version_id_idx ON dbo.dr20_catalog_to_legacy_survey_dr10  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr10_version_id_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr10  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr1_version_id_target_id_best_idx ON dbo.dr20_catalog_to_legacy_survey_dr10  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_best_idx ON dbo.dr20_catalog_to_legacy_survey_dr8  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_best_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr8  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_catalogid_idx ON dbo.dr20_catalog_to_legacy_survey_dr8  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_catalogid_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr8  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_target_id_idx ON dbo.dr20_catalog_to_legacy_survey_dr8  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_target_id_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr8  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_version_id_idx ON dbo.dr20_catalog_to_legacy_survey_dr8  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_version_id_idx1 ON dbo.dr20_catalog_to_legacy_survey_dr8  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_legacy_survey_dr8_version_id_target_id_best_idx ON dbo.dr20_catalog_to_legacy_survey_dr8  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_mangatarget_catalogid_idx ON dbo.dr20_catalog_to_mangatarget  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_mangatarget_target_id_idx ON dbo.dr20_catalog_to_mangatarget  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_mangatarget_version_id_idx ON dbo.dr20_catalog_to_mangatarget  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_marvels_dr11_star_catalogid_idx ON dbo.dr20_catalog_to_marvels_dr11_star  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_marvels_dr11_star_target_id_idx ON dbo.dr20_catalog_to_marvels_dr11_star  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_marvels_dr11_star_version_id_idx ON dbo.dr20_catalog_to_marvels_dr11_star  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_marvels_dr12_star_catalogid_idx ON dbo.dr20_catalog_to_marvels_dr12_star  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_marvels_dr12_star_target_id_idx ON dbo.dr20_catalog_to_marvels_dr12_star  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_marvels_dr12_star_version_id_idx ON dbo.dr20_catalog_to_marvels_dr12_star  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_mastar_goodstars_catalogid_idx ON dbo.dr20_catalog_to_mastar_goodstars  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_mastar_goodstars_target_id_idx ON dbo.dr20_catalog_to_mastar_goodstars  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_mastar_goodstars_version_id_idx ON dbo.dr20_catalog_to_mastar_goodstars  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_best_idx ON dbo.dr20_catalog_to_milliquas_7_7  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_best_idx1 ON dbo.dr20_catalog_to_milliquas_7_7  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_catalogid_idx ON dbo.dr20_catalog_to_milliquas_7_7  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_catalogid_idx1 ON dbo.dr20_catalog_to_milliquas_7_7  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_target_id_idx ON dbo.dr20_catalog_to_milliquas_7_7  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_target_id_idx1 ON dbo.dr20_catalog_to_milliquas_7_7  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_version_id_idx ON dbo.dr20_catalog_to_milliquas_7_7  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_version_id_idx1 ON dbo.dr20_catalog_to_milliquas_7_7  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_milliquas_7_7_version_id_target_id_best_idx ON dbo.dr20_catalog_to_milliquas_7_7  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_best_idx ON dbo.dr20_catalog_to_panstarrs1  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_best_idx1 ON dbo.dr20_catalog_to_panstarrs1  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_catalogid_idx ON dbo.dr20_catalog_to_panstarrs1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_catalogid_idx1 ON dbo.dr20_catalog_to_panstarrs1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_target_id_idx ON dbo.dr20_catalog_to_panstarrs1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_target_id_idx1 ON dbo.dr20_catalog_to_panstarrs1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_version_id_idx ON dbo.dr20_catalog_to_panstarrs1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_version_id_idx1 ON dbo.dr20_catalog_to_panstarrs1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_panstarrs1_version_id_target_id_best_idx ON dbo.dr20_catalog_to_panstarrs1  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoob_version_id_target_id_best_idx ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_best_idx ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_best_idx1 ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_catalogid_idx ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_catalogid_idx1 ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_target_id_idx ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_target_id_idx1 ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_version_id_idx ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr13_photoobj_primary_version_id_idx1 ON dbo.dr20_catalog_to_sdss_dr13_photoobj_primary  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_best_idx ON dbo.dr20_catalog_to_sdss_dr16_specobj  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_best_idx1 ON dbo.dr20_catalog_to_sdss_dr16_specobj  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_catalogid_idx ON dbo.dr20_catalog_to_sdss_dr16_specobj  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_catalogid_idx1 ON dbo.dr20_catalog_to_sdss_dr16_specobj  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_target_id_idx ON dbo.dr20_catalog_to_sdss_dr16_specobj  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_target_id_idx1 ON dbo.dr20_catalog_to_sdss_dr16_specobj  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_version_id_idx ON dbo.dr20_catalog_to_sdss_dr16_specobj  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_version_id_idx1 ON dbo.dr20_catalog_to_sdss_dr16_specobj  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr16_specobj_version_id_target_id_best_idx ON dbo.dr20_catalog_to_sdss_dr16_specobj  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr17_specobj_catalogid_idx ON dbo.dr20_catalog_to_sdss_dr17_specobj  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr17_specobj_target_id_idx ON dbo.dr20_catalog_to_sdss_dr17_specobj  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_sdss_dr17_specobj_version_id_idx ON dbo.dr20_catalog_to_sdss_dr17_specobj  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_best_idx ON dbo.dr20_catalog_to_skies_v1  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_best_idx1 ON dbo.dr20_catalog_to_skies_v1  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_catalogid_idx ON dbo.dr20_catalog_to_skies_v1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_catalogid_idx1 ON dbo.dr20_catalog_to_skies_v1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_target_id_idx ON dbo.dr20_catalog_to_skies_v1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_target_id_idx1 ON dbo.dr20_catalog_to_skies_v1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_version_id_idx ON dbo.dr20_catalog_to_skies_v1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_version_id_idx1 ON dbo.dr20_catalog_to_skies_v1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v1_version_id_target_id_best_idx ON dbo.dr20_catalog_to_skies_v1  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_best_idx ON dbo.dr20_catalog_to_skies_v2  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_best_idx1 ON dbo.dr20_catalog_to_skies_v2  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_catalogid_idx ON dbo.dr20_catalog_to_skies_v2  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_catalogid_idx1 ON dbo.dr20_catalog_to_skies_v2  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_target_id_idx ON dbo.dr20_catalog_to_skies_v2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_target_id_idx1 ON dbo.dr20_catalog_to_skies_v2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_version_id_idx ON dbo.dr20_catalog_to_skies_v2  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_version_id_idx1 ON dbo.dr20_catalog_to_skies_v2  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skies_v2_version_id_target_id_best_idx ON dbo.dr20_catalog_to_skies_v2  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_best_idx ON dbo.dr20_catalog_to_skymapper_dr2  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_best_idx1 ON dbo.dr20_catalog_to_skymapper_dr2  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_catalogid_idx ON dbo.dr20_catalog_to_skymapper_dr2  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_catalogid_idx1 ON dbo.dr20_catalog_to_skymapper_dr2  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_target_id_idx ON dbo.dr20_catalog_to_skymapper_dr2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_target_id_idx1 ON dbo.dr20_catalog_to_skymapper_dr2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_version_id_idx ON dbo.dr20_catalog_to_skymapper_dr2  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_version_id_idx1 ON dbo.dr20_catalog_to_skymapper_dr2  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_skymapper_dr2_version_id_target_id_best_idx ON dbo.dr20_catalog_to_skymapper_dr2  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_best_idx ON dbo.dr20_catalog_to_supercosmos  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_best_idx1 ON dbo.dr20_catalog_to_supercosmos  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_catalogid_idx ON dbo.dr20_catalog_to_supercosmos  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_catalogid_idx1 ON dbo.dr20_catalog_to_supercosmos  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_target_id_idx ON dbo.dr20_catalog_to_supercosmos  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_target_id_idx1 ON dbo.dr20_catalog_to_supercosmos  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_version_id_idx ON dbo.dr20_catalog_to_supercosmos  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_version_id_idx1 ON dbo.dr20_catalog_to_supercosmos  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_supercosmos_version_id_target_id_best_idx ON dbo.dr20_catalog_to_supercosmos  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_best_idx ON dbo.dr20_catalog_to_tic_v8  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_best_idx1 ON dbo.dr20_catalog_to_tic_v8  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_catalogid_idx ON dbo.dr20_catalog_to_tic_v8  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_catalogid_idx1 ON dbo.dr20_catalog_to_tic_v8  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_target_id_idx ON dbo.dr20_catalog_to_tic_v8  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_target_id_idx1 ON dbo.dr20_catalog_to_tic_v8  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_version_id_idx ON dbo.dr20_catalog_to_tic_v8  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_version_id_idx1 ON dbo.dr20_catalog_to_tic_v8  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tic_v8_version_id_target_id_best_idx ON dbo.dr20_catalog_to_tic_v8  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_best_idx1 ON dbo.dr20_catalog_to_twomass_psc  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_catalogid_idx1 ON dbo.dr20_catalog_to_twomass_psc  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_part1_target_id_idx ON dbo.dr20_catalog_to_twomass_psc_part1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_part2_target_id_idx ON dbo.dr20_catalog_to_twomass_psc_part2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_target_id_idx1 ON dbo.dr20_catalog_to_twomass_psc  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_twomass_psc_version_id_idx1 ON dbo.dr20_catalog_to_twomass_psc  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_best_idx ON dbo.dr20_catalog_to_tycho2  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_best_idx1 ON dbo.dr20_catalog_to_tycho2  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_catalogid_idx ON dbo.dr20_catalog_to_tycho2  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_catalogid_idx1 ON dbo.dr20_catalog_to_tycho2  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_target_id_idx ON dbo.dr20_catalog_to_tycho2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_target_id_idx1 ON dbo.dr20_catalog_to_tycho2  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_version_id_idx ON dbo.dr20_catalog_to_tycho2  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_version_id_idx1 ON dbo.dr20_catalog_to_tycho2  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_tycho2_version_id_target_id_best_idx ON dbo.dr20_catalog_to_tycho2  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_best_idx ON dbo.dr20_catalog_to_unwise  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_best_idx1 ON dbo.dr20_catalog_to_unwise  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_catalogid_idx ON dbo.dr20_catalog_to_unwise  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_catalogid_idx1 ON dbo.dr20_catalog_to_unwise  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_target_id_idx ON dbo.dr20_catalog_to_unwise  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_target_id_idx1 ON dbo.dr20_catalog_to_unwise  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_version_id_idx ON dbo.dr20_catalog_to_unwise  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_version_id_idx1 ON dbo.dr20_catalog_to_unwise  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_unwise_version_id_target_id_best_idx ON dbo.dr20_catalog_to_unwise  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_best_idx ON dbo.dr20_catalog_to_uvotssc1  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_best_idx1 ON dbo.dr20_catalog_to_uvotssc1  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_catalogid_idx ON dbo.dr20_catalog_to_uvotssc1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_catalogid_idx1 ON dbo.dr20_catalog_to_uvotssc1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_target_id_idx ON dbo.dr20_catalog_to_uvotssc1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_target_id_idx1 ON dbo.dr20_catalog_to_uvotssc1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_version_id_idx ON dbo.dr20_catalog_to_uvotssc1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_version_id_idx1 ON dbo.dr20_catalog_to_uvotssc1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_uvotssc1_version_id_target_id_best_idx ON dbo.dr20_catalog_to_uvotssc1  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_best_idx ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_best_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_catalogid_idx ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_catalogid_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_target_id_idx ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_target_id_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_version_id_idx ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_version_id_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_4_1_version_id_target_id_best_idx ON dbo.dr20_catalog_to_xmm_om_suss_4_1  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_best_idx ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_best_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (best);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_catalogid_idx ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_catalogid_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (catalogid);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_target_id_idx ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_target_id_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (target_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_version_id_idx ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_version_id_idx1 ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (version_id);


CREATE NONCLUSTERED INDEX dr20_catalog_to_xmm_om_suss_5_0_version_id_target_id_best_idx ON dbo.dr20_catalog_to_xmm_om_suss_5_0  (version_id, target_id, best);


CREATE NONCLUSTERED INDEX dr20_catalog_version_id_idx ON dbo.dr20_catalog  (version_id);


CREATE NONCLUSTERED INDEX dr20_catwise2020_source_name_idx ON dbo.dr20_catwise2020  (source_name);


CREATE NONCLUSTERED INDEX dr20_catwise2020_w1mpro_idx ON dbo.dr20_catwise2020  (w1mpro);


CREATE NONCLUSTERED INDEX dr20_catwise2020_w1sigmpro_idx ON dbo.dr20_catwise2020  (w1sigmpro);


CREATE NONCLUSTERED INDEX dr20_catwise2020_w2mpro_idx ON dbo.dr20_catwise2020  (w2mpro);


CREATE NONCLUSTERED INDEX dr20_catwise2020_w2sigmpro_idx ON dbo.dr20_catwise2020  (w2sigmpro);


CREATE NONCLUSTERED INDEX dr20_design_assignment_hash_idx ON dbo.dr20_design  (assignment_hash);


CREATE NONCLUSTERED INDEX dr20_design_to_field_design_id_idx ON dbo.dr20_design_to_field  (design_id);


CREATE NONCLUSTERED INDEX dr20_design_to_field_field_pk_idx ON dbo.dr20_design_to_field  (field_pk);


CREATE NONCLUSTERED INDEX dr20_ebosstarget_v5_eboss_target1_idx ON dbo.dr20_ebosstarget_v5  (eboss_target1);


CREATE NONCLUSTERED INDEX dr20_ebosstarget_v5_objc_type_idx ON dbo.dr20_ebosstarget_v5  (objc_type);


CREATE NONCLUSTERED INDEX dr20_ebosstarget_v5_objid_targeting_idx ON dbo.dr20_ebosstarget_v5  (objid_targeting);


CREATE NONCLUSTERED INDEX dr20_ebosstarget_v5_resolve_status_idx ON dbo.dr20_ebosstarget_v5  (resolve_status);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_agn_catwise2020_id_idx ON dbo.dr20_erosita_superset_agn  (catwise2020_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_agn_ero_det_like_idx ON dbo.dr20_erosita_superset_agn  (ero_det_like);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_agn_ero_detuid_idx ON dbo.dr20_erosita_superset_agn  (ero_detuid);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_agn_ero_flux_idx ON dbo.dr20_erosita_superset_agn  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_agn_ero_version_idx ON dbo.dr20_erosita_superset_agn  (ero_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_agn_gaia_dr2_id_idx ON dbo.dr20_erosita_superset_agn  (gaia_dr2_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_agn_ls_id_idx ON dbo.dr20_erosita_superset_agn  (ls_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_clusters_catwise2020_id_idx ON dbo.dr20_erosita_superset_clusters  (catwise2020_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_clusters_ero_det_like_idx ON dbo.dr20_erosita_superset_clusters  (ero_det_like);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_clusters_ero_detuid_idx ON dbo.dr20_erosita_superset_clusters  (ero_detuid);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_clusters_ero_flux_idx ON dbo.dr20_erosita_superset_clusters  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_clusters_ero_version_idx ON dbo.dr20_erosita_superset_clusters  (ero_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_clusters_gaia_dr2_id_idx ON dbo.dr20_erosita_superset_clusters  (gaia_dr2_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_clusters_ls_id_idx ON dbo.dr20_erosita_superset_clusters  (ls_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_compactobjects_catwise2020_id_idx ON dbo.dr20_erosita_superset_compactobjects  (catwise2020_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_compactobjects_ero_det_like_idx ON dbo.dr20_erosita_superset_compactobjects  (ero_det_like);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_compactobjects_ero_detuid_idx ON dbo.dr20_erosita_superset_compactobjects  (ero_detuid);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_compactobjects_ero_flux_idx ON dbo.dr20_erosita_superset_compactobjects  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_compactobjects_ero_version_idx ON dbo.dr20_erosita_superset_compactobjects  (ero_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_compactobjects_gaia_dr2_id_idx ON dbo.dr20_erosita_superset_compactobjects  (gaia_dr2_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_compactobjects_ls_id_idx ON dbo.dr20_erosita_superset_compactobjects  (ls_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_stars_catwise2020_id_idx ON dbo.dr20_erosita_superset_stars  (catwise2020_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_stars_ero_det_like_idx ON dbo.dr20_erosita_superset_stars  (ero_det_like);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_stars_ero_detuid_idx ON dbo.dr20_erosita_superset_stars  (ero_detuid);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_stars_ero_flux_idx ON dbo.dr20_erosita_superset_stars  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_stars_ero_version_idx ON dbo.dr20_erosita_superset_stars  (ero_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_stars_gaia_dr2_id_idx ON dbo.dr20_erosita_superset_stars  (gaia_dr2_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_stars_ls_id_idx ON dbo.dr20_erosita_superset_stars  (ls_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_ero_det_like_idx ON dbo.dr20_erosita_superset_v1_agn  (ero_det_like);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_ero_detuid_idx ON dbo.dr20_erosita_superset_v1_agn  (ero_detuid);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_ero_flags_idx ON dbo.dr20_erosita_superset_v1_agn  (ero_flags);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_ero_flux_idx ON dbo.dr20_erosita_superset_v1_agn  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_ero_morph_idx ON dbo.dr20_erosita_superset_v1_agn  (ero_morph);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_ero_version_idx ON dbo.dr20_erosita_superset_v1_agn  (ero_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_gaia_dr3_source_id_idx ON dbo.dr20_erosita_superset_v1_agn  (gaia_dr3_source_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_ls_id_idx ON dbo.dr20_erosita_superset_v1_agn  (ls_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_opt_cat_idx ON dbo.dr20_erosita_superset_v1_agn  (opt_cat);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_xmatch_flags_idx ON dbo.dr20_erosita_superset_v1_agn  (xmatch_flags);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_xmatch_metric_idx ON dbo.dr20_erosita_superset_v1_agn  (xmatch_metric);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_agn_xmatch_version_idx ON dbo.dr20_erosita_superset_v1_agn  (xmatch_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_ero_det_like_idx ON dbo.dr20_erosita_superset_v1_clusters  (ero_det_like);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_ero_detuid_idx ON dbo.dr20_erosita_superset_v1_clusters  (ero_detuid);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_ero_flags_idx ON dbo.dr20_erosita_superset_v1_clusters  (ero_flags);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_ero_flux_idx ON dbo.dr20_erosita_superset_v1_clusters  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_ero_version_idx ON dbo.dr20_erosita_superset_v1_clusters  (ero_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_eromapper_lambda_idx ON dbo.dr20_erosita_superset_v1_clusters  (eromapper_lambda);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_eromapper_z_lambda_idx ON dbo.dr20_erosita_superset_v1_clusters  (eromapper_z_lambda);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_gaia_dr3_source_id_idx ON dbo.dr20_erosita_superset_v1_clusters  (gaia_dr3_source_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_ls_id_idx ON dbo.dr20_erosita_superset_v1_clusters  (ls_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_opt_cat_idx ON dbo.dr20_erosita_superset_v1_clusters  (opt_cat);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_target_priority_idx ON dbo.dr20_erosita_superset_v1_clusters  (target_priority);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_xmatch_metric_idx ON dbo.dr20_erosita_superset_v1_clusters  (xmatch_metric);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_clusters_xmatch_version_idx ON dbo.dr20_erosita_superset_v1_clusters  (xmatch_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_ero_det_like_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_det_like);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_ero_detuid_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_detuid);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_ero_flags_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_flags);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_ero_flux_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_ero_version_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (ero_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_gaia_dr3_source_id_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (gaia_dr3_source_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_ls_id_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (ls_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_opt_cat_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (opt_cat);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_compactobjects_xmatch_metric_idx ON dbo.dr20_erosita_superset_v1_compactobjects  (xmatch_metric);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_ero_det_like_idx ON dbo.dr20_erosita_superset_v1_stars  (ero_det_like);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_ero_detuid_idx ON dbo.dr20_erosita_superset_v1_stars  (ero_detuid);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_ero_flags_idx ON dbo.dr20_erosita_superset_v1_stars  (ero_flags);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_ero_flux_idx ON dbo.dr20_erosita_superset_v1_stars  (ero_flux);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_ero_version_idx ON dbo.dr20_erosita_superset_v1_stars  (ero_version);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_gaia_dr3_source_id_idx ON dbo.dr20_erosita_superset_v1_stars  (gaia_dr3_source_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_ls_id_idx ON dbo.dr20_erosita_superset_v1_stars  (ls_id);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_opt_cat_idx ON dbo.dr20_erosita_superset_v1_stars  (opt_cat);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_xmatch_metric_idx ON dbo.dr20_erosita_superset_v1_stars  (xmatch_metric);


CREATE NONCLUSTERED INDEX dr20_erosita_superset_v1_stars_xmatch_version_idx ON dbo.dr20_erosita_superset_v1_stars  (xmatch_version);


CREATE NONCLUSTERED INDEX dr20_field_cadence_pk_idx ON dbo.dr20_field  (cadence_pk);


CREATE NONCLUSTERED INDEX dr20_field_field_id_idx ON dbo.dr20_field  (field_id);


CREATE NONCLUSTERED INDEX dr20_field_observatory_pk_idx ON dbo.dr20_field  (observatory_pk);


CREATE NONCLUSTERED INDEX dr20_gaia_assas_sn_cepheids_source_idx ON dbo.dr20_gaia_assas_sn_cepheids  (source);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_ruwe_ruwe_idx ON dbo.dr20_gaia_dr2_ruwe  (ruwe);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_source_astrometric_chi2_al_idx ON dbo.dr20_gaia_dr2_source  (astrometric_chi2_al);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_source_astrometric_excess_noise_idx ON dbo.dr20_gaia_dr2_source  (astrometric_excess_noise);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_source_bp_rp_idx ON dbo.dr20_gaia_dr2_source  (bp_rp);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_source_expr_idx ON dbo.dr20_gaia_dr2_source  (((parallax - parallax_error)));


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_source_parallax_idx ON dbo.dr20_gaia_dr2_source  (parallax);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_source_phot_bp_mean_flux_over_error_idx ON dbo.dr20_gaia_dr2_source  (phot_bp_mean_flux_over_error);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_source_phot_bp_mean_mag_idx ON dbo.dr20_gaia_dr2_source  (phot_bp_mean_mag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_source_phot_rp_mean_mag_idx ON dbo.dr20_gaia_dr2_source  (phot_rp_mean_mag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_wd_gmag_idx ON dbo.dr20_gaia_dr2_wd  (gmag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr2_wd_pwd_idx ON dbo.dr20_gaia_dr2_wd  (pwd);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_paramet_vsini_esphs_uncertainty_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (vsini_esphs_uncertainty);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_paramete_logg_esphs_uncertainty_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (logg_esphs_uncertainty);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_paramete_teff_esphs_uncertainty_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (teff_esphs_uncertainty);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_parameters_logg_esphs_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (logg_esphs);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_parameters_logg_gspphot_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (logg_gspphot);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_parameters_mh_gspphot_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (mh_gspphot);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_parameters_teff_esphs_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (teff_esphs);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_parameters_teff_gspphot_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (teff_gspphot);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_astrophysical_parameters_vsini_esphs_idx ON dbo.dr20_gaia_dr3_astrophysical_parameters  (vsini_esphs);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_nss_two_body_orbit_period_idx ON dbo.dr20_gaia_dr3_nss_two_body_orbit  (period);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_nss_two_body_orbit_source_id_idx ON dbo.dr20_gaia_dr3_nss_two_body_orbit  (source_id);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_astrometric_chi2_al_idx ON dbo.dr20_gaia_dr3_source  (astrometric_chi2_al);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_astrometric_excess_noise_idx ON dbo.dr20_gaia_dr3_source  (astrometric_excess_noise);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_bp_g_idx ON dbo.dr20_gaia_dr3_source  (bp_g);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_bp_rp_idx ON dbo.dr20_gaia_dr3_source  (bp_rp);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_g_rp_idx ON dbo.dr20_gaia_dr3_source  (g_rp);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_parallax_idx ON dbo.dr20_gaia_dr3_source  (parallax);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_parallax_over_error_idx ON dbo.dr20_gaia_dr3_source  (parallax_over_error);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_bp_mean_flux_idx ON dbo.dr20_gaia_dr3_source  (phot_bp_mean_flux);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_bp_mean_flux_over_error_idx ON dbo.dr20_gaia_dr3_source  (phot_bp_mean_flux_over_error);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_bp_mean_mag_idx ON dbo.dr20_gaia_dr3_source  (phot_bp_mean_mag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_g_mean_flux_idx ON dbo.dr20_gaia_dr3_source  (phot_g_mean_flux);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_g_mean_flux_over_error_idx ON dbo.dr20_gaia_dr3_source  (phot_g_mean_flux_over_error);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_g_mean_mag_idx ON dbo.dr20_gaia_dr3_source  (phot_g_mean_mag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_rp_mean_flux_idx ON dbo.dr20_gaia_dr3_source  (phot_rp_mean_flux);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_rp_mean_flux_over_error_idx ON dbo.dr20_gaia_dr3_source  (phot_rp_mean_flux_over_error);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_phot_rp_mean_mag_idx ON dbo.dr20_gaia_dr3_source  (phot_rp_mean_mag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_ruwe_idx ON dbo.dr20_gaia_dr3_source  (ruwe);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_source_solution_id_idx ON dbo.dr20_gaia_dr3_source  (solution_id);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_synthetic_photometry_gspc_g_sdss_flag_idx ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (g_sdss_flag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_synthetic_photometry_gspc_g_sdss_mag_idx ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (g_sdss_mag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_synthetic_photometry_gspc_i_sdss_flag_idx ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (i_sdss_flag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_synthetic_photometry_gspc_i_sdss_mag_idx ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (i_sdss_mag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_synthetic_photometry_gspc_r_sdss_flag_idx ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (r_sdss_flag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_synthetic_photometry_gspc_r_sdss_mag_idx ON dbo.dr20_gaia_dr3_synthetic_photometry_gspc  (r_sdss_mag);


CREATE NONCLUSTERED INDEX dr20_gaia_dr3_vari_rrlyrae_solution_id_idx ON dbo.dr20_gaia_dr3_vari_rrlyrae  (solution_id);


CREATE NONCLUSTERED INDEX dr20_gaia_unwise_agn_g_idx ON dbo.dr20_gaia_unwise_agn  (g);


CREATE NONCLUSTERED INDEX dr20_gaia_unwise_agn_prob_rf_idx ON dbo.dr20_gaia_unwise_agn  (prob_rf);


CREATE NONCLUSTERED INDEX dr20_gaia_unwise_agn_unwise_objid_idx ON dbo.dr20_gaia_unwise_agn  (unwise_objid);


CREATE NONCLUSTERED INDEX dr20_gaiadr2_tmass_best_neighbour_angular_distance_idx ON dbo.dr20_gaiadr2_tmass_best_neighbour  (angular_distance);


CREATE NONCLUSTERED INDEX dr20_gaiadr2_tmass_best_neighbour_source_id_idx ON dbo.dr20_gaiadr2_tmass_best_neighbour  (source_id);


CREATE NONCLUSTERED INDEX dr20_gaiadr2_tmass_best_neighbour_tmass_pts_key_idx ON dbo.dr20_gaiadr2_tmass_best_neighbour  (tmass_pts_key);


CREATE NONCLUSTERED INDEX dr20_galah_dr3_star_id_idx ON dbo.dr20_galah_dr3  (star_id);


CREATE NONCLUSTERED INDEX dr20_galex_gr7_gaia_dr3_fuv_mag_idx ON dbo.dr20_galex_gr7_gaia_dr3  (fuv_mag);


CREATE NONCLUSTERED INDEX dr20_galex_gr7_gaia_dr3_gaia_edr3_source_id_idx ON dbo.dr20_galex_gr7_gaia_dr3  (gaia_edr3_source_id);


CREATE NONCLUSTERED INDEX dr20_galex_gr7_gaia_dr3_galex_objid_idx ON dbo.dr20_galex_gr7_gaia_dr3  (galex_objid);


CREATE NONCLUSTERED INDEX dr20_galex_gr7_gaia_dr3_galex_separation_idx ON dbo.dr20_galex_gr7_gaia_dr3  (galex_separation);


CREATE NONCLUSTERED INDEX dr20_galex_gr7_gaia_dr3_nuv_mag_idx ON dbo.dr20_galex_gr7_gaia_dr3  (nuv_mag);


CREATE NONCLUSTERED INDEX dr20_galex_gr7_gaia_dr3_nuv_magerr_idx ON dbo.dr20_galex_gr7_gaia_dr3  (nuv_magerr);


CREATE NONCLUSTERED INDEX dr20_gedr3spur_main_fidelity_v1_idx ON dbo.dr20_gedr3spur_main  (fidelity_v1);


CREATE NONCLUSTERED INDEX dr20_gedr3spur_main_fidelity_v2_idx ON dbo.dr20_gedr3spur_main  (fidelity_v2);


CREATE NONCLUSTERED INDEX dr20_geometric_distances_gaia_dr2_r_est_idx ON dbo.dr20_geometric_distances_gaia_dr2  (r_est);


CREATE NONCLUSTERED INDEX dr20_geometric_distances_gaia_dr2_r_hi_idx ON dbo.dr20_geometric_distances_gaia_dr2  (r_hi);


CREATE NONCLUSTERED INDEX dr20_geometric_distances_gaia_dr2_r_len_idx ON dbo.dr20_geometric_distances_gaia_dr2  (r_len);


CREATE NONCLUSTERED INDEX dr20_geometric_distances_gaia_dr2_r_lo_idx ON dbo.dr20_geometric_distances_gaia_dr2  (r_lo);


CREATE NONCLUSTERED INDEX dr20_glimpse_designation_idx ON dbo.dr20_glimpse  (designation);


CREATE NONCLUSTERED INDEX dr20_glimpse_tmass_cntr_idx ON dbo.dr20_glimpse  (tmass_cntr);


CREATE NONCLUSTERED INDEX dr20_glimpse_tmass_designation_idx ON dbo.dr20_glimpse  (tmass_designation);


CREATE NONCLUSTERED INDEX dr20_guvcat_expr_idx ON dbo.dr20_guvcat  (((fuv_mag - nuv_mag)));


CREATE NONCLUSTERED INDEX dr20_guvcat_fuv_mag_idx ON dbo.dr20_guvcat  (fuv_mag);


CREATE NONCLUSTERED INDEX dr20_guvcat_nuv_mag_idx ON dbo.dr20_guvcat  (nuv_mag);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_f_astrom_idx ON dbo.dr20_hecate_1_1  (f_astrom);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_id_2mass_idx ON dbo.dr20_hecate_1_1  (id_2mass);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_id_iras_idx ON dbo.dr20_hecate_1_1  (id_iras);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_id_ned_idx ON dbo.dr20_hecate_1_1  (id_ned);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_id_nedd_idx ON dbo.dr20_hecate_1_1  (id_nedd);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_objname_idx ON dbo.dr20_hecate_1_1  (objname);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_pa_idx ON dbo.dr20_hecate_1_1  (pa);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_pgc_idx ON dbo.dr20_hecate_1_1  (pgc);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_r1_idx ON dbo.dr20_hecate_1_1  (r1);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_r2_idx ON dbo.dr20_hecate_1_1  (r2);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_rflag_idx ON dbo.dr20_hecate_1_1  (rflag);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_rsource_idx ON dbo.dr20_hecate_1_1  (rsource);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_sdss_photid_idx ON dbo.dr20_hecate_1_1  (sdss_photid);


CREATE NONCLUSTERED INDEX dr20_hecate_1_1_sdss_specid_idx ON dbo.dr20_hecate_1_1  (sdss_specid);


CREATE NONCLUSTERED INDEX dr20_hole_holeid_idx ON dbo.dr20_hole  (holeid);


CREATE NONCLUSTERED INDEX dr20_hole_observatory_pk_idx ON dbo.dr20_hole  (observatory_pk);


CREATE NONCLUSTERED INDEX dr20_lamost_dr6_obsid_idx ON dbo.dr20_lamost_dr6  (obsid);


CREATE NONCLUSTERED INDEX dr20_lamost_dr6_source_id_idx ON dbo.dr20_lamost_dr6  (source_id);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_ebv_idx ON dbo.dr20_legacy_survey_dr10  (ebv);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_fiberflux_g_idx ON dbo.dr20_legacy_survey_dr10  (fiberflux_g);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_fiberflux_i_idx ON dbo.dr20_legacy_survey_dr10  (fiberflux_i);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_fiberflux_r_idx ON dbo.dr20_legacy_survey_dr10  (fiberflux_r);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_fiberflux_z_idx ON dbo.dr20_legacy_survey_dr10  (fiberflux_z);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_flux_g_idx ON dbo.dr20_legacy_survey_dr10  (flux_g);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_flux_i_idx ON dbo.dr20_legacy_survey_dr10  (flux_i);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_flux_r_idx ON dbo.dr20_legacy_survey_dr10  (flux_r);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_flux_w1_idx ON dbo.dr20_legacy_survey_dr10  (flux_w1);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_flux_z_idx ON dbo.dr20_legacy_survey_dr10  (flux_z);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_gaia_dr2_source_id_idx ON dbo.dr20_legacy_survey_dr10  (gaia_dr2_source_id);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_gaia_dr3_source_id_idx ON dbo.dr20_legacy_survey_dr10  (gaia_dr3_source_id);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_gaia_phot_bp_mean_mag_idx ON dbo.dr20_legacy_survey_dr10  (gaia_phot_bp_mean_mag);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_gaia_phot_g_mean_mag_idx ON dbo.dr20_legacy_survey_dr10  (gaia_phot_g_mean_mag);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_gaia_phot_rp_mean_mag_idx ON dbo.dr20_legacy_survey_dr10  (gaia_phot_rp_mean_mag);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_maskbits_idx ON dbo.dr20_legacy_survey_dr10  (maskbits);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_nobs_g_idx ON dbo.dr20_legacy_survey_dr10  (nobs_g);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_nobs_i_idx ON dbo.dr20_legacy_survey_dr10  (nobs_i);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_nobs_r_idx ON dbo.dr20_legacy_survey_dr10  (nobs_r);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_nobs_z_idx ON dbo.dr20_legacy_survey_dr10  (nobs_z);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_parallax_idx ON dbo.dr20_legacy_survey_dr10  (parallax);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_ref_cat_idx ON dbo.dr20_legacy_survey_dr10  (ref_cat);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_ref_id_idx ON dbo.dr20_legacy_survey_dr10  (ref_id);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_shape_r_idx ON dbo.dr20_legacy_survey_dr10  (shape_r);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_shape_r_ivar_idx ON dbo.dr20_legacy_survey_dr10  (shape_r_ivar);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_survey_primary_idx ON dbo.dr20_legacy_survey_dr10  (survey_primary);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr10_type_idx ON dbo.dr20_legacy_survey_dr10  (type);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_fibertotflux_g_idx ON dbo.dr20_legacy_survey_dr8  (fibertotflux_g);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_fibertotflux_r_idx ON dbo.dr20_legacy_survey_dr8  (fibertotflux_r);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_fibertotflux_z_idx ON dbo.dr20_legacy_survey_dr8  (fibertotflux_z);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_flux_g_idx ON dbo.dr20_legacy_survey_dr8  (flux_g);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_flux_r_idx ON dbo.dr20_legacy_survey_dr8  (flux_r);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_flux_w1_idx ON dbo.dr20_legacy_survey_dr8  (flux_w1);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_flux_z_idx ON dbo.dr20_legacy_survey_dr8  (flux_z);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_gaia_phot_g_mean_mag_idx ON dbo.dr20_legacy_survey_dr8  (gaia_phot_g_mean_mag);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_gaia_phot_g_mean_mag_idx1 ON dbo.dr20_legacy_survey_dr8  (gaia_phot_g_mean_mag);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_gaia_phot_rp_mean_mag_idx ON dbo.dr20_legacy_survey_dr8  (gaia_phot_rp_mean_mag);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_gaia_sourceid_idx ON dbo.dr20_legacy_survey_dr8  (gaia_sourceid);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_maskbits_idx ON dbo.dr20_legacy_survey_dr8  (maskbits);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_nobs_g_idx ON dbo.dr20_legacy_survey_dr8  (nobs_g);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_nobs_r_idx ON dbo.dr20_legacy_survey_dr8  (nobs_r);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_nobs_z_idx ON dbo.dr20_legacy_survey_dr8  (nobs_z);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_parallax_idx ON dbo.dr20_legacy_survey_dr8  (parallax);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_ref_cat_idx ON dbo.dr20_legacy_survey_dr8  (ref_cat);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_ref_epoch_idx ON dbo.dr20_legacy_survey_dr8  (ref_epoch);


CREATE NONCLUSTERED INDEX dr20_legacy_survey_dr8_ref_id_idx ON dbo.dr20_legacy_survey_dr8  (ref_id);


CREATE NONCLUSTERED INDEX dr20_magnitude_carton_to_target_pk_idx ON dbo.dr20_magnitude  (carton_to_target_pk);


CREATE NONCLUSTERED INDEX dr20_magnitude_h_idx ON dbo.dr20_magnitude  (h);


CREATE NONCLUSTERED INDEX dr20_mangadapall_daptype_idx ON dbo.dr20_mangadapall  (daptype);


CREATE NONCLUSTERED INDEX dr20_mangadapall_mangaid_idx ON dbo.dr20_mangadapall  (mangaid);


CREATE NONCLUSTERED INDEX dr20_mangadapall_nsa_z_idx ON dbo.dr20_mangadapall  (nsa_z);


CREATE NONCLUSTERED INDEX dr20_mangadapall_plate_idx ON dbo.dr20_mangadapall  (plate);


CREATE NONCLUSTERED INDEX dr20_mangadrpall_ifudsgn_idx ON dbo.dr20_mangadrpall  (ifudsgn);


CREATE NONCLUSTERED INDEX dr20_mangadrpall_mangaid_idx ON dbo.dr20_mangadrpall  (mangaid);


CREATE NONCLUSTERED INDEX dr20_mangadrpall_nsa_z_idx ON dbo.dr20_mangadrpall  (nsa_z);


CREATE NONCLUSTERED INDEX dr20_mangadrpall_plate_idx ON dbo.dr20_mangadrpall  (plate);


CREATE NONCLUSTERED INDEX dr20_mangatarget_nsa_iauname_idx ON dbo.dr20_mangatarget  (nsa_iauname);


CREATE NONCLUSTERED INDEX dr20_mangatarget_nsa_nsaid_idx ON dbo.dr20_mangatarget  (nsa_nsaid);


CREATE NONCLUSTERED INDEX dr20_mangatarget_nsa_pid_idx ON dbo.dr20_mangatarget  (nsa_pid);


CREATE NONCLUSTERED INDEX dr20_mangatarget_nsa_z_idx ON dbo.dr20_mangatarget  (nsa_z);


CREATE NONCLUSTERED INDEX dr20_marvels_dr11_star_gsc_name_idx ON dbo.dr20_marvels_dr11_star  (gsc_name);


CREATE NONCLUSTERED INDEX dr20_marvels_dr11_star_hip_name_idx ON dbo.dr20_marvels_dr11_star  (hip_name);


CREATE NONCLUSTERED INDEX dr20_marvels_dr11_star_plate_idx ON dbo.dr20_marvels_dr11_star  (plate);


CREATE NONCLUSTERED INDEX dr20_marvels_dr11_star_twomass_designation_idx ON dbo.dr20_marvels_dr11_star  (twomass_designation);


CREATE NONCLUSTERED INDEX dr20_marvels_dr11_star_twomass_name_idx ON dbo.dr20_marvels_dr11_star  (twomass_name);


CREATE NONCLUSTERED INDEX dr20_marvels_dr11_star_tyc_name_idx ON dbo.dr20_marvels_dr11_star  (tyc_name);


CREATE NONCLUSTERED INDEX dr20_marvels_dr11_star_tycho2_designation_idx ON dbo.dr20_marvels_dr11_star  (tycho2_designation);


CREATE NONCLUSTERED INDEX dr20_marvels_dr12_star_gsc_name_idx ON dbo.dr20_marvels_dr12_star  (gsc_name);


CREATE NONCLUSTERED INDEX dr20_marvels_dr12_star_hip_name_idx ON dbo.dr20_marvels_dr12_star  (hip_name);


CREATE NONCLUSTERED INDEX dr20_marvels_dr12_star_plate_idx ON dbo.dr20_marvels_dr12_star  (plate);


CREATE NONCLUSTERED INDEX dr20_marvels_dr12_star_starname_idx ON dbo.dr20_marvels_dr12_star  (starname);


CREATE NONCLUSTERED INDEX dr20_marvels_dr12_star_twomass_designation_idx ON dbo.dr20_marvels_dr12_star  (twomass_designation);


CREATE NONCLUSTERED INDEX dr20_marvels_dr12_star_twomass_name_idx ON dbo.dr20_marvels_dr12_star  (twomass_name);


CREATE NONCLUSTERED INDEX dr20_marvels_dr12_star_tyc_name_idx ON dbo.dr20_marvels_dr12_star  (tyc_name);


CREATE NONCLUSTERED INDEX dr20_marvels_dr12_star_tycho2_designation_idx ON dbo.dr20_marvels_dr12_star  (tycho2_designation);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_drpver_idx ON dbo.dr20_mastar_goodstars  (drpver);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_epoch_idx ON dbo.dr20_mastar_goodstars  (epoch);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_input_alpha_m_idx ON dbo.dr20_mastar_goodstars  (input_alpha_m);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_input_fe_h_idx ON dbo.dr20_mastar_goodstars  (input_fe_h);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_input_logg_idx ON dbo.dr20_mastar_goodstars  (input_logg);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_input_teff_idx ON dbo.dr20_mastar_goodstars  (input_teff);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_maxmjd_idx ON dbo.dr20_mastar_goodstars  (maxmjd);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_minmjd_idx ON dbo.dr20_mastar_goodstars  (minmjd);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_mngtarg2_idx ON dbo.dr20_mastar_goodstars  (mngtarg2);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_mprocver_idx ON dbo.dr20_mastar_goodstars  (mprocver);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_nplates_idx ON dbo.dr20_mastar_goodstars  (nplates);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_nvisits_idx ON dbo.dr20_mastar_goodstars  (nvisits);


CREATE NONCLUSTERED INDEX dr20_mastar_goodstars_photocat_idx ON dbo.dr20_mastar_goodstars  (photocat);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_coord_source_idx ON dbo.dr20_mastar_goodvisits  (coord_source);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_drpver_idx ON dbo.dr20_mastar_goodvisits  (drpver);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_epoch_idx ON dbo.dr20_mastar_goodvisits  (epoch);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_exptime_idx ON dbo.dr20_mastar_goodvisits  (exptime);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_heliov_idx ON dbo.dr20_mastar_goodvisits  (heliov);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_heliov_visit_idx ON dbo.dr20_mastar_goodvisits  (heliov_visit);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_ifudesign_idx ON dbo.dr20_mastar_goodvisits  (ifudesign);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_mangaid_idx ON dbo.dr20_mastar_goodvisits  (mangaid);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_mjd_idx ON dbo.dr20_mastar_goodvisits  (mjd);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_mjdqual_idx ON dbo.dr20_mastar_goodvisits  (mjdqual);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_mngtarg2_idx ON dbo.dr20_mastar_goodvisits  (mngtarg2);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_mprocver_idx ON dbo.dr20_mastar_goodvisits  (mprocver);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_nexp_used_idx ON dbo.dr20_mastar_goodvisits  (nexp_used);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_nexp_visit_idx ON dbo.dr20_mastar_goodvisits  (nexp_visit);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_nvelgood_idx ON dbo.dr20_mastar_goodvisits  (nvelgood);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_photocat_idx ON dbo.dr20_mastar_goodvisits  (photocat);


CREATE NONCLUSTERED INDEX dr20_mastar_goodvisits_plate_idx ON dbo.dr20_mastar_goodvisits  (plate);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_b_idx ON dbo.dr20_milliquas_7_7  (b);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_bmag_idx ON dbo.dr20_milliquas_7_7  (bmag);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_name_idx ON dbo.dr20_milliquas_7_7  (name);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_qpct_idx ON dbo.dr20_milliquas_7_7  (qpct);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_r_idx ON dbo.dr20_milliquas_7_7  (r);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_rmag_idx ON dbo.dr20_milliquas_7_7  (rmag);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_rname_idx ON dbo.dr20_milliquas_7_7  (rname);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_rxpct_idx ON dbo.dr20_milliquas_7_7  (rxpct);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_type_idx ON dbo.dr20_milliquas_7_7  (type);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_xname_idx ON dbo.dr20_milliquas_7_7  (xname);


CREATE NONCLUSTERED INDEX dr20_milliquas_7_7_z_idx ON dbo.dr20_milliquas_7_7  (z);


CREATE NONCLUSTERED INDEX dr20_mipsgal_glat_idx ON dbo.dr20_mipsgal  (glat);


CREATE NONCLUSTERED INDEX dr20_mipsgal_glimpse_idx ON dbo.dr20_mipsgal  (glimpse);


CREATE NONCLUSTERED INDEX dr20_mipsgal_glon_idx ON dbo.dr20_mipsgal  (glon);


CREATE NONCLUSTERED INDEX dr20_mipsgal_hmag_idx ON dbo.dr20_mipsgal  (hmag);


CREATE NONCLUSTERED INDEX dr20_mipsgal_twomass_name_idx ON dbo.dr20_mipsgal  (twomass_name);


CREATE NONCLUSTERED INDEX dr20_mwm_tess_ob_h_mag_idx ON dbo.dr20_mwm_tess_ob  (h_mag);


CREATE NONCLUSTERED INDEX dr20_opsdb_apo_camera_frame_exposure_pk_idx ON dbo.dr20_opsdb_apo_camera_frame  (exposure_pk);


CREATE NONCLUSTERED INDEX dr20_opsdb_apo_configuration_design_id_idx ON dbo.dr20_opsdb_apo_configuration  (design_id);


CREATE NONCLUSTERED INDEX dr20_opsdb_apo_exposure_configuration_id_idx ON dbo.dr20_opsdb_apo_exposure  (configuration_id);


CREATE NONCLUSTERED INDEX dr20_opsdb_apo_exposure_start_time_idx ON dbo.dr20_opsdb_apo_exposure  (start_time);


CREATE NONCLUSTERED INDEX dr20_opsdb_lco_camera_frame_exposure_pk_idx ON dbo.dr20_opsdb_lco_camera_frame  (exposure_pk);


CREATE NONCLUSTERED INDEX dr20_opsdb_lco_configuration_design_id_idx ON dbo.dr20_opsdb_lco_configuration  (design_id);


CREATE NONCLUSTERED INDEX dr20_opsdb_lco_exposure_configuration_id_idx ON dbo.dr20_opsdb_lco_exposure  (configuration_id);


CREATE NONCLUSTERED INDEX dr20_opsdb_lco_exposure_start_time_idx ON dbo.dr20_opsdb_lco_exposure  (start_time);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_extid_hi_lo_idx ON dbo.dr20_panstarrs1  (extid_hi_lo);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_flags_idx ON dbo.dr20_panstarrs1  (flags);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_g_flags_idx ON dbo.dr20_panstarrs1  (g_flags);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_g_stk_psf_flux_idx ON dbo.dr20_panstarrs1  (g_stk_psf_flux);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_i_flags_idx ON dbo.dr20_panstarrs1  (i_flags);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_i_stk_psf_flux_idx ON dbo.dr20_panstarrs1  (i_stk_psf_flux);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_r_flags_idx ON dbo.dr20_panstarrs1  (r_flags);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_r_stk_psf_flux_idx ON dbo.dr20_panstarrs1  (r_stk_psf_flux);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_stargal_idx ON dbo.dr20_panstarrs1  (stargal);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_z_flags_idx ON dbo.dr20_panstarrs1  (z_flags);


CREATE NONCLUSTERED INDEX dr20_panstarrs1_z_stk_psf_flux_idx ON dbo.dr20_panstarrs1  (z_stk_psf_flux);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_al_h_chisq_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (al_h_chisq_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_al_h_error_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (al_h_error_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_al_h_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (al_h_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_al_h_nl_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (al_h_nl_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_alpha_fe_chisq_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (alpha_fe_chisq_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_alpha_fe_error_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (alpha_fe_error_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_alpha_fe_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (alpha_fe_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_fe_h_chisq_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (fe_h_chisq_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_fe_h_error_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (fe_h_error_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_fe_h_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (fe_h_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_fe_h_nl_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (fe_h_nl_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_n_elements_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (n_elements_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_ni_h_chisq_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (ni_h_chisq_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_ni_h_error_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (ni_h_error_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_ni_h_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (ni_h_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_ni_h_nl_gauguin_idx ON dbo.dr20_rave_dr6_gauguin_madera  (ni_h_nl_gauguin);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_gauguin_madera_rave_obs_id_idx ON dbo.dr20_rave_dr6_gauguin_madera  (rave_obs_id);


CREATE NONCLUSTERED INDEX dr20_rave_dr6_xgaiae3_gaiae3_idx ON dbo.dr20_rave_dr6_xgaiae3  (gaiae3);


CREATE NONCLUSTERED INDEX dr20_revised_magnitude_carton_to_target_pk_idx ON dbo.dr20_revised_magnitude  (carton_to_target_pk);


CREATE NONCLUSTERED INDEX dr20_revised_magnitude_h_idx ON dbo.dr20_revised_magnitude  (h);


CREATE NONCLUSTERED INDEX dr20_sagitta_av_idx ON dbo.dr20_sagitta  (av);


CREATE NONCLUSTERED INDEX dr20_sagitta_edr3_age_idx ON dbo.dr20_sagitta_edr3  (age);


CREATE NONCLUSTERED INDEX dr20_sagitta_edr3_age_std_idx ON dbo.dr20_sagitta_edr3  (age_std);


CREATE NONCLUSTERED INDEX dr20_sagitta_edr3_av_idx ON dbo.dr20_sagitta_edr3  (av);


CREATE NONCLUSTERED INDEX dr20_sagitta_edr3_av_std_idx ON dbo.dr20_sagitta_edr3  (av_std);


CREATE NONCLUSTERED INDEX dr20_sagitta_edr3_pms_idx ON dbo.dr20_sagitta_edr3  (pms);


CREATE NONCLUSTERED INDEX dr20_sagitta_edr3_pms_std_idx ON dbo.dr20_sagitta_edr3  (pms_std);


CREATE NONCLUSTERED INDEX dr20_sagitta_yso_idx ON dbo.dr20_sagitta  (yso);


CREATE NONCLUSTERED INDEX dr20_sagitta_yso_std_idx ON dbo.dr20_sagitta  (yso_std);


CREATE NONCLUSTERED INDEX dr20_sdss_apogeeallstarmerge_r13_h_idx ON dbo.dr20_sdss_apogeeallstarmerge_r13  (h);


CREATE NONCLUSTERED INDEX dr20_sdss_apogeeallstarmerge_r13_j_idx ON dbo.dr20_sdss_apogeeallstarmerge_r13  (j);


CREATE NONCLUSTERED INDEX dr20_sdss_apogeeallstarmerge_r13_k_idx ON dbo.dr20_sdss_apogeeallstarmerge_r13  (k);


CREATE NONCLUSTERED INDEX dr20_sdss_dr13_photoobj_primary_objid_idx ON dbo.dr20_sdss_dr13_photoobj_primary  (objid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_qso_fiberid_idx ON dbo.dr20_sdss_dr16_qso  (fiberid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_qso_mjd_idx ON dbo.dr20_sdss_dr16_qso  (mjd);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_qso_mjd_plate_fiberid_idx ON dbo.dr20_sdss_dr16_qso  (mjd, plate, fiberid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_qso_plate_idx ON dbo.dr20_sdss_dr16_qso  (plate);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_bestobjid_idx ON dbo.dr20_sdss_dr16_specobj  (bestobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_fiberid_idx ON dbo.dr20_sdss_dr16_specobj  (fiberid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_fluxobjid_idx ON dbo.dr20_sdss_dr16_specobj  (fluxobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_mjd_idx ON dbo.dr20_sdss_dr16_specobj  (mjd);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_plate_idx ON dbo.dr20_sdss_dr16_specobj  (plate);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_run2d_idx ON dbo.dr20_sdss_dr16_specobj  (run2d);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_scienceprimary_idx ON dbo.dr20_sdss_dr16_specobj  (scienceprimary);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_snmedian_idx ON dbo.dr20_sdss_dr16_specobj  (snmedian);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_targetobjid_idx ON dbo.dr20_sdss_dr16_specobj  (targetobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_z_idx ON dbo.dr20_sdss_dr16_specobj  (z);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_zerr_idx ON dbo.dr20_sdss_dr16_specobj  (zerr);


CREATE NONCLUSTERED INDEX dr20_sdss_dr16_specobj_zwarning_idx ON dbo.dr20_sdss_dr16_specobj  (zwarning);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_apogee_allstarmerge_gaia_source_id_idx ON dbo.dr20_sdss_dr17_apogee_allstarmerge  (gaia_source_id);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_bestobjid_idx ON dbo.dr20_sdss_dr17_specobj  (bestobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_bestobjid_idx1 ON dbo.dr20_sdss_dr17_specobj  (bestobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_fiberid_idx ON dbo.dr20_sdss_dr17_specobj  (fiberid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_fluxobjid_idx ON dbo.dr20_sdss_dr17_specobj  (fluxobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_mjd_idx ON dbo.dr20_sdss_dr17_specobj  (mjd);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_mjd_plate_fiberid_idx ON dbo.dr20_sdss_dr17_specobj  (mjd, plate, fiberid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_mjd_plate_fiberid_run2d_idx ON dbo.dr20_sdss_dr17_specobj  (mjd, plate, fiberid, run2d);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_plateid_idx ON dbo.dr20_sdss_dr17_specobj  (plateid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_run2d_idx ON dbo.dr20_sdss_dr17_specobj  (run2d);


CREATE NONCLUSTERED INDEX dr20_sdss_dr17_specobj_targetobjid_idx ON dbo.dr20_sdss_dr17_specobj  (targetobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr19p_speclite_bestobjid_idx ON dbo.dr20_sdss_dr19p_speclite  (bestobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr19p_speclite_catalogid_idx ON dbo.dr20_sdss_dr19p_speclite  (catalogid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr19p_speclite_mjd_idx ON dbo.dr20_sdss_dr19p_speclite  (mjd);


CREATE NONCLUSTERED INDEX dr20_sdss_dr19p_speclite_plate_mjd_fiberid_idx ON dbo.dr20_sdss_dr19p_speclite  (plate, mjd, fiberid);


CREATE NONCLUSTERED INDEX dr20_sdss_dr19p_speclite_sn_median_all_idx ON dbo.dr20_sdss_dr19p_speclite  (sn_median_all);


CREATE NONCLUSTERED INDEX dr20_sdss_dr19p_speclite_z_err_idx ON dbo.dr20_sdss_dr19p_speclite  (z_err);


CREATE NONCLUSTERED INDEX dr20_sdss_dr19p_speclite_z_idx ON dbo.dr20_sdss_dr19p_speclite  (z);


CREATE NONCLUSTERED INDEX dr20_sdss_dr19p_speclite_zwarning_idx ON dbo.dr20_sdss_dr19p_speclite  (zwarning);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_catalogid_idx ON dbo.dr20_sdss_id_flat  (catalogid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_catalogid_idx1 ON dbo.dr20_sdss_id_flat  (catalogid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_dec_catalogid_idx ON dbo.dr20_sdss_id_flat  (dec_catalogid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_dec_sdss_id_idx ON dbo.dr20_sdss_id_flat  (dec_sdss_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_initial_catalogid_idx ON dbo.dr20_sdss_id_flat_initial  (catalogid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_initial_sdss_id_idx ON dbo.dr20_sdss_id_flat_initial  (sdss_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_n_associated_idx ON dbo.dr20_sdss_id_flat  (n_associated);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_ra_catalogid_idx ON dbo.dr20_sdss_id_flat  (ra_catalogid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_flat_sdss_id_idx ON dbo.dr20_sdss_id_flat  (sdss_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_stacked_catalogid21_idx ON dbo.dr20_sdss_id_stacked  (catalogid21);


CREATE NONCLUSTERED INDEX dr20_sdss_id_stacked_catalogid25_idx ON dbo.dr20_sdss_id_stacked  (catalogid25);


CREATE NONCLUSTERED INDEX dr20_sdss_id_stacked_catalogid25_idx1 ON dbo.dr20_sdss_id_stacked  (catalogid25);


CREATE NONCLUSTERED INDEX dr20_sdss_id_stacked_catalogid31_idx ON dbo.dr20_sdss_id_stacked  (catalogid31);


CREATE NONCLUSTERED INDEX dr20_sdss_id_stacked_catalogid31_idx1 ON dbo.dr20_sdss_id_stacked  (catalogid31);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_allstar_dr17_synspec_rev1__apstar_i_idx ON dbo.dr20_sdss_id_to_catalog  (allstar_dr17_synspec_rev1__apstar_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_allwise__cntr_idx ON dbo.dr20_sdss_id_to_catalog  (allwise__cntr);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_bhm_rm_v0_2__pk_idx ON dbo.dr20_sdss_id_to_catalog  (bhm_rm_v0_2__pk);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_bhm_rm_v0__pk_idx ON dbo.dr20_sdss_id_to_catalog  (bhm_rm_v0__pk);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_catalogid_idx ON dbo.dr20_sdss_id_to_catalog  (catalogid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_catwise2020__source_id_idx ON dbo.dr20_sdss_id_to_catalog  (catwise2020__source_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_catwise__source_id_idx ON dbo.dr20_sdss_id_to_catalog  (catwise__source_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_full_catalogid_idx ON dbo.dr20_sdss_id_to_catalog_full  (catalogid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_gaia_dr2_source__source_id_idx ON dbo.dr20_sdss_id_to_catalog  (gaia_dr2_source__source_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_gaia_dr3_source__source_id_idx ON dbo.dr20_sdss_id_to_catalog  (gaia_dr3_source__source_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_glimpse__pk_idx ON dbo.dr20_sdss_id_to_catalog  (glimpse__pk);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_guvcat__objid_idx ON dbo.dr20_sdss_id_to_catalog  (guvcat__objid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_legacy_survey_dr10__ls_id_idx ON dbo.dr20_sdss_id_to_catalog  (legacy_survey_dr10__ls_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_legacy_survey_dr8__ls_id_idx ON dbo.dr20_sdss_id_to_catalog  (legacy_survey_dr8__ls_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_mangatarget__mangaid_idx ON dbo.dr20_sdss_id_to_catalog  (mangatarget__mangaid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_marvels_dr11_star__starname_idx ON dbo.dr20_sdss_id_to_catalog  (marvels_dr11_star__starname);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_marvels_dr12_star__pk_idx ON dbo.dr20_sdss_id_to_catalog  (marvels_dr12_star__pk);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_mastar_goodstars__mangaid_idx ON dbo.dr20_sdss_id_to_catalog  (mastar_goodstars__mangaid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_panstarrs1__catid_objid_idx ON dbo.dr20_sdss_id_to_catalog  (panstarrs1__catid_objid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_pk_idx ON dbo.dr20_sdss_id_to_catalog  (pk);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_ps1_g18__objid_idx ON dbo.dr20_sdss_id_to_catalog  (ps1_g18__objid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_sdss_dr13_photoobj__objid_idx ON dbo.dr20_sdss_id_to_catalog  (sdss_dr13_photoobj__objid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_sdss_dr17_specobj__specobjid_idx ON dbo.dr20_sdss_id_to_catalog  (sdss_dr17_specobj__specobjid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_sdss_id_idx ON dbo.dr20_sdss_id_to_catalog  (sdss_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_skymapper_dr1_1__object_id_idx ON dbo.dr20_sdss_id_to_catalog  (skymapper_dr1_1__object_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_skymapper_dr2__object_id_idx ON dbo.dr20_sdss_id_to_catalog  (skymapper_dr2__object_id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_supercosmos__objid_idx ON dbo.dr20_sdss_id_to_catalog  (supercosmos__objid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_tic_v8__id_idx ON dbo.dr20_sdss_id_to_catalog  (tic_v8__id);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_twomass_psc__pts_key_idx ON dbo.dr20_sdss_id_to_catalog  (twomass_psc__pts_key);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_tycho2__designation_idx ON dbo.dr20_sdss_id_to_catalog  (tycho2__designation);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_unwise__unwise_objid_idx ON dbo.dr20_sdss_id_to_catalog  (unwise__unwise_objid);


CREATE NONCLUSTERED INDEX dr20_sdss_id_to_catalog_version_id_idx ON dbo.dr20_sdss_id_to_catalog  (version_id);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_designid_idx ON dbo.dr20_sdssv_boss_conflist  (designid);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_mjd_idx ON dbo.dr20_sdssv_boss_conflist  (mjd);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_plate_idx ON dbo.dr20_sdssv_boss_conflist  (plate);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_plate_mjd_idx ON dbo.dr20_sdssv_boss_conflist  (plate, mjd);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_platesn2_idx ON dbo.dr20_sdssv_boss_conflist  (platesn2);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_programname_idx ON dbo.dr20_sdssv_boss_conflist  (programname);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_sn2_g1_idx ON dbo.dr20_sdssv_boss_conflist  (sn2_g1);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_sn2_i1_idx ON dbo.dr20_sdssv_boss_conflist  (sn2_i1);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_conflist_sn2_r1_idx ON dbo.dr20_sdssv_boss_conflist  (sn2_r1);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_catalogid_idx ON dbo.dr20_sdssv_boss_spall  (catalogid);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_fiberid_idx ON dbo.dr20_sdssv_boss_spall  (fiberid);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_firstcarton_idx ON dbo.dr20_sdssv_boss_spall  (firstcarton);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_mjd_idx ON dbo.dr20_sdssv_boss_spall  (mjd);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_plate_idx ON dbo.dr20_sdssv_boss_spall  (plate);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_plate_mjd_fiberid_idx ON dbo.dr20_sdssv_boss_spall  (plate, mjd, fiberid);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_plate_mjd_idx ON dbo.dr20_sdssv_boss_spall  (plate, mjd);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_programname_idx ON dbo.dr20_sdssv_boss_spall  (programname);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_sn_median_all_idx ON dbo.dr20_sdssv_boss_spall  (sn_median_all);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_specprimary_idx ON dbo.dr20_sdssv_boss_spall  (specprimary);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_z_err_idx ON dbo.dr20_sdssv_boss_spall  (z_err);


CREATE NONCLUSTERED INDEX dr20_sdssv_boss_spall_zwarning_idx ON dbo.dr20_sdssv_boss_spall  (zwarning);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_block_idx ON dbo.dr20_sdssv_plateholes  (block);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_catalogid_idx ON dbo.dr20_sdssv_plateholes  (catalogid);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_fiberid_idx ON dbo.dr20_sdssv_plateholes  (fiberid);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_firstcarton_idx ON dbo.dr20_sdssv_plateholes  (firstcarton);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_holetype_idx ON dbo.dr20_sdssv_plateholes  (holetype);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_meta_defaultsurveymode_idx ON dbo.dr20_sdssv_plateholes_meta  (defaultsurveymode);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_meta_designid_idx ON dbo.dr20_sdssv_plateholes_meta  (designid);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_meta_isvalid_idx ON dbo.dr20_sdssv_plateholes_meta  (isvalid);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_meta_locationid_idx ON dbo.dr20_sdssv_plateholes_meta  (locationid);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_meta_plateid_idx ON dbo.dr20_sdssv_plateholes_meta  (plateid);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_meta_programname_idx ON dbo.dr20_sdssv_plateholes_meta  (programname);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_sdssv_apogee_target0_idx ON dbo.dr20_sdssv_plateholes  (sdssv_apogee_target0);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_sdssv_boss_target0_idx ON dbo.dr20_sdssv_plateholes  (sdssv_boss_target0);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_sourcetype_idx ON dbo.dr20_sdssv_plateholes  (sourcetype);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_targettype_idx ON dbo.dr20_sdssv_plateholes  (targettype);


CREATE NONCLUSTERED INDEX dr20_sdssv_plateholes_yanny_uid_idx ON dbo.dr20_sdssv_plateholes  (yanny_uid);


CREATE NONCLUSTERED INDEX dr20_skies_v1_down_pix_idx ON dbo.dr20_skies_v1  (down_pix);


CREATE NONCLUSTERED INDEX dr20_skies_v1_mag_neighbour_gaia_idx ON dbo.dr20_skies_v1  (mag_neighbour_gaia);


CREATE NONCLUSTERED INDEX dr20_skies_v1_mag_neighbour_ls8_idx ON dbo.dr20_skies_v1  (mag_neighbour_ls8);


CREATE NONCLUSTERED INDEX dr20_skies_v1_mag_neighbour_tmass_idx ON dbo.dr20_skies_v1  (mag_neighbour_tmass);


CREATE NONCLUSTERED INDEX dr20_skies_v1_mag_neighbour_tmass_xsc_idx ON dbo.dr20_skies_v1  (mag_neighbour_tmass_xsc);


CREATE NONCLUSTERED INDEX dr20_skies_v1_mag_neighbour_tycho2_idx ON dbo.dr20_skies_v1  (mag_neighbour_tycho2);


CREATE NONCLUSTERED INDEX dr20_skies_v1_sep_neighbour_gaia_idx ON dbo.dr20_skies_v1  (sep_neighbour_gaia);


CREATE NONCLUSTERED INDEX dr20_skies_v1_sep_neighbour_ls8_idx ON dbo.dr20_skies_v1  (sep_neighbour_ls8);


CREATE NONCLUSTERED INDEX dr20_skies_v1_sep_neighbour_tmass_idx ON dbo.dr20_skies_v1  (sep_neighbour_tmass);


CREATE NONCLUSTERED INDEX dr20_skies_v1_sep_neighbour_tmass_xsc_idx ON dbo.dr20_skies_v1  (sep_neighbour_tmass_xsc);


CREATE NONCLUSTERED INDEX dr20_skies_v1_sep_neighbour_tycho2_idx ON dbo.dr20_skies_v1  (sep_neighbour_tycho2);


CREATE NONCLUSTERED INDEX dr20_skies_v1_tile_32_idx ON dbo.dr20_skies_v1  (tile_32);


CREATE NONCLUSTERED INDEX dr20_skies_v2_down_pix_idx ON dbo.dr20_skies_v2  (down_pix);


CREATE NONCLUSTERED INDEX dr20_skies_v2_mag_neighbour_gaia_idx ON dbo.dr20_skies_v2  (mag_neighbour_gaia);


CREATE NONCLUSTERED INDEX dr20_skies_v2_mag_neighbour_ls8_idx ON dbo.dr20_skies_v2  (mag_neighbour_ls8);


CREATE NONCLUSTERED INDEX dr20_skies_v2_mag_neighbour_ps1dr2_idx ON dbo.dr20_skies_v2  (mag_neighbour_ps1dr2);


CREATE NONCLUSTERED INDEX dr20_skies_v2_mag_neighbour_tmass_idx ON dbo.dr20_skies_v2  (mag_neighbour_tmass);


CREATE NONCLUSTERED INDEX dr20_skies_v2_mag_neighbour_tycho2_idx ON dbo.dr20_skies_v2  (mag_neighbour_tycho2);


CREATE NONCLUSTERED INDEX dr20_skies_v2_sep_neighbour_gaia_idx ON dbo.dr20_skies_v2  (sep_neighbour_gaia);


CREATE NONCLUSTERED INDEX dr20_skies_v2_sep_neighbour_ls8_idx ON dbo.dr20_skies_v2  (sep_neighbour_ls8);


CREATE NONCLUSTERED INDEX dr20_skies_v2_sep_neighbour_ps1dr2_idx ON dbo.dr20_skies_v2  (sep_neighbour_ps1dr2);


CREATE NONCLUSTERED INDEX dr20_skies_v2_sep_neighbour_tmass_idx ON dbo.dr20_skies_v2  (sep_neighbour_tmass);


CREATE NONCLUSTERED INDEX dr20_skies_v2_sep_neighbour_tmass_xsc_idx ON dbo.dr20_skies_v2  (sep_neighbour_tmass_xsc);


CREATE NONCLUSTERED INDEX dr20_skies_v2_sep_neighbour_tycho2_idx ON dbo.dr20_skies_v2  (sep_neighbour_tycho2);


CREATE NONCLUSTERED INDEX dr20_skies_v2_tile_32_idx ON dbo.dr20_skies_v2  (tile_32);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_allwise_cntr_idx ON dbo.dr20_skymapper_dr2  (allwise_cntr);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_flags_psf_idx ON dbo.dr20_skymapper_dr2  (flags_psf);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_g_psf_idx ON dbo.dr20_skymapper_dr2  (g_psf);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_gaia_dr2_id1_idx ON dbo.dr20_skymapper_dr2  (gaia_dr2_id1);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_gaia_dr2_id2_idx ON dbo.dr20_skymapper_dr2  (gaia_dr2_id2);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_i_psf_idx ON dbo.dr20_skymapper_dr2  (i_psf);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_nimaflags_idx ON dbo.dr20_skymapper_dr2  (nimaflags);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_r_psf_idx ON dbo.dr20_skymapper_dr2  (r_psf);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_smss_j_idx ON dbo.dr20_skymapper_dr2  (smss_j);


CREATE NONCLUSTERED INDEX dr20_skymapper_dr2_z_psf_idx ON dbo.dr20_skymapper_dr2  (z_psf);


CREATE NONCLUSTERED INDEX dr20_skymapper_gaia_feh_idx ON dbo.dr20_skymapper_gaia  (feh);


CREATE NONCLUSTERED INDEX dr20_skymapper_gaia_gaia_source_id_idx ON dbo.dr20_skymapper_gaia  (gaia_source_id);


CREATE NONCLUSTERED INDEX dr20_skymapper_gaia_teff_idx ON dbo.dr20_skymapper_gaia  (teff);


CREATE NONCLUSTERED INDEX dr20_supercosmos_classb_idx ON dbo.dr20_supercosmos  (classb);


CREATE NONCLUSTERED INDEX dr20_supercosmos_classi_idx ON dbo.dr20_supercosmos  (classi);


CREATE NONCLUSTERED INDEX dr20_supercosmos_classmagb_idx ON dbo.dr20_supercosmos  (classmagb);


CREATE NONCLUSTERED INDEX dr20_supercosmos_classmagi_idx ON dbo.dr20_supercosmos  (classmagi);


CREATE NONCLUSTERED INDEX dr20_supercosmos_classmagr1_idx ON dbo.dr20_supercosmos  (classmagr1);


CREATE NONCLUSTERED INDEX dr20_supercosmos_classmagr2_idx ON dbo.dr20_supercosmos  (classmagr2);


CREATE NONCLUSTERED INDEX dr20_supercosmos_classr1_idx ON dbo.dr20_supercosmos  (classr1);


CREATE NONCLUSTERED INDEX dr20_supercosmos_classr2_idx ON dbo.dr20_supercosmos  (classr2);


CREATE NONCLUSTERED INDEX dr20_target_catalogid_idx ON dbo.dr20_target  (catalogid);


CREATE NONCLUSTERED INDEX dr20_targeting_generation_to_carton_carton_pk_idx ON dbo.dr20_targeting_generation_to_carton  (carton_pk);


CREATE NONCLUSTERED INDEX dr20_targeting_generation_to_carton_generation_pk_idx ON dbo.dr20_targeting_generation_to_carton  (generation_pk);


CREATE NONCLUSTERED INDEX dr20_targeting_generation_to_version_generation_pk_idx ON dbo.dr20_targeting_generation_to_version  (generation_pk);


CREATE NONCLUSTERED INDEX dr20_targeting_generation_to_version_version_pk_idx ON dbo.dr20_targeting_generation_to_version  (version_pk);


CREATE NONCLUSTERED INDEX dr20_tess_toi_ticid_idx ON dbo.dr20_tess_toi  (ticid);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v05_ctoi_idx ON dbo.dr20_tess_toi_v05  (ctoi);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v05_num_sectors_idx ON dbo.dr20_tess_toi_v05  (num_sectors);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v05_target_type_idx ON dbo.dr20_tess_toi_v05  (target_type);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v05_tess_disposition_idx ON dbo.dr20_tess_toi_v05  (tess_disposition);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v05_tfopwg_disposition_idx ON dbo.dr20_tess_toi_v05  (tfopwg_disposition);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v05_ticid_idx ON dbo.dr20_tess_toi_v05  (ticid);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v05_toi_idx ON dbo.dr20_tess_toi_v05  (toi);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v05_user_disposition_idx ON dbo.dr20_tess_toi_v05  (user_disposition);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v1_ctoi_idx ON dbo.dr20_tess_toi_v1  (ctoi);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v1_num_sectors_idx ON dbo.dr20_tess_toi_v1  (num_sectors);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v1_target_type_idx ON dbo.dr20_tess_toi_v1  (target_type);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v1_tess_disposition_idx ON dbo.dr20_tess_toi_v1  (tess_disposition);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v1_tfopwg_disposition_idx ON dbo.dr20_tess_toi_v1  (tfopwg_disposition);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v1_ticid_idx ON dbo.dr20_tess_toi_v1  (ticid);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v1_toi_idx ON dbo.dr20_tess_toi_v1  (toi);


CREATE NONCLUSTERED INDEX dr20_tess_toi_v1_user_disposition_idx ON dbo.dr20_tess_toi_v1  (user_disposition);


CREATE NONCLUSTERED INDEX dr20_tic_v8_allwise_idx ON dbo.dr20_tic_v8  (allwise);


CREATE NONCLUSTERED INDEX dr20_tic_v8_gaia_int_idx ON dbo.dr20_tic_v8  (gaia_int);


CREATE NONCLUSTERED INDEX dr20_tic_v8_gaiamag_idx ON dbo.dr20_tic_v8  (gaiamag);


CREATE NONCLUSTERED INDEX dr20_tic_v8_hmag_idx ON dbo.dr20_tic_v8  (hmag);


CREATE NONCLUSTERED INDEX dr20_tic_v8_kic_idx ON dbo.dr20_tic_v8  (kic);


CREATE NONCLUSTERED INDEX dr20_tic_v8_logg_idx ON dbo.dr20_tic_v8  (logg);


CREATE NONCLUSTERED INDEX dr20_tic_v8_objtype_idx ON dbo.dr20_tic_v8  (objtype);


CREATE NONCLUSTERED INDEX dr20_tic_v8_plx_idx ON dbo.dr20_tic_v8  (plx);


CREATE NONCLUSTERED INDEX dr20_tic_v8_posflag_idx ON dbo.dr20_tic_v8  (posflag);


CREATE NONCLUSTERED INDEX dr20_tic_v8_sdss_idx ON dbo.dr20_tic_v8  (sdss);


CREATE NONCLUSTERED INDEX dr20_tic_v8_teff_idx ON dbo.dr20_tic_v8  (teff);


CREATE NONCLUSTERED INDEX dr20_tic_v8_tmag_idx ON dbo.dr20_tic_v8  (tmag);


CREATE NONCLUSTERED INDEX dr20_tic_v8_twomass_psc_idx ON dbo.dr20_tic_v8  (twomass_psc);


CREATE NONCLUSTERED INDEX dr20_tic_v8_twomass_psc_pts_key_idx ON dbo.dr20_tic_v8  (twomass_psc_pts_key);


CREATE NONCLUSTERED INDEX dr20_tic_v8_tycho2_tycid_idx ON dbo.dr20_tic_v8  (tycho2_tycid);


CREATE NONCLUSTERED INDEX dr20_twomass_psc_cc_flg_idx ON dbo.dr20_twomass_psc  (cc_flg);


CREATE NONCLUSTERED INDEX dr20_twomass_psc_gal_contam_idx ON dbo.dr20_twomass_psc  (gal_contam);


CREATE NONCLUSTERED INDEX dr20_twomass_psc_jdate_idx ON dbo.dr20_twomass_psc  (jdate);


CREATE NONCLUSTERED INDEX dr20_twomass_psc_ph_qual_idx ON dbo.dr20_twomass_psc  (ph_qual);


CREATE NONCLUSTERED INDEX dr20_twomass_psc_rd_flg_idx ON dbo.dr20_twomass_psc  (rd_flg);


CREATE NONCLUSTERED INDEX dr20_tycho2_btmag_idx ON dbo.dr20_tycho2  (btmag);


CREATE NONCLUSTERED INDEX dr20_tycho2_tycid_idx ON dbo.dr20_tycho2  (tycid);


CREATE NONCLUSTERED INDEX dr20_tycho2_vtmag_idx ON dbo.dr20_tycho2  (vtmag);


CREATE NONCLUSTERED INDEX dr20_unwise_flux_w1_idx ON dbo.dr20_unwise  (flux_w1);


CREATE NONCLUSTERED INDEX dr20_unwise_flux_w2_idx ON dbo.dr20_unwise  (flux_w2);


CREATE NONCLUSTERED INDEX dr20_uvotssc1_name_idx ON dbo.dr20_uvotssc1  (name);


CREATE NONCLUSTERED INDEX dr20_uvotssc1_obsid_idx ON dbo.dr20_uvotssc1  (obsid);


CREATE NONCLUSTERED INDEX dr20_uvotssc1_srcid_idx ON dbo.dr20_uvotssc1  (srcid);


CREATE NONCLUSTERED INDEX dr20_visual_binary_gaia_dr3_source_id2_idx ON dbo.dr20_visual_binary_gaia_dr3  (source_id2);


CREATE NONCLUSTERED INDEX dr20_wd_gaia_dr3_gaiadr2_idx ON dbo.dr20_wd_gaia_dr3  (gaiadr2);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_4_1_iauname_idx ON dbo.dr20_xmm_om_suss_4_1  (iauname);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_iauname_idx ON dbo.dr20_xmm_om_suss_5_0  (iauname);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_n_summary_idx ON dbo.dr20_xmm_om_suss_5_0  (n_summary);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_obsid_idx ON dbo.dr20_xmm_om_suss_5_0  (obsid);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_srcnum_idx ON dbo.dr20_xmm_om_suss_5_0  (srcnum);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvm2_ab_mag_idx ON dbo.dr20_xmm_om_suss_5_0  (uvm2_ab_mag);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvm2_quality_flag_st_idx ON dbo.dr20_xmm_om_suss_5_0  (uvm2_quality_flag_st);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvm2_signif_idx ON dbo.dr20_xmm_om_suss_5_0  (uvm2_signif);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvw1_ab_mag_idx ON dbo.dr20_xmm_om_suss_5_0  (uvw1_ab_mag);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvw1_quality_flag_st_idx ON dbo.dr20_xmm_om_suss_5_0  (uvw1_quality_flag_st);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvw1_signif_idx ON dbo.dr20_xmm_om_suss_5_0  (uvw1_signif);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvw2_ab_mag_idx ON dbo.dr20_xmm_om_suss_5_0  (uvw2_ab_mag);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvw2_quality_flag_st_idx ON dbo.dr20_xmm_om_suss_5_0  (uvw2_quality_flag_st);


CREATE NONCLUSTERED INDEX dr20_xmm_om_suss_5_0_uvw2_signif_idx ON dbo.dr20_xmm_om_suss_5_0  (uvw2_signif);


CREATE NONCLUSTERED INDEX dr20_xpfeh_gaia_dr3_in_training_sample_idx ON dbo.dr20_xpfeh_gaia_dr3  (in_training_sample);


CREATE NONCLUSTERED INDEX dr20_xpfeh_gaia_dr3_logg_xgboost_idx ON dbo.dr20_xpfeh_gaia_dr3  (logg_xgboost);


CREATE NONCLUSTERED INDEX dr20_xpfeh_gaia_dr3_mh_xgboost_idx ON dbo.dr20_xpfeh_gaia_dr3  (mh_xgboost);


CREATE NONCLUSTERED INDEX dr20_xpfeh_gaia_dr3_teff_xgboost_idx ON dbo.dr20_xpfeh_gaia_dr3  (teff_xgboost);


CREATE NONCLUSTERED INDEX dr20_yso_clustering_bp_idx ON dbo.dr20_yso_clustering  (bp);


CREATE NONCLUSTERED INDEX dr20_yso_clustering_g_idx ON dbo.dr20_yso_clustering  (g);


CREATE NONCLUSTERED INDEX dr20_yso_clustering_h_idx ON dbo.dr20_yso_clustering  (h);


CREATE NONCLUSTERED INDEX dr20_yso_clustering_j_idx ON dbo.dr20_yso_clustering  (j);


CREATE NONCLUSTERED INDEX dr20_yso_clustering_k_idx ON dbo.dr20_yso_clustering  (k);


CREATE NONCLUSTERED INDEX dr20_yso_clustering_rp_idx ON dbo.dr20_yso_clustering  (rp);


CREATE NONCLUSTERED INDEX dr20_zari18pms_bp_over_rp_idx ON dbo.dr20_zari18pms  (bp_over_rp);


CREATE NONCLUSTERED INDEX dr20_zari18pms_bp_rp_idx ON dbo.dr20_zari18pms  (bp_rp);


CREATE NONCLUSTERED INDEX dr20_zari18pms_bpmag_idx ON dbo.dr20_zari18pms  (bpmag);


CREATE NONCLUSTERED INDEX dr20_zari18pms_gmag_idx ON dbo.dr20_zari18pms  (gmag);


CREATE NONCLUSTERED INDEX dr20_zari18pms_rpmag_idx ON dbo.dr20_zari18pms  (rpmag);


CREATE NONCLUSTERED INDEX dr20_zari18pms_source_idx ON dbo.dr20_zari18pms  (source);
