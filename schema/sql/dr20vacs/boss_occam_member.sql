create table boss_occam_member (
    ------- 
    --/H The BOSS OCCAM member summary table provides positional, identification, and membership information for candidate open cluster member stars. 
    --/T The BOSS OCCAM member summary table provides the proper motion membership 
    --/T probabilities from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    --/T alongside the radial velocity and [Fe/H] membership 
    --/T probabilities from BOSS/CLAM. Basic positional information is included with 
    --/T source IDs from Gaia DR3 and SDSS for each star in the table. 
    ------- 
    cluster varchar(20) NOT NULL, --/U  --/D Open cluster name 
    sdss_id bigint NOT NULL, --/U  --/D Internal SDSS source ID 
    gaiadr3_id bigint NOT NULL, --/U  --/D Gaia DR3 source ID 
    glon real NOT NULL, --/U deg --/D Galactic longitude 
    glat real NOT NULL, --/U deg --/D Galactic latitude 
    radeg float NOT NULL, --/U deg --/D Right ascension in degrees 
    dedeg float NOT NULL, --/U deg --/D Declination in degrees 
    v_rad real NOT NULL, --/U km/s --/D Radial velocity from pyXCSAO (<a href="https://ui.adsabs.harvard.edu/abs/2022yCat..51640137K">Kounkel 2022</a>) 
    e_v_rad real NOT NULL, --/U km/s --/D Standard error in radial velocity measurements 
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA 
    e_pmra real NOT NULL, --/U mas/yr --/D Standard error of proper motion in RA 
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in declination 
    e_pmde real NOT NULL, --/U mas/yr --/D Standard error of proper motion in declination 
    feh_clam float NOT NULL, --/U dex --/D [Fe/H] from the CLAM pipeline 
    e_feh_clam float NOT NULL, --/U dex --/D 1-sigma [Fe/H] dispersion from the CLAM pipeline 
    alpha_m_clam float NOT NULL, --/U dex --/D [Fe/H] from the CLAM pipeline 
    e_alpha_m_clam float NOT NULL, --/U dex --/D 1-sigma [alpha/M] dispersion from the CLAM pipeline 
    eh_prob float NOT NULL, --/U  --/D Membership probability from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    rv_prob float NOT NULL, --/U  --/D OCCAM RV membership probability 
    feh_prob_clam float NOT NULL, --/U  --/D OCCAM CLAM [Fe/H] membership probability 
    teff float NOT NULL, --/U K --/D Effective temperature 
    logg float NOT NULL, --/U dex --/D Surface gravity log(g) 
);
