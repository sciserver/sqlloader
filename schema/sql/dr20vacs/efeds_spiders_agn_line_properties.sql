create table efeds_spiders_agn_line_properties (
    ------- 
    --/H eFEDS SPIDERS AGN emission lines properties (PYQSOFIT fitting)
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
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from visual inspection (Aydar+2025) 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension (J2000) 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination (J2000) 
    mjd int NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    sn_median_all float NOT NULL, --/U  --/D SDSS Median S/N per pix in spectrum (idlspec2d v6_0_2 reductions) 
    sii6732_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    sii6732_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    sii6732_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    sii6732_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    sii6732_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    sii6732_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    sii6732_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    sii6732_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    sii6732_ew float NOT NULL, --/U A --/D Line equivalent width 
    sii6732_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    sii6718_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    sii6718_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    sii6718_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    sii6718_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    sii6718_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    sii6718_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    sii6718_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    sii6718_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    sii6718_ew float NOT NULL, --/U A --/D Line equivalent width 
    sii6718_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    nii6585_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    nii6585_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    nii6585_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    nii6585_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    nii6585_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    nii6585_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    nii6585_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    nii6585_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    nii6585_ew float NOT NULL, --/U A --/D Line equivalent width 
    nii6585_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    nii6549_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    nii6549_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    nii6549_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    nii6549_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    nii6549_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    nii6549_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    nii6549_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    nii6549_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    nii6549_ew float NOT NULL, --/U A --/D Line equivalent width 
    nii6549_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    halpha_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    halpha_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    halpha_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    halpha_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    halpha_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    halpha_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    halpha_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    halpha_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    halpha_ew float NOT NULL, --/U A --/D Line equivalent width 
    halpha_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    halpha_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    halpha_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    halpha_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    halpha_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    halpha_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    halpha_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    halpha_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    halpha_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    halpha_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    halpha_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    halpha_na_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    halpha_na_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    halpha_na_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    halpha_na_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    halpha_na_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    halpha_na_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    halpha_na_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    halpha_na_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    halpha_na_ew float NOT NULL, --/U A --/D Line equivalent width 
    halpha_na_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    fex6376_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    fex6376_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    fex6376_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    fex6376_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    fex6376_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    fex6376_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    fex6376_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    fex6376_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    fex6376_ew float NOT NULL, --/U A --/D Line equivalent width 
    fex6376_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oi6300_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oi6300_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oi6300_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oi6300_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oi6300_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oi6300_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oi6300_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oi6300_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oi6300_ew float NOT NULL, --/U A --/D Line equivalent width 
    oi6300_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    fevii6088_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    fevii6088_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    fevii6088_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    fevii6088_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    fevii6088_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    fevii6088_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    fevii6088_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    fevii6088_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    fevii6088_ew float NOT NULL, --/U A --/D Line equivalent width 
    fevii6088_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hei5877_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hei5877_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hei5877_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hei5877_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hei5877_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hei5877_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hei5877_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hei5877_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hei5877_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    hei5877_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hei5877_na_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hei5877_na_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hei5877_na_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hei5877_na_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hei5877_na_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hei5877_na_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hei5877_na_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hei5877_na_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hei5877_na_ew float NOT NULL, --/U A --/D Line equivalent width 
    hei5877_na_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hei5877_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hei5877_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hei5877_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hei5877_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hei5877_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hei5877_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hei5877_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hei5877_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hei5877_ew float NOT NULL, --/U A --/D Line equivalent width 
    hei5877_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    heii4685_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    heii4685_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    heii4685_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    heii4685_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    heii4685_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    heii4685_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    heii4685_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    heii4685_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    heii4685_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    heii4685_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    heii4685_na_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    heii4685_na_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    heii4685_na_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    heii4685_na_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    heii4685_na_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    heii4685_na_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    heii4685_na_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    heii4685_na_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    heii4685_na_ew float NOT NULL, --/U A --/D Line equivalent width 
    heii4685_na_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    heii4685_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    heii4685_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    heii4685_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    heii4685_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    heii4685_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    heii4685_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    heii4685_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    heii4685_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    heii4685_ew float NOT NULL, --/U A --/D Line equivalent width 
    heii4685_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiii5007_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiii5007_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiii5007_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiii5007_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiii5007_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiii5007_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiii5007_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiii5007_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiii5007_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiii5007_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiii5007c_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiii5007c_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiii5007c_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiii5007c_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiii5007c_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiii5007c_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiii5007c_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiii5007c_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiii5007c_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiii5007c_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiii5007w_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiii5007w_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiii5007w_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiii5007w_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiii5007w_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiii5007w_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiii5007w_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiii5007w_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiii5007w_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiii5007w_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiii4959_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiii4959_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiii4959_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiii4959_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiii4959_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiii4959_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiii4959_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiii4959_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiii4959_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiii4959_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiii4959c_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiii4959c_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiii4959c_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiii4959c_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiii4959c_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiii4959c_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiii4959c_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiii4959c_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiii4959c_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiii4959c_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiii4959w_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiii4959w_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiii4959w_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiii4959w_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiii4959w_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiii4959w_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiii4959w_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiii4959w_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiii4959w_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiii4959w_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hbeta_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hbeta_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hbeta_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hbeta_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hbeta_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hbeta_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hbeta_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hbeta_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hbeta_ew float NOT NULL, --/U A --/D Line equivalent width 
    hbeta_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hbeta_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hbeta_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hbeta_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hbeta_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hbeta_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hbeta_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hbeta_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hbeta_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hbeta_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    hbeta_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hbeta_na_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hbeta_na_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hbeta_na_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hbeta_na_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hbeta_na_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hbeta_na_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hbeta_na_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hbeta_na_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hbeta_na_ew float NOT NULL, --/U A --/D Line equivalent width 
    hbeta_na_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiii4363_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiii4363_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiii4363_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiii4363_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiii4363_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiii4363_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiii4363_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiii4363_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiii4363_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiii4363_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hgamma_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hgamma_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hgamma_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hgamma_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hgamma_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hgamma_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hgamma_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hgamma_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hgamma_ew float NOT NULL, --/U A --/D Line equivalent width 
    hgamma_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hgamma_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hgamma_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hgamma_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hgamma_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hgamma_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hgamma_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hgamma_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hgamma_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hgamma_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    hgamma_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hgamma_na_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hgamma_na_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hgamma_na_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hgamma_na_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hgamma_na_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hgamma_na_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hgamma_na_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hgamma_na_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hgamma_na_ew float NOT NULL, --/U A --/D Line equivalent width 
    hgamma_na_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hdelta_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hdelta_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hdelta_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hdelta_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hdelta_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hdelta_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hdelta_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hdelta_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hdelta_ew float NOT NULL, --/U A --/D Line equivalent width 
    hdelta_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hdelta_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hdelta_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hdelta_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hdelta_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hdelta_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hdelta_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hdelta_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hdelta_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hdelta_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    hdelta_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hdelta_na_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    hdelta_na_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    hdelta_na_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    hdelta_na_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    hdelta_na_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    hdelta_na_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    hdelta_na_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    hdelta_na_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    hdelta_na_ew float NOT NULL, --/U A --/D Line equivalent width 
    hdelta_na_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    neiii3967_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    neiii3967_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    neiii3967_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    neiii3967_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    neiii3967_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    neiii3967_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    neiii3967_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    neiii3967_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    neiii3967_ew float NOT NULL, --/U A --/D Line equivalent width 
    neiii3967_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    neiii3869_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    neiii3869_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    neiii3869_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    neiii3869_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    neiii3869_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    neiii3869_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    neiii3869_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    neiii3869_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    neiii3869_ew float NOT NULL, --/U A --/D Line equivalent width 
    neiii3869_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    fevii3759_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    fevii3759_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    fevii3759_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    fevii3759_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    fevii3759_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    fevii3759_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    fevii3759_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    fevii3759_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    fevii3759_ew float NOT NULL, --/U A --/D Line equivalent width 
    fevii3759_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oii3728_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oii3728_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oii3728_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oii3728_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oii3728_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oii3728_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oii3728_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oii3728_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oii3728_ew float NOT NULL, --/U A --/D Line equivalent width 
    oii3728_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    nev3426_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    nev3426_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    nev3426_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    nev3426_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    nev3426_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    nev3426_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    nev3426_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    nev3426_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    nev3426_ew float NOT NULL, --/U A --/D Line equivalent width 
    nev3426_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    nev3426_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    nev3426_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    nev3426_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    nev3426_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    nev3426_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    nev3426_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    nev3426_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    nev3426_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    nev3426_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    nev3426_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    nev3426_na_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    nev3426_na_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    nev3426_na_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    nev3426_na_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    nev3426_na_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    nev3426_na_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    nev3426_na_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    nev3426_na_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    nev3426_na_ew float NOT NULL, --/U A --/D Line equivalent width 
    nev3426_na_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    nev3346_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    nev3346_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    nev3346_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    nev3346_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    nev3346_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    nev3346_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    nev3346_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    nev3346_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    nev3346_ew float NOT NULL, --/U A --/D Line equivalent width 
    nev3346_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    mgii_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    mgii_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    mgii_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    mgii_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    mgii_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    mgii_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    mgii_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    mgii_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    mgii_ew float NOT NULL, --/U A --/D Line equivalent width 
    mgii_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    mgii_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    mgii_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    mgii_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    mgii_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    mgii_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    mgii_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    mgii_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    mgii_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    mgii_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    mgii_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    mgii_na_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    mgii_na_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    mgii_na_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    mgii_na_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    mgii_na_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    mgii_na_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    mgii_na_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    mgii_na_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    mgii_na_ew float NOT NULL, --/U A --/D Line equivalent width 
    mgii_na_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    neiv2422_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    neiv2422_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    neiv2422_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    neiv2422_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    neiv2422_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    neiv2422_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    neiv2422_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    neiv2422_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    neiv2422_ew float NOT NULL, --/U A --/D Line equivalent width 
    neiv2422_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    cii2326_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    cii2326_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    cii2326_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    cii2326_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    cii2326_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    cii2326_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    cii2326_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    cii2326_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    cii2326_ew float NOT NULL, --/U A --/D Line equivalent width 
    cii2326_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    ciii_all_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    ciii_all_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    ciii_all_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    ciii_all_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    ciii_all_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    ciii_all_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    ciii_all_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    ciii_all_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    ciii_all_ew float NOT NULL, --/U A --/D Line equivalent width 
    ciii_all_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    ciii_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    ciii_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    ciii_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    ciii_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    ciii_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    ciii_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    ciii_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    ciii_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    ciii_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    ciii_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    siiii1892_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    siiii1892_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    siiii1892_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    siiii1892_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    siiii1892_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    siiii1892_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    siiii1892_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    siiii1892_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    siiii1892_ew float NOT NULL, --/U A --/D Line equivalent width 
    siiii1892_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    aliii1857_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    aliii1857_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    aliii1857_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    aliii1857_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    aliii1857_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    aliii1857_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    aliii1857_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    aliii1857_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    aliii1857_ew float NOT NULL, --/U A --/D Line equivalent width 
    aliii1857_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    siii1816_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    siii1816_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    siii1816_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    siii1816_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    siii1816_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    siii1816_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    siii1816_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    siii1816_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    siii1816_ew float NOT NULL, --/U A --/D Line equivalent width 
    siii1816_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    niii1750_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    niii1750_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    niii1750_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    niii1750_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    niii1750_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    niii1750_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    niii1750_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    niii1750_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    niii1750_ew float NOT NULL, --/U A --/D Line equivalent width 
    niii1750_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    niv1718_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    niv1718_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    niv1718_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    niv1718_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    niv1718_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    niv1718_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    niv1718_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    niv1718_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    niv1718_ew float NOT NULL, --/U A --/D Line equivalent width 
    niv1718_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiii1663_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiii1663_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiii1663_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiii1663_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiii1663_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiii1663_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiii1663_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiii1663_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiii1663_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiii1663_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    heii1640_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    heii1640_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    heii1640_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    heii1640_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    heii1640_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    heii1640_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    heii1640_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    heii1640_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    heii1640_ew float NOT NULL, --/U A --/D Line equivalent width 
    heii1640_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    heii1640_br_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    heii1640_br_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    heii1640_br_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    heii1640_br_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    heii1640_br_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    heii1640_br_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    heii1640_br_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    heii1640_br_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    heii1640_br_ew float NOT NULL, --/U A --/D Line equivalent width 
    heii1640_br_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    civ_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    civ_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    civ_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    civ_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    civ_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    civ_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    civ_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    civ_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    civ_ew float NOT NULL, --/U A --/D Line equivalent width 
    civ_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    siiv_oiv_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    siiv_oiv_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    siiv_oiv_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    siiv_oiv_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    siiv_oiv_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    siiv_oiv_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    siiv_oiv_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    siiv_oiv_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    siiv_oiv_ew float NOT NULL, --/U A --/D Line equivalent width 
    siiv_oiv_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    cii1335_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    cii1335_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    cii1335_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    cii1335_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    cii1335_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    cii1335_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    cii1335_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    cii1335_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    cii1335_ew float NOT NULL, --/U A --/D Line equivalent width 
    cii1335_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oi1304_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oi1304_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oi1304_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oi1304_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oi1304_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oi1304_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oi1304_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oi1304_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oi1304_ew float NOT NULL, --/U A --/D Line equivalent width 
    oi1304_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    lya_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    lya_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    lya_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    lya_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    lya_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    lya_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    lya_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    lya_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    lya_ew float NOT NULL, --/U A --/D Line equivalent width 
    lya_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    nv1240_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    nv1240_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    nv1240_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    nv1240_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    nv1240_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    nv1240_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    nv1240_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    nv1240_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    nv1240_ew float NOT NULL, --/U A --/D Line equivalent width 
    nv1240_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    oiv1035_peak_wavelength float NOT NULL, --/U A --/D Line peak wavelength 
    oiv1035_peak_wavelength_error float NOT NULL, --/U A --/D Line peak wavelength error 
    oiv1035_flux float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux 
    oiv1035_flux_error float NOT NULL, --/U 1e-17 erg/s/cm^2 --/D Line flux error 
    oiv1035_logl float NOT NULL, --/U  --/D Line luminosity (log, erg/s) 
    oiv1035_logl_error float NOT NULL, --/U  --/D Line luminosity error (log, erg/s) 
    oiv1035_fwhm float NOT NULL, --/U km/s --/D Line full width at half maximum 
    oiv1035_fwhm_error float NOT NULL, --/U km/s --/D Line full width at half maximum error 
    oiv1035_ew float NOT NULL, --/U A --/D Line equivalent width 
    oiv1035_ew_error float NOT NULL, --/U A --/D Line equivalent width error 
    hg_subtraction bit NOT NULL, --/U  --/D True: host-galaxy emission subtracted; False: quasar-dominated 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
);
