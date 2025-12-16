USE [BestDR19]
GO

/****** Object:  Table [dbo].[spAll]    Script Date: 6/26/2025 1:31:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[spAll2](
	[field] [bigint] NOT NULL,
	[mjd] [bigint] NOT NULL,
	[obs] [varchar](3) NOT NULL,
	[mjd_final] [float] NOT NULL,
	[mjd_list] [varchar](107) NOT NULL,
	[tai_list] [varchar](197) NOT NULL,
	[run2d] [varchar](6) NOT NULL,
	[run1d] [varchar](6) NOT NULL,
	[designs] [varchar](125) NOT NULL,
	[configs] [varchar](89) NOT NULL,
	[nexp] [smallint] NOT NULL,
	[exptime] [real] NOT NULL,
	[target_index] [bigint] NOT NULL,
	[fiberid_list] [varchar](71) NOT NULL,
	[spec_file] [varchar](42) NOT NULL,
	[programname] [varchar](14) NOT NULL,
	[survey] [varchar](13) NOT NULL,
	[cadence] [varchar](19) NOT NULL,
	[firstcarton] [varchar](48) NOT NULL,
	[carton_to_target_pk] [varchar](64) NOT NULL,
	[objtype] [varchar](16) NOT NULL,
	[catalogid] [bigint] NOT NULL,
	[catalogid_v0] [bigint] NOT NULL,
	[catalogid_v0p5] [bigint] NOT NULL,
	[sdss_id] [bigint] NOT NULL,
	[specobjid] [numeric](30, 0) NOT NULL,
	[calibflux_u] [real] NOT NULL,
	[calibflux_g] [real] NOT NULL,
	[calibflux_r] [real] NOT NULL,
	[calibflux_i] [real] NOT NULL,
	[calibflux_z] [real] NOT NULL,
	[calibflux_ivar_u] [real] NOT NULL,
	[calibflux_ivar_g] [real] NOT NULL,
	[calibflux_ivar_r] [real] NOT NULL,
	[calibflux_ivar_i] [real] NOT NULL,
	[calibflux_ivar_z] [real] NOT NULL,
	[optical_prov] [varchar](26) NOT NULL,
	[mag_u] [real] NOT NULL,
	[mag_g] [real] NOT NULL,
	[mag_r] [real] NOT NULL,
	[mag_i] [real] NOT NULL,
	[mag_z] [real] NOT NULL,
	[psfmag_u] [real] NOT NULL,
	[psfmag_g] [real] NOT NULL,
	[psfmag_r] [real] NOT NULL,
	[psfmag_i] [real] NOT NULL,
	[psfmag_z] [real] NOT NULL,
	[fiber2mag_u] [real] NOT NULL,
	[fiber2mag_g] [real] NOT NULL,
	[fiber2mag_r] [real] NOT NULL,
	[fiber2mag_i] [real] NOT NULL,
	[fiber2mag_z] [real] NOT NULL,
	[catdb_mag_u] [real] NOT NULL,
	[catdb_mag_g] [real] NOT NULL,
	[catdb_mag_r] [real] NOT NULL,
	[catdb_mag_i] [real] NOT NULL,
	[catdb_mag_z] [real] NOT NULL,
	[gaia_g_mag] [real] NOT NULL,
	[gri_gaia_transform] [bigint] NOT NULL,
	[bp_mag] [real] NOT NULL,
	[rp_mag] [real] NOT NULL,
	[gaia_id] [bigint] NOT NULL,
	[wise_mag_1] [real] NOT NULL,
	[wise_mag_2] [real] NOT NULL,
	[wise_mag_3] [real] NOT NULL,
	[wise_mag_4] [real] NOT NULL,
	[twomass_mag_1] [real] NOT NULL,
	[twomass_mag_2] [real] NOT NULL,
	[twomass_mag_3] [real] NOT NULL,
	[guvcat_mag_1] [real] NOT NULL,
	[guvcat_mag_2] [real] NOT NULL,
	[ebv] [real] NOT NULL,
	[ebv_type] [varchar](14) NOT NULL,
	[fiber_ra] [float] NOT NULL,
	[fiber_dec] [float] NOT NULL,
	[plug_ra] [float] NOT NULL,
	[plug_dec] [float] NOT NULL,
	[racat] [float] NOT NULL,
	[deccat] [float] NOT NULL,
	[coord_epoch] [real] NOT NULL,
	[pmra] [real] NOT NULL,
	[pmdec] [real] NOT NULL,
	[parallax] [real] NOT NULL,
	[ra_list] [varchar](197) NOT NULL,
	[dec_list] [varchar](179) NOT NULL,
	[delta_ra_list] [varchar](71) NOT NULL,
	[delta_dec_list] [varchar](71) NOT NULL,
	[fiber_offset] [bigint] NOT NULL,
	[xfocal] [varchar](161) NOT NULL,
	[yfocal] [varchar](161) NOT NULL,
	[zoffset] [real] NOT NULL,
	[lambda_eff] [real] NOT NULL,
	[bluefiber] [bigint] NOT NULL,
	[healpix] [bigint] NOT NULL,
	[healpixgrp] [bigint] NOT NULL,
	[healpix_path] [varchar](70) NOT NULL,
	[fieldquality] [varchar](4) NOT NULL,
	[exp_disp_med] [float] NOT NULL,
	[fieldsn2] [real] NOT NULL,
	[fieldsnr2g_list] [varchar](89) NOT NULL,
	[fieldsnr2r_list] [varchar](89) NOT NULL,
	[fieldsnr2i_list] [varchar](89) NOT NULL,
	[spec1_g] [real] NOT NULL,
	[spec1_r] [real] NOT NULL,
	[spec1_i] [real] NOT NULL,
	[spec2_g] [real] NOT NULL,
	[spec2_r] [real] NOT NULL,
	[spec2_i] [real] NOT NULL,
	[sn_median_u] [real] NOT NULL,
	[sn_median_g] [real] NOT NULL,
	[sn_median_r] [real] NOT NULL,
	[sn_median_i] [real] NOT NULL,
	[sn_median_z] [real] NOT NULL,
	[sn_median_all] [real] NOT NULL,
	[airmass] [real] NOT NULL,
	[seeing20] [real] NOT NULL,
	[seeing50] [real] NOT NULL,
	[seeing80] [real] NOT NULL,
	[moon_dist] [varchar](107) NOT NULL,
	[moon_phase] [varchar](89) NOT NULL,
	[assigned] [varchar](35) NOT NULL,
	[on_target] [varchar](35) NOT NULL,
	[valid] [varchar](35) NOT NULL,
	[decollided] [varchar](35) NOT NULL,
	[anyandmask] [bigint] NOT NULL,
	[anyormask] [bigint] NOT NULL,
	[specprimary] [tinyint] NOT NULL,
	[specboss] [bigint] NOT NULL,
	[boss_specobj_id] [bigint] NOT NULL,
	[nspecobs] [bigint] NOT NULL,
	[spectroflux_u] [real] NOT NULL,
	[spectroflux_g] [real] NOT NULL,
	[spectroflux_r] [real] NOT NULL,
	[spectroflux_i] [real] NOT NULL,
	[spectroflux_z] [real] NOT NULL,
	[spectroflux_ivar_u] [real] NOT NULL,
	[spectroflux_ivar_g] [real] NOT NULL,
	[spectroflux_ivar_r] [real] NOT NULL,
	[spectroflux_ivar_i] [real] NOT NULL,
	[spectroflux_ivar_z] [real] NOT NULL,
	[spectrosynflux_u] [real] NOT NULL,
	[spectrosynflux_g] [real] NOT NULL,
	[spectrosynflux_r] [real] NOT NULL,
	[spectrosynflux_i] [real] NOT NULL,
	[spectrosynflux_z] [real] NOT NULL,
	[spectrosynflux_ivar_u] [real] NOT NULL,
	[spectrosynflux_ivar_g] [real] NOT NULL,
	[spectrosynflux_ivar_r] [real] NOT NULL,
	[spectrosynflux_ivar_i] [real] NOT NULL,
	[spectrosynflux_ivar_z] [real] NOT NULL,
	[spectroskyflux_u] [real] NOT NULL,
	[spectroskyflux_g] [real] NOT NULL,
	[spectroskyflux_r] [real] NOT NULL,
	[spectroskyflux_i] [real] NOT NULL,
	[spectroskyflux_z] [real] NOT NULL,
	[wavemin] [real] NOT NULL,
	[wavemax] [real] NOT NULL,
	[wcoverage] [real] NOT NULL,
	[class] [varchar](6) NOT NULL,
	[subclass] [varchar](21) NOT NULL,
	[z] [real] NOT NULL,
	[z_err] [real] NOT NULL,
	[zwarning] [bigint] NOT NULL,
	[rchi2] [real] NOT NULL,
	[dof] [bigint] NOT NULL,
	[rchi2diff] [real] NOT NULL,
	[tfile] [varchar](24) NOT NULL,
	[tcolumn_1] [bigint] NOT NULL,
	[tcolumn_2] [bigint] NOT NULL,
	[tcolumn_3] [bigint] NOT NULL,
	[tcolumn_4] [bigint] NOT NULL,
	[tcolumn_5] [bigint] NOT NULL,
	[tcolumn_6] [bigint] NOT NULL,
	[tcolumn_7] [bigint] NOT NULL,
	[tcolumn_8] [bigint] NOT NULL,
	[tcolumn_9] [bigint] NOT NULL,
	[tcolumn_10] [bigint] NOT NULL,
	[npoly] [bigint] NOT NULL,
	[theta_1] [real] NOT NULL,
	[theta_2] [real] NOT NULL,
	[theta_3] [real] NOT NULL,
	[theta_4] [real] NOT NULL,
	[theta_5] [real] NOT NULL,
	[theta_6] [real] NOT NULL,
	[theta_7] [real] NOT NULL,
	[theta_8] [real] NOT NULL,
	[theta_9] [real] NOT NULL,
	[theta_10] [real] NOT NULL,
	[vdisp] [real] NOT NULL,
	[vdisp_err] [real] NOT NULL,
	[vdispz] [real] NOT NULL,
	[vdispz_err] [real] NOT NULL,
	[vdispchi2] [real] NOT NULL,
	[vdispnpix] [real] NOT NULL,
	[vdispdof] [bigint] NOT NULL,
	[chi68p] [real] NOT NULL,
	[fracnsigma_1] [real] NOT NULL,
	[fracnsigma_2] [real] NOT NULL,
	[fracnsigma_3] [real] NOT NULL,
	[fracnsigma_4] [real] NOT NULL,
	[fracnsigma_5] [real] NOT NULL,
	[fracnsigma_6] [real] NOT NULL,
	[fracnsigma_7] [real] NOT NULL,
	[fracnsigma_8] [real] NOT NULL,
	[fracnsigma_9] [real] NOT NULL,
	[fracnsigma_10] [real] NOT NULL,
	[fracnsighi_1] [real] NOT NULL,
	[fracnsighi_2] [real] NOT NULL,
	[fracnsighi_3] [real] NOT NULL,
	[fracnsighi_4] [real] NOT NULL,
	[fracnsighi_5] [real] NOT NULL,
	[fracnsighi_6] [real] NOT NULL,
	[fracnsighi_7] [real] NOT NULL,
	[fracnsighi_8] [real] NOT NULL,
	[fracnsighi_9] [real] NOT NULL,
	[fracnsighi_10] [real] NOT NULL,
	[fracnsiglo_1] [real] NOT NULL,
	[fracnsiglo_2] [real] NOT NULL,
	[fracnsiglo_3] [real] NOT NULL,
	[fracnsiglo_4] [real] NOT NULL,
	[fracnsiglo_5] [real] NOT NULL,
	[fracnsiglo_6] [real] NOT NULL,
	[fracnsiglo_7] [real] NOT NULL,
	[fracnsiglo_8] [real] NOT NULL,
	[fracnsiglo_9] [real] NOT NULL,
	[fracnsiglo_10] [real] NOT NULL,
	[z_noqso] [real] NOT NULL,
	[z_err_noqso] [real] NOT NULL,
	[znum_noqso] [bigint] NOT NULL,
	[zwarning_noqso] [bigint] NOT NULL,
	[class_noqso] [varchar](6) NOT NULL,
	[subclass_noqso] [varchar](21) NOT NULL,
	[rchi2diff_noqso] [real] NOT NULL,
	[xcsao_rv] [real] NOT NULL,
	[xcsao_erv] [real] NOT NULL,
	[xcsao_rxc] [real] NOT NULL,
	[xcsao_teff] [real] NOT NULL,
	[xcsao_eteff] [real] NOT NULL,
	[xcsao_logg] [real] NOT NULL,
	[xcsao_elogg] [real] NOT NULL,
	[xcsao_feh] [real] NOT NULL,
	[xcsao_efeh] [real] NOT NULL,
	htmid as dbo.fHtmEq(racat, deccat) persisted, 
	cx float null,
	cy float null,
	cz float null
 CONSTRAINT [pk_spAll_specObjID2] PRIMARY KEY CLUSTERED 
(
	[specobjid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SPEC]
) ON [SPEC]
GO

insert spall2 with (tablock)
SELECT [field]
      ,[mjd]
      ,[obs]
      ,[mjd_final]
      ,[mjd_list]
      ,[tai_list]
      ,[run2d]
      ,[run1d]
      ,[designs]
      ,[configs]
      ,[nexp]
      ,[exptime]
      ,[target_index]
      ,[fiberid_list]
      ,[spec_file]
      ,[programname]
      ,[survey]
      ,[cadence]
      ,[firstcarton]
      ,[carton_to_target_pk]
      ,[objtype]
      ,[catalogid]
      ,[catalogid_v0]
      ,[catalogid_v0p5]
      ,[sdss_id]
      ,[specobjid]
      ,[calibflux_u]
      ,[calibflux_g]
      ,[calibflux_r]
      ,[calibflux_i]
      ,[calibflux_z]
      ,[calibflux_ivar_u]
      ,[calibflux_ivar_g]
      ,[calibflux_ivar_r]
      ,[calibflux_ivar_i]
      ,[calibflux_ivar_z]
      ,[optical_prov]
      ,[mag_u]
      ,[mag_g]
      ,[mag_r]
      ,[mag_i]
      ,[mag_z]
      ,[psfmag_u]
      ,[psfmag_g]
      ,[psfmag_r]
      ,[psfmag_i]
      ,[psfmag_z]
      ,[fiber2mag_u]
      ,[fiber2mag_g]
      ,[fiber2mag_r]
      ,[fiber2mag_i]
      ,[fiber2mag_z]
      ,[catdb_mag_u]
      ,[catdb_mag_g]
      ,[catdb_mag_r]
      ,[catdb_mag_i]
      ,[catdb_mag_z]
      ,[gaia_g_mag]
      ,[gri_gaia_transform]
      ,[bp_mag]
      ,[rp_mag]
      ,[gaia_id]
      ,[wise_mag_1]
      ,[wise_mag_2]
      ,[wise_mag_3]
      ,[wise_mag_4]
      ,[twomass_mag_1]
      ,[twomass_mag_2]
      ,[twomass_mag_3]
      ,[guvcat_mag_1]
      ,[guvcat_mag_2]
      ,[ebv]
      ,[ebv_type]
      ,[fiber_ra]
      ,[fiber_dec]
      ,[plug_ra]
      ,[plug_dec]
      ,[racat]
      ,[deccat]
      ,[coord_epoch]
      ,[pmra]
      ,[pmdec]
      ,[parallax]
      ,[ra_list]
      ,[dec_list]
      ,[delta_ra_list]
      ,[delta_dec_list]
      ,[fiber_offset]
      ,[xfocal]
      ,[yfocal]
      ,[zoffset]
      ,[lambda_eff]
      ,[bluefiber]
      ,[healpix]
      ,[healpixgrp]
      ,[healpix_path]
      ,[fieldquality]
      ,[exp_disp_med]
      ,[fieldsn2]
      ,[fieldsnr2g_list]
      ,[fieldsnr2r_list]
      ,[fieldsnr2i_list]
      ,[spec1_g]
      ,[spec1_r]
      ,[spec1_i]
      ,[spec2_g]
      ,[spec2_r]
      ,[spec2_i]
      ,[sn_median_u]
      ,[sn_median_g]
      ,[sn_median_r]
      ,[sn_median_i]
      ,[sn_median_z]
      ,[sn_median_all]
      ,[airmass]
      ,[seeing20]
      ,[seeing50]
      ,[seeing80]
      ,[moon_dist]
      ,[moon_phase]
      ,[assigned]
      ,[on_target]
      ,[valid]
      ,[decollided]
      ,[anyandmask]
      ,[anyormask]
      ,[specprimary]
      ,[specboss]
      ,[boss_specobj_id]
      ,[nspecobs]
      ,[spectroflux_u]
      ,[spectroflux_g]
      ,[spectroflux_r]
      ,[spectroflux_i]
      ,[spectroflux_z]
      ,[spectroflux_ivar_u]
      ,[spectroflux_ivar_g]
      ,[spectroflux_ivar_r]
      ,[spectroflux_ivar_i]
      ,[spectroflux_ivar_z]
      ,[spectrosynflux_u]
      ,[spectrosynflux_g]
      ,[spectrosynflux_r]
      ,[spectrosynflux_i]
      ,[spectrosynflux_z]
      ,[spectrosynflux_ivar_u]
      ,[spectrosynflux_ivar_g]
      ,[spectrosynflux_ivar_r]
      ,[spectrosynflux_ivar_i]
      ,[spectrosynflux_ivar_z]
      ,[spectroskyflux_u]
      ,[spectroskyflux_g]
      ,[spectroskyflux_r]
      ,[spectroskyflux_i]
      ,[spectroskyflux_z]
      ,[wavemin]
      ,[wavemax]
      ,[wcoverage]
      ,[class]
      ,[subclass]
      ,[z]
      ,[z_err]
      ,[zwarning]
      ,[rchi2]
      ,[dof]
      ,[rchi2diff]
      ,[tfile]
      ,[tcolumn_1]
      ,[tcolumn_2]
      ,[tcolumn_3]
      ,[tcolumn_4]
      ,[tcolumn_5]
      ,[tcolumn_6]
      ,[tcolumn_7]
      ,[tcolumn_8]
      ,[tcolumn_9]
      ,[tcolumn_10]
      ,[npoly]
      ,[theta_1]
      ,[theta_2]
      ,[theta_3]
      ,[theta_4]
      ,[theta_5]
      ,[theta_6]
      ,[theta_7]
      ,[theta_8]
      ,[theta_9]
      ,[theta_10]
      ,[vdisp]
      ,[vdisp_err]
      ,[vdispz]
      ,[vdispz_err]
      ,[vdispchi2]
      ,[vdispnpix]
      ,[vdispdof]
      ,[chi68p]
      ,[fracnsigma_1]
      ,[fracnsigma_2]
      ,[fracnsigma_3]
      ,[fracnsigma_4]
      ,[fracnsigma_5]
      ,[fracnsigma_6]
      ,[fracnsigma_7]
      ,[fracnsigma_8]
      ,[fracnsigma_9]
      ,[fracnsigma_10]
      ,[fracnsighi_1]
      ,[fracnsighi_2]
      ,[fracnsighi_3]
      ,[fracnsighi_4]
      ,[fracnsighi_5]
      ,[fracnsighi_6]
      ,[fracnsighi_7]
      ,[fracnsighi_8]
      ,[fracnsighi_9]
      ,[fracnsighi_10]
      ,[fracnsiglo_1]
      ,[fracnsiglo_2]
      ,[fracnsiglo_3]
      ,[fracnsiglo_4]
      ,[fracnsiglo_5]
      ,[fracnsiglo_6]
      ,[fracnsiglo_7]
      ,[fracnsiglo_8]
      ,[fracnsiglo_9]
      ,[fracnsiglo_10]
      ,[z_noqso]
      ,[z_err_noqso]
      ,[znum_noqso]
      ,[zwarning_noqso]
      ,[class_noqso]
      ,[subclass_noqso]
      ,[rchi2diff_noqso]
      ,[xcsao_rv]
      ,[xcsao_erv]
      ,[xcsao_rxc]
      ,[xcsao_teff]
      ,[xcsao_eteff]
      ,[xcsao_logg]
      ,[xcsao_elogg]
      ,[xcsao_feh]
      ,[xcsao_efeh]
	  ,null
	  ,null
	  ,null
  FROM [dbo].[spAll]

GO


  update a
  set 
	cx = f.x,
	cy = f.y,
	cz = f.z
	from spall2 a
	cross apply dbo.fHtmEqToXyz(racat, deccat) f


exec sp_rename 'spAll', 'spAll_bak'

exec sp_rename 'spall2', 'spAll'


	create nonclustered index [ix_spall_htmid]
	on spall(htmid) INCLUDE (cx, cy,  cz)


	create nonclustered index [ix_spall_sdss_id]
	on spall(sdss_id)