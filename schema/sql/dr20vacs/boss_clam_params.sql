create table boss_clam_params (
    ------- 
    --/H Stellar Parameters from BOSS Spectra with The CLAM 
    --/T BOSS-CLAM is a data driven method that maps labels to NMF basis weights to 
    --/T forward model continuum normalized BOSS spectra. This model was training 
    --/T with labels from ASPCAP, BOSS-MINESweeper, wide binaries and a validation 
    --/T set of hot stars. This VAC includes the inferened stellar parameters from 
    --/T all mwmStar BOSS spectra with snr > 10, the forward modeled spectra at 
    --/T these parameters, a series of flags to clean the dataset, and all meta-data 
    --/T from mwmAllStar. 
    ------- 
    apogee_max_mjd int NOT NULL, --/U  --/D Maximum MJD of APOGEE visits  
    apogee_min_mjd int NOT NULL, --/U  --/D Minimum MJD of APOGEE visits  
    b real NOT NULL, --/U  --/D Galactic latitude [deg]  
    b_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic B-band (JKC) [mag]  
    b_jkc_mag_flag int NOT NULL, --/U  --/D B-band (JKC) is within valid range  
    bailer_jones_flags varchar(256) NOT NULL, --/U  --/D Bailer-Jones quality flags  
    bl_flg varchar(256) NOT NULL, --/U  --/D Number of components fit per band (JHK)  
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits  
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits  
    bp_mag real NOT NULL, --/U  --/D Gaia DR3 mean BP band magnitude [mag]  
    c_star real NOT NULL, --/U  --/D Quality parameter (see Riello et al. 2021)  
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0)  
    catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5)  
    catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0)  
    cc_flg varchar(256) NOT NULL, --/U  --/D Contamination and confusion flag  
    created varchar(256) NOT NULL, --/U  --/D Datetime when task record was created  
    crossmatch_flags bigint NOT NULL, --/U  --/D Astra internal crossmatch flag system  
    csf bigint NOT NULL, --/U  --/D Close source flag  
    d4_5m real NOT NULL, --/U  --/D Error on IRAC band 4.5 micron magnitude [mag]  
    dec real NOT NULL, --/U  --/D Declination [deg]  
    e_ebv real NOT NULL, --/U  --/D Error on E(B-V) [mag]  
    e_ebv_bayestar_2019 real NOT NULL, --/U  --/D Error on Bayestar 2019 E(B-V) [mag]  
    e_ebv_edenhofer_2023 real NOT NULL, --/U  --/D Error on Edenhofer et al. (2023) E(B-V) [mag]  
    e_ebv_rjce_allwise real NOT NULL, --/U  --/D Error on RJCE AllWISE E(B-V) [mag]  
    e_ebv_rjce_glimpse real NOT NULL, --/U  --/D Error on RJCE GLIMPSE E(B-V) [mag]  
    e_ebv_sfd real NOT NULL, --/U  --/D Error on E(B-V) from SFD [mag]  
    e_ebv_zhang_2023 real NOT NULL, --/U  --/D Error on E(B-V) from Zhang et al. (2023) [mag]  
    e_h_mag real NOT NULL, --/U  --/D Error on 2MASS H band magnitude [mag]  
    e_j_mag real NOT NULL, --/U  --/D Error on 2MASS J band magnitude [mag]  
    e_k_mag real NOT NULL, --/U  --/D Error on 2MASS K band magnitude [mag]  
    e_plx real NOT NULL, --/U  --/D Error on parallax [mas]  
    e_pmde real NOT NULL, --/U  --/D Error on proper motion in DEC [mas/yr]  
    e_pmra real NOT NULL, --/U  --/D Error on proper motion in RA [mas/yr]  
    e_v_rad real NOT NULL, --/U  --/D Error on radial velocity [km/s]  
    e_w1_mag real NOT NULL, --/U  --/D Error on W1 magnitude  
    e_w2_mag real NOT NULL, --/U  --/D Error on W2 magnitude  
    ebv real NOT NULL, --/U  --/D E(B-V) [mag]  
    ebv_bayestar_2019 real NOT NULL, --/U  --/D E(B-V) from Bayestar 2019 [mag]  
    ebv_edenhofer_2023 real NOT NULL, --/U  --/D E(B-V) from Edenhofer et al. (2023) [mag]  
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V)  
    ebv_rjce_allwise real NOT NULL, --/U  --/D E(B-V) from RJCE AllWISE [mag]  
    ebv_rjce_glimpse real NOT NULL, --/U  --/D E(B-V) from RJCE GLIMPSE [mag]  
    ebv_sfd real NOT NULL, --/U  --/D E(B-V) from SFD [mag]  
    ebv_zhang_2023 real NOT NULL, --/U  --/D E(B-V) from Zhang et al. (2023) [mag]  
    filetype varchar(256) NOT NULL, --/U  --/D SDSS file type that stores this spectrum  
    g_mag real NOT NULL, --/U  --/D Gaia DR3 mean G band magnitude [mag]  
    g_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic g-band (SDSS) [mag]  
    g_sdss_mag_flag int NOT NULL, --/U  --/D g-band (SDSS) is within valid range  
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier  
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    gaia_e_v_rad real NOT NULL, --/U  --/D Error on Gaia radial velocity [km/s]  
    gaia_v_rad real NOT NULL, --/U  --/D Gaia radial velocity [km/s]  
    gri_gaia_transform_flags bigint NOT NULL, --/U  --/D Flags for provenance of ugriz photometry  
    h_mag real NOT NULL, --/U  --/D 2MASS H band magnitude [mag]  
    healpix int NOT NULL, --/U  --/D HEALPix (128 side)  
    i_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic I-band (JKC) [mag]  
    i_jkc_mag_flag int NOT NULL, --/U  --/D I-band (JKC) is within valid range  
    i_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic i-band (SDSS) [mag]  
    i_sdss_mag_flag int NOT NULL, --/U  --/D i-band (SDSS) is within valid range  
    j_mag real NOT NULL, --/U  --/D 2MASS J band magnitude [mag]  
    k_mag real NOT NULL, --/U  --/D 2MASS K band magnitude [mag]  
    l real NOT NULL, --/U  --/D Galactic longitude [deg]  
    lead varchar(256) NOT NULL, --/U  --/D Lead catalog used for cross-match  
    mag4_5 real NOT NULL, --/U  --/D IRAC band 4.5 micron magnitude [mag]  
    max_mjd int NOT NULL, --/U  --/D Maximum MJD of visits  
    median_e_v_rad real NOT NULL, --/U  --/D Median error in radial velocity [km/s]  
    mf4_5 bigint NOT NULL, --/U  --/D Flux calculation method flag  
    min_mjd int NOT NULL, --/U  --/D Minimum MJD of visits  
    modified varchar(256) NOT NULL, --/U  --/D Datetime when task record was modified  
    n_apogee_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID  
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    n_good_rvs int NOT NULL, --/U  --/D Number of 'good' BOSS radial velocities  
    n_good_visits int NOT NULL, --/U  --/D Number of 'good' BOSS visits  
    n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5  
    n_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    nmf_flags bigint NOT NULL, --/U  --/D NMF Continuum method flags  
    nmf_rchi2 real NOT NULL, --/U  --/D Reduced chi-square value of NMF continuum fit  
    ph_qual varchar(256) NOT NULL, --/U  --/D 2MASS photometric quality flag  
    plx real NOT NULL, --/U  --/D Parallax [mas]  
    pmde real NOT NULL, --/U  --/D Proper motion in DEC [mas/yr]  
    pmra real NOT NULL, --/U  --/D Proper motion in RA [mas/yr]  
    r_hi_geo real NOT NULL, --/U  --/D 84th percentile of geometric distance [pc]  
    r_hi_photogeo real NOT NULL, --/U  --/D 84th percentile of photogeometric distance [pc]  
    r_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic R-band (JKC) [mag]  
    r_jkc_mag_flag int NOT NULL, --/U  --/D R-band (JKC) is within valid range  
    r_lo_geo real NOT NULL, --/U  --/D 16th percentile of geometric distance [pc]  
    r_lo_photogeo real NOT NULL, --/U  --/D 16th percentile of photogeometric distance [pc]  
    r_med_geo real NOT NULL, --/U  --/D Median geometric distance [pc]  
    r_med_photogeo real NOT NULL, --/U  --/D 50th percentile of photogeometric distance [pc]  
    r_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic r-band (SDSS) [mag]  
    r_sdss_mag_flag int NOT NULL, --/U  --/D r-band (SDSS) is within valid range  
    ra real NOT NULL, --/U  --/D Right ascension [deg]  
    release varchar(256) NOT NULL, --/U  --/D SDSS release  
    rms_f4_5 real NOT NULL, --/U  --/D RMS deviations from final flux [mJy]  
    rp_mag real NOT NULL, --/U  --/D Gaia DR3 mean RP band magnitude [mag]  
    run2d varchar(256) NOT NULL, --/U  --/D BOSS data reduction pipeline version  
    sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3)  
    sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3)  
    sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3)  
    sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG)  
    sdss4_apogee_id varchar(256) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier  
    sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags  
    sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2)  
    sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2)  
    sdss5_dr19_apogee_flag bit NOT NULL, --/U  --/D If entry has APOGEE spectrum in DR19  
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio  
    source bigint NOT NULL, --/U  --/D Unique source primary key  
    spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key  
    sqf_4_5 bigint NOT NULL, --/U  --/D Source quality flag for IRAC band 4.5 micron  
    std_v_rad real NOT NULL, --/U  --/D Standard deviation of visit V_RAD [km/s]  
    telescope varchar(256) NOT NULL, --/U  --/D Short telescope name  
    tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier  
    u_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic U-band (JKC) [mag]  
    u_jkc_mag_flag int NOT NULL, --/U  --/D U-band (JKC) is within valid range  
    u_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic u-band (SDSS) [mag]  
    u_sdss_mag_flag int NOT NULL, --/U  --/D u-band (SDSS) is within valid range  
    v_astra varchar(256) NOT NULL, --/U  --/D Astra version  
    v_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic V-band (JKC) [mag]  
    v_jkc_mag_flag int NOT NULL, --/U  --/D V-band (JKC) is within valid range  
    v_rad real NOT NULL, --/U  --/D Barycentric rest frame radial velocity [km/s]  
    version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting  
    w1_dflux real NOT NULL, --/U  --/D Error on W1 flux [Vega nMgy]  
    w1_flux real NOT NULL, --/U  --/D W1 flux [Vega nMgy]  
    w1_frac real NOT NULL, --/U  --/D Fraction of W1 flux from this object  
    w1_mag real NOT NULL, --/U  --/D W1 magnitude  
    w1aflags bigint NOT NULL, --/U  --/D Additional flags for W1  
    w1uflags bigint NOT NULL, --/U  --/D unWISE flags for W1  
    w2_dflux real NOT NULL, --/U  --/D Error on W2 flux [Vega nMgy]  
    w2_flux real NOT NULL, --/U  --/D W2 flux [Vega nMgy]  
    w2_frac real NOT NULL, --/U  --/D Fraction of W2 flux from this object  
    w2_mag real NOT NULL, --/U  --/D W2 magnitude [Vega]  
    w2aflags bigint NOT NULL, --/U  --/D Additional flags for W2  
    w2uflags bigint NOT NULL, --/U  --/D unWISE flags for W2  
    xcsao_e_fe_h real NOT NULL, --/U  --/D Error on [Fe/H] [dex]  
    xcsao_e_logg real NOT NULL, --/U  --/D Error on surface gravity [log10(cm/s^2)]  
    xcsao_e_teff real NOT NULL, --/U  --/D Error on stellar effective temperature [K]  
    xcsao_fe_h real NOT NULL, --/U  --/D [Fe/H] [dex]  
    xcsao_logg real NOT NULL, --/U  --/D Surface gravity [log10(cm/s^2)]  
    xcsao_meanrxc real NOT NULL, --/U  --/D Cross-correlation R-value (1979AJ.....84.1511T)  
    xcsao_teff real NOT NULL, --/U  --/D Stellar effective temperature [K]  
    y_ps1_mag real NOT NULL, --/U  --/D Gaia XP synthetic Y-band (PS1) [mag]  
    y_ps1_mag_flag int NOT NULL, --/U  --/D Y-band (PS1) is within valid range  
    z_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic z-band (SDSS) [mag]  
    z_sdss_mag_flag int NOT NULL, --/U  --/D z-band (SDSS) is within valid range  
    zgr_chi2 real NOT NULL, --/U  --/D Chi-square value  
    zgr_e real NOT NULL, --/U  --/D Extinction [mag]  
    zgr_e_e real NOT NULL, --/U  --/D Error on extinction [mag]  
    zgr_e_fe_h real NOT NULL, --/U  --/D Error on [Fe/H] [dex]  
    zgr_e_logg real NOT NULL, --/U  --/D Error on surface gravity [log10(cm/s^2)]  
    zgr_e_plx real NOT NULL, --/U  --/D Error on parallax [mas] (Gaia DR3)  
    zgr_e_teff real NOT NULL, --/U  --/D Error on stellar effective temperature [K]  
    zgr_fe_h real NOT NULL, --/U  --/D [Fe/H] [dex]  
    zgr_fe_h_confidence real NOT NULL, --/U  --/D Confidence estimate in FE_H  
    zgr_ln_prior real NOT NULL, --/U  --/D Log prior probability  
    zgr_logg real NOT NULL, --/U  --/D Surface gravity [log10(cm/s^2)]  
    zgr_logg_confidence real NOT NULL, --/U  --/D Confidence estimate in LOGG  
    zgr_plx real NOT NULL, --/U  --/D Parallax [mas] (Gaia DR3)  
    zgr_quality_flags bigint NOT NULL, --/U  --/D Quality flags  
    zgr_teff real NOT NULL, --/U  --/D Stellar effective temperature [K]  
    zgr_teff_confidence real NOT NULL, --/U  --/D Confidence estimate in TEFF  
    zwarning_flags bigint NOT NULL --/U  --/D BOSS DRP warning flags  
);
