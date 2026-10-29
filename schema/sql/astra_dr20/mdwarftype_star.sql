--// Created from HDU 1 in /uufs/chpc.utah.edu/common/home/sdss/dr20/spectro/astra/0.8.1/summary/astraAllStarMDwarfType-0.8.1.fits.gz
CREATE TABLE m_dwarf_type_boss_star (
--------------------------------------------------------------------------------
--/H Results from the MDwarfType astra pipeline for each star
--
--/T Results from the MDwarfType astra pipeline for each star
--------------------------------------------------------------------------------
  sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier 
  sdss4_apogee_id varchar(18) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier 
  gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier 
  gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier 
  tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier 
  healpix int NOT NULL, --/U  --/D HEALPix (128 side) 
  lead varchar(26) NOT NULL, --/U  --/D Lead catalog used for cross-match 
  version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting 
  catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source 
  catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0) 
  catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5) 
  catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0) 
  n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID 
  n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5 
  crossmatch_flags bigint NOT NULL, --/U  --/D Astra internal crossmatch flag system 
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
  ph_qual varchar(3) NOT NULL, --/U  --/D 2MASS photometric quality flag 
  bl_flg varchar(3) NOT NULL, --/U  --/D Number of components fit per band (JHK) 
  cc_flg varchar(3) NOT NULL, --/U  --/D Contamination and confusion flag 
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
  bailer_jones_flags varchar(5) NOT NULL, --/U  --/D Bailer-Jones quality flags 
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
  created varchar(26) NOT NULL, --/U  --/D Datetime when task record was created 
  modified varchar(26) NOT NULL, --/U Datetime when task record was modified --/D modified 
  spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key 
  source bigint NOT NULL, --/U  --/D Unique source primary key 
  release varchar(5) NOT NULL, --/U  --/D SDSS release 
  filetype varchar(7) NOT NULL, --/U  --/D SDSS file type that stores this spectrum 
  v_astra varchar(5) NOT NULL, --/U  --/D Astra version 
  run2d varchar(6) NOT NULL, --/U  --/D BOSS data reduction pipeline version 
  telescope varchar(6) NOT NULL, --/U  --/D Short telescope name 
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
  task_pk bigint NOT NULL, --/U  --/D Task model primary key 
  spectral_type varchar(4) NOT NULL, --/U  --/D Spectral type 
  sub_type real NOT NULL, --/U  --/D Spectral sub-type 
  rchi2 real NOT NULL, --/U  --/D Reduced chi-square value 
  continuum real NOT NULL, --/U  --/D Scalar continuum value used 
  result_flags bigint NOT NULL, --/U  --/D Flags describing the results 
  flag_bad bit NOT NULL, --/U  --/D Bad flag for results 
  source_pk bigint NOT NULL, --/U  --/D Unique source primary key 
  t_elapsed real NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead real NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/U  --/D Experiment tag for this result 
);
