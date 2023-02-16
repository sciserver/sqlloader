--
-- Name: mos_allwise; Type: TABLE; Schema: minidb; Owner: -
--



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_allwise')
	DROP TABLE mos_allwise
GO
--
EXEC spSetDefaultFileGroup 'mos_allwise'
GO
CREATE TABLE mos_allwise (

----------------------------------------------------------------------
--/H ALLWISE catalog: https://wise2.ipac.caltech.edu/docs/release/allwise/. For detailed descriptions of the columns see: https://wise2.ipac.caltech.edu/docs/release/allwise/expsup/sec2_1a.html
----------------------------------------------------------------------
    designation character(20), --/D Sexagesimal, equatorial position-based source name
    ra numeric(10,7), --/U degrees --/D J2000 right ascension
    [dec] numeric(9,7), --/U degrees --/D J2000 declination
    sigra numeric(7,4), --/U arcsec --/D One-sigma uncertainty in right ascension coordinate
    sigdec numeric(7,4), --/U arcsec --/D One-sigma uncertainty in declination coordinate
    sigradec numeric(8,4), --/U arcsec --/D The co-sigma of the equatorial position uncertainties
    glon numeric(10,7), --/U degrees --/D Galactic longitude
    glat numeric(9,7), --/U degrees --/D Galactic latitude
    elon numeric(10,7), --/U degrees --/D Ecliptic longitude
    elat numeric(9,7), --/U degrees --/D Ecliptic latitude
    wx numeric(7,3), --/U pixel --/D The x-pixel coordinate of this source on the WISE Atlas Image
    wy numeric(7,3), --/U pixel --/D The y-pixel coordinate of this source on the WISE Atlas Image
    cntr bigint NOT NULL, --/D Unique identification number for this object in the AllWISE 
	--/D Catalog/Reject Table
    source_id character(28), --/D Unique source ID
    coadd_id character(20), --/D WISE Atlas Tile identifier from which source was extracted
    src integer, --/D Sequential number of the source extraction in the WISE Atlas Tile from
	--/D  which this source detected and measured
    w1mpro numeric(5,3), --/U mag --/D W1 magnitude measured with profile-fitting photometry
    w1sigmpro numeric(4,3), --/U mag --/D W1 profile-fit photometric measurement uncertainty
    w1snr numeric(7,1), --/D W1 profile-fit measurement signal-to-noise ratio
    w1rchi2 real, --/D Reduced chi^2 of the W1 profile-fit photometry measurement
    w2mpro numeric(5,3), --/U mag --/D W2 magnitude measured with profile-fitting photometry
    w2sigmpro numeric(4,3), --/U mag --/D W2 profile-fit photometric measurement uncertainty
    w2snr numeric(7,1), --/D W2 profile-fit measurement signal-to-noise ratio
    w2rchi2 real, --/D Reduced chi^2 of the W2 profile-fit photometry measurement
    w3mpro numeric(5,3), --/U mag --/D W3 magnitude measured with profile-fitting photometry
    w3sigmpro numeric(4,3), --/U mag --/D W3 profile-fit photometric measurement uncertainty
    w3snr numeric(7,1), --/D W3 profile-fit measurement signal-to-noise ratio
    w3rchi2 real, --/D Reduced chi^2 of the W3 profile-fit photometry measurement
    w4mpro numeric(5,3), --/U mag --/D W4 magnitude measured with profile-fitting photometry
    w4sigmpro numeric(4,3), --/U mag --/D W4 profile-fit photometric measurement uncertainty
    w4snr numeric(7,1), --/D W4 profile-fit measurement signal-to-noise ratio
    w4rchi2 real, --/D Reduced chi^2 of the W4 profile-fit photometry measurement
    rchi2 real, --/D Combined reduced chi^2 in all bands for the profile-fit photometry 
	--/D measurement
    nb integer, --/D Number of PSF components used simultaneously in the profile-fitting 
	--/D for this source
    na integer, --/D Active deblending flag
    w1sat numeric(4,3), --/D Fraction of all pixels within the profile-fitting area for W1 images 
	--/D that are flagged as saturated
    w2sat numeric(4,3), --/D Fraction of all pixels within the profile-fitting area for W2 images 
	--/D that are flagged as saturated
    w3sat numeric(4,3), --/D Fraction of all pixels within the profile-fitting area for W3 images 
	--/D that are flagged as saturated
    w4sat numeric(4,3), --/D Fraction of all pixels within the profile-fitting area for W4 images 
	--/D that are flagged as saturated
    satnum character(4), --/D Minimum sample at which saturation occurs in each band
    ra_pm numeric(10,7), --/U degrees --/D Right ascension at epoch MJD=55400.0 (2010.5589) from the 
	--/D profile-fitting measurement model that includes motion
    dec_pm numeric(9,7), --/U degrees --/D Declination at epoch MJD=55400.0 (2010.5589) from the profile-fitting 
	--/D measurement model that includes motion
    sigra_pm numeric(7,4), --/U arcsec --/D One-sigma uncertainty in right ascension from the profile-fitting 
	--/D measurement model that includes motion
    sigdec_pm numeric(7,4), --/U arcsec --/D One-sigma uncertainty in declination from the profile-fitting 
	--/D measurement model that includes motion
    sigradec_pm numeric(8,4), --/U arcsec --/D The co-sigma of the equatorial position uncertainties from the profile
	--/D -fitting measurement model that includes motion
    pmra integer, --/U mas/yr --/D Total apparent motion in right ascension estimated for this source
    sigpmra integer, --/U mas/yr --/D Uncertainty in the total right ascension motion estimation
    pmdec integer, --/U mas/yr --/D Total apparent motion in declination estimated for this source
    sigpmdec integer, --/U mas/yr --/D Uncertainty in the total declination motion estimation
    w1rchi2_pm real, --/D Reduced chi^2 of the W1 profile-fit photometry measurement including 
	--/D motion estimation
    w2rchi2_pm real, --/D Reduced chi^2 of the W2 profile-fit photometry measurement including 
	--/D motion estimation
    w3rchi2_pm real, --/D Reduced chi^2 of the W3 profile-fit photometry measurement including 
	--/D motion estimation
    w4rchi2_pm real, --/D Reduced chi^2 of the W4 profile-fit photometry measurement including 
	--/D motion estimation
    rchi2_pm real, --/D Combined reduced chi^2 in all bands for the profile-fit photometry 
	--/D measurement including motion estimation
    pmcode character(5), --/D string that encodes information about factors that impact the accuracy
	--/D  of the motion estimation
    cc_flags character(4), --/D Contamination and confusion flag
    rel character(1), --/D Small-separation, same-Tile detection flag
    ext_flg integer, --/D Extended source flag
    var_flg character(4), --/D Variability flag
    ph_qual character(4), --/D Photometric quality flag
    det_bit integer, --/D Bit-encoded integer indicating bands in which a source has a w#snr>2 
	--/D detection
    moon_lev character(4), --/D Scattered moonlight contamination flag
    w1nm integer, --/D number of individual 7.7s exposures where this source was detected 
	--/D with SNR>3 in the W1 profile-fit measurement
    w1m integer, --/D number of individual 7.7s W1 exposures on which a profile-fit 
	--/D measurement of this source was possible
    w2nm integer, --/D number of individual 7.7s exposures where this source was detected 
	--/D with SNR>3 in the W2 profile-fit measurement
    w2m integer, --/D number of individual 7.7s W2 exposures on which a profile-fit 
	--/D measurement of this source was possible
    w3nm integer, --/D number of individual 7.7s exposures where this source was detected 
	--/D with SNR>3 in the W3 profile-fit measurement
    w3m integer, --/D number of individual 7.7s W3 exposures on which a profile-fit 
	--/D measurement of this source was possible
    w4nm integer, --/D number of individual 7.7s exposures where this source was detected 
	--/D with SNR>3 in the W4 profile-fit measurement
    w4m integer, --/D number of individual 7.7s W4 exposures on which a profile-fit 
	--/D measurement of this source was possible
    w1cov numeric(6,3), --/D Mean pixel coverage in W1
    w2cov numeric(6,3), --/D Mean pixel coverage in W2
    w3cov numeric(6,3), --/D Mean pixel coverage in W3
    w4cov numeric(6,3), --/D Mean pixel coverage in W4
    w1cc_map integer, --/D Contamination and confusion map for this source in W1
    w1cc_map_str character(9), --/D Contamination and confusion string denoting all artifacts that may 
	--/D contaminate the W1 measurement of this source
    w2cc_map integer, --/D Contamination and confusion map for this source in W2
    w2cc_map_str character(9), --/D Contamination and confusion string denoting all artifacts that may 
	--/D contaminate the W2 measurement of this source
    w3cc_map integer, --/D Contamination and confusion map for this source in W3
    w3cc_map_str character(9), --/D Contamination and confusion string denoting all artifacts that may 
	--/D contaminate the W3 measurement of this source
    w4cc_map integer, --/D Contamination and confusion map for this source in W4
    w4cc_map_str character(9), --/D Contamination and confusion string denoting all artifacts that may 
	--/D contaminate the W4 measurement of this source
    best_use_cntr bigint, --/D Cntr identification value of the source extraction
    ngrp smallint, --/D Excess number of positionally associated duplicate resolution groups 
	--/D that included this source
    w1flux real, --/U dn --/D "Raw" W1 source flux measured in profile-fit photometry
    w1sigflux real, --/U dn --/D Uncertainty in the "raw" W1 source flux measurement in profile-fit 
	--/D photometry
    w1sky numeric(8,3), --/U dn --/D Average of the W1 sky background value
    w1sigsk numeric(6,3), --/U dn --/D Uncertainty in the W1 sky background value
    w1conf numeric(8,3), --/U dn --/D Estimated confusion noise in the W1 sky background annulus
    w2flux real, --/U dn --/D "Raw" W2 source flux measured in profile-fit photometry
    w2sigflux real, --/U dn --/D Uncertainty in the "raw" W2 source flux measurement in profile-fit 
	--/D photometry
    w2sky numeric(8,3), --/U dn --/D Average of the W2 sky background value
    w2sigsk numeric(6,3), --/U dn --/D Uncertainty in the W2 sky background value
    w2conf numeric(8,3), --/U dn --/D Estimated confusion noise in the W2 sky background annulus
    w3flux real, --/U dn --/D "Raw" W3 source flux measured in profile-fit photometry
    w3sigflux real, --/U dn --/D Uncertainty in the "raw" W3 source flux measurement in profile-fit 
	--/D photometry
    w3sky numeric(8,3), --/U dn --/D Average of the W3 sky background value
    w3sigsk numeric(6,3), --/U dn --/D Uncertainty in the W3 sky background value
    w3conf numeric(8,3), --/U dn --/D Estimated confusion noise in the W3 sky background annulus
    w4flux real, --/U dn --/D "Raw" W4 source flux measured in profile-fit photometry
    w4sigflux real, --/U dn --/D Uncertainty in the "raw" W4 source flux measurement in profile-fit 
	--/D photometry
    w4sky numeric(8,3), --/U dn --/D Average of the W4 sky background value
    w4sigsk numeric(6,3), --/U dn --/D Uncertainty in the W4 sky background value
    w4conf numeric(8,3), --/U dn --/D Estimated confusion noise in the W4 sky background annulus
    w1mag numeric(5,3), --/U mag --/D W1 "standard" aperture magnitude
    w1sigm numeric(4,3), --/U mag --/D Uncertainty in the W1 "standard" aperture magnitude
    w1flg integer, --/D W1 "standard" aperture measurement quality flag
    w1mcor numeric(4,3), --/U mag --/D W1 aperture curve-of-growth correction
    w2mag numeric(5,3), --/U mag --/D W2 "standard" aperture magnitude
    w2sigm numeric(4,3), --/D Uncertainty in the W2 "standard" aperture magnitude
    w2flg integer, --/D W2 "standard" aperture measurement quality flag
    w2mcor numeric(4,3), --/D W2 aperture curve-of-growth correction
    w3mag numeric(5,3), --/U mag --/D W3 "standard" aperture magnitude
    w3sigm numeric(4,3), --/U mag --/D Uncertainty in the W3 "standard" aperture magnitude
    w3flg integer, --/D W3 "standard" aperture measurement quality flag
    w3mcor numeric(4,3), --/U mag --/D W3 aperture curve-of-growth correction
    w4mag numeric(5,3), --/U mag --/D W4 "standard" aperture magnitude
    w4sigm numeric(4,3), --/U mag --/D Uncertainty in the W4 "standard" aperture magnitude
    w4flg integer, --/D W4 "standard" aperture measurement quality flag
    w4mcor numeric(4,3), --/U mag --/D W4 aperture curve-of-growth correction
    w1mag_1 numeric(5,3), --/U mag --/D W1 5.5" radius aperture magnitude
    w1sigm_1 numeric(4,3), --/U mag --/D Uncertainty in the W1 5.5" radius aperture magnitude
    w1flg_1 integer, --/D W1 5.5" radius aperture magnitude quality flag
    w2mag_1 numeric(5,3), --/U mag --/D W2 5.5" radius aperture magnitude
    w2sigm_1 numeric(4,3), --/U mag --/D Uncertainty in the W2 5.5" radius aperture magnitude
    w2flg_1 integer, --/D W2 5.5" radius aperture magnitude quality flag
    w3mag_1 numeric(5,3), --/U mag --/D W3 5.5" radius aperture magnitude
    w3sigm_1 numeric(4,3), --/U mag --/D Uncertainty in the W3 5.5" radius aperture magnitude
    w3flg_1 integer, --/D W3 5.5" radius aperture magnitude quality flag
    w4mag_1 numeric(5,3), --/U mag --/D W4 11.0" radius aperture magnitude
    w4sigm_1 numeric(4,3), --/U mag --/D Uncertainty in the W4 11.0" radius aperture magnitude
    w4flg_1 integer, --/D W4 11.0" radius aperture magnitude quality flag
    w1mag_2 numeric(5,3), --/U mag --/D W1 8.25" radius aperture magnitude
    w1sigm_2 numeric(4,3), --/U mag --/D Uncertainty in the W1 8.25" radius aperture magnitude
    w1flg_2 integer, --/D W1 8.25" radius aperture magnitude quality flag
    w2mag_2 numeric(5,3), --/U mag --/D W2 8.25" radius aperture magnitude
    w2sigm_2 numeric(4,3), --/U mag --/D Uncertainty in the W2 8.25" radius aperture magnitude
    w2flg_2 integer, --/D W2 8.25" radius aperture magnitude quality flag
    w3mag_2 numeric(5,3), --/U mag --/D W3 8.25" radius aperture magnitude
    w3sigm_2 numeric(4,3), --/U mag --/D Uncertainty in the W3 8.25" radius aperture magnitude
    w3flg_2 integer, --/D W3 8.25" radius aperture magnitude quality flag
    w4mag_2 numeric(5,3), --/U mag --/D W4 16.5" radius aperture magnitude
    w4sigm_2 numeric(4,3), --/U mag --/D Uncertainty in the W4 16.5" radius aperture magnitude
    w4flg_2 integer, --/D W4 16.5" radius aperture magnitude quality flag
    w1mag_3 numeric(5,3), --/U mag --/D W1 11.0" radius aperture magnitude
    w1sigm_3 numeric(4,3), --/U mag --/D Uncertainty in the W1 11.0" radius aperture magnitude
    w1flg_3 integer, --/D W1 11.0" radius aperture magnitude quality flag
    w2mag_3 numeric(5,3), --/U mag --/D W2 11.0" radius aperture magnitude
    w2sigm_3 numeric(4,3), --/U mag --/D Uncertainty in the W2 11.0" radius aperture magnitude
    w2flg_3 integer, --/D W2 11.0" radius aperture magnitude quality flag
    w3mag_3 numeric(5,3), --/U mag --/D W3 11.0" radius aperture magnitude
    w3sigm_3 numeric(4,3), --/U mag --/D Uncertainty in the W3 11.0" radius aperture magnitude
    w3flg_3 integer, --/D W3 11.0" radius aperture magnitude quality flag
    w4mag_3 numeric(5,3), --/U mag --/D W4 22.0" radius aperture magnitude
    w4sigm_3 numeric(4,3), --/U mag --/D Uncertainty in the W4 22.0" radius aperture magnitude
    w4flg_3 integer, --/D W4 22.0" radius aperture magnitude quality flag
    w1mag_4 numeric(5,3), --/U mag --/D W1 13.75" radius aperture magnitude
    w1sigm_4 numeric(4,3), --/U mag --/D Uncertainty in the W1 13.75" radius aperture magnitude
    w1flg_4 integer, --/D W1 13.75" radius aperture magnitude quality flag
    w2mag_4 numeric(5,3), --/U mag --/D W2 13.75" radius aperture magnitude
    w2sigm_4 numeric(4,3), --/U mag --/D Uncertainty in the W2 13.75" radius aperture magnitude
    w2flg_4 integer, --/D W2 13.75" radius aperture magnitude quality flag
    w3mag_4 numeric(5,3), --/U mag --/D W3 13.75" radius aperture magnitude
    w3sigm_4 numeric(4,3), --/U mag --/D Uncertainty in the W3 13.75" radius aperture magnitude
    w3flg_4 integer, --/D W3 13.75" radius aperture magnitude quality flag
    w4mag_4 numeric(5,3), --/U mag --/D W4 27.5" radius aperture magnitude
    w4sigm_4 numeric(4,3), --/U mag --/D Uncertainty in the W4 27.5" radius aperture magnitude
    w4flg_4 integer, --/D W4 27.5" radius aperture magnitude quality flag
    w1mag_5 numeric(5,3), --/U mag --/D W1 16.5" radius aperture magnitude
    w1sigm_5 numeric(4,3), --/U mag --/D Uncertainty in the W1 16.5" radius aperture magnitude
    w1flg_5 integer, --/D W1 16.5" radius aperture magnitude quality flag
    w2mag_5 numeric(5,3), --/U mag --/D W2 16.5" radius aperture magnitude
    w2sigm_5 numeric(4,3), --/U mag --/D Uncertainty in the W2 16.5" radius aperture magnitude
    w2flg_5 integer, --/D W2 16.5" radius aperture magnitude quality flag
    w3mag_5 numeric(5,3), --/U mag --/D W3 16.5" radius aperture magnitude
    w3sigm_5 numeric(4,3), --/U mag --/D Uncertainty in the W3 16.5" radius aperture magnitude
    w3flg_5 integer, --/D W3 16.5" radius aperture magnitude quality flag
    w4mag_5 numeric(5,3), --/U mag --/D W4 33.0" radius aperture magnitude
    w4sigm_5 numeric(4,3), --/U mag --/D Uncertainty in the W4 33.0" radius aperture magnitude
    w4flg_5 integer, --/D W4 33.0" radius aperture magnitude quality flag
    w1mag_6 numeric(5,3), --/U mag --/D W1 19.25" radius aperture magnitude
    w1sigm_6 numeric(4,3), --/U mag --/D Uncertainty in the W1 19.25" radius aperture magnitude
    w1flg_6 integer, --/D W1 19.25" radius aperture magnitude quality flag
    w2mag_6 numeric(5,3), --/U mag --/D W2 19.25" radius aperture magnitude
    w2sigm_6 numeric(4,3), --/U mag --/D Uncertainty in the W2 19.25" radius aperture magnitude
    w2flg_6 integer, --/D W2 19.25" radius aperture magnitude quality flag
    w3mag_6 numeric(5,3), --/U mag --/D W3 19.25" radius aperture magnitude
    w3sigm_6 numeric(4,3), --/U mag --/D Uncertainty in the W3 19.25" radius aperture magnitude
    w3flg_6 integer, --/D W3 19.25" radius aperture magnitude quality flag
    w4mag_6 numeric(5,3), --/U mag --/D W4 38.5" radius aperture magnitude
    w4sigm_6 numeric(4,3), --/U mag --/D Uncertainty in the W4 38.5" radius aperture magnitude
    w4flg_6 integer, --/D W4 38.5" radius aperture magnitude quality flag
    w1mag_7 numeric(5,3), --/U mag --/D W1 22.0" radius aperture magnitude
    w1sigm_7 numeric(4,3), --/U mag --/D Uncertainty in the W1 22.0" radius aperture magnitude
    w1flg_7 integer, --/D W1 22.0" radius aperture magnitude quality flag
    w2mag_7 numeric(5,3), --/U mag --/D W2 22.0" radius aperture magnitude
    w2sigm_7 numeric(4,3), --/U mag --/D Uncertainty in the W2 22.0" radius aperture magnitude
    w2flg_7 integer, --/D W2 22.0" radius aperture magnitude quality flag
    w3mag_7 numeric(5,3), --/U mag --/D W3 22.0" radius aperture magnitude
    w3sigm_7 numeric(4,3), --/U mag --/D Uncertainty in the W3 22.0" radius aperture magnitude
    w3flg_7 integer, --/D W3 22.0" radius aperture magnitude quality flag
    w4mag_7 numeric(5,3), --/U mag --/D W4 44.0" radius aperture magnitude
    w4sigm_7 numeric(4,3), --/U mag --/D Uncertainty in the W4 44.0" radius aperture magnitude
    w4flg_7 integer, --/D W4 44.0" radius aperture magnitude quality flag
    w1mag_8 numeric(5,3), --/U mag --/D W1 24.75" radius aperture magnitude
    w1sigm_8 numeric(4,3), --/U mag --/D Uncertainty in the W1 24.75" radius aperture magnitude
    w1flg_8 integer, --/D W1 24.75" radius aperture magnitude quality flag
    w2mag_8 numeric(5,3), --/U mag --/D W2 24.75" radius aperture magnitude
    w2sigm_8 numeric(4,3), --/U mag --/D Uncertainty in the W2 24.75" radius aperture magnitude
    w2flg_8 integer, --/D W3 24.75" radius aperture magnitude quality flag
    w3mag_8 numeric(5,3), --/U mag --/D W3 24.75" radius aperture magnitude
    w3sigm_8 numeric(4,3), --/U mag --/D Uncertainty in the W3 24.75" radius aperture magnitude
    w3flg_8 integer, --/D W3 24.75" radius aperture magnitude quality flag
    w4mag_8 numeric(5,3), --/U mag --/D W4 49.5" radius aperture magnitude
    w4sigm_8 numeric(4,3), --/U mag --/D Uncertainty in the W4 49.5" radius aperture magnitude
    w4flg_8 integer, --/D W4 49.5" radius aperture magnitude quality flag
    w1magp numeric(5,3), --/U mag --/D Magnitude computed from the inverse-variance-weighted mean of the 
	--/D profile-fit flux measurements on the w1m W1 frames covering this source
    w1sigp1 numeric(5,3), --/U mag --/D Standard deviation of the population of W1 fluxes measured on the w1m 
	--/D individual frames covering this source
    w1sigp2 numeric(5,3), --/U mag --/D w1sigp1/sqrt(w1m)
    w1k numeric(4,3), --/D Stetson K variability index computed using the W1 profile-fit fluxes 
	--/D measured on the single-exposure images
    w1ndf integer, --/D Number of degrees of freedom in the flux variability chi-square, W1
    w1mlq numeric(4,2), --/D Probability measure that the source is variable in W1 flux
    w1mjdmin numeric(13,8), --/D The earliest modified Julian Date (mJD) of the W1 single-exposures 
	--/D covering the source
    w1mjdmax numeric(13,8), --/D The latest modified Julian Date (mJD) of the W1 single-exposures 
	--/D covering the source
    w1mjdmean numeric(13,8), --/D The average modified Julian Date (mJD) of the W1 single-exposures 
	--/D covering the source
    w2magp numeric(5,3), --/U mag --/D Magnitude computed from the inverse-variance-weighted mean of the 
	--/D profile-fit flux measurements on the w2m W2 frames covering this source
    w2sigp1 numeric(5,3), --/U mag --/D Standard deviation of the population of W2 fluxes measured on the w2m 
	--/D individual frames covering this source
    w2sigp2 numeric(5,3), --/U mag --/D w2sigp1/sqrt(w2m)
    w2k numeric(4,3), --/D Stetson K variability index computed using the W2 profile-fit fluxes 
	--/D measured on the single-exposure images
    w2ndf integer, --/D Number of degrees of freedom in the flux variability chi-square, W2
    w2mlq numeric(4,2), --/D Probability measure that the source is variable in W2 flux
    w2mjdmin numeric(13,8), --/D The earliest modified Julian Date (mJD) of the W2 single-exposures 
	--/D covering the source
    w2mjdmax numeric(13,8), --/D The latest modified Julian Date (mJD) of the W2 single-exposures 
	--/D covering the source
    w2mjdmean numeric(13,8), --/D The average modified Julian Date (mJD) of the W2 single-exposures 
	--/D covering the source
    w3magp numeric(5,3), --/U mag --/D Magnitude computed from the inverse-variance-weighted mean of the 
	--/D profile-fit flux measurements on the w3m W3 frames covering this source
    w3sigp1 numeric(5,3), --/U mag --/D Standard deviation of the population of W3 fluxes measured on the w3m 
	--/D individual frames covering this source
    w3sigp2 numeric(5,3), --/U mag --/D w3sigp1/sqrt(w3m)
    w3k numeric(4,3), --/D Stetson K variability index computed using the W3 profile-fit fluxes m
	--/D easured on the single-exposure images
    w3ndf integer, --/D Number of degrees of freedom in the flux variability chi-square, W3
    w3mlq numeric(4,2), --/D Probability measure that the source is variable in W3 flux
    w3mjdmin numeric(13,8), --/D The earliest modified Julian Date (mJD) of the W3 single-exposures cov
	--/D ering the source
    w3mjdmax numeric(13,8), --/D The latest modified Julian Date (mJD) of the W3 single-exposures cover
	--/D ing the source
    w3mjdmean numeric(13,8), --/D The average modified Julian Date (mJD) of the W3 single-exposures cove
	--/D ring the source
    w4magp numeric(5,3), --/U mag --/D Magnitude computed from the inverse-variance-weighted mean of the prof
	--/D ile-fit flux measurements on the w4m W4 frames covering this source
    w4sigp1 numeric(5,3), --/U mag --/D Standard deviation of the population of W4 fluxes measured on the w4m 
	--/D individual frames covering this source
    w4sigp2 numeric(5,3), --/U mag --/D w4sigp1/sqrt(w4m)
    w4k numeric(4,3), --/D Stetson K variability index computed using the W4 profile-fit fluxes 
	--/D measured on the single-exposure images
    w4ndf integer, --/D Number of degrees of freedom in the flux variability chi-square, W4
    w4mlq numeric(4,2), --/D Probability measure that the source is variable in W4 flux
    w4mjdmin numeric(13,8), --/D The earliest modified Julian Date (mJD) of the W4 single-exposures 
	--/D covering the source
    w4mjdmax numeric(13,8), --/D The latest modified Julian Date (mJD) of the W4 single-exposures 
	--/D covering the source
    w4mjdmean numeric(13,8), --/D The average modified Julian Date (mJD) of the W4 single-exposures 
	--/D covering the source
    rho12 integer, --/U percent --/D The correlation coefficient between the W1 and W2 single-exposure flux
	--/D  measurements
    rho23 integer, --/U percent --/D The correlation coefficient between the W2 and W3 single-exposure flux
	--/D  measurements
    rho34 integer, --/U percent --/D The correlation coefficient between the W3 and W4 single-exposure flux
	--/D  measurements
    q12 integer, --/D Correlation significance between W1 and W2
    q23 integer, --/D Correlation significance between W2 and W3
    q34 integer, --/D Correlation significance between W3 and W4
    xscprox numeric(7,2), --/U arcsec --/D distance between the WISE source position and the position of a nearby
	--/D  2MASS XSC source
    w1rsemi numeric(7,2), --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W1
    w1ba numeric(3,2), --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W1
    w1pa numeric(5,2), --/U degrees --/D Position angle of the elliptical aperture major axis used to measure 
	--/D source in W1
    w1gmag numeric(5,3), --/U mag --/D W1 magnitude of source measured in the elliptical aperture described 
	--/D by w1rsemi, w1ba, and w1pa
    w1gerr numeric(4,3), --/U mag --/D Uncertainty in the W1 magnitude of source measured in elliptical aperture
    w1gflg integer, --/D W1 elliptical aperture measurement quality flag
    w2rsemi numeric(7,2), --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W2
    w2ba numeric(3,2), --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W2
    w2pa numeric(5,2), --/U degrees --/D Position angle of the elliptical aperture major axis used to measure 
	--/D source in W2
    w2gmag numeric(5,3), --/D W2 magnitude of source measured in the elliptical aperture described 
	--/D by w2rsemi, w2ba, and w2pa
    w2gerr numeric(4,3), --/U mag --/D Uncertainty in the W2 magnitude of source measured in elliptical aperture
    w2gflg integer, --/D W2 elliptical aperture measurement quality flag
    w3rsemi numeric(7,2), --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W3
    w3ba numeric(3,2), --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W3
    w3pa numeric(5,2), --/U degrees --/D Position angle of the elliptical aperture major axis used to measure 
	--/D source in W3
    w3gmag numeric(5,3), --/D W3 magnitude of source measured in the elliptical aperture described 
	--/D by w3rsemi, w3ba, and w3pa
    w3gerr numeric(4,3), --/U mag --/D Uncertainty in the W3 magnitude of source measured in elliptical aperture
    w3gflg integer, --/D W3 elliptical aperture measurement quality flag
    w4rsemi numeric(7,2), --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W4
    w4ba numeric(3,2), --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W4
    w4pa numeric(5,2), --/U degrees --/D Position angle of the elliptical aperture major axis used to measure 
	--/D source in W4
    w4gmag numeric(5,3), --/D W4 magnitude of source measured in the elliptical aperture described 
	--/D by w4rsemi, w4ba, and w4pa
    w4gerr numeric(4,3), --/U mag --/D Uncertainty in the W4 magnitude of source measured in elliptical aperture
    w4gflg integer, --/D W4 elliptical aperture measurement quality flag
    tmass_key integer, --/D Unique identifier of the closest source in the 2MASS Point Source Catalog
    r_2mass numeric(5,3), --/U arcsec --/D Distance separating the positions of the WISE source and associated 
	--/D 2MASS PSC source within 3"
    pa_2mass numeric(4,1), --/U degrees --/D Position angle of the vector from the WISE source to the associated 
	--/D 2MASS PSC source
    n_2mass integer, --/D The number of 2MASS PSC entries found within a 3" radius of the WISE source position
    j_m_2mass numeric(5,3), --/U mag --/D 2MASS J-band magnitude or magnitude upper limit of the associated 
	--/D 2MASS PSC source
    j_msig_2mass numeric(4,3), --/U mag --/D 2MASS J-band corrected photometric uncertainty of the associated 2MASS
	--/D  PSC source
    h_m_2mass numeric(5,3), --/U mag --/D 2MASS H-band magnitude or magnitude upper limit of the associated 
	--/D 2MASS PSC source
    h_msig_2mass numeric(4,3), --/U mag --/D 2MASS H-band corrected photometric uncertainty of the associated 2MASS
	--/D  PSC source
    k_m_2mass numeric(5,3), --/U mag --/D 2MASS Ks-band magnitude or magnitude upper limit of the associated 
	--/D 2MASS PSC source
    k_msig_2mass numeric(4,3), --/U mag --/D 2MASS Ks-band corrected photometric uncertainty of the associated 
	--/D 2MASS PSC source
    x numeric(17,16), --/D Unit sphere position x value
    y numeric(17,16), --/D Unit sphere position y value
    z numeric(17,16), --/D Unit sphere position z value
    spt_ind integer, --/D Level 7 HTM spatial index key
    htm20 bigint, --/D Level 20 HTM spatial index key
    [w1mpro_w2mpro] AS ([w1mpro]-[w2mpro]) PERSISTED, --/D difference of w1mpro and w2mpro
	htmid bigint --/D 20-level deep Hierarchical Triangular Mesh ID

)
GO
--


--
-- Name: mos_best_brightest; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_best_brightest')
	DROP TABLE mos_best_brightest
GO
--
EXEC spSetDefaultFileGroup 'mos_best_brightest'
GO
CREATE TABLE mos_best_brightest (

----------------------------------------------------------------------
--/H Catalog from Kevin Schlaufman for the selection of bright 
--/H metal-poor stars.
----------------------------------------------------------------------
--/T From the method of Schlaufman and Casey (2014):
--/T https://ui.adsabs.harvard.edu/abs/2014ApJ...797...13S/abstract.
--/T WISE values from WHICH CATALOG, 2MASS values from 2MASS point
--/T source catalog.
----------------------------------------------------------------------
    designation character varying(19), --/D 2MASS Designation
    ra_1 double precision, --/U degrees --/D right ascension from the AllWISE catalog
    dec_1 double precision, --/U degrees --/D declination from the AllWISE catalog
    glon double precision, --/U degrees --/D Galactic longitude from AllWISE catalog
    glat double precision, --/U degrees --/D Galactic latitude from the AllWISE catalog
    w1mpro real, --/U mag --/D AllWISE W1-band magnitude measured with profile-fitting photometry
    w2mpro real, --/U mag --/D AllWISE W2-band magnitude measured with profile-fitting photometry
    w3mpro real, --/U mag --/D AllWISE W3-band magnitude measured with profile-fitting photometry
    w4mpro character varying(6), --/U mag --/D AllWISE W4-band magnitude measured with profile-fitting photometry
    pmra integer, --/U mas/yr --/D Gaia DR2 proper motion
    pmdec integer, --/U mas/yr --/D Gaia DR2 proper motion
    j_m_2mass real, --/U mag --/D 2MASS J=band magnitude
    h_m_2mass real, --/U mag --/D 2MASS magnitude
    k_m_2mass real, --/U mag --/D 2MASS magnitude
    ra_2 double precision, --/U degrees --/D Right ascension from the 2MASS catalog
    raerr double precision, --/U degrees --/D Uncertainty in right ascension from the 2MASS catalog
    dec_2 double precision, --/U degrees --/D Declination from the 2MASS catalog
    decerr double precision, --/U degrees --/D Uncertainty in declination from the 2MASS catalog
    nobs integer, --/D Number of observed nights from the APASS catalog
    mobs integer, --/D Number of images for this field from the APASS catalog
    vjmag real, --/U mag --/D APASS V_J magnitude
    bjmag real, --/U mag --/D APASS B_J magnitude
    gmag real, --/U mag --/D APASS Sloan g' magnitude
    rmag real, --/U mag --/D APASS Sloan r' magnitude
    imag real, --/U mag --/D APASS Sloan i' magnitude
    evjmag real, --/U mag --/D Uncertainty in APASS V_J  magnitude
    ebjmag real, --/U mag --/D Uncertainty in APASS B_J magnitude
    egmag real, --/U mag --/D Uncertainty in APASS Sloan g' magnitude
    ermag real, --/U mag --/D Uncertainty in APASS Sloan r' magnitude
    eimag real, --/U mag --/D Uncertainty in APASS Sloan i' magnitude
    name integer, --/D APASS field name
    separation double precision, --/U arcsec --/D Separation between AllWISE object and APASS object
    ebv real, --/U mag --/D SFD dustmap E(B-V)
    version integer, --/D version 2 is high priiority, version 1 is low priority (see Schlaufman
	--/D  + Casey 2014 for definitions)
    original_ext_source_id character varying(16), --/D 2MASS designation removing the "." from the coordinates and getting 
	--/D rid of "J" at the front
    cntr bigint NOT NULL --/D Internal Identifier
)
GO
--


