--=================================================================
-- RegionTables.sql
-- 2004-03-18 Alex Szalay, Baltimore
-------------------------------------------------------------------
-- History:
--* 2004-03-18 Alex: moved here from spBoundary
--* 2004-03-25 Jim: dropped RegionConvexString, added RegionConvex, 
--*		added comments re sectors etc
--* 2004-03-30 Alex: changed column names in RegionConvex
--* 2004-03-31 Alex: added RegionArcs table
--* 2004-05-06 Alex: merged with SectorSchema.sql
--* 2004-05-06 Alex: added spSetDefaultFileGroup commands
--* 2004-08-27 Alex: moved here the Rmatrix table
--* 2004-10-08 Ani: added mode doc for Rmatrix.
--* 2004-12-22 Alex+Adrian: added more fields to Best2Sector
--* 2005-01-28 Alex: Changed Best2Sector to BestTarget2Sector
--* 2005-03-06 Alex: changed Region2Box.regionid->id, added type to Sector2Tile
--* 2005-03-10 Alex: added patch column to RegionConvex
--* 2005-03-13 Alex: added targetVersion column to Sector
--* 2005-10-22 Ani: added command to revert to primary filegroup at the end.
--* 2007-06-08 Alex: modified RegionConvex to RegionPatch, added view. Also
--*		added area to RegionPatch
--* 2010-12-10 Ani: deleted BestTarget2Sector and Sector2Tile.
--* 2012-03-07 Ani: Reinstated BestTarget2Sector and Sector2Tile as
--*             sdssBestTarget2Sector and sdssSector2Tile, renamed
--*             Sector to sdssSector.
--* 2012-11-15 Ani: Added new table RegionTypes from Alex.
--* 2014-09-05 Ani: Fixed typo in HalfSpace short description.
--=================================================================



--===========================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[RegionTypes]') 
    and OBJECTPROPERTY(id, N'IsUserTable') = 1)
    drop table [RegionTypes]
GO
--
CREATE TABLE RegionTypes(
	type varchar(16) NOT NULL,
	radius float NOT NULL
)
GO



--===========================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[Rmatrix]') 
    and OBJECTPROPERTY(id, N'IsUserTable') = 1)
    drop table [Rmatrix]
GO
--
CREATE TABLE Rmatrix(
-------------------------------------------------------
--/H Contains various rotation matrices between spherical coordinate systems
--  --------------------------------------------------
--/T 
--/T The mode field is a 3-letter code indicating the transformation:
--/T <ul><li>      S2J - Survey-to-J2000   </li>
--/T     <li>      G2J - Galactic-to-J2000 </li>
--/T     <li>      J2G - J2000-to-Galactic </li>
--/T     <li>      J2S - J2000-to-Survey   </li>
--/T </ul>
-------------------------------------------------------
	mode	varchar(16) NOT NULL,
	row	smallint NOT NULL,
	x	float NOT NULL,
	y	float NOT NULL,
	z	float NOT NULL
)
GO


--=======================================================
if exists (select * from dbo.sysobjects 
	where name=N'Region') 
	drop table Region
