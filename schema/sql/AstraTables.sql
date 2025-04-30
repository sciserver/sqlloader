--=============================================================================
--   AstraTables.sql
--   2025-04-14 Ani Thakar
-------------------------------------------------------------------------------
--  Astra schema for SkyServer  Apr-14-2025
-------------------------------------------------------------------------------
-- History:
--* 2025-04-14 Ani: Imported all the table definitions from
--*                 https://github.com/sdss/casload/tree/master/sql/astra
--* 2025-04-14 Ani: Replaced "bool" columns with "bit" iin MWM tables.
-------------------------------------------------------------------------------

SET NOCOUNT ON;
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'apogee_net_apogee_star')
	DROP TABLE apogee_net_apogee_star
GO
--
EXEC spSetDefaultFileGroup 'apogee_net_apogee_star'
GO

CREATE TABLE apogee_net_apogee_star (
--------------------------------------------------------------------------------
--/H Results from the ApogeeNet astra pipeline for each star
--
--/T Results from the ApogeeNet astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(19) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  source bigint NOT NULL, --/D Unique source primary key
  star_pk bigint NOT NULL, --/D APOGEE DRP `star` primary key
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(6) NOT NULL, --/D SDSS file type that stores this spectrum
  apred varchar(4) NOT NULL, --/D APOGEE reduction pipeline
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  obj varchar(19) NOT NULL, --/D Object name
  telescope varchar(6) NOT NULL, --/D Short telescope name
  field varchar(19) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_entries int NOT NULL, --/D apStar entries for this SDSS4_APOGEE_ID
  n_visits int NOT NULL, --/D Number of APOGEE visits
  n_good_visits int NOT NULL, --/D Number of 'good' APOGEE visits
  n_good_rvs int NOT NULL, --/D Number of 'good' APOGEE radial velocities
  snr float NOT NULL, --/D Signal-to-noise ratio
  mean_fiber float NOT NULL, --/D S/N-weighted mean visit fiber number
  std_fiber float NOT NULL, --/D Standard deviation of visit fiber numbers
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D Unique source primary key
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
  raw_e_teff float NOT NULL, --/U K --/D Raw error on stellar effective temperature 
  raw_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Raw error on surface gravity 
  raw_e_fe_h float NOT NULL, --/U dex --/D Raw error on [Fe/H] 
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'aspcap_apogee_star')
	DROP TABLE aspcap_apogee_star
GO
--
EXEC spSetDefaultFileGroup 'aspcap_apogee_star'
GO
CREATE TABLE aspcap_apogee_star (
--------------------------------------------------------------------------------
--/H Results from the ASPCAP astra pipeline for each star
--
--/T Results from the ASPCAP astra pipeline for each star. 
--/T The ASPCAP flag bitmaps are documented at 
--/T https://www.sdss.org/dr17/irspec/apogee-bitmasks#ParamBitMask, 
--/T and the weights used when computing each abundance are documented 
--/T at https://data.sdss5.org/sas/sdssrelease, 
--/T work/mwm/spectro/astra/component_data/aspcap/masks/
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(19) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(25) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  source bigint NOT NULL, --/D Unique source primary key
  star_pk bigint NOT NULL, --/D APOGEE DRP `star` primary key
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(6) NOT NULL, --/D SDSS file type that stores this spectrum
  apred varchar(5) NOT NULL, --/D APOGEE reduction pipeline
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  obj varchar(19) NOT NULL, --/D Object name
  telescope varchar(6) NOT NULL, --/D Short telescope name
  field varchar(19) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_entries int NOT NULL, --/D apStar entries for this SDSS4_APOGEE_ID
  n_visits int NOT NULL, --/D Number of APOGEE visits
  n_good_visits int NOT NULL, --/D Number of 'good' APOGEE visits
  n_good_rvs int NOT NULL, --/D Number of 'good' APOGEE radial velocities
  snr float NOT NULL, --/D Signal-to-noise ratio
  mean_fiber float NOT NULL, --/D S/N-weighted mean visit fiber number
  std_fiber float NOT NULL, --/D Standard deviation of visit fiber numbers
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  irfm_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  irfm_teff_flags bigint NOT NULL, --/D IRFM temperature flags
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  v_micro float NOT NULL, --/U km/s --/D Microturbulence 
  e_v_micro float NOT NULL, --/U km/s --/D Error on microturbulence 
  v_sini float NOT NULL, --/U km/s --/D Projected rotational velocity 
  e_v_sini float NOT NULL, --/U km/s --/D Error on projected rotational velocity 
  m_h_atm float NOT NULL, --/U dex --/D Metallicity 
  e_m_h_atm float NOT NULL, --/U dex --/D Error on metallicity 
  alpha_m_atm float NOT NULL, --/U dex --/D [alpha/M] abundance ratio 
  e_alpha_m_atm float NOT NULL, --/U dex --/D Error on [alpha/M] abundance ratio 
  c_m_atm float NOT NULL, --/U dex --/D Atmospheric carbon abundance 
  e_c_m_atm float NOT NULL, --/U dex --/D Error on atmospheric carbon abundance 
  n_m_atm float NOT NULL, --/U dex --/D Atmospheric nitrogen abundance 
  e_n_m_atm float NOT NULL, --/U dex --/D Error on atmospheric nitrogen abundance 
  al_h float NOT NULL, --/U dex --/D [Al/H] 
  e_al_h float NOT NULL, --/U dex --/D Error on [Al/H] 
  al_h_flags bigint NOT NULL, --/U dex --/D Flags for [Al/H] 
  al_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Al/H] 
  c_12_13 float NOT NULL, --/D C12/C13 ratio
  e_c_12_13 float NOT NULL, --/D Error on c12/C13 ratio
  c_12_13_flags bigint NOT NULL, --/D Flags for c12/C13 ratio
  c_12_13_rchi2 float NOT NULL, --/D Reduced chi-square value for c12/C13 ratio
  ca_h float NOT NULL, --/U dex --/D [Ca/H] 
  e_ca_h float NOT NULL, --/U dex --/D Error on [Ca/H] 
  ca_h_flags bigint NOT NULL, --/U dex --/D Flags for [Ca/H] 
  ca_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ca/H] 
  ce_h float NOT NULL, --/U dex --/D [Ce/H] 
  e_ce_h float NOT NULL, --/U dex --/D Error on [Ce/H] 
  ce_h_flags bigint NOT NULL, --/U dex --/D Flags for [Ce/H] 
  ce_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ce/H] 
  c_1_h float NOT NULL, --/U dex --/D [C/H] from neutral C lines 
  e_c_1_h float NOT NULL, --/U dex --/D Error on [C/H] from neutral C lines 
  c_1_h_flags bigint NOT NULL, --/U dex --/D Flags for [C/H] from neutral C lines 
  c_1_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [C/H] from neutral
  c_h float NOT NULL, --/U dex --/D [C/H] 
  e_c_h float NOT NULL, --/U dex --/D Error on [C/H] 
  c_h_flags bigint NOT NULL, --/U dex --/D Flags for [C/H] 
  c_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [C/H] 
  co_h float NOT NULL, --/U dex --/D [Co/H] 
  e_co_h float NOT NULL, --/U dex --/D Error on [Co/H] 
  co_h_flags bigint NOT NULL, --/U dex --/D Flags for [Co/H] 
  co_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Co/H] 
  cr_h float NOT NULL, --/U dex --/D [Cr/H] 
  e_cr_h float NOT NULL, --/U dex --/D Error on [Cr/H] 
  cr_h_flags bigint NOT NULL, --/U dex --/D Flags for [Cr/H] 
  cr_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Cr/H] 
  cu_h float NOT NULL, --/U dex --/D [Cu/H] 
  e_cu_h float NOT NULL, --/U dex --/D Error on [Cu/H] 
  cu_h_flags bigint NOT NULL, --/U dex --/D Flags for [Cu/H] 
  cu_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Cu/H] 
  fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  fe_h_flags bigint NOT NULL, --/U dex --/D Flags for [Fe/H] 
  fe_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Fe/H] 
  k_h float NOT NULL, --/U dex --/D [K/H] 
  e_k_h float NOT NULL, --/U dex --/D Error on [K/H] 
  k_h_flags bigint NOT NULL, --/U dex --/D Flags for [K/H] 
  k_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [K/H] 
  mg_h float NOT NULL, --/U dex --/D [Mg/H] 
  e_mg_h float NOT NULL, --/U dex --/D Error on [Mg/H] 
  mg_h_flags bigint NOT NULL, --/U dex --/D Flags for [Mg/H] 
  mg_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Mg/H] 
  mn_h float NOT NULL, --/U dex --/D [Mn/H] 
  e_mn_h float NOT NULL, --/U dex --/D Error on [Mn/H] 
  mn_h_flags bigint NOT NULL, --/U dex --/D Flags for [Mn/H] 
  mn_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Mn/H] 
  na_h float NOT NULL, --/U dex --/D [Na/H] 
  e_na_h float NOT NULL, --/U dex --/D Error on [Na/H] 
  na_h_flags bigint NOT NULL, --/U dex --/D Flags for [Na/H] 
  na_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Na/H] 
  nd_h float NOT NULL, --/U dex --/D [Nd/H] 
  e_nd_h float NOT NULL, --/U dex --/D Error on [Nd/H] 
  nd_h_flags bigint NOT NULL, --/U dex --/D Flags for [Nd/H] 
  nd_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Nd/H] 
  ni_h float NOT NULL, --/U dex --/D [Ni/H] 
  e_ni_h float NOT NULL, --/U dex --/D Error on [Ni/H] 
  ni_h_flags bigint NOT NULL, --/U dex --/D Flags for [Ni/H] 
  ni_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ni/H] 
  n_h float NOT NULL, --/U dex --/D [N/H] 
  e_n_h float NOT NULL, --/U dex --/D Error on [N/H] 
  n_h_flags bigint NOT NULL, --/U dex --/D Flags for [N/H] 
  n_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [N/H] 
  o_h float NOT NULL, --/U dex --/D [O/H] 
  e_o_h float NOT NULL, --/U dex --/D Error on [O/H] 
  o_h_flags bigint NOT NULL, --/U dex --/D Flags for [O/H] 
  o_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [O/H] 
  p_h float NOT NULL, --/U dex --/D [P/H] 
  e_p_h float NOT NULL, --/U dex --/D Error on [P/H] 
  p_h_flags bigint NOT NULL, --/U dex --/D Flags for [P/H] 
  p_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [P/H] 
  si_h float NOT NULL, --/U dex --/D [Si/H] 
  e_si_h float NOT NULL, --/U dex --/D Error on [Si/H] 
  si_h_flags bigint NOT NULL, --/U dex --/D Flags for [Si/H] 
  si_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Si/H] 
  s_h float NOT NULL, --/U dex --/D [S/H] 
  e_s_h float NOT NULL, --/U dex --/D Error on [S/H] 
  s_h_flags bigint NOT NULL, --/U dex --/D Flags for [S/H] 
  s_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [S/H] 
  ti_h float NOT NULL, --/U dex --/D [Ti/H] 
  e_ti_h float NOT NULL, --/U dex --/D Error on [Ti/H] 
  ti_h_flags bigint NOT NULL, --/U dex --/D Flags for [Ti/H] 
  ti_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ti/H] 
  ti_2_h float NOT NULL, --/U dex --/D [Ti/H] from singly ionized Ti lines 
  e_ti_2_h float NOT NULL, --/U d --/D Error on [Ti/H] from singly ionized Ti lines
  ti_2_h_flags bigint NOT NULL, --/U  --/D Flags for [Ti/H] from singly ionized Ti lines
  ti_2_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ti/H] from singly
  v_h float NOT NULL, --/U dex --/D [V/H] 
  e_v_h float NOT NULL, --/U dex --/D Error on [V/H] 
  v_h_flags bigint NOT NULL, --/U dex --/D Flags for [V/H] 
  v_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [V/H] 
  short_grid_name varchar(16) NOT NULL, --/D Short name describing the FERRE grid used
  continuum_order int NOT NULL, --/D Continuum order used in FERRE
  continuum_reject float NOT NULL, --/D Tolerance for FERRE to reject continuum points
  interpolation_order int NOT NULL, --/D Interpolation order used by FERRE
  initial_flags bigint NOT NULL, --/D Flags indicating source of initial guess
  rchi2 float NOT NULL, --/D Reduced chi-square value
  ferre_log_snr_sq float NOT NULL, --/D FERRE-reported log10(snr**2)
  ferre_time_elapsed float NOT NULL, --/U s --/D Total core-second use reported by FERRE 
  result_flags bigint NOT NULL, --/D Flags indicating FERRE issues
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
  stellar_parameters_task_pk bigint NOT NULL, --/D Task primary key for stellar parameters
  al_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Al/H]
  c_12_13_task_pk bigint NOT NULL, --/D Task primary key for C12/C13
  ca_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Ca/H]
  ce_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Ce/H]
  c_1_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [C 1/H]
  c_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [C/H]
  co_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Co/H]
  cr_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Cr/H]
  cu_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Cu/H]
  fe_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Fe/H]
  k_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [K/H]
  mg_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Mg/H]
  mn_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Mn/H]
  na_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Na/H]
  nd_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Nd/H]
  ni_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Ni/H]
  n_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [N/H]
  o_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [O/H]
  p_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [P/H]
  si_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Si/H]
  s_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [S/H]
  ti_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Ti/H]
  ti_2_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [Ti 2/H]
  v_h_task_pk bigint NOT NULL, --/U dex --/D Task primary key for [V/H]
  calibrated_flags bigint NOT NULL, --/D Calibration flags
  mass float NOT NULL, --/U M_sun --/D Mass inferred from isochrones 
  radius float NOT NULL, --/U R_sun --/D Radius inferred from isochrones 
  raw_teff float NOT NULL, --/U K --/D Raw stellar effective temperature 
  raw_e_teff float NOT NULL, --/U K --/D Raw error on stellar effective temperature 
  raw_logg float NOT NULL, --/U log10(cm/s^2) --/D Raw surface gravity 
  raw_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Raw error on surface gravity 
  raw_v_micro float NOT NULL, --/U km/s --/D Raw microturbulence 
  raw_e_v_micro float NOT NULL, --/U km/s --/D Raw error on microturbulence 
  raw_v_sini float NOT NULL, --/U km/s --/D Raw projected rotational velocity 
  raw_e_v_sini float NOT NULL, --/U km/ --/D Raw error on projected rotational velocity
  raw_m_h_atm float NOT NULL, --/U dex --/D Raw metallicity 
  raw_e_m_h_atm float NOT NULL, --/U dex --/D Raw error on metallicity 
  raw_alpha_m_atm float NOT NULL, --/U dex --/D Raw [alpha/M] abundance ratio 
  raw_e_alpha_m_atm float NOT NULL, --/U dex --/D Raw error on [alpha/M] abundance ratio 
  raw_c_m_atm float NOT NULL, --/U dex --/D Raw atmospheric carbon abundance 
  raw_e_c_m_atm float NOT NULL, --/U dex --/D Raw error on atmospheric carbon abundance 
  raw_n_m_atm float NOT NULL, --/U dex --/D Raw atmospheric nitrogen abundance 
  raw_e_n_m_atm float NOT NULL, --/U de --/D Raw error on atmospheric nitrogen abundance
  raw_al_h float NOT NULL, --/U dex --/D Raw [Al/H] 
  raw_e_al_h float NOT NULL, --/U dex --/D Raw error on [Al/H] 
  raw_c_12_13 float NOT NULL, --/D Raw c12/C13 ratio
  raw_e_c_12_13 float NOT NULL, --/D Raw error on c12/C13 ratio
  raw_ca_h float NOT NULL, --/U dex --/D Raw [Ca/H] 
  raw_e_ca_h float NOT NULL, --/U dex --/D Raw error on [Ca/H] 
  raw_ce_h float NOT NULL, --/U dex --/D Raw [Ce/H] 
  raw_e_ce_h float NOT NULL, --/U dex --/D Raw error on [Ce/H] 
  raw_c_1_h float NOT NULL, --/U dex --/D Raw [C/H] from neutral C lines 
  raw_e_c_1_h float NOT NULL, --/U dex --/D Raw error on [C/H] from neutral C lines 
  raw_c_h float NOT NULL, --/U dex --/D Raw [C/H] 
  raw_e_c_h float NOT NULL, --/U dex --/D Raw error on [C/H] 
  raw_co_h float NOT NULL, --/U dex --/D Raw [Co/H] 
  raw_e_co_h float NOT NULL, --/U dex --/D Raw error on [Co/H] 
  raw_cr_h float NOT NULL, --/U dex --/D Raw [Cr/H] 
  raw_e_cr_h float NOT NULL, --/U dex --/D Raw error on [Cr/H] 
  raw_cu_h float NOT NULL, --/U dex --/D Raw [Cu/H] 
  raw_e_cu_h float NOT NULL, --/U dex --/D Raw error on [Cu/H] 
  raw_fe_h float NOT NULL, --/U dex --/D Raw [Fe/H] 
  raw_e_fe_h float NOT NULL, --/U dex --/D Raw error on [Fe/H] 
  raw_k_h float NOT NULL, --/U dex --/D Raw [K/H] 
  raw_e_k_h float NOT NULL, --/U dex --/D Raw error on [K/H] 
  raw_mg_h float NOT NULL, --/U dex --/D Raw [Mg/H] 
  raw_e_mg_h float NOT NULL, --/U dex --/D Raw error on [Mg/H] 
  raw_mn_h float NOT NULL, --/U dex --/D Raw [Mn/H] 
  raw_e_mn_h float NOT NULL, --/U dex --/D Raw error on [Mn/H] 
  raw_na_h float NOT NULL, --/U dex --/D Raw [Na/H] 
  raw_e_na_h float NOT NULL, --/U dex --/D Raw error on [Na/H] 
  raw_nd_h float NOT NULL, --/U dex --/D Raw [Nd/H] 
  raw_e_nd_h float NOT NULL, --/U dex --/D Raw error on [Nd/H] 
  raw_ni_h float NOT NULL, --/U dex --/D Raw [Ni/H] 
  raw_e_ni_h float NOT NULL, --/U dex --/D Raw error on [Ni/H] 
  raw_n_h float NOT NULL, --/U dex --/D Raw [N/H] 
  raw_e_n_h float NOT NULL, --/U dex --/D Raw error on [N/H] 
  raw_o_h float NOT NULL, --/U dex --/D Raw [O/H] 
  raw_e_o_h float NOT NULL, --/U dex --/D Raw error on [O/H] 
  raw_p_h float NOT NULL, --/U dex --/D Raw [P/H] 
  raw_e_p_h float NOT NULL, --/U dex --/D Raw error on [P/H] 
  raw_si_h float NOT NULL, --/U dex --/D Raw [Si/H] 
  raw_e_si_h float NOT NULL, --/U dex --/D Raw error on [Si/H] 
  raw_s_h float NOT NULL, --/U dex --/D Raw [S/H] 
  raw_e_s_h float NOT NULL, --/U dex --/D Raw error on [S/H] 
  raw_ti_h float NOT NULL, --/U dex --/D Raw [Ti/H] 
  raw_e_ti_h float NOT NULL, --/U dex --/D Raw error on [Ti/H] 
  raw_ti_2_h float NOT NULL, --/U dex --/D Raw [Ti/H] from singly ionized Ti lines 
  raw_e_ti_2_h float NOT NULL, --/U dex --/D Raw error on [Ti/H] from singly ionized Ti line
  raw_v_h float NOT NULL, --/U dex --/D Raw [V/H] 
  raw_e_v_h float NOT NULL, --/U dex --/D Raw error on [V/H] 
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'astro_nn_apogee_star')
	DROP TABLE astro_nn_apogee_star
GO
--
EXEC spSetDefaultFileGroup 'astro_nn_apogee_star'
GO
CREATE TABLE astro_nn_apogee_star (
--------------------------------------------------------------------------------
--/H Results from the AstroNN astra pipeline for each star
--
--/T Results from the AstroNN astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(19) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  source bigint NOT NULL, --/D Unique source primary key
  star_pk bigint NOT NULL, --/D APOGEE DRP `star` primary key
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(6) NOT NULL, --/D SDSS file type that stores this spectrum
  apred varchar(5) NOT NULL, --/D APOGEE reduction pipeline
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  obj varchar(19) NOT NULL, --/D Object name
  telescope varchar(6) NOT NULL, --/D Short telescope name
  field varchar(19) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_entries int NOT NULL, --/D apStar entries for this SDSS4_APOGEE_ID
  n_visits int NOT NULL, --/D Number of APOGEE visits
  n_good_visits int NOT NULL, --/D Number of 'good' APOGEE visits
  n_good_rvs int NOT NULL, --/D Number of 'good' APOGEE radial velocities
  snr float NOT NULL, --/D Signal-to-noise ratio
  mean_fiber float NOT NULL, --/D S/N-weighted mean visit fiber number
  std_fiber float NOT NULL, --/D Standard deviation of visit fiber numbers
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D Unique source primary key
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  teff float NOT NULL, --/U K --/D Effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on effective temperature 
  logg float NOT NULL, --/U dex --/D Surface gravity 
  e_logg float NOT NULL, --/U dex --/D Error on surface gravity 
  c_h float NOT NULL, --/U dex --/D Carbon abundance 
  e_c_h float NOT NULL, --/U dex --/D Error on carbon abundance 
  c_1_h float NOT NULL, --/U dex --/D Carbon I abundance 
  e_c_1_h float NOT NULL, --/U dex --/D Error on carbon I abundance 
  n_h float NOT NULL, --/U dex --/D Nitrogen abundance 
  e_n_h float NOT NULL, --/U dex --/D Error on nitrogen abundance 
  o_h float NOT NULL, --/U dex --/D Oxygen abundance 
  e_o_h float NOT NULL, --/U dex --/D Error on oxygen abundance 
  na_h float NOT NULL, --/U dex --/D Sodium abundance 
  e_na_h float NOT NULL, --/U dex --/D Error on sodium abundance 
  mg_h float NOT NULL, --/U dex --/D Magnesium abundance 
  e_mg_h float NOT NULL, --/U dex --/D Error on magnesium abundance 
  al_h float NOT NULL, --/U dex --/D Aluminum abundance 
  e_al_h float NOT NULL, --/U dex --/D Error on aluminum abundance 
  si_h float NOT NULL, --/U dex --/D Silicon abundance 
  e_si_h float NOT NULL, --/U dex --/D Error on silicon abundance 
  p_h float NOT NULL, --/U dex --/D Phosphorus abundance 
  e_p_h float NOT NULL, --/U dex --/D Error on phosphorus abundance 
  s_h float NOT NULL, --/U dex --/D Sulfur abundance 
  e_s_h float NOT NULL, --/U dex --/D Error on sulfur abundance 
  k_h float NOT NULL, --/U dex --/D Potassium abundance 
  e_k_h float NOT NULL, --/U dex --/D Error on potassium abundance 
  ca_h float NOT NULL, --/U dex --/D Calcium abundance 
  e_ca_h float NOT NULL, --/U dex --/D Error on calcium abundance 
  ti_h float NOT NULL, --/U dex --/D Titanium abundance 
  e_ti_h float NOT NULL, --/U dex --/D Error on titanium abundance 
  ti_2_h float NOT NULL, --/U dex --/D Titanium II abundance 
  e_ti_2_h float NOT NULL, --/U dex --/D Error on titanium II abundance 
  v_h float NOT NULL, --/U dex --/D Vanadium abundance 
  e_v_h float NOT NULL, --/U dex --/D Error on vanadium abundance 
  cr_h float NOT NULL, --/U dex --/D Chromium abundance 
  e_cr_h float NOT NULL, --/U dex --/D Error on chromium abundance 
  mn_h float NOT NULL, --/U dex --/D Manganese abundance 
  e_mn_h float NOT NULL, --/U dex --/D Error on manganese abundance 
  fe_h float NOT NULL, --/U dex --/D Iron abundance 
  e_fe_h float NOT NULL, --/U dex --/D Error on iron abundance 
  co_h float NOT NULL, --/U dex --/D Cobalt abundance 
  e_co_h float NOT NULL, --/U dex --/D Error on cobalt abundance 
  ni_h float NOT NULL, --/U dex --/D Nickel abundance 
  e_ni_h float NOT NULL, --/U dex --/D Error on nickel abundance 
  raw_teff float NOT NULL, --/U K --/D Raw Effective temperature 
  raw_e_teff float NOT NULL, --/U K --/D Raw error on effective temperature 
  raw_logg float NOT NULL, --/U dex --/D Raw surface gravity 
  raw_e_logg float NOT NULL, --/U dex --/D Raw error on surface gravity 
  raw_c_h float NOT NULL, --/U dex --/D Raw carbon abundance 
  raw_e_c_h float NOT NULL, --/U dex --/D Raw error on carbon abundance 
  raw_c_1_h float NOT NULL, --/U dex --/D Raw carbon I abundance 
  raw_e_c_1_h float NOT NULL, --/U dex --/D Raw error on carbon I abundance 
  raw_n_h float NOT NULL, --/U dex --/D Raw nitrogen abundance 
  raw_e_n_h float NOT NULL, --/U dex --/D Raw error on nitrogen abundance 
  raw_o_h float NOT NULL, --/U dex --/D Raw oxygen abundance 
  raw_e_o_h float NOT NULL, --/U dex --/D Raw error on oxygen abundance 
  raw_na_h float NOT NULL, --/U dex --/D Raw sodium abundance 
  raw_e_na_h float NOT NULL, --/U dex --/D Raw error on sodium abundance 
  raw_mg_h float NOT NULL, --/U dex --/D Raw magnesium abundance 
  raw_e_mg_h float NOT NULL, --/U dex --/D Raw error on magnesium abundance 
  raw_al_h float NOT NULL, --/U dex --/D Raw aluminum abundance 
  raw_e_al_h float NOT NULL, --/U dex --/D Raw error on aluminum abundance 
  raw_si_h float NOT NULL, --/U dex --/D Raw silicon abundance 
  raw_e_si_h float NOT NULL, --/U dex --/D Raw error on silicon abundance 
  raw_p_h float NOT NULL, --/U dex --/D Raw phosphorus abundance 
  raw_e_p_h float NOT NULL, --/U dex --/D Raw error on phosphorus abundance 
  raw_s_h float NOT NULL, --/U dex --/D Raw sulfur abundance 
  raw_e_s_h float NOT NULL, --/U dex --/D Raw error on sulfur abundance 
  raw_k_h float NOT NULL, --/U dex --/D Raw potassium abundance 
  raw_e_k_h float NOT NULL, --/U dex --/D Raw error on potassium abundance 
  raw_ca_h float NOT NULL, --/U dex --/D Raw calcium abundance 
  raw_e_ca_h float NOT NULL, --/U dex --/D Raw error on calcium abundance 
  raw_ti_h float NOT NULL, --/U dex --/D Raw titanium abundance 
  raw_e_ti_h float NOT NULL, --/U dex --/D Raw error on titanium abundance 
  raw_ti_2_h float NOT NULL, --/U dex --/D Raw titanium II abundance 
  raw_e_ti_2_h float NOT NULL, --/U dex --/D Raw error on titanium II abundance 
  raw_v_h float NOT NULL, --/U dex --/D Raw vanadium abundance 
  raw_e_v_h float NOT NULL, --/U dex --/D Raw error on vanadium abundance 
  raw_cr_h float NOT NULL, --/U dex --/D Raw chromium abundance 
  raw_e_cr_h float NOT NULL, --/U dex --/D Raw error on chromium abundance 
  raw_mn_h float NOT NULL, --/U dex --/D Raw manganese abundance 
  raw_e_mn_h float NOT NULL, --/U dex --/D Raw error on manganese abundance 
  raw_fe_h float NOT NULL, --/U dex --/D Raw iron abundance 
  raw_e_fe_h float NOT NULL, --/U dex --/D Raw error on iron abundance 
  raw_co_h float NOT NULL, --/U dex --/D Raw cobalt abundance 
  raw_e_co_h float NOT NULL, --/U dex --/D Raw error on cobalt abundance 
  raw_ni_h float NOT NULL, --/U dex --/D Raw nickel abundance 
  raw_e_ni_h float NOT NULL, --/U dex --/D Raw error on nickel abundance 
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'astro_nn_apogee_visit')
	DROP TABLE astro_nn_apogee_visit
GO
--
EXEC spSetDefaultFileGroup 'astro_nn_apogee_visit'
GO
CREATE TABLE astro_nn_apogee_visit (
--------------------------------------------------------------------------------
--/H Results from the AstroNN astra pipeline for each visit
--
--/T Results from the AstroNN astra pipeline for each visit
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(18) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  star_pk bigint NOT NULL, --/D APOGEE DRP `star` primary key
  visit_pk bigint NOT NULL, --/D APOGEE DRP `visit` primary key
  rv_visit_pk bigint NOT NULL, --/D APOGEE DRP `rv_visit` primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(7) NOT NULL, --/D SDSS file type that stores this spectrum
  apred varchar(3) NOT NULL, --/D APOGEE reduction pipeline
  plate varchar(5) NOT NULL, --/D Plate identifier
  telescope varchar(6) NOT NULL, --/D Short telescope name
  fiber int NOT NULL, --/D Fiber number
  mjd int NOT NULL, --/D Modified Julian date of observation
  field varchar(22) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  reduction varchar(1) NOT NULL, --/D An `obj`-like keyword used for apo1m spectra
  obj varchar(18) NOT NULL, --/D Object name
  date_obs varchar(26) NOT NULL, --/D Observation date (UTC)
  jd float NOT NULL, --/D Julian date at mid-point of visit
  exptime float NOT NULL, --/U s --/D Exposure time 
  dithered bit NOT NULL, --/D Fraction of visits that were dithered
  f_night_time float NOT NULL, --/D Mid obs time as fraction from sunset to sunrise
  input_ra float NOT NULL, --/U deg --/D Input right ascension 
  input_dec float NOT NULL, --/U deg --/D Input declination 
  n_frames int NOT NULL, --/D Number of frames combined
  assigned int NOT NULL, --/D FPS target assigned
  on_target int NOT NULL, --/D FPS fiber on target
  valid int NOT NULL, --/D Valid FPS target
  fps bit NOT NULL, --/D Fibre positioner used to acquire this data?
  snr float NOT NULL, --/D Signal-to-noise ratio
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  bc float NOT NULL, --/U km/s --/D Barycentric velocity correction applied 
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  drp_spectrum_pk bigint NOT NULL, --/D Data Reduction Pipeline spectrum primary key
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D Unique source primary key
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  teff float NOT NULL, --/U K --/D Effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on effective temperature 
  logg float NOT NULL, --/U dex --/D Surface gravity 
  e_logg float NOT NULL, --/U dex --/D Error on surface gravity 
  c_h float NOT NULL, --/U dex --/D Carbon abundance 
  e_c_h float NOT NULL, --/U dex --/D Error on carbon abundance 
  c_1_h float NOT NULL, --/U dex --/D Carbon I abundance 
  e_c_1_h float NOT NULL, --/U dex --/D Error on carbon I abundance 
  n_h float NOT NULL, --/U dex --/D Nitrogen abundance 
  e_n_h float NOT NULL, --/U dex --/D Error on nitrogen abundance 
  o_h float NOT NULL, --/U dex --/D Oxygen abundance 
  e_o_h float NOT NULL, --/U dex --/D Error on oxygen abundance 
  na_h float NOT NULL, --/U dex --/D Sodium abundance 
  e_na_h float NOT NULL, --/U dex --/D Error on sodium abundance 
  mg_h float NOT NULL, --/U dex --/D Magnesium abundance 
  e_mg_h float NOT NULL, --/U dex --/D Error on magnesium abundance 
  al_h float NOT NULL, --/U dex --/D Aluminum abundance 
  e_al_h float NOT NULL, --/U dex --/D Error on aluminum abundance 
  si_h float NOT NULL, --/U dex --/D Silicon abundance 
  e_si_h float NOT NULL, --/U dex --/D Error on silicon abundance 
  p_h float NOT NULL, --/U dex --/D Phosphorus abundance 
  e_p_h float NOT NULL, --/U dex --/D Error on phosphorus abundance 
  s_h float NOT NULL, --/U dex --/D Sulfur abundance 
  e_s_h float NOT NULL, --/U dex --/D Error on sulfur abundance 
  k_h float NOT NULL, --/U dex --/D Potassium abundance 
  e_k_h float NOT NULL, --/U dex --/D Error on potassium abundance 
  ca_h float NOT NULL, --/U dex --/D Calcium abundance 
  e_ca_h float NOT NULL, --/U dex --/D Error on calcium abundance 
  ti_h float NOT NULL, --/U dex --/D Titanium abundance 
  e_ti_h float NOT NULL, --/U dex --/D Error on titanium abundance 
  ti_2_h float NOT NULL, --/U dex --/D Titanium II abundance 
  e_ti_2_h float NOT NULL, --/U dex --/D Error on titanium II abundance 
  v_h float NOT NULL, --/U dex --/D Vanadium abundance 
  e_v_h float NOT NULL, --/U dex --/D Error on vanadium abundance 
  cr_h float NOT NULL, --/U dex --/D Chromium abundance 
  e_cr_h float NOT NULL, --/U dex --/D Error on chromium abundance 
  mn_h float NOT NULL, --/U dex --/D Manganese abundance 
  e_mn_h float NOT NULL, --/U dex --/D Error on manganese abundance 
  fe_h float NOT NULL, --/U dex --/D Iron abundance 
  e_fe_h float NOT NULL, --/U dex --/D Error on iron abundance 
  co_h float NOT NULL, --/U dex --/D Cobalt abundance 
  e_co_h float NOT NULL, --/U dex --/D Error on cobalt abundance 
  ni_h float NOT NULL, --/U dex --/D Nickel abundance 
  e_ni_h float NOT NULL, --/U dex --/D Error on nickel abundance 
  raw_teff float NOT NULL, --/U K --/D Raw Effective temperature 
  raw_e_teff float NOT NULL, --/U K --/D Raw error on effective temperature 
  raw_logg float NOT NULL, --/U dex --/D Raw surface gravity 
  raw_e_logg float NOT NULL, --/U dex --/D Raw error on surface gravity 
  raw_c_h float NOT NULL, --/U dex --/D Raw carbon abundance 
  raw_e_c_h float NOT NULL, --/U dex --/D Raw error on carbon abundance 
  raw_c_1_h float NOT NULL, --/U dex --/D Raw carbon I abundance 
  raw_e_c_1_h float NOT NULL, --/U dex --/D Raw error on carbon I abundance 
  raw_n_h float NOT NULL, --/U dex --/D Raw nitrogen abundance 
  raw_e_n_h float NOT NULL, --/U dex --/D Raw error on nitrogen abundance 
  raw_o_h float NOT NULL, --/U dex --/D Raw oxygen abundance 
  raw_e_o_h float NOT NULL, --/U dex --/D Raw error on oxygen abundance 
  raw_na_h float NOT NULL, --/U dex --/D Raw sodium abundance 
  raw_e_na_h float NOT NULL, --/U dex --/D Raw error on sodium abundance 
  raw_mg_h float NOT NULL, --/U dex --/D Raw magnesium abundance 
  raw_e_mg_h float NOT NULL, --/U dex --/D Raw error on magnesium abundance 
  raw_al_h float NOT NULL, --/U dex --/D Raw aluminum abundance 
  raw_e_al_h float NOT NULL, --/U dex --/D Raw error on aluminum abundance 
  raw_si_h float NOT NULL, --/U dex --/D Raw silicon abundance 
  raw_e_si_h float NOT NULL, --/U dex --/D Raw error on silicon abundance 
  raw_p_h float NOT NULL, --/U dex --/D Raw phosphorus abundance 
  raw_e_p_h float NOT NULL, --/U dex --/D Raw error on phosphorus abundance 
  raw_s_h float NOT NULL, --/U dex --/D Raw sulfur abundance 
  raw_e_s_h float NOT NULL, --/U dex --/D Raw error on sulfur abundance 
  raw_k_h float NOT NULL, --/U dex --/D Raw potassium abundance 
  raw_e_k_h float NOT NULL, --/U dex --/D Raw error on potassium abundance 
  raw_ca_h float NOT NULL, --/U dex --/D Raw calcium abundance 
  raw_e_ca_h float NOT NULL, --/U dex --/D Raw error on calcium abundance 
  raw_ti_h float NOT NULL, --/U dex --/D Raw titanium abundance 
  raw_e_ti_h float NOT NULL, --/U dex --/D Raw error on titanium abundance 
  raw_ti_2_h float NOT NULL, --/U dex --/D Raw titanium II abundance 
  raw_e_ti_2_h float NOT NULL, --/U dex --/D Raw error on titanium II abundance 
  raw_v_h float NOT NULL, --/U dex --/D Raw vanadium abundance 
  raw_e_v_h float NOT NULL, --/U dex --/D Raw error on vanadium abundance 
  raw_cr_h float NOT NULL, --/U dex --/D Raw chromium abundance 
  raw_e_cr_h float NOT NULL, --/U dex --/D Raw error on chromium abundance 
  raw_mn_h float NOT NULL, --/U dex --/D Raw manganese abundance 
  raw_e_mn_h float NOT NULL, --/U dex --/D Raw error on manganese abundance 
  raw_fe_h float NOT NULL, --/U dex --/D Raw iron abundance 
  raw_e_fe_h float NOT NULL, --/U dex --/D Raw error on iron abundance 
  raw_co_h float NOT NULL, --/U dex --/D Raw cobalt abundance 
  raw_e_co_h float NOT NULL, --/U dex --/D Raw error on cobalt abundance 
  raw_ni_h float NOT NULL, --/U dex --/D Raw nickel abundance 
  raw_e_ni_h float NOT NULL, --/U dex --/D Raw error on nickel abundance 
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'astro_nn_dist_apogee_star')
	DROP TABLE astro_nn_dist_apogee_star
