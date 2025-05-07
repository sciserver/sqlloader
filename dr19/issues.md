# DR19 Loading - Nov 2024

## General notes

The minidb now contains 108 tables.  Converting the postgres schema to t-sql went smoothly using the pg2mssql.py script.  

**Question: should we prefix these tables with 'mos_' like we did for dr18?**

## Specific issues
### column names / types

- dr19_opsdb_apo_exposure
  - start_time was "timestamp without time zone" type.  Changed it to datetime (timestamp in t-sql means something different)
  
- dr19_sdssv_boss_conflist
  - there is a column named "public" which is a reserved word in t-sql.  For now I put [brackets] around it so i could create the table, but we should change it to something else. **what should i rename 'public' to**


-  dr19_design
   -  assignment_hash column had type uuid, changed to uniqueidentifier


### indexes

--CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_expr_idx ON dbo.dr19_gaia_dr2_source  (((parallax - parallax_error)));


--CREATE NONCLUSTERED INDEX dr19_allwise_expr_idx ON dbo.dr19_allwise  (((w1mpro - w2mpro)));

--CREATE NONCLUSTERED INDEX dr19_guvcat_expr_idx ON dbo.dr19_guvcat  (((fuv_mag - nuv_mag)));

Can't have math in indexes in sql server.  I can create persisted computed columns for these values and add them to the corresponding table and put an index on that column.  **For DR18 I named the columns like 'parallax_parallax_error', does that still work?**

### loading

- dr19_field.csv - Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 2, column 9 (field_id).
    - there was some issue with the quotes and commas.  was able to load fine using the SSMS import flat file GUI so I did that rather than mess around with bulk insert for an hour

-  dr19_mwm_tess_ob - Msg 4863, Level 16, State 1, Line 1 Bulk load data conversion error (truncation) for row 2, column 5 (instrument).
   -  changed instrument and cadence columns from varchar(1) to varchar(20), loaded fine
  

-  dr19_sdss_apogeeallstarmerge_r13
   -  problem with quotes / commas
   -  changed visits to varchar(1500)
   -  changed apstarid to varchar(1000)
   -  loaded fine w import flat file


## TODO:
- get schema / table / column descriptions
- load with data compression
- add htmid, cx, cy, cz to all tables with ra/dec?


### new tables 1/22/2025

- no pk for sdss_id_to_catalog?   assumed it was 
ALTER TABLE dbo.dr19_sdss_id_to_catalog
    ADD CONSTRAINT dr19_sdss_id_to_catalog_pkey PRIMARY KEY CLUSTERED (pk);

