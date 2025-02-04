

ALTER TABLE dbo.dr19_catalog_to_sdss_dr17_specobj 
    ADD CONSTRAINT pk_catalog_to_sdss_dr17_specobj (version_id, catalogid, target_id) PRIMARY KEY CLUSTERED;
