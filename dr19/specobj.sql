CREATE TABLE minidb_dr19.dr19_catalog_to_sdss_dr17_specobj(
catalogid bigint not null,
target_id numeric(20, 0) not null,
version_id smallint not null,
distance double precision,
best boolean not null,
plan_id text,
added_by_phase smallint
);

ALTER TABLE minidb_dr19.dr19_catalog_to_sdss_dr17_specobj 
    ADD CONSTRAINT pk_catalog_to_sdss_dr17_specobj (version_id, catalogid, target_id) PRIMARY KEY;

CREATE INDEX on minidb_dr19.dr19_catalog_to_sdss_dr17_specobj(catalogid);
CREATE INDEX on minidb_dr19.dr19_catalog_to_sdss_dr17_specobj(target_id);
CREATE INDEX on minidb_dr19.dr19_catalog_to_sdss_dr17_specobj(version_id);

ALTER TABLE minidb_dr19.dr19_catalog_to_sdss_dr17_specobj ADD FOREIGN KEY (target_id) REFERENCES minidb_dr19.dr19_sdss_dr17_specobj(specobjid);