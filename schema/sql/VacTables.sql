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
--* 2021-09-29  Ani: Moved SDSS17Pipe3D_v3_1_1 to MangaTables (as mangaPipe3D) (DR17).
--* 2022-12-27  Ani: Added eFEDs VACs (DR18).
--* 2022-12-28  Ani: Replaced "--\" with "--/" and removed indents for table
--*             description rows in eFEDs VACs (DR18).
--* 2025-04-21  Ani: Added VACs (DR19).
--* 2025-05-26  Ani: Added StarFlow, StarHorse (DR19 version) and 
--*                  eROSITA VACs (DR19).
--* 2025-06-03  Ani: Added PK column to StarFlow summary. (DR19)
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
  xray_detection 		varchar(5) NOT NULL,		--/D Flag indicating whether the X-ray source was detected in the 2RXS or XMMSL2 survey.
  name 					varchar(32) NOT NULL,       --/D Name of the X-ray detection (Saxton et al. 2008, Boller et al. 2016).
  RA					real NOT NULL,				--/D Right ascension of the X-ray detection (J2000; Saxton et al. 2008, Boller et al. 2016).
  DEC					real NOT NULL,				--/D Declination of the X-ray detection (J2000; Saxton et al. 2008, Boller et al. 2016).
  ExiML_2RXS			real NOT NULL,				--/D Existence likelihood of the 2RXS X-ray detection (Boller et al. 2016).
  ExpTime_2RXS			real NOT NULL,				--/D Exposure time of the 2RXS X-ray detection (Boller et al. 2016).
  DETML_XMMSL2			real NOT NULL, 				--/D Detection likelihood of the XMMSL2 detection in the 0.2-12 keV range (Saxton et al. 2008).
  ExpTime_XMMSL2		real NOT NULL,				--/D Exposure time of the XMMSL2 X-ray detection (Saxton et al. 2008).
  f_class_2RXS			real NOT NULL,				--/D Classical flux in the observed-frame 0.1-2.4 keV range (2RXS).
  errf_class_2RXS		real NOT NULL,				--/D Uncertainty in the classical flux in the observed-frame 0.1-2.4 keV range (2RXS).
  f_bay_2RXS			real NOT NULL,				--/D Bayesian flux in the observed-frame 0.1-2.4 keV range (2RXS).
  errf_bay_2RXS			real NOT NULL,				--/D Uncertainty in the Bayesian flux in the observed-frame 0.1-2.4 keV range (2RXS).
  l_class_2RXS			real NOT NULL,				--/D Classical luminosity in the observed-frame 0.1-2.4 keV range (derived from f_class_2RXS; no k-correction applied) (2RXS).
  errl_class_2RXS		real NOT NULL,				--/D Uncertainty in the classical luminosity in the observed-frame 0.1-2.4 keV range (derived from errf_class_2RXS; no k-correction applied) (2RXS).
  l_bay_2RXS			real NOT NULL,				--/D Bayesian luminosity in the observed-frame 0.1-2.4 keV range (derived from f_bay_2RXS; no k-correction applied) (2RXS).
  errl_bay_2RXS			real NOT NULL,				--/D Uncertainty in the Bayesian luminosity in the observed-frame 0.1-2.4 keV range (derived from errf_bay_2RXS; no k-correction applied) (2RXS).
  l2keV_class_2RXS		real NOT NULL,				--/D Classical monochromatic luminosity at rest-frame 2 keV (2RXS).
  errl2keV_class_2RXS	real NOT NULL,				--/D Uncertainty in the classical monochromatic luminosity at rest-frame 2 keV (2RXS).
  l2keV_bay_2RXS		real NOT NULL,				--/D Bayesian monochromatic luminosity at rest-frame 2 keV (2RXS).
  errl2keV_bay_2RXS		real NOT NULL,				--/D Uncertainty in the Bayesian monochromatic luminosity at rest-frame 2 keV (2RXS).
  f_XMMSL2				real NOT NULL,				--/D Flux in the 0.2-12 keV range (XMMSL2; Saxton et al. 2008).
  errf_XMMSL2			real NOT NULL,				--/D Uncertainty in the flux in the 0.2-12 keV range (XMMSL2; Saxton et al. (2008)).
  l_XMMSL2				real NOT NULL,				--/D Luminosity in the 0.2-12 keV range (derived from f_XMMSL2; no k-correction applied) (XMMSL2).
  errl_XMMSL2			real NOT NULL,				--/D Uncertainty in the luminosity in the 0.2-12 keV range (derived from errf_XMMSL2; no k-correction applied) (XMMSL2).
  Plate					bigint NOT NULL,			--/D SDSS plate number.
  MJD					bigint NOT NULL,			--/D MJD that the SDSS spectrum was taken.
  FiberID				bigint NOT NULL,			--/D SDSS fiber identification.
  DR16_RUN2D			varchar(32) NOT NULL,		--/D Spectroscopic reprocessing number.
  SPECOBJID				real NOT NULL,				--/D Unique spectroscopic object ID.
  DR16_PLUGRA			real NOT NULL,				--/D Right ascension of the drilled fiber position.
  DR16_PLUGDEC			real NOT NULL,				--/D Declination of the drilled fiber position.
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
  errvirialfwhm_mgII    real NOT NULL,				--/D Uncertainty in the FWHM of the MgII broad line profile.
  virialfwhm_hb    		real NOT NULL,				--/D FWHM of the H beta broad line profile.
  errvirialfwhm_hb    	real NOT NULL,				--/D Uncertainty in the FWHM of the H beta broad line profile.
  mgII_chi    			real NOT NULL,				--/D Reduced chi-squared of the fit to the MgII region.
  hb_chi    			real NOT NULL,				--/D Reduced chi-squared of the fit to the H beta region.
  l_2500          		float NOT NULL,				--/D Monochromatic luminosity at 2500 Ang.
  errl_2500          	float NOT NULL,				--/D Uncertainty in the monochromatic luminosity at 2500 Ang.
  l_3000          		float NOT NULL,				--/D Monochromatic luminosity at 3000 Ang.
  errl_3000          	float NOT NULL,				--/D Uncertainty in the monochromatic luminosity at 3000 Ang.
  l_5100          		float NOT NULL,				--/D Monochromatic luminosity at 5100 Ang.
  errl_5100          	float NOT NULL,				--/D Uncertainty in the monochromatic luminosity at 5100 Ang.
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
  flag_abs    			real NOT NULL,				--/D Flag indicating whether or not strong absorption lines have been observed in the spectrum. flag_abs is set to either 0 (spectrum not inspected for absorption lines/no absorption present) or 1 (absorption present).
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


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'eFEDS_Main_speccomp')
	DROP TABLE eFEDS_Main_speccomp
GO
--
EXEC spSetDefaultFileGroup 'eFEDS_Main_speccomp'
GO

CREATE TABLE eFEDS_Main_speccomp (
-------------------------------------------------------------------------------
--/H eROSITA/eFEDS Main source catalogue counterparts with redshifts/classifications updated with SDSS-V information.
-------------------------------------------------------------------------------
--/T A catalogue of soft X-ray (0.2-2.3 keV) selected sources detected in the eROSITA/eFEDS performance verification field (Brunner et al., 2022), 
--/T and classificaions (w.r.t. Salvato et al. 2022), using a spectroscopic compilation, derived from several facilities, 
--/T but dominated by SDSS/BOSS spectroscopy. We include new information derived from 37 dedicated SDSS-V plates, observed between Dec 2020-May 2021. 
--/T We combine automated redshift and classifications, provided by the standard SDSS idlspec1d pipeline, with an extensive and targeted set of 
--/T visual inspections, which increases the reliability and completeness of the spectroscopic coverage.
-------------------------------------------------------------------------------

	ero_name varchar(30) NOT NULL, --/U  --/D    From Brunner+22, eROSITA official source Name
	ero_id_src int NOT NULL, --/U  --/D    From Brunner+22, ID of eROSITA source in the Main Sample
	ero_ra_corr float NOT NULL, --/U deg --/D    From Brunner+22, J2000 Right Ascension of eROSITA source (corrected)
	ero_dec_corr float NOT NULL, --/U deg --/D    From Brunner+22, J2000 Declination of eROSITA source (corrected)
	ero_radec_err_corr real, --/U arcsec --/D    From Brunner+22, eROSITA positional uncertainty (corrected)
	ero_ml_flux real, --/U erg/cm^2/s --/D    From Brunner+22, 0.2-2.3 keV source flux
	ero_ml_flux_err real, --/U erg/cm^2/s --/D    From Brunner+22, 0.2-2.3 keV source flux error (1 sigma)
	ero_det_like real, --/U  --/D    From Brunner+22, 0.2-2.3 keV detection likelihood via PSF-fitting
	ctp_ls8_unique_objid varchar(20), --/U  --/D    From Salvato+22, LS8 unique id for ctp to the eROSITA source
	ctp_ls8_ra float, --/U deg --/D    From Salvato+22, Right Ascension of the LS8 counterpart
	ctp_ls8_dec float, --/U deg --/D    From Salvato+22, Declination of the best LS8 counterpart
	dist_ctp_ls8_ero real, --/U arcsec --/D    From Salvato+22, Separation between ctp and eROSITA position
	ctp_quality smallint, --/U  --/D    From Salvato+22, ctp qual: 4=best,3=good,2=secondary,1/0=unreliable
	ls_id bigint, --/U  --/D    Unique ID of lsdr9 photometric object labelled with spec-z
	ls_ra float, --/U deg --/D    Coordinate from lsdr9 at epoch LS9_EPOCH
	ls_dec float, --/U deg --/D    Coordinate from lsdr9 at epoch LS9_EPOCH
	ls_pmra real, --/U mas/yr --/D    Proper motion from lsdr9
	ls_pmdec real, --/U mas/yr --/D    Proper motion from lsdr9
	ls_epoch real, --/U year --/D    Coordinate epoch from lsdr9
	ls_mag_g real, --/U mag --/D    DECam g-band model magnitude from lsdr9, AB
	ls_mag_r real, --/U mag --/D    DECam r-band model magnitude from lsdr9, AB
	ls_mag_z real, --/U mag --/D    DECam z-band model magnitude from lsdr9, AB
	specz_n int, --/U  --/D    Total number of spec-z associated with this lsdr9 object
	specz_raj2000 float, --/U deg --/D    Coordinate of spec-z, propagated if necessary to epoch J2000
	specz_dej2000 float, --/U deg --/D    Coordinate of spec-z, propagated if necessary to epoch J2000
	specz_nsel int, --/U  --/D    Number of spec-z selected to inform result for this object
	specz_redshift real, --/U  --/D    Final redshift determined for this object
	specz_normq int, --/U  --/D    Final normalised redshift quality associated with this object
	specz_normc varchar(10), --/U  --/D    Final normlised classfication determined for this object
	specz_hasvi bit, --/U  --/D    True if best spec-z for this object has a visual inspection
	specz_catcode varchar(20), --/U  --/D    Catalogue code of best spec-z for this object
	specz_bitmask bigint, --/U  --/D    Bitmask encoding catalogues containing spec-z for this object
	specz_sel_bitmask bigint, --/U  --/D    Bitmask encoding catalogues containing informative spec-z for object
	specz_flags int, --/U  --/D    Bitmask encoding quality flags for this object
	specz_sel_normq_max int, --/U  --/D    Highest NORMQ of informative spec-z for this object
	specz_sel_normq_mean real, --/U  --/D    Mean NORMQ of informative spec-z for this object
	specz_sel_z_mean real, --/U  --/D    Mean REDSHIFT of informative spec-z for this object
	specz_sel_z_median real, --/U  --/D    Median REDSHIFT of informative spec-z for this object
	specz_sel_z_stddev real, --/U  --/D    Standard deviation of REDSHIFTs for informative spec-z for object
	specz_orig_ra float, --/U deg --/D    Coordinate associated with individual spec-z measurement
	specz_orig_dec float, --/U deg --/D    Coordinate associated with individual spec-z measurement
	specz_orig_pos_epoch real, --/U  --/D    Coordinate epoch associated with individual spec-z measurement
	specz_orig_ls_sep real, --/U arcsec --/D    Distance from spec-z to lsdr9 photometric ctp (corrected for pm)
	specz_orig_ls_gt1ctp bit, --/U  --/D    Can spec-z be associated with >1 possible lsdr9 counterpart?
	specz_orig_ls_ctp_rank int, --/U  --/D    Rank of ctp out of all possibilities for this spec-z (1=closest)
	specz_orig_id varchar(40), --/U  --/D    Orig. value of ID of individual spec-z measurement (as a string)
	specz_orig_redshift real, --/U  --/D    Orig. redshift value of individual spec-z measurement
	specz_orig_qual varchar(10), --/U  --/D    Orig. redshift quality value of individual spec-z measurement
	specz_orig_normq int, --/U  --/D    Orig. redshift quality of individual spec-z measurement - normalised
	specz_orig_class varchar(20), --/U  --/D    Orig. classification label of individual spec-z measurement
	specz_orig_hasvi bit, --/U  --/D    True if individual spec-z has a visual inspection from our team
	specz_orig_normc varchar(10), --/U  --/D    Normalised classification code of individual spec-z measurement
	specz_ra_used float, --/U deg --/D    Adopted coordinate of specz when matching to Salvato+22 counterpart
	specz_dec_used float, --/U deg --/D    Adopted coordinate of specz when matching to Salvato+22 counterpart
	separation_specz_ctp float, --/U arcsec --/D    Distance from LS_RA,LS_DEC to SPECZ_RA_USED,SPECZ_DEC_USED
	has_specz bit, --/U  --/D    Does this Salvato+22 counterpart have a spec-z?
	has_informative_specz bit --/U  --/D    Does this Salvato+22 counterpart have an informative spec-z?
)
GO
--


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'eFEDS_Hard_speccomp')
	DROP TABLE eFEDS_Hard_speccomp
GO
--
EXEC spSetDefaultFileGroup 'eFEDS_Hard_speccomp'
GO

CREATE TABLE eFEDS_Hard_speccomp (
-------------------------------------------------------------------------------
--/H eROSITA/eFEDS Hard source catalogue counterparts with redshifts/classifications updated with SDSS-V information.
-------------------------------------------------------------------------------
--/T A catalogue of hard X-ray (2.3-5 keV) selected sources detected in the eROSITA/eFEDS performance verification field (Brunner et al., 2022), 
--/T with optical/IR counterpart associations (Salvato et al., 2022). This catalogue (Merloni et al., in prep) updates the spectroscopic redshift 
--/T and classificaions (w.r.t. Salvato et al. 2022), using a spectroscopic compilation, derived from several facilities, but dominated by 
--/T SDSS/BOSS spectroscopy. We include new information derived from 37 dedicated SDSS-V plates, observed between Dec 2020-May 2021. 
--/T We combine automated redshift and classifications, provided by the standard SDSS idlspec1d pipeline, with an extensive and targeted set of visual inspections, 
--/T which increase the reliability and completeness of the spectroscopic coverage.
-------------------------------------------------------------------------------

	ero_name varchar(30) NOT NULL, --/U  --/D    From Brunner+22, eROSITA official source Name
	ero_id_src int NOT NULL, --/U  --/D    From Brunner+22, ID of eROSITA source in the Main Sample
	ero_ra_corr real NOT NULL, --/U deg --/D    From Brunner+22, J2000 Right Ascension of eROSITA source (corrected)
	ero_dec_corr real NOT NULL, --/U deg --/D    From Brunner+22, J2000 Declination of eROSITA source (corrected)
	ero_radec_err_corr real NOT NULL, --/U arcsec --/D    From Brunner+22, eROSITA positional uncertainty (corrected)
	ero_ml_flux_3 real, --/U erg/cm^2/s --/D    From Brunner+22, 2.3-5.0 keV source flux
	ero_ml_flux_err_3 real , --/U erg/cm^2/s --/D    From Brunner+22, 2.3-5.0 keV source flux error (1 sigma)
	ero_det_like_3 real , --/U  --/D    From Brunner+22, 2.3-5.0 keV detection likelihood via PSF-fitting
	ctp_ls8_unique_objid varchar(20) , --/U  --/D    From Salvato+22, LS8 unique id for ctp to the eROSITA source
	ctp_ls8_ra real , --/U deg --/D    From Salvato+22, Right Ascension of the LS8 counterpart
	ctp_ls8_dec real , --/U deg --/D    From Salvato+22, Declination of the best LS8 counterpart
	dist_ctp_ls8_ero real , --/U arcsec --/D    From Salvato+22, Separation between ctp and eROSITA position
	ctp_quality smallint , --/U  --/D    From Salvato+22, ctp qual: 4=best,3=good,2=secondary,1/0=unreliable
	ls_id bigint , --/U  --/D    Unique ID of lsdr9 photometric object labelled with spec-z
	ls_ra float , --/U deg --/D    Coordinate from lsdr9 at epoch LS9_EPOCH
	ls_dec float , --/U deg --/D    Coordinate from lsdr9 at epoch LS9_EPOCH
	ls_pmra real , --/U mas/yr --/D    Proper motion from lsdr9
	ls_pmdec real , --/U mas/yr --/D    Proper motion from lsdr9
	ls_epoch real , --/U year --/D    Coordinate epoch from lsdr9
	ls_mag_g real , --/U mag --/D    DECam g-band model magnitude from lsdr9, AB
	ls_mag_r real , --/U mag --/D    DECam r-band model magnitude from lsdr9, AB
	ls_mag_z real , --/U mag --/D    DECam z-band model magnitude from lsdr9, AB
	specz_n int , --/U  --/D    Total number of spec-z associated with this lsdr9 object
	specz_raj2000 float , --/U deg --/D    Coordinate of spec-z, propagated if necessary to epoch J2000
	specz_dej2000 float , --/U deg --/D    Coordinate of spec-z, propagated if necessary to epoch J2000
	specz_nsel int , --/U  --/D    Number of spec-z selected to inform result for this object
	specz_redshift real , --/U  --/D    Final redshift determined for this object
	specz_normq int , --/U  --/D    Final normalised redshift quality associated with this object
	specz_normc varchar(10) , --/U  --/D    Final normlised classfication determined for this object
	specz_hasvi bit , --/U  --/D    True if best spec-z for this object has a visual inspection
	specz_catcode varchar(20) , --/U  --/D    Catalogue code of best spec-z for this object
	specz_bitmask bigint , --/U  --/D    Bitmask encoding catalogues containing spec-z for this object
	specz_sel_bitmask bigint , --/U  --/D    Bitmask encoding catalogues containing informative spec-z for object
	specz_flags int , --/U  --/D    Bitmask encoding quality flags for this object
	specz_sel_normq_max int , --/U  --/D    Highest NORMQ of informative spec-z for this object
	specz_sel_normq_mean real , --/U  --/D    Mean NORMQ of informative spec-z for this object
	specz_sel_z_mean real , --/U  --/D    Mean REDSHIFT of informative spec-z for this object
	specz_sel_z_median real , --/U  --/D    Median REDSHIFT of informative spec-z for this object
	specz_sel_z_stddev real , --/U  --/D    Standard deviation of REDSHIFTs for informative spec-z for object
	specz_orig_ra float , --/U deg --/D    Coordinate associated with individual spec-z measurement
	specz_orig_dec float , --/U deg --/D    Coordinate associated with individual spec-z measurement
	specz_orig_pos_epoch real , --/U  --/D    Coordinate epoch associated with individual spec-z measurement
	specz_orig_ls_sep real , --/U arcsec --/D    Distance from spec-z to lsdr9 photometric ctp (corrected for pm)
	specz_orig_ls_gt1ctp bit , --/U  --/D    Can spec-z be associated with >1 possible lsdr9 counterpart?
	specz_orig_ls_ctp_rank int , --/U  --/D    Rank of ctp out of all possibilities for this spec-z (1=closest)
	specz_orig_id varchar(40) , --/U  --/D    Orig. value of ID of individual spec-z measurement (as a string)
	specz_orig_redshift real , --/U  --/D    Orig. redshift value of individual spec-z measurement
	specz_orig_qual varchar(10) , --/U  --/D    Orig. redshift quality value of individual spec-z measurement
	specz_orig_normq int , --/U  --/D    Orig. redshift quality of individual spec-z measurement - normalised
	specz_orig_class varchar(20) , --/U  --/D    Orig. classification label of individual spec-z measurement
	specz_orig_hasvi bit , --/U  --/D    True if individual spec-z has a visual inspection from our team
	specz_orig_normc varchar(10) , --/U  --/D    Normalised classification code of individual spec-z measurement
	specz_ra_used float , --/U deg --/D    Adopted coordinate of specz when matching to Salvato+22 counterpart
	specz_dec_used float , --/U deg --/D    Adopted coordinate of specz when matching to Salvato+22 counterpart
	separation_specz_ctp float , --/U arcsec --/D    Distance from LS_RA,LS_DEC to SPECZ_RA_USED,SPECZ_DEC_USED
	has_specz bit , --/U  --/D    Does this Salvato+22 counterpart have a spec-z?
	has_informative_specz bit  --/U  --/D    Does this Salvato+22 counterpart have an informative spec-z?
)
GO
--



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'eFEDS_SDSSV_spec_results')
	DROP TABLE eFEDS_SDSSV_spec_results
GO
--
EXEC spSetDefaultFileGroup 'eFEDS_SDSSV_spec_results'
GO

CREATE TABLE eFEDS_SDSSV_spec_results (
-------------------------------------------------------------------------------
--/H SDSS-V/eFEDS catalogue of spectroscopic redshift and visual inspection information.
-------------------------------------------------------------------------------
--/T A catalogue of spectroscopic redshifts and classifications derived solely from the SDSS-V/eFEDS plate data set. 
--/T The pipeline redshift/classification information for many spectra is supplemented by the results of 
--/T an extensive visual inspection process. We include an entry for all spectra of science targets in the SDSS-V/eFEDS plates, 
--/T regardless of whether they are deemed to be counterparts to eROSITA X-ray sources.
-------------------------------------------------------------------------------

	field smallint NOT NULL, --/U  --/D    SDSS field code identifier
	mjd int NOT NULL, --/U  --/D    SDSS MJD associated with this spectrum
	catalogid bigint NOT NULL, --/U  --/D    SDSS-V CATALOGID (v0) associated with this target
	plug_ra float NOT NULL, --/U deg --/D    Sky coordinate of spectroscopic fiber
	plug_dec float NOT NULL, --/U deg --/D    Sky coordinate of spectroscopic fiber
	nvi smallint, --/U  --/D    Number of visual inspections collected for this spectrum
	sn_median_all float, --/U  --/D    Median SNR/pix in spectrum (idlspec2d eFEDS v6_0_2 reductions)
	z_pipe float, --/U  --/D    Pipeline redshift in idlspec1d eFEDS v6_0_2 reductions
	z_err_pipe float, --/U  --/D    Pipeline redshift uncertainty in idlspec1d eFEDS v6_0_2 reductions
	zwarning_pipe smallint, --/U  --/D    Pipeline redshift warning flags in idlspec1d eFEDS v6_0_2 reductions
	class_pipe varchar(10), --/U  --/D    Pipeline classification in idlspec1d eFEDS v6_0_2 reductions
	subclass_pipe varchar(30), --/U  --/D    Pipeline sub-classification in idlspec1d eFEDS v6_0_2 reductions
	z_final float, --/U  --/D    Final redshift derived from pipeline and visual inspections
	z_conf_final smallint, --/U  --/D    Final redshift confidence from pipeline and visual inspections
	class_final varchar(20), --/U  --/D    Final classfication derived from pipeline and visual inspections
	blazar_candidate bit --/U  --/D    Was object flagged as a blazar candidate in visual inspections?
)
GO
--


-- VACs for DR19

--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'allVisit_MADGICS_th')
	DROP TABLE allVisit_MADGICS_th
