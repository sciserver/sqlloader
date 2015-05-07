-- Patch to create Galaxy Table Products
-- Date: May 30 , 2012
-- @Deoyani Nandrekar-Heinis
--* 2012-06-18  Ani: Updated table names/schema from sas-sql.
--* 2012-06-19  Ani: Inserted comma after Error_Warning column in 
--*             emissionLinesPort.


-- Drop the tables with the old names first.

IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'stellarMassPCA')
	DROP TABLE stellarMassPCA
GO
--
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'stellarMassPhotoPassive')
	DROP TABLE stellarMassPhotoPassive
GO
--
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'stellarMassPhoto')
	DROP TABLE stellarMassPhoto
GO
--
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'emissionLines')
	DROP TABLE emissionLines
GO
--


IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'stellarMassPCAWisc')
	DROP TABLE stellarMassPCAWisc
GO
---
EXEC spSetDefaultFileGroup 'stellarMassPCAWisc'
GO
---

CREATE TABLE stellarMassPCAWisc (
-------------------------------------------------------------------------------
--/H Estimated stellar masses for BOSS galaxies using PCA technique.
--/T Stellar masses using the method of <a href="http://adsabs.harvard.edu/abs/2012MNRAS.421..314C">Chen et al. (2012).</a>
--/T These have been calculated only for the DR9 BOSS galaxy spectra.
--/T In this table, the best estimate of stellar mass is "mstellar_median".
--/T Please use the "warning" values to check for data quality:
--/T   warning = 0 : Results correspond to a best-fit PCA spectrum (no problems detected)
--/T   warning = 1 : Target redshift too small (z &lt 0.05)
--/T   warning = 2 : Target redshift too large (z &gt 0.80)
--/T   warning = 3 : READSPEC cannot get wavelength vector
--/T   warning = 4 : Available wavelengths all outside PCA coverage 
--/T   warning = 5 : Unable to project projection wavelength range
--/T   warning = 6 : Unable to select projection wavelength range
--/T   warning = 7 : Minimum chi^2 less than zero
--/T   warning = 8 : Total of log mass PDF equal to zero
--/T   warning = 9 : Total of velocity dispersion PDF equal to zero
-------------------------------------------------------------------------------
  specObjID        bigint NOT NULL, --/D Unique ID --/K ID_CATALOG
  plate            smallint NOT NULL, --/D Plate number 
  fiberID          smallint NOT NULL, --/D Fiber ID 
  mjd              int NOT NULL, --/U days --/D MJD of observation 
  ra               float NOT NULL, --/U deg  --/D Right ascension of fiber, J2000    
  dec              float NOT NULL, --/U deg  --/D Declination of fiber, J2000     
  z                real NOT NULL, --/D Redshift used (corresponds to z_noqso in specObjAll)
  zErr             real NOT NULL, --/D Error in z (corresponds to zErr_noqso in specObjAll) --/F z_err
  zNum             int NOT NULL, --/D Index of chi^2 minimum corresponding to z_noqso 
  mstellar_median  float NOT NULL, --/U dex (solar masses) --/D median (50th percentile of PDF) of log stellar mass (best estimator)
  mstellar_err     float NOT NULL, --/U dex (solar masses) --/D 1-sigma error in log stellar mass (84th minus 16th percential)
  mstellar_p2p5    float NOT NULL, --/U dex (solar masses) --/D 2.5th percentile of PDF of log stellar mass 
  mstellar_p16     float NOT NULL, --/U dex (solar masses) --/D 16th percentile of PDF of log stellar mass 
  mstellar_p84     float NOT NULL, --/U dex (solar masses) --/D 84th percentile of PDF of log stellar mass 
  mstellar_p97p5   float NOT NULL, --/U dex (solar masses) --/D 97.5th percentile of PDF of log stellar mass 
  vdisp_median     float NOT NULL, --/U km/s --/D median (50th percentile of PDF) of velocity dispersion (best estimator)
  vdisp_err        float NOT NULL, --/U km/s --/D 1-sigma error in velocity dispersion (84th minus 16th percential)
  vdisp_p2p5       float NOT NULL, --/U km/s --/D 2.5th percentile of PDF of velocity dispersion 
  vdisp_p16        float NOT NULL, --/U km/s --/D 16th percentile of PDF of velocity dispersion 
  vdisp_p84        float NOT NULL, --/U km/s --/D 84th percentile of PDF of velocity dispersion 
  vdisp_p97p5      float NOT NULL, --/U km/s --/D 97.5th percentile of PDF of velocity dispersion  
  calpha_0         real NOT NULL, --/D Coefficient for 0th eigenspectrum in fit --/F calpha 0
  calpha_1         real NOT NULL, --/D Coefficient for 1th eigenspectrum in fit --/F calpha 1
  calpha_2         real NOT NULL, --/D Coefficient for 2th eigenspectrum in fit --/F calpha 2
  calpha_3         real NOT NULL, --/D Coefficient for 3th eigenspectrum in fit --/F calpha 3
  calpha_4         real NOT NULL, --/D Coefficient for 4th eigenspectrum in fit --/F calpha 4
  calpha_5         real NOT NULL, --/D Coefficient for 5th eigenspectrum in fit --/F calpha 5
  calpha_6         real NOT NULL, --/D Coefficient for 6th eigenspectrum in fit --/F calpha 6
  calpha_norm      real NOT NULL, --/D Overall normalization for best-fit
  warning          int NOT NULL, --/D Output warnings: 0 if everything is fine. 
)
GO
--


IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'stellarMassPassivePort')
	DROP TABLE stellarMassPassivePort
GO
---
EXEC spSetDefaultFileGroup 'stellarMassPassivePort'
GO
---

