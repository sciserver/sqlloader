--// Created from HDU 1 in /uufs/chpc.utah.edu/common/home/sdss/dr20/spectro/astra/0.8.1/summary/mwmAllVisit-0.8.1.fits.gz

CREATE TABLE mwm_boss_allvisit (
    ------- 
    --/H MWM data for each visit from BOSS 
    --/T MWM data for each visit from BOSS 
    ------- 
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
    sdss5_dr19_apogee_flag bit NOT NULL, --/U  --/D If entry has APOGEE spectrum in DR19 
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
    modified varchar(26) NOT NULL, --/U  --/D Datetime when task record was modified 
    spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key 
    source bigint NOT NULL, --/U  --/D Unique source primary key 
    release varchar(5) NOT NULL, --/U  --/D SDSS release 
    filetype varchar(8) NOT NULL, --/U  --/D SDSS file type that stores this spectrum 
    run2d varchar(6) NOT NULL, --/U  --/D BOSS data reduction pipeline version 
    mjd int NOT NULL, --/U  --/D Modified Julian date of observation 
    fieldid int NOT NULL, --/U  --/D Field identifier 
    spec_file varchar(41) NOT NULL, --/U  --/D BOSS specFull basename 
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
    telescope varchar(6) NOT NULL, --/U  --/D Short telescope name 
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
    delta_ra_1 real NOT NULL, --/F delta_ra 0 --/U  --/D Offset in right ascension  (array element 1) 
    delta_ra_2 real NOT NULL, --/F delta_ra 1 --/U  --/D Offset in right ascension  (array element 2) 
    delta_ra_3 real NOT NULL, --/F delta_ra 2 --/U  --/D Offset in right ascension  (array element 3) 
    delta_ra_4 real NOT NULL, --/F delta_ra 3 --/U  --/D Offset in right ascension  (array element 4) 
    delta_ra_5 real NOT NULL, --/F delta_ra 4 --/U  --/D Offset in right ascension  (array element 5) 
    delta_ra_6 real NOT NULL, --/F delta_ra 5 --/U  --/D Offset in right ascension  (array element 6) 
    delta_ra_7 real NOT NULL, --/F delta_ra 6 --/U  --/D Offset in right ascension  (array element 7) 
    delta_ra_8 real NOT NULL, --/F delta_ra 7 --/U  --/D Offset in right ascension  (array element 8) 
    delta_ra_9 real NOT NULL, --/F delta_ra 8 --/U  --/D Offset in right ascension  (array element 9) 
    delta_ra_10 real NOT NULL, --/F delta_ra 9 --/U  --/D Offset in right ascension  (array element 10) 
    delta_ra_11 real NOT NULL, --/F delta_ra 10 --/U  --/D Offset in right ascension  (array element 11) 
    delta_ra_12 real NOT NULL, --/F delta_ra 11 --/U  --/D Offset in right ascension  (array element 12) 
    delta_ra_13 real NOT NULL, --/F delta_ra 12 --/U  --/D Offset in right ascension  (array element 13) 
    delta_ra_14 real NOT NULL, --/F delta_ra 13 --/U  --/D Offset in right ascension  (array element 14) 
    delta_ra_15 real NOT NULL, --/F delta_ra 14 --/U  --/D Offset in right ascension  (array element 15) 
    delta_ra_16 real NOT NULL, --/F delta_ra 15 --/U  --/D Offset in right ascension  (array element 16) 
    delta_ra_17 real NOT NULL, --/F delta_ra 16 --/U  --/D Offset in right ascension  (array element 17) 
    delta_ra_18 real NOT NULL, --/F delta_ra 17 --/U  --/D Offset in right ascension  (array element 18) 
    delta_dec_1 real NOT NULL, --/F delta_dec 0 --/U  --/D Offset in declination  (array element 1) 
    delta_dec_2 real NOT NULL, --/F delta_dec 1 --/U  --/D Offset in declination  (array element 2) 
    delta_dec_3 real NOT NULL, --/F delta_dec 2 --/U  --/D Offset in declination  (array element 3) 
    delta_dec_4 real NOT NULL, --/F delta_dec 3 --/U  --/D Offset in declination  (array element 4) 
    delta_dec_5 real NOT NULL, --/F delta_dec 4 --/U  --/D Offset in declination  (array element 5) 
    delta_dec_6 real NOT NULL, --/F delta_dec 5 --/U  --/D Offset in declination  (array element 6) 
    delta_dec_7 real NOT NULL, --/F delta_dec 6 --/U  --/D Offset in declination  (array element 7) 
    delta_dec_8 real NOT NULL, --/F delta_dec 7 --/U  --/D Offset in declination  (array element 8) 
    delta_dec_9 real NOT NULL, --/F delta_dec 8 --/U  --/D Offset in declination  (array element 9) 
    delta_dec_10 real NOT NULL, --/F delta_dec 9 --/U  --/D Offset in declination  (array element 10) 
    delta_dec_11 real NOT NULL, --/F delta_dec 10 --/U  --/D Offset in declination  (array element 11) 
    delta_dec_12 real NOT NULL, --/F delta_dec 11 --/U  --/D Offset in declination  (array element 12) 
    delta_dec_13 real NOT NULL, --/F delta_dec 12 --/U  --/D Offset in declination  (array element 13) 
    delta_dec_14 real NOT NULL, --/F delta_dec 13 --/U  --/D Offset in declination  (array element 14) 
    delta_dec_15 real NOT NULL, --/F delta_dec 14 --/U  --/D Offset in declination  (array element 15) 
    delta_dec_16 real NOT NULL, --/F delta_dec 15 --/U  --/D Offset in declination  (array element 16) 
    delta_dec_17 real NOT NULL, --/F delta_dec 16 --/U  --/D Offset in declination  (array element 17) 
    delta_dec_18 real NOT NULL, --/F delta_dec 17 --/U  --/D Offset in declination  (array element 18) 
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
);
