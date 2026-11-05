create table eROSITA_CVs (
    ------- 
    --/H Cataclysmic variables identified from screening of SDSS-V spectra based from eROSITA X-ray sources 
    --/T Cataclysmic variable binaries confirmed by screening and visual inspection 
    --/T of SDSS-V spectra of eROSITA eRASS1 and eRASS:3 X-ray sources, with optical 
    --/T data from Gaia DR3 and X-ray data from eRASS:3 
    ------- 
    iauname varchar(23) NOT NULL, --/U  --/D IAU ID 
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID 
    detuid varchar(32) NOT NULL, --/U  --/D eRASS:3 ID 
    gaia_dr3_id bigint NOT NULL, --/U  --/D Gaia DR3 ID 
    ra_ero float NOT NULL, --/U deg --/D Right ascension in eRASS:3 
    dec_ero float NOT NULL, --/U deg --/D Declination in eRASS:3 
    ra_gaia_dr3 float NOT NULL, --/U deg --/D Right ascension in Gaia DR3 
    dec_gaia_dr3 float NOT NULL, --/U deg --/D Declination in Gaia DR3 
    ra_icrs float NOT NULL, --/U deg --/D Right ascension in ICRS 
    de_icrs float NOT NULL, --/U deg --/D Declination in ICRS 
    ero_flux real NOT NULL, --/U erg s**(-1) cm**(-2) --/D eRASS:3 flux in 0.2 - 2.3 keV band 
    ero_flux_err real NOT NULL, --/U erg s**(-1) cm**(-2) --/D eRASS:3 flux error in 0.2 - 2.3 keV band 
    gmag float NOT NULL, --/U mag --/D Gaia DR3 G-band magnitude 
    gmag_err float NOT NULL, --/U mag --/D Gaia DR3 error in G-band magnitude 
    bp-rp float NOT NULL, --/U mag --/D Gaia DR3 BP - RP magnitude 
    bp-rp_err float NOT NULL, --/U mag --/D Gaia DR3 error in BP - RP magnitude 
    distance float NOT NULL, --/U pc --/D Gaia DR3 rgeo nominal distance based on Bailer-Jones et al. (2021) 
    distance_lower float NOT NULL, --/U pc --/D Gaia DR3 rgeo lower distance based on Bailer-Jones et al. (2021) 
    distance_upper float NOT NULL, --/U pc --/D Gaia DR3 rgeo upper distance based on Bailer-Jones et al. (2021) 
    gabs float NOT NULL, --/U mag --/D Absolute magnitude based on Gmag and DISTANCE 
    log(lx) float NOT NULL, --/U erg s**(-1) --/D log(Lx) 
    log(fx/fopt) float NOT NULL, --/U  --/D logarithm of X-ray to flux ratio given by: log(Fx/Fopt) = log10(eRO_FLUX) + (Gmag/2.5) + 4.86 
    hr_p12 real NOT NULL, --/U  --/D Hardness ratio between the eRASS:3 0.2–0.5 keV and 0.5–1.0 keV bands 
    hr_p12_err real NOT NULL, --/U  --/D Hardness ratio error between the eRASS:3 0.2–0.5 keV and 0.5–1.0 keV bands 
    hr_p23 real NOT NULL, --/U  --/D Hardness ratio between the eRASS:3 0.5–1.0 keV and 1.0–2.0 keV bands 
    hr_p23_err real NOT NULL, --/U  --/D Hardness ratio error between the eRASS:3 0.5–1.0 keV and 1.0–2.0 keV bands 
    period float NOT NULL, --/U hours --/D Orbital period of system 
    cv_type varchar(8) NOT NULL, --/U  --/D Main CV type of system 
    cv_subtype varchar(11) NOT NULL, --/U  --/D Subtype of CV or alternative (less likely) main CV type 
    references varchar(31) NOT NULL --/U  --/D References used to obtain orbital period and/or CV type and subtype 
);
