

ALTER TABLE  dbo.dr18_allwise
    ADD CONSTRAINT dr18_allwise_pkey PRIMARY KEY CLUSTERED (cntr);


ALTER TABLE  dbo.dr18_best_brightest
    ADD CONSTRAINT dr18_best_brightest_pkey PRIMARY KEY CLUSTERED (cntr);


ALTER TABLE  dbo.dr18_bhm_csc_v2
    ADD CONSTRAINT dr18_bhm_csc_v2_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_bhm_efeds_veto
    ADD CONSTRAINT dr18_bhm_efeds_veto_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_bhm_rm_v0_2
    ADD CONSTRAINT dr18_bhm_rm_v0_2_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_cadence_epoch
    ADD CONSTRAINT dr18_cadence_epoch_pkey PRIMARY KEY CLUSTERED (label, epoch);


ALTER TABLE  dbo.dr18_cadence
    ADD CONSTRAINT dr18_cadence_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_carton
    ADD CONSTRAINT dr18_carton_pkey PRIMARY KEY CLUSTERED (carton_pk);


ALTER TABLE  dbo.dr18_carton_to_target
    ADD CONSTRAINT dr18_carton_to_target_pkey PRIMARY KEY CLUSTERED (carton_to_target_pk);


ALTER TABLE  dbo.dr18_cataclysmic_variables
    ADD CONSTRAINT dr18_cataclysmic_variables_pkey PRIMARY KEY CLUSTERED (ref_id);


ALTER TABLE  dbo.dr18_catalog
    ADD CONSTRAINT dr18_catalog_pkey PRIMARY KEY CLUSTERED (catalogid);


ALTER TABLE  dbo.dr18_category
    ADD CONSTRAINT dr18_category_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_catwise2020
    ADD CONSTRAINT dr18_catwise2020_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr18_ebosstarget_v5
    ADD CONSTRAINT dr18_ebosstarget_v5_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_gaia_dr2_ruwe
    ADD CONSTRAINT dr18_gaia_dr2_ruwe_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr18_gaia_dr2_source
    ADD CONSTRAINT dr18_gaia_dr2_source_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr18_gaia_dr2_wd
    ADD CONSTRAINT dr18_gaia_dr2_wd_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr18_gaia_unwise_agn
    ADD CONSTRAINT dr18_gaia_unwise_agn_pkey PRIMARY KEY CLUSTERED (gaia_sourceid);


ALTER TABLE  dbo.dr18_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr18_gaiadr2_tmass_best_neighbour_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr18_geometric_distances_gaia_dr2
    ADD CONSTRAINT dr18_geometric_distances_gaia_dr2_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr18_glimpse
    ADD CONSTRAINT dr18_glimpse_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_guvcat
    ADD CONSTRAINT dr18_guvcat_pkey PRIMARY KEY CLUSTERED (objid);


ALTER TABLE  dbo.dr18_instrument
    ADD CONSTRAINT dr18_instrument_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_legacy_survey_dr8
    ADD CONSTRAINT dr18_legacy_survey_dr8_pkey PRIMARY KEY CLUSTERED (ls_id);


ALTER TABLE  dbo.dr18_magnitude
    ADD CONSTRAINT dr18_magnitude_pkey PRIMARY KEY CLUSTERED (magnitude_pk);


ALTER TABLE  dbo.dr18_mapper
    ADD CONSTRAINT dr18_mapper_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_panstarrs1
    ADD CONSTRAINT dr18_panstarrs1_pkey PRIMARY KEY CLUSTERED (catid_objid);


ALTER TABLE  dbo.dr18_sagitta
    ADD CONSTRAINT dr18_sagitta_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr18_sdss_apogeeallstarmerge_r13
    ADD CONSTRAINT dr18_sdss_apogeeallstarmerge_r13_pkey PRIMARY KEY CLUSTERED (apogee_id);


ALTER TABLE  dbo.dr18_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr18_sdss_dr13_photoobj_primary_pkey PRIMARY KEY CLUSTERED (objid);


ALTER TABLE  dbo.dr18_sdss_dr16_qso
    ADD CONSTRAINT dr18_sdss_dr16_qso_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_sdss_dr16_specobj
    ADD CONSTRAINT dr18_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (specobjid);


ALTER TABLE  dbo.dr18_skies_v2
    ADD CONSTRAINT dr18_skies_v2_pkey PRIMARY KEY CLUSTERED (pix_32768);


ALTER TABLE  dbo.dr18_skymapper_dr2
    ADD CONSTRAINT dr18_skymapper_dr2_pkey PRIMARY KEY CLUSTERED (object_id);


ALTER TABLE  dbo.dr18_supercosmos
    ADD CONSTRAINT dr18_supercosmos_pkey PRIMARY KEY CLUSTERED (objid);


ALTER TABLE  dbo.dr18_target
    ADD CONSTRAINT dr18_target_pkey PRIMARY KEY CLUSTERED (target_pk);


ALTER TABLE  dbo.dr18_tic_v8
    ADD CONSTRAINT dr18_tic_v8_pkey PRIMARY KEY CLUSTERED (id);


ALTER TABLE  dbo.dr18_twomass_psc
    ADD CONSTRAINT dr18_twomass_psc_pkey PRIMARY KEY CLUSTERED (pts_key);


ALTER TABLE  dbo.dr18_tycho2
    ADD CONSTRAINT dr18_tycho2_pkey PRIMARY KEY CLUSTERED (designation);


ALTER TABLE  dbo.dr18_uvotssc1
    ADD CONSTRAINT dr18_uvotssc1_pkey PRIMARY KEY CLUSTERED (id);


ALTER TABLE  dbo.dr18_xmm_om_suss_4_1
    ADD CONSTRAINT dr18_xmm_om_suss_4_1_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr18_yso_clustering
    ADD CONSTRAINT dr18_yso_clustering_pkey PRIMARY KEY CLUSTERED (source_id);


ALTER TABLE  dbo.dr18_zari18pms
    ADD CONSTRAINT dr18_zari18pms_pkey PRIMARY KEY CLUSTERED (source);
