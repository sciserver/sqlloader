USE [BestDR18]
GO

/****** Object:  Table [dbo].[eFEDS_Hard_speccomp]    Script Date: 12/22/2022 4:19:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eFEDS_Hard_speccomp](
	[ero_name] [varchar](30) NOT NULL,
	[ero_id_src] [int] NOT NULL,
	[ero_ra_corr] [real] NOT NULL,
	[ero_dec_corr] [real] NOT NULL,
	[ero_radec_err_corr] [real] NOT NULL,
	[ero_ml_flux_3] [real] NULL,
	[ero_ml_flux_err_3] [real] NULL,
	[ero_det_like_3] [real] NULL,
	[ctp_ls8_unique_objid] [varchar](20) NULL,
	[ctp_ls8_ra] [real] NULL,
	[ctp_ls8_dec] [real] NULL,
	[dist_ctp_ls8_ero] [real] NULL,
	[ctp_quality] [smallint] NULL,
	[ls_id] [bigint] NULL,
	[ls_ra] [float] NULL,
	[ls_dec] [float] NULL,
	[ls_pmra] [real] NULL,
	[ls_pmdec] [real] NULL,
	[ls_epoch] [real] NULL,
	[ls_mag_g] [real] NULL,
	[ls_mag_r] [real] NULL,
	[ls_mag_z] [real] NULL,
	[specz_n] [int] NULL,
	[specz_raj2000] [float] NULL,
	[specz_dej2000] [float] NULL,
	[specz_nsel] [int] NULL,
	[specz_redshift] [real] NULL,
	[specz_normq] [int] NULL,
	[specz_normc] [varchar](10) NULL,
	[specz_hasvi] [bit] NULL,
	[specz_catcode] [varchar](20) NULL,
	[specz_bitmask] [bigint] NULL,
	[specz_sel_bitmask] [bigint] NULL,
	[specz_flags] [int] NULL,
	[specz_sel_normq_max] [int] NULL,
	[specz_sel_normq_mean] [real] NULL,
	[specz_sel_z_mean] [real] NULL,
	[specz_sel_z_median] [real] NULL,
	[specz_sel_z_stddev] [real] NULL,
	[specz_orig_ra] [float] NULL,
	[specz_orig_dec] [float] NULL,
	[specz_orig_pos_epoch] [real] NULL,
	[specz_orig_ls_sep] [real] NULL,
	[specz_orig_ls_gt1ctp] [bit] NULL,
	[specz_orig_ls_ctp_rank] [int] NULL,
	[specz_orig_id] [varchar](40) NULL,
	[specz_orig_redshift] [real] NULL,
	[specz_orig_qual] [varchar](10) NULL,
	[specz_orig_normq] [int] NULL,
	[specz_orig_class] [varchar](20) NULL,
	[specz_orig_hasvi] [bit] NULL,
	[specz_orig_normc] [varchar](10) NULL,
	[specz_ra_used] [float] NULL,
	[specz_dec_used] [float] NULL,
	[separation_specz_ctp] [float] NULL,
	[has_specz] [bit] NULL,
	[has_informative_specz] [bit] NULL
) ON [DATAFG]
GO




/****** Object:  Table [dbo].[eFEDS_Main_speccomp]    Script Date: 12/22/2022 4:20:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eFEDS_Main_speccomp](
	[ero_name] [varchar](30) NOT NULL,
	[ero_id_src] [int] NOT NULL,
	[ero_ra_corr] [float] NOT NULL,
	[ero_dec_corr] [float] NOT NULL,
	[ero_radec_err_corr] [real] NULL,
	[ero_ml_flux] [real] NULL,
	[ero_ml_flux_err] [real] NULL,
	[ero_det_like] [real] NULL,
	[ctp_ls8_unique_objid] [varchar](20) NULL,
	[ctp_ls8_ra] [float] NULL,
	[ctp_ls8_dec] [float] NULL,
	[dist_ctp_ls8_ero] [real] NULL,
	[ctp_quality] [smallint] NULL,
	[ls_id] [bigint] NULL,
	[ls_ra] [float] NULL,
	[ls_dec] [float] NULL,
	[ls_pmra] [real] NULL,
	[ls_pmdec] [real] NULL,
	[ls_epoch] [real] NULL,
	[ls_mag_g] [real] NULL,
	[ls_mag_r] [real] NULL,
	[ls_mag_z] [real] NULL,
	[specz_n] [int] NULL,
	[specz_raj2000] [float] NULL,
	[specz_dej2000] [float] NULL,
	[specz_nsel] [int] NULL,
	[specz_redshift] [real] NULL,
	[specz_normq] [int] NULL,
	[specz_normc] [varchar](10) NULL,
	[specz_hasvi] [bit] NULL,
	[specz_catcode] [varchar](20) NULL,
	[specz_bitmask] [bigint] NULL,
	[specz_sel_bitmask] [bigint] NULL,
	[specz_flags] [int] NULL,
	[specz_sel_normq_max] [int] NULL,
	[specz_sel_normq_mean] [real] NULL,
	[specz_sel_z_mean] [real] NULL,
	[specz_sel_z_median] [real] NULL,
	[specz_sel_z_stddev] [real] NULL,
	[specz_orig_ra] [float] NULL,
	[specz_orig_dec] [float] NULL,
	[specz_orig_pos_epoch] [real] NULL,
	[specz_orig_ls_sep] [real] NULL,
	[specz_orig_ls_gt1ctp] [bit] NULL,
	[specz_orig_ls_ctp_rank] [int] NULL,
	[specz_orig_id] [varchar](40) NULL,
	[specz_orig_redshift] [real] NULL,
	[specz_orig_qual] [varchar](10) NULL,
	[specz_orig_normq] [int] NULL,
	[specz_orig_class] [varchar](20) NULL,
	[specz_orig_hasvi] [bit] NULL,
	[specz_orig_normc] [varchar](10) NULL,
	[specz_ra_used] [float] NULL,
	[specz_dec_used] [float] NULL,
	[separation_specz_ctp] [float] NULL,
	[has_specz] [bit] NULL,
	[has_informative_specz] [bit] NULL
) ON [DATAFG]
GO



/****** Object:  Table [dbo].[eFEDS_SDSSV_spec_results]    Script Date: 12/22/2022 4:20:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[eFEDS_SDSSV_spec_results](
	[field] [smallint] NOT NULL,
	[mjd] [int] NOT NULL,
	[catalogid] [bigint] NOT NULL,
	[plug_ra] [float] NOT NULL,
	[plug_dec] [float] NOT NULL,
	[nvi] [smallint] NULL,
	[sn_median_all] [float] NULL,
	[z_pipe] [float] NULL,
	[z_err_pipe] [float] NULL,
	[zwarning_pipe] [smallint] NULL,
	[class_pipe] [varchar](10) NULL,
	[subclass_pipe] [varchar](30) NULL,
	[z_final] [float] NULL,
	[z_conf_final] [smallint] NULL,
	[class_final] [varchar](20) NULL,
	[blazar_candidate] [bit] NULL
) ON [DATAFG]
GO



