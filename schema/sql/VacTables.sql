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


-- revert to primary file group
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[VacTables.sql]: VAC tables created'
GO


