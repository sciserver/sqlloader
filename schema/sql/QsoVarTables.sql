--======================================================================
--   QsoVarTables.sql
--   2013-02-05 Eric Armengaud
------------------------------------------------------------------------
--  QSO variability catalog for EBOSS targets
------------------------------------------------------------------------
-- History:
--* 2016-04-05 Ani: Created sqlLoader schema file from sas/sql.
------------------------------------------------------------------------

SET NOCOUNT ON;
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'qsoVarPTF')
	DROP TABLE qsoVarPTF
GO
--
EXEC spSetDefaultFileGroup 'qsoVarPTF'
GO
--
CREATE TABLE qsoVarPTF (
-------------------------------------------------------------------------------
--/H Variability information on eBOSS quasar targets using PTF lightcurves.
-------------------------------------------------------------------------------
--/T The table "qsoVarPTF" contains variability informations for most DR13 QSO 
--/T targets (EBOSS_TARGET1=0,9,10,11,12), derived from the combination of 
--/T SDSS and PTF photometries, on a large fraction of the eBOSS footprint.
--/T Due to the inhomogeneity of the PTF sky survey, the sensitivity of these
--/T variability measurements is highly variable as a function of sky
--/T coordinates.
-------------------------------------------------------------------------------
  VAR_OBJID          bigint NOT NULL, --/D ObjId
  THING_ID_TARGETING int NOT NULL, --/D ThingID, as in the DR13 target list
  RA                 real NOT NULL, --/D RA (DR12 astrometry) --/U deg
  DEC                real NOT NULL, --/D DEC (DR12 astrometry) --/U deg
  VAR_MATCHED        smallint NOT NULL, --/D Number of epoqs used for the lightcurve construction. For SDSS, one epoq = a single observation. For PTF, one epoq = a set of (coadded) observations, typically from a few months to a year. There are at least two PTF and one SDSS epoq for each object.
  VAR_CHI2           real NOT NULL, --/D Reduced chi2 when the combined light curve is adjusted to a constant
  VAR_A              real NOT NULL, --/D Structure function parameter A as defined in Palanque-Delabrouille et al. (2011)
  VAR_GAMMA          real NOT NULL, --/D Structure function parameter gamma as defined in Palanque-Delabrouille et al. (2011)
)
GO
--



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'qsoVarStripe')
	DROP TABLE qsoVarStripe
GO
--
EXEC spSetDefaultFileGroup 'qsoVarStripe'
GO
--
CREATE TABLE qsoVarStripe (
-------------------------------------------------------------------------------
--/H Variability information on eBOSS quasar targets using SDSS stripe 82 data.
-------------------------------------------------------------------------------
--/T The table "qsoVarStripe" contains additional informations derived from 
--/T essentially all multi-epoq SDSS photometry carried out in the Stripe 82
--/T region.
-------------------------------------------------------------------------------
  VAR_OBJID          bigint NOT NULL, --/D ObjId
  RA                 real NOT NULL, --/D RA (DR12 astrometry) --/U deg
  DEC                real NOT NULL, --/D DEC (DR12 astrometry) --/U deg
  VAR_CHI2           real NOT NULL, --/D Reduced chi2 when the combined light curve is adjusted to a constant
  VAR_A              real NOT NULL, --/D Structure function parameter A as defined in Palanque-Delabrouille et al. (2011)
  VAR_GAMMA          real NOT NULL, --/D Structure function parameter gamma as defined in Palanque-Delabrouille et al. (2011)
  NEPOQS             int NOT NULL, --/D Number of epoqs (SDSS observations) used in lightcurve
  CHI2_U             real NOT NULL, --/D Reduced chi2 in u band
  CHI2_G             real NOT NULL, --/D Reduced chi2 in g band
  CHI2_R             real NOT NULL, --/D Reduced chi2 in r band
  CHI2_I             real NOT NULL, --/D Reduced chi2 in i band
  CHI2_Z             real NOT NULL, --/D Reduced chi2 in z band
  VAR_NN             real NOT NULL, --/D Variability neural network output to discriminate stars against QSO
  MJD_FIRST          real NOT NULL, --/D MJD for the first observation
  MJD_LAST           real NOT NULL, --/D MJD for the last observation
)
GO
--


--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[QsoVarTables.sql]: EBOSS QSO Variability tables created'
GO