--
-- Name: mos_bhm_csc_v2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_bhm_csc_v2')
	DROP TABLE mos_bhm_csc_v2
GO
--
EXEC spSetDefaultFileGroup 'mos_bhm_csc_v2'
GO
CREATE TABLE mos_bhm_csc_v2 (

----------------------------------------------------------------------
--/H CSC2 X-ray sources that have been matched
----------------------------------------------------------------------
--/T separately to PanSTARRS-1, Gaia DR2, and 2MASS catalogs, using the programs NWAY <br>
--/T (Johannes Buchner; see: Salvato 2018, MN, 473, 4937) and Xmatch (Arnold Rots;
--/T see: <br>
--/T https://cxc.cfa.harvard.edu/csc/csc_crossmatches.html). Both are based on the
--/T Bayesian spatial <br>
--/T cross-matching algorithm developed by Budavari & Szalay (2008, ApJ 679, 301),
--/T but Xmatch <br>
--/T has the added capability of taking source extent and/or PSF into account. <br>
--/T Created March 2021 by Paul Green, Dong-Woo Kim, Arnold Rots and the CXC CatSci
--/T group.
----------------------------------------------------------------------
    cxoid text, --/D CSC2 Chandra ID
    xra double precision, --/U deg --/D RA of X-ray source from CSC2
    xdec double precision, --/U deg --/D Dec of X-ray source from CSC2
    pri smallint, --/D Priority (based on X-ray S/N)
    ocat text, --/D optical catalog code (P for PS1, G for Gaia)
    oid bigint, --/D object ID from optical catalog
    ora double precision, --/U deg --/D right ascension (2000) from optical catalog
    odec double precision, --/U deg --/D declination (2000) from optical catalog
    omag real, --/U mag --/D optical magnitude from optical catalog
    omatchtype smallint, --/D X-ray/optical match type (1-4 definite/likely/multiple opt, multiple X)
    irid text, --/D object ID from 2MASS
    ra2m double precision, --/U deg --/D right ascension (2000) from 2MASS
    dec2m double precision, --/U deg --/D declination (2000) from 2MASS
    hmag real, --/U mag --/D H mag from 2MASS
    irmatchtype smallint, --/D X-ray/IR match type (1-4 definite/likely/multiple opt, multiple X)
    lgal double precision, --/U deg --/D Galactic longitude (from X-ray position)
    bgal double precision, --/U deg --/D Galactic latitude (from X-ray position)
    logfx real, --/D log10 of X-ray cgs flux in xband
    xband text, --/D X-ray bandpass for logfx, priority b,m,s,h,w
    xsn double precision, --/D X-ray S/N
    xflags integer, --/D concatenated X-ray source flags: extended,confused,piledup,variable,
	--/D streak,saturated
    designation2m text, --/D 2MASS identifier (designation) derived from irid
    idg2 bigint, --/D Gaia DR2 source_id (derived from ocat, oid)
    idps bigint, --/D Pan-STARRS1 Object identifier (derived here from ocat+oid) - equivalent to ObjID 
	--/D in MAST database (https://outerspace.stsci.edu/display/PANSTARRS/PS1+Object+Identifiers),
	--/D and to our panstarrs1.extid_hi_lo
    pk bigint NOT NULL --/D primary key of the database table
)
GO
--


--
-- Name: mos_bhm_efeds_veto; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_bhm_efeds_veto')
	DROP TABLE mos_bhm_efeds_veto
GO
--
EXEC spSetDefaultFileGroup 'mos_bhm_efeds_veto'
GO
CREATE TABLE mos_bhm_efeds_veto (

----------------------------------------------------------------------
--/H The BHM-SPIDERS eFEDS veto catalogue.
----------------------------------------------------------------------
--/T A minimalist catalogue of 6300 science targets in the SPIDERS eFEDS field that
--/T received SDSS-IV spectroscopy during the March2020 SPIDERS observing run (and
--/T hence are not in SDSS-SpecObj-DR16). Many of these spectra have very low SNR and
--/T so we will want to observe them again, but we will take account of this in the
--/T Carton code. This is a subset (in both rows and columns) of the
--/T spAll-v5_13_1.fits idlspec2d pipeline product. The original data model for that
--/T file is here:
--/T https://data.sdss.org/datamodel/files/BOSS_SPECTRO_REDUX/RUN2D/spAll.html
----------------------------------------------------------------------
    programname character varying(5), --/D program name within a given survey
    chunk character varying(7), --/D Name of tiling chunk
    platesn2 real, --/D Overall (S/N)^2 measure for plate; minimum of all 4 cameras
    plate integer, --/D Plate ID
    tile integer, --/D Tile ID
    mjd integer, --/U days --/D MJD of (last) observation
    fiberid integer, --/D Fiber ID (1-1000)
    run2d character varying(7), --/D idlspec 2D reduction version
    run1d character varying(7), --/D idlspec 1D reduction version
    plug_ra double precision, --/U deg --/D Object RA (drilled fiber position at expected epoch of observation)
    plug_dec double precision, --/U deg --/D Object Dec (drilled fiber position at expected epoch of observation)
    z_err real, --/D Redshift error based upon fit to chi^2 minimum; negative for invalid fit
    rchi2 real, --/D Reduced chi^2 for best fit
    dof integer, --/D Degrees of freedom for best fit
    rchi2diff real, --/D Difference in reduced chi^2 of best solution to 2nd best solution
    wavemin real, --/U Angstroms --/D Minimum observed (vacuum) wavelength for this object
    wavemax real, --/U Angstroms --/D Maximum observed (vacuum) wavelength for this object
    wcoverage real, --/D Amount of wavelength coverage in log-10(Angstroms)
    zwarning integer, --/D A flag bitmask set for bad data or redshift fits
    sn_median_all real, --/D Median S/N for all good pixels in all filters
    anyandmask integer, --/D Mask bits which are set if any pixels for an object's ANDMASK have 
	--/D that bit set
    anyormask integer, --/D Mask bits which are set if any pixels for an object's ORMASK have that
	--/D  bit set
    pk bigint NOT NULL --/D primary key in the database table
)
GO
--


--
-- Name: mos_bhm_rm_v0_2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_bhm_rm_v0_2')
	DROP TABLE mos_bhm_rm_v0_2
GO
--
EXEC spSetDefaultFileGroup 'mos_bhm_rm_v0_2'
GO
CREATE TABLE mos_bhm_rm_v0_2 (

----------------------------------------------------------------------
--/H Parent sample for the RM project, used to select confirmed and
--/H candidate quasar targets for the BHM-RM Program in SDSS-V.
----------------------------------------------------------------------
--/T For more details please see Yang and Shen, (2022,
--/T https://ui.adsabs.harvard.edu/abs/2022arXiv220608989Y/abstract).
--/T This table contains all photometric objects detected in the COSMOS, SDSS-RM,
--/T XMM-LSS, CDFS, S-CVZ, and ELAIS-S1 fields., within a circular area of 10
--/T degree^2 from the field center. <br>
--/T Field center: Name     RA          DEC <br>
--/T               XMM-LSS  02:22:50.00    -04:45:00.0 <br>
--/T               CDFS     03:30:35.60    -28:06:00.0 <br>
--/T               EDFS     04:04:57.84    -48:25:22.8 <br>
--/T               ELAIS-S1 00:37:48.00    -44:00:00.0 <br>
--/T               COSMOS   10:00:00.00    +02:12:00.0 <br>
--/T               SDSS-RM  14:14:49.00    +53:05:00.0 <br>
--/T               S-CVZ    06:00:00.00    -66:33:38.0 <br>
--/T The table includes information from the following survey data releases: <br>
--/T DES: Dark Energy Survey, Y6, Y6A1_COADD_OBJECT_SUMMARY <br>
--/T PS1: Pan-STARRS, DR1, StackObjectThin <br>
--/T NSC: NOAO Source Catalog, DR1, nsc_dr1.object <br>
--/T SDSS: Sloan Digital Sky Survey, DR14, PhotoObjAll <br>
--/T Gaia: DR2, gaia_dr2.gaia_source <br>
--/T unWISE: DR1 <br>
--/T Near-infrared: LAS: UKIDSS Large Area Surveys (DR11), <br>
--/T                UHS: UKIRT Hemisphere Survey (DR1), <br>
--/T                VHS: VISTA Hemisphere Survey (DR6), <br>
--/T                Viking: VISTA Kilo-Degree Infrared Galaxy Survey (DR5), <br>
--/T                VIDEO: VISTA Deep Extragalactic Observations Survey (DR5), <br>
--/T                VMC: VISTA Magellanic Cloud Survey (DR4) <br>
--/T Values are set to -9.0 or -9 if null.
----------------------------------------------------------------------
    field_name character varying(8), --/D One of COSMOS, SDSS-RM, XMM-LSS, CDFS, S-CVZ, or ELAIS-S1
    ra double precision, --/U deg --/D Fiducial Right Ascension (J2000)
    [dec] double precision, --/U deg --/D Fiducial Declination (J2000)
    distance double precision, --/U deg --/D Angular distance from the field center
    pos_ref character varying(4), --/D Fiducial coordinates reference, priority: Gaia > DES > PS1 > NSC
    ebv double precision, --/D Galactic E(B−V) reddening from Schlegel et al. (1998)
    des integer, --/D A flag set to 1 if in DES photometric catalog
    coadd_object_id bigint, --/D DES coadd object ID
    ra_des double precision, --/U deg --/D DES Right Ascension (J2000)
    dec_des double precision, --/U deg --/D DES Declination (J2000)
    extended_coadd integer, --/D DES type classifier: 0 (high-confidence stars), 1 (likely stars), 2 
	--/D (mostly galaxies), and 3 (high-confidence galaxies)
    separation_des double precision, --/U arcsec --/D Angular distance between DES position and the fiducial coordinates
    ps1 integer, --/D A flag set to 1 if in PS1 photometric catalog
    objid_ps1 bigint, --/D PS1 unique object identifier
    ra_ps1 double precision, --/U deg --/D PS1 right ascension from i filter stack detection
    dec_ps1 double precision, --/U deg --/D PS1 declination from i filter stack detection
    class_ps1 double precision, --/D PS1 source classification = iPsfMag - iKronMag
    separation_ps1 double precision, --/U arcsec --/D Angular distance between PS1 position and the fiducial coordinates
    nsc integer, --/D A flag set to 1 if in  photometric catalog
    id_nsc bigint, --/D NSC unique object identifier
    ra_nsc double precision, --/U deg --/D Right Ascension (J2000)
    dec_nsc double precision, --/U deg --/D Declination (J2000)
    class_star double precision, --/D NSC Star/Galaxy classifier
    flags_nsc integer, --/D NSC SExtractor flag value
    separation_nsc double precision, --/U arcsec --/D Angular distance between NSC position and the fiducial coordinates
    sdss integer, --/D A flag set to 1 if in SDSS photometric catalog
    objid_sdss bigint, --/D Unique SDSS identifier
    ra_sdss double precision, --/U deg --/D Right Ascension (J2000)
    dec_sdss double precision, --/U deg --/D Declination (J2000)
    type_sdss integer, --/D SDSS type classifier (star 6, galaxy 3, etc.)
    clean_sdss integer, --/D SDSS clean photometry flag (1=clean, 0=unclean)
    separation_sdss double precision, --/U arcsec --/D Angular distance between SDSS position and the fiducial coordinates
    gaia integer, --/D A flag set to 1 if in Gaia DR2 photometric catalog
    source_id_gaia bigint, --/D Gaia DR2 unique source identifier
    mg double precision, --/U mag --/D Gaia g-band magnitude (phot_g_mean_mag in Gaia catalog, Vega)
    parallax double precision, --/U mas --/D Parallax, Angle,
    parallax_error double precision, --/U mas --/D Standard error of parallax, Angle,
    plxsig double precision, --/D Parallax significance defined as |PARALLAX/PARALLAX_ERROR|
    pmra double precision, --/U mas/year --/D Proper motion in RA direction, Angular Velocity,
    pmra_error double precision, --/U mas/year --/D Standard error of proper motion in RA direction, Angular Velocity,
    pmdec double precision, --/U mas/year --/D Proper motion in DEC direction, Angular Velocity,
    pmdec_error double precision, --/U mas/year --/D Standard error of proper motion in DEC direction, Angular Velocity,
    pmsig double precision, --/D Proper motion significance defined as (pmra^2+pmdec^2)/sqrt(pmra^2*pmra_error^2
	--/D  + pmdec^2*pmdec_error^2)
    unwise integer, --/D A flag set to 1 if in unWISE photometric catalog
    objid_unwise character varying(16), --/D unWISE unique object id
    ra_unwise double precision, --/U deg --/D unWISE Right Ascension (J2000)
    dec_unwise double precision, --/U deg --/D unWISE Declination (J2000)
    separation_unwise double precision, --/U arcsec --/D Angular distance between unWISE position and the fiducial coordinates
    near_ir integer, --/D A flag set to 1 if in NIR photometric catalog
    survey_ir character varying(6), --/D Near-IR survey name: LAS, UHS, VHS, Viking, VMC, VIDEO
    sourceid_ir bigint, --/D NIR source identifier
    ra_ir double precision, --/U deg --/D NIR Right Ascension (J2000)
    dec_ir double precision, --/U deg --/D NIR Declination (J2000)
    separation_ir double precision, --/U arcsec --/D Angular distance between NIR position and the fiducial coordinates
    optical_survey character varying(4), --/D Optical survey used in Skewt-QSO, e.g., DES, PS1, Gaia, NSC
    mi double precision, --/U mag --/D i-band PSF magnitude (galactic extinction not corrected)
    cal_skewt_qso integer, --/D A flag indicates whether Skewt-QSO is calculated.(Set to 1 when 
	--/D Nband_Optical_use > 2.)
    nband_optical_use integer, --/D Number of optical bands used in Skewt-QSQ.
    use_unwise integer, --/D Set to 1 when unWISE photometry is used in Skewt-QSO calculation.
    use_nir integer, --/D Set to 1 when NIR photometry is usedin Skewt-QSO calculation.
    photo_combination character varying(17), --/D The photometric data combinations used in Skewt-QSO, for example, 
	--/D "DECam-YJHK-unWISE" - DECam/PS1 includes grizy bands; unWISE incldes unWISE W1 and W2 bands; and Gaia 
	--/D includes Gaia bp, g, and rp bands
    log_qso double precision, --/D The (natural) logarithmic probability of a target fitting to QSO colors convolved 
	--/D with a QLF. Set to -323 if log_QSO<-323 (close to the lower limit of double-precision data).
    log_star double precision, --/D The logarithmic probability of a target fitting to star colors multiplied 
	--/D by star number counts based on a stellar simulation. Set to -323 if log_Star<-323.
    log_galaxy double precision, --/D The logarithmic probability of a target fitting to galaxy colors convolved 
	--/D with a GLF. Set to -323 if  log_Galaxy<-323.
    p_qso double precision, --/D QSO probability from Skewt-QSO. P_QSO = exp(log_qso)/(exp(log_qso) + 
	--/D exp(log_star) + exp(log_galaxy))
    p_star real, --/D Star probability from Skewt-QSO.
    p_galaxy double precision, --/D Galaxy probability from Skewt-QSO.
    class_skewt_qso character varying(6), --/D Classification based on the highest probability from Skewt-QSO, 
	--/D QSO/Star/Galaxy
    skewt_qso integer, --/D flag indicating whether the object is a QSO (same as class_skewt_qso, 
	--/D except additionally requiring log_QSO>-10). (P_QSO>P_Star & P_QSO>P_galaxy & log_QSO>-10)
    p_qso_prior double precision, --/D QSO probability with prior probabilities from additional info, such as
	--/D  separation (between optical survey and unWISE), morphology, variability, and/or proper motion. 
	--/D (Note: *_Prior are generally not populated in this version, except for the "S-CVZ" field, 
	--/D where we take into account the separation between optical surveys and unWISE.)
    p_star_prior real, --/D Star probability with prior probabilities.
    p_galaxy_prior double precision, --/D Galaxy probability with prior probabilities.
    class_skewt_qso_prior character varying(6), --/D Classification based on Skewt-QSO with prior probabilities 
	--/D described above.
    skewt_qso_prior integer, --/D flag indicating whether the object is QSO based on Skewt-QSO with 
	--/D prior probabilities described above.
    photoz_qso double precision, --/D Photometric redshift of QSO from Skewt-QSO
    photoz_qso_lower double precision, --/D Lower limit of photoz_QSO
    photoz_qso_upper double precision, --/D Upper limit of photoz_QSO
    prob_photoz_qso double precision, --/D The total probability of z located between photoz_QSO_lower and 
	--/D photoz_QSO_upper (assuming it is QSO).
    photoz_galaxy double precision, --/D Photometric redshift of Galaxy from Skewt-QSO (fitting to galaxy colors).
    photoz_galaxy_lower double precision, --/D Lower limit of photoz_Galaxy.
    photoz_galaxy_upper double precision, --/D Upper limit of photoz_Galaxy.
    pqso_xdqso double precision, --/D QSO probability from the public XDQSO catalog
    photoz_xdqso double precision, --/D Photometric redshift of QSO from the public XDQSO catalog
    prob_rf_gaia_unwise double precision, --/D AGN probability from the Gaia-unWISE AGN catalog
    photoz_gaia_unwise double precision, --/D Photometric redshift from the Gaia-unWISE AGN catalog
    des_var_sn_max double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS in grizy bands
	--/D  (DES).
    ps1_var_sn_max double precision, --/D The maximum signal-to-noise ratio of the measured intrinsic RMS over 5
	--/D  bands (PS1).
    spec_q integer, --/D flag indicating if the object was spectroscopically confirmed as QSO 
	--/D from earlier surveys.
    spec_strmask character varying(6), --/D string format of spec_bitmask, e.g., '000001'.
    spec_bitmask bigint, --/D bitmask - bit 0: SDSS-DR14Q, bit 1: SDSS-DR7Q, bit 2: OzDES-DR1Q, 
	--/D bit 3: SDSS-RM_Q, bit 4: COSMOS_Q, bit 5: Milliquas_QA. (Note: Milliquas_QA=1 are objects 
	--/D spectroscopically classified as broad-line QSO/AGN in the Million Quasars (MILLIQUAS) catalog.)
    specz double precision, --/D spectroscopic redshift from multiple surveys. Priority: SDSS-RM_Q/COSM
	--/D OS_Q > SDSS-DR14Q > SDSS-DR7Q > OzDES-DR1Q > Milliquas_QA
    specz_ref character varying(16), --/D Reference of specz.
    photo_q integer, --/D flag indicating if the object was selected as QSO in public photometric quasar catalogs.
    photo_strmask character varying(3), --/D string format of photo_bitmask
    photo_bitmask bigint, --/D bit mask, bit 0: XDQSO catalog, bit 1: Gaia-unWISE AGN catalog; bit 2:
	--/D  Milliquas_photo: photometric quasar candidates in the Milliquas catalog
    photoz double precision, --/D Photometric redshift from public photometric quasar catalogs. Priority
	--/D : XDQSO > Gaia-unWISE > Milliquas_photo
    pqso_photo double precision, --/D QSO probability from public photometric quasar catalogs.
    photoz_ref character varying(16), --/D photoz reference.
    pk bigint NOT NULL, --/D primary key for the database table
    psfmag_des_g double precision, --/U mag --/D DES PSF photometry
    psfmag_des_r double precision, --/U mag --/D DES PSF photometry
    psfmag_des_i double precision, --/U mag --/D DES PSF photometry
    psfmag_des_z double precision, --/U mag --/D DES PSF photometry
    psfmag_des_y double precision, --/U mag --/D DES PSF photometry
    psfmagerr_des_g double precision, --/U mag --/D DES PSF photometry error
    psfmagerr_des_r double precision, --/U mag --/D DES PSF photometry error
    psfmagerr_des_i double precision, --/U mag --/D DES PSF photometry error
    psfmagerr_des_z double precision, --/U mag --/D DES PSF photometry error
    psfmagerr_des_y double precision, --/U mag --/D DES PSF photometry error
    mag_auto_des_g double precision, --/U mag --/D DES auto photometry
    mag_auto_des_r double precision, --/U mag --/D DES auto photometry
    mag_auto_des_i double precision, --/U mag --/D DES auto photometry
    mag_auto_des_z double precision, --/U mag --/D DES auto photometry
    mag_auto_des_y double precision, --/U mag --/D DES auto photometry
    magerr_auto_des_g double precision, --/U mag --/D DES auto photometry error
    magerr_auto_des_r double precision, --/U mag --/D DES auto photometry error
    magerr_auto_des_i double precision, --/U mag --/D DES auto photometry error
    magerr_auto_des_z double precision, --/U mag --/D DES auto photometry error
    magerr_auto_des_y double precision, --/U mag --/D DES auto photometry error
    imaflags_iso_g integer, --/D DES flag identifying sources with missing/flagged pixels, considering 
	--/D all single epoch images
    imaflags_iso_r integer, --/D DES flag identifying sources with missing/flagged pixels, considering 
	--/D all single epoch images
    imaflags_iso_i integer, --/D DES flag identifying sources with missing/flagged pixels, considering 
	--/D all single epoch images
    imaflags_iso_z integer, --/D DES flag identifying sources with missing/flagged pixels, considering 
	--/D all single epoch images
    imaflags_iso_y integer, --/D DES flag identifying sources with missing/flagged pixels, considering 
	--/D all single epoch images
    psfmag_ps1_g double precision, --/U mag --/D PS1 PSF magnitude
    psfmag_ps1_r double precision, --/U mag --/D PS1 PSF magnitude
    psfmag_ps1_i double precision, --/U mag --/D PS1 PSF magnitude
    psfmag_ps1_z double precision, --/U mag --/D PS1 PSF magnitude
    psfmag_ps1_y double precision, --/U mag --/D PS1 PSF magnitude
    psfmagerr_ps1_g double precision, --/U mag --/D PS1 PSF magnitude error
    psfmagerr_ps1_r double precision, --/U mag --/D PS1 PSF magnitude error
    psfmagerr_ps1_i double precision, --/U mag --/D PS1 PSF magnitude error
    psfmagerr_ps1_z double precision, --/U mag --/D PS1 PSF magnitude error
    psfmagerr_ps1_y double precision, --/U mag --/D PS1 PSF magnitude error
    kronmag_ps1_g double precision, --/U mag --/D PS1 Kron magnitude
    kronmag_ps1_r double precision, --/U mag --/D PS1 Kron magnitude
    kronmag_ps1_i double precision, --/U mag --/D PS1 Kron magnitude
    kronmag_ps1_z double precision, --/U mag --/D PS1 Kron magnitude
    kronmag_ps1_y double precision, --/U mag --/D PS1 Kron magnitude
    kronmagerr_ps1_g double precision, --/U mag --/D PS1 Kron magnitude error
    kronmagerr_ps1_r double precision, --/U mag --/D PS1 Kron magnitude error
    kronmagerr_ps1_i double precision, --/U mag --/D PS1 Kron magnitude error
    kronmagerr_ps1_z double precision, --/U mag --/D PS1 Kron magnitude error
    kronmagerr_ps1_y double precision, --/U mag --/D PS1 Kron magnitude error
    infoflag2_g integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_r integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_i integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_z integer, --/D PS1 flags, values listed in DetectionFlags2
    infoflag2_y integer, --/D PS1 flags, values listed in DetectionFlags2
    mag_nsc_g double precision, --/U mag --/D Weighted-average magnitude
    mag_nsc_r double precision, --/U mag --/D Weighted-average magnitude
    mag_nsc_i double precision, --/U mag --/D Weighted-average magnitude
    mag_nsc_z double precision, --/U mag --/D Weighted-average magnitude
    mag_nsc_y double precision, --/U mag --/D Weighted-average magnitude
    magerr_nsc_g double precision, --/U mag --/D Weighted-average NSC magnitude
    magerr_nsc_r double precision, --/U mag --/D Weighted-average NSC magnitude
    magerr_nsc_i double precision, --/U mag --/D Weighted-average NSC magnitude
    magerr_nsc_z double precision, --/U mag --/D Weighted-average NSC magnitude
    magerr_nsc_y double precision, --/U mag --/D Weighted-average NSC magnitude
    psfmag_sdss_u double precision, --/U mag --/D SDSS PSF magnitude
    psfmag_sdss_g double precision, --/U mag --/D SDSS PSF magnitude
    psfmag_sdss_r double precision, --/U mag --/D SDSS PSF magnitude
    psfmag_sdss_i double precision, --/U mag --/D SDSS PSF magnitude
    psfmag_sdss_z double precision, --/U mag --/D SDSS PSF magnitude
    psfmagerr_sdss_u double precision, --/U mag --/D SDSS PSF magnitude error
    psfmagerr_sdss_g double precision, --/U mag --/D SDSS PSF magnitude error
    psfmagerr_sdss_r double precision, --/U mag --/D SDSS PSF magnitude error
    psfmagerr_sdss_i double precision, --/U mag --/D SDSS PSF magnitude error
    psfmagerr_sdss_z double precision, --/U mag --/D SDSS PSF magnitude error
    modelmag_sdss_u double precision, --/U mag --/D SDSS Model magnitude
    modelmag_sdss_g double precision, --/U mag --/D SDSS Model magnitude
    modelmag_sdss_r double precision, --/U mag --/D SDSS Model magnitude
    modelmag_sdss_i double precision, --/U mag --/D SDSS Model magnitude
    modelmag_sdss_z double precision, --/U mag --/D SDSS Model magnitude
    modelmagerr_sdss_u double precision, --/U mag --/D SDSS Model magnitude error
    modelmagerr_sdss_g double precision, --/U mag --/D SDSS Model magnitude error
    modelmagerr_sdss_r double precision, --/U mag --/D SDSS Model magnitude error
    modelmagerr_sdss_i double precision, --/U mag --/D SDSS Model magnitude error
    modelmagerr_sdss_z double precision, --/U mag --/D SDSS Model magnitude error
    mag_gaia_g double precision, --/U mag --/D Gaia DR2 G-band magnitude, Vega
    mag_gaia_bp double precision, --/U mag --/D Gaia DR2 BP-band magnitude, Vega
    mag_gaia_rp double precision, --/U mag --/D Gaia DR2 RP-band magnitude, Vega
    magerr_gaia_g double precision, --/U mag --/D Gaia DR2 G-band magnitude error, Vega
    magerr_gaia_bp double precision, --/U mag --/D Gaia DR2 BP-band magnitude error, Vega
    magerr_gaia_rp double precision, --/U mag --/D Gaia DR2 RP-band magnitude error, Vega
    mag_unwise_w1 double precision, --/U mag --/D unWISE (Vega) magnitude,
    mag_unwise_w2 double precision, --/U mag --/D unWISE (Vega) magnitude,
    magerr_unwise_w1 double precision, --/U mag --/D unWISE (Vega) magnitude error,
    magerr_unwise_w2 double precision, --/U mag --/D unWISE (Vega) magnitude error,
    flags_unwise_w1 integer, --/D unWISE Coadd Flags
    flags_unwise_w2 integer, --/D unWISE Coadd Flags
    mag_ir_y double precision, --/U mag --/D (Vega) magnitude in near-IR,
    mag_ir_j double precision, --/U mag --/D (Vega) magnitude in near-IR,
    mag_ir_h double precision, --/U mag --/D (Vega) magnitude in near-IR,
    mag_ir_k double precision, --/U mag --/D (Vega) magnitude in near-IR,
    magerr_ir_y double precision, --/U mag --/D magnitude error in near-IR
    magerr_ir_j double precision, --/U mag --/D magnitude error in near-IR
    magerr_ir_h double precision, --/U mag --/D magnitude error in near-IR
    magerr_ir_k double precision, --/U mag --/D magnitude error in near-IR
    des_var_nepoch_g integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_r integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_i integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_z integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_nepoch_y integer, --/D Number of DES single-epoch photometric datapoints per band
    des_var_status_g integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_r integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_i integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_z integer, --/D Status of intrinsic variability calculation from DES
    des_var_status_y integer, --/D Status of intrinsic variability calculation from DES
    des_var_rms_g double precision, --/U mag --/D Intrinsic RMS from DES
    des_var_rms_r double precision, --/U mag --/D Intrinsic RMS from DES
    des_var_rms_i double precision, --/U mag --/D Intrinsic RMS from DES
    des_var_rms_z double precision, --/U mag --/D Intrinsic RMS from DES
    des_var_rms_y double precision, --/U mag --/D Intrinsic RMS from DES
    des_var_sigrms_g double precision, --/U mag --/D Error of intrinsic RMS from DES
    des_var_sigrms_r double precision, --/U mag --/D Error of intrinsic RMS from DES
    des_var_sigrms_i double precision, --/U mag --/D Error of intrinsic RMS from DES
    des_var_sigrms_z double precision, --/U mag --/D Error of intrinsic RMS from DES
    des_var_sigrms_y double precision, --/U mag --/D Error of intrinsic RMS from DES
    des_var_sn_g double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_r double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_i double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_z double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    des_var_sn_y double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from DES
    ps1_var_nepoch_g integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_r integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_i integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_z integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_nepoch_y integer, --/D Number of PS1 single-epoch photometric data points
    ps1_var_status_g integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_r integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_i integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_z integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_status_y integer, --/D Status of intrinsic variability calculation from PS1
    ps1_var_rms_g double precision, --/U mag --/D Intrinsic RMS from PS1
    ps1_var_rms_r double precision, --/U mag --/D Intrinsic RMS from PS1
    ps1_var_rms_i double precision, --/U mag --/D Intrinsic RMS from PS1
    ps1_var_rms_z double precision, --/U mag --/D Intrinsic RMS from PS1
    ps1_var_rms_y double precision, --/U mag --/D Intrinsic RMS from PS1
    ps1_var_sigrms_g double precision, --/U mag --/D Error of intrinsic RMS from PS1
    ps1_var_sigrms_r double precision, --/U mag --/D Error of intrinsic RMS from PS1
    ps1_var_sigrms_i double precision, --/U mag --/D Error of intrinsic RMS from PS1
    ps1_var_sigrms_z double precision, --/U mag --/D Error of intrinsic RMS from PS1
    ps1_var_sigrms_y double precision, --/U mag --/D Error of intrinsic RMS from PS1
    ps1_var_sn_g double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_r double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_i double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_z double precision, --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
    ps1_var_sn_y double precision --/D The signal-to-noise ratio of the measured intrinsic RMS from PS1
)
GO
--


--
-- Name: mos_cadence; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_cadence')
	DROP TABLE mos_cadence
GO
--
EXEC spSetDefaultFileGroup 'mos_cadence'
GO
CREATE TABLE mos_cadence (

----------------------------------------------------------------------
--/H This table contains information on the field cadence.
----------------------------------------------------------------------
--/T Cadences define the time between series of exposures (one "epoch")
--/T on a field, and the observing conditions, e.g., skybrightness, for
--/T each epoch.
----------------------------------------------------------------------
    label text, --/D Descriptive name for the cadence with a version
    nepochs integer, --/D Number of epochs in the cadence
    pk bigint NOT NULL, --/D Primary key
    label_root text, --/D Descriptive name, typically {bright/dark}_{nepochs}x{nexps}
    label_version text, --/D Version; cadences are added in versioned batches
    max_skybrightness real, --/D The maximum skybrightness for all epochs in this cadence
    nexp_total integer --/D The total number of exposures planned for this cadence
)
GO
--


--
-- Name: mos_cadence_epoch; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_cadence_epoch')
	DROP TABLE mos_cadence_epoch
GO
--
EXEC spSetDefaultFileGroup 'mos_cadence_epoch'
GO
CREATE TABLE mos_cadence_epoch (

----------------------------------------------------------------------
--/H Constraints for a single epoch within a cadence.
----------------------------------------------------------------------
    label text NOT NULL, --/D Descriptive name for the cadence with a version
    nepochs integer, --/D Number of epochs in the cadence
    cadence_pk bigint, --/D Primary key of the cadence this epoch belongs to
    epoch integer NOT NULL, --/D Which epoch is this in the cadence (0-indexed)
    delta double precision, --/U days --/D Nominal (goal) time since previous epoch
    skybrightness real, --/D Maximum allowed skybrightness, i.e. moon illumination (0.0 to 1.0)
    delta_max real, --/U days --/D Maximum allowed time since previous epoch
    delta_min real, --/U days --/D Minimum allowed time since previous epoch
    nexp integer, --/D Number of exposures in this epoch
    max_length real, --/D Maximum allowed length of epoch, i.e. time between first and last exposure
    obsmode_pk text --/D Reference to the observing parameters (airmass, moon seperation, etc.)
)
GO
--


--
-- Name: mos_carton; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_carton')
	DROP TABLE mos_carton
GO
--
EXEC spSetDefaultFileGroup 'mos_carton'
GO
CREATE TABLE mos_carton (

----------------------------------------------------------------------
--/H The table contains the list of cartons along with the target
--/H selection plan that generated them.
----------------------------------------------------------------------
    carton text, --/D The name of the carton.
    carton_pk integer NOT NULL, --/D The primary key. A sequential identifier.
    mapper_pk smallint, --/D The primary key of the mapper leading this carton. See mos_mapper.
    category_pk smallint, --/D The primary key of the category in the mos_category table.
    target_selection_planname text --/D The target selection plan version for which this carton was run.
)
GO
--



--
-- Name: mos_carton_to_target; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_carton_to_target')
	DROP TABLE mos_carton_to_target
GO
--
EXEC spSetDefaultFileGroup 'mos_carton_to_target'
GO
CREATE TABLE mos_carton_to_target (

----------------------------------------------------------------------
--/H The table stores the targets assigned to a given carton along with
--/H information about the instrument that will observe that target,
--/H and offseting data.
----------------------------------------------------------------------
    carton_to_target_pk integer NOT NULL, --/D The primary key. A sequential identifier.
    lambda_eff real, --/U angstrom --/D The effective wavelength at which the object will be observed
    carton_pk smallint, --/D The primary key of the carton in the mos_carton table.
    target_pk bigint, --/D The primary key of the target in the mos_target table.
    cadence_pk smallint, --/D The primary key of the cadence in the mos_cadence table.
    priority integer, --/D The target priority. Used for scheduling.
    value real, --/D An internal metric of the target value used for scheduling.
    instrument_pk integer, --/D The primary key of the instrument in the mos_instrument table.
    delta_ra double precision, --/D The RA offset for fibre positioning, in arcsec.
    delta_dec double precision, --/D The Dec offset for fibre positioning, in arcsec.
    inertial bit --/D Whether this is an inertial target (no proper motion will be applied).
)
GO
--


--
-- Name: mos_cataclysmic_variables; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_cataclysmic_variables')
	DROP TABLE mos_cataclysmic_variables
GO
--
EXEC spSetDefaultFileGroup 'mos_cataclysmic_variables'
GO
CREATE TABLE mos_cataclysmic_variables (

----------------------------------------------------------------------
--/H Gaia DR2 parameters for AAVSO cataclysmic variables.
----------------------------------------------------------------------
--/T From cataclysmic (explosive and novalike) variables (N, NA, NB,
--/T NC, NL, NR, SN, SNI, SNII, UG, UGSS, UGSU, UGZ, ZAND). VSX
--/T catalog downloaded in summer 2019 and then manually pruned.
----------------------------------------------------------------------
    ref_id bigint NOT NULL, --/D same as source_id
    solution_id bigint, --/D ID that identifies the version of all the subsystems that were used in
	--/D  the generation of the data as well as the input data used
    designation text, --/D Unique source designation across all Gaia data releases
    source_id bigint, --/D Unique source identifier within a particular Gaia data release
    random_index integer, --/D Random index which can be used to select smaller subsets of the data
    ref_epoch real, --/U Julian Years --/D Time
    ra double precision, --/U degrees --/D Right Ascension
    ra_error double precision, --/U degrees --/D Standard error of the right ascension
    [dec] double precision, --/U degrees --/D Declination
    dec_error double precision, --/U degrees --/D Standard error of the declination
    parallax double precision, --/U mas --/D Absolute stellar parallax of the source at the reference epoch
    parallax_error double precision, --/U mas --/D Standard error of parallax
    parallax_over_error double precision, --/D Parallax divided by its error
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension direction
    pmra_error double precision, --/U mas/yr --/D Standard error of proper motion in right ascension direction
    pmdec double precision, --/U mas/yr --/D Proper motion in declination direction
    pmdec_error double precision, --/U mas/yr --/D Standard error of proper motion in declination direction
    ra_dec_corr double precision, --/D Correlation between right ascension and declination
    ra_parallax_corr double precision, --/D Correlation between right ascension and parallax
    ra_pmra_corr double precision, --/D Correlation between right ascension and proper motion in right ascension
    ra_pmdec_corr double precision, --/D Correlation between right ascension and proper motion in declination
    dec_parallax_corr double precision, --/D Correlation between declination and parallax
    dec_pmra_corr double precision, --/D Correlation between declination and proper motion in right ascension
    dec_pmdec_corr double precision, --/D Correlation between declination and proper motion in declination
    parallax_pmra_corr double precision, --/D Correlation between parallax and proper motion in right ascension
    parallax_pmdec_corr double precision, --/D Correlation between parallax and proper motion in declination
    pmra_pmdec_corr double precision, --/D Correlation between proper motion in right ascension and proper motion
	--/D  in declination
    astrometric_n_obs_al smallint, --/D Total number of observations AL
    astrometric_n_obs_ac smallint, --/D Total number of observations AC
    astrometric_n_good_obs_al smallint, --/D Number of good observations AL
    astrometric_n_bad_obs_al smallint, --/D Number of bad observations AL
    astrometric_gof_al double precision, --/D Goodness of fit statistic of model wrt along-scan observations
    astrometric_chi2_al double precision, --/D AL chi-square value
    astrometric_excess_noise double precision, --/U mas --/D Excess noise of the source
    astrometric_excess_noise_sig double precision, --/D Significance of excess noise
    astrometric_params_solved smallint, --/D Which parameters have been solved for
    astrometric_primary_flag bit, --/D Flag indicating if this source was used as a primary source (true) or 
	--/D secondary source (false)
    astrometric_weight_al double precision, --/U mas^-2 --/D Mean astrometric weight of the source
    astrometric_pseudo_colour double precision, --/U um^-1 --/D Astrometrically determined pseudocolour of the source
    astrometric_pseudo_colour_error double precision, --/U um^-1 --/D Standard error of the pseudocolour of the source
    mean_varpi_factor_al double precision, --/D Mean Parallax factor AL
    astrometric_matched_observations smallint, --/D number of FOV transits matched to this source
    visibility_periods_used smallint, --/D Number of visibility periods used in the astrometric solution
    astrometric_sigma5d_max double precision, --/U mas --/D Longest semi-major axis of the 5-d error ellipsoid
    frame_rotator_object_type smallint, --/D Type of the source mainly used for frame rotation
    matched_observations smallint, --/D Total number of FOV transits matched to this source
    duplicated_source bit, --/D Source with duplicate sources
    phot_g_n_obs smallint, --/D Number of observations contributing to G photometry
    phot_g_mean_flux double precision, --/U e-/s --/D G-band mean flux
    phot_g_mean_flux_error double precision, --/U e-/s --/D Error on G-band mean flux
    phot_g_mean_flux_over_error double precision, --/D G-band mean flux divided by its error
    phot_g_mean_mag double precision, --/U mag --/D G-band mean magnitude
    phot_bp_n_obs smallint, --/D Number of observations contributing to BP photometry
    phot_bp_mean_flux double precision, --/U e-/s --/D Integrated BP mean flux
    phot_bp_mean_flux_error double precision, --/U e-/s --/D Error on the integrated BP mean flux
    phot_bp_mean_flux_over_error double precision, --/D Integrated BP mean flux divided by its error
    phot_bp_mean_mag double precision, --/U mag --/D Integrated BP mean magnitude
    phot_rp_n_obs smallint, --/D Number of observations contributing to RP photometry
    phot_rp_mean_flux double precision, --/U e-/s --/D Integrated RP mean flux
    phot_rp_mean_flux_error double precision, --/U e-/s --/D Error on the integrated RP mean flux
    phot_rp_mean_flux_over_error double precision, --/D Integrated RP mean flux divided by its error
    phot_rp_mean_mag double precision, --/U mag --/D Integrated RP mean magnitude
    phot_bp_rp_excess_factor double precision, --/D BP/RP excess factor
    phot_proc_mode smallint, --/D Photometry processing mode
    bp_rp double precision, --/U mag --/D BP - RP color
    bp_g double precision, --/U mag --/D BP - G color
    g_rp double precision, --/U mag --/D G - RP color
    radial_velocity double precision, --/U km/s --/D Radial velocity
    radial_velocity_error double precision, --/U km/s --/D Radial velocity error
    rv_nb_transits smallint, --/D Number of transits used to compute radial velocity
    rv_template_teff real, --/U K --/D Teff of the template used to compute radial velocity
    rv_template_logg real, --/U log cgs --/D logg of the template used to compute radial velocity
    rv_template_fe_h real, --/U dex --/D Fe/H of the template used to compute radial velocity
    phot_variable_flag text, --/D Photometric variability flag
    l double precision, --/U degrees --/D Galactic longitude
    b double precision, --/U degrees --/D Galactic latitude
    ecl_lon double precision, --/U degrees --/D Ecliptic longitude
    ecl_lat double precision, --/U degrees --/D Ecliptic latitude
    priam_flags integer, --/D Flags for the Apsis-Priam results
    teff_val double precision, --/U K --/D Stellar effective temperature
    teff_percentile_lower double precision, --/U K --/D Teff_val lower uncertainty
    teff_percentile_upper double precision, --/U K --/D Teff_val upper uncertainty
    a_g_val real, --/U mag --/D Line-of-sight extinction in the G band
    a_g_percentile_lower real, --/U mag --/D A_g_val lower uncertainty
    a_g_percentile_upper real, --/U mag --/D A_g_val upper uncertainty
    e_bp_min_rp_val real, --/U mag --/D Line-of-sight reddening E(BP-RP)
    e_bp_min_rp_percentile_lower real, --/U mag --/D e_bp_min_rp_val lower uncertainty
    e_bp_min_rp_percentile_upper real, --/U mag --/D e_bp_min_rp_val upper uncertainty
    flame_flags integer, --/D Flags for the Apsis-FLAME results
    radius_val double precision, --/U Solar Radius --/D Stellar radius
    radius_percentile_lower double precision, --/U Solar Radius --/D Radius_val lower uncertainty
    radius_percentile_upper double precision, --/U Solar Radius --/D Radius_val upper uncertainty
    lum_val double precision, --/U Solar Luminosity --/D stellar luminosity
    lum_percentile_lower double precision, --/U Solar Luminosity --/D lum_val lower uncertainty
    lum_percentile_upper double precision --/U Solar Luminosity --/D lum_val upper uncertainty
)
GO
--


--
-- Name: mos_catalog; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog')
	DROP TABLE mos_catalog
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog'
GO
CREATE TABLE mos_catalog (

----------------------------------------------------------------------
--/H The table stores the results of the cross-match used for DR18 targeting.
----------------------------------------------------------------------
--/T All entries in this table are expected to be unique physical objects
--/T drawn from one or more parent catalogues. The mos_catalog_to_tables 
--/T provide the relationship between mos_catalog objects and their parent
--/T catalogue counterparts.
----------------------------------------------------------------------
    catalogid bigint NOT NULL, --/D The SDSS identifier for a unique object in this cross-match run.
    iauname text, --/D The IAU-style name. Not used.
    ra double precision, --/U degrees --/D The right ascension of the target in ICRS coordinates for J2015.5. 
	--/D Taken from the lead parent catalogue
    [dec] double precision, --/U degrees --/D The declination of the target in ICRS coordinates for J2015.5. 
	--/D Taken from the lead parent catalogue
    pmra real, --/U mas/yr --/D The proper motion of the target in right ascension. Taken from the 
	--/D lead parent catalogue. This is a true angle (i.e., the cos(dec) factor has been applied)
    pmdec real, --/U mas/yr --/D The proper motion of the target in declination. Taken from the lead 
	--/D parent catalogue
    parallax real, --/U arcsec --/D The parallax of the target. Taken from the lead parent catalogue
    lead text, --/D The name of the parent catalogue from which this target was selected 
	--/D and whose data was used to determine its astrometric position.
    version_id integer --/D The internal version for the cross-match.
)
GO
--



--
-- Name: mos_catalog_to_allwise; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_allwise')
	DROP TABLE mos_catalog_to_allwise
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_allwise'
GO
CREATE TABLE mos_catalog_to_allwise (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos_catalog
--/H targets and the mos_allwise table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_allwise table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_allwise.
)
GO
--



--
-- Name: mos_catalog_to_bhm_efeds_veto; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_bhm_efeds_veto')
	DROP TABLE mos_catalog_to_bhm_efeds_veto
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_bhm_efeds_veto'
GO
CREATE TABLE mos_catalog_to_bhm_efeds_veto (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos_catalog
--/H targets and the mos_bhm_efeds_veto table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_bhm_efeds_veto table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_bhm_efeds_veto.
)
GO
--


--
-- Name: mos_catalog_to_bhm_rm_v0_2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_bhm_rm_v0_2')
	DROP TABLE mos_catalog_to_bhm_rm_v0_2
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_bhm_rm_v0_2'
GO
CREATE TABLE mos_catalog_to_bhm_rm_v0_2 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos_catalog
--/H targets and the mos_rm_v0_2 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_rm_v0_2 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_rm_v0_2.
)
GO
--



--
-- Name: mos_catalog_to_catwise2020; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_catwise2020')
	DROP TABLE mos_catalog_to_catwise2020
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_catwise2020'
GO
CREATE TABLE mos_catalog_to_catwise2020 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos_catalog
--/H targets and the mos_catwise2020 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id character varying(25), --/D The primary key identifier in the mos_catwise2020 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_catwise2020.
)
GO
--



--
-- Name: mos_catalog_to_glimpse; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_glimpse')
	DROP TABLE mos_catalog_to_glimpse
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_glimpse'
GO
CREATE TABLE mos_catalog_to_glimpse (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos_catalog
--/H targets and the mos_glimpse table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_glimpse table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_glimpse.
)
GO
--



--
-- Name: mos_catalog_to_guvcat; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_guvcat')
	DROP TABLE mos_catalog_to_guvcat
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_guvcat'
GO
CREATE TABLE mos_catalog_to_guvcat (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos_catalog
--/H targets and the mos_guvcat table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_guvcat table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_guvcat.
)
GO
--



--
-- Name: mos_catalog_to_legacy_survey_dr8; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_legacy_survey_dr8')
	DROP TABLE mos_catalog_to_legacy_survey_dr8
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_legacy_survey_dr8'
GO
CREATE TABLE mos_catalog_to_legacy_survey_dr8 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_legacy_survey_dr8 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_legacy_survey_dr8 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_legacy_survey_dr8.
)
GO
--


