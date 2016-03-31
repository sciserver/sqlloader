--=========================================================
--  resolveTables.sql
--  2010-11-12	Michael Blanton
-----------------------------------------------------------
--  Resolve tables.
-----------------------------------------------------------
-- History:
--* 2010-11-12  Ani: Copied in schema for tables from sas-sql.
--* 2010-11-24  Ani: Changed thingIndex.objID to bigint.
--* 2012-07-18  Ani: Added note about DR8 ra,dec to thingIndex
--*             description.
--* 2013-07-23  Ani: Added isPrimary column to detectionIndex.
--* 2016-03-28  Ani: Removed isPrimary column from detectionIndex
--*                  so it can be added later in FINISH step. This
--*                  allows the table to be loaded from CSV.
--=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'detectionIndex')
	DROP TABLE detectionIndex
GO
EXEC spSetDefaultFileGroup 'detectionIndex'
GO
CREATE TABLE detectionIndex (
-------------------------------------------------------------------------------
--/H Full list of all detections, with associated "thing" assignment.
--
--/T Each row in this table corresponds to a single catalog entry,
--/T or "detection" in the SDSS imaging. For each one, this table
--/T lists a "thingId", which is common among all detections of 
--/T the same object in the catalog.
-------------------------------------------------------------------------------
thingId		bigint NOT NULL,	--/D thing ID number
objId		bigint NOT NULL,	--/D object ID number (from run, camcol, field, id, rerun)
loadVersion	int	NOT NULL	--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--



IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'thingIndex')
	DROP TABLE thingIndex
GO
EXEC spSetDefaultFileGroup 'thingIndex'
GO
CREATE TABLE thingIndex (
-------------------------------------------------------------------------------
--/H Full list of all "things": unique objects in the SDSS imaging
--
--/T Each row in this table corresponds to a single "thing" observed
--/T by the SDSS imaging survey. By joining with the "detectionIndex"
--/T table one can retrieve all of the observations of a particular 
--/T thing.
--/T NOTE: The RA and Dec in this table refer to the DR8 coordinates,
--/T which have errors in the region north of 41 deg in Dec, since
--/T those were used for the resolving of the survey.  These errors
--/T should have a very small effect on the decision about which
--/T objects are matched to each other.
-------------------------------------------------------------------------------
thingId 	bigint NOT NULL, 	--/D thing ID number
sdssPolygonID	int NOT NULL,		--/D id number of polygon containing object in sdssPolygons --/F balkan_id
fieldID		bigint NOT NULL,	--/D field identification of primary field
objID 		bigint NOT NULL,	--/D id of object for primary (or best) observation
isPrimary	tinyint NOT NULL,	--/D Non-zero if there is a detection of this object in the primary field covering this balkan.
nDetect		int NOT NULL,		--/D Number of detections of this object.
nEdge		int NOT NULL,		--/D Number of fields in which this is a RUN_EDGE object (observation close to edge)
ra		float NOT NULL,		--/D DR8 Right ascension, J2000 deg
dec		float NOT NULL,		--/D DR8 Declination, J2000 deg
loadVersion	int	NOT NULL	--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO

--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[resolveTables.sql]: Resolve tables created'
GO
