create table DL1_spec_SDSSV_eROSITA_eRASS3_allepoch (
    ------- 
    --/H SDSS and eROSITA data of the sources within the SPIDERS program 
    --/T Data Level 1 contains the data shared among the collaborations of SDSS and 
    --/T eROSITA, with optical and X-ray information of sources that were detected 
    --/T with eROSITA and followed-up with SDSS 
    ------- 
    ero_detuid varchar(32) NOT NULL, --/U  --/D eROSITA unique X-ray source identifier 
    sdss_catalogid bigint NOT NULL, --/U  --/D SDSS CATALOGID (used before the unification with SDSS_ID) 
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID (SDSS-V unique source identifier) 
    sdss_obs varchar(3) NOT NULL, --/U  --/D SDSS observatory (APO or LCO) 
    sdss_field bigint NOT NULL, --/U  --/D SDSS field sequence number 
    sdss_mjd bigint NOT NULL, --/U day --/D SDSS modified Julian date of observation 
    sdss_objtype varchar(16) NOT NULL, --/U  --/D SDSS object type 
    sdss_fiber_ra float NOT NULL, --/U degree --/D SDSS fiber position coordinate: right ascension 
    sdss_fiber_dec float NOT NULL, --/U degree --/D SDSS fiber position coordinate: declination 
    sdss_z real NOT NULL, --/U  --/D SDSS best redshift fit 
    sdss_z_err real NOT NULL, --/U  --/D SDSS redshift error 
    sdss_zwarning bigint NOT NULL, --/U  --/D SDSS redshift measurement warning flag 
    sdss_sn_median_all real NOT NULL, --/U  --/D SDSS median Signal to Noise over the entire spectral range 
    sdss_class varchar(6) NOT NULL, --/U  --/D SDSS best fit spectroscopic classification 
    sdss_subclass varchar(21) NOT NULL, --/U  --/D SDSS subclass 
    sdss_run2d varchar(6) NOT NULL, --/U  --/D Tagged version of idlspec2d that was used to reduce the SDSS BOSS spectra 
    sdss_nspec bigint NOT NULL, --/U  --/D Number of observed SDSS spectra 
    sdss_vrad_astra real NOT NULL, --/U km/s --/D ASTRA stellar fit: Radial velocity 
    sdss_evrad_astra real NOT NULL, --/U km/s --/D ASTRA stellar fit: Radial velocity error 
    sdss_teff_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Effective temperature 
    sdss_eteff_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Effective temperature error 
    sdss_logg_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Surface gravity 
    sdss_elogg_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Surface gravity error 
    sdss_feh_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Metallicity [Fe/H] 
    sdss_efeh_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Metallicity [Fe/H] error 
    gaia_bp real NOT NULL, --/U Vega mag --/D Gaia DR2 BP passband 
    gaia_rp real NOT NULL, --/U Vega mag --/D Gaia DR2 RP passband 
    gaia_g real NOT NULL, --/U Vega mag --/D Gaia DR2 G passband 
    racat float NOT NULL, --/U degree --/D Right ascension of the SDSS-V target, as derived from external catalogs 
    deccat float NOT NULL, --/U degree --/D Declination of the SDSS-V target, as derived from external catalogs 
    coord_epoch real NOT NULL, --/U  --/D Coordinate epoch of the SDSS-V target, as derived from external catalogs 
    pmra real NOT NULL, --/U mas/yr --/D Proper Motion in right ascension of the SDSS-V target, as derived from external catalogs 
    pmdec real NOT NULL, --/U mas/yr --/D Proper Motion in declination of the SDSS-V target, as derived from external catalogs 
    parallax real NOT NULL, --/U mas --/D Parallax of the SDSS-V target, as derived from external catalogs 
    wise_mag_1 real NOT NULL, --/F wise_mag 0 --/U  --/D WISE photometry (W1, W2, W3, W4) (array element 1) 
    wise_mag_2 real NOT NULL, --/F wise_mag 1 --/U  --/D WISE photometry (W1, W2, W3, W4) (array element 2) 
    wise_mag_3 real NOT NULL, --/F wise_mag 2 --/U  --/D WISE photometry (W1, W2, W3, W4) (array element 3) 
    wise_mag_4 real NOT NULL, --/F wise_mag 3 --/U  --/D WISE photometry (W1, W2, W3, W4) (array element 4) 
    twomass_mag_1 real NOT NULL, --/F twomass_mag 0 --/U  --/D 2MASS photometry (J, H, Ks) (array element 1) 
    twomass_mag_2 real NOT NULL, --/F twomass_mag 1 --/U  --/D 2MASS photometry (J, H, Ks) (array element 2) 
    twomass_mag_3 real NOT NULL, --/F twomass_mag 2 --/U  --/D 2MASS photometry (J, H, Ks) (array element 3) 
    guvcat_mag_1 real NOT NULL, --/F guvcat_mag 0 --/U  --/D GALEX UV photometry (FUV, NUV) (array element 1) 
    guvcat_mag_2 real NOT NULL, --/F guvcat_mag 1 --/U  --/D GALEX UV photometry (FUV, NUV) (array element 2) 
    ero_ra float NOT NULL, --/U degree --/D eROSITA position estimate: right ascension 
    ero_dec float NOT NULL, --/U degree --/D eROSITA position estimate: declination 
    ero_pos_err float NOT NULL, --/U arcsec --/D eROSITA positional error 
    ero_mjd real NOT NULL, --/U day --/D eROSITA modified Julian date of observation 
    ero_mjd_flag smallint NOT NULL, --/U  --/D eROSITA MJD flag (1 for sources close to the boundaries of the survey) 
    ero_morph varchar(9) NOT NULL, --/U  --/D eROSITA source morphological classification (point-like or extended) 
    ero_flux real NOT NULL, --/U erg/s/cm^2 --/D eROSITA flux 
    ero_flux_err real NOT NULL, --/U erg/s/cm^2 --/D eROSITA flux error 
    ero_det_like real NOT NULL, --/U  --/D eROSITA source detection likelihood in the given band 
    ero_flux_type varchar(9) NOT NULL, --/U keV --/D eROSITA band for the given flux 
    ero_version varchar(6) NOT NULL --/U  --/D ero_version 
);
