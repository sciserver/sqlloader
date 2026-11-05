create table yso_ob_kin (
    ------- 
    --/H Catalogue of ~45,000 OB stars used to study the Milky Way disc kinematics. 
    --/T This is a catalogue of ~45,000 OB stars accompanying the paper "The 
    --/T large-scale kinematics of young stars in the Milky Way disc: first results 
    --/T from SDSS-V (<a 
    --/T href="https://ui.adsabs.harvard.edu/abs/2025A%26A...703A.303Z/abstract">Zari 
    --/T et al., 2025</a>). The catalogue is described in detail in Section 2.2. of 
    --/T <a 
    --/T href="https://ui.adsabs.harvard.edu/abs/2025A%26A...703A.303Z/abstract">Zari 
    --/T et al., 2025</a>. It contains Galactocentric cartesian coordinates and 
    --/T radial velocities and age estimates of the sample used in the paper. 
    ------- 
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 Unique Source Identifier  
    ra float NOT NULL, --/U deg --/D right ascension  
    dec float NOT NULL, --/U deg --/D declination  
    distance float NOT NULL, --/U kpc --/D 50th percentile of photogeometric distance (<a href="https://ui.adsabs.harvard.edu/abs/2021AJ....161..147B/abstract">Bailer-Jones et al., 2021</a>)  
    pm_ra_cosdec float NOT NULL, --/U mas yr-1 --/D Proper motion in RA  
    pm_dec float NOT NULL, --/U mas yr-1 --/D Proper motion in Dec  
    radial_velocity float NOT NULL, --/U km s-1 --/D Radial velocity (computed as described in Sec. 2.3 of <a href="https://ui.adsabs.harvard.edu/abs/2025A%26A...703A.303Z/abstract">Zari et al., 2025</a>)  
    e_distance float NOT NULL, --/U kpc --/D Error on photogeometric distance  
    e_pmra float NOT NULL, --/U mas yr-1 --/D Error on proper motion in RA  
    e_pmdec float NOT NULL, --/U mas yr-1 --/D Error on proper motion in Dec  
    e_rv float NOT NULL, --/U km s-1 --/D Error on radial velocity  
    xg float NOT NULL, --/U kpc --/D Galactocentric cartesian x position component  
    yg float NOT NULL, --/U kpc --/D Galactocentric cartesian y position component  
    zg float NOT NULL, --/U kpc --/D Galactocentric cartesian z position component  
    r float NOT NULL, --/U kpc --/D Galactocentric distance  
    vr float NOT NULL, --/U km s-1 --/D Galactocentric radial velocity  
    e_vr float NOT NULL, --/U km s-1 --/D Error on Galactocentric radial velocity  
    teff float NOT NULL, --/U K --/D BossNet Effective temperature  
    e_teff float NOT NULL, --/U K --/D Error on BossNet effective temperature  
    logg float NOT NULL, --/U dex --/D BossNet surface gravity  
    e_logg float NOT NULL, --/U dex --/D Error on BossNet surface gravity  
    feh float NOT NULL, --/U dex --/D BossNet iron abundance  
    e_feh float NOT NULL, --/U dex --/D Error on BossNet iron abundance  
    median_log_age real NOT NULL, --/U log(yr) --/D 50th percentile of log-age (computed as described in Sec. 3.2 of <a href="https://ui.adsabs.harvard.edu/abs/2025A%26A...703A.303Z/abstract">Zari et al., 2025</a>)  
    lo_median_age real NOT NULL, --/U log(yr) --/D 16th percentile of log-age  
    hi_median_age real NOT NULL, --/U log(yr) --/D 84th percentile of log-age  
);
