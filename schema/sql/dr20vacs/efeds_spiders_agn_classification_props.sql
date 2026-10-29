create table efeds_spiders_agn_classification_props (
    ------- 
    --/H eFEDS SPIDERS AGN classification, emission line detection flags, and derived physical properties.
    --/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
    --/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
    --/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
    --/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
    --/T Also provided are the X-ray and public photometric data.
    ------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source Name (Brunner+2022) 
    ero_id_hard int NOT NULL, --/U  --/D ID of Hard sample eROSITA source (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of Main sample eROSITA source (Brunner+2022) 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ra float NOT NULL, --/U deg --/D SDSS right ascension (J2000) 
    dec float NOT NULL, --/U deg --/D SDSS declination (J2000) 
    hg_subtraction bit NOT NULL, --/U  --/D True: host-galaxy emission subtracted; False: quasar-dominated 
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from visual inspection (Aydar+2025) 
    sn_median_all float NOT NULL, --/U  --/D SDSS Median S/N per pix in spectrum (idlspec2d v6_0_2 reductions) 
    class_line varchar(10) NOT NULL, --/U  --/D Classification onto Broad, Narrow or No (emission) lines 
    f_agn float NOT NULL, --/U  --/D AGN continuum (PL+Fe II+Balmer) weight to continuum fit 
    type varchar(15) NOT NULL, --/U  --/D Types 1-2; c for candidates; SF from BPT or WHAN 
    subtype varchar(15) NOT NULL, --/U  --/D Narrow Line Seyfert 1; for Type 1.9, if Mg II or Ha are broad 
    xray_obscuration varchar(20) NOT NULL, --/U  --/D Obscuration according to nH=21.5; c for candidates 
    oiii_outflow varchar(5) NOT NULL, --/U  --/D Candidates of having an outflow in [O III], red- or blueshifted 
    coronal_line bit NOT NULL, --/U  --/D Candidates of having a coronal line ([Ne V], [Fe VII], or [Fe X]) 
    a_ox float NOT NULL, --/U  --/D Ratio between UV and X-ray luminosities, Tananbaum+1979 
    a_ox_error float NOT NULL, --/U  --/D Ratio between UV and X-ray luminosities error, Tananbaum+1979 
    logbhmass float NOT NULL, --/U  --/D Black hole mass (log, Msun): Hb or Ha z<0.7; Mg II 0.7<z<2; C IV z>2 
    logbhmass_error float NOT NULL, --/U  --/D Black hole mass error (log, Msun): line as LogBHmass 
    loglbol float NOT NULL, --/U  --/D Bolometric luminosity (log, erg/s): 5100 z<0.7; 3000 0.7<z<2; 1350 z 
    loglbol_error float NOT NULL, --/U  --/D Bolometric luminosity error (log, erg/s): luminosities as LogLbol 
    logedd_ratio float NOT NULL, --/U  --/D Eddington ratio: Hb,Ha,5100 z<0.7; MgII,3000 0.7<z<2; CIV,1350 z>2 
    logedd_ratio_error float NOT NULL, --/U  --/D Eddington ratio error: lines and luminosities as LogEdd_ratio 
    logl2500 float NOT NULL, --/U  --/D Continuum luminosity at 2500 A (log, erg/s) 
    logl2500_error float NOT NULL, --/U  --/D Uncertainty of the continuum luminosity at 2500 A (log, erg/s) 
    balmdec float NOT NULL, --/U  --/D Balmer decrement from the total lines (Ha/Hb) 
    balmdec_error float NOT NULL, --/U  --/D Balmer decrement from the total lines error 
    balmdec_na float NOT NULL, --/U  --/D Balmer decrement from the narrow lines (Ha_na/Hb_na) 
    balmdec_na_error float NOT NULL, --/U  --/D Balmer decrement from the narrow lines error 
    balmdec_br float NOT NULL, --/U  --/D Balmer decrement from the broad lines (Ha_br/Hb_br) 
    balmdec_br_error float NOT NULL, --/U  --/D Balmer decrement from the broad lines error 
    t_e_oiii float NOT NULL, --/U K --/D Electron temperature from [O III], Dors+2020 
    t_e_oii float NOT NULL, --/U K --/D Electron temperature from [O II], Dors+2020 
    n_e_sii float NOT NULL, --/U cm-3 --/D Electron density from [S II], Dors+2020 
    metallicity_oh_direct float NOT NULL, --/U  --/D 12+log(O/H) from the direct method, Dors+2020 
    metallicity_zsun_n2 float NOT NULL, --/U Zsun --/D Z in solar metallicity from [N II]/Ha, Carvalho+2020 
    ionization_u float NOT NULL, --/U  --/D Ionization parameter, Morisset+2016 
    aperture_physical_size_kpc float NOT NULL, --/U kpc --/D Physical size within the fiber 
    logbhmass_ha float NOT NULL, --/U  --/D Black hole mass estimated from Ha, Shen+2011 (log, Msun) 
    logbhmass_ha_error float NOT NULL, --/U  --/D Black hole mass error estimated from Ha, Shen+2011 (log, Msun) 
    logbhmass_hb float NOT NULL, --/U  --/D Black hole mass estimated from Hb, Shen+2011 (log, Msun) 
    logbhmass_hb_error float NOT NULL, --/U  --/D Black hole mass error estimated from Hb, Shen+2011 (log, Msun) 
    logbhmass_mg float NOT NULL, --/U  --/D Black hole mass estimated from Mg II, Shen+2011 (log, Msun) 
    logbhmass_mg_error float NOT NULL, --/U  --/D Black hole mass error estimated from Mg II, Shen+2011 (log, Msun) 
    logbhmass_civ float NOT NULL, --/U  --/D Black hole mass estimated from C IV, Shen+2011 (log, Msun) 
    logbhmass_civ_error float NOT NULL, --/U  --/D Black hole mass error estimated from C IV, Shen+2011 (log, Msun) 
    loglbol_5100 float NOT NULL, --/U  --/D Bolometric luminosity estimated from 5100A, Runnoe+2012 (log, erg/s) 
    loglbol_5100_error float NOT NULL, --/U  --/D Bolometric luminosity error from 5100A, Runnoe+2012 (log, erg/s) 
    loglbol_3000 float NOT NULL, --/U  --/D Bolometric luminosity estimated from 3000A, Runnoe+2012 (log, erg/s) 
    loglbol_3000_error float NOT NULL, --/U  --/D Bolometric luminosity error from 3000A, Runnoe+2012 (log, erg/s) 
    loglbol_1350 float NOT NULL, --/U  --/D Bolometric luminosity estimated from 1350A, Runnoe+2012 (log, erg/s) 
    loglbol_1350_error float NOT NULL, --/U  --/D Bolometric luminosity error from 1350A, Runnoe+2012 (log, erg/s) 
    lbol_x float NOT NULL, --/U  --/D Bolometric luminosity estimated from Lx, Duras+2020 (log, erg/s) 
    lbol_x_error float NOT NULL, --/U  --/D Bolometric luminosity error from Lx, Duras+2020 (log, erg/s) 
    logedd_ratio_ha float NOT NULL, --/U  --/D Eddington ratio estimated from Ha and Lbol_5100 
    logedd_ratio_ha_error float NOT NULL, --/U  --/D Eddington ratio error estimated from Ha and Lbol_5100 
    logedd_ratio_hb float NOT NULL, --/U  --/D Eddington ratio estimated from Hb and Lbol_5100 
    logedd_ratio_hb_error float NOT NULL, --/U  --/D Eddington ratio error estimated from Hb and Lbol_5100 
    logedd_ratio_mg float NOT NULL, --/U  --/D Eddington ratio estimated from Mg II and Lbol_3000 
    logedd_ratio_mg_error float NOT NULL, --/U  --/D Eddington ratio error estimated from Mg II and Lbol_3000 
    logedd_ratio_civ float NOT NULL, --/U  --/D Eddington ratio estimated from C IV and Lbol_1350 
    logedd_ratio_civ_error float NOT NULL, --/U  --/D Eddington ratio error estimated from C IV and Lbol_1350 
    sii6732_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    sii6718_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    nii6585_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    nii6549_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    halpha_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    halpha_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    halpha_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    halpha_na_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    fex6376_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oi6300_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    fevii6088_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hei5877_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hei5877_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    hei5877_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hei5877_na_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    heii4685_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    heii4685_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    heii4685_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    heii4685_na_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii5007_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii5007_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    oiii5007c_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii5007w_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii4959_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii4959_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    oiii4959c_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii4959w_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hbeta_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hbeta_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    hbeta_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hbeta_na_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii4363_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hgamma_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hgamma_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    hgamma_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hgamma_na_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hdelta_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hdelta_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    hdelta_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    hdelta_na_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    neiii3967_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    neiii3869_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    fevii3759_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oii3728_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    nev3426_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    nev3426_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    nev3426_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    nev3426_na_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    nev3346_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    mgii_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    mgii_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    mgii_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    mgii_na_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    neiv2422_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    cii2326_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    ciii_all_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    ciii_all_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    ciii_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    siiii1892_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    aliii1857_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    siii1816_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    niii1750_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    niv1718_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii1663_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiii1663_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    heii1640_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    heii1640_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    heii1640_br_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    civ_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    civ_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    siiv_oiv_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    cii1335_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oi1304_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    lya_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    lya_broad bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the broad component 
    nv1240_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
    oiv1035_detected bit NOT NULL, --/U  --/D Flag for considering a reliable detection of the line 
);