--
-- Name: mos_catalog_to_panstarrs1; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_panstarrs1')
	DROP TABLE mos_catalog_to_panstarrs1
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_panstarrs1'
GO
CREATE TABLE mos_catalog_to_panstarrs1 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_panstarrs1 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_panstarrs1 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_panstarrs1.
)
GO
--


--
-- Name: mos_catalog_to_sdss_dr13_photoobj_primary; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_sdss_dr13_photoobj_primary')
	DROP TABLE mos_catalog_to_sdss_dr13_photoobj_primary
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_sdss_dr13_photoobj_primary'
GO
CREATE TABLE mos_catalog_to_sdss_dr13_photoobj_primary (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_sdss_dr13_photoobj_primary table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_sdss_dr13_photoobj_primary table
	--/D .
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_sdss_dr13_photoobj_primary.
)
GO
--


--
-- Name: mos_catalog_to_sdss_dr16_specobj; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_sdss_dr16_specobj')
	DROP TABLE mos_catalog_to_sdss_dr16_specobj
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_sdss_dr16_specobj'
GO
CREATE TABLE mos_catalog_to_sdss_dr16_specobj (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_sdss_dr16_specobj table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id numeric(20,0), --/D The primary key identifier in the mos_sdss_dr16_specobj table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_sdss_dr16_specobj.
)
GO
--


--
-- Name: mos_catalog_to_skies_v2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_skies_v2')
	DROP TABLE mos_catalog_to_skies_v2
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_skies_v2'
GO
CREATE TABLE mos_catalog_to_skies_v2 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_skies_v2 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_skies_v2 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_skies_v2.
)
GO
--


--
-- Name: mos_catalog_to_skymapper_dr2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_skymapper_dr2')
	DROP TABLE mos_catalog_to_skymapper_dr2
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_skymapper_dr2'
GO
CREATE TABLE mos_catalog_to_skymapper_dr2 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_skymapper_dr2 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_skymapper_dr2 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_skymapper_dr2.
)
GO
--


--
-- Name: mos_catalog_to_supercosmos; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_supercosmos')
	DROP TABLE mos_catalog_to_supercosmos
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_supercosmos'
GO
CREATE TABLE mos_catalog_to_supercosmos (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_supercosmos table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_supercosmos table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_supercosmos.
)
GO
--


--
-- Name: mos_catalog_to_tic_v8; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_tic_v8')
	DROP TABLE mos_catalog_to_tic_v8
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_tic_v8'
GO
CREATE TABLE mos_catalog_to_tic_v8 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_tic_v8 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_tic_v8 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_tic_v8.
)
GO
--


--
-- Name: mos_catalog_to_tycho2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_tycho2')
	DROP TABLE mos_catalog_to_tycho2
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_tycho2'
GO
CREATE TABLE mos_catalog_to_tycho2 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_tycho2 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id text, --/D The primary key identifier in the mos_tycho2 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_tycho2.
)
GO
--


--
-- Name: mos_catalog_to_uvotssc1; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_uvotssc1')
	DROP TABLE mos_catalog_to_uvotssc1
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_uvotssc1'
GO
CREATE TABLE mos_catalog_to_uvotssc1 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_uvotssc1 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_uvotssc1 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_uvotssc1.
)
GO
--


--
-- Name: mos_catalog_to_xmm_om_suss_4_1; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalog_to_xmm_om_suss_4_1')
	DROP TABLE mos_catalog_to_xmm_om_suss_4_1
GO
--
EXEC spSetDefaultFileGroup 'mos_catalog_to_xmm_om_suss_4_1'
GO
CREATE TABLE mos_catalog_to_xmm_om_suss_4_1 (

----------------------------------------------------------------------
--/H The table contains the cross-match between the mos-catalog
--/H targets and the mos_xmm_om_suss_4_1 table.
----------------------------------------------------------------------
    catalogid bigint, --/D The catalogid identifier in the mos_catalog table.
    target_id bigint, --/D The primary key identifier in the mos_xmm_om_suss_4_1 table.
    version_id smallint, --/D The internal version for the cross-match.
    distance double precision, --/D The distance between the catalog and target coordinates if best=F.
    best bit --/D Whether this is considered the best match between the catalog entry 
	--/D and mos_xmm_om_suss_4_1.
)
GO
--


--
-- Name: mos_catalogdb_version; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catalogdb_version')
	DROP TABLE mos_catalogdb_version
GO
--
EXEC spSetDefaultFileGroup 'mos_catalogdb_version'
GO
CREATE TABLE mos_catalogdb_version (

    id integer NOT NULL,
    planname text,
    tag text
)
GO
--


--
-- Name: mos_category; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_category')
	DROP TABLE mos_category
GO
--
EXEC spSetDefaultFileGroup 'mos_category'
GO
CREATE TABLE mos_category (

----------------------------------------------------------------------
--/H This table indicates the category of a carton (science, standards, etc.)
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    [label] text --/D The name of the category.
)
GO
--


--
-- Name: mos_catwise2020; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_catwise2020')
	DROP TABLE mos_catwise2020
