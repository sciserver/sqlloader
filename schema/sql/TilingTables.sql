--=========================================================
--  TilingTables.sql
--  2003-05-21	Adrian Pope and Alex Szalay
-----------------------------------------------------------
--  Tiling Schema for SQL Server
--
--  split off from photoTables.sql and spectroTables.sql
-----------------------------------------------------------
-- History:
--* 2003-05-21 Adrian and Alex: changed Tile to TileAll, 
--*		took out htmSupport, added untiled
--* 2003-05-21 Adrian+Alex: modified Sector table, switched
--*		to regionId, dropped htmInfo and htmSupport
--* 2003-05-21 Adrian+Alex: changed TargetParam to name,value
--* 2003-05-21 Adrian+Alex: changed TilingRegion to TilingRun
--* 2003-05-21 Adrian+Alex: changed TilingNotes to TIlingNote,
--*		and TileNoteID to TilingNoteID, TileNotes to TilingNote
--* 2003-05-21 Adrian+Alex: changed TilingGeometry.tileBoundID to
--*		tilingGeometryID, removed htm*
--* 2003-05-21 Adrian+Alex: changed TiledTarget to TiledTargetAll, 
--*		added untiled
--* 2003-05-21 Adrian+Alex: changed Best2Sector.bestObjID to objID
--* 2003-05-21 Adrian+Alex: moved views Tile, TiledTarget, TilingBoundary, 
--*		TilingMask to this file
--* 2003-06-04 Adrian+Alex: added Target.bestMode, TargetInfo.targetMode
--* 2003-06-06 Ani: Renamed Tile->TileAll and TiledTarget->TiledTargetAll,
--*		     added unTiled to both tables (PR #5305).
--* 2003-08-20 Ani: Added TileContains for region/convex/wedges stuff.
--* 2003-11-12 Ani: Added lambdaLimits to TilingGeometry (PR #5742).
--* 2004-08-30 Alex: moved tiling views to Views.sql
--* 2004-09--2 Alex: removed TileContains, it is obsolete
--* 2009-08-11 Ani: Removed TilingNote, renamed tables for SDSS-III and 
--*            swapped in schema changes.
--* 2010-11-24 Ani: Changed sdssTilingInfo.tid to int from smallint.
--* 2010-12-07 Ani: Renamed TargetParam to sdssTargetParam and updated
--*            schema for it.
--* 2010-12-07 Ani: Changed sdssTargetParam.value to varchar(512).
--* 2011-09-29 Ani: Reinstated --/R links for TiMask (PR #1444).
--* 2012-07-26 Ani: Renamed sdssTilingGeometry.regionID to 
--*            tilingGemetryID.
--* 2014-09-05 Ani: Fixed typo in TargetInfo short description.
--=========================================================
SET NOCOUNT ON
GO


--=====================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'Target')
	DROP TABLE Target
GO
--
EXEC spSetDefaultFileGroup 'Target'
GO
CREATE TABLE Target (
-------------------------------------------------------------------------------
--/H Keeps track of objects chosen by target selection and need to be tiled.
--
--/T Objects are added whenever target selection is run on a new chunk.
--/T Objects are also added when southern target selection is run.
--/T In the case where an object (meaning run,rerun,camcol,field,id) is 
--/T targetted more than once, there will be only one row in Target for
--/T that object, but there will multiple entries for that Target in the
--/T TargetInfo table.
-------------------------------------------------------------------------------
	targetID	bigint NOT NULL,	--/D hash of run, rerun, camcol, field, object (skyVersion=0) --/K ID_CATALOG
	run		smallint NOT NULL,	--/D imaging run --/K OBS_RUN
	rerun		smallint NOT NULL,	--/D rerun number --/K CODE_MISC
	camcol		tinyint NOT NULL,	--/D imaging camcol --/K INST_ID
	field		int NOT NULL,		--/D imaging field --/K ID_FIELD
	obj		int NOT NULL,		--/D imaging object id --/K ID_NUMBER
	regionID	int NOT NULL,		--/D ID of sector, 0 if unset --/K ID_CATALOG
	ra		float NOT NULL,		--/D right ascension --/U deg --/K POS_EQ_RA_MAIN
	[dec]		float NOT NULL,		--/D declination --/U deg --/K POS_EQ_DEC_MAIN
	duplicate	tinyint NOT NULL,	--/D duplicate spectrum by mistake --/K CODE_MISC
	htmID		bigint NOT NULL,	--/D htm index --/K CODE_HTM
	cx		float NOT NULL,		--/D x projection of vector on unit sphere --/K POS_EQ_CART_X
	cy		float NOT NULL,		--/D y projection of vector on unit sphere --/K POS_EQ_CART_Y
	cz		float NOT NULL,		--/D z projection of vector on unit sphere --/K POS_EQ_CART_Z
	bestObjID	bigint NOT NULL,	--/D hashed ID of object in best version of the sky --/K CODE_MISC
	specObjID	bigint NOT NULL,	--/D hashed ID of specobj in best version of the sky --/K CODE_MISC
	bestMode	tinyInt NOT NULL,	--/D mode from BEST PhotoObj --/K CLASS_OBJECT
	loadVersion	int NOT NULL		--/D Load Version --/K ID_VERSION
)
GO
--


--=====================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'TargetInfo')
	DROP TABLE TargetInfo
GO
--
EXEC spSetDefaultFileGroup 'TargetInfo'
GO
CREATE TABLE TargetInfo (
-------------------------------------------------------------------------------
--/H Unique information for an object every time it is targeted
--
--/T
-------------------------------------------------------------------------------
	targetObjID	bigint NOT NULL,	--/D ID of object in Target (foreign key to Target.TargetObjID) --/K ID_CATALOG
	targetID	bigint NOT NULL,	--/D ID of entry in Target table --/K ID_CATALOG
	skyVersion	int NOT NULL,		--/D skyVersion --/K ID_VERSION
	primTarget	int NOT NULL,		--/D primTarget from TARGET --/R PrimTarget --/K CODE_MISC
	secTarget	int NOT NULL,		--/D secTarget from TARGET --/R SecTarget --/K CODE_MISC
	priority	int NOT NULL,		--/D target selection priority --/K CODE_QUALITY
	programType	int NOT NULL,		--/D spectroscopic program type --/R ProgramType --/K OBS_TYPE
	programName	varchar(32) NOT NULL,	--/D character string of program (from plate inventory db) --/K ID_SURVEY
	targetMode	tinyInt NOT NULL,	--/D mode from TARGET PhotoObj --/K CLASS_OBJECT
	loadVersion	int NOT NULL		--/D Load Version --/K ID_VERSION
)
GO
--



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssTargetParam')
	DROP TABLE sdssTargetParam
GO
--
EXEC spSetDefaultFileGroup 'sdssTargetParam'
GO
CREATE TABLE sdssTargetParam (
-------------------------------------------------------------------------------
--/H Contains the parameters used for a version of the target selection code
--
--/T
-------------------------------------------------------------------------------
	targetVersion	varchar(32) NOT NULL,	--/D version of target selection software	--/K ID_VERSION
	paramFile	varchar(32) NOT NULL,	--/D version of target selection software	--/K ID_VERSION --/F file
	name		varchar(32) NOT NULL,	--/D parameter name 
	value		varchar(512) NOT NULL	--/D value used for the parameter  
)
GO
--


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssTileAll')
	DROP TABLE sdssTileAll
GO
--
EXEC spSetDefaultFileGroup 'sdssTileAll'
GO
CREATE TABLE sdssTileAll (
-------------------------------------------------------------------------------
--/H Contains information about each individual tile on the sky.
--
--/T Each "tile" corresponds to an SDSS-I or -II spectroscopic observation.
--/T The tile covers a region of the 1.49 deg in radius, and corresponds to
--/T one or more observed plates.  At the time the tile was created, all of 
--/T the "tiled target" categories (galaxies, quasars, and some very special
--/T categories of star) were assigned fibers; later other targets were 
--/T assigned fibers on the plate.
-------------------------------------------------------------------------------
	tile		smallint NOT NULL,	--/D (unique) tile number --/K ID_PLATE --/F tileid
	tileRun	smallint NOT NULL,	--/D run of the tiling software --/K ID_VERSION --/F chunk
	raCen		float NOT NULL,		--/D right ascension of tile center --/U deg --/K POS_EQ_RA
	decCen	float NOT NULL,		--/D declination of the tile center --/U deg --/K POS_EQ_DEC
	htmID		bigint NOT NULL,		--/D htm tree info --/K CODE_HTM --/F NOFITS
	cx		float NOT NULL,		--/D x projection of vector on unit sphere --/K POS_EQ_CART_X
	cy		float NOT NULL,		--/D y projection of vector on unit sphere --/K POS_EQ_CART_Y
	cz		float NOT NULL,		--/D z projection of vector on unit sphere --/K POS_EQ_CART_Z
	untiled	tinyint NOT NULL,		--/D 1: this tile later "untiled," releasing targets to be assigned to another tile, 0: otherwise --/K CODE_MISC
	nTargets	int NOT NULL,		--/D number of targets assigned to this tile --/K NUMBER
	loadVersion	int	NOT NULL		--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssTilingRun')
	DROP TABLE sdssTilingRun
GO
--
EXEC spSetDefaultFileGroup 'sdssTilingRun'
GO
CREATE TABLE sdssTilingRun (
-------------------------------------------------------------------------------
--/H Contains basic information for a run of tiling
--
--/T
-------------------------------------------------------------------------------
--/H Contains basic information for a run of tiling
--
--/T
-------------------------------------------------------------------------------
	tileRun		smallint NOT NULL,	--/D (unique) tiling run number --/K OBS_RUN --/F chunk
	ctileVersion	varchar(32) NOT NULL,	--/D version of ctile software --/K ID_VERSION
	tilepId		varchar(32) NOT NULL,	--/D unique id for tiling run --/K OBJ_ID
	programName		varchar(32) NOT NULL,	--/D character string of program --/K OBJ_ID
	primTargetMask	int NOT NULL,		--/D bit mask for target types to be tiled --/R PrimTarget --/K CODE_MISC
	secTargetMask	int NOT NULL,		--/D bit mask for target types to be tiled --/R SecTarget --/K CODE_MISC
	loadVersion		int NOT NULL 		--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssTilingGeometry')
	DROP TABLE sdssTilingGeometry
GO
--
EXEC spSetDefaultFileGroup 'sdssTilingGeometry'
GO
CREATE TABLE sdssTilingGeometry (
-------------------------------------------------------------------------------
--/H Information about boundary and mask regions in SDSS-I and SDSS-II
--
--/T This table contains both tiling boundary and mask information.
-------------------------------------------------------------------------------
	tilingGeometryID	int NOT NULL,   		--/D unique identifier for this tilingRegion --/F NOFITS
	tileRun		smallint NOT NULL,	--/D run of tiling software --/K OBJ_RUN
	[stripe]		int NOT NULL,		--/D stripe containing the boundary --/K EXTENSION_AREA
	nsbx			varchar(1) NOT NULL,	--/D b: official stripe boundaries should be included, x: use the full rectangle --/K CODE_MISC
	isMask		tinyint NOT NULL,		--/D 1: tiling mask, 0: tiling boundary --/K CODE_MISC
	coordType		int NOT NULL,		--/D specifies coordinate system for the boundaries --/R CoordType --/K POS_REFERENCE-SYSTEM
	lambdamu_0		float NOT NULL,		--/D first lower bound --/U deg --/K POS_SDSS POS_LIMIT
	lambdamu_1		float NOT NULL,		--/D first upper bound --/U deg --/K POS_SDSS POS_LIMIT
	etanu_0		float NOT NULL,		--/D second lower bound --/U deg --/K POS_SDSS POS_LIMIT
	etanu_1		float NOT NULL,		--/D second upper bound --/U deg --/K POS_SDSS POS_LIMIT
	lambdaLimit_0	float NOT NULL,		--/D minimum survey latitude for this stripe for region in which primaries are selected (-9999 if no limit) --/U deg --/K POS_SDSS POS_LIMIT
	lambdaLimit_1	float NOT NULL,		--/D maximum survey latitude for this stripe for region in which primaries are selected (-9999 if no limit) --/U deg --/K POS_SDSS POS_LIMIT
	targetVersion	varchar(32) NOT NULL,	--/D version of target software within this boundary --/K ID_VERSION
	firstArea		float NOT NULL,		--/D  area of sky covered by this boundary that was not covered by previous boundaries --/U deg^2 --/K EXTENSION_AREA
	loadVersion		int NOT NULL		--/D Load Version --/K ID_VERSION
)
GO
--


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssTiledTargetAll')
	DROP TABLE sdssTiledTargetAll
GO
--
EXEC spSetDefaultFileGroup 'sdssTiledTargetAll'
GO
CREATE TABLE sdssTiledTargetAll (
-------------------------------------------------------------------------------
--/H Information on all targets run through tiling for SDSS-I and SDSS-II
--
--/T This table is the full list of all targets that were run through
--/T the SDSS tiling routines. targetID refers to the SDSS object
--/T ID associated with the CAS DR7. 
-------------------------------------------------------------------------------
	targetID	bigint NOT NULL,		--/D Unique SDSS identifier composed from [skyVersion=0,rerun,run,camcol,field,obj]. --/F targetobjid
	run		smallint NOT NULL,	--/D Drift scan run number for targeting
	rerun		smallint NOT NULL,	--/D Reprocessing number for targeting
	camcol	smallint NOT NULL,	--/D Camera column number for targeting
	field		smallint NOT NULL,	--/D Field number for targeting
	obj		smallint NOT NULL,	--/D Object id number for targeting --/F id
	ra		float NOT NULL,		--/D right ascension --/U deg --/K POS_EQ_RA
	[dec]		float NOT NULL,		--/D declination --/U deg --/K POS_EQ_DEC
	htmID		bigint NOT NULL,		--/D htm tree info --/K CODE_HTM --/F NOFITS
	cx		float NOT NULL,		--/D x projection of vector on unit sphere 
	cy		float NOT NULL,		--/D y projection of vector on unit sphere 
	cz		float NOT NULL,		--/D z projection of vector on unit sphere 
	primTarget	[int] NOT NULL,		--/D primary target bitmask
	secTarget	[int] NOT NULL,		--/D secondary target bitmask
	tiPriority	[int] NOT NULL,		--/D tiling priority level (lower means higher priority)
	tileAll	[int] NOT NULL,		--/D First tile number this object was assigned to
	tiMaskAll	smallint NOT NULL,	--/D Combined value of tiling results bitmask --/R TiMask
	collisionGroupAll   int NOT NULL,	--/D unique ID of collisionGroup
	photoObjID	bigint NOT NULL,		--/D hashed ID of photometric object in best version of the sky 
	specObjID	bigint NOT NULL,		--/D hashed ID of spectroscopic object in best version of the sky
	regionID	int NOT NULL,		--/D ID of tiling region, 0 if unset --/F NOFITS
	loadVersion	int	NOT NULL		--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssTilingInfo')
	DROP TABLE sdssTilingInfo
GO
--
EXEC spSetDefaultFileGroup 'sdssTilingInfo'
GO
CREATE TABLE sdssTilingInfo (
-------------------------------------------------------------------------------
--/H Results of individual tiling runs for each tiled target
--
--/T This table has entry for each time a target was input into
--/T the SDSS tiling routines. targetID refers to the SDSS object
--/T ID associated with the CAS DR7. To get target information,
--/T join this table with sdssTiledTargets on targetID.
-------------------------------------------------------------------------------
	targetID		bigint NOT NULL,		--/D Unique SDSS identifier composed from [skyVersion=0,rerun,run,camcol,field,obj].--/F targetobjid
	tileRun		smallint NOT NULL,	--/D Run of tiling software --/F chunk
	tid			int NOT NULL,	--/D Unique ID of objects within tiling run
	tiMask		smallint NOT NULL,	--/D Value of tiling results bitmask for this run --/R TiMask
	collisionGroup	int NOT NULL,		--/D unique ID of collisionGroup in this tiling run 
	tile			[int] NOT NULL,		--/D Tile this object was assigned to in this run
	loadVersion		int NOT NULL		--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--


EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[TilingTables.sql]: Tiling tables and related views created'
GO
