--=========================================================
--  WindowTables.sql
--  2009-07-29	Michael Blanton
-----------------------------------------------------------
--  Wondow Function Schema for SQL Server
-----------------------------------------------------------
-- History:
--* 2009-07-30  Ani: Adapted from sas-sql/sdssWindow.sql.
--* 2009-10-07  Ani: Changed REAL to FLOAT for coords.
--* 2010-01-18  Ani: Updated descriptions of mangle coords
--*                  in sdssImagingHalfSpaces.
--=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssImagingHalfSpaces')
	DROP TABLE sdssImagingHalfSpaces
GO
--
EXEC spSetDefaultFileGroup 'sdssImagingHalfSpaces'
GO
CREATE TABLE sdssImagingHalfSpaces (
-------------------------------------------------------------------------------
--/H Half-spaces (caps) describing the SDSS imaging geometry
--
--/T Each row in this table corresponds to a single polygon
--/T in the SDSS imaging data window function.
-------------------------------------------------------------------------------
sdssPolygonID	int NOT NULL, --/D integer description of polygon
x	float NOT NULL, --/D x-component of normal vector
y	float NOT NULL, --/D y-component of normal vector
z	float NOT NULL, --/D z-component of normal vector
c	float NOT NULL, --/D offset from center along normal
xMangle	float NOT NULL, --/D mangle version of x-component 
yMangle	float NOT NULL, --/D mangle version of y-component 
zMangle	float NOT NULL, --/D mangle version of z-component 
cMangle	float NOT NULL, --/D mangle version of offset from center 
loadVersion	int	NOT NULL	--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssPolygons')
	DROP TABLE sdssPolygons
GO
--
EXEC spSetDefaultFileGroup 'sdssPolygons'
GO
CREATE TABLE sdssPolygons (
-------------------------------------------------------------------------------
--/H Polygons describing SDSS imaging data window function
--
--/T Each row in this table corresponds to a single polygon
--/T in the SDSS imaging data window function.
-------------------------------------------------------------------------------
sdssPolygonID	int NOT NULL, --/D integer description of polygon
nField	int NOT NULL, --/D number of fields in the polygon
primaryFieldID	bigint NOT NULL, --/D ID of primary field in this polygon
ra	float NOT NULL, --/D RA (J2000 deg) in approximate center of polygon   --/U deg
dec	float NOT NULL, --/D Dec (J2000 deg) in approximate center of polygon  --/U deg
area	float NOT NULL, --/D area of polygon  --/U square deg
loadVersion	int	NOT NULL	--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sdssPolygon2Field')
	DROP TABLE sdssPolygon2Field
GO
--
EXEC spSetDefaultFileGroup 'sdssPolygon2Field'
GO
CREATE TABLE sdssPolygon2Field (
-------------------------------------------------------------------------------
--/H Matched list of polygons and fields
--
--/T Each row in this table corresponds to 
-------------------------------------------------------------------------------
sdssPolygonID	int NOT NULL, --/D integer designator of polygon
fieldID	bigint NOT NULL, --/D field identification
loadVersion	int	NOT NULL	--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--


EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[WindowTables.sql]: Window tables and related views created'
GO