CREATE TABLE stellarMassPassivePort (
-------------------------------------------------------------------------------
--/H Estimated stellar masses for BOSS galaxies using photometric method, assuming passive model.
--/T Stellar masses using the method of <a href="http://adsabs.harvard.edu/abs/2009MNRAS.394L.107M">Maraston et al. (2009).</a>
--/T These fit passive stellar evolution models to the SDSS photometry, using
--/T the known BOSS redshifts. The model is a instantaneous burst stellar population 
--/T whose age is fit for (with a minimum allowed age of 3 Gyrs). The population
--/T is 97% solar metallicity and 3% metal-poor, by mass. In this table we 
--/T assume the Kroupa IMF.
-------------------------------------------------------------------------------
  specObjID        bigint NOT NULL, --/D Unique ID --/K ID_CATALOG
  plate            smallint NOT NULL, --/D Plate number 
  fiberID          smallint NOT NULL, --/D Fiber ID 
  mjd              int NOT NULL, --/U days --/D MJD of observation 
  ra               float NOT NULL, --/U deg  --/D Right ascension of fiber, J2000    
  dec              float NOT NULL, --/U deg  --/D Declination of fiber, J2000     
  z                real NOT NULL, --/D Redshift used (corresponds to z_noqso in specObjAll)								 
  zErr             real NOT NULL, --/D Error in z (corresponds to zErr_noqso in specObjAll) --/F z_err		 
  logMass          real NOT NULL, --/U dex (solar masses) --/D Best-fit stellar mass of galaxy 
  minLogMass       real NOT NULL, --/U dex (solar masses) --/D 1-sigma minimum stellar mass (where chi-squared is within minimum + 1)
  maxLogMass       real NOT NULL, --/U dex (solar masses) --/D 1-sigma maximum stellar mass (where chi-squared is within minimum + 1)
  medianPDF        real NOT NULL, --/U dex (solar masses) --/D Median value in mass PDF (log base 10 in solar masses)							 
  PDF16            real NOT NULL, --/U dex (solar masses) --/D 16% lower limit on stellar mass in PDF 
  PDF84            real NOT NULL, --/U dex (solar masses) --/D 84% upper limit on stellar mass in PDF 
  peakPDF          real NOT NULL, --/U dex (solar masses) --/D Peak of PDF (log base 10 in solar masses)                             
  logMass_noMassLoss          real NOT NULL, --/U dex (solar masses) --/D Best-fit stellar mass of galaxy (log base 10 in solar masses)			 
  minLogMass_noMassLoss       real NOT NULL, --/U dex (solar masses) --/D 1-sigma minimum stellar mass (where chi-squared is within minimum + 1), not accounting for mass loss 
  maxLogMass_noMassLoss       real NOT NULL, --/U dex (solar masses) --/D 1-sigma maximum stellar mass (where chi-squared is within minimum + 1), not accounting for mass loss 
  medianPDF_noMassLoss        real NOT NULL, --/U dex (solar masses) --/D Median value in mass PDF, not accounting for mass loss (log base 10 in solar masses)							 
  PDF16_noMassLoss            real NOT NULL, --/U dex (solar masses) --/D 16% lower limit on stellar mass in PDF, not accounting for mass loss 
  PDF84_noMassLoss            real NOT NULL, --/U dex (solar masses) --/D 84% upper limit on stellar mass in PDF, not accounting for mass loss 
  peakPDF_noMassLoss          real NOT NULL, --/U dex (solar masses) --/D Peak of PDF, not accounting for mass loss (log base 10 in solar masses)                           
  reducedChi2                 real NOT NULL, --/D Reduced chi squared of best fit
  age                         real NOT NULL, --/U Gyrs --/D Age of best fit
  minAge                      real NOT NULL, --/U Gyrs --/D 1-sigma minimum age (where chi-squared is within minimum + 1) 
  maxAge                      real NOT NULL, --/U Gyrs --/D 1-sigma maximum age (where chi-squared is within minimum + 1) 
  SFR                         real NOT NULL, --/U solar masses per year --/D Star-formation rate of best fit
  minSFR                      real NOT NULL, --/U solar masses per year --/D 1-sigma minimum star-formation rate of best fit (where chi-squared is within minimum + 1)
  maxSFR                      real NOT NULL, --/U solar masses per year --/D 1-sigma maximum star-formation rate of best fit (where chi-squared is within minimum + 1)
  absMagK                     real NOT NULL, --/D Absolute magnitude in K inferred from model
  SFH                         varchar(32) NOT NULL, --/D Star-formation history model used 
  Metallicity                 varchar(32) NOT NULL, --/D Metallicity of best fit template (0.004, 0.01, 0.02, 0.04, or "composite")
  reddeninglaw                smallint NOT NULL, --/D ID of best fit reddening law (0 = no reddening)
  nFilter                     smallint NOT NULL, --/D Number of filters used in the fit (default is 5 for ugriz)
)
GO
--


IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'stellarMassStarformingPort')
	DROP TABLE stellarMassStarformingPort
