create table efeds_spiders_agn_hard_xray_catalogue (
    ------- 
    --/H eROSITA Hard Sample X-ray catalogue from Brunner et al. (2022)
    --/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
    --/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
    --/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
    --/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
    --/T Also provided are the X-ray and public photometric data.
    ------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source Name 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of eROSITA source in the Main Sample 
    ero_id_hard int NOT NULL, --/U  --/D ID of eROSITA source in the Hard Sample 
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from visual inspection (Aydar+2025) 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension (J2000) 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination (J2000) 
    mjd int NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    ra float NOT NULL, --/U deg --/D eROSITA uncorrected RA (ICRS) 
    dec float NOT NULL, --/U deg --/D eROSITA uncorrected Dec (ICRS) 
    radec_err real NOT NULL, --/U arcsec --/D Combined positional uncertainty, uncorrected 
    ra_corr float NOT NULL, --/U deg --/D J2000 Right Ascension of the eROSITA source (corrected) 
    dec_corr float NOT NULL, --/U deg --/D J2000 Declination of the eROSITA source (corrected) 
    radec_err_corr float NOT NULL, --/U arcsec --/D eROSITA positional uncertainty (corrected) 
    ext real NOT NULL, --/U arcsec --/D Source extent 
    ext_err real NOT NULL, --/U arcsec --/D Extent error 
    ext_like real NOT NULL, --/U  --/D Extent likelihood 
    det_like_0 real NOT NULL, --/U  --/D Detection likelihood measured by PSF-fitting, combining 3 bands 
    ml_rate_0 real NOT NULL, --/U count/s --/D Source count rate, combining 3 bands 
    ml_rate_err_0 real NOT NULL, --/U count/s --/D 1 sigma count rate error 
    ml_cts_0 real NOT NULL, --/U count --/D Source net counts, combining 3 bands 
    ml_cts_err_0 real NOT NULL, --/U count --/D 1 sigma counts error 
    ml_flux_0 real NOT NULL, --/U erg / (cm2 s) --/D Source flux, combining 3 bands 
    ml_flux_err_0 real NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error 
    ml_bkg_0 real NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position 
    inarea90 bit NOT NULL, --/U  --/D True if in the 0.2-2.3keV exp>500s region, which comprises 90% area 
    det_like_1 real NOT NULL, --/U  --/D 0.2-0.6 keV detection likelihood 
    det_like_2 real NOT NULL, --/U  --/D 0.6-2.3 keV detection likelihood 
    det_like_3 real NOT NULL, --/U  --/D 2.3-5 keV detection likelihood 
    ml_rate_1 real NOT NULL, --/U count/s --/D 0.2-0.6 keV count rate 
    ml_rate_2 real NOT NULL, --/U count/s --/D 0.6-2.3 keV count rate 
    ml_rate_3 real NOT NULL, --/U count/s --/D 2.3-5 keV count rate 
    ml_rate_err_1 real NOT NULL, --/U count/s --/D 1 sigma count rate error; 0.2-0.6 keV 
    ml_rate_err_2 real NOT NULL, --/U count/s --/D 1 sigma count rate error; 0.6-2.3 keV 
    ml_rate_err_3 real NOT NULL, --/U count/s --/D 1 sigma count rate error; 2.3-5 keV 
    ml_cts_1 real NOT NULL, --/U count --/D 0.2-0.6 keV net counts 
    ml_cts_2 real NOT NULL, --/U count --/D 0.6-2.3 keV net counts 
    ml_cts_3 real NOT NULL, --/U count --/D 2.3-5 keV net counts 
    ml_cts_err_1 real NOT NULL, --/U count --/D 1 sigma counts error; 0.2-0.6 keV 
    ml_cts_err_2 real NOT NULL, --/U count --/D 1 sigma counts error; 0.6-2.3 keV 
    ml_cts_err_3 real NOT NULL, --/U count --/D 1 sigma counts error; 2.3-5 keV 
    ml_flux_1 real NOT NULL, --/U erg / (cm2 s) --/D 0.2-0.6 keV flux 
    ml_flux_2 real NOT NULL, --/U erg / (cm2 s) --/D 0.6-2.3 keV flux 
    ml_flux_3 real NOT NULL, --/U erg / (cm2 s) --/D 2.3-5 keV flux 
    ml_flux_err_1 real NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 0.2-0.6 keV 
    ml_flux_err_2 real NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 0.6-2.3 keV 
    ml_flux_err_3 real NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 2.3-5 keV 
    ml_exp_1 real NOT NULL, --/U s --/D Vignetted exposure value; 0.2-0.6 keV 
    ml_exp_2 real NOT NULL, --/U s --/D Vignetted exposure value; 0.6-2.3 keV 
    ml_exp_3 real NOT NULL, --/U s --/D Vignetted exposure value; 2.3-5 keV 
    ml_bkg_1 real NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 0.2-0.6 keV 
    ml_bkg_2 real NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 0.6-2.3 keV 
    ml_bkg_3 real NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 2.3-5 keV 
    det_like_b1 float NOT NULL, --/U  --/D Detection likelihood measured by forced PSF-fitting; 0.2-0.5 keV 
    det_like_b2 float NOT NULL, --/U  --/D Detection likelihood measured by forced PSF-fitting; 0.5-1 keV 
    det_like_b3 float NOT NULL, --/U  --/D Detection likelihood measured by forced PSF-fitting; 1-2 keV 
    det_like_b4 float NOT NULL, --/U  --/D Detection likelihood measured by forced PSF-fitting; 2-4.5 keV 
    det_like_s float NOT NULL, --/U  --/D Detection likelihood measured by forced PSF-fitting; 0.5-2 keV 
    det_like_h float NOT NULL, --/U  --/D Detection likelihood measured by forced PSF-fitting; 2.3-5 keV 
    det_like_u float NOT NULL, --/U  --/D Detection likelihood measured by forced PSF-fitting; 5-8 keV 
    ml_rate_b1 float NOT NULL, --/U count/s --/D Source count rate measured by forced PSF-fitting; 0.2-0.5 keV 
    ml_rate_b2 float NOT NULL, --/U count/s --/D Source count rate measured by forced PSF-fitting; 0.5-1 keV 
    ml_rate_b3 float NOT NULL, --/U count/s --/D Source count rate measured by forced PSF-fitting; 1-2 keV 
    ml_rate_b4 float NOT NULL, --/U count/s --/D Source count rate measured by forced PSF-fitting; 2-4.5 keV 
    ml_rate_s float NOT NULL, --/U count/s --/D Source count rate measured by forced PSF-fitting; 0.5-2 keV 
    ml_rate_h float NOT NULL, --/U count/s --/D Source count rate measured by forced PSF-fitting; 2.3-5 keV 
    ml_rate_u float NOT NULL, --/U count/s --/D Source count rate measured by forced PSF-fitting; 5-8 keV 
    ml_rate_err_b1 float NOT NULL, --/U count/s --/D 1 sigma count rate error; 0.2-0.5 keV 
    ml_rate_err_b2 float NOT NULL, --/U count/s --/D 1 sigma count rate error; 0.5-1 keV 
    ml_rate_err_b3 float NOT NULL, --/U count/s --/D 1 sigma count rate error; 1-2 keV 
    ml_rate_err_b4 float NOT NULL, --/U count/s --/D 1 sigma count rate error; 2-4.5 keV 
    ml_rate_err_s float NOT NULL, --/U count/s --/D 1 sigma count rate error; 0.5-2 keV 
    ml_rate_err_h float NOT NULL, --/U count/s --/D 1 sigma count rate error; 2.3-5 keV 
    ml_rate_err_u float NOT NULL, --/U count/s --/D 1 sigma count rate error; 5-8 keV 
    ml_rate_lowerr_b1 float NOT NULL, --/U count/s --/D 1 sigma lower error of count rate; 0.2-0.5 keV 
    ml_rate_lowerr_b2 float NOT NULL, --/U count/s --/D 1 sigma lower error of count rate; 0.5-1 keV 
    ml_rate_lowerr_b3 float NOT NULL, --/U count/s --/D 1 sigma lower error of count rate; 1-2 keV 
    ml_rate_lowerr_b4 float NOT NULL, --/U count/s --/D 1 sigma lower error of count rate; 2-4.5 keV 
    ml_rate_lowerr_s float NOT NULL, --/U count/s --/D 1 sigma lower error of count rate; 0.5-2 keV 
    ml_rate_lowerr_h float NOT NULL, --/U count/s --/D 1 sigma lower error of count rate; 2.3-5 keV 
    ml_rate_lowerr_u float NOT NULL, --/U count/s --/D 1 sigma lower error of count rate; 5-8 keV 
    ml_rate_uperr_b1 float NOT NULL, --/U count/s --/D 1 sigma upper error of count rate; 0.2-0.5 keV 
    ml_rate_uperr_b2 float NOT NULL, --/U count/s --/D 1 sigma upper error of count rate; 0.5-1 keV 
    ml_rate_uperr_b3 float NOT NULL, --/U count/s --/D 1 sigma upper error of count rate; 1-2 keV 
    ml_rate_uperr_b4 float NOT NULL, --/U count/s --/D 1 sigma upper error of count rate; 2-4.5 keV 
    ml_rate_uperr_s float NOT NULL, --/U count/s --/D 1 sigma upper error of count rate; 0.5-2 keV 
    ml_rate_uperr_h float NOT NULL, --/U count/s --/D 1 sigma upper error of count rate; 2.3-5 keV 
    ml_rate_uperr_u float NOT NULL, --/U count/s --/D 1 sigma upper error of count rate; 5-8 keV 
    ml_cts_b1 float NOT NULL, --/U count --/D Source net counts measured from count rate; 0.2-0.5 keV 
    ml_cts_b2 float NOT NULL, --/U count --/D Source net counts measured from count rate; 0.5-1 keV 
    ml_cts_b3 float NOT NULL, --/U count --/D Source net counts measured from count rate; 1-2 keV 
    ml_cts_b4 float NOT NULL, --/U count --/D Source net counts measured from count rate; 2-4.5 keV 
    ml_cts_s float NOT NULL, --/U count --/D Source net counts measured from count rate; 0.5-2 keV 
    ml_cts_h float NOT NULL, --/U count --/D Source net counts measured from count rate; 2.3-5 keV 
    ml_cts_u float NOT NULL, --/U count --/D Source net counts measured from count rate; 5-8 keV 
    ml_cts_err_b1 float NOT NULL, --/U count --/D 1 sigma counts error; 0.2-0.5 keV 
    ml_cts_err_b2 float NOT NULL, --/U count --/D 1 sigma counts error; 0.5-1 keV 
    ml_cts_err_b3 float NOT NULL, --/U count --/D 1 sigma counts error; 1-2 keV 
    ml_cts_err_b4 float NOT NULL, --/U count --/D 1 sigma counts error; 2-4.5 keV 
    ml_cts_err_s float NOT NULL, --/U count --/D 1 sigma counts error; 0.5-2 keV 
    ml_cts_err_h float NOT NULL, --/U count --/D 1 sigma counts error; 2.3-5 keV 
    ml_cts_err_u float NOT NULL, --/U count --/D 1 sigma counts error; 5-8 keV 
    ml_cts_lowerr_b1 float NOT NULL, --/U count --/D 1 sigma lower error of counts; 0.2-0.5 keV 
    ml_cts_lowerr_b2 float NOT NULL, --/U count --/D 1 sigma lower error of counts; 0.5-1 keV 
    ml_cts_lowerr_b3 float NOT NULL, --/U count --/D 1 sigma lower error of counts; 1-2 keV 
    ml_cts_lowerr_b4 float NOT NULL, --/U count --/D 1 sigma lower error of counts; 2-4.5 keV 
    ml_cts_lowerr_s float NOT NULL, --/U count --/D 1 sigma lower error of counts; 0.5-2 keV 
    ml_cts_lowerr_h float NOT NULL, --/U count --/D 1 sigma lower error of counts; 2.3-5 keV 
    ml_cts_lowerr_u float NOT NULL, --/U count --/D 1 sigma lower error of counts; 5-8 keV 
    ml_cts_uperr_b1 float NOT NULL, --/U count --/D 1 sigma upper error of counts; 0.2-0.5 keV 
    ml_cts_uperr_b2 float NOT NULL, --/U count --/D 1 sigma upper error of counts; 0.5-1 keV 
    ml_cts_uperr_b3 float NOT NULL, --/U count --/D 1 sigma upper error of counts; 1-2 keV 
    ml_cts_uperr_b4 float NOT NULL, --/U count --/D 1 sigma upper error of counts; 2-4.5 keV 
    ml_cts_uperr_s float NOT NULL, --/U count --/D 1 sigma upper error of counts; 0.5-2 keV 
    ml_cts_uperr_h float NOT NULL, --/U count --/D 1 sigma upper error of counts; 2.3-5 keV 
    ml_cts_uperr_u float NOT NULL, --/U count --/D 1 sigma upper error of counts; 5-8 keV 
    ml_flux_b1 float NOT NULL, --/U erg / (cm2 s) --/D Source flux converted from count rate; 0.2-0.5 keV 
    ml_flux_b2 float NOT NULL, --/U erg / (cm2 s) --/D Source flux converted from count rate; 0.5-1 keV 
    ml_flux_b3 float NOT NULL, --/U erg / (cm2 s) --/D Source flux converted from count rate; 1-2 keV 
    ml_flux_b4 float NOT NULL, --/U erg / (cm2 s) --/D Source flux converted from count rate; 2-4.5 keV 
    ml_flux_s float NOT NULL, --/U erg / (cm2 s) --/D Source flux converted from count rate; 0.5-2 keV 
    ml_flux_h float NOT NULL, --/U erg / (cm2 s) --/D Source flux converted from count rate; 2.3-5 keV 
    ml_flux_u float NOT NULL, --/U erg / (cm2 s) --/D Source flux converted from count rate; 5-8 keV 
    ml_flux_err_b1 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 0.2-0.5 keV 
    ml_flux_err_b2 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 0.5-1 keV 
    ml_flux_err_b3 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 1-2 keV 
    ml_flux_err_b4 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 2-4.5 keV 
    ml_flux_err_s float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 0.5-2 keV 
    ml_flux_err_h float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 2.3-5 keV 
    ml_flux_err_u float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error; 5-8 keV 
    ml_flux_lowerr_b1 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma lower error of flux; 0.2-0.5 keV 
    ml_flux_lowerr_b2 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma lower error of flux; 0.5-1 keV 
    ml_flux_lowerr_b3 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma lower error of flux; 1-2 keV 
    ml_flux_lowerr_b4 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma lower error of flux; 2-4.5 keV 
    ml_flux_lowerr_s float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma lower error of flux; 0.5-2 keV 
    ml_flux_lowerr_h float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma lower error of flux; 2.3-5 keV 
    ml_flux_lowerr_u float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma lower error of flux; 5-8 keV 
    ml_flux_uperr_b1 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma upper error of flux; 0.2-0.5 keV 
    ml_flux_uperr_b2 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma upper error of flux; 0.5-1 keV 
    ml_flux_uperr_b3 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma upper error of flux; 1-2 keV 
    ml_flux_uperr_b4 float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma upper error of flux; 2-4.5 keV 
    ml_flux_uperr_s float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma upper error of flux; 0.5-2 keV 
    ml_flux_uperr_h float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma upper error of flux; 2.3-5 keV 
    ml_flux_uperr_u float NOT NULL, --/U erg / (cm2 s) --/D 1 sigma upper error of flux; 5-8 keV 
    ml_exp_b1 float NOT NULL, --/U s --/D Vignetted exposure value; 0.2-0.5 keV 
    ml_exp_b2 float NOT NULL, --/U s --/D Vignetted exposure value; 0.5-1 keV 
    ml_exp_b3 float NOT NULL, --/U s --/D Vignetted exposure value; 1-2 keV 
    ml_exp_b4 float NOT NULL, --/U s --/D Vignetted exposure value; 2-4.5 keV 
    ml_exp_s float NOT NULL, --/U s --/D Vignetted exposure value; 0.5-2 keV 
    ml_exp_h float NOT NULL, --/U s --/D Vignetted exposure value; 2.3-5 keV 
    ml_exp_u float NOT NULL, --/U s --/D Vignetted exposure value; 5-8 keV 
    ml_bkg_b1 float NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 0.2-0.5 keV 
    ml_bkg_b2 float NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 0.5-1 keV 
    ml_bkg_b3 float NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 1-2 keV 
    ml_bkg_b4 float NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 2-4.5 keV 
    ml_bkg_s float NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 0.5-2 keV 
    ml_bkg_h float NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 2.3-5 keV 
    ml_bkg_u float NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position; 5-8 keV 
    ape_cts_b1 int NOT NULL, --/U count --/D Total counts extracted in the aperture; 0.2-0.5 keV 
    ape_cts_b2 int NOT NULL, --/U count --/D Total counts extracted in the aperture; 0.5-1 keV 
    ape_cts_b3 int NOT NULL, --/U count --/D Total counts extracted in the aperture; 1-2 keV 
    ape_cts_b4 int NOT NULL, --/U count --/D Total counts extracted in the aperture; 2-4.5 keV 
    ape_cts_s int NOT NULL, --/U count --/D Total counts extracted in the aperture; 0.5-2 keV 
    ape_cts_h int NOT NULL, --/U count --/D Total counts extracted in the aperture; 2.3-5 keV 
    ape_cts_u int NOT NULL, --/U count --/D Total counts extracted in the aperture; 5-8 keV 
    ape_exp_b1 float NOT NULL, --/U s --/D Vignetted exposure value; 0.2-0.5 keV 
    ape_exp_b2 float NOT NULL, --/U s --/D Vignetted exposure value; 0.5-1 keV 
    ape_exp_b3 float NOT NULL, --/U s --/D Vignetted exposure value; 1-2 keV 
    ape_exp_b4 float NOT NULL, --/U s --/D Vignetted exposure value; 2-4.5 keV 
    ape_exp_s float NOT NULL, --/U s --/D Vignetted exposure value; 0.5-2 keV 
    ape_exp_h float NOT NULL, --/U s --/D Vignetted exposure value; 2.3-5 keV 
    ape_exp_u float NOT NULL, --/U s --/D Vignetted exposure value; 5-8 keV 
    ape_bkg_b1 float NOT NULL, --/U count --/D Background counts in aperture, excluding nearby sources; 0.2-0.5 keV 
    ape_bkg_b2 float NOT NULL, --/U count --/D Background counts in aperture, excluding nearby sources; 0.5-1 keV 
    ape_bkg_b3 float NOT NULL, --/U count --/D Background counts in aperture, excluding nearby sources; 1-2 keV 
    ape_bkg_b4 float NOT NULL, --/U count --/D Background counts in aperture, excluding nearby sources; 2-4.5 keV 
    ape_bkg_s float NOT NULL, --/U count --/D Background counts in aperture, excluding nearby sources; 0.5-2 keV 
    ape_bkg_h float NOT NULL, --/U count --/D Background counts in aperture, excluding nearby sources; 2.3-5 keV 
    ape_bkg_u float NOT NULL, --/U count --/D Background counts in aperture, excluding nearby sources; 5-8 keV 
    ape_radius_b1 float NOT NULL, --/U pixel --/D Aperture radius; 0.2-0.5 keV 
    ape_radius_b2 float NOT NULL, --/U pixel --/D Aperture radius; 0.5-1 keV 
    ape_radius_b3 float NOT NULL, --/U pixel --/D Aperture radius; 1-2 keV 
    ape_radius_b4 float NOT NULL, --/U pixel --/D Aperture radius; 2-4.5 keV 
    ape_radius_s float NOT NULL, --/U pixel --/D Aperture radius; 0.5-2 keV 
    ape_radius_h float NOT NULL, --/U pixel --/D Aperture radius; 2.3-5 keV 
    ape_radius_u float NOT NULL, --/U pixel --/D Aperture radius; 5-8 keV 
    ape_pois_b1 float NOT NULL, --/U  --/D Poisson probability of being background fluctuation; 0.2-0.5 keV 
    ape_pois_b2 float NOT NULL, --/U  --/D Poisson probability of being background fluctuation; 0.5-1 keV 
    ape_pois_b3 float NOT NULL, --/U  --/D Poisson probability of being background fluctuation; 1-2 keV 
    ape_pois_b4 float NOT NULL, --/U  --/D Poisson probability of being background fluctuation; 2-4.5 keV 
    ape_pois_s float NOT NULL, --/U  --/D Poisson probability of being background fluctuation; 0.5-2 keV 
    ape_pois_h float NOT NULL, --/U  --/D Poisson probability of being background fluctuation; 2.3-5 keV 
    ape_pois_u float NOT NULL, --/U  --/D Poisson probability of being background fluctuation; 5-8 keV 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
);
