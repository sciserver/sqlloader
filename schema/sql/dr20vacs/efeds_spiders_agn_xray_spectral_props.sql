create table efeds_spiders_agn_xray_spectral_props (
    ------- 
    --/H eFEDS SPIDERS AGN X-ray spectral properties from Liu et al. (2022) 
    --/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
    --/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
    --/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
    --/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
    --/T Also provided are the X-ray and public photometric data.
    ------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source Name (Brunner+2022) 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of Main sample eROSITA source (Brunner+2022) 
    ero_id_hard int NOT NULL, --/U  --/D ID of Hard sample eROSITA source (Brunner+2022) 
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from visual inspection (Aydar+2025) 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension (J2000) 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination (J2000) 
    mjd bigint NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    redshift real NOT NULL, --/U  --/D Redshift of the optical counterpart (Paper II) 
    new_class int NOT NULL, --/U  --/D Updated classification of the optical counterpart 
    new_quality int NOT NULL, --/U  --/D Updated counterpart quality 
    ra_corr float NOT NULL, --/U deg --/D eROSITA right ascension (J2000), astrometric corrected (Paper I) 
    dec_corr float NOT NULL, --/U deg --/D eROSITA declination (J2000), astrometric corrected (Paper I) 
    det_like real NOT NULL, --/U  --/D 0.2-2.3 keV source detection likelihood (Paper I) 
    inarea90 bit NOT NULL, --/U  --/D Whether located inside the inner 90%-area region of eFEDS (Paper I) 
    edr_quality smallint NOT NULL, --/U  --/D Counterpart quality (Paper II). A value >=2 is recommended. 
    edr_class smallint NOT NULL, --/U  --/D Classification of the optical counterpart (Paper II). 0:likely Galac 
    edr_redshift real NOT NULL, --/U  --/D Redshift of the optical counterpart (Paper II) 
    lxmodel int NOT NULL, --/U  --/D Index of selected model for luminosity measurement. 1:single-powerla 
    nhclass int NOT NULL, --/U  --/D Class of AGN NH measurement with model 1 (single-powerlaw). 1: uninf 
    fsmodel int NOT NULL, --/U  --/D Index of selected model for 0.5-2keV flux. 5: counts-based measureme 
    fhmodel int NOT NULL, --/U  --/D Index of selected model for 2.3-5keV flux. 5: counts-based measureme 
    galnh float NOT NULL, --/U cm-2 --/D Total column density of Galactic absorption 
    galnhi float NOT NULL, --/U cm-2 --/D HI column density from HI4PI 
    srccts float NOT NULL, --/U count --/D Source net counts in the 0.2-5 keV band 
    fluxcorr_med_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 0.5-2 keV, posterior median 
    fluxcorr_lo1_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 0.5-2 keV, 1sigma lower limit 
    fluxcorr_up1_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 0.5-2 keV, 1sigma upper limit 
    fluxcorr_med_t real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 2.3-5 keV, posterior median 
    fluxcorr_lo1_t real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 2.3-5 keV, 1sigma lower limit 
    fluxcorr_up1_t real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 2.3-5 keV, 1sigma upper limit 
    fluxintr_med_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in rest-frame 0.5-2 keV, posterior median 
    fluxintr_lo1_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in rest-frame 0.5-2keV, 1sigma lower limit 
    fluxintr_up1_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in rest-frame 0.5-2keV, 1sigma upper limit 
    fluxintr_med_2kev real NOT NULL, --/U erg / (cm2 eV s) --/D Absorption corrected flux at rest-frame 2keV, median 
    fluxintr_lo1_2kev real NOT NULL, --/U erg / (cm2 eV s) --/D Absorption corrected flux at rest-frame 2keV, 1sigma lower limit 
    fluxintr_up1_2kev real NOT NULL, --/U erg / (cm2 eV s) --/D Absorption corrected flux at rest-frame 2keV, 1sigma upper limit 
    lumiintr_med_s real NOT NULL, --/U erg / s --/D Intrinsic luminosity in rest-frame 0.5-2 keV, posterior median 
    lumiintr_lo1_s real NOT NULL, --/U erg / s --/D Intrinsic luminosity in rest-frame 0.5-2 keV, 1sigma lower limit 
    lumiintr_up1_s real NOT NULL, --/U erg / s --/D Intrinsic luminosity in rest-frame 0.5-2 keV, 1sigma upper limit 
    lumiintr_med_2kev real NOT NULL, --/U erg / (eV s) --/D Intrinsic luminosity at rest-frame 2keV, posterior median 
    lumiintr_lo1_2kev real NOT NULL, --/U erg / (eV s) --/D Intrinsic luminosity at rest-frame 2keV, 1sigma lower limit 
    lumiintr_up1_2kev real NOT NULL, --/U erg / (eV s) --/D Intrinsic luminosity at rest-frame 2keV, 1sigma upper limit 
    fluxobsv_med_s real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 0.5-2 keV, posterior median 
    fluxobsv_lo1_s real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 0.5-2 keV, 1sigma lower limit 
    fluxobsv_up1_s real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 0.5-2 keV, 1sigma upper limit 
    fluxobsv_med_t real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 2.3-5 keV, posterior median 
    fluxobsv_lo1_t real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 2.3-5 keV, 1sigma lower limit 
    fluxobsv_up1_t real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 2.3-5 keV, 1sigma upper limit 
    lognh_kl_m1 real NOT NULL, --/U nats --/D log AGN column density, KL divergence 
    lognh_hlo_m1 real NOT NULL, --/U cm-2 --/D log AGN column density, HDI lower limit 
    lognh_hup_m1 real NOT NULL, --/U cm-2 --/D log AGN column density, HDI upper limit 
    lognh_med_m1 real NOT NULL, --/U cm-2 --/D log AGN column density, posterior median 
    gamma_kl_m3 real NOT NULL, --/U nats --/D primary power-law slope in model 3, KL divergence 
    gamma_hlo_m3 real NOT NULL, --/U  --/D primary power-law slope in model 3, HDI lower limit 
    gamma_hup_m3 real NOT NULL, --/U  --/D primary power-law slope in model 3, HDI upper limit 
    gamma_med_m3 real NOT NULL, --/U  --/D primary power-law slope in model 3, posterior median 
    logz_m0 real NOT NULL, --/U  --/D log Bayesian evidence with model 0: APEC 
    logz_m1 real NOT NULL, --/U  --/D log Bayesian evidence with model 1: single powerlaw 
    logz_m2 real NOT NULL, --/U  --/D log Bayesian evidence with model 2: double powerlaw 
    logz_m3 real NOT NULL, --/U  --/D log Bayesian evidence with model 3: powerlaw + blackbody 
    logz_m4 real NOT NULL, --/U  --/D log Bayesian evidence with model 4: powerlaw with Gamma fixed at 2.0 
    logz_m5 real NOT NULL, --/U  --/D log Bayesian evidence with model 5: shape-fixed powerlaw 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
);
