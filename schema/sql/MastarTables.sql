--=========================================================
--  MastarTables.sql
--  2018-07-24	Renbin Yan	
-----------------------------------------------------------
--  Mastar table schema for SQL Server
-----------------------------------------------------------
-- History:
--* 2018-07-24  Ani: Adapted from sas-sql/mastarall.sql.
--* 2018-07-24  Ani: Flipped the float/real types for coords and mags,
--*             and changed psfMag_[ugriz] to psfMag_[12345] as per 
--*             Renbin's request.
--=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mastar_goodstars')
	DROP TABLE mastar_goodstars
GO
--
EXEC spSetDefaultFileGroup 'mastar_goodstars'
GO
CREATE TABLE mastar_goodstars (
------------------------------------------------------------------------------
--/H Summary file of MaNGA Stellar Libary.
------------------------------------------------------------------------------
--/T Summary information for stars with at least one high quality 
--/T visit-spectrum.
------------------------------------------------------------------------------
    drpver varchar(10) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(10) NOT NULL, --/U  --/D   Version of mastarproc.
    mangaid varchar(20) NOT NULL, --/U  --/D   MaNGA-ID for the target.
    minmjd int NOT NULL, --/U  --/D   Minimum Modified Julian Date of Observations.
    maxmjd int NOT NULL, --/U  --/D   Maximum Modified Julian Date of Observations.
    nvisits int NOT NULL, --/U  --/D   Number of visits for this star (including good and bad observations).
    nplates int NOT NULL, --/U  --/D   Number of plates this star is on.
    objra float NOT NULL, --/U deg --/D   Right Ascension for this object.
    objdec float NOT NULL, --/U deg --/D   Declination for this object.
    catalogra float NOT NULL, --/U deg --/D   Right Ascension in the catalog which the photometry is based on.
    catalogdec float NOT NULL, --/U deg --/D   Declination in the catalog which the photometry is based on.
    cat_epoch real NOT NULL, --/U  --/D   Epoch of the photometry (which is approximate for some catalogs).
    psfmag_1 real NOT NULL, --/F PSFMAG 0 --/U mag --/D   PSF magnitude in the first band, which is u for most stars (depending on PHOTOCAT).  
    psfmag_2 real NOT NULL, --/F PSFMAG 1 --/U mag --/D   PSF magnitude in the second band, which is g for most stars (depending on PHOTOCAT).  
    psfmag_3 real NOT NULL, --/F PSFMAG 2 --/U mag --/D   PSF magnitude in the third band, which is r for most stars (depending on PHOTOCAT).  
    psfmag_4 real NOT NULL, --/F PSFMAG 3 --/U mag --/D   PSF magnitude in the fourth band, which is i for most stars (depending on PHOTOCAT).  
    psfmag_5 real NOT NULL, --/F PSFMAG 4 --/U mag --/D   PSF magnitude in the fifth band, which is z for most stars (depending on PHOTOCAT).  
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    input_logg real NOT NULL, --/U log(cm/s^2) --/D   Surface gravity in the input catalog.
    input_teff real NOT NULL, --/U K --/D   Effective temperature in the input catalog.
    input_fe_h real NOT NULL, --/U  --/D   [Fe/H] in the input catalog.
    input_alpha_m real NOT NULL, --/U  --/D   [alpha/M] in the input catalog.
    input_source varchar(20) NOT NULL, --/U  --/D   Source catalog for stellar parameters.
    photocat varchar(10) NOT NULL, --/U  --/D   Source of photometry for PSFMAG.
)
GO
--



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mastar_goodvisits')
	DROP TABLE mastar_goodvisits
GO
--
EXEC spSetDefaultFileGroup 'mastar_goodvisits'
GO
CREATE TABLE mastar_goodvisits (
------------------------------------------------------------------------------
--/H Summary file of all visits of stars included in MaNGA Stellar Libary.
------------------------------------------------------------------------------
--/T Summary information for all of the good visits of the good stars.
------------------------------------------------------------------------------
    drpver varchar(10) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(10) NOT NULL, --/U  --/D   Version of mastarproc.
    mangaid varchar(20) NOT NULL, --/U  --/D   MaNGA-ID for the object.
    plate int NOT NULL, --/U  --/D   Plate ID.
    ifudesign varchar(10) NOT NULL, --/U  --/D   IFUDESIGN for the fiber bundle.
    mjd int NOT NULL, --/U  --/D   Modified Julian Date for this visit.
    ifura float NOT NULL, --/U  --/D   Right Ascension of the center of the IFU.
    ifudec float NOT NULL, --/U  --/D   Declination of the center of the IFU.
    objra float NOT NULL, --/U  --/D   Right Ascension for this object.
    objdec float NOT NULL, --/U  --/D   Declination for this object.
    psfmag_1 real NOT NULL, --/F PSFMAG 0 --/U mag --/D   PSF magnitude in the first band, which is u for most stars (depending on MNGTARG2)  
    psfmag_2 real NOT NULL, --/F PSFMAG 1 --/U mag --/D   PSF magnitude in the second band, which is g for most stars (depending on MNGTARG2).  
    psfmag_3 real NOT NULL, --/F PSFMAG 2 --/U mag --/D   PSF magnitude in the third band, which is r for most stars (depending on MNGTARG2).  
    psfmag_4 real NOT NULL, --/F PSFMAG 3 --/U mag --/D   PSF magnitude in the fourth band, which is i for most stars (depending on MNGTARG2).  
    psfmag_5 real NOT NULL, --/F PSFMAG 4 --/U mag --/D   PSF magnitude in the fifth band, which is z for most stars (depending on MNGTARG2).  
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    nexp smallint NOT NULL, --/U  --/D   Number of exposures on this visit for this star.
    heliov real NOT NULL, --/U km/s --/D   Heliocentric velocity.
    verr real NOT NULL, --/U km/s --/D   Uncertainty in heliocentric velocity.
    v_errcode smallint NOT NULL, --/U  --/D   Error code for heliocentric velocity measurements.
    mjdqual int NOT NULL, --/U  --/D   Spectral quality bitmask (MASTAR_QUAL).
)
GO
--


EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[MastarTables.sql]: Mastar tables created'
GO