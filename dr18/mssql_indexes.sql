

CREATE NONCLUSTERED INDEX dr18_allwise_designation_idx ON dbo.dr18_allwise  (designation);


CREATE NONCLUSTERED INDEX dr18_allwise_expr_idx ON dbo.dr18_allwise  (((w1mpro - w2mpro)));


CREATE NONCLUSTERED INDEX dr18_allwise_ph_qual_idx ON dbo.dr18_allwise  (ph_qual);


CREATE NONCLUSTERED INDEX dr18_allwise_w1mpro_idx ON dbo.dr18_allwise  (w1mpro);


CREATE NONCLUSTERED INDEX dr18_allwise_w1sigmpro_idx ON dbo.dr18_allwise  (w1sigmpro);


CREATE NONCLUSTERED INDEX dr18_allwise_w2mpro_idx ON dbo.dr18_allwise  (w2mpro);


CREATE NONCLUSTERED INDEX dr18_allwise_w2sigmpro_idx ON dbo.dr18_allwise  (w2sigmpro);


CREATE NONCLUSTERED INDEX dr18_allwise_w3mpro_idx ON dbo.dr18_allwise  (w3mpro);


CREATE NONCLUSTERED INDEX dr18_allwise_w3sigmpro_idx ON dbo.dr18_allwise  (w3sigmpro);


CREATE NONCLUSTERED INDEX dr18_best_brightest_gmag_idx ON dbo.dr18_best_brightest  (gmag);


CREATE NONCLUSTERED INDEX dr18_best_brightest_version_idx ON dbo.dr18_best_brightest  (version);


CREATE NONCLUSTERED INDEX dr18_bhm_csc_v2_cxoid_idx ON dbo.dr18_bhm_csc_v2  (cxoid);


CREATE NONCLUSTERED INDEX dr18_bhm_csc_v2_designation2m_idx ON dbo.dr18_bhm_csc_v2  (designation2m);


CREATE NONCLUSTERED INDEX dr18_bhm_csc_v2_hmag_idx ON dbo.dr18_bhm_csc_v2  (hmag);


CREATE NONCLUSTERED INDEX dr18_bhm_csc_v2_idg2_idx ON dbo.dr18_bhm_csc_v2  (idg2);


CREATE NONCLUSTERED INDEX dr18_bhm_csc_v2_idps_idx ON dbo.dr18_bhm_csc_v2  (idps);


CREATE NONCLUSTERED INDEX dr18_bhm_csc_v2_ocat_idx ON dbo.dr18_bhm_csc_v2  (ocat);


CREATE NONCLUSTERED INDEX dr18_bhm_csc_v2_oid_idx ON dbo.dr18_bhm_csc_v2  (oid);


CREATE NONCLUSTERED INDEX dr18_bhm_csc_v2_omag_idx ON dbo.dr18_bhm_csc_v2  (omag);


CREATE NONCLUSTERED INDEX dr18_bhm_efeds_veto_fiberid_idx ON dbo.dr18_bhm_efeds_veto  (fiberid);


CREATE NONCLUSTERED INDEX dr18_bhm_efeds_veto_mjd_idx ON dbo.dr18_bhm_efeds_veto  (mjd);


CREATE NONCLUSTERED INDEX dr18_bhm_efeds_veto_plate_idx ON dbo.dr18_bhm_efeds_veto  (plate);


CREATE NONCLUSTERED INDEX dr18_bhm_efeds_veto_run2d_idx ON dbo.dr18_bhm_efeds_veto  (run2d);


CREATE NONCLUSTERED INDEX dr18_bhm_efeds_veto_tile_idx ON dbo.dr18_bhm_efeds_veto  (tile);


CREATE NONCLUSTERED INDEX dr18_bhm_rm_v0_2_coadd_object_id_idx ON dbo.dr18_bhm_rm_v0_2  (coadd_object_id);


CREATE NONCLUSTERED INDEX dr18_bhm_rm_v0_2_id_nsc_idx ON dbo.dr18_bhm_rm_v0_2  (id_nsc);


CREATE NONCLUSTERED INDEX dr18_bhm_rm_v0_2_objid_ps1_idx ON dbo.dr18_bhm_rm_v0_2  (objid_ps1);


CREATE NONCLUSTERED INDEX dr18_bhm_rm_v0_2_objid_sdss_idx ON dbo.dr18_bhm_rm_v0_2  (objid_sdss);


CREATE NONCLUSTERED INDEX dr18_bhm_rm_v0_2_objid_unwise_idx ON dbo.dr18_bhm_rm_v0_2  (objid_unwise);


CREATE NONCLUSTERED INDEX dr18_bhm_rm_v0_2_source_id_gaia_idx ON dbo.dr18_bhm_rm_v0_2  (source_id_gaia);


CREATE NONCLUSTERED INDEX dr18_bhm_rm_v0_2_sourceid_ir_idx ON dbo.dr18_bhm_rm_v0_2  (sourceid_ir);


CREATE NONCLUSTERED INDEX dr18_cadence_epoch_cadence_pk_idx ON dbo.dr18_cadence_epoch  (cadence_pk);


CREATE NONCLUSTERED INDEX dr18_cadence_epoch_label_idx ON dbo.dr18_cadence_epoch  (label);


CREATE NONCLUSTERED INDEX dr18_carton_to_target_cadence_pk_idx ON dbo.dr18_carton_to_target  (cadence_pk);


CREATE NONCLUSTERED INDEX dr18_carton_to_target_carton_pk_idx ON dbo.dr18_carton_to_target  (carton_pk);


CREATE NONCLUSTERED INDEX dr18_carton_to_target_instrument_pk_idx ON dbo.dr18_carton_to_target  (instrument_pk);


CREATE NONCLUSTERED INDEX dr18_carton_to_target_target_pk_idx ON dbo.dr18_carton_to_target  (target_pk);


CREATE NONCLUSTERED INDEX dr18_cataclysmic_variables_source_id_idx ON dbo.dr18_cataclysmic_variables  (source_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_allwise_best_idx ON dbo.dr18_catalog_to_allwise  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_allwise_catalogid_idx ON dbo.dr18_catalog_to_allwise  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_allwise_target_id_idx ON dbo.dr18_catalog_to_allwise  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_allwise_version_id_idx ON dbo.dr18_catalog_to_allwise  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_bhm_efeds_veto_best_idx ON dbo.dr18_catalog_to_bhm_efeds_veto  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_bhm_efeds_veto_catalogid_idx ON dbo.dr18_catalog_to_bhm_efeds_veto  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_bhm_efeds_veto_target_id_idx ON dbo.dr18_catalog_to_bhm_efeds_veto  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_bhm_efeds_veto_version_id_idx ON dbo.dr18_catalog_to_bhm_efeds_veto  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_bhm_rm_v0_2_best_idx ON dbo.dr18_catalog_to_bhm_rm_v0_2  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_bhm_rm_v0_2_catalogid_idx ON dbo.dr18_catalog_to_bhm_rm_v0_2  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_bhm_rm_v0_2_target_id_idx ON dbo.dr18_catalog_to_bhm_rm_v0_2  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_bhm_rm_v0_2_version_id_idx ON dbo.dr18_catalog_to_bhm_rm_v0_2  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_catwise2020_best_idx ON dbo.dr18_catalog_to_catwise2020  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_catwise2020_catalogid_idx ON dbo.dr18_catalog_to_catwise2020  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_catwise2020_target_id_idx ON dbo.dr18_catalog_to_catwise2020  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_catwise2020_version_id_idx ON dbo.dr18_catalog_to_catwise2020  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_glimpse_best_idx ON dbo.dr18_catalog_to_glimpse  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_glimpse_catalogid_idx ON dbo.dr18_catalog_to_glimpse  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_glimpse_target_id_idx ON dbo.dr18_catalog_to_glimpse  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_glimpse_version_id_idx ON dbo.dr18_catalog_to_glimpse  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_guvcat_best_idx ON dbo.dr18_catalog_to_guvcat  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_guvcat_catalogid_idx ON dbo.dr18_catalog_to_guvcat  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_guvcat_target_id_idx ON dbo.dr18_catalog_to_guvcat  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_guvcat_version_id_idx ON dbo.dr18_catalog_to_guvcat  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_legacy_survey_dr8_best_idx ON dbo.dr18_catalog_to_legacy_survey_dr8  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_legacy_survey_dr8_catalogid_idx ON dbo.dr18_catalog_to_legacy_survey_dr8  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_legacy_survey_dr8_target_id_idx ON dbo.dr18_catalog_to_legacy_survey_dr8  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_legacy_survey_dr8_version_id_idx ON dbo.dr18_catalog_to_legacy_survey_dr8  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_panstarrs1_best_idx ON dbo.dr18_catalog_to_panstarrs1  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_panstarrs1_catalogid_idx ON dbo.dr18_catalog_to_panstarrs1  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_panstarrs1_target_id_idx ON dbo.dr18_catalog_to_panstarrs1  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_panstarrs1_version_id_idx ON dbo.dr18_catalog_to_panstarrs1  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_sdss_dr13_photoobj_primary_best_idx ON dbo.dr18_catalog_to_sdss_dr13_photoobj_primary  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_sdss_dr13_photoobj_primary_catalogid_idx ON dbo.dr18_catalog_to_sdss_dr13_photoobj_primary  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_sdss_dr13_photoobj_primary_target_id_idx ON dbo.dr18_catalog_to_sdss_dr13_photoobj_primary  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_sdss_dr13_photoobj_primary_version_id_idx ON dbo.dr18_catalog_to_sdss_dr13_photoobj_primary  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_sdss_dr16_specobj_best_idx ON dbo.dr18_catalog_to_sdss_dr16_specobj  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_sdss_dr16_specobj_catalogid_idx ON dbo.dr18_catalog_to_sdss_dr16_specobj  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_sdss_dr16_specobj_target_id_idx ON dbo.dr18_catalog_to_sdss_dr16_specobj  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_sdss_dr16_specobj_version_id_idx ON dbo.dr18_catalog_to_sdss_dr16_specobj  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_skies_v2_best_idx ON dbo.dr18_catalog_to_skies_v2  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_skies_v2_catalogid_idx ON dbo.dr18_catalog_to_skies_v2  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_skies_v2_target_id_idx ON dbo.dr18_catalog_to_skies_v2  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_skies_v2_version_id_idx ON dbo.dr18_catalog_to_skies_v2  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_skymapper_dr2_best_idx ON dbo.dr18_catalog_to_skymapper_dr2  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_skymapper_dr2_catalogid_idx ON dbo.dr18_catalog_to_skymapper_dr2  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_skymapper_dr2_target_id_idx ON dbo.dr18_catalog_to_skymapper_dr2  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_skymapper_dr2_version_id_idx ON dbo.dr18_catalog_to_skymapper_dr2  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_supercosmos_best_idx ON dbo.dr18_catalog_to_supercosmos  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_supercosmos_catalogid_idx ON dbo.dr18_catalog_to_supercosmos  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_supercosmos_target_id_idx ON dbo.dr18_catalog_to_supercosmos  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_supercosmos_version_id_idx ON dbo.dr18_catalog_to_supercosmos  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_tic_v8_best_idx ON dbo.dr18_catalog_to_tic_v8  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_tic_v8_catalogid_idx ON dbo.dr18_catalog_to_tic_v8  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_tic_v8_target_id_idx ON dbo.dr18_catalog_to_tic_v8  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_tic_v8_version_id_idx ON dbo.dr18_catalog_to_tic_v8  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_tycho2_best_idx ON dbo.dr18_catalog_to_tycho2  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_tycho2_catalogid_idx ON dbo.dr18_catalog_to_tycho2  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_tycho2_target_id_idx ON dbo.dr18_catalog_to_tycho2  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_tycho2_version_id_idx ON dbo.dr18_catalog_to_tycho2  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_uvotssc1_best_idx ON dbo.dr18_catalog_to_uvotssc1  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_uvotssc1_catalogid_idx ON dbo.dr18_catalog_to_uvotssc1  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_uvotssc1_target_id_idx ON dbo.dr18_catalog_to_uvotssc1  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_uvotssc1_version_id_idx ON dbo.dr18_catalog_to_uvotssc1  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_xmm_om_suss_4_1_best_idx ON dbo.dr18_catalog_to_xmm_om_suss_4_1  (best);


CREATE NONCLUSTERED INDEX dr18_catalog_to_xmm_om_suss_4_1_catalogid_idx ON dbo.dr18_catalog_to_xmm_om_suss_4_1  (catalogid);


CREATE NONCLUSTERED INDEX dr18_catalog_to_xmm_om_suss_4_1_target_id_idx ON dbo.dr18_catalog_to_xmm_om_suss_4_1  (target_id);


CREATE NONCLUSTERED INDEX dr18_catalog_to_xmm_om_suss_4_1_version_id_idx ON dbo.dr18_catalog_to_xmm_om_suss_4_1  (version_id);


CREATE NONCLUSTERED INDEX dr18_catalog_version_id_idx ON dbo.dr18_catalog  (version_id);


CREATE NONCLUSTERED INDEX dr18_catwise2020_source_name_idx ON dbo.dr18_catwise2020  (source_name);


CREATE NONCLUSTERED INDEX dr18_catwise2020_w1mpro_idx ON dbo.dr18_catwise2020  (w1mpro);


CREATE NONCLUSTERED INDEX dr18_catwise2020_w1sigmpro_idx ON dbo.dr18_catwise2020  (w1sigmpro);


CREATE NONCLUSTERED INDEX dr18_catwise2020_w2mpro_idx ON dbo.dr18_catwise2020  (w2mpro);


CREATE NONCLUSTERED INDEX dr18_catwise2020_w2sigmpro_idx ON dbo.dr18_catwise2020  (w2sigmpro);


CREATE NONCLUSTERED INDEX dr18_ebosstarget_v5_eboss_target1_idx ON dbo.dr18_ebosstarget_v5  (eboss_target1);


CREATE NONCLUSTERED INDEX dr18_ebosstarget_v5_objc_type_idx ON dbo.dr18_ebosstarget_v5  (objc_type);


CREATE NONCLUSTERED INDEX dr18_ebosstarget_v5_objid_targeting_idx ON dbo.dr18_ebosstarget_v5  (objid_targeting);


CREATE NONCLUSTERED INDEX dr18_ebosstarget_v5_resolve_status_idx ON dbo.dr18_ebosstarget_v5  (resolve_status);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_ruwe_ruwe_idx ON dbo.dr18_gaia_dr2_ruwe  (ruwe);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_source_astrometric_chi2_al_idx ON dbo.dr18_gaia_dr2_source  (astrometric_chi2_al);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_source_astrometric_excess_noise_idx ON dbo.dr18_gaia_dr2_source  (astrometric_excess_noise);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_source_bp_rp_idx ON dbo.dr18_gaia_dr2_source  (bp_rp);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_source_expr_idx ON dbo.dr18_gaia_dr2_source  (((parallax - parallax_error)));


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_source_parallax_idx ON dbo.dr18_gaia_dr2_source  (parallax);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_source_phot_bp_mean_flux_over_error_idx ON dbo.dr18_gaia_dr2_source  (phot_bp_mean_flux_over_error);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_source_phot_bp_mean_mag_idx ON dbo.dr18_gaia_dr2_source  (phot_bp_mean_mag);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_source_phot_rp_mean_mag_idx ON dbo.dr18_gaia_dr2_source  (phot_rp_mean_mag);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_wd_gmag_idx ON dbo.dr18_gaia_dr2_wd  (gmag);


CREATE NONCLUSTERED INDEX dr18_gaia_dr2_wd_pwd_idx ON dbo.dr18_gaia_dr2_wd  (pwd);


CREATE NONCLUSTERED INDEX dr18_gaia_unwise_agn_g_idx ON dbo.dr18_gaia_unwise_agn  (g);


CREATE NONCLUSTERED INDEX dr18_gaia_unwise_agn_prob_rf_idx ON dbo.dr18_gaia_unwise_agn  (prob_rf);


CREATE NONCLUSTERED INDEX dr18_gaia_unwise_agn_unwise_objid_idx ON dbo.dr18_gaia_unwise_agn  (unwise_objid);


CREATE NONCLUSTERED INDEX dr18_gaiadr2_tmass_best_neighbour_angular_distance_idx ON dbo.dr18_gaiadr2_tmass_best_neighbour  (angular_distance);


CREATE NONCLUSTERED INDEX dr18_gaiadr2_tmass_best_neighbour_source_id_idx ON dbo.dr18_gaiadr2_tmass_best_neighbour  (source_id);


CREATE NONCLUSTERED INDEX dr18_gaiadr2_tmass_best_neighbour_tmass_pts_key_idx ON dbo.dr18_gaiadr2_tmass_best_neighbour  (tmass_pts_key);


CREATE NONCLUSTERED INDEX dr18_geometric_distances_gaia_dr2_r_est_idx ON dbo.dr18_geometric_distances_gaia_dr2  (r_est);


CREATE NONCLUSTERED INDEX dr18_geometric_distances_gaia_dr2_r_hi_idx ON dbo.dr18_geometric_distances_gaia_dr2  (r_hi);


CREATE NONCLUSTERED INDEX dr18_geometric_distances_gaia_dr2_r_len_idx ON dbo.dr18_geometric_distances_gaia_dr2  (r_len);


CREATE NONCLUSTERED INDEX dr18_geometric_distances_gaia_dr2_r_lo_idx ON dbo.dr18_geometric_distances_gaia_dr2  (r_lo);


CREATE NONCLUSTERED INDEX dr18_glimpse_designation_idx ON dbo.dr18_glimpse  (designation);


CREATE NONCLUSTERED INDEX dr18_glimpse_tmass_cntr_idx ON dbo.dr18_glimpse  (tmass_cntr);


CREATE NONCLUSTERED INDEX dr18_glimpse_tmass_designation_idx ON dbo.dr18_glimpse  (tmass_designation);


CREATE NONCLUSTERED INDEX dr18_guvcat_expr_idx ON dbo.dr18_guvcat  (((fuv_mag - nuv_mag)));


CREATE NONCLUSTERED INDEX dr18_guvcat_fuv_mag_idx ON dbo.dr18_guvcat  (fuv_mag);


CREATE NONCLUSTERED INDEX dr18_guvcat_nuv_mag_idx ON dbo.dr18_guvcat  (nuv_mag);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_fibertotflux_g_idx ON dbo.dr18_legacy_survey_dr8  (fibertotflux_g);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_fibertotflux_r_idx ON dbo.dr18_legacy_survey_dr8  (fibertotflux_r);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_fibertotflux_z_idx ON dbo.dr18_legacy_survey_dr8  (fibertotflux_z);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_flux_g_idx ON dbo.dr18_legacy_survey_dr8  (flux_g);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_flux_r_idx ON dbo.dr18_legacy_survey_dr8  (flux_r);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_flux_w1_idx ON dbo.dr18_legacy_survey_dr8  (flux_w1);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_flux_z_idx ON dbo.dr18_legacy_survey_dr8  (flux_z);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_gaia_phot_g_mean_mag_idx ON dbo.dr18_legacy_survey_dr8  (gaia_phot_g_mean_mag);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_gaia_phot_g_mean_mag_idx1 ON dbo.dr18_legacy_survey_dr8  (gaia_phot_g_mean_mag);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_gaia_phot_rp_mean_mag_idx ON dbo.dr18_legacy_survey_dr8  (gaia_phot_rp_mean_mag);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_gaia_sourceid_idx ON dbo.dr18_legacy_survey_dr8  (gaia_sourceid);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_maskbits_idx ON dbo.dr18_legacy_survey_dr8  (maskbits);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_nobs_g_idx ON dbo.dr18_legacy_survey_dr8  (nobs_g);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_nobs_r_idx ON dbo.dr18_legacy_survey_dr8  (nobs_r);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_nobs_z_idx ON dbo.dr18_legacy_survey_dr8  (nobs_z);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_parallax_idx ON dbo.dr18_legacy_survey_dr8  (parallax);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_ref_cat_idx ON dbo.dr18_legacy_survey_dr8  (ref_cat);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_ref_epoch_idx ON dbo.dr18_legacy_survey_dr8  (ref_epoch);


CREATE NONCLUSTERED INDEX dr18_legacy_survey_dr8_ref_id_idx ON dbo.dr18_legacy_survey_dr8  (ref_id);


CREATE NONCLUSTERED INDEX dr18_magnitude_carton_to_target_pk_idx ON dbo.dr18_magnitude  (carton_to_target_pk);


CREATE NONCLUSTERED INDEX dr18_magnitude_h_idx ON dbo.dr18_magnitude  (h);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_extid_hi_lo_idx ON dbo.dr18_panstarrs1  (extid_hi_lo);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_flags_idx ON dbo.dr18_panstarrs1  (flags);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_g_flags_idx ON dbo.dr18_panstarrs1  (g_flags);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_g_stk_psf_flux_idx ON dbo.dr18_panstarrs1  (g_stk_psf_flux);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_i_flags_idx ON dbo.dr18_panstarrs1  (i_flags);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_i_stk_psf_flux_idx ON dbo.dr18_panstarrs1  (i_stk_psf_flux);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_r_flags_idx ON dbo.dr18_panstarrs1  (r_flags);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_r_stk_psf_flux_idx ON dbo.dr18_panstarrs1  (r_stk_psf_flux);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_stargal_idx ON dbo.dr18_panstarrs1  (stargal);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_z_flags_idx ON dbo.dr18_panstarrs1  (z_flags);


CREATE NONCLUSTERED INDEX dr18_panstarrs1_z_stk_psf_flux_idx ON dbo.dr18_panstarrs1  (z_stk_psf_flux);


CREATE NONCLUSTERED INDEX dr18_sagitta_av_idx ON dbo.dr18_sagitta  (av);


CREATE NONCLUSTERED INDEX dr18_sagitta_yso_idx ON dbo.dr18_sagitta  (yso);


CREATE NONCLUSTERED INDEX dr18_sagitta_yso_std_idx ON dbo.dr18_sagitta  (yso_std);


CREATE NONCLUSTERED INDEX dr18_sdss_apogeeallstarmerge_r13_h_idx ON dbo.dr18_sdss_apogeeallstarmerge_r13  (h);


CREATE NONCLUSTERED INDEX dr18_sdss_apogeeallstarmerge_r13_j_idx ON dbo.dr18_sdss_apogeeallstarmerge_r13  (j);


CREATE NONCLUSTERED INDEX dr18_sdss_apogeeallstarmerge_r13_k_idx ON dbo.dr18_sdss_apogeeallstarmerge_r13  (k);


CREATE NONCLUSTERED INDEX dr18_sdss_dr13_photoobj_primary_objid_idx ON dbo.dr18_sdss_dr13_photoobj_primary  (objid);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_qso_fiberid_idx ON dbo.dr18_sdss_dr16_qso  (fiberid);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_qso_mjd_idx ON dbo.dr18_sdss_dr16_qso  (mjd);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_qso_mjd_plate_fiberid_idx ON dbo.dr18_sdss_dr16_qso  (mjd, plate, fiberid);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_qso_plate_idx ON dbo.dr18_sdss_dr16_qso  (plate);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_bestobjid_idx ON dbo.dr18_sdss_dr16_specobj  (bestobjid);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_fiberid_idx ON dbo.dr18_sdss_dr16_specobj  (fiberid);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_fluxobjid_idx ON dbo.dr18_sdss_dr16_specobj  (fluxobjid);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_mjd_idx ON dbo.dr18_sdss_dr16_specobj  (mjd);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_plate_idx ON dbo.dr18_sdss_dr16_specobj  (plate);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_run2d_idx ON dbo.dr18_sdss_dr16_specobj  (run2d);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_scienceprimary_idx ON dbo.dr18_sdss_dr16_specobj  (scienceprimary);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_snmedian_idx ON dbo.dr18_sdss_dr16_specobj  (snmedian);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_targetobjid_idx ON dbo.dr18_sdss_dr16_specobj  (targetobjid);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_z_idx ON dbo.dr18_sdss_dr16_specobj  (z);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_zerr_idx ON dbo.dr18_sdss_dr16_specobj  (zerr);


CREATE NONCLUSTERED INDEX dr18_sdss_dr16_specobj_zwarning_idx ON dbo.dr18_sdss_dr16_specobj  (zwarning);


CREATE NONCLUSTERED INDEX dr18_skies_v2_down_pix_idx ON dbo.dr18_skies_v2  (down_pix);


CREATE NONCLUSTERED INDEX dr18_skies_v2_mag_neighbour_gaia_idx ON dbo.dr18_skies_v2  (mag_neighbour_gaia);


CREATE NONCLUSTERED INDEX dr18_skies_v2_mag_neighbour_ls8_idx ON dbo.dr18_skies_v2  (mag_neighbour_ls8);


CREATE NONCLUSTERED INDEX dr18_skies_v2_mag_neighbour_ps1dr2_idx ON dbo.dr18_skies_v2  (mag_neighbour_ps1dr2);


CREATE NONCLUSTERED INDEX dr18_skies_v2_mag_neighbour_tmass_idx ON dbo.dr18_skies_v2  (mag_neighbour_tmass);


CREATE NONCLUSTERED INDEX dr18_skies_v2_mag_neighbour_tycho2_idx ON dbo.dr18_skies_v2  (mag_neighbour_tycho2);


CREATE NONCLUSTERED INDEX dr18_skies_v2_sep_neighbour_gaia_idx ON dbo.dr18_skies_v2  (sep_neighbour_gaia);


CREATE NONCLUSTERED INDEX dr18_skies_v2_sep_neighbour_ls8_idx ON dbo.dr18_skies_v2  (sep_neighbour_ls8);


CREATE NONCLUSTERED INDEX dr18_skies_v2_sep_neighbour_ps1dr2_idx ON dbo.dr18_skies_v2  (sep_neighbour_ps1dr2);


CREATE NONCLUSTERED INDEX dr18_skies_v2_sep_neighbour_tmass_idx ON dbo.dr18_skies_v2  (sep_neighbour_tmass);


CREATE NONCLUSTERED INDEX dr18_skies_v2_sep_neighbour_tmass_xsc_idx ON dbo.dr18_skies_v2  (sep_neighbour_tmass_xsc);


CREATE NONCLUSTERED INDEX dr18_skies_v2_sep_neighbour_tycho2_idx ON dbo.dr18_skies_v2  (sep_neighbour_tycho2);


CREATE NONCLUSTERED INDEX dr18_skies_v2_tile_32_idx ON dbo.dr18_skies_v2  (tile_32);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_allwise_cntr_idx ON dbo.dr18_skymapper_dr2  (allwise_cntr);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_flags_psf_idx ON dbo.dr18_skymapper_dr2  (flags_psf);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_g_psf_idx ON dbo.dr18_skymapper_dr2  (g_psf);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_gaia_dr2_id1_idx ON dbo.dr18_skymapper_dr2  (gaia_dr2_id1);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_gaia_dr2_id2_idx ON dbo.dr18_skymapper_dr2  (gaia_dr2_id2);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_i_psf_idx ON dbo.dr18_skymapper_dr2  (i_psf);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_nimaflags_idx ON dbo.dr18_skymapper_dr2  (nimaflags);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_r_psf_idx ON dbo.dr18_skymapper_dr2  (r_psf);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_smss_j_idx ON dbo.dr18_skymapper_dr2  (smss_j);


CREATE NONCLUSTERED INDEX dr18_skymapper_dr2_z_psf_idx ON dbo.dr18_skymapper_dr2  (z_psf);


CREATE NONCLUSTERED INDEX dr18_supercosmos_classb_idx ON dbo.dr18_supercosmos  (classb);


CREATE NONCLUSTERED INDEX dr18_supercosmos_classi_idx ON dbo.dr18_supercosmos  (classi);


CREATE NONCLUSTERED INDEX dr18_supercosmos_classmagb_idx ON dbo.dr18_supercosmos  (classmagb);


CREATE NONCLUSTERED INDEX dr18_supercosmos_classmagi_idx ON dbo.dr18_supercosmos  (classmagi);


CREATE NONCLUSTERED INDEX dr18_supercosmos_classmagr1_idx ON dbo.dr18_supercosmos  (classmagr1);


CREATE NONCLUSTERED INDEX dr18_supercosmos_classmagr2_idx ON dbo.dr18_supercosmos  (classmagr2);


CREATE NONCLUSTERED INDEX dr18_supercosmos_classr1_idx ON dbo.dr18_supercosmos  (classr1);


CREATE NONCLUSTERED INDEX dr18_supercosmos_classr2_idx ON dbo.dr18_supercosmos  (classr2);


CREATE NONCLUSTERED INDEX dr18_target_catalogid_idx ON dbo.dr18_target  (catalogid);


CREATE NONCLUSTERED INDEX dr18_target_q3c_ang2ipix_idx ON dbo.dr18_target  (public.q3c_ang2ipix(ra, "dec"));


CREATE NONCLUSTERED INDEX dr18_tic_v8_allwise_idx ON dbo.dr18_tic_v8  (allwise);


CREATE NONCLUSTERED INDEX dr18_tic_v8_gaia_int_idx ON dbo.dr18_tic_v8  (gaia_int);


CREATE NONCLUSTERED INDEX dr18_tic_v8_gaiamag_idx ON dbo.dr18_tic_v8  (gaiamag);


CREATE NONCLUSTERED INDEX dr18_tic_v8_hmag_idx ON dbo.dr18_tic_v8  (hmag);


CREATE NONCLUSTERED INDEX dr18_tic_v8_kic_idx ON dbo.dr18_tic_v8  (kic);


CREATE NONCLUSTERED INDEX dr18_tic_v8_logg_idx ON dbo.dr18_tic_v8  (logg);


CREATE NONCLUSTERED INDEX dr18_tic_v8_objtype_idx ON dbo.dr18_tic_v8  (objtype);


CREATE NONCLUSTERED INDEX dr18_tic_v8_plx_idx ON dbo.dr18_tic_v8  (plx);


CREATE NONCLUSTERED INDEX dr18_tic_v8_posflag_idx ON dbo.dr18_tic_v8  (posflag);


CREATE NONCLUSTERED INDEX dr18_tic_v8_sdss_idx ON dbo.dr18_tic_v8  (sdss);


CREATE NONCLUSTERED INDEX dr18_tic_v8_teff_idx ON dbo.dr18_tic_v8  (teff);


CREATE NONCLUSTERED INDEX dr18_tic_v8_tmag_idx ON dbo.dr18_tic_v8  (tmag);


CREATE NONCLUSTERED INDEX dr18_tic_v8_twomass_psc_idx ON dbo.dr18_tic_v8  (twomass_psc);


CREATE NONCLUSTERED INDEX dr18_tic_v8_twomass_psc_pts_key_idx ON dbo.dr18_tic_v8  (twomass_psc_pts_key);


CREATE NONCLUSTERED INDEX dr18_tic_v8_tycho2_tycid_idx ON dbo.dr18_tic_v8  (tycho2_tycid);


CREATE NONCLUSTERED INDEX dr18_twomass_psc_cc_flg_idx ON dbo.dr18_twomass_psc  (cc_flg);


CREATE NONCLUSTERED INDEX dr18_twomass_psc_designation_idx1 ON dbo.dr18_twomass_psc  (designation);


CREATE NONCLUSTERED INDEX dr18_twomass_psc_gal_contam_idx ON dbo.dr18_twomass_psc  (gal_contam);


CREATE NONCLUSTERED INDEX dr18_twomass_psc_jdate_idx ON dbo.dr18_twomass_psc  (jdate);


CREATE NONCLUSTERED INDEX dr18_twomass_psc_ph_qual_idx ON dbo.dr18_twomass_psc  (ph_qual);


CREATE NONCLUSTERED INDEX dr18_twomass_psc_rd_flg_idx ON dbo.dr18_twomass_psc  (rd_flg);


CREATE NONCLUSTERED INDEX dr18_tycho2_btmag_idx ON dbo.dr18_tycho2  (btmag);


CREATE NONCLUSTERED INDEX dr18_tycho2_tycid_idx ON dbo.dr18_tycho2  (tycid);


CREATE NONCLUSTERED INDEX dr18_tycho2_vtmag_idx ON dbo.dr18_tycho2  (vtmag);


CREATE NONCLUSTERED INDEX dr18_uvotssc1_name_idx ON dbo.dr18_uvotssc1  (name);


CREATE NONCLUSTERED INDEX dr18_uvotssc1_obsid_idx ON dbo.dr18_uvotssc1  (obsid);


CREATE NONCLUSTERED INDEX dr18_uvotssc1_srcid_idx ON dbo.dr18_uvotssc1  (srcid);


CREATE NONCLUSTERED INDEX dr18_xmm_om_suss_4_1_iauname_idx ON dbo.dr18_xmm_om_suss_4_1  (iauname);


CREATE NONCLUSTERED INDEX dr18_yso_clustering_bp_idx ON dbo.dr18_yso_clustering  (bp);


CREATE NONCLUSTERED INDEX dr18_yso_clustering_g_idx ON dbo.dr18_yso_clustering  (g);


CREATE NONCLUSTERED INDEX dr18_yso_clustering_h_idx ON dbo.dr18_yso_clustering  (h);


CREATE NONCLUSTERED INDEX dr18_yso_clustering_j_idx ON dbo.dr18_yso_clustering  (j);


CREATE NONCLUSTERED INDEX dr18_yso_clustering_k_idx ON dbo.dr18_yso_clustering  (k);


CREATE NONCLUSTERED INDEX dr18_yso_clustering_rp_idx ON dbo.dr18_yso_clustering  (rp);


CREATE NONCLUSTERED INDEX dr18_zari18pms_bp_over_rp_idx ON dbo.dr18_zari18pms  (bp_over_rp);


CREATE NONCLUSTERED INDEX dr18_zari18pms_bp_rp_idx ON dbo.dr18_zari18pms  (bp_rp);


CREATE NONCLUSTERED INDEX dr18_zari18pms_bpmag_idx ON dbo.dr18_zari18pms  (bpmag);


CREATE NONCLUSTERED INDEX dr18_zari18pms_gmag_idx ON dbo.dr18_zari18pms  (gmag);


CREATE NONCLUSTERED INDEX dr18_zari18pms_rpmag_idx ON dbo.dr18_zari18pms  (rpmag);


CREATE NONCLUSTERED INDEX dr18_zari18pms_source_idx ON dbo.dr18_zari18pms  (source);
