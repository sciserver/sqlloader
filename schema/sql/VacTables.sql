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
--* 2026-07-15  Ani: Swapped in the DR20 VACs, from: 
--*                  https://github.com/sdss/casload/blob/DR20_VAC_??/sql/[MWM|BHM]/
--*                  Also updated table and column names as necessary. 
--* 2026-07-22  Ani: Refreshed schema for VAC-27 (spiders AGN) tables. (DR20)
--* 2026-07-27  Ani: Reinstated the DR19 VACs which got deleted by mistake. (DR20)
--* 2026-07-28  Ani: Refreshed schema (column descriptions only) for VAC-36
--*                  (boss_clam_lite) table. (DR20)
--* 2026-07-28  Swerner: Added the 7 eROSITA DR1 tables (efeds_c001_*,
--*             erass1_*, salvato_etal2025_dr1_ls10) from
--*             casload/sql/erosita/dr1. They are loaded in BestDR20 but
--*             had no metadata -- previously added and overwritten. (DR20)
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



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'boss_clam_lite')
	DROP TABLE boss_clam_lite
GO
--
EXEC spSetDefaultFileGroup 'boss_clam_lite'
GO

CREATE TABLE boss_clam_lite (
---------------------------------------------------------------- 
--/H Stellar Parameters from BOSS Spectra with The CLAM
-----------------------------------------------------------------
--/T BOSS-CLAM is a data driven method that maps labels to NMF basis weights to 
--/T forward model continuum normalized BOSS spectra. This model was training 
--/T with labels from ASPCAP, BOSS-MINESweeper, wide binaries and a validation 
--/T set of hot stars. This is the lite version of the VAC includes the 
--/T inferened stellar parameters from all mwmStar BOSS spectra with snr > 10,  
--/T a series of flags to clean the dataset, and a subset of meta-data from 
--/T mwmAllStar. 
---------------------------------------------------------------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier 
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier 
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier 
    ra real NOT NULL, --/U deg --/D Right ascension 
    dec real NOT NULL, --/U deg --/D Declination 
    l real NOT NULL, --/U deg --/D Galactic longitude 
    b real NOT NULL, --/U deg --/D Galactic latitude 
    plx real NOT NULL, --/U mas --/D Parallax 
    e_plx real NOT NULL, --/U mas --/D Error on parallax 
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA 
    e_pmra real NOT NULL, --/U mas/yr --/D Error on proper motion in RA 
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in DEC 
    e_pmde real NOT NULL, --/U mas/yr --/D Error on proper motion in DEC 
    g_mag real NOT NULL, --/U mag --/D Gaia DR3 mean G band magnitude 
    bp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean BP band magnitude 
    rp_mag real NOT NULL, --/U mag --/D Gaia DR3 mean RP band magnitude 
    j_mag real NOT NULL, --/U mag --/D 2MASS J band magnitude 
    h_mag real NOT NULL, --/U mag --/D 2MASS H band magnitude 
    k_mag real NOT NULL, --/U mag --/D 2MASS K band magnitude 
    r_med_geo real NOT NULL, --/U pc --/D Median geometric distance 
    r_med_photogeo real NOT NULL, --/U pc --/D 50th percentile of photogeometric distance 
    bailer_jones_flags varchar(8) NOT NULL, --/U  --/D Bailer-Jones quality flags 
    ebv real NOT NULL, --/U mag --/D E(B-V) 
    e_ebv real NOT NULL, --/U mag --/D Error on E(B-V) 
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V) 
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits 
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits 
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits 
    telescope varchar(9) NOT NULL, --/U  --/D Short telescope name 
    n_good_visits int NOT NULL, --/U  --/D Number of 'good' BOSS visits 
    n_good_rvs int NOT NULL, --/U  --/D Number of 'good' BOSS radial velocities 
    v_rad real NOT NULL, --/U km/s --/D Barycentric rest frame radial velocity 
    e_v_rad real NOT NULL, --/U km/s --/D Error on radial velocity 
    std_v_rad real NOT NULL, --/U km/s --/D Standard deviation of visit V_RAD 
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio 
    teff float NOT NULL, --/U K --/D BOSS-CLAM effective temperature 
    logg float NOT NULL, --/U  --/D BOSS-CLAM log(g) 
    fe_h float NOT NULL, --/U  --/D BOSS-CLAM [Fe/H] 
    alpha_m float NOT NULL, --/U  --/D BOSS-CLAM [alpha/M] 
    param_covariance_1_1 float NOT NULL, --/F param_covariance 0 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 1_1) 
    param_covariance_1_2 float NOT NULL, --/F param_covariance 1 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 1_2) 
    param_covariance_1_3 float NOT NULL, --/F param_covariance 2 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 1_3) 
    param_covariance_1_4 float NOT NULL, --/F param_covariance 3 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 1_4) 
    param_covariance_2_1 float NOT NULL, --/F param_covariance 4 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 2_1) 
    param_covariance_2_2 float NOT NULL, --/F param_covariance 5 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 2_2) 
    param_covariance_2_3 float NOT NULL, --/F param_covariance 6 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 2_3) 
    param_covariance_2_4 float NOT NULL, --/F param_covariance 7 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 2_4) 
    param_covariance_3_1 float NOT NULL, --/F param_covariance 8 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 3_1) 
    param_covariance_3_2 float NOT NULL, --/F param_covariance 9 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 3_2) 
    param_covariance_3_3 float NOT NULL, --/F param_covariance 10 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 3_3) 
    param_covariance_3_4 float NOT NULL, --/F param_covariance 11 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 3_4) 
    param_covariance_4_1 float NOT NULL, --/F param_covariance 12 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 4_1) 
    param_covariance_4_2 float NOT NULL, --/F param_covariance 13 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 4_2) 
    param_covariance_4_3 float NOT NULL, --/F param_covariance 14 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 4_3) 
    param_covariance_4_4 float NOT NULL, --/F param_covariance 15 --/U  --/D Covariance matrix for the parameters. Order is [teff, logg, fe_h, alpha_m] (array element 4_4) 
    rchi2 float NOT NULL, --/U  --/D Reduced chi^2 between BOSS spectrum and forward modeled CLAM spectrum 
    clam_flags bigint NOT NULL, --/U  --/D Bitmask indicating potentially unreliable or out-of-distribution BOSS-CLAM results. Flags include: IN_WD (0): likely white dwarf in mwm_wd not represented in the training set; IN_YSO (1): likely young stellar object in mwm_yso not represented in the training set; IN_OB (2): likely hot star in mwm_ob with unreliable [Fe/H] or [alpha/M] training coverage; FE_H_ALPHA_SUSPECT (3): Teff > 6500 K, where [Fe/H] and [alpha/M] are poorly constrained; BAD_SPEC_FIT (4): reduced chi^2 > 1 indicating poor forward-model fit; LOW_MASS_SUSPECT (5): Teff < 4000 K and [Fe/H] < -1 in sparsely sampled low-mass regime; FE_H_ALPHA_CORR (6): atypical correlation between [Fe/H], [alpha/M], and Teff; TEFF_LOGG_CORR (7): unphysical negative correlation between Teff and logg; LOW_MASS_TEFF_LOGG_CORR (8): weak Teff-logg correlation in low-mass stars (Teff < 4200 K); EXTREME_CORR (9): extreme correlations involving [alpha/M]; ALTER_CORR (10): alternating correlation structure relative to the bulk population.
    flag_warn bit NOT NULL, --/U  --/D If IN_OB or FE_H_ALPHA_SUSPECT is set 
    flag_bad bit NOT NULL, --/U  --/D If IN_WD, IN_YSO, BAD_SPEC_FIT, LOW_MASS_SUSPECT, FE_H_ALPHA_CORR, TEFF_LOGG_CORR, LOW_MASS_TEFF_LOGG_CORR, EXTREME_CORR o
    PK int NOT NULL, --/D Sequential row number generated during loading, used as the clustering key
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'boss_ISM_NaI_absorption')
	DROP TABLE boss_ISM_NaI_absorption
GO
--
EXEC spSetDefaultFileGroup 'boss_ISM_NaI_absorption'
GO

CREATE TABLE boss_ISM_NaI_absorption (
---------------------------------------------------------------- 
--/H Catalog of Na I D interstellar absorption equivalent widths and V-band extinctions measured from SDSS-V DR20 BOSS spectra.
-----------------------------------------------------------------
--/T This VAC provides measurements of the Na I D (5889.95/5895.92 Ã…) 
--/T interstellar absorption doublet and V-band dust extinction (A_V, assuming 
--/T R_V = 3.1) for 1,373,392 stellar sightlines observed with the BOSS 
--/T spectrograph as part of the SDSS-V Milky Way Mapper program. Equivalent 
--/T widths and extinctions are derived from spectral fits via ISM-cleaned 
--/T MaStar spectra; uncertainties and fit quality (reduced chi^2) are reported 
--/T for each source. See McQuaid et al. (2026) for full methodology. 
---------------------------------------------------------------- 
    sdssid bigint NOT NULL, --/U  --/D SDSS unique object identifier 
    ra float NOT NULL, --/U deg --/D ICRS right ascension 
    dec float NOT NULL, --/U deg --/D ICRS declination 
    reduced_chi2 float NOT NULL, --/U  --/D Reduced chi-squared of fit 
    a_v float NOT NULL, --/U mag --/D Fitted V-band extinction, R_V = 3.1 
    a_v_err float NOT NULL, --/U mag --/D Uncertainty in A_V 
    nai_d_ew float NOT NULL, --/U Angstrom --/D Equivalent width of Na I D absorption 
    nai_d_ew_err float NOT NULL, --/U Angstrom --/D Uncertainty in Na I D EW 
    PK int NOT NULL, --/D Sequential row number generated during loading, used as the clustering key
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'boss_occam_cluster')
	DROP TABLE boss_occam_cluster
GO
--
EXEC spSetDefaultFileGroup 'boss_occam_cluster'
GO

CREATE TABLE boss_occam_cluster (
---------------------------------------------------------------- 
--/H The BOSS OCCAM cluster summary table provides mean cluster parameters for open clusters.
-----------------------------------------------------------------
--/T The BOSS OCCAM cluster summary table provides a comprehensive, uniform 
--/T dataset for open clusters. It contains mean 5-D astrometry from Gaia 
--/T (<a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a>), 
--/T age and distance information (<a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
--/T and <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a>), 
--/T mean orbital parameters calculated using Gala 
--/T (<a href="https://ui.adsabs.harvard.edu/abs/2017JOSS....2..388P">Adrian M. Price-Whelan 2017</a>), 
--/T an orbital dynamics code, and mean radial velocities and chemical abundances from MWM/BOSS.
---------------------------------------------------------------- 
    name varchar(20) NOT NULL, --/U  --/D Open cluster name 
    glon float NOT NULL, --/U deg --/D Galactic longitude 
    glat float NOT NULL, --/U deg --/D Galactic latitude 
    radeg float NOT NULL, --/U deg --/D Right ascension in degrees 
    dedeg float NOT NULL, --/U deg --/D Declination in degrees 
    eh_radius float NOT NULL, --/U deg --/D Total radius of the cluster including tidal tails from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    eh_pmra float NOT NULL, --/U mas/yr --/D Mean proper motion in RA multiplied by cos(DE) from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    eh_pmra_err float NOT NULL, --/U mas/yr --/D Standard error of EH_PMRA from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    eh_pmde float NOT NULL, --/U mas/yr --/D Mean proper motion in DE from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    eh_pmde_err float NOT NULL, --/U mas/yr --/D Standard error in EH_PMDE from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    v_rad float NOT NULL, --/U km/s --/D Mean radial velocity of cluster members 
    v_rad_err float NOT NULL, --/U km/s --/D 1-sigma V_RAD dispersion 
    r_gc_eh float NOT NULL, --/U kpc --/D Distance from the Galactic center using distances from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    r_gc_cav float NOT NULL, --/U kpc --/D Distance from the Galactic center from <a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    eh_logage float NOT NULL, --/U yr --/D logAge of the cluster from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    cav_logage float NOT NULL, --/U yr --/D logAge of the cluster from <a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    r_guide float NOT NULL, --/U kpc --/D Guiding Center radius 
    z_height float NOT NULL, --/U kpc --/D Current Z position from orbit calculations 
    z_max float NOT NULL, --/U kpc --/D Maximum Z position from orbit calculations 
    azimuth_angle float NOT NULL, --/U deg --/D Azimuthal angle relative to Galactic center 
    eccentricity float NOT NULL, --/U  --/D Average eccentricity of calculated cluster orbits 
    z_period_avg float NOT NULL, --/U Myr --/D Average period in the Z coordinate 
    radial_period_avg float NOT NULL, --/U Myr --/D Average radial period of the cluster 
    fe_h float NOT NULL, --/U dex --/D Mean [Fe/H] 
    fe_h_err float NOT NULL, --/U dex --/D 1-sigma [Fe/H] dispersion 
    alpha_m float NOT NULL, --/U dex --/D Mean [alpha/M] 
    alpha_m_err float NOT NULL, --/U dex --/D 1-sigma [alpha/M] dispersion 
    num_full_members bigint NOT NULL, --/U  --/D Number of full cluster members (PM, RV and [Fe/H]) 
    num_pmrv_members bigint NOT NULL, --/U  --/D Number of cluster proper motion and radial velocity members 
    occam_qual bigint NOT NULL, --/U  --/D Visual CMD quality Flag; 1: less than 5 stars 2: 5 or more stars 
    cav_qual bigint NOT NULL, --/U  --/D Quality flag from <a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    eh_dist float NOT NULL, --/U pc --/D Distance from solar neighborhood from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    cav_dist float NOT NULL, --/U pc --/D Distance from solar neighborhood from <a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    x float NOT NULL, --/U pc --/D Galactocentric X coordinate 
    y float NOT NULL, --/U pc --/D Galactocentric Y coordinate 
    z float NOT NULL, --/U pc --/D Galactocentric Z coordinate 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'boss_occam_member')
	DROP TABLE boss_occam_member
GO
--
EXEC spSetDefaultFileGroup 'boss_occam_member'
GO

CREATE TABLE boss_occam_member (
---------------------------------------------------------------- 
--/H The BOSS OCCAM member summary table provides positional, identification, and membership information for candidate open cluster member stars.
-----------------------------------------------------------------
--/T The BOSS OCCAM member summary table provides the proper motion membership 
--/T probabilities from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
--/T alongside the radial velocity and [Fe/H] membership 
--/T probabilities from BOSS/CLAM. Basic positional information is included with 
--/T source IDs from Gaia DR3 and SDSS for each star in the table. 
---------------------------------------------------------------- 
    cluster varchar(20) NOT NULL, --/U  --/D Open cluster name 
    sdss_id bigint NOT NULL, --/U  --/D Internal SDSS source ID 
    gaiadr3_id bigint NOT NULL, --/U  --/D Gaia DR3 source ID 
    glon real NOT NULL, --/U deg --/D Galactic longitude 
    glat real NOT NULL, --/U deg --/D Galactic latitude 
    radeg float NOT NULL, --/U deg --/D Right ascension in degrees 
    dedeg float NOT NULL, --/U deg --/D Declination in degrees 
    v_rad real NOT NULL, --/U km/s --/D Radial velocity from pyXCSAO (<a href="https://ui.adsabs.harvard.edu/abs/2022yCat..51640137K">Kounkel 2022</a>) 
    e_v_rad real NOT NULL, --/U km/s --/D Standard error in radial velocity measurements 
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA 
    e_pmra real NOT NULL, --/U mas/yr --/D Standard error of proper motion in RA 
    pmde real NOT NULL, --/U mas/yr --/D Proper motion in declination 
    e_pmde real NOT NULL, --/U mas/yr --/D Standard error of proper motion in declination 
    feh_clam float NOT NULL, --/U dex --/D [Fe/H] from the CLAM pipeline 
    e_feh_clam float NOT NULL, --/U dex --/D 1-sigma [Fe/H] dispersion from the CLAM pipeline 
    alpha_m_clam float NOT NULL, --/U dex --/D [Fe/H] from the CLAM pipeline 
    e_alpha_m_clam float NOT NULL, --/U dex --/D 1-sigma [alpha/M] dispersion from the CLAM pipeline 
    eh_prob float NOT NULL, --/U  --/D Membership probability from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    rv_prob float NOT NULL, --/U  --/D OCCAM RV membership probability 
    feh_prob_clam float NOT NULL, --/U  --/D OCCAM CLAM [Fe/H] membership probability 
    teff float NOT NULL, --/U K --/D Effective temperature 
    logg float NOT NULL, --/U dex --/D Surface gravity log(g) 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'boss_vi_results')
	DROP TABLE boss_vi_results
GO
--
EXEC spSetDefaultFileGroup 'boss_vi_results'
GO

CREATE TABLE boss_vi_results (
---------------------------------------------------------------- 
--/H Results from visual inspection of BOSS spectra
-----------------------------------------------------------------
--/T Catalog of redshifts/classifications/and confidence flags derived from 
--/T visual inspections of BOSS allepoch spectra, supplemented with ML 
--/T predictions of pipeline redshift reliability. 
---------------------------------------------------------------- 
    field int NOT NULL, --/U  --/D SDSS field identifier 
    mjd int NOT NULL, --/U days --/D SDSS MJD - last date the object was observed 
    catalogid bigint NOT NULL, --/U  --/D SDSS unique catalog identifier 
    sdss_id bigint NOT NULL, --/U  --/D SDSS unique object identifer 
    z_pipe real NOT NULL, --/U  --/D True if spectrum was visually inspected 
    has_vi bit NOT NULL, --/U  --/D Pipeline redshift, copied from spAll 
    z_vi real NOT NULL, --/U  --/D Visual inspection redshift, when available 
    z_conf_vi smallint NOT NULL, --/U  --/D The degree of confidence we have on z_vi 
    z_best real NOT NULL, --/U  --/D Best redshift available (from VI when available, from the pipeline otherwise). NaN when z_conf_best < 2 
    z_conf_best smallint NOT NULL, --/U  --/D The degree of confidence we have on z_best 
    class_best varchar(15) NOT NULL, --/U  --/D The best classification for this spectrum 
    z_pipe_reliable bit NOT NULL, --/U  --/D True when z_pipe is correct (via ML classifier) 
    z_best_reliable bit NOT NULL, --/U  --/D True if z_best is reliable, i.e. z_conf_best=3 (when we have a secure VI redshift, or the ML classifier says that z_pipe is reliable) 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'da_dwd_candidates')
	DROP TABLE da_dwd_candidates
GO
--
EXEC spSetDefaultFileGroup 'da_dwd_candidates'
GO

CREATE TABLE da_dwd_candidates (
---------------------------------------------------------------- 
--/H DA double white dwarf binary candidates
---------------------------------------------------------------- 
--/T Summarises the result of the analysis 
--/T to discover DA double white dwarf binary candidates in SDSS-V DR19. 
--/T We report the SDSS-ID, Gaia DR3 ID, ra, dec, and the RV variability parameter (eta).
--/T Full details of the target selection, analysis, binary candidates, 
--/T and the subsequent constraints on the binary population are presented 
--/T in <a href="https://ui.adsabs.harvard.edu/abs/2026ApJ..1002..207A">Adamane Pallathadka et al. (2026)</a>. 
---------------------------------------------------------------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID of the WD 
    gaia_dr3_id bigint NOT NULL, --/U  --/D Gaia DR3 ID of the WD 
    ra real NOT NULL, --/U deg --/D Right Ascention J2000 
    dec real NOT NULL, --/U deg --/D Declination J2000 
    eta float NOT NULL, --/U  --/D Radial Velocity variability parameter 
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'da_dwd_rvs')
	DROP TABLE da_dwd_rvs
GO
--
EXEC spSetDefaultFileGroup 'da_dwd_rvs'
GO

CREATE TABLE da_dwd_rvs (
---------------------------------------------------------------- 
--/H Radial Velocities for DA double white dwarf binary candidate observed exposures
---------------------------------------------------------------- 
--/T Summarise the result of the analysis 
--/T to discover DA double white dwarf binary candidates in SDSS-V DR19. 
--/T We report the SDSS-ID, Gaia DR3 ID, RV, RV error, and observation time
--/T Full details of the target selection, analysis, binary candidates, 
--/T and the subsequent constraints on the binary population are presented 
--/T in <a href="https://ui.adsabs.harvard.edu/abs/2026ApJ..1002..207A">Adamane Pallathadka et al. (2026)</a>.
---------------------------------------------------------------- 
    exposure_num int NOT NULL, --/U  --/D exposure number as a sequential index 
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID of the WD 
    gaia_dr3_id bigint NOT NULL, --/U  --/D Gaia DR3 ID of the WD 
    rv float NOT NULL, --/U km/s --/D Radial Velocity measured using different SDSS-V exposures 
    erv float NOT NULL, --/U km/s --/D Measured error in the radial velocity 
    tai float NOT NULL --/U s --/D Mid-exposure observation time 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'DL1_eROSITA_eRASS3_allepoch')
	DROP TABLE DL1_eROSITA_eRASS3_allepoch
GO
--
EXEC spSetDefaultFileGroup 'DL1_eROSITA_eRASS3_allepoch'
GO

CREATE TABLE DL1_eROSITA_eRASS3_allepoch (
---------------------------------------------------------------- 
--/H SDSS and eROSITA data of the sources within the SPIDERS program
-----------------------------------------------------------------
--/T Data Level 1 contains the data shared among the collaborations of SDSS and 
--/T eROSITA, with optical and X-ray information of sources that were detected 
--/T with eROSITA and followed-up with SDSS 
---------------------------------------------------------------- 
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
    wise_mag_1 real NOT NULL, --/F wise_mag 0 --/U AB mag --/D WISE photometry (W1, W2, W3, W4) (array element 1) 
    wise_mag_2 real NOT NULL, --/F wise_mag 1 --/U AB mag --/D WISE photometry (W1, W2, W3, W4) (array element 2) 
    wise_mag_3 real NOT NULL, --/F wise_mag 2 --/U AB mag --/D WISE photometry (W1, W2, W3, W4) (array element 3) 
    wise_mag_4 real NOT NULL, --/F wise_mag 3 --/U AB mag --/D WISE photometry (W1, W2, W3, W4) (array element 4) 
    twomass_mag_1 real NOT NULL, --/F twomass_mag 0 --/U Vega mag --/D 2MASS photometry (J, H, Ks) (array element 1) 
    twomass_mag_2 real NOT NULL, --/F twomass_mag 1 --/U Vega mag --/D 2MASS photometry (J, H, Ks) (array element 2) 
    twomass_mag_3 real NOT NULL, --/F twomass_mag 2 --/U Vega mag --/D 2MASS photometry (J, H, Ks) (array element 3) 
    guvcat_mag_1 real NOT NULL, --/F guvcat_mag 0 --/U AB mag --/D GALEX UV photometry (FUV, NUV) (array element 1) 
    guvcat_mag_2 real NOT NULL, --/F guvcat_mag 1 --/U AB mag --/D GALEX UV photometry (FUV, NUV) (array element 2) 
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
    ero_version varchar(6) NOT NULL --/U  --/D eROSITA version (eRASS1 or eRASS:3)
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'DL1_eROSITA_eRASS3_daily')
	DROP TABLE DL1_eROSITA_eRASS3_daily
GO
--
EXEC spSetDefaultFileGroup 'DL1_eROSITA_eRASS3_daily'
GO

CREATE TABLE DL1_eROSITA_eRASS3_daily (
---------------------------------------------------------------- 
--/H SDSS and eROSITA data of the sources within the SPIDERS program
-----------------------------------------------------------------
--/T Data Level 1 contains the data shared among the collaborations of SDSS and 
--/T eROSITA, with optical and X-ray information of sources that were detected 
--/T with eROSITA and followed-up with SDSS 
---------------------------------------------------------------- 
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
    sdss_nspec smallint NOT NULL, --/U  --/D Number of observed SDSS spectra 
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
    wise_mag_1 real NOT NULL, --/F wise_mag 0 --/U AB mag  --/D WISE photometry (W1, W2, W3, W4) (array element 1) 
    wise_mag_2 real NOT NULL, --/F wise_mag 1 --/U AB mag --/D WISE photometry (W1, W2, W3, W4) (array element 2) 
    wise_mag_3 real NOT NULL, --/F wise_mag 2 --/U AB mag --/D WISE photometry (W1, W2, W3, W4) (array element 3) 
    wise_mag_4 real NOT NULL, --/F wise_mag 3 --/U AB mag --/D WISE photometry (W1, W2, W3, W4) (array element 4) 
    twomass_mag_1 real NOT NULL, --/F twomass_mag 0 --/U Vega mag --/D 2MASS photometry (J, H, Ks) (array element 1) 
    twomass_mag_2 real NOT NULL, --/F twomass_mag 1 --/U Vega mag --/D 2MASS photometry (J, H, Ks) (array element 2) 
    twomass_mag_3 real NOT NULL, --/F twomass_mag 2 --/U Vega mag --/D 2MASS photometry (J, H, Ks) (array element 3) 
    guvcat_mag_1 real NOT NULL, --/F guvcat_mag 0 --/U  AB mag --/D GALEX UV photometry (FUV, NUV) (array element 1) 
    guvcat_mag_2 real NOT NULL, --/F guvcat_mag 1 --/U  AB mag --/D GALEX UV photometry (FUV, NUV) (array element 2) 
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
    ero_version varchar(6) NOT NULL --/U  --/D eROSITA version (eRASS1 or eRASS:3) 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'DR20Q_prop')
	DROP TABLE DR20Q_prop
GO
--
EXEC spSetDefaultFileGroup 'DR20Q_prop'
GO

CREATE TABLE DR20Q_prop (
---------------------------------------------------------------- 
--/H Spectral measurements of DR20 quasars using PyQSOFit
-----------------------------------------------------------------
--/T Quasar spectral properties measured by PyQSOFit, including the continuum 
--/T and emission line properties (flux, FWHM, EW...), virial BH masses, 
--/T bolometric luminosities, Eddington ratios, systemic redshift, etc. Host 
--/T galaxy properties are also provided for z<1 quasars. 
---------------------------------------------------------------- 
    obs varchar(4) NOT NULL, --/U  --/D observatory site 
    mjd int NOT NULL, --/U  --/D MJD of the exposure 
    catalogid bigint NOT NULL, --/U  --/D SDSS-V catalog indentifier 
    objid varchar(36) NOT NULL, --/U  --/D OBS- 
    z_pip float NOT NULL, --/U  --/D pipeline reshift 
    ra float NOT NULL, --/U degree --/D Right ascension 
    dec float NOT NULL, --/U degree --/D Declination 
    z_fit float NOT NULL, --/U  --/D Input redshift for PyQSOFit 
    z_sys float NOT NULL, --/U  --/D Systemic redshift 
    z_sys_err float NOT NULL, --/U  --/D Systemic redshift uncertainty 
    has_vi float NOT NULL, --/U  --/D if this object has been visual inspected 
    z_vi float NOT NULL, --/U  --/D Visual inspection redshift 
    sn_ratio_conti float NOT NULL, --/U  --/D Signal-to-noise ratio of the continuum 
    ebv float NOT NULL, --/U  --/D Milky Way extinction E(B-V) 
    conti_para_1 float NOT NULL, --/F CONTI_PARA 0 --/U  --/D Best-fit parameters for the continuum model (PL+poly) (array element 1) 
    conti_para_2 float NOT NULL, --/F CONTI_PARA 1 --/U  --/D Best-fit parameters for the continuum model (PL+poly) (array element 2) 
    conti_para_3 float NOT NULL, --/F CONTI_PARA 2 --/U  --/D Best-fit parameters for the continuum model (PL+poly) (array element 3) 
    conti_para_4 float NOT NULL, --/F CONTI_PARA 3 --/U  --/D Best-fit parameters for the continuum model (PL+poly) (array element 4) 
    conti_para_5 float NOT NULL, --/F CONTI_PARA 4 --/U  --/D Best-fit parameters for the continuum model (PL+poly) (array element 5) 
    conti_para_err_1 float NOT NULL, --/F CONTI_PARA_ERR 0 --/U  --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly) (array element 1) 
    conti_para_err_2 float NOT NULL, --/F CONTI_PARA_ERR 1 --/U  --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly) (array element 2) 
    conti_para_err_3 float NOT NULL, --/F CONTI_PARA_ERR 2 --/U  --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly) (array element 3) 
    conti_para_err_4 float NOT NULL, --/F CONTI_PARA_ERR 3 --/U  --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly) (array element 4) 
    conti_para_err_5 float NOT NULL, --/F CONTI_PARA_ERR 4 --/U  --/D Uncertainties of the best-fit parameters for the continuum model (PL+poly) (array element 5) 
    fe_uv_opt_para_1 float NOT NULL, --/F FE_UV_OPT_PARA 0 --/U  --/D FeII template parameters (normalization, FWHM and shift) for UV and optical band (array element 1) 
    fe_uv_opt_para_2 float NOT NULL, --/F FE_UV_OPT_PARA 1 --/U  --/D FeII template parameters (normalization, FWHM and shift) for UV and optical band (array element 2) 
    fe_uv_opt_para_3 float NOT NULL, --/F FE_UV_OPT_PARA 2 --/U  --/D FeII template parameters (normalization, FWHM and shift) for UV and optical band (array element 3) 
    fe_uv_opt_para_4 float NOT NULL, --/F FE_UV_OPT_PARA 3 --/U  --/D FeII template parameters (normalization, FWHM and shift) for UV and optical band (array element 4) 
    fe_uv_opt_para_5 float NOT NULL, --/F FE_UV_OPT_PARA 4 --/U  --/D FeII template parameters (normalization, FWHM and shift) for UV and optical band (array element 5) 
    fe_uv_opt_para_6 float NOT NULL, --/F FE_UV_OPT_PARA 5 --/U  --/D FeII template parameters (normalization, FWHM and shift) for UV and optical band (array element 6) 
    fe_uv_opt_para_err_1 float NOT NULL, --/F FE_UV_OPT_PARA_ERR 0 --/U  --/D uncertainties for the FeII template parameters (array element 1) 
    fe_uv_opt_para_err_2 float NOT NULL, --/F FE_UV_OPT_PARA_ERR 1 --/U  --/D uncertainties for the FeII template parameters (array element 2) 
    fe_uv_opt_para_err_3 float NOT NULL, --/F FE_UV_OPT_PARA_ERR 2 --/U  --/D uncertainties for the FeII template parameters (array element 3) 
    fe_uv_opt_para_err_4 float NOT NULL, --/F FE_UV_OPT_PARA_ERR 3 --/U  --/D uncertainties for the FeII template parameters (array element 4) 
    fe_uv_opt_para_err_5 float NOT NULL, --/F FE_UV_OPT_PARA_ERR 4 --/U  --/D uncertainties for the FeII template parameters (array element 5) 
    fe_uv_opt_para_err_6 float NOT NULL, --/F FE_UV_OPT_PARA_ERR 5 --/U  --/D uncertainties for the FeII template parameters (array element 6) 
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
    host_decomp_para_1 float NOT NULL, --/F HOST_DECOMP_PARA 0 --/U  --/D The host galaxy decomposition eigenvalues (array element 1) 
    host_decomp_para_2 float NOT NULL, --/F HOST_DECOMP_PARA 1 --/U  --/D The host galaxy decomposition eigenvalues (array element 2) 
    host_decomp_para_3 float NOT NULL, --/F HOST_DECOMP_PARA 2 --/U  --/D The host galaxy decomposition eigenvalues (array element 3) 
    host_decomp_para_4 float NOT NULL, --/F HOST_DECOMP_PARA 3 --/U  --/D The host galaxy decomposition eigenvalues (array element 4) 
    host_decomp_para_5 float NOT NULL, --/F HOST_DECOMP_PARA 4 --/U  --/D The host galaxy decomposition eigenvalues (array element 5) 
    halpha_1 float NOT NULL, --/F HALPHA 0 --/U Angstrom --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    halpha_2 float NOT NULL, --/F HALPHA 1 --/U  10^{-17} erg/s/cm^2 --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    halpha_3 float NOT NULL, --/F HALPHA 2 --/U  erg/s --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    halpha_4 float NOT NULL, --/F HALPHA 3 --/U  km/s --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    halpha_5 float NOT NULL, --/F HALPHA 4 --/U  Angstrom --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    halpha_6 float NOT NULL, --/F HALPHA 5 --/U  Angstrom --/D Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    halpha_err_1 float NOT NULL, --/F HALPHA_ERR 0 --/U Angstrom --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    halpha_err_2 float NOT NULL, --/F HALPHA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    halpha_err_3 float NOT NULL, --/F HALPHA_ERR 2 --/U  erg/s --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    halpha_err_4 float NOT NULL, --/F HALPHA_ERR 3 --/U  km/s --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    halpha_err_5 float NOT NULL, --/F HALPHA_ERR 4 --/U  Angstrom --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    halpha_err_6 float NOT NULL, --/F HALPHA_ERR 5 --/U  Angstrom --/D Uncertainties of Halpha peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    halpha_br_1 float NOT NULL, --/F HALPHA_BR 0 --/U Angstrom --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    halpha_br_2 float NOT NULL, --/F HALPHA_BR 1 --/U  10^{-17} erg/s/cm^2 --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    halpha_br_3 float NOT NULL, --/F HALPHA_BR 2 --/U  erg/s --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    halpha_br_4 float NOT NULL, --/F HALPHA_BR 3 --/U  km/s --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    halpha_br_5 float NOT NULL, --/F HALPHA_BR 4 --/U  Angstrom --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    halpha_br_6 float NOT NULL, --/F HALPHA_BR 5 --/U  Angstrom --/D Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    halpha_br_err_1 float NOT NULL, --/F HALPHA_BR_ERR 0 --/U Angstrom --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    halpha_br_err_2 float NOT NULL, --/F HALPHA_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    halpha_br_err_3 float NOT NULL, --/F HALPHA_BR_ERR 2 --/U  erg/s --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    halpha_br_err_4 float NOT NULL, --/F HALPHA_BR_ERR 3 --/U  km/s --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    halpha_br_err_5 float NOT NULL, --/F HALPHA_BR_ERR 4 --/U  Angstrom --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    halpha_br_err_6 float NOT NULL, --/F HALPHA_BR_ERR 5 --/U  Angstrom --/D Uncertainties of Halpha broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    halpha_na_1 float NOT NULL, --/F HALPHA_NA 0 --/U Angstrom --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    halpha_na_2 float NOT NULL, --/F HALPHA_NA 1 --/U  10^{-17} erg/s/cm^2 --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    halpha_na_3 float NOT NULL, --/F HALPHA_NA 2 --/U  erg/s --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    halpha_na_4 float NOT NULL, --/F HALPHA_NA 3 --/U  km/s --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    halpha_na_5 float NOT NULL, --/F HALPHA_NA 4 --/U  Angstrom --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    halpha_na_6 float NOT NULL, --/F HALPHA_NA 5 --/U  Angstrom --/D Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    halpha_na_err_1 float NOT NULL, --/F HALPHA_NA_ERR 0 --/U Angstrom --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    halpha_na_err_2 float NOT NULL, --/F HALPHA_NA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    halpha_na_err_3 float NOT NULL, --/F HALPHA_NA_ERR 2 --/U  erg/s --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    halpha_na_err_4 float NOT NULL, --/F HALPHA_NA_ERR 3 --/U  km/s --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    halpha_na_err_5 float NOT NULL, --/F HALPHA_NA_ERR 4 --/U  Angstrom --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    halpha_na_err_6 float NOT NULL, --/F HALPHA_NA_ERR 5 --/U  Angstrom --/D Uncertainties of Halpha narrow peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    nii6549_1 float NOT NULL, --/F NII6549 0 --/U Angstrom --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    nii6549_2 float NOT NULL, --/F NII6549 1 --/U  10^{-17} erg/s/cm^2 --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    nii6549_3 float NOT NULL, --/F NII6549 2 --/U  erg/s --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    nii6549_4 float NOT NULL, --/F NII6549 3 --/U  km/s --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    nii6549_5 float NOT NULL, --/F NII6549 4 --/U  Angstrom --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    nii6549_6 float NOT NULL, --/F NII6549 5 --/U  Angstrom --/D NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    nii6549_err_1 float NOT NULL, --/F NII6549_ERR 0 --/U Angstrom --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    nii6549_err_2 float NOT NULL, --/F NII6549_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    nii6549_err_3 float NOT NULL, --/F NII6549_ERR 2 --/U  erg/s --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    nii6549_err_4 float NOT NULL, --/F NII6549_ERR 3 --/U  km/s --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    nii6549_err_5 float NOT NULL, --/F NII6549_ERR 4 --/U  Angstrom --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    nii6549_err_6 float NOT NULL, --/F NII6549_ERR 5 --/U  Angstrom --/D Uncertainties of NII6549 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    nii6585_1 float NOT NULL, --/F NII6585 0 --/U Angstrom --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    nii6585_2 float NOT NULL, --/F NII6585 1 --/U  10^{-17} erg/s/cm^2 --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    nii6585_3 float NOT NULL, --/F NII6585 2 --/U  erg/s --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    nii6585_4 float NOT NULL, --/F NII6585 3 --/U  km/s --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    nii6585_5 float NOT NULL, --/F NII6585 4 --/U  Angstrom --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    nii6585_6 float NOT NULL, --/F NII6585 5 --/U  Angstrom --/D NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    nii6585_err_1 float NOT NULL, --/F NII6585_ERR 0 --/U Angstrom --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    nii6585_err_2 float NOT NULL, --/F NII6585_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    nii6585_err_3 float NOT NULL, --/F NII6585_ERR 2 --/U  erg/s --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    nii6585_err_4 float NOT NULL, --/F NII6585_ERR 3 --/U  km/s --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    nii6585_err_5 float NOT NULL, --/F NII6585_ERR 4 --/U  Angstrom --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    nii6585_err_6 float NOT NULL, --/F NII6585_ERR 5 --/U  Angstrom --/D Uncertainties of NII6585 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    sii6718_1 float NOT NULL, --/F SII6718 0 --/U Angstrom --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    sii6718_2 float NOT NULL, --/F SII6718 1 --/U  10^{-17} erg/s/cm^2 --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    sii6718_3 float NOT NULL, --/F SII6718 2 --/U  erg/s --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    sii6718_4 float NOT NULL, --/F SII6718 3 --/U  km/s --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    sii6718_5 float NOT NULL, --/F SII6718 4 --/U  Angstrom --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    sii6718_6 float NOT NULL, --/F SII6718 5 --/U  Angstrom --/D SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    sii6718_err_1 float NOT NULL, --/F SII6718_ERR 0 --/U Angstrom --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    sii6718_err_2 float NOT NULL, --/F SII6718_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    sii6718_err_3 float NOT NULL, --/F SII6718_ERR 2 --/U  erg/s --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    sii6718_err_4 float NOT NULL, --/F SII6718_ERR 3 --/U  km/s --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    sii6718_err_5 float NOT NULL, --/F SII6718_ERR 4 --/U  Angstrom --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    sii6718_err_6 float NOT NULL, --/F SII6718_ERR 5 --/U  Angstrom --/D Uncertainties of SII6718 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    sii6732_1 float NOT NULL, --/F SII6732 0 --/U Angstrom --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    sii6732_2 float NOT NULL, --/F SII6732 1 --/U  10^{-17} erg/s/cm^2 --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    sii6732_3 float NOT NULL, --/F SII6732 2 --/U  erg/s --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    sii6732_4 float NOT NULL, --/F SII6732 3 --/U  km/s --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    sii6732_5 float NOT NULL, --/F SII6732 4 --/U  Angstrom --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    sii6732_6 float NOT NULL, --/F SII6732 5 --/U  Angstrom --/D SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    sii6732_err_1 float NOT NULL, --/F SII6732_ERR 0 --/U Angstrom --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    sii6732_err_2 float NOT NULL, --/F SII6732_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    sii6732_err_3 float NOT NULL, --/F SII6732_ERR 2 --/U  erg/s --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    sii6732_err_4 float NOT NULL, --/F SII6732_ERR 3 --/U  km/s --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    sii6732_err_5 float NOT NULL, --/F SII6732_ERR 4 --/U  Angstrom --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    sii6732_err_6 float NOT NULL, --/F SII6732_ERR 5 --/U  Angstrom --/D Uncertainties of SII6732 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    hbeta_1 float NOT NULL, --/F HBETA 0 --/U Angstrom --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    hbeta_2 float NOT NULL, --/F HBETA 1 --/U  10^{-17} erg/s/cm^2 --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    hbeta_3 float NOT NULL, --/F HBETA 2 --/U  erg/s --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    hbeta_4 float NOT NULL, --/F HBETA 3 --/U  km/s --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    hbeta_5 float NOT NULL, --/F HBETA 4 --/U  Angstrom --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    hbeta_6 float NOT NULL, --/F HBETA 5 --/U  Angstrom --/D Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    hbeta_err_1 float NOT NULL, --/F HBETA_ERR 0 --/U Angstrom --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    hbeta_err_2 float NOT NULL, --/F HBETA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    hbeta_err_3 float NOT NULL, --/F HBETA_ERR 2 --/U  erg/s --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    hbeta_err_4 float NOT NULL, --/F HBETA_ERR 3 --/U  km/s --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    hbeta_err_5 float NOT NULL, --/F HBETA_ERR 4 --/U  Angstrom --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    hbeta_err_6 float NOT NULL, --/F HBETA_ERR 5 --/U  Angstrom --/D Uncertainties of Hbeta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    hbeta_br_1 float NOT NULL, --/F HBETA_BR 0 --/U Angstrom --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    hbeta_br_2 float NOT NULL, --/F HBETA_BR 1 --/U  10^{-17} erg/s/cm^2 --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    hbeta_br_3 float NOT NULL, --/F HBETA_BR 2 --/U  erg/s --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    hbeta_br_4 float NOT NULL, --/F HBETA_BR 3 --/U  km/s --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    hbeta_br_5 float NOT NULL, --/F HBETA_BR 4 --/U  Angstrom --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    hbeta_br_6 float NOT NULL, --/F HBETA_BR 5 --/U  Angstrom --/D Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    hbeta_br_err_1 float NOT NULL, --/F HBETA_BR_ERR 0 --/U Angstrom --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    hbeta_br_err_2 float NOT NULL, --/F HBETA_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    hbeta_br_err_3 float NOT NULL, --/F HBETA_BR_ERR 2 --/U  erg/s --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    hbeta_br_err_4 float NOT NULL, --/F HBETA_BR_ERR 3 --/U  km/s --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    hbeta_br_err_5 float NOT NULL, --/F HBETA_BR_ERR 4 --/U  Angstrom --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    hbeta_br_err_6 float NOT NULL, --/F HBETA_BR_ERR 5 --/U  Angstrom --/D Uncertainties of Hbeta broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    heii4687_1 float NOT NULL, --/F HEII4687 0 --/U Angstrom --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    heii4687_2 float NOT NULL, --/F HEII4687 1 --/U  10^{-17} erg/s/cm^2 --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    heii4687_3 float NOT NULL, --/F HEII4687 2 --/U  erg/s --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    heii4687_4 float NOT NULL, --/F HEII4687 3 --/U  km/s --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    heii4687_5 float NOT NULL, --/F HEII4687 4 --/U  Angstrom --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    heii4687_6 float NOT NULL, --/F HEII4687 5 --/U  Angstrom --/D HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    heii4687_err_1 float NOT NULL, --/F HEII4687_ERR 0 --/U Angstrom --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    heii4687_err_2 float NOT NULL, --/F HEII4687_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    heii4687_err_3 float NOT NULL, --/F HEII4687_ERR 2 --/U  erg/s --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    heii4687_err_4 float NOT NULL, --/F HEII4687_ERR 3 --/U  km/s --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    heii4687_err_5 float NOT NULL, --/F HEII4687_ERR 4 --/U  Angstrom --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    heii4687_err_6 float NOT NULL, --/F HEII4687_ERR 5 --/U  Angstrom --/D Uncertainties of HEII4687 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    heii4687_br_1 float NOT NULL, --/F HEII4687_BR 0 --/U Angstrom --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    heii4687_br_2 float NOT NULL, --/F HEII4687_BR 1 --/U  10^{-17} erg/s/cm^2 --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    heii4687_br_3 float NOT NULL, --/F HEII4687_BR 2 --/U  erg/s --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    heii4687_br_4 float NOT NULL, --/F HEII4687_BR 3 --/U  km/s --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    heii4687_br_5 float NOT NULL, --/F HEII4687_BR 4 --/U  Angstrom --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    heii4687_br_6 float NOT NULL, --/F HEII4687_BR 5 --/U  Angstrom --/D HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    heii4687_br_err_1 float NOT NULL, --/F HEII4687_BR_ERR 0 --/U Angstrom --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    heii4687_br_err_2 float NOT NULL, --/F HEII4687_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    heii4687_br_err_3 float NOT NULL, --/F HEII4687_BR_ERR 2 --/U  erg/s --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    heii4687_br_err_4 float NOT NULL, --/F HEII4687_BR_ERR 3 --/U  km/s --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    heii4687_br_err_5 float NOT NULL, --/F HEII4687_BR_ERR 4 --/U  Angstrom --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    heii4687_br_err_6 float NOT NULL, --/F HEII4687_BR_ERR 5 --/U  Angstrom --/D Uncertainties of HEII4687 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oiii5007_1 float NOT NULL, --/F OIII5007 0 --/U Angstrom --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oiii5007_2 float NOT NULL, --/F OIII5007 1 --/U  10^{-17} erg/s/cm^2 --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oiii5007_3 float NOT NULL, --/F OIII5007 2 --/U  erg/s --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oiii5007_4 float NOT NULL, --/F OIII5007 3 --/U  km/s --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oiii5007_5 float NOT NULL, --/F OIII5007 4 --/U  Angstrom --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oiii5007_6 float NOT NULL, --/F OIII5007 5 --/U  Angstrom --/D OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oiii5007_err_1 float NOT NULL, --/F OIII5007_ERR 0 --/U Angstrom --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oiii5007_err_2 float NOT NULL, --/F OIII5007_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oiii5007_err_3 float NOT NULL, --/F OIII5007_ERR 2 --/U  erg/s --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oiii5007_err_4 float NOT NULL, --/F OIII5007_ERR 3 --/U  km/s --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oiii5007_err_5 float NOT NULL, --/F OIII5007_ERR 4 --/U  Angstrom --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oiii5007_err_6 float NOT NULL, --/F OIII5007_ERR 5 --/U  Angstrom --/D Uncertainties of OIII5007 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oiii5007c_1 float NOT NULL, --/F OIII5007C 0 --/U Angstrom --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oiii5007c_2 float NOT NULL, --/F OIII5007C 1 --/U  10^{-17} erg/s/cm^2 --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oiii5007c_3 float NOT NULL, --/F OIII5007C 2 --/U  erg/s --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oiii5007c_4 float NOT NULL, --/F OIII5007C 3 --/U  km/s --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oiii5007c_5 float NOT NULL, --/F OIII5007C 4 --/U  Angstrom --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oiii5007c_6 float NOT NULL, --/F OIII5007C 5 --/U  Angstrom --/D OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oiii5007c_err_1 float NOT NULL, --/F OIII5007C_ERR 0 --/U Angstrom --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oiii5007c_err_2 float NOT NULL, --/F OIII5007C_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oiii5007c_err_3 float NOT NULL, --/F OIII5007C_ERR 2 --/U  erg/s --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oiii5007c_err_4 float NOT NULL, --/F OIII5007C_ERR 3 --/U  km/s --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oiii5007c_err_5 float NOT NULL, --/F OIII5007C_ERR 4 --/U  Angstrom --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oiii5007c_err_6 float NOT NULL, --/F OIII5007C_ERR 5 --/U  Angstrom --/D Uncertainties of OIII5007 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oiii4960_1 float NOT NULL, --/F OIII4960 0 --/U Angstrom --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oiii4960_2 float NOT NULL, --/F OIII4960 1 --/U  10^{-17} erg/s/cm^2 --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oiii4960_3 float NOT NULL, --/F OIII4960 2 --/U  erg/s --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oiii4960_4 float NOT NULL, --/F OIII4960 3 --/U  km/s --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oiii4960_5 float NOT NULL, --/F OIII4960 4 --/U  Angstrom --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oiii4960_6 float NOT NULL, --/F OIII4960 5 --/U  Angstrom --/D OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oiii4960_err_1 float NOT NULL, --/F OIII4960_ERR 0 --/U Angstrom --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oiii4960_err_2 float NOT NULL, --/F OIII4960_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oiii4960_err_3 float NOT NULL, --/F OIII4960_ERR 2 --/U  erg/s --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oiii4960_err_4 float NOT NULL, --/F OIII4960_ERR 3 --/U  km/s --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oiii4960_err_5 float NOT NULL, --/F OIII4960_ERR 4 --/U  Angstrom --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oiii4960_err_6 float NOT NULL, --/F OIII4960_ERR 5 --/U  Angstrom --/D Uncertainties of OIII4960 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oiii4960c_1 float NOT NULL, --/F OIII4960C 0 --/U Angstrom --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oiii4960c_2 float NOT NULL, --/F OIII4960C 1 --/U  10^{-17} erg/s/cm^2 --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oiii4960c_3 float NOT NULL, --/F OIII4960C 2 --/U  erg/s --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oiii4960c_4 float NOT NULL, --/F OIII4960C 3 --/U  km/s --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oiii4960c_5 float NOT NULL, --/F OIII4960C 4 --/U  Angstrom --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oiii4960c_6 float NOT NULL, --/F OIII4960C 5 --/U  Angstrom --/D OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oiii4960c_err_1 float NOT NULL, --/F OIII4960C_ERR 0 --/U Angstrom --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oiii4960c_err_2 float NOT NULL, --/F OIII4960C_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oiii4960c_err_3 float NOT NULL, --/F OIII4960C_ERR 2 --/U  erg/s --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oiii4960c_err_4 float NOT NULL, --/F OIII4960C_ERR 3 --/U  km/s --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oiii4960c_err_5 float NOT NULL, --/F OIII4960C_ERR 4 --/U  Angstrom --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oiii4960c_err_6 float NOT NULL, --/F OIII4960C_ERR 5 --/U  Angstrom --/D Uncertainties of OIII4960 core peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    hgamma_1 float NOT NULL, --/F HGAMMA 0 --/U Angstrom --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    hgamma_2 float NOT NULL, --/F HGAMMA 1 --/U  10^{-17} erg/s/cm^2 --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    hgamma_3 float NOT NULL, --/F HGAMMA 2 --/U  erg/s --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    hgamma_4 float NOT NULL, --/F HGAMMA 3 --/U  km/s --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    hgamma_5 float NOT NULL, --/F HGAMMA 4 --/U  Angstrom --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    hgamma_6 float NOT NULL, --/F HGAMMA 5 --/U  Angstrom --/D Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    hgamma_err_1 float NOT NULL, --/F HGAMMA_ERR 0 --/U Angstrom --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    hgamma_err_2 float NOT NULL, --/F HGAMMA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    hgamma_err_3 float NOT NULL, --/F HGAMMA_ERR 2 --/U  erg/s --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    hgamma_err_4 float NOT NULL, --/F HGAMMA_ERR 3 --/U  km/s --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    hgamma_err_5 float NOT NULL, --/F HGAMMA_ERR 4 --/U  Angstrom --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    hgamma_err_6 float NOT NULL, --/F HGAMMA_ERR 5 --/U  Angstrom --/D Uncertainties of Hgamma peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    hdelta_1 float NOT NULL, --/F HDELTA 0 --/U Angstrom --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    hdelta_2 float NOT NULL, --/F HDELTA 1 --/U  10^{-17} erg/s/cm^2 --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    hdelta_3 float NOT NULL, --/F HDELTA 2 --/U  erg/s --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    hdelta_4 float NOT NULL, --/F HDELTA 3 --/U  km/s --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    hdelta_5 float NOT NULL, --/F HDELTA 4 --/U  Angstrom --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    hdelta_6 float NOT NULL, --/F HDELTA 5 --/U  Angstrom --/D Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    hdelta_err_1 float NOT NULL, --/F HDELTA_ERR 0 --/U Angstrom --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    hdelta_err_2 float NOT NULL, --/F HDELTA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    hdelta_err_3 float NOT NULL, --/F HDELTA_ERR 2 --/U  erg/s --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    hdelta_err_4 float NOT NULL, --/F HDELTA_ERR 3 --/U  km/s --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    hdelta_err_5 float NOT NULL, --/F HDELTA_ERR 4 --/U  Angstrom --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    hdelta_err_6 float NOT NULL, --/F HDELTA_ERR 5 --/U  Angstrom --/D Uncertainties of Hdelta peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    caii3934_1 float NOT NULL, --/F CAII3934 0 --/U Angstrom --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    caii3934_2 float NOT NULL, --/F CAII3934 1 --/U  10^{-17} erg/s/cm^2 --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    caii3934_3 float NOT NULL, --/F CAII3934 2 --/U  erg/s --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    caii3934_4 float NOT NULL, --/F CAII3934 3 --/U  km/s --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    caii3934_5 float NOT NULL, --/F CAII3934 4 --/U  Angstrom --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    caii3934_6 float NOT NULL, --/F CAII3934 5 --/U  Angstrom --/D CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    caii3934_err_1 float NOT NULL, --/F CAII3934_ERR 0 --/U Angstrom --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    caii3934_err_2 float NOT NULL, --/F CAII3934_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    caii3934_err_3 float NOT NULL, --/F CAII3934_ERR 2 --/U  erg/s --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    caii3934_err_4 float NOT NULL, --/F CAII3934_ERR 3 --/U  km/s --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    caii3934_err_5 float NOT NULL, --/F CAII3934_ERR 4 --/U  Angstrom --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    caii3934_err_6 float NOT NULL, --/F CAII3934_ERR 5 --/U  Angstrom --/D Uncertainties of CAII3934 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oii3728_1 float NOT NULL, --/F OII3728 0 --/U Angstrom --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oii3728_2 float NOT NULL, --/F OII3728 1 --/U  10^{-17} erg/s/cm^2 --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oii3728_3 float NOT NULL, --/F OII3728 2 --/U  erg/s --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oii3728_4 float NOT NULL, --/F OII3728 3 --/U  km/s --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oii3728_5 float NOT NULL, --/F OII3728 4 --/U  Angstrom --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oii3728_6 float NOT NULL, --/F OII3728 5 --/U  Angstrom --/D OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oii3728_err_1 float NOT NULL, --/F OII3728_ERR 0 --/U Angstrom --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oii3728_err_2 float NOT NULL, --/F OII3728_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oii3728_err_3 float NOT NULL, --/F OII3728_ERR 2 --/U  erg/s --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oii3728_err_4 float NOT NULL, --/F OII3728_ERR 3 --/U  km/s --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oii3728_err_5 float NOT NULL, --/F OII3728_ERR 4 --/U  Angstrom --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oii3728_err_6 float NOT NULL, --/F OII3728_ERR 5 --/U  Angstrom --/D Uncertainties of OII3728 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    nev3426_1 float NOT NULL, --/F NEV3426 0 --/U Angstrom --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    nev3426_2 float NOT NULL, --/F NEV3426 1 --/U  10^{-17} erg/s/cm^2 --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    nev3426_3 float NOT NULL, --/F NEV3426 2 --/U  erg/s --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    nev3426_4 float NOT NULL, --/F NEV3426 3 --/U  km/s --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    nev3426_5 float NOT NULL, --/F NEV3426 4 --/U  Angstrom --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    nev3426_6 float NOT NULL, --/F NEV3426 5 --/U  Angstrom --/D NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    nev3426_err_1 float NOT NULL, --/F NEV3426_ERR 0 --/U Angstrom --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    nev3426_err_2 float NOT NULL, --/F NEV3426_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    nev3426_err_3 float NOT NULL, --/F NEV3426_ERR 2 --/U  erg/s --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    nev3426_err_4 float NOT NULL, --/F NEV3426_ERR 3 --/U  km/s --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    nev3426_err_5 float NOT NULL, --/F NEV3426_ERR 4 --/U  Angstrom --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    nev3426_err_6 float NOT NULL, --/F NEV3426_ERR 5 --/U  Angstrom --/D Uncertainties of NEV3426 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    mgii_1 float NOT NULL, --/F MGII 0 --/U Angstrom --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    mgii_2 float NOT NULL, --/F MGII 1 --/U  10^{-17} erg/s/cm^2 --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    mgii_3 float NOT NULL, --/F MGII 2 --/U  erg/s --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    mgii_4 float NOT NULL, --/F MGII 3 --/U  km/s --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    mgii_5 float NOT NULL, --/F MGII 4 --/U  Angstrom --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    mgii_6 float NOT NULL, --/F MGII 5 --/U  Angstrom --/D MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    mgii_err_1 float NOT NULL, --/F MGII_ERR 0 --/U Angstrom --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    mgii_err_2 float NOT NULL, --/F MGII_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    mgii_err_3 float NOT NULL, --/F MGII_ERR 2 --/U  erg/s --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    mgii_err_4 float NOT NULL, --/F MGII_ERR 3 --/U  km/s --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    mgii_err_5 float NOT NULL, --/F MGII_ERR 4 --/U  Angstrom --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    mgii_err_6 float NOT NULL, --/F MGII_ERR 5 --/U  Angstrom --/D Uncertainties of MgII peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    mgii_br_1 float NOT NULL, --/F MGII_BR 0 --/U Angstrom --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    mgii_br_2 float NOT NULL, --/F MGII_BR 1 --/U  10^{-17} erg/s/cm^2 --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    mgii_br_3 float NOT NULL, --/F MGII_BR 2 --/U  erg/s --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    mgii_br_4 float NOT NULL, --/F MGII_BR 3 --/U  km/s --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    mgii_br_5 float NOT NULL, --/F MGII_BR 4 --/U  Angstrom --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    mgii_br_6 float NOT NULL, --/F MGII_BR 5 --/U  Angstrom --/D MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    mgii_br_err_1 float NOT NULL, --/F MGII_BR_ERR 0 --/U Angstrom --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    mgii_br_err_2 float NOT NULL, --/F MGII_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    mgii_br_err_3 float NOT NULL, --/F MGII_BR_ERR 2 --/U  erg/s --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    mgii_br_err_4 float NOT NULL, --/F MGII_BR_ERR 3 --/U  km/s --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    mgii_br_err_5 float NOT NULL, --/F MGII_BR_ERR 4 --/U  Angstrom --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    mgii_br_err_6 float NOT NULL, --/F MGII_BR_ERR 5 --/U  Angstrom --/D Uncertainties of MgII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    ciii_br_1 float NOT NULL, --/F CIII_BR 0 --/U Angstrom --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    ciii_br_2 float NOT NULL, --/F CIII_BR 1 --/U  10^{-17} erg/s/cm^2 --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    ciii_br_3 float NOT NULL, --/F CIII_BR 2 --/U  erg/s --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    ciii_br_4 float NOT NULL, --/F CIII_BR 3 --/U  km/s --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    ciii_br_5 float NOT NULL, --/F CIII_BR 4 --/U  Angstrom --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    ciii_br_6 float NOT NULL, --/F CIII_BR 5 --/U  Angstrom --/D CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    ciii_br_err_1 float NOT NULL, --/F CIII_BR_ERR 0 --/U Angstrom --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    ciii_br_err_2 float NOT NULL, --/F CIII_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    ciii_br_err_3 float NOT NULL, --/F CIII_BR_ERR 2 --/U  erg/s --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    ciii_br_err_4 float NOT NULL, --/F CIII_BR_ERR 3 --/U  km/s --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    ciii_br_err_5 float NOT NULL, --/F CIII_BR_ERR 4 --/U  Angstrom --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    ciii_br_err_6 float NOT NULL, --/F CIII_BR_ERR 5 --/U  Angstrom --/D Uncertainties of CIII broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    siiii1892_1 float NOT NULL, --/F SIIII1892 0 --/U Angstrom --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    siiii1892_2 float NOT NULL, --/F SIIII1892 1 --/U  10^{-17} erg/s/cm^2 --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    siiii1892_3 float NOT NULL, --/F SIIII1892 2 --/U  erg/s --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    siiii1892_4 float NOT NULL, --/F SIIII1892 3 --/U  km/s --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    siiii1892_5 float NOT NULL, --/F SIIII1892 4 --/U  Angstrom --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    siiii1892_6 float NOT NULL, --/F SIIII1892 5 --/U  Angstrom --/D SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    siiii1892_err_1 float NOT NULL, --/F SIIII1892_ERR 0 --/U Angstrom --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    siiii1892_err_2 float NOT NULL, --/F SIIII1892_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    siiii1892_err_3 float NOT NULL, --/F SIIII1892_ERR 2 --/U  erg/s --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    siiii1892_err_4 float NOT NULL, --/F SIIII1892_ERR 3 --/U  km/s --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    siiii1892_err_5 float NOT NULL, --/F SIIII1892_ERR 4 --/U  Angstrom --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    siiii1892_err_6 float NOT NULL, --/F SIIII1892_ERR 5 --/U  Angstrom --/D Uncertainties of SIIII1892 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    aliii1857_1 float NOT NULL, --/F ALIII1857 0 --/U Angstrom --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    aliii1857_2 float NOT NULL, --/F ALIII1857 1 --/U  10^{-17} erg/s/cm^2 --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    aliii1857_3 float NOT NULL, --/F ALIII1857 2 --/U  erg/s --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    aliii1857_4 float NOT NULL, --/F ALIII1857 3 --/U  km/s --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    aliii1857_5 float NOT NULL, --/F ALIII1857 4 --/U  Angstrom --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    aliii1857_6 float NOT NULL, --/F ALIII1857 5 --/U  Angstrom --/D ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    aliii1857_err_1 float NOT NULL, --/F ALIII1857_ERR 0 --/U Angstrom --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    aliii1857_err_2 float NOT NULL, --/F ALIII1857_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    aliii1857_err_3 float NOT NULL, --/F ALIII1857_ERR 2 --/U  erg/s --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    aliii1857_err_4 float NOT NULL, --/F ALIII1857_ERR 3 --/U  km/s --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    aliii1857_err_5 float NOT NULL, --/F ALIII1857_ERR 4 --/U  Angstrom --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    aliii1857_err_6 float NOT NULL, --/F ALIII1857_ERR 5 --/U  Angstrom --/D Uncertainties of ALIII1857 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    niii1750_1 float NOT NULL, --/F NIII1750 0 --/U Angstrom --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    niii1750_2 float NOT NULL, --/F NIII1750 1 --/U  10^{-17} erg/s/cm^2 --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    niii1750_3 float NOT NULL, --/F NIII1750 2 --/U  erg/s --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    niii1750_4 float NOT NULL, --/F NIII1750 3 --/U  km/s --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    niii1750_5 float NOT NULL, --/F NIII1750 4 --/U  Angstrom --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    niii1750_6 float NOT NULL, --/F NIII1750 5 --/U  Angstrom --/D NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    niii1750_err_1 float NOT NULL, --/F NIII1750_ERR 0 --/U Angstrom --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    niii1750_err_2 float NOT NULL, --/F NIII1750_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    niii1750_err_3 float NOT NULL, --/F NIII1750_ERR 2 --/U  erg/s --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    niii1750_err_4 float NOT NULL, --/F NIII1750_ERR 3 --/U  km/s --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    niii1750_err_5 float NOT NULL, --/F NIII1750_ERR 4 --/U  Angstrom --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    niii1750_err_6 float NOT NULL, --/F NIII1750_ERR 5 --/U  Angstrom --/D Uncertainties of NIII1750 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    civ_1 float NOT NULL, --/F CIV 0 --/U Angstrom --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    civ_2 float NOT NULL, --/F CIV 1 --/U  10^{-17} erg/s/cm^2 --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    civ_3 float NOT NULL, --/F CIV 2 --/U  erg/s --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    civ_4 float NOT NULL, --/F CIV 3 --/U  km/s --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    civ_5 float NOT NULL, --/F CIV 4 --/U  Angstrom --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    civ_6 float NOT NULL, --/F CIV 5 --/U  Angstrom --/D CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    civ_err_1 float NOT NULL, --/F CIV_ERR 0 --/U Angstrom --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    civ_err_2 float NOT NULL, --/F CIV_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    civ_err_3 float NOT NULL, --/F CIV_ERR 2 --/U  erg/s --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    civ_err_4 float NOT NULL, --/F CIV_ERR 3 --/U  km/s --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    civ_err_5 float NOT NULL, --/F CIV_ERR 4 --/U  Angstrom --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    civ_err_6 float NOT NULL, --/F CIV_ERR 5 --/U  Angstrom --/D Uncertainties of CIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    heii1640_1 float NOT NULL, --/F HEII1640 0 --/U Angstrom --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    heii1640_2 float NOT NULL, --/F HEII1640 1 --/U  10^{-17} erg/s/cm^2 --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    heii1640_3 float NOT NULL, --/F HEII1640 2 --/U  erg/s --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    heii1640_4 float NOT NULL, --/F HEII1640 3 --/U  km/s --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    heii1640_5 float NOT NULL, --/F HEII1640 4 --/U  Angstrom --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    heii1640_6 float NOT NULL, --/F HEII1640 5 --/U  Angstrom --/D HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    heii1640_err_1 float NOT NULL, --/F HEII1640_ERR 0 --/U Angstrom --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    heii1640_err_2 float NOT NULL, --/F HEII1640_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    heii1640_err_3 float NOT NULL, --/F HEII1640_ERR 2 --/U  erg/s --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    heii1640_err_4 float NOT NULL, --/F HEII1640_ERR 3 --/U  km/s --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    heii1640_err_5 float NOT NULL, --/F HEII1640_ERR 4 --/U  Angstrom --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    heii1640_err_6 float NOT NULL, --/F HEII1640_ERR 5 --/U  Angstrom --/D Uncertainties of HEII1640 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    heii1640_br_1 float NOT NULL, --/F HEII1640_BR 0 --/U Angstrom --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    heii1640_br_2 float NOT NULL, --/F HEII1640_BR 1 --/U  10^{-17} erg/s/cm^2 --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    heii1640_br_3 float NOT NULL, --/F HEII1640_BR 2 --/U  erg/s --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    heii1640_br_4 float NOT NULL, --/F HEII1640_BR 3 --/U  km/s --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    heii1640_br_5 float NOT NULL, --/F HEII1640_BR 4 --/U  Angstrom --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    heii1640_br_6 float NOT NULL, --/F HEII1640_BR 5 --/U  Angstrom --/D HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    heii1640_br_err_1 float NOT NULL, --/F HEII1640_BR_ERR 0 --/U Angstrom --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    heii1640_br_err_2 float NOT NULL, --/F HEII1640_BR_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    heii1640_br_err_3 float NOT NULL, --/F HEII1640_BR_ERR 2 --/U  erg/s --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    heii1640_br_err_4 float NOT NULL, --/F HEII1640_BR_ERR 3 --/U  km/s --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    heii1640_br_err_5 float NOT NULL, --/F HEII1640_BR_ERR 4 --/U  Angstrom --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    heii1640_br_err_6 float NOT NULL, --/F HEII1640_BR_ERR 5 --/U  Angstrom --/D Uncertainties of HEII1640 broad peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    siiv_oiv_1 float NOT NULL, --/F SIIV_OIV 0 --/U Angstrom --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    siiv_oiv_2 float NOT NULL, --/F SIIV_OIV 1 --/U  10^{-17} erg/s/cm^2 --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    siiv_oiv_3 float NOT NULL, --/F SIIV_OIV 2 --/U  erg/s --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    siiv_oiv_4 float NOT NULL, --/F SIIV_OIV 3 --/U  km/s --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    siiv_oiv_5 float NOT NULL, --/F SIIV_OIV 4 --/U  Angstrom --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    siiv_oiv_6 float NOT NULL, --/F SIIV_OIV 5 --/U  Angstrom --/D SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    siiv_oiv_err_1 float NOT NULL, --/F SIIV_OIV_ERR 0 --/U Angstrom --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    siiv_oiv_err_2 float NOT NULL, --/F SIIV_OIV_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    siiv_oiv_err_3 float NOT NULL, --/F SIIV_OIV_ERR 2 --/U  erg/s --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    siiv_oiv_err_4 float NOT NULL, --/F SIIV_OIV_ERR 3 --/U  km/s --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    siiv_oiv_err_5 float NOT NULL, --/F SIIV_OIV_ERR 4 --/U  Angstrom --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    siiv_oiv_err_6 float NOT NULL, --/F SIIV_OIV_ERR 5 --/U  Angstrom --/D Uncertainties of SIIV_OIV peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oi1304_1 float NOT NULL, --/F OI1304 0 --/U Angstrom --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oi1304_2 float NOT NULL, --/F OI1304 1 --/U  10^{-17} erg/s/cm^2 --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oi1304_3 float NOT NULL, --/F OI1304 2 --/U  erg/s --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oi1304_4 float NOT NULL, --/F OI1304 3 --/U  km/s --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oi1304_5 float NOT NULL, --/F OI1304 4 --/U  Angstrom --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oi1304_6 float NOT NULL, --/F OI1304 5 --/U  Angstrom --/D OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    oi1304_err_1 float NOT NULL, --/F OI1304_ERR 0 --/U Angstrom --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    oi1304_err_2 float NOT NULL, --/F OI1304_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    oi1304_err_3 float NOT NULL, --/F OI1304_ERR 2 --/U  erg/s --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    oi1304_err_4 float NOT NULL, --/F OI1304_ERR 3 --/U  km/s --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    oi1304_err_5 float NOT NULL, --/F OI1304_ERR 4 --/U  Angstrom --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    oi1304_err_6 float NOT NULL, --/F OI1304_ERR 5 --/U  Angstrom --/D Uncertainties of OI1304 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    lya_1 float NOT NULL, --/F LYA 0 --/U Angstrom --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    lya_2 float NOT NULL, --/F LYA 1 --/U  10^{-17} erg/s/cm^2 --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    lya_3 float NOT NULL, --/F LYA 2 --/U  erg/s --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    lya_4 float NOT NULL, --/F LYA 3 --/U  km/s --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    lya_5 float NOT NULL, --/F LYA 4 --/U  Angstrom --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    lya_6 float NOT NULL, --/F LYA 5 --/U  Angstrom --/D Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    lya_err_1 float NOT NULL, --/F LYA_ERR 0 --/U Angstrom --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    lya_err_2 float NOT NULL, --/F LYA_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    lya_err_3 float NOT NULL, --/F LYA_ERR 2 --/U  erg/s --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    lya_err_4 float NOT NULL, --/F LYA_ERR 3 --/U  km/s --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    lya_err_5 float NOT NULL, --/F LYA_ERR 4 --/U  Angstrom --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    lya_err_6 float NOT NULL, --/F LYA_ERR 5 --/U  Angstrom --/D Uncertainties of Lya peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    nv1240_1 float NOT NULL, --/F NV1240 0 --/U Angstrom --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    nv1240_2 float NOT NULL, --/F NV1240 1 --/U  10^{-17} erg/s/cm^2 --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    nv1240_3 float NOT NULL, --/F NV1240 2 --/U  erg/s --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    nv1240_4 float NOT NULL, --/F NV1240 3 --/U  km/s --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    nv1240_5 float NOT NULL, --/F NV1240 4 --/U  Angstrom --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    nv1240_6 float NOT NULL, --/F NV1240 5 --/U  Angstrom --/D NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    nv1240_err_1 float NOT NULL, --/F NV1240_ERR 0 --/U Angstrom --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 1) 
    nv1240_err_2 float NOT NULL, --/F NV1240_ERR 1 --/U  10^{-17} erg/s/cm^2 --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 2) 
    nv1240_err_3 float NOT NULL, --/F NV1240_ERR 2 --/U  erg/s --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 3) 
    nv1240_err_4 float NOT NULL, --/F NV1240_ERR 3 --/U  km/s --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 4) 
    nv1240_err_5 float NOT NULL, --/F NV1240_ERR 4 --/U  Angstrom --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 5) 
    nv1240_err_6 float NOT NULL, --/F NV1240_ERR 5 --/U  Angstrom --/D Uncertainties of NV1240 peak wavelength, flux, logL of lines, FWHM, rest-frame equivalent width, 50% flux centoid wavelength (array element 6) 
    ha_stat_1 float NOT NULL, --/F Ha_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    ha_stat_2 float NOT NULL, --/F Ha_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    hb_stat_1 float NOT NULL, --/F Hb_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    hb_stat_2 float NOT NULL, --/F Hb_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    hghd_stat_1 float NOT NULL, --/F HgHd_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    hghd_stat_2 float NOT NULL, --/F HgHd_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    mgii_stat_1 float NOT NULL, --/F MgII_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    mgii_stat_2 float NOT NULL, --/F MgII_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    ciii_stat_1 float NOT NULL, --/F CIII_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    ciii_stat_2 float NOT NULL, --/F CIII_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    civ_stat_1 float NOT NULL, --/F CIV_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    civ_stat_2 float NOT NULL, --/F CIV_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    siiv_stat_1 float NOT NULL, --/F SiIV_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    siiv_stat_2 float NOT NULL, --/F SiIV_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    lya_stat_1 float NOT NULL, --/F Lya_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    lya_stat_2 float NOT NULL, --/F Lya_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    caii_stat_1 float NOT NULL, --/F CaII_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    caii_stat_2 float NOT NULL, --/F CaII_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    oii_stat_1 float NOT NULL, --/F OII_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    oii_stat_2 float NOT NULL, --/F OII_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
    nev_stat_1 float NOT NULL, --/F NeV_STAT 0 --/U  --/D Complex line window pixel number, reduced chi square (array element 1) 
    nev_stat_2 float NOT NULL, --/F NeV_STAT 1 --/U  --/D Complex line window pixel number, reduced chi square (array element 2) 
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
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_c001_hard_pointsources_ctp_redshift_v17')
	DROP TABLE efeds_c001_hard_pointsources_ctp_redshift_v17
GO
--
EXEC spSetDefaultFileGroup 'efeds_c001_hard_pointsources_ctp_redshift_v17'
GO

CREATE TABLE efeds_c001_hard_pointsources_ctp_redshift_v17 (
-----------------------------------------
--/H eROSITA/eFEDS HARD point source counterparts catalogue
--/T Multiwavelength properties of the primary counterpart to the eFEDS sources in the Hard X-ray catalog
--/T (number two of this table) for which an alternative or additional counterpart can't be excluded. For
--/T each counterparts the classification, photometry and redshift is provided. Three sources have an
--/T alternative or additional counterpart: the properties can be retrieved by matching the ID_MAIN
--/T column with the ID_SRC column in the catalog above. Mar 22 2022: updated catalogue is available.
--/T Reference: https://ui.adsabs.harvard.edu/abs/2021arXiv210614520S/abstract
-----------------------------------------
    ero_name varchar(22) NOT NULL, --/D eROSITA official source Name (see Brunner et al.,) --/U 
    ero_id_src int NOT NULL, --/D ID of eROSITA source in the Main Sample (from Brunner et al. catalog) --/U 
    ero_ra_corr float NOT NULL, --/D J2000 Right Ascension of the eROSITA source (corrected) from Brunner et al. --/U degrees
    ero_dec_corr float NOT NULL, --/D J2000 Declination of the eROSITA source (corrected) from Brunner et al., --/U degrees
    ero_radec_error_corr float NOT NULL, --/D eROSITA positional uncertainty (corrected) from Brunner et al., --/U 
    ero_ml_flux_3 real NOT NULL, --/D 2.3-5 keV source flux converted from count rate assuming ECF=1.147e+11 (Gamma=2.0)]. See Brunner et al. --/U erg /cm**2 /s
    ero_ml_flux_err_3 real NOT NULL, --/D 2.3-5 keV source flux error (1 sigma) --/U erg /cm**2 /s
    ero_det_like_3 real NOT NULL, --/D 2.3-5 keV detection likelihood measured by PSF-fitting --/U 
    ero_inarea90 bit NOT NULL, --/D True if in the 0.2-2.3keV exp>500s region, which comprises 90% --/U 
    ctp_ls8_unique_objid varchar(11) NOT NULL, --/D LS8 unique identifier for the counterpart to the eROSITA source (Expression: toString(LS8_BRICKID)+"_"+toString(LS8_OBJID)) --/U 
    ctp_ls8_ra float NOT NULL, --/D J2000 Right Ascension of the LS8 countepart --/U degrees
    ctp_ls8_dec float NOT NULL, --/D J2000 Declination of the best LS8 countepart --/U degrees
    dist_ctp_ls8_ero float NOT NULL, --/D Separation between selected counterpart and eROSITA (corrected) position in arcsec --/U arcsec
    ctp_nway_ls8_unique_objid varchar(11) NOT NULL, --/D Unique OBJECTID of the best LS8 countepart from NWAY (Expression: toString(LS8_BRICKID)+"_"+toString(LS8_OBJID)) --/U 
    ctp_nway_ls8_ra float NOT NULL, --/D J2000 Right Ascension of the best LS8 countepart from NWAY --/U degrees
    ctp_nway_ls8_dec float NOT NULL, --/D J2000 Declination of the best LS8 countepart from NWAY --/U degrees
    ctp_nway_dist_bayesfactor real NOT NULL, --/D Logarithm of ratio between prior and posterior, from separation, positional error and number density (see Appx. in Salvato et al 2018 for clarifications) --/U 
    ctp_nway_dist_post real NOT NULL, --/D Distance posterior probability comparing this association vs. no association (see Appx. in Salvato et al 2018 for clarifications) --/U 
    ctp_nway_p_single real NOT NULL, --/D Same as dist_post, but weighted by the prior (see Appx. in Salvato et al 2018 for clarifications) --/U 
    ctp_nway_p_any real NOT NULL, --/D For each entry in the X-ray catalogue, the probability that there is a counterpart in LS8 (see Appx. in Salvato et al 2018 for clarifications) --/U 
    ctp_nway_p_i real NOT NULL, --/D Relative probability of the eROSITA/LS8 match (see Appx. in Salvato et al 2018 for clarifications) --/U 
    dist_nway_ls8_ero real NOT NULL, --/D Separation between the Xray position and the best LS8 counterparts from NWAY --/U arcsec
    ctp_mlr_ls8_unique_objid varchar(11) NOT NULL, --/D LS8 unique identifier of the LS8 counterpart from Maximum Likelihood Ratio technique --/U 
    ctp_mlr_ls8_ra float NOT NULL, --/D J2000 Right Ascension of LS8 counterpart from Maximum Likelihood Ratio technique --/U degrees
    ctp_mlr_ls8_dec float NOT NULL, --/D J2000 Declination of LS8 counterpart from Maximum Likelihood Ratio technique --/U degrees
    ctp_mlr_lr_best float NOT NULL, --/D Likelihood Ratio value from Maximum Likelihood Ratio technique --/U 
    ctp_mlr_rel_best float NOT NULL, --/D Reliability of the identification from Maximum Likelihood Ratio technique --/U 
    dist_mlr_ls8_ero float NOT NULL, --/D Separation between the Xray position and the best LS8 counterparts from Maximum Likelihood Ratio technique --/U arcsec
    ctp_same smallint NOT NULL, --/D Comparison NWAY/MLR: true if the counterpart selected by the two method is the same --/U 
    ctp_mlr smallint NOT NULL, --/D Comparison NWAY/MLR: true if the counterpart from NWAY(MLR) has p_any(LR_BEST) below(above) threshold --/U 
    ctp_hamstar int NOT NULL, --/D Match to Hamstar: 1=same counterpart, 0=different counterpart, -99=no Hamstar (Schneider et al) --/U 
    ctp_hamstar_p_stellar float NOT NULL, --/D Probability of association from Hamstar. --/U arcsec
    dist_ctp_hamstar float NOT NULL, --/D Separation between the counterpart proposed by Hamstar and the counterpart selected in this work --/U arcsec
    ctp_quality smallint NOT NULL, --/D Counterpart quality: 4=best, 3=good, 2=with secondary, 1/0=unreliable. (see flow chart paper) --/U 
    gaiaedr3_id bigint NOT NULL, --/D ID in Gaia EDR3 source catalog --/U 
    gaiaedr3_parallax float NOT NULL, --/D Parallax from Gaia EDR3 --/U mas
    gaiaedr3_parallax_error float NOT NULL, --/D Parallax error from Gaia EDR3 --/U mas
    gaiaedr3_parallax_over_error float NOT NULL, --/D Parallax/Parallax error. ratio $>$5 SECURE GALACTIC --/U 
    gaiaedr3_pmra float NOT NULL, --/D Proper motion in RA from Gaia EDR3 --/U mas/yr
    gaiaedr3_pmra_error float NOT NULL, --/D Error on Proper motion in RA from Gaia EDR3 --/U mas/yr
    gaiaedr3_pmdec float NOT NULL, --/D Proper motion in Dec from Gaia EDR3 --/U mas/yr
    gaiaedr3_pmdec_error float NOT NULL, --/D Error on Proper motion in Dec from Gaia EDR3 --/U mas/yr
    gaiaedr3_phot_g_mean_mag float NOT NULL, --/D g band magnitude (VEGA) from Gaia EDR3 --/U Vegamag
    gaiaedr3_phot_g_mean_mag_error float NOT NULL, --/D Error g band magnitude from Gaia EDR3 --/U Vegamag
    gaiaedr3_phot_bp_mean_mag float NOT NULL, --/D bp band magnitude (VEGA) from Gaia EDR3 --/U Vegamag
    gaiaedr3_phot_bp_mean_mag_error float NOT NULL, --/D Error bp band magnitude from Gaia EDR3 --/U Vegamag
    gaiaedr3_phot_rp_mean_mag float NOT NULL, --/D rp band magnitude (VEGA) from Gaia EDR3 --/U Vegamag
    gaiaedr3_phot_rp_mean_mag_error float NOT NULL, --/D Error bp band magnitude from Gaia EDR3 --/U Vegamag
    fuv float NOT NULL, --/D Galex Far UV magnitude (AB) --/U mag
    fuv_err float NOT NULL, --/D Galex Far UV magnitude error --/U mag
    nuv float NOT NULL, --/D Galex Near UV magnitude (AB) --/U mag
    nuv_err float NOT NULL, --/D Galex Near UV magnitude error --/U mag
    kids_u float NOT NULL, --/D KiDS u-band magnitude (AB) --/U mag
    kids_u_err float NOT NULL, --/D KiDS u-band magnitude error --/U mag
    kids_g float NOT NULL, --/D KiDS g-band magnitude (AB) --/U mag
    kids_g_err float NOT NULL, --/D KiDS g-band magnitude error --/U mag
    kids_r float NOT NULL, --/D KiDS r-band magnitude (AB) --/U mag
    kids_r_err float NOT NULL, --/D KiDS r-band magnitude error --/U mag
    kids_i float NOT NULL, --/D KiDS i-band magnitude (AB) --/U mag
    kids_i_err float NOT NULL, --/D KiDS i-band magnitude error --/U mag
    omegac_z smallint NOT NULL, --/D OmegaCAM z-band magnitude (AB) --/U mag
    omegac_z_err real NOT NULL, --/D OmegaCAM z-band magnitude error --/U mag
    hsc_g float NOT NULL, --/D HSC g-band magnitude (AB) --/U 
    hsc_g_err float NOT NULL, --/D HSC g-band magnitude error --/U mag
    hsc_r float NOT NULL, --/D HSC r-band magnitude (AB) when images are mostly from r-filter (see text) --/U 
    hsc_r_err float NOT NULL, --/D HSC r-band magnitude error --/U mag
    hsc_r2 float NOT NULL, --/D HSC r2-band magnitude (AB) when images are mostly from r2-filter (see text) --/U 
    hsc_r2_err float NOT NULL, --/D HSC r2-band magnitude error --/U 
    hsc_i float NOT NULL, --/D HSC i-band magnitude (AB) when images are mostly from i-filter (see text) --/U 
    hsc_i_err float NOT NULL, --/D HSC i-band magnitude error --/U mag
    hsc_i2 float NOT NULL, --/D HSC i2-band magnitude (AB) when images are mostly from i2-filter (see text) --/U 
    hsc_i2_err float NOT NULL, --/D HSC i2-band magnitude error --/U 
    hsc_z float NOT NULL, --/D HSC z-band magnitude (AB) --/U 
    hsc_z_err float NOT NULL, --/D HSC z-band magnitude error --/U mag
    hsc_y float NOT NULL, --/D HSC Y-band magnitude (AB) --/U 
    hsc_y_err float NOT NULL, --/D HSC Y-band magnitude error --/U mag
    vista_z float NOT NULL, --/D VISTA/VIKING z-band magnitude (AB) --/U mag
    vista_z_err float NOT NULL, --/D VISTA/VIKING z-band magnitude error --/U mag
    vista_y float NOT NULL, --/D VISTA/VIKING Y-band magnitude (AB) --/U mag
    vista_y_err float NOT NULL, --/D VISTA/VIKING Y-band magnitude error --/U mag
    vista_j float NOT NULL, --/D VISTA/VIKING J-band magnitude (AB) --/U mag
    vista_j_err float NOT NULL, --/D VISTA/VIKING J-band magnitude error --/U mag
    vista_h float NOT NULL, --/D VISTA/VIKING H-band magnitude (AB) --/U mag
    vista_h_err float NOT NULL, --/D VISTA/VIKING H-band magnitude error --/U mag
    vista_ks float NOT NULL, --/D VISTA/VIKING Ks-band magnitude (AB --/U mag
    vista_ks_err float NOT NULL, --/D VISTA/VIKING Ks-band magnitude error --/U mag
    w1 float NOT NULL, --/D LS8/Wise W1 magnitude (AB) --/U mag
    w1_err float NOT NULL, --/D LS8/Wise W1 magnitude error --/U mag
    w2 float NOT NULL, --/D LS8/Wise W2 magnitude (AB) --/U mag
    w2_err float NOT NULL, --/D LS8/Wise W2 magnitude error --/U mag
    w3 float NOT NULL, --/D LS8/Wise W3 magnitude (AB) --/U mag
    w3_err float NOT NULL, --/D LS8/Wise W3 magnitude error --/U mag
    w4 float NOT NULL, --/D LS8/Wise W4 magnitude (AB) --/U mag
    w4_err float NOT NULL, --/D LS8/Wise W4 magnitude error --/U mag
    ls8_g float NOT NULL, --/D LS8 g-band magnitude (AB) --/U mag
    ls8_g_err float NOT NULL, --/D LS8 g-band magnitude error --/U mag
    ls8_r float NOT NULL, --/D LS8 r-band magnitude (AB) --/U mag
    ls8_r_err float NOT NULL, --/D LS8 r-band magnitude error --/U mag
    ls8_z float NOT NULL, --/D LS8 z-band magnitude (AB) --/U mag
    ls8_z_err float NOT NULL, --/D LS8 z-band magnitude error --/U mag
    vhs_y float NOT NULL, --/D VISTA/VHS Y-band magnitude (AB) --/U mag
    vhs_y_err real NOT NULL, --/D VISTA/VHS Y-band magnitude error --/U mag
    vhs_h float NOT NULL, --/D VISTA/VHS H-band magnitude (AB) --/U mag
    vhs_h_err real NOT NULL, --/D VISTA/VHS H-band magnitude error --/U mag
    vhs_ks float NOT NULL, --/D VISTA/VHS Ks-band magnitude (AB) --/U mag
    vhs_ks_err real NOT NULL, --/D VISTA/VHS Ks-band magnitude error --/U mag
    hsc_g_diff float NOT NULL, --/D Difference between psf and Kron magnitude in HSC g-band (AB) --/U mag
    hsc_r_diff float NOT NULL, --/D Difference between psf and Kron magnitude in HSC r-band (AB) --/U mag
    hsc_i_diff float NOT NULL, --/D Difference between psf and Kron magnitude in HSC i-band (AB) --/U mag
    hsc_z_diff float NOT NULL, --/D Difference between psf and Kron magnitude in HSC z-band (AB) --/U mag
    hsc_opt_extended int NOT NULL, --/D Extension in HSC griz bands. 1=extended; -99=data missing 0=other from Aihara et al 2018 --/U 
    ctp_ls8_phot_flag bit NOT NULL, --/D Flag for LS8 photometry: true when the source has simultaneously g,r,z,w1 photometry in LS8 --/U 
    ctp_ls8_type varchar(4) NOT NULL, --/D Morphological model from LS8 --/U 
    in_kids smallint NOT NULL, --/D in_KiDS --/U 
    in_hsc smallint NOT NULL, --/D in_HSC --/U 
    specz_ra float NOT NULL, --/D J2000 Right Ascension of the spectroscopic redshift entry in the original catalogue from which it was taken --/U degrees
    specz_dec float NOT NULL, --/D J2000 Declination of the spectroscopic redshift entry in the original catalogue from which it was taken --/U degrees
    specz_redshift float NOT NULL, --/D Spectroscopic redshift from original catalog --/U 
    specz_normq int NOT NULL, --/D Normalised quality of spectroscopic redshift: 3=secure, 2=not secure, 1=unreliable, -1= Blazar candidate --/U 
    specz_origin varchar(8) NOT NULL, --/D Catalogue which provided this spectroscopic redshift --/U 
    specz_original_id varchar(12) NOT NULL, --/D Identifier of this entry in the original catalogue from which it was taken --/U 
    orig_id_spec varchar(23) NOT NULL, --/D ORIG_ID_spec --/U 
    specz_galaxy_flag bit NOT NULL, --/D True when the CTP has a reliable redshift above 0.002 --/U 
    specz_star_flag bit NOT NULL, --/D True when the CTP has a reliable redshift below 0.002 --/U 
    ctp_classification varchar(20) NOT NULL, --/D SECURE/LIKELY GALACTIC/EXTRAGALACTIC, as from flowchart (see paper) --/U 
    phz_lephare_zphot real NOT NULL, --/D Photoz from Le PHARE, but set to 0 for GALACTIC sources --/U 
    phz_lephare_zl68 real NOT NULL, --/D Le PHARE zphot min at 1 sigma --/U 
    phz_lephare_zu68 real NOT NULL, --/D Le PHARE zphot max at 1 sigma --/U 
    phz_lephare_zl90 real NOT NULL, --/D Le PHARE zphot min at 2 sigma --/U 
    phz_lephare_zu90 real NOT NULL, --/D Le PHARE zphot max at 2 sigma --/U 
    phz_lephare_zl99 real NOT NULL, --/D Le PHARE zphot min at 3 sigma --/U 
    phz_lephare_zu99 real NOT NULL, --/D Le PHARE zphot max at 3 sigma --/U 
    phz_lephare_chi2 float NOT NULL, --/D Le PHARE chi2 value for best fitting galaxy/AGN template --/U 
    phz_lephare_modelagn smallint NOT NULL, --/D Le PHARE model number for best template fitting the data (for PLIKE 1000+model number) --/U 
    phz_lephare_extlaw smallint NOT NULL, --/D Le PHARE Extinction Law applied to the template: Prevot (1) or none (0) --/U 
    phz_lephare_ebv real NOT NULL, --/D Le PHARE E(B-V) applied to the template --/U 
    phz_lephare_pdz real NOT NULL, --/D Le Phare probability distribution. Photoz more reliable when value is high --/U 
    phz_lephare_nband smallint NOT NULL, --/D Le Phare number of bands used for the computation of photoz --/U 
    phz_lephare_zphot_2 real NOT NULL, --/D Le Phare second best photoz from LePhare, if existing --/U 
    phz_lephare_chi2_2 float NOT NULL, --/D Le Phare chi2 value for second best fitting template, if existing --/U 
    phz_lephare_modelagn_2 smallint NOT NULL, --/D Le Phare second best template fitting the data, if existing --/U 
    phz_lephare_pdz_2 real NOT NULL, --/D Le Phare probability distribution for secondary solution, if existing --/U 
    orig_dnnz_best float NOT NULL, --/D orig_dnnz_best --/U 
    phz_dnnz_zphot float NOT NULL, --/D Photoz from DNNZ (from Nishizawa et al.,), but set to 0 for GALACTIC sources --/U 
    phz_dnnz_zl68 float NOT NULL, --/D DNNz zphot min at 1 sigma --/U 
    phz_dnnz_zu68 float NOT NULL, --/D DNNz zphot max at 1 sigma --/U 
    phz_dnnz_zl95 float NOT NULL, --/D DNNz zphot min at 2 sigma --/U 
    phz_dnnz_zu95 float NOT NULL, --/D DNNz zphot max at 2 sigma --/U 
    ctp_redshift float NOT NULL, --/D Final redshift: zspec when available, else photo-z from Le PHARE; 0 for GALACTIC sources --/U 
    ctp_redshift_grade smallint NOT NULL, --/D In a range from 5 (spectroscopy) to 0 (unreliable photo-z). (See paper for details). --/U 
    cluster_class smallint NOT NULL, --/D Range from 5 (most likely a cluster) to 1 (not a cluster) (see paper for details) --/U 
    ctp_class smallint NOT NULL, --/D same as CTP_classification, but with numbers: 3: SECURE EXTRAGALACTIC; 2: LIKELY EXTRAGALACTIC; 1: SECURE GALACTIC; 0: LIKELY GALACTIC --/U 
    ero_id_main int NOT NULL --/D Source ID in the single-band detected, eFEDS Main catalog from Brunner et al. --/U 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_c001_hard_v7_5')
	DROP TABLE efeds_c001_hard_v7_5
GO
--
EXEC spSetDefaultFileGroup 'efeds_c001_hard_v7_5'
GO

CREATE TABLE efeds_c001_hard_v7_5 (
-----------------------------------------
--/H eROSITA/eFEDS hard catalogue
--/T Hard X-ray selected eFEDS catalogue. Based on sources detection in three bands (1: 0.2-0.6; 2:
--/T 0.6-2.3; 3: 2.3-5 keV) using eSASS adopting a detection likelihood threshold of 5, we select the
--/T sources with a 2.3-5 keV band detection likelihood greater than 10 and a zero extent likelihood as
--/T the hard eFEDS catalog (246 sources).
--/T Reference: https://ui.adsabs.harvard.edu/abs/2021arXiv210614517B/abstract
-----------------------------------------
    name varchar(22) NOT NULL, --/D Source name --/U 
    id_src int NOT NULL, --/D Source ID --/U 
    id_main int NOT NULL, --/D Source ID in the single-band detected, eFEDS main catalog --/U 
    ra float NOT NULL, --/D Uncorrected RA (ICRS) --/U deg
    dec float NOT NULL, --/D Uncorrected Dec (ICRS) --/U deg
    radec_err real NOT NULL, --/D Combined positional uncertainty, uncorrected --/U arcsec
    ra_corr float NOT NULL, --/D Corrected RA (ICRS) --/U deg
    dec_corr float NOT NULL, --/D Corrected Dec (ICRS) --/U deg
    radec_err_corr float NOT NULL, --/D Combined positional uncertainty, corrected --/U arcsec
    ext real NOT NULL, --/D Source extent --/U arcsec
    ext_err real NOT NULL, --/D Extent error --/U arcsec
    ext_like real NOT NULL, --/D Extent likelihood --/U 
    det_like_0 real NOT NULL, --/D Detection likelihood measured by PSF-fitting --/U 
    ml_rate_0 real NOT NULL, --/D Source count rate --/U counts/s
    ml_rate_err_0 real NOT NULL, --/D 1 sigma count rate error --/U counts/s
    ml_cts_0 real NOT NULL, --/D Source net counts, combining 3 bands --/U counts
    ml_cts_err_0 real NOT NULL, --/D 1 sigma counts error --/U counts
    ml_flux_0 real NOT NULL, --/D Source flux --/U erg/cm^2/s
    ml_flux_err_0 real NOT NULL, --/D 1 sigma flux error --/U erg/cm^2/s
    ml_bkg_0 real NOT NULL, --/D Background at the source position --/U counts/arcmin^2
    inarea90 bit NOT NULL, --/D True if in the 0.2-2.3keV exp>500s region, which comprises 90% area --/U 
    det_like_1 real NOT NULL, --/D Detection likelihood measured by PSF-fitting --/U 
    det_like_2 real NOT NULL, --/D Detection likelihood measured by PSF-fitting --/U 
    det_like_3 real NOT NULL, --/D Detection likelihood measured by PSF-fitting --/U 
    ml_rate_1 real NOT NULL, --/D Source count rate measured by PSF-fitting --/U counts/s
    ml_rate_2 real NOT NULL, --/D Source count rate measured by PSF-fitting --/U counts/s
    ml_rate_3 real NOT NULL, --/D Source count rate measured by PSF-fitting --/U counts/s
    ml_rate_err_1 real NOT NULL, --/D 1 sigma count rate error --/U counts/s
    ml_rate_err_2 real NOT NULL, --/D 1 sigma count rate error --/U counts/s
    ml_rate_err_3 real NOT NULL, --/D 1 sigma count rate error --/U counts/s
    ml_cts_1 real NOT NULL, --/D Source net counts measured from count rate --/U counts
    ml_cts_2 real NOT NULL, --/D Source net counts measured from count rate --/U counts
    ml_cts_3 real NOT NULL, --/D Source net counts measured from count rate --/U counts
    ml_cts_err_1 real NOT NULL, --/D 1 sigma counts error --/U counts
    ml_cts_err_2 real NOT NULL, --/D 1 sigma counts error --/U counts
    ml_cts_err_3 real NOT NULL, --/D 1 sigma counts error --/U counts
    ml_flux_1 real NOT NULL, --/D Source flux converted from count rate --/U erg/cm^2/s
    ml_flux_2 real NOT NULL, --/D Source flux converted from count rate --/U erg/cm^2/s
    ml_flux_3 real NOT NULL, --/D Source flux converted from count rate --/U erg/cm^2/s
    ml_flux_err_1 real NOT NULL, --/D 1 sigma flux error --/U erg/cm^2/s
    ml_flux_err_2 real NOT NULL, --/D 1 sigma flux error --/U erg/cm^2/s
    ml_flux_err_3 real NOT NULL, --/D 1 sigma flux error --/U erg/cm^2/s
    ml_exp_1 real NOT NULL, --/D Vignetted exposure value --/U seconds
    ml_exp_2 real NOT NULL, --/D Vignetted exposure value --/U seconds
    ml_exp_3 real NOT NULL, --/D Vignetted exposure value --/U seconds
    ml_bkg_1 real NOT NULL, --/D Background at the source position --/U counts/arcmin^2
    ml_bkg_2 real NOT NULL, --/D Background at the source position --/U counts/arcmin^2
    ml_bkg_3 real NOT NULL, --/D Background at the source position --/U counts/arcmin^2
    det_like_b1 float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 0.2-0.5 keV --/U 
    det_like_b2 float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 0.5-1 keV --/U 
    det_like_b3 float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 1-2 keV --/U 
    det_like_b4 float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 2-4.5 keV --/U 
    det_like_s float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 0.5-2 keV --/U 
    det_like_h float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 2.3-5 keV --/U 
    det_like_u float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 5-8 keV --/U 
    ml_rate_b1 float NOT NULL, --/D Source count rate measured by forced PSF-fitting;.2-.5keV --/U counts/s
    ml_rate_b2 float NOT NULL, --/D Source count rate measured by forced PSF-fitting;0.5-1keV --/U counts/s
    ml_rate_b3 float NOT NULL, --/D Source count rate measured by forced PSF-fitting; 1-2 keV --/U counts/s
    ml_rate_b4 float NOT NULL, --/D Source count rate measured by forced PSF-fitting;2-4.5keV --/U counts/s
    ml_rate_s float NOT NULL, --/D Source count rate measured by forced PSF-fitting;0.5-2keV --/U counts/s
    ml_rate_h float NOT NULL, --/D Source count rate measured by forced PSF-fitting;2.3-5keV --/U counts/s
    ml_rate_u float NOT NULL, --/D Source count rate measured by forced PSF-fitting; 5-8 keV --/U counts/s
    ml_rate_err_b1 float NOT NULL, --/D 1 sigma count rate error; 0.2-0.5 keV --/U counts/s
    ml_rate_err_b2 float NOT NULL, --/D 1 sigma count rate error; 0.5-1 keV --/U counts/s
    ml_rate_err_b3 float NOT NULL, --/D 1 sigma count rate error; 1-2 keV --/U counts/s
    ml_rate_err_b4 float NOT NULL, --/D 1 sigma count rate error; 2-4.5 keV --/U counts/s
    ml_rate_err_s float NOT NULL, --/D 1 sigma count rate error; 0.5-2 keV --/U counts/s
    ml_rate_err_h float NOT NULL, --/D 1 sigma count rate error; 2.3-5 keV --/U counts/s
    ml_rate_err_u float NOT NULL, --/D 1 sigma count rate error; 5-8 keV --/U counts/s
    ml_rate_lowerr_b1 float NOT NULL, --/D 1 sigma lower error of count rate;0.2-0.5 keV --/U counts/s
    ml_rate_lowerr_b2 float NOT NULL, --/D 1 sigma lower error of count rate;0.5-1 keV --/U counts/s
    ml_rate_lowerr_b3 float NOT NULL, --/D 1 sigma lower error of count rate;1-2 keV --/U counts/s
    ml_rate_lowerr_b4 float NOT NULL, --/D 1 sigma lower error of count rate;2-4.5 keV --/U counts/s
    ml_rate_lowerr_s float NOT NULL, --/D 1 sigma lower error of count rate;0.5-2 keV --/U counts/s
    ml_rate_lowerr_h float NOT NULL, --/D 1 sigma lower error of count rate;2.3-5 keV --/U counts/s
    ml_rate_lowerr_u float NOT NULL, --/D 1 sigma lower error of count rate;5-8 keV --/U counts/s
    ml_rate_uperr_b1 float NOT NULL, --/D 1 sigma upper error of count rate;0.2-0.5 keV --/U counts/s
    ml_rate_uperr_b2 float NOT NULL, --/D 1 sigma upper error of count rate;0.5-1 keV --/U counts/s
    ml_rate_uperr_b3 float NOT NULL, --/D 1 sigma upper error of count rate;1-2 keV --/U counts/s
    ml_rate_uperr_b4 float NOT NULL, --/D 1 sigma upper error of count rate;2-4.5 keV --/U counts/s
    ml_rate_uperr_s float NOT NULL, --/D 1 sigma upper error of count rate;0.5-2 keV --/U counts/s
    ml_rate_uperr_h float NOT NULL, --/D 1 sigma upper error of count rate;2.3-5 keV --/U counts/s
    ml_rate_uperr_u float NOT NULL, --/D 1 sigma upper error of count rate;5-8 keV --/U counts/s
    ml_cts_b1 float NOT NULL, --/D Source net counts measured from count rate; 0.2-0.5 keV --/U counts
    ml_cts_b2 float NOT NULL, --/D Source net counts measured from count rate; 0.5-1 keV --/U counts
    ml_cts_b3 float NOT NULL, --/D Source net counts measured from count rate; 1-2 keV --/U counts
    ml_cts_b4 float NOT NULL, --/D Source net counts measured from count rate; 2-4.5 keV --/U counts
    ml_cts_s float NOT NULL, --/D Source net counts measured from count rate; 0.5-2 keV --/U counts
    ml_cts_h float NOT NULL, --/D Source net counts measured from count rate; 2.3-5 keV --/U counts
    ml_cts_u float NOT NULL, --/D Source net counts measured from count rate; 5-8 keV --/U counts
    ml_cts_err_b1 float NOT NULL, --/D 1 sigma counts error; 0.2-0.5 keV --/U counts
    ml_cts_err_b2 float NOT NULL, --/D 1 sigma counts error; 0.5-1 keV --/U counts
    ml_cts_err_b3 float NOT NULL, --/D 1 sigma counts error; 1-2 keV --/U counts
    ml_cts_err_b4 float NOT NULL, --/D 1 sigma counts error; 2-4.5 keV --/U counts
    ml_cts_err_s float NOT NULL, --/D 1 sigma counts error; 0.5-2 keV --/U counts
    ml_cts_err_h float NOT NULL, --/D 1 sigma counts error; 2.3-5 keV --/U counts
    ml_cts_err_u float NOT NULL, --/D 1 sigma counts error; 5-8 keV --/U counts
    ml_cts_lowerr_b1 float NOT NULL, --/D 1 sigma lower error of counts;0.2-0.5 keV --/U counts
    ml_cts_lowerr_b2 float NOT NULL, --/D 1 sigma lower error of counts;0.5-1 keV --/U counts
    ml_cts_lowerr_b3 float NOT NULL, --/D 1 sigma lower error of counts;1-2 keV --/U counts
    ml_cts_lowerr_b4 float NOT NULL, --/D 1 sigma lower error of counts;2-4.5 keV --/U counts
    ml_cts_lowerr_s float NOT NULL, --/D 1 sigma lower error of counts;0.5-2 keV --/U counts
    ml_cts_lowerr_h float NOT NULL, --/D 1 sigma lower error of counts;2.3-5 keV --/U counts
    ml_cts_lowerr_u float NOT NULL, --/D 1 sigma lower error of counts;5-8 keV --/U counts
    ml_cts_uperr_b1 float NOT NULL, --/D 1 sigma upper error of counts;0.2-0.5 keV --/U counts
    ml_cts_uperr_b2 float NOT NULL, --/D 1 sigma upper error of counts;0.5-1 keV --/U counts
    ml_cts_uperr_b3 float NOT NULL, --/D 1 sigma upper error of counts;1-2 keV --/U counts
    ml_cts_uperr_b4 float NOT NULL, --/D 1 sigma upper error of counts;2-4.5 keV --/U counts
    ml_cts_uperr_s float NOT NULL, --/D 1 sigma upper error of counts;0.5-2 keV --/U counts
    ml_cts_uperr_h float NOT NULL, --/D 1 sigma upper error of counts;2.3-5 keV --/U counts
    ml_cts_uperr_u float NOT NULL, --/D 1 sigma upper error of counts;5-8 keV --/U counts
    ml_flux_b1 float NOT NULL, --/D Source flux converted from count rate; 0.2-0.5 keV --/U erg/cm^2/s
    ml_flux_b2 float NOT NULL, --/D Source flux converted from count rate; 0.5-1 keV --/U erg/cm^2/s
    ml_flux_b3 float NOT NULL, --/D Source flux converted from count rate; 1-2 keV --/U erg/cm^2/s
    ml_flux_b4 float NOT NULL, --/D Source flux converted from count rate; 2-4.5 keV --/U erg/cm^2/s
    ml_flux_s float NOT NULL, --/D Source flux converted from count rate; 0.5-2 keV --/U erg/cm^2/s
    ml_flux_h float NOT NULL, --/D Source flux converted from count rate; 2.3-5 keV --/U erg/cm^2/s
    ml_flux_u float NOT NULL, --/D Source flux converted from count rate; 5-8 keV --/U erg/cm^2/s
    ml_flux_err_b1 float NOT NULL, --/D 1 sigma flux error; 0.2-0.5 keV --/U erg/cm^2/s
    ml_flux_err_b2 float NOT NULL, --/D 1 sigma flux error; 0.5-1 keV --/U erg/cm^2/s
    ml_flux_err_b3 float NOT NULL, --/D 1 sigma flux error; 1-2 keV --/U erg/cm^2/s
    ml_flux_err_b4 float NOT NULL, --/D 1 sigma flux error; 2-4.5 keV --/U erg/cm^2/s
    ml_flux_err_s float NOT NULL, --/D 1 sigma flux error; 0.5-2 keV --/U erg/cm^2/s
    ml_flux_err_h float NOT NULL, --/D 1 sigma flux error; 2.3-5 keV --/U erg/cm^2/s
    ml_flux_err_u float NOT NULL, --/D 1 sigma flux error; 5-8 keV --/U erg/cm^2/s
    ml_flux_lowerr_b1 float NOT NULL, --/D 1 sigma lower error of flux;0.2-0.5 keV --/U erg/cm^2/s
    ml_flux_lowerr_b2 float NOT NULL, --/D 1 sigma lower error of flux;0.5-1 keV --/U erg/cm^2/s
    ml_flux_lowerr_b3 float NOT NULL, --/D 1 sigma lower error of flux;1-2 keV --/U erg/cm^2/s
    ml_flux_lowerr_b4 float NOT NULL, --/D 1 sigma lower error of flux;2-4.5 keV --/U erg/cm^2/s
    ml_flux_lowerr_s float NOT NULL, --/D 1 sigma lower error of flux;0.5-2 keV --/U erg/cm^2/s
    ml_flux_lowerr_h float NOT NULL, --/D 1 sigma lower error of flux;2.3-5 keV --/U erg/cm^2/s
    ml_flux_lowerr_u float NOT NULL, --/D 1 sigma lower error of flux;5-8 keV --/U erg/cm^2/s
    ml_flux_uperr_b1 float NOT NULL, --/D 1 sigma upper error of flux;0.2-0.5 keV --/U erg/cm^2/s
    ml_flux_uperr_b2 float NOT NULL, --/D 1 sigma upper error of flux;0.5-1 keV --/U erg/cm^2/s
    ml_flux_uperr_b3 float NOT NULL, --/D 1 sigma upper error of flux;1-2 keV --/U erg/cm^2/s
    ml_flux_uperr_b4 float NOT NULL, --/D 1 sigma upper error of flux;2-4.5 keV --/U erg/cm^2/s
    ml_flux_uperr_s float NOT NULL, --/D 1 sigma upper error of flux;0.5-2 keV --/U erg/cm^2/s
    ml_flux_uperr_h float NOT NULL, --/D 1 sigma upper error of flux;2.3-5 keV --/U erg/cm^2/s
    ml_flux_uperr_u float NOT NULL, --/D 1 sigma upper error of flux;5-8 keV --/U erg/cm^2/s
    ml_exp_b1 float NOT NULL, --/D Vignetted exposure value; 0.2-0.5 keV --/U seconds
    ml_exp_b2 float NOT NULL, --/D Vignetted exposure value; 0.5-1 keV --/U seconds
    ml_exp_b3 float NOT NULL, --/D Vignetted exposure value; 1-2 keV --/U seconds
    ml_exp_b4 float NOT NULL, --/D Vignetted exposure value; 2-4.5 keV --/U seconds
    ml_exp_s float NOT NULL, --/D Vignetted exposure value; 0.5-2 keV --/U seconds
    ml_exp_h float NOT NULL, --/D Vignetted exposure value; 2.3-5 keV --/U seconds
    ml_exp_u float NOT NULL, --/D Vignetted exposure value; 5-8 keV --/U seconds
    ml_bkg_b1 float NOT NULL, --/D Background at the source position; 0.2-0.5keV --/U counts/arcmin^2
    ml_bkg_b2 float NOT NULL, --/D Background at the source position; 0.5-1 keV --/U counts/arcmin^2
    ml_bkg_b3 float NOT NULL, --/D Background at the source position; 1-2 keV --/U counts/arcmin^2
    ml_bkg_b4 float NOT NULL, --/D Background at the source position; 2-4.5 keV --/U counts/arcmin^2
    ml_bkg_s float NOT NULL, --/D Background at the source position; 0.5-2 keV --/U counts/arcmin^2
    ml_bkg_h float NOT NULL, --/D Background at the source position; 2.3-5 keV --/U counts/arcmin^2
    ml_bkg_u float NOT NULL, --/D Background at the source position; 5-8 keV --/U counts/arcmin^2
    ape_cts_b1 int NOT NULL, --/D Total counts extracted in the aperture; 0.2-0.5 keV --/U counts
    ape_cts_b2 int NOT NULL, --/D Total counts extracted in the aperture; 0.5-1 keV --/U counts
    ape_cts_b3 int NOT NULL, --/D Total counts extracted in the aperture; 1-2 keV --/U counts
    ape_cts_b4 int NOT NULL, --/D Total counts extracted in the aperture; 2-4.5 keV --/U counts
    ape_cts_s int NOT NULL, --/D Total counts extracted in the aperture; 0.5-2 keV --/U counts
    ape_cts_h int NOT NULL, --/D Total counts extracted in the aperture; 2.3-5 keV --/U counts
    ape_cts_u int NOT NULL, --/D Total counts extracted in the aperture; 5-8 keV --/U counts
    ape_exp_b1 float NOT NULL, --/D Vignetted exposure value; 0.2-0.5 keV --/U seconds
    ape_exp_b2 float NOT NULL, --/D Vignetted exposure value; 0.5-1 keV --/U seconds
    ape_exp_b3 float NOT NULL, --/D Vignetted exposure value; 1-2 keV --/U seconds
    ape_exp_b4 float NOT NULL, --/D Vignetted exposure value; 2-4.5 keV --/U seconds
    ape_exp_s float NOT NULL, --/D Vignetted exposure value; 0.5-2 keV --/U seconds
    ape_exp_h float NOT NULL, --/D Vignetted exposure value; 2.3-5 keV --/U seconds
    ape_exp_u float NOT NULL, --/D Vignetted exposure value; 5-8 keV --/U seconds
    ape_bkg_b1 float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;.2-.5keV --/U counts
    ape_bkg_b2 float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;0.5-1keV --/U counts
    ape_bkg_b3 float NOT NULL, --/D Background counts in the aperture, excluding nearby sources; 1-2 keV --/U counts
    ape_bkg_b4 float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;2-4.5keV --/U counts
    ape_bkg_s float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;0.5-2keV --/U counts
    ape_bkg_h float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;2.3-5keV --/U counts
    ape_bkg_u float NOT NULL, --/D Background counts in the aperture, excluding nearby sources; 5-8 keV --/U counts
    ape_radius_b1 float NOT NULL, --/D Aperture radius; 0.2-0.5 keV --/U pixels
    ape_radius_b2 float NOT NULL, --/D Aperture radius; 0.5-1 keV --/U pixels
    ape_radius_b3 float NOT NULL, --/D Aperture radius; 1-2 keV --/U pixels
    ape_radius_b4 float NOT NULL, --/D Aperture radius; 2-4.5 keV --/U pixels
    ape_radius_s float NOT NULL, --/D Aperture radius; 0.5-2 keV --/U pixels
    ape_radius_h float NOT NULL, --/D Aperture radius; 2.3-5 keV --/U pixels
    ape_radius_u float NOT NULL, --/D Aperture radius; 5-8 keV --/U pixels
    ape_pois_b1 float NOT NULL, --/D Poisson probability of being background fluctuation; 0.2-0.5 keV --/U 
    ape_pois_b2 float NOT NULL, --/D Poisson probability of being background fluctuation; 0.5-1 keV --/U 
    ape_pois_b3 float NOT NULL, --/D Poisson probability of being background fluctuation; 1-2 keV --/U 
    ape_pois_b4 float NOT NULL, --/D Poisson probability of being background fluctuation; 2-4.5 keV --/U 
    ape_pois_s float NOT NULL, --/D Poisson probability of being background fluctuation; 0.5-2 keV --/U 
    ape_pois_h float NOT NULL, --/D Poisson probability of being background fluctuation; 2.3-5 keV --/U 
    ape_pois_u float NOT NULL --/D Poisson probability of being background fluctuation; 5-8 keV --/U 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_c001_main_pointsources_ctp_redshift_v17')
	DROP TABLE efeds_c001_main_pointsources_ctp_redshift_v17
GO
--
EXEC spSetDefaultFileGroup 'efeds_c001_main_pointsources_ctp_redshift_v17'
GO

CREATE TABLE efeds_c001_main_pointsources_ctp_redshift_v17 (
-----------------------------------------
--/H eROSITA/eFEDS MAIN point source counterparts catalogue
--/T Multiwavelength properties of the primary counterpart to the eFEDS sources in the Main Xray catalog
--/T (number one of this table). For each counterparts the classification, photometry and redshift is
--/T provided. Dec 3 2021: updated catalogue is available.
--/T Reference: https://ui.adsabs.harvard.edu/abs/2021arXiv210614520S/abstract
-----------------------------------------
    ero_name varchar(22) NOT NULL, --/D eROSITA official source Name (see Brunner+2021) --/U 
    ero_id_src int NOT NULL, --/D ID of eROSITA source in the Main Sample (from Brunner+2021 catalog) --/U 
    ero_ra_corr float NOT NULL, --/D J2000 Right Ascension of the eROSITA source (corrected) from Brunner+2021 --/U deg
    ero_dec_corr float NOT NULL, --/D J2000 Declination of the eROSITA source (corrected) from Brunner+2021 --/U deg
    ero_radec_err_corr real NOT NULL, --/D eROSITA positional uncertainty (corrected) from Brunner+2021 --/U arcsec
    ero_ml_flux real NOT NULL, --/D 0.2-2.3 keV source flux converted from count rate assuming ECF=1.074e+12 (Gamma=2.0) (from Brunner+2021) --/U erg/cm^2/s
    ero_ml_flux_err real NOT NULL, --/D 0.2-2.3 keV source flux error (1 sigma) (from Brunner+2021) --/U erg/cm^2/s
    ero_det_like real NOT NULL, --/D 0.2-2.3 keV detection likelihood measured by PSF-fitting (from Brunner+2021) --/U 
    ero_inarea90 bit NOT NULL, --/D Whether in the 0.2-2.3keV exp>500s region, which comprises 90% area (from Brunner+2021) --/U 
    ctp_ls8_unique_objid varchar(11) NOT NULL, --/D LS8 unique identifier for the counterpart to the eROSITA source (Expression: toString(LS8_BRICKID)+"_"+toString(LS8_OBJID)) --/U 
    ctp_ls8_ra float NOT NULL, --/D J2000 Right Ascension of the LS8 countepart --/U deg
    ctp_ls8_dec float NOT NULL, --/D J2000 Declination of the best LS8 countepart --/U deg
    dist_ctp_ls8_ero real NOT NULL, --/D Separation between selected counterpart and eROSITA (corrected) position in arcsec --/U arcsec
    ctp_nway_ls8_unique_objid varchar(11) NOT NULL, --/D Unique OBJECTID of the best LS8 countepart from NWAY (Expression: toString(LS8_BRICKID)+"_"+toString(LS8_OBJID)) --/U 
    ctp_nway_ls8_ra float NOT NULL, --/D J2000 Right Ascension of the best LS8 countepart from NWAY --/U deg
    ctp_nway_ls8_dec float NOT NULL, --/D J2000 Declination of the best LS8 countepart from NWAY --/U deg
    ctp_nway_dist_bayesfactor real NOT NULL, --/D Logarithm of ratio between prior and posterior, from separation, positional error and number density (see Appx. in Salvato et al 2018 for clarifications) --/U 
    ctp_nway_dist_post real NOT NULL, --/D Distance posterior probability comparing this association vs. no association (see Appx. in Salvato et al 2018 for clarifications) --/U 
    ctp_nway_p_single real NOT NULL, --/D Same as dist_post, but weighted by the prior (see Appx. in Salvato et al 2018 for clarifications) --/U 
    ctp_nway_p_any real NOT NULL, --/D For each entry in the X-ray catalogue, the probability that there is a counterpart in LS8 (see Appx. in Salvato et al 2018 for clarifications) --/U 
    ctp_nway_p_i real NOT NULL, --/D Relative probability of the eROSITA/LS8 match (see Appx. in Salvato et al 2018 for clarifications) --/U 
    dist_nway_ls8_ero real NOT NULL, --/D Separation between the Xray position and the best LS8 counterparts from NWAY --/U arcsec
    ctp_mlr_ls8_unique_objid varchar(11) NOT NULL, --/D LS8 unique identifier of the LS8 counterpart from Maximum Likelihood Ratio technique --/U 
    ctp_mlr_ls8_ra float NOT NULL, --/D J2000 Right Ascension of LS8 counterpart from Maximum Likelihood Ratio technique --/U deg
    ctp_mlr_ls8_dec float NOT NULL, --/D J2000 Declination of LS8 counterpart from Maximum Likelihood Ratio technique --/U degrees
    ctp_mlr_lr_best real NOT NULL, --/D Likelihood Ratio value from Maximum Likelihood Ratio technique --/U 
    ctp_mlr_rel_best real NOT NULL, --/D Separation between the Xray position and the best LS8 counterparts from Maximum Likelihood Ratio technique --/U 
    dist_mlr_ls8_ero real NOT NULL, --/D Reliability of the identification from Maximum Likelihood Ratio technique --/U arcsec
    ctp_same smallint NOT NULL, --/D Comparison NWAY/MLR: true if the counterpart selected by the two method is the same --/U 
    ctp_mlr smallint NOT NULL, --/D Comparison NWAY/MLR: true if the counterpart from NWAY(MLR) has p_any(LR_BEST) below(above) threshold --/U 
    ctp_hamstar int NOT NULL, --/D Match to Hamstar: 1=same counterpart, 0=different counterpart, -99=no Hamstar (Schneider+2021) --/U 
    ctp_hamstar_p_stellar real NOT NULL, --/D Probability of association from Hamstar. --/U 
    dist_ctp_hamstar real NOT NULL, --/D Separation between the counterpart proposed by Hamstar and the counterpart selected in this work --/U arcsec
    ctp_quality smallint NOT NULL, --/D counterpart quality: 4=best, 3=good, 2=with secondary, 1/0=unreliable. (see flow chart paper) --/U 
    gaiaedr3_id bigint NOT NULL, --/D ID in Gaia EDR3 source catalog --/U 
    gaiaedr3_parallax real NOT NULL, --/D Parallax from Gaia EDR3 --/U mas
    gaiaedr3_parallax_error real NOT NULL, --/D Parallax error from Gaia EDR3 --/U mas
    gaiaedr3_parallax_over_error real NOT NULL, --/D Parallax/Parallax error. ratio $>$5 SECURE GALACTIC --/U 
    gaiaedr3_pmra real NOT NULL, --/D Proper motion in RA from Gaia EDR3 --/U mas/yr
    gaiaedr3_pmra_error real NOT NULL, --/D Error on Proper motion in RA from Gaia EDR3 --/U mas/yr
    gaiaedr3_pmdec real NOT NULL, --/D Proper motion in Dec from Gaia EDR3 --/U mas/yr
    gaiaedr3_pmdec_error real NOT NULL, --/D Error on Proper motion in Dec from Gaia EDR3 --/U mas/yr
    gaiaedr3_phot_g_mean_mag real NOT NULL, --/D g band magnitude (VEGA) from Gaia EDR3 --/U mag
    gaiaedr3_phot_g_mean_mag_error real NOT NULL, --/D Error g band magnitude from Gaia EDR3 --/U mag
    gaiaedr3_phot_bp_mean_mag real NOT NULL, --/D bp band magnitude (VEGA) from Gaia EDR3 --/U mag
    gaiaedr3_phot_bp_mean_mag_error real NOT NULL, --/D Error bp band magnitude from Gaia EDR3 --/U mag
    gaiaedr3_phot_rp_mean_mag real NOT NULL, --/D rp band magnitude (VEGA) from Gaia EDR3 --/U mag
    gaiaedr3_phot_rp_mean_mag_error real NOT NULL, --/D Error bp band magnitude from Gaia EDR3 --/U mag
    fuv real NOT NULL, --/D Galex Far UV magnitude (AB) --/U mag
    fuv_err real NOT NULL, --/D Galex Far UV magnitude error --/U mag
    nuv real NOT NULL, --/D Galex Near UV magnitude (AB) --/U mag
    nuv_err real NOT NULL, --/D Galex Near UV magnitude error --/U mag
    kids_u real NOT NULL, --/D KiDS u-band magnitude (AB) --/U mag
    kids_u_err real NOT NULL, --/D KiDS u-band magnitude error --/U mag
    kids_g real NOT NULL, --/D KiDS g-band magnitude (AB) --/U mag
    kids_g_err real NOT NULL, --/D KiDS g-band magnitude error --/U mag
    kids_r real NOT NULL, --/D KiDS r-band magnitude (AB) --/U mag
    kids_r_err real NOT NULL, --/D KiDS r-band magnitude error --/U mag
    kids_i real NOT NULL, --/D KiDS i-band magnitude (AB) --/U mag
    kids_i_err real NOT NULL, --/D KiDS i-band magnitude error --/U mag
    omegac_z real NOT NULL, --/D OmegaCAM z-band magnitude (AB) --/U mag
    omegac_z_err real NOT NULL, --/D OmegaCAM z-band magnitude error --/U mag
    hsc_g real NOT NULL, --/D HSC g-band cmodel magnitude (AB) --/U mag
    hsc_g_err real NOT NULL, --/D HSC g-band cmodel magnitude error --/U mag
    hsc_r real NOT NULL, --/D HSC r-band cmodel magnitude (AB) when images are mostly from r-filter (see Salvato+2021) --/U mag
    hsc_r_err real NOT NULL, --/D HSC r-band cmodel magnitude error --/U mag
    hsc_r2 real NOT NULL, --/D HSC r2-band cmodel magnitude (AB) when images are mostly from r2-filter (see Salvato+2021) --/U mag
    hsc_r2_err real NOT NULL, --/D HSC r2-band cmodel magnitude error --/U mag
    hsc_i real NOT NULL, --/D HSC i-band cmodel magnitude (AB) when images are mostly from i-filter (see Salvato+2021) --/U mag
    hsc_i_err real NOT NULL, --/D HSC i-band cmodel magnitude error --/U mag
    hsc_i2 real NOT NULL, --/D HSC i2-band cmodel magnitude (AB) when images are mostly from i2-filter (see Salvato+2021) --/U mag
    hsc_i2_err real NOT NULL, --/D HSC i2-band cmodel magnitude error --/U mag
    hsc_z real NOT NULL, --/D HSC z-band cmodel magnitude (AB) --/U mag
    hsc_z_err real NOT NULL, --/D HSC z-band cmodel magnitude error --/U mag
    hsc_y real NOT NULL, --/D HSC Y-band cmodel magnitude (AB) --/U mag
    hsc_y_err real NOT NULL, --/D HSC Y-band cmodel magnitude error --/U mag
    vista_z real NOT NULL, --/D VISTA/VIKING z-band magnitude (AB) --/U mag
    vista_z_err real NOT NULL, --/D VISTA/VIKING z-band magnitude error --/U mag
    vista_y real NOT NULL, --/D VISTA/VIKING Y-band magnitude (AB) --/U mag
    vista_y_err real NOT NULL, --/D VISTA/VIKING Y-band magnitude error --/U mag
    vista_j real NOT NULL, --/D VISTA/VIKING J-band magnitude (AB) --/U mag
    vista_j_err real NOT NULL, --/D VISTA/VIKING J-band magnitude error --/U mag
    vista_h real NOT NULL, --/D VISTA/VIKING H-band magnitude (AB) --/U mag
    vista_h_err real NOT NULL, --/D VISTA/VIKING H-band magnitude error --/U mag
    vista_ks real NOT NULL, --/D VISTA/VIKING Ks-band magnitude (AB) --/U mag
    vista_ks_err real NOT NULL, --/D VISTA/VIKING Ks-band magnitude error --/U mag
    w1 real NOT NULL, --/D LS8/Wise W1 magnitude (AB) --/U mag
    w1_err real NOT NULL, --/D LS8/Wise W1 magnitude error --/U mag
    w2 real NOT NULL, --/D LS8/Wise W2 magnitude (AB) --/U mag
    w2_err real NOT NULL, --/D LS8/Wise W2 magnitude error --/U mag
    w3 real NOT NULL, --/D LS8/Wise W3 magnitude (AB) --/U mag
    w3_err real NOT NULL, --/D LS8/Wise W3 magnitude error --/U mag
    w4 real NOT NULL, --/D LS8/Wise W4 magnitude (AB) --/U mag
    w4_err real NOT NULL, --/D LS8/Wise W4 magnitude error --/U mag
    ls8_g real NOT NULL, --/D LS8 g-band magnitude (AB) --/U mag
    ls8_g_err real NOT NULL, --/D LS8 g-band magnitude error --/U mag
    ls8_r real NOT NULL, --/D LS8 r-band magnitude (AB) --/U mag
    ls8_r_err real NOT NULL, --/D LS8 r-band magnitude error --/U mag
    ls8_z real NOT NULL, --/D LS8 z-band magnitude (AB) --/U mag
    ls8_z_err real NOT NULL, --/D LS8 z-band magnitude error --/U mag
    vhs_y real NOT NULL, --/D VISTA/VHS Y-band magnitude (AB) --/U mag
    vhs_y_err real NOT NULL, --/D VISTA/VHS Y-band magnitude error --/U mag
    vhs_h real NOT NULL, --/D VISTA/VHS H-band magnitude (AB) --/U mag
    vhs_h_err real NOT NULL, --/D VISTA/VHS H-band magnitude error --/U mag
    vhs_ks real NOT NULL, --/D VISTA/VHS Ks-band magnitude (AB) --/U mag
    vhs_ks_err real NOT NULL, --/D VISTA/VHS Ks-band magnitude error --/U mag
    hsc_g_diff real NOT NULL, --/D Difference between psf and Kron magnitude in HSC g-band (AB) --/U mag
    hsc_r_diff real NOT NULL, --/D Difference between psf and Kron magnitude in HSC r-band (AB) --/U mag
    hsc_i_diff real NOT NULL, --/D Difference between psf and Kron magnitude in HSC i-band (AB) --/U mag
    hsc_z_diff real NOT NULL, --/D Difference between psf and Kron magnitude in HSC z-band (AB) --/U mag
    hsc_opt_extended int NOT NULL, --/D Extension in HSC griz bands. 1=extended; -99=data missing 0=other from Aihara et al 2018 --/U 
    ctp_ls8_phot_flag bit NOT NULL, --/D Flag for LS8 photometry: true when the source has simultaneously g,r,z,w1 photometry in LS8 --/U 
    ctp_ls8_type varchar(4) NOT NULL, --/D Morphological model from LS8 --/U 
    in_kids_flag smallint NOT NULL, --/D Flag for KiDS coverage: 1: Source is in KiDS area; 0: otherwise --/U 
    in_hsc_flag smallint NOT NULL, --/D Flag for HSC coverage: 1: Source is in HSC area as from Aihara et al 2018; 0: otherwise --/U 
    specz_ra float NOT NULL, --/D J2000 Right Ascension of the spectroscopic redshift entry in the original catalogue from which it was taken --/U deg
    specz_dec float NOT NULL, --/D J2000 Declination of the spectroscopic redshift entry in the original catalogue from which it was taken --/U deg
    specz_redshift real NOT NULL, --/D Spectroscopic redshift from original catalog --/U 
    specz_normq int NOT NULL, --/D Normalised quality of spectroscopic redshift: 3=secure, 2=not secure, 1=unreliable, -1= Blazar candidate --/U 
    specz_origin varchar(8) NOT NULL, --/D Catalogue which provided this spectroscopic redshift --/U 
    specz_orig_id varchar(24) NOT NULL, --/D Identifier of this entry in the original catalogue from which it was taken --/U 
    specz_galaxy_flag bit NOT NULL, --/D True when the CTP has a reliable redshift above 0.002 --/U 
    specz_star_flag bit NOT NULL, --/D True when the CTP has a reliable redshift below 0.002 --/U 
    ctp_classification varchar(20) NOT NULL, --/D SECURE/LIKELY GALACTIC/EXTRAGALACTIC, as from flowchart (see Salvato+2021) --/U 
    phz_lephare_zphot real NOT NULL, --/D Photoz from Le PHARE, but set to 0 for GALACTIC sources --/U 
    phz_lephare_zl68 real NOT NULL, --/D Le PHARE zphot max at 1 sigma --/U 
    phz_lephare_zu68 real NOT NULL, --/D Le PHARE zphot min at 2 sigma --/U 
    phz_lephare_zl90 real NOT NULL, --/D Le PHARE zphot max at 2 sigma --/U 
    phz_lephare_zu90 real NOT NULL, --/D Le PHARE zphot min at 3 sigma --/U 
    phz_lephare_zl99 real NOT NULL, --/D Le PHARE zphot max at 3 sigma --/U 
    phz_lephare_zu99 real NOT NULL, --/D Expression: null_zu99_2?zu99_1:zu99_2 --/U 
    phz_lephare_chi2 real NOT NULL, --/D Le PHARE chi2 value for best fitting galaxy/AGN template --/U 
    phz_lephare_modelagn smallint NOT NULL, --/D Le PHARE model number for best template fitting the data (for PLIKE 1000+model number) --/U 
    phz_lephare_extlaw smallint NOT NULL, --/D Le PHARE Extinction Law applied to the template: Prevot (1) or none (0) --/U 
    phz_lephare_ebv real NOT NULL, --/D Le PHARE E(B-V) applied to the template --/U 
    phz_lephare_pdz real NOT NULL, --/D Le Phare probability distribution. Photoz more reliable when value is high --/U 
    phz_lephare_nband smallint NOT NULL, --/D Le Phare number of bands used for the computation of photoz --/U 
    phz_lephare_zphot_2 real NOT NULL, --/D Le Phare second best photoz from LePhare, if existing --/U 
    phz_lephare_chi2_2 real NOT NULL, --/D Le Phare chi2 value for second best fitting template, if existing --/U 
    phz_lephare_modelagn_2 smallint NOT NULL, --/D Le Phare second best template fitting the data, if existing --/U 
    phz_lephare_pdz_2 real NOT NULL, --/D Le Phare probability distribution for secondary solution, if existing --/U 
    phz_dnnz_zphot real NOT NULL, --/D Photoz from DNNZ (from Nishizawa et al.,), but set to 0 for GALACTIC sources --/U 
    phz_dnnz_zl68 real NOT NULL, --/D DNNz zphot min at 1 sigma --/U 
    phz_dnnz_zu68 real NOT NULL, --/D DNNz zphot max at 1 sigma --/U 
    phz_dnnz_zl95 real NOT NULL, --/D DNNz zphot min at 2 sigma --/U 
    phz_dnnz_zu95 real NOT NULL, --/D DNNz zphot max at 2 sigma --/U 
    ctp_redshift real NOT NULL, --/D Final redshift: zspec when available, else photo-z from Le PHARE; 0 for GALACTIC sources --/U 
    ctp_redshift_grade smallint NOT NULL, --/D In a range from 5 (spectroscopy) to 0 (unreliable photo-z) --/U 
    ctp_class smallint NOT NULL, --/D same as CTP_classification, but with numbers: 3: SECURE EXTRAGALACTIC; 2: LIKELY EXTRAGALACTIC; 1: SECURE GALACTIC; 0: LIKELY GALACTIC --/U 
    cluster_class smallint NOT NULL --/D Range from 5 (most likely a cluster) to 1 (not a cluster) (see Salvato+2021) --/U 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_c001_main_v7_4')
	DROP TABLE efeds_c001_main_v7_4
GO
--
EXEC spSetDefaultFileGroup 'efeds_c001_main_v7_4'
GO

CREATE TABLE efeds_c001_main_v7_4 (
-----------------------------------------
--/H eROSITA/eFEDS main catalogue
--/T X-ray sources detected in the 0.2-2.3 keV band using eSASS adopting a detection likelihood threshold
--/T of 5. The sources with detection likelihood larger than 6 are selected as the main eFEDS catalog
--/T (27910 sources).
--/T Reference: https://ui.adsabs.harvard.edu/abs/2021arXiv210614517B/abstract
-----------------------------------------
    name varchar(22) NOT NULL, --/D Source name --/U 
    id_src int NOT NULL, --/D Source ID --/U 
    id_hard int NOT NULL, --/D ID_hard --/U 
    ra float NOT NULL, --/D Uncorrected RA (ICRS) --/U deg
    dec float NOT NULL, --/D Uncorrected Dec (ICRS) --/U deg
    radec_err real NOT NULL, --/D Combined positional uncertainty, uncorrected --/U arcsec
    ra_corr float NOT NULL, --/D Corrected RA (ICRS) --/U deg
    dec_corr float NOT NULL, --/D Corrected Dec (ICRS) --/U deg
    radec_err_corr float NOT NULL, --/D Combined positional uncertainty, corrected --/U arcsec
    ext real NOT NULL, --/D Source extent --/U arcsec
    ext_err real NOT NULL, --/D Extent error --/U arcsec
    ext_like real NOT NULL, --/D Extent likelihood --/U 
    det_like real NOT NULL, --/D DET_LIKE --/U 
    ml_rate real NOT NULL, --/D ML_RATE --/U counts/s
    ml_rate_err real NOT NULL, --/D ML_RATE_ERR --/U counts/s
    ml_cts real NOT NULL, --/D ML_CTS --/U counts
    ml_cts_err real NOT NULL, --/D ML_CTS_ERR --/U counts
    ml_flux real NOT NULL, --/D ML_FLUX --/U erg/cm^2/s
    ml_flux_err real NOT NULL, --/D ML_FLUX_ERR --/U erg/cm^2/s
    ml_exp real NOT NULL, --/D ML_EXP --/U seconds
    ml_bkg real NOT NULL, --/D ML_BKG --/U counts/arcmin^2
    inarea90 bit NOT NULL, --/D True if in the 0.2-2.3keV exp>500s region, which comprises 90% area --/U 
    det_like_b1 float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 0.2-0.5 keV --/U 
    det_like_b2 float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 0.5-1 keV --/U 
    det_like_b3 float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 1-2 keV --/U 
    det_like_b4 float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 2-4.5 keV --/U 
    det_like_s float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 0.5-2 keV --/U 
    det_like_h float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 2.3-5 keV --/U 
    det_like_u float NOT NULL, --/D Detection likelihood measured by forced PSF-fitting; 5-8 keV --/U 
    ml_rate_b1 float NOT NULL, --/D Source count rate measured by forced PSF-fitting;.2-.5keV --/U counts/s
    ml_rate_b2 float NOT NULL, --/D Source count rate measured by forced PSF-fitting;0.5-1keV --/U counts/s
    ml_rate_b3 float NOT NULL, --/D Source count rate measured by forced PSF-fitting; 1-2 keV --/U counts/s
    ml_rate_b4 float NOT NULL, --/D Source count rate measured by forced PSF-fitting;2-4.5keV --/U counts/s
    ml_rate_s float NOT NULL, --/D Source count rate measured by forced PSF-fitting;0.5-2keV --/U counts/s
    ml_rate_h float NOT NULL, --/D Source count rate measured by forced PSF-fitting;2.3-5keV --/U counts/s
    ml_rate_u float NOT NULL, --/D Source count rate measured by forced PSF-fitting; 5-8 keV --/U counts/s
    ml_rate_err_b1 float NOT NULL, --/D 1 sigma count rate error; 0.2-0.5 keV --/U counts/s
    ml_rate_err_b2 float NOT NULL, --/D 1 sigma count rate error; 0.5-1 keV --/U counts/s
    ml_rate_err_b3 float NOT NULL, --/D 1 sigma count rate error; 1-2 keV --/U counts/s
    ml_rate_err_b4 float NOT NULL, --/D 1 sigma count rate error; 2-4.5 keV --/U counts/s
    ml_rate_err_s float NOT NULL, --/D 1 sigma count rate error; 0.5-2 keV --/U counts/s
    ml_rate_err_h float NOT NULL, --/D 1 sigma count rate error; 2.3-5 keV --/U counts/s
    ml_rate_err_u float NOT NULL, --/D 1 sigma count rate error; 5-8 keV --/U counts/s
    ml_rate_lowerr_b1 float NOT NULL, --/D 1 sigma lower error of count rate;0.2-0.5 keV --/U counts/s
    ml_rate_lowerr_b2 float NOT NULL, --/D 1 sigma lower error of count rate;0.5-1 keV --/U counts/s
    ml_rate_lowerr_b3 float NOT NULL, --/D 1 sigma lower error of count rate;1-2 keV --/U counts/s
    ml_rate_lowerr_b4 float NOT NULL, --/D 1 sigma lower error of count rate;2-4.5 keV --/U counts/s
    ml_rate_lowerr_s float NOT NULL, --/D 1 sigma lower error of count rate;0.5-2 keV --/U counts/s
    ml_rate_lowerr_h float NOT NULL, --/D 1 sigma lower error of count rate;2.3-5 keV --/U counts/s
    ml_rate_lowerr_u float NOT NULL, --/D 1 sigma lower error of count rate;5-8 keV --/U counts/s
    ml_rate_uperr_b1 float NOT NULL, --/D 1 sigma upper error of count rate;0.2-0.5 keV --/U counts/s
    ml_rate_uperr_b2 float NOT NULL, --/D 1 sigma upper error of count rate;0.5-1 keV --/U counts/s
    ml_rate_uperr_b3 float NOT NULL, --/D 1 sigma upper error of count rate;1-2 keV --/U counts/s
    ml_rate_uperr_b4 float NOT NULL, --/D 1 sigma upper error of count rate;2-4.5 keV --/U counts/s
    ml_rate_uperr_s float NOT NULL, --/D 1 sigma upper error of count rate;0.5-2 keV --/U counts/s
    ml_rate_uperr_h float NOT NULL, --/D 1 sigma upper error of count rate;2.3-5 keV --/U counts/s
    ml_rate_uperr_u float NOT NULL, --/D 1 sigma upper error of count rate;5-8 keV --/U counts/s
    ml_cts_b1 float NOT NULL, --/D Source net counts measured from count rate; 0.2-0.5 keV --/U counts
    ml_cts_b2 float NOT NULL, --/D Source net counts measured from count rate; 0.5-1 keV --/U counts
    ml_cts_b3 float NOT NULL, --/D Source net counts measured from count rate; 1-2 keV --/U counts
    ml_cts_b4 float NOT NULL, --/D Source net counts measured from count rate; 2-4.5 keV --/U counts
    ml_cts_s float NOT NULL, --/D Source net counts measured from count rate; 0.5-2 keV --/U counts
    ml_cts_h float NOT NULL, --/D Source net counts measured from count rate; 2.3-5 keV --/U counts
    ml_cts_u float NOT NULL, --/D Source net counts measured from count rate; 5-8 keV --/U counts
    ml_cts_err_b1 float NOT NULL, --/D 1 sigma counts error; 0.2-0.5 keV --/U counts
    ml_cts_err_b2 float NOT NULL, --/D 1 sigma counts error; 0.5-1 keV --/U counts
    ml_cts_err_b3 float NOT NULL, --/D 1 sigma counts error; 1-2 keV --/U counts
    ml_cts_err_b4 float NOT NULL, --/D 1 sigma counts error; 2-4.5 keV --/U counts
    ml_cts_err_s float NOT NULL, --/D 1 sigma counts error; 0.5-2 keV --/U counts
    ml_cts_err_h float NOT NULL, --/D 1 sigma counts error; 2.3-5 keV --/U counts
    ml_cts_err_u float NOT NULL, --/D 1 sigma counts error; 5-8 keV --/U counts
    ml_cts_lowerr_b1 float NOT NULL, --/D 1 sigma lower error of counts;0.2-0.5 keV --/U counts
    ml_cts_lowerr_b2 float NOT NULL, --/D 1 sigma lower error of counts;0.5-1 keV --/U counts
    ml_cts_lowerr_b3 float NOT NULL, --/D 1 sigma lower error of counts;1-2 keV --/U counts
    ml_cts_lowerr_b4 float NOT NULL, --/D 1 sigma lower error of counts;2-4.5 keV --/U counts
    ml_cts_lowerr_s float NOT NULL, --/D 1 sigma lower error of counts;0.5-2 keV --/U counts
    ml_cts_lowerr_h float NOT NULL, --/D 1 sigma lower error of counts;2.3-5 keV --/U counts
    ml_cts_lowerr_u float NOT NULL, --/D 1 sigma lower error of counts;5-8 keV --/U counts
    ml_cts_uperr_b1 float NOT NULL, --/D 1 sigma upper error of counts;0.2-0.5 keV --/U counts
    ml_cts_uperr_b2 float NOT NULL, --/D 1 sigma upper error of counts;0.5-1 keV --/U counts
    ml_cts_uperr_b3 float NOT NULL, --/D 1 sigma upper error of counts;1-2 keV --/U counts
    ml_cts_uperr_b4 float NOT NULL, --/D 1 sigma upper error of counts;2-4.5 keV --/U counts
    ml_cts_uperr_s float NOT NULL, --/D 1 sigma upper error of counts;0.5-2 keV --/U counts
    ml_cts_uperr_h float NOT NULL, --/D 1 sigma upper error of counts;2.3-5 keV --/U counts
    ml_cts_uperr_u float NOT NULL, --/D 1 sigma upper error of counts;5-8 keV --/U counts
    ml_flux_b1 float NOT NULL, --/D Source flux converted from count rate; 0.2-0.5 keV --/U erg/cm^2/s
    ml_flux_b2 float NOT NULL, --/D Source flux converted from count rate; 0.5-1 keV --/U erg/cm^2/s
    ml_flux_b3 float NOT NULL, --/D Source flux converted from count rate; 1-2 keV --/U erg/cm^2/s
    ml_flux_b4 float NOT NULL, --/D Source flux converted from count rate; 2-4.5 keV --/U erg/cm^2/s
    ml_flux_s float NOT NULL, --/D Source flux converted from count rate; 0.5-2 keV --/U erg/cm^2/s
    ml_flux_h float NOT NULL, --/D Source flux converted from count rate; 2.3-5 keV --/U erg/cm^2/s
    ml_flux_u float NOT NULL, --/D Source flux converted from count rate; 5-8 keV --/U erg/cm^2/s
    ml_flux_err_b1 float NOT NULL, --/D 1 sigma flux error; 0.2-0.5 keV --/U erg/cm^2/s
    ml_flux_err_b2 float NOT NULL, --/D 1 sigma flux error; 0.5-1 keV --/U erg/cm^2/s
    ml_flux_err_b3 float NOT NULL, --/D 1 sigma flux error; 1-2 keV --/U erg/cm^2/s
    ml_flux_err_b4 float NOT NULL, --/D 1 sigma flux error; 2-4.5 keV --/U erg/cm^2/s
    ml_flux_err_s float NOT NULL, --/D 1 sigma flux error; 0.5-2 keV --/U erg/cm^2/s
    ml_flux_err_h float NOT NULL, --/D 1 sigma flux error; 2.3-5 keV --/U erg/cm^2/s
    ml_flux_err_u float NOT NULL, --/D 1 sigma flux error; 5-8 keV --/U erg/cm^2/s
    ml_flux_lowerr_b1 float NOT NULL, --/D 1 sigma lower error of flux;0.2-0.5 keV --/U erg/cm^2/s
    ml_flux_lowerr_b2 float NOT NULL, --/D 1 sigma lower error of flux;0.5-1 keV --/U erg/cm^2/s
    ml_flux_lowerr_b3 float NOT NULL, --/D 1 sigma lower error of flux;1-2 keV --/U erg/cm^2/s
    ml_flux_lowerr_b4 float NOT NULL, --/D 1 sigma lower error of flux;2-4.5 keV --/U erg/cm^2/s
    ml_flux_lowerr_s float NOT NULL, --/D 1 sigma lower error of flux;0.5-2 keV --/U erg/cm^2/s
    ml_flux_lowerr_h float NOT NULL, --/D 1 sigma lower error of flux;2.3-5 keV --/U erg/cm^2/s
    ml_flux_lowerr_u float NOT NULL, --/D 1 sigma lower error of flux;5-8 keV --/U erg/cm^2/s
    ml_flux_uperr_b1 float NOT NULL, --/D 1 sigma upper error of flux;0.2-0.5 keV --/U erg/cm^2/s
    ml_flux_uperr_b2 float NOT NULL, --/D 1 sigma upper error of flux;0.5-1 keV --/U erg/cm^2/s
    ml_flux_uperr_b3 float NOT NULL, --/D 1 sigma upper error of flux;1-2 keV --/U erg/cm^2/s
    ml_flux_uperr_b4 float NOT NULL, --/D 1 sigma upper error of flux;2-4.5 keV --/U erg/cm^2/s
    ml_flux_uperr_s float NOT NULL, --/D 1 sigma upper error of flux;0.5-2 keV --/U erg/cm^2/s
    ml_flux_uperr_h float NOT NULL, --/D 1 sigma upper error of flux;2.3-5 keV --/U erg/cm^2/s
    ml_flux_uperr_u float NOT NULL, --/D 1 sigma upper error of flux;5-8 keV --/U erg/cm^2/s
    ml_exp_b1 float NOT NULL, --/D Vignetted exposure value; 0.2-0.5 keV --/U seconds
    ml_exp_b2 float NOT NULL, --/D Vignetted exposure value; 0.5-1 keV --/U seconds
    ml_exp_b3 float NOT NULL, --/D Vignetted exposure value; 1-2 keV --/U seconds
    ml_exp_b4 float NOT NULL, --/D Vignetted exposure value; 2-4.5 keV --/U seconds
    ml_exp_s float NOT NULL, --/D Vignetted exposure value; 0.5-2 keV --/U seconds
    ml_exp_h float NOT NULL, --/D Vignetted exposure value; 2.3-5 keV --/U seconds
    ml_exp_u float NOT NULL, --/D Vignetted exposure value; 5-8 keV --/U seconds
    ml_bkg_b1 float NOT NULL, --/D Background at the source position; 0.2-0.5keV --/U counts/arcmin^2
    ml_bkg_b2 float NOT NULL, --/D Background at the source position; 0.5-1 keV --/U counts/arcmin^2
    ml_bkg_b3 float NOT NULL, --/D Background at the source position; 1-2 keV --/U counts/arcmin^2
    ml_bkg_b4 float NOT NULL, --/D Background at the source position; 2-4.5 keV --/U counts/arcmin^2
    ml_bkg_s float NOT NULL, --/D Background at the source position; 0.5-2 keV --/U counts/arcmin^2
    ml_bkg_h float NOT NULL, --/D Background at the source position; 2.3-5 keV --/U counts/arcmin^2
    ml_bkg_u float NOT NULL, --/D Background at the source position; 5-8 keV --/U counts/arcmin^2
    ape_cts_b1 int NOT NULL, --/D Total counts extracted in the aperture; 0.2-0.5 keV --/U counts
    ape_cts_b2 int NOT NULL, --/D Total counts extracted in the aperture; 0.5-1 keV --/U counts
    ape_cts_b3 int NOT NULL, --/D Total counts extracted in the aperture; 1-2 keV --/U counts
    ape_cts_b4 int NOT NULL, --/D Total counts extracted in the aperture; 2-4.5 keV --/U counts
    ape_cts_s int NOT NULL, --/D Total counts extracted in the aperture; 0.5-2 keV --/U counts
    ape_cts_h int NOT NULL, --/D Total counts extracted in the aperture; 2.3-5 keV --/U counts
    ape_cts_u int NOT NULL, --/D Total counts extracted in the aperture; 5-8 keV --/U counts
    ape_exp_b1 float NOT NULL, --/D Vignetted exposure value; 0.2-0.5 keV --/U seconds
    ape_exp_b2 float NOT NULL, --/D Vignetted exposure value; 0.5-1 keV --/U seconds
    ape_exp_b3 float NOT NULL, --/D Vignetted exposure value; 1-2 keV --/U seconds
    ape_exp_b4 float NOT NULL, --/D Vignetted exposure value; 2-4.5 keV --/U seconds
    ape_exp_s float NOT NULL, --/D Vignetted exposure value; 0.5-2 keV --/U seconds
    ape_exp_h float NOT NULL, --/D Vignetted exposure value; 2.3-5 keV --/U seconds
    ape_exp_u float NOT NULL, --/D Vignetted exposure value; 5-8 keV --/U seconds
    ape_bkg_b1 float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;.2-.5keV --/U counts
    ape_bkg_b2 float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;0.5-1keV --/U counts
    ape_bkg_b3 float NOT NULL, --/D Background counts in the aperture, excluding nearby sources; 1-2 keV --/U counts
    ape_bkg_b4 float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;2-4.5keV --/U counts
    ape_bkg_s float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;0.5-2keV --/U counts
    ape_bkg_h float NOT NULL, --/D Background counts in the aperture, excluding nearby sources;2.3-5keV --/U counts
    ape_bkg_u float NOT NULL, --/D Background counts in the aperture, excluding nearby sources; 5-8 keV --/U counts
    ape_radius_b1 float NOT NULL, --/D Aperture radius; 0.2-0.5 keV --/U pixels
    ape_radius_b2 float NOT NULL, --/D Aperture radius; 0.5-1 keV --/U pixels
    ape_radius_b3 float NOT NULL, --/D Aperture radius; 1-2 keV --/U pixels
    ape_radius_b4 float NOT NULL, --/D Aperture radius; 2-4.5 keV --/U pixels
    ape_radius_s float NOT NULL, --/D Aperture radius; 0.5-2 keV --/U pixels
    ape_radius_h float NOT NULL, --/D Aperture radius; 2.3-5 keV --/U pixels
    ape_radius_u float NOT NULL, --/D Aperture radius; 5-8 keV --/U pixels
    ape_pois_b1 float NOT NULL, --/D Poisson probability of being background fluctuation; 0.2-0.5 keV --/U 
    ape_pois_b2 float NOT NULL, --/D Poisson probability of being background fluctuation; 0.5-1 keV --/U 
    ape_pois_b3 float NOT NULL, --/D Poisson probability of being background fluctuation; 1-2 keV --/U 
    ape_pois_b4 float NOT NULL, --/D Poisson probability of being background fluctuation; 2-4.5 keV --/U 
    ape_pois_s float NOT NULL, --/D Poisson probability of being background fluctuation; 0.5-2 keV --/U 
    ape_pois_h float NOT NULL, --/D Poisson probability of being background fluctuation; 2.3-5 keV --/U 
    ape_pois_u float NOT NULL --/D Poisson probability of being background fluctuation; 5-8 keV --/U 
)
GO


/*
--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_spiders_agn_class_props')
	DROP TABLE efeds_spiders_agn_class_props
GO
--
EXEC spSetDefaultFileGroup 'efeds_spiders_agn_class_props'
GO

CREATE TABLE efeds_spiders_agn_class_props (
---------------------------------------------------------------- 
--/H eFEDS SPIDERS AGN classification, emission line detection flags, and derived physical properties.
--/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
--/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
--/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
--/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
--/T Also provided are the X-ray and public photometric data.
---------------------------------------------------------------- 
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
)
GO
*/


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_spiders_agn_ctp_salvato')
	DROP TABLE efeds_spiders_agn_ctp_salvato
GO
--
EXEC spSetDefaultFileGroup 'efeds_spiders_agn_ctp_salvato'
GO

CREATE TABLE efeds_spiders_agn_ctp_salvato (
---------------------------------------------------------------- 
--/H eFEDS SPIDERS AGN photometric counterpart catalogue and multi-wavelength photometry from Salvato et al. (2022)
-----------------------------------------------------------------
--/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
--/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
--/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
--/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
--/T Also provided are the X-ray and public photometric data.
---------------------------------------------------------------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source Name (Brunner+2022) 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of Main sample eROSITA source (Brunner+2022) 
    ero_id_hard int NOT NULL, --/U  --/D ID of eROSITA source in the Hard Sample 
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from the original catalogue 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension sky coordinate of spectroscopic fibre 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination sky coordinate of spectroscopic fibre 
    mjd int NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    ctp_ls8_unique_objid varchar(11) NOT NULL, --/U  --/D LS8 unique identifier for the counterpart to the eROSITA source (Exp 
    ctp_ls8_ra float NOT NULL, --/U deg --/D J2000 Right Ascension of the LS8 counterpart 
    ctp_ls8_dec float NOT NULL, --/U deg --/D J2000 Declination of the LS8 counterpart 
    specz_n_specz int NOT NULL, --/U  --/D Total number of spec_z associated with this Legacy Survey DR9 object 
    specz_normq_specz int NOT NULL, --/U  --/D Normalised quality of spectroscopic redshift: 3=secure, 2=not secure 
    specz_normc_specz varchar(8) NOT NULL, --/U  --/D Final normalised classification determined for this object 
    specz_hasvi_specz bit NOT NULL, --/U  --/D True if best spec-z for this object has a visual inspection 
    specz_catcode_specz varchar(12) NOT NULL, --/U  --/D Catalogue code of best spec-z for this object 
    specz_bitmask_specz bigint NOT NULL, --/U  --/D Bitmask encoding catalogues containing spec-z for this object. Bit e 
    plate int NOT NULL, --/U  --/D SDSS plate 
    fiberid int NOT NULL, --/U  --/D SDSS FIBER ID 
    field int NOT NULL, --/U  --/D SDSS field sequence number 
    catalogid bigint NOT NULL, --/U  --/D SDSS CATALOGID (used before the unification with SDSS_ID) 
    run2d varchar(7) NOT NULL, --/U  --/D Tagged version of idlspec2d used to reduce the SDSS BOSS spectra 
    dr varchar(4) NOT NULL, --/U  --/D SDSS Data Release version 
    url varchar(131) NOT NULL, --/U  --/D SDSS url to (internal) access observed spectrum 
    sep_ls8_sdss float NOT NULL, --/U arcsec --/D Distance between matched objects along a great circle 
    sn_median_all float NOT NULL, --/U  --/D SDSS Median S/N per pix in spectrum (idlspec2d v6_0_2 reductions) 
    z float NOT NULL, --/U  --/D SDSS Pipeline redshift in idlspec2d eFEDS v6_0_2 reductions 
    z_err float NOT NULL, --/U  --/D SDSS Pipeline redshift uncertainty in idlspec2d eFEDS v6_0_2 reducti 
    zwarning float NOT NULL, --/U  --/D SDSS Pipeline redshift warning flags in idlspec2d eFEDS v6_0_2 reduc 
    ero_ra_corr float NOT NULL, --/U deg --/D J2000 Right Ascension of the eROSITA source (corrected) 
    ero_dec_corr float NOT NULL, --/U deg --/D J2000 Declination of the eROSITA source (corrected) 
    ero_radec_error_corr float NOT NULL, --/U deg --/D eROSITA positional uncertainty (corrected) 
    ero_ml_flux real NOT NULL, --/U erg / (cm2 s) --/D 0.2-2.3 keV source flux converted from count rate assuming ECF=1.074 
    ero_ml_flux_err real NOT NULL, --/U erg / (cm2 s) --/D 2.3-5 keV source flux error (1 sigma) 
    ero_det_like real NOT NULL, --/U  --/D X-ray detection likelihood measured by PSF-fitting 
    ero_inarea90 bit NOT NULL, --/U  --/D True if in the 0.2-2.3keV exp>500s region, which comprises 90% 
    dist_ctp_ls8_ero float NOT NULL, --/U arcsec --/D Separation between selected counterpart and eROSITA (corrected) posi 
    ctp_nway_ls8_unique_objid varchar(11) NOT NULL, --/U  --/D Unique OBJECTID of the best LS8 counterpart from NWAY (Expression: t 
    ctp_nway_ls8_ra float NOT NULL, --/U deg --/D J2000 Right Ascension of the best LS8 counterpart from NWAY 
    ctp_nway_ls8_dec float NOT NULL, --/U deg --/D J2000 Declination of the best LS8 counterpart from NWAY 
    ctp_nway_dist_bayesfactor real NOT NULL, --/U  --/D Logarithm of ratio between prior and posterior, from separation, pos 
    ctp_nway_dist_post real NOT NULL, --/U  --/D Distance probability comparing this association vs. no association ( 
    ctp_nway_p_single real NOT NULL, --/U  --/D Same as dist_post, but weighted by the prior (see Appx. in Salvato e 
    ctp_nway_p_any real NOT NULL, --/U  --/D For each entry in the X-ray catalogue, the probability that there is 
    ctp_nway_p_i real NOT NULL, --/U  --/D Relative probability of the eROSITA/LS8 match (see Appx. in Salvato 
    dist_nway_ls8_ero real NOT NULL, --/U arcsec --/D Separation between the X-ray position and the best LS8 counterparts 
    ctp_mlr_ls8_unique_objid varchar(11) NOT NULL, --/U  --/D LS8 unique identifier of the LS8 counterpart from Maximum Likelihood 
    ctp_mlr_ls8_ra float NOT NULL, --/U deg --/D J2000 Right Ascension of the LS8 counterpart 
    ctp_mlr_ls8_dec float NOT NULL, --/U deg --/D J2000 Declination of the best LS8 counterpart 
    ctp_mlr_lr_best float NOT NULL, --/U  --/D Likelihood Ratio value from Maximum Likelihood Ratio technique 
    ctp_mlr_rel_best float NOT NULL, --/U  --/D Reliability of the identification from Maximum Likelihood Ratio tech 
    dist_mlr_ls8_ero float NOT NULL, --/U arcsec --/D Separation between the X-ray position and the best LS8 counterparts 
    ctp_same smallint NOT NULL, --/U  --/D Comparison NWAY/MLR: true if the counterpart selected by the two met 
    ctp_mlr smallint NOT NULL, --/U  --/D Comparison NWAY/MLR: true if the counterpart from NWAY/MLR has p_any 
    ctp_hamstar int NOT NULL, --/U  --/D Match to Hamstar: 1=same counterpart, 0=different counterpart, -99=n 
    ctp_hamstar_p_stellar float NOT NULL, --/U arcsec --/D probability of association from Hamstar 
    dist_ctp_hamstar float NOT NULL, --/U arcsec --/D Separation between Hamstar ctp and NWAY/MLR ctp 
    ctp_quality smallint NOT NULL, --/U  --/D colour: 1=best, 4=best, 3=good, 2=with secondary, 1/0=unreliable. (s 
    gaiaedr3_id bigint NOT NULL, --/U  --/D ID in Gaia EDR3 source catalog 
    gaiaedr3_parallax float NOT NULL, --/U mas --/D Parallax from Gaia EDR3 
    gaiaedr3_parallax_error float NOT NULL, --/U mas --/D Parallax error from Gaia EDR3 
    gaiaedr3_parallax_over_error float NOT NULL, --/U  --/D Parallax/Parallax error, ratio >5 SECURE GALACTIC 
    gaiaedr3_pmra float NOT NULL, --/U mas / yr --/D Proper motion in RA from Gaia EDR3 
    gaiaedr3_pmra_error float NOT NULL, --/U mas / yr --/D Proper motion error in RA from Gaia EDR3 
    gaiaedr3_pmdec float NOT NULL, --/U mas / yr --/D Proper motion in Dec from Gaia EDR3 
    gaiaedr3_pmdec_error float NOT NULL, --/U mas / yr --/D Proper motion error in Dec from Gaia EDR3 
    gaiaedr3_phot_g_mean_mag float NOT NULL, --/U mag --/D g band magnitude (VEGA) from Gaia EDR3 
    gaiaedr3_phot_g_mean_mag_error float NOT NULL, --/U mag --/D Error g band magnitude from Gaia EDR3 
    gaiaedr3_phot_bp_mean_mag float NOT NULL, --/U mag --/D bp band magnitude from Gaia EDR3 
    gaiaedr3_phot_bp_mean_mag_error float NOT NULL, --/U mag --/D Error bp band magnitude from Gaia EDR3 
    gaiaedr3_phot_rp_mean_mag float NOT NULL, --/U mag --/D rp band magnitude (VEGA) from Gaia EDR3 
    gaiaedr3_phot_rp_mean_mag_error float NOT NULL, --/U mag --/D Error rp band magnitude from Gaia EDR3 
    fuv float NOT NULL, --/U mag --/D Galex Far UV magnitude (AB) 
    fuv_err float NOT NULL, --/U mag --/D Galex Far UV magnitude error (AB) 
    nuv float NOT NULL, --/U mag --/D Galex Near UV magnitude (AB) 
    nuv_err float NOT NULL, --/U mag --/D Galex Near UV magnitude error (AB) 
    kids_u float NOT NULL, --/U mag --/D KIDS u-band magnitude 
    kids_u_err float NOT NULL, --/U mag --/D KIDS u-band magnitude error 
    kids_g float NOT NULL, --/U mag --/D KIDS g-band magnitude 
    kids_g_err float NOT NULL, --/U mag --/D KIDS g-band magnitude error 
    kids_r float NOT NULL, --/U mag --/D KIDS r-band magnitude 
    kids_r_err float NOT NULL, --/U mag --/D KIDS r-band magnitude error 
    kids_i float NOT NULL, --/U mag --/D KIDS i-band magnitude 
    kids_i_err float NOT NULL, --/U mag --/D KIDS i-band magnitude error 
    omegac_z smallint NOT NULL, --/U mag --/D OmegaCAM z-band magnitude (AB) 
    omegac_z_err real NOT NULL, --/U mag --/D OmegaCAM z-band magnitude error 
    hsc_g float NOT NULL, --/U mag --/D HSC g-band magnitude (AB) 
    hsc_g_err float NOT NULL, --/U mag --/D HSC g-band magnitude error 
    hsc_r float NOT NULL, --/U mag --/D HSC r-band magnitude (AB) when images are mostly from r-filter (see 
    hsc_r_err float NOT NULL, --/U mag --/D HSC r-band magnitude error 
    hsc_r2 float NOT NULL, --/U mag --/D HSC r2-band magnitude (AB) when images are mostly from r2-filter (se 
    hsc_r2_err float NOT NULL, --/U mag --/D HSC r2-band magnitude error 
    hsc_i float NOT NULL, --/U mag --/D HSC i-band magnitude (AB) when images are mostly from i-filter (see 
    hsc_i_err float NOT NULL, --/U mag --/D HSC i-band magnitude error 
    hsc_i2 float NOT NULL, --/U mag --/D HSC i2-band magnitude (AB) when images are mostly from i2-filter (se 
    hsc_i2_err float NOT NULL, --/U mag --/D HSC i2-band magnitude error 
    hsc_z float NOT NULL, --/U mag --/D HSC z-band magnitude (AB) 
    hsc_z_err float NOT NULL, --/U mag --/D HSC z-band magnitude error 
    hsc_y float NOT NULL, --/U mag --/D HSC Y-band magnitude (AB) 
    hsc_y_err float NOT NULL, --/U mag --/D HSC Y-band magnitude error 
    vista_z float NOT NULL, --/U mag --/D VISTA/VIKING z-band magnitude (AB) 
    vista_z_err float NOT NULL, --/U mag --/D VISTA/VIKING z-band magnitude error 
    vista_y float NOT NULL, --/U mag --/D VISTA/VIKING Y-band magnitude (AB) 
    vista_y_err float NOT NULL, --/U mag --/D VISTA/VIKING Y-band magnitude error 
    vista_j float NOT NULL, --/U mag --/D VISTA/VIKING J-band magnitude (AB) 
    vista_j_err float NOT NULL, --/U mag --/D VISTA/VIKING J-band magnitude error 
    vista_h float NOT NULL, --/U mag --/D VISTA/VIKING H-band magnitude (AB) 
    vista_h_err float NOT NULL, --/U mag --/D VISTA/VIKING H-band magnitude error 
    vista_ks float NOT NULL, --/U mag --/D VISTA/VIKING Ks-band magnitude (AB) 
    vista_ks_err float NOT NULL, --/U mag --/D VISTA/VIKING Ks-band magnitude error 
    w1 float NOT NULL, --/U mag --/D LS8/Wise W1 magnitude (AB) 
    w1_err float NOT NULL, --/U mag --/D LS8/Wise W1 magnitude error 
    w2 float NOT NULL, --/U mag --/D LS8/Wise W2 magnitude (AB) 
    w2_err float NOT NULL, --/U mag --/D LS8/Wise W2 magnitude error 
    w3 float NOT NULL, --/U mag --/D LS8/Wise W3 magnitude (AB) 
    w3_err float NOT NULL, --/U mag --/D LS8/Wise W3 magnitude error 
    w4 float NOT NULL, --/U mag --/D LS8/Wise W4 magnitude (AB) 
    w4_err float NOT NULL, --/U mag --/D LS8/Wise W4 magnitude error 
    ls8_g float NOT NULL, --/U mag --/D LS8 g-band magnitude (AB) 
    ls8_g_err float NOT NULL, --/U mag --/D LS8 g-band magnitude error 
    ls8_r float NOT NULL, --/U mag --/D LS8 r-band magnitude (AB) 
    ls8_r_err float NOT NULL, --/U mag --/D LS8 r-band magnitude error 
    ls8_z float NOT NULL, --/U mag --/D LS8 z-band magnitude (AB) 
    ls8_z_err float NOT NULL, --/U mag --/D LS8 z-band magnitude error 
    vhs_y float NOT NULL, --/U mag --/D VISTA/VHS Y-band magnitude (AB) 
    vhs_y_err real NOT NULL, --/U mag --/D VISTA/VHS Y-band magnitude error 
    vhs_h float NOT NULL, --/U mag --/D VISTA/VHS H-band magnitude (AB) 
    vhs_h_err real NOT NULL, --/U mag --/D VISTA/VHS H-band magnitude error 
    vhs_ks float NOT NULL, --/U mag --/D VISTA/VHS Ks-band magnitude (AB) 
    vhs_ks_err real NOT NULL, --/U mag --/D VISTA/VHS Ks-band magnitude error 
    hsc_g_diff float NOT NULL, --/U mag --/D Difference between psf and Kron magnitude in HSC g-band 
    hsc_r_diff float NOT NULL, --/U mag --/D Distance between pfron and Kron magnitude in HSC r-band 
    hsc_i_diff float NOT NULL, --/U mag --/D Distance between pfron and Kron magnitude in HSC i-band 
    hsc_z_diff float NOT NULL, --/U mag --/D Distance between pfron and Kron magnitude in HSC z-band 
    hsc_opt_extended int NOT NULL, --/U  --/D Extension in HSC griz bands. 1=extended; -99=data missing; 0=other f 
    ctp_ls8_phot_flag bit NOT NULL, --/U  --/D Flag for LS8 photometry: true when the source has simultaneously g,r 
    ctp_ls8_type varchar(4) NOT NULL, --/U  --/D Morphological model from LS8 
    in_kids_flag smallint NOT NULL, --/U  --/D Source is in KIDS area 
    in_hsc_flag smallint NOT NULL, --/U  --/D Source is in HSC area 
    specz_ra float NOT NULL, --/U deg --/D J2000 Right Ascension of the spectroscopic redshift entry in the ori 
    specz_dec float NOT NULL, --/U deg --/D J2000 Declination of the spectroscopic redshift entry in the origina 
    specz_normq int NOT NULL, --/U  --/D Normalised quality of spectroscopic redshift: 3=secure, 2=not secure 
    specz_origin varchar(8) NOT NULL, --/U  --/D Catalogue which provided this spectroscopic redshift 
    specz_orig_id varchar(12) NOT NULL, --/U  --/D Original ID of this spec-z in ORIGIN catalogue 
    specz_galaxy_flag bit NOT NULL, --/U  --/D True when the CTP has a reliable redshift above 0.002 
    specz_star_flag bit NOT NULL, --/U  --/D True when the CTP has a reliable redshift below 0.002 
    ctp_classification varchar(20) NOT NULL, --/U  --/D SECURE/LIKELY GALACTIC/EXTRAGALACTIC, as from flowchart (Salvato+202 
    phz_lephare_zphot real NOT NULL, --/U  --/D Photoz from Le PHARE, but set to 0 for GALACTIC sources 
    phz_lephare_zl68 real NOT NULL, --/U  --/D Le PHARE zphot min at 1 sigma 
    phz_lephare_zu68 real NOT NULL, --/U  --/D Le PHARE zphot max at 1 sigma 
    phz_lephare_zl90 real NOT NULL, --/U  --/D Le PHARE zphot min at 2 sigma 
    phz_lephare_zu90 real NOT NULL, --/U  --/D Le PHARE zphot max at 2 sigma 
    phz_lephare_zl99 real NOT NULL, --/U  --/D Le PHARE zphot min at 3 sigma 
    phz_lephare_zu99 real NOT NULL, --/U  --/D Le PHARE zphot max at 3 sigma 
    phz_lephare_chi2 float NOT NULL, --/U  --/D Le PHARE chi2 value for best fitting galaxy/AGN template 
    phz_lephare_modelagn smallint NOT NULL, --/U  --/D Le PHARE model number for best template fitting the data (for PLIKE 
    phz_lephare_extlaw smallint NOT NULL, --/U  --/D Le PHARE Extinction Law applied to the template: Prevot (1) or none 
    phz_lephare_ebv real NOT NULL, --/U  --/D Le PHARE E(B-V) applied to the template 
    phz_lephare_pdz real NOT NULL, --/U  --/D Le Phare probability distribution: Photoz more reliable when value i 
    phz_lephare_nband smallint NOT NULL, --/U  --/D Le Phare number of bands used for the computation of photoz 
    phz_lephare_zphot_2 real NOT NULL, --/U  --/D Le Phare best photoz from LePhare, if existing 
    phz_lephare_chi2_2 float NOT NULL, --/U  --/D Le Phare chi2 value for second best fitting template, if existing 
    phz_lephare_modelagn_2 smallint NOT NULL, --/U  --/D Le Phare second best template fitting the data, if existing 
    phz_lephare_pdz_2 real NOT NULL, --/U  --/D Le Phare distribution of photoz for secondary solution, if existing 
    phz_dnnz_zphot float NOT NULL, --/U  --/D Photoz from DNNZ (from Nishizawa et al.), but set to 0 for GALACTIC 
    phz_dnnz_zl68 float NOT NULL, --/U  --/D DNNZ zphot min at 1 sigma 
    phz_dnnz_zu68 float NOT NULL, --/U  --/D DNNZ zphot max at 1 sigma 
    phz_dnnz_zl95 float NOT NULL, --/U  --/D DNNZ zphot min at 2 sigma 
    phz_dnnz_zu95 float NOT NULL, --/U  --/D DNNZ zphot max at 2 sigma 
    ctp_redshift float NOT NULL, --/U  --/D Final redshift: zspec when available, else photo-z from Le PHARE; 0 
    ctp_redshift_grade smallint NOT NULL, --/U  --/D In a range from 5 (spectroscopy) to 0 (unreliable photo-z) 
    cluster_class smallint NOT NULL, --/U  --/D Range from 5 (most likely a cluster) to 1 (not a cluster) (see Salva 
    ctp_class smallint NOT NULL, --/U  --/D same as CTP_classification, but with numbers: 3: SECURE EXTRAGALACTI 
    nspec int NOT NULL, --/U  --/D Number of spectra for the same eROSITA source 
    sdss_class varchar(20) NOT NULL, --/U  --/D SDSS class (STAR, GALAXY, QSO) in idlspec2d eFEDS v6_0_2 reductions 
    sdss_subclass varchar(20) NOT NULL, --/U  --/D SDSS subclass in idlspec2d eFEDS v6_0_2 reductions 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_spiders_agn_fit_params')
	DROP TABLE efeds_spiders_agn_fit_params
GO
--
EXEC spSetDefaultFileGroup 'efeds_spiders_agn_fit_params'
GO

CREATE TABLE efeds_spiders_agn_fit_params (
---------------------------------------------------------------- 
--/H eFEDS SPIDERS AGN continuum and emission line Gaussian fit parameters (PyQSOFit).
--/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
--/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
--/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
--/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
--/T Also provided are the X-ray and public photometric data.
---------------------------------------------------------------- 
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
    first_local_complex_name varchar(8) NOT NULL, --/U  --/D First local line complex name 
    first_local_line_status bigint NOT NULL, --/U  --/D First local line complex fit status 
    first_local_line_min_chi2 float NOT NULL, --/U  --/D First local line complex chi2 
    first_local_line_red_chi2 float NOT NULL, --/U  --/D First local line complex reduced chi2 
    first_local_niter float NOT NULL, --/U  --/D First local line complex number of iterations 
    first_local_ndof float NOT NULL, --/U  --/D First local line complex number of pixels 
    first_local_npix float NOT NULL, --/U  --/D First local line complex number of degrees of freedom 
    second_local_complex_name varchar(8) NOT NULL, --/U  --/D Second local line complex name 
    second_local_line_status bigint NOT NULL, --/U  --/D Second local line complex fit status 
    second_local_line_min_chi2 float NOT NULL, --/U  --/D Second local line complex chi2 
    second_local_line_red_chi2 float NOT NULL, --/U  --/D Second local line complex reduced chi2 
    second_local_niter float NOT NULL, --/U  --/D Second local line complex number of iterations 
    second_local_ndof float NOT NULL, --/U  --/D Second local line complex number of pixels 
    second_local_npix float NOT NULL, --/U  --/D Second local line complex number of degrees of freedom 
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
    third_local_complex_name varchar(8) NOT NULL, --/U  --/D Third local line complex name 
    third_local_line_status bigint NOT NULL, --/U  --/D Third local line complex fit status 
    third_local_line_min_chi2 float NOT NULL, --/U  --/D Third local line complex chi2 
    third_local_line_red_chi2 float NOT NULL, --/U  --/D Third local line complex reduced chi2 
    third_local_niter float NOT NULL, --/U  --/D Third local line complex number of iterations 
    third_local_ndof float NOT NULL, --/U  --/D Third local line complex number of pixels 
    third_local_npix float NOT NULL, --/U  --/D Third local line complex number of degrees of freedom 
    fourth_local_complex_name varchar(8) NOT NULL, --/U  --/D Fourth local line complex name 
    fourth_local_line_status bigint NOT NULL, --/U  --/D Fourth local line complex fit status 
    fourth_local_line_min_chi2 float NOT NULL, --/U  --/D Fourth local line complex chi2 
    fourth_local_line_red_chi2 float NOT NULL, --/U  --/D Fourth local line complex reduced chi2 
    fourth_local_niter float NOT NULL, --/U  --/D Fourth local line complex number of iterations 
    fourth_local_ndof float NOT NULL, --/U  --/D Fourth local line complex number of pixels 
    fourth_local_npix float NOT NULL, --/U  --/D Fourth local line complex number of degrees of freedom 
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
    fifth_local_complex_name varchar(8) NOT NULL, --/U  --/D Fifth local line complex name 
    fifth_local_line_status bigint NOT NULL, --/U  --/D Fifth local line complex fit status 
    fifth_local_line_min_chi2 float NOT NULL, --/U  --/D Fifth local line complex chi2 
    fifth_local_line_red_chi2 float NOT NULL, --/U  --/D Fifth local line complex reduced chi2 
    fifth_local_niter float NOT NULL, --/U  --/D Fifth local line complex number of iterations 
    fifth_local_ndof float NOT NULL, --/U  --/D Fifth local line complex number of pixels 
    fifth_local_npix float NOT NULL, --/U  --/D Fifth local line complex number of degrees of freedom 
    hg_subtraction bit NOT NULL, --/U  --/D True: host-galaxy emission subtracted; False: quasar-dominated 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_spiders_agn_hard_xray_cat')
	DROP TABLE efeds_spiders_agn_hard_xray_cat
GO
--
EXEC spSetDefaultFileGroup 'efeds_spiders_agn_hard_xray_cat'
GO

CREATE TABLE efeds_spiders_agn_hard_xray_cat (
---------------------------------------------------------------- 
--/H eROSITA Hard Sample X-ray catalogue from Brunner et al. (2022)
--/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
--/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
--/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
--/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
--/T Also provided are the X-ray and public photometric data.
---------------------------------------------------------------- 
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
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_spiders_agn_host_decomp')
	DROP TABLE efeds_spiders_agn_host_decomp
GO
--
EXEC spSetDefaultFileGroup 'efeds_spiders_agn_host_decomp'
GO

CREATE TABLE efeds_spiders_agn_host_decomp (
---------------------------------------------------------------- 
--/H eFEDS SPIDERS AGN stellar population and host-galaxy properties (host decomposition with pPXF).
--/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
--/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
--/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
--/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
--/T Also provided are the X-ray and public photometric data.
---------------------------------------------------------------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source name (Brunner+2022) 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of Main sample eROSITA source (Brunner+2022) 
    ero_id_hard int NOT NULL, --/U  --/D ID of Hard sample eROSITA source (Brunner+2022) 
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from visual inspection (Aydar+2025) 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension (J2000) 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination (J2000) 
    mjd int NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    hg_subtraction bit NOT NULL, --/U  --/D True: host-galaxy emission subtracted; False: quasar-dominated 
    reduced_chi2 float NOT NULL, --/U  --/D Reduced chi2 from pPXF fit 
    f_agn float NOT NULL, --/U  --/D AGN continuum (PL+Fe II+Balmer) weight to continuum fit 
    f_hg float NOT NULL, --/U  --/D Host galaxy continuum (SSP) weight to continuum fit 
    stellar_mass_flux_msun_r float NOT NULL, --/U Msun --/D Stellar mass within aperture from the spectral flux in DECam r 
    apcorr_factor float NOT NULL, --/U  --/D Aperture correction factor (Aydar+2026a) 
    stellar_mass_msun_r_apcorr float NOT NULL, --/U Msun --/D Aperture corrected stellar mass from the spectral flux in DECam r 
    stellar_mass_flux_msun_g float NOT NULL, --/U Msun --/D Stellar mass within aperture from the spectral flux in DECam g 
    velocity_dispersion_stars float NOT NULL, --/U km/s --/D Stellar velocity dispersion (second term of kinematic fit) 
    velocity_dispersion_stars_error float NOT NULL, --/U km/s --/D Stellar velocity dispersion error 
    velocity_stars float NOT NULL, --/U km/s --/D Stellar velocity (first term of kinematic fit) 
    velocity_stars_error float NOT NULL, --/U km/s --/D Stellar velocity error 
    specz_normc_specz varchar(6) NOT NULL, --/U  --/D Final normalised classification (Aydar+2025) 
    plate int NOT NULL, --/U  --/D SDSS PLATE 
    fiberid int NOT NULL, --/U  --/D SDSS FIBER ID 
    catalogid bigint NOT NULL, --/U  --/D SDSS CATALOGID 
    run2d varchar(7) NOT NULL, --/U  --/D Tagged version of idlspec2d used to reduce the SDSS BOSS spectra 
    sn_median_all float NOT NULL, --/U  --/D SDSS Median S/N per pix in spectrum (idlspec2d v6_0_2 reductions) 
    ctp_ls8_type varchar(4) NOT NULL, --/U  --/D Morphological model from LS8 
    ls8_g float NOT NULL, --/U mag --/D LS8 g-band magnitude (AB) 
    ls8_r float NOT NULL, --/U mag --/D LS8 r-band magnitude (AB) 
    flux_decam_r float NOT NULL, --/U erg/s/cm2 --/D Spectral flux integrated in the DECam r band coverage 
    d4000 float NOT NULL, --/U  --/D D4000 break measurement from observed spectrum 
    d4000_error float NOT NULL, --/U  --/D D4000 break measurement from observed spectrum error 
    log_mean_age_yr_light float NOT NULL, --/U  --/D Mean light-weighted age from SSP fits (log, yr) 
    mean_metallicity_zsun_light float NOT NULL, --/U Zsun --/D Mean light-weighted metallicity from SSP fits 
    log_mean_age_yr_mass float NOT NULL, --/U  --/D Mean mass-weighted age from SSP fits (log, yr) 
    mean_metallicity_zsun_mass float NOT NULL, --/U Zsun --/D Mean mass-weighted metallicity from SSP fits 
    mass_to_light_decamr float NOT NULL, --/U  --/D Mass to light ratio from the spectral flux in DECam r 
    logl_decamr_ssp float NOT NULL, --/U  --/D SSP luminosity from the spectral flux in DECam r (log, erg/s) 
    mass_to_light_decamg float NOT NULL, --/U  --/D Mass to light ratio from the spectral flux in DECam g 
    logl_decamg_ssp float NOT NULL, --/U  --/D SSP luminosity from the spectral flux in DECam g (log, erg/s) 
    logl5100_ssp float NOT NULL, --/U  --/D SSP luminosity at 5100 A (log, erg/s) 
    logl5100_agn float NOT NULL, --/U  --/D AGN luminosity at 5100 A (log, erg/s) 
    logl5100_obs float NOT NULL, --/U  --/D Observed luminosity at 5100 A (log, erg/s) 
    weight_ssp float NOT NULL, --/U  --/D Simple Stellar Population templates weight to total fit 
    weight_narrowlines float NOT NULL, --/U  --/D Narrow emission lines template weight to total fit 
    weight_broadlines float NOT NULL, --/U  --/D Broad emission lines template weight to total fit 
    weight_feii float NOT NULL, --/U  --/D Fe II pseudo-continuum template weight to total fit 
    weight_powerlaw float NOT NULL, --/U  --/D Power-law templates weight to total fit 
    weight_balmer float NOT NULL, --/U  --/D Balmer continuum and high-order templates weight to total fit 
    log_age_yr_1 float NOT NULL, --/U  --/D Age of SSP with highest weight (log, yr) 
    metallicity_zsun_1 float NOT NULL, --/U Zsun --/D Metallicity of SSP with highest weight 
    weight_1 float NOT NULL, --/U  --/D Weight of SSP with highest weight 
    log_age_yr_2 float NOT NULL, --/U  --/D Age of SSP with second highest weight (log, yr) 
    metallicity_zsun_2 float NOT NULL, --/U Zsun --/D Metallicity of SSP with second highest weight 
    weight_2 float NOT NULL, --/U  --/D Weight of SSP with second highest weight 
    log_age_yr_3 float NOT NULL, --/U  --/D Age of SSP with third highest weight (log, yr) 
    metallicity_zsun_3 float NOT NULL, --/U Zsun --/D Metallicity of SSP with third highest weight 
    weight_3 float NOT NULL, --/U  --/D Weight of SSP with third highest weight 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_spiders_agn_line_props')
	DROP TABLE efeds_spiders_agn_line_props
GO
--
EXEC spSetDefaultFileGroup 'efeds_spiders_agn_line_props'
GO

CREATE TABLE efeds_spiders_agn_line_props (
---------------------------------------------------------------- 
--/H eFEDS SPIDERS AGN emission lines properties (PYQSOFIT fitting)
--/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
--/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
--/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
--/T These objects were detected with eROSITA and followed up with SDSS (DR18).
--/T Also provided are the X-ray and public photometric data.
---------------------------------------------------------------- 
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
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_spiders_agn_main_xray_cat')
	DROP TABLE efeds_spiders_agn_main_xray_cat
GO
--
EXEC spSetDefaultFileGroup 'efeds_spiders_agn_main_xray_cat'
GO

CREATE TABLE efeds_spiders_agn_main_xray_cat (
---------------------------------------------------------------- 
--/H eROSITA Main Sample X-ray catalogue from Brunner et al. (2022)
--/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
--/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
--/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
--/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
--/T Also provided are the X-ray and public photometric data.
---------------------------------------------------------------- 
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
    det_like real NOT NULL, --/U  --/D Detection likelihood measured by PSF-fitting, combining 3 bands 
    ml_rate real NOT NULL, --/U count/s --/D Source count rate, combining 3 bands 
    ml_rate_err real NOT NULL, --/U count/s --/D 1 sigma count rate error 
    ml_cts real NOT NULL, --/U count --/D Source net counts, combining 3 bands 
    ml_cts_err real NOT NULL, --/U count --/D 1 sigma counts error 
    ml_flux real NOT NULL, --/U erg / (cm2 s) --/D Source flux, combining 3 bands 
    ml_flux_err real NOT NULL, --/U erg / (cm2 s) --/D 1 sigma flux error 
    ml_exp real NOT NULL, --/U s --/D Vignetted exposure value 
    ml_bkg real NOT NULL, --/U count/arcmin^2 --/D Background flux at the source position 
    inarea90 bit NOT NULL, --/U  --/D True if in the 0.2-2.3keV exp>500s region, which comprises 90% area 
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
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'efeds_spiders_agn_xray_props')
	DROP TABLE efeds_spiders_agn_xray_props
GO
--
EXEC spSetDefaultFileGroup 'efeds_spiders_agn_xray_props'
GO

CREATE TABLE efeds_spiders_agn_xray_props (
---------------------------------------------------------------- 
--/H eFEDS SPIDERS AGN X-ray spectral properties from Liu et al. (2022)
-----------------------------------------------------------------
--/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
--/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
--/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
--/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
--/T Also provided are the X-ray and public photometric data.
---------------------------------------------------------------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source Name (Brunner+2022) 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of Main sample eROSITA source (Brunner+2022) 
    ero_id_hard int NOT NULL, --/U  --/D ID of Hard sample eROSITA source (Brunner+2022) 
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from visual inspection (Aydar+2025) 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension (J2000) 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination (J2000) 
    mjd bigint NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    redshift real NOT NULL, --/U  --/D Redshift of the optical counterpart (Paper II) 
    new_class int NOT NULL, --/U  --/D Updated classification of the optical counterpart 
    new_quality int NOT NULL, --/U  --/D Updated counterpart quality 
    ra_corr float NOT NULL, --/U deg --/D eROSITA right ascension (J2000), astrometric corrected (Paper I) 
    dec_corr float NOT NULL, --/U deg --/D eROSITA declination (J2000), astrometric corrected (Paper I) 
    det_like real NOT NULL, --/U  --/D 0.2-2.3 keV source detection likelihood (Paper I) 
    inarea90 bit NOT NULL, --/U  --/D Whether located inside the inner 90%-area region of eFEDS (Paper I) 
    edr_quality smallint NOT NULL, --/U  --/D Counterpart quality (Paper II). A value >=2 is recommended. 
    edr_class smallint NOT NULL, --/U  --/D Classification of the optical counterpart (Paper II). 0:likely Galac 
    edr_redshift real NOT NULL, --/U  --/D Redshift of the optical counterpart (Paper II) 
    lxmodel int NOT NULL, --/U  --/D Index of selected model for luminosity measurement. 1:single-powerla 
    nhclass int NOT NULL, --/U  --/D Class of AGN NH measurement with model 1 (single-powerlaw). 1: uninf 
    fsmodel int NOT NULL, --/U  --/D Index of selected model for 0.5-2keV flux. 5: counts-based measureme 
    fhmodel int NOT NULL, --/U  --/D Index of selected model for 2.3-5keV flux. 5: counts-based measureme 
    galnh float NOT NULL, --/U cm-2 --/D Total column density of Galactic absorption 
    galnhi float NOT NULL, --/U cm-2 --/D HI column density from HI4PI 
    srccts float NOT NULL, --/U count --/D Source net counts in the 0.2-5 keV band 
    fluxcorr_med_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 0.5-2 keV, posterior median 
    fluxcorr_lo1_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 0.5-2 keV, 1sigma lower limit 
    fluxcorr_up1_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 0.5-2 keV, 1sigma upper limit 
    fluxcorr_med_t real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 2.3-5 keV, posterior median 
    fluxcorr_lo1_t real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 2.3-5 keV, 1sigma lower limit 
    fluxcorr_up1_t real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in observed 2.3-5 keV, 1sigma upper limit 
    fluxintr_med_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in rest-frame 0.5-2 keV, posterior median 
    fluxintr_lo1_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in rest-frame 0.5-2keV, 1sigma lower limit 
    fluxintr_up1_s real NOT NULL, --/U erg / (cm2 s) --/D Absorption corrected flux in rest-frame 0.5-2keV, 1sigma upper limit 
    fluxintr_med_2kev real NOT NULL, --/U erg / (cm2 eV s) --/D Absorption corrected flux at rest-frame 2keV, median 
    fluxintr_lo1_2kev real NOT NULL, --/U erg / (cm2 eV s) --/D Absorption corrected flux at rest-frame 2keV, 1sigma lower limit 
    fluxintr_up1_2kev real NOT NULL, --/U erg / (cm2 eV s) --/D Absorption corrected flux at rest-frame 2keV, 1sigma upper limit 
    lumiintr_med_s real NOT NULL, --/U erg / s --/D Intrinsic luminosity in rest-frame 0.5-2 keV, posterior median 
    lumiintr_lo1_s real NOT NULL, --/U erg / s --/D Intrinsic luminosity in rest-frame 0.5-2 keV, 1sigma lower limit 
    lumiintr_up1_s real NOT NULL, --/U erg / s --/D Intrinsic luminosity in rest-frame 0.5-2 keV, 1sigma upper limit 
    lumiintr_med_2kev real NOT NULL, --/U erg / (eV s) --/D Intrinsic luminosity at rest-frame 2keV, posterior median 
    lumiintr_lo1_2kev real NOT NULL, --/U erg / (eV s) --/D Intrinsic luminosity at rest-frame 2keV, 1sigma lower limit 
    lumiintr_up1_2kev real NOT NULL, --/U erg / (eV s) --/D Intrinsic luminosity at rest-frame 2keV, 1sigma upper limit 
    fluxobsv_med_s real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 0.5-2 keV, posterior median 
    fluxobsv_lo1_s real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 0.5-2 keV, 1sigma lower limit 
    fluxobsv_up1_s real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 0.5-2 keV, 1sigma upper limit 
    fluxobsv_med_t real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 2.3-5 keV, posterior median 
    fluxobsv_lo1_t real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 2.3-5 keV, 1sigma lower limit 
    fluxobsv_up1_t real NOT NULL, --/U erg / (cm2 s) --/D Observed flux in observed 2.3-5 keV, 1sigma upper limit 
    lognh_kl_m1 real NOT NULL, --/U nats --/D log AGN column density, KL divergence 
    lognh_hlo_m1 real NOT NULL, --/U cm-2 --/D log AGN column density, HDI lower limit 
    lognh_hup_m1 real NOT NULL, --/U cm-2 --/D log AGN column density, HDI upper limit 
    lognh_med_m1 real NOT NULL, --/U cm-2 --/D log AGN column density, posterior median 
    gamma_kl_m3 real NOT NULL, --/U nats --/D primary power-law slope in model 3, KL divergence 
    gamma_hlo_m3 real NOT NULL, --/U  --/D primary power-law slope in model 3, HDI lower limit 
    gamma_hup_m3 real NOT NULL, --/U  --/D primary power-law slope in model 3, HDI upper limit 
    gamma_med_m3 real NOT NULL, --/U  --/D primary power-law slope in model 3, posterior median 
    logz_m0 real NOT NULL, --/U  --/D log Bayesian evidence with model 0: APEC 
    logz_m1 real NOT NULL, --/U  --/D log Bayesian evidence with model 1: single powerlaw 
    logz_m2 real NOT NULL, --/U  --/D log Bayesian evidence with model 2: double powerlaw 
    logz_m3 real NOT NULL, --/U  --/D log Bayesian evidence with model 3: powerlaw + blackbody 
    logz_m4 real NOT NULL, --/U  --/D log Bayesian evidence with model 4: powerlaw with Gamma fixed at 2.0 
    logz_m5 real NOT NULL, --/U  --/D log Bayesian evidence with model 5: shape-fixed powerlaw 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'erass1_hard_v1_0')
	DROP TABLE erass1_hard_v1_0
GO
--
EXEC spSetDefaultFileGroup 'erass1_hard_v1_0'
GO

CREATE TABLE erass1_hard_v1_0 (
-----------------------------------------
--/H eROSITA/eRASS1 hard catalogue
--/T Hard eRASS1 X-ray catalog from the 3B (in the 2.3-5.0 keV band) eSASS source detection run.
--/T Reference: https://ui.adsabs.harvard.edu/abs/2024A%26A...682A..34M/abstract
-----------------------------------------
    iauname varchar(23) NOT NULL, --/D String containing the official IAU name of the source --/U 
    detuid varchar(32) NOT NULL, --/D String unique detection ID --/U 
    skytile int NOT NULL, --/D Sky tile ID --/U 
    id_src int NOT NULL, --/D Source ID in each sky tile. Use SKYTILE+ID_SRC to identify the corresponding source products --/U 
    uid bigint NOT NULL, --/D Integer unique detection ID. It equals CatID*10^11+SKYTILE*10^5+ID_SRC, where catID is 1 for the 1B detected Main and Supp catalogs and 2 for the 3B detected Hard catalog --/U 
    uid_1b bigint NOT NULL, --/D 1B catalog UID of the source with a strong association, or -UID if the association is weak --/U 
    id_cluster int NOT NULL, --/D Group ID of simultaneously fitted sources --/U 
    ra float NOT NULL, --/D Right ascension (ICRS), corrected --/U deg
    dec float NOT NULL, --/D Declination (ICRS), corrected --/U deg
    ra_raw float NOT NULL, --/D Right ascension (ICRS), uncorrected --/U deg
    dec_raw float NOT NULL, --/D Declination (ICRS), uncorrected --/U deg
    ra_lowerr real NOT NULL, --/D 1-sigma lower error on RA --/U arcsec
    ra_uperr real NOT NULL, --/D 1-sigma upper error on RA --/U arcsec
    dec_lowerr real NOT NULL, --/D 1-sigma lower error on DEC --/U arcsec
    dec_uperr real NOT NULL, --/D 1-sigma upper error on DEC --/U arcsec
    pos_err real NOT NULL, --/D 1-sigma positional uncertainty --/U 
    radec_err real NOT NULL, --/D Combined positional error, raw output from PSF fitting --/U 
    lii float NOT NULL, --/D LII --/U deg
    bii float NOT NULL, --/D BII --/U deg
    elon float NOT NULL, --/D Ecliptic longitude --/U deg
    elat float NOT NULL, --/D Ecliptic latitude --/U deg
    mjd real NOT NULL, --/D Modified Julian Date of the observation of the source nearest to the optical axis of the telescope --/U 
    mjd_min real NOT NULL, --/D Modified Julian Date of the first observation of the source --/U 
    mjd_max real NOT NULL, --/D Modified Julian Date of the last observation of the source --/U 
    ext real NOT NULL, --/D Source Extent Parameter --/U arcsec
    ext_err real NOT NULL, --/D 1-sigma error on EXT --/U arcsec
    ext_lowerr real NOT NULL, --/D 1-sigma lower error on EXT --/U arcsec
    ext_uperr real NOT NULL, --/D 1-sigma upper error on EXT --/U arcsec
    ext_like real NOT NULL, --/D Extent likelihood --/U 
    ml_cts_0 real NOT NULL, --/D Source net counts in 0.2-5.0 keV band --/U count
    ml_cts_err_0 real NOT NULL, --/D 1-sigma combined counts error in 0.2-5.0 keV band --/U count
    ml_rate_0 real NOT NULL, --/D Source count rate in 0.2-5.0 keV band --/U count s-1
    ml_rate_err_0 real NOT NULL, --/D 1-sigma combined count rate error in 0.2-5.0 keV band --/U count s-1
    ml_flux_0 real NOT NULL, --/D Source flux in 2.3-5.0 keV band --/U erg s-1 cm-2
    ml_flux_err_0 real NOT NULL, --/D 1-sigma combined error on flux in 0.2-5.0 keV band --/U erg s-1 cm-2
    det_like_0 real NOT NULL, --/D Detection likelihood in 0.2-5.0 keV band --/U 
    ml_bkg_0 real NOT NULL, --/D Background at the source position in the 0.2-5.0 keV band --/U arcmin-2
    ml_cts_1 real NOT NULL, --/D Source net counts in 0.2-0.6 keV band --/U count
    ml_cts_err_1 real NOT NULL, --/D 1-sigma combined counts error in 0.2-0.6 keV band --/U count
    ml_cts_lowerr_1 real NOT NULL, --/D 1-sigma lower counts error in 0.2-0.6 keV band --/U count
    ml_cts_uperr_1 real NOT NULL, --/D 1-sigma upper counts error in 0.2-0.6 keV band --/U count
    ml_rate_1 real NOT NULL, --/D Source count rate in 0.2-0.6 keV band --/U count s-1
    ml_rate_err_1 real NOT NULL, --/D 1-sigma combined count rate error in 0.2-0.6 keV band --/U count s-1
    ml_rate_lowerr_1 real NOT NULL, --/D 1-sigma lower count rate error in 0.2-0.6 keV band --/U count s-1
    ml_rate_uperr_1 real NOT NULL, --/D 1-sigma upper count rate error in 0.2-0.6 keV band --/U count s-1
    ml_flux_1 real NOT NULL, --/D Source flux in 0.2-0.6 keV band --/U erg s-1 cm-2
    ml_flux_err_1 real NOT NULL, --/D 1-sigma combined error on flux in 0.2-0.6 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_1 real NOT NULL, --/D 1-sigma lower error on flux in 0.2-0.6 keV band --/U erg s-1 cm-2
    ml_flux_uperr_1 real NOT NULL, --/D 1-sigma upper error on flux in 0.2-0.6 keV band --/U erg s-1 cm-2
    det_like_1 real NOT NULL, --/D Detection likelihood in 0.2-0.6 keV band --/U 
    ml_bkg_1 real NOT NULL, --/D Background at the source position in the 0.2-0.6 keV band --/U arcmin-2
    ml_exp_1 real NOT NULL, --/D Vignetted exposure time at the source position in 0.2-0.6 keV band --/U s
    ml_eef_1 real NOT NULL, --/D Enclosed energy fraction in 0.2-0.6 keV band --/U 
    ape_cts_1 int NOT NULL, --/D Total counts extracted within the aperture in 0.2-0.6 keV band --/U count
    ape_bkg_1 real NOT NULL, --/D Background counts extracted within the aperture in 0.2-0.6 keV band, excluding nearby sources using the source map --/U count
    ape_exp_1 real NOT NULL, --/D Exposure map value in 0.2-0.6 keV band at the given position --/U s
    ape_radius_1 real NOT NULL, --/D Extraction radius in pixels (4'') in the 0.2-0.6 keV band --/U pix
    ape_pois_1 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_1) are a background fluctuation --/U 
    ml_cts_2 real NOT NULL, --/D Source net counts in 0.6-2.3 keV band --/U count
    ml_cts_err_2 real NOT NULL, --/D 1-sigma combined counts error in 0.6-2.3 keV band --/U count
    ml_cts_lowerr_2 real NOT NULL, --/D 1-sigma lower counts error in 0.6-2.3 keV band --/U count
    ml_cts_uperr_2 real NOT NULL, --/D 1-sigma upper counts error in 0.6-2.3 keV band --/U count
    ml_rate_2 real NOT NULL, --/D Source count rate in 0.6-2.3 keV band --/U count s-1
    ml_rate_err_2 real NOT NULL, --/D 1-sigma combined count rate error in 0.6-2.3 keV band --/U count s-1
    ml_rate_lowerr_2 real NOT NULL, --/D 1-sigma lower count rate error in 0.6-2.3 keV band --/U count s-1
    ml_rate_uperr_2 real NOT NULL, --/D 1-sigma upper count rate error in 0.6-2.3 keV band --/U count s-1
    ml_flux_2 real NOT NULL, --/D Source flux in 0.6-2.3 keV band --/U erg s-1 cm-2
    ml_flux_err_2 real NOT NULL, --/D 1-sigma combined error on flux in 0.6-2.3 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_2 real NOT NULL, --/D 1-sigma lower error on flux in 0.6-2.3 keV band --/U erg s-1 cm-2
    ml_flux_uperr_2 real NOT NULL, --/D 1-sigma upper error on flux in 0.6-2.3 keV band --/U erg s-1 cm-2
    det_like_2 real NOT NULL, --/D Detection likelihood in 0.6-2.3 keV band --/U 
    ml_bkg_2 real NOT NULL, --/D Background at the source position in the 0.6-2.3 keV band --/U arcmin-2
    ml_exp_2 real NOT NULL, --/D Vignetted exposure time at the source position in 0.6-2.3 keV band --/U s
    ml_eef_2 real NOT NULL, --/D Enclosed energy fraction in 0.6-2.3 keV band --/U 
    ape_cts_2 int NOT NULL, --/D Total counts extracted within the aperture in 0.6-2.3 keV band --/U count
    ape_bkg_2 real NOT NULL, --/D Background counts extracted within the aperture in 0.6-2.3 keV band, excluding nearby sources using the source map --/U count
    ape_exp_2 real NOT NULL, --/D Exposure map value in 0.6-2.3 keV band at the given position --/U s
    ape_radius_2 real NOT NULL, --/D Extraction radius in pixels (4'') in the 0.6-2.3 keV band --/U pix
    ape_pois_2 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_2) are a background fluctuation --/U 
    ml_cts_3 real NOT NULL, --/D Source net counts in 2.3-5.0 keV band --/U count
    ml_cts_err_3 real NOT NULL, --/D 1-sigma combined counts error in 2.3-5.0 keV band --/U count
    ml_cts_lowerr_3 real NOT NULL, --/D 1-sigma lower counts error in 2.3-5.0 keV band --/U count
    ml_cts_uperr_3 real NOT NULL, --/D 1-sigma upper counts error in 2.3-5.0 keV band --/U count
    ml_rate_3 real NOT NULL, --/D Source count rate in 2.3-5.0 keV band --/U count s-1
    ml_rate_err_3 real NOT NULL, --/D 1-sigma combined count rate error in 2.3-5.0 keV band --/U count s-1
    ml_rate_lowerr_3 real NOT NULL, --/D 1-sigma lower count rate error in 2.3-5.0 keV band --/U count s-1
    ml_rate_uperr_3 real NOT NULL, --/D 1-sigma upper count rate error in 2.3-5.0 keV band --/U count s-1
    ml_flux_3 real NOT NULL, --/D Source flux in 2.3-5.0 keV band --/U erg s-1 cm-2
    ml_flux_err_3 real NOT NULL, --/D 1-sigma combined error on flux in 2.3-5.0 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_3 real NOT NULL, --/D 1-sigma lower error on flux in 2.3-5.0 keV band --/U erg s-1 cm-2
    ml_flux_uperr_3 real NOT NULL, --/D 1-sigma upper error on flux in 2.3-5.0 keV band --/U erg s-1 cm-2
    det_like_3 real NOT NULL, --/D Detection likelihood in 2.3-5.0 keV band --/U 
    ml_bkg_3 real NOT NULL, --/D Background at the source position in the 2.3-5.0 keV band --/U arcmin-2
    ml_exp_3 real NOT NULL, --/D Vignetted exposure time at the source position in 2.3-5.0 keV band --/U s
    ml_eef_3 real NOT NULL, --/D Enclosed energy fraction in 2.3-5.0 keV band --/U 
    ape_cts_3 int NOT NULL, --/D Total counts extracted within the aperture in 2.3-5.0 keV band --/U count
    ape_bkg_3 real NOT NULL, --/D Background counts extracted within the aperture in 2.3-5.0 keV band, excluding nearby sources using the source map --/U count
    ape_exp_3 real NOT NULL, --/D Exposure map value in 2.3-5.0 keV band at the given position --/U s
    ape_radius_3 real NOT NULL, --/D Extraction radius in pixels (4'') in the 2.3-5.0 keV band --/U pix
    ape_pois_3 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_3) are a background fluctuation --/U 
    flag_sp_snr smallint NOT NULL, --/D Source may lie within an overdense region near a supernova remnant --/U 
    flag_sp_bps smallint NOT NULL, --/D Source may lie within an overdense region near a bright point source --/U 
    flag_sp_scl smallint NOT NULL, --/D Source may lie within an overdense region near a stellar cluste --/U 
    flag_sp_lga smallint NOT NULL, --/D Source may lie within an overdense region near a local large galaxy --/U 
    flag_sp_gc_cons smallint NOT NULL, --/D Source may lie within an overdense region near a galaxy cluster --/U 
    flag_no_radec_err smallint NOT NULL, --/D Source contained no RADEC_ERR in the pre-processed version of the catalogue --/U 
    flag_no_ext_err smallint NOT NULL, --/D Source contained no EXT_ERR in the pre-processed version of the catalogue --/U 
    flag_no_cts_err smallint NOT NULL, --/D Source contained no CTS_ERR in the pre-processed version of the catalogue --/U 
    flag_opt smallint NOT NULL --/D Source matched within 15'' with a bright optical star, likely contaminated by optical loading --/U 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'erass1_main_v1_2')
	DROP TABLE erass1_main_v1_2
GO
--
EXEC spSetDefaultFileGroup 'erass1_main_v1_2'
GO

CREATE TABLE erass1_main_v1_2 (
-----------------------------------------
--/H eROSITA/eRASS1 main catalogue
--/T X-ray sources detected in the 0.2>2.3 keV band using eSASS adopting a detection likelihood threshold
--/T of 5. The sources with detection likelihood larger than 6 are selected as the main eRASS1 catalogue
--/T (930203 sources). 12.01.2026: Version 1.2 available. It fixes the values of the column named
--/T NO_FLAG_EXT_ERR .
--/T Reference: https://ui.adsabs.harvard.edu/abs/2024A%26A...682A..34M/abstract
-----------------------------------------
    iauname varchar(23) NOT NULL, --/D String containing the official IAU name of the source --/U 
    detuid varchar(32) NOT NULL, --/D String unique detection ID --/U 
    skytile int NOT NULL, --/D Sky tile ID --/U 
    id_src int NOT NULL, --/D Source ID in each sky tile. Use SKYTILE+ID_SRC to identify the corresponding source products --/U 
    uid bigint NOT NULL, --/D Integer unique detection ID. It equals CatID*10^11+SKYTILE*10^5+ID_SRC, where catID is 1 for the 1B detected Main and Supp catalogs and 2 for the 3B detected Hard catalog --/U 
    uid_hard bigint NOT NULL, --/D Hard catalog UID of the source with a strong association, or -UID if the association is weak --/U 
    id_cluster int NOT NULL, --/D Group ID of simultaneously fitted sources --/U 
    ra float NOT NULL, --/D Right ascension (ICRS), corrected --/U deg
    dec float NOT NULL, --/D Declination (ICRS), corrected --/U deg
    ra_raw float NOT NULL, --/D Right ascension (ICRS), uncorrected --/U deg
    dec_raw float NOT NULL, --/D Declination (ICRS), uncorrected --/U deg
    ra_lowerr real NOT NULL, --/D 1-sigma lower error on RA --/U arcsec
    ra_uperr real NOT NULL, --/D 1-sigma upper error on RA --/U arcsec
    dec_lowerr real NOT NULL, --/D 1-sigma lower error on DEC --/U arcsec
    dec_uperr real NOT NULL, --/D 1-sigma upper error on DEC --/U arcsec
    pos_err real NOT NULL, --/D 1-sigma positional uncertainty --/U 
    radec_err real NOT NULL, --/D Combined positional error, raw output from PSF fitting --/U 
    lii float NOT NULL, --/D LII --/U deg
    bii float NOT NULL, --/D BII --/U deg
    elon float NOT NULL, --/D Ecliptic longitude --/U deg
    elat float NOT NULL, --/D Ecliptic latitude --/U deg
    mjd real NOT NULL, --/D Modified Julian Date of the observation of the source nearest to the optical axis of the telescope --/U d
    mjd_min real NOT NULL, --/D Modified Julian Date of the first observation of the source --/U d
    mjd_max real NOT NULL, --/D Modified Julian Date of the last observation of the source --/U d
    ext real NOT NULL, --/D Source Extent Parameter --/U arcsec
    ext_err real NOT NULL, --/D 1-sigma error on EXT --/U arcsec
    ext_lowerr real NOT NULL, --/D 1-sigma lower error on EXT --/U arcsec
    ext_uperr real NOT NULL, --/D 1-sigma upper error on EXT --/U arcsec
    ext_like real NOT NULL, --/D Extent likelihood --/U 
    det_like_0 real NOT NULL, --/D Detection likelihood in 0.2-2.3 keV band --/U 
    ml_cts_1 real NOT NULL, --/D Source net counts in 0.2-2.3 keV band --/U count
    ml_cts_err_1 real NOT NULL, --/D 1-sigma combined counts error in 0.2-2.3 keV band --/U count
    ml_cts_lowerr_1 real NOT NULL, --/D 1-sigma lower counts error in 0.2-2.3 keV band --/U count
    ml_cts_uperr_1 real NOT NULL, --/D 1-sigma upper counts error in 0.2-2.3 keV band --/U count
    ml_rate_1 real NOT NULL, --/D Source count rate in 0.2-2.3 keV band --/U count s-1
    ml_rate_err_1 real NOT NULL, --/D 1-sigma combined count rate error in 0.2-2.3 keV band --/U count s-1
    ml_rate_lowerr_1 real NOT NULL, --/D 1-sigma lower count rate error in 0.2-2.3 keV band --/U count s-1
    ml_rate_uperr_1 real NOT NULL, --/D 1-sigma upper count rate error in 0.2-2.3 keV band --/U count s-1
    ml_flux_1 real NOT NULL, --/D Source flux in 0.2-2.3 keV band --/U erg s-1 cm-2
    ml_flux_err_1 real NOT NULL, --/D 1-sigma combined error on flux in 0.2-2.3 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_1 real NOT NULL, --/D 1-sigma lower error on flux in 0.2-2.3 keV band --/U erg s-1 cm-2
    ml_flux_uperr_1 real NOT NULL, --/D 1-sigma upper error on flux in 0.2-2.3 keV band --/U erg s-1 cm-2
    ml_bkg_1 real NOT NULL, --/D Background at the source position in the 0.2-2.3 keV band --/U arcmin-2
    ml_exp_1 real NOT NULL, --/D Vignetted exposure time at the source position in 0.2-2.3 keV band --/U s
    ml_eef_1 real NOT NULL, --/D Enclosed energy fraction --/U 
    ape_cts_1 int NOT NULL, --/D Total counts extracted within the aperture in 0.2-2.3 keV band --/U count
    ape_bkg_1 real NOT NULL, --/D Background counts extracted within the aperture in 0.2-2.3 keV band, excluding nearby sources using the source map --/U count
    ape_exp_1 real NOT NULL, --/D Exposure map value in 0.2-2.3 keV band at the given position --/U s
    ape_radius_1 real NOT NULL, --/D Extraction radius in pixels (4'') in the 0.2-2.3 keV band --/U pix
    ape_pois_1 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_1) are a background fluctuation --/U 
    det_like_p1 real NOT NULL, --/D Detection likelihood in 0.2-0.5 keV band --/U 
    ml_cts_p1 real NOT NULL, --/D Source net counts in 0.2-0.5 keV band --/U count
    ml_cts_err_p1 real NOT NULL, --/D 1-sigma combined counts error in 0.2-0.5 keV band --/U count
    ml_cts_lowerr_p1 real NOT NULL, --/D 1-sigma lower counts error in 0.2-0.5 keV band --/U count
    ml_cts_uperr_p1 real NOT NULL, --/D 1-sigma upper counts error in 0.2-0.5 keV band --/U 
    ml_rate_p1 real NOT NULL, --/D Source count rate in 0.2-0.5 keV band --/U count s-1
    ml_rate_err_p1 real NOT NULL, --/D 1-sigma combined count rate error in 0.2-0.5 keV band --/U count s-1
    ml_rate_lowerr_p1 real NOT NULL, --/D 1-sigma lower count rate error in 0.2-0.5 keV band --/U count s-1
    ml_rate_uperr_p1 real NOT NULL, --/D 1-sigma upper count rate error in 0.2-0.5 keV band --/U 
    ml_flux_p1 real NOT NULL, --/D Source flux in 0.2-0.5 keV band --/U erg s-1 cm-2
    ml_flux_err_p1 real NOT NULL, --/D 1-sigma combined flux error in 0.2-0.5 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p1 real NOT NULL, --/D 1-sigma lower flux error in 0.2-0.5 keV band --/U erg s-1 cm-2
    ml_flux_uperr_p1 real NOT NULL, --/D 1-sigma upper flux error in 0.2-0.5 keV band --/U erg s-1 cm-2
    ml_bkg_p1 real NOT NULL, --/D Background at the source position in 0.2-0.5 keV band --/U arcmin-2
    ml_exp_p1 real NOT NULL, --/D Vignetted exposure time at the source position in 0.2-0.5 keV band --/U s
    ml_eef_p1 real NOT NULL, --/D Enclosed energy fraction in 0.2-0.5 keV band --/U 
    ape_cts_p1 int NOT NULL, --/D Total counts extracted within the aperture in 0.2-0.5 keV band --/U count
    ape_bkg_p1 real NOT NULL, --/D Background counts extracted within the aperture in 0.2-0.5 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p1 real NOT NULL, --/D Exposure map value at the given position in the 0.2-0.5 keV band --/U s
    ape_radius_p1 real NOT NULL, --/D Extraction radius in pixels (4'') in the 0.2-0.5 keV band --/U pix
    ape_pois_p1 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P1) are a background fluctuation --/U 
    det_like_p2 real NOT NULL, --/D Detection likelihood in 0.5-1.0 keV band --/U 
    ml_cts_p2 real NOT NULL, --/D Source net counts in 0.5-1.0 keV band --/U count
    ml_cts_err_p2 real NOT NULL, --/D 1-sigma combined counts error in 0.5-1.0 keV band --/U count
    ml_cts_lowerr_p2 real NOT NULL, --/D 1-sigma lower counts error in 0.5-1.0 keV band --/U count
    ml_cts_uperr_p2 real NOT NULL, --/D 1-sigma upper counts error in 0.5-1.0 keV band --/U 
    ml_rate_p2 real NOT NULL, --/D Source count rate in 0.5-1.0 keV band --/U count s-1
    ml_rate_err_p2 real NOT NULL, --/D 1-sigma combined count rate error in 0.5-1.0 keV band --/U count s-1
    ml_rate_lowerr_p2 real NOT NULL, --/D 1-sigma lower count rate error in 0.5-1.0 keV band --/U count s-1
    ml_rate_uperr_p2 real NOT NULL, --/D 1-sigma upper count rate error in 0.5-1.0 keV band --/U count s-1
    ml_flux_p2 real NOT NULL, --/D Source flux in 0.5-1.0 keV band --/U erg s-1 cm-2
    ml_flux_err_p2 real NOT NULL, --/D 1-sigma combined flux error in 0.5-1.0 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p2 real NOT NULL, --/D 1-sigma lower flux error in 0.5-1.0 keV band --/U erg s-1 cm-2
    ml_flux_uperr_p2 real NOT NULL, --/D 1-sigma upper flux error in 0.5-1.0 keV band --/U erg s-1 cm-2
    ml_bkg_p2 real NOT NULL, --/D Background at the source position in 0.5-1.0 keV band --/U arcmin-2
    ml_exp_p2 real NOT NULL, --/D Vignetted exposure time at the source position in 0.5-1.0 keV band --/U s
    ml_eef_p2 real NOT NULL, --/D Enclosed energy fraction in 0.5-1.0 keV band --/U 
    ape_cts_p2 int NOT NULL, --/D Total counts extracted within the aperture in 0.5-1.0 keV band --/U 
    ape_bkg_p2 real NOT NULL, --/D Background counts extracted within the aperture in 0.5-1.0 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p2 real NOT NULL, --/D Exposure map value at the given position in the 0.5-1.0 keV band --/U s
    ape_radius_p2 real NOT NULL, --/D Extraction radius in pixels (4'') in the 0.5-1.0 keV band --/U pix
    ape_pois_p2 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P2) are a background fluctuation --/U 
    det_like_p3 real NOT NULL, --/D Detection likelihood in 1.0-2.0 keV band --/U 
    ml_cts_p3 real NOT NULL, --/D Source net counts in 1.0-2.0 keV band --/U count
    ml_cts_err_p3 real NOT NULL, --/D 1-sigma combined counts error in 1.0-2.0 keV band --/U count
    ml_cts_lowerr_p3 real NOT NULL, --/D 1-sigma lower counts error in 1.0-2.0 keV band --/U count
    ml_cts_uperr_p3 real NOT NULL, --/D 1-sigma upper counts error in 1.0-2.0 keV band --/U 
    ml_rate_p3 real NOT NULL, --/D Source count rate in 1.0-2.0 keV band --/U count s-1
    ml_rate_err_p3 real NOT NULL, --/D 1-sigma combined count rate error in 1.0-2.0 keV band --/U count s-1
    ml_rate_lowerr_p3 real NOT NULL, --/D 1-sigma lower count rate error in 1.0-2.0 keV band --/U count s-1
    ml_rate_uperr_p3 real NOT NULL, --/D 1-sigma upper count rate error in 1.0-2.0 keV band --/U count s-1
    ml_flux_p3 real NOT NULL, --/D Source flux in 1.0-2.0 keV band --/U erg s-1 cm-2
    ml_flux_err_p3 real NOT NULL, --/D 1-sigma combined flux error in 1.0-2.0 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p3 real NOT NULL, --/D 1-sigma lower flux error in 1.0-2.0 keV band --/U erg s-1 cm-2
    ml_flux_uperr_p3 real NOT NULL, --/D 1-sigma upper flux error in 1.0-2.0 keV band --/U erg s-1 cm-2
    ml_bkg_p3 real NOT NULL, --/D Background at the source position in 1.0-2.0 keV band --/U erg s-1 cm-2
    ml_exp_p3 real NOT NULL, --/D Vignetted exposure time at the source position in 1.0-2.0 keV band --/U s
    ml_eef_p3 real NOT NULL, --/D Enclosed energy fraction in 1.0-2.0 keV band --/U 
    ape_cts_p3 int NOT NULL, --/D Total counts extracted within the aperture in 1.0-2.0 keV band --/U count
    ape_bkg_p3 real NOT NULL, --/D Background counts extracted within the aperture in 1.0-2.0 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p3 real NOT NULL, --/D Exposure map value at the given position in the 1.0-2.0 keV band --/U s
    ape_radius_p3 real NOT NULL, --/D Extraction radius in pixels (4'') in the 1.0-2.0 keV band --/U pix
    ape_pois_p3 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P3) are a background fluctuation --/U 
    det_like_p4 real NOT NULL, --/D Detection likelihood in 2.0-5.0 keV band --/U 
    ml_cts_p4 real NOT NULL, --/D Source net counts in 2.0-5.0 keV band --/U count
    ml_cts_err_p4 real NOT NULL, --/D 1-sigma combined counts error in 2.0-5.0 keV band< --/U count
    ml_cts_lowerr_p4 real NOT NULL, --/D 1-sigma lower counts error in 2.0-5.0 keV band --/U count
    ml_cts_uperr_p4 real NOT NULL, --/D 1-sigma upper counts error in 2.0-5.0 keV band --/U 
    ml_rate_p4 real NOT NULL, --/D Source count rate in 2.0-5.0 keV band --/U count s-1
    ml_rate_err_p4 real NOT NULL, --/D 1-sigma combined count rate error in 2.0-5.0 keV band --/U count s-1
    ml_rate_lowerr_p4 real NOT NULL, --/D 1-sigma lower count rate error in 2.0-5.0 keV band --/U count s-1
    ml_rate_uperr_p4 real NOT NULL, --/D 1-sigma upper count rate error in 2.0-5.0 keV band --/U count s-1
    ml_flux_p4 real NOT NULL, --/D Source flux in 2.0-5.0 keV band --/U erg s-1 cm-2
    ml_flux_err_p4 real NOT NULL, --/D 1-sigma combined flux error in 2.0-5.0 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p4 real NOT NULL, --/D 1-sigma lower flux error in 2.0-5.0 keV band --/U erg s-1 cm-2
    ml_flux_uperr_p4 real NOT NULL, --/D 1-sigma upper flux error in 2.0-5.0 keV band --/U erg s-1 cm-2
    ml_bkg_p4 real NOT NULL, --/D Background at the source position in 2.0-5.0 keV band --/U arcmin-2
    ml_exp_p4 real NOT NULL, --/D Vignetted exposure time at the source position in 2.0-5.0 keV band --/U s
    ml_eef_p4 real NOT NULL, --/D Enclosed energy fraction in 2.0-5.0 keV band --/U 
    ape_cts_p4 int NOT NULL, --/D Total counts extracted within the aperture in 2.0-5.0 keV band --/U count
    ape_bkg_p4 real NOT NULL, --/D Background counts extracted within the aperture in 2.0-5.0 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p4 real NOT NULL, --/D Exposure map value at the given position in the 2.0-5.0 keV band --/U s
    ape_radius_p4 real NOT NULL, --/D Extraction radius in pixels (4'') in the 2.0-5.0 keV band --/U pix
    ape_pois_p4 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P4) are a background fluctuation --/U 
    det_like_p5 real NOT NULL, --/D Detection likelihood in 5.0-8.0 keV band --/U 
    ml_cts_p5 real NOT NULL, --/D Source net counts in 5.0-8.0 keV band --/U count
    ml_cts_err_p5 real NOT NULL, --/D 1-sigma combined counts error in 5.0-8.0 keV band --/U count
    ml_cts_lowerr_p5 real NOT NULL, --/D 1-sigma lower counts error in 5.0-8.0 keV band --/U count
    ml_cts_uperr_p5 real NOT NULL, --/D 1-sigma upper counts error in 5.0-8.0 keV band --/U 
    ml_rate_p5 real NOT NULL, --/D Source count rate in 5.0-8.0 keV band --/U count s-1
    ml_rate_err_p5 real NOT NULL, --/D 1-sigma combined count rate error in 5.0-8.0 keV band --/U count s-1
    ml_rate_lowerr_p5 real NOT NULL, --/D 1-sigma lower count rate error in 5.0-8.0 keV band --/U count s-1
    ml_rate_uperr_p5 real NOT NULL, --/D 1-sigma upper count rate error in 5.0-8.0 keV band --/U count s-1
    ml_flux_p5 real NOT NULL, --/D Source flux in 5.0-8.0 keV band --/U erg s-1 cm-2
    ml_flux_err_p5 real NOT NULL, --/D 1-sigma combined flux error in 5.0-8.0 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p5 real NOT NULL, --/D 1-sigma lower flux error in 5.0-8.0 keV band --/U erg s-1 cm-2
    ml_flux_uperr_p5 real NOT NULL, --/D 1-sigma upper flux error in 5.0-8.0 keV band --/U erg s-1 cm-2
    ml_bkg_p5 real NOT NULL, --/D Background at the source position in 5.0-8.0 keV band --/U arcmin-2
    ml_exp_p5 real NOT NULL, --/D Vignetted exposure time at the source position in 5.0-8.0 keV band --/U s
    ml_eef_p5 real NOT NULL, --/D Enclosed energy fraction in 5.0-8.0 keV band --/U 
    ape_cts_p5 int NOT NULL, --/D Total counts extracted within the aperture in 5.0-8.0 keV band --/U count
    ape_bkg_p5 real NOT NULL, --/D Background counts extracted within the aperture in 5.0-8.0 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p5 real NOT NULL, --/D Exposure map value at the given position in the 5.0-8.0 keV band --/U s
    ape_radius_p5 real NOT NULL, --/D Extraction radius in pixels (4'') in the 5.0-8.0 keV band --/U pix
    ape_pois_p5 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P5) are a background fluctuation --/U 
    det_like_p6 real NOT NULL, --/D Detection likelihood in 4.0-10.0 keV band --/U 
    ml_cts_p6 real NOT NULL, --/D Source net counts in 4.0-10.0 keV band --/U count
    ml_cts_err_p6 real NOT NULL, --/D 1-sigma combined counts error in 4.0-10.0 keV band --/U count
    ml_cts_lowerr_p6 real NOT NULL, --/D 1-sigma lower counts error in 4.0-10.0 keV band --/U count
    ml_cts_uperr_p6 real NOT NULL, --/D 1-sigma upper counts error in 4.0-10.0 keV band --/U 
    ml_rate_p6 real NOT NULL, --/D Source count rate in 4.0-10.0 keV band --/U count s-1
    ml_rate_err_p6 real NOT NULL, --/D 1-sigma combined count rate error in 4.0-10.0 keV band --/U count s-1
    ml_rate_lowerr_p6 real NOT NULL, --/D 1-sigma lower count rate error in 4.0-10.0 keV band --/U count s-1
    ml_rate_uperr_p6 real NOT NULL, --/D 1-sigma upper count rate error in 4.0-10.0 keV band --/U count s-1
    ml_flux_p6 real NOT NULL, --/D Source flux in 4.0-10.0 keV band --/U erg s-1 cm-2
    ml_flux_err_p6 real NOT NULL, --/D 1-sigma combined flux error in 4.0-10.0 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p6 real NOT NULL, --/D 1-sigma lower flux error in 4.0-10.0 keV band --/U erg s-1 cm-2
    ml_flux_uperr_p6 real NOT NULL, --/D 1-sigma upper flux error in 4.0-10.0 keV band --/U erg s-1 cm-2
    ml_bkg_p6 real NOT NULL, --/D Background at the source position in 4.0-10.0 keV band --/U arcmin-2
    ml_exp_p6 real NOT NULL, --/D Vignetted exposure time at the source position in 4.0-10.0 keV band --/U s
    ml_eef_p6 real NOT NULL, --/D Enclosed energy fraction in 4.0-10.0 keV band --/U 
    ape_cts_p6 int NOT NULL, --/D Total counts extracted within the aperture in 4.0-10.0 keV band --/U count
    ape_bkg_p6 real NOT NULL, --/D Background counts extracted within the aperture in 4.0-10.0 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p6 real NOT NULL, --/D Exposure map value at the given position in the 4.0-10.0 keV band --/U s
    ape_radius_p6 real NOT NULL, --/D Extraction radius in pixels (4'') in the 4.0-10.0 keV band --/U pix
    ape_pois_p6 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P6) are a background fluctuation --/U 
    det_like_p7 real NOT NULL, --/D Detection likelihood in 5.1-6.1 keV band --/U 
    ml_cts_p7 real NOT NULL, --/D Source net counts in 5.1-6.1 keV band --/U count
    ml_cts_err_p7 real NOT NULL, --/D 1-sigma combined counts error in 5.1-6.1 keV band --/U count
    ml_cts_lowerr_p7 real NOT NULL, --/D 1-sigma lower counts error in 5.1-6.1 keV band --/U count
    ml_cts_uperr_p7 real NOT NULL, --/D 1-sigma upper counts error in 5.1-6.1 keV band --/U 
    ml_rate_p7 real NOT NULL, --/D Source count rate in 5.1-6.1 keV band --/U count s-1
    ml_rate_err_p7 real NOT NULL, --/D 1-sigma combined count rate error in 5.1-6.1 keV band --/U count s-1
    ml_rate_lowerr_p7 real NOT NULL, --/D 1-sigma lower count rate error in 5.1-6.1 keV band --/U count s-1
    ml_rate_uperr_p7 real NOT NULL, --/D 1-sigma upper count rate error in 5.1-6.1 keV band --/U count s-1
    ml_flux_p7 real NOT NULL, --/D Source flux in 5.1-6.1 keV band --/U erg s-1 cm-2
    ml_flux_err_p7 real NOT NULL, --/D 1-sigma combined flux error in 5.1-6.1 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p7 real NOT NULL, --/D 1-sigma lower flux error in 5.1-6.1 keV band --/U erg s-1 cm-2
    ml_flux_uperr_p7 real NOT NULL, --/D 1-sigma upper flux error in 5.1-6.1 keV band --/U erg s-1 cm-2
    ml_bkg_p7 real NOT NULL, --/D Background at the source position in 5.1-6.1 keV band --/U arcmin-2
    ml_exp_p7 real NOT NULL, --/D Vignetted exposure time at the source position in 5.1-6.1 keV band --/U s
    ml_eef_p7 real NOT NULL, --/D Enclosed energy fraction in 5.1-6.1 keV band --/U 
    ape_cts_p7 int NOT NULL, --/D Total counts extracted within the aperture in 5.1-6.1 keV band --/U count
    ape_bkg_p7 real NOT NULL, --/D Background counts extracted within the aperture in 5.1-6.1 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p7 real NOT NULL, --/D Exposure map value at the given position in the 5.1-6.1 keV band --/U s
    ape_radius_p7 real NOT NULL, --/D Extraction radius in pixels (4'') in the 5.1-6.1 keV band --/U pix
    ape_pois_p7 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P7) are a background fluctuation --/U 
    det_like_p8 real NOT NULL, --/D Detection likelihood in 6.2-7.1 keV band --/U 
    ml_cts_p8 real NOT NULL, --/D Source net counts in 6.2-7.1 keV band --/U count
    ml_cts_err_p8 real NOT NULL, --/D 1-sigma combined counts error in 6.2-7.1 keV band --/U count
    ml_cts_lowerr_p8 real NOT NULL, --/D 1-sigma lower counts error in 6.2-7.1 keV band --/U count
    ml_cts_uperr_p8 real NOT NULL, --/D 1-sigma upper counts error in 6.2-7.1 keV band --/U 
    ml_rate_p8 real NOT NULL, --/D Source count rate in 6.2-7.1 keV band --/U count s-1
    ml_rate_err_p8 real NOT NULL, --/D 1-sigma combined count rate error in 6.2-7.1 keV band --/U count s-1
    ml_rate_lowerr_p8 real NOT NULL, --/D 1-sigma lower count rate error in 6.2-7.1 keV band --/U count s-1
    ml_rate_uperr_p8 real NOT NULL, --/D 1-sigma upper count rate error in 6.2-7.1 keV band --/U count s-1
    ml_flux_p8 real NOT NULL, --/D Source flux in 6.2-7.1 keV band --/U erg s-1 cm-2
    ml_flux_err_p8 real NOT NULL, --/D 1-sigma combined flux error in 6.2-7.1 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p8 real NOT NULL, --/D 1-sigma lower flux error in 6.2-7.1 keV band --/U erg s-1 cm-2
    ml_flux_uperr_p8 real NOT NULL, --/D 1-sigma upper flux error in 6.2-7.1 keV band --/U erg s-1 cm-2
    ml_bkg_p8 real NOT NULL, --/D Background at the source position in 6.2-7.1 keV band --/U arcmin-2
    ml_exp_p8 real NOT NULL, --/D Vignetted exposure time at the source position in 6.2-7.1 keV band --/U s
    ml_eef_p8 real NOT NULL, --/D Enclosed energy fraction in 6.2-7.1 keV band --/U 
    ape_cts_p8 int NOT NULL, --/D Total counts extracted within the aperture in 6.2-7.1 keV band --/U count
    ape_bkg_p8 real NOT NULL, --/D Background counts extracted within the aperture in 6.2-7.1 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p8 real NOT NULL, --/D Exposure map value at the given position in the 6.2-7.1 keV band --/U s
    ape_radius_p8 real NOT NULL, --/D Extraction radius in pixels (4'') in the 6.2-7.1 keV band --/U 
    ape_pois_p8 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P8) are a background fluctuation --/U pix
    det_like_p9 real NOT NULL, --/D Detection likelihood in 7.2-8.2 keV band --/U 
    ml_cts_p9 real NOT NULL, --/D Source net counts in 7.2-8.2 keV band --/U count
    ml_cts_err_p9 real NOT NULL, --/D 1-sigma combined counts error in 7.2-8.2 keV band --/U count
    ml_cts_lowerr_p9 real NOT NULL, --/D 1-sigma lower counts error in 7.2-8.2 keV band --/U count
    ml_cts_uperr_p9 real NOT NULL, --/D 1-sigma upper counts error in 7.2-8.2 keV band --/U 
    ml_rate_p9 real NOT NULL, --/D Source count rate in 7.2-8.2 keV band --/U count s-1
    ml_rate_err_p9 real NOT NULL, --/D 1-sigma combined count rate error in 7.2-8.2 keV band --/U count s-1
    ml_rate_lowerr_p9 real NOT NULL, --/D 1-sigma lower count rate error in 7.2-8.2 keV band --/U count s-1
    ml_rate_uperr_p9 real NOT NULL, --/D 1-sigma upper count rate error in 7.2-8.2 keV band --/U count s-1
    ml_flux_p9 real NOT NULL, --/D Source flux in 7.2-8.2 keV band --/U erg s-1 cm-2
    ml_flux_err_p9 real NOT NULL, --/D 1-sigma combined flux error in 7.2-8.2 keV band --/U erg s-1 cm-2
    ml_flux_lowerr_p9 real NOT NULL, --/D 1-sigma lower flux error in 7.2-8.2 keV ban --/U erg s-1 cm-2
    ml_flux_uperr_p9 real NOT NULL, --/D 1-sigma upper flux error in 7.2-8.2 keV band --/U erg s-1 cm-2
    ml_bkg_p9 real NOT NULL, --/D Background at the source position in 7.2-8.2 keV band --/U arcmin-2
    ml_exp_p9 real NOT NULL, --/D Vignetted exposure time at the source position in 7.2-8.2 keV band --/U s
    ml_eef_p9 real NOT NULL, --/D Enclosed energy fraction in 7.2-8.2 keV band --/U 
    ape_cts_p9 int NOT NULL, --/D Total counts extracted within the aperture in 7.2-8.2 keV band --/U count
    ape_bkg_p9 real NOT NULL, --/D Background counts extracted within the aperture in 7.2-8.2 keV band, excluding nearby sources using the source map --/U count
    ape_exp_p9 real NOT NULL, --/D Exposure map value at the given position in the 7.2-8.2 keV band --/U s
    ape_radius_p9 real NOT NULL, --/D Extraction radius in pixels (4'') in the 7.2-8.2 keV band --/U pix
    ape_pois_p9 real NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_P9) are a background fluctuation --/U 
    ape_cts_s int NOT NULL, --/D Total counts extracted within the aperture in 0.5-2.0 keV band --/U 
    ape_bkg_s real NOT NULL, --/D Background counts extracted within the aperture in 0.5-2.0 keV band, excluding nearby sources using the source map --/U count
    ape_exp_s real NOT NULL, --/D Exposure map value at the given position in the 0.5-2.0 keV band --/U s
    ape_pois_s float NOT NULL, --/D Poisson probability that the extracted counts (APE_CTS_S) are a background fluctuation --/U 
    flag_sp_snr smallint NOT NULL, --/D Source may lie within an overdense region near a supernova remnant --/U 
    flag_sp_bps smallint NOT NULL, --/D Source may lie within an overdense region near a bright point source --/U 
    flag_sp_scl smallint NOT NULL, --/D Source may lie within an overdense region near a stellar cluster --/U 
    flag_sp_lga smallint NOT NULL, --/D Source may lie within an overdense region near a local large galaxy --/U 
    flag_sp_gc_cons smallint NOT NULL, --/D Source may lie within an overdense region near a galaxy cluster --/U 
    flag_no_radec_err smallint NOT NULL, --/D Source contained no RADEC_ERR in the pre-processed version of the catalogue --/U 
    flag_no_ext_err bigint NOT NULL, --/D Source contained no EXT_ERR in the pre-processed version of the catalogue. Version 1.2 of the catalogue fixes a bug on this column, which had the wrong values. --/U 
    flag_no_cts_err smallint NOT NULL, --/D Source contained no CTS_ERR in the pre-processed version of the catalogue --/U 
    flag_opt smallint NOT NULL --/D Source matched within 15'' with a bright optical star, likely contaminated by optical loading --/U 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'eROSITA_CVs')
	DROP TABLE eROSITA_CVs
GO
--
EXEC spSetDefaultFileGroup 'eROSITA_CVs'
GO

CREATE TABLE eROSITA_CVs (
---------------------------------------------------------------- 
--/H Cataclysmic variables identified from screening of SDSS-V spectra based from eROSITA X-ray sources
-----------------------------------------------------------------
--/T Cataclysmic variable binaries confirmed by screening and visual inspection 
--/T of SDSS-V spectra of eROSITA eRASS1 and eRASS:3 X-ray sources, with optical 
--/T data from Gaia DR3 and X-ray data from eRASS:3 
---------------------------------------------------------------- 
    iauname varchar(23) NOT NULL, --/U  --/D IAU ID 
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID 
    detuid varchar(32) NOT NULL, --/U  --/D eRASS:3 ID 
    gaia_dr3_id bigint NOT NULL, --/U  --/D Gaia DR3 ID 
    ra_ero float NOT NULL, --/U deg --/D Right ascension in eRASS:3 
    dec_ero float NOT NULL, --/U deg --/D Declination in eRASS:3 
    ra_gaia_dr3 float NOT NULL, --/U deg --/D Right ascension in Gaia DR3 
    dec_gaia_dr3 float NOT NULL, --/U deg --/D Declination in Gaia DR3 
    ra_icrs float NOT NULL, --/U deg --/D Right ascension in ICRS 
    de_icrs float NOT NULL, --/U deg --/D Declination in ICRS 
    ero_flux real NOT NULL, --/U erg s**(-1) cm**(-2) --/D eRASS:3 flux in 0.2 - 2.3 keV band 
    ero_flux_err real NOT NULL, --/U erg s**(-1) cm**(-2) --/D eRASS:3 flux error in 0.2 - 2.3 keV band 
    gmag float NOT NULL, --/U mag --/D Gaia DR3 G-band magnitude 
    gmag_err float NOT NULL, --/U mag --/D Gaia DR3 error in G-band magnitude 
    bp_rp float NOT NULL, --/U mag --/D Gaia DR3 BP - RP magnitude 
    bp_rp_err float NOT NULL, --/U mag --/D Gaia DR3 error in BP - RP magnitude 
    distance float NOT NULL, --/U pc --/D Gaia DR3 rgeo nominal distance based on Bailer-Jones et al. (2021) 
    distance_lower float NOT NULL, --/U pc --/D Gaia DR3 rgeo lower distance based on Bailer-Jones et al. (2021) 
    distance_upper float NOT NULL, --/U pc --/D Gaia DR3 rgeo upper distance based on Bailer-Jones et al. (2021) 
    gabs float NOT NULL, --/U mag --/D Absolute magnitude based on Gmag and DISTANCE 
    log_lx float NOT NULL, --/U erg s**(-1) --/D log(Lx) 
    log_fx_fopt float NOT NULL, --/U  --/D logarithm of X-ray to flux ratio given by: log(Fx/Fopt) = log10(eRO_FLUX) + (Gmag/2.5) + 4.86 
    hr_p12 real NOT NULL, --/U  --/D Hardness ratio between the eRASS:3 0.2â€“0.5 keV and 0.5â€“1.0 keV bands 
    hr_p12_err real NOT NULL, --/U  --/D Hardness ratio error between the eRASS:3 0.2â€“0.5 keV and 0.5â€“1.0 keV bands 
    hr_p23 real NOT NULL, --/U  --/D Hardness ratio between the eRASS:3 0.5â€“1.0 keV and 1.0â€“2.0 keV bands 
    hr_p23_err real NOT NULL, --/U  --/D Hardness ratio error between the eRASS:3 0.5â€“1.0 keV and 1.0â€“2.0 keV bands 
    [period] float NOT NULL, --/U hours --/D Orbital period of system 
    cv_type varchar(8) NOT NULL, --/U  --/D Main CV type of system 
    cv_subtype varchar(11) NOT NULL, --/U  --/D Subtype of CV or alternative (less likely) main CV type 
    [references] varchar(31) NOT NULL --/U  --/D References used to obtain orbital period and/or CV type and subtype 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'fermi_blazar')
	DROP TABLE fermi_blazar
GO
--
EXEC spSetDefaultFileGroup 'fermi_blazar'
GO

CREATE TABLE fermi_blazar (
---------------------------------------------------------------- 
--/H Multi-component spectral classifications and redshifts for Fermi-LAT blazars observed in SDSS-V DR20.
-----------------------------------------------------------------
--/T Value-added catalogue (VAC) of 707 Fermi-LAT blazar candidates 
--/T cross-matched with SDSS-V DR20 BOSS spectroscopy. Each source has been 
--/T fitted with a multi-component spectral decomposition combining a flexible 
--/T dual power-law jet continuum, elliptical galaxy templates (SWIRE), and 
--/T synthetic QSO templates (Temple et al. 2021) over a logarithmic redshift 
--/T grid z=0.01--5.0. Model selection uses the corrected Akaike Information 
--/T Criterion (AICc). The catalogue provides improved spectroscopic redshifts, 
--/T best model classification, optical jet flux fractions, and power-law 
--/T continuum shape parameters for sources previously misclassified or lacking 
--/T reliable redshifts in the SDSS pipeline. A reliability flag (Z_FLAG) is 
--/T included to indicate the confidence level of each fitted redshift and 
--/T classification. 
---------------------------------------------------------------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-V unique source identifier (sdss_id) from the SDSS-V catalogue database, cross-matched to the 4FGL-DR4 Fermi source. 
    mjd bigint NOT NULL, --/U  --/D Modified Julian Date of the SDSS-V BOSS spectrum used for the multi-component spectral fitting. This is used to uniquely identify the spectrum in cases where multiple spectra exist for a single source. 
    sdss_name varchar(24) NOT NULL, --/U  --/D IAU-format SDSS designation constructed from J2000 right ascension and declination (SDSS JHHMMSS.SS+DDMMSS.S). 
    fgl_name varchar(18) NOT NULL, --/U  --/D 4FGL-DR4 source name from the fourth Fermi-LAT source catalogue data release 4 (Ballet et al. 2023). 
    fgl_class varchar(5) NOT NULL, --/U  --/D Fermi source classification from 4FGL-DR4. Blazar subclasses include bll (BL Lac), fsrq (flat-spectrum radio quasar), and bcu (blazar candidate of unknown type). 
    best_model varchar(100) NOT NULL, --/U  --/D Best-fit spectral model family selected by AICc from six families: Galaxy, QSO, Powerlaw, Powerlaw+Galaxy, Powerlaw+QSO, and Powerlaw+Lines. Powerlaw+Galaxy and pure Powerlaw sources are classified as BL Lac candidates; Powerlaw+QSO and Powerlaw+Lines as FSRQ candidates. Pure Powerlaw sources (7 in DR20) have no spectral features and their redshifts and classifications are unreliable (see Z_FLAG). 
    sdss_class varchar(6) NOT NULL, --/U  --/D Spectroscopic classification from the SDSS-V automated pipeline (GALAXY, QSO, or STAR). Many blazar sources are misclassified as STAR by the SDSS pipeline due to the featureless power-law continuum dominating the spectrum. 
    z_sdss real NOT NULL, --/U  --/D Spectroscopic redshift from the SDSS-V automated pipeline. 
    z_fit float NOT NULL, --/U  --/D Best-fit spectroscopic redshift from the multi-component decomposition, derived from the maximum a posteriori (MAP) estimate over a logarithmic redshift grid z=0.01--5.0 with local refinement within dz=0.15 of the MAP solution. Sources with Z_FLAG > 0 have poorly constrained or unreliable redshifts. 
    z_fit_err float NOT NULL, --/U  --/D 1-sigma uncertainty on Z_fit from the lmfit covariance matrix at the best-fit redshift. A small value indicates the fit is locally well-constrained but does not rule out alternative redshift solutions at other values. 
    rchi2_fit float NOT NULL, --/U  --/D Reduced chi-squared of the best-fit multi-component model, evaluated on the native BOSS wavelength grid using SpectRes resampling. Sources with rchi2_fit > 3 * rchi2_sdss are flagged as poor fits and excluded from this catalogue. 
    rchi2_sdss float NOT NULL, --/U  --/D Reduced chi-squared of the best-fit SDSS pipeline model, as reported in the SDSS-V spectroscopic catalogue. Used as a quality baseline for filtering catastrophic fit failures. 
    jet_fraction float NOT NULL, --/U  --/D Fraction of total optical flux attributed to the jet power-law component at the best-fit redshift, computed as F_jet / (F_jet + F_host), where F_host is the integrated flux of the galaxy or QSO template component. Values near 1.0 indicate a jet-dominated spectrum. For Powerlaw+Lines sources this is an upper limit as the power-law component may absorb a mixture of jet synchrotron and accretion-disc continuum emission. 
    pl_alpha float NOT NULL, --/U  --/D Power-law spectral slope parameter alpha of the jet continuum model F(lambda) proportional to (lambda/lambda_0)^(-alpha). Positive values indicate a redder (steeper) spectrum; negative values a bluer (flatter) spectrum in flux density per unit wavelength. 
    pl_delta float NOT NULL, --/U  --/D Power-law curvature parameter delta controlling the spectral transition between two regimes in the dual power-law jet model. Positive delta produces a spectrum that is flatter at shorter wavelengths and steeper at longer wavelengths. Negative delta produces the opposite. delta=0 recovers a simple single power-law. 
    snr real NOT NULL, --/U  --/D Median signal-to-noise ratio per pixel across all BOSS spectral bands as reported by the SDSS-V pipeline (SN_MEDIAN_ALL). Sources with SNR < 3 are retained in the catalogue but carry lower confidence in their redshift and jet fraction estimates (Z_FLAG=3). 
    z_flag bigint NOT NULL --/U  --/D Redshift and classification reliability flag. Values are: 0 = reliable redshift and classification; 1 = unreliable, featureless power-law spectrum with no spectral anchor for redshift determination (7 sources in DR20) â€” fitted Z_fit and Jet_Fraction values are retained but should be treaetd with caution; 2 = low-confidence redshift, Powerlaw+Galaxy source at z > 1.8 where the SDSS wavelength coverage provides no strong rest-frame features to anchor the galaxy template; 3 = low spectral quality, SNR < 3, fitted parameters carry greater uncertainty. Users are advised to apply Z_FLAG == 0 for analyses requiring reliable redshifts and classifications.
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'grav_pot_16')
	DROP TABLE grav_pot_16
GO
--
EXEC spSetDefaultFileGroup 'grav_pot_16'
GO

CREATE TABLE grav_pot_16 (
---------------------------------------------------------------- 
--/H Main orbital elements of DR20 stars using GravPot16.
-----------------------------------------------------------------
--/T Contains the median statistics of 50 ensemble of orbits for each 
--/T star, integrated over a 3 Gyr timespan. Orbits were computed in a model 
--/T configuration with bar patterns speed of 41 km/s/kpc 
--/T (<a href="https://ui.adsabs.harvard.edu/abs/2019MNRAS.488.4552S">Sanders et al. 2019</a>). 
--/T To the Galactic orbits, we adopt a solar position of R_sun = 8.178 kpc 
--/T (<a href="https://ui.adsabs.harvard.edu/abs/2019A&A...625L..10G">Gravity Collaboration et al. 2019</a>)
--/T , Z_sun = 25 pc (<a href="https://ui.adsabs.harvard.edu/abs/2008ApJ...673..864J">JuriÄ‡ 2008</a>), 
--/T and solar motion of [U_sun, V_LSR + V_sun, W_sun] = [11.10, 248.5, 7.25] km/s, 
--/T in line with <a href="https://ui.adsabs.harvard.edu/abs/2011AN....332..461B">Brunthaler et al. 2011</a> 
--/T and <a href="https://ui.adsabs.harvard.edu/abs/2020ApJ...892...39R">Reid & Brunthaler 2020</a>. 
--/T We assumed a bar angle of 20 degrees, and a bar mass of 11 billions Solar mass, 
--/T in line with FernÃ¡ndez Trincado (2017, PhD.-Thesis) and <a href="https://https://ui.adsabs.harvard.edu/abs/2020MNRAS.495.4113F">FernÃ¡ndez-Trincado et al. 2020</a>.
---------------------------------------------------------------- 
    ids int NOT NULL, --/U  --/D SDSS-5 unique identifier 
    ruwe real NOT NULL, --/U  --/D Renormalised Unit Weight Error 
    peri_c float NOT NULL, --/U kpc --/D Perigalactocentric distance computed using the central values of the observables. 
    apo_c float NOT NULL, --/U kpc --/D Apogalactocentric distance computed using the central values of the observables. 
    zmax_c float NOT NULL, --/U kpc --/D Maximum vertical excursion from the Galactic plane computed using the central values of the observables. 
    eccentricity_c float NOT NULL, --/U  --/D Orbital eccentricity computed using the central values of the observables. 
    ej_c float NOT NULL, --/U x100 km**2/s**2 --/D Orbital Jacobi constant computed using the central values of the observables. 
    emean_c float NOT NULL, --/U x100 km**2/s**2 --/D Mean Total orbital energy computed using the central values of the observables. 
    emin_c float NOT NULL, --/U x100 km**2/s**2 --/D Minimum Total orbital energy computed using the central values of the observables. 
    emax_c float NOT NULL, --/U x100 km**2/s**2 --/D Maximum Total orbital energy computed using the central values of the observables. 
    lxmin_c smallint NOT NULL, --/U x10 km/s kpc --/D Minimum x-component of the angular momentum computed using the central values of the observables. 
    lxmax_c smallint NOT NULL, --/U x10 km/s kpc --/D Maximum x-component of the angular momentum computed using the central values of the observables. 
    lymin_c smallint NOT NULL, --/U x10 km/s kpc --/D Minimum y-component of the angular momentum computed using the central values of the observables. 
    lymax_c smallint NOT NULL, --/U x10 km/s kpc --/D Maximum y-component of the angular momentum computed using the central values of the observables. 
    lzmin_c smallint NOT NULL, --/U x10 km/s kpc --/D Minimum z-component of the angular momentum computed using the central values of the observables. 
    lzmax_c smallint NOT NULL, --/U x10 km/s kpc --/D Maximum z-component of the angular momentum computed using the central values of the observables. 
    lx_mean_c smallint NOT NULL, --/U x10 km/s kpc --/D Mean x-component of the angular momentum computed using the central values of the observables. 
    ly_mean_c smallint NOT NULL, --/U x10 km/s kpc --/D Mean y-component of the angular momentum computed using the central values of the observables. 
    lz_mean_c smallint NOT NULL, --/U x10 km/s kpc --/D Mean z-component of the angular momentum computed using the central values of the observables. 
    peri_ps41 real NOT NULL, --/U kpc --/D Perigalactocentric distance computed using a Monte Carlo approach. 
    error_peri_ps41 real NOT NULL, --/U kpc --/D Error - Perigalactocentric distance computed using a Monte Carlo approach. 
    apo_ps41 real NOT NULL, --/U kpc --/D Apogalactocentric distance computed using a Monte Carlo approach. 
    error_apo_ps41 real NOT NULL, --/U kpc --/D Error - Apogalactocentric distance computed using a Monte Carlo approach. 
    zmax_ps41 real NOT NULL, --/U kpc --/D Maximum vertical excursion from the Galactic plane computed using a Monte Carlo approach. 
    error_zmax_ps41 real NOT NULL, --/U kpc --/D Error - Maximum vertical excursion from the Galactic plane computed using a Monte Carlo approach. 
    e_ps41 real NOT NULL, --/U  --/D Orbital eccentricity computed using a Monte Carlo approach. 
    error_e_ps41 real NOT NULL, --/U  --/D Error - Orbital eccentricity computed using a Monte Carlo approach. 
    ej_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Orbital Jacobi constant computed using a Monte Carlo approach. 
    error_ej_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Error - Orbital Jacobi constant computed using a Monte Carlo approach. 
    emean_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Mean Total orbital energy computed using a Monte Carlo approach. 
    error_emean_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Error - Mean Total orbital energy computed using a Monte Carlo approach. 
    emin_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Minimum Total orbital energy computed using a Monte Carlo approach. 
    error_emin_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Error - Minimum Total orbital energy computed using a Monte Carlo approach. 
    emax_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Maximum Total orbital energy using a Monte Carlo approach. 
    error_emax_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Error - Maximum Total orbital energy using a Monte Carlo approach. 
    lxmin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Minimum x-component of the angular momentum using a Monte Carlo approach. 
    error_lxmin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Minimum x-component of the angular momentum using a Monte Carlo approach. 
    lxmax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Maximum x-component of the angular momentum using a Monte Carlo approach. 
    error_lxmax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Maximum x-component of the angular momentum using a Monte Carlo approach. 
    lymin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Minimum y-component of the angular momentum using a Monte Carlo approach. 
    error_lymin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Minimum y-component of the angular momentum using a Monte Carlo approach. 
    lymax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Maximum y-component of the angular momentum using a Monte Carlo approach. 
    error_lymax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Maximum y-component of the angular momentum using a Monte Carlo approach. 
    lzmin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Minimum z-component of the angular momentum using a Monte Carlo approach. 
    error_lzmin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Minimum z-component of the angular momentum using a Monte Carlo approach. 
    lzmax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Maximum z-component of the angular momentum using a Monte Carlo approach. 
    error_lzmax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Maximum z-component of the angular momentum using a Monte Carlo approach. 
    lxmean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Mean x-component of the angular momentum computed using a Monte Carlo approach. 
    error_lxmean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Mean x-component of the angular momentum computed using a Monte Carlo approach. 
    lymean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Mean y-component of the angular momentum computed using a Monte Carlo approach. 
    error_lymean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Mean y-component of the angular momentum computed using a Monte Carlo approach. 
    lzmean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Mean z-component of the angular momentum computed using a Monte Carlo approach. 
    error_lzmean_ps41 real NOT NULL --/U x10 km/s kpc --/D Error - Mean z-component of the angular momentum computed using a Monte Carlo approach. 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'gyro_age_dwarf')
	DROP TABLE gyro_age_dwarf
GO
--
EXEC spSetDefaultFileGroup 'gyro_age_dwarf'
GO

CREATE TABLE gyro_age_dwarf (
---------------------------------------------------------------- 
--/H Gyrochronology ages for dwarf stars in MWM
-----------------------------------------------------------------
--/T Gyrochronology ages (rotation based ages) for dwarf stars determined using 
--/T GPgyro (Lu. et al. 2024) and gyro-interp (Bouma et al. 2023). GPgyro is 
--/T suitable for stars > 1.5 Gyr, and gyrointerp is suitable for stars < 4 Gyr. 
---------------------------------------------------------------- 
    source_id bigint NOT NULL, --/U --/D Gaia DR3 source ID  
    sdss_id float NOT NULL, --/U --/D SDSS-V star ID  
    prot float NOT NULL, --/U Days --/D Rotation period measurements  
    prot_survey varchar(6) NOT NULL, --/U --/D Survey that provided the rotation period  
    gyrointerp_age float NOT NULL, --/U Gyr --/D Gyrochronology age output from gyro-interp  
    gyrointerp_age_p float NOT NULL, --/U Gyr --/D +1 sigma from gyro-interp  
    gyrointerp_age_m float NOT NULL, --/U Gyr --/D -1 sigma from gyro-interp  
    gyrointerp_flag varchar(5) NOT NULL, --/U --/D outside of the application limit for gyro-interp (> 4 Gyr) if flag is set  
    gpgyro_age float NOT NULL, --/U Gyr --/D Gyrochronology age output from GPgyro  
    gpgyro_age_p float NOT NULL, --/U Gyr --/D +1 sigma from GPgyro  
    gpgyro_age_m float NOT NULL, --/U Gyr --/D -1 sigma from GPgyro  
    gpgyro_flag varchar(5) NOT NULL, --/U --/D outside of the application limit for GPgyro (< 1.5 Gyr) if flag is set  
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mdwarf_active_params')
	DROP TABLE mdwarf_active_params
GO
--
EXEC spSetDefaultFileGroup 'mdwarf_active_params'
GO

CREATE TABLE mdwarf_active_params (
---------------------------------------------------------------- 
--/H Spectral subtypes, morphology classes, H-alpha equivalent widths, and 3D Galactic space velocities for K/M dwarfs in SDSS DR20.
-----------------------------------------------------------------
--/T This VAC compares BOSS spectra of low-mass stars to a set of 536 empirical 
--/T spectral templates assembled from earlier SDSS optical spectra (Galligan & Lepine 2026, in press), 
--/T which span a broad range of effective temperatures and metallicities. 
--/T BOSS spectra are matched to their best-fit templates to assign: 
--/T (1) a spectral subtype, which range from K5.0-M8.5 with half-subtype resolution, 
--/T (2) a "morphology class", which range from 0.5 to 12.5 in half-integer steps, 12.5 in half-integer steps, 
--/T (3) H&alpha; equivalent widths, and 
--/T (4) calculated UVW velocities relative to the Sun. 
---------------------------------------------------------------- 
    sdssid int NOT NULL, --/U  --/D SDSS-V unique identifier 
    gaiadr3_source bigint NOT NULL, --/U  --/D Gaia DR3 Source ID 
    u float NOT NULL, --/U km/s --/D Velocity toward/away the Galactic center 
    v float NOT NULL, --/U km/s --/D Rotational velocity around the Galactic center 
    vmix float NOT NULL, --/U km/s --/D velocity transformation of Xmix, proxy for angular momentum (<a href="https://doi.org/10.1093/mnras/staa1987">Hunt et al. 2020</a>) 
    w float NOT NULL, --/U km/s --/D Velocity toward/away the North Galactic Pole 
    st real NOT NULL, --/U  --/D numeric spectral subtype 
    mc real NOT NULL, --/U  --/D morphology class 
    ha_ew float NOT NULL --/U Angstroms --/D H-alpha equivalent width 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mdwarf_contin_summary')
	DROP TABLE mdwarf_contin_summary
GO
--
EXEC spSetDefaultFileGroup 'mdwarf_contin_summary'
GO

CREATE TABLE mdwarf_contin_summary (
---------------------------------------------------------------- 
--/H M dwarf pseudo-continuum used to standardize BOSS spectra
-----------------------------------------------------------------
--/T M dwarf pseudo-continuum from <a href="https://ui.adsabs.harvard.edu/abs/2025AJ....170..302M/abstract">Medan, Way, et al. (2025)</a>,
--/T which can be used to standardize BOSS spectra of Mdwarfs. 
--/T When standardized, the issues in flux calibration in the optical 
--/T spectra are removed such that M dwarfs of similar stellar parameters should 
--/T not have comparable spectrum shapes and features. This VAC includes all 
--/T meta-data from mwmAllVisit, flux and ivar from the mwmVisit files, and the 
--/T computed pseudo-continuum for the subset of M dwarfs in DR20. 
---------------------------------------------------------------- 
    airmass real NOT NULL, --/U  --/D Mean airmass  
    airtemp real NOT NULL, --/U  --/D Air temperature   
    alt real NOT NULL, --/U  --/D Telescope altitude   
    apogee_max_mjd int NOT NULL, --/U  --/D Maximum MJD of APOGEE visits  
    apogee_min_mjd int NOT NULL, --/U  --/D Minimum MJD of APOGEE visits  
    az real NOT NULL, --/U  --/D Telescope azimuth   
    b real NOT NULL, --/U  --/D Galactic latitude   
    b_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic B-band (JKC)   
    b_jkc_mag_flag int NOT NULL, --/U  --/D B-band (JKC) is within valid range  
    bailer_jones_flags varchar(256) NOT NULL, --/U  --/D Bailer-Jones quality flags  
    bl_flg varchar(256) NOT NULL, --/U  --/D Number of components fit per band (JHK)  
    boss_max_mjd int NOT NULL, --/U  --/D Maximum MJD of BOSS visits  
    boss_min_mjd int NOT NULL, --/U  --/D Minimum MJD of BOSS visits  
    bp_mag real NOT NULL, --/U  --/D Gaia DR3 mean BP band magnitude   
    c_star real NOT NULL, --/U  --/D Quality parameter (see Riello et al. 2021)  
    cartid int NOT NULL, --/U  --/D Cartridge identifier  
    catalogid bigint NOT NULL, --/U  --/D Catalog identifier used to target the source  
    catalogid21 bigint NOT NULL, --/U  --/D Catalog identifier (v21; v0.0)  
    catalogid25 bigint NOT NULL, --/U  --/D Catalog identifier (v25; v0.5)  
    catalogid31 bigint NOT NULL, --/U  --/D Catalog identifier (v31; v1.0)  
    cc_flg varchar(256) NOT NULL, --/U  --/D Contamination and confusion flag  
    created varchar(256) NOT NULL, --/U  --/D Date file created  
    crossmatch_flags bigint NOT NULL, --/U  --/D Crossmatch flags  
    csf bigint NOT NULL, --/U  --/D Close source flag  
    d4_5m real NOT NULL, --/U  --/D Error on IRAC band 4.5 micron magnitude   
    dec real NOT NULL, --/U  --/D Declination   
    dewpoint real NOT NULL, --/U  --/D Dew point temperature   
    dust_a real NOT NULL, --/U  --/D 0.3mu-sized dust count   
    dust_b real NOT NULL, --/U  --/D 1.0mu-sized dust count   
    e_ebv real NOT NULL, --/U  --/D Error on E(B-V)   
    e_ebv_bayestar_2019 real NOT NULL, --/U  --/D Error on Bayestar 2019 E(B-V)   
    e_ebv_edenhofer_2023 real NOT NULL, --/U  --/D Error on <a href=""https://ui.adsabs.harvard.edu/abs/2024A%26A...685A..82E/abstract">Edenhofer et al. (2023)</a> E(B-V)   
    e_ebv_rjce_allwise real NOT NULL, --/U  --/D Error on RJCE AllWISE E(B-V)  
    e_ebv_rjce_glimpse real NOT NULL, --/U  --/D Error on RJCE GLIMPSE E(B-V)   
    e_ebv_sfd real NOT NULL, --/U  --/D Error on E(B-V) from SFD   
    e_ebv_zhang_2023 real NOT NULL, --/U  --/D Error on E(B-V) from <a href="https://ui.adsabs.harvard.edu/abs/2023ApJ...953...35G/abstract">Zhang et al. (2023)</a>  
    e_h_mag real NOT NULL, --/U  --/D Error on 2MASS H band magnitude   
    e_j_mag real NOT NULL, --/U  --/D Error on 2MASS J band magnitude   
    e_k_mag real NOT NULL, --/U  --/D Error on 2MASS K band magnitude   
    e_plx real NOT NULL, --/U  --/D Error on parallax   
    e_pmde real NOT NULL, --/U  --/D Error on proper motion in DEC   
    e_pmra real NOT NULL, --/U  --/D Error on proper motion in RA   
    e_w1_mag real NOT NULL, --/U  --/D Error on W1 magnitude  
    e_w2_mag real NOT NULL, --/U  --/D Error on W2 magnitude  
    ebv real NOT NULL, --/U  --/D E(B-V)   
    ebv_bayestar_2019 real NOT NULL, --/U  --/D E(B-V) from Bayestar 2019   
    ebv_edenhofer_2023 real NOT NULL, --/U  --/D E(B-V) from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...685A..82E/abstract">Edenhofer et al. (2023)</a>  
    ebv_flags bigint NOT NULL, --/U  --/D Flags indicating the source of E(B-V)  
    ebv_rjce_allwise real NOT NULL, --/U  --/D E(B-V) from RJCE AllWISE   
    ebv_rjce_glimpse real NOT NULL, --/U  --/D E(B-V) from RJCE GLIMPSE   
    ebv_sfd real NOT NULL, --/U  --/D E(B-V) from SFD   
    ebv_zhang_2023 real NOT NULL, --/U  --/D E(B-V) from <a href="https://ui.adsabs.harvard.edu/abs/2023ApJ...953...35G/abstract">Zhang et al. (2023)</a>  
    exptime real NOT NULL, --/U  --/D Exposure time   
    f_night_time real NOT NULL, --/U  --/D Mid obs time as fraction from sunset to sunrise  
    fiber_offset bit NOT NULL, --/U  --/D Position offset applied during observations  
    fieldid int NOT NULL, --/U  --/D Field identifier  
    filetype varchar(256) NOT NULL, --/U  --/D SDSS file type that stores this spectrum  
    g_mag real NOT NULL, --/U  --/D Gaia DR3 mean G band magnitude   
    g_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic g-band (SDSS)   
    g_sdss_mag_flag int NOT NULL, --/U  --/D g-band (SDSS) is within valid range  
    gaia_dr2_source_id bigint NOT NULL, --/U  --/D Gaia DR2 source identifier  
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 source identifier  
    gaia_e_v_rad real NOT NULL, --/U  --/D Error on Gaia radial velocity   
    gaia_v_rad real NOT NULL, --/U  --/D Gaia radial velocity   
    gri_gaia_transform_flags bigint NOT NULL, --/U  --/D Flags for provenance of ugriz photometry  
    gust_direction real NOT NULL, --/U  --/D Wind gust direction   
    gust_speed real NOT NULL, --/U  --/D Wind gust speed   
    h_mag real NOT NULL, --/U  --/D 2MASS H band magnitude   
    healpix int NOT NULL, --/U  --/D HEALPix (128 side)  
    highrej int NOT NULL, --/U  --/D Extraction: high rejection  
    humidity real NOT NULL, --/U  --/D Humidity   
    i_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic I-band (JKC)   
    i_jkc_mag_flag int NOT NULL, --/U  --/D I-band (JKC) is within valid range  
    i_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic i-band (SDSS)   
    i_sdss_mag_flag int NOT NULL, --/U  --/D i-band (SDSS) is within valid range  
    j_mag real NOT NULL, --/U  --/D 2MASS J band magnitude   
    k_mag real NOT NULL, --/U  --/D 2MASS K band magnitude   
    l real NOT NULL, --/U  --/D Galactic longitude   
    lead varchar(256) NOT NULL, --/U  --/D Lead catalog used for cross-match  
    lowrej int NOT NULL, --/U  --/D Extraction: low rejection  
    mag4_5 real NOT NULL, --/U  --/D IRAC band 4.5 micron magnitude   
    mapid int NOT NULL, --/U  --/D Mapping version of the loaded plate  
    mf4_5 bigint NOT NULL, --/U  --/D Flux calculation method flag  
    mjd int NOT NULL, --/U  --/D Modified Julian date of observation  
    modified varchar(256) NOT NULL, --/U  --/D Date file modified  
    moon_dist_mean real NOT NULL, --/U  --/D Mean sky distance to the moon   
    moon_phase_mean real NOT NULL, --/U  --/D Mean phase of the moon  
    n_apogee_visits int NOT NULL, --/U  --/D Number of APOGEE visits  
    n_associated int NOT NULL, --/U  --/D SDSS_IDs associated with this CATALOGID  
    n_boss_visits int NOT NULL, --/U  --/D Number of BOSS visits  
    n_exp int NOT NULL, --/U  --/D Number of co-added exposures  
    n_gal int NOT NULL, --/U  --/D Number of (good) galaxies in field  
    n_guide int NOT NULL, --/U  --/D Number of guider frames during integration  
    n_neighborhood int NOT NULL, --/U  --/D Sources within 3" and G_MAG < G_MAG_source + 5  
    n_std int NOT NULL, --/U  --/D Number of (good) standard stars  
    nfitpoly int NOT NULL, --/U  --/D Extraction: Number of profile parameters  
    ph_qual varchar(256) NOT NULL, --/U  --/D 2MASS photometric quality flag  
    plateid int NOT NULL, --/U  --/D Plate identifier  
    plx real NOT NULL, --/U  --/D Parallax   
    pmde real NOT NULL, --/U  --/D Proper motion in DEC   
    pmra real NOT NULL, --/U  --/D Proper motion in RA   
    preject real NOT NULL, --/U  --/D Profile area rejection threshold  
    pressure real NOT NULL, --/U  --/D Air pressure   
    proftype int NOT NULL, --/U  --/D Extraction profile: 1=Gaussian  
    psfsky int NOT NULL, --/U  --/D Order of PSF sky subtraction  
    r_hi_geo real NOT NULL, --/U  --/D 84th percentile of geometric distance   
    r_hi_photogeo real NOT NULL, --/U  --/D 84th percentile of photogeometric distance   
    r_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic R-band (JKC)   
    r_jkc_mag_flag int NOT NULL, --/U  --/D R-band (JKC) is within valid range  
    r_lo_geo real NOT NULL, --/U  --/D 16th percentile of geometric distance   
    r_lo_photogeo real NOT NULL, --/U  --/D 16th percentile of photogeometric distance   
    r_med_geo real NOT NULL, --/U  --/D Median geometric distance   
    r_med_photogeo real NOT NULL, --/U  --/D 50th percentile of photogeometric distance   
    r_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic r-band (SDSS)   
    r_sdss_mag_flag int NOT NULL, --/U  --/D r-band (SDSS) is within valid range  
    ra real NOT NULL, --/U  --/D Right ascension   
    release varchar(256) NOT NULL, --/U  --/D SDSS release  
    rms_f4_5 real NOT NULL, --/U  --/D RMS deviations from final flux   
    rp_mag real NOT NULL, --/U  --/D Gaia DR3 mean RP band magnitude   
    run2d varchar(256) NOT NULL, --/U  --/D BOSS data reduction pipeline version  
    scatpoly int NOT NULL, --/U  --/D Extraction: Order of scattered light polynomial  
    schi2max real NOT NULL, --/U  --/D Maximum \chi^2 of sky subtraction  
    schi2min real NOT NULL, --/U  --/D Minimum \chi^2 of sky subtraction  
    sdss4_apogee2_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (1/3)  
    sdss4_apogee2_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (2/3)  
    sdss4_apogee2_target3_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE2 targeting flags (3/3)  
    sdss4_apogee_extra_target_flags bigint NOT NULL, --/U  --/D SDSS4 target info (aka EXTRATARG)  
    sdss4_apogee_id varchar(256) NOT NULL, --/U  --/D SDSS-4 DR17 APOGEE identifier  
    sdss4_apogee_member_flags bigint NOT NULL, --/U  --/D SDSS4 likely cluster/galaxy member flags  
    sdss4_apogee_target1_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (1/2)  
    sdss4_apogee_target2_flags bigint NOT NULL, --/U  --/D SDSS4 APOGEE1 targeting flags (2/2)  
    sdss5_dr19_apogee_flag bit NOT NULL, --/U  --/D If target has an APOGEE spectrum in DR19  
    sdss_id bigint NOT NULL, --/U  --/D SDSS-5 unique identifier  
    seeing real NOT NULL, --/U  --/D Median seeing conditions   
    skychi2 real NOT NULL, --/U  --/D Mean \chi^2 of sky subtraction  
    slitid int NOT NULL, --/U  --/D Slit identifier  
    snr real NOT NULL, --/U  --/D Signal-to-noise ratio  
    source bigint NOT NULL, --/U  --/D Unique source primary key  
    spec_file varchar(256) NOT NULL, --/U  --/D Name of the spectrum file  
    spectrum_pk bigint NOT NULL, --/U  --/D Unique spectrum primary key  
    sqf_4_5 bigint NOT NULL, --/U  --/D Source quality flag for IRAC band 4.5 micron  
    tai_beg bigint NOT NULL, --/U  --/D MJD (TAI) at start of integrations   
    tai_end bigint NOT NULL, --/U  --/D MJD (TAI) at end of integrations   
    telescope varchar(256) NOT NULL, --/U  --/D Short telescope name  
    tic_v8_id bigint NOT NULL, --/U  --/D TESS Input Catalog (v8) identifier  
    u_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic U-band (JKC)   
    u_jkc_mag_flag int NOT NULL, --/U  --/D U-band (JKC) is within valid range  
    u_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic u-band (SDSS)   
    u_sdss_mag_flag int NOT NULL, --/U  --/D u-band (SDSS) is within valid range  
    v_jkc_mag real NOT NULL, --/U  --/D Gaia XP synthetic V-band (JKC)   
    v_jkc_mag_flag int NOT NULL, --/U  --/D V-band (JKC) is within valid range  
    version_id int NOT NULL, --/U  --/D SDSS catalog version for targeting  
    w1_dflux real NOT NULL, --/U  --/D Error on W1 flux   
    w1_flux real NOT NULL, --/U  --/D W1 flux   
    w1_frac real NOT NULL, --/U  --/D Fraction of W1 flux from this object  
    w1_mag real NOT NULL, --/U  --/D W1 magnitude  
    w1aflags bigint NOT NULL, --/U  --/D Additional flags for W1  
    w1uflags bigint NOT NULL, --/U  --/D unWISE flags for W1  
    w2_dflux real NOT NULL, --/U  --/D Error on W2 flux   
    w2_flux real NOT NULL, --/U  --/D W2 flux   
    w2_frac real NOT NULL, --/U  --/D Fraction of W2 flux from this object  
    w2_mag real NOT NULL, --/U  --/D W2 magnitude   
    w2aflags bigint NOT NULL, --/U  --/D Additional flags for W2  
    w2uflags bigint NOT NULL, --/U  --/D unWISE flags for W2  
    wind_direction real NOT NULL, --/U  --/D Wind direction   
    wind_speed real NOT NULL, --/U  --/D Wind speed   
    xcsao_e_fe_h real NOT NULL, --/U  --/D Error on [Fe/H]   
    xcsao_e_logg real NOT NULL, --/U  --/D Error on surface gravity   
    xcsao_e_teff real NOT NULL, --/U  --/D Error on stellar effective temperature   
    xcsao_e_v_rad real NOT NULL, --/U  --/D Error on radial velocity   
    xcsao_fe_h real NOT NULL, --/U  --/D [Fe/H]   
    xcsao_logg real NOT NULL, --/U  --/D Surface gravity   
    xcsao_rxc real NOT NULL, --/U  --/D Cross-correlation R-value (1979AJ.....84.1511T)  
    xcsao_teff real NOT NULL, --/U  --/D Stellar effective temperature   
    xcsao_v_rad real NOT NULL, --/U  --/D Barycentric rest frame radial velocity   
    y_ps1_mag real NOT NULL, --/U  --/D Gaia XP synthetic Y-band (PS1)   
    y_ps1_mag_flag int NOT NULL, --/U  --/D Y-band (PS1) is within valid range  
    z_sdss_mag real NOT NULL, --/U  --/D Gaia XP synthetic z-band (SDSS)   
    z_sdss_mag_flag int NOT NULL, --/U  --/D z-band (SDSS) is within valid range  
    zgr_chi2 real NOT NULL, --/U  --/D Chi-square value  
    zgr_e real NOT NULL, --/U  --/D Extinction   
    zgr_e_e real NOT NULL, --/U  --/D Error on extinction   
    zgr_e_fe_h real NOT NULL, --/U  --/D Error on [Fe/H]   
    zgr_e_logg real NOT NULL, --/U  --/D Error on surface gravity   
    zgr_e_plx real NOT NULL, --/U  --/D Error on parallax [mas] (Gaia DR3)  
    zgr_e_teff real NOT NULL, --/U  --/D Error on stellar effective temperature   
    zgr_fe_h real NOT NULL, --/U  --/D [Fe/H]   
    zgr_fe_h_confidence real NOT NULL, --/U  --/D Confidence estimate in FE_H  
    zgr_ln_prior real NOT NULL, --/U  --/D Log prior probability  
    zgr_logg real NOT NULL, --/U  --/D Surface gravity   
    zgr_logg_confidence real NOT NULL, --/U  --/D Confidence estimate in LOGG  
    zgr_plx real NOT NULL, --/U  --/D Parallax [mas] (Gaia DR3)  
    zgr_quality_flags bigint NOT NULL, --/U  --/D Quality flags  
    zgr_teff real NOT NULL, --/U  --/D Stellar effective temperature   
    zgr_teff_confidence real NOT NULL, --/U  --/D Confidence estimate in TEFF  
    zwarning_flags bigint NOT NULL, --/U  --/D BOSS DRP warning flags  
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO


--// Created from /uufs/chpc.utah.edu/common/home/sdss/dr19/vac/mwm/minesweeper/minesweeper_v1.0.0.fits
--// HDU 1 (178 columns x 8788 rows)



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'minesweeper')
	DROP TABLE minesweeper
GO
--
EXEC spSetDefaultFileGroup 'minesweeper'
GO

CREATE TABLE minesweeper (
---------------------------------------------------------------- 
--/H MINESweeper parameters for halo stars from SDSS-V MWM
--
--/T Stellar parameters for distant and metal-poor halo stars from the SDSS-V Milky Way Mapper survey, fit using the Bayesian MINESweeper code.
--/T Stellar parameters are estimated via a simultaneous fit to the spectrum, photometry, and parallax, and solutions are constrained to lie on
--/T MIST isochrones. A full description of MINESweeper is presented in Cargile et al (2020).
----------------------------------------------------------------
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
    circularity float NOT NULL, --/U  --/D normalized orbital circularity parameter 
    catalogid bigint NOT NULL, --/U  --/D SDSS catalog identification number 
    sdssid bigint NOT NULL, --/U  --/D SDSS object identifier 
    field bigint NOT NULL, --/U  --/D Field number for the observation 
    mjd bigint NOT NULL, --/U day --/D Mean modified Julian date of observations 
    obs varchar(8) NOT NULL, --/U  --/D Three-letter code identifying the observatory (APO or LCO) 
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
    vrad_ms float NOT NULL, --/U km/s --/D Radial velocity measured in the MINESweeper wavelength range (unreliable WL calibration) 
    vrad_ms_lerr float NOT NULL, --/U km/s --/D Lower error on radial velocity measured in the MINESweeper wavelength range 
    vrad_ms_uerr float NOT NULL, --/U km/s --/D Upper error on radial velocity measured in the MINESweeper wavelength range 
    vrad_ms_err float NOT NULL, --/U km/s --/D Error on radial velocity measured in the MINESweeper wavelength range 
    vrot float NOT NULL, --/U km/s --/D Projected rotational velocity - do not use for science, since the intrinsic LSF is uncertain. 
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
    vrad real NOT NULL, --/U km/s --/D Radial velocity in km/s 
    vrad_err real NOT NULL, --/U km/s --/D Uncertainty on radial velocity 
    sgr_l float NOT NULL, --/U deg --/D Sagittarius stream coordinate (longitude) 
    sgr_b float NOT NULL, --/U deg --/D Sagittarius stream coordinate (latitude) 
    in_sgr_l bit NOT NULL, --/U  --/D Flag indicating association with the Sagittarius Stream based on angular momentum 
    in_substructure bit NOT NULL, --/U  --/D Flag indicating membership in a known halo substructure 
    in_cluster bit NOT NULL, --/U  --/D Flag indicating membership in a calibration cluster 
    cluster varchar(16) NOT NULL, --/U  --/D Identifier for the cluster if membership is determined, otherwise n/a 
    kg_near bit NOT NULL, --/U  --/D Flag indicating membership in 10-30 kpc K giant target class 
    kg_far bit NOT NULL, --/U  --/D Flag indicating membership in >30 kpc K giant target class 
    xp_vmp bit NOT NULL, --/U  --/D Flag indicating membership in very metal-poor (VMP) target class based on Gaia XP 
    xp_mp bit NOT NULL, --/U  --/D Flag indicating membership in metal-poor (MP) target class based on Gaia XP 
    bb_mp bit NOT NULL, --/U  --/D Flag indicating membership in metal-poor (MP) target class based on IR colors ('best and brightest') 
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'payne4GAIN_summary')
	DROP TABLE payne4GAIN_summary
GO
--
EXEC spSetDefaultFileGroup 'payne4GAIN_summary'
GO

CREATE TABLE payne4GAIN_summary (
---------------------------------------------------------------- 
--/H Summary table of the LTE and NLTE Payne fits of red giant spectra, as well as aspcap raw values, and NLTE corrected aspcap raw values.
-----------------------------------------------------------------
--/T We trained Payne models on grids of Turbospectrum_NLTE synthetic spectra: 
--/T one in LTE and one in NLTE, using departure coefficient grids calculated in 
--/T MULTI. We chi-squared fit the APOGEE DR19 spectra that fall within our 
--/T training range (according to ASPCAP) and present the results of our fits. 
--/T We also perform a polynomial fit to the NLTE-LTE corrections, expecting 
--/T them to vary smoothly with the stellar parameters, and apply them to the 
--/T aspcap raw values. The aspcap raw values are also packaged with this VAC, 
--/T for comparison. 
---------------------------------------------------------------- 
    sdssid bigint NOT NULL, --/U  --/D SDSS-V unique source identifier 
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D GAIA DR 3 unique source identifier 
    aspcap_raw_teff real NOT NULL, --/U K --/D spectroscopic teff from ASPCAP. In ASPCAP, there is a calibration that is applied after this to better agree with photometric temperatures. 
    aspcap_raw_logg real NOT NULL, --/U log(cgs) --/D spectroscopic logg from ASPCAP. In ASPCAP, there is a calibration that is applied after this to better agree with asteroseismic loggs. 
    aspcap_raw_vmicro real NOT NULL, --/U km/s --/D spectroscopic microturbulence from ASPCAP. 
    aspcap_raw_feh real NOT NULL, --/U  --/D spectroscopic [Fe/H] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_raw_cfe real NOT NULL, --/U  --/D spectroscopic [C/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_raw_nfe real NOT NULL, --/U  --/D spectroscopic [N/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_raw_mgfe real NOT NULL, --/U  --/D spectroscopic [Mg/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_mgfe real NOT NULL, --/U  --/D ASPCAP [Mg/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_alfe real NOT NULL, --/U  --/D spectroscopic [Al/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_alfe real NOT NULL, --/U  --/D ASPCAP [Al/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_mnfe real NOT NULL, --/U  --/D spectroscopic [Mn/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_mnfe real NOT NULL, --/U  --/D ASPCAP [Mn/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_nafe real NOT NULL, --/U  --/D spectroscopic [Na/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_nafe real NOT NULL, --/U  --/D ASPCAP [Na/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_cafe real NOT NULL, --/U  --/D spectroscopic [Ca/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_cafe real NOT NULL, --/U  --/D ASPCAP [Ca/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_nife real NOT NULL, --/U  --/D spectroscopic [Ni/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_nife real NOT NULL, --/U  --/D ASPCAP [Ni/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_tife real NOT NULL, --/U  --/D spectroscopic [Ti/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_tife real NOT NULL, --/U  --/D ASPCAP [Ti/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_sife real NOT NULL, --/U  --/D spectroscopic [Si/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_sife real NOT NULL, --/U  --/D ASPCAP [Si/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_ofe real NOT NULL, --/U  --/D spectroscopic [O/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_spectrum_flags int NOT NULL, --/U bitflag --/D Data-level flags from ASPCAP 
    aspcap_result_flags int NOT NULL, --/U bitflag --/D Flags from initial (stellar parameter) fit in ASPCAP 
    aspcap_fe_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Fe/H] 
    aspcap_c_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [C/H] 
    aspcap_n_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [N/H] 
    aspcap_mg_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Mg/H] 
    aspcap_al_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Al/H] 
    aspcap_mn_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Mn/H] 
    aspcap_na_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Na/H] 
    aspcap_ca_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Ca/H] 
    aspcap_ni_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Ni/H] 
    aspcap_ti_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Ti/H] 
    aspcap_si_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Si/H] 
    aspcap_o_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [O/H] 
    p4g_lte_dof int NOT NULL, --/U  --/D Degree of freedom of the LTE payne4GAIN fit. This is the number of unmasked points minus 26 fitting parameters 
    p4g_lte_chi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN fit 
    p4g_lte_teff real NOT NULL, --/U K --/D Teff of the LTE payne4GAIN fit 
    p4g_lte_logg real NOT NULL, --/U log(cgs) --/D logg of the LTE payne4GAIN fit 
    p4g_lte_vmicro real NOT NULL, --/U km/s --/D microturbulence of the LTE payne4GAIN fit 
    p4g_lte_feh real NOT NULL, --/U  --/D [Fe/H] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_cfe real NOT NULL, --/U  --/D [C/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_nfe real NOT NULL, --/U  --/D [N/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_mgfe real NOT NULL, --/U  --/D [Mg/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_alfe real NOT NULL, --/U  --/D [Al/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_mnfe real NOT NULL, --/U  --/D [Mn/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_nafe real NOT NULL, --/U  --/D [Na/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_cafe real NOT NULL, --/U  --/D [Ca/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_nife real NOT NULL, --/U  --/D [Ni/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_tife real NOT NULL, --/U  --/D [Ti/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_sife real NOT NULL, --/U  --/D [Si/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_ofe real NOT NULL, --/U  --/D [O/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_teff_err real NOT NULL, --/U K --/D statistical error of LTE payne4GAIN Teff fit 
    p4g_lte_logg_err real NOT NULL, --/U log(cgs) --/D statistical error of LTE payne4GAIN logg fit 
    p4g_lte_vmicro_err real NOT NULL, --/U km/s --/D statistical error of LTE payne4GAIN microturbulence fit 
    p4g_lte_feh_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Fe/H] fit 
    p4g_lte_cfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [C/Fe] fit 
    p4g_lte_nfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [N/Fe] fit 
    p4g_lte_mgfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Mg/Fe] fit 
    p4g_lte_alfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Al/Fe] fit 
    p4g_lte_mnfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Mn/Fe] fit 
    p4g_lte_nafe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Na/Fe] fit 
    p4g_lte_cafe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Ca/Fe] fit 
    p4g_lte_nife_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Ni/Fe] fit 
    p4g_lte_tife_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Ti/Fe] fit 
    p4g_lte_sife_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Si/Fe] fit 
    p4g_lte_ofe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [O/Fe] fit 
    p4g_lte_cfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [C/Fe] set to the lowest value. 
    p4g_lte_nfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [N/Fe] set to the lowest value. 
    p4g_lte_mgfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Mg/Fe] set to the lowest value. 
    p4g_lte_alfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Al/Fe] set to the lowest value. 
    p4g_lte_mnfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Mn/Fe] set to the lowest value. 
    p4g_lte_nafe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Na/Fe] set to the lowest value. 
    p4g_lte_cafe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Ca/Fe] set to the lowest value. 
    p4g_lte_nife_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Ni/Fe] set to the lowest value. 
    p4g_lte_tife_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Ti/Fe] set to the lowest value. 
    p4g_lte_sife_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Si/Fe] set to the lowest value. 
    p4g_lte_ofe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [O/Fe] set to the lowest value. 
    p4g_nlte_dof int NOT NULL, --/U  --/D Degree of freedom of the NLTE payne4GAIN fit. This is the number of unmasked points minus 26 fitting parameters 
    p4g_nlte_chi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN fit 
    p4g_nlte_teff real NOT NULL, --/U K --/D Teff of the NLTE payne4GAIN fit 
    p4g_nlte_logg real NOT NULL, --/U log(cgs) --/D logg of the NLTE payne4GAIN fit 
    p4g_nlte_vmicro real NOT NULL, --/U km/s --/D microturbulence of the NLTE payne4GAIN fit 
    p4g_nlte_feh real NOT NULL, --/U  --/D [Fe/H] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_cfe real NOT NULL, --/U  --/D [C/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_nfe real NOT NULL, --/U  --/D [N/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_mgfe real NOT NULL, --/U  --/D [Mg/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_alfe real NOT NULL, --/U  --/D [Al/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_mnfe real NOT NULL, --/U  --/D [Mn/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_nafe real NOT NULL, --/U  --/D [Na/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_cafe real NOT NULL, --/U  --/D [Ca/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_nife real NOT NULL, --/U  --/D [Ni/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_tife real NOT NULL, --/U  --/D [Ti/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_sife real NOT NULL, --/U  --/D [Si/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_ofe real NOT NULL, --/U  --/D [O/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_teff_err real NOT NULL, --/U K --/D statistical error of NLTE payne4GAIN teff fit 
    p4g_nlte_logg_err real NOT NULL, --/U log(cgs) --/D statistical error of NLTE payne4GAIN logg fit 
    p4g_nlte_vmicro_err real NOT NULL, --/U km/s --/D statistical error of NLTE payne4GAIN microturbulence fit 
    p4g_nlte_feh_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Fe/H] fit 
    p4g_nlte_cfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [C/Fe] fit 
    p4g_nlte_nfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [N/Fe] fit 
    p4g_nlte_mgfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Mg/Fe] fit 
    p4g_nlte_alfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Al/Fe] fit 
    p4g_nlte_mnfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Mn/Fe] fit 
    p4g_nlte_nafe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Na/Fe] fit 
    p4g_nlte_cafe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Ca/Fe] fit 
    p4g_nlte_nife_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Ni/Fe] fit 
    p4g_nlte_tife_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Ti/Fe] fit 
    p4g_nlte_sife_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Si/Fe] fit 
    p4g_nlte_ofe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [O/Fe] fit 
    p4g_nlte_cfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [C/Fe] set to the lowest value. 
    p4g_nlte_nfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [N/Fe] set to the lowest value. 
    p4g_nlte_mgfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Mg/Fe] set to the lowest value. 
    p4g_nlte_alfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Al/Fe] set to the lowest value. 
    p4g_nlte_mnfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Mn/Fe] set to the lowest value. 
    p4g_nlte_nafe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Na/Fe] set to the lowest value. 
    p4g_nlte_cafe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Ca/Fe] set to the lowest value. 
    p4g_nlte_nife_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Ni/Fe] set to the lowest value. 
    p4g_nlte_tife_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Ti/Fe] set to the lowest value. 
    p4g_nlte_sife_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Si/Fe] set to the lowest value. 
    p4g_nlte_ofe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [O/Fe] set to the lowest value. 
    p4g_lte_teff_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of Teff grid, 0=not on edge 
    p4g_lte_logg_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of logg grid, 0=not on edge 
    p4g_lte_vt_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of vt grid, 0=not on edge 
    p4g_lte_feh_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Fe/H] grid, 0=not on edge 
    p4g_lte_cfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [C/Fe] grid, 0=not on edge 
    p4g_lte_nfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [N/Fe] grid, 0=not on edge 
    p4g_lte_mgfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Mg/Fe] grid, 0=not on edge 
    p4g_lte_alfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Al/Fe] grid, 0=not on edge 
    p4g_lte_mnfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Mn/Fe] grid, 0=not on edge 
    p4g_lte_nafe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Na/Fe] grid, 0=not on edge 
    p4g_lte_cafe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Ca/Fe] grid, 0=not on edge 
    p4g_lte_nife_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Ni/Fe] grid, 0=not on edge 
    p4g_lte_tife_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Ti/Fe] grid, 0=not on edge 
    p4g_lte_sife_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Si/Fe] grid, 0=not on edge 
    p4g_lte_ofe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [O/Fe] grid, 0=not on edge 
    p4g_nlte_teff_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of Teff grid, 0=not on edge 
    p4g_nlte_logg_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of logg grid, 0=not on edge 
    p4g_nlte_vt_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of vt grid, 0=not on edge 
    p4g_nlte_feh_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Fe/H] grid, 0=not on edge 
    p4g_nlte_cfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [C/Fe] grid, 0=not on edge 
    p4g_nlte_nfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [N/Fe] grid, 0=not on edge 
    p4g_nlte_mgfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Mg/Fe] grid, 0=not on edge 
    p4g_nlte_alfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Al/Fe] grid, 0=not on edge 
    p4g_nlte_mnfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Mn/Fe] grid, 0=not on edge 
    p4g_nlte_nafe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Na/Fe] grid, 0=not on edge 
    p4g_nlte_cafe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Ca/Fe] grid, 0=not on edge 
    p4g_nlte_nife_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Ni/Fe] grid, 0=not on edge 
    p4g_nlte_tife_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Ti/Fe] grid, 0=not on edge 
    p4g_nlte_sife_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Si/Fe] grid, 0=not on edge 
    p4g_nlte_ofe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [O/Fe] grid, 0=not on edge 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'qms_hg_h_hb_indices')
	DROP TABLE qms_hg_h_hb_indices
GO
--
EXEC spSetDefaultFileGroup 'qms_hg_h_hb_indices'
GO

CREATE TABLE qms_hg_h_hb_indices (
---------------------------------------------------------------- 
--/H This table contains the measurements of the CaII-H and Hb indices for an extended sample of quasars. Used to disentangle the influence of the host galaxy in quasar spectra.
--/T Contains the measurements of the CaII-H and Hb indices for a 
--/T more comprehensive sample (6439 quasars), selected by having 0.01 < z < 0.8, 
--/T SN_MEDIAN_ALL > 15, FIRSTCARTON containing 'bhm' in the label, and CLASS = QSO.
---------------------------------------------------------------- 
    object varchar(16) NOT NULL, --/U  --/D Object name 
    ra float NOT NULL, --/U deg --/D RA of the object 
    dec float NOT NULL, --/U deg --/D DEC of the object 
    catalogid bigint NOT NULL, --/U  --/D SDSS Catalog ID of the object 
    h_index float NOT NULL, --/U Angstrom --/D CaII-H band index 
    hb_index float NOT NULL, --/U Angstrom --/D Hb Lick index
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'qms_hg_index_diagram')
	DROP TABLE qms_hg_index_diagram
GO
--
EXEC spSetDefaultFileGroup 'qms_hg_index_diagram'
GO

CREATE TABLE qms_hg_index_diagram (
---------------------------------------------------------------- 
--/H Contains the measurements and products derived for the data sample used in <a href='https://ui.adsabs.harvard.edu/abs/2025MNRAS.543.4272N'>Negrete\net al. 2025</a>.
--/T Includes the delivered catalog comprising 28 parameters for 3082 quasars, with a single row per object. 
--/T Each object is easily identified using the RA and DEC coordinates. Details of the sample selection and
--/T performed analysis are described in <a href='https://ui.adsabs.harvard.edu/abs/2025MNRAS.543.4272N'>Negrete et al. 2025</a>.
--/T The spectral identifier (SI) is as follows: 
--/T 0.0 - No emission-line spectra; more likely a retired galaxy 
--/T 0.1 - Spectra showing strong sky-subtraction residuals 
--/T 0.2 - Sy2 objects, all at z < 0.5
--/T 1.0 - Type-1 AGN showing both Ha and Hb BCs 
--/T 1.1 - Optical spectra with z correction 
--/T 1.9 - Sy 1.9 spectra without HbBC but with HaBC
--/T -1.0 - UV spectra with incorrectly assigned z.
---------------------------------------------------------------- 
    object varchar(16) NOT NULL, --/U  --/D Object name 
    ra float NOT NULL, --/U deg --/D RA of the object 
    dec float NOT NULL, --/U deg --/D DEC of the object 
    catalogid bigint NOT NULL, --/U  --/D SDSS Catalog ID of the object 
    z_tw float NOT NULL, --/U  --/D Redshift used in This Work 
    z float NOT NULL, --/U  --/D Redshift extracted from the DR20 
    g_r float NOT NULL, --/U mag --/D g - r color 
    fcont_5100 float NOT NULL, --/U 10^-17 cm-2 erg s-1 --/D Continuum flux at 5100 AA 
    fcont_5100_err float NOT NULL, --/U 10^-17 cm-2 erg s-1 --/D Continuum flux at 5100 AA error 
    fhb_c4750 float NOT NULL, --/U  --/D Flux ratio of the Hb blue band and the continuum at 4750 AA 
    fcont_6400 float NOT NULL, --/U 10^-17 cm-2 erg s-1 --/D Continuum flux at 6400 AA 
    fblue_fcont float NOT NULL, --/U  --/D Flux ratio of the Ha blue band and the continuum at 6400 AA 
    fred_fcont float NOT NULL, --/U  --/D Flux ratio of the Ha red band and the continuum at 6400 AA 
    h_index float NOT NULL, --/U Angstrom --/D CaII-H band index 
    hb_index float NOT NULL, --/U Angstrom --/D Hb Lick index 
    si float NOT NULL, --/U  --/D Spectral Identifier of the object type 
    family bigint NOT NULL, --/U  --/D Identifier of the AGN-HG dominance AGND=1 INT=2 and HGD=3 
    rfeii float NOT NULL, --/U  --/D Flux ratio of FeII and Hb broad component 
    fwhm_1000 float NOT NULL, --/U km s-1 --/D FWHM of Hb broad component / 1000 
    pop varchar(2) NOT NULL, --/U  --/D Population designation in the Quasar Main Sequence 
    logmbh float NOT NULL, --/U log(Msun) --/D Logarithm of the Black Hole Mass 
    redd float NOT NULL, --/U  --/D Eddington ratio 
    l_bol float NOT NULL, --/U erg s-1 --/D Bolometric luminosity 
    lum_g float NOT NULL, --/U erg s-1 --/D Luminosity of the g band 
    lum_20cm float NOT NULL, --/U erg s-1 --/D Luminosity of the emission at 20 cm 
    rk float NOT NULL, --/U  --/D Modified Kellerman's ratio 
    lum_w3 float NOT NULL, --/U erg s-1 --/D Luminosity of the wise W3 band 
    w1_w2 float NOT NULL, --/U mag --/D W1-W2 Wise color 
    w2_w3 float NOT NULL, --/U mag --/D W2-W3 Wise color 
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'salvato_etal2025_dr1_ls10')
	DROP TABLE salvato_etal2025_dr1_ls10
GO
--
EXEC spSetDefaultFileGroup 'salvato_etal2025_dr1_ls10'
GO

CREATE TABLE salvato_etal2025_dr1_ls10 (
-----------------------------------------
--/H eROSITA/eRASS1 catalogue of identified counterparts using Legacy Survey DR10
--/T Identification and characterization of the counterparts to the X-ray point sources in the
--/T eROSITA/DR1 main catalogue using the Legacy Survey DR10
--/T Reference: https://ui.adsabs.harvard.edu/abs/2025arXiv250902842S/abstract
-----------------------------------------
    iauname varchar(23) NOT NULL, --/D eROSITA String containing the official IAU name of the source --/U 
    detuid varchar(32) NOT NULL, --/D eROSITA String unique detection --/U 
    skytile int NOT NULL, --/D eROSITA Sky tile ID --/U 
    id_src int NOT NULL, --/D eROSITA Source ID in each sky tile. Use SKYTILE+ID_SRC to identify t --/U 
    uid bigint NOT NULL, --/D eROSITA Integer unique detection ID. It equals CatID*10^11+SKYTILE*1 --/U 
    uid_hard bigint NOT NULL, --/D eROSITA Hard catalog UID of the source with a strong association, or --/U 
    id_cluster int NOT NULL, --/D eROSITA Group ID of simultaneously fitted sources --/U 
    ra float NOT NULL, --/D eROSITA Right ascension (ICRS), corrected --/U deg
    dec_1 float NOT NULL, --/D eROSITA Declination (ICRS), corrected --/U deg
    ra_raw float NOT NULL, --/D eROSITA Right ascension (ICRS), uncorrected --/U deg
    dec_raw float NOT NULL, --/D eROSITA Declination (ICRS), uncorrected --/U deg
    ra_lowerr real NOT NULL, --/D eROSITA 1-sigma lower error on RA --/U arcsec
    ra_uperr real NOT NULL, --/D eROSITA 1-sigma upper error on RA --/U arcsec
    dec_lowerr real NOT NULL, --/D eROSITA 1-sigma lower error on DEC --/U arcsec
    dec_uperr real NOT NULL, --/D eROSITA 1-sigma upper error on DEC --/U arcsec
    radec_err real NOT NULL, --/D eROSITA Combined positional error, raw output from PSF fitting --/U arcsec
    pos_err real NOT NULL, --/D eROSITA 1-sigma positional uncertainty --/U 
    lii float NOT NULL, --/D Galactic longitude --/U deg
    bii float NOT NULL, --/D Galactic latitude --/U deg
    elon float NOT NULL, --/D Ecliptic longitude --/U deg
    elat float NOT NULL, --/D Ecliptic latitude --/U deg
    mjd real NOT NULL, --/D Modified Julian Date of the observation of the source nearest to the --/U d
    mjd_min real NOT NULL, --/D Minimum Modified Julian Date of observations used to construct the m --/U d
    mjd_max real NOT NULL, --/D Maximum Modified Julian Date of observations used to construct the m --/U d
    ext real NOT NULL, --/D Source extent --/U arcsec
    ext_err real NOT NULL, --/D Extent error --/U arcsec
    ext_lowerr real NOT NULL, --/D 1-sigma lower error on EXT --/U arcsec
    ext_uperr real NOT NULL, --/D 1-sigma upper error on EXT --/U arcsec
    ext_like real NOT NULL, --/D Extent likelihood --/U 
    det_like_0_1 real NOT NULL, --/D Detection likelihood measured by forced PSF-fitting at 0.2-2.3 keV --/U 
    ml_cts_1 real NOT NULL, --/D Source net counts measured from count rate at 0.2-2.3 keV --/U count
    ml_cts_err_1 real NOT NULL, --/D 1 sigma counts error at 0.2-2.3 keV --/U count
    ml_cts_lowerr_1 real NOT NULL, --/D 1 sigma lower error of counts at 0.2-2.3 keV --/U count
    ml_cts_uperr_1 real NOT NULL, --/D 1 sigma upper error of counts at 0.2-2.3 keV --/U count
    ml_rate_1 real NOT NULL, --/D Source count rate measured by forced PSF-fitting; 0.2-2.3 keV --/U count s-1
    ml_rate_err_1 real NOT NULL, --/D 1 sigma count rate error at 0.2-2.3 keV --/U count s-1
    ml_rate_lowerr_1 real NOT NULL, --/D 1 sigma lower error of count rate at 0.2-2.3 keV --/U count s-1
    ml_rate_uperr_1 real NOT NULL, --/D 1 sigma upper error of count rate at 0.2-2.3 keV --/U count s-1
    ml_flux_1 real NOT NULL, --/D Source flux converted from count rate at 0.2-2.3 keV --/U erg s-1 cm-2
    ml_flux_err_1 real NOT NULL, --/D 1 sigma flux error at 0.2-2.3 keV --/U erg s-1 cm-2
    ml_flux_lowerr_1 real NOT NULL, --/D 1 sigma lower error of flux at 0.2-2.3 keV --/U erg s-1 cm-2
    ml_flux_uperr_1 real NOT NULL, --/D 1 sigma upper error of flux at 0.2-2.3 keV --/U erg s-1 cm-2
    ml_bkg_1 real NOT NULL, --/D Background at the source position at 0.2-2.3 keV --/U arcmin-2
    ml_exp_1 real NOT NULL, --/D Vignetted exposure value at 0.2-2.3 keV --/U s
    ml_eef_1 real NOT NULL, --/D Enclosed energy fraction --/U 
    ape_cts_1 int NOT NULL, --/D Total counts extracted within the aperture at 0.2-2.3 keV --/U count
    ape_bkg_1 real NOT NULL, --/D Background counts in the aperture excluding nearby sources at 0.2-2. --/U count
    ape_exp_1 real NOT NULL, --/D Vignetted exposure value at 0.2-2.3 keV --/U s
    ape_radius_1 real NOT NULL, --/D Aperture radius at 0.2-2.3 keV --/U pix
    ape_pois_1 real NOT NULL, --/D Poisson probability of being background fluctuation; at 0.2-2.3 keV --/U 
    flag_sp_snr smallint NOT NULL, --/D Source may lie within an overdense region near a supernova remnant ( --/U 
    flag_sp_bps smallint NOT NULL, --/D Source may lie within an overdense region near a bright point source --/U 
    flag_sp_scl smallint NOT NULL, --/D Source may lie within an overdense region near a stellar cluster (Ex --/U 
    flag_sp_lga smallint NOT NULL, --/D Source may lie within an overdense region near a local large galaxy --/U 
    flag_sp_gc_cons smallint NOT NULL, --/D Source may lie within an overdense region near a galaxy cluster (Exp --/U 
    flag_no_radec_err smallint NOT NULL, --/D Source contained no RADEC_ERR in the pre-processed version of the ca --/U 
    flag_no_ext_err smallint NOT NULL, --/D Source contained no EXT_ERR in the pre-processed version of the cata --/U 
    flag_no_cts_err smallint NOT NULL, --/D Source contained no CTS_ERR in the pre-processed version of the cata --/U 
    flag_opt smallint NOT NULL, --/D Source matched within 15'' with a bright optical star, likely cont --/U 
    ls10_release smallint NOT NULL, --/D LS10 Integer denoting the camera and filter set used, which will be --/U 
    ls10_brickid int NOT NULL, --/D LS10 Brick ID [1,662174] --/U 
    ls10_objid int NOT NULL, --/D Catalog object number within this brick --/U 
    ls10_fullid varchar(18) NOT NULL, --/D Unique LS10 identifier (a unique identifier has release_brickid_obj --/U 
    ero_ls10_fullid varchar(48) NOT NULL, --/D Unique identifier of X-ray source + LS10 Counterpart --/U 
    ls10_ra float NOT NULL, --/D LS10 Right Ascension --/U deg
    ls10_dec float NOT NULL, --/D LS10 Declination --/U deg
    ls10_xray_proba float NOT NULL, --/D Probability to be an X-ray emitter usibf LS10 prior --/U 
    nway_separation_ls10_ero real NOT NULL, --/D Separation between LS10 and eROSITA source --/U arcsec
    nway_ncat smallint NOT NULL, --/D 2 if source has counterpart in LS10, 1 otherwise --/U 
    nway_dist_bayesfactor real NOT NULL, --/D Logarithm of ratio between prior and posterior, from separation, pos --/U 
    nway_dist_post real NOT NULL, --/D Distance posterior probability comparing this association vs. no ass --/U 
    nway_bias_ls10_xray_proba real NOT NULL, --/D Prior Probability weighting. A value of 1 indicates no change from p --/U 
    nway_p_single real NOT NULL, --/D Same as dist_post, but weighted by the prior (see Appx. in Salvato e --/U 
    nway_p_any real NOT NULL, --/D For each entry in the X-ray catalogue, the probability that there is --/U 
    nway_p_i real NOT NULL, --/D Relative probability of the eROSITA/LS10 match (see Appx. in Salvato --/U 
    nway_match_flag smallint NOT NULL, --/D assuming ncat==2: 1 best counterpart; 2 alternative good counterpart --/U 
    ls10_type varchar(3) NOT NULL, --/D Morphological model: "PSF"=stellar, "REX"="round exponential galaxy" --/U 
    ls10_ra_ivar real NOT NULL, --/D Inverse variance of RA (no cosine term!), excluding astrometric cali --/U 1/deg^2
    ls10_dec_ivar real NOT NULL, --/D Inverse variance of DEC, excluding astrometric calibration errors --/U 1/deg^2
    ls10_dchisq_1 real NOT NULL, --/D Difference in chi^2 between successively more-complex model fits: PS (component 1) --/U 
    ls10_dchisq_2 real NOT NULL, --/D Difference in chi^2 between successively more-complex model fits: PS (component 2) --/U 
    ls10_dchisq_3 real NOT NULL, --/D Difference in chi^2 between successively more-complex model fits: PS (component 3) --/U 
    ls10_dchisq_4 real NOT NULL, --/D Difference in chi^2 between successively more-complex model fits: PS (component 4) --/U 
    ls10_dchisq_5 real NOT NULL, --/D Difference in chi^2 between successively more-complex model fits: PS (component 5) --/U 
    ls10_ebv real NOT NULL, --/D Galactic extinction E(B-V) reddening from SFD98 , used to compute th --/U mag
    ls10_flux_g real NOT NULL, --/D model flux in g --/U nanomaggy
    ls10_flux_r real NOT NULL, --/D model flux in r --/U nanomaggy
    ls10_flux_i real NOT NULL, --/D model flux in i --/U nanomaggy
    ls10_flux_z real NOT NULL, --/D model flux in z --/U nanomaggy
    ls10_flux_w1 real NOT NULL, --/D WISE model flux in W1 (AB system) --/U nanomaggy
    ls10_flux_w2 real NOT NULL, --/D WISE model flux in W2 (AB) --/U nanomaggy
    ls10_flux_w3 real NOT NULL, --/D WISE model flux in W3 (AB) --/U nanomaggy
    ls10_flux_w4 real NOT NULL, --/D WISE model flux in W4 (AB) --/U nanomaggy
    ls10_flux_ivar_g real NOT NULL, --/D Inverse variance of flux_g --/U 1/nanomaggy^2
    ls10_flux_ivar_r real NOT NULL, --/D Inverse variance of flux_r --/U 1/nanomaggy^2
    ls10_flux_ivar_i real NOT NULL, --/D Inverse variance of flux_i --/U 1/nanomaggy^2
    ls10_flux_ivar_z real NOT NULL, --/D Inverse variance of flux_z --/U 1/nanomaggy^2
    ls10_flux_ivar_w1 real NOT NULL, --/D Inverse variance of flux_W1 (AB system) --/U 1/nanomaggy^2
    ls10_flux_ivar_w2 real NOT NULL, --/D Inverse variance of flux_W2 (AB) --/U 1/nanomaggy^2
    ls10_flux_ivar_w3 real NOT NULL, --/D Inverse variance of flux_W3 (AB) --/U 1/nanomaggy^2
    ls10_flux_ivar_w4 real NOT NULL, --/D Inverse variance of flux_W4 (AB) --/U 1/nanomaggy^2
    ls10_mw_transmission_g real NOT NULL, --/D Galactic transmission in g filter in linear units [0, 1] --/U 
    ls10_mw_transmission_r real NOT NULL, --/D Galactic transmission in r filter in linear units [0, 1] --/U 
    ls10_mw_transmission_i real NOT NULL, --/D Galactic transmission in i filter in linear units [0, 1] --/U 
    ls10_mw_transmission_z real NOT NULL, --/D Galactic transmission in z filter in linear units [0, 1] --/U 
    ls10_mw_transmission_w1 real NOT NULL, --/D Galactic transmission in W1 filter in linear units [0, 1] --/U 
    ls10_mw_transmission_w2 real NOT NULL, --/D Galactic transmission in W2 filter in linear units [0, 1] --/U 
    ls10_mw_transmission_w3 real NOT NULL, --/D Galactic transmission in W3 filter in linear units [0, 1] --/U 
    ls10_mw_transmission_w4 real NOT NULL, --/D Galactic transmission in W4 filter in linear units [0, 1] --/U 
    anymask_g smallint NOT NULL, --/D Bitwise mask set if the central pixel from any image satisfies each --/U 
    anymask_r smallint NOT NULL, --/D Bitwise mask set if the central pixel from any image satisfies each --/U 
    anymask_i smallint NOT NULL, --/D Bitwise mask set if the central pixel from any image satisfies each --/U 
    anymask_z smallint NOT NULL, --/D Bitwise mask set if the central pixel from any image satisfies each --/U 
    allmask_g smallint NOT NULL, --/D Bitwise mask set if the central pixel from all images satisfy each c --/U 
    allmask_r smallint NOT NULL, --/D Bitwise mask set if the central pixel from all images satisfy each c --/U 
    allmask_i smallint NOT NULL, --/D Bitwise mask set if the central pixel from all images satisfy each c --/U 
    allmask_z smallint NOT NULL, --/D Bitwise mask set if the central pixel from all images satisfy each c --/U 
    wisemask_w1 smallint NOT NULL, --/D W1 bitmask as cataloged on the DR10 bitmasks page --/U 
    wisemask_w2 smallint NOT NULL, --/D W2 bitmask as cataloged on the DR10 bitmasks page --/U 
    psfsize_g real NOT NULL, --/D Weighted average PSF FWHM in the g band --/U arcsec
    psfsize_r real NOT NULL, --/D Weighted average PSF FWHM in the r band --/U arcsec
    psfsize_i real NOT NULL, --/D Weighted average PSF FWHM in the i band --/U arcsec
    psfsize_z real NOT NULL, --/D Weighted average PSF FWHM in the z band --/U arcsec
    psfdepth_g real NOT NULL, --/D For a 5 sigma point source detection limit in g , 5 / ( sqrt(psfdept --/U 1/nanomaggy^2
    psfdepth_r real NOT NULL, --/D For a 5 sigma point source detection limit in r , 5 / ( sqrt(psfdept --/U 1/nanomaggy^2
    psfdepth_i real NOT NULL, --/D For a 5 sigma point source detection limit in i , 5 / ( sqrt(psfdept --/U 1/nanomaggy^2
    psfdepth_z real NOT NULL, --/D For a 5 sigma point source detection limit in z , 5 / ( sqrt(psfdept --/U 1/nanomaggy^2
    galdepth_g real NOT NULL, --/D As for psfdepth_g but for a galaxy (0.45" exp, round) detection sens --/U 1/nanomaggy^2
    galdepth_r real NOT NULL, --/D As for psfdepth_r but for a galaxy (0.45" exp, round) detection sens --/U 1/nanomaggy^2
    galdepth_i real NOT NULL, --/D As for psfdepth_i but for a galaxy (0.45" exp, round) detection sens --/U 1/nanomaggy^2
    galdepth_z real NOT NULL, --/D As for psfdepth_z but for a galaxy (0.45" exp, round) detection sens --/U 1/nanomaggy^2
    psfdepth_w1 real NOT NULL, --/D As for psfdepth_g (and also on the AB system) but for WISE W1 --/U 1/nanomaggy^2
    psfdepth_w2 real NOT NULL, --/D As for psfdepth_g (and also on the AB system) but for WISE W2 --/U 1/nanomaggy^2
    shape_r real NOT NULL, --/D Half-light radius of galaxy model for galaxy type type (>0) --/U arcsec
    shape_r_ivar real NOT NULL, --/D Inverse variance of shape_r --/U 1/arcsec^2
    shape_e1 real NOT NULL, --/D Ellipticity component 1 of galaxy model for galaxy type type --/U 
    shape_e1_ivar real NOT NULL, --/D Inverse variance of shape_e1 --/U 
    shape_e2 real NOT NULL, --/D Ellipticity component 2 of galaxy model for galaxy type type --/U 
    shape_e2_ivar real NOT NULL, --/D Inverse variance of shape_e2 --/U 
    sersic real NOT NULL, --/D LS10 Power-law index for the Sersic profile model ( type="SER" ) --/U 
    sersic_ivar real NOT NULL, --/D Inverse variance of sersic --/U 
    ref_cat varchar(2) NOT NULL, --/D Reference catalog source for this star: "T2" for Tycho-2 , "GE" for --/U 
    ref_id bigint NOT NULL, --/D Reference catalog identifier for this star; Tyc1*1,000,000+Tyc2*10+T --/U 
    ref_epoch real NOT NULL, --/D Reference catalog reference epoch (eg, 2015.5 for Gaia EDR3 ) --/U 
    gaia_phot_g_mean_mag real NOT NULL, --/D Gaia EDR3 G band mag --/U mag
    gaia_phot_g_mean_flux_over_error real NOT NULL, --/D Gaia EDR3 G band signal-to-noise --/U 
    gaia_phot_bp_mean_mag real NOT NULL, --/D Gaia EDR3 BP mag --/U mag
    gaia_phot_bp_mean_flux_over_error real NOT NULL, --/D Gaia EDR3 BP signal-to-noise --/U 
    gaia_phot_rp_mean_mag real NOT NULL, --/D Gaia EDR3 RP mag --/U mag
    gaia_phot_rp_mean_flux_over_error real NOT NULL, --/D Gaia EDR3 RP signal-to-noise --/U 
    gaia_astrometric_excess_noise real NOT NULL, --/D Gaia EDR3 astrometric excess noise --/U 
    gaia_duplicated_source smallint NOT NULL, --/D Gaia EDR3 duplicated source flag --/U 
    gaia_phot_bp_rp_excess_factor real NOT NULL, --/D Gaia EDR3 BP/RP excess factor --/U 
    gaia_astrometric_sigma5d_max real NOT NULL, --/D Gaia EDR3 longest semi-major axis of the 5-d error ellipsoid --/U arcsec
    parallax real NOT NULL, --/D Reference catalog parallax --/U mas
    parallax_ivar real NOT NULL, --/D Gaia EDR3 Reference catalog inverse-variance on parallax --/U 1/mas**2
    pmra real NOT NULL, --/D Gaia EDR3 Reference catalog proper motion in the RA direction --/U mas yr-1
    pmra_ivar real NOT NULL, --/D Gaia EDR3 Reference catalog inverse-variance on pmra --/U 1/(mas/yr)**2
    pmdec real NOT NULL, --/D Gaia EDR3 Reference catalog proper motion in the Dec direction --/U mas yr-1
    pmdec_ivar real NOT NULL, --/D Gaia Reference catalog inverse-variance on pmdec --/U 1/(mas/yr)**2
    dered_mag_w1 float NOT NULL, --/D AB magnitude, Milky Way attenuation corrected, W1 band --/U mag
    dered_mag_w2 float NOT NULL, --/D AB magnitude, Milky Way attenuation corrected, W2 band --/U mag
    dered_mag_g float NOT NULL, --/D AB magnitude, Milky Way attenuation corrected, g band --/U mag
    dered_mag_r float NOT NULL, --/D AB magnitude, Milky Way attenuation corrected, r band --/U mag
    dered_mag_z float NOT NULL, --/D AB magnitude, Milky Way attenuation corrected, z band --/U mag
    softflux float NOT NULL, --/D 0.2-2.3 keV flux. Same as ML_FLUX_1 but adding 1e-16 to reduce numer --/U erg s-1 cm-2
    salvato18_w1_x_line_distance float NOT NULL, --/D distance to Salvato+18 W1 to X-ray flux separating line: W1+1.625?lo --/U 
    salvato22_zw1gr_linedistance float NOT NULL, --/D distance to Salvato+22 color separating line: z-W1 - 0.8*(g-r)+1.2=0 --/U 
    g_minus_r float NOT NULL, --/D g-r in AB --/U 
    z_minus_w1 float NOT NULL, --/D z-W1 in AB --/U 
    w1_minus_w2 float NOT NULL, --/D W1-W2 in AB --/U 
    has_salvato18_agn_colors smallint NOT NULL, --/D Salvato+18 AGN criterion (Salvato18_W1_X_linedistance>0) --/U 
    has_salvato22_agn_colors smallint NOT NULL, --/D Salvato+22 AGN criterion (Salvato22_gr_zW_linedistance>0) --/U 
    gaia_pm_snr float NOT NULL, --/D Gaia proper motion RA and DEC, each divided by error, added in quadr --/U 
    gaia_parallax_snr float NOT NULL, --/D Gaia parallax divided by error --/U 
    gaia_moving_5sigma smallint NOT NULL, --/D Gaia motion >5sigma significant in either parallax or proper motion --/U 
    main_id_simbad varchar(41) NOT NULL, --/D Simbad ID of source with a max distance of 1 arcsec from LS10 --/U 
    ra_simbad float NOT NULL, --/D Simbad Right Ascension --/U deg
    dec_simbad float NOT NULL, --/D Simbad Declination --/U deg
    simbad_known_galactic smallint NOT NULL, --/D known X-ray binary or CV in simbad within 1 arcsec of LS10 position. --/U 
    redshift_simbad float NOT NULL, --/D Redshift from Simbad (not always reliable) --/U 
    redshift_err_simbad float NOT NULL, --/D Redshift error from Simbad --/U 
    morph_type_simbad varchar(12) NOT NULL, --/D Morphological type from Simbad --/U 
    separation_ls10_simbad float NOT NULL, --/D Separation between LS10 and Simbad --/U arcsec
    is_blazar_in_simbad smallint NOT NULL, --/D It is a Blazar in Simbad (max distance of 1 arcsec from LS10 source) --/U 
    id_bzcat smallint NOT NULL, --/D ID from the Blazar catalog BZcat(2009) --/U 
    source_classification_bzcat varchar(24) NOT NULL, --/D Source Classification in BZcat --/U 
    raj2000_bzcat varchar(11) NOT NULL, --/D BZcat Right Ascension --/U hms
    decj2000_bzcat varchar(12) NOT NULL, --/D BZcat Declination --/U dms
    exgal_prob_gaia_starex float NOT NULL, --/D Probability to be Extragalactic from STAREX, using Gaia (see paper) --/U 
    exgal_prob_nogaia_starex float NOT NULL, --/D Probability to be Extragalactic from STAREX, omitting Gaia (see pape --/U 
    class_gal_exgal int NOT NULL, --/D negative values for stars, positive for extragalactic (see paper) --/U 
    class_jetted smallint NOT NULL, --/D indicator if known blazar source within 1 arcsec of LS10 position: 1 --/U 
    pgc int NOT NULL, --/D ID in PGC catalog --/U 
    hecate_objname varchar(28) NOT NULL, --/D HECATE Object name in the HyperLEDA --/U 
    hecate_ra float NOT NULL, --/D J2000 Right ascension (deg) --/U deg
    hecate_dec float NOT NULL, --/D J2000 Declination (deg) --/U deg
    hecate_r1 real NOT NULL, --/D Semi-major axis (arcmin) --/U arcmin
    hecate_r2 real NOT NULL, --/D Semi-minor axis (arcmin) --/U arcmin
    hecate_pa real NOT NULL, --/D North-to-Northeast positional angle (deg) --/U deg
    hecate smallint NOT NULL, --/D 1 if the source is associate to an HECATE object, 0 otherwise. (Expr --/U 
    nway_threshold6 float NOT NULL, --/D p_any value at the intersection between purity and completeness for --/U 
    nway_compur6 float NOT NULL, --/D Value of Purity and Completeness at the intersection point for DET_L --/U 
    nway_purity6 float NOT NULL, --/D Purity at the value of p_any for DET_LIKE_0>=6 --/U 
    nway_completeness6 float NOT NULL, --/D Completeness at the value of p_any for DET_LIKE_0>=6 --/U 
    nway_threshold7 float NOT NULL, --/D p_any value at the intersection between purity and completeness for --/U 
    nway_compur7 float NOT NULL, --/D Value of Purity and Completeness at the intersection point for DET_L --/U 
    nway_purity7 float NOT NULL, --/D Purity at the value of p_any for DET_LIKE_0>=7 --/U 
    nway_completeness7 float NOT NULL, --/D Completeness at the value of p_any for DET_LIKE_0>=7 --/U 
    nway_threshold8 float NOT NULL, --/D p_any value at the intersection between purity and completeness for --/U 
    nway_compur8 float NOT NULL, --/D Value of Purity and Completeness at the intersection point for DET_L --/U 
    nway_purity8 float NOT NULL, --/D Purity at the value of p_any for DET_LIKE_0>=8 --/U 
    nway_completeness8 float NOT NULL, --/D Completeness at the value of p_any for DET_LIKE_0>=8 --/U 
    zspec_compilation real NOT NULL, --/D Spectroscopic redshift from literature --/U 
    zspec_ref varchar(38) NOT NULL, --/D Reference for the redshift adopted --/U 
    zspec_proprietary real NOT NULL, --/D Spectroscopic redshift either from literature or proprietary --/U 
    zphot float NOT NULL, --/D Photometric redshift from CIRCLEZ (Saxena et al 2024) --/U 
    z_final float NOT NULL, --/D Spectroscopic redshift when available, otherwise photometric from CI --/U 
    zz_final float NOT NULL, --/D Expression: (!null_zspec_compilation&&zspec_proprietary>0)?zspec_com --/U 
    zphot_lower1sigma float NOT NULL, --/D 1 sigma lower photometric redshift --/U 
    zphot_lower3sigma float NOT NULL, --/D 3 sigma lower photometric redshift --/U 
    zphot_upper1sigma float NOT NULL, --/D 1 sigma upper photometric redshift --/U 
    zphot_upper3sigma float NOT NULL, --/D 1 sigma upper photometric redshift --/U 
    inallls10 smallint NOT NULL, --/D when the counterpart is in a brick where the g, r, i, z nominal dept --/U 
    inanyls10 smallint NOT NULL, --/D when the counterpart is in a brick where at least one of the g, r, i --/U 
    with_quaia smallint NOT NULL, --/D 1 when the source is in Quaia, 0 otherwise (Expression: $219==1) --/U 
    redshift_quaia float NOT NULL, --/D Redshift from Quaia --/U 
    with_gaiaqso smallint NOT NULL, --/D 1 if source is classified as QSO in Gaia; 0 otherwise (Expression: $ --/U 
    with_r90 smallint NOT NULL, --/D 1 if source is in the R90 catalog of Assef et al 2018 (Expression: --/U 
    wisea varchar(19) NOT NULL, --/D WISE ID from AllWISE (Assef et al 2018) --/U 
    raj2000 float NOT NULL, --/D WISE RA from AllWISE (Assef et al 2018) --/U deg
    dej2000 float NOT NULL, --/D WISE DEC from AllWISE (Assef et al 2018) --/U deg
    hamstar_ctp_id bigint NOT NULL, --/D Hamstar counterpart ID from GDR3 --/U 
    hamstar_ra float NOT NULL, --/D Gaia DR3 Right ascension from Hamstar --/U deg
    hamstar_dec float NOT NULL, --/D Gaia DR3 Declination from Hamstar --/U deg
    separation_hamstar_ls10 float NOT NULL, --/D Separation between Hamstar and LS10 counterpart (Expression: 3600*sk --/U arcsec
    p_stellar float NOT NULL, --/D Probability of being a star from Hamstar --/U 
    coronal smallint NOT NULL, --/D Probability to be a coronal emitter from Hamstar --/U 
    clean smallint NOT NULL, --/D Unflagged Point like X-ray source (see Figure 11 of paper) --/U 
    bestctp smallint NOT NULL, --/D Primary LS10 counterpart to clean sources --/U 
    exgal smallint NOT NULL, --/D Clean primary counterpart classified as extragalactic (class_gal_exg --/U 
    purity90pc smallint NOT NULL, --/D Clean primary counterpart classified as extragalactic with purity ab --/U 
    rosat_2rxs varchar(21) NOT NULL, --/D Corresponding ROSAT/2RXS source --/U 
    allwise varchar(19) NOT NULL --/D AllWISE counterpart to ROSAT/2RXS source --/U 
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'yso_ob_kin')
	DROP TABLE yso_ob_kin
GO
--
EXEC spSetDefaultFileGroup 'yso_ob_kin'
GO

CREATE TABLE yso_ob_kin (
---------------------------------------------------------------- 
--/H Catalogue of ~45,000 OB stars used to study the Milky Way disc kinematics.
-----------------------------------------------------------------
--/T This is a catalogue of ~45,000 OB stars accompanying the paper "The 
--/T large-scale kinematics of young stars in the Milky Way disc: first results 
--/T from SDSS-V (<a 
--/T href="https://ui.adsabs.harvard.edu/abs/2025A%26A...703A.303Z/abstract">Zari 
--/T et al., 2025</a>). The catalogue is described in detail in Section 2.2. of 
--/T <a 
--/T href="https://ui.adsabs.harvard.edu/abs/2025A%26A...703A.303Z/abstract">Zari 
--/T et al., 2025</a>. It contains Galactocentric cartesian coordinates and 
--/T radial velocities and age estimates of the sample used in the paper. 
---------------------------------------------------------------- 
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D Gaia DR3 Unique Source Identifier  
    ra float NOT NULL, --/U deg --/D right ascension  
    dec float NOT NULL, --/U deg --/D declination  
    distance float NOT NULL, --/U kpc --/D 50th percentile of photogeometric distance (<a href="https://ui.adsabs.harvard.edu/abs/2021AJ....161..147B/abstract">Bailer-Jones et al., 2021</a>)  
    pm_ra_cosdec float NOT NULL, --/U mas yr-1 --/D Proper motion in RA  
    pm_dec float NOT NULL, --/U mas yr-1 --/D Proper motion in Dec  
    radial_velocity float NOT NULL, --/U km s-1 --/D Radial velocity (computed as described in Sec. 2.3 of <a href="https://ui.adsabs.harvard.edu/abs/2025A%26A...703A.303Z/abstract">Zari et al., 2025</a>)  
    e_distance float NOT NULL, --/U kpc --/D Error on photogeometric distance  
    e_pmra float NOT NULL, --/U mas yr-1 --/D Error on proper motion in RA  
    e_pmdec float NOT NULL, --/U mas yr-1 --/D Error on proper motion in Dec  
    e_rv float NOT NULL, --/U km s-1 --/D Error on radial velocity  
    xg float NOT NULL, --/U kpc --/D Galactocentric cartesian x position component  
    yg float NOT NULL, --/U kpc --/D Galactocentric cartesian y position component  
    zg float NOT NULL, --/U kpc --/D Galactocentric cartesian z position component  
    r float NOT NULL, --/U kpc --/D Galactocentric distance  
    vr float NOT NULL, --/U km s-1 --/D Galactocentric radial velocity  
    e_vr float NOT NULL, --/U km s-1 --/D Error on Galactocentric radial velocity  
    teff float NOT NULL, --/U K --/D BossNet Effective temperature  
    e_teff float NOT NULL, --/U K --/D Error on BossNet effective temperature  
    logg float NOT NULL, --/U dex --/D BossNet surface gravity  
    e_logg float NOT NULL, --/U dex --/D Error on BossNet surface gravity  
    feh float NOT NULL, --/U dex --/D BossNet iron abundance  
    e_feh float NOT NULL, --/U dex --/D Error on BossNet iron abundance  
    median_log_age real NOT NULL, --/U log(yr) --/D 50th percentile of log-age (computed as described in Sec. 3.2 of <a href="https://ui.adsabs.harvard.edu/abs/2025A%26A...703A.303Z/abstract">Zari et al., 2025</a>)  
    lo_median_age real NOT NULL, --/U log(yr) --/D 16th percentile of log-age  
    hi_median_age real NOT NULL, --/U log(yr) --/D 84th percentile of log-age  
    htmid bigint, --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
    cx float, --/D x of the J2000 unit vector for ra+dec --/K POS_EQ_CART_X
    cy float, --/D y of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Y
    cz float --/D z of the J2000 unit vector for ra+dec --/K POS_EQ_CART_Z
)
GO



-- revert to primary file group
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[VacTables.sql]: VAC tables created'
GO


