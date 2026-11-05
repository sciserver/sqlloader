create table boss_ISM_NaI_absorption (
    ------- 
    --/H Catalog of Na I D interstellar absorption equivalent widths and V-band extinctions measured from SDSS-V DR20 BOSS spectra. 
    --/T This VAC provides measurements of the Na I D (5889.95/5895.92 Å) 
    --/T interstellar absorption doublet and V-band dust extinction (A_V, assuming 
    --/T R_V = 3.1) for 1,373,392 stellar sightlines observed with the BOSS 
    --/T spectrograph as part of the SDSS-V Milky Way Mapper program. Equivalent 
    --/T widths and extinctions are derived from spectral fits via ISM-cleaned 
    --/T MaStar spectra; uncertainties and fit quality (reduced chi^2) are reported 
    --/T for each source. See McQuaid et al. (2026) for full methodology. 
    ------- 
    sdssid bigint NOT NULL, --/U  --/D SDSS unique object identifier 
    ra float NOT NULL, --/U deg --/D ICRS right ascension 
    dec float NOT NULL, --/U deg --/D ICRS declination 
    reduced_chi2 float NOT NULL, --/U  --/D Reduced chi-squared of fit 
    a_v float NOT NULL, --/U mag --/D Fitted V-band extinction, R_V = 3.1 
    a_v_err float NOT NULL, --/U mag --/D Uncertainty in A_V 
    nai_d_ew float NOT NULL, --/U Angstrom --/D Equivalent width of Na I D absorption 
    nai_d_ew_err float NOT NULL, --/U Angstrom --/D Uncertainty in Na I D EW 
);