GO
--
EXEC spSetDefaultFileGroup 'allVisit_MADGICS_th'
GO
--// Created from /uufs/chpc.utah.edu/common/home/sdss52/dr19/vac/mwm/apMADGICS/v2024_03_16-part1/outdir_wu_th/allVisit_MADGICS_v2024_03_16_th.fits
--// HDU 1 (113 columns x 2618012 rows)
CREATE TABLE allVisit_MADGICS_th (
-------------------------------------------------------------------------------
--/H Summary file of scalar outputs from apMADGICS pipeline processing of all
--/H visit spectra in APOGEE DR17 for star_prior_type = "th"
-------------------------------------------------------------------------------
--/T Summary file of scalar outputs from apMADGICS pipeline processing of all 
--/T visit spectra in APOGEE DR17. Contains stellar radial velocities,
--/T DIB properties, and crossmatches to the standard APOGEE DRP allStar and 
--/T allVisit files, for star_prior_type = "dd".
-------------------------------------------------------------------------------
    SDSS_ID bigint NOT NULL, --/U  --/D SDSS_ID of Target
    dib_minchi2_final_1_15273 float NOT NULL, --/U  --/D minimum value of the delta chi2 at the optimum for adding DIB model 1_15273 to the MADGICS model for the visit spectrum  
    tot_p5chi2_v1_1_15273 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model after including the DIB model 1_15273  
    dr17_logg real NOT NULL, --/U log10(cm/s²) --/D log(g) from ASPCAP allStar file for DR17  
    dib_sigval_final_3_15672 float NOT NULL, --/U Å --/D DIB width sigma value at optimum for DIB model 3_15672  
    tot_p5chi2_v1_2_15273 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model after including the DIB model 2_15273  
    ingestbit bigint NOT NULL, --/U  --/D Bit mask value indicating any issues with ingesting the standard DRP spectra by the apMADGICS pipeline. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl">https://github.com/andrew-saydjari/apMADGICS.jl</a> for more  
    dec float NOT NULL, --/U deg --/D Declination (J2000)  
    ew_dib_2_15273 float NOT NULL, --/U Å --/D Equivalent width of DIB in the 2_15273 DIB model  
    rv_pixoff_disc_final float NOT NULL, --/U pixels --/D Discrete (grid point) pixel offset nearest stellar radial velocity optimum  
    ew_dib_err_1_15273 float NOT NULL, --/U Å --/D Uncertainty in DIB equivalent width for DIB model 1_15273  
    a_relflux float NOT NULL, --/U  --/D Relative fluxing applied upstream by DRP to chip a  
    dib_minchi2_final_2_15273 float NOT NULL, --/U  --/D minimum value of the delta chi2 at the optimum for adding DIB model 2_15273 to the MADGICS model for the visit spectrum  
    ew_dib float NOT NULL, --/U Å --/D Equivalent width of DIB in 2_15273 DIB model  
    skyscale1 float NOT NULL, --/U ADU --/D Second pass median sky flux in apMADGICS sky component model of the visit  
    dib_sigval_disc_final_2_15273 float NOT NULL, --/U Å --/D Discrete DIB width sigma value (on gridpoint) at optimum for DIB model 2_15273  
    rv_verr float NOT NULL, --/U km/s --/D Stellar radial velocity error from apMADGICS, calibrated EXCEPT for systematics (should be used with STAR_PRIOR_TYPE=th)  
    data_pix_cnt bigint NOT NULL, --/U  --/D Number of unmasked pixels in the input spectrum to apMADGICS component separation  
    b_relflux float NOT NULL, --/U  --/D Relative fluxing applied upstream by DRP to chip b  
    gaiaedr3_source_id bigint NOT NULL, --/U  --/D Gaia source ID from Gaia EDR3  
    drp_vrel float NOT NULL, --/U km/s --/D Stellar radial velocity in the observed frame from standard DRP (km/s)  
    ew_dib_err_3_15672 float NOT NULL, --/U Å --/D Uncertainty in DIB equivalent width for DIB model 3_15672  
    dib_snr float NOT NULL, --/U  --/D Calibrated signal-to-noise ration for DIB detection under DIB model 2_15273  
    drp_snr real NOT NULL, --/U  --/D Visit signal-to-noise ratio estimate from standard DRP  
    dibchi2_residuals_2_15273 float NOT NULL, --/U  --/D Chi2 of the residual component after fitting DIB model 2_15273  
    ew_dib_3_15672 float NOT NULL, --/U Å --/D Equivalent width of DIB in the 3_15672 DIB model  
    dib_v_lsr_coframe float NOT NULL, --/U km/s --/D Radial velocity of DIB in the local standard of rest used by Dame et al. 2001 for DIB model 2_15273  
    fluxerr2_nans bigint NOT NULL, --/U  --/D Number of nan pixels in the reinterpolated flux variance spectrum  
    gx float NOT NULL, --/U kpc --/D Galactocentric cartesian X-coordinate  
    rv_vel float NOT NULL, --/U km/s --/D Stellar radial velocity from apMADGICS in observed frame (should be used with STAR_PRIOR_TYPE=th)  
    dib_sigval_disc_final_3_15672 float NOT NULL, --/U Å --/D Discrete DIB width sigma value (on gridpoint) at optimum for DIB model 3_15672  
    rv_pixoff_final float NOT NULL, --/U pixels --/D Pixel offset nearest stellar radial velocity optimum  
    rvchi2_residuals float NOT NULL, --/U  --/D Chi2 value for the residual component after the RV fitting step for the apMADGICS component separation  
    map2madgics bigint NOT NULL, --/U  --/D Index mapping the apMADGICS output files to the ordering of this file. CAUTION 1-indexed (not 0-indexed). Not identity mapping because we drop spectra that are entirely NaNs from this summary table.  
    dib_pixoff_disc_final_3_15672 float NOT NULL, --/U pixels --/D DIB discrete pixel offset at optimum for DIB model 3_15672  
    dib_pixoff_final_3_15672 float NOT NULL, --/U pixels --/D DIB pixel offset at optimum for DIB model 3_15672  
    dibchi2_residuals_3_15672 float NOT NULL, --/U  --/D Chi2 of the residual component after fitting DIB model 3_15672  
    dib_pixoff_disc_final_4_15672 float NOT NULL, --/U pixels --/D DIB discrete pixel offset at optimum for DIB model 4_15672  
    dib_flag_1_15273 bigint NOT NULL, --/U  --/D Flag describing the success/failure of gridsearch fiting DIB model 1_15273. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl/tree/main">https://github.com/andrew-saydjari/apMADGICS.jl/tree/main</a> for explaination of bit values.  
    c_relflux float NOT NULL, --/U  --/D Relative fluxing applied upstream by DRP to chip c  
    dr17_vsini real NOT NULL, --/U km/s --/D VSINI from ASPCAP allStar file for DR17  
    glat float NOT NULL, --/U deg --/D Galactic latitude  
    dib_pixoff_final_1_15273 float NOT NULL, --/U pixels --/D DIB pixel offset at optimum for DIB model 1_15273  
    gaiaedr3_r_med_geo real NOT NULL, --/U pc --/D Gaia Bailer-Jones GEO distance estimate r_est from Gaia EDR3  
    dib_sig float NOT NULL, --/U Å --/D DIB width sigma for DIB model 2_15273  
    plate varchar(20) NOT NULL, --/U  --/D Plate ID of observation  
    drp_starflag bigint NOT NULL, --/U  --/D Flag from standard DRP processing for star condition taken from bitwise OR of individual visits, see bitmask definitions  
    dibchi2_residuals_1_15273 float NOT NULL, --/U  --/D Chi2 of the residual component after fitting DIB model 1_15273  
    tot_p5chi2_v0 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model including only the sky continuum, (faint) sky lines, stellar continuum, stellar lines, and residual components  
    flux_nans bigint NOT NULL, --/U  --/D Number of nan pixels in the reinterpolated flux spectrum  
    dib_sig_err float NOT NULL, --/U Å --/D Calibrated uncertainty on DIB width sigma for DIB model 2_15273  
    starscale1 float NOT NULL, --/U ADU --/D Second pass median star flux in apMADGICS star continuum component model of the visit  
    dib_sigval_final_2_15273 float NOT NULL, --/U Å --/D DIB width sigma value at optimum for DIB model 2_15273  
    drp_vrelerr float NOT NULL, --/U km/s --/D Uncertainty on the radial velocity from the stadard DRP  
    map2visit bigint NOT NULL, --/U  --/D Index mapping the standard DRP allVisit file to the ordering of this file. CAUTION 1-indexed (not 0-indexed)  
    ew_dib_1_15273 float NOT NULL, --/U Å --/D Equivalent width of DIB in the 1_15273 DIB model  
    rv_bary_offcor float NOT NULL, --/U km/s --/D Stellar radial velocity from apMADGICS in the frame of the solar system barycenter and also corrected for fiber-fiber RV variations (should be used with STAR_PRIOR_TYPE=th)  
    adjfiberindx bigint NOT NULL, --/U  --/D A unique fiber identifier running 1 to 600 to handle fibers at both APO and LCO  
    frame_counts bigint NOT NULL, --/U  --/D Number of contiguous exposures that were combined into a given visit  
    dib_minchi2_final_3_15672 float NOT NULL, --/U  --/D minimum value of the delta chi2 at the optimum for adding DIB model 3_15672 to the MADGICS model for the visit spectrum  
    rv_minchi2_final float NOT NULL, --/U  --/D Value of the minimum on the delta chi2 surface for the stellar radial velocity determinination step in apMADGICS  
    dib_pixoff_final_4_15672 float NOT NULL, --/U pixels --/D DIB pixel offset at optimum for DIB model 4_15672  
    ra float NOT NULL, --/U deg --/D Right ascension (J2000)  
    dr17_x_h real NOT NULL, --/U dex --/D X_H ("metallicity") from ASPCAP allStar file for DR17  
    gy float NOT NULL, --/U kpc --/D Galactocentric cartesian Y-coordinate  
    tot_p5chi2_v1_3_15672 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model after including the DIB model 3_15672  
    tot_p5chi2_v1_4_15672 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model after including the DIB model 4_15672  
    dib_minchi2_final_4_15672 float NOT NULL, --/U  --/D minimum value of the delta chi2 at the optimum for adding DIB model 4_15672 to the MADGICS model for the visit spectrum  
    mskdib bit NOT NULL, --/U  --/D Boolean mask identifying stars that are well enough modeled that the DIB model 2_15273 outputs can be trusted. A DIB "detection" still requires a cut(s) on dib_snr and/or EW_dib.  
    dib_v_lsr float NOT NULL, --/U km/s --/D DIB radial velocity in the local standard of rest for DIB model 2_15273  
    glon float NOT NULL, --/U deg --/D Galactic longitude  
    zcorr float NOT NULL, --/U  --/D Redshift correction to move from observed redshift to redshift relative to the solar system barycenter  
    rv_bary float NOT NULL, --/U km/s --/D Stellar radial velocity from apMADGICS in the frame of the solar system barycenter (should be used with STAR_PRIOR_TYPE=th)  
    ew_dib_err_4_15672 float NOT NULL, --/U Å --/D Uncertainty in DIB equivalent width for DIB model 4_15672  
    rv_flag bigint NOT NULL, --/U  --/D Grid search flag value from apMADGICS from the search for stellar radial velocity. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl">https://github.com/andrew-saydjari/apMADGICS.jl</a> for bit interpretations.  
    map2star bigint NOT NULL, --/U  --/D Index mapping the standard DRP allStar file to the ordering of this file. CAUTION 1-indexed (not 0-indexed)  
    dib_verr float NOT NULL, --/U km/s --/D Calibrated uncertainty on DIB radial velocity from DIB model 2_15273  
    gz float NOT NULL, --/U kpc --/D Galactocentric cartesian Z-coordinate  
    ew_dib_4_15672 float NOT NULL, --/U Å --/D Equivalent width of DIB in the 4_15672 DIB model  
    ew_dib_err float NOT NULL, --/U Å --/D Calibrated uncertainty in DIB equivalent width for DIB model 2_15273  
    field varchar(20) NOT NULL, --/U  --/D APOGEE targeting field name  
    dib_flag_4_15672 bigint NOT NULL, --/U  --/D Flag describing the success/failure of gridsearch fiting DIB model 4_15672. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl/tree/main">https://github.com/andrew-saydjari/apMADGICS.jl/tree/main</a> for explaination of bit values.  
    dib_flag_3_15672 bigint NOT NULL, --/U  --/D Flag describing the success/failure of gridsearch fiting DIB model 3_15672. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl/tree/main">https://github.com/andrew-saydjari/apMADGICS.jl/tree/main</a> for explaination of bit values.  
    dib_sigval_disc_final_4_15672 float NOT NULL, --/U Å --/D Discrete DIB width sigma value (on gridpoint) at optimum for DIB model 4_15672  
    dib_pixoff_disc_final_2_15273 float NOT NULL, --/U pixels --/D DIB discrete pixel offset at optimum for DIB model 2_15273  
    fiberid smallint NOT NULL, --/U  --/D APOGEE FIBERID used to obtain the visit spectrum (1 to 300 at each of APO and LCO)  
    dib_v_bary float NOT NULL, --/U km/s --/D DIB radial velocity with respect to the solar system barycenter for DIB model 15273  
    dibchi2_residuals_4_15672 float NOT NULL, --/U  --/D Chi2 of the residual component after fitting DIB model 4_15672  
    dib_sigval_disc_final_1_15273 float NOT NULL, --/U Å --/D Discrete DIB width sigma value (on gridpoint) at optimum for DIB model 1_15273  
    starscale float NOT NULL, --/U ADU --/D First pass median star flux in apMADGICS star continuum component model of the visit  
    ew_dib_err_2_15273 float NOT NULL, --/U Å --/D Uncertainty in DIB equivalent width for DIB model 2_15273  
    skyscale0 float NOT NULL, --/U ADU --/D First pass median sky flux in apMADGICS sky component model of the visit  
    rv_pix_var float NOT NULL, --/U pixels --/D Stellar radial velocity uncertainty expressed as a variance in the pixel offset (should be used with STAR_PRIOR_TYPE=th)  
    dib_pixoff_final_2_15273 float NOT NULL, --/U pixels --/D DIB pixel offset at optimum for DIB model 2_15273  
    dib_sigval_final_1_15273 float NOT NULL, --/U Å --/D DIB width sigma value at optimum for DIB model 1_15273  
    telescope varchar(10) NOT NULL, --/U  --/D Telescope used for the visit (either apo25m or lco25m for the 2.5 meters at APO or LCO)  
    mjd int NOT NULL, --/U  --/D Integer MJD (actually SJD, a SDSS construct) encoding the discretized "night" data was taken  
    chip_a_midtimes float NOT NULL, --/U s --/D Best approximation to midpoint in time for exposures used in the visit for chip a  
    chip_c_midtimes float NOT NULL, --/U s --/D Best approximation to midpoint in time for exposures used in the visit for chip c  
    drp_vhelio float NOT NULL, --/U km/s --/D Heliocentric (actually barycentric) stellar radial velocity from the standard DRP  
    gaiaedr3_parallax real NOT NULL, --/U mas --/D Gaia parallax from Gaia EDR3  
    gaiaedr3_r_lo_geo real NOT NULL, --/U pc --/D Gaia Bailer-Jones 16th GEO percentile distance r_lo from GAIA EDR3  
    chip_b_midtimes float NOT NULL, --/U s --/D Best approximation to midpoint in time for exposures used in the visit for chip b  
    dib_pixoff_disc_final_1_15273 float NOT NULL, --/U pixels --/D DIB discrete pixel offset at optimum for DIB model 1_15273  
    dib_v_rel float NOT NULL, --/U km/s --/D DIB radial velocity in observed frame (for model 2_15273)  
    gaiaedr3_r_hi_geo real NOT NULL, --/U pc --/D Gaia Bailer-Jones 84th GEO percentile distance r_hi from GAIA EDR3  
    dib_sigval_final_4_15672 float NOT NULL, --/U Å --/D DIB width sigma value at optimum for DIB model 4_15672  
    apogee_id varchar(20) NOT NULL, --/U  --/D Star identifier used by APOGEE (generally 2MASS)  
    avg_flux_conservation float NOT NULL, --/U  --/D Median fractional flux conservation of MADGICS component separation across the visit spectrum  
    dib_flag_2_15273 bigint NOT NULL, --/U  --/D Flag describing the success/failure of gridsearch fiting DIB model 2_15273. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl/tree/main">https://github.com/andrew-saydjari/apMADGICS.jl/tree/main</a> for explaination of bit values.  
    rv_verr_sys float NOT NULL, --/U km/s --/D Stellar radial velocity error with systematic corrections for apMADGICS RVs (should be used with STAR_PRIOR_TYPE=th)  
    dr17_teff real NOT NULL, --/U K --/D TEFF from ASPCAP allStar file for DR17  
    final_pix_cnt bigint NOT NULL, --/U  --/D Final number of unmasked pixels used for modeling the visit spectrum  
    cartvisit bigint NOT NULL, --/U  --/D Cart identifier for plate cart used during the visit observation (variations in total throughput can depend on the throughput of the fibers in a given cart)  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'allVisit_MADGICS_dd')
	DROP TABLE allVisit_MADGICS_dd
GO
--
EXEC spSetDefaultFileGroup 'allVisit_MADGICS_dd'
GO
--// Created from /uufs/chpc.utah.edu/common/home/sdss52/dr19/vac/mwm/apMADGICS/v2024_03_16-part1/outdir_wu_dd/allVisit_MADGICS_v2024_03_16_dd.fits
--// HDU 1 (110 columns x 2618012 rows)
CREATE TABLE allVisit_MADGICS_dd (
-------------------------------------------------------------------------------
--/H Summary file of scalar outputs from apMADGICS pipeline processing of all 
--/H visit spectra in APOGEE DR17 for star_prior_type = "dd"
-------------------------------------------------------------------------------
--/T Summary file of scalar outputs from apMADGICS pipeline processing of all 
--/T visit spectra in APOGEE DR17. Contains stellar radial velocities,
--/T DIB properties, and crossmatches to the standard APOGEE DRP allStar and 
--/T allVisit files, for star_prior_type = "dd".
-------------------------------------------------------------------------------
    SDSS_ID bigint NOT NULL, --/U  --/D SDSS_ID of Target
    dib_minchi2_final_1_15273 float NOT NULL, --/U  --/D minimum value of the delta chi2 at the optimum for adding DIB model 1_15273 to the MADGICS model for the visit spectrum  
    tot_p5chi2_v1_1_15273 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model after including the DIB model 1_15273  
    dr17_logg real NOT NULL, --/U log10(cm/s²) --/D log(g) from ASPCAP allStar file for DR17  
    dib_sigval_final_3_15672 float NOT NULL, --/U Å --/D DIB width sigma value at optimum for DIB model 3_15672  
    tot_p5chi2_v1_2_15273 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model after including the DIB model 2_15273  
    ingestbit bigint NOT NULL, --/U  --/D Bit mask value indicating any issues with ingesting the standard DRP spectra by the apMADGICS pipeline. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl">https://github.com/andrew-saydjari/apMADGICS.jl</a> for more  
    dec float NOT NULL, --/U deg --/D Declination (J2000)  
    ew_dib_2_15273 float NOT NULL, --/U Å --/D Equivalent width of DIB in the 2_15273 DIB model  
    rv_pixoff_disc_final float NOT NULL, --/U pixels --/D Discrete (grid point) pixel offset nearest stellar radial velocity optimum  
    ew_dib_err_1_15273 float NOT NULL, --/U Å --/D Uncertainty in DIB equivalent width for DIB model 1_15273  
    a_relflux float NOT NULL, --/U  --/D Relative fluxing applied upstream by DRP to chip a  
    dib_minchi2_final_2_15273 float NOT NULL, --/U  --/D minimum value of the delta chi2 at the optimum for adding DIB model 2_15273 to the MADGICS model for the visit spectrum  
    ew_dib float NOT NULL, --/U Å --/D Equivalent width of DIB in 2_15273 DIB model  
    skyscale1 float NOT NULL, --/U ADU --/D Second pass median sky flux in apMADGICS sky component model of the visit  
    dib_sigval_disc_final_2_15273 float NOT NULL, --/U Å --/D Discrete DIB width sigma value (on gridpoint) at optimum for DIB model 2_15273  
    data_pix_cnt bigint NOT NULL, --/U  --/D Number of unmasked pixels in the input spectrum to apMADGICS component separation  
    b_relflux float NOT NULL, --/U  --/D Relative fluxing applied upstream by DRP to chip b  
    gaiaedr3_source_id bigint NOT NULL, --/U  --/D Gaia source ID from Gaia EDR3  
    drp_vrel float NOT NULL, --/U km/s --/D Stellar radial velocity in the observed frame from standard DRP (km/s)  
    ew_dib_err_3_15672 float NOT NULL, --/U Å --/D Uncertainty in DIB equivalent width for DIB model 3_15672  
    dib_snr float NOT NULL, --/U  --/D Calibrated signal-to-noise ration for DIB detection under DIB model 2_15273  
    drp_snr real NOT NULL, --/U  --/D Visit signal-to-noise ratio estimate from standard DRP  
    dibchi2_residuals_2_15273 float NOT NULL, --/U  --/D Chi2 of the residual component after fitting DIB model 2_15273  
    ew_dib_3_15672 float NOT NULL, --/U Å --/D Equivalent width of DIB in the 3_15672 DIB model  
    dib_v_lsr_coframe float NOT NULL, --/U km/s --/D Radial velocity of DIB in the local standard of rest used by Dame et al. 2001 for DIB model 2_15273  
    fluxerr2_nans bigint NOT NULL, --/U  --/D Number of nan pixels in the reinterpolated flux variance spectrum  
    gx float NOT NULL, --/U kpc --/D Galactocentric cartesian X-coordinate  
    rv_vel float NOT NULL, --/U km/s --/D Stellar radial velocity from apMADGICS in observed frame (should be used with STAR_PRIOR_TYPE=th)  
    dib_sigval_disc_final_3_15672 float NOT NULL, --/U Å --/D Discrete DIB width sigma value (on gridpoint) at optimum for DIB model 3_15672  
    rv_pixoff_final float NOT NULL, --/U pixels --/D Pixel offset nearest stellar radial velocity optimum  
    rvchi2_residuals float NOT NULL, --/U  --/D Chi2 value for the residual component after the RV fitting step for the apMADGICS component separation  
    map2madgics bigint NOT NULL, --/U  --/D Index mapping the apMADGICS output files to the ordering of this file. CAUTION 1-indexed (not 0-indexed). Not identity mapping because we drop spectra that are entirely NaNs from this summary table.  
    dib_pixoff_disc_final_3_15672 float NOT NULL, --/U pixels --/D DIB discrete pixel offset at optimum for DIB model 3_15672  
    dib_pixoff_final_3_15672 float NOT NULL, --/U pixels --/D DIB pixel offset at optimum for DIB model 3_15672  
    dibchi2_residuals_3_15672 float NOT NULL, --/U  --/D Chi2 of the residual component after fitting DIB model 3_15672  
    dib_pixoff_disc_final_4_15672 float NOT NULL, --/U pixels --/D DIB discrete pixel offset at optimum for DIB model 4_15672  
    dib_flag_1_15273 bigint NOT NULL, --/U  --/D Flag describing the success/failure of gridsearch fiting DIB model 1_15273. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl/tree/main">https://github.com/andrew-saydjari/apMADGICS.jl/tree/main</a> for explaination of bit values.  
    c_relflux float NOT NULL, --/U  --/D Relative fluxing applied upstream by DRP to chip c  
    dr17_vsini real NOT NULL, --/U km/s --/D VSINI from ASPCAP allStar file for DR17  
    glat float NOT NULL, --/U deg --/D Galactic latitude  
    dib_pixoff_final_1_15273 float NOT NULL, --/U pixels --/D DIB pixel offset at optimum for DIB model 1_15273  
    gaiaedr3_r_med_geo real NOT NULL, --/U pc --/D Gaia Bailer-Jones GEO distance estimate r_est from Gaia EDR3  
    dib_sig float NOT NULL, --/U Å --/D DIB width sigma for DIB model 2_15273  
    plate varchar(20) NOT NULL, --/U  --/D Plate ID of observation  
    drp_starflag bigint NOT NULL, --/U  --/D Flag from standard DRP processing for star condition taken from bitwise OR of individual visits, see bitmask definitions  
    dibchi2_residuals_1_15273 float NOT NULL, --/U  --/D Chi2 of the residual component after fitting DIB model 1_15273  
    tot_p5chi2_v0 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model including only the sky continuum, (faint) sky lines, stellar continuum, stellar lines, and residual components  
    flux_nans bigint NOT NULL, --/U  --/D Number of nan pixels in the reinterpolated flux spectrum  
    dib_sig_err float NOT NULL, --/U Å --/D Calibrated uncertainty on DIB width sigma for DIB model 2_15273  
    starscale1 float NOT NULL, --/U ADU --/D Second pass median star flux in apMADGICS star continuum component model of the visit  
    dib_sigval_final_2_15273 float NOT NULL, --/U Å --/D DIB width sigma value at optimum for DIB model 2_15273  
    drp_vrelerr float NOT NULL, --/U km/s --/D Uncertainty on the radial velocity from the stadard DRP  
    map2visit bigint NOT NULL, --/U  --/D Index mapping the standard DRP allVisit file to the ordering of this file. CAUTION 1-indexed (not 0-indexed)  
    ew_dib_1_15273 float NOT NULL, --/U Å --/D Equivalent width of DIB in the 1_15273 DIB model  
    adjfiberindx bigint NOT NULL, --/U  --/D A unique fiber identifier running 1 to 600 to handle fibers at both APO and LCO  
    frame_counts bigint NOT NULL, --/U  --/D Number of contiguous exposures that were combined into a given visit  
    dib_minchi2_final_3_15672 float NOT NULL, --/U  --/D minimum value of the delta chi2 at the optimum for adding DIB model 3_15672 to the MADGICS model for the visit spectrum  
    rv_minchi2_final float NOT NULL, --/U  --/D Value of the minimum on the delta chi2 surface for the stellar radial velocity determinination step in apMADGICS  
    dib_pixoff_final_4_15672 float NOT NULL, --/U pixels --/D DIB pixel offset at optimum for DIB model 4_15672  
    ra float NOT NULL, --/U deg --/D Right ascension (J2000)  
    dr17_x_h real NOT NULL, --/U dex --/D X_H ("metallicity") from ASPCAP allStar file for DR17  
    gy float NOT NULL, --/U kpc --/D Galactocentric cartesian Y-coordinate  
    tot_p5chi2_v1_3_15672 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model after including the DIB model 3_15672  
    tot_p5chi2_v1_4_15672 float NOT NULL, --/U  --/D Total chi2 for the MADGICS model after including the DIB model 4_15672  
    dib_minchi2_final_4_15672 float NOT NULL, --/U  --/D minimum value of the delta chi2 at the optimum for adding DIB model 4_15672 to the MADGICS model for the visit spectrum  
    mskdib bit NOT NULL, --/U  --/D Boolean mask identifying stars that are well enough modeled that the DIB model 2_15273 outputs can be trusted. A DIB "detection" still requires a cut(s) on dib_snr and/or EW_dib.  
    dib_v_lsr float NOT NULL, --/U km/s --/D DIB radial velocity in the local standard of rest for DIB model 2_15273  
    glon float NOT NULL, --/U deg --/D Galactic longitude  
    zcorr float NOT NULL, --/U  --/D Redshift correction to move from observed redshift to redshift relative to the solar system barycenter  
    rv_bary float NOT NULL, --/U km/s --/D Stellar radial velocity from apMADGICS in the frame of the solar system barycenter (should be used with STAR_PRIOR_TYPE=th)  
    ew_dib_err_4_15672 float NOT NULL, --/U Å --/D Uncertainty in DIB equivalent width for DIB model 4_15672  
    rv_flag bigint NOT NULL, --/U  --/D Grid search flag value from apMADGICS from the search for stellar radial velocity. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl">https://github.com/andrew-saydjari/apMADGICS.jl</a> for bit interpretations.  
    map2star bigint NOT NULL, --/U  --/D Index mapping the standard DRP allStar file to the ordering of this file. CAUTION 1-indexed (not 0-indexed)  
    dib_verr float NOT NULL, --/U km/s --/D Calibrated uncertainty on DIB radial velocity from DIB model 2_15273  
    gz float NOT NULL, --/U kpc --/D Galactocentric cartesian Z-coordinate  
    ew_dib_4_15672 float NOT NULL, --/U Å --/D Equivalent width of DIB in the 4_15672 DIB model  
    ew_dib_err float NOT NULL, --/U Å --/D Calibrated uncertainty in DIB equivalent width for DIB model 2_15273  
    field varchar(20) NOT NULL, --/U  --/D APOGEE targeting field name  
    dib_flag_4_15672 bigint NOT NULL, --/U  --/D Flag describing the success/failure of gridsearch fiting DIB model 4_15672. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl/tree/main">https://github.com/andrew-saydjari/apMADGICS.jl/tree/main</a> for explaination of bit values.  
    dib_flag_3_15672 bigint NOT NULL, --/U  --/D Flag describing the success/failure of gridsearch fiting DIB model 3_15672. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl/tree/main">https://github.com/andrew-saydjari/apMADGICS.jl/tree/main</a> for explaination of bit values.  
    dib_sigval_disc_final_4_15672 float NOT NULL, --/U Å --/D Discrete DIB width sigma value (on gridpoint) at optimum for DIB model 4_15672  
    dib_pixoff_disc_final_2_15273 float NOT NULL, --/U pixels --/D DIB discrete pixel offset at optimum for DIB model 2_15273  
    fiberid smallint NOT NULL, --/U  --/D APOGEE FIBERID used to obtain the visit spectrum (1 to 300 at each of APO and LCO)  
    dib_v_bary float NOT NULL, --/U km/s --/D DIB radial velocity with respect to the solar system barycenter for DIB model 15273  
    dibchi2_residuals_4_15672 float NOT NULL, --/U  --/D Chi2 of the residual component after fitting DIB model 4_15672  
    dib_sigval_disc_final_1_15273 float NOT NULL, --/U Å --/D Discrete DIB width sigma value (on gridpoint) at optimum for DIB model 1_15273  
    starscale float NOT NULL, --/U ADU --/D First pass median star flux in apMADGICS star continuum component model of the visit  
    ew_dib_err_2_15273 float NOT NULL, --/U Å --/D Uncertainty in DIB equivalent width for DIB model 2_15273  
    skyscale0 float NOT NULL, --/U ADU --/D First pass median sky flux in apMADGICS sky component model of the visit  
    rv_pix_var float NOT NULL, --/U pixels --/D Stellar radial velocity uncertainty expressed as a variance in the pixel offset (should be used with STAR_PRIOR_TYPE=th)  
    dib_pixoff_final_2_15273 float NOT NULL, --/U pixels --/D DIB pixel offset at optimum for DIB model 2_15273  
    dib_sigval_final_1_15273 float NOT NULL, --/U Å --/D DIB width sigma value at optimum for DIB model 1_15273  
    telescope varchar(10) NOT NULL, --/U  --/D Telescope used for the visit (either apo25m or lco25m for the 2.5 meters at APO or LCO)  
    mjd int NOT NULL, --/U  --/D Integer MJD (actually SJD, a SDSS construct) encoding the discretized "night" data was taken  
    chip_a_midtimes float NOT NULL, --/U s --/D Best approximation to midpoint in time for exposures used in the visit for chip a  
    chip_c_midtimes float NOT NULL, --/U s --/D Best approximation to midpoint in time for exposures used in the visit for chip c  
    drp_vhelio float NOT NULL, --/U km/s --/D Heliocentric (actually barycentric) stellar radial velocity from the standard DRP  
    gaiaedr3_parallax real NOT NULL, --/U mas --/D Gaia parallax from Gaia EDR3  
    gaiaedr3_r_lo_geo real NOT NULL, --/U pc --/D Gaia Bailer-Jones 16th GEO percentile distance r_lo from GAIA EDR3  
    chip_b_midtimes float NOT NULL, --/U s --/D Best approximation to midpoint in time for exposures used in the visit for chip b  
    dib_pixoff_disc_final_1_15273 float NOT NULL, --/U pixels --/D DIB discrete pixel offset at optimum for DIB model 1_15273  
    dib_v_rel float NOT NULL, --/U km/s --/D DIB radial velocity in observed frame (for model 2_15273)  
    gaiaedr3_r_hi_geo real NOT NULL, --/U pc --/D Gaia Bailer-Jones 84th GEO percentile distance r_hi from GAIA EDR3  
    dib_sigval_final_4_15672 float NOT NULL, --/U Å --/D DIB width sigma value at optimum for DIB model 4_15672  
    apogee_id varchar(20) NOT NULL, --/U  --/D Star identifier used by APOGEE (generally 2MASS)  
    avg_flux_conservation float NOT NULL, --/U  --/D Median fractional flux conservation of MADGICS component separation across the visit spectrum  
    dib_flag_2_15273 bigint NOT NULL, --/U  --/D Flag describing the success/failure of gridsearch fiting DIB model 2_15273. See <a href="https://github.com/andrew-saydjari/apMADGICS.jl/tree/main">https://github.com/andrew-saydjari/apMADGICS.jl/tree/main</a> for explaination of bit values.  
    dr17_teff real NOT NULL, --/U K --/D TEFF from ASPCAP allStar file for DR17  
    final_pix_cnt bigint NOT NULL, --/U  --/D Final number of unmasked pixels used for modeling the visit spectrum  
    cartvisit bigint NOT NULL, --/U  --/D Cart identifier for plate cart used during the visit observation (variations in total throughput can depend on the throughput of the fibers in a given cart)  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'minesweeper')
	DROP TABLE minesweeper
