--=============================================================================================
--   neighborTables.sql
--   2003-05-15 Alex Szalay, split off from the photoTables.sql
-----------------------------------------------------------------------------------------------
-- History:
--* 2003-05-15 Alex: split off from the photoTables.sql
--* 2003-05-19 Jim: added Match and MatchHead tables
--* 2003-07-08 Ani: Removed references to MatchMiss table from Match/MatchHead text (PR 5464).
--* 2004-08-26 Alex: updated Match and MatchHead
--* 2010-11-18 Ani: Removed Match/MatchHead tables.
--=============================================================================================
SET NOCOUNT ON
GO

--======================================================
if exists (select name FROM sysobjects
	where xtype='U' AND name = 'Neighbors')
	drop table Neighbors
GO
--
EXEC spSetDefaultFileGroup 'Neighbors'
GO
--
CREATE TABLE Neighbors ( 
-------------------------------------------------------------------------------
--/H All PhotoObj pairs within 0.5 arcmins
--
--/T SDSS objects within 0.5 arcmins and their match parameters stored here. 
--/T Make sure to filter out unwanted PhotoObj, like secondaries.
-------------------------------------------------------------------------------
	objID 			bigint	NOT NULL, --/D The unique objId of the center object --/K ID_CATALOG
	neighborObjID		bigint	NOT NULL, --/D The objId of the neighbor --/K ID_CATALOG
	distance 		float 	NOT NULL, --/D Distance between center and neighbor --/U arcmins --/K POS_ANG_DIST_GENERAL
	type			tinyint NOT NULL, --/D Object type of the center --/K CLASS_OBJECT
	neighborType		tinyint NOT NULL, --/D Object type of the neighbor --/K CLASS_OBJECT
	mode			tinyint NOT NULL, --/D object is primary, secondary, family, outside  --/K CODE_MISC
	neighborMode		tinyint NOT NULL  --/D is neighbor primary, secondary, family, outside  --/K CODE_MISC
)
GO
--

--==================================================
if exists (select [name] from sysobjects 
	where [name] = N'Zone' ) 
	drop table Zone
GO
--
EXEC spSetDefaultFileGroup 'Zone'
GO
--
CREATE TABLE Zone (
---------------------------------------------------
--/H Table to organize objects into declination zones
--
--/T In order to speed up all-sky corss-correlations,
--/T this table organizes the PhotoObj into 0.5 arcmin
--/T zones, indexed by the zone number and ra.
---------------------------------------------------
	zoneID	int not null, 		--/D id counts from -90 degrees == 0 --/K EXTENSION_AREA
	ra 	float not null , 	--/D ra of object --/U deg --/K POS_EQ_RA_MAIN
	[dec] 	float not null, 	--/D declination of object --/U deg --/K POS_EQ_DEC_MAIN
	objID 	bigint not null,	--/D object ID --/K ID_CATALOG
	type 	tinyint not null,	--/D object type (star, galaxy) --/K CLASS_OBJECT
	mode 	tinyint not null,	--/D mode is primary, secondary, family, outside  --/K CODE_MISC
	cx 	float not null,		--/D Cartesian x of the object --/K POS_EQ_CART_X
	cy 	float not null,		--/D Cartesian y of the object --/K POS_EQ_CART_Y
	cz 	float not null,		--/D Cartesian z of the object --/K POS_EQ_CART_Z
	native  tinyint not null	--/D true if obj is local, false if from the destination dataset --/K CODE_MISC
)	
GO


-----------------------------------------------
-- MATCH Table DDL and BUILDING CODE
-----------------------------------------------

--===============================================================
-- observations, 
-- (1) only work with good objects 
--	 mode 1,2 == primary secondary.
-- 	 type 3,5,6,  == galaxy, unknown, star 
-- (2) chains are short 1 or 2 in this.
-- (3) radius of .6 arcsec is probably good enough for "true" matches.
--     we are using 1 arcsec
--===============================================================
-- to do: 
--	  add Match, MatchHead, MatchMiss to FileGroup setup      
--        move table build to spFinish 
--===============================================================
go



--=================================================
if exists (select * from sysobjects 
	where name like N'Match') 
	drop table Match
GO
--

--=================================================
if exists (select * from sysobjects 
	where name like N'MatchHead') 
	drop table MatchHead
GO
--


EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[NeighborTables.sql]: Neighbor and Match tables created'
GO
