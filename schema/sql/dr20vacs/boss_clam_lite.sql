create table boss_clam_lite_fits (
    ------- 
    --/H Stellar Parameters from BOSS Spectra with The CLAM 
    --/T BOSS-CLAM is a data driven method that maps labels to NMF basis weights to 
    --/T forward model continuum normalized BOSS spectra. This model was training 
    --/T with labels from ASPCAP, BOSS-MINESweeper, wide binaries and a validation 
    --/T set of hot stars. This is the lite version of the VAC includes the 
    --/T inferened stellar parameters from all mwmStar BOSS spectra with snr > 10,  
    --/T a series of flags to clean the dataset, and a subset of meta-data from 
    --/T mwmAllStar. 
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier 
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier 
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier 
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
    g_mag real NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
    bp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
    rp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
    j_mag real NOT NULL, --/U mag --/D 2MASS J band magnitude 
    h_mag real NOT NULL, --/U mag --/D 2MASS H band magnitude 
    k_mag real NOT NULL, --/U mag --/D 2MASS K band magnitude 
    r_med_geo real NOT NULL, --/U pc --/D Median geometric distance 
    r_med_photogeo real NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
    bailer_jones_flags varchar(8) NOT NULL, --/U  --/D Bailer-Jones quality flags 
    ebv real NOT NULL, --/U mag --/D E(B-V) 
    e_ebv real NOT NULL, --/U mag --/D Error on E(B-V) 
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V) 
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits 
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits 
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits 
    telescope varchar(9) NOT NULL, --/U  --/D Short telescope name 
    n_good_visits int NOT NULL, --/U  --/D Number of 'good' BOSS visits 
    n_good_rvs int NOT NULL, --/U  --/D Number of 'good' BOSS radial velocities 
    v_rad real NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
    e_v_rad real NOT NULL, --/U km/s --/D Error on radial velocity 
    std_v_rad real NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio 
    teff float NOT NULL, --/U K --/D BOSS-CLAM effective temperature 
    logg float NOT NULL, --/U  --/D BOSS-CLAM log(g) 
    fe_h float NOT NULL, --/U  --/D BOSS-CLAM [Fe/H] 
    alpha_m float NOT NULL, --/U  --/D BOSS-CLAM [alpha/M] 
    param_covariance_1_1 float NOT NULL, --/F param_covariance 0 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 1_1) 
    param_covariance_1_2 float NOT NULL, --/F param_covariance 1 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 1_2) 
    param_covariance_1_3 float NOT NULL, --/F param_covariance 2 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 1_3) 
    param_covariance_1_4 float NOT NULL, --/F param_covariance 3 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 1_4) 
    param_covariance_2_1 float NOT NULL, --/F param_covariance 4 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 2_1) 
    param_covariance_2_2 float NOT NULL, --/F param_covariance 5 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 2_2) 
    param_covariance_2_3 float NOT NULL, --/F param_covariance 6 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 2_3) 
    param_covariance_2_4 float NOT NULL, --/F param_covariance 7 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 2_4) 
    param_covariance_3_1 float NOT NULL, --/F param_covariance 8 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 3_1) 
    param_covariance_3_2 float NOT NULL, --/F param_covariance 9 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 3_2) 
    param_covariance_3_3 float NOT NULL, --/F param_covariance 10 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 3_3) 
    param_covariance_3_4 float NOT NULL, --/F param_covariance 11 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 3_4) 
    param_covariance_4_1 float NOT NULL, --/F param_covariance 12 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 4_1) 
    param_covariance_4_2 float NOT NULL, --/F param_covariance 13 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 4_2) 
    param_covariance_4_3 float NOT NULL, --/F param_covariance 14 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 4_3) 
    param_covariance_4_4 float NOT NULL, --/F param_covariance 15 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 4_4) 
    rchi2 float NOT NULL, --/U  --/D Reduced chi^2 between BOSS spectrum and forward modeled CLAM spectrum 
    clam_flags bigint NOT NULL, --/U  --/D Bitmask indicating potentially unreliable or out-of-distribution BOSS-CLAM results. Flags include: IN_WD (0): likely white dwarf in mwm_wd not represented in the training set; IN_YSO (1): likely young stellar object in mwm_yso not represented in the training set; IN_OB (2): likely hot star in mwm_ob with unreliable [Fe/H] or [alpha/M] training coverage; FE_H_ALPHA_SUSPECT (3): Teff > 6500 K, where [Fe/H] and [alpha/M] are poorly constrained; BAD_SPEC_FIT (4): reduced chi^2 > 1 indicating poor forward-model fit; LOW_MASS_SUSPECT (5): Teff < 4000 K and [Fe/H] < -1 in sparsely sampled low-mass regime; FE_H_ALPHA_CORR (6): atypical correlation between [Fe/H], [alpha/M], and Teff; TEFF_LOGG_CORR (7): unphysical negative correlation between Teff and logg; LOW_MASS_TEFF_LOGG_CORR (8): weak Teff-logg correlation in low-mass stars (Teff < 4200 K); EXTREME_CORR (9): extreme correlations involving [alpha/M]; ALTER_CORR (10): alternating correlation structure relative to the bulk population.
    flag_warn bit NOT NULL, --/U  --/D If IN_OB or FE_H_ALPHA_SUSPECT is set 
    flag_bad bit NOT NULL --/U  --/D If IN_WD, IN_YSO, BAD_SPEC_FIT, LOW_MASS_SUSPECT, FE_H_ALPHA_CORR, TEFF_LOGG_CORR, LOW_MASS_TEFF_LOGG_CORR, EXTREME_CORR or ALTER_CORR is set 
);