GO
--
EXEC spSetDefaultFileGroup 'mos_catwise2020'
GO
CREATE TABLE mos_catwise2020 (

----------------------------------------------------------------------
--/H The CatWISE2020 Catalog
--/H (https://ui.adsabs.harvard.edu/abs/2021ApJS..253....8M/abstract) 
----------------------------------------------------------------------
--/T See https://irsa.ipac.caltech.edu/data/WISE/CatWISE/gator_docs/catwise_colDescriptions.html
--/T for more detailed column descriptions
----------------------------------------------------------------------
    source_name character(21), --/D source hexagesimal designation
    source_id character(25) NOT NULL, --/D tile name + processing code + wphot index
    ra double precision, --/U deg --/D right ascension (J2000); (note uncorrected systematic in CatWISE2020)
    [dec] double precision, --/U deg --/D declination (J2000); (note uncorrected systematic in CatWISE2020)
    sigra real, --/U arcsec --/D uncertainty in RA
    sigdec real, --/U arcsec --/D uncertainty in DEC
    sigradec real, --/U arcsec --/D cross-term of RA and Dec uncertainties
    wx real, --/U pix --/D x pixel value
    wy real, --/U pix --/D y pixel value
    w1sky real, --/U 'dn' --/D frame sky background value, band 1
    w1sigsk real, --/U 'dn' --/D frame sky background value uncertainty, band 1
    w1conf real, --/U 'dn' --/D frame sky confusion based on the uncertainty images, band 1
    w2sky real, --/U 'dn' --/D frame sky background value, band 2
    w2sigsk real, --/U 'dn' --/D frame sky background value uncertainty, band 2
    w2conf real, --/U 'dn' --/D frame sky confusion based on the uncertainty images, band 2
    w1fitr real, --/U arcsec --/D fitting radius for W1; see note
    w2fitr real, --/U arcsec --/D fitting radius for W2; see note
    w1snr real, --/D instrumental profile-fit photometry S/N ratio, band 1
    w2snr real, --/D instrumental profile-fit photometry S/N ratio, band 2
    w1flux real, --/U 'dn' --/D profile-fit photometry raw flux, band 1
    w1sigflux real, --/U 'dn' --/D profile-fit photometry raw flux uncertainty, band 1
    w2flux real, --/U 'db' --/D profile-fit photometry raw flux, band 2
    w2sigflux real, --/U 'dn' --/D profile-fit photometry raw flux uncertainty, band 2
    w1mpro real, --/U mag --/D instrumental profile-fit photometry magnitude, band 1
    w1sigmpro real, --/U mag --/D instrumental profile-fit photometry flux uncertainty in mag units, 
	--/D band 1
    w1rchi2 real, --/D instrumental profile-fit photometry reduced chi^2, band 1
    w2mpro real, --/U mag --/D instrumental profile-fit photometry magnitude, band 2
    w2sigmpro real, --/U mag --/D instrumental profile-fit photometry flux uncertainty in mag units, 
	--/D band 2
    w2rchi2 real, --/D instrumental profile-fit photometry reduced chi^2, band 2
    rchi2 real, --/D instrumental profile-fit photometry reduced chi squared, total
    nb integer, --/D number of blend components used in each fit
    na integer, --/D number of actively deblended components
    w1sat real, --/D fraction of pixels affected by saturation, band 1
    w2sat real, --/D fraction of pixels affected by saturation, band 2
    w1mag real, --/U mag --/D instrumental standard aperture (8.25") mag w/ aperture correction 
	--/D applied, band 1
    w1sigm real, --/U mag --/D instrumental standard aperture mag uncertainty, band 1
    w1flg integer, --/D instrumental standard aperture flag, band 1
    w1cov real, --/D mean coverage depth, band 1
    w2mag real, --/U mag --/D instrumental standard aperture (8.25") mag w/ aperture correction 
	--/D applied, band 2
    w2sigm real, --/U mag --/D instrumental standard aperture mag uncertainty, band 2
    w2flg integer, --/D instrumental standard aperture flag, band 2
    w2cov real, --/D mean coverage depth, band 2
    w1mag_1 real, --/U mag --/D aperture 1 (5.50") instrumental aperture mag, band 1
    w1sigm_1 real, --/U mag --/D aperture 1 instrumental aperture mag uncertainty, band 1
    w1flg_1 integer, --/D aperture 1 instrumental aperture flag, band 1
    w2mag_1 real, --/U mag --/D aperture 1 (5.50") instrumental aperture mag, band 2
    w2sigm_1 real, --/U mag --/D aperture 1 instrumental aperture mag uncertainty, band 2
    w2flg_1 integer, --/D aperture 1 instrumental aperture flag, band 2
    w1mag_2 real, --/U mag --/D aperture 2 (8.25") instrumental aperture mag, band 1
    w1sigm_2 real, --/U mag --/D aperture 2 instrumental aperture mag uncertainty, band 1
    w1flg_2 integer, --/D aperture 2 instrumental aperture flag, band 1
    w2mag_2 real, --/U mag --/D aperture 2 (8.25") instrumental aperture mag, band 2
    w2sigm_2 real, --/U mag --/D aperture 2 instrumental aperture mag uncertainty, band 2
    w2flg_2 integer, --/D aperture 2 instrumental aperture flag, band 2
    w1mag_3 real, --/U mag --/D aperture 3 (11.00") instrumental aperture mag, band 1
    w1sigm_3 real, --/U mag --/D aperture 3 instrumental aperture mag uncertainty, band 1
    w1flg_3 integer, --/D aperture 3 instrumental aperture flag, band 1
    w2mag_3 real, --/U mag --/D aperture 3 (11.00") instrumental aperture mag, band 2
    w2sigm_3 real, --/U mag --/D aperture 3 instrumental aperture mag uncertainty, band 2
    w2flg_3 integer, --/D aperture 3 instrumental aperture flag, band 2
    w1mag_4 real, --/U mag --/D aperture 4 (13.75") instrumental aperture mag, band 1
    w1sigm_4 real, --/U mag --/D aperture 4 instrumental aperture mag uncertainty, band 1
    w1flg_4 integer, --/D aperture 4 instrumental aperture flag, band 1
    w2mag_4 real, --/U mag --/D aperture 4 (13.75") instrumental aperture mag, band 2
    w2sigm_4 real, --/U mag --/D aperture 4 instrumental aperture mag uncertainty, band 2
    w2flg_4 integer, --/D aperture 4 instrumental aperture flag, band 2
    w1mag_5 real, --/U mag --/D aperture 5 (16.50") instrumental aperture mag, band 1
    w1sigm_5 real, --/U mag --/D aperture 5 instrumental aperture mag uncertainty, band 1
    w1flg_5 integer, --/D aperture 5 instrumental aperture flag, band 1
    w2mag_5 real, --/U mag --/D aperture 5 (16.50") instrumental aperture mag, band 2
    w2sigm_5 real, --/U mag --/D aperture 5 instrumental aperture mag uncertainty, band 2
    w2flg_5 integer, --/D aperture 5 instrumental aperture flag, band 2
    w1mag_6 real, --/U mag --/D aperture 6 (19.25") instrumental aperture mag, band 1
    w1sigm_6 real, --/U mag --/D aperture 6 instrumental aperture mag uncertainty, band 1
    w1flg_6 integer, --/D aperture 6 instrumental aperture flag, band 1
    w2mag_6 real, --/U mag --/D aperture 6 (19.25") instrumental aperture mag, band 2
    w2sigm_6 real, --/U mag --/D aperture 6 instrumental aperture mag uncertainty, band 2
    w2flg_6 integer, --/D aperture 6 instrumental aperture flag, band 2
    w1mag_7 real, --/U mag --/D aperture 7 (22.00") instrumental aperture mag, band 1
    w1sigm_7 real, --/U mag --/D aperture 7 instrumental aperture mag uncertainty, band 1
    w1flg_7 integer, --/D aperture 7 instrumental aperture flag, band 1
    w2mag_7 real, --/U mag --/D aperture 7 (22.00") instrumental aperture mag, band 2
    w2sigm_7 real, --/U mag --/D aperture 7 instrumental aperture mag uncertainty, band 2
    w2flg_7 integer, --/D aperture 7 instrumental aperture flag, band 2
    w1mag_8 real, --/U mag --/D aperture 8 (24.75") instrumental aperture mag, band 1
    w1sigm_8 real, --/U mag --/D aperture 8 instrumental aperture mag uncertainty, band 1
    w1flg_8 integer, --/D aperture 8 instrumental aperture flag, band 1
    w2mag_8 real, --/U mag --/D aperture 8 (24.75") instrumental aperture mag, band 2
    w2sigm_8 real, --/U mag --/D aperture 8 instrumental aperture mag uncertainty, band 2
    w2flg_8 integer, --/D aperture 8 instrumental aperture flag, band 2
    w1nm integer, --/D number of profile-fit flux measurements for source with SNR >= 3, band 1
    w1m integer, --/D number of profile-fit flux measurements for source, band 1
    w1magp real, --/U mag --/D profile-fit repeatability mag -- inverse-variance weighted mean mag, band 1
    w1sigp1 real, --/U mag --/D standard deviation of population of profile-fit repeatability mag, band 1
    w1sigp2 real, --/U mag --/D standard deviation of the mean of profile-fit repeatability mag, band 1
    w1k real, --/D Stetson K variability index, band 1
    w1ndf integer, --/D number degrees of freedom in variability chi^2, band 1
    w1mlq real, --/D -ln(Q), where Q = 1 - P(chi^2), band 1
    w1mjdmin double precision, --/U d --/D minimum modified Julian Date of frame extractions, band 1
    w1mjdmax double precision, --/U d --/D maximum modified Julian Date of frame extractions, band 1
    w1mjdmean double precision, --/U d --/D mean modified Julian Date of frame extractions, band 1
    w2nm integer, --/D number of profile-fit flux measurements for source with SNR >= 3, band 2
    w2m integer, --/D number of profile-fit flux measurements for source, band 2
    w2magp real, --/U mag --/D profile-fit repeatability mag -- inverse-variance weighted mean mag, band 2
    w2sigp1 real, --/U mag --/D standard deviation of population of profile-fit repeatability mag, band 2
    w2sigp2 real, --/U mag --/D standard deviation of the mean of profile-fit repeatability mag, band 2
    w2k real, --/D Stetson K variability index, band 2
    w2ndf integer, --/D number degrees of freedom in variability chi^2, band 2
    w2mlq real, --/D -ln(Q), where Q = 1 - P(chi^2), band 2
    w2mjdmin double precision, --/U d --/D minimum modified Julian Date of frame extractions, band 2
    w2mjdmax double precision, --/U d --/D maximum modified Julian Date of frame extractions, band 2
    w2mjdmean double precision, --/U d --/D mean modified Julian Date of frame extractions, band 2
    rho12 integer, --/U % --/D band 1 - band 2 correlation coefficient
    q12 integer, --/U % --/D -log10(1 - P(rho12)), given no real correlation
    niters integer, --/D number of chi-square minimization iterations
    nsteps integer, --/D number of steps in all iterations
    mdetid integer, --/D source ID in mdet list
    p1 real, --/U arcsec --/D distance in ra from the mdet position to the wphot template-fit position
    p2 real, --/U arcsec --/D distance in dec from the mdet position to the wphot template-fit position
    meanobsmjd double precision, --/U d --/D mean observation epoch
    ra_pm double precision, --/U deg --/D Right ascension from psf model incl. motion at epoch MJD=56700.0 
	--/D (2014.118) for Preliminary Catalog and MJD=57170 (2015.405) for CatWISE2020
    dec_pm double precision, --/U deg --/D Declination from psf model incl. motion at epoch MJD=56700.0 
	--/D (2014.118) for Preliminary Catalog and MJD=57170 (2015.405) for CatWISE2020
    sigra_pm real, --/U arcsec --/D One-sigma uncertainty in RA from psf model incl. motion
    sigdec_pm real, --/U arcsec --/D One-sigma uncertainty in DEC from psf model incl. motion
    sigradec_pm real, --/U arcsec --/D The co-sigma of the equatorial position uncertainties from psf 
	--/D model incl motion
    pmra real, --/U arcsec/yr --/D Apparent motion in RA; (note uncorrected systematic in CatWISE2020)
    pmdec real, --/U arcsec/yr --/D Apparent motion in DEC; (note uncorrected systematic in CatWISE2020)
    sigpmra real, --/U arcsec/yr --/D Uncertainty in the RA motion estimate
    sigpmdec real, --/U arcsec/yr --/D Uncertainty in the Dec motion estimate
    w1snr_pm real, --/D S/N ratio of the W1 profile-fit photometry including motion
    w2snr_pm real, --/D S/N ratio of the W2 profile-fit photometry including motion
    w1flux_pm real, --/U 'dn' --/D Raw flux W1 profile-fit photometry including motion
    w1sigflux_pm real, --/U 'dn' --/D Raw flux uncertainty W1 profile-fit photometry including motion
    w2flux_pm real, --/U 'dn' --/D Raw flux W2 profile-fit photometry including motion
    w2sigflux_pm real, --/U 'dn' --/D Raw flux uncertainty W2 profile-fit photometry including motion
    w1mpro_pm real, --/U nag --/D W1 magnitude from profile-fit photometry including motion
    w1sigmpro_pm real, --/U mag --/D W1 flux uncertainty in mag units from profile-fit photometry including
	--/D  motion
    w1rchi2_pm real, --/D Reduced chi^2 of the W1 profile-fit photometry measurement including motion est
    w2mpro_pm real, --/U mag --/D W2 magnitude from profile-fit photometry including motion
    w2sigmpro_pm real, --/U mag --/D W2 flux uncertainty in mag units from profile-fit photometry including
	--/D  motion
    w2rchi2_pm real, --/D Reduced chi^2 of the W2 profile-fit photometry measurement including motion est
    rchi2_pm real, --/D Combined Reduced chi^2 in all bands for the psf photometry includes src motion
    pmcode character(7), --/D Motion estimate quality code: the format is ABCCC, where A is the 
	--/D number of components in the passive blend group (including the primary) before any are 
	--/D removed or added, B is "Y" or "N" to indicate "Yes" or "No" that a secondary blend 
	--/D component replaced the primary, and CCC is the distance in hundredths of an arcsec 
	--/D between the PM position solution for the mean observation epoch and the stationary solution
    niters_pm integer, --/D number of chi-square minimization iterations
    nsteps_pm integer, --/D number of steps in all iterations
    dist real, --/U arcsec --/D radial distance between source positions in ascending and descending 
	--/D scans
    dw1mag real, --/U mag --/D difference in w1mpro between ascending and descending scans
    rch2w1 real, --/D chi-square for dw1mag (1 degree of freedom)
    dw2mag real, --/U mag --/D difference in w2mpro between ascending and descending scans
    rch2w2 real, --/D chi-square for dw2mag (1 degree of freedom)
    elon_avg double precision, --/U deg --/D average ecliptic longitude
    elonsig real, --/U arcsec --/D uncertainty in elon_avg
    elat_avg double precision, --/U deg --/D average ecliptic latitude
    elatsig real, --/U arcsec --/D uncertainty in elat_avg
    delon real, --/U arcsec --/D descending scan - ascending scan ecliptic longitude difference (notes)
    delonsig real, --/U arcsec --/D one-sigma uncertainty in Delon
    delat real, --/U arcsec --/D descending scan - ascending scan ecliptic longitude difference
    delatsig real, --/U arcsec --/D one-sigma uncertainty in Delat
    delonsnr real, --/D abs(Delon)/DelonSig
    delatsnr real, --/D abs(Delat)/DelatSig
    chi2pmra real, --/D chi-square for PMRA difference (1 degree of freedom)
    chi2pmdec real, --/D chi-square for PMDec difference (1 degree of freedom)
    ka integer, --/D astrometry usage code: 0 neither the ascending nor the descending scan
	--/D  provided a solution; 1 only the ascending scan provided a solution; 2 only the
	--/D  descending scan provided a solutio; 3 both scans provided solutions which were 
	--/D combined in the relevant way
    k1 integer, --/D W1 photometry usage code: 0 neither the ascending nor the descending s
	--/D can provided a solution; 1 only the ascending scan provided a solution; 2 only the
	--/D  descending scan provided a solutio; 3 both scans provided solutions which were 
	--/D combined in the relevant way
    k2 integer, --/D W2 photometry usage code: 0 neither the ascending nor the descending s
	--/D can provided a solution; 1 only the ascending scan provided a solution; 2 only the
	--/D  descending scan provided a solutio; 3 both scans provided solutions which were 
	--/D combined in the relevant way
    km integer, --/D proper motion usage code: 0 neither the ascending nor the descending s
	--/D can provided a solution; 1 only the ascending scan provided a solution; 2 only the
	--/D  descending scan provided a solutio; 3 both scans provided solutions which were 
	--/D combined in the relevant way
    par_pm real, --/U arcsec --/D parallax from PM desc-asce elon (notes)
    par_pmsig real, --/U arcsec --/D one-sigma uncertainty in par_pm
    par_stat real, --/U arcsec --/D parallax estimate from stationary solution (notes)
    par_sigma real, --/U arcsec --/D one-sigma uncertainty in par_stat
    dist_x real, --/U arcsec --/D distance between CatWISE and AllWISE source
    cc_flags character(16), --/D worst case 4 character cc_flag from AllWISE (See Table A1 in Eisenhard
	--/D t et al. (2020))
    w1cc_map integer, --/D worst case w1cc_map from AllWISE (See Table A1 in Eisenhardt et al. (2020))
    w1cc_map_str character(20), --/D worst case w1cc_map_str from AllWISE (See Table A1 in Eisenhardt et al.
	--/D  (2020))
    w2cc_map integer, --/D worst case w2cc_map from AllWISE (See Table A1 in Eisenhardt et al. (2020))
    w2cc_map_str character(20), --/D worst case w2cc_map_str from AllWISE (See Table A1 in Eisenhardt et al.
	--/D  (2020))
    n_aw integer, --/D number of sources within 2.75" in AllWISE
    ab_flags character(9), --/D unWISE artifact bitmask contamination flags
    w1ab_map integer, --/D unWISE artifact bitmask contamination map for W1
    w1ab_map_str character(13), --/D unWISE artifact bitmask contamination string for W1
    w2ab_map integer, --/D unWISE artifact bitmask contamination map for W2
    w2ab_map_str character(13), --/D unWISE artifact bitmask contamination string for W1
    glon double precision, --/U deg --/D Galactic longitude (only present in CatWISE 2020)
    glat double precision, --/U deg --/D Galactic latitude (only present in CatWISE 2020)
    elon double precision, --/U deg --/D Ecliptic longitude
    elat double precision, --/U deg --/D Ecliptic latitude
    unwise_objid character(20) --/D UnWISE Object ID (only present in CatWISE 2020)
)
GO
--


--
-- Name: mos_ebosstarget_v5; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_ebosstarget_v5')
	DROP TABLE mos_ebosstarget_v5
GO
--
EXEC spSetDefaultFileGroup 'mos_ebosstarget_v5'
GO
CREATE TABLE mos_ebosstarget_v5 (

----------------------------------------------------------------------
--/H A catalog of targets, selected from SDSS+WISE imaging that were
--/H considered for observation in the SDSS-IV/eBOSS project.
----------------------------------------------------------------------
--/T These include spectrophotometric starts and candidate QSOs. <br>
--/T This catalogue is a data product of the ebosstarget target
--/T selection software, version "v5_0".
----------------------------------------------------------------------
    run integer, --/D SDSS imaging run
    camcol integer, --/D SDSS imaging camcol
    field integer, --/D SDSS imaging field
    id integer, --/D SDSS imaging object id
    rerun text, --/D SDSS imaging rerun
    fibermag_u real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, u-band
    fibermag_g real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, g-band
    fibermag_r real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, r-band
    fibermag_i real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, i-band
    fibermag_z real, --/U mag --/D Magnitude in 3 arcsec diameter fiber radius, z-band
    fiber2mag_u real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, u-band
    fiber2mag_g real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, g-band
    fiber2mag_r real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, r-band
    fiber2mag_i real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, i-band
    fiber2mag_z real, --/U mag --/D Magnitude in 2 arcsec diameter fiber radius, z-band
    calib_status_u integer, --/D Calibration status in u-band
    calib_status_g integer, --/D Calibration status in g-band
    calib_status_r integer, --/D Calibration status in r-band
    calib_status_i integer, --/D Calibration status in i-band
    calib_status_z integer, --/D Calibration status in z-band
    ra double precision, --/U deg --/D J2000 Right Ascension
    [dec] double precision, --/U deg --/D J2000 Declination
    epoch real, --/U year --/D Epoch of position
    pmra real, --/U mas/yr --/D proper motion in RA direction
    pmdec real, --/U mas/yr --/D - proper motion in Dec direction
    eboss_target1 bigint, --/D eBOSS target selection information, for eBOSS plates
    eboss_target2 bigint, --/D eBOSS target selection information, for TDSS, SPIDERS, ELG, etc. plates
    eboss_target_id bigint, --/D eBOSS unique target identifier for every spectroscopic target
    thing_id_targeting integer, --/D thing_id value from the version of resolve from which the targeting 
	--/D was created
    objc_type integer, --/D Type classification of the object (star, galaxy, cosmic ray, etc.)
    objc_flags integer, --/D Photo Object Attribute Flags(?)
    objc_flags2 integer, --/D Additional Photo Object Attribute Flags(?)
    flags integer, --/D Target selection flags set by ebosstarget (?)
    flags2 integer, --/D Additional target selection flags set by ebosstarget (?)
    psf_fwhm_u real, --/U arcsec --/D Imaging FWHM in u-band
    psf_fwhm_g real, --/U arcsec --/D Imaging FWHM in g-band
    psf_fwhm_r real, --/U arcsec --/D Imaging FWHM in r-band
    psf_fwhm_i real, --/U arcsec --/D Imaging FWHM in i-band
    psf_fwhm_z real, --/U arcsec --/D Imaging FWHM in z-band
    psfflux_u real, --/U nMgy --/D PSF flux, u-band
    psfflux_g real, --/U nMgy --/D PSF flux, g-band
    psfflux_r real, --/U nMgy --/D PSF flux, r-band
    psfflux_i real, --/U nMgy --/D PSF flux, i-band
    psfflux_z real, --/U nMgy --/D PSF flux, z-band
    psfflux_ivar_u real, --/U nMgy^{-2} --/D PSF flux inverse variance, u-band
    psfflux_ivar_g real, --/U nMgy^{-2} --/D PSF flux inverse variance, g-band
    psfflux_ivar_r real, --/U nMgy^{-2} --/D PSF flux inverse variance, r-band
    psfflux_ivar_i real, --/U nMgy^{-2} --/D PSF flux inverse variance, r-band
    psfflux_ivar_z real, --/U nMgy^{-2} --/D PSF flux inverse variance, i-band
    extinction_u real, --/U mag --/D Extinction in u-band
    extinction_g real, --/U mag --/D Extinction in g-band
    extinction_r real, --/U mag --/D Extinction in r-band
    extinction_i real, --/U mag --/D Extinction in i-band
    extinction_z real, --/U mag --/D Extinction in z-band
    fiberflux_u real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, u-band
    fiberflux_g real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, g-band
    fiberflux_r real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, r-band
    fiberflux_i real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, i-band
    fiberflux_z real, --/U nMgy --/D Flux in 3 arcsec diameter fiber radius, z-band
    fiberflux_ivar_u real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, u-band
    fiberflux_ivar_g real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, g-band
    fiberflux_ivar_r real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, r-band
    fiberflux_ivar_i real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, i-band
    fiberflux_ivar_z real, --/U nMgy^{-2} --/D Inverse variance of flux in 3 arcsec diameter fiber radius, z-band
    fiber2flux_ivar_u real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, u-band
    fiber2flux_ivar_g real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, g-band
    fiber2flux_ivar_r real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, r-band
    fiber2flux_ivar_i real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, i-band
    fiber2flux_ivar_z real, --/U nMgy^{-2} --/D Inverse variance of flux in 2 arcsec diameter fiber radius, z-band
    modelflux_u real, --/U nMgy --/D Flux of best fitting model, u-band
    modelflux_g real, --/U nMgy --/D Flux of best fitting model, g-band
    modelflux_r real, --/U nMgy --/D Flux of best fitting model, r-band
    modelflux_i real, --/U nMgy --/D Flux of best fitting model, i-band
    modelflux_z real, --/U nMgy --/D Flux of best fitting model, z-band
    modelflux_ivar_u real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, u-band
    modelflux_ivar_g real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, g-band
    modelflux_ivar_r real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, r-band
    modelflux_ivar_i real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, i-band
    modelflux_ivar_z real, --/U nMgy^{-2} --/D Inverse variance of flux of best fitting model, z-band
    modelmag_u real, --/U nMgy --/D Magnitude of best fitting model, u-band
    modelmag_g real, --/U nMgy --/D Magnitude of best fitting model, g-band
    modelmag_r real, --/U nMgy --/D Magnitude of best fitting model, r-band
    modelmag_i real, --/U nMgy --/D Magnitude of best fitting model, i-band
    modelmag_z real, --/U nMgy --/D Magnitude of best fitting model, z-band
    modelmag_ivar_u real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, u-band
    modelmag_ivar_g real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, g-band
    modelmag_ivar_r real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, r-band
    modelmag_ivar_i real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, i-band
    modelmag_ivar_z real, --/U nMgy^{-2} --/D Inverse variance of magnitude of best fitting model, z-band
    resolve_status integer, --/D Resolve status of object
    w1_mag real, --/U mag --/D WISE AllSky magnitude of the object, W1-band
    w1_mag_err real, --/U mag --/D Error on WISE AllSky magnitude of the object, W1-band
    w1_nanomaggies real, --/U nMgy --/D WISE AllSky flux of the object, W1-band
    w1_nanomaggies_ivar real, --/U nMgy^{-2} --/D Inverse variance of WISE AllSky flux of the object, W1-band
    w2_nanomaggies real, --/U nMgy --/D WISE AllSky flux of the object, W2-band
    w2_nanomaggies_ivar real, --/U nMgy^{-2} --/D Inverse variance of WISE AllSky flux of the object, W2-band
    has_wise_phot bit, --/D True if WISE photometry is available for this object
    objid_targeting bigint, --/D Object ID of target
    pk bigint NOT NULL --/D primary key for entry in database table
)
GO
--


--
-- Name: mos_gaia_dr2_ruwe; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_gaia_dr2_ruwe')
	DROP TABLE mos_gaia_dr2_ruwe
GO
--
EXEC spSetDefaultFileGroup 'mos_gaia_dr2_ruwe'
GO
CREATE TABLE mos_gaia_dr2_ruwe (

----------------------------------------------------------------------
--/H Table from Gaia DR2 containing the Renormalised Unit Weight Error
--/H (RUWE) associated to each source in gaia_source.
----------------------------------------------------------------------
--/T See https://gea.esac.esa.int/archive/documentation/GDR2/Gaia_archive/chap_datamodel/sec_dm_main_tables/ssec_dm_ruwe.html 
--/T for more detailed descriptions of the columns.
----------------------------------------------------------------------
    source_id bigint NOT NULL, --/D Gaia DR2 unique source identifier
    ruwe real --/D renormalised unit weight error
)
GO
--


--
-- Name: mos_gaia_dr2_source; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_gaia_dr2_source')
	DROP TABLE mos_gaia_dr2_source
GO
--
EXEC spSetDefaultFileGroup 'mos_gaia_dr2_source'
GO
CREATE TABLE mos_gaia_dr2_source (

----------------------------------------------------------------------
--/H Gaia DR2 Source Table. 
----------------------------------------------------------------------
--/T See https://gea.esac.esa.int/archive/documentation/GDR2/Gaia_archive/chap_datamodel/sec_dm_main_tables/ssec_dm_gaia_source.html 
--/T for complete details.
----------------------------------------------------------------------
    solution_id bigint, --/D ID that identifies the version of all the subsystems that were used in
	--/D  the generation of the data as well as the input data used
    designation text, --/D Unique source designation across all Gaia data releases
    source_id bigint NOT NULL, --/D Unique source identifier within a particular Gaia data release
    random_index bigint, --/D Random index which can be used to select smaller subsets of the data
    ref_epoch double precision, --/U Julian Years --/D Time
    ra double precision, --/U degrees --/D Right Ascension
    ra_error double precision, --/U degrees --/D Standard error of the right ascension
    [dec] double precision, --/U degrees --/D Declination
    dec_error double precision, --/U degrees --/D Standard error of the declination
    parallax double precision, --/U mas --/D Absolute stellar parallax of the source at the reference epoch
    parallax_error double precision, --/U mas --/D Standard error of parallax
    parallax_over_error real, --/D Parallax divided by its error
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension direction
    pmra_error double precision, --/U mas/yr --/D Standard error of proper motion in right ascension direction
    pmdec double precision, --/U mas/yr --/D Proper motion in declination direction
    pmdec_error double precision, --/U mas/yr --/D Standard error of proper motion in declination direction
    ra_dec_corr real, --/D Correlation between right ascension and declination
    ra_parallax_corr real, --/D Correlation between right ascension and parallax
    ra_pmra_corr real, --/D Correlation between right ascension and proper motion in right ascension
    ra_pmdec_corr real, --/D Correlation between right ascension and proper motion in declination
    dec_parallax_corr real, --/D Correlation between declination and parallax
    dec_pmra_corr real, --/D Correlation between declination and proper motion in right ascension
    dec_pmdec_corr real, --/D Correlation between declination and proper motion in declination
    parallax_pmra_corr real, --/D Correlation between parallax and proper motion in right ascension
    parallax_pmdec_corr real, --/D Correlation between parallax and proper motion in declination
    pmra_pmdec_corr real, --/D Correlation between proper motion in right ascension and proper motion
	--/D  in declination
    astrometric_n_obs_al integer, --/D Total number of observations AL
    astrometric_n_obs_ac integer, --/D Total number of observations AC
    astrometric_n_good_obs_al integer, --/D Number of good observations AL
    astrometric_n_bad_obs_al integer, --/D Number of bad observations AL
    astrometric_gof_al real, --/D Goodness of fit statistic of model wrt along-scan observations
    astrometric_chi2_al real, --/D AL chi-square value
    astrometric_excess_noise double precision, --/U mas --/D Excess noise of the source
    astrometric_excess_noise_sig double precision, --/D Significance of excess noise
    astrometric_params_solved integer, --/D Which parameters have been solved for
    astrometric_primary_flag bit, --/D Flag indicating if this source was used as a primary source (true) or 
	--/D secondary source (false)
    astrometric_weight_al real, --/U mas^-2 --/D Mean astrometric weight of the source
    astrometric_pseudo_colour double precision, --/U um^-1 --/D Astrometrically determined pseudocolour of the source
    astrometric_pseudo_colour_error double precision, --/U um^-1 --/D Standard error of the pseudocolour of the source
    mean_varpi_factor_al real, --/D Mean Parallax factor AL
    astrometric_matched_observations smallint, --/D number of FOV transits matched to this source
    visibility_periods_used smallint, --/D Number of visibility periods used in the astrometric solution
    astrometric_sigma5d_max real, --/U mas --/D Longest semi-major axis of the 5-d error ellipsoid
    frame_rotator_object_type integer, --/D Type of the source mainly used for frame rotation
    matched_observations smallint, --/D Total number of FOV transits matched to this source
    duplicated_source bit, --/D Source with duplicate sources
    phot_g_n_obs integer, --/D Number of observations contributing to G photometry
    phot_g_mean_flux double precision, --/U e-/s --/D G-band mean flux
    phot_g_mean_flux_error double precision, --/U e-/s --/D Error on G-band mean flux
    phot_g_mean_flux_over_error real, --/D G-band mean flux divided by its error
    phot_g_mean_mag real, --/U mag --/D G-band mean magnitude
    phot_bp_n_obs integer, --/D Number of observations contributing to BP photometry
    phot_bp_mean_flux double precision, --/U e-/s --/D Integrated BP mean flux
    phot_bp_mean_flux_error double precision, --/U e-/s --/D Error on the integrated BP mean flux
    phot_bp_mean_flux_over_error real, --/D Integrated BP mean flux divided by its error
    phot_bp_mean_mag real, --/U mag --/D Integrated BP mean magnitude
    phot_rp_n_obs integer, --/D Number of observations contributing to RP photometry
    phot_rp_mean_flux double precision, --/U e-/s --/D Integrated RP mean flux
    phot_rp_mean_flux_error double precision, --/U e-/s --/D Error on the integrated RP mean flux
    phot_rp_mean_flux_over_error real, --/D Integrated RP mean flux divided by its error
    phot_rp_mean_mag real, --/U mag --/D Integrated RP mean magnitude
    phot_bp_rp_excess_factor real, --/D BP/RP excess factor
    phot_proc_mode integer, --/D Photometry processing mode
    bp_rp real, --/U mag --/D BP - RP color
    bp_g real, --/U mag --/D BP - G color
    g_rp real, --/U mag --/D G - RP color
    radial_velocity double precision, --/U km/s --/D Radial velocity
    radial_velocity_error double precision, --/U km/s --/D Radial velocity error
    rv_nb_transits integer, --/D Number of transits used to compute radial velocity
    rv_template_teff real, --/U K --/D Teff of the template used to compute radial velocity
    rv_template_logg real, --/U log cgs --/D logg of the template used to compute radial velocity
    rv_template_fe_h real, --/U dex --/D Fe/H of the template used to compute radial velocity
    phot_variable_flag text, --/D Photometric variability flag
    l double precision, --/U degrees --/D Galactic longitude
    b double precision, --/U degrees --/D Galactic latitude
    ecl_lon double precision, --/U degrees --/D Ecliptic longitude
    ecl_lat double precision, --/U degrees --/D Ecliptic latitude
    priam_flags bigint, --/D Flags for the Apsis-Priam results
    teff_val real, --/U K --/D Stellar effective temperature
    teff_percentile_lower real, --/U K --/D Teff_val lower uncertainty
    teff_percentile_upper real, --/U K --/D Teff_val upper uncertainty
    a_g_val real, --/U mag --/D Line-of-sight extinction in the G band
    a_g_percentile_lower real, --/U mag --/D A_g_val lower uncertainty
    a_g_percentile_upper real, --/U mag --/D A_g_val upper uncertainty
    e_bp_min_rp_val real, --/U mag --/D Line-of-sight reddening E(BP-RP)
    e_bp_min_rp_percentile_lower real, --/U mag --/D e_bp_min_rp_val lower uncertainty
    e_bp_min_rp_percentile_upper real, --/U mag --/D e_bp_min_rp_val upper uncertainty
    flame_flags bigint, --/D Flags for the Apsis-FLAME results
    radius_val real, --/U Solar Radius --/D Stellar radius
    radius_percentile_lower real, --/U Solar Radius --/D Radius_val lower uncertainty
    radius_percentile_upper real, --/U Solar Radius --/D Radius_val upper uncertainty
    lum_val real, --/U Solar Luminosity --/D stellar luminosity
    lum_percentile_lower real, --/U Solar Luminosity --/D lum_val lower uncertainty
    lum_percentile_upper real, --/U Solar Luminosity --/D lum_val upper uncertainty
    parallax_parallax_error  AS ([parallax]-[parallax_error]) PERSISTED --/D difference between parallax and parallax error
)
GO
--


--
-- Name: mos_gaia_dr2_wd; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_gaia_dr2_wd')
	DROP TABLE mos_gaia_dr2_wd
GO
--
EXEC spSetDefaultFileGroup 'mos_gaia_dr2_wd'
GO
CREATE TABLE mos_gaia_dr2_wd (

----------------------------------------------------------------------
--/H White dwarf catalog of high-probablity WDs from Gentile Fusillo
--H (2019) based on Gaia DR2. 
----------------------------------------------------------------------
--/T Please see https://academic.oup.com/mnras/article/482/4/4570/5162857
--/T for more information on the columns.
----------------------------------------------------------------------
    wd text, --/D WD names from this catalog -- WD J + J2000 ra (hh mm ss.ss) + dec (dd 
	--/D mm ss.s), equinox and epoch 2000
    dr2name text, --/D Unique Gaia source designation
    source_id bigint NOT NULL, --/D Unique Gaia DR2 source identifier
    source integer, --/D Internal identifier (do not use)
    ra double precision, --/U deg --/D Right ascension
    e_ra double precision, --/U mas --/D Standard error of right ascenscion
    [dec] double precision, --/U deg --/D Declination
    e_dec double precision, --/U mas --/D Standard error of declination
    plx real, --/U mas --/D Absolute stellar parallax of the source at J2015.5
    e_plx real, --/U mas --/D Standard error of parallax
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension
    e_pmra double precision, --/U mas/yr --/D Standard error of proper motion in right ascension
    pmdec double precision, --/U mas/yr --/D Proper motion in right declination
    e_pmdec double precision, --/U mas/yr --/D Standard error of proper motion in declination
    epsi real, --/U mas --/D Measure of the residuals in the astrometric solution
    amax real, --/U mas --/D 5-dimensional equivalent to the semimajor axis of the Gaia position 
	--/D error ellipse
    fg_gaia real, --/U e-/s --/D Gaia G-band mean flux
    e_fg_gaia real, --/U e-/s --/D Error on G-band mean flux
    g_gaia_mag real, --/U mag --/D Gaia G-band mean magnitude
    fbp real, --/U e-/s --/D Integrated G_BP mean flux
    e_fbp real, --/U e-/s --/D Error on integrated G_BP mean flux
    bpmag real, --/U mag --/D Integrated G_BP mean magnitude
    frp real, --/U e-/s --/D Integrated G_RP mean flux
    e_frp real, --/U e-/s --/D Error on integrated G_RP mean flux
    rpmag real, --/U mag --/D Integrated G_RP mean magnitude
    e_br_rp real, --/D G_BP/G_RP execess factor
    glon double precision, --/U deg --/D Galactic longitude
    glat double precision, --/U deg --/D Galactic latitude
    density real, --/U sq.deg^-1 --/D Number of Gaia sources around this object
    ag real, --/U mag --/D Extinction in the Gaia G band derived from E(B − V) values from 
	--/D Schlafly and  Finkbeiner
    sdss text, --/D SDSS object name if available
    umag real, --/U mag --/D SDSS u-band magnitude
    e_umag real, --/U mag --/D SDSS u-band magnitude uncertainty
    gmag real, --/U mag --/D SDSS g-band magnitude uncertainty
    e_gmag real, --/U mag --/D SDSS g-band magnitude
    rmag real, --/U mag --/D SDSS r-band magnitude uncertainty
    e_rmag real, --/U mag --/D SDSS r-band magnitude
    imag real, --/U mag --/D SDSS i-band magnitude uncertainty
    e_imag real, --/U mag --/D SDSS i-band magnitude
    zmag real, --/U mag --/D SDSS z-band magnitude uncertainty
    e_zmag real, --/U mag --/D SDSS z-band magnitude
    pwd real, --/D Probability of being a white dwarf
    f_pwd integer, --/D Flag on probability of being a white dwarf
    teffh real, --/U K --/D Effective temperature from fitting the dereddened G, GBP, and GRP 
	--/D absolute fluxes with pure-H model atmospheres
    e_teffh real, --/U K --/D Uncertainty on Teff from pure-H model atmospheres
    loggh real, --/U dex cgs --/D Surface gravity from fitting the dereddened G, GBP, and GRP absolute 
	--/D fluxes with pure-H model atmospheres
    e_loggh real, --/U dex cgs --/D Uncertainty on log g from pure-H model atmospheres
    massh real, --/U Solar masses --/D Stellar mass assuming pure-H model atmospheres
    e_massh real, --/U Solar masses --/D Uncertainty on the mass assuming pure-H model atmospheres
    chi2h real, --/D Chi^2 value of the pure-H fit
    teffhe real, --/U K --/D Effective temperature from fitting the dereddened G, GBP, and GRP 
	--/D absolute fluxes with pure-He model atmospheres
    e_teffhe real, --/U K --/D Uncertainty on Teff from pure-He model atmospheres
    logghe real, --/U dex cgs --/D Surface gravity from fitting the dereddened G, GBP, and GRP absolute 
	--/D fluxes with pure-He model atmospheres
    e_logghe real, --/U dex cgs --/D Uncertainty on log g from pure-He model atmospheres
    masshe real, --/U Solar masses --/D Stellar mass assuming pure-He model atmospheres
    e_masshe real, --/U Solar masses --/D Uncertainty on the mass assuming pure-H model atmospheres
    chisqhe real --/D Chi^2 value of the pure-H fit
)
GO
--


--
-- Name: mos_gaia_unwise_agn; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_gaia_unwise_agn')
	DROP TABLE mos_gaia_unwise_agn
GO
--
EXEC spSetDefaultFileGroup 'mos_gaia_unwise_agn'
GO
CREATE TABLE mos_gaia_unwise_agn (

----------------------------------------------------------------------
--/H AGN identified using information from WISE and Gaia DR2 from the
--/H catalog of Shu et al. 2019.
----------------------------------------------------------------------
--/T See complete information on the columns in
--/T https://academic.oup.com/mnras/article/489/4/4741/5561523
----------------------------------------------------------------------
    ra double precision, --/U degrees --/D Right ascension from Gaia DR2
    [dec] double precision, --/U degrees --/D Declination from Gaia DR2
    gaia_sourceid bigint NOT NULL, --/D Unique Gaia DR2 source identifier
    unwise_objid text, --/D Unique unWISE source identifier
    plx double precision, --/U mas --/D Parallax from Gaia DR2
    plx_err double precision, --/U mas --/D Error in parallax from Gaia DR2
    pmra double precision, --/U mas/yr --/D Proper motion in right ascension from Gaia DR2
    pmra_err double precision, --/U mas/yr --/D Error in proper motion in right ascension from Gaia DR2
    pmdec double precision, --/U mas/yr --/D Proper motion in declination from Gaia DR2
    pmdec_err double precision, --/U mas/yr --/D Error in proper motinon in declination from Gaia DR2
    plxsig double precision, --/D Parallax significance defined as parallax/parallax_error
    pmsig double precision, --/D Proper motion significance
    ebv double precision, --/U mag --/D Galactic E(B-V) reddening from Schlegel et al. 1998
    n_obs integer, --/D Number of observations contributing to Gaia DR2 G photometry
    g double precision, --/U mag --/D Gaia DR2 G-band mean magnitude (extinction corrected)
    bp double precision, --/U mag --/D Gaia DR2 BP-band mean magnitude (extinction corrected)
    rp double precision, --/U mag --/D Gaia DR2 RP-band mean magnitude (extinction corrected)
    w1 double precision, --/U mag --/D unWISE W1-band magnitude
    w2 double precision, --/U mag --/D unWISE W2-band magnitude
    bp_g double precision, --/U mag --/D Gaia DR2 BP − G color (extinction corrected)
    bp_rp double precision, --/U mag --/D Gaia DR2 BP − RP color (extinction corrected)
    g_rp double precision, --/U mag --/D Gaia DR2 G − RP color (extinction corrected)
    g_w1 double precision, --/U mag --/D Gaia DR2 G − unWISE W1 color (extinction corrected)
    gw_sep double precision, --/U arcsec --/D Separation between a Gaia source and its unWISE counterpart
    w1_w2 double precision, --/U mag --/D unWISE W1 −W2 color
    g_var double precision, --/D Variation in GaiaG-band flux
    bprp_ef double precision, --/D BP/RP excess factor from Gaia DR2
    aen double precision, --/U mas --/D Astrometric excess noise from Gaia DR2
    gof double precision, --/D Goodness-of-fit statistic of the astrometric solution from Gaia DR2
    cnt1 integer, --/D Number of Gaia DR2 sources within a 1 arcsec radius circular aperture
    cnt2 integer, --/D Number of Gaia DR2 sources within a 2 arcsec radius circular aperture
    cnt4 integer, --/D Number of Gaia DR2 sources within a 4 arcsec radius circular aperture
    cnt8 integer, --/D Number of Gaia DR2 sources within a 8 arcsec radius circular aperture
    cnt16 integer, --/D Number of Gaia DR2 sources within a 16 arcsec radius circular aperture
    cnt32 integer, --/D Number of Gaia DR2 sources within a 32 arcsec radius circular aperture
    phot_z double precision, --/D Photometric redshift
    prob_rf double precision --/D AGN probability
)
GO
--


--
-- Name: mos_gaiadr2_tmass_best_neighbour; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_gaiadr2_tmass_best_neighbour')
	DROP TABLE mos_gaiadr2_tmass_best_neighbour
GO
--
EXEC spSetDefaultFileGroup 'mos_gaiadr2_tmass_best_neighbour'
GO
CREATE TABLE mos_gaiadr2_tmass_best_neighbour (

----------------------------------------------------------------------
--/H The Gaia DR2 vs. 2MASS PSC crossmatch provided by the Gaia collaboration.
----------------------------------------------------------------------
--/T Please see https://gea.esac.esa.int/archive/documentation/GDR2/Catalogue_consolidation/chap_cu9val_cu9val/ssec_cu9xma/sssec_cu9xma_extcat.html
--/T for complete details.
----------------------------------------------------------------------
    tmass_oid bigint, --/D Additional numeric unique source identifier of 2MASS, increasing with 
	--/D declination
    number_of_neighbours integer, --/D Number of sources in the 2MASS Catalogue which match the Gaia 
	--/D source within position errors
    number_of_mates integer, --/D Number of other Gaia sources that have as best-neighbour the same 
	--/D 2MASS source.
    best_neighbour_multiplicity integer, --/D Number of neighbours with same probability as best neighbour
    source_id bigint NOT NULL, --/D Unique Gaia DR2 source identifier
    original_ext_source_id character(17), --/D The unique source identifier in the original 2MASS catalogue
    angular_distance double precision, --/U arcsec --/D Angular distance between the two sources
    gaia_astrometric_params integer, --/D Number of Gaia astrometric params used
    tmass_pts_key integer --/D key for crossmatch
)
GO
--


--
-- Name: mos_geometric_distances_gaia_dr2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_geometric_distances_gaia_dr2')
	DROP TABLE mos_geometric_distances_gaia_dr2
GO
--
EXEC spSetDefaultFileGroup 'mos_geometric_distances_gaia_dr2'
GO
CREATE TABLE mos_geometric_distances_gaia_dr2 (

----------------------------------------------------------------------
--/H Bayesian distances from Gaia DR2 parameters from Bailer-Jones et al. 2018.
----------------------------------------------------------------------
--/T For complete details, see the original paper:
--/T https://iopscience.iop.org/article/10.3847/1538-3881/aacb21/pdf
----------------------------------------------------------------------
    source_id bigint NOT NULL, --/D Unique Gaia DR2 source identifier
    r_est real, --/U pc --/D Estimated distance
    r_lo real, --/U pc --/D Lower bound on the confidence interval of the estimated distance
    r_hi real, --/U pc --/D Upper bound on the confidence interval of the estimated distance
    r_len real, --/U pc --/D Length scale used in the prior for the distance estimation
    result_flag character(1), --/D Result flag
    modality_flag smallint --/D Number of modes in the posterior
)
GO
--


--
-- Name: mos_glimpse; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_glimpse')
	DROP TABLE mos_glimpse
GO
--
EXEC spSetDefaultFileGroup 'mos_glimpse'
GO
CREATE TABLE mos_glimpse (

----------------------------------------------------------------------
--/H GLIMPSE catalog (I, II and 3-D).
----------------------------------------------------------------------
--/T See full documentation at
--/T https://irsa.ipac.caltech.edu/data/SPITZER/GLIMPSE/doc/glimpse1_dataprod_v2.0.pdf
----------------------------------------------------------------------
    designation text, --/D position-based designation in Galactic coordinates
    tmass_designation character varying(18), --/D 2MASS designation from PSC
    tmass_cntr integer, --/D 2MASS counter
    l double precision, --/U degrees --/D Galactic longitude
    b double precision, --/U degrees --/D Galactic latitude
    dl double precision, --/U degrees --/D uncertaintiy in Galactic longitude
    db double precision, --/U degrees --/D uncertainty in Galactic latitude
    ra double precision, --/U degrees --/D right ascension
    [dec] double precision, --/U degrees --/D declination
    dra double precision, --/U degrees --/D uncertainity in RA
    ddec double precision, --/U degrees --/D uncertainity in Dec
    csf integer, --/D close source flag (see GLIMPSE documentation for details)
    mag_j real, --/U mag --/D 2MASS J-band magnitude
    dj_m real, --/U mag --/D uncertainity in 2MASS J-band magnitude
    mag_h real, --/U mag --/D 2MASS H-band magnitude
    dh_m real, --/U mag --/D uncertainity in 2MASS H-band magnitude
    mag_ks real, --/U mag --/D 2MASS Ks-band magnitude
    dks_m real, --/U mag --/D uncertainity in 2MASS Ks-band magnitude
    mag3_6 real, --/U mag --/D IRAC 3.6-band magnitude
    d3_6m real, --/U mag --/D uncertainty in IRAC 3.6-band magnitude
    mag4_5 real, --/U mag --/D IRAC 4.5-band magnitude
    d4_5m real, --/U mag --/D uncertainty in IRAC 4.5-band magnitude
    mag5_8 real, --/U mag --/D IRAC 5.8-band magnitude
    d5_8m real, --/U mag --/D uncertainty in IRAC 5.8-band magnitude
    mag8_0 real, --/U mag --/D IRAC 8.0-band magnitude
    d8_0m real, --/U mag --/D uncertainty in IRAC 8.0-band magnitude
    f_j real, --/U mJy --/D 2MASS J-band flux
    df_j real, --/U mJy --/D uncertainity in 2MASS J-band flux
    f_h real, --/U mJy --/D 2MASS H-band flux
    df_h real, --/U mJy --/D uncertainty in 2MASS H-band flux
    f_ks real, --/U mJy --/D 2MASS Ks-band flux
    df_ks real, --/U mJy --/D uncertainity in 2MASS Ks-band flux
    f3_6 real, --/U mJy --/D IRAC 3.6-band flux
    df3_6 real, --/U mJy --/D uncertainty in IRAC 3.6-band flux
    f4_5 real, --/U mJy --/D IRAC 4.5-band flux
    df4_5 real, --/U mJy --/D uncertainty in IRAC 4.5-band flux
    f5_8 real, --/U mJy --/D IRAC 5.8-band flux
    df5_8 real, --/U mJy --/D uncertainty in IRAC 5.8-band flux
    f8_0 real, --/U mJy --/D IRAC 8.0-band flux
    df8_0 real, --/U mJy --/D uncertainty in IRAC 8.0-band flux
    rms_f3_6 real, --/U mJy --/D RMS deviation of the individual detections from final flux in 
	--/D IRAC 3.6-band
    rms_f4_5 real, --/U mJy --/D RMS deviation of the individual detections from final flux in 
	--/D IRAC 4.5-band
    rms_f5_8 real, --/U mJy --/D RMS deviation of the individual detections from final flux in 
	--/D IRAC 5.8-band
    rms_f8_0 real, --/U mJy --/D RMS deviation of the individual detections from final flux in 
	--/D IRAC 8.0-band
    sky_3_6 real, --/U mJy/sr --/D local background sky in IRAC 3.6-band
    sky_4_5 real, --/U mJy/sr --/D local background sky in IRAC 4.5-band
    sky_5_8 real, --/U mJy/sr --/D local background sky in IRAC 5.8-band
    sky_8_0 real, --/U mJy/sr --/D local background sky in IRAC 8.0-band
    sn_j real, --/D j_snr in 2MASS J-band
    sn_h real, --/D h_snr from 2MASS catalog
    sn_ks real, --/D ks_snr from 2MASS catalog
    sn_3_6 real, --/D (flux)/(uncertainty in flux) in IRAC 3.5-band
    sn_4_5 real, --/D (flux)/(uncertainty in flux) in IRAC 4.5-band
    sn_5_8 real, --/D (flux)/(uncertainty in flux) in IRAC 5.8-band
    sn_8_0 real, --/D (flux)/(uncertainty in flux) in IRAC 8.0-band
    dens_3_6 real, --/U #/sqarcmin --/D local source density in IRAC 3.6-band
    dens_4_5 real, --/U #/sqarcmin --/D local source density in IRAC 4.5-band
    dens_5_8 real, --/U #/sqarcmin --/D local source density in IRAC 5.8-band
    dens_8_0 real, --/U #/sqarcmin --/D local source density in IRAC 8.0-band
    m3_6 integer, --/D number of source detections in IRAC 3.6-band
    m4_5 integer, --/D number of source detections in IRAC 4.5-band
    m5_8 integer, --/D number of source detections in IRAC 5.8-band
    m8_0 integer, --/D number of source detections in IRAC 8.0-band
    n3_6 integer, --/D number of observations in IRAC 3.6-band
    n4_5 integer, --/D number of observations in IRAC 4.5-band
    n5_8 integer, --/D number of observations in IRAC 5.8-band
    n8_0 integer, --/D number of observations in IRAC 8.0-band
    sqf_j integer, --/D source quality flag for 2MASS J-band (see GLIMPSE documentation for 
	--/D details)
    sqf_h integer, --/D source quality flag for 2MASS H-band (see GLIMPSE documentation for 
	--/D details)
    sqf_ks integer, --/D source quality flag for 2MASS Ks-band (see GLIMPSE documentation for 
	--/D details)
    sqf_3_6 integer, --/D source quality flag for IRAC 3.6-band (see GLIMPSE documentation for 
	--/D details)
    sqf_4_5 integer, --/D source quality flag for IRAC 4.5-band (see GLIMPSE documentation for 
	--/D details)
    sqf_5_8 integer, --/D source quality flag for IRAC 5.8-band (see GLIMPSE documentation for 
	--/D details)
    sqf_8_0 integer, --/D source quality flag for IRAC 8.0-band (see GLIMPSE documentation for 
	--/D details)
    mf3_6 integer, --/D method flag for IRAC 3.6-band (see GLIMPSE documentation for details)
    mf4_5 integer, --/D method flag for IRAC 4.5-band (see GLIMPSE documentation for details)
    mf5_8 integer, --/D method flag for IRAC 5.8-band (see GLIMPSE documentation for details)
    mf8_0 integer, --/D method flag for IRAC 8.0-band (see GLIMPSE documentation for details)
    pk bigint NOT NULL --/D primary key
)
GO
--


--
-- Name: mos_guvcat; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_guvcat')
	DROP TABLE mos_guvcat
GO
--
EXEC spSetDefaultFileGroup 'mos_guvcat'
GO
CREATE TABLE mos_guvcat (

----------------------------------------------------------------------
--/H GALEX unique source catalog from Bianchi et al. 2017
--/H (https://iopscience.iop.org/article/10.3847/1538-4365/aa7053/pdf).
----------------------------------------------------------------------
--/T For more details on the column descriptions see
--/T https://archive.stsci.edu/hlsp/guvcat/guvcat-column-description
----------------------------------------------------------------------
    objid bigint NOT NULL, --/D GALEX identifier for the source
    photoextractid bigint, --/D Pointer to GALEX photoExtract Table (identifier of original observation)
    mpstype text, --/D Survey type ("AIS")
    avaspra double precision, --/U degrees --/D R.A. of center of field where object was measured
    avaspdec double precision, --/U degrees --/D Declination of center of field where object was measured
    fexptime real, --/U seconds --/D FUV exposure time
    nexptime real, --/U seconds --/D NUV exposure time
    ra double precision, --/U degrees --/D Source's right ascension
    [dec] double precision, --/U degrees --/D Source's declination
    glon double precision, --/U degrees --/D Source's Galactic longitude
    glat double precision, --/U degrees --/D Source's Galactic latitude
    tilenum integer, --/D "Tile" number
    img integer, --/D Image number
    subvisit integer, --/D Number of subvisit if exposure was divided
    fov_radius real, --/D Distance of source from center of the field in which it was measured
    type integer, --/D Obs. type (0=single, 1=multi)
    band integer, --/D Band number (1=NUV, 2=FUV, 3=both)
    e_bv real, --/U mag --/D E(B-V) Galactic reddening from Schlegel et al. 1998 maps)
    istherespectrum smallint, --/D Does this object have a GALEX spectrum?
    chkobj_type smallint, --/D Astrometry check type
    fuv_mag real, --/U mag --/D FUV calibrated magnitude
    fuv_magerr real, --/U mag --/D FUV calibrated magnitude error
    nuv_mag real, --/U mag --/D NUV calibrated magnitude
    nuv_magerr real, --/U mag --/D NUV calibrated magnitude error
    fuv_mag_auto real, --/U mag --/D FUV Kron-like elliptical aperture magnitude
    fuv_magerr_auto real, --/U mag --/D FUV rms error for AUTO magnitude
    nuv_mag_auto real, --/U mag --/D NUV Kron-like elliptical aperture magnitude
    nuv_magerr_auto real, --/U mag --/D NUV rms error for AUTO magnitude
    fuv_mag_aper_4 real, --/U mag --/D FUV magnitude aperture (8 pixel)
    fuv_magerr_aper_4 real, --/U mag --/D FUV magnitude error aperture (8 pixel)
    nuv_mag_aper_4 real, --/U mag --/D NUV magnitude aperture (8 pixel)
    nuv_magerr_aper_4 real, --/U mag --/D NUV magnitude error aperture (8 pixel)
    fuv_mag_aper_6 real, --/U mag --/D FUV magnitude aperture (17 pixel)
    fuv_magerr_aper_6 real, --/U mag --/D FUV magnitude error aperture (17 pixel)
    nuv_mag_aper_6 real, --/U mag --/D NUV magnitude aperture (17 pixel)
    nuv_magerr_aper_6 real, --/U mag --/D NUV magnitude error aperture (17 pixel)
    fuv_artifact smallint, --/D FUV artifact flag
    nuv_artifact smallint, --/D NUV artifact flag
    fuv_flags smallint, --/D FUV extraction flags
    nuv_flags smallint, --/D NUV extraction flags
    fuv_flux real, --/U mJy --/D FUV calibrated flux
    fuv_fluxerr real, --/U mJy --/D FUV calibrated flux error
    nuv_flux real, --/U mJy --/D NUV calibrated flux
    nuv_fluxerr real, --/U mJy --/D NUV calibrated flux error
    fuv_x_image real, --/D FUV object position along x
    fuv_y_image real, --/D FUV object position along y
    nuv_x_image real, --/D NUV object position along x
    nuv_y_image real, --/D NUV object position along y
    fuv_fwhm_image real, --/D FUV FWHM assuming a Gaussian core
    nuv_fwhm_image real, --/D NUV FWHM assuming a Gaussian core
    fuv_fwhm_world real, --/D FUV FWHM assuming a Gaussian core (WORLD units)
    nuv_fwhm_world real, --/D NUV FWHM assuming a Gaussian core (WORLD units)
    nuv_class_star real, --/D NUV Star/Galaxy classifier
    fuv_class_star real, --/D FUV Star/Galaxy classifier
    nuv_ellipticity real, --/D NUV (1. - B_IMAGE/A_IMAGE)
    fuv_ellipticity real, --/D FUV (1. - B_IMAGE/A_IMAGE)
    nuv_theta_j2000 real, --/U degrees --/D NUV position angle (east of north) (J2000)
    nuv_errtheta_j2000 real, --/U degrees --/D NUV position angle error (east of north) (J2000)
    fuv_theta_j2000 real, --/U degrees --/D FUV position angle (east of north) (J2000)
    fuv_errtheta_j2000 real, --/U degrees --/D FUV position angle error (east of north) (J2000)
    fuv_ncat_fwhm_image real, --/U pixels --/D FUV FWHM_IMAGE value from -fd-ncat.fits
    fuv_ncat_flux_radius_3 real, --/D FUV FLUX_RADIUS using Aperture
    nuv_kron_radius real, --/D NUV Kron apertures in units of A or B
    nuv_a_world real, --/D NUV profile rms along major axis (world units)
    nuv_b_world real, --/D NUV profile rms along minor axis (world units)
    fuv_kron_radius real, --/D FUV Kron apertures in units of A or B
    fuv_a_world real, --/D FUV profile rms along major axis (world units)
    fuv_b_world real, --/D FUV profile rms along minor axis (world units)
    nuv_weight real, --/U seconds --/D NUV effective exposure (flat-field response value) at the source 
	--/D position
    fuv_weight real, --/U seconds --/D FUV effective exposure (flat-field response value) at the source 
	--/D position
    prob real, --/D Probability of the FUV-NUV cross-match
    sep real, --/D Separation between the FUV and NUV position of the source in the same 
	--/D observation
    nuv_poserr real, --/U arcsec --/D Position error of the source in the NUV image
    fuv_poserr real, --/U arcsec --/D Position error of the source in the FUV image
    ib_poserr real, --/U arcsec --/D Inter-band position error
    nuv_pperr real, --/D NUV Poisson position error
    fuv_pperr real, --/D FUV Poisson position error
    corv text, --/D Whether the source comes from a coadd or visit
    grank smallint, --/D rank of source with 2.5 arcsec of primary
    ngrank smallint, --/D If this is a primary, the number of sources within 2.5 arcsec
    primgid bigint, --/D OBJID of the primary
    groupgid text, --/D OBJID's of all AIS sources within 2.5 arcseconds concatenated by a "+"
    grankdist smallint, --/D Same for GRANK, but based on distance criterion
    ngrankdist bigint, --/D Same for NGRANK, but based on distance criterion
    primgiddist bigint, --/D Same for PRIMGID, but based on distance criterion
    groupgiddist text, --/D Same for GROUPGID, but based on distance criterion
    groupgidtot text, --/D OBJID's of all sources within 2.5 arcseconds
    difffuv real, --/U mag --/D FUV magnitude difference between primary and secondary
    diffnuv real, --/U mag --/D NUV magnitude difference between primary and secondary
    difffuvdist real, --/U mag --/D FUV magnitude difference between primary and secondary, but based on 
	--/D distance criterion
    diffnuvdist real, --/U mag --/D NUV magnitude difference between primary and secondary, but based on 
	--/D distance criterion
    sepas real, --/U arcsec --/D Separation between primary and secondary
    sepasdist real, --/U arcsec --/D Separation between primary and secondary, but based on distance 0
	--/D criterion
    inlargeobj text, --/D Is source in the footprint of an extended object?
    largeobjsize real, --/D Size of the extended object
    fuv_mag_nuv_mag  AS ([fuv_mag]-[nuv_mag]) PERSISTED --/D difference between fuv_mag and nuv_mag
)
GO
--


--
-- Name: mos_instrument; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_instrument')
	DROP TABLE mos_instrument
GO
--
EXEC spSetDefaultFileGroup 'mos_instrument'
GO
CREATE TABLE mos_instrument (

----------------------------------------------------------------------
--/H This table stores the instruments used by SDSS-V.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    label text, --/D The name of the instrument.
    default_lambda_eff real --/U angstrom --/D The default wavelength for which fibre positioning will be optimised
)
GO
--


--
-- Name: mos_legacy_survey_dr8; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_legacy_survey_dr8')
	DROP TABLE mos_legacy_survey_dr8
GO
--
EXEC spSetDefaultFileGroup 'mos_legacy_survey_dr8'
GO
CREATE TABLE mos_legacy_survey_dr8 (

----------------------------------------------------------------------
--/H Legacy Survey DR8 catalogue derived from 'sweep' catalogues.
----------------------------------------------------------------------
--/T See https://www.legacysurvey.org/dr8/.
----------------------------------------------------------------------
    release integer, --/D Unique integer denoting the camera and filter set used (RELEASE 
	--/D documentation: https://www.legacysurvey.org/release/)
    brickid bigint, --/D A unique Brick ID (in the range 1-662174)
    brickname text, --/D Name of brick, encoding the brick sky position, eg "1126p222" near RA=
	--/D 112.6, Dec=+22.2
    objid bigint, --/D Catalog object number within this brick; a unique identifier hash is 
	--/D RELEASE,BRICKID,OBJID; OBJID spans 0 to N-1 and is contiguously enumerated within each blob
    type text, --/D Morphological model: "PSF"=stellar, "REX"="round exponential galaxy" =
	--/D  round EXP galaxy with a variable radius, "EXP"=exponential, "DEV"=deVauc, 
	--/D "COMP"=composite, "DUP"==Gaia source fit by different model. Note that in some 
	--/D FITS readers, a trailing space may be appended for "PSF ", "EXP " and "DEV " since 
	--/D the column data type is a 4-character string
    ra double precision, --/U deg --/D Right ascension at equinox J2000
    [dec] double precision, --/U deg --/D Declination at equinox J2000
    ra_ivar real, --/U 1/deg^2 --/D Inverse variance of RA (no cosine term!), excluding astrometric 
	--/D calibration errors
    dec_ivar real, --/U 1/deg^2 --/D Inverse variance of DEC, excluding astrometric calibration errors
    dchisq_psf real, --/D Difference in chi2 between successively more-complex model fits: PSF. 
	--/D The difference is versus no source.
    dchisq_rex real, --/D Difference in chi2 between successively more-complex model fits: REX. 
	--/D The difference is versus no source.
    dchisq_dev real, --/D Difference in chi2 between successively more-complex model fits: DEV. 
	--/D The difference is versus no source.
    dchisq_exp real, --/D Difference in chi2 between successively more-complex model fits: EXP. 
	--/D The difference is versus no source.
    dchisq_comp real, --/D Difference in chi2 between successively more-complex model fits: COMP.
	--/D  The difference is versus no source.
    ebv real, --/U mag --/D Galactic extinction E(B-V) reddening from SFD98, used to compute 
	--/D MW_TRANSMISSION
    flux_g real, --/U nanomaggies --/D model flux in g
    flux_r real, --/U nanomaggies --/D model flux in r
    flux_z real, --/U nanomaggies --/D model flux in z
    flux_w1 real, --/U nanomaggies --/D WISE model flux in W1 (AB system)
    flux_w2 real, --/U nanomaggies --/D WISE model flux in W2 (AB system)
    flux_w3 real, --/U nanomaggies --/D WISE model flux in W3 (AB system)
    flux_w4 real, --/U nanomaggies --/D WISE model flux in W4 (AB system)
    flux_ivar_g real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_G
    flux_ivar_r real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_R
    flux_ivar_z real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_Z
    flux_ivar_w1 real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_W1 (AB system)
    flux_ivar_w2 real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_W2 (AB system)
    flux_ivar_w3 real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_W3 (AB system)
    flux_ivar_w4 real, --/U 1/nanomaggies^2 --/D Inverse variance of FLUX_W4 (AB system)
    mw_transmission_g real, --/D Galactic transmission in g filter in linear units
    mw_transmission_r real, --/D Galactic transmission in r filter in linear units
    mw_transmission_z real, --/D Galactic transmission in z filter in linear units
    mw_transmission_w1 real, --/D Galactic transmission in W1 filter in linear units
    mw_transmission_w2 real, --/D Galactic transmission in W2 filter in linear units
    mw_transmission_w3 real, --/D Galactic transmission in W3 filter in linear units
    mw_transmission_w4 real, --/D Galactic transmission in W4 filter in linear units
    nobs_g integer, --/D Number of images that contribute to the central pixel in g: filter for
	--/D  this object (not profile-weighted)
    nobs_r integer, --/D Number of images that contribute to the central pixel in r: filter for
	--/D  this object (not profile-weighted)
    nobs_z integer, --/D Number of images that contribute to the central pixel in z: filter for
	--/D  this object (not profile-weighted)
    nobs_w1 integer, --/D Number of images that contribute to the central pixel in W1: filter 
	--/D for this object (not profile-weighted)
    nobs_w2 integer, --/D Number of images that contribute to the central pixel in W2: filter 
	--/D for this object (not profile-weighted)
    nobs_w3 integer, --/D Number of images that contribute to the central pixel in W3: filter 
	--/D for this object (not profile-weighted)
    nobs_w4 integer, --/D Number of images that contribute to the central pixel in W4: filter 
	--/D for this object (not profile-weighted)
    rchisq_g real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels 
	--/D in g
    rchisq_r real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels 
	--/D in r
    rchisq_z real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels 
	--/D in z
    rchisq_w1 real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels 
	--/D in W1
    rchisq_w2 real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels 
	--/D in W2
    rchisq_w3 real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels 
	--/D in W3
    rchisq_w4 real, --/D Profile-weighted chi2 of model fit normalized by the number of pixels 
	--/D in W4
    fracflux_g real, --/D Profile-weighted fraction of the flux from other sources divided by 
	--/D the total flux in g (typically in 0..1)
    fracflux_r real, --/D Profile-weighted fraction of the flux from other sources divided by 
	--/D the total flux in r (typically in 0..1)
    fracflux_z real, --/D Profile-weighted fraction of the flux from other sources divided by 
	--/D the total flux in z (typically in 0..1)
    fracflux_w1 real, --/D Profile-weighted fraction of the flux from other sources divided by 
	--/D the total flux in W1 (typically in 0..1)
    fracflux_w2 real, --/D Profile-weighted fraction of the flux from other sources divided by 
	--/D the total flux in W2 (typically in 0..1)
    fracflux_w3 real, --/D Profile-weighted fraction of the flux from other sources divided by 
	--/D the total flux in W3 (typically in 0..1)
    fracflux_w4 real, --/D Profile-weighted fraction of the flux from other sources divided by 
	--/D the total flux in W4 (typically in 0..1)
    fracmasked_g real, --/D Profile-weighted fraction of pixels masked from all observations of 
	--/D this object in g, strictly between 0..1
    fracmasked_r real, --/D Profile-weighted fraction of pixels masked from all observations of 
	--/D this object in r, strictly between 0..1
    fracmasked_z real, --/D Profile-weighted fraction of pixels masked from all observations of 
	--/D this object in z, strictly between 0..1
    fracin_g real, --/D Fraction of a source's flux within the blob in g, near unity for real 
	--/D sources
    fracin_r real, --/D Fraction of a source's flux within the blob in r, near unity for real 
	--/D sources
    fracin_z real, --/D Fraction of a source's flux within the blob in z, near unity for real 
	--/D sources
    anymask_g integer, --/D Bitwise mask set if the central pixel from any image satisfies each 
	--/D condition in g (see the DR8 bitmasks page)
    anymask_r integer, --/D Bitwise mask set if the central pixel from any image satisfies each 
	--/D condition in r (see the DR8 bitmasks page)
    anymask_z integer, --/D Bitwise mask set if the central pixel from any image satisfies each 
	--/D condition in z (see the DR8 bitmasks page)
    allmask_g integer, --/D Bitwise mask set if the central pixel from all images satisfy each 
	--/D condition in g (see the DR8 bitmasks page)
    allmask_r integer, --/D Bitwise mask set if the central pixel from all images satisfy each 
	--/D condition in r (see the DR8 bitmasks page)
    allmask_z integer, --/D Bitwise mask set if the central pixel from all images satisfy each 
	--/D condition in z (see the DR8 bitmasks page)
    wisemask_w1 smallint, --/D W1 bitmask as cataloged on the DR8 bitmasks page
    wisemask_w2 smallint, --/D W2 bitmask as cataloged on the DR8 bitmasks page
    psfsize_g real, --/U arcsec --/D Weighted average PSF FWHM in the g band
    psfsize_r real, --/U arcsec --/D Weighted average PSF FWHM in the r band
    psfsize_z real, --/U arcsec --/D Weighted average PSF FWHM in the z band
    psfdepth_g real, --/U 1/nanomaggies^2 --/D For a 5σ point source detection limit in g, 5/sqrt(PSFDEPTH_G) 
	--/D gives flux in nanomaggies and -2.5(log10(5/sqrt(PSFDEPTH_G))-9) give corresponding magnitude
    psfdepth_r real, --/U 1/nanomaggies^2 --/D For a 5σ point source detection limit in g, 5/sqrt(PSFDEPTH_R) 
	--/D gives flux in nanomaggies and -2.5(log10(5/sqrt(PSFDEPTH_R))-9) give corresponding magnitude
    psfdepth_z real, --/U 1/nanomaggies^2 --/D For a 5σ point source detection limit in g, 5/sqrt(PSFDEPTH_Z) 
	--/D gives flux in nanomaggies and -2.5(log10(5/sqrt(PSFDEPTH_Z))-9) give corresponding magnitude
    galdepth_g real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_G but for a galaxy (0.45" exp, round) detection 
	--/D sensitivity
    galdepth_r real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_R but for a galaxy (0.45" exp, round) detection 
	--/D sensitivity
    galdepth_z real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_Z but for a galaxy (0.45" exp, round) detection 
	--/D sensitivity
    psfdepth_w1 real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_G (and also on the AB system) but for WISE W1
    psfdepth_w2 real, --/U 1/nanomaggies^2 --/D As for PSFDEPTH_G (and also on the AB system) but for WISE W2
    wise_coadd_id text, --/D unWISE coadd file name for the center of each object
    fracdev real, --/D Fraction of model in deVauc (in range 0..1)
    fracdev_ivar real, --/D Inverse variance of FRACDEV
    shapedev_r real, --/U arcsec --/D Half-light radius of deVaucouleurs model (>0)
    shapedev_r_ivar real, --/U 1/arcsec --/D Inverse variance of SHAPEDEV_R
    shapedev_e1 real, --/D Ellipticity component 1
    shapedev_e1_ivar real, --/D Inverse variance of SHAPEDEV_E1
    shapedev_e2 real, --/D Ellipticity component 2
    shapedev_e2_ivar real, --/D Inverse variance of SHAPEDEV_E2
    shapeexp_r real, --/U acrsec --/D Half-light radius of exponential model (>0)
    shapeexp_r_ivar real, --/U 1/arcsec --/D Inverse variance of SHAPEEXP_R
    shapeexp_e1 real, --/D Ellipticity component 1
    shapeexp_e1_ivar real, --/D Inverse variance of SHAPEEXP_E1
    shapeexp_e2 real, --/D Ellipticity component 2
    shapeexp_e2_ivar real, --/D Inverse variance of SHAPEEXP_E2
    fiberflux_g real, --/U nanomaggies --/D Predicted g-band flux within a fiber of diameter 1.5 arcsec from this 
	--/D object in 1 arcsec Gaussian seeing
    fiberflux_r real, --/U nanomaggies --/D Predicted r-band flux within a fiber of diameter 1.5 arcsec from this 
	--/D object in 1 arcsec Gaussian seeing
    fiberflux_z real, --/U nanomaggies --/D Predicted z-band flux within a fiber of diameter 1.5 arcsec from this 
	--/D object in 1 arcsec Gaussian seeing
    fibertotflux_g real, --/U nanomaggies --/D Predicted g-band flux within a fiber of diameter 1.5 arcsec from 
	--/D all sources at this location in 1 arcsec Gaussian seeing
    fibertotflux_r real, --/U nanomaggies --/D Predicted r-band flux within a fiber of diameter 1.5 arcsec from 
	--/D all sources at this location in 1 arcsec Gaussian seeing
    fibertotflux_z real, --/U nanomaggies --/D Predicted z-band flux within a fiber of diameter 1.5 arcsec from 
	--/D all sources at this location in 1 arcsec Gaussian seeing
    ref_cat text, --/D Reference catalog source for this star: "T2" for Tycho-2, "G2" for Gaia DR2, 
	--/D "L2" for the SGA, empty otherwise
    ref_id bigint, --/D Reference catalog identifier for this star; Tyc1*1,000,000+Tyc2*10+Tyc3 
	--/D for Tycho2; "sourceid" for Gaia-DR2 and SGA
    ref_epoch real, --/U yr --/D Reference catalog reference epoch (eg, 2015.5 for Gaia DR2)
    gaia_phot_g_mean_mag real, --/U mag --/D Gaia G band magnitude, Vega
    gaia_phot_g_mean_flux_over_error real, --/D Gaia G band magnitude signal-to-noise
    gaia_phot_bp_mean_mag real, --/U mag --/D Gaia BP band magnitude, Vega
    gaia_phot_bp_mean_flux_over_error real, --/D Gaia BP band magnitude signal-to-noise
    gaia_phot_rp_mean_mag real, --/U mag --/D Gaia RP band magnitude, Vega
    gaia_phot_rp_mean_flux_over_error real, --/D Gaia RP band magnitude signal-to-noise
    gaia_astrometric_excess_noise real, --/D Gaia astrometric excess noise
    gaia_duplicated_source bit, --/D Gaia duplicated source flag (1/0 for True/False)
    gaia_phot_bp_rp_excess_factor real, --/D Gaia BP/RP excess factor
    gaia_astrometric_sigma5d_max real, --/U mas --/D Gaia longest semi-major axis of the 5-d error ellipsoid
    gaia_astrometric_params_solved smallint, --/D Which astrometric parameters were estimated for a Gaia source
    parallax real, --/U mas --/D Reference catalog parallax
    parallax_ivar real, --/U 1/mas^2 --/D Reference catalog inverse-variance on parallax
    pmra real, --/U mas/yr --/D Reference catalog proper motion in the RA direction
    pmra_ivar real, --/U 1/(mas/yr)^2 --/D Reference catalog inverse-variance on pmra
    pmdec real, --/U mas/yr --/D Reference catalog proper motion in the Dec direction
    pmdec_ivar real, --/U 1/(mas/yr)^2 --/D Reference catalog inverse-variance on pmdec
    maskbits integer, --/D Bitwise mask indicating that an object touches a pixel in the 
	--/D coadd/*/*/*maskbits* maps (see the DR8 bitmasks page)
    ls_id bigint NOT NULL, --/D Added by SDSS-V: Derived unique object identifier. Computed as follows: 
	--/D ls_id = objid + (brickid << 16) + (release << 40)
    tycho_ref bigint, --/D Added by SDSS-V: TychoII identifier (equal to ref_id when ref_cat = "T2")
    gaia_sourceid bigint --/D Added by SDSS-V: Gaia DR2 source_id identifier (equal to ref_id when 
	--/D ref_cat = "G2")
)
GO
--


--
-- Name: mos_magnitude; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_magnitude')
	DROP TABLE mos_magnitude
GO
--
EXEC spSetDefaultFileGroup 'mos_magnitude'
GO
CREATE TABLE mos_magnitude (

----------------------------------------------------------------------
--/H This table stores magnitude information for a target. 
----------------------------------------------------------------------
--/T Optical magnitudes that are not selected from SDSS photometry 
--/T have been converted to the SDSS system.
----------------------------------------------------------------------
    carton_to_target_pk integer, --/D The primary key of the target in the mos_carton_to_target table.
    magnitude_pk bigint NOT NULL, --/D The primary key. A sequential identifier.
    g real, --/D The optical g magnitude.
    r real, --/D The optical r magnitude.
    i real, --/D The optical i magnitude.
    h real, --/D The IR H magnitude.
    bp real, --/D The Gaia BP magnitude.
    rp real, --/D The Gaia RP magnitude.
    z real, --/D The optical z magnitude.
    j real, --/D The IR J magnitude.
    k real, --/D The IR K magnitude.
    gaia_g real, --/D The Gaia G magnitude.
    optical_prov text --/D The source of the optical magnitudes.
)
GO
--


--
-- Name: mos_mapper; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_mapper')
	DROP TABLE mos_mapper
GO
--
EXEC spSetDefaultFileGroup 'mos_mapper'
GO
CREATE TABLE mos_mapper (

----------------------------------------------------------------------
--/H This table stores the names of the mappers associated with
--/H cartons in mos_carton.
----------------------------------------------------------------------
    pk integer NOT NULL, --/D The primary key. A sequential identifier.
    label text --/D The name of the mapper.
)
GO
--


--
-- Name: mos_panstarrs1; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_panstarrs1')
	DROP TABLE mos_panstarrs1
GO
--
EXEC spSetDefaultFileGroup 'mos_panstarrs1'
GO
CREATE TABLE mos_panstarrs1 (

----------------------------------------------------------------------
--/H A copy of the PanSTARRS1-dr2 catalogue provided by E. Magnier. 
----------------------------------------------------------------------
--/T Based on the internal IPP database representation mainyaned by 
--/T IfA, U. Hawaii. Column names may differ from publically available
--/T catalogues hosted at MAST (mapping provided in column descriptions).
--/T The SDSS-V copy of this database is derived from a combination of 
--/T the PS1-dr2 StackObjectThin and ObjectThin tables
--/T (https://outerspace.stsci.edu/display/PANSTARRS/PS1+Database+object+and+detection+tables).
--/T The catalogue contains PSF, Kron, and Aper measurements based on
--/T stacked and forced warp photometry, and expressed as fluxes, 
--/T including measurements are made of low-significance detections. 
--/T The average exposure (chip) measurements are expressed in magnitudes
--/T since photometry is not measured at this stage for sources with 
--/T S/N < 5, so there should not be any negative fluxes. Magnitudes 
--/T are on the AB system, fluxes are in Janskys. Conversion to AB 
--/T mags is via: mag = 8.9 - 2.5*log10(flux).
----------------------------------------------------------------------
    ra double precision, --/U deg --/D mean RA, (J2000, tied to Gaia DR1)
    [dec] double precision, --/U deg --/D mean Dec, (J2000, tied to Gaia DR1)
    dra real, --/U arcsec --/D error on RA
    ddec real, --/U arcsec --/D error on DEC
    tmean real, --/U days --/D Mean epoch (MJD)
    trange real, --/U days --/D Time range -- may include 2MASS values
    chisqpos real, --/D chi-square of a fixed position astrometry solution (equiv to 
	--/D ObjectThin.posMeanChisq)
    stargal real, --/D Measure of extendedness. Computed as the median across all chip measurements 
	--/D of extNsigma, where extNsigma = (PSF mag - Kron mag) expressed as a number of sigmas, 
	--/D so it somewhat adjusts for the spread at low signal-to-noise.
    nmeas integer, --/D total number of measurements in databases (including non-PS1 data)
    nwarp_ok integer, --/D number of warps with psf_qf > 0 (any unmasked pixels)
    flags integer, --/D ObjectInfoFlags
    objid integer, --/D internal Pan-STARRS IPP object ID : unique within database spatial 
	--/D partition (see catID)
    catid integer, --/D database spatial partition ID - (equiv. to StackObjectThin.dvoRegionID)
    extid_hi integer, --/D upper 32 bits of PSPS object ID (objID in MAST PSPS database)
    extid_lo integer, --/D lower 32 bits of PSPS object ID (objID in MAST PSPS database)
    g_chp_psf real, --/U mag --/D mean g-band chip PSF magnitude
    g_chp_psf_err real, --/U mag --/D error on mean g-band chip PSF magnitude
    g_chp_psf_nphot integer, --/D number of measurements used for g_chp_psf (excluding outliers)
    g_chp_aper real, --/U mag --/D mean g-band chip seeing-adapted aperture magnitude
    g_chp_aper_err real, --/U mag --/D error on mean g-band chip seeing-adapted aperture magnitude
    g_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    g_chp_kron real, --/U mag --/D mean g-band chip Kron magnitude
    g_chp_kron_err real, --/U mag --/D error on mean g-band chip Kron magnitude
    g_chp_kron_nphot integer, --/D number of measurements used for g_chp_kron (excluding outliers)
    g_stk_psf_flux real, --/U Jy --/D best g-band stack PSF flux
    g_stk_psf_fluxerr real, --/U Jy --/D error on best g-band stack PSF flux
    g_stk_psf_nphot integer, --/D number of measurements used for g_stk_psf_flux (excluding outliers)
    g_stk_aper_flux real, --/U Jy --/D g-band stack seeing-adapted aperture flux
    g_stk_aper_fluxerr real, --/U Jy --/D error on g-band stack seeing-adapted aperture flux
    g_stk_aper_nphot integer, --/D number of measurements used for g_stk_aper_flux (excluding outliers)
    g_stk_kron_flux real, --/U Jy --/D g-band stack Kron flux from same stack as 'best' PSF above
    g_stk_kron_fluxerr real, --/U Jy --/D error on g-band stack Kron flux from same stack as 'best' PSF above
    g_stk_kron_nphot integer, --/D number of measurements used for g_stk_kron_flux (excluding outliers)
    g_wrp_psf_flux real, --/U Jy --/D mean g-band forced-warp PSF flux
    g_wrp_psf_fluxerr real, --/U Jy --/D error on mean g-band forced-warp PSF flux
    g_wrp_psf_nphot integer, --/D number of measurements used for g_wrp_psf_flux (excluding outliers)
    g_wrp_aper_flux real, --/U Jy --/D mean g-band forced-warp seeing-adapted aperture flux
    g_wrp_aper_fluxerr real, --/U Jy --/D error on mean g-band forced-warp seeing-adapted aperture flux
    g_wrp_aper_nphot integer, --/D number of measurements used for g_wrp_aper_flux (excluding outliers)
    g_wrp_kron_flux real, --/U Jy --/D mean g-band forced-warp Kron flux
    g_wrp_kron_fluxerr real, --/U Jy --/D error on mean g-band forced-warp Kron flux
    g_wrp_kron_nphot integer, --/D number of measurements used for g_wrp_kron_flux (excluding outliers)
    g_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.ginfoFlag4)
    g_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.ng)
    g_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary 
	--/D skycells)
    g_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter 
	--/D (including primary & secondary skycells)
    g_nstack integer, --/D number of stack measurements (primary and secondary)
    g_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    g_psfqf real, --/D g-band PSF coverage factor
    g_psfqfperf real, --/D g-band PSF weighted fraction of pixels totally unmasked
    r_chp_psf real, --/U mag --/D mean r-band chip PSF magnitude
    r_chp_psf_err real, --/U mag --/D error on mean r-band chip PSF magnitude
    r_chp_psf_nphot integer, --/D number of measurements used for r_chp_psf (excluding outliers)
    r_chp_aper real, --/U mag --/D mean r-band chip seeing-adapted aperture magnitude
    r_chp_aper_err real, --/U mag --/D error on mean r-band chip seeing-adapted aperture magnitude
    r_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    r_chp_kron real, --/U mag --/D mean r-band chip Kron magnitude
    r_chp_kron_err real, --/U mag --/D error on mean r-band chip Kron magnitude
    r_chp_kron_nphot integer, --/D number of measurements used for r_chp_kron (excluding outliers)
    r_stk_psf_flux real, --/U Jy --/D best r-band stack PSF flux
    r_stk_psf_fluxerr real, --/U Jy --/D error on best r-band stack PSF flux
    r_stk_psf_nphot integer, --/D number of measurements used for r_stk_psf_flux (excluding outliers)
    r_stk_aper_flux real, --/U Jy --/D r-band stack seeing-adapted aperture flux
    r_stk_aper_fluxerr real, --/U Jy --/D error on r-band stack seeing-adapted aperture flux
    r_stk_aper_nphot integer, --/D number of measurements used for r_stk_aper_flux (excluding outliers)
    r_stk_kron_flux real, --/U Jy --/D r-band stack Kron flux from same stack as 'best' PSF above
    r_stk_kron_fluxerr real, --/U Jy --/D error on r-band stack Kron flux from same stack as 'best' PSF above
    r_stk_kron_nphot integer, --/D number of measurements used for r_stk_kron_flux (excluding outliers)
    r_wrp_psf_flux real, --/U Jy --/D mean r-band forced-warp PSF flux
    r_wrp_psf_fluxerr real, --/U Jy --/D error on mean r-band forced-warp PSF flux
    r_wrp_psf_nphot integer, --/D number of measurements used for r_wrp_psf_flux (excluding outliers)
    r_wrp_aper_flux real, --/U Jy --/D mean r-band forced-warp seeing-adapted aperture flux
    r_wrp_aper_fluxerr real, --/U Jy --/D error on mean r-band forced-warp seeing-adapted aperture flux
    r_wrp_aper_nphot integer, --/D number of measurements used for r_wrp_aper_flux (excluding outliers)
    r_wrp_kron_flux real, --/U Jy --/D mean r-band forced-warp Kron flux
    r_wrp_kron_fluxerr real, --/U Jy --/D error on mean r-band forced-warp Kron flux
    r_wrp_kron_nphot integer, --/D number of measurements used for r_wrp_kron_flux (excluding outliers)
    r_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.rinfoFlag4)
    r_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.nr)
    r_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary 
	--/D skycells)
    r_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter 
	--/D (including primary & secondary skycells)
    r_nstack integer, --/D number of stack measurements (primary and secondary)
    r_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    r_psfqf real, --/D r-band PSF coverage factor
    r_psfqfperf real, --/D r-band PSF weighted fraction of pixels totally unmasked
    i_chp_psf real, --/U mag --/D mean i-band chip PSF magnitude
    i_chp_psf_err real, --/U mag --/D error on mean i-band chip PSF magnitude
    i_chp_psf_nphot integer, --/D number of measurements used for i_chp_psf (excluding outliers)
    i_chp_aper real, --/U mag --/D mean i-band chip seeing-adapted aperture magnitude
    i_chp_aper_err real, --/U mag --/D error on mean i-band chip seeing-adapted aperture magnitude
    i_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    i_chp_kron real, --/U mag --/D mean i-band chip Kron magnitude
    i_chp_kron_err real, --/U mag --/D error on mean i-band chip Kron magnitude
    i_chp_kron_nphot integer, --/D number of measurements used for i_chp_kron (excluding outliers)
    i_stk_psf_flux real, --/U Jy --/D best i-band stack PSF flux
    i_stk_psf_fluxerr real, --/U Jy --/D error on best i-band stack PSF flux
    i_stk_psf_nphot integer, --/D number of measurements used for i_stk_psf_flux (excluding outliers)
    i_stk_aper_flux real, --/U Jy --/D i-band stack seeing-adapted aperture flux
    i_stk_aper_fluxerr real, --/U Jy --/D error on i-band stack seeing-adapted aperture flux
    i_stk_aper_nphot integer, --/D number of measurements used for i_stk_aper_flux (excluding outliers)
    i_stk_kron_flux real, --/U Jy --/D i-band stack Kron flux from same stack as 'best' PSF above
    i_stk_kron_fluxerr real, --/U Jy --/D error on i-band stack Kron flux from same stack as 'best' PSF above
    i_stk_kron_nphot integer, --/D number of measurements used for i_stk_kron_flux (excluding outliers)
    i_wrp_psf_flux real, --/U Jy --/D mean i-band forced-warp PSF flux
    i_wrp_psf_fluxerr real, --/U Jy --/D error on mean i-band forced-warp PSF flux
    i_wrp_psf_nphot integer, --/D number of measurements used for i_wrp_psf_flux (excluding outliers)
    i_wrp_aper_flux real, --/U Jy --/D mean i-band forced-warp seeing-adapted aperture flux
    i_wrp_aper_fluxerr real, --/U Jy --/D error on mean i-band forced-warp seeing-adapted aperture flux
    i_wrp_aper_nphot integer, --/D number of measurements used for i_wrp_aper_flux (excluding outliers)
    i_wrp_kron_flux real, --/U Jy --/D mean i-band forced-warp Kron flux
    i_wrp_kron_fluxerr real, --/U Jy --/D error on mean i-band forced-warp Kron flux
    i_wrp_kron_nphot integer, --/D number of measurements used for i_wrp_kron_flux (excluding outliers)
    i_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.iinfoFlag4)
    i_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.ni)
    i_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary 
	--/D skycells)
    i_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter 
	--/D (including primary & secondary skycells)
    i_nstack integer, --/D number of stack measurements (primary and secondary)
    i_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    i_psfqf real, --/D i-band PSF coverage factor
    i_psfqfperf real, --/D i-band PSF weighted fraction of pixels totally unmasked
    z_chp_psf real, --/U mag --/D mean z-band chip PSF magnitude
    z_chp_psf_err real, --/U mag --/D error on mean z-band chip PSF magnitude
    z_chp_psf_nphot integer, --/D number of measurements used for z_chp_psf (excluding outliers)
    z_chp_aper real, --/U mag --/D mean z-band chip seeing-adapted aperture magnitude
    z_chp_aper_err real, --/U mag --/D error on mean z-band chip seeing-adapted aperture magnitude
    z_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    z_chp_kron real, --/U mag --/D mean z-band chip Kron magnitude
    z_chp_kron_err real, --/U mag --/D error on mean z-band chip Kron magnitude
    z_chp_kron_nphot integer, --/D number of measurements used for z_chp_kron (excluding outliers)
    z_stk_psf_flux real, --/U Jy --/D best z-band stack PSF flux
    z_stk_psf_fluxerr real, --/U Jy --/D error on best z-band stack PSF flux
    z_stk_psf_nphot integer, --/D number of measurements used for z_stk_psf_flux (excluding outliers)
    z_stk_aper_flux real, --/U Jy --/D z-band stack seeing-adapted aperture flux
    z_stk_aper_fluxerr real, --/U Jy --/D error on z-band stack seeing-adapted aperture flux
    z_stk_aper_nphot integer, --/D number of measurements used for z_stk_aper_flux (excluding outliers)
    z_stk_kron_flux real, --/U Jy --/D z-band stack Kron flux from same stack as 'best' PSF above
    z_stk_kron_fluxerr real, --/U Jy --/D error on z-band stack Kron flux from same stack as 'best' PSF above
    z_stk_kron_nphot integer, --/D number of measurements used for z_stk_kron_flux (excluding outliers)
    z_wrp_psf_flux real, --/U Jy --/D mean z-band forced-warp PSF flux
    z_wrp_psf_fluxerr real, --/U Jy --/D error on mean z-band forced-warp PSF flux
    z_wrp_psf_nphot integer, --/D number of measurements used for z_wrp_psf_flux (excluding outliers)
    z_wrp_aper_flux real, --/U Jy --/D mean z-band forced-warp seeing-adapted aperture flux
    z_wrp_aper_fluxerr real, --/U Jy --/D error on mean z-band forced-warp seeing-adapted aperture flux
    z_wrp_aper_nphot integer, --/D number of measurements used for z_wrp_aper_flux (excluding outliers)
    z_wrp_kron_flux real, --/U Jy --/D mean z-band forced-warp Kron flux
    z_wrp_kron_fluxerr real, --/U Jy --/D error on mean z-band forced-warp Kron flux
    z_wrp_kron_nphot integer, --/D number of measurements used for z_wrp_kron_flux (excluding outliers)
    z_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.zinfoFlag4)
    z_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.nz)
    z_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary 
	--/D skycells)
    z_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter 
	--/D (including primary & secondary skycells)
    z_nstack integer, --/D number of stack measurements (primary and secondary)
    z_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    z_psfqf real, --/D z-band PSF coverage factor
    z_psfqfperf real, --/D z-band PSF weighted fraction of pixels totally unmasked
    y_chp_psf real, --/U mag --/D mean y-band chip PSF magnitude
    y_chp_psf_err real, --/U mag --/D error on mean y-band chip PSF magnitude
    y_chp_psf_nphot integer, --/D number of measurements used for y_chp_psf (excluding outliers)
    y_chp_aper real, --/U mag --/D mean y-band chip seeing-adapted aperture magnitude
    y_chp_aper_err real, --/U mag --/D error on mean y-band chip seeing-adapted aperture magnitude
    y_chp_aper_nphot integer, --/D number of measurements used for above (excluding outliers)
    y_chp_kron real, --/U mag --/D mean y-band chip Kron magnitude
    y_chp_kron_err real, --/U mag --/D error on mean y-band chip Kron magnitude
    y_chp_kron_nphot integer, --/D number of measurements used for y_chp_kron (excluding outliers)
    y_stk_psf_flux real, --/U Jy --/D best y-band stack PSF flux
    y_stk_psf_fluxerr real, --/U Jy --/D error on best y-band stack PSF flux
    y_stk_psf_nphot integer, --/D number of measurements used for y_stk_psf_flux (excluding outliers)
    y_stk_aper_flux real, --/U Jy --/D y-band stack seeing-adapted aperture flux
    y_stk_aper_fluxerr real, --/U Jy --/D error on y-band stack seeing-adapted aperture flux
    y_stk_aper_nphot integer, --/D number of measurements used for y_stk_aper_flux (excluding outliers)
    y_stk_kron_flux real, --/U Jy --/D y-band stack Kron flux from same stack as 'best' PSF above
    y_stk_kron_fluxerr real, --/U Jy --/D error on y-band stack Kron flux from same stack as 'best' PSF above
    y_stk_kron_nphot integer, --/D number of measurements used for y_stk_kron_flux (excluding outliers)
    y_wrp_psf_flux real, --/U Jy --/D mean y-band forced-warp PSF flux
    y_wrp_psf_fluxerr real, --/U Jy --/D error on mean y-band forced-warp PSF flux
    y_wrp_psf_nphot integer, --/D number of measurements used for y_wrp_psf_flux (excluding outliers)
    y_wrp_aper_flux real, --/U Jy --/D mean y-band forced-warp seeing-adapted aperture flux
    y_wrp_aper_fluxerr real, --/U Jy --/D error on mean y-band forced-warp seeing-adapted aperture flux
    y_wrp_aper_nphot integer, --/D number of measurements used for y_wrp_aper_flux (excluding outliers)
    y_wrp_kron_flux real, --/U Jy --/D mean y-band forced-warp Kron flux
    y_wrp_kron_fluxerr real, --/U Jy --/D error on mean y-band forced-warp Kron flux
    y_wrp_kron_nphot integer, --/D number of measurements used for y_wrp_kron_flux (excluding outliers)
    y_flags integer, --/D per-filter info flags (equiv. to StackObjectThin.yinfoFlag4)
    y_ncode integer, --/D number of chip detections in this filter (equiv. to StackObjectThin.ny)
    y_nwarp integer, --/D number of warp measurements in this filter (including primary & secondary 
	--/D skycells)
    y_nwarp_good integer, --/D number of warp measurements with psfqfperf > 0.85 in this filter 
	--/D (including primary & secondary skycells)
    y_nstack integer, --/D number of stack measurements (primary and secondary)
    y_nstack_det integer, --/D number of stack detections (S/N > 5, primary and secondary)
    y_psfqf real, --/D y-band PSF coverage factor
    y_psfqfperf real, --/D y-band PSF weighted fraction of pixels totally unmasked
    catid_objid bigint NOT NULL, --/D computed as (catid << 32) & objid. Equivalent to 
	--/D StackObjectThin.ippObjID
    extid_hi_lo bigint --/D computed as (extid_hi << 32) & extid_lo. Equivalent to 
	--/D StackObjectThin.ObjID
)
GO
--


--
-- Name: mos_sagitta; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_sagitta')
	DROP TABLE mos_sagitta
GO
--
EXEC spSetDefaultFileGroup 'mos_sagitta'
GO
CREATE TABLE mos_sagitta (

----------------------------------------------------------------------
--/H Catalog of pre-main-sequence stars derived from Gaia DR2 and 
--/H 2MASS from McBride et al. (2021), their Table 4.
----------------------------------------------------------------------
--/T For complete details, please see the original paper: 
--/T https://iopscience.iop.org/article/10.3847/1538-3881/ac2432
----------------------------------------------------------------------
    source_id bigint NOT NULL, --/D Gaia DR2 unique identifier
    ra double precision, --/U degrees --/D Right ascension
    [dec] double precision, --/U degrees --/D Declination
    av real, --/U mag --/D Predicted extinction
    yso real, --/D Pre-main-sequence probability
    yso_std real, --/D Error on pre-main-sequence probability
    age real, --/U log yrs --/D Age
    age_std real --/U log yrs --/D Error on age
)
GO
--


--
-- Name: mos_sdss_apogeeallstarmerge_r13; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_sdss_apogeeallstarmerge_r13')
	DROP TABLE mos_sdss_apogeeallstarmerge_r13
GO
--
EXEC spSetDefaultFileGroup 'mos_sdss_apogeeallstarmerge_r13'
GO
CREATE TABLE mos_sdss_apogeeallstarmerge_r13 (

----------------------------------------------------------------------
--/H List of APOGEE DR16 stars for RV followup
----------------------------------------------------------------------
    apogee_id text NOT NULL, --/D 2MASS style ID from APOGEE DR16
    nvisits smallint, --/D Number of visits into combined spectra, accross all allStar entries 
	--/D for the star
    nentries integer, --/D Number of unique allStar entries for the star
    ra double precision, --/U degrees --/D Right ascension (J2000)
    [dec] double precision, --/U degrees --/D Declination (J2000)
    glon double precision, --/U degrees --/D Galactic longitude
    glat double precision, --/U degrees --/D Galactic latitude
    pmra double precision, --/U mas/yr --/D proper motion in RA
    pmdec double precision, --/U mas/yr --/D proper motion in DEC
    pm_src text, --/D source of proper motion (e.g. gaia)
    j real, --/U bad=99] [mag --/D 2MASS J mag
    j_err real, --/U mag --/D Uncertainty in 2MASS J mag
    h real, --/U bad=99] [mag --/D 2MASS H mag
    h_err real, --/U mag --/D Uncertainty in 2MASS H mag
    k real, --/U bad=99] [mag --/D 2MASS Ks mag
    k_err real, --/U mag --/D Uncertainty in 2MASS Ks mag
    ak real, --/U mag --/D K-band extinction adopted for targetting
    vhelio_avg real, --/U km/s --/D Average radial velocity, weighted by S/N, rederived to reflect all 
	--/D entries
    vhelio_err real, --/U km/s --/D Uncertainty in VHELIO_AVG from the S/N-weighted individual RVs, 
	--/D rederived to reflect all entries
    vscatter real, --/U km/s --/D Scatter of individual visit RVs around average, rederived to reflect 
	--/D all entries
    sig_rvvar real, --/D Measure of the significance of the star's RV variability (see Troup, et. al 2016)
    baseline real, --/U days --/D Temporal baseline of the observations (JD_last-JD-first)
    mean_fiber real, --/D The mean fiberID of all of the star's visits
    sig_fiber real, --/D The standard deviation of the fiberID of all of the star's visits
    apstar_ids text, --/D List of APSTAR_ID from each of the star's allStar entries
    visits text, --/D List of VISIT_ID from eeach of the star's allVisit entries
    fields text, --/D List of FIELD flags from each of the star's allStar entries
    surveys text, --/D List of SURVEY flags from each of the star's allStar entries
    telescopes text, --/D List of TELESCOPE flags from each of the star's allStar entries
    targflags text, --/D Verbose/text form of TARGFLAG combined from all entries
    starflags text, --/D Verbose/text form of STARFLAG combined from all entries
    aspcapflags text, --/D Verbose/text form of ASPCAPFLAG combined from all entries
    teff real, --/U K --/D Teff from ASPCAP analysis of combined spectra (from PARAM) averaged 
	--/D across entries
    teff_err real, --/U K --/D Teff uncertainty (from PARAM_COV)
    logg real, --/U dex --/D log g from ASPCAP analysis of combined spectrum (from PARAM) averaged 
	--/D across entries
    logg_err real, --/U dex --/D log g uncertainty (from PARAM_COV)
    feh real, --/U dex --/D metallicity from ASPCAP analysis of combined spectrum (from PARAM) 
	--/D averaged across entries
    feh_err real, --/U dex --/D feh uncertainty (from PARAM_COV)
    startype text, --/D Best guess of star's evolutionary state based on stellar parameters or
	--/D  external catalogs (RC=red clump, RG=red giant, SG = subgiant, MS=dwarf, PMS=pre-main 
	--/D sequence)
    vjitter real, --/U km/s --/D Atmospheric RV jitter derived from log g using the relationship derived
	--/D  in Hekker, et. al 2008.
    dist real, --/U pc --/D Derived or given distance to the star
    dist_err real, --/U pc --/D uncertainy of the distance
    dist_src text, --/D Source of the star's distance measurement (e.g. gaia=derived from gaia
	--/D  parallax)
    mstar real, --/D Derived or given stellar mass (Solar Mass)
    mstar_err real, --/U Solar Mass --/D Uncertainty of the Derived stellar mass
    rstar real, --/U Solar Radius --/D Derived stellar radius
    rstar_err real, --/U Solar Radius --/D Uncertainty of the Derived stellar radius
    mstar_src text, --/D Source of the star's Mass (if not derived)
    designation text --/D identifier
)
GO
--


--
-- Name: mos_sdss_dr13_photoobj_primary; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_sdss_dr13_photoobj_primary')
	DROP TABLE mos_sdss_dr13_photoobj_primary
GO
--
EXEC spSetDefaultFileGroup 'mos_sdss_dr13_photoobj_primary'
GO
CREATE TABLE mos_sdss_dr13_photoobj_primary (

----------------------------------------------------------------------
--/H Columns from the PhotoPrimary Table of SDSS DR13.
----------------------------------------------------------------------
    objid bigint NOT NULL, --/D Unique SDSS identifier composed from skyVersion,rerun,
	--/D run,camcol,field,obj
    ra double precision, --/U degrees --/D Right ascension
    [dec] double precision --/U degrees --/D Declination
)
GO
--


--
-- Name: mos_sdss_dr16_qso; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_sdss_dr16_qso')
	DROP TABLE mos_sdss_dr16_qso
GO
--
EXEC spSetDefaultFileGroup 'mos_sdss_dr16_qso'
GO
CREATE TABLE mos_sdss_dr16_qso (

----------------------------------------------------------------------
--/H SDSS Data Release 16 Quasar Catalog (Lyke et al. 2020). 
----------------------------------------------------------------------
--/T For complete details, please see the original paper: 
--/T https://ui.adsabs.harvard.edu/abs/2020ApJS..250....8L/abstract
--/T Description derived from SDSS datamodel:
--/T https://data.sdss.org/datamodel/files/BOSS_QSO/DR16Q/DR16Q_v4.html
----------------------------------------------------------------------
    sdss_name text, --/D SDSS-DR16 designation (hhmmss.ss+-ddmmss.s, J2000)
    ra double precision, --/U degrees --/D Right ascension in decimal degrees (J2000)
    [dec] double precision, --/U degrees --/D Declination in decimal degrees (J2000)
    plate integer, --/D Spectroscopic plate number
    mjd integer, --/U day --/D Modified Julian day of the spectroscopic observation
    fiberid integer, --/D Fiber ID number
    autoclass_pqn text, --/D Object classification post-QuasarNET
    autoclass_dr14q text, --/D Object classification based only on the DR14Q algorithm
    is_qso_qn integer, --/D Binary flag for QuasarNET quasar identification
    z_qn double precision, --/D Systemic redshift from QuasarNET
    random_select integer, --/D Binary flag indicating objects selected for random visual inspection
    z_10k double precision, --/D Redshift from visual inspection in random set
    z_conf_10k integer, --/D Confidence rating for visual inspection redshift in random set
    pipe_corr_10k integer, --/D Binary flag indicating if the automated pipeline classification and 
	--/D redshift were correct in the random set
    is_qso_10k integer, --/D Binary flag for random set quasar identification
    thing_id bigint, --/D SDSS identifier
    z_vi double precision, --/D Visual inspection redshift
    z_conf integer, --/D Confidence rating for visual inspection redshift
    class_person integer, --/D Object classification from visual inspection
    z_dr12q double precision, --/D Redshift taken from DR12Q visual inspection
    is_qso_dr12q integer, --/D Flag indicating if an object was a quasar in DR12Q
    z_dr7q_sch double precision, --/D Redshift taken from DR7Q Schneider et al (2010) catalog
    is_qso_dr7q integer, --/D Flag indicating if an object was a quasar in DR7Q
    z_dr6q_hw double precision, --/D Redshift taken from DR6-based Hewett and Wild (2010) catalog
    z_dr7q_hw double precision, --/D Redshift using Hewett and Wild (2010) updates for DR7Q sources from 
	--/D the Shen et al. (2011) catalog
    is_qso_final integer, --/D Flag indicating quasars to be included in final catalog
    z double precision, --/D Best available redshift taken from Z_VI, Z_PIPE, Z_DR12Q, Z_DR7Q_SCH, 
	--/D Z_DR6Q_HW, and Z_10K
    source_z text, --/D Origin of the reported redshift in Z
    z_pipe double precision, --/D SDSS automated pipeline redshift
    zwarning integer, --/D Quality flag on the pipeline redshift estimate
    objid text, --/D SDSS object identification number
    z_pca double precision, --/D PCA-derived systemic redshift from redvsblue
    zwarn_pca bigint, --/D Warning flag for redvsblue redshift
    deltachi2_pca double precision, --/D Delta χ2 for PCA redshift vs. cubic continuum fit
    z_halpha double precision, --/D PCA line redshift for Halpha from redvsblue
    zwarn_halpha bigint, --/D Warning flag for Halpha redshift
    deltachi2_halpha double precision, --/D Delta χ2 for Halpha line redshift vs. cubic continuum fit
    z_hbeta double precision, --/D PCA line redshift for Hbeta from redvsblue
    zwarn_hbeta bigint, --/D Warning flag for Hbeta redshift
    deltachi2_hbeta double precision, --/D Delta χ2 for Hbeta line redshift vs. cubic continuum fit
    z_mgii double precision, --/D PCA line redshift for Mg II 2799AA from redvsblue
    zwarn_mgii bigint, --/D Warning flag for Mg II 2799AA redshift
    deltachi2_mgii double precision, --/D Delta χ2 for Mg II 2799AA line redshift vs. cubic continuum fit
    z_ciii double precision, --/D PCA line redshift for C III] 1908AA from redvsblue
    zwarn_ciii bigint, --/D Warning flag for C III] 1908AA redshift
    deltachi2_ciii double precision, --/D Delta χ2 for C III] 1908AA line redshift vs. cubic continuum fit
    z_civ double precision, --/D PCA line redshift for C IV 1549AA from redvsblue
    zwarn_civ bigint, --/D Warning flag for C IV 1549AA redshift
    deltachi2_civ double precision, --/D Delta χ2 for C IV 1549AA line redshift vs. cubic continuum fit
    z_lya double precision, --/D PCA line redshift for Lyalpha from redvsblue
    zwarn_lya bigint, --/D Warning flag for Lyalpha redshift
    deltachi2_lya double precision, --/D Delta χ2 for Lyalpha line redshift vs. cubic continuum fit
    z_lyawg real, --/D PCA systemic redshift from redvsblue with a masked Lyalpha emission line and forest
    z_dla text, --/D Redshift for damped Lyalpha features
    nhi_dla text, --/U log(cm**-2) --/D Absorber column density for damped Lyalpha features
    conf_dla text, --/D Confidence of detection for damped Lyalpha features
    bal_prob real, --/D BAL probability
    bi_civ double precision, --/U km/s --/D BALnicity index for C IV 1549AA region
    err_bi_civ double precision, --/U km/s --/D Uncertainty of BI for C IV 1549AA region
    ai_civ double precision, --/U km/s --/D Absorption index for C IV 1549AA region
    err_ai_civ double precision, --/U km/s --/D Uncertainty of absorption index for C IV 1549AA region
    bi_siiv double precision, --/U km/s --/D BALnicity index for Si IV 1396AA region
    err_bi_siiv double precision, --/U km/s --/D Uncertainty of BI for Si IV 1396AA region
    ai_siiv double precision, --/U km/s --/D Absorption index for Si IV 1396AA region
    err_ai_siiv double precision, --/U km/s --/D Uncertainty of absorption index for Si IV 1396AA region
    boss_target1 bigint, --/D BOSS target selection bitmask for main survey
    eboss_target0 bigint, --/D Target selection bitmask for the eBOSS pilot survey (SEQUELS)
    eboss_target1 bigint, --/D eBOSS target selection bitmask
    eboss_target2 bigint, --/D eBOSS target selection bitmask
    ancillary_target1 bigint, --/D BOSS target selection bitmask for ancillary programs
    ancillary_target2 bigint, --/D BOSS target selection bitmask for ancillary programs
    nspec_sdss integer, --/D Number of additional observations from SDSS-I/II
    nspec_boss integer, --/D Number of additional observations from BOSS/eBOSS
    nspec integer, --/D Total number of additional observations
    plate_duplicate text, --/D Spectroscopic plate number of duplicate spectroscopic observations
    mjd_duplicate text, --/D Spectroscopic MJD of duplicate spectroscopic observations
    fiberid_duplicate text, --/D Fiber ID number of duplicate spectrocscopic observations.
    spectro_duplicate text, --/D Spectroscopic instrument for each duplicate, 1=SDSS, 2=(e)BOSS
    skyversion integer, --/D SDSS photometric sky version number
    run_number integer, --/D SDSS photometric run number
    rerun_number text, --/D SDSS photometric rerun number
    camcol_number integer, --/D SDSS photometric camera column
    field_number integer, --/D SDSS photometric field number
    id_number integer, --/D SDSS photometric ID number
    lambda_eff double precision, --/U Angstrom --/D Wavelength to optimize hold location for
    zoffset double precision, --/U um --/D Backstopping offset distance
    xfocal double precision, --/U mm --/D Hole x-axis position in focal plane
    yfocal double precision, --/U mm --/D Hole y-axis position in focal plane
    chunk text, --/D Name of tiling chunk (from platelist product)
    tile integer, --/D Tile number
    platesn2 double precision, --/D Overall (S/N)^2 measure for plate, minimum of all 4 cameras
    psfflux_u real,
    psfflux_g real,
    psfflux_r real,
    psfflux_i real,
    psfflux_z real,
    psfflux_ivar_u double precision,
    psfflux_ivar_g double precision,
    psfflux_ivar_r double precision,
    psfflux_ivar_i double precision,
    psfflux_ivar_z double precision,
    psfmag_u real,
    psfmag_g real,
    psfmag_r real,
    psfmag_i real,
    psfmag_z real,
    psfmagerr_u double precision,
    psfmagerr_g double precision,
    psfmagerr_r double precision,
    psfmagerr_i double precision,
    psfmagerr_z double precision,
    extinction_u real,
    extinction_g real,
    extinction_r real,
    extinction_i real,
    extinction_z real,
    m_i double precision, --/U mag --/D Absolute i-band magnitude. Assuming H0 = 67.6 km/s/Mpc, OmegaM=0.31, O
	--/D megaL=0.69, Omega_r=9.11e-5. K-corrections taken from Table 4 of Richards et al. (2006).
	--/D  Z_PCA used for redshifts
    sn_median_all double precision, --/D Median S/N value of all good spectroscopic pixels
    galex_matched integer, --/D Matching flag for GALEX
    fuv double precision, --/U nMgy --/D FUV flux from GALEX
    fuv_ivar double precision, --/U nMgy**-2 --/D Inverse variance of FUV flux from GALEX
    nuv double precision, --/U nMgy --/D NUV flux from GALEX
    nuv_ivar double precision, --/U nMgy**-2 --/D Inverse variance of NUV flux from GALEX
    ukidss_matched integer, --/D Matching flag for UKIDSS
    yflux double precision, --/U W m-2 Hz-1 --/D Y-band flux density from UKIDSS
    yflux_err double precision, --/U W m-2 Hz-1 --/D Error in Y-band flux density from UKIDSS
    jflux double precision, --/U W m-2 Hz-1 --/D J-band flux density from UKIDSS
    jflux_err double precision, --/U W m-2 Hz-1 --/D Error in J-band flux density from UKIDSS
    hflux double precision, --/U W m-2 Hz-1 --/D H-band flux density from UKIDSS
    hflux_err double precision, --/U W m-2 Hz-1 --/D Error in H-band flux density from UKIDSS
    kflux double precision, --/U W m-2 Hz-1 --/D K-band flux density from UKIDSS
    kflux_err double precision, --/U W m-2 Hz-1 --/D Error in K-band flux density from UKIDSS
    w1_flux real, --/U nMgy --/D WISE flux in W1-band (Vega)
    w1_flux_ivar real, --/U nMgy**-2 --/D Inverse variance in W1-band (Vega)
    w1_mag real, --/U mag --/D W1-band magnitude (Vega)
    w1_mag_err real, --/U mag --/D W1-band uncertainty in magnitude (Vega)
    w1_chi2 real, --/D Profile-weighed χ2
    w1_flux_snr real, --/D S/N from flux and inverse variance
    w1_src_frac real, --/D Profile-weighted number of exposures in coadd
    w1_ext_flux real, --/U nMgy --/D Profile-weighted flux from other sources
    w1_ext_frac real, --/D Profile-weighted fraction of flux from other sources (blendedness measure)
    w1_npix integer, --/D Number of pixels in fit
    w2_flux real, --/U nMgy --/D WISE flux in W2-band (Vega)
    w2_flux_ivar real, --/U nMgy**-2 --/D Inverse variance in W2-band (Vega)
    w2_mag real, --/U mag --/D W2-band magnitude (Vega)
    w2_mag_err real, --/U mag --/D W2-band uncertainty in magnitude (Vega)
    w2_chi2 real, --/D Profile-weighed χ2
    w2_flux_snr real, --/D S/N from flux and inverse variance
    w2_src_frac real, --/D Profile-weighted number of exposures in coadd
    w2_ext_flux real, --/U nMgy --/D Profile-weighted flux from other sources
    w2_ext_frac real, --/D Profile-weighted fraction of flux from other sources (blendedness measure)
    w2_npix integer, --/D Number of pixels in fit
    first_matched integer, --/D Matching flag for FIRST
    first_flux double precision, --/U mJy --/D FIRST peak flux density at 20 cm
    first_snr double precision, --/D FIRST flux density S/N
    sdss2first_sep double precision, --/D SDSS-FIRST separation in arcsec
    jmag double precision, --/U mag --/D 2MASS J-band magnitude (Vega)
    jmag_err double precision, --/U mag --/D 2MASS Error in J-band magnitude
    jsnr double precision, --/D 2MASS J-band S/N
    jrdflag integer, --/D 2MASS J-band photometry flag
    hmag double precision, --/U mag --/D 2MASS H-band magnitude (Vega)
    hmag_err double precision, --/U mag --/D 2MASS Error in H-band magnitude
    hsnr double precision, --/D 2MASS H-band S/N
    hrdflag integer, --/D 2MASS H-band photometry flag
    kmag double precision, --/U mag --/D 2MASS Ks-band magnitude (Vega)
    kmag_err double precision, --/U mag --/D 2MASS Error in Ks-band magnitude
    ksnr double precision, --/D 2MASS Ks-band S/N
    krdflag integer, --/D 2MASS Ks-band photometry flag
    sdss2mass_sep double precision, --/U arcsec --/D SDSS-2MASS separation
    rass2rxs_id text,
    rass2rxs_ra double precision,
    rass2rxs_dec double precision,
    rass2rxs_src_flux real,
    rass2rxs_src_flux_err real,
    sdss2rosat_sep double precision, --/U arcsec --/D SDSS-ROSAT separation
    xmm_src_id bigint, --/D XMM source ID
    xmm_ra double precision, --/U degrees --/D Right ascension for XMM source in decimal degrees (J2000)
    xmm_dec double precision, --/U degrees --/D Declination for XMM source in decimal degrees (J2000)
    xmm_soft_flux real, --/U erg/s/cm2 --/D Soft (0.2-2.0 keV) X-ray flux from XMM-Newton
    xmm_soft_flux_err real, --/U erg/s/cm2 --/D Error on soft X-ray flux from XMM-Newton
    xmm_hard_flux real, --/U erg/s/cm2 --/D Hard (2.0-12.0 keV) X-ray flux from XMM-Newton
    xmm_hard_flux_err real, --/U erg/s/cm2 --/D Error on hard X-ray flux from XMM-Newton
    xmm_total_flux real, --/U erg/s/cm2 --/D Total (0.2-12.0 keV) X-ray flux from XMM-Newton
    xmm_total_flux_err real, --/U erg/s/cm2 --/D Error on total X-ray flux from XMM-Newton
    xmm_total_lum real, --/U erg/s --/D Total (0.2-12.0 keV) X-ray luminosity from XMM-Newton
    sdss2xmm_sep double precision, --/U arcsec --/D SDSS-XMM-Newton separation
    gaia_matched integer, --/D Gaia matching flag
    gaia_designation text, --/D Gaia designation, includes data release and source ID in that release
    gaia_ra double precision, --/U degrees --/D Gaia barycentric right ascension in decimal degrees (J2015.5)
    gaia_dec double precision, --/U degrees --/D Gaia barycentric declination in decimal degrees (J2015.5)
    gaia_parallax double precision, --/U mas --/D Absolute stellar parallax
    gaia_parallax_err double precision, --/U mas**-2 --/D Inverse variance of the stellar parallax
    gaia_pm_ra double precision, --/U mas/yr --/D Proper motion in right ascension
    gaia_pm_ra_err double precision, --/U (mas/yr)**-2 --/D Inverse variance of the proper motion in right ascension
    gaia_pm_dec double precision, --/U mas/yr --/D Proper motion in declination
    gaia_pm_dec_err double precision, --/U (mas/yr)**-2 --/D Inverse variance of the proper motion in declination
    gaia_g_mag double precision, --/U mag --/D Mean magnitude in G-band (Vega)
    gaia_g_flux_snr double precision, --/D Mean flux over standard deviation in G-band
    gaia_bp_mag double precision, --/U mag --/D Mean magnitude in BP-band (Vega)
    gaia_bp_flux_snr double precision, --/D Mean flux over standard deviation in BP-band
    gaia_rp_mag double precision, --/U mag --/D Mean magnitude in RP-band (Vega)
    gaia_rp_flux_snr double precision, --/D Mean flux over standard deviation in RP-band
    sdss2gaia_sep double precision, --/U arcsec --/D SDSS-Gaia separation
    pk bigint NOT NULL --/D Added for convenience - serial integer primary key
)
GO
--


--
-- Name: mos_sdss_dr16_specobj; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_sdss_dr16_specobj')
	DROP TABLE mos_sdss_dr16_specobj
GO
--
EXEC spSetDefaultFileGroup 'mos_sdss_dr16_specobj'
GO
CREATE TABLE mos_sdss_dr16_specobj (

----------------------------------------------------------------------
--/H This table contains the list of all SDSS optical spectra for a 
--/H given data release, with associated parameters from the 2D and 
--/H 1D pipelines for each. 
----------------------------------------------------------------------
--/T The table contains both the BOSS and SDSS spectrograph data. The 
--/T database representation is derived from the flat file information
--/T described here: 
--/T https://data.sdss.org/datamodel/files/SPECTRO_REDUX/specObj.html.
----------------------------------------------------------------------
    specobjid numeric(20,0) NOT NULL, --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D 
	--/D (same as SkyServer version)
    bestobjid bigint, --/D Unique database ID of (recommended) position-based photometric match 
	--/D based on RUN, RERUN, CAMCOl, FIELD, ID (same as SkyServer version)
    fluxobjid bigint, --/D Unique database ID of flux-based photometric match based on RUN, RERUN, 
	--/D CAMCOl, FIELD, ID (same as SkyServer version)
    targetobjid bigint, --/D Unique database ID of targeting object based on RUN, RERUN, CAMCOl, 
	--/D FIELD, ID (same as SkyServer version)
    plateid numeric(20,0), --/D Unique database ID of plate based on PLATE, MJD, RUN2D (same as 
	--/D SkyServer version)
    scienceprimary smallint,
    sdssprimary smallint,
    legacyprimary smallint,
    segueprimary smallint,
    segue1primary smallint,
    segue2primary smallint,
    bossprimary smallint,
    bossspecobjid integer,
    firstrelease character varying(32), --/D Name of first release this PLATE, MJD, FIBERID, RUN2D was 
	--/D associated with
    survey character varying(32), --/D Survey that this object is part of
    instrument character varying(32), --/D Instrument that this spectrum was observed with (SDSS or BOSS)
    programname character varying(32), --/D Program within each survey that the plate was part of
    chunk character varying(32), --/D Name of tiling chunk that this spectrum was tiled in (boss1, boss2, 
	--/D etc), important for tracking large-scale structure samples
    platerun character varying(32), --/D Drilling run that this plate was drilled in
    mjd integer, --/U day --/D Modified Julian Day of observation
    plate smallint, --/D Plate number (each plate corresponds to an actual plug plate)
    fiberid smallint, --/D Fiber number
    run1d character varying(32), --/D Spectroscopic 1D reduction (redshift and classification) name
    run2d character varying(32), --/D Spectroscopic 2D reduction (extraction of spectra) name
    tile integer, --/D Tile number (each tile can have several plates drilled for it)
    designid integer, --/D Design identification number for plate
    legacy_target1 bigint, --/D Primary (science) target flags for SDSS-I and SDSS-II Legacy survey
    legacy_target2 bigint, --/D Secondary (calibration) target flags for SDSS-I and SDSS-II Legacy 
	--/D survey
    special_target1 bigint, --/D Primary (science) target flags for SDSS-I and SDSS-II special program 
	--/D targets
    special_target2 bigint, --/D Secondary (calibration) target flags for SDSS-I and SDSS-II special 
	--/D program targets
    segue1_target1 bigint, --/D Primary (science) target flags for SEGUE-1 targets
    segue1_target2 bigint,
    segue2_target1 bigint, --/D Primary (science) target flags for SEGUE-2 targets
    segue2_target2 bigint, --/D Secondary (calibration) target flags for SEGUE-2 targets
    boss_target1 bigint, --/D Primary (science) target flags for BOSS targets
    eboss_target0 bigint, --/D SEQUELS, TDSS and SPIDERS target selection flags
    eboss_target1 bigint, --/D eBOSS, TDSS and SPIDERS target selection flags for main eBOSS survey
    eboss_target2 bigint, --/D eBOSS, TDSS and SPIDERS target selection flags for main eBOSS survey
    eboss_target_id bigint,
    ancillary_target1 bigint, --/D Target flags for BOSS ancillary targets
    ancillary_target2 bigint, --/D More target flags for BOSS ancillary targets
    thing_id_targeting bigint, --/D Resolve THING_ID in SDSS imaging for targeted object
    thing_id integer, --/D Resolve THING_ID in SDSS imaging for best positional match
    primtarget bigint, --/D Deprecated version of primary (science) target flags (meanings highly 
	--/D overloaded)
    sectarget bigint, --/D Deprecated version of secondary (calibration) target flags (meanings 
	--/D highly overloaded)
    spectrographid smallint, --/D Which spectrograph (1 or 2)
    sourcetype character varying(128), --/D String expressing type of source (similar to OBJTYPE in DR8 
	--/D and earlier)
    targettype character varying(128), --/D General type of target ("SCIENCE", "STANDARD" or "SKY")
    ra double precision,
    [dec] double precision,
    cx double precision, --/D Position of object on J2000 unit sphere
    cy double precision, --/D Position of object on J2000 unit sphere
    cz double precision, --/D Position of object on J2000 unit sphere
    xfocal real, --/U mm --/D Hole position on plate (+X = +RA)
    yfocal real, --/U mm --/D Hole position on plate (+Y = +DEC)
    lambdaeff real,
    bluefiber integer,
    zoffset real, --/U microns --/D Washer thickness used (for backstopping BOSS quasar targets, so they 
	--/D are closer to 4000 Angstrom focal plan
    z real, --/D Best redshift
    zerr real,
    zwarning integer, --/D Bitmask of spectroscopic warning values; 0 means everything is OK
    class character varying(32), --/D Best spectroscopic classification ("STAR", "GALAXY" or "QSO")
    subclass character varying(32), --/D Best spectroscopic subclassification
    rchi2 real, --/D Reduced chi-squared of best fit
    dof real, --/D Number of degrees of freedom in best fit
    rchi2diff real, --/D Difference in reduced chi-squared between best and second best fit
    z_noqso real, --/D Best redshift when ignoring QSO fits, recommended for BOSS CMASS and LOWZ 
	--/D targets; calculated only for survey='boss' spectra, not for any SDSS spectrograph data
    zerr_noqso real,
    zwarning_noqso integer, --/D For Z_NOQSO redshift, the bitmask of spectroscopic warning values; 0 
	--/D means everything is OK
    class_noqso character varying(32), --/D Spectroscopic classification for Z_NOQSO redshift
    subclass_noqso character varying(32), --/D Spectroscopic subclassification for Z_NOQSO redshift
    rchi2diff_noqso real, --/D Difference in reduced chi-squared between best and second best fit for
	--/D  Z_NOQSO redshift
    z_person real, --/D Visual-inspection redshift
    class_person character varying(32), --/D Visual-inspection classification (0=not inspected or unknown, 1=star, 
	--/D 2=narrow emission-line galaxy, 3=QSO, 4=galaxy)
    comments_person character varying(200), --/D Visual-inspection comments
    tfile character varying(32), --/D File that best fit template comes from in idlspec1d product
    tcolumn_0 smallint, --/D Which column of the template file corresponds to template #0
    tcolumn_1 smallint, --/D Which column of the template file corresponds to template #1
    tcolumn_2 smallint, --/D Which column of the template file corresponds to template #2
    tcolumn_3 smallint, --/D Which column of the template file corresponds to template #3
    tcolumn_4 smallint, --/D Which column of the template file corresponds to template #4
    tcolumn_5 smallint, --/D Which column of the template file corresponds to template #5
    tcolumn_6 smallint, --/D Which column of the template file corresponds to template #6
    tcolumn_7 smallint, --/D Which column of the template file corresponds to template #7
    tcolumn_8 smallint, --/D Which column of the template file corresponds to template #8
    tcolumn_9 smallint, --/D Which column of the template file corresponds to template #9
    npoly real, --/D Number of polynomial terms in fit
    theta_0 real, --/D Template coefficients of best fit (polynomial term #0)
    theta_1 real, --/D Template coefficients of best fit (polynomial term #1)
    theta_2 real, --/D Template coefficients of best fit (polynomial term #2)
    theta_3 real, --/D Template coefficients of best fit (polynomial term #3)
    theta_4 real, --/D Template coefficients of best fit (polynomial term #4)
    theta_5 real, --/D Template coefficients of best fit (polynomial term #5)
    theta_6 real, --/D Template coefficients of best fit (polynomial term #6)
    theta_7 real, --/D Template coefficients of best fit (polynomial term #7)
    theta_8 real, --/D Template coefficients of best fit (polynomial term #8)
    theta_9 real, --/D Template coefficients of best fit (polynomial term #9)
    veldisp real,
    veldisperr real,
    veldispz real,
    veldispzerr real,
    veldispchi2 real,
    veldispnpix integer,
    veldispdof integer,
    wavemin real, --/U Angstroms --/D Minimum observed (vacuum) wavelength
    wavemax real, --/U Angstroms --/D Maximum observed (vacuum) wavelength
    wcoverage real, --/D Coverage in wavelength, in units of log10 wavelength
    snmedian_u real,
    snmedian_g real,
    snmedian_r real,
    snmedian_i real,
    snmedian_z real,
    snmedian real,
    chi68p real, --/D 68-th percentile value of abs(chi) of the best-fit synthetic spectrum 
	--/D to the actual spectrum (around 1.0 for a good fit)
    fracnsigma_1 real, --/D Fraction of pixels deviant by more than 1 sigma relative to best-fit
    fracnsigma_2 real, --/D Fraction of pixels deviant by more than 2 sigma relative to best-fit
    fracnsigma_3 real, --/D Fraction of pixels deviant by more than 3 sigma relative to best-fit
    fracnsigma_4 real, --/D Fraction of pixels deviant by more than 4 sigma relative to best-fit
    fracnsigma_5 real, --/D Fraction of pixels deviant by more than 5 sigma relative to best-fit
    fracnsigma_6 real, --/D Fraction of pixels deviant by more than 6 sigma relative to best-fit
    fracnsigma_7 real, --/D Fraction of pixels deviant by more than 7 sigma relative to best-fit
    fracnsigma_8 real, --/D Fraction of pixels deviant by more than 8 sigma relative to best-fit
    fracnsigma_9 real, --/D Fraction of pixels deviant by more than 9 sigma relative to best-fit
    fracnsigma_10 real, --/D Fraction of pixels deviant by more than 10 sigma relative to best-fit
    fracnsighi_1 real, --/D Fraction of pixels high by more than 1 sigma relative to best-fit
    fracnsighi_2 real, --/D Fraction of pixels high by more than 2 sigma relative to best-fit
    fracnsighi_3 real, --/D Fraction of pixels high by more than 3 sigma relative to best-fit
    fracnsighi_4 real, --/D Fraction of pixels high by more than 4 sigma relative to best-fit
    fracnsighi_5 real, --/D Fraction of pixels high by more than 5 sigma relative to best-fit
    fracnsighi_6 real, --/D Fraction of pixels high by more than 6 sigma relative to best-fit
    fracnsighi_7 real, --/D Fraction of pixels high by more than 7 sigma relative to best-fit
    fracnsighi_8 real, --/D Fraction of pixels high by more than 8 sigma relative to best-fit
    fracnsighi_9 real, --/D Fraction of pixels high by more than 9 sigma relative to best-fit
    fracnsighi_10 real, --/D Fraction of pixels high by more than 10 sigma relative to best-fit
    fracnsiglo_1 real, --/D Fraction of pixels low by more than 1 sigma relative to best-fit
    fracnsiglo_2 real, --/D Fraction of pixels low by more than 2 sigma relative to best-fit
    fracnsiglo_3 real, --/D Fraction of pixels low by more than 3 sigma relative to best-fit
    fracnsiglo_4 real, --/D Fraction of pixels low by more than 4 sigma relative to best-fit
    fracnsiglo_5 real, --/D Fraction of pixels low by more than 5 sigma relative to best-fit
    fracnsiglo_6 real, --/D Fraction of pixels low by more than 6 sigma relative to best-fit
    fracnsiglo_7 real, --/D Fraction of pixels low by more than 7 sigma relative to best-fit
    fracnsiglo_8 real, --/D Fraction of pixels low by more than 8 sigma relative to best-fit
    fracnsiglo_9 real, --/D Fraction of pixels low by more than 9 sigma relative to best-fit
    fracnsiglo_10 real, --/D Fraction of pixels low by more than 10 sigma relative to best-fit
    spectroflux_u real, --/U nanomaggies --/D Spectral flux within u filter bandpass
    spectroflux_g real, --/U nanomaggies --/D Spectral flux within g filter bandpass
    spectroflux_r real, --/U nanomaggies --/D Spectral flux within r filter bandpass
    spectroflux_i real, --/U nanomaggies --/D Spectral flux within i filter bandpass
    spectroflux_z real, --/U nanomaggies --/D Spectral flux within z filter bandpass
    spectrosynflux_u real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within u filter bandpass
    spectrosynflux_g real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within g filter bandpass
    spectrosynflux_r real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within r filter bandpass
    spectrosynflux_i real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within i filter bandpass
    spectrosynflux_z real, --/U nanomaggies --/D Spectral flux of best-fit template spectrum within z filter bandpass
    spectrofluxivar_u real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within u filter bandpass
    spectrofluxivar_g real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within g filter bandpass
    spectrofluxivar_r real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within r filter bandpass
    spectrofluxivar_i real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within i filter bandpass
    spectrofluxivar_z real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux within z filter bandpass
    spectrosynfluxivar_u real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within
	--/D  u filter bandpass
    spectrosynfluxivar_g real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within
	--/D  g filter bandpass
    spectrosynfluxivar_r real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within
	--/D  r filter bandpass
    spectrosynfluxivar_i real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within
	--/D  i filter bandpass
    spectrosynfluxivar_z real, --/U nanomaggies^-2 --/D Inverse variance of spectral flux of best-fit template spectrum within
	--/D  z filter bandpass
    spectroskyflux_u real, --/U nanomaggies --/D Sky flux in the u filter bandpass
    spectroskyflux_g real, --/U nanomaggies --/D Sky flux in the g filter bandpass
    spectroskyflux_r real, --/U nanomaggies --/D Sky flux in the r filter bandpass
    spectroskyflux_i real, --/U nanomaggies --/D Sky flux in the i filter bandpass
    spectroskyflux_z real, --/U nanomaggies --/D Sky flux in the z filter bandpass
    anyandmask integer, --/D For each bit, records whether any pixel in the spectrum has that bit 
	--/D set in its ANDMASK
    anyormask integer, --/D For each bit, records whether any pixel in the spectrum has that bit 
	--/D set in its ORMASK
    platesn2 real, --/D Overall signal-to-noise-squared measure for plate (only for SDSS 
	--/D spectrograph plates)
    deredsn2 real, --/D Dereddened overall signal-to-noise-squared measure for plate (only for
	--/D  BOSS spectrograph plates)
    snturnoff real, --/D Signal to noise measure for MS turnoff stars on plate (-9999 if not 
	--/D appropriate)
    sn1_g real,
    sn1_r real,
    sn1_i real,
    sn2_g real,
    sn2_r real,
    sn2_i real,
    elodiefilename character varying(32),
    elodieobject character varying(32),
    elodiesptype character varying(32),
    elodiebv real,
    elodieteff real,
    elodielogg real,
    elodiefeh real,
    elodiez real,
    elodiezerr real,
    elodiezmodelerr real,
    elodierchi2 real,
    elodiedof real,
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID
    loadversion integer --/D Load Version
)
GO
--


--
-- Name: mos_skies_v2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_skies_v2')
	DROP TABLE mos_skies_v2
GO
--
EXEC spSetDefaultFileGroup 'mos_skies_v2'
GO
CREATE TABLE mos_skies_v2 (

----------------------------------------------------------------------
--/H This table stores the positions used as blank sky regions for 
--/H DR18 targetting. 
----------------------------------------------------------------------
--/T The sky regions are selected by dividing the sky in tiles of 
--/T HEALpix nside 32. Each tile is then subdivided in candidate 
--/T regions of HEALpix nside 32768 and the pixels that meet the 
--/T isolation requirements are considered valid skies. This process 
--/T is repeated for a number of all-sky catalogues. See 
--/T https://sdss.org/dr18/targeting/fps/ for further details of the 
--/T process by which suitable sky locations are selected in SDSS-V/FPS.
----------------------------------------------------------------------
    pix_32768 bigint NOT NULL, --/D The HEALpix pixel (nside=32768, nested indexing, Equatorial coords) of
	--/D  the sky region.
    ra double precision, --/U degrees --/D The RA of the centre of the sky pixel.
    [dec] double precision, --/U degrees --/D The declination of the centre of the sky pixel.
    down_pix bigint, --/D The HEALpix pixel (nside=256, nested indexing, Equatorial coords) of 
	--/D the sky region. Used internally to downsample the list of candidate region.
    tile_32 bigint, --/D The HEALpix pixel (nside=32, nested indexing, Equatorial coords) of the 
	--/D sky region.
    valid_gaia bit, --/D Whether this is a valid sky region in the Gaia catalogue.
    selected_gaia bit, --/D Whether this sky region was selected in the Gaia catalogue.
    sep_neighbour_gaia real, --/U arcsec --/D Separation to the nearest Gaia DR2 neighbour
    mag_neighbour_gaia real, --/U mag --/D Magnitude of the nearest Gaia DR2 neighbour (G band, Vega).
    valid_ls8 bit, --/D Whether this is a valid sky region in the Legacy Survey DR8 catalogue.
    selected_ls8 bit, --/D Whether this sky region was selected in the Legacy Survey DR8 catalogue.
    sep_neighbour_ls8 real, --/U arcsec --/D Separation to the nearest Legacy Survey DR8 neighbour
    mag_neighbour_ls8 real, --/U mag --/D Magnitude of the nearest Legacy Survey DR8 neighbour (r-band, AB).
    valid_ps1dr2 bit, --/D Whether this is a valid sky region in the PanSTARRS1 DR2 catalogue.
    selected_ps1dr2 bit, --/D Whether this sky region was selected in the PanSTARRS1 DR2 catalogue.
    sep_neighbour_ps1dr2 real, --/U arcsec --/D Separation to the nearest PanSTARRS1 DR2 neighbour
    mag_neighbour_ps1dr2 real, --/U mag --/D Magnitude of the nearest PanSTARRS1 DR2 neighbour (r-band, AB).
    valid_tmass bit, --/D Whether this is a valid sky region in the 2MASS point source catalogue.
    selected_tmass bit, --/D Whether this sky region was selected in the 2MASS point source catalogue.
    sep_neighbour_tmass real, --/U arcsec --/D Separation to the nearest 2MASS point source neighbour
    mag_neighbour_tmass real, --/U mag --/D Magnitude of the nearest 2MASS point source neighbour (H band, Vega).
    valid_tycho2 bit, --/D Whether this is a valid sky region in the Tycho2 catalogue.
    selected_tycho2 bit, --/D Whether this sky region was selected in the Tycho2 catalogue.
    sep_neighbour_tycho2 real, --/U arcsec --/D Separation to the nearest Tycho2 neighbour
    mag_neighbour_tycho2 real, --/U mag --/D Magnitude of the nearest Tycho2 neighbour (Vt band, Vega).
    valid_tmass_xsc bit, --/D Whether this is a valid sky region in the 2MASS extended source catalogue.
    selected_tmass_xsc bit, --/D Whether this sky region was selected in the 2MASS extended source 
	--/D catalogue.
    sep_neighbour_tmass_xsc real --/U arcsec --/D Separation to the nearest 2MASS extended source neighbour
)
GO
--


--
-- Name: mos_skymapper_dr2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_skymapper_dr2')
	DROP TABLE mos_skymapper_dr2
GO
--
EXEC spSetDefaultFileGroup 'mos_skymapper_dr2'
GO
CREATE TABLE mos_skymapper_dr2 (

----------------------------------------------------------------------
--/H Skymapper Data Release 2 photometry. 
----------------------------------------------------------------------
--/T For detailed descriptions, please see the SkyMapper 
--/T documentation: https://skymapper.anu.edu.au/table-browser/
----------------------------------------------------------------------
    object_id bigint NOT NULL, --/D Global unique SkyMapper object ID in the master table
    raj2000 double precision, --/U degrees --/D Mean ICRS Right Ascension of the object
    dej2000 double precision, --/U degrees --/D Mean ICRS Declination of the object
    e_raj2000 integer, --/U mas --/D RMS variation around the mean Right Ascension
    e_dej2000 integer, --/U mas --/D RMS variation around the mean Declination
    smss_j character(18), --/D SkyMapper Southern Survey designation of the form SMSS 
	--/D Jhhmmss.ss+/-ddmmss.s
    mean_epoch double precision, --/U days --/D Mean MJD epoch of the observations
    rms_epoch real, --/U days --/D RMS variation around the mean epoch
    glon real, --/U degrees --/D Galactic longitude derived from ICRS coordinate
    glat real, --/U degrees --/D Galactic latitude derived from ICRS coordinate
    flags smallint, --/D Bitwise OR of Source Extractor flags across all observations
    nimaflags integer, --/D Total number of flagged pixels from bad, saturated, and crosstalk 
	--/D pixel masks across all observations
    ngood smallint, --/D Number of observations used across all filters
    ngood_min smallint, --/D Minimum number of observations used in any filter
    nch_max smallint, --/D Maximum number of child sources combined into this global object_id in
	--/D  any filter
    density real, --/D Number of DR2 sources within 15 arcsec (including this source)
    u_flags smallint, --/D Bitwise OR of Source Extractor flags from u-band measurements in photo
	--/D metry table
    u_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel 
	--/D masks from u-band measurements in photometry table
    u_ngood smallint, --/D Number of u-band observations used
    u_nch smallint, --/D Number of u-band child sources combined into this object_id
    u_nclip smallint, --/D Number of u-band observations with magnitudes clipped from the final 
	--/D PSF magnitude estimate
    v_flags smallint, --/D Bitwise OR of Source Extractor flags from v-band measurements in 
	--/D photometry table
    v_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel 
	--/D masks from u-band measurements in photometry table
    v_ngood smallint, --/D Number of v-band observations used
    v_nch smallint, --/D Number of v-band child sources combined into this object_id
    v_nclip smallint, --/D Number of v-band observations with magnitudes clipped from the final 
	--/D PSF magnitude estimate
    g_flags smallint, --/D Bitwise OR of Source Extractor flags from g-band measurements in photo
	--/D metry table
    g_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel 
	--/D masks from g-band measurements in photometry table
    g_ngood smallint, --/D Number of g-band observations used
    g_nch smallint, --/D Number of g-band child sources combined into this object_id
    g_nclip smallint, --/D Number of g-band observations with magnitudes clipped from the final 
	--/D PSF magnitude estimate
    r_flags smallint, --/D Bitwise OR of Source Extractor flags from r-band measurements in photo
	--/D metry table
    r_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel 
	--/D masks from r-band measurements in photometry table
    r_ngood smallint, --/D Number of r-band observations used
    r_nch smallint, --/D Number of r-band child sources combined into this object_id
    r_nclip smallint, --/D Number of r-band observations with magnitudes clipped from the final 
	--/D PSF magnitude estimate
    i_flags smallint, --/D Bitwise OR of Source Extractor flags from i-band measurements in 
	--/D photometry table
    i_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel 
	--/D masks from i-band measurements in photometry table
    i_ngood smallint, --/D Number of i-band observations used
    i_nch smallint, --/D Number of i-band child sources combined into this object_id
    i_nclip smallint, --/D Number of i-band observations with magnitudes clipped from the final 
	--/D PSF magnitude estimate
    z_flags smallint, --/D Bitwise OR of Source Extractor flags from z-band measurements in photo
	--/D metry table
    z_nimaflags integer, --/D Number of flagged pixels from bad, saturated, and crosstalk pixel 
	--/D masks from z-band measurements in photometry table
    z_ngood smallint, --/D Number of z-band observations used
    z_nch smallint, --/D Number of z-band child sources combined into this object_id
    z_nclip smallint, --/D Number of a-band observations with magnitudes clipped from the final 
	--/D PSF magnitude estimate
    class_star real, --/D Maximum stellarity index from photometry table (between 0=no star and 
	--/D 1=star)
    flags_psf integer, --/D Bitmask indicating whether photometry is likely biased by neighbours 
	--/D at greater than 1%
    radius_petro real, --/U pix --/D Mean r-band Petrosian radius
    u_psf real, --/U mag --/D Mean u-band PSF magnitude
    e_u_psf real, --/U mag --/D Error in u-band PSF magnitude
    u_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the u-band PSF 
	--/D magnitude, including clipped sources
    u_petro real, --/U mag --/D Mean u-band Petrosian magnitude
    e_u_petro real, --/U mag --/D Error in u-band Petrosian magnitude
    v_psf real, --/U mag --/D Mean v-band PSF magnitude
    e_v_psf real, --/U mag --/D Error in v-band PSF magnitude
    v_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the v-band PSF 
	--/D magnitude, including clipped sources
    v_petro real, --/U mag --/D Mean v-band Petrosian magnitude
    e_v_petro real, --/U mag --/D Error in v-band Petrosian magnitude
    g_psf real, --/U mag --/D Mean g-band PSF magnitude
    e_g_psf real, --/U mag --/D Error in g-band PSF magnitude
    g_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the g-band PSF 
	--/D magnitude, including clipped sources
    g_petro real, --/U mag --/D Mean g-band Petrosian magnitude
    e_g_petro real, --/U mag --/D Error in g-band Petrosian magnitude
    r_psf real, --/U mag --/D Mean r-band PSF magnitude
    e_r_psf real, --/U mag --/D Error in r-band PSF magnitude
    r_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the r-band PSF 
	--/D magnitude, including clipped sources
    r_petro real, --/U mag --/D Mean r-band Petrosian magnitude
    e_r_petro real, --/U mag --/D Error in r-band Petrosian magnitude
    i_psf real, --/U mag --/D Mean i-band PSF magnitude
    e_i_psf real, --/U mag --/D Error in i-band PSF magnitude
    i_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the i-band PSF 
	--/D magnitude, including clipped sources
    i_petro real, --/U mag --/D Mean i-band Petrosian magnitude
    e_i_petro real, --/U mag --/D Error in i-band Petrosian magnitude
    z_psf real, --/U mag --/D Mean z-band PSF magnitude
    e_z_psf real, --/U mag --/D Error in z-band PSF magnitude
    z_rchi2var real, --/D Reduced chi-squared for a constant-magnitude model of the z-band PSF 
	--/D magnitude, including clipped sources
    z_petro real, --/U mag --/D Mean z-band Petrosian magnitude
    e_z_petro real, --/U mag --/D Error in z-band Petrosian magnitude
    ebmv_sfd real, --/U mag --/D E(B-V) from Schlegel+1998 extinction maps at the ICRS coordinates
    prox real, --/U arcsec --/D Distance to next-closest DR2 source
    prox_id bigint, --/D object_id of next-closest DR2 source
    dr1_id bigint, --/D object_id of closest SkyMapper Data Release 1 source
    dr1_dist real, --/U arcsec --/D Distance to closest SkyMapper Data Release 1 source
    twomass_key bigint, --/D Unique identifier (pts_key) of closest 2MASS PSC source
    twomass_dist real, --/U arcsec --/D Distance on sky to closest 2MASS PSC source
    allwise_cntr bigint, --/D Unique identifier (cntr) of closest AllWISE source
    allwise_dist real, --/U arcsec --/D Distance on sky to closest AllWISE source
    ucac4_mpos bigint, --/D Unique identifier (mpos) of closest UCAC4 source
    ucac4_dist real, --/U arcsec --/D Distance on sky to closest UCAC4 source
    refcat2_id bigint, --/D Unique identifier (objid) of closest ATLAS Refcat2 source
    refcat2_dist real, --/U arcsec --/D Distance on sky to closest ATLAS Refcat2 source
    ps1_dr1_id bigint, --/D Unique identifier (objID) of closest Pan-STARRS1 DR1 source
    ps1_dr1_dist real, --/U arcsec --/D Distance on sky to closest Pan-STARRS1 DR1 source
    galex_guv_id bigint, --/D Unique identifier (objid) of closest GALEX GUVcat AIS source (Bianchi 
	--/D et al. 2017)
    galex_guv_dist real, --/U arcsec --/D Distance on sky to closest GALEX GUVcat AIS source
    gaia_dr2_id1 bigint, --/D Unique identifier (source_id) of closest Gaia DR2 source
    gaia_dr2_dist1 real, --/U arcsec --/D Distance on sky to closest Gaia DR2 source
    gaia_dr2_id2 bigint, --/D Unique identifier (source_id) of second-closest Gaia DR2 source
    gaia_dr2_dist2 real --/U arcsec --/D Distance on sky to second-closest Gaia DR2 source
)
GO
--


--
-- Name: mos_supercosmos; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_supercosmos')
	DROP TABLE mos_supercosmos
GO
--
EXEC spSetDefaultFileGroup 'mos_supercosmos'
GO
CREATE TABLE mos_supercosmos (

----------------------------------------------------------------------
--/H Contains merged sources for every field in the SuperCOSMOS Science Archive (SSA).
----------------------------------------------------------------------
--/T It consists of data from digitised sky survey plates taken with the UK Schmidt <br>
--/T telescope (UKST), the ESO Schmidt, and the Palomar Schmidt. <br>
--/T Each field within the SSA is covered by four plates in passbands B, R and <br>
--/T I with R being covered twice at different times. This results in <br>
--/T four-plate multi-colour, multi-epoch data which are merged into a single <br>
--/T source catalogue for general science exploitation. This table contains the <br>
--/T associated merged records created from the records in table Detection, <br>
--/T along with a full astrometric solution (including proper motions) computed <br>
--/T from the available position measures. The most useful subset of image <br>
--/T morphological descriptors are also propagated into this table for ease of <br>
--/T use. <br>
--/T Derived from http://ssa.roe.ac.uk/www/SSA_TABLE_SourceSchema.html#Source
----------------------------------------------------------------------
    objid bigint NOT NULL, --/D Unique identifier of merged source  --/D SDSS photometric object ident
	--/D ification numbers (RUN, RERUN, CAMCOL, FIELD, ID)
    objidb bigint, --/D objID for B band detection merged into this object
    objidr1 bigint, --/D objID for R1 band detection merged into this object
    objidr2 bigint, --/D objID for R2 band detection merged into this object
    objidi bigint, --/D objID for I band detection merged into this object
    htmid bigint, --/D Hierarchical Triangular Mesh (20-deep) of centroid
    epoch real, --/U yr --/D Epoch of position (variance weighted mean epoch of available measures)
    ra double precision, --/U deg --/D Mean RA, computed from detections merged in this catalogue
    [dec] double precision, --/U deg --/D Mean Dec, computed from detections merged in this catalogue
    sigra double precision, --/U deg --/D Uncertainty in RA (formal random error not inc. systematic errors)
    sigdec double precision, --/U deg --/D Uncertainty in Dec (formal random error not inc. systematic errors)
    cx double precision, --/D Cartesian x of unit (ra,dec) vector on celestial sphere
    cy double precision, --/D Cartesian y of unit (ra,dec) vector on celestial sphere
    cz double precision, --/D Cartesian z of unit (ra,dec) vector on celestial sphere
    muacosd real, --/U mas/yr --/D Proper motion in RA direction
    mud real, --/U mas/yr --/D Proper motion in Dec direction
    sigmuacosd real, --/U mas/yr --/D Error on proper motion in RA direction
    sigmud real, --/U mas/yr --/D Error on proper motion in Dec direction
    chi2 real, --/D Chi-squared value of proper motion solution
    nplates smallint, --/D No. of plates used for this proper motion measurement
    classmagb real, --/U mag --/D B band magnitude selected by B image class
    classmagr1 real, --/U mag --/D R1 band magnitude selected by R1 image class
    classmagr2 real, --/U mag --/D R2 band magnitude selected by R2 image class
    classmagi real, --/U mag --/D I band magnitude selected by I image class
    gcormagb real, --/U mag --/D B band magnitude assuming object is galaxy
    gcormagr1 real, --/U mag --/D R1 band magnitude assuming object is galaxy
    gcormagr2 real, --/U mag --/D R2 band magnitude assuming object is galaxy
    gcormagi real, --/U mag --/D I band magnitude assuming object is galaxy
    scormagb real, --/U mag --/D B band magnitude assuming object is star
    scormagr1 real, --/U mag --/D R1 band magnitude assuming object is star
    scormagr2 real, --/U mag --/D R2 band magnitude assuming object is star
    scormagi real, --/U mag --/D I band magnitude assuming object is star
    meanclass smallint, --/D Estimate of image class based on unit-weighted mean of individual classes
    classb smallint, --/D Image classification from B band detection
    classr1 smallint, --/D Image classification from R1 band detection
    classr2 smallint, --/D Image classification from R2 band detection
    classi smallint, --/D Image classification from I band detection
    ellipb real, --/D Ellipticity of B band detection
    ellipr1 real, --/D Ellipticity of R1 band detection
    ellipr2 real, --/D Ellipticity of R2 band detection
    ellipi real, --/D Ellipticity of I band detection
    qualb integer, --/D Bitwise quality flag from B band detection
    qualr1 integer, --/D Bitwise quality flag from R1 band detection
    qualr2 integer, --/D Bitwise quality flag from R2 band detection
    quali integer, --/D Bitwise quality flag from I band detection
    blendb integer, --/D Blend flag from B band detection
    blendr1 integer, --/D Blend flag from R1 band detection
    blendr2 integer, --/D Blend flag from R2 band detection
    blendi integer, --/D Blend flag from I band detection
    prfstatb real, --/D Profile statistic from B band detection
    prfstatr1 real, --/D Profile statistic from R1 band detection
    prfstatr2 real, --/D Profile statistic from R2 band detection
    prfstati real, --/D Profile statistic from I band detection
    l real, --/U deg --/D The Galactic longitude of the source
    b real, --/U deg --/D The Galactic latitude of the source
    d real, --/U deg --/D The great-circle distance of the source from the Galactic centre
    ebmv real --/U mag --/D The estimated foreground reddening at this position from Schlegel et al. (1998)
)
GO
--


--
-- Name: mos_target; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_target')
	DROP TABLE mos_target
GO
--
EXEC spSetDefaultFileGroup 'mos_target'
GO
CREATE TABLE mos_target (

----------------------------------------------------------------------
--/H This table stores the targets associated with DR18 target 
--/H selection cartons. 
----------------------------------------------------------------------
--/T Note that the targets in this table are unique, but a target can 
--/T be associated with multiple cartons. That many-to-many 
--/T relationship is encoded in the mos_carton_to_target table.
----------------------------------------------------------------------
    target_pk bigint NOT NULL, --/D The primary key. A sequential identifier.
    ra double precision, --/U degree --/D The right ascension of the target in ICRS coordinates at epoch. 
	--/D From mos_catalog.
    [dec] double precision, --/U degree --/D The declination of the target in ICRS coordinates at epoch. 
	--/D From mos_catalog.
    pmra real, --/U mas/yr --/D The proper motion in right ascenscion of the target, as a true angle. 
	--/D From mos_catalog.
    pmdec real, --/U mas/yr --/D The proper motion in declination of the target. From mos_catalog.
    epoch real, --/U years --/D The epoch of the coordinates, as a Julian epoch.
    parallax real, --/U arcsec --/D The parallax of the target. From mos_catalog.
    catalogid bigint, --/D The catalogid of the entry in mos_catalog associated with this target.
	htmid bigint, --/D 20-level deep Hierarchical Triangular Mesh ID
	cx float,  --/D unit vector for ra+dec 
	cy float,  --/D unit vector for ra+dec 
	cz float   --/D unit vector for ra+dec 

)
GO
--


--
-- Name: mos_targetdb_version; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_targetdb_version')
	DROP TABLE mos_targetdb_version
GO
--
EXEC spSetDefaultFileGroup 'mos_targetdb_version'
GO
CREATE TABLE mos_targetdb_version (

    pk integer NOT NULL,
    planname text,
    tag text,
    target_selection bit,
    robostrategy bit
)
GO
--


--
-- Name: mos_targeting_generation; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_targeting_generation')
	DROP TABLE mos_targeting_generation
GO
--
EXEC spSetDefaultFileGroup 'mos_targeting_generation'
GO
CREATE TABLE mos_targeting_generation (

    pk integer NOT NULL,
    label text
)
GO
--


--
-- Name: mos_targeting_generation_pk_seq; Type: SEQUENCE; Schema: minidb; Owner: -
--
/*
CREATE SEQUENCE mos_targeting_generation_pk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
*/

--
-- Name: mos_targeting_generation_pk_seq; Type: SEQUENCE OWNED BY; Schema: minidb; Owner: -
--

-- ALTER SEQUENCE mos_targeting_generation_pk_seq OWNED BY mos_targeting_generation.pk;


--
-- Name: mos_tic_v8; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_tic_v8')
	DROP TABLE mos_tic_v8
GO
--
EXEC spSetDefaultFileGroup 'mos_tic_v8'
GO
CREATE TABLE mos_tic_v8 (

----------------------------------------------------------------------
--/H The Eighth version (v8.0) of the TESS Input Catalogue 
--/H (https://outerspace.stsci.edu/display/TESS/TIC+v8+and+CTL+v8.xx+Data+Release+Notes). 
----------------------------------------------------------------------
--/T This catalogue is used in v0.5 target selection as a form of 
--/T internal cross-match between the objects found in difference 
--/T input catalogues.
----------------------------------------------------------------------
    id bigint NOT NULL, --/D TESS Input Catalog identifier
    version character varying(8), --/D Version Identifier for this entry (yyyymmdd)
    hip integer, --/D Hipparcos Identifier
    tyc character varying(12), --/D Tycho2 Identifier
    ucac character varying(10), --/D UCAC4 Identifier
    twomass character varying(20), --/D 2MASS Identifier
    sdss bigint, --/D SDSS DR9 Identifier
    allwise character varying(20), --/D AllWISE Identifier
    gaia character varying(20), --/D Gaia DR2 Identifier (source_id, string representation)
    apass character varying(30), --/D APASS Identifier
    kic integer, --/D KIC Identifier
    objtype character varying(16), --/D Object Type
    typesrc character varying(16), --/D Source of the object
    ra double precision, --/U degrees --/D Right Ascension epoch 2000
    [dec] double precision, --/U degrees --/D Declination epoch 2000
    posflag character varying(12), --/D Source of the position
    pmra real, --/U mas/yr --/D Proper Motion in Right Ascension
    e_pmra real, --/U mas/yr --/D Uncertainty in PM Right Ascension
    pmdec real, --/U mas/yr --/D Proper Motion in Declination
    e_pmdec real, --/U mas/yr --/D Uncertainty in PM Declination
    pmflag character varying(12), --/D Source of the Proper Motion
    plx real, --/U mas --/D Parallax
    e_plx real, --/U mas --/D Error in the parallax
    parflag character varying(12), --/D Source of the parallax
    gallong double precision, --/U degrees --/D Galactic Longitude
    gallat double precision, --/U degrees --/D Galactic Latitude
    eclong double precision, --/U degrees --/D Ecliptic Longitude
    eclat double precision, --/U degrees --/D Ecliptic Latitude
    bmag real, --/U mag --/D Johnson B
    e_bmag real, --/U mag --/D Uncertainty in Johnson B
    vmag real, --/U mag --/D Johnson V
    e_vmag real, --/U mag --/D Uncertainty in Johnson V
    umag real, --/U mag --/D Sloan u
    e_umag real, --/U mag --/D Uncertainty in Sloan u
    gmag real, --/U mag --/D Sloan g
    e_gmag real, --/U mag --/D Uncertainty in Sloan g
    rmag real, --/U mag --/D Sloan r
    e_rmag real, --/U mag --/D Uncertainty in Sloan r
    imag real, --/U mag --/D Sloan i
    e_imag real, --/U mag --/D Uncertainty in Sloan i
    zmag real, --/U mag --/D Sloan z
    e_zmag real, --/U mag --/D Uncertainty in Sloan z
    jmag real, --/U mag --/D 2MASS J
    e_jmag real, --/U mag --/D Uncertainty in 2MASS J
    hmag real, --/U mag --/D 2MASS H
    e_hmag real, --/U mag --/D Uncertainty in 2MASS H
    kmag real, --/U mag --/D 2MASS K
    e_kmag real, --/U mag --/D Uncertainty in 2MASS K
    twomflag character varying(20), --/D Quality Flags for 2MASS
    prox real, --/U arcsec --/D Distance to 2MASS nearest neighbor
    w1mag real, --/U mag --/D WISE W1
    e_w1mag real, --/U mag --/D Uncertainty in WISE W1
    w2mag real, --/U mag --/D WISE W2
    e_w2mag real, --/U mag --/D Uncertainty in WISE W2
    w3mag real, --/U mag --/D WISE W3
    e_w3mag real, --/U mag --/D Uncertainty in WISE W3
    w4mag real, --/U mag --/D WISE W4
    e_w4mag real, --/U mag --/D Uncertainty in WISE W4
    gaiamag real, --/U mag --/D Gaia G Mag
    e_gaiamag real, --/U mag --/D Uncertainty in Gaia G
    tmag real, --/U mag --/D TESS Magnitude
    e_tmag real, --/U mag --/D Uncertainty in TESS Magnitude
    tessflag character varying(20), --/D TESS Magnitude Flag
    spflag character varying(20), --/D Stellar Properties Flag
    teff real, --/U K --/D Effective Temperature
    e_teff real, --/U K --/D Uncertainty in Effective Temperature
    logg real, --/U log(cgs) --/D log of the Surface Gravity
    e_logg real, --/U log(cgs) --/D Uncertainty in Surface Gravity
    mh real, --/U dex --/D Metallicity
    e_mh real, --/U dex --/D Uncertainty in the Metallicity
    rad real, --/U solar --/D Radius
    e_rad real, --/U solar --/D Uncertainty in the Radius
    mass real, --/U solar --/D Mass
    e_mass real, --/U solar --/D Uncertainty in the Mass
    rho real, --/U solar --/D Stellar Density
    e_rho real, --/U solar --/D Uncertainty in the Stellar Density
    lumclass character varying(10), --/D Luminosity Class
    lum real, --/U solar --/D Stellar Luminosity
    e_lum real, --/U solar --/D Uncertainty in Luminosity
    d real, --/U pc --/D Distance
    e_d real, --/U pc --/D Uncertainty in the distance
    ebv real, --/U mag --/D Applied Color Excess
    e_ebv real, --/U mag --/D Uncertainty in Applied Color Excess
    numcont integer, --/D Number of Contamination Sources
    contratio real, --/D Contamination Ratio
    disposition character varying(10), --/D Disposition type
    duplicate_id bigint, --/D Points to the duplicate object TIC ID
    priority real, --/D CTL priority
    eneg_ebv real, --/U mag --/D Negative error for EBV
    epos_ebv real, --/U mag --/D Positive error for EBV
    ebvflag character varying(20), --/D Source of EBV
    eneg_mass real, --/U solar --/D Negative error for Mass
    epos_mass real, --/U solar --/D Positive error for Mass
    eneg_rad real, --/U solar --/D Negative error for Radius
    epos_rad real, --/U solar --/D Positive error for Radius
    eneg_rho real, --/U solar --/D Negative error for Density
    epos_rho real, --/U solar --/D Positive error for Density
    eneg_logg real, --/U log(cgs) --/D Negative error for Surface Gravity
    epos_logg real, --/U log(cgs) --/D Positive error for Surface Gravity
    eneg_lum real, --/U solar --/D Negative error for Luminosity
    epos_lum real, --/U solar --/D Positive error for Luminosity
    eneg_dist real, --/U pc --/D Negative Error for Distance
    epos_dist real, --/U pc --/D Positive Error for Distance
    distflag character varying(20), --/D Source of distance
    eneg_teff real, --/U K --/D Negative error for effective temperature
    epos_teff real, --/U K --/D Positive error for effective temperature
    tefflag character varying(20), --/D Source of effective Temperature
    gaiabp real, --/U mag --/D Gaia BP magnitude
    e_gaiabp real, --/U mag --/D Error in Gaia BP magnitude
    gaiarp real, --/U mag --/D Gaia RP magnitude
    e_gaiarp real, --/U mag --/D Error in Gaia RP magnitude
    gaiaqflag integer, --/D Quality of Gaia information
    starchareflag character varying(20), --/D Error of asymmetric errors
    vmagflag character varying(20), --/D Source of V magnitude
    bmagflag character varying(20), --/D Source of B magnitude
    splits character varying(20), --/D Identifies if star is in a specially curated list. (original TIC column
	--/D  is named splists).
    e_ra double precision, --/U mas --/D Error in RA
    e_dec double precision, --/U mas --/D Error in Dec
    ra_orig double precision, --/U degrees --/D RA from original catalog
    dec_orig double precision, --/U degrees --/D Dec from original catalog
    e_ra_orig double precision, --/U mas --/D RA error as given in original catalog
    e_dec_orig double precision, --/U mas --/D Dec error as given in original catalog
    raddflag integer, --/D 1=dwarf by radius, 0=giant by radius
    wdflag integer, --/D 1=star in Gaia's photometric "White Dwarf region"
    objid bigint, --/D Object identifier (integer)
    gaia_int bigint, --/D Gaia DR2 source ID (integer). Not originally in TIC v8.
    twomass_psc text, --/D 2MASS PSC identifier. Not originally in TIC v8.
    twomass_psc_pts_key integer, --/D 2MASS PSC identifier. Not originally in TIC v8.
    tycho2_tycid integer, --/D Tycho2 identifier (integer). Not originally in TIC v8.
    allwise_cntr bigint --/D ALLWISE ID (integer). Not originally in TIC v8.
)
GO
--


--
-- Name: mos_twomass_psc; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_twomass_psc')
	DROP TABLE mos_twomass_psc
GO
--
EXEC spSetDefaultFileGroup 'mos_twomass_psc'
GO
CREATE TABLE mos_twomass_psc (

----------------------------------------------------------------------
--/H 2MASS point source catalog. 
----------------------------------------------------------------------
--/T For full details, please see 
--/T https://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html
----------------------------------------------------------------------
    ra double precision, --/U degrees --/D Right ascenscion
    decl double precision, --/U degrees --/D Declination
    err_maj real, --/U arcsec --/D Semi-major axis of position error ellipse
    err_min real, --/U arcsec --/D Semi-minor axis of position error ellipse
    err_ang smallint, --/U degrees --/D Position angle of error ellipse major axis (E of N)
    j_m real, --/U mag --/D 2MASS J-band default magnitude
    j_cmsig real, --/U mag --/D J-band default magnitude uncertainty
    j_msigcom real, --/U mag --/D J-band total magnitude uncertainty
    j_snr real, --/D J-band signal-to-noise ratio
    h_m real, --/U mag --/D 2MASS H-band default magnitude
    h_cmsig real, --/U mag --/D H-band default magnitude uncertainty
    h_msigcom real, --/U mag --/D H-band total magnitude uncertainty
    h_snr real, --/D H-band signal-to-noise ratio
    k_m real, --/U mag --/D 2MASS K-band default magnitude
    k_cmsig real, --/U mag --/D K-band default magnitude uncertainty
    k_msigcom real, --/U mag --/D K-band total magnitude uncertainty
    k_snr real, --/D K-band signal-to-noise ratio
    ph_qual character(3), --/D JHK photometric quality flag {}
    rd_flg character(3), --/D Source of JHK default mag
    bl_flg character(3), --/D JHK components fit to source
    cc_flg character(3), --/D Artifact contamination, confusion flag
    ndet character(6), --/D Number of aperture measurements (jjhhkk)
    prox real, --/U arcsec --/D Distance between source and nearest neighbor
    pxpa smallint, --/U degrees --/D Position ange of vector from source to nearest neighbor (E of N)
    pxcntr integer, --/D Sequence number of nearest neighbor
    gal_contam smallint, --/D Extended source contamination flag
    mp_flg smallint, --/D Association with asteroid or comet flag
    pts_key integer NOT NULL, --/D A unique identification number for the PSC source
    hemis character(1), --/D Hemisphere code for the 2MASS Observatory from which this source was observed
    date date, --/U yyyy-mm-dd --/D The observation reference date for this source expressed in ISO standard format.
    scan smallint, --/D The nightly scan number in which the source was detected
    glon real, --/U degrees --/D Galactic longitude
    glat real, --/U degrees --/D Galactic latitude
    x_scan real, --/U arcsec --/D Mean cross-scan focal plane position of the source in the Universal scan 
	--/D (U-scan) coordinate system
    jdate double precision, --/U days --/D The Julian Date of the source measurement accurate to 30 seconds
    j_psfchi real, --/D Reduced chi-squared goodness-of-fit value for the J-band profile-fit photometry
    h_psfchi real, --/D Reduced chi-squared goodness-of-fit value for the H-band profile-fit photometry
    k_psfchi real, --/D Reduced chi-squared goodness-of-fit value for the K-band profile-fit photometry
    j_m_stdap real, --/U mag --/D J-band "standard" aperture magnitude
    j_msig_stdap real, --/U mag --/D Uncertainty in the J-band standard aperture magnitude
    h_m_stdap real, --/U mag --/D H-band "standard" aperture magnitude
    h_msig_stdap real, --/U mag --/D Uncertainty in the H-band standard aperture magnitude
    k_m_stdap real, --/U mag --/D K-band "standard" aperture magnitude
    k_msig_stdap real, --/U mag --/D Uncertainty in the K-band standard aperture magnitude
    dist_edge_ns integer, --/U arcsec --/D Distance from the source to the nearest North or South scan edge
    dist_edge_ew integer, --/U arcsec --/D Distance from the source to the nearest East or West scan edge
    dist_edge_flg character(2), --/D Flag that specifies to which scan edges a source lies closest and to 
	--/D which edges the dist_edge_ns and dist_edge_ew values refer
    dup_src smallint, --/D Duplicate source flag
    use_src smallint, --/D Use source flag
    a character(1), --/D Catalog identifier of an optical source from either the Tycho 2 or USN
	--/D O-A2.0 catalog that falls within approximately 5 arcsec of the 2MASS source position
    dist_opt real, --/U arcsec --/D Distance separating 2MASS source position and associated optical sourc
	--/D e
    phi_opt smallint, --/U degrees --/D Position angle on the sky of the vector from the the associated optica
	--/D l source to the 2MASS source position (East of North)
    b_m_opt real, --/U mag --/D Blue magnitude of associated optical source
    vr_m_opt real, --/U mag --/D Visual or red magnitude of the associated optical source
    nopt_mchs smallint, --/D The number of USNO-A2.0 or Tycho 2 optical sources found within a radius
	--/D of approximately 5 arcsec of the 2MASS position
    ext_key integer, --/D Unique identification number of the record in the XSC that corresponds
	--/D  to this point source
    scan_key integer, --/D Unique identification number of the record in the Scan Information Table
    coadd_key integer, --/D Unique identification number of the record in the Atlas Image Information Table
    coadd smallint, --/D Sequence number of the Atlas Image in which the position of this source falls
    designation text --/D Sexagesimal, equatorial position-based source
)
GO
--


--
-- Name: mos_tycho2; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_tycho2')
	DROP TABLE mos_tycho2
GO
--
EXEC spSetDefaultFileGroup 'mos_tycho2'
GO
CREATE TABLE mos_tycho2 (

----------------------------------------------------------------------
--/H Tycho-2 catalog. 
----------------------------------------------------------------------
--/T For complete details, please see the original Tycho-2 
--/T documentation from Hog et al (2020) https://ui.adsabs.harvard.edu/abs/2000A%26A...355L..27H/abstract 
--/T and https://www.cosmos.esa.int/web/hipparcos/tycho-2
----------------------------------------------------------------------
    tyc1 integer, --/D TYC1 from TYC or GSC (used to construct the Tycho identifier)
    tyc2 integer, --/D TYC2 from TYC or GSC (used to construct the Tycho identifier)
    tyc3 integer, --/D TYC3 from TYC (used to construct the Tycho identifier)
    pflag character varying(1), --/D Mean position flag
    ramdeg double precision, --/U degrees --/D Mean Right Asc, ICRS, epoch=J2000
    demdeg double precision, --/U degrees --/D Mean Decl, ICRS, at epoch=J2000
    pmra double precision, --/U mas/yr --/D Proper motion in RA*cos(dec)
    pmde double precision, --/U mas/yr --/D Proper motion in Dec
    e_ramdeg integer, --/U mas --/D standard error of RA*cos(dec) at mean epoch
    e_demdeg integer, --/U mas --/D standard error of Declination at mean epoch
    e_pmra double precision, --/U mas/yr --/D standard error of proper motion in RA*cos(dec)
    e_pmde double precision, --/U mas/yr --/D standard error of proper motion in Declination
    epram double precision, --/U yr --/D mean epoch of RA
    epdem double precision, --/U yr --/D mean epoch of Dec
    num integer, --/D Number of positions used
    q_ramdeg double precision, --/D Goodness of fit for mean RA
    q_demdeg double precision, --/D Goodness of fit for mean Dec
    q_pmra double precision, --/D Goodness of fit for pmra
    q_pmde double precision, --/D Goodness of fit for pmde
    btmag real, --/U mag --/D Tycho-2 BT magnitude
    e_btmag real, --/U mag --/D Standard error of BT magnitude
    vtmag real, --/U mag --/D Tycho-2 VT magnitude
    e_vtmag real, --/U mag --/D Standard error of VT magnitude
    prox integer, --/U 0.1 arcsec --/D Distance to the nearest entry in the Tycho-2 main catalogue or supplement
    tyc character varying(1), --/D Tycho-1 star flag
    hip bigint, --/D Hipparcos number
    ccdm character varying(3), --/D CCDM component identifiers for double or multiple Hipparcos stars contributing 
	--/D to this Tycho-2 entry
    radeg double precision, --/U degrees --/D Observed Tycho-2 Right Ascension, ICRS
    dedeg double precision, --/U degrees --/D Observed Tycho-2 Declination, ICRS
    epra_1990 double precision, --/U yr --/D epoch-1990 of RAdeg
    epde_1990 double precision, --/U yr --/D epoch-1990 of Dedeg
    e_radeg double precision, --/U mas --/D Standard error of RA*cos(dec), of observed Tycho-2 RA
    e_dedeg double precision, --/U mas --/D Standard error of observed Tycho-2 Dec
    posflg character varying(1), --/D Type of Tycho-2 solution
    corr real, --/D correlation (RAdeg,DEdeg)
    flag character varying(1), --/D flag indicating whether data from Hipparcos or Tycho-1
    mflag character varying(1), --/D magnitude flag
    designation text NOT NULL, --/D Unique Tycho designation
    tycid integer --/D Tycho ID
)
GO
--


--
-- Name: mos_uvotssc1; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_uvotssc1')
	DROP TABLE mos_uvotssc1
GO
--
EXEC spSetDefaultFileGroup 'mos_uvotssc1'
GO
CREATE TABLE mos_uvotssc1 (

----------------------------------------------------------------------
--/H Version 1.1 of the Swift UVOT Serendipitous Source Catalogue 
--/H (UVOTSSC). 
----------------------------------------------------------------------
--/T For full details, please see Page et al. (2015) at https://pos.sissa.it/233/037 
--/T and the online documentation at https://archive.stsci.edu/prepds/uvotssc/
----------------------------------------------------------------------
    name character varying(17), --/D UVOTSSC1 name (JHHMMSS.s+DDMMSSa)
    oseq bigint, --/D Reference number in the observation table
    obsid bigint, --/D Unique Swift observation ID
    nf bigint, --/D Number of filters included in this observation
    srcid bigint, --/D Unique source number
    radeg double precision, --/U degrees --/D Right ascension
    dedeg double precision, --/U degrees --/D Declination
    e_radeg double precision, --/U arcsec --/D Right ascension error
    e_dedeg double precision, --/U arcsec --/D Declination error
    ruvw2 real, --/U arcsec --/D Distance to closest UVW2 source
    ruvm2 real, --/U arcsec --/D Distance to closest UVM2 source
    ruvw1 real, --/U arcsec --/D Distance to closest UVW1 source
    ru real, --/U arcsec --/D Distance to closest U source
    rb real, --/U arcsec --/D Distance to closest B source
    rv real, --/U arcsec --/D Distance to closest V source
    nd bigint, --/D Number of individual observations
    suvw2 real, --/D Significance (S/N) in UVW2
    suvm2 real, --/D Significance (S/N) in UVM2
    suvw1 real, --/D Significance (S/N) in UVW1
    su real, --/D Significance (S/N) in U
    sb real, --/D Significance (S/N) in B
    sv real, --/D Significance (S/N) in V
    uvw2 double precision, --/U mag --/D UVOT/UVW2 Vega magnitude
    uvm2 double precision, --/U mag --/D UVOT/UVM2 Vega magnitude
    uvw1 double precision, --/U mag --/D UVOT/UVW1 Vega magnitude
    umag double precision, --/U mag --/D UVOT/U Vega magnitude
    bmag double precision, --/U mag --/D UVOT/B Vega magnitude
    vmag double precision, --/U mag --/D UVOT/V Vega magnitude
    uvw2_ab double precision, --/U mag --/D UVOT/UVW2 AB magnitude
    uvm2_ab double precision, --/U mag --/D UVOT/UVM2 AB magnitude
    uvw1_ab double precision, --/U mag --/D UVOT/UVW1 AB magnitude
    u_ab double precision, --/U mag --/D UVOT/U AB magnitude
    b_ab double precision, --/U mag --/D UVOT/B AB magnitude
    v_ab double precision, --/U mag --/D UVOT/V AB magnitude
    e_uvw2 double precision, --/U mag --/D Error on UVW2 magnitude
    e_uvm2 double precision, --/U mag --/D Error on UVM2 magnitude
    e_uvw1 double precision, --/U mag --/D Error on UVW1 magnitude
    e_umag double precision, --/U mag --/D Error on U magnitude
    e_bmag double precision, --/U mag --/D Error on B magnitude
    e_vmag double precision, --/U mag --/D Error on V magnitude
    f_uvw2 double precision, --/U cW/m2/nm --/D UVOT/UVW2 Flux
    f_uvm2 double precision, --/U cW/m2/nm --/D UVOT/UVM2 Flux
    f_uvw1 double precision, --/U cW/m2/nm --/D UVOT/UVW1 Flux
    f_u double precision, --/U cW/m2/nm --/D UVOT/U Flux
    f_b double precision, --/U cW/m2/nm --/D UVOT/B Flux
    f_v double precision, --/U cW/m2/nm --/D UVOT/V Flux
    e_f_uvw2 double precision, --/U cW/m2/nm --/D Error on F.UVW2
    e_f_uvm2 double precision, --/U cW/m2/nm --/D Error on F.UVM2
    e_f_uvw1 double precision, --/U cW/m2/nm --/D Error on F.UVW1
    e_f_u double precision, --/U cW/m2/nm --/D Error on F.U
    e_f_b double precision, --/U cW/m2/nm --/D Error on F.B
    e_f_v double precision, --/U cW/m2/nm --/D Error on F.V
    auvw2 double precision, --/U arcsec --/D Major axis in UVW2
    auvm2 double precision, --/U arcsec --/D Major axis in UVM2
    auvw1 double precision, --/U arcsec --/D Major axis in UVW1
    au double precision, --/U arcsec --/D Major axis in U
    ab double precision, --/U arcsec --/D Major axis in B
    av double precision, --/U arcsec --/D Major axis in V
    buvw2 double precision, --/U arcsec --/D Minor axis in UVW2
    buvm2 double precision, --/U arcsec --/D Minor axis in UVM2
    buvw1 double precision, --/U arcsec --/D Minor axis in UVW1
    bu double precision, --/U arcsec --/D Minor axis in U
    bb double precision, --/U arcsec --/D Minor axis in B
    bv double precision, --/U arcsec --/D Minor axis in V
    pauvw2 real, --/U degrees --/D Position angle of major axis in UVW2
    pauvm2 real, --/U degrees --/D Position angle of major axis in UVM2
    pauvw1 real, --/U degrees --/D Position angle of major axis in UVW1
    pau real, --/U degrees --/D Position angle of major axis in U
    pab real, --/U degrees --/D Position angle of major axis in B
    pav real, --/U degrees --/D Position angle of major axis in V
    xuvw2 integer, --/D Extended flag in UVW2
    xuvm2 integer, --/D Extended flag in UVM2
    xuvw1 integer, --/D Extended flag in UVW1
    xu integer, --/D Extended flag in U
    xb integer, --/D Extended flag in B
    xv integer, --/D Extended flag in V
    fuvw2 integer, --/D Quality flags in UVW2
    fuvm2 integer, --/D Quality flags in UVM2
    fuvw1 integer, --/D Quality flags in UVW1
    fu integer, --/D Quality flags in U
    fb integer, --/D Quality flags in B
    fv integer, --/D Quality flags in V
    id bigint NOT NULL --/D Internal identifier
)
GO
--


--
-- Name: mos_xmm_om_suss_4_1; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_xmm_om_suss_4_1')
	DROP TABLE mos_xmm_om_suss_4_1
GO
--
EXEC spSetDefaultFileGroup 'mos_xmm_om_suss_4_1'
GO
CREATE TABLE mos_xmm_om_suss_4_1 (

----------------------------------------------------------------------
--/H The 2018 release of the XMM OM Serendipitous Ultraviolet Source 
--/H Survey (XMM-SUSS4.1) Catalog. 
----------------------------------------------------------------------
--/T For full details, please see https://heasarc.gsfc.nasa.gov/W3Browse/all/xmmomsuob.html 
--/T and the original catalog paper (Page et al. 2012; 
--/T https://academic.oup.com/mnras/article/426/2/903/976665)
----------------------------------------------------------------------
    iauname character varying(22), --/D Coordinate-based name
    n_summary integer, --/D Reference number index for the XMM-Newton pointing in which the partic
	--/D ular detection was mad
    obsid character varying(10), --/D The exclusive 10-digit identification number of the XMM pointing with 
	--/D the detection
    srcnum integer, --/D The unique reference number within each combined source list created by the pipeline
    uvw2_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in UVW2
    uvm2_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in UVM2
    uvw1_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in UVW1
    u_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in U
    b_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in B
    v_srcdist real, --/U arcsec --/D Distance between source and nearest detected neighbor in V
    ra double precision, --/U degrees --/D Right ascension
    [dec] double precision, --/U degrees --/D Declination
    ra_hms character varying(13), --/U sexagesimal --/D Right ascension
    dec_dms character varying(14), --/U sexagesimal --/D Declination
    poserr real, --/U arcsec --/D Statistical error of the measured source position
    lii double precision, --/U degrees --/D Galactic longitude
    bii double precision, --/U degrees --/D Galactic latitude
    n_obsid integer, --/D Number of times a source has been detected during separate observations
    uvw2_signif real, --/D Significance of source detection in UVW2
    uvm2_signif real, --/D Significance of source detection in UVM2
    uvw1_signif real, --/D Significance of source detection in UVW1
    u_signif real, --/D Significance of source detection in U
    b_signif real, --/D Significance of source detection in B
    v_signif real, --/D Significance of source detection in V
    uvw2_rate real, --/U counts/s --/D Background-subtracted source count rate in UVW2 corrected for coincidence loss
    uvw2_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in UVW2
    uvm2_rate real, --/U counts/s --/D Background-subtracted source count rate in UVM2 corrected for coincidence loss
    uvm2_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in UVM2
    uvw1_rate real, --/U counts/s --/D Background-subtracted source count rate in UVW1 corrected for coincidence loss
    uvw1_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in UVW1
    u_rate real, --/U counts/s --/D Background-subtracted source count rate in U corrected for coincidence loss
    u_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in U
    b_rate real, --/U counts/s --/D Background-subtracted source count rate in B corrected for coincidence loss
    b_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in B
    v_rate real, --/U counts/s --/D Background-subtracted source count rate in V corrected for coincidence loss
    v_rate_err real, --/U counts/s --/D Uncertainty in the background-subtracted source count rate in V
    uvw2_ab_flux real, --/U erg/s/cm^2/A --/D UVW2 AB flux
    uvw2_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in UVW2 AB flux
    uvm2_ab_flux real, --/U erg/s/cm^2/A --/D UVM2 AB flux
    uvm2_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in UVM2 AB flux
    uvw1_ab_flux real, --/U erg/s/cm^2/A --/D UVW1 AB flux
    uvw1_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in UVW1 AB flux
    u_ab_flux real, --/U erg/s/cm^2/A --/D U AB flux
    u_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in U AB flux
    b_ab_flux real, --/U erg/s/cm^2/A --/D B AB flux
    b_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in B AB flux
    v_ab_flux real, --/U erg/s/cm^2/A --/D V AB flux
    v_ab_flux_err real, --/U erg/s/cm^2/A --/D Error in V AB flux
    uvw2_ab_mag real, --/U mag --/D UVW2 AB magnitude
    uvw2_ab_mag_err real, --/U mag --/D Error in UVW2 AB magnitude
    uvm2_ab_mag real, --/U mag --/D UVM2 AB magnitude
    uvm2_ab_mag_err real, --/U mag --/D Error in UVM2 AB magnitude
    uvw1_ab_mag real, --/U mag --/D UVW1 AB magnitude
    uvw1_ab_mag_err real, --/U mag --/D Error in UVW1 AB magnitude
    u_ab_mag real, --/U mag --/D U AB magnitude
    u_ab_mag_err real, --/U mag --/D Error in U AB magnitude
    b_ab_mag real, --/U mag --/D B AB magnitude
    b_ab_mag_err real, --/U mag --/D Error in B AB magnitude
    v_ab_mag real, --/U mag --/D V AB magnitude
    v_ab_mag_err real, --/U mag --/D Error in V AB magnitude
    uvw2_vega_mag real, --/U mag --/D UVW2 Vega magnitude
    uvw2_vega_mag_err real, --/U mag --/D Error in UVW2 Vega magnitude
    uvm2_vega_mag real, --/U mag --/D UVM2 Vega magnitude
    uvm2_vega_mag_err real, --/U mag --/D Error in UVM2 Vega magnitude
    uvw1_vega_mag real, --/U mag --/D UVW1 Vega magnitude
    uvw1_vega_mag_err real, --/U mag --/D Error in UVW1 Vega magnitude
    u_vega_mag real, --/U mag --/D U Vega magnitude
    u_vega_mag_err real, --/U mag --/D Error in U Vega magnitude
    b_vega_mag real, --/U mag --/D B Vega magnitude
    b_vega_mag_err real, --/U mag --/D Error in B Vega magnitude
    v_vega_mag real, --/U mag --/D V Vega magnitude
    v_vega_mag_err real, --/U mag --/D Error in V Vega magnitude
    uvw2_major_axis real, --/U arcsec --/D Length of major axis in UVW2
    uvm2_major_axis real, --/U arcsec --/D Length of major axis in UVM2
    uvw1_major_axis real, --/U arcsec --/D Length of major axis in UVW1
    u_major_axis real, --/U arcsec --/D Length of major axis in U
    b_major_axis real, --/U arcsec --/D Length of major axis in B
    v_major_axis real, --/U arcsec --/D Length of major axis in V
    uvw2_minor_axis real, --/U arcsec --/D Length of minor axis in UVW2
    uvm2_minor_axis real, --/U arcsec --/D Length of minor axis in UVM2
    uvw1_minor_axis real, --/U arcsec --/D Length of minor axis in UVW1
    u_minor_axis real, --/U arcsec --/D Length of minor axis in U
    b_minor_axis real, --/U arcsec --/D Length of minor axis in B
    v_minor_axis real, --/U arcsec --/D Length of minor axis in V
    uvw2_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in UVW2
    uvm2_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in UVM2
    uvw1_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in UVW1
    u_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in U
    b_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in B
    v_posang real, --/U degrees --/D Angle on the sky subtended by the major axis of the source and J2000 north in V
    uvw2_quality_flag smallint, --/D UVW2 quality flag
    uvm2_quality_flag smallint, --/D UVM2 quality flag
    uvw1_quality_flag smallint, --/D UVW1 quality flag
    u_quality_flag smallint, --/D U quality flag
    b_quality_flag smallint, --/D B quality flag
    v_quality_flag smallint, --/D V quality flag
    uvw2_quality_flag_st character varying(12), --/D Alternative UVW2 quality flag
    uvm2_quality_flag_st character varying(12), --/D Alternative UVM2 quality flag
    uvw1_quality_flag_st character varying(12), --/D Alternative UVW1 quality flag
    u_quality_flag_st character varying(12), --/D Alternative U quality flag
    b_quality_flag_st character varying(12), --/D Alternative B quality flag
    v_quality_flag_st character varying(12), --/D Alternative V quality flag
    uvw2_extended_flag bigint, --/D Spatially extended flag in UVW2
    uvm2_extended_flag bigint, --/D Spatially extended flag in UVM2
    uvw1_extended_flag bigint, --/D Spatially extended flag in UVW1
    u_extended_flag bigint, --/D Spatially extended flag in U
    b_extended_flag bigint, --/D Spatially extended flag in B
    v_extended_flag bigint, --/D Spatially extended flag in V
    uvw2_sky_image character varying(4), --/D Flag for stakcked sky images in UVW2
    uvm2_sky_image character varying(4), --/D Flag for stakcked sky images in UVM2
    uvw1_sky_image character varying(4), --/D Flag for stakcked sky images in UVW1
    u_sky_image character varying(4), --/D Flag for stakcked sky images in U
    b_sky_image character varying(4), --/D Flag for stakcked sky images in B
    v_sky_image character varying(4), --/D Flag for stakcked sky images in V
    pk bigint NOT NULL --/D Primary key
)
GO
--


--
-- Name: mos_yso_clustering; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_yso_clustering')
	DROP TABLE mos_yso_clustering
GO
--
EXEC spSetDefaultFileGroup 'mos_yso_clustering'
GO
CREATE TABLE mos_yso_clustering (

----------------------------------------------------------------------
--/H YSO candidates from Kounkel et al. 2020. 
----------------------------------------------------------------------
--/T Please see details in the original paper: 
--/T https://iopscience.iop.org/article/10.3847/1538-3881/abc0e6
----------------------------------------------------------------------
    source_id bigint NOT NULL, --/D Gaia DR2 source id
    twomass text, --/D 2MASS ID
    ra double precision, --/U degrees --/D Right ascention in J2000 reference frame
    [dec] double precision, --/U degrees --/D Declination in J2000 reference frame
    parallax real, --/U mas --/D Parallax from Gaia DR2
    id integer, --/D Identification of a parent group from Kounkel et al. (2020)
    g double precision, --/U mag --/D Gaia (DR2) G band magnitude
    bp double precision, --/U mag --/D Gaia (DR2) BP band magnitude
    rp double precision, --/U mag --/D Gaia (DR2) RP band magnitude
    j real, --/U mag --/D 2MASS J band magnitude
    h real, --/U mag --/D 2MASS H band magnitude
    k real, --/U mag --/D 2MASS K band magnitude
    age double precision, --/U log yr --/D Estimate of the age of the parent group from Kounkel et al. (2020)
    eage double precision, --/U log yr --/D Uncertainty in age
    av double precision, --/U mag --/D Estimate of extinction of the parent group from Kounkel et al. (2020)
    eav double precision, --/U mag --/D Uncertainty in av
    dist double precision, --/U pc --/D Estimate of distance of the parent group from Kounkel et al. (2020)
    edist double precision --/U pc --/D Uncertainty in dist
)
GO
--


--
-- Name: mos_zari18pms; Type: TABLE; Schema: minidb; Owner: -
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mos_zari18pms')
	DROP TABLE mos_zari18pms
GO
--
EXEC spSetDefaultFileGroup 'mos_zari18pms'
GO
CREATE TABLE mos_zari18pms (

----------------------------------------------------------------------
--/H Pre-main sequence (PMS) catalogue from Zari+2018.
----------------------------------------------------------------------
    source bigint NOT NULL, --/D Unique source identifier (Gaia DR2 source_id)
    glon double precision, --/U deg --/D Galactic longitude
    glat double precision, --/U deg --/D Galactic latitude
    plx real, --/U mas --/D Parallax
    e_plx real, --/U mas --/D Standard error of parallax (parallax_error)
    pmglon real, --/U mas/yr --/D Proper motion in galactic longitude
    e_pmglon real, --/U mas/yr --/D Standard error of proper motion in galactic longitude
    pmglat real, --/U mas/yr --/D Proper motion in galactic latitude
    e_pmglat real, --/U mas/yr --/D Standard error of proper motion in galactic latitude
    pmlbcorr real, --/D Correlation between proper motion in galactic longitude and proper mot
	--/D ion in galactic latitude
    rv real, --/U km/s --/D radial velocity
    e_rv real, --/U km/s --/D radial velocity error
    gmag real, --/U mag --/D G-band mean magnitude (phot_g_mean_mag)
    bpmag real, --/U mag --/D BP-band mean magnitude (phot_bp_mean_mag)
    rpmag real, --/U mag --/D RP-band mean magnitude (phot_g_mean_mag)
    bp_over_rp real, --/D BP/RP excess factor
    chi2al real, --/D AL chi-square value (astrometric_chi2_al)
    ngal integer, --/D Number of good observation AL (astrometric_n_good_obs_al)
    ag real, --/U mag --/D Extinction in G-band (A_G)
    bp_rp real, --/U mag --/D Colour excess in BP-RP
    uwe real --/D Unit Weight Error, as defined in Lindegren et al., 2018A&A...616A...2L
)
GO
--