GO
--
EXEC spSetDefaultFileGroup 'astro_nn_dist_apogee_star'
GO

--// Created from HDU 2 in /uufs/chpc.utah.edu/common/home/sdss51/sdsswork/mwm/spectro/astra/0.6.0/summary/astraAllStarAstroNNdist-0.6.0.fits.gz
CREATE TABLE astro_nn_dist_apogee_star (
--------------------------------------------------------------------------------
--/H Results from the AstroNNdist astra pipeline for each star
--
--/T Results from the AstroNNdist astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(19) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  source bigint NOT NULL, --/D Unique source primary key
  star_pk bigint NOT NULL, --/D APOGEE DRP `star` primary key
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(6) NOT NULL, --/D SDSS file type that stores this spectrum
  apred varchar(4) NOT NULL, --/D APOGEE reduction pipeline
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  obj varchar(19) NOT NULL, --/D Object name
  telescope varchar(6) NOT NULL, --/D Short telescope name
  field varchar(19) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_entries int NOT NULL, --/D apStar entries for this SDSS4_APOGEE_ID
  n_visits int NOT NULL, --/D Number of APOGEE visits
  n_good_visits int NOT NULL, --/D Number of 'good' APOGEE visits
  n_good_rvs int NOT NULL, --/D Number of 'good' APOGEE radial velocities
  snr float NOT NULL, --/D Signal-to-noise ratio
  mean_fiber float NOT NULL, --/D S/N-weighted mean visit fiber number
  std_fiber float NOT NULL, --/D Standard deviation of visit fiber numbers
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  a_k_mag float NOT NULL, --/D Ks-band extinction
  L_fakemag float NOT NULL, --/D Predicted (fake) Ks-band absolute luminosity, L
  L_fakemag_err float NOT NULL, --/D Prediected (fake) Ks-band absolute luminosity e
  L_fakemag_model_err float NOT NULL, --/D Model error in predicted (fake) Ks-band absolu
  nn_dist float NOT NULL, --/U pc --/D NN Heliocentric distance 
  nn_dist_err float NOT NULL, --/U pc --/D NN Heliocentric distance error 
  nn_dist_model_err float NOT NULL, --/U pc --/D NN Model error in heliocentric distance 
  nn_parallax float NOT NULL, --/U mas --/D NN parallax 
  nn_parallax_err float NOT NULL, --/U mas --/D NN parallax error 
  nn_parallax_model_err float NOT NULL, --/U mas --/D NN Model error in parallax 
  gdr3_parallax_w_zp float NOT NULL, --/U mas --/D Gaia DR3 zero-point-corrected parallax 
  gdr3_parallax_err float NOT NULL, --/U mas --/D Gaia DR3 parallax error 
  gdr3_zeropoint float NOT NULL, --/U mas --/D Gaia DR3 zero-point offset 
  weighted_parallax float NOT NULL, --/U mas --/D Weighted parallax 
  weighted_parallax_err float NOT NULL, --/U mas --/D Weighted parallax error 
  weighted_dist float NOT NULL, --/U pc --/D Weighted distance 
  weighted_dist_err float NOT NULL, --/U pc --/D Weighted distance error 
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'boss_net_boss_star')
	DROP TABLE boss_net_boss_star
GO
--
EXEC spSetDefaultFileGroup 'boss_net_boss_star'
GO
CREATE TABLE boss_net_boss_star (
--------------------------------------------------------------------------------
--/H Results from the BossNet astra pipeline for each star
--
--/T Results from the BossNet astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(7) NOT NULL, --/D SDSS file type that stores this spectrum
  v_astra varchar(5) NOT NULL, --/D Astra version
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  telescope varchar(6) NOT NULL, --/D Short telescope name
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_visits int NOT NULL, --/D Number of BOSS visits
  n_good_visits int NOT NULL, --/D Number of 'good' BOSS visits
  n_good_rvs int NOT NULL, --/D Number of 'good' BOSS radial velocities
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_meanrxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  nmf_rchi2 float NOT NULL, --/D Reduced chi-square value of NMF continuum fit
  nmf_flags bigint NOT NULL, --/D NMF Continuum method flags
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
)
GO



-- DR17 no cannonStar reload

--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'boss_net_boss_visit')
	DROP TABLE boss_net_boss_visit
GO
--
EXEC spSetDefaultFileGroup 'boss_net_boss_visit'
GO
CREATE TABLE boss_net_boss_visit (
--------------------------------------------------------------------------------
--/H Results from the BossNet astra pipeline for each visit
--
--/T Results from the BossNet astra pipeline for each visit
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(8) NOT NULL, --/D SDSS file type that stores this spectrum
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  mjd int NOT NULL, --/D Modified Julian date of observation
  fieldid int NOT NULL, --/D Field identifier
  n_exp int NOT NULL, --/D Number of co-added exposures
  exptime float NOT NULL, --/U s --/D Exposure time 
  plateid int NOT NULL, --/D Plate identifier
  cartid int NOT NULL, --/D Cartridge identifier
  mapid int NOT NULL, --/D Mapping version of the loaded plate
  slitid int NOT NULL, --/D Slit identifier
  psfsky int NOT NULL, --/D Order of PSF sky subtraction
  preject float NOT NULL, --/D Profile area rejection threshold
  n_std int NOT NULL, --/D Number of (good) standard stars
  n_gal int NOT NULL, --/D Number of (good) galaxies in field
  lowrej int NOT NULL, --/D Extraction: low rejection
  highrej int NOT NULL, --/D Extraction: high rejection
  scatpoly int NOT NULL, --/D Extraction: Order of scattered light polynomial
  proftype int NOT NULL, --/D Extraction profile: 1=Gaussian
  nfitpoly int NOT NULL, --/D Extraction: Number of profile parameters
  skychi2 float NOT NULL, --/D Mean \chi^2 of sky subtraction
  schi2min float NOT NULL, --/D Minimum \chi^2 of sky subtraction
  schi2max float NOT NULL, --/D Maximum \chi^2 of sky subtraction
  alt float NOT NULL, --/U deg --/D Telescope altitude 
  az float NOT NULL, --/U deg --/D Telescope azimuth 
  telescope varchar(6) NOT NULL, --/D Short telescope name
  seeing float NOT NULL, --/U arcsecond --/D Median seeing conditions 
  airmass float NOT NULL, --/D Mean airmass
  airtemp float NOT NULL, --/U C --/D Air temperature 
  dewpoint float NOT NULL, --/U C --/D Dew point temperature 
  humidity float NOT NULL, --/U % --/D Humidity 
  pressure float NOT NULL, --/U millibar --/D Air pressure 
  dust_a float NOT NULL, --/U particles m^-3 s^-1 --/D 0.3mu-sized dust count 
  dust_b float NOT NULL, --/U particles m^-3 s^-1 --/D 1.0mu-sized dust count 
  gust_direction float NOT NULL, --/U deg --/D Wind gust direction 
  gust_speed float NOT NULL, --/U km/s --/D Wind gust speed 
  wind_direction float NOT NULL, --/U deg --/D Wind direction 
  wind_speed float NOT NULL, --/U km/s --/D Wind speed 
  moon_dist_mean float NOT NULL, --/U deg --/D Mean sky distance to the moon 
  moon_phase_mean float NOT NULL, --/D Mean phase of the moon
  n_guide int NOT NULL, --/D Number of guider frames during integration
  tai_beg bigint NOT NULL, --/U s --/D MJD (TAI) at start of integrations 
  tai_end bigint NOT NULL, --/U s --/D MJD (TAI) at end of integrations 
  fiber_offset bit NOT NULL, --/D Position offset applied during observations
  f_night_time float NOT NULL, --/D Mid obs time as fraction from sunset to sunrise
  delta_ra_1 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 1 --/F delta_ra
  delta_ra_2 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 2 --/F delta_ra
  delta_ra_3 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 3 --/F delta_ra
  delta_ra_4 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 4 --/F delta_ra
  delta_ra_5 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 5 --/F delta_ra
  delta_ra_6 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 6 --/F delta_ra
  delta_ra_7 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 7 --/F delta_ra
  delta_ra_8 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 8 --/F delta_ra
  delta_ra_9 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 9 --/F delta_ra
  delta_ra_0 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 10 --/F delta_ra
  delta_ra_11 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 11 --/F delta_ra
  delta_ra_12 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 12 --/F delta_ra
  delta_ra_13 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 13 --/F delta_ra
  delta_ra_14 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 14 --/F delta_ra
  delta_ra_15 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 15 --/F delta_ra
  delta_ra_16 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 16 --/F delta_ra
  delta_ra_17 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 17 --/F delta_ra
  delta_ra_18 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 18 --/F delta_ra
  delta_dec_1 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 1 --/F delta_dec
  delta_dec_2 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 2 --/F delta_dec
  delta_dec_3 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 3 --/F delta_dec
  delta_dec_4 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 4 --/F delta_dec
  delta_dec_5 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 5 --/F delta_dec
  delta_dec_6 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 6 --/F delta_dec
  delta_dec_7 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 7 --/F delta_dec
  delta_dec_8 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 8 --/F delta_dec
  delta_dec_9 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 9 --/F delta_dec
  delta_dec_10 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 10 --/F delta_dec
  delta_dec_11 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 11 --/F delta_dec
  delta_dec_12 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 12 --/F delta_dec
  delta_dec_13 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 13 --/F delta_dec
  delta_dec_14 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 14 --/F delta_dec
  delta_dec_15 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 15 --/F delta_dec
  delta_dec_16 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 16 --/F delta_dec
  delta_dec_17 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 17 --/F delta_dec
  delta_dec_18 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 18 --/F delta_dec
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  xcsao_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcsao_e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_rxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
)
GO

-- DR17 no cannonStar reload



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'corv_boss_visit')
	DROP TABLE corv_boss_visit
GO
--
EXEC spSetDefaultFileGroup 'corv_boss_visit'
GO
CREATE TABLE corv_boss_visit (
--------------------------------------------------------------------------------
--/H Results from the Corv astra pipeline for each visit
--
--/T Results from the Corv astra pipeline for each visit
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(15) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(8) NOT NULL, --/D SDSS file type that stores this spectrum
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  mjd int NOT NULL, --/D Modified Julian date of observation
  fieldid int NOT NULL, --/D Field identifier
  n_exp int NOT NULL, --/D Number of co-added exposures
  exptime float NOT NULL, --/U s --/D Exposure time 
  plateid int NOT NULL, --/D Plate identifier
  cartid int NOT NULL, --/D Cartridge identifier
  mapid int NOT NULL, --/D Mapping version of the loaded plate
  slitid int NOT NULL, --/D Slit identifier
  psfsky int NOT NULL, --/D Order of PSF sky subtraction
  preject float NOT NULL, --/D Profile area rejection threshold
  n_std int NOT NULL, --/D Number of (good) standard stars
  n_gal int NOT NULL, --/D Number of (good) galaxies in field
  lowrej int NOT NULL, --/D Extraction: low rejection
  highrej int NOT NULL, --/D Extraction: high rejection
  scatpoly int NOT NULL, --/D Extraction: Order of scattered light polynomial
  proftype int NOT NULL, --/D Extraction profile: 1=Gaussian
  nfitpoly int NOT NULL, --/D Extraction: Number of profile parameters
  skychi2 float NOT NULL, --/D Mean \chi^2 of sky subtraction
  schi2min float NOT NULL, --/D Minimum \chi^2 of sky subtraction
  schi2max float NOT NULL, --/D Maximum \chi^2 of sky subtraction
  alt float NOT NULL, --/U deg --/D Telescope altitude 
  az float NOT NULL, --/U deg --/D Telescope azimuth 
  telescope varchar(6) NOT NULL, --/D Short telescope name
  seeing float NOT NULL, --/U arcsecond --/D Median seeing conditions 
  airmass float NOT NULL, --/D Mean airmass
  airtemp float NOT NULL, --/U C --/D Air temperature 
  dewpoint float NOT NULL, --/U C --/D Dew point temperature 
  humidity float NOT NULL, --/U % --/D Humidity 
  pressure float NOT NULL, --/U millibar --/D Air pressure 
  dust_a float NOT NULL, --/U particles m^-3 s^-1 --/D 0.3mu-sized dust count 
  dust_b float NOT NULL, --/U particles m^-3 s^-1 --/D 1.0mu-sized dust count 
  gust_direction float NOT NULL, --/U deg --/D Wind gust direction 
  gust_speed float NOT NULL, --/U km/s --/D Wind gust speed 
  wind_direction float NOT NULL, --/U deg --/D Wind direction 
  wind_speed float NOT NULL, --/U km/s --/D Wind speed 
  moon_dist_mean float NOT NULL, --/U deg --/D Mean sky distance to the moon 
  moon_phase_mean float NOT NULL, --/D Mean phase of the moon
  n_guide int NOT NULL, --/D Number of guider frames during integration
  tai_beg bigint NOT NULL, --/U s --/D MJD (TAI) at start of integrations 
  tai_end bigint NOT NULL, --/U s --/D MJD (TAI) at end of integrations 
  fiber_offset bit NOT NULL, --/D Position offset applied during observations
  f_night_time float NOT NULL, --/D Mid obs time as fraction from sunset to sunrise
  delta_ra_1 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 1 --/F delta_ra
  delta_ra_2 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 2 --/F delta_ra
  delta_ra_3 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 3 --/F delta_ra
  delta_ra_4 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 4 --/F delta_ra
  delta_ra_5 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 5 --/F delta_ra
  delta_ra_6 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 6 --/F delta_ra
  delta_ra_7 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 7 --/F delta_ra
  delta_ra_8 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 8 --/F delta_ra
  delta_ra_9 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 9 --/F delta_ra
  delta_ra_0 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 10 --/F delta_ra
  delta_ra_11 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 11 --/F delta_ra
  delta_ra_12 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 12 --/F delta_ra
  delta_ra_13 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 13 --/F delta_ra
  delta_ra_14 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 14 --/F delta_ra
  delta_dec_1 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 1 --/F delta_dec
  delta_dec_2 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 2 --/F delta_dec
  delta_dec_3 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 3 --/F delta_dec
  delta_dec_4 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 4 --/F delta_dec
  delta_dec_5 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 5 --/F delta_dec
  delta_dec_6 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 6 --/F delta_dec
  delta_dec_7 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 7 --/F delta_dec
  delta_dec_8 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 8 --/F delta_dec
  delta_dec_9 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 9 --/F delta_dec
  delta_dec_10 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 10 --/F delta_dec
  delta_dec_11 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 11 --/F delta_dec
  delta_dec_12 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 12 --/F delta_dec
  delta_dec_13 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 13 --/F delta_dec
  delta_dec_14 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 14 --/F delta_dec
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  xcsao_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcsao_e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_rxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  initial_teff float NOT NULL, --/U K --/D Initial stellar effective temperature 
  initial_logg float NOT NULL, --/U log10(cm/s^2) --/D Initial surface gravity 
  initial_v_rad float NOT NULL, --/U km/s --/D Initial radial velocity 
  rchi2 float NOT NULL, --/D Reduced chi-square value
  result_flags int NOT NULL, --/D Flags describing the results
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'line_forest_boss_star')
	DROP TABLE line_forest_boss_star
