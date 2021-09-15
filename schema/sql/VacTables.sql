--======================================================================
--   VacTables.sql
--   2018-07-17 Ani Thakar
------------------------------------------------------------------------
--  Value Added Catalog (VAC) Table Schema for SkyServer 
------------------------------------------------------------------------
-- History:
--* 2018-07-17	Ani: Created file.
--* 2018-07-26  Ani: Updated schema as per latest version in sas/sql. (DR14-mini)
--* 2018-07-29  Ani: Updated schema as per latest version in sas/sql, where
--*                  several columns were changed to float from real. (DR14-mini)
--* 2019-09-27  Ani: Added PawlikMorph table, updated spiders_quasar. (DR16)
--* 2021-08-04  Ani: Added SDSS17Pipe3D_v3_1_1 VAC table. (DR17)
--* 2021-08-05  Ani: Added apogee_starhorse VAC table. (DR17).
--* 2021-08-06  Ani: Added apogeeDistMass, ebossMCPM VAC tables. (DR17).
--* 2021-08-11  Ani: Added mangaFirefly_mastar,_miles VAC tables. (DR17).
------------------------------------------------------------------------

SET NOCOUNT ON;
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'spiders_quasar')
	DROP TABLE spiders_quasar
GO
--
EXEC spSetDefaultFileGroup 'spiders_quasar'
GO


