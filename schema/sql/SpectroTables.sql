--======================================================================
--   SpectroTables.sql
--   2001-08-14 Alex Szalay
------------------------------------------------------------------------
--  Spectra Schema for SkyServer  Aug-14-2001
------------------------------------------------------------------------
-- History:
--* 2001-04-15	Jim+Alex: go to uniform names.
--*		    return from varchar to tile in SpecObj table.
--* 2001-05-25	Jim: objType-> type, fiberCounts -> fiberMag
--* 2001-08-15	Jim: replaced SpecObj with SpecObjAll  (some spectra are QA or dups.)
--*		Added objID to specObjAll
--*      	Changed procedure name from getFiberList() to fGetFiberList()
--* 2001-11-06	Alex: changed the way primary keys are laid out, added comments
--* 2001-11-06	Alex: moved specLineNames to the Constants.sql script
--* 2002-04-24	Ani: added loadVersion to Plate and SpecObjAll tables, and
--*		    commented out USE statement (isqlw specifies DB name now).
--*		    Also added taiHMS field to Plate table.
--* 2002-05-01	Ani: incorporated Adrian's tiling changes (PR 2433)
--* 2002-08-11	Adrian: modified tiling schema to work with versioned DB
--* 2002-08-20	Adrian: modified HoleObj
--* 2002-09-20	Alex: fixed unit names, also changed tile name in specobj to img
--* 2002-09-20	Alex: Added UCDs to the schema
--* 2002-09-24	Ani: Moved Target and TargetInfo to photoTables.sql
--*                  Moved primary key creation to primaryKeys.sql
--* 2002-11-01	Alex: changed loadVersion type to int
--* 2002-11-07	Alex: Changed SpecLine to SpecLineAll
--* 2002-11-16	Alex: added spRerun to PlateX
--* 2002-12-03	Alex: changed Sector2Tile.tile to smallint
--* 2003-01-27   Ani: Made changes to tiling schema as per PR# 4702:
--*		     renamed TileRegion to TilingRegion
--*		     renamed TileInfo to TilingInfo
--*		     renamed TileNotes to TilingNotes
--*		     renamed TileBoundary to TilingGeometry
--*		     added tinyint "isMask" to TilingGeometry
--*		     removed TiBound2TsChunk
--*		     removed Target2Sector
--* 2003-01-24   Jim: added file group mapping
--* 2003-01-27   Ani: Made changes to tiling schema as per PR# 4702:
--*		     renamed TileRegion to TilingRegion
--*		     renamed TileInfo to TilingInfo
--*		     renamed TileNotes to TilingNotes
--*		     renamed TileBoundary to TilingGeometry
--*		     added tinyint "isMask" to TilingGeometry
--*		     removed TiBound2TsChunk
--*		     removed Target2Sector
--* 2003-01-28:	Alex: changed PlateX.version to varchar(32)
--* 2003-01-30   Ani: Increased varchars from 20 to 64 chars in PlateX
--* 2003-02-21   Ani: Added duplicate to TiledTarget (PR #4487).
--* 2003-03-21   Ani: Fix for PR #5016 (Signal-to-noise descriptions in PlateX)
--* 2003-05-05   Ani: Added positional info to TiledTarget (PR #5276).
--* 2003-05-05   Ani: Changed "reddening" to "extinction" in PlateX and Tile,
--*		     as per PR #5277.
--* 2003-05-16   Ani: Added functions to extract components of specObjIDs
--*		     (supplied by Adrian Pope).
--* 2003-05-20	Adrian+Alex: move Sector, Best2Sector, Sector2Tile, TargetParam,
--*		     TilingRegion, TilingNotes, TilingGeometry, Tile, TiledTarget,
--*		     TilingInfo to tilingTables.sql
--* 2003-06-02	Alex: added SpecPhotoAll table
--* 2003-06-04	Adrian+Alex: added SpecPhotoAll.targetMode, SpecPhotoAll.mode
--* 2003-06-07	Jim: added QSO support tables
--* 2003-06-23  Ani: Fixed error in SpecLineAll.category description.
--* 2003-06-26  Ani: Fixed spelling of Angstroem->Angstrom
--* 2003-10-24  Ani: Fixed UCDs of specObjID and bestObjID (PR #5724).
--* 2003-11-12  Ani: DR2 spectro changes (PR #5741).
--* 2004-07-14  Ani: Fix for PR #6088 (QSO catalog descriptions).
--* 2004-12-17  Ani: Moved functions/sps to spSpectro.sql.
--* 2005-04-02  Ani: Added QuasarCatalog table.
--* 2005-05-02  Ani: Updated description of PlateX.plateID.
--* 2006-04-09  Ani: Updated schema of QSO catalogs for DR5 (from Jim).
--*             Replaced QsoConcordance with QsoConcordanceAll, added
--*             QsoBunch, QsoBest, QsoTarget and QsoSpec.
--* 2006-04-10  Ani: Fixed bug in QSO schema - added extinction for all 
--*             bands in QsoBest and QsoTarget.
--* 2006-05-15  Ani: Shortened description of QsoCatalogAll so it would
--*             not overflow the varchar for it in DBObjects.
--* 2006-06-08  Ani: Updated QuasarCatalog description.
--* 2006-07-31  Ani: Removed PK defs for QsoCatalog tables.
--* 2006-08-02  Ani: Added SEGUE and other target flags to SpecObjAll
--*             for DR6 (PR # 6998).
--* 2007-06-14  Ani: Renamed QuasarCatalog to DR3QuasarCatalog, added new
--*             table DR5QuasarCatalog.
--* 2007-06-15  Ani: Added sppLines and sppParams.
--* 2007-12-05  Ani: Fix for PR #7428 (12C13* column names enclosed in []).
--* 2008-07-21  Ani: Removed identity type for column "QsoPrimary" in 
--*             QsoConcordanceAll as part of fix for PR #7629.
--* 2008-09-25  Ani: Removed last two columns for new sppLines table (PR #7648). 
--* 2008-10-16  Ani: Added metadata for sppParams from Brian Yanny (PR #7660). 
--* 2009-06-04  Ani: Updated schema for SDSS-III.
--* 2009-06-10  Ani: Removed PlateX.programName.
--* 2009-08-13  Ani: Renamed specClass to class and bestPrimTarget,bestSecTarget
--*             to primTarget, secTarget in SpecPhotoAll for SDSS-III.
--* 2009-10-01  Ani: Replaced spec2dRerun and ssppRerun with run2d, run1d and
--*             runsspp in PlateX, and replaced spec2dRerun with run2d and 
--*             run1d in SpecObjAll.
--* 2007-06-15  Ani: Deleted sppLines and sppParams - these are in ssppTables.sql
--*             now.
--* 2009-10-13  Ani: Reinstateed PlateX.programName because CSV file has it.
--* 2009-10-29  Ani: Increased length of PlateX.designComments from 32 to 128.
--* 2010-01-07  Ani: Increased length of PlateX.mjdList from 32 to 512.
--* 2010-06-21  Naren: Added column "img" for SpecObjAll.
--* 2010-07-08  Ani: Added default value to SpecObjAll.img column.
--* 2010-09-16  Ani: Synced SpecObjAll with sas-sql, deleted tables
--*                  ELRedshift, XCRedshift and HoleObj.
--* 2010-10-12  Ani: Synced Platex with sas-sql version.
--* 2010-11-04  Ani: Synced Platex and SpecObjAll with sas-sql version.
--* 2010-11-18  Ani: Removed SpecLine* tables.
--* 2010-12-02  Ani: Modified SpecPhotoAll schema as per Mike Blanton.
--* 2011-05-20  Ani: Added SpecDR7 containing xmatch between SpecObjAll
--*                  and DR7 PhotoPrimary.
--* 2011-06-08  Ani: Updates to SpecDR7 table description, and added column
--*                  descriptions from DR7 schema..
--* 2011-09-27  Ani: Reinstated --/R tags for enumerated and bit columns,
--*                  as per per PR #1444.  Fixed errors in legacy and
--*                  special target flags columns in SpecObjAll.
--* 2011-09-29  Ani: Added --/R PixMask to SpecObjAll.anyAnd(Or)Mask,
--*                  and --/R ObjType to SpecPhotoAll.objType.
--* 2012-05-17  Ani: Swapped in new DR9 schema for PlateX, SpecObjAll.
--* 2012-05-17  Ani: Increased PlateX.dateObs size to varchar(32) from 12.
--* 2012-05-23  Ani: Changed objType to sourceType in SpecPhotoAll.
--* 2012-05-31  Ani: Added galaxy product tables from DR9 patch file.
--* 2012-06-10  Ani: Added additional columns to SpecPhotoAll for DR9 as
--*                  requested by MB.
--* 2012-06-19  Ani: Updated galaxy product table names/schema from sas-sql.
--* 2012-06-19  Ani: Inserted missing comma after Error_Warning column in 
--*                  emissionLinesPort.
--* 2012-07-11  Ani: Added sdssPrimary column to SpecObjAll.
--* 2012-07-16  Ani: Added spec.sdssPrimary to SpecPhotoAll.
--* 2012-07-18  Ani: Added note about DR8 ra,dec to SpecObjAll
--*             description.
--* 2013-01-03  Ani: Changed units of flux inverse variances in
--*             SpecObjAll to 1/nanomaggies^2 (from nanomaggies).
--* 2013-04-08  Ani: Fixed info link key for SpecPhotoAll.sourceType.
--* 2013-05-01  Ani: Moved galaxy product tables to separate file.
--* 2013-05-24  Ani: Added --/R tags back in for bit/enum fields.
--* 2013-07-08  Ani: Added info links for target flags.
--* 2014-11-06  Ani: Added comment to SpecObjAll.sdssPrimary re SpecObj view.
--* 2014-11-26  Ani: Added new column for DR12, eboss_target0.
--* 2014-12-04  Ani: Fixed typo in segue2Primary description as per MWV.
--* 2015-01-22  Ani: Changed zwarning_noqso data type to INT from REAL and
--*                  tweaked descriptions to say BOSS data only (PR #2094).
--* 2015-02-16  Ani: Added info link for zwarning_noqso column in SpecObjAll.
--* 2017-04-07  Ani: Moved sdssPrimary up below sciencePrimary, and added new
--*                  DR14 columns for eBOSS to SpecObjAll.
--* 2017-07-11  Ani: Changed SpecPhotoAll.plateID to NUMERIC(20,0) from BIGINT.
--* 2017-12-12  Ani: Added new VAC table sdssEbossFirefly (from J Comparat).
--* 2019-09-27  Ani: Updated table sdssEbossFirefly (for DR16).
--* 2021-07-19  Ani: Swapped in updated SpecObjAll (for DR17).
--* 2022-12-22  Ani: spAll table added for DR18. Still needs schema info.
--* 2022-12-22  Ani: Removed duplicate spectroflux_[ugriz] columns. (DR18)
--* 2022-12-22  Ani: Bumped up size of PlateX.tile to int from smallint (DR18).
--* 2023-01-03  Ani: Added spAll_eFEDS table, bumped up string lengths for 
--*                  mjd_list through moon_phase.(DR18).
--* 2023-01-04  Ani: Added remaining column descriptions for spAll tables from
--*                  S Morrison. (DR18).
--* 2023-01-05  Ani: Swapped in full column descriptions for spAll tables from
--*                  S Morrison. (DR18).
--* 2024-09-03  Ani: Swapped in spAll* tables. (DR19) 
--* 2024-09-05  Ani: Swapped in new version of spAll_allepoch with bigger 
--*                  varchars. (DR19)
--* 2024-09-06  Ani: Increased size of carton_to_target_pk in spAll 
--*                  tables. (DR19)
--* 2025-05-16  Ani: Added allspec tables. (DR19)
--* 2025-07-03  Ani: Added htmid,cx,cy,cz to spAll and allspec 
--*                  tables. (DR19)
--* 2025-07-24  Ani: Added column has_mwmStar to allspec. (DR19)
------------------------------------------------------------------------

SET NOCOUNT ON;
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PlateX')
	DROP TABLE PlateX
GO
--
EXEC spSetDefaultFileGroup 'PlateX'
GO

CREATE TABLE PlateX (
-------------------------------------------------------------------------------
--/H Contains data from a given plate used for spectroscopic observations.
--
--/T Each SDSS spectrograph plate has 640 observed spectra, whereas each BOSS 
--/T spectrograph plate has 1000 observed spectra. 
-------------------------------------------------------------------------------
	plateID         numeric(20,0)  NOT NULL,	--/D Unique ID, composite of plate number and MJD --/K ID_PLATE
	firstRelease	varchar(32) NOT NULL,	--/D Name of release that this plate/mjd/rerun was first distributed in 
	plate           smallint NOT NULL,      --/D Plate number 
	mjd             int     NOT NULL,       --/D MJD of observation (last) --/U days
	mjdList         varchar(512) NOT NULL,  --/D List of contributing MJDs [from spPlate header]
	survey          varchar(32) NOT NULL,   --/D Name of survey [from platelist product]
	programName     varchar(32) NOT NULL,   --/D Name of program [from platelist product]
	instrument      varchar(32) NOT NULL,   --/D Instrument used (SDSS or BOSS spectrograph)
	chunk           varchar(32) NOT NULL,   --/D Name of tiling chunk  [from platelist product]
	plateRun        varchar(128) NOT NULL,   --/D Drilling run for plate [from platelist product]
	designComments  varchar(128) NOT NULL,  --/D Comments on the plate design from plate plans [from platelist product]
	plateQuality    varchar(32) NOT NULL,   --/D Characterization of plate quality
	qualityComments varchar(100) NOT NULL,  --/D Comments on reason for plate quality  
	plateSN2        real NOT NULL,          --/D Overall signal to noise measure for plate (only set for SDSS plates)
	deredSN2        real NOT NULL,          --/D Dereddened overall signal to noise measure for plate (only set for BOSS plates)
	ra              float   NOT NULL,       --/D RA, J2000 [from spPlate header] --/U deg  --/F racen
	dec             float   NOT NULL,       --/D Dec, J2000 [from spPlate header]  --/U deg  --/F deccen
	run2d		varchar(32) NOT NULL,	--/D 2D reduction rerun of plate
	run1d		varchar(32) NOT NULL,	--/D 1D reduction rerun of plate  
	runsspp		varchar(32) NOT NULL,	--/D SSPP reduction rerun of plate  ("none" if not run)  
	tile            int NOT NULL,      --/D Tile number for SDSS-I, -II plates (-1 for SDSS-III) [from platelist product]
	designID        int NOT NULL,           --/D Design number number for SDSS-III plates (-1 for SDSS-I, -II) [from platelist product]
	locationID        int NOT NULL,         --/D Location number number for SDSS-III plates (-1 for SDSS-I, -II) [from platelist product]
	iopVersion      varchar(64) NOT NULL,   --/D IOP Version [from spPlate header]
	camVersion      varchar(64) NOT NULL,   --/D Camera code version  [from spPlate header]
	taiHMS          varchar(64) NOT NULL,   --/D Time in string format [from spPlate header]
	dateObs         varchar(32) NOT NULL,   --/D Date of 1st row [from spPlate header]
	timeSys         varchar(8)  NOT NULL,   --/D Time System [from spPlate header]
	cx              float   NOT NULL,       --/D x of Normal unit vector in J2000 
	cy              float   NOT NULL,       --/D y of Normal unit vector in J2000 
	cz              float   NOT NULL,       --/D z of Normal unit vector in J2000 
	cartridgeID     smallint NOT NULL,      --/D ID of cartridge used for the observation [from spPlate header] --/F cartid
	tai             float   NOT NULL,       --/D Mean time (TAI) [from spPlate header] --/U sec 
	taiBegin        float   NOT NULL,       --/D Beginning time (TAI) [from spPlate header] --/U sec --/F tai_beg
	taiEnd          float   NOT NULL,       --/D Ending time (TAI) [from spPlate header] --/U sec --/F tai_end
	airmass         real NOT NULL,          --/D Airmass at central TAI time [from spPlate header]
	mapMjd          int     NOT NULL,       --/D Map MJD [from spPlate header] --/U days
	mapName         varchar(32) NOT NULL,   --/D ID of mapping file [from spPlate header]
	plugFile        varchar(32) NOT NULL,   --/D Full name of mapping file [from spPlate header]
	expTime         real    NOT NULL,       --/D Total Exposure time [from spPlate header] --/U sec 
	expTimeB1       real    NOT NULL,       --/D exposure time in B1 spectrograph [from spPlate header] --/U sec --/F expt_b1
	expTimeB2       real    NOT NULL,       --/D exposure time in B2 spectrograph [from spPlate header] --/U sec --/F expt_b2
	expTimeR1       real    NOT NULL,       --/D exposure time in R1 spectrograph [from spPlate header] --/U sec --/F expt_r1
	expTimeR2       real    NOT NULL,       --/D exposure time in R2 spectrograph [from spPlate header] --/U sec --/F expt_r2
	vers2d          varchar(32) NOT NULL,   --/D idlspec2d version used during 2d reduction [from spPlate header]
	verscomb        varchar(32) NOT NULL,   --/D idlspec2d version used during combination of multiple exposures [from spPlate header]
	vers1d          varchar(32) NOT NULL,   --/D idlspec2d version used during redshift fitting [from spPlate header]
	snturnoff       real NOT NULL,          --/D Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate)
	nturnoff        real NOT NULL,          --/D Number of MS turnoff stars on plate 
	nExp            smallint NOT NULL,      --/D Number of exposures total [from spPlate header]
	nExpB1          smallint NOT NULL,      --/D Number of exposures in B1 spectrograph  [from spPlate header]
	nExpB2          smallint NOT NULL,      --/D Number of exposures in B2 spectrograph  [from spPlate header]
	nExpR1          smallint NOT NULL,      --/D Number of exposures in R1 spectrograph  [from spPlate header]
	nExpR2          smallint NOT NULL,      --/D Number of exposures in R2 spectrograph  [from spPlate header]
	sn1_g           real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #1 [from spPlate header] --/F sn2_g1 
	sn1_r           real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #1 [from spPlate header] --/F sn2_r1 
	sn1_i           real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #1 [from spPlate header] --/F sn2_i1 
	sn2_g           real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #2 [from spPlate header] --/F sn2_g2 
	sn2_r           real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #2 [from spPlate header] --/F sn2_r2 
	sn2_i           real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #2 [from spPlate header] --/F sn2_i2 
	dered_sn1_g     real NOT NULL, --/D Dereddened (S/N)^2 at g=20.20 for spectrograph #1 [from spPlate header] --/F dered_sn2_g1 
	dered_sn1_r     real NOT NULL, --/D Dereddened (S/N)^2 at r=20.25 for spectrograph #1 [from spPlate header] --/F dered_sn2_r1 
	dered_sn1_i     real NOT NULL, --/D Dereddened (S/N)^2 at i=19.90 for spectrograph #1 [from spPlate header] --/F dered_sn2_i1 
	dered_sn2_g     real NOT NULL, --/D Dereddened (S/N)^2 at g=20.20 for spectrograph #2 [from spPlate header] --/F dered_sn2_g2 
	dered_sn2_r     real NOT NULL, --/D Dereddened (S/N)^2 at r=20.25 for spectrograph #2 [from spPlate header] --/F dered_sn2_r2 
	dered_sn2_i     real NOT NULL, --/D Dereddened (S/N)^2 at i=19.90 for spectrograph #2 [from spPlate header] --/F dered_sn2_i2 
	helioRV         real    NOT NULL,       --/D Heliocentric velocity correction [from spPlate header] --/U km/s
	gOffStd         real NOT NULL,          --/D Mean g-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	gRMSStd         real NOT NULL,          --/D Standard deviation of g-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	rOffStd         real NOT NULL,          --/D Mean r-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	rRMSStd         real NOT NULL,          --/D Standard deviation of r-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	iOffStd         real NOT NULL,          --/D Mean i-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	iRMSStd         real NOT NULL,          --/D Standard deviation of i-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	grOffStd         real NOT NULL,          --/D Mean g-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	grRMSStd         real NOT NULL,          --/D Standard deviation of g-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	riOffStd         real NOT NULL,          --/D Mean r-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	riRMSStd         real NOT NULL,          --/D Standard deviation of r-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	gOffGal         real NOT NULL,          --/D Mean g-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	gRMSGal         real NOT NULL,          --/D Standard deviation of g-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	rOffGal         real NOT NULL,          --/D Mean r-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	rRMSGal         real NOT NULL,          --/D Standard deviation of r-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	iOffGal         real NOT NULL,          --/D Mean i-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	iRMSGal         real NOT NULL,          --/D Standard deviation of i-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	grOffGal         real NOT NULL,          --/D Mean g-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	grRMSGal         real NOT NULL,          --/D Standard deviation of g-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	riOffGal         real NOT NULL,          --/D Mean r-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	riRMSGal         real NOT NULL,          --/D Standard deviation of r-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	nGuide           int NOT NULL,           --/D Number of guider camera frames taken during the exposure [from spPlate header]
	seeing20         real NOT NULL,          --/D 20th-percentile of seeing during exposure (arcsec) [from spPlate header]
	seeing50         real NOT NULL,          --/D 50th-percentile of seeing during exposure (arcsec) [from spPlate header]
	seeing80         real NOT NULL,          --/D 80th-percentile of seeing during exposure (arcsec) [from spPlate header]
	rmsoff20         real NOT NULL,          --/D 20th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]
	rmsoff50         real NOT NULL,          --/D 50th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]
	rmsoff80         real NOT NULL,          --/D 80th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]
	airtemp          real NOT NULL,          --/U deg Celsius  --/D Air temperature in the dome [from spPlate header]
	sfd_used         tinyint NOT NULL,       --/D Were the SFD dust maps applied to the output spectrum? (0 = no, 1 = yes) --/F sfd_used
	xSigma           real NOT NULL,         --/D sigma of gaussian fit to spatial profile[from spPlate header] 
	xSigMin          real NOT NULL,         --/D minimum of xSigma for all exposures [from spPlate header] 
	xSigMax          real NOT NULL,         --/D maximum of xSigma for all exposures [from spPlate header] 
	wSigma           real NOT NULL,         --/D sigma of gaussian fit to arc-line profiles in wavelength direction [from spPlate header] 
	wSigMin          real NOT NULL,         --/D minimum of wSigma for all exposures [from spPlate header] 
	wSigMax          real NOT NULL,         --/D maximum of wSigma for all exposures [from spPlate header] 
	xChi2            real NOT NULL,         --/D [from spPlate header] 
	xChi2Min         real NOT NULL,         --/D [from spPlate header] 
	xChi2Max         real NOT NULL,         --/D [from spPlate header] 
	skyChi2          real NOT NULL,         --/D average chi-squared from sky subtraction from all exposures [from spPlate header] 
	skyChi2Min       real NOT NULL,         --/D minimum skyChi2 over all exposures [from spPlate header] --/F schi2min
	skyChi2Max       real NOT NULL,         --/D maximum skyChi2 over all exposures [from spPlate header] --/F schi2max
	fBadPix          real NOT NULL,         --/D Fraction of pixels that are bad (total) [from spPlate header]
	fBadPix1         real NOT NULL,         --/D Fraction of pixels that are bad (spectrograph #1) [from spPlate header]
	fBadPix2         real NOT NULL,         --/D Fraction of pixels that are bad (spectrograph #2) [from spPlate header]
	status2d         varchar(32) NOT NULL,  --/D Status of 2D extraction
	statuscombine    varchar(32) NOT NULL,  --/D Status of combination of multiple MJDs
	status1d         varchar(32) NOT NULL,  --/D Status of 1D reductions
	nTotal           int NOT NULL,         --/D Number of objects total [calculated from spZbest file]
	nGalaxy          int NOT NULL,         --/D Number of objects classified as galaxy [calculated from spZbest file]
	nQSO             int NOT NULL,         --/D Number of objects classified as QSO [calculated from spZbest file]
	nStar            int NOT NULL,         --/D Number of objects classified as Star [calculated from spZbest file]
	nSky             int NOT NULL,          --/D Number of sky objects  [calculated from spZbest file]
	nUnknown         int NOT NULL,         --/D Number of objects with zWarning set non-zero (such objects still classified as star, galaxy or QSO) [calculated from spZbest file]
	isBest           tinyint NOT NULL,       --/D is this plateX entry the best observation of the plate 
	isPrimary        tinyint NOT NULL,      --/D is this plateX entry both good and the best observation of the plate 
	isTile           tinyint NOT NULL,         --/D is this plate the best representative  of its tile (only set for "legacy" program plates)
	ha               real NOT NULL,             --/D hour angle of design [from plPlugMapM file] --/U deg --/K POS_EQ_RA  
	mjdDesign        int NOT NULL,           --/D MJD designed for [from plPlugMapM file] --/K MJD  
	theta            real NOT NULL,          --/D cartridge position angle [from plPlugMapM file] --/K POS_POS-ANG  
	fscanVersion     varchar(32) NOT NULL,   --/D version of fiber scanning software [from plPlugMapM file] 
	fmapVersion      varchar(32) NOT NULL,   --/D version of fiber mapping software [from plPlugMapM file] 
	fscanMode        varchar(32) NOT NULL,   --/D 'slow', 'fast', or 'extreme' [from plPlugMapM file] 
	fscanSpeed       int NOT NULL,           --/D speed of scan [from plPlugMapM file] 
	htmID            bigint  NOT NULL,       --/D 20 deep Hierarchical Triangular Mesh ID --/F NOFITS
	loadVersion      int NOT NULL            --/D Load Version --/F NOFITS
)
GO
--



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SpecObjAll')
	DROP TABLE SpecObjAll
GO
--
EXEC spSetDefaultFileGroup 'SpecObjAll'
GO

CREATE TABLE SpecObjAll (
-------------------------------------------------------------------------------
--/H Contains the measured parameters for a spectrum.
-------------------------------------------------------------------------------
--/T This is a base table containing <b>ALL</b> the spectroscopic
--/T information, including a lot of duplicate and bad data. Use
--/T the <b>SpecObj</b> view instead, which has the data properly
--/T filtered for cleanliness. These tables contain both the BOSS
--/T and SDSS spectrograph data.
-------------------------------------------------------------------------------
  specObjID       numeric(20,0) NOT NULL, --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D --/K ID_CATALOG
  bestObjID       bigint NOT NULL, --/D Object ID of photoObj match (position-based) --/K ID_MAIN
  fluxObjID       bigint NOT NULL, --/D Object ID of photoObj match (flux-based) --/K ID_MAIN
  targetObjID     bigint NOT NULL, --/D Object ID of original target --/K ID_CATALOG
  plateID         numeric(20,0) NOT NULL, --/D Database ID of Plate 
  sciencePrimary  smallint NOT NULL, --/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
  sdssPrimary  smallint NOT NULL, --/D Best version of spectrum at this location among SDSS plates (defines default view SpecObj) --/F specsdss
  legacyPrimary   smallint NOT NULL, --/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
  seguePrimary    smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE plates --/F specsegue
  segue1Primary   smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue1
  segue2Primary   smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue2
  bossPrimary     smallint NOT NULL, --/D Best version of spectrum at this location, among BOSS plates --/F specboss
  bossSpecObjID   int NOT NULL, --/D Index of BOSS observation in spAll flat file
  firstRelease    varchar(32) NOT NULL, --/D Name of first release this object was associated with
  survey          varchar(32) NOT NULL, --/D Survey name
  instrument      varchar(32) NOT NULL, --/D Instrument used (SDSS or BOSS spectrograph)
  programname     varchar(32) NOT NULL, --/D Program name
  chunk           varchar(32) NOT NULL, --/D Chunk name
  platerun        varchar(32) NOT NULL, --/D Plate drill run name
  mjd             int NOT NULL, --/U days --/D MJD of observation
  plate           smallint NOT NULL, --/D Plate number
  fiberID         smallint NOT NULL, --/D Fiber ID
  run1d           varchar(32) NOT NULL,  --/D 1D Reduction version of spectrum
  run2d           varchar(32) NOT NULL,  --/D 2D Reduction version of spectrum
  tile            int NOT NULL, --/D Tile number
  designID        int NOT NULL, --/D Design ID number
  legacy_target1   bigint NOT NULL, --/D for Legacy program, target selection information at plate design --/F legacy_target1
  legacy_target2   bigint NOT NULL, --/D for Legacy program target selection information at plate design, secondary/qa/calibration --/F legacy_target2
  special_target1  bigint NOT NULL, --/D for Special program target selection information at plate design --/F special_target1
  special_target2  bigint NOT NULL, --/D for Special program target selection information at plate design, secondary/qa/calibration --/F special_target2
  segue1_target1   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1
  segue1_target2   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection --/F segue1_target2
  segue2_target1   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, primary science selection --/F segue2_target1
  segue2_target2   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, secondary/qa/calib selection --/F segue2_target2
  boss_target1   bigint NOT NULL, --/D BOSS target selection information at plate  --/F boss_target1
  eboss_target0   bigint NOT NULL, --/D EBOSS target selection information, for SEQUELS plates --/F eboss_target0
  eboss_target1   bigint NOT NULL, --/D EBOSS target selection information, for eBOSS plates --/F eboss_target1
  eboss_target2   bigint NOT NULL, --/D EBOSS target selection information, for TDSS, SPIDERS, ELG, etc. plates --/F eboss_target2
  eboss_target_id bigint NOT NULL, --/D EBOSS unique target identifier for every spectroscopic target, --/F eboss_target_id
  ancillary_target1   bigint NOT NULL, --/D BOSS ancillary science target selection information at plate design --/F ancillary_target1
  ancillary_target2   bigint NOT NULL, --/D BOSS ancillary target selection information at plate design --/F ancillary_target2
  thing_id_targeting  bigint Not NULL, --/D thing_id value from the version of resolve from which the targeting was created --/F thing_id_targeting
  thing_id            int Not NULL, --/D Unique identifier from global resolve --/F thing_id
  primTarget       bigint NOT NULL, --/D target selection information at plate design, primary science selection (for backwards compatibility)
  secTarget        bigint NOT NULL, --/D target selection information at plate design, secondary/qa/calib selection  (for backwards compatibility)
  spectrographID  smallint NOT NULL, --/D which spectrograph (1,2)
  sourceType         varchar(128) NOT NULL,  --/D For Legacy, SEGUE-2 and BOSS science targets, type of object targeted as (target bits contain full information and are recommended)
  targetType         varchar(128) NOT NULL,  --/D Nature of target: SCIENCE, STANDARD, or SKY
  ra              float NOT NULL, --/U deg  --/D Right ascension of fiber, J2000    --/F plug_ra
  dec             float NOT NULL, --/U deg  --/D Declination of fiber, J2000     --/F plug_dec
  cx              float   NOT NULL,       --/D x of Normal unit vector in J2000 --/K POS_EQ_CART_X
  cy              float   NOT NULL,       --/D y of Normal unit vector in J2000 --/K POS_EQ_CART_Y
  cz              float   NOT NULL,       --/D z of Normal unit vector in J2000 --/K POS_EQ_CART_Z
  xFocal          real NOT NULL, --/U mm --/D X focal plane position (+RA direction)
  yFocal          real NOT NULL, --/U mm --/D Y focal plane position (+Dec direction)
  lambdaEff       real NOT NULL, --/U Angstroms --/D Effective wavelength that hole was drilled for (accounting for atmopheric refraction)
  blueFiber       int NOT NULL, --/D Set to 1 if this hole was designated a "blue fiber", 0 if designated a "red fiber" (high redshift LRGs are preferentially in "red fibers")
  zOffset         real NOT NULL, --/U microns --/D Washer thickness used (for backstopping BOSS quasar targets, so they are closer to 4000 Angstrom focal plan)
  z               real NOT NULL, --/D Final Redshift
  zErr            real NOT NULL, --/D Redshift error
  zWarning        int NOT NULL, --/D Bitmask of warning values; 0 means all is well
  class           varchar(32) NOT NULL,  --/D Spectroscopic class (GALAXY, QSO, or STAR)
  subClass        varchar(32) NOT NULL,  --/D Spectroscopic subclass
  rChi2           real NOT NULL, --/D Reduced chi-squared of best fit
  DOF             int NOT NULL, --/D Degrees of freedom in best fit
  rChi2Diff       real NOT NULL, --/D Difference in reduced chi-squared between best and second best fit
  z_noqso         real NOT NULL,  --/D Best redshift when excluding QSO fit (right redshift to use for galaxy targets) --/F z_noqso
  zErr_noqso      real NOT NULL,  --/D Error in "z_noqso" redshift --/F z_err_noqso
  zWarning_noqso   int NOT NULL,  --/D Warnings in "z_noqso" redshift --/F zwarning_noqso
  class_noqso      varchar(32) NOT NULL,  --/D Classification in "z_noqso" redshift --/F class_noqso
  subClass_noqso   varchar(32) NOT NULL,  --/D Sub-classification in "z_noqso" redshift --/F subclass_noqso
  rChi2Diff_noqso  real NOT NULL,  --/D Reduced chi-squared difference from next best redshift, for "z_noqso" redshift  --/F rchi2diff_noqso
  z_person         real NOT NULL,  --/D Person-assigned redshift, if this object has been inspected --/F z_person
  class_person     int NOT NULL,  --/D Person-assigned classification, if this object has been inspected --/F class_person
  comments_person  varchar(200) NOT NULL,  --/D Comments from person for inspected objects --/F comments_person
  tFile           varchar(32) NOT NULL, --/D File name of best fit template source
  tColumn_0       smallint NOT NULL, --/D Which column of the template file corresponds to template #0 --/F tcolumn 0
  tColumn_1       smallint NOT NULL, --/D Which column of the template file corresponds to template #1 --/F tcolumn 1
  tColumn_2       smallint NOT NULL, --/D Which column of the template file corresponds to template #2 --/F tcolumn 2
  tColumn_3       smallint NOT NULL, --/D Which column of the template file corresponds to template #3 --/F tcolumn 3
  tColumn_4       smallint NOT NULL, --/D Which column of the template file corresponds to template #4 --/F tcolumn 4
  tColumn_5       smallint NOT NULL, --/D Which column of the template file corresponds to template #5 --/F tcolumn 5
  tColumn_6       smallint NOT NULL, --/D Which column of the template file corresponds to template #6 --/F tcolumn 6
  tColumn_7       smallint NOT NULL, --/D Which column of the template file corresponds to template #7 --/F tcolumn 7
  tColumn_8       smallint NOT NULL, --/D Which column of the template file corresponds to template #8 --/F tcolumn 8
  tColumn_9       smallint NOT NULL, --/D Which column of the template file corresponds to template #9 --/F tcolumn 9
  nPoly           int NOT NULL, --/D Number of polynomial terms used in the fit
  theta_0         real NOT NULL, --/D Coefficient for template #0 of fit --/F theta 0
  theta_1         real NOT NULL, --/D Coefficient for template #1 of fit --/F theta 1
  theta_2         real NOT NULL, --/D Coefficient for template #2 of fit --/F theta 2
  theta_3         real NOT NULL, --/D Coefficient for template #3 of fit --/F theta 3
  theta_4         real NOT NULL, --/D Coefficient for template #4 of fit --/F theta 4
  theta_5         real NOT NULL, --/D Coefficient for template #5 of fit --/F theta 5
  theta_6         real NOT NULL, --/D Coefficient for template #6 of fit --/F theta 6
  theta_7         real NOT NULL, --/D Coefficient for template #7 of fit --/F theta 7
  theta_8         real NOT NULL, --/D Coefficient for template #8 of fit --/F theta 8
  theta_9         real NOT NULL, --/D Coefficient for template #9 of fit --/F theta 9
  velDisp         real NOT NULL, --/U km/s --/D Velocity dispersion --/F vdisp
  velDispErr      real NOT NULL, --/U km/s --/D Error in velocity dispersion --/F vdisp_err
  velDispZ        real NOT NULL, --/D Redshift associated with best fit velocity dispersion --/F vdispz
  velDispZErr     real NOT NULL, --/D Error in redshift associated with best fit velocity dispersion --/F vdispz_err
  velDispChi2     real NOT NULL, --/D Chi-squared associated with velocity dispersion fit --/F vdispchi2
  velDispNPix     int NOT NULL, --/D Number of pixels overlapping best template in velocity dispersion fit --/F vdispnpix
  velDispDOF      int NOT NULL, --/D Number of degrees of freedom in velocity dispersion fit --/F vdispdof
  waveMin         real NOT NULL, --/U Angstroms --/D Minimum observed (vacuum) wavelength
  waveMax         real NOT NULL, --/U Angstroms --/D Maximum observed (vacuum) wavelength
  wCoverage       real NOT NULL, --/D Coverage in wavelength, in units of log10 wavelength
  snMedian_u      real NOT NULL, --/D Median signal-to-noise over all good pixels in u-band --/F sn_median 0
  snMedian_g      real NOT NULL, --/D Median signal-to-noise over all good pixels in g-band --/F sn_median 1
  snMedian_r      real NOT NULL, --/D Median signal-to-noise over all good pixels in r-band --/F sn_median 2
  snMedian_i      real NOT NULL, --/D Median signal-to-noise over all good pixels in i-band --/F sn_median 3
  snMedian_z      real NOT NULL, --/D Median signal-to-noise over all good pixels in z-band --/F sn_median 4
  snMedian        real NOT NULL, --/D Median signal-to-noise over all good pixels --/F sn_median_all
  chi68p          real NOT NULL, --/D 68-th percentile value of abs(chi) of the best-fit synthetic spectrum to the actual spectrum (around 1.0 for a good fit)
  fracNSigma_1    real NOT NULL, --/D Fraction of pixels deviant by more than 1 sigma relative to best-fit --/F fracnsigma 0
  fracNSigma_2    real NOT NULL, --/D Fraction of pixels deviant by more than 2 sigma relative to best-fit --/F fracnsigma 1
  fracNSigma_3    real NOT NULL, --/D Fraction of pixels deviant by more than 3 sigma relative to best-fit --/F fracnsigma 2
  fracNSigma_4    real NOT NULL, --/D Fraction of pixels deviant by more than 4 sigma relative to best-fit --/F fracnsigma 3
  fracNSigma_5    real NOT NULL, --/D Fraction of pixels deviant by more than 5 sigma relative to best-fit --/F fracnsigma 4
  fracNSigma_6    real NOT NULL, --/D Fraction of pixels deviant by more than 6 sigma relative to best-fit --/F fracnsigma 5
  fracNSigma_7    real NOT NULL, --/D Fraction of pixels deviant by more than 7 sigma relative to best-fit --/F fracnsigma 6
  fracNSigma_8    real NOT NULL, --/D Fraction of pixels deviant by more than 8 sigma relative to best-fit --/F fracnsigma 7
  fracNSigma_9    real NOT NULL, --/D Fraction of pixels deviant by more than 9 sigma relative to best-fit --/F fracnsigma 8
  fracNSigma_10   real NOT NULL, --/D Fraction of pixels deviant by more than 10 sigma relative to best-fit --/F fracnsigma 9
  fracNSigHi_1    real NOT NULL, --/D Fraction of pixels high by more than 1 sigma relative to best-fit --/F fracnsighi 0
  fracNSigHi_2    real NOT NULL, --/D Fraction of pixels high by more than 2 sigma relative to best-fit --/F fracnsighi 1
  fracNSigHi_3    real NOT NULL, --/D Fraction of pixels high by more than 3 sigma relative to best-fit --/F fracnsighi 2
  fracNSigHi_4    real NOT NULL, --/D Fraction of pixels high by more than 4 sigma relative to best-fit --/F fracnsighi 3
  fracNSigHi_5    real NOT NULL, --/D Fraction of pixels high by more than 5 sigma relative to best-fit --/F fracnsighi 4
  fracNSigHi_6    real NOT NULL, --/D Fraction of pixels high by more than 6 sigma relative to best-fit --/F fracnsighi 5
  fracNSigHi_7    real NOT NULL, --/D Fraction of pixels high by more than 7 sigma relative to best-fit --/F fracnsighi 6
  fracNSigHi_8    real NOT NULL, --/D Fraction of pixels high by more than 8 sigma relative to best-fit --/F fracnsighi 7
  fracNSigHi_9    real NOT NULL, --/D Fraction of pixels high by more than 9 sigma relative to best-fit --/F fracnsighi 8
  fracNSigHi_10   real NOT NULL, --/D Fraction of pixels high by more than 10 sigma relative to best-fit --/F fracnsighi 9
  fracNSigLo_1    real NOT NULL, --/D Fraction of pixels low by more than 1 sigma relative to best-fit --/F fracnsiglo 0
  fracNSigLo_2    real NOT NULL, --/D Fraction of pixels low by more than 2 sigma relative to best-fit --/F fracnsiglo 1
  fracNSigLo_3    real NOT NULL, --/D Fraction of pixels low by more than 3 sigma relative to best-fit --/F fracnsiglo 2
  fracNSigLo_4    real NOT NULL, --/D Fraction of pixels low by more than 4 sigma relative to best-fit --/F fracnsiglo 3
  fracNSigLo_5    real NOT NULL, --/D Fraction of pixels low by more than 5 sigma relative to best-fit --/F fracnsiglo 4
  fracNSigLo_6    real NOT NULL, --/D Fraction of pixels low by more than 6 sigma relative to best-fit --/F fracnsiglo 5
  fracNSigLo_7    real NOT NULL, --/D Fraction of pixels low by more than 7 sigma relative to best-fit --/F fracnsiglo 6
  fracNSigLo_8    real NOT NULL, --/D Fraction of pixels low by more than 8 sigma relative to best-fit --/F fracnsiglo 7
  fracNSigLo_9    real NOT NULL, --/D Fraction of pixels low by more than 9 sigma relative to best-fit --/F fracnsiglo 8
  fracNSigLo_10   real NOT NULL, --/D Fraction of pixels low by more than 10 sigma relative to best-fit --/F fracnsiglo 9
  spectroFlux_u   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto u filter
  spectroFlux_g   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto g filter
  spectroFlux_r   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto r filter
  spectroFlux_i   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto i filter
  spectroFlux_z   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto z filter
  spectroSynFlux_u  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto u filter
  spectroSynFlux_g  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto g filter
  spectroSynFlux_r  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto r filter
  spectroSynFlux_i  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto i filter
  spectroSynFlux_z  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto z filter
  spectroFluxIvar_u real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto u filter
  spectroFluxIvar_g real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto g filter
  spectroFluxIvar_r real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto r filter
  spectroFluxIvar_i real NOT NULL, --/U 1/nanomaggies^2--/D Inverse variance of spectrum projected onto i filter
  spectroFluxIvar_z real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto z filter
  spectroSynFluxIvar_u  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto u filter
  spectroSynFluxIvar_g  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto g filter
  spectroSynFluxIvar_r  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto r filter
  spectroSynFluxIvar_i  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto i filter
  spectroSynFluxIvar_z  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto z filter
  spectroSkyFlux_u      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto u filter
  spectroSkyFlux_g      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto g filter
  spectroSkyFlux_r      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto r filter
  spectroSkyFlux_i      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto i filter
  spectroSkyFlux_z      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto z filter
  anyAndMask            int NOT NULL, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK
  anyOrMask             int NOT NULL, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK
  plateSN2              real NOT NULL, --/D Overall signal-to-noise-squared measure for plate (only set for SDSS spectrograph)
  deredSN2              real NOT NULL, --/D Dereddened signal-to-noise-squared measure for plate (only set for BOSS spectrograph)
  snTurnoff             real NOT NULL, --/D Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate)
  sn1_g         real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #1 --/F spec1_g
  sn1_r         real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #1 --/F spec1_r
  sn1_i         real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #1 --/F spec1_i
  sn2_g         real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #2 --/F spec2_g
  sn2_r         real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #2 --/F spec2_r
  sn2_i         real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #2 --/F spec2_i
  elodieFileName   varchar(32) NOT NULL, --/D File name for best-fit Elodie star
  elodieObject     varchar(32) NOT NULL, --/D Star name (mostly Henry Draper names)
  elodieSpType     varchar(32) NOT NULL, --/D Spectral type
  elodieBV         real NOT NULL,  --/U mag --/D (B-V) color
  elodieTEff       real NOT NULL,  --/U Kelvin --/D Effective temperature
  elodieLogG       real NOT NULL,  --/D log10(gravity)
  elodieFeH        real NOT NULL,  --/D Metallicity ([Fe/H])
  elodieZ          real NOT NULL,  --/D Redshift
  elodieZErr       real NOT NULL,  --/D Redshift error (negative for invalid fit)
  elodieZModelErr  real NOT NULL,  --/D Standard deviation in redshift among the 12 best-fit stars
  elodieRChi2      real NOT NULL,  --/D Reduced chi^2
  elodieDOF        int NOT NULL,  --/D Degrees of freedom for fit
  htmID           bigint  NOT NULL,       --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM --/F NOFITS
  loadVersion     int     NOT NULL,       --/D Load Version --/K ID_TRACER --/F NOFITS
  img		varbinary(max) NOT NULL DEFAULT 0x1111,	--/D Spectrum Image --/K IMAGE? 
)
GO
--



/* older version commented out for DR17

--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SpecObjAll')
	DROP TABLE SpecObjAll
GO
--
EXEC spSetDefaultFileGroup 'SpecObjAll'
GO

CREATE TABLE SpecObjAll (
-------------------------------------------------------------------------------
--/H Contains the measured parameters for a spectrum.
--
--/T This is a base table containing <b>ALL</b> the spectroscopic
--/T information, including a lot of duplicate and bad data. Use
--/T the <b>SpecObj</b> view instead, which has the data properly
--/T filtered for cleanliness. These tables contain both the BOSS
--/T and SDSS spectrograph data.
--/T NOTE: The RA and Dec in this table refer to the DR8 coordinates,
--/T which have errors in the region north of 41 deg in Dec.
--/T This change does not affect the matching to the photometric
--/T catalog.

-------------------------------------------------------------------------------
  specObjID       numeric(20,0) NOT NULL, --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D --/K ID_CATALOG
  bestObjID       bigint NOT NULL, --/D Object ID of photoObj match (position-based) --/K ID_MAIN
  fluxObjID       bigint NOT NULL, --/D Object ID of photoObj match (flux-based) --/K ID_MAIN
  targetObjID     bigint NOT NULL, --/D Object ID of original target --/K ID_CATALOG
  plateID         numeric(20,0) NOT NULL, --/D Database ID of Plate 
  sciencePrimary  smallint NOT NULL, --/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
  sdssPrimary     smallint NOT NULL, --/D Best version of spectrum at this location among SDSS plates (defines default view SpecObj) --/F specsdss
  legacyPrimary   smallint NOT NULL, --/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
  seguePrimary    smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE plates --/F specsegue
  segue1Primary   smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue1
  segue2Primary   smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE-2 plates --/F specsegue2
  bossPrimary     smallint NOT NULL, --/D Best version of spectrum at this location, among BOSS plates --/F specboss
  bossSpecObjID   int NOT NULL, --/D Index of BOSS observation in spAll flat file
  firstRelease    varchar(32) NOT NULL, --/D Name of first release this object was associated with
  survey          varchar(32) NOT NULL, --/D Survey name
  instrument      varchar(32) NOT NULL, --/D Instrument used (SDSS or BOSS spectrograph)
  programname     varchar(32) NOT NULL, --/D Program name
  chunk           varchar(32) NOT NULL, --/D Chunk name
  platerun        varchar(32) NOT NULL, --/D Plate drill run name
  mjd             int NOT NULL, --/U days --/D MJD of observation 
  plate           smallint NOT NULL, --/D Plate number 
  fiberID         smallint NOT NULL, --/D Fiber ID 
  run1d           varchar(32) NOT NULL,  --/D 1D Reduction version of spectrum 
  run2d           varchar(32) NOT NULL,  --/D 2D Reduction version of spectrum 
  tile            int NOT NULL, --/D Tile number 
  designID        int NOT NULL, --/D Design ID number 
  legacy_target1   bigint NOT NULL, --/D for Legacy program, target selection information at plate design --/F legacy_target1  --/R PrimTarget
  legacy_target2   bigint NOT NULL, --/D for Legacy program target selection information at plate design, secondary/qa/calibration --/F legacy_target2  --/R SecTarget
  special_target1  bigint NOT NULL, --/D for Special program target selection information at plate design --/F special_target1  --/R SpecialTarget1
  special_target2  bigint NOT NULL, --/D for Special program target selection information at plate design, secondary/qa/calibration --/F special_target2  --/R SpecialTarget2
  segue1_target1   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1  --/R Segue1Target1
  segue1_target2   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection --/F segue1_target2  --/R Segue1Target2
  segue2_target1   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, primary science selection --/F segue2_target1  --/R Segue2Target1
  segue2_target2   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, secondary/qa/calib selection --/F segue2_target2  --/R Segue2Target2
  boss_target1   bigint NOT NULL, --/D BOSS target selection information at plate  --/F boss_target1  --/R BossTarget1
  eboss_target0   bigint NOT NULL, --/D EBOSS target selection information, for SEQUELS plates --/F eboss_target0
  eboss_target1   bigint NOT NULL, --/D EBOSS target selection information, for eBOSS plates --/F eboss_target1
  eboss_target2   bigint NOT NULL, --/D EBOSS target selection information, for TDSS, SPIDERS, ELG, etc. plates --/F eboss_target2
  eboss_target_id bigint NOT NULL, --/D EBOSS unique target identifier for every spectroscopic target, --/F eboss_target_id
  ancillary_target1   bigint NOT NULL, --/D BOSS ancillary science target selection information at plate design --/F ancillary_target1  --/R AncillaryTarget1
  ancillary_target2   bigint NOT NULL, --/D BOSS ancillary target selection information at plate design --/F ancillary_target2  --/R AncillaryTarget2
  thing_id_targeting  bigint Not NULL, --/D thing_id value from the version of resolve from which the targeting was created --/F thing_id_targeting
  thing_id            int Not NULL, --/D Unique identifier from global resolve --/F thing_id
  primTarget       bigint NOT NULL, --/D target selection information at plate design, primary science selection (for backwards compatibility)  --/R PrimTarget
  secTarget        bigint NOT NULL, --/D target selection information at plate design, secondary/qa/calib selection  (for backwards compatibility)  --/R SecTarget
  spectrographID  smallint NOT NULL, --/D which spectrograph (1,2)  
  sourceType         varchar(128) NOT NULL,  --/D For Legacy, SEGUE-2 and BOSS science targets, type of object targeted as (target bits contain full information and are recommended)  --/R SourceType
  targetType         varchar(128) NOT NULL,  --/D Nature of target: SCIENCE, STANDARD, or SKY
  ra              float NOT NULL, --/U deg  --/D DR8 Right ascension of fiber, J2000    --/F plug_ra
  dec             float NOT NULL, --/U deg  --/D DR8 Declination of fiber, J2000     --/F plug_dec
  cx              float   NOT NULL,       --/D x of Normal unit vector in J2000 --/K POS_EQ_CART_X
  cy              float   NOT NULL,       --/D y of Normal unit vector in J2000 --/K POS_EQ_CART_Y
  cz              float   NOT NULL,       --/D z of Normal unit vector in J2000 --/K POS_EQ_CART_Z
  xFocal          real NOT NULL, --/U mm --/D X focal plane position (+RA direction)
  yFocal          real NOT NULL, --/U mm --/D Y focal plane position (+Dec direction)
  lambdaEff       real NOT NULL, --/U Angstroms --/D Effective wavelength that hole was drilled for (accounting for atmopheric refraction)
  blueFiber       int NOT NULL, --/D Set to 1 if this hole was designated a "blue fiber", 0 if designated a "red fiber" (high redshift LRGs are preferentially in "red fibers")
  zOffset         real NOT NULL, --/U microns --/D Washer thickness used (for backstopping BOSS quasar targets, so they are closer to 4000 Angstrom focal plan)
  z               real NOT NULL, --/D Final Redshift 
  zErr            real NOT NULL, --/D Redshift error 
  zWarning        int NOT NULL, --/D Bitmask of warning values; 0 means all is well --/R SpeczWarning 
  class           varchar(32) NOT NULL,  --/D Spectroscopic class (GALAXY, QSO, or STAR)
  subClass        varchar(32) NOT NULL,  --/D Spectroscopic subclass 
  rChi2           real NOT NULL, --/D Reduced chi-squared of best fit
  DOF             real NOT NULL, --/D Degrees of freedom in best fit
  rChi2Diff       real NOT NULL, --/D Difference in reduced chi-squared between best and second best fit
  z_noqso         real NOT NULL,  --/D Best redshift when excluding QSO fit in BOSS spectra (right redshift to use for galaxy targets) --/F z_noqso
  zErr_noqso      real NOT NULL,  --/D Error in "z_noqso" redshift (BOSS spectra only) --/F z_err_noqso
  zWarning_noqso   int NOT NULL,  --/D Warnings in "z_noqso" redshift (BOSS spectra only) --/F zwarning_noqso  --/R SpeczWarning 
  class_noqso      varchar(32) NOT NULL,  --/D Classification in "z_noqso" redshift --/F class_noqso
  subClass_noqso   varchar(32) NOT NULL,  --/D Sub-classification in "z_noqso" redshift --/F subclass_noqso
  rChi2Diff_noqso  real NOT NULL,  --/D Reduced chi-squared difference from next best redshift, for "z_noqso" redshift  --/F rchi2diff_noqso
  z_person         real NOT NULL,  --/D Person-assigned redshift, if this object has been inspected --/F z_person
  class_person     varchar(32) NOT NULL,  --/D Person-assigned classification, if this object has been inspected --/F class_person
  comments_person  varchar(200) NOT NULL,  --/D Comments from person for inspected objects --/F comments_person
  tFile           varchar(32) NOT NULL, --/D File name of best fit template source 
  tColumn_0       smallint NOT NULL, --/D Which column of the template file corresponds to template #0 --/F tcolumn 0
  tColumn_1       smallint NOT NULL, --/D Which column of the template file corresponds to template #1 --/F tcolumn 1
  tColumn_2       smallint NOT NULL, --/D Which column of the template file corresponds to template #2 --/F tcolumn 2
  tColumn_3       smallint NOT NULL, --/D Which column of the template file corresponds to template #3 --/F tcolumn 3
  tColumn_4       smallint NOT NULL, --/D Which column of the template file corresponds to template #4 --/F tcolumn 4
  tColumn_5       smallint NOT NULL, --/D Which column of the template file corresponds to template #5 --/F tcolumn 5
  tColumn_6       smallint NOT NULL, --/D Which column of the template file corresponds to template #6 --/F tcolumn 6
  tColumn_7       smallint NOT NULL, --/D Which column of the template file corresponds to template #7 --/F tcolumn 7
  tColumn_8       smallint NOT NULL, --/D Which column of the template file corresponds to template #8 --/F tcolumn 8
  tColumn_9       smallint NOT NULL, --/D Which column of the template file corresponds to template #9 --/F tcolumn 9
  nPoly           real NOT NULL, --/D Number of polynomial terms used in the fit
  theta_0         real NOT NULL, --/D Coefficient for template #0 of fit --/F theta 0 
  theta_1         real NOT NULL, --/D Coefficient for template #1 of fit --/F theta 1 
  theta_2         real NOT NULL, --/D Coefficient for template #2 of fit --/F theta 2 
  theta_3         real NOT NULL, --/D Coefficient for template #3 of fit --/F theta 3 
  theta_4         real NOT NULL, --/D Coefficient for template #4 of fit --/F theta 4 
  theta_5         real NOT NULL, --/D Coefficient for template #5 of fit --/F theta 5 
  theta_6         real NOT NULL, --/D Coefficient for template #6 of fit --/F theta 6 
  theta_7         real NOT NULL, --/D Coefficient for template #7 of fit --/F theta 7 
  theta_8         real NOT NULL, --/D Coefficient for template #8 of fit --/F theta 8 
  theta_9         real NOT NULL, --/D Coefficient for template #9 of fit --/F theta 9 
  velDisp         real NOT NULL, --/U km/s --/D Velocity dispersion --/F vdisp
  velDispErr      real NOT NULL, --/U km/s --/D Error in velocity dispersion --/F vdisp_err
  velDispZ        real NOT NULL, --/D Redshift associated with best fit velocity dispersion --/F vdispz
  velDispZErr     real NOT NULL, --/D Error in redshift associated with best fit velocity dispersion --/F vdispz_err
  velDispChi2     real NOT NULL, --/D Chi-squared associated with velocity dispersion fit --/F vdispchi2
  velDispNPix     int NOT NULL, --/D Number of pixels overlapping best template in velocity dispersion fit --/F vdispnpix
  velDispDOF      int NOT NULL, --/D Number of degrees of freedom in velocity dispersion fit --/F vdispdof
  waveMin         real NOT NULL, --/U Angstroms --/D Minimum observed (vacuum) wavelength 
  waveMax         real NOT NULL, --/U Angstroms --/D Maximum observed (vacuum) wavelength 
  wCoverage       real NOT NULL, --/D Coverage in wavelength, in units of log10 wavelength
  snMedian_u      real NOT NULL, --/D Median signal-to-noise over all good pixels in u-band --/F sn_median 0
  snMedian_g      real NOT NULL, --/D Median signal-to-noise over all good pixels in g-band --/F sn_median 1
  snMedian_r      real NOT NULL, --/D Median signal-to-noise over all good pixels in r-band --/F sn_median 2
  snMedian_i      real NOT NULL, --/D Median signal-to-noise over all good pixels in i-band --/F sn_median 3
  snMedian_z      real NOT NULL, --/D Median signal-to-noise over all good pixels in z-band --/F sn_median 4
  snMedian        real NOT NULL, --/D Median signal-to-noise over all good pixels --/F sn_median_all
  chi68p          real NOT NULL, --/D 68-th percentile value of abs(chi) of the best-fit synthetic spectrum to the actual spectrum (around 1.0 for a good fit)
  fracNSigma_1    real NOT NULL, --/D Fraction of pixels deviant by more than 1 sigma relative to best-fit --/F fracnsigma 0
  fracNSigma_2    real NOT NULL, --/D Fraction of pixels deviant by more than 2 sigma relative to best-fit --/F fracnsigma 1
  fracNSigma_3    real NOT NULL, --/D Fraction of pixels deviant by more than 3 sigma relative to best-fit --/F fracnsigma 2
  fracNSigma_4    real NOT NULL, --/D Fraction of pixels deviant by more than 4 sigma relative to best-fit --/F fracnsigma 3
  fracNSigma_5    real NOT NULL, --/D Fraction of pixels deviant by more than 5 sigma relative to best-fit --/F fracnsigma 4
  fracNSigma_6    real NOT NULL, --/D Fraction of pixels deviant by more than 6 sigma relative to best-fit --/F fracnsigma 5
  fracNSigma_7    real NOT NULL, --/D Fraction of pixels deviant by more than 7 sigma relative to best-fit --/F fracnsigma 6
  fracNSigma_8    real NOT NULL, --/D Fraction of pixels deviant by more than 8 sigma relative to best-fit --/F fracnsigma 7
  fracNSigma_9    real NOT NULL, --/D Fraction of pixels deviant by more than 9 sigma relative to best-fit --/F fracnsigma 8
  fracNSigma_10   real NOT NULL, --/D Fraction of pixels deviant by more than 10 sigma relative to best-fit --/F fracnsigma 9
  fracNSigHi_1    real NOT NULL, --/D Fraction of pixels high by more than 1 sigma relative to best-fit --/F fracnsighi 0
  fracNSigHi_2    real NOT NULL, --/D Fraction of pixels high by more than 2 sigma relative to best-fit --/F fracnsighi 1
  fracNSigHi_3    real NOT NULL, --/D Fraction of pixels high by more than 3 sigma relative to best-fit --/F fracnsighi 2
  fracNSigHi_4    real NOT NULL, --/D Fraction of pixels high by more than 4 sigma relative to best-fit --/F fracnsighi 3
  fracNSigHi_5    real NOT NULL, --/D Fraction of pixels high by more than 5 sigma relative to best-fit --/F fracnsighi 4
  fracNSigHi_6    real NOT NULL, --/D Fraction of pixels high by more than 6 sigma relative to best-fit --/F fracnsighi 5
  fracNSigHi_7    real NOT NULL, --/D Fraction of pixels high by more than 7 sigma relative to best-fit --/F fracnsighi 6
  fracNSigHi_8    real NOT NULL, --/D Fraction of pixels high by more than 8 sigma relative to best-fit --/F fracnsighi 7
  fracNSigHi_9    real NOT NULL, --/D Fraction of pixels high by more than 9 sigma relative to best-fit --/F fracnsighi 8
  fracNSigHi_10   real NOT NULL, --/D Fraction of pixels high by more than 10 sigma relative to best-fit --/F fracnsighi 9
  fracNSigLo_1    real NOT NULL, --/D Fraction of pixels low by more than 1 sigma relative to best-fit --/F fracnsiglo 0
  fracNSigLo_2    real NOT NULL, --/D Fraction of pixels low by more than 2 sigma relative to best-fit --/F fracnsiglo 1
  fracNSigLo_3    real NOT NULL, --/D Fraction of pixels low by more than 3 sigma relative to best-fit --/F fracnsiglo 2
  fracNSigLo_4    real NOT NULL, --/D Fraction of pixels low by more than 4 sigma relative to best-fit --/F fracnsiglo 3
  fracNSigLo_5    real NOT NULL, --/D Fraction of pixels low by more than 5 sigma relative to best-fit --/F fracnsiglo 4
  fracNSigLo_6    real NOT NULL, --/D Fraction of pixels low by more than 6 sigma relative to best-fit --/F fracnsiglo 5
  fracNSigLo_7    real NOT NULL, --/D Fraction of pixels low by more than 7 sigma relative to best-fit --/F fracnsiglo 6
  fracNSigLo_8    real NOT NULL, --/D Fraction of pixels low by more than 8 sigma relative to best-fit --/F fracnsiglo 7
  fracNSigLo_9    real NOT NULL, --/D Fraction of pixels low by more than 9 sigma relative to best-fit --/F fracnsiglo 8
  fracNSigLo_10   real NOT NULL, --/D Fraction of pixels low by more than 10 sigma relative to best-fit --/F fracnsiglo 9
  spectroFlux_u   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto u filter  
  spectroFlux_g   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto g filter  
  spectroFlux_r   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto r filter
  spectroFlux_i   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto i filter
  spectroFlux_z   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto z filter
  spectroSynFlux_u  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto u filter
  spectroSynFlux_g  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto g filter
  spectroSynFlux_r  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto r filter
  spectroSynFlux_i  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto i filter
  spectroSynFlux_z  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto z filter
  spectroFluxIvar_u real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto u filter
  spectroFluxIvar_g real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto g filter
  spectroFluxIvar_r real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto r filter
  spectroFluxIvar_i real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto i filter
  spectroFluxIvar_z real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto z filter
  spectroSynFluxIvar_u  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto u filter 
  spectroSynFluxIvar_g  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto g filter 
  spectroSynFluxIvar_r  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto r filter 
  spectroSynFluxIvar_i  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto i filter 
  spectroSynFluxIvar_z  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto z filter 
  spectroSkyFlux_u      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto u filter
  spectroSkyFlux_g      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto g filter
  spectroSkyFlux_r      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto r filter
  spectroSkyFlux_i      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto i filter
  spectroSkyFlux_z      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto z filter
  anyAndMask            int NOT NULL, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK  --/R SpecPixMask
  anyOrMask             int NOT NULL, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK  --/R SpecPixMask
  plateSN2              real NOT NULL, --/D Overall signal-to-noise-squared measure for plate (only set for SDSS spectrograph)
  deredSN2              real NOT NULL, --/D Dereddened signal-to-noise-squared measure for plate (only set for BOSS spectrograph)
  snTurnoff             real NOT NULL, --/D Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate)
  sn1_g         real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #1 --/F spec1_g 
  sn1_r         real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #1 --/F spec1_r 
  sn1_i         real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #1 --/F spec1_i 
  sn2_g         real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #2 --/F spec2_g 
  sn2_r         real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #2 --/F spec2_r 
  sn2_i         real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #2 --/F spec2_i 
  elodieFileName   varchar(32) NOT NULL, --/D File name for best-fit Elodie star
  elodieObject     varchar(32) NOT NULL, --/D Star name (mostly Henry Draper names)
  elodieSpType     varchar(32) NOT NULL, --/D Spectral type
  elodieBV         real NOT NULL,  --/U mag --/D (B-V) color
  elodieTEff       real NOT NULL,  --/U Kelvin --/D Effective temperature
  elodieLogG       real NOT NULL,  --/D log10(gravity)  
  elodieFeH        real NOT NULL,  --/D Metallicity ([Fe/H])
  elodieZ          real NOT NULL,  --/D Redshift
  elodieZErr       real NOT NULL,  --/D Redshift error (negative for invalid fit)
  elodieZModelErr  real NOT NULL,  --/D Standard deviation in redshift among the 12 best-fit stars
  elodieRChi2      real NOT NULL,  --/D Reduced chi^2
  elodieDOF        real NOT NULL,  --/D Degrees of freedom for fit
  htmID           bigint  NOT NULL,       --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM --/F NOFITS
  loadVersion     int     NOT NULL,       --/D Load Version --/K ID_TRACER --/F NOFITS
  img		varbinary(max) NOT NULL DEFAULT 0x1111,	--/D Spectrum Image --/K IMAGE? 
)
GO
--

*/



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SpecPhotoAll')
	DROP TABLE SpecPhotoAll
GO
--
EXEC spSetDefaultFileGroup 'SpecPhotoAll'
GO
CREATE TABLE SpecPhotoAll (
-------------------------------------------------------------------------------
--/H The combined spectro and photo parameters of an object in SpecObjAll
--
--/T This is a precomputed join between the PhotoObjAll and SpecObjAll tables.
--/T The photo attibutes included cover about the same as PhotoTag.
--/T The table also includes certain attributes from Tiles.
-------------------------------------------------------------------------------
	specObjID       numeric(20,0) NOT NULL,	--/D Unique ID --/K ID_CATALOG
	mjd		int NOT NULL,		--/D MJD of observation --/U MJD --/K TIME_DATE
	plate		smallint NOT NULL, 	--/D Plate ID --/K ID_PLATE
	tile		smallint NOT NULL,  	--/D Tile ID --/K ID_PLATE
	fiberID		smallint NOT NULL,	--/D Fiber ID --/K ID_FIBER
	z		real NOT NULL,		--/D Final Redshift --/K REDSHIFT
	zErr		real NOT NULL,		--/D Redshift error --/K REDSHIFT ERROR
	class		varchar(32) NOT NULL,	--/D Spectroscopic class (GALAXY, QSO, or STAR)
	subClass	varchar(32) NOT NULL,	--/D Spectroscopic subclass
	zWarning	int NOT NULL,		--/D Warning Flags --/R SpeczWarning --/K CODE_QUALITY
	ra		float NOT NULL,		--/D ra in J2000 from SpecObj --/U deg --/K POS_EQ_RA_MAIN
	dec		float NOT NULL,		--/D dec in J2000 from SpecObj --/U deg --/K POS_EQ_DEC_MAIN
	cx 		float 	NOT NULL,	--/D x of Normal unit vector in J2000 --/K POS_EQ_CART_X?
	cy 		float 	NOT NULL,  	--/D y of Normal unit vector in J2000 --/K POS_EQ_CART_Y?
	cz 		float 	NOT NULL,  	--/D z of Normal unit vector in J2000 --/K POS_EQ_CART_Z?
	htmID 		bigint 	NOT NULL, 	--/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
	sciencePrimary	smallint NOT NULL,	--/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
	legacyPrimary	smallint NOT NULL,	--/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
	seguePrimary	smallint NOT NULL,	--/D Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj) --/F specsegue
	segue1Primary	smallint NOT NULL,	--/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue1
	segue2Primary	smallint NOT NULL,	--/D Best version of spectrum at this location, among SEGUE-2 plates --/F specsegue2
	bossPrimary	smallint NOT NULL,	--/D Best version of spectrum at this location, among BOSS plates --/F specboss
	sdssPrimary     smallint NOT NULL,	--/D Best version of spectrum at this location among SDSS plates --/F specsdss
	survey	varchar(32) NOT NULL,		--/D Survey name
	programname	varchar(32) NOT NULL,	--/D Program name
	legacy_target1   bigint NOT NULL, --/D for Legacy program, target selection information at plate design --/F legacy_target1  --/R PrimTarget
	legacy_target2   bigint NOT NULL, --/D for Legacy program target selection information at plate design, secondary/qa/calibration --/F legacy_target2  --/R SecTarget
	special_target1  bigint NOT NULL, --/D for Special program target selection information at plate design --/F special_target1  --/R SpecialTarget1
	special_target2  bigint NOT NULL, --/D for Special program target selection information at plate design, secondary/qa/calibration --/F special_target2  --/R SpecialTarget2
	segue1_target1   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1  --/R Segue1Target1
	segue1_target2   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection --/F segue1_target2  --/R Segue1Target2
	segue2_target1   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, primary science selection --/F segue2_target1  --/R Segue2Target1
	segue2_target2   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, secondary/qa/calib selection --/F segue2_target2  --/R Segue2Target2
	boss_target1   bigint NOT NULL, --/D BOSS target selection information at plate  --/F boss_target1  --/R BossTarget1
	ancillary_target1   bigint NOT NULL, --/D BOSS ancillary science target selection information at plate design --/F ancillary_target1  --/R AncillaryTarget1
	ancillary_target2   bigint NOT NULL, --/D BOSS ancillary target selection information at plate design --/F ancillary_target2  --/R AncillaryTarget2
	plateID		numeric(20,0) NOT NULL,	--/D Link to plate on which the spectrum was taken --/K ID_PLATE
	sourceType	varchar(32) NOT NULL,	--/D type of object targeted as --/R sourceType --/K CLASS_OBJECT
	targetObjID	bigint NOT NULL,	--/D ID of target PhotoObj --/K ID_CATALOG
-------------------------------------------------------------------------------
	objID		bigint ,	--/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj]. --/K ID_CATALOG
	skyVersion	int ,	--/D 0 = OPDB target, 1 = OPDB best --/K CODE_MISC
	run		int ,	--/D Run number --/K OBS_RUN
	rerun		int ,	--/D Rerun number --/K CODE_MISC
	camcol		int ,	--/D Camera column --/K INST_ID
	field		int ,	--/D Field number --/K ID_FIELD
	obj		int ,	--/D The object id within a field. Usually changes between reruns of the same field. --/K ID_NUMBER
	mode		int ,	--/D  1: primary, 2: secondary, 3: family object. --/K CLASS_OBJECT
	nChild		int ,	--/D Number of children if this is a deblened composite object. BRIGHT (in a flags sense) objects also have nchild==1, the non-BRIGHT sibling. --/K NUMBER
	type		int ,	--/D Morphological type classification of the object. --/R PhotoType --/K CLASS_OBJECT
	flags		bigint ,	--/D Photo Object Attribute Flags  --/R PhotoFlags --/K CODE_MISC
	psfMag_u	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_U
	psfMag_g	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_G
	psfMag_r	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_R
	psfMag_i	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_I
	psfMag_z	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_Z
	psfMagErr_u	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_U ERROR
	psfMagErr_g	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_G ERROR
	psfMagErr_r	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_R ERROR
	psfMagErr_i	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_I ERROR
	psfMagErr_z	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_Z ERROR
	fiberMag_u	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_U
	fiberMag_g	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_G
	fiberMag_r	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_R
	fiberMag_i	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_I
	fiberMag_z	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_Z
	fiberMagErr_u	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_U ERROR
	fiberMagErr_g	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_G ERROR
	fiberMagErr_r	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_R ERROR
	fiberMagErr_i	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_I ERROR
	fiberMagErr_z	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_Z ERROR
	petroMag_u	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_U
	petroMag_g	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_G
	petroMag_r	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_R
	petroMag_i	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_I
	petroMag_z	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_Z
	petroMagErr_u	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_U ERROR
	petroMagErr_g	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_G ERROR
	petroMagErr_r	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_R ERROR
	petroMagErr_i	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_I ERROR
	petroMagErr_z	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_Z ERROR
	modelMag_u	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_U FIT_PARAM
	modelMag_g	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_G FIT_PARAM
	modelMag_r	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_R FIT_PARAM
	modelMag_i	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_I FIT_PARAM
	modelMag_z	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_Z FIT_PARAM
	modelMagErr_u	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_U ERROR
	modelMagErr_g	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_G ERROR
	modelMagErr_r	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_R ERROR
	modelMagErr_i	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_I ERROR
	modelMagErr_z	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_Z ERROR
	cModelMag_u     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMag_g     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMag_r     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMag_i     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMag_z     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMagErr_u  real ,	--/U mag --/D DeV+Exp magnitude error
	cModelMagErr_g  real ,	--/U mag --/D DeV+Exp magnitude error
	cModelMagErr_r  real ,	--/U mag --/D DeV+Exp magnitude error
	cModelMagErr_i  real ,	--/U mag --/D DeV+Exp magnitude error
	cModelMagErr_z  real ,	--/U mag --/D DeV+Exp magnitude error
	mRrCc_r		real ,	--/D Adaptive (<r^2> + <c^2>) --/K FIT_PARAM
	mRrCcErr_r	real ,	--/D Error in adaptive (<r^2> + <c^2>) --/K FIT_PARAM ERROR
	score           real ,	--/D Quality of field (0-1)
	resolveStatus   int ,	--/D Resolve status of object
	calibStatus_u   int ,	--/D Calibration status in u-band
	calibStatus_g   int ,	--/D Calibration status in g-band
	calibStatus_r   int ,	--/D Calibration status in r-band
	calibStatus_i   int ,	--/D Calibration status in i-band
	calibStatus_z   int ,	--/D Calibration status in z-band
	photoRa		float ,	--/D J2000 right ascension (r') from Best --/U deg --/K POS_EQ_RA_MAIN
	photoDec	float ,	--/D J2000 declination (r') from Best --/U deg --/K POS_EQ_DEC_MAIN
	extinction_u	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_g	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_r	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_i	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_z	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	fieldID 	bigint ,	--/D Link to the field this object is in --/K ID_FIELD
	dered_u		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_U
	dered_g		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_G
	dered_r		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_R
	dered_i		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_I
	dered_z		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_Z
)
GO




--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SpecDR7')
	DROP TABLE SpecDR7
GO
--
EXEC spSetDefaultFileGroup 'SpecDR7'
GO
CREATE TABLE SpecDR7 (
-------------------------------------------------------------------------------
--/H Contains the spatial cross-match between DR8 SpecObjAll and DR7 primaries.
-------------------------------------------------------------------------------
--/T This is a unique match between a DR8 SpecObjAll and a DR7 photoprimary 
--/T within 1 arcsec.  DR7 PhotoTag columns and relevant DR7 ProperMotions are
--/T also included for convenience.
-------------------------------------------------------------------------------
	specObjID   bigint NOT NULL,	--/D Unique DR8 ID based on PLATE, MJD, FIBERID, RUN2D--/K ID_CATALOG
	dr7ObjID	bigint NOT NULL,	--/D Unique DR7 PhotoPrimary ID composed from [skyVersion,rerun,run,camcol,field,obj]. --/K ID_MAIN
	ra		float NOT NULL,		--/D J2000 right ascension (r') --/U deg --/K POS_EQ_RA_MAIN
	[dec]		float NOT NULL,		--/D J2000 declination (r') --/U deg --/K POS_EQ_DEC_MAIN
	cx		float NOT NULL,		--/D unit vector for ra+dec --/K POS_EQ_CART_X
	cy		float NOT NULL,		--/D unit vector for ra+dec --/K POS_EQ_CART_Y
	cz		float NOT NULL,		--/D unit vector for ra+dec --/K POS_EQ_CART_Z
	skyVersion	tinyint NOT NULL,	--/D 0 = OPDB target, 1 = OPDB best --/K CODE_MISC
	run		smallint NOT NULL,	--/D Run number --/K OBS_RUN
	rerun		smallint NOT NULL,	--/D Rerun number --/K CODE_MISC
	camcol		tinyint NOT NULL,	--/D Camera column --/K INST_ID
	field		smallint NOT NULL,	--/D Field number --/K ID_FIELD
	obj		smallint NOT NULL,	--/D The object id within a field. Usually changes between reruns of the same field. --/K ID_NUMBER
	nChild		smallInt NOT NULL,	--/D Number of children if this is a composite object that has been deblended. BRIGHT (in a flags sense) objects also have nchild == 1, the non-BRIGHT sibling. --/K NUMBER
	[type]		smallint NOT NULL,	--/D Morphological type classification of the object. --/R PhotoType --/K CLASS_OBJECT
	probPSF		real NOT NULL,		--/D Probability that the object is a star. Currently 0 if type == 3 (galaxy), 1 if type == 6 (star). --/K STAT_PROBABILITY
	insideMask	tinyint NOT NULL,	--/D Flag to indicate whether object is inside a mask and why --/R InsideMask --/K CODE_MISC
	flags		bigint NOT NULL, --/D Photo Object Attribute Flags  --/R PhotoFlags --/K CODE_MISC
	psfMag_u	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_U
	psfMag_g	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_G
	psfMag_r	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_R
	psfMag_i	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_I
	psfMag_z	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_Z
	psfMagErr_u	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_U ERROR
	psfMagErr_g	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_G ERROR
	psfMagErr_r	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_R ERROR
	psfMagErr_i	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_I ERROR
	psfMagErr_z	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_Z ERROR
	petroMag_u	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_U
	petroMag_g	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_G
	petroMag_r	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_R
	petroMag_i	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_I
	petroMag_z	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_Z
	petroMagErr_u	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_U ERROR
	petroMagErr_g	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_G ERROR
	petroMagErr_r	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_R ERROR
	petroMagErr_i	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_I ERROR
	petroMagErr_z	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_Z ERROR
	petroR50_r	real NOT NULL,	--/D Radius containing 50% of Petrosian flux --/U arcsec --/K EXTENSION_RAD
	petroR90_r	real NOT NULL,	--/D Radius containing 90% of Petrosian flux --/U arcsec --/K EXTENSION_RAD
	modelMag_u	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_U FIT_PARAM
	modelMag_g	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_G FIT_PARAM
	modelMag_r	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_R FIT_PARAM
	modelMag_i	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_I FIT_PARAM
	modelMag_z	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_Z FIT_PARAM
	modelMagErr_u	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_U ERROR
	modelMagErr_g	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_G ERROR
	modelMagErr_r	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_R ERROR
	modelMagErr_i	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_I ERROR
	modelMagErr_z	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_Z ERROR
	mRrCc_r		real NOT NULL,	--/D Adaptive (<r^2> + <c^2>) --/K FIT_PARAM
	mRrCcErr_r	real NOT NULL,	--/D Error in adaptive (<r^2> + <c^2>) --/K FIT_PARAM ERROR
--
	lnLStar_r	real NOT NULL,	--/D Star ln(likelihood) --/K FIT_GOODNESS
	lnLExp_r	real NOT NULL,	--/D Exponential disk fit ln(likelihood) --/K FIT_GOODNESS
	lnLDeV_r	real NOT NULL,	--/D DeVaucouleurs fit ln(likelihood) --/K FIT_GOODNESS
	status		int NOT NULL,	--/D Status of the object in the survey --/R PhotoStatus --/K CODE_MISC
	primTarget	int NOT NULL,	--/D Bit mask of primary target categories the object was selected in. --/R PrimTarget  --/K CODE_MISC
	secTarget	int NOT NULL,	--/D Bit mask of secondary target categories the object was selected in. --/R SecTarget --/K CODE_MISC
--
	extinction_u	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_g	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_r	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_i	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_z	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	htmID 		bigint NOT NULL, --/D 20-deep hierarchical trangular mesh ID of this object --/K CODE_HTM
	fieldID 	bigint NOT NULL, --/D Link to the field this object is in --/K ID_FIELD
	[size]		real NOT NULL default -9999,  --/D computed: =SQRT(mRrCc_r/2.0)
	pmRa real NOT NULL,	--/D Proper motion in right ascension. --/U mas/year --/K POS_PM_RA
	pmDec real NOT NULL,	--/D Proper motion in declination. --/U mas/year --/K POS_PM_DEC
	pmL real NOT NULL,	--/D Proper motion in galactic longitude.  --/U mas/year --/K POS_PM
	pmB real NOT NULL,	--/D Proper motion in galactic latitude. --/U mas/year  --/K POS_PM
	pmRaErr real NOT NULL,	--/D Error in proper motion in right ascension. --/U mas/year --/K POS_PM_RA_ERR
	pmDecErr real NOT NULL,	--/D Error in proper motion in declination. --/U mas/year --/K POS_PM_DEC_ERR
	delta real NOT NULL,	--/D Distance between this object and the nearest matching USNO-B object. --/U arcsec --/K POS_ANG_DIST_GENERAL --/F pm_delta
	match int NOT NULL	--/D Number of objects in USNO-B which matched this object within a 1 arcsec radius.  If negative, then the nearest matching USNO-B object itself matched more than 1 SDSS object. --/K CODE_MISC --/F pm_match
)
GO
--


--===============================================================
-- eBOSS Firefly VAC table (from sas/sql/sdssEbossFoirefly.sql
--===============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'sdssEbossFirefly')) 
	drop table [sdssEbossFirefly]
GO
--
CREATE TABLE sdssEbossFirefly (
------------------------------------------------------------------------------
--/H Contains the measured stellar population parameters for a spectrum.
------------------------------------------------------------------------------
--/T This is a base table containing spectroscopic
--/T information and the results of the FIREFLY fits on
--/T the DR16 speclite spectra observed by SDSS (run2d=26) and BOSS, eBOSS
--/T (run2d=v5_13_0). This run used the Chabrier stellar initial mass
--/T function, the MILES and ELODIE libraries.  Redshifts used for BOSS and
--/T eBOSS plates is the NOQSO version
------------------------------------------------------------------------------
SPECOBJID                                                             numeric(20,0)   NOT NULL, --/U no unit --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D     --/F SPECOBJID
RUN2D                                                                 varchar(16)   NOT NULL, --/U no unit --/D version of the 2d reduction pipeline		      --/F RUN2D
RUN1D                                                                 varchar(16)   NOT NULL, --/U no unit --/D version of the 1d reduction pipeline	              --/F RUN1D
PLATE  		                                                      int       NOT NULL, --/U no unit --/D Plate number                                              --/F PLATE
MJD    		                                                      int       NOT NULL, --/U days    --/D MJD of observation					      --/F MJD
FIBERID		                                                      int       NOT NULL, --/U no unit --/D Fiber identification number 			      --/F FIBERID
RA		                                                      float    NOT NULL, --/U degrees --/D Right ascension of fiber, J2000 			      --/F RA
DEC	                                                              float    NOT NULL, --/U degrees --/D Declination of fiber, J2000 				      --/F DEC
Z_NOQSO			                                              real     NOT NULL, --/U no unit --/D Best redshift 					      --/F Z_NOQSO
Z_ERR_NOQSO 		                                              real     NOT NULL, --/U no unit --/D Error in redshift  					      --/F Z_ERR_NOQSO
CLASS_NOQSO                       	                              varchar(16)   NOT NULL, --/U no unit --/D Classification in redshift 			      --/F CLASS_NOQSO
Chabrier_MILES_age_lightW                                             real     NOT NULL, --/U age in years (light weighted)
Chabrier_MILES_age_lightW_up_1sig                                     real     NOT NULL, --/U
Chabrier_MILES_age_lightW_low_1sig                                    real     NOT NULL, --/U
Chabrier_MILES_age_lightW_up_2sig                                     real     NOT NULL, --/U
Chabrier_MILES_age_lightW_low_2sig                                    real     NOT NULL, --/U
Chabrier_MILES_metallicity_lightW                                     real     NOT NULL, --/U  metallicity in solar metallicities (light weighted)
Chabrier_MILES_metallicity_lightW_up_1sig                             real     NOT NULL, --/U 
Chabrier_MILES_metallicity_lightW_low_1sig                            real     NOT NULL, --/U 
Chabrier_MILES_metallicity_lightW_up_2sig                             real     NOT NULL, --/U 
Chabrier_MILES_metallicity_lightW_low_2sig                            real     NOT NULL, --/U 
Chabrier_MILES_age_massW     		                              real     NOT NULL, --/U age in years (mass weighted)
Chabrier_MILES_age_massW_up_1sig                                      real     NOT NULL, --/U 
Chabrier_MILES_age_massW_low_1sig                                     real     NOT NULL, --/U 
Chabrier_MILES_age_massW_up_2sig                                      real     NOT NULL, --/U 
Chabrier_MILES_age_massW_low_2sig                                     real     NOT NULL, --/U 
Chabrier_MILES_metallicity_massW                                      real     NOT NULL, --/U metallicity in solar metallicities (mass weighted)
Chabrier_MILES_metallicity_massW_up_1sig                              real     NOT NULL, --/U 
Chabrier_MILES_metallicity_massW_low_1sig                             real     NOT NULL, --/U 
Chabrier_MILES_metallicity_massW_up_2sig                              real     NOT NULL, --/U 
Chabrier_MILES_metallicity_massW_low_2sig                             real     NOT NULL, --/U 
Chabrier_MILES_total_mass                                             real     NOT NULL, --/U mass in solar mass
Chabrier_MILES_total_mass_up_1sig                                     real     NOT NULL, --/U 
Chabrier_MILES_total_mass_low_1sig                                    real     NOT NULL, --/U 
Chabrier_MILES_total_mass_up_2sig                                     real     NOT NULL, --/U 
Chabrier_MILES_total_mass_low_2sig                                    real     NOT NULL, --/U 
Chabrier_MILES_spm_EBV                                                real     NOT NULL, --/U E(B-V) mag
Chabrier_MILES_nComponentsSSP                                         real     NOT NULL, --/U number of components
Chabrier_ELODIE_age_lightW                                            real     NOT NULL, --/U 
Chabrier_ELODIE_age_lightW_up_1sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_age_lightW_low_1sig                                   real     NOT NULL, --/U 
Chabrier_ELODIE_age_lightW_up_2sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_age_lightW_low_2sig                                   real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW                                    real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW_up_1sig                            real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW_low_1sig                           real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW_up_2sig                            real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW_low_2sig                           real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW                                             real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW_up_1sig                                     real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW_low_1sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW_up_2sig                                     real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW_low_2sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW                                     real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW_up_1sig                             real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW_low_1sig                            real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW_up_2sig                             real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW_low_2sig                            real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass                                            real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass_up_1sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass_low_1sig                                   real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass_up_2sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass_low_2sig                                   real     NOT NULL, --/U 
Chabrier_ELODIE_spm_EBV                                               real     NOT NULL, --/U 
Chabrier_ELODIE_nComponentsSSP                                        real     NOT NULL, --/U 
)

GO
--




--===============================================================
-- spAll table added for DR18
--===============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'spAll')) 
	drop table [spAll]
GO
--
CREATE TABLE spAll (
--------------------------------------------------------------------------------
--/H Summary spectroscopic information for the BOSS spectrograph data.
--
--/T This is a base table containing the summary spectroscopic information
--/T for the BOSS spectrograph data coadded on a daily cadence
--------------------------------------------------------------------------------
    field bigint NOT NULL,   --/D SDSS FieldID (plateID for plate era data)  
    mjd bigint NOT NULL,   --/D Modified Julian date of combined Spectra  
    obs varchar(3) NOT NULL,   --/D Observatory of Observation  
    mjd_final float NOT NULL,   --/D Mean MJD of the Coadded Spectra  
    mjd_list varchar(107) NOT NULL,   --/D List of MJD of each included exposures  
    tai_list varchar(197) NOT NULL,   --/D List Tai for each exposure (at midpoint)  
    run2d varchar(6) NOT NULL,   --/D Spectro-2D reduction name  
    run1d varchar(6) NOT NULL,   --/D Spectro-1D reduction name  
    designs varchar(125) NOT NULL,   --/D List of Included Designs  
    configs varchar(89) NOT NULL,   --/D List of Included Configurations  
    nexp smallint NOT NULL,   --/D Number of Included Exposures  
    exptime real NOT NULL,    --/U s --/D Total Exposure time of Coadded Spectra  
    target_index bigint NOT NULL,   --/D Index of target on combined spField  
    fiberid_list varchar(71) NOT NULL,   --/D List of FiberIDs contributing to Stack  
    spec_file varchar(42) NOT NULL,   --/D Name of spec file (in SAS)  
    programname varchar(14) NOT NULL,   --/D Program name within a given survey  
    survey varchar(13) NOT NULL,   --/D Survey that field is part of  
    cadence varchar(19) NOT NULL,   --/D Requested Target Cadence  
    firstcarton varchar(48) NOT NULL,   --/D Primary SDSS Carton for target  
    carton_to_target_pk varchar(64) NOT NULL,   --/D SDSS-V CartonToTarget DB Table Primary Key  
    objtype varchar(16) NOT NULL,   --/D Why this object was targeted.  Note that if this field says QSO, it could be the case that this object would have been targeted as a GALAXY or any number of other categories as well. The PRIMTARGET and SECTARGET flags in the plug-map structure (in the spField file) gives this full information.  
    catalogid bigint NOT NULL,   --/D SDSS-V CatalogID used in naming  
    catalogid_v0 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v0  
    catalogid_v0p5 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v0.5  
    sdss_id bigint NOT NULL,   --/D Unified SDSS Target Identifier  
    specobjid numeric(30) NOT NULL,   --/D Unique ID based on Field, MJD, SDSSID, RUN2D, COADD type  
    calibflux_u real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-u from PSFmag  
    calibflux_g real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-g from PSFmag  
    calibflux_r real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-r from PSFmag  
    calibflux_i real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-i from PSFmag  
    calibflux_z real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-z from PSFmag  
    calibflux_ivar_u real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-u from PSFmag  
    calibflux_ivar_g real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-g from PSFmag  
    calibflux_ivar_r real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-r from PSFmag  
    calibflux_ivar_i real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-i from PSFmag  
    calibflux_ivar_z real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-z from PSFmag  
    optical_prov varchar(26) NOT NULL,   --/D The source of the optical CATDB_MAG magnitudes  
    mag_u real NOT NULL,   --/D u optical magnitudes  
    mag_g real NOT NULL,   --/D g optical magnitudes  
    mag_r real NOT NULL,   --/D r optical magnitudes  
    mag_i real NOT NULL,   --/D i optical magnitudes  
    mag_z real NOT NULL,   --/D z optical magnitudes  
    psfmag_u real NOT NULL,   --/D u optical PSF magnitudes  
    psfmag_g real NOT NULL,   --/D g optical PSF magnitudes  
    psfmag_r real NOT NULL,   --/D r optical PSF magnitudes  
    psfmag_i real NOT NULL,   --/D i optical PSF magnitudes  
    psfmag_z real NOT NULL,   --/D z optical PSF magnitudes  
    fiber2mag_u real NOT NULL,   --/D u optical Fiber2 magnitudes  
    fiber2mag_g real NOT NULL,   --/D g optical Fiber2 magnitudes  
    fiber2mag_r real NOT NULL,   --/D r optical Fiber2 magnitudes  
    fiber2mag_i real NOT NULL,   --/D i optical Fiber2 magnitudes  
    fiber2mag_z real NOT NULL,   --/D z optical Fiber2 magnitudes  
    catdb_mag_u real NOT NULL,   --/D u Raw TargetDB magnitudes  
    catdb_mag_g real NOT NULL,   --/D g Raw TargetDB magnitudes  
    catdb_mag_r real NOT NULL,   --/D r Raw TargetDB magnitudes  
    catdb_mag_i real NOT NULL,   --/D i Raw TargetDB magnitudes  
    catdb_mag_z real NOT NULL,   --/D z Raw TargetDB magnitudes  
    gaia_g_mag real NOT NULL,   --/D Gaia G magnitude  
    gri_gaia_transform bigint NOT NULL,   --/D provenance of photometry in SDSS-V plate design  
    bp_mag real NOT NULL,   --/D Gaia BP magnitude  
    rp_mag real NOT NULL,   --/D Gaia RP magnitude  
    gaia_id bigint NOT NULL,   --/D Gaia DR2 SourceID  
    wise_mag_1 real NOT NULL,   --/D WISE W1 band magnitudes  
    wise_mag_2 real NOT NULL,   --/D WISE W2 band magnitudes  
    wise_mag_3 real NOT NULL,   --/D WISE W3 band magnitudes  
    wise_mag_4 real NOT NULL,   --/D WISE W4 band magnitudes  
    twomass_mag_1 real NOT NULL,   --/D 2MASS J band magnitudes  
    twomass_mag_2 real NOT NULL,   --/D 2MASS H band magnitudes  
    twomass_mag_3 real NOT NULL,   --/D 2MASS Ks band magnitudes  
    guvcat_mag_1 real NOT NULL,   --/D GALEX FUV band magnitudes  
    guvcat_mag_2 real NOT NULL,   --/D GALEX NUV band magnitudes  
    ebv real NOT NULL,   --/D dust extinction  
    ebv_type varchar(14) NOT NULL,   --/D Source of dust extinction  
    fiber_ra float NOT NULL,    --/U degrees --/D Fiber RA [J2000 for plate; at exp for FPS]  
    fiber_dec float NOT NULL,    --/U degrees --/D Fiber DEC [J2000 for plate; at exp for FPS]  
    plug_ra float NOT NULL,    --/U degrees --/D Object RA (drilled fiber position) [J2000]  
    plug_dec float NOT NULL,    --/U degrees --/D Object DEC (drilled fiber position) [J2000]  
    racat float NOT NULL,    --/U degrees --/D Catalog RA in ICRS coordinates at coord_epoch  
    deccat float NOT NULL,    --/U degrees --/D Catalog DEC in ICRS coordinates at coord_epoch  
    coord_epoch real NOT NULL,   --/D Epoch of the RACAT/DECCAT Catalog coordinates.  
    pmra real NOT NULL,    --/U mas/year --/D Proper motion in RA (pmra is a true angle)  
    pmdec real NOT NULL,    --/U mas/year --/D Proper motion in Dec  
    parallax real NOT NULL,    --/U mas --/D Parallax  
    ra_list varchar(197) NOT NULL,    --/U degrees --/D List of measured RA per exposure  
    dec_list varchar(179) NOT NULL,    --/U degrees --/D List of measured DEC per exposure  
    delta_ra_list varchar(71) NOT NULL,    --/U arcsec --/D List of designed RA offsets per exposure  
    delta_dec_list varchar(71) NOT NULL,    --/U arcsec --/D List of designed DEC offsets per exposure  
    fiber_offset bigint NOT NULL,   --/D Flag identifying the fiber was offset by design  
    xfocal varchar(161) NOT NULL,    --/U mm --/D Hole/robot x-axis position in focal plane  
    yfocal varchar(161) NOT NULL,    --/U mm --/D Hole/robot y-axis position in focal plane  
    zoffset real NOT NULL,    --/U microns --/D Backstopping offset distance  
    lambda_eff real NOT NULL,    --/U AA --/D Wavelength to optimize hole location for  
    bluefiber bigint NOT NULL,   --/D 1 if assigned target a blue fiber; 0 otherwise  
    healpix bigint NOT NULL,   --/D healpix pixel number of the RACAT and DECCAT coordinates, computed with healpix nside=128  
    healpixgrp bigint NOT NULL,   --/D Rounded-down integer value of healpix / 1000  
    healpix_path varchar(70) NOT NULL,   --/D Path to spec fits file in SAS healpix structure  
    fieldquality varchar(4) NOT NULL,   --/D Characterization of field quality  
    exp_disp_med float NOT NULL,   --/D Dispersion of Median Exposure Flux  
    fieldsn2 real NOT NULL,   --/D Overall (S/N)^2 for field; min of cameras  
    fieldsnr2g_list varchar(89) NOT NULL,   --/D Overall Field (S/N)^2 in g per exposure  
    fieldsnr2r_list varchar(89) NOT NULL,   --/D Overall Field (S/N)^2 in r per exposure  
    fieldsnr2i_list varchar(89) NOT NULL,   --/D Overall Field (S/N)^2 in i per exposure  
    spec1_g real NOT NULL,   --/D Fit (S/N)^2 at g=20.20 for spectrograph 1 (same value for 500 fibers)  
    spec1_r real NOT NULL,   --/D Fit (S/N)^2 at r=20.25 for spectrograph 1 (same value for 500 fibers)  
    spec1_i real NOT NULL,   --/D Fit (S/N)^2 at i=19.90 for spectrograph 1 (same value for 500 fibers)  
    spec2_g real NOT NULL,   --/D Fit (S/N)^2 at g=20.20 for spectrograph 2 (same value for 500 fibers)  
    spec2_r real NOT NULL,   --/D Fit (S/N)^2 at r=20.25 for spectrograph 2 (same value for 500 fibers)  
    spec2_i real NOT NULL,   --/D Fit (S/N)^2 at i=19.90 for spectrograph 2 (same value for 500 fibers)  
    sn_median_u real NOT NULL,   --/D Median S/N for all good pixels in SDSS-u  
    sn_median_g real NOT NULL,   --/D Median S/N for all good pixels in SDSS-g  
    sn_median_r real NOT NULL,   --/D Median S/N for all good pixels in SDSS-r  
    sn_median_i real NOT NULL,   --/D Median S/N for all good pixels in SDSS-i  
    sn_median_z real NOT NULL,   --/D Median S/N for all good pixels in SDSS-z  
    sn_median_all real NOT NULL,   --/D Median S/N for all good pixels in all filters  
    airmass real NOT NULL,   --/D Airmass at time of observation  
    seeing20 real NOT NULL,    --/U arcsecs --/D Mean 20% seeing during exposures (arcsec)  
    seeing50 real NOT NULL,    --/U arcsecs --/D Mean 50% seeing during exposures (arcsec)  
    seeing80 real NOT NULL,    --/U arcsecs --/D Mean 80% seeing during exposures (arcsec)  
    moon_dist varchar(107) NOT NULL,    --/U degrees --/D Mean Moon-target separation of Coadded Spectra  
    moon_phase varchar(89) NOT NULL,   --/D Mean Moon phase of the Coadded Spectra  
    assigned varchar(35) NOT NULL,   --/D Whether this fibre was assigned to a target  
    on_target varchar(35) NOT NULL,   --/D Whether this fibre is on target  
    valid varchar(35) NOT NULL,   --/D alpha and beta angles are valid  
    decollided varchar(35) NOT NULL,   --/D this positioner had to be moved to decollide it  
    anyandmask bigint NOT NULL,   --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK  
    anyormask bigint NOT NULL,   --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK  
    specprimary tinyint NOT NULL,   --/D Objects observed multiple times will have this set to 1 for one observation only. This is usually the 'best' observation, as defined by critera listed in fieldmerge.py.  
    specboss bigint NOT NULL,   --/D Best version of spectrum at this location  
    boss_specobj_id bigint NOT NULL,   --/D ID of spectrum location on sky  
    nspecobs bigint NOT NULL,   --/D Number of spectral observations  
    spectroflux_u real NOT NULL,    --/U nanomaggy --/D Spectrum projected onto SDSS-u filter  
    spectroflux_g real NOT NULL,    --/U nanomaggy --/D Spectrum projected onto SDSS-g filter  
    spectroflux_r real NOT NULL,    --/U nanomaggy --/D Spectrum projected onto SDSS-r filter  
    spectroflux_i real NOT NULL,    --/U nanomaggy --/D Spectrum projected onto SDSS-i filter  
    spectroflux_z real NOT NULL,    --/U nanomaggy --/D Spectrum projected onto SDSS-z filter  
    spectroflux_ivar_u real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROFLUX_u  
    spectroflux_ivar_g real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROFLUX_g  
    spectroflux_ivar_r real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROFLUX_r  
    spectroflux_ivar_i real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROFLUX_i  
    spectroflux_ivar_z real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROFLUX_z  
    spectrosynflux_u real NOT NULL,    --/U nanomaggy --/D Best-fit template projected onto SDSS-u  
    spectrosynflux_g real NOT NULL,    --/U nanomaggy --/D Best-fit template projected onto SDSS-g  
    spectrosynflux_r real NOT NULL,    --/U nanomaggy --/D Best-fit template projected onto SDSS-r  
    spectrosynflux_i real NOT NULL,    --/U nanomaggy --/D Best-fit template projected onto SDSS-i  
    spectrosynflux_z real NOT NULL,    --/U nanomaggy --/D Best-fit template projected onto SDSS-z  
    spectrosynflux_ivar_u real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_u  
    spectrosynflux_ivar_g real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_g  
    spectrosynflux_ivar_r real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_r  
    spectrosynflux_ivar_i real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_i  
    spectrosynflux_ivar_z real NOT NULL,    --/U nanomaggy --/D Inverse variance of SPECTROSYNFLUX_z  
    spectroskyflux_u real NOT NULL,    --/U nanomaggy --/D Sky spectrum projected onto SDSS-u filter  
    spectroskyflux_g real NOT NULL,    --/U nanomaggy --/D Sky spectrum projected onto SDSS-g filter  
    spectroskyflux_r real NOT NULL,    --/U nanomaggy --/D Sky spectrum projected onto SDSS-r filter  
    spectroskyflux_i real NOT NULL,    --/U nanomaggy --/D Sky spectrum projected onto SDSS-i filter  
    spectroskyflux_z real NOT NULL,    --/U nanomaggy --/D Sky spectrum projected onto SDSS-z filter  
    wavemin real NOT NULL,    --/U AA --/D Minimum observed (vacuum) wavelength for target  
    wavemax real NOT NULL,    --/U AA --/D Maximum observed (vacuum) wavelength for target  
    wcoverage real NOT NULL,    --/U log10(AA) --/D Amount of wavelength coverage in log-10(Angs)  
    class varchar(6) NOT NULL,   --/D Spectro classification: GALAXY, QSO, STAR  
    subclass varchar(21) NOT NULL,   --/D Spectro sub-classification  
    z real NOT NULL,   --/D Redshift; incorrect for nonzero ZWARNING flag  
    z_err real NOT NULL,   --/D z error from chi^2 min; negative is invalid fit  
    zwarning bigint NOT NULL,   --/D A flag for bad z fits in place of CLASS=UNKNOWN  
    rchi2 real NOT NULL,   --/D Reduced chi^2 for best fit  
    dof bigint NOT NULL,   --/D Degrees of freedom for best fit  
    rchi2diff real NOT NULL,   --/D Diff in reduced chi^2 of 2 best solutions  
    tfile varchar(24) NOT NULL,   --/D Template file in $IDLSPEC2D_DIR/templates  
    tcolumn_1 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_2 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_3 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_4 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_5 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_6 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_7 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_8 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_9 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    tcolumn_10 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  
    npoly bigint NOT NULL,   --/D # of polynomial terms with TFILE  
    theta_1 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_2 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_3 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_4 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_5 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_6 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_7 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_8 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_9 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    theta_10 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  
    vdisp real NOT NULL,    --/U km/s --/D Velocity dispersion, only computed for galaxies  
    vdisp_err real NOT NULL,    --/U km/s --/D Error in VDISP; negative for invalid fit  
    vdispz real NOT NULL,   --/D Redshift for best-fit velocity dispersion  
    vdispz_err real NOT NULL,   --/D Error in VDISPZ  
    vdispchi2 real NOT NULL,   --/D Chi^2 for best-fit velocity dispersion  
    vdispnpix real NOT NULL,   --/D Num of pixels overlapping VDISP fit templates  
    vdispdof bigint NOT NULL,   --/D Degrees of freedom for best-fit velocity dispersion, equal to VDISPNPIX minus the number of templates minus the number of polynomial terms minus 1 (the last 1 is for the velocity dispersion)  
    chi68p real NOT NULL,   --/D 68% of abs(chi) of synthetic to actual spectrum  
    fracnsigma_1 real NOT NULL,   --/D Fraction of pixels deviant by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_2 real NOT NULL,   --/D Fraction of pixels deviant by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_3 real NOT NULL,   --/D Fraction of pixels deviant by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_4 real NOT NULL,   --/D Fraction of pixels deviant by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_5 real NOT NULL,   --/D Fraction of pixels deviant by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_6 real NOT NULL,   --/D Fraction of pixels deviant by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_7 real NOT NULL,   --/D Fraction of pixels deviant by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_8 real NOT NULL,   --/D Fraction of pixels deviant by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_9 real NOT NULL,   --/D Fraction of pixels deviant by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsigma_10 real NOT NULL,   --/D Fraction of pixels deviant by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_1 real NOT NULL,   --/D Fraction of pixels high by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_2 real NOT NULL,   --/D Fraction of pixels high by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_3 real NOT NULL,   --/D Fraction of pixels high by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_4 real NOT NULL,   --/D Fraction of pixels high by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_5 real NOT NULL,   --/D Fraction of pixels high by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_6 real NOT NULL,   --/D Fraction of pixels high by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_7 real NOT NULL,   --/D Fraction of pixels high by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_8 real NOT NULL,   --/D Fraction of pixels high by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_9 real NOT NULL,   --/D Fraction of pixels high by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsighi_10 real NOT NULL,   --/D Fraction of pixels high by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_1 real NOT NULL,   --/D Fraction of pixels low by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_2 real NOT NULL,   --/D Fraction of pixels low by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_3 real NOT NULL,   --/D Fraction of pixels low by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_4 real NOT NULL,   --/D Fraction of pixels low by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_5 real NOT NULL,   --/D Fraction of pixels low by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_6 real NOT NULL,   --/D Fraction of pixels low by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_7 real NOT NULL,   --/D Fraction of pixels low by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_8 real NOT NULL,   --/D Fraction of pixels low by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_9 real NOT NULL,   --/D Fraction of pixels low by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_10 real NOT NULL,   --/D Fraction of pixels low by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang)  
    z_noqso real NOT NULL,   --/D Redshift of the best-fit non-QSO model (recommended for CMASS and LOZ)  
    z_err_noqso real NOT NULL,   --/D Formal one-sigma error on Z_NOQSO (recommended for CMASS and LOZ)  
    znum_noqso bigint NOT NULL,   --/D Best fit z/class index excluding QSO; 1-indexed (recommended for CMASS and LOZ)  
    zwarning_noqso bigint NOT NULL,   --/D Redshift warning flag for Z_NOQSO (recommended for CMASS and LOZ)  
    class_noqso varchar(6) NOT NULL,   --/D Spectro class of best-fit non-QSO model (recommended for CMASS and LOZ)  
    subclass_noqso varchar(21) NOT NULL,   --/D Spectro sub-class of best-fit non-QSO model (recommended for CMASS and LOZ)  
    rchi2diff_noqso real NOT NULL,   --/D Reduced chi^2 diff to next-best non-QSO model (recommended for CMASS and LOZ)  
    xcsao_rv real NOT NULL,    --/U km/s --/D Radial velocity measured with pyXCSAO  
    xcsao_erv real NOT NULL,    --/U km/s --/D Uncertainty in Radial velocity  
    xcsao_rxc real NOT NULL,   --/D Cross correlation strength from pyXCSAO  
    xcsao_teff real NOT NULL,    --/U K --/D Interpolated temperature from pyXCSAO  
    xcsao_eteff real NOT NULL,    --/U K --/D Uncertainty in Interpolated temperature  
    xcsao_logg real NOT NULL,    --/U cm/s^2 --/D Interpolated surface gravity from pyXCSAO  
    xcsao_elogg real NOT NULL,    --/U cm/s^2 --/D Uncertainty in Interpolated surface gravity  
    xcsao_feh real NOT NULL,    --/U solar --/D Interpolated metallicity from pyXCSAO  
    xcsao_efeh real NOT NULL,    --/U solar --/D Uncertainty in interpolated metallicity  
	htmid bigint not null, --/D the htmid
	cx float, --/D cx coordinate
	cy float, --/D cy coordinate
	cz float, --/D cz coordinate
)
GO
--


if exists (select * from dbo.sysobjects 
	where id = object_id(N'spAll_allepoch')) 
	drop table [spAll_allepoch]
GO
--
CREATE TABLE spAll_allepoch (
--------------------------------------------------------------------------------
--/H Summary spectroscopic information for the BOSS spectrograph data custom Coadds
--
--/T This is a base table containing the summary spectroscopic information
--/T for the BOSS spectrograph data coadded on custom target level
--/T requirements
--------------------------------------------------------------------------------
    field bigint NOT NULL,   --/D SDSS FieldID (plateID for plate era data)  
    mjd bigint NOT NULL,   --/D Modified Julian date of combined Spectra  
    obs varchar(3) NOT NULL,   --/D Observatory of Observation  
    mjd_final float NOT NULL,   --/D Mean MJD of the Coadded Spectra  
    mjd_list varchar(173) NOT NULL,   --/D List of MJD of each included exposures  
    tai_list varchar(318) NOT NULL,   --/D List Tai for each exposure (at midpoint)  
    run2d varchar(6) NOT NULL,   --/D Spectro-2D reduction name  
    run1d varchar(6) NOT NULL,   --/D Spectro-1D reduction name  
    designs varchar(139) NOT NULL,   --/D List of Included Designs  
    configs varchar(173) NOT NULL,   --/D List of Included Configurations  
    nexp smallint NOT NULL,   --/D Number of Included Exposures  
    exptime real NOT NULL,    --/U s --/D Total Exposure time of Coadded Spectra  
    target_index bigint NOT NULL,   --/D Index of target on combined spField  
    fiberid_list varchar(115) NOT NULL,   --/D List of FiberIDs contributing to Stack  
    spec_file varchar(42) NOT NULL,   --/D Name of spec file (in SAS)  
    programname varchar(14) NOT NULL,   --/D Program name within a given survey  
    survey varchar(13) NOT NULL,   --/D Survey that field is part of  
    cadence varchar(19) NOT NULL,   --/D Requested Target Cadence  
    firstcarton varchar(48) NOT NULL,   --/D Primary SDSS Carton for target  
    carton_to_target_pk varchar(32) NOT NULL,   --/D SDSS-V CartonToTarget DB Table Primary Key  
    objtype varchar(16) NOT NULL,   --/D Why this object was targeted.  Note that if this field says QSO, it could be the case that this object would have been targetted as a GALAXY or any number of other categories as well. The PRIMTARGET and SECTARGET flags in the plug-map structure (in the spField file) gives this full information.  
    catalogid bigint NOT NULL,   --/D SDSS-V CatalogID used in naming  
    catalogid_v0 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v0  
    catalogid_v0p5 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v0.5  
    sdss_id bigint NOT NULL,   --/D Unified SDSS Target Identifier  
    specobjid numeric(30) NOT NULL,   --/D Unique ID based on Field, MJD, SDSSID, RUN2D, COADD type  
    calibflux_u real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-u from PSFmag --/F CALIBFLUX 
    calibflux_g real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-g from PSFmag --/F CALIBFLUX  
    calibflux_r real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-r from PSFmag --/F CALIBFLUX  
    calibflux_i real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-i from PSFmag --/F CALIBFLUX  
    calibflux_z real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-z from PSFmag --/F CALIBFLUX  
    calibflux_ivar_u real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-u from PSFmag --/F CALIBFLUX_IVAR  
    calibflux_ivar_g real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-g from PSFmag --/F CALIBFLUX_IVAR  
    calibflux_ivar_r real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-r from PSFmag --/F CALIBFLUX_IVAR  
    calibflux_ivar_i real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-i from PSFmag --/F CALIBFLUX_IVAR  
    calibflux_ivar_z real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-z from PSFmag --/F CALIBFLUX_IVAR  
    optical_prov varchar(26) NOT NULL,   --/D The source of the optical CATDB_MAG magnitudes  
    mag_u real NOT NULL,   --/D u optical magnitudes --/F MAG  
    mag_g real NOT NULL,   --/D g optical magnitudes --/F MAG  
    mag_r real NOT NULL,   --/D r optical magnitudes --/F MAG  
    mag_i real NOT NULL,   --/D i optical magnitudes --/F MAG  
    mag_z real NOT NULL,   --/D z optical magnitudes --/F MAG  
    psfmag_u real NOT NULL,   --/D u optical PSF magnitudes --/F PSFMAG  
    psfmag_g real NOT NULL,   --/D g optical PSF magnitudes --/F PSFMAG  
    psfmag_r real NOT NULL,   --/D r optical PSF magnitudes --/F PSFMAG  
    psfmag_i real NOT NULL,   --/D i optical PSF magnitudes --/F PSFMAG  
    psfmag_z real NOT NULL,   --/D z optical PSF magnitudes --/F PSFMAG  
    fiber2mag_u real NOT NULL,   --/D u optical Fiber2 magnitudes --/F FIBER2MAG 
    fiber2mag_g real NOT NULL,   --/D g optical Fiber2 magnitudes --/F FIBER2MAG  
    fiber2mag_r real NOT NULL,   --/D r optical Fiber2 magnitudes --/F FIBER2MAG  
    fiber2mag_i real NOT NULL,   --/D i optical Fiber2 magnitudes --/F FIBER2MAG  
    fiber2mag_z real NOT NULL,   --/D z optical Fiber2 magnitudes --/F FIBER2MAG  
    catdb_mag_u real NOT NULL,   --/D u Raw TargetDB magnitudes --/F CATDB_MAG  
    catdb_mag_g real NOT NULL,   --/D g Raw TargetDB magnitudes --/F CATDB_MAG  
    catdb_mag_r real NOT NULL,   --/D r Raw TargetDB magnitudes --/F CATDB_MAG  
    catdb_mag_i real NOT NULL,   --/D i Raw TargetDB magnitudes --/F CATDB_MAG  
    catdb_mag_z real NOT NULL,   --/D z Raw TargetDB magnitudes --/F CATDB_MAG  
    gaia_g_mag real NOT NULL,   --/D Gaia G magnitude  
    gri_gaia_transform bigint NOT NULL,   --/D provenance of photometry in SDSS-V plate design  
    bp_mag real NOT NULL,   --/D Gaia BP magnitude  
    rp_mag real NOT NULL,   --/D Gaia RP magnitude  
    gaia_id bigint NOT NULL,   --/D Gaia DR2 SourceID  
    wise_mag_1 real NOT NULL,   --/D WISE W1 band magnitudes --/F WISE_MAG
    wise_mag_2 real NOT NULL,   --/D WISE W2 band magnitudes --/F WISE_MAG  
    wise_mag_3 real NOT NULL,   --/D WISE W3 band magnitudes --/F WISE_MAG  
    wise_mag_4 real NOT NULL,   --/D WISE W4 band magnitudes --/F WISE_MAG  
    twomass_mag_1 real NOT NULL,   --/D 2MASS J band magnitudes --/F TWOMASS_MAG   
    twomass_mag_2 real NOT NULL,   --/D 2MASS H band magnitudes --/F TWOMASS_MAG  
    twomass_mag_3 real NOT NULL,   --/D 2MASS Ks band magnitudes --/F TWOMASS_MAG  
    guvcat_mag_1 real NOT NULL,   --/D GALEX FUV band magnitudes --/F GUVCAT_MAG  
    guvcat_mag_2 real NOT NULL,   --/D GALEX NUV band magnitudes --/F GUVCAT_MAG  
    ebv real NOT NULL,   --/D dust extinction  
    ebv_type varchar(14) NOT NULL,   --/D Source of dust extinction  
    fiber_ra float NOT NULL,    --/U degrees --/D Fiber RA [J2000 for plate; at exp for FPS]  
    fiber_dec float NOT NULL,    --/U degrees --/D Fiber DEC [J2000 for plate; at exp for FPS]  
    plug_ra float NOT NULL,    --/U degrees --/D Object RA (drilled fiber position) [J2000]  
    plug_dec float NOT NULL,    --/U degrees --/D Object DEC (drilled fiber position) [J2000]  
    racat float NOT NULL,    --/U degrees --/D Catalog RA in ICRS coordinates at coord_epoch  
    deccat float NOT NULL,    --/U degrees --/D Catalog DEC in ICRS coordinates at coord_epoch  
    coord_epoch real NOT NULL,   --/D Epoch of the RACAT/DECCAT Catalog coordinates.  
    pmra real NOT NULL,    --/U mas/year --/D Proper motion in RA (pmra is a true angle)  
    pmdec real NOT NULL,    --/U mas/year --/D Proper motion in Dec  
    parallax real NOT NULL,    --/U mas --/D Parallax  
    ra_list varchar(318) NOT NULL,    --/U degrees --/D List of measured RA per exposure  
    dec_list varchar(289) NOT NULL,    --/U degrees --/D List of measured DEC per exposure  
    delta_ra_list varchar(115) NOT NULL,    --/U arcsec --/D List of designed RA offsets per exposure  
    delta_dec_list varchar(115) NOT NULL,    --/U arcsec --/D List of designed DEC offsets per exposure  
    fiber_offset bigint NOT NULL,   --/D Flag identifying the fiber was offset by design  
    xfocal varchar(260) NOT NULL,    --/U mm --/D Hole/robot x-axis position in focal plane  
    yfocal varchar(260) NOT NULL,    --/U mm --/D Hole/robot y-axis position in focal plane  
    zoffset real NOT NULL,    --/U microns --/D Backstopping offset distance  
    lambda_eff real NOT NULL,    --/U AA --/D Wavelength to optimize hole location for  
    bluefiber bigint NOT NULL,   --/D 1 if assigned target a blue fiber; 0 otherwise  
    healpix bigint NOT NULL,   --/D healpix pixel number of the RACAT and DECCAT coordinates, computed with healpix nside=128  
    healpixgrp bigint NOT NULL,   --/D Rounded-down integer value of healpix / 1000  
    healpix_path varchar(70) NOT NULL,   --/D Path to spec fits file in SAS healpix structure  
    fieldquality varchar(4) NOT NULL,   --/D Characterization of field quality  
    exp_disp_med float NOT NULL,   --/D Dispersion of Median Exposure Flux  
    fieldsn2 real NOT NULL,   --/D Overall (S/N)^2 for field; min of cameras  
    fieldsnr2g_list varchar(144) NOT NULL,   --/D Overall Field (S/N)^2 in g per exposure  
    fieldsnr2r_list varchar(152) NOT NULL,   --/D Overall Field (S/N)^2 in r per exposure  
    fieldsnr2i_list varchar(157) NOT NULL,   --/D Overall Field (S/N)^2 in i per exposure  
    spec1_g real NOT NULL,   --/D Fit (S/N)^2 at g=20.20 for spectrograph 1 (same value for 500 fibers)  
    spec1_r real NOT NULL,   --/D Fit (S/N)^2 at r=20.25 for spectrograph 1 (same value for 500 fibers)  
    spec1_i real NOT NULL,   --/D Fit (S/N)^2 at i=19.90 for spectrograph 1 (same value for 500 fibers)  
    spec2_g real NOT NULL,   --/D Fit (S/N)^2 at g=20.20 for spectrograph 2 (same value for 500 fibers)  
    spec2_r real NOT NULL,   --/D Fit (S/N)^2 at r=20.25 for spectrograph 2 (same value for 500 fibers)  
    spec2_i real NOT NULL,   --/D Fit (S/N)^2 at i=19.90 for spectrograph 2 (same value for 500 fibers)  
    sn_median_u real NOT NULL,   --/D Median S/N for all good pixels in SDSS-u --/F SN_MEDIAN 
    sn_median_g real NOT NULL,   --/D Median S/N for all good pixels in SDSS-g --/F SN_MEDIAN  
    sn_median_r real NOT NULL,   --/D Median S/N for all good pixels in SDSS-r --/F SN_MEDIAN  
    sn_median_i real NOT NULL,   --/D Median S/N for all good pixels in SDSS-i --/F SN_MEDIAN  
    sn_median_z real NOT NULL,   --/D Median S/N for all good pixels in SDSS-z --/F SN_MEDIAN  
    sn_median_all real NOT NULL,   --/D Median S/N for all good pixels in all filters  
    airmass real NOT NULL,   --/D Airmass at time of observation  
    seeing20 real NOT NULL,    --/U arcsecs --/D Mean 20% seeing during exposures (arcsec)  
    seeing50 real NOT NULL,    --/U arcsecs --/D Mean 50% seeing during exposures (arcsec)  
    seeing80 real NOT NULL,    --/U arcsecs --/D Mean 80% seeing during exposures (arcsec)  
    moon_dist varchar(144) NOT NULL,    --/U degrees --/D Mean Moon-target separation of Coadded Spectra  
    moon_phase varchar(144) NOT NULL,   --/D Mean Moon phase of the Coadded Spectra  
    assigned varchar(57) NOT NULL,   --/D Whether this fibre was assigned to a target  
    on_target varchar(57) NOT NULL,   --/D Whether this fibre is on target  
    valid varchar(57) NOT NULL,   --/D alpha and beta angles are valid  
    decollided varchar(57) NOT NULL,   --/D this positioner had to be moved to decollide it  
    anyandmask bigint NOT NULL,   --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK  
    anyormask bigint NOT NULL,   --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK  
    specprimary tinyint NOT NULL,   --/D Objects observed multiple times will have this set to 1 for one observation only. This is usually the 'best' observation, as defined by critera listed in fieldmerge.py.  
    specboss bigint NOT NULL,   --/D Best version of spectrum at this location  
    boss_specobj_id bigint NOT NULL,   --/D ID of spectrum location on sky  
    nspecobs bigint NOT NULL,   --/D Number of spectral observations  
    spectroflux_u real NOT NULL,   --/D Spectrum projected onto SDSS-u filter --/F SPECTROFLUX  
    spectroflux_g real NOT NULL,   --/D Spectrum projected onto SDSS-g filter --/F SPECTROFLUX  
    spectroflux_r real NOT NULL,   --/D Spectrum projected onto SDSS-r filter --/F SPECTROFLUX  
    spectroflux_i real NOT NULL,   --/D Spectrum projected onto SDSS-i filter --/F SPECTROFLUX  
    spectroflux_z real NOT NULL,   --/D Spectrum projected onto SDSS-z filter --/F SPECTROFLUX  
    spectroflux_ivar_u real NOT NULL,   --/D Inverse variance of SPECTROFLUX_u --/F SPECTROFLUX_IVAR  
    spectroflux_ivar_g real NOT NULL,   --/D Inverse variance of SPECTROFLUX_g --/F SPECTROFLUX_IVAR  
    spectroflux_ivar_r real NOT NULL,   --/D Inverse variance of SPECTROFLUX_r --/F SPECTROFLUX_IVAR  
    spectroflux_ivar_i real NOT NULL,   --/D Inverse variance of SPECTROFLUX_i --/F SPECTROFLUX_IVAR  
    spectroflux_ivar_z real NOT NULL,   --/D Inverse variance of SPECTROFLUX_z --/F SPECTROFLUX_IVAR  
    spectrosynflux_u real NOT NULL,   --/D Best-fit template projected onto SDSS-u --/F SPECTROSYNFLUX  
    spectrosynflux_g real NOT NULL,   --/D Best-fit template projected onto SDSS-g --/F SPECTROSYNFLUX  
    spectrosynflux_r real NOT NULL,   --/D Best-fit template projected onto SDSS-r --/F SPECTROSYNFLUX  
    spectrosynflux_i real NOT NULL,   --/D Best-fit template projected onto SDSS-i --/F SPECTROSYNFLUX  
    spectrosynflux_z real NOT NULL,   --/D Best-fit template projected onto SDSS-z --/F SPECTROSYNFLUX  
    spectrosynflux_ivar_u real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_u --/F SPECTROSYNFLUX_IVAR  
    spectrosynflux_ivar_g real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_g --/F SPECTROSYNFLUX_IVAR  
    spectrosynflux_ivar_r real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_r --/F SPECTROSYNFLUX_IVAR  
    spectrosynflux_ivar_i real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_i --/F SPECTROSYNFLUX_IVAR  
    spectrosynflux_ivar_z real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_z --/F SPECTROSYNFLUX_IVAR  
    spectroskyflux_u real NOT NULL,   --/D Sky spectrum projected onto SDSS-u filter --/F SPECTROSKYFLUX  
    spectroskyflux_g real NOT NULL,   --/D Sky spectrum projected onto SDSS-g filter --/F SPECTROSKYFLUX  
    spectroskyflux_r real NOT NULL,   --/D Sky spectrum projected onto SDSS-r filter --/F SPECTROSKYFLUX  
    spectroskyflux_i real NOT NULL,   --/D Sky spectrum projected onto SDSS-i filter --/F SPECTROSKYFLUX  
    spectroskyflux_z real NOT NULL,   --/D Sky spectrum projected onto SDSS-z filter --/F SPECTROSKYFLUX  
    wavemin real NOT NULL,    --/U AA --/D Minimum observed (vacuum) wavelength for target  
    wavemax real NOT NULL,    --/U AA --/D Maximum observed (vacuum) wavelength for target  
    wcoverage real NOT NULL,    --/U log10(AA) --/D Amount of wavelength coverage in log-10(Angs)  
    class varchar(6) NOT NULL,   --/D Spectro classification: GALAXY, QSO, STAR  
    subclass varchar(21) NOT NULL,   --/D Spectro sub-classification  
    z real NOT NULL,   --/D Redshift; incorrect for nonzero ZWARNING flag  
    z_err real NOT NULL,   --/D z error from chi^2 min; negative is invalid fit  
    zwarning bigint NOT NULL,   --/D A flag for bad z fits in place of CLASS=UNKNOWN  
    rchi2 real NOT NULL,   --/D Reduced chi^2 for best fit  
    dof bigint NOT NULL,   --/D Degrees of freedom for best fit  
    rchi2diff real NOT NULL,   --/D Diff in reduced chi^2 of 2 best solutions  
    tfile varchar(24) NOT NULL,   --/D Template file in $IDLSPEC2D_DIR/templates  
    tcolumn_1 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN 
    tcolumn_2 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_3 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_4 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_5 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_6 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_7 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_8 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_9 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_10 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    npoly bigint NOT NULL,   --/D # of polynomial terms with TFILE  
    theta_1 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_2 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_3 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_4 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_5 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_6 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_7 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_8 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_9 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_10 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    vdisp real NOT NULL,    --/U km/s --/D Velocity dispersion, only computed for galaxies  
    vdisp_err real NOT NULL,    --/U km/s --/D Error in VDISP; negative for invalid fit  
    vdispz real NOT NULL,   --/D Redshift for best-fit velocity dispersion  
    vdispz_err real NOT NULL,   --/D Error in VDISPZ  
    vdispchi2 real NOT NULL,   --/D Chi^2 for best-fit velocity dispersion  
    vdispnpix real NOT NULL,   --/D Num of pixels overlapping VDISP fit templates  
    vdispdof bigint NOT NULL,   --/D Degrees of freedom for best-fit velocity dispersion, equal to VDISPNPIX minus the number of templates minus the number of polynomial terms minus 1 (the last 1 is for the velocity dispersion)  
    chi68p real NOT NULL,   --/D 68% of abs(chi) of synthetic to actual spectrum  
    fracnsigma_1 real NOT NULL,   --/D Fraction of pixels low by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_2 real NOT NULL,   --/D Fraction of pixels low by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_3 real NOT NULL,   --/D Fraction of pixels low by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_4 real NOT NULL,   --/D Fraction of pixels low by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_5 real NOT NULL,   --/D Fraction of pixels low by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_6 real NOT NULL,   --/D Fraction of pixels low by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_7 real NOT NULL,   --/D Fraction of pixels low by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_8 real NOT NULL,   --/D Fraction of pixels low by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_9 real NOT NULL,   --/D Fraction of pixels low by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_10 real NOT NULL,   --/D Fraction of pixels low by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsighi_1 real NOT NULL,   --/D Fraction of pixels high by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_2 real NOT NULL,   --/D Fraction of pixels high by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_3 real NOT NULL,   --/D Fraction of pixels high by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_4 real NOT NULL,   --/D Fraction of pixels high by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_5 real NOT NULL,   --/D Fraction of pixels high by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_6 real NOT NULL,   --/D Fraction of pixels high by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_7 real NOT NULL,   --/D Fraction of pixels high by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_8 real NOT NULL,   --/D Fraction of pixels high by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_9 real NOT NULL,   --/D Fraction of pixels high by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_10 real NOT NULL,   --/D Fraction of pixels high by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsiglo_1 real NOT NULL,   --/D Fraction of pixels deviant by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_2 real NOT NULL,   --/D Fraction of pixels deviant by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_3 real NOT NULL,   --/D Fraction of pixels deviant by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_4 real NOT NULL,   --/D Fraction of pixels deviant by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_5 real NOT NULL,   --/D Fraction of pixels deviant by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_6 real NOT NULL,   --/D Fraction of pixels deviant by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_7 real NOT NULL,   --/D Fraction of pixels deviant by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_8 real NOT NULL,   --/D Fraction of pixels deviant by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_9 real NOT NULL,   --/D Fraction of pixels deviant by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_10 real NOT NULL,   --/D Fraction of pixels deviant by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    z_noqso real NOT NULL,   --/D Redshift of the best-fit non-QSO model (recommended for CMASS and LOZ)  
    z_err_noqso real NOT NULL,   --/D Formal one-sigma error on Z_NOQSO (recommended for CMASS and LOZ)  
    znum_noqso bigint NOT NULL,   --/D Best fit z/class index excluding QSO; 1-indexed (recommended for CMASS and LOZ)  
    zwarning_noqso bigint NOT NULL,   --/D Redshift warning flag for Z_NOQSO (recommended for CMASS and LOZ)  
    class_noqso varchar(6) NOT NULL,   --/D Spectro class of best-fit non-QSO model (recommended for CMASS and LOZ)  
    subclass_noqso varchar(21) NOT NULL,   --/D Spectro sub-class of best-fit non-QSO model (recommended for CMASS and LOZ)  
    rchi2diff_noqso real NOT NULL,   --/D Reduced chi^2 diff to next-best non-QSO model (recommended for CMASS and LOZ)  
    xcsao_rv real NOT NULL,    --/U km/s --/D Radial velocity measured with pyXCSAO  
    xcsao_erv real NOT NULL,    --/U km/s --/D Uncertainty in Radial velocity  
    xcsao_rxc real NOT NULL,   --/D Cross correlation strength from pyXCSAO  
    xcsao_teff real NOT NULL,    --/U K --/D Interpolated temperature from pyXCSAO  
    xcsao_eteff real NOT NULL,    --/U K --/D Uncertainty in Interpolated temperature  
    xcsao_logg real NOT NULL,    --/U cm/s^2 --/D Interpolated surface gravity from pyXCSAO  
    xcsao_elogg real NOT NULL,    --/U cm/s^2 --/D Uncertainty in Interpolated surface gravity  
    xcsao_feh real NOT NULL,    --/U solar --/D Interpolated metallicity from pyXCSAO  
    xcsao_efeh real NOT NULL,    --/U solar --/D Uncertainty in interpolated metallicity  
)
GO
--



if exists (select * from dbo.sysobjects 
	where id = object_id(N'spAll_epoch')) 
	drop table [spAll_epoch]
GO
--
CREATE TABLE spAll_epoch (
--------------------------------------------------------------------------------
--/H Summary spectroscopic information for the BOSS spectrograph data Field Epoch Coadds
--
--/T This is a base table containing the summary spectroscopic information
--/T for the BOSS spectrograph data coadded based on field epoch cadence
--/T requirements
--------------------------------------------------------------------------------
    field bigint NOT NULL,   --/D SDSS FieldID (plateID for plate era data)  
    mjd bigint NOT NULL,   --/D Modified Julian date of combined Spectra  
    obs varchar(3) NOT NULL,   --/D Observatory of Observation  
    mjd_final float NOT NULL,   --/D Mean MJD of the Coadded Spectra  
    mjd_list varchar(173) NOT NULL,   --/D List of MJD of each included exposures  
    tai_list varchar(318) NOT NULL,   --/D List Tai for each exposure (at midpoint)  
    run2d varchar(6) NOT NULL,   --/D Spectro-2D reduction name  
    run1d varchar(6) NOT NULL,   --/D Spectro-1D reduction name  
    designs varchar(139) NOT NULL,   --/D List of Included Designs  
    configs varchar(173) NOT NULL,   --/D List of Included Configurations  
    nexp smallint NOT NULL,   --/D Number of Included Exposures  
    exptime real NOT NULL,    --/U s --/D Total Exposure time of Coadded Spectra  
    target_index bigint NOT NULL,   --/D Index of target on combined spField  
    fiberid_list varchar(115) NOT NULL,   --/D List of FiberIDs contributing to Stack  
    spec_file varchar(42) NOT NULL,   --/D Name of spec file (in SAS)  
    programname varchar(14) NOT NULL,   --/D Program name within a given survey  
    survey varchar(13) NOT NULL,   --/D Survey that field is part of  
    cadence varchar(19) NOT NULL,   --/D Requested Target Cadence  
    firstcarton varchar(48) NOT NULL,   --/D Primary SDSS Carton for target  
    carton_to_target_pk varchar(32) NOT NULL,   --/D SDSS-V CartonToTarget DB Table Primary Key  
    objtype varchar(16) NOT NULL,   --/D Why this object was targeted.  Note that if this field says QSO, it could be the case that this object would have been targeted as a GALAXY or any number of other categories as well. The PRIMTARGET and SECTARGET flags in the plug-map structure (in the spField file) gives this full information.  
    catalogid bigint NOT NULL,   --/D SDSS-V CatalogID used in naming  
    catalogid_v0 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v0  
    catalogid_v0p5 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v0.5  
    sdss_id bigint NOT NULL,   --/D Unified SDSS Target Identifier  
    specobjid numeric(30) NOT NULL,   --/D Unique ID based on Field, MJD, SDSSID, RUN2D, COADD type  
    calibflux_u real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-u from PSFmag --/F CALIBFLUX  
    calibflux_g real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-g from PSFmag --/F CALIBFLUX  
    calibflux_r real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-r from PSFmag --/F CALIBFLUX  
    calibflux_i real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-i from PSFmag --/F CALIBFLUX  
    calibflux_z real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-z from PSFmag --/F CALIBFLUX  
    calibflux_ivar_u real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-u from PSFmag --/F CALIBFLUX_IVAR  
    calibflux_ivar_g real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-g from PSFmag --/F CALIBFLUX_IVAR  
    calibflux_ivar_r real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-r from PSFmag --/F CALIBFLUX_IVAR  
    calibflux_ivar_i real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-i from PSFmag --/F CALIBFLUX_IVAR  
    calibflux_ivar_z real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-z from PSFmag --/F CALIBFLUX_IVAR  
    optical_prov varchar(26) NOT NULL,   --/D The source of the optical CATDB_MAG magnitudes  
    mag_u real NOT NULL,   --/D u optical magnitudes --/F MAG  
    mag_g real NOT NULL,   --/D g optical magnitudes --/F MAG  
    mag_r real NOT NULL,   --/D r optical magnitudes --/F MAG  
    mag_i real NOT NULL,   --/D i optical magnitudes --/F MAG  
    mag_z real NOT NULL,   --/D z optical magnitudes --/F MAG  
    psfmag_u real NOT NULL,   --/D u optical PSF magnitudes --/F PSFMAG  
    psfmag_g real NOT NULL,   --/D g optical PSF magnitudes --/F PSFMAG  
    psfmag_r real NOT NULL,   --/D r optical PSF magnitudes --/F PSFMAG  
    psfmag_i real NOT NULL,   --/D i optical PSF magnitudes --/F PSFMAG  
    psfmag_z real NOT NULL,   --/D z optical PSF magnitudes --/F PSFMAG  
    fiber2mag_u real NOT NULL,   --/D u optical Fiber2 magnitudes --/F FIBER2MAG  
    fiber2mag_g real NOT NULL,   --/D g optical Fiber2 magnitudes --/F FIBER2MAG  
    fiber2mag_r real NOT NULL,   --/D r optical Fiber2 magnitudes --/F FIBER2MAG  
    fiber2mag_i real NOT NULL,   --/D i optical Fiber2 magnitudes --/F FIBER2MAG  
    fiber2mag_z real NOT NULL,   --/D z optical Fiber2 magnitudes --/F FIBER2MAG  
    catdb_mag_u real NOT NULL,   --/D u Raw TargetDB magnitudes --/F CATDB_MAG  
    catdb_mag_g real NOT NULL,   --/D g Raw TargetDB magnitudes --/F CATDB_MAG  
    catdb_mag_r real NOT NULL,   --/D r Raw TargetDB magnitudes --/F CATDB_MAG  
    catdb_mag_i real NOT NULL,   --/D i Raw TargetDB magnitudes --/F CATDB_MAG  
    catdb_mag_z real NOT NULL,   --/D z Raw TargetDB magnitudes --/F CATDB_MAG  
    gaia_g_mag real NOT NULL,   --/D Gaia G magnitude  
    gri_gaia_transform bigint NOT NULL,   --/D provenance of photometry in SDSS-V plate design  
    bp_mag real NOT NULL,   --/D Gaia BP magnitude  
    rp_mag real NOT NULL,   --/D Gaia RP magnitude  
    gaia_id bigint NOT NULL,   --/D Gaia DR2 SourceID  
    wise_mag_1 real NOT NULL,   --/D WISE W1 band magnitudes --/F WISE_MAG  
    wise_mag_2 real NOT NULL,   --/D WISE W2 band magnitudes --/F WISE_MAG  
    wise_mag_3 real NOT NULL,   --/D WISE W3 band magnitudes --/F WISE_MAG  
    wise_mag_4 real NOT NULL,   --/D WISE W4 band magnitudes --/F WISE_MAG  
    twomass_mag_1 real NOT NULL,   --/D 2MASS J band magnitudes --/F TWOMASS_MAG  
    twomass_mag_2 real NOT NULL,   --/D 2MASS H band magnitudes --/F TWOMASS_MAG  
    twomass_mag_3 real NOT NULL,   --/D 2MASS Ks band magnitudes --/F TWOMASS_MAG  
    guvcat_mag_1 real NOT NULL,   --/D GALEX FUV band magnitudes --/F GUVCAT_MAG  
    guvcat_mag_2 real NOT NULL,   --/D GALEX NUV band magnitudes --/F GUVCAT_MAG  
    ebv real NOT NULL,   --/D dust extinction  
    ebv_type varchar(14) NOT NULL,   --/D Source of dust extinction  
    fiber_ra float NOT NULL,    --/U degrees --/D Fiber RA [J2000 for plate; at exp for FPS]  
    fiber_dec float NOT NULL,    --/U degrees --/D Fiber DEC [J2000 for plate; at exp for FPS]  
    plug_ra float NOT NULL,    --/U degrees --/D Object RA (drilled fiber position) [J2000]  
    plug_dec float NOT NULL,    --/U degrees --/D Object DEC (drilled fiber position) [J2000]  
    racat float NOT NULL,    --/U degrees --/D Catalog RA in ICRS coordinates at coord_epoch  
    deccat float NOT NULL,    --/U degrees --/D Catalog DEC in ICRS coordinates at coord_epoch  
    coord_epoch real NOT NULL,   --/D Epoch of the RACAT/DECCAT Catalog coordinates.  
    pmra real NOT NULL,    --/U mas/year --/D Proper motion in RA (pmra is a true angle)  
    pmdec real NOT NULL,    --/U mas/year --/D Proper motion in Dec  
    parallax real NOT NULL,    --/U mas --/D Parallax  
    ra_list varchar(318) NOT NULL,    --/U degrees --/D List of measured RA per exposure  
    dec_list varchar(289) NOT NULL,    --/U degrees --/D List of measured DEC per exposure  
    delta_ra_list varchar(115) NOT NULL,    --/U arcsec --/D List of designed RA offsets per exposure  
    delta_dec_list varchar(115) NOT NULL,    --/U arcsec --/D List of designed DEC offsets per exposure  
    fiber_offset bigint NOT NULL,   --/D Flag identifying the fiber was offset by design  
    xfocal varchar(260) NOT NULL,    --/U mm --/D Hole/robot x-axis position in focal plane  
    yfocal varchar(260) NOT NULL,    --/U mm --/D Hole/robot y-axis position in focal plane  
    zoffset real NOT NULL,    --/U microns --/D Backstopping offset distance  
    lambda_eff real NOT NULL,    --/U AA --/D Wavelength to optimize hole location for  
    bluefiber bigint NOT NULL,   --/D 1 if assigned target a blue fiber; 0 otherwise  
    healpix bigint NOT NULL,   --/D healpix pixel number of the RACAT and DECCAT coordinates, computed with healpix nside=128  
    healpixgrp bigint NOT NULL,   --/D Rounded-down integer value of healpix / 1000  
    healpix_path varchar(70) NOT NULL,   --/D Path to spec fits file in SAS healpix structure  
    fieldquality varchar(4) NOT NULL,   --/D Characterization of field quality  
    exp_disp_med float NOT NULL,   --/D Dispersion of Median Exposure Flux  
    fieldsn2 real NOT NULL,   --/D Overall (S/N)^2 for field; min of cameras  
    fieldsnr2g_list varchar(144) NOT NULL,   --/D Overall Field (S/N)^2 in g per exposure  
    fieldsnr2r_list varchar(152) NOT NULL,   --/D Overall Field (S/N)^2 in r per exposure  
    fieldsnr2i_list varchar(157) NOT NULL,   --/D Overall Field (S/N)^2 in i per exposure  
    spec1_g real NOT NULL,   --/D Fit (S/N)^2 at g=20.20 for spectrograph 1 (same value for 500 fibers)  
    spec1_r real NOT NULL,   --/D Fit (S/N)^2 at r=20.25 for spectrograph 1 (same value for 500 fibers)  
    spec1_i real NOT NULL,   --/D Fit (S/N)^2 at i=19.90 for spectrograph 1 (same value for 500 fibers)  
    spec2_g real NOT NULL,   --/D Fit (S/N)^2 at g=20.20 for spectrograph 2 (same value for 500 fibers)  
    spec2_r real NOT NULL,   --/D Fit (S/N)^2 at r=20.25 for spectrograph 2 (same value for 500 fibers)  
    spec2_i real NOT NULL,   --/D Fit (S/N)^2 at i=19.90 for spectrograph 2 (same value for 500 fibers)  
    sn_median_u real NOT NULL,   --/D Median S/N for all good pixels in SDSS-u --/F SN_MEDIAN  
    sn_median_g real NOT NULL,   --/D Median S/N for all good pixels in SDSS-g --/F SN_MEDIAN  
    sn_median_r real NOT NULL,   --/D Median S/N for all good pixels in SDSS-r --/F SN_MEDIAN  
    sn_median_i real NOT NULL,   --/D Median S/N for all good pixels in SDSS-i --/F SN_MEDIAN  
    sn_median_z real NOT NULL,   --/D Median S/N for all good pixels in SDSS-z --/F SN_MEDIAN  
    sn_median_all real NOT NULL,   --/D Median S/N for all good pixels in all filters  
    airmass real NOT NULL,   --/D Airmass at time of observation  
    seeing20 real NOT NULL,    --/U arcsecs --/D Mean 20% seeing during exposures (arcsec)  
    seeing50 real NOT NULL,    --/U arcsecs --/D Mean 50% seeing during exposures (arcsec)  
    seeing80 real NOT NULL,    --/U arcsecs --/D Mean 80% seeing during exposures (arcsec)  
    moon_dist varchar(144) NOT NULL,    --/U degrees --/D Mean Moon-target separation of Coadded Spectra  
    moon_phase varchar(144) NOT NULL,   --/D Mean Moon phase of the Coadded Spectra  
    assigned varchar(57) NOT NULL,   --/D Whether this fibre was assigned to a target  
    on_target varchar(57) NOT NULL,   --/D Whether this fibre is on target  
    valid varchar(57) NOT NULL,   --/D alpha and beta angles are valid  
    decollided varchar(57) NOT NULL,   --/D this positioner had to be moved to decollide it  
    anyandmask bigint NOT NULL,   --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK  
    anyormask bigint NOT NULL,   --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK  
    specprimary tinyint NOT NULL,   --/D Objects observed multiple times will have this set to 1 for one observation only. This is usually the 'best' observation, as defined by critera listed in fieldmerge.py.  
    specboss bigint NOT NULL,   --/D Best version of spectrum at this location  
    boss_specobj_id bigint NOT NULL,   --/D ID of spectrum location on sky  
    nspecobs bigint NOT NULL,   --/D Number of spectral observations  
    spectroflux_u real NOT NULL,   --/D Spectrum projected onto SDSS-u filter --/F SPECTROFLUX  
    spectroflux_g real NOT NULL,   --/D Spectrum projected onto SDSS-g filter --/F SPECTROFLUX  
    spectroflux_r real NOT NULL,   --/D Spectrum projected onto SDSS-r filter --/F SPECTROFLUX  
    spectroflux_i real NOT NULL,   --/D Spectrum projected onto SDSS-i filter --/F SPECTROFLUX  
    spectroflux_z real NOT NULL,   --/D Spectrum projected onto SDSS-z filter --/F SPECTROFLUX  
    spectroflux_ivar_u real NOT NULL,   --/D Inverse variance of SPECTROFLUX_u --/F SPECTROFLUX_IVAR  
    spectroflux_ivar_g real NOT NULL,   --/D Inverse variance of SPECTROFLUX_g --/F SPECTROFLUX_IVAR  
    spectroflux_ivar_r real NOT NULL,   --/D Inverse variance of SPECTROFLUX_r --/F SPECTROFLUX_IVAR  
    spectroflux_ivar_i real NOT NULL,   --/D Inverse variance of SPECTROFLUX_i --/F SPECTROFLUX_IVAR  
    spectroflux_ivar_z real NOT NULL,   --/D Inverse variance of SPECTROFLUX_z --/F SPECTROFLUX_IVAR  
    spectrosynflux_u real NOT NULL,   --/D Best-fit template projected onto SDSS-u --/F SPECTROSYNFLUX  
    spectrosynflux_g real NOT NULL,   --/D Best-fit template projected onto SDSS-g --/F SPECTROSYNFLUX  
    spectrosynflux_r real NOT NULL,   --/D Best-fit template projected onto SDSS-r --/F SPECTROSYNFLUX  
    spectrosynflux_i real NOT NULL,   --/D Best-fit template projected onto SDSS-i --/F SPECTROSYNFLUX  
    spectrosynflux_z real NOT NULL,   --/D Best-fit template projected onto SDSS-z --/F SPECTROSYNFLUX  
    spectrosynflux_ivar_u real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_u --/F SPECTROSYNFLUX_IVAR  
    spectrosynflux_ivar_g real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_g --/F SPECTROSYNFLUX_IVAR  
    spectrosynflux_ivar_r real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_r --/F SPECTROSYNFLUX_IVAR  
    spectrosynflux_ivar_i real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_i --/F SPECTROSYNFLUX_IVAR  
    spectrosynflux_ivar_z real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_z --/F SPECTROSYNFLUX_IVAR  
    spectroskyflux_u real NOT NULL,   --/D Sky spectrum projected onto SDSS-u filter --/F SPECTROSKYFLUX  
    spectroskyflux_g real NOT NULL,   --/D Sky spectrum projected onto SDSS-g filter --/F SPECTROSKYFLUX  
    spectroskyflux_r real NOT NULL,   --/D Sky spectrum projected onto SDSS-r filter --/F SPECTROSKYFLUX  
    spectroskyflux_i real NOT NULL,   --/D Sky spectrum projected onto SDSS-i filter --/F SPECTROSKYFLUX  
    spectroskyflux_z real NOT NULL,   --/D Sky spectrum projected onto SDSS-z filter --/F SPECTROSKYFLUX  
    wavemin real NOT NULL,    --/U AA --/D Minimum observed (vacuum) wavelength for target  
    wavemax real NOT NULL,    --/U AA --/D Maximum observed (vacuum) wavelength for target  
    wcoverage real NOT NULL,    --/U log10(AA) --/D Amount of wavelength coverage in log-10(Angs)  
    class varchar(6) NOT NULL,   --/D Spectro classification: GALAXY, QSO, STAR  
    subclass varchar(21) NOT NULL,   --/D Spectro sub-classification  
    z real NOT NULL,   --/D Redshift; incorrect for nonzero ZWARNING flag  
    z_err real NOT NULL,   --/D z error from chi^2 min; negative is invalid fit  
    zwarning bigint NOT NULL,   --/D A flag for bad z fits in place of CLASS=UNKNOWN  
    rchi2 real NOT NULL,   --/D Reduced chi^2 for best fit  
    dof bigint NOT NULL,   --/D Degrees of freedom for best fit  
    rchi2diff real NOT NULL,   --/D Diff in reduced chi^2 of 2 best solutions  
    tfile varchar(24) NOT NULL,   --/D Template file in $IDLSPEC2D_DIR/templates  
    tcolumn_1 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_2 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_3 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_4 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_5 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_6 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_7 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_8 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_9 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    tcolumn_10 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1 --/F TCOLUMN  
    npoly bigint NOT NULL,   --/D # of polynomial terms with TFILE  
    theta_1 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_2 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_3 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_4 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_5 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_6 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_7 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_8 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_9 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    theta_10 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial --/F THETA  
    vdisp real NOT NULL,    --/U km/s --/D Velocity dispersion, only computed for galaxies  
    vdisp_err real NOT NULL,    --/U km/s --/D Error in VDISP; negative for invalid fit  
    vdispz real NOT NULL,   --/D Redshift for best-fit velocity dispersion  
    vdispz_err real NOT NULL,   --/D Error in VDISPZ  
    vdispchi2 real NOT NULL,   --/D Chi^2 for best-fit velocity dispersion  
    vdispnpix real NOT NULL,   --/D Num of pixels overlapping VDISP fit templates  
    vdispdof bigint NOT NULL,   --/D Degrees of freedom for best-fit velocity dispersion, equal to VDISPNPIX minus the number of templates minus the number of polynomial terms minus 1 (the last 1 is for the velocity dispersion)  
    chi68p real NOT NULL,   --/D 68% of abs(chi) of synthetic to actual spectrum  
    fracnsigma_1 real NOT NULL,   --/D Fraction of pixels low by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_2 real NOT NULL,   --/D Fraction of pixels low by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_3 real NOT NULL,   --/D Fraction of pixels low by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_4 real NOT NULL,   --/D Fraction of pixels low by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_5 real NOT NULL,   --/D Fraction of pixels low by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_6 real NOT NULL,   --/D Fraction of pixels low by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_7 real NOT NULL,   --/D Fraction of pixels low by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_8 real NOT NULL,   --/D Fraction of pixels low by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_9 real NOT NULL,   --/D Fraction of pixels low by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsigma_10 real NOT NULL,   --/D Fraction of pixels low by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGMA  
    fracnsighi_1 real NOT NULL,   --/D Fraction of pixels high by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_2 real NOT NULL,   --/D Fraction of pixels high by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_3 real NOT NULL,   --/D Fraction of pixels high by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_4 real NOT NULL,   --/D Fraction of pixels high by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_5 real NOT NULL,   --/D Fraction of pixels high by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_6 real NOT NULL,   --/D Fraction of pixels high by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_7 real NOT NULL,   --/D Fraction of pixels high by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_8 real NOT NULL,   --/D Fraction of pixels high by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_9 real NOT NULL,   --/D Fraction of pixels high by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsighi_10 real NOT NULL,   --/D Fraction of pixels high by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGHI  
    fracnsiglo_1 real NOT NULL,   --/D Fraction of pixels low by >1 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_2 real NOT NULL,   --/D Fraction of pixels low by >2 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_3 real NOT NULL,   --/D Fraction of pixels low by >3 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_4 real NOT NULL,   --/D Fraction of pixels low by >4 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_5 real NOT NULL,   --/D Fraction of pixels low by >5 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_6 real NOT NULL,   --/D Fraction of pixels low by >6 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_7 real NOT NULL,   --/D Fraction of pixels low by >7 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_8 real NOT NULL,   --/D Fraction of pixels low by >8 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_9 real NOT NULL,   --/D Fraction of pixels low by >9 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    fracnsiglo_10 real NOT NULL,   --/D Fraction of pixels low by >10 sigma (ignoring all points blueward of rest-frame 1216 Ang) --/F FRACNSIGLO  
    z_noqso real NOT NULL,   --/D Redshift of the best-fit non-QSO model (recommended for CMASS and LOZ)  
    z_err_noqso real NOT NULL,   --/D Formal one-sigma error on Z_NOQSO (recommended for CMASS and LOZ)  
    znum_noqso bigint NOT NULL,   --/D Best fit z/class index excluding QSO; 1-indexed (recommended for CMASS and LOZ)  
    zwarning_noqso bigint NOT NULL,   --/D Redshift warning flag for Z_NOQSO (recommended for CMASS and LOZ)  
    class_noqso varchar(6) NOT NULL,   --/D Spectro class of best-fit non-QSO model (recommended for CMASS and LOZ)  
    subclass_noqso varchar(21) NOT NULL,   --/D Spectro sub-class of best-fit non-QSO model (recommended for CMASS and LOZ)  
    rchi2diff_noqso real NOT NULL,   --/D Reduced chi^2 diff to next-best non-QSO model (recommended for CMASS and LOZ)  
    xcsao_rv real NOT NULL,    --/U km/s --/D Radial velocity measured with pyXCSAO  
    xcsao_erv real NOT NULL,    --/U km/s --/D Uncertainty in Radial velocity  
    xcsao_rxc real NOT NULL,   --/D Cross correlation strength from pyXCSAO  
    xcsao_teff real NOT NULL,    --/U K --/D Interpolated temperature from pyXCSAO  
    xcsao_eteff real NOT NULL,    --/U K --/D Uncertainty in Interpolated temperature  
    xcsao_logg real NOT NULL,    --/U cm/s^2 --/D Interpolated surface gravity from pyXCSAO  
    xcsao_elogg real NOT NULL,    --/U cm/s^2 --/D Uncertainty in Interpolated surface gravity  
    xcsao_feh real NOT NULL,    --/U solar --/D Interpolated metallicity from pyXCSAO  
    xcsao_efeh real NOT NULL,    --/U solar --/D Uncertainty in interpolated metallicity  
)
GO



if exists (select * from dbo.sysobjects 
	where id = object_id(N'spAll_eFEDS')) 
	drop table [spAll_eFEDS]
GO
--
CREATE TABLE spAll_eFEDS (
-------------------------------------------------------------------------------
--/H Contains the summary results for combined boss spectra for the eFEDS program.
--
--/T This is a nonbase table (related to spAll) containing the summary spectroscopic
--/T information for combined (eFEDS) visits for BOSS spectrograph data.
--/T The catalogid is a unique column in this table, and can be joined to spAll for all visits.
-------------------------------------------------------------------------------
    programname     varchar(32) NOT NULL, --/D Program name within a given survey
    chunk           varchar(32) NOT NULL, --/D Name of tiling chunk
    survey          varchar(32) NOT NULL, --/D Survey that plate is part of
    platequality varchar(4) NOT NULL, --/D Characterization of plate quality
    platesn2 real NOT NULL,   --/D Overall (S/N)^2 measure for plate; minimum of all 2 cameras
    deredsn2 real NOT NULL,   --/D Dereddened (extinction corrected) (S/N)^2 measure for plate; minimum of 2 cameras
    primtarget bigint NOT NULL,   --/D Primary target flags
    sectarget bigint NOT NULL,   --/D Secondary target flags
    lambda_eff real NOT NULL,   --/D Wavelength to optimize hole location for, in Angstroms.
    bluefiber bigint NOT NULL,   --/D 1 if the BOSS instrument is meant to assign this target a "blue" fiber; 0 otherwise
    zoffset real NOT NULL,   --/D Backstopping offset distance, in microns.
    xfocal real NOT NULL,   --/D Hole x-axis position in focal plane (mm)
    yfocal real NOT NULL,   --/D Hole y-axis position in focal plane (mm)
    specprimary smallint NOT NULL, --/D  Objects observed multiple times will have this set to 1 for one observation only. This is usually the 'best' observation, as defined by critera listed in platemerge.pro. --/F specprimary
    specboss smallint NOT NULL, --/D Best version of spectrum at this location --/F specboss
    boss_specobj_id bigint NOT NULL,   --/D Same as SPECPRIMARY
    nspecobs smallint NOT NULL,   --/D Number of spectral observations
    calibflux_u real NOT NULL,   --/D Broad-band flux in SDSS-u computed from the input PSF photometric magnitudes
    calibflux_g real NOT NULL,   --/D Broad-band flux in SDSS-g computed from the input PSF photometric magnitudes 
    calibflux_r real NOT NULL,   --/D Broad-band flux in SDSS-r computed from the input PSF photometric magnitudes 
    calibflux_i real NOT NULL,   --/D Broad-band flux in SDSS-i computed from the input PSF photometric magnitudes 
    calibflux_z real NOT NULL,   --/D Broad-band flux in SDSS-z computed from the input PSF photometric magnitudes 
    calibflux_ivar_u real NOT NULL,   --/D Inverse variance in broad-band flux in SDSS-u computed from the input PSF photometric magnitudes
    calibflux_ivar_g real NOT NULL,   --/D Inverse variance in broad-band flux in SDSS-g computed from the input PSF photometric magnitudes
    calibflux_ivar_r real NOT NULL,   --/D Inverse variance in broad-band flux in SDSS-r computed from the input PSF photometric magnitudes
    calibflux_ivar_i real NOT NULL,   --/D Inverse variance in broad-band flux in SDSS-i computed from the input PSF photometric magnitudes
    calibflux_ivar_z real NOT NULL,   --/D Inverse variance in broad-band flux in SDSS-z computed from the input PSF photometric magnitudes
    gaia_bp real NOT NULL,   --/D Gaia DR2 G_BP magnitude
    gaia_rp real NOT NULL,   --/D Gaia DR2 G_RP magnitude 
    gaia_g real NOT NULL,   --/D  Gaia DR2 G magnitude
    firstcarton varchar(48) NOT NULL,   --/D Primary SDSS-V Carton for target
    mag_u real NOT NULL,   --/D SDSS-u Fiber2mag magnitude 
    mag_g real NOT NULL,   --/D SDSS-g Fiber2mag magnitude 
    mag_r real NOT NULL,   --/D SDSS-r Fiber2mag magnitude 
    mag_i real NOT NULL,   --/D SDSS-i Fiber2mag magnitude 
    mag_z real NOT NULL,   --/D SDSS-z Fiber2mag magnitude 
    plate numeric(20) NOT NULL,  --/D The number of the currently loaded plate
    designid smallint NOT NULL,   --/D SDSS-V DesignID
    nexp smallint NOT NULL,   --/D Number of exposures in Coadded Spectra
    exptime smallint NOT NULL,   --/D Length of Coadded Spectra [s]
    airmass real NOT NULL,   --/D Airmass at time of observation
    healpix bigint NOT NULL,   --/D The healpix pixel number of the plug_ra, plug_dec coords, computed with healpix nside=2^7=128
    healpixgrp smallint NOT NULL,   --/D The rounded-down integer value of healpix / 1000
    healpix_dir varchar(68) NOT NULL,   --/D Path to spec fits file in the SAS healpix structure
    mjd_final real NOT NULL,   --/D Mean MJD of the Coadded Spectra
    mjd_list varchar(128) NOT NULL,   --/D List MJDs for each exposure
    tai_list varchar(512) NOT NULL,   --/D List MJD(Tai) for each exposure (at midpoint)
    platesnr2g_list varchar(512) NOT NULL,   --/D Overall (S/N)^2 in g measured for plate per exposure
    platesnr2r_list varchar(512) NOT NULL,   --/D Overall (S/N)^2 in r measured for plate per exposure 
    platesnr2i_list varchar(512) NOT NULL,   --/D Overall (S/N)^2 in i measured for plate per exposure 
    moon_dist varchar(512) NOT NULL,   --/D Mean Moon-target speparation of the Coadded Spectra
    moon_phase varchar(512) NOT NULL,   --/D Mean Moon phase of the Coadded Spectra
    sfd_ebv real NOT NULL,   --/D SFD dust extinction
    wise_mag_1 real NOT NULL,   --/D WISE W1 band magnitude
    wise_mag_2 real NOT NULL,   --/D WISE W2 band magnitude 
    wise_mag_3 real NOT NULL,   --/D WISE W3 band magnitude 
    wise_mag_4 real NOT NULL,   --/D WISE W4 band magnitude 
    twomass_mag_1 real NOT NULL,   --/D 2MASS J band magnitude
    twomass_mag_2 real NOT NULL,   --/D 2MASS H band magnitude
    twomass_mag_3 real NOT NULL,   --/D 2MASS Ks band magnitude
    guvcat_mag_1 real NOT NULL,   --/D GALEX FUV Magnitude
    guvcat_mag_2 real NOT NULL,   --/D GALEX NUV Magnitude
    gaia_parallax real NOT NULL,   --/D Gaia DR2 parallax [mas]
    gaia_pmra real NOT NULL,   --/D Gaia DR2 RA proper motion [mas/yr]
    gaia_pmdec real NOT NULL,   --/D Gaia DR2 DEC proper motion [mas/yr]
    xcsao_rv real NOT NULL,   --/D Radial velocity measured with pyXCSAO [km/s]
    xcsao_erv real NOT NULL,   --/D Uncertainty in Radial velocity measured with pyXCSAO [km/s]
    xcsao_rxc real NOT NULL,   --/D Cross correlation strength, as defined in Tonry+79 from pyXCSAO 
    xcsao_teff real NOT NULL,   --/D Interpolated temperature of the best matched cross-correlation template from pyXCSAO [K]
    xcsao_eteff real NOT NULL,   --/D Uncertainty in Interpolated temperature of the best matched cross-correlation template from pyXCSAO [K]
    xcsao_logg real NOT NULL,   --/D Interpolated surface gravity of the best matched cross-correlation template from pyXCSAO [cm/s^2]
    xcsao_elogg real NOT NULL,   --/D Uncertainty in Interpolated surface gravity of the best matched cross-correlation template from pyXCSAO [cm/s^2]
    xcsao_feh real NOT NULL,   --/D Interpolated metallicity of the best matched cross-correlation template from pyXCSAO [Solar]
    xcsao_efeh real NOT NULL,   --/D Uncertainty in interpolated metallicity of the best matched cross-correlation template from pyXCSAO [Solar]
    catalogid bigint NOT NULL,   --/D SDSS-V CatalogID
    sdssv_boss_target0 bigint NOT NULL,   --/D SDSS-V BOSS targeting bitmask
    field bigint NOT NULL,   --/D Field number
    tile bigint NOT NULL,   --/D  Tile number
    mjd bigint NOT NULL,   --/D Modified Julian date of observation
    fiberid bigint NOT NULL,   --/D Fiber ID
    run2d varchar(6) NOT NULL,   --/D  Spectro-2D reduction name
    run1d varchar(6) NOT NULL,   --/D  Spectro-1D reduction name
    objtype varchar(16) NOT NULL,   --/D  Why this object was targetted.  Note that if this field says QSO, it could be the case that this object would have been targetted as a GALAXY or any number of other categories as well. The PRIMTARGET and SECTARGET flags in the plug-map structure (in the spPlate file) gives this full information.
    plug_ra float NOT NULL,   --/D  Object RA (drilled fiber position) [J2000 degrees].
    plug_dec float NOT NULL,   --/D  Object DEC (drilled fiber position) [J2000 degrees].
    class varchar(6) NOT NULL,   --/D  Spectro classification: GALAXY, QSO, STAR; reductions prior to version v4_7 will also use SKY and UNKNOWN; later versions set the ZWARNING flags
    subclass varchar(21) NOT NULL,   --/D Spectro sub-classification
    z real NOT NULL,   --/D  Redshift; if the ZWARNING flag is nonzero, then assume that this redshift is incorrect
    z_err real NOT NULL,   --/D  Redshift error based upon fit to chi^2 minimum; negative for invalid fit.
    rchi2 real NOT NULL,   --/D  Reduced chi^2 for best fit
    dof bigint NOT NULL,   --/D  Degrees of freedom for best fit
    rchi2diff real NOT NULL,   --/D  Difference in reduced chi^2 of best solution to 2nd best solution
    tfile varchar(24) NOT NULL,   --/D  Template file in $IDLSPEC2D_DIR/templates
    tcolumn_1 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_2 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_3 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_4 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_5 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_6 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_7 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_8 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_9 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    tcolumn_10 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1
    npoly bigint NOT NULL,   --/D  Number of polynomial terms used in conjunction with TFILE
    theta_1 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_2 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_3 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_4 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_5 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_6 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_7 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_8 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_9 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    theta_10 bigint NOT NULL,   --/D  Eigenvalue coefficient for each column in template file + each polynomial term
    vdisp real NOT NULL,   --/D  Velocity dispersion, only computed for galaxies (km/sec)
    vdisp_err real NOT NULL,   --/D  Error in VDISP (km/sec); negative for invalid fit
    vdispz real NOT NULL,   --/D  Redshift for best-fit velocity dispersion
    vdispz_err real NOT NULL,   --/D  Error in VDISPZ
    vdispchi2 real NOT NULL,   --/D  Chi^2 for best-fit velocity dispersion
    vdispnpix real NOT NULL,   --/D  Number of pixels overlapping the templates used in the velocity dispersion fit
    vdispdof bigint NOT NULL,   --/D  Degrees of freedom for best-fit velocity dispersion, equal to VDISPNPIX minus the number of templates minus the number of polynomial terms minus 1 (the last 1 is for the velocity dispersion)
    wavemin real NOT NULL,   --/D  Minimum observed (vacuum) wavelength for this object (Angstroms)
    wavemax real NOT NULL,   --/D  Maximum observed (vacuum) wavelength for this object (Angstroms)
    wcoverage real NOT NULL,   --/D  Amount of wavelength coverage in log-10(Angstroms)
    zwarning bigint NOT NULL,   --/D  A flag set for bad redshift fits in place of calling CLASS=UNKNOWN
    sn_median_u real NOT NULL,   --/D  Median S/N for all good pixels in the u filter
    sn_median_g real NOT NULL,   --/D  Median S/N for all good pixels in the g filter
    sn_median_r real NOT NULL,   --/D  Median S/N for all good pixels in the r filter
    sn_median_i real NOT NULL,   --/D  Median S/N for all good pixels in the i filter
    sn_median_z real NOT NULL,   --/D  Median S/N for all good pixels in the z filter
    sn_median_all real NOT NULL,   --/D   Median S/N for all good pixels in all filters
    chi68p real NOT NULL,   --/D  68-th percentile value of abs(chi) of the best-fit synthetic spectrum to the actual spectrum, which would be 1.0 for a good fit if the errors are properly normalized.
    fracnsigma_1 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 1 sigma (igorning all points blueward of rest-frame 1216 Ang)
    fracnsigma_2 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 2 sigma (igorning all points blueward of rest-frame 1216 Ang)
    fracnsigma_3 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 3 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsigma_4 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 4 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsigma_5 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 5 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsigma_6 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 6 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsigma_7 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 7 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsigma_8 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 8 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsigma_9 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 9 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsigma_10 bigint NOT NULL,   --/D  Fraction of pixels deviant by more than 10 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_1 bigint NOT NULL,   --/D  Fraction of pixels high by more than 1 sigma (igorning all points blueward of rest-frame 1216 Ang)
    fracnsighi_2 bigint NOT NULL,   --/D  Fraction of pixels high by more than 2 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_3 bigint NOT NULL,   --/D  Fraction of pixels high by more than 3 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_4 bigint NOT NULL,   --/D  Fraction of pixels high by more than 4 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_5 bigint NOT NULL,   --/D  Fraction of pixels high by more than 5 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_6 bigint NOT NULL,   --/D  Fraction of pixels high by more than 6 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_7 bigint NOT NULL,   --/D  Fraction of pixels high by more than 7 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_8 bigint NOT NULL,   --/D  Fraction of pixels high by more than 8 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_9 bigint NOT NULL,   --/D  Fraction of pixels high by more than 9 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsighi_10 bigint NOT NULL,   --/D  Fraction of pixels high by more than 10 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsiglo_1 bigint NOT NULL,   --/D  Fraction of pixels low by more than 1 sigma (igorning all points blueward of rest-frame 1216 Ang) 
    fracnsiglo_2 bigint NOT NULL,   --/D  Fraction of pixels low by more than 2 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_3 bigint NOT NULL,   --/D  Fraction of pixels low by more than 3 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_4 bigint NOT NULL,   --/D  Fraction of pixels low by more than 4 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_5 bigint NOT NULL,   --/D  Fraction of pixels low by more than 5 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_6 bigint NOT NULL,   --/D  Fraction of pixels low by more than 6 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_7 bigint NOT NULL,   --/D  Fraction of pixels low by more than 7 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_8 bigint NOT NULL,   --/D  Fraction of pixels low by more than 8 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_9 bigint NOT NULL,   --/D  Fraction of pixels low by more than 9 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    fracnsiglo_10 bigint NOT NULL,   --/D  Fraction of pixels low by more than 10 sigma (igorning all points blueward of rest-frame 1216 Ang)  
    spectroflux_u real NOT NULL,   --/D  Spectrum projected onto u filter
    spectroflux_g real NOT NULL,   --/D  Spectrum projected onto g filter
    spectroflux_r real NOT NULL,   --/D  Spectrum projected onto r filter
    spectroflux_i real NOT NULL,   --/D  Spectrum projected onto i filter
    spectroflux_z real NOT NULL,   --/D  Spectrum projected onto z filter
    spectrosynflux_u real NOT NULL,   --/D  Best-fit template spectrum projected onto u filter 
    spectrosynflux_g real NOT NULL,   --/D  Best-fit template spectrum projected onto g filter  
    spectrosynflux_r real NOT NULL,   --/D  Best-fit template spectrum projected onto r filter  
    spectrosynflux_i real NOT NULL,   --/D  Best-fit template spectrum projected onto i filter  
    spectrosynflux_z real NOT NULL,   --/D  Best-fit template spectrum projected onto z filter  
    spectrosynflux_ivar_u real NOT NULL,   --/D  Inverse variance of best-fit template spectrum projected onto u filter
    spectrosynflux_ivar_g real NOT NULL,   --/D  Inverse variance of best-fit template spectrum projected onto g filter 
    spectrosynflux_ivar_r real NOT NULL,   --/D  Inverse variance of best-fit template spectrum projected onto r filter 
    spectrosynflux_ivar_i real NOT NULL,   --/D  Inverse variance of best-fit template spectrum projected onto i filter 
    spectrosynflux_ivar_z real NOT NULL,   --/D  Inverse variance of best-fit template spectrum projected onto z filter 
    spectroskyflux_u real NOT NULL,   --/D  Sky spectrum projected onto u filter
    spectroskyflux_g real NOT NULL,   --/D  Sky spectrum projected onto g filter 
    spectroskyflux_r real NOT NULL,   --/D  Sky spectrum projected onto r filter 
    spectroskyflux_i real NOT NULL,   --/D  Sky spectrum projected onto i filter 
    spectroskyflux_z real NOT NULL,   --/D  Sky spectrum projected onto z filter 
    anyandmask bigint NOT NULL,   --/D  For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK
    anyormask bigint NOT NULL,   --/D  For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK
    spec1_g real NOT NULL,   --/D  (S/N)^2 at g=20.20 for spectrograph #1 (same value for 500 fibers)
    spec1_r real NOT NULL,   --/D  (S/N)^2 at r=20.25 for spectrograph #1 (same value for 500 fibers) 
    spec1_i real NOT NULL,   --/D  (S/N)^2 at i=19.90 for spectrograph #1 (same value for 500 fibers)
    elodie_filename varchar(16) NOT NULL,   --/D  File name for best-fit Elodie star
    elodie_object varchar(9) NOT NULL,   --/D  Star name (mostly Henry Draper names)  from Elodie
    elodie_sptype varchar(12) NOT NULL,   --/D  Spectral type  from Elodie
    elodie_bv real NOT NULL,   --/D  (B-V) color  from Elodie
    elodie_teff real NOT NULL,   --/D  Effective temperature from Elodie
    elodie_logg real NOT NULL,   --/D  Log10(gravity) from Elodie
    elodie_feh real NOT NULL,   --/D  [Fe/H] from Elodie
    elodie_z real NOT NULL,   --/D  Redshift from Elodie
    elodie_z_err real NOT NULL,   --/D  Redshift error from Elodie; negative for invalid fit
    elodie_z_modelerr real NOT NULL,   --/D  The standard deviation in redshift amongst the 12 best-fit Elodie stars
    elodie_rchi2 real NOT NULL,   --/D  Reduced chi^2 from Elodie
    elodie_dof bigint NOT NULL,   --/D  Degrees of freedom for fit from Elodie
    z_noqso real NOT NULL,   --/D  Redshift of the best-fit non-QSO model (recommended for CMASS and LOZ).
    z_err_noqso real NOT NULL,   --/D  Formal one-sigma error on Z_NOQSO (recommended for CMASS and LOZ).
    znum_noqso bigint NOT NULL,   --/D  Best fit redshift/classification index while excluding QSO fits; 1-indexed.
    zwarning_noqso bigint NOT NULL,   --/D  Redshift warning flag for Z_NOQSO (recommended for CMASS and LOZ).
    class_noqso varchar(6) NOT NULL,   --/D  Spectro classification of best-fit non-QSO model (recommended for CMASS and LOZ).
    subclass_noqso varchar(21) NOT NULL,   --/D  Spectro sub-classification of best-fit non-QSO model (recommended for CMASS and LOZ).
    rchi2diff_noqso real NOT NULL,   --/D  Reduced chi-squared difference to next-best non-QSO model (recommended for CMASS and LOZ).
    specobjid bigint NOT NULL --/D  Unique database ID based on PLATE, MJD, FIBERID, RUN2D
)
GO
--

-- Allspec (DR19)

--// Created from HDU 1 in $ALLSPEC/1.0.1/multiplex-dr19-1.0.1.fits

if exists (select * from dbo.sysobjects 
	where id = object_id(N'multiplex')) 
	drop table multiplex
GO
--
CREATE TABLE multiplex (
    ------- 
    --/H Table of all spectroscopic plates or FPS fields
    --/T Table of all spectroscopic plates or FPS fields across each SDSS instrument.
    ------- 
    multiplex_id varchar(40) NOT NULL, --/U  --/D Unique multiplex ID  
    design_id int NOT NULL, --/U  --/D design_id  
    sdss_phase smallint NOT NULL, --/U  --/D SDSS Phase from 1 to 5  
    observatory varchar(10) NOT NULL, --/U  --/D observatory  
    instrument varchar(10) NOT NULL, --/U  --/D instrument  
    plate int NOT NULL, --/U  --/D SDSS/BOSS/eBOSS/BHM plate (before FPS era)  
    fps_field int NOT NULL, --/U  --/D Plate or FPS Field (merges pre/post Plate era)  
    plate_or_fps_field int NOT NULL, --/U  --/D Plate or FPS Field (merges pre/post Plate era)  
    mjd int NOT NULL, --/U  --/D MJD  
    run2d varchar(10) NOT NULL, --/U  --/D idlspec2d version  
    apred_vers varchar(10) NOT NULL, --/U  --/D APOGEE DRP Version  
    drpver varchar(10) NOT NULL, --/U  --/D MaNGA (for e.g.) DRP Version  
    version varchar(10) NOT NULL, --/U  --/D All Pipeline Version  
    racen float NOT NULL, --/U deg --/D Multiplex center's right ascension  
    deccen float NOT NULL, --/U deg --/D Multiplex center's declination  
    position_angle float NOT NULL, --/U  --/D Multiplex position angle  
    healpix int NOT NULL, --/U  --/D healpix  
    healpixgrp smallint NOT NULL, --/U  --/D healpixgrp  
    quality varchar(10) NOT NULL, --/U  --/D Quality flag for spectroscopic reduction  
    programname varchar(40) NOT NULL, --/U  --/D Spectroscopic program Name  
    survey varchar(20) NOT NULL, --/U  --/D Spectroscopic survey or sub-survey  
    cas_url varchar(256) NOT NULL, --/U  --/D CAS URL  
    sas_url varchar(256) NOT NULL, --/U  --/D SAS URL  
)




--// Created from HDU 1 in $ALLSPEC/1.0.1/allspec-dr19-1.0.1.fits

if exists (select * from dbo.sysobjects 
	where id = object_id(N'allspec')) 
	drop table allspec
GO
--
CREATE TABLE allspec (
    ------- 
    --/H Table of all spectroscopic reductions
    --/T Table of all spectroscopic reductions across each SDSS instrument. 
    ------- 
    allspec_id varchar(128) NOT NULL, --/U  --/D Unique allspec ID
    multiplex_id varchar(40) NOT NULL, --/U  --/D multiplex ID  
    sdss_phase smallint NOT NULL, --/U  --/D SDSS Phase from 1 to 5  
    observatory varchar(10) NOT NULL, --/U  --/D observatory  
    instrument varchar(10) NOT NULL, --/U  --/D instrument  
    sdss_id bigint NOT NULL, --/U  --/D sdss_id  
    catalogid bigint NOT NULL, --/U  --/D BHM catalogid  
    fiberid int NOT NULL, --/U  --/D SDSS/BOSS/eBOSS fiberid  
    ifudsgn smallint NOT NULL, --/U  --/D MaNGA IFU DESIGN ID  
    plate int NOT NULL, --/U  --/D SDSS/BOSS/eBOSS/BHM plate (before FPS era)  
    fps_field int NOT NULL, --/U  --/D FPS Field (post Plate era)  
    plate_or_fps_field int NOT NULL, --/U  --/D Plate or FPS Field (merges pre/post Plate era)  
    mjd int NOT NULL, --/U  --/D MJD  
    run2d varchar(10) NOT NULL, --/U  --/D idlspec2d version  
    run1d varchar(10) NOT NULL, --/U  --/D idlspec1d version  
    coadd varchar(10) NOT NULL, --/U  --/D either epoch, daily, or custom=allepoch  
    apred_vers varchar(10) NOT NULL, --/U  --/D APOGEE DRP Version  
    drpver varchar(10) NOT NULL, --/U  --/D MaNGA (for e.g.) DRP Version  
    version varchar(10) NOT NULL, --/U  --/D All Pipeline Version  
    programname varchar(40) NOT NULL, --/U  --/D Spectroscopic program Name  
    survey varchar(40) NOT NULL, --/U  --/D Spectroscopic survey or sub-survey  
    sas_file varchar(50) NOT NULL, --/U  --/D SAS File  
    cas_url varchar(256) NOT NULL, --/U  --/D CAS URL  
    sas_url varchar(256) NOT NULL, --/U  --/D SAS URL  
    ra float NOT NULL, --/U deg --/D Right ascension  
    dec float NOT NULL, --/U deg --/D Declination  
    healpix int NOT NULL, --/U  --/D healpix  
    healpixgrp smallint NOT NULL, --/U  --/D healpixgrp  
    apogee_id varchar(32) NOT NULL, --/U  --/D APOGEE ID  
    apogee_field varchar(32) NOT NULL, --/U  --/D APOGEE Field (prior to SDSS-V)  
    telescope varchar(10) NOT NULL, --/U  --/D 2.5m Telescope  
    file_spec varchar(10) NOT NULL, --/U  --/D sdss_access file species name  
    apstar_id varchar(60) NOT NULL, --/U  --/D APOGEE (combined) star ID  
    visit_id varchar(40) NOT NULL, --/U  --/D APOGEE visit ID  
    mangaid varchar(10) NOT NULL, --/U  --/D MaNGA ID  
    specobjid varchar(32) NOT NULL, --/U  --/D spectroscopic object id
	htmid bigint NOT NULL, --/D the htmid
	cx float, --/D cx coordinate
	cy float, --/D cy coordinate
	cz float, --/D cz coordinate
    has_mwmStar bit NOT NULL, --/U  --/D does it have an asscociated mwmStar file if it was (co-)observed with apogee
)




if exists (select * from dbo.sysobjects 
	where id = object_id(N'DR3QuasarCatalog')) 
	drop table [DR3QuasarCatalog]
GO
--


if exists (select * from dbo.sysobjects 
	where id = object_id(N'DR5QuasarCatalog')) 
	drop table [DR5QuasarCatalog]
GO


--==================================================
-- QsoConcordance tables 
--==================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'QsoCatalogAll')) 
	drop table [QsoCatalogAll]
GO


--==================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'QsoConcordanceAll')) 
	drop table [QsoConcordanceAll]
GO
 
IF EXISTS(SELECT * FROM sysobjects WHERE name = N'QsoTarget') 
          DROP TABLE QsoTarget
GO


IF EXISTS(SELECT * FROM sysobjects WHERE name = N'QsoBunch') 
     DROP TABLE QsoBunch
GO


IF EXISTS(SELECT * FROM sysobjects WHERE name = N'QsoBest') 
          DROP TABLE QsoBest
GO


---------------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE name = N'QsoSpec') 
          DROP TABLE QsoSpec
GO


-- revert to primary file group
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[SpectroTables.sql]: Spec tables and related functions created'
GO