GO
--
EXEC spSetDefaultFileGroup 'line_forest_boss_star'
GO
CREATE TABLE line_forest_boss_star (
--------------------------------------------------------------------------------
--/H Results from the LineForest astra pipeline for each star
--
--/T Results from the LineForest astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(7) NOT NULL, --/D SDSS file type that stores this spectrum
  v_astra varchar(5) NOT NULL, --/D Astra version
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  telescope varchar(6) NOT NULL, --/D Short telescope name
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_visits int NOT NULL, --/D Number of BOSS visits
  n_good_visits int NOT NULL, --/D Number of 'good' BOSS visits
  n_good_rvs int NOT NULL, --/D Number of 'good' BOSS radial velocities
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_meanrxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  nmf_rchi2 float NOT NULL, --/D Reduced chi-square value of NMF continuum fit
  nmf_flags bigint NOT NULL, --/D NMF Continuum method flags
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  eqw_h_alpha float NOT NULL, --/U A --/D Equivalent width of H-alpha 
  abs_h_alpha float NOT NULL, --/D 
  detection_stat_h_alpha float NOT NULL, --/D Detection probability (+1: absorption; 0: u
  detection_raw_h_alpha float NOT NULL, --/D Probability that feature is not noise (0: no
  eqw_percentiles_h_alpha_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-alpha  --/F eqw_percentiles_h_alpha
  eqw_percentiles_h_alpha_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-alpha  --/F eqw_percentiles_h_alpha
  eqw_percentiles_h_alpha_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-alpha  --/F eqw_percentiles_h_alpha
  abs_percentiles_h_alpha_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-alpha  --/F abs_percentiles_h_alpha
  abs_percentiles_h_alpha_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-alpha  --/F abs_percentiles_h_alpha
  abs_percentiles_h_alpha_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-alpha  --/F abs_percentiles_h_alpha
  eqw_h_beta float NOT NULL, --/U A --/D Equivalent width of H-beta 
  abs_h_beta float NOT NULL, --/D 
  detection_stat_h_beta float NOT NULL, --/D Detection probability (+1: absorption; 0: un
  detection_raw_h_beta float NOT NULL, --/D Probability that feature is not noise (0: noi
  eqw_percentiles_h_beta_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-beta  --/F eqw_percentiles_h_beta
  eqw_percentiles_h_beta_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-beta  --/F eqw_percentiles_h_beta
  eqw_percentiles_h_beta_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-beta  --/F eqw_percentiles_h_beta
  abs_percentiles_h_beta_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-beta  --/F abs_percentiles_h_beta
  abs_percentiles_h_beta_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-beta  --/F abs_percentiles_h_beta
  abs_percentiles_h_beta_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-beta  --/F abs_percentiles_h_beta
  eqw_h_gamma float NOT NULL, --/U A --/D Equivalent width of H-gamma 
  abs_h_gamma float NOT NULL, --/D 
  detection_stat_h_gamma float NOT NULL, --/D Detection probability (+1: absorption; 0: u
  detection_raw_h_gamma float NOT NULL, --/D Probability that feature is not noise (0: no
  eqw_percentiles_h_gamma_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-gamma  --/F eqw_percentiles_h_gamma
  eqw_percentiles_h_gamma_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-gamma  --/F eqw_percentiles_h_gamma
  eqw_percentiles_h_gamma_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-gamma  --/F eqw_percentiles_h_gamma
  abs_percentiles_h_gamma_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-gamma  --/F abs_percentiles_h_gamma
  abs_percentiles_h_gamma_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-gamma  --/F abs_percentiles_h_gamma
  abs_percentiles_h_gamma_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-gamma  --/F abs_percentiles_h_gamma
  eqw_h_delta float NOT NULL, --/U A --/D Equivalent width of H-delta 
  abs_h_delta float NOT NULL, --/D 
  detection_stat_h_delta float NOT NULL, --/D Detection probability (+1: absorption; 0: u
  detection_raw_h_delta float NOT NULL, --/D Probability that feature is not noise (0: no
  eqw_percentiles_h_delta_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-delta  --/F eqw_percentiles_h_delta
  eqw_percentiles_h_delta_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-delta  --/F eqw_percentiles_h_delta
  eqw_percentiles_h_delta_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-delta  --/F eqw_percentiles_h_delta
  abs_percentiles_h_delta_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-delta  --/F abs_percentiles_h_delta
  abs_percentiles_h_delta_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-delta  --/F abs_percentiles_h_delta
  abs_percentiles_h_delta_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-delta  --/F abs_percentiles_h_delta
  eqw_h_epsilon float NOT NULL, --/U A --/D Equivalent width of H-epsilon 
  abs_h_epsilon float NOT NULL, --/D 
  detection_stat_h_epsilon float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_h_epsilon float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_h_epsilon_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-epsilon  --/F eqw_percentiles_h_epsilon
  eqw_percentiles_h_epsilon_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-epsilon  --/F eqw_percentiles_h_epsilon
  eqw_percentiles_h_epsilon_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-epsilon  --/F eqw_percentiles_h_epsilon
  abs_percentiles_h_epsilon_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-epsilon  --/F abs_percentiles_h_epsilon
  abs_percentiles_h_epsilon_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-epsilon  --/F abs_percentiles_h_epsilon
  abs_percentiles_h_epsilon_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-epsilon  --/F abs_percentiles_h_epsilon
  eqw_h_8 float NOT NULL, --/U A --/D Equivalent width of H-8 
  abs_h_8 float NOT NULL, --/D 
  detection_stat_h_8 float NOT NULL, --/D Detection probability (+1: absorption; 0: undet
  detection_raw_h_8 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_8_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-8  --/F eqw_percentiles_h_8
  eqw_percentiles_h_8_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-8  --/F eqw_percentiles_h_8
  eqw_percentiles_h_8_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-8  --/F eqw_percentiles_h_8
  abs_percentiles_h_8_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-8  --/F abs_percentiles_h_8
  abs_percentiles_h_8_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-8  --/F abs_percentiles_h_8
  abs_percentiles_h_8_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-8  --/F abs_percentiles_h_8
  eqw_h_9 float NOT NULL, --/U A --/D Equivalent width of H-9 
  abs_h_9 float NOT NULL, --/D 
  detection_stat_h_9 float NOT NULL, --/D Detection probability (+1: absorption; 0: undet
  detection_raw_h_9 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_9_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-9  --/F eqw_percentiles_h_9
  eqw_percentiles_h_9_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-9  --/F eqw_percentiles_h_9
  eqw_percentiles_h_9_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-9  --/F eqw_percentiles_h_9
  abs_percentiles_h_9_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-9  --/F abs_percentiles_h_9
  abs_percentiles_h_9_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-9  --/F abs_percentiles_h_9
  abs_percentiles_h_9_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-9  --/F abs_percentiles_h_9
  eqw_h_10 float NOT NULL, --/U A --/D Equivalent width of H-10 
  abs_h_10 float NOT NULL, --/D 
  detection_stat_h_10 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_10 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_10_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-10  --/F eqw_percentiles_h_10
  eqw_percentiles_h_10_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-10  --/F eqw_percentiles_h_10
  eqw_percentiles_h_10_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-10  --/F eqw_percentiles_h_10
  abs_percentiles_h_10_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-10  --/F abs_percentiles_h_10
  abs_percentiles_h_10_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-10  --/F abs_percentiles_h_10
  abs_percentiles_h_10_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-10  --/F abs_percentiles_h_10
  eqw_h_11 float NOT NULL, --/U A --/D Equivalent width of H-11 
  abs_h_11 float NOT NULL, --/D 
  detection_stat_h_11 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_11 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_11_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-11  --/F eqw_percentiles_h_11
  eqw_percentiles_h_11_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-11  --/F eqw_percentiles_h_11
  eqw_percentiles_h_11_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-11  --/F eqw_percentiles_h_11
  abs_percentiles_h_11_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-11  --/F abs_percentiles_h_11
  abs_percentiles_h_11_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-11  --/F abs_percentiles_h_11
  abs_percentiles_h_11_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-11  --/F abs_percentiles_h_11
  eqw_h_12 float NOT NULL, --/U A --/D Equivalent width of H-12 
  abs_h_12 float NOT NULL, --/D 
  detection_stat_h_12 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_12 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_12_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-12  --/F eqw_percentiles_h_12
  eqw_percentiles_h_12_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-12  --/F eqw_percentiles_h_12
  eqw_percentiles_h_12_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-12  --/F eqw_percentiles_h_12
  abs_percentiles_h_12_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-12  --/F abs_percentiles_h_12
  abs_percentiles_h_12_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-12  --/F abs_percentiles_h_12
  abs_percentiles_h_12_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-12  --/F abs_percentiles_h_12
  eqw_h_13 float NOT NULL, --/U A --/D Equivalent width of H-13 
  abs_h_13 float NOT NULL, --/D 
  detection_stat_h_13 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_13 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_13_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-13  --/F eqw_percentiles_h_13
  eqw_percentiles_h_13_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-13  --/F eqw_percentiles_h_13
  eqw_percentiles_h_13_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-13  --/F eqw_percentiles_h_13
  abs_percentiles_h_13_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-13  --/F abs_percentiles_h_13
  abs_percentiles_h_13_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-13  --/F abs_percentiles_h_13
  abs_percentiles_h_13_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-13  --/F abs_percentiles_h_13
  eqw_h_14 float NOT NULL, --/U A --/D Equivalent width of H-14 
  abs_h_14 float NOT NULL, --/D 
  detection_stat_h_14 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_14 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_14_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-14  --/F eqw_percentiles_h_14
  eqw_percentiles_h_14_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-14  --/F eqw_percentiles_h_14
  eqw_percentiles_h_14_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-14  --/F eqw_percentiles_h_14
  abs_percentiles_h_14_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-14  --/F abs_percentiles_h_14
  abs_percentiles_h_14_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-14  --/F abs_percentiles_h_14
  abs_percentiles_h_14_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-14  --/F abs_percentiles_h_14
  eqw_h_15 float NOT NULL, --/U A --/D Equivalent width of H-15 
  abs_h_15 float NOT NULL, --/D 
  detection_stat_h_15 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_15 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_15_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-15  --/F eqw_percentiles_h_15
  eqw_percentiles_h_15_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-15  --/F eqw_percentiles_h_15
  eqw_percentiles_h_15_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-15  --/F eqw_percentiles_h_15
  abs_percentiles_h_15_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-15  --/F abs_percentiles_h_15
  abs_percentiles_h_15_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-15  --/F abs_percentiles_h_15
  abs_percentiles_h_15_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-15  --/F abs_percentiles_h_15
  eqw_h_16 float NOT NULL, --/U A --/D Equivalent width of H-16 
  abs_h_16 float NOT NULL, --/D 
  detection_stat_h_16 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_16 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_16_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-16  --/F eqw_percentiles_h_16
  eqw_percentiles_h_16_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-16  --/F eqw_percentiles_h_16
  eqw_percentiles_h_16_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-16  --/F eqw_percentiles_h_16
  abs_percentiles_h_16_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-16  --/F abs_percentiles_h_16
  abs_percentiles_h_16_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-16  --/F abs_percentiles_h_16
  abs_percentiles_h_16_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-16  --/F abs_percentiles_h_16
  eqw_h_17 float NOT NULL, --/U A --/D Equivalent width of H-17 
  abs_h_17 float NOT NULL, --/D 
  detection_stat_h_17 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_17 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_17_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-17  --/F eqw_percentiles_h_17
  eqw_percentiles_h_17_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-17  --/F eqw_percentiles_h_17
  eqw_percentiles_h_17_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-17  --/F eqw_percentiles_h_17
  abs_percentiles_h_17_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-17  --/F abs_percentiles_h_17
  abs_percentiles_h_17_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-17  --/F abs_percentiles_h_17
  abs_percentiles_h_17_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-17  --/F abs_percentiles_h_17
  eqw_pa_7 float NOT NULL, --/U A --/D Equivalent width of Pa-7 
  abs_pa_7 float NOT NULL, --/D 
  detection_stat_pa_7 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_pa_7 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_pa_7_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-7  --/F eqw_percentiles_pa_7
  eqw_percentiles_pa_7_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-7  --/F eqw_percentiles_pa_7
  eqw_percentiles_pa_7_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-7  --/F eqw_percentiles_pa_7
  abs_percentiles_pa_7_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-7  --/F abs_percentiles_pa_7
  abs_percentiles_pa_7_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-7  --/F abs_percentiles_pa_7
  abs_percentiles_pa_7_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-7  --/F abs_percentiles_pa_7
  eqw_pa_8 float NOT NULL, --/U A --/D Equivalent width of Pa-8 
  abs_pa_8 float NOT NULL, --/D 
  detection_stat_pa_8 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_pa_8 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_pa_8_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-8  --/F eqw_percentiles_pa_8
  eqw_percentiles_pa_8_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-8  --/F eqw_percentiles_pa_8
  eqw_percentiles_pa_8_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-8  --/F eqw_percentiles_pa_8
  abs_percentiles_pa_8_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-8  --/F abs_percentiles_pa_8
  abs_percentiles_pa_8_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-8  --/F abs_percentiles_pa_8
  abs_percentiles_pa_8_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-8  --/F abs_percentiles_pa_8
  eqw_pa_9 float NOT NULL, --/U A --/D Equivalent width of Pa-9 
  abs_pa_9 float NOT NULL, --/D 
  detection_stat_pa_9 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_pa_9 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_pa_9_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-9  --/F eqw_percentiles_pa_9
  eqw_percentiles_pa_9_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-9  --/F eqw_percentiles_pa_9
  eqw_percentiles_pa_9_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-9  --/F eqw_percentiles_pa_9
  abs_percentiles_pa_9_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-9  --/F abs_percentiles_pa_9
  abs_percentiles_pa_9_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-9  --/F abs_percentiles_pa_9
  abs_percentiles_pa_9_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-9  --/F abs_percentiles_pa_9
  eqw_pa_10 float NOT NULL, --/U A --/D Equivalent width of Pa-10 
  abs_pa_10 float NOT NULL, --/D 
  detection_stat_pa_10 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_10 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_10_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-10  --/F eqw_percentiles_pa_10
  eqw_percentiles_pa_10_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-10  --/F eqw_percentiles_pa_10
  eqw_percentiles_pa_10_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-10  --/F eqw_percentiles_pa_10
  abs_percentiles_pa_10_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-10  --/F abs_percentiles_pa_10
  abs_percentiles_pa_10_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-10  --/F abs_percentiles_pa_10
  abs_percentiles_pa_10_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-10  --/F abs_percentiles_pa_10
  eqw_pa_11 float NOT NULL, --/U A --/D Equivalent width of Pa-11 
  abs_pa_11 float NOT NULL, --/D 
  detection_stat_pa_11 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_11 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_11_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-11  --/F eqw_percentiles_pa_11
  eqw_percentiles_pa_11_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-11  --/F eqw_percentiles_pa_11
  eqw_percentiles_pa_11_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-11  --/F eqw_percentiles_pa_11
  abs_percentiles_pa_11_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-11  --/F abs_percentiles_pa_11
  abs_percentiles_pa_11_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-11  --/F abs_percentiles_pa_11
  abs_percentiles_pa_11_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-11  --/F abs_percentiles_pa_11
  eqw_pa_12 float NOT NULL, --/U A --/D Equivalent width of Pa-12 
  abs_pa_12 float NOT NULL, --/D 
  detection_stat_pa_12 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_12 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_12_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-12  --/F eqw_percentiles_pa_12
  eqw_percentiles_pa_12_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-12  --/F eqw_percentiles_pa_12
  eqw_percentiles_pa_12_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-12  --/F eqw_percentiles_pa_12
  abs_percentiles_pa_12_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-12  --/F abs_percentiles_pa_12
  abs_percentiles_pa_12_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-12  --/F abs_percentiles_pa_12
  abs_percentiles_pa_12_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-12  --/F abs_percentiles_pa_12
  eqw_pa_13 float NOT NULL, --/U A --/D Equivalent width of Pa-13 
  abs_pa_13 float NOT NULL, --/D 
  detection_stat_pa_13 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_13 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_13_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-13  --/F eqw_percentiles_pa_13
  eqw_percentiles_pa_13_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-13  --/F eqw_percentiles_pa_13
  eqw_percentiles_pa_13_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-13  --/F eqw_percentiles_pa_13
  abs_percentiles_pa_13_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-13  --/F abs_percentiles_pa_13
  abs_percentiles_pa_13_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-13  --/F abs_percentiles_pa_13
  abs_percentiles_pa_13_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-13  --/F abs_percentiles_pa_13
  eqw_pa_14 float NOT NULL, --/U A --/D Equivalent width of Pa-14 
  abs_pa_14 float NOT NULL, --/D 
  detection_stat_pa_14 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_14 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_14_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-14  --/F eqw_percentiles_pa_14
  eqw_percentiles_pa_14_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-14  --/F eqw_percentiles_pa_14
  eqw_percentiles_pa_14_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-14  --/F eqw_percentiles_pa_14
  abs_percentiles_pa_14_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-14  --/F abs_percentiles_pa_14
  abs_percentiles_pa_14_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-14  --/F abs_percentiles_pa_14
  abs_percentiles_pa_14_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-14  --/F abs_percentiles_pa_14
  eqw_pa_15 float NOT NULL, --/U A --/D Equivalent width of Pa-15 
  abs_pa_15 float NOT NULL, --/D 
  detection_stat_pa_15 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_15 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_15_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-15  --/F eqw_percentiles_pa_15
  eqw_percentiles_pa_15_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-15  --/F eqw_percentiles_pa_15
  eqw_percentiles_pa_15_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-15  --/F eqw_percentiles_pa_15
  abs_percentiles_pa_15_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-15  --/F abs_percentiles_pa_15
  abs_percentiles_pa_15_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-15  --/F abs_percentiles_pa_15
  abs_percentiles_pa_15_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-15  --/F abs_percentiles_pa_15
  eqw_pa_16 float NOT NULL, --/U A --/D Equivalent width of Pa-16 
  abs_pa_16 float NOT NULL, --/D 
  detection_stat_pa_16 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_16 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_16_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-16  --/F eqw_percentiles_pa_16
  eqw_percentiles_pa_16_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-16  --/F eqw_percentiles_pa_16
  eqw_percentiles_pa_16_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-16  --/F eqw_percentiles_pa_16
  abs_percentiles_pa_16_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-16  --/F abs_percentiles_pa_16
  abs_percentiles_pa_16_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-16  --/F abs_percentiles_pa_16
  abs_percentiles_pa_16_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-16  --/F abs_percentiles_pa_16
  eqw_pa_17 float NOT NULL, --/U A --/D Equivalent width of Pa-17 
  abs_pa_17 float NOT NULL, --/D 
  detection_stat_pa_17 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_17 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_17_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-17  --/F eqw_percentiles_pa_17
  eqw_percentiles_pa_17_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-17  --/F eqw_percentiles_pa_17
  eqw_percentiles_pa_17_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-17  --/F eqw_percentiles_pa_17
  abs_percentiles_pa_17_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-17  --/F abs_percentiles_pa_17
  abs_percentiles_pa_17_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-17  --/F abs_percentiles_pa_17
  abs_percentiles_pa_17_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-17  --/F abs_percentiles_pa_17
  eqw_ca_ii_8662 float NOT NULL, --/U A --/D Equivalent width of Ca II at 8662 A 
  abs_ca_ii_8662 float NOT NULL, --/D 
  detection_stat_ca_ii_8662 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_ca_ii_8662 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_ii_8662_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca II at 8662 A  --/F eqw_percentiles_ca_ii_8662
  eqw_percentiles_ca_ii_8662_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca II at 8662 A  --/F eqw_percentiles_ca_ii_8662
  eqw_percentiles_ca_ii_8662_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca II at 8662 A  --/F eqw_percentiles_ca_ii_8662
  abs_percentiles_ca_ii_8662_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca II at 8662 A  --/F abs_percentiles_ca_ii_8662
  abs_percentiles_ca_ii_8662_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca II at 8662 A  --/F abs_percentiles_ca_ii_8662
  abs_percentiles_ca_ii_8662_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca II at 8662 A  --/F abs_percentiles_ca_ii_8662
  eqw_ca_ii_8542 float NOT NULL, --/U A --/D Equivalent width of Ca II at 8542 A 
  abs_ca_ii_8542 float NOT NULL, --/D 
  detection_stat_ca_ii_8542 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_ca_ii_8542 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_ii_8542_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca II at 8542 A  --/F eqw_percentiles_ca_ii_8542
  eqw_percentiles_ca_ii_8542_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca II at 8542 A  --/F eqw_percentiles_ca_ii_8542
  eqw_percentiles_ca_ii_8542_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca II at 8542 A  --/F eqw_percentiles_ca_ii_8542
  abs_percentiles_ca_ii_8542_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca II at 8542 A  --/F abs_percentiles_ca_ii_8542
  abs_percentiles_ca_ii_8542_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca II at 8542 A  --/F abs_percentiles_ca_ii_8542
  abs_percentiles_ca_ii_8542_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca II at 8542 A  --/F abs_percentiles_ca_ii_8542
  eqw_ca_ii_8498 float NOT NULL, --/U A --/D Equivalent width of Ca II at 8498 A 
  abs_ca_ii_8498 float NOT NULL, --/D 
  detection_stat_ca_ii_8498 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_ca_ii_8498 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_ii_8498_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca II at 8498 A  --/F eqw_percentiles_ca_ii_8498
  eqw_percentiles_ca_ii_8498_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca II at 8498 A  --/F eqw_percentiles_ca_ii_8498
  eqw_percentiles_ca_ii_8498_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca II at 8498 A  --/F eqw_percentiles_ca_ii_8498
  abs_percentiles_ca_ii_8498_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca II at 8498 A  --/F abs_percentiles_ca_ii_8498
  abs_percentiles_ca_ii_8498_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca II at 8498 A  --/F abs_percentiles_ca_ii_8498
  abs_percentiles_ca_ii_8498_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca II at 8498 A  --/F abs_percentiles_ca_ii_8498
  eqw_ca_k_3933 float NOT NULL, --/U A --/D Equivalent width of Ca K at 3933 A 
  abs_ca_k_3933 float NOT NULL, --/D 
  detection_stat_ca_k_3933 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_ca_k_3933 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_k_3933_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca K at 3933 A  --/F eqw_percentiles_ca_k_3933
  eqw_percentiles_ca_k_3933_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca K at 3933 A  --/F eqw_percentiles_ca_k_3933
  eqw_percentiles_ca_k_3933_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca K at 3933 A  --/F eqw_percentiles_ca_k_3933
  abs_percentiles_ca_k_3933_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca K at 3933 A  --/F abs_percentiles_ca_k_3933
  abs_percentiles_ca_k_3933_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca K at 3933 A  --/F abs_percentiles_ca_k_3933
  abs_percentiles_ca_k_3933_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca K at 3933 A  --/F abs_percentiles_ca_k_3933
  eqw_ca_h_3968 float NOT NULL, --/U A --/D Equivalent width of Ca H at 3968 A 
  abs_ca_h_3968 float NOT NULL, --/D 
  detection_stat_ca_h_3968 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_ca_h_3968 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_h_3968_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca H at 3968 A  --/F eqw_percentiles_ca_h_3968
  eqw_percentiles_ca_h_3968_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca H at 3968 A  --/F eqw_percentiles_ca_h_3968
  eqw_percentiles_ca_h_3968_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca H at 3968 A  --/F eqw_percentiles_ca_h_3968
  abs_percentiles_ca_h_3968_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca H at 3968 A  --/F abs_percentiles_ca_h_3968
  abs_percentiles_ca_h_3968_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca H at 3968 A  --/F abs_percentiles_ca_h_3968
  abs_percentiles_ca_h_3968_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca H at 3968 A  --/F abs_percentiles_ca_h_3968
  eqw_he_i_6678 float NOT NULL, --/U A --/D Equivalent width of He I at 6678 A 
  abs_he_i_6678 float NOT NULL, --/D 
  detection_stat_he_i_6678 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_he_i_6678 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_i_6678_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He I at 6678 A  --/F eqw_percentiles_he_i_6678
  eqw_percentiles_he_i_6678_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He I at 6678 A  --/F eqw_percentiles_he_i_6678
  eqw_percentiles_he_i_6678_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He I at 6678 A  --/F eqw_percentiles_he_i_6678
  abs_percentiles_he_i_6678_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He I at 6678 A  --/F abs_percentiles_he_i_6678
  abs_percentiles_he_i_6678_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He I at 6678 A  --/F abs_percentiles_he_i_6678
  abs_percentiles_he_i_6678_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He I at 6678 A  --/F abs_percentiles_he_i_6678
  eqw_he_i_5875 float NOT NULL, --/U A --/D Equivalent width of He I at 5875 A 
  abs_he_i_5875 float NOT NULL, --/D 
  detection_stat_he_i_5875 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_he_i_5875 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_i_5875_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He I at 5875 A  --/F eqw_percentiles_he_i_5875
  eqw_percentiles_he_i_5875_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He I at 5875 A  --/F eqw_percentiles_he_i_5875
  eqw_percentiles_he_i_5875_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He I at 5875 A  --/F eqw_percentiles_he_i_5875
  abs_percentiles_he_i_5875_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He I at 5875 A  --/F abs_percentiles_he_i_5875
  abs_percentiles_he_i_5875_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He I at 5875 A  --/F abs_percentiles_he_i_5875
  abs_percentiles_he_i_5875_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He I at 5875 A  --/F abs_percentiles_he_i_5875
  eqw_he_i_5015 float NOT NULL, --/U A --/D Equivalent width of He I at 5015 A 
  abs_he_i_5015 float NOT NULL, --/D 
  detection_stat_he_i_5015 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_he_i_5015 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_i_5015_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He I at 5015 A  --/F eqw_percentiles_he_i_5015
  eqw_percentiles_he_i_5015_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He I at 5015 A  --/F eqw_percentiles_he_i_5015
  eqw_percentiles_he_i_5015_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He I at 5015 A  --/F eqw_percentiles_he_i_5015
  abs_percentiles_he_i_5015_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He I at 5015 A  --/F abs_percentiles_he_i_5015
  abs_percentiles_he_i_5015_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He I at 5015 A  --/F abs_percentiles_he_i_5015
  abs_percentiles_he_i_5015_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He I at 5015 A  --/F abs_percentiles_he_i_5015
  eqw_he_i_4471 float NOT NULL, --/U A --/D Equivalent width of He I at 4471 A 
  abs_he_i_4471 float NOT NULL, --/D 
  detection_stat_he_i_4471 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_he_i_4471 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_i_4471_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He I at 4471 A  --/F eqw_percentiles_he_i_4471
  eqw_percentiles_he_i_4471_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He I at 4471 A  --/F eqw_percentiles_he_i_4471
  eqw_percentiles_he_i_4471_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He I at 4471 A  --/F eqw_percentiles_he_i_4471
  abs_percentiles_he_i_4471_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He I at 4471 A  --/F abs_percentiles_he_i_4471
  abs_percentiles_he_i_4471_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He I at 4471 A  --/F abs_percentiles_he_i_4471
  abs_percentiles_he_i_4471_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He I at 4471 A  --/F abs_percentiles_he_i_4471
  eqw_he_ii_4685 float NOT NULL, --/U A --/D Equivalent width of He II at 4685 A 
  abs_he_ii_4685 float NOT NULL, --/D 
  detection_stat_he_ii_4685 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_he_ii_4685 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_ii_4685_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He II at 4685 A  --/F eqw_percentiles_he_ii_4685
  eqw_percentiles_he_ii_4685_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He II at 4685 A  --/F eqw_percentiles_he_ii_4685
  eqw_percentiles_he_ii_4685_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He II at 4685 A  --/F eqw_percentiles_he_ii_4685
  abs_percentiles_he_ii_4685_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He II at 4685 A  --/F abs_percentiles_he_ii_4685
  abs_percentiles_he_ii_4685_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He II at 4685 A  --/F abs_percentiles_he_ii_4685
  abs_percentiles_he_ii_4685_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He II at 4685 A  --/F abs_percentiles_he_ii_4685
  eqw_n_ii_6583 float NOT NULL, --/U A --/D Equivalent width of N II at 6583 A 
  abs_n_ii_6583 float NOT NULL, --/D 
  detection_stat_n_ii_6583 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_n_ii_6583 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_n_ii_6583_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of N II at 6583 A  --/F eqw_percentiles_n_ii_6583
  eqw_percentiles_n_ii_6583_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of N II at 6583 A  --/F eqw_percentiles_n_ii_6583
  eqw_percentiles_n_ii_6583_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of N II at 6583 A  --/F eqw_percentiles_n_ii_6583
  abs_percentiles_n_ii_6583_16 float NOT NULL, --/U  --/D 16th ABS percentiles of N II at 6583 A  --/F abs_percentiles_n_ii_6583
  abs_percentiles_n_ii_6583_50 float NOT NULL, --/U  --/D 50th ABS percentiles of N II at 6583 A  --/F abs_percentiles_n_ii_6583
  abs_percentiles_n_ii_6583_84 float NOT NULL, --/U  --/D 84th ABS percentiles of N II at 6583 A  --/F abs_percentiles_n_ii_6583
  eqw_n_ii_6548 float NOT NULL, --/U A --/D Equivalent width of N II at 6548 A 
  abs_n_ii_6548 float NOT NULL, --/D 
  detection_stat_n_ii_6548 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_n_ii_6548 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_n_ii_6548_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of N II at 6548 A  --/F eqw_percentiles_n_ii_6548
  eqw_percentiles_n_ii_6548_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of N II at 6548 A  --/F eqw_percentiles_n_ii_6548
  eqw_percentiles_n_ii_6548_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of N II at 6548 A  --/F eqw_percentiles_n_ii_6548
  abs_percentiles_n_ii_6548_16 float NOT NULL, --/U  --/D 16th ABS percentiles of N II at 6548 A  --/F abs_percentiles_n_ii_6548
  abs_percentiles_n_ii_6548_50 float NOT NULL, --/U  --/D 50th ABS percentiles of N II at 6548 A  --/F abs_percentiles_n_ii_6548
  abs_percentiles_n_ii_6548_84 float NOT NULL, --/U  --/D 84th ABS percentiles of N II at 6548 A  --/F abs_percentiles_n_ii_6548
  eqw_s_ii_6716 float NOT NULL, --/U A --/D Equivalent width of S II at 6716 A 
  abs_s_ii_6716 float NOT NULL, --/D 
  detection_stat_s_ii_6716 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_s_ii_6716 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_s_ii_6716_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of S II at 6716 A  --/F eqw_percentiles_s_ii_6716
  eqw_percentiles_s_ii_6716_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of S II at 6716 A  --/F eqw_percentiles_s_ii_6716
  eqw_percentiles_s_ii_6716_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of S II at 6716 A  --/F eqw_percentiles_s_ii_6716
  abs_percentiles_s_ii_6716_16 float NOT NULL, --/U  --/D 16th ABS percentiles of S II at 6716 A  --/F abs_percentiles_s_ii_6716
  abs_percentiles_s_ii_6716_50 float NOT NULL, --/U  --/D 50th ABS percentiles of S II at 6716 A  --/F abs_percentiles_s_ii_6716
  abs_percentiles_s_ii_6716_84 float NOT NULL, --/U  --/D 84th ABS percentiles of S II at 6716 A  --/F abs_percentiles_s_ii_6716
  eqw_s_ii_6730 float NOT NULL, --/U A --/D Equivalent width of S II at 6730 A 
  abs_s_ii_6730 float NOT NULL, --/D 
  detection_stat_s_ii_6730 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_s_ii_6730 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_s_ii_6730_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of S II at 6730 A  --/F eqw_percentiles_s_ii_6730
  eqw_percentiles_s_ii_6730_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of S II at 6730 A  --/F eqw_percentiles_s_ii_6730
  eqw_percentiles_s_ii_6730_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of S II at 6730 A  --/F eqw_percentiles_s_ii_6730
  abs_percentiles_s_ii_6730_16 float NOT NULL, --/U  --/D 16th ABS percentiles of S II at 6730 A  --/F abs_percentiles_s_ii_6730
  abs_percentiles_s_ii_6730_50 float NOT NULL, --/U  --/D 50th ABS percentiles of S II at 6730 A  --/F abs_percentiles_s_ii_6730
  abs_percentiles_s_ii_6730_84 float NOT NULL, --/U  --/D 84th ABS percentiles of S II at 6730 A  --/F abs_percentiles_s_ii_6730
  eqw_fe_ii_5018 float NOT NULL, --/U A --/D Equivalent width of Fe II at 5018 A 
  abs_fe_ii_5018 float NOT NULL, --/D 
  detection_stat_fe_ii_5018 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_fe_ii_5018 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_fe_ii_5018_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Fe II at 5018 A  --/F eqw_percentiles_fe_ii_5018
  eqw_percentiles_fe_ii_5018_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Fe II at 5018 A  --/F eqw_percentiles_fe_ii_5018
  eqw_percentiles_fe_ii_5018_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Fe II at 5018 A  --/F eqw_percentiles_fe_ii_5018
  abs_percentiles_fe_ii_5018_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Fe II at 5018 A  --/F abs_percentiles_fe_ii_5018
  abs_percentiles_fe_ii_5018_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Fe II at 5018 A  --/F abs_percentiles_fe_ii_5018
  abs_percentiles_fe_ii_5018_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Fe II at 5018 A  --/F abs_percentiles_fe_ii_5018
  eqw_fe_ii_5169 float NOT NULL, --/U A --/D Equivalent width of Fe II at 5169 A 
  abs_fe_ii_5169 float NOT NULL, --/D 
  detection_stat_fe_ii_5169 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_fe_ii_5169 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_fe_ii_5169_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Fe II at 5169 A  --/F eqw_percentiles_fe_ii_5169
  eqw_percentiles_fe_ii_5169_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Fe II at 5169 A  --/F eqw_percentiles_fe_ii_5169
  eqw_percentiles_fe_ii_5169_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Fe II at 5169 A  --/F eqw_percentiles_fe_ii_5169
  abs_percentiles_fe_ii_5169_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Fe II at 5169 A  --/F abs_percentiles_fe_ii_5169
  abs_percentiles_fe_ii_5169_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Fe II at 5169 A  --/F abs_percentiles_fe_ii_5169
  abs_percentiles_fe_ii_5169_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Fe II at 5169 A  --/F abs_percentiles_fe_ii_5169
  eqw_fe_ii_5197 float NOT NULL, --/U A --/D Equivalent width of Fe II at 5197 A 
  abs_fe_ii_5197 float NOT NULL, --/D 
  detection_stat_fe_ii_5197 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_fe_ii_5197 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_fe_ii_5197_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Fe II at 5197 A  --/F eqw_percentiles_fe_ii_5197
  eqw_percentiles_fe_ii_5197_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Fe II at 5197 A  --/F eqw_percentiles_fe_ii_5197
  eqw_percentiles_fe_ii_5197_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Fe II at 5197 A  --/F eqw_percentiles_fe_ii_5197
  abs_percentiles_fe_ii_5197_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Fe II at 5197 A  --/F abs_percentiles_fe_ii_5197
  abs_percentiles_fe_ii_5197_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Fe II at 5197 A  --/F abs_percentiles_fe_ii_5197
  abs_percentiles_fe_ii_5197_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Fe II at 5197 A  --/F abs_percentiles_fe_ii_5197
  eqw_fe_ii_6432 float NOT NULL, --/U A --/D Equivalent width of Fe II at 6432 A 
  abs_fe_ii_6432 float NOT NULL, --/D 
  detection_stat_fe_ii_6432 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_fe_ii_6432 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_fe_ii_6432_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Fe II at 6432 A  --/F eqw_percentiles_fe_ii_6432
  eqw_percentiles_fe_ii_6432_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Fe II at 6432 A  --/F eqw_percentiles_fe_ii_6432
  eqw_percentiles_fe_ii_6432_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Fe II at 6432 A  --/F eqw_percentiles_fe_ii_6432
  abs_percentiles_fe_ii_6432_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Fe II at 6432 A  --/F abs_percentiles_fe_ii_6432
  abs_percentiles_fe_ii_6432_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Fe II at 6432 A  --/F abs_percentiles_fe_ii_6432
  abs_percentiles_fe_ii_6432_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Fe II at 6432 A  --/F abs_percentiles_fe_ii_6432
  eqw_o_i_5577 float NOT NULL, --/U A --/D Equivalent width of O I at 5577 A
  abs_o_i_5577 float NOT NULL, --/D 
  detection_stat_o_i_5577 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_o_i_5577 float NOT NULL, --/D Probability that feature is not noise (0: n
  eqw_percentiles_o_i_5577_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O I at 5577 A --/F eqw_percentiles_o_i_5577
  eqw_percentiles_o_i_5577_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O I at 5577 A --/F eqw_percentiles_o_i_5577
  eqw_percentiles_o_i_5577_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O I at 5577 A --/F eqw_percentiles_o_i_5577
  abs_percentiles_o_i_5577_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O I at 5577 A --/F abs_percentiles_o_i_5577
  abs_percentiles_o_i_5577_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O I at 5577 A --/F abs_percentiles_o_i_5577
  abs_percentiles_o_i_5577_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O I at 5577 A --/F abs_percentiles_o_i_5577
  eqw_o_i_6300 float NOT NULL, --/U A --/D Equivalent width of O I at 6300 A 
  abs_o_i_6300 float NOT NULL, --/D 
  detection_stat_o_i_6300 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_o_i_6300 float NOT NULL, --/D Probability that feature is not noise (0: n
  eqw_percentiles_o_i_6300_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O I at 6300 A  --/F eqw_percentiles_o_i_6300
  eqw_percentiles_o_i_6300_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O I at 6300 A  --/F eqw_percentiles_o_i_6300
  eqw_percentiles_o_i_6300_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O I at 6300 A  --/F eqw_percentiles_o_i_6300
  abs_percentiles_o_i_6300_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O I at 6300 A  --/F abs_percentiles_o_i_6300
  abs_percentiles_o_i_6300_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O I at 6300 A  --/F abs_percentiles_o_i_6300
  abs_percentiles_o_i_6300_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O I at 6300 A  --/F abs_percentiles_o_i_6300
  eqw_o_i_6363 float NOT NULL, --/U A --/D Equivalent width of O I at 6363 A
  abs_o_i_6363 float NOT NULL, --/D 
  detection_stat_o_i_6363 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_o_i_6363 float NOT NULL, --/D Probability that feature is not noise (0: n
  eqw_percentiles_o_i_6363_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O I at 6363 A --/F eqw_percentiles_o_i_6363
  eqw_percentiles_o_i_6363_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O I at 6363 A --/F eqw_percentiles_o_i_6363
  eqw_percentiles_o_i_6363_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O I at 6363 A --/F eqw_percentiles_o_i_6363
  abs_percentiles_o_i_6363_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O I at 6363 A --/F abs_percentiles_o_i_6363
  abs_percentiles_o_i_6363_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O I at 6363 A --/F abs_percentiles_o_i_6363
  abs_percentiles_o_i_6363_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O I at 6363 A --/F abs_percentiles_o_i_6363
  eqw_o_ii_3727 float NOT NULL, --/U A --/D Equivalent width of O II at 3727 A 
  abs_o_ii_3727 float NOT NULL, --/D 
  detection_stat_o_ii_3727 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_o_ii_3727 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_o_ii_3727_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O II at 3727 A  --/F eqw_percentiles_o_ii_3727
  eqw_percentiles_o_ii_3727_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O II at 3727 A  --/F eqw_percentiles_o_ii_3727
  eqw_percentiles_o_ii_3727_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O II at 3727 A  --/F eqw_percentiles_o_ii_3727
  abs_percentiles_o_ii_3727_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O II at 3727 A  --/F abs_percentiles_o_ii_3727
  abs_percentiles_o_ii_3727_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O II at 3727 A  --/F abs_percentiles_o_ii_3727
  abs_percentiles_o_ii_3727_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O II at 3727 A  --/F abs_percentiles_o_ii_3727
  eqw_o_iii_4959 float NOT NULL, --/U A --/D Equivalent width of O III at 4959 A 
  abs_o_iii_4959 float NOT NULL, --/D 
  detection_stat_o_iii_4959 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_o_iii_4959 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_o_iii_4959_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O III at 4959 A  --/F eqw_percentiles_o_iii_4959
  eqw_percentiles_o_iii_4959_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O III at 4959 A  --/F eqw_percentiles_o_iii_4959
  eqw_percentiles_o_iii_4959_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O III at 4959 A  --/F eqw_percentiles_o_iii_4959
  abs_percentiles_o_iii_4959_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O III at 4959 A  --/F abs_percentiles_o_iii_4959
  abs_percentiles_o_iii_4959_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O III at 4959 A  --/F abs_percentiles_o_iii_4959
  abs_percentiles_o_iii_4959_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O III at 4959 A  --/F abs_percentiles_o_iii_4959
  eqw_o_iii_5006 float NOT NULL, --/U A --/D Equivalent width of O III at 5006 A 
  abs_o_iii_5006 float NOT NULL, --/D 
  detection_stat_o_iii_5006 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_o_iii_5006 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_o_iii_5006_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O III at 5006 A  --/F eqw_percentiles_o_iii_5006
  eqw_percentiles_o_iii_5006_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O III at 5006 A  --/F eqw_percentiles_o_iii_5006
  eqw_percentiles_o_iii_5006_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O III at 5006 A  --/F eqw_percentiles_o_iii_5006
  abs_percentiles_o_iii_5006_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O III at 5006 A  --/F abs_percentiles_o_iii_5006
  abs_percentiles_o_iii_5006_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O III at 5006 A  --/F abs_percentiles_o_iii_5006
  abs_percentiles_o_iii_5006_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O III at 5006 A  --/F abs_percentiles_o_iii_5006
  eqw_o_iii_4363 float NOT NULL, --/U A --/D Equivalent width of O III at 4363 A 
  abs_o_iii_4363 float NOT NULL, --/D 
  detection_stat_o_iii_4363 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_o_iii_4363 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_o_iii_4363_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O III at 4363 A  --/F eqw_percentiles_o_iii_4363
  eqw_percentiles_o_iii_4363_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O III at 4363 A  --/F eqw_percentiles_o_iii_4363
  eqw_percentiles_o_iii_4363_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O III at 4363 A  --/F eqw_percentiles_o_iii_4363
  abs_percentiles_o_iii_4363_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O III at 4363 A  --/F abs_percentiles_o_iii_4363
  abs_percentiles_o_iii_4363_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O III at 4363 A  --/F abs_percentiles_o_iii_4363
  abs_percentiles_o_iii_4363_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O III at 4363 A  --/F abs_percentiles_o_iii_4363
  eqw_li_i float NOT NULL, --/U A --/D Equivalent width of Li I at 6707 A 
  abs_li_i float NOT NULL, --/D 
  detection_stat_li_i float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_li_i float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_li_i_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Li I at 6707 A  --/F eqw_percentiles_li_i
  eqw_percentiles_li_i_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Li I at 6707 A  --/F eqw_percentiles_li_i
  eqw_percentiles_li_i_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Li I at 6707 A  --/F eqw_percentiles_li_i
  abs_percentiles_li_i_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Li I at 6707 A  --/F abs_percentiles_li_i
  abs_percentiles_li_i_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Li I at 6707 A  --/F abs_percentiles_li_i
  abs_percentiles_li_i_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Li I at 6707 A  --/F abs_percentiles_li_i
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'line_forest_boss_visit')
	DROP TABLE line_forest_boss_visit
GO
--
EXEC spSetDefaultFileGroup 'line_forest_boss_visit'
GO
CREATE TABLE line_forest_boss_visit (
--------------------------------------------------------------------------------
--/H Results from the LineForest astra pipeline for each visit
--
--/T Results from the LineForest astra pipeline for each visit
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(17) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(8) NOT NULL, --/D SDSS file type that stores this spectrum
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  mjd int NOT NULL, --/D Modified Julian date of observation
  fieldid int NOT NULL, --/D Field identifier
  n_exp int NOT NULL, --/D Number of co-added exposures
  exptime float NOT NULL, --/U s --/D Exposure time 
  plateid int NOT NULL, --/D Plate identifier
  cartid int NOT NULL, --/D Cartridge identifier
  mapid int NOT NULL, --/D Mapping version of the loaded plate
  slitid int NOT NULL, --/D Slit identifier
  psfsky int NOT NULL, --/D Order of PSF sky subtraction
  preject float NOT NULL, --/D Profile area rejection threshold
  n_std int NOT NULL, --/D Number of (good) standard stars
  n_gal int NOT NULL, --/D Number of (good) galaxies in field
  lowrej int NOT NULL, --/D Extraction: low rejection
  highrej int NOT NULL, --/D Extraction: high rejection
  scatpoly int NOT NULL, --/D Extraction: Order of scattered light polynomial
  proftype int NOT NULL, --/D Extraction profile: 1=Gaussian
  nfitpoly int NOT NULL, --/D Extraction: Number of profile parameters
  skychi2 float NOT NULL, --/D Mean \chi^2 of sky subtraction
  schi2min float NOT NULL, --/D Minimum \chi^2 of sky subtraction
  schi2max float NOT NULL, --/D Maximum \chi^2 of sky subtraction
  alt float NOT NULL, --/U deg --/D Telescope altitude 
  az float NOT NULL, --/U deg --/D Telescope azimuth 
  telescope varchar(6) NOT NULL, --/D Short telescope name
  seeing float NOT NULL, --/U arcsecond --/D Median seeing conditions 
  airmass float NOT NULL, --/D Mean airmass
  airtemp float NOT NULL, --/U C --/D Air temperature 
  dewpoint float NOT NULL, --/U C --/D Dew point temperature 
  humidity float NOT NULL, --/U % --/D Humidity 
  pressure float NOT NULL, --/U millibar --/D Air pressure 
  dust_a float NOT NULL, --/U particles m^-3 s^-1 --/D 0.3mu-sized dust count 
  dust_b float NOT NULL, --/U particles m^-3 s^-1 --/D 1.0mu-sized dust count 
  gust_direction float NOT NULL, --/U deg --/D Wind gust direction 
  gust_speed float NOT NULL, --/U km/s --/D Wind gust speed 
  wind_direction float NOT NULL, --/U deg --/D Wind direction 
  wind_speed float NOT NULL, --/U km/s --/D Wind speed 
  moon_dist_mean float NOT NULL, --/U deg --/D Mean sky distance to the moon 
  moon_phase_mean float NOT NULL, --/D Mean phase of the moon
  n_guide int NOT NULL, --/D Number of guider frames during integration
  tai_beg bigint NOT NULL, --/U s --/D MJD (TAI) at start of integrations 
  tai_end bigint NOT NULL, --/U s --/D MJD (TAI) at end of integrations 
  fiber_offset bit NOT NULL, --/D Position offset applied during observations
  f_night_time float NOT NULL, --/D Mid obs time as fraction from sunset to sunrise
  delta_ra_1 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 1 --/F delta_ra
  delta_ra_2 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 2 --/F delta_ra
  delta_ra_3 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 3 --/F delta_ra
  delta_ra_4 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 4 --/F delta_ra
  delta_ra_5 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 5 --/F delta_ra
  delta_ra_6 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 6 --/F delta_ra
  delta_ra_7 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 7 --/F delta_ra
  delta_ra_8 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 8 --/F delta_ra
  delta_ra_9 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 9 --/F delta_ra
  delta_ra_0 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 10 --/F delta_ra
  delta_ra_11 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 11 --/F delta_ra
  delta_ra_12 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 12 --/F delta_ra
  delta_ra_13 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 13 --/F delta_ra
  delta_ra_14 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 14 --/F delta_ra
  delta_ra_15 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 15 --/F delta_ra
  delta_ra_16 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 16 --/F delta_ra
  delta_ra_17 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 17 --/F delta_ra
  delta_ra_18 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 18 --/F delta_ra
  delta_dec_1 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 1 --/F delta_dec
  delta_dec_2 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 2 --/F delta_dec
  delta_dec_3 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 3 --/F delta_dec
  delta_dec_4 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 4 --/F delta_dec
  delta_dec_5 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 5 --/F delta_dec
  delta_dec_6 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 6 --/F delta_dec
  delta_dec_7 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 7 --/F delta_dec
  delta_dec_8 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 8 --/F delta_dec
  delta_dec_9 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 9 --/F delta_dec
  delta_dec_10 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 10 --/F delta_dec
  delta_dec_11 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 11 --/F delta_dec
  delta_dec_12 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 12 --/F delta_dec
  delta_dec_13 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 13 --/F delta_dec
  delta_dec_14 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 14 --/F delta_dec
  delta_dec_15 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 15 --/F delta_dec
  delta_dec_16 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 16 --/F delta_dec
  delta_dec_17 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 17 --/F delta_dec
  delta_dec_18 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 18 --/F delta_dec
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  xcsao_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcsao_e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_rxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  eqw_h_alpha float NOT NULL, --/U A --/D Equivalent width of H-alpha 
  abs_h_alpha float NOT NULL, --/D 
  detection_stat_h_alpha float NOT NULL, --/D Detection probability (+1: absorption; 0: u
  detection_raw_h_alpha float NOT NULL, --/D Probability that feature is not noise (0: no
  eqw_percentiles_h_alpha_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-alpha  --/F eqw_percentiles_h_alpha
  eqw_percentiles_h_alpha_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-alpha  --/F eqw_percentiles_h_alpha
  eqw_percentiles_h_alpha_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-alpha  --/F eqw_percentiles_h_alpha
  abs_percentiles_h_alpha_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-alpha  --/F abs_percentiles_h_alpha
  abs_percentiles_h_alpha_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-alpha  --/F abs_percentiles_h_alpha
  abs_percentiles_h_alpha_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-alpha  --/F abs_percentiles_h_alpha
  eqw_h_beta float NOT NULL, --/U A --/D Equivalent width of H-beta 
  abs_h_beta float NOT NULL, --/D 
  detection_stat_h_beta float NOT NULL, --/D Detection probability (+1: absorption; 0: un
  detection_raw_h_beta float NOT NULL, --/D Probability that feature is not noise (0: noi
  eqw_percentiles_h_beta_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-beta  --/F eqw_percentiles_h_beta
  eqw_percentiles_h_beta_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-beta  --/F eqw_percentiles_h_beta
  eqw_percentiles_h_beta_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-beta  --/F eqw_percentiles_h_beta
  abs_percentiles_h_beta_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-beta  --/F abs_percentiles_h_beta
  abs_percentiles_h_beta_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-beta  --/F abs_percentiles_h_beta
  abs_percentiles_h_beta_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-beta  --/F abs_percentiles_h_beta
  eqw_h_gamma float NOT NULL, --/U A --/D Equivalent width of H-gamma 
  abs_h_gamma float NOT NULL, --/D 
  detection_stat_h_gamma float NOT NULL, --/D Detection probability (+1: absorption; 0: u
  detection_raw_h_gamma float NOT NULL, --/D Probability that feature is not noise (0: no
  eqw_percentiles_h_gamma_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-gamma  --/F eqw_percentiles_h_gamma
  eqw_percentiles_h_gamma_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-gamma  --/F eqw_percentiles_h_gamma
  eqw_percentiles_h_gamma_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-gamma  --/F eqw_percentiles_h_gamma
  abs_percentiles_h_gamma_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-gamma  --/F abs_percentiles_h_gamma
  abs_percentiles_h_gamma_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-gamma  --/F abs_percentiles_h_gamma
  abs_percentiles_h_gamma_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-gamma  --/F abs_percentiles_h_gamma
  eqw_h_delta float NOT NULL, --/U A --/D Equivalent width of H-delta 
  abs_h_delta float NOT NULL, --/D 
  detection_stat_h_delta float NOT NULL, --/D Detection probability (+1: absorption; 0: u
  detection_raw_h_delta float NOT NULL, --/D Probability that feature is not noise (0: no
  eqw_percentiles_h_delta_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-delta  --/F eqw_percentiles_h_delta
  eqw_percentiles_h_delta_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-delta  --/F eqw_percentiles_h_delta
  eqw_percentiles_h_delta_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-delta  --/F eqw_percentiles_h_delta
  abs_percentiles_h_delta_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-delta  --/F abs_percentiles_h_delta
  abs_percentiles_h_delta_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-delta  --/F abs_percentiles_h_delta
  abs_percentiles_h_delta_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-delta  --/F abs_percentiles_h_delta
  eqw_h_epsilon float NOT NULL, --/U A --/D Equivalent width of H-epsilon 
  abs_h_epsilon float NOT NULL, --/D 
  detection_stat_h_epsilon float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_h_epsilon float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_h_epsilon_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-epsilon  --/F eqw_percentiles_h_epsilon
  eqw_percentiles_h_epsilon_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-epsilon  --/F eqw_percentiles_h_epsilon
  eqw_percentiles_h_epsilon_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-epsilon  --/F eqw_percentiles_h_epsilon
  abs_percentiles_h_epsilon_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-epsilon  --/F abs_percentiles_h_epsilon
  abs_percentiles_h_epsilon_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-epsilon  --/F abs_percentiles_h_epsilon
  abs_percentiles_h_epsilon_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-epsilon  --/F abs_percentiles_h_epsilon
  eqw_h_8 float NOT NULL, --/U A --/D Equivalent width of H-8 
  abs_h_8 float NOT NULL, --/D 
  detection_stat_h_8 float NOT NULL, --/D Detection probability (+1: absorption; 0: undet
  detection_raw_h_8 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_8_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-8  --/F eqw_percentiles_h_8
  eqw_percentiles_h_8_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-8  --/F eqw_percentiles_h_8
  eqw_percentiles_h_8_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-8  --/F eqw_percentiles_h_8
  abs_percentiles_h_8_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-8  --/F abs_percentiles_h_8
  abs_percentiles_h_8_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-8  --/F abs_percentiles_h_8
  abs_percentiles_h_8_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-8  --/F abs_percentiles_h_8
  eqw_h_9 float NOT NULL, --/U A --/D Equivalent width of H-9 
  abs_h_9 float NOT NULL, --/D 
  detection_stat_h_9 float NOT NULL, --/D Detection probability (+1: absorption; 0: undet
  detection_raw_h_9 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_9_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-9  --/F eqw_percentiles_h_9
  eqw_percentiles_h_9_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-9  --/F eqw_percentiles_h_9
  eqw_percentiles_h_9_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-9  --/F eqw_percentiles_h_9
  abs_percentiles_h_9_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-9  --/F abs_percentiles_h_9
  abs_percentiles_h_9_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-9  --/F abs_percentiles_h_9
  abs_percentiles_h_9_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-9  --/F abs_percentiles_h_9
  eqw_h_10 float NOT NULL, --/U A --/D Equivalent width of H-10 
  abs_h_10 float NOT NULL, --/D 
  detection_stat_h_10 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_10 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_10_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-10  --/F eqw_percentiles_h_10
  eqw_percentiles_h_10_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-10  --/F eqw_percentiles_h_10
  eqw_percentiles_h_10_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-10  --/F eqw_percentiles_h_10
  abs_percentiles_h_10_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-10  --/F abs_percentiles_h_10
  abs_percentiles_h_10_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-10  --/F abs_percentiles_h_10
  abs_percentiles_h_10_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-10  --/F abs_percentiles_h_10
  eqw_h_11 float NOT NULL, --/U A --/D Equivalent width of H-11 
  abs_h_11 float NOT NULL, --/D 
  detection_stat_h_11 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_11 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_11_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-11  --/F eqw_percentiles_h_11
  eqw_percentiles_h_11_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-11  --/F eqw_percentiles_h_11
  eqw_percentiles_h_11_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-11  --/F eqw_percentiles_h_11
  abs_percentiles_h_11_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-11  --/F abs_percentiles_h_11
  abs_percentiles_h_11_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-11  --/F abs_percentiles_h_11
  abs_percentiles_h_11_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-11  --/F abs_percentiles_h_11
  eqw_h_12 float NOT NULL, --/U A --/D Equivalent width of H-12 
  abs_h_12 float NOT NULL, --/D 
  detection_stat_h_12 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_12 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_12_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-12  --/F eqw_percentiles_h_12
  eqw_percentiles_h_12_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-12  --/F eqw_percentiles_h_12
  eqw_percentiles_h_12_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-12  --/F eqw_percentiles_h_12
  abs_percentiles_h_12_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-12  --/F abs_percentiles_h_12
  abs_percentiles_h_12_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-12  --/F abs_percentiles_h_12
  abs_percentiles_h_12_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-12  --/F abs_percentiles_h_12
  eqw_h_13 float NOT NULL, --/U A --/D Equivalent width of H-13 
  abs_h_13 float NOT NULL, --/D 
  detection_stat_h_13 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_13 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_13_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-13  --/F eqw_percentiles_h_13
  eqw_percentiles_h_13_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-13  --/F eqw_percentiles_h_13
  eqw_percentiles_h_13_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-13  --/F eqw_percentiles_h_13
  abs_percentiles_h_13_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-13  --/F abs_percentiles_h_13
  abs_percentiles_h_13_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-13  --/F abs_percentiles_h_13
  abs_percentiles_h_13_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-13  --/F abs_percentiles_h_13
  eqw_h_14 float NOT NULL, --/U A --/D Equivalent width of H-14 
  abs_h_14 float NOT NULL, --/D 
  detection_stat_h_14 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_14 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_14_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-14  --/F eqw_percentiles_h_14
  eqw_percentiles_h_14_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-14  --/F eqw_percentiles_h_14
  eqw_percentiles_h_14_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-14  --/F eqw_percentiles_h_14
  abs_percentiles_h_14_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-14  --/F abs_percentiles_h_14
  abs_percentiles_h_14_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-14  --/F abs_percentiles_h_14
  abs_percentiles_h_14_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-14  --/F abs_percentiles_h_14
  eqw_h_15 float NOT NULL, --/U A --/D Equivalent width of H-15 
  abs_h_15 float NOT NULL, --/D 
  detection_stat_h_15 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_15 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_15_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-15  --/F eqw_percentiles_h_15
  eqw_percentiles_h_15_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-15  --/F eqw_percentiles_h_15
  eqw_percentiles_h_15_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-15  --/F eqw_percentiles_h_15
  abs_percentiles_h_15_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-15  --/F abs_percentiles_h_15
  abs_percentiles_h_15_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-15  --/F abs_percentiles_h_15
  abs_percentiles_h_15_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-15  --/F abs_percentiles_h_15
  eqw_h_16 float NOT NULL, --/U A --/D Equivalent width of H-16 
  abs_h_16 float NOT NULL, --/D 
  detection_stat_h_16 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_16 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_16_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-16  --/F eqw_percentiles_h_16
  eqw_percentiles_h_16_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-16  --/F eqw_percentiles_h_16
  eqw_percentiles_h_16_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-16  --/F eqw_percentiles_h_16
  abs_percentiles_h_16_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-16  --/F abs_percentiles_h_16
  abs_percentiles_h_16_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-16  --/F abs_percentiles_h_16
  abs_percentiles_h_16_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-16  --/F abs_percentiles_h_16
  eqw_h_17 float NOT NULL, --/U A --/D Equivalent width of H-17 
  abs_h_17 float NOT NULL, --/D 
  detection_stat_h_17 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_h_17 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_h_17_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of H-17  --/F eqw_percentiles_h_17
  eqw_percentiles_h_17_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of H-17  --/F eqw_percentiles_h_17
  eqw_percentiles_h_17_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of H-17  --/F eqw_percentiles_h_17
  abs_percentiles_h_17_16 float NOT NULL, --/U  --/D 16th ABS percentiles of H-17  --/F abs_percentiles_h_17
  abs_percentiles_h_17_50 float NOT NULL, --/U  --/D 50th ABS percentiles of H-17  --/F abs_percentiles_h_17
  abs_percentiles_h_17_84 float NOT NULL, --/U  --/D 84th ABS percentiles of H-17  --/F abs_percentiles_h_17
  eqw_pa_7 float NOT NULL, --/U A --/D Equivalent width of Pa-7 
  abs_pa_7 float NOT NULL, --/D 
  detection_stat_pa_7 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_pa_7 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_pa_7_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-7  --/F eqw_percentiles_pa_7
  eqw_percentiles_pa_7_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-7  --/F eqw_percentiles_pa_7
  eqw_percentiles_pa_7_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-7  --/F eqw_percentiles_pa_7
  abs_percentiles_pa_7_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-7  --/F abs_percentiles_pa_7
  abs_percentiles_pa_7_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-7  --/F abs_percentiles_pa_7
  abs_percentiles_pa_7_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-7  --/F abs_percentiles_pa_7
  eqw_pa_8 float NOT NULL, --/U A --/D Equivalent width of Pa-8 
  abs_pa_8 float NOT NULL, --/D 
  detection_stat_pa_8 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_pa_8 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_pa_8_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-8  --/F eqw_percentiles_pa_8
  eqw_percentiles_pa_8_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-8  --/F eqw_percentiles_pa_8
  eqw_percentiles_pa_8_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-8  --/F eqw_percentiles_pa_8
  abs_percentiles_pa_8_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-8  --/F abs_percentiles_pa_8
  abs_percentiles_pa_8_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-8  --/F abs_percentiles_pa_8
  abs_percentiles_pa_8_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-8  --/F abs_percentiles_pa_8
  eqw_pa_9 float NOT NULL, --/U A --/D Equivalent width of Pa-9 
  abs_pa_9 float NOT NULL, --/D 
  detection_stat_pa_9 float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_pa_9 float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_pa_9_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-9  --/F eqw_percentiles_pa_9
  eqw_percentiles_pa_9_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-9  --/F eqw_percentiles_pa_9
  eqw_percentiles_pa_9_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-9  --/F eqw_percentiles_pa_9
  abs_percentiles_pa_9_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-9  --/F abs_percentiles_pa_9
  abs_percentiles_pa_9_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-9  --/F abs_percentiles_pa_9
  abs_percentiles_pa_9_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-9  --/F abs_percentiles_pa_9
  eqw_pa_10 float NOT NULL, --/U A --/D Equivalent width of Pa-10 
  abs_pa_10 float NOT NULL, --/D 
  detection_stat_pa_10 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_10 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_10_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-10  --/F eqw_percentiles_pa_10
  eqw_percentiles_pa_10_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-10  --/F eqw_percentiles_pa_10
  eqw_percentiles_pa_10_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-10  --/F eqw_percentiles_pa_10
  abs_percentiles_pa_10_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-10  --/F abs_percentiles_pa_10
  abs_percentiles_pa_10_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-10  --/F abs_percentiles_pa_10
  abs_percentiles_pa_10_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-10  --/F abs_percentiles_pa_10
  eqw_pa_11 float NOT NULL, --/U A --/D Equivalent width of Pa-11 
  abs_pa_11 float NOT NULL, --/D 
  detection_stat_pa_11 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_11 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_11_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-11  --/F eqw_percentiles_pa_11
  eqw_percentiles_pa_11_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-11  --/F eqw_percentiles_pa_11
  eqw_percentiles_pa_11_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-11  --/F eqw_percentiles_pa_11
  abs_percentiles_pa_11_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-11  --/F abs_percentiles_pa_11
  abs_percentiles_pa_11_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-11  --/F abs_percentiles_pa_11
  abs_percentiles_pa_11_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-11  --/F abs_percentiles_pa_11
  eqw_pa_12 float NOT NULL, --/U A --/D Equivalent width of Pa-12 
  abs_pa_12 float NOT NULL, --/D 
  detection_stat_pa_12 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_12 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_12_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-12  --/F eqw_percentiles_pa_12
  eqw_percentiles_pa_12_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-12  --/F eqw_percentiles_pa_12
  eqw_percentiles_pa_12_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-12  --/F eqw_percentiles_pa_12
  abs_percentiles_pa_12_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-12  --/F abs_percentiles_pa_12
  abs_percentiles_pa_12_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-12  --/F abs_percentiles_pa_12
  abs_percentiles_pa_12_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-12  --/F abs_percentiles_pa_12
  eqw_pa_13 float NOT NULL, --/U A --/D Equivalent width of Pa-13 
  abs_pa_13 float NOT NULL, --/D 
  detection_stat_pa_13 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_13 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_13_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-13  --/F eqw_percentiles_pa_13
  eqw_percentiles_pa_13_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-13  --/F eqw_percentiles_pa_13
  eqw_percentiles_pa_13_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-13  --/F eqw_percentiles_pa_13
  abs_percentiles_pa_13_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-13  --/F abs_percentiles_pa_13
  abs_percentiles_pa_13_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-13  --/F abs_percentiles_pa_13
  abs_percentiles_pa_13_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-13  --/F abs_percentiles_pa_13
  eqw_pa_14 float NOT NULL, --/U A --/D Equivalent width of Pa-14 
  abs_pa_14 float NOT NULL, --/D 
  detection_stat_pa_14 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_14 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_14_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-14  --/F eqw_percentiles_pa_14
  eqw_percentiles_pa_14_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-14  --/F eqw_percentiles_pa_14
  eqw_percentiles_pa_14_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-14  --/F eqw_percentiles_pa_14
  abs_percentiles_pa_14_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-14  --/F abs_percentiles_pa_14
  abs_percentiles_pa_14_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-14  --/F abs_percentiles_pa_14
  abs_percentiles_pa_14_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-14  --/F abs_percentiles_pa_14
  eqw_pa_15 float NOT NULL, --/U A --/D Equivalent width of Pa-15 
  abs_pa_15 float NOT NULL, --/D 
  detection_stat_pa_15 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_15 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_15_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-15  --/F eqw_percentiles_pa_15
  eqw_percentiles_pa_15_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-15  --/F eqw_percentiles_pa_15
  eqw_percentiles_pa_15_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-15  --/F eqw_percentiles_pa_15
  abs_percentiles_pa_15_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-15  --/F abs_percentiles_pa_15
  abs_percentiles_pa_15_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-15  --/F abs_percentiles_pa_15
  abs_percentiles_pa_15_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-15  --/F abs_percentiles_pa_15
  eqw_pa_16 float NOT NULL, --/U A --/D Equivalent width of Pa-16 
  abs_pa_16 float NOT NULL, --/D 
  detection_stat_pa_16 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_16 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_16_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-16  --/F eqw_percentiles_pa_16
  eqw_percentiles_pa_16_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-16  --/F eqw_percentiles_pa_16
  eqw_percentiles_pa_16_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-16  --/F eqw_percentiles_pa_16
  abs_percentiles_pa_16_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-16  --/F abs_percentiles_pa_16
  abs_percentiles_pa_16_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-16  --/F abs_percentiles_pa_16
  abs_percentiles_pa_16_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-16  --/F abs_percentiles_pa_16
  eqw_pa_17 float NOT NULL, --/U A --/D Equivalent width of Pa-17 
  abs_pa_17 float NOT NULL, --/D 
  detection_stat_pa_17 float NOT NULL, --/D Detection probability (+1: absorption; 0: und
  detection_raw_pa_17 float NOT NULL, --/D Probability that feature is not noise (0: nois
  eqw_percentiles_pa_17_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Pa-17  --/F eqw_percentiles_pa_17
  eqw_percentiles_pa_17_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Pa-17  --/F eqw_percentiles_pa_17
  eqw_percentiles_pa_17_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Pa-17  --/F eqw_percentiles_pa_17
  abs_percentiles_pa_17_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Pa-17  --/F abs_percentiles_pa_17
  abs_percentiles_pa_17_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Pa-17  --/F abs_percentiles_pa_17
  abs_percentiles_pa_17_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Pa-17  --/F abs_percentiles_pa_17
  eqw_ca_ii_8662 float NOT NULL, --/U A --/D Equivalent width of Ca II at 8662 A 
  abs_ca_ii_8662 float NOT NULL, --/D 
  detection_stat_ca_ii_8662 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_ca_ii_8662 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_ii_8662_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca II at 8662 A  --/F eqw_percentiles_ca_ii_8662
  eqw_percentiles_ca_ii_8662_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca II at 8662 A  --/F eqw_percentiles_ca_ii_8662
  eqw_percentiles_ca_ii_8662_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca II at 8662 A  --/F eqw_percentiles_ca_ii_8662
  abs_percentiles_ca_ii_8662_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca II at 8662 A  --/F abs_percentiles_ca_ii_8662
  abs_percentiles_ca_ii_8662_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca II at 8662 A  --/F abs_percentiles_ca_ii_8662
  abs_percentiles_ca_ii_8662_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca II at 8662 A  --/F abs_percentiles_ca_ii_8662
  eqw_ca_ii_8542 float NOT NULL, --/U A --/D Equivalent width of Ca II at 8542 A 
  abs_ca_ii_8542 float NOT NULL, --/D 
  detection_stat_ca_ii_8542 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_ca_ii_8542 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_ii_8542_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca II at 8542 A  --/F eqw_percentiles_ca_ii_8542
  eqw_percentiles_ca_ii_8542_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca II at 8542 A  --/F eqw_percentiles_ca_ii_8542
  eqw_percentiles_ca_ii_8542_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca II at 8542 A  --/F eqw_percentiles_ca_ii_8542
  abs_percentiles_ca_ii_8542_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca II at 8542 A  --/F abs_percentiles_ca_ii_8542
  abs_percentiles_ca_ii_8542_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca II at 8542 A  --/F abs_percentiles_ca_ii_8542
  abs_percentiles_ca_ii_8542_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca II at 8542 A  --/F abs_percentiles_ca_ii_8542
  eqw_ca_ii_8498 float NOT NULL, --/U A --/D Equivalent width of Ca II at 8498 A 
  abs_ca_ii_8498 float NOT NULL, --/D 
  detection_stat_ca_ii_8498 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_ca_ii_8498 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_ii_8498_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca II at 8498 A  --/F eqw_percentiles_ca_ii_8498
  eqw_percentiles_ca_ii_8498_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca II at 8498 A  --/F eqw_percentiles_ca_ii_8498
  eqw_percentiles_ca_ii_8498_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca II at 8498 A  --/F eqw_percentiles_ca_ii_8498
  abs_percentiles_ca_ii_8498_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca II at 8498 A  --/F abs_percentiles_ca_ii_8498
  abs_percentiles_ca_ii_8498_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca II at 8498 A  --/F abs_percentiles_ca_ii_8498
  abs_percentiles_ca_ii_8498_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca II at 8498 A  --/F abs_percentiles_ca_ii_8498
  eqw_ca_k_3933 float NOT NULL, --/U A --/D Equivalent width of Ca K at 3933 A 
  abs_ca_k_3933 float NOT NULL, --/D 
  detection_stat_ca_k_3933 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_ca_k_3933 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_k_3933_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca K at 3933 A  --/F eqw_percentiles_ca_k_3933
  eqw_percentiles_ca_k_3933_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca K at 3933 A  --/F eqw_percentiles_ca_k_3933
  eqw_percentiles_ca_k_3933_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca K at 3933 A  --/F eqw_percentiles_ca_k_3933
  abs_percentiles_ca_k_3933_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca K at 3933 A  --/F abs_percentiles_ca_k_3933
  abs_percentiles_ca_k_3933_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca K at 3933 A  --/F abs_percentiles_ca_k_3933
  abs_percentiles_ca_k_3933_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca K at 3933 A  --/F abs_percentiles_ca_k_3933
  eqw_ca_h_3968 float NOT NULL, --/U A --/D Equivalent width of Ca H at 3968 A 
  abs_ca_h_3968 float NOT NULL, --/D 
  detection_stat_ca_h_3968 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_ca_h_3968 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_ca_h_3968_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Ca H at 3968 A  --/F eqw_percentiles_ca_h_3968
  eqw_percentiles_ca_h_3968_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Ca H at 3968 A  --/F eqw_percentiles_ca_h_3968
  eqw_percentiles_ca_h_3968_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Ca H at 3968 A  --/F eqw_percentiles_ca_h_3968
  abs_percentiles_ca_h_3968_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Ca H at 3968 A  --/F abs_percentiles_ca_h_3968
  abs_percentiles_ca_h_3968_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Ca H at 3968 A  --/F abs_percentiles_ca_h_3968
  abs_percentiles_ca_h_3968_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Ca H at 3968 A  --/F abs_percentiles_ca_h_3968
  eqw_he_i_6678 float NOT NULL, --/U A --/D Equivalent width of He I at 6678 A 
  abs_he_i_6678 float NOT NULL, --/D 
  detection_stat_he_i_6678 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_he_i_6678 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_i_6678_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He I at 6678 A  --/F eqw_percentiles_he_i_6678
  eqw_percentiles_he_i_6678_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He I at 6678 A  --/F eqw_percentiles_he_i_6678
  eqw_percentiles_he_i_6678_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He I at 6678 A  --/F eqw_percentiles_he_i_6678
  abs_percentiles_he_i_6678_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He I at 6678 A  --/F abs_percentiles_he_i_6678
  abs_percentiles_he_i_6678_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He I at 6678 A  --/F abs_percentiles_he_i_6678
  abs_percentiles_he_i_6678_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He I at 6678 A  --/F abs_percentiles_he_i_6678
  eqw_he_i_5875 float NOT NULL, --/U A --/D Equivalent width of He I at 5875 A 
  abs_he_i_5875 float NOT NULL, --/D 
  detection_stat_he_i_5875 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_he_i_5875 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_i_5875_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He I at 5875 A  --/F eqw_percentiles_he_i_5875
  eqw_percentiles_he_i_5875_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He I at 5875 A  --/F eqw_percentiles_he_i_5875
  eqw_percentiles_he_i_5875_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He I at 5875 A  --/F eqw_percentiles_he_i_5875
  abs_percentiles_he_i_5875_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He I at 5875 A  --/F abs_percentiles_he_i_5875
  abs_percentiles_he_i_5875_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He I at 5875 A  --/F abs_percentiles_he_i_5875
  abs_percentiles_he_i_5875_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He I at 5875 A  --/F abs_percentiles_he_i_5875
  eqw_he_i_5015 float NOT NULL, --/U A --/D Equivalent width of He I at 5015 A 
  abs_he_i_5015 float NOT NULL, --/D 
  detection_stat_he_i_5015 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_he_i_5015 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_i_5015_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He I at 5015 A  --/F eqw_percentiles_he_i_5015
  eqw_percentiles_he_i_5015_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He I at 5015 A  --/F eqw_percentiles_he_i_5015
  eqw_percentiles_he_i_5015_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He I at 5015 A  --/F eqw_percentiles_he_i_5015
  abs_percentiles_he_i_5015_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He I at 5015 A  --/F abs_percentiles_he_i_5015
  abs_percentiles_he_i_5015_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He I at 5015 A  --/F abs_percentiles_he_i_5015
  abs_percentiles_he_i_5015_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He I at 5015 A  --/F abs_percentiles_he_i_5015
  eqw_he_i_4471 float NOT NULL, --/U A --/D Equivalent width of He I at 4471 A 
  abs_he_i_4471 float NOT NULL, --/D 
  detection_stat_he_i_4471 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_he_i_4471 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_i_4471_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He I at 4471 A  --/F eqw_percentiles_he_i_4471
  eqw_percentiles_he_i_4471_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He I at 4471 A  --/F eqw_percentiles_he_i_4471
  eqw_percentiles_he_i_4471_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He I at 4471 A  --/F eqw_percentiles_he_i_4471
  abs_percentiles_he_i_4471_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He I at 4471 A  --/F abs_percentiles_he_i_4471
  abs_percentiles_he_i_4471_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He I at 4471 A  --/F abs_percentiles_he_i_4471
  abs_percentiles_he_i_4471_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He I at 4471 A  --/F abs_percentiles_he_i_4471
  eqw_he_ii_4685 float NOT NULL, --/U A --/D Equivalent width of He II at 4685 A 
  abs_he_ii_4685 float NOT NULL, --/D 
  detection_stat_he_ii_4685 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_he_ii_4685 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_he_ii_4685_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of He II at 4685 A  --/F eqw_percentiles_he_ii_4685
  eqw_percentiles_he_ii_4685_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of He II at 4685 A  --/F eqw_percentiles_he_ii_4685
  eqw_percentiles_he_ii_4685_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of He II at 4685 A  --/F eqw_percentiles_he_ii_4685
  abs_percentiles_he_ii_4685_16 float NOT NULL, --/U  --/D 16th ABS percentiles of He II at 4685 A  --/F abs_percentiles_he_ii_4685
  abs_percentiles_he_ii_4685_50 float NOT NULL, --/U  --/D 50th ABS percentiles of He II at 4685 A  --/F abs_percentiles_he_ii_4685
  abs_percentiles_he_ii_4685_84 float NOT NULL, --/U  --/D 84th ABS percentiles of He II at 4685 A  --/F abs_percentiles_he_ii_4685
  eqw_n_ii_6583 float NOT NULL, --/U A --/D Equivalent width of N II at 6583 A 
  abs_n_ii_6583 float NOT NULL, --/D 
  detection_stat_n_ii_6583 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_n_ii_6583 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_n_ii_6583_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of N II at 6583 A  --/F eqw_percentiles_n_ii_6583
  eqw_percentiles_n_ii_6583_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of N II at 6583 A  --/F eqw_percentiles_n_ii_6583
  eqw_percentiles_n_ii_6583_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of N II at 6583 A  --/F eqw_percentiles_n_ii_6583
  abs_percentiles_n_ii_6583_16 float NOT NULL, --/U  --/D 16th ABS percentiles of N II at 6583 A  --/F abs_percentiles_n_ii_6583
  abs_percentiles_n_ii_6583_50 float NOT NULL, --/U  --/D 50th ABS percentiles of N II at 6583 A  --/F abs_percentiles_n_ii_6583
  abs_percentiles_n_ii_6583_84 float NOT NULL, --/U  --/D 84th ABS percentiles of N II at 6583 A  --/F abs_percentiles_n_ii_6583
  eqw_n_ii_6548 float NOT NULL, --/U A --/D Equivalent width of N II at 6548 A 
  abs_n_ii_6548 float NOT NULL, --/D 
  detection_stat_n_ii_6548 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_n_ii_6548 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_n_ii_6548_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of N II at 6548 A  --/F eqw_percentiles_n_ii_6548
  eqw_percentiles_n_ii_6548_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of N II at 6548 A  --/F eqw_percentiles_n_ii_6548
  eqw_percentiles_n_ii_6548_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of N II at 6548 A  --/F eqw_percentiles_n_ii_6548
  abs_percentiles_n_ii_6548_16 float NOT NULL, --/U  --/D 16th ABS percentiles of N II at 6548 A  --/F abs_percentiles_n_ii_6548
  abs_percentiles_n_ii_6548_50 float NOT NULL, --/U  --/D 50th ABS percentiles of N II at 6548 A  --/F abs_percentiles_n_ii_6548
  abs_percentiles_n_ii_6548_84 float NOT NULL, --/U  --/D 84th ABS percentiles of N II at 6548 A  --/F abs_percentiles_n_ii_6548
  eqw_s_ii_6716 float NOT NULL, --/U A --/D Equivalent width of S II at 6716 A 
  abs_s_ii_6716 float NOT NULL, --/D 
  detection_stat_s_ii_6716 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_s_ii_6716 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_s_ii_6716_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of S II at 6716 A  --/F eqw_percentiles_s_ii_6716
  eqw_percentiles_s_ii_6716_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of S II at 6716 A  --/F eqw_percentiles_s_ii_6716
  eqw_percentiles_s_ii_6716_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of S II at 6716 A  --/F eqw_percentiles_s_ii_6716
  abs_percentiles_s_ii_6716_16 float NOT NULL, --/U  --/D 16th ABS percentiles of S II at 6716 A  --/F abs_percentiles_s_ii_6716
  abs_percentiles_s_ii_6716_50 float NOT NULL, --/U  --/D 50th ABS percentiles of S II at 6716 A  --/F abs_percentiles_s_ii_6716
  abs_percentiles_s_ii_6716_84 float NOT NULL, --/U  --/D 84th ABS percentiles of S II at 6716 A  --/F abs_percentiles_s_ii_6716
  eqw_s_ii_6730 float NOT NULL, --/U A --/D Equivalent width of S II at 6730 A 
  abs_s_ii_6730 float NOT NULL, --/D 
  detection_stat_s_ii_6730 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_s_ii_6730 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_s_ii_6730_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of S II at 6730 A  --/F eqw_percentiles_s_ii_6730
  eqw_percentiles_s_ii_6730_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of S II at 6730 A  --/F eqw_percentiles_s_ii_6730
  eqw_percentiles_s_ii_6730_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of S II at 6730 A  --/F eqw_percentiles_s_ii_6730
  abs_percentiles_s_ii_6730_16 float NOT NULL, --/U  --/D 16th ABS percentiles of S II at 6730 A  --/F abs_percentiles_s_ii_6730
  abs_percentiles_s_ii_6730_50 float NOT NULL, --/U  --/D 50th ABS percentiles of S II at 6730 A  --/F abs_percentiles_s_ii_6730
  abs_percentiles_s_ii_6730_84 float NOT NULL, --/U  --/D 84th ABS percentiles of S II at 6730 A  --/F abs_percentiles_s_ii_6730
  eqw_fe_ii_5018 float NOT NULL, --/U A --/D Equivalent width of Fe II at 5018 A 
  abs_fe_ii_5018 float NOT NULL, --/D 
  detection_stat_fe_ii_5018 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_fe_ii_5018 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_fe_ii_5018_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Fe II at 5018 A  --/F eqw_percentiles_fe_ii_5018
  eqw_percentiles_fe_ii_5018_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Fe II at 5018 A  --/F eqw_percentiles_fe_ii_5018
  eqw_percentiles_fe_ii_5018_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Fe II at 5018 A  --/F eqw_percentiles_fe_ii_5018
  abs_percentiles_fe_ii_5018_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Fe II at 5018 A  --/F abs_percentiles_fe_ii_5018
  abs_percentiles_fe_ii_5018_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Fe II at 5018 A  --/F abs_percentiles_fe_ii_5018
  abs_percentiles_fe_ii_5018_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Fe II at 5018 A  --/F abs_percentiles_fe_ii_5018
  eqw_fe_ii_5169 float NOT NULL, --/U A --/D Equivalent width of Fe II at 5169 A 
  abs_fe_ii_5169 float NOT NULL, --/D 
  detection_stat_fe_ii_5169 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_fe_ii_5169 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_fe_ii_5169_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Fe II at 5169 A  --/F eqw_percentiles_fe_ii_5169
  eqw_percentiles_fe_ii_5169_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Fe II at 5169 A  --/F eqw_percentiles_fe_ii_5169
  eqw_percentiles_fe_ii_5169_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Fe II at 5169 A  --/F eqw_percentiles_fe_ii_5169
  abs_percentiles_fe_ii_5169_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Fe II at 5169 A  --/F abs_percentiles_fe_ii_5169
  abs_percentiles_fe_ii_5169_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Fe II at 5169 A  --/F abs_percentiles_fe_ii_5169
  abs_percentiles_fe_ii_5169_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Fe II at 5169 A  --/F abs_percentiles_fe_ii_5169
  eqw_fe_ii_5197 float NOT NULL, --/U A --/D Equivalent width of Fe II at 5197 A 
  abs_fe_ii_5197 float NOT NULL, --/D 
  detection_stat_fe_ii_5197 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_fe_ii_5197 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_fe_ii_5197_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Fe II at 5197 A  --/F eqw_percentiles_fe_ii_5197
  eqw_percentiles_fe_ii_5197_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Fe II at 5197 A  --/F eqw_percentiles_fe_ii_5197
  eqw_percentiles_fe_ii_5197_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Fe II at 5197 A  --/F eqw_percentiles_fe_ii_5197
  abs_percentiles_fe_ii_5197_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Fe II at 5197 A  --/F abs_percentiles_fe_ii_5197
  abs_percentiles_fe_ii_5197_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Fe II at 5197 A  --/F abs_percentiles_fe_ii_5197
  abs_percentiles_fe_ii_5197_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Fe II at 5197 A  --/F abs_percentiles_fe_ii_5197
  eqw_fe_ii_6432 float NOT NULL, --/U A --/D Equivalent width of Fe II at 6432 A 
  abs_fe_ii_6432 float NOT NULL, --/D 
  detection_stat_fe_ii_6432 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_fe_ii_6432 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_fe_ii_6432_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Fe II at 6432 A  --/F eqw_percentiles_fe_ii_6432
  eqw_percentiles_fe_ii_6432_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Fe II at 6432 A  --/F eqw_percentiles_fe_ii_6432
  eqw_percentiles_fe_ii_6432_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Fe II at 6432 A  --/F eqw_percentiles_fe_ii_6432
  abs_percentiles_fe_ii_6432_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Fe II at 6432 A  --/F abs_percentiles_fe_ii_6432
  abs_percentiles_fe_ii_6432_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Fe II at 6432 A  --/F abs_percentiles_fe_ii_6432
  abs_percentiles_fe_ii_6432_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Fe II at 6432 A  --/F abs_percentiles_fe_ii_6432
  eqw_o_i_5577 float NOT NULL, --/U A --/D Equivalent width of O I at 5577 A
  abs_o_i_5577 float NOT NULL, --/D 
  detection_stat_o_i_5577 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_o_i_5577 float NOT NULL, --/D Probability that feature is not noise (0: n
  eqw_percentiles_o_i_5577_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O I at 5577 A --/F eqw_percentiles_o_i_5577
  eqw_percentiles_o_i_5577_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O I at 5577 A --/F eqw_percentiles_o_i_5577
  eqw_percentiles_o_i_5577_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O I at 5577 A --/F eqw_percentiles_o_i_5577
  abs_percentiles_o_i_5577_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O I at 5577 A --/F abs_percentiles_o_i_5577
  abs_percentiles_o_i_5577_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O I at 5577 A --/F abs_percentiles_o_i_5577
  abs_percentiles_o_i_5577_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O I at 5577 A --/F abs_percentiles_o_i_5577
  eqw_o_i_6300 float NOT NULL, --/U A --/D Equivalent width of O I at 6300 A 
  abs_o_i_6300 float NOT NULL, --/D 
  detection_stat_o_i_6300 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_o_i_6300 float NOT NULL, --/D Probability that feature is not noise (0: n
  eqw_percentiles_o_i_6300_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O I at 6300 A  --/F eqw_percentiles_o_i_6300
  eqw_percentiles_o_i_6300_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O I at 6300 A  --/F eqw_percentiles_o_i_6300
  eqw_percentiles_o_i_6300_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O I at 6300 A  --/F eqw_percentiles_o_i_6300
  abs_percentiles_o_i_6300_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O I at 6300 A  --/F abs_percentiles_o_i_6300
  abs_percentiles_o_i_6300_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O I at 6300 A  --/F abs_percentiles_o_i_6300
  abs_percentiles_o_i_6300_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O I at 6300 A  --/F abs_percentiles_o_i_6300
  eqw_o_i_6363 float NOT NULL, --/U A --/D Equivalent width of O I at 6363 A
  abs_o_i_6363 float NOT NULL, --/D 
  detection_stat_o_i_6363 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_o_i_6363 float NOT NULL, --/D Probability that feature is not noise (0: n
  eqw_percentiles_o_i_6363_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O I at 6363 A --/F eqw_percentiles_o_i_6363
  eqw_percentiles_o_i_6363_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O I at 6363 A --/F eqw_percentiles_o_i_6363
  eqw_percentiles_o_i_6363_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O I at 6363 A --/F eqw_percentiles_o_i_6363
  abs_percentiles_o_i_6363_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O I at 6363 A --/F abs_percentiles_o_i_6363
  abs_percentiles_o_i_6363_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O I at 6363 A --/F abs_percentiles_o_i_6363
  abs_percentiles_o_i_6363_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O I at 6363 A --/F abs_percentiles_o_i_6363
  eqw_o_ii_3727 float NOT NULL, --/U A --/D Equivalent width of O II at 3727 A 
  abs_o_ii_3727 float NOT NULL, --/D 
  detection_stat_o_ii_3727 float NOT NULL, --/D Detection probability (+1: absorption; 0:
  detection_raw_o_ii_3727 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_o_ii_3727_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O II at 3727 A  --/F eqw_percentiles_o_ii_3727
  eqw_percentiles_o_ii_3727_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O II at 3727 A  --/F eqw_percentiles_o_ii_3727
  eqw_percentiles_o_ii_3727_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O II at 3727 A  --/F eqw_percentiles_o_ii_3727
  abs_percentiles_o_ii_3727_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O II at 3727 A  --/F abs_percentiles_o_ii_3727
  abs_percentiles_o_ii_3727_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O II at 3727 A  --/F abs_percentiles_o_ii_3727
  abs_percentiles_o_ii_3727_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O II at 3727 A  --/F abs_percentiles_o_ii_3727
  eqw_o_iii_4959 float NOT NULL, --/U A --/D Equivalent width of O III at 4959 A 
  abs_o_iii_4959 float NOT NULL, --/D 
  detection_stat_o_iii_4959 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_o_iii_4959 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_o_iii_4959_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O III at 4959 A  --/F eqw_percentiles_o_iii_4959
  eqw_percentiles_o_iii_4959_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O III at 4959 A  --/F eqw_percentiles_o_iii_4959
  eqw_percentiles_o_iii_4959_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O III at 4959 A  --/F eqw_percentiles_o_iii_4959
  abs_percentiles_o_iii_4959_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O III at 4959 A  --/F abs_percentiles_o_iii_4959
  abs_percentiles_o_iii_4959_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O III at 4959 A  --/F abs_percentiles_o_iii_4959
  abs_percentiles_o_iii_4959_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O III at 4959 A  --/F abs_percentiles_o_iii_4959
  eqw_o_iii_5006 float NOT NULL, --/U A --/D Equivalent width of O III at 5006 A 
  abs_o_iii_5006 float NOT NULL, --/D 
  detection_stat_o_iii_5006 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_o_iii_5006 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_o_iii_5006_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O III at 5006 A  --/F eqw_percentiles_o_iii_5006
  eqw_percentiles_o_iii_5006_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O III at 5006 A  --/F eqw_percentiles_o_iii_5006
  eqw_percentiles_o_iii_5006_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O III at 5006 A  --/F eqw_percentiles_o_iii_5006
  abs_percentiles_o_iii_5006_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O III at 5006 A  --/F abs_percentiles_o_iii_5006
  abs_percentiles_o_iii_5006_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O III at 5006 A  --/F abs_percentiles_o_iii_5006
  abs_percentiles_o_iii_5006_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O III at 5006 A  --/F abs_percentiles_o_iii_5006
  eqw_o_iii_4363 float NOT NULL, --/U A --/D Equivalent width of O III at 4363 A 
  abs_o_iii_4363 float NOT NULL, --/D 
  detection_stat_o_iii_4363 float NOT NULL, --/D Detection probability (+1: absorption; 0
  detection_raw_o_iii_4363 float NOT NULL, --/D Probability that feature is not noise (0:
  eqw_percentiles_o_iii_4363_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of O III at 4363 A  --/F eqw_percentiles_o_iii_4363
  eqw_percentiles_o_iii_4363_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of O III at 4363 A  --/F eqw_percentiles_o_iii_4363
  eqw_percentiles_o_iii_4363_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of O III at 4363 A  --/F eqw_percentiles_o_iii_4363
  abs_percentiles_o_iii_4363_16 float NOT NULL, --/U  --/D 16th ABS percentiles of O III at 4363 A  --/F abs_percentiles_o_iii_4363
  abs_percentiles_o_iii_4363_50 float NOT NULL, --/U  --/D 50th ABS percentiles of O III at 4363 A  --/F abs_percentiles_o_iii_4363
  abs_percentiles_o_iii_4363_84 float NOT NULL, --/U  --/D 84th ABS percentiles of O III at 4363 A  --/F abs_percentiles_o_iii_4363
  eqw_li_i float NOT NULL, --/U A --/D Equivalent width of Li I at 6707 A 
  abs_li_i float NOT NULL, --/D 
  detection_stat_li_i float NOT NULL, --/D Detection probability (+1: absorption; 0: unde
  detection_raw_li_i float NOT NULL, --/D Probability that feature is not noise (0: noise
  eqw_percentiles_li_i_16 float NOT NULL, --/U mA --/D 16th percentiles of Equivalent Width of Li I at 6707 A  --/F eqw_percentiles_li_i
  eqw_percentiles_li_i_50 float NOT NULL, --/U mA --/D 50th percentiles of Equivalent Width of Li I at 6707 A  --/F eqw_percentiles_li_i
  eqw_percentiles_li_i_84 float NOT NULL, --/U mA --/D 84th percentiles of Equivalent Width of Li I at 6707 A  --/F eqw_percentiles_li_i
  abs_percentiles_li_i_16 float NOT NULL, --/U  --/D 16th ABS percentiles of Li I at 6707 A  --/F abs_percentiles_li_i
  abs_percentiles_li_i_50 float NOT NULL, --/U  --/D 50th ABS percentiles of Li I at 6707 A  --/F abs_percentiles_li_i
  abs_percentiles_li_i_84 float NOT NULL, --/U  --/D 84th ABS percentiles of Li I at 6707 A  --/F abs_percentiles_li_i
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'lite_all_star')
	DROP TABLE lite_all_star
GO
--
EXEC spSetDefaultFileGroup 'lite_all_star'
GO
CREATE TABLE lite_all_star (
--------------------------------------------------------------------------------
--/H Parameters and elemental abundances for each star obtained by combining results from various pipelines.
--
--/T Parameters and elemental abundances for each star obtained by combining results from various pipelines.
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(19) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  id bigint NOT NULL, --/D 
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  modified varchar(26) NOT NULL, --/D 
  pipeline varchar(13) NOT NULL, --/D 
  task_pk bigint NOT NULL, --/D Task model primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(7) NOT NULL, --/D SDSS file type that stores this spectrum
  telescope varchar(6) NOT NULL, --/D Short telescope name
  apred varchar(4) NOT NULL, --/D APOGEE reduction pipeline
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  obj varchar(19) NOT NULL, --/D Object name
  field varchar(19) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  snr float NOT NULL, --/D Signal-to-noise ratio
  mean_fiber float NOT NULL, --/D S/N-weighted mean visit fiber number
  std_fiber float NOT NULL, --/D Standard deviation of visit fiber numbers
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_visits int NOT NULL, --/D Number of visits
  n_good_visits int NOT NULL, --/D Number of 'good' visits
  n_good_rvs int NOT NULL, --/D Number of 'good' radial velocities
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_meanrxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  boss_net_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  boss_net_e_v_rad float NOT NULL, --/U km/s --/D Relative velocity 
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  v_micro float NOT NULL, --/U km/s --/D Microturbulence 
  e_v_micro float NOT NULL, --/U km/s --/D Error on microturbulence 
  v_sini float NOT NULL, --/U km/s --/D Projected rotational velocity 
  e_v_sini float NOT NULL, --/U km/s --/D Error on projected rotational velocity 
  m_h_atm float NOT NULL, --/U dex --/D Metallicity 
  e_m_h_atm float NOT NULL, --/U dex --/D Error on metallicity 
  alpha_m_atm float NOT NULL, --/U dex --/D [alpha/M] abundance ratio 
  e_alpha_m_atm float NOT NULL, --/U dex --/D Error on [alpha/M] abundance ratio 
  c_m_atm float NOT NULL, --/U dex --/D Atmospheric carbon abundance 
  e_c_m_atm float NOT NULL, --/U dex --/D Error on atmospheric carbon abundance 
  n_m_atm float NOT NULL, --/U dex --/D Atmospheric nitrogen abundance 
  e_n_m_atm float NOT NULL, --/U dex --/D Error on atmospheric nitrogen abundance 
  al_h float NOT NULL, --/U dex --/D [Al/H] 
  e_al_h float NOT NULL, --/U dex --/D Error on [Al/H] 
  al_h_flags bigint NOT NULL, --/U dex --/D Flags for [Al/H] 
  al_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Al/H] 
  c_12_13 float NOT NULL, --/D C12/C13 ratio
  e_c_12_13 float NOT NULL, --/D Error on c12/C13 ratio
  c_12_13_flags bigint NOT NULL, --/D Flags for c12/C13 ratio
  c_12_13_rchi2 float NOT NULL, --/D Reduced chi-square value for c12/C13 ratio
  ca_h float NOT NULL, --/U dex --/D [Ca/H] 
  e_ca_h float NOT NULL, --/U dex --/D Error on [Ca/H] 
  ca_h_flags bigint NOT NULL, --/U dex --/D Flags for [Ca/H] 
  ca_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ca/H] 
  ce_h float NOT NULL, --/U dex --/D [Ce/H] 
  e_ce_h float NOT NULL, --/U dex --/D Error on [Ce/H] 
  ce_h_flags bigint NOT NULL, --/U dex --/D Flags for [Ce/H] 
  ce_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ce/H] 
  c_1_h float NOT NULL, --/U dex --/D [C/H] from neutral C lines 
  e_c_1_h float NOT NULL, --/U dex --/D Error on [C/H] from neutral C lines 
  c_1_h_flags bigint NOT NULL, --/U dex --/D Flags for [C/H] from neutral C lines 
  c_1_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [C/H] from neutral
  c_h float NOT NULL, --/U dex --/D [C/H] 
  e_c_h float NOT NULL, --/U dex --/D Error on [C/H] 
  c_h_flags bigint NOT NULL, --/U dex --/D Flags for [C/H] 
  c_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [C/H] 
  co_h float NOT NULL, --/U dex --/D [Co/H] 
  e_co_h float NOT NULL, --/U dex --/D Error on [Co/H] 
  co_h_flags bigint NOT NULL, --/U dex --/D Flags for [Co/H] 
  co_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Co/H] 
  cr_h float NOT NULL, --/U dex --/D [Cr/H] 
  e_cr_h float NOT NULL, --/U dex --/D Error on [Cr/H] 
  cr_h_flags bigint NOT NULL, --/U dex --/D Flags for [Cr/H] 
  cr_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Cr/H] 
  cu_h float NOT NULL, --/U dex --/D [Cu/H] 
  e_cu_h float NOT NULL, --/U dex --/D Error on [Cu/H] 
  cu_h_flags bigint NOT NULL, --/U dex --/D Flags for [Cu/H] 
  cu_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Cu/H] 
  fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  fe_h_flags bigint NOT NULL, --/U dex --/D Flags for [Fe/H] 
  fe_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Fe/H] 
  k_h float NOT NULL, --/U dex --/D [K/H] 
  e_k_h float NOT NULL, --/U dex --/D Error on [K/H] 
  k_h_flags bigint NOT NULL, --/U dex --/D Flags for [K/H] 
  k_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [K/H] 
  mg_h float NOT NULL, --/U dex --/D [Mg/H] 
  e_mg_h float NOT NULL, --/U dex --/D Error on [Mg/H] 
  mg_h_flags bigint NOT NULL, --/U dex --/D Flags for [Mg/H] 
  mg_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Mg/H] 
  mn_h float NOT NULL, --/U dex --/D [Mn/H] 
  e_mn_h float NOT NULL, --/U dex --/D Error on [Mn/H] 
  mn_h_flags bigint NOT NULL, --/U dex --/D Flags for [Mn/H] 
  mn_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Mn/H] 
  na_h float NOT NULL, --/U dex --/D [Na/H] 
  e_na_h float NOT NULL, --/U dex --/D Error on [Na/H] 
  na_h_flags bigint NOT NULL, --/U dex --/D Flags for [Na/H] 
  na_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Na/H] 
  nd_h float NOT NULL, --/U dex --/D [Nd/H] 
  e_nd_h float NOT NULL, --/U dex --/D Error on [Nd/H] 
  nd_h_flags bigint NOT NULL, --/U dex --/D Flags for [Nd/H] 
  nd_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Nd/H] 
  ni_h float NOT NULL, --/U dex --/D [Ni/H] 
  e_ni_h float NOT NULL, --/U dex --/D Error on [Ni/H] 
  ni_h_flags bigint NOT NULL, --/U dex --/D Flags for [Ni/H] 
  ni_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ni/H] 
  n_h float NOT NULL, --/U dex --/D [N/H] 
  e_n_h float NOT NULL, --/U dex --/D Error on [N/H] 
  n_h_flags bigint NOT NULL, --/U dex --/D Flags for [N/H] 
  n_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [N/H] 
  o_h float NOT NULL, --/U dex --/D [O/H] 
  e_o_h float NOT NULL, --/U dex --/D Error on [O/H] 
  o_h_flags bigint NOT NULL, --/U dex --/D Flags for [O/H] 
  o_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [O/H] 
  p_h float NOT NULL, --/U dex --/D [P/H] 
  e_p_h float NOT NULL, --/U dex --/D Error on [P/H] 
  p_h_flags bigint NOT NULL, --/U dex --/D Flags for [P/H] 
  p_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [P/H] 
  si_h float NOT NULL, --/U dex --/D [Si/H] 
  e_si_h float NOT NULL, --/U dex --/D Error on [Si/H] 
  si_h_flags bigint NOT NULL, --/U dex --/D Flags for [Si/H] 
  si_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Si/H] 
  s_h float NOT NULL, --/U dex --/D [S/H] 
  e_s_h float NOT NULL, --/U dex --/D Error on [S/H] 
  s_h_flags bigint NOT NULL, --/U dex --/D Flags for [S/H] 
  s_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [S/H] 
  ti_h float NOT NULL, --/U dex --/D [Ti/H] 
  e_ti_h float NOT NULL, --/U dex --/D Error on [Ti/H] 
  ti_h_flags bigint NOT NULL, --/U dex --/D Flags for [Ti/H] 
  ti_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ti/H] 
  ti_2_h float NOT NULL, --/U dex --/D [Ti/H] from singly ionized Ti lines 
  e_ti_2_h float NOT NULL, --/U d --/D Error on [Ti/H] from singly ionized Ti lines
  ti_2_h_flags bigint NOT NULL, --/U  --/D Flags for [Ti/H] from singly ionized Ti lines
  ti_2_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [Ti/H] from singly
  v_h float NOT NULL, --/U dex --/D [V/H] 
  e_v_h float NOT NULL, --/U dex --/D Error on [V/H] 
  v_h_flags bigint NOT NULL, --/U dex --/D Flags for [V/H] 
  v_h_rchi2 float NOT NULL, --/U dex --/D Reduced chi-square value for [V/H] 
  classification varchar(15) NOT NULL, --/D Classification
  p_cv float NOT NULL, --/D Cataclysmic variable probability
  p_da float NOT NULL, --/D DA-type white dwarf probability
  p_dab float NOT NULL, --/D DAB-type white dwarf probability
  p_dabz float NOT NULL, --/D DABZ-type white dwarf probability
  p_dah float NOT NULL, --/D DA (H)-type white dwarf probability
  p_dahe float NOT NULL, --/D DA (He)-type white dwarf probability
  p_dao float NOT NULL, --/D DAO-type white dwarf probability
  p_daz float NOT NULL, --/D DAZ-type white dwarf probability
  p_da_ms float NOT NULL, --/D DA-MS binary probability
  p_db float NOT NULL, --/D DB-type white dwarf probability
  p_dba float NOT NULL, --/D DBA-type white dwarf probability
  p_dbaz float NOT NULL, --/D DBAZ-type white dwarf probability
  p_dbh float NOT NULL, --/D DB (H)-type white dwarf probability
  p_dbz float NOT NULL, --/D DBZ-type white dwarf probability
  p_db_ms float NOT NULL, --/D DB-MS binary probability
  p_dc float NOT NULL, --/D DC-type white dwarf probability
  p_dc_ms float NOT NULL, --/D DC-MS binary probability
  p_do float NOT NULL, --/D DO-type white dwarf probability
  p_dq float NOT NULL, --/D DQ-type white dwarf probability
  p_dqz float NOT NULL, --/D DQZ-type white dwarf probability
  p_dqpec float NOT NULL, --/D DQ Peculiar-type white dwarf probability
  p_dz float NOT NULL, --/D DZ-type white dwarf probability
  p_dza float NOT NULL, --/D DZA-type white dwarf probability
  p_dzb float NOT NULL, --/D DZB-type white dwarf probability
  p_dzba float NOT NULL, --/D DZBA-type white dwarf probability
  p_mwd float NOT NULL, --/D Main sequence star probability
  p_hotdq float NOT NULL, --/D Hot DQ-type white dwarf probability
  spectral_type varchar(1) NOT NULL, --/D Spectral type
  sub_type float NOT NULL, --/D Spectral sub-type
  rchi2 float NOT NULL, --/D Reduced chi-square value
  pipeline_flags bigint NOT NULL, --/D Amalgamated pipeline flags
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'm_dwarf_type_boss_star')
	DROP TABLE m_dwarf_type_boss_star
GO
--
EXEC spSetDefaultFileGroup 'm_dwarf_type_boss_star'
GO
CREATE TABLE m_dwarf_type_boss_star (
--------------------------------------------------------------------------------
--/H Results from the MDwarfType astra pipeline for each star
--
--/T Results from the MDwarfType astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(7) NOT NULL, --/D SDSS file type that stores this spectrum
  v_astra varchar(5) NOT NULL, --/D Astra version
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  telescope varchar(6) NOT NULL, --/D Short telescope name
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_visits int NOT NULL, --/D Number of BOSS visits
  n_good_visits int NOT NULL, --/D Number of 'good' BOSS visits
  n_good_rvs int NOT NULL, --/D Number of 'good' BOSS radial velocities
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_meanrxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  nmf_rchi2 float NOT NULL, --/D Reduced chi-square value of NMF continuum fit
  nmf_flags bigint NOT NULL, --/D NMF Continuum method flags
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D Unique source primary key
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  spectral_type varchar(4) NOT NULL, --/D Spectral type
  sub_type float NOT NULL, --/D Spectral sub-type
  rchi2 float NOT NULL, --/D Reduced chi-square value
  continuum float NOT NULL, --/D Scalar continuum value used
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_bad bit NOT NULL, --/D Bad flag for results
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'm_dwarf_type_boss_visit')
	DROP TABLE m_dwarf_type_boss_visit
GO
--
EXEC spSetDefaultFileGroup 'm_dwarf_type_boss_visit'
GO
CREATE TABLE m_dwarf_type_boss_visit (
--------------------------------------------------------------------------------
--/H Results from the MDwarfType astra pipeline for each visit
--
--/T Results from the MDwarfType astra pipeline for each visit
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(8) NOT NULL, --/D SDSS file type that stores this spectrum
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  mjd int NOT NULL, --/D Modified Julian date of observation
  fieldid int NOT NULL, --/D Field identifier
  n_exp int NOT NULL, --/D Number of co-added exposures
  exptime float NOT NULL, --/U s --/D Exposure time 
  plateid int NOT NULL, --/D Plate identifier
  cartid int NOT NULL, --/D Cartridge identifier
  mapid int NOT NULL, --/D Mapping version of the loaded plate
  slitid int NOT NULL, --/D Slit identifier
  psfsky int NOT NULL, --/D Order of PSF sky subtraction
  preject float NOT NULL, --/D Profile area rejection threshold
  n_std int NOT NULL, --/D Number of (good) standard stars
  n_gal int NOT NULL, --/D Number of (good) galaxies in field
  lowrej int NOT NULL, --/D Extraction: low rejection
  highrej int NOT NULL, --/D Extraction: high rejection
  scatpoly int NOT NULL, --/D Extraction: Order of scattered light polynomial
  proftype int NOT NULL, --/D Extraction profile: 1=Gaussian
  nfitpoly int NOT NULL, --/D Extraction: Number of profile parameters
  skychi2 float NOT NULL, --/D Mean \chi^2 of sky subtraction
  schi2min float NOT NULL, --/D Minimum \chi^2 of sky subtraction
  schi2max float NOT NULL, --/D Maximum \chi^2 of sky subtraction
  alt float NOT NULL, --/U deg --/D Telescope altitude 
  az float NOT NULL, --/U deg --/D Telescope azimuth 
  telescope varchar(6) NOT NULL, --/D Short telescope name
  seeing float NOT NULL, --/U arcsecond --/D Median seeing conditions 
  airmass float NOT NULL, --/D Mean airmass
  airtemp float NOT NULL, --/U C --/D Air temperature 
  dewpoint float NOT NULL, --/U C --/D Dew point temperature 
  humidity float NOT NULL, --/U % --/D Humidity 
  pressure float NOT NULL, --/U millibar --/D Air pressure 
  dust_a float NOT NULL, --/U particles m^-3 s^-1 --/D 0.3mu-sized dust count 
  dust_b float NOT NULL, --/U particles m^-3 s^-1 --/D 1.0mu-sized dust count 
  gust_direction float NOT NULL, --/U deg --/D Wind gust direction 
  gust_speed float NOT NULL, --/U km/s --/D Wind gust speed 
  wind_direction float NOT NULL, --/U deg --/D Wind direction 
  wind_speed float NOT NULL, --/U km/s --/D Wind speed 
  moon_dist_mean float NOT NULL, --/U deg --/D Mean sky distance to the moon 
  moon_phase_mean float NOT NULL, --/D Mean phase of the moon
  n_guide int NOT NULL, --/D Number of guider frames during integration
  tai_beg bigint NOT NULL, --/U s --/D MJD (TAI) at start of integrations 
  tai_end bigint NOT NULL, --/U s --/D MJD (TAI) at end of integrations 
  fiber_offset bit NOT NULL, --/D Position offset applied during observations
  f_night_time float NOT NULL, --/D Mid obs time as fraction from sunset to sunrise
  delta_ra_1 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 1 --/F delta_ra
  delta_ra_2 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 2 --/F delta_ra
  delta_ra_3 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 3 --/F delta_ra
  delta_ra_4 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 4 --/F delta_ra
  delta_ra_5 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 5 --/F delta_ra
  delta_ra_6 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 6 --/F delta_ra
  delta_ra_7 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 7 --/F delta_ra
  delta_ra_8 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 8 --/F delta_ra
  delta_ra_9 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 9 --/F delta_ra
  delta_ra_0 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 10 --/F delta_ra
  delta_ra_11 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 11 --/F delta_ra
  delta_ra_12 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 12 --/F delta_ra
  delta_ra_13 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 13 --/F delta_ra
  delta_ra_14 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 14 --/F delta_ra
  delta_ra_15 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 15 --/F delta_ra
  delta_ra_16 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 16 --/F delta_ra
  delta_ra_17 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 17 --/F delta_ra
  delta_ra_18 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 18 --/F delta_ra
  delta_dec_1 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 1 --/F delta_dec
  delta_dec_2 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 2 --/F delta_dec
  delta_dec_3 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 3 --/F delta_dec
  delta_dec_4 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 4 --/F delta_dec
  delta_dec_5 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 5 --/F delta_dec
  delta_dec_6 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 6 --/F delta_dec
  delta_dec_7 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 7 --/F delta_dec
  delta_dec_8 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 8 --/F delta_dec
  delta_dec_9 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 9 --/F delta_dec
  delta_dec_10 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 10 --/F delta_dec
  delta_dec_11 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 11 --/F delta_dec
  delta_dec_12 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 12 --/F delta_dec
  delta_dec_13 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 13 --/F delta_dec
  delta_dec_14 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 14 --/F delta_dec
  delta_dec_15 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 15 --/F delta_dec
  delta_dec_16 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 16 --/F delta_dec
  delta_dec_17 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 17 --/F delta_dec
  delta_dec_18 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 18 --/F delta_dec
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  xcsao_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcsao_e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_rxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D Unique source primary key
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  spectral_type varchar(4) NOT NULL, --/D Spectral type
  sub_type float NOT NULL, --/D Spectral sub-type
  rchi2 float NOT NULL, --/D Reduced chi-square value
  continuum float NOT NULL, --/D Scalar continuum value used
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_bad bit NOT NULL, --/D Bad flag for results
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'mwm_apogee_allstar')
	DROP TABLE mwm_apogee_allstar
GO
--
EXEC spSetDefaultFileGroup 'mwm_apogee_allstar'
GO
CREATE TABLE mwm_apogee_allstar (
    ------- 
    --/H MWM data for each star from APOGEE 
    --/T MWM data for each star from APOGEE 
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    sdss4_apogee_id varchar(20) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier  
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier  
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier  
    healpix int NOT NULL, --/U  --/D HEALPix (128 side)  
    lead varchar(30) NOT NULL, --/U  --/D Lead catalog used for cross-match  
    version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting  
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0)  
    catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5)  
    catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0)  
    n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID  
    n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5  
    sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2)  
    sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2)  
    sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3)  
    sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3)  
    sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3)  
    sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags  
    sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG)  
    ra real NOT NULL, --/U deg --/D Right ascension   
    dec real NOT NULL, --/U deg --/D Declination   
    l real NOT NULL, --/U deg --/D Galactic longitude   
    b real NOT NULL, --/U deg --/D Galactic latitude   
    plx real NOT NULL, --/U mas --/D Parallax   
    e_plx real NOT NULL, --/U mas --/D Error on parallax   
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA   
    e_pmra real NOT NULL, --/U mas/yr --/D Error on proper motion in RA   
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in DEC   
    e_pmde real NOT NULL, --/U mas/yr --/D Error on proper motion in DEC   
    gaia_v_rad real NOT NULL, --/U km/s --/D Gaia radial velocity   
    gaia_e_v_rad real NOT NULL, --/U km/s --/D Error on Gaia radial velocity   
    g_mag real NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude   
    bp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude   
    rp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude   
    j_mag real NOT NULL, --/U mag --/D 2MASS J band magnitude   
    e_j_mag real NOT NULL, --/U mag --/D Error on 2MASS J band magnitude   
    h_mag real NOT NULL, --/U mag --/D 2MASS H band magnitude   
    e_h_mag real NOT NULL, --/U mag --/D Error on 2MASS H band magnitude   
    k_mag real NOT NULL, --/U mag --/D 2MASS K band magnitude   
    e_k_mag real NOT NULL, --/U mag --/D Error on 2MASS K band magnitude   
    ph_qual varchar(10) NOT NULL, --/U  --/D 2MASS photometric quality flag  
    bl_flg varchar(10) NOT NULL, --/U  --/D Number of components fit per band (JHK)  
    cc_flg varchar(10) NOT NULL, --/U  --/D Contamination and confusion flag  
    w1_mag real NOT NULL, --/U  --/D W1 magnitude  
    e_w1_mag real NOT NULL, --/U  --/D Error on W1 magnitude  
    w1_flux real NOT NULL, --/U Vega nMgy --/D W1 flux   
    w1_dflux real NOT NULL, --/U Vega nMgy --/D Error on W1 flux   
    w1_frac real NOT NULL, --/U  --/D Fraction of W1 flux from this object  
    w2_mag real NOT NULL, --/U Vega --/D W2 magnitude   
    e_w2_mag real NOT NULL, --/U  --/D Error on W2 magnitude  
    w2_flux real NOT NULL, --/U Vega nMgy --/D W2 flux   
    w2_dflux real NOT NULL, --/U Vega nMgy --/D Error on W2 flux   
    w2_frac real NOT NULL, --/U  --/D Fraction of W2 flux from this object  
    w1uflags bigint NOT NULL, --/U  --/D unWISE flags for W1  
    w2uflags bigint NOT NULL, --/U  --/D unWISE flags for W2  
    w1aflags bigint NOT NULL, --/U  --/D Additional flags for W1  
    w2aflags bigint NOT NULL, --/U  --/D Additional flags for W2  
    mag4_5 real NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude   
    d4_5m real NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude   
    rms_f4_5 real NOT NULL, --/U mJy --/D RMS deviations from final flux   
    sqf_4_5 bigint NOT NULL, --/U  --/D Source quality flag for IRAC band 4.5 micron  
    mf4_5 bigint NOT NULL, --/U  --/D Flux calculation method flag  
    csf bigint NOT NULL, --/U  --/D Close source flag  
    zgr_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    zgr_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    zgr_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    zgr_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    zgr_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    zgr_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    zgr_e real NOT NULL, --/U mag --/D Extinction   
    zgr_e_e real NOT NULL, --/U mag --/D Error on extinction   
    zgr_plx real NOT NULL, --/U  --/D Parallax [mas] (Gaia DR3)  
    zgr_e_plx real NOT NULL, --/U  --/D Error on parallax [mas] (Gaia DR3)  
    zgr_teff_confidence real NOT NULL, --/U  --/D Confidence estimate in TEFF  
    zgr_logg_confidence real NOT NULL, --/U  --/D Confidence estimate in LOGG  
    zgr_fe_h_confidence real NOT NULL, --/U  --/D Confidence estimate in FE_H  
    zgr_ln_prior real NOT NULL, --/U  --/D Log prior probability  
    zgr_chi2 real NOT NULL, --/U  --/D Chi-square value  
    zgr_quality_flags bigint NOT NULL, --/U  --/D Quality flags  
    r_med_geo real NOT NULL, --/U pc --/D Median geometric distance   
    r_lo_geo real NOT NULL, --/U pc --/D 16th percentile of geometric distance   
    r_hi_geo real NOT NULL, --/U pc --/D 84th percentile of geometric distance   
    r_med_photogeo real NOT NULL, --/U pc --/D 50th percentile of photogeometric distance   
    r_lo_photogeo real NOT NULL, --/U pc --/D 16th percentile of photogeometric distance   
    r_hi_photogeo real NOT NULL, --/U pc --/D 84th percentile of photogeometric distance   
    bailer_jones_flags varchar(10) NOT NULL, --/U  --/D Bailer-Jones quality flags  
    ebv real NOT NULL, --/U mag --/D E(B-V)   
    e_ebv real NOT NULL, --/U mag --/D Error on E(B-V)   
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V)  
    ebv_zhang_2023 real NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023)   
    e_ebv_zhang_2023 real NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023)   
    ebv_sfd real NOT NULL, --/U mag --/D E(B-V) from SFD   
    e_ebv_sfd real NOT NULL, --/U mag --/D Error on E(B-V) from SFD   
    ebv_rjce_glimpse real NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE   
    e_ebv_rjce_glimpse real NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V)   
    ebv_rjce_allwise real NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE   
    e_ebv_rjce_allwise real NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)  
    ebv_bayestar_2019 real NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019   
    e_ebv_bayestar_2019 real NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V)   
    ebv_edenhofer_2023 real NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023)   
    e_ebv_edenhofer_2023 real NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V)   
    c_star real NOT NULL, --/U  --/D Quality parameter (see Riello et al. 2021)  
    u_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC)   
    u_jkc_mag_flag int NOT NULL, --/U  --/D U-band (JKC) is within valid range  
    b_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC)   
    b_jkc_mag_flag int NOT NULL, --/U  --/D B-band (JKC) is within valid range  
    v_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC)   
    v_jkc_mag_flag int NOT NULL, --/U  --/D V-band (JKC) is within valid range  
    r_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC)   
    r_jkc_mag_flag int NOT NULL, --/U  --/D R-band (JKC) is within valid range  
    i_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC)   
    i_jkc_mag_flag int NOT NULL, --/U  --/D I-band (JKC) is within valid range  
    u_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS)   
    u_sdss_mag_flag int NOT NULL, --/U  --/D u-band (SDSS) is within valid range  
    g_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS)   
    g_sdss_mag_flag int NOT NULL, --/U  --/D g-band (SDSS) is within valid range  
    r_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS)   
    r_sdss_mag_flag int NOT NULL, --/U  --/D r-band (SDSS) is within valid range  
    i_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS)   
    i_sdss_mag_flag int NOT NULL, --/U  --/D i-band (SDSS) is within valid range  
    z_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS)   
    z_sdss_mag_flag int NOT NULL, --/U  --/D z-band (SDSS) is within valid range  
    y_ps1_mag real NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1)   
    y_ps1_mag_flag int NOT NULL, --/U  --/D Y-band (PS1) is within valid range  
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits  
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits  
    n_apogee_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    apogee_min_mjd int NOT NULL, --/U  --/D Minimum MJD of APOGEE visits  
    apogee_max_mjd int NOT NULL, --/U  --/D Maximum MJD of APOGEE visits  
    source bigint NOT NULL, --/U  --/D Unique source primary key  
    star_pk bigint NOT NULL, --/U  --/D APOGEE DRP `star` primary key  
    spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key  
    release varchar(10) NOT NULL, --/U  --/D SDSS release  
    filetype varchar(10) NOT NULL, --/U  --/D SDSS file type that stores this spectrum  
    apred varchar(10) NOT NULL, --/U  --/D APOGEE reduction pipeline  
    apstar varchar(10) NOT NULL, --/U  --/D Unused DR17 apStar keyword (default: stars)  
    obj varchar(20) NOT NULL, --/U  --/D Object name  
    telescope varchar(10) NOT NULL, --/U  --/D Short telescope name  
    field varchar(20) NOT NULL, --/U  --/D Field identifier  
    prefix varchar(10) NOT NULL, --/U  --/D Prefix used to separate SDSS 4 north/south  
    min_mjd int NOT NULL, --/U  --/D Minimum MJD of visits  
    max_mjd int NOT NULL, --/U  --/D Maximum MJD of visits  
    n_entries int NOT NULL, --/U  --/D apStar entries for this SDSS4_APOGEE_ID  
    n_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    n_good_visits int NOT NULL, --/U  --/D Number of 'good' APOGEE visits  
    n_good_rvs int NOT NULL, --/U  --/D Number of 'good' APOGEE radial velocities  
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio  
    mean_fiber real NOT NULL, --/U  --/D S/N-weighted mean visit fiber number  
    std_fiber real NOT NULL, --/U  --/D Standard deviation of visit fiber numbers  
    spectrum_flags bigint NOT NULL, --/U  --/D Data reduction pipeline flags for this spectrum  
    v_rad real NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity   
    e_v_rad real NOT NULL, --/U km/s --/D Error on radial velocity   
    std_v_rad real NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD   
    median_e_v_rad real NOT NULL, --/U km/s --/D Median error in radial velocity   
    doppler_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    doppler_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    doppler_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    doppler_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    doppler_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    doppler_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    doppler_rchi2 real NOT NULL, --/U  --/D Reduced chi-square value of DOPPLER fit  
    doppler_flags bigint NOT NULL, --/U  --/D DOPPLER flags  
    xcorr_v_rad real NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity   
    xcorr_v_rel real NOT NULL, --/U km/s --/D Relative velocity   
    xcorr_e_v_rel real NOT NULL, --/U km/s --/D Error on relative velocity   
    ccfwhm real NOT NULL, --/U  --/D Cross-correlation function FWHM  
    autofwhm real NOT NULL, --/U  --/D Auto-correlation function FWHM  
    n_components int NOT NULL, --/U  --/D Number of components in CCF  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'mwm_apogee_allvisit')
	DROP TABLE mwm_apogee_allvisit
