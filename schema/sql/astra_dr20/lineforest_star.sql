--// Created from HDU 1 in /uufs/chpc.utah.edu/common/home/sdss/dr20/spectro/astra/0.8.1/summary/astraAllStarLineForest-0.8.1.fits.gz
CREATE TABLE line_forest_boss_star (
--------------------------------------------------------------------------------
--/H Results from the LineForest astra pipeline for each star
--
--/T Results from the LineForest astra pipeline for each star
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
  crossmatch_flags bigint NOT NULL, --/U  --/D crossmatch_flags 
  sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2) 
  sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2) 
  sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3) 
  sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3) 
  sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3) 
  sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags 
  sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG) 
  sdss5_dr19_apogee_flag bit NOT NULL, --/U  --/D sdss5_dr19_apogee_flag 
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
  modified varchar(26) NOT NULL, --/U  --/D modified 
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
  eqw_h_alpha real NOT NULL, --/U A --/D Equivalent width of H-alpha 
  abs_h_alpha real NOT NULL, --/U  --/D abs_h_alpha 
  detection_stat_h_alpha real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: u 
  detection_raw_h_alpha real NOT NULL, --/U  --/D Probability that feature is not noise (0: no 
  eqw_percentiles_h_alpha_1 real NOT NULL, --/F eqw_percentiles_h_alpha 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_alpha_2 real NOT NULL, --/F eqw_percentiles_h_alpha 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_alpha_3 real NOT NULL, --/F eqw_percentiles_h_alpha 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_alpha_1 real NOT NULL, --/F abs_percentiles_h_alpha 0 --/U  --/D abs_percentiles_h_alpha (array element 1) 
  abs_percentiles_h_alpha_2 real NOT NULL, --/F abs_percentiles_h_alpha 1 --/U  --/D abs_percentiles_h_alpha (array element 2) 
  abs_percentiles_h_alpha_3 real NOT NULL, --/F abs_percentiles_h_alpha 2 --/U  --/D abs_percentiles_h_alpha (array element 3) 
  eqw_h_beta real NOT NULL, --/U A --/D Equivalent width of H-beta 
  abs_h_beta real NOT NULL, --/U  --/D abs_h_beta 
  detection_stat_h_beta real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: un 
  detection_raw_h_beta real NOT NULL, --/U  --/D Probability that feature is not noise (0: noi 
  eqw_percentiles_h_beta_1 real NOT NULL, --/F eqw_percentiles_h_beta 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_beta_2 real NOT NULL, --/F eqw_percentiles_h_beta 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_beta_3 real NOT NULL, --/F eqw_percentiles_h_beta 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_beta_1 real NOT NULL, --/F abs_percentiles_h_beta 0 --/U  --/D abs_percentiles_h_beta (array element 1) 
  abs_percentiles_h_beta_2 real NOT NULL, --/F abs_percentiles_h_beta 1 --/U  --/D abs_percentiles_h_beta (array element 2) 
  abs_percentiles_h_beta_3 real NOT NULL, --/F abs_percentiles_h_beta 2 --/U  --/D abs_percentiles_h_beta (array element 3) 
  eqw_h_gamma real NOT NULL, --/U A --/D Equivalent width of H-gamma 
  abs_h_gamma real NOT NULL, --/U  --/D abs_h_gamma 
  detection_stat_h_gamma real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: u 
  detection_raw_h_gamma real NOT NULL, --/U  --/D Probability that feature is not noise (0: no 
  eqw_percentiles_h_gamma_1 real NOT NULL, --/F eqw_percentiles_h_gamma 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_gamma_2 real NOT NULL, --/F eqw_percentiles_h_gamma 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_gamma_3 real NOT NULL, --/F eqw_percentiles_h_gamma 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_gamma_1 real NOT NULL, --/F abs_percentiles_h_gamma 0 --/U  --/D abs_percentiles_h_gamma (array element 1) 
  abs_percentiles_h_gamma_2 real NOT NULL, --/F abs_percentiles_h_gamma 1 --/U  --/D abs_percentiles_h_gamma (array element 2) 
  abs_percentiles_h_gamma_3 real NOT NULL, --/F abs_percentiles_h_gamma 2 --/U  --/D abs_percentiles_h_gamma (array element 3) 
  eqw_h_delta real NOT NULL, --/U A --/D Equivalent width of H-delta 
  abs_h_delta real NOT NULL, --/U  --/D abs_h_delta 
  detection_stat_h_delta real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: u 
  detection_raw_h_delta real NOT NULL, --/U  --/D Probability that feature is not noise (0: no 
  eqw_percentiles_h_delta_1 real NOT NULL, --/F eqw_percentiles_h_delta 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_delta_2 real NOT NULL, --/F eqw_percentiles_h_delta 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_delta_3 real NOT NULL, --/F eqw_percentiles_h_delta 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_delta_1 real NOT NULL, --/F abs_percentiles_h_delta 0 --/U  --/D abs_percentiles_h_delta (array element 1) 
  abs_percentiles_h_delta_2 real NOT NULL, --/F abs_percentiles_h_delta 1 --/U  --/D abs_percentiles_h_delta (array element 2) 
  abs_percentiles_h_delta_3 real NOT NULL, --/F abs_percentiles_h_delta 2 --/U  --/D abs_percentiles_h_delta (array element 3) 
  eqw_h_epsilon real NOT NULL, --/U A --/D Equivalent width of H-epsilon 
  abs_h_epsilon real NOT NULL, --/U  --/D abs_h_epsilon 
  detection_stat_h_epsilon real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_h_epsilon real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_h_epsilon_1 real NOT NULL, --/F eqw_percentiles_h_epsilon 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_epsilon_2 real NOT NULL, --/F eqw_percentiles_h_epsilon 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_epsilon_3 real NOT NULL, --/F eqw_percentiles_h_epsilon 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_epsilon_1 real NOT NULL, --/F abs_percentiles_h_epsilon 0 --/U  --/D abs_percentiles_h_epsilon (array element 1) 
  abs_percentiles_h_epsilon_2 real NOT NULL, --/F abs_percentiles_h_epsilon 1 --/U  --/D abs_percentiles_h_epsilon (array element 2) 
  abs_percentiles_h_epsilon_3 real NOT NULL, --/F abs_percentiles_h_epsilon 2 --/U  --/D abs_percentiles_h_epsilon (array element 3) 
  eqw_h_8 real NOT NULL, --/U A --/D Equivalent width of H-8 
  abs_h_8 real NOT NULL, --/U  --/D abs_h_8 
  detection_stat_h_8 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: undet 
  detection_raw_h_8 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_8_1 real NOT NULL, --/F eqw_percentiles_h_8 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_8_2 real NOT NULL, --/F eqw_percentiles_h_8 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_8_3 real NOT NULL, --/F eqw_percentiles_h_8 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_8_1 real NOT NULL, --/F abs_percentiles_h_8 0 --/U  --/D abs_percentiles_h_8 (array element 1) 
  abs_percentiles_h_8_2 real NOT NULL, --/F abs_percentiles_h_8 1 --/U  --/D abs_percentiles_h_8 (array element 2) 
  abs_percentiles_h_8_3 real NOT NULL, --/F abs_percentiles_h_8 2 --/U  --/D abs_percentiles_h_8 (array element 3) 
  eqw_h_9 real NOT NULL, --/U A --/D Equivalent width of H-9 
  abs_h_9 real NOT NULL, --/U  --/D abs_h_9 
  detection_stat_h_9 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: undet 
  detection_raw_h_9 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_9_1 real NOT NULL, --/F eqw_percentiles_h_9 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_9_2 real NOT NULL, --/F eqw_percentiles_h_9 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_9_3 real NOT NULL, --/F eqw_percentiles_h_9 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_9_1 real NOT NULL, --/F abs_percentiles_h_9 0 --/U  --/D abs_percentiles_h_9 (array element 1) 
  abs_percentiles_h_9_2 real NOT NULL, --/F abs_percentiles_h_9 1 --/U  --/D abs_percentiles_h_9 (array element 2) 
  abs_percentiles_h_9_3 real NOT NULL, --/F abs_percentiles_h_9 2 --/U  --/D abs_percentiles_h_9 (array element 3) 
  eqw_h_10 real NOT NULL, --/U A --/D Equivalent width of H-10 
  abs_h_10 real NOT NULL, --/U  --/D abs_h_10 
  detection_stat_h_10 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_h_10 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_10_1 real NOT NULL, --/F eqw_percentiles_h_10 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_10_2 real NOT NULL, --/F eqw_percentiles_h_10 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_10_3 real NOT NULL, --/F eqw_percentiles_h_10 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_10_1 real NOT NULL, --/F abs_percentiles_h_10 0 --/U  --/D abs_percentiles_h_10 (array element 1) 
  abs_percentiles_h_10_2 real NOT NULL, --/F abs_percentiles_h_10 1 --/U  --/D abs_percentiles_h_10 (array element 2) 
  abs_percentiles_h_10_3 real NOT NULL, --/F abs_percentiles_h_10 2 --/U  --/D abs_percentiles_h_10 (array element 3) 
  eqw_h_11 real NOT NULL, --/U A --/D Equivalent width of H-11 
  abs_h_11 real NOT NULL, --/U  --/D abs_h_11 
  detection_stat_h_11 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_h_11 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_11_1 real NOT NULL, --/F eqw_percentiles_h_11 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_11_2 real NOT NULL, --/F eqw_percentiles_h_11 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_11_3 real NOT NULL, --/F eqw_percentiles_h_11 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_11_1 real NOT NULL, --/F abs_percentiles_h_11 0 --/U  --/D abs_percentiles_h_11 (array element 1) 
  abs_percentiles_h_11_2 real NOT NULL, --/F abs_percentiles_h_11 1 --/U  --/D abs_percentiles_h_11 (array element 2) 
  abs_percentiles_h_11_3 real NOT NULL, --/F abs_percentiles_h_11 2 --/U  --/D abs_percentiles_h_11 (array element 3) 
  eqw_h_12 real NOT NULL, --/U A --/D Equivalent width of H-12 
  abs_h_12 real NOT NULL, --/U  --/D abs_h_12 
  detection_stat_h_12 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_h_12 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_12_1 real NOT NULL, --/F eqw_percentiles_h_12 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_12_2 real NOT NULL, --/F eqw_percentiles_h_12 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_12_3 real NOT NULL, --/F eqw_percentiles_h_12 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_12_1 real NOT NULL, --/F abs_percentiles_h_12 0 --/U  --/D abs_percentiles_h_12 (array element 1) 
  abs_percentiles_h_12_2 real NOT NULL, --/F abs_percentiles_h_12 1 --/U  --/D abs_percentiles_h_12 (array element 2) 
  abs_percentiles_h_12_3 real NOT NULL, --/F abs_percentiles_h_12 2 --/U  --/D abs_percentiles_h_12 (array element 3) 
  eqw_h_13 real NOT NULL, --/U A --/D Equivalent width of H-13 
  abs_h_13 real NOT NULL, --/U  --/D abs_h_13 
  detection_stat_h_13 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_h_13 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_13_1 real NOT NULL, --/F eqw_percentiles_h_13 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_13_2 real NOT NULL, --/F eqw_percentiles_h_13 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_13_3 real NOT NULL, --/F eqw_percentiles_h_13 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_13_1 real NOT NULL, --/F abs_percentiles_h_13 0 --/U  --/D abs_percentiles_h_13 (array element 1) 
  abs_percentiles_h_13_2 real NOT NULL, --/F abs_percentiles_h_13 1 --/U  --/D abs_percentiles_h_13 (array element 2) 
  abs_percentiles_h_13_3 real NOT NULL, --/F abs_percentiles_h_13 2 --/U  --/D abs_percentiles_h_13 (array element 3) 
  eqw_h_14 real NOT NULL, --/U A --/D Equivalent width of H-14 
  abs_h_14 real NOT NULL, --/U  --/D abs_h_14 
  detection_stat_h_14 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_h_14 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_14_1 real NOT NULL, --/F eqw_percentiles_h_14 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_14_2 real NOT NULL, --/F eqw_percentiles_h_14 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_14_3 real NOT NULL, --/F eqw_percentiles_h_14 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_14_1 real NOT NULL, --/F abs_percentiles_h_14 0 --/U  --/D abs_percentiles_h_14 (array element 1) 
  abs_percentiles_h_14_2 real NOT NULL, --/F abs_percentiles_h_14 1 --/U  --/D abs_percentiles_h_14 (array element 2) 
  abs_percentiles_h_14_3 real NOT NULL, --/F abs_percentiles_h_14 2 --/U  --/D abs_percentiles_h_14 (array element 3) 
  eqw_h_15 real NOT NULL, --/U A --/D Equivalent width of H-15 
  abs_h_15 real NOT NULL, --/U  --/D abs_h_15 
  detection_stat_h_15 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_h_15 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_15_1 real NOT NULL, --/F eqw_percentiles_h_15 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_15_2 real NOT NULL, --/F eqw_percentiles_h_15 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_15_3 real NOT NULL, --/F eqw_percentiles_h_15 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_15_1 real NOT NULL, --/F abs_percentiles_h_15 0 --/U  --/D abs_percentiles_h_15 (array element 1) 
  abs_percentiles_h_15_2 real NOT NULL, --/F abs_percentiles_h_15 1 --/U  --/D abs_percentiles_h_15 (array element 2) 
  abs_percentiles_h_15_3 real NOT NULL, --/F abs_percentiles_h_15 2 --/U  --/D abs_percentiles_h_15 (array element 3) 
  eqw_h_16 real NOT NULL, --/U A --/D Equivalent width of H-16 
  abs_h_16 real NOT NULL, --/U  --/D abs_h_16 
  detection_stat_h_16 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_h_16 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_16_1 real NOT NULL, --/F eqw_percentiles_h_16 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_16_2 real NOT NULL, --/F eqw_percentiles_h_16 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_16_3 real NOT NULL, --/F eqw_percentiles_h_16 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_16_1 real NOT NULL, --/F abs_percentiles_h_16 0 --/U  --/D abs_percentiles_h_16 (array element 1) 
  abs_percentiles_h_16_2 real NOT NULL, --/F abs_percentiles_h_16 1 --/U  --/D abs_percentiles_h_16 (array element 2) 
  abs_percentiles_h_16_3 real NOT NULL, --/F abs_percentiles_h_16 2 --/U  --/D abs_percentiles_h_16 (array element 3) 
  eqw_h_17 real NOT NULL, --/U A --/D Equivalent width of H-17 
  abs_h_17 real NOT NULL, --/U  --/D abs_h_17 
  detection_stat_h_17 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_h_17 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_h_17_1 real NOT NULL, --/F eqw_percentiles_h_17 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_h_17_2 real NOT NULL, --/F eqw_percentiles_h_17 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_h_17_3 real NOT NULL, --/F eqw_percentiles_h_17 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_h_17_1 real NOT NULL, --/F abs_percentiles_h_17 0 --/U  --/D abs_percentiles_h_17 (array element 1) 
  abs_percentiles_h_17_2 real NOT NULL, --/F abs_percentiles_h_17 1 --/U  --/D abs_percentiles_h_17 (array element 2) 
  abs_percentiles_h_17_3 real NOT NULL, --/F abs_percentiles_h_17 2 --/U  --/D abs_percentiles_h_17 (array element 3) 
  eqw_pa_7 real NOT NULL, --/U A --/D Equivalent width of Pa-7 
  abs_pa_7 real NOT NULL, --/U  --/D abs_pa_7 
  detection_stat_pa_7 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_pa_7 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_pa_7_1 real NOT NULL, --/F eqw_percentiles_pa_7 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_7_2 real NOT NULL, --/F eqw_percentiles_pa_7 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_7_3 real NOT NULL, --/F eqw_percentiles_pa_7 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_7_1 real NOT NULL, --/F abs_percentiles_pa_7 0 --/U  --/D abs_percentiles_pa_7 (array element 1) 
  abs_percentiles_pa_7_2 real NOT NULL, --/F abs_percentiles_pa_7 1 --/U  --/D abs_percentiles_pa_7 (array element 2) 
  abs_percentiles_pa_7_3 real NOT NULL, --/F abs_percentiles_pa_7 2 --/U  --/D abs_percentiles_pa_7 (array element 3) 
  eqw_pa_8 real NOT NULL, --/U A --/D Equivalent width of Pa-8 
  abs_pa_8 real NOT NULL, --/U  --/D abs_pa_8 
  detection_stat_pa_8 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_pa_8 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_pa_8_1 real NOT NULL, --/F eqw_percentiles_pa_8 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_8_2 real NOT NULL, --/F eqw_percentiles_pa_8 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_8_3 real NOT NULL, --/F eqw_percentiles_pa_8 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_8_1 real NOT NULL, --/F abs_percentiles_pa_8 0 --/U  --/D abs_percentiles_pa_8 (array element 1) 
  abs_percentiles_pa_8_2 real NOT NULL, --/F abs_percentiles_pa_8 1 --/U  --/D abs_percentiles_pa_8 (array element 2) 
  abs_percentiles_pa_8_3 real NOT NULL, --/F abs_percentiles_pa_8 2 --/U  --/D abs_percentiles_pa_8 (array element 3) 
  eqw_pa_9 real NOT NULL, --/U A --/D Equivalent width of Pa-9 
  abs_pa_9 real NOT NULL, --/U  --/D abs_pa_9 
  detection_stat_pa_9 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_pa_9 real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_pa_9_1 real NOT NULL, --/F eqw_percentiles_pa_9 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_9_2 real NOT NULL, --/F eqw_percentiles_pa_9 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_9_3 real NOT NULL, --/F eqw_percentiles_pa_9 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_9_1 real NOT NULL, --/F abs_percentiles_pa_9 0 --/U  --/D abs_percentiles_pa_9 (array element 1) 
  abs_percentiles_pa_9_2 real NOT NULL, --/F abs_percentiles_pa_9 1 --/U  --/D abs_percentiles_pa_9 (array element 2) 
  abs_percentiles_pa_9_3 real NOT NULL, --/F abs_percentiles_pa_9 2 --/U  --/D abs_percentiles_pa_9 (array element 3) 
  eqw_pa_10 real NOT NULL, --/U A --/D Equivalent width of Pa-10 
  abs_pa_10 real NOT NULL, --/U  --/D abs_pa_10 
  detection_stat_pa_10 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: und 
  detection_raw_pa_10 real NOT NULL, --/U  --/D Probability that feature is not noise (0: nois 
  eqw_percentiles_pa_10_1 real NOT NULL, --/F eqw_percentiles_pa_10 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_10_2 real NOT NULL, --/F eqw_percentiles_pa_10 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_10_3 real NOT NULL, --/F eqw_percentiles_pa_10 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_10_1 real NOT NULL, --/F abs_percentiles_pa_10 0 --/U  --/D abs_percentiles_pa_10 (array element 1) 
  abs_percentiles_pa_10_2 real NOT NULL, --/F abs_percentiles_pa_10 1 --/U  --/D abs_percentiles_pa_10 (array element 2) 
  abs_percentiles_pa_10_3 real NOT NULL, --/F abs_percentiles_pa_10 2 --/U  --/D abs_percentiles_pa_10 (array element 3) 
  eqw_pa_11 real NOT NULL, --/U A --/D Equivalent width of Pa-11 
  abs_pa_11 real NOT NULL, --/U  --/D abs_pa_11 
  detection_stat_pa_11 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: und 
  detection_raw_pa_11 real NOT NULL, --/U  --/D Probability that feature is not noise (0: nois 
  eqw_percentiles_pa_11_1 real NOT NULL, --/F eqw_percentiles_pa_11 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_11_2 real NOT NULL, --/F eqw_percentiles_pa_11 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_11_3 real NOT NULL, --/F eqw_percentiles_pa_11 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_11_1 real NOT NULL, --/F abs_percentiles_pa_11 0 --/U  --/D abs_percentiles_pa_11 (array element 1) 
  abs_percentiles_pa_11_2 real NOT NULL, --/F abs_percentiles_pa_11 1 --/U  --/D abs_percentiles_pa_11 (array element 2) 
  abs_percentiles_pa_11_3 real NOT NULL, --/F abs_percentiles_pa_11 2 --/U  --/D abs_percentiles_pa_11 (array element 3) 
  eqw_pa_12 real NOT NULL, --/U A --/D Equivalent width of Pa-12 
  abs_pa_12 real NOT NULL, --/U  --/D abs_pa_12 
  detection_stat_pa_12 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: und 
  detection_raw_pa_12 real NOT NULL, --/U  --/D Probability that feature is not noise (0: nois 
  eqw_percentiles_pa_12_1 real NOT NULL, --/F eqw_percentiles_pa_12 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_12_2 real NOT NULL, --/F eqw_percentiles_pa_12 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_12_3 real NOT NULL, --/F eqw_percentiles_pa_12 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_12_1 real NOT NULL, --/F abs_percentiles_pa_12 0 --/U  --/D abs_percentiles_pa_12 (array element 1) 
  abs_percentiles_pa_12_2 real NOT NULL, --/F abs_percentiles_pa_12 1 --/U  --/D abs_percentiles_pa_12 (array element 2) 
  abs_percentiles_pa_12_3 real NOT NULL, --/F abs_percentiles_pa_12 2 --/U  --/D abs_percentiles_pa_12 (array element 3) 
  eqw_pa_13 real NOT NULL, --/U A --/D Equivalent width of Pa-13 
  abs_pa_13 real NOT NULL, --/U  --/D abs_pa_13 
  detection_stat_pa_13 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: und 
  detection_raw_pa_13 real NOT NULL, --/U  --/D Probability that feature is not noise (0: nois 
  eqw_percentiles_pa_13_1 real NOT NULL, --/F eqw_percentiles_pa_13 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_13_2 real NOT NULL, --/F eqw_percentiles_pa_13 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_13_3 real NOT NULL, --/F eqw_percentiles_pa_13 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_13_1 real NOT NULL, --/F abs_percentiles_pa_13 0 --/U  --/D abs_percentiles_pa_13 (array element 1) 
  abs_percentiles_pa_13_2 real NOT NULL, --/F abs_percentiles_pa_13 1 --/U  --/D abs_percentiles_pa_13 (array element 2) 
  abs_percentiles_pa_13_3 real NOT NULL, --/F abs_percentiles_pa_13 2 --/U  --/D abs_percentiles_pa_13 (array element 3) 
  eqw_pa_14 real NOT NULL, --/U A --/D Equivalent width of Pa-14 
  abs_pa_14 real NOT NULL, --/U  --/D abs_pa_14 
  detection_stat_pa_14 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: und 
  detection_raw_pa_14 real NOT NULL, --/U  --/D Probability that feature is not noise (0: nois 
  eqw_percentiles_pa_14_1 real NOT NULL, --/F eqw_percentiles_pa_14 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_14_2 real NOT NULL, --/F eqw_percentiles_pa_14 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_14_3 real NOT NULL, --/F eqw_percentiles_pa_14 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_14_1 real NOT NULL, --/F abs_percentiles_pa_14 0 --/U  --/D abs_percentiles_pa_14 (array element 1) 
  abs_percentiles_pa_14_2 real NOT NULL, --/F abs_percentiles_pa_14 1 --/U  --/D abs_percentiles_pa_14 (array element 2) 
  abs_percentiles_pa_14_3 real NOT NULL, --/F abs_percentiles_pa_14 2 --/U  --/D abs_percentiles_pa_14 (array element 3) 
  eqw_pa_15 real NOT NULL, --/U A --/D Equivalent width of Pa-15 
  abs_pa_15 real NOT NULL, --/U  --/D abs_pa_15 
  detection_stat_pa_15 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: und 
  detection_raw_pa_15 real NOT NULL, --/U  --/D Probability that feature is not noise (0: nois 
  eqw_percentiles_pa_15_1 real NOT NULL, --/F eqw_percentiles_pa_15 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_15_2 real NOT NULL, --/F eqw_percentiles_pa_15 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_15_3 real NOT NULL, --/F eqw_percentiles_pa_15 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_15_1 real NOT NULL, --/F abs_percentiles_pa_15 0 --/U  --/D abs_percentiles_pa_15 (array element 1) 
  abs_percentiles_pa_15_2 real NOT NULL, --/F abs_percentiles_pa_15 1 --/U  --/D abs_percentiles_pa_15 (array element 2) 
  abs_percentiles_pa_15_3 real NOT NULL, --/F abs_percentiles_pa_15 2 --/U  --/D abs_percentiles_pa_15 (array element 3) 
  eqw_pa_16 real NOT NULL, --/U A --/D Equivalent width of Pa-16 
  abs_pa_16 real NOT NULL, --/U  --/D abs_pa_16 
  detection_stat_pa_16 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: und 
  detection_raw_pa_16 real NOT NULL, --/U  --/D Probability that feature is not noise (0: nois 
  eqw_percentiles_pa_16_1 real NOT NULL, --/F eqw_percentiles_pa_16 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_16_2 real NOT NULL, --/F eqw_percentiles_pa_16 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_16_3 real NOT NULL, --/F eqw_percentiles_pa_16 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_16_1 real NOT NULL, --/F abs_percentiles_pa_16 0 --/U  --/D abs_percentiles_pa_16 (array element 1) 
  abs_percentiles_pa_16_2 real NOT NULL, --/F abs_percentiles_pa_16 1 --/U  --/D abs_percentiles_pa_16 (array element 2) 
  abs_percentiles_pa_16_3 real NOT NULL, --/F abs_percentiles_pa_16 2 --/U  --/D abs_percentiles_pa_16 (array element 3) 
  eqw_pa_17 real NOT NULL, --/U A --/D Equivalent width of Pa-17 
  abs_pa_17 real NOT NULL, --/U  --/D abs_pa_17 
  detection_stat_pa_17 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: und 
  detection_raw_pa_17 real NOT NULL, --/U  --/D Probability that feature is not noise (0: nois 
  eqw_percentiles_pa_17_1 real NOT NULL, --/F eqw_percentiles_pa_17 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_pa_17_2 real NOT NULL, --/F eqw_percentiles_pa_17 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_pa_17_3 real NOT NULL, --/F eqw_percentiles_pa_17 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_pa_17_1 real NOT NULL, --/F abs_percentiles_pa_17 0 --/U  --/D abs_percentiles_pa_17 (array element 1) 
  abs_percentiles_pa_17_2 real NOT NULL, --/F abs_percentiles_pa_17 1 --/U  --/D abs_percentiles_pa_17 (array element 2) 
  abs_percentiles_pa_17_3 real NOT NULL, --/F abs_percentiles_pa_17 2 --/U  --/D abs_percentiles_pa_17 (array element 3) 
  eqw_ca_ii_8662 real NOT NULL, --/U A --/D Equivalent width of Ca II at 8662 A 
  abs_ca_ii_8662 real NOT NULL, --/U  --/D abs_ca_ii_8662 
  detection_stat_ca_ii_8662 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_ca_ii_8662 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_ca_ii_8662_1 real NOT NULL, --/F eqw_percentiles_ca_ii_8662 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_ca_ii_8662_2 real NOT NULL, --/F eqw_percentiles_ca_ii_8662 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_ca_ii_8662_3 real NOT NULL, --/F eqw_percentiles_ca_ii_8662 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_ca_ii_8662_1 real NOT NULL, --/F abs_percentiles_ca_ii_8662 0 --/U  --/D abs_percentiles_ca_ii_8662 (array element 1) 
  abs_percentiles_ca_ii_8662_2 real NOT NULL, --/F abs_percentiles_ca_ii_8662 1 --/U  --/D abs_percentiles_ca_ii_8662 (array element 2) 
  abs_percentiles_ca_ii_8662_3 real NOT NULL, --/F abs_percentiles_ca_ii_8662 2 --/U  --/D abs_percentiles_ca_ii_8662 (array element 3) 
  eqw_ca_ii_8542 real NOT NULL, --/U A --/D Equivalent width of Ca II at 8542 A 
  abs_ca_ii_8542 real NOT NULL, --/U  --/D abs_ca_ii_8542 
  detection_stat_ca_ii_8542 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_ca_ii_8542 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_ca_ii_8542_1 real NOT NULL, --/F eqw_percentiles_ca_ii_8542 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_ca_ii_8542_2 real NOT NULL, --/F eqw_percentiles_ca_ii_8542 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_ca_ii_8542_3 real NOT NULL, --/F eqw_percentiles_ca_ii_8542 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_ca_ii_8542_1 real NOT NULL, --/F abs_percentiles_ca_ii_8542 0 --/U  --/D abs_percentiles_ca_ii_8542 (array element 1) 
  abs_percentiles_ca_ii_8542_2 real NOT NULL, --/F abs_percentiles_ca_ii_8542 1 --/U  --/D abs_percentiles_ca_ii_8542 (array element 2) 
  abs_percentiles_ca_ii_8542_3 real NOT NULL, --/F abs_percentiles_ca_ii_8542 2 --/U  --/D abs_percentiles_ca_ii_8542 (array element 3) 
  eqw_ca_ii_8498 real NOT NULL, --/U A --/D Equivalent width of Ca II at 8498 A 
  abs_ca_ii_8498 real NOT NULL, --/U  --/D abs_ca_ii_8498 
  detection_stat_ca_ii_8498 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_ca_ii_8498 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_ca_ii_8498_1 real NOT NULL, --/F eqw_percentiles_ca_ii_8498 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_ca_ii_8498_2 real NOT NULL, --/F eqw_percentiles_ca_ii_8498 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_ca_ii_8498_3 real NOT NULL, --/F eqw_percentiles_ca_ii_8498 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_ca_ii_8498_1 real NOT NULL, --/F abs_percentiles_ca_ii_8498 0 --/U  --/D abs_percentiles_ca_ii_8498 (array element 1) 
  abs_percentiles_ca_ii_8498_2 real NOT NULL, --/F abs_percentiles_ca_ii_8498 1 --/U  --/D abs_percentiles_ca_ii_8498 (array element 2) 
  abs_percentiles_ca_ii_8498_3 real NOT NULL, --/F abs_percentiles_ca_ii_8498 2 --/U  --/D abs_percentiles_ca_ii_8498 (array element 3) 
  eqw_ca_k_3933 real NOT NULL, --/U A --/D Equivalent width of Ca K at 3933 A 
  abs_ca_k_3933 real NOT NULL, --/U  --/D abs_ca_k_3933 
  detection_stat_ca_k_3933 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_ca_k_3933 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_ca_k_3933_1 real NOT NULL, --/F eqw_percentiles_ca_k_3933 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_ca_k_3933_2 real NOT NULL, --/F eqw_percentiles_ca_k_3933 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_ca_k_3933_3 real NOT NULL, --/F eqw_percentiles_ca_k_3933 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_ca_k_3933_1 real NOT NULL, --/F abs_percentiles_ca_k_3933 0 --/U  --/D abs_percentiles_ca_k_3933 (array element 1) 
  abs_percentiles_ca_k_3933_2 real NOT NULL, --/F abs_percentiles_ca_k_3933 1 --/U  --/D abs_percentiles_ca_k_3933 (array element 2) 
  abs_percentiles_ca_k_3933_3 real NOT NULL, --/F abs_percentiles_ca_k_3933 2 --/U  --/D abs_percentiles_ca_k_3933 (array element 3) 
  eqw_ca_h_3968 real NOT NULL, --/U A --/D Equivalent width of Ca H at 3968 A 
  abs_ca_h_3968 real NOT NULL, --/U  --/D abs_ca_h_3968 
  detection_stat_ca_h_3968 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_ca_h_3968 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_ca_h_3968_1 real NOT NULL, --/F eqw_percentiles_ca_h_3968 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_ca_h_3968_2 real NOT NULL, --/F eqw_percentiles_ca_h_3968 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_ca_h_3968_3 real NOT NULL, --/F eqw_percentiles_ca_h_3968 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_ca_h_3968_1 real NOT NULL, --/F abs_percentiles_ca_h_3968 0 --/U  --/D abs_percentiles_ca_h_3968 (array element 1) 
  abs_percentiles_ca_h_3968_2 real NOT NULL, --/F abs_percentiles_ca_h_3968 1 --/U  --/D abs_percentiles_ca_h_3968 (array element 2) 
  abs_percentiles_ca_h_3968_3 real NOT NULL, --/F abs_percentiles_ca_h_3968 2 --/U  --/D abs_percentiles_ca_h_3968 (array element 3) 
  eqw_he_i_6678 real NOT NULL, --/U A --/D Equivalent width of He I at 6678 A 
  abs_he_i_6678 real NOT NULL, --/U  --/D abs_he_i_6678 
  detection_stat_he_i_6678 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_he_i_6678 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_he_i_6678_1 real NOT NULL, --/F eqw_percentiles_he_i_6678 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_he_i_6678_2 real NOT NULL, --/F eqw_percentiles_he_i_6678 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_he_i_6678_3 real NOT NULL, --/F eqw_percentiles_he_i_6678 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_he_i_6678_1 real NOT NULL, --/F abs_percentiles_he_i_6678 0 --/U  --/D abs_percentiles_he_i_6678 (array element 1) 
  abs_percentiles_he_i_6678_2 real NOT NULL, --/F abs_percentiles_he_i_6678 1 --/U  --/D abs_percentiles_he_i_6678 (array element 2) 
  abs_percentiles_he_i_6678_3 real NOT NULL, --/F abs_percentiles_he_i_6678 2 --/U  --/D abs_percentiles_he_i_6678 (array element 3) 
  eqw_he_i_5875 real NOT NULL, --/U A --/D Equivalent width of He I at 5875 A 
  abs_he_i_5875 real NOT NULL, --/U  --/D abs_he_i_5875 
  detection_stat_he_i_5875 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_he_i_5875 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_he_i_5875_1 real NOT NULL, --/F eqw_percentiles_he_i_5875 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_he_i_5875_2 real NOT NULL, --/F eqw_percentiles_he_i_5875 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_he_i_5875_3 real NOT NULL, --/F eqw_percentiles_he_i_5875 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_he_i_5875_1 real NOT NULL, --/F abs_percentiles_he_i_5875 0 --/U  --/D abs_percentiles_he_i_5875 (array element 1) 
  abs_percentiles_he_i_5875_2 real NOT NULL, --/F abs_percentiles_he_i_5875 1 --/U  --/D abs_percentiles_he_i_5875 (array element 2) 
  abs_percentiles_he_i_5875_3 real NOT NULL, --/F abs_percentiles_he_i_5875 2 --/U  --/D abs_percentiles_he_i_5875 (array element 3) 
  eqw_he_i_5015 real NOT NULL, --/U A --/D Equivalent width of He I at 5015 A 
  abs_he_i_5015 real NOT NULL, --/U  --/D abs_he_i_5015 
  detection_stat_he_i_5015 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_he_i_5015 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_he_i_5015_1 real NOT NULL, --/F eqw_percentiles_he_i_5015 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_he_i_5015_2 real NOT NULL, --/F eqw_percentiles_he_i_5015 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_he_i_5015_3 real NOT NULL, --/F eqw_percentiles_he_i_5015 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_he_i_5015_1 real NOT NULL, --/F abs_percentiles_he_i_5015 0 --/U  --/D abs_percentiles_he_i_5015 (array element 1) 
  abs_percentiles_he_i_5015_2 real NOT NULL, --/F abs_percentiles_he_i_5015 1 --/U  --/D abs_percentiles_he_i_5015 (array element 2) 
  abs_percentiles_he_i_5015_3 real NOT NULL, --/F abs_percentiles_he_i_5015 2 --/U  --/D abs_percentiles_he_i_5015 (array element 3) 
  eqw_he_i_4471 real NOT NULL, --/U A --/D Equivalent width of He I at 4471 A 
  abs_he_i_4471 real NOT NULL, --/U  --/D abs_he_i_4471 
  detection_stat_he_i_4471 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_he_i_4471 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_he_i_4471_1 real NOT NULL, --/F eqw_percentiles_he_i_4471 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_he_i_4471_2 real NOT NULL, --/F eqw_percentiles_he_i_4471 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_he_i_4471_3 real NOT NULL, --/F eqw_percentiles_he_i_4471 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_he_i_4471_1 real NOT NULL, --/F abs_percentiles_he_i_4471 0 --/U  --/D abs_percentiles_he_i_4471 (array element 1) 
  abs_percentiles_he_i_4471_2 real NOT NULL, --/F abs_percentiles_he_i_4471 1 --/U  --/D abs_percentiles_he_i_4471 (array element 2) 
  abs_percentiles_he_i_4471_3 real NOT NULL, --/F abs_percentiles_he_i_4471 2 --/U  --/D abs_percentiles_he_i_4471 (array element 3) 
  eqw_he_ii_4685 real NOT NULL, --/U A --/D Equivalent width of He II at 4685 A 
  abs_he_ii_4685 real NOT NULL, --/U  --/D abs_he_ii_4685 
  detection_stat_he_ii_4685 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_he_ii_4685 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_he_ii_4685_1 real NOT NULL, --/F eqw_percentiles_he_ii_4685 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_he_ii_4685_2 real NOT NULL, --/F eqw_percentiles_he_ii_4685 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_he_ii_4685_3 real NOT NULL, --/F eqw_percentiles_he_ii_4685 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_he_ii_4685_1 real NOT NULL, --/F abs_percentiles_he_ii_4685 0 --/U  --/D abs_percentiles_he_ii_4685 (array element 1) 
  abs_percentiles_he_ii_4685_2 real NOT NULL, --/F abs_percentiles_he_ii_4685 1 --/U  --/D abs_percentiles_he_ii_4685 (array element 2) 
  abs_percentiles_he_ii_4685_3 real NOT NULL, --/F abs_percentiles_he_ii_4685 2 --/U  --/D abs_percentiles_he_ii_4685 (array element 3) 
  eqw_n_ii_6583 real NOT NULL, --/U A --/D Equivalent width of N II at 6583 A 
  abs_n_ii_6583 real NOT NULL, --/U  --/D abs_n_ii_6583 
  detection_stat_n_ii_6583 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_n_ii_6583 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_n_ii_6583_1 real NOT NULL, --/F eqw_percentiles_n_ii_6583 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_n_ii_6583_2 real NOT NULL, --/F eqw_percentiles_n_ii_6583 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_n_ii_6583_3 real NOT NULL, --/F eqw_percentiles_n_ii_6583 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_n_ii_6583_1 real NOT NULL, --/F abs_percentiles_n_ii_6583 0 --/U  --/D abs_percentiles_n_ii_6583 (array element 1) 
  abs_percentiles_n_ii_6583_2 real NOT NULL, --/F abs_percentiles_n_ii_6583 1 --/U  --/D abs_percentiles_n_ii_6583 (array element 2) 
  abs_percentiles_n_ii_6583_3 real NOT NULL, --/F abs_percentiles_n_ii_6583 2 --/U  --/D abs_percentiles_n_ii_6583 (array element 3) 
  eqw_n_ii_6548 real NOT NULL, --/U A --/D Equivalent width of N II at 6548 A 
  abs_n_ii_6548 real NOT NULL, --/U  --/D abs_n_ii_6548 
  detection_stat_n_ii_6548 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_n_ii_6548 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_n_ii_6548_1 real NOT NULL, --/F eqw_percentiles_n_ii_6548 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_n_ii_6548_2 real NOT NULL, --/F eqw_percentiles_n_ii_6548 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_n_ii_6548_3 real NOT NULL, --/F eqw_percentiles_n_ii_6548 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_n_ii_6548_1 real NOT NULL, --/F abs_percentiles_n_ii_6548 0 --/U  --/D abs_percentiles_n_ii_6548 (array element 1) 
  abs_percentiles_n_ii_6548_2 real NOT NULL, --/F abs_percentiles_n_ii_6548 1 --/U  --/D abs_percentiles_n_ii_6548 (array element 2) 
  abs_percentiles_n_ii_6548_3 real NOT NULL, --/F abs_percentiles_n_ii_6548 2 --/U  --/D abs_percentiles_n_ii_6548 (array element 3) 
  eqw_s_ii_6716 real NOT NULL, --/U A --/D Equivalent width of S II at 6716 A 
  abs_s_ii_6716 real NOT NULL, --/U  --/D abs_s_ii_6716 
  detection_stat_s_ii_6716 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_s_ii_6716 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_s_ii_6716_1 real NOT NULL, --/F eqw_percentiles_s_ii_6716 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_s_ii_6716_2 real NOT NULL, --/F eqw_percentiles_s_ii_6716 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_s_ii_6716_3 real NOT NULL, --/F eqw_percentiles_s_ii_6716 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_s_ii_6716_1 real NOT NULL, --/F abs_percentiles_s_ii_6716 0 --/U  --/D abs_percentiles_s_ii_6716 (array element 1) 
  abs_percentiles_s_ii_6716_2 real NOT NULL, --/F abs_percentiles_s_ii_6716 1 --/U  --/D abs_percentiles_s_ii_6716 (array element 2) 
  abs_percentiles_s_ii_6716_3 real NOT NULL, --/F abs_percentiles_s_ii_6716 2 --/U  --/D abs_percentiles_s_ii_6716 (array element 3) 
  eqw_s_ii_6730 real NOT NULL, --/U A --/D Equivalent width of S II at 6730 A 
  abs_s_ii_6730 real NOT NULL, --/U  --/D abs_s_ii_6730 
  detection_stat_s_ii_6730 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_s_ii_6730 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_s_ii_6730_1 real NOT NULL, --/F eqw_percentiles_s_ii_6730 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_s_ii_6730_2 real NOT NULL, --/F eqw_percentiles_s_ii_6730 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_s_ii_6730_3 real NOT NULL, --/F eqw_percentiles_s_ii_6730 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_s_ii_6730_1 real NOT NULL, --/F abs_percentiles_s_ii_6730 0 --/U  --/D abs_percentiles_s_ii_6730 (array element 1) 
  abs_percentiles_s_ii_6730_2 real NOT NULL, --/F abs_percentiles_s_ii_6730 1 --/U  --/D abs_percentiles_s_ii_6730 (array element 2) 
  abs_percentiles_s_ii_6730_3 real NOT NULL, --/F abs_percentiles_s_ii_6730 2 --/U  --/D abs_percentiles_s_ii_6730 (array element 3) 
  eqw_fe_ii_5018 real NOT NULL, --/U A --/D Equivalent width of Fe II at 5018 A 
  abs_fe_ii_5018 real NOT NULL, --/U  --/D abs_fe_ii_5018 
  detection_stat_fe_ii_5018 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_fe_ii_5018 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_fe_ii_5018_1 real NOT NULL, --/F eqw_percentiles_fe_ii_5018 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_fe_ii_5018_2 real NOT NULL, --/F eqw_percentiles_fe_ii_5018 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_fe_ii_5018_3 real NOT NULL, --/F eqw_percentiles_fe_ii_5018 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_fe_ii_5018_1 real NOT NULL, --/F abs_percentiles_fe_ii_5018 0 --/U  --/D abs_percentiles_fe_ii_5018 (array element 1) 
  abs_percentiles_fe_ii_5018_2 real NOT NULL, --/F abs_percentiles_fe_ii_5018 1 --/U  --/D abs_percentiles_fe_ii_5018 (array element 2) 
  abs_percentiles_fe_ii_5018_3 real NOT NULL, --/F abs_percentiles_fe_ii_5018 2 --/U  --/D abs_percentiles_fe_ii_5018 (array element 3) 
  eqw_fe_ii_5169 real NOT NULL, --/U A --/D Equivalent width of Fe II at 5169 A 
  abs_fe_ii_5169 real NOT NULL, --/U  --/D abs_fe_ii_5169 
  detection_stat_fe_ii_5169 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_fe_ii_5169 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_fe_ii_5169_1 real NOT NULL, --/F eqw_percentiles_fe_ii_5169 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_fe_ii_5169_2 real NOT NULL, --/F eqw_percentiles_fe_ii_5169 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_fe_ii_5169_3 real NOT NULL, --/F eqw_percentiles_fe_ii_5169 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_fe_ii_5169_1 real NOT NULL, --/F abs_percentiles_fe_ii_5169 0 --/U  --/D abs_percentiles_fe_ii_5169 (array element 1) 
  abs_percentiles_fe_ii_5169_2 real NOT NULL, --/F abs_percentiles_fe_ii_5169 1 --/U  --/D abs_percentiles_fe_ii_5169 (array element 2) 
  abs_percentiles_fe_ii_5169_3 real NOT NULL, --/F abs_percentiles_fe_ii_5169 2 --/U  --/D abs_percentiles_fe_ii_5169 (array element 3) 
  eqw_fe_ii_5197 real NOT NULL, --/U A --/D Equivalent width of Fe II at 5197 A 
  abs_fe_ii_5197 real NOT NULL, --/U  --/D abs_fe_ii_5197 
  detection_stat_fe_ii_5197 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_fe_ii_5197 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_fe_ii_5197_1 real NOT NULL, --/F eqw_percentiles_fe_ii_5197 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_fe_ii_5197_2 real NOT NULL, --/F eqw_percentiles_fe_ii_5197 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_fe_ii_5197_3 real NOT NULL, --/F eqw_percentiles_fe_ii_5197 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_fe_ii_5197_1 real NOT NULL, --/F abs_percentiles_fe_ii_5197 0 --/U  --/D abs_percentiles_fe_ii_5197 (array element 1) 
  abs_percentiles_fe_ii_5197_2 real NOT NULL, --/F abs_percentiles_fe_ii_5197 1 --/U  --/D abs_percentiles_fe_ii_5197 (array element 2) 
  abs_percentiles_fe_ii_5197_3 real NOT NULL, --/F abs_percentiles_fe_ii_5197 2 --/U  --/D abs_percentiles_fe_ii_5197 (array element 3) 
  eqw_fe_ii_6432 real NOT NULL, --/U A --/D Equivalent width of Fe II at 6432 A 
  abs_fe_ii_6432 real NOT NULL, --/U  --/D abs_fe_ii_6432 
  detection_stat_fe_ii_6432 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_fe_ii_6432 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_fe_ii_6432_1 real NOT NULL, --/F eqw_percentiles_fe_ii_6432 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_fe_ii_6432_2 real NOT NULL, --/F eqw_percentiles_fe_ii_6432 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_fe_ii_6432_3 real NOT NULL, --/F eqw_percentiles_fe_ii_6432 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_fe_ii_6432_1 real NOT NULL, --/F abs_percentiles_fe_ii_6432 0 --/U  --/D abs_percentiles_fe_ii_6432 (array element 1) 
  abs_percentiles_fe_ii_6432_2 real NOT NULL, --/F abs_percentiles_fe_ii_6432 1 --/U  --/D abs_percentiles_fe_ii_6432 (array element 2) 
  abs_percentiles_fe_ii_6432_3 real NOT NULL, --/F abs_percentiles_fe_ii_6432 2 --/U  --/D abs_percentiles_fe_ii_6432 (array element 3) 
  eqw_o_i_5577 real NOT NULL, --/U A --/D Equivalent width of O I at 5577 A 
  abs_o_i_5577 real NOT NULL, --/U  --/D abs_o_i_5577 
  detection_stat_o_i_5577 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_o_i_5577 real NOT NULL, --/U  --/D Probability that feature is not noise (0: n 
  eqw_percentiles_o_i_5577_1 real NOT NULL, --/F eqw_percentiles_o_i_5577 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_o_i_5577_2 real NOT NULL, --/F eqw_percentiles_o_i_5577 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_o_i_5577_3 real NOT NULL, --/F eqw_percentiles_o_i_5577 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_o_i_5577_1 real NOT NULL, --/F abs_percentiles_o_i_5577 0 --/U  --/D abs_percentiles_o_i_5577 (array element 1) 
  abs_percentiles_o_i_5577_2 real NOT NULL, --/F abs_percentiles_o_i_5577 1 --/U  --/D abs_percentiles_o_i_5577 (array element 2) 
  abs_percentiles_o_i_5577_3 real NOT NULL, --/F abs_percentiles_o_i_5577 2 --/U  --/D abs_percentiles_o_i_5577 (array element 3) 
  eqw_o_i_6300 real NOT NULL, --/U A --/D Equivalent width of O I at 6300 A 
  abs_o_i_6300 real NOT NULL, --/U  --/D abs_o_i_6300 
  detection_stat_o_i_6300 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_o_i_6300 real NOT NULL, --/U  --/D Probability that feature is not noise (0: n 
  eqw_percentiles_o_i_6300_1 real NOT NULL, --/F eqw_percentiles_o_i_6300 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_o_i_6300_2 real NOT NULL, --/F eqw_percentiles_o_i_6300 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_o_i_6300_3 real NOT NULL, --/F eqw_percentiles_o_i_6300 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_o_i_6300_1 real NOT NULL, --/F abs_percentiles_o_i_6300 0 --/U  --/D abs_percentiles_o_i_6300 (array element 1) 
  abs_percentiles_o_i_6300_2 real NOT NULL, --/F abs_percentiles_o_i_6300 1 --/U  --/D abs_percentiles_o_i_6300 (array element 2) 
  abs_percentiles_o_i_6300_3 real NOT NULL, --/F abs_percentiles_o_i_6300 2 --/U  --/D abs_percentiles_o_i_6300 (array element 3) 
  eqw_o_i_6363 real NOT NULL, --/U A --/D Equivalent width of O I at 6363 A 
  abs_o_i_6363 real NOT NULL, --/U  --/D abs_o_i_6363 
  detection_stat_o_i_6363 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_o_i_6363 real NOT NULL, --/U  --/D Probability that feature is not noise (0: n 
  eqw_percentiles_o_i_6363_1 real NOT NULL, --/F eqw_percentiles_o_i_6363 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_o_i_6363_2 real NOT NULL, --/F eqw_percentiles_o_i_6363 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_o_i_6363_3 real NOT NULL, --/F eqw_percentiles_o_i_6363 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_o_i_6363_1 real NOT NULL, --/F abs_percentiles_o_i_6363 0 --/U  --/D abs_percentiles_o_i_6363 (array element 1) 
  abs_percentiles_o_i_6363_2 real NOT NULL, --/F abs_percentiles_o_i_6363 1 --/U  --/D abs_percentiles_o_i_6363 (array element 2) 
  abs_percentiles_o_i_6363_3 real NOT NULL, --/F abs_percentiles_o_i_6363 2 --/U  --/D abs_percentiles_o_i_6363 (array element 3) 
  eqw_o_ii_3727 real NOT NULL, --/U A --/D Equivalent width of O II at 3727 A 
  abs_o_ii_3727 real NOT NULL, --/U  --/D abs_o_ii_3727 
  detection_stat_o_ii_3727 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: 
  detection_raw_o_ii_3727 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_o_ii_3727_1 real NOT NULL, --/F eqw_percentiles_o_ii_3727 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_o_ii_3727_2 real NOT NULL, --/F eqw_percentiles_o_ii_3727 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_o_ii_3727_3 real NOT NULL, --/F eqw_percentiles_o_ii_3727 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_o_ii_3727_1 real NOT NULL, --/F abs_percentiles_o_ii_3727 0 --/U  --/D abs_percentiles_o_ii_3727 (array element 1) 
  abs_percentiles_o_ii_3727_2 real NOT NULL, --/F abs_percentiles_o_ii_3727 1 --/U  --/D abs_percentiles_o_ii_3727 (array element 2) 
  abs_percentiles_o_ii_3727_3 real NOT NULL, --/F abs_percentiles_o_ii_3727 2 --/U  --/D abs_percentiles_o_ii_3727 (array element 3) 
  eqw_o_iii_4959 real NOT NULL, --/U A --/D Equivalent width of O III at 4959 A 
  abs_o_iii_4959 real NOT NULL, --/U  --/D abs_o_iii_4959 
  detection_stat_o_iii_4959 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_o_iii_4959 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_o_iii_4959_1 real NOT NULL, --/F eqw_percentiles_o_iii_4959 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_o_iii_4959_2 real NOT NULL, --/F eqw_percentiles_o_iii_4959 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_o_iii_4959_3 real NOT NULL, --/F eqw_percentiles_o_iii_4959 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_o_iii_4959_1 real NOT NULL, --/F abs_percentiles_o_iii_4959 0 --/U  --/D abs_percentiles_o_iii_4959 (array element 1) 
  abs_percentiles_o_iii_4959_2 real NOT NULL, --/F abs_percentiles_o_iii_4959 1 --/U  --/D abs_percentiles_o_iii_4959 (array element 2) 
  abs_percentiles_o_iii_4959_3 real NOT NULL, --/F abs_percentiles_o_iii_4959 2 --/U  --/D abs_percentiles_o_iii_4959 (array element 3) 
  eqw_o_iii_5006 real NOT NULL, --/U A --/D Equivalent width of O III at 5006 A 
  abs_o_iii_5006 real NOT NULL, --/U  --/D abs_o_iii_5006 
  detection_stat_o_iii_5006 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_o_iii_5006 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_o_iii_5006_1 real NOT NULL, --/F eqw_percentiles_o_iii_5006 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_o_iii_5006_2 real NOT NULL, --/F eqw_percentiles_o_iii_5006 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_o_iii_5006_3 real NOT NULL, --/F eqw_percentiles_o_iii_5006 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_o_iii_5006_1 real NOT NULL, --/F abs_percentiles_o_iii_5006 0 --/U  --/D abs_percentiles_o_iii_5006 (array element 1) 
  abs_percentiles_o_iii_5006_2 real NOT NULL, --/F abs_percentiles_o_iii_5006 1 --/U  --/D abs_percentiles_o_iii_5006 (array element 2) 
  abs_percentiles_o_iii_5006_3 real NOT NULL, --/F abs_percentiles_o_iii_5006 2 --/U  --/D abs_percentiles_o_iii_5006 (array element 3) 
  eqw_o_iii_4363 real NOT NULL, --/U A --/D Equivalent width of O III at 4363 A 
  abs_o_iii_4363 real NOT NULL, --/U  --/D abs_o_iii_4363 
  detection_stat_o_iii_4363 real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0 
  detection_raw_o_iii_4363 real NOT NULL, --/U  --/D Probability that feature is not noise (0: 
  eqw_percentiles_o_iii_4363_1 real NOT NULL, --/F eqw_percentiles_o_iii_4363 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_o_iii_4363_2 real NOT NULL, --/F eqw_percentiles_o_iii_4363 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_o_iii_4363_3 real NOT NULL, --/F eqw_percentiles_o_iii_4363 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_o_iii_4363_1 real NOT NULL, --/F abs_percentiles_o_iii_4363 0 --/U  --/D abs_percentiles_o_iii_4363 (array element 1) 
  abs_percentiles_o_iii_4363_2 real NOT NULL, --/F abs_percentiles_o_iii_4363 1 --/U  --/D abs_percentiles_o_iii_4363 (array element 2) 
  abs_percentiles_o_iii_4363_3 real NOT NULL, --/F abs_percentiles_o_iii_4363 2 --/U  --/D abs_percentiles_o_iii_4363 (array element 3) 
  eqw_li_i real NOT NULL, --/U A --/D Equivalent width of Li I at 6707 A 
  abs_li_i real NOT NULL, --/U  --/D abs_li_i 
  detection_stat_li_i real NOT NULL, --/U  --/D Detection probability (+1: absorption; 0: unde 
  detection_raw_li_i real NOT NULL, --/U  --/D Probability that feature is not noise (0: noise 
  eqw_percentiles_li_i_1 real NOT NULL, --/F eqw_percentiles_li_i 0 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 1) 
  eqw_percentiles_li_i_2 real NOT NULL, --/F eqw_percentiles_li_i 1 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 2) 
  eqw_percentiles_li_i_3 real NOT NULL, --/F eqw_percentiles_li_i 2 --/U  --/D (16, 50, 84)th percentiles of EW  (array element 3) 
  abs_percentiles_li_i_1 real NOT NULL, --/F abs_percentiles_li_i 0 --/U  --/D abs_percentiles_li_i (array element 1) 
  abs_percentiles_li_i_2 real NOT NULL, --/F abs_percentiles_li_i 1 --/U  --/D abs_percentiles_li_i (array element 2) 
  abs_percentiles_li_i_3 real NOT NULL, --/F abs_percentiles_li_i 2 --/U  --/D abs_percentiles_li_i (array element 3) 
  source_pk bigint NOT NULL, --/U  --/D source_pk 
  t_elapsed real NOT NULL, --/U s --/D Core-time elapsed on this analysis 
  t_overhead real NOT NULL, --/U s --/D Estimated core-time spent in overhads 
  tag varchar(1) NOT NULL, --/U  --/D Experiment tag for this result 
);