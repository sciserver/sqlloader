USE [LamostDR8]
GO
/****** Object:  Table [dbo].[MRS_stellar]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MRS_stellar]') AND type in (N'U'))
DROP TABLE [dbo].[MRS_stellar]
GO
/****** Object:  Table [dbo].[MRS_plan]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MRS_plan]') AND type in (N'U'))
DROP TABLE [dbo].[MRS_plan]
GO
/****** Object:  Table [dbo].[MRS_mec]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MRS_mec]') AND type in (N'U'))
DROP TABLE [dbo].[MRS_mec]
GO
/****** Object:  Table [dbo].[MRS_inputcatalog]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MRS_inputcatalog]') AND type in (N'U'))
DROP TABLE [dbo].[MRS_inputcatalog]
GO
/****** Object:  Table [dbo].[MRS_catalogue]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MRS_catalogue]') AND type in (N'U'))
DROP TABLE [dbo].[MRS_catalogue]
GO
/****** Object:  Table [dbo].[LRS_wd]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_wd]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_wd]
GO
/****** Object:  Table [dbo].[LRS_stellar]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_stellar]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_stellar]
GO
/****** Object:  Table [dbo].[LRS_qso]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_qso]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_qso]
GO
/****** Object:  Table [dbo].[LRS_plan]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_plan]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_plan]
GO
/****** Object:  Table [dbo].[LRS_mstellar]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_mstellar]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_mstellar]
GO
/****** Object:  Table [dbo].[LRS_mec]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_mec]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_mec]
GO
/****** Object:  Table [dbo].[LRS_inputcatalog]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_inputcatalog]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_inputcatalog]
GO
/****** Object:  Table [dbo].[LRS_galaxy]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_galaxy]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_galaxy]
GO
/****** Object:  Table [dbo].[LRS_cv]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_cv]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_cv]
GO
/****** Object:  Table [dbo].[LRS_catalogue]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_catalogue]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_catalogue]
GO
/****** Object:  Table [dbo].[LRS_astellar]    Script Date: 11/23/2022 11:09:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LRS_astellar]') AND type in (N'U'))
DROP TABLE [dbo].[LRS_astellar]
GO
/****** Object:  Table [dbo].[LRS_astellar]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_astellar](
	[obsid] [bigint] not NULL primary key clustered,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snru] [numeric](6, 2) NULL,
	[snrg] [numeric](6, 2) NULL,
	[snrr] [numeric](6, 2) NULL,
	[snri] [numeric](6, 2) NULL,
	[snrz] [numeric](6, 2) NULL,
	[class] [varchar](20) NULL,
	[subclass] [varchar](20) NULL,
	[z] [numeric](21, 10) NULL,
	[z_err] [numeric](21, 10) NULL,
	[ps_id] [bigint] NULL,
	[mag_ps_g] [numeric](16, 10) NULL,
	[mag_ps_r] [numeric](16, 10) NULL,
	[mag_ps_i] [numeric](16, 10) NULL,
	[mag_ps_z] [numeric](16, 10) NULL,
	[mag_ps_y] [numeric](16, 10) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[kp12] [numeric](8, 2) NULL,
	[kp18] [numeric](8, 2) NULL,
	[kp6] [numeric](8, 2) NULL,
	[hdelta12] [numeric](8, 2) NULL,
	[hdelta24] [numeric](8, 2) NULL,
	[hdelta48] [numeric](8, 2) NULL,
	[hdelta64] [numeric](8, 2) NULL,
	[hgamma12] [numeric](8, 2) NULL,
	[hgamma24] [numeric](8, 2) NULL,
	[hgamma48] [numeric](8, 2) NULL,
	[hgamma54] [numeric](8, 2) NULL,
	[hbeta12] [numeric](8, 2) NULL,
	[hbeta24] [numeric](8, 2) NULL,
	[hbeta48] [numeric](8, 2) NULL,
	[hbeta60] [numeric](8, 2) NULL,
	[halpha12] [numeric](8, 2) NULL,
	[halpha24] [numeric](8, 2) NULL,
	[halpha48] [numeric](8, 2) NULL,
	[halpha70] [numeric](8, 2) NULL,
	[paschen13] [numeric](8, 2) NULL,
	[paschen142] [numeric](8, 2) NULL,
	[paschen242] [numeric](8, 2) NULL,
	[halpha_d02] [numeric](8, 2) NULL,
	[hbeta_d02] [numeric](8, 2) NULL,
	[hgamma_d02] [numeric](8, 2) NULL,
	[hdelta_d02] [numeric](8, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_catalogue]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_catalogue](
	[obsid] [bigint] not NULL primary key clustered,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snru] [numeric](6, 2) NULL,
	[snrg] [numeric](6, 2) NULL,
	[snrr] [numeric](6, 2) NULL,
	[snri] [numeric](6, 2) NULL,
	[snrz] [numeric](6, 2) NULL,
	[class] [varchar](20) NULL,
	[subclass] [varchar](20) NULL,
	[z] [numeric](21, 10) NULL,
	[z_err] [numeric](21, 10) NULL,
	[ps_id] [bigint] NULL,
	[mag_ps_g] [numeric](16, 10) NULL,
	[mag_ps_r] [numeric](16, 10) NULL,
	[mag_ps_i] [numeric](16, 10) NULL,
	[mag_ps_z] [numeric](16, 10) NULL,
	[mag_ps_y] [numeric](16, 10) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[fibermask] [int] NULL,
	[with_norm_flux] [smallint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_cv]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_cv](
	[obsid] [bigint] not NULL primary key clustered,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snru] [numeric](6, 2) NULL,
	[snrg] [numeric](6, 2) NULL,
	[snrr] [numeric](6, 2) NULL,
	[snri] [numeric](6, 2) NULL,
	[snrz] [numeric](6, 2) NULL,
	[class] [varchar](20) NULL,
	[subclass] [varchar](20) NULL,
	[z] [numeric](21, 10) NULL,
	[z_err] [numeric](21, 10) NULL,
	[ps_id] [bigint] NULL,
	[mag_ps_g] [numeric](16, 10) NULL,
	[mag_ps_r] [numeric](16, 10) NULL,
	[mag_ps_i] [numeric](16, 10) NULL,
	[mag_ps_z] [numeric](16, 10) NULL,
	[mag_ps_y] [numeric](16, 10) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[class_liter] [varchar](20) NULL,
	[period_liter] [numeric](16, 10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_galaxy]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_galaxy](
	[obsid] [bigint] not NULL primary key clustered,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snru] [numeric](6, 2) NULL,
	[snrg] [numeric](6, 2) NULL,
	[snrr] [numeric](6, 2) NULL,
	[snri] [numeric](6, 2) NULL,
	[snrz] [numeric](6, 2) NULL,
	[class] [varchar](20) NULL,
	[subclass] [varchar](20) NULL,
	[z] [numeric](21, 10) NULL,
	[z_err] [numeric](21, 10) NULL,
	[ps_id] [bigint] NULL,
	[mag_ps_g] [numeric](16, 10) NULL,
	[mag_ps_r] [numeric](16, 10) NULL,
	[mag_ps_i] [numeric](16, 10) NULL,
	[mag_ps_z] [numeric](16, 10) NULL,
	[mag_ps_y] [numeric](16, 10) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[hbeta_flux] [numeric](16, 10) NULL,
	[hbeta_ew] [numeric](16, 10) NULL,
	[oiii_4960_flux] [numeric](16, 10) NULL,
	[oiii_4960_ew] [numeric](16, 10) NULL,
	[oiii_5008_flux] [numeric](16, 10) NULL,
	[oiii_5008_ew] [numeric](16, 10) NULL,
	[nii_6550_flux] [numeric](16, 10) NULL,
	[nii_6550_ew] [numeric](16, 10) NULL,
	[halpha_flux] [numeric](16, 10) NULL,
	[halpha_ew] [numeric](16, 10) NULL,
	[nii_6585_flux] [numeric](16, 10) NULL,
	[nii_6585_ew] [numeric](16, 10) NULL,
	[sii_6718_flux] [numeric](16, 10) NULL,
	[sii_6718_ew] [numeric](16, 10) NULL,
	[sii_6733_flux] [numeric](16, 10) NULL,
	[sii_6733_ew] [numeric](16, 10) NULL,
	[age_lw] [numeric](21, 16) NULL,
	[age_mw] [numeric](21, 16) NULL,
	[metal_lw] [numeric](21, 16) NULL,
	[metal_mw] [numeric](21, 16) NULL,
	[vsig] [numeric](21, 10) NULL,
	[vsig_err] [numeric](21, 10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_inputcatalog]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_inputcatalog](
	[obsid] [bigint] not NULL primary key clustered,
	[obsdate] [date] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[unitid] [varchar](16) NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[objtype] [varchar](16) NULL,
	[magtype] [varchar](25) NULL,
	[mag1] [numeric](6, 2) NULL,
	[mag2] [numeric](6, 2) NULL,
	[mag3] [numeric](6, 2) NULL,
	[mag4] [numeric](6, 2) NULL,
	[mag5] [numeric](6, 2) NULL,
	[mag6] [numeric](6, 2) NULL,
	[mag7] [numeric](6, 2) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[epoch] [varchar](7) NULL,
	[tname] [varchar](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_mec]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_mec](
	[uid] [varchar](32) not NULL primary key clustered,
	[ura] [numeric](16, 10) NULL,
	[udec] [numeric](16, 10) NULL,
	[gp_id] [bigint] NULL,
	[obs_number] [int] NULL,
	[obsid_list] [varchar](400) NULL,
	[midmjm_list] [varchar](400) NULL,
	[z_list] [varchar](700) NULL,
	[teff_list] [varchar](500) NULL,
	[logg_list] [varchar](500) NULL,
	[feh_list] [varchar](500) NULL,
	[rv_list] [varchar](500) NULL,
	[gaia_vari_type_sos] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_mstellar]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_mstellar](
	[obsid] [bigint] not NULL primary key clustered,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snru] [numeric](6, 2) NULL,
	[snrg] [numeric](6, 2) NULL,
	[snrr] [numeric](6, 2) NULL,
	[snri] [numeric](6, 2) NULL,
	[snrz] [numeric](6, 2) NULL,
	[class] [varchar](20) NULL,
	[subclass] [varchar](20) NULL,
	[z] [numeric](21, 10) NULL,
	[z_err] [numeric](21, 10) NULL,
	[ps_id] [bigint] NULL,
	[mag_ps_g] [numeric](16, 10) NULL,
	[mag_ps_r] [numeric](16, 10) NULL,
	[mag_ps_i] [numeric](16, 10) NULL,
	[mag_ps_z] [numeric](16, 10) NULL,
	[mag_ps_y] [numeric](16, 10) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[teff] [numeric](10, 2) NULL,
	[teff_err] [numeric](8, 2) NULL,
	[logg] [numeric](10, 3) NULL,
	[logg_err] [numeric](8, 3) NULL,
	[m_h] [numeric](12, 6) NULL,
	[m_h_err] [numeric](12, 6) NULL,
	[ewha] [numeric](12, 6) NULL,
	[ewha_err] [numeric](12, 6) NULL,
	[tio5] [numeric](12, 6) NULL,
	[cah2] [numeric](12, 6) NULL,
	[cah3] [numeric](12, 6) NULL,
	[tio1] [numeric](12, 6) NULL,
	[tio2] [numeric](12, 6) NULL,
	[tio3] [numeric](12, 6) NULL,
	[tio4] [numeric](12, 6) NULL,
	[cah1] [numeric](12, 6) NULL,
	[caoh] [numeric](12, 6) NULL,
	[tio5_err] [numeric](12, 6) NULL,
	[cah2_err] [numeric](12, 6) NULL,
	[cah3_err] [numeric](12, 6) NULL,
	[tio1_err] [numeric](12, 6) NULL,
	[tio2_err] [numeric](12, 6) NULL,
	[tio3_err] [numeric](12, 6) NULL,
	[tio4_err] [numeric](12, 6) NULL,
	[cah1_err] [numeric](12, 6) NULL,
	[caoh_err] [numeric](12, 6) NULL,
	[zeta] [numeric](12, 6) NULL,
	[zeta_err] [numeric](12, 6) NULL,
	[type] [numeric](8, 2) NULL,
	[na] [numeric](10, 6) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_plan]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_plan](
	[pid] [int] not NULL ,  --primary key nonclustered
	[obsdate] [date] NULL,
	[planid] [varchar](40) not NULL,
	[ra] [numeric](11, 7) NULL,
	[dec] [numeric](11, 7) NULL,
	[mag] [numeric](5, 2) NULL,
	[seeing] [numeric](5, 2) NULL,
	[exptime] [varchar](120) NULL,
	[lmjm] [bigint] NULL
) ON [PRIMARY]
GO

--create clustered index CX_LRS_plan_planid on LRS_plan(planid)

/****** Object:  Table [dbo].[LRS_qso]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_qso](
	[obsid] [bigint] not NULL primary key clustered,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snru] [numeric](6, 2) NULL,
	[snrg] [numeric](6, 2) NULL,
	[snrr] [numeric](6, 2) NULL,
	[snri] [numeric](6, 2) NULL,
	[snrz] [numeric](6, 2) NULL,
	[class] [varchar](20) NULL,
	[subclass] [varchar](20) NULL,
	[z] [numeric](21, 10) NULL,
	[z_err] [numeric](21, 10) NULL,
	[ps_id] [bigint] NULL,
	[mag_ps_g] [numeric](16, 10) NULL,
	[mag_ps_r] [numeric](16, 10) NULL,
	[mag_ps_i] [numeric](16, 10) NULL,
	[mag_ps_z] [numeric](16, 10) NULL,
	[mag_ps_y] [numeric](16, 10) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[sn_ratio_conti] [numeric](32, 12) NULL,
	[fe_uv_norm] [numeric](32, 12) NULL,
	[fe_uv_fwhm] [numeric](32, 12) NULL,
	[fe_uv_shift] [numeric](32, 12) NULL,
	[fe_op_norm] [numeric](32, 12) NULL,
	[fe_op_fwhm] [numeric](32, 12) NULL,
	[fe_op_shift] [numeric](32, 12) NULL,
	[pl_norm] [numeric](32, 12) NULL,
	[pl_slope] [numeric](32, 12) NULL,
	[balmer_norm] [numeric](32, 12) NULL,
	[balmer_teff] [int] NULL,
	[balmer_tau_e] [numeric](32, 12) NULL,
	[poly_a] [numeric](32, 12) NULL,
	[poly_b] [numeric](32, 12) NULL,
	[poly_c] [numeric](32, 12) NULL,
	[l1350] [numeric](32, 12) NULL,
	[l3000] [numeric](32, 12) NULL,
	[l5100] [numeric](32, 12) NULL,
	[line_name_1] [varchar](5) NULL,
	[fitting_status_1] [int] NULL,
	[min_chi2_1] [numeric](32, 12) NULL,
	[red_chi2_1] [numeric](32, 12) NULL,
	[ndof_1] [int] NULL,
	[line_name_2] [varchar](5) NULL,
	[fitting_status_2] [int] NULL,
	[min_chi2_2] [numeric](32, 12) NULL,
	[red_chi2_2] [numeric](32, 12) NULL,
	[ndof_2] [int] NULL,
	[line_name_3] [varchar](5) NULL,
	[fitting_status_3] [int] NULL,
	[min_chi2_3] [numeric](32, 12) NULL,
	[red_chi2_3] [numeric](32, 12) NULL,
	[ndof_3] [int] NULL,
	[line_name_4] [varchar](5) NULL,
	[fitting_status_4] [int] NULL,
	[min_chi2_4] [numeric](32, 12) NULL,
	[red_chi2_4] [numeric](32, 12) NULL,
	[ndof_4] [int] NULL,
	[line_name_5] [varchar](1) NULL,
	[fitting_status_5] [int] NULL,
	[min_chi2_5] [int] NULL,
	[red_chi2_5] [int] NULL,
	[ndof_5] [int] NULL,
	[line_name_6] [varchar](1) NULL,
	[fitting_status_6] [int] NULL,
	[min_chi2_6] [int] NULL,
	[red_chi2_6] [int] NULL,
	[ndof_6] [int] NULL,
	[lya_br_1_peak_flux] [numeric](32, 12) NULL,
	[lya_br_1_peak_wavelength] [numeric](32, 12) NULL,
	[lya_br_1_sigma] [numeric](32, 12) NULL,
	[lya_na_1_peak_flux] [numeric](32, 12) NULL,
	[lya_na_1_peak_wavelength] [numeric](32, 12) NULL,
	[lya_na_1_sigma] [numeric](32, 12) NULL,
	[civ_br_1_peak_flux] [numeric](32, 12) NULL,
	[civ_br_1_peak_wavelength] [numeric](32, 12) NULL,
	[civ_br_1_sigma] [numeric](32, 12) NULL,
	[civ_na_1_peak_flux] [numeric](32, 12) NULL,
	[civ_na_1_peak_wavelength] [numeric](32, 12) NULL,
	[civ_na_1_sigma] [numeric](32, 12) NULL,
	[ciii_br_1_peak_flux] [numeric](32, 12) NULL,
	[ciii_br_1_peak_wavelength] [numeric](32, 12) NULL,
	[ciii_br_1_sigma] [numeric](32, 12) NULL,
	[ciii_br_2_peak_flux] [numeric](32, 12) NULL,
	[ciii_br_2_peak_wavelength] [numeric](32, 12) NULL,
	[ciii_na_1_peak_flux] [int] NULL,
	[ciii_na_1_peak_wavelength] [int] NULL,
	[ciii_na_1_sigma] [int] NULL,
	[ciii_na_2_peak_flux] [int] NULL,
	[ciii_na_2_peak_wavelength] [int] NULL,
	[ciii_na_2_sigma] [int] NULL,
	[mgii_br_1_peak_flux] [numeric](32, 12) NULL,
	[mgii_br_1_peak_wavelength] [numeric](32, 12) NULL,
	[mgii_br_1_sigma] [numeric](32, 12) NULL,
	[mgii_na_1_peak_flux] [numeric](32, 12) NULL,
	[mgii_na_1_peak_wavelength] [numeric](32, 12) NULL,
	[mgii_na_1_sigma] [numeric](32, 12) NULL,
	[mgii_na_2_peak_flux] [numeric](32, 12) NULL,
	[mgii_na_2_peak_wavelength] [numeric](32, 12) NULL,
	[mgii_na_2_sigma] [numeric](32, 12) NULL,
	[hb_br_1_peak_flux] [numeric](32, 12) NULL,
	[hb_br_1_peak_wavelength] [numeric](32, 12) NULL,
	[hb_br_1_sigma] [numeric](32, 12) NULL,
	[hb_na_1_peak_flux] [numeric](32, 12) NULL,
	[hb_na_1_peak_wavelength] [numeric](32, 12) NULL,
	[hb_na_1_sigma] [numeric](32, 12) NULL,
	[oiii4959_1_peak_flux] [numeric](32, 12) NULL,
	[oiii4959_1_peak_wavelength] [numeric](32, 12) NULL,
	[oiii4959_1_sigma] [numeric](32, 12) NULL,
	[oiii5007_1_peak_flux] [numeric](32, 12) NULL,
	[oiii5007_1_peak_wavelength] [numeric](32, 12) NULL,
	[oiii5007_1_sigma] [numeric](32, 12) NULL,
	[ha_br_1_peak_flux] [numeric](32, 12) NULL,
	[ha_br_1_peak_wavelength] [numeric](32, 12) NULL,
	[ha_br_1_sigma] [numeric](32, 12) NULL,
	[ha_br_2_peak_flux] [numeric](32, 12) NULL,
	[ha_br_2_peak_wavelength] [numeric](32, 12) NULL,
	[ha_br_2_sigma] [numeric](32, 12) NULL,
	[ha_br_3_peak_flux] [numeric](32, 12) NULL,
	[ha_br_3_peak_wavelength] [numeric](32, 12) NULL,
	[ha_br_3_sigma] [numeric](32, 12) NULL,
	[ha_na_1_peak_flux] [numeric](32, 12) NULL,
	[ha_na_1_peak_wavelength] [numeric](32, 12) NULL,
	[ha_na_1_sigma] [numeric](32, 12) NULL,
	[nii6549_1_peak_flux] [numeric](32, 12) NULL,
	[nii6549_1_peak_wavelength] [numeric](32, 12) NULL,
	[nii6549_1_sigma] [numeric](32, 12) NULL,
	[nii6585_1_peak_flux] [numeric](32, 12) NULL,
	[nii6585_1_peak_wavelength] [numeric](32, 12) NULL,
	[nii6585_1_sigma] [numeric](32, 12) NULL,
	[sii6718_1_peak_flux] [numeric](32, 12) NULL,
	[sii6718_1_peak_wavelength] [numeric](32, 12) NULL,
	[sii6718_1_sigma] [numeric](32, 12) NULL,
	[sii6732_1_peak_flux] [numeric](32, 12) NULL,
	[sii6732_1_peak_wavelength] [numeric](32, 12) NULL,
	[sii6732_1_sigma] [numeric](32, 12) NULL,
	[lya_fwhm] [numeric](32, 12) NULL,
	[lya_sigma] [numeric](32, 12) NULL,
	[lya_ew] [numeric](32, 12) NULL,
	[lya_peak_wavelength] [numeric](32, 12) NULL,
	[lya_area] [numeric](32, 12) NULL,
	[civ_fwhm] [numeric](32, 12) NULL,
	[civ_sigma] [numeric](32, 12) NULL,
	[civ_ew] [numeric](32, 12) NULL,
	[civ_peak_wavelength] [numeric](32, 12) NULL,
	[civ_area] [numeric](32, 12) NULL,
	[ciii_fwhm] [numeric](32, 12) NULL,
	[ciii_sigma] [numeric](32, 12) NULL,
	[ciii_ew] [numeric](32, 12) NULL,
	[ciii_peak_wavelength] [numeric](32, 12) NULL,
	[ciii_area] [numeric](32, 12) NULL,
	[mgii_fwhm] [numeric](32, 12) NULL,
	[mgii_sigma] [numeric](32, 12) NULL,
	[mgii_ew] [numeric](32, 12) NULL,
	[mgii_peak_wavelength] [numeric](32, 12) NULL,
	[mgii_area] [numeric](32, 12) NULL,
	[hb_fwhm] [numeric](32, 12) NULL,
	[hb_sigma] [numeric](32, 12) NULL,
	[hb_ew] [numeric](32, 12) NULL,
	[hb_peak_wavelength] [numeric](32, 12) NULL,
	[hb_area] [numeric](32, 12) NULL,
	[ha_fwhm] [numeric](32, 12) NULL,
	[ha_sigma] [numeric](32, 12) NULL,
	[ha_ew] [numeric](32, 12) NULL,
	[ha_peak_wavelength] [numeric](32, 12) NULL,
	[ha_area] [numeric](32, 12) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_stellar]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_stellar](
	[obsid] [bigint] not NULL primary key clustered,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snru] [numeric](6, 2) NULL,
	[snrg] [numeric](6, 2) NULL,
	[snrr] [numeric](6, 2) NULL,
	[snri] [numeric](6, 2) NULL,
	[snrz] [numeric](6, 2) NULL,
	[class] [varchar](20) NULL,
	[subclass] [varchar](20) NULL,
	[z] [numeric](21, 10) NULL,
	[z_err] [numeric](21, 10) NULL,
	[ps_id] [bigint] NULL,
	[mag_ps_g] [numeric](16, 10) NULL,
	[mag_ps_r] [numeric](16, 10) NULL,
	[mag_ps_i] [numeric](16, 10) NULL,
	[mag_ps_z] [numeric](16, 10) NULL,
	[mag_ps_y] [numeric](16, 10) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[teff] [numeric](10, 2) NULL,
	[teff_err] [numeric](8, 2) NULL,
	[logg] [numeric](10, 3) NULL,
	[logg_err] [numeric](8, 3) NULL,
	[feh] [numeric](10, 3) NULL,
	[feh_err] [numeric](8, 3) NULL,
	[rv] [numeric](10, 2) NULL,
	[rv_err] [numeric](8, 2) NULL,
	[alpha_m] [numeric](10, 6) NULL,
	[alpha_m_err] [numeric](10, 6) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LRS_wd]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LRS_wd](
	[obsid] [bigint] not NULL primary key clustered,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snru] [numeric](6, 2) NULL,
	[snrg] [numeric](6, 2) NULL,
	[snrr] [numeric](6, 2) NULL,
	[snri] [numeric](6, 2) NULL,
	[snrz] [numeric](6, 2) NULL,
	[class] [varchar](20) NULL,
	[subclass] [varchar](20) NULL,
	[z] [numeric](21, 10) NULL,
	[z_err] [numeric](21, 10) NULL,
	[ps_id] [bigint] NULL,
	[mag_ps_g] [numeric](16, 10) NULL,
	[mag_ps_r] [numeric](16, 10) NULL,
	[mag_ps_i] [numeric](16, 10) NULL,
	[mag_ps_z] [numeric](16, 10) NULL,
	[mag_ps_y] [numeric](16, 10) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[wd_subclass] [varchar](10) NULL,
	[teff] [numeric](10, 2) NULL,
	[teff_err] [numeric](8, 2) NULL,
	[logg] [numeric](10, 3) NULL,
	[logg_err] [numeric](8, 3) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MRS_catalogue]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MRS_catalogue](
	[mobsid] [varchar](20) not NULL primary key clustered,
	[obsid] [bigint] NULL,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[lmjm] [bigint] NULL,
	[band] [varchar](2) NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snr] [numeric](6, 2) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[gaia_bp_mean_mag] [numeric](16, 10) NULL,
	[gaia_rp_mean_mag] [numeric](16, 10) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[rv_b0] [numeric](10, 2) NULL,
	[rv_b0_err] [numeric](10, 2) NULL,
	[rv_b1] [numeric](10, 2) NULL,
	[rv_b1_err] [numeric](10, 2) NULL,
	[rv_b_flag] [smallint] NULL,
	[rv_r0] [numeric](10, 2) NULL,
	[rv_r0_err] [numeric](10, 2) NULL,
	[rv_r1] [numeric](10, 2) NULL,
	[rv_r1_err] [numeric](10, 2) NULL,
	[rv_r_flag] [smallint] NULL,
	[rv_br0] [numeric](10, 2) NULL,
	[rv_br0_err] [numeric](10, 2) NULL,
	[rv_br1] [numeric](10, 2) NULL,
	[rv_br1_err] [numeric](10, 2) NULL,
	[rv_br_flag] [smallint] NULL,
	[rv_lasp0] [numeric](10, 2) NULL,
	[rv_lasp0_err] [numeric](10, 2) NULL,
	[rv_lasp1] [numeric](10, 2) NULL,
	[rv_lasp1_err] [numeric](10, 2) NULL,
	[coadd] [smallint] NULL,
	[fibermask] [int] NULL,
	[bad_b] [smallint] NULL,
	[bad_r] [smallint] NULL,
	[moon_angle] [numeric](5, 1) NULL,
	[lunardate] [smallint] NULL,
	[moon_flg] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MRS_inputcatalog]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MRS_inputcatalog](
	[obsid] [bigint] not NULL primary key clustered,
	[obsdate] [date] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[unitid] [varchar](16) NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[objtype] [varchar](16) NULL,
	[magtype] [varchar](25) NULL,
	[mag1] [numeric](6, 2) NULL,
	[mag2] [numeric](6, 2) NULL,
	[mag3] [numeric](6, 2) NULL,
	[mag4] [numeric](6, 2) NULL,
	[mag5] [numeric](6, 2) NULL,
	[mag6] [numeric](6, 2) NULL,
	[mag7] [numeric](6, 2) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[epoch] [varchar](7) NULL,
	[tname] [varchar](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MRS_mec]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MRS_mec](
	[uid] [varchar](32) not NULL primary key clustered,
	[ura] [numeric](16, 10) NULL,
	[udec] [numeric](16, 10) NULL,
	[gp_id] [bigint] NULL,
	[obs_number] [int] NULL,
	[obsid_list] [varchar](400) NULL,
	[teff_lasp_list] [varchar](500) NULL,
	[logg_lasp_list] [varchar](500) NULL,
	[feh_lasp_list] [varchar](500) NULL,
	[exp_number] [int] NULL,
	[lmjm_list] [varchar](1200) NULL,
	[rv_b0_list] [varchar](1200) NULL,
	[rv_b1_list] [varchar](1200) NULL,
	[rv_r0_list] [varchar](1200) NULL,
	[rv_r1_list] [varchar](1200) NULL,
	[rv_br0_list] [varchar](1200) NULL,
	[rv_br1_list] [varchar](1200) NULL,
	[gaia_vari_type_sos] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MRS_plan]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MRS_plan](
	[pid] [int] not NULL, --primary key nonclustered,
	[obsdate] [date] NULL,
	[planid] [varchar](40) not NULL,
	[ra] [numeric](11, 7) NULL,
	[dec] [numeric](11, 7) NULL,
	[mag] [numeric](5, 2) NULL,
	[seeing] [numeric](5, 2) NULL,
	[exptime] [varchar](120) NULL,
	[lmjm_list] [varchar](1200) NULL
) ON [PRIMARY]
GO

--create clustered index CX_MRS_plan_planid on MRS_plan(planid)

go

/****** Object:  Table [dbo].[MRS_stellar]    Script Date: 11/23/2022 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MRS_stellar](
	[mobsid] [varchar](20) not NULL primary key clustered,
	[obsid] [bigint] NULL,
	[uid] [varchar](32) NULL,
	[gp_id] [bigint] NULL,
	[designation] [varchar](19) NULL,
	[obsdate] [date] NULL,
	[lmjd] [int] NULL,
	[mjd] [int] NULL,
	[planid] [varchar](40) NULL,
	[spid] [int] NULL,
	[fiberid] [int] NULL,
	[lmjm] [bigint] NULL,
	[band] [varchar](2) NULL,
	[ra_obs] [numeric](16, 10) NULL,
	[dec_obs] [numeric](16, 10) NULL,
	[snr] [numeric](6, 2) NULL,
	[gaia_source_id] [varchar](25) NULL,
	[gaia_g_mean_mag] [numeric](13, 8) NULL,
	[gaia_bp_mean_mag] [numeric](16, 10) NULL,
	[gaia_rp_mean_mag] [numeric](16, 10) NULL,
	[tsource] [varchar](16) NULL,
	[fibertype] [varchar](10) NULL,
	[tfrom] [varchar](60) NULL,
	[tcomment] [varchar](80) NULL,
	[offset] [int] NULL,
	[offset_v] [numeric](6, 3) NULL,
	[ra] [numeric](16, 10) NULL,
	[dec] [numeric](16, 10) NULL,
	[teff_lasp] [numeric](10, 2) NULL,
	[teff_lasp_err] [numeric](8, 2) NULL,
	[logg_lasp] [numeric](10, 3) NULL,
	[logg_lasp_err] [numeric](8, 3) NULL,
	[feh_lasp] [numeric](10, 3) NULL,
	[feh_lasp_err] [numeric](8, 3) NULL,
	[vsini_lasp] [numeric](10, 3) NULL,
	[vsini_lasp_err] [numeric](9, 3) NULL,
	[rv_b0] [numeric](10, 2) NULL,
	[rv_b0_err] [numeric](10, 2) NULL,
	[rv_b1] [numeric](10, 2) NULL,
	[rv_b1_err] [numeric](10, 2) NULL,
	[rv_b_flag] [smallint] NULL,
	[rv_r0] [numeric](10, 2) NULL,
	[rv_r0_err] [numeric](10, 2) NULL,
	[rv_r1] [numeric](10, 2) NULL,
	[rv_r1_err] [numeric](10, 2) NULL,
	[rv_r_flag] [smallint] NULL,
	[rv_br0] [numeric](10, 2) NULL,
	[rv_br0_err] [numeric](10, 2) NULL,
	[rv_br1] [numeric](10, 2) NULL,
	[rv_br1_err] [numeric](10, 2) NULL,
	[rv_br_flag] [smallint] NULL,
	[rv_lasp0] [numeric](10, 2) NULL,
	[rv_lasp0_err] [numeric](10, 2) NULL,
	[rv_lasp1] [numeric](10, 2) NULL,
	[rv_lasp1_err] [numeric](10, 2) NULL,
	[coadd] [smallint] NULL,
	[fibermask] [int] NULL,
	[alpha_m_cnn] [numeric](10, 3) NULL,
	[teff_cnn] [numeric](10, 2) NULL,
	[logg_cnn] [numeric](10, 3) NULL,
	[feh_cnn] [numeric](10, 3) NULL,
	[c_fe] [numeric](10, 6) NULL,
	[n_fe] [numeric](10, 6) NULL,
	[o_fe] [numeric](10, 6) NULL,
	[mg_fe] [numeric](10, 6) NULL,
	[al_fe] [numeric](10, 6) NULL,
	[si_fe] [numeric](10, 6) NULL,
	[s_fe] [numeric](10, 6) NULL,
	[ca_fe] [numeric](10, 6) NULL,
	[ti_fe] [numeric](10, 6) NULL,
	[cr_fe] [numeric](10, 6) NULL,
	[ni_fe] [numeric](10, 6) NULL,
	[cu_fe] [numeric](10, 6) NULL,
	[alpha_m_lasp] [numeric](10, 6) NULL,
	[alpha_m_lasp_err] [numeric](10, 6) NULL,
	[moon_angle] [numeric](5, 1) NULL,
	[lunardate] [smallint] NULL,
	[moon_flg] [varchar](10) NULL
) ON [PRIMARY]
GO