GO
--
EXEC spSetDefaultFileGroup 'mwm_apogee_allvisit'
GO
CREATE TABLE mwm_apogee_allvisit (
    ------- 
    --/H MWM data for each visit from APOGEE 
    --/T MWM data for each visit from APOGEE 
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    sdss4_apogee_id varchar(20) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier  
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier  
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier  
    healpix int NOT NULL, --/U  --/D HEALPix (128 side)  
    lead varchar(30) NOT NULL, --/U  --/D Lead catalog used for cross-match  
    version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting  
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0)  
    catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5)  
    catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0)  
    n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID  
    n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5  
    sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2)  
    sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2)  
    sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3)  
    sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3)  
    sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3)  
    sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags  
    sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG)  
    ra real NOT NULL, --/U deg --/D Right ascension   
    dec real NOT NULL, --/U deg --/D Declination   
    l real NOT NULL, --/U deg --/D Galactic longitude   
    b real NOT NULL, --/U deg --/D Galactic latitude   
    plx real NOT NULL, --/U mas --/D Parallax   
    e_plx real NOT NULL, --/U mas --/D Error on parallax   
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA   
    e_pmra real NOT NULL, --/U mas/yr --/D Error on proper motion in RA   
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in DEC   
    e_pmde real NOT NULL, --/U mas/yr --/D Error on proper motion in DEC   
    gaia_v_rad real NOT NULL, --/U km/s --/D Gaia radial velocity   
    gaia_e_v_rad real NOT NULL, --/U km/s --/D Error on Gaia radial velocity   
    g_mag real NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude   
    bp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude   
    rp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude   
    j_mag real NOT NULL, --/U mag --/D 2MASS J band magnitude   
    e_j_mag real NOT NULL, --/U mag --/D Error on 2MASS J band magnitude   
    h_mag real NOT NULL, --/U mag --/D 2MASS H band magnitude   
    e_h_mag real NOT NULL, --/U mag --/D Error on 2MASS H band magnitude   
    k_mag real NOT NULL, --/U mag --/D 2MASS K band magnitude   
    e_k_mag real NOT NULL, --/U mag --/D Error on 2MASS K band magnitude   
    ph_qual varchar(10) NOT NULL, --/U  --/D 2MASS photometric quality flag  
    bl_flg varchar(10) NOT NULL, --/U  --/D Number of components fit per band (JHK)  
    cc_flg varchar(10) NOT NULL, --/U  --/D Contamination and confusion flag  
    w1_mag real NOT NULL, --/U  --/D W1 magnitude  
    e_w1_mag real NOT NULL, --/U  --/D Error on W1 magnitude  
    w1_flux real NOT NULL, --/U Vega nMgy --/D W1 flux   
    w1_dflux real NOT NULL, --/U Vega nMgy --/D Error on W1 flux   
    w1_frac real NOT NULL, --/U  --/D Fraction of W1 flux from this object  
    w2_mag real NOT NULL, --/U Vega --/D W2 magnitude   
    e_w2_mag real NOT NULL, --/U  --/D Error on W2 magnitude  
    w2_flux real NOT NULL, --/U Vega nMgy --/D W2 flux   
    w2_dflux real NOT NULL, --/U Vega nMgy --/D Error on W2 flux   
    w2_frac real NOT NULL, --/U  --/D Fraction of W2 flux from this object  
    w1uflags bigint NOT NULL, --/U  --/D unWISE flags for W1  
    w2uflags bigint NOT NULL, --/U  --/D unWISE flags for W2  
    w1aflags bigint NOT NULL, --/U  --/D Additional flags for W1  
    w2aflags bigint NOT NULL, --/U  --/D Additional flags for W2  
    mag4_5 real NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude   
    d4_5m real NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude   
    rms_f4_5 real NOT NULL, --/U mJy --/D RMS deviations from final flux   
    sqf_4_5 bigint NOT NULL, --/U  --/D Source quality flag for IRAC band 4.5 micron  
    mf4_5 bigint NOT NULL, --/U  --/D Flux calculation method flag  
    csf bigint NOT NULL, --/U  --/D Close source flag  
    zgr_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    zgr_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    zgr_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    zgr_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    zgr_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    zgr_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    zgr_e real NOT NULL, --/U mag --/D Extinction   
    zgr_e_e real NOT NULL, --/U mag --/D Error on extinction   
    zgr_plx real NOT NULL, --/U  --/D Parallax [mas] (Gaia DR3)  
    zgr_e_plx real NOT NULL, --/U  --/D Error on parallax [mas] (Gaia DR3)  
    zgr_teff_confidence real NOT NULL, --/U  --/D Confidence estimate in TEFF  
    zgr_logg_confidence real NOT NULL, --/U  --/D Confidence estimate in LOGG  
    zgr_fe_h_confidence real NOT NULL, --/U  --/D Confidence estimate in FE_H  
    zgr_ln_prior real NOT NULL, --/U  --/D Log prior probability  
    zgr_chi2 real NOT NULL, --/U  --/D Chi-square value  
    zgr_quality_flags bigint NOT NULL, --/U  --/D Quality flags  
    r_med_geo real NOT NULL, --/U pc --/D Median geometric distance   
    r_lo_geo real NOT NULL, --/U pc --/D 16th percentile of geometric distance   
    r_hi_geo real NOT NULL, --/U pc --/D 84th percentile of geometric distance   
    r_med_photogeo real NOT NULL, --/U pc --/D 50th percentile of photogeometric distance   
    r_lo_photogeo real NOT NULL, --/U pc --/D 16th percentile of photogeometric distance   
    r_hi_photogeo real NOT NULL, --/U pc --/D 84th percentile of photogeometric distance   
    bailer_jones_flags varchar(10) NOT NULL, --/U  --/D Bailer-Jones quality flags  
    ebv real NOT NULL, --/U mag --/D E(B-V)   
    e_ebv real NOT NULL, --/U mag --/D Error on E(B-V)   
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V)  
    ebv_zhang_2023 real NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023)   
    e_ebv_zhang_2023 real NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023)   
    ebv_sfd real NOT NULL, --/U mag --/D E(B-V) from SFD   
    e_ebv_sfd real NOT NULL, --/U mag --/D Error on E(B-V) from SFD   
    ebv_rjce_glimpse real NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE   
    e_ebv_rjce_glimpse real NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V)   
    ebv_rjce_allwise real NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE   
    e_ebv_rjce_allwise real NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)  
    ebv_bayestar_2019 real NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019   
    e_ebv_bayestar_2019 real NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V)   
    ebv_edenhofer_2023 real NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023)   
    e_ebv_edenhofer_2023 real NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V)   
    c_star real NOT NULL, --/U  --/D Quality parameter (see Riello et al. 2021)  
    u_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC)   
    u_jkc_mag_flag int NOT NULL, --/U  --/D U-band (JKC) is within valid range  
    b_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC)   
    b_jkc_mag_flag int NOT NULL, --/U  --/D B-band (JKC) is within valid range  
    v_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC)   
    v_jkc_mag_flag int NOT NULL, --/U  --/D V-band (JKC) is within valid range  
    r_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC)   
    r_jkc_mag_flag int NOT NULL, --/U  --/D R-band (JKC) is within valid range  
    i_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC)   
    i_jkc_mag_flag int NOT NULL, --/U  --/D I-band (JKC) is within valid range  
    u_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS)   
    u_sdss_mag_flag int NOT NULL, --/U  --/D u-band (SDSS) is within valid range  
    g_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS)   
    g_sdss_mag_flag int NOT NULL, --/U  --/D g-band (SDSS) is within valid range  
    r_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS)   
    r_sdss_mag_flag int NOT NULL, --/U  --/D r-band (SDSS) is within valid range  
    i_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS)   
    i_sdss_mag_flag int NOT NULL, --/U  --/D i-band (SDSS) is within valid range  
    z_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS)   
    z_sdss_mag_flag int NOT NULL, --/U  --/D z-band (SDSS) is within valid range  
    y_ps1_mag real NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1)   
    y_ps1_mag_flag int NOT NULL, --/U  --/D Y-band (PS1) is within valid range  
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits  
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits  
    n_apogee_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    apogee_min_mjd int NOT NULL, --/U  --/D Minimum MJD of APOGEE visits  
    apogee_max_mjd int NOT NULL, --/U  --/D Maximum MJD of APOGEE visits  
    spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key  
    source bigint NOT NULL, --/U  --/D Unique source primary key  
    star_pk bigint NOT NULL, --/U  --/D APOGEE DRP `star` primary key  
    visit_pk bigint NOT NULL, --/U  --/D APOGEE DRP `visit` primary key  
    rv_visit_pk bigint NOT NULL, --/U  --/D APOGEE DRP `rv_visit` primary key  
    release varchar(10) NOT NULL, --/U  --/D SDSS release  
    filetype varchar(10) NOT NULL, --/U  --/D SDSS file type that stores this spectrum  
    apred varchar(10) NOT NULL, --/U  --/D APOGEE reduction pipeline  
    plate varchar(20) NOT NULL, --/U  --/D Plate identifier  
    telescope varchar(10) NOT NULL, --/U  --/D Short telescope name  
    fiber int NOT NULL, --/U  --/D Fiber number  
    mjd int NOT NULL, --/U  --/D Modified Julian date of observation  
    field varchar(30) NOT NULL, --/U  --/D Field identifier  
    prefix varchar(10) NOT NULL, --/U  --/D Prefix used to separate SDSS 4 north/south  
    reduction varchar(20) NOT NULL, --/U  --/D An `obj`-like keyword used for apo1m spectra  
    obj varchar(20) NOT NULL, --/U  --/D Object name  
    date_obs varchar(30) NOT NULL, --/U  --/D Observation date (UTC)  
    jd real NOT NULL, --/U  --/D Julian date at mid-point of visit  
    exptime real NOT NULL, --/U s --/D Exposure time   
    dithered bit NOT NULL, --/U  --/D Fraction of visits that were dithered  
    f_night_time real NOT NULL, --/U  --/D Mid obs time as fraction from sunset to sunrise  
    input_ra real NOT NULL, --/U deg --/D Input right ascension   
    input_dec real NOT NULL, --/U deg --/D Input declination   
    n_frames int NOT NULL, --/U  --/D Number of frames combined  
    assigned int NOT NULL, --/U  --/D FPS target assigned  
    on_target int NOT NULL, --/U  --/D FPS fiber on target  
    valid int NOT NULL, --/U  --/D Valid FPS target  
    fps bit NOT NULL, --/U  --/D Fibre positioner used to acquire this data?  
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio  
    spectrum_flags bigint NOT NULL, --/U  --/D Data reduction pipeline flags for this spectrum  
    v_rad real NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity   
    v_rel real NOT NULL, --/U km/s --/D Relative velocity   
    e_v_rel real NOT NULL, --/U km/s --/D Error on relative velocity   
    bc real NOT NULL, --/U km/s --/D Barycentric velocity correction applied   
    doppler_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    doppler_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    doppler_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    doppler_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    doppler_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    doppler_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    doppler_rchi2 real NOT NULL, --/U  --/D Reduced chi-square value of DOPPLER fit  
    doppler_flags bigint NOT NULL, --/U  --/D DOPPLER flags  
    xcorr_v_rad real NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity   
    xcorr_v_rel real NOT NULL, --/U km/s --/D Relative velocity   
    xcorr_e_v_rel real NOT NULL, --/U km/s --/D Error on relative velocity   
    ccfwhm real NOT NULL, --/U  --/D Cross-correlation function FWHM  
    autofwhm real NOT NULL, --/U  --/D Auto-correlation function FWHM  
    n_components int NOT NULL, --/U  --/D Number of components in CCF  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'mwm_boss_allstar')
	DROP TABLE mwm_boss_allstar