GO
---
EXEC spSetDefaultFileGroup 'stellarMassStarformingPort'
GO
---
CREATE TABLE stellarMassStarformingPort (
-------------------------------------------------------------------------------
--/H Estimated stellar masses for BOSS galaxies using photometric method, assuming a star-forming model.
--/T Stellar masses using the method of <a href="http://adsabs.harvard.edu/abs/2009MNRAS.394L.107M">Maraston et al. (2006).</a>
--/T These fit stellar evolution models to the SDSS photometry, using
--/T the known BOSS redshifts. The star-formation model uses a
--/T metallicity (specified in the "metallicity" column) and one of three
--/T star-formation histories: constant, truncated, and exponentially
--/T declining ("tau"). The type, and relevant time scale, are given in the "SFH"
--/T column. The "age" listed gives the start time for the onset of
--/t star-formation in each model. In this table we assume the Kroupa IMF.
-------------------------------------------------------------------------------
  specObjID        bigint NOT NULL, --/D Unique ID --/K ID_CATALOG
  plate            smallint NOT NULL, --/D Plate number 
  fiberID          smallint NOT NULL, --/D Fiber ID 
  mjd              int NOT NULL, --/U days --/D MJD of observation 
  ra               float NOT NULL, --/U deg  --/D Right ascension of fiber, J2000    
  dec              float NOT NULL, --/U deg  --/D Declination of fiber, J2000     
  z                real NOT NULL, --/D Redshift used (corresponds to z_noqso in specObjAll)								 
  zErr             real NOT NULL, --/D Error in z (corresponds to zErr_noqso in specObjAll) --/F z_err		 
  logMass          real NOT NULL, --/U dex (solar masses) --/D Best-fit stellar mass of galaxy 
  minLogMass       real NOT NULL, --/U dex (solar masses) --/D 1-sigma minimum stellar mass (where chi-squared is within minimum + 1)
  maxLogMass       real NOT NULL, --/U dex (solar masses) --/D 1-sigma maximum stellar mass (where chi-squared is within minimum + 1)
  medianPDF        real NOT NULL, --/U dex (solar masses) --/D Median value in mass PDF (log base 10 in solar masses)							 
  PDF16            real NOT NULL, --/U dex (solar masses) --/D 16% lower limit on stellar mass in PDF 
  PDF84            real NOT NULL, --/U dex (solar masses) --/D 84% upper limit on stellar mass in PDF 
  peakPDF          real NOT NULL, --/U dex (solar masses) --/D Peak of PDF (log base 10 in solar masses)                             
  logMass_noMassLoss          real NOT NULL, --/U dex (solar masses) --/D Best-fit stellar mass of galaxy (log base 10 in solar masses)			 
  minLogMass_noMassLoss       real NOT NULL, --/U dex (solar masses) --/D 1-sigma minimum stellar mass (where chi-squared is within minimum + 1), not accounting for mass loss 
  maxLogMass_noMassLoss       real NOT NULL, --/U dex (solar masses) --/D 1-sigma maximum stellar mass (where chi-squared is within minimum + 1), not accounting for mass loss 
  medianPDF_noMassLoss        real NOT NULL, --/U dex (solar masses) --/D Median value in mass PDF, not accounting for mass loss (log base 10 in solar masses)							 
  PDF16_noMassLoss            real NOT NULL, --/U dex (solar masses) --/D 16% lower limit on stellar mass in PDF, not accounting for mass loss 
  PDF84_noMassLoss            real NOT NULL, --/U dex (solar masses) --/D 84% upper limit on stellar mass in PDF, not accounting for mass loss 
  peakPDF_noMassLoss          real NOT NULL, --/U dex (solar masses) --/D Peak of PDF, not accounting for mass loss (log base 10 in solar masses)                           
  reducedChi2                 real NOT NULL, --/D Reduced chi squared of best fit
  age                         real NOT NULL, --/U Gyrs --/D Age of best fit
  minAge                      real NOT NULL, --/U Gyrs --/D 1-sigma minimum age (where chi-squared is within minimum + 1) 
  maxAge                      real NOT NULL, --/U Gyrs --/D 1-sigma maximum age (where chi-squared is within minimum + 1) 
  SFR                         real NOT NULL, --/U solar masses per year --/D Star-formation rate of best fit
  minSFR                      real NOT NULL, --/U solar masses per year --/D 1-sigma minimum star-formation rate of best fit (where chi-squared is within minimum + 1)
  maxSFR                      real NOT NULL, --/U solar masses per year --/D 1-sigma maximum star-formation rate of best fit (where chi-squared is within minimum + 1)
  absMagK                     real NOT NULL, --/D Absolute magnitude in K inferred from model
  SFH                         varchar(32) NOT NULL, --/D Star-formation history model used ("const" or "tau=X" or "trunc=X", where X is the exponential decline rate, or the time until truncation of the model)
  Metallicity                 varchar(32) NOT NULL, --/D Metallicity of best fit template (0.004, 0.01, 0.02, 0.04, or "composite")
  reddeninglaw                smallint NOT NULL, --/D ID of best fit reddening law (0 = no reddening)
  nFilter                     smallint NOT NULL, --/D Number of filters used in the fit (default is 5 for ugriz)
)
GO
--



IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'emissionLinesPort')
	DROP TABLE emissionLinesPort
GO
---
EXEC spSetDefaultFileGroup 'emissionLinesPort'
GO
---

