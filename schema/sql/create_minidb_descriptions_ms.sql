

--
-- Name: dr19_allstar_dr17_synspec_rev1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_allstar_dr17_synspec_rev1 (
----------------------------------------------------------------------
--/H The APOGEE All-Star DR17 synspec catalogue.
----------------------------------------------------------------------
    filename text, --/D apStar file name
    apogee_id text, --/D TMASS-STYLE object name
    target_id text, --/D target id
    apstar_id text NOT NULL, --/U ns].[sc --/D Unique ASPCAP identifier: apogee.
    aspcap_id text, --/U ns].[sc].APSTAR_VERS.LOC.STAR, where [ns] is for APOGEE North/South, [sc --/D Unique apStar identifier: apogee.
    telescope text, --/D String representation of of telescope used for observation (apo25m, lco25m, apo1m)
    location_id integer, --/D Field Location ID
    field text, --/D Field name
    alt_id text, --/D Alternate object name, if any
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
    src_h text, --/D Source of H-Band photometry for targeting
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
    targ_pm_src text, --/D Source of proper motion used for targeting
    ak_targ real, --/D K-band extinction adopted for targetting
    ak_targ_method text, --/D Method used to get targetting extinction
    ak_wise real, --/D WISE all-sky K-band extinction
    sfd_ebv real, --/D SFD reddening
    apogee_target1 integer, --/D Bitwise OR of first APOGEE-1 target flag of all visits, see bitmask definitions.
    apogee_target2 integer, --/D Bitwise OR of second APOGEE-1 target flag of all visits, see bitmask definitions
    apogee2_target1 integer, --/D Bitwise OR of first APOGEE-2 target flag of all visits, see bitmask definitions.
    apogee2_target2 integer, --/D Bitwise OR of second APOGEE-2 target flag of all visits, see bitmask definitions
    apogee2_target3 integer, --/D Bitwise OR of third APOGEE-2 target flag of all visits, see bitmask definitions
    apogee2_target4 integer, --/D Bitwise OR of fourth APOGEE-2 target flag of all visits, see bitmask definitions
    targflags text, --/D Verbose/text form of APOGEE-1 target flags
    survey text, --/D Survey-associated with object: apogee, apo1m, apogee-marvels, apogee2, apogee2-manga, manga-apogee2
    programname text, --/D Program name associated with object, when available
    nvisits integer, --/D Number of visits into combined spectrum
    snr real, --/D S/N estimate
    snrev real, --/D Revised S/N estimate (avoiding persistence issues)
    starflag bigint, --/D Flag for star condition taken from bitwise OR of individual visits, see bitmask definitions
    starflags text, --/D Verbose/text form of STARFLAG
    andflag bigint, --/D Flag for star condition taken from bitwise AND of individual visits, see bitmask definitions
    andflags text, --/D Verbose/text form of ANDFLAG
    vhelio_avg real, --/U km/s --/D Average solar system barycentric radial velocity, weighted by S/N, using RVs determined from cross-correlation of individual spectra with combined spectrum 
    vscatter real, --/U km/s --/D Scatter of individual visit RVs around average 
    verr real, --/U km/s --/D Uncertainty in VHELIO_AVG from the S/N-weighted individual RVs 
    rv_teff real, --/U K --/D Teff of best-fit synthetic spectrum from RV fit (NOT ASPCAP!) 
    rv_logg real, --/U log (cgs) --/D log g of best-fit synthetic spectrum from RV fit (NOT ASPCAP!) 
    rv_feh real, --/U Fe/H
    rv_alpha real, --/U alpha/M
    rv_carb real, --/U C/M
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
    aspcap_grid text, --/D ASPCAP grid of best-fitting spectrum
    fparam_grid text, --/D Raw FERRE parameters for each grid for which fit was performed (see GRIDS tag in HDU3 for grid names
    chi2_grid text, --/D CHI2 for each grid for which fit was performed (see GRIDS tag in HDU3 for grid names
    fparam text, --/U M/H], [C/M], [N/M], [alpha/M --/D Output parameter array from ASPCAP stellar parameters fit, in order given in PARAM_SYMBOL array in HDU3: Teff, logg, vmicro, 
    fparam_cov text, --/D Covariance of fitted parameters from FERRE
    aspcap_chi2 real, --/D Chi^2 from ASPCAP fit
    param text, --/U M/H], [C/M], [N/M], [alpha/M --/D Empirically calibrated parameter array, using ASPCAP stellar parameters fit + calibrations, in order given in PARAM_SYMBOL array in HDU3: Teff, logg, vmicro, 
    param_cov text, --/D Covariance of calibrated parameters, but with only diagonal elements from "external" uncertainty estimation
    paramflag text, --/D Individual parameter flag for ASPCAP analysis, see bitmask definitions
    aspcapflag bigint, --/D Flag for ASPCAP analysis, see bitmask definitions
    aspcapflags text, --/D Verbose/text form ASPCAPFLAG
    frac_badpix real, --/D Fraction of bad pixels in spectrum
    frac_lowsnr real, --/D Fraction of low S/N pixels in spectrum
    frac_sigsky real, --/D Fraction of SIG_SKYLINE pixels in spectrum
    felem text, --/D Output individual element array from ASPCAP stellar abundances fit, in order given in ELEM_SYMBOL array in HDU3
    felem_err text, --/D Uncertainty from FERRE in individual element abundances
    x_h text, --/U X/H --/D Empirically calibrated individual element array, using ASPCAP stellar abundances fit + calibrations, all expressed in logarithmic abundance relative to H (
    x_h_err text, --/U X/H --/D Empirical uncertainties in 
    x_m text, --/U X/M --/D Empirically calibrated individual element array, using ASPCAP stellar abundances fit + calibrations, all expressed in logarithmic abundance relative to M (
    x_m_err text, --/U X/M --/D Empirical uncertainties in 
    elem_chi2 text, --/D Chi^2 from ASPCAP fit of individual abundances
    elemfrac text,
    elemflag text, --/D Flags for analysis of individual abundances, see bitmask definitions
    extratarg integer, --/D Bitmask which identifies main survey targets and other classes, see bitmask definitions.
    memberflag bigint, --/D memberflag missing missing missing
    member text, --/D member missing missing missing
    x_h_spec text, --/D x_h_spec missing missing missing
    x_m_spec text, --/D x_m_spec missing missing missing
    teff real, --/U K --/D Teff from ASPCAP analysis of combined spectrum (from PARAM) 
    teff_err real, --/U K --/D Teff uncertainty (from PARAM_COV) 
    logg real, --/U log (cgs) --/D log g from ASPCAP analysis of combined spectrum (from PARAM) 
    logg_err real, --/U log (cgs) --/D log g uncertainty (from PARAM_COV) 
    m_h real, --/U Z/H] from ASPCAP analysis of combined spectrum (from PARAM) [dex
    m_h_err real, --/U Z/H] uncertainty (from PARAM_COV) [dex
    alpha_m real, --/U alpha/M] from ASPCAP analysis of combined spectrum (from PARAM) [dex
    alpha_m_err real, --/U alpha/M] uncertainty (from PARAM_COV) [dex
    vmicro real, --/U (cgs) --/D microturbulent velocity (fit for dwarfs, f(log g) for giants) 
    vmacro real, --/U M/H]) for giants) [(cgs) --/D macroturbulent velocity (f(log Teff, 
    vsini real, --/U (cgs) --/D rotational+macroturbulent velocity (fit for dwarfs) 
    teff_spec real, --/U 0] for convenience) [K --/D ASPCAP spectroscopic Teff (duplicated from FPARAM
    logg_spec real, --/U 1] for convenience) [log (cgs) --/D ASPCAP spectroscopic surface gravity (duplicated from FPARAM
    c_fe real,
    c_fe_spec real,
    c_fe_err real, --/U C/Fe
    c_fe_flag integer, --/U C/Fe
    ci_fe real, --/U Ci/Fe
    ci_fe_spec real,
    ci_fe_err real, --/U Ci/Fe
    ci_fe_flag integer, --/U Ci/Fe
    n_fe real, --/U N/Fe
    n_fe_spec real,
    n_fe_err real, --/U N/Fe
    n_fe_flag integer, --/U N/Fe
    o_fe real, --/U O/Fe
    o_fe_spec real,
    o_fe_err real, --/U O/Fe
    o_fe_flag integer, --/U O/Fe
    na_fe real, --/U Na/Fe
    na_fe_spec real,
    na_fe_err real, --/U Na/Fe
    na_fe_flag integer, --/U Na/Fe
    mg_fe real, --/U Mg/Fe
    mg_fe_spec real,
    mg_fe_err real, --/U Mg/Fe
    mg_fe_flag integer, --/U Mg/Fe
    al_fe real, --/U Al/Fe
    al_fe_spec real,
    al_fe_err real, --/U Al/Fe
    al_fe_flag integer, --/U Al/Fe
    si_fe real, --/U Si/Fe
    si_fe_spec real,
    si_fe_err real, --/U Si/Fe
    si_fe_flag integer, --/U Si/Fe
    p_fe real, --/U P/Fe
    p_fe_spec real,
    p_fe_err real, --/U P/Fe
    p_fe_flag integer, --/U P/Fe
    s_fe real, --/U S/Fe
    s_fe_spec real,
    s_fe_err real, --/U S/Fe
    s_fe_flag integer, --/U S/Fe
    k_fe real, --/U K/Fe
    k_fe_spec real,
    k_fe_err real, --/U K/Fe
    k_fe_flag integer, --/U K/Fe
    ca_fe real, --/U Ca/Fe
    ca_fe_spec real,
    ca_fe_err real, --/U Ca/Fe
    ca_fe_flag integer, --/U Ca/Fe
    ti_fe real, --/U Ti/Fe
    ti_fe_spec real,
    ti_fe_err real, --/U Ti/Fe
    ti_fe_flag integer, --/U Ti/Fe
    tiii_fe real, --/U TiII/Fe
    tiii_fe_spec real,
    tiii_fe_err real, --/U TiII/Fe
    tiii_fe_flag integer, --/U TiII/Fe
    v_fe real, --/U C/Fe --/D c_fe -  --/U V/Fe
    v_fe_spec real,
    v_fe_err real, --/U V/Fe
    v_fe_flag integer, --/U V/Fe
    cr_fe real, --/U Cr/Fe
    cr_fe_spec real,
    cr_fe_err real, --/U Cr/Fe
    cr_fe_flag integer, --/U Cr/Fe
    mn_fe real, --/U Mn/Fe
    mn_fe_spec real,
    mn_fe_err real, --/U Mn/Fe
    mn_fe_flag integer, --/U Mn/Fe
    fe_h real, --/U Fe/H
    fe_h_spec real,
    fe_h_err real, --/U Fe/H
    fe_h_flag integer, --/U Fe/H
    co_fe real, --/U Co/Fe
    co_fe_spec real,
    co_fe_err real, --/U Co/Fe
    co_fe_flag integer, --/U Co/Fe
    ni_fe real, --/U Ni/Fe
    ni_fe_spec real,
    ni_fe_err real, --/U Ni/Fe
    ni_fe_flag integer, --/U Ni/Fe
    cu_fe real, --/U Cu/Fe
    cu_fe_spec real,
    cu_fe_err real, --/U Cu/Fe
    cu_fe_flag integer, --/U Cu/Fe
    ce_fe real, --/U Ce/Fe
    ce_fe_spec real,
    ce_fe_err real, --/U Ce/Fe
    ce_fe_flag integer, --/U Ce/Fe
    yb_fe real, --/U Yb/Fe
    yb_fe_spec real,
    yb_fe_err real, --/U Yb/Fe
    yb_fe_flag integer, --/U Yb/Fe
    visit_pk text, --/D Index of visits (used in combined spectrum) in allVisit file
    twomass_designation text --/D Unique idetni from 2MASS
);



--
-- Name: dr19_allwise; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_allwise (
----------------------------------------------------------------------
--/H ALLWISE catalog: https://wise2.ipac.caltech.edu/docs/release/allwise/. For detailed descriptions of the columns see: https://wise2.ipac.caltech.edu/docs/release/allwise/expsup/sec2_1a.html
----------------------------------------------------------------------
    designation character(20), --/D Sexagesimal, equatorial position-based source name 
    ra numeric(10,7), --/U degrees --/D J2000 right ascension 
    "dec" numeric(9,7), --/U degrees --/D J2000 declination 
    sigra numeric(7,4), --/U arcsec --/D One-sigma uncertainty in right ascension coordinate 
    sigdec numeric(7,4), --/U arcsec --/D One-sigma uncertainty in declination coordinate 
    sigradec numeric(8,4), --/U arcsec --/D The co-sigma of the equatorial position uncertainties 
    glon numeric(10,7), --/U degrees --/D Galactic longitude 
    glat numeric(9,7), --/U degrees --/D Galactic latitude 
    elon numeric(10,7), --/U degrees --/D Ecliptic longitude 
    elat numeric(9,7), --/U degrees --/D Ecliptic latitude 
    wx numeric(7,3), --/U pixel --/D The x-pixel coordinate of this source on the WISE Atlas Image 
    wy numeric(7,3), --/U pixel --/D The y-pixel coordinate of this source on the WISE Atlas Image 
    cntr bigint NOT NULL, --/D Unique identification number for this object in the AllWISE Catalog/Reject Table 
    source_id character(28), --/D Unique source ID 
    coadd_id character(20), --/D WISE Atlas Tile identifier from which source was extracted 
    src integer, --/D Sequential number of the source extraction in the WISE Atlas Tile from which this source detected and measured 
    w1mpro numeric(5,3), --/U mag --/D W1 magnitude measured with profile-fitting photometry 
    w1sigmpro numeric(4,3), --/U mag --/D W1 profile-fit photometric measurement uncertainty 
    w1snr numeric(7,1), --/D W1 profile-fit measurement signal-to-noise ratio 
    w1rchi2 real, --/D Reduced chi^2 of the W1 profile-fit photometry measurement 
    w2mpro numeric(5,3), --/U mag --/D W2 magnitude measured with profile-fitting photometry 
    w2sigmpro numeric(4,3), --/U mag --/D W2 profile-fit photometric measurement uncertainty 
    w2snr numeric(7,1), --/D W2 profile-fit measurement signal-to-noise ratio 
    w2rchi2 real, --/D Reduced chi^2 of the W2 profile-fit photometry measurement 
    w3mpro numeric(5,3), --/U mag --/D W3 magnitude measured with profile-fitting photometry 
    w3sigmpro numeric(4,3), --/U mag --/D W3 profile-fit photometric measurement uncertainty 
    w3snr numeric(7,1), --/D W3 profile-fit measurement signal-to-noise ratio 
    w3rchi2 real, --/D Reduced chi^2 of the W3 profile-fit photometry measurement 
    w4mpro numeric(5,3), --/U mag --/D W4 magnitude measured with profile-fitting photometry 
    w4sigmpro numeric(4,3), --/U mag --/D W4 profile-fit photometric measurement uncertainty 
    w4snr numeric(7,1), --/D W4 profile-fit measurement signal-to-noise ratio 
    w4rchi2 real, --/D Reduced chi^2 of the W4 profile-fit photometry measurement 
    rchi2 real, --/D Combined reduced chi^2 in all bands for the profile-fit photometry measurement 
    nb integer, --/D Number of PSF components used simultaneously in the profile-fitting for this source 
    na integer, --/D Active deblending flag 
    w1sat numeric(4,3), --/D Fraction of all pixels within the profile-fitting area for W1 images that are flagged as saturated 
    w2sat numeric(4,3), --/D Fraction of all pixels within the profile-fitting area for W2 images that are flagged as saturated 
    w3sat numeric(4,3), --/D Fraction of all pixels within the profile-fitting area for W3 images that are flagged as saturated 
    w4sat numeric(4,3), --/D Fraction of all pixels within the profile-fitting area for W4 images that are flagged as saturated 
    satnum character(4), --/D Minimum sample at which saturation occurs in each band 
    ra_pm numeric(10,7), --/U degrees --/D Right ascension at epoch MJD=55400.0 (2010.5589) from the profile-fitting measurement model that includes motion 
    dec_pm numeric(9,7), --/U degrees --/D Declination at epoch MJD=55400.0 (2010.5589) from the profile-fitting measurement model that includes motion 
    sigra_pm numeric(7,4), --/U arcsec --/D One-sigma uncertainty in right ascension from the profile-fitting measurement model that includes motion 
    sigdec_pm numeric(7,4), --/U arcsec --/D One-sigma uncertainty in declination from the profile-fitting measurement model that includes motion 
    sigradec_pm numeric(8,4), --/U arcsec --/D The co-sigma of the equatorial position uncertainties from the profile-fitting measurement model that includes motion 
    pmra integer, --/U mas/yr --/D Total apparent motion in right ascension estimated for this source 
    sigpmra integer, --/U mas/yr --/D Uncertainty in the total right ascension motion estimation 
    pmdec integer, --/U mas/yr --/D Total apparent motion in declination estimated for this source 
    sigpmdec integer, --/U mas/yr --/D Uncertainty in the total declination motion estimation 
    w1rchi2_pm real, --/D Reduced chi^2 of the W1 profile-fit photometry measurement including motion estimation 
    w2rchi2_pm real, --/D Reduced chi^2 of the W2 profile-fit photometry measurement including motion estimation 
    w3rchi2_pm real, --/D Reduced chi^2 of the W3 profile-fit photometry measurement including motion estimation 
    w4rchi2_pm real, --/D Reduced chi^2 of the W4 profile-fit photometry measurement including motion estimation 
    rchi2_pm real, --/D Combined reduced chi^2 in all bands for the profile-fit photometry measurement including motion estimation 
    pmcode character(5), --/D string that encodes information about factors that impact the accuracy of the motion estimation 
    cc_flags character(4), --/D Contamination and confusion flag 
    rel character(1), --/D Small-separation, same-Tile detection flag 
    ext_flg integer, --/D Extended source flag 
    var_flg character(4), --/D Variability flag 
    ph_qual character(4), --/D Photometric quality flag 
    det_bit integer, --/D Bit-encoded integer indicating bands in which a source has a w#snr>2 detection 
    moon_lev character(4), --/D Scattered moonlight contamination flag 
    w1nm integer, --/D number of individual 7.7s exposures where this source was detected with SNR>3 in the W1 profile-fit measurement 
    w1m integer, --/D number of individual 7.7s W1 exposures on which a profile-fit measurement of this source was possible 
    w2nm integer, --/D number of individual 7.7s exposures where this source was detected with SNR>3 in the W2 profile-fit measurement 
    w2m integer, --/D number of individual 7.7s W2 exposures on which a profile-fit measurement of this source was possible 
    w3nm integer, --/D number of individual 7.7s exposures where this source was detected with SNR>3 in the W3 profile-fit measurement 
    w3m integer, --/D number of individual 7.7s W3 exposures on which a profile-fit measurement of this source was possible 
    w4nm integer, --/D number of individual 7.7s exposures where this source was detected with SNR>3 in the W4 profile-fit measurement 
    w4m integer, --/D number of individual 7.7s W4 exposures on which a profile-fit measurement of this source was possible 
    w1cov numeric(6,3), --/D Mean pixel coverage in W1 
    w2cov numeric(6,3), --/D Mean pixel coverage in W2 
    w3cov numeric(6,3), --/D Mean pixel coverage in W3 
    w4cov numeric(6,3), --/D Mean pixel coverage in W4 
    w1cc_map integer, --/D Contamination and confusion map for this source in W1 
    w1cc_map_str character(9), --/D Contamination and confusion string denoting all artifacts that may contaminate the W1 measurement of this source 
    w2cc_map integer, --/D Contamination and confusion map for this source in W2 
    w2cc_map_str character(9), --/D Contamination and confusion string denoting all artifacts that may contaminate the W2 measurement of this source 
    w3cc_map integer, --/D Contamination and confusion map for this source in W3 
    w3cc_map_str character(9), --/D Contamination and confusion string denoting all artifacts that may contaminate the W3 measurement of this source 
    w4cc_map integer, --/D Contamination and confusion map for this source in W4 
    w4cc_map_str character(9), --/D Contamination and confusion string denoting all artifacts that may contaminate the W4 measurement of this source 
    best_use_cntr bigint, --/D Cntr identification value of the source extraction 
    ngrp smallint, --/D Excess number of positionally associated duplicate resolution groups that included this source 
    w1flux real, --/U dn --/D "Raw" W1 source flux measured in profile-fit photometry 
    w1sigflux real, --/U dn --/D Uncertainty in the "raw" W1 source flux measurement in profile-fit photometry 
    w1sky numeric(8,3), --/U dn --/D Average of the W1 sky background value  
    w1sigsk numeric(6,3), --/U dn --/D Uncertainty in the W1 sky background value 
    w1conf numeric(8,3), --/U dn --/D Estimated confusion noise in the W1 sky background annulus 
    w2flux real, --/U dn --/D "Raw" W2 source flux measured in profile-fit photometry 
    w2sigflux real, --/U dn --/D Uncertainty in the "raw" W2 source flux measurement in profile-fit photometry 
    w2sky numeric(8,3), --/U dn --/D Average of the W2 sky background value  
    w2sigsk numeric(6,3), --/U dn --/D Uncertainty in the W2 sky background value 
    w2conf numeric(8,3), --/U dn --/D Estimated confusion noise in the W2 sky background annulus 
    w3flux real, --/U dn --/D "Raw" W3 source flux measured in profile-fit photometry 
    w3sigflux real, --/U dn --/D Uncertainty in the "raw" W3 source flux measurement in profile-fit photometry 
    w3sky numeric(8,3), --/U dn --/D Average of the W3 sky background value  
    w3sigsk numeric(6,3), --/U dn --/D Uncertainty in the W3 sky background value 
    w3conf numeric(8,3), --/U dn --/D Estimated confusion noise in the W3 sky background annulus 
    w4flux real, --/U dn --/D "Raw" W4 source flux measured in profile-fit photometry 
    w4sigflux real, --/U dn --/D Uncertainty in the "raw" W4 source flux measurement in profile-fit photometry 
    w4sky numeric(8,3), --/U dn --/D Average of the W4 sky background value  
    w4sigsk numeric(6,3), --/U dn --/D Uncertainty in the W4 sky background value 
    w4conf numeric(8,3), --/U dn --/D Estimated confusion noise in the W4 sky background annulus 
    w1mag numeric(5,3), --/U mag --/D W1 "standard" aperture magnitude 
    w1sigm numeric(4,3), --/U mag --/D Uncertainty in the W1 "standard" aperture magnitude 
    w1flg integer, --/D W1 "standard" aperture measurement quality flag 
    w1mcor numeric(4,3), --/U mag --/D W1 aperture curve-of-growth correction 
    w2mag numeric(5,3), --/U mag --/D W2 "standard" aperture magnitude 
    w2sigm numeric(4,3), --/D Uncertainty in the W2 "standard" aperture magnitude
    w2flg integer, --/D W2 "standard" aperture measurement quality flag
    w2mcor numeric(4,3), --/D W2 aperture curve-of-growth correction
    w3mag numeric(5,3), --/U mag --/D W3 "standard" aperture magnitude 
    w3sigm numeric(4,3), --/U mag --/D Uncertainty in the W3 "standard" aperture magnitude 
    w3flg integer, --/D W3 "standard" aperture measurement quality flag 
    w3mcor numeric(4,3), --/U mag --/D W3 aperture curve-of-growth correction 
    w4mag numeric(5,3), --/U mag --/D W4 "standard" aperture magnitude 
    w4sigm numeric(4,3), --/U mag --/D Uncertainty in the W4 "standard" aperture magnitude 
    w4flg integer, --/D W4 "standard" aperture measurement quality flag 
    w4mcor numeric(4,3), --/U mag --/D W4 aperture curve-of-growth correction 
    w1mag_1 numeric(5,3), --/U mag --/D W1 5.5" radius aperture magnitude 
    w1sigm_1 numeric(4,3), --/U mag --/D Uncertainty in the W1 5.5" radius aperture magnitude 
    w1flg_1 integer, --/D W1 5.5" radius aperture magnitude quality flag 
    w2mag_1 numeric(5,3), --/U mag --/D W2 5.5" radius aperture magnitude 
    w2sigm_1 numeric(4,3), --/U mag --/D Uncertainty in the W2 5.5" radius aperture magnitude 
    w2flg_1 integer, --/D W2 5.5" radius aperture magnitude quality flag 
    w3mag_1 numeric(5,3), --/U mag --/D W3 5.5" radius aperture magnitude 
    w3sigm_1 numeric(4,3), --/U mag --/D Uncertainty in the W3 5.5" radius aperture magnitude 
    w3flg_1 integer, --/D W3 5.5" radius aperture magnitude quality flag 
    w4mag_1 numeric(5,3), --/U mag --/D W4 11.0" radius aperture magnitude 
    w4sigm_1 numeric(4,3), --/U mag --/D Uncertainty in the W4 11.0" radius aperture magnitude 
    w4flg_1 integer, --/D W4 11.0" radius aperture magnitude quality flag 
    w1mag_2 numeric(5,3), --/U mag --/D W1 8.25" radius aperture magnitude 
    w1sigm_2 numeric(4,3), --/U mag --/D Uncertainty in the W1 8.25" radius aperture magnitude 
    w1flg_2 integer, --/D W1 8.25" radius aperture magnitude quality flag 
    w2mag_2 numeric(5,3), --/U mag --/D W2 8.25" radius aperture magnitude 
    w2sigm_2 numeric(4,3), --/U mag --/D Uncertainty in the W2 8.25" radius aperture magnitude 
    w2flg_2 integer, --/D W2 8.25" radius aperture magnitude quality flag 
    w3mag_2 numeric(5,3), --/U mag --/D W3 8.25" radius aperture magnitude 
    w3sigm_2 numeric(4,3), --/U mag --/D Uncertainty in the W3 8.25" radius aperture magnitude 
    w3flg_2 integer, --/D W3 8.25" radius aperture magnitude quality flag 
    w4mag_2 numeric(5,3), --/U mag --/D W4 16.5" radius aperture magnitude 
    w4sigm_2 numeric(4,3), --/U mag --/D Uncertainty in the W4 16.5" radius aperture magnitude 
    w4flg_2 integer, --/D W4 16.5" radius aperture magnitude quality flag 
    w1mag_3 numeric(5,3), --/U mag --/D W1 11.0" radius aperture magnitude 
    w1sigm_3 numeric(4,3), --/U mag --/D Uncertainty in the W1 11.0" radius aperture magnitude 
    w1flg_3 integer, --/D W1 11.0" radius aperture magnitude quality flag 
    w2mag_3 numeric(5,3), --/U mag --/D W2 11.0" radius aperture magnitude 
    w2sigm_3 numeric(4,3), --/U mag --/D Uncertainty in the W2 11.0" radius aperture magnitude 
    w2flg_3 integer, --/D W2 11.0" radius aperture magnitude quality flag 
    w3mag_3 numeric(5,3), --/U mag --/D W3 11.0" radius aperture magnitude 
    w3sigm_3 numeric(4,3), --/U mag --/D Uncertainty in the W3 11.0" radius aperture magnitude 
    w3flg_3 integer, --/D W3 11.0" radius aperture magnitude quality flag 
    w4mag_3 numeric(5,3), --/U mag --/D W4 22.0" radius aperture magnitude 
    w4sigm_3 numeric(4,3), --/U mag --/D Uncertainty in the W4 22.0" radius aperture magnitude 
    w4flg_3 integer, --/D W4 22.0" radius aperture magnitude quality flag 
    w1mag_4 numeric(5,3), --/U mag --/D W1 13.75" radius aperture magnitude 
    w1sigm_4 numeric(4,3), --/U mag --/D Uncertainty in the W1 13.75" radius aperture magnitude 
    w1flg_4 integer, --/D W1 13.75" radius aperture magnitude quality flag 
    w2mag_4 numeric(5,3), --/U mag --/D W2 13.75" radius aperture magnitude 
    w2sigm_4 numeric(4,3), --/U mag --/D Uncertainty in the W2 13.75" radius aperture magnitude 
    w2flg_4 integer, --/D W2 13.75" radius aperture magnitude quality flag 
    w3mag_4 numeric(5,3), --/U mag --/D W3 13.75" radius aperture magnitude 
    w3sigm_4 numeric(4,3), --/U mag --/D Uncertainty in the W3 13.75" radius aperture magnitude 
    w3flg_4 integer, --/D W3 13.75" radius aperture magnitude quality flag 
    w4mag_4 numeric(5,3), --/U mag --/D W4 27.5" radius aperture magnitude 
    w4sigm_4 numeric(4,3), --/U mag --/D Uncertainty in the W4 27.5" radius aperture magnitude 
    w4flg_4 integer, --/D W4 27.5" radius aperture magnitude quality flag 
    w1mag_5 numeric(5,3), --/U mag --/D W1 16.5" radius aperture magnitude 
    w1sigm_5 numeric(4,3), --/U mag --/D Uncertainty in the W1 16.5" radius aperture magnitude 
    w1flg_5 integer, --/D W1 16.5" radius aperture magnitude quality flag 
    w2mag_5 numeric(5,3), --/U mag --/D W2 16.5" radius aperture magnitude 
    w2sigm_5 numeric(4,3), --/U mag --/D Uncertainty in the W2 16.5" radius aperture magnitude 
    w2flg_5 integer, --/D W2 16.5" radius aperture magnitude quality flag 
    w3mag_5 numeric(5,3), --/U mag --/D W3 16.5" radius aperture magnitude 
    w3sigm_5 numeric(4,3), --/U mag --/D Uncertainty in the W3 16.5" radius aperture magnitude 
    w3flg_5 integer, --/D W3 16.5" radius aperture magnitude quality flag 
    w4mag_5 numeric(5,3), --/U mag --/D W4 33.0" radius aperture magnitude 
    w4sigm_5 numeric(4,3), --/U mag --/D Uncertainty in the W4 33.0" radius aperture magnitude 
    w4flg_5 integer, --/D W4 33.0" radius aperture magnitude quality flag 
    w1mag_6 numeric(5,3), --/U mag --/D W1 19.25" radius aperture magnitude 
    w1sigm_6 numeric(4,3), --/U mag --/D Uncertainty in the W1 19.25" radius aperture magnitude 
    w1flg_6 integer, --/D W1 19.25" radius aperture magnitude quality flag 
    w2mag_6 numeric(5,3), --/U mag --/D W2 19.25" radius aperture magnitude 
    w2sigm_6 numeric(4,3), --/U mag --/D Uncertainty in the W2 19.25" radius aperture magnitude 
    w2flg_6 integer, --/D W2 19.25" radius aperture magnitude quality flag 
    w3mag_6 numeric(5,3), --/U mag --/D W3 19.25" radius aperture magnitude 
    w3sigm_6 numeric(4,3), --/U mag --/D Uncertainty in the W3 19.25" radius aperture magnitude 
    w3flg_6 integer, --/D W3 19.25" radius aperture magnitude quality flag 
    w4mag_6 numeric(5,3), --/U mag --/D W4 38.5" radius aperture magnitude 
    w4sigm_6 numeric(4,3), --/U mag --/D Uncertainty in the W4 38.5" radius aperture magnitude 
    w4flg_6 integer, --/D W4 38.5" radius aperture magnitude quality flag 
    w1mag_7 numeric(5,3), --/U mag --/D W1 22.0" radius aperture magnitude 
    w1sigm_7 numeric(4,3), --/U mag --/D Uncertainty in the W1 22.0" radius aperture magnitude 
    w1flg_7 integer, --/D W1 22.0" radius aperture magnitude quality flag 
    w2mag_7 numeric(5,3), --/U mag --/D W2 22.0" radius aperture magnitude 
    w2sigm_7 numeric(4,3), --/U mag --/D Uncertainty in the W2 22.0" radius aperture magnitude 
    w2flg_7 integer, --/D W2 22.0" radius aperture magnitude quality flag 
    w3mag_7 numeric(5,3), --/U mag --/D W3 22.0" radius aperture magnitude 
    w3sigm_7 numeric(4,3), --/U mag --/D Uncertainty in the W3 22.0" radius aperture magnitude 
    w3flg_7 integer, --/D W3 22.0" radius aperture magnitude quality flag 
    w4mag_7 numeric(5,3), --/U mag --/D W4 44.0" radius aperture magnitude 
    w4sigm_7 numeric(4,3), --/U mag --/D Uncertainty in the W4 44.0" radius aperture magnitude 
    w4flg_7 integer, --/D W4 44.0" radius aperture magnitude quality flag 
    w1mag_8 numeric(5,3), --/U mag --/D W1 24.75" radius aperture magnitude 
    w1sigm_8 numeric(4,3), --/U mag --/D Uncertainty in the W1 24.75" radius aperture magnitude 
    w1flg_8 integer, --/D W1 24.75" radius aperture magnitude quality flag 
    w2mag_8 numeric(5,3), --/U mag --/D W2 24.75" radius aperture magnitude 
    w2sigm_8 numeric(4,3), --/U mag --/D Uncertainty in the W2 24.75" radius aperture magnitude 
    w2flg_8 integer, --/D W3 24.75" radius aperture magnitude quality flag 
    w3mag_8 numeric(5,3), --/U mag --/D W3 24.75" radius aperture magnitude 
    w3sigm_8 numeric(4,3), --/U mag --/D Uncertainty in the W3 24.75" radius aperture magnitude 
    w3flg_8 integer, --/D W3 24.75" radius aperture magnitude quality flag 
    w4mag_8 numeric(5,3), --/U mag --/D W4 49.5" radius aperture magnitude 
    w4sigm_8 numeric(4,3), --/U mag --/D Uncertainty in the W4 49.5" radius aperture magnitude 
    w4flg_8 integer, --/D W4 49.5" radius aperture magnitude quality flag 
    w1magp numeric(5,3), --/U mag --/D Magnitude computed from the inverse-variance-weighted mean of the profile-fit flux measurements on the w1m W1 frames covering this source 
    w1sigp1 numeric(5,3), --/U mag --/D Standard deviation of the population of W1 fluxes measured on the w1m individual frames covering this source 
    w1sigp2 numeric(5,3), --/U mag --/D w1sigp1/sqrt(w1m) 
    w1k numeric(4,3), --/D Stetson K variability index computed using the W1 profile-fit fluxes measured on the single-exposure images 
    w1ndf integer, --/D Number of degrees of freedom in the flux variability chi-square, W1 
    w1mlq numeric(4,2), --/D Probability measure that the source is variable in W1 flux 
    w1mjdmin numeric(13,8), --/D The earliest modified Julian Date (mJD) of the W1 single-exposures covering the source 
    w1mjdmax numeric(13,8), --/D The latest modified Julian Date (mJD) of the W1 single-exposures covering the source 
    w1mjdmean numeric(13,8), --/D The average modified Julian Date (mJD) of the W1 single-exposures covering the source 
    w2magp numeric(5,3), --/U mag --/D Magnitude computed from the inverse-variance-weighted mean of the profile-fit flux measurements on the w2m W2 frames covering this source 
    w2sigp1 numeric(5,3), --/U mag --/D Standard deviation of the population of W2 fluxes measured on the w2m individual frames covering this source 
    w2sigp2 numeric(5,3), --/U mag --/D w2sigp1/sqrt(w2m) 
    w2k numeric(4,3), --/D Stetson K variability index computed using the W2 profile-fit fluxes measured on the single-exposure images 
    w2ndf integer, --/D Number of degrees of freedom in the flux variability chi-square, W2 
    w2mlq numeric(4,2), --/D Probability measure that the source is variable in W2 flux 
    w2mjdmin numeric(13,8), --/D The earliest modified Julian Date (mJD) of the W2 single-exposures covering the source 
    w2mjdmax numeric(13,8), --/D The latest modified Julian Date (mJD) of the W2 single-exposures covering the source 
    w2mjdmean numeric(13,8), --/D The average modified Julian Date (mJD) of the W2 single-exposures covering the source 
    w3magp numeric(5,3), --/U mag --/D Magnitude computed from the inverse-variance-weighted mean of the profile-fit flux measurements on the w3m W3 frames covering this source 
    w3sigp1 numeric(5,3), --/U mag --/D Standard deviation of the population of W3 fluxes measured on the w3m individual frames covering this source 
    w3sigp2 numeric(5,3), --/U mag --/D w3sigp1/sqrt(w3m) 
    w3k numeric(4,3), --/D Stetson K variability index computed using the W3 profile-fit fluxes measured on the single-exposure images 
    w3ndf integer, --/D Number of degrees of freedom in the flux variability chi-square, W3 
    w3mlq numeric(4,2), --/D Probability measure that the source is variable in W3 flux 
    w3mjdmin numeric(13,8), --/D The earliest modified Julian Date (mJD) of the W3 single-exposures covering the source 
    w3mjdmax numeric(13,8), --/D The latest modified Julian Date (mJD) of the W3 single-exposures covering the source 
    w3mjdmean numeric(13,8), --/D The average modified Julian Date (mJD) of the W3 single-exposures covering the source 
    w4magp numeric(5,3), --/U mag --/D Magnitude computed from the inverse-variance-weighted mean of the profile-fit flux measurements on the w4m W4 frames covering this source 
    w4sigp1 numeric(5,3), --/U mag --/D Standard deviation of the population of W4 fluxes measured on the w4m individual frames covering this source 
    w4sigp2 numeric(5,3), --/U mag --/D w4sigp1/sqrt(w4m) 
    w4k numeric(4,3), --/D Stetson K variability index computed using the W4 profile-fit fluxes measured on the single-exposure images 
    w4ndf integer, --/D Number of degrees of freedom in the flux variability chi-square, W4 
    w4mlq numeric(4,2), --/D Probability measure that the source is variable in W4 flux 
    w4mjdmin numeric(13,8), --/D The earliest modified Julian Date (mJD) of the W4 single-exposures covering the source 
    w4mjdmax numeric(13,8), --/D The latest modified Julian Date (mJD) of the W4 single-exposures covering the source 
    w4mjdmean numeric(13,8), --/D The average modified Julian Date (mJD) of the W4 single-exposures covering the source 
    rho12 integer, --/U percent --/D The correlation coefficient between the W1 and W2 single-exposure flux measurements 
    rho23 integer, --/U percent --/D The correlation coefficient between the W2 and W3 single-exposure flux measurements 
    rho34 integer, --/U percent --/D The correlation coefficient between the W3 and W4 single-exposure flux measurements 
    q12 integer, --/D Correlation significance between W1 and W2 
    q23 integer, --/D Correlation significance between W2 and W3 
    q34 integer, --/D Correlation significance between W3 and W4 
    xscprox numeric(7,2), --/U arcsec --/D distance between the WISE source position and the position of a nearby 2MASS XSC source 
    w1rsemi numeric(7,2), --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W1 
    w1ba numeric(3,2), --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W1 
    w1pa numeric(5,2), --/U degrees --/D Position angle of the elliptical aperture major axis used to measure source in W1 
    w1gmag numeric(5,3), --/U mag --/D W1 magnitude of source measured in the elliptical aperture described by w1rsemi, w1ba, and w1pa 
    w1gerr numeric(4,3), --/U mag --/D Uncertainty in the W1 magnitude of source measured in elliptical aperture 
    w1gflg integer, --/D W1 elliptical aperture measurement quality flag 
    w2rsemi numeric(7,2), --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W2 
    w2ba numeric(3,2), --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W2 
    w2pa numeric(5,2), --/U degrees --/D Position angle of the elliptical aperture major axis used to measure source in W2 
    w2gmag numeric(5,3), --/D W2 magnitude of source measured in the elliptical aperture described by w2rsemi, w2ba, and w2pa
    w2gerr numeric(4,3), --/U mag --/D Uncertainty in the W2 magnitude of source measured in elliptical aperture 
    w2gflg integer, --/D W2 elliptical aperture measurement quality flag 
    w3rsemi numeric(7,2), --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W3 
    w3ba numeric(3,2), --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W3 
    w3pa numeric(5,2), --/U degrees --/D Position angle of the elliptical aperture major axis used to measure source in W3 
    w3gmag numeric(5,3), --/D W3 magnitude of source measured in the elliptical aperture described by w3rsemi, w3ba, and w3pa
    w3gerr numeric(4,3), --/U mag --/D Uncertainty in the W3 magnitude of source measured in elliptical aperture 
    w3gflg integer, --/D W3 elliptical aperture measurement quality flag 
    w4rsemi numeric(7,2), --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W4 
    w4ba numeric(3,2), --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W4 
    w4pa numeric(5,2), --/U degrees --/D Position angle of the elliptical aperture major axis used to measure source in W4 
    w4gmag numeric(5,3), --/D W4 magnitude of source measured in the elliptical aperture described by w4rsemi, w4ba, and w4pa
    w4gerr numeric(4,3), --/U mag --/D Uncertainty in the W4 magnitude of source measured in elliptical aperture 
    w4gflg integer, --/D W4 elliptical aperture measurement quality flag 
    tmass_key integer, --/D Unique identifier of the closest source in the 2MASS Point Source Catalog 
    r_2mass numeric(5,3), --/U arcsec --/D Distance separating the positions of the WISE source and associated 2MASS PSC source within 3" 
    pa_2mass numeric(4,1), --/U degrees --/D Position angle of the vector from the WISE source to the associated 2MASS PSC source 
    n_2mass integer, --/D The number of 2MASS PSC entries found within a 3" radius of the WISE source position 
    j_m_2mass numeric(5,3), --/U mag --/D 2MASS J-band magnitude or magnitude upper limit of the associated 2MASS PSC source 
    j_msig_2mass numeric(4,3), --/U mag --/D 2MASS J-band corrected photometric uncertainty of the associated 2MASS PSC source 
    h_m_2mass numeric(5,3), --/U mag --/D 2MASS H-band magnitude or magnitude upper limit of the associated 2MASS PSC source 
    h_msig_2mass numeric(4,3), --/U mag --/D 2MASS H-band corrected photometric uncertainty of the associated 2MASS PSC source 
    k_m_2mass numeric(5,3), --/U mag --/D 2MASS Ks-band magnitude or magnitude upper limit of the associated 2MASS PSC source 
    k_msig_2mass numeric(4,3), --/U mag --/D 2MASS Ks-band corrected photometric uncertainty of the associated 2MASS PSC source 
    x numeric(17,16), --/D Unit sphere position x value 
    y numeric(17,16), --/D Unit sphere position y value 
    z numeric(17,16), --/D Unit sphere position z value 
    spt_ind integer, --/D Level 7 HTM spatial index key 
    htm20 bigint --/D Level 20 HTM spatial index key 
);



--
-- Name: dr19_assignment; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_assignment (
----------------------------------------------------------------------
--/H This table stores the assignment of a given target in a carton to a fiber of a given instrument. A collection of assignments are included within a design, which is one configuartion of the robots for an exposure.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    carton_to_target_pk bigint, --/D The primary key of the carton_to_target in the dr19_carton_to_target table.
    hole_pk integer, --/D The primary key of the hole in the dr19_hole table.
    instrument_pk integer, --/D The primary key of the instrument in the dr19_instrument table.
    design_id integer --/D The primary key of the design in the dr19_design table.
);



--
-- Name: dr19_best_brightest; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_best_brightest (
----------------------------------------------------------------------
--/H Catalog from Kevin Schlaufman for the selection of bright metal-poor stars from the method of Schlaufman and Casey (2014): https://ui.adsabs.harvard.edu/abs/2014ApJ...797...13S/abstract. WISE values from WHICH CATALOG, 2MASS values from 2MASS point source catalog.
----------------------------------------------------------------------
    designation character varying(19), --/D 2MASS Designation 
    ra_1 double precision, --/U degrees --/D right ascension from the AllWISE catalog 
    dec_1 double precision, --/U degrees --/D declination from the AllWISE catalog 
    glon double precision, --/U degrees --/D Galactic longitude from AllWISE catalog 
    glat double precision, --/U degrees --/D Galactic latitude from the AllWISE catalog 
    w1mpro real, --/U mag --/D AllWISE W1-band magnitude measured with profile-fitting photometry 
    w2mpro real, --/U mag --/D AllWISE W2-band magnitude measured with profile-fitting photometry 
    w3mpro real, --/U mag --/D AllWISE W3-band magnitude measured with profile-fitting photometry 
    w4mpro character varying(6), --/U mag --/D AllWISE W4-band magnitude measured with profile-fitting photometry 
    pmra integer, --/U mas/yr --/D Gaia DR2 proper motion 
    pmdec integer, --/U mas/yr --/D Gaia DR2 proper motion 
    j_m_2mass real, --/U mag --/D 2MASS J=band magnitude 
    h_m_2mass real, --/U mag --/D 2MASS magnitude 
    k_m_2mass real, --/U mag --/D 2MASS magnitude 
    ra_2 double precision, --/U degrees --/D Right ascension from the 2MASS catalog 
    raerr double precision, --/U degrees --/D Uncertainty in right ascension from the 2MASS catalog 
    dec_2 double precision, --/U degrees --/D Declination from the 2MASS catalog 
    decerr double precision, --/U degrees --/D Uncertainty in declination from the 2MASS catalog 
    nobs integer, --/D Number of observed nights from the APASS catalog 
    mobs integer, --/D Number of images for this field from the APASS catalog 
    vjmag real, --/U mag --/D APASS V_J magnitude 
    bjmag real, --/U mag --/D APASS B_J magnitude 
    gmag real, --/U mag --/D APASS Sloan g' magnitude 
    rmag real, --/U mag --/D APASS Sloan r' magnitude 
    imag real, --/U mag --/D APASS Sloan i' magnitude 
    evjmag real, --/U mag --/D Uncertainty in APASS V_J  magnitude 
    ebjmag real, --/U mag --/D Uncertainty in APASS B_J magnitude 
    egmag real, --/U mag --/D Uncertainty in APASS Sloan g' magnitude 
    ermag real, --/U mag --/D Uncertainty in APASS Sloan r' magnitude 
    eimag real, --/U mag --/D Uncertainty in APASS Sloan i' magnitude 
    name integer, --/D APASS field name 
    separation double precision, --/U arcsec --/D Separation between AllWISE object and APASS object 
    ebv real, --/U mag --/D SFD dustmap E(B-V) 
    version integer, --/D version 2 is high priiority, version 1 is low priority (see Schlaufman + Casey 2014 for definitions) 
    original_ext_source_id character varying(16), --/D 2MASS designation removing the "." from the coordinates and getting rid of "J" at the front 
    cntr bigint NOT NULL --/D Internal Identifier 
);



--
-- Name: dr19_bhm_csc; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_bhm_csc (
----------------------------------------------------------------------
--/H Chandra Source Catalogue version 2.0 (CSC2) sources that have been
--/T matched (separately) to the PanSTARRS-1 and 2MASS catalogs.  This <br>
--/T version of the CSC2 catalog informed early (plate era) SDSS-V <br>
--/T observations but was then replaced by updated versions.
----------------------------------------------------------------------
    pk bigint NOT NULL, --/D primary key of this table entry
    csc_version text, --/D Always equal to 'CSC2stub1'
    cxo_name text, --/D unique identifier for the CSC X-ray source
    oir_ra double precision, --/U deg --/D despite the name, this is the X-ray coordinate of the target 
    oir_dec double precision, --/U deg --/D despite the name, this is the X-ray coordinate of the target 
    mag_g real, --/U mag --/D optical magnitude (g-band) from Pan-STARRS1 catalog, if available 
    mag_r real, --/U mag --/D optical magnitude (r-band) from Pan-STARRS1 catalog, if available 
    mag_i real, --/U mag --/D optical magnitude (i-band) from Pan-STARRS1 catalog, if available 
    mag_z real, --/U mag --/D optical magnitude (z-band) from Pan-STARRS1 catalog, if available 
    mag_h real, --/U mag --/D H-band NIR magnitude from 2MASS catalog, if available 
    spectrograph text --/D Which spectrograph this target should be observed with (BOSS or APOGEE)
);



--
-- Name: dr19_bhm_csc_v2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_bhm_csc_v2 (
----------------------------------------------------------------------
--/H CSC2 X-ray sources that have been matched
--/T separately to PanSTARRS-1, Gaia DR2, and 2MASS catalogs, using the programs NWAY <br>
--/T (Johannes Buchner; see: Salvato 2018, MN, 473, 4937) and Xmatch (Arnold Rots;
--/T see: <br>
--/T https://cxc.cfa.harvard.edu/csc/csc_crossmatches.html). Both are based on the
--/T Bayesian spatial <br>
--/T cross-matching algorithm developed by Budavari & Szalay (2008, ApJ 679, 301),
--/T but Xmatch <br>
--/T has the added capability of taking source extent and/or PSF into account. <br>
--/T Created March 2021 by Paul Green, Dong-Woo Kim, Arnold Rots and the CXC CatSci
--/T group.
----------------------------------------------------------------------
    cxoid text, --/D CSC2 Chandra ID
    xra double precision, --/U deg --/D RA of X-ray source from CSC2 
    xdec double precision, --/U deg --/D Dec of X-ray source from CSC2 
    pri smallint, --/D Priority (based on X-ray S/N)
    ocat text, --/D optical catalog code (P for PS1, G for Gaia)
    oid bigint, --/D object ID from optical catalog
    ora double precision, --/U deg --/D right ascension (2000) from optical catalog 
    odec double precision, --/U deg --/D declination (2000) from optical catalog 
    omag real, --/U mag --/D optical magnitude from optical catalog 
    omatchtype smallint, --/D X-ray/optical match type (1-4 definite/likely/multiple opt, multiple X)
    irid text, --/D object ID from 2MASS
    ra2m double precision, --/U deg --/D right ascension (2000) from 2MASS 
    dec2m double precision, --/U deg --/D declination (2000) from 2MASS 
    hmag real, --/U mag --/D H mag from 2MASS 
    irmatchtype smallint, --/D X-ray/IR match type (1-4 definite/likely/multiple opt, multiple X)
    lgal double precision, --/U deg --/D Galactic longitude (from X-ray position) 
    bgal double precision, --/U deg --/D Galactic latitude (from X-ray position) 
    logfx real, --/D log10 of X-ray cgs flux in xband 
    xband text, --/D X-ray bandpass for logfx, priority b,m,s,h,w
    xsn double precision, --/D X-ray S/N
    xflags integer, --/D concatenated X-ray source flags: extended,confused,piledup,variable,streak,saturated
    designation2m text, --/D 2MASS identifier (designation) derived from irid
    idg2 bigint, --/D Gaia DR2 source_id (derived from ocat, oid)
    idps bigint, --/D Pan-STARRS1 Object identifier (derived here from ocat+oid) - equivalent to ObjID in MAST database (https://outerspace.stsci.edu/display/PANSTARRS/PS1+Object+Identifiers), and to our panstarrs1.extid_hi_lo
    pk bigint NOT NULL --/D primary key of the database table
);



--
-- Name: dr19_bhm_efeds_veto; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_bhm_efeds_veto (
----------------------------------------------------------------------
--/H The BHM-SPIDERS eFEDS veto catalogue.
--/T A minimalist catalogue of 6300 science targets in the SPIDERS eFEDS field that
--/T received SDSS-IV spectroscopy during the March2020 SPIDERS observing run (and
--/T hence are not in SDSS-SpecObj-DR16). Many of these spectra have very low SNR and
--/T so we will want to observe them again, but we will take account of this in the
--/T Carton code. This is a subset (in both rows and columns) of the
--/T spAll-v5_13_1.fits idlspec2d pipeline product. The original data model for that
--/T file is here:
--/T https://data.sdss.org/datamodel/files/BOSS_SPECTRO_REDUX/RUN2D/spAll.html
----------------------------------------------------------------------
    programname character varying(5), --/D program name within a given survey
    chunk character varying(7), --/D Name of tiling chunk
    platesn2 real, --/D Overall (S/N)^2 measure for plate; minimum of all 4 cameras
    plate integer, --/D Plate ID
    tile integer, --/D Tile ID
    mjd integer, --/U days --/D MJD of (last) observation 
    fiberid integer, --/D Fiber ID (1-1000)
    run2d character varying(7), --/D idlspec 2D reduction version
    run1d character varying(7), --/D idlspec 1D reduction version
    plug_ra double precision, --/U deg --/D Object RA (drilled fiber position at expected epoch of observation) 
    plug_dec double precision, --/U deg --/D Object Dec (drilled fiber position at expected epoch of observation) 
    z_err real, --/D Redshift error based upon fit to chi^2 minimum; negative for invalid fit
    rchi2 real, --/D Reduced chi^2 for best fit
    dof integer, --/D Degrees of freedom for best fit
    rchi2diff real, --/D Difference in reduced chi^2 of best solution to 2nd best solution
    wavemin real, --/U Angstroms --/D Minimum observed (vacuum) wavelength for this object 
    wavemax real, --/U Angstroms --/D Maximum observed (vacuum) wavelength for this object 
    wcoverage real, --/D Amount of wavelength coverage in log-10(Angstroms)
    zwarning integer, --/D A flag bitmask set for bad data or redshift fits
    sn_median_all real, --/D Median S/N for all good pixels in all filters
    anyandmask integer, --/D Mask bits which are set if any pixels for an object's ANDMASK have that bit set
    anyormask integer, --/D Mask bits which are set if any pixels for an object's ORMASK have that bit set
    pk bigint NOT NULL --/D primary key in the database table
);



--
-- Name: dr19_bhm_rm_tweaks; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_bhm_rm_tweaks (
----------------------------------------------------------------------
--/H This table enables small modifications to be made to the set of
--/T reverberation mapping (RM) targets selected for observation in SDSS-V. <br>
--/T The dr19_bhm_rm_tweaks table allows identification of i) confirmed <br>
--/T QSOs which were observed in plate mode that should be preferentially <br>
--/T targeted in forward-looking FPS mode observations, and ii) reject candidates <br>
--/T which the plate-mode observations have revealed to be unsuitable for <br>
--/T continued RM studies.
----------------------------------------------------------------------
    rm_field_name character(12), --/D Human readable name of the field (e.g. 'XMM-LSS', 'COSMOS', 'SDSS-RM')
    plate integer, --/D PLATEID of the SDSS-V spectrum from which the visual inspection information was derived
    fiberid integer, --/D FIBERID of the SDSS-V spectrum from which the visual inspection information was derived
    mjd integer, --/D MJD of the SDSS-V spectrum from which the visual inspection information was derived
    catalogid bigint, --/D SDSS-V catalogid from version '0.1.0' of the crossmatch
    ra double precision, --/D PLUG_RA of the SDSS-V spectrum from which the visual inspection information was derived
    "dec" double precision, --/D PLUG_DEC of the SDSS-V spectrum from which the visual inspection information was derived
    rm_suitability integer, --/D Flag indicating if this target is well suited to continued RM observation. Known values are: -1 - unconfirmed (but might still be a good QSO target, e.g. due to unplugged fiber, or unverified visual inspection); 0 - target is probably unsuitable for RM, do not observe in the future; 1 - target is probably suitable for RM
    in_plate boolean, --/D flag indicating if this target was included in a plate design during SDSS-V plate observations
    firstcarton character(17), --/D 'firstcarton' that selected this target for observation in the SDSS-V plate-mode operations phase
    mag_u real, --/U mag --/D optical magnitude of the target (u-band) 
    mag_g real, --/U mag --/D optical magnitude of the target (g-band) 
    mag_r real, --/U mag --/D optical magnitude of the target (r-band) 
    mag_i real, --/U mag --/D optical magnitude of the target (i-band) 
    mag_z real, --/U mag --/D optical magnitude of the target (z-band) 
    gaia_g real, --/U mag --/D optical magnitude of the target (Gaia G-band) 
    date_set character(11), --/D Human readable date string, e.g. '25-Nov-2020' that indicates roughly when this entry was added
    pkey bigint NOT NULL --/D primary key of the table entry
);



--
-- Name: dr19_bhm_rm_v0; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_bhm_rm_v0 (
----------------------------------------------------------------------
--/H Parent sample for the RM project, used to select confirmed and candidate quasar targets for the BHM-RM Program in SDSS-V. For more details please see Yang and Shen, (2022, https://ui.adsabs.harvard.edu/abs/2022arXiv220608989Y/abstract).
--/T This table contains all photometric objects detected in the COSMOS, SDSS-RM,
--/T XMM-LSS, CDFS, S-CVZ, and ELAIS-S1 fields., within a circular area of 10
--/T degree^2 from the field center. <br>
--/T Field center: Name     RA          DEC <br>
--/T               XMM-LSS  02:22:50.00    -04:45:00.0 <br>
--/T               CDFS     03:30:35.60    -28:06:00.0 <br>
--/T               EDFS     04:04:57.84    -48:25:22.8 <br>
--/T               ELAIS-S1 00:37:48.00    -44:00:00.0 <br>
--/T               COSMOS   10:00:00.00    +02:12:00.0 <br>
--/T               SDSS-RM  14:14:49.00    +53:05:00.0 <br>
--/T               S-CVZ    06:00:00.00    -66:33:38.0 <br>
--/T The table includes information from the following survey data releases: <br>
--/T DES: Dark Energy Survey, Y6, Y6A1_COADD_OBJECT_SUMMARY <br>
--/T PS1: Pan-STARRS, DR1, StackObjectThin <br>
--/T NSC: NOAO Source Catalog, DR1, nsc_dr1.object <br>
--/T SDSS: Sloan Digital Sky Survey, DR14, PhotoObjAll <br>
--/T Gaia: DR2, gaia_dr2.gaia_source <br>
--/T unWISE: DR1 <br>
--/T Near-infrared: LAS: UKIDSS Large Area Surveys (DR11), <br>
--/T                UHS: UKIRT Hemisphere Survey (DR1), <br>
--/T                VHS: VISTA Hemisphere Survey (DR6), <br>
--/T                Viking: VISTA Kilo-Degree Infrared Galaxy Survey (DR5), <br>
--/T                VIDEO: VISTA Deep Extragalactic Observations Survey (DR5), <br>
--/T                VMC: VISTA Magellanic Cloud Survey (DR4) <br>
--/T Values are set to -9.0 or -9 if null. <br>
--/T The dr19_bhm_rm_v0 table corresponds to Version: v0, 04/07/2020 <br>
--/T Note that contents of the spec_q column are incorrect in this version of the
--/T table.
----------------------------------------------------------------------
    field_name character varying(8), --/D One of COSMOS, SDSS-RM, XMM-LSS, CDFS, S-CVZ, or ELAIS-S1
    ra double precision, --/U deg --/D Fiducial Right Ascension (J2000) 
    "dec" double precision, --/U deg --/D Fiducial Declination (J2000) 
    distance double precision, --/U deg --/D Angular distance from the field center 
    pos_ref character varying(4), --/D Fiducial coordinates reference, priority: Gaia > DES > PS1 > NSC
    ebv double precision, --/D Galactic E(B−V) reddening from Schlegel et al. (1998)
    des integer, --/D A flag set to 1 if in DES photometric catalog
    coadd_object_id bigint, --/D DES coadd object ID
    ra_des double precision, --/U deg --/D DES Right Ascension (J2000) 
    dec_des double precision, --/U deg --/D DES Declination (J2000) 
    extended_coadd integer, --/D DES type classifier: 0 (high-confidence stars), 1 (likely stars), 2 (mostly galaxies), and 3 (high-confidence galaxies)
    separation_des double precision, --/U arcsec --/D Angular distance between DES position and the fiducial coordinates 
    ps1 integer, --/D A flag set to 1 if in PS1 photometric catalog
    objid_ps1 bigint, --/D PS1 unique object identifier
    ra_ps1 double precision, --/U deg --/D PS1 right ascension from i filter stack detection 
    dec_ps1 double precision, --/U deg --/D PS1 declination from i filter stack detection 
    class_ps1 double precision, --/D PS1 source classification = iPsfMag - iKronMag
    separation_ps1 double precision, --/U arcsec --/D Angular distance between PS1 position and the fiducial coordinates 
    nsc integer, --/D A flag set to 1 if in  photometric catalog
    id_nsc bigint, --/D NSC unique object identifier
    ra_nsc double precision, --/U deg --/D Right Ascension (J2000) 
    dec_nsc double precision, --/U deg --/D Declination (J2000) 
    class_star double precision, --/D NSC Star/Galaxy classifier
    flags_nsc integer, --/D NSC SExtractor flag value
    separation_nsc double precision, --/U arcsec --/D Angular distance between NSC position and the fiducial coordinates 
    sdss integer, --/D A flag set to 1 if in SDSS photometric catalog
    objid_sdss bigint, --/D Unique SDSS identifier
    ra_sdss double precision, --/U deg --/D Right Ascension (J2000) 
    dec_sdss double precision, --/U deg --/D Declination (J2000) 
    type_sdss integer, --/D SDSS type classifier (star 6, galaxy 3, etc.)
    clean_sdss integer, --/D SDSS clean photometry flag (1=clean, 0=unclean)
    separation_sdss double precision, --/U arcsec --/D Angular distance between SDSS position and the fiducial coordinates 
    gaia integer, --/D A flag set to 1 if in Gaia DR2 photometric catalog
    source_id_gaia bigint, --/D Gaia DR2 unique source identifier
    mg double precision, --/U mag --/D Gaia g-band magnitude (phot_g_mean_mag in Gaia catalog, Vega) 
    parallax double precision, --/U mas --/D Parallax, Angle, 
    parallax_error double precision, --/U mas --/D Standard error of parallax, Angle, 
    plxsig double precision, --/D Parallax significance defined as (PARALLAX/PARALLAX_ERROR)
    pmra double precision, --/U mas/year --/D Proper motion in RA direction, Angular Velocity, 
    pmra_error double precision, --/U mas/year --/D Standard error of proper motion in RA direction, Angular Velocity, 
    pmdec double precision, --/U mas/year --/D Proper motion in DEC direction, Angular Velocity, 
    pmdec_error double precision, --/U mas/year --/D Standard error of proper motion in DEC direction, Angular Velocity, 
    pmsig double precision, --/D Proper motion significance defined as (pmra^2+pmdec^2)/sqrt(pmra^2*pmra_error^2 + pmdec^2*pmdec_error^2)
    unwise integer, --/D A flag set to 1 if in unWISE photometric catalog
    objid_unwise character varying(16), --/D unWISE unique object id
    ra_unwise double precision, --/U deg --/D unWISE Right Ascension (J2000) 
    dec_unwise double precision, --/U deg --/D unWISE Declination (J2000) 
    separation_unwise double precision, --/U arcsec --/D Angular distance between unWISE position and the fiducial coordinates 
    near_ir integer, --/D A flag set to 1 if in NIR photometric catalog
    survey_ir character varying(6), --/D Near-IR survey name: LAS, UHS, VHS, Viking, VMC, VIDEO
    sourceid_ir bigint, --/D NIR source identifier
    ra_ir double precision, --/U deg --/D NIR Right Ascension (J2000) 
    dec_ir double precision, --/U deg --/D NIR Declination (J2000) 
    separation_ir double precision, --/U arcsec --/D Angular distance between NIR position and the fiducial coordinates 
    optical_survey character varying(4), --/D Optical survey used in Skewt-QSO, e.g., DES, PS1, Gaia, NSC
    mi double precision, --/U mag --/D i-band PSF magnitude (galactic extinction not corrected) 
    cal_skewt_qso integer, --/D A flag indicates whether Skewt-QSO is calculated.(Set to 1 when Nband_Optical_use > 2.)
    nband_optical_use integer, --/D Number of optical bands used in Skewt-QSQ.
    use_unwise integer, --/D Set to 1 when unWISE photometry is used in Skewt-QSO calculation.
    use_nir integer, --/D Set to 1 when NIR photometry is usedin Skewt-QSO calculation.
    photo_combination character varying(17), --/D The photometric data combinations used in Skewt-QSO, for example, "DECam-YJHK-unWISE" - DECam/PS1 includes grizy bands; unWISE incldes unWISE W1 and W2 bands; and Gaia includes Gaia bp, g, and rp bands
    log_qso double precision, --/D The (natural) logarithmic probability of a target fitting to QSO colors convolved with a QLF. Set to -323 if log_QSO<-323 (close to the lower limit of double-precision data).
    log_star double precision, --/D The logarithmic probability of a target fitting to star colors multiplied by star number counts based on a stellar simulation. Set to -323 if log_Star<-323.
    log_galaxy double precision, --/D The logarithmic probability of a target fitting to galaxy colors convolved with a GLF. Set to -323 if  log_Galaxy<-323.
    p_qso double precision, --/D QSO probability from Skewt-QSO. P_QSO = exp(log_qso)/(exp(log_qso) + exp(log_star) + exp(log_galaxy))
    p_star real, --/D Star probability from Skewt-QSO.
    p_galaxy double precision, --/D Galaxy probability from Skewt-QSO.
    class_skewt_qso character varying(6), --/D Classification based on the highest probability from Skewt-QSO, QSO/Star/Galaxy
    skewt_qso integer, --/D flag indicating whether the object is a QSO (same as class_skewt_qso, except additionally requiring log_QSO>-10). (P_QSO>P_Star & P_QSO>P_galaxy & log_QSO>-10)
    p_qso_prior double precision, --/D QSO probability with prior probabilities from additional info, such as separation (between optical survey and unWISE), morphology, variability, and/or proper motion.(Note: *_Prior are generally not populated in this version, except for the "S-CVZ" field, where we take into account the separation between optical surveys and unWISE.)
    p_star_prior real, --/D Star probability with prior probabilities.
    p_galaxy_prior double precision, --/D Galaxy probability with prior probabilities.
    class_skewt_qso_prior character varying(6), --/D Classification based on Skewt-QSO with prior probabilities described above.
    skewt_qso_prior integer, --/D flag indicating whether the object is QSO based on Skewt-QSO with prior probabilities described above.
    photoz_qso double precision, --/D Photometric redshift of QSO from Skewt-QSO
    photoz_qso_lower double precision, --/D Lower limit of photoz_QSO
    photoz_qso_upper double precision, --/D Upper limit of photoz_QSO
    prob_photoz_qso double precision, --/D The total probability of z located between photoz_QSO_lower and photoz_QSO_upper (assuming it is QSO).
    photoz_galaxy double precision, --/D Photometric redshift of Galaxy from Skewt-QSO (fitting to galaxy colors).
    photoz_galaxy_lower double precision, --/D Lower limit of photoz_Galaxy.
    photoz_galaxy_upper double precision, --/D Upper limit of photoz_Galaxy.
    pqso_xdqso double precision, --/D QSO probability from the public XDQSO catalog
    photoz_xdqso double precision, --/D Photometric redshift of QSO from the public XDQSO catalog
    prob_rf_gaia_unwise double precision, --/D AGN probability from the Gaia-unWISE AGN catalog
    photoz_gaia_unwise double precision, --/D Photometric redshift from the Gaia-unWISE AGN catalog
    des_var_sn_max double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS in grizy bands (DES).
    ps1_var_sn_max double precision, --/D The maximum signal-to-noise ratio of the measured intrinsic RMS over 5 bands (PS1).
    spec_q integer, --/D flag indicating if the object was spectroscopically confirmed as QSO from earlier surveys (-9=False, 1=True). Note that contents of this column are incorrect in this version of the table.
    spec_strmask character varying(6), --/D string format of spec_bitmask, e.g., '000001'.
    spec_bitmask bigint, --/D bitmask - bit 0: SDSS-DR14Q, bit 1: SDSS-DR7Q, bit 2: OzDES-DR1Q, bit 3: SDSS-RM_Q, bit 4: COSMOS_Q, bit 5: Milliquas_QA. (Note: Milliquas_QA=1 are objects spectroscopically classified as broad-line QSO/AGN in the Million Quasars (MILLIQUAS) catalog.)
    specz double precision, --/D spectroscopic redshift from multiple surveys. Priority: SDSS-RM_Q/COSMOS_Q > SDSS-DR14Q > SDSS-DR7Q > OzDES-DR1Q > Milliquas_QA
    specz_ref character varying(16), --/D Reference of specz.
    photo_q integer, --/D flag indicating if the object was selected as QSO in public photometric quasar catalogs.
    photo_strmask character varying(3), --/D string format of photo_bitmask
    photo_bitmask bigint, --/D bit mask, bit 0: XDQSO catalog, bit 1: Gaia-unWISE AGN catalog; bit 2: Milliquas_photo: photometric quasar candidates in the Milliquas catalog
    photoz double precision, --/D Photometric redshift from public photometric quasar catalogs. Priority: XDQSO > Gaia-unWISE > Milliquas_photo
    pqso_photo double precision, --/D QSO probability from public photometric quasar catalogs.
    photoz_ref character varying(16), --/D photoz reference.
    pk bigint NOT NULL, --/D primary key for the database table
    psfmag_des_g double precision, --/U mag --/D DES PSF photometry 
    psfmag_des_r double precision, --/U mag --/D DES PSF photometry 
    psfmag_des_i double precision, --/U mag --/D DES PSF photometry 
    psfmag_des_z double precision, --/U mag --/D DES PSF photometry 
    psfmag_des_y double precision, --/U mag --/D DES PSF photometry 
    psfmagerr_des_g double precision, --/U mag --/D DES PSF photometry error 
    psfmagerr_des_r double precision, --/U mag --/D DES PSF photometry error 
    psfmagerr_des_i double precision, --/U mag --/D DES PSF photometry error 
    psfmagerr_des_z double precision, --/U mag --/D DES PSF photometry error 
    psfmagerr_des_y double precision, --/U mag --/D DES PSF photometry error 
    mag_auto_des_g double precision, --/U mag --/D DES auto photometry 
    mag_auto_des_r double precision, --/U mag --/D DES auto photometry 
    mag_auto_des_i double precision, --/U mag --/D DES auto photometry 
    mag_auto_des_z double precision, --/U mag --/D DES auto photometry 
    mag_auto_des_y double precision, --/U mag --/D DES auto photometry 
    magerr_auto_des_g double precision, --/U mag --/D DES auto photometry error 
    magerr_auto_des_r double precision, --/U mag --/D DES auto photometry error 
    magerr_auto_des_i double precision, --/U mag --/D DES auto photometry error 
    magerr_auto_des_z double precision, --/U mag --/D DES auto photometry error 
    magerr_auto_des_y double precision, --/U mag --/D DES auto photometry error 
    imaflags_iso_g integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    imaflags_iso_r integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    imaflags_iso_i integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    imaflags_iso_z integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    imaflags_iso_y integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    psfmag_ps1_g double precision, --/U mag --/D PS1 PSF magnitude 
    psfmag_ps1_r double precision, --/U mag --/D PS1 PSF magnitude 
    psfmag_ps1_i double precision, --/U mag --/D PS1 PSF magnitude 
    psfmag_ps1_z double precision, --/U mag --/D PS1 PSF magnitude 
    psfmag_ps1_y double precision, --/U mag --/D PS1 PSF magnitude 
    psfmagerr_ps1_g double precision, --/U mag --/D PS1 PSF magnitude error 
    psfmagerr_ps1_r double precision, --/U mag --/D PS1 PSF magnitude error 
    psfmagerr_ps1_i double precision, --/U mag --/D PS1 PSF magnitude error 
    psfmagerr_ps1_z double precision, --/U mag --/D PS1 PSF magnitude error 
    psfmagerr_ps1_y double precision, --/U mag --/D PS1 PSF magnitude error 
    kronmag_ps1_g double precision, --/U mag --/D PS1 Kron magnitude 
    kronmag_ps1_r double precision, --/U mag --/D PS1 Kron magnitude 
    kronmag_ps1_i double precision, --/U mag --/D PS1 Kron magnitude 
    kronmag_ps1_z double precision, --/U mag --/D PS1 Kron magnitude 
    kronmag_ps1_y double precision, --/U mag --/D PS1 Kron magnitude 
    kronmagerr_ps1_g double precision, --/U mag --/D PS1 Kron magnitude error 
    kronmagerr_ps1_r double precision, --/U mag --/D PS1 Kron magnitude error 
    kronmagerr_ps1_i double precision, --/U mag --/D PS1 Kron magnitude error 
    kronmagerr_ps1_z double precision, --/U mag --/D PS1 Kron magnitude error 
    kronmagerr_ps1_y double precision, --/U mag --/D PS1 Kron magnitude error 
    infoflag2_g integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_r integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_i integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_z integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_y integer, --/D PS1 flags, values listed in DetectionFlags2
    mag_nsc_g double precision, --/U mag --/D Weighted-average magnitude 
    mag_nsc_r double precision, --/U mag --/D Weighted-average magnitude 
    mag_nsc_i double precision, --/U mag --/D Weighted-average magnitude 
    mag_nsc_z double precision, --/U mag --/D Weighted-average magnitude 
    mag_nsc_y double precision, --/U mag --/D Weighted-average magnitude 
    magerr_nsc_g double precision, --/U mag --/D Weighted-average NSC magnitude 
    magerr_nsc_r double precision, --/U mag --/D Weighted-average NSC magnitude 
    magerr_nsc_i double precision, --/U mag --/D Weighted-average NSC magnitude 
    magerr_nsc_z double precision, --/U mag --/D Weighted-average NSC magnitude 
    magerr_nsc_y double precision, --/U mag --/D Weighted-average NSC magnitude 
    psfmag_sdss_u double precision, --/U mag --/D SDSS PSF magnitude 
    psfmag_sdss_g double precision, --/U mag --/D SDSS PSF magnitude 
    psfmag_sdss_r double precision, --/U mag --/D SDSS PSF magnitude 
    psfmag_sdss_i double precision, --/U mag --/D SDSS PSF magnitude 
    psfmag_sdss_z double precision, --/U mag --/D SDSS PSF magnitude 
    psfmagerr_sdss_u double precision, --/U mag --/D SDSS PSF magnitude error 
    psfmagerr_sdss_g double precision, --/U mag --/D SDSS PSF magnitude error 
    psfmagerr_sdss_r double precision, --/U mag --/D SDSS PSF magnitude error 
    psfmagerr_sdss_i double precision, --/U mag --/D SDSS PSF magnitude error 
    psfmagerr_sdss_z double precision, --/U mag --/D SDSS PSF magnitude error 
    modelmag_sdss_u double precision, --/U mag --/D SDSS Model magnitude 
    modelmag_sdss_g double precision, --/U mag --/D SDSS Model magnitude 
    modelmag_sdss_r double precision, --/U mag --/D SDSS Model magnitude 
    modelmag_sdss_i double precision, --/U mag --/D SDSS Model magnitude 
    modelmag_sdss_z double precision, --/U mag --/D SDSS Model magnitude 
    modelmagerr_sdss_u double precision, --/U mag --/D SDSS Model magnitude error 
    modelmagerr_sdss_g double precision, --/U mag --/D SDSS Model magnitude error 
    modelmagerr_sdss_r double precision, --/U mag --/D SDSS Model magnitude error 
    modelmagerr_sdss_i double precision, --/U mag --/D SDSS Model magnitude error 
    modelmagerr_sdss_z double precision, --/U mag --/D SDSS Model magnitude error 
    mag_gaia_g double precision, --/U mag --/D Gaia DR2 G-band magnitude, Vega 
    mag_gaia_bp double precision, --/U mag --/D Gaia DR2 BP-band magnitude, Vega 
    mag_gaia_rp double precision, --/U mag --/D Gaia DR2 RP-band magnitude, Vega 
    magerr_gaia_g double precision, --/U mag --/D Gaia DR2 G-band magnitude error, Vega 
    magerr_gaia_bp double precision, --/U mag --/D Gaia DR2 BP-band magnitude error, Vega 
    magerr_gaia_rp double precision, --/U mag --/D Gaia DR2 RP-band magnitude error, Vega 
    mag_unwise_w1 double precision, --/U mag --/D unWISE (Vega) magnitude, 
    mag_unwise_w2 double precision, --/U mag --/D unWISE (Vega) magnitude, 
    magerr_unwise_w1 double precision, --/U mag --/D unWISE (Vega) magnitude error, 
    magerr_unwise_w2 double precision, --/U mag --/D unWISE (Vega) magnitude error, 
    flags_unwise_w1 integer, --/D unWISE Coadd Flags
    flags_unwise_w2 integer, --/D unWISE Coadd Flags
    mag_ir_y double precision, --/U mag --/D (Vega) magnitude in near-IR, 
    mag_ir_j double precision, --/U mag --/D (Vega) magnitude in near-IR, 
    mag_ir_h double precision, --/U mag --/D (Vega) magnitude in near-IR, 
    mag_ir_k double precision, --/U mag --/D (Vega) magnitude in near-IR, 
    magerr_ir_y double precision, --/U mag --/D magnitude error in near-IR 
    magerr_ir_j double precision, --/U mag --/D magnitude error in near-IR 
    magerr_ir_h double precision, --/U mag --/D magnitude error in near-IR 
    magerr_ir_k double precision, --/U mag --/D magnitude error in near-IR 
    des_var_nepoch_g integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_r integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_i integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_z integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_y integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_status_g integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_r integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_i integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_z integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_y integer, --/D Status of intrinsic variability calculation from DES
    des_var_rms_g double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_rms_r double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_rms_i double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_rms_z double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_rms_y double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_sigrms_g double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sigrms_r double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sigrms_i double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sigrms_z double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sigrms_y double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sn_g double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_r double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_i double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_z double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_y double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    ps1_var_nepoch_g integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_r integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_i integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_z integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_y integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_status_g integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_r integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_i integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_z integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_y integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_rms_g double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_rms_r double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_rms_i double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_rms_z double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_rms_y double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_sigrms_g double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sigrms_r double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sigrms_i double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sigrms_z double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sigrms_y double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sn_g double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_r double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_i double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_z double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_y double precision --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
);



--
-- Name: dr19_bhm_rm_v0_2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_bhm_rm_v0_2 (
----------------------------------------------------------------------
--/H Parent sample for the RM project, used to select confirmed and candidate quasar targets for the BHM-RM Program in SDSS-V. For more details please see Yang and Shen, (2022, https://ui.adsabs.harvard.edu/abs/2022arXiv220608989Y/abstract).
--/T This table contains all photometric objects detected in the COSMOS, SDSS-RM,
--/T XMM-LSS, CDFS, S-CVZ, and ELAIS-S1 fields., within a circular area of 10
--/T degree^2 from the field center. <br>
--/T Field center: Name     RA          DEC <br>
--/T               XMM-LSS  02:22:50.00    -04:45:00.0 <br>
--/T               CDFS     03:30:35.60    -28:06:00.0 <br>
--/T               EDFS     04:04:57.84    -48:25:22.8 <br>
--/T               ELAIS-S1 00:37:48.00    -44:00:00.0 <br>
--/T               COSMOS   10:00:00.00    +02:12:00.0 <br>
--/T               SDSS-RM  14:14:49.00    +53:05:00.0 <br>
--/T               S-CVZ    06:00:00.00    -66:33:38.0 <br>
--/T The table includes information from the following survey data releases: <br>
--/T DES: Dark Energy Survey, Y6, Y6A1_COADD_OBJECT_SUMMARY <br>
--/T PS1: Pan-STARRS, DR1, StackObjectThin <br>
--/T NSC: NOAO Source Catalog, DR1, nsc_dr1.object <br>
--/T SDSS: Sloan Digital Sky Survey, DR14, PhotoObjAll <br>
--/T Gaia: DR2, gaia_dr2.gaia_source <br>
--/T unWISE: DR1 <br>
--/T Near-infrared: LAS: UKIDSS Large Area Surveys (DR11), <br>
--/T                UHS: UKIRT Hemisphere Survey (DR1), <br>
--/T                VHS: VISTA Hemisphere Survey (DR6), <br>
--/T                Viking: VISTA Kilo-Degree Infrared Galaxy Survey (DR5), <br>
--/T                VIDEO: VISTA Deep Extragalactic Observations Survey (DR5), <br>
--/T                VMC: VISTA Magellanic Cloud Survey (DR4) <br>
--/T Values are set to -9.0 or -9 if null. <br>
--/T The dr19_bhm_rm_v0_2 table corresponds to Version: v0.2, 06/30/2020 <br>
--/T Changes (wrt v0) include correct error in spec_q column, and add specz from
--/T OzDES DR2
----------------------------------------------------------------------
    field_name character varying(8), --/D One of COSMOS, SDSS-RM, XMM-LSS, CDFS, S-CVZ, or ELAIS-S1
    ra double precision, --/U deg --/D Fiducial Right Ascension (J2000) 
    "dec" double precision, --/U deg --/D Fiducial Declination (J2000) 
    distance double precision, --/U deg --/D Angular distance from the field center 
    pos_ref character varying(4), --/D Fiducial coordinates reference, priority: Gaia > DES > PS1 > NSC
    ebv double precision, --/D Galactic E(B−V) reddening from Schlegel et al. (1998)
    des integer, --/D A flag set to 1 if in DES photometric catalog
    coadd_object_id bigint, --/D DES coadd object ID
    ra_des double precision, --/U deg --/D DES Right Ascension (J2000) 
    dec_des double precision, --/U deg --/D DES Declination (J2000) 
    extended_coadd integer, --/D DES type classifier: 0 (high-confidence stars), 1 (likely stars), 2 (mostly galaxies), and 3 (high-confidence galaxies)
    separation_des double precision, --/U arcsec --/D Angular distance between DES position and the fiducial coordinates 
    ps1 integer, --/D A flag set to 1 if in PS1 photometric catalog
    objid_ps1 bigint, --/D PS1 unique object identifier
    ra_ps1 double precision, --/U deg --/D PS1 right ascension from i filter stack detection 
    dec_ps1 double precision, --/U deg --/D PS1 declination from i filter stack detection 
    class_ps1 double precision, --/D PS1 source classification = iPsfMag - iKronMag
    separation_ps1 double precision, --/U arcsec --/D Angular distance between PS1 position and the fiducial coordinates 
    nsc integer, --/D A flag set to 1 if in  photometric catalog
    id_nsc bigint, --/D NSC unique object identifier
    ra_nsc double precision, --/U deg --/D Right Ascension (J2000) 
    dec_nsc double precision, --/U deg --/D Declination (J2000) 
    class_star double precision, --/D NSC Star/Galaxy classifier
    flags_nsc integer, --/D NSC SExtractor flag value
    separation_nsc double precision, --/U arcsec --/D Angular distance between NSC position and the fiducial coordinates 
    sdss integer, --/D A flag set to 1 if in SDSS photometric catalog
    objid_sdss bigint, --/D Unique SDSS identifier
    ra_sdss double precision, --/U deg --/D Right Ascension (J2000) 
    dec_sdss double precision, --/U deg --/D Declination (J2000) 
    type_sdss integer, --/D SDSS type classifier (star 6, galaxy 3, etc.)
    clean_sdss integer, --/D SDSS clean photometry flag (1=clean, 0=unclean)
    separation_sdss double precision, --/U arcsec --/D Angular distance between SDSS position and the fiducial coordinates 
    gaia integer, --/D A flag set to 1 if in Gaia DR2 photometric catalog
    source_id_gaia bigint, --/D Gaia DR2 unique source identifier
    mg double precision, --/U mag --/D Gaia g-band magnitude (phot_g_mean_mag in Gaia catalog, Vega) 
    parallax double precision, --/U mas --/D Parallax, Angle, 
    parallax_error double precision, --/U mas --/D Standard error of parallax, Angle, 
    plxsig double precision, --/D Parallax significance defined as (PARALLAX/PARALLAX_ERROR)
    pmra double precision, --/U mas/year --/D Proper motion in RA direction, Angular Velocity, 
    pmra_error double precision, --/U mas/year --/D Standard error of proper motion in RA direction, Angular Velocity, 
    pmdec double precision, --/U mas/year --/D Proper motion in DEC direction, Angular Velocity, 
    pmdec_error double precision, --/U mas/year --/D Standard error of proper motion in DEC direction, Angular Velocity, 
    pmsig double precision, --/D Proper motion significance defined as (pmra^2+pmdec^2)/sqrt(pmra^2*pmra_error^2 + pmdec^2*pmdec_error^2)
    unwise integer, --/D A flag set to 1 if in unWISE photometric catalog
    objid_unwise character varying(16), --/D unWISE unique object id
    ra_unwise double precision, --/U deg --/D unWISE Right Ascension (J2000) 
    dec_unwise double precision, --/U deg --/D unWISE Declination (J2000) 
    separation_unwise double precision, --/U arcsec --/D Angular distance between unWISE position and the fiducial coordinates 
    near_ir integer, --/D A flag set to 1 if in NIR photometric catalog
    survey_ir character varying(6), --/D Near-IR survey name: LAS, UHS, VHS, Viking, VMC, VIDEO
    sourceid_ir bigint, --/D NIR source identifier
    ra_ir double precision, --/U deg --/D NIR Right Ascension (J2000) 
    dec_ir double precision, --/U deg --/D NIR Declination (J2000) 
    separation_ir double precision, --/U arcsec --/D Angular distance between NIR position and the fiducial coordinates 
    optical_survey character varying(4), --/D Optical survey used in Skewt-QSO, e.g., DES, PS1, Gaia, NSC
    mi double precision, --/U mag --/D i-band PSF magnitude (galactic extinction not corrected) 
    cal_skewt_qso integer, --/D A flag indicates whether Skewt-QSO is calculated.(Set to 1 when Nband_Optical_use > 2.)
    nband_optical_use integer, --/D Number of optical bands used in Skewt-QSQ.
    use_unwise integer, --/D Set to 1 when unWISE photometry is used in Skewt-QSO calculation.
    use_nir integer, --/D Set to 1 when NIR photometry is usedin Skewt-QSO calculation.
    photo_combination character varying(17), --/D The photometric data combinations used in Skewt-QSO, for example, "DECam-YJHK-unWISE" - DECam/PS1 includes grizy bands; unWISE incldes unWISE W1 and W2 bands; and Gaia includes Gaia bp, g, and rp bands
    log_qso double precision, --/D The (natural) logarithmic probability of a target fitting to QSO colors convolved with a QLF. Set to -323 if log_QSO<-323 (close to the lower limit of double-precision data).
    log_star double precision, --/D The logarithmic probability of a target fitting to star colors multiplied by star number counts based on a stellar simulation. Set to -323 if log_Star<-323.
    log_galaxy double precision, --/D The logarithmic probability of a target fitting to galaxy colors convolved with a GLF. Set to -323 if  log_Galaxy<-323.
    p_qso double precision, --/D QSO probability from Skewt-QSO. P_QSO = exp(log_qso)/(exp(log_qso) + exp(log_star) + exp(log_galaxy))
    p_star real, --/D Star probability from Skewt-QSO.
    p_galaxy double precision, --/D Galaxy probability from Skewt-QSO.
    class_skewt_qso character varying(6), --/D Classification based on the highest probability from Skewt-QSO, QSO/Star/Galaxy
    skewt_qso integer, --/D flag indicating whether the object is a QSO (same as class_skewt_qso, except additionally requiring log_QSO>-10). (P_QSO>P_Star & P_QSO>P_galaxy & log_QSO>-10)
    p_qso_prior double precision, --/D QSO probability with prior probabilities from additional info, such as separation (between optical survey and unWISE), morphology, variability, and/or proper motion.(Note: *_Prior are generally not populated in this version, except for the "S-CVZ" field, where we take into account the separation between optical surveys and unWISE.)
    p_star_prior real, --/D Star probability with prior probabilities.
    p_galaxy_prior double precision, --/D Galaxy probability with prior probabilities.
    class_skewt_qso_prior character varying(6), --/D Classification based on Skewt-QSO with prior probabilities described above.
    skewt_qso_prior integer, --/D flag indicating whether the object is QSO based on Skewt-QSO with prior probabilities described above.
    photoz_qso double precision, --/D Photometric redshift of QSO from Skewt-QSO
    photoz_qso_lower double precision, --/D Lower limit of photoz_QSO
    photoz_qso_upper double precision, --/D Upper limit of photoz_QSO
    prob_photoz_qso double precision, --/D The total probability of z located between photoz_QSO_lower and photoz_QSO_upper (assuming it is QSO).
    photoz_galaxy double precision, --/D Photometric redshift of Galaxy from Skewt-QSO (fitting to galaxy colors).
    photoz_galaxy_lower double precision, --/D Lower limit of photoz_Galaxy.
    photoz_galaxy_upper double precision, --/D Upper limit of photoz_Galaxy.
    pqso_xdqso double precision, --/D QSO probability from the public XDQSO catalog
    photoz_xdqso double precision, --/D Photometric redshift of QSO from the public XDQSO catalog
    prob_rf_gaia_unwise double precision, --/D AGN probability from the Gaia-unWISE AGN catalog
    photoz_gaia_unwise double precision, --/D Photometric redshift from the Gaia-unWISE AGN catalog
    des_var_sn_max double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS in grizy bands (DES).
    ps1_var_sn_max double precision, --/D The maximum signal-to-noise ratio of the measured intrinsic RMS over 5 bands (PS1).
    spec_q integer, --/D flag indicating if the object was spectroscopically confirmed as QSO from earlier surveys (-9=False, 1=True)
    spec_strmask character varying(6), --/D string format of spec_bitmask, e.g., '000001'.
    spec_bitmask bigint, --/D bitmask - bit 0: SDSS-DR14Q, bit 1: SDSS-DR7Q, bit 2: OzDES-DR1Q, bit 3: SDSS-RM_Q, bit 4: COSMOS_Q, bit 5: Milliquas_QA. (Note: Milliquas_QA=1 are objects spectroscopically classified as broad-line QSO/AGN in the Million Quasars (MILLIQUAS) catalog.)
    specz double precision, --/D spectroscopic redshift from multiple surveys. Priority: SDSS-RM_Q/COSMOS_Q > SDSS-DR14Q > SDSS-DR7Q > OzDES-DR1Q > Milliquas_QA
    specz_ref character varying(16), --/D Reference of specz.
    photo_q integer, --/D flag indicating if the object was selected as QSO in public photometric quasar catalogs.
    photo_strmask character varying(3), --/D string format of photo_bitmask
    photo_bitmask bigint, --/D bit mask, bit 0: XDQSO catalog, bit 1: Gaia-unWISE AGN catalog; bit 2: Milliquas_photo: photometric quasar candidates in the Milliquas catalog
    photoz double precision, --/D Photometric redshift from public photometric quasar catalogs. Priority: XDQSO > Gaia-unWISE > Milliquas_photo
    pqso_photo double precision, --/D QSO probability from public photometric quasar catalogs.
    photoz_ref character varying(16), --/D photoz reference.
    pk bigint NOT NULL, --/D primary key for the database table
    psfmag_des_g double precision, --/U mag --/D DES PSF photometry 
    psfmag_des_r double precision, --/U mag --/D DES PSF photometry 
    psfmag_des_i double precision, --/U mag --/D DES PSF photometry 
    psfmag_des_z double precision, --/U mag --/D DES PSF photometry 
    psfmag_des_y double precision, --/U mag --/D DES PSF photometry 
    psfmagerr_des_g double precision, --/U mag --/D DES PSF photometry error 
    psfmagerr_des_r double precision, --/U mag --/D DES PSF photometry error 
    psfmagerr_des_i double precision, --/U mag --/D DES PSF photometry error 
    psfmagerr_des_z double precision, --/U mag --/D DES PSF photometry error 
    psfmagerr_des_y double precision, --/U mag --/D DES PSF photometry error 
    mag_auto_des_g double precision, --/U mag --/D DES auto photometry 
    mag_auto_des_r double precision, --/U mag --/D DES auto photometry 
    mag_auto_des_i double precision, --/U mag --/D DES auto photometry 
    mag_auto_des_z double precision, --/U mag --/D DES auto photometry 
    mag_auto_des_y double precision, --/U mag --/D DES auto photometry 
    magerr_auto_des_g double precision, --/U mag --/D DES auto photometry error 
    magerr_auto_des_r double precision, --/U mag --/D DES auto photometry error 
    magerr_auto_des_i double precision, --/U mag --/D DES auto photometry error 
    magerr_auto_des_z double precision, --/U mag --/D DES auto photometry error 
    magerr_auto_des_y double precision, --/U mag --/D DES auto photometry error 
    imaflags_iso_g integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    imaflags_iso_r integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    imaflags_iso_i integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    imaflags_iso_z integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    imaflags_iso_y integer, --/D DES flag identifying sources with missing/flagged pixels, considering all single epoch images
    psfmag_ps1_g double precision, --/U mag --/D PS1 PSF magnitude 
    psfmag_ps1_r double precision, --/U mag --/D PS1 PSF magnitude 
    psfmag_ps1_i double precision, --/U mag --/D PS1 PSF magnitude 
    psfmag_ps1_z double precision, --/U mag --/D PS1 PSF magnitude 
    psfmag_ps1_y double precision, --/U mag --/D PS1 PSF magnitude 
    psfmagerr_ps1_g double precision, --/U mag --/D PS1 PSF magnitude error 
    psfmagerr_ps1_r double precision, --/U mag --/D PS1 PSF magnitude error 
    psfmagerr_ps1_i double precision, --/U mag --/D PS1 PSF magnitude error 
    psfmagerr_ps1_z double precision, --/U mag --/D PS1 PSF magnitude error 
    psfmagerr_ps1_y double precision, --/U mag --/D PS1 PSF magnitude error 
    kronmag_ps1_g double precision, --/U mag --/D PS1 Kron magnitude 
    kronmag_ps1_r double precision, --/U mag --/D PS1 Kron magnitude 
    kronmag_ps1_i double precision, --/U mag --/D PS1 Kron magnitude 
    kronmag_ps1_z double precision, --/U mag --/D PS1 Kron magnitude 
    kronmag_ps1_y double precision, --/U mag --/D PS1 Kron magnitude 
    kronmagerr_ps1_g double precision, --/U mag --/D PS1 Kron magnitude error 
    kronmagerr_ps1_r double precision, --/U mag --/D PS1 Kron magnitude error 
    kronmagerr_ps1_i double precision, --/U mag --/D PS1 Kron magnitude error 
    kronmagerr_ps1_z double precision, --/U mag --/D PS1 Kron magnitude error 
    kronmagerr_ps1_y double precision, --/U mag --/D PS1 Kron magnitude error 
    infoflag2_g integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_r integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_i integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_z integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_y integer, --/D PS1 flags, values listed in DetectionFlags2
    mag_nsc_g double precision, --/U mag --/D Weighted-average magnitude 
    mag_nsc_r double precision, --/U mag --/D Weighted-average magnitude 
    mag_nsc_i double precision, --/U mag --/D Weighted-average magnitude 
    mag_nsc_z double precision, --/U mag --/D Weighted-average magnitude 
    mag_nsc_y double precision, --/U mag --/D Weighted-average magnitude 
    magerr_nsc_g double precision, --/U mag --/D Weighted-average NSC magnitude 
    magerr_nsc_r double precision, --/U mag --/D Weighted-average NSC magnitude 
    magerr_nsc_i double precision, --/U mag --/D Weighted-average NSC magnitude 
    magerr_nsc_z double precision, --/U mag --/D Weighted-average NSC magnitude 
    magerr_nsc_y double precision, --/U mag --/D Weighted-average NSC magnitude 
    psfmag_sdss_u double precision, --/U mag --/D SDSS PSF magnitude 
    psfmag_sdss_g double precision, --/U mag --/D SDSS PSF magnitude 
    psfmag_sdss_r double precision, --/U mag --/D SDSS PSF magnitude 
    psfmag_sdss_i double precision, --/U mag --/D SDSS PSF magnitude 
    psfmag_sdss_z double precision, --/U mag --/D SDSS PSF magnitude 
    psfmagerr_sdss_u double precision, --/U mag --/D SDSS PSF magnitude error 
    psfmagerr_sdss_g double precision, --/U mag --/D SDSS PSF magnitude error 
    psfmagerr_sdss_r double precision, --/U mag --/D SDSS PSF magnitude error 
    psfmagerr_sdss_i double precision, --/U mag --/D SDSS PSF magnitude error 
    psfmagerr_sdss_z double precision, --/U mag --/D SDSS PSF magnitude error 
    modelmag_sdss_u double precision, --/U mag --/D SDSS Model magnitude 
    modelmag_sdss_g double precision, --/U mag --/D SDSS Model magnitude 
    modelmag_sdss_r double precision, --/U mag --/D SDSS Model magnitude 
    modelmag_sdss_i double precision, --/U mag --/D SDSS Model magnitude 
    modelmag_sdss_z double precision, --/U mag --/D SDSS Model magnitude 
    modelmagerr_sdss_u double precision, --/U mag --/D SDSS Model magnitude error 
    modelmagerr_sdss_g double precision, --/U mag --/D SDSS Model magnitude error 
    modelmagerr_sdss_r double precision, --/U mag --/D SDSS Model magnitude error 
    modelmagerr_sdss_i double precision, --/U mag --/D SDSS Model magnitude error 
    modelmagerr_sdss_z double precision, --/U mag --/D SDSS Model magnitude error 
    mag_gaia_g double precision, --/U mag --/D Gaia DR2 G-band magnitude, Vega 
    mag_gaia_bp double precision, --/U mag --/D Gaia DR2 BP-band magnitude, Vega 
    mag_gaia_rp double precision, --/U mag --/D Gaia DR2 RP-band magnitude, Vega 
    magerr_gaia_g double precision, --/U mag --/D Gaia DR2 G-band magnitude error, Vega 
    magerr_gaia_bp double precision, --/U mag --/D Gaia DR2 BP-band magnitude error, Vega 
    magerr_gaia_rp double precision, --/U mag --/D Gaia DR2 RP-band magnitude error, Vega 
    mag_unwise_w1 double precision, --/U mag --/D unWISE (Vega) magnitude, 
    mag_unwise_w2 double precision, --/U mag --/D unWISE (Vega) magnitude, 
    magerr_unwise_w1 double precision, --/U mag --/D unWISE (Vega) magnitude error, 
    magerr_unwise_w2 double precision, --/U mag --/D unWISE (Vega) magnitude error, 
    flags_unwise_w1 integer, --/D unWISE Coadd Flags
    flags_unwise_w2 integer, --/D unWISE Coadd Flags
    mag_ir_y double precision, --/U mag --/D (Vega) magnitude in near-IR, 
    mag_ir_j double precision, --/U mag --/D (Vega) magnitude in near-IR, 
    mag_ir_h double precision, --/U mag --/D (Vega) magnitude in near-IR, 
    mag_ir_k double precision, --/U mag --/D (Vega) magnitude in near-IR, 
    magerr_ir_y double precision, --/U mag --/D magnitude error in near-IR 
    magerr_ir_j double precision, --/U mag --/D magnitude error in near-IR 
    magerr_ir_h double precision, --/U mag --/D magnitude error in near-IR 
    magerr_ir_k double precision, --/U mag --/D magnitude error in near-IR 
    des_var_nepoch_g integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_r integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_i integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_z integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_y integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_status_g integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_r integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_i integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_z integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_y integer, --/D Status of intrinsic variability calculation from DES
    des_var_rms_g double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_rms_r double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_rms_i double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_rms_z double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_rms_y double precision, --/U mag --/D Intrinsic RMS from DES 
    des_var_sigrms_g double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sigrms_r double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sigrms_i double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sigrms_z double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sigrms_y double precision, --/U mag --/D Error of intrinsic RMS from DES 
    des_var_sn_g double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_r double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_i double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_z double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_y double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    ps1_var_nepoch_g integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_r integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_i integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_z integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_y integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_status_g integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_r integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_i integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_z integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_y integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_rms_g double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_rms_r double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_rms_i double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_rms_z double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_rms_y double precision, --/U mag --/D Intrinsic RMS from PS1 
    ps1_var_sigrms_g double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sigrms_r double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sigrms_i double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sigrms_z double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sigrms_y double precision, --/U mag --/D Error of intrinsic RMS from PS1 
    ps1_var_sn_g double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_r double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_i double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_z double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_y double precision --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
);



--
-- Name: dr19_bhm_spiders_agn_superset; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_bhm_spiders_agn_superset (
----------------------------------------------------------------------
--/H One of several tables describing optical/IR counterparts to eROSITA
--/T X-ray sources identified via various methods.  These tables contain a <br>
--/T superset of potential targets from which the SDSS-V spectroscopic <br>
--/T targets were drawn.  The dr19_bhm_spiders_agn_superset table includes <br>
--/T is expected to be dominated by Active Galactic Nuclei (AGN) <br>
--/T but should also include a significant minority of galaxies, stars and <br>
--/T other Galactic sources. <br>
--/T Each row corresponds to one possible match between an X-ray source and <br>
--/T a potential optical/IR counterpart.  The X-ray columns (ero_*) record <br>
--/T the eROSITA information known at the time of target selection and may <br>
--/T differ from publicly available eROSITA catalogs. The <br>
--/T dr19_bhm_spiders_*_superset tables are derived from <br>
--/T eROSITA observations of the eROSITA Final <br>
--/T Equatorial Depth performance verification field ('eFEDS').
----------------------------------------------------------------------
    pk bigint NOT NULL, --/D primary key of table entry
    ero_version text, --/D Identifier giving the eROSITA dataset and processing version e.g. 'eFEDS_c940', 'em01_c946_201008_poscorr' etc
    ero_detuid text, --/D The standard official eROSITA unique detection identifier, e.g. 'em01_123456_020_ML12345_001_c946' etc
    ero_flux real, --/U erg/cm2/s --/D X-ray flux, usually in the main eROSITA detection band (0.2-2.3keV). 
    ero_flux_err real, --/U erg/cm2/s --/D Uncertainty on X-ray flux 
    ero_ext real, --/U arcsec --/D X-ray extent parameter 
    ero_ext_err real, --/U arcsec --/D Uncertainty on X-ray extent parameter 
    ero_ext_like real, --/D Likelihood of X-ray source being extended
    ero_det_like real, --/D X-ray detection likelihood
    ero_ra double precision, --/U deg --/D Best determination of X-ray position, J2000 
    ero_dec double precision, --/U deg --/D Best determination of X-ray position, J2000 
    ero_radec_err real, --/U arcsec --/D Best estimate of X-ray position uncertainty 
    xmatch_method text, --/D The X-ray-to-optical/IR cross-match method that was used in this case e.g. 'XPS-ML/NWAY', 'CLUSTERS_EFEDS_MULTIPLE' etc
    xmatch_version text, --/D The cross-match software version and OIR catalog used e.g. 'LSdr8-JWMS_v2.1LSdr8-JWMS_v2.1', 'LSdr8-AG_v1,JC_16032020', 'eromapper_2020-10-12', 'CW20ps1dr2-v011220' etc
    xmatch_dist real, --/U arcsec --/D Distance between X-ray position and optical counterpart 
    xmatch_metric real, --/D Metric giving quality of cross-match. Meaning is dependent on xmatch_method, e.g. p_any for NWAY
    xmatch_flags bigint, --/D Flags indicating cross-match properties (e.g. status flags), xmatch_method dependent
    target_class text, --/D Best guess of source classification at time of xmatch e.g. 'GALAXY','STAR','QSO','UNKNOWN',....
    target_priority integer, --/D Relative to other targets in this catalog, interpreted/adapted later to derive a final target priority
    target_has_spec integer, --/D Flags used to indicate if target has good quality archival spectroscopy available
    best_opt text, --/D Describes which OIR survey provided the optical counterpart for this row of the table, i.e. which OIR cat gives the entries in fields opt_ra, opt_dec, opt_pmra, opt_pmdec, opt_epoch, and which OIR identifier is given in the *_id columns
    ls_id bigint, --/D Identifier of counterpart (if any) in dr19_legacy_survey_dr8 ('ls_id' field). Arithmetically derived from legacysurvey sweep file columns: release, brickid and objid:  ls_id = objid + (brickid * 2**16) + (release * 2**40)
    ps1_dr2_objid bigint, --/D Identifier of counterpart (if any) in dr19_panstarrs1 (catid_objid field). Identical to MAST 'ippObjID' identifier
    gaia_dr2_source_id bigint, --/D Identifier of counterpart (if any) in dr19_gaia_dr2_source ('source_id' field)
    unwise_dr1_objid text, --/D Identifier of counterpart (if any) in dr19_unwise (not used)
    des_dr1_coadd_object_id bigint, --/D Identifier of counterpart (if any) in DES/dr1 coadd catalogg (not used)
    sdss_dr16_objid bigint, --/D Identifier of counterpart (if any) in SDSS dr16 photobj table (not used)
    opt_ra double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_dec double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_pmra real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only  
    opt_pmdec real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_epoch real, --/U decimal year --/D Epoch of opt_ra,opt_dec 
    opt_modelflux_g real, --/U nanomaggy --/D optical magnitude of counterpart, included for validity checks only 
    opt_modelflux_ivar_g real, --/U 1/nanomaggy^2 --/D uncertainty on optical magnitude of counterpart, included for validity checks only 
    opt_modelflux_r real, --/U nanomaggy --/D optical magnitude of counterpart, included for validity checks only  
    opt_modelflux_ivar_r real, --/U 1/nanomaggy^2 --/D uncertainty on optical magnitude of counterpart, included for validity checks only 
    opt_modelflux_i real, --/U nanomaggy --/D optical magnitude of counterpart, included for validity checks only  
    opt_modelflux_ivar_i real, --/U 1/nanomaggy^2 --/D uncertainty on optical magnitude of counterpart, included for validity checks only 
    opt_modelflux_z real, --/U nanomaggy --/D optical magnitude of counterpart, included for validity checks only  
    opt_modelflux_ivar_z real --/U 1/nanomaggy^2 --/D uncertainty on optical magnitude of counterpart, included for validity checks only 
);



--
-- Name: dr19_bhm_spiders_clusters_superset; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_bhm_spiders_clusters_superset (
----------------------------------------------------------------------
--/H One of several tables describing optical/IR counterparts to eROSITA
--/T X-ray sources identified via various methods.  These tables contain a <br>
--/T superset of potential targets from which the SDSS-V spectroscopic <br>
--/T targets were drawn.  The dr19_bhm_spiders_clusters_superset table includes <br>
--/T counterparts selected via algorithms optimised to find clusters of galaxies. <br>
--/T Each row corresponds to one possible match between an X-ray source and <br>
--/T a potential optical/IR counterpart.  The X-ray columns (ero_*) record <br>
--/T the eROSITA information known at the time of target selection and may <br>
--/T differ from publicly available eROSITA catalogs. The <br>
--/T dr19_bhm_spiders_*_superset tables are derived from <br>
--/T eROSITA observations of the eROSITA Final <br>
--/T Equatorial Depth performance verification field ('eFEDS').
----------------------------------------------------------------------
    pk bigint NOT NULL, --/D primary key of table entry
    ero_version text, --/D Identifier giving the eROSITA dataset and processing version e.g. 'eFEDS_c940', 'em01_c946_201008_poscorr' etc
    ero_detuid text, --/D The standard official eROSITA unique detection identifier, e.g. 'em01_123456_020_ML12345_001_c946' etc
    ero_flux real, --/U erg/cm2/s --/D X-ray flux, usually in the main eROSITA detection band (0.2-2.3keV). 
    ero_flux_err real, --/U erg/cm2/s --/D Uncertainty on X-ray flux 
    ero_ext real, --/U arcsec --/D X-ray extent parameter 
    ero_ext_err real, --/U arcsec --/D Uncertainty on X-ray extent parameter 
    ero_ext_like real, --/D Likelihood of X-ray source being extended
    ero_det_like real, --/D X-ray detection likelihood
    ero_ra double precision, --/U deg --/D Best determination of X-ray position, J2000 
    ero_dec double precision, --/U deg --/D Best determination of X-ray position, J2000 
    ero_radec_err real, --/U arcsec --/D Best estimate of X-ray position uncertainty 
    xmatch_method text, --/D The X-ray-to-optical/IR cross-match method that was used in this case e.g. 'XPS-ML/NWAY', 'CLUSTERS_EFEDS_MULTIPLE' etc
    xmatch_version text, --/D The cross-match software version and OIR catalog used e.g. 'LSdr8-JWMS_v2.1LSdr8-JWMS_v2.1', 'LSdr8-AG_v1,JC_16032020', 'eromapper_2020-10-12', 'CW20ps1dr2-v011220' etc
    xmatch_dist real, --/U arcsec --/D Distance between X-ray position and optical counterpart 
    xmatch_metric real, --/D Metric giving quality of cross-match. Meaning is dependent on xmatch_method, e.g. p_any for NWAY
    xmatch_flags bigint, --/D Flags indicating cross-match properties (e.g. status flags), xmatch_method dependent
    target_class text, --/D Best guess of source classification at time of xmatch e.g. 'GALAXY','STAR','QSO','UNKNOWN',....
    target_priority integer, --/D Relative to other targets in this catalog, interpreted/adapted later to derive a final target priority
    target_has_spec integer, --/D Flags used to indicate if target has good quality archival spectroscopy available
    best_opt text, --/D Describes which OIR survey provided the optical counterpart for this row of the table, i.e. which OIR cat gives the entries in fields opt_ra, opt_dec, opt_pmra, opt_pmdec, opt_epoch, and which OIR identifier is given in the *_id columns
    ls_id bigint, --/D Identifier of counterpart (if any) in dr19_legacy_survey_dr8 ('ls_id' field). Arithmetically derived from legacysurvey sweep file columns: release, brickid and objid:  ls_id = objid + (brickid * 2**16) + (release * 2**40)
    ps1_dr2_objid bigint, --/D Identifier of counterpart (if any) in dr19_panstarrs1 (catid_objid field). Identical to MAST 'ippObjID' identifier
    gaia_dr2_source_id bigint, --/D Identifier of counterpart (if any) in dr19_gaia_dr2_source ('source_id' field)
    unwise_dr1_objid text, --/D Identifier of counterpart (if any) in dr19_unwise (not used)
    des_dr1_coadd_object_id bigint, --/D Identifier of counterpart (if any) in DES/dr1 coadd catalogg (not used)
    sdss_dr16_objid bigint, --/D Identifier of counterpart (if any) in SDSS dr16 photobj table (not used)
    opt_ra double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_dec double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_pmra real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only  
    opt_pmdec real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_epoch real, --/U decimal year --/D Epoch of opt_ra,opt_dec 
    opt_modelflux_g real, --/U nanomaggy --/D optical magnitude of counterpart, included for validity checks only 
    opt_modelflux_ivar_g real, --/U 1/nanomaggy^2 --/D uncertainty on optical magnitude of counterpart, included for validity checks only 
    opt_modelflux_r real, --/U nanomaggy --/D optical magnitude of counterpart, included for validity checks only  
    opt_modelflux_ivar_r real, --/U 1/nanomaggy^2 --/D uncertainty on optical magnitude of counterpart, included for validity checks only 
    opt_modelflux_i real, --/U nanomaggy --/D optical magnitude of counterpart, included for validity checks only  
    opt_modelflux_ivar_i real, --/U 1/nanomaggy^2 --/D uncertainty on optical magnitude of counterpart, included for validity checks only 
    opt_modelflux_z real, --/U nanomaggy --/D optical magnitude of counterpart, included for validity checks only  
    opt_modelflux_ivar_z real --/U 1/nanomaggy^2 --/D uncertainty on optical magnitude of counterpart, included for validity checks only 
);



--
-- Name: dr19_cadence; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_cadence (
----------------------------------------------------------------------
--/H Cadences define the time between series of exposures (one "epoch") on a field, and the observing conditions, e.g., skybrightness, for each epoch.
----------------------------------------------------------------------
    label text, --/D Descriptive name for the cadence with a version 
    nepochs integer, --/D Number of epochs in the cadence 
    pk bigint NOT NULL, --/D Primary key 
    label_root text, --/D Descriptive name, typically {bright/dark}_{nepochs}x{nexps}
    label_version text, --/D Version; cadences are added in versioned batches 
    max_skybrightness real, --/D The maximum skybrightness for all epochs in this cadence 
    nexp_total integer --/D The total number of exposures planned for this cadence 
);



--
-- Name: dr19_cadence_epoch; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_cadence_epoch (
----------------------------------------------------------------------
--/H Constraints for a single epoch within a cadence.
----------------------------------------------------------------------
    label text NOT NULL, --/D Descriptive name for the cadence with a version 
    nepochs integer, --/D Number of epochs in the cadence 
    cadence_pk bigint, --/D Primary key of the cadence this epoch belongs to 
    epoch integer NOT NULL, --/D Which epoch is this in the cadence (0-indexed) 
    delta double precision, --/U days --/D Nominal (goal) time since previous epoch 
    skybrightness real, --/D Maximum allowed skybrightness, i.e. moon illumination (0.0 to 1.0) 
    delta_max real, --/U days --/D Maximum allowed time since previous epoch 
    delta_min real, --/U days --/D Minimum allowed time since previous epoch 
    nexp integer, --/D Number of exposures in this epoch 
    max_length real, --/D Maximum allowed length of epoch, i.e. time between first and last exposure 
    obsmode_pk text --/D Reference to the observing parameters (airmass, moon seperation, etc.) 
);



--
-- Name: dr19_carton; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_carton (
----------------------------------------------------------------------
--/H The table contains the list of cartons along with the target selection plan that generated them.
----------------------------------------------------------------------
    carton text, --/D The name of the carton.
    carton_pk integer NOT NULL, --/D The primary key. A sequential identifier.
    mapper_pk integer, --/D The primary key of the mapper leading this carton. See dr19_mapper.
    category_pk integer, --/D The primary key of the category in the dr19_category table.
    version_pk integer, --/D The primary key of the version in the dr19_version table.
    program text, --/D The program name.
    target_selection_plan text --/D The target selection plan version for which this carton was run.
);



--
-- Name: dr19_carton_csv; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_carton_csv (
    carton_pk integer NOT NULL,
    version_pk integer NOT NULL,
    carton text
);



--
-- Name: dr19_carton_to_target; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_carton_to_target (
----------------------------------------------------------------------
--/H The table stores the targets assigned to a given carton along with information about the instrument that will observe that target, and offseting data.
----------------------------------------------------------------------
    carton_to_target_pk bigint NOT NULL, --/D The primary key. A sequential identifier.
    lambda_eff real, --/U angstrom --/D The effective wavelength at which the object will be observed 
    carton_pk integer, --/D The primary key of the carton in the dr19_carton table.
    target_pk bigint, --/D The primary key of the target in the dr19_target table.
    cadence_pk integer, --/D The primary key of the cadence in the dr19_cadence table.
    priority integer, --/D The target priority. Used for scheduling.
    value real, --/D An internal metric of the target value used for scheduling.
    instrument_pk integer, --/D The primary key of the instrument in the dr19_instrument table.
    delta_ra double precision, --/D The RA offset for fibre positioning, in arcsec.
    delta_dec double precision, --/D The Dec offset for fibre positioning, in arcsec.
    inertial boolean --/D Whether this is an inertial target (no proper motion will be applied).
);



--
-- Name: dr19_cataclysmic_variables; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_cataclysmic_variables (
----------------------------------------------------------------------
--/H Gaia DR2 parameters for AAVSO cataclysmic variables from cataclysmic (explosive and novalike) variables (N, NA, NB, NC, NL, NR, SN, SNI, SNII, UG, UGSS, UGSU, UGZ, ZAND). VSX catalog downloaded in summer 2019 and then manually pruned.
----------------------------------------------------------------------
    ref_id bigint NOT NULL, --/D same as source_id 
    solution_id bigint, --/D ID that identifies the version of all the subsystems that were used in the generation of the data as well as the input data used 
    designation text, --/D Unique source designation across all Gaia data releases 
    source_id bigint, --/D Unique source identifier within a particular Gaia data release 
    random_index integer, --/D Random index which can be used to select smaller subsets of the data 
    ref_epoch real, --/U Julian Years --/D Time 
    ra double precision, --/U degrees --/D Right Ascension 
    ra_error double precision, --/U degrees --/D Standard error of the right ascension 
    "dec" double precision, --/U degrees --/D Declination 
    dec_error double precision, --/U degrees --/D Standard error of the declination 
    parallax double precision, --/U mas --/D Absolute stellar parallax of the source at the reference epoch 
    parallax_error double precision, --/U mas --/D Standard error of parallax 
    parallax_over_error double precision, --/D Parallax divided by its error 
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension direction 
    pmra_error double precision, --/U mas/yr --/D Standard error of proper motion in right ascension direction 
    pmdec double precision, --/U mas/yr --/D Proper motion in declination direction 
    pmdec_error double precision, --/U mas/yr --/D Standard error of proper motion in declination direction 
    ra_dec_corr double precision, --/D Correlation between right ascension and declination 
    ra_parallax_corr double precision, --/D Correlation between right ascension and parallax 
    ra_pmra_corr double precision, --/D Correlation between right ascension and proper motion in right ascension 
    ra_pmdec_corr double precision, --/D Correlation between right ascension and proper motion in declination 
    dec_parallax_corr double precision, --/D Correlation between declination and parallax 
    dec_pmra_corr double precision, --/D Correlation between declination and proper motion in right ascension 
    dec_pmdec_corr double precision, --/D Correlation between declination and proper motion in declination 
    parallax_pmra_corr double precision, --/D Correlation between parallax and proper motion in right ascension 
    parallax_pmdec_corr double precision, --/D Correlation between parallax and proper motion in declination 
    pmra_pmdec_corr double precision, --/D Correlation between proper motion in right ascension and proper motion in declination 
    astrometric_n_obs_al smallint, --/D Total number of observations AL 
    astrometric_n_obs_ac smallint, --/D Total number of observations AC 
    astrometric_n_good_obs_al smallint, --/D Number of good observations AL 
    astrometric_n_bad_obs_al smallint, --/D Number of bad observations AL 
    astrometric_gof_al double precision, --/D Goodness of fit statistic of model wrt along-scan observations 
    astrometric_chi2_al double precision, --/D AL chi-square value 
    astrometric_excess_noise double precision, --/U mas --/D Excess noise of the source 
    astrometric_excess_noise_sig double precision, --/D Significance of excess noise 
    astrometric_params_solved smallint, --/D Which parameters have been solved for 
    astrometric_primary_flag boolean, --/D Flag indicating if this source was used as a primary source (true) or secondary source (false) 
    astrometric_weight_al double precision, --/U mas^-2 --/D Mean astrometric weight of the source 
    astrometric_pseudo_colour double precision, --/U um^-1 --/D Astrometrically determined pseudocolour of the source 
    astrometric_pseudo_colour_error double precision, --/U um^-1 --/D Standard error of the pseudocolour of the source 
    mean_varpi_factor_al double precision, --/D Mean Parallax factor AL 
    astrometric_matched_observations smallint, --/D number of FOV transits matched to this source 
    visibility_periods_used smallint, --/D Number of visibility periods used in the astrometric solution 
    astrometric_sigma5d_max double precision, --/U mas --/D Longest semi-major axis of the 5-d error ellipsoid 
    frame_rotator_object_type smallint, --/D Type of the source mainly used for frame rotation 
    matched_observations smallint, --/D Total number of FOV transits matched to this source 
    duplicated_source boolean, --/D Source with duplicate sources 
    phot_g_n_obs smallint, --/D Number of observations contributing to G photometry 
    phot_g_mean_flux double precision, --/U e-/s --/D G-band mean flux 
    phot_g_mean_flux_error double precision, --/U e-/s --/D Error on G-band mean flux 
    phot_g_mean_flux_over_error double precision, --/D G-band mean flux divided by its error 
    phot_g_mean_mag double precision, --/U mag --/D G-band mean magnitude 
    phot_bp_n_obs smallint, --/D Number of observations contributing to BP photometry 
    phot_bp_mean_flux double precision, --/U e-/s --/D Integrated BP mean flux 
    phot_bp_mean_flux_error double precision, --/U e-/s --/D Error on the integrated BP mean flux 
    phot_bp_mean_flux_over_error double precision, --/D Integrated BP mean flux divided by its error 
    phot_bp_mean_mag double precision, --/U mag --/D Integrated BP mean magnitude 
    phot_rp_n_obs smallint, --/D Number of observations contributing to RP photometry 
    phot_rp_mean_flux double precision, --/U e-/s --/D Integrated RP mean flux 
    phot_rp_mean_flux_error double precision, --/U e-/s --/D Error on the integrated RP mean flux 
    phot_rp_mean_flux_over_error double precision, --/D Integrated RP mean flux divided by its error 
    phot_rp_mean_mag double precision, --/U mag --/D Integrated RP mean magnitude 
    phot_bp_rp_excess_factor double precision, --/D BP/RP excess factor 
    phot_proc_mode smallint, --/D Photometry processing mode 
    bp_rp double precision, --/U mag --/D BP - RP color 
    bp_g double precision, --/U mag --/D BP - G color 
    g_rp double precision, --/U mag --/D G - RP color 
    radial_velocity double precision, --/U km/s --/D Radial velocity 
    radial_velocity_error double precision, --/U km/s --/D Radial velocity error 
    rv_nb_transits smallint, --/D Number of transits used to compute radial velocity 
    rv_template_teff real, --/U K --/D Teff of the template used to compute radial velocity 
    rv_template_logg real, --/U log cgs --/D logg of the template used to compute radial velocity 
    rv_template_fe_h real, --/U dex --/D Fe/H of the template used to compute radial velocity 
    phot_variable_flag text, --/D Photometric variability flag 
    l double precision, --/U degrees --/D Galactic longitude 
    b double precision, --/U degrees --/D Galactic latitude 
    ecl_lon double precision, --/U degrees --/D Ecliptic longitude 
    ecl_lat double precision, --/U degrees --/D Ecliptic latitude 
    priam_flags integer, --/D Flags for the Apsis-Priam results 
    teff_val double precision, --/U K --/D Stellar effective temperature 
    teff_percentile_lower double precision, --/U K --/D Teff_val lower uncertainty 
    teff_percentile_upper double precision, --/U K --/D Teff_val upper uncertainty 
    a_g_val real, --/U mag --/D Line-of-sight extinction in the G band 
    a_g_percentile_lower real, --/U mag --/D A_g_val lower uncertainty 
    a_g_percentile_upper real, --/U mag --/D A_g_val upper uncertainty 
    e_bp_min_rp_val real, --/U mag --/D Line-of-sight reddening E(BP-RP) 
    e_bp_min_rp_percentile_lower real, --/U mag --/D e_bp_min_rp_val lower uncertainty 
    e_bp_min_rp_percentile_upper real, --/U mag --/D e_bp_min_rp_val upper uncertainty 
    flame_flags integer, --/D Flags for the Apsis-FLAME results 
    radius_val double precision, --/U Solar Radius --/D Stellar radius 
    radius_percentile_lower double precision, --/U Solar Radius --/D Radius_val lower uncertainty 
    radius_percentile_upper double precision, --/U Solar Radius --/D Radius_val upper uncertainty 
    lum_val double precision, --/U Solar Luminosity --/D stellar luminosity 
    lum_percentile_lower double precision, --/U Solar Luminosity --/D lum_val lower uncertainty 
    lum_percentile_upper double precision --/U Solar Luminosity --/D lum_val upper uncertainty 
);



--
-- Name: dr19_catalog; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog (
----------------------------------------------------------------------
--/H The table stores the results of the cross-match used for dr19 targeting. All entries in this table are expected to be unique physical objects drawn from one or more parent catalogues. The dr19_catalog_to_ tables provide the relationship between dr19_catalog objects and their parent catalogue counterparts.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The SDSS identifier for a unique object in this cross-match run.
    iauname text, --/D The IAU-style name. Not used.
    ra double precision, --/U degrees --/D The right ascension of the target in ICRS coordinates for J2015.5. Taken from the lead parent catalogue 
    "dec" double precision, --/U degrees --/D The declination of the target in ICRS coordinates for J2015.5. Taken from the lead parent catalogue 
    pmra real, --/U mas/yr --/D The proper motion of the target in right ascension. Taken from the lead parent catalogue. This is a true angle (i.e., the cos(dec) factor has been applied) 
    pmdec real, --/U mas/yr --/D The proper motion of the target in declination. Taken from the lead parent catalogue 
    parallax real, --/U arcsec --/D The parallax of the target. Taken from the lead parent catalogue 
    lead text, --/D The name of the parent catalogue from which this target was selected and whose data was used to determine its astrometric position.
    version_id integer --/D The internal version for the cross-match.
);



--
-- Name: dr19_catalog_to_allstar_dr17_synspec_rev1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_allstar_dr17_synspec_rev1 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_allstar_dr17_synspec_rev1 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id text NOT NULL, --/D The primary key identifier in the dr19_allstar_dr17_synspec_rev1 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean, --/D Whether this is considered the best match between the catalog entry and dr19_allstar_dr17_synspec_rev1.
    plan_id text --/D Identifier of the cross-matching plan used to generate this file.
);



--
-- Name: dr19_catalog_to_allwise; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_allwise (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_allwise table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_allwise table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_allwise.
);



--
-- Name: dr19_catalog_to_bhm_csc; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_bhm_csc (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_bhm_csc table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_bhm_csc table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_bhm_csc.
);



--
-- Name: dr19_catalog_to_bhm_efeds_veto; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_bhm_efeds_veto (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_bhm_efeds_veto table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_bhm_efeds_veto table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_bhm_efeds_veto.
);



--
-- Name: dr19_catalog_to_bhm_rm_v0; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_bhm_rm_v0 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_rm_v0 table.
--/T Note. This table is identical to dr19_catalog_to_bhm_rm_v0_2.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_rm_v0 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/U deg --/D The distance between the catalog and target coordinates if best=F. 
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_rm_v0.
);



--
-- Name: dr19_catalog_to_bhm_rm_v0_2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_bhm_rm_v0_2 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_rm_v0_2 table.
--/T Note. This table is identical to dr19_catalog_to_bhm_rm_v0.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_rm_v0_2 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/U deg --/D The distance between the catalog and target coordinates if best=F. 
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_rm_v0_2.
);



--
-- Name: dr19_catalog_to_catwise2020; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_catwise2020 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_catwise2020 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id character varying(25) NOT NULL, --/D The primary key identifier in the dr19_catwise2020 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_catwise2020.
);



--
-- Name: dr19_catalog_to_gaia_dr2_source; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_gaia_dr2_source (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_gaia_dr2_source table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_gaia_dr2_source table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_gaia_dr2_source.
);



--
-- Name: dr19_catalog_to_glimpse; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_glimpse (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_glimpse table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_glimpse table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_glimpse.
);



--
-- Name: dr19_catalog_to_guvcat; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_guvcat (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_guvcat table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_guvcat table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_guvcat.
);



--
-- Name: dr19_catalog_to_legacy_survey_dr8; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_legacy_survey_dr8 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_legacy_survey_dr8 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_legacy_survey_dr8 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_legacy_survey_dr8.
);



--
-- Name: dr19_catalog_to_mangatarget; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_mangatarget (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_mangatarget table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id character varying(255) NOT NULL, --/D The primary key identifier in the dr19_mangatarget table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean, --/D Whether this is considered the best match between the catalog entry and dr19_mangatarget.
    plan_id text, --/D Identifier of the cross-matching plan used to generate this file.
    added_by_phase smallint --/D The phase of the cross-match in which this target was added.
);



--
-- Name: dr19_catalog_to_marvels_dr11_star; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_marvels_dr11_star (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_marvels_dr11_star table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id character varying(255) NOT NULL, --/D The primary key identifier in the dr19_marvels_dr11_star table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean, --/D Whether this is considered the best match between the catalog entry and dr19_marvels_dr11_star.
    plan_id text, --/D Identifier of the cross-matching plan used to generate this file.
    added_by_phase smallint --/D The phase of the cross-match in which this target was added.
);



--
-- Name: dr19_catalog_to_marvels_dr12_star; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_marvels_dr12_star (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_marvels_dr12_star table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_marvels_dr12_star table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean, --/D Whether this is considered the best match between the catalog entry and dr19_marvels_dr12_star.
    plan_id text, --/D Identifier of the cross-matching plan used to generate this file.
    added_by_phase smallint --/D The phase of the cross-match in which this target was added.
);



--
-- Name: dr19_catalog_to_mastar_goodstars; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_mastar_goodstars (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_mastar_goodstars table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id character varying(255) NOT NULL, --/D The primary key identifier in the dr19_mastar_goodstars table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean, --/D Whether this is considered the best match between the catalog entry and dr19_mastar_goodstars.
    plan_id text, --/D Identifier of the cross-matching plan used to generate this file.
    added_by_phase smallint --/D The phase of the cross-match in which this target was added.
);



--
-- Name: dr19_catalog_to_panstarrs1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_panstarrs1 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_panstarrs1 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_panstarrs1 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_panstarrs1.
);



--
-- Name: dr19_catalog_to_sdss_dr13_photoobj_primary; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_sdss_dr13_photoobj_primary (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_sdss_dr13_photoobj_primary table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_sdss_dr13_photoobj_primary table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_sdss_dr13_photoobj_primary.
);



--
-- Name: dr19_catalog_to_sdss_dr16_specobj; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_sdss_dr16_specobj (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_sdss_dr16_specobj table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id numeric(20,0) NOT NULL, --/D The primary key identifier in the dr19_sdss_dr16_specobj table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_sdss_dr16_specobj.
);



--
-- Name: dr19_catalog_to_sdss_dr17_specobj; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_sdss_dr17_specobj (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_sdss_dr17_specobj table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id numeric(20,0) NOT NULL, --/D The primary key identifier in the dr19_sdss_dr17_specobj table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean, --/D Whether this is considered the best match between the catalog entry and dr19_sdss_dr17_specobj.
    plan_id text, --/D Identifier of the cross-matching plan used to generate this file.
    added_by_phase smallint --/D The phase of the cross-match in which this target was added.
);



--
-- Name: dr19_catalog_to_skies_v1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_skies_v1 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_skies_v1 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_skies_v1 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_skies_v1.
);



--
-- Name: dr19_catalog_to_skies_v2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_skies_v2 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_skies_v1 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_skies_v2 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_skies_v2.
);



--
-- Name: dr19_catalog_to_skymapper_dr2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_skymapper_dr2 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_skymapper_dr2 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_skymapper_dr2 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_skymapper_dr2.
);



--
-- Name: dr19_catalog_to_supercosmos; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_supercosmos (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_supercosmos table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_supercosmos table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_supercosmos.
);



--
-- Name: dr19_catalog_to_tic_v8; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_tic_v8 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_tic_v8 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_tic_v8 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_tic_v8.
);



--
-- Name: dr19_catalog_to_twomass_psc; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_twomass_psc (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_twomass_psc table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id integer NOT NULL, --/D The primary key identifier in the dr19_twomass_psc table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_twomass_psc.
);



--
-- Name: dr19_catalog_to_tycho2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_tycho2 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_tycho2 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id text NOT NULL, --/D The primary key identifier in the dr19_tycho2 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_tycho2.
);



--
-- Name: dr19_catalog_to_unwise; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_unwise (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_unwise table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id text NOT NULL, --/D The primary key identifier in the dr19_unwise table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_unwise.
);



--
-- Name: dr19_catalog_to_uvotssc1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_uvotssc1 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_uvotssc1 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_uvotssc1 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_uvotssc1.
);



--
-- Name: dr19_catalog_to_xmm_om_suss_4_1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalog_to_xmm_om_suss_4_1 (
----------------------------------------------------------------------
--/H The table contains the cross-match between the dr19_catalog targets and the dr19_xmm_om_suss_4_1 table.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The catalogid identifier in the dr19_catalog table.
    target_id bigint NOT NULL, --/D The primary key identifier in the dr19_xmm_om_suss_4_1 table.
    version_id smallint NOT NULL, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best boolean --/D Whether this is considered the best match between the catalog entry and dr19_xmm_om_suss_4_1.
);



--
-- Name: dr19_catalogdb_version; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catalogdb_version (
----------------------------------------------------------------------
--/H Table containing crossmatch versions
----------------------------------------------------------------------
    id integer NOT NULL, --/D Unique identifier
    plan text, --/D Cross match version
    tag text --/D Tag of target selection software used https://github.com/sdss/target_selection/tags
);



--
-- Name: dr19_category; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_category (
----------------------------------------------------------------------
--/H This table indicates the category of a carton (science, standards, etc.)
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    label text --/D The name of the category.
);



--
-- Name: dr19_catwise2020; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_catwise2020 (
----------------------------------------------------------------------
--/H The CatWISE2020 Catalog (https://ui.adsabs.harvard.edu/abs/2021ApJS..253....8M/abstract) See https://irsa.ipac.caltech.edu/data/WISE/CatWISE/gator_docs/catwise_colDescriptions.html for more detailed column descriptions
----------------------------------------------------------------------
    source_name character(21), --/D source hexagesimal designation 
    source_id character(25) NOT NULL, --/D tile name + processing code + wphot index 
    ra double precision, --/U deg --/D right ascension (J2000); (note uncorrected systematic in CatWISE2020) 
    "dec" double precision, --/U deg --/D declination (J2000); (note uncorrected systematic in CatWISE2020)
    sigra real, --/U arcsec --/D uncertainty in RA 
    sigdec real, --/U arcsec --/D uncertainty in DEC 
    sigradec real, --/U arcsec --/D cross-term of RA and Dec uncertainties 
    wx real, --/U pix --/D x pixel value 
    wy real, --/U pix --/D y pixel value 
    w1sky real, --/U 'dn' --/D frame sky background value, band 1 
    w1sigsk real, --/U 'dn' --/D frame sky background value uncertainty, band 1 
    w1conf real, --/U 'dn' --/D frame sky confusion based on the uncertainty images, band 1 
    w2sky real, --/U 'dn' --/D frame sky background value, band 2 
    w2sigsk real, --/U 'dn' --/D frame sky background value uncertainty, band 2 
    w2conf real, --/U 'dn' --/D frame sky confusion based on the uncertainty images, band 2 
    w1fitr real, --/U arcsec --/D fitting radius for W1; see note 
    w2fitr real, --/U arcsec --/D fitting radius for W2; see note 
    w1snr real, --/D instrumental profile-fit photometry S/N ratio, band 1 
    w2snr real, --/D instrumental profile-fit photometry S/N ratio, band 2 
    w1flux real, --/U 'dn' --/D profile-fit photometry raw flux, band 1 
    w1sigflux real, --/U 'dn' --/D profile-fit photometry raw flux uncertainty, band 1 
    w2flux real, --/U 'db' --/D profile-fit photometry raw flux, band 2 
    w2sigflux real, --/U 'dn' --/D profile-fit photometry raw flux uncertainty, band 2 
    w1mpro real, --/U mag --/D instrumental profile-fit photometry magnitude, band 1 
    w1sigmpro real, --/U mag --/D instrumental profile-fit photometry flux uncertainty in mag units, band 1 
    w1rchi2 real, --/D instrumental profile-fit photometry reduced chi^2, band 1 
    w2mpro real, --/U mag --/D instrumental profile-fit photometry magnitude, band 2 
    w2sigmpro real, --/U mag --/D instrumental profile-fit photometry flux uncertainty in mag units, band 2 
    w2rchi2 real, --/D instrumental profile-fit photometry reduced chi^2, band 2 
    rchi2 real, --/D instrumental profile-fit photometry reduced chi squared, total 
    nb integer, --/D number of blend components used in each fit 
    na integer, --/D number of actively deblended components 
    w1sat real, --/D fraction of pixels affected by saturation, band 1 
    w2sat real, --/D fraction of pixels affected by saturation, band 2 
    w1mag real, --/U mag --/D instrumental standard aperture (8.25") mag w/ aperture correction applied, band 1 
    w1sigm real, --/U mag --/D instrumental standard aperture mag uncertainty, band 1 
    w1flg integer, --/D instrumental standard aperture flag, band 1 
    w1cov real, --/D mean coverage depth, band 1 
    w2mag real, --/U mag --/D instrumental standard aperture (8.25") mag w/ aperture correction applied, band 2 
    w2sigm real, --/U mag --/D instrumental standard aperture mag uncertainty, band 2 
    w2flg integer, --/D instrumental standard aperture flag, band 2 
    w2cov real, --/D mean coverage depth, band 2 
    w1mag_1 real, --/U mag --/D aperture 1 (5.50") instrumental aperture mag, band 1 
    w1sigm_1 real, --/U mag --/D aperture 1 instrumental aperture mag uncertainty, band 1 
    w1flg_1 integer, --/D aperture 1 instrumental aperture flag, band 1 
    w2mag_1 real, --/U mag --/D aperture 1 (5.50") instrumental aperture mag, band 2 
    w2sigm_1 real, --/U mag --/D aperture 1 instrumental aperture mag uncertainty, band 2 
    w2flg_1 integer, --/D aperture 1 instrumental aperture flag, band 2 
    w1mag_2 real, --/U mag --/D aperture 2 (8.25") instrumental aperture mag, band 1 
    w1sigm_2 real, --/U mag --/D aperture 2 instrumental aperture mag uncertainty, band 1 
    w1flg_2 integer, --/D aperture 2 instrumental aperture flag, band 1 
    w2mag_2 real, --/U mag --/D aperture 2 (8.25") instrumental aperture mag, band 2 
    w2sigm_2 real, --/U mag --/D aperture 2 instrumental aperture mag uncertainty, band 2 
    w2flg_2 integer, --/D aperture 2 instrumental aperture flag, band 2 
    w1mag_3 real, --/U mag --/D aperture 3 (11.00") instrumental aperture mag, band 1 
    w1sigm_3 real, --/U mag --/D aperture 3 instrumental aperture mag uncertainty, band 1 
    w1flg_3 integer, --/D aperture 3 instrumental aperture flag, band 1 
    w2mag_3 real, --/U mag --/D aperture 3 (11.00") instrumental aperture mag, band 2 
    w2sigm_3 real, --/U mag --/D aperture 3 instrumental aperture mag uncertainty, band 2 
    w2flg_3 integer, --/D aperture 3 instrumental aperture flag, band 2 
    w1mag_4 real, --/U mag --/D aperture 4 (13.75") instrumental aperture mag, band 1 
    w1sigm_4 real, --/U mag --/D aperture 4 instrumental aperture mag uncertainty, band 1 
    w1flg_4 integer, --/D aperture 4 instrumental aperture flag, band 1 
    w2mag_4 real, --/U mag --/D aperture 4 (13.75") instrumental aperture mag, band 2 
    w2sigm_4 real, --/U mag --/D aperture 4 instrumental aperture mag uncertainty, band 2 
    w2flg_4 integer, --/D aperture 4 instrumental aperture flag, band 2 
    w1mag_5 real, --/U mag --/D aperture 5 (16.50") instrumental aperture mag, band 1 
    w1sigm_5 real, --/U mag --/D aperture 5 instrumental aperture mag uncertainty, band 1 
    w1flg_5 integer, --/D aperture 5 instrumental aperture flag, band 1 
    w2mag_5 real, --/U mag --/D aperture 5 (16.50") instrumental aperture mag, band 2 
    w2sigm_5 real, --/U mag --/D aperture 5 instrumental aperture mag uncertainty, band 2 
    w2flg_5 integer, --/D aperture 5 instrumental aperture flag, band 2 
    w1mag_6 real, --/U mag --/D aperture 6 (19.25") instrumental aperture mag, band 1 
    w1sigm_6 real, --/U mag --/D aperture 6 instrumental aperture mag uncertainty, band 1 
    w1flg_6 integer, --/D aperture 6 instrumental aperture flag, band 1 
    w2mag_6 real, --/U mag --/D aperture 6 (19.25") instrumental aperture mag, band 2 
    w2sigm_6 real, --/U mag --/D aperture 6 instrumental aperture mag uncertainty, band 2 
    w2flg_6 integer, --/D aperture 6 instrumental aperture flag, band 2 
    w1mag_7 real, --/U mag --/D aperture 7 (22.00") instrumental aperture mag, band 1 
    w1sigm_7 real, --/U mag --/D aperture 7 instrumental aperture mag uncertainty, band 1 
    w1flg_7 integer, --/D aperture 7 instrumental aperture flag, band 1 
    w2mag_7 real, --/U mag --/D aperture 7 (22.00") instrumental aperture mag, band 2 
    w2sigm_7 real, --/U mag --/D aperture 7 instrumental aperture mag uncertainty, band 2 
    w2flg_7 integer, --/D aperture 7 instrumental aperture flag, band 2 
    w1mag_8 real, --/U mag --/D aperture 8 (24.75") instrumental aperture mag, band 1 
    w1sigm_8 real, --/U mag --/D aperture 8 instrumental aperture mag uncertainty, band 1 
    w1flg_8 integer, --/D aperture 8 instrumental aperture flag, band 1 
    w2mag_8 real, --/U mag --/D aperture 8 (24.75") instrumental aperture mag, band 2 
    w2sigm_8 real, --/U mag --/D aperture 8 instrumental aperture mag uncertainty, band 2 
    w2flg_8 integer, --/D aperture 8 instrumental aperture flag, band 2 
    w1nm integer, --/D number of profile-fit flux measurements for source with SNR >= 3, band 1 
    w1m integer, --/D number of profile-fit flux measurements for source, band 1 
    w1magp real, --/U mag --/D profile-fit repeatability mag -- inverse-variance weighted mean mag, band 1 
    w1sigp1 real, --/U mag --/D standard deviation of population of profile-fit repeatability mag, band 1 
    w1sigp2 real, --/U mag --/D standard deviation of the mean of profile-fit repeatability mag, band 1 
    w1k real, --/D Stetson K variability index, band 1 
    w1ndf integer, --/D number degrees of freedom in variability chi^2, band 1 
    w1mlq real, --/D -ln(Q), where Q = 1 - P(chi^2), band 1 
    w1mjdmin double precision, --/U d --/D minimum modified Julian Date of frame extractions, band 1 
    w1mjdmax double precision, --/U d --/D maximum modified Julian Date of frame extractions, band 1 
    w1mjdmean double precision, --/U d --/D mean modified Julian Date of frame extractions, band 1 
    w2nm integer, --/D number of profile-fit flux measurements for source with SNR >= 3, band 2 
    w2m integer, --/D number of profile-fit flux measurements for source, band 2 
    w2magp real, --/U mag --/D profile-fit repeatability mag -- inverse-variance weighted mean mag, band 2 
    w2sigp1 real, --/U mag --/D standard deviation of population of profile-fit repeatability mag, band 2 
    w2sigp2 real, --/U mag --/D standard deviation of the mean of profile-fit repeatability mag, band 2 
    w2k real, --/D Stetson K variability index, band 2 
    w2ndf integer, --/D number degrees of freedom in variability chi^2, band 2 
    w2mlq real, --/D -ln(Q), where Q = 1 - P(chi^2), band 2 
    w2mjdmin double precision, --/U d --/D minimum modified Julian Date of frame extractions, band 2 
    w2mjdmax double precision, --/U d --/D maximum modified Julian Date of frame extractions, band 2 
    w2mjdmean double precision, --/U d --/D mean modified Julian Date of frame extractions, band 2 
    rho12 integer, --/U % --/D band 1 - band 2 correlation coefficient 
    q12 integer, --/U % --/D -log10(1 - P(rho12)), given no real correlation 
    niters integer, --/D number of chi-square minimization iterations 
    nsteps integer, --/D number of steps in all iterations
    mdetid integer, --/D source ID in mdet list 
    p1 real, --/U arcsec --/D distance in ra from the mdet position to the wphot template-fit position 
    p2 real, --/U arcsec --/D distance in dec from the mdet position to the wphot template-fit position 
    meanobsmjd double precision, --/U d --/D mean observation epoch 
    ra_pm double precision, --/U deg --/D Right ascension from psf model incl. motion at epoch MJD=56700.0 (2014.118) for Preliminary Catalog and MJD=57170 (2015.405) for CatWISE2020 
    dec_pm double precision, --/U deg --/D Declination from psf model incl. motion at epoch MJD=56700.0 (2014.118) for Preliminary Catalog and MJD=57170 (2015.405) for CatWISE2020 
    sigra_pm real, --/U arcsec --/D One-sigma uncertainty in RA from psf model incl. motion 
    sigdec_pm real, --/U arcsec --/D One-sigma uncertainty in DEC from psf model incl. motion 
    sigradec_pm real, --/U arcsec --/D The co-sigma of the equatorial position uncertainties from psf model incl motion 
    pmra real, --/U arcsec/yr --/D Apparent motion in RA; (note uncorrected systematic in CatWISE2020) 
    pmdec real, --/U arcsec/yr --/D Apparent motion in DEC; (note uncorrected systematic in CatWISE2020) 
    sigpmra real, --/U arcsec/yr --/D Uncertainty in the RA motion estimate 
    sigpmdec real, --/U arcsec/yr --/D Uncertainty in the Dec motion estimate 
    w1snr_pm real, --/D S/N ratio of the W1 profile-fit photometry including motion 
    w2snr_pm real, --/D S/N ratio of the W2 profile-fit photometry including motion 
    w1flux_pm real, --/U 'dn' --/D Raw flux W1 profile-fit photometry including motion 
    w1sigflux_pm real, --/U 'dn' --/D Raw flux uncertainty W1 profile-fit photometry including motion 
    w2flux_pm real, --/U 'dn' --/D Raw flux W2 profile-fit photometry including motion 
    w2sigflux_pm real, --/U 'dn' --/D Raw flux uncertainty W2 profile-fit photometry including motion 
    w1mpro_pm real, --/U nag --/D W1 magnitude from profile-fit photometry including motion 
    w1sigmpro_pm real, --/U mag --/D W1 flux uncertainty in mag units from profile-fit photometry including motion 
    w1rchi2_pm real, --/D Reduced chi^2 of the W1 profile-fit photometry measurement including motion est 
    w2mpro_pm real, --/U mag --/D W2 magnitude from profile-fit photometry including motion 
    w2sigmpro_pm real, --/U mag --/D W2 flux uncertainty in mag units from profile-fit photometry including motion 
    w2rchi2_pm real, --/D Reduced chi^2 of the W2 profile-fit photometry measurement including motion est 
    rchi2_pm real, --/D Combined Reduced chi^2 in all bands for the psf photometry includes src motion 
    pmcode character(7), --/D Motion estimate quality code: the format is ABCCC, where A is the number of components in the passive blend group (including the primary) before any are removed or added, B is "Y" or "N" to indicate "Yes" or "No" that a secondary blend component replaced the primary, and CCC is the distance in hundredths of an arcsec between the PM position solution for the mean observation epoch and the stationary solution 
    niters_pm integer, --/D number of chi-square minimization iterations 
    nsteps_pm integer, --/D number of steps in all iterations 
    dist real, --/U arcsec --/D radial distance between source positions in ascending and descending scans 
    dw1mag real, --/U mag --/D difference in w1mpro between ascending and descending scans 
    rch2w1 real, --/D chi-square for dw1mag (1 degree of freedom) 
    dw2mag real, --/U mag --/D difference in w2mpro between ascending and descending scans 
    rch2w2 real, --/D chi-square for dw2mag (1 degree of freedom) 
    elon_avg double precision, --/U deg --/D average ecliptic longitude 
    elonsig real, --/U arcsec --/D uncertainty in elon_avg 
    elat_avg double precision, --/U deg --/D average ecliptic latitude 
    elatsig real, --/U arcsec --/D uncertainty in elat_avg 
    delon real, --/U arcsec --/D descending scan - ascending scan ecliptic longitude difference (notes) 
    delonsig real, --/U arcsec --/D one-sigma uncertainty in Delon 
    delat real, --/U arcsec --/D descending scan - ascending scan ecliptic longitude difference 
    delatsig real, --/U arcsec --/D one-sigma uncertainty in Delat 
    delonsnr real, --/D abs(Delon)/DelonSig 
    delatsnr real, --/D abs(Delat)/DelatSig 
    chi2pmra real, --/D chi-square for PMRA difference (1 degree of freedom) 
    chi2pmdec real, --/D chi-square for PMDec difference (1 degree of freedom) 
    ka integer, --/D astrometry usage code: 0 neither the ascending nor the descending scan provided a solution; 1 only the ascending scan provided a solution; 2 only the descending scan provided a solutio; 3 both scans provided solutions which were combined in the relevant way 
    k1 integer, --/D W1 photometry usage code: 0 neither the ascending nor the descending scan provided a solution; 1 only the ascending scan provided a solution; 2 only the descending scan provided a solutio; 3 both scans provided solutions which were combined in the relevant way 
    k2 integer, --/D W2 photometry usage code: 0 neither the ascending nor the descending scan provided a solution; 1 only the ascending scan provided a solution; 2 only the descending scan provided a solutio; 3 both scans provided solutions which were combined in the relevant way 
    km integer, --/D proper motion usage code: 0 neither the ascending nor the descending scan provided a solution; 1 only the ascending scan provided a solution; 2 only the descending scan provided a solutio; 3 both scans provided solutions which were combined in the relevant way 
    par_pm real, --/U arcsec --/D parallax from PM desc-asce elon (notes) 
    par_pmsig real, --/U arcsec --/D one-sigma uncertainty in par_pm 
    par_stat real, --/U arcsec --/D parallax estimate from stationary solution (notes) 
    par_sigma real, --/U arcsec --/D one-sigma uncertainty in par_stat 
    dist_x real, --/U arcsec --/D distance between CatWISE and AllWISE source 
    cc_flags character(16), --/D worst case 4 character cc_flag from AllWISE (See Table A1 in Eisenhardt et al. (2020)) 
    w1cc_map integer, --/D worst case w1cc_map from AllWISE (See Table A1 in Eisenhardt et al. (2020)) 
    w1cc_map_str character(20), --/D worst case w1cc_map_str from AllWISE (See Table A1 in Eisenhardt et al. (2020)) 
    w2cc_map integer, --/D worst case w2cc_map from AllWISE (See Table A1 in Eisenhardt et al. (2020)) 
    w2cc_map_str character(20), --/D worst case w2cc_map_str from AllWISE (See Table A1 in Eisenhardt et al. (2020)) 
    n_aw integer, --/D number of sources within 2.75" in AllWISE 
    ab_flags character(9), --/D unWISE artifact bitmask contamination flags 
    w1ab_map integer, --/D unWISE artifact bitmask contamination map for W1 
    w1ab_map_str character(13), --/D unWISE artifact bitmask contamination string for W1 
    w2ab_map integer, --/D unWISE artifact bitmask contamination map for W2 
    w2ab_map_str character(13), --/D unWISE artifact bitmask contamination string for W1 
    glon double precision, --/U deg --/D Galactic longitude (only present in CatWISE 2020) 
    glat double precision, --/U deg --/D Galactic latitude (only present in CatWISE 2020) 
    elon double precision, --/U deg --/D Ecliptic longitude 
    elat double precision, --/U deg --/D Ecliptic latitude 
    unwise_objid character(20) --/D UnWISE Object ID (only present in CatWISE 2020) 
);



--
-- Name: dr19_design; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_design (
----------------------------------------------------------------------
--/H This table stores the meta-data for the design, including its Design Mode and versioning information.
----------------------------------------------------------------------
    design_id integer NOT NULL, --/D The primary key. A sequential identifier.
    design_mode_label text, --/D The primary key of the design_mode in the dr19_design_mode table.
    mugatu_version text, --/D Software version of mugatu used to validate and ingest design.
    run_on date, --/D Date that design was added to database.
    assignment_hash uuid, --/D Hash of the assignments in the design.
    design_version_pk integer --/D The primary key of the version in the dr19_version table.
);



--
-- Name: dr19_design_mode; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_design_mode (
----------------------------------------------------------------------
--/H The parameters for the metrics that descirbe a given Design Mode, where a Design Mode constrains the assignments on a design.
----------------------------------------------------------------------
    label text NOT NULL, --/D The primary key. A string label.
    boss_skies_min integer, --/D Minimum number of Boss skies needed for design.
    apogee_skies_min integer, --/D Minimum number of Apogee skies needed for design.
    boss_stds_min integer, --/D Minimum number of Boss standards needed for design.
    apogee_stds_min integer, --/D Minimum number of Apogee standards needed for design.
    boss_trace_diff_targets double precision, --/D Limit for magnitude difference between adjacent traces on Boss instrument.
    apogee_trace_diff_targets double precision, --/D Limit for magnitude difference between adjacent traces on Apogee instrument.
    boss_skies_fov_k double precision, --/D The kth neighbor to measure distance to for the Field of View metric for Boss skies.
    boss_skies_fov_perc double precision, --/D The percentile of the distances for the Field of View metric for Boss skies.
    boss_skies_fov_perc_dist double precision, --/D The maximum percentile distance for the Field of View metric for Boss skies.
    apogee_skies_fov_k double precision, --/D The kth neighbor to measure distance to for the Field of View metric for Apogee skies.
    apogee_skies_fov_perc double precision, --/D The percentile of the distances for the Field of View metric for Apogee skies.
    apogee_skies_fov_perc_dist double precision, --/D The maximum percentile distance for the Field of View metric for Apogee skies.
    boss_stds_fov_k double precision, --/D The kth neighbor to measure distance to for the Field of View metric for Boss standards.
    boss_stds_fov_perc double precision, --/D The percentile of the distances for the Field of View metric for Boss standards.
    boss_stds_fov_perc_dist double precision, --/D The maximum percentile distance for the Field of View metric for Boss standards.
    apogee_stds_fov_k double precision, --/D The kth neighbor to measure distance to for the Field of View metric for Apogee standards.
    apogee_stds_fov_perc double precision, --/D The percentile of the distances for the Field of View metric for Apogee standards.
    apogee_stds_fov_perc_dist double precision, --/D The maximum percentile distance for the Field of View metric for Apogee standards.
    boss_stds_mags_min_g double precision, --/D The minimum optical g magnitude for Boss standards.
    boss_stds_mags_min_r double precision, --/D The minimum optical r magnitude for Boss standards.
    boss_stds_mags_min_i double precision, --/D The minimum optical i magnitude for Boss standards.
    boss_stds_mags_min_z double precision, --/D The minimum optical z magnitude for Boss standards.
    boss_stds_mags_min_bp double precision, --/D The minimum Gaia BP magnitude for Boss standards.
    boss_stds_mags_min_gaia_g double precision, --/D The minimum Gaia G magnitude for Boss standards.
    boss_stds_mags_min_rp double precision, --/D The minimum Gaia RP magnitude for Boss standards.
    boss_stds_mags_min_j double precision, --/D The minimum IR J magnitude for Boss standards.
    boss_stds_mags_min_h double precision, --/D The minimum IR H magnitude for Boss standards.
    boss_stds_mags_min_k double precision, --/D The minimum IR K magnitude for Boss standards.
    boss_stds_mags_max_g double precision, --/D The maximum optical g magnitude for Boss standards.
    boss_stds_mags_max_r double precision, --/D The maximum optical r magnitude for Boss standards.
    boss_stds_mags_max_i double precision, --/D The maximum optical i magnitude for Boss standards.
    boss_stds_mags_max_z double precision, --/D The maximum optical z magnitude for Boss standards.
    boss_stds_mags_max_bp double precision, --/D The maximum Gaia BP magnitude for Boss standards.
    boss_stds_mags_max_gaia_g double precision, --/D The maximum Gaia G magnitude for Boss standards.
    boss_stds_mags_max_rp double precision, --/D The maximum Gaia RP magnitude for Boss standards.
    boss_stds_mags_max_j double precision, --/D The maximum IR J magnitude for Boss standards.
    boss_stds_mags_max_h double precision, --/D The maximum IR H magnitude for Boss standards.
    boss_stds_mags_max_k double precision, --/D The maximum IR K magnitude for Boss standards.
    apogee_stds_mags_min_g double precision, --/D The minimum optical g magnitude for Apogee standards.
    apogee_stds_mags_min_r double precision, --/D The minimum optical r magnitude for Apogee standards.
    apogee_stds_mags_min_i double precision, --/D The minimum optical i magnitude for Apogee standards.
    apogee_stds_mags_min_z double precision, --/D The minimum optical z magnitude for Apogee standards.
    apogee_stds_mags_min_bp double precision, --/D The minimum Gaia BP magnitude for Apogee standards.
    apogee_stds_mags_min_gaia_g double precision, --/D The minimum Gaia G magnitude for Apogee standards.
    apogee_stds_mags_min_rp double precision, --/D The minimum Gaia RP magnitude for Apogee standards.
    apogee_stds_mags_min_j double precision, --/D The minimum IR J magnitude for Apogee standards.
    apogee_stds_mags_min_h double precision, --/D The minimum IR H magnitude for Apogee standards.
    apogee_stds_mags_min_k double precision, --/D The minimum IR K magnitude for Apogee standards.
    apogee_stds_mags_max_g double precision, --/D The maximum optical g magnitude for Apogee standards.
    apogee_stds_mags_max_r double precision, --/D The maximum optical r magnitude for Apogee standards.
    apogee_stds_mags_max_i double precision, --/D The maximum optical i magnitude for Apogee standards.
    apogee_stds_mags_max_z double precision, --/D The maximum optical z magnitude for Apogee standards.
    apogee_stds_mags_max_bp double precision, --/D The maximum Gaia BP magnitude for Apogee standards.
    apogee_stds_mags_max_gaia_g double precision, --/D The maximum Gaia G magnitude for Apogee standards.
    apogee_stds_mags_max_rp double precision, --/D The maximum Gaia RP magnitude for Apogee standards.
    apogee_stds_mags_max_j double precision, --/D The maximum IR J magnitude for Apogee standards.
    apogee_stds_mags_max_h double precision, --/D The maximum IR H magnitude for Apogee standards.
    apogee_stds_mags_max_k double precision, --/D The maximum IR K magnitude for Apogee standards.
    boss_bright_limit_targets_min_g double precision, --/D The minimum optical g magnitude for Boss science targets.
    boss_bright_limit_targets_min_r double precision, --/D The minimum optical r magnitude for Boss science targets.
    boss_bright_limit_targets_min_i double precision, --/D The minimum optical i magnitude for Boss science targets.
    boss_bright_limit_targets_min_z double precision, --/D The minimum optical z magnitude for Boss science targets.
    boss_bright_limit_targets_min_bp double precision, --/D The minimum Gaia BP magnitude for Boss science targets.
    boss_bright_limit_targets_min_gaia_g double precision, --/D The minimum Gaia G magnitude for Boss science targets.
    boss_bright_limit_targets_min_rp double precision, --/D The minimum Gaia RP magnitude for Boss science targets.
    boss_bright_limit_targets_min_j double precision, --/D The minimum IR J magnitude for Boss science targets.
    boss_bright_limit_targets_min_h double precision, --/D The minimum IR H magnitude for Boss science targets.
    boss_bright_limit_targets_min_k double precision, --/D The minimum IR K magnitude for Boss science targets.
    boss_bright_limit_targets_max_g double precision, --/D The maximum optical g magnitude for Boss science targets.
    boss_bright_limit_targets_max_r double precision, --/D The maximum optical r magnitude for Boss science targets.
    boss_bright_limit_targets_max_i double precision, --/D The maximum optical i magnitude for Boss science targets.
    boss_bright_limit_targets_max_z double precision, --/D The maximum optical z magnitude for Boss science targets.
    boss_bright_limit_targets_max_bp double precision, --/D The maximum Gaia BP magnitude for Boss science targets.
    boss_bright_limit_targets_max_gaia_g double precision, --/D The maximum Gaia G magnitude for Boss science targets.
    boss_bright_limit_targets_max_rp double precision, --/D The maximum Gaia RP magnitude for Boss science targets.
    boss_bright_limit_targets_max_j double precision, --/D The maximum IR J magnitude for Boss science targets.
    boss_bright_limit_targets_max_h double precision, --/D The maximum IR H magnitude for Boss science targets.
    boss_bright_limit_targets_max_k double precision, --/D The maximum IR K magnitude for Boss science targets.
    apogee_bright_limit_targets_min_g double precision, --/D The minimum optical g magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_r double precision, --/D The minimum optical r magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_i double precision, --/D The minimum optical i magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_z double precision, --/D The minimum optical z magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_bp double precision, --/D The minimum Gaia BP magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_gaia_g double precision, --/D The minimum Gaia G magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_rp double precision, --/D The minimum Gaia RP magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_j double precision, --/D The minimum IR J magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_h double precision, --/D The minimum IR H magnitude for Apogee science targets.
    apogee_bright_limit_targets_min_k double precision, --/D The minimum IR K magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_g double precision, --/D The maximum optical g magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_r double precision, --/D The maximum optical r magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_i double precision, --/D The maximum optical i magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_z double precision, --/D The maximum optical z magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_bp double precision, --/D The maximum Gaia BP magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_gaia_g double precision, --/D The maximum Gaia G magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_rp double precision, --/D The maximum Gaia RP magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_j double precision, --/D The maximum IR J magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_h double precision, --/D The maximum IR H magnitude for Apogee science targets.
    apogee_bright_limit_targets_max_k double precision --/D The maximum IR K magnitude for Apogee science targets.
);



--
-- Name: dr19_design_mode_check_results; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_design_mode_check_results (
----------------------------------------------------------------------
--/H Summary if design passed individual Design Mode checks from dr19_design_mode.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    design_id integer, --/D The primary key of the design in the dr19_design table.
    design_pass boolean, --/D If minimum design checks were passed.
    design_status integer, --/D Bitmask for design. 1 if revalidated design. 2 if replacement design.
    boss_skies_min_pass boolean, --/D If passed minimum Boss skies metric.
    boss_skies_min_value integer, --/D How many Boss skies in the design.
    boss_skies_fov_pass boolean, --/D If passed Boss skies Field of View metric.
    boss_skies_fov_value double precision, --/D Boss skies Field of View metric value.
    apogee_skies_min_pass boolean, --/D If passed minimum Apogee skies metric.
    apogee_skies_min_value integer, --/D How many Apogee skies in the design.
    apogee_skies_fov_pass boolean, --/D If passed Apogee skies Field of View metric.
    apogee_skies_fov_value double precision, --/D Apogee skies Field of View metric value.
    boss_stds_min_pass boolean, --/D If passed minimum Boss standards metric.
    boss_stds_min_value integer, --/D How many Boss standards in the design.
    boss_stds_fov_pass boolean, --/D If passed Boss standards Field of View metric.
    boss_stds_fov_value double precision, --/D Boss standards Field of View metric value.
    apogee_stds_min_pass boolean, --/D If passed minimum Apogee standards metric.
    apogee_stds_min_value integer, --/D How many Apogee standards in the design.
    apogee_stds_fov_pass boolean, --/D If passed Apogee standards Field of View metric.
    apogee_stds_fov_value double precision, --/D Apogee standards Field of View metric value.
    boss_stds_mags_pass boolean, --/D If all Boss standards within magnitude limits.
    apogee_stds_mags_pass boolean, --/D If all Apogee standards within magnitude limits.
    boss_bright_limit_targets_pass boolean, --/D If all Boss science targets within magnitude limits.
    apogee_bright_limit_targets_pass boolean, --/D If all Apogee science targets within magnitude limits.
    boss_sky_neighbors_targets_pass boolean, --/D If all Boss assignments pass bright neighobor check.
    apogee_sky_neighbors_targets_pass boolean, --/D If all Apogee assignments pass bright neighobor check.
    apogee_trace_diff_targets_pass boolean --/D If all Apogee assignments pass magnitude difference between adjacent traces check.
);



--
-- Name: dr19_design_to_field; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_design_to_field (
----------------------------------------------------------------------
--/H Connects a design to a given field within a version of the survey. Sets the placement of the design in the overall exposure sequence for that field.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    design_id integer, --/D The primary key of the design in the dr19_design table.
    field_pk integer, --/D The primary key of the field in the dr19_field table.
    exposure bigint, --/D The 0-indexed exposure number in the lunation sequence for the field.
    field_exposure bigint --/D The 0-indexed overall exposure number in the sequence for the field.
);



--
-- Name: dr19_ebosstarget_v5; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_ebosstarget_v5 (
----------------------------------------------------------------------
--/H A catalog of targets, selected from SDSS+WISE imaging that were considered for observation in the
--/T  SDSS-IV/eBOSS project, including spectrophotometric starts and candidate QSOs. <br>
--/T  This catalogue is a data product of the ebosstarget target selection software,
--/T version "v5_0".
----------------------------------------------------------------------
    run integer, --/D SDSS imaging run 
    camcol integer, --/D SDSS imaging camcol 
    field integer, --/D SDSS imaging field 
    id integer, --/D SDSS imaging object id 
    rerun text, --/D SDSS imaging rerun 
    fibermag_u real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, u-band 
    fibermag_g real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, g-band 
    fibermag_r real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, r-band 
    fibermag_i real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, i-band 
    fibermag_z real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, z-band 
    fiber2mag_u real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, u-band 
    fiber2mag_g real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, g-band 
    fiber2mag_r real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, r-band 
    fiber2mag_i real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, i-band 
    fiber2mag_z real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, z-band 
    calib_status_u integer, --/D Calibration status in u-band 
    calib_status_g integer, --/D Calibration status in g-band 
    calib_status_r integer, --/D Calibration status in r-band 
    calib_status_i integer, --/D Calibration status in i-band 
    calib_status_z integer, --/D Calibration status in z-band 
    ra double precision, --/U deg --/D J2000 Right Ascension 
    "dec" double precision, --/U deg --/D J2000 Declination 
    epoch real, --/U year --/D Epoch of position 
    pmra real, --/U mas/yr --/D proper motion in RA direction 
    pmdec real, --/U mas/yr --/D - proper motion in Dec direction 
    eboss_target1 bigint, --/D eBOSS target selection information, for eBOSS plates 
    eboss_target2 bigint, --/D eBOSS target selection information, for TDSS, SPIDERS, ELG, etc. plates 
    eboss_target_id bigint, --/D eBOSS unique target identifier for every spectroscopic target 
    thing_id_targeting integer, --/D thing_id value from the version of resolve from which the targeting was created 
    objc_type integer, --/D Type classification of the object (star, galaxy, cosmic ray, etc.) 
    objc_flags integer, --/D Photo Object Attribute Flags(?) 
    objc_flags2 integer, --/D Additional Photo Object Attribute Flags(?) 
    flags integer, --/D Target selection flags set by ebosstarget (?) 
    flags2 integer, --/D Additional target selection flags set by ebosstarget (?) 
    psf_fwhm_u real, --/U arcsec --/D Imaging FWHM in u-band 
    psf_fwhm_g real, --/U arcsec --/D Imaging FWHM in g-band 
    psf_fwhm_r real, --/U arcsec --/D Imaging FWHM in r-band 
    psf_fwhm_i real, --/U arcsec --/D Imaging FWHM in i-band 
    psf_fwhm_z real, --/U arcsec --/D Imaging FWHM in z-band 
    psfflux_u real, --/U nMgy --/D PSF flux, u-band 
    psfflux_g real, --/U nMgy --/D PSF flux, g-band 
    psfflux_r real, --/U nMgy --/D PSF flux, r-band 
    psfflux_i real, --/U nMgy --/D PSF flux, i-band 
    psfflux_z real, --/U nMgy --/D PSF flux, z-band 
    psfflux_ivar_u real, --/U nMgy^{-2} --/D PSF flux inverse variance, u-band 
    psfflux_ivar_g real, --/U nMgy^{-2} --/D PSF flux inverse variance, g-band 
    psfflux_ivar_r real, --/U nMgy^{-2} --/D PSF flux inverse variance, r-band 
    psfflux_ivar_i real, --/U nMgy^{-2} --/D PSF flux inverse variance, r-band 
    psfflux_ivar_z real, --/U nMgy^{-2} --/D PSF flux inverse variance, i-band 
    extinction_u real, --/U mag --/D Extinction in u-band 
    extinction_g real, --/U mag --/D Extinction in g-band 
    extinction_r real, --/U mag --/D Extinction in r-band 
    extinction_i real, --/U mag --/D Extinction in i-band 
    extinction_z real, --/U mag --/D Extinction in z-band 
    fiberflux_u real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, u-band 
    fiberflux_g real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, g-band 
    fiberflux_r real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, r-band 
    fiberflux_i real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, i-band 
    fiberflux_z real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, z-band 
    fiberflux_ivar_u real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, u-band 
    fiberflux_ivar_g real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, g-band 
    fiberflux_ivar_r real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, r-band 
    fiberflux_ivar_i real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, i-band 
    fiberflux_ivar_z real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, z-band 
    fiber2flux_ivar_u real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, u-band 
    fiber2flux_ivar_g real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, g-band 
    fiber2flux_ivar_r real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, r-band 
    fiber2flux_ivar_i real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, i-band 
    fiber2flux_ivar_z real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, z-band 
    modelflux_u real, --/U nMgy --/D Flux of best fitting model, u-band 
    modelflux_g real, --/U nMgy --/D Flux of best fitting model, g-band 
    modelflux_r real, --/U nMgy --/D Flux of best fitting model, r-band 
    modelflux_i real, --/U nMgy --/D Flux of best fitting model, i-band 
    modelflux_z real, --/U nMgy --/D Flux of best fitting model, z-band 
    modelflux_ivar_u real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, u-band 
    modelflux_ivar_g real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, g-band 
    modelflux_ivar_r real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, r-band 
    modelflux_ivar_i real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, i-band 
    modelflux_ivar_z real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, z-band 
    modelmag_u real, --/U nMgy --/D Magnitude of best fitting model, u-band 
    modelmag_g real, --/U nMgy --/D Magnitude of best fitting model, g-band 
    modelmag_r real, --/U nMgy --/D Magnitude of best fitting model, r-band 
    modelmag_i real, --/U nMgy --/D Magnitude of best fitting model, i-band 
    modelmag_z real, --/U nMgy --/D Magnitude of best fitting model, z-band 
    modelmag_ivar_u real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, u-band 
    modelmag_ivar_g real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, g-band 
    modelmag_ivar_r real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, r-band 
    modelmag_ivar_i real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, i-band 
    modelmag_ivar_z real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, z-band 
    resolve_status integer, --/D Resolve status of object 
    w1_mag real, --/U mag --/D WISE AllSky magnitude of the object, W1-band 
    w1_mag_err real, --/U mag --/D Error on WISE AllSky magnitude of the object, W1-band 
    w1_nanomaggies real, --/U nMgy --/D WISE AllSky flux of the object, W1-band 
    w1_nanomaggies_ivar real, --/U nMgy^{-2} --/D Inverse variance of WISE AllSky flux of the object, W1-band 
    w2_nanomaggies real, --/U nMgy --/D WISE AllSky flux of the object, W2-band 
    w2_nanomaggies_ivar real, --/U nMgy^{-2} --/D Inverse variance of WISE AllSky flux of the object, W2-band 
    has_wise_phot boolean, --/D True if WISE photometry is available for this object 
    objid_targeting bigint, --/D Object ID of target 
    pk bigint NOT NULL --/D primary key for entry in database table 
);



--
-- Name: dr19_erosita_superset_agn; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_erosita_superset_agn (
----------------------------------------------------------------------
--/H One of several tables describing optical/IR counterparts to eROSITA
--/T X-ray sources identified via various methods.  These tables contain a <br>
--/T superset of potential targets from which the SDSS-V spectroscopic <br>
--/T targets were drawn.  The dr19_erosita_superset_agn table includes <br>
--/T counterparts to point-like X-ray sources. The sample is expected to be <br>
--/T dominated by Active Galactic Nuclei (AGN) but should also include a <br>
--/T significant minority of galaxies, stars and other Galactic sources. <br>
--/T Each row corresponds to one possible match between an X-ray source and <br>
--/T a potential optical/IR counterpart.  The X-ray columns (ero_*) record <br>
--/T the eROSITA information known at the time of target selection and may <br>
--/T differ from publicly available eROSITA catalogs. The <br>
--/T dr19_erosita_superset_* tables are derived from a combination of <br>
--/T eROSITA's first 6-month survey of of the West Galactic hemisphere <br>
--/T ('eRASS1'), and from the eROSITA observations of the eROSITA Final <br>
--/T Equatorial Depth performance verification field ('eFEDS').
----------------------------------------------------------------------
    ero_version character(24), --/D Identifier giving the eROSITA dataset and processing version e.g. 'eFEDS_c940', 'em01_c946_201008_poscorr' etc
    ero_detuid character(32), --/D The standard official eROSITA unique detection identifier, e.g. 'em01_123456_020_ML12345_001_c946' etc
    ero_flux real, --/U erg/cm2/s --/D X-ray flux, usually in the main eROSITA detection band (0.2-2.3keV) 
    ero_morph character(9), --/D X-ray morphological classification ("POINTLIKE" or "EXTENDED")
    ero_det_like real, --/D X-ray detection likelihood
    ero_ra double precision, --/U deg --/D Best determination of X-ray position (J2000) 
    ero_dec double precision, --/U deg --/D Best determination of X-ray position (J2000) 
    ero_radec_err real, --/U arcsec --/D Best estimate of X-ray position uncertainty 
    xmatch_method character(24), --/D The X-ray-to-optical/IR cross-match method that was used in this case e.g. 'XPS-ML/NWAY', 'CLUSTERS_EFEDS_MULTIPLE' etc
    xmatch_version character(24), --/D The cross-match software version and OIR catalog used e.g. 'LSdr8-JWMS_v2.1LSdr8-JWMS_v2.1', 'LSdr8-AG_v1,JC_16032020', 'eromapper_2020-10-12', 'CW20ps1dr2-v011220' etc
    xmatch_dist real, --/U arcsec --/D Distance between X-ray position and optical counterpart 
    xmatch_metric real, --/D Metric giving quality of cross-match. Meaning is dependent on xmatch_method, e.g. p_any for NWAY
    xmatch_flags bigint, --/D Flags indicating cross-match properties (e.g. status flags), xmatch_method dependent
    target_class character(12), --/D Best guess of source classification at time of xmatch e.g. 'GALAXY','STAR','QSO','UNKNOWN',....
    target_priority integer, --/D Relative to other targets in this catalog, interpreted/adapted later to derive a final target priority
    target_has_spec bigint, --/D Flags used to indicate if target has good quality archival spectroscopy available
    opt_cat character(12), --/D Describes which OIR survey provided the optical counterpart for this row of the table, i.e. which OIR cat gives the entries in fields opt_ra, opt_dec, opt_pmra, opt_pmdec, opt_epoch, and which OIR identifier is given in the *_id columns
    ls_id bigint, --/D Identifier of counterpart (if any) in dr19_legacy_survey_dr8 ('ls_id' field). Arithmetically derived from legacysurvey sweep file columns: release, brickid and objid:  ls_id = objid + (brickid * 2**16) + (release * 2**40)
    ps1_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_panstarrs1 (catid_objid field). Identical to MAST 'ippObjID' identifier
    gaia_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_gaia_dr2_source ('source_id' field)
    catwise2020_id character(25), --/D Identifier of counterpart (if any) in dr19_catwise2020 ('source_id' field)
    skymapper_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_skymapper_dr2 ('object_id' field)
    supercosmos_id bigint, --/D Identifier of counterpart (if any) in dr19_supercosmos ('objid' field)
    tycho2_id character(12), --/D Identifier of counterpart (if any) in dr19_tycho2 ('designation' field)
    sdss_dr13_id bigint, --/D Identifier of counterpart (if any) in dr19_sdss_dr13_photoobj ('objid' field)
    opt_ra double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_dec double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_pmra real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_pmdec real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_epoch real, --/U decimal year --/D Epoch of opt_ra,opt_dec 
    pkey bigint NOT NULL --/D primary key of table entry
);



--
-- Name: dr19_erosita_superset_clusters; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_erosita_superset_clusters (
----------------------------------------------------------------------
--/H One of several tables describing optical/IR counterparts to eROSITA
--/T X-ray sources identified via various methods.  These tables contain a <br>
--/T superset of potential targets from which the SDSS-V spectroscopic <br>
--/T targets were drawn.  The dr19_erosita_superset_clusters table includes <br>
--/T counterparts to both extended and point-like X-ray sources, selected <br>
--/T via algorithms optimised to find clusters of galaxies.  Each row <br>
--/T corresponds to one possible match between an X-ray source and a <br>
--/T potential optical/IR counterpart.  The X-ray columns (ero_*) record <br>
--/T the eROSITA information known at the time of target selection and may <br>
--/T differ from publicly available eROSITA catalogs. The <br>
--/T dr19_erosita_superset_* tables are derived from a combination of <br>
--/T eROSITA's first 6-month survey of of the West Galactic hemisphere <br>
--/T ('eRASS1'), and from the eROSITA observations of the eROSITA Final <br>
--/T Equatorial Depth performance verification field ('eFEDS').
----------------------------------------------------------------------
    ero_version character(24), --/D Identifier giving the eROSITA dataset and processing version e.g. 'eFEDS_c940', 'em01_c946_201008_poscorr' etc
    ero_detuid character(32), --/D The standard official eROSITA unique detection identifier, e.g. 'em01_123456_020_ML12345_001_c946' etc
    ero_flux real, --/U erg/cm2/s --/D X-ray flux, usually in the main eROSITA detection band (0.2-2.3keV) 
    ero_morph character(9), --/D X-ray morphological classification ("POINTLIKE" or "EXTENDED")
    ero_det_like real, --/D X-ray detection likelihood
    ero_ra double precision, --/U deg --/D Best determination of X-ray position (J2000) 
    ero_dec double precision, --/U deg --/D Best determination of X-ray position (J2000) 
    ero_radec_err real, --/U arcsec --/D Best estimate of X-ray position uncertainty 
    xmatch_method character(24), --/D The X-ray-to-optical/IR cross-match method that was used in this case e.g. 'XPS-ML/NWAY', 'CLUSTERS_EFEDS_MULTIPLE' etc
    xmatch_version character(24), --/D The cross-match software version and OIR catalog used e.g. 'LSdr8-JWMS_v2.1LSdr8-JWMS_v2.1', 'LSdr8-AG_v1,JC_16032020', 'eromapper_2020-10-12', 'CW20ps1dr2-v011220' etc
    xmatch_dist real, --/U arcsec --/D Distance between X-ray position and optical counterpart 
    xmatch_metric real, --/D Metric giving quality of cross-match. Meaning is dependent on xmatch_method, e.g. p_any for NWAY
    xmatch_flags bigint, --/D Flags indicating cross-match properties (e.g. status flags), xmatch_method dependent
    target_class character(12), --/D Best guess of source classification at time of xmatch e.g. 'GALAXY','STAR','QSO','UNKNOWN',....
    target_priority integer, --/D Relative to other targets in this catalog, interpreted/adapted later to derive a final target priority
    target_has_spec bigint, --/D Flags used to indicate if target has good quality archival spectroscopy available
    opt_cat character(12), --/D Describes which OIR survey provided the optical counterpart for this row of the table, i.e. which OIR cat gives the entries in fields opt_ra, opt_dec, opt_pmra, opt_pmdec, opt_epoch, and which OIR identifier is given in the *_id columns
    ls_id bigint, --/D Identifier of counterpart (if any) in dr19_legacy_survey_dr8 ('ls_id' field). Arithmetically derived from legacysurvey sweep file columns: release, brickid and objid:  ls_id = objid + (brickid * 2**16) + (release * 2**40)
    ps1_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_panstarrs1 (catid_objid field). Identical to MAST 'ippObjID' identifier
    gaia_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_gaia_dr2_source ('source_id' field)
    catwise2020_id character(25), --/D Identifier of counterpart (if any) in dr19_catwise2020 ('source_id' field)
    skymapper_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_skymapper_dr2 ('object_id' field)
    supercosmos_id bigint, --/D Identifier of counterpart (if any) in dr19_supercosmos ('objid' field)
    tycho2_id character(12), --/D Identifier of counterpart (if any) in dr19_tycho2 ('designation' field)
    sdss_dr13_id bigint, --/D Identifier of counterpart (if any) in dr19_sdss_dr13_photoobj ('objid' field)
    opt_ra double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_dec double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_pmra real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_pmdec real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_epoch real, --/U decimal year --/D Epoch of opt_ra,opt_dec 
    pkey bigint NOT NULL --/D primary key of table entry
);



--
-- Name: dr19_erosita_superset_compactobjects; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_erosita_superset_compactobjects (
----------------------------------------------------------------------
--/H One of several tables describing optical/IR counterparts to eROSITA
--/T X-ray sources identified via various methods.  These tables contain a <br>
--/T superset of potential targets from which the SDSS-V spectroscopic <br>
--/T targets were drawn.  The dr19_erosita_superset_agn table includes <br>
--/T counterparts to point-like X-ray sources, chosen via algorithms <br>
--/T optimised to select compact objects.  Each row corresponds to one <br>
--/T possible match between an X-ray source and a potential optical/IR <br>
--/T counterpart.  The X-ray columns (ero_*) record the eROSITA information <br>
--/T known at the time of target selection and may differ from publicly <br>
--/T available eROSITA catalogs. The dr19_erosita_superset_* tables are <br>
--/T derived from a combination of eROSITA's first 6-month survey of of the <br>
--/T West Galactic hemisphere ('eRASS1'), and from the eROSITA observations <br>
--/T of the eROSITA Final Equatorial Depth performance verification field <br>
--/T ('eFEDS').
----------------------------------------------------------------------
    ero_version character(24), --/D Identifier giving the eROSITA dataset and processing version e.g. 'eFEDS_c940', 'em01_c946_201008_poscorr' etc
    ero_detuid character(32), --/D The standard official eROSITA unique detection identifier, e.g. 'em01_123456_020_ML12345_001_c946' etc
    ero_flux real, --/U erg/cm2/s --/D X-ray flux, usually in the main eROSITA detection band (0.2-2.3keV) 
    ero_morph character(9), --/D X-ray morphological classification ("POINTLIKE" or "EXTENDED")
    ero_det_like real, --/D X-ray detection likelihood
    ero_ra double precision, --/U deg --/D Best determination of X-ray position (J2000) 
    ero_dec double precision, --/U deg --/D Best determination of X-ray position (J2000) 
    ero_radec_err real, --/U arcsec --/D Best estimate of X-ray position uncertainty 
    xmatch_method character(24), --/D The X-ray-to-optical/IR cross-match method that was used in this case e.g. 'XPS-ML/NWAY', 'CLUSTERS_EFEDS_MULTIPLE' etc
    xmatch_version character(24), --/D The cross-match software version and OIR catalog used e.g. 'LSdr8-JWMS_v2.1LSdr8-JWMS_v2.1', 'LSdr8-AG_v1,JC_16032020', 'eromapper_2020-10-12', 'CW20ps1dr2-v011220' etc
    xmatch_dist real, --/U arcsec --/D Distance between X-ray position and optical counterpart 
    xmatch_metric real, --/D Metric giving quality of cross-match. Meaning is dependent on xmatch_method, e.g. p_any for NWAY
    xmatch_flags bigint, --/D Flags indicating cross-match properties (e.g. status flags), xmatch_method dependent
    target_class character(12), --/D Best guess of source classification at time of xmatch e.g. 'GALAXY','STAR','QSO','UNKNOWN',....
    target_priority integer, --/D Relative to other targets in this catalog, interpreted/adapted later to derive a final target priority
    target_has_spec bigint, --/D Flags used to indicate if target has good quality archival spectroscopy available
    opt_cat character(12), --/D Describes which OIR survey provided the optical counterpart for this row of the table, i.e. which OIR cat gives the entries in fields opt_ra, opt_dec, opt_pmra, opt_pmdec, opt_epoch, and which OIR identifier is given in the *_id columns
    ls_id bigint, --/D Identifier of counterpart (if any) in dr19_legacy_survey_dr8 ('ls_id' field). Arithmetically derived from legacysurvey sweep file columns: release, brickid and objid:  ls_id = objid + (brickid * 2**16) + (release * 2**40)
    ps1_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_panstarrs1 (catid_objid field). Identical to MAST 'ippObjID' identifier
    gaia_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_gaia_dr2_source ('source_id' field)
    catwise2020_id character(25), --/D Identifier of counterpart (if any) in dr19_catwise2020 ('source_id' field)
    skymapper_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_skymapper_dr2 ('object_id' field)
    supercosmos_id bigint, --/D Identifier of counterpart (if any) in dr19_supercosmos ('objid' field)
    tycho2_id character(12), --/D Identifier of counterpart (if any) in dr19_tycho2 ('designation' field)
    sdss_dr13_id bigint, --/D Identifier of counterpart (if any) in dr19_sdss_dr13_photoobj ('objid' field)
    opt_ra double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_dec double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_pmra real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_pmdec real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_epoch real, --/U decimal year --/D Epoch of opt_ra,opt_dec 
    pkey bigint NOT NULL --/D primary key of table entry
);



--
-- Name: dr19_erosita_superset_stars; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_erosita_superset_stars (
----------------------------------------------------------------------
--/H One of several tables describing optical/IR counterparts to eROSITA
--/T X-ray sources identified via various methods.  These tables contain a <br>
--/T superset of potential targets from which the SDSS-V spectroscopic <br>
--/T targets were drawn.  The dr19_erosita_superset_stars table includes <br>
--/T counterparts to point-like X-ray sources, chosen via an algorithm <br>
--/T optimised to select coronally active stars.  Each row corresponds to <br>
--/T one possible match between an X-ray source and a potential optical/IR <br>
--/T counterpart.  The X-ray columns (ero_*) record the eROSITA information <br>
--/T known at the time of target selection and may differ from publicly <br>
--/T available eROSITA catalogs. The dr19_erosita_superset_* tables are <br>
--/T derived from a combination of eROSITA's first 6-month survey of of the <br>
--/T West Galactic hemisphere ('eRASS1'), and from the eROSITA observations <br>
--/T of the eROSITA Final Equatorial Depth performance verification field <br>
--/T ('eFEDS').
----------------------------------------------------------------------
    ero_version character(24), --/D Identifier giving the eROSITA dataset and processing version e.g. 'eFEDS_c940', 'em01_c946_201008_poscorr' etc
    ero_detuid character(32), --/D The standard official eROSITA unique detection identifier, e.g. 'em01_123456_020_ML12345_001_c946' etc
    ero_flux real, --/U erg/cm2/s --/D X-ray flux, usually in the main eROSITA detection band (0.2-2.3keV) 
    ero_morph character(9), --/D X-ray morphological classification ("POINTLIKE" or "EXTENDED")
    ero_det_like real, --/D X-ray detection likelihood
    ero_ra double precision, --/U deg --/D Best determination of X-ray position (J2000) 
    ero_dec double precision, --/U deg --/D Best determination of X-ray position (J2000) 
    ero_radec_err real, --/U arcsec --/D Best estimate of X-ray position uncertainty 
    xmatch_method character(24), --/D The X-ray-to-optical/IR cross-match method that was used in this case e.g. 'XPS-ML/NWAY', 'CLUSTERS_EFEDS_MULTIPLE' etc
    xmatch_version character(24), --/D The cross-match software version and OIR catalog used e.g. 'LSdr8-JWMS_v2.1LSdr8-JWMS_v2.1', 'LSdr8-AG_v1,JC_16032020', 'eromapper_2020-10-12', 'CW20ps1dr2-v011220' etc
    xmatch_dist real, --/U arcsec --/D Distance between X-ray position and optical counterpart 
    xmatch_metric real, --/D Metric giving quality of cross-match. Meaning is dependent on xmatch_method, e.g. p_any for NWAY
    xmatch_flags bigint, --/D Flags indicating cross-match properties (e.g. status flags), xmatch_method dependent
    target_class character(12), --/D Best guess of source classification at time of xmatch e.g. 'GALAXY','STAR','QSO','UNKNOWN',....
    target_priority integer, --/D Relative to other targets in this catalog, interpreted/adapted later to derive a final target priority
    target_has_spec bigint, --/D Flags used to indicate if target has good quality archival spectroscopy available
    opt_cat character(12), --/D Describes which OIR survey provided the optical counterpart for this row of the table, i.e. which OIR cat gives the entries in fields opt_ra, opt_dec, opt_pmra, opt_pmdec, opt_epoch, and which OIR identifier is given in the *_id columns
    ls_id bigint, --/D Identifier of counterpart (if any) in dr19_legacy_survey_dr8 ('ls_id' field). Arithmetically derived from legacysurvey sweep file columns: release, brickid and objid:  ls_id = objid + (brickid * 2**16) + (release * 2**40)
    ps1_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_panstarrs1 (catid_objid field). Identical to MAST 'ippObjID' identifier
    gaia_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_gaia_dr2_source ('source_id' field)
    catwise2020_id character(25), --/D Identifier of counterpart (if any) in dr19_catwise2020 ('source_id' field)
    skymapper_dr2_id bigint, --/D Identifier of counterpart (if any) in dr19_skymapper_dr2 ('object_id' field)
    supercosmos_id bigint, --/D Identifier of counterpart (if any) in dr19_supercosmos ('objid' field)
    tycho2_id character(12), --/D Identifier of counterpart (if any) in dr19_tycho2 ('designation' field)
    sdss_dr13_id bigint, --/D Identifier of counterpart (if any) in dr19_sdss_dr13_photoobj ('objid' field)
    opt_ra double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_dec double precision, --/U deg --/D Sky coordinate of optical/IR counterpart, included for validity checks only 
    opt_pmra real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_pmdec real, --/U mas/yr --/D Proper motion of optical/IR counterpart, included for validity checks only 
    opt_epoch real, --/U decimal year --/D Epoch of opt_ra,opt_dec 
    pkey bigint NOT NULL --/D primary key of table entry
);



--
-- Name: dr19_field; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_field (
----------------------------------------------------------------------
--/H The table includes the field information, where a field is a unique pointing of the telescope on the sky.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    racen double precision, --/D The Right Ascension of the center of the field.
    deccen double precision, --/D The Declination of the center of the field.
    version_pk integer, --/D The primary key of the version in the dr19_version table.
    cadence_pk integer, --/D The primary key of the cadence in the dr19_cadence table.
    observatory_pk integer, --/D The primary key of the observatory in the dr19_observatory table.
    position_angle real, --/D The position angle of the field E of N in degrees.
    slots_exposures text, --/D Exposures assigned to each LST and sky brightness slot 
    field_id integer --/D The idenifier of a field within a version of the survey plan.
);



--
-- Name: dr19_gaia_assas_sn_cepheids; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_gaia_assas_sn_cepheids (
----------------------------------------------------------------------
--/H Well-defined and characterized all-sky sample of
--/T classical Cepheids in the Milky Way, obtained by combining two <br>
--/T time-domain all-sky surveys: Gaia DR2 (Gaia Col. 2018; see I/345) <br>
--/T and All-Sky Automated Survey for Supernovae (ASAS-SN; <br>
--/T Shappee+ 2014AAS...22323603S) and presented in Inno+2021. <br>
--/T Inno+21 use parallax and variability information from Gaia <br>
--/T to select ~30000 bright (G<17) Cepheid candidates with M_K_{<}-1. <br>
--/T They analyze their ASAS-SN V-band light curves, determining periods <br>
--/T and classifying the light curves using their Fourier parameters. <br>
--/T This results in ~1900 likely Galactic Cepheids, Inno+21 estimate <br>
--/T to be >~90% complete and pure within their adopted selection criteria.
----------------------------------------------------------------------
    source text, --/D Source of photometric data 
    ref text, --/D Reference of the catalog from which period and mode are adopted (I20 = Inno+21) 
    star text, --/D Name of the star from literature sources 
    period double precision, --/U days --/D Period 
    amp_v double precision, --/U mag --/D Variability amplitude in the V band 
    mean_v double precision, --/U mag --/D Mean V band magnitude 
    a1_v double precision, --/D A_1 column in Table 2 of Inno+2021 
    source_id bigint NOT NULL, --/D Unique Gaia DR2 source identifier 
    random_index integer, --/D Random index used to select subsets 
    ref_epoch real,
    ra double precision, --/U deg --/D Right ascension 
    ra_error double precision, --/U mas --/D Standard error of right ascenscion 
    "dec" double precision, --/U deg --/D Declination 
    dec_error double precision, --/U mas --/D Standard error of declination 
    parallax double precision, --/U mas --/D Absolute stellar parallax of the source at J2015.5 
    parallax_error double precision, --/U mas --/D Standard error of parallax 
    parallax_over_error double precision, --/D Ratio of parallax/parallax_error 
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension 
    pmra_error double precision, --/U mas/yr --/D Standard error of proper motion in right ascension 
    pmdec double precision, --/U mas/yr --/D Proper motion in right declination 
    pmdec_error double precision, --/U mas/yr --/D Standard error of proper motion in declination 
    ra_dec_corr double precision, --/D Correlation between right ascension and declination 
    ra_parallax_corr double precision, --/D Correlation between right ascension and parallax  
    ra_pmra_corr double precision, --/D Correlation between right ascension and proper motion in right ascension 
    ra_pmdec_corr double precision, --/D Correlation between right ascension and proper motion in declination 
    dec_parallax_corr double precision, --/D Correlation between declination and parallax  
    dec_pmra_corr double precision, --/D Correlation between declination and proper motion in right ascension 
    dec_pmdec_corr double precision, --/D Correlation between declination and proper motion in declination 
    parallax_pmra_corr double precision, --/D Correlation between parallax and proper motion in right ascension 
    parallax_pmdec_corr double precision, --/D Correlation between parallax and proper motion in declination 
    pmra_pmdec_corr double precision, --/D Correlation between proper motion in right ascension and proper motion in declination 
    phot_g_n_obs smallint, --/D Number of observations contributing to G photometry 
    phot_g_mean_flux double precision, --/U e-/s --/D G-band mean flux 
    phot_g_mean_flux_error double precision, --/U e-/s --/D Error on G-band mean flux 
    phot_g_mean_flux_over_error double precision, --/D G-band mean flux divided by its error 
    phot_g_mean_mag double precision, --/U mag --/D G-band mean magnitude 
    phot_bp_n_obs smallint, --/D Number of observations contributing to BP photometry 
    phot_bp_mean_flux double precision, --/U e-/s --/D BP-band mean flux 
    phot_bp_mean_flux_error double precision, --/U e-/s --/D Error on BP-band mean flux 
    phot_bp_mean_flux_over_error double precision, --/D BP-band mean flux divided by its error 
    phot_bp_mean_mag double precision, --/U mag --/D BP-band mean magnitude 
    phot_rp_n_obs smallint, --/D Number of observations contributing to RP photometry 
    phot_rp_mean_flux double precision, --/U e-/s --/D RP-band mean flux 
    phot_rp_mean_flux_error double precision, --/U e-/s --/D Error on RP-band mean flux 
    phot_rp_mean_flux_over_error double precision, --/D RP-band mean flux divided by its error 
    phot_rp_mean_mag double precision, --/U mag --/D RP-band mean magnitude 
    phot_bp_rp_excess_factor double precision, --/D BP/RP excess factor 
    phot_proc_mode smallint, --/D Photometry processing mode 
    bp_rp double precision, --/U mag --/D BP - RP 
    bp_g double precision, --/U mag --/D BP - G 
    g_rp double precision, --/U mag --/D G - RP 
    radial_velocity double precision, --/U km/s --/D Gaia radial velocity 
    radial_velocity_error double precision, --/U km/s --/D Gaia radial velocity error 
    a_g_val double precision, --/U mag --/D line-of-sight extinction in the G band, A_G 
    a_g_percentile_lower double precision, --/U mag --/D aGVal lower uncertainty 
    a_g_percentile_upper double precision, --/U mag --/D aGVal upper uncertainty 
    e_bp_min_rp_val double precision, --/U mag --/D line-of-sight reddening E(BP-RP) 
    e_bp_min_rp_percentile_lower double precision, --/U mag --/D eBPminRPVal lower uncertainty 
    e_bp_min_rp_percentile_upper double precision, --/U mag --/D eBPminRPVal upper uncertainty 
    variability double precision, --/U 2 --/D Proxy for rms variability in the Gaia G band, defined as in Eq. 2 in Inno+21 
    type text, --/D Pulsation mode. F is Fundamental, 1O is First Overtone 
    twomass text, --/D Two Mass source identifier 
    raj2000 double precision, --/D Right ascension (J2000)
    dej2000 double precision, --/D Declination (J2000)
    errhalfmaj real, --/U arcsec --/D Semi-major axis length of the one sigma position uncertainty ellipse 
    errhalfmin real, --/U arcsec --/D Semi-minor axis length of the one sigma position uncertainty ellipse 
    errposang real, --/U deg --/D Position angle on the sky of the semi-major axis of the position uncertainty ellipse (East of North) 
    jmag real, --/U mag --/D Default J-band magnitude. In case of a source not detected in the J-band, it is an upper limit and the corresponding total photometric uncertainty is NULL. In case of a source detected in the J-band and with no useful brightness estimate, it is set to NULL 
    hmag real, --/U mag --/D Default H-band magnitude. In case of a source not detected in the H-band, it is an upper limit and the corresponding total photometric uncertainty is NULL. In case of a source detected in the H-band and with no useful brightness estimate, it is set to NULL 
    kmag real, --/U mag --/D Default Ks-band magnitude. In case of a source not detected in the Ks-band, it is an upper limit and the corresponding total photometric uncertainty is NULL. In case of a source detected in the Ks-band and with no useful brightness estimate, it is set to NULL 
    e_jmag real, --/U mag --/D Total photometric uncertainty for the default J-band magnitude. This column is NULL if the default magnitude is a 95% confidence upper limit (i.e. the source is not detected, or inconsistently deblended in the J-band) 
    e_hmag real, --/U mag --/D Total photometric uncertainty for the default H-band magnitude. This column is NULL if the default magnitude is a 95% confidence upper limit (i.e. the source is not detected, or inconsistently deblended in the H-band) 
    e_kmag real, --/U mag --/D Total photometric uncertainty for the default Ks-band magnitude. This column is NULL if the default magnitude is a 95% confidence upper limit (i.e. the source is not detected, or inconsistently deblended in the Ks-band) 
    qfl text, --/D JHK photometric quality flag 
    rfl smallint, --/D JHK default magnitude read flag 
    x smallint, --/U deg --/D Distance of source from focal plane centerline 
    measurejd double precision, --/D Julian date of detection 
    angdist double precision --/U arcsec --/D X-match angular distance 
);



--
-- Name: dr19_gaia_dr2_ruwe; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_gaia_dr2_ruwe (
----------------------------------------------------------------------
--/H Table from Gaia DR2 containing the Renormalised Unit Weight Error (RUWE) associated to each source in gaia_source. See https://gea.esac.esa.int/archive/documentation/GDR2/Gaia_archive/chap_datamodel/sec_dm_main_tables/ssec_dm_ruwe.html for more detailed descriptions of the columns
----------------------------------------------------------------------
    source_id bigint NOT NULL, --/D Gaia DR2 unique source identifier 
    ruwe real --/D renormalised unit weight error 
);



--
-- Name: dr19_gaia_dr2_source; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_gaia_dr2_source (
----------------------------------------------------------------------
--/H Gaia DR2 Source Table. See https://gea.esac.esa.int/archive/documentation/GDR2/Gaia_archive/chap_datamodel/sec_dm_main_tables/ssec_dm_gaia_source.html for complete details.
----------------------------------------------------------------------
    solution_id bigint, --/D ID that identifies the version of all the subsystems that were used in the generation of the data as well as the input data used 
    designation text, --/D Unique source designation across all Gaia data releases 
    source_id bigint NOT NULL, --/D Unique source identifier within a particular Gaia data release 
    random_index bigint, --/D Random index which can be used to select smaller subsets of the data 
    ref_epoch double precision, --/U Julian Years --/D Time 
    ra double precision, --/U degrees --/D Right Ascension 
    ra_error double precision, --/U degrees --/D Standard error of the right ascension 
    "dec" double precision, --/U degrees --/D Declination 
    dec_error double precision, --/U degrees --/D Standard error of the declination 
    parallax double precision, --/U mas --/D Absolute stellar parallax of the source at the reference epoch 
    parallax_error double precision, --/U mas --/D Standard error of parallax 
    parallax_over_error real, --/D Parallax divided by its error 
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension direction 
    pmra_error double precision, --/U mas/yr --/D Standard error of proper motion in right ascension direction 
    pmdec double precision, --/U mas/yr --/D Proper motion in declination direction 
    pmdec_error double precision, --/U mas/yr --/D Standard error of proper motion in declination direction 
    ra_dec_corr real, --/D Correlation between right ascension and declination 
    ra_parallax_corr real, --/D Correlation between right ascension and parallax 
    ra_pmra_corr real, --/D Correlation between right ascension and proper motion in right ascension 
    ra_pmdec_corr real, --/D Correlation between right ascension and proper motion in declination 
    dec_parallax_corr real, --/D Correlation between declination and parallax 
    dec_pmra_corr real, --/D Correlation between declination and proper motion in right ascension 
    dec_pmdec_corr real, --/D Correlation between declination and proper motion in declination 
    parallax_pmra_corr real, --/D Correlation between parallax and proper motion in right ascension 
    parallax_pmdec_corr real, --/D Correlation between parallax and proper motion in declination 
    pmra_pmdec_corr real, --/D Correlation between proper motion in right ascension and proper motion in declination 
    astrometric_n_obs_al integer, --/D Total number of observations AL 
    astrometric_n_obs_ac integer, --/D Total number of observations AC 
    astrometric_n_good_obs_al integer, --/D Number of good observations AL 
    astrometric_n_bad_obs_al integer, --/D Number of bad observations AL 
    astrometric_gof_al real, --/D Goodness of fit statistic of model wrt along-scan observations 
    astrometric_chi2_al real, --/D AL chi-square value 
    astrometric_excess_noise double precision, --/U mas --/D Excess noise of the source 
    astrometric_excess_noise_sig double precision, --/D Significance of excess noise 
    astrometric_params_solved integer, --/D Which parameters have been solved for 
    astrometric_primary_flag boolean, --/D Flag indicating if this source was used as a primary source (true) or secondary source (false) 
    astrometric_weight_al real, --/U mas^-2 --/D Mean astrometric weight of the source 
    astrometric_pseudo_colour double precision, --/U um^-1 --/D Astrometrically determined pseudocolour of the source 
    astrometric_pseudo_colour_error double precision, --/U um^-1 --/D Standard error of the pseudocolour of the source 
    mean_varpi_factor_al real, --/D Mean Parallax factor AL 
    astrometric_matched_observations smallint, --/D number of FOV transits matched to this source 
    visibility_periods_used smallint, --/D Number of visibility periods used in the astrometric solution 
    astrometric_sigma5d_max real, --/U mas --/D Longest semi-major axis of the 5-d error ellipsoid 
    frame_rotator_object_type integer, --/D Type of the source mainly used for frame rotation 
    matched_observations smallint, --/D Total number of FOV transits matched to this source 
    duplicated_source boolean, --/D Source with duplicate sources 
    phot_g_n_obs integer, --/D Number of observations contributing to G photometry 
    phot_g_mean_flux double precision, --/U e-/s --/D G-band mean flux 
    phot_g_mean_flux_error double precision, --/U e-/s --/D Error on G-band mean flux 
    phot_g_mean_flux_over_error real, --/D G-band mean flux divided by its error 
    phot_g_mean_mag real, --/U mag --/D G-band mean magnitude 
    phot_bp_n_obs integer, --/D Number of observations contributing to BP photometry 
    phot_bp_mean_flux double precision, --/U e-/s --/D Integrated BP mean flux 
    phot_bp_mean_flux_error double precision, --/U e-/s --/D Error on the integrated BP mean flux 
    phot_bp_mean_flux_over_error real, --/D Integrated BP mean flux divided by its error 
    phot_bp_mean_mag real, --/U mag --/D Integrated BP mean magnitude 
    phot_rp_n_obs integer, --/D Number of observations contributing to RP photometry 
    phot_rp_mean_flux double precision, --/U e-/s --/D Integrated RP mean flux 
    phot_rp_mean_flux_error double precision, --/U e-/s --/D Error on the integrated RP mean flux 
    phot_rp_mean_flux_over_error real, --/D Integrated RP mean flux divided by its error 
    phot_rp_mean_mag real, --/U mag --/D Integrated RP mean magnitude 
    phot_bp_rp_excess_factor real, --/D BP/RP excess factor 
    phot_proc_mode integer, --/D Photometry processing mode 
    bp_rp real, --/U mag --/D BP - RP color 
    bp_g real, --/U mag --/D BP - G color 
    g_rp real, --/U mag --/D G - RP color 
    radial_velocity double precision, --/U km/s --/D Radial velocity 
    radial_velocity_error double precision, --/U km/s --/D Radial velocity error 
    rv_nb_transits integer, --/D Number of transits used to compute radial velocity 
    rv_template_teff real, --/U K --/D Teff of the template used to compute radial velocity 
    rv_template_logg real, --/U log cgs --/D logg of the template used to compute radial velocity 
    rv_template_fe_h real, --/U dex --/D Fe/H of the template used to compute radial velocity 
    phot_variable_flag text, --/D Photometric variability flag 
    l double precision, --/U degrees --/D Galactic longitude 
    b double precision, --/U degrees --/D Galactic latitude 
    ecl_lon double precision, --/U degrees --/D Ecliptic longitude 
    ecl_lat double precision, --/U degrees --/D Ecliptic latitude 
    priam_flags bigint, --/D Flags for the Apsis-Priam results 
    teff_val real, --/U K --/D Stellar effective temperature 
    teff_percentile_lower real, --/U K --/D Teff_val lower uncertainty 
    teff_percentile_upper real, --/U K --/D Teff_val upper uncertainty 
    a_g_val real, --/U mag --/D Line-of-sight extinction in the G band 
    a_g_percentile_lower real, --/U mag --/D A_g_val lower uncertainty 
    a_g_percentile_upper real, --/U mag --/D A_g_val upper uncertainty 
    e_bp_min_rp_val real, --/U mag --/D Line-of-sight reddening E(BP-RP) 
    e_bp_min_rp_percentile_lower real, --/U mag --/D e_bp_min_rp_val lower uncertainty 
    e_bp_min_rp_percentile_upper real, --/U mag --/D e_bp_min_rp_val upper uncertainty 
    flame_flags bigint, --/D Flags for the Apsis-FLAME results 
    radius_val real, --/U Solar Radius --/D Stellar radius 
    radius_percentile_lower real, --/U Solar Radius --/D Radius_val lower uncertainty 
    radius_percentile_upper real, --/U Solar Radius --/D Radius_val upper uncertainty 
    lum_val real, --/U Solar Luminosity --/D stellar luminosity 
    lum_percentile_lower real, --/U Solar Luminosity --/D lum_val lower uncertainty 
    lum_percentile_upper real --/U Solar Luminosity --/D lum_val upper uncertainty 
);



--
-- Name: dr19_gaia_dr2_wd; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_gaia_dr2_wd (
----------------------------------------------------------------------
--/H White dwarf catalog of high-probablity WDs from Gentile Fusillo (2019) based on Gaia DR2. Please see https://academic.oup.com/mnras/article/482/4/4570/5162857 for more information on the columns.
----------------------------------------------------------------------
    wd text, --/D WD names from this catalog -- WD J + J2000 ra (hh mm ss.ss) + dec (dd mm ss.s), equinox and epoch 2000 
    dr2name text, --/D Unique Gaia source designation 
    source_id bigint NOT NULL, --/D Unique Gaia DR2 source identifier 
    source integer, --/D Internal identifier (do not use) 
    ra double precision, --/U deg --/D Right ascension 
    e_ra double precision, --/U mas --/D Standard error of right ascenscion 
    "dec" double precision, --/U deg --/D Declination 
    e_dec double precision, --/U mas --/D Standard error of declination 
    plx real, --/U mas --/D Absolute stellar parallax of the source at J2015.5 
    e_plx real, --/U mas --/D Standard error of parallax 
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension 
    e_pmra double precision, --/U mas/yr --/D Standard error of proper motion in right ascension 
    pmdec double precision, --/U mas/yr --/D Proper motion in right declination 
    e_pmdec double precision, --/U mas/yr --/D Standard error of proper motion in declination 
    epsi real, --/U mas --/D Measure of the residuals in the astrometric solution 
    amax real, --/U mas --/D 5-dimensional equivalent to the semimajor axis of the Gaia position error ellipse 
    fg_gaia real, --/U e-/s --/D Gaia G-band mean flux 
    e_fg_gaia real, --/U e-/s --/D Error on G-band mean flux 
    g_gaia_mag real, --/U mag --/D Gaia G-band mean magnitude 
    fbp real, --/U e-/s --/D Integrated G_BP mean flux 
    e_fbp real, --/U e-/s --/D Error on integrated G_BP mean flux 
    bpmag real, --/U mag --/D Integrated G_BP mean magnitude 
    frp real, --/U e-/s --/D Integrated G_RP mean flux 
    e_frp real, --/U e-/s --/D Error on integrated G_RP mean flux 
    rpmag real, --/U mag --/D Integrated G_RP mean magnitude 
    e_br_rp real, --/D G_BP/G_RP execess factor
    glon double precision, --/U deg --/D Galactic longitude 
    glat double precision, --/U deg --/D Galactic latitude 
    density real, --/U sq.deg^-1 --/D Number of Gaia sources around this object 
    ag real, --/U mag --/D Extinction in the Gaia G band derived from E(B − V) values from Schlafly and  Finkbeiner 
    sdss text, --/D SDSS object name if available 
    umag real, --/U mag --/D SDSS u-band magnitude 
    e_umag real, --/U mag --/D SDSS u-band magnitude uncertainty 
    gmag real, --/U mag --/D SDSS g-band magnitude uncertainty 
    e_gmag real, --/U mag --/D SDSS g-band magnitude 
    rmag real, --/U mag --/D SDSS r-band magnitude uncertainty 
    e_rmag real, --/U mag --/D SDSS r-band magnitude 
    imag real, --/U mag --/D SDSS i-band magnitude uncertainty 
    e_imag real, --/U mag --/D SDSS i-band magnitude 
    zmag real, --/U mag --/D SDSS z-band magnitude uncertainty 
    e_zmag real, --/U mag --/D SDSS z-band magnitude 
    pwd real, --/D Probability of being a white dwarf 
    f_pwd integer, --/D Flag on probability of being a white dwarf 
    teffh real, --/U K --/D Effective temperature from fitting the dereddened G, GBP, and GRP absolute fluxes with pure-H model atmospheres 
    e_teffh real, --/U K --/D Uncertainty on Teff from pure-H model atmospheres 
    loggh real, --/U dex cgs --/D Surface gravity from fitting the dereddened G, GBP, and GRP absolute fluxes with pure-H model atmospheres 
    e_loggh real, --/U dex cgs --/D Uncertainty on log g from pure-H model atmospheres 
    massh real, --/U Solar masses --/D Stellar mass assuming pure-H model atmospheres 
    e_massh real, --/U Solar masses --/D Uncertainty on the mass assuming pure-H model atmospheres 
    chi2h real, --/D Chi^2 value of the pure-H fit 
    teffhe real, --/U K --/D Effective temperature from fitting the dereddened G, GBP, and GRP absolute fluxes with pure-He model atmospheres 
    e_teffhe real, --/U K --/D Uncertainty on Teff from pure-He model atmospheres 
    logghe real, --/U dex cgs --/D Surface gravity from fitting the dereddened G, GBP, and GRP absolute fluxes with pure-He model atmospheres 
    e_logghe real, --/U dex cgs --/D Uncertainty on log g from pure-He model atmospheres 
    masshe real, --/U Solar masses --/D Stellar mass assuming pure-He model atmospheres 
    e_masshe real, --/U Solar masses --/D Uncertainty on the mass assuming pure-H model atmospheres 
    chisqhe real --/D Chi^2 value of the pure-H fit 
);



--
-- Name: dr19_gaia_unwise_agn; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_gaia_unwise_agn (
----------------------------------------------------------------------
--/H AGN identified using information from WISE and Gaia DR2 from the catalog of Shu et al. 2019. See complete information on the columns in https://academic.oup.com/mnras/article/489/4/4741/5561523
----------------------------------------------------------------------
    ra double precision, --/U degrees --/D Right ascension from Gaia DR2 
    "dec" double precision, --/U degrees --/D Declination from Gaia DR2 
    gaia_sourceid bigint NOT NULL, --/D Unique Gaia DR2 source identifier 
    unwise_objid text, --/D Unique unWISE source identifier 
    plx double precision, --/U mas --/D Parallax from Gaia DR2 
    plx_err double precision, --/U mas --/D Error in parallax from Gaia DR2 
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension from Gaia DR2 
    pmra_err double precision, --/U mas/yr --/D Error in proper motion in right ascension from Gaia DR2 
    pmdec double precision, --/U mas/yr --/D Proper motion in declination from Gaia DR2 
    pmdec_err double precision, --/U mas/yr --/D Error in proper motinon in declination from Gaia DR2 
    plxsig double precision, --/D Parallax significance defined as parallax/parallax_error 
    pmsig double precision, --/D Proper motion significance 
    ebv double precision, --/U mag --/D Galactic E(B-V) reddening from Schlegel et al. 1998 
    n_obs integer, --/D Number of observations contributing to Gaia DR2 G photometry 
    g double precision, --/U mag --/D Gaia DR2 G-band mean magnitude (extinction corrected) 
    bp double precision, --/U mag --/D Gaia DR2 BP-band mean magnitude (extinction corrected) 
    rp double precision, --/U mag --/D Gaia DR2 RP-band mean magnitude (extinction corrected) 
    w1 double precision, --/U mag --/D unWISE W1-band magnitude 
    w2 double precision, --/U mag --/D unWISE W2-band magnitude 
    bp_g double precision, --/U mag --/D Gaia DR2 BP − G color (extinction corrected) 
    bp_rp double precision, --/U mag --/D Gaia DR2 BP − RP color (extinction corrected) 
    g_rp double precision, --/U mag --/D Gaia DR2 G − RP color (extinction corrected) 
    g_w1 double precision, --/U mag --/D Gaia DR2 G − unWISE W1 color (extinction corrected) 
    gw_sep double precision, --/U arcsec --/D Separation between a Gaia source and its unWISE counterpart 
    w1_w2 double precision, --/U mag --/D unWISE W1 −W2 color 
    g_var double precision, --/D Variation in GaiaG-band flux 
    bprp_ef double precision, --/D BP/RP excess factor from Gaia DR2 
    aen double precision, --/U mas --/D Astrometric excess noise from Gaia DR2 
    gof double precision, --/D Goodness-of-fit statistic of the astrometric solution from Gaia DR2 
    cnt1 integer, --/D Number of Gaia DR2 sources within a 1 arcsec radius circular aperture 
    cnt2 integer, --/D Number of Gaia DR2 sources within a 2 arcsec radius circular aperture 
    cnt4 integer, --/D Number of Gaia DR2 sources within a 4 arcsec radius circular aperture 
    cnt8 integer, --/D Number of Gaia DR2 sources within a 8 arcsec radius circular aperture 
    cnt16 integer, --/D Number of Gaia DR2 sources within a 16 arcsec radius circular aperture 
    cnt32 integer, --/D Number of Gaia DR2 sources within a 32 arcsec radius circular aperture 
    phot_z double precision, --/D Photometric redshift 
    prob_rf double precision --/D AGN probability 
);



--
-- Name: dr19_gaiadr2_tmass_best_neighbour; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_gaiadr2_tmass_best_neighbour (
----------------------------------------------------------------------
--/H The Gaia DR2 vs. 2MASS PSC crossmatch provided by the Gaia collaboration. Please see https://gea.esac.esa.int/archive/documentation/GDR2/Catalogue_consolidation/chap_cu9val_cu9val/ssec_cu9xma/sssec_cu9xma_extcat.html for complete details.
----------------------------------------------------------------------
    tmass_oid bigint, --/D Additional numeric unique source identifier of 2MASS, increasing with declination 
    number_of_neighbours integer, --/D Number of sources in the 2MASS Catalogue which match the Gaia source within position errors 
    number_of_mates integer, --/D Number of other Gaia sources that have as best-neighbour the same 2MASS source.
    best_neighbour_multiplicity integer, --/D Number of neighbours with same probability as best neighbour 
    source_id bigint NOT NULL, --/D Unique Gaia DR2 source identifier 
    original_ext_source_id character(17), --/D The unique source identifier in the original 2MASS catalogue 
    angular_distance double precision, --/U arcsec --/D Angular distance between the two sources 
    gaia_astrometric_params integer, --/D Number of Gaia astrometric params used 
    tmass_pts_key integer --/D key for crossmatch 
);



--
-- Name: dr19_geometric_distances_gaia_dr2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_geometric_distances_gaia_dr2 (
----------------------------------------------------------------------
--/H Bayesian distances from Gaia DR2 parameters from Bailer-Jones et al. 2018. For complete details, see the original paper: https://iopscience.iop.org/article/10.3847/1538-3881/aacb21/pdf
----------------------------------------------------------------------
    source_id bigint NOT NULL, --/D Unique Gaia DR2 source identifier 
    r_est real, --/U pc --/D Estimated distance 
    r_lo real, --/U pc --/D Lower bound on the confidence interval of the estimated distance 
    r_hi real, --/U pc --/D Upper bound on the confidence interval of the estimated distance 
    r_len real, --/U pc --/D Length scale used in the prior for the distance estimation 
    result_flag character(1), --/D Result flag 
    modality_flag smallint --/D Number of modes in the posterior 
);



--
-- Name: dr19_glimpse; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_glimpse (
----------------------------------------------------------------------
--/H GLIMPSE catalog (I, II and 3-D). See full documentation at https://irsa.ipac.caltech.edu/data/SPITZER/GLIMPSE/doc/glimpse1_dataprod_v2.0.pdf
----------------------------------------------------------------------
    designation text, --/D position-based designation in Galactic coordinates 
    tmass_designation character varying(18), --/D 2MASS designation from PSC 
    tmass_cntr integer, --/D 2MASS counter 
    l double precision, --/U degrees --/D Galactic longitude 
    b double precision, --/U degrees --/D Galactic latitude 
    dl double precision, --/U degrees --/D uncertaintiy in Galactic longitude 
    db double precision, --/U degrees --/D uncertainty in Galactic latitude 
    ra double precision, --/U degrees --/D right ascension 
    "dec" double precision, --/U degrees --/D declination 
    dra double precision, --/U degrees --/D uncertainity in RA 
    ddec double precision, --/U degrees --/D uncertainity in Dec 
    csf integer, --/D close source flag (see GLIMPSE documentation for details) 
    mag_j real, --/U mag --/D 2MASS J-band magnitude 
    dj_m real, --/U mag --/D uncertainity in 2MASS J-band magnitude 
    mag_h real, --/U mag --/D 2MASS H-band magnitude 
    dh_m real, --/U mag --/D uncertainity in 2MASS H-band magnitude 
    mag_ks real, --/U mag --/D 2MASS Ks-band magnitude 
    dks_m real, --/U mag --/D uncertainity in 2MASS Ks-band magnitude 
    mag3_6 real, --/U mag --/D IRAC 3.6-band magnitude 
    d3_6m real, --/U mag --/D uncertainty in IRAC 3.6-band magnitude 
    mag4_5 real, --/U mag --/D IRAC 4.5-band magnitude 
    d4_5m real, --/U mag --/D uncertainty in IRAC 4.5-band magnitude 
    mag5_8 real, --/U mag --/D IRAC 5.8-band magnitude 
    d5_8m real, --/U mag --/D uncertainty in IRAC 5.8-band magnitude 
    mag8_0 real, --/U mag --/D IRAC 8.0-band magnitude 
    d8_0m real, --/U mag --/D uncertainty in IRAC 8.0-band magnitude 
    f_j real, --/U mJy --/D 2MASS J-band flux 
    df_j real, --/U mJy --/D uncertainity in 2MASS J-band flux 
    f_h real, --/U mJy --/D 2MASS H-band flux 
    df_h real, --/U mJy --/D uncertainty in 2MASS H-band flux 
    f_ks real, --/U mJy --/D 2MASS Ks-band flux 
    df_ks real, --/U mJy --/D uncertainity in 2MASS Ks-band flux 
    f3_6 real, --/U mJy --/D IRAC 3.6-band flux 
    df3_6 real, --/U mJy --/D uncertainty in IRAC 3.6-band flux 
    f4_5 real, --/U mJy --/D IRAC 4.5-band flux 
    df4_5 real, --/U mJy --/D uncertainty in IRAC 4.5-band flux 
    f5_8 real, --/U mJy --/D IRAC 5.8-band flux 
    df5_8 real, --/U mJy --/D uncertainty in IRAC 5.8-band flux 
    f8_0 real, --/U mJy --/D IRAC 8.0-band flux 
    df8_0 real, --/U mJy --/D uncertainty in IRAC 8.0-band flux 
    rms_f3_6 real, --/U mJy --/D RMS deviation of the individual detections from final flux in IRAC 3.6-band 
    rms_f4_5 real, --/U mJy --/D RMS deviation of the individual detections from final flux in IRAC 4.5-band 
    rms_f5_8 real, --/U mJy --/D RMS deviation of the individual detections from final flux in IRAC 5.8-band 
    rms_f8_0 real, --/U mJy --/D RMS deviation of the individual detections from final flux in IRAC 8.0-band 
    sky_3_6 real, --/U mJy/sr --/D local background sky in IRAC 3.6-band 
    sky_4_5 real, --/U mJy/sr --/D local background sky in IRAC 4.5-band 
    sky_5_8 real, --/U mJy/sr --/D local background sky in IRAC 5.8-band 
    sky_8_0 real, --/U mJy/sr --/D local background sky in IRAC 8.0-band 
    sn_j real, --/D j_snr in 2MASS J-band 
    sn_h real, --/D h_snr from 2MASS catalog 
    sn_ks real, --/D ks_snr from 2MASS catalog 
    sn_3_6 real, --/D (flux)/(uncertainty in flux) in IRAC 3.5-band 
    sn_4_5 real, --/D (flux)/(uncertainty in flux) in IRAC 4.5-band 
    sn_5_8 real, --/D (flux)/(uncertainty in flux) in IRAC 5.8-band 
    sn_8_0 real, --/D (flux)/(uncertainty in flux) in IRAC 8.0-band 
    dens_3_6 real, --/U #/sqarcmin --/D local source density in IRAC 3.6-band 
    dens_4_5 real, --/U #/sqarcmin --/D local source density in IRAC 4.5-band 
    dens_5_8 real, --/U #/sqarcmin --/D local source density in IRAC 5.8-band 
    dens_8_0 real, --/U #/sqarcmin --/D local source density in IRAC 8.0-band 
    m3_6 integer, --/D number of source detections in IRAC 3.6-band 
    m4_5 integer, --/D number of source detections in IRAC 4.5-band 
    m5_8 integer, --/D number of source detections in IRAC 5.8-band 
    m8_0 integer, --/D number of source detections in IRAC 8.0-band 
    n3_6 integer, --/D number of observations in IRAC 3.6-band 
    n4_5 integer, --/D number of observations in IRAC 4.5-band 
    n5_8 integer, --/D number of observations in IRAC 5.8-band 
    n8_0 integer, --/D number of observations in IRAC 8.0-band 
    sqf_j integer, --/D source quality flag for 2MASS J-band (see GLIMPSE documentation for details) 
    sqf_h integer, --/D source quality flag for 2MASS H-band (see GLIMPSE documentation for details) 
    sqf_ks integer, --/D source quality flag for 2MASS Ks-band (see GLIMPSE documentation for details) 
    sqf_3_6 integer, --/D source quality flag for IRAC 3.6-band (see GLIMPSE documentation for details) 
    sqf_4_5 integer, --/D source quality flag for IRAC 4.5-band (see GLIMPSE documentation for details) 
    sqf_5_8 integer, --/D source quality flag for IRAC 5.8-band (see GLIMPSE documentation for details) 
    sqf_8_0 integer, --/D source quality flag for IRAC 8.0-band (see GLIMPSE documentation for details) 
    mf3_6 integer, --/D method flag for IRAC 3.6-band (see GLIMPSE documentation for details) 
    mf4_5 integer, --/D method flag for IRAC 4.5-band (see GLIMPSE documentation for details) 
    mf5_8 integer, --/D method flag for IRAC 5.8-band (see GLIMPSE documentation for details) 
    mf8_0 integer, --/D method flag for IRAC 8.0-band (see GLIMPSE documentation for details) 
    pk bigint NOT NULL --/D primary key 
);



--
-- Name: dr19_guvcat; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_guvcat (
----------------------------------------------------------------------
--/H GALEX unique source catalog from Bianchi et al. 2017 (https://iopscience.iop.org/article/10.3847/1538-4365/aa7053/pdf). For more details on the column descriptions see https://archive.stsci.edu/hlsp/guvcat/guvcat-column-description
----------------------------------------------------------------------
    objid bigint NOT NULL, --/D GALEX identifier for the source 
    photoextractid bigint, --/D Pointer to GALEX photoExtract Table (identifier of original observation) 
    mpstype text, --/D Survey type ("AIS") 
    avaspra double precision, --/U degrees --/D R.A. of center of field where object was measured 
    avaspdec double precision, --/U degrees --/D Declination of center of field where object was measured 
    fexptime real, --/U seconds --/D FUV exposure time 
    nexptime real, --/U seconds --/D NUV exposure time 
    ra double precision, --/U degrees --/D Source's right ascension 
    "dec" double precision, --/U degrees --/D Source's declination 
    glon double precision, --/U degrees --/D Source's Galactic longitude 
    glat double precision, --/U degrees --/D Source's Galactic latitude 
    tilenum integer, --/D "Tile" number 
    img integer, --/D Image number 
    subvisit integer, --/D Number of subvisit if exposure was divided 
    fov_radius real, --/D Distance of source from center of the field in which it was measured 
    type integer, --/D Obs. type (0=single, 1=multi) 
    band integer, --/D Band number (1=NUV, 2=FUV, 3=both) 
    e_bv real, --/U mag --/D E(B-V) Galactic reddening from Schlegel et al. 1998 maps) 
    istherespectrum smallint, --/D Does this object have a GALEX spectrum? 
    chkobj_type smallint, --/D Astrometry check type 
    fuv_mag real, --/U mag --/D FUV calibrated magnitude 
    fuv_magerr real, --/U mag --/D FUV calibrated magnitude error 
    nuv_mag real, --/U mag --/D NUV calibrated magnitude 
    nuv_magerr real, --/U mag --/D NUV calibrated magnitude error 
    fuv_mag_auto real, --/U mag --/D FUV Kron-like elliptical aperture magnitude 
    fuv_magerr_auto real, --/U mag --/D FUV rms error for AUTO magnitude 
    nuv_mag_auto real, --/U mag --/D NUV Kron-like elliptical aperture magnitude 
    nuv_magerr_auto real, --/U mag --/D NUV rms error for AUTO magnitude 
    fuv_mag_aper_4 real, --/U mag --/D FUV magnitude aperture (8 pixel) 
    fuv_magerr_aper_4 real, --/U mag --/D FUV magnitude error aperture (8 pixel) 
    nuv_mag_aper_4 real, --/U mag --/D NUV magnitude aperture (8 pixel) 
    nuv_magerr_aper_4 real, --/U mag --/D NUV magnitude error aperture (8 pixel) 
    fuv_mag_aper_6 real, --/U mag --/D FUV magnitude aperture (17 pixel) 
    fuv_magerr_aper_6 real, --/U mag --/D FUV magnitude error aperture (17 pixel) 
    nuv_mag_aper_6 real, --/U mag --/D NUV magnitude aperture (17 pixel) 
    nuv_magerr_aper_6 real, --/U mag --/D NUV magnitude error aperture (17 pixel) 
    fuv_artifact smallint, --/D FUV artifact flag 
    nuv_artifact smallint, --/D NUV artifact flag 
    fuv_flags smallint, --/D FUV extraction flags 
    nuv_flags smallint, --/D NUV extraction flags 
    fuv_flux real, --/U mJy --/D FUV calibrated flux 
    fuv_fluxerr real, --/U mJy --/D FUV calibrated flux error 
    nuv_flux real, --/U mJy --/D NUV calibrated flux 
    nuv_fluxerr real, --/U mJy --/D NUV calibrated flux error 
    fuv_x_image real, --/D FUV object position along x 
    fuv_y_image real, --/D FUV object position along y 
    nuv_x_image real, --/D NUV object position along x 
    nuv_y_image real, --/D NUV object position along y 
    fuv_fwhm_image real, --/D FUV FWHM assuming a Gaussian core 
    nuv_fwhm_image real, --/D NUV FWHM assuming a Gaussian core 
    fuv_fwhm_world real, --/D FUV FWHM assuming a Gaussian core (WORLD units) 
    nuv_fwhm_world real, --/D NUV FWHM assuming a Gaussian core (WORLD units) 
    nuv_class_star real, --/D NUV Star/Galaxy classifier 
    fuv_class_star real, --/D FUV Star/Galaxy classifier 
    nuv_ellipticity real, --/D NUV (1. - B_IMAGE/A_IMAGE) 
    fuv_ellipticity real, --/D FUV (1. - B_IMAGE/A_IMAGE) 
    nuv_theta_j2000 real, --/U degrees --/D NUV position angle (east of north) (J2000) 
    nuv_errtheta_j2000 real, --/U degrees --/D NUV position angle error (east of north) (J2000) 
    fuv_theta_j2000 real, --/U degrees --/D FUV position angle (east of north) (J2000) 
    fuv_errtheta_j2000 real, --/U degrees --/D FUV position angle error (east of north) (J2000) 
    fuv_ncat_fwhm_image real, --/U pixels --/D FUV FWHM_IMAGE value from -fd-ncat.fits 
    fuv_ncat_flux_radius_3 real, --/D FUV FLUX_RADIUS using Aperture 
    nuv_kron_radius real, --/D NUV Kron apertures in units of A or B 
    nuv_a_world real, --/D NUV profile rms along major axis (world units) 
    nuv_b_world real, --/D NUV profile rms along minor axis (world units) 
    fuv_kron_radius real, --/D FUV Kron apertures in units of A or B 
    fuv_a_world real, --/D FUV profile rms along major axis (world units) 
    fuv_b_world real, --/D FUV profile rms along minor axis (world units) 
    nuv_weight real, --/U seconds --/D NUV effective exposure (flat-field response value) at the source position 
    fuv_weight real, --/U seconds --/D FUV effective exposure (flat-field response value) at the source position 
    prob real, --/D Probability of the FUV-NUV cross-match 
    sep real, --/D Separation between the FUV and NUV position of the source in the same observation 
    nuv_poserr real, --/U arcsec --/D Position error of the source in the NUV image 
    fuv_poserr real, --/U arcsec --/D Position error of the source in the FUV image 
    ib_poserr real, --/U arcsec --/D Inter-band position error 
    nuv_pperr real, --/D NUV Poisson position error 
    fuv_pperr real, --/D FUV Poisson position error 
    corv text, --/D Whether the source comes from a coadd or visit 
    grank smallint, --/D rank of source with 2.5 arcsec of primary 
    ngrank smallint, --/D If this is a primary, the number of sources within 2.5 arcsec 
    primgid bigint, --/D OBJID of the primary 
    groupgid text, --/D OBJID's of all AIS sources within 2.5 arcseconds concatenated by a "+" 
    grankdist smallint, --/D Same for GRANK, but based on distance criterion 
    ngrankdist bigint, --/D Same for NGRANK, but based on distance criterion 
    primgiddist bigint, --/D Same for PRIMGID, but based on distance criterion 
    groupgiddist text, --/D Same for GROUPGID, but based on distance criterion 
    groupgidtot text, --/D OBJID's of all sources within 2.5 arcseconds 
    difffuv real, --/U mag --/D FUV magnitude difference between primary and secondary 
    diffnuv real, --/U mag --/D NUV magnitude difference between primary and secondary 
    difffuvdist real, --/U mag --/D FUV magnitude difference between primary and secondary, but based on distance criterion 
    diffnuvdist real, --/U mag --/D NUV magnitude difference between primary and secondary, but based on distance criterion 
    sepas real, --/U arcsec --/D Separation between primary and secondary 
    sepasdist real, --/U arcsec --/D Separation between primary and secondary, but based on distance criterion 
    inlargeobj text, --/D Is source in the footprint of an extended object? 
    largeobjsize real --/D Size of the extended object 
);



--
-- Name: dr19_hole; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_hole (
----------------------------------------------------------------------
--/H The holes in which the positioners sit for the FPS at each observatory.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    row_num integer, --/D The row of the hole in which the positioner is sitting.
    column_num integer, --/D The column of the hole in which the positioner is sitting.
    holeid text, --/D The identifier for the hole in which the positioner is sitting.
    observatory_pk integer --/D The primary key of the observatory in the dr19_observatory table.
);



--
-- Name: dr19_instrument; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_instrument (
----------------------------------------------------------------------
--/H This table stores the instruments used by SDSS-V.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    label text, --/D The name of the instrument.
    default_lambda_eff real --/U angstrom --/D The default wavelength for which fibre positioning will be optimised 
);



--
-- Name: dr19_legacy_catalog_catalogid; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_legacy_catalog_catalogid (
    catalogid bigint NOT NULL
);



--
-- Name: dr19_legacy_survey_dr8; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_legacy_survey_dr8 (
----------------------------------------------------------------------
--/H Legacy Survey DR8 catalogue derived from 'sweep' catalogues (See <a href="https://www.legacysurvey.org/dr8/">https://www.legacysurvey.org/dr8/</a>).
----------------------------------------------------------------------
    release integer, --/D Unique integer denoting the camera and filter set used (RELEASE documentation: https://www.legacysurvey.org/release/) 
    brickid bigint, --/D A unique Brick ID (in the range 1-662174) 
    brickname text, --/D Name of brick, encoding the brick sky position, eg "1126p222" near RA=112.6, Dec=+22.2 
    objid bigint, --/D Catalog object number within this brick; a unique identifier hash is RELEASE,BRICKID,OBJID; OBJID spans 0 to N-1 and is contiguously enumerated within each blob 
    type text, --/D Morphological model: "PSF"=stellar, "REX"="round exponential galaxy" = round EXP galaxy with a variable radius, "EXP"=exponential, "DEV"=deVauc, "COMP"=composite, "DUP"==Gaia source fit by different model. Note that in some FITS readers, a trailing space may be appended for "PSF ", "EXP " and "DEV " since the column data type is a 4-character string 
    ra double precision, --/U deg --/D Right ascension at equinox J2000 
    "dec" double precision, --/U deg --/D Declination at equinox J2000 
    ra_ivar real, --/U 1/deg^2 --/D Inverse variance of RA (no cosine term!), excluding astrometric calibration errors 
    dec_ivar real, --/U 1/deg^2 --/D Inverse variance of DEC, excluding astrometric calibration errors 
    dchisq_psf real, --/D Difference in chi2 between successively more-complex model fits: PSF. The difference is versus no source. 
    dchisq_rex real, --/D Difference in chi2 between successively more-complex model fits: REX. The difference is versus no source. 
    dchisq_dev real, --/D Difference in chi2 between successively more-complex model fits: DEV. The difference is versus no source. 
    dchisq_exp real, --/D Difference in chi2 between successively more-complex model fits: EXP. The difference is versus no source. 
    dchisq_comp real, --/D Difference in chi2 between successively more-complex model fits: COMP. The difference is versus no source. 
    ebv real, --/U mag --/D Galactic extinction E(B-V) reddening from SFD98, used to compute MW_TRANSMISSION 
    flux_g real, --/U nanomaggies --/D model flux in g 
    flux_r real, --/U nanomaggies --/D model flux in r 
    flux_z real, --/U nanomaggies --/D model flux in z 
    flux_w1 real, --/U nanomaggies --/D WISE model flux in W1 (AB system) 
    flux_w2 real, --/U nanomaggies --/D WISE model flux in W2 (AB system) 
    flux_w3 real, --/U nanomaggies --/D WISE model flux in W3 (AB system) 
    flux_w4 real, --/U nanomaggies --/D WISE model flux in W4 (AB system) 
    flux_ivar_g real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_G 
    flux_ivar_r real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_R 
    flux_ivar_z real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_Z 
    flux_ivar_w1 real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_W1 (AB system) 
    flux_ivar_w2 real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_W2 (AB system) 
    flux_ivar_w3 real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_W3 (AB system) 
    flux_ivar_w4 real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_W4 (AB system) 
    mw_transmission_g real, --/D Galactic transmission in g filter in linear units 
    mw_transmission_r real, --/D Galactic transmission in r filter in linear units 
    mw_transmission_z real, --/D Galactic transmission in z filter in linear units 
    mw_transmission_w1 real, --/D Galactic transmission in W1 filter in linear units 
    mw_transmission_w2 real, --/D Galactic transmission in W2 filter in linear units 
    mw_transmission_w3 real, --/D Galactic transmission in W3 filter in linear units 
    mw_transmission_w4 real, --/D Galactic transmission in W4 filter in linear units 
    nobs_g integer, --/D Number of images that contribute to the central pixel in g: filter for this object (not profile-weighted) 
    nobs_r integer, --/D Number of images that contribute to the central pixel in r: filter for this object (not profile-weighted) 
    nobs_z integer, --/D Number of images that contribute to the central pixel in z: filter for this object (not profile-weighted) 
    nobs_w1 integer, --/D Number of images that contribute to the central pixel in W1: filter for this object (not profile-weighted) 
    nobs_w2 integer, --/D Number of images that contribute to the central pixel in W2: filter for this object (not profile-weighted) 
    nobs_w3 integer, --/D Number of images that contribute to the central pixel in W3: filter for this object (not profile-weighted) 
    nobs_w4 integer, --/D Number of images that contribute to the central pixel in W4: filter for this object (not profile-weighted) 
    rchisq_g real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels in g 
    rchisq_r real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels in r 
    rchisq_z real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels in z 
    rchisq_w1 real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels in W1 
    rchisq_w2 real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels in W2 
    rchisq_w3 real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels in W3 
    rchisq_w4 real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels in W4 
    fracflux_g real, --/D Profile-weighted fraction of the flux from other sources divided by the total flux in g (typically in 0..1) 
    fracflux_r real, --/D Profile-weighted fraction of the flux from other sources divided by the total flux in r (typically in 0..1) 
    fracflux_z real, --/D Profile-weighted fraction of the flux from other sources divided by the total flux in z (typically in 0..1) 
    fracflux_w1 real, --/D Profile-weighted fraction of the flux from other sources divided by the total flux in W1 (typically in 0..1) 
    fracflux_w2 real, --/D Profile-weighted fraction of the flux from other sources divided by the total flux in W2 (typically in 0..1) 
    fracflux_w3 real, --/D Profile-weighted fraction of the flux from other sources divided by the total flux in W3 (typically in 0..1) 
    fracflux_w4 real, --/D Profile-weighted fraction of the flux from other sources divided by the total flux in W4 (typically in 0..1) 
    fracmasked_g real, --/D Profile-weighted fraction of pixels masked from all observations of this object in g, strictly between 0..1 
    fracmasked_r real, --/D Profile-weighted fraction of pixels masked from all observations of this object in r, strictly between 0..1 
    fracmasked_z real, --/D Profile-weighted fraction of pixels masked from all observations of this object in z, strictly between 0..1 
    fracin_g real, --/D Fraction of a source's flux within the blob in g, near unity for real sources 
    fracin_r real, --/D Fraction of a source's flux within the blob in r, near unity for real sources 
    fracin_z real, --/D Fraction of a source's flux within the blob in z, near unity for real sources 
    anymask_g integer, --/D Bitwise mask set if the central pixel from any image satisfies each condition in g (see the DR8 bitmasks page) 
    anymask_r integer, --/D Bitwise mask set if the central pixel from any image satisfies each condition in r (see the DR8 bitmasks page) 
    anymask_z integer, --/D Bitwise mask set if the central pixel from any image satisfies each condition in z (see the DR8 bitmasks page) 
    allmask_g integer, --/D Bitwise mask set if the central pixel from all images satisfy each condition in g (see the DR8 bitmasks page) 
    allmask_r integer, --/D Bitwise mask set if the central pixel from all images satisfy each condition in r (see the DR8 bitmasks page) 
    allmask_z integer, --/D Bitwise mask set if the central pixel from all images satisfy each condition in z (see the DR8 bitmasks page) 
    wisemask_w1 smallint, --/D W1 bitmask as cataloged on the DR8 bitmasks page 
    wisemask_w2 smallint, --/D W2 bitmask as cataloged on the DR8 bitmasks page 
    psfsize_g real, --/U arcsec --/D Weighted average PSF FWHM in the g band 
    psfsize_r real, --/U arcsec --/D Weighted average PSF FWHM in the r band 
    psfsize_z real, --/U arcsec --/D Weighted average PSF FWHM in the z band 
    psfdepth_g real, --/U 1/nanomaggies^2 --/D For a 5σ point source detection limit in g, 5/sqrt(PSFDEPTH_G) gives flux in nanomaggies and -2.5(log10(5/sqrt(PSFDEPTH_G))-9) give corresponding magnitude 
    psfdepth_r real, --/U 1/nanomaggies^2 --/D For a 5σ point source detection limit in g, 5/sqrt(PSFDEPTH_R) gives flux in nanomaggies and -2.5(log10(5/sqrt(PSFDEPTH_R))-9) give corresponding magnitude 
    psfdepth_z real, --/U 1/nanomaggies^2 --/D For a 5σ point source detection limit in g, 5/sqrt(PSFDEPTH_Z) gives flux in nanomaggies and -2.5(log10(5/sqrt(PSFDEPTH_Z))-9) give corresponding magnitude 
    galdepth_g real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_G but for a galaxy (0.45" exp, round) detection sensitivity 
    galdepth_r real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_R but for a galaxy (0.45" exp, round) detection sensitivity 
    galdepth_z real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_Z but for a galaxy (0.45" exp, round) detection sensitivity 
    psfdepth_w1 real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_G (and also on the AB system) but for WISE W1 
    psfdepth_w2 real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_G (and also on the AB system) but for WISE W2 
    wise_coadd_id text, --/D unWISE coadd file name for the center of each object 
    fracdev real, --/D Fraction of model in deVauc (in range 0..1) 
    fracdev_ivar real, --/D Inverse variance of FRACDEV 
    shapedev_r real, --/U arcsec --/D Half-light radius of deVaucouleurs model (>0) 
    shapedev_r_ivar real, --/U 1/arcsec --/D Inverse variance of SHAPEDEV_R 
    shapedev_e1 real, --/D Ellipticity component 1 
    shapedev_e1_ivar real, --/D Inverse variance of SHAPEDEV_E1 
    shapedev_e2 real, --/D Ellipticity component 2 
    shapedev_e2_ivar real, --/D Inverse variance of SHAPEDEV_E2 
    shapeexp_r real, --/U acrsec --/D Half-light radius of exponential model (>0) 
    shapeexp_r_ivar real, --/U 1/arcsec --/D Inverse variance of SHAPEEXP_R 
    shapeexp_e1 real, --/D Ellipticity component 1 
    shapeexp_e1_ivar real, --/D Inverse variance of SHAPEEXP_E1 
    shapeexp_e2 real, --/D Ellipticity component 2 
    shapeexp_e2_ivar real, --/D Inverse variance of SHAPEEXP_E2 
    fiberflux_g real, --/U nanomaggies --/D Predicted g-band flux within a fiber of diameter 1.5 arcsec from this object in 1 arcsec Gaussian seeing 
    fiberflux_r real, --/U nanomaggies --/D Predicted r-band flux within a fiber of diameter 1.5 arcsec from this object in 1 arcsec Gaussian seeing 
    fiberflux_z real, --/U nanomaggies --/D Predicted z-band flux within a fiber of diameter 1.5 arcsec from this object in 1 arcsec Gaussian seeing 
    fibertotflux_g real, --/U nanomaggies --/D Predicted g-band flux within a fiber of diameter 1.5 arcsec from all sources at this location in 1 arcsec Gaussian seeing 
    fibertotflux_r real, --/U nanomaggies --/D Predicted r-band flux within a fiber of diameter 1.5 arcsec from all sources at this location in 1 arcsec Gaussian seeing 
    fibertotflux_z real, --/U nanomaggies --/D Predicted z-band flux within a fiber of diameter 1.5 arcsec from all sources at this location in 1 arcsec Gaussian seeing 
    ref_cat text, --/D Reference catalog source for this star: "T2" for Tycho-2, "G2" for Gaia DR2, "L2" for the SGA, empty otherwise 
    ref_id bigint, --/D Reference catalog identifier for this star; Tyc1*1,000,000+Tyc2*10+Tyc3 for Tycho2; "sourceid" for Gaia-DR2 and SGA 
    ref_epoch real, --/U yr --/D Reference catalog reference epoch (eg, 2015.5 for Gaia DR2) 
    gaia_phot_g_mean_mag real, --/U mag --/D Gaia G band magnitude, Vega 
    gaia_phot_g_mean_flux_over_error real, --/D Gaia G band magnitude signal-to-noise 
    gaia_phot_bp_mean_mag real, --/U mag --/D Gaia BP band magnitude, Vega 
    gaia_phot_bp_mean_flux_over_error real, --/D Gaia BP band magnitude signal-to-noise 
    gaia_phot_rp_mean_mag real, --/U mag --/D Gaia RP band magnitude, Vega 
    gaia_phot_rp_mean_flux_over_error real, --/D Gaia RP band magnitude signal-to-noise 
    gaia_astrometric_excess_noise real, --/D Gaia astrometric excess noise 
    gaia_duplicated_source boolean, --/D Gaia duplicated source flag (1/0 for True/False) 
    gaia_phot_bp_rp_excess_factor real, --/D Gaia BP/RP excess factor 
    gaia_astrometric_sigma5d_max real, --/U mas --/D Gaia longest semi-major axis of the 5-d error ellipsoid 
    gaia_astrometric_params_solved smallint, --/D Which astrometric parameters were estimated for a Gaia source 
    parallax real, --/U mas --/D Reference catalog parallax 
    parallax_ivar real, --/U 1/mas^2 --/D Reference catalog inverse-variance on parallax 
    pmra real, --/U mas/yr --/D Reference catalog proper motion in the RA direction 
    pmra_ivar real, --/U 1/(mas/yr)^2 --/D Reference catalog inverse-variance on pmra 
    pmdec real, --/U mas/yr --/D Reference catalog proper motion in the Dec direction 
    pmdec_ivar real, --/U 1/(mas/yr)^2 --/D Reference catalog inverse-variance on pmdec 
    maskbits integer, --/D Bitwise mask indicating that an object touches a pixel in the coadd/*/*/*maskbits* maps (see the DR8 bitmasks page) 
    ls_id bigint NOT NULL, --/D Added by SDSS-V: Derived unique object identifier. Computed as follows: ls_id = objid + (brickid << 16) + (release << 40)  
    tycho_ref bigint, --/D Added by SDSS-V: TychoII identifier (equal to ref_id when ref_cat = "T2") 
    gaia_sourceid bigint --/D Added by SDSS-V: Gaia DR2 source_id identifier (equal to ref_id when ref_cat = "G2") 
);



--
-- Name: dr19_magnitude; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_magnitude (
----------------------------------------------------------------------
--/H This table stores magnitude information for a target. Optical magnitudes that are not selected from SDSS photometry have been converted to the SDSS system.
----------------------------------------------------------------------
    carton_to_target_pk bigint, --/D The primary key of the target in the dr19_carton_to_target table.
    magnitude_pk bigint NOT NULL,
    g real, --/U mag --/D The optical g magnitude, AB. 
    r real, --/U mag --/D The optical r magnitude, AB. 
    i real, --/U mag --/D The optical i magnitude, AB. 
    h real, --/U mag --/D The IR H magnitude, Vega. 
    bp real, --/U mag --/D The Gaia BP magnitude, Vega. 
    rp real, --/U mag --/D The Gaia RP magnitude, Vega. 
    z real, --/U mag --/D The optical z magnitude, AB. 
    j real, --/U mag --/D The IR J magnitude, Vega. 
    k real, --/U mag --/D The IR K magnitude, Vega. 
    gaia_g real, --/U mag --/D The Gaia G magnitude, Vega. 
    optical_prov text --/D The providence/origin of the optical magnitudes.
);



--
-- Name: dr19_mangadapall; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_mangadapall (
----------------------------------------------------------------------
--/H Final summary file of the MaNGA Data Analysis Pipeline (DAP).
----------------------------------------------------------------------
    plate integer, --/D Plate number 
    ifudesign integer, --/D IFU design number 
    plateifu character varying(32), --/D String combination of PLATE-IFU to ease searching 
    mangaid character varying(16), --/D MaNGA ID string 
    drpallindx integer, --/D Row index of the observation in the DRPall file 
    mode character varying(16), --/D 3D mode of the DRP file (CUBE or RSS) 
    daptype character varying(32), --/D Keyword of the analysis approach used (e.g., HYB10-GAU-MILESHC) 
    dapdone bit(1), --/D Flag that MAPS file successfully produced 
    objra double precision, --/U deg --/D RA of the galaxy center 
    objdec double precision, --/U deg --/D Declination of the galaxy center 
    ifura double precision, --/U deg --/D RA of the IFU pointing center (generally the same as OBJRA) 
    ifudec double precision, --/U deg --/D Declination of the IFU pointing center (generally the same as OBJDEC) 
    mngtarg1 integer, --/D Main survey targeting bit 
    mngtarg2 integer, --/D Non-galaxy targeting bit 
    mngtarg3 integer, --/D Ancillary targeting bit 
    z real, --/D Redshift used to set initial guess velocity (typically identical to NSA_Z) 
    ldist_z real, --/U h^{-1} Mpc --/D Luminosity distance based on Z and a standard cosmology 
    adist_z real, --/U h^{-1} Mpc --/D Angular-diameter distance based on Z and a standard cosmology 
    nsa_z real, --/D Redshift from the NASA-Sloan Atlas 
    nsa_zdist real, --/D NSA distance estimate using pecular velocity model of Willick et al. (1997); multiply by c/H0 for Mpc. 
    ldist_nsa_z real, --/U h^{-1} Mpc --/D Luminosity distance based on NSA_Z and a standard cosmology 
    adist_nsa_z real, --/U h^{-1} Mpc --/D Angular-diameter distance based on NSA_Z and a standard cosmology 
    nsa_elpetro_ba real, --/D NSA isophotal axial ratio from elliptical Petrosian analysis 
    nsa_elpetro_phi real, --/U deg --/D NSA isophotal position angle from elliptical Petrosian analysis 
    nsa_elpetro_th50_r real, --/U arcsec --/D NSA elliptical Petrosian effective radius in the r-band; the is the same as R_{e} below. 
    nsa_sersic_ba real, --/D NSA isophotal axial ratio from Sersic fit 
    nsa_sersic_phi real, --/U deg --/D NSA isophotal position angle from Sersic fit 
    nsa_sersic_th50 real, --/U arcsec --/D NSA effective radius from the Sersic fit 
    nsa_sersic_n real, --/D NSA Sersic index 
    versdrp2 character varying(16), --/D Version of DRP used for 2d reductions 
    versdrp3 character varying(16), --/D Version of DRP used for 3d reductions 
    verscore character varying(16), --/D Version of mangacore used by the DAP 
    versutil character varying(16), --/D Version of idlutils used by the DAP 
    versdap character varying(16), --/D Version of mangadap 
    drp3qual integer, --/D DRP 3D quality bit 
    dapqual integer, --/D DAP quality bit 
    rdxqakey character varying(32), --/D Configuration keyword for the method used to assess the reduced data 
    binkey character varying(32), --/D Configuration keyword for the spatial binning method 
    sckey character varying(32), --/D Configuration keyword for the method used to model the stellar-continuum 
    elmkey character varying(32), --/D Configuration keyword that defines the emission-line moment measurement method 
    elfkey character varying(32), --/D Configuration keyword that defines the emission-line modeling method 
    sikey character varying(32), --/D Configuration keyword that defines the spectral-index measurement method 
    bintype character varying(16), --/D Type of binning used 
    binsnr real, --/D Target for bin S/N, if Voronoi binning 
    tplkey character varying(32), --/D The identifier of the template library, e.g., MILES. 
    datedap character varying(12), --/D Date the DAP file was created and/or last modified. 
    dapbins integer, --/D The number of "binned" spectra analyzed by the DAP. 
    rcov90 real, --/U arcsec --/D Semi-major axis radius (R) below which spaxels cover at least 90% of elliptical annuli with width R +/- 2.5 arcsec. This should be independent of the DAPTYPE. 
    snr_med_g real, --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}. This should be independent of the DAPTYPE. Measurements specifically for g. 
    snr_med_r real, --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}. This should be independent of the DAPTYPE. Measurements specifically for r. 
    snr_med_i real, --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}. This should be independent of the DAPTYPE. Measurements specifically for i. 
    snr_med_z real, --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}. This should be independent of the DAPTYPE. Measurements specifically for z. 
    snr_ring_g real, --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}. This should be independent of the DAPTYPE. Measurements specifically for g. 
    snr_ring_r real, --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}. This should be independent of the DAPTYPE. Measurements specifically for r. 
    snr_ring_i real, --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}. This should be independent of the DAPTYPE. Measurements specifically for i. 
    snr_ring_z real, --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}. This should be independent of the DAPTYPE. Measurements specifically for z. 
    sb_1re real, --/U 10^{-17} erg/s/cm^{2}/angstrom/spaxel --/D Mean g-band surface brightness of valid spaxels within 1 R_e}. This should be independent of the DAPTYPE. 
    bin_rmax real, --/U R_{e} --/D Maximum g-band luminosity-weighted semi-major radius of any "valid" binned spectrum. 
    bin_r_n_05 real, --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}. Measurements specifically for 05. 
    bin_r_n_10 real, --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}. Measurements specifically for 10. 
    bin_r_n_20 real, --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}. Measurements specifically for 20. 
    bin_r_snr_05 real, --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}. Measurements specifically for 05. 
    bin_r_snr_10 real, --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}. Measurements specifically for 10. 
    bin_r_snr_20 real, --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}. Measurements specifically for 20. 
    stellar_z real, --/D Flux-weighted mean redshift of the stellar component within a 2.5 arcsec aperture at the galaxy center. 
    stellar_vel_lo real, --/U km/s --/D Stellar velocity at 2.5% growth of all valid spaxels. 
    stellar_vel_hi real, --/U km/s --/D Stellar velocity at 97.5% growth of all valid spaxels. 
    stellar_vel_lo_clip real, --/U km/s --/D Stellar velocity at 2.5% growth after iteratively clipping 3-sigma outliers. 
    stellar_vel_hi_clip real, --/U km/s --/D Stellar velocity at 97.5% growth after iteratively clipping 3-sigma outliers. 
    stellar_sigma_1re real, --/U km/s --/D Flux-weighted mean stellar velocity dispersion of all spaxels within 1 R_{e}. 
    stellar_rchi2_1re real, --/D Median reduced chi^{2} of the stellar-continuum fit within 1 R_{e}. 
    ha_z real, --/D Flux-weighted mean redshift of the Ha line within a 2.5 arcsec aperture at the galaxy center. 
    ha_gvel_lo real, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 2.5% growth of all valid spaxels. 
    ha_gvel_hi real, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 97.5% growth of all valid spaxels. 
    ha_gvel_lo_clip real, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 2.5% growth after iteratively clipping 3-sigma outliers. 
    ha_gvel_hi_clip real, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 97.5% growth after iteratively clipping 3-sigma outliers. 
    ha_gsigma_1re real, --/U km/s --/D Flux-weighted H-alpha velocity dispersion (from Gaussian fit) of all spaxels within 1 R_{e}. 
    ha_gsigma_hi real, --/U km/s --/D H-alpha velocity dispersion (from Gaussian fit) at 97.5% growth of all valid spaxels. 
    ha_gsigma_hi_clip real, --/U km/s --/D H-alpha velocity dispersion (from Gaussian fit) at 97.5% growth after iteratively clipping 3-sigma outliers. 
    emline_rchi2_1re real, --/D Median reduced chi^{2} of the continuum+emission-line fit within 1 R_{e}. 
    emline_sflux_cen_oiid_3728 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OIId_3728. 
    emline_sflux_cen_oii_3729 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OII_3729. 
    emline_sflux_cen_h12_3751 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for H12_3751. 
    emline_sflux_cen_h11_3771 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for H11_3771. 
    emline_sflux_cen_hthe_3798 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hthe_3798. 
    emline_sflux_cen_heta_3836 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Heta_3836. 
    emline_sflux_cen_neiii_3869 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NeIII_3869. 
    emline_sflux_cen_hei_3889 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for HeI_3889. 
    emline_sflux_cen_hzet_3890 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hzet_3890. 
    emline_sflux_cen_neiii_3968 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NeIII_3968. 
    emline_sflux_cen_heps_3971 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Heps_3971. 
    emline_sflux_cen_hdel_4102 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hdel_4102. 
    emline_sflux_cen_hgam_4341 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hgam_4341. 
    emline_sflux_cen_heii_4687 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for HeII_4687. 
    emline_sflux_cen_hb_4862 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hb_4862. 
    emline_sflux_cen_oiii_4960 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OIII_4960. 
    emline_sflux_cen_oiii_5008 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OIII_5008. 
    emline_sflux_cen_ni_5199 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NI_5199. 
    emline_sflux_cen_ni_5201 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NI_5201. 
    emline_sflux_cen_hei_5877 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for HeI_5877. 
    emline_sflux_cen_oi_6302 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OI_6302. 
    emline_sflux_cen_oi_6365 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OI_6365. 
    emline_sflux_cen_nii_6549 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NII_6549. 
    emline_sflux_cen_ha_6564 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Ha_6564. 
    emline_sflux_cen_nii_6585 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NII_6585. 
    emline_sflux_cen_sii_6718 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for SII_6718. 
    emline_sflux_cen_sii_6732 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for SII_6732. 
    emline_sflux_cen_hei_7067 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for HeI_7067. 
    emline_sflux_cen_ariii_7137 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for ArIII_7137. 
    emline_sflux_cen_ariii_7753 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for ArIII_7753. 
    emline_sflux_cen_peta_9017 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Peta_9017. 
    emline_sflux_cen_siii_9071 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for SIII_9071. 
    emline_sflux_cen_pzet_9231 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Pzet_9231. 
    emline_sflux_cen_siii_9533 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for SIII_9533. 
    emline_sflux_cen_peps_9548 real, --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Peps_9548. 
    emline_sflux_1re_oiid_3728 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OIId_3728. 
    emline_sflux_1re_oii_3729 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OII_3729. 
    emline_sflux_1re_h12_3751 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for H12_3751. 
    emline_sflux_1re_h11_3771 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for H11_3771. 
    emline_sflux_1re_hthe_3798 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hthe_3798. 
    emline_sflux_1re_heta_3836 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Heta_3836. 
    emline_sflux_1re_neiii_3869 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NeIII_3869. 
    emline_sflux_1re_hei_3889 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for HeI_3889. 
    emline_sflux_1re_hzet_3890 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hzet_3890. 
    emline_sflux_1re_neiii_3968 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NeIII_3968. 
    emline_sflux_1re_heps_3971 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Heps_3971. 
    emline_sflux_1re_hdel_4102 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hdel_4102. 
    emline_sflux_1re_hgam_4341 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hgam_4341. 
    emline_sflux_1re_heii_4687 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for HeII_4687. 
    emline_sflux_1re_hb_4862 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hb_4862. 
    emline_sflux_1re_oiii_4960 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OIII_4960. 
    emline_sflux_1re_oiii_5008 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OIII_5008. 
    emline_sflux_1re_ni_5199 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NI_5199. 
    emline_sflux_1re_ni_5201 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NI_5201. 
    emline_sflux_1re_hei_5877 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for HeI_5877. 
    emline_sflux_1re_oi_6302 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OI_6302. 
    emline_sflux_1re_oi_6365 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OI_6365. 
    emline_sflux_1re_nii_6549 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NII_6549. 
    emline_sflux_1re_ha_6564 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Ha_6564. 
    emline_sflux_1re_nii_6585 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NII_6585. 
    emline_sflux_1re_sii_6718 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for SII_6718. 
    emline_sflux_1re_sii_6732 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for SII_6732. 
    emline_sflux_1re_hei_7067 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for HeI_7067. 
    emline_sflux_1re_ariii_7137 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for ArIII_7137. 
    emline_sflux_1re_ariii_7753 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for ArIII_7753. 
    emline_sflux_1re_peta_9017 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Peta_9017. 
    emline_sflux_1re_siii_9071 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for SIII_9071. 
    emline_sflux_1re_pzet_9231 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Pzet_9231. 
    emline_sflux_1re_siii_9533 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for SIII_9533. 
    emline_sflux_1re_peps_9548 real, --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Peps_9548. 
    emline_sflux_tot_oiid_3728 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for OIId_3728. 
    emline_sflux_tot_oii_3729 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for OII_3729. 
    emline_sflux_tot_h12_3751 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for H12_3751. 
    emline_sflux_tot_h11_3771 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for H11_3771. 
    emline_sflux_tot_hthe_3798 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Hthe_3798. 
    emline_sflux_tot_heta_3836 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Heta_3836. 
    emline_sflux_tot_neiii_3869 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for NeIII_3869. 
    emline_sflux_tot_hei_3889 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for HeI_3889. 
    emline_sflux_tot_hzet_3890 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Hzet_3890. 
    emline_sflux_tot_neiii_3968 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for NeIII_3968. 
    emline_sflux_tot_heps_3971 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Heps_3971. 
    emline_sflux_tot_hdel_4102 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Hdel_4102. 
    emline_sflux_tot_hgam_4341 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Hgam_4341. 
    emline_sflux_tot_heii_4687 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for HeII_4687. 
    emline_sflux_tot_hb_4862 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Hb_4862. 
    emline_sflux_tot_oiii_4960 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for OIII_4960. 
    emline_sflux_tot_oiii_5008 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for OIII_5008. 
    emline_sflux_tot_ni_5199 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for NI_5199. 
    emline_sflux_tot_ni_5201 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for NI_5201. 
    emline_sflux_tot_hei_5877 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for HeI_5877. 
    emline_sflux_tot_oi_6302 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for OI_6302. 
    emline_sflux_tot_oi_6365 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for OI_6365. 
    emline_sflux_tot_nii_6549 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for NII_6549. 
    emline_sflux_tot_ha_6564 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Ha_6564. 
    emline_sflux_tot_nii_6585 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for NII_6585. 
    emline_sflux_tot_sii_6718 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for SII_6718. 
    emline_sflux_tot_sii_6732 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for SII_6732. 
    emline_sflux_tot_hei_7067 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for HeI_7067. 
    emline_sflux_tot_ariii_7137 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for ArIII_7137. 
    emline_sflux_tot_ariii_7753 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for ArIII_7753. 
    emline_sflux_tot_peta_9017 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Peta_9017. 
    emline_sflux_tot_siii_9071 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for SIII_9071. 
    emline_sflux_tot_pzet_9231 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Pzet_9231. 
    emline_sflux_tot_siii_9533 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for SIII_9533. 
    emline_sflux_tot_peps_9548 real, --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view. Measurements specifically for Peps_9548. 
    emline_ssb_1re_oiid_3728 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for OIId_3728. 
    emline_ssb_1re_oii_3729 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for OII_3729. 
    emline_ssb_1re_h12_3751 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for H12_3751. 
    emline_ssb_1re_h11_3771 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for H11_3771. 
    emline_ssb_1re_hthe_3798 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Hthe_3798. 
    emline_ssb_1re_heta_3836 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Heta_3836. 
    emline_ssb_1re_neiii_3869 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for NeIII_3869. 
    emline_ssb_1re_hei_3889 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for HeI_3889. 
    emline_ssb_1re_hzet_3890 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Hzet_3890. 
    emline_ssb_1re_neiii_3968 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for NeIII_3968. 
    emline_ssb_1re_heps_3971 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Heps_3971. 
    emline_ssb_1re_hdel_4102 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Hdel_4102. 
    emline_ssb_1re_hgam_4341 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Hgam_4341. 
    emline_ssb_1re_heii_4687 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for HeII_4687. 
    emline_ssb_1re_hb_4862 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Hb_4862. 
    emline_ssb_1re_oiii_4960 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for OIII_4960. 
    emline_ssb_1re_oiii_5008 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for OIII_5008. 
    emline_ssb_1re_ni_5199 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for NI_5199. 
    emline_ssb_1re_ni_5201 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for NI_5201. 
    emline_ssb_1re_hei_5877 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for HeI_5877. 
    emline_ssb_1re_oi_6302 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for OI_6302. 
    emline_ssb_1re_oi_6365 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for OI_6365. 
    emline_ssb_1re_nii_6549 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for NII_6549. 
    emline_ssb_1re_ha_6564 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Ha_6564. 
    emline_ssb_1re_nii_6585 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for NII_6585. 
    emline_ssb_1re_sii_6718 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for SII_6718. 
    emline_ssb_1re_sii_6732 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for SII_6732. 
    emline_ssb_1re_hei_7067 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for HeI_7067. 
    emline_ssb_1re_ariii_7137 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for ArIII_7137. 
    emline_ssb_1re_ariii_7753 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for ArIII_7753. 
    emline_ssb_1re_peta_9017 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Peta_9017. 
    emline_ssb_1re_siii_9071 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for SIII_9071. 
    emline_ssb_1re_pzet_9231 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Pzet_9231. 
    emline_ssb_1re_siii_9533 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for SIII_9533. 
    emline_ssb_1re_peps_9548 real, --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}. Measurements specifically for Peps_9548. 
    emline_ssb_peak_oiid_3728 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for OIId_3728. 
    emline_ssb_peak_oii_3729 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for OII_3729. 
    emline_ssb_peak_h12_3751 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for H12_3751. 
    emline_ssb_peak_h11_3771 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for H11_3771. 
    emline_ssb_peak_hthe_3798 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Hthe_3798. 
    emline_ssb_peak_heta_3836 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Heta_3836. 
    emline_ssb_peak_neiii_3869 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for NeIII_3869. 
    emline_ssb_peak_hei_3889 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for HeI_3889. 
    emline_ssb_peak_hzet_3890 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Hzet_3890. 
    emline_ssb_peak_neiii_3968 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for NeIII_3968. 
    emline_ssb_peak_heps_3971 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Heps_3971. 
    emline_ssb_peak_hdel_4102 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Hdel_4102. 
    emline_ssb_peak_hgam_4341 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Hgam_4341. 
    emline_ssb_peak_heii_4687 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for HeII_4687. 
    emline_ssb_peak_hb_4862 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Hb_4862. 
    emline_ssb_peak_oiii_4960 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for OIII_4960. 
    emline_ssb_peak_oiii_5008 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for OIII_5008. 
    emline_ssb_peak_ni_5199 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for NI_5199. 
    emline_ssb_peak_ni_5201 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for NI_5201. 
    emline_ssb_peak_hei_5877 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for HeI_5877. 
    emline_ssb_peak_oi_6302 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for OI_6302. 
    emline_ssb_peak_oi_6365 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for OI_6365. 
    emline_ssb_peak_nii_6549 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for NII_6549. 
    emline_ssb_peak_ha_6564 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Ha_6564. 
    emline_ssb_peak_nii_6585 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for NII_6585. 
    emline_ssb_peak_sii_6718 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for SII_6718. 
    emline_ssb_peak_sii_6732 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for SII_6732. 
    emline_ssb_peak_hei_7067 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for HeI_7067. 
    emline_ssb_peak_ariii_7137 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for ArIII_7137. 
    emline_ssb_peak_ariii_7753 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for ArIII_7753. 
    emline_ssb_peak_peta_9017 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Peta_9017. 
    emline_ssb_peak_siii_9071 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for SIII_9071. 
    emline_ssb_peak_pzet_9231 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Pzet_9231. 
    emline_ssb_peak_siii_9533 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for SIII_9533. 
    emline_ssb_peak_peps_9548 real, --/D Peak summed-flux emission-line surface brightness. Measurements specifically for Peps_9548. 
    emline_sew_1re_oiid_3728 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for OIId_3728. 
    emline_sew_1re_oii_3729 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for OII_3729. 
    emline_sew_1re_h12_3751 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for H12_3751. 
    emline_sew_1re_h11_3771 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for H11_3771. 
    emline_sew_1re_hthe_3798 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Hthe_3798. 
    emline_sew_1re_heta_3836 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Heta_3836. 
    emline_sew_1re_neiii_3869 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for NeIII_3869. 
    emline_sew_1re_hei_3889 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for HeI_3889. 
    emline_sew_1re_hzet_3890 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Hzet_3890. 
    emline_sew_1re_neiii_3968 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for NeIII_3968. 
    emline_sew_1re_heps_3971 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Heps_3971. 
    emline_sew_1re_hdel_4102 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Hdel_4102. 
    emline_sew_1re_hgam_4341 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Hgam_4341. 
    emline_sew_1re_heii_4687 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for HeII_4687. 
    emline_sew_1re_hb_4862 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Hb_4862. 
    emline_sew_1re_oiii_4960 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for OIII_4960. 
    emline_sew_1re_oiii_5008 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for OIII_5008. 
    emline_sew_1re_ni_5199 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for NI_5199. 
    emline_sew_1re_ni_5201 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for NI_5201. 
    emline_sew_1re_hei_5877 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for HeI_5877. 
    emline_sew_1re_oi_6302 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for OI_6302. 
    emline_sew_1re_oi_6365 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for OI_6365. 
    emline_sew_1re_nii_6549 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for NII_6549. 
    emline_sew_1re_ha_6564 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Ha_6564. 
    emline_sew_1re_nii_6585 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for NII_6585. 
    emline_sew_1re_sii_6718 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for SII_6718. 
    emline_sew_1re_sii_6732 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for SII_6732. 
    emline_sew_1re_hei_7067 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for HeI_7067. 
    emline_sew_1re_ariii_7137 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for ArIII_7137. 
    emline_sew_1re_ariii_7753 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for ArIII_7753. 
    emline_sew_1re_peta_9017 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Peta_9017. 
    emline_sew_1re_siii_9071 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for SIII_9071. 
    emline_sew_1re_pzet_9231 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Pzet_9231. 
    emline_sew_1re_siii_9533 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for SIII_9533. 
    emline_sew_1re_peps_9548 real, --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}. Measurements specifically for Peps_9548. 
    emline_sew_peak_oiid_3728 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for OIId_3728. 
    emline_sew_peak_oii_3729 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for OII_3729. 
    emline_sew_peak_h12_3751 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for H12_3751. 
    emline_sew_peak_h11_3771 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for H11_3771. 
    emline_sew_peak_hthe_3798 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Hthe_3798. 
    emline_sew_peak_heta_3836 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Heta_3836. 
    emline_sew_peak_neiii_3869 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for NeIII_3869. 
    emline_sew_peak_hei_3889 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for HeI_3889. 
    emline_sew_peak_hzet_3890 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Hzet_3890. 
    emline_sew_peak_neiii_3968 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for NeIII_3968. 
    emline_sew_peak_heps_3971 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Heps_3971. 
    emline_sew_peak_hdel_4102 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Hdel_4102. 
    emline_sew_peak_hgam_4341 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Hgam_4341. 
    emline_sew_peak_heii_4687 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for HeII_4687. 
    emline_sew_peak_hb_4862 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Hb_4862. 
    emline_sew_peak_oiii_4960 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for OIII_4960. 
    emline_sew_peak_oiii_5008 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for OIII_5008. 
    emline_sew_peak_ni_5199 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for NI_5199. 
    emline_sew_peak_ni_5201 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for NI_5201. 
    emline_sew_peak_hei_5877 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for HeI_5877. 
    emline_sew_peak_oi_6302 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for OI_6302. 
    emline_sew_peak_oi_6365 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for OI_6365. 
    emline_sew_peak_nii_6549 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for NII_6549. 
    emline_sew_peak_ha_6564 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Ha_6564. 
    emline_sew_peak_nii_6585 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for NII_6585. 
    emline_sew_peak_sii_6718 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for SII_6718. 
    emline_sew_peak_sii_6732 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for SII_6732. 
    emline_sew_peak_hei_7067 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for HeI_7067. 
    emline_sew_peak_ariii_7137 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for ArIII_7137. 
    emline_sew_peak_ariii_7753 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for ArIII_7753. 
    emline_sew_peak_peta_9017 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Peta_9017. 
    emline_sew_peak_siii_9071 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for SIII_9071. 
    emline_sew_peak_pzet_9231 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Pzet_9231. 
    emline_sew_peak_siii_9533 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for SIII_9533. 
    emline_sew_peak_peps_9548 real, --/D Peak summed-flux emission-line equivalent width. Measurements specifically for Peps_9548. 
    emline_gflux_cen_oii_3727 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OII_3727. 
    emline_gflux_cen_oii_3729 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OII_3729. 
    emline_gflux_cen_h12_3751 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for H12_3751. 
    emline_gflux_cen_h11_3771 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for H11_3771. 
    emline_gflux_cen_hthe_3798 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hthe_3798. 
    emline_gflux_cen_heta_3836 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Heta_3836. 
    emline_gflux_cen_neiii_3869 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NeIII_3869. 
    emline_gflux_cen_hei_3889 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for HeI_3889. 
    emline_gflux_cen_hzet_3890 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hzet_3890. 
    emline_gflux_cen_neiii_3968 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NeIII_3968. 
    emline_gflux_cen_heps_3971 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Heps_3971. 
    emline_gflux_cen_hdel_4102 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hdel_4102. 
    emline_gflux_cen_hgam_4341 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hgam_4341. 
    emline_gflux_cen_heii_4687 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for HeII_4687. 
    emline_gflux_cen_hb_4862 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Hb_4862. 
    emline_gflux_cen_oiii_4960 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OIII_4960. 
    emline_gflux_cen_oiii_5008 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OIII_5008. 
    emline_gflux_cen_ni_5199 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NI_5199. 
    emline_gflux_cen_ni_5201 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NI_5201. 
    emline_gflux_cen_hei_5877 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for HeI_5877. 
    emline_gflux_cen_oi_6302 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OI_6302. 
    emline_gflux_cen_oi_6365 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for OI_6365. 
    emline_gflux_cen_nii_6549 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NII_6549. 
    emline_gflux_cen_ha_6564 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Ha_6564. 
    emline_gflux_cen_nii_6585 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for NII_6585. 
    emline_gflux_cen_sii_6718 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for SII_6718. 
    emline_gflux_cen_sii_6732 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for SII_6732. 
    emline_gflux_cen_hei_7067 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for HeI_7067. 
    emline_gflux_cen_ariii_7137 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for ArIII_7137. 
    emline_gflux_cen_ariii_7753 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for ArIII_7753. 
    emline_gflux_cen_peta_9017 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Peta_9017. 
    emline_gflux_cen_siii_9071 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for SIII_9071. 
    emline_gflux_cen_pzet_9231 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Pzet_9231. 
    emline_gflux_cen_siii_9533 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for SIII_9533. 
    emline_gflux_cen_peps_9548 real, --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center. Measurements specifically for Peps_9548. 
    emline_gflux_1re_oii_3727 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OII_3727. 
    emline_gflux_1re_oii_3729 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OII_3729. 
    emline_gflux_1re_h12_3751 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for H12_3751. 
    emline_gflux_1re_h11_3771 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for H11_3771. 
    emline_gflux_1re_hthe_3798 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hthe_3798. 
    emline_gflux_1re_heta_3836 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Heta_3836. 
    emline_gflux_1re_neiii_3869 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NeIII_3869. 
    emline_gflux_1re_hei_3889 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for HeI_3889. 
    emline_gflux_1re_hzet_3890 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hzet_3890. 
    emline_gflux_1re_neiii_3968 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NeIII_3968. 
    emline_gflux_1re_heps_3971 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Heps_3971. 
    emline_gflux_1re_hdel_4102 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hdel_4102. 
    emline_gflux_1re_hgam_4341 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hgam_4341. 
    emline_gflux_1re_heii_4687 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for HeII_4687. 
    emline_gflux_1re_hb_4862 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Hb_4862. 
    emline_gflux_1re_oiii_4960 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OIII_4960. 
    emline_gflux_1re_oiii_5008 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OIII_5008. 
    emline_gflux_1re_ni_5199 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NI_5199. 
    emline_gflux_1re_ni_5201 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NI_5201. 
    emline_gflux_1re_hei_5877 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for HeI_5877. 
    emline_gflux_1re_oi_6302 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OI_6302. 
    emline_gflux_1re_oi_6365 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for OI_6365. 
    emline_gflux_1re_nii_6549 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NII_6549. 
    emline_gflux_1re_ha_6564 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Ha_6564. 
    emline_gflux_1re_nii_6585 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for NII_6585. 
    emline_gflux_1re_sii_6718 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for SII_6718. 
    emline_gflux_1re_sii_6732 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for SII_6732. 
    emline_gflux_1re_hei_7067 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for HeI_7067. 
    emline_gflux_1re_ariii_7137 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for ArIII_7137. 
    emline_gflux_1re_ariii_7753 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for ArIII_7753. 
    emline_gflux_1re_peta_9017 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Peta_9017. 
    emline_gflux_1re_siii_9071 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for SIII_9071. 
    emline_gflux_1re_pzet_9231 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Pzet_9231. 
    emline_gflux_1re_siii_9533 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for SIII_9533. 
    emline_gflux_1re_peps_9548 real, --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy. Measurements specifically for Peps_9548. 
    emline_gflux_tot_oii_3727 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for OII_3727. 
    emline_gflux_tot_oii_3729 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for OII_3729. 
    emline_gflux_tot_h12_3751 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for H12_3751. 
    emline_gflux_tot_h11_3771 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for H11_3771. 
    emline_gflux_tot_hthe_3798 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Hthe_3798. 
    emline_gflux_tot_heta_3836 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Heta_3836. 
    emline_gflux_tot_neiii_3869 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for NeIII_3869. 
    emline_gflux_tot_hei_3889 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for HeI_3889. 
    emline_gflux_tot_hzet_3890 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Hzet_3890. 
    emline_gflux_tot_neiii_3968 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for NeIII_3968. 
    emline_gflux_tot_heps_3971 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Heps_3971. 
    emline_gflux_tot_hdel_4102 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Hdel_4102. 
    emline_gflux_tot_hgam_4341 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Hgam_4341. 
    emline_gflux_tot_heii_4687 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for HeII_4687. 
    emline_gflux_tot_hb_4862 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Hb_4862. 
    emline_gflux_tot_oiii_4960 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for OIII_4960. 
    emline_gflux_tot_oiii_5008 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for OIII_5008. 
    emline_gflux_tot_ni_5199 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for NI_5199. 
    emline_gflux_tot_ni_5201 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for NI_5201. 
    emline_gflux_tot_hei_5877 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for HeI_5877. 
    emline_gflux_tot_oi_6302 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for OI_6302. 
    emline_gflux_tot_oi_6365 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for OI_6365. 
    emline_gflux_tot_nii_6549 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for NII_6549. 
    emline_gflux_tot_ha_6564 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Ha_6564. 
    emline_gflux_tot_nii_6585 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for NII_6585. 
    emline_gflux_tot_sii_6718 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for SII_6718. 
    emline_gflux_tot_sii_6732 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for SII_6732. 
    emline_gflux_tot_hei_7067 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for HeI_7067. 
    emline_gflux_tot_ariii_7137 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for ArIII_7137. 
    emline_gflux_tot_ariii_7753 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for ArIII_7753. 
    emline_gflux_tot_peta_9017 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Peta_9017. 
    emline_gflux_tot_siii_9071 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for SIII_9071. 
    emline_gflux_tot_pzet_9231 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Pzet_9231. 
    emline_gflux_tot_siii_9533 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for SIII_9533. 
    emline_gflux_tot_peps_9548 real, --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view. Measurements specifically for Peps_9548. 
    emline_gsb_1re_oii_3727 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OII_3727. 
    emline_gsb_1re_oii_3729 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OII_3729. 
    emline_gsb_1re_h12_3751 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for H12_3751. 
    emline_gsb_1re_h11_3771 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for H11_3771. 
    emline_gsb_1re_hthe_3798 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hthe_3798. 
    emline_gsb_1re_heta_3836 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Heta_3836. 
    emline_gsb_1re_neiii_3869 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NeIII_3869. 
    emline_gsb_1re_hei_3889 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for HeI_3889. 
    emline_gsb_1re_hzet_3890 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hzet_3890. 
    emline_gsb_1re_neiii_3968 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NeIII_3968. 
    emline_gsb_1re_heps_3971 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Heps_3971. 
    emline_gsb_1re_hdel_4102 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hdel_4102. 
    emline_gsb_1re_hgam_4341 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hgam_4341. 
    emline_gsb_1re_heii_4687 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for HeII_4687. 
    emline_gsb_1re_hb_4862 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hb_4862. 
    emline_gsb_1re_oiii_4960 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OIII_4960. 
    emline_gsb_1re_oiii_5008 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OIII_5008. 
    emline_gsb_1re_ni_5199 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NI_5199. 
    emline_gsb_1re_ni_5201 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NI_5201. 
    emline_gsb_1re_hei_5877 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for HeI_5877. 
    emline_gsb_1re_oi_6302 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OI_6302. 
    emline_gsb_1re_oi_6365 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OI_6365. 
    emline_gsb_1re_nii_6549 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NII_6549. 
    emline_gsb_1re_ha_6564 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Ha_6564. 
    emline_gsb_1re_nii_6585 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NII_6585. 
    emline_gsb_1re_sii_6718 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for SII_6718. 
    emline_gsb_1re_sii_6732 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for SII_6732. 
    emline_gsb_1re_hei_7067 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for HeI_7067. 
    emline_gsb_1re_ariii_7137 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for ArIII_7137. 
    emline_gsb_1re_ariii_7753 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for ArIII_7753. 
    emline_gsb_1re_peta_9017 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Peta_9017. 
    emline_gsb_1re_siii_9071 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for SIII_9071. 
    emline_gsb_1re_pzet_9231 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Pzet_9231. 
    emline_gsb_1re_siii_9533 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for SIII_9533. 
    emline_gsb_1re_peps_9548 real, --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Peps_9548. 
    emline_gsb_peak_oii_3727 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for OII_3727. 
    emline_gsb_peak_oii_3729 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for OII_3729. 
    emline_gsb_peak_h12_3751 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for H12_3751. 
    emline_gsb_peak_h11_3771 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for H11_3771. 
    emline_gsb_peak_hthe_3798 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Hthe_3798. 
    emline_gsb_peak_heta_3836 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Heta_3836. 
    emline_gsb_peak_neiii_3869 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for NeIII_3869. 
    emline_gsb_peak_hei_3889 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for HeI_3889. 
    emline_gsb_peak_hzet_3890 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Hzet_3890. 
    emline_gsb_peak_neiii_3968 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for NeIII_3968. 
    emline_gsb_peak_heps_3971 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Heps_3971. 
    emline_gsb_peak_hdel_4102 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Hdel_4102. 
    emline_gsb_peak_hgam_4341 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Hgam_4341. 
    emline_gsb_peak_heii_4687 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for HeII_4687. 
    emline_gsb_peak_hb_4862 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Hb_4862. 
    emline_gsb_peak_oiii_4960 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for OIII_4960. 
    emline_gsb_peak_oiii_5008 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for OIII_5008. 
    emline_gsb_peak_ni_5199 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for NI_5199. 
    emline_gsb_peak_ni_5201 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for NI_5201. 
    emline_gsb_peak_hei_5877 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for HeI_5877. 
    emline_gsb_peak_oi_6302 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for OI_6302. 
    emline_gsb_peak_oi_6365 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for OI_6365. 
    emline_gsb_peak_nii_6549 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for NII_6549. 
    emline_gsb_peak_ha_6564 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Ha_6564. 
    emline_gsb_peak_nii_6585 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for NII_6585. 
    emline_gsb_peak_sii_6718 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for SII_6718. 
    emline_gsb_peak_sii_6732 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for SII_6732. 
    emline_gsb_peak_hei_7067 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for HeI_7067. 
    emline_gsb_peak_ariii_7137 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for ArIII_7137. 
    emline_gsb_peak_ariii_7753 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for ArIII_7753. 
    emline_gsb_peak_peta_9017 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Peta_9017. 
    emline_gsb_peak_siii_9071 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for SIII_9071. 
    emline_gsb_peak_pzet_9231 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Pzet_9231. 
    emline_gsb_peak_siii_9533 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for SIII_9533. 
    emline_gsb_peak_peps_9548 real, --/D Peak Gaussian-fitted emission-line surface brightness. Measurements specifically for Peps_9548. 
    emline_gew_1re_oii_3727 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OII_3727. 
    emline_gew_1re_oii_3729 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OII_3729. 
    emline_gew_1re_h12_3751 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for H12_3751. 
    emline_gew_1re_h11_3771 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for H11_3771. 
    emline_gew_1re_hthe_3798 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hthe_3798. 
    emline_gew_1re_heta_3836 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Heta_3836. 
    emline_gew_1re_neiii_3869 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NeIII_3869. 
    emline_gew_1re_hei_3889 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for HeI_3889. 
    emline_gew_1re_hzet_3890 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hzet_3890. 
    emline_gew_1re_neiii_3968 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NeIII_3968. 
    emline_gew_1re_heps_3971 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Heps_3971. 
    emline_gew_1re_hdel_4102 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hdel_4102. 
    emline_gew_1re_hgam_4341 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hgam_4341. 
    emline_gew_1re_heii_4687 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for HeII_4687. 
    emline_gew_1re_hb_4862 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Hb_4862. 
    emline_gew_1re_oiii_4960 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OIII_4960. 
    emline_gew_1re_oiii_5008 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OIII_5008. 
    emline_gew_1re_ni_5199 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NI_5199. 
    emline_gew_1re_ni_5201 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NI_5201. 
    emline_gew_1re_hei_5877 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for HeI_5877. 
    emline_gew_1re_oi_6302 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OI_6302. 
    emline_gew_1re_oi_6365 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for OI_6365. 
    emline_gew_1re_nii_6549 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NII_6549. 
    emline_gew_1re_ha_6564 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Ha_6564. 
    emline_gew_1re_nii_6585 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for NII_6585. 
    emline_gew_1re_sii_6718 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for SII_6718. 
    emline_gew_1re_sii_6732 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for SII_6732. 
    emline_gew_1re_hei_7067 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for HeI_7067. 
    emline_gew_1re_ariii_7137 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for ArIII_7137. 
    emline_gew_1re_ariii_7753 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for ArIII_7753. 
    emline_gew_1re_peta_9017 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Peta_9017. 
    emline_gew_1re_siii_9071 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for SIII_9071. 
    emline_gew_1re_pzet_9231 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Pzet_9231. 
    emline_gew_1re_siii_9533 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for SIII_9533. 
    emline_gew_1re_peps_9548 real, --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}. Measurements specifically for Peps_9548. 
    emline_gew_peak_oii_3727 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for OII_3727. 
    emline_gew_peak_oii_3729 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for OII_3729. 
    emline_gew_peak_h12_3751 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for H12_3751. 
    emline_gew_peak_h11_3771 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for H11_3771. 
    emline_gew_peak_hthe_3798 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Hthe_3798. 
    emline_gew_peak_heta_3836 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Heta_3836. 
    emline_gew_peak_neiii_3869 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for NeIII_3869. 
    emline_gew_peak_hei_3889 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for HeI_3889. 
    emline_gew_peak_hzet_3890 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Hzet_3890. 
    emline_gew_peak_neiii_3968 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for NeIII_3968. 
    emline_gew_peak_heps_3971 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Heps_3971. 
    emline_gew_peak_hdel_4102 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Hdel_4102. 
    emline_gew_peak_hgam_4341 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Hgam_4341. 
    emline_gew_peak_heii_4687 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for HeII_4687. 
    emline_gew_peak_hb_4862 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Hb_4862. 
    emline_gew_peak_oiii_4960 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for OIII_4960. 
    emline_gew_peak_oiii_5008 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for OIII_5008. 
    emline_gew_peak_ni_5199 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for NI_5199. 
    emline_gew_peak_ni_5201 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for NI_5201. 
    emline_gew_peak_hei_5877 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for HeI_5877. 
    emline_gew_peak_oi_6302 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for OI_6302. 
    emline_gew_peak_oi_6365 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for OI_6365. 
    emline_gew_peak_nii_6549 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for NII_6549. 
    emline_gew_peak_ha_6564 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Ha_6564. 
    emline_gew_peak_nii_6585 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for NII_6585. 
    emline_gew_peak_sii_6718 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for SII_6718. 
    emline_gew_peak_sii_6732 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for SII_6732. 
    emline_gew_peak_hei_7067 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for HeI_7067. 
    emline_gew_peak_ariii_7137 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for ArIII_7137. 
    emline_gew_peak_ariii_7753 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for ArIII_7753. 
    emline_gew_peak_peta_9017 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Peta_9017. 
    emline_gew_peak_siii_9071 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for SIII_9071. 
    emline_gew_peak_pzet_9231 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Pzet_9231. 
    emline_gew_peak_siii_9533 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for SIII_9533. 
    emline_gew_peak_peps_9548 real, --/D Peak Gaussian-fitted emission-line equivalent width. Measurements specifically for Peps_9548. 
    specindex_lo_cn1 real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for CN1. 
    specindex_lo_cn2 real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for CN2. 
    specindex_lo_ca4227 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Ca4227. 
    specindex_lo_g4300 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for G4300. 
    specindex_lo_fe4383 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Fe4383. 
    specindex_lo_ca4455 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Ca4455. 
    specindex_lo_fe4531 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Fe4531. 
    specindex_lo_c24668 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for C24668. 
    specindex_lo_hb real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Hb. 
    specindex_lo_fe5015 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Fe5015. 
    specindex_lo_mg1 real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Mg1. 
    specindex_lo_mg2 real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Mg2. 
    specindex_lo_mgb real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Mgb. 
    specindex_lo_fe5270 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Fe5270. 
    specindex_lo_fe5335 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Fe5335. 
    specindex_lo_fe5406 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Fe5406. 
    specindex_lo_fe5709 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Fe5709. 
    specindex_lo_fe5782 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Fe5782. 
    specindex_lo_nad real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for NaD. 
    specindex_lo_tio1 real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for TiO1. 
    specindex_lo_tio2 real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for TiO2. 
    specindex_lo_hdeltaa real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for HDeltaA. 
    specindex_lo_hgammaa real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for HGammaA. 
    specindex_lo_hdeltaf real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for HDeltaF. 
    specindex_lo_hgammaf real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for HGammaF. 
    specindex_lo_cahk real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for CaHK. 
    specindex_lo_caii1 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for CaII1. 
    specindex_lo_caii2 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for CaII2. 
    specindex_lo_caii3 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for CaII3. 
    specindex_lo_pa17 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Pa17. 
    specindex_lo_pa14 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Pa14. 
    specindex_lo_pa12 real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Pa12. 
    specindex_lo_mgicvd real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for MgICvD. 
    specindex_lo_naicvd real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for NaICvD. 
    specindex_lo_mgiir real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for MgIIR. 
    specindex_lo_fehcvd real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for FeHCvD. 
    specindex_lo_nai real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for NaI. 
    specindex_lo_btio real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for bTiO. 
    specindex_lo_atio real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for aTiO. 
    specindex_lo_cah1 real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for CaH1. 
    specindex_lo_cah2 real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for CaH2. 
    specindex_lo_naisdss real, --/U ang --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for NaISDSS. 
    specindex_lo_tio2sdss real, --/U mag --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for TiO2SDSS. 
    specindex_lo_d4000 real, --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for D4000. 
    specindex_lo_dn4000 real, --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for Dn4000. 
    specindex_lo_tiocvd real, --/D Spectral index at 2.5% growth of all valid spaxels. Measurements specifically for TiOCvD. 
    specindex_hi_cn1 real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for CN1. 
    specindex_hi_cn2 real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for CN2. 
    specindex_hi_ca4227 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Ca4227. 
    specindex_hi_g4300 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for G4300. 
    specindex_hi_fe4383 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Fe4383. 
    specindex_hi_ca4455 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Ca4455. 
    specindex_hi_fe4531 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Fe4531. 
    specindex_hi_c24668 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for C24668. 
    specindex_hi_hb real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Hb. 
    specindex_hi_fe5015 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Fe5015. 
    specindex_hi_mg1 real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Mg1. 
    specindex_hi_mg2 real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Mg2. 
    specindex_hi_mgb real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Mgb. 
    specindex_hi_fe5270 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Fe5270. 
    specindex_hi_fe5335 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Fe5335. 
    specindex_hi_fe5406 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Fe5406. 
    specindex_hi_fe5709 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Fe5709. 
    specindex_hi_fe5782 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Fe5782. 
    specindex_hi_nad real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for NaD. 
    specindex_hi_tio1 real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for TiO1. 
    specindex_hi_tio2 real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for TiO2. 
    specindex_hi_hdeltaa real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for HDeltaA. 
    specindex_hi_hgammaa real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for HGammaA. 
    specindex_hi_hdeltaf real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for HDeltaF. 
    specindex_hi_hgammaf real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for HGammaF. 
    specindex_hi_cahk real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for CaHK. 
    specindex_hi_caii1 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for CaII1. 
    specindex_hi_caii2 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for CaII2. 
    specindex_hi_caii3 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for CaII3. 
    specindex_hi_pa17 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Pa17. 
    specindex_hi_pa14 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Pa14. 
    specindex_hi_pa12 real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Pa12. 
    specindex_hi_mgicvd real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for MgICvD. 
    specindex_hi_naicvd real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for NaICvD. 
    specindex_hi_mgiir real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for MgIIR. 
    specindex_hi_fehcvd real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for FeHCvD. 
    specindex_hi_nai real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for NaI. 
    specindex_hi_btio real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for bTiO. 
    specindex_hi_atio real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for aTiO. 
    specindex_hi_cah1 real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for CaH1. 
    specindex_hi_cah2 real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for CaH2. 
    specindex_hi_naisdss real, --/U ang --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for NaISDSS. 
    specindex_hi_tio2sdss real, --/U mag --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for TiO2SDSS. 
    specindex_hi_d4000 real, --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for D4000. 
    specindex_hi_dn4000 real, --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for Dn4000. 
    specindex_hi_tiocvd real, --/D Spectral index at 97.5% growth of all valid spaxels. Measurements specifically for TiOCvD. 
    specindex_lo_clip_cn1 real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CN1. 
    specindex_lo_clip_cn2 real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CN2. 
    specindex_lo_clip_ca4227 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Ca4227. 
    specindex_lo_clip_g4300 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for G4300. 
    specindex_lo_clip_fe4383 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe4383. 
    specindex_lo_clip_ca4455 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Ca4455. 
    specindex_lo_clip_fe4531 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe4531. 
    specindex_lo_clip_c24668 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for C24668. 
    specindex_lo_clip_hb real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Hb. 
    specindex_lo_clip_fe5015 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5015. 
    specindex_lo_clip_mg1 real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Mg1. 
    specindex_lo_clip_mg2 real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Mg2. 
    specindex_lo_clip_mgb real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Mgb. 
    specindex_lo_clip_fe5270 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5270. 
    specindex_lo_clip_fe5335 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5335. 
    specindex_lo_clip_fe5406 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5406. 
    specindex_lo_clip_fe5709 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5709. 
    specindex_lo_clip_fe5782 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5782. 
    specindex_lo_clip_nad real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for NaD. 
    specindex_lo_clip_tio1 real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for TiO1. 
    specindex_lo_clip_tio2 real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for TiO2. 
    specindex_lo_clip_hdeltaa real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for HDeltaA. 
    specindex_lo_clip_hgammaa real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for HGammaA. 
    specindex_lo_clip_hdeltaf real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for HDeltaF. 
    specindex_lo_clip_hgammaf real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for HGammaF. 
    specindex_lo_clip_cahk real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaHK. 
    specindex_lo_clip_caii1 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaII1. 
    specindex_lo_clip_caii2 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaII2. 
    specindex_lo_clip_caii3 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaII3. 
    specindex_lo_clip_pa17 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Pa17. 
    specindex_lo_clip_pa14 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Pa14. 
    specindex_lo_clip_pa12 real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Pa12. 
    specindex_lo_clip_mgicvd real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for MgICvD. 
    specindex_lo_clip_naicvd real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for NaICvD. 
    specindex_lo_clip_mgiir real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for MgIIR. 
    specindex_lo_clip_fehcvd real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for FeHCvD. 
    specindex_lo_clip_nai real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for NaI. 
    specindex_lo_clip_btio real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for bTiO. 
    specindex_lo_clip_atio real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for aTiO. 
    specindex_lo_clip_cah1 real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaH1. 
    specindex_lo_clip_cah2 real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaH2. 
    specindex_lo_clip_naisdss real, --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for NaISDSS. 
    specindex_lo_clip_tio2sdss real, --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for TiO2SDSS. 
    specindex_lo_clip_d4000 real, --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for D4000. 
    specindex_lo_clip_dn4000 real, --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Dn4000. 
    specindex_lo_clip_tiocvd real, --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for TiOCvD. 
    specindex_hi_clip_cn1 real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CN1. 
    specindex_hi_clip_cn2 real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CN2. 
    specindex_hi_clip_ca4227 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Ca4227. 
    specindex_hi_clip_g4300 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for G4300. 
    specindex_hi_clip_fe4383 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe4383. 
    specindex_hi_clip_ca4455 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Ca4455. 
    specindex_hi_clip_fe4531 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe4531. 
    specindex_hi_clip_c24668 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for C24668. 
    specindex_hi_clip_hb real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Hb. 
    specindex_hi_clip_fe5015 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5015. 
    specindex_hi_clip_mg1 real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Mg1. 
    specindex_hi_clip_mg2 real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Mg2. 
    specindex_hi_clip_mgb real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Mgb. 
    specindex_hi_clip_fe5270 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5270. 
    specindex_hi_clip_fe5335 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5335. 
    specindex_hi_clip_fe5406 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5406. 
    specindex_hi_clip_fe5709 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5709. 
    specindex_hi_clip_fe5782 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Fe5782. 
    specindex_hi_clip_nad real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for NaD. 
    specindex_hi_clip_tio1 real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for TiO1. 
    specindex_hi_clip_tio2 real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for TiO2. 
    specindex_hi_clip_hdeltaa real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for HDeltaA. 
    specindex_hi_clip_hgammaa real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for HGammaA. 
    specindex_hi_clip_hdeltaf real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for HDeltaF. 
    specindex_hi_clip_hgammaf real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for HGammaF. 
    specindex_hi_clip_cahk real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaHK. 
    specindex_hi_clip_caii1 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaII1. 
    specindex_hi_clip_caii2 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaII2. 
    specindex_hi_clip_caii3 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaII3. 
    specindex_hi_clip_pa17 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Pa17. 
    specindex_hi_clip_pa14 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Pa14. 
    specindex_hi_clip_pa12 real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Pa12. 
    specindex_hi_clip_mgicvd real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for MgICvD. 
    specindex_hi_clip_naicvd real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for NaICvD. 
    specindex_hi_clip_mgiir real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for MgIIR. 
    specindex_hi_clip_fehcvd real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for FeHCvD. 
    specindex_hi_clip_nai real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for NaI. 
    specindex_hi_clip_btio real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for bTiO. 
    specindex_hi_clip_atio real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for aTiO. 
    specindex_hi_clip_cah1 real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaH1. 
    specindex_hi_clip_cah2 real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for CaH2. 
    specindex_hi_clip_naisdss real, --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for NaISDSS. 
    specindex_hi_clip_tio2sdss real, --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for TiO2SDSS. 
    specindex_hi_clip_d4000 real, --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for D4000. 
    specindex_hi_clip_dn4000 real, --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for Dn4000. 
    specindex_hi_clip_tiocvd real, --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers. Measurements specifically for TiOCvD. 
    specindex_1re_cn1 real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for CN1. 
    specindex_1re_cn2 real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for CN2. 
    specindex_1re_ca4227 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Ca4227. 
    specindex_1re_g4300 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for G4300. 
    specindex_1re_fe4383 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Fe4383. 
    specindex_1re_ca4455 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Ca4455. 
    specindex_1re_fe4531 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Fe4531. 
    specindex_1re_c24668 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for C24668. 
    specindex_1re_hb real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Hb. 
    specindex_1re_fe5015 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Fe5015. 
    specindex_1re_mg1 real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for Mg1. 
    specindex_1re_mg2 real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for Mg2. 
    specindex_1re_mgb real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Mgb. 
    specindex_1re_fe5270 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Fe5270. 
    specindex_1re_fe5335 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Fe5335. 
    specindex_1re_fe5406 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Fe5406. 
    specindex_1re_fe5709 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Fe5709. 
    specindex_1re_fe5782 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Fe5782. 
    specindex_1re_nad real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for NaD. 
    specindex_1re_tio1 real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for TiO1. 
    specindex_1re_tio2 real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for TiO2. 
    specindex_1re_hdeltaa real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for HDeltaA. 
    specindex_1re_hgammaa real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for HGammaA. 
    specindex_1re_hdeltaf real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for HDeltaF. 
    specindex_1re_hgammaf real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for HGammaF. 
    specindex_1re_cahk real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for CaHK. 
    specindex_1re_caii1 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for CaII1. 
    specindex_1re_caii2 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for CaII2. 
    specindex_1re_caii3 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for CaII3. 
    specindex_1re_pa17 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Pa17. 
    specindex_1re_pa14 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Pa14. 
    specindex_1re_pa12 real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for Pa12. 
    specindex_1re_mgicvd real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for MgICvD. 
    specindex_1re_naicvd real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for NaICvD. 
    specindex_1re_mgiir real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for MgIIR. 
    specindex_1re_fehcvd real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for FeHCvD. 
    specindex_1re_nai real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for NaI. 
    specindex_1re_btio real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for bTiO. 
    specindex_1re_atio real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for aTiO. 
    specindex_1re_cah1 real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for CaH1. 
    specindex_1re_cah2 real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for CaH2. 
    specindex_1re_naisdss real, --/U ang --/D Median spectral index within 1 effective radius. Measurements specifically for NaISDSS. 
    specindex_1re_tio2sdss real, --/U mag --/D Median spectral index within 1 effective radius. Measurements specifically for TiO2SDSS. 
    specindex_1re_d4000 real, --/D Median spectral index within 1 effective radius. Measurements specifically for D4000. 
    specindex_1re_dn4000 real, --/D Median spectral index within 1 effective radius. Measurements specifically for Dn4000. 
    specindex_1re_tiocvd real, --/D Median spectral index within 1 effective radius. Measurements specifically for TiOCvD. 
    sfr_1re real, --/U 2012, ARAA, 50, 531], citing Murphy et al. [2011, ApJ, 737, 67] and Hao et al. [2011, ApJ, 741, 124]; Kroupa IMF), where L_{Ha} = 4-Ç EML_FLUX_1RE (LDIST_Z)^{2} and ''no'' attentuation correction has been applied. [h^{-2} M_{sun}/yr --/D Simple estimate of the star-formation rate within 1 effective radius based on the Gaussian-fitted Ha flux; log(SFR) = log L_{Ha} - 41.27 (Kennicutt &amp; Evans 
    sfr_tot real, --/U 2012, ARAA, 50, 531], citing Murphy et al. [2011, ApJ, 737, 67] and Hao et al. [2011, ApJ, 741, 124]; Kroupa IMF), where L_{Ha} = 4-Ç EML_FLUX_TOT (LDIST_Z)^{2} and ''no'' attentuation correction has been applied. [h^{-2} M_{sun}/yr --/D Simple estimate of the star-formation rate within the IFU field-of-view based on the Gaussian-fitted Ha flux; log(SFR) = log L_{Ha} - 41.27 (Kennicutt &amp; Evans 
    htmid bigint, --/D 20-level deep Hierarchical Triangular Mesh ID 
    pk bigint NOT NULL --/D Primary key, a sequential unique identifier 
);



--
-- Name: dr19_mangadrpall; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_mangadrpall (
----------------------------------------------------------------------
--/H Final summary file of the MaNGA Data Reduction Pipeline (DRP).
----------------------------------------------------------------------
    plate integer NOT NULL, --/D Plate ID 
    ifudsgn character varying(40), --/D IFU design id (e.g. 12701) 
    plateifu character varying(40), --/D Plate+ifudesign name for this object (e.g. 7443-12701) 
    mangaid character varying(40) NOT NULL, --/D MaNGA ID for this object (e.g. 1-114145) 
    versdrp2 character varying(40), --/D Version of DRP used for 2d reductions 
    versdrp3 character varying(40), --/D Version of DRP used for 3d reductions 
    verscore character varying(40), --/D Version of mangacore used for reductions 
    versutil character varying(40), --/D Version of idlutils used for reductions 
    versprim character varying(40), --/D Version of mangapreim used for reductions 
    platetyp character varying(40), --/D Plate type (e.g. MANGA, APOGEE-2&amp;MANGA) 
    srvymode character varying(40), --/D Survey mode (e.g. MANGA dither, MANGA stare, APOGEE lead) 
    objra double precision, --/D Right ascension of the science object in J2000 
    objdec double precision, --/U degrees --/D Declination of the science object in J2000 
    ifuglon double precision, --/U degrees --/D Galactic longitude corresponding to IFURA/DEC 
    ifuglat double precision, --/U degrees --/D Galactic latitude corresponding to IFURA/DEC 
    ifura double precision, --/U degrees --/D Right ascension of this IFU in J2000 
    ifudec double precision, --/U degrees --/D Declination of this IFU in J2000 
    ebvgal real, --/U degrees --/D E(B-V) value from SDSS dust routine for this IFUGLON, IFUGLAT 
    nexp integer, --/D Number of science exposures combined 
    exptime real, --/D Total exposure time 
    drp3qual integer, --/U seconds --/D Quality bitmask 
    bluesn2 real, --/D Total blue SN2 across all nexp exposures 
    redsn2 real, --/D Total red SN2 across all nexp exposures 
    harname character varying(60), --/D IFU harness name 
    frlplug integer, --/D Frplug hardware code 
    cartid character varying(40), --/D Cartridge ID number 
    designid integer, --/D Design ID number 
    cenra double precision, --/D Plate center right ascension in J2000 
    cendec double precision, --/U degrees --/D Plate center declination in J2000 
    airmsmin real, --/U degrees --/D Minimum airmass across all exposures 
    airmsmed real, --/D Median airmass across all exposures 
    airmsmax real, --/D Maximum airmass across all exposures 
    seemin real, --/D Best guider seeing 
    seemed real, --/U arcsec --/D Median guider seeing 
    seemax real, --/U arcsec --/D Worst guider seeing 
    transmin real, --/U arcsec --/D Worst transparency 
    transmed real, --/D Median transparency 
    transmax real, --/D Best transparency 
    mjdmin integer, --/D Minimum MJD across all exposures 
    mjdmed integer, --/D Median MJD across all exposures 
    mjdmax integer, --/D Maximum MJD across all exposures 
    gfwhm real, --/D Reconstructed FWHM in g-band 
    rfwhm real, --/U arcsec --/D Reconstructed FWHM in r-band 
    ifwhm real, --/U arcsec --/D Reconstructed FWHM in i-band 
    zfwhm real, --/U arcsec --/D Reconstructed FWHM in z-band 
    mngtarg1 bigint, --/U arcsec --/D Manga-target1 maskbit for galaxy target catalog 
    mngtarg2 bigint, --/D Manga-target2 maskbit for galaxy target catalog 
    mngtarg3 bigint, --/D Manga-target3 maskbit for galaxy target catalog 
    catidnum bigint, --/D Primary target input catalog (leading digits of mangaid) 
    plttarg character varying(40), --/D plateTarget reference file appropriate for this target 
    manga_tileid integer, --/D The ID of the tile to which this object has been allocated 
    nsa_iauname character varying(20), --/D IAU-style designation based on RA/Dec (NSA) 
    ifutargetsize integer, --/D The ideal IFU size for this object. The intended IFU size is equal to IFUTargetSize except if IFUTargetSize &gt; 127 when it is 127, or &lt; 19 when it is 19 
    ifudesignsize integer, --/U fibers --/D The allocated IFU size (0 = "unallocated") 
    ifudesignwrongsize integer, --/U fibers --/D The allocated IFU size if the intended IFU size was not available 
    z real, --/U fibers --/D The targeting redshift (identical to nsa_z for those targets in the NSA Catalog. For others, it is the redshift provided by the Ancillary programs) 
    zmin real, --/D The minimum redshift at which the galaxy could still have been included in the Primary sample 
    zmax real, --/D The maximum redshift at which the galaxy could still have been included in the Primary sample 
    szmin real, --/D The minimum redshift at which the galaxy could still have been included in the Secondary sample 
    szmax real, --/D The maximum redshift at which the galaxy could still have been included in the Secondary sample 
    ezmin real, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample 
    ezmax real, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample 
    probs real, --/D The probability that a Secondary sample galaxy is included after down-sampling. For galaxies not in the Secondary sample PROBS is set to the mean down-sampling probability 
    pweight real, --/D The volume weight for the Primary sample. Corrects the MaNGA selection to a volume limited sample. 
    psweight real, --/D The volume weight for the combined Primary and full Secondary samples. Corrects the MaNGA selection to a volume limited sample. 
    psrweight real, --/D The volume weight for the combined Primary and down-sampled Secondary samples. Corrects the MaNGA selection to a volume limited sample. 
    sweight real, --/D The volume weight for the full Secondary sample. Corrects the MaNGA selection to a volume limited sample. 
    srweight real, --/D The volume weight for the down-sampled Secondary sample. Corrects the MaNGA selection to a volume limited sample. 
    eweight real, --/D The volume weight for the Primary+ sample. Corrects the MaNGA selection to a volume limited sample. 
    esweight real, --/D The volume weight for the combined Primary+ and full Secondary samples. Corrects the MaNGA selection to a volume limited sample. 
    esrweight real, --/D The volume weight for the combined Primary+ and down-sampled Secondary samples. Corrects the MaNGA selection to a volume limited sample. 
    nsa_field integer, --/D SDSS field ID covering the target 
    nsa_run integer, --/D SDSS run ID covering the target 
    nsa_camcol integer, --/D SDSS camcol ID covering the catalog position. 
    nsa_version character varying(10), --/D Version of NSA catalogue used to select these targets 
    nsa_nsaid integer, --/D The NSAID field in the NSA catalogue referenced in nsa_version. 
    nsa_nsaid_v1b integer, --/D The NSAID of the target in the NSA_v1b_0_0_v2 catalogue (if applicable). 
    nsa_z real, --/D Heliocentric redshift (NSA) 
    nsa_zdist real, --/D Distance estimate using peculiar velocity model of Willick et al. (1997), expressed as a redshift equivalent; multiply by c/H0 for Mpc (NSA) 
    nsa_elpetro_mass real, --/D Stellar mass from K-correction fit (use with caution) for elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_f real, --/U solar masses --/D Absolute magnitude in rest-frame GALEX far-UV, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_n real, --/U mag --/D Absolute magnitude in rest-frame GALEX near-UV, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_u real, --/U mag --/D Absolute magnitude in rest-frame SDSS u-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_g real, --/U mag --/D Absolute magnitude in rest-frame SDSS g-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_r real, --/U mag --/D Absolute magnitude in rest-frame SDSS r-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_i real, --/U mag --/D Absolute magnitude in rest-frame SDSS i-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_z real, --/U mag --/D Absolute magnitude in rest-frame SDSS z-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_amivar_f real, --/U mag --/D Inverse variance of elpetro_absmag_f (NSA) 
    nsa_elpetro_amivar_n real, --/U mag^{-2} --/D Inverse variance of elpetro_absmag_n (NSA) 
    nsa_elpetro_amivar_u real, --/U mag^{-2} --/D Inverse variance of elpetro_absmag_u (NSA) 
    nsa_elpetro_amivar_g real, --/U mag^{-2} --/D Inverse variance of elpetro_absmag_g (NSA) 
    nsa_elpetro_amivar_r real, --/U mag^{-2} --/D Inverse variance of elpetro_absmag_r (NSA) 
    nsa_elpetro_amivar_i real, --/U mag^{-2} --/D Inverse variance of elpetro_absmag_i (NSA) 
    nsa_elpetro_amivar_z real, --/U mag^{-2} --/D Inverse variance of elpetro_absmag_z (NSA) 
    nsa_elpetro_flux_f real, --/U mag^{-2} --/D Elliptical SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA) 
    nsa_elpetro_flux_n real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in GALEX near-UV (using r-band aperture) (NSA) 
    nsa_elpetro_flux_u real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS u-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_g real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS g-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_r real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS r-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_i real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS i-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_z real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS z-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_ivar_f real, --/U nanomaggies --/D Inverse variance of elpetroflux_f (NSA) 
    nsa_elpetro_flux_ivar_n real, --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_n (NSA) 
    nsa_elpetro_flux_ivar_u real, --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_u (NSA) 
    nsa_elpetro_flux_ivar_g real, --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_g (NSA) 
    nsa_elpetro_flux_ivar_r real, --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_r (NSA) 
    nsa_elpetro_flux_ivar_i real, --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_i (NSA) 
    nsa_elpetro_flux_ivar_z real, --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_z (NSA) 
    nsa_elpetro_th50_r real, --/U nanomaggies^{-2} --/D Elliptical Petrosian 50% light radius in SDSS r-band (NSA) 
    nsa_elpetro_phi real, --/U arcsec --/D Position angle (east of north) used for elliptical apertures (for this version, same as ba90) (NSA) 
    nsa_elpetro_ba real, --/U deg --/D Axis ratio used for elliptical apertures (for this version, same as ba90) (NSA) 
    nsa_sersic_mass real, --/D Stellar mass from K-correction fit (use with caution) for Sersic fluxes (NSA) 
    nsa_sersic_absmag_f real, --/U solar mass --/D Absolute magnitude in rest-frame GALEX near-UV, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_n real, --/U mag --/D Absolute magnitude in rest-frame GALEX far-UV, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_u real, --/U mag --/D Absolute magnitude in rest-frame SDSS u-band, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_g real, --/U mag --/D Absolute magnitude in rest-frame SDSS g-band, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_r real, --/U mag --/D Absolute magnitude in rest-frame SDSS r-band, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_i real, --/U mag --/D Absolute magnitude in rest-frame SDSS i-band, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_z real, --/U mag --/D Absolute magnitude in rest-frame SDSS z-band, from Sersic fluxes (NSA) 
    nsa_sersic_flux_f real, --/U mag --/D Two-dimensional, single-component Sersic fit flux in GALEX far-UV (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_n real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in GALEX near-UV (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_u real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS u-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_g real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS g-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_r real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS r-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_i real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS i-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_z real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS z-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_ivar_f real, --/U nanomaggies --/D Inverse variance of sersic_flux_f (NSA) 
    nsa_sersic_flux_ivar_n real, --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_n (NSA) 
    nsa_sersic_flux_ivar_u real, --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_u (NSA) 
    nsa_sersic_flux_ivar_g real, --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_g (NSA) 
    nsa_sersic_flux_ivar_r real, --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_r (NSA) 
    nsa_sersic_flux_ivar_i real, --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_i (NSA) 
    nsa_sersic_flux_ivar_z real, --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_z (NSA) 
    nsa_sersic_th50 real, --/U nanomaggies^{-2} --/D 50% light radius of two-dimensional, single-component Sersic fit to r-band (NSA) 
    nsa_sersic_phi real, --/U arcsec --/D Angle (E of N) of major axis in two-dimensional, single-component Sersic fit in r-band (NSA) 
    nsa_sersic_ba real, --/U deg --/D Axis ratio b/a from two-dimensional, single-component Sersic fit in r-band (NSA) 
    nsa_sersic_n real, --/D Sersic index from two-dimensional, single-component Sersic fit in r-band (NSA) 
    nsa_petro_flux_f real, --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA) 
    nsa_petro_flux_n real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA) 
    nsa_petro_flux_u real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS u-band (using r-band aperture) (NSA) 
    nsa_petro_flux_g real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS g-band (using r-band aperture) (NSA) 
    nsa_petro_flux_r real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS r-band (using r-band aperture) (NSA) 
    nsa_petro_flux_i real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS i-band (using r-band aperture) (NSA) 
    nsa_petro_flux_z real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS z-band (using r-band aperture) (NSA) 
    nsa_petro_flux_ivar_f real, --/U nanomaggies --/D Inverse variance of petro_flux_f (NSA) 
    nsa_petro_flux_ivar_n real, --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_n (NSA) 
    nsa_petro_flux_ivar_u real, --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_u (NSA) 
    nsa_petro_flux_ivar_g real, --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_g (NSA) 
    nsa_petro_flux_ivar_r real, --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_r (NSA) 
    nsa_petro_flux_ivar_i real, --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_i (NSA) 
    nsa_petro_flux_ivar_z real, --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_z (NSA) 
    nsa_petro_th50 real, --/U nanomaggies^{-2} --/D Azimuthally averaged SDSS-style Petrosian 50% light radius (derived from r band) (NSA) 
    nsa_extinction_f real, --/U arcsec --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX far-UV (NSA) 
    nsa_extinction_n real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX near-UV (NSA) 
    nsa_extinction_u real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS u-band (NSA) 
    nsa_extinction_g real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS g-band (NSA) 
    nsa_extinction_r real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS r-band (NSA) 
    nsa_extinction_i real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS i-band (NSA) 
    nsa_extinction_z real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS z-band (NSA) 
    htmid bigint --/U mag --/D 20-level deep Hierarchical Triangular Mesh ID 
);



--
-- Name: dr19_mangatarget; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_mangatarget (
----------------------------------------------------------------------
--/H MaNGA Target Catalog
----------------------------------------------------------------------
    catalog_ra double precision, --/U deg --/D Right Ascension of measured object center (J2000) as given in the input catalog (NSA for main samples and most ancillaries) 
    catalog_dec double precision, --/U deg --/D Declination of measured object center (J2000) as given in the input catalog (NSA for main samples and most ancillaries) 
    nsa_z real, --/D Heliocentric redshift (NSA) 
    nsa_zdist real, --/D Distance estimate using pecular velocity model of Willick et al. (1997), expressed as a redshift equivalent; multiply by c/H0 for Mpc (NSA) 
    nsa_elpetro_mass real, --/U solar masses --/D Stellar mass from K-correction fit (use with caution) for elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_f real, --/U mag --/D Absolute magnitude in rest-frame GALEX far-UV, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_n real, --/U mag --/D Absolute magnitude in rest-frame GALEX near-UV, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_u real, --/U mag --/D Absolute magnitude in rest-frame SDSS u-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_g real, --/U mag --/D Absolute magnitude in rest-frame SDSS g-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_r real, --/U mag --/D Absolute magnitude in rest-frame SDSS r-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_i real, --/U mag --/D Absolute magnitude in rest-frame SDSS i-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_absmag_z real, --/U mag --/D Absolute magnitude in rest-frame SDSS z-band, from elliptical Petrosian fluxes (NSA) 
    nsa_elpetro_amivar_f real, --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_f (NSA) 
    nsa_elpetro_amivar_n real, --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_n (NSA) 
    nsa_elpetro_amivar_u real, --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_u (NSA) 
    nsa_elpetro_amivar_g real, --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_g (NSA) 
    nsa_elpetro_amivar_r real, --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_r (NSA) 
    nsa_elpetro_amivar_i real, --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_i (NSA) 
    nsa_elpetro_amivar_z real, --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_z (NSA) 
    nsa_elpetro_flux_f real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA) 
    nsa_elpetro_flux_n real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in GALEX near-UV (using r-band aperture) (NSA) 
    nsa_elpetro_flux_u real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS u-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_g real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS g-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_r real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS r-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_i real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS i-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_z real, --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS z-band (using r-band aperture) (NSA) 
    nsa_elpetro_flux_ivar_f real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_f (NSA) 
    nsa_elpetro_flux_ivar_n real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_n (NSA) 
    nsa_elpetro_flux_ivar_u real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_u (NSA) 
    nsa_elpetro_flux_ivar_g real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_g (NSA) 
    nsa_elpetro_flux_ivar_r real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_r (NSA) 
    nsa_elpetro_flux_ivar_i real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_i (NSA) 
    nsa_elpetro_flux_ivar_z real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_z (NSA) 
    nsa_elpetro_th50_r_original real, --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS r-band (NSA) 
    nsa_elpetro_th50_f real, --/U arcsec --/D Elliptical Petrosian 50% light radius in GALEX far-UV (NSA) 
    nsa_elpetro_th50_n real, --/U arcsec --/D Elliptical Petrosian 50% light radius in GALEX near-UV (NSA) 
    nsa_elpetro_th50_u real, --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS u-band (NSA) 
    nsa_elpetro_th50_g real, --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS g-band (NSA) 
    nsa_elpetro_th50_r real, --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS r-band (NSA) 
    nsa_elpetro_th50_i real, --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS i-band (NSA) 
    nsa_elpetro_th50_z real, --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS z-band (NSA) 
    nsa_elpetro_phi real, --/U deg --/D Position angle (east of north) used for elliptical apertures (for this version, same as ba90) (NSA) 
    nsa_elpetro_ba real, --/D Axis ratio used for elliptical apertures (for this version, same as ba90) (NSA) 
    nsa_sersic_mass real, --/U solar mass --/D Stellar mass from K-correction fit (use with caution) for Sersic fluxes (NSA) 
    nsa_sersic_absmag_f real, --/U mag --/D Absolute magnitude in rest-frame GALEX near-UV, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_n real, --/U mag --/D Absolute magnitude in rest-frame GALEX far-UV, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_u real, --/U mag --/D Absolute magnitude in rest-frame SDSS u-band, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_g real, --/U mag --/D Absolute magnitude in rest-frame SDSS g-band, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_r real, --/U mag --/D Absolute magnitude in rest-frame SDSS r-band, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_i real, --/U mag --/D Absolute magnitude in rest-frame SDSS i-band, from Sersic fluxes (NSA) 
    nsa_sersic_absmag_z real, --/U mag --/D Absolute magnitude in rest-frame SDSS z-band, from Sersic fluxes (NSA) 
    nsa_sersic_amivar_f real, --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_f (NSA) 
    nsa_sersic_amivar_n real, --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_n (NSA) 
    nsa_sersic_amivar_u real, --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_u (NSA) 
    nsa_sersic_amivar_g real, --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_g (NSA) 
    nsa_sersic_amivar_r real, --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_r (NSA) 
    nsa_sersic_amivar_i real, --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_i (NSA) 
    nsa_sersic_amivar_z real, --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_z (NSA) 
    nsa_sersic_flux_f real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in GALEX far-UV (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_n real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in GALEX near-UV (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_u real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS u-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_g real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS g-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_r real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS r-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_i real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS i-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_z real, --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS z-band (fit using r-band structural parameters) (NSA) 
    nsa_sersic_flux_ivar_f real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_f (NSA) 
    nsa_sersic_flux_ivar_n real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_n (NSA) 
    nsa_sersic_flux_ivar_u real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_u (NSA) 
    nsa_sersic_flux_ivar_g real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_g (NSA) 
    nsa_sersic_flux_ivar_r real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_r (NSA) 
    nsa_sersic_flux_ivar_i real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_i (NSA) 
    nsa_sersic_flux_ivar_z real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_z (NSA) 
    nsa_sersic_th50 real, --/U arcsec --/D 50% light radius of two-dimensional, single-component Sersic fit to r-band (NSA) 
    nsa_sersic_phi real, --/U deg --/D Angle (E of N) of major axis in two-dimensional, single-component Sersic fit in r-band (NSA) 
    nsa_sersic_ba real, --/D Axis ratio b/a from two-dimensional, single-component Sersic fit in r-band (NSA) 
    nsa_sersic_n real, --/D Sersic index from two-dimensional, single-component Sersic fit in r-band (NSA) 
    nsa_petro_flux_f real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA) 
    nsa_petro_flux_n real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA) 
    nsa_petro_flux_u real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS u-band (using r-band aperture) (NSA) 
    nsa_petro_flux_g real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS g-band (using r-band aperture) (NSA) 
    nsa_petro_flux_r real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS r-band (using r-band aperture) (NSA) 
    nsa_petro_flux_i real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS i-band (using r-band aperture) (NSA) 
    nsa_petro_flux_z real, --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS z-band (using r-band aperture) (NSA) 
    nsa_petro_flux_ivar_f real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_f (NSA) 
    nsa_petro_flux_ivar_n real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_n (NSA) 
    nsa_petro_flux_ivar_u real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_u (NSA) 
    nsa_petro_flux_ivar_g real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_g (NSA) 
    nsa_petro_flux_ivar_r real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_r (NSA) 
    nsa_petro_flux_ivar_i real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_i (NSA) 
    nsa_petro_flux_ivar_z real, --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_z (NSA) 
    nsa_petro_th50 real, --/U arcsec --/D Azimuthally averaged SDSS-style Petrosian 50% light radius (derived from r band) (NSA) 
    nsa_extinction_f real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX far-UV (NSA) 
    nsa_extinction_n real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX near-UV (NSA) 
    nsa_extinction_u real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS u-band (NSA) 
    nsa_extinction_g real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS g-band (NSA) 
    nsa_extinction_r real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS r-band (NSA) 
    nsa_extinction_i real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS i-band (NSA) 
    nsa_extinction_z real, --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS z-band (NSA) 
    nsa_iauname character varying(20), --/D IAU-style designation based on RA/Dec (NSA) 
    nsa_subdir character varying(128), --/D Subdirectory for images in the NSA 'detect' directory (NSA) 
    nsa_pid integer, --/D Parent id within mosaic for this object (NSA) 
    nsa_nsaid integer, --/D Unique ID within NSA v1 catalog (NSA) 
    catind integer, --/D Zero-indexed row within the input NSA v1 catalog (NSA) 
    manga_target1 bigint, --/D Targeting bitmask for main sample targets 
    mangaid character varying(20) NOT NULL, --/D Unique ID for each manga target 
    zmin real, --/D The minimum redshift at which the galaxy could still have been included in the Primary sample 
    zmax real, --/D The maximum redshift at which the galaxy could still have been included in the Primary sample 
    szmin real, --/D The minimum redshift at which the galaxy could still have been included in the Secondary sample 
    szmax real, --/D The maximum redshift at which the galaxy could still have been included in the Secondary sample 
    ezmin real, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample 
    ezmax real, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample 
    probs real, --/D The probability that a Secondary sample galaxy is included after down-sampling. For galaxies not in the Secondary sample PROBS is set to the mean down-sampling probability 
    pweight real, --/D The volume weight for the Primary sample. Corrects the MaNGA selection to a volume limited sample 
    sweight real, --/D The volume weight for the full Secondary sample. Corrects the MaNGA selection to a volume limited sample 
    srweight real, --/D The volume weight for the down-sampled Secondary sample. Corrects the MaNGA selection to a volume limited sample 
    eweight real, --/D The volume weight for the Primary+ sample. Corrects the MaNGA selection to a volume limited sample 
    psrweight real, --/D The volume weight for the combined Primary and down-sampled Secondary samples. Corrects the MaNGA selection to a volume limited sample 
    esrweight real, --/D The volume weight for the combined Primary+ and down-sampled Secondary samples. Corrects the MaNGA selection to a volume limited sample 
    psweight real, --/D The volume weight for the combined Primary and full Secondary samples. Corrects the MaNGA selection to a volume limited sample 
    esweight real, --/D The volume weight for the combined Primary+ and full Secondary samples. Corrects the MaNGA selection to a volume limited sample 
    ranflag bit(1), --/D Set to 1 if a target is to be included after random sampling to produce the correct proportions of each sample, otherwise 0 
    manga_tileids_0 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_1 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_2 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_3 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_4 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_5 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_6 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_7 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_8 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_9 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_10 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_11 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_12 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_13 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_14 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_15 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_16 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_17 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_18 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_19 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_20 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_21 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_22 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_23 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_24 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_25 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_26 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_27 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_28 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileids_29 integer, --/D IDs of all tiles that overlap a galaxy's position. 
    manga_tileid integer, --/D The ID of the tile to which this object has been allocated 
    tilera double precision, --/U deg --/D The Right Ascension (J2000) of the tile to which this object has been allocated 
    tiledec double precision, --/U deg --/D The Declination (J2000) of the tile to which this object has been allocated 
    ifutargetsize smallint, --/U fibers --/D The ideal IFU size for this object. The intended IFU size is equal to IFUTargetSize except if IFUTargetSize &gt; 127 when it is 127, or &lt; 19 when it is 19 
    ifudesignsize smallint, --/U fibers --/D The allocated IFU size (0 = "unallocated") 
    ifudesignwrongsize smallint, --/U fibers --/D The allocated IFU size if the intended IFU size was not available 
    ifu_ra double precision, --/U deg --/D The Right Ascension (J2000) of the IFU center 
    ifu_dec double precision, --/U deg --/D The Right Declination (J2000) of the IFU center 
    badphotflag bit(1), --/D Set to 1 if target has been visually inspected to have bad photometry and should not be observed 
    starflag bit(1), --/D Set to 1 if target lies close to a bright star should not be observed 
    object_ra double precision, --/U deg --/D The best estimate of the Right Ascension (J2000) of the center of the object. Normally the same as CATALOG_RA but can be modified particularly as a result of visual inspection 
    object_dec double precision, --/U deg --/D The best estimate of the Declination (J2000) of the center of the object. Normally the same as CATALOG_RA but can be modified particularly as a result of visual inspection 
    obsflag bit(1), --/D Set to 1 if the target has already been included on a plate set to be observed at the time the IFU allocation was made, otherwise 0 
    catindanc integer, --/D Zero-indexed row within the applicable ancillary catalog 
    ifudesignsizemain smallint, --/U fibers --/D The allocated IFU size prior to the addition of the ancillary samples (0 = "unallocated") 
    ifuminsizeanc smallint, --/U fibers --/D The minimum acceptable IFU size for the ancillary program 
    ifutargsizeanc smallint, --/U fibers --/D The ideal IFU size for the ancillary program 
    manga_target3 bigint, --/D Targeting bitmask for the ancillary samples 
    priorityanc integer, --/D The ancillary program's priority for this object 
    unalloc smallint, --/D Set to 1 if an ancillary target has been allocated an IFU the was not allocated to a main sample galaxy, otherwise 0 
    specobjid text --/D The associated specObjID from the dr19_sdss_dr17_specobj table 
);



--
-- Name: dr19_mapper; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_mapper (
----------------------------------------------------------------------
--/H This table stores the names of the mappers associated with cartons in dr19_carton.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier. 
    label text --/D The name of the mapper. 
);



--
-- Name: dr19_marvels_dr11_star; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_marvels_dr11_star (
----------------------------------------------------------------------
--/H Contains data for a MARVELS star (DR11 release).
----------------------------------------------------------------------
    starname character varying NOT NULL, --/D The primary name of the star (STARNAME) 
    twomass_name character varying, --/D 2MASS Star Catalog Name 
    plate character varying, --/D Plate Name 
    gsc_name character varying, --/D Guide Star Catalog Name 
    tyc_name character varying, --/D Tycho Star Catalog Name 
    hip_name character varying, --/D Hipparcos Star Catalog Name 
    ra_final double precision, --/U deg --/D Star Right Ascension 
    dec_final double precision, --/U deg --/D Star Declination 
    gsc_b double precision, --/U mag --/D GSC B Magnitude 
    gsc_v double precision, --/U mag --/D GSC V Magnitude 
    twomass_j real, --/U mag --/D 2MASS J Magnitude 
    twomass_h real, --/U mag --/D 2MASS H Magnitude 
    twomass_k real, --/U mag --/D 2MASS K Magnitude 
    sp1 character varying, --/D Hipparcos Spectral type 1 
    sp2 character varying, --/D Hipparcos Spectral type 2 
    rpm_log_g character varying, --/D Luminosity Class from SSPP* (Mainseq/Giant/Refstar) Refstar means it is a known planet host (different method used for year34 - see docs) 
    teff real, --/U K --/D SSPP* effective temperature (different method used for year34 - see docs) 
    log_g real, --/D SSPP* Surface gravity (different method used for year34 - see docs) 
    feh real, --/D SSPP* Metallicity (different method used for year34 - see docs) 
    gsc_b_e real, --/U mag --/D Error in GSC B Magnitude 
    gsc_v_e real, --/U mag --/D Error in GSC V Magnitude 
    twomass_j_e real, --/U mag --/D Error in 2MASS J Magnitude 
    twomass_h_e real, --/U mag --/D Error in 2MASS H Magnitude 
    twomass_k_e real, --/U mag --/D Error in 2MASS H Magnitude 
    teff_e real, --/U K --/D Error in SSPP* effective temperature 
    log_g_e real, --/D Error in SSPP* Surface gravity (different method used for year34 - see docs) (different method used for year34 - see docs) 
    feh_e real, --/D Error in SSPP* Metallicity (different method used for year34 - see docs) 
    epoch_0 real, --/D Epoch 0 
    ra_0 double precision, --/U deg --/D Right Ascension at Epoch 0 
    dec_0 double precision, --/U deg --/D Declination at Epoch 0 
    ra_twomass double precision, --/U deg --/D 2MASS Right Ascension 
    dec_twomass double precision, --/U deg --/D 2MASS Declination 
    gsc_pm_ra double precision, --/U mas/yr --/D GSC Proper Motion in RA pmra * cos(dec) 
    gsc_pm_dec double precision, --/U mas/yr --/D GSC Proper MOtion in DEC 
    gsc_pm_ra_e double precision, --/U mas/yr --/D Error in GSC Proper Motion in RA pmra * cos(dec) 
    gsc_pm_dec_e double precision, --/U mas/yr --/D Error in GSC Proper MOtion in DEC 
    tyc_b real, --/U mag --/D Tycho B Magnitude 
    tyc_b_e real, --/U mag --/D Error in Tycho B Magnitude 
    tyc_v real, --/U mag --/D Tycho V Magnitude 
    tyc_v_e real, --/U mag --/D Error in Tycho V Magnitude 
    hip_plx real, --/U mas --/D Hipparcos Parallax 
    hip_plx_e real, --/U mas --/D Error in Hipparcos Parallax 
    hip_sptype character varying, --/D Hipparcos Spectral Type 
    twomass_designation text, --/D 2MASS Designation ID in dr19_twomass_psc 
    tycho2_designation text --/D Tycho2 Designation ID in dr19_tycho2 
);



--
-- Name: dr19_marvels_dr12_star; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_marvels_dr12_star (
----------------------------------------------------------------------
--/H Contains data for a MARVELS star (DR12 release).
----------------------------------------------------------------------
    starname character varying, --/D The primary name of the star (STARNAME) 
    twomass_name character varying, --/D 2MASS Star Catalog Name 
    plate character varying, --/D Plate Name 
    gsc_name character varying, --/D Guide Star Catalog Name 
    tyc_name character varying, --/D Tycho Star Catalog Name 
    hip_name character varying, --/D Hipparcos Star Catalog Name 
    ra_final double precision, --/U deg --/D Star Right Ascension 
    dec_final double precision, --/U deg --/D Star Declination 
    gsc_b double precision, --/U mag --/D GSC B Magnitude 
    gsc_v double precision, --/U mag --/D GSC V Magnitude 
    twomass_j real, --/U mag --/D 2MASS J Magnitude 
    twomass_h real, --/U mag --/D 2MASS H Magnitude 
    twomass_k real, --/U mag --/D 2MASS K Magnitude 
    sp1 character varying, --/D Hipparcos Spectral type 1 
    sp2 character varying, --/D Hipparcos Spectral type 2 
    rpm_log_g character varying, --/D Luminosity Class from SSPP* (Mainseq/Giant/Refstar) Refstar means it is a known planet host (different method used for year34 - see docs) 
    teff real, --/U K --/D SSPP* effective temperature (different method used for year34 - see docs) 
    log_g real, --/D SSPP* Surface gravity (different method used for year34 - see docs) 
    feh real, --/D SSPP* Metallicity (different method used for year34 - see docs) 
    gsc_b_e real, --/U mag --/D Error in GSC B Magnitude 
    gsc_v_e real, --/U mag --/D Error in GSC V Magnitude 
    twomass_j_e real, --/U mag --/D Error in 2MASS J Magnitude 
    twomass_h_e real, --/U mag --/D Error in 2MASS H Magnitude 
    twomass_k_e real, --/U mag --/D Error in 2MASS H Magnitude 
    teff_e real, --/U K --/D Error in SSPP* effective temperature 
    log_g_e real, --/D Error in SSPP* Surface gravity (different method used for year34 - see docs) (different method used for year34 - see docs) 
    feh_e real, --/D Error in SSPP* Metallicity (different method used for year34 - see docs) 
    epoch_0 real, --/D Epoch 0 
    ra_0 double precision, --/U deg --/D Right Ascension at Epoch 0 
    dec_0 double precision, --/U deg --/D Declination at Epoch 0 
    ra_twomass double precision, --/U deg --/D 2MASS Right Ascension 
    dec_twomass double precision, --/U deg --/D 2MASS Declination 
    gsc_pm_ra double precision, --/U mas/yr --/D GSC Proper Motion in RA pmra * cos(dec) 
    gsc_pm_dec double precision, --/U mas/yr --/D GSC Proper MOtion in DEC 
    gsc_pm_ra_e double precision, --/U mas/yr --/D Error in GSC Proper Motion in RA pmra * cos(dec) 
    gsc_pm_dec_e double precision, --/U mas/yr --/D Error in GSC Proper MOtion in DEC 
    tyc_b real, --/U mag --/D Tycho B Magnitude 
    tyc_b_e real, --/U mag --/D Error in Tycho B Magnitude 
    tyc_v real, --/U mag --/D Tycho V Magnitude 
    tyc_v_e real, --/U mag --/D Error in Tycho V Magnitude 
    hip_plx real, --/U mas --/D Hipparcos Parallax 
    hip_plx_e real, --/U mas --/D Error in Hipparcos Parallax 
    hip_sptype character varying, --/D Hipparcos Spectral Type 
    pk bigint NOT NULL,
    twomass_designation text, --/D 2MASS Designation ID in dr19_twomass_psc 
    tycho2_designation text --/D Tycho2 Designation ID in dr19_tycho2 
);



--
-- Name: dr19_mastar_goodstars; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_mastar_goodstars (
----------------------------------------------------------------------
--/H Summary file of MaNGA Stellar Libary.
----------------------------------------------------------------------
    drpver character varying(8), --/D Version of mangadrp. 
    mprocver character varying(8), --/D Version of mastarproc. 
    mangaid character varying(25) NOT NULL, --/D MaNGA-ID for the target. 
    minmjd integer, --/D Minimum Modified Julian Date of Observations. 
    maxmjd integer, --/D Maximum Modified Julian Date of Observations. 
    nvisits integer, --/D Number of visits for this star (including good and bad observations). 
    nplates integer, --/D Number of plates this star is on. 
    ra double precision, --/U deg --/D Right Ascension for this object at the time given by the EPOCH column (Equinox J2000). 
    "dec" double precision, --/U deg --/D Declination for this object at the time given by the EPOCH column (Equinox J2000). 
    epoch real, --/D Epoch of the astrometry (which is approximate for some catalogs). 
    psfmag_1 real, --/U mag --/D PSF magnitude in the first band with the filter correspondence depending on PHOTOCAT. 
    psfmag_2 real, --/U mag --/D PSF magnitude in the second band with the filter correspondence depending on PHOTOCAT. 
    psfmag_3 real, --/U mag --/D PSF magnitude in the third band with the filter correspondence depending on PHOTOCAT. 
    psfmag_4 real, --/U mag --/D PSF magnitude in the fourth band with the filter correspondence depending on PHOTOCAT. 
    psfmag_5 real, --/U mag --/D PSF magnitude in the fifth band with the filter correspondence depending on PHOTOCAT. 
    mngtarg2 integer, --/D MANGA_TARGET2 targeting bitmask. 
    input_logg real, --/U log(cm/s^2) --/D Surface gravity in the input catalog (with some adjustment made). 
    input_teff real, --/U K --/D Effective temperature in the input catalog (with some adjustment made). 
    input_fe_h real, --/U Fe/H] in the input catalog (with some adjustment made). [
    input_alpha_m real, --/U alpha/M] in the input catalog (with some adjustment made). [
    input_source character varying(16), --/D Source catalog for stellar parameters. 
    photocat character varying(10) --/D Source of astrometry and photometry. 
);



--
-- Name: dr19_mastar_goodvisits; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_mastar_goodvisits (
----------------------------------------------------------------------
--/H Summary file of all visits of stars included in MaNGA Stellar Libary.
----------------------------------------------------------------------
    drpver character varying(8), --/D Version of mangadrp. 
    mprocver character varying(8), --/D Version of mastarproc. 
    mangaid character varying(25), --/D MaNGA-ID for the object. 
    plate integer, --/D Plate ID. 
    ifudesign character varying(6), --/D IFUDESIGN for the fiber bundle. 
    mjd integer, --/D Modified Julian Date for this visit. 
    ifura double precision, --/U deg --/D Right Ascension of the center of the IFU. 
    ifudec double precision, --/U deg --/D Declination of the center of the IFU. 
    ra double precision, --/U deg --/D Right Ascension for this object at the time given by the EPOCH column (Equinox J2000). 
    "dec" double precision, --/U deg --/D Declination for this object at the time given by the EPOCH column (Equinox J2000). 
    epoch real, --/D Epoch of the astrometry (which is approximate for some catalogs). 
    psfmag_1 real, --/U mag --/D PSF magnitude in the first band with the filter correspondence depending on PHOTOCAT. 
    psfmag_2 real, --/U mag --/D PSF magnitude in the second band with the filter correspondence depending on PHOTOCAT. 
    psfmag_3 real, --/U mag --/D PSF magnitude in the third band with the filter correspondence depending on PHOTOCAT. 
    psfmag_4 real, --/U mag --/D PSF magnitude in the fourth band with the filter correspondence depending on PHOTOCAT. 
    psfmag_5 real, --/U mag --/D PSF magnitude in the fifth band with the filter correspondence depending on PHOTOCAT. 
    mngtarg2 integer, --/D MANGA_TARGET2 targeting bitmask. 
    exptime real, --/U sec --/D Median exposure time for all exposures on this visit. 
    nexp_visit smallint, --/D Total number of exposures during this visit. This column was named 'NEXP' in DR15/16. 
    nvelgood smallint, --/D Number of exposures (from all visits of this PLATE-IFUDESIGN) with good velocity measurements. 
    heliov real, --/U km/s --/D Median heliocentric velocity of all exposures on all visits that yield good velocity measurements. This is used to shift the spectra to the rest frame. 
    verr real, --/U km/s --/D 1-sigma uncertainty of the heliocentric velocity 
    v_errcode smallint, --/D Error code for HELIOV. Zero is good, nonzero is bad. 
    heliov_visit real, --/U km/s --/D Median heliocentric velocity of good exposures from only this visit, rather than from all visits. 
    verr_visit real, --/U km/s --/D 1-sigma uncertainty of HELIOV_VISIT. 
    v_errcode_visit smallint, --/D Error code for HELIOV_VISIT. Zero is good, nonzero is bad. 
    velvarflag smallint, --/D Flag indicating the significant variation of the heliocentric velocity from visit to visit. A value of 1 means the variation is beyond 3-sigma between at least two of the visits. A value of 0 means all variations between pairs of visits are less than 3-sigma. 
    dv_maxsig real, --/D Maximum significance in velocity variation between pairs of visits. 
    mjdqual integer, --/D Spectral quality bitmask (MASTAR_QUAL). 
    bprperr_sp real, --/D Uncertainty in the synthetic Bp-Rp color derived from the spectra. 
    nexp_used smallint, --/D Number of exposures used in constructing the visit spectrum. 
    s2n real, --/D Median signal-to-noise ratio per pixel of this visit spectrum. 
    s2n10 real, --/D Top 10-th percentile signal-to-noise ratio per pixel of this visit spectrum. 
    badpixfrac real, --/D Fraction of bad pixels (those with inverse variance being zero.) 
    coord_source character varying(10), --/D Source of astrometry. 
    photocat character varying(10), --/D Source of photometry. 
    pk bigint NOT NULL --/D Primary key. Sequential identifier for this table. 
);



--
-- Name: dr19_mipsgal; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_mipsgal (
----------------------------------------------------------------------
--/H This table contains target from a 24µm catalog based point source catalog derived from the image data of the MIPSGAL 24µm Galactic Plane Survey and the corresponding data products.
----------------------------------------------------------------------
    mipsgal character varying(18) NOT NULL, --/D MIPSGAL name 
    glon double precision, --/U deg --/D Galactic longitude 
    glat double precision, --/U deg --/D Galactic latitude 
    radeg double precision, --/U deg --/D Right Ascension, in decimal degrees (J2000) 
    dedeg double precision, --/U deg --/D Declination, in decimal degrees (J2000) 
    s24 double precision, --/U mJy --/D 24µm flux density 
    e_s24 double precision, --/U mJy --/D 1σ uncertainty in S24 
    mag_24 double precision, --/U mag --/D 24µm magnitude (Vega) 
    e_mag_24 double precision, --/U 24] [mag --/D 1σ uncertainty in 
    twomass_name character varying(17), --/D 2MASS name (HHMMSSss+DDMMSSs, Cat. II/246) 
    sj double precision, --/U mJy --/D 2MASS J-band flux density 
    e_sj double precision, --/U mJy --/D 1σ uncertainty in SJ 
    sh double precision, --/U mJy --/D 2MASS H-band flux density 
    e_sh double precision, --/U mJy --/D 1σ uncertainty in SH 
    sk double precision, --/U mJy --/D 2MASS Ks-band flux density 
    e_sk double precision, --/U mJy --/D 1σ uncertainty in SK 
    glimpse character varying(17), --/D GLIMPSE name (GLLL.llll+BB.bbbb, Cat. II/293) 
    s3_6 double precision, --/U mJy --/D Spitzer/IRAC 3.6µm flux density 
    e_s3_6 double precision, --/U mJy --/D 1σ uncertainty in S3.6 
    s4_5 double precision, --/U mJy --/D Spitzer/IRAC 4.5µm flux density 
    e_s4_5 double precision, --/U mJy --/D 1σ uncertainty in S4.5 
    s5_8 double precision, --/U mJy --/D Spitzer/IRAC 5.8µm flux density 
    e_s5_8 double precision, --/U mJy --/D 1σ uncertainty in S5.8 
    s8_0 double precision, --/U mJy --/D Spitzer/IRAC 8.0µm flux density 
    wise character varying(19), --/D WISE name (JHHMMSS.ss+DDMMSS.s, Cat. I/311) 
    s3_4 double precision, --/U mJy --/D WISE/W1 (3.35µm) flux density 
    e_s3_4 double precision, --/U mJy --/D 1σ uncertainty in S3.4 
    s4_6 double precision, --/U mJy --/D WISE/W2 (4.6µm) flux density 
    e_s4_6 double precision, --/U mJy --/D 1σ uncertainty in S4.6 
    s12 double precision, --/U mJy --/D WISE/W3 (11.6µm) flux density 
    e_s12 double precision, --/U mJy --/D 1σ uncertainty in S12 
    s22 double precision, --/U mJy --/D WISE/W4 (22.1µm) flux density 
    e_s22 double precision, --/U mJy --/D 1σ uncertainty in S22 
    jmag double precision, --/U mag --/D 2MASS J-band magnitude (Vega) 
    e_jmag double precision, --/U mag --/D 1σ uncertainty in Jmag (Vega) 
    hmag double precision, --/U mag --/D 2MASS H band magnitude (Vega) 
    e_hmag double precision, --/U mag --/D 1σ uncertainty in Hmag (Vega) 
    kmag double precision, --/U mag --/D 2MASS Ks band magnitude (Vega) 
    e_kmag double precision, --/U mag --/D 1σ uncertainty in Kmag (Vega) 
    mag_3_6 double precision, --/U mag --/D Spitzer/IRAC 3.6µm magnitude (Vega) 
    e_mag_3_6 double precision, --/U 3.6] [mag --/D 1σ uncertainty in 
    mag_4_5 double precision, --/U mag --/D Spitzer/IRAC 4.5µm magnitude (Vega) 
    e_mag_4_5 double precision, --/U 4.5] [mag --/D 1σ uncertainty in 
    mag_5_8 double precision, --/U mag --/D Spitzer/IRAC 5.8µm magnitude (Vega) 
    e_mag_5_8 double precision, --/U 5.8] [mag --/D 1σ uncertainty in 
    mag_8_0 double precision, --/U mag --/D Spitzer/IRAC 8.0µm magnitude (Vega) 
    e_mag_8_0 double precision, --/U 8.0] [mag --/D 1σ uncertainty in 
    w1mag double precision, --/U mag --/D WISE/W1 (3.35um) magnitude (Vega) 
    e_w1mag double precision, --/U mag --/D 1σ uncertainty in W1mag (Vega) 
    w2mag double precision, --/U mag --/D WISE/W2 (4.6µm) magnitude (Vega) 
    e_w2mag double precision, --/U mag --/D 1σ uncertainty in W2mag (Vega) 
    w3mag double precision, --/U mag --/D WISE/W3 (11.6um) magnitude (Vega) 
    e_w3mag double precision, --/U mag --/D 1σ uncertainty in W3mag (Vega) 
    w4mag double precision, --/U mag --/D WISE/W4 (22.1um) magnitude (Vega) 
    e_w4mag double precision, --/U mag --/D 1σ uncertainty in W4mag (Vega) 
    dnn double precision, --/U arcsec --/D Nearest neighbor distance 
    ng integer, --/D Number of GLIMPSE sources within 6.35" aperture 
    n2m integer, --/D Number of 2MASS sources within 6.35" aperture 
    nw integer, --/D Number of WISE sources within 6.35" aperture 
    fwhm double precision, --/U arcsec --/D Empirically measured Full Width at Half Maximum of the MIPSGAL source 
    sky double precision, --/U MJy --/D Background flux density measured in the sky annulus 
    lim1 double precision, --/U mJy --/D 90% differential completeness limit (in mJy) 
    lim2 double precision --/U mag --/D 90% differential completeness limit, VEGAMAG (magnitude at which 90% of the sources are successfully recovered) 
);



--
-- Name: dr19_mwm_tess_ob; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_mwm_tess_ob (
----------------------------------------------------------------------
--/H This table contains targets requested for the manual carton mwm_tess_ob.
----------------------------------------------------------------------
    gaia_dr2_id bigint NOT NULL, --/D Gaia DR2 unique source identifier 
    ra double precision, --/U degrees --/D Right Ascension (J2000) 
    "dec" double precision, --/U degrees --/D Declination (J2000) 
    h_mag double precision, --/U mag --/D 2MASS H-band mangitude 
    instrument character varying, --/D Instrument requested for this target (only APOGEE for this carton) 
    cadence character varying --/D Cadence requested for this carton 
);



--
-- Name: dr19_observatory; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_observatory (
----------------------------------------------------------------------
--/H Table of observatories.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    label text --/D The name of the observatory.
);



--
-- Name: dr19_obsmode; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_obsmode (
----------------------------------------------------------------------
--/H The table contains observing constraints for different observing modes. Cadences have an observing mode associated with each epoch, and the constraints are checked before an epoch can be scheduled.
----------------------------------------------------------------------
    label text NOT NULL, --/D Descriptive name for the observing mode, e.g. 'dark_rm' 
    min_moon_sep real, --/U deg --/D Minimum distance a target must be from the Moon 
    min_deltav_ks91 real, --/U mag --/D Minimum estimated background flux from the Moon, using the method of Krisciunas, K., & Schaefer 1991 
    min_twilight_ang real, --/U deg --/D Minimum twilight angle (angle of the Sun below the horizon) for a target to be observed 
    max_airmass_apo real, --/D Max airmass at which a target can be observed at APO
    max_airmass_lco real --/D Max airmass at which a target can be observed at LCO
);



--
-- Name: dr19_opsdb_apo_camera; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_opsdb_apo_camera (
----------------------------------------------------------------------
--/H The table contains the cameras at the observatory. The three APOGEE chips are treated as one camera, while the separate blue channel and red channel BOSS chips are treated separately.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D Unique identifier
    label text --/D The name of the camera.
);



--
-- Name: dr19_opsdb_apo_camera_frame; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_opsdb_apo_camera_frame (
----------------------------------------------------------------------
--/H The table contains signal-to-noise estimates for each 'camera', for each exposure. APOGEE is treated as one camera, while R1/2 and B1/2 are treated separately.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D Unique identifier
    exposure_pk integer, --/D Unique identifier in the exposure table
    camera_pk smallint, --/D Unique identifier in the camera table
    sn2 real, --/D Signal-to-noise squared estimate from on-mountain quick reduction pipelines
    comment text --/D An optional comment
);



--
-- Name: dr19_opsdb_apo_completion_status; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_opsdb_apo_completion_status (
----------------------------------------------------------------------
--/H The table complains completion statuses referenced in design_to_status
----------------------------------------------------------------------
    pk integer NOT NULL, --/D Unique identifier
    label text --/D Description of status ('not started', 'started', 'done')
);



--
-- Name: dr19_opsdb_apo_configuration; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_opsdb_apo_configuration (
----------------------------------------------------------------------
--/H This table contains basic information about a configuration of robots loaded at the telescope.
----------------------------------------------------------------------
    configuration_id integer NOT NULL, --/D Unique identifier
    design_id integer, --/D Unique identifier of the design loaded
    comment text, --/D An optional comment
    temperature text, --/D The ambient temperature when the design was loaded
    epoch double precision, --/D The Julian Date (JD) when the design was loaded
    calibration_version text --/D The version of fps_calibration used, https://github.com/sdss/fps_calibrations/tags
);



--
-- Name: dr19_opsdb_apo_design_to_status; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_opsdb_apo_design_to_status (
----------------------------------------------------------------------
--/H The table contains design completion information by joining design and design_status
----------------------------------------------------------------------
    pk integer NOT NULL, --/D Unique identifier
    design_id integer, --/D Unique identifier in the design table
    completion_status_pk smallint, --/D Unique identifier in the design status table
    mjd real, --/U days --/D Decimal Modified Julian Date (MJD) on which the design was completed 
    manual boolean --/D A flag indicated whether the design was manually marked complete (True) or met normal pipeline criteria (False)
);



--
-- Name: dr19_opsdb_apo_exposure; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_opsdb_apo_exposure (
----------------------------------------------------------------------
--/H The table contains exposures taken at the observatory.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D Unique identifier 
    configuration_id integer, --/D Unique identifier in the configuration table 
    exposure_no bigint, --/D An Exposure Number assigned by the on mountain pipelines 
    comment text, --/D Optional comment 
    start_time timestamp without time zone, --/U datetime --/D The time an exposure started 
    exposure_time real, --/U seconds --/D The length of the exposure 
    exposure_flavor_pk smallint --/D Unique identifier in the exposure_flavor table 
);



--
-- Name: dr19_opsdb_apo_exposure_flavor; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_opsdb_apo_exposure_flavor (
----------------------------------------------------------------------
--/H The table contains the various types of exposures; science, dark, flat, etc.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D Unique identifier
    label text --/D The type of exposure
);



--
-- Name: dr19_panstarrs1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_panstarrs1 (
----------------------------------------------------------------------
--/H A copy of the PanSTARRS1-dr2 catalogue provided by E. Magnier. Based on the internal IPP database representation mainyaned by IfA, U. Hawaii. Column names may differ from publically available catalogues hosted at MAST (mapping provided in column descriptions). The SDSS-V copy of this database is derived from a combination of the PS1-dr2 StackObjectThin and ObjectThin tables (https://outerspace.stsci.edu/display/PANSTARRS/PS1+Database+object+and+detection+tables). The catalogue contains PSF, Kron, and Aper measurements based on stacked and forced warp photometry, and expressed as fluxes, including measurements are made of low-significance detections. The average exposure (chip) measurements are expressed in magnitudes since photometry is not measured at this stage for sources with S/N < 5, so there should not be any negative fluxes. Magnitudes are on the AB system, fluxes are in Janskys. Conversion to AB mags is via: mag = 8.9 - 2.5*log10(flux).
----------------------------------------------------------------------
    ra double precision, --/U deg --/D mean RA, (J2000, tied to Gaia DR1) 
    "dec" double precision, --/U deg --/D mean Dec, (J2000, tied to Gaia DR1) 
    dra real, --/U arcsec --/D error on RA 
    ddec real, --/U arcsec --/D error on DEC 
    tmean real, --/U days --/D Mean epoch (MJD) 
    trange real, --/U days --/D Time range -- may include 2MASS values 
    chisqpos real, --/D chi-square of a fixed position astrometry solution (equiv to ObjectThin.posMeanChisq)
    stargal real, --/D Measure of extendedness. Computed as the median across all chip measurements of extNsigma, where extNsigma = (PSF mag - Kron mag) expressed as a number of sigmas, so it somewhat adjusts for the spread at low signal-to-noise.
    nmeas integer, --/D total number of measurements in databases (including non-PS1 data)
    nwarp_ok integer, --/D number of warps with psf_qf > 0 (any unmasked pixels)
    flags integer, --/D ObjectInfoFlags
    objid integer, --/D internal Pan-STARRS IPP object ID : unique within database spatial partition (see catID)
    catid integer, --/D database spatial partition ID - (equiv. to StackObjectThin.dvoRegionID)
    extid_hi integer, --/D upper 32 bits of PSPS object ID (objID in MAST PSPS database)
    extid_lo integer, --/D lower 32 bits of PSPS object ID (objID in MAST PSPS database)
    g_chp_psf real, --/U mag --/D mean g-band chip PSF magnitude 
    g_chp_psf_err real, --/U mag --/D error on mean g-band chip PSF magnitude 
    g_chp_psf_nphot integer, --/D number of measurements used for g_chp_psf (excluding outliers)
    g_chp_aper real, --/U mag --/D mean g-band chip seeing-adapted aperture magnitude 
    g_chp_aper_err real, --/U mag --/D error on mean g-band chip seeing-adapted aperture magnitude 
    g_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    g_chp_kron real, --/U mag --/D mean g-band chip Kron magnitude 
    g_chp_kron_err real, --/U mag --/D error on mean g-band chip Kron magnitude 
    g_chp_kron_nphot integer, --/D number of measurements used for g_chp_kron (excluding outliers)
    g_stk_psf_flux real, --/U Jy --/D best g-band stack PSF flux 
    g_stk_psf_fluxerr real, --/U Jy --/D error on best g-band stack PSF flux 
    g_stk_psf_nphot integer, --/D number of measurements used for g_stk_psf_flux (excluding outliers)
    g_stk_aper_flux real, --/U Jy --/D g-band stack seeing-adapted aperture flux 
    g_stk_aper_fluxerr real, --/U Jy --/D error on g-band stack seeing-adapted aperture flux 
    g_stk_aper_nphot integer, --/D number of measurements used for g_stk_aper_flux (excluding outliers)
    g_stk_kron_flux real, --/U Jy --/D g-band stack Kron flux from same stack as 'best' PSF above 
    g_stk_kron_fluxerr real, --/U Jy --/D error on g-band stack Kron flux from same stack as 'best' PSF above 
    g_stk_kron_nphot integer, --/D number of measurements used for g_stk_kron_flux (excluding outliers)
    g_wrp_psf_flux real, --/U Jy --/D mean g-band forced-warp PSF flux 
    g_wrp_psf_fluxerr real, --/U Jy --/D error on mean g-band forced-warp PSF flux 
    g_wrp_psf_nphot integer, --/D number of measurements used for g_wrp_psf_flux (excluding outliers)
    g_wrp_aper_flux real, --/U Jy --/D mean g-band forced-warp seeing-adapted aperture flux 
    g_wrp_aper_fluxerr real, --/U Jy --/D error on mean g-band forced-warp seeing-adapted aperture flux 
    g_wrp_aper_nphot integer, --/D number of measurements used for g_wrp_aper_flux (excluding outliers)
    g_wrp_kron_flux real, --/U Jy --/D mean g-band forced-warp Kron flux 
    g_wrp_kron_fluxerr real, --/U Jy --/D error on mean g-band forced-warp Kron flux 
    g_wrp_kron_nphot integer, --/D number of measurements used for g_wrp_kron_flux (excluding outliers)
    g_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.ginfoFlag4)
    g_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.ng)
    g_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary skycells)
    g_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter (including primary & secondary skycells)
    g_nstack integer, --/D number of stack measurements (primary and secondary)
    g_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    g_psfqf real, --/D g-band PSF coverage factor
    g_psfqfperf real, --/D g-band PSF weighted fraction of pixels totally unmasked
    r_chp_psf real, --/U mag --/D mean r-band chip PSF magnitude 
    r_chp_psf_err real, --/U mag --/D error on mean r-band chip PSF magnitude 
    r_chp_psf_nphot integer, --/D number of measurements used for r_chp_psf (excluding outliers)
    r_chp_aper real, --/U mag --/D mean r-band chip seeing-adapted aperture magnitude 
    r_chp_aper_err real, --/U mag --/D error on mean r-band chip seeing-adapted aperture magnitude 
    r_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    r_chp_kron real, --/U mag --/D mean r-band chip Kron magnitude 
    r_chp_kron_err real, --/U mag --/D error on mean r-band chip Kron magnitude 
    r_chp_kron_nphot integer, --/D number of measurements used for r_chp_kron (excluding outliers)
    r_stk_psf_flux real, --/U Jy --/D best r-band stack PSF flux 
    r_stk_psf_fluxerr real, --/U Jy --/D error on best r-band stack PSF flux 
    r_stk_psf_nphot integer, --/D number of measurements used for r_stk_psf_flux (excluding outliers)
    r_stk_aper_flux real, --/U Jy --/D r-band stack seeing-adapted aperture flux 
    r_stk_aper_fluxerr real, --/U Jy --/D error on r-band stack seeing-adapted aperture flux 
    r_stk_aper_nphot integer, --/D number of measurements used for r_stk_aper_flux (excluding outliers)
    r_stk_kron_flux real, --/U Jy --/D r-band stack Kron flux from same stack as 'best' PSF above 
    r_stk_kron_fluxerr real, --/U Jy --/D error on r-band stack Kron flux from same stack as 'best' PSF above 
    r_stk_kron_nphot integer, --/D number of measurements used for r_stk_kron_flux (excluding outliers)
    r_wrp_psf_flux real, --/U Jy --/D mean r-band forced-warp PSF flux 
    r_wrp_psf_fluxerr real, --/U Jy --/D error on mean r-band forced-warp PSF flux 
    r_wrp_psf_nphot integer, --/D number of measurements used for r_wrp_psf_flux (excluding outliers)
    r_wrp_aper_flux real, --/U Jy --/D mean r-band forced-warp seeing-adapted aperture flux 
    r_wrp_aper_fluxerr real, --/U Jy --/D error on mean r-band forced-warp seeing-adapted aperture flux 
    r_wrp_aper_nphot integer, --/D number of measurements used for r_wrp_aper_flux (excluding outliers)
    r_wrp_kron_flux real, --/U Jy --/D mean r-band forced-warp Kron flux 
    r_wrp_kron_fluxerr real, --/U Jy --/D error on mean r-band forced-warp Kron flux 
    r_wrp_kron_nphot integer, --/D number of measurements used for r_wrp_kron_flux (excluding outliers)
    r_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.rinfoFlag4)
    r_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.nr)
    r_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary skycells)
    r_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter (including primary & secondary skycells)
    r_nstack integer, --/D number of stack measurements (primary and secondary)
    r_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    r_psfqf real, --/D r-band PSF coverage factor
    r_psfqfperf real, --/D r-band PSF weighted fraction of pixels totally unmasked
    i_chp_psf real, --/U mag --/D mean i-band chip PSF magnitude 
    i_chp_psf_err real, --/U mag --/D error on mean i-band chip PSF magnitude 
    i_chp_psf_nphot integer, --/D number of measurements used for i_chp_psf (excluding outliers)
    i_chp_aper real, --/U mag --/D mean i-band chip seeing-adapted aperture magnitude 
    i_chp_aper_err real, --/U mag --/D error on mean i-band chip seeing-adapted aperture magnitude 
    i_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    i_chp_kron real, --/U mag --/D mean i-band chip Kron magnitude 
    i_chp_kron_err real, --/U mag --/D error on mean i-band chip Kron magnitude 
    i_chp_kron_nphot integer, --/D number of measurements used for i_chp_kron (excluding outliers)
    i_stk_psf_flux real, --/U Jy --/D best i-band stack PSF flux 
    i_stk_psf_fluxerr real, --/U Jy --/D error on best i-band stack PSF flux 
    i_stk_psf_nphot integer, --/D number of measurements used for i_stk_psf_flux (excluding outliers)
    i_stk_aper_flux real, --/U Jy --/D i-band stack seeing-adapted aperture flux 
    i_stk_aper_fluxerr real, --/U Jy --/D error on i-band stack seeing-adapted aperture flux 
    i_stk_aper_nphot integer, --/D number of measurements used for i_stk_aper_flux (excluding outliers)
    i_stk_kron_flux real, --/U Jy --/D i-band stack Kron flux from same stack as 'best' PSF above 
    i_stk_kron_fluxerr real, --/U Jy --/D error on i-band stack Kron flux from same stack as 'best' PSF above 
    i_stk_kron_nphot integer, --/D number of measurements used for i_stk_kron_flux (excluding outliers)
    i_wrp_psf_flux real, --/U Jy --/D mean i-band forced-warp PSF flux 
    i_wrp_psf_fluxerr real, --/U Jy --/D error on mean i-band forced-warp PSF flux 
    i_wrp_psf_nphot integer, --/D number of measurements used for i_wrp_psf_flux (excluding outliers)
    i_wrp_aper_flux real, --/U Jy --/D mean i-band forced-warp seeing-adapted aperture flux 
    i_wrp_aper_fluxerr real, --/U Jy --/D error on mean i-band forced-warp seeing-adapted aperture flux 
    i_wrp_aper_nphot integer, --/D number of measurements used for i_wrp_aper_flux (excluding outliers)
    i_wrp_kron_flux real, --/U Jy --/D mean i-band forced-warp Kron flux 
    i_wrp_kron_fluxerr real, --/U Jy --/D error on mean i-band forced-warp Kron flux 
    i_wrp_kron_nphot integer, --/D number of measurements used for i_wrp_kron_flux (excluding outliers)
    i_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.iinfoFlag4)
    i_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.ni)
    i_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary skycells)
    i_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter (including primary & secondary skycells)
    i_nstack integer, --/D number of stack measurements (primary and secondary)
    i_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    i_psfqf real, --/D i-band PSF coverage factor
    i_psfqfperf real, --/D i-band PSF weighted fraction of pixels totally unmasked
    z_chp_psf real, --/U mag --/D mean z-band chip PSF magnitude 
    z_chp_psf_err real, --/U mag --/D error on mean z-band chip PSF magnitude 
    z_chp_psf_nphot integer, --/D number of measurements used for z_chp_psf (excluding outliers)
    z_chp_aper real, --/U mag --/D mean z-band chip seeing-adapted aperture magnitude 
    z_chp_aper_err real, --/U mag --/D error on mean z-band chip seeing-adapted aperture magnitude 
    z_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    z_chp_kron real, --/U mag --/D mean z-band chip Kron magnitude 
    z_chp_kron_err real, --/U mag --/D error on mean z-band chip Kron magnitude 
    z_chp_kron_nphot integer, --/D number of measurements used for z_chp_kron (excluding outliers)
    z_stk_psf_flux real, --/U Jy --/D best z-band stack PSF flux 
    z_stk_psf_fluxerr real, --/U Jy --/D error on best z-band stack PSF flux 
    z_stk_psf_nphot integer, --/D number of measurements used for z_stk_psf_flux (excluding outliers)
    z_stk_aper_flux real, --/U Jy --/D z-band stack seeing-adapted aperture flux 
    z_stk_aper_fluxerr real, --/U Jy --/D error on z-band stack seeing-adapted aperture flux 
    z_stk_aper_nphot integer, --/D number of measurements used for z_stk_aper_flux (excluding outliers)
    z_stk_kron_flux real, --/U Jy --/D z-band stack Kron flux from same stack as 'best' PSF above 
    z_stk_kron_fluxerr real, --/U Jy --/D error on z-band stack Kron flux from same stack as 'best' PSF above 
    z_stk_kron_nphot integer, --/D number of measurements used for z_stk_kron_flux (excluding outliers)
    z_wrp_psf_flux real, --/U Jy --/D mean z-band forced-warp PSF flux 
    z_wrp_psf_fluxerr real, --/U Jy --/D error on mean z-band forced-warp PSF flux 
    z_wrp_psf_nphot integer, --/D number of measurements used for z_wrp_psf_flux (excluding outliers)
    z_wrp_aper_flux real, --/U Jy --/D mean z-band forced-warp seeing-adapted aperture flux 
    z_wrp_aper_fluxerr real, --/U Jy --/D error on mean z-band forced-warp seeing-adapted aperture flux 
    z_wrp_aper_nphot integer, --/D number of measurements used for z_wrp_aper_flux (excluding outliers)
    z_wrp_kron_flux real, --/U Jy --/D mean z-band forced-warp Kron flux 
    z_wrp_kron_fluxerr real, --/U Jy --/D error on mean z-band forced-warp Kron flux 
    z_wrp_kron_nphot integer, --/D number of measurements used for z_wrp_kron_flux (excluding outliers)
    z_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.zinfoFlag4)
    z_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.nz)
    z_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary skycells)
    z_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter (including primary & secondary skycells)
    z_nstack integer, --/D number of stack measurements (primary and secondary)
    z_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    z_psfqf real, --/D z-band PSF coverage factor
    z_psfqfperf real, --/D z-band PSF weighted fraction of pixels totally unmasked
    y_chp_psf real, --/U mag --/D mean y-band chip PSF magnitude 
    y_chp_psf_err real, --/U mag --/D error on mean y-band chip PSF magnitude 
    y_chp_psf_nphot integer, --/D number of measurements used for y_chp_psf (excluding outliers)
    y_chp_aper real, --/U mag --/D mean y-band chip seeing-adapted aperture magnitude 
    y_chp_aper_err real, --/U mag --/D error on mean y-band chip seeing-adapted aperture magnitude 
    y_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    y_chp_kron real, --/U mag --/D mean y-band chip Kron magnitude 
    y_chp_kron_err real, --/U mag --/D error on mean y-band chip Kron magnitude 
    y_chp_kron_nphot integer, --/D number of measurements used for y_chp_kron (excluding outliers)
    y_stk_psf_flux real, --/U Jy --/D best y-band stack PSF flux 
    y_stk_psf_fluxerr real, --/U Jy --/D error on best y-band stack PSF flux 
    y_stk_psf_nphot integer, --/D number of measurements used for y_stk_psf_flux (excluding outliers)
    y_stk_aper_flux real, --/U Jy --/D y-band stack seeing-adapted aperture flux 
    y_stk_aper_fluxerr real, --/U Jy --/D error on y-band stack seeing-adapted aperture flux 
    y_stk_aper_nphot integer, --/D number of measurements used for y_stk_aper_flux (excluding outliers)
    y_stk_kron_flux real, --/U Jy --/D y-band stack Kron flux from same stack as 'best' PSF above 
    y_stk_kron_fluxerr real, --/U Jy --/D error on y-band stack Kron flux from same stack as 'best' PSF above 
    y_stk_kron_nphot integer, --/D number of measurements used for y_stk_kron_flux (excluding outliers)
    y_wrp_psf_flux real, --/U Jy --/D mean y-band forced-warp PSF flux 
    y_wrp_psf_fluxerr real, --/U Jy --/D error on mean y-band forced-warp PSF flux 
    y_wrp_psf_nphot integer, --/D number of measurements used for y_wrp_psf_flux (excluding outliers)
    y_wrp_aper_flux real, --/U Jy --/D mean y-band forced-warp seeing-adapted aperture flux 
    y_wrp_aper_fluxerr real, --/U Jy --/D error on mean y-band forced-warp seeing-adapted aperture flux 
    y_wrp_aper_nphot integer, --/D number of measurements used for y_wrp_aper_flux (excluding outliers)
    y_wrp_kron_flux real, --/U Jy --/D mean y-band forced-warp Kron flux 
    y_wrp_kron_fluxerr real, --/U Jy --/D error on mean y-band forced-warp Kron flux 
    y_wrp_kron_nphot integer, --/D number of measurements used for y_wrp_kron_flux (excluding outliers)
    y_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.yinfoFlag4)
    y_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.ny)
    y_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary skycells)
    y_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter (including primary & secondary skycells)
    y_nstack integer, --/D number of stack measurements (primary and secondary)
    y_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    y_psfqf real, --/D y-band PSF coverage factor
    y_psfqfperf real, --/D y-band PSF weighted fraction of pixels totally unmasked
    catid_objid bigint NOT NULL, --/D computed as (catid << 32) & objid. Equivalent to StackObjectThin.ippObjID
    extid_hi_lo bigint --/D computed as (extid_hi << 32) & extid_lo. Equivalent to StackObjectThin.ObjID
);



--
-- Name: dr19_positioner_status; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_positioner_status (
----------------------------------------------------------------------
--/H Table of possible positioner statuses
----------------------------------------------------------------------
    pk integer NOT NULL, --/D Unique identifier
    label text --/D Status (OK or KO)
);



--
-- Name: dr19_revised_magnitude; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_revised_magnitude (
----------------------------------------------------------------------
--/H This table stores magnitude information for a target. Optical magnitudes that are not selected from SDSS photometry have been converted to the SDSS system.
--/T Entries in this revised_magnitude table only exist if there was an issue with
--/T the values in the original magnitude table. Therefore: if a carton_to_target_pk
--/T exists in this table, the values in this table should be used instead.
----------------------------------------------------------------------
    carton_to_target_pk bigint, --/D The primary key of the target in the dr19_carton_to_target table.
    revised_magnitude_pk bigint NOT NULL, --/D The primary key. A sequential identifier. --/D The primary key. A sequential identifier.
    g double precision, --/U mag --/D The optical g magnitude, AB. 
    r double precision, --/U mag --/D The optical r magnitude, AB. 
    i double precision, --/U mag --/D The optical i magnitude, AB. 
    h real, --/U mag --/D The IR H magnitude, Vega. 
    bp real, --/U mag --/D The Gaia BP magnitude, Vega. 
    rp real, --/U mag --/D The Gaia RP magnitude, Vega. 
    z double precision, --/U mag --/D The optical z magnitude, AB. 
    j real, --/U mag --/D The IR J magnitude, Vega. 
    k real, --/U mag --/D The IR K magnitude, Vega. 
    gaia_g real, --/U mag --/D The Gaia G magnitude, Vega. 
    optical_prov text --/D The providence/origin of the optical magnitudes.
);



--
-- Name: dr19_sagitta; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sagitta (
----------------------------------------------------------------------
--/H Catalog of pre-main-sequence stars derived from Gaia DR2 and 2MASS from McBride et al. (2021), their Table 4. For complete details, please see the original paper: https://iopscience.iop.org/article/10.3847/1538-3881/ac2432
----------------------------------------------------------------------
    source_id bigint NOT NULL, --/D Gaia DR2 unique identifier 
    ra double precision, --/U degrees --/D Right ascension 
    "dec" double precision, --/U degrees --/D Declination 
    av real, --/U mag --/D Predicted extinction 
    yso real, --/D Pre-main-sequence probability 
    yso_std real, --/D Error on pre-main-sequence probability 
    age real, --/U log yrs --/D Age 
    age_std real --/U log yrs --/D Error on age 
);



--
-- Name: dr19_sdss_apogeeallstarmerge_r13; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_apogeeallstarmerge_r13 (
----------------------------------------------------------------------
--/H List of APOGEE DR16 stars for RV followup
----------------------------------------------------------------------
    apogee_id text NOT NULL, --/D 2MASS style ID from APOGEE DR16 
    nvisits smallint, --/D Number of visits into combined spectra, accross all allStar entries for the star 
    nentries integer, --/D Number of unique allStar entries for the star 
    ra double precision, --/U degrees --/D Right ascension (J2000) 
    "dec" double precision, --/U degrees --/D Declination (J2000) 
    glon double precision, --/U degrees --/D Galactic longitude 
    glat double precision, --/U degrees --/D Galactic latitude 
    pmra double precision, --/U mas/yr --/D proper motion in RA 
    pmdec double precision, --/U mas/yr --/D proper motion in DEC 
    pm_src text, --/D source of proper motion (e.g. gaia) 
    j real, --/U bad=99] [mag --/D 2MASS J mag 
    j_err real, --/U mag --/D Uncertainty in 2MASS J mag 
    h real, --/U bad=99] [mag --/D 2MASS H mag 
    h_err real, --/U mag --/D Uncertainty in 2MASS H mag 
    k real, --/U bad=99] [mag --/D 2MASS Ks mag 
    k_err real, --/U mag --/D Uncertainty in 2MASS Ks mag 
    ak real, --/U mag --/D K-band extinction adopted for targetting 
    vhelio_avg real, --/U km/s --/D Average radial velocity, weighted by S/N, rederived to reflect all entries 
    vhelio_err real, --/U km/s --/D Uncertainty in VHELIO_AVG from the S/N-weighted individual RVs, rederived to reflect all entries 
    vscatter real, --/U km/s --/D Scatter of individual visit RVs around average, rederived to reflect all entries 
    sig_rvvar real, --/D Measure of the significance of the star's RV variability (see Troup, et. al 2016) 
    baseline real, --/U days --/D Temporal baseline of the observations (JD_last-JD-first) 
    mean_fiber real, --/D The mean fiberID of all of the star's visits 
    sig_fiber real, --/D The standard deviation of the fiberID of all of the star's visits 
    apstar_ids text, --/D List of APSTAR_ID from each of the star's allStar entries 
    visits text, --/D List of VISIT_ID from eeach of the star's allVisit entries 
    fields text, --/D List of FIELD flags from each of the star's allStar entries 
    surveys text, --/D List of SURVEY flags from each of the star's allStar entries 
    telescopes text, --/D List of TELESCOPE flags from each of the star's allStar entries 
    targflags text, --/D Verbose/text form of TARGFLAG combined from all entries 
    starflags text, --/D Verbose/text form of STARFLAG combined from all entries 
    aspcapflags text, --/D Verbose/text form of ASPCAPFLAG combined from all entries 
    teff real, --/U K --/D Teff from ASPCAP analysis of combined spectra (from PARAM) averaged across entries 
    teff_err real, --/U K --/D Teff uncertainty (from PARAM_COV) 
    logg real, --/U dex --/D log g from ASPCAP analysis of combined spectrum (from PARAM) averaged across entries 
    logg_err real, --/U dex --/D log g uncertainty (from PARAM_COV) 
    feh real, --/U dex --/D metallicity from ASPCAP analysis of combined spectrum (from PARAM) averaged across entries 
    feh_err real, --/U dex --/D feh uncertainty (from PARAM_COV) 
    startype text, --/D Best guess of star's evolutionary state based on stellar parameters or external catalogs (RC=red clump, RG=red giant, SG = subgiant, MS=dwarf, PMS=pre-main sequence) 
    vjitter real, --/U km/s --/D Atmospheric RV jitter derived from log g using the relationship derived in Hekker, et. al 2008. 
    dist real, --/U pc --/D Derived or given distance to the star 
    dist_err real, --/U pc --/D uncertainy of the distance 
    dist_src text, --/D Source of the star's distance measurement (e.g. gaia=derived from gaia parallax) 
    mstar real, --/D Derived or given stellar mass (Solar Mass)
    mstar_err real, --/U Solar Mass --/D Uncertainty of the Derived stellar mass 
    rstar real, --/U Solar Radius --/D Derived stellar radius 
    rstar_err real, --/U Solar Radius --/D Uncertainty of the Derived stellar radius 
    mstar_src text, --/D Source of the star's Mass (if not derived) 
    designation text --/D identifier 
);



--
-- Name: dr19_sdss_dr13_photoobj_primary; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_dr13_photoobj_primary (
----------------------------------------------------------------------
--/H Columns from the PhotoPrimary Table of SDSS DR13.
----------------------------------------------------------------------
    objid bigint NOT NULL, --/D Unique SDSS identifier composed from skyVersion,rerun,run,camcol,field,obj 
    ra double precision, --/U degrees --/D Right ascension 
    "dec" double precision --/U degrees --/D Declination 
);



--
-- Name: dr19_sdss_dr16_qso; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_dr16_qso (
----------------------------------------------------------------------
--/H SDSS Data Release 16 Quasar Catalog (Lyke et al. 2020). For complete details, please see the original paper: https://ui.adsabs.harvard.edu/abs/2020ApJS..250....8L/abstract
--/T Description derived from SDSS datamodel:
--/T https://data.sdss.org/datamodel/files/BOSS_QSO/DR16Q/DR16Q_v4.html
----------------------------------------------------------------------
    sdss_name text, --/D SDSS-DR16 designation (hhmmss.ss+-ddmmss.s, J2000) 
    ra double precision, --/U degrees --/D Right ascension in decimal degrees (J2000) 
    "dec" double precision, --/U degrees --/D Declination in decimal degrees (J2000) 
    plate integer, --/D Spectroscopic plate number 
    mjd integer, --/U day --/D Modified Julian day of the spectroscopic observation 
    fiberid integer, --/D Fiber ID number 
    autoclass_pqn text, --/D Object classification post-QuasarNET 
    autoclass_dr14q text, --/D Object classification based only on the DR14Q algorithm 
    is_qso_qn integer, --/D Binary flag for QuasarNET quasar identification 
    z_qn double precision, --/D Systemic redshift from QuasarNET 
    random_select integer, --/D Binary flag indicating objects selected for random visual inspection 
    z_10k double precision, --/D Redshift from visual inspection in random set 
    z_conf_10k integer, --/D Confidence rating for visual inspection redshift in random set 
    pipe_corr_10k integer, --/D Binary flag indicating if the automated pipeline classification and redshift were correct in the random set 
    is_qso_10k integer, --/D Binary flag for random set quasar identification 
    thing_id bigint, --/D SDSS identifier 
    z_vi double precision, --/D Visual inspection redshift 
    z_conf integer, --/D Confidence rating for visual inspection redshift 
    class_person integer, --/D Object classification from visual inspection 
    z_dr12q double precision, --/D Redshift taken from DR12Q visual inspection 
    is_qso_dr12q integer, --/D Flag indicating if an object was a quasar in DR12Q 
    z_dr7q_sch double precision, --/D Redshift taken from DR7Q Schneider et al (2010) catalog 
    is_qso_dr7q integer, --/D Flag indicating if an object was a quasar in DR7Q 
    z_dr6q_hw double precision, --/D Redshift taken from DR6-based Hewett and Wild (2010) catalog 
    z_dr7q_hw double precision, --/D Redshift using Hewett and Wild (2010) updates for DR7Q sources from the Shen et al. (2011) catalog 
    is_qso_final integer, --/D Flag indicating quasars to be included in final catalog 
    z double precision, --/D Best available redshift taken from Z_VI, Z_PIPE, Z_DR12Q, Z_DR7Q_SCH, Z_DR6Q_HW, and Z_10K 
    source_z text, --/D Origin of the reported redshift in Z 
    z_pipe double precision, --/D SDSS automated pipeline redshift 
    zwarning integer, --/D Quality flag on the pipeline redshift estimate 
    objid text, --/D SDSS object identification number 
    z_pca double precision, --/D PCA-derived systemic redshift from redvsblue 
    zwarn_pca bigint, --/D Warning flag for redvsblue redshift 
    deltachi2_pca double precision, --/D Delta χ2 for PCA redshift vs. cubic continuum fit 
    z_halpha double precision, --/D PCA line redshift for Halpha from redvsblue 
    zwarn_halpha bigint, --/D Warning flag for Halpha redshift 
    deltachi2_halpha double precision, --/D Delta χ2 for Halpha line redshift vs. cubic continuum fit 
    z_hbeta double precision, --/D PCA line redshift for Hbeta from redvsblue 
    zwarn_hbeta bigint, --/D Warning flag for Hbeta redshift 
    deltachi2_hbeta double precision, --/D Delta χ2 for Hbeta line redshift vs. cubic continuum fit 
    z_mgii double precision, --/D PCA line redshift for Mg II 2799AA from redvsblue 
    zwarn_mgii bigint, --/D Warning flag for Mg II 2799AA redshift 
    deltachi2_mgii double precision, --/D Delta χ2 for Mg II 2799AA line redshift vs. cubic continuum fit 
    z_ciii double precision, --/D PCA line redshift for C III] 1908AA from redvsblue 
    zwarn_ciii bigint, --/D Warning flag for C III] 1908AA redshift 
    deltachi2_ciii double precision, --/D Delta χ2 for C III] 1908AA line redshift vs. cubic continuum fit 
    z_civ double precision, --/D PCA line redshift for C IV 1549AA from redvsblue 
    zwarn_civ bigint, --/D Warning flag for C IV 1549AA redshift 
    deltachi2_civ double precision, --/D Delta χ2 for C IV 1549AA line redshift vs. cubic continuum fit 
    z_lya double precision, --/D PCA line redshift for Lyalpha from redvsblue 
    zwarn_lya bigint, --/D Warning flag for Lyalpha redshift 
    deltachi2_lya double precision, --/D Delta χ2 for Lyalpha line redshift vs. cubic continuum fit 
    z_lyawg real, --/D PCA systemic redshift from redvsblue with a masked Lyalpha emission line and forest 
    z_dla text, --/D Redshift for damped Lyalpha features 
    nhi_dla text, --/U log(cm**-2) --/D Absorber column density for damped Lyalpha features 
    conf_dla text, --/D Confidence of detection for damped Lyalpha features 
    bal_prob real, --/D BAL probability 
    bi_civ double precision, --/U km/s --/D BALnicity index for C IV 1549AA region 
    err_bi_civ double precision, --/U km/s --/D Uncertainty of BI for C IV 1549AA region 
    ai_civ double precision, --/U km/s --/D Absorption index for C IV 1549AA region 
    err_ai_civ double precision, --/U km/s --/D Uncertainty of absorption index for C IV 1549AA region 
    bi_siiv double precision, --/U km/s --/D BALnicity index for Si IV 1396AA region 
    err_bi_siiv double precision, --/U km/s --/D Uncertainty of BI for Si IV 1396AA region 
    ai_siiv double precision, --/U km/s --/D Absorption index for Si IV 1396AA region 
    err_ai_siiv double precision, --/U km/s --/D Uncertainty of absorption index for Si IV 1396AA region 
    boss_target1 bigint, --/D BOSS target selection bitmask for main survey 
    eboss_target0 bigint, --/D Target selection bitmask for the eBOSS pilot survey (SEQUELS) 
    eboss_target1 bigint, --/D eBOSS target selection bitmask 
    eboss_target2 bigint, --/D eBOSS target selection bitmask 
    ancillary_target1 bigint, --/D BOSS target selection bitmask for ancillary programs 
    ancillary_target2 bigint, --/D BOSS target selection bitmask for ancillary programs 
    nspec_sdss integer, --/D Number of additional observations from SDSS-I/II 
    nspec_boss integer, --/D Number of additional observations from BOSS/eBOSS 
    nspec integer, --/D Total number of additional observations 
    plate_duplicate text, --/D Spectroscopic plate number of duplicate spectroscopic observations 
    mjd_duplicate text, --/D Spectroscopic MJD of duplicate spectroscopic observations 
    fiberid_duplicate text, --/D Fiber ID number of duplicate spectrocscopic observations. 
    spectro_duplicate text, --/D Spectroscopic instrument for each duplicate, 1=SDSS, 2=(e)BOSS 
    skyversion integer, --/D SDSS photometric sky version number 
    run_number integer, --/D SDSS photometric run number 
    rerun_number text, --/D SDSS photometric rerun number 
    camcol_number integer, --/D SDSS photometric camera column 
    field_number integer, --/D SDSS photometric field number 
    id_number integer, --/D SDSS photometric ID number 
    lambda_eff double precision, --/U Angstrom --/D Wavelength to optimize hold location for 
    zoffset double precision, --/U um --/D Backstopping offset distance 
    xfocal double precision, --/U mm --/D Hole x-axis position in focal plane 
    yfocal double precision, --/U mm --/D Hole y-axis position in focal plane 
    chunk text, --/D Name of tiling chunk (from platelist product) 
    tile integer, --/D Tile number 
    platesn2 double precision, --/D Overall (S/N)^2 measure for plate, minimum of all 4 cameras 
    psfflux_u real,
    psfflux_g real,
    psfflux_r real,
    psfflux_i real,
    psfflux_z real,
    psfflux_ivar_u double precision,
    psfflux_ivar_g double precision,
    psfflux_ivar_r double precision,
    psfflux_ivar_i double precision,
    psfflux_ivar_z double precision,
    psfmag_u real,
    psfmag_g real,
    psfmag_r real,
    psfmag_i real,
    psfmag_z real,
    psfmagerr_u double precision,
    psfmagerr_g double precision,
    psfmagerr_r double precision,
    psfmagerr_i double precision,
    psfmagerr_z double precision,
    extinction_u real,
    extinction_g real,
    extinction_r real,
    extinction_i real,
    extinction_z real,
    m_i double precision, --/U mag --/D Absolute i-band magnitude. Assuming H0 = 67.6 km/s/Mpc, OmegaM=0.31, OmegaL=0.69, Omega_r=9.11e-5. K-corrections taken from Table 4 of Richards et al. (2006). Z_PCA used for redshifts 
    sn_median_all double precision, --/D Median S/N value of all good spectroscopic pixels 
    galex_matched integer, --/D Matching flag for GALEX 
    fuv double precision, --/U nMgy --/D FUV flux from GALEX 
    fuv_ivar double precision, --/U nMgy**-2 --/D Inverse variance of FUV flux from GALEX 
    nuv double precision, --/U nMgy --/D NUV flux from GALEX 
    nuv_ivar double precision, --/U nMgy**-2 --/D Inverse variance of NUV flux from GALEX 
    ukidss_matched integer, --/D Matching flag for UKIDSS 
    yflux double precision, --/U W m-2 Hz-1 --/D Y-band flux density from UKIDSS 
    yflux_err double precision, --/U W m-2 Hz-1 --/D Error in Y-band flux density from UKIDSS 
    jflux double precision, --/U W m-2 Hz-1 --/D J-band flux density from UKIDSS 
    jflux_err double precision, --/U W m-2 Hz-1 --/D Error in J-band flux density from UKIDSS 
    hflux double precision, --/U W m-2 Hz-1 --/D H-band flux density from UKIDSS 
    hflux_err double precision, --/U W m-2 Hz-1 --/D Error in H-band flux density from UKIDSS 
    kflux double precision, --/U W m-2 Hz-1 --/D K-band flux density from UKIDSS 
    kflux_err double precision, --/U W m-2 Hz-1 --/D Error in K-band flux density from UKIDSS 
    w1_flux real, --/U nMgy --/D WISE flux in W1-band (Vega) 
    w1_flux_ivar real, --/U nMgy**-2 --/D Inverse variance in W1-band (Vega) 
    w1_mag real, --/U mag --/D W1-band magnitude (Vega) 
    w1_mag_err real, --/U mag --/D W1-band uncertainty in magnitude (Vega) 
    w1_chi2 real, --/D Profile-weighed χ2 
    w1_flux_snr real, --/D S/N from flux and inverse variance 
    w1_src_frac real, --/D Profile-weighted number of exposures in coadd 
    w1_ext_flux real, --/U nMgy --/D Profile-weighted flux from other sources 
    w1_ext_frac real, --/D Profile-weighted fraction of flux from other sources (blendedness measure) 
    w1_npix integer, --/D Number of pixels in fit 
    w2_flux real, --/U nMgy --/D WISE flux in W2-band (Vega) 
    w2_flux_ivar real, --/U nMgy**-2 --/D Inverse variance in W2-band (Vega) 
    w2_mag real, --/U mag --/D W2-band magnitude (Vega) 
    w2_mag_err real, --/U mag --/D W2-band uncertainty in magnitude (Vega) 
    w2_chi2 real, --/D Profile-weighed χ2 
    w2_flux_snr real, --/D S/N from flux and inverse variance 
    w2_src_frac real, --/D Profile-weighted number of exposures in coadd 
    w2_ext_flux real, --/U nMgy --/D Profile-weighted flux from other sources 
    w2_ext_frac real, --/D Profile-weighted fraction of flux from other sources (blendedness measure) 
    w2_npix integer, --/D Number of pixels in fit 
    first_matched integer, --/D Matching flag for FIRST 
    first_flux double precision, --/U mJy --/D FIRST peak flux density at 20 cm 
    first_snr double precision, --/D FIRST flux density S/N 
    sdss2first_sep double precision, --/D SDSS-FIRST separation in arcsec 
    jmag double precision, --/U mag --/D 2MASS J-band magnitude (Vega) 
    jmag_err double precision, --/U mag --/D 2MASS Error in J-band magnitude 
    jsnr double precision, --/D 2MASS J-band S/N 
    jrdflag integer, --/D 2MASS J-band photometry flag 
    hmag double precision, --/U mag --/D 2MASS H-band magnitude (Vega) 
    hmag_err double precision, --/U mag --/D 2MASS Error in H-band magnitude 
    hsnr double precision, --/D 2MASS H-band S/N 
    hrdflag integer, --/D 2MASS H-band photometry flag 
    kmag double precision, --/U mag --/D 2MASS Ks-band magnitude (Vega) 
    kmag_err double precision, --/U mag --/D 2MASS Error in Ks-band magnitude 
    ksnr double precision, --/D 2MASS Ks-band S/N 
    krdflag integer, --/D 2MASS Ks-band photometry flag 
    sdss2mass_sep double precision, --/U arcsec --/D SDSS-2MASS separation 
    rass2rxs_id text, --/D ROSAT ID 
    rass2rxs_ra double precision, --/U degrees --/D Right ascension of the ROSAT source in decimal degrees (J2000) 
    rass2rxs_dec double precision, --/U degrees --/D Declination of the ROSAT source in decimal degrees (J2000) 
    rass2rxs_src_flux real, --/U erg/s/cm2 --/D ROSAT source flux in 0.5-2.0 keV band (G = 2.4, dered) 
    rass2rxs_src_flux_err real, --/U erg/s/cm2 --/D ROSAT source flux error in 0.5-2.0 keV band (G = 2.4, dered) 
    sdss2rosat_sep double precision, --/U arcsec --/D SDSS-ROSAT separation 
    xmm_src_id bigint, --/D XMM source ID 
    xmm_ra double precision, --/U degrees --/D Right ascension for XMM source in decimal degrees (J2000) 
    xmm_dec double precision, --/U degrees --/D Declination for XMM source in decimal degrees (J2000) 
    xmm_soft_flux real, --/U erg/s/cm2 --/D Soft (0.2-2.0 keV) X-ray flux from XMM-Newton 
    xmm_soft_flux_err real, --/U erg/s/cm2 --/D Error on soft X-ray flux from XMM-Newton 
    xmm_hard_flux real, --/U erg/s/cm2 --/D Hard (2.0-12.0 keV) X-ray flux from XMM-Newton 
    xmm_hard_flux_err real, --/U erg/s/cm2 --/D Error on hard X-ray flux from XMM-Newton 
    xmm_total_flux real, --/U erg/s/cm2 --/D Total (0.2-12.0 keV) X-ray flux from XMM-Newton 
    xmm_total_flux_err real, --/U erg/s/cm2 --/D Error on total X-ray flux from XMM-Newton 
    xmm_total_lum real, --/U erg/s --/D Total (0.2-12.0 keV) X-ray luminosity from XMM-Newton 
    sdss2xmm_sep double precision, --/U arcsec --/D SDSS-XMM-Newton separation 
    gaia_matched integer, --/D Gaia matching flag 
    gaia_designation text, --/D Gaia designation, includes data release and source ID in that release 
    gaia_ra double precision, --/U degrees --/D Gaia barycentric right ascension in decimal degrees (J2015.5) 
    gaia_dec double precision, --/U degrees --/D Gaia barycentric declination in decimal degrees (J2015.5) 
    gaia_parallax double precision, --/U mas --/D Absolute stellar parallax 
    gaia_parallax_err double precision, --/U mas**-2 --/D Inverse variance of the stellar parallax 
    gaia_pm_ra double precision, --/U mas/yr --/D Proper motion in right ascension 
    gaia_pm_ra_err double precision, --/U (mas/yr)**-2 --/D Inverse variance of the proper motion in right ascension 
    gaia_pm_dec double precision, --/U mas/yr --/D Proper motion in declination 
    gaia_pm_dec_err double precision, --/U (mas/yr)**-2 --/D Inverse variance of the proper motion in declination 
    gaia_g_mag double precision, --/U mag --/D Mean magnitude in G-band (Vega) 
    gaia_g_flux_snr double precision, --/D Mean flux over standard deviation in G-band 
    gaia_bp_mag double precision, --/U mag --/D Mean magnitude in BP-band (Vega) 
    gaia_bp_flux_snr double precision, --/D Mean flux over standard deviation in BP-band 
    gaia_rp_mag double precision, --/U mag --/D Mean magnitude in RP-band (Vega) 
    gaia_rp_flux_snr double precision, --/D Mean flux over standard deviation in RP-band 
    sdss2gaia_sep double precision, --/U arcsec --/D SDSS-Gaia separation 
    pk bigint NOT NULL --/D Added for convenience - serial integer primary key 
);



--
-- Name: dr19_sdss_dr16_specobj; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_dr16_specobj (
----------------------------------------------------------------------
--/H This table contains the list of all SDSS optical spectra for a given data release, with associated parameters from the 2D and 1D pipelines for each. The table contains both the BOSS and SDSS spectrograph data. The database representation is derived from the flat file information described here: <a href="https://data.sdss.org/datamodel/files/SPECTRO_REDUX/specObj.html">https://data.sdss.org/datamodel/files/SPECTRO_REDUX/specObj.html</a> Note: the order of the columns in this documentation may not match the order of the columns in the database table.
----------------------------------------------------------------------
    specobjid numeric(20,0) NOT NULL, --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D (same as SkyServer version) 
    bestobjid bigint, --/D Unique database ID of (recommended) position-based photometric match based on RUN, RERUN, CAMCOl, FIELD, ID (same as SkyServer version) 
    fluxobjid bigint, --/D Unique database ID of flux-based photometric match based on RUN, RERUN, CAMCOl, FIELD, ID (same as SkyServer version) 
    targetobjid bigint, --/D Unique database ID of targeting object based on RUN, RERUN, CAMCOl, FIELD, ID (same as SkyServer version) 
    plateid numeric(20,0), --/D Unique database ID of plate based on PLATE, MJD, RUN2D (same as SkyServer version) 
    scienceprimary smallint, --/D Set to 1 for primary observation of object, 0 otherwise 
    sdssprimary smallint, --/D Set to 1 for primary SDSS spectrograph observation of object, 0 otherwise 
    legacyprimary smallint, --/D Set to 1 for primary SDSS Legacy program observation of object, 0 otherwise 
    segueprimary smallint, --/D Set to 1 for primary SDSS SEGUE program observation of object (including SEGUE-1 and SEGUE-2), 0 otherwise 
    segue1primary smallint, --/D Set to 1 for primary SDSS SEGUE-1 program observation of object, 0 otherwise 
    segue2primary smallint, --/D Set to 1 for primary SDSS SEGUE-2 program observation of object, 0 otherwise 
    bossprimary smallint, --/D Set to 1 for primary BOSS spectrograph observation of object, 0 otherwise 
    bossspecobjid integer, --/D Identification number internal to BOSS for SPECBOSS=1 objects 
    firstrelease character varying(32), --/D Name of first release this PLATE, MJD, FIBERID, RUN2D was associated with 
    survey character varying(32), --/D Survey that this object is part of 
    instrument character varying(32), --/D Instrument that this spectrum was observed with (SDSS or BOSS) 
    programname character varying(32), --/D Program within each survey that the plate was part of 
    chunk character varying(32), --/D Name of tiling chunk that this spectrum was tiled in (boss1, boss2, etc), important for tracking large-scale structure samples 
    platerun character varying(32), --/D Drilling run that this plate was drilled in 
    mjd integer, --/U day --/D Modified Julian Day of observation 
    plate smallint, --/D Plate number (each plate corresponds to an actual plug plate) 
    fiberid smallint, --/D Fiber number 
    run1d character varying(32), --/D Spectroscopic 1D reduction (redshift and classification) name 
    run2d character varying(32), --/D Spectroscopic 2D reduction (extraction of spectra) name 
    tile integer, --/D Tile number (each tile can have several plates drilled for it) 
    designid integer, --/D Design identification number for plate 
    legacy_target1 bigint, --/D Primary (science) target flags for SDSS-I and SDSS-II Legacy survey 
    legacy_target2 bigint, --/D Secondary (calibration) target flags for SDSS-I and SDSS-II Legacy survey 
    special_target1 bigint, --/D Primary (science) target flags for SDSS-I and SDSS-II special program targets 
    special_target2 bigint, --/D Secondary (calibration) target flags for SDSS-I and SDSS-II special program targets 
    segue1_target1 bigint, --/D Primary (science) target flags for SEGUE-1 targets 
    segue1_target2 bigint, --/D Secondary (calibration) target flags for SEGUE-1 targets 
    segue2_target1 bigint, --/D Primary (science) target flags for SEGUE-2 targets 
    segue2_target2 bigint, --/D Secondary (calibration) target flags for SEGUE-2 targets 
    boss_target1 bigint, --/D Primary (science) target flags for BOSS targets 
    eboss_target0 bigint, --/D SEQUELS, TDSS and SPIDERS target selection flags 
    eboss_target1 bigint, --/D eBOSS, TDSS and SPIDERS target selection flags for main eBOSS survey 
    eboss_target2 bigint, --/D eBOSS, TDSS and SPIDERS target selection flags for main eBOSS survey 
    eboss_target_id bigint, --/D eBOSS unique target identifier for every spectroscopic target 
    ancillary_target1 bigint, --/D Target flags for BOSS ancillary targets 
    ancillary_target2 bigint, --/D More target flags for BOSS ancillary targets 
    thing_id_targeting bigint, --/D Resolve THING_ID in SDSS imaging for targeted object 
    thing_id integer, --/D Resolve THING_ID in SDSS imaging for best positional match 
    primtarget bigint, --/D Deprecated version of primary (science) target flags (meanings highly overloaded) 
    sectarget bigint, --/D Deprecated version of secondary (calibration) target flags (meanings highly overloaded) 
    spectrographid smallint, --/D Which spectrograph (1 or 2) 
    sourcetype character varying(128), --/D String expressing type of source (similar to OBJTYPE in DR8 and earlier) 
    targettype character varying(128), --/D General type of target ("SCIENCE", "STANDARD" or "SKY") 
    ra double precision, --/U degrees --/D Right ascension of hole (J2000) 
    "dec" double precision, --/U degrees --/D Declination of hole (J2000) 
    cx double precision, --/D Position of object on J2000 unit sphere 
    cy double precision, --/D Position of object on J2000 unit sphere 
    cz double precision, --/D Position of object on J2000 unit sphere 
    xfocal real, --/U mm --/D Hole position on plate (+X = +RA) 
    yfocal real, --/U mm --/D Hole position on plate (+Y = +DEC) 
    lambdaeff real, --/U Angstroms --/D Effective wavelength drilling position was optimized for 
    bluefiber integer, --/D Set to 1 if this was requested to be a "blue fiber" target, 0 if it was a "red fiber" (in BOSS high redshift LRGs are requested to be on red fibers) 
    zoffset real, --/U microns --/D Washer thickness used (for backstopping BOSS quasar targets, so they are closer to 4000 Angstrom focal plan) 
    z real, --/D Best redshift 
    zerr real, --/D Error in best redshift 
    zwarning integer, --/D Bitmask of spectroscopic warning values; 0 means everything is OK 
    class character varying(32), --/D Best spectroscopic classification ("STAR", "GALAXY" or "QSO") 
    subclass character varying(32), --/D Best spectroscopic subclassification 
    rchi2 real, --/D Reduced chi-squared of best fit 
    dof real, --/D Number of degrees of freedom in best fit 
    rchi2diff real, --/D Difference in reduced chi-squared between best and second best fit 
    z_noqso real, --/D Best redshift when ignoring QSO fits, recommended for BOSS CMASS and LOWZ targets; calculated only for survey='boss' spectra, not for any SDSS spectrograph data 
    zerr_noqso real, --/D Error in Z_NOQSO redshift 
    zwarning_noqso integer, --/D For Z_NOQSO redshift, the bitmask of spectroscopic warning values; 0 means everything is OK 
    class_noqso character varying(32), --/D Spectroscopic classification for Z_NOQSO redshift 
    subclass_noqso character varying(32), --/D Spectroscopic subclassification for Z_NOQSO redshift 
    rchi2diff_noqso real, --/D Difference in reduced chi-squared between best and second best fit for Z_NOQSO redshift 
    z_person real, --/D Visual-inspection redshift 
    class_person character varying(32), --/D Visual-inspection classification (0=not inspected or unknown, 1=star, 2=narrow emission-line galaxy, 3=QSO, 4=galaxy) 
    comments_person character varying(200), --/D Visual-inspection comments 
    tfile character varying(32), --/D File that best fit template comes from in idlspec1d product 
    tcolumn_0 smallint, --/D Which column of the template file corresponds to template #0
    tcolumn_1 smallint, --/D Which column of the template file corresponds to template #1
    tcolumn_2 smallint, --/D Which column of the template file corresponds to template #2
    tcolumn_3 smallint, --/D Which column of the template file corresponds to template #3
    tcolumn_4 smallint, --/D Which column of the template file corresponds to template #4
    tcolumn_5 smallint, --/D Which column of the template file corresponds to template #5
    tcolumn_6 smallint, --/D Which column of the template file corresponds to template #6
    tcolumn_7 smallint, --/D Which column of the template file corresponds to template #7
    tcolumn_8 smallint, --/D Which column of the template file corresponds to template #8
    tcolumn_9 smallint, --/D Which column of the template file corresponds to template #9
    npoly real, --/D Number of polynomial terms in fit 
    theta_0 real, --/D Template coefficients of best fit (polynomial term #0) 
    theta_1 real, --/D Template coefficients of best fit (polynomial term #1) 
    theta_2 real, --/D Template coefficients of best fit (polynomial term #2) 
    theta_3 real, --/D Template coefficients of best fit (polynomial term #3) 
    theta_4 real, --/D Template coefficients of best fit (polynomial term #4) 
    theta_5 real, --/D Template coefficients of best fit (polynomial term #5) 
    theta_6 real, --/D Template coefficients of best fit (polynomial term #6) 
    theta_7 real, --/D Template coefficients of best fit (polynomial term #7) 
    theta_8 real, --/D Template coefficients of best fit (polynomial term #8) 
    theta_9 real, --/D Template coefficients of best fit (polynomial term #9) 
    veldisp real, --/U km/s --/D Velocity dispersion 
    veldisperr real, --/U km/s --/D Error in velocity dispersion 
    veldispz real, --/D Redshift associated with best-fit velocity dispersion 
    veldispzerr real, --/D Error in redshift associated with best-fit velocity dispersion 
    veldispchi2 real, --/D Chi-squared for best-fit velocity dispersion 
    veldispnpix integer, --/D Number of pixels overlapping the templates used in the velocity dispersion fit 
    veldispdof integer, --/D Number of degrees of freedom in velocity dispersion fit 
    wavemin real, --/U Angstroms --/D Minimum observed (vacuum) wavelength 
    wavemax real, --/U Angstroms --/D Maximum observed (vacuum) wavelength 
    wcoverage real, --/D Coverage in wavelength, in units of log10 wavelength 
    snmedian_u real, --/D Median signal-to-noise per pixel within the u bandpass 
    snmedian_g real, --/D Median signal-to-noise per pixel within the g bandpass 
    snmedian_r real, --/D Median signal-to-noise per pixel within the r bandpass 
    snmedian_i real, --/D Median signal-to-noise per pixel within the i bandpass 
    snmedian_z real, --/D Median signal-to-noise per pixel within the z bandpass 
    snmedian real, --/D Median signal-to-noise per pixel across full spectrum (aka SN_MEDIAN_ALL) 
    chi68p real, --/D 68-th percentile value of abs(chi) of the best-fit synthetic spectrum to the actual spectrum (around 1.0 for a good fit) 
    fracnsigma_1 real, --/D Fraction of pixels deviant by more than 1 sigma relative to best-fit
    fracnsigma_2 real, --/D Fraction of pixels deviant by more than 2 sigma relative to best-fit
    fracnsigma_3 real, --/D Fraction of pixels deviant by more than 3 sigma relative to best-fit
    fracnsigma_4 real, --/D Fraction of pixels deviant by more than 4 sigma relative to best-fit
    fracnsigma_5 real, --/D Fraction of pixels deviant by more than 5 sigma relative to best-fit
    fracnsigma_6 real, --/D Fraction of pixels deviant by more than 6 sigma relative to best-fit
    fracnsigma_7 real, --/D Fraction of pixels deviant by more than 7 sigma relative to best-fit
    fracnsigma_8 real, --/D Fraction of pixels deviant by more than 8 sigma relative to best-fit
    fracnsigma_9 real, --/D Fraction of pixels deviant by more than 9 sigma relative to best-fit
    fracnsigma_10 real, --/D Fraction of pixels deviant by more than 10 sigma relative to best-fit
    fracnsighi_1 real, --/D Fraction of pixels high by more than 1 sigma relative to best-fit
    fracnsighi_2 real, --/D Fraction of pixels high by more than 2 sigma relative to best-fit
    fracnsighi_3 real, --/D Fraction of pixels high by more than 3 sigma relative to best-fit
    fracnsighi_4 real, --/D Fraction of pixels high by more than 4 sigma relative to best-fit
    fracnsighi_5 real, --/D Fraction of pixels high by more than 5 sigma relative to best-fit
    fracnsighi_6 real, --/D Fraction of pixels high by more than 6 sigma relative to best-fit
    fracnsighi_7 real, --/D Fraction of pixels high by more than 7 sigma relative to best-fit
    fracnsighi_8 real, --/D Fraction of pixels high by more than 8 sigma relative to best-fit
    fracnsighi_9 real, --/D Fraction of pixels high by more than 9 sigma relative to best-fit
    fracnsighi_10 real, --/D Fraction of pixels high by more than 10 sigma relative to best-fit
    fracnsiglo_1 real, --/D Fraction of pixels low by more than 1 sigma relative to best-fit
    fracnsiglo_2 real, --/D Fraction of pixels low by more than 2 sigma relative to best-fit
    fracnsiglo_3 real, --/D Fraction of pixels low by more than 3 sigma relative to best-fit
    fracnsiglo_4 real, --/D Fraction of pixels low by more than 4 sigma relative to best-fit
    fracnsiglo_5 real, --/D Fraction of pixels low by more than 5 sigma relative to best-fit
    fracnsiglo_6 real, --/D Fraction of pixels low by more than 6 sigma relative to best-fit
    fracnsiglo_7 real, --/D Fraction of pixels low by more than 7 sigma relative to best-fit
    fracnsiglo_8 real, --/D Fraction of pixels low by more than 8 sigma relative to best-fit
    fracnsiglo_9 real, --/D Fraction of pixels low by more than 9 sigma relative to best-fit
    fracnsiglo_10 real, --/D Fraction of pixels low by more than 10 sigma relative to best-fit
    spectroflux_u real, --/U nanomaggies --/D Spectral flux within u filter bandpass 
    spectroflux_g real, --/U nanomaggies --/D Spectral flux within g filter bandpass 
    spectroflux_r real, --/U nanomaggies --/D Spectral flux within r filter bandpass 
    spectroflux_i real, --/U nanomaggies --/D Spectral flux within i filter bandpass 
    spectroflux_z real, --/U nanomaggies --/D Spectral flux within z filter bandpass 
    spectrosynflux_u real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within u filter bandpass 
    spectrosynflux_g real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within g filter bandpass 
    spectrosynflux_r real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within r filter bandpass 
    spectrosynflux_i real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within i filter bandpass 
    spectrosynflux_z real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within z filter bandpass 
    spectrofluxivar_u real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within u filter bandpass 
    spectrofluxivar_g real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within g filter bandpass 
    spectrofluxivar_r real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within r filter bandpass 
    spectrofluxivar_i real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within i filter bandpass 
    spectrofluxivar_z real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within z filter bandpass 
    spectrosynfluxivar_u real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within u filter bandpass 
    spectrosynfluxivar_g real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within g filter bandpass 
    spectrosynfluxivar_r real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within r filter bandpass 
    spectrosynfluxivar_i real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within i filter bandpass 
    spectrosynfluxivar_z real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within z filter bandpass 
    spectroskyflux_u real, --/U nanomaggies --/D Sky flux in the u filter bandpass 
    spectroskyflux_g real, --/U nanomaggies --/D Sky flux in the g filter bandpass 
    spectroskyflux_r real, --/U nanomaggies --/D Sky flux in the r filter bandpass 
    spectroskyflux_i real, --/U nanomaggies --/D Sky flux in the i filter bandpass 
    spectroskyflux_z real, --/U nanomaggies --/D Sky flux in the z filter bandpass 
    anyandmask integer, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK 
    anyormask integer, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK 
    platesn2 real, --/D Overall signal-to-noise-squared measure for plate (only for SDSS spectrograph plates) 
    deredsn2 real, --/D Dereddened overall signal-to-noise-squared measure for plate (only for BOSS spectrograph plates) 
    snturnoff real, --/D Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate) 
    sn1_g real, --/D Signal-to-noise squared for spectrograph #1, at fiducial (psf)magnitude g=20.20 for SDSS spectrograph spectra, g=21.20 for BOSS spectrograph spectra 
    sn1_r real, --/D Signal-to-noise squared for spectrograph #1, at fiducial (psf)magnitude r=20.25 for SDSS spectrograph spectra, r=20.20 for BOSS spectrograph spectra 
    sn1_i real, --/D Signal-to-noise squared for spectrograph #1, at fiducial (psf)magnitude i=19.90 for SDSS spectrograph spectra, i=20.20 for BOSS spectrograph spectra 
    sn2_g real, --/D Signal-to-noise squared for spectrograph #2, at fiducial (psf)magnitude g=20.20 for SDSS spectrograph spectra, g=21.20 for BOSS spectrograph spectra 
    sn2_r real, --/D Signal-to-noise squared for spectrograph #2, at fiducial (psf)magnitude r=20.25 for SDSS spectrograph spectra, r=20.20 for BOSS spectrograph spectra 
    sn2_i real, --/D Signal-to-noise squared for spectrograph #2, at fiducial (psf)magnitude i=19.90 for SDSS spectrograph spectra, i=20.20 for BOSS spectrograph spectra 
    elodiefilename character varying(32), --/D File name for best-fit ELODIE star 
    elodieobject character varying(32), --/D Star name for ELODIE star 
    elodiesptype character varying(32), --/D ELODIE star spectral type 
    elodiebv real, --/U mag --/D (B-V) color index for ELODIE star 
    elodieteff real, --/U Kelvin --/D Effective temperature of ELODIE star 
    elodielogg real, --/D log10(gravity) of ELODIE star 
    elodiefeh real, --/D Metallicity of ELODIE star log10(Fe/H) 
    elodiez real, --/D Redshift fit to ELODIE star 
    elodiezerr real, --/D Error in redshift fit to ELODIE star 
    elodiezmodelerr real, --/D Standard deviation in redshift among the 12 best-fit ELODIE stars 
    elodierchi2 real, --/D Reduced chi-squared of fit to best ELODIE star 
    elodiedof real, --/D Degrees of freedom in fit to best ELODIE star 
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID 
    loadversion integer --/D Load Version 
);



--
-- Name: dr19_sdss_dr17_specobj; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_dr17_specobj (
----------------------------------------------------------------------
--/H This table contains the list of all SDSS optical spectra for a given data release, with associated parameters from the 2D and 1D pipelines for each. The table contains both the BOSS and SDSS spectrograph data. The database representation is derived from the flat file information described here: <a href="https://data.sdss.org/datamodel/files/SPECTRO_REDUX/specObj.html">https://data.sdss.org/datamodel/files/SPECTRO_REDUX/specObj.html</a> Note: the order of the columns in this documentation may not match the order of the columns in the database table.
----------------------------------------------------------------------
    specobjid numeric(20,0) NOT NULL, --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D (same as SkyServer version) 
    bestobjid bigint, --/D Unique database ID of (recommended) position-based photometric match based on RUN, RERUN, CAMCOl, FIELD, ID (same as SkyServer version) 
    fluxobjid bigint, --/D Unique database ID of flux-based photometric match based on RUN, RERUN, CAMCOl, FIELD, ID (same as SkyServer version) 
    targetobjid bigint, --/D Unique database ID of targeting object based on RUN, RERUN, CAMCOl, FIELD, ID (same as SkyServer version) 
    plateid numeric(20,0), --/D Unique database ID of plate based on PLATE, MJD, RUN2D (same as SkyServer version) 
    scienceprimary smallint, --/D Set to 1 for primary observation of object, 0 otherwise 
    sdssprimary smallint, --/D Set to 1 for primary SDSS spectrograph observation of object, 0 otherwise 
    legacyprimary smallint, --/D Set to 1 for primary SDSS Legacy program observation of object, 0 otherwise 
    segueprimary smallint, --/D Set to 1 for primary SDSS SEGUE program observation of object (including SEGUE-1 and SEGUE-2), 0 otherwise 
    segue1primary smallint, --/D Set to 1 for primary SDSS SEGUE-1 program observation of object, 0 otherwise 
    segue2primary smallint, --/D Set to 1 for primary SDSS SEGUE-2 program observation of object, 0 otherwise 
    bossprimary smallint, --/D Set to 1 for primary BOSS spectrograph observation of object, 0 otherwise 
    bossspecobjid integer, --/D Identification number internal to BOSS for SPECBOSS=1 objects 
    firstrelease character varying(32), --/D Name of first release this PLATE, MJD, FIBERID, RUN2D was associated with 
    survey character varying(32), --/D Survey that this object is part of 
    instrument character varying(32), --/D Instrument that this spectrum was observed with (SDSS or BOSS) 
    programname character varying(32), --/D Program within each survey that the plate was part of 
    chunk character varying(32), --/D Name of tiling chunk that this spectrum was tiled in (boss1, boss2, etc), important for tracking large-scale structure samples 
    platerun character varying(32), --/D Drilling run that this plate was drilled in 
    mjd integer, --/U day --/D Modified Julian Day of observation 
    plate smallint, --/D Plate number (each plate corresponds to an actual plug plate) 
    fiberid smallint, --/D Fiber number 
    run1d character varying(32), --/D Spectroscopic 1D reduction (redshift and classification) name 
    run2d character varying(32), --/D Spectroscopic 2D reduction (extraction of spectra) name 
    tile integer, --/D Tile number (each tile can have several plates drilled for it) 
    designid integer, --/D Design identification number for plate 
    legacy_target1 bigint, --/D Primary (science) target flags for SDSS-I and SDSS-II Legacy survey 
    legacy_target2 bigint, --/D Secondary (calibration) target flags for SDSS-I and SDSS-II Legacy survey 
    special_target1 bigint, --/D Primary (science) target flags for SDSS-I and SDSS-II special program targets 
    special_target2 bigint, --/D Secondary (calibration) target flags for SDSS-I and SDSS-II special program targets 
    segue1_target1 bigint, --/D Primary (science) target flags for SEGUE-1 targets 
    segue1_target2 bigint, --/D Secondary (calibration) target flags for SEGUE-1 targets 
    segue2_target1 bigint, --/D Primary (science) target flags for SEGUE-2 targets 
    segue2_target2 bigint, --/D Secondary (calibration) target flags for SEGUE-2 targets 
    boss_target1 bigint, --/D Primary (science) target flags for BOSS targets 
    eboss_target0 bigint, --/D SEQUELS, TDSS and SPIDERS target selection flags 
    eboss_target1 bigint, --/D eBOSS, TDSS and SPIDERS target selection flags for main eBOSS survey 
    eboss_target2 bigint, --/D eBOSS, TDSS and SPIDERS target selection flags for main eBOSS survey 
    eboss_target_id bigint, --/D eBOSS unique target identifier for every spectroscopic target 
    ancillary_target1 bigint, --/D Target flags for BOSS ancillary targets 
    ancillary_target2 bigint, --/D More target flags for BOSS ancillary targets 
    thing_id_targeting bigint, --/D Resolve THING_ID in SDSS imaging for targeted object 
    thing_id integer, --/D Resolve THING_ID in SDSS imaging for best positional match 
    primtarget bigint, --/D Deprecated version of primary (science) target flags (meanings highly overloaded) 
    sectarget bigint, --/D Deprecated version of secondary (calibration) target flags (meanings highly overloaded) 
    spectrographid smallint, --/D Which spectrograph (1 or 2) 
    sourcetype character varying(128), --/D String expressing type of source (similar to OBJTYPE in DR8 and earlier) 
    targettype character varying(128), --/D General type of target ("SCIENCE", "STANDARD" or "SKY") 
    ra double precision, --/U degrees --/D Right ascension of hole (J2000) 
    "dec" double precision, --/U degrees --/D Declination of hole (J2000) 
    cx double precision, --/D Position of object on J2000 unit sphere 
    cy double precision, --/D Position of object on J2000 unit sphere 
    cz double precision, --/D Position of object on J2000 unit sphere 
    xfocal real, --/U mm --/D Hole position on plate (+X = +RA) 
    yfocal real, --/U mm --/D Hole position on plate (+Y = +DEC) 
    lambdaeff real, --/U Angstroms --/D Effective wavelength drilling position was optimized for 
    bluefiber integer, --/D Set to 1 if this was requested to be a "blue fiber" target, 0 if it was a "red fiber" (in BOSS high redshift LRGs are requested to be on red fibers) 
    zoffset real, --/U microns --/D Washer thickness used (for backstopping BOSS quasar targets, so they are closer to 4000 Angstrom focal plan) 
    z real, --/D Best redshift 
    zerr real, --/D Error in best redshift 
    zwarning integer, --/D Bitmask of spectroscopic warning values; 0 means everything is OK 
    class character varying(32), --/D Best spectroscopic classification ("STAR", "GALAXY" or "QSO") 
    subclass character varying(32), --/D Best spectroscopic subclassification 
    rchi2 real, --/D Reduced chi-squared of best fit 
    dof real, --/D Number of degrees of freedom in best fit 
    rchi2diff real, --/D Difference in reduced chi-squared between best and second best fit 
    z_noqso real, --/D Best redshift when ignoring QSO fits, recommended for BOSS CMASS and LOWZ targets; calculated only for survey='boss' spectra, not for any SDSS spectrograph data 
    zerr_noqso real, --/D Error in Z_NOQSO redshift 
    zwarning_noqso integer, --/D For Z_NOQSO redshift, the bitmask of spectroscopic warning values; 0 means everything is OK 
    class_noqso character varying(32), --/D Spectroscopic classification for Z_NOQSO redshift 
    subclass_noqso character varying(32), --/D Spectroscopic subclassification for Z_NOQSO redshift 
    rchi2diff_noqso real, --/D Difference in reduced chi-squared between best and second best fit for Z_NOQSO redshift 
    z_person real, --/D Visual-inspection redshift 
    class_person character varying(32), --/D Visual-inspection classification (0=not inspected or unknown, 1=star, 2=narrow emission-line galaxy, 3=QSO, 4=galaxy) 
    comments_person character varying(200), --/D Visual-inspection comments 
    tfile character varying(32), --/D File that best fit template comes from in idlspec1d product 
    tcolumn_0 smallint, --/D Which column of the template file corresponds to template #0
    tcolumn_1 smallint, --/D Which column of the template file corresponds to template #1
    tcolumn_2 smallint, --/D Which column of the template file corresponds to template #2
    tcolumn_3 smallint, --/D Which column of the template file corresponds to template #3
    tcolumn_4 smallint, --/D Which column of the template file corresponds to template #4
    tcolumn_5 smallint, --/D Which column of the template file corresponds to template #5
    tcolumn_6 smallint, --/D Which column of the template file corresponds to template #6
    tcolumn_7 smallint, --/D Which column of the template file corresponds to template #7
    tcolumn_8 smallint, --/D Which column of the template file corresponds to template #8
    tcolumn_9 smallint, --/D Which column of the template file corresponds to template #9
    npoly real, --/D Number of polynomial terms in fit 
    theta_0 real, --/D Template coefficients of best fit (polynomial term #0) 
    theta_1 real, --/D Template coefficients of best fit (polynomial term #1) 
    theta_2 real, --/D Template coefficients of best fit (polynomial term #2) 
    theta_3 real, --/D Template coefficients of best fit (polynomial term #3) 
    theta_4 real, --/D Template coefficients of best fit (polynomial term #4) 
    theta_5 real, --/D Template coefficients of best fit (polynomial term #5) 
    theta_6 real, --/D Template coefficients of best fit (polynomial term #6) 
    theta_7 real, --/D Template coefficients of best fit (polynomial term #7) 
    theta_8 real, --/D Template coefficients of best fit (polynomial term #8) 
    theta_9 real, --/D Template coefficients of best fit (polynomial term #9) 
    veldisp real, --/U km/s --/D Velocity dispersion 
    veldisperr real, --/U km/s --/D Error in velocity dispersion 
    veldispz real, --/D Redshift associated with best-fit velocity dispersion 
    veldispzerr real, --/D Error in redshift associated with best-fit velocity dispersion 
    veldispchi2 real, --/D Chi-squared for best-fit velocity dispersion 
    veldispnpix integer, --/D Number of pixels overlapping the templates used in the velocity dispersion fit 
    veldispdof integer, --/D Number of degrees of freedom in velocity dispersion fit 
    wavemin real, --/U Angstroms --/D Minimum observed (vacuum) wavelength 
    wavemax real, --/U Angstroms --/D Maximum observed (vacuum) wavelength 
    wcoverage real, --/D Coverage in wavelength, in units of log10 wavelength 
    snmedian_u real, --/D Median signal-to-noise per pixel within the u bandpass 
    snmedian_g real, --/D Median signal-to-noise per pixel within the g bandpass 
    snmedian_r real, --/D Median signal-to-noise per pixel within the r bandpass 
    snmedian_i real, --/D Median signal-to-noise per pixel within the i bandpass 
    snmedian_z real, --/D Median signal-to-noise per pixel within the z bandpass 
    snmedian real, --/D Median signal-to-noise per pixel across full spectrum (aka SN_MEDIAN_ALL) 
    chi68p real, --/D 68-th percentile value of abs(chi) of the best-fit synthetic spectrum to the actual spectrum (around 1.0 for a good fit) 
    fracnsigma_1 real, --/D Fraction of pixels deviant by more than 1 sigma relative to best-fit
    fracnsigma_2 real, --/D Fraction of pixels deviant by more than 2 sigma relative to best-fit
    fracnsigma_3 real, --/D Fraction of pixels deviant by more than 3 sigma relative to best-fit
    fracnsigma_4 real, --/D Fraction of pixels deviant by more than 4 sigma relative to best-fit
    fracnsigma_5 real, --/D Fraction of pixels deviant by more than 5 sigma relative to best-fit
    fracnsigma_6 real, --/D Fraction of pixels deviant by more than 6 sigma relative to best-fit
    fracnsigma_7 real, --/D Fraction of pixels deviant by more than 7 sigma relative to best-fit
    fracnsigma_8 real, --/D Fraction of pixels deviant by more than 8 sigma relative to best-fit
    fracnsigma_9 real, --/D Fraction of pixels deviant by more than 9 sigma relative to best-fit
    fracnsigma_10 real, --/D Fraction of pixels deviant by more than 10 sigma relative to best-fit
    fracnsighi_1 real, --/D Fraction of pixels high by more than 1 sigma relative to best-fit
    fracnsighi_2 real, --/D Fraction of pixels high by more than 2 sigma relative to best-fit
    fracnsighi_3 real, --/D Fraction of pixels high by more than 3 sigma relative to best-fit
    fracnsighi_4 real, --/D Fraction of pixels high by more than 4 sigma relative to best-fit
    fracnsighi_5 real, --/D Fraction of pixels high by more than 5 sigma relative to best-fit
    fracnsighi_6 real, --/D Fraction of pixels high by more than 6 sigma relative to best-fit
    fracnsighi_7 real, --/D Fraction of pixels high by more than 7 sigma relative to best-fit
    fracnsighi_8 real, --/D Fraction of pixels high by more than 8 sigma relative to best-fit
    fracnsighi_9 real, --/D Fraction of pixels high by more than 9 sigma relative to best-fit
    fracnsighi_10 real, --/D Fraction of pixels high by more than 10 sigma relative to best-fit
    fracnsiglo_1 real, --/D Fraction of pixels low by more than 1 sigma relative to best-fit
    fracnsiglo_2 real, --/D Fraction of pixels low by more than 2 sigma relative to best-fit
    fracnsiglo_3 real, --/D Fraction of pixels low by more than 3 sigma relative to best-fit
    fracnsiglo_4 real, --/D Fraction of pixels low by more than 4 sigma relative to best-fit
    fracnsiglo_5 real, --/D Fraction of pixels low by more than 5 sigma relative to best-fit
    fracnsiglo_6 real, --/D Fraction of pixels low by more than 6 sigma relative to best-fit
    fracnsiglo_7 real, --/D Fraction of pixels low by more than 7 sigma relative to best-fit
    fracnsiglo_8 real, --/D Fraction of pixels low by more than 8 sigma relative to best-fit
    fracnsiglo_9 real, --/D Fraction of pixels low by more than 9 sigma relative to best-fit
    fracnsiglo_10 real, --/D Fraction of pixels low by more than 10 sigma relative to best-fit
    spectroflux_u real, --/U nanomaggies --/D Spectral flux within u filter bandpass 
    spectroflux_g real, --/U nanomaggies --/D Spectral flux within g filter bandpass 
    spectroflux_r real, --/U nanomaggies --/D Spectral flux within r filter bandpass 
    spectroflux_i real, --/U nanomaggies --/D Spectral flux within i filter bandpass 
    spectroflux_z real, --/U nanomaggies --/D Spectral flux within z filter bandpass 
    spectrosynflux_u real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within u filter bandpass 
    spectrosynflux_g real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within g filter bandpass 
    spectrosynflux_r real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within r filter bandpass 
    spectrosynflux_i real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within i filter bandpass 
    spectrosynflux_z real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within z filter bandpass 
    spectrofluxivar_u real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within u filter bandpass 
    spectrofluxivar_g real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within g filter bandpass 
    spectrofluxivar_r real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within r filter bandpass 
    spectrofluxivar_i real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within i filter bandpass 
    spectrofluxivar_z real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within z filter bandpass 
    spectrosynfluxivar_u real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within u filter bandpass 
    spectrosynfluxivar_g real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within g filter bandpass 
    spectrosynfluxivar_r real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within r filter bandpass 
    spectrosynfluxivar_i real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within i filter bandpass 
    spectrosynfluxivar_z real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within z filter bandpass 
    spectroskyflux_u real, --/U nanomaggies --/D Sky flux in the u filter bandpass 
    spectroskyflux_g real, --/U nanomaggies --/D Sky flux in the g filter bandpass 
    spectroskyflux_r real, --/U nanomaggies --/D Sky flux in the r filter bandpass 
    spectroskyflux_i real, --/U nanomaggies --/D Sky flux in the i filter bandpass 
    spectroskyflux_z real, --/U nanomaggies --/D Sky flux in the z filter bandpass 
    anyandmask integer, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK 
    anyormask integer, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK 
    platesn2 real, --/D Overall signal-to-noise-squared measure for plate (only for SDSS spectrograph plates) 
    deredsn2 real, --/D Dereddened overall signal-to-noise-squared measure for plate (only for BOSS spectrograph plates) 
    snturnoff real, --/D Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate) 
    sn1_g real, --/D Signal-to-noise squared for spectrograph #1, at fiducial (psf)magnitude g=20.20 for SDSS spectrograph spectra, g=21.20 for BOSS spectrograph spectra 
    sn1_r real, --/D Signal-to-noise squared for spectrograph #1, at fiducial (psf)magnitude r=20.25 for SDSS spectrograph spectra, r=20.20 for BOSS spectrograph spectra 
    sn1_i real, --/D Signal-to-noise squared for spectrograph #1, at fiducial (psf)magnitude i=19.90 for SDSS spectrograph spectra, i=20.20 for BOSS spectrograph spectra 
    sn2_g real, --/D Signal-to-noise squared for spectrograph #2, at fiducial (psf)magnitude g=20.20 for SDSS spectrograph spectra, g=21.20 for BOSS spectrograph spectra 
    sn2_r real, --/D Signal-to-noise squared for spectrograph #2, at fiducial (psf)magnitude r=20.25 for SDSS spectrograph spectra, r=20.20 for BOSS spectrograph spectra 
    sn2_i real, --/D Signal-to-noise squared for spectrograph #2, at fiducial (psf)magnitude i=19.90 for SDSS spectrograph spectra, i=20.20 for BOSS spectrograph spectra 
    elodiefilename character varying(32), --/D File name for best-fit ELODIE star 
    elodieobject character varying(32), --/D Star name for ELODIE star 
    elodiesptype character varying(32), --/D ELODIE star spectral type 
    elodiebv real, --/U mag --/D (B-V) color index for ELODIE star 
    elodieteff real, --/U Kelvin --/D Effective temperature of ELODIE star 
    elodielogg real, --/D log10(gravity) of ELODIE star 
    elodiefeh real, --/D Metallicity of ELODIE star log10(Fe/H) 
    elodiez real, --/D Redshift fit to ELODIE star 
    elodiezerr real, --/D Error in redshift fit to ELODIE star 
    elodiezmodelerr real, --/D Standard deviation in redshift among the 12 best-fit ELODIE stars 
    elodierchi2 real, --/D Reduced chi-squared of fit to best ELODIE star 
    elodiedof real, --/D Degrees of freedom in fit to best ELODIE star 
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID 
    loadversion integer, --/D Load Version 
    bestobjid_bigint bigint, --/D integer representation of bestobjid 
    fluxobjid_bigint bigint --/D integer representation of fluxobjid 
);



--
-- Name: dr19_sdss_id_flat; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_id_flat (
----------------------------------------------------------------------
--/H This table includes associations between sdss_id identifiers and the best matched catalogid for each catalogue cross-match. Unlike dr19_sdss_id_stacked, this table contains multiple rows per sdss_id, one for each cross-match association. When multiple sdss_ids are associated with the same catalogid, the one with the lowest rank (rank=1) should be preferred.
--/T Note: The sdss_id match was extended internally for a more recent crossmatch not
--/T yet part of the publicly released data. As such, the ra/dec_sdss_id columns may
--/T differ from the catalogid coordinates.
----------------------------------------------------------------------
    sdss_id bigint, --/D The SDSS identifier for a unique object.
    catalogid bigint, --/D The associated catalogid for this target.
    version_id smallint, --/D The version of the cross-match associated with the catalogid.
    ra_sdss_id double precision, --/D The right ascension of the target in ICRS J2015.5 coordinates (taken from the highest version catalogid in dr19_sdss_id_stacked).
    dec_sdss_id double precision, --/D The declination of the target in ICRS J2015.5 coordinates (taken from the highest version catalogid in dr19_sdss_id_stacked).
    n_associated smallint, --/D The number of sdss_ids associated with this catalogid.
    ra_catalogid double precision, --/D The right ascension of this row's catalogid from the dr19_catalog table.
    dec_catalogid double precision, --/D The declination of this row's catalogid from the dr19_catalog table.
    pk bigint NOT NULL, --/D The primary key. A sequential identifier for this table.
    rank integer --/D The rank of the sdss_id to catalogid association. When multiple sdss_ids are associated with the same catalogid, the one with the lowest rank (rank=1) should be preferred.
);



--
-- Name: dr19_sdss_id_stacked; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_id_stacked (
----------------------------------------------------------------------
--/H This table includes associations between sdss_id identifiers and the matched catalogids for each catalogue cross-match. The table contains one row per sdss_id with columns for each catalogid version. However, catalogids may be associated with multiple sdss_id. dr19_sdss_id_flat is a pivoted/flattened version of this table and contains information about the preferred sdss_id for a catalogid.
--/T Note: The sdss_id match was extended internally for a more recent crossmatch not
--/T yet part of the publicly released data. As such, the ra/dec_sdss_id columns may
--/T differ from the catalogid coordinates.
----------------------------------------------------------------------
    catalogid21 bigint, --/D The catalogid for the best matched object in the v0.1 cross-match (pk=21).
    catalogid25 bigint, --/D The catalogid for the best matched object in the v0.5 cross-match (pk=25).
    ra_sdss_id double precision, --/D The right ascension of the target in ICRS J2015.5 coordinates (taken from the highest version catalogid).
    dec_sdss_id double precision, --/D The declination of the target in ICRS J2015.5 coordinates (taken from the highest version catalogid).
    sdss_id bigint NOT NULL --/D The SDSS identifier for a unique object.
);



--
-- Name: dr19_sdss_id_to_catalog; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_id_to_catalog (
----------------------------------------------------------------------
--/H This table contains the best matched associations between SDSS identifiers (sdss_id, catalogid) and the unique identifiers in the parent catalogues used for SDSS cross-matches. The format of the parent catalogue columns is <table_name>__<column_name>, where <column_name> is the primary key/unique identifier column to which to join in the dr19_<table_name> table.
----------------------------------------------------------------------
    pk bigint NOT NULL, --/D The primary key. A sequential identifier for this table.
    sdss_id bigint, --/D The SDSS identifier for a unique object.
    catalogid bigint, --/D The associated catalogid for this target. An sdss_id may be associated with multiple catalogids (see dr19_sdss_id_flat).
    version_id integer, --/D The version of the cross-match associated with the catalogid.
    lead text, --/D The parent catalog, in the cross-match sequence, that first added this target.
    allstar_dr17_synspec_rev1__apstar_id text, --/D The associated primary key (apstar_id) in the allstar_dr17_synspec_rev1 table.
    allwise__cntr bigint, --/D The associated primary key (cntr) in the allwise table.
    bhm_rm_v0__pk bigint, --/D The associated primary key (pk) in the bhm_rm_v0 table.
    bhm_rm_v0_2__pk bigint, --/D The associated primary key (pk) in the bhm_rm_v0_2 table.
    catwise__source_id character varying(25), --/D The associated primary key (source_id) in the catwise table.
    catwise2020__source_id character(25), --/D The associated primary key (source_id) in the catwise2020 table.
    gaia_dr2_source__source_id bigint, --/D The associated primary key (source_id) in the gaia_dr2_source table.
    gaia_dr3_source__source_id bigint, --/D The associated primary key (source_id) in the gaia_dr3_source table.
    glimpse__pk bigint, --/D The associated primary key (pk) in the glimpse table.
    guvcat__objid bigint, --/D The associated primary key (objid) in the guvcat table.
    legacy_survey_dr10__ls_id bigint, --/D The associated primary key (ls_id) in the legacy_survey_dr10 table.
    legacy_survey_dr8__ls_id bigint, --/D The associated primary key (ls_id) in the legacy_survey_dr8 table.
    mangatarget__mangaid character varying(20), --/D The associated primary key (mangaid) in the mangatarget table.
    marvels_dr11_star__starname character varying, --/D The associated primary key (starname) in the marvels_dr11_star table.
    marvels_dr12_star__pk bigint, --/D The associated primary key (pk) in the marvels_dr12_star table.
    mastar_goodstars__mangaid character varying(25), --/D The associated primary key (mangaid) in the mastar_goodstars table.
    panstarrs1__catid_objid bigint, --/D The associated primary key (catid_objid) in the panstarrs1 table.
    ps1_g18__objid bigint, --/D The associated primary key (objid) in the ps1_g18 table.
    sdss_dr13_photoobj__objid bigint, --/D The associated primary key (objid) in the sdss_dr13_photoobj table.
    sdss_dr17_specobj__specobjid character varying, --/D The associated primary key (specobjid) in the sdss_dr17_specobj table.
    skymapper_dr1_1__object_id bigint, --/D The associated primary key (object_id) in the skymapper_dr1_1 table.
    skymapper_dr2__object_id bigint, --/D The associated primary key (object_id) in the skymapper_dr2 table.
    supercosmos__objid bigint, --/D The associated primary key (objid) in the supercosmos table.
    tic_v8__id bigint, --/D The associated primary key (id) in the tic_v8 table.
    twomass_psc__pts_key integer, --/D The associated primary key (pts_key) in the twomass_psc table.
    tycho2__designation text, --/D The associated primary key (designation) in the tycho2 table.
    unwise__unwise_objid text --/D The associated primary key (unwise_objid) in the unwise table.
);



--
-- Name: dr19_sdss_id_to_catalog_full; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdss_id_to_catalog_full (
    pk bigint,
    sdss_id bigint,
    catalogid bigint,
    version_id integer,
    lead text,
    allstar_dr17_synspec_rev1__apstar_id text,
    allwise__cntr bigint,
    bhm_rm_v0__pk bigint,
    bhm_rm_v0_2__pk bigint,
    catwise__source_id character varying(25),
    catwise2020__source_id character(25),
    gaia_dr2_source__source_id bigint,
    gaia_dr3_source__source_id bigint,
    glimpse__pk bigint,
    guvcat__objid bigint,
    legacy_survey_dr10__ls_id bigint,
    legacy_survey_dr8__ls_id bigint,
    mangatarget__mangaid character varying(20),
    marvels_dr11_star__starname character varying,
    marvels_dr12_star__pk bigint,
    mastar_goodstars__mangaid character varying(25),
    panstarrs1__catid_objid bigint,
    ps1_g18__objid bigint,
    sdss_dr13_photoobj__objid bigint,
    sdss_dr17_specobj__specobjid character varying,
    skymapper_dr1_1__object_id bigint,
    skymapper_dr2__object_id bigint,
    supercosmos__objid bigint,
    tic_v8__id bigint,
    twomass_psc__pts_key integer,
    tycho2__designation text,
    unwise__unwise_objid text
);



--
-- Name: dr19_sdssv_boss_conflist; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdssv_boss_conflist (
----------------------------------------------------------------------
--/H The dr19_sdssv_boss_conflist table is a database representation of an
--/T early version of the SDSS-V BOSS fieldlist data product.  The <br>
--/T dr19_sdssv_boss_conflist table was used within early iterations of FPS <br>
--/T target_selection as a way to communicate information about which <br>
--/T SDSS-V plates had been observed by the time of target selection. <br>
--/T This information was used <br>
--/T to e.g. de-prioritise targets that were expected to have a good quality <br>
--/T spectroscopic measurement before the start of SDSS-V FPS operations. <br>
--/T Caution. The dr19_sdssv_boss_conflist table should only be used in order to <br>
--/T recreate the target_selection selection function. <br>
--/T Column descriptions are mainly derived from:
--/T https://data.sdss.org/datamodel/files/BOSS_SPECTRO_REDUX/RUN2D/platelist.html
----------------------------------------------------------------------
    plate integer, --/D Plate ID number
    designid integer, --/D Design ID number
    mjd integer, --/D Modified Julian date of combined Spectra
    run2d text, --/D Spectro-2D reduction name
    run1d text, --/D Spectro-1D reduction name
    racen real, --/U deg --/D RA of the telescope pointing 
    deccen real, --/U deg --/D DEC of the telescope pointing 
    epoch real, --/D Epoch of the RACEN/DECCEN
    cartid integer, --/D The currently loaded cartridge/instrument
    tai double precision, --/U s --/D Mean MJD(TAI) seconds of integration 
    tai_beg double precision, --/U s --/D MJD(TAI) seconds at start of integration 
    tai_end double precision, --/U s --/D MJD(TAI) seconds at end of integration 
    airmass real, --/D Mean Airmass
    exptime real, --/U s --/D Total Exposure time 
    mapname text, --/D ID of plate mapping file
    survey text, --/D Survey that plate is part of
    programname text, --/D Program name within a given survey
    chunk text, --/U from platelist product --/D Name of tiling chunk 
    platequality text, --/D Characterization of plate quality
    platesn2 real, --/D Overall (S/N)^2 measure for plate
    deredsn2 real, --/D Overall Dereddened (S/N)^2 for plate
    qsurvey integer, --/D 1 for an survey quality plate, 0 otherwise
    mjdlist text, --/D List of MJD for each included exposure
    tailist text, --/D List of TAI for each included exposure
    nexp integer, --/D Number of Included Exposures
    nexp_b1 integer, --/D Number of Included Exposures from b1
    nexp_r1 integer, --/D Number of Included Exposures from r1
    expt_b1 real, --/U s --/D Total Exposure Time of b1 
    expt_r1 real, --/U s --/D Total Exposure Time of r1 
    sn2_g1 real, --/D Fit (S/N)^2 at g=20.20 for spectrograph #1
    sn2_r1 real, --/D Fit (S/N)^2 at r=20.25 for spectrograph #1
    sn2_i1 real, --/D Fit (S/N)^2 at i=19.90 for spectrograph #1
    dered_sn2_g1 real, --/D Extinction corrected (S/N)^2 for sp1 g-band
    dered_sn2_r1 real, --/D Extinction corrected (S/N)^2 for sp1 r-band
    dered_sn2_i1 real, --/D Extinction corrected (S/N)^2 for sp1 i-band
    goffstd real, --/D Mean g mag difference (spectro-photo) for STDs
    grmsstd real, --/D Stddev g mag diff (spectro-photo) for STDs
    roffstd real, --/D Mean r mag difference (spectro-photo) for STDs
    rrmsstd real, --/D Stddev r mag diff (spectro-photo) for STDs
    ioffstd real, --/D Mean i mag difference (spectro-photo) for STDs
    irmsstd real, --/D Stddev i mag diff (spectro-photo) for STDs
    groffstd real, --/D Spectrophoto offset for G-R in standards
    grrmsstd real, --/D Spectrophoto RMS for G-R in standards
    rioffstd real, --/D Spectrophoto offset for R-I in standards
    rirmsstd real, --/D Spectrophoto RMS for R-I in standards
    goffgal real, --/D Mean g mag diff (spectro-photo) for galaxies
    grmsgal real, --/D Stddev g mag diff (spectro-photo) for galaxies
    roffgal real, --/D Mean r mag diff (spectro-photo) for galaxies
    rrmsgal real, --/D Stddev r mag diff (spectro-photo) for galaxies
    ioffgal real, --/D Mean i mag diff (spectro-photo) for galaxies
    irmsgal real, --/D Stddev i mag diff (spectro-photo) for galaxies
    groffgal real, --/D Spectrophoto offset for G-R in galaxies
    grrmsgal real, --/D Spectrophoto RMS for G-R in galaxies
    rioffgal real, --/D Spectrophoto offset for R-I in galaxies
    rirmsgal real, --/D Spectrophoto RMS for R-I in galaxies
    nguide integer, --/D Number of guider frames during the exposures
    seeing20 real, --/U arcsec --/D Mean 20% seeing during exposures 
    seeing50 real, --/U arcsec --/D Mean 50% seeing during exposures 
    seeing80 real, --/U arcsec --/D Mean 80% seeing during exposures 
    rmsoff20 real, --/U arcsec --/D 20% of RMS offset of guide fibers 
    rmsoff50 real, --/U arcsec --/D 50% of RMS offset of guide fibers 
    rmsoff80 real, --/U arcsec --/D 80% of RMS offset of guide fibers 
    airtemp real, --/U dec --/D Air temperature in the dome 
    xsigma real, --/D Mean of median trace extraction profile width
    xsigmin real, --/D Min of median trace extraction profile width
    xsigmax real, --/D Max of median trace extraction profile width
    wsigma real, --/D Mean of median Arc Lines wavelength (Y) width
    wsigmin real, --/D Min of median Arc Lines wavelength (Y) width
    wsigmax real, --/D Max of median Arc Lines wavelength (Y) width
    xchi2 real, --/D Mean of XCHI2 (reduced chi^2 of row-by-row)
    xchi2min real, --/D Minimum of XCHI2 (reduced chi^2 of row-by-row)
    xchi2max real, --/D Maximum of XCHI2 (reduced chi^2 of row-by-row)
    skychi2 real, --/D Average chi^2 from sky subtraction
    schi2min real, --/D Minimum skyChi2 over all exposures
    schi2max real, --/D Maximum skyChi2 over all exposures
    fbadpix real, --/D Fraction of bad pixels
    fbadpix1 real, --/D Fraction of bad pixels from spectrograph #1
    fbadpix2 real, --/D Fraction of bad pixels from spectrograph #2
    n_total integer, --/D Number of Sources
    n_galaxy integer, --/D Number of Galaxies
    n_qso integer, --/D Number of QSOs
    n_star integer, --/D Number of Stars
    n_unknown integer, --/D Number of Unknown Sources
    n_sky integer, --/D Number of Skys
    n_std integer, --/D Number of Standards
    n_target_qso integer, --/D Number of QSO Targeted
    success_qso real, --/D Success rate of QSOs
    status2d text, --/D Status of 2d extraction
    statuscombine text, --/D Status of 1d combine
    status1d text, --/D Status of 1d analysis
    public text, --/D Is this Plate Public
    qualcomments text, --/D Comments on Plate Quality
    moon_frac real, --/D Mean Moon phase of the Coadded Spectra
    pkey bigint NOT NULL --/D primary key for table entry
);



--
-- Name: dr19_sdssv_boss_spall; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdssv_boss_spall (
----------------------------------------------------------------------
--/H The dr19_sdssv_boss_spall table is a database representation of an
--/T early version of the SDSS-V BOSS spAll data product.  The <br>
--/T dr19_sdssv_boss_spall table was used within early iterations of FPS <br>
--/T target_selection as a way to communicate information about which <br>
--/T targets had been observed in SDSS-V plates. This information was used <br>
--/T to e.g. de-prioritise targets that were expected to have a good quality <br>
--/T spectroscopic measurement before the start of SDSS-V FPS operations. <br>
--/T Caution. The dr19_sdssv_boss_spall table should only be used in order to <br>
--/T recreate the target_selection selection function. <br>
--/T Column descriptions are mainly derived from:
--/T https://data.sdss.org/datamodel/files/BOSS_SPECTRO_REDUX/RUN2D/spAll.html
----------------------------------------------------------------------
    programname text, --/D Program name within a given survey
    chunk text, --/U from platelist product --/D Name of tiling chunk 
    survey text, --/D Survey that plate is a part of
    platequality text, --/D Characterization of plate quality
    platesn2 real, --/D Overall (S/N)^2 measure for plate; minimum of all 4 cameras
    deredsn2 real, --/D Dereddened (extinction corrected) (S/N)^2 measure for plate; minimum of all 4 cameras
    primtarget integer, --/D n/a ignore
    sectarget integer, --/D n/a ignore
    lambda_eff real, --/U Angstrom --/D Wavelength to optimize hole location for 
    bluefiber integer, --/D 1 if assigned target a blue fiber; 0 otherwise
    zoffset real, --/D Backstopping offset distance
    xfocal real, --/D Hole/robot x-axis position in focal plane
    yfocal real, --/D Hole/robot y-axis position in focal plane
    specprimary smallint, --/D Objects observed multiple times will have this set to 1 for one observation only. This is usually the 'best' observation, as defined by critera listed in fieldmerge.py.
    specboss smallint, --/D Best version of spectrum at this location
    boss_specobj_id integer, --/D ID of spectrum location on sky
    nspecobs smallint, --/D Number of spectral observations
    calibflux_u real, --/U nanomaggy --/D Broad-band flux in SDSS-u from PSFmag 
    calibflux_g real, --/U nanomaggy --/D Broad-band flux in SDSS-g from PSFmag 
    calibflux_r real, --/U nanomaggy --/D Broad-band flux in SDSS-r from PSFmag 
    calibflux_i real, --/U nanomaggy --/D Broad-band flux in SDSS-i from PSFmag 
    calibflux_z real, --/U nanomaggy --/D Broad-band flux in SDSS-z from PSFmag 
    calibflux_ivar_u real, --/D Inverse var flux SDSS-u from PSFmag
    calibflux_ivar_g real, --/D Inverse var flux SDSS-g from PSFmag
    calibflux_ivar_r real, --/D Inverse var flux SDSS-r from PSFmag
    calibflux_ivar_i real, --/D Inverse var flux SDSS-i from PSFmag
    calibflux_ivar_z real, --/D Inverse var flux SDSS-z from PSFmag
    gaia_bp real, --/U mag, Vega --/D Gaia BP magnitude 
    gaia_rp real, --/U mag, Vega --/D Gaia RP magnitude 
    gaia_g real, --/U mag, Vega --/D Gaia G magnitude 
    firstcarton text, --/D Primary SDSS Carton for target
    mag_u real, --/U mag, AB --/D u-band optical magnitude 
    mag_g real, --/U mag, AB --/D g-band optical magnitude 
    mag_r real, --/U mag, AB --/D r-band optical magnitude 
    mag_i real, --/U mag, AB --/D i-band optical magnitude 
    mag_z real, --/U mag, AB --/D z-band optical magnitude 
    plate smallint, --/D Plate ID number
    designid smallint, --/D Design ID number
    nexp smallint, --/D Number of Included Exposures
    exptime smallint, --/U s --/D Total Exposure time of Coadded Spectra 
    airmass real, --/D Airmass at time of observation
    healpix integer, --/D healpix pixel number of the RACAT and DECCAT coordinates, computed with healpix nside=128
    healpixgrp smallint, --/D Rounded-down integer value of healpix / 1000
    healpix_dir text, --/D Relative directory for spectra grouped by healpixel
    mjd_final real, --/D Mean MJD of the Coadded Spectra
    mjd_list text, --/D List of MJD of each included exposures
    tai_list text, --/D List Tai for each exposure (at midpoint)
    catalogid bigint, --/D SDSS-V CatalogID used in naming
    sdssv_boss_target0 bigint, --/D bitmask for SDSS-V plate-era BOSS targeting
    field integer, --/D SDSS FieldID (plateID for plate era data)
    tile integer, --/D n/a ignore
    mjd integer, --/D Modified Julian date of combined Spectra
    fiberid integer, --/D Index of the fiber which observed the target
    run2d text, --/D Spectro-2D reduction name
    run1d text, --/D Spectro-1D reduction name
    objtype text, --/D Why this object was targeted.  Note that if this field says QSO, it could be the case that this object would have been targeted as a GALAXY or any number of other categories as well. The PRIMTARGET and SECTARGET flags in the plug-map structure (in the spField file) gives this full information.
    plug_ra double precision, --/U J2000] [degrees --/D Object RA (drilled fiber position) 
    plug_dec double precision, --/U J2000] [degrees --/D Object DEC (drilled fiber position) 
    class text, --/D Spectro classification: GALAXY, QSO, STAR
    subclass text, --/D Spectro sub-classification
    z real, --/D Redshift; incorrect for nonzero ZWARNING flag
    z_err real, --/D z error from chi^2 min; negative is invalid fit
    rchi2 real, --/D Reduced chi^2 for best fit
    dof integer, --/D Degrees of freedom for best fit
    rchi2diff real, --/D Diff in reduced chi^2 of 2 best solutions
    tfile text, --/D Template file in $IDLSPEC2D_DIR/templates
    npoly integer, --/D # of polynomial terms with TFILE
    vdisp real, --/U km/s --/D Velocity dispersion, only computed for galaxies 
    vdisp_err real, --/U km/s --/D Error in VDISP; negative for invalid fit 
    vdispz real, --/D Redshift for best-fit velocity dispersion
    vdispz_err real, --/D Error in VDISPZ
    vdispchi2 real, --/D Chi^2 for best-fit velocity dispersion
    vdispnpix real, --/D Num of pixels overlapping VDISP fit templates
    vdispdof integer, --/D Degrees of freedom for best-fit velocity dispersion, equal to VDISPNPIX minus the number of templates minus the number of polynomial terms minus 1 (the last 1 is for the velocity dispersion)
    wavemin real, --/U AA --/D Minimum observed (vacuum) wavelength for target 
    wavemax real, --/U AA --/D Maximum observed (vacuum) wavelength for target 
    wcoverage real, --/U log10(AA) --/D Amount of wavelength coverage in log-10(Angs) 
    zwarning integer, --/D A flag for bad z fits in place of CLASS=UNKNOWN
    sn_median_u real, --/D Median S/N for all good pixels in SDSS-u
    sn_median_g real, --/D Median S/N for all good pixels in SDSS-g
    sn_median_r real, --/D Median S/N for all good pixels in SDSS-r
    sn_median_i real, --/D Median S/N for all good pixels in SDSS-i
    sn_median_z real, --/D Median S/N for all good pixels in SDSS-z
    sn_median_all real, --/D Median S/N for all good pixels in all filters
    chi68p real, --/D 68% of abs(chi) of synthetic to actual spectrum
    spectroflux_u real, --/U nanomaggy --/D Spectrum projected onto SDSS-u filter 
    spectroflux_g real, --/U nanomaggy --/D Spectrum projected onto SDSS-g filter 
    spectroflux_r real, --/U nanomaggy --/D Spectrum projected onto SDSS-r filter 
    spectroflux_i real, --/U nanomaggy --/D Spectrum projected onto SDSS-i filter 
    spectroflux_z real, --/U nanomaggy --/D Spectrum projected onto SDSS-z filter 
    spectroflux_ivar_u real, --/U nanomaggy --/D Inverse variance of SPECTROFLUX_u 
    spectroflux_ivar_g real, --/U nanomaggy --/D Inverse variance of SPECTROFLUX_g 
    spectroflux_ivar_r real, --/U nanomaggy --/D Inverse variance of SPECTROFLUX_r 
    spectroflux_ivar_i real, --/U nanomaggy --/D Inverse variance of SPECTROFLUX_i 
    spectroflux_ivar_z real, --/U nanomaggy --/D Inverse variance of SPECTROFLUX_z 
    spectrosynflux_u real, --/U nanomaggy --/D Best-fit template projected onto SDSS-u 
    spectrosynflux_g real, --/U nanomaggy --/D Best-fit template projected onto SDSS-g 
    spectrosynflux_r real, --/U nanomaggy --/D Best-fit template projected onto SDSS-r 
    spectrosynflux_i real, --/U nanomaggy --/D Best-fit template projected onto SDSS-i 
    spectrosynflux_z real, --/U nanomaggy --/D Best-fit template projected onto SDSS-z 
    spectrosynflux_ivar_u real, --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_u 
    spectrosynflux_ivar_g real, --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_g 
    spectrosynflux_ivar_r real, --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_r 
    spectrosynflux_ivar_i real, --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_i 
    spectrosynflux_ivar_z real, --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_z 
    spectroskyflux_u real, --/U nanomaggy --/D Sky spectrum projected onto SDSS-u filter 
    spectroskyflux_g real, --/U nanomaggy --/D Sky spectrum projected onto SDSS-g filter 
    spectroskyflux_r real, --/U nanomaggy --/D Sky spectrum projected onto SDSS-r filter 
    spectroskyflux_i real, --/U nanomaggy --/D Sky spectrum projected onto SDSS-i filter 
    spectroskyflux_z real, --/U nanomaggy --/D Sky spectrum projected onto SDSS-z filter 
    anyandmask integer, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK
    anyormask integer, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK
    spec1_g real, --/D (S/N)^2 at g=20.20 for spectrograph #1 (same value for 500 fibers)
    spec1_r real, --/D (S/N)^2 at r=20.25 for spectrograph #1 (same value for 500 fibers)
    spec1_i real, --/D (S/N)^2 at i=19.90 for spectrograph #1 (same value for 500 fibers)
    elodie_filename text, --/D File name for best-fit Elodie star
    elodie_object text, --/D Star name (mostly Henry Draper names)
    elodie_sptype text, --/D Spectral type
    elodie_bv real, --/D (B-V) color
    elodie_teff real, --/D Effective temperature
    elodie_logg real, --/D Log10(gravity)
    elodie_feh real, --/U Fe/H
    elodie_z real, --/D redshift
    elodie_z_err real, --/D redshift error; negative for invalid fit
    elodie_z_modelerr real, --/D The standard deviation in redshift amongst the 12 best-fit stars
    elodie_rchi2 real, --/D Reduced chi^2
    elodie_dof integer, --/D Degrees of freedom for fit
    z_noqso real, --/D Redshift of the best-fit non-QSO model (recommended for CMASS and LOZ)
    z_err_noqso real, --/D Formal one-sigma error on Z_NOQSO (recommended for CMASS and LOZ)
    znum_noqso integer, --/D Best fit z/class index excluding QSO; 1-indexed (recommended for CMASS and LOZ)
    zwarning_noqso integer, --/D Redshift warning flag for Z_NOQSO (recommended for CMASS and LOZ)
    class_noqso text, --/D Spectro class of best-fit non-QSO model (recommended for CMASS and LOZ)
    subclass_noqso text, --/D Spectro sub-class of best-fit non-QSO model (recommended for CMASS and LOZ)
    rchi2diff_noqso real, --/D Reduced chi^2 diff to next-best non-QSO model (recommended for CMASS and LOZ)
    specobjid bigint, --/D Unique ID based on Field, MJD, SDSSID, RUN2D, COADD type
    pkey bigint NOT NULL --/D primary key for table entry
);



--
-- Name: dr19_sdssv_plateholes; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdssv_plateholes (
----------------------------------------------------------------------
--/H The combination of the dr19_sdssv_plateholes and dr19_sdssv_plateholes_meta
--/T tables are a database representation of the SDSS-V platelist data <br>
--/T product (https://svn.sdss.org/public/data/sdss/platelist/trunk/). <br>
--/T These tables were used within early iterations of FPS target_selection <br>
--/T as a way to communicate information about which targets had been <br>
--/T included in SDSS-V plates. This information was used to <br>
--/T e.g. de-prioritise targets that were expected to have a good quality <br>
--/T spectroscopic measurement by the end of the SDSS-V plate observations. <br>
--/T The dr19_sdssv_plateholes_meta table contains meta-data for each <br>
--/T SDSS-V plate (one record per plate), whereas the dr19_sdssv_plateholes <br>
--/T table has one entry for each drilled hole in each SDSS-V plate. <br>
--/T The dr19_sdssv_plateholes and dr19_sdssv_plateholes_meta tables should be joined
--/T via the yanny_uid field. <br>
--/T Mostly derived from: https://data.sdss.org/datamodel/files/PLATELIST_DIR/designs
--/T /DESIGNID6XX/DESIGNID6/plateDesign.html
----------------------------------------------------------------------
    holetype text, --/D type of hole to be drilled; one of SDSS, BOSS, MARVELS, APOGEE, GUIDE, CENTER, TRAP, or ALIGNMENT; this really refers to the instrument to be used, so for example SEGUE targets should be either SDSS or BOSS
    targettype text, --/D type of target; one of SCIENCE, STANDARD, or SKY (if holetype is BOSS, SDSS, MARVELS or APOGEE); NA if not holetype is not one of the instruments (GUIDE, CENTER, TRAP, ALIGNMENT)
    sourcetype text, --/D indicate the nature of the source, one of STAR, QSO, GALAXY, or NA (if targettype is NA)
    target_ra double precision, --/D right ascension, in J2000 deg
    target_dec double precision, --/D declination, in J2000 deg
    iplateinput integer, --/D integer indicating which plateInput file from the list in the plateDefinition file this came from (1-indexed); -1 or 0 if the hole wasn't from a plateInput file.
    pointing integer, --/D which pointing (1-indexed) this target is associated with; note this means which pointing among the ones that this plate is designed for, so if this a single pointing plate but uses the B-side MARVELS fibers, this will be "1", not "2"
    offset_integer integer, --/D which offset this target is associated with; 0 means it is not associated with an offset, it is associated with the primary pointing
    fiberid integer, --/D what fiber on the appropriate instrument (as listed in holetype) is assigned to this target (-9999 for none)
    block integer, --/D which fiber block that fiber is associated with (-9999 for none)
    iguide integer, --/D for guide holes, which guide fiber it is assigned to (from 1 to 11) (-9999 for non guide holes)
    xf_default real, --/D X position of hole in focal plane, given a default set of observing parameters (hour angle of zero, temperature of 5 deg C), in units of mm; for position angle of zero (which we always use), +X is +RA
    yf_default real, --/D Y position of hole in focal plane, given a default set of observing parameters (hour angle of zero, temperature of 5 deg C), in units of mm; for position angle of zero (which we always use), +Y is +Dec
    lambda_eff real, --/D wavelength to optimize hole location for, in Angstroms (platedesign will default to 5400 if not set)
    zoffset real, --/D backstopping offset distance, in microns (platedesign will default to 0 if not set)
    bluefiber integer, --/D 1 if the BOSS instrument is meant to assign this target a "blue" fiber; 0 otherwise
    chunk integer, --/D BOSS chunk number (0 if not appropriate)
    ifinal integer, --/D 0-indexed position in BOSS final tiling file (-1 if not appropriate)
    origfile text, --/D for BOSS targets, name of file that target originated within (for BOSS targets, one of the bosstarget files, for ancillary targets, a file within the directory.
    fileindx integer, --/D for BOSS targets, 0-indexed position within ORIGFILE (-1 if not appropriate)
    diameter real, --/D diameter of hole to be drilled, in mm
    buffer real, --/D buffer to leave around hole edge for conflicts in mm
    priority integer, --/D priority number assigned by the plateInput file; lower numbers indicate higher priority
    assigned integer, --/D 1 if this was a target assigned to a fiber, 0 otherwise; clearly for all targets this will be 1 for plateDesign files, but this will not be the case for plateInput-output files, which also have this same format.
    conflicted integer, --/D 1 if this was a target not assigned because of a collision, 0 otherwise; clearly for all targets this will be 0 for plateDesign files, but this will not be the case for plateInput-output files, which also have this same format.
    ranout integer, --/D 1 if this was a target not assigned because we ran out of fibers, 0 otherwise; clearly for all targets this will be 0 for plateDesign files, but this will not be the case for plateInput-output files, which also have this same format.
    outside integer, --/D 1 if this was a target not assigned because it was too fare from the plate center, 0 otherwise; clearly for all targets this will be 0 for plateDesign files, but this will not be the case for plateInput-output files, which also have this same format.
    mangaid text, --/D MaNGA identifier
    ifudesign integer, --/D intended IFU identified for this object
    ifudesignsize integer, --/D number of fibers in intended IFU identified for this object
    bundle_size integer, --/D obsolete; used for number of fibers in bundle for MaNGA prototype cartridge, December 2012
    fiber_size real, --/D obsolete; used for fiber size (in arcsec) for MaNGA prototype cartridge, December 2012
    tmass_j real, --/D 2MASS Point Source Catalog J-band magnitude; Vega-relative; not Galactic extinction corrected; if available
    tmass_h real, --/D 2MASS Point Source Catalog H-band magnitude; Vega-relative; not Galactic extinction corrected, if available
    tmass_k real, --/D 2MASS Point Source Catalog K-band magnitude; Vega-relative; not Galactic extinction corrected, if available
    gsc_vmag real, --/D V mag from GSC if available
    tyc_bmag real, --/D B mag from Tycho2 if available
    tyc_vmag real, --/D V mag from Tycho2 if available
    mfd_mag_u real, --/D MARVELS magnitudes for stars in the PRE_SELECTION plates; VT, BT, V, J, H, K
    mfd_mag_g real, --/D MARVELS magnitudes for stars in the PRE_SELECTION plates; VT, BT, V, J, H, K
    mfd_mag_r real, --/D MARVELS magnitudes for stars in the PRE_SELECTION plates; VT, BT, V, J, H, K
    mfd_mag_i real, --/D MARVELS magnitudes for stars in the PRE_SELECTION plates; VT, BT, V, J, H, K
    mfd_mag_z real, --/D MARVELS magnitudes for stars in the PRE_SELECTION plates; VT, BT, V, J, H, K
    usnob_mag_u real, --/D USNO-B magnitudes if available
    usnob_mag_g real, --/D USNO-B magnitudes if available
    usnob_mag_r real, --/D USNO-B magnitudes if available
    usnob_mag_i real, --/D USNO-B magnitudes if available
    usnob_mag_z real, --/D USNO-B magnitudes if available
    source_id bigint, --/D Gaia source_id, if available
    phot_g_mean_mag real, --/D Gaia G mag if available
    sp_param_source text, --/D source for stellar parameters for MARVELS stars
    marvels_target1 integer, --/D bitmask for MARVELS targeting flags (see the MARVELS target flag descriptions.
    marvels_target2 integer, --/D bitmask for MARVELS targeting flags (see the MARVELS target flag descriptions.
    boss_target1 bigint, --/D bitmask for BOSS targeting flags (see the BOSS target flag descriptions.
    boss_target2 bigint, --/D Always set to zero (placeholder for BOSS target flags never used).
    ancillary_target1 bigint, --/D bitmask for BOSS ancillary targeting flags (see the BOSS target flag descriptions.
    ancillary_target2 bigint, --/D bitmask for BOSS ancillary targeting flags (see the BOSS target flag descriptions.
    segue2_target1 integer, --/D bitmask for SEGUE-2 targeting flags (see the SEGUE-2 target flag descriptions.
    segue2_target2 integer, --/D bitmask for SEGUE-2 targeting flags (see the SEGUE-2 target flag descriptions.
    segueb_target1 integer, --/D bitmask for SEGUE-bright targeting flags (see the SEGUE-bright target flag descriptions.
    segueb_target2 integer, --/D bitmask for SEGUE-bright targeting flags (see the SEGUE-bright target flag descriptions.
    apogee_target1 integer, --/D bitmask for APOGEE targeting flags (see the APOGEE target flag descriptions.
    apogee_target2 integer, --/D bitmask for APOGEE targeting flags (see the APOGEE target flag descriptions.
    manga_target1 integer, --/D bitmask for MaNGA targeting flags. Used for galaxy targets.
    manga_target2 integer, --/D bitmask for MaNGA targeting flags. Used for stars and sky positions.
    manga_target3 integer, --/D bitmask for MaNGA targeting flags. Used for ancillary targets.
    eboss_target0 bigint, --/D bitmask for SEQUels targeting
    eboss_target1 bigint, --/D bitmask for eBOSS targeting
    eboss_target2 bigint, --/D bitmask for eBOSS targeting
    eboss_target_id bigint, --/D n/a ignore
    thing_id_targeting integer, --/D n/a ignore
    objid_targeting bigint, --/D n/a ignore
    apogee2_target1 integer, --/D bitmask for APOGEE2 targeting flags (see the APOGEE2 target flag descriptions.
    apogee2_target2 integer, --/D bitmask for APOGEE2 targeting flags (see the APOGEE2 target flag descriptions.
    apogee2_target3 integer, --/D bitmask for APOGEE2 targeting flags (see the APOGEE2 target flag descriptions.
    run integer, --/D SDSS imaging run, for SDSS imaging based targets
    rerun text, --/D SDSS imaging rerun, for SDSS imaging based targets
    camcol integer, --/D SDSS imaging camcol, for SDSS imaging based targets
    field integer, --/D SDSS imaging field, for SDSS imaging based targets
    id integer, --/D SDSS imaging id, for SDSS imaging based targets
    psfflux_u real, --/D PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_g real, --/D PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_r real, --/D PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_i real, --/D PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_z real, --/D PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_ivar_u real, --/D inverse variance of PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_ivar_g real, --/D inverse variance of PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_ivar_r real, --/D inverse variance of PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_ivar_i real, --/D inverse variance of PSF flux in nanomaggies, for SDSS imaging based targets
    psfflux_ivar_z real, --/D inverse variance of PSF flux in nanomaggies, for SDSS imaging based targets
    fiberflux_u real, --/D 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_g real, --/D 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_r real, --/D 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_i real, --/D 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_z real, --/D 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_ivar_u real, --/D inverse variance of 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_ivar_g real, --/D inverse variance of 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_ivar_r real, --/D inverse variance of 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_ivar_i real, --/D inverse variance of 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiberflux_ivar_z real, --/D inverse variance of 3 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_u real, --/D 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_g real, --/D 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_r real, --/D 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_i real, --/D 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_z real, --/D 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_ivar_u real, --/D inverse variance of 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_ivar_g real, --/D inverse variance of 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_ivar_r real, --/D inverse variance of 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_ivar_i real, --/D inverse variance of 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    fiber2flux_ivar_z real, --/D inverse variance of 2 arcsec fiber flux in nanomaggies, for SDSS imaging based targets
    psfmag_u real, --/D PSF magnitude, for SDSS imaging based targets
    psfmag_g real, --/D PSF magnitude, for SDSS imaging based targets
    psfmag_r real, --/D PSF magnitude, for SDSS imaging based targets
    psfmag_i real, --/D PSF magnitude, for SDSS imaging based targets
    psfmag_z real, --/D PSF magnitude, for SDSS imaging based targets
    fibermag_u real, --/D 3 arcsec fiber magnitude, for SDSS imaging based targets
    fibermag_g real, --/D 3 arcsec fiber magnitude, for SDSS imaging based targets
    fibermag_r real, --/D 3 arcsec fiber magnitude, for SDSS imaging based targets
    fibermag_i real, --/D 3 arcsec fiber magnitude, for SDSS imaging based targets
    fibermag_z real, --/D 3 arcsec fiber magnitude, for SDSS imaging based targets
    fiber2mag_u real, --/D 2 arcsec fiber magnitude, for SDSS imaging based targets
    fiber2mag_g real, --/D 2 arcsec fiber magnitude, for SDSS imaging based targets
    fiber2mag_r real, --/D 2 arcsec fiber magnitude, for SDSS imaging based targets
    fiber2mag_i real, --/D 2 arcsec fiber magnitude, for SDSS imaging based targets
    fiber2mag_z real, --/D 2 arcsec fiber magnitude, for SDSS imaging based targets
    mag_u real, --/D magnitude to use for the SOS software as the best known fiber magnitude for the object
    mag_g real, --/D magnitude to use for the SOS software as the best known fiber magnitude for the object
    mag_r real, --/D magnitude to use for the SOS software as the best known fiber magnitude for the object
    mag_i real, --/D magnitude to use for the SOS software as the best known fiber magnitude for the object
    mag_z real, --/D magnitude to use for the SOS software as the best known fiber magnitude for the object
    epoch real, --/D epoch for which RA and DEC are most appropriate in years AD (default 2011)
    pmra real, --/D proper motion in RA direction in milliarcsec/yr
    pmdec real, --/D proper motion in Dec direction in milliarcsec/yr
    targetids text, --/D free-form, white-space separated list of identifiers
    ifuid integer, --/D n/a ignore
    catalogid bigint, --/D SDSS-V catalogid associated with this target
    gaia_bp real, --/D Gaia BP magnitude (Vega), if available
    gaia_rp real, --/D Gaia RP magnitude (Vega), if available
    gaia_g real, --/D Gaia G magnitude (Vega), if available
    tmass_id text, --/D 2MASS identification, if available
    sdssv_apogee_target0 integer, --/D bitmask for SDSS-V plate-era APOGEE targeting
    sdssv_boss_target0 bigint, --/D bitmask for SDSS-V plate-era BOSS targeting
    gri_gaia_transform integer, --/D n/a ignore
    firstcarton text, --/D name of the SDSS-V carton which was the primary reason this target was assigned a fiber
    xfocal double precision, --/D final X position in the focal plane of the hole, in mm; for position angle of zero (which we always use), +X is +RA
    yfocal double precision, --/D final Y position in the focal plane of the hole, in mm; for position angle of zero (which we always use), +Y is +Dec
    yanny_uid integer, --/D internal integer identifier for the platelist file from which this inforation was extracted
    yanny_filename text, --/D filename from which this information was extracted
    pkey bigint NOT NULL --/D primary key for this table entry
);



--
-- Name: dr19_sdssv_plateholes_meta; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_sdssv_plateholes_meta (
----------------------------------------------------------------------
--/H The combination of the dr19_sdssv_plateholes and dr19_sdssv_plateholes_meta
--/T tables are a database representation of the SDSS-V platelist data <br>
--/T product (https://svn.sdss.org/public/data/sdss/platelist/trunk/). <br>
--/T These tables were used within early iterations of FPS target_selection <br>
--/T as a way to communicate information about which targets had been <br>
--/T included in SDSS-V plates. This information was used to <br>
--/T e.g. de-prioritise targets that were expected to have a good quality <br>
--/T spectroscopic measurement by the end of the SDSS-V plate observations. <br>
--/T The dr19_sdssv_plateholes_meta table contains meta-data for each <br>
--/T SDSS-V plate (one record per plate), whereas the dr19_sdssv_plateholes <br>
--/T table has one entry for each drilled hole in each SDSS-V plate. <br>
--/T The dr19_sdssv_plateholes and dr19_sdssv_plateholes_meta tables should be <br>
--/T joined via the yanny_uid field. <br>
--/T Mostly derived from: https://data.sdss.org/datamodel/files/PLATELIST_DIR/plates/
--/T PLATEID6XX/PLATEID6/plateHoles.html
----------------------------------------------------------------------
    plateid integer, --/D plate ID number
    ha real, --/D the hour angle for which each pointing is designed (negative = rising, positive = setting, given in degrees)
    ha_observable_min real, --/D the minimum observable hour angle to guarantee no hole offsets due to refraction greater than value given by MAX_OFF_FIBER_FOR_HA header keyword in plateDefaults file (negative = rising, positive = setting, given in degrees)
    ha_observable_max real, --/D the minimum observable hour angle to guarantee no hole offsets due to refraction greater than value given by MAX_OFF_FIBER_FOR_HA header keyword in plateDefaults file (negative = rising, positive = setting, given in degrees)
    programname text, --/D The scientific program to which this plate belongs
    temp real, --/D temperature of design (deg C)
    design_platescale_alt real, --/D effective plate scale of the design (in altitude direction, mm per deg)
    design_platescale_az real, --/D effective plate scale of the design (in azimuth direction, mm per deg)
    design_parallactic_angle real, --/D parallactic angle (deg E of N)
    guider_coeff_0 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_1 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_2 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_3 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_4 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_5 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_6 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_7 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_8 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    guider_coeff_9 real, --/D placeholders for guider coefficients, unused (N from 0 to 9)
    locationid integer, --/D An internal identifier for each unique location on the sky for which SDSS-V plates were designed
    instruments text, --/D list of instrument names that are used in this type of plate (allowed: "SDSS", "BOSS", "MARVELS", "APOGEE")
    npointings integer, --/D number of pointings that the plate is designed to make; each pointing will correspond to one or more exposures during observation; number must be less than or equal to 6
    noffsets integer, --/D number of offsets to perform within each exposure
    minstdinblockboss_shared text, --/D for the given instrument, specify if we have a minimum number of standards we want to assign per fiber block (default 0)
    maxskyinblockboss_shared integer, --/D for the given instrument, specify if we have a maximum number of skies we want to assign per fiber block (default 0)
    gfibertype text, --/D type of guide fibers to assume (old "gfiber" or new "gfiber2")
    guidetype text, --/D for each pointing, the source to search for guide fibers from (can be "SDSS" or "2MASS")
    guidemag_min real, --/U 13, 15.5 --/D minimum and maximum g-band magnitudes for guide stars (default: 
    guidemag_max real, --/U 13, 15.5 --/D minimum and maximum g-band magnitudes for guide stars (default: 
    guide_lambda_eff real, --/D The effective wavelength at which to guide, Angstroms
    nguidemax integer, --/D maximum number of possible guide stars to track, otherwise tracks 10s of thousands at low b (default: infinite)
    ferrulesizeboss_shared real, --/D for specified instrument, diameter of ferrule in mm; must exist for all instruments, plus also for instrument=GUIDE
    buffersizeboss_shared real, --/D for specified instrument, buffer to include outside ferrule for checking for conflicts; must exist for all instruments, plus also for instrument=GUIDE
    ferrulesizeapogee_shared real, --/D for specified instrument, diameter of ferrule in mm; must exist for all instruments, plus also for instrument=GUIDE
    buffersizeapogee_shared real, --/D for specified instrument, diameter of ferrule in mm; must exist for all instruments, plus also for instrument=GUIDE
    ferrulesizeguide real, --/D for specified instrument, diameter of ferrule in mm; must exist for all instruments, plus also for instrument=GUIDE
    buffersizeguide real, --/D for specified instrument, buffer to include outside ferrule for checking for conflicts; must exist for all instruments, plus also for instrument=GUIDE
    platedesignstandards text, --/D specify what instruments we want plate design to find standards for; otherwise one of the plateInput files specified by the plateDefinition file should find them; (default: plate design doesn't find standards)
    standardtype text, --/D for each pointing, type of standard to find (can be "SDSS" or "2MASS", or "None" --- in fact, any value other than SDSS or 2MASS is equivalent to "None")
    platedesignskies text, --/D specify what instruments we want plate design to find skies for, if any
    skytype text, --/D for each pointing, type of skies to find (can be "SDSS" or "2MASS")
    plugmapstyle text, --/D type of plugmap file to create (default "plplugmap")
    bossmagtype text, --/D type of magnitude used for fiber magnitudes for BOSS targets
    pointing_name text, --/D "name" for each of the pointings (in legacy plates where not given, default to "A B C D E F")
    max_off_fiber_for_ha real, --/D set HA limits (ha_observable_min, haobservable_max) to guarantee no offsets greater than this limit, in arcsec (platedesign v1_27 and above)
    collectfactor integer, --/D oversampling factor for collecting skies and standards; to ensure pluggability, should be at least 5 (default: 5)
    designid integer, --/D design identification number
    platedesignversion text, --/D version of plateDefault file to use (for backwards compatibility; if specified it must agree with the corresponding entry in the platePlans file
    platetype text, --/D type of plateDefault file to use (always "APOGEE-BOSS")
    racen real, --/D right ascension of pointing center, J2000 deg
    deccen real, --/D declination of pointing center, J2000 deg
    ninputs integer, --/D Number of input files to platedesign
    plateinput1 text, --/D filename of input to platedesign
    plateinput2 text, --/D filename of input to platedesign
    plateinput3 text, --/D filename of input to platedesign
    plateinput4 text, --/D filename of input to platedesign
    plateinput5 text, --/D filename of input to platedesign
    plateinput6 text, --/D filename of input to platedesign
    plateinput7 text, --/D filename of input to platedesign
    priority text, --/D order of priority for input files; lower numbers get checked first; if two files have the same priority, their targets are checked simultaneously (in order of the individual priority number for each object); (default is 1..nInputs).
    relaxed_fiber_classes integer, --/D for APOGEE, do not break target classes up into bright/medium/faint.
    targettypes text, --/D Which targettypes to include in plate design (e.g. "standard science sky")
    napogee_shared_standard integer, --/D The number of APOGEE standard star targets in this plate
    napogee_shared_science integer, --/D The number of APOGEE science targets in this plate
    napogee_shared_sky integer, --/D - The number of APOGEE sky targets in this plate
    nboss_shared_standard integer, --/D The number of BOSS standard star targets in this plate
    nboss_shared_science integer, --/D The number of BOSS science targets in this plate
    nboss_shared_sky integer, --/D The number of BOSS sky targets in this plate
    minskyinblockboss_shared integer, --/D for the given instrument, specify if we have a minimum number of skies we want to assign per fiber block (default 0)
    minstandardinblockboss_shared text, --/D for the given instrument, specify if we have a minimum number of standards we want to assign per fiber block (default 0)
    reddeningmed_u real, --/U mag --/D The estimated Galactic reddening (u-band) at the sky location of this plate 
    reddeningmed_g real, --/U mag --/D The estimated Galactic reddening (g-band) at the sky location of this plate 
    reddeningmed_r real, --/U mag --/D The estimated Galactic reddening (r-band) at the sky location of this plate 
    reddeningmed_i real, --/U mag --/D The estimated Galactic reddening (i-band) at the sky location of this plate 
    reddeningmed_z real, --/U mag --/D The estimated Galactic reddening (z-band) at the sky location of this plate 
    tileid integer, --/D Not used
    theta integer, --/D position angle of design (always 0 in practice)
    platerun text, --/D name of platerun this file was part of
    platedesign_version text, --/D version of platedesign used to produce design file
    yanny_uid integer NOT NULL, --/D internal integer identifier for the platelist file from which this inforation was extracted
    yanny_filename text, --/D filename from which this information was extracted
    plateinput8 text, --/D filename of input to platedesign
    plateinput9 text, --/D filename of input to platedesign
    plateinput10 text, --/D filename of input to platedesign
    plateinput11 text, --/D filename of input to platedesign
    plateinput12 text, --/D filename of input to platedesign
    plateinput13 text, --/D filename of input to platedesign
    plateinput14 text, --/D filename of input to platedesign
    plateinput15 text, --/D filename of input to platedesign
    plateinput16 text, --/D filename of input to platedesign
    skyinput17 text, --/D filename of input to platedesign
    plateinput18 text, --/D filename of input to platedesign
    plateinput17 text, --/D filename of input to platedesign
    skyinput18 text, --/D filename of input to platedesign
    plateinput19 text, --/D filename of input to platedesign
    skyinput16 text, --/D filename of input to platedesign
    skyinput19 text, --/D filename of input to platedesign
    plateinput20 text, --/D filename of input to platedesign
    skyinput15 text, --/D filename of input to platedesign
    skyinput21 text, --/D filename of input to platedesign
    plateinput22 text, --/D filename of input to platedesign
    skyinput13 text, --/D filename of input to platedesign
    skyinput20 text, --/D filename of input to platedesign
    plateinput21 text, --/D filename of input to platedesign
    skyinput14 text, --/D filename of input to platedesign
    skyinput6 text, --/D filename of input to platedesign
    defaultsurveymode text, --/D Which mapper leads the plate design (bhmLead or mwmLead). Ony set for plateID>=15072.
    skyinput23 text, --/D filename of input to platedesign
    plateinput24 text, --/D filename of input to platedesign
    skyinput22 text, --/D filename of input to platedesign
    plateinput23 text, --/D filename of input to platedesign
    skyinput8 text, --/D filename of input to platedesign
    isvalid boolean --/D Whether the plate design is valid (i.e. eligible for drilling+plugging)
);



--
-- Name: dr19_skies_v1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_skies_v1 (
----------------------------------------------------------------------
--/H This table stores the positions used as blank sky regions for DR19 targetting. The sky regions are selected by dividing the sky in tiles of HEALpix nside 32. Each tile is then subdivided in candidate regions of HEALpix nside 32768 and the pixels that meet the isolation requirements are considered valid skies. This process is repeated for a number of all-sky catalogues. See <a href="https://sdss.org/dr19/targeting/fps/sky/"> for further details of the process by which suitable sky locations are selected in SDSS-V/FPS. This version of the skies catalog was used for v0.1 target selection. The skies_v2 catalog was used for v0.5 and subsequent target selections.
----------------------------------------------------------------------
    pix_32768 bigint NOT NULL, --/D The HEALpix pixel (nside=32768, nested indexing, Equatorial coords) of the sky region. 
    ra double precision, --/U degrees --/D The RA of the centre of the sky pixel. 
    "dec" double precision, --/U degrees --/D The declination of the centre of the sky pixel. 
    down_pix integer, --/D The HEALpix pixel (nside=256, nested indexing, Equatorial coords) of the sky region. Used internally to downsample the list of candidate region. 
    tile_32 integer, --/D The HEALpix pixel (nside=32, nested indexing, Equatorial coords) of the sky region. 
    gaia_sky boolean, --/D Whether this is a valid sky region in the Gaia DR2 catalogue. 
    sep_neighbour_gaia real, --/U arcsec --/D Separation to the nearest Gaia DR2 neighbour. 
    mag_neighbour_gaia real, --/U mag --/D Magnitude of the nearest Gaia DR2 neighbour (G band, Vega). 
    ls8_sky boolean, --/D Whether this is a valid sky region in the Legacy Survey DR8 catalogue. 
    sep_neighbour_ls8 real, --/U arcsec --/D Separation to the nearest Legacy Survey DR8 neighbour. 
    mag_neighbour_ls8 real, --/U mag --/D Magnitude of the nearest Legacy Survey DR8 neighbour (r-band, AB). 
    tmass_sky boolean, --/D Whether this is a valid sky region in the 2MASS point source catalogue. 
    sep_neighbour_tmass real, --/U arcsec --/D Separation to the nearest 2MASS point source neighbour. 
    mag_neighbour_tmass real, --/U mag --/D Magnitude of the nearest 2MASS point source neighbour (H band, Vega). 
    tycho2_sky boolean, --/D Whether this is a valid sky region in the Tycho2 catalogue. 
    sep_neighbour_tycho2 real, --/U arcsec --/D Separation to the nearest Tycho2 neighbour. 
    mag_neighbour_tycho2 real, --/U mag --/D Magnitude of the nearest Tycho2 neighbour (Vt band, Vega). 
    tmass_xsc_sky boolean, --/D Whether this is a valid sky region in the 2MASS extended source catalogue. 
    sep_neighbour_tmass_xsc real, --/U arcsec --/D Separation to the nearest 2MASS extended source neighbour 
    mag_neighbour_tmass_xsc real --/U mag --/D Magnitude of the nearest 2MASS extended source neighbour (H band, Vega). 
);



--
-- Name: dr19_skies_v2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_skies_v2 (
----------------------------------------------------------------------
--/H This table stores the positions used as blank sky regions for dr19 targetting. The sky regions are selected by dividing the sky in tiles of HEALpix nside 32. Each tile is then subdivided in candidate regions of HEALpix nside 32768 and the pixels that meet the isolation requirements are considered valid skies. This process is repeated for a number of all-sky catalogues. See <a href="https://sdss.org/dr19/targeting/fps/sky/"> for further details of the process by which suitable sky locations are selected in SDSS-V/FPS.
----------------------------------------------------------------------
    pix_32768 bigint NOT NULL, --/D The HEALpix pixel (nside=32768, nested indexing, Equatorial coords) of the sky region. 
    ra double precision, --/U degrees --/D The RA of the centre of the sky pixel. 
    "dec" double precision, --/U degrees --/D The declination of the centre of the sky pixel. 
    down_pix bigint, --/D The HEALpix pixel (nside=256, nested indexing, Equatorial coords) of the sky region. Used internally to downsample the list of candidate region. 
    tile_32 bigint, --/D The HEALpix pixel (nside=32, nested indexing, Equatorial coords) of the sky region. 
    valid_gaia boolean, --/D Whether this is a valid sky region in the Gaia catalogue. 
    selected_gaia boolean, --/D Whether this sky region was selected in the Gaia catalogue. 
    sep_neighbour_gaia real, --/U arcsec --/D Separation to the nearest Gaia DR2 neighbour 
    mag_neighbour_gaia real, --/U mag --/D Magnitude of the nearest Gaia DR2 neighbour (G band, Vega). 
    valid_ls8 boolean, --/D Whether this is a valid sky region in the Legacy Survey DR8 catalogue. 
    selected_ls8 boolean, --/D Whether this sky region was selected in the Legacy Survey DR8 catalogue. 
    sep_neighbour_ls8 real, --/U arcsec --/D Separation to the nearest Legacy Survey DR8 neighbour 
    mag_neighbour_ls8 real, --/U mag --/D Magnitude of the nearest Legacy Survey DR8 neighbour (r-band, AB). 
    valid_ps1dr2 boolean, --/D Whether this is a valid sky region in the PanSTARRS1 DR2 catalogue. 
    selected_ps1dr2 boolean, --/D Whether this sky region was selected in the PanSTARRS1 DR2 catalogue. 
    sep_neighbour_ps1dr2 real, --/U arcsec --/D Separation to the nearest PanSTARRS1 DR2 neighbour 
    mag_neighbour_ps1dr2 real, --/U mag --/D Magnitude of the nearest PanSTARRS1 DR2 neighbour (r-band, AB). 
    valid_tmass boolean, --/D Whether this is a valid sky region in the 2MASS point source catalogue. 
    selected_tmass boolean, --/D Whether this sky region was selected in the 2MASS point source catalogue. 
    sep_neighbour_tmass real, --/U arcsec --/D Separation to the nearest 2MASS point source neighbour 
    mag_neighbour_tmass real, --/U mag --/D Magnitude of the nearest 2MASS point source neighbour (H band, Vega). 
    valid_tycho2 boolean, --/D Whether this is a valid sky region in the Tycho2 catalogue.
    selected_tycho2 boolean, --/D Whether this sky region was selected in the Tycho2 catalogue.
    sep_neighbour_tycho2 real, --/U arcsec --/D Separation to the nearest Tycho2 neighbour 
    mag_neighbour_tycho2 real, --/U mag --/D Magnitude of the nearest Tycho2 neighbour (Vt band, Vega). 
    valid_tmass_xsc boolean, --/D Whether this is a valid sky region in the 2MASS extended source catalogue. 
    selected_tmass_xsc boolean, --/D Whether this sky region was selected in the 2MASS extended source catalogue. 
    sep_neighbour_tmass_xsc real --/U arcsec --/D Separation to the nearest 2MASS extended source neighbour 
);



--
-- Name: dr19_skymapper_dr2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_skymapper_dr2 (
----------------------------------------------------------------------
--/H Skymapper Data Release 2 photometry. For detailed descriptions, please see the SkyMapper documentation: https://skymapper.anu.edu.au/table-browser/
----------------------------------------------------------------------
    object_id bigint NOT NULL, --/D Global unique SkyMapper object ID in the master table 
    raj2000 double precision, --/U degrees --/D Mean ICRS Right Ascension of the object 
    dej2000 double precision, --/U degrees --/D Mean ICRS Declination of the object 
    e_raj2000 integer, --/U mas --/D RMS variation around the mean Right Ascension 
    e_dej2000 integer, --/U mas --/D RMS variation around the mean Declination 
    smss_j character(18), --/D SkyMapper Southern Survey designation of the form SMSS Jhhmmss.ss+/-ddmmss.s 
    mean_epoch double precision, --/U days --/D Mean MJD epoch of the observations 
    rms_epoch real, --/U days --/D RMS variation around the mean epoch 
    glon real, --/U degrees --/D Galactic longitude derived from ICRS coordinate 
    glat real, --/U degrees --/D Galactic latitude derived from ICRS coordinate 
    flags smallint, --/D Bitwise OR of Source Extractor flags across all observations 
    nimaflags integer, --/D Total number of flagged pixels from bad, saturated, and crosstalk pixel masks across all observations 
    ngood smallint, --/D Number of observations used across all filters	
    ngood_min smallint, --/D Minimum number of observations used in any filter 
    nch_max smallint, --/D Maximum number of child sources combined into this global object_id in any filter 
    density real, --/D Number of DR2 sources within 15 arcsec (including this source) 
    u_flags smallint, --/D Bitwise OR of Source Extractor flags from u-band measurements in photometry table
    u_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel masks from u-band measurements in photometry table
    u_ngood smallint, --/D Number of u-band observations used 
    u_nch smallint, --/D Number of u-band child sources combined into this object_id 
    u_nclip smallint, --/D Number of u-band observations with magnitudes clipped from the final PSF magnitude estimate 
    v_flags smallint, --/D Bitwise OR of Source Extractor flags from v-band measurements in photometry table
    v_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel masks from u-band measurements in photometry table
    v_ngood smallint, --/D Number of v-band observations used 
    v_nch smallint, --/D Number of v-band child sources combined into this object_id 
    v_nclip smallint, --/D Number of v-band observations with magnitudes clipped from the final PSF magnitude estimate 
    g_flags smallint, --/D Bitwise OR of Source Extractor flags from g-band measurements in photometry table
    g_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel masks from g-band measurements in photometry table 
    g_ngood smallint, --/D Number of g-band observations used 
    g_nch smallint, --/D Number of g-band child sources combined into this object_id 
    g_nclip smallint, --/D Number of g-band observations with magnitudes clipped from the final PSF magnitude estimate 
    r_flags smallint, --/D Bitwise OR of Source Extractor flags from r-band measurements in photometry table
    r_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel masks from r-band measurements in photometry table 
    r_ngood smallint, --/D Number of r-band observations used 
    r_nch smallint, --/D Number of r-band child sources combined into this object_id 
    r_nclip smallint, --/D Number of r-band observations with magnitudes clipped from the final PSF magnitude estimate 
    i_flags smallint, --/D Bitwise OR of Source Extractor flags from i-band measurements in photometry table
    i_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel masks from i-band measurements in photometry table 
    i_ngood smallint, --/D Number of i-band observations used 
    i_nch smallint, --/D Number of i-band child sources combined into this object_id 
    i_nclip smallint, --/D Number of i-band observations with magnitudes clipped from the final PSF magnitude estimate 
    z_flags smallint, --/D Bitwise OR of Source Extractor flags from z-band measurements in photometry table
    z_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel masks from z-band measurements in photometry table 
    z_ngood smallint, --/D Number of z-band observations used 
    z_nch smallint, --/D Number of z-band child sources combined into this object_id 
    z_nclip smallint, --/D Number of a-band observations with magnitudes clipped from the final PSF magnitude estimate 
    class_star real, --/D Maximum stellarity index from photometry table (between 0=no star and 1=star) 
    flags_psf integer, --/D Bitmask indicating whether photometry is likely biased by neighbours at greater than 1% 
    radius_petro real, --/U pix --/D Mean r-band Petrosian radius 
    u_psf real, --/U mag --/D Mean u-band PSF magnitude 
    e_u_psf real, --/U mag --/D Error in u-band PSF magnitude 
    u_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the u-band PSF magnitude, including clipped sources 
    u_petro real, --/U mag --/D Mean u-band Petrosian magnitude 
    e_u_petro real, --/U mag --/D Error in u-band Petrosian magnitude 
    v_psf real, --/U mag --/D Mean v-band PSF magnitude 
    e_v_psf real, --/U mag --/D Error in v-band PSF magnitude 
    v_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the v-band PSF magnitude, including clipped sources 
    v_petro real, --/U mag --/D Mean v-band Petrosian magnitude 
    e_v_petro real, --/U mag --/D Error in v-band Petrosian magnitude 
    g_psf real, --/U mag --/D Mean g-band PSF magnitude 
    e_g_psf real, --/U mag --/D Error in g-band PSF magnitude 
    g_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the g-band PSF magnitude, including clipped sources 
    g_petro real, --/U mag --/D Mean g-band Petrosian magnitude 
    e_g_petro real, --/U mag --/D Error in g-band Petrosian magnitude 
    r_psf real, --/U mag --/D Mean r-band PSF magnitude 
    e_r_psf real, --/U mag --/D Error in r-band PSF magnitude 
    r_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the r-band PSF magnitude, including clipped sources 
    r_petro real, --/U mag --/D Mean r-band Petrosian magnitude 
    e_r_petro real, --/U mag --/D Error in r-band Petrosian magnitude 
    i_psf real, --/U mag --/D Mean i-band PSF magnitude 
    e_i_psf real, --/U mag --/D Error in i-band PSF magnitude 
    i_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the i-band PSF magnitude, including clipped sources 
    i_petro real, --/U mag --/D Mean i-band Petrosian magnitude 
    e_i_petro real, --/U mag --/D Error in i-band Petrosian magnitude 
    z_psf real, --/U mag --/D Mean z-band PSF magnitude 
    e_z_psf real, --/U mag --/D Error in z-band PSF magnitude 
    z_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the z-band PSF magnitude, including clipped sources 
    z_petro real, --/U mag --/D Mean z-band Petrosian magnitude 
    e_z_petro real, --/U mag --/D Error in z-band Petrosian magnitude 
    ebmv_sfd real, --/U mag --/D E(B-V) from Schlegel+1998 extinction maps at the ICRS coordinates 
    prox real, --/U arcsec --/D Distance to next-closest DR2 source 
    prox_id bigint, --/D object_id of next-closest DR2 source 
    dr1_id bigint, --/D object_id of closest SkyMapper Data Release 1 source 
    dr1_dist real, --/U arcsec --/D Distance to closest SkyMapper Data Release 1 source 
    twomass_key bigint, --/D Unique identifier (pts_key) of closest 2MASS PSC source 
    twomass_dist real, --/U arcsec --/D Distance on sky to closest 2MASS PSC source 
    allwise_cntr bigint, --/D Unique identifier (cntr) of closest AllWISE source 
    allwise_dist real, --/U arcsec --/D Distance on sky to closest AllWISE source 
    ucac4_mpos bigint, --/D Unique identifier (mpos) of closest UCAC4 source 
    ucac4_dist real, --/U arcsec --/D Distance on sky to closest UCAC4 source 
    refcat2_id bigint, --/D Unique identifier (objid) of closest ATLAS Refcat2 source 
    refcat2_dist real, --/U arcsec --/D Distance on sky to closest ATLAS Refcat2 source 
    ps1_dr1_id bigint, --/D Unique identifier (objID) of closest Pan-STARRS1 DR1 source 
    ps1_dr1_dist real, --/U arcsec --/D Distance on sky to closest Pan-STARRS1 DR1 source 
    galex_guv_id bigint, --/D Unique identifier (objid) of closest GALEX GUVcat AIS source (Bianchi et al. 2017) 
    galex_guv_dist real, --/U arcsec --/D Distance on sky to closest GALEX GUVcat AIS source 
    gaia_dr2_id1 bigint, --/D Unique identifier (source_id) of closest Gaia DR2 source 
    gaia_dr2_dist1 real, --/U arcsec --/D Distance on sky to closest Gaia DR2 source 
    gaia_dr2_id2 bigint, --/D Unique identifier (source_id) of second-closest Gaia DR2 source 
    gaia_dr2_dist2 real --/U arcsec --/D Distance on sky to second-closest Gaia DR2 source 
);



--
-- Name: dr19_skymapper_gaia; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_skymapper_gaia (
----------------------------------------------------------------------
--/H This catalogue contains photometric stellar parameters for 9+ million stars in common between the SkyMapper survey and Gaia DR2. See https://skymapper.anu.edu.au/_data/sm-gaia/ for details.
----------------------------------------------------------------------
    skymapper_object_id bigint NOT NULL, --/D SkyMapper object_id 
    gaia_source_id bigint, --/D Gaia DR2 source_id 
    teff real, --/U K --/D Effective temperature 
    e_teff real, --/U K --/D Effective temperature uncertainty 
    feh real, --/U dex --/D Metallicity 
    e_feh real --/U dex --/D Metallicity uncertainty 
);



--
-- Name: dr19_supercosmos; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_supercosmos (
----------------------------------------------------------------------
--/H Contains merged sources for every field in the SuperCOSMOS Science Archive (SSA).
--/T It consists of data from digitised sky survey plates taken with the UK Schmidt <br>
--/T telescope (UKST), the ESO Schmidt, and the Palomar Schmidt. <br>
--/T Each field within the SSA is covered by four plates in passbands B, R and <br>
--/T I with R being covered twice at different times. This results in <br>
--/T four-plate multi-colour, multi-epoch data which are merged into a single <br>
--/T source catalogue for general science exploitation. This table contains the <br>
--/T associated merged records created from the records in table Detection, <br>
--/T along with a full astrometric solution (including proper motions) computed <br>
--/T from the available position measures. The most useful subset of image <br>
--/T morphological descriptors are also propagated into this table for ease of <br>
--/T use. <br>
--/T Derived from http://ssa.roe.ac.uk/www/SSA_TABLE_SourceSchema.html#Source
----------------------------------------------------------------------
    objid bigint NOT NULL, --/D Unique identifier of merged source 
    objidb bigint, --/D objID for B band detection merged into this object 
    objidr1 bigint, --/D objID for R1 band detection merged into this object 
    objidr2 bigint, --/D objID for R2 band detection merged into this object 
    objidi bigint, --/D objID for I band detection merged into this object 
    htmid bigint, --/D Hierarchical Triangular Mesh (20-deep) of centroid 
    epoch real, --/U yr --/D Epoch of position (variance weighted mean epoch of available measures) 
    ra double precision, --/U deg --/D Mean RA, computed from detections merged in this catalogue 
    "dec" double precision, --/U deg --/D Mean Dec, computed from detections merged in this catalogue 
    sigra double precision, --/U deg --/D Uncertainty in RA (formal random error not inc. systematic errors) 
    sigdec double precision, --/U deg --/D Uncertainty in Dec (formal random error not inc. systematic errors) 
    cx double precision, --/D Cartesian x of unit (ra,dec) vector on celestial sphere 
    cy double precision, --/D Cartesian y of unit (ra,dec) vector on celestial sphere 
    cz double precision, --/D Cartesian z of unit (ra,dec) vector on celestial sphere 
    muacosd real, --/U mas/yr --/D Proper motion in RA direction 
    mud real, --/U mas/yr --/D Proper motion in Dec direction 
    sigmuacosd real, --/U mas/yr --/D Error on proper motion in RA direction 
    sigmud real, --/U mas/yr --/D Error on proper motion in Dec direction 
    chi2 real, --/D Chi-squared value of proper motion solution 
    nplates smallint, --/D No. of plates used for this proper motion measurement 
    classmagb real, --/U mag --/D B band magnitude selected by B image class 
    classmagr1 real, --/U mag --/D R1 band magnitude selected by R1 image class 
    classmagr2 real, --/U mag --/D R2 band magnitude selected by R2 image class 
    classmagi real, --/U mag --/D I band magnitude selected by I image class 
    gcormagb real, --/U mag --/D B band magnitude assuming object is galaxy 
    gcormagr1 real, --/U mag --/D R1 band magnitude assuming object is galaxy 
    gcormagr2 real, --/U mag --/D R2 band magnitude assuming object is galaxy 
    gcormagi real, --/U mag --/D I band magnitude assuming object is galaxy 
    scormagb real, --/U mag --/D B band magnitude assuming object is star 
    scormagr1 real, --/U mag --/D R1 band magnitude assuming object is star 
    scormagr2 real, --/U mag --/D R2 band magnitude assuming object is star 
    scormagi real, --/U mag --/D I band magnitude assuming object is star 
    meanclass smallint, --/D Estimate of image class based on unit-weighted mean of individual classes 
    classb smallint, --/D Image classification from B band detection 
    classr1 smallint, --/D Image classification from R1 band detection 
    classr2 smallint, --/D Image classification from R2 band detection 
    classi smallint, --/D Image classification from I band detection 
    ellipb real, --/D Ellipticity of B band detection 
    ellipr1 real, --/D Ellipticity of R1 band detection 
    ellipr2 real, --/D Ellipticity of R2 band detection 
    ellipi real, --/D Ellipticity of I band detection 
    qualb integer, --/D Bitwise quality flag from B band detection 
    qualr1 integer, --/D Bitwise quality flag from R1 band detection 
    qualr2 integer, --/D Bitwise quality flag from R2 band detection 
    quali integer, --/D Bitwise quality flag from I band detection 
    blendb integer, --/D Blend flag from B band detection 
    blendr1 integer, --/D Blend flag from R1 band detection 
    blendr2 integer, --/D Blend flag from R2 band detection 
    blendi integer, --/D Blend flag from I band detection 
    prfstatb real, --/D Profile statistic from B band detection 
    prfstatr1 real, --/D Profile statistic from R1 band detection 
    prfstatr2 real, --/D Profile statistic from R2 band detection 
    prfstati real, --/D Profile statistic from I band detection 
    l real, --/U deg --/D The Galactic longitude of the source 
    b real, --/U deg --/D The Galactic latitude of the source 
    d real, --/U deg --/D The great-circle distance of the source from the Galactic centre 
    ebmv real --/U mag --/D The estimated foreground reddening at this position from Schlegel et al. (1998) 
);



--
-- Name: dr19_target; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_target (
----------------------------------------------------------------------
--/H This table stores the targets associated with dr19 target selection cartons. Note that the targets in this table are unique, but a target can be associated with multiple cartons. That many-to-many relationship is encoded in the dr19_carton_to_target table.
----------------------------------------------------------------------
    target_pk bigint NOT NULL, --/D The primary key. A sequential identifier. 
    ra double precision, --/U degree --/D The right ascension of the target in ICRS coordinates at epoch. From dr19_catalog. 
    "dec" double precision, --/U degree --/D The declination of the target in ICRS coordinates at epoch. From dr19_catalog. 
    pmra real, --/U mas/yr --/D The proper motion in right ascenscion of the target, as a true angle. From dr19_catalog. 
    pmdec real, --/U mas/yr --/D The proper motion in declination of the target. From dr19_catalog. 
    epoch real, --/U years --/D The epoch of the coordinates, as a Julian epoch. 
    parallax real, --/U arcsec --/D The parallax of the target. From dr19_catalog. 
    catalogid bigint --/D The catalogid of the entry in dr19_catalog associated with this target. 
);



--
-- Name: dr19_target_union_legacy; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_target_union_legacy (
    catalogid bigint
);



--
-- Name: dr19_targetdb_version; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_targetdb_version (
----------------------------------------------------------------------
--/H List of versions associated with target selection cartons and robostategy runs.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D Unique identifier 
    plan text, --/D Labeled human readable version 
    tag text, --/D Tag of target selection version used, https://github.com/sdss/target_selection/releases 
    target_selection boolean, --/U boolean --/D Flag, associated with target selection 
    robostrategy boolean --/U boolean --/D Flag, associated with robostrategy run 
);



--
-- Name: dr19_targeting_generation; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_targeting_generation (
----------------------------------------------------------------------
--/H A 'targeting_generation' describes a collection of versioned cartons,
--/T together with their robostrategy control parameters. This is a convenient <br>
--/T way to describe the specific set of carton-versions that were used <br>
--/T (and the way that they were treated) within any particular run of <br>
--/T robostrategy. <br>
--/T The dr19_targeting_generation table contains all targeting_generations <br>
--/T that were considered for observations in the timespan covered by the <br>
--/T DR19 data release. In addition, we include the 'v0.5.3' targeting_generation <br>
--/T since this was the version released as part of dr19. <br>
--/T During the initial plate operations phase of SDSS-V, we did not use <br>
--/T the robostrategy code to assign fibers to targets. However, for <br>
--/T completeness, the 'v0.plates' pseudo-targeting_generation has been <br>
--/T reverse engineered in order to describe the set of carton-versions <br>
--/T that were considered during that phase. <br>
--/T The dr19_targeting_generation table can be joined <br>
--/T to the dr19_carton table via the dr19_targeting_generation_to_carton <br>
--/T table. To associate a targeting_generation with a robostrategy plan, <br>
--/T join dr19_targeting_generation to dr19_targetdb_version via the <br>
--/T dr19_targeting_generation_to_version table. <br>
--/T Taken together, the dr19_targeting_generation, <br>
--/T dr19_targeting_generation_to_carton and <br>
--/T dr19_targeting_generation_to_version tables duplicate, in a database <br>
--/T form, the robostrategy carton configuration information available <br>
--/T via the rsconfig product (https://github.com/sdss/rsconfig).
----------------------------------------------------------------------
    pk integer NOT NULL, --/D primary key for this table entry
    label text, --/D A human-readble name for the targeting_generation
    first_release text --/D The first SDSS data release containing this targeting_generation
);



--
-- Name: dr19_targeting_generation_to_carton; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_targeting_generation_to_carton (
----------------------------------------------------------------------
--/H A 'targeting_generation' describes a collection of versioned cartons,
--/T together with their robostrategy control parameters. This is a convenient <br>
--/T way to describe the specific set of carton-versions that were used <br>
--/T (and the way that they were treated) within any particular run of <br>
--/T robostrategy. <br>
--/T The dr19_targeting_generation_to_carton table describes a many-to-many <br>
--/T relationship, connecting each targeting_generation to a set of entries <br>
--/T in the dr19_carton table, as well as recording how those <br>
--/T carton-versions were treated in the robostrategy code (i.e. the <br>
--/T rs_stage and rs_active parameters). <br>
--/T Taken together, the dr19_targeting_generation, <br>
--/T dr19_targeting_generation_to_carton and <br>
--/T dr19_targeting_generation_to_version tables duplicate, in a database <br>
--/T form, the robostrategy carton configuration information available <br>
--/T via the rsconfig product (https://github.com/sdss/rsconfig).
----------------------------------------------------------------------
    pk integer NOT NULL, --/D primary key for this table entry
    generation_pk integer, --/D primary key of an entry in the dr19_targeting_generation table
    carton_pk integer, --/D primary key of an entry in the dr19_carton table, i.e. a carton-version
    rs_stage text, --/D the algorithimic stage of robostrategy in which targets from this carton-version are considered for assignment. Options: 'none', 'plates', 'srd', 'filler', or 'open'. See the robostrategy documentation for further information.
    rs_active boolean --/D a Boolean column describing whether the carton-version is considered within robostrategy
);



--
-- Name: dr19_targeting_generation_to_version; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_targeting_generation_to_version (
----------------------------------------------------------------------
--/H A 'targeting_generation' describes a collection of versioned cartons,
--/T together with their robostrategy control parameters. This is a convenient <br>
--/T way to describe the specific set of carton-versions that were used <br>
--/T (and the way that they were treated) within any particular run of <br>
--/T robostrategy. <br>
--/T The dr19_targeting_generation_to_version table describes a one-to-many <br>
--/T relationship, connecting each robostrategy run to one targeting_generation. <br>
--/T In general, a single target_generation can be used my more than one robostrategy
--/T run. <br>
--/T Taken together, the dr19_targeting_generation, <br>
--/T dr19_targeting_generation_to_carton and <br>
--/T dr19_targeting_generation_to_version tables duplicate, in a database <br>
--/T form, the robostrategy carton configuration information available <br>
--/T via the rsconfig product (https://github.com/sdss/rsconfig).
----------------------------------------------------------------------
    generation_pk integer, --/D primary key of an entry in the dr19_targeting_generation table
    version_pk integer, --/D primary key of an entry in the dr19_targetdb_version table, which lists the robostrategy run version ('plan' and 'tag')
    pk integer NOT NULL --/D primary key for this table entry
);



--
-- Name: dr19_tess_toi; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_tess_toi (
----------------------------------------------------------------------
--/H This catalog contains targets that recieved the 2 minute cadence during the TESS Mission, are TESS Objects of Interest (TOI) or Community TESS Objects of Interest (CTOI). The contents of this catalog were derived from the MIT TESS website (https://tess.mit.edu/public/target_lists/target_lists.html) and the ExoFOP website https://exofop.ipac.caltech.edu/tess/index.php. These targets were updated on 2020-04-02.
----------------------------------------------------------------------
    ticid bigint, --/D TESS Input Catalog (TIC) ID 
    target_type character varying(8), --/D Type of target. Options: 2min = 2 minute cadence, exo_TOI = TOI, and exo_CTOI = CTOI 
    toi character varying(32), --/D TESS Object of Interest ID 
    tess_disposition character varying(2), --/D TESS Team Dispositon Options: EB = Eclipsing Binary, KP = Known Planet, PC = Planet Candidate, O = Other, or blank 
    tfopwg_disposition character varying(2), --/D TESS Follow-up Observing Program (TFOP) Working Group Disposition Options: APC = Ambiguous Planet Candidate, CP = Confirmed Planet, FA = False Alarm, FP = False Positive, KP = Known Planet, PC = Planet Candidate or blank 
    ctoi character varying(32), --/D Community Tareget of Interest ID 
    user_disposition character varying(2), --/D Initial Community User Disposition 
    num_sectors real, --/D The total number of sectors that this object was observed on as of the catalog date 
    pk bigint NOT NULL --/D Primary Key 
);



--
-- Name: dr19_tess_toi_v05; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_tess_toi_v05 (
----------------------------------------------------------------------
--/H This catalog contains targets that recieved the 2 minute cadence during the TESS Mission, are TESS Objects of Interest (TOI) or Community TESS Objects of Interest (CTOI). The contents of this catalog were derived from the MIT TESS website (https://tess.mit.edu/public/target_lists/target_lists.html) and the ExoFOP website https://exofop.ipac.caltech.edu/tess/index.php. These targets were updated on 2020-11-24.
----------------------------------------------------------------------
    ticid bigint, --/D TESS Input Catalog (TIC) ID 
    target_type character(8), --/D Type of target. Options: 2min = 2 minute cadence, exo_TOI = TOI, and exo_CTOI = CTOI 
    toi character(32), --/D TESS Object of Interest ID 
    tess_disposition character(4), --/D TESS Team Dispositon Options: EB = Eclipsing Binary, KP = Known Planet, PC = Planet Candidate, O = Other, or blank 
    tfopwg_disposition character(3), --/D TESS Follow-up Observing Program (TFOP) Working Group Disposition Options: APC = Ambiguous Planet Candidate, CP = Confirmed Planet, FA = False Alarm, FP = False Positive, KP = Known Planet, PC = Planet Candidate or blank 
    ctoi character(32), --/D Community Tareget of Interest ID 
    user_disposition character(2), --/D Initial Community User Disposition 
    num_sectors double precision, --/D The total number of sectors that this object was observed on as of the catalog date 
    pkey bigint NOT NULL --/D Primary Key 
);



--
-- Name: dr19_tic_v8; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_tic_v8 (
----------------------------------------------------------------------
--/H The Eighth version (v8.0) of the TESS Input Catalogue (<a href="https://outerspace.stsci.edu/display/TESS/TIC+v8+and+CTL+v8.xx+Data+Release+Notes"></a>). This catalogue is used in v0.5 target selection as a form of internal cross-match between the objects found in difference input catalogues.
----------------------------------------------------------------------
    id bigint NOT NULL, --/D TESS Input Catalog identifier 
    version character varying(8), --/D Version Identifier for this entry (yyyymmdd) 
    hip integer, --/D Hipparcos Identifier 
    tyc character varying(12), --/D Tycho2 Identifier 
    ucac character varying(10), --/D UCAC4 Identifier 
    twomass character varying(20), --/D 2MASS Identifier 
    sdss bigint, --/D SDSS DR9 Identifier 
    allwise character varying(20), --/D AllWISE Identifier 
    gaia character varying(20), --/D Gaia DR2 Identifier (source_id, string representation) 
    apass character varying(30), --/D APASS Identifier 
    kic integer, --/D KIC Identifier 
    objtype character varying(16), --/D Object Type 
    typesrc character varying(16), --/D Source of the object 
    ra double precision, --/U degrees --/D Right Ascension epoch 2000 
    "dec" double precision, --/U degrees --/D Declination epoch 2000 
    posflag character varying(12), --/D Source of the position 
    pmra real, --/U mas/yr --/D Proper Motion in Right Ascension 
    e_pmra real, --/U mas/yr --/D Uncertainty in PM Right Ascension 
    pmdec real, --/U mas/yr --/D Proper Motion in Declination 
    e_pmdec real, --/U mas/yr --/D Uncertainty in PM Declination 
    pmflag character varying(12), --/D Source of the Proper Motion 
    plx real, --/U mas --/D Parallax 
    e_plx real, --/U mas --/D Error in the parallax 
    parflag character varying(12), --/D Source of the parallax 
    gallong double precision, --/U degrees --/D Galactic Longitude  
    gallat double precision, --/U degrees --/D Galactic Latitude 
    eclong double precision, --/U degrees --/D Ecliptic Longitude 
    eclat double precision, --/U degrees --/D Ecliptic Latitude 
    bmag real, --/U mag --/D Johnson B 
    e_bmag real, --/U mag --/D Uncertainty in Johnson B 
    vmag real, --/U mag --/D Johnson V 
    e_vmag real, --/U mag --/D Uncertainty in Johnson V 
    umag real, --/U mag --/D Sloan u 
    e_umag real, --/U mag --/D Uncertainty in Sloan u 
    gmag real, --/U mag --/D Sloan g 
    e_gmag real, --/U mag --/D Uncertainty in Sloan g 
    rmag real, --/U mag --/D Sloan r 
    e_rmag real, --/U mag --/D Uncertainty in Sloan r 
    imag real, --/U mag --/D Sloan i 
    e_imag real, --/U mag --/D Uncertainty in Sloan i 
    zmag real, --/U mag --/D Sloan z 
    e_zmag real, --/U mag --/D Uncertainty in Sloan z 
    jmag real, --/U mag --/D 2MASS J 
    e_jmag real, --/U mag --/D Uncertainty in 2MASS J 
    hmag real, --/U mag --/D 2MASS H 
    e_hmag real, --/U mag --/D Uncertainty in 2MASS H 
    kmag real, --/U mag --/D 2MASS K 
    e_kmag real, --/U mag --/D Uncertainty in 2MASS K 
    twomflag character varying(20), --/D Quality Flags for 2MASS 
    prox real, --/U arcsec --/D Distance to 2MASS nearest neighbor 
    w1mag real, --/U mag --/D WISE W1 
    e_w1mag real, --/U mag --/D Uncertainty in WISE W1 
    w2mag real, --/U mag --/D WISE W2 
    e_w2mag real, --/U mag --/D Uncertainty in WISE W2 
    w3mag real, --/U mag --/D WISE W3 
    e_w3mag real, --/U mag --/D Uncertainty in WISE W3 
    w4mag real, --/U mag --/D WISE W4 
    e_w4mag real, --/U mag --/D Uncertainty in WISE W4 
    gaiamag real, --/U mag --/D Gaia G Mag 
    e_gaiamag real, --/U mag --/D Uncertainty in Gaia G 
    tmag real, --/U mag --/D TESS Magnitude 
    e_tmag real, --/U mag --/D Uncertainty in TESS Magnitude 
    tessflag character varying(20), --/D TESS Magnitude Flag 
    spflag character varying(20), --/D Stellar Properties Flag 
    teff real, --/U K --/D Effective Temperature 
    e_teff real, --/U K --/D Uncertainty in Effective Temperature 
    logg real, --/U log(cgs) --/D log of the Surface Gravity 
    e_logg real, --/U log(cgs) --/D Uncertainty in Surface Gravity 
    mh real, --/U dex --/D Metallicity 
    e_mh real, --/U dex --/D Uncertainty in the Metallicity 
    rad real, --/U solar --/D Radius 
    e_rad real, --/U solar --/D Uncertainty in the Radius 
    mass real, --/U solar --/D Mass  
    e_mass real, --/U solar --/D Uncertainty in the Mass 
    rho real, --/U solar --/D Stellar Density 
    e_rho real, --/U solar --/D Uncertainty in the Stellar Density 
    lumclass character varying(10), --/D Luminosity Class 
    lum real, --/U solar --/D Stellar Luminosity 
    e_lum real, --/U solar --/D Uncertainty in Luminosity 
    d real, --/U pc --/D Distance 
    e_d real, --/U pc --/D Uncertainty in the distance 
    ebv real, --/U mag --/D Applied Color Excess 
    e_ebv real, --/U mag --/D Uncertainty in Applied Color Excess 
    numcont integer, --/D Number of Contamination Sources 
    contratio real, --/D Contamination Ratio 
    disposition character varying(10), --/D Disposition type 
    duplicate_id bigint, --/D Points to the duplicate object TIC ID 
    priority real, --/D CTL priority 
    eneg_ebv real, --/U mag --/D Negative error for EBV 
    epos_ebv real, --/U mag --/D Positive error for EBV 
    ebvflag character varying(20), --/D Source of EBV 
    eneg_mass real, --/U solar --/D Negative error for Mass  
    epos_mass real, --/U solar --/D Positive error for Mass  
    eneg_rad real, --/U solar --/D Negative error for Radius  
    epos_rad real, --/U solar --/D Positive error for Radius  
    eneg_rho real, --/U solar --/D Negative error for Density  
    epos_rho real, --/U solar --/D Positive error for Density  
    eneg_logg real, --/U log(cgs) --/D Negative error for Surface Gravity 
    epos_logg real, --/U log(cgs) --/D Positive error for Surface Gravity  
    eneg_lum real, --/U solar --/D Negative error for Luminosity   
    epos_lum real, --/U solar --/D Positive error for Luminosity  
    eneg_dist real, --/U pc --/D Negative Error for Distance  
    epos_dist real, --/U pc --/D Positive Error for Distance 
    distflag character varying(20), --/D Source of distance 
    eneg_teff real, --/U K --/D Negative error for effective temperature 
    epos_teff real, --/U K --/D Positive error for effective temperature 
    tefflag character varying(20), --/D Source of effective Temperature 
    gaiabp real, --/U mag --/D Gaia BP magnitude 
    e_gaiabp real, --/U mag --/D Error in Gaia BP magnitude  
    gaiarp real, --/U mag --/D Gaia RP magnitude  
    e_gaiarp real, --/U mag --/D Error in Gaia RP magnitude 
    gaiaqflag integer, --/D Quality of Gaia information 
    starchareflag character varying(20), --/D Error of asymmetric errors 
    vmagflag character varying(20), --/D Source of V magnitude 
    bmagflag character varying(20), --/D Source of B magnitude 
    splits character varying(20), --/D Identifies if star is in a specially curated list. (original TIC column is named splists). 
    e_ra double precision, --/U mas --/D Error in RA  
    e_dec double precision, --/U mas --/D Error in Dec 
    ra_orig double precision, --/U degrees --/D RA from original catalog 
    dec_orig double precision, --/U degrees --/D Dec from original catalog 
    e_ra_orig double precision, --/U mas --/D RA error as given in original catalog 
    e_dec_orig double precision, --/U mas --/D Dec error as given in original catalog 
    raddflag integer, --/D 1=dwarf by radius, 0=giant by radius 
    wdflag integer, --/D 1=star in Gaia's photometric "White Dwarf region" 
    objid bigint, --/D Object identifier (integer) 
    gaia_int bigint, --/D Gaia DR2 source ID (integer). Not originally in TIC v8.
    twomass_psc text, --/D 2MASS PSC identifier. Not originally in TIC v8.
    twomass_psc_pts_key integer, --/D 2MASS PSC identifier. Not originally in TIC v8.
    tycho2_tycid integer, --/D Tycho2 identifier (integer). Not originally in TIC v8.
    allwise_cntr bigint --/D ALLWISE ID (integer). Not originally in TIC v8.
);



--
-- Name: dr19_twomass_psc; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_twomass_psc (
----------------------------------------------------------------------
--/H 2MASS point source catalog. For full details, please see https://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html
----------------------------------------------------------------------
    ra double precision, --/U degrees --/D Right ascenscion 
    decl double precision, --/U degrees --/D Declination 
    err_maj real, --/U arcsec --/D Semi-major axis of position error ellipse 
    err_min real, --/U arcsec --/D Semi-minor axis of position error ellipse 
    err_ang smallint, --/U degrees --/D Position angle of error ellipse major axis (E of N) 
    j_m real, --/U mag --/D 2MASS J-band default magnitude 
    j_cmsig real, --/U mag --/D J-band default magnitude uncertainty 
    j_msigcom real, --/U mag --/D J-band total magnitude uncertainty 
    j_snr real, --/D J-band signal-to-noise ratio 
    h_m real, --/U mag --/D 2MASS H-band default magnitude 
    h_cmsig real, --/U mag --/D H-band default magnitude uncertainty 
    h_msigcom real, --/U mag --/D H-band total magnitude uncertainty 
    h_snr real, --/D H-band signal-to-noise ratio 
    k_m real, --/U mag --/D 2MASS K-band default magnitude 
    k_cmsig real, --/U mag --/D K-band default magnitude uncertainty 
    k_msigcom real, --/U mag --/D K-band total magnitude uncertainty 
    k_snr real, --/D K-band signal-to-noise ratio 
    ph_qual character(3), --/D JHK photometric quality flag {}
    rd_flg character(3), --/D Source of JHK default mag 
    bl_flg character(3), --/D JHK components fit to source 
    cc_flg character(3), --/D Artifact contamination, confusion flag 
    ndet character(6), --/D Number of aperture measurements (jjhhkk) 
    prox real, --/U arcsec --/D Distance between source and nearest neighbor 
    pxpa smallint, --/U degrees --/D Position ange of vector from source to nearest neighbor (E of N) 
    pxcntr integer, --/D Sequence number of nearest neighbor 
    gal_contam smallint, --/D Extended source contamination flag 
    mp_flg smallint, --/D Association with asteroid or comet flag 
    pts_key integer NOT NULL, --/D A unique identification number for the PSC source 
    hemis character(1), --/D Hemisphere code for the 2MASS Observatory from which this source was observed 
    date date, --/U yyyy-mm-dd --/D The observation reference date for this source expressed in ISO standard format. 
    scan smallint, --/D The nightly scan number in which the source was detected 
    glon real, --/U degrees --/D Galactic longitude 
    glat real, --/U degrees --/D Galactic latitude 
    x_scan real, --/U arcsec --/D Mean cross-scan focal plane position of the source in the Universal scan (U-scan) coordinate system 
    jdate double precision, --/U days --/D The Julian Date of the source measurement accurate to 30 seconds 
    j_psfchi real, --/D Reduced chi-squared goodness-of-fit value for the J-band profile-fit photometry 
    h_psfchi real, --/D Reduced chi-squared goodness-of-fit value for the H-band profile-fit photometry 
    k_psfchi real, --/D Reduced chi-squared goodness-of-fit value for the K-band profile-fit photometry 
    j_m_stdap real, --/U mag --/D J-band "standard" aperture magnitude 
    j_msig_stdap real, --/U mag --/D Uncertainty in the J-band standard aperture magnitude 
    h_m_stdap real, --/U mag --/D H-band "standard" aperture magnitude 
    h_msig_stdap real, --/U mag --/D Uncertainty in the H-band standard aperture magnitude 
    k_m_stdap real, --/U mag --/D K-band "standard" aperture magnitude 
    k_msig_stdap real, --/U mag --/D Uncertainty in the K-band standard aperture magnitude 
    dist_edge_ns integer, --/U arcsec --/D Distance from the source to the nearest North or South scan edge 
    dist_edge_ew integer, --/U arcsec --/D Distance from the source to the nearest East or West scan edge 
    dist_edge_flg character(2), --/D Flag that specifies to which scan edges a source lies closest and to which edges the dist_edge_ns and dist_edge_ew values refer 
    dup_src smallint, --/D Duplicate source flag 
    use_src smallint, --/D Use source flag 
    a character(1), --/D Catalog identifier of an optical source from either the Tycho 2 or USNO-A2.0 catalog that falls within approximately 5 arcsec of the 2MASS source position 
    dist_opt real, --/U arcsec --/D Distance separating 2MASS source position and associated optical source 
    phi_opt smallint, --/U degrees --/D Position angle on the sky of the vector from the the associated optical source to the 2MASS source position (East of North) 
    b_m_opt real, --/U mag --/D Blue magnitude of associated optical source 
    vr_m_opt real, --/U mag --/D Visual or red magnitude of the associated optical source 
    nopt_mchs smallint, --/D The number of USNO-A2.0 or Tycho 2 optical sources found within a radius of approximately 5 arcsec of the 2MASS position 
    ext_key integer, --/D Unique identification number of the record in the XSC that corresponds to this point source 
    scan_key integer, --/D Unique identification number of the record in the Scan Information Table 
    coadd_key integer, --/D Unique identification number of the record in the Atlas Image Information Table 
    coadd smallint, --/D Sequence number of the Atlas Image in which the position of this source falls 
    designation text --/D Sexagesimal, equatorial position-based source 
);



--
-- Name: dr19_tycho2; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_tycho2 (
----------------------------------------------------------------------
--/H Tycho-2 catalog. For complete details, please see the original Tycho-2 documentation from Hog et al (2020) https://ui.adsabs.harvard.edu/abs/2000A%26A...355L..27H/abstract and https://www.cosmos.esa.int/web/hipparcos/tycho-2
----------------------------------------------------------------------
    tyc1 integer, --/D TYC1 from TYC or GSC (used to construct the Tycho identifier) 
    tyc2 integer, --/D TYC2 from TYC or GSC (used to construct the Tycho identifier) 
    tyc3 integer, --/D TYC3 from TYC (used to construct the Tycho identifier) 
    pflag character varying(1), --/D Mean position flag 
    ramdeg double precision, --/U degrees --/D Mean Right Asc, ICRS, epoch=J2000 
    demdeg double precision, --/U degrees --/D Mean Decl, ICRS, at epoch=J2000 
    pmra double precision, --/U mas/yr --/D Proper motion in RA*cos(dec) 
    pmde double precision, --/U mas/yr --/D Proper motion in Dec 
    e_ramdeg integer, --/U mas --/D standard error of RA*cos(dec) at mean epoch 
    e_demdeg integer, --/U mas --/D standard error of Declination at mean epoch 
    e_pmra double precision, --/U mas/yr --/D standard error of proper motion in RA*cos(dec) 
    e_pmde double precision, --/U mas/yr --/D standard error of proper motion in Declination 
    epram double precision, --/U yr --/D mean epoch of RA 
    epdem double precision, --/U yr --/D mean epoch of Dec 
    num integer, --/D Number of positions used 
    q_ramdeg double precision, --/D Goodness of fit for mean RA 
    q_demdeg double precision, --/D Goodness of fit for mean Dec 
    q_pmra double precision, --/D Goodness of fit for pmra 
    q_pmde double precision, --/D Goodness of fit for pmde 
    btmag real, --/U mag --/D Tycho-2 BT magnitude 
    e_btmag real, --/U mag --/D Standard error of BT magnitude 
    vtmag real, --/U mag --/D Tycho-2 VT magnitude 
    e_vtmag real, --/U mag --/D Standard error of VT magnitude 
    prox integer, --/U 0.1 arcsec --/D Distance to the nearest entry in the Tycho-2 main catalogue or supplement 
    tyc character varying(1), --/D Tycho-1 star flag 
    hip bigint, --/D Hipparcos number 
    ccdm character varying(3), --/D CCDM component identifiers for double or multiple Hipparcos stars contributing to this Tycho-2 entry 
    radeg double precision, --/U degrees --/D Observed Tycho-2 Right Ascension, ICRS 
    dedeg double precision, --/U degrees --/D Observed Tycho-2 Declination, ICRS 
    epra_1990 double precision, --/U yr --/D epoch-1990 of RAdeg 
    epde_1990 double precision, --/U yr --/D epoch-1990 of Dedeg 
    e_radeg double precision, --/U mas --/D Standard error of RA*cos(dec), of observed Tycho-2 RA 
    e_dedeg double precision, --/U mas --/D Standard error of observed Tycho-2 Dec 
    posflg character varying(1), --/D Type of Tycho-2 solution 
    corr real, --/D correlation (RAdeg,DEdeg) 
    flag character varying(1), --/D flag indicating whether data from Hipparcos or Tycho-1 
    mflag character varying(1), --/D magnitude flag 
    designation text NOT NULL, --/D Unique Tycho designation 
    tycid integer, --/D Tycho ID 
    designation2 text
);



--
-- Name: dr19_unwise; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_unwise (
----------------------------------------------------------------------
--/H The unWISE catalog, containing the positions and fluxes of approximately two billion objects observed by the Wide-field Infrared Survey Explorer (WISE). See Schlafly et al. (2019). The original catalogs are hosted at https://catalog.unwise.me/catalogs.html
----------------------------------------------------------------------
    x_w1 double precision, --/U pixels --/D x coordinate from the W1 measurement of the source 
    x_w2 double precision, --/U pixels --/D x coordinate from the W2 measurement of the source 
    y_w1 double precision, --/U pixels --/D y coordinate from the W1 measurement of the source 
    y_w2 double precision, --/U pixels --/D y coordinate from the W2 measurement of the source 
    flux_w1 real, --/U Vega nMgy --/D flux from the W1 measurement of the source 
    flux_w2 real, --/U Vega nMgy --/D flux from the W2 measurement of the source 
    dx_w1 real, --/U pixels --/D uncertainty in x from the W1 measurement of the source 
    dx_w2 real, --/U pixels --/D uncertainty in x from the W2 measurement of the source 
    dy_w1 real, --/U pixels --/D uncertainty in y from the W1 measurement of the source 
    dy_w2 real, --/U pixels --/D uncertainty in y from the W2 measurement of the source 
    dflux_w1 real, --/U Vega nMgy --/D uncertainty in flux (statistical only) from the W1 measurement 
    dflux_w2 real, --/U Vega nMgy --/D uncertainty in flux (statistical only) from the W2 measurement 
    qf_w1 real, --/D "quality factor" for the W1 measurement 
    qf_w2 real, --/D "quality factor" for the W2 measurement 
    rchi2_w1 real, --/D average chi2 per pixel, weighted by PSF from the W1 measurement of the source 
    rchi2_w2 real, --/D average chi2 per pixel, weighted by PSF from the W2 measurement of the source 
    fracflux_w1 real, --/D fraction of flux in this object's PSF that comes from this object from the W1 measurement of the source 
    fracflux_w2 real, --/D fraction of flux in this object's PSF that comes from this object from the W2 measurement of the source 
    fluxlbs_w1 real, --/U Vega nMgy --/D local-background-subtracted flux from the W1 measurement of the source 
    fluxlbs_w2 real, --/U Vega nMgy --/D local-background-subtracted flux from the W2 measurement of the source 
    dfluxlbs_w1 real, --/U Vega nMgy --/D uncertainty in local-background-subtracted flux from the W1 measurement of the source 
    dfluxlbs_w2 real, --/U Vega nMgy --/D uncertainty in local-background-subtracted flux from the W2 measurement of the source 
    fwhm_w1 real, --/U pixels --/D full-width at half-maximum of PSF from the W1 measurement of the source 
    fwhm_w2 real, --/U pixels --/D full-width at half-maximum of PSF from the W2 measurement of the source 
    spread_model_w1 real, --/D SExtractor spread_model parameter from the W1 measurement of the source 
    spread_model_w2 real, --/D SExtractor spread_model parameter from the W2 measurement of the source 
    dspread_model_w1 real, --/D uncertainty in spread_model from the W1 measurement of the source 
    dspread_model_w2 real, --/D uncertainty in spread_model from the W2 measurement of the source 
    sky_w1 real, --/U Vega nMgy --/D sky flux from the W1 measurement of the source 
    sky_w2 real, --/U Vega nMgy --/D sky flux from the W2 measurement of the source 
    ra12_w1 double precision, --/D RA position from individual-image catalogs from the W1 measurement of the source 
    ra12_w2 double precision, --/U degrees --/D RA position from individual-image catalogs from the W2 measurement of the source 
    dec12_w1 double precision, --/U degrees --/D Dec position from individual-image catalogs from the W1 measurement of the source 
    dec12_w2 double precision, --/U degrees --/D Dec position from individual-image catalogs from the W2 measurement of the source 
    coadd_id text, --/D unique identifier for the coadd 
    unwise_detid_w1 text, --/D unWISE detection ID from the W1 measurement of the source 
    unwise_detid_w2 text, --/D unWISE detection ID from the W2 measurement of the source 
    nm_w1 integer, --/D number of single-exposure images of this part of sky in coadd for the W1 band 
    nm_w2 integer, --/D number of single-exposure images of this part of sky in coadd for the W2 band 
    primary12_w1 integer, --/D 'primary' status from individual-image catalogs from the W1 measurement of the source 
    primary12_w2 integer, --/D 'primary' status from individual-image catalogs from the W2 measurement of the source 
    flags_unwise_w1 integer, --/D unWISE Coadd Flags flags at central pixel for the W1 measurement of the source 
    flags_unwise_w2 integer, --/D unWISE Coadd Flags flags at central pixel for the W2 measurement of the source 
    flags_info_w1 integer, --/D additional informational flags at central pixel for the W1 measurement of the source 
    flags_info_w2 integer, --/D additional informational flags at central pixel for the W2 measurement of the source 
    ra double precision, --/D RA W1 position, if available; otherwise W2 position 
    "dec" double precision, --/D Declination W1 position, if available; otherwise W2 position 
    primary_status integer, --/D W1 primary status, if available; otherwise W2 primary status 
    unwise_objid text NOT NULL --/D unique object id 
);



--
-- Name: dr19_uvotssc1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_uvotssc1 (
----------------------------------------------------------------------
--/H Version 1.1 of the Swift UVOT Serendipitous Source Catalogue (UVOTSSC). For full details, please see Page et al. (2015) at https://pos.sissa.it/233/037 and the online documentation at https://archive.stsci.edu/prepds/uvotssc/
----------------------------------------------------------------------
    name character varying(17), --/D UVOTSSC1 name (JHHMMSS.s+DDMMSSa) 
    oseq bigint, --/D Reference number in the observation table 
    obsid bigint, --/D Unique Swift observation ID 
    nf bigint, --/D Number of filters included in this observation 
    srcid bigint, --/D Unique source number 
    radeg double precision, --/U degrees --/D Right ascension 
    dedeg double precision, --/U degrees --/D Declination 
    e_radeg double precision, --/U arcsec --/D Right ascension error 
    e_dedeg double precision, --/U arcsec --/D Declination error 
    ruvw2 real, --/U arcsec --/D Distance to closest UVW2 source 
    ruvm2 real, --/U arcsec --/D Distance to closest UVM2 source 
    ruvw1 real, --/U arcsec --/D Distance to closest UVW1 source 
    ru real, --/U arcsec --/D Distance to closest U source 
    rb real, --/U arcsec --/D Distance to closest B source 
    rv real, --/U arcsec --/D Distance to closest V source 
    nd bigint, --/D Number of individual observations 
    suvw2 real, --/D Significance (S/N) in UVW2 
    suvm2 real, --/D Significance (S/N) in UVM2 
    suvw1 real, --/D Significance (S/N) in UVW1 
    su real, --/D Significance (S/N) in U 
    sb real, --/D Significance (S/N) in B 
    sv real, --/D Significance (S/N) in V 
    uvw2 double precision, --/U mag --/D UVOT/UVW2 Vega magnitude 
    uvm2 double precision, --/U mag --/D UVOT/UVM2 Vega magnitude 
    uvw1 double precision, --/U mag --/D UVOT/UVW1 Vega magnitude 
    umag double precision, --/U mag --/D UVOT/U Vega magnitude 
    bmag double precision, --/U mag --/D UVOT/B Vega magnitude 
    vmag double precision, --/U mag --/D UVOT/V Vega magnitude 
    uvw2_ab double precision, --/U mag --/D UVOT/UVW2 AB magnitude 
    uvm2_ab double precision, --/U mag --/D UVOT/UVM2 AB magnitude 
    uvw1_ab double precision, --/U mag --/D UVOT/UVW1 AB magnitude 
    u_ab double precision, --/U mag --/D UVOT/U AB magnitude 
    b_ab double precision, --/U mag --/D UVOT/B AB magnitude 
    v_ab double precision, --/U mag --/D UVOT/V AB magnitude 
    e_uvw2 double precision, --/U mag --/D Error on UVW2 magnitude 
    e_uvm2 double precision, --/U mag --/D Error on UVM2 magnitude 
    e_uvw1 double precision, --/U mag --/D Error on UVW1 magnitude 
    e_umag double precision, --/U mag --/D Error on U magnitude 
    e_bmag double precision, --/U mag --/D Error on B magnitude 
    e_vmag double precision, --/U mag --/D Error on V magnitude 
    f_uvw2 double precision, --/U cW/m2/nm --/D UVOT/UVW2 Flux 
    f_uvm2 double precision, --/U cW/m2/nm --/D UVOT/UVM2 Flux 
    f_uvw1 double precision, --/U cW/m2/nm --/D UVOT/UVW1 Flux 
    f_u double precision, --/U cW/m2/nm --/D UVOT/U Flux 
    f_b double precision, --/U cW/m2/nm --/D UVOT/B Flux 
    f_v double precision, --/U cW/m2/nm --/D UVOT/V Flux 
    e_f_uvw2 double precision, --/U cW/m2/nm --/D Error on F.UVW2 
    e_f_uvm2 double precision, --/U cW/m2/nm --/D Error on F.UVM2 
    e_f_uvw1 double precision, --/U cW/m2/nm --/D Error on F.UVW1 
    e_f_u double precision, --/U cW/m2/nm --/D Error on F.U 
    e_f_b double precision, --/U cW/m2/nm --/D Error on F.B 
    e_f_v double precision, --/U cW/m2/nm --/D Error on F.V 
    auvw2 double precision, --/U arcsec --/D Major axis in UVW2 
    auvm2 double precision, --/U arcsec --/D Major axis in UVM2 
    auvw1 double precision, --/U arcsec --/D Major axis in UVW1 
    au double precision, --/U arcsec --/D Major axis in U 
    ab double precision, --/U arcsec --/D Major axis in B 
    av double precision, --/U arcsec --/D Major axis in V 
    buvw2 double precision, --/U arcsec --/D Minor axis in UVW2 
    buvm2 double precision, --/U arcsec --/D Minor axis in UVM2 
    buvw1 double precision, --/U arcsec --/D Minor axis in UVW1 
    bu double precision, --/U arcsec --/D Minor axis in U 
    bb double precision, --/U arcsec --/D Minor axis in B 
    bv double precision, --/U arcsec --/D Minor axis in V 
    pauvw2 real, --/U degrees --/D Position angle of major axis in UVW2 
    pauvm2 real, --/U degrees --/D Position angle of major axis in UVM2 
    pauvw1 real, --/U degrees --/D Position angle of major axis in UVW1 
    pau real, --/U degrees --/D Position angle of major axis in U 
    pab real, --/U degrees --/D Position angle of major axis in B 
    pav real, --/U degrees --/D Position angle of major axis in V 
    xuvw2 integer, --/D Extended flag in UVW2 
    xuvm2 integer, --/D Extended flag in UVM2 
    xuvw1 integer, --/D Extended flag in UVW1 
    xu integer, --/D Extended flag in U 
    xb integer, --/D Extended flag in B 
    xv integer, --/D Extended flag in V 
    fuvw2 integer, --/D Quality flags in UVW2 
    fuvm2 integer, --/D Quality flags in UVM2 
    fuvw1 integer, --/D Quality flags in UVW1 
    fu integer, --/D Quality flags in U 
    fb integer, --/D Quality flags in B 
    fv integer, --/D Quality flags in V 
    id bigint NOT NULL --/D Internal identifier 
);



--
-- Name: dr19_xmm_om_suss_4_1; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_xmm_om_suss_4_1 (
----------------------------------------------------------------------
--/H The 2018 release of the XMM OM Serendipitous Ultraviolet Source Survey (XMM-SUSS4.1) Catalog. For full details, please see https://heasarc.gsfc.nasa.gov/W3Browse/all/xmmomsuob.html and the original catalog paper (Page et al. 2012; https://academic.oup.com/mnras/article/426/2/903/976665)
----------------------------------------------------------------------
    iauname character varying(22), --/D Coordinate-based name 
    n_summary integer, --/D Reference number index for the XMM-Newton pointing in which the particular detection was mad
    obsid character varying(10), --/D The exclusive 10-digit identification number of the XMM pointing with the detection 
    srcnum integer, --/D The unique reference number within each combined source list created by the pipeline 
    uvw2_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in UVW2 
    uvm2_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in UVM2 
    uvw1_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in UVW1 
    u_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in U 
    b_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in B 
    v_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in V 
    ra double precision, --/U degrees --/D Right ascension 
    "dec" double precision, --/U degrees --/D Declination 
    ra_hms character varying(13), --/U sexagesimal --/D Right ascension 
    dec_dms character varying(14), --/U sexagesimal --/D Declination 
    poserr real, --/U arcsec --/D Statistical error of the measured source position 
    lii double precision, --/U degrees --/D Galactic longitude 
    bii double precision, --/U degrees --/D Galactic latitude 
    n_obsid integer, --/D Number of times a source has been detected during separate observations 
    uvw2_signif real, --/D Significance of source detection in UVW2 
    uvm2_signif real, --/D Significance of source detection in UVM2 
    uvw1_signif real, --/D Significance of source detection in UVW1 
    u_signif real, --/D Significance of source detection in U 
    b_signif real, --/D Significance of source detection in B 
    v_signif real, --/D Significance of source detection in V 
    uvw2_rate real, --/U counts/s --/D Background-subtracted source count rate in UVW2 corrected for coincidence loss 
    uvw2_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in UVW2 
    uvm2_rate real, --/U counts/s --/D Background-subtracted source count rate in UVM2 corrected for coincidence loss 
    uvm2_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in UVM2 
    uvw1_rate real, --/U counts/s --/D Background-subtracted source count rate in UVW1 corrected for coincidence loss 
    uvw1_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in UVW1 
    u_rate real, --/U counts/s --/D Background-subtracted source count rate in U corrected for coincidence loss 
    u_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in U 
    b_rate real, --/U counts/s --/D Background-subtracted source count rate in B corrected for coincidence loss 
    b_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in B 
    v_rate real, --/U counts/s --/D Background-subtracted source count rate in V corrected for coincidence loss 
    v_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in V 
    uvw2_ab_flux real, --/U erg/s/cm^2/A --/D UVW2 AB flux 
    uvw2_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in UVW2 AB flux 
    uvm2_ab_flux real, --/U erg/s/cm^2/A --/D UVM2 AB flux 
    uvm2_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in UVM2 AB flux 
    uvw1_ab_flux real, --/U erg/s/cm^2/A --/D UVW1 AB flux 
    uvw1_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in UVW1 AB flux 
    u_ab_flux real, --/U erg/s/cm^2/A --/D U AB flux 
    u_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in U AB flux 
    b_ab_flux real, --/U erg/s/cm^2/A --/D B AB flux 
    b_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in B AB flux 
    v_ab_flux real, --/U erg/s/cm^2/A --/D V AB flux 
    v_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in V AB flux 
    uvw2_ab_mag real, --/U mag --/D UVW2 AB magnitude 
    uvw2_ab_mag_err real, --/U mag --/D Error in UVW2 AB magnitude 
    uvm2_ab_mag real, --/U mag --/D UVM2 AB magnitude 
    uvm2_ab_mag_err real, --/U mag --/D Error in UVM2 AB magnitude 
    uvw1_ab_mag real, --/U mag --/D UVW1 AB magnitude 
    uvw1_ab_mag_err real, --/U mag --/D Error in UVW1 AB magnitude 
    u_ab_mag real, --/U mag --/D U AB magnitude 
    u_ab_mag_err real, --/U mag --/D Error in U AB magnitude 
    b_ab_mag real, --/U mag --/D B AB magnitude 
    b_ab_mag_err real, --/U mag --/D Error in B AB magnitude 
    v_ab_mag real, --/U mag --/D V AB magnitude 
    v_ab_mag_err real, --/U mag --/D Error in V AB magnitude 
    uvw2_vega_mag real, --/U mag --/D UVW2 Vega magnitude 
    uvw2_vega_mag_err real, --/U mag --/D Error in UVW2 Vega magnitude 
    uvm2_vega_mag real, --/U mag --/D UVM2 Vega magnitude 
    uvm2_vega_mag_err real, --/U mag --/D Error in UVM2 Vega magnitude 
    uvw1_vega_mag real, --/U mag --/D UVW1 Vega magnitude 
    uvw1_vega_mag_err real, --/U mag --/D Error in UVW1 Vega magnitude 
    u_vega_mag real, --/U mag --/D U Vega magnitude 
    u_vega_mag_err real, --/U mag --/D Error in U Vega magnitude 
    b_vega_mag real, --/U mag --/D B Vega magnitude 
    b_vega_mag_err real, --/U mag --/D Error in B Vega magnitude 
    v_vega_mag real, --/U mag --/D V Vega magnitude 
    v_vega_mag_err real, --/U mag --/D Error in V Vega magnitude 
    uvw2_major_axis real, --/U arcsec --/D Length of major axis in UVW2 
    uvm2_major_axis real, --/U arcsec --/D Length of major axis in UVM2 
    uvw1_major_axis real, --/U arcsec --/D Length of major axis in UVW1 
    u_major_axis real, --/U arcsec --/D Length of major axis in U 
    b_major_axis real, --/U arcsec --/D Length of major axis in B 
    v_major_axis real, --/U arcsec --/D Length of major axis in V 
    uvw2_minor_axis real, --/U arcsec --/D Length of minor axis in UVW2 
    uvm2_minor_axis real, --/U arcsec --/D Length of minor axis in UVM2 
    uvw1_minor_axis real, --/U arcsec --/D Length of minor axis in UVW1 
    u_minor_axis real, --/U arcsec --/D Length of minor axis in U 
    b_minor_axis real, --/U arcsec --/D Length of minor axis in B 
    v_minor_axis real, --/U arcsec --/D Length of minor axis in V 
    uvw2_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in UVW2 
    uvm2_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in UVM2 
    uvw1_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in UVW1 
    u_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in U 
    b_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in B 
    v_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in V 
    uvw2_quality_flag smallint, --/D UVW2 quality flag 
    uvm2_quality_flag smallint, --/D UVM2 quality flag 
    uvw1_quality_flag smallint, --/D UVW1 quality flag 
    u_quality_flag smallint, --/D U quality flag 
    b_quality_flag smallint, --/D B quality flag 
    v_quality_flag smallint, --/D V quality flag 
    uvw2_quality_flag_st character varying(12), --/D Alternative UVW2 quality flag 
    uvm2_quality_flag_st character varying(12), --/D Alternative UVM2 quality flag 
    uvw1_quality_flag_st character varying(12), --/D Alternative UVW1 quality flag 
    u_quality_flag_st character varying(12), --/D Alternative U quality flag 
    b_quality_flag_st character varying(12), --/D Alternative B quality flag 
    v_quality_flag_st character varying(12), --/D Alternative V quality flag 
    uvw2_extended_flag bigint, --/D Spatially extended flag in UVW2 
    uvm2_extended_flag bigint, --/D Spatially extended flag in UVM2 
    uvw1_extended_flag bigint, --/D Spatially extended flag in UVW1 
    u_extended_flag bigint, --/D Spatially extended flag in U 
    b_extended_flag bigint, --/D Spatially extended flag in B 
    v_extended_flag bigint, --/D Spatially extended flag in V 
    uvw2_sky_image character varying(4), --/D Flag for stakcked sky images in UVW2 
    uvm2_sky_image character varying(4), --/D Flag for stakcked sky images in UVM2 
    uvw1_sky_image character varying(4), --/D Flag for stakcked sky images in UVW1 
    u_sky_image character varying(4), --/D Flag for stakcked sky images in U 
    b_sky_image character varying(4), --/D Flag for stakcked sky images in B 
    v_sky_image character varying(4), --/D Flag for stakcked sky images in V 
    pk bigint NOT NULL --/D Primary key 
);



--
-- Name: dr19_yso_clustering; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_yso_clustering (
----------------------------------------------------------------------
--/H YSO candidates from Kounkel et al. 2020. Please see details in the original paper: https://iopscience.iop.org/article/10.3847/1538-3881/abc0e6
----------------------------------------------------------------------
    source_id bigint NOT NULL, --/D Gaia DR2 source id 
    twomass text, --/D 2MASS ID 
    ra double precision, --/U degrees --/D Right ascention in J2000 reference frame 
    "dec" double precision, --/U degrees --/D Declination in J2000 reference frame 
    parallax real, --/U mas --/D Parallax from Gaia DR2 
    id integer, --/D Identification of a parent group from Kounkel et al. (2020) 
    g double precision, --/U mag --/D Gaia (DR2) G band magnitude 
    bp double precision, --/U mag --/D Gaia (DR2) BP band magnitude 
    rp double precision, --/U mag --/D Gaia (DR2) RP band magnitude 
    j real, --/U mag --/D 2MASS J band magnitude 
    h real, --/U mag --/D 2MASS H band magnitude 
    k real, --/U mag --/D 2MASS K band magnitude 
    age double precision, --/U log yr --/D Estimate of the age of the parent group from Kounkel et al. (2020) 
    eage double precision, --/U log yr --/D Uncertainty in age 
    av double precision, --/U mag --/D Estimate of extinction of the parent group from Kounkel et al. (2020) 
    eav double precision, --/U mag --/D Uncertainty in av 
    dist double precision, --/U pc --/D Estimate of distance of the parent group from Kounkel et al. (2020) 
    edist double precision --/U pc --/D Uncertainty in dist 
);



--
-- Name: dr19_zari18pms; Type: TABLE; Schema: dbo. Owner: postgres
--

CREATE TABLE dbo.dr19_zari18pms (
----------------------------------------------------------------------
--/H Pre-main sequence (PMS) catalogue from Zari+2018.
----------------------------------------------------------------------
    source bigint NOT NULL, --/D Unique source identifier (Gaia DR2 source_id) 
    glon double precision, --/U deg --/D Galactic longitude 
    glat double precision, --/U deg --/D Galactic latitude 
    plx real, --/U mas --/D Parallax 
    e_plx real, --/U mas --/D Standard error of parallax (parallax_error) 
    pmglon real, --/U mas/yr --/D Proper motion in galactic longitude 
    e_pmglon real, --/U mas/yr --/D Standard error of proper motion in galactic longitude 
    pmglat real, --/U mas/yr --/D Proper motion in galactic latitude 
    e_pmglat real, --/U mas/yr --/D Standard error of proper motion in galactic latitude 
    pmlbcorr real, --/D Correlation between proper motion in galactic longitude and proper motion in galactic latitude 
    rv real, --/U km/s --/D radial velocity 
    e_rv real, --/U km/s --/D radial velocity error 
    gmag real, --/U mag --/D G-band mean magnitude (phot_g_mean_mag) 
    bpmag real, --/U mag --/D BP-band mean magnitude (phot_bp_mean_mag) 
    rpmag real, --/U mag --/D RP-band mean magnitude (phot_g_mean_mag) 
    bp_over_rp real, --/D BP/RP excess factor 
    chi2al real, --/D AL chi-square value (astrometric_chi2_al) 
    ngal integer, --/D Number of good observation AL (astrometric_n_good_obs_al) 
    ag real, --/U mag --/D Extinction in G-band (A_G) 
    bp_rp real, --/U mag --/D Colour excess in BP-RP 
    uwe real --/D Unit Weight Error, as defined in Lindegren et al., 2018A&A...616A...2L 
);