-CREATE TABLE dbo.dr19_allstar_dr17_synspec_rev1 (
    file varchar(500),

    changing to filename

    - [aspcapflag] bigint, changed to varchar(500)
    - [frac_badpix] real, changed to varchar(500)

### Tables loaded 1/30/2025

Wasn't able to add the qc3_ang2ipix index as it's a postgresql thing. 53 tables affected.  

Need to figure out a solution here using htmid or zones or something? Create a more generic cone search function?

 H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(18):--CREATE NONCLUSTERED INDEX dr19_allwise_q3c_ang2ipix_idx ON dbo.dr19_allwise  (public.q3c_ang2ipix((ra)::double precision, ("dec")::double precision));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(72):--CREATE NONCLUSTERED INDEX dr19_bhm_csc_q3c_ang2ipix_idx ON dbo.dr19_bhm_csc  (public.q3c_ang2ipix(oir_ra, oir_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(99):--CREATE NONCLUSTERED INDEX dr19_bhm_csc_v2_q3c_ang2ipix_idx ON dbo.dr19_bhm_csc_v2  (public.q3c_ang2ipix(xra, xdec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(111):--CREATE NONCLUSTERED INDEX dr19_bhm_efeds_veto_q3c_ang2ipix_idx ON dbo.dr19_bhm_efeds_veto  (public.q3c_ang2ipix(plug_ra, plug_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(144):--CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_q3c_ang2ipix_idx ON dbo.dr19_bhm_rm_tweaks  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(147):--CREATE NONCLUSTERED INDEX dr19_bhm_rm_tweaks_q3c_ang2ipix_idx1 ON dbo.dr19_bhm_rm_tweaks  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(171):--CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_2_q3c_ang2ipix_idx ON dbo.dr19_bhm_rm_v0_2  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(198):--CREATE NONCLUSTERED INDEX dr19_bhm_rm_v0_q3c_ang2ipix_idx ON dbo.dr19_bhm_rm_v0  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(219):--CREATE NONCLUSTERED INDEX dr19_bhm_spiders_agn_superset_q3c_ang2ipix_idx ON dbo.dr19_bhm_spiders_agn_superset  (public.q3c_ang2ipix(opt_ra, opt_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(231):--CREATE NONCLUSTERED INDEX dr19_bhm_spiders_clusters_superset_q3c_ang2ipix_idx ON dbo.dr19_bhm_spiders_clusters_superset  (public.q3c_ang2ipix(opt_ra, opt_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(261):--CREATE NONCLUSTERED INDEX dr19_cataclysmic_variables_q3c_ang2ipix_idx ON dbo.dr19_cataclysmic_variables  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(267):--CREATE NONCLUSTERED INDEX dr19_catalog_q3c_ang2ipix_idx ON dbo.dr19_catalog  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(918):--CREATE NONCLUSTERED INDEX dr19_catwise2020_q3c_ang2ipix_idx ON dbo.dr19_catwise2020  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(921):--CREATE NONCLUSTERED INDEX dr19_catwise2020_q3c_ang2ipix_idx1 ON dbo.dr19_catwise2020  (public.q3c_ang2ipix(ra_pm, dec_pm));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(957):--CREATE NONCLUSTERED INDEX dr19_ebosstarget_v5_q3c_ang2ipix_idx ON dbo.dr19_ebosstarget_v5  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(984):--CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_q3c_ang2ipix_idx ON dbo.dr19_erosita_superset_agn  (public.q3c_ang2ipix(opt_ra, opt_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(987):--CREATE NONCLUSTERED INDEX dr19_erosita_superset_agn_q3c_ang2ipix_idx1 ON dbo.dr19_erosita_superset_agn  (public.q3c_ang2ipix(ero_ra, ero_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1011):--CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_q3c_ang2ipix_idx ON dbo.dr19_erosita_superset_clusters  (public.q3c_ang2ipix(opt_ra, opt_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1014):--CREATE NONCLUSTERED INDEX dr19_erosita_superset_clusters_q3c_ang2ipix_idx1 ON dbo.dr19_erosita_superset_clusters  (public.q3c_ang2ipix(ero_ra, ero_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1038):--CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_q3c_ang2ipix_idx ON dbo.dr19_erosita_superset_compactobjects  (public.q3c_ang2ipix(opt_ra, opt_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1041):--CREATE NONCLUSTERED INDEX dr19_erosita_superset_compactobjects_q3c_ang2ipix_idx1 ON dbo.dr19_erosita_superset_compactobjects  (public.q3c_ang2ipix(ero_ra, ero_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1065):--CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_q3c_ang2ipix_idx ON dbo.dr19_erosita_superset_stars  (public.q3c_ang2ipix(opt_ra, opt_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1068):--CREATE NONCLUSTERED INDEX dr19_erosita_superset_stars_q3c_ang2ipix_idx1 ON dbo.dr19_erosita_superset_stars  (public.q3c_ang2ipix(ero_ra, ero_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1110):--CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_q3c_ang2ipix_idx ON dbo.dr19_gaia_dr2_source  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1119):--CREATE NONCLUSTERED INDEX dr19_gaia_dr2_wd_q3c_ang2ipix_idx ON dbo.dr19_gaia_dr2_wd  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1128):--CREATE NONCLUSTERED INDEX dr19_gaia_unwise_agn_q3c_ang2ipix_idx ON dbo.dr19_gaia_unwise_agn  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1158):--CREATE NONCLUSTERED INDEX dr19_glimpse_q3c_ang2ipix_idx ON dbo.dr19_glimpse  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1176):--CREATE NONCLUSTERED INDEX dr19_guvcat_q3c_ang2ipix_idx ON dbo.dr19_guvcat  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1233):--CREATE NONCLUSTERED INDEX dr19_legacy_survey_dr8_q3c_ang2ipix_idx ON dbo.dr19_legacy_survey_dr8  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1434):--CREATE NONCLUSTERED INDEX dr19_mipsgal_q3c_ang2ipix_idx ON dbo.dr19_mipsgal  (public.q3c_ang2ipix(radeg, dedeg));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1443):--CREATE NONCLUSTERED INDEX dr19_mwm_tess_ob_q3c_ang2ipix_idx ON dbo.dr19_mwm_tess_ob  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1446):--CREATE NONCLUSTERED INDEX dr19_mwm_tess_ob_q3c_ang2ipix_idx1 ON dbo.dr19_mwm_tess_ob  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1479):--CREATE NONCLUSTERED INDEX dr19_panstarrs1_q3c_ang2ipix_idx ON dbo.dr19_panstarrs1  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1506):--CREATE NONCLUSTERED INDEX dr19_sagitta_q3c_ang2ipix_idx ON dbo.dr19_sagitta  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1524):--CREATE NONCLUSTERED INDEX dr19_sdss_apogeeallstarmerge_r13_q3c_ang2ipix_idx ON dbo.dr19_sdss_apogeeallstarmerge_r13  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1527):--CREATE NONCLUSTERED INDEX dr19_sdss_apogeeallstarmerge_r13_q3c_ang2ipix_idx1 ON dbo.dr19_sdss_apogeeallstarmerge_r13  (public.q3c_ang2ipix(glon, glat));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1533):--CREATE NONCLUSTERED INDEX dr19_sdss_dr13_photoobj_primary_q3c_ang2ipix_idx ON dbo.dr19_sdss_dr13_photoobj_primary  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1563):--CREATE NONCLUSTERED INDEX dr19_sdss_dr16_specobj_q3c_ang2ipix_idx ON dbo.dr19_sdss_dr16_specobj  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1611):--CREATE NONCLUSTERED INDEX dr19_sdss_dr17_specobj_q3c_ang2ipix_idx ON dbo.dr19_sdss_dr17_specobj  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1632):--CREATE NONCLUSTERED INDEX dr19_sdss_id_flat_q3c_ang2ipix_idx ON dbo.dr19_sdss_id_flat  (public.q3c_ang2ipix(ra_sdss_id, dec_sdss_id));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1635):--CREATE NONCLUSTERED INDEX dr19_sdss_id_flat_q3c_ang2ipix_idx1 ON dbo.dr19_sdss_id_flat  (public.q3c_ang2ipix(ra_catalogid, dec_catalogid));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1647):--CREATE NONCLUSTERED INDEX dr19_sdss_id_stacked_q3c_ang2ipix_idx ON dbo.dr19_sdss_id_stacked  (public.q3c_ang2ipix(ra_sdss_id, dec_sdss_id));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1764):--CREATE NONCLUSTERED INDEX dr19_sdssv_boss_conflist_q3c_ang2ipix_idx ON dbo.dr19_sdssv_boss_conflist  (public.q3c_ang2ipix(racen, deccen));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1800):--CREATE NONCLUSTERED INDEX dr19_sdssv_boss_spall_q3c_ang2ipix_idx ON dbo.dr19_sdssv_boss_spall  (public.q3c_ang2ipix(plug_ra, plug_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1848):--CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_meta_q3c_ang2ipix_idx ON dbo.dr19_sdssv_plateholes_meta  (public.q3c_ang2ipix(racen, deccen));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1851):--CREATE NONCLUSTERED INDEX dr19_sdssv_plateholes_q3c_ang2ipix_idx ON dbo.dr19_sdssv_plateholes  (public.q3c_ang2ipix(target_ra, target_dec));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1887):--CREATE NONCLUSTERED INDEX dr19_skies_v1_q3c_ang2ipix_idx ON dbo.dr19_skies_v1  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1926):--CREATE NONCLUSTERED INDEX dr19_skies_v2_q3c_ang2ipix_idx ON dbo.dr19_skies_v2  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(1971):--CREATE NONCLUSTERED INDEX dr19_skymapper_dr2_q3c_ang2ipix_idx ON dbo.dr19_skymapper_dr2  (public.q3c_ang2ipix(raj2000, dej2000));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2016):--CREATE NONCLUSTERED INDEX dr19_supercosmos_q3c_ang2ipix_idx ON dbo.dr19_supercosmos  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2088):--CREATE NONCLUSTERED INDEX dr19_tic_v8_q3c_ang2ipix_idx ON dbo.dr19_tic_v8  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2124):--CREATE NONCLUSTERED INDEX dr19_twomass_psc_q3c_ang2ipix_idx ON dbo.dr19_twomass_psc  (public.q3c_ang2ipix(ra, decl));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2133):--CREATE NONCLUSTERED INDEX dr19_tycho2_q3c_ang2ipix_idx ON dbo.dr19_tycho2  (public.q3c_ang2ipix(ramdeg, demdeg));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2136):--CREATE NONCLUSTERED INDEX dr19_tycho2_q3c_ang2ipix_idx1 ON dbo.dr19_tycho2  (public.q3c_ang2ipix(radeg, dedeg));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2151):--CREATE NONCLUSTERED INDEX dr19_unwise_q3c_ang2ipix_idx ON dbo.dr19_unwise  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2160):--CREATE NONCLUSTERED INDEX dr19_uvotssc1_q3c_ang2ipix_idx ON dbo.dr19_uvotssc1  (public.q3c_ang2ipix(radeg, dedeg));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2169):--CREATE NONCLUSTERED INDEX dr19_xmm_om_suss_4_1_q3c_ang2ipix_idx ON dbo.dr19_xmm_om_suss_4_1  (public.q3c_ang2ipix(ra, "dec"));
  H:\GitHub\sqlloader\dr19\mssql_indexes_01222025.sql(2187):--CREATE NONCLUSTERED INDEX dr19_yso_clustering_q3c_ang2ipix_idx ON dbo.dr19_yso_clustering  (public.q3c_ang2ipix(ra, "dec"));


  ## other (math in indexes):

  --CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_expr_idx ON dbo.dr19_gaia_dr2_source  (((parallax - parallax_error)));  
    dropped and recreated added peristed computed column parallax_parallax_error

  --CREATE NONCLUSTERED INDEX dr19_guvcat_expr_idx ON dbo.dr19_guvcat  (((fuv_mag - nuv_mag)));
  added fuv_mag_nuv_mag

  --CREATE NONCLUSTERED INDEX dr19_allwise_expr_idx ON dbo.dr19_allwise  (((w1mpro - w2mpro)));


  reload these 3 tables AND catalog_to_gaia_dr2_source


looks like some PKS are missing??

DROPPING AND RELOADING EVERYTHING



where is this table???
--ALTER TABLE  dbo.dr19_legacy_catalog_catalogid
--    ADD CONSTRAINT dr19_legacy_catalog_catalogid_pkey PRIMARY KEY CLUSTERED (catalogid) 


## ON RELOAD

had to change bulk insert statement for dr19_field
TRUNCATE TABLE dr19_field;BULK INSERT dr19_field FROM 'e:\DR19\mos_target-csv\minidb_dr19.dr19_field.csv' WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK, FIELDQUOTE = '"');


null or not null?

CREATE TABLE [dbo].[dr19_catalog_to_sdss_dr17_specobj](
	[catalogid] [bigint] NOT NULL,
	[target_id] [numeric](20, 0) NOT NULL,
	[version_id] [smallint] NOT NULL,
	[distance] [float] NULL,
	[best] [bit] NULL,
	[planname_id] [varchar](500) NULL,
	[added_by_phase] [smallint] NULL
) ON [PRIMARY]


CREATE TABLE [dbo].[dr19_catalog_to_twomass_psc](
	[catalogid] [bigint] NOT NULL,
	[target_id] [int] NOT NULL,
	[version_id] [smallint] NOT NULL,
	[distance] [float] NULL,
	[best] [bit] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[dr19_marvels_dr11_star](

  CREATE TABLE [dbo].[dr19_mwm_tess_ob](

  why all the varchar(1) columns


## foreign keys
ALTER TABLE  dbo.dr19_catalog_to_bhm_csc
    ADD CONSTRAINT dr19_catalog_to_bhm_csc_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_bhm_csc(pk);


	select target_id from dr19_catalog_to_bhm_csc
	where target_id not in (select pk from dr19_bhm_csc)

gives:

target_id
30857
30857

ALTER TABLE  dbo.dr19_catalog_to_bhm_efeds_veto
    ADD CONSTRAINT dr19_catalog_to_bhm_efeds_veto_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_bhm_efeds_veto(pk);

	select target_id from dr19_catalog_to_bhm_efeds_veto
	where target_id not in (select pk from dr19_bhm_efeds_veto)

  1342
1973
1973
2002
2002
2842
2842
3386
3386
3449
3449
4210
4210
4264
4264
5301
5664
5664

--ALTER TABLE  dbo.dr19_catalog_to_catwise2020
--    ADD CONSTRAINT dr19_catalog_to_catwise2020_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_catwise2020(source_id);


--	select target_id from dr19_catalog_to_catwise2020
--	where target_id not in (select source_id from dr19_catwise2020)

gives almost 3m rows


ALTER TABLE  dbo.dr19_catalog_to_glimpse
    ADD CONSTRAINT dr19_catalog_to_glimpse_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_glimpse(pk);

	select target_id from dr19_catalog_to_glimpse
	where target_id not in (select pk from  dr19_glimpse)

  12krows


## after reload

ALTER TABLE  dbo.dr19_carton
    ADD CONSTRAINT dr19_carton_target_selection_plan_fkey FOREIGN KEY (target_selection_plan) REFERENCES dbo.dr19_targetdb_version(planname);




ALTER TABLE  dbo.dr19_catalog_to_mangatarget
    ADD CONSTRAINT dr19_catalog_to_mangatarget_target_id_fkey FOREIGN KEY (target_id) REFERENCES dbo.dr19_mangatarget(mangaid);


    catalog_to_mastar_goodstars: change target_id from varchar(255) to varchar(25)

    actually maybe i should change mangatarget.mangaid to varchar(255) instead.


    

  
  


  




  


