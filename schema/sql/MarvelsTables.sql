--======================================================================
--   MarvelsTables_DR12.sql
--   2014-02-05 Nathan De Lee and Ani Thakar
------------------------------------------------------------------------
--  MARVELS schema for SkyServer  Feb-05-2014
------------------------------------------------------------------------
-- History:
--* 2014-02-05 Ani: Created initial version, split velocity curve data
--*            into 2 tables, marvelsVelocityCurve and marvelsStar.
--* 2014-02-18 Ani: Assigned data types to columns.
--* 2014-02-19 Ani: Removed duplicate TWOMASS_NAME and renamed second
--*            FCJD to FCJD_IMG.
--* 2014-03-04 Ani: Fixed column names with / in them, also replaced
--*            2MASS with TWOMASS in column names.
--* 2014-03-04 Ani: Reverted EXPTIME/TIME to VARCHAR.
--* 2014-03-04 Ani: Changed TOTALPHOTONS to BIGINT from INT.
--* 2014-03-05 Ani: Added BEAM to marvelsVelocityCurve.
--* 2014-03-26 Ani: Split MarvelsVelocityCurve into two tables, one for
--*            each of the radial velocity analysis techniques.  Also
--*            changed the FCJD field in each of these tables to FLOAT. 
--* 2014-07-26 Ani: Added SURVEY column to MarvelsVelocityCurve* tables
--*            as per Nathan de Lee, to indicate phase of survey.
--* 2014-09-05 Nolan: Edited Tables to apply to DR12 UF 1D results
--* 2014-10-03 Ani: Updated column descriptions in marvelsStar as per
--*            Nathan de Lee, and added BEAM and SURVEY columns to 
--*            marvelsVelocityCurveUF1D (the DR12 version).
------------------------------------------------------------------------

SET NOCOUNT ON;
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'marvelsVelocityCurveUF1D')
	DROP TABLE marvelsVelocityCurveUF1D
GO
--
EXEC spSetDefaultFileGroup 'marvelsVelocityCurveUF1D'
GO

CREATE TABLE marvelsVelocityCurveUF1D (
-------------------------------------------------------------------------------
--/H Contains data for a particular MARVELS velocity curve using UF1D technique.
--
--/T This table corresponds to the data in a single velocity curve measurement
-------------------------------------------------------------------------------
	STARNAME VARCHAR(64) NOT NULL,	--/D The primary name of the star (STARNAME)
	FCJD FLOAT NOT NULL,		--/D The flux centered Julian Date 
	RV FLOAT NOT NULL,		--/D The fully corrected radial velocity measurement
	PHOTONERR FLOAT NOT NULL,	--/D Photon limit of observation
	STATERROR FLOAT NOT NULL,	--/D Observed Precision in the measurement of the RV data point
	OFFSETERROR FLOAT NOT NULL,	--/D Expected RV error for each order
	Keep FLOAT NOT NULL,		--/D Good or rejected measurement
	TOTALPHOTONS BIGINT NOT NULL,	--/D Sum of the photons 
	BARYCENTRICVEL FLOAT NOT NULL,	--/D The calculated barycentric velocity (m/s) 
	SPECNO SMALLINT NOT NULL,	--/D Spectrum number (1 is bottom; 120 is top) 
	EPOCHFILE VARCHAR(256) NOT NULL,	--/D Name of the aggregated file for this epoch
	TEMPLATEFILE VARCHAR(256) NOT NULL,	--/D Number of the MJD that was used as the template 
	RADECID VARCHAR(32) NOT NULL,	--/D Plate Name composed from RA and DEC (From image header)
	[OBJECT] VARCHAR(32) NOT NULL,	--/D Plate Name (From image header)
	EXPTYPE VARCHAR(32) NOT NULL,	--/D Exposure Type (Valid values include STAR/TIO/THAR etc.) (From image header)
	PLATEID VARCHAR(32) NOT NULL,	--/D Plate Name (From image header)
	CARTID INT NOT NULL,	--/D Id of the cartridge used for this image (From image header)
	EXPTIME INT NOT NULL,	--/D Exposure time in seconds (From image header)
	[DATE-OBS] VARCHAR(64) NOT NULL,	--/D UT of observation Format is YYYY-MM-DDThh:mm:ss.ss (From image header)
	[TIME] VARCHAR(64) NOT NULL,	--/D Start & Stop of Exposure (From image header)
	[UTC-OBS] VARCHAR(32) NOT NULL,	--/D UTC of Start of Exposure (From image header)
	[LST-OBS] VARCHAR(32) NOT NULL,	--/D LST of Start of Exposure (From image header)
	JD REAL NOT NULL,		--/D Julian date at start of observation (From image header)
	FCJD_IMG REAL NOT NULL,		--/D Flux centered Julian date (From image header)
	MJD REAL NOT NULL,		--/D Modified Julian date at start of observation (From image header)
	RA FLOAT NOT NULL,		--/D RA of tel. boresight (in degrees) (From image header)
	[DEC] FLOAT NOT NULL,		--/D DEC of tel. boresight (in degrees) (From image header)
	EPOCH INT NOT NULL,		--/D Epoch of Coordinates (From image header)
	ALT REAL NOT NULL,		--/D Altitude (encoder) of telescope (From image header)
	AZ REAL NOT NULL,		--/D Azimuth (encoder) of telescope (From image header)
	PMTAVG REAL NOT NULL,	--/D Average PMT (rough flux over whole plate) during observation (in counts) (From image header)
	PMTRMS REAL NOT NULL,	--/D RMS deviation of PMT counts during obs (in counts) (From image header)
	PMTMIN REAL NOT NULL,	--/D Minimum PMT counts during obsservation (in counts) (From image header)
	PMTMAX REAL NOT NULL,	--/D Maximum PMT counts during observation (in counts) (From image header)
	OBSFLAG VARCHAR(16) NOT NULL,	--/D Exp. Quality Flag (OK/UNSURE/JUNK) (From image header)
	IMGAVG REAL NOT NULL,	--/D Average counts per pixel in the image (in counts) (From image header)
	IMGMAX REAL NOT NULL,	--/D Maximum counts per pixel in the image (in counts) (From image header)
	IMGMIN REAL NOT NULL,	--/D Minimum counts per pixel in the image (in counts) (From image header)
	SNRMAX REAL NOT NULL,	--/D Maximumsignal to noise per pixel in the image (From image header)
	SNRMEDN REAL NOT NULL,	--/D Median signal to noise per pixel in the image (From image header)
	SNRMIN REAL NOT NULL,	--/D Minimumsignal to noise per pixel in the image (From image header)
	SNRAVG REAL NOT NULL,	--/D Average signal to noise per pixel in the image (From image header)
	SNRSTDEV REAL NOT NULL,	--/D RMS deviation signal to noise per pixel in the image (From image header)
	SEEING REAL NOT NULL,	--/D Average seeing during the exposure (in arcsec) (From image header)
	CCDTEMP REAL NOT NULL,	--/D CCD Chip Temp. in Deg. Celsius (approx -106 normal) (From image header)
	CCDPRES REAL NOT NULL,	--/D CCD Dewar Pressure in Torr (below < 0.001) normal (From image header)
	P1 REAL NOT NULL,		--/D Mean Pressure(PSI) of Regulator (From image header)
	P1RMS REAL NOT NULL,		--/D RMS Pressure(PSI) of Regulator (From image header)
	P2 REAL NOT NULL,		--/D Mean Pressure(PSI) of Chamber (From image header)
	P2RMS REAL NOT NULL,		--/D RMS Pressure(PSI) of Chamber (From image header)
	P3 REAL NOT NULL,		--/D Mean Pressure(PSI) of Atmosphere (From image header)
	P3RMS REAL NOT NULL,		--/D RMS Pressure(PSI) of Atmosphere (From image header)
	T1 REAL NOT NULL,		--/D Mean Temp. of North Chamber wall in deg. Celsius (From image header)
	T1RMS REAL NOT NULL,		--/D RMS Temp. of North Chamber wall in deg. Celsius (From image header)
	T2 REAL NOT NULL,		--/D Mean Temp. of South Chamber wallin deg. Celsius (From image header)
	T2RMS REAL NOT NULL,		--/D RMS Temp. of South Chamber wallin deg. Celsius (From image header)
	T3 REAL NOT NULL,		--/D Mean Temp. of East Chamber wallin deg. Celsius (From image header)
	T3RMS REAL NOT NULL,		--/D RMS Temp. of East Chamber wallin deg. Celsius (From image header)
	T4 REAL NOT NULL,		--/D Mean Temp. of West Chamber wallin deg. Celsius (From image header)
	T4RMS REAL NOT NULL,		--/D RMS Temp. of West Chamber wallin deg. Celsius (From image header)
	T5 REAL NOT NULL,		--/D Mean Temp. of Top Chamber wallin deg. Celsius (From image header)
	T5RMS REAL NOT NULL,		--/D RMS Temp. of Top Chamber wallin deg. Celsius (From image header)
	T6 REAL NOT NULL,		--/D Mean Temp. of Bottom Chamber wallin deg. Celsius (From image header)
	T6RMS REAL NOT NULL,		--/D RMS Temp. of Bottom Chamber wallin deg. Celsius (From image header)
	T7 REAL NOT NULL,		--/D Mean Temp. of CCD skin in deg. Celsius (From image header)
	T7RMS REAL NOT NULL,		--/D RMSTemp. of CCD skin in deg. Celsius (From image header)
	T8 REAL NOT NULL,		--/D Mean Temp. of CCD house in deg. Celsius (From image header)
	T8RMS REAL NOT NULL,		--/D RMSTemp. of CCD house in deg. Celsius (From image header)
	T9 REAL NOT NULL,		--/D Mean Temp. of Iodine_Cell in deg. Celsius (From image header)
	T9RMS REAL NOT NULL,		--/D RMS Temp. of Iodine_Cell in deg. Celsius (From image header)
	T10 REAL NOT NULL,		--/D Mean Temp of CCD Air in deg. Celsius (From image header)
	T10RMS REAL NOT NULL,	--/D RMSTemp of CCD Air in deg. Celsius (From image header)
	T11 REAL NOT NULL,		--/D Mean Temp of Interferometer top in deg. Celsius (From image header)
	T11RMS REAL NOT NULL,	--/D RMS Temp of Interferometer top in deg. Celsius (From image header)
	T12 REAL NOT NULL,		--/D Mean Temp of Chamber Center in deg. Celsius (From image header)
	T12RMS REAL NOT NULL,	--/D RMSTemp of Chamber Center in deg. Celsius (From image header)
	T13 REAL NOT NULL,		--/D Mean Temp of Grating in deg. Celsius (From image header)
	T13RMS REAL NOT NULL,	--/D RMSTemp of Grating in deg. Celsius (From image header)
	T14 REAL NOT NULL,		--/D Mean Temp of CCD area in deg. Celsius (From image header)
	T14RMS REAL NOT NULL,	--/D RMSTemp of CCD area in deg. Celsius (From image header)
	T15 REAL NOT NULL,		--/D Mean Temp of Chamber input in deg. Celsius (From image header)
	T15RMS REAL NOT NULL,	--/D RMS Temp of Chamber input in deg. Celsius (From image header)
	T16 REAL NOT NULL,		--/D Mean Temp of Ambient in deg. Celsius (From image header)
	T16RMS REAL NOT NULL,		--/D RMS Temp of Ambient in deg. Celsius (From image header)
	BEAM TINYINT NOT NULL,		--/D Beam ID (1 or 2)
	SURVEY VARCHAR(16) NOT NULL,	--/D Indicates survey phase ('year12' or 'year34')
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'marvelsStar')
	DROP TABLE marvelsStar