GO
--
EXEC spSetDefaultFileGroup 'mwm_boss_allstar'
GO
CREATE TABLE mwm_boss_allstar (
    ------- 
    --/H MWM data for each star from BOSS 
    --/T MWM data for each star from BOSS 
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    sdss4_apogee_id varchar(20) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier  
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier  
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier  
    healpix int NOT NULL, --/U  --/D HEALPix (128 side)  
    lead varchar(30) NOT NULL, --/U  --/D Lead catalog used for cross-match  
    version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting  
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0)  
    catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5)  
    catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0)  
    n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID  
    n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5  
    sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2)  
    sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2)  
    sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3)  
    sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3)  
    sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3)  
    sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags  
    sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG)  
    ra real NOT NULL, --/U deg --/D Right ascension   
    dec real NOT NULL, --/U deg --/D Declination   
    l real NOT NULL, --/U deg --/D Galactic longitude   
    b real NOT NULL, --/U deg --/D Galactic latitude   
    plx real NOT NULL, --/U mas --/D Parallax   
    e_plx real NOT NULL, --/U mas --/D Error on parallax   
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA   
    e_pmra real NOT NULL, --/U mas/yr --/D Error on proper motion in RA   
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in DEC   
    e_pmde real NOT NULL, --/U mas/yr --/D Error on proper motion in DEC   
    gaia_v_rad real NOT NULL, --/U km/s --/D Gaia radial velocity   
    gaia_e_v_rad real NOT NULL, --/U km/s --/D Error on Gaia radial velocity   
    g_mag real NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude   
    bp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude   
    rp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude   
    j_mag real NOT NULL, --/U mag --/D 2MASS J band magnitude   
    e_j_mag real NOT NULL, --/U mag --/D Error on 2MASS J band magnitude   
    h_mag real NOT NULL, --/U mag --/D 2MASS H band magnitude   
    e_h_mag real NOT NULL, --/U mag --/D Error on 2MASS H band magnitude   
    k_mag real NOT NULL, --/U mag --/D 2MASS K band magnitude   
    e_k_mag real NOT NULL, --/U mag --/D Error on 2MASS K band magnitude   
    ph_qual varchar(10) NOT NULL, --/U  --/D 2MASS photometric quality flag  
    bl_flg varchar(10) NOT NULL, --/U  --/D Number of components fit per band (JHK)  
    cc_flg varchar(10) NOT NULL, --/U  --/D Contamination and confusion flag  
    w1_mag real NOT NULL, --/U  --/D W1 magnitude  
    e_w1_mag real NOT NULL, --/U  --/D Error on W1 magnitude  
    w1_flux real NOT NULL, --/U Vega nMgy --/D W1 flux   
    w1_dflux real NOT NULL, --/U Vega nMgy --/D Error on W1 flux   
    w1_frac real NOT NULL, --/U  --/D Fraction of W1 flux from this object  
    w2_mag real NOT NULL, --/U Vega --/D W2 magnitude   
    e_w2_mag real NOT NULL, --/U  --/D Error on W2 magnitude  
    w2_flux real NOT NULL, --/U Vega nMgy --/D W2 flux   
    w2_dflux real NOT NULL, --/U Vega nMgy --/D Error on W2 flux   
    w2_frac real NOT NULL, --/U  --/D Fraction of W2 flux from this object  
    w1uflags bigint NOT NULL, --/U  --/D unWISE flags for W1  
    w2uflags bigint NOT NULL, --/U  --/D unWISE flags for W2  
    w1aflags bigint NOT NULL, --/U  --/D Additional flags for W1  
    w2aflags bigint NOT NULL, --/U  --/D Additional flags for W2  
    mag4_5 real NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude   
    d4_5m real NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude   
    rms_f4_5 real NOT NULL, --/U mJy --/D RMS deviations from final flux   
    sqf_4_5 bigint NOT NULL, --/U  --/D Source quality flag for IRAC band 4.5 micron  
    mf4_5 bigint NOT NULL, --/U  --/D Flux calculation method flag  
    csf bigint NOT NULL, --/U  --/D Close source flag  
    zgr_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    zgr_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    zgr_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    zgr_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    zgr_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    zgr_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    zgr_e real NOT NULL, --/U mag --/D Extinction   
    zgr_e_e real NOT NULL, --/U mag --/D Error on extinction   
    zgr_plx real NOT NULL, --/U  --/D Parallax [mas] (Gaia DR3)  
    zgr_e_plx real NOT NULL, --/U  --/D Error on parallax [mas] (Gaia DR3)  
    zgr_teff_confidence real NOT NULL, --/U  --/D Confidence estimate in TEFF  
    zgr_logg_confidence real NOT NULL, --/U  --/D Confidence estimate in LOGG  
    zgr_fe_h_confidence real NOT NULL, --/U  --/D Confidence estimate in FE_H  
    zgr_ln_prior real NOT NULL, --/U  --/D Log prior probability  
    zgr_chi2 real NOT NULL, --/U  --/D Chi-square value  
    zgr_quality_flags bigint NOT NULL, --/U  --/D Quality flags  
    r_med_geo real NOT NULL, --/U pc --/D Median geometric distance   
    r_lo_geo real NOT NULL, --/U pc --/D 16th percentile of geometric distance   
    r_hi_geo real NOT NULL, --/U pc --/D 84th percentile of geometric distance   
    r_med_photogeo real NOT NULL, --/U pc --/D 50th percentile of photogeometric distance   
    r_lo_photogeo real NOT NULL, --/U pc --/D 16th percentile of photogeometric distance   
    r_hi_photogeo real NOT NULL, --/U pc --/D 84th percentile of photogeometric distance   
    bailer_jones_flags varchar(10) NOT NULL, --/U  --/D Bailer-Jones quality flags  
    ebv real NOT NULL, --/U mag --/D E(B-V)   
    e_ebv real NOT NULL, --/U mag --/D Error on E(B-V)   
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V)  
    ebv_zhang_2023 real NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023)   
    e_ebv_zhang_2023 real NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023)   
    ebv_sfd real NOT NULL, --/U mag --/D E(B-V) from SFD   
    e_ebv_sfd real NOT NULL, --/U mag --/D Error on E(B-V) from SFD   
    ebv_rjce_glimpse real NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE   
    e_ebv_rjce_glimpse real NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V)   
    ebv_rjce_allwise real NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE   
    e_ebv_rjce_allwise real NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)  
    ebv_bayestar_2019 real NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019   
    e_ebv_bayestar_2019 real NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V)   
    ebv_edenhofer_2023 real NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023)   
    e_ebv_edenhofer_2023 real NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V)   
    c_star real NOT NULL, --/U  --/D Quality parameter (see Riello et al. 2021)  
    u_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC)   
    u_jkc_mag_flag int NOT NULL, --/U  --/D U-band (JKC) is within valid range  
    b_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC)   
    b_jkc_mag_flag int NOT NULL, --/U  --/D B-band (JKC) is within valid range  
    v_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC)   
    v_jkc_mag_flag int NOT NULL, --/U  --/D V-band (JKC) is within valid range  
    r_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC)   
    r_jkc_mag_flag int NOT NULL, --/U  --/D R-band (JKC) is within valid range  
    i_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC)   
    i_jkc_mag_flag int NOT NULL, --/U  --/D I-band (JKC) is within valid range  
    u_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS)   
    u_sdss_mag_flag int NOT NULL, --/U  --/D u-band (SDSS) is within valid range  
    g_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS)   
    g_sdss_mag_flag int NOT NULL, --/U  --/D g-band (SDSS) is within valid range  
    r_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS)   
    r_sdss_mag_flag int NOT NULL, --/U  --/D r-band (SDSS) is within valid range  
    i_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS)   
    i_sdss_mag_flag int NOT NULL, --/U  --/D i-band (SDSS) is within valid range  
    z_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS)   
    z_sdss_mag_flag int NOT NULL, --/U  --/D z-band (SDSS) is within valid range  
    y_ps1_mag real NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1)   
    y_ps1_mag_flag int NOT NULL, --/U  --/D Y-band (PS1) is within valid range  
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits  
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits  
    n_apogee_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    apogee_min_mjd int NOT NULL, --/U  --/D Minimum MJD of APOGEE visits  
    apogee_max_mjd int NOT NULL, --/U  --/D Maximum MJD of APOGEE visits  
    spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key  
    source bigint NOT NULL, --/U  --/D Unique source primary key  
    release varchar(10) NOT NULL, --/U  --/D SDSS release  
    filetype varchar(10) NOT NULL, --/U  --/D SDSS file type that stores this spectrum  
    v_astra varchar(10) NOT NULL, --/U  --/D Astra version  
    run2d varchar(10) NOT NULL, --/U  --/D BOSS data reduction pipeline version  
    telescope varchar(10) NOT NULL, --/U  --/D Short telescope name  
    min_mjd int NOT NULL, --/U  --/D Minimum MJD of visits  
    max_mjd int NOT NULL, --/U  --/D Maximum MJD of visits  
    n_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    n_good_visits int NOT NULL, --/U  --/D Number of 'good' BOSS visits  
    n_good_rvs int NOT NULL, --/U  --/D Number of 'good' BOSS radial velocities  
    v_rad real NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity   
    e_v_rad real NOT NULL, --/U km/s --/D Error on radial velocity   
    std_v_rad real NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD   
    median_e_v_rad real NOT NULL, --/U km/s --/D Median error in radial velocity   
    xcsao_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    xcsao_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    xcsao_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    xcsao_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    xcsao_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    xcsao_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    xcsao_meanrxc real NOT NULL, --/U  --/D Cross-correlation R-value (1979AJ.....84.1511T)  
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio  
    gri_gaia_transform_flags bigint NOT NULL, --/U  --/D Flags for provenance of ugriz photometry  
    zwarning_flags bigint NOT NULL, --/U  --/D BOSS DRP warning flags  
    nmf_rchi2 real NOT NULL, --/U  --/D Reduced chi-square value of NMF continuum fit  
    nmf_flags bigint NOT NULL, --/U  --/D NMF Continuum method flags  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'mwm_boss_allvisit')
	DROP TABLE mwm_boss_allvisit