CREATE TABLE spiders_quasar (
-------------------------------------------------------------------------------
--/H The SPIDERS quasar eRosita source
-------------------------------------------------------------------------------
--/T This table contains data for the SPIDERS (SPectroscopic IDentification
--/T of ERosita  Sources) quasar spectroscopic followup Value Added Catalog
--/T (VAC) based on SDSS DR14.
-------------------------------------------------------------------------------
  xray_detection 		varchar(16) NOT NULL,		--/D Flag indicating whether the X-ray source was detected in the 2RXS or XMMSL2 survey.
  name 					varchar(32) NOT NULL,       --/D IAU name of the X-ray detection.
  RA					float NOT NULL,				--/D Right ascension of the X-ray detection (J2000).
  DEC					float NOT NULL,				--/D Declination of the X-ray detection (J2000).
  ExiML_2RXS			real NOT NULL,				--/D Existence likelihood of the 2RXS X-ray detection.
  ExpTime_2RXS			real NOT NULL,				--/D Exposure time of the 2RXS X-ray detection.
  DETML_XMMSL2			real NOT NULL, 				--/D Detection likelihood of the XMMSL2 detection in the 0.2-12 keV range. 
  ExpTime_XMMSL2		real NOT NULL,				--/D Exposure time of the XMMSL2 X-ray detection.
  f_class_2RXS			real NOT NULL,				--/D Classical flux in the 0.1-2.4 keV range (2RXS).
  errf_class_2RXS		real NOT NULL,				--/D Uncertainty in the classical flux in the 0.1-2.4 keV range (2RXS).
  f_bay_2RXS			real NOT NULL,				--/D Bayesian flux in the 0.1-2.4 keV range (2RXS).
  errf_bay_2RXS			real NOT NULL,				--/D Uncertainty in the Bayesian flux in the 0.1-2.4 keV range (2RXS).
  fden_class_2RXS		real NOT NULL,				--/D Classical flux density at 2 keV (2RXS).
  errfden_class_2RXS	real NOT NULL,				--/D Uncertainty in the classical flux density at 2 keV (2RXS).
  fden_bay_2RXS			real NOT NULL,				--/D Bayesian flux density at 2 keV (2RXS).
  errfden_bay_2RXS		real NOT NULL,				--/D Uncertainty in the Bayesian flux density at 2 keV (2RXS).
  l_class_2RXS			real NOT NULL,				--/D Classical luminosity in the 0.1-2.4 keV range (2RXS).
  errl_class_2RXS		real NOT NULL,				--/D Uncertainty in the classical luminosity in the 0.1-2.4 keV range (2RXS).
  l_bay_2RXS			real NOT NULL,				--/D Bayesian luminosity in the 0.1-2.4 keV range (2RXS).
  errl_bay_2RXS			real NOT NULL,				--/D Uncertainty in the Bayesian luminosity in the 0.1-2.4 keV range (2RXS).
  l2keV_class_2RXS		real NOT NULL,				--/D Classical monochromatic luminosity at 2 keV (2RXS).
  errl2keV_class_2RXS	real NOT NULL,				--/D Uncertainty in the classical monochromatic luminosity at 2 keV (2RXS).
  l2keV_bay_2RXS		real NOT NULL,				--/D Bayesian monochromatic luminosity at 2 keV (2RXS).
  errl2keV_bay_2RXS		real NOT NULL,				--/D Uncertainty in the Bayesian monochromatic luminosity at 2 keV (2RXS).
  f_XMMSL2				real NOT NULL,				--/D Flux in the 0.2-12 keV range (XMMSL2; Saxton et al. (2008)).
  errf_XMMSL2			real NOT NULL,				--/D Uncertainty in the flux in the 0.2-12 keV range (XMMSL2; Saxton et al. (2008)).
  l_XMMSL2				real NOT NULL,				--/D Luminosity in the 0.2-12 keV range (XMMSL2; Saxton et al. (2008)).
  errl_XMMSL2			real NOT NULL,				--/D Uncertainty in the luminosity in the 0.2-12keV range (XMMSL2; Saxton et al. (2008)).
  Plate					int NOT NULL,			--/D SDSS plate number.
  MJD					int NOT NULL,			--/D MJD that the SDSS spectrum was taken.
  FiberID				int NOT NULL,			--/D SDSS fiber identification.
  DR16_RUN2D			varchar(32) NOT NULL,		--/D Spectroscopic reprocessing number.
  SPECOBJID				numeric(20) NOT NULL,				--/D Unique spectroscopic object ID.
  DR16_PLUGRA			float NOT NULL,				--/D Right ascension of the drilled fiber position.
  DR16_PLUGDEC			float NOT NULL,				--/D Declination of the drilled fiber position.
  redshift				real NOT NULL,				--/D Source redshift based on the visual inspection results.
  CLASS_BEST			varchar(32) NOT NULL,		--/D Source classification based on the visual inspection results.
  CONF_BEST				bigint NOT NULL,			--/D Visual inspection redshift and classification confidence flag.
  DR16_ZWARNING			bigint NOT NULL,			--/D Warning flag for SDSS spectra.
  DR16_SNMEDIANALL		real NOT NULL,				--/D Median signal to noise ratio per pixel of the spectrum.
  Instrument			varchar(32) NOT NULL,		--/D Flag indicating which spectrograph was used (SDSS or BOSS) to measure the spectrum.
  norm1_mgII			real NOT NULL,				--/D Normalisation of the first Gaussian used to fit the MgII line.
  errnorm1_mgII			real NOT NULL,				--/D Uncertainty in the normalisation of the first Gaussian used to fit the MgII line.
  peak1_mgII			real NOT NULL,				--/D Wavelength of the peak of the first Gaussian used to fit the MgII line.
  errpeak1_mgII			real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the first Gaussian used to fit the MgII line.
  width1_mgII			real NOT NULL,				--/D Width of the first Gaussian used to fit the MgII line.
  errwidth1_mgII		real NOT NULL,				--/D Uncertainty in the width of the first Gaussian used to fit the MgII line.
  fwhm1_mgII			real NOT NULL,				--/D FWHM of the first Gaussian used to fit the MgII line.
  errfwhm1_mgII			real NOT NULL,				--/D Uncertainty in the FWHM of the first Gaussian used to fit the MgII line.
  shift1_mgII			real NOT NULL,				--/D Wavelength shift of the peak of the first Gaussian used to fit the MgII line relative to the rest-frame wavelength.
  norm2_mgII			real NOT NULL,				--/D Normalisation of the second Gaussian used to fit the MgII line.
  errnorm2_mgII			real NOT NULL,				--/D Uncertainty in the normalisation of the second Gaussian used to fit the MgII line.
  peak2_mgII			real NOT NULL,				--/D Wavelength of the peak of the second Gaussian used to fit the MgII line.
  errpeak2_mgII			real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the second Gaussian used to fit the MgII line.
  width2_mgII			real NOT NULL,				--/D Width of the second Gaussian used to fit the MgII line.
  errwidth2_mgII		real NOT NULL,				--/D Uncertainty in the width of the second Gaussian used to fit the MgII line.
  fwhm2_mgII			real NOT NULL,				--/D FWHM of the second Gaussian used to fit the MgII line.
  errfwhm2_mgII			real NOT NULL,				--/D Uncertainty in the FWHM of the second Gaussian used to fit the MgII line.
  shift2_mgII			real NOT NULL,				--/D Wavelength shift of the peak of the second Gaussian used to fit the MgII line relative to the rest-frame wavelength.
  norm3_mgII			real NOT NULL,				--/D Normalisation of the third Gaussian used to fit the MgII line.
  errnorm3_mgII			real NOT NULL,				--/D Uncertainty in the normalisation of the third Gaussian used to fit the MgII line.
  peak3_mgII			real NOT NULL,				--/D Wavelength of the peak of the third Gaussian used to fit the MgII line.
  errpeak3_mgII			real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the third Gaussian used to fit the MgII line.
  width3_mgII			real NOT NULL,				--/D Width of the third Gaussian used to fit the MgII line.
  errwidth3_mgII		real NOT NULL,				--/D Uncertainty in the width of the third Gaussian used to fit the MgII line.
  fwhm3_mgII			real NOT NULL,				--/D FWHM of the third Gaussian used to fit the MgII line.
  errfwhm3_mgII			real NOT NULL,				--/D Uncertainty in the FWHM of the third Gaussian used to fit the MgII line.
  shift3_mgII			real NOT NULL,				--/D Wavelength shift of the peak of the third Gaussian used to fit the MgII line relative to the rest-frame wavelength.
  norm_heII				real NOT NULL,				--/D Normalisation of the Gaussian used to fit the HeII line.
  errnorm_heII			real NOT NULL,				--/D Uncertainty in the normalisation of the Gaussian used to fit the HeII line.
  peak_heII				real NOT NULL,				--/D Wavelength of the peak of the Gaussian used to fit the HeII line.
  errpeak_heII			real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the Gaussian used to fit the HeII line.
  width_heII			real NOT NULL,				--/D Width of the Gaussian used to fit the HeII line.
  errwidth_heII			real NOT NULL,				--/D Uncertainty in the width of the Gaussian used to fit the HeII line.
  fwhm_heII				real NOT NULL,				--/D FWHM of the Gaussian used to fit the HeII line.
  errfwhm_heII			real NOT NULL,				--/D Uncertainty in the FWHM of the Gaussian used to fit the HeII line.
  shift_heII			real NOT NULL,				--/D Wavelength shift of the peak of the Gaussian used to fit the HeII line relative to the rest-frame wavelength.
  norm1_hb				real NOT NULL,				--/D Normalisation of the first Gaussian used to fit the H beta line.
  errnorm1_hb			real NOT NULL,				--/D Uncertainty in the normalisation of the first Gaussian used to fit the H beta line.
  peak1_hb				real NOT NULL,				--/D Wavelength of the peak of the first Gaussian used to fit the H beta line.
  errpeak1_hb			real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the first Gaussian used to fit the H beta line.
  width1_hb				real NOT NULL,				--/D Width of the first Gaussian used to fit the H beta line.
  errwidth1_hb			real NOT NULL,				--/D Uncertainty in the width of the first Gaussian used to fit the H beta line.
  fwhm1_hb				real NOT NULL,				--/D FWHM of the first Gaussian used to fit the H beta line.
  errfwhm1_hb			real NOT NULL,				--/D Uncertainty in the FWHM of the first Gaussian used to fit the H beta line.
  shift1_hb				real NOT NULL,				--/D Wavelength shift of the peak of the first Gaussian used to fit the H beta line relative to the rest-frame wavelength.
  norm2_hb				real NOT NULL,				--/D Normalisation of the second Gaussian used to fit the H beta line.
  errnorm2_hb			real NOT NULL,				--/D Uncertainty in the normalisation of the second Gaussian used to fit the H beta line.
  peak2_hb				real NOT NULL,				--/D Wavelength of the peak of the second Gaussian used to fit the H beta line.
  errpeak2_hb			real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the second Gaussian used to fit the H beta line.
  width2_hb				real NOT NULL,				--/D Width of the second Gaussian used to fit the H beta line.
  errwidth2_hb			real NOT NULL,				--/D Uncertainty in the width of the second Gaussian used to fit the H beta line.
  fwhm2_hb				real NOT NULL,				--/D FWHM of the second Gaussian used to fit the H beta line.
  errfwhm2_hb			real NOT NULL,				--/D Uncertainty in the FWHM of the second Gaussian used to fit the H beta line.
  shift2_hb				real NOT NULL,				--/D Wavelength shift of the peak of the second Gaussian used to fit the H beta line relative to the rest-frame wavelength.
  norm3_hb				real NOT NULL,				--/D Normalisation of the third Gaussian used to fit the H beta line.
  errnorm3_hb			real NOT NULL,				--/D Uncertainty in the normalisation of the third Gaussian used to fit the H beta line.
  peak3_hb				real NOT NULL,				--/D Wavelength of the peak of the third Gaussian used to fit the H beta line.
  errpeak3_hb			real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the third Gaussian used to fit the H beta line.
  width3_hb				real NOT NULL,				--/D Width of the third Gaussian used to fit the H beta line.
  errwidth3_hb			real NOT NULL,				--/D Uncertainty in the width of the third Gaussian used to fit the H beta line.
  fwhm3_hb				real NOT NULL,				--/D FWHM of the third Gaussian used to fit the H beta line.
  errfwhm3_hb			real NOT NULL,				--/D Uncertainty in the FWHM of the third Gaussian used to fit the H beta line.
  shift3_hb				real NOT NULL,				--/D Wavelength shift of the peak of the third Gaussian used to fit the H beta line relative to the rest-frame wavelength.
  norm4_hb				real NOT NULL,				--/D Normalisation of the fourth Gaussian used to fit the H beta line.
  errnorm4_hb			real NOT NULL,				--/D Uncertainty in the normalisation of the fourth Gaussian used to fit the H beta line.
  peak4_hb				real NOT NULL,				--/D Wavelength of the peak of the fourth Gaussian used to fit the H beta line.
  errpeak4_hb			real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the fourth Gaussian used to fit the H beta line.
  width4_hb				real NOT NULL,				--/D Width of the fourth Gaussian used to fit the H beta line.
  errwidth4_hb			real NOT NULL,				--/D Uncertainty in the width of the fourth Gaussian used to fit the H beta line.
  fwhm4_hb				real NOT NULL,				--/D FWHM of the fourth Gaussian used to fit the H beta line.
  errfwhm4_hb			real NOT NULL,				--/D Uncertainty in the FWHM of the fourth Gaussian used to fit the H beta line.
  shift4_hb				real NOT NULL,				--/D Wavelength shift of the peak of the fourth Gaussian used to fit the H beta line relative to the rest-frame wavelength.
  norm1_OIII4959		real NOT NULL,				--/D Normalisation of the first Gaussian used to fit the [OIII]4959 line.
  errnorm1_OIII4959		real NOT NULL,				--/D Uncertainty in the normalisation of the first Gaussian used to fit the [OIII]4959 line.
  peak1_OIII4959		real NOT NULL,				--/D Wavelength of the peak of the first Gaussian used to fit the [OIII]4959 line.
  errpeak1_OIII4959		real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the first Gaussian used to fit the [OIII]4959 line.
  width1_OIII4959		real NOT NULL,				--/D Width of the first Gaussian used to fit the [OIII]4959 line.
  errwidth1_OIII4959	real NOT NULL,				--/D Uncertainty in the width of the first Gaussian used to fit the [OIII]4959 line.
  fwhm1_OIII4959		real NOT NULL,				--/D FWHM of the first Gaussian used to fit the [OIII]4959 line.
  errfwhm1_OIII4959		real NOT NULL,				--/D Uncertainty in the FWHM of the first Gaussian used to fit the [OIII]4959 line.
  shift1_OIII4959		real NOT NULL,				--/D Wavelength shift of the peak of the first Gaussian used to fit the [OIII]4959 line relative to the rest-frame wavelength.
  norm2_OIII4959		real NOT NULL,				--/D Normalisation of the second Gaussian used to fit the [OIII]4959 line.
  errnorm2_OIII4959		real NOT NULL,				--/D Uncertainty in the normalisation of the second Gaussian used to fit the [OIII]4959 line.
  peak2_OIII4959		real NOT NULL,				--/D Wavelength of the peak of the second Gaussian used to fit the [OIII]4959 line.
  errpeak2_OIII4959		real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the second Gaussian used to fit the [OIII]4959 line.
  width2_OIII4959		real NOT NULL,				--/D Width of the second Gaussian used to fit the [OIII]4959 line.
  errwidth2_OIII4959	real NOT NULL,				--/D Uncertainty in the width of the second Gaussian used to fit the [OIII]4959 line.
  fwhm2_OIII4959		real NOT NULL,				--/D FWHM of the second Gaussian used to fit the [OIII]4959 line.
  errfwhm2_OIII4959		real NOT NULL,				--/D Uncertainty in the FWHM of the second Gaussian used to fit the [OIII]4959 line.
  shift2_OIII4959		real NOT NULL,				--/D Wavelength shift of the peak of the second Gaussian used to fit the [OIII]4959 line relative to the rest-frame wavelength.
  norm1_OIII5007		real NOT NULL,				--/D Normalisation of the first Gaussian used to fit the [OIII]5007 line.
  errnorm1_OIII5007		real NOT NULL,				--/D Uncertainty in the normalisation of the first Gaussian used to fit the [OIII]5007 line.
  peak1_OIII5007		real NOT NULL,				--/D Wavelength of the peak of the first Gaussian used to fit the [OIII]5007 line.
  errpeak1_OIII5007		real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the first Gaussian used to fit the [OIII]5007 line.
  width1_OIII5007		real NOT NULL,				--/D Width of the first Gaussian used to fit the [OIII]5007 line.
  errwidth1_OIII5007	real NOT NULL,				--/D Uncertainty in the width of the first Gaussian used to fit the [OIII]5007 line.
  fwhm1_OIII5007		real NOT NULL,				--/D FWHM of the first Gaussian used to fit the [OIII]5007 line.
  errfwhm1_OIII5007		real NOT NULL,				--/D Uncertainty in the FWHM of the first Gaussian used to fit the [OIII]5007 line.
  shift1_OIII5007		real NOT NULL,				--/D Wavelength shift of the peak of the first Gaussian used to fit the [OIII]5007 line relative to the rest-frame wavelength.
  norm2_OIII5007		real NOT NULL,				--/D Normalisation of the second Gaussian used to fit the [OIII]5007 line.
  errnorm2_OIII5007		real NOT NULL,				--/D Uncertainty in the normalisation of the second Gaussian used to fit the [OIII]5007 line.
  peak2_OIII5007		real NOT NULL,				--/D Wavelength of the peak of the second Gaussian used to fit the [OIII]5007 line.
  errpeak2_OIII5007		real NOT NULL,				--/D Uncertainty in the wavelength of the peak of the second Gaussian used to fit the [OIII]5007 line.
  width2_OIII5007		real NOT NULL,				--/D Width of the second Gaussian used to fit the [OIII]5007 line.
  errwidth2_OIII5007	real NOT NULL,				--/D Uncertainty in the width of the second Gaussian used to fit the [OIII]5007 line.
  fwhm2_OIII5007		real NOT NULL,				--/D FWHM of the second Gaussian used to fit the [OIII]5007 line.
  errfwhm2_OIII5007		real NOT NULL,				--/D Uncertainty in the FWHM of the second Gaussian used to fit the [OIII]5007 line.
  shift2_OIII5007		real NOT NULL,				--/D Wavelength shift of the peak of the second Gaussian used to fit the [OIII]5007 line relative to the rest-frame wavelength.
  norm_pl1				float NOT NULL,				--/D Normalisation of the power law fit to the MgII continuum region.
  errnorm_pl1			float NOT NULL,				--/D Uncertainty in the normalisation of the power law fit to the MgII continuum region.
  slope_pl1				real NOT NULL,				--/D Slope of the power law fit to the MgII continuum region.
  errslope_pl1			real NOT NULL,				--/D Uncertainty in the slope of the power law fit to the MgII continuum region.
  norm_pl2				float NOT NULL,				--/D Normalisation of the power law fit to the H beta continuum region.
  errnorm_pl2			float NOT NULL,				--/D Uncertainty in the normalisation of the power law fit to the H beta continuum region.
  slope_pl2				real NOT NULL,				--/D Slope of the power law fit to the H beta continuum region.
  errslope_pl2			real NOT NULL,				--/D Uncertainty in the slope of the power law fit to the H beta continuum region.
  norm_gal1				real NOT NULL,				--/D Normalisation of the galaxy template used to fit the MgII continuum region.
  errnorm_gal1			real NOT NULL,				--/D Uncertainty in the normalisation of the galaxy template used to fit the MgII continuum region.
  norm_gal2				real NOT NULL,				--/D Normalisation of the galaxy template used to fit the H beta continuum region.
  errnorm_gal2			real NOT NULL,				--/D Uncertainty in the normalisation of the galaxy template used to fit the H beta continuum region.
  norm_feII1    		real NOT NULL,				--/D Normalisation of the iron template used to fit the MgII continuum region.
  errnorm_feII1    		real NOT NULL,				--/D Uncertainty in the normalisation of the iron template used to fit the MgII continuum region.
  norm_feII2    		real NOT NULL,				--/D Normalisation of the iron template used to fit the H beta continuum region.
  errnorm_feII2    		real NOT NULL,				--/D Uncertainty in the normalisation of the iron template used to fit the H beta continuum region.
  fwhm_feII1    		real NOT NULL,				--/D FWHM of the Gaussian kernel convolved with the iron template used to fit the MgII continuum region.
  errfwhm_feII1    		real NOT NULL,				--/D Uncertainty in the FWHM of the Gaussian kernel convolved with the iron template used to fit the MgII continuum region.
  fwhm_feII2    		real NOT NULL,				--/D FWHM of the Gaussian kernel convolved with the iron template used to fit the H beta continuum region.
  errfwhm_feII2    		real NOT NULL,				--/D Uncertainty in the FWHM of the Gaussian kernel convolved with the iron template used to fit the H beta continuum region.
  r_feII    			real NOT NULL,				--/D Flux ratio of the 4434-4684 Ang FeII emission to the broad component of H beta.
  OIII_Hbeta_ratio    	real NOT NULL,				--/D Flux ratio of [OIII]5007 Ang to H beta.
  virialfwhm_mgII    	real NOT NULL,				--/D FWHM of the MgII broad line profile.
  errvirialfwhm_mgII1    real NOT NULL,				--/D Uncertainty in the FWHM of the MgII broad line profile.
  virialfwhm_hb    		real NOT NULL,				--/D FWHM of the H beta broad line profile.
  errvirialfwhm_hb    	real NOT NULL,				--/D Uncertainty in the FWHM of the H beta broad line profile.
  mgII_chi    			real NOT NULL,				--/D Reduced chi-squared of the fit to the MgII region.
  hb_chi    			real NOT NULL,				--/D Reduced chi-squared of the fit to the H beta region.
  l2500          		float NOT NULL,				--/D Monochromatic luminosity at 2500 Ang.
  errl2500          	float NOT NULL,				--/D Uncertainty in the monochromatic luminosity at 2500 Ang.
  l3000          		float NOT NULL,				--/D Monochromatic luminosity at 3000 Ang.
  errl3000          	float NOT NULL,				--/D Uncertainty in the monochromatic luminosity at 3000 Ang.
  l5100          		float NOT NULL,				--/D Monochromatic luminosity at 5100 Ang.
  errl5100          	float NOT NULL,				--/D Uncertainty in the monochromatic luminosity at 5100 Ang.
  l_bol1          		float NOT NULL,				--/D Bolometric luminosity derived from the monochromatic luminosity at 3000 Ang.
  errl_bol1          	float NOT NULL,				--/D Uncertainty in the bolometric luminosity derived from the monochromatic luminosity at 3000 Ang.
  l_bol2          		float NOT NULL,				--/D Bolometric luminosity derived from the monochromatic luminosity at 5100 Ang.
  errl_bol2          	float NOT NULL,				--/D Uncertainty in the bolometric luminosity derived from the monochromatic luminosity at 5100 Ang.
  logBHMVP_hb   		real NOT NULL,				--/D Black hole mass derived from the H beta line using the Vestergaard & Peterson (2006) calibration.
  errlogBHMVP_hb   		real NOT NULL,				--/D Uncertainty in the black hole mass derived from the H beta line using the Vestergaard & Peterson (2006) calibration.
  logBHMA_hb   			real NOT NULL,				--/D Black hole mass derived from the H beta line using the Assef et al. (2011) calibration.
  errlogBHMA_hb   		real NOT NULL,				--/D Uncertainty in the black hole mass derived from the H beta line using the Assef et al. (2011) calibration.
  logBHMS_mgII   		real NOT NULL,				--/D Black hole mass derived from the MgII line using the Shen & Liu (2012) calibration.
  errlogBHMS_mgII   	real NOT NULL,				--/D Uncertainty in the black hole mass derived from the MgII line using the Shen & Liu (2012) calibration.
  l_edd1         		float NOT NULL,				--/D Eddington luminosity based on the black hole mass estimate derived using the Shen & Liu (2012) calibration.
  errl_edd1         	float NOT NULL,				--/D Uncertainty in the Eddington luminosity based on the black hole mass estimate derived using the Shen & Liu (2012) calibration.
  l_edd2         		float NOT NULL,				--/D Eddington luminosity based on the black hole mass estimate derived using the Assef et al. (2011) calibration.
  errl_edd2         	float NOT NULL,				--/D Uncertainty in the Eddington luminosity based on the black hole mass estimate derived using the Assef et al. (2011) calibration.
  edd_ratio1    		real NOT NULL,				--/D Eddington ratio defined as l_bol1/l_edd1.
  erredd_ratio1    		real NOT NULL,				--/D Uncertainty in the Eddington ratio defined as l_bol1/l_edd1.
  edd_ratio2    		real NOT NULL,				--/D Eddington ratio defined as l_bol2/l_edd2.
  erredd_ratio2    		real NOT NULL,				--/D Uncertainty in the Eddington ratio defined as l_bol2/l_edd2.
  flag_abs    			smallint NOT NULL,				--/D Flag indicating whether or not strong absorption lines have been observed in the spectrum. flag_abs is set to either 0 (no absorption present) or 1 (absorption present).
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PawlikMorph')
	DROP TABLE PawlikMorph
GO
--
EXEC spSetDefaultFileGroup 'PawlikMorph'
GO


CREATE TABLE PawlikMorph (
----------------------------------------------------------------------------
--/H Morphological parameters for all galaxies in MaNGA DR15
----------------------------------------------------------------------------
--/T This table provides the CAS, gini, M20, shape asymmetry, curve of growth
--/T radii, sersic fits and associated parameters measured from SDSS DR7
--/T imaging using the 8-connected structure detection algorithm to define the
--/T edges of the galaxies presented in Pawlik et al. (2016, MNRAS, 456, 3032)
--/T for all galaxies in MaNGA DR15. This is the original implementation of
--/T the Shape Asymmetry algorithm. 
----------------------------------------------------------------------------
mangaID       varchar(16)  NOT NULL, --/U			--/D MaNGA ID string	
plateifu      varchar(32)  NOT NULL, --/U			--/D String combination of PLATE-IFU to ease searching
run	      smallint NOT NULL, --/U			--/D Run number
rerun	      smallint NOT NULL, --/U			--/D Rerun number
camcol	      tinyint  NOT NULL, --/U			--/D Camera column
field	      smallint NOT NULL, --/U			--/D Field number
imgsize       smallint NOT NULL, --/U pixels		--/D image size
imgmin	      real     NOT NULL, --/U counts		--/D minimum pixel value in the image
imgmax 	      real     NOT NULL, --/U counts    	--/D maximum pixel value in the image
skybgr	      real     NOT NULL, --/U counts/pixel 	--/D sky background estimate 
skybgrerr     real     NOT NULL, --/U counts/pixel 	--/D standard deviation in the sky background
skybgrflag    smallint  NOT NULL, --/U 			--/D flag indicating unreliable measurement of the sky background (0 if everything is OK)
bpixx	      smallint NOT NULL, --/U pixels		--/D  x position of the brightest pixel
bpixy	      smallint NOT NULL, --/U pixels		--/D  y position of the brightest pixel
apixx	      smallint NOT NULL, --/U pixels		--/D  x position yielding minimum value of the rotational light-weighted asymmetry parameter
apixy	      smallint NOT NULL, --/U pixels		--/D  y position yielding minimum value of the rotational light-weighted asymmetry parameter
mpixx	      smallint NOT NULL, --/U pixels		--/D  x position yielding minimum value of the second order moment of light
mpixy	      smallint NOT NULL, --/U pixels		--/D  y position yielding minimum value of the second order moment of light
rmax	      real     NOT NULL, --/U pixels		--/D  the `maximum’ radius of the galaxy, defined as the distance between the furthest pixel in the object’s pixel map, with respect to the central brightest pixel
r20 	      real     NOT NULL, --/U pixels		--/D  curve of growth radii defining a circular aperture that contains 20% of the total flux
r50 	      real     NOT NULL, --/U pixels		--/D  curve of growth radii defining a circular aperture that contains 50% of the total flux
r80 	      real     NOT NULL, --/U pixels		--/D  curve of growth radii defining a circular aperture that contains 80% of the total flux
r90 	      real     NOT NULL, --/U pixels		--/D  curve of growth radii defining a circular aperture that contains 90% of the total flux
C2080 	      real     NOT NULL, --/U 			--/D  the concentration index defined by the logarithmic ratio of  r20 and r80
C5090 	      real     NOT NULL, --/U 			--/D  the concentration index defined by the logarithmic ratio of  r50 and r90
A 	      real     NOT NULL, --/U 			--/D  the asymmetry of light under image rotation about 180 degrees around [apixx,apixy] (background corrected)
Abgr 	      real     NOT NULL, --/U 			--/D  the `background’ asymmetry associated with A
[As]  	      real     NOT NULL, --/U 			--/D  the shape asymmetry under image rotation about 180 degrees around [apixx,apixy]
As90  	      real     NOT NULL, --/U 			--/D  the shape asymmetry under image rotation about 90 degrees around [apixx,apixy]
S 	      real     NOT NULL, --/U 			--/D  the `clumpiness’ of the light distribution (background corrected)
Sbgr 	      real     NOT NULL, --/U 			--/D  the `background’ clumpiness associated with S
G 	      real     NOT NULL, --/U 			--/D  the Gini index
M20 	      real     NOT NULL, --/U 			--/D  the second-order moment of the brightest 20% of the total light
mag 	      real     NOT NULL, --/U mag		--/D  total magnitude within the boundaries of the pixel map
magerr        real     NOT NULL, --/U mag		--/D  the error associated with mag
sb0 	      real     NOT NULL, --/U counts		--/D  Sersic model’s best-fit parameter: the central surface brightness
sb0err        real     NOT NULL, --/U counts		--/D  error associated with sb0
reff 	      real     NOT NULL, --/U pixels		--/D  Sersic model’s best-fit parameter: the effective radius
refferr       real     NOT NULL, --/U pixels		--/D  error associated with reff
n 	      real     NOT NULL, --/U 			--/D  Sersic model’s best-fit parameter: the Sersic index
nerr 	      real     NOT NULL, --/U 			--/D  error associated with n
warningflag   smallint  NOT NULL, --/U 			--/D  flag indicating unreliable measurement (0 if everything is OK)
)
GO




--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SDSS17Pipe3D_v3_1_1')
	DROP TABLE SDSS17Pipe3D_v3_1_1
GO
--
EXEC spSetDefaultFileGroup 'SDSS17Pipe3D_v3_1_1'
GO


CREATE TABLE SDSS17Pipe3D_v3_1_1 (
-----------------------------------------------------
--/H Data products of MaNGA cubes derived using Pipe3D.
--/T Contains all the information of each dataproduct.
-----------------------------------------------------
name varchar(50) NOT NULL, --/U -- --/D manga-plate-ifudsgn unique name
plate numeric(20) NOT NULL, --/U -- --/D plate ID of the MaNGA cube
ifudsgn varchar(50) NOT NULL, --/U -- --/D IFU bundle ID of the MaNGA cube
plateifu varchar(50) NOT NULL, --/U -- --/D code formed by the plate and ifu names
mangaid varchar(50) NOT NULL, --/U -- --/D MaNGA ID
objra float NOT NULL, --/U degree --/D RA of the object
objdec float NOT NULL, --/U degree --/D DEC of the object
log_SFR_Ha real NOT NULL, --/U log(Msun/yr) --/D Integrated star-formation rate derived from the integra
FoV real NOT NULL, --/U -- --/D Ratio between the diagonal radius of the cube and Re
Re_kpc real NOT NULL, --/U kpc --/D derived effective radius in kpc
e_log_Mass real NOT NULL, --/U log(Msun) --/D Error of the integrated stellar mass
e_log_SFR_Ha real NOT NULL, --/U log(Msun/yr) --/D Error of the Integrated star-formation rate derived f
log_Mass real NOT NULL, --/U log(Msun) --/D Integrated stellar mass in units of the solar mass in loga
log_SFR_ssp real NOT NULL, --/U log(Msun/yr) --/D Integrated SFR derived from the SSP analysis t<32Myr
log_NII_Ha_cen real NOT NULL, --/U -- --/D logarithm of the [NII]6583/Halpha line ratio in the central 2.5
e_log_NII_Ha_cen real NOT NULL, --/U -- --/D error in the logarithm of the [NII]6583/Halpha line ratio in
log_OIII_Hb_cen real NOT NULL, --/U -- --/D logarithm of the [OIII]5007/Hbeta line ratio in the central 2.
e_log_OIII_Hb_cen real NOT NULL, --/U -- --/D error in the logarithm of the [OIII]5007/Hbeta line ratio in
log_SII_Ha_cen real NOT NULL, --/U -- --/D logarithm of the [SII]6717+6731/Halpha line ratio in the centra
e_log_SII_Ha_cen real NOT NULL, --/U -- --/D error in the logarithm of the [SII]6717/Halpha line ratio in
log_OII_Hb_cen real NOT NULL, --/U -- --/D logarithm of the [OII]3727/Hbeta line ratio in the central 2.5a
e_log_OII_Hb_cen real NOT NULL, --/U -- --/D error in the logarithm of the [OII]3727/Hbeta line ratio in t
EW_Ha_cen real NOT NULL, --/U Angstrom --/D EW of Halpha in the central 2.5arcsec/aperture
e_EW_Ha_cen real NOT NULL, --/U Angstrom --/D error of the EW of Halpha in the central 2.5arcsec/aperture
ZH_LW_Re_fit real NOT NULL, --/U log(yr) --/D Luminosity weighted metallicity of the stellar population
e_ZH_LW_Re_fit real NOT NULL, --/U log(yr) --/D Error in the luminosity weighted metallicity of the stel
alpha_ZH_LW_Re_fit real NOT NULL, --/U -- --/D slope of the gradient of the LW log-metallicity of the stel
e_alpha_ZH_LW_Re_fit real NOT NULL, --/U -- --/D Error of the slope of the gradient of the LW log-metallic
ZH_MW_Re_fit real NOT NULL, --/U log(yr) --/D Mass weighted metallicity of the stellar population in log
e_ZH_MW_Re_fit real NOT NULL, --/U log(yr) --/D Error in the Mass weighted metallicity of the stellar po
alpha_ZH_MW_Re_fit real NOT NULL, --/U -- --/D slope of the gradient of the MW log-metallicity of the stel
e_alpha_ZH_MW_Re_fit real NOT NULL, --/U -- --/D Error of the slope of the gradient of the MW log-metallic
Age_LW_Re_fit real NOT NULL, --/U log(yr) --/D Luminosity weighted age of the stellar population in loga
e_Age_LW_Re_fit real NOT NULL, --/U log(yr) --/D Error in the luminosity weighted age of the stellar pop
alpha_Age_LW_Re_fit real NOT NULL, --/U -- --/D slope of the gradient of the LW log-age of the stellar pop
e_alpha_Age_LW_Re_fit real NOT NULL, --/U -- --/D Error of the slope of the gradient of the LW log-age of
Age_MW_Re_fit real NOT NULL, --/U log(yr) --/D Mass weighted age of the stellar population in logarithm
e_Age_MW_Re_fit real NOT NULL, --/U log(yr) --/D Error in the Mass weighted age of the stellar populatio
alpha_Age_MW_Re_fit real NOT NULL, --/U -- --/D slope of the gradient of the MW log-age of the stellar pop
e_alpha_Age_MW_Re_fit real NOT NULL, --/U -- --/D Error of the slope of the gradient of the MW log-age of
Re_arc real NOT NULL, --/U arcsec --/D derived effective radius in arcsec
DL real NOT NULL, --/U -- --/D adopted luminosity distance in Mpc
DA real NOT NULL, --/U -- --/D adopted angular-diameter distance in Mpc
PA real NOT NULL, --/U degrees --/D adopted position angle in degrees
ellip real NOT NULL, --/U -- --/D adopted elipticity
log_Mass_gas real NOT NULL, --/U log(Msun) --/D Integrated gas mass in units of the solar mass in logari
vel_sigma_Re real NOT NULL, --/U -- --/D Velocity/dispersion ratio for the stellar populations within 1.5
e_vel_sigma_Re real NOT NULL, --/U -- --/D error in the velocity/dispersion ratio for the stellar populat
log_SFR_SF real NOT NULL, --/U log(Msun/yr) --/D Integrated SFR using only the spaxels compatible with SF
log_SFR_D_C real NOT NULL, --/U log(Msun/yr) --/D Integrated SFR diffuse corrected
OH_O3N2_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator O3N2 at the central region
e_OH_O3N2_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator O3N2 at the central region
OH_N2_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator N2 at the central region
e_OH_N2_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator N2 at the central region
OH_ONS_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator ONS at the central region
e_OH_ONS_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator ONS at the central region
OH_R23_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator R23 at the central region
e_OH_R23_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator R23 at the central region
OH_pyqz_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator pyqz at the central region
e_OH_pyqz_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator pyqz at the central region
OH_t2_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator t2 at the central region
e_OH_t2_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator t2 at the central region
OH_M08_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator M08 at the central region
e_OH_M08_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator M08 at the central region
OH_T04_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator T04 at the central region
e_OH_T04_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator T04 at the central region
OH_dop_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator dop at the central region
e_OH_dop_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator dop at the central region
OH_O3N2_EPM09_cen real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator O3N2_EPM09 at the central region
e_OH_O3N2_EPM09_cen real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator O3N2_EPM09 at the central region
log_OI_Ha_cen real NOT NULL, --/U -- --/D logarithm of the [OI]6301/Ha within a central aperture of 2arcsec
e_log_OI_Ha_cen real NOT NULL, --/U -- --/D error in the logarithm of the [OI]6301/Hbeta within a central aperture of 2arcsec
Ha_Hb_cen real NOT NULL, --/U -- --/D Ratio between the flux of Halpha and Hbeta within a central aperture of 2arcsec
e_Ha_Hb_cen real NOT NULL, --/U -- --/D error of Ha_Hb_cen
log_NII_Ha_Re real NOT NULL, --/U -- --/D logarithm of the [NII]6583/Halpha line ratio at 1Re
e_log_NII_Ha_Re real NOT NULL, --/U -- --/D error in the logarithm of the [NII]6583/Halpha at 1Re
log_OIII_Hb_Re real NOT NULL, --/U -- --/D logarithm of the [OIII]5007/Hbeta line ratio at 1Re
e_log_OIII_Hb_Re real NOT NULL, --/U -- --/D error in the logarithm of the [OIII]5007/Hbeta at 1Re
log_SII_Ha_Re real NOT NULL, --/U -- --/D logarithm of the [SII]6717+6731/Halpha at 1Re
e_log_SII_Ha_Re real NOT NULL, --/U -- --/D error in the logarithm of the [SII]6717/Halpha at 1Re
log_OII_Hb_Re real NOT NULL, --/U -- --/D logarithm of the [OII]3727/Hbeta at 1Re
e_log_OII_Hb_Re real NOT NULL, --/U -- --/D error in the logarithm of the [OII]3727/Hbeta at 1Re
log_OI_Ha_Re real NOT NULL, --/U -- --/D logarithm of the [OI]6301/Ha at 1Re
e_log_OI_Ha_Re real NOT NULL, --/U -- --/D error in the logarithm of the [OI]6301/Hbeta at 1Re
EW_Ha_Re real NOT NULL, --/U Angstrom --/D EW of Halpha at 1Re
e_EW_Ha_Re real NOT NULL, --/U Angstrom --/D error of the EW of Halpha at 1Re
Ha_Hb_Re real NOT NULL, --/U -- --/D Ratio between the flux of Halpha and Hbeta within at 1Re
e_Ha_Hb_Re real NOT NULL, --/U -- --/D error of Ha_Hb_Re
log_NII_Ha_ALL real NOT NULL, --/U -- --/D logarithm of the [NII]6583/Halpha line ratio within the FoV
e_log_NII_Ha_ALL real NOT NULL, --/U -- --/D error in the logarithm of the [NII]6583/Halpha within the FoV
log_OIII_Hb_ALL real NOT NULL, --/U -- --/D logarithm of the [OIII]5007/Hbeta line ratio within the FoV
e_log_OIII_Hb_ALL real NOT NULL, --/U -- --/D error in the logarithm of the [OIII]5007/Hbeta within the FoV
log_SII_Ha_ALL real NOT NULL, --/U -- --/D logarithm of the [SII]6717+6731/Halpha within the FoV
e_log_SII_Ha_ALL real NOT NULL, --/U -- --/D error in the logarithm of the [SII]6717/Halpha within the FoV
log_OII_Hb_ALL real NOT NULL, --/U -- --/D logarithm of the [OII]3727/Hbeta within the FoV
e_log_OII_Hb_ALL real NOT NULL, --/U -- --/D error in the logarithm of the [OII]3727/Hbeta within the FoV
log_OI_Ha_ALL real NOT NULL, --/U -- --/D logarithm of the [OI]6301/Ha within the FoV
e_log_OI_Ha_ALL real NOT NULL, --/U -- --/D error in the logarithm of the [OI]6301/Hbeta within the FoV
EW_Ha_ALL real NOT NULL, --/U Angstrom --/D EW of Halpha within the FoV
e_EW_Ha_ALL real NOT NULL, --/U Angstrom --/D error of the EW of Halpha within the FoV
Ha_Hb_ALL real NOT NULL, --/U -- --/D Ratio between the flux of Halpha and Hbeta within the FoV
Sigma_Mass_cen real NOT NULL, --/U log(Msun/pc^2) --/D Stellar Mass surface density in the central 2arcsec
e_Sigma_Mass_cen real NOT NULL, --/U log(Msun/pc^2) --/D error in Stellar Mass density in the central 2arcsec
Sigma_Mass_Re real NOT NULL, --/U log(Msun/pc^2) --/D Stellar Mass surface density at 1Re
e_Sigma_Mass_Re real NOT NULL, --/U log(Msun/pc^2) --/D error in Stellar Mass density at 1Re
Sigma_Mass_ALL real NOT NULL, --/U log(Msun/pc^2) --/D Average Stellar Mass surface density within the FoV
e_Sigma_Mass_ALL real NOT NULL, --/U log(Msun/pc^2) --/D error in the Average Stellar Mass surface density within the FoV
T30 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 30% of its mass
ZH_T30 real NOT NULL, --/U dex --/D Stellar metallicity at T30   time
ZH_Re_T30 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T30   time
a_ZH_T30 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T30   time
T40 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 40% of its mass
ZH_T40 real NOT NULL, --/U dex --/D Stellar metallicity at T40   time
ZH_Re_T40 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T40   time
a_ZH_T40 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T40   time
T50 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 50% of its mass
ZH_T50 real NOT NULL, --/U dex --/D Stellar metallicity at T50   time
ZH_Re_T50 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T50   time
a_ZH_T50 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T50   time
T60 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 60% of its mass
ZH_T60 real NOT NULL, --/U dex --/D Stellar metallicity at T60   time
ZH_Re_T60 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T60   time
a_ZH_T60 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T60   time
T70 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 70% of its mass
ZH_T70 real NOT NULL, --/U dex --/D Stellar metallicity at T70   time
ZH_Re_T70 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T70   time
a_ZH_T70 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T70   time
T80 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 80% of its mass
ZH_T80 real NOT NULL, --/U dex --/D Stellar metallicity at T80   time
ZH_Re_T80 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T80   time
a_ZH_T80 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T80   time
T90 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 90% of its mass
ZH_T90 real NOT NULL, --/U dex --/D Stellar metallicity at T90   time
ZH_Re_T90 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T90   time
a_ZH_T90 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T90   time
T95 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 95% of its mass
ZH_T95 real NOT NULL, --/U dex --/D Stellar metallicity at T95   time
ZH_Re_T95 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T95   time
a_ZH_T95 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T95   time
T99 real NOT NULL, --/U Gyr --/D Look Back time at which the galaxy has formed 99% of its mass
ZH_T99 real NOT NULL, --/U dex --/D Stellar metallicity at T99   time
ZH_Re_T99 real NOT NULL, --/U dex --/D Stellar metallicity at Re at T99   time
a_ZH_T99 real NOT NULL, --/U dex --/D slope of the ZH gradient at time T99   time
log_Mass_gas_Av_gas_OH real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator log_Mass_gas_Av_gas_OH at the central region
log_Mass_gas_Av_ssp_OH real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator log_Mass_gas_Av_ssp_OH at the central region
vel_ssp_2 real NOT NULL, --/U km/s --/D stellar velocity at 2Re
e_vel_ssp_2 real NOT NULL, --/U km/s --/D error in vel_ssp_2
vel_Ha_2 real NOT NULL, --/U km/s --/D Ha velocity at 2Re
e_vel_Ha_2 real NOT NULL, --/U km/s --/D error in vel_Ha_2
vel_ssp_1 real NOT NULL, --/U km/s --/D stellar velocity at 1Re
e_vel_ssp_1 real NOT NULL, --/U km/s --/D error of vel_ssp_1
vel_Ha_1 real NOT NULL, --/U km/s --/D Ha velocity at 1Re
e_vel_Ha_1 real NOT NULL, --/U km/s --/D error of e_vel_Ha_1
log_SFR_ssp_100Myr real NOT NULL, --/U log(Msun/yr) --/D Integrated SFR derived from the SSP analysis t<100Myr
log_SFR_ssp_10Myr real NOT NULL, --/U log(Msun/yr) --/D Integrated SFR derived from the SSP analysis t<10Myr
vel_disp_Ha_cen real NOT NULL, --/U km/s --/D Ha velocity dispersion at the central regions
vel_disp_ssp_cen real NOT NULL, --/U km/s --/D Stellar velocity dispersion at the central regions
vel_disp_Ha_1Re real NOT NULL, --/U km/s --/D Ha velocity dispersion at 1 Re
vel_disp_ssp_1Re real NOT NULL, --/U km/s --/D Stellar velocity at 1 Re
log_Mass_in_Re real NOT NULL, --/U log(Msun) --/D Integrated stellar mass within one optical Re
ML_int real NOT NULL, --/U -- --/D V-band mass-to-light ratio from integrated quantities
ML_avg real NOT NULL, --/U -- --/D V-band mass-to-light ratio average across the FoV
F_Ha_cen real NOT NULL, --/U 10^-16 erg/cm/s --/D Flux intensity of Halpha in the central 2.5arcsec/aperture
e_F_Ha_cen real NOT NULL, --/U 10^-16 erg/cm/s --/D error of F_Ha_cen
R50_kpc_V real NOT NULL, --/U kpc --/D R50 in the V-band within the FoV of the cube
e_R50_kpc_V real NOT NULL, --/U kpc --/D error of R50_kpc_V
R50_kpc_Mass real NOT NULL, --/U kpc --/D R50 in Mass within the FoV of the cube
e_R50_kpc_Mass real NOT NULL, --/U kpc --/D error of R50_kpc_Mass
log_Mass_corr_in_R50_V real NOT NULL, --/U log(Msun) --/D Integrated stellar mass within one R50 in the V-band
e_log_Mass_corr_in_R50_V real NOT NULL, --/U log(Msun) --/D error of log_Mass_corr_in_R50_V
log_Mass_gas_Av_gas_log_log real NOT NULL, --/U -- --/D --
Av_gas_Re real NOT NULL, --/U mag --/D Dust attenuation in the V-band derived from the Ha/Hb line ratios
e_Av_gas_Re real NOT NULL, --/U mag --/D Error of the dust attenuation in the V-band derived from the Ha
Av_ssp_Re real NOT NULL, --/U mag --/D Dust attenuation in the V-band derived from the analysis of the s
e_Av_ssp_Re real NOT NULL, --/U mag --/D Error of the dust attenuation in the V-band derived from the an
Lambda_Re real NOT NULL, --/U -- --/D Specific angular momentum (lambda parameter) for the stellar popula
e_Lambda_Re real NOT NULL, --/U -- --/D error in the specific angular momentum (lambda parameter) for the
nsa_redshift real NOT NULL, --/U -- --/D --
nsa_mstar real NOT NULL, --/U -- --/D --
nsa_inclination real NOT NULL, --/U -- --/D --
flux_OII3726_03_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OII]3726.03 at 1Re --/F flux_[OII]3726.03_Re_fit 
e_flux_OII3726_03_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OII]3726.03 at 1Re --/F e_flux_[OII]3726.03_Re_fit 
flux_OII3726_03_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OII]3726.03 at 1Re --/F flux_[OII]3726.03_alpha_fit 
e_flux_OII3726_03_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OII]3726.03 at 1Re --/F e_flux_[OII]3726.03_alpha_fit 
flux_OII3728_82_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OII]3728.82 at 1Re --/F flux_[OII]3728.82_Re_fit 
e_flux_OII3728_82_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OII]3728.82 at 1Re --/F e_flux_[OII]3728.82_Re_fit 
flux_OII3728_82_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OII]3728.82 at 1Re --/F flux_[OII]3728.82_alpha_fit 
e_flux_OII3728_82_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OII]3728.82 at 1Re --/F e_flux_[OII]3728.82_alpha_fit 
flux_HI3734_37_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HI3734.37 at 1Re --/F flux_HI3734.37_Re_fit 
e_flux_HI3734_37_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HI3734.37 at 1Re --/F e_flux_HI3734.37_Re_fit 
flux_HI3734_37_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HI3734.37 at 1Re --/F flux_HI3734.37_alpha_fit 
e_flux_HI3734_37_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HI3734.37 at 1Re --/F e_flux_HI3734.37_alpha_fit 
flux_HI3797_9_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HI3797.9 at 1Re --/F flux_HI3797.9_Re_fit 
e_flux_HI3797_9_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HI3797.9 at 1Re --/F e_flux_HI3797.9_Re_fit 
flux_HI3797_9_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HI3797.9 at 1Re --/F flux_HI3797.9_alpha_fit 
e_flux_HI3797_9_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HI3797.9 at 1Re --/F e_flux_HI3797.9_alpha_fit 
flux_HeI3888_65_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HeI3888.65 at 1Re --/F flux_HeI3888.65_Re_fit 
e_flux_HeI3888_65_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HeI3888.65 at 1Re --/F e_flux_HeI3888.65_Re_fit 
flux_HeI3888_65_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HeI3888.65 at 1Re --/F flux_HeI3888.65_alpha_fit 
e_flux_HeI3888_65_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HeI3888.65 at 1Re --/F e_flux_HeI3888.65_alpha_fit 
flux_HI3889_05_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HI3889.05 at 1Re --/F flux_HI3889.05_Re_fit 
e_flux_HI3889_05_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HI3889.05 at 1Re --/F e_flux_HI3889.05_Re_fit 
flux_HI3889_05_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HI3889.05 at 1Re --/F flux_HI3889.05_alpha_fit 
e_flux_HI3889_05_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HI3889.05 at 1Re --/F e_flux_HI3889.05_alpha_fit 
flux_HeI3964_73_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HeI3964.73 at 1Re --/F flux_HeI3964.73_Re_fit 
e_flux_HeI3964_73_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HeI3964.73 at 1Re --/F e_flux_HeI3964.73_Re_fit 
flux_HeI3964_73_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HeI3964.73 at 1Re --/F flux_HeI3964.73_alpha_fit 
e_flux_HeI3964_73_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HeI3964.73 at 1Re --/F e_flux_HeI3964.73_alpha_fit 
flux_NeIII3967_46_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NeIII]3967.46 at 1Re --/F flux_[NeIII]3967.46_Re_fit 
e_flux_NeIII3967_46_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NeIII]3967.46 at 1Re --/F e_flux_[NeIII]3967.46_Re_fit 
flux_NeIII3967_46_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NeIII]3967.46 at 1Re --/F flux_[NeIII]3967.46_alpha_fit 
e_flux_NeIII3967_46_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NeIII]3967.46 at 1Re --/F e_flux_[NeIII]3967.46_alpha_fit 
flux_CaII3968_47_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line CaII3968.47 at 1Re --/F flux_CaII3968.47_Re_fit 
e_flux_CaII3968_47_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line CaII3968.47 at 1Re --/F e_flux_CaII3968.47_Re_fit 
flux_CaII3968_47_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line CaII3968.47 at 1Re --/F flux_CaII3968.47_alpha_fit 
e_flux_CaII3968_47_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line CaII3968.47 at 1Re --/F e_flux_CaII3968.47_alpha_fit 
flux_Hepsilon3970_07_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Hepsilon3970.07 at 1Re --/F flux_Hepsilon3970.07_Re_fit 
e_flux_Hepsilon3970_07_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Hepsilon3970.07 at 1Re --/F e_flux_Hepsilon3970.07_Re_fit 
flux_Hepsilon3970_07_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Hepsilon3970.07 at 1Re --/F flux_Hepsilon3970.07_alpha_fit 
e_flux_Hepsilon3970_07_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Hepsilon3970.07 at 1Re --/F e_flux_Hepsilon3970.07_alpha_fit 
flux_Hdelta4101_77_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Hdelta4101.77 at 1Re --/F flux_Hdelta4101.77_Re_fit 
e_flux_Hdelta4101_77_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Hdelta4101.77 at 1Re --/F e_flux_Hdelta4101.77_Re_fit 
flux_Hdelta4101_77_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Hdelta4101.77 at 1Re --/F flux_Hdelta4101.77_alpha_fit 
e_flux_Hdelta4101_77_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Hdelta4101.77 at 1Re --/F e_flux_Hdelta4101.77_alpha_fit 
flux_Hgamma4340_49_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Hgamma4340.49 at 1Re --/F flux_Hgamma4340.49_Re_fit 
e_flux_Hgamma4340_49_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Hgamma4340.49 at 1Re --/F e_flux_Hgamma4340.49_Re_fit 
flux_Hgamma4340_49_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Hgamma4340.49 at 1Re --/F flux_Hgamma4340.49_alpha_fit 
e_flux_Hgamma4340_49_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Hgamma4340.49 at 1Re --/F e_flux_Hgamma4340.49_alpha_fit 
flux_Hbeta4861_36_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Hbeta4861.36 at 1Re --/F flux_Hbeta4861.36_Re_fit 
e_flux_Hbeta4861_36_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Hbeta4861.36 at 1Re --/F e_flux_Hbeta4861.36_Re_fit 
flux_Hbeta4861_36_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Hbeta4861.36 at 1Re --/F flux_Hbeta4861.36_alpha_fit 
e_flux_Hbeta4861_36_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Hbeta4861.36 at 1Re --/F e_flux_Hbeta4861.36_alpha_fit 
flux_OIII4958_91_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OIII]4958.91 at 1Re --/F flux_[OIII]4958.91_Re_fit 
e_flux_OIII4958_91_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OIII]4958.91 at 1Re --/F e_flux_[OIII]4958.91_Re_fit 
flux_OIII4958_91_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OIII]4958.91 at 1Re --/F flux_[OIII]4958.91_alpha_fit 
e_flux_OIII4958_91_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OIII]4958.91 at 1Re --/F e_flux_[OIII]4958.91_alpha_fit 
flux_OIII5006_84_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OIII]5006.84 at 1Re --/F flux_[OIII]5006.84_Re_fit 
e_flux_OIII5006_84_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OIII]5006.84 at 1Re --/F e_flux_[OIII]5006.84_Re_fit 
flux_OIII5006_84_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OIII]5006.84 at 1Re --/F flux_[OIII]5006.84_alpha_fit 
e_flux_OIII5006_84_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OIII]5006.84 at 1Re --/F e_flux_[OIII]5006.84_alpha_fit 
flux_HeI5015_68_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HeI5015.68 at 1Re --/F flux_HeI5015.68_Re_fit 
e_flux_HeI5015_68_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HeI5015.68 at 1Re --/F e_flux_HeI5015.68_Re_fit 
flux_HeI5015_68_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HeI5015.68 at 1Re --/F flux_HeI5015.68_alpha_fit 
e_flux_HeI5015_68_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HeI5015.68 at 1Re --/F e_flux_HeI5015.68_alpha_fit 
flux_NI5197_9_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NI]5197.9 at 1Re --/F flux_[NI]5197.9_Re_fit 
e_flux_NI5197_9_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NI]5197.9 at 1Re --/F e_flux_[NI]5197.9_Re_fit 
flux_NI5197_9_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NI]5197.9 at 1Re --/F flux_[NI]5197.9_alpha_fit 
e_flux_NI5197_9_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NI]5197.9 at 1Re --/F e_flux_[NI]5197.9_alpha_fit 
flux_NI5200_26_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NI]5200.26 at 1Re --/F flux_[NI]5200.26_Re_fit 
e_flux_NI5200_26_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NI]5200.26 at 1Re --/F e_flux_[NI]5200.26_Re_fit 
flux_NI5200_26_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NI]5200.26 at 1Re --/F flux_[NI]5200.26_alpha_fit 
e_flux_NI5200_26_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NI]5200.26 at 1Re --/F e_flux_[NI]5200.26_alpha_fit 
flux_HeI5876_0_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HeI5876.0 at 1Re --/F flux_HeI5876.0_Re_fit 
e_flux_HeI5876_0_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HeI5876.0 at 1Re --/F e_flux_HeI5876.0_Re_fit 
flux_HeI5876_0_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HeI5876.0 at 1Re --/F flux_HeI5876.0_alpha_fit 
e_flux_HeI5876_0_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HeI5876.0 at 1Re --/F e_flux_HeI5876.0_alpha_fit 
flux_NaI5889_95_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line NaI5889.95 at 1Re --/F flux_NaI5889.95_Re_fit 
e_flux_NaI5889_95_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line NaI5889.95 at 1Re --/F e_flux_NaI5889.95_Re_fit 
flux_NaI5889_95_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line NaI5889.95 at 1Re --/F flux_NaI5889.95_alpha_fit 
e_flux_NaI5889_95_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line NaI5889.95 at 1Re --/F e_flux_NaI5889.95_alpha_fit 
flux_NaI5895_92_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line NaI5895.92 at 1Re --/F flux_NaI5895.92_Re_fit 
e_flux_NaI5895_92_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line NaI5895.92 at 1Re --/F e_flux_NaI5895.92_Re_fit 
flux_NaI5895_92_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line NaI5895.92 at 1Re --/F flux_NaI5895.92_alpha_fit 
e_flux_NaI5895_92_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line NaI5895.92 at 1Re --/F e_flux_NaI5895.92_alpha_fit 
flux_OI6300_3_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OI]6300.3 at 1Re --/F flux_[OI]6300.3_Re_fit 
e_flux_OI6300_3_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OI]6300.3 at 1Re --/F e_flux_[OI]6300.3_Re_fit 
flux_OI6300_3_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [OI]6300.3 at 1Re --/F flux_[OI]6300.3_alpha_fit 
e_flux_OI6300_3_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [OI]6300.3 at 1Re --/F e_flux_[OI]6300.3_alpha_fit 
flux_NII6548_05_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NII]6548.05 at 1Re --/F flux_[NII]6548.05_Re_fit 
e_flux_NII6548_05_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NII]6548.05 at 1Re --/F e_flux_[NII]6548.05_Re_fit 
flux_NII6548_05_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NII]6548.05 at 1Re --/F flux_[NII]6548.05_alpha_fit 
e_flux_NII6548_05_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NII]6548.05 at 1Re --/F e_flux_[NII]6548.05_alpha_fit 
flux_Halpha6562_85_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Halpha6562.85 at 1Re --/F flux_Halpha6562.85_Re_fit 
e_flux_Halpha6562_85_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Halpha6562.85 at 1Re --/F e_flux_Halpha6562.85_Re_fit 
flux_Halpha6562_85_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line Halpha6562.85 at 1Re --/F flux_Halpha6562.85_alpha_fit 
e_flux_Halpha6562_85_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line Halpha6562.85 at 1Re --/F e_flux_Halpha6562.85_alpha_fit 
flux_NII6583_45_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NII]6583.45 at 1Re --/F flux_[NII]6583.45_Re_fit 
e_flux_NII6583_45_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NII]6583.45 at 1Re --/F e_flux_[NII]6583.45_Re_fit 
flux_NII6583_45_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [NII]6583.45 at 1Re --/F flux_[NII]6583.45_alpha_fit 
e_flux_NII6583_45_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [NII]6583.45 at 1Re --/F e_flux_[NII]6583.45_alpha_fit 
flux_SII6716_44_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [SII]6716.44 at 1Re --/F flux_[SII]6716.44_Re_fit 
e_flux_SII6716_44_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [SII]6716.44 at 1Re --/F e_flux_[SII]6716.44_Re_fit 
flux_SII6716_44_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [SII]6716.44 at 1Re --/F flux_[SII]6716.44_alpha_fit 
e_flux_SII6716_44_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [SII]6716.44 at 1Re --/F e_flux_[SII]6716.44_alpha_fit 
flux_SII6730_82_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [SII]6730.82 at 1Re --/F flux_[SII]6730.82_Re_fit 
e_flux_SII6730_82_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [SII]6730.82 at 1Re --/F e_flux_[SII]6730.82_Re_fit 
flux_SII6730_82_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [SII]6730.82 at 1Re --/F flux_[SII]6730.82_alpha_fit 
e_flux_SII6730_82_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [SII]6730.82 at 1Re --/F e_flux_[SII]6730.82_alpha_fit 
flux_ArIII7135_8_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [ArIII]7135.8 at 1Re --/F flux_[ArIII]7135.8_Re_fit 
e_flux_ArIII7135_8_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [ArIII]7135.8 at 1Re --/F e_flux_[ArIII]7135.8_Re_fit 
flux_ArIII7135_8_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [ArIII]7135.8 at 1Re --/F flux_[ArIII]7135.8_alpha_fit 
e_flux_ArIII7135_8_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [ArIII]7135.8 at 1Re --/F e_flux_[ArIII]7135.8_alpha_fit 
flux_HI9014_91_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HI9014.91 at 1Re --/F flux_HI9014.91_Re_fit 
e_flux_HI9014_91_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HI9014.91 at 1Re --/F e_flux_HI9014.91_Re_fit 
flux_HI9014_91_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line HI9014.91 at 1Re --/F flux_HI9014.91_alpha_fit 
e_flux_HI9014_91_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line HI9014.91 at 1Re --/F e_flux_HI9014.91_alpha_fit 
flux_SIII9069_0_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [SIII]9069.0 at 1Re --/F flux_[SIII]9069.0_Re_fit 
e_flux_SIII9069_0_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [SIII]9069.0 at 1Re --/F e_flux_[SIII]9069.0_Re_fit 
flux_SIII9069_0_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [SIII]9069.0 at 1Re --/F flux_[SIII]9069.0_alpha_fit 
e_flux_SIII9069_0_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [SIII]9069.0 at 1Re --/F e_flux_[SIII]9069.0_alpha_fit 
flux_FeII9470_93_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [FeII]9470.93 at 1Re --/F flux_[FeII]9470.93_Re_fit 
e_flux_FeII9470_93_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [FeII]9470.93 at 1Re --/F e_flux_[FeII]9470.93_Re_fit 
flux_FeII9470_93_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [FeII]9470.93 at 1Re --/F flux_[FeII]9470.93_alpha_fit 
e_flux_FeII9470_93_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [FeII]9470.93 at 1Re --/F e_flux_[FeII]9470.93_alpha_fit 
flux_SIII9531_1_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [SIII]9531.1 at 1Re --/F flux_[SIII]9531.1_Re_fit 
e_flux_SIII9531_1_Re_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [SIII]9531.1 at 1Re --/F e_flux_[SIII]9531.1_Re_fit 
flux_SIII9531_1_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Flux intensity of line [SIII]9531.1 at 1Re --/F flux_[SIII]9531.1_alpha_fit 
e_flux_SIII9531_1_alpha_fit real NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Error in the flux intensity of line [SIII]9531.1 at 1Re --/F e_flux_[SIII]9531.1_alpha_fit 
OH_Mar13_N2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Mar13_N2 at 1Re
e_OH_Mar13_N2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Mar13_N2 at 1Re
OH_Mar13_N2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Mar13_N2
e_OH_Mar13_N2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Mar13_N2
OH_Mar13_O3N2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Mar13_O3N2 at 1Re
e_OH_Mar13_O3N2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Mar13_O3N2 at 1Re
OH_Mar13_O3N2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Mar13_O3N2
e_OH_Mar13_O3N2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Mar13_O3N2
OH_T04_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator T04 at 1Re
e_OH_T04_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator T04 at 1Re
OH_T04_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator T04
e_OH_T04_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator T04
OH_Pet04_N2_lin_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Pet04_N2_lin at 1Re
e_OH_Pet04_N2_lin_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Pet04_N2_lin at 1Re
OH_Pet04_N2_lin_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Pet04_N2_lin
e_OH_Pet04_N2_lin_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Pet04_N2_lin
OH_Pet04_N2_poly_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Pet04_N2_poly at 1Re
e_OH_Pet04_N2_poly_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Pet04_N2_poly at 1Re
OH_Pet04_N2_poly_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Pet04_N2_poly
e_OH_Pet04_N2_poly_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Pet04_N2_poly
OH_Pet04_O3N2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Pet04_O3N2 at 1Re
e_OH_Pet04_O3N2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Pet04_O3N2 at 1Re
OH_Pet04_O3N2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Pet04_O3N2
e_OH_Pet04_O3N2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Pet04_O3N2
OH_Kew02_N2O2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Kew02_N2O2 at 1Re
e_OH_Kew02_N2O2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Kew02_N2O2 at 1Re
OH_Kew02_N2O2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Kew02_N2O2
e_OH_Kew02_N2O2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Kew02_N2O2
OH_Pil10_ONS_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Pil10_ONS at 1Re
e_OH_Pil10_ONS_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Pil10_ONS at 1Re
OH_Pil10_ONS_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Pil10_ONS
e_OH_Pil10_ONS_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Pil10_ONS
OH_Pil10_ON_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Pil10_ON at 1Re
e_OH_Pil10_ON_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Pil10_ON at 1Re
OH_Pil10_ON_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Pil10_ON
e_OH_Pil10_ON_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Pil10_ON
OH_Pil11_NS_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Pil11_NS at 1Re
e_OH_Pil11_NS_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Pil11_NS at 1Re
OH_Pil11_NS_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Pil11_NS
e_OH_Pil11_NS_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Pil11_NS
OH_Cur20_RS32_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_RS32 at 1Re
e_OH_Cur20_RS32_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_RS32 at 1Re
OH_Cur20_RS32_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_RS32
e_OH_Cur20_RS32_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_RS32
OH_Cur20_R3_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_R3 at 1Re
e_OH_Cur20_R3_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_R3 at 1Re
OH_Cur20_R3_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_R3
e_OH_Cur20_R3_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_R3
OH_Cur20_O3O2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_O3O2 at 1Re
e_OH_Cur20_O3O2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_O3O2 at 1Re
OH_Cur20_O3O2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_O3O2
e_OH_Cur20_O3O2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_O3O2
OH_Cur20_S2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_S2 at 1Re
e_OH_Cur20_S2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_S2 at 1Re
OH_Cur20_S2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_S2
e_OH_Cur20_S2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_S2
OH_Cur20_R2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_R2 at 1Re
e_OH_Cur20_R2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_R2 at 1Re
OH_Cur20_R2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_R2
e_OH_Cur20_R2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_R2
OH_Cur20_N2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_N2 at 1Re
e_OH_Cur20_N2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_N2 at 1Re
OH_Cur20_N2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_N2
e_OH_Cur20_N2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_N2
OH_Cur20_R23_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_R23 at 1Re
e_OH_Cur20_R23_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_R23 at 1Re
OH_Cur20_R23_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_R23
e_OH_Cur20_R23_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_R23
OH_Cur20_O3N2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_O3N2 at 1Re
e_OH_Cur20_O3N2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_O3N2 at 1Re
OH_Cur20_O3N2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_O3N2
e_OH_Cur20_O3N2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_O3N2
OH_Cur20_O3S2_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Cur20_O3S2 at 1Re
e_OH_Cur20_O3S2_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Cur20_O3S2 at 1Re
OH_Cur20_O3S2_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Cur20_O3S2
e_OH_Cur20_O3S2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Cur20_O3S2
OH_KK04_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator KK04 at 1Re
e_OH_KK04_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator KK04 at 1Re
OH_KK04_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator KK04
e_OH_KK04_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator KK04
OH_Pil16_R_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Pil16_R at 1Re
e_OH_Pil16_R_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Pil16_R at 1Re
OH_Pil16_R_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Pil16_R
e_OH_Pil16_R_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Pil16_R
OH_Pil16_S_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Pil16_S at 1Re
e_OH_Pil16_S_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Pil16_S at 1Re
OH_Pil16_S_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Pil16_S
e_OH_Pil16_S_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Pil16_S
OH_Ho_Re_fit real NOT NULL, --/U dex --/D Oxygen abundance using the calibrator Ho at 1Re
e_OH_Ho_Re_fit real NOT NULL, --/U dex --/D Error in Oxygen abundance using the calibrator Ho at 1Re
OH_Ho_alpha_fit real NOT NULL, --/U dex --/D Slope of the O/H gradient using the calibrator Ho
e_OH_Ho_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the O/H gradient using the calibrator Ho
U_Dors_O32_Re_fit real NOT NULL, --/U dex --/D log(U)
e_U_Dors_O32_Re_fit real NOT NULL, --/U dex --/D Error in log(U) using the calibrator Dors_O32 at 1Re
U_Dors_O32_alpha_fit real NOT NULL, --/U dex --/D Slope of the log(U) gradient using the calibrator Dors_O32
e_U_Dors_O32_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the log(U) gradient using the calibrator Dors_O32
U_Dors_S_Re_fit real NOT NULL, --/U dex --/D log(U)
e_U_Dors_S_Re_fit real NOT NULL, --/U dex --/D Error in log(U) using the calibrator Dors_S at 1Re
U_Dors_S_alpha_fit real NOT NULL, --/U dex --/D Slope of the log(U) gradient using the calibrator Dors_S
e_U_Dors_S_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the log(U) gradient using the calibrator Dors_S
U_Mor16_O23_fs_Re_fit real NOT NULL, --/U dex --/D log(U)
e_U_Mor16_O23_fs_Re_fit real NOT NULL, --/U dex --/D Error in log(U) using the calibrator Mor16_O23_fs at 1Re
U_Mor16_O23_fs_alpha_fit real NOT NULL, --/U dex --/D Slope of the log(U) gradient using the calibrator Mor16_O23_fs
e_U_Mor16_O23_fs_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the log(U) gradient using the calibrator Mor16_O23_fs
U_Mor16_O23_ts_Re_fit real NOT NULL, --/U dex --/D log(U)
e_U_Mor16_O23_ts_Re_fit real NOT NULL, --/U dex --/D Error in log(U) using the calibrator Mor16_O23_ts at 1Re
U_Mor16_O23_ts_alpha_fit real NOT NULL, --/U dex --/D Slope of the log(U) gradient using the calibrator Mor16_O23_ts
e_U_Mor16_O23_ts_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the log(U) gradient using the calibrator Mor16_O23_ts
NH_Pil16_R_Re_fit real NOT NULL, --/U dex --/D Nitrogen abundance using the calibrator Pil16_R at 1Re
e_NH_Pil16_R_Re_fit real NOT NULL, --/U dex --/D Error in Nitrogen abundance using the calibrator Pil16_R at 1Re
NH_Pil16_R_alpha_fit real NOT NULL, --/U dex --/D Slope of the N/H gradient using the calibrator Pil16_R
e_NH_Pil16_R_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the N/H gradient using the calibrator Pil16_R
NO_Pil16_R_Re_fit real NOT NULL, --/U dex --/D N/O abundance using the calibrator Pil16_R at 1Re
e_NO_Pil16_R_Re_fit real NOT NULL, --/U dex --/D Error in N/O abundance using the calibrator Pil16_R at 1Re
NO_Pil16_R_alpha_fit real NOT NULL, --/U dex --/D Slope of the N/O gradient using the calibrator Pil16_R
e_NO_Pil16_R_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the N/O gradient using the calibrator Pil16_R
NO_Pil16_Ho_R_Re_fit real NOT NULL, --/U dex --/D N/O abundance using the calibrator Pil16_Ho_R at 1Re
e_NO_Pil16_Ho_R_Re_fit real NOT NULL, --/U dex --/D Error in N/O abundance using the calibrator Pil16_Ho_R at 1Re
NO_Pil16_Ho_R_alpha_fit real NOT NULL, --/U dex --/D Slope of the N/O gradient using the calibrator Pil16_Ho_R
e_NO_Pil16_Ho_R_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the N/O gradient using the calibrator Pil16_Ho_R
NO_Pil16_N2_R2_Re_fit real NOT NULL, --/U dex --/D N/O abundance using the calibrator Pil16_N2_R2 at 1Re
e_NO_Pil16_N2_R2_Re_fit real NOT NULL, --/U dex --/D Error in N/O abundance using the calibrator Pil16_N2_R2 at 1Re
NO_Pil16_N2_R2_alpha_fit real NOT NULL, --/U dex --/D Slope of the N/O gradient using the calibrator Pil16_N2_R2
e_NO_Pil16_N2_R2_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of the N/O gradient using the calibrator Pil16_N2_R2
Ne_Oster_S_Re_fit real NOT NULL, --/U dex --/D n_e
e_Ne_Oster_S_Re_fit real NOT NULL, --/U dex --/D Error in n_e using the Oster_S estimator at 1Re
Ne_Oster_S_alpha_fit real NOT NULL, --/U dex --/D Slope of the n_e gradient using the Oster_S estimator
e_Ne_Oster_S_alpha_fit real NOT NULL, --/U dex --/D Error in the slope of n_e gradient using the Oster_S estimator
Hd_Re_fit real NOT NULL, --/U Angstrom --/D Value of the Hd stellar index at 1Re
e_Hd_Re_fit real NOT NULL, --/U Angstrom --/D Error of the Hd stellar index at 1Re
Hd_alpha_fit real NOT NULL, --/U -- --/D Slope of the gradient of the Hd index
e_Hd_alpha_fit real NOT NULL, --/U -- --/D Error in the slope of the gradient of the Hd index
Hb_Re_fit real NOT NULL, --/U Angstrom --/D Value of the Hb stellar index at 1Re
e_Hb_Re_fit real NOT NULL, --/U Angstrom --/D Error of the Hb stellar index at 1Re
Hb_alpha_fit real NOT NULL, --/U -- --/D Slope of the gradient of the Hb index
e_Hb_alpha_fit real NOT NULL, --/U -- --/D Error in the slope of the gradient of the Hb index
Mgb_Re_fit real NOT NULL, --/U Angstrom --/D Value of the Mgb stellar index at 1Re
e_Mgb_Re_fit real NOT NULL, --/U Angstrom --/D Error of the Mgb stellar index at 1Re
Mgb_alpha_fit real NOT NULL, --/U -- --/D Slope of the gradient of the Mgb index
e_Mgb_alpha_fit real NOT NULL, --/U -- --/D Error in the slope of the gradient of the Mgb index
Fe5270_Re_fit real NOT NULL, --/U Angstrom --/D Value of the Fe5270 stellar index at 1Re
e_Fe5270_Re_fit real NOT NULL, --/U Angstrom --/D Error of the Fe5270 stellar index at 1Re
Fe5270_alpha_fit real NOT NULL, --/U -- --/D Slope of the gradient of the Fe5270 index
e_Fe5270_alpha_fit real NOT NULL, --/U -- --/D Error in the slope of the gradient of the Fe5270 index
Fe5335_Re_fit real NOT NULL, --/U Angstrom --/D Value of the Fe5335 stellar index at 1Re
e_Fe5335_Re_fit real NOT NULL, --/U Angstrom --/D Error of the Fe5335 stellar index at 1Re
Fe5335_alpha_fit real NOT NULL, --/U -- --/D Slope of the gradient of the Fe5335 index
e_Fe5335_alpha_fit real NOT NULL, --/U -- --/D Error in the slope of the gradient of the Fe5335 index
D4000_Re_fit1 real NOT NULL, --/U -- --/D Value of the D40001 stellar index at 1Re
e_D4000_Re_fit real NOT NULL, --/U -- --/D Error of the D4000 stellar index at 1Re
D4000_alpha_fit real NOT NULL, --/U -- --/D Slope of the gradient of the D4000 index
e_D4000_alpha_fit real NOT NULL, --/U -- --/D Error in the slope of the gradient of the D4000 index
Hdmod_Re_fit real NOT NULL, --/U Angstrom --/D Value of the Hdmod stellar index at 1Re
e_Hdmod_Re_fit real NOT NULL, --/U Angstrom --/D Error of the Hdmod stellar index at 1Re
Hdmod_alpha_fit real NOT NULL, --/U -- --/D Slope of the gradient of the Hdmod index
e_Hdmod_alpha_fit real NOT NULL, --/U -- --/D Error in the slope of the gradient of the Hdmod index
Hg_Re_fit real NOT NULL, --/U Angstrom --/D Value of the Hg stellar index at 1Re
e_Hg_Re_fit real NOT NULL, --/U Angstrom --/D Error of the Hg stellar index at 1Re
Hg_alpha_fit real NOT NULL, --/U -- --/D Slope of the gradient of the Hg index
e_Hg_alpha_fit real NOT NULL, --/U -- --/D Error in the slope of the gradient of the Hg index
u_band_mag real NOT NULL, --/U mag --/D u-band magnitude from the cube
u_band_mag_error real NOT NULL, --/U mag --/D error in  u-band magnitude from the cube
u_band_abs_mag real NOT NULL, --/U mag --/D u-band abs. magnitude from the cube
u_band_abs_mag_error real NOT NULL, --/U mag --/D error in u-band magnitude from the cube
g_band_mag real NOT NULL, --/U mag --/D g-band magnitude from the cube
g_band_mag_error real NOT NULL, --/U mag --/D error in g-band magnitude from the cube
g_band_abs_mag real NOT NULL, --/U mag --/D g-band abs. magnitude from the cube
g_band_abs_mag_error real NOT NULL, --/U mag --/D error in g-band abs. magnitude from the cube
r_band_mag real NOT NULL, --/U mag --/D r-band magnitude from the cube
r_band_mag_error real NOT NULL, --/U mag --/D error in r-band magnitude from the cube
r_band_abs_mag real NOT NULL, --/U mag --/D r-band abs. magnitude from the cube
r_band_abs_mag_error real NOT NULL, --/U mag --/D error in r-band magnitude from the cube
i_band_mag real NOT NULL, --/U mag --/D i-band magnitude from the cube
i_band_mag_error real NOT NULL, --/U mag --/D error in i-band magnitude from the cube
i_band_abs_mag real NOT NULL, --/U mag --/D i-band abs. magnitude from the cube
i_band_abs_mag_error real NOT NULL, --/U mag --/D error in i-band magnitude from the cube
B_band_mag real NOT NULL, --/U mag --/D B-band magnitude from the cube
B_band_mag_error real NOT NULL, --/U mag --/D error in B-band magnitude from the cube
B_band_abs_mag real NOT NULL, --/U mag --/D B-band abs. magnitude from the cube
B_band_abs_mag_error real NOT NULL, --/U mag --/D error in B-band magnitude from the cube
V_band_mag real NOT NULL, --/U mag --/D V-band magnitude from the cube
V_band_mag_error real NOT NULL, --/U mag --/D error in V-band magnitude from the cube
V_band_abs_mag real NOT NULL, --/U mag --/D V-band abs. magnitude from the cube
V_band_abs_mag_error real NOT NULL, --/U mag --/D error in V-band magnitude from the cube
RJ_band_mag real NOT NULL, --/U mag --/D R-band magnitude from the cube
RJ_band_mag_error real NOT NULL, --/U mag --/D error R-band magnitude from the cube
RJ_band_abs_mag real NOT NULL, --/U mag --/D R-band abs. magnitude from the cube
RJ_band_abs_mag_error real NOT NULL, --/U mag --/D error in R-band abs. magnitude from the cube
R50 real NOT NULL, --/U arcsec --/D g-band R50 derived from the cube
error_R50 real NOT NULL, --/U arcsec --/D error in g-band R50 derived from the cube
R90 real NOT NULL, --/U arcsec --/D g-band R90 derived from the cube
error_R90 real NOT NULL, --/U arcsec --/D error in g-band R90 derived from the cube
C real NOT NULL, --/U -- --/D R90/R50 Concentration index
e_C real NOT NULL, --/U -- --/D error in concentration index
B_V_color real NOT NULL, --/U mag --/D B-V color --/F B-V 
error_B_V_color real NOT NULL, --/U mag --/D error in the B-V color --/F error_B-V 
B_R_color real NOT NULL, --/U mag --/D B-R color --/F B-R 
error_B_R_color real NOT NULL, --/U mag --/D error in the B-R color --/F error_B-R 
log_Mass_phot real NOT NULL, --/U log(Msun) --/D stellar masses derived from photometric
e_log_Mass_phot real NOT NULL, --/U dex --/D error in the stellar masses derived from photometry
V_band_SB_at_Re real NOT NULL, --/U mag/arcsec^2 --/D V-band surface brightness at 1Re --/F V-band_SB_at_Re 
error_V_band_SB_at_Re real NOT NULL, --/U mag/arcsec^2 --/D error in the V-band SB at 1Re --/F error_V-band_SB_at_Re 
V_band_SB_at_R_50 real NOT NULL, --/U mag/arcsec^2 --/D V-band surface brightness at R50 --/F V-band_SB_at_R_50 
error_V_band_SB_at_R_50 real NOT NULL, --/U mag/arcsec^2 --/D error in V-band surface brightness at R50 --/F error_V-band_SB_at_R_50 
nsa_sersic_n_morph real NOT NULL, --/U -- --/D NSA sersic index
u_g_color real NOT NULL, --/U mag --/D u-g NSA color --/F u-g 
g_r_color real NOT NULL, --/U mag --/D g-r NSA color --/F g-r 
r_i_color real NOT NULL, --/U mag --/D r-i NSA color --/F r-i 
i_z_color real NOT NULL, --/U mag --/D i-z NSA color --/F i-z 
P_CD real NOT NULL, --/U -- --/D Probability of being a CD galaxy --/F P(CD) 
P_E real NOT NULL, --/U -- --/D Probability of being a E galaxy --/F P(E) 
P_S0 real NOT NULL, --/U -- --/D Probability of being a S0 galaxy --/F P(S0) 
P_Sa real NOT NULL, --/U -- --/D Probability of being a Sa galaxy --/F P(Sa) 
P_Sab real NOT NULL, --/U -- --/D Probability of being a Sab galaxy --/F P(Sab) 
P_Sb real NOT NULL, --/U -- --/D Probability of being a Sb galaxy --/F P(Sb) 
P_Sbc real NOT NULL, --/U -- --/D Probability of being a Sbc galaxy --/F P(Sbc) 
P_Sc real NOT NULL, --/U -- --/D Probability of being a Sc galaxy --/F P(Sc) 
P_Scd real NOT NULL, --/U -- --/D Probability of being a Scd galaxy --/F P(Scd) 
P_Sd real NOT NULL, --/U -- --/D Probability of being a Sd galaxy --/F P(Sd) 
P_Sdm real NOT NULL, --/U -- --/D Probability of being a Sdm galaxy --/F P(Sdm) 
P_Sm real NOT NULL, --/U -- --/D Probability of being a Sm galaxy --/F P(Sm) 
P_Irr real NOT NULL, --/U -- --/D Probability of being a Irr galaxy --/F P(Irr) 
best_type_n bigint NOT NULL, --/U -- --/D Best morphologica type index based on a NN analysis
best_type varchar(50) NOT NULL, --/U -- --/D Morphological Type derived by the NN analysis
nsa_nsaid bigint NOT NULL, --/U -- --/D NSA ID
Vmax_w real NOT NULL, --/U Mpc^-3 dex^-1 --/D Weight for the volume correction in volume
Num_w real NOT NULL, --/U -- --/D Weight of the volume correction in number
QCFLAG bigint NOT NULL, --/U -- --/D QC flat 0=good 2=bad >2 warning
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'apogee_starhorse')
	DROP TABLE apogee_starhorse