GO
--
EXEC spSetDefaultFileGroup 'minesweeper'
GO
--// Created from /uufs/chpc.utah.edu/common/home/sdss/dr19/vac/mwm/minesweeper/minesweeper_v1.0.0.fits
--// HDU 1 (178 columns x 8788 rows)
CREATE TABLE minesweeper (
-------------------------------------------------------------------------------
--/H MINESweeper parameters for halo stars from SDSS-V MWM
-------------------------------------------------------------------------------
--/T Stellar parameters for distant and metal-poor halo stars from the 
--/T SDSS-V Milky Way Mapper survey, fit using the Bayesian MINESweeper 
--/T code. Stellar parameters are estimated via a simultaneous fit to the 
--/T spectrum, photometry, and parallax, and solutions are constrained to 
--/T lie on MIST isochrones. A full description of MINESweeper is presented
--/T in Cargile et al (2020).
-------------------------------------------------------------------------------
    source_id bigint NOT NULL, --/U  --/D Gaia DR3 Source ID  
    g real NOT NULL, --/U mag --/D Gaia DR3 G magnitude  
    bp real NOT NULL, --/U mag --/D Gaia DR3 BP magnitude  
    rp real NOT NULL, --/U mag --/D Gaia DR3 RP magnitude  
    ra float NOT NULL, --/U deg --/D Gaia DR3 right ascension  
    dec float NOT NULL, --/U deg --/D Gaia DR3 declination  
    parallax float NOT NULL, --/U mas --/D Gaia DR3 parallax  
    parallax_error float NOT NULL, --/U mas --/D Gaia DR3 parallax error  
    parallax_over_error float NOT NULL, --/U  --/D Gaia DR3 parallax over error  
    pmra float NOT NULL, --/U mas/yr --/D Gaia DR3 proper motion in right ascension  
    pmdec float NOT NULL, --/U mas/yr --/D Gaia DR3 proper motion in declination  
    pmra_error float NOT NULL, --/U mas/yr --/D Uncertainty on Gaia DR3 proper motion in right ascension  
    pmdec_error float NOT NULL, --/U mas/yr --/D Uncertainty on Gaia DR3 proper motion in declination  
    bp_rp real NOT NULL, --/U mag --/D Gaia DR3 BP-RP color index  
    l float NOT NULL, --/U deg --/D Galactic longitude  
    b float NOT NULL, --/U deg --/D Galactic latitude  
    catalogid bigint NOT NULL, --/U  --/D SDSS catalog identification number  
    sdssid bigint NOT NULL, --/U  --/D SDSS object identifier  
    field bigint NOT NULL, --/U  --/D Field number for the observation  
    mjd bigint NOT NULL, --/U day --/D Mean modified Julian date of observations  
    obs varchar(10) NOT NULL, --/U  --/D Three-letter code identifying the observatory (APO or LCO)  
    n_exp bigint NOT NULL, --/U count --/D Number of individual 15-min exposures co-added  
    n_spall bigint NOT NULL, --/U count --/D Number of spAll rows co-added  
    snr real NOT NULL, --/U  --/D Median signal-to-noise ratio per pixel of the combined spectrum  
    acat_id bigint NOT NULL, --/U  --/D Internal identifier for MINESweeper catalog  
    eep float NOT NULL, --/U  --/D Equivalent evolutionary phase used in isochrone fitting  
    eep_lerr float NOT NULL, --/U  --/D Lower uncertainty on EEP  
    eep_uerr float NOT NULL, --/U  --/D Upper uncertainty on EEP  
    eep_err float NOT NULL, --/U  --/D Typical uncertainty on EEP  
    init_feh float NOT NULL, --/U dex --/D Initial stellar metallicity from isochrone fit  
    init_feh_lerr float NOT NULL, --/U dex --/D Lower error on initial [Fe/H]  
    init_feh_uerr float NOT NULL, --/U dex --/D Upper error on initial [Fe/H]  
    init_feh_err float NOT NULL, --/U dex --/D Uncertainty on initial [Fe/H]  
    init_afe float NOT NULL, --/U dex --/D Initial stellar alpha-element enhancement from isochrone fit  
    init_afe_lerr float NOT NULL, --/U dex --/D Lower error on initial [α/Fe]  
    init_afe_uerr float NOT NULL, --/U dex --/D Upper error on initial [α/Fe]  
    init_afe_err float NOT NULL, --/U dex --/D Uncertainty on initial [α/Fe]  
    init_mass float NOT NULL, --/U M_sun --/D Initial stellar mass from isochrone fit, in solar masses  
    init_mass_lerr float NOT NULL, --/U M_sun --/D Lower uncertainty on initial mass estimate  
    init_mass_uerr float NOT NULL, --/U M_sun --/D Upper uncertainty on initial mass estimate  
    init_mass_err float NOT NULL, --/U M_sun --/D Uncertainty on initial mass estimate  
    pc_0 float NOT NULL, --/U  --/D Continuum polynomial coefficient 0  
    pc_0_lerr float NOT NULL, --/U  --/D Lower error on pc_0  
    pc_0_uerr float NOT NULL, --/U  --/D Upper error on pc_0  
    pc_0_err float NOT NULL, --/U  --/D Uncertainty on pc_0  
    pc_1 float NOT NULL, --/U  --/D Continuum polynomial coefficient 1 (unitless)  
    pc_1_lerr float NOT NULL, --/U  --/D Lower error on pc_1  
    pc_1_uerr float NOT NULL, --/U  --/D Upper error on pc_1  
    pc_1_err float NOT NULL, --/U  --/D Uncertainty on pc_1  
    pc_2 float NOT NULL, --/U  --/D Continuum polynomial coefficient 2 (unitless)  
    pc_2_lerr float NOT NULL, --/U  --/D Lower error on pc_2  
    pc_2_uerr float NOT NULL, --/U  --/D Upper error on pc_2  
    pc_2_err float NOT NULL, --/U  --/D Uncertainty on pc_2  
    pc_3 float NOT NULL, --/U  --/D Continuum polynomial coefficient 3 (unitless)  
    pc_3_lerr float NOT NULL, --/U  --/D Lower error on pc_3  
    pc_3_uerr float NOT NULL, --/U  --/D Upper error on pc_3  
    pc_3_err float NOT NULL, --/U  --/D Uncertainty on pc_3  
    teff float NOT NULL, --/U K --/D Effective temperature in Kelvin  
    teff_lerr float NOT NULL, --/U K --/D Lower error on effective temperature  
    teff_uerr float NOT NULL, --/U K --/D Upper error on effective temperature  
    teff_err float NOT NULL, --/U K --/D Uncertainty on effective temperature  
    logg float NOT NULL, --/U dex --/D Logarithm (base 10) of the surface gravity in cm/s²  
    logg_lerr float NOT NULL, --/U dex --/D Lower error on logg  
    logg_uerr float NOT NULL, --/U dex --/D Upper error on logg  
    logg_err float NOT NULL, --/U dex --/D Uncertainty on logg  
    logr float NOT NULL, --/U dex --/D Logarithm of the stellar radius (in solar radii)  
    logr_lerr float NOT NULL, --/U dex --/D Lower error on logR  
    logr_uerr float NOT NULL, --/U dex --/D Upper error on logR  
    logr_err float NOT NULL, --/U dex --/D Uncertainty on logR  
    feh float NOT NULL, --/U dex --/D Metallicity measurement [Fe/H]  
    feh_lerr float NOT NULL, --/U dex --/D Lower error on present [Fe/H]  
    feh_uerr float NOT NULL, --/U dex --/D Upper error on present [Fe/H]  
    feh_err float NOT NULL, --/U dex --/D Uncertainty on present [Fe/H]  
    afe float NOT NULL, --/U dex --/D Alpha element enhancement measurement  
    afe_lerr float NOT NULL, --/U dex --/D Lower error on alpha enhancement  
    afe_uerr float NOT NULL, --/U dex --/D Upper error on alpha enhancement  
    afe_err float NOT NULL, --/U dex --/D Uncertainty on alpha enhancement  
    vrad float NOT NULL, --/U km/s --/D Radial velocity in km/s  
    vrad_lerr float NOT NULL, --/U km/s --/D Lower error on radial velocity  
    vrad_uerr float NOT NULL, --/U km/s --/D Upper error on radial velocity  
    vrad_err float NOT NULL, --/U km/s --/D Uncertainty on radial velocity  
    vrot float NOT NULL, --/U km/s --/D Projected rotational velocity  
    vrot_lerr float NOT NULL, --/U km/s --/D Lower error on Vrot  
    vrot_uerr float NOT NULL, --/U km/s --/D Upper error on Vrot  
    vrot_err float NOT NULL, --/U km/s --/D Uncertainty on Vrot  
    dist float NOT NULL, --/U kpc --/D Distance from the Sun in kiloparsecs  
    dist_lerr float NOT NULL, --/U kpc --/D Lower error on distance  
    dist_uerr float NOT NULL, --/U kpc --/D Upper error on distance  
    dist_err float NOT NULL, --/U kpc --/D Uncertainty on distance  
    av float NOT NULL, --/U mag --/D Visual V-band extinction in magnitudes  
    av_lerr float NOT NULL, --/U mag --/D Lower error on A_V  
    av_uerr float NOT NULL, --/U mag --/D Upper error on A_V  
    av_err float NOT NULL, --/U mag --/D Uncertainty on A_V  
    logage float NOT NULL, --/U log(yr) --/D Logarithm (base 10) of stellar age (years)  
    logage_lerr float NOT NULL, --/U log(yr) --/D Lower error on log stellar age  
    logage_uerr float NOT NULL, --/U log(yr) --/D Upper error on log stellar age  
    logage_err float NOT NULL, --/U log(yr) --/D Uncertainty on log stellar age  
    mass float NOT NULL, --/U M_sun --/D Current stellar mass in solar masses  
    mass_lerr float NOT NULL, --/U M_sun --/D Lower error on current mass estimate  
    mass_uerr float NOT NULL, --/U M_sun --/D Upper error on current mass estimate  
    mass_err float NOT NULL, --/U M_sun --/D Uncertainty on current mass estimate  
    logl float NOT NULL, --/U log(L/L_sun) --/D Logarithm of stellar luminosity relative to the Sun  
    logl_lerr float NOT NULL, --/U log(L/L_sun) --/D Lower error on log luminosity  
    logl_uerr float NOT NULL, --/U log(L/L_sun) --/D Upper error on log luminosity  
    logl_err float NOT NULL, --/U log(L/L_sun) --/D Uncertainty on log luminosity  
    para float NOT NULL, --/U mas --/D Fitted parallax  
    para_lerr float NOT NULL, --/U mas --/D Lower error on fitted parallax  
    para_uerr float NOT NULL, --/U mas --/D Upper error on fitted parallax  
    para_err float NOT NULL, --/U mas --/D Uncertainty on fitted parallax  
    age float NOT NULL, --/U Gyr --/D Stellar age in gigayears  
    age_lerr float NOT NULL, --/U Gyr --/D Lower error on age  
    age_uerr float NOT NULL, --/U Gyr --/D Upper error on age  
    age_err float NOT NULL, --/U Gyr --/D Uncertainty on age  
    lnz float NOT NULL, --/U  --/D Natural logarithm of the Bayesian evidence  
    lnl float NOT NULL, --/U  --/D Natural logarithm of the likelihood  
    lnp float NOT NULL, --/U  --/D Natural logarithm of the posterior probability from the fit  
    chisq_spec float NOT NULL, --/U  --/D Chi-square statistic for the spectral fit  
    nspecpix bigint NOT NULL, --/U pixels --/D Number of spectral pixels used in fitting  
    chisq_phot float NOT NULL, --/U  --/D Chi-square statistic for the photometric fit  
    nbands bigint NOT NULL, --/U bands --/D Number of photometric bands utilized  
    r_gal float NOT NULL, --/U kpc --/D Galactocentric radial distance in kiloparsecs  
    r_gal_err float NOT NULL, --/U kpc --/D Uncertainty on R_gal  
    x_gal float NOT NULL, --/U kpc --/D Galactocentric X-coordinate in kiloparsecs  
    x_gal_err float NOT NULL, --/U kpc --/D Uncertainty on X_gal  
    y_gal float NOT NULL, --/U kpc --/D Galactocentric Y-coordinate in kiloparsecs  
    y_gal_err float NOT NULL, --/U kpc --/D Uncertainty on Y_gal  
    z_gal float NOT NULL, --/U kpc --/D Galactocentric Z-coordinate in kiloparsecs  
    z_gal_err float NOT NULL, --/U kpc --/D Uncertainty on Z_gal  
    vx_gal float NOT NULL, --/U km/s --/D Galactic Cartesian velocity in X direction  
    vx_gal_err float NOT NULL, --/U km/s --/D Uncertainty on Vx_gal  
    vy_gal float NOT NULL, --/U km/s --/D Galactic Cartesian velocity in Y direction  
    vy_gal_err float NOT NULL, --/U km/s --/D Uncertainty on Vy_gal  
    vz_gal float NOT NULL, --/U km/s --/D Galactic Cartesian velocity in Z direction  
    vz_gal_err float NOT NULL, --/U km/s --/D Uncertainty on Vz_gal  
    vr_gal float NOT NULL, --/U km/s --/D Radial component of galactic velocity  
    vr_gal_err float NOT NULL, --/U km/s --/D Uncertainty on Vr_gal  
    vphi_gal float NOT NULL, --/U km/s --/D Azimuthal component of galactic velocity  
    vphi_gal_err float NOT NULL, --/U km/s --/D Uncertainty on Vphi_gal  
    vtheta_gal float NOT NULL, --/U km/s --/D Polar component of galactic velocity  
    vtheta_gal_err float NOT NULL, --/U km/s --/D Uncertainty on Vtheta_gal  
    v_tan float NOT NULL, --/U km/s --/D Tangential velocity relative to the Sun  
    v_tan_err float NOT NULL, --/U km/s --/D Uncertainty on V_tan  
    v_gsr float NOT NULL, --/U km/s --/D Velocity in the Galactic Standard of Rest frame  
    v_gsr_err float NOT NULL, --/U km/s --/D Uncertainty on V_gsr  
    lx float NOT NULL, --/U kpc km/s --/D X-component of the angular momentum  
    lx_err float NOT NULL, --/U kpc km/s --/D Uncertainty on Lx  
    ly float NOT NULL, --/U kpc km/s --/D Y-component of the angular momentum  
    ly_err float NOT NULL, --/U kpc km/s --/D Uncertainty on Ly  
    lz float NOT NULL, --/U kpc km/s --/D Z-component of the angular momentum  
    lz_err float NOT NULL, --/U kpc km/s --/D Uncertainty on Lz  
    ltot float NOT NULL, --/U kpc km/s --/D Total angular momentum magnitude  
    ltot_err float NOT NULL, --/U kpc km/s --/D Uncertainty on total angular momentum  
    e_kin_mw22 float NOT NULL, --/U km^2/s^2 --/D Kinetic energy from the MW22 potential model  
    e_kin_mw22_err float NOT NULL, --/U km^2/s^2 --/D Uncertainty on kinetic energy from the MW22 model  
    e_pot_mw22 float NOT NULL, --/U km^2/s^2 --/D Potential energy from the MW22 potential model  
    e_pot_mw22_err float NOT NULL, --/U km^2/s^2 --/D Uncertainty on potential energy from the MW22 model  
    e_tot_mw22 float NOT NULL, --/U km^2/s^2 --/D Total energy from the MW22 potential model  
    e_tot_mw22_err float NOT NULL, --/U km^2/s^2 --/D Uncertainty on total energy from the MW22 model  
    ecc_mw22 float NOT NULL, --/U  --/D Orbital eccentricity from the MW22 model  
    ecc_mw22_err float NOT NULL, --/U  --/D Uncertainty on the orbital eccentricity  
    r_apo_mw22 float NOT NULL, --/U kpc --/D Apocentric radius from MW22 orbit integration  
    r_apo_mw22_err float NOT NULL, --/U kpc --/D Uncertainty on the apocenter distance  
    r_peri_mw22 float NOT NULL, --/U kpc --/D Pericentric radius from MW22 orbit integration  
    r_peri_mw22_err float NOT NULL, --/U kpc --/D Uncertainty on the pericenter distance  
    z_max_mw22 float NOT NULL, --/U kpc --/D Maximum vertical height reached in MW22 orbit integration  
    z_max_mw22_err float NOT NULL, --/U kpc --/D Uncertainty on the maximum vertical height  
    flag bigint NOT NULL, --/U  --/D Data quality flag from MINESweeper fit (FLAG==0 selects clean data)  
    sgr_l float NOT NULL, --/U deg --/D Sagittarius stream coordinate (longitude)  
    sgr_b float NOT NULL, --/U deg --/D Sagittarius stream coordinate (latitude)  
    in_sgr_l bit NOT NULL, --/U  --/D Flag indicating association with the Sagittarius Stream based on angular momentum  
    in_substructure bit NOT NULL, --/U  --/D Flag indicating membership in a known halo substructure  
    in_cluster bit NOT NULL, --/U  --/D Flag indicating membership in a calibration cluster  
    cluster varchar(10) NOT NULL, --/U  --/D Identifier for the cluster if membership is determined, otherwise n/a  
    kg_near bit NOT NULL, --/U  --/D Flag indicating membership in 10-30 kpc K giant target class  
    kg_far bit NOT NULL, --/U  --/D Flag indicating membership in >30 kpc K giant target class  
    xp_vmp bit NOT NULL, --/U  --/D Flag indicating membership in very metal-poor (VMP) target class based on Gaia XP  
    xp_mp bit NOT NULL, --/U  --/D Flag indicating membership in metal-poor (MP) target class based on Gaia XP  
    bb_mp bit NOT NULL, --/U  --/D Flag indicating membership in metal-poor (MP) target class based on IR colors ('best and brightest')  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mwm_mdwarf_abundances')
	DROP TABLE mwm_mdwarf_abundances
GO
--
EXEC spSetDefaultFileGroup 'mwm_mdwarf_abundances'
GO
CREATE TABLE mwm_mdwarf_abundances (
-------------------------------------------------------------------------------
--/H Elemental abundances for ~17,000 M dwarfs in MWM.
-------------------------------------------------------------------------------
--/T Catalog of detailed elemental abundances for ~17,000 M dwarfs in MWM (Behmard et al. 2025, Table 2).
-------------------------------------------------------------------------------
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    [name] bigint NOT NULL, --/U  --/D SDSS ID  
    teff_cannon float NOT NULL, --/U Kelvin --/D M dwarf temperature  
    fe_h_cannon float NOT NULL, --/U dex --/D M dwarf [Fe/H]  
    mg_h_cannon float NOT NULL, --/U dex --/D M dwarf [Mg/H]  
    al_h_cannon float NOT NULL, --/U dex --/D M dwarf [Al/H]  
    si_h_cannon float NOT NULL, --/U dex --/D M dwarf [Si/H]  
    c_h_cannon float NOT NULL, --/U dex --/D M dwarf [C/H]  
    o_h_cannon float NOT NULL, --/U dex --/D M dwarf [O/H]  
    ca_h_cannon float NOT NULL, --/U dex --/D M dwarf [Ca/H]  
    ti_h_cannon float NOT NULL, --/U dex --/D M dwarf [Ti/H]  
    cr_h_cannon float NOT NULL, --/U dex --/D M dwarf [Cr/H]  
    n_h_cannon float NOT NULL, --/U dex --/D M dwarf [N/H]  
    ni_h_cannon float NOT NULL, --/U dex --/D M dwarf [Ni/H]  
    spec_chisq float NOT NULL, --/U  --/D Model-data spectral fit chi-squared  
    temp_agree bit NOT NULL, --/U  --/D flag describing whether the photometric and The Cannon–inferred Teff agree to within 2σ  
    teff_err float NOT NULL, --/U Kelvin --/D M dwarf temperature uncertainties  
    fe_h_err float NOT NULL, --/U dex --/D M dwarf [Fe/H] uncertainties  
    mg_h_err float NOT NULL, --/U dex --/D M dwarf [Mg/H] uncertainties  
    al_h_err float NOT NULL, --/U dex --/D M dwarf [Al/H] uncertainties  
    si_h_err float NOT NULL, --/U dex --/D M dwarf [Si/H] uncertainties  
    c_h_err float NOT NULL, --/U dex --/D M dwarf [C/H] uncertainties  
    o_h_err float NOT NULL, --/U dex --/D M dwarf [O/H] uncertainties  
    ca_h_err float NOT NULL, --/U dex --/D M dwarf [Ca/H] uncertainties  
    ti_h_err float NOT NULL, --/U dex --/D M dwarf [Ti/H] uncertainties  
    cr_h_err float NOT NULL, --/U dex --/D M dwarf [Cr/H] uncertainties  
    n_h_err float NOT NULL, --/U dex --/D M dwarf [N/H] uncertainties  
    ni_h_err float NOT NULL, --/U dex --/D M dwarf [Ni/H] uncertainties  
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'MWM_WD_SDSSV_DA_df')
	DROP TABLE MWM_WD_SDSSV_DA_df
GO
--
EXEC spSetDefaultFileGroup 'MWM_WD_SDSSV_DA_df'
GO
CREATE TABLE MWM_WD_SDSSV_DA_df (
-------------------------------------------------------------------------------
--/H Measurements of physical parameters for DA white dwarfs observed in 
--/H SDSS Data Release 19.
-------------------------------------------------------------------------------
--/T Measurements of radial velocities, spectroscopic effective temperatures
--/T and surface gravities, and photometric effective temperatures and radii
--/T for 8,545 unique DA white dwarfs observed in SDSS Data Release 19.
-------------------------------------------------------------------------------
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    fieldid bigint NOT NULL, --/U  --/D Field identifier  
    mjd bigint NOT NULL, --/U  --/D Modified Julian date of observation  
    catalogid bigint NOT NULL, --/U  --/D SDSS-V catalog identifier  
    snr float NOT NULL, --/U  --/D Spectrum signal-to-noise ratio  
    p_da float NOT NULL, --/U  --/D SnowWhite DA-type white dwarf probability  
    ra float NOT NULL, --/U deg --/D Right ascension  
    dec float NOT NULL, --/U deg --/D Declination  
    l float NOT NULL, --/U deg --/D Galactic longitude  
    b float NOT NULL, --/U deg --/D Galactic latitude  
    r_med_geo float NOT NULL, --/U pc --/D Median geometric distance from Bailer-Jones et al. (2021)  
    r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance from Bailer-Jones et al. (2021)  
    r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance from Bailer-Jones et al. (2021)  
    pmra float NOT NULL, --/U mas/yr --/D Proper motion in ra  
    pmra_error float NOT NULL, --/U mas/yr --/D Error on proper motion in ra  
    pmdec float NOT NULL, --/U mas/yr --/D Proper motion in dec  
    pmdec_error float NOT NULL, --/U mas/yr --/D Error on proper motion in dec  
    phot_g_mean_flux float NOT NULL, --/U e-/s --/D Gaia G-band mean flux  
    phot_g_mean_flux_error float NOT NULL, --/U e-/s --/D Error on G-band mean flux  
    phot_g_mean_mag float NOT NULL, --/U mag --/D Gaia G-band mean magnitude on Vega scale  
    phot_bp_mean_flux float NOT NULL, --/U e-/s --/D Gaia BP-band mean flux  
    phot_bp_mean_flux_error float NOT NULL, --/U e-/s --/D Error on BP-band mean flux  
    phot_bp_mean_mag float NOT NULL, --/U mag --/D Gaia BP-band mean magnitude on Vega scale  
    phot_rp_mean_flux float NOT NULL, --/U e-/s --/D Gaia RP-band mean flux  
    phot_rp_mean_flux_error float NOT NULL, --/U e-/s --/D Error on RP-band mean flux  
    phot_rp_mean_mag float NOT NULL, --/U mag --/D Gaia RP-band mean magnitude on Vega scale  
    phot_bp_rp_excess_factor float NOT NULL, --/U  --/D Excess flux in Gaia BP/RP photometry relative to G band  
    no_gaia_phot bit NOT NULL, --/U  --/D Flag indicating if WD lacks Gaia BP or RP mean fluxes  
    clean real NOT NULL, --/U  --/D SDSS clean photometry flag (1=clean, 0=unclean) 
    psf_mag_u float NOT NULL, --/U mag --/D SDSS PSF u-band magnitude on the SDSS scale  
    psf_mag_g float NOT NULL, --/U mag --/D SDSS PSF g-band magnitude on the SDSS scale  
    psf_mag_r float NOT NULL, --/U mag --/D SDSS PSF r-band magnitude on the SDSS scale  
    psf_mag_i float NOT NULL, --/U mag --/D SDSS PSF i-band magnitude on the SDSS scale  
    psf_mag_z float NOT NULL, --/U mag --/D SDSS PSF z-band magnitude on the SDSS scale  
    psf_magerr_u float NOT NULL, --/U mag --/D Error on SDSS PSF u-band magnitude on the SDSS scale  
    psf_magerr_g float NOT NULL, --/U mag --/D Error on SDSS PSF g-band magnitude on the SDSS scale  
    psf_magerr_r float NOT NULL, --/U mag --/D Error on SDSS PSF r-band magnitude on the SDSS scale  
    psf_magerr_i float NOT NULL, --/U mag --/D Error on SDSS PSF i-band magnitude on the SDSS scale  
    psf_magerr_z float NOT NULL, --/U mag --/D Error on SDSS PSF z-band magnitude on the SDSS scale  
    psf_flux_u float NOT NULL, --/U nanomaggies --/D SDSS PSF u-band flux  
    psf_flux_g float NOT NULL, --/U nanomaggies --/D SDSS PSF g-band flux  
    psf_flux_r float NOT NULL, --/U nanomaggies --/D SDSS PSF r-band flux  
    psf_flux_i float NOT NULL, --/U nanomaggies --/D SDSS PSF i-band flux  
    psf_flux_z float NOT NULL, --/U nanomaggies --/D SDSS PSF z-band flux  
    psf_fluxivar_u float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF u-band flux  
    psf_fluxivar_g float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF g-band flux  
    psf_fluxivar_r float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF r-band flux  
    psf_fluxivar_i float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF i-band flux  
    psf_fluxivar_z float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF z-band flux  
    mag_ab_u float NOT NULL, --/U mag --/D SDSS PSF u-band magnitude on the AB scale  
    magerr_ab_u float NOT NULL, --/U mag --/D Error on SDSS PSF u-band magnitude on the AB scale  
    mag_ab_g float NOT NULL, --/U mag --/D SDSS PSF g-band magnitude on the AB scale  
    magerr_ab_g float NOT NULL, --/U mag --/D Error on SDSS PSF g-band magnitude on the AB scale  
    mag_ab_r float NOT NULL, --/U mag --/D SDSS PSF r-band magnitude on the AB scale  
    magerr_ab_r float NOT NULL, --/U mag --/D Error on SDSS PSF r-band magnitude on the AB scale  
    mag_ab_i float NOT NULL, --/U mag --/D SDSS PSF i-band magnitude on the AB scale  
    magerr_ab_i float NOT NULL, --/U mag --/D Error on SDSS PSF i-band magnitude on the AB scale  
    mag_ab_z float NOT NULL, --/U mag --/D SDSS PSF z-band magnitude on the AB scale  
    magerr_ab_z float NOT NULL, --/U mag --/D Error on SDSS PSF z-band magnitude on the AB scale  
    no_sdss_phot bit NOT NULL, --/U  --/D Flag indicating if WD lacks or has non-physical SDSS u, r, or z magnitudes on the AB scale  
    rv_falcon float NOT NULL, --/U km/s --/D WD radial velocity in cross-matched Falcon et al. (2010) catalog  
    e_rv_falcon float NOT NULL, --/U km/s --/D Error on WD radial velocity in cross-matched Falcon et al. (2010) catalog  
    falcon_flag bit NOT NULL, --/U  --/D Flag indicating whether WD is contained in cross-matched Falcon et al. (2010) catalog  
    logg_raddi float NOT NULL, --/U  --/D WD surface gravity in cross-matched Raddi et al. (2022) catalog  
    e_logg_raddi float NOT NULL, --/U  --/D Error on WD surface gravity in cross-matched Raddi et al. (2022) catalog  
    mass_raddi float NOT NULL, --/U Msun --/D WD mass in cross-matched Raddi et al. (2022) catalog  
    e_mass_raddi float NOT NULL, --/U Msun --/D Error on WD mass in cross-matched Raddi et al. (2022) catalog  
    radius_raddi float NOT NULL, --/U Rsun --/D WD radius in cross-matched Raddi et al. (2022) catalog  
    rv_raddi float NOT NULL, --/U km/s --/D WD radial velocity in cross-matched Raddi et al. (2022) catalog  
    e_rv_raddi float NOT NULL, --/U km/s --/D Error on WD radial velocity in cross-matched Raddi et al. (2022) catalog  
    teff_raddi float NOT NULL, --/U K --/D WD effective temperature in cross-matched Raddi et al. (2022) catalog  
    e_teff_raddi float NOT NULL, --/U K --/D Error on WD effective temperature in cross-matched Raddi et al. (2022) catalog  
    e_radius_raddi float NOT NULL, --/U Rsun --/D Error on WD radius in cross-matched Raddi et al. (2022) catalog  
    raddi_flag bit NOT NULL, --/U  --/D Flag indicating whether WD is contained in cross-matched Raddi et al. (2022) catalog  
    teff_anguiano float NOT NULL, --/U K --/D WD effective temperature in cross-matched Anguiano et al. (2017) catalog  
    e_teff_anguiano float NOT NULL, --/U K --/D Error on WD effective temperature in cross-matched Anguiano et al. (2017) catalog  
    mass_anguiano float NOT NULL, --/U Msun --/D WD mass in cross-matched Anguiano et al. (2017) catalog  
    e_mass_anguiano float NOT NULL, --/U Msun --/D Error on WD mass in cross-matched Anguiano et al. (2017) catalog  
    logg_anguiano float NOT NULL, --/U  --/D WD surface gravity in cross-matched Anguiano et al. (2017) catalog  
    e_logg_anguiano float NOT NULL, --/U  --/D Error on WD surface gravity in cross-matched Anguiano et al. (2017) catalog  
    rv_anguiano float NOT NULL, --/U km/s --/D WD radial velocity in cross-matched Anguiano et al. (2017) catalog  
    e_rv_anguiano float NOT NULL, --/U km/s --/D Error on WD radial velocity in cross-matched Anguiano et al. (2017) catalog  
    radius_anguiano float NOT NULL, --/U Rsun --/D WD radius in cross-matched Anguiano et al. (2017) catalog  
    e_radius_anguiano float NOT NULL, --/U Rsun --/D Error on WD radius in cross-matched Anguiano et al. (2017) catalog  
    anguiano_flag bit NOT NULL, --/U  --/D Flag indicating whether WD is contained in cross-matched Anguiano et al. (2017) catalog  
    teff_gentile float NOT NULL, --/U K --/D WD effective temperature in cross-matched Gentile Fusillo et al. (2021) catalog  
    e_teff_gentile float NOT NULL, --/U K --/D Error on WD effective temperature in cross-matched Gentile Fusillo et al. (2021) catalog  
    logg_gentile float NOT NULL, --/U  --/D WD surface gravity in cross-matched Gentile Fusillo et al. (2021) catalog  
    e_logg_gentile float NOT NULL, --/U  --/D Error on WD surface gravity in cross-matched Gentile Fusillo et al. (2021) catalog  
    mass_gentile float NOT NULL, --/U Msun --/D WD mass in cross-matched Gentile Fusillo et al. (2021) catalog  
    e_mass_gentile float NOT NULL, --/U Msun --/D Error on WD mass in cross-matched Gentile Fusillo et al. (2021) catalog  
    radius_gentile float NOT NULL, --/U Rsun --/D WD radius in cross-matched Gentile Fusillo et al. (2021) catalog  
    e_radius_gentile float NOT NULL, --/U Rsun --/D Error on WD radius in cross-matched Gentile Fusillo et al. (2021) catalog  
    gentile_flag bit NOT NULL, --/U  --/D Flag indicating whether WD is contained in cross-matched Gentile Fusillo et al. (2021) catalog  
    teff_koester float NOT NULL, --/U K --/D WD effective temperature in cross-matched Koester et al. (2009) catalog  
    e_teff_koester float NOT NULL, --/U K --/D Error on WD effective temperature in cross-matched Koester et al. (2009) catalog  
    logg_koester float NOT NULL, --/U  --/D WD surface gravity in cross-matched Koester et al. (2009) catalog  
    e_logg_koester float NOT NULL, --/U  --/D Error on WD surface gravity in cross-matched Koester et al. (2009) catalog  
    koester_flag bit NOT NULL, --/U  --/D Flag indicating whether WD is contained in cross-matched Koester et al. (2009) catalog  
    teff_kepler float NOT NULL, --/U K --/D WD effective temperature in cross-matched Kepler et al. (2019) catalog  
    e_teff_kepler float NOT NULL, --/U K --/D Error on WD effective temperature in cross-matched Kepler et al. (2019) catalog  
    logg_kepler float NOT NULL, --/U  --/D WD surface gravity in cross-matched Kepler et al. (2019) catalog  
    e_logg_kepler float NOT NULL, --/U  --/D Error on WD surface gravity in cross-matched Kepler et al. (2019) catalog  
    rv_kepler float NOT NULL, --/U km/s --/D WD radial velocity in cross-matched Kepler et al. (2019) catalog  
    e_rv_kepler float NOT NULL, --/U km/s --/D Error on WD radial velocity in cross-matched Kepler et al. (2019) catalog  
    mass_kepler float NOT NULL, --/U Msun --/D WD mass in cross-matched Kepler et al. (2019) catalog  
    e_mass_kepler float NOT NULL, --/U Msun --/D Error on WD mass in cross-matched Kepler et al. (2019) catalog  
    radius_kepler float NOT NULL, --/U Rsun --/D WD radius in cross-matched Kepler et al. (2019) catalog  
    e_radius_kepler float NOT NULL, --/U Rsun --/D Error on WD radius in cross-matched Kepler et al. (2019) catalog  
    kepler_flag bit NOT NULL, --/U  --/D Flag indicating whether WD is contained in cross-matched Kepler et al. (2019) catalog  
    snr_coadd float NOT NULL, --/U  --/D Coadded spectrum signal-to-noise ratio  
    nspec_coadd float NOT NULL, --/U  --/D Number of field-mjd-catalogid spectra corresponding to unique Gaia DR3 source ID, all spectra are coadded to create 1 spectrum per WD  
    rv_corv_ind float NOT NULL, --/U km/s --/D Radial velocity measured from each individual spectrum  
    e_rv_corv_ind float NOT NULL, --/U km/s --/D Error on radial velocity measured from each individual spectrum  
    teff_corv_ind float NOT NULL, --/U K --/D corv effective temperature measured from each individual spectrum  
    logg_corv_ind float NOT NULL, --/U  --/D corv surface gravity measured from each individual spectrum  
    rv_corv_coadd float NOT NULL, --/U km/s --/D Radial velocity measured from each WD coadded spectrum  
    e_rv_corv_coadd float NOT NULL, --/U km/s --/D Error on radial velocity measured from each WD coadded spectrum  
    teff_corv_coadd float NOT NULL, --/U K --/D corv effective temperature measured from each WD coadded spectrum  
    logg_corv_coadd float NOT NULL, --/U  --/D corv surface gravity measured from each WD coadded spectrum  
    e_rv_corv_ind_full float NOT NULL, --/U km/s --/D Full error (measured+systematic) on the radial velocity measured from each individual spectrum  
    e_rv_corv_coadd_full float NOT NULL, --/U km/s --/D Full error (measured+systematic) on the radial velocity measured from each WD coadded spectrum  
    rv_corv_mean float NOT NULL, --/U km/s --/D Radial velocity measured from taking the weighted mean of all high SNR individual spectrum radial velocities  
    e_rv_corv_mean float NOT NULL, --/U km/s --/D Error on radial velocity measured from taking the weighted mean of all high SNR individual spectrum radial velocities  
    nspec_mean_rv_corv float NOT NULL, --/U  --/D Number of high SNR spectra used to calculate weighted mean radial velocity  
    teff_prf_ind float NOT NULL, --/U K --/D Effective temperature measured from each individual spectrum  
    e_teff_prf_ind float NOT NULL, --/U K --/D Error on effective temperature measured from each individual spectrum  
    logg_prf_ind float NOT NULL, --/U  --/D Surface gravity measured from each individual spectrum  
    e_logg_prf_ind float NOT NULL, --/U  --/D Error on surface gravity measured from each individual spectrum  
    teff_prf_coadd float NOT NULL, --/U K --/D Effective temperature measured from each WD coadded spectrum  
    e_teff_prf_coadd float NOT NULL, --/U K --/D Error on effective temperature measured from each WD coadded spectrum  
    logg_prf_coadd float NOT NULL, --/U  --/D Surface gravity measured from each WD coadded spectrum  
    e_logg_prf_coadd float NOT NULL, --/U  --/D Error on surface gravity measured from each WD coadded spectrum  
    e_teff_prf_ind_full float NOT NULL, --/U K --/D Full error (measured+systematic) on the effective temperature from each individual spectrum  
    e_logg_prf_ind_full float NOT NULL, --/U  --/D Full error (measured+systematic) on the surface gravity from each individual spectrum  
    e_teff_prf_coadd_full float NOT NULL, --/U K --/D Full error (measured+systematic) on the effective temperature from each WD coadded spectrum  
    e_logg_prf_coadd_full float NOT NULL, --/U  --/D Full error (measured+systematic) on the surface gravity from each WD coadded spectrum  
    teff_prf_mean float NOT NULL, --/U K --/D Effective temperature measured from taking the weighted mean of all high SNR individual spectrum effective temperatures  
    e_teff_prf_mean float NOT NULL, --/U K --/D Effective temperature measured from taking the weighted mean of all high SNR individual spectrum effective temperatures  
    logg_prf_mean float NOT NULL, --/U  --/D Surface gravity measured from taking the weighted mean of all high SNR individual spectrum surface gravities  
    e_logg_prf_mean float NOT NULL, --/U  --/D Error on surface gravity measured from taking the weighted mean of all high SNR individual spectrum surface gravities  
    nspec_mean_teff float NOT NULL, --/U  --/D Number of high SNR spectra used to calculate weighted mean effective temperature  
    nspec_mean_logg float NOT NULL, --/U  --/D Number of high SNR spectra used to calculate weighted mean surface gravity  
    av_lo float NOT NULL, --/U mag --/D Total extinction in Johnson–Cousins V-band at lo geometric distance  
    u_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS u-band at lo geometric distance  
    g_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS g-band at lo geometric distance  
    r_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS r-band at lo geometric distance  
    i_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS i-band at lo geometric distance  
    z_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS z-band at lo geometric distance  
    gaia_g_ext_lo float NOT NULL, --/U mag --/D Total extinction in Gaia G-band at lo geometric distance  
    gaia_bp_ext_lo float NOT NULL, --/U mag --/D Total extinction in Gaia BP-band at lo geometric distance  
    gaia_rp_ext_lo float NOT NULL, --/U mag --/D Total extinction in Gaia RP-band at lo geometric distance  
    u_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS u-band magnitude at lo geometric distance  
    g_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS g-band magnitude at lo geometric distance  
    r_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS r-band magnitude at lo geometric distance  
    i_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS i-band magnitude at lo geometric distance  
    z_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS z-band magnitude at lo geometric distance  
    gaia_g_dered_lo float NOT NULL, --/U mag --/D Dereddened Gaia G-band magnitude at lo geometric distance  
    gaia_bp_dered_lo float NOT NULL, --/U mag --/D Dereddened Gaia BP-band magnitude at lo geometric distance  
    gaia_rp_dered_lo float NOT NULL, --/U mag --/D Dereddened Gaia RP-band magnitude at lo geometric distance  
    av_med float NOT NULL, --/U mag --/D Total extinction in Johnson–Cousins V-band at med geometric distance  
    u_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS u-band at med geometric distance  
    g_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS g-band at med geometric distance  
    r_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS r-band at med geometric distance  
    i_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS i-band at med geometric distance  
    z_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS z-band at med geometric distance  
    gaia_g_ext_med float NOT NULL, --/U mag --/D Total extinction in Gaia G-band at med geometric distance  
    gaia_bp_ext_med float NOT NULL, --/U mag --/D Total extinction in Gaia BP-band at med geometric distance  
    gaia_rp_ext_med float NOT NULL, --/U mag --/D Total extinction in Gaia RP-band at med geometric distance  
    u_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS u-band magnitude at med geometric distance  
    g_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS g-band magnitude at med geometric distance  
    r_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS r-band magnitude at med geometric distance  
    i_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS i-band magnitude at med geometric distance  
    z_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS z-band magnitude at med geometric distance  
    gaia_g_dered_med float NOT NULL, --/U mag --/D Dereddened Gaia G-band magnitude at med geometric distance  
    gaia_bp_dered_med float NOT NULL, --/U mag --/D Dereddened Gaia BP-band magnitude at med geometric distance  
    gaia_rp_dered_med float NOT NULL, --/U mag --/D Dereddened Gaia RP-band magnitude at med geometric distance  
    av_hi float NOT NULL, --/U mag --/D Total extinction in Johnson–Cousins V-band at hi geometric distance  
    u_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS u-band at hi geometric distance  
    g_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS g-band at hi geometric distance  
    r_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS r-band at hi geometric distance  
    i_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS i-band at hi geometric distance  
    z_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS z-band at hi geometric distance  
    gaia_g_ext_hi float NOT NULL, --/U mag --/D Total extinction in Gaia G-band at hi geometric distance  
    gaia_bp_ext_hi float NOT NULL, --/U mag --/D Total extinction in Gaia BP-band at hi geometric distance  
    gaia_rp_ext_hi float NOT NULL, --/U mag --/D Total extinction in Gaia RP-band at hi geometric distance  
    u_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS u-band magnitude at hi geometric distance  
    g_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS g-band magnitude at hi geometric distance  
    r_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS r-band magnitude at hi geometric distance  
    i_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS i-band magnitude at hi geometric distance  
    z_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS z-band magnitude at hi geometric distance  
    gaia_g_dered_hi float NOT NULL, --/U mag --/D Dereddened Gaia G-band magnitude at hi geometric distance  
    gaia_bp_dered_hi float NOT NULL, --/U mag --/D Dereddened Gaia BP-band magnitude at hi geometric distance  
    gaia_rp_dered_hi float NOT NULL, --/U mag --/D Dereddened Gaia RP-band magnitude at hi geometric distance  
    phot_used bigint NOT NULL, --/U  --/D Flag indicating whether SDSS or Gaia photometry was used to fit WD parameters (1=SDSS, 2=Gaia)  
    phot_radius_sdss_lo float NOT NULL, --/U Rsun --/D Photometric radius measured at geometric distance with SDSS photometry  
    e_phot_radius_sdss_lo float NOT NULL, --/U Rsun --/D Error on photometric radius measured at geometric distance with SDSS photometry  
    phot_teff_sdss_lo float NOT NULL, --/U K --/D Photometric effective temperature measured at lo geometric distance with SDSS photometry  
    e_phot_teff_sdss_lo float NOT NULL, --/U K --/D Error on photometric effective temperature measured at lo geometric distance with SDSS photometry  
    phot_redchi_sdss_lo float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_gaia_lo float NOT NULL, --/U Rsun --/D Photometric radius measured at lo geometric distance with Gaia photometry  
    e_phot_radius_gaia_lo float NOT NULL, --/U Rsun --/D Error on photometric radius measured at lo geometric distance with Gaia photometry  
    phot_teff_gaia_lo float NOT NULL, --/U K --/D Photometric effective temperature measured at lo geometric distance with Gaia photometry  
    e_phot_teff_gaia_lo float NOT NULL, --/U K --/D Error on photometric effective temperature measured at lo geometric distance with Gaia photometry  
    phot_redchi_gaia_lo float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_sdss_med float NOT NULL, --/U Rsun --/D Photometric radius measured at med geometric distance with SDSS photometry  
    e_phot_radius_sdss_med float NOT NULL, --/U Rsun --/D Error on photometric radius measured at med geometric distance with SDSS photometry  
    phot_teff_sdss_med float NOT NULL, --/U K --/D Photometric effective temperature measured at med geometric distance with SDSS photometry  
    e_phot_teff_sdss_med float NOT NULL, --/U K --/D Error on photometric effective temperature measured at med geometric distance with SDSS photometry  
    phot_redchi_sdss_med float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_gaia_med float NOT NULL, --/U Rsun --/D Photometric radius measured at med geometric distance with Gaia photometry  
    e_phot_radius_gaia_med float NOT NULL, --/U Rsun --/D Error on photometric radius measured at med geometric distance with Gaia photometry  
    phot_teff_gaia_med float NOT NULL, --/U K --/D Photometric effective temperature measured at med geometric distance with Gaia photometry  
    e_phot_teff_gaia_med float NOT NULL, --/U K --/D Error on photometric effective temperature measured at med geometric distance with Gaia photometry  
    phot_redchi_gaia_med float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_sdss_hi float NOT NULL, --/U Rsun --/D Photometric radius measured at hi geometric distance with SDSS photometry  
    e_phot_radius_sdss_hi float NOT NULL, --/U Rsun --/D Error on photometric radius measured at hi geometric distance with SDSS photometry  
    phot_teff_sdss_hi float NOT NULL, --/U K --/D Photometric effective temperature measured at hi geometric distance with SDSS photometry  
    e_phot_teff_sdss_hi float NOT NULL, --/U K --/D Error on photometric effective temperature measured at hi geometric distance with SDSS photometry  
    phot_redchi_sdss_hi float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_gaia_hi float NOT NULL, --/U Rsun --/D Photometric radius measured at hi geometric distance with Gaia photometry  
    e_phot_radius_gaia_hi float NOT NULL, --/U Rsun --/D Error on photometric radius measured at hi geometric distance with Gaia photometry  
    phot_teff_gaia_hi float NOT NULL, --/U K --/D Photometric effective temperature measured at hi geometric distance with Gaia photometry  
    e_phot_teff_gaia_hi float NOT NULL, --/U K --/D Error on photometric effective temperature measured at hi geometric distance with Gaia photometry  
    phot_redchi_gaia_hi float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_logg_sdss_lo float NOT NULL, --/U  --/D Photometric surface gravity measured at lo geometric distance with SDSS photometry  
    e_phot_logg_sdss_lo float NOT NULL, --/U  --/D Error on photometric surface gravity measured at lo geometric distance with SDSS photometry  
    sdss_logg_flag_lo bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    gaia_logg_flag_lo bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    phot_logg_sdss_med float NOT NULL, --/U  --/D Photometric surface gravity measured at med geometric distance with SDSS photometry  
    e_phot_logg_sdss_med float NOT NULL, --/U  --/D Error on photometric surface gravity measured at med geometric distance with SDSS photometry  
    sdss_logg_flag_med bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    gaia_logg_flag_med bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    phot_logg_sdss_hi float NOT NULL, --/U  --/D Photometric surface gravity measured at hi geometric distance with SDSS photometry  
    e_phot_logg_sdss_hi float NOT NULL, --/U  --/D Error on photometric surface gravity measured at hi geometric distance with SDSS photometry  
    sdss_logg_flag_hi bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    gaia_logg_flag_hi bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    radius_phot_sdss float NOT NULL, --/U Rsun --/D Final SDSS photometric radius measurement, taken to be the value at the median geometric distance  
    e_radius_phot_sdss float NOT NULL, --/U Rsun --/D Error (measured+distance uncertainty) on the final SDSS photometric radius  
    radius_phot_gaia float NOT NULL, --/U Rsun --/D Final Gaia photometric radius measurement, taken to be the value at the median geometric distance  
    e_radius_phot_gaia float NOT NULL, --/U Rsun --/D Error (measured+distance uncertainty) on the final Gaia photometric radius  
    teff_phot_sdss float NOT NULL, --/U K --/D Final SDSS photometric effective temperature measurement, taken to be the value at the median geometric distance  
    e_teff_phot_sdss float NOT NULL, --/U K --/D Error (measured+distance uncertainty) on the final SDSS photometric effective temperature  
    teff_phot_gaia float NOT NULL, --/U K --/D Final Gaia photometric effective temperature measurement, taken to be the value at the median geometric distance  
    e_teff_phot_gaia float NOT NULL, --/U K --/D Error (measured+distance uncertainty) on the final Gaia photometric effective temperature  
    phot_err_sdss float NOT NULL, --/U mag --/D Mean SDSS u, r, and z-band magnitude error  
    phot_err_gaia float NOT NULL, --/U e-/s --/D Mean Gaia BP and RP flux error  
    radius_phot float NOT NULL, --/U Rsun --/D Final photometric radius measurement, prioritizing SDSS photometry, taken to be the value at the median geometric distance  
    e_radius_phot float NOT NULL, --/U Rsun --/D Error (measured+distance uncertainty) on the final photometric radius  
    teff_phot float NOT NULL, --/U K --/D Final photometric effective temperature measurement, prioritizing SDSS photometry, taken to be the value at the median geometric distance  
    e_teff_phot float NOT NULL, --/U K --/D Error (measured+distance uncertainty) on the final photometric effective temperature  
    e_radius_phot_full float NOT NULL, --/U Rsun --/D Full error (measured+distance uncertainty+systematic) on the final radius  
    e_teff_phot_full float NOT NULL, --/U K --/D Full error (measured+distance uncertainty+systematic) on the final effective temperature  
    mass_rad_logg float NOT NULL, --/U Msun --/D Mass measured from coadded spectrum surface gravity and final photometric radius  
    e_mass_rad_logg float NOT NULL, --/U Msun --/D Error on mass from surface gravity and radius  
    mass_logg_theory float NOT NULL, --/U Msun --/D Mass measured from coadded spectrum surface gravity and effective temperature, combined with La Plata models  
    e_mass_logg_theory float NOT NULL, --/U Msun --/D Error on mass measured from surface gravity and theory  
    mass_rad_theory float NOT NULL, --/U Msun --/D Mass measured from final photometric radius and effective temperature, combined with La Plata models  
    e_mass_rad_theory float NOT NULL, --/U Msun --/D Error on mass measured from radius and theory  
    rv_corv_lsr float NOT NULL, --/U km/s --/D Measured coadded spectrum radial velocity, corrected to the LSR  
    rv_corv_asym_corr float NOT NULL, --/U km/s --/D Measured coadded spectrum radial velocity, corrected to the LSR and for asymmetric drift, only for WDs used in the Crumpler et. al temperature dependence detection  
    asym_corr float NOT NULL, --/U km/s --/D Applied asymmetric drift correction, only for WDs used in the Crumpler et. al temperature dependence detection  
    tempdep_catalog_flag bit NOT NULL, --/U  --/D Flag indicating whether WD was used in the Crumpler et. al temperature dependence detection  
    eta float NOT NULL, --/U  --/D Logarithm of the probability that the observed apparent radial velocity variation is random noise  
    ruwe float NOT NULL, --/U  --/D Gaia Renormalised Unit Weight Error (RUWE)  
    binary_flag float NOT NULL, --/U  --/D Flag indicating whether the WD is a potential binary, 0= No evidence for binarity, 1= Evidence for binarity from apparent radial velocity variation, 2= Evidence for binarity from Gaia RUWE, 3= Evidence for binarity from both apparent radial velocity variation and RUWE  
    speed_lsr float NOT NULL, --/U km/s --/D WD total speed relative to the LSR  
    thin_disk_flag tinyint NOT NULL, --/U  --/D Flag indicating whether WD likely belongs to thin disk  
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'MWM_WD_eSDSS_DA_df')
	DROP TABLE MWM_WD_eSDSS_DA_df
GO
--
EXEC spSetDefaultFileGroup 'MWM_WD_eSDSS_DA_df'
GO
CREATE TABLE MWM_WD_eSDSS_DA_df (
-------------------------------------------------------------------------------
--/H Measurements of physical parameters for DA white dwarfs observed in SDSS 
--/H Data Releases 1 through 16. 
-------------------------------------------------------------------------------
--/T Measurements of radial velocities, spectroscopic effective temperatures
--/T and surface gravities, and photometric effective temperatures and radii
--/T for 19,257 unique DA white dwarfs observed in SDSS Data Releases 1 
--/T through 16.
-------------------------------------------------------------------------------
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    plate bigint NOT NULL, --/U  --/D SDSS plate identifier  
    mjd bigint NOT NULL, --/U  --/D Modified Julian date of observation  
    fiber bigint NOT NULL, --/U  --/D SDSS fiber identifier  
    snr float NOT NULL, --/U  --/D Spectrum signal-to-noise ratio  
    spec_avail real NOT NULL, --/U  --/D Flag indicating where the spectrum can be accessed: 0=https://dr18.sdss.org/sas/dr18/spectro/sdss/redux/26/spectra/lite/, 1=https://dr18.sdss.org/sas/dr18/spectro/sdss/redux/103/spectra/lite/, 2=https://dr18.sdss.org/sas/dr18/spectro/sdss/redux/104/spectra/lite/, 3=https://dr18.sdss.org/sas/dr18/spectro/sdss/redux/v5_13_2/spectra/lite, 4=https://dr18.sdss.org/sas/dr18/spectro/sdss/redux/v6_0_4/spectra/lite/, 5=https://dr18.sdss.org/sas/dr18/spectro/sdss/redux/eFEDS/spectra/lite/, 6=https://dr18.sdss.org/sas/dr18/spectro/boss/redux/eFEDS/spectra/lite/, 7=https://dr18.sdss.org/sas/dr18/spectro/boss/redux/v6_0_4/spectra/lite/, 8= available through SDSS.astroquery  
    ra float NOT NULL, --/U deg --/D Right ascension  
    dec float NOT NULL, --/U deg --/D Declination  
    l float NOT NULL, --/U deg --/D Galactic longitude  
    b float NOT NULL, --/U deg --/D Galactic latitude  
    r_med_geo float NOT NULL, --/U pc --/D Median geometric distance from Bailer-Jones et al. (2021)  
    r_lo_geo float NOT NULL, --/U pc --/D 16th percentile of geometric distance from Bailer-Jones et al. (2021)  
    r_hi_geo float NOT NULL, --/U pc --/D 84th percentile of geometric distance from Bailer-Jones et al. (2021)  
    pmra float NOT NULL, --/U mas/yr --/D Proper motion in ra  
    pmra_error float NOT NULL, --/U mas/yr --/D Error on proper motion in ra  
    pmdec float NOT NULL, --/U mas/yr --/D Proper motion in dec  
    pmdec_error float NOT NULL, --/U mas/yr --/D Error on proper motion in dec  
    phot_g_mean_flux float NOT NULL, --/U e-/s --/D Gaia G-band mean flux  
    phot_g_mean_flux_error float NOT NULL, --/U e-/s --/D Error on G-band mean flux  
    phot_g_mean_mag float NOT NULL, --/U mag --/D Gaia G-band mean magnitude on Vega scale  
    phot_bp_mean_flux float NOT NULL, --/U e-/s --/D Gaia BP-band mean flux  
    phot_bp_mean_flux_error float NOT NULL, --/U e-/s --/D Error on BP-band mean flux  
    phot_bp_mean_mag float NOT NULL, --/U mag --/D Gaia BP-band mean magnitude on Vega scale  
    phot_rp_mean_flux float NOT NULL, --/U e-/s --/D Gaia RP-band mean flux  
    phot_rp_mean_flux_error float NOT NULL, --/U e-/s --/D Error on RP-band mean flux  
    phot_rp_mean_mag float NOT NULL, --/U mag --/D Gaia RP-band mean magnitude on Vega scale  
    phot_bp_rp_excess_factor float NOT NULL, --/U  --/D Excess flux in Gaia BP/RP photometry relative to G band  
    no_gaia_phot bit NOT NULL, --/U  --/D Flag indicating if WD lacks Gaia BP or RP mean fluxes  
    clean real NOT NULL, --/U  --/D SDSS clean photometry flag (1=clean, 0=unclean)  
    psf_mag_u float NOT NULL, --/U mag --/D SDSS PSF u-band magnitude on the SDSS scale  
    psf_mag_g float NOT NULL, --/U mag --/D SDSS PSF g-band magnitude on the SDSS scale  
    psf_mag_r float NOT NULL, --/U mag --/D SDSS PSF r-band magnitude on the SDSS scale  
    psf_mag_i float NOT NULL, --/U mag --/D SDSS PSF i-band magnitude on the SDSS scale  
    psf_mag_z float NOT NULL, --/U mag --/D SDSS PSF z-band magnitude on the SDSS scale  
    psf_magerr_u float NOT NULL, --/U mag --/D Error on SDSS PSF u-band magnitude on the SDSS scale  
    psf_magerr_g float NOT NULL, --/U mag --/D Error on SDSS PSF g-band magnitude on the SDSS scale  
    psf_magerr_r float NOT NULL, --/U mag --/D Error on SDSS PSF r-band magnitude on the SDSS scale  
    psf_magerr_i float NOT NULL, --/U mag --/D Error on SDSS PSF i-band magnitude on the SDSS scale  
    psf_magerr_z float NOT NULL, --/U mag --/D Error on SDSS PSF z-band magnitude on the SDSS scale  
    psf_flux_u float NOT NULL, --/U nanomaggies --/D SDSS PSF u-band flux  
    psf_flux_g float NOT NULL, --/U nanomaggies --/D SDSS PSF g-band flux  
    psf_flux_r float NOT NULL, --/U nanomaggies --/D SDSS PSF r-band flux  
    psf_flux_i float NOT NULL, --/U nanomaggies --/D SDSS PSF i-band flux  
    psf_flux_z float NOT NULL, --/U nanomaggies --/D SDSS PSF z-band flux  
    psf_fluxivar_u float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF u-band flux  
    psf_fluxivar_g float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF g-band flux  
    psf_fluxivar_r float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF r-band flux  
    psf_fluxivar_i float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF i-band flux  
    psf_fluxivar_z float NOT NULL, --/U nanomaggies^-2 --/D Inverse variance of SDSS PSF z-band flux  
    mag_ab_u float NOT NULL, --/U mag --/D SDSS PSF u-band magnitude on the AB scale  
    magerr_ab_u float NOT NULL, --/U mag --/D Error on SDSS PSF u-band magnitude on the AB scale  
    mag_ab_g float NOT NULL, --/U mag --/D SDSS PSF g-band magnitude on the AB scale  
    magerr_ab_g float NOT NULL, --/U mag --/D Error on SDSS PSF g-band magnitude on the AB scale  
    mag_ab_r float NOT NULL, --/U mag --/D SDSS PSF r-band magnitude on the AB scale  
    magerr_ab_r float NOT NULL, --/U mag --/D Error on SDSS PSF r-band magnitude on the AB scale  
    mag_ab_i float NOT NULL, --/U mag --/D SDSS PSF i-band magnitude on the AB scale  
    magerr_ab_i float NOT NULL, --/U mag --/D Error on SDSS PSF i-band magnitude on the AB scale  
    mag_ab_z float NOT NULL, --/U mag --/D SDSS PSF z-band magnitude on the AB scale  
    magerr_ab_z float NOT NULL, --/U mag --/D Error on SDSS PSF z-band magnitude on the AB scale  
    no_sdss_phot bit NOT NULL, --/U  --/D Flag indicating if WD lacks or has non-physical SDSS u, r, or z magnitudes on the AB scale  
    teff_gentile float NOT NULL, --/U K --/D WD effective temperature in cross-matched Gentile Fusillo et al. (2021) catalog  
    e_teff_gentile float NOT NULL, --/U K --/D Error on WD effective temperature in cross-matched Gentile Fusillo et al. (2021) catalog  
    logg_gentile float NOT NULL, --/U  --/D WD surface gravity in cross-matched Gentile Fusillo et al. (2021) catalog  
    e_logg_gentile float NOT NULL, --/U  --/D Error on WD surface gravity in cross-matched Gentile Fusillo et al. (2021) catalog  
    mass_gentile float NOT NULL, --/U Msun --/D WD mass in cross-matched Gentile Fusillo et al. (2021) catalog  
    e_mass_gentile float NOT NULL, --/U Msun --/D Error on WD mass in cross-matched Gentile Fusillo et al. (2021) catalog  
    radius_gentile float NOT NULL, --/U Rsun --/D WD radius in cross-matched Gentile Fusillo et al. (2021) catalog  
    e_radius_gentile float NOT NULL, --/U Rsun --/D Error on WD radius in cross-matched Gentile Fusillo et al. (2021) catalog  
    sdss_dr varchar(20) NOT NULL, --/U  --/D Most recent published SDSS WD catalog containing this WD, all listed measurements are from this data release  
    teff_sdss_dr float NOT NULL, --/U K --/D WD effective temperature in published SDSS catalog  
    e_teff_sdss_dr float NOT NULL, --/U K --/D Error on WD effective temperature in published SDSS catalog  
    logg_sdss_dr float NOT NULL, --/U  --/D WD surface gravity in published SDSS catalog  
    e_logg_sdss_dr float NOT NULL, --/U  --/D Error on WD surface gravity in published SDSS catalog  
    teff1d_sdss_dr float NOT NULL, --/U K --/D WD effective temperature in published SDSS catalog, not corrected for 3D effects  
    e_teff1d_sdss_dr float NOT NULL, --/U K --/D Error on WD effective temperature in published SDSS catalog, not corrected for 3D effects  
    logg1d_sdss_dr float NOT NULL, --/U  --/D WD surface gravity in published SDSS catalog, not corrected for 3D effects  
    e_logg1d_sdss_dr float NOT NULL, --/U  --/D Error on WD surface gravity in published SDSS catalog, not corrected for 3D effects  
    rv_sdss_dr float NOT NULL, --/U km/s --/D WD radial velocity in published SDSS catalog  
    e_rv_sdss_dr float NOT NULL, --/U km/s --/D Error on WD radial velocity in published SDSS catalog  
    mass_sdss_dr float NOT NULL, --/U Msun --/D WD mass in published SDSS catalog  
    e_mass_sdss_dr float NOT NULL, --/U Msun --/D Error on WD mass in published SDSS catalog  
    mass1d_sdss_dr float NOT NULL, --/U Msun --/D WD mass in published SDSS catalog, not corrected for 3D effects  
    e_mass1d_sdss_dr float NOT NULL, --/U Msun --/D Error on WD mass in published SDSS catalog, not corrected for 3D effects  
    radius_sdss_dr float NOT NULL, --/U Rsun --/D WD radius in published SDSS catalog  
    e_radius_sdss_dr float NOT NULL, --/U Rsun --/D Error on WD radius in published SDSS catalog  
    radius1d_sdss_dr float NOT NULL, --/U Rsun --/D WD radius in published SDSS catalog, not corrected for 3D effects  
    e_radius1d_sdss_dr float NOT NULL, --/U Rsun --/D Error on WD radius in published SDSS catalog, not corrected for 3D effects  
    snr_coadd float NOT NULL, --/U  --/D Coadded spectrum signal-to-noise ratio  
    nspec_coadd float NOT NULL, --/U  --/D Number of field-mjd-catalogid spectra corresponding to unique Gaia DR3 source ID, all spectra are coadded to create 1 spectrum per WD  
    rv_corv_ind float NOT NULL, --/U km/s --/D Radial velocity measured from each individual spectrum  
    e_rv_corv_ind float NOT NULL, --/U km/s --/D Error on radial velocity measured from each individual spectrum  
    teff_corv_ind float NOT NULL, --/U K --/D corv effective temperature measured from each individual spectrum  
    logg_corv_ind float NOT NULL, --/U  --/D corv surface gravity measured from each individual spectrum  
    rv_corv_coadd float NOT NULL, --/U km/s --/D Radial velocity measured from each WD coadded spectrum  
    e_rv_corv_coadd float NOT NULL, --/U km/s --/D Error on radial velocity measured from each WD coadded spectrum  
    teff_corv_coadd float NOT NULL, --/U K --/D corv effective temperature measured from each WD coadded spectrum  
    logg_corv_coadd float NOT NULL, --/U  --/D corv surface gravity measured from each WD coadded spectrum  
    e_rv_corv_ind_full float NOT NULL, --/U km/s --/D Full error (measured+systematic) on the radial velocity measured from each individual spectrum  
    e_rv_corv_coadd_full float NOT NULL, --/U km/s --/D Full error (measured+systematic) on the radial velocity measured from each WD coadded spectrum  
    rv_corv_mean float NOT NULL, --/U km/s --/D Radial velocity measured from taking the weighted mean of all high SNR individual spectrum radial velocities  
    e_rv_corv_mean float NOT NULL, --/U km/s --/D Error on radial velocity measured from taking the weighted mean of all high SNR individual spectrum radial velocities  
    nspec_mean_rv_corv float NOT NULL, --/U  --/D Number of high SNR spectra used to calculate weighted mean radial velocity  
    teff_prf_ind float NOT NULL, --/U K --/D Effective temperature measured from each individual spectrum  
    e_teff_prf_ind float NOT NULL, --/U K --/D Error on effective temperature measured from each individual spectrum  
    logg_prf_ind float NOT NULL, --/U  --/D Surface gravity measured from each individual spectrum  
    e_logg_prf_ind float NOT NULL, --/U  --/D Error on surface gravity measured from each individual spectrum  
    teff_prf_coadd float NOT NULL, --/U K --/D Effective temperature measured from each WD coadded spectrum  
    e_teff_prf_coadd float NOT NULL, --/U K --/D Error on effective temperature measured from each WD coadded spectrum  
    logg_prf_coadd float NOT NULL, --/U  --/D Surface gravity measured from each WD coadded spectrum  
    e_logg_prf_coadd float NOT NULL, --/U  --/D Error on surface gravity measured from each WD coadded spectrum  
    e_teff_prf_ind_full float NOT NULL, --/U K --/D Full error (measured+systematic) on the effective temperature from each individual spectrum  
    e_logg_prf_ind_full float NOT NULL, --/U  --/D Full error (measured+systematic) on the surface gravity from each individual spectrum  
    e_teff_prf_coadd_full float NOT NULL, --/U K --/D Full error (measured+systematic) on the effective temperature from each WD coadded spectrum  
    e_logg_prf_coadd_full float NOT NULL, --/U  --/D Full error (measured+systematic) on the surface gravity from each WD coadded spectrum  
    teff_prf_mean float NOT NULL, --/U K --/D Effective temperature measured from taking the weighted mean of all high SNR individual spectrum effective temperatures  
    e_teff_prf_mean float NOT NULL, --/U K --/D Effective temperature measured from taking the weighted mean of all high SNR individual spectrum effective temperatures  
    logg_prf_mean float NOT NULL, --/U  --/D Surface gravity measured from taking the weighted mean of all high SNR individual spectrum surface gravities  
    e_logg_prf_mean float NOT NULL, --/U  --/D Error on surface gravity measured from taking the weighted mean of all high SNR individual spectrum surface gravities  
    nspec_mean_teff float NOT NULL, --/U  --/D Number of high SNR spectra used to calculate weighted mean effective temperature  
    nspec_mean_logg float NOT NULL, --/U  --/D Number of high SNR spectra used to calculate weighted mean surface gravity  
    av_lo float NOT NULL, --/U mag --/D Total extinction in Johnson–Cousins V-band at lo geometric distance  
    u_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS u-band at lo geometric distance  
    g_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS g-band at lo geometric distance  
    r_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS r-band at lo geometric distance  
    i_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS i-band at lo geometric distance  
    z_ext_lo float NOT NULL, --/U mag --/D Total extinction in SDSS z-band at lo geometric distance  
    gaia_g_ext_lo float NOT NULL, --/U mag --/D Total extinction in Gaia G-band at lo geometric distance  
    gaia_bp_ext_lo float NOT NULL, --/U mag --/D Total extinction in Gaia BP-band at lo geometric distance  
    gaia_rp_ext_lo float NOT NULL, --/U mag --/D Total extinction in Gaia RP-band at lo geometric distance  
    u_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS u-band magnitude at lo geometric distance  
    g_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS g-band magnitude at lo geometric distance  
    r_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS r-band magnitude at lo geometric distance  
    i_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS i-band magnitude at lo geometric distance  
    z_dered_lo float NOT NULL, --/U mag --/D Dereddened SDSS z-band magnitude at lo geometric distance  
    gaia_g_dered_lo float NOT NULL, --/U mag --/D Dereddened Gaia G-band magnitude at lo geometric distance  
    gaia_bp_dered_lo float NOT NULL, --/U mag --/D Dereddened Gaia BP-band magnitude at lo geometric distance  
    gaia_rp_dered_lo float NOT NULL, --/U mag --/D Dereddened Gaia RP-band magnitude at lo geometric distance  
    av_med float NOT NULL, --/U mag --/D Total extinction in Johnson–Cousins V-band at med geometric distance  
    u_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS u-band at med geometric distance  
    g_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS g-band at med geometric distance  
    r_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS r-band at med geometric distance  
    i_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS i-band at med geometric distance  
    z_ext_med float NOT NULL, --/U mag --/D Total extinction in SDSS z-band at med geometric distance  
    gaia_g_ext_med float NOT NULL, --/U mag --/D Total extinction in Gaia G-band at med geometric distance  
    gaia_bp_ext_med float NOT NULL, --/U mag --/D Total extinction in Gaia BP-band at med geometric distance  
    gaia_rp_ext_med float NOT NULL, --/U mag --/D Total extinction in Gaia RP-band at med geometric distance  
    u_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS u-band magnitude at med geometric distance  
    g_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS g-band magnitude at med geometric distance  
    r_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS r-band magnitude at med geometric distance  
    i_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS i-band magnitude at med geometric distance  
    z_dered_med float NOT NULL, --/U mag --/D Dereddened SDSS z-band magnitude at med geometric distance  
    gaia_g_dered_med float NOT NULL, --/U mag --/D Dereddened Gaia G-band magnitude at med geometric distance  
    gaia_bp_dered_med float NOT NULL, --/U mag --/D Dereddened Gaia BP-band magnitude at med geometric distance  
    gaia_rp_dered_med float NOT NULL, --/U mag --/D Dereddened Gaia RP-band magnitude at med geometric distance  
    av_hi float NOT NULL, --/U mag --/D Total extinction in Johnson–Cousins V-band at hi geometric distance  
    u_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS u-band at hi geometric distance  
    g_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS g-band at hi geometric distance  
    r_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS r-band at hi geometric distance  
    i_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS i-band at hi geometric distance  
    z_ext_hi float NOT NULL, --/U mag --/D Total extinction in SDSS z-band at hi geometric distance  
    gaia_g_ext_hi float NOT NULL, --/U mag --/D Total extinction in Gaia G-band at hi geometric distance  
    gaia_bp_ext_hi float NOT NULL, --/U mag --/D Total extinction in Gaia BP-band at hi geometric distance  
    gaia_rp_ext_hi float NOT NULL, --/U mag --/D Total extinction in Gaia RP-band at hi geometric distance  
    u_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS u-band magnitude at hi geometric distance  
    g_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS g-band magnitude at hi geometric distance  
    r_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS r-band magnitude at hi geometric distance  
    i_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS i-band magnitude at hi geometric distance  
    z_dered_hi float NOT NULL, --/U mag --/D Dereddened SDSS z-band magnitude at hi geometric distance  
    gaia_g_dered_hi float NOT NULL, --/U mag --/D Dereddened Gaia G-band magnitude at hi geometric distance  
    gaia_bp_dered_hi float NOT NULL, --/U mag --/D Dereddened Gaia BP-band magnitude at hi geometric distance  
    gaia_rp_dered_hi float NOT NULL, --/U mag --/D Dereddened Gaia RP-band magnitude at hi geometric distance  
    phot_used bigint NOT NULL, --/U  --/D Flag indicating whether SDSS or Gaia photometry was used to fit WD parameters (1=SDSS, 2=Gaia)  
    phot_radius_sdss_lo float NOT NULL, --/U Rsun --/D Photometric radius measured at geometric distance with SDSS photometry  
    e_phot_radius_sdss_lo float NOT NULL, --/U Rsun --/D Error on photometric radius measured at geometric distance with SDSS photometry  
    phot_teff_sdss_lo float NOT NULL, --/U K --/D Photometric effective temperature measured at lo geometric distance with SDSS photometry  
    e_phot_teff_sdss_lo float NOT NULL, --/U K --/D Error on photometric effective temperature measured at lo geometric distance with SDSS photometry  
    phot_redchi_sdss_lo float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_gaia_lo float NOT NULL, --/U Rsun --/D Photometric radius measured at lo geometric distance with Gaia photometry  
    e_phot_radius_gaia_lo float NOT NULL, --/U Rsun --/D Error on photometric radius measured at lo geometric distance with Gaia photometry  
    phot_teff_gaia_lo float NOT NULL, --/U K --/D Photometric effective temperature measured at lo geometric distance with Gaia photometry  
    e_phot_teff_gaia_lo float NOT NULL, --/U K --/D Error on photometric effective temperature measured at lo geometric distance with Gaia photometry  
    phot_redchi_gaia_lo float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_sdss_med float NOT NULL, --/U Rsun --/D Photometric radius measured at med geometric distance with SDSS photometry  
    e_phot_radius_sdss_med float NOT NULL, --/U Rsun --/D Error on photometric radius measured at med geometric distance with SDSS photometry  
    phot_teff_sdss_med float NOT NULL, --/U K --/D Photometric effective temperature measured at med geometric distance with SDSS photometry  
    e_phot_teff_sdss_med float NOT NULL, --/U K --/D Error on photometric effective temperature measured at med geometric distance with SDSS photometry  
    phot_redchi_sdss_med float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_gaia_med float NOT NULL, --/U Rsun --/D Photometric radius measured at med geometric distance with Gaia photometry  
    e_phot_radius_gaia_med float NOT NULL, --/U Rsun --/D Error on photometric radius measured at med geometric distance with Gaia photometry  
    phot_teff_gaia_med float NOT NULL, --/U K --/D Photometric effective temperature measured at med geometric distance with Gaia photometry  
    e_phot_teff_gaia_med float NOT NULL, --/U K --/D Error on photometric effective temperature measured at med geometric distance with Gaia photometry  
    phot_redchi_gaia_med float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_sdss_hi float NOT NULL, --/U Rsun --/D Photometric radius measured at hi geometric distance with SDSS photometry  
    e_phot_radius_sdss_hi float NOT NULL, --/U Rsun --/D Error on photometric radius measured at hi geometric distance with SDSS photometry  
    phot_teff_sdss_hi float NOT NULL, --/U K --/D Photometric effective temperature measured at hi geometric distance with SDSS photometry  
    e_phot_teff_sdss_hi float NOT NULL, --/U K --/D Error on photometric effective temperature measured at hi geometric distance with SDSS photometry  
    phot_redchi_sdss_hi float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_radius_gaia_hi float NOT NULL, --/U Rsun --/D Photometric radius measured at hi geometric distance with Gaia photometry  
    e_phot_radius_gaia_hi float NOT NULL, --/U Rsun --/D Error on photometric radius measured at hi geometric distance with Gaia photometry  
    phot_teff_gaia_hi float NOT NULL, --/U K --/D Photometric effective temperature measured at hi geometric distance with Gaia photometry  
    e_phot_teff_gaia_hi float NOT NULL, --/U K --/D Error on photometric effective temperature measured at hi geometric distance with Gaia photometry  
    phot_redchi_gaia_hi float NOT NULL, --/U  --/D Reduced chi^2 on the photometric fit  
    phot_logg_sdss_lo float NOT NULL, --/U  --/D Photometric surface gravity measured at lo geometric distance with SDSS photometry  
    e_phot_logg_sdss_lo float NOT NULL, --/U  --/D Error on photometric surface gravity measured at lo geometric distance with SDSS photometry  
    sdss_logg_flag_lo bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    gaia_logg_flag_lo bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    phot_logg_sdss_med float NOT NULL, --/U  --/D Photometric surface gravity measured at med geometric distance with SDSS photometry  
    e_phot_logg_sdss_med float NOT NULL, --/U  --/D Error on photometric surface gravity measured at med geometric distance with SDSS photometry  
    sdss_logg_flag_med bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    gaia_logg_flag_med bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    phot_logg_sdss_hi float NOT NULL, --/U  --/D Photometric surface gravity measured at hi geometric distance with SDSS photometry  
    e_phot_logg_sdss_hi float NOT NULL, --/U  --/D Error on photometric surface gravity measured at hi geometric distance with SDSS photometry  
    sdss_logg_flag_hi bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    gaia_logg_flag_hi bigint NOT NULL, --/U  --/D Flag indicating whether the photometric fit 0=failed, 1=was successful with variable logg, 2=was successful with fixed logg=8  
    radius_phot_sdss float NOT NULL, --/U Rsun --/D Final SDSS photometric radius measurement, taken to be the value at the median geometric distance  
    e_radius_phot_sdss float NOT NULL, --/U Rsun --/D Error (measured+distance uncertainty) on the final SDSS photometric radius  
    radius_phot_gaia float NOT NULL, --/U Rsun --/D Final Gaia photometric radius measurement, taken to be the value at the median geometric distance  
    e_radius_phot_gaia float NOT NULL, --/U Rsun --/D Error (measured+distance uncertainty) on the final Gaia photometric radius  
    teff_phot_sdss float NOT NULL, --/U K --/D Final SDSS photometric effective temperature measurement, taken to be the value at the median geometric distance  
    e_teff_phot_sdss float NOT NULL, --/U K --/D Error (measured+distance uncertainty) on the final SDSS photometric effective temperature  
    teff_phot_gaia float NOT NULL, --/U K --/D Final Gaia photometric effective temperature measurement, taken to be the value at the median geometric distance  
    e_teff_phot_gaia float NOT NULL, --/U K --/D Error (measured+distance uncertainty) on the final Gaia photometric effective temperature  
    phot_err_sdss float NOT NULL, --/U mag --/D Mean SDSS u, r, and z-band magnitude error  
    phot_err_gaia float NOT NULL, --/U e-/s --/D Mean Gaia BP and RP flux error  
    radius_phot float NOT NULL, --/U Rsun --/D Final photometric radius measurement, prioritizing SDSS photometry, taken to be the value at the median geometric distance  
    e_radius_phot float NOT NULL, --/U Rsun --/D Error (measured+distance uncertainty) on the final photometric radius  
    teff_phot float NOT NULL, --/U K --/D Final photometric effective temperature measurement, prioritizing SDSS photometry, taken to be the value at the median geometric distance  
    e_teff_phot float NOT NULL, --/U K --/D Error (measured+distance uncertainty) on the final photometric effective temperature  
    e_radius_phot_full float NOT NULL, --/U Rsun --/D Full error (measured+distance uncertainty+systematic) on the final radius  
    e_teff_phot_full float NOT NULL, --/U K --/D Full error (measured+distance uncertainty+systematic) on the final effective temperature  
    mass_rad_logg float NOT NULL, --/U Msun --/D Mass measured from coadded spectrum surface gravity and final photometric radius  
    e_mass_rad_logg float NOT NULL, --/U Msun --/D Error on mass from surface gravity and radius  
    mass_logg_theory float NOT NULL, --/U Msun --/D Mass measured from coadded spectrum surface gravity and effective temperature, combined with La Plata models  
    e_mass_logg_theory float NOT NULL, --/U Msun --/D Error on mass measured from surface gravity and theory  
    mass_rad_theory float NOT NULL, --/U Msun --/D Mass measured from final photometric radius and effective temperature, combined with La Plata models  
    e_mass_rad_theory float NOT NULL, --/U Msun --/D Error on mass measured from radius and theory  
    rv_corv_lsr float NOT NULL, --/U km/s --/D Measured coadded spectrum radial velocity, corrected to the LSR  
    rv_corv_asym_corr float NOT NULL, --/U km/s --/D Measured coadded spectrum radial velocity, corrected to the LSR and for asymmetric drift, only for WDs used in the Crumpler et. al temperature dependence detection  
    asym_corr float NOT NULL, --/U km/s --/D Applied asymmetric drift correction, only for WDs used in the Crumpler et. al temperature dependence detection  
    tempdep_catalog_flag bit NOT NULL, --/U  --/D Flag indicating whether WD was used in the Crumpler et. al temperature dependence detection  
    eta float NOT NULL, --/U  --/D Logarithm of the probability that the observed apparent radial velocity variation is random noise  
    ruwe float NOT NULL, --/U  --/D Gaia Renormalised Unit Weight Error (RUWE)  
    binary_flag float NOT NULL, --/U  --/D Flag indicating whether the WD is a potential binary, 0= No evidence for binarity, 1= Evidence for binarity from apparent radial velocity variation, 2= Evidence for binarity from Gaia RUWE, 3= Evidence for binarity from both apparent radial velocity variation and RUWE  
    speed_lsr float NOT NULL, --/U km/s --/D WD total speed relative to the LSR  
    thin_disk_flag tinyint NOT NULL, --/U  --/D Flag indicating whether WD likely belongs to thin disk  
)
GO




--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'DR19Q_prop')
	DROP TABLE DR19Q_prop
