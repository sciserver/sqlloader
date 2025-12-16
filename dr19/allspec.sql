drop table if exists allspec


CREATE TABLE [dbo].[allspec](
	[allspec_id] [varchar](128) NOT NULL primary key clustered,
	[multiplex_id] [varchar](40) NOT NULL,
	[sdss_phase] [smallint] NOT NULL,
	[observatory] [varchar](10) NOT NULL,
	[instrument] [varchar](10) NOT NULL,
	[sdss_id] [bigint] NOT NULL,
	[catalogid] [bigint] NOT NULL,
	[fiberid] [int] NOT NULL,
	[ifudsgn] [smallint] NOT NULL,
	[plate] [int] NOT NULL,
	[fps_field] [int] NOT NULL,
	[plate_or_fps_field] [int] NOT NULL,
	[mjd] [int] NOT NULL,
	[run2d] [varchar](10) NOT NULL,
	[run1d] [varchar](10) NOT NULL,
	[coadd] [varchar](10) NOT NULL,
	[apred_vers] [varchar](10) NOT NULL,
	[drpver] [varchar](10) NOT NULL,
	[version] [varchar](10) NOT NULL,
	[programname] [varchar](40) NOT NULL,
	[survey] [varchar](40) NOT NULL,
	[sas_file] [varchar](50) NOT NULL,
	[cas_url] [varchar](256) NOT NULL,
	[sas_url] [varchar](256) NOT NULL,
	[ra] [float] NOT NULL,
	[dec] [float] NOT NULL,
	[healpix] [int] NOT NULL,
	[healpixgrp] [smallint] NOT NULL,
	[apogee_id] [varchar](32) NOT NULL,
	[apogee_field] [varchar](32) NOT NULL,
	[telescope] [varchar](10) NOT NULL,
	[file_spec] [varchar](10) NOT NULL,
	[apstar_id] [varchar](60) NOT NULL,
	[visit_id] [varchar](40) NOT NULL,
	[mangaid] [varchar](10) NOT NULL,
	[specobjid] [numeric](30)  NULL,
	[htmid] as dbo.fHtmEq(ra, dec) persisted,
	[cx] float null,
	[cy] float null,
	[cz] float null 
) ON [SPEC]
GO

insert allspec with (tablock)
SELECT [allspec_id]
      ,[multiplex_id]
      ,[sdss_phase]
      ,[observatory]
      ,[instrument]
      ,[sdss_id]
      ,[catalogid]
      ,[fiberid]
      ,[ifudsgn]
      ,[plate]
      ,[fps_field]
      ,[plate_or_fps_field]
      ,[mjd]
      ,[run2d]
      ,[run1d]
      ,[coadd]
      ,[apred_vers]
      ,[drpver]
      ,[version]
      ,[programname]
      ,[survey]
      ,[sas_file]
      ,[cas_url]
      ,[sas_url]
      ,[ra]
      ,[dec]
      ,[healpix]
      ,[healpixgrp]
      ,[apogee_id]
      ,[apogee_field]
      ,[telescope]
      ,[file_spec]
      ,[apstar_id]
      ,[visit_id]
      ,[mangaid]
      , cast(nullif(specobjid, '') as numeric(30))
	  ,null
	  ,null
	  ,null
  FROM BESTTEST.[dbo].[allspec]

GO


select top 10 * from allspec


  update a
  set 
	cx = f.x,
	cy = f.y,
	cz = f.z
	from allspec a
	cross apply dbo.fHtmEqToXyz(ra, dec) f


	create nonclustered index ix_allspec_htmid
	on allspec(htmid) INCLUDE (cx, cy, cz)

	create nonclustered index ix_allspec_sdssid
	on allspec(sdss_id)

	create nonclustered index ix_allspec_specobjid
	on allspec(specobjid)

	create nonclustered index ix_mjd_fiberid_plate_or_fps_field
	on allspec(mjd, fiberid, plate_or_fps_field)

	create nonclustered index ix_allspec_mangaid
	on allspec(mangaid)

	create nonclustered index ix_allspec_apogee_id
	on allspec(apogee_id)

	create nonclustered index ix_allspec_apstar_id
	on allspec(apstar_id)