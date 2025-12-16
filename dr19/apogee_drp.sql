USE [BestDR19]
GO

/****** Object:  Table [dbo].[apogee_drp_allstar]    Script Date: 6/26/2025 12:44:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

drop table if exists BestDR19.dbo.apogee_drp_allstar
go

CREATE TABLE [dbo].[apogee_drp_allstar](
	[PK] [bigint] NOT NULL,
	[APOGEE_ID] [varchar](28) NULL,
	[FILE] [varchar](57) NULL,
	[URI] [varchar](106) NULL,
	[STARVER] [varchar](15) NULL,
	[MJDBEG] [bigint] NULL,
	[MJDEND] [bigint] NULL,
	[TELESCOPE] [varchar](16) NULL,
	[APRED_VERS] [varchar](13) NULL,
	[V_APRED] [varchar](50) NULL,
	[HEALPIX] [bigint] NULL,
	[SNR] [real] NULL,
	[RA] [float] NULL,
	[DEC] [float] NULL,
	[GLON] [float] NULL,
	[GLAT] [float] NULL,
	[JMAG] [real] NULL,
	[JERR] [real] NULL,
	[HMAG] [real] NULL,
	[HERR] [real] NULL,
	[KMAG] [real] NULL,
	[KERR] [real] NULL,
	[SRC_H] [varchar](10) NULL,
	[TARG_PMRA] [real] NULL,
	[TARG_PMDEC] [real] NULL,
	[TARG_PM_SRC] [varchar](10) NULL,
	[APOGEE_TARGET1] [bigint] NULL,
	[APOGEE_TARGET2] [bigint] NULL,
	[APOGEE2_TARGET1] [bigint] NULL,
	[APOGEE2_TARGET2] [bigint] NULL,
	[APOGEE2_TARGET3] [bigint] NULL,
	[APOGEE2_TARGET4] [bigint] NULL,
	[CATALOGID] [decimal](18, 0) NULL,
	[SDSS_ID] [bigint] NULL,
	[GAIA_RELEASE] [varchar](14) NULL,
	[GAIA_SOURCEID] [bigint] NULL,
	[GAIA_PLX] [real] NULL,
	[GAIA_PLX_ERROR] [real] NULL,
	[GAIA_PMRA] [real] NULL,
	[GAIA_PMRA_ERROR] [real] NULL,
	[GAIA_PMDEC] [real] NULL,
	[GAIA_PMDEC_ERROR] [real] NULL,
	[GAIA_GMAG] [real] NULL,
	[GAIA_GERR] [real] NULL,
	[GAIA_BPMAG] [real] NULL,
	[GAIA_BPERR] [real] NULL,
	[GAIA_RPMAG] [real] NULL,
	[GAIA_RPERR] [real] NULL,
	[SDSSV_APOGEE_TARGET0] [bigint] NULL,
	[FIRSTCARTON] [varchar](50) NULL,
	[CADENCE] [varchar](10) NULL,
	[PROGRAM] [varchar](10) NULL,
	[CATEGORY] [varchar](10) NULL,
	[TARGFLAGS] [varchar](113) NULL,
	[NVISITS] [bigint] NULL,
	[NGOODVISITS] [bigint] NULL,
	[NGOODRVS] [bigint] NULL,
	[STARFLAG] [bigint] NULL,
	[STARFLAGS] [varchar](91) NULL,
	[ANDFLAG] [bigint] NULL,
	[ANDFLAGS] [varchar](10) NULL,
	[VRAD] [real] NULL,
	[VSCATTER] [real] NULL,
	[VERR] [real] NULL,
	[VMEDERR] [real] NULL,
	[CHISQ] [real] NULL,
	[RV_TEFF] [real] NULL,
	[RV_TEFFERR] [real] NULL,
	[RV_LOGG] [real] NULL,
	[RV_LOGGERR] [real] NULL,
	[RV_FEH] [real] NULL,
	[RV_FEHERR] [real] NULL,
	[RV_CCPFWHM] [real] NULL,
	[RV_AUTOFWHM] [real] NULL,
	[N_COMPONENTS] [bigint] NULL,
	[MEANFIB] [real] NULL,
	[SIGFIB] [real] NULL,
	[htmid] as dbo.fhtmeq(ra, dec) persisted,
	[cx] float null,
	[cy] float null,
	[cz] float null

 CONSTRAINT [pk_apogee_drp_allstar_PK] PRIMARY KEY CLUSTERED 
(
	[PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SPEC]
) ON [SPEC]
GO




/****** Object:  Table [dbo].[apogee_drp_allvisit]    Script Date: 6/26/2025 12:47:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

drop table if exists BestDR19.dbo.apogee_drp_allvisit

CREATE TABLE [dbo].[apogee_drp_allvisit](
	[APOGEE_ID] [varchar](28) NULL,
	[TARGET_ID] [varchar](28) NULL,
	[APRED_VERS] [varchar](13) NULL,
	[FILE] [varchar](49) NOT NULL,
	[URI] [varchar](122) NULL,
	[FIBERID] [bigint] NULL,
	[PLATE] [varchar](15) NULL,
	[MJD] [bigint] NULL,
	[TELESCOPE] [varchar](16) NULL,
	[SURVEY] [varchar](23) NULL,
	[FIELD] [varchar](32) NULL,
	[PROGRAMNAME] [varchar](57) NULL,
	[RA] [float] NULL,
	[DEC] [float] NULL,
	[GLON] [float] NULL,
	[GLAT] [float] NULL,
	[JMAG] [float] NULL,
	[JERR] [float] NULL,
	[HMAG] [float] NULL,
	[HERR] [float] NULL,
	[KMAG] [float] NULL,
	[KERR] [float] NULL,
	[SRC_H] [varchar](10) NULL,
	[PMRA] [float] NULL,
	[PMDEC] [float] NULL,
	[PM_SRC] [varchar](10) NULL,
	[APOGEE_TARGET1] [bigint] NULL,
	[APOGEE_TARGET2] [bigint] NULL,
	[APOGEE_TARGET3] [bigint] NULL,
	[APOGEE_TARGET4] [bigint] NULL,
	[CATALOGID] [decimal](18, 0) NULL,
	[SDSS_ID] [bigint] NULL,
	[GAIA_RELEASE] [varchar](14) NULL,
	[GAIA_PLX] [float] NULL,
	[GAIA_PLX_ERROR] [float] NULL,
	[GAIA_PMRA] [float] NULL,
	[GAIA_PMRA_ERROR] [float] NULL,
	[GAIA_PMDEC] [float] NULL,
	[GAIA_PMDEC_ERROR] [float] NULL,
	[GAIA_GMAG] [float] NULL,
	[GAIA_GERR] [float] NULL,
	[GAIA_BPMAG] [float] NULL,
	[GAIA_BPERR] [float] NULL,
	[GAIA_RPMAG] [float] NULL,
	[GAIA_RPERR] [float] NULL,
	[SDSSV_APOGEE_TARGET0] [bigint] NULL,
	[FIRSTCARTON] [varchar](50) NULL,
	[TARGFLAGS] [varchar](113) NULL,
	[SNR] [float] NULL,
	[STARFLAG] [bigint] NULL,
	[STARFLAGS] [varchar](84) NULL,
	[DATEOBS] [varchar](33) NULL,
	[JD] [float] NULL,
	[STARVER] [varchar](15) NULL,
	[BC] [float] NULL,
	[VTYPE] [bigint] NULL,
	[VREL] [float] NULL,
	[VRELERR] [float] NULL,
	[VRAD] [float] NULL,
	[CHISQ] [float] NULL,
	[RV_TEFF] [float] NULL,
	[RV_LOGG] [float] NULL,
	[RV_FEH] [float] NULL,
	[XCORR_VREL] [float] NULL,
	[XCORR_VRELERR] [float] NULL,
	[XCORR_VRAD] [float] NULL,
	[N_COMPONENTS] [bigint] NULL,
	[RV_COMPONENTS_0] [float] NULL,
	[RV_COMPONENTS_1] [float] NULL,
	[RV_COMPONENTS_2] [float] NULL,
 CONSTRAINT [pk_apogee_drp_allvisit_FILE] PRIMARY KEY CLUSTERED 
(
	[FILE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SPEC]
) ON [SPEC]
GO


---=====================
insert BestDR19.dbo.apogee_drp_allstar with (tablock)
SELECT [PK]
      ,[APOGEE_ID]
      ,[FILE]
      ,[URI]
      ,[STARVER]
      ,[MJDBEG]
      ,[MJDEND]
      ,[TELESCOPE]
      ,[APRED_VERS]
      ,[V_APRED]
      ,[HEALPIX]
      ,[SNR]
      ,[RA]
      ,[DEC]
      ,[GLON]
      ,[GLAT]
      ,[JMAG]
      ,[JERR]
      ,[HMAG]
      ,[HERR]
      ,[KMAG]
      ,[KERR]
      ,[SRC_H]
      ,[TARG_PMRA]
      ,[TARG_PMDEC]
      ,[TARG_PM_SRC]
      ,[APOGEE_TARGET1]
      ,[APOGEE_TARGET2]
      ,[APOGEE2_TARGET1]
      ,[APOGEE2_TARGET2]
      ,[APOGEE2_TARGET3]
      ,[APOGEE2_TARGET4]
      ,[CATALOGID]
      ,[SDSS_ID]
      ,[GAIA_RELEASE]
      ,[GAIA_SOURCEID]
      ,[GAIA_PLX]
      ,[GAIA_PLX_ERROR]
      ,[GAIA_PMRA]
      ,[GAIA_PMRA_ERROR]
      ,[GAIA_PMDEC]
      ,[GAIA_PMDEC_ERROR]
      ,[GAIA_GMAG]
      ,[GAIA_GERR]
      ,[GAIA_BPMAG]
      ,[GAIA_BPERR]
      ,[GAIA_RPMAG]
      ,[GAIA_RPERR]
      ,[SDSSV_APOGEE_TARGET0]
      ,[FIRSTCARTON]
      ,[CADENCE]
      ,[PROGRAM]
      ,[CATEGORY]
      ,[TARGFLAGS]
      ,[NVISITS]
      ,[NGOODVISITS]
      ,[NGOODRVS]
      ,[STARFLAG]
      ,[STARFLAGS]
      ,[ANDFLAG]
      ,[ANDFLAGS]
      ,[VRAD]
      ,[VSCATTER]
      ,[VERR]
      ,[VMEDERR]
      ,[CHISQ]
      ,[RV_TEFF]
      ,[RV_TEFFERR]
      ,[RV_LOGG]
      ,[RV_LOGGERR]
      ,[RV_FEH]
      ,[RV_FEHERR]
      ,[RV_CCPFWHM]
      ,[RV_AUTOFWHM]
      ,[N_COMPONENTS]
      ,[MEANFIB]
      ,[SIGFIB]
     -- ,null
      ,null
      ,null
      ,null
  FROM [BESTTEST].dbo.[apogee_drp_allstar]


  update a
  set 
	cx = f.x,
	cy = f.y,
	cz = f.z
	from apogee_drp_allstar a
	cross apply dbo.fHtmEqToXyz(ra, dec) f


	create nonclustered index [ix_apogee_drp_allstar_htmid]
	on apogee_drp_allstar(htmid) INCLUDE (cx, cy,  cz)


	create nonclustered index [ix_apogee_drp_allstar_apogee_id]
	on apogee_drp_allstar(apogee_id)


---=================
insert apogee_drp_allvisit with (tablock)
select * from BESTTEST.dbo.apogee_drp_allvisit

	create nonclustered index [ix_apogee_drp_allvisit_apogee_id]
	on apogee_drp_allvisit(apogee_id)