GO
--
EXEC spSetDefaultFileGroup 'DR19Q_prop'
GO
create table DR19Q_prop (
-------------------------------------------------------------------------------
--/H Spectral measurements of DR19 quasars using PyQSOFit
-------------------------------------------------------------------------------
--/T Quasar spectral properties measured by PyQSOFit, including the continuum
--/T and emission line properties (flux, FWHM, EW...), virial BH masses, bolometric
--/T luminosities, Eddington ratios, systemic redshift, etc. Host galaxy properties
--/T are also provided for z<1 quasars.
-------------------------------------------------------------------------------
    field bigint NOT NULL, --/U  --/D FieldID of the exposure  
    mjd bigint NOT NULL, --/U  --/D MJD of the exposure  
    catalogid bigint NOT NULL, --/U  --/D SDSS-V catalog indentifier  
    fits_file varchar(40) NOT NULL, --/U  --/D Name of the FITS file  
    version varchar(40) NOT NULL, --/U  --/D spectra source version  
    ra float NOT NULL, --/U degree --/D Right ascension  
    dec float NOT NULL, --/U degree --/D Declination  
    nexp bigint NOT NULL, --/U  --/D Number of exposures  
    exptime float NOT NULL, --/U second --/D Exposure time  
    programname varchar(20) NOT NULL, --/U  --/D Program of the observation  
    survey varchar(20) NOT NULL, --/U  --/D Survey of the observation  
    z_pipe float NOT NULL, --/U  --/D Pipeline redshift  
    firstcarton varchar(50) NOT NULL, --/U  --/D Primary SDSS Carton for target  
    objtype varchar(20) NOT NULL, --/U  --/D Object type from SDSS pipeline  
    class varchar(10) NOT NULL, --/U  --/D Object class from SDSS pipeline  
    subclass varchar(30) NOT NULL, --/U  --/D Object subclass from SDSS pipeline  
    vi_remark varchar(20) NOT NULL, --/U  --/D Visual inspection remark  
    z_vi float NOT NULL, --/U  --/D Visual inspection redshift  
    z_fit float NOT NULL, --/U  --/D Input redshift for PyQSOFit  
    z_sys float NOT NULL, --/U  --/D Systemic redshift  
    z_sys_err float NOT NULL, --/U  --/D Systemic redshift uncertainty  
    sn_ratio_conti float NOT NULL, --/U  --/D Signal-to-noise ratio of the continuum  
    ebv float NOT NULL, --/U  --/D Milky Way extinction E(B-V)  
    conti_para_0 float NOT NULL, --/F CONTI_PARA 0 --/U mag --/D Best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 0.
    conti_para_1 float NOT NULL, --/F CONTI_PARA 1 --/U mag --/D Best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 1.
    conti_para_2 float NOT NULL, --/F CONTI_PARA 2 --/U mag --/D Best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 2.
    conti_para_3 float NOT NULL, --/F CONTI_PARA 3 --/U mag --/D Best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 3.
    conti_para_4 float NOT NULL, --/F CONTI_PARA 4 --/U mag --/D Best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 4.
    conti_para_err_0 float NOT NULL, --/F CONTI_PARA_ERR 0 --/U mag --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 0.
    conti_para_err_1 float NOT NULL, --/F CONTI_PARA_ERR 1 --/U mag --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 1.
    conti_para_err_2 float NOT NULL, --/F CONTI_PARA_ERR 2 --/U mag --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 2.
    conti_para_err_3 float NOT NULL, --/F CONTI_PARA_ERR 3 --/U mag --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 3.
    conti_para_err_4 float NOT NULL, --/F CONTI_PARA_ERR 4 --/U mag --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly)  Measurements specifically for 4.
    fe_uv_para_0 float NOT NULL, --/F FE_UV_PARA 0 --/U  --/D Best-fit parameters for the Fe II UV model  Measurements specifically for 0.  
    fe_uv_para_1 float NOT NULL, --/F FE_UV_PARA 1 --/U  --/D Best-fit parameters for the Fe II UV model  Measurements specifically for 1.  
    fe_uv_para_2 float NOT NULL, --/F FE_UV_PARA 2 --/U  --/D Best-fit parameters for the Fe II UV model  Measurements specifically for 2.  
    fe_uv_para_err_0 float NOT NULL, --/F FE_UV_PARA_ERR 0 --/U  --/D Uncertainties of the best-fit parameters for the Fe II UV model  Measurements specifically for 0.  
    fe_uv_para_err_1 float NOT NULL, --/F FE_UV_PARA_ERR 1 --/U  --/D Uncertainties of the best-fit parameters for the Fe II UV model  Measurements specifically for 1.  
    fe_uv_para_err_2 float NOT NULL, --/F FE_UV_PARA_ERR 2 --/U  --/D Uncertainties of the best-fit parameters for the Fe II UV model  Measurements specifically for 2.  
    fe_op_para_0 float NOT NULL, --/F FE_OP_PARA 0 --/U  --/D Best-fit parameters for the Fe II optical model  Measurements specifically for 0.  
    fe_op_para_1 float NOT NULL, --/F FE_OP_PARA 1 --/U  --/D Best-fit parameters for the Fe II optical model  Measurements specifically for 1.  
    fe_op_para_2 float NOT NULL, --/F FE_OP_PARA 2 --/U  --/D Best-fit parameters for the Fe II optical model  Measurements specifically for 2.  
    fe_op_para_err_0 float NOT NULL, --/F FE_OP_PARA_ERR 0 --/U  --/D Uncertainties of the best-fit parameters for the Fe II optical model  Measurements specifically for 0.  
    fe_op_para_err_1 float NOT NULL, --/F FE_OP_PARA_ERR 1 --/U  --/D Uncertainties of the best-fit parameters for the Fe II optical model  Measurements specifically for 1.  
    fe_op_para_err_2 float NOT NULL, --/F FE_OP_PARA_ERR 2 --/U  --/D Uncertainties of the best-fit parameters for the Fe II optical model  Measurements specifically for 2.  
    logl1350 float NOT NULL, --/U erg/s --/D Continuum luminosity at 1350 A  
    logl1350_err float NOT NULL, --/U erg/s --/D Uncertainty of the continuum luminosity at 1350 A  
    logl1700 float NOT NULL, --/U erg/s --/D Continuum luminosity at 1700 A  
    logl1700_err float NOT NULL, --/U erg/s --/D Uncertainty of the continuum luminosity at 1700 A  
    logl2500 float NOT NULL, --/U erg/s --/D Continuum luminosity at 2500 A  
    logl2500_err float NOT NULL, --/U erg/s --/D Uncertainty of the continuum luminosity at 2500 A  
    logl3000 float NOT NULL, --/U erg/s --/D Continuum luminosity at 3000 A  
    logl3000_err float NOT NULL, --/U erg/s --/D Uncertainty of the continuum luminosity at 3000 A  
    logl4200 float NOT NULL, --/U erg/s --/D Continuum luminosity at 4200 A  
    logl4200_err float NOT NULL, --/U erg/s --/D Uncertainty of the continuum luminosity at 4200 A  
    logl5100 float NOT NULL, --/U erg/s --/D Continuum luminosity at 5100 A  
    logl5100_err float NOT NULL, --/U erg/s --/D Uncertainty of the continuum luminosity at 5100 A  
    conti_npix float NOT NULL, --/U  --/D Pixel number of the continuum fitting  
    frac_host_4200 float NOT NULL, --/U  --/D Host galaxy contribution at 4200 A  
    frac_host_5100 float NOT NULL, --/U  --/D Host galaxy contribution at 5100 A  
    dn4000 float NOT NULL, --/U  --/D D4000 break index  
    host_decomp_para_0 float NOT NULL, --/F HOST_DECOMP_PARA 0 --/U mag --/D The host galaxy decomposition eigenvalues  Measurements specifically for 0.
    host_decomp_para_1 float NOT NULL, --/F HOST_DECOMP_PARA 1 --/U mag --/D The host galaxy decomposition eigenvalues  Measurements specifically for 1.
    host_decomp_para_2 float NOT NULL, --/F HOST_DECOMP_PARA 2 --/U mag --/D The host galaxy decomposition eigenvalues  Measurements specifically for 2.
    host_decomp_para_3 float NOT NULL, --/F HOST_DECOMP_PARA 3 --/U mag --/D The host galaxy decomposition eigenvalues  Measurements specifically for 3.
    host_decomp_para_4 float NOT NULL, --/F HOST_DECOMP_PARA 4 --/U mag --/D The host galaxy decomposition eigenvalues  Measurements specifically for 4.
    halpha_0 float NOT NULL, --/F HALPHA 0 --/U Angstrom --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    halpha_1 float NOT NULL, --/F HALPHA 1 --/U  10^{-17} erg/s/cm^2 --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    halpha_2 float NOT NULL, --/F HALPHA 2 --/U  erg/s --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    halpha_3 float NOT NULL, --/F HALPHA 3 --/U  km/s --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    halpha_4 float NOT NULL, --/F HALPHA 4 --/U  Angstrom --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    halpha_5 float NOT NULL, --/F HALPHA 5 --/U  Angstrom --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    halpha_err_0 float NOT NULL, --/F HALPHA_ERR 0 --/U Angstrom --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    halpha_err_1 float NOT NULL, --/F HALPHA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    halpha_err_2 float NOT NULL, --/F HALPHA_ERR 2 --/U  erg/s --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    halpha_err_3 float NOT NULL, --/F HALPHA_ERR 3 --/U  km/s --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    halpha_err_4 float NOT NULL, --/F HALPHA_ERR 4 --/U  Angstrom --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    halpha_err_5 float NOT NULL, --/F HALPHA_ERR 5 --/U  Angstrom --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    halpha_br_0 float NOT NULL, --/F HALPHA_BR 0 --/U Angstrom --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    halpha_br_1 float NOT NULL, --/F HALPHA_BR 1 --/U  10^{-17} erg/s/cm^2 --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    halpha_br_2 float NOT NULL, --/F HALPHA_BR 2 --/U  erg/s --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    halpha_br_3 float NOT NULL, --/F HALPHA_BR 3 --/U  km/s --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    halpha_br_4 float NOT NULL, --/F HALPHA_BR 4 --/U  Angstrom --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    halpha_br_5 float NOT NULL, --/F HALPHA_BR 5 --/U  Angstrom --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    halpha_br_err_0 float NOT NULL, --/F HALPHA_BR_ERR 0 --/U Angstrom --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    halpha_br_err_1 float NOT NULL, --/F HALPHA_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    halpha_br_err_2 float NOT NULL, --/F HALPHA_BR_ERR 2 --/U  erg/s --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    halpha_br_err_3 float NOT NULL, --/F HALPHA_BR_ERR 3 --/U  km/s --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    halpha_br_err_4 float NOT NULL, --/F HALPHA_BR_ERR 4 --/U  Angstrom --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    halpha_br_err_5 float NOT NULL, --/F HALPHA_BR_ERR 5 --/U  Angstrom --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    halpha_na_0 float NOT NULL, --/F HALPHA_NA 0 --/U Angstrom --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    halpha_na_1 float NOT NULL, --/F HALPHA_NA 1 --/U  10^{-17} erg/s/cm^2 --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    halpha_na_2 float NOT NULL, --/F HALPHA_NA 2 --/U  erg/s --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    halpha_na_3 float NOT NULL, --/F HALPHA_NA 3 --/U  km/s --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    halpha_na_4 float NOT NULL, --/F HALPHA_NA 4 --/U  Angstrom --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    halpha_na_5 float NOT NULL, --/F HALPHA_NA 5 --/U  Angstrom --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    halpha_na_err_0 float NOT NULL, --/F HALPHA_NA_ERR 0 --/U Angstrom --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    halpha_na_err_1 float NOT NULL, --/F HALPHA_NA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    halpha_na_err_2 float NOT NULL, --/F HALPHA_NA_ERR 2 --/U  erg/s --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    halpha_na_err_3 float NOT NULL, --/F HALPHA_NA_ERR 3 --/U  km/s --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    halpha_na_err_4 float NOT NULL, --/F HALPHA_NA_ERR 4 --/U  Angstrom --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    halpha_na_err_5 float NOT NULL, --/F HALPHA_NA_ERR 5 --/U  Angstrom --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    nii6549_0 float NOT NULL, --/F NII6549 0 --/U Angstrom --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    nii6549_1 float NOT NULL, --/F NII6549 1 --/U  10^{-17} erg/s/cm^2 --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    nii6549_2 float NOT NULL, --/F NII6549 2 --/U  erg/s --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    nii6549_3 float NOT NULL, --/F NII6549 3 --/U  km/s --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    nii6549_4 float NOT NULL, --/F NII6549 4 --/U  Angstrom --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    nii6549_5 float NOT NULL, --/F NII6549 5 --/U  Angstrom --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    nii6549_err_0 float NOT NULL, --/F NII6549_ERR 0 --/U Angstrom --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    nii6549_err_1 float NOT NULL, --/F NII6549_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    nii6549_err_2 float NOT NULL, --/F NII6549_ERR 2 --/U  erg/s --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    nii6549_err_3 float NOT NULL, --/F NII6549_ERR 3 --/U  km/s --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    nii6549_err_4 float NOT NULL, --/F NII6549_ERR 4 --/U  Angstrom --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    nii6549_err_5 float NOT NULL, --/F NII6549_ERR 5 --/U  Angstrom --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    nii6585_0 float NOT NULL, --/F NII6585 0 --/U Angstrom --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    nii6585_1 float NOT NULL, --/F NII6585 1 --/U  10^{-17} erg/s/cm^2 --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    nii6585_2 float NOT NULL, --/F NII6585 2 --/U  erg/s --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    nii6585_3 float NOT NULL, --/F NII6585 3 --/U  km/s --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    nii6585_4 float NOT NULL, --/F NII6585 4 --/U  Angstrom --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    nii6585_5 float NOT NULL, --/F NII6585 5 --/U  Angstrom --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    nii6585_err_0 float NOT NULL, --/F NII6585_ERR 0 --/U Angstrom --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    nii6585_err_1 float NOT NULL, --/F NII6585_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    nii6585_err_2 float NOT NULL, --/F NII6585_ERR 2 --/U  erg/s --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    nii6585_err_3 float NOT NULL, --/F NII6585_ERR 3 --/U  km/s --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    nii6585_err_4 float NOT NULL, --/F NII6585_ERR 4 --/U  Angstrom --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    nii6585_err_5 float NOT NULL, --/F NII6585_ERR 5 --/U  Angstrom --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    sii6718_0 float NOT NULL, --/F SII6718 0 --/U Angstrom --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    sii6718_1 float NOT NULL, --/F SII6718 1 --/U  10^{-17} erg/s/cm^2 --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    sii6718_2 float NOT NULL, --/F SII6718 2 --/U  erg/s --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    sii6718_3 float NOT NULL, --/F SII6718 3 --/U  km/s --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    sii6718_4 float NOT NULL, --/F SII6718 4 --/U  Angstrom --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    sii6718_5 float NOT NULL, --/F SII6718 5 --/U  Angstrom --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    sii6718_err_0 float NOT NULL, --/F SII6718_ERR 0 --/U Angstrom --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    sii6718_err_1 float NOT NULL, --/F SII6718_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    sii6718_err_2 float NOT NULL, --/F SII6718_ERR 2 --/U  erg/s --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    sii6718_err_3 float NOT NULL, --/F SII6718_ERR 3 --/U  km/s --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    sii6718_err_4 float NOT NULL, --/F SII6718_ERR 4 --/U  Angstrom --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    sii6718_err_5 float NOT NULL, --/F SII6718_ERR 5 --/U  Angstrom --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    sii6732_0 float NOT NULL, --/F SII6732 0 --/U Angstrom --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    sii6732_1 float NOT NULL, --/F SII6732 1 --/U  10^{-17} erg/s/cm^2 --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    sii6732_2 float NOT NULL, --/F SII6732 2 --/U  erg/s --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    sii6732_3 float NOT NULL, --/F SII6732 3 --/U  km/s --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    sii6732_4 float NOT NULL, --/F SII6732 4 --/U  Angstrom --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    sii6732_5 float NOT NULL, --/F SII6732 5 --/U  Angstrom --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    sii6732_err_0 float NOT NULL, --/F SII6732_ERR 0 --/U Angstrom --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    sii6732_err_1 float NOT NULL, --/F SII6732_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    sii6732_err_2 float NOT NULL, --/F SII6732_ERR 2 --/U  erg/s --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    sii6732_err_3 float NOT NULL, --/F SII6732_ERR 3 --/U  km/s --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    sii6732_err_4 float NOT NULL, --/F SII6732_ERR 4 --/U  Angstrom --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    sii6732_err_5 float NOT NULL, --/F SII6732_ERR 5 --/U  Angstrom --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    hbeta_0 float NOT NULL, --/F HBETA 0 --/U Angstrom --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    hbeta_1 float NOT NULL, --/F HBETA 1 --/U  10^{-17} erg/s/cm^2 --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    hbeta_2 float NOT NULL, --/F HBETA 2 --/U  erg/s --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    hbeta_3 float NOT NULL, --/F HBETA 3 --/U  km/s --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    hbeta_4 float NOT NULL, --/F HBETA 4 --/U  Angstrom --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    hbeta_5 float NOT NULL, --/F HBETA 5 --/U  Angstrom --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    hbeta_err_0 float NOT NULL, --/F HBETA_ERR 0 --/U Angstrom --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    hbeta_err_1 float NOT NULL, --/F HBETA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    hbeta_err_2 float NOT NULL, --/F HBETA_ERR 2 --/U  erg/s --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    hbeta_err_3 float NOT NULL, --/F HBETA_ERR 3 --/U  km/s --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    hbeta_err_4 float NOT NULL, --/F HBETA_ERR 4 --/U  Angstrom --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    hbeta_err_5 float NOT NULL, --/F HBETA_ERR 5 --/U  Angstrom --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    hbeta_br_0 float NOT NULL, --/F HBETA_BR 0 --/U Angstrom --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    hbeta_br_1 float NOT NULL, --/F HBETA_BR 1 --/U  10^{-17} erg/s/cm^2 --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    hbeta_br_2 float NOT NULL, --/F HBETA_BR 2 --/U  erg/s --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    hbeta_br_3 float NOT NULL, --/F HBETA_BR 3 --/U  km/s --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    hbeta_br_4 float NOT NULL, --/F HBETA_BR 4 --/U  Angstrom --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    hbeta_br_5 float NOT NULL, --/F HBETA_BR 5 --/U  Angstrom --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    hbeta_br_err_0 float NOT NULL, --/F HBETA_BR_ERR 0 --/U Angstrom --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    hbeta_br_err_1 float NOT NULL, --/F HBETA_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    hbeta_br_err_2 float NOT NULL, --/F HBETA_BR_ERR 2 --/U  erg/s --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    hbeta_br_err_3 float NOT NULL, --/F HBETA_BR_ERR 3 --/U  km/s --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    hbeta_br_err_4 float NOT NULL, --/F HBETA_BR_ERR 4 --/U  Angstrom --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    hbeta_br_err_5 float NOT NULL, --/F HBETA_BR_ERR 5 --/U  Angstrom --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    heii4687_0 float NOT NULL, --/F HEII4687 0 --/U Angstrom --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    heii4687_1 float NOT NULL, --/F HEII4687 1 --/U  10^{-17} erg/s/cm^2 --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    heii4687_2 float NOT NULL, --/F HEII4687 2 --/U  erg/s --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    heii4687_3 float NOT NULL, --/F HEII4687 3 --/U  km/s --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    heii4687_4 float NOT NULL, --/F HEII4687 4 --/U  Angstrom --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    heii4687_5 float NOT NULL, --/F HEII4687 5 --/U  Angstrom --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    heii4687_err_0 float NOT NULL, --/F HEII4687_ERR 0 --/U Angstrom --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    heii4687_err_1 float NOT NULL, --/F HEII4687_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    heii4687_err_2 float NOT NULL, --/F HEII4687_ERR 2 --/U  erg/s --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    heii4687_err_3 float NOT NULL, --/F HEII4687_ERR 3 --/U  km/s --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    heii4687_err_4 float NOT NULL, --/F HEII4687_ERR 4 --/U  Angstrom --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    heii4687_err_5 float NOT NULL, --/F HEII4687_ERR 5 --/U  Angstrom --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    heii4687_br_0 float NOT NULL, --/F HEII4687_BR 0 --/U Angstrom --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    heii4687_br_1 float NOT NULL, --/F HEII4687_BR 1 --/U  10^{-17} erg/s/cm^2 --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    heii4687_br_2 float NOT NULL, --/F HEII4687_BR 2 --/U  erg/s --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    heii4687_br_3 float NOT NULL, --/F HEII4687_BR 3 --/U  km/s --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    heii4687_br_4 float NOT NULL, --/F HEII4687_BR 4 --/U  Angstrom --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    heii4687_br_5 float NOT NULL, --/F HEII4687_BR 5 --/U  Angstrom --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    heii4687_br_err_0 float NOT NULL, --/F HEII4687_BR_ERR 0 --/U Angstrom --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    heii4687_br_err_1 float NOT NULL, --/F HEII4687_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    heii4687_br_err_2 float NOT NULL, --/F HEII4687_BR_ERR 2 --/U  erg/s --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    heii4687_br_err_3 float NOT NULL, --/F HEII4687_BR_ERR 3 --/U  km/s --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    heii4687_br_err_4 float NOT NULL, --/F HEII4687_BR_ERR 4 --/U  Angstrom --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    heii4687_br_err_5 float NOT NULL, --/F HEII4687_BR_ERR 5 --/U  Angstrom --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oiii5007_0 float NOT NULL, --/F OIII5007 0 --/U Angstrom --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oiii5007_1 float NOT NULL, --/F OIII5007 1 --/U  10^{-17} erg/s/cm^2 --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oiii5007_2 float NOT NULL, --/F OIII5007 2 --/U  erg/s --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oiii5007_3 float NOT NULL, --/F OIII5007 3 --/U  km/s --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oiii5007_4 float NOT NULL, --/F OIII5007 4 --/U  Angstrom --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oiii5007_5 float NOT NULL, --/F OIII5007 5 --/U  Angstrom --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oiii5007_err_0 float NOT NULL, --/F OIII5007_ERR 0 --/U Angstrom --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oiii5007_err_1 float NOT NULL, --/F OIII5007_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oiii5007_err_2 float NOT NULL, --/F OIII5007_ERR 2 --/U  erg/s --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oiii5007_err_3 float NOT NULL, --/F OIII5007_ERR 3 --/U  km/s --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oiii5007_err_4 float NOT NULL, --/F OIII5007_ERR 4 --/U  Angstrom --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oiii5007_err_5 float NOT NULL, --/F OIII5007_ERR 5 --/U  Angstrom --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oiii5007c_0 float NOT NULL, --/F OIII5007C 0 --/U Angstrom --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oiii5007c_1 float NOT NULL, --/F OIII5007C 1 --/U  10^{-17} erg/s/cm^2 --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oiii5007c_2 float NOT NULL, --/F OIII5007C 2 --/U  erg/s --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oiii5007c_3 float NOT NULL, --/F OIII5007C 3 --/U  km/s --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oiii5007c_4 float NOT NULL, --/F OIII5007C 4 --/U  Angstrom --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oiii5007c_5 float NOT NULL, --/F OIII5007C 5 --/U  Angstrom --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oiii5007c_err_0 float NOT NULL, --/F OIII5007C_ERR 0 --/U Angstrom --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oiii5007c_err_1 float NOT NULL, --/F OIII5007C_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oiii5007c_err_2 float NOT NULL, --/F OIII5007C_ERR 2 --/U  erg/s --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oiii5007c_err_3 float NOT NULL, --/F OIII5007C_ERR 3 --/U  km/s --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oiii5007c_err_4 float NOT NULL, --/F OIII5007C_ERR 4 --/U  Angstrom --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oiii5007c_err_5 float NOT NULL, --/F OIII5007C_ERR 5 --/U  Angstrom --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oiii4960_0 float NOT NULL, --/F OIII4960 0 --/U Angstrom --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oiii4960_1 float NOT NULL, --/F OIII4960 1 --/U  10^{-17} erg/s/cm^2 --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oiii4960_2 float NOT NULL, --/F OIII4960 2 --/U  erg/s --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oiii4960_3 float NOT NULL, --/F OIII4960 3 --/U  km/s --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oiii4960_4 float NOT NULL, --/F OIII4960 4 --/U  Angstrom --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oiii4960_5 float NOT NULL, --/F OIII4960 5 --/U  Angstrom --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oiii4960_err_0 float NOT NULL, --/F OIII4960_ERR 0 --/U Angstrom --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oiii4960_err_1 float NOT NULL, --/F OIII4960_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oiii4960_err_2 float NOT NULL, --/F OIII4960_ERR 2 --/U  erg/s --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oiii4960_err_3 float NOT NULL, --/F OIII4960_ERR 3 --/U  km/s --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oiii4960_err_4 float NOT NULL, --/F OIII4960_ERR 4 --/U  Angstrom --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oiii4960_err_5 float NOT NULL, --/F OIII4960_ERR 5 --/U  Angstrom --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oiii4960c_0 float NOT NULL, --/F OIII4960C 0 --/U Angstrom --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oiii4960c_1 float NOT NULL, --/F OIII4960C 1 --/U  10^{-17} erg/s/cm^2 --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oiii4960c_2 float NOT NULL, --/F OIII4960C 2 --/U  erg/s --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oiii4960c_3 float NOT NULL, --/F OIII4960C 3 --/U  km/s --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oiii4960c_4 float NOT NULL, --/F OIII4960C 4 --/U  Angstrom --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oiii4960c_5 float NOT NULL, --/F OIII4960C 5 --/U  Angstrom --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oiii4960c_err_0 float NOT NULL, --/F OIII4960C_ERR 0 --/U Angstrom --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oiii4960c_err_1 float NOT NULL, --/F OIII4960C_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oiii4960c_err_2 float NOT NULL, --/F OIII4960C_ERR 2 --/U  erg/s --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oiii4960c_err_3 float NOT NULL, --/F OIII4960C_ERR 3 --/U  km/s --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oiii4960c_err_4 float NOT NULL, --/F OIII4960C_ERR 4 --/U  Angstrom --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oiii4960c_err_5 float NOT NULL, --/F OIII4960C_ERR 5 --/U  Angstrom --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    hgamma_0 float NOT NULL, --/F HGAMMA 0 --/U Angstrom --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    hgamma_1 float NOT NULL, --/F HGAMMA 1 --/U  10^{-17} erg/s/cm^2 --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    hgamma_2 float NOT NULL, --/F HGAMMA 2 --/U  erg/s --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    hgamma_3 float NOT NULL, --/F HGAMMA 3 --/U  km/s --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    hgamma_4 float NOT NULL, --/F HGAMMA 4 --/U  Angstrom --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    hgamma_5 float NOT NULL, --/F HGAMMA 5 --/U  Angstrom --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    hgamma_err_0 float NOT NULL, --/F HGAMMA_ERR 0 --/U Angstrom --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    hgamma_err_1 float NOT NULL, --/F HGAMMA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    hgamma_err_2 float NOT NULL, --/F HGAMMA_ERR 2 --/U  erg/s --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    hgamma_err_3 float NOT NULL, --/F HGAMMA_ERR 3 --/U  km/s --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    hgamma_err_4 float NOT NULL, --/F HGAMMA_ERR 4 --/U  Angstrom --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    hgamma_err_5 float NOT NULL, --/F HGAMMA_ERR 5 --/U  Angstrom --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    hdelta_0 float NOT NULL, --/F HDELTA 0 --/U Angstrom --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    hdelta_1 float NOT NULL, --/F HDELTA 1 --/U  10^{-17} erg/s/cm^2 --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    hdelta_2 float NOT NULL, --/F HDELTA 2 --/U  erg/s --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    hdelta_3 float NOT NULL, --/F HDELTA 3 --/U  km/s --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    hdelta_4 float NOT NULL, --/F HDELTA 4 --/U  Angstrom --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    hdelta_5 float NOT NULL, --/F HDELTA 5 --/U  Angstrom --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    hdelta_err_0 float NOT NULL, --/F HDELTA_ERR 0 --/U Angstrom --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    hdelta_err_1 float NOT NULL, --/F HDELTA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    hdelta_err_2 float NOT NULL, --/F HDELTA_ERR 2 --/U  erg/s --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    hdelta_err_3 float NOT NULL, --/F HDELTA_ERR 3 --/U  km/s --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    hdelta_err_4 float NOT NULL, --/F HDELTA_ERR 4 --/U  Angstrom --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    hdelta_err_5 float NOT NULL, --/F HDELTA_ERR 5 --/U  Angstrom --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    caii3934_0 float NOT NULL, --/F CAII3934 0 --/U Angstrom --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    caii3934_1 float NOT NULL, --/F CAII3934 1 --/U  10^{-17} erg/s/cm^2 --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    caii3934_2 float NOT NULL, --/F CAII3934 2 --/U  erg/s --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    caii3934_3 float NOT NULL, --/F CAII3934 3 --/U  km/s --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    caii3934_4 float NOT NULL, --/F CAII3934 4 --/U  Angstrom --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    caii3934_5 float NOT NULL, --/F CAII3934 5 --/U  Angstrom --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    caii3934_err_0 float NOT NULL, --/F CAII3934_ERR 0 --/U Angstrom --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    caii3934_err_1 float NOT NULL, --/F CAII3934_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    caii3934_err_2 float NOT NULL, --/F CAII3934_ERR 2 --/U  erg/s --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    caii3934_err_3 float NOT NULL, --/F CAII3934_ERR 3 --/U  km/s --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    caii3934_err_4 float NOT NULL, --/F CAII3934_ERR 4 --/U  Angstrom --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    caii3934_err_5 float NOT NULL, --/F CAII3934_ERR 5 --/U  Angstrom --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oii3728_0 float NOT NULL, --/F OII3728 0 --/U Angstrom --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oii3728_1 float NOT NULL, --/F OII3728 1 --/U  10^{-17} erg/s/cm^2 --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oii3728_2 float NOT NULL, --/F OII3728 2 --/U  erg/s --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oii3728_3 float NOT NULL, --/F OII3728 3 --/U  km/s --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oii3728_4 float NOT NULL, --/F OII3728 4 --/U  Angstrom --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oii3728_5 float NOT NULL, --/F OII3728 5 --/U  Angstrom --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oii3728_err_0 float NOT NULL, --/F OII3728_ERR 0 --/U Angstrom --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oii3728_err_1 float NOT NULL, --/F OII3728_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oii3728_err_2 float NOT NULL, --/F OII3728_ERR 2 --/U  erg/s --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oii3728_err_3 float NOT NULL, --/F OII3728_ERR 3 --/U  km/s --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oii3728_err_4 float NOT NULL, --/F OII3728_ERR 4 --/U  Angstrom --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oii3728_err_5 float NOT NULL, --/F OII3728_ERR 5 --/U  Angstrom --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    nev3426_0 float NOT NULL, --/F NEV3426 0 --/U Angstrom --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    nev3426_1 float NOT NULL, --/F NEV3426 1 --/U  10^{-17} erg/s/cm^2 --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    nev3426_2 float NOT NULL, --/F NEV3426 2 --/U  erg/s --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    nev3426_3 float NOT NULL, --/F NEV3426 3 --/U  km/s --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    nev3426_4 float NOT NULL, --/F NEV3426 4 --/U  Angstrom --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    nev3426_5 float NOT NULL, --/F NEV3426 5 --/U  Angstrom --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    nev3426_err_0 float NOT NULL, --/F NEV3426_ERR 0 --/U Angstrom --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    nev3426_err_1 float NOT NULL, --/F NEV3426_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    nev3426_err_2 float NOT NULL, --/F NEV3426_ERR 2 --/U  erg/s --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    nev3426_err_3 float NOT NULL, --/F NEV3426_ERR 3 --/U  km/s --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    nev3426_err_4 float NOT NULL, --/F NEV3426_ERR 4 --/U  Angstrom --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    nev3426_err_5 float NOT NULL, --/F NEV3426_ERR 5 --/U  Angstrom --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    mgii_0 float NOT NULL, --/F MGII 0 --/U Angstrom --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    mgii_1 float NOT NULL, --/F MGII 1 --/U  10^{-17} erg/s/cm^2 --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    mgii_2 float NOT NULL, --/F MGII 2 --/U  erg/s --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    mgii_3 float NOT NULL, --/F MGII 3 --/U  km/s --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    mgii_4 float NOT NULL, --/F MGII 4 --/U  Angstrom --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    mgii_5 float NOT NULL, --/F MGII 5 --/U  Angstrom --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    mgii_err_0 float NOT NULL, --/F MGII_ERR 0 --/U Angstrom --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    mgii_err_1 float NOT NULL, --/F MGII_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    mgii_err_2 float NOT NULL, --/F MGII_ERR 2 --/U  erg/s --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    mgii_err_3 float NOT NULL, --/F MGII_ERR 3 --/U  km/s --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    mgii_err_4 float NOT NULL, --/F MGII_ERR 4 --/U  Angstrom --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    mgii_err_5 float NOT NULL, --/F MGII_ERR 5 --/U  Angstrom --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    mgii_br_0 float NOT NULL, --/F MGII_BR 0 --/U Angstrom --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    mgii_br_1 float NOT NULL, --/F MGII_BR 1 --/U  10^{-17} erg/s/cm^2 --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    mgii_br_2 float NOT NULL, --/F MGII_BR 2 --/U  erg/s --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    mgii_br_3 float NOT NULL, --/F MGII_BR 3 --/U  km/s --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    mgii_br_4 float NOT NULL, --/F MGII_BR 4 --/U  Angstrom --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    mgii_br_5 float NOT NULL, --/F MGII_BR 5 --/U  Angstrom --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    mgii_br_err_0 float NOT NULL, --/F MGII_BR_ERR 0 --/U Angstrom --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    mgii_br_err_1 float NOT NULL, --/F MGII_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    mgii_br_err_2 float NOT NULL, --/F MGII_BR_ERR 2 --/U  erg/s --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    mgii_br_err_3 float NOT NULL, --/F MGII_BR_ERR 3 --/U  km/s --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    mgii_br_err_4 float NOT NULL, --/F MGII_BR_ERR 4 --/U  Angstrom --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    mgii_br_err_5 float NOT NULL, --/F MGII_BR_ERR 5 --/U  Angstrom --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    ciii_br_0 float NOT NULL, --/F CIII_BR 0 --/U Angstrom --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    ciii_br_1 float NOT NULL, --/F CIII_BR 1 --/U  10^{-17} erg/s/cm^2 --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    ciii_br_2 float NOT NULL, --/F CIII_BR 2 --/U  erg/s --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    ciii_br_3 float NOT NULL, --/F CIII_BR 3 --/U  km/s --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    ciii_br_4 float NOT NULL, --/F CIII_BR 4 --/U  Angstrom --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    ciii_br_5 float NOT NULL, --/F CIII_BR 5 --/U  Angstrom --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    ciii_br_err_0 float NOT NULL, --/F CIII_BR_ERR 0 --/U Angstrom --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    ciii_br_err_1 float NOT NULL, --/F CIII_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    ciii_br_err_2 float NOT NULL, --/F CIII_BR_ERR 2 --/U  erg/s --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    ciii_br_err_3 float NOT NULL, --/F CIII_BR_ERR 3 --/U  km/s --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    ciii_br_err_4 float NOT NULL, --/F CIII_BR_ERR 4 --/U  Angstrom --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    ciii_br_err_5 float NOT NULL, --/F CIII_BR_ERR 5 --/U  Angstrom --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    siiii1892_0 float NOT NULL, --/F SIIII1892 0 --/U Angstrom --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    siiii1892_1 float NOT NULL, --/F SIIII1892 1 --/U  10^{-17} erg/s/cm^2 --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    siiii1892_2 float NOT NULL, --/F SIIII1892 2 --/U  erg/s --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    siiii1892_3 float NOT NULL, --/F SIIII1892 3 --/U  km/s --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    siiii1892_4 float NOT NULL, --/F SIIII1892 4 --/U  Angstrom --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    siiii1892_5 float NOT NULL, --/F SIIII1892 5 --/U  Angstrom --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    siiii1892_err_0 float NOT NULL, --/F SIIII1892_ERR 0 --/U Angstrom --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    siiii1892_err_1 float NOT NULL, --/F SIIII1892_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    siiii1892_err_2 float NOT NULL, --/F SIIII1892_ERR 2 --/U  erg/s --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    siiii1892_err_3 float NOT NULL, --/F SIIII1892_ERR 3 --/U  km/s --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    siiii1892_err_4 float NOT NULL, --/F SIIII1892_ERR 4 --/U  Angstrom --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    siiii1892_err_5 float NOT NULL, --/F SIIII1892_ERR 5 --/U  Angstrom --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    aliii1857_0 float NOT NULL, --/F ALIII1857 0 --/U Angstrom --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    aliii1857_1 float NOT NULL, --/F ALIII1857 1 --/U  10^{-17} erg/s/cm^2 --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    aliii1857_2 float NOT NULL, --/F ALIII1857 2 --/U  erg/s --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    aliii1857_3 float NOT NULL, --/F ALIII1857 3 --/U  km/s --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    aliii1857_4 float NOT NULL, --/F ALIII1857 4 --/U  Angstrom --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    aliii1857_5 float NOT NULL, --/F ALIII1857 5 --/U  Angstrom --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    aliii1857_err_0 float NOT NULL, --/F ALIII1857_ERR 0 --/U Angstrom --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    aliii1857_err_1 float NOT NULL, --/F ALIII1857_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    aliii1857_err_2 float NOT NULL, --/F ALIII1857_ERR 2 --/U  erg/s --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    aliii1857_err_3 float NOT NULL, --/F ALIII1857_ERR 3 --/U  km/s --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    aliii1857_err_4 float NOT NULL, --/F ALIII1857_ERR 4 --/U  Angstrom --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    aliii1857_err_5 float NOT NULL, --/F ALIII1857_ERR 5 --/U  Angstrom --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    niii1750_0 float NOT NULL, --/F NIII1750 0 --/U Angstrom --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    niii1750_1 float NOT NULL, --/F NIII1750 1 --/U  10^{-17} erg/s/cm^2 --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    niii1750_2 float NOT NULL, --/F NIII1750 2 --/U  erg/s --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    niii1750_3 float NOT NULL, --/F NIII1750 3 --/U  km/s --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    niii1750_4 float NOT NULL, --/F NIII1750 4 --/U  Angstrom --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    niii1750_5 float NOT NULL, --/F NIII1750 5 --/U  Angstrom --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    niii1750_err_0 float NOT NULL, --/F NIII1750_ERR 0 --/U Angstrom --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    niii1750_err_1 float NOT NULL, --/F NIII1750_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    niii1750_err_2 float NOT NULL, --/F NIII1750_ERR 2 --/U  erg/s --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    niii1750_err_3 float NOT NULL, --/F NIII1750_ERR 3 --/U  km/s --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    niii1750_err_4 float NOT NULL, --/F NIII1750_ERR 4 --/U  Angstrom --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    niii1750_err_5 float NOT NULL, --/F NIII1750_ERR 5 --/U  Angstrom --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    civ_0 float NOT NULL, --/F CIV 0 --/U Angstrom --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    civ_1 float NOT NULL, --/F CIV 1 --/U  10^{-17} erg/s/cm^2 --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    civ_2 float NOT NULL, --/F CIV 2 --/U  erg/s --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    civ_3 float NOT NULL, --/F CIV 3 --/U  km/s --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    civ_4 float NOT NULL, --/F CIV 4 --/U  Angstrom --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    civ_5 float NOT NULL, --/F CIV 5 --/U  Angstrom --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    civ_err_0 float NOT NULL, --/F CIV_ERR 0 --/U Angstrom --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    civ_err_1 float NOT NULL, --/F CIV_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    civ_err_2 float NOT NULL, --/F CIV_ERR 2 --/U  erg/s --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    civ_err_3 float NOT NULL, --/F CIV_ERR 3 --/U  km/s --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    civ_err_4 float NOT NULL, --/F CIV_ERR 4 --/U  Angstrom --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    civ_err_5 float NOT NULL, --/F CIV_ERR 5 --/U  Angstrom --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    heii1640_0 float NOT NULL, --/F HEII1640 0 --/U Angstrom --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    heii1640_1 float NOT NULL, --/F HEII1640 1 --/U  10^{-17} erg/s/cm^2 --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    heii1640_2 float NOT NULL, --/F HEII1640 2 --/U  erg/s --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    heii1640_3 float NOT NULL, --/F HEII1640 3 --/U  km/s --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    heii1640_4 float NOT NULL, --/F HEII1640 4 --/U  Angstrom --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    heii1640_5 float NOT NULL, --/F HEII1640 5 --/U  Angstrom --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    heii1640_err_0 float NOT NULL, --/F HEII1640_ERR 0 --/U Angstrom --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    heii1640_err_1 float NOT NULL, --/F HEII1640_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    heii1640_err_2 float NOT NULL, --/F HEII1640_ERR 2 --/U  erg/s --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    heii1640_err_3 float NOT NULL, --/F HEII1640_ERR 3 --/U  km/s --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    heii1640_err_4 float NOT NULL, --/F HEII1640_ERR 4 --/U  Angstrom --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    heii1640_err_5 float NOT NULL, --/F HEII1640_ERR 5 --/U  Angstrom --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    heii1640_br_0 float NOT NULL, --/F HEII1640_BR 0 --/U Angstrom --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    heii1640_br_1 float NOT NULL, --/F HEII1640_BR 1 --/U  10^{-17} erg/s/cm^2 --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    heii1640_br_2 float NOT NULL, --/F HEII1640_BR 2 --/U  erg/s --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    heii1640_br_3 float NOT NULL, --/F HEII1640_BR 3 --/U  km/s --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    heii1640_br_4 float NOT NULL, --/F HEII1640_BR 4 --/U  Angstrom --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    heii1640_br_5 float NOT NULL, --/F HEII1640_BR 5 --/U  Angstrom --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    heii1640_br_err_0 float NOT NULL, --/F HEII1640_BR_ERR 0 --/U Angstrom --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    heii1640_br_err_1 float NOT NULL, --/F HEII1640_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    heii1640_br_err_2 float NOT NULL, --/F HEII1640_BR_ERR 2 --/U  erg/s --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    heii1640_br_err_3 float NOT NULL, --/F HEII1640_BR_ERR 3 --/U  km/s --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    heii1640_br_err_4 float NOT NULL, --/F HEII1640_BR_ERR 4 --/U  Angstrom --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    heii1640_br_err_5 float NOT NULL, --/F HEII1640_BR_ERR 5 --/U  Angstrom --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    siiv_oiv_0 float NOT NULL, --/F SIIV_OIV 0 --/U Angstrom --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    siiv_oiv_1 float NOT NULL, --/F SIIV_OIV 1 --/U  10^{-17} erg/s/cm^2 --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    siiv_oiv_2 float NOT NULL, --/F SIIV_OIV 2 --/U  erg/s --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    siiv_oiv_3 float NOT NULL, --/F SIIV_OIV 3 --/U  km/s --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    siiv_oiv_4 float NOT NULL, --/F SIIV_OIV 4 --/U  Angstrom --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    siiv_oiv_5 float NOT NULL, --/F SIIV_OIV 5 --/U  Angstrom --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    siiv_oiv_err_0 float NOT NULL, --/F SIIV_OIV_ERR 0 --/U Angstrom --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    siiv_oiv_err_1 float NOT NULL, --/F SIIV_OIV_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    siiv_oiv_err_2 float NOT NULL, --/F SIIV_OIV_ERR 2 --/U  erg/s --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    siiv_oiv_err_3 float NOT NULL, --/F SIIV_OIV_ERR 3 --/U  km/s --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    siiv_oiv_err_4 float NOT NULL, --/F SIIV_OIV_ERR 4 --/U  Angstrom --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    siiv_oiv_err_5 float NOT NULL, --/F SIIV_OIV_ERR 5 --/U  Angstrom --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oi1304_0 float NOT NULL, --/F OI1304 0 --/U Angstrom --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oi1304_1 float NOT NULL, --/F OI1304 1 --/U  10^{-17} erg/s/cm^2 --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oi1304_2 float NOT NULL, --/F OI1304 2 --/U  erg/s --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oi1304_3 float NOT NULL, --/F OI1304 3 --/U  km/s --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oi1304_4 float NOT NULL, --/F OI1304 4 --/U  Angstrom --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oi1304_5 float NOT NULL, --/F OI1304 5 --/U  Angstrom --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    oi1304_err_0 float NOT NULL, --/F OI1304_ERR 0 --/U Angstrom --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    oi1304_err_1 float NOT NULL, --/F OI1304_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    oi1304_err_2 float NOT NULL, --/F OI1304_ERR 2 --/U  erg/s --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    oi1304_err_3 float NOT NULL, --/F OI1304_ERR 3 --/U  km/s --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    oi1304_err_4 float NOT NULL, --/F OI1304_ERR 4 --/U  Angstrom --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    oi1304_err_5 float NOT NULL, --/F OI1304_ERR 5 --/U  Angstrom --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    lya_0 float NOT NULL, --/F LYA 0 --/U Angstrom --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    lya_1 float NOT NULL, --/F LYA 1 --/U  10^{-17} erg/s/cm^2 --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    lya_2 float NOT NULL, --/F LYA 2 --/U  erg/s --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    lya_3 float NOT NULL, --/F LYA 3 --/U  km/s --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    lya_4 float NOT NULL, --/F LYA 4 --/U  Angstrom --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    lya_5 float NOT NULL, --/F LYA 5 --/U  Angstrom --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    lya_err_0 float NOT NULL, --/F LYA_ERR 0 --/U Angstrom --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    lya_err_1 float NOT NULL, --/F LYA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    lya_err_2 float NOT NULL, --/F LYA_ERR 2 --/U  erg/s --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    lya_err_3 float NOT NULL, --/F LYA_ERR 3 --/U  km/s --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    lya_err_4 float NOT NULL, --/F LYA_ERR 4 --/U  Angstrom --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    lya_err_5 float NOT NULL, --/F LYA_ERR 5 --/U  Angstrom --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    nv1240_0 float NOT NULL, --/F NV1240 0 --/U Angstrom --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    nv1240_1 float NOT NULL, --/F NV1240 1 --/U  10^{-17} erg/s/cm^2 --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    nv1240_2 float NOT NULL, --/F NV1240 2 --/U  erg/s --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    nv1240_3 float NOT NULL, --/F NV1240 3 --/U  km/s --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    nv1240_4 float NOT NULL, --/F NV1240 4 --/U  Angstrom --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    nv1240_5 float NOT NULL, --/F NV1240 5 --/U  Angstrom --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    nv1240_err_0 float NOT NULL, --/F NV1240_ERR 0 --/U Angstrom --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 0.  
    nv1240_err_1 float NOT NULL, --/F NV1240_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 1.  
    nv1240_err_2 float NOT NULL, --/F NV1240_ERR 2 --/U  erg/s --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 2.  
    nv1240_err_3 float NOT NULL, --/F NV1240_ERR 3 --/U  km/s --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 3.  
    nv1240_err_4 float NOT NULL, --/F NV1240_ERR 4 --/U  Angstrom --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 4.  
    nv1240_err_5 float NOT NULL, --/F NV1240_ERR 5 --/U  Angstrom --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength  Measurements specifically for 5.  
    ha_stat_0 float NOT NULL, --/F Ha_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    ha_stat_1 float NOT NULL, --/F Ha_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    hb_stat_0 float NOT NULL, --/F Hb_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    hb_stat_1 float NOT NULL, --/F Hb_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    hr_stat_0 float NOT NULL, --/F Hr_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    hr_stat_1 float NOT NULL, --/F Hr_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    hd_stat_0 float NOT NULL, --/F Hd_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    hd_stat_1 float NOT NULL, --/F Hd_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    mgii_stat_0 float NOT NULL, --/F MgII_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    mgii_stat_1 float NOT NULL, --/F MgII_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    ciii_stat_0 float NOT NULL, --/F CIII_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    ciii_stat_1 float NOT NULL, --/F CIII_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    civ_stat_0 float NOT NULL, --/F CIV_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    civ_stat_1 float NOT NULL, --/F CIV_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    siiv_stat_0 float NOT NULL, --/F SiIV_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    siiv_stat_1 float NOT NULL, --/F SiIV_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    lya_stat_0 float NOT NULL, --/F Lya_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    lya_stat_1 float NOT NULL, --/F Lya_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    caii_stat_0 float NOT NULL, --/F CaII_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    caii_stat_1 float NOT NULL, --/F CaII_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    oii_stat_0 float NOT NULL, --/F OII_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    oii_stat_1 float NOT NULL, --/F OII_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    nev_stat_0 float NOT NULL, --/F NeV_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 0.  
    nev_stat_1 float NOT NULL, --/F NeV_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square  Measurements specifically for 1.  
    loglbol float NOT NULL, --/U erg/s --/D Bolometric luminosity  
    loglbol_err float NOT NULL, --/U erg/s --/D Uncertainty of the bolometric luminosity  
    logmbh_hb float NOT NULL, --/U M_sun --/D Black hole mass from Hbeta line  
    logmbh_hb_err float NOT NULL, --/U M_sun --/D Uncertainty of the black hole mass from Hbeta line  
    logmbh_mgii float NOT NULL, --/U M_sun --/D Black hole mass from MgII line  
    logmbh_mgii_err float NOT NULL, --/U M_sun --/D Uncertainty of the black hole mass from MgII line  
    logmbh_civ float NOT NULL, --/U M_sun --/D Black hole mass from CIV line  
    logmbh_civ_err float NOT NULL, --/U M_sun --/D Uncertainty of the black hole mass from CIV line  
    logmbh float NOT NULL, --/U M_sun --/D Fiducial black hole mass  
    logmbh_err float NOT NULL, --/U M_sun --/D Uncertainty of the fiducial black hole mass  
    loglledd_ratio float NOT NULL, --/U  --/D Eddington ratio  
    loglledd_ratio_err float NOT NULL, --/U  --/D Uncertainty of the Eddington ratio  
    zsys_best float NOT NULL, --/U  --/D Systematic redshift from the line zsys with the lowest errorbar  
    zsys_best_err float NOT NULL, --/U  --/D Uncertainty of the systematic redshift from the line zsys with the lowest errorbar  
    zsys_weight float NOT NULL, --/U  --/D Systematic redshift from the weighted mean  
    zsys_weight_err float NOT NULL, --/U  --/D Uncertainty of the systematic redshift from the weighted mean  
    zsys_lines_0 float NOT NULL, --/F ZSYS_LINES 0 --/U  --/D Systematic redshift from Hbeta_BR, [OIII]5007, CaII3934, [OII]3728, MgII, CIII], CIV, SiIV  Measurements specifically for 0.  
    zsys_lines_1 float NOT NULL, --/F ZSYS_LINES 1 --/U  --/D Systematic redshift from Hbeta_BR, [OIII]5007, CaII3934, [OII]3728, MgII, CIII], CIV, SiIV  Measurements specifically for 1.  
    zsys_lines_2 float NOT NULL, --/F ZSYS_LINES 2 --/U  --/D Systematic redshift from Hbeta_BR, [OIII]5007, CaII3934, [OII]3728, MgII, CIII], CIV, SiIV  Measurements specifically for 2.  
    zsys_lines_3 float NOT NULL, --/F ZSYS_LINES 3 --/U  --/D Systematic redshift from Hbeta_BR, [OIII]5007, CaII3934, [OII]3728, MgII, CIII], CIV, SiIV  Measurements specifically for 3.  
    zsys_lines_4 float NOT NULL, --/F ZSYS_LINES 4 --/U  --/D Systematic redshift from Hbeta_BR, [OIII]5007, CaII3934, [OII]3728, MgII, CIII], CIV, SiIV  Measurements specifically for 4.  
    zsys_lines_5 float NOT NULL, --/F ZSYS_LINES 5 --/U  --/D Systematic redshift from Hbeta_BR, [OIII]5007, CaII3934, [OII]3728, MgII, CIII], CIV, SiIV  Measurements specifically for 5.  
    zsys_lines_6 float NOT NULL, --/F ZSYS_LINES 6 --/U  --/D Systematic redshift from Hbeta_BR, [OIII]5007, CaII3934, [OII]3728, MgII, CIII], CIV, SiIV  Measurements specifically for 6.  
    zsys_lines_7 float NOT NULL, --/F ZSYS_LINES 7 --/U  --/D Systematic redshift from Hbeta_BR, [OIII]5007, CaII3934, [OII]3728, MgII, CIII], CIV, SiIV  Measurements specifically for 7.  
    zsys_lines_err_0 float NOT NULL, --/F ZSYS_LINES_ERR 0 --/U  --/D Uncertainties of the systematic redshift from emission lines  Measurements specifically for 0.  
    zsys_lines_err_1 float NOT NULL, --/F ZSYS_LINES_ERR 1 --/U  --/D Uncertainties of the systematic redshift from emission lines  Measurements specifically for 1.  
    zsys_lines_err_2 float NOT NULL, --/F ZSYS_LINES_ERR 2 --/U  --/D Uncertainties of the systematic redshift from emission lines  Measurements specifically for 2.  
    zsys_lines_err_3 float NOT NULL, --/F ZSYS_LINES_ERR 3 --/U  --/D Uncertainties of the systematic redshift from emission lines  Measurements specifically for 3.  
    zsys_lines_err_4 float NOT NULL, --/F ZSYS_LINES_ERR 4 --/U  --/D Uncertainties of the systematic redshift from emission lines  Measurements specifically for 4.  
    zsys_lines_err_5 float NOT NULL, --/F ZSYS_LINES_ERR 5 --/U  --/D Uncertainties of the systematic redshift from emission lines  Measurements specifically for 5.  
    zsys_lines_err_6 float NOT NULL, --/F ZSYS_LINES_ERR 6 --/U  --/D Uncertainties of the systematic redshift from emission lines  Measurements specifically for 6.  
    zsys_lines_err_7 float NOT NULL, --/F ZSYS_LINES_ERR 7 --/U  --/D Uncertainties of the systematic redshift from emission lines  Measurements specifically for 7.  
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'occam_cluster')
	DROP TABLE occam_cluster
GO
--
EXEC spSetDefaultFileGroup 'occam_cluster'
GO
--// Created from $APOGEE_OCCAM/occam_cluster-DR19.fits
CREATE TABLE occam_cluster (
-------------------------------------------------------------------------------
--/H The OCCAM cluster summary table provides mean cluster parameters for 170 open clusters.
-------------------------------------------------------------------------------
--/T The OCCAM cluster summary table provides a comprehensive, uniform
--/T dataset for open clusters. It contains mean 5-D astrometry from Gaia (Cantat-Gaudin
--/T et al. 2020, Hunt & Reffert 2023), mean orbital parameters calculated using Gala
--/T (Adrian M. Price-Whelan 2017), an orbital dynamics code, and mean radial velocities
--/T and chemical abundances from MWM/APOGEE.
-------------------------------------------------------------------------------
    [name] varchar(20) NOT NULL, --/U --- --/D Open cluster name   1  
    glon float NOT NULL, --/U deg --/D Galactic longitude   2  
    glat float NOT NULL, --/U deg --/D Galactic latitude  3  
    radeg float NOT NULL, --/U deg --/D Right ascencion in degrees   4  
    dedeg float NOT NULL, --/U deg --/D Declination in degrees   5  
    cg_rad float NOT NULL, --/U deg --/D Cluster radius containing half the members, from Cantat-Gaudin et al. 2020   6  
    cg_pmra float NOT NULL, --/U mas/yr --/D Mean proper motion in RA of cluster members, pmra*cos(declination) from Cantat-Gaudin et al. 2020  7  
    cg_pmra_err float NOT NULL, --/U mas/yr --/D Standard deviation of CG_PMRA of cluster members from Cantat-Gaudin et al. 2020   8  
    cg_pmde float NOT NULL, --/U mas/yr --/D Mean proper motion in DE of cluster members from Cantat-Gaudin et al. 2020  9  
    cg_pmde_err float NOT NULL, --/U mas/yr --/D Standard deviation in CG_PMDE of cluster members from Cantat-Gaudin et al. 2020 10  
    v_rad float NOT NULL, --/U km/s --/D Mean radial velocity of cluster members  11  
    v_rad_err float NOT NULL, --/U km/s --/D 1-sigma V_RAD dispersion 12  
    cg_r_gc float NOT NULL, --/U kpc --/D Distance from the Galactic center from Cantat-Gaudin et al. 2020  13  
    cg_distpc float NOT NULL, --/U pc --/D Distance from solar neighborbood from Cantat-Gaudin et al. 2020  14  
    cg_logage float NOT NULL, --/U yr --/D logAge of the cluster from Cantat-Gaudin et al. 2020  15  
    r_guide float NOT NULL, --/U kpc --/D Guiding Center radius  16  
    z_height float NOT NULL, --/U kpc --/D Current Z position in X,Y,Z Galactocentric coordinates  17  
    z_max float NOT NULL, --/U kpc --/D Maximum Z position   18  
    azimuth_angle float NOT NULL, --/U deg --/D Azimuthal angle relative to Galactic center  19  
    eccentricity float NOT NULL, --/U --- --/D Average eccentricity of calculated cluster orbits  20  
    z_period_avg float NOT NULL, --/U Myr --/D Average period in the Z coordinate  21  
    radial_period_avg float NOT NULL, --/U Myr --/D Average radial period of the cluster  22  
    fe_h_aspcap float NOT NULL, --/U dex --/D Mean [Fe/H] from the ASPCAP pipeline 23  
    c_h float NOT NULL, --/U dex --/D Mean [C/H]  24  
    c_h_err float NOT NULL, --/U dex --/D 1-sigma [C/H] dispersion  25  
    n_h float NOT NULL, --/U dex --/D Mean [N/H]  26  
    n_h_err float NOT NULL, --/U dex --/D 1-sigma [N/H] dispersion  27  
    o_h float NOT NULL, --/U dex --/D Mean [O/H]  28  
    o_h_err float NOT NULL, --/U dex --/D 1-sigma [O/H] dispersion   29  
    na_h float NOT NULL, --/U dex --/D Mean [Na/H]  30  
    na_h_err float NOT NULL, --/U dex --/D 1-sigma [Na/H] dispersion  31  
    mg_h float NOT NULL, --/U dex --/D Mean [Mg/H] 32  
    mg_h_err float NOT NULL, --/U dex --/D 1-sigma [Mg/H] dispersion  33  
    al_h float NOT NULL, --/U dex --/D Mean [Al/H] 34  
    al_h_err float NOT NULL, --/U dex --/D 1-sigma [Al/H] dispersion  35  
    si_h float NOT NULL, --/U dex --/D Mean [Si/H]  36  
    si_h_err float NOT NULL, --/U dex --/D 1-sigma [Si/H] dispersion   37  
    p_h float NOT NULL, --/U dex --/D Mean [P/H] 38  
    p_h_err float NOT NULL, --/U dex --/D 1-sigma [P/H] dispersion   39  
    s_h float NOT NULL, --/U dex --/D Mean [S/H] 40  
    s_h_err float NOT NULL, --/U dex --/D 1-sigma [S/H] dispersion   41  
    k_h float NOT NULL, --/U dex --/D Mean [K/H]  42  
    k_h_err float NOT NULL, --/U dex --/D 1-sigma [K/H] dispersion   43  
    ca_h float NOT NULL, --/U dex --/D Mean [Ca/H]  44  
    ca_h_err float NOT NULL, --/U dex --/D 1-sigma [Ca/H] dispersion   45  
    ti_h float NOT NULL, --/U dex --/D Mean [Ti/H]  46  
    ti_h_err float NOT NULL, --/U dex --/D 1-sigma [Ti/H] dispersion   47  
    v_h float NOT NULL, --/U dex --/D Mean [V/H]  48  
    v_h_err float NOT NULL, --/U dex --/D 1-sigma [V/H] dispersion   49  
    cr_h float NOT NULL, --/U dex --/D Mean [Cr/H] 50  
    cr_h_err float NOT NULL, --/U dex --/D 1-sigma [Cr/H] dispersion   51  
    mn_h float NOT NULL, --/U dex --/D Mean [Mn/H] 52  
    mn_h_err float NOT NULL, --/U dex --/D 1-sigma [Mn/H] dispersion   53  
    fe_h float NOT NULL, --/U dex --/D Mean [Fe/H]  54  
    fe_h_err float NOT NULL, --/U dex --/D 1-sigma [Fe/H] dispersion   55  
    co_h float NOT NULL, --/U dex --/D Mean [Co/H]  56  
    co_h_err float NOT NULL, --/U dex --/D 1-sigma [Co/H] dispersion   57  
    ni_h float NOT NULL, --/U dex --/D Mean [Ni/H]  58  
    ni_h_err float NOT NULL, --/U dex --/D 1-sigma [Ni/H] dispersion   59  
    cu_h float NOT NULL, --/U dex --/D Mean [Cu/H] 60  
    cu_h_err float NOT NULL, --/U dex --/D 1-sigma [Cu/H] dispersion   61  
    ce_h float NOT NULL, --/U dex --/D Mean [Ce/H]  62  
    ce_h_err float NOT NULL, --/U dex --/D 1-sigma [Ce/H] dispersion   63  
    nd_h float NOT NULL, --/U dex --/D Mean [Nd/H]  64  
    nd_h_err float NOT NULL, --/U dex --/D 1-sigma [Nd/H] dispersion 65  
    num_stars_aspcap bigint NOT NULL, --/U --- --/D Number of cluster members as determined using the ASPCAP pipeline [Fe/H]  66  
    occam_qual bigint NOT NULL, --/U --- --/D Visual CMD quality Flag; 4: calibration, 3: high quality >5 stars, 2: high quality 2-4 stars, 1: good 1 star 67
    eh_rad float NOT NULL, --/U deg --/D Total radius of the cluster including tidal tails from Hunt and Reffert 2023  68  
    eh_pmra float NOT NULL, --/U mas/yr --/D Mean proper motion in RA multiplied by cos(DE) from Hunt & Reffert 2023  69  
    eh_pmra_err float NOT NULL, --/U mas/yr --/D Standard error of EH_PMRA from Hunt & Reffert 2023  70  
    eh_pmde float NOT NULL, --/U mas/yr --/D Mean proper motion in DE from Hunt & Reffert 2023  71  
    eh_pmde_err float NOT NULL, --/U mas/yr --/D Standard error in EH_PMDE from Hunt & Reffert 2023  72  
    eh_r_gc float NOT NULL, --/U kpc --/D Distance from the Galactic center using distances from Hunt & Reffert 2023  73  
    eh_distpc float NOT NULL, --/U pc --/D Distance from solar neighborbood from Hunt & Reffert 2023  74  
    eh_logage float NOT NULL --/U yr --/D logAge of the cluster from Hunt & Reffert 2023 75  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'occam_member')
	DROP TABLE occam_member
