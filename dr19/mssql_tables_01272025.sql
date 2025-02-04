

DROP TABLE IF EXISTS dbo.dr19_catalog_to_sdss_dr17_specobj(
CREATE TABLE dbo.dr19_catalog_to_sdss_dr17_specobj(
catalogid bigint not null,
target_id numeric(20, 0) not null,
version_id smallint not null,
distance double precision,
best bit not null,
planname_id varchar(500),
added_by_phase smallint
);
