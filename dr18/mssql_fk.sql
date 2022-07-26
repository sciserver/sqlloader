

ALTER TABLE  dbo.dr18_best_brightest
    ADD CONSTRAINT dr18_best_brightest_cntr_fkey FOREIGN KEY (cntr) REFERENCES dbo.dr18_allwise(cntr);


ALTER TABLE  dbo.dr18_bhm_csc_v2
    ADD CONSTRAINT dr18_bhm_csc_v2_designation2m_fkey FOREIGN KEY (designation2m) REFERENCES dbo.dr18_twomass_psc(designation);


ALTER TABLE  dbo.dr18_bhm_csc_v2
    ADD CONSTRAINT dr18_bhm_csc_v2_idg2_fkey FOREIGN KEY (idg2) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_cataclysmic_variables
    ADD CONSTRAINT dr18_cataclysmic_variables_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_catalog_to_allwise
    ADD CONSTRAINT dr18_catalog_to_allwise_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_allwise(cntr);


ALTER TABLE  dbo.dr18_catalog_to_bhm_efeds_veto
    ADD CONSTRAINT dr18_catalog_to_bhm_efeds_veto_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_bhm_efeds_veto(pk);


ALTER TABLE  dbo.dr18_catalog_to_bhm_rm_v0_2
    ADD CONSTRAINT dr18_catalog_to_bhm_rm_v0_2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_bhm_rm_v0_2(pk);


ALTER TABLE  dbo.dr18_catalog_to_catwise2020
    ADD CONSTRAINT dr18_catalog_to_catwise2020_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_catwise2020(source_id);


ALTER TABLE  dbo.dr18_catalog_to_glimpse
    ADD CONSTRAINT dr18_catalog_to_glimpse_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_glimpse(pk);


ALTER TABLE  dbo.dr18_catalog_to_guvcat
    ADD CONSTRAINT dr18_catalog_to_guvcat_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_guvcat(objid);


ALTER TABLE  dbo.dr18_catalog_to_legacy_survey_dr8
    ADD CONSTRAINT dr18_catalog_to_legacy_survey_dr8_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_legacy_survey_dr8(ls_id);


ALTER TABLE  dbo.dr18_catalog_to_panstarrs1
    ADD CONSTRAINT dr18_catalog_to_panstarrs1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_panstarrs1(catid_objid);


ALTER TABLE  dbo.dr18_catalog_to_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr18_catalog_to_sdss_dr13_photoobj_primary_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_sdss_dr13_photoobj_primary(objid);


ALTER TABLE  dbo.dr18_catalog_to_sdss_dr16_specobj
    ADD CONSTRAINT dr18_catalog_to_sdss_dr16_specobj_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_sdss_dr16_specobj(specobjid);


ALTER TABLE  dbo.dr18_catalog_to_skies_v2
    ADD CONSTRAINT dr18_catalog_to_skies_v2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_skies_v2(pix_32768);


ALTER TABLE  dbo.dr18_catalog_to_skymapper_dr2
    ADD CONSTRAINT dr18_catalog_to_skymapper_dr2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_skymapper_dr2(object_id);


ALTER TABLE  dbo.dr18_catalog_to_supercosmos
    ADD CONSTRAINT dr18_catalog_to_supercosmos_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_supercosmos(objid);


ALTER TABLE  dbo.dr18_catalog_to_tic_v8
    ADD CONSTRAINT dr18_catalog_to_tic_v8_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_tic_v8(id);


ALTER TABLE  dbo.dr18_catalog_to_tycho2
    ADD CONSTRAINT dr18_catalog_to_tycho2_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_tycho2(designation);


ALTER TABLE  dbo.dr18_catalog_to_uvotssc1
    ADD CONSTRAINT dr18_catalog_to_uvotssc1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_uvotssc1(id);


ALTER TABLE  dbo.dr18_catalog_to_xmm_om_suss_4_1
    ADD CONSTRAINT dr18_catalog_to_xmm_om_suss_4_1_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr18_xmm_om_suss_4_1(pk);


ALTER TABLE  dbo.dr18_ebosstarget_v5
    ADD CONSTRAINT dr18_ebosstarget_v5_objid_targeting_fkey FOREIGN KEY (objid_targeting) REFERENCES dbo.dr18_sdss_dr13_photoobj_primary(objid);


ALTER TABLE  dbo.dr18_gaia_dr2_ruwe
    ADD CONSTRAINT dr18_gaia_dr2_ruwe_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_gaia_dr2_wd
    ADD CONSTRAINT dr18_gaia_dr2_wd_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_gaia_unwise_agn
    ADD CONSTRAINT dr18_gaia_unwise_agn_gaia_sourceid_fkey FOREIGN KEY (gaia_sourceid) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr18_gaiadr2_tmass_best_neighbour_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr18_gaiadr2_tmass_best_neighbour_tmass_pts_key_fkey FOREIGN KEY (tmass_pts_key) REFERENCES dbo.dr18_twomass_psc(pts_key);


ALTER TABLE  dbo.dr18_geometric_distances_gaia_dr2
    ADD CONSTRAINT dr18_geometric_distances_gaia_dr2_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_sagitta
    ADD CONSTRAINT dr18_sagitta_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_sdss_apogeeallstarmerge_r13
    ADD CONSTRAINT dr18_sdss_apogeeallstarmerge_r13_designation_fkey FOREIGN KEY (designation) REFERENCES dbo.dr18_twomass_psc(designation);


ALTER TABLE  dbo.dr18_sdss_dr16_qso
    ADD CONSTRAINT dr18_sdss_dr16_qso_plate_fiberid_mjd_fkey FOREIGN KEY (plate, fiberid, mjd) REFERENCES dbo.dr18_sdss_dr16_specobj(plate, fiberid, mjd);


ALTER TABLE  dbo.dr18_tic_v8
    ADD CONSTRAINT dr18_tic_v8_gaia_int_fkey FOREIGN KEY (gaia_int) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_tic_v8
    ADD CONSTRAINT dr18_tic_v8_twomass_psc_fkey FOREIGN KEY (twomass_psc) REFERENCES dbo.dr18_twomass_psc(designation);


ALTER TABLE  dbo.dr18_yso_clustering
    ADD CONSTRAINT dr18_yso_clustering_source_id_fkey FOREIGN KEY (source_id) REFERENCES dbo.dr18_gaia_dr2_source(source_id);


ALTER TABLE  dbo.dr18_zari18pms
    ADD CONSTRAINT dr18_zari18pms_source_fkey FOREIGN KEY (source) REFERENCES dbo.dr18_gaia_dr2_source(source_id);