GO
--
EXEC spSetDefaultFileGroup 'mwm_boss_allvisit'
GO
CREATE TABLE mwm_boss_allvisit (
    ------- 
    --/H MWM data for each visit from BOSS 
    --/T MWM data for each visit from BOSS 
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    sdss4_apogee_id varchar(20) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier  
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier  
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier  
    healpix int NOT NULL, --/U  --/D HEALPix (128 side)  
    lead varchar(30) NOT NULL, --/U  --/D Lead catalog used for cross-match  
    version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting  
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0)  
    catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5)  
    catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0)  
    n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID  
    n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5  
    sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2)  
    sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2)  
    sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3)  
    sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3)  
    sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3)  
    sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags  
    sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG)  
    ra real NOT NULL, --/U deg --/D Right ascension   
    dec real NOT NULL, --/U deg --/D Declination   
    l real NOT NULL, --/U deg --/D Galactic longitude   
    b real NOT NULL, --/U deg --/D Galactic latitude   
    plx real NOT NULL, --/U mas --/D Parallax   
    e_plx real NOT NULL, --/U mas --/D Error on parallax   
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA   
    e_pmra real NOT NULL, --/U mas/yr --/D Error on proper motion in RA   
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in DEC   
    e_pmde real NOT NULL, --/U mas/yr --/D Error on proper motion in DEC   
    gaia_v_rad real NOT NULL, --/U km/s --/D Gaia radial velocity   
    gaia_e_v_rad real NOT NULL, --/U km/s --/D Error on Gaia radial velocity   
    g_mag real NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude   
    bp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude   
    rp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude   
    j_mag real NOT NULL, --/U mag --/D 2MASS J band magnitude   
    e_j_mag real NOT NULL, --/U mag --/D Error on 2MASS J band magnitude   
    h_mag real NOT NULL, --/U mag --/D 2MASS H band magnitude   
    e_h_mag real NOT NULL, --/U mag --/D Error on 2MASS H band magnitude   
    k_mag real NOT NULL, --/U mag --/D 2MASS K band magnitude   
    e_k_mag real NOT NULL, --/U mag --/D Error on 2MASS K band magnitude   
    ph_qual varchar(10) NOT NULL, --/U  --/D 2MASS photometric quality flag  
    bl_flg varchar(10) NOT NULL, --/U  --/D Number of components fit per band (JHK)  
    cc_flg varchar(10) NOT NULL, --/U  --/D Contamination and confusion flag  
    w1_mag real NOT NULL, --/U  --/D W1 magnitude  
    e_w1_mag real NOT NULL, --/U  --/D Error on W1 magnitude  
    w1_flux real NOT NULL, --/U Vega nMgy --/D W1 flux   
    w1_dflux real NOT NULL, --/U Vega nMgy --/D Error on W1 flux   
    w1_frac real NOT NULL, --/U  --/D Fraction of W1 flux from this object  
    w2_mag real NOT NULL, --/U Vega --/D W2 magnitude   
    e_w2_mag real NOT NULL, --/U  --/D Error on W2 magnitude  
    w2_flux real NOT NULL, --/U Vega nMgy --/D W2 flux   
    w2_dflux real NOT NULL, --/U Vega nMgy --/D Error on W2 flux   
    w2_frac real NOT NULL, --/U  --/D Fraction of W2 flux from this object  
    w1uflags bigint NOT NULL, --/U  --/D unWISE flags for W1  
    w2uflags bigint NOT NULL, --/U  --/D unWISE flags for W2  
    w1aflags bigint NOT NULL, --/U  --/D Additional flags for W1  
    w2aflags bigint NOT NULL, --/U  --/D Additional flags for W2  
    mag4_5 real NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude   
    d4_5m real NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude   
    rms_f4_5 real NOT NULL, --/U mJy --/D RMS deviations from final flux   
    sqf_4_5 bigint NOT NULL, --/U  --/D Source quality flag for IRAC band 4.5 micron  
    mf4_5 bigint NOT NULL, --/U  --/D Flux calculation method flag  
    csf bigint NOT NULL, --/U  --/D Close source flag  
    zgr_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    zgr_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    zgr_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    zgr_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    zgr_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    zgr_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    zgr_e real NOT NULL, --/U mag --/D Extinction   
    zgr_e_e real NOT NULL, --/U mag --/D Error on extinction   
    zgr_plx real NOT NULL, --/U  --/D Parallax [mas] (Gaia DR3)  
    zgr_e_plx real NOT NULL, --/U  --/D Error on parallax [mas] (Gaia DR3)  
    zgr_teff_confidence real NOT NULL, --/U  --/D Confidence estimate in TEFF  
    zgr_logg_confidence real NOT NULL, --/U  --/D Confidence estimate in LOGG  
    zgr_fe_h_confidence real NOT NULL, --/U  --/D Confidence estimate in FE_H  
    zgr_ln_prior real NOT NULL, --/U  --/D Log prior probability  
    zgr_chi2 real NOT NULL, --/U  --/D Chi-square value  
    zgr_quality_flags bigint NOT NULL, --/U  --/D Quality flags  
    r_med_geo real NOT NULL, --/U pc --/D Median geometric distance   
    r_lo_geo real NOT NULL, --/U pc --/D 16th percentile of geometric distance   
    r_hi_geo real NOT NULL, --/U pc --/D 84th percentile of geometric distance   
    r_med_photogeo real NOT NULL, --/U pc --/D 50th percentile of photogeometric distance   
    r_lo_photogeo real NOT NULL, --/U pc --/D 16th percentile of photogeometric distance   
    r_hi_photogeo real NOT NULL, --/U pc --/D 84th percentile of photogeometric distance   
    bailer_jones_flags varchar(10) NOT NULL, --/U  --/D Bailer-Jones quality flags  
    ebv real NOT NULL, --/U mag --/D E(B-V)   
    e_ebv real NOT NULL, --/U mag --/D Error on E(B-V)   
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V)  
    ebv_zhang_2023 real NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023)   
    e_ebv_zhang_2023 real NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023)   
    ebv_sfd real NOT NULL, --/U mag --/D E(B-V) from SFD   
    e_ebv_sfd real NOT NULL, --/U mag --/D Error on E(B-V) from SFD   
    ebv_rjce_glimpse real NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE   
    e_ebv_rjce_glimpse real NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V)   
    ebv_rjce_allwise real NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE   
    e_ebv_rjce_allwise real NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)  
    ebv_bayestar_2019 real NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019   
    e_ebv_bayestar_2019 real NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V)   
    ebv_edenhofer_2023 real NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023)   
    e_ebv_edenhofer_2023 real NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V)   
    c_star real NOT NULL, --/U  --/D Quality parameter (see Riello et al. 2021)  
    u_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC)   
    u_jkc_mag_flag int NOT NULL, --/U  --/D U-band (JKC) is within valid range  
    b_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC)   
    b_jkc_mag_flag int NOT NULL, --/U  --/D B-band (JKC) is within valid range  
    v_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC)   
    v_jkc_mag_flag int NOT NULL, --/U  --/D V-band (JKC) is within valid range  
    r_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC)   
    r_jkc_mag_flag int NOT NULL, --/U  --/D R-band (JKC) is within valid range  
    i_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC)   
    i_jkc_mag_flag int NOT NULL, --/U  --/D I-band (JKC) is within valid range  
    u_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS)   
    u_sdss_mag_flag int NOT NULL, --/U  --/D u-band (SDSS) is within valid range  
    g_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS)   
    g_sdss_mag_flag int NOT NULL, --/U  --/D g-band (SDSS) is within valid range  
    r_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS)   
    r_sdss_mag_flag int NOT NULL, --/U  --/D r-band (SDSS) is within valid range  
    i_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS)   
    i_sdss_mag_flag int NOT NULL, --/U  --/D i-band (SDSS) is within valid range  
    z_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS)   
    z_sdss_mag_flag int NOT NULL, --/U  --/D z-band (SDSS) is within valid range  
    y_ps1_mag real NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1)   
    y_ps1_mag_flag int NOT NULL, --/U  --/D Y-band (PS1) is within valid range  
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits  
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits  
    n_apogee_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    apogee_min_mjd int NOT NULL, --/U  --/D Minimum MJD of APOGEE visits  
    apogee_max_mjd int NOT NULL, --/U  --/D Maximum MJD of APOGEE visits  
    spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key  
    source bigint NOT NULL, --/U  --/D Unique source primary key  
    release varchar(10) NOT NULL, --/U  --/D SDSS release  
    filetype varchar(10) NOT NULL, --/U  --/D SDSS file type that stores this spectrum  
    run2d varchar(10) NOT NULL, --/U  --/D BOSS data reduction pipeline version  
    mjd int NOT NULL, --/U  --/D Modified Julian date of observation  
    fieldid int NOT NULL, --/U  --/D Field identifier  
    n_exp int NOT NULL, --/U  --/D Number of co-added exposures  
    exptime real NOT NULL, --/U s --/D Exposure time   
    plateid int NOT NULL, --/U  --/D Plate identifier  
    cartid int NOT NULL, --/U  --/D Cartridge identifier  
    mapid int NOT NULL, --/U  --/D Mapping version of the loaded plate  
    slitid int NOT NULL, --/U  --/D Slit identifier  
    psfsky int NOT NULL, --/U  --/D Order of PSF sky subtraction  
    preject real NOT NULL, --/U  --/D Profile area rejection threshold  
    n_std int NOT NULL, --/U  --/D Number of (good) standard stars  
    n_gal int NOT NULL, --/U  --/D Number of (good) galaxies in field  
    lowrej int NOT NULL, --/U  --/D Extraction: low rejection  
    highrej int NOT NULL, --/U  --/D Extraction: high rejection  
    scatpoly int NOT NULL, --/U  --/D Extraction: Order of scattered light polynomial  
    proftype int NOT NULL, --/U  --/D Extraction profile: 1=Gaussian  
    nfitpoly int NOT NULL, --/U  --/D Extraction: Number of profile parameters  
    skychi2 real NOT NULL, --/U  --/D Mean \chi^2 of sky subtraction  
    schi2min real NOT NULL, --/U  --/D Minimum \chi^2 of sky subtraction  
    schi2max real NOT NULL, --/U  --/D Maximum \chi^2 of sky subtraction  
    alt real NOT NULL, --/U deg --/D Telescope altitude   
    az real NOT NULL, --/U deg --/D Telescope azimuth   
    telescope varchar(10) NOT NULL, --/U  --/D Short telescope name  
    seeing real NOT NULL, --/U arcsecond --/D Median seeing conditions   
    airmass real NOT NULL, --/U  --/D Mean airmass  
    airtemp real NOT NULL, --/U C --/D Air temperature   
    dewpoint real NOT NULL, --/U C --/D Dew point temperature   
    humidity real NOT NULL, --/U % --/D Humidity   
    pressure real NOT NULL, --/U millibar --/D Air pressure   
    dust_a real NOT NULL, --/U particles m^-3 s^-1 --/D 0.3mu-sized dust count   
    dust_b real NOT NULL, --/U particles m^-3 s^-1 --/D 1.0mu-sized dust count   
    gust_direction real NOT NULL, --/U deg --/D Wind gust direction   
    gust_speed real NOT NULL, --/U km/s --/D Wind gust speed   
    wind_direction real NOT NULL, --/U deg --/D Wind direction   
    wind_speed real NOT NULL, --/U km/s --/D Wind speed   
    moon_dist_mean real NOT NULL, --/U deg --/D Mean sky distance to the moon   
    moon_phase_mean real NOT NULL, --/U  --/D Mean phase of the moon  
    n_guide int NOT NULL, --/U  --/D Number of guider frames during integration  
    tai_beg bigint NOT NULL, --/U s --/D MJD (TAI) at start of integrations   
    tai_end bigint NOT NULL, --/U s --/D MJD (TAI) at end of integrations   
    fiber_offset bit NOT NULL, --/U  --/D Position offset applied during observations  
    f_night_time real NOT NULL, --/U  --/D Mid obs time as fraction from sunset to sunrise  
    delta_ra_1 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 1 --/F delta_ra
    delta_ra_2 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 2 --/F delta_ra
    delta_ra_3 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 3 --/F delta_ra
    delta_ra_4 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 4 --/F delta_ra
    delta_ra_5 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 5 --/F delta_ra
    delta_ra_6 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 6 --/F delta_ra
    delta_ra_7 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 7 --/F delta_ra
    delta_ra_8 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 8 --/F delta_ra
    delta_ra_9 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 9 --/F delta_ra
    delta_ra_0 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 10 --/F delta_ra
    delta_ra_11 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 11 --/F delta_ra
    delta_ra_12 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 12 --/F delta_ra
    delta_ra_13 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 13 --/F delta_ra
    delta_ra_14 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 14 --/F delta_ra
    delta_ra_15 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 15 --/F delta_ra
    delta_ra_16 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 16 --/F delta_ra
    delta_ra_17 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 17 --/F delta_ra
    delta_ra_18 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 18 --/F delta_ra
    delta_dec_1 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 1 --/F delta_dec
    delta_dec_2 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 2 --/F delta_dec
    delta_dec_3 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 3 --/F delta_dec
    delta_dec_4 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 4 --/F delta_dec
    delta_dec_5 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 5 --/F delta_dec
    delta_dec_6 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 6 --/F delta_dec
    delta_dec_7 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 7 --/F delta_dec
    delta_dec_8 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 8 --/F delta_dec
    delta_dec_9 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 9 --/F delta_dec
    delta_dec_10 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 10 --/F delta_dec
    delta_dec_11 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 11 --/F delta_dec
    delta_dec_12 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 12 --/F delta_dec
    delta_dec_13 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 13 --/F delta_dec
    delta_dec_14 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 14 --/F delta_dec
    delta_dec_15 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 15 --/F delta_dec
    delta_dec_16 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 16 --/F delta_dec
    delta_dec_17 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 17 --/F delta_dec
    delta_dec_18 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 18 --/F delta_dec
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio  
    gri_gaia_transform_flags bigint NOT NULL, --/U  --/D Flags for provenance of ugriz photometry  
    zwarning_flags bigint NOT NULL, --/U  --/D BOSS DRP warning flags  
    xcsao_v_rad real NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity   
    xcsao_e_v_rad real NOT NULL, --/U km/s --/D Error on radial velocity   
    xcsao_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    xcsao_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    xcsao_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    xcsao_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    xcsao_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    xcsao_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    xcsao_rxc real NOT NULL, --/U  --/D Cross-correlation R-value (1979AJ.....84.1511T)  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'mwm_targets')
	DROP TABLE mwm_targets