GO
--
EXEC spSetDefaultFileGroup 'occam_member'
GO
--// Created from $APOGEE_OCCAM/occam_member-DR19.fits
CREATE TABLE occam_member (
-------------------------------------------------------------------------------
--/H The OCCAM member summary table provides positional, identification, and
--/H membership information for 1196 candidate open cluster member stars.
-------------------------------------------------------------------------------
--/T The OCCAM member summary table provides the proper motion membership
--/T probabilities from Cantat-Gaudin et al. 2020 and Hunt and Reffert 2023 alongside
--/T the radial velocity and [Fe/H] membership probabilities from MWM/APOGEE. Basic
--/T postional information is included with source IDs from Gaia DR2/3 and SDSS-V DR19
--/T for each star in the table.
-------------------------------------------------------------------------------
    cluster varchar(20) NOT NULL, --/U --- --/D Open cluster name   1  
    sdss_id bigint NOT NULL, --/U --- --/D Internal SDSS-V source ID   2  
    gaiadr3_id bigint NOT NULL, --/U --- --/D Gaia DR3 source ID   3  
    gaiadr2_id bigint NOT NULL, --/U --- --/D Gaia DR2 source ID   4  
    obj_id varchar(40) NOT NULL, --/U --- --/D DR17 APOGEE ID 5  
    glon real NOT NULL, --/U deg --/D Galactic longitude   6  
    glat real NOT NULL, --/U deg --/D Galactic latitude   7  
    radeg float NOT NULL, --/U deg --/D Right ascencion   8  
    dedeg float NOT NULL, --/U deg --/D Declination   9  
    v_rad real NOT NULL, --/U km/s --/D Average radial velocity  10  
    e_v_rad real NOT NULL, --/U km/s --/D Standard error in radial velocity measurements 11  
    std_v_rad real NOT NULL, --/U km/s --/D 1-sigma radial velocity scatter  12  
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA  13  
    e_pmra real NOT NULL, --/U mas/yr --/D Standard error of proper motion in RA  14  
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in declination 15  
    e_pmde real NOT NULL, --/U mas/yr --/D Standard error of proper motion in declination  16  
    feh_aspcap float NOT NULL, --/U dex --/D [Fe/H] from the ASPCAP pipeline  17
    e_feh_aspcap float NOT NULL, --/U dex --/D 1-sigma [Fe/H] dispersion  18  
    cg_prob float NOT NULL, --/U --- --/D Membership probability from Cantat-Gaudin et. al 2020  19  
    rv_prob float NOT NULL, --/U --- --/D OCCAM RV membership probability  20  
    feh_prob_aspcap float NOT NULL, --/U --- --/D OCCAM ASPCAP [Fe/H] membership probability 21  
    eh_prob float NOT NULL, --/U --- --/D Membership probability from Hunt & Reffert 2023 22  
    xmatch tinyint NOT NULL --/U --- --/D An unsigned integer to indicate whether a individual star has been observed by Galah, GaiaESO or OCCASO. The first bit corresponds to Galah, second to GaiaESO, and the thrid to OCCASO.  23  
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'StarFlow_summary')
	DROP TABLE StarFlow_summary