GO
--
EXEC spSetDefaultFileGroup 'Region'
GO
--
CREATE TABLE Region (
-------------------------------------------------------
--/H Definition of the different regions
--  --------------------------------------------------
--/T We have various boundaries in the survey, represented
--/T by equations of 3D planes, intersecting the unit sphere,
--/T describing great and small circles, respectively. This
--/T table stores the description of a region, the details
--/T are in the HalfSpace table.
--/T <ul>
--/T <li>CHUNK - the boundary of a given Chunk
--/T <li>STRIPE - the boundary of the whole stripe
--/T <li>STAVE - the unique boundary of the whole stripe,
--/T agrees with STRIPE for Southern stripes
--/T <li>PRIMARY - the primary region of a given CHUNK
--/T <li>SEGMENT - the idealized boundary of a segment
--/T <li>CAMCOL - the real boundary of a segment
--/T <li>PLATE - the boundary of a plate
--/T <li>TILE - the boundary of a circular tile
--/T <li>TIGEOM - the boundary of a Tiling Run, also includes
--/T     inverse regions, which must be excluded
--/T <li>RUN - the union of the CAMCOLs making up a Run
--/T <li>WEDGE -- intersection of tiles as booleans.
--/T <li>TILEBOX -- intersection of TIGEOM respecting masks (these are positive convex TIGEOM)
--/T <li>SKYBOX  -- intersection and union of TILEBOX to cover the sky with positive disjoin convex regions.  
--/T <li>SECTORLETS -- intersection of Skyboxes with wedges.  These are the areas that have targets.
--/T <li>SECTORS -- collects together all the sectorlets with the same covering (and excluded) tiles. 
--/T <br> See also the RegionConvex and Halfspace tables 
-------------------------------------------------------
	regionid		bigint identity(1,1) NOT NULL,
	[id]			bigint NOT NULL,	--/D key of the region pointing into other tables
	type			varchar(16) NOT NULL,	--/D type of the region (STRIPE|STAVE|...)
	comment			varchar(1024) NOT NULL,	--/D description of the region
	ismask			tinyint NOT NULL DEFAULT(0), --/D 0: region, 1: to be excluded
	area			float	NOT NULL DEFAULT(0), --/D area of region --/U deg^2 --/K EXTENSION_AREA 
	regionString	varchar(max) DEFAULT(''), --/D the string representation of the region
	regionBinary	varbinary(max) DEFAULT(0x00)  --/D the precompiled XML description of region
)
GO


--===========================================================
if exists (select * from dbo.sysobjects 
	where name= N'RegionPatch')
	drop table RegionPatch
GO
--
EXEC spSetDefaultFileGroup 'RegionPatch'
GO
--
CREATE TABLE RegionPatch (
-------------------------------------------------------------------------------
--/H Defines the attributes of the patches of a given region
--
--/T Regions are the union of convex hulls and are defined in the Region table.
--/T Convexes are the intersection of halfspaces defined by the HalfSpace table. 
--/T Each convex is then broken up into a set of Patches, with their own
--/T bounding circle.
--/T See also the Region table
-------------------------------------------------------------------------------
	regionid    bigint 	not null, 		--/D Unique Region ID
	convexid    bigint 	not null, 		--/D Unique Convex ID
	patchid		int 	not null,		--/D Unique patch number
	[type]		varchar (16) not null, 		--/D CAMCOL, RUN, STAVE, TILE, TILEBOX, SKYBOX, WEDGE, SECTOR...
	radius		float   not null default(0),--/D radius of bounding circle centered at ra, dec --/U arcmin
	ra		float not null default(0),	--/D right ascension of observation --/U deg
	dec		float not null default(0),	--/D declination of observation --/U deg
	x		float not null default(0),	--/D x of centerpoint Normal unit vector in J2000
	y		float not null default(0),	--/D y of centerpoint Normal unit vector in J2000
	z		float not null default(0),	--/D z of centerpoint Normal unit vector in J2000
	c		float not null default(0),	--/D offset of the equation of plane
	htmid	bigint not null default(0),	--/D 20 deep Hierarchical Triangular Mesh ID of centerpoint
	area	float not null default(0), --/D area of the patch --/U deg^2
	convexString varchar(max) default('') --/D {x,y,z,c}+ representation of the convex of the patch
)
GO


--=======================================================
if exists (select * from dbo.sysobjects 
	where name = N'HalfSpace') 
	drop table HalfSpace
GO
--
EXEC spSetDefaultFileGroup 'HalfSpace'
GO
--
CREATE TABLE HalfSpace (
-------------------------------------------------------
--/H The constraints for boundaries of the the different regions
--  --------------------------------------------------
--/T Boundaries are represented as the equation of a 3D plane,
--/T intersecting the unit sphere. These intersections are
--/T great and small circles. THe representation is in terms
--/T of a 4-vector, (x,y,z,c), where (x,y,z) are the components
--/T of a 3D normal vector pointing along the normal of the plane
--/T into the half-scape inside our boundary, and c is the shift
--/T of the plane along the normal from the origin. Thus, c=0
--/T constraints represent great circles. If c<0, the small circle
--/T contains more than half of the sky.
--/T See also the Region and RegionConvex tables
-------------------------------------------------------
	constraintid	bigint NOT NULL identity(1,1), --/D id for the constraint
	regionid	bigint NOT NULL,	--/D pointer to RegionDefs
	convexid	bigint NOT NULL,	--/D unique id for the convex
	x		float NOT NULL,		--/D x component of normal
	y		float NOT NULL,		--/D y component of normal
	z		float NOT NULL,		--/D z component of normal
	c		float NOT NULL		--/D offset from center along normal
)
GO