GO
--
EXEC spSetDefaultFileGroup 'apogee_starhorse'
GO


CREATE TABLE apogee_starhorse (
---------------------------------------------------------------------------------- 
--/H StarHorse distance, extinction and other astrophysical parameters for APOGEE
--/H DR17 + Gaia EDR3 
---------------------------------------------------------------------------------- 
--/T parameters computed with Bayesian code, using  stellar evolutionary models,
--/T Galactic priors and a set of spectroscopic/astrometric/photometric
--/T measurements For more information on StarHorse code see Queiroz et al 2010
--/T (https://arxiv.org/pdf/1710.09970.pdf)  
---------------------------------------------------------------------------------- 
    apogee_id varchar(32) NOT NULL, --/U  --/D TMASS-STYLE object name
    aspcap_id varchar(128) NOT NULL, --/U  --/D Unique ID for ASPCAP results of form apogee.[telescope].[cs].results_version.location_id.star (Primary key)
    apstar_id varchar(128) NOT NULL, --/U  --/D Unique ID for combined star spectrum of form apogee.[telescope].[cs].apstar_version.location_id.apogee_id (Primary key)
    edr3_source_id varchar(32) NOT NULL, --/U  --/D Gaia EDR3 Source ID
    glon float NOT NULL, --/U deg --/D Galactic Longitude
    glat float NOT NULL, --/U deg --/D Galactic Latitude  
    ra float NOT NULL, --/U deg --/D Right Ascention J200
    dec float NOT NULL, --/U deg --/D Declination J200
    mass16 real NOT NULL, --/U solar mass   --/D StarHorse 16th astro-spectro-photometric mass percentile (Queiroz et al. 2018)
    mass50 real NOT NULL, --/U  solar mass --/D StarHorse median astro-spectro-photometric mass (Queiroz et al. 2018)
    mass84 real NOT NULL, --/U solar mass  --/D  StarHorse 84th astro-spectro-photometric mass percentile (Queiroz et al. 2018)
    teff16 real NOT NULL, --/U K  --/D   StarHorse 16th astro-spectro-photometric effective temperature percentile (Queiroz et al. 2018)
    teff50 real NOT NULL, --/U K --/D   StarHorse median astro-spectro-photometric effective temperature (Queiroz et al. 2018)
    teff84 real NOT NULL, --/U K --/D  StarHorse 84th astro-spectro-photometric effective temperature percentile (Queiroz et al. 2018)
    logg16 real NOT NULL, --/U dex --/D StarHorse 16th astro-spectro-photometric surface gravity percentile (Queiroz et al. 2018)  
    logg50 real NOT NULL, --/U dex --/D   StarHorse median astro-spectro-photometric surface gravity (Queiroz et al. 2018)
    logg84 real NOT NULL, --/U dex --/D   StarHorse 84th astro-spectro-photometric surface gravity percentile (Queiroz et al. 2018) 
    met16 real NOT NULL, --/U dex --/D StarHorse 16th astro-spectro-photometric metallicity percentile (Queiroz et al. 2018)
    met50 real NOT NULL, --/U dex --/D StarHorse median astro-spectro-photometric metallicity (Queiroz et al. 2018)
    met84 real NOT NULL, --/U dex --/D StarHorse 84th astro-spectro-photometric metallicity percentile (Queiroz et al. 2018)
    dist05 real NOT NULL, --/U kpc --/D StarHorse 5th astro-spectro-photometric distance percentile (Queiroz et al. 2018)
    dist16 real NOT NULL, --/U kpc --/D   StarHorse 16th astro-spectro-photometric distance percentile (Queiroz et al. 2018) 
    dist50 real NOT NULL, --/U kpc --/D StarHorse median astro-spectro-photometric distance (Queiroz et al. 2018)
    dist84 real NOT NULL, --/U kpc --/D StarHorse 84th astro-spectro-photometric distance percentile (Queiroz et al. 2018)
    dist95 real NOT NULL, --/U kpc --/D StarHorse 95th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)
    av05 real NOT NULL, --/U mag --/D   StarHorse 5th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)
    av16 real NOT NULL, --/U mag --/D StarHorse 16th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)
    av50 real NOT NULL, --/U mag --/D StarHorse median posterior extinction (at 542 nm) (Queiroz et al. 2018)
    av84 real NOT NULL, --/U mag --/D StarHorse 84th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)   
    av95 real NOT NULL, --/U mag --/D   StarHorse 95th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)
    starhorse_inputflags varchar(80) NOT NULL, --/U  --/D StarHorse Input flags (Queiroz et al. 2018) 
    starhorse_outputflags varchar(80) NOT NULL, --/U  --/D StarHorse Output flags (Queiroz et al. 2018)
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'apogeeDistMass')
	DROP TABLE apogeeDistMass