GO
--
EXEC spSetDefaultFileGroup 'StarFlow_summary'
GO
--// Created from HDU 1 in $MWM_STARFLOW/v1_0_0/StarFlow_summary_v1_0_0.fits
CREATE TABLE StarFlow_summary (
    ------- 
    --/H Summary table of age and mass posteriors with the maximum liklihood and corresponding errorbars
    --/T Stellar age and mass estimates for 378,720 evolved stars from SDSS-V DR19, derived using a
    --/T normalizing flow model trained on asteroseismic data. Each entry includes maximum likelihood
    --/T age and mass estimates, 1σ uncertainties, and a training space density metric indicating the
    --/T models confidence based on parameter coverage.
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D Unique SDSS-V ID  
    sdss4_apogee_id varchar(20) NOT NULL, --/U  --/D 2MASS ID 
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    age float NOT NULL, --/U Gyr --/D Maximum likelihood age from the StarFlow age mo  
    e_p_age float NOT NULL, --/U Gyr --/D Upper age uncertainty  
    e_n_age float NOT NULL, --/U Gyr --/D Lower age uncertainty  
    mass float NOT NULL, --/U Solar Mass --/D Maximum likelihood mass from the StarFlow mass  
    e_p_mass float NOT NULL, --/U Solar Mass --/D Upper mass uncertainty  
    e_n_mass float NOT NULL, --/U Solar Mass --/D Lower mass uncertainty  
    training_density float NOT NULL, --/U  --/D Training density value. Describes how well samp  
    bitmask bigint NOT NULL, --/U  --/D Contains flags to indicate notes about a given  
    PK int NOT NULL,
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'DL1_eROSITA_eRASS1')
	DROP TABLE DL1_eROSITA_eRASS1