GO
--
EXEC spSetDefaultFileGroup 'marvelsStar'
GO

CREATE TABLE marvelsStar (
-------------------------------------------------------------------------------
--/H Contains data for a MARVELS star.
--
--/T This table corresponds to the data for a star whose velocity curve is
--/T measured in MARVELS. 
-------------------------------------------------------------------------------
	STARNAME VARCHAR(64) NOT NULL,	--/D The primary name of the star (STARNAME)
	TWOMASS_NAME VARCHAR(64) NOT NULL,	--/D 2MASS Star Catalog Name
	Plate VARCHAR(32) NOT NULL,		--/D Plate Name
	GSC_Name VARCHAR(64) NOT NULL,		--/D Guide Star Catalog Name
	TYC_Name VARCHAR(64) NOT NULL,		--/D Tycho Star Catalog Name
	HIP_Name VARCHAR(62) NOT NULL,		--/D Hipparcos Star Catalog Name
	RA_Final FLOAT NOT NULL,		--/D Star Right Ascension (in degrees)
	DEC_Final FLOAT NOT NULL,		--/D Star Declination (in degrees)
	GSC_B FLOAT NOT NULL,			--/D GSC B Magnitude (in mags)
	GSC_V FLOAT NOT NULL,			--/D GSC V Magnitude (in mags)
	TWOMASS_J REAL NOT NULL,			--/D 2MASS J Magnitude (in mags)
	TWOMASS_H REAL NOT NULL,			--/D 2MASS H Magnitude (in mags)
	TWOMASS_K REAL NOT NULL,			--/D 2MASS K Magnitude (in mags)
	SP1 VARCHAR(16) NOT NULL,		--/D Hipparcos Spectral type 1
	SP2 VARCHAR(16) NOT NULL,		--/D Hipparcos Spectral type 2
	[RPM_LOG_g] VARCHAR(32) NOT NULL,	--/D Luminosity Class from SSPP* (Mainseq/Giant/Refstar) Refstar means it is a known planet host (different method used for year34 - see docs)
	Teff REAL NOT NULL,			--/D SSPP* effective temperature (in Kelvin) (different method used for year34 - see docs)
	[log_g] REAL NOT NULL,	--/D SSPP* Surface gravity (different method used for year34 - see docs)
	[FeH] REAL NOT NULL,	--/D SSPP* Metallicity (different method used for year34 - see docs)
	GSC_B_E REAL NOT NULL,	--/D Error in GSC B Magnitude (in mags)
	GSC_V_E REAL NOT NULL,	--/D Error in GSC V Magnitude (in mags)
	TWOMASS_J_E REAL NOT NULL,	--/D Error in 2MASS J Magnitude (in mags)
	TWOMASS_H_E REAL NOT NULL,	--/D Error in 2MASS H Magnitude (in mags)
	TWOMASS_K_E REAL NOT NULL,	--/D Error in 2MASS H Magnitude (in mags)
	Teff_E REAL NOT NULL,	--/D Error in SSPP* effective temperature (in Kelvin)
	log_g_E REAL NOT NULL,	--/D Error in SSPP* Surface gravity (different method used for year34 - see docs) (different method used for year34 - see docs)
	[FeH_E] REAL NOT NULL,	--/D Error in SSPP* Metallicity (different method used for year34 - see docs)
	Epoch_0 REAL NOT NULL,	--/D Epoch 0
	RA_0 FLOAT NOT NULL,		--/D Right Ascension at Epoch 0 (in degrees)
	DEC_0 FLOAT NOT NULL,		--/D Declination at Epoch 0 (in degrees)
	RA_TWOMASS FLOAT NOT NULL,	--/D 2MASS Right Ascension (in degrees)
	DEC_TWOMASS FLOAT NOT NULL,	--/D 2MASS Declination (in degrees)
	GSC_PM_RA FLOAT NOT NULL,	--/D GSC Proper Motion in RA pmra * cos(dec) (in mas)
	GSC_PM_DEC FLOAT NOT NULL,	--/D GSC Proper MOtion in DEC (in mas)
	GSC_PM_RA_E FLOAT NOT NULL,	--/D Error in GSC Proper Motion in RA pmra * cos(dec) (in mas)
	GSC_PM_DEC_E FLOAT NOT NULL,	--/D Error in GSC Proper MOtion in DEC (in mas)
	TYC_B REAL NOT NULL,	 	--/D Tycho B Magnitude (in mag)
	TYC_B_E REAL NOT NULL,	--/D Error in Tycho B Magnitude (in mag)
	TYC_V REAL NOT NULL,		--/D Tycho V Magnitude (in mag)
	TYC_V_E REAL NOT NULL,	--/D Error in Tycho V Magnitude (in mag)
	HIP_PLX REAL NOT NULL,	--/D Hipparcos Parallax (in mas)
	HIP_PLX_E REAL NOT NULL,	--/D Error in Hipparcos Parallax (in mas)
	HIP_SPTYPE VARCHAR(32) NOT NULL	--/D Hipparcos Spectral Type
)
GO