GO
--
EXEC spSetDefaultFileGroup 'apogeeDistMass'
GO

CREATE TABLE apogeeDistMass (
    apogee_id varchar(19) NOT NULL, --/D 2MASS-style star identification  
    apstar_id varchar(59) NOT NULL, --/D Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid (Primary key)
    teff real NOT NULL,  --/U deg K --/D Empirically calibrated temperature from ASPCAP 
    logg real NOT NULL, --/U dex --/D empirically calibrated log gravity from ASPCAP
    m_h real NOT NULL, --/U dex --/D calibrated [M/H]
    c_fe real NOT NULL, --/U dex --/D empirically calibrated [C/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals 
    n_fe real NOT NULL, --/U dex --/D empirically calibrated [N/Fe] from ASPCAP; [N/Fe] is calculated as (ASPCAP [N/M])+param_metals 
    gaiaedr3_dist real NOT NULL, --/U pc --/D GAIA EDR3 Bailer Jones r_med_geo
    extinction real NOT NULL, --/U mag --/D Ks-band extinction based on WISE allWISE release photometry
    mag real NOT NULL, --/U mag --/D 2MASS Ks-band magnitude
    abs_mag real NOT NULL, --/U mag --/D derived absolute Ks-band magnitude
    abs_mag_err real NOT NULL, --/U mag --/D uncertainty derived absolute Ks-band magnitude
    distance real NOT NULL, --/U pc --/D derived distance
    distance_err real NOT NULL, --/U pc --/D uncertainty in derived distance
    mass real NOT NULL, --/U solar --/D derived mass
    mass_err real NOT NULL, --/U solar --/D uncertainty in erived mass
    train_mass real NOT NULL, --/U solar --/D mass used for training
    age real NOT NULL, --/U yr --/D derived age
    bitmask bigint NOT NULL, --/D Bitmask with information
    nmsu_dist_max real NOT NULL, --/U deg pc --/F nmsu_dist 0 --/D isochrone based distance, maximum of PDF
    nmsu_dist_med real NOT NULL, --/U deg pc --/F nmsu_dist 1 --/D isochrone based distance, median of PDF
    nmsu_dist_mean real NOT NULL, --/U deg pc --/F nmsu_dist 2 --/D isochrone based distance, mean of PDF
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'ebossMCPM')
	DROP TABLE ebossMCPM
GO
--
EXEC spSetDefaultFileGroup 'ebossMCPM'
GO

CREATE TABLE ebossMCPM (
---------------------------------------------------------------------------- 
--/H The catalog containing matter density estimates from the MCPM algorithm
--/H for the eBOSS catalog. 
---------------------------------------------------------------------------- 
--/T This catalogue contains estimates of the local matter density at the
--/T location of galaxies based on the Monte Carlo Physarum Machine (MCPM)
--/T algorithm, inspired by the growth and movement of Physarum polycephalum
--/T slime mold. We employ this algorithm to reconstruct the cosmic web and
--/T provide estimates for the matter density field at the locations of
--/T SDSS galaxies, both those from Classic SDSS and eBOSS LRG program.
---------------------------------------------------------------------------- 
    CATALOGID bigint NOT NULL, --/U  --/D Combination of PLATE-MJD-FIBERID
    PLATE int NOT NULL, --/U  --/D Plate number
    MJD int NOT NULL, --/U  --/D MJD of observation
    FIBERID int NOT NULL, --/U  --/D Fiber identification number
    RA float NOT NULL, --/U deg --/D Right ascension of fiber, J2000
    DEC float NOT NULL, --/U deg --/D Declination of fiber, J2000
    Z real NOT NULL, --/U  --/D Best redshift
    MSTARS real NOT NULL, --/U solMass --/D  Stellar mass
    MASS_SOURCE varchar(7) NOT NULL, --/U  --/D Source of the mass determination (nsa or firefly)  
    MATTERDENS real NOT NULL, --/U  --/D log10 of the ratio of the matter density relative to the mean matter density
    MCPM_RUN smallint NOT NULL, --/U --/D Index of galaxy sample fitted simultaneously with MCPM
)
GO
--



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaFirefly_miles')
	DROP TABLE mangaFirefly_miles
GO
--
EXEC spSetDefaultFileGroup 'mangaFirefly_miles'
GO

CREATE TABLE mangaFirefly_miles (
-------------------------------------------------------------------------------
--/H Contains the measured stellar population parameters for each MaNGA galaxy.
--
--/T This is a base table containing spectroscopic global galaxy
--/T information and the results of the FIREFLY full spectral fits on
--/T the MaNGA Voronoi binned spectra with S/N threshold of 10.
--/T The catalogue is offered in two versions:
--/T The first version has been computed using Maraston & Stromback (M11, 2011) models with 
--/T the MILES stellar library and a Kroupa stellar initial mass function.
--/T The second version has been computed using the models of Maraston (2020) based on the
--/T MaStar stellar library (Yan et al. 2019) and a Kroupa stellar initial mass function.
--/T This is the mangaFirefly catalogue using the m11-MILES models.
-------------------------------------------------------------------------------
  MANGAID                varchar(20) NOT NULL,     --/D Unique MaNGA identifier.
  PLATEIFU               varchar(20) NOT NULL,   --/D Unique identifier containing the MaNGA plate and ifu combination.
  PLATE                  int NOT NULL,     --/D Plate used to observe galaxy.
  IFUDSGN                varchar(20) NOT NULL,     --/D IFU used to observe galaxy.
  OBJRA                  float NOT NULL,     --/D Right ascension of the galaxy, not the IFU.
  OBJDEC                 float NOT NULL,     --/D Declination of the galaxy, not the IFU.
  REDSHIFT               real NOT NULL,     --/D Redshift of the galaxy.
  PHOTOMETRIC_MASS       real NOT NULL,     --/U log(M_sun) --/D Stellar mass of galaxy from NSA catalogue obtained from K-correction fits to elliptical Petrosian photometric fluxes.
  MANGADRP_VER           varchar(20) NOT NULL,     --/D Version of MaNGA DRP that produced this data.
  MANGADAP_VER           varchar(20) NOT NULL,     --/D Version of MaNGA DAP that analysed this data.
  FIREFLY_VER            varchar(20) NOT NULL,     --/D Version of FIREFLY that analysed this data.
  LW_AGE_1RE             real NOT NULL,       --/U log(Gyr) --/D Light-weighted age within a shell located at 1Re.
  LW_AGE_1RE_ERROR       real NOT NULL,       --/U log(Gyr) --/D Error on light-weighted age within a shell located at 1Re.
  MW_AGE_1RE             real NOT NULL,       --/U log(Gyr) --/D Mass-weighted age within a shell located at 1Re.
  MW_AGE_1RE_ERROR       real NOT NULL,       --/U log(Gyr) --/D Error on mass-weighted age within a shell located at 1Re.
  LW_Z_1RE               real NOT NULL,       --/D Light-weighted metallicity [Z/H] within a shell located at 1Re. 
  LW_Z_1RE_ERROR         real NOT NULL,       --/D Error on light-weighted metallicity [Z/H] within a shell located at 1Re. 
  MW_Z_1RE               real NOT NULL,       --/D Mass-weighted metallicity [Z/H] within a shell located at 1Re. 
  MW_Z_1RE_ERROR         real NOT NULL,       --/D Error on mass-weighted metallicity [Z/H] within a shell located at 1Re. 
  LW_AGE_3ARCSEC         real NOT NULL,       --/U log(Gyr) --/D Light-weighted age within 3arcsec diameter. 
  LW_AGE_3ARCSEC_ERROR   real NOT NULL,       --/U log(Gyr) --/D Error on light-weighted age within 3arcsec.
  MW_AGE_3ARCSEC         real NOT NULL,       --/U log(Gyr) --/D Mass-weighted age within 3arcsec diameter.
  MW_AGE_3ARCSEC_ERROR   real NOT NULL,       --/U log(Gyr) --/D Error on mass-weighted age within 3arcsec.
  LW_Z_3ARCSEC           real NOT NULL,       --/D Light-weighted metallicity [Z/H] within 3arcsec diameter. 
  LW_Z_3ARCSEC_ERROR     real NOT NULL,       --/D Error on light-weighted metallicity [Z/H] within 3arcsec. 
  MW_Z_3ARCSEC           real NOT NULL,       --/D Mass-weighted metallicity [Z/H] within 3arcsec diameter. 
  MW_Z_3ARCSEC_ERROR     real NOT NULL,       --/D Error on mass-weighted metallicity [Z/H] within 3arcsec.
  LW_AGE_GRADIENT         real NOT NULL,      --/U dex/Re --/D Light-weighted age gradient of linear fit obtained within 1.5Re.
  LW_AGE_GRADIENT_ERROR   real NOT NULL,      --/U dex/Re --/D Error on light-weighted age gradient within 1.5Re of galaxy.
  LW_AGE_ZEROPOINT        real NOT NULL,      --/D Light-weighted age zeropoint of linear fit obtained within 1.5Re.
  LW_AGE_ZEROPOINT_ERROR  real NOT NULL,      --/D Error on light-weighted age zeropoint obtained within 1.5Re.
  MW_AGE_GRADIENT         real NOT NULL,      --/U dex/Re --/D Mass-weighted age gradient of linear fit obtained within 1.5Re.
  MW_AGE_GRADIENT_ERROR   real NOT NULL,      --/U dex/Re --/D Error on mass-weighted age gradient within 1.5Re of galaxy.
  MW_AGE_ZEROPOINT        real NOT NULL,      --/D Mass-weighted age zeropoint of linear fit obtained within 1.5Re.
  MW_AGE_ZEROPOINT_ERROR  real NOT NULL,      --/D Error on mass-weighted age zeropoint obtained within 1.5Re.
  LW_Z_GRADIENT           real NOT NULL,      --/U dex/Re --/D Light-weighted metallicity [Z/H] gradient of linear fit obtained within 1.5Re.
  LW_Z_GRADIENT_ERROR     real NOT NULL,      --/U dex/Re --/D Error on light-weighted metallicity [Z/H] gradient within 1.5Re of galaxy.
  LW_Z_ZEROPOINT          real NOT NULL,      --/D Light-weighted metallicity [Z/H] zeropoint of linear fit obtained within 1.5Re.
  LW_Z_ZEROPOINT_ERROR    real NOT NULL,      --/D Error on light-weighted metallicity [Z/H] zeropoint obtained within 1.5Re.
  MW_Z_GRADIENT           real NOT NULL,      --/U dex/Re --/D Mass-weighted metallicity [Z/H] gradient of linear fit obtained within 1.5Re.
  MW_Z_GRADIENT_ERROR     real NOT NULL,      --/U dex/Re --/D Error on mass-weighted metallicity [Z/H] gradient within 1.5Re of galaxy.
  MW_Z_ZEROPOINT          real NOT NULL,      --/D Mass-weighted metallicity [Z/H] zeropoint of linear fit obtained within 1.5Re.
  MW_Z_ZEROPOINT_ERROR    real NOT NULL,      --/D Error on mass-weighted metallicity [Z/H] zeropoint obtained within 1.5Re.
)
GO
--



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaFirefly_mastar')
	DROP TABLE mangaFirefly_mastar
GO
--
EXEC spSetDefaultFileGroup 'mangaFirefly_mastar'
GO

CREATE TABLE mangaFirefly_mastar (
-------------------------------------------------------------------------------
--/H Contains the measured stellar population parameters for each MaNGA galaxy.
--
--/T This is a base table containing spectroscopic global galaxy
--/T information and the results of the FIREFLY full spectral fits on
--/T the MaNGA Voronoi binned spectra with S/N threshold of 10.
--/T The catalogue is offered in two versions:
--/T The first version has been computed using Maraston & Stromback (M11, 2011) models with 
--/T the MILES stellar library and a Kroupa stellar initial mass function.
--/T The second version has been computed using the models of Maraston (2020) based on the
--/T MaStar stellar library (Yan et al. 2019) and a Kroupa stellar initial mass function.
--/T This is the mangaFirefly catalogue using the MaStar models.
-------------------------------------------------------------------------------
  MANGAID                varchar(20) NOT NULL,     --/D Unique MaNGA identifier.
  PLATEIFU               varchar(20) NOT NULL,   --/D Unique identifier containing the MaNGA plate and ifu combination.
  PLATE                  int NOT NULL,     --/D Plate used to observe galaxy.
  IFUDSGN                varchar(20) NOT NULL,     --/D IFU used to observe galaxy.
  OBJRA                  float NOT NULL,     --/D Right ascension of the galaxy, not the IFU.
  OBJDEC                 float NOT NULL,     --/D Declination of the galaxy, not the IFU.
  REDSHIFT               real NOT NULL,     --/D Redshift of the galaxy.
  PHOTOMETRIC_MASS       real NOT NULL,     --/U log(M_sun) --/D Stellar mass of galaxy from NSA catalogue obtained from K-correction fits to elliptical Petrosian photometric fluxes.
  MANGADRP_VER           varchar(20) NOT NULL,     --/D Version of MaNGA DRP that produced this data.
  MANGADAP_VER           varchar(20) NOT NULL,     --/D Version of MaNGA DAP that analysed this data.
  FIREFLY_VER            varchar(20) NOT NULL,     --/D Version of FIREFLY that analysed this data.
  LW_AGE_1RE             real NOT NULL,       --/U log(Gyr) --/D Light-weighted age within a shell located at 1Re.
  LW_AGE_1RE_ERROR       real NOT NULL,       --/U log(Gyr) --/D Error on light-weighted age within a shell located at 1Re.
  MW_AGE_1RE             real NOT NULL,       --/U log(Gyr) --/D Mass-weighted age within a shell located at 1Re.
  MW_AGE_1RE_ERROR       real NOT NULL,       --/U log(Gyr) --/D Error on mass-weighted age within a shell located at 1Re.
  LW_Z_1RE               real NOT NULL,       --/D Light-weighted metallicity [Z/H] within a shell located at 1Re. 
  LW_Z_1RE_ERROR         real NOT NULL,       --/D Error on light-weighted metallicity [Z/H] within a shell located at 1Re. 
  MW_Z_1RE               real NOT NULL,       --/D Mass-weighted metallicity [Z/H] within a shell located at 1Re. 
  MW_Z_1RE_ERROR         real NOT NULL,       --/D Error on mass-weighted metallicity [Z/H] within a shell located at 1Re. 
  LW_AGE_3ARCSEC         real NOT NULL,       --/U log(Gyr) --/D Light-weighted age within 3arcsec diameter. 
  LW_AGE_3ARCSEC_ERROR   real NOT NULL,       --/U log(Gyr) --/D Error on light-weighted age within 3arcsec.
  MW_AGE_3ARCSEC         real NOT NULL,       --/U log(Gyr) --/D Mass-weighted age within 3arcsec diameter.
  MW_AGE_3ARCSEC_ERROR   real NOT NULL,       --/U log(Gyr) --/D Error on mass-weighted age within 3arcsec.
  LW_Z_3ARCSEC           real NOT NULL,       --/D Light-weighted metallicity [Z/H] within 3arcsec diameter. 
  LW_Z_3ARCSEC_ERROR     real NOT NULL,       --/D Error on light-weighted metallicity [Z/H] within 3arcsec. 
  MW_Z_3ARCSEC           real NOT NULL,       --/D Mass-weighted metallicity [Z/H] within 3arcsec diameter. 
  MW_Z_3ARCSEC_ERROR     real NOT NULL,       --/D Error on mass-weighted metallicity [Z/H] within 3arcsec.
  LW_AGE_GRADIENT         real NOT NULL,      --/U dex/Re --/D Light-weighted age gradient of linear fit obtained within 1.5Re.
  LW_AGE_GRADIENT_ERROR   real NOT NULL,      --/U dex/Re --/D Error on light-weighted age gradient within 1.5Re of galaxy.
  LW_AGE_ZEROPOINT        real NOT NULL,      --/D Light-weighted age zeropoint of linear fit obtained within 1.5Re.
  LW_AGE_ZEROPOINT_ERROR  real NOT NULL,      --/D Error on light-weighted age zeropoint obtained within 1.5Re.
  MW_AGE_GRADIENT         real NOT NULL,      --/U dex/Re --/D Mass-weighted age gradient of linear fit obtained within 1.5Re.
  MW_AGE_GRADIENT_ERROR   real NOT NULL,      --/U dex/Re --/D Error on mass-weighted age gradient within 1.5Re of galaxy.
  MW_AGE_ZEROPOINT        real NOT NULL,      --/D Mass-weighted age zeropoint of linear fit obtained within 1.5Re.
  MW_AGE_ZEROPOINT_ERROR  real NOT NULL,      --/D Error on mass-weighted age zeropoint obtained within 1.5Re.
  LW_Z_GRADIENT           real NOT NULL,      --/U dex/Re --/D Light-weighted metallicity [Z/H] gradient of linear fit obtained within 1.5Re.
  LW_Z_GRADIENT_ERROR     real NOT NULL,      --/U dex/Re --/D Error on light-weighted metallicity [Z/H] gradient within 1.5Re of galaxy.
  LW_Z_ZEROPOINT          real NOT NULL,      --/D Light-weighted metallicity [Z/H] zeropoint of linear fit obtained within 1.5Re.
  LW_Z_ZEROPOINT_ERROR    real NOT NULL,      --/D Error on light-weighted metallicity [Z/H] zeropoint obtained within 1.5Re.
  MW_Z_GRADIENT           real NOT NULL,      --/U dex/Re --/D Mass-weighted metallicity [Z/H] gradient of linear fit obtained within 1.5Re.
  MW_Z_GRADIENT_ERROR     real NOT NULL,      --/U dex/Re --/D Error on mass-weighted metallicity [Z/H] gradient within 1.5Re of galaxy.
  MW_Z_ZEROPOINT          real NOT NULL,      --/D Mass-weighted metallicity [Z/H] zeropoint of linear fit obtained within 1.5Re.
  MW_Z_ZEROPOINT_ERROR    real NOT NULL,      --/D Error on mass-weighted metallicity [Z/H] zeropoint obtained within 1.5Re.
)
GO
--



-- revert to primary file group
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[VacTables.sql]: VAC tables created'
GO