CREATE TABLE emissionLinesPort (
-------------------------------------------------------------------------------
--/H Emission line kinematics results for BOSS galaxies using GANDALF
--/T We fit BOSS galaxies using an adaptation of the publicly available Gas AND Absorption 
--/T Line Fitting (GANDALF, <a href="http://adsabs.harvard.edu/abs/2006MNRAS.366.1151S">Sarzi et al. 2006</a>) 
--/T and penalised PiXel Fitting (pPXF, <a href="http://adsabs.harvard.edu/abs/2004PASP..116..138C">Cappellari & Emsellem 2004</a>).
--/T Stellar population models for the continuum are from of <a href="http://adsabs.harvard.edu/abs/2011MNRAS.418.2785M">Maraston & Strömbäck (2011)</a> and 
--/T <a href="http://adsabs.harvard.edu/abs/2011MNRAS.412.2183T">Thomas, Maraston & Johansson (2011)</a>.
-------------------------------------------------------------------------------
  specObjID        bigint NOT NULL, --/D Unique ID --/K ID_CATALOG
  plate            smallint NOT NULL, --/D Plate number 
  fiberID          smallint NOT NULL, --/D Fiber ID 
  mjd              int NOT NULL, --/U days --/D MJD of observation 
  ra               float NOT NULL, --/U deg  --/D Right ascension of fiber, J2000    
  dec              float NOT NULL, --/U deg  --/D Declination of fiber, J2000     
  z                real NOT NULL, --/D Redshift used (corresponds to z_noqso in specObjAll)								 
  zErr             real NOT NULL, --/D Error in z (corresponds to zErr_noqso in specObjAll) --/F z_err		 
  zNum             int NOT NULL, --/D Index of chi^2 minimum corresponding to z_noqso 
  velStars         real NOT NULL, --/U km/s --/D stellar velocity --/F vel_stars
  redshift         real NOT NULL, --/D GANDALF-corrected redshift
  sigmaStars       real NOT NULL, --/U km/s --/D Stellar velocity dispersion --/F sigma_stars
  sigmaStarsErr    real NOT NULL, --/U km/s --/D Error on measurement of stellar velocity dispersion --/F sigma_stars_err
  chisq            real NOT NULL, --/D chi-squared of best-fit template
  bpt              varchar(32) NOT NULL, --/D Classification from Kauffmann et al. (2003), Kewley et al. (2001) and Schawinski et al. (2007) for objects with the emission lines H&beta;, [OIII], H&alpha;, [NII] available with A/N > 1.5. Possible values: "BLANK" (if emission lines not available), "Star Forming", "Seyfert", "LINER", "Seyfert/LINER", "Composite"
  ebmv             real NOT NULL, --/U mag --/D E(B-V) for internal reddening estimated from emission lines
  ebmv_err         real NOT NULL, --/U mag --/D Error in E(B-V)for internal reddening estimated from emission lines --/F ebmv_err
  Error_Warning    tinyint NOT NULL, --/D Set to 1 if error calculation failed (errors all set to zero in that case); otherwise, set to 0
  V_HeII_3203 real NOT NULL, --/U km/s --/D Velocity of emission line HeII 3203 --/F v 0
  V_HeII_3203_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line HeII 3203 --/F v_err 0
  Sigma_HeII_3203 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line HeII 3203 --/F sig 0
  Sigma_HeII_3203_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line HeII 3203 --/F sig_err 0
  Amplitude_HeII_3203 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line HeII 3203 --/F amplitude 0
  Amplitude_HeII_3203_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line HeII 3203 --/F amplitude_err 0
  Flux_HeII_3203 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line HeII 3203 --/F flux 0
  Flux_HeII_3203_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line HeII 3203 --/F flux_err 0
  EW_HeII_3203 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line HeII 3203 --/F ew 0
  EW_HeII_3203_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line HeII 3203 --/F ew_err 0
  Flux_Cont_HeII_3203 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line HeII 3203 --/F flux_cont 0
  Flux_Cont_HeII_3203_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line HeII 3203 --/F flux_cont_err 0
  Fit_Warning_HeII_3203 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 0
  AoN_HeII_3203 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line HeII 3203 --/F aon 0
  V_NeV_3345 real NOT NULL, --/U km/s --/D Velocity of emission line [NeV] 3345 --/F v 1
  V_NeV_3345_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [NeV] 3345 --/F v_err 1
  Sigma_NeV_3345 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [NeV] 3345 --/F sig 1
  Sigma_NeV_3345_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [NeV] 3345 --/F sig_err 1
  Amplitude_NeV_3345 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [NeV] 3345 --/F amplitude 1
  Amplitude_NeV_3345_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [NeV] 3345 --/F amplitude_err 1
  Flux_NeV_3345 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [NeV] 3345 --/F flux 1
  Flux_NeV_3345_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [NeV] 3345 --/F flux_err 1
  EW_NeV_3345 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [NeV] 3345 --/F ew 1
  EW_NeV_3345_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [NeV] 3345 --/F ew_err 1
  Flux_Cont_NeV_3345 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [NeV] 3345 --/F flux_cont 1
  Flux_Cont_NeV_3345_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [NeV] 3345 --/F flux_cont_err 1
  Fit_Warning_NeV_3345 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 1
  AoN_NeV_3345 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [NeV] 3345 --/F aon 1
  V_NeV_3425 real NOT NULL, --/U km/s --/D Velocity of emission line [NeV] 3425 --/F v 2
  V_NeV_3425_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [NeV] 3425 --/F v_err 2
  Sigma_NeV_3425 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [NeV] 3425 --/F sig 2
  Sigma_NeV_3425_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [NeV] 3425 --/F sig_err 2
  Amplitude_NeV_3425 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [NeV] 3425 --/F amplitude 2
  Amplitude_NeV_3425_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [NeV] 3425 --/F amplitude_err 2
  Flux_NeV_3425 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [NeV] 3425 --/F flux 2
  Flux_NeV_3425_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [NeV] 3425 --/F flux_err 2
  EW_NeV_3425 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [NeV] 3425 --/F ew 2
  EW_NeV_3425_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [NeV] 3425 --/F ew_err 2
  Flux_Cont_NeV_3425 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [NeV] 3425 --/F flux_cont 2
  Flux_Cont_NeV_3425_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [NeV] 3425 --/F flux_cont_err 2
  Fit_Warning_NeV_3425 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 2
  AoN_NeV_3425 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [NeV] 3425 --/F aon 2
  V_OII_3726 real NOT NULL, --/U km/s --/D Velocity of emission line [OII] 3726 --/F v 3
  V_OII_3726_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [OII] 3726 --/F v_err 3
  Sigma_OII_3726 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [OII] 3726 --/F sig 3
  Sigma_OII_3726_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [OII] 3726 --/F sig_err 3
  Amplitude_OII_3726 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [OII] 3726 --/F amplitude 3
  Amplitude_OII_3726_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [OII] 3726 --/F amplitude_err 3
  Flux_OII_3726 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [OII] 3726 --/F flux 3
  Flux_OII_3726_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [OII] 3726 --/F flux_err 3
  EW_OII_3726 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [OII] 3726 --/F ew 3
  EW_OII_3726_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [OII] 3726 --/F ew_err 3
  Flux_Cont_OII_3726 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [OII] 3726 --/F flux_cont 3
  Flux_Cont_OII_3726_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [OII] 3726 --/F flux_cont_err 3
  Fit_Warning_OII_3726 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 3
  AoN_OII_3726 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [OII] 3726 --/F aon 3
  V_OII_3728 real NOT NULL, --/U km/s --/D Velocity of emission line [OII] 3728 --/F v 4
  V_OII_3728_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [OII] 3728 --/F v_err 4
  Sigma_OII_3728 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [OII] 3728 --/F sig 4
  Sigma_OII_3728_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [OII] 3728 --/F sig_err 4
  Amplitude_OII_3728 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [OII] 3728 --/F amplitude 4
  Amplitude_OII_3728_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [OII] 3728 --/F amplitude_err 4
  Flux_OII_3728 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [OII] 3728 --/F flux 4
  Flux_OII_3728_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [OII] 3728 --/F flux_err 4
  EW_OII_3728 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [OII] 3728 --/F ew 4
  EW_OII_3728_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [OII] 3728 --/F ew_err 4
  Flux_Cont_OII_3728 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [OII] 3728 --/F flux_cont 4
  Flux_Cont_OII_3728_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [OII] 3728 --/F flux_cont_err 4
  Fit_Warning_OII_3728 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 4
  AoN_OII_3728 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [OII] 3728 --/F aon 4
  V_NeIII_3868 real NOT NULL, --/U km/s --/D Velocity of emission line [NeIII] 3868 --/F v 5
  V_NeIII_3868_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [NeIII] 3868 --/F v_err 5
  Sigma_NeIII_3868 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [NeIII] 3868 --/F sig 5
  Sigma_NeIII_3868_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [NeIII] 3868 --/F sig_err 5
  Amplitude_NeIII_3868 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [NeIII] 3868 --/F amplitude 5
  Amplitude_NeIII_3868_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [NeIII] 3868 --/F amplitude_err 5
  Flux_NeIII_3868 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [NeIII] 3868 --/F flux 5
  Flux_NeIII_3868_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [NeIII] 3868 --/F flux_err 5
  EW_NeIII_3868 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [NeIII] 3868 --/F ew 5
  EW_NeIII_3868_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [NeIII] 3868 --/F ew_err 5
  Flux_Cont_NeIII_3868 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [NeIII] 3868 --/F flux_cont 5
  Flux_Cont_NeIII_3868_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [NeIII] 3868 --/F flux_cont_err 5
  Fit_Warning_NeIII_3868 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 5
  AoN_NeIII_3868 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [NeIII] 3868 --/F aon 5
  V_NeIII_3967 real NOT NULL, --/U km/s --/D Velocity of emission line [NeIII] 3967 --/F v 6
  V_NeIII_3967_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [NeIII] 3967 --/F v_err 6
  Sigma_NeIII_3967 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [NeIII] 3967 --/F sig 6
  Sigma_NeIII_3967_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [NeIII] 3967 --/F sig_err 6
  Amplitude_NeIII_3967 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [NeIII] 3967 --/F amplitude 6
  Amplitude_NeIII_3967_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [NeIII] 3967 --/F amplitude_err 6
  Flux_NeIII_3967 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [NeIII] 3967 --/F flux 6
  Flux_NeIII_3967_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [NeIII] 3967 --/F flux_err 6
  EW_NeIII_3967 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [NeIII] 3967 --/F ew 6
  EW_NeIII_3967_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [NeIII] 3967 --/F ew_err 6
  Flux_Cont_NeIII_3967 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [NeIII] 3967 --/F flux_cont 6
  Flux_Cont_NeIII_3967_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [NeIII] 3967 --/F flux_cont_err 6
  Fit_Warning_NeIII_3967 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 6
  AoN_NeIII_3967 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [NeIII] 3967 --/F aon 6
  V_H5_3889 real NOT NULL, --/U km/s --/D Velocity of emission line H5 3889 --/F v 7
  V_H5_3889_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line H5 3889 --/F v_err 7
  Sigma_H5_3889 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line H5 3889 --/F sig 7
  Sigma_H5_3889_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line H5 3889 --/F sig_err 7
  Amplitude_H5_3889 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line H5 3889 --/F amplitude 7
  Amplitude_H5_3889_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line H5 3889 --/F amplitude_err 7
  Flux_H5_3889 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line H5 3889 --/F flux 7
  Flux_H5_3889_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line H5 3889 --/F flux_err 7
  EW_H5_3889 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line H5 3889 --/F ew 7
  EW_H5_3889_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line H5 3889 --/F ew_err 7
  Flux_Cont_H5_3889 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line H5 3889 --/F flux_cont 7
  Flux_Cont_H5_3889_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line H5 3889 --/F flux_cont_err 7
  Fit_Warning_H5_3889 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 7
  AoN_H5_3889 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line H5 3889 --/F aon 7
  V_He_3970 real NOT NULL, --/U km/s --/D Velocity of emission line He 3970 --/F v 8
  V_He_3970_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line He 3970 --/F v_err 8
  Sigma_He_3970 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line He 3970 --/F sig 8
  Sigma_He_3970_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line He 3970 --/F sig_err 8
  Amplitude_He_3970 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line He 3970 --/F amplitude 8
  Amplitude_He_3970_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line He 3970 --/F amplitude_err 8
  Flux_He_3970 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line He 3970 --/F flux 8
  Flux_He_3970_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line He 3970 --/F flux_err 8
  EW_He_3970 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line He 3970 --/F ew 8
  EW_He_3970_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line He 3970 --/F ew_err 8
  Flux_Cont_He_3970 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line He 3970 --/F flux_cont 8
  Flux_Cont_He_3970_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line He 3970 --/F flux_cont_err 8
  Fit_Warning_He_3970 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 8
  AoN_He_3970 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line He 3970 --/F aon 8
  V_Hd_4101 real NOT NULL, --/U km/s --/D Velocity of emission line Hd 4101 --/F v 9
  V_Hd_4101_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line Hd 4101 --/F v_err 9
  Sigma_Hd_4101 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line Hd 4101 --/F sig 9
  Sigma_Hd_4101_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line Hd 4101 --/F sig_err 9
  Amplitude_Hd_4101 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line Hd 4101 --/F amplitude 9
  Amplitude_Hd_4101_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line Hd 4101 --/F amplitude_err 9
  Flux_Hd_4101 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line Hd 4101 --/F flux 9
  Flux_Hd_4101_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line Hd 4101 --/F flux_err 9
  EW_Hd_4101 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line Hd 4101 --/F ew 9
  EW_Hd_4101_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line Hd 4101 --/F ew_err 9
  Flux_Cont_Hd_4101 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line Hd 4101 --/F flux_cont 9
  Flux_Cont_Hd_4101_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line Hd 4101 --/F flux_cont_err 9
  Fit_Warning_Hd_4101 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 9
  AoN_Hd_4101 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line Hd 4101 --/F aon 9
  V_Hg_4340 real NOT NULL, --/U km/s --/D Velocity of emission line Hg 4340 --/F v 10
  V_Hg_4340_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line Hg 4340 --/F v_err 10
  Sigma_Hg_4340 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line Hg 4340 --/F sig 10
  Sigma_Hg_4340_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line Hg 4340 --/F sig_err 10
  Amplitude_Hg_4340 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line Hg 4340 --/F amplitude 10
  Amplitude_Hg_4340_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line Hg 4340 --/F amplitude_err 10
  Flux_Hg_4340 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line Hg 4340 --/F flux 10
  Flux_Hg_4340_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line Hg 4340 --/F flux_err 10
  EW_Hg_4340 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line Hg 4340 --/F ew 10
  EW_Hg_4340_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line Hg 4340 --/F ew_err 10
  Flux_Cont_Hg_4340 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line Hg 4340 --/F flux_cont 10
  Flux_Cont_Hg_4340_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line Hg 4340 --/F flux_cont_err 10
  Fit_Warning_Hg_4340 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 10
  AoN_Hg_4340 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line Hg 4340 --/F aon 10
  V_OIII_4363 real NOT NULL, --/U km/s --/D Velocity of emission line [OIII] 4363 --/F v 11
  V_OIII_4363_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [OIII] 4363 --/F v_err 11
  Sigma_OIII_4363 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [OIII] 4363 --/F sig 11
  Sigma_OIII_4363_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [OIII] 4363 --/F sig_err 11
  Amplitude_OIII_4363 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [OIII] 4363 --/F amplitude 11
  Amplitude_OIII_4363_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [OIII] 4363 --/F amplitude_err 11
  Flux_OIII_4363 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [OIII] 4363 --/F flux 11
  Flux_OIII_4363_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [OIII] 4363 --/F flux_err 11
  EW_OIII_4363 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [OIII] 4363 --/F ew 11
  EW_OIII_4363_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [OIII] 4363 --/F ew_err 11
  Flux_Cont_OIII_4363 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [OIII] 4363 --/F flux_cont 11
  Flux_Cont_OIII_4363_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [OIII] 4363 --/F flux_cont_err 11
  Fit_Warning_OIII_4363 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 11
  AoN_OIII_4363 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [OIII] 4363 --/F aon 11
  V_HeII_4685 real NOT NULL, --/U km/s --/D Velocity of emission line HeII 4685 --/F v 12
  V_HeII_4685_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line HeII 4685 --/F v_err 12
  Sigma_HeII_4685 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line HeII 4685 --/F sig 12
  Sigma_HeII_4685_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line HeII 4685 --/F sig_err 12
  Amplitude_HeII_4685 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line HeII 4685 --/F amplitude 12
  Amplitude_HeII_4685_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line HeII 4685 --/F amplitude_err 12
  Flux_HeII_4685 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line HeII 4685 --/F flux 12
  Flux_HeII_4685_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line HeII 4685 --/F flux_err 12
  EW_HeII_4685 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line HeII 4685 --/F ew 12
  EW_HeII_4685_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line HeII 4685 --/F ew_err 12
  Flux_Cont_HeII_4685 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line HeII 4685 --/F flux_cont 12
  Flux_Cont_HeII_4685_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line HeII 4685 --/F flux_cont_err 12
  Fit_Warning_HeII_4685 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 12
  AoN_HeII_4685 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line HeII 4685 --/F aon 12
  V_ArIV_4711 real NOT NULL, --/U km/s --/D Velocity of emission line [ArIV] 4711 --/F v 13
  V_ArIV_4711_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [ArIV] 4711 --/F v_err 13
  Sigma_ArIV_4711 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [ArIV] 4711 --/F sig 13
  Sigma_ArIV_4711_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [ArIV] 4711 --/F sig_err 13
  Amplitude_ArIV_4711 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [ArIV] 4711 --/F amplitude 13
  Amplitude_ArIV_4711_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [ArIV] 4711 --/F amplitude_err 13
  Flux_ArIV_4711 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [ArIV] 4711 --/F flux 13
  Flux_ArIV_4711_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [ArIV] 4711 --/F flux_err 13
  EW_ArIV_4711 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [ArIV] 4711 --/F ew 13
  EW_ArIV_4711_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [ArIV] 4711 --/F ew_err 13
  Flux_Cont_ArIV_4711 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [ArIV] 4711 --/F flux_cont 13
  Flux_Cont_ArIV_4711_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [ArIV] 4711 --/F flux_cont_err 13
  Fit_Warning_ArIV_4711 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 13
  AoN_ArIV_4711 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [ArIV] 4711 --/F aon 13
  V_ArIV_4740 real NOT NULL, --/U km/s --/D Velocity of emission line [ArIV] 4740 --/F v 14
  V_ArIV_4740_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [ArIV] 4740 --/F v_err 14
  Sigma_ArIV_4740 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [ArIV] 4740 --/F sig 14
  Sigma_ArIV_4740_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [ArIV] 4740 --/F sig_err 14
  Amplitude_ArIV_4740 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [ArIV] 4740 --/F amplitude 14
  Amplitude_ArIV_4740_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [ArIV] 4740 --/F amplitude_err 14
  Flux_ArIV_4740 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [ArIV] 4740 --/F flux 14
  Flux_ArIV_4740_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [ArIV] 4740 --/F flux_err 14
  EW_ArIV_4740 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [ArIV] 4740 --/F ew 14
  EW_ArIV_4740_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [ArIV] 4740 --/F ew_err 14
  Flux_Cont_ArIV_4740 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [ArIV] 4740 --/F flux_cont 14
  Flux_Cont_ArIV_4740_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [ArIV] 4740 --/F flux_cont_err 14
  Fit_Warning_ArIV_4740 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 14
  AoN_ArIV_4740 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [ArIV] 4740 --/F aon 14
  V_Hb_4861 real NOT NULL, --/U km/s --/D Velocity of emission line Hb 4861 --/F v 15
  V_Hb_4861_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line Hb 4861 --/F v_err 15
  Sigma_Hb_4861 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line Hb 4861 --/F sig 15
  Sigma_Hb_4861_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line Hb 4861 --/F sig_err 15
  Amplitude_Hb_4861 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line Hb 4861 --/F amplitude 15
  Amplitude_Hb_4861_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line Hb 4861 --/F amplitude_err 15
  Flux_Hb_4861 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line Hb 4861 --/F flux 15
  Flux_Hb_4861_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line Hb 4861 --/F flux_err 15
  EW_Hb_4861 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line Hb 4861 --/F ew 15
  EW_Hb_4861_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line Hb 4861 --/F ew_err 15
  Flux_Cont_Hb_4861 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line Hb 4861 --/F flux_cont 15
  Flux_Cont_Hb_4861_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line Hb 4861 --/F flux_cont_err 15
  Fit_Warning_Hb_4861 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 15
  AoN_Hb_4861 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line Hb 4861 --/F aon 15
  V_OIII_4958 real NOT NULL, --/U km/s --/D Velocity of emission line [OIII] 4958 --/F v 16
  V_OIII_4958_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [OIII] 4958 --/F v_err 16
  Sigma_OIII_4958 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [OIII] 4958 --/F sig 16
  Sigma_OIII_4958_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [OIII] 4958 --/F sig_err 16
  Amplitude_OIII_4958 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [OIII] 4958 --/F amplitude 16
  Amplitude_OIII_4958_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [OIII] 4958 --/F amplitude_err 16
  Flux_OIII_4958 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [OIII] 4958 --/F flux 16
  Flux_OIII_4958_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [OIII] 4958 --/F flux_err 16
  EW_OIII_4958 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [OIII] 4958 --/F ew 16
  EW_OIII_4958_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [OIII] 4958 --/F ew_err 16
  Flux_Cont_OIII_4958 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [OIII] 4958 --/F flux_cont 16
  Flux_Cont_OIII_4958_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [OIII] 4958 --/F flux_cont_err 16
  Fit_Warning_OIII_4958 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 16
  V_OIII_5006 real NOT NULL, --/U km/s --/D Velocity of emission line [OIII] 5006 --/F v 17
  V_OIII_5006_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [OIII] 5006 --/F v_err 17
  Sigma_OIII_5006 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [OIII] 5006 --/F sig 17
  Sigma_OIII_5006_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [OIII] 5006 --/F sig_err 17
  Amplitude_OIII_5006 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [OIII] 5006 --/F amplitude 17
  Amplitude_OIII_5006_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [OIII] 5006 --/F amplitude_err 17
  Flux_OIII_5006 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [OIII] 5006 --/F flux 17
  Flux_OIII_5006_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [OIII] 5006 --/F flux_err 17
  EW_OIII_5006 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [OIII] 5006 --/F ew 17
  EW_OIII_5006_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [OIII] 5006 --/F ew_err 17
  Flux_Cont_OIII_5006 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [OIII] 5006 --/F flux_cont 17
  Flux_Cont_OIII_5006_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [OIII] 5006 --/F flux_cont_err 17
  Fit_Warning_OIII_5006 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 17
  AoN_OIII_5006 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [OIII] 5006 --/F aon 17
  V_NI_5197 real NOT NULL, --/U km/s --/D Velocity of emission line [NI] 5197 --/F v 18
  V_NI_5197_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [NI] 5197 --/F v_err 18
  Sigma_NI_5197 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [NI] 5197 --/F sig 18
  Sigma_NI_5197_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [NI] 5197 --/F sig_err 18
  Amplitude_NI_5197 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [NI] 5197 --/F amplitude 18
  Amplitude_NI_5197_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [NI] 5197 --/F amplitude_err 18
  Flux_NI_5197 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [NI] 5197 --/F flux 18
  Flux_NI_5197_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [NI] 5197 --/F flux_err 18
  EW_NI_5197 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [NI] 5197 --/F ew 18
  EW_NI_5197_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [NI] 5197 --/F ew_err 18
  Flux_Cont_NI_5197 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [NI] 5197 --/F flux_cont 18
  Flux_Cont_NI_5197_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [NI] 5197 --/F flux_cont_err 18
  Fit_Warning_NI_5197 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 18
  AoN_NI_5197 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [NI] 5197 --/F aon 18
  V_NI_5200 real NOT NULL, --/U km/s --/D Velocity of emission line [NI] 5200 --/F v 19
  V_NI_5200_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [NI] 5200 --/F v_err 19
  Sigma_NI_5200 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [NI] 5200 --/F sig 19
  Sigma_NI_5200_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [NI] 5200 --/F sig_err 19
  Amplitude_NI_5200 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [NI] 5200 --/F amplitude 19
  Amplitude_NI_5200_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [NI] 5200 --/F amplitude_err 19
  Flux_NI_5200 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [NI] 5200 --/F flux 19
  Flux_NI_5200_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [NI] 5200 --/F flux_err 19
  EW_NI_5200 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [NI] 5200 --/F ew 19
  EW_NI_5200_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [NI] 5200 --/F ew_err 19
  Flux_Cont_NI_5200 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [NI] 5200 --/F flux_cont 19
  Flux_Cont_NI_5200_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [NI] 5200 --/F flux_cont_err 19
  Fit_Warning_NI_5200 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 19
  AoN_NI_5200 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [NI] 5200 --/F aon 19
  V_HeI_5875 real NOT NULL, --/U km/s --/D Velocity of emission line HeI 5875 --/F v 20
  V_HeI_5875_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line HeI 5875 --/F v_err 20
  Sigma_HeI_5875 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line HeI 5875 --/F sig 20
  Sigma_HeI_5875_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line HeI 5875 --/F sig_err 20
  Amplitude_HeI_5875 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line HeI 5875 --/F amplitude 20
  Amplitude_HeI_5875_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line HeI 5875 --/F amplitude_err 20
  Flux_HeI_5875 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line HeI 5875 --/F flux 20
  Flux_HeI_5875_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line HeI 5875 --/F flux_err 20
  EW_HeI_5875 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line HeI 5875 --/F ew 20
  EW_HeI_5875_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line HeI 5875 --/F ew_err 20
  Flux_Cont_HeI_5875 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line HeI 5875 --/F flux_cont 20
  Flux_Cont_HeI_5875_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line HeI 5875 --/F flux_cont_err 20
  Fit_Warning_HeI_5875 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 20
  AoN_HeI_5875 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line HeI 5875 --/F aon 20
  V_OI_6300 real NOT NULL, --/U km/s --/D Velocity of emission line [OI] 6300 --/F v 21
  V_OI_6300_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [OI] 6300 --/F v_err 21
  Sigma_OI_6300 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [OI] 6300 --/F sig 21
  Sigma_OI_6300_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [OI] 6300 --/F sig_err 21
  Amplitude_OI_6300 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [OI] 6300 --/F amplitude 21
  Amplitude_OI_6300_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [OI] 6300 --/F amplitude_err 21
  Flux_OI_6300 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [OI] 6300 --/F flux 21
  Flux_OI_6300_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [OI] 6300 --/F flux_err 21
  EW_OI_6300 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [OI] 6300 --/F ew 21
  EW_OI_6300_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [OI] 6300 --/F ew_err 21
  Flux_Cont_OI_6300 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [OI] 6300 --/F flux_cont 21
  Flux_Cont_OI_6300_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [OI] 6300 --/F flux_cont_err 21
  Fit_Warning_OI_6300 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 21
  AoN_OI_6300 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [OI] 6300 --/F aon 21
  V_OI_6363 real NOT NULL, --/U km/s --/D Velocity of emission line [OI] 6363 --/F v 22
  V_OI_6363_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [OI] 6363 --/F v_err 22
  Sigma_OI_6363 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [OI] 6363 --/F sig 22
  Sigma_OI_6363_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [OI] 6363 --/F sig_err 22
  Amplitude_OI_6363 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [OI] 6363 --/F amplitude 22
  Amplitude_OI_6363_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [OI] 6363 --/F amplitude_err 22
  Flux_OI_6363 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [OI] 6363 --/F flux 22
  Flux_OI_6363_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [OI] 6363 --/F flux_err 22
  EW_OI_6363 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [OI] 6363 --/F ew 22
  EW_OI_6363_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [OI] 6363 --/F ew_err 22
  Flux_Cont_OI_6363 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [OI] 6363 --/F flux_cont 22
  Flux_Cont_OI_6363_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [OI] 6363 --/F flux_cont_err 22
  Fit_Warning_OI_6363 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 22
  AoN_OI_6363 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [OI] 6363 --/F aon 22
  V_NII_6547 real NOT NULL, --/U km/s --/D Velocity of emission line [NII] 6547 --/F v 23
  V_NII_6547_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [NII] 6547 --/F v_err 23
  Sigma_NII_6547 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [NII] 6547 --/F sig 23
  Sigma_NII_6547_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [NII] 6547 --/F sig_err 23
  Amplitude_NII_6547 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [NII] 6547 --/F amplitude 23
  Amplitude_NII_6547_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [NII] 6547 --/F amplitude_err 23
  Flux_NII_6547 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [NII] 6547 --/F flux 23
  Flux_NII_6547_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [NII] 6547 --/F flux_err 23
  EW_NII_6547 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [NII] 6547 --/F ew 23
  EW_NII_6547_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [NII] 6547 --/F ew_err 23
  Flux_Cont_NII_6547 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [NII] 6547 --/F flux_cont 23
  Flux_Cont_NII_6547_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [NII] 6547 --/F flux_cont_err 23
  Fit_Warning_NII_6547 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 23
  V_Ha_6562 real NOT NULL, --/U km/s --/D Velocity of emission line Ha 6562 --/F v 24
  V_Ha_6562_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line Ha 6562 --/F v_err 24
  Sigma_Ha_6562 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line Ha 6562 --/F sig 24
  Sigma_Ha_6562_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line Ha 6562 --/F sig_err 24
  Amplitude_Ha_6562 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line Ha 6562 --/F amplitude 24
  Amplitude_Ha_6562_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line Ha 6562 --/F amplitude_err 24
  Flux_Ha_6562 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line Ha 6562 --/F flux 24
  Flux_Ha_6562_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line Ha 6562 --/F flux_err 24
  EW_Ha_6562 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line Ha 6562 --/F ew 24
  EW_Ha_6562_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line Ha 6562 --/F ew_err 24
  Flux_Cont_Ha_6562 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line Ha 6562 --/F flux_cont 24
  Flux_Cont_Ha_6562_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line Ha 6562 --/F flux_cont_err 24
  Fit_Warning_Ha_6562 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 24
  AoN_Ha_6562 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line Ha 6562 --/F aon 24
  V_NII_6583 real NOT NULL, --/U km/s --/D Velocity of emission line [NII] 6583 --/F v 25
  V_NII_6583_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [NII] 6583 --/F v_err 25
  Sigma_NII_6583 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [NII] 6583 --/F sig 25
  Sigma_NII_6583_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [NII] 6583 --/F sig_err 25
  Amplitude_NII_6583 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [NII] 6583 --/F amplitude 25
  Amplitude_NII_6583_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [NII] 6583 --/F amplitude_err 25
  Flux_NII_6583 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [NII] 6583 --/F flux 25
  Flux_NII_6583_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [NII] 6583 --/F flux_err 25
  EW_NII_6583 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [NII] 6583 --/F ew 25
  EW_NII_6583_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [NII] 6583 --/F ew_err 25
  Flux_Cont_NII_6583 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [NII] 6583 --/F flux_cont 25
  Flux_Cont_NII_6583_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [NII] 6583 --/F flux_cont_err 25
  Fit_Warning_NII_6583 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 25
  AoN_NII_6583 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [NII] 6583 --/F aon 25
  V_SII_6716 real NOT NULL, --/U km/s --/D Velocity of emission line [SII] 6716 --/F v 26
  V_SII_6716_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [SII] 6716 --/F v_err 26
  Sigma_SII_6716 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [SII] 6716 --/F sig 26
  Sigma_SII_6716_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [SII] 6716 --/F sig_err 26
  Amplitude_SII_6716 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [SII] 6716 --/F amplitude 26
  Amplitude_SII_6716_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [SII] 6716 --/F amplitude_err 26
  Flux_SII_6716 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [SII] 6716 --/F flux 26
  Flux_SII_6716_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [SII] 6716 --/F flux_err 26
  EW_SII_6716 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [SII] 6716 --/F ew 26
  EW_SII_6716_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [SII] 6716 --/F ew_err 26
  Flux_Cont_SII_6716 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [SII] 6716 --/F flux_cont 26
  Flux_Cont_SII_6716_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [SII] 6716 --/F flux_cont_err 26
  Fit_Warning_SII_6716 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 26
  AoN_SII_6716 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [SII] 6716 --/F aon 26
  V_SII_6730 real NOT NULL, --/U km/s --/D Velocity of emission line [SII] 6730 --/F v 27
  V_SII_6730_Err real NOT NULL, --/U km/s --/D Error in velocity of emission line [SII] 6730 --/F v_err 27
  Sigma_SII_6730 real NOT NULL, --/U km/s --/D Velocity dispersion of emission line [SII] 6730 --/F sig 27
  Sigma_SII_6730_Err real NOT NULL, --/U km/s --/D Error in velocity dispersion of emission line [SII] 6730 --/F sig_err 27
  Amplitude_SII_6730 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Amplitude of emission line [SII] 6730 --/F amplitude 27
  Amplitude_SII_6730_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in amplitude of emission line [SII] 6730 --/F amplitude_err 27
  Flux_SII_6730 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Flux of emission line [SII] 6730 --/F flux 27
  Flux_SII_6730_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A  --/D Error in flux of emission line [SII] 6730 --/F flux_err 27
  EW_SII_6730 real NOT NULL, --/U Angstroms --/D Equivalent width of emission line [SII] 6730 --/F ew 27
  EW_SII_6730_Err real NOT NULL, --/U Angstroms --/D Error in equivalent width of emission line [SII] 6730 --/F ew_err 27
  Flux_Cont_SII_6730 real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Continuum flux at wavelength of emission line [SII] 6730 --/F flux_cont 27
  Flux_Cont_SII_6730_Err real NOT NULL, --/U 10<sup>-17</sup> ergs/cm<sup>2</sup>/s/A --/D Error in continuum flux at wavelength of emission line [SII] 6730 --/F flux_cont_err 27
  Fit_Warning_SII_6730 tinyint NOT NULL, --/D Set to 1 if the emission line falls on a sky line (5577, 6300 or 6363), measurements set to zero in this case; otherwise, this flag is set to 0 --/F fit_warning 27
  AoN_SII_6730 real NOT NULL, --/U km/s --/D Amplitude-over-noise of emission line [SII] 6730 --/F aon 27
)
GO
--
