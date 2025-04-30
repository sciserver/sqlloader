ALTER TABLE  dbo.dr19_sdss_id_flat
    ADD CONSTRAINT dr19_sdss_id_flat_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_sdss_id_stacked
    ADD CONSTRAINT dr19_sdss_id_stacked_pkey PRIMARY KEY CLUSTERED (sdss_id);

    ALTER TABLE  dbo.dr19_allstar_dr17_synspec_rev1
    ADD CONSTRAINT dr19_allstar_dr17_synspec_rev1_pkey PRIMARY KEY CLUSTERED (apstar_id);

ALTER TABLE  dbo.dr19_catalog_to_allstar_dr17_synspec_rev1
    ADD CONSTRAINT dr19_catalog_to_allstar_dr17_synspec_rev1_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);

ALTER TABLE  dbo.dr19_catalog_to_mangatarget
    ADD CONSTRAINT dr19_catalog_to_mangatarget_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_marvels_dr11_star
    ADD CONSTRAINT dr19_catalog_to_marvels_dr11_star_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_marvels_dr12_star
    ADD CONSTRAINT dr19_catalog_to_marvels_dr12_star_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_mastar_goodstars
    ADD CONSTRAINT dr19_catalog_to_mastar_goodstars_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);

ALTER TABLE  dbo.dr19_catalog_to_sdss_dr16_specobj
    ADD CONSTRAINT dr19_catalog_to_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);


ALTER TABLE  dbo.dr19_catalog_to_sdss_dr17_specobj
    ADD CONSTRAINT dr19_catalog_to_sdss_dr17_specobj_pkey PRIMARY KEY CLUSTERED (version_id, catalogid, target_id);

ALTER TABLE  dbo.dr19_mangadapall
    ADD CONSTRAINT dr19_mangadapall_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_mangadrpall
    ADD CONSTRAINT dr19_mangadrpall_pkey PRIMARY KEY CLUSTERED (mangaid, plate);


ALTER TABLE  dbo.dr19_mangatarget
    ADD CONSTRAINT dr19_mangatarget_pkey PRIMARY KEY CLUSTERED (mangaid);

ALTER TABLE  dbo.dr19_marvels_dr11_star
    ADD CONSTRAINT dr19_marvels_dr11_star_pkey PRIMARY KEY CLUSTERED (starname);


ALTER TABLE  dbo.dr19_marvels_dr12_star
    ADD CONSTRAINT dr19_marvels_dr12_star_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_mastar_goodstars
    ADD CONSTRAINT dr19_mastar_goodstars_pkey PRIMARY KEY CLUSTERED (mangaid);


ALTER TABLE  dbo.dr19_mastar_goodvisits
    ADD CONSTRAINT dr19_mastar_goodvisits_pkey PRIMARY KEY CLUSTERED (pk);


ALTER TABLE  dbo.dr19_sdss_dr16_specobj
    ADD CONSTRAINT dr19_sdss_dr16_specobj_pkey PRIMARY KEY CLUSTERED (specobjid);


ALTER TABLE  dbo.dr19_sdss_dr17_specobj
    ADD CONSTRAINT dr19_sdss_dr17_specobj_pkey PRIMARY KEY CLUSTERED (specobjid);

ALTER TABLE dbo.dr19_sdss_id_to_catalog
    ADD CONSTRAINT dr19_sdss_id_to_catalog_pkey PRIMARY KEY CLUSTERED (pk);
    


