

ALTER TABLE  dbo.mos_allwise
    ADD CONSTRAINT mos_allwise_pkey PRIMARY KEY CLUSTERED (cntr) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_best_brightest
    ADD CONSTRAINT mos_best_brightest_pkey PRIMARY KEY CLUSTERED (cntr) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_bhm_csc_v2
    ADD CONSTRAINT mos_bhm_csc_v2_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_bhm_efeds_veto
    ADD CONSTRAINT mos_bhm_efeds_veto_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_bhm_rm_v0_2
    ADD CONSTRAINT mos_bhm_rm_v0_2_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_cadence_epoch
    ADD CONSTRAINT mos_cadence_epoch_pkey PRIMARY KEY CLUSTERED (label, epoch) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_cadence
    ADD CONSTRAINT mos_cadence_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_carton
    ADD CONSTRAINT mos_carton_pkey PRIMARY KEY CLUSTERED (carton_pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_carton_to_target
    ADD CONSTRAINT mos_carton_to_target_pkey PRIMARY KEY CLUSTERED (carton_to_target_pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_cataclysmic_variables
    ADD CONSTRAINT mos_cataclysmic_variables_pkey PRIMARY KEY CLUSTERED (ref_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_catalog
    ADD CONSTRAINT mos_catalog_pkey PRIMARY KEY CLUSTERED (catalogid) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_category
    ADD CONSTRAINT mos_category_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_catwise2020
    ADD CONSTRAINT mos_catwise2020_pkey PRIMARY KEY CLUSTERED (source_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_ebosstarget_v5
    ADD CONSTRAINT mos_ebosstarget_v5_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_gaia_dr2_ruwe
    ADD CONSTRAINT mos_gaia_dr2_ruwe_pkey PRIMARY KEY CLUSTERED (source_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_gaia_dr2_source
    ADD CONSTRAINT mos_gaia_dr2_source_pkey PRIMARY KEY CLUSTERED (source_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_gaia_dr2_wd
    ADD CONSTRAINT mos_gaia_dr2_wd_pkey PRIMARY KEY CLUSTERED (source_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_gaia_unwise_agn
    ADD CONSTRAINT mos_gaia_unwise_agn_pkey PRIMARY KEY CLUSTERED (gaia_sourceid) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT mos_gaiadr2_tmass_best_neighbour_pkey PRIMARY KEY CLUSTERED (source_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_geometric_distances_gaia_dr2
    ADD CONSTRAINT mos_geometric_distances_gaia_dr2_pkey PRIMARY KEY CLUSTERED (source_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_glimpse
    ADD CONSTRAINT mos_glimpse_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_guvcat
    ADD CONSTRAINT mos_guvcat_pkey PRIMARY KEY CLUSTERED (objid) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_instrument
    ADD CONSTRAINT mos_instrument_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_legacy_survey_dr8
    ADD CONSTRAINT mos_legacy_survey_dr8_pkey PRIMARY KEY CLUSTERED (ls_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_magnitude
    ADD CONSTRAINT mos_magnitude_pkey PRIMARY KEY CLUSTERED (magnitude_pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_mapper
    ADD CONSTRAINT mos_mapper_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_panstarrs1
    ADD CONSTRAINT mos_panstarrs1_pkey PRIMARY KEY CLUSTERED (catid_objid) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_sagitta
    ADD CONSTRAINT mos_sagitta_pkey PRIMARY KEY CLUSTERED (source_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_sdss_apogeeallstarmerge_r13
    ADD CONSTRAINT mos_sdss_apogeeallstarmerge_r13_pkey PRIMARY KEY CLUSTERED (apogee_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_sdss_dr13_photoobj_primary
    ADD CONSTRAINT mos_sdss_dr13_photoobj_primary_pkey PRIMARY KEY CLUSTERED (objid) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_sdss_dr16_qso
    ADD CONSTRAINT mos_sdss_dr16_qso_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_sdss_dr16_specobj
    ADD CONSTRAINT mos_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (specobjid) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_skies_v2
    ADD CONSTRAINT mos_skies_v2_pkey PRIMARY KEY CLUSTERED (pix_32768) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_skymapper_dr2
    ADD CONSTRAINT mos_skymapper_dr2_pkey PRIMARY KEY CLUSTERED (object_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_supercosmos
    ADD CONSTRAINT mos_supercosmos_pkey PRIMARY KEY CLUSTERED (objid) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_target
    ADD CONSTRAINT mos_target_pkey PRIMARY KEY CLUSTERED (target_pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_tic_v8
    ADD CONSTRAINT mos_tic_v8_pkey PRIMARY KEY CLUSTERED (id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_twomass_psc
    ADD CONSTRAINT mos_twomass_psc_pkey PRIMARY KEY CLUSTERED (pts_key) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_tycho2
    ADD CONSTRAINT mos_tycho2_pkey PRIMARY KEY CLUSTERED (designation) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_uvotssc1
    ADD CONSTRAINT mos_uvotssc1_pkey PRIMARY KEY CLUSTERED (id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_xmm_om_suss_4_1
    ADD CONSTRAINT mos_xmm_om_suss_4_1_pkey PRIMARY KEY CLUSTERED (pk) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_yso_clustering
    ADD CONSTRAINT mos_yso_clustering_pkey PRIMARY KEY CLUSTERED (source_id) with (DATA_COMPRESSION = PAGE) ON [MINIDB]


ALTER TABLE  dbo.mos_zari18pms
    ADD CONSTRAINT mos_zari18pms_pkey PRIMARY KEY CLUSTERED (source) with (DATA_COMPRESSION = PAGE) ON [MINIDB]