GO
--
EXEC spSetDefaultFileGroup 'mwm_targets'
GO
CREATE TABLE mwm_targets (
    -------
    --/H Targeting information for each MWM target 
    --/T Targeting information for each MWM target 
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    sdss4_apogee_id varchar(20) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier  
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier  
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier  
    healpix int NOT NULL, --/U  --/D HEALPix (128 side)  
    lead varchar(30) NOT NULL, --/U  --/D Lead catalog used for cross-match  
    version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting  
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0)  
    catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5)  
    catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0)  
    n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID  
    n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5  
    sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2)  
    sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2)  
    sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3)  
    sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3)  
    sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3)  
    sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags  
    sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG)  
    ra real NOT NULL, --/U deg --/D Right ascension   
    dec real NOT NULL, --/U deg --/D Declination   
    l real NOT NULL, --/U deg --/D Galactic longitude   
    b real NOT NULL, --/U deg --/D Galactic latitude   
    plx real NOT NULL, --/U mas --/D Parallax   
    e_plx real NOT NULL, --/U mas --/D Error on parallax   
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA   
    e_pmra real NOT NULL, --/U mas/yr --/D Error on proper motion in RA   
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in DEC   
    e_pmde real NOT NULL, --/U mas/yr --/D Error on proper motion in DEC   
    gaia_v_rad real NOT NULL, --/U km/s --/D Gaia radial velocity   
    gaia_e_v_rad real NOT NULL, --/U km/s --/D Error on Gaia radial velocity   
    g_mag real NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude   
    bp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude   
    rp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude   
    j_mag real NOT NULL, --/U mag --/D 2MASS J band magnitude   
    e_j_mag real NOT NULL, --/U mag --/D Error on 2MASS J band magnitude   
    h_mag real NOT NULL, --/U mag --/D 2MASS H band magnitude   
    e_h_mag real NOT NULL, --/U mag --/D Error on 2MASS H band magnitude   
    k_mag real NOT NULL, --/U mag --/D 2MASS K band magnitude   
    e_k_mag real NOT NULL, --/U mag --/D Error on 2MASS K band magnitude   
    ph_qual varchar(10) NOT NULL, --/U  --/D 2MASS photometric quality flag  
    bl_flg varchar(10) NOT NULL, --/U  --/D Number of components fit per band (JHK)  
    cc_flg varchar(10) NOT NULL, --/U  --/D Contamination and confusion flag  
    w1_mag real NOT NULL, --/U  --/D W1 magnitude  
    e_w1_mag real NOT NULL, --/U  --/D Error on W1 magnitude  
    w1_flux real NOT NULL, --/U Vega nMgy --/D W1 flux   
    w1_dflux real NOT NULL, --/U Vega nMgy --/D Error on W1 flux   
    w1_frac real NOT NULL, --/U  --/D Fraction of W1 flux from this object  
    w2_mag real NOT NULL, --/U Vega --/D W2 magnitude   
    e_w2_mag real NOT NULL, --/U  --/D Error on W2 magnitude  
    w2_flux real NOT NULL, --/U Vega nMgy --/D W2 flux   
    w2_dflux real NOT NULL, --/U Vega nMgy --/D Error on W2 flux   
    w2_frac real NOT NULL, --/U  --/D Fraction of W2 flux from this object  
    w1uflags bigint NOT NULL, --/U  --/D unWISE flags for W1  
    w2uflags bigint NOT NULL, --/U  --/D unWISE flags for W2  
    w1aflags bigint NOT NULL, --/U  --/D Additional flags for W1  
    w2aflags bigint NOT NULL, --/U  --/D Additional flags for W2  
    mag4_5 real NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude   
    d4_5m real NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude   
    rms_f4_5 real NOT NULL, --/U mJy --/D RMS deviations from final flux   
    sqf_4_5 bigint NOT NULL, --/U  --/D Source quality flag for IRAC band 4.5 micron  
    mf4_5 bigint NOT NULL, --/U  --/D Flux calculation method flag  
    csf bigint NOT NULL, --/U  --/D Close source flag  
    zgr_teff real NOT NULL, --/U K --/D Stellar effective temperature   
    zgr_e_teff real NOT NULL, --/U K --/D Error on stellar effective temperature   
    zgr_logg real NOT NULL, --/U log10(cm/s^2) --/D Surface gravity   
    zgr_e_logg real NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity   
    zgr_fe_h real NOT NULL, --/U dex --/D [Fe/H]   
    zgr_e_fe_h real NOT NULL, --/U dex --/D Error on [Fe/H]   
    zgr_e real NOT NULL, --/U mag --/D Extinction   
    zgr_e_e real NOT NULL, --/U mag --/D Error on extinction   
    zgr_plx real NOT NULL, --/U  --/D Parallax [mas] (Gaia DR3)  
    zgr_e_plx real NOT NULL, --/U  --/D Error on parallax [mas] (Gaia DR3)  
    zgr_teff_confidence real NOT NULL, --/U  --/D Confidence estimate in TEFF  
    zgr_logg_confidence real NOT NULL, --/U  --/D Confidence estimate in LOGG  
    zgr_fe_h_confidence real NOT NULL, --/U  --/D Confidence estimate in FE_H  
    zgr_ln_prior real NOT NULL, --/U  --/D Log prior probability  
    zgr_chi2 real NOT NULL, --/U  --/D Chi-square value  
    zgr_quality_flags bigint NOT NULL, --/U  --/D Quality flags  
    r_med_geo real NOT NULL, --/U pc --/D Median geometric distance   
    r_lo_geo real NOT NULL, --/U pc --/D 16th percentile of geometric distance   
    r_hi_geo real NOT NULL, --/U pc --/D 84th percentile of geometric distance   
    r_med_photogeo real NOT NULL, --/U pc --/D 50th percentile of photogeometric distance   
    r_lo_photogeo real NOT NULL, --/U pc --/D 16th percentile of photogeometric distance   
    r_hi_photogeo real NOT NULL, --/U pc --/D 84th percentile of photogeometric distance   
    bailer_jones_flags varchar(10) NOT NULL, --/U  --/D Bailer-Jones quality flags  
    ebv real NOT NULL, --/U mag --/D E(B-V)   
    e_ebv real NOT NULL, --/U mag --/D Error on E(B-V)   
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V)  
    ebv_zhang_2023 real NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023)   
    e_ebv_zhang_2023 real NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023)   
    ebv_sfd real NOT NULL, --/U mag --/D E(B-V) from SFD   
    e_ebv_sfd real NOT NULL, --/U mag --/D Error on E(B-V) from SFD   
    ebv_rjce_glimpse real NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE   
    e_ebv_rjce_glimpse real NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V)   
    ebv_rjce_allwise real NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE   
    e_ebv_rjce_allwise real NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)  
    ebv_bayestar_2019 real NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019   
    e_ebv_bayestar_2019 real NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V)   
    ebv_edenhofer_2023 real NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023)   
    e_ebv_edenhofer_2023 real NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V)   
    c_star real NOT NULL, --/U  --/D Quality parameter (see Riello et al. 2021)  
    u_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC)   
    u_jkc_mag_flag int NOT NULL, --/U  --/D U-band (JKC) is within valid range  
    b_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC)   
    b_jkc_mag_flag int NOT NULL, --/U  --/D B-band (JKC) is within valid range  
    v_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC)   
    v_jkc_mag_flag int NOT NULL, --/U  --/D V-band (JKC) is within valid range  
    r_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC)   
    r_jkc_mag_flag int NOT NULL, --/U  --/D R-band (JKC) is within valid range  
    i_jkc_mag real NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC)   
    i_jkc_mag_flag int NOT NULL, --/U  --/D I-band (JKC) is within valid range  
    u_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS)   
    u_sdss_mag_flag int NOT NULL, --/U  --/D u-band (SDSS) is within valid range  
    g_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS)   
    g_sdss_mag_flag int NOT NULL, --/U  --/D g-band (SDSS) is within valid range  
    r_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS)   
    r_sdss_mag_flag int NOT NULL, --/U  --/D r-band (SDSS) is within valid range  
    i_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS)   
    i_sdss_mag_flag int NOT NULL, --/U  --/D i-band (SDSS) is within valid range  
    z_sdss_mag real NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS)   
    z_sdss_mag_flag int NOT NULL, --/U  --/D z-band (SDSS) is within valid range  
    y_ps1_mag real NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1)   
    y_ps1_mag_flag int NOT NULL, --/U  --/D Y-band (PS1) is within valid range  
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits  
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits  
    n_apogee_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    apogee_min_mjd int NOT NULL, --/U  --/D Minimum MJD of APOGEE visits  
    apogee_max_mjd int NOT NULL, --/U  --/D Maximum MJD of APOGEE visits  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'slam_boss_star')
	DROP TABLE slam_boss_star
