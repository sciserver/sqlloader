create table mdwarf_contin_summary (
    ------- 
    --/H M dwarf pseudo-continuum used to standardize BOSS spectra 
    --/T M dwarf pseudo-continuum from <a href="https://ui.adsabs.harvard.edu/abs/2025AJ....170..302M/abstract">Medan, Way, et al. (2025)</a>,
    --/T which can be used to standardize BOSS spectra of Mdwarfs. 
    --/T When standardized, the issues in flux calibration in the optical 
    --/T spectra are removed such that M dwarfs of similar stellar parameters should 
    --/T not have comparable spectrum shapes and features. This VAC includes all 
    --/T meta-data from mwmAllVisit, flux and ivar from the mwmVisit files, and the 
    --/T computed pseudo-continuum for the subset of M dwarfs in DR20. 
    ------- 
    airmass real NOT NULL, --/U  --/D Mean airmass  
    airtemp real NOT NULL, --/U  --/D Air temperature   
    alt real NOT NULL, --/U  --/D Telescope altitude   
    apogee_max_mjd int NOT NULL, --/U  --/D Maximum MJD of APOGEE visits  
    apogee_min_mjd int NOT NULL, --/U  --/D Minimum MJD of APOGEE visits  
    az real NOT NULL, --/U  --/D Telescope azimuth   
    b real NOT NULL, --/U  --/D Galactic latitude   
    b_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic B-band (JKC)   
    b_jkc_mag_flag int NOT NULL, --/U  --/D B-band (JKC) is within valid range  
    bailer_jones_flags varchar(256) NOT NULL, --/U  --/D Bailer-Jones quality flags  
    bl_flg varchar(256) NOT NULL, --/U  --/D Number of components fit per band (JHK)  
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits  
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits  
    bp_mag real NOT NULL, --/U  --/D Gaia DR3 mean BP band magnitude   
    c_star real NOT NULL, --/U  --/D Quality parameter (see Riello et al. 2021)  
    cartid int NOT NULL, --/U  --/D Cartridge identifier  
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0)  
    catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5)  
    catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0)  
    cc_flg varchar(256) NOT NULL, --/U  --/D Contamination and confusion flag  
    created varchar(256) NOT NULL, --/U  --/D Date file created  
    crossmatch_flags bigint NOT NULL, --/U  --/D Crossmatch flags  
    csf bigint NOT NULL, --/U  --/D Close source flag  
    d4_5m real NOT NULL, --/U  --/D Error on IRAC band 4.5 micron magnitude   
    dec real NOT NULL, --/U  --/D Declination   
    dewpoint real NOT NULL, --/U  --/D Dew point temperature   
    dust_a real NOT NULL, --/U  --/D 0.3mu-sized dust count   
    dust_b real NOT NULL, --/U  --/D 1.0mu-sized dust count   
    e_ebv real NOT NULL, --/U  --/D Error on E(B-V)   
    e_ebv_bayestar_2019 real NOT NULL, --/U  --/D Error on Bayestar 2019 E(B-V)   
    e_ebv_edenhofer_2023 real NOT NULL, --/U  --/D Error on <a href=""https://ui.adsabs.harvard.edu/abs/2024A%26A...685A..82E/abstract">Edenhofer et al. (2023)</a> E(B-V)   
    e_ebv_rjce_allwise real NOT NULL, --/U  --/D Error on RJCE AllWISE E(B-V)  
    e_ebv_rjce_glimpse real NOT NULL, --/U  --/D Error on RJCE GLIMPSE E(B-V)   
    e_ebv_sfd real NOT NULL, --/U  --/D Error on E(B-V) from SFD   
    e_ebv_zhang_2023 real NOT NULL, --/U  --/D Error on E(B-V) from <a href="https://ui.adsabs.harvard.edu/abs/2023ApJ...953...35G/abstract">Zhang et al. (2023)</a>  
    e_h_mag real NOT NULL, --/U  --/D Error on 2MASS H band magnitude   
    e_j_mag real NOT NULL, --/U  --/D Error on 2MASS J band magnitude   
    e_k_mag real NOT NULL, --/U  --/D Error on 2MASS K band magnitude   
    e_plx real NOT NULL, --/U  --/D Error on parallax   
    e_pmde real NOT NULL, --/U  --/D Error on proper motion in DEC   
    e_pmra real NOT NULL, --/U  --/D Error on proper motion in RA   
    e_w1_mag real NOT NULL, --/U  --/D Error on W1 magnitude  
    e_w2_mag real NOT NULL, --/U  --/D Error on W2 magnitude  
    ebv real NOT NULL, --/U  --/D E(B-V)   
    ebv_bayestar_2019 real NOT NULL, --/U  --/D E(B-V) from Bayestar 2019   
    ebv_edenhofer_2023 real NOT NULL, --/U  --/D E(B-V) from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...685A..82E/abstract">Edenhofer et al. (2023)</a>  
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V)  
    ebv_rjce_allwise real NOT NULL, --/U  --/D E(B-V) from RJCE AllWISE   
    ebv_rjce_glimpse real NOT NULL, --/U  --/D E(B-V) from RJCE GLIMPSE   
    ebv_sfd real NOT NULL, --/U  --/D E(B-V) from SFD   
    ebv_zhang_2023 real NOT NULL, --/U  --/D E(B-V) from <a href="https://ui.adsabs.harvard.edu/abs/2023ApJ...953...35G/abstract">Zhang et al. (2023)</a>  
    exptime real NOT NULL, --/U  --/D Exposure time   
    f_night_time real NOT NULL, --/U  --/D Mid obs time as fraction from sunset to sunrise  
    fiber_offset bit NOT NULL, --/U  --/D Position offset applied during observations  
    fieldid int NOT NULL, --/U  --/D Field identifier  
    filetype varchar(256) NOT NULL, --/U  --/D SDSS file type that stores this spectrum  
    g_mag real NOT NULL, --/U  --/D Gaia DR3 mean G band magnitude   
    g_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic g-band (SDSS)   
    g_sdss_mag_flag int NOT NULL, --/U  --/D g-band (SDSS) is within valid range  
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier  
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    gaia_e_v_rad real NOT NULL, --/U  --/D Error on Gaia radial velocity   
    gaia_v_rad real NOT NULL, --/U  --/D Gaia radial velocity   
    gri_gaia_transform_flags bigint NOT NULL, --/U  --/D Flags for provenance of ugriz photometry  
    gust_direction real NOT NULL, --/U  --/D Wind gust direction   
    gust_speed real NOT NULL, --/U  --/D Wind gust speed   
    h_mag real NOT NULL, --/U  --/D 2MASS H band magnitude   
    healpix int NOT NULL, --/U  --/D HEALPix (128 side)  
    highrej int NOT NULL, --/U  --/D Extraction: high rejection  
    humidity real NOT NULL, --/U  --/D Humidity   
    i_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic I-band (JKC)   
    i_jkc_mag_flag int NOT NULL, --/U  --/D I-band (JKC) is within valid range  
    i_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic i-band (SDSS)   
    i_sdss_mag_flag int NOT NULL, --/U  --/D i-band (SDSS) is within valid range  
    j_mag real NOT NULL, --/U  --/D 2MASS J band magnitude   
    k_mag real NOT NULL, --/U  --/D 2MASS K band magnitude   
    l real NOT NULL, --/U  --/D Galactic longitude   
    lead varchar(256) NOT NULL, --/U  --/D Lead catalog used for cross-match  
    lowrej int NOT NULL, --/U  --/D Extraction: low rejection  
    mag4_5 real NOT NULL, --/U  --/D IRAC band 4.5 micron magnitude   
    mapid int NOT NULL, --/U  --/D Mapping version of the loaded plate  
    mf4_5 bigint NOT NULL, --/U  --/D Flux calculation method flag  
    mjd int NOT NULL, --/U  --/D Modified Julian date of observation  
    modified varchar(256) NOT NULL, --/U  --/D Date file modified  
    moon_dist_mean real NOT NULL, --/U  --/D Mean sky distance to the moon   
    moon_phase_mean real NOT NULL, --/U  --/D Mean phase of the moon  
    n_apogee_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID  
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    n_exp int NOT NULL, --/U  --/D Number of co-added exposures  
    n_gal int NOT NULL, --/U  --/D Number of (good) galaxies in field  
    n_guide int NOT NULL, --/U  --/D Number of guider frames during integration  
    n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5  
    n_std int NOT NULL, --/U  --/D Number of (good) standard stars  
    nfitpoly int NOT NULL, --/U  --/D Extraction: Number of profile parameters  
    ph_qual varchar(256) NOT NULL, --/U  --/D 2MASS photometric quality flag  
    plateid int NOT NULL, --/U  --/D Plate identifier  
    plx real NOT NULL, --/U  --/D Parallax   
    pmde real NOT NULL, --/U  --/D Proper motion in DEC   
    pmra real NOT NULL, --/U  --/D Proper motion in RA   
    preject real NOT NULL, --/U  --/D Profile area rejection threshold  
    pressure real NOT NULL, --/U  --/D Air pressure   
    proftype int NOT NULL, --/U  --/D Extraction profile: 1=Gaussian  
    psfsky int NOT NULL, --/U  --/D Order of PSF sky subtraction  
    r_hi_geo real NOT NULL, --/U  --/D 84th percentile of geometric distance   
    r_hi_photogeo real NOT NULL, --/U  --/D 84th percentile of photogeometric distance   
    r_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic R-band (JKC)   
    r_jkc_mag_flag int NOT NULL, --/U  --/D R-band (JKC) is within valid range  
    r_lo_geo real NOT NULL, --/U  --/D 16th percentile of geometric distance   
    r_lo_photogeo real NOT NULL, --/U  --/D 16th percentile of photogeometric distance   
    r_med_geo real NOT NULL, --/U  --/D Median geometric distance   
    r_med_photogeo real NOT NULL, --/U  --/D 50th percentile of photogeometric distance   
    r_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic r-band (SDSS)   
    r_sdss_mag_flag int NOT NULL, --/U  --/D r-band (SDSS) is within valid range  
    ra real NOT NULL, --/U  --/D Right ascension   
    release varchar(256) NOT NULL, --/U  --/D SDSS release  
    rms_f4_5 real NOT NULL, --/U  --/D RMS deviations from final flux   
    rp_mag real NOT NULL, --/U  --/D Gaia DR3 mean RP band magnitude   
    run2d varchar(256) NOT NULL, --/U  --/D BOSS data reduction pipeline version  
    scatpoly int NOT NULL, --/U  --/D Extraction: Order of scattered light polynomial  
    schi2max real NOT NULL, --/U  --/D Maximum \chi^2 of sky subtraction  
    schi2min real NOT NULL, --/U  --/D Minimum \chi^2 of sky subtraction  
    sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3)  
    sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3)  
    sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3)  
    sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG)  
    sdss4_apogee_id varchar(256) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier  
    sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags  
    sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2)  
    sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2)  
    sdss5_dr19_apogee_flag bit NOT NULL, --/U  --/D If target has an APOGEE spectrum in DR19  
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    seeing real NOT NULL, --/U  --/D Median seeing conditions   
    skychi2 real NOT NULL, --/U  --/D Mean \chi^2 of sky subtraction  
    slitid int NOT NULL, --/U  --/D Slit identifier  
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio  
    source bigint NOT NULL, --/U  --/D Unique source primary key  
    spec_file varchar(256) NOT NULL, --/U  --/D Name of the spectrum file  
    spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key  
    sqf_4_5 bigint NOT NULL, --/U  --/D Source quality flag for IRAC band 4.5 micron  
    tai_beg bigint NOT NULL, --/U  --/D MJD (TAI) at start of integrations   
    tai_end bigint NOT NULL, --/U  --/D MJD (TAI) at end of integrations   
    telescope varchar(256) NOT NULL, --/U  --/D Short telescope name  
    tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier  
    u_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic U-band (JKC)   
    u_jkc_mag_flag int NOT NULL, --/U  --/D U-band (JKC) is within valid range  
    u_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic u-band (SDSS)   
    u_sdss_mag_flag int NOT NULL, --/U  --/D u-band (SDSS) is within valid range  
    v_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic V-band (JKC)   
    v_jkc_mag_flag int NOT NULL, --/U  --/D V-band (JKC) is within valid range  
    version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting  
    w1_dflux real NOT NULL, --/U  --/D Error on W1 flux   
    w1_flux real NOT NULL, --/U  --/D W1 flux   
    w1_frac real NOT NULL, --/U  --/D Fraction of W1 flux from this object  
    w1_mag real NOT NULL, --/U  --/D W1 magnitude  
    w1aflags bigint NOT NULL, --/U  --/D Additional flags for W1  
    w1uflags bigint NOT NULL, --/U  --/D unWISE flags for W1  
    w2_dflux real NOT NULL, --/U  --/D Error on W2 flux   
    w2_flux real NOT NULL, --/U  --/D W2 flux   
    w2_frac real NOT NULL, --/U  --/D Fraction of W2 flux from this object  
    w2_mag real NOT NULL, --/U  --/D W2 magnitude   
    w2aflags bigint NOT NULL, --/U  --/D Additional flags for W2  
    w2uflags bigint NOT NULL, --/U  --/D unWISE flags for W2  
    wind_direction real NOT NULL, --/U  --/D Wind direction   
    wind_speed real NOT NULL, --/U  --/D Wind speed   
    xcsao_e_fe_h real NOT NULL, --/U  --/D Error on [Fe/H]   
    xcsao_e_logg real NOT NULL, --/U  --/D Error on surface gravity   
    xcsao_e_teff real NOT NULL, --/U  --/D Error on stellar effective temperature   
    xcsao_e_v_rad real NOT NULL, --/U  --/D Error on radial velocity   
    xcsao_fe_h real NOT NULL, --/U  --/D [Fe/H]   
    xcsao_logg real NOT NULL, --/U  --/D Surface gravity   
    xcsao_rxc real NOT NULL, --/U  --/D Cross-correlation R-value (1979AJ.....84.1511T)  
    xcsao_teff real NOT NULL, --/U  --/D Stellar effective temperature   
    xcsao_v_rad real NOT NULL, --/U  --/D Barycentric rest frame radial velocity   
    y_ps1_mag real NOT NULL, --/U  --/D Gaia XP synthetic Y-band (PS1)   
    y_ps1_mag_flag int NOT NULL, --/U  --/D Y-band (PS1) is within valid range  
    z_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic z-band (SDSS)   
    z_sdss_mag_flag int NOT NULL, --/U  --/D z-band (SDSS) is within valid range  
    zgr_chi2 real NOT NULL, --/U  --/D Chi-square value  
    zgr_e real NOT NULL, --/U  --/D Extinction   
    zgr_e_e real NOT NULL, --/U  --/D Error on extinction   
    zgr_e_fe_h real NOT NULL, --/U  --/D Error on [Fe/H]   
    zgr_e_logg real NOT NULL, --/U  --/D Error on surface gravity   
    zgr_e_plx real NOT NULL, --/U  --/D Error on parallax [mas] (Gaia DR3)  
    zgr_e_teff real NOT NULL, --/U  --/D Error on stellar effective temperature   
    zgr_fe_h real NOT NULL, --/U  --/D [Fe/H]   
    zgr_fe_h_confidence real NOT NULL, --/U  --/D Confidence estimate in FE_H  
    zgr_ln_prior real NOT NULL, --/U  --/D Log prior probability  
    zgr_logg real NOT NULL, --/U  --/D Surface gravity   
    zgr_logg_confidence real NOT NULL, --/U  --/D Confidence estimate in LOGG  
    zgr_plx real NOT NULL, --/U  --/D Parallax [mas] (Gaia DR3)  
    zgr_quality_flags bigint NOT NULL, --/U  --/D Quality flags  
    zgr_teff real NOT NULL, --/U  --/D Stellar effective temperature   
    zgr_teff_confidence real NOT NULL, --/U  --/D Confidence estimate in TEFF  
    zwarning_flags bigint NOT NULL, --/U  --/D BOSS DRP warning flags  
);