--=======================================================
IF EXISTS (select * from dbo.sysobjects 
	where name=N'RegionArcs') 
	drop table RegionArcs
GO
--
EXEC spSetDefaultFileGroup 'RegionArcs'
GO
--
CREATE TABLE RegionArcs (
----------------------------------------------------
--/H Contains the arcs of a Region with their endpoints
--
--/T An arc has two endpoints, specified via their equatorial
--/T coordinates, and the equation of the circle (x,y,z,c) of
--/T the arc. The arc is directed, the first point is the
--/T beginning, the second is the end. The arc belongs to a 
--/T Region, a Convex and a patch. A patch is a contigous area 
--/T of the sky. Within a patch the consecutive arcids represent 
--/T a counterclockwise ordering of the vertices.
-----------------------------------------------------
	arcid 		int identity(1,1),	--/D unique id of the arc
	regionid 	bigint NOT NULL, 	--/D unique region identifier
	convexid 	bigint NOT NULL, 	--/D convex identifier
	constraintid 	bigint NOT NULL, 	--/D id of the constraint
	patch 		int NOT NULL,		--/D id of the patch
	state 		int NOT NULL,		--/D state (3: bounding circle, 2:root, 1: hole)
	draw 		int NOT NULL, 		--/D 0:hide, 1: draw
	ra1 		float NOT NULL, 	--/D ra of starting point of arc
	dec1 		float NOT NULL,  	--/D dec of starting point of arc
	ra2 		float NOT NULL,  	--/D ra of end point of arc
	dec2 		float NOT NULL,  	--/D dec of end point of arc
	x 			float NOT NULL, 	--/D x of constraint normal vector
	y 			float NOT NULL, 	--/D y of constraint normal vector 	
	z 			float NOT NULL, 	--/D z of constraint normal vector 
	c 			float NOT NULL, 	--/D offset of constraint
	length 		float default(0.0) NOT NULL	--/D length of arc in degrees --/U deg
)
GO


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



--===============================================================
IF EXISTS (select * from  sysobjects 
	WHERE name = N'Region2Box' )
	DROP TABLE Region2Box
GO
--
EXEC spSetDefaultFileGroup 'Region2Box'
GO
--
CREATE TABLE Region2Box (
-----------------------------------------------------------------
--/H Tracks the parentage which regions contribute to which boxes
-----------------------------------------------------------------
--/T For the sector computation, Region2Box tracks the parentage
--/T of which regions contribute to which boxs.
--/T TileRegions contribute to TileBoxes
--/T TileRegions and TileBoxes contribute to SkyBoxes
--/T Wedges and SkyBoxes contribute to Sectorlets
--/T Sectorlets contribute to Sectors
-----------------------------------------------------------------
	regionType 	varchar(16) NOT NULL,	--/D type of parent, (TIGEOM)
	[id]		bigint NOT NULL, 	--/D the object id of the other parent region
	boxType 	varchar(16) NOT NULL,	--/D type of child (TILEBOX, SKYBOX)
	boxid		bigint NOT NULL		--/D regionid of child
)
GO


--=============================================================
IF  EXISTS (SELECT * FROM sys.views 
		WHERE object_id = OBJECT_ID(N'[dbo].[RegionConvex]'))
		DROP VIEW [dbo].[RegionConvex]
GO
--
CREATE VIEW RegionConvex
---------------------------------------------------------------
--/H Emulates the old RegionConvex table for compatibility
--/U ----------------------------------------------------------
--/T Implemented as a view, translates patchid to patch
---------------------------------------------------------------
AS
	SELECT	regionid, convexid, patchid as patch, type, 
			radius, ra,dec,x,y,z,c, htmid, convexString
	FROM RegionPatch
GO


-- revert to primary file group
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO



--==============================================================
PRINT '[RegionTables.sql]: Created tables for Region package'
--==============================================================
