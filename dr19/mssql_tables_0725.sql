

DROP TABLE IF EXISTS dbo.mos_allstar_dr17_synspec_rev1
CREATE TABLE dbo.mos_allstar_dr17_synspec_rev1 (
----------------------------------------------------------------------
--/H The APOGEE All-Star DR17 synspec catalogue.
----------------------------------------------------------------------
    [file] varchar(500), --/D apStar [file] name 
    apogee_id varchar(500), --/D TMASS-STYLE object name 
    target_id varchar(500), --/D target id 
    apstar_id varchar(500) NOT NULL, --/D Unique ASPCAP identifier: apogee.[ns].[sc].RESULTS_VERS.LOC.STAR 
    aspcap_id varchar(500), --/D Unique apStar identifier: apogee.[ns].[sc].APSTAR_VERS.LOC.STAR, where [ns] is for APOGEE North/South, [sc] is for survey/commissioning 
    telescope varchar(500), --/D String representation of of telescope used for observation (apo25m, lco25m, apo1m) 
    location_id integer, --/D Field Location ID 
    field varchar(500), --/D Field name 
    alt_id varchar(500), --/D Alternate object name, if any 
    ra double precision, --/U degrees --/D Right ascension (J2000) 
    "dec" double precision, --/U degrees --/D Declination (J2000) 
    glon double precision, --/U degrees --/D Galactic longitude 
    glat double precision, --/U degrees --/D Galactic latitude 
    j real, --/U mag --/D 2MASS J (bad=99) 
    j_err real, --/U mag --/D Uncertainty in 2MASS J 
    h real, --/U mag --/D 2MASS H (bad=99) 
    h_err real, --/U mag --/D Uncertainty in 2MASS H 
    k real, --/U mag --/D 2MASS Ks (bad=99) 
    k_err real, --/U mag --/D Uncertainty in 2MASS Ks 
    src_h varchar(500), --/D Source of H-Band photometry for targeting 
    wash_m real, --/D Washington M mag 
    wash_m_err real, --/D Washington M mag error 
    wash_t2 real, --/D Washington T2 mag 
    wash_t2_err real, --/D Washington T2 mag error 
    ddo51 real, --/D DDO 51 mag 
    ddo51_err real, --/D DDO 51 mag error 
    irac_3_6 real, --/D IRAC 3.6micron mag 
    irac_3_6_err real, --/D IRAC 3.6micron mag error 
    irac_4_5 real, --/D IRAC 4.5micron mag 
    irac_4_5_err real, --/D IRAC 4.5micron mag error 
    irac_5_8 real, --/D IRAC 5.8 micron mag 
    irac_5_8_err real, --/D IRAC 5.8 micron mag error 
    irac_8_0 real, --/D IRAC 8.0 micron mag 
    irac_8_0_err real, --/D IRAC 8.0 micron mag error 
    wise_4_5 real, --/D WISE 4.5 micron mag 
    wise_4_5_err real, --/D WISE 4.5 micron mag error 
    targ_4_5 real, --/D 4.5 micron mag adopted for dereddening for targeting 
    targ_4_5_err real, --/D 4.5 micron mag adopted for dereddening for targeting, error 
    wash_ddo51_giant_flag integer, --/D Flagged as a giant for targeting purposes based on Washington/DDO 51 photometry 
    wash_ddo51_star_flag integer, --/D Flagged as a starfor targeting purposes based on Washington/DDO 51 photometry 
    targ_pmra real, --/D RA proper motion used for targeting 
    targ_pmdec real, --/D DEC proper motion used for targeting 
    targ_pm_src varchar(500), --/D Source of proper motion used for targeting 
    ak_targ real, --/D K-band extinction adopted for targetting 
    ak_targ_method varchar(500), --/D Method used to get targetting extinction 
    ak_wise real, --/D WISE all-sky K-band extinction 
    sfd_ebv real, --/D SFD reddening 
    apogee_target1 integer, --/D Bitwise OR of first APOGEE-1 target flag of all visits, see bitmask definitions. 
    apogee_target2 integer, --/D Bitwise OR of second APOGEE-1 target flag of all visits, see bitmask definitions 
    apogee2_target1 integer, --/D Bitwise OR of first APOGEE-2 target flag of all visits, see bitmask definitions. 
    apogee2_target2 integer, --/D Bitwise OR of second APOGEE-2 target flag of all visits, see bitmask definitions 
    apogee2_target3 integer, --/D Bitwise OR of third APOGEE-2 target flag of all visits, see bitmask definitions 
    apogee2_target4 integer, --/D Bitwise OR of fourth APOGEE-2 target flag of all visits, see bitmask definitions 
    targflags varchar(500), --/D Verbose/varchar(500) form of APOGEE-1 target flags 
    survey varchar(500), --/D Survey-associated with object: apogee, apo1m, apogee-marvels, apogee2, apogee2-manga, manga-apogee2 
    programname varchar(500), --/D Program name associated with object, when available 
    nvisits integer, --/D Number of visits into combined spectrum 
    snr real, --/D S/N estimate 
    snrev real, --/D Revised S/N estimate (avoiding persistence issues) 
    starflag bigint, --/D Flag for star condition taken from bitwise OR of individual visits, see bitmask definitions 
    starflags varchar(500), --/D Verbose/varchar(500) form of STARFLAG 
    andflag bigint, --/D Flag for star condition taken from bitwise AND of individual visits, see bitmask definitions 
    andflags varchar(500), --/D Verbose/varchar(500) form of ANDFLAG 
    vhelio_avg real, --/U km/s --/D Average solar system barycentric radial velocity, weighted by S/N, using RVs determined from cross-correlation of individual spectra with combined spectrum 
    vscatter real, --/U km/s --/D Scatter of individual visit RVs around average 
    verr real, --/U km/s --/D Uncertainty in VHELIO_AVG from the S/N-weighted individual RVs 
    rv_teff real, --/U K --/D Teff of best-fit synthetic spectrum from RV fit (NOT ASPCAP!) 
    rv_logg real, --/U log (cgs) --/D log g of best-fit synthetic spectrum from RV fit (NOT ASPCAP!) 
    rv_feh real, --/D [Fe/H] of best-fit synthetic spectrum from RV fit (NOT ASPCAP!) 
    rv_alpha real, --/D [alpha/M] of best-fit synthetic spectrum from RV fit (NOT ASPCAP!) 
    rv_carb real, --/D [C/M] of best-fit synthetic spectrum from RV fit (NOT ASPCAP!) 
    rv_chi2 real,
    rv_ccfwhm real, --/U km/s --/D FWHM of cross-correlation peak from combined vs best-match synthetic spectrum 
    rv_autofwhm real, --/U km/s --/D FWHM of auto-correlation of best-match synthetic spectrum 
    rv_flag integer, --/D bitmask for RV determination 
    n_components integer, --/D Number of components identified from RV cross-correlations 
    meanfib real, --/D Mean fiber number of the set of observations 
    sigfib real, --/D Dispersion in fiber number 
    min_h real, --/D Bright H limit for target selection for this object 
    max_h real, --/D Faint H limit for target selection for this object 
    min_jk real, --/D Blue (J-K) limit for target selection for this object 
    max_jk real, --/D Red (J-K) limit for target selection for this object 
    gaiaedr3_source_id bigint, --/D GAIA source ID from GAIA EDR3 
    gaiaedr3_parallax real, --/U mas --/D GAIA parallax from GAIA EDR3 
    gaiaedr3_parallax_error real, --/U mas --/D GAIA parallax uncertainty GAIA EDR3 
    gaiaedr3_pmra real, --/U mas/yr --/D GAIA proper motion in RA from GAIA EDR3 
    gaiaedr3_pmra_error real, --/U mas/yr --/D GAIA uncertainty in proper motion in RA from GAIA EDR3 
    gaiaedr3_pmdec real, --/U mas/yr --/D GAIA proper motion in DEC from GAIA EDR3 
    gaiaedr3_pmdec_error real, --/U mas/yr --/D GAIA uncdertainty in proper motion in DEC from GAIA EDR3 
    gaiaedr3_phot_g_mean_mag real, --/D GAIA g mag from GAIA EDR3 
    gaiaedr3_phot_bp_mean_mag real, --/D GAIA Bp mag from GAIA EDR3 
    gaiaedr3_phot_rp_mean_mag real, --/D GAIA Rp mag from GAIA EDR3 
    gaiaedr3_dr2_radial_velocity real, --/U km/s --/D GAIA radial velocity from GAIA EDR3 
    gaiaedr3_dr2_radial_velocity_error real, --/U km/s --/D GAIA uncertainty in radial velocity from GAIA EDR3 
    gaiaedr3_r_med_geo real, --/U pc --/D GAIA Bailer-Jones GEO distance estimate r_est from GAIA EDR3 
    gaiaedr3_r_lo_geo real, --/U pc --/D GAIA Bailer-Jones 16th GEO percentile distance r_lo from GAIA EDR3 
    gaiaedr3_r_hi_geo real, --/U pc --/D GAIA Bailer-Jones 84th GEO percentile distance r_hi from GAIA EDR3 
    gaiaedr3_r_med_photogeo real, --/U pc --/D GAIA Bailer-Jones PHOTOGEO distance estimate r_est from GAIA EDR3 
    gaiaedr3_r_lo_photogeo real, --/U pc --/D GAIA Bailer-Jones 16th percentile PHOTOGEO distance r_lo from GAIA EDR3 
    gaiaedr3_r_hi_photogeo real, --/U pc --/D GAIA Bailer-Jones 84th percentile PHOTOGEO distance r_hi from GAIA EDR3 
    aspcap_grid varchar(500), --/D ASPCAP grid of best-fitting spectrum 
    fparam_grid varchar(500), --/D Raw FERRE parameters for each grid for which fit was performed (see GRIDS tag in HDU3 for grid names 
    chi2_grid varchar(500), --/D CHI2 for each grid for which fit was performed (see GRIDS tag in HDU3 for grid names 
    fparam varchar(500), --/D Output parameter array from ASPCAP stellar parameters fit, in order given in PARAM_SYMBOL array in HDU3: Teff, logg, vmicro, [M/H], [C/M], [N/M], [alpha/M], vsini/vmacro 
    fparam_cov varchar(500), --/D Covariance of fitted parameters from FERRE 
    aspcap_chi2 real, --/D Chi^2 from ASPCAP fit 
    param varchar(500), --/D Empirically calibrated parameter array, using ASPCAP stellar parameters fit + calibrations, in order given in PARAM_SYMBOL array in HDU3: Teff, logg, vmicro, [M/H], [C/M], [N/M], [alpha/M], vsini/vmacro 
    param_cov varchar(500), --/D Covariance of calibrated parameters, but with only diagonal elements from "external" uncertainty estimation 
    paramflag varchar(500), --/D Individual parameter flag for ASPCAP analysis, see bitmask definitions 
    aspcapflag bigint, --/D Flag for ASPCAP analysis, see bitmask definitions 
    aspcapflags varchar(500), --/D Verbose/varchar(500) form ASPCAPFLAG 
    frac_badpix real, --/D Fraction of bad pixels in spectrum 
    frac_lowsnr real, --/D Fraction of low S/N pixels in spectrum 
    frac_sigsky real, --/D Fraction of SIG_SKYLINE pixels in spectrum 
    felem varchar(500), --/D Output individual element array from ASPCAP stellar abundances fit, in order given in ELEM_SYMBOL array in HDU3 
    felem_err varchar(500), --/D Uncertainty from FERRE in individual element abundances 
    x_h varchar(500), --/D Empirically calibrated individual element array, using ASPCAP stellar abundances fit + calibrations, all expressed in logarithmic abundance relative to H ([X/H]), in order given in ELEM_SYMBOL array in HDU3 
    x_h_err varchar(500), --/D Empirical uncertainties in [X/H], derived from repeat observations of stars 
    x_m varchar(500), --/D Empirically calibrated individual element array, using ASPCAP stellar abundances fit + calibrations, all expressed in logarithmic abundance relative to M ([X/M]) in order given in ELEM_SYMBOL array in HDU3 
    x_m_err varchar(500), --/D Empirical uncertainties in [X/M], derived from repeat observations of stars 
    elem_chi2 varchar(500), --/D Chi^2 from ASPCAP fit of individual abundances 
    elemfrac varchar(500),
    elemflag varchar(500), --/D Flags for analysis of individual abundances, see bitmask definitions 
    extratarg integer, --/D Bitmask which identifies main survey targets and other classes, see bitmask definitions. 
    memberflag bigint, --/D memberflag missing missing missing 
    member varchar(500), --/D member missing missing missing 
    x_h_spec varchar(500), --/D x_h_spec missing missing missing 
    x_m_spec varchar(500), --/D x_m_spec missing missing missing 
    teff real, --/U K --/D Teff from ASPCAP analysis of combined spectrum (from PARAM) 
    teff_err real, --/U K --/D Teff uncertainty (from PARAM_COV) 
    logg real, --/U log (cgs) --/D log g from ASPCAP analysis of combined spectrum (from PARAM) 
    logg_err real, --/U log (cgs) --/D log g uncertainty (from PARAM_COV) 
    m_h real, --/U dex --/D [Z/H] from ASPCAP analysis of combined spectrum (from PARAM) 
    m_h_err real, --/U dex --/D [Z/H] uncertainty (from PARAM_COV) 
    alpha_m real, --/U dex --/D [alpha/M] from ASPCAP analysis of combined spectrum (from PARAM) 
    alpha_m_err real, --/U dex --/D [alpha/M] uncertainty (from PARAM_COV) 
    vmicro real, --/U (cgs) --/D microturbulent velocity (fit for dwarfs, f(log g) for giants) 
    vmacro real, --/U (cgs) --/D macroturbulent velocity (f(log Teff, [M/H]) for giants) 
    vsini real, --/U (cgs) --/D rotational+macroturbulent velocity (fit for dwarfs) 
    teff_spec real, --/U K --/D ASPCAP spectroscopic Teff (duplicated from FPARAM[0] for convenience) 
    logg_spec real, --/U log (cgs) --/D ASPCAP spectroscopic surface gravity (duplicated from FPARAM[1] for convenience) 
    c_fe real,
    c_fe_spec real,
    c_fe_err real, --/D [C/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    c_fe_flag integer, --/D [C/Fe] flag 
    ci_fe real, --/D [Ci/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    ci_fe_spec real,
    ci_fe_err real, --/D [Ci/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    ci_fe_flag integer, --/D [Ci/Fe] flag 
    n_fe real, --/D [N/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    n_fe_spec real,
    n_fe_err real, --/D [N/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    n_fe_flag integer, --/D [N/Fe] flag 
    o_fe real, --/D [O/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    o_fe_spec real,
    o_fe_err real, --/D [O/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    o_fe_flag integer, --/D [O/Fe] flag 
    na_fe real, --/D [Na/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    na_fe_spec real,
    na_fe_err real, --/D [Na/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    na_fe_flag integer, --/D [Na/Fe] flag 
    mg_fe real, --/D [Mg/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    mg_fe_spec real,
    mg_fe_err real, --/D [Mg/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    mg_fe_flag integer, --/D [Mg/Fe] flag 
    al_fe real, --/D [Al/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    al_fe_spec real,
    al_fe_err real, --/D [Al/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    al_fe_flag integer, --/D [Al/Fe] flag 
    si_fe real, --/D [Si/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    si_fe_spec real,
    si_fe_err real, --/D [Si/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    si_fe_flag integer, --/D [Si/Fe] flag 
    p_fe real, --/D [P/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    p_fe_spec real,
    p_fe_err real, --/D [P/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    p_fe_flag integer, --/D [P/Fe] flag 
    s_fe real, --/D [S/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    s_fe_spec real,
    s_fe_err real, --/D [S/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    s_fe_flag integer, --/D [S/Fe] flag 
    k_fe real, --/D [K/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    k_fe_spec real,
    k_fe_err real, --/D [K/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    k_fe_flag integer, --/D [K/Fe] flag 
    ca_fe real, --/D [Ca/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    ca_fe_spec real,
    ca_fe_err real, --/D [Ca/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    ca_fe_flag integer, --/D [Ca/Fe] flag 
    ti_fe real, --/D [Ti/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    ti_fe_spec real,
    ti_fe_err real, --/D [Ti/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    ti_fe_flag integer, --/D [Ti/Fe] flag 
    tiii_fe real, --/D [TiII/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    tiii_fe_spec real,
    tiii_fe_err real, --/D [TiII/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    tiii_fe_flag integer, --/D [TiII/Fe] flag 
    v_fe real, --/D c_fe - [C/Fe] from ASPCAP analysis of combined spectrum (from X_M)  --/D [V/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    v_fe_spec real,
    v_fe_err real, --/D [V/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    v_fe_flag integer, --/D [V/Fe] flag 
    cr_fe real, --/D [Cr/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    cr_fe_spec real,
    cr_fe_err real, --/D [Cr/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    cr_fe_flag integer, --/D [Cr/Fe] flag 
    mn_fe real, --/D [Mn/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    mn_fe_spec real,
    mn_fe_err real, --/D [Mn/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    mn_fe_flag integer, --/D [Mn/Fe] flag 
    fe_h real, --/D [Fe/H] from ASPCAP analysis of combined spectrum (from X_M) 
    fe_h_spec real,
    fe_h_err real, --/D [Fe/H] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    fe_h_flag integer, --/D [Fe/H] flag 
    co_fe real, --/D [Co/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    co_fe_spec real,
    co_fe_err real, --/D [Co/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    co_fe_flag integer, --/D [Co/Fe] flag 
    ni_fe real, --/D [Ni/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    ni_fe_spec real,
    ni_fe_err real, --/D [Ni/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    ni_fe_flag integer, --/D [Ni/Fe] flag 
    cu_fe real, --/D [Cu/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    cu_fe_spec real,
    cu_fe_err real, --/D [Cu/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    cu_fe_flag integer, --/D [Cu/Fe] flag 
    ce_fe real, --/D [Ce/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    ce_fe_spec real,
    ce_fe_err real, --/D [Ce/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    ce_fe_flag integer, --/D [Ce/Fe] flag 
    yb_fe real, --/D [Yb/Fe] from ASPCAP analysis of combined spectrum (from X_M) 
    yb_fe_spec real,
    yb_fe_err real, --/D [Yb/Fe] uncertainty from ASPCAP analysis of combined spectrum (from X_M) 
    yb_fe_flag integer, --/D [Yb/Fe] flag 
    visit_pk varchar(500), --/D Index of visits (used in combined spectrum) in allVisit [file] 
    twomass_designation varchar(500) --/D Unique idetni from 2MASS 
);
