-- Patch to reinstate and rename some sector/region tables.  These are defined
-- in RegionTables.sql. [ART]


-- Drop tables with old names if they exist.

--==================================================
IF EXISTS (SELECT name FROM sysobjects
        WHERE xtype='U' AND name = 'Sector')
	DROP TABLE Sector
GO
--



--==================================================
IF EXISTS (SELECT name FROM sysobjects
        WHERE xtype='U' AND name = 'BestTarget2Sector')
	DROP TABLE BestTarget2Sector
GO
--



--==================================================
IF EXISTS (SELECT name FROM sysobjects
        WHERE xtype='U' AND name = 'Sector2Tile')
	DROP TABLE Sector2Tile
GO
--



-- Create tables with new names.

--==================================================
IF EXISTS (SELECT name FROM sysobjects
        WHERE xtype='U' AND name = 'sdssSector')
	DROP TABLE sdssSector
GO
--
EXEC spSetDefaultFileGroup 'sdssSector'
GO
--
CREATE TABLE sdssSector (
----------------------------------------------------------------
--/H Stores the information about set of unique Sector regions
----------------------------------------------------------------
--/T A Sector is defined as a distinct intersection of tiles and
--/T TilingGeometries, characterized by a unique combination of
--/T intersecting tiles and a list of tilingVersions. The sampling
--/T rate for any targets is unambgously defined by the number of
--/T tiles involved (nTiles) and the combination of targetVersion.
----------------------------------------------------------------
	regionID	bigint NOT NULL,--/D unique, sequential ID --/K ID_CATALOG
	nTiles		int NOT NULL,	--/D number of overlapping tiles --/K NUMBER
	tiles		varchar(256) NOT NULL, --/D list of tiles in Sector --/K ID_VERSION
	targetVersion	varchar(64) NOT NULL, --/D the version of target selection ran over the sector -/K ID_VERSION
	area		real NOT NULL	--/D area of this overlap region --/U deg^2 --/K EXTENSION_AREA
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssBestTarget2Sector')
	DROP TABLE sdssBestTarget2Sector
GO
--
EXEC spSetDefaultFileGroup 'sdssBestTarget2Sector'
GO
CREATE TABLE sdssBestTarget2Sector (
-------------------------------------------------------------------------------
--/H Map PhotoObj which are potential targets to sectors 
--
--/T PhotoObj should only appear once in this list because any ra,dec
--/T should belong to a unique sector
-------------------------------------------------------------------------------
	objID		bigint NOT NULL,--/D ID of the best PhotoObj --/K ID_CATALOG
	regionID	bigint NOT NULL,	--/D ID of the sector --/K ID_CATALOG
	status		int NOT NULL,	--/D Status of the object in the survey --/R PhotoStatus --/K CODE_MISC
	primTarget	int NOT NULL,	--/D Bit mask of primary target categories the object was selected in. --/R PrimTarget  --/K CODE_MISC
	secTarget	int NOT NULL,	--/D Bit mask of secondary target categories the object was selected in. --/R SecTarget --/K CODE_MISC
	petroMag_r	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_R
	extinction_r	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
)
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssSector2Tile')
	DROP TABLE sdssSector2Tile
GO
--
EXEC spSetDefaultFileGroup 'sdssSector2Tile'
GO
--
CREATE TABLE sdssSector2Tile (
-------------------------------------------------------------------------------
--/H Match tiles to sectors, wedges adn sectorlets, and vice versa.
--
--/T This table is designed to be queried in either direction - one can get
--/T all the tiles associated with a sector, or one can find all the sectors
--/T to which a tile belongs.
-------------------------------------------------------------------------------
	regionID	bigint NOT NULL,	--/D ID of the sector --/K ID_CATALOG
	type		varchar(16) NOT NULL, 	--/D type of the sector
	tile		smallint NOT NULL,	--/D tile number --/K ID_CATALOG
	isMask 		int NOT NULL 		--/D flag that shows sign of tile (1 is negative)
)
GO
--