GO
--
EXEC spSetDefaultFileGroup 'DL1_eROSITA_eRASS1'
GO
--// Created from HDU 1 in $DL1_SDSS_EROSITA/v1_0_2/DL1_spec_SDSSV_IPL3_eROSITA_eRASS1.fits
CREATE TABLE DL1_eROSITA_eRASS1 (
    ------- 
    --/H SDSS and eROSITA data of the sources within the SPIDERS program
    --/T Data Level 1 contains the data shared among the collaborations of SDSS and eROSITA, with optical and X-ray information
    --/T of sources that were detected with eROSITA and followed-up with SDSS
    -------
    sdss_catalogid bigint NOT NULL, --/U  --/D SDSS CATALOGID (used before the unification with SDSS_ID)  
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID (unified for DR19)  
    sdss_field bigint NOT NULL, --/U  --/D SDSS field sequence number  
    sdss_mjd bigint NOT NULL, --/U day --/D SDSS modified Julian date of observation  
    sdss_objtype varchar(20) NOT NULL, --/U  --/D SDSS object type  
    sdss_fiber_ra float NOT NULL, --/U degree --/D SDSS fiber position coordinate: right ascension  
    sdss_fiber_dec float NOT NULL, --/U degree --/D SDSS fiber position coordinate: declination  
    sdss_z real NOT NULL, --/U  --/D SDSS best redshift fit  
    sdss_z_err real NOT NULL, --/U  --/D SDSS redshift error  
    sdss_zwarning bigint NOT NULL, --/U  --/D SDSS redshift measurement warning flag  
    sdss_sn_median_all real NOT NULL, --/U  --/D SDSS median Signal to Noise over the entire spectral range  
    sdss_class varchar(10) NOT NULL, --/U  --/D SDSS best fit spectroscopic classification  
    sdss_subclass varchar(30) NOT NULL, --/U  --/D SDSS subclass  
    sdss_obs varchar(10) NOT NULL, --/U  --/D SDSS observatory (APO or LCO)  
    sdss_run2d varchar(10) NOT NULL, --/U  --/D Tagged version of idlspec2d that was used to reduce the SDSS BOSS spectra  
    sdss_nspec smallint NOT NULL, --/U  --/D Number of observed SDSS spectra  
    sdss_vrad_astra real NOT NULL, --/U km/s --/D ASTRA stellar fit: Radial velocity  
    sdss_evrad_astra real NOT NULL, --/U km/s --/D ASTRA stellar fit: Radial velocity error  
    sdss_teff_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Effective temperature  
    sdss_eteff_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Effective temperature error  
    sdss_logg_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Surface gravity  
    sdss_elogg_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Surface gravity error  
    sdss_feh_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Metallicity [Fe/H]  
    sdss_efeh_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Metallicity [Fe/H] error  
    sdss_ewha_astra real NOT NULL, --/U  --/D ASTRA stellar fit: H alpha equivalent width  
    sdss_eewha_astra_0 real NOT NULL, --/F sdss_eewha_astra 0 --/U  --/D ASTRA stellar fit: H alpha equivalent width error (percentiles)  Measurements specifically for 0.  
    sdss_eewha_astra_1 real NOT NULL, --/F sdss_eewha_astra 1 --/U  --/D ASTRA stellar fit: H alpha equivalent width error (percentiles)  Measurements specifically for 1.  
    sdss_eewha_astra_2 real NOT NULL, --/F sdss_eewha_astra 2 --/U  --/D ASTRA stellar fit: H alpha equivalent width error (percentiles)  Measurements specifically for 2.  
    gaia_bp real NOT NULL, --/U Vega mag --/D Gaia DR2 BP passband  
    gaia_rp real NOT NULL, --/U Vega mag --/D Gaia DR2 RP passband  
    gaia_g real NOT NULL, --/U Vega mag --/D Gaia DR2 G passband  
    racat float NOT NULL, --/U degree --/D Right ascension of the SDSS-V target, as derived from external catalogs  
    deccat float NOT NULL, --/U degree --/D Declination of the SDSS-V target, as derived from external catalogs  
    coord_epoch real NOT NULL, --/U  --/D Coordinate epoch of the SDSS-V target, as derived from external catalogs  
    pmra real NOT NULL, --/U mas/yr --/D Proper Motion in right ascension of the SDSS-V target, as derived from external catalogs  
    pmdec real NOT NULL, --/U mas/yr --/D Proper Motion in declination of the SDSS-V target, as derived from external catalogs  
    parallax real NOT NULL, --/U mas --/D Parallax of the SDSS-V target, as derived from external catalogs  
    wise_mag_0 real NOT NULL, --/F wise_mag 0 --/U  --/D WISE photometry (W1, W2, W3, W4)  Measurements specifically for 0.  
    wise_mag_1 real NOT NULL, --/F wise_mag 1 --/U  --/D WISE photometry (W1, W2, W3, W4)  Measurements specifically for 1.  
    wise_mag_2 real NOT NULL, --/F wise_mag 2 --/U  --/D WISE photometry (W1, W2, W3, W4)  Measurements specifically for 2.  
    wise_mag_3 real NOT NULL, --/F wise_mag 3 --/U  --/D WISE photometry (W1, W2, W3, W4)  Measurements specifically for 3.  
    twomass_mag_0 real NOT NULL, --/F twomass_mag 0 --/U  --/D 2MASS photometry (J, H, Ks)  Measurements specifically for 0.  
    twomass_mag_1 real NOT NULL, --/F twomass_mag 1 --/U  --/D 2MASS photometry (J, H, Ks)  Measurements specifically for 1.  
    twomass_mag_2 real NOT NULL, --/F twomass_mag 2 --/U  --/D 2MASS photometry (J, H, Ks)  Measurements specifically for 2.  
    guvcat_mag_0 real NOT NULL, --/F guvcat_mag 0 --/U  --/D GALEX UV photometry (FUV, NUV)  Measurements specifically for 0.  
    guvcat_mag_1 real NOT NULL, --/F guvcat_mag 1 --/U  --/D GALEX UV photometry (FUV, NUV)  Measurements specifically for 1.  
    ero_detuid varchar(40) NOT NULL, --/U  --/D eROSITA unique X-ray source identifier  
    ero_ra float NOT NULL, --/U degree --/D eROSITA position estimate: right ascension  
    ero_dec float NOT NULL, --/U degree --/D eROSITA position estimate: declination  
    ero_pos_err float NOT NULL, --/U arcsec --/D eROSITA positional error  
    ero_mjd int NOT NULL, --/U day --/D eROSITA modified Julian date of observation  
    ero_mjd_flag smallint NOT NULL, --/U  --/D eROSITA MJD flag (1 for sources close to the boundaries of the survey)  
    ero_morph varchar(10) NOT NULL, --/U  --/D eROSITA source morphological classification (point-like or extended)  
    ero_flux real NOT NULL, --/U erg/s/cm^2 --/D eROSITA flux  
    ero_flux_err real NOT NULL, --/U erg/s/cm^2 --/D eROSITA flux error  
    ero_det_like real NOT NULL, --/U  --/D eROSITA source detection likelihood in the given band  
    ero_flux_type varchar(10) NOT NULL, --/U keV --/D eROSITA band for the given flux  
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'DL1_eROSITA_eRASS1_allepoch')
	DROP TABLE DL1_eROSITA_eRASS1_allepoch
GO
--
EXEC spSetDefaultFileGroup 'DL1_eROSITA_eRASS1_allepoch'
GO
--// Created from HDU 1 in $DL1_SDSS_EROSITA/v1_0_2/DL1_spec_SDSSV_IPL3_eROSITA_eRASS1_allepoch.fits
CREATE TABLE DL1_eROSITA_eRASS1_allepoch (
    ------- 
    --/H SDSS and eROSITA data of the sources within the SPIDERS program (allepoch)
    --/T Data Level 1 contains the data shared among the collaborations of SDSS and eROSITA, with optical and X-ray information
    --/T of sources that were detected with eROSITA and followed-up with SDSS (allepoch)
    ------- 
    sdss_catalogid bigint NOT NULL, --/U  --/D SDSS CATALOGID (used before the unification with SDSS_ID)  
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID (unified for DR19)  
    sdss_field bigint NOT NULL, --/U  --/D SDSS field sequence number  
    sdss_mjd bigint NOT NULL, --/U day --/D SDSS modified Julian date of observation  
    sdss_objtype varchar(20) NOT NULL, --/U  --/D SDSS object type  
    sdss_fiber_ra float NOT NULL, --/U degree --/D SDSS fiber position coordinate: right ascension  
    sdss_fiber_dec float NOT NULL, --/U degree --/D SDSS fiber position coordinate: declination  
    sdss_z real NOT NULL, --/U  --/D SDSS best redshift fit  
    sdss_z_err real NOT NULL, --/U  --/D SDSS redshift error  
    sdss_zwarning bigint NOT NULL, --/U  --/D SDSS redshift measurement warning flag  
    sdss_sn_median_all real NOT NULL, --/U  --/D SDSS median Signal to Noise over the entire spectral range  
    sdss_class varchar(10) NOT NULL, --/U  --/D SDSS best fit spectroscopic classification  
    sdss_subclass varchar(30) NOT NULL, --/U  --/D SDSS subclass  
    sdss_obs varchar(10) NOT NULL, --/U  --/D SDSS observatory (APO or LCO)  
    sdss_run2d varchar(10) NOT NULL, --/U  --/D Tagged version of idlspec2d that was used to reduce the SDSS BOSS spectra  
    sdss_nspec bigint NOT NULL, --/U  --/D Number of observed SDSS spectra  
    sdss_vrad_astra real NOT NULL, --/U km/s --/D ASTRA stellar fit: Radial velocity  
    sdss_evrad_astra real NOT NULL, --/U km/s --/D ASTRA stellar fit: Radial velocity error  
    sdss_teff_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Effective temperature  
    sdss_eteff_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Effective temperature error  
    sdss_logg_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Surface gravity  
    sdss_elogg_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Surface gravity error  
    sdss_feh_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Metallicity [Fe/H]  
    sdss_efeh_astra real NOT NULL, --/U  --/D ASTRA stellar fit: Metallicity [Fe/H] error  
    sdss_ewha_astra real NOT NULL, --/U  --/D ASTRA stellar fit: H alpha equivalent width  
    sdss_eewha_astra_0 real NOT NULL, --/F sdss_eewha_astra 0 --/U  --/D ASTRA stellar fit: H alpha equivalent width error (percentiles)  Measurements specifically for 0.  
    sdss_eewha_astra_1 real NOT NULL, --/F sdss_eewha_astra 1 --/U  --/D ASTRA stellar fit: H alpha equivalent width error (percentiles)  Measurements specifically for 1.  
    sdss_eewha_astra_2 real NOT NULL, --/F sdss_eewha_astra 2 --/U  --/D ASTRA stellar fit: H alpha equivalent width error (percentiles)  Measurements specifically for 2.  
    gaia_bp real NOT NULL, --/U Vega mag --/D Gaia DR2 BP passband  
    gaia_rp real NOT NULL, --/U Vega mag --/D Gaia DR2 RP passband  
    gaia_g real NOT NULL, --/U Vega mag --/D Gaia DR2 G passband  
    racat float NOT NULL, --/U degree --/D Right ascension of the SDSS-V target, as derived from external catalogs  
    deccat float NOT NULL, --/U degree --/D Declination of the SDSS-V target, as derived from external catalogs  
    coord_epoch real NOT NULL, --/U  --/D Coordinate epoch of the SDSS-V target, as derived from external catalogs  
    pmra real NOT NULL, --/U mas/yr --/D Proper Motion in right ascension of the SDSS-V target, as derived from external catalogs  
    pmdec real NOT NULL, --/U mas/yr --/D Proper Motion in declination of the SDSS-V target, as derived from external catalogs  
    parallax real NOT NULL, --/U mas --/D Parallax of the SDSS-V target, as derived from external catalogs  
    wise_mag_0 real NOT NULL, --/F wise_mag 0 --/U  --/D WISE photometry (W1, W2, W3, W4)  Measurements specifically for 0.  
    wise_mag_1 real NOT NULL, --/F wise_mag 1 --/U  --/D WISE photometry (W1, W2, W3, W4)  Measurements specifically for 1.  
    wise_mag_2 real NOT NULL, --/F wise_mag 2 --/U  --/D WISE photometry (W1, W2, W3, W4)  Measurements specifically for 2.  
    wise_mag_3 real NOT NULL, --/F wise_mag 3 --/U  --/D WISE photometry (W1, W2, W3, W4)  Measurements specifically for 3.  
    twomass_mag_0 real NOT NULL, --/F twomass_mag 0 --/U  --/D 2MASS photometry (J, H, Ks)  Measurements specifically for 0.  
    twomass_mag_1 real NOT NULL, --/F twomass_mag 1 --/U  --/D 2MASS photometry (J, H, Ks)  Measurements specifically for 1.  
    twomass_mag_2 real NOT NULL, --/F twomass_mag 2 --/U  --/D 2MASS photometry (J, H, Ks)  Measurements specifically for 2.  
    guvcat_mag_0 real NOT NULL, --/F guvcat_mag 0 --/U  --/D GALEX UV photometry (FUV, NUV)  Measurements specifically for 0.  
    guvcat_mag_1 real NOT NULL, --/F guvcat_mag 1 --/U  --/D GALEX UV photometry (FUV, NUV)  Measurements specifically for 1.  
    ero_detuid varchar(40) NOT NULL, --/U  --/D eROSITA unique X-ray source identifier  
    ero_ra float NOT NULL, --/U degree --/D eROSITA position estimate: right ascension  
    ero_dec float NOT NULL, --/U degree --/D eROSITA position estimate: declination  
    ero_pos_err float NOT NULL, --/U arcsec --/D eROSITA positional error  
    ero_mjd int NOT NULL, --/U day --/D eROSITA modified Julian date of observation  
    ero_mjd_flag smallint NOT NULL, --/U  --/D eROSITA MJD flag (1 for sources close to the boundaries of the survey)  
    ero_morph varchar(10) NOT NULL, --/U  --/D eROSITA source morphological classification (point-like or extended)  
    ero_flux real NOT NULL, --/U erg/s/cm^2 --/D eROSITA flux  
    ero_flux_err real NOT NULL, --/U erg/s/cm^2 --/D eROSITA flux error  
    ero_det_like real NOT NULL, --/U  --/D eROSITA source detection likelihood in the given band  
    ero_flux_type varchar(10) NOT NULL, --/U keV --/D eROSITA band for the given flux  
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
--// Created from HDU 1 in $APOGEE_STARHORSE/APOGEE_mos_DR3_STARHORSE_v2.fits
CREATE TABLE apogee_starhorse (
    ------- 
    --/H StarHorse results for the SDSS-V DR19 APOGEE giants
    --/T This file contains spectro-photo-astrometric distances, extinctions, and stellar parameters such as temperature,
    --/T masses and metallicity for giant stars with the SDSS-V DR19 APOGEE spectroscopy using the StarHorse code
    --/T Queiroz et al. 2018 (https://ui.adsabs.harvard.edu/abs/2018MNRAS.476.2556Q/abstract,
    --/T Queiroz et al. 2023 https://ui.adsabs.harvard.edu/abs/2023A%26A...673A.155Q/abstract). Parameters are estimated
    --/T for each unique sdss_id in the data release, provided the StarHorse code successfully converges. If a star has
    --/T multiple sdss_ids, the ASPCAP results with the highest signal-to-noise ratio (snr) are used. For each star, StarHorse
    --/T computes the joint posterior probability distribution function (PDF) over a grid of PARSEC 1.2S stellar models, using
    --/T input values including ASPCAP-derived effective temperature, surface gravity, metallicity, and alpha-element abundance,
    --/T as well as Gaia DR3 parallaxes (when available), and multi-band photometry from Pan-STARRS1, 2MASS, and AllWISE. ASPCAP
    --/T effective temperature and surface gravity are calibrated before input to StarHorse. Calibration details are described
    --/T in the SDSS DR19 main publication. The VAC includes median values of marginalized PDFs for mass, temperature, surface
    --/T gravity, metallicity, distance, and extinction. The StarHorse_INPUTFLAGS column indicates the input data used, while
    --/T StarHorse_OUTFLAGS flags possibly uncertain outputs. Calibrated temperature and surface gravity are also included.
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    dr3_source_id bigint NOT NULL, --/U  --/D Gaia-DR3 source id  
    glon real NOT NULL, --/U deg --/D Galactic Longitude  
    glat real NOT NULL, --/U deg --/D Galactic Latitude  
    ra real NOT NULL, --/U deg --/D Right Ascention J2000  
    dec real NOT NULL, --/U deg --/D Declination J2000  
    logg_shcalib real NOT NULL, --/U dex --/D StarHorse calibrated spectroscopic surface gravity  
    teff_shcalib real NOT NULL, --/U K --/D StarHorse calibrated spectroscopic effective temperature  
    mass16 real NOT NULL, --/U solar masses --/D StarHorse 16th astro-spectro-photometric mass percentile (Queiroz et al. 2018)  
    mass50 real NOT NULL, --/U solar masses --/D StarHorse median astro-spectro-photometric mass (Queiroz et al. 2018)  
    mass84 real NOT NULL, --/U solar masses --/D StarHorse 84th astro-spectro-photometric mass percentile (Queiroz et al. 2018)  
    teff16 real NOT NULL, --/U K --/D StarHorse 16th astro-spectro-photometric effective temperature percentile (Queiroz et al. 2018)  
    teff50 real NOT NULL, --/U K --/D StarHorse median astro-spectro-photometric effective temperature (Queiroz et al. 2018)  
    teff84 real NOT NULL, --/U K --/D StarHorse 84th astro-spectro-photometric effective temperature percentile (Queiroz et al. 2018)  
    logg16 real NOT NULL, --/U dex --/D StarHorse 16th astro-spectro-photometric surface gravity percentile (Queiroz et al. 2018)  
    logg50 real NOT NULL, --/U dex --/D StarHorse median astro-spectro-photometric surface gravity (Queiroz et al. 2018)  
    logg84 real NOT NULL, --/U dex --/D StarHorse 84th astro-spectro-photometric surface gravity percentile (Queiroz et al. 2018)  
    met16 real NOT NULL, --/U dex --/D StarHorse 16th astro-spectro-photometric metallicity percentile (Queiroz et al. 2018)  
    met50 real NOT NULL, --/U dex --/D StarHorse median astro-spectro-photometric metallicity (Queiroz et al. 2018)  
    met84 real NOT NULL, --/U dex --/D StarHorse 84th astro-spectro-photometric metallicity percentile (Queiroz et al. 2018)  
    dist05 real NOT NULL, --/U kpc --/D StarHorse 5th astro-spectro-photometric distance percentile (Queiroz et al. 2018)  
    dist16 real NOT NULL, --/U kpc --/D StarHorse 16th astro-spectro-photometric distance percentile (Queiroz et al. 2018)  
    dist50 real NOT NULL, --/U kpc --/D StarHorse median astro-spectro-photometric distance (Queiroz et al. 2018)  
    dist84 real NOT NULL, --/U kpc --/D StarHorse 84th astro-spectro-photometric distance percentile (Queiroz et al. 2018)  
    dist95 real NOT NULL, --/U kpc --/D StarHorse 95th astro-spectro-photometric distance percentile (Queiroz et al. 2018)  
    av05 real NOT NULL, --/U mag --/D StarHorse 5th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)  
    av16 real NOT NULL, --/U mag --/D StarHorse 16th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)  
    av50 real NOT NULL, --/U mag --/D StarHorse median posterior extinction (at 542 nm) (Queiroz et al. 2018)  
    av84 real NOT NULL, --/U mag --/D StarHorse 84th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)  
    av95 real NOT NULL, --/U mag --/D StarHorse 95th posterior extinction (at 542 nm) percentile (Queiroz et al. 2018)  
    starhorse_inputflags varchar(80) NOT NULL, --/U  --/D StarHorse Input flags (Queiroz et al. 2023)  
    starhorse_outputflags varchar(80) NOT NULL, --/U  --/D StarHorse Output flags (Queiroz et al. 2023)  
)
GO



-- revert to primary file group
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[VacTables.sql]: VAC tables created'
GO