GO
--
EXEC spSetDefaultFileGroup 'slam_boss_star'
GO
CREATE TABLE slam_boss_star (
--------------------------------------------------------------------------------
--/H Results from the Slam astra pipeline for each star
--
--/T Results from the Slam astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(17) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(7) NOT NULL, --/D SDSS file type that stores this spectrum
  v_astra varchar(5) NOT NULL, --/D Astra version
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  telescope varchar(6) NOT NULL, --/D Short telescope name
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_visits int NOT NULL, --/D Number of BOSS visits
  n_good_visits int NOT NULL, --/D Number of 'good' BOSS visits
  n_good_rvs int NOT NULL, --/D Number of 'good' BOSS radial velocities
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_meanrxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  nmf_rchi2 float NOT NULL, --/D Reduced chi-square value of NMF continuum fit
  nmf_flags bigint NOT NULL, --/D NMF Continuum method flags
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  fe_h_niu float NOT NULL, --/U dex --/D [Fe/H] calibrated from Niu et al. (2023)
  e_fe_h_niu float NOT NULL, --/U dex --/D Error on [Fe/H] calibrated from Niu et al. (202
  alpha_fe float NOT NULL, --/U dex --/D [alpha/fe] 
  e_alpha_fe float NOT NULL, --/U dex --/D Error on [alpha/fe] 
  initial_teff float NOT NULL, --/U K --/D Initial stellar effective temperature 
  initial_logg float NOT NULL, --/U log10(cm/s^2) --/D Initial surface gravity 
  initial_fe_h float NOT NULL, --/U dex --/D Initial [Fe/H] 
  initial_alpha_fe float NOT NULL, --/U dex --/D Initial [alpha/fe] 
  initial_fe_h_niu float NOT NULL, --/U dex --/D Initial [Fe/H] on Niu et al. (2023) scale 
  success bit NOT NULL, --/D Optimizer returned successful value
  status int NOT NULL, --/D Optimization status
  optimality bit NOT NULL, --/D Optimality condition
  result_flags bigint NOT NULL, --/D Flags describing the results
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
  chi2 float NOT NULL, --/D Chi-square value
  rchi2 float NOT NULL, --/D Reduced chi-square value
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'snow_white_boss_star')
	DROP TABLE snow_white_boss_star
GO
--
EXEC spSetDefaultFileGroup 'snow_white_boss_star'
GO
CREATE TABLE snow_white_boss_star (
--------------------------------------------------------------------------------
--/H Results from the SnowWhite astra pipeline for each star
--
--/T Results from the SnowWhite astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(15) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(7) NOT NULL, --/D SDSS file type that stores this spectrum
  v_astra varchar(5) NOT NULL, --/D Astra version
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  telescope varchar(6) NOT NULL, --/D Short telescope name
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_visits int NOT NULL, --/D Number of BOSS visits
  n_good_visits int NOT NULL, --/D Number of 'good' BOSS visits
  n_good_rvs int NOT NULL, --/D Number of 'good' BOSS radial velocities
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_meanrxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  nmf_rchi2 float NOT NULL, --/D Reduced chi-square value of NMF continuum fit
  nmf_flags bigint NOT NULL, --/D NMF Continuum method flags
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  classification varchar(15) NOT NULL, --/D Classification
  p_cv float NOT NULL, --/D Cataclysmic variable probability
  p_da float NOT NULL, --/D DA-type white dwarf probability
  p_dab float NOT NULL, --/D DAB-type white dwarf probability
  p_dabz float NOT NULL, --/D DABZ-type white dwarf probability
  p_dah float NOT NULL, --/D DA (H)-type white dwarf probability
  p_dahe float NOT NULL, --/D DA (He)-type white dwarf probability
  p_dao float NOT NULL, --/D DAO-type white dwarf probability
  p_daz float NOT NULL, --/D DAZ-type white dwarf probability
  p_da_ms float NOT NULL, --/D DA-MS binary probability
  p_db float NOT NULL, --/D DB-type white dwarf probability
  p_dba float NOT NULL, --/D DBA-type white dwarf probability
  p_dbaz float NOT NULL, --/D DBAZ-type white dwarf probability
  p_dbh float NOT NULL, --/D DB (H)-type white dwarf probability
  p_dbz float NOT NULL, --/D DBZ-type white dwarf probability
  p_db_ms float NOT NULL, --/D DB-MS binary probability
  p_dc float NOT NULL, --/D DC-type white dwarf probability
  p_dc_ms float NOT NULL, --/D DC-MS binary probability
  p_do float NOT NULL, --/D DO-type white dwarf probability
  p_dq float NOT NULL, --/D DQ-type white dwarf probability
  p_dqz float NOT NULL, --/D DQZ-type white dwarf probability
  p_dqpec float NOT NULL, --/D DQ Peculiar-type white dwarf probability
  p_dz float NOT NULL, --/D DZ-type white dwarf probability
  p_dza float NOT NULL, --/D DZA-type white dwarf probability
  p_dzb float NOT NULL, --/D DZB-type white dwarf probability
  p_dzba float NOT NULL, --/D DZBA-type white dwarf probability
  p_mwd float NOT NULL, --/D Main sequence star probability
  p_hotdq float NOT NULL, --/D Hot DQ-type white dwarf probability
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  v_rel float NOT NULL, --/D Relative velocity used in stellar parameter fit
  raw_e_teff float NOT NULL, --/U K --/D Raw error on stellar effective temperature 
  raw_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Raw error on surface gravity 
  result_flags bigint NOT NULL, --/D Result flags
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'snow_white_boss_visit')
	DROP TABLE snow_white_boss_visit
GO
--
EXEC spSetDefaultFileGroup 'snow_white_boss_visit'
GO
CREATE TABLE snow_white_boss_visit (
--------------------------------------------------------------------------------
--/H Results from the SnowWhite astra pipeline for each visit
--
--/T Results from the SnowWhite astra pipeline for each visit
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(15) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(8) NOT NULL, --/D SDSS file type that stores this spectrum
  run2d varchar(6) NOT NULL, --/D BOSS data reduction pipeline version
  mjd int NOT NULL, --/D Modified Julian date of observation
  fieldid int NOT NULL, --/D Field identifier
  n_exp int NOT NULL, --/D Number of co-added exposures
  exptime float NOT NULL, --/U s --/D Exposure time 
  plateid int NOT NULL, --/D Plate identifier
  cartid int NOT NULL, --/D Cartridge identifier
  mapid int NOT NULL, --/D Mapping version of the loaded plate
  slitid int NOT NULL, --/D Slit identifier
  psfsky int NOT NULL, --/D Order of PSF sky subtraction
  preject float NOT NULL, --/D Profile area rejection threshold
  n_std int NOT NULL, --/D Number of (good) standard stars
  n_gal int NOT NULL, --/D Number of (good) galaxies in field
  lowrej int NOT NULL, --/D Extraction: low rejection
  highrej int NOT NULL, --/D Extraction: high rejection
  scatpoly int NOT NULL, --/D Extraction: Order of scattered light polynomial
  proftype int NOT NULL, --/D Extraction profile: 1=Gaussian
  nfitpoly int NOT NULL, --/D Extraction: Number of profile parameters
  skychi2 float NOT NULL, --/D Mean \chi^2 of sky subtraction
  schi2min float NOT NULL, --/D Minimum \chi^2 of sky subtraction
  schi2max float NOT NULL, --/D Maximum \chi^2 of sky subtraction
  alt float NOT NULL, --/U deg --/D Telescope altitude 
  az float NOT NULL, --/U deg --/D Telescope azimuth 
  telescope varchar(6) NOT NULL, --/D Short telescope name
  seeing float NOT NULL, --/U arcsecond --/D Median seeing conditions 
  airmass float NOT NULL, --/D Mean airmass
  airtemp float NOT NULL, --/U C --/D Air temperature 
  dewpoint float NOT NULL, --/U C --/D Dew point temperature 
  humidity float NOT NULL, --/U % --/D Humidity 
  pressure float NOT NULL, --/U millibar --/D Air pressure 
  dust_a float NOT NULL, --/U particles m^-3 s^-1 --/D 0.3mu-sized dust count 
  dust_b float NOT NULL, --/U particles m^-3 s^-1 --/D 1.0mu-sized dust count 
  gust_direction float NOT NULL, --/U deg --/D Wind gust direction 
  gust_speed float NOT NULL, --/U km/s --/D Wind gust speed 
  wind_direction float NOT NULL, --/U deg --/D Wind direction 
  wind_speed float NOT NULL, --/U km/s --/D Wind speed 
  moon_dist_mean float NOT NULL, --/U deg --/D Mean sky distance to the moon 
  moon_phase_mean float NOT NULL, --/D Mean phase of the moon
  n_guide int NOT NULL, --/D Number of guider frames during integration
  tai_beg bigint NOT NULL, --/U s --/D MJD (TAI) at start of integrations 
  tai_end bigint NOT NULL, --/U s --/D MJD (TAI) at end of integrations 
  fiber_offset bit NOT NULL, --/D Position offset applied during observations
  f_night_time float NOT NULL, --/D Mid obs time as fraction from sunset to sunrise
  delta_ra_1 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 1 --/F delta_ra
  delta_ra_2 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 2 --/F delta_ra
  delta_ra_3 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 3 --/F delta_ra
  delta_ra_4 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 4 --/F delta_ra
  delta_ra_5 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 5 --/F delta_ra
  delta_ra_6 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 6 --/F delta_ra
  delta_ra_7 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 7 --/F delta_ra
  delta_ra_8 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 8 --/F delta_ra
  delta_ra_9 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 9 --/F delta_ra
  delta_ra_0 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 10 --/F delta_ra
  delta_ra_11 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 11 --/F delta_ra
  delta_ra_12 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 12 --/F delta_ra
  delta_ra_13 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 13 --/F delta_ra
  delta_ra_14 float NOT NULL, --/U arcsecond --/D Offset in right ascension, array element 14 --/F delta_ra
  delta_dec_1 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 1 --/F delta_dec
  delta_dec_2 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 2 --/F delta_dec
  delta_dec_3 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 3 --/F delta_dec
  delta_dec_4 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 4 --/F delta_dec
  delta_dec_5 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 5 --/F delta_dec
  delta_dec_6 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 6 --/F delta_dec
  delta_dec_7 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 7 --/F delta_dec
  delta_dec_8 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 8 --/F delta_dec
  delta_dec_9 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 9 --/F delta_dec
  delta_dec_10 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 10 --/F delta_dec
  delta_dec_11 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 11 --/F delta_dec
  delta_dec_12 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 12 --/F delta_dec
  delta_dec_13 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 13 --/F delta_dec
  delta_dec_14 float NOT NULL, --/U arcsecond --/D Offset in declination, array element 14 --/F delta_dec
  snr float NOT NULL, --/D Signal-to-noise ratio
  gri_gaia_transform_flags bigint NOT NULL, --/D Flags for provenance of ugriz photometry
  zwarning_flags bigint NOT NULL, --/D BOSS DRP warning flags
  xcsao_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcsao_e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  xcsao_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  xcsao_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  xcsao_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  xcsao_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  xcsao_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  xcsao_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  xcsao_rxc float NOT NULL, --/D Cross-correlation R-value (1979AJ.....84.1511T)
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  classification varchar(15) NOT NULL, --/D Classification
  p_cv float NOT NULL, --/D Cataclysmic variable probability
  p_da float NOT NULL, --/D DA-type white dwarf probability
  p_dab float NOT NULL, --/D DAB-type white dwarf probability
  p_dabz float NOT NULL, --/D DABZ-type white dwarf probability
  p_dah float NOT NULL, --/D DA (H)-type white dwarf probability
  p_dahe float NOT NULL, --/D DA (He)-type white dwarf probability
  p_dao float NOT NULL, --/D DAO-type white dwarf probability
  p_daz float NOT NULL, --/D DAZ-type white dwarf probability
  p_da_ms float NOT NULL, --/D DA-MS binary probability
  p_db float NOT NULL, --/D DB-type white dwarf probability
  p_dba float NOT NULL, --/D DBA-type white dwarf probability
  p_dbaz float NOT NULL, --/D DBAZ-type white dwarf probability
  p_dbh float NOT NULL, --/D DB (H)-type white dwarf probability
  p_dbz float NOT NULL, --/D DBZ-type white dwarf probability
  p_db_ms float NOT NULL, --/D DB-MS binary probability
  p_dc float NOT NULL, --/D DC-type white dwarf probability
  p_dc_ms float NOT NULL, --/D DC-MS binary probability
  p_do float NOT NULL, --/D DO-type white dwarf probability
  p_dq float NOT NULL, --/D DQ-type white dwarf probability
  p_dqz float NOT NULL, --/D DQZ-type white dwarf probability
  p_dqpec float NOT NULL, --/D DQ Peculiar-type white dwarf probability
  p_dz float NOT NULL, --/D DZ-type white dwarf probability
  p_dza float NOT NULL, --/D DZA-type white dwarf probability
  p_dzb float NOT NULL, --/D DZB-type white dwarf probability
  p_dzba float NOT NULL, --/D DZBA-type white dwarf probability
  p_mwd float NOT NULL, --/D Main sequence star probability
  p_hotdq float NOT NULL, --/D Hot DQ-type white dwarf probability
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  v_rel float NOT NULL, --/D Relative velocity used in stellar parameter fit
  raw_e_teff float NOT NULL, --/U K --/D Raw error on stellar effective temperature 
  raw_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Raw error on surface gravity 
  result_flags bigint NOT NULL, --/D Result flags
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'the_cannon_apogee_star')
	DROP TABLE the_cannon_apogee_star
GO
--
EXEC spSetDefaultFileGroup 'the_cannon_apogee_star'
GO
CREATE TABLE the_cannon_apogee_star (
--------------------------------------------------------------------------------
--/H Results from the TheCannon astra pipeline for each star
--
--/T Results from the TheCannon astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(15) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  source bigint NOT NULL, --/D Unique source primary key
  star_pk bigint NOT NULL, --/D APOGEE DRP `star` primary key
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  release varchar(4) NOT NULL, --/D SDSS release
  filetype varchar(6) NOT NULL, --/D SDSS file type that stores this spectrum
  apred varchar(4) NOT NULL, --/D APOGEE reduction pipeline
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  obj varchar(18) NOT NULL, --/D Object name
  telescope varchar(6) NOT NULL, --/D Short telescope name
  field varchar(18) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_entries int NOT NULL, --/D apStar entries for this SDSS4_APOGEE_ID
  n_visits int NOT NULL, --/D Number of APOGEE visits
  n_good_visits int NOT NULL, --/D Number of 'good' APOGEE visits
  n_good_rvs int NOT NULL, --/D Number of 'good' APOGEE radial velocities
  snr float NOT NULL, --/D Signal-to-noise ratio
  mean_fiber float NOT NULL, --/D S/N-weighted mean visit fiber number
  std_fiber float NOT NULL, --/D Standard deviation of visit fiber numbers
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D Unique source primary key
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  teff float NOT NULL, --/U K --/D Stellar effective temperature 
  e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  v_micro float NOT NULL, --/U km/s --/D Microturbulence 
  e_v_micro float NOT NULL, --/U km/s --/D Error on microturbulence 
  v_macro float NOT NULL, --/U km/s --/D Macroscopic broadening 
  e_v_macro float NOT NULL, --/U km/s --/D Error on macroscopic broadening 
  c_fe float NOT NULL, --/U dex --/D [C/Fe] abundance ratio
  e_c_fe float NOT NULL, --/U dex --/D Error on [C/Fe] abundance ratio
  n_fe float NOT NULL, --/U dex --/D [N/Fe] abundance ratio
  e_n_fe float NOT NULL, --/U dex --/D Error on [N/Fe] abundance ratio
  o_fe float NOT NULL, --/U dex --/D [O/Fe] abundance ratio
  e_o_fe float NOT NULL, --/U dex --/D Error on [O/Fe] abundance ratio
  na_fe float NOT NULL, --/U dex --/D [Na/Fe] abundance ratio
  e_na_fe float NOT NULL, --/U dex --/D Error on [Na/Fe] abundance ratio
  mg_fe float NOT NULL, --/U dex --/D [Mg/Fe] abundance ratio
  e_mg_fe float NOT NULL, --/U dex --/D Error on [Mg/Fe] abundance ratio
  al_fe float NOT NULL, --/U dex --/D [Al/Fe] abundance ratio
  e_al_fe float NOT NULL, --/U dex --/D Error on [Al/Fe] abundance ratio
  si_fe float NOT NULL, --/U dex --/D [Si/Fe] abundance ratio
  e_si_fe float NOT NULL, --/U dex --/D Error on [Si/Fe] abundance ratio
  s_fe float NOT NULL, --/U dex --/D [S/Fe] abundance ratio
  e_s_fe float NOT NULL, --/U dex --/D Error on [S/Fe] abundance ratio
  k_fe float NOT NULL, --/U dex --/D [K/Fe] abundance ratio
  e_k_fe float NOT NULL, --/U dex --/D Error on [K/Fe] abundance ratio
  ca_fe float NOT NULL, --/U dex --/D [Ca/Fe] abundance ratio
  e_ca_fe float NOT NULL, --/U dex --/D Error on [Ca/Fe] abundance ratio
  ti_fe float NOT NULL, --/U dex --/D [Ti/Fe] abundance ratio
  e_ti_fe float NOT NULL, --/U dex --/D Error on [Ti/Fe] abundance ratio
  v_fe float NOT NULL, --/U dex --/D [V/Fe] abundance ratio
  e_v_fe float NOT NULL, --/U dex --/D Error on [V/Fe] abundance ratio
  cr_fe float NOT NULL, --/U dex --/D [Cr/Fe] abundance ratio
  e_cr_fe float NOT NULL, --/U dex --/D Error on [Cr/Fe] abundance ratio
  mn_fe float NOT NULL, --/U dex --/D [Mn/Fe] abundance ratio
  e_mn_fe float NOT NULL, --/U dex --/D Error on [Mn/Fe] abundance ratio
  ni_fe float NOT NULL, --/U dex --/D [Ni/Fe] abundance ratio
  e_ni_fe float NOT NULL, --/U dex --/D Error on [Ni/Fe] abundance ratio
  chi2 float NOT NULL, --/D Chi-square value
  rchi2 float NOT NULL, --/D Reduced chi-square value
  raw_e_teff float NOT NULL, --/U K --/D Raw error on stellar effective temperature 
  raw_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Raw error on surface gravity 
  raw_e_fe_h float NOT NULL, --/U dex --/D Raw error on [Fe/H] 
  raw_e_v_micro float NOT NULL, --/U km/s --/D Raw error on microturbulence 
  raw_e_v_macro float NOT NULL, --/U km/s --/D Raw error on macroscopic broadening 
  raw_e_c_fe float NOT NULL, --/U dex --/D Raw error on [C/Fe] abundance ratio
  raw_e_n_fe float NOT NULL, --/U dex --/D Raw error on [N/Fe] abundance ratio
  raw_e_o_fe float NOT NULL, --/U dex --/D Raw error on [O/Fe] abundance ratio
  raw_e_na_fe float NOT NULL, --/U dex --/D Raw error on [Na/Fe] abundance ratio
  raw_e_mg_fe float NOT NULL, --/U dex --/D Raw error on [Mg/Fe] abundance ratio
  raw_e_al_fe float NOT NULL, --/U dex --/D Raw error on [Al/Fe] abundance ratio
  raw_e_si_fe float NOT NULL, --/U dex --/D Raw error on [Si/Fe] abundance ratio
  raw_e_s_fe float NOT NULL, --/U dex --/D Raw error on [S/Fe] abundance ratio
  raw_e_k_fe float NOT NULL, --/U dex --/D Raw error on [K/Fe] abundance ratio
  raw_e_ca_fe float NOT NULL, --/U dex --/D Raw error on [Ca/Fe] abundance ratio
  raw_e_ti_fe float NOT NULL, --/U dex --/D Raw error on [Ti/Fe] abundance ratio
  raw_e_v_fe float NOT NULL, --/U dex --/D Raw error on [V/Fe] abundance ratio
  raw_e_cr_fe float NOT NULL, --/U dex --/D Raw error on [Cr/Fe] abundance ratio
  raw_e_mn_fe float NOT NULL, --/U dex --/D Raw error on [Mn/Fe] abundance ratio
  raw_e_ni_fe float NOT NULL, --/U dex --/D Raw error on [Ni/Fe] abundance ratio
  ier int NOT NULL, --/D Returned state from optimizer
  nfev int NOT NULL, --/D Number of function evaluations
  x0_index int NOT NULL, --/D Index of initial guess used
  result_flags bigint NOT NULL, --/D Result flags
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'the_payne_apogee_star')
	DROP TABLE the_payne_apogee_star
GO
--
EXEC spSetDefaultFileGroup 'the_payne_apogee_star'
GO
CREATE TABLE the_payne_apogee_star (
--------------------------------------------------------------------------------
--/H Results from the ThePayne astra pipeline for each star
--
--/T Results from the ThePayne astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(19) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(26) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  source bigint NOT NULL, --/D Unique source primary key
  star_pk bigint NOT NULL, --/D APOGEE DRP `star` primary key
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(6) NOT NULL, --/D SDSS file type that stores this spectrum
  apred varchar(4) NOT NULL, --/D APOGEE reduction pipeline
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  obj varchar(19) NOT NULL, --/D Object name
  telescope varchar(6) NOT NULL, --/D Short telescope name
  field varchar(19) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  min_mjd int NOT NULL, --/D Minimum MJD of visits
  max_mjd int NOT NULL, --/D Maximum MJD of visits
  n_entries int NOT NULL, --/D apStar entries for this SDSS4_APOGEE_ID
  n_visits int NOT NULL, --/D Number of APOGEE visits
  n_good_visits int NOT NULL, --/D Number of 'good' APOGEE visits
  n_good_rvs int NOT NULL, --/D Number of 'good' APOGEE radial velocities
  snr float NOT NULL, --/D Signal-to-noise ratio
  mean_fiber float NOT NULL, --/D S/N-weighted mean visit fiber number
  std_fiber float NOT NULL, --/D Standard deviation of visit fiber numbers
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  e_v_rad float NOT NULL, --/U km/s --/D Error on radial velocity 
  std_v_rad float NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
  median_e_v_rad float NOT NULL, --/U km/s --/D Median error in radial velocity 
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  v_rel float NOT NULL, --/D 
  teff float NOT NULL, --/D 
  e_teff float NOT NULL, --/D 
  logg float NOT NULL, --/D 
  e_logg float NOT NULL, --/D 
  v_turb float NOT NULL, --/D 
  e_v_turb float NOT NULL, --/D 
  c_h float NOT NULL, --/D 
  e_c_h float NOT NULL, --/D 
  n_h float NOT NULL, --/D 
  e_n_h float NOT NULL, --/D 
  o_h float NOT NULL, --/D 
  e_o_h float NOT NULL, --/D 
  na_h float NOT NULL, --/D 
  e_na_h float NOT NULL, --/D 
  mg_h float NOT NULL, --/D 
  e_mg_h float NOT NULL, --/D 
  al_h float NOT NULL, --/D 
  e_al_h float NOT NULL, --/D 
  si_h float NOT NULL, --/D 
  e_si_h float NOT NULL, --/D 
  p_h float NOT NULL, --/D 
  e_p_h float NOT NULL, --/D 
  s_h float NOT NULL, --/D 
  e_s_h float NOT NULL, --/D 
  k_h float NOT NULL, --/D 
  e_k_h float NOT NULL, --/D 
  ca_h float NOT NULL, --/D 
  e_ca_h float NOT NULL, --/D 
  ti_h float NOT NULL, --/D 
  e_ti_h float NOT NULL, --/D 
  v_h float NOT NULL, --/D 
  e_v_h float NOT NULL, --/D 
  cr_h float NOT NULL, --/D 
  e_cr_h float NOT NULL, --/D 
  mn_h float NOT NULL, --/D 
  e_mn_h float NOT NULL, --/D 
  fe_h float NOT NULL, --/D 
  e_fe_h float NOT NULL, --/D 
  co_h float NOT NULL, --/D 
  e_co_h float NOT NULL, --/D 
  ni_h float NOT NULL, --/D 
  e_ni_h float NOT NULL, --/D 
  cu_h float NOT NULL, --/D 
  e_cu_h float NOT NULL, --/D 
  ge_h float NOT NULL, --/D 
  e_ge_h float NOT NULL, --/D 
  c12_c13 float NOT NULL, --/D 
  e_c12_c13 float NOT NULL, --/D 
  v_macro float NOT NULL, --/D 
  e_v_macro float NOT NULL, --/D 
  chi2 float NOT NULL, --/D 
  reduced_chi2 float NOT NULL, --/D 
  result_flags bigint NOT NULL, --/D 
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
  raw_e_teff float NOT NULL, --/D 
  raw_e_logg float NOT NULL, --/D 
  raw_e_v_turb float NOT NULL, --/D 
  raw_e_c_h float NOT NULL, --/D 
  raw_e_n_h float NOT NULL, --/D 
  raw_e_o_h float NOT NULL, --/D 
  raw_e_na_h float NOT NULL, --/D 
  raw_e_mg_h float NOT NULL, --/D 
  raw_e_al_h float NOT NULL, --/D 
  raw_e_si_h float NOT NULL, --/D 
  raw_e_p_h float NOT NULL, --/D 
  raw_e_s_h float NOT NULL, --/D 
  raw_e_k_h float NOT NULL, --/D 
  raw_e_ca_h float NOT NULL, --/D 
  raw_e_ti_h float NOT NULL, --/D 
  raw_e_v_h float NOT NULL, --/D 
  raw_e_cr_h float NOT NULL, --/D 
  raw_e_mn_h float NOT NULL, --/D 
  raw_e_fe_h float NOT NULL, --/D 
  raw_e_co_h float NOT NULL, --/D 
  raw_e_ni_h float NOT NULL, --/D 
  raw_e_cu_h float NOT NULL, --/D 
  raw_e_ge_h float NOT NULL, --/D 
  raw_e_c12_c13 float NOT NULL, --/D 
  raw_e_v_macro float NOT NULL, --/D 
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'the_payne_apogee_visit')
	DROP TABLE the_payne_apogee_visit
GO
--
EXEC spSetDefaultFileGroup 'the_payne_apogee_visit'
GO
CREATE TABLE the_payne_apogee_visit (
--------------------------------------------------------------------------------
--/H Results from the ThePayne astra pipeline for each visit
--
--/T Results from the ThePayne astra pipeline for each visit
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/D SDSS-5 unique identifier
  sdss4_apogee_id varchar(18) NOT NULL, --/D SDSS-4 DR17 APOGEE identifier
  gaia_dr2_source_id bigint NOT NULL, --/D Gaia DR2 source identifier
  gaia_dr3_source_id bigint NOT NULL, --/D Gaia DR3 source identifier
  tic_v8_id bigint NOT NULL, --/D TESS Input Catalog (v8) identifier
  healpix int NOT NULL, --/D HEALPix (128 side)
  lead varchar(18) NOT NULL, --/D Lead catalog used for cross-match
  version_id int NOT NULL, --/D SDSS catalog version for targeting
  catalogid bigint NOT NULL, --/D Catalog identifier used to target the source
  catalogid21 bigint NOT NULL, --/D Catalog identifier (v21; v0.0)
  catalogid25 bigint NOT NULL, --/D Catalog identifier (v25; v0.5)
  catalogid31 bigint NOT NULL, --/D Catalog identifier (v31; v1.0)
  n_associated int NOT NULL, --/D SDSS_IDs associated with this CATALOGID
  n_neighborhood int NOT NULL, --/D Sources within 3" and G_MAG < G_MAG_source + 5
  sdss4_apogee_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (1/2)
  sdss4_apogee_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE1 targeting flags (2/2)
  sdss4_apogee2_target1_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (1/3)
  sdss4_apogee2_target2_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (2/3)
  sdss4_apogee2_target3_flags bigint NOT NULL, --/D SDSS4 APOGEE2 targeting flags (3/3)
  sdss4_apogee_member_flags bigint NOT NULL, --/D SDSS4 likely cluster/galaxy member flags
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/D SDSS4 target info (aka EXTRATARG)
  ra float NOT NULL, --/U deg --/D Right ascension 
  dec float NOT NULL, --/U deg --/D Declination 
  l float NOT NULL, --/U deg --/D Galactic longitude 
  b float NOT NULL, --/U deg --/D Galactic latitude 
  plx float NOT NULL, --/U mas --/D Parallax 
  e_plx float NOT NULL, --/U mas --/D Error on parallax 
  pmra float NOT NULL, --/U mas/yr --/D Proper motion in RA 
  e_pmra float NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
  pmde float NOT NULL, --/U mas/yr --/D Proper motion in DEC 
  e_pmde float NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
  gaia_v_rad float NOT NULL, --/U km/s --/D Gaia radial velocity 
  gaia_e_v_rad float NOT NULL, --/U km/s --/D Error on Gaia radial velocity 
  g_mag float NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
  bp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
  rp_mag float NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
  j_mag float NOT NULL, --/U mag --/D 2MASS J band magnitude 
  e_j_mag float NOT NULL, --/U mag --/D Error on 2MASS J band magnitude 
  h_mag float NOT NULL, --/U mag --/D 2MASS H band magnitude 
  e_h_mag float NOT NULL, --/U mag --/D Error on 2MASS H band magnitude 
  k_mag float NOT NULL, --/U mag --/D 2MASS K band magnitude 
  e_k_mag float NOT NULL, --/U mag --/D Error on 2MASS K band magnitude 
  ph_qual varchar(3) NOT NULL, --/D 2MASS photometric quality flag
  bl_flg varchar(3) NOT NULL, --/D Number of components fit per band (JHK)
  cc_flg varchar(3) NOT NULL, --/D Contamination and confusion flag
  w1_mag float NOT NULL, --/D W1 magnitude
  e_w1_mag float NOT NULL, --/D Error on W1 magnitude
  w1_flux float NOT NULL, --/U Vega nMgy --/D W1 flux 
  w1_dflux float NOT NULL, --/U Vega nMgy --/D Error on W1 flux 
  w1_frac float NOT NULL, --/D Fraction of W1 flux from this object
  w2_mag float NOT NULL, --/U Vega --/D W2 magnitude 
  e_w2_mag float NOT NULL, --/D Error on W2 magnitude
  w2_flux float NOT NULL, --/U Vega nMgy --/D W2 flux 
  w2_dflux float NOT NULL, --/U Vega nMgy --/D Error on W2 flux 
  w2_frac float NOT NULL, --/D Fraction of W2 flux from this object
  w1uflags bigint NOT NULL, --/D unWISE flags for W1
  w2uflags bigint NOT NULL, --/D unWISE flags for W2
  w1aflags bigint NOT NULL, --/D Additional flags for W1
  w2aflags bigint NOT NULL, --/D Additional flags for W2
  mag4_5 float NOT NULL, --/U mag --/D IRAC band 4.5 micron magnitude 
  d4_5m float NOT NULL, --/U mag --/D Error on IRAC band 4.5 micron magnitude 
  rms_f4_5 float NOT NULL, --/U mJy --/D RMS deviations from final flux 
  sqf_4_5 bigint NOT NULL, --/D Source quality flag for IRAC band 4.5 micron
  mf4_5 bigint NOT NULL, --/D Flux calculation method flag
  csf bigint NOT NULL, --/D Close source flag
  zgr_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  zgr_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  zgr_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  zgr_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  zgr_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  zgr_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  zgr_e float NOT NULL, --/U mag --/D Extinction 
  zgr_e_e float NOT NULL, --/U mag --/D Error on extinction 
  zgr_plx float NOT NULL, --/U mas --/D Parallax [mas] (Gaia
  zgr_e_plx float NOT NULL, --/U mas --/D Error on parallax [mas] (Gaia
  zgr_teff_confidence float NOT NULL, --/D Confidence estimate in TEFF
  zgr_logg_confidence float NOT NULL, --/D Confidence estimate in LOGG
  zgr_fe_h_confidence float NOT NULL, --/D Confidence estimate in FE_H
  zgr_ln_prior float NOT NULL, --/D Log prior probability
  zgr_chi2 float NOT NULL, --/D Chi-square value
  zgr_quality_flags bigint NOT NULL, --/D Quality flags
  r_med_geo float NOT NULL, --/U pc --/D Median geometric distance 
  r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance 
  r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance 
  r_med_photogeo float NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
  r_lo_photogeo float NOT NULL, --/U pc --/D 16th percentile of photogeometric distance 
  r_hi_photogeo float NOT NULL, --/U pc --/D 84th percentile of photogeometric distance 
  bailer_jones_flags varchar(5) NOT NULL, --/D Bailer-Jones quality flags
  ebv float NOT NULL, --/U mag --/D E(B-V) 
  e_ebv float NOT NULL, --/U mag --/D Error on E(B-V) 
  ebv_flags bigint NOT NULL, --/D Flags indicating the source of E(B-V)
  ebv_zhang_2023 float NOT NULL, --/U mag --/D E(B-V) from Zhang et al. (2023) 
  e_ebv_zhang_2023 float NOT NULL, --/U mag --/D Error on E(B-V) from Zhang et al. (2023) 
  ebv_sfd float NOT NULL, --/U mag --/D E(B-V) from SFD 
  e_ebv_sfd float NOT NULL, --/U mag --/D Error on E(B-V) from SFD 
  ebv_rjce_glimpse float NOT NULL, --/U mag --/D E(B-V) from RJCE GLIMPSE 
  e_ebv_rjce_glimpse float NOT NULL, --/U mag --/D Error on RJCE GLIMPSE E(B-V) 
  ebv_rjce_allwise float NOT NULL, --/U mag --/D E(B-V) from RJCE AllWISE 
  e_ebv_rjce_allwise float NOT NULL, --/U mag --/D Error on RJCE AllWISE E(B-V)
  ebv_bayestar_2019 float NOT NULL, --/U mag --/D E(B-V) from Bayestar 2019 
  e_ebv_bayestar_2019 float NOT NULL, --/U mag --/D Error on Bayestar 2019 E(B-V) 
  ebv_edenhofer_2023 float NOT NULL, --/U mag --/D E(B-V) from Edenhofer et al. (2023) 
  e_ebv_edenhofer_2023 float NOT NULL, --/U mag --/D Error on Edenhofer et al. (2023) E(B-V) 
  c_star float NOT NULL, --/D Quality parameter (see Riello et al. 2021)
  u_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic U-band (JKC) 
  u_jkc_mag_flag int NOT NULL, --/D U-band (JKC) is within valid range
  b_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic B-band (JKC) 
  b_jkc_mag_flag int NOT NULL, --/D B-band (JKC) is within valid range
  v_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic V-band (JKC) 
  v_jkc_mag_flag int NOT NULL, --/D V-band (JKC) is within valid range
  r_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic R-band (JKC) 
  r_jkc_mag_flag int NOT NULL, --/D R-band (JKC) is within valid range
  i_jkc_mag float NOT NULL, --/U mag --/D Gaia XP synthetic I-band (JKC) 
  i_jkc_mag_flag int NOT NULL, --/D I-band (JKC) is within valid range
  u_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic u-band (SDSS) 
  u_sdss_mag_flag int NOT NULL, --/D u-band (SDSS) is within valid range
  g_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic g-band (SDSS) 
  g_sdss_mag_flag int NOT NULL, --/D g-band (SDSS) is within valid range
  r_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic r-band (SDSS) 
  r_sdss_mag_flag int NOT NULL, --/D r-band (SDSS) is within valid range
  i_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic i-band (SDSS) 
  i_sdss_mag_flag int NOT NULL, --/D i-band (SDSS) is within valid range
  z_sdss_mag float NOT NULL, --/U mag --/D Gaia XP synthetic z-band (SDSS) 
  z_sdss_mag_flag int NOT NULL, --/D z-band (SDSS) is within valid range
  y_ps1_mag float NOT NULL, --/U mag --/D Gaia XP synthetic Y-band (PS1) 
  y_ps1_mag_flag int NOT NULL, --/D Y-band (PS1) is within valid range
  n_boss_visits int NOT NULL, --/D Number of BOSS visits
  boss_min_mjd int NOT NULL, --/D Minimum MJD of BOSS visits
  boss_max_mjd int NOT NULL, --/D Maximum MJD of BOSS visits
  n_apogee_visits int NOT NULL, --/D Number of APOGEE visits
  apogee_min_mjd int NOT NULL, --/D Minimum MJD of APOGEE visits
  apogee_max_mjd int NOT NULL, --/D Maximum MJD of APOGEE visits
  spectrum_pk bigint NOT NULL, --/D Unique spectrum primary key
  source bigint NOT NULL, --/D Unique source primary key
  star_pk bigint NOT NULL, --/D APOGEE DRP `star` primary key
  visit_pk bigint NOT NULL, --/D APOGEE DRP `visit` primary key
  rv_visit_pk bigint NOT NULL, --/D APOGEE DRP `rv_visit` primary key
  release varchar(5) NOT NULL, --/D SDSS release
  filetype varchar(7) NOT NULL, --/D SDSS file type that stores this spectrum
  apred varchar(3) NOT NULL, --/D APOGEE reduction pipeline
  plate varchar(5) NOT NULL, --/D Plate identifier
  telescope varchar(6) NOT NULL, --/D Short telescope name
  fiber int NOT NULL, --/D Fiber number
  mjd int NOT NULL, --/D Modified Julian date of observation
  field varchar(22) NOT NULL, --/D Field identifier
  prefix varchar(2) NOT NULL, --/D Prefix used to separate SDSS 4 north/south
  reduction varchar(1) NOT NULL, --/D An `obj`-like keyword used for apo1m spectra
  obj varchar(18) NOT NULL, --/D Object name
  date_obs varchar(26) NOT NULL, --/D Observation date (UTC)
  jd float NOT NULL, --/D Julian date at mid-point of visit
  exptime float NOT NULL, --/U s --/D Exposure time 
  dithered bit NOT NULL, --/D Fraction of visits that were dithered
  f_night_time float NOT NULL, --/D Mid obs time as fraction from sunset to sunrise
  input_ra float NOT NULL, --/U deg --/D Input right ascension 
  input_dec float NOT NULL, --/U deg --/D Input declination 
  n_frames int NOT NULL, --/D Number of frames combined
  assigned int NOT NULL, --/D FPS target assigned
  on_target int NOT NULL, --/D FPS fiber on target
  valid int NOT NULL, --/D Valid FPS target
  fps bit NOT NULL, --/D Fibre positioner used to acquire this data?
  snr float NOT NULL, --/D Signal-to-noise ratio
  spectrum_flags bigint NOT NULL, --/D Data reduction pipeline flags for this spectrum
  v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  bc float NOT NULL, --/U km/s --/D Barycentric velocity correction applied 
  doppler_teff float NOT NULL, --/U K --/D Stellar effective temperature 
  doppler_e_teff float NOT NULL, --/U K --/D Error on stellar effective temperature 
  doppler_logg float NOT NULL, --/U log10(cm/s^2) --/D Surface gravity 
  doppler_e_logg float NOT NULL, --/U log10(cm/s^2) --/D Error on surface gravity 
  doppler_fe_h float NOT NULL, --/U dex --/D [Fe/H] 
  doppler_e_fe_h float NOT NULL, --/U dex --/D Error on [Fe/H] 
  doppler_rchi2 float NOT NULL, --/D Reduced chi-square value of DOPPLER fit
  doppler_flags bigint NOT NULL, --/D DOPPLER flags
  xcorr_v_rad float NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
  xcorr_v_rel float NOT NULL, --/U km/s --/D Relative velocity 
  xcorr_e_v_rel float NOT NULL, --/U km/s --/D Error on relative velocity 
  ccfwhm float NOT NULL, --/D Cross-correlation function FWHM
  autofwhm float NOT NULL, --/D Auto-correlation function FWHM
  n_components int NOT NULL, --/D Number of components in CCF
  drp_spectrum_pk bigint NOT NULL, --/D Data Reduction Pipeline spectrum primary key
  apstar varchar(5) NOT NULL, --/D Unused DR17 apStar keyword (default: stars)
  task_pk bigint NOT NULL, --/D Task model primary key
  source_pk bigint NOT NULL, --/D 
  v_astra varchar(5) NOT NULL, --/D Astra version
  created varchar(26) NOT NULL, --/D Datetime when task record was created
  t_elapsed float NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead float NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/D Experiment tag for this result
  teff float NOT NULL, --/D 
  e_teff float NOT NULL, --/D 
  logg float NOT NULL, --/D 
  e_logg float NOT NULL, --/D 
  v_turb float NOT NULL, --/D 
  e_v_turb float NOT NULL, --/D 
  c_h float NOT NULL, --/D 
  e_c_h float NOT NULL, --/D 
  n_h float NOT NULL, --/D 
  e_n_h float NOT NULL, --/D 
  o_h float NOT NULL, --/D 
  e_o_h float NOT NULL, --/D 
  na_h float NOT NULL, --/D 
  e_na_h float NOT NULL, --/D 
  mg_h float NOT NULL, --/D 
  e_mg_h float NOT NULL, --/D 
  al_h float NOT NULL, --/D 
  e_al_h float NOT NULL, --/D 
  si_h float NOT NULL, --/D 
  e_si_h float NOT NULL, --/D 
  p_h float NOT NULL, --/D 
  e_p_h float NOT NULL, --/D 
  s_h float NOT NULL, --/D 
  e_s_h float NOT NULL, --/D 
  k_h float NOT NULL, --/D 
  e_k_h float NOT NULL, --/D 
  ca_h float NOT NULL, --/D 
  e_ca_h float NOT NULL, --/D 
  ti_h float NOT NULL, --/D 
  e_ti_h float NOT NULL, --/D 
  v_h float NOT NULL, --/D 
  e_v_h float NOT NULL, --/D 
  cr_h float NOT NULL, --/D 
  e_cr_h float NOT NULL, --/D 
  mn_h float NOT NULL, --/D 
  e_mn_h float NOT NULL, --/D 
  fe_h float NOT NULL, --/D 
  e_fe_h float NOT NULL, --/D 
  co_h float NOT NULL, --/D 
  e_co_h float NOT NULL, --/D 
  ni_h float NOT NULL, --/D 
  e_ni_h float NOT NULL, --/D 
  cu_h float NOT NULL, --/D 
  e_cu_h float NOT NULL, --/D 
  ge_h float NOT NULL, --/D 
  e_ge_h float NOT NULL, --/D 
  c12_c13 float NOT NULL, --/D 
  e_c12_c13 float NOT NULL, --/D 
  v_macro float NOT NULL, --/D 
  e_v_macro float NOT NULL, --/D 
  chi2 float NOT NULL, --/D 
  reduced_chi2 float NOT NULL, --/D 
  result_flags bigint NOT NULL, --/D 
  flag_warn bit NOT NULL, --/D Warning flag for results
  flag_bad bit NOT NULL, --/D Bad flag for results
  raw_e_teff float NOT NULL, --/D 
  raw_e_logg float NOT NULL, --/D 
  raw_e_v_turb float NOT NULL, --/D 
  raw_e_c_h float NOT NULL, --/D 
  raw_e_n_h float NOT NULL, --/D 
  raw_e_o_h float NOT NULL, --/D 
  raw_e_na_h float NOT NULL, --/D 
  raw_e_mg_h float NOT NULL, --/D 
  raw_e_al_h float NOT NULL, --/D 
  raw_e_si_h float NOT NULL, --/D 
  raw_e_p_h float NOT NULL, --/D 
  raw_e_s_h float NOT NULL, --/D 
  raw_e_k_h float NOT NULL, --/D 
  raw_e_ca_h float NOT NULL, --/D 
  raw_e_ti_h float NOT NULL, --/D 
  raw_e_v_h float NOT NULL, --/D 
  raw_e_cr_h float NOT NULL, --/D 
  raw_e_mn_h float NOT NULL, --/D 
  raw_e_fe_h float NOT NULL, --/D 
  raw_e_co_h float NOT NULL, --/D 
  raw_e_ni_h float NOT NULL, --/D 
  raw_e_cu_h float NOT NULL, --/D 
  raw_e_ge_h float NOT NULL, --/D 
  raw_e_c12_c13 float NOT NULL, --/D 
  raw_e_v_macro float NOT NULL, --/D 
)
GO

--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[AstraTables.sql]: Astra tables created'
GO
