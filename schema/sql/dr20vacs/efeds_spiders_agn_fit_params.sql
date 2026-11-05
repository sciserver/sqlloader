create table efeds_spiders_agn_fit_params (
    ------- 
    --/H eFEDS SPIDERS AGN continuum and emission line Gaussian fit parameters (PyQSOFit).
    --/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
    --/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
    --/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
    --/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
    --/T Also provided are the X-ray and public photometric data.
    ------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source name (Brunner+2022) 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of Main sample eROSITA source (Brunner+2022) 
    ero_id_hard int NOT NULL, --/U  --/D ID of Hard sample eROSITA source (Brunner+2022) 
    specz_redshift float NOT NULL, --/U  --/D Spectroscopic redshift from visual inspection (Aydar+2025) 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension (J2000) 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination (J2000) 
    mjd bigint NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    plate bigint NOT NULL, --/U  --/D SDSS PLATE 
    fiberid bigint NOT NULL, --/U  --/D SDSS FIBER ID 
    snr_conti float NOT NULL, --/U  --/D Signal-to-noise ratio of the continuum 
    ebv float NOT NULL, --/U  --/D Milky Way extinction E(B-V) 
    conti_chi2 float NOT NULL, --/U  --/D Continuum chi2 
    conti_rchi2 float NOT NULL, --/U  --/D Continuum reduced chi2 
    conti_dof float NOT NULL, --/U  --/D Continuum degrees of freedom 
    conti_npix float NOT NULL, --/U  --/D Continuum number of pixels 
    fe_uv_norm float NOT NULL, --/U  --/D Fe II UV normalization 
    fe_uv_norm_error float NOT NULL, --/U  --/D Fe II UV normalization error 
    fe_uv_fwhm float NOT NULL, --/U km/s --/D Fe II UV FWHM 
    fe_uv_fwhm_error float NOT NULL, --/U km/s --/D Fe II UV FWHM error 
    fe_uv_shift float NOT NULL, --/U A --/D Fe II UV shift (offset) 
    fe_uv_shift_error float NOT NULL, --/U A --/D Fe II UV shift (offset) error 
    fe_op_norm float NOT NULL, --/U  --/D Fe II optical normalization 
    fe_op_norm_error float NOT NULL, --/U  --/D Fe II optical normalization error 
    fe_op_fwhm float NOT NULL, --/U km/s --/D Fe II optical FWHM 
    fe_op_fwhm_error float NOT NULL, --/U km/s --/D Fe II optical FWHM error 
    fe_op_shift float NOT NULL, --/U A --/D Fe II optical shift (offset) 
    fe_op_shift_error float NOT NULL, --/U A --/D Fe II optical shift (offset) error 
    fe_uv_ew float NOT NULL, --/U A --/D Fe II UV equivalent width 
    fe_op_ew float NOT NULL, --/U A --/D Fe II optical equivalent width 
    fe_uv_ew_error float NOT NULL, --/U A --/D Fe II UV equivalent width error 
    fe_op_ew_error float NOT NULL, --/U A --/D Fe II optical equivalent width error 
    pl_norm float NOT NULL, --/U  --/D Power-law normalization 
    pl_norm_error float NOT NULL, --/U  --/D Power-law normalization error 
    pl_slope float NOT NULL, --/U  --/D Power-law slope 
    pl_slope_error float NOT NULL, --/U  --/D Power-law slope error 
    poly_a float NOT NULL, --/U  --/D Polynomial linear coefficient 
    poly_a_error float NOT NULL, --/U  --/D Polynomial linear coefficient error 
    poly_b float NOT NULL, --/U  --/D Polynomial quadratic coefficient 
    poly_b_error float NOT NULL, --/U  --/D Polynomial quadratic coefficient error 
    poly_c float NOT NULL, --/U  --/D Polynomial cubic coefficient 
    poly_c_error float NOT NULL, --/U  --/D Polynomial cubic coefficient error 
    logl1350 float NOT NULL, --/U  --/D Continuum luminosity at 1350 A (log, erg/s) 
    logl1350_error float NOT NULL, --/U  --/D Uncertainty of the continuum luminosity at 1350 A (log, erg/s) 
    logl1700 float NOT NULL, --/U  --/D Continuum luminosity at 1700 A (log, erg/s) 
    logl1700_error float NOT NULL, --/U  --/D Uncertainty of the continuum luminosity at 1700 A (log, erg/s) 
    logl3000 float NOT NULL, --/U  --/D Continuum luminosity at 3000 A (log, erg/s) 
    logl3000_error float NOT NULL, --/U  --/D Uncertainty of the continuum luminosity at 3000 A (log, erg/s) 
    logl5100 float NOT NULL, --/U  --/D Continuum luminosity at 5100 A (log, erg/s) 
    logl5100_error float NOT NULL, --/U  --/D Uncertainty of the continuum luminosity at 5100 A (log, erg/s) 
    first_complex_name varchar(8) NOT NULL, --/U  --/D First line complex name 
    first_line_status bigint NOT NULL, --/U  --/D First line complex fit status 
    first_line_min_chi2 float NOT NULL, --/U  --/D First line complex chi2 
    first_line_red_chi2 float NOT NULL, --/U  --/D First line complex reduced chi2 
    first_niter float NOT NULL, --/U  --/D First line complex number of iterations 
    first_npix float NOT NULL, --/U  --/D First line complex number of pixels 
    first_ndof float NOT NULL, --/U  --/D First line complex number of degrees of freedom 
    second_complex_name varchar(8) NOT NULL, --/U  --/D Second line complex name 
    second_line_status bigint NOT NULL, --/U  --/D Second line complex fit status 
    second_line_min_chi2 float NOT NULL, --/U  --/D Second line complex chi2 
    second_line_red_chi2 float NOT NULL, --/U  --/D Second line complex reduced chi2 
    second_niter float NOT NULL, --/U  --/D Second line complex number of iterations 
    second_npix float NOT NULL, --/U  --/D Second line complex number of pixels 
    second_ndof float NOT NULL, --/U  --/D Second line complex number of degrees of freedom 
    third_complex_name varchar(8) NOT NULL, --/U  --/D Third line complex name 
    third_line_status bigint NOT NULL, --/U  --/D Third line complex fit status 
    third_line_min_chi2 float NOT NULL, --/U  --/D Third line complex chi2 
    third_line_red_chi2 float NOT NULL, --/U  --/D Third line complex reduced chi2 
    third_niter float NOT NULL, --/U  --/D Third line complex number of iterations 
    third_npix float NOT NULL, --/U  --/D Third line complex number of pixels 
    third_ndof float NOT NULL, --/U  --/D Third line complex number of degrees of freedom 
    fourth_complex_name varchar(8) NOT NULL, --/U  --/D Fourth line complex name 
    fourth_line_status bigint NOT NULL, --/U  --/D Fourth line complex fit status 
    fourth_line_min_chi2 float NOT NULL, --/U  --/D Fourth line complex chi2 
    fourth_line_red_chi2 float NOT NULL, --/U  --/D Fourth line complex reduced chi2 
    fourth_niter float NOT NULL, --/U  --/D Fourth line complex number of iterations 
    fourth_npix float NOT NULL, --/U  --/D Fourth line complex number of pixels 
    fourth_ndof float NOT NULL, --/U  --/D Fourth line complex number of degrees of freedom 
    fifth_complex_name varchar(8) NOT NULL, --/U  --/D Fifth line complex name 
    fifth_line_status bigint NOT NULL, --/U  --/D Fifth line complex fit status 
    fifth_line_min_chi2 float NOT NULL, --/U  --/D Fifth line complex chi2 
    fifth_line_red_chi2 float NOT NULL, --/U  --/D Fifth line complex reduced chi2 
    fifth_niter float NOT NULL, --/U  --/D Fifth line complex number of iterations 
    fifth_npix float NOT NULL, --/U  --/D Fifth line complex number of pixels 
    fifth_ndof float NOT NULL, --/U  --/D Fifth line complex number of degrees of freedom 
    lya_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    lya_br_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    lya_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    lya_br_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    lya_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    lya_br_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    lya_br_2_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    lya_br_2_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    lya_br_2_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    lya_br_2_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    lya_br_2_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    lya_br_2_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    lya_br_3_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    lya_br_3_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    lya_br_3_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    lya_br_3_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    lya_br_3_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    lya_br_3_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    nv1240_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    nv1240_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    nv1240_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    nv1240_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    nv1240_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    nv1240_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    siiv_oiv1_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    siiv_oiv1_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    siiv_oiv1_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    siiv_oiv1_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    siiv_oiv1_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    siiv_oiv1_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    siiv_oiv2_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    siiv_oiv2_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    siiv_oiv2_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    siiv_oiv2_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    siiv_oiv2_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    siiv_oiv2_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    cii1335_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    cii1335_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    cii1335_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    cii1335_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    cii1335_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    cii1335_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    oi1304_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oi1304_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    oi1304_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oi1304_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    oi1304_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oi1304_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    civ_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    civ_br_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    civ_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    civ_br_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    civ_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    civ_br_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    civ_br_2_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    civ_br_2_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    civ_br_2_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    civ_br_2_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    civ_br_2_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    civ_br_2_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    civ_br_3_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    civ_br_3_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    civ_br_3_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    civ_br_3_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    civ_br_3_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    civ_br_3_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    heii1640_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    heii1640_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    heii1640_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    heii1640_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    heii1640_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    heii1640_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    oiii1663_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oiii1663_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    oiii1663_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oiii1663_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    oiii1663_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oiii1663_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    heii1640_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    heii1640_br_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    heii1640_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    heii1640_br_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    heii1640_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    heii1640_br_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    oiii1663_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oiii1663_br_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    oiii1663_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oiii1663_br_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    oiii1663_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oiii1663_br_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    ciii_br1_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    ciii_br1_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    ciii_br1_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    ciii_br1_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    ciii_br1_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    ciii_br1_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    ciii_br2_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    ciii_br2_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    ciii_br2_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    ciii_br2_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    ciii_br2_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    ciii_br2_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    siiii1892_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    siiii1892_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    siiii1892_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    siiii1892_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    siiii1892_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    siiii1892_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    aliii1857_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    aliii1857_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    aliii1857_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    aliii1857_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    aliii1857_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    aliii1857_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    siii1816_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    siii1816_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    siii1816_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    siii1816_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    siii1816_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    siii1816_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    niii1750_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    niii1750_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    niii1750_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    niii1750_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    niii1750_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    niii1750_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    niv1718_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    niv1718_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    niv1718_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    niv1718_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    niv1718_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    niv1718_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    mgii_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    mgii_br_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    mgii_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    mgii_br_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    mgii_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    mgii_br_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    mgii_br_2_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    mgii_br_2_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    mgii_br_2_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    mgii_br_2_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    mgii_br_2_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    mgii_br_2_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    mgii_na_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    mgii_na_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    mgii_na_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    mgii_na_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    mgii_na_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    mgii_na_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    1_local_complex_name varchar(8) NOT NULL, --/U  --/D First local line complex name 
    1_local_line_status bigint NOT NULL, --/U  --/D First local line complex fit status 
    1_local_line_min_chi2 float NOT NULL, --/U  --/D First local line complex chi2 
    1_local_line_red_chi2 float NOT NULL, --/U  --/D First local line complex reduced chi2 
    1_local_niter float NOT NULL, --/U  --/D First local line complex number of iterations 
    1_local_ndof float NOT NULL, --/U  --/D First local line complex number of pixels 
    1_local_npix float NOT NULL, --/U  --/D First local line complex number of degrees of freedom 
    2_local_complex_name varchar(8) NOT NULL, --/U  --/D Second local line complex name 
    2_local_line_status bigint NOT NULL, --/U  --/D Second local line complex fit status 
    2_local_line_min_chi2 float NOT NULL, --/U  --/D Second local line complex chi2 
    2_local_line_red_chi2 float NOT NULL, --/U  --/D Second local line complex reduced chi2 
    2_local_niter float NOT NULL, --/U  --/D Second local line complex number of iterations 
    2_local_ndof float NOT NULL, --/U  --/D Second local line complex number of pixels 
    2_local_npix float NOT NULL, --/U  --/D Second local line complex number of degrees of freedom 
    cii_pl_norm float NOT NULL, --/U  --/D Local line complex power-law normalization 
    cii_pl_slope float NOT NULL, --/U  --/D Local line complex power-law slope 
    neiv2422_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    neiv2422_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    neiv2422_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    cii2326_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    cii2326_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    cii2326_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    nev_pl_norm float NOT NULL, --/U  --/D Local line complex power-law normalization 
    nev_pl_slope float NOT NULL, --/U  --/D Local line complex power-law slope 
    nev3426_na_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    nev3426_na_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    nev3426_na_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    nev3426_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    nev3426_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    nev3426_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    nev3346_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    nev3346_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    nev3346_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    heii_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    heii_br_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    heii_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    heii_br_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    heii_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    heii_br_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    heii_na_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    heii_na_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    heii_na_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    heii_na_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    heii_na_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    heii_na_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    hbeta_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hbeta_br_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    hbeta_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hbeta_br_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    hbeta_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hbeta_br_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    hbeta_br_2_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hbeta_br_2_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    hbeta_br_2_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hbeta_br_2_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    hbeta_br_2_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hbeta_br_2_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    hbeta_br_3_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hbeta_br_3_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    hbeta_br_3_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hbeta_br_3_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    hbeta_br_3_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hbeta_br_3_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    hbeta_na_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hbeta_na_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    hbeta_na_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hbeta_na_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    hbeta_na_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hbeta_na_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    oiii4959c_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oiii4959c_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    oiii4959c_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oiii4959c_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    oiii4959c_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oiii4959c_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    oiii5007c_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oiii5007c_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    oiii5007c_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oiii5007c_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    oiii5007c_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oiii5007c_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    oiii4959w_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oiii4959w_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    oiii4959w_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oiii4959w_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    oiii4959w_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oiii4959w_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    oiii5007w_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oiii5007w_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    oiii5007w_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oiii5007w_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    oiii5007w_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oiii5007w_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    3_local_complex_name varchar(8) NOT NULL, --/U  --/D Third local line complex name 
    3_local_line_status bigint NOT NULL, --/U  --/D Third local line complex fit status 
    3_local_line_min_chi2 float NOT NULL, --/U  --/D Third local line complex chi2 
    3_local_line_red_chi2 float NOT NULL, --/U  --/D Third local line complex reduced chi2 
    3_local_niter float NOT NULL, --/U  --/D Third local line complex number of iterations 
    3_local_ndof float NOT NULL, --/U  --/D Third local line complex number of pixels 
    3_local_npix float NOT NULL, --/U  --/D Third local line complex number of degrees of freedom 
    4_local_complex_name varchar(8) NOT NULL, --/U  --/D Fourth local line complex name 
    4_local_line_status bigint NOT NULL, --/U  --/D Fourth local line complex fit status 
    4_local_line_min_chi2 float NOT NULL, --/U  --/D Fourth local line complex chi2 
    4_local_line_red_chi2 float NOT NULL, --/U  --/D Fourth local line complex reduced chi2 
    4_local_niter float NOT NULL, --/U  --/D Fourth local line complex number of iterations 
    4_local_ndof float NOT NULL, --/U  --/D Fourth local line complex number of pixels 
    4_local_npix float NOT NULL, --/U  --/D Fourth local line complex number of degrees of freedom 
    neiii_oii_pl_norm float NOT NULL, --/U  --/D Local line complex power-law normalization 
    neiii_oii_pl_slope float NOT NULL, --/U  --/D Local line complex power-law slope 
    neiii3967_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    neiii3967_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    neiii3967_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    neiii3869_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    neiii3869_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    neiii3869_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oii3728_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oii3728_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oii3728_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    fevii3759_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    fevii3759_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    fevii3759_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hg_hd_pl_norm float NOT NULL, --/U  --/D Local line complex power-law normalization 
    hg_hd_pl_slope float NOT NULL, --/U  --/D Local line complex power-law slope 
    oiii4363_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oiii4363_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oiii4363_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hgamma_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hgamma_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hgamma_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hgamma_na_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hgamma_na_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hgamma_na_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hdelta_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hdelta_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hdelta_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hdelta_na_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hdelta_na_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hdelta_na_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oiv_pl_norm float NOT NULL, --/U  --/D Local line complex power-law normalization 
    oiv_pl_slope float NOT NULL, --/U  --/D Local line complex power-law slope 
    oiv1035_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oiv1035_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oiv1035_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    halpha_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    halpha_br_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    halpha_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    halpha_br_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    halpha_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    halpha_br_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    halpha_br_2_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    halpha_br_2_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    halpha_br_2_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    halpha_br_2_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    halpha_br_2_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    halpha_br_2_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    halpha_br_3_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    halpha_br_3_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    halpha_br_3_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    halpha_br_3_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    halpha_br_3_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    halpha_br_3_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    halpha_na_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    halpha_na_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    halpha_na_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    halpha_na_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    halpha_na_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    halpha_na_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    nii6549_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    nii6549_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    nii6549_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    nii6549_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    nii6549_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    nii6549_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    nii6585_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    nii6585_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    nii6585_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    nii6585_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    nii6585_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    nii6585_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    sii6718_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    sii6718_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    sii6718_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    sii6718_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    sii6718_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    sii6718_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    sii6732_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    sii6732_1_scale_error float NOT NULL, --/U  --/D Gaussian amplitude (ln) error 
    sii6732_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    sii6732_1_centerwave_error float NOT NULL, --/U  --/D Central wavelength (ln) error 
    sii6732_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    sii6732_1_sigma_error float NOT NULL, --/U  --/D Gaussian width (ln) error 
    hei_fe_oi_pl_norm float NOT NULL, --/U  --/D Local line complex power-law normalization 
    hei_fe_oi_pl_slope float NOT NULL, --/U  --/D Local line complex power-law slope 
    fevii6088_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    fevii6088_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    fevii6088_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    fex6376_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    fex6376_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    fex6376_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    oi6300_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    oi6300_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    oi6300_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hei_br_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hei_br_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hei_br_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    hei_na_1_scale float NOT NULL, --/U  --/D Gaussian amplitude (ln) 
    hei_na_1_centerwave float NOT NULL, --/U  --/D Central wavelength (ln) 
    hei_na_1_sigma float NOT NULL, --/U  --/D Gaussian width (ln) 
    5_local_complex_name varchar(8) NOT NULL, --/U  --/D Fifth local line complex name 
    5_local_line_status bigint NOT NULL, --/U  --/D Fifth local line complex fit status 
    5_local_line_min_chi2 float NOT NULL, --/U  --/D Fifth local line complex chi2 
    5_local_line_red_chi2 float NOT NULL, --/U  --/D Fifth local line complex reduced chi2 
    5_local_niter float NOT NULL, --/U  --/D Fifth local line complex number of iterations 
    5_local_ndof float NOT NULL, --/U  --/D Fifth local line complex number of pixels 
    5_local_npix float NOT NULL, --/U  --/D Fifth local line complex number of degrees of freedom 
    hg_subtraction bit NOT NULL, --/U  --/D True: host-galaxy emission subtracted; False: quasar-dominated 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
);
