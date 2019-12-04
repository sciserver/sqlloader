--=======================================================
--   IndexMap.sql
--   2002-07-01 Jim Gray
---------------------------------------------------------
-- Manage primary keys, foreign keys, and indices
-- Various stored procedures to manage indexes, 
-- update statistics on all tables and views,
-- and grant users read/execute access to user objects
------------------------------------------------------------
--* 2002-07-08 Jim: modified to V4 schema for PhotoProfile.
--*		dropped extra neighbor foreign key,
--*		added field->segment forign key,
--*		added segment->chunk forign key,
--*		added chunk->stripeDefs foreign key,
--*		added fieldProfile->Field,
--*		added PhotoProfile-PhotoObj,
--*		added Mosaic foreign keys.
--* 2001-11-01 Jan: created from system dump
--* 2001-11-08 Alex: manual edits for concise naming convention
--* 2001-11-09 Alex: total count of indices is 21
--* 2002-10-12 Alex: commented out Extinction, Mosaic, made other V4 changes
--* 2002-10-12 Alex: commented out Synonym and Crossid, need to add tiling stuff later
--* 2002-10-22 Alex+Jim: distanceMin-> Distance in Neighbors, isPrimary->mode in neighbors.
--*		Added sp's to drop and add indices.
--* 2002-10-28 Alex+Jim: Revised index definitions to match new (V4) column names,
--*		best and target IDs in spectra, sciencePrimary and so on.
--* 2002-10-26 Alex: merged with index management
--* 2002-10-26 Alex: modified spGrantExec to manage access rights
--* 2002-10-28 Jim: made drop index transactional.
--*		merged spManageIndices and spBuildIndices
--* 2002-11-08 Jim: fixed bug in drop index
--* 2002-11-24 Jim: tied to load enviroment (generate phase messages)
--*		converted to spCreateIndex()
--* 2002-11-25 Alex: moved spGrantAccess to separate file
--* 2002-11-30 Jim: recovered lost files (from Windows File loss),
--*		added Tiles key and foreign key creates.
--* 2002-12-08 Alex: commented out SpecObjAll 'TargetObjID,objType,....'
--* 2002-12-10 Alex: moved Sector stuff into @buildall=1
--* 2002-12-19 Alex: added skyVersion to TargetInfo PK
--* 2003-01-27 Ani: Made changes to tiling schema as per PR# 4702:
--*		renamed TileRegion to TilingRegion,
--*		renamed TileInfo to TilingInfo,
--*		renamed TileNotes to TilingNotes,
--*		renamed TileBoundary to TilingGeometry,
--*		change the primary key of TilingInfo from (tileRun,tid)
--*		to (tileRun,targetID)
--*		removed TiBound2TsChunk and Target2Sector
--* 2003-01-28 Alex: commented out the indices on the PhotoObj table, 
--* 		they will move to PhotoTag
--* 2003-01-28 Jim:  fixed primary index create to have 'with sort_in_tempdb
--* 2003-02-23 Alex: added HTM index to specObj, Target, Mask
--* 2003-05-15 Alex: changed PhotoObj to PhotoObjAll for now
--* 2003-05-21 Adrian+Alex: changed pk for Tiling tables, to reflect updates
--* 2003-05-23 Alex: changed it to use the IndexMap table
--* 2003-05-26 Alex: moved spUpdateStatistics to metadataTables
--* 2003-05-28 Alex: added IndexMap table, modified procedures to work with this.
--* 2003-06-05 Alex: fixed filegroup assignment in spCreateIndex
--* 2003-06-07 Alex: added fIndexName function, also QSo* indexes
--* 2003-08-06 Ani: Fixed pk creation for PhotoObjAll (PR #5542)
--*		the IndexGroup shd have been PHOTO, not PHOTOOBJ
--* 2003-08-20 Ani: Added RegionConvexString and TileContains.
--* 2003-08-22 Ani: Changed RegionConvexString and TileContains to FINISH category.
--* 2003-12-04 Jim: fixed drop primary key bug in spDropIndex
--* 2004-08-13 Ani: added phase message to spBuildPrimaryKeys.
--* 2004-09-02 Alex: removed index on DBObjectDescription, the table has been dropped
--* 2004-09-03 Alex: remove TileContains and RegionConvexString references, both obsolete
--* 2004-09-06 Alex: added two more foreign keys related to Match->MatchHead, 
--*		and PlateX->TileAll
--* 2004-09-10 Alex: moved here spCheckDBIndexes from MetadataTables.sql
--* 2004-09-10 Alex: changed the names spCreateIndex->spIndexCreate, and
--*		spBuildNextIndex->spIndexBuildNext, spDropIndex->spIndexDrop,
--*		spBuildIndex -> spIndexBuild. Also the procedures spBuildIndices,
--*		spBuildForeignKeys, spBuildPrimaryKeys, spIndexBuildNext
--*		and spIndexFinish were removed.
--* 2004-09-17 Alex: added pk/fk for the new tables: Versions, History, Inventory, Dependency
--* 2004-09-17 Alex: changed spIndexBuild to spIndexBuildSelection, and added spIndexDropSelection
--*		and move spCheckDBIndexes to spCheckDB.sql
--* 2004-10-09 Jim+Alex: added local version of spNewPhase
--* 2004-10-11 Alex+Jim: added case sensitivity and tableName to spIndex*Selection
--* 2004-11-11 Alex: added local wrappers for spStartStep and spEndStep
--* 2004-12-02 Ani: added RC3 and Stetson clustered indices.
--* 2005-01-13 Ani: Fixed stepid problem in spStartStep - made it OUTPUT in
--*            loadsupport call and made sure it only returns stepid=1 for
--*            taskid=0.
--* 2005-02-01 Ani: Fixed a bug in error-handling in spIndexCreate that
--*            caused errors to be lost (was checking @@error instead of
--*            @error); also added a check and warning message for a
--*            nonexistent table in the same procedure.
--* 2005-02-03 Ani: Backed out check for nonexistent table to force one-one
--*            match between IndexMap and current schema.
--* 2005-02-04 Alex: removed info messages about redundant index operations
--* 2005-02-05 Ani: Added check for pk constraint being a pk index previously
--*            in spIndexDropList.  If it is an index, drop the index not
--*            the constraint.
--* 2005-02-06 Jim: added time to QueryResutlts primary key
--* 2005-03-06 Alex: changed primary key for Region2Box, reflecting regionid->id change.
--* 2005-03-10 Alex: added patch to PK columns in RegionConvex
--* 2005-03-12 Alex: changed FK Sector2Tile.regionid to point to Region
--* 2005-03-15 Jim: added stetson index map entries for ra, dec
--* 2005-03-30 Ani: Added PK and FK for USNOB.
--* 2005-04-02 Ani: Added PK and FK for QuasarCatalog.
--* 2005-07-13 Ani: Added indices for PhotoAuxAll table.
--* 2005-10-22 Ani: Renamed USNOB to ProperMotions (PR #6638).
--* 2005-12-13 Ani: Commented out Photoz table entries, not loaded any more.
--* 2005-12-20 Ani: Added index on Match.matchhead (PR #6820).
--* 2006-02-02 Ani: Reinstated Photoz table entries.
--* 2006-02-09 Ani/Jim: Added ra/dec index for PhotoObjAll, PhotoTag and
--*            SpecObjAll.
--* 2006-03-08 Ani: Added TargRunQA PK index.
--* 2006-04-09 Ani: Updated QsoCatalogAll entries, replaced QsoConcordance
--*            with QsoConcordanceAll, added entries for QsoBunch, QsoBest,
--*            QsoTarget and QsoSpec.
--* 2006-05-11 Ani: Added K and F entries for Photoz2 table.
--* 2006-12-20 Ani: Made indices for Photoz, Photoz2 and ProperMotions
--*            conditional (only creeated if this is not a TARGDRx DB).
--* 2006-12-26 Ani: Made SPECTRO, QSO, TILES indices also conditional.
--* 2006-01-08 Ani: Removed indices for PhotoAuxAll table (it's a view now,
--*            see PR #7000).
--* 2007-01-08 Ani: Modified spIndexCreate to print an error message if the
--*            table doesn't exist.
--* 2007-01-17 Ani: Modified spIndexBuildSelection and spIndexDropSelection
--*            to handle FKs for a given table (needed to drop and
--*            recreate specific FKs before and after a schema sync.
--* 2007-01-24 Ani: Added covering index to PhotoTag similar to PhotoObjAll
--*            index on htmid,run,camcol,..., because without it the
--*            joins in some of the nearby functions were very slow.
--* 2007-01-31 Ani: Added "untiled" to htmid index on TiledTargetAll to
--*            fix a performance problem with fGetNearbyTiledTargetsEq.
--* 2007-04-12 Ani: Added PK, FK indices for Ap7Mag and UberCal tables.
--* 2007-06-14 Ani: Renamed QuasarCatalog to DR3QuasarCatalog, added indices
--*            for DR5QuasarCatalog.
--* 2007-06-15 Ani: Added PKs for sppLines and sppParams.
--* 2007-06-15 Ani: Added RegionPatch indices.
--* 2007-08-25 Ani: Commented out RegionConvex indices - it's a view now.
--*                 Also commented out ProperMotions FK.
--* 2007-08-25 Ani: Added search on tablename for foreign keys in 
--*                 spIndexBuildSelection.
--* 2008-03-20 Ani: Added PK index for PsObjAll (PR #7014).
--* 2008-08-31 Ani: Added indices for OrigField, OrigPhotoObjAll and UberAstro.
--* 2008-10-10 Ani: Added PK entry for FieldQA table.
--* 2009-08-14 Ani: SDSS-III changes: removed tables that no longer exist, and
--*            columns that have been removed or renamed.  Removed isoA_r, 
--*            isoB_r from PhotoObjAll indices.
--* 2009-12-30 Ani: Added PKs for sppParams, sppLines, galSpec tables (in SPECTRO
--*            group) and window function tables (in REGION group).
--* 2010-01-14 Ani: Replaced ObjMask with AtlasOutline.
--* 2010-02-09 Ani: Added PK for sppTargets (but commented out for now).
--* 2010-07-16 Naren: uncommented sppTargets PK.
--* 2010-07-28 Ani: Commented out sppTargets PK again.
--* 2010-11-16 Ani: Removed Glossary, Algorithm and TableDesc tables, and
--*                 adeed resolve table indices.
--* 2010-11-18 Ani: Went through and cleaned up discontinued tables, etc.
--* 2010-11-26 Ani: Deleted detectionIndex PK and added FKs for resolve tables.
--* 2010-11-30 Ani: Deleted Region2Box PK.
--* 2010-12-03 Ani: Deleted obsolete SpecPhotoAll index on targetid.
--* 2010-12-08 Ani: Deleted indices for segueTargetAll.
--* 2010-12-09 Ani: Renamed TargetParam to sdssTargetParam.
--* 2010-12-10 Ani: Changed detectionIndex objid to PK from FK.
--* 2010-12-11 Ani: Removed PhotoTag indices.
--* 2010-12-11 Ani: Added paramFile to sdssTargetParam PK.
--* 2010-12-11 Ani: Added dummy entry for i_PhotoObjAll_phototag fat index.
--* 2010-12-20 Ani: Added (non-unique) index on objID for thingIndex.
--* 2010-12-21 Ani: Added PK indices for xmatch tables and nonclustered index
--*                 on thingID for detectionIndex table.
--* 2011-02-23 Ani: Added PK/FK indices for Photoz* tables.
--* 2011-03-12 Ani: Added entry for PhotoObjAll index on parentid,mode,type,
--*                 although this index currently needs to be created manually
--*                 because it has additional included columns run,rerun,camcol
--*                 field,u,g,r,i,z.
--* 2011-03-14 Ani: Deleted FK entry for FIRST, none of the external match
--*                 tables have FKs now.
--* 2011-05-20 Ani: Added PK indices for DR7 xmatch tables.
--* 2012-02-23 Ani: Added PK indices for DR9 astrom patch tables.
--* 2012-05-23 Ani: Replaced "objType" with "sourceType".
--* 2012-05-31 Ani: Added PKs for galaxy product tables for DR9.
--* 2012-06-19 Ani: Updated galaxy product table names.
--* 2012-07-10 Ani: Updated logic for dropping and building table FKs. 
--* 2012-07-10 Ani: Reverted logic for dropping and building table FKs. 
--* 2012-07-18 Ani: Added index on PhotoObjDR7.dr7objd.
--* 2012-07-19 Ani: Added SCHEMA group of FKs so schema diagram will show
--*                 proper relationships.  Updated spIndexBuildSelection
--*                 to handle this special group properly.
--* 2012-07-26 Ani: Added sdssTilingGeometry PK (tilingGeometryID).
--* 2012-07-26 Ani: Fixed typos in sdssTilingGeometry PK (tilingGeometryID).
--* 2012-07-29 Ani: Commented out SCHEMA group of FKs.
--* 2012-07-29 Ani: Deleted PKs for astromDR9, ProperMotionsDR9.
--* 2012-07-29 Ani: Added spIndexCreatePhotoTag to create fat index PhotoTag
--*                 in PhotoObjAll..
--* 2013-03-26 Ani: Added PKs for APOGEE tables.
--* 2013-03-27 Ani: Commented out references to PhotoTag table.
--* 2013-04-02 Ani: Added check for pre-existence of Phototag index and
--*                 added column "clean" to the Phototag index.  Also
--*                 fixed error/typo in spIndexBuildSelection.
--* 2013-05-06 Ani: Updated galaxy product PKs for DR10.
--* 2013-05-21 Ani: Added WISE table PKs.
--* 2013-05-22 Ani: Added PK for aspcapStarCovar.
--* 2013-05-22 Ani: Updated PK for aspcapStarCovar (composite of 2 columns).
--* 2013-06-14 Ani: Added Galaxy Zoo 2 table PKs, FKs.
--* 2013-07-03 Ani: Added reduction_id to apogeeStar PK.
--* 2013-07-03 Ani: Added PK for apogeeObject and reset apogeeStar PK
--* 2013-07-09 Ani: Added PKs for apogeeStarVisit and apogeeStarAllVisit.
--* 2013-07-10 Ani: Fixed spIndexDropSelection logic for dropping FK for
--*                 single table.
--* 2013-07-10 Ani: Added NOCHECK to FK creation in spIndexCreate.
--* 2013-07-11 Ani: Updated zoo2 PKs.
--* 2013-07-23 Ani: Updated detectionIndex PK to include thingId.
--* 2013-08-02 Ani: Added index on apogee_id for apogeeObject, to speed up 
--*                 Explore queries.
--* 2013-09-17 Ani: Added PKs and indices to zoo* tables, and indices to   
--*                 WISE_xmatch and APOGEE tables to speed up queries.
--* 2013-09-20 Ani: Fixed bug in spIndexBuildList which caused it to skip
--*                 items in the list it was given.
--* 2013-09-28 Ani: Added indices for WISE_allsky, as per PR #1892.
--* 2013-09-29 Ani: Deleted duplicate entry for WISE_allsky.tmass_key.
--* 2013-09-29 Ani: Added PK for zoo2MainPhotoz (dr7objid).
--* 2013-09-30 Ani: Added 2 more indices for WISE_allsky, as per PR #1892.
--* 2013-10-01 Ani: Added 4 more indices for WISE_allsky, as per PR #1892.
--* 2013-10-01 Ani: Deleted duplicate entry for WISE_allsky.w3cc_map.
--* 2014-02-10 Ani: Added indices for TwoMASS, as per PR #1900, and also
--* 	       	    added index on WISE_allsky.rjce (PR #1909).
--* 2014-02-10 Ani: Added index on glat,glon for WISE_allsky (PR #1913).
--* 2014-09-12 Ani: Added index on SpecObjAll.fluxObjID (PR #2130).
--* 2014-10-14 Ani: Added index on apogeeStar.apogee_id (D.Medvedev).
--* 2014-11-05 Ani: Commented out sdssTilingGeometry->StripeDefs FK
--*            because it causes DataConstants.sql refresh to fail.
--* 2014-11-05 Ani: Added MARVELS DR12 PKs.
--* 2014-11-06 Ani: Added apogeeStar.htmID index and additional columns
--*            to SpecObjAll.BestObjID... index (to speed up default qry).
--* 2014-11-26 Ani: Added apogeeVisit index on plate,mjd,fiberid.
--* 2015-02-09 Ani: Updated Photoz indices for DR12.
--* 2016-02-22 Ani: Added covering index on PhotoObjAll.b (galactic latitude),
--*                 and moved WISE_AllSky.rjce index to FINISH group because it
--*                 is an index on a computed column.
--* 2016-03-22 Ani: Added indices for wiseForced.
--* 2016-03-29 Ani: Added PK and FK for MaNGA tables in SPECTRO group.
--* 2016-04-01 Ani: Added flags settings to commands in spIndexCreate to avoid
--*                 problems with computed columns (e.g. WISE_allsky.rjce).
--* 2016-04-05 Ani: Added PKs for qsoVar* tables.
--* 2016-04-13 Ani: Changed wiseForced to wiseForcedTarget.
--* 2016-07-06 Ani: Added PKs for apogeeDesign, apogeeField and nsatlas.
--* 2017-04-19 Ani: Added PK for APOGEE cannonStar.
--* 2017-05-26 Ani: Added PKs for mangaFirefly and mangaPipe3D.
--* 2017-06-13 Ani: Changed manga[Firefly|Pipe3D] PKs to plateIFU (mangaID not unique).
--* 2017-06-30 Ani: Changed PK for sppTargets to TARGETID (identity column).
--* 2017-07-17 Ani: Added PK for Plate2Target.
--* 2017-12-18 Ani: Added PK for sdssEbossFirefly (VAC). (DR15)
--* 2018-06-11 Ani: Added PK. FK for mangaDAPall. (DR15)
--* 2018-06-12 Ani: Updated FK for mangaDAPall to plateIFU+daptype. (DR15)
--* 2018-06-13 Ani: Added PKs for mangaHIall and mangaHIbonus. (DR15)
--* 2018-07-17 Ani: Added PK for spiders_quasar. (DR14 mini)
--* 2018-07-23 Ani: Added PKs for Mastar tables. (DR15)
--* 2018-07-25 Ani: Fixed PK for mangaHIbonus (added bonusid), fixed typo
--*                 in sdssEbossFirefly PK name. (DR15)
--* 2018-08-02 Sue: Changes to IndexMap for compression, filegroups, and common vs DR-specific
--*					(multi-DR) tables
--*					TODO: fill in all rows, this data is sufficient for DR15 loading
--* 2019-11-23 Ani: Added PKs for mangaGalaxyZoo and mangaAlfalfaDR15. (DR16)
--*
--* 2019-12-03 Sue: Adding PK to PawlikMorph (DR16)
-------------------------------------------------------------------------------
SET NOCOUNT ON;
GO
--

IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNewPhase' AND  type = 'P')
    DROP PROCEDURE spNewPhase
GO
--
CREATE PROCEDURE spNewPhase (
	@taskid int,
	@stepid int,
	@phasename varchar(16), 
	@status varchar(16), 
	@phasemsg varchar(2048)
)
-----------------------------------------------------------------
--/H Wraps the loadsupport spNewPhase procedure for local use
--/A
--/T If @taskid=0, only prints the message
-----------------------------------------------------------------
AS 
BEGIN
	-------------------------------------------------
	SET NOCOUNT ON;
	--
	IF @taskid>0
	    EXEC loadsupport.dbo.spNewPhase @taskid, @stepid,  
		@phasename, @status, @phasemsg 
	ELSE
	    PRINT 'At '+ convert(varchar(30),Current_timestamp,14 )+' ' + @phasemsg;
	-------------------------------------------------
END
GO

--=======================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spStartStep' AND type = 'P')
    DROP PROCEDURE spStartStep
GO
--
CREATE PROCEDURE spStartStep ( @taskid int, @stepid int OUTPUT, @stepname varchar(16), 
	@status varchar(16), @stepmsg varchar(2048), @phasemsg varchar(2048)
)
-----------------------------------------------------------------
--/H Wraps the loadsupport spStartStep procedure for local use
--/A
--/T If @taskid=0, only prints the message, and returns 1 as @stepid
-----------------------------------------------------------------
AS
BEGIN
	-------------------------------------------------
	SET NOCOUNT ON;
	--
	IF @taskid>0
	    EXEC loadsupport.dbo.spStartStep @taskid, @stepid OUTPUT, 
		@stepname, @status, @stepmsg, @phasemsg;
	ELSE
	    BEGIN
		EXEC spNewPhase @taskID, @stepID, 'STARTING', 'START', @phasemsg
		------------------------------------------------
		SET @stepid = 1;
	    END
END
GO


--====================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spEndStep' AND type = 'P')
    DROP PROCEDURE spEndStep
GO
--
CREATE PROCEDURE spEndStep (@taskid int, @stepid int, 
	@status varchar(16), @stepmsg varchar(2048), @phasemsg varchar(2048)
)
-----------------------------------------------------------------
--/H Wraps the loadsupport spEndStep procedure for local use
--/A
--/T If @taskid=0, only prints the message
-----------------------------------------------------------------
AS
BEGIN
	-------------------------------------------------
	SET NOCOUNT ON;
	--
	IF @taskid>0
	    EXEC loadsupport.dbo.spEndStep @taskid, @stepid, 
		@status, @stepmsg, @phasemsg;
	ELSE
	    EXEC spNewPhase @taskID, @stepID, 'FINISHING', @status, @phasemsg
	-------------------------------------------------
END
GO


--========================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'IndexMap')
	DROP TABLE IndexMap
GO
--
EXEC spSetDefaultFileGroup 'IndexMap'
GO
--
CREATE TABLE IndexMap ( 
-------------------------------------------------------------------------------
--/H Table containing the definition of all indices
--/A
--/T Contains all information necessary to build the indices
--/T including the list of fields. Drives both index creation 
--/T and data validation.
-------------------------------------------------------------------------------
	indexmapid	int identity(1,1),	--/D unique primary key for the indexmap --/K CODE_MISC
	code		varchar(2)    NOT NULL, --/D one char designator of index category for lookup ('K'|'F'|'I') --/K CODE_MISC
	type		varchar(32)   NOT NULL, --/D index type, one of ('primary key'|'foreign key'|'index'|'unique index') --/K CODE_MISC
	tableName	varchar(128)  NOT NULL,	--/D the name of the table the index is built on --/K CODE_MISC
	fieldList	varchar(1000) NOT NULL,	--/D the list of columns to be included in the index --/K CODE_MISC
	foreignKey	varchar(1000) NOT NULL,	--/D the definition of the foreign Key if any --/K CODE_MISC
	indexgroup	varchar(128)  NOT NULL,	--/D the group id, one of ('PHOTO'|'TAG'|'SPECTRO'|'QSO'|'META'|'TILES'|'FINISH') --/K CODE_MISC
	[compression] varchar(32) NULL,		--/D type of data compression to use (page | row | none) --/K CODE_MISC
	[filegroup]	varchar(32)	  NULL,		--/D filegroup where index should be created --/K CODE_MISC
	[common]	BIT			  NULL		--/D for multi-DR versions, 0=DR specific, 1=common between DRs --/K CODE_MISC
)

GO
--

-----------------------------------------------------
-- Primary Keys for the META tables
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'PartitionMap', 'fileGroupName', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'FileGroupMap', 'tableName', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'IndexMap', 'indexmapid', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'PubHistory', 'name,loadversion', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'QueryResults', 'query, time', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'RecentQueries', 'ipAddr,lastQueryTime', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'RunShift', 'run', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'Versions', 'version', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ('K', 'primary key', 'DBObjects', 'name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'DBColumns', 'tableName,name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'DBViewCols', 'viewName,name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'History', 'id', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'Inventory', 'filename,name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'Dependency', 'parent,child', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'DataConstants', 'field,name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'Diagnostics', 'name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'SDSSConstants', 'name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'SiteConstants', 'name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'SiteDiagnostics', 'name', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'ProfileDefs', 'bin', '', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'LoadHistory', 'loadVersion,tStart', '', 'META', NULL, NULL, 0)
-----------------------------------------------------
-- Primary Keys for the PHOTO tables
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'PhotoObjAll', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'PhotoProfile', 'objID,bin,band', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'AtlasOutline', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'Frame', 'fieldID,zoom', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'PhotoPrimaryDR7', 'dr8objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'PhotoObjDR7', 'dr8objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'Photoz', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'PhotozErrorMap', 'cellID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'Field', 'fieldID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'FieldProfile', 'fieldID,bin,band', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'Mask', 'maskID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'First', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'RC3', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'Rosat', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'USNO', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'TwoMass', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'TwoMassXSC', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'WISE_xmatch', 'sdss_objID,wise_cntr', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'WISE_allsky', 'cntr', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'wiseForcedTarget', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'thingIndex', 'thingId', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'detectionIndex', 'thingId,objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'ProperMotions', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'StripeDefs', 'stripe', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'MaskedObject', 'objid,maskid', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zooMirrorBias', 'dr7objid', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zooMonochromeBias', 'dr7objid', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zooNoSpec', 'dr7objid', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zooVotes', 'dr7objid', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zoo2MainPhotoz', 'dr7objid', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
-----------------------------------------------------
-- Primary Keys for the SPECTRO tables
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'PlateX', 'plateID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'SpecObjAll', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'SpecDR7', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'sppParams', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'sppLines', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'segueTargetAll', 'objID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'galSpecExtra', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'galSpecIndx', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'galSpecInfo', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'galSpecLine', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'emissionLinesPort', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'stellarMassFSPSGranEarlyDust', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'stellarMassFSPSGranEarlyNoDust', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'stellarMassFSPSGranWideDust', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'stellarMassFSPSGranWideNoDust', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'stellarMassPCAWiscBC03', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'stellarMassPCAWiscM11', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'stellarMassStarformingPort', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'stellarMassPassivePort', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'apogeeDesign', 'designid', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'apogeeField', 'location_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'apogeeVisit', 'visit_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'apogeeStar', 'apstar_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'aspcapStar', 'aspcap_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'apogeePlate', 'plate_visit_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'aspcapStarCovar', 'aspcap_covar_id,aspcap_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'apogeeObject', 'target_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'apogeeStarVisit', 'visit_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'apogeeStarAllVisit', 'visit_id,apstar_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'cannonStar', 'cannon_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaDAPall', 'plateIFU,daptype', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaDRPall', 'plateIFU', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaTarget', 'mangaID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'nsatlas', 'nsaID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaFirefly', 'plateIFU', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaPipe3D', 'plateIFU', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaHIall', 'plateIFU', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaHIbonus', 'plateIFU,bonusid', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaGalaxyZoo', 'nsa_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'mangaAlfalfaDR15', 'plateIFU', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'qsoVarPTF', 'VAR_OBJID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'qsoVarStripe', 'VAR_OBJID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zooSpec', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zooConfidence', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zoo2MainSpecz', 'dr7objid', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zoo2Stripe82Coadd1', 'stripe82objid', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zoo2Stripe82Coadd2', 'stripe82objid', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'zoo2Stripe82Normal', 'dr7objid', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'marvelsStar', 'STARNAME,PLATE', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'marvelsVelocityCurveUF1D', 'STARNAME,BEAM,RADECID,FCJD,[LST-OBS]', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sppTargets', 'TARGETID', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssEbossFirefly', 'specObjID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'spiders_quasar', 'name', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'mastar_goodstars', 'mangaid', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'mastar_goodvisits', 'mangaid,mjd', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]	  VALUES ( 'K', 'primary key', 'PawlikMorph', 'mangaid', '', 'SPECTRO', 'page', 'SPEC', 0)

-----------------------------------------------------
-- Primary Keys for the TILES tables
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'Target', 'targetID', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'TargetInfo', 'skyVersion,targetID', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssTargetParam', 'targetVersion,paramFile,name', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssTileAll', 'tile', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssTilingGeometry', 'tilingGeometryID', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssTilingRun', 'tileRun', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssTiledTargetAll', 'targetID', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssTilingInfo', 'tileRun,targetID', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'plate2Target', 'plate2TargetID,plate,objid', '', 'TILES', NULL, NULL, 1)
-----------------------------------------------------
-- Primary Keys for the REGION tables
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'RMatrix', 'mode,row', '', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'Region', 'regionId', '', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'HalfSpace', 'constraintid', '', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'RegionArcs', 'regionId,convexid,arcid', '', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'RegionPatch', 'regionid,convexid,patchid', '', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssImagingHalfspaces', 'sdssPolygonID,x,y,z', '', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssPolygon2Field', 'sdssPolygonID,fieldID', '', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'sdssPolygons', 'sdssPolygonID', '', 'REGION', NULL, NULL, 1)
----------------------------------------------------
-- Primary Keys for the FINISH tables
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'Zone', 'zoneID,ra,objID', '', 'ZONE', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'Neighbors', 'objID,NeighborObjID', '', 'NEIGHBORS', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'K', 'primary key', 'SpecPhotoAll', 'specObjID', '', 'FINISH', NULL, NULL, 0)

--------------------------------------------------
-- Foreign keys for PHOTO
--------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'PhotoObjAll', 'fieldID', 'Field(fieldID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'PhotoProfile', 'objID', 'PhotoObjAll(objID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'AtlasOutline', 'objID', 'PhotoObjAll(objID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'Frame', 'fieldID', 'Field(fieldID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'Photoz', 'objID', 'PhotoObjAll(objID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'detectionIndex', 'thingID', 'thingIndex(thingID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'thingIndex', 'sdssPolygonID', 'sdssPolygons(sdssPolygonID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'FieldProfile', 'fieldID', 'Field(fieldID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'ProperMotions', 'objID', 'PhotoObjAll(objID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'MaskedObject', 'objID', 'PhotoObjAll(objID)', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'MaskedObject', 'maskID', 'Mask(maskID)', 'PHOTO', 'PAGE', 'PHOTO', 1)

--------------------------------------------------
-- Foreign keys for SPECTRO
--------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'SpecObjAll', 'plateID', 'PlateX(plateID)', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'mangaDAPall', 'mangaID', 'mangaTarget(mangaID)', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'mangaDRPall', 'mangaID', 'mangaTarget(mangaID)', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'zoo2MainSpecz', 'dr8objid', 'PhotoObjAll(objid)', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'zoo2Stripe82Coadd1', 'dr8objid', 'PhotoObjAll(objid)', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'zoo2Stripe82Coadd2', 'dr8objid', 'PhotoObjAll(objid)', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'zoo2Stripe82Normal', 'dr8objid', 'PhotoObjAll(objid)', 'SPECTRO', 'page', 'SPEC', 0)
--------------------------------------------------
-- Foreign keys for TILES
--------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'TargetInfo', 'targetID', 'Target(targetID)', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'sdssTileAll', 'tileRun', 'sdssTilingRun(tileRun)', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'sdssTilingGeometry', 'tileRun', 'sdssTilingRun(tileRun)', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'sdssTilingInfo', 'tileRun', 'sdssTilingRun(tileRun)', 'TILES', NULL, NULL, 1)
--------------------------------------------------
-- Foreign keys for REGION
--------------------------------------------------
--	INSERT IndexMap Values('F','foreign key', 'RegionConvex', 	'regionID'	,'Region(regionID)'	,'REGION');
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'HalfSpace', 'regionID', 'Region(regionID)', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'RegionArcs', 'regionID', 'Region(regionID)', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'RegionPatch', 'regionID', 'Region(regionID)', 'REGION', NULL, NULL, 1)
--------------------------------------------------
-- Foreign keys for FINISH
--------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'Zone', 'objID', 'PhotoObjAll(objID)', 'ZONE', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'Neighbors', 'objID', 'PhotoObjAll(objID)', 'NEIGHBORS', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'SpecPhotoAll', 'specObjID', 'SpecObjAll(specObjID)', 'FINISH', NULL, NULL, 0)
--
--
--------------------------------------------------
-- Foreign keys for META
--------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'DBColumns', 'tablename', 'DBObjects(name)', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'DBViewCols', 'viewname', 'DBObjects(name)', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'IndexMap', 'tableName', 'DBObjects(name)', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'FileGroupMap', 'tableFileGroup', 'PartitionMap(fileGroupName)', 'META', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ( 'F', 'foreign key', 'Inventory', 'name', 'DBObjects(name)', 'META', NULL, NULL, 0)
-- 
--
--------------------------------------------------
-- Foreign keys for SCHEMA DIAGRAM
-- These should only be created on the testload
-- schema so the schema diagram for SkyServer
-- and other sites will show the proper table
-- connections.  Once the diagram is done for a
-- given release, these keys should be dropped.
--------------------------------------------------
/*
INSERT IndexMap Values('F','foreign key', 'PhotoObjDR7', 	'dr8objID'	,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'PhotoPrimaryDR7', 	'dr8objID'	,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'astromDR9', 	 	'objID'		,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'TwoMassXSC', 	'objID'		,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'FIRST', 	'objID'		,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'RC3', 	'objID'		,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'ROSAT', 	'objID'		,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'USNO', 	'objID'		,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sdssImagingHalfSpaces', 	'sdssPolygonID'	,'sdssPolygons(sdssPolygonID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sdssSector', 		'regionID'	,'Region(regionID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sdssBestTarget2Sector', 	'objID'	,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sdssBestTarget2Sector', 	'regionID'	,'Region(regionID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sdssSector2Tile', 		'regionID'	,'Region(regionID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'Region2Box', 	'boxID'	,'Region(regionID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'detectionIndex', 	'objID'	,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'thingIndex', 	'fieldID'	,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'thingIndex', 	'objID'	,'PhotoObjAll(objID)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'SpecPhotoAll',	'objID'	,'PhotoObjAll(objID)','SCHEMA');
INSERT IndexMap Values('F','foreign key', 'stellarMassPCAWisc', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'stellarMassPassivePort', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'stellarMassStarformingPort', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'emissionLinesPort', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'specDR7', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sppLines', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sppLines', 	'bestObjid'	,'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sppParams', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sppParams', 	'bestObjid'	,'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'segueTargetAll', 	'objid'	,'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'sdssPolygons', 	'primaryFieldID'	,'Field(fieldID)'	,'PHOTO');
INSERT IndexMap Values('F','foreign key', 'sdssPolygon2Field', 	'sdssPolygonID'	,'sdssPolygons(sdssPolygonID)'	,'PHOTO');
INSERT IndexMap Values('F','foreign key', 'sdssPolygon2Field', 	'fieldID'	,'Field(fieldID)'	,'PHOTO');
INSERT IndexMap Values('F','foreign key', 'zooConfidence', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooConfidence', 	'objid'	,	'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooMirrorBias', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooMirrorBias', 	'objid'	,	'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooMonochromeBias', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooMonochromeBias', 	'objid'	,	'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooNoSpec', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooNoSpec', 	'objid'	,	'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooSpec', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooSpec', 	'objid'	,	'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooVotes', 	'specobjid'	,'SpecObjAll(specobjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'zooVotes', 	'objid'	,	'PhotoObjAll(objid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'galSpecExtra', 	'specObjid',	'SpecObjAll(specObjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'galSpecIndx', 	'specObjid',	'SpecObjAll(specObjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'galSpecInfo', 	'specObjid',	'SpecObjAll(specObjid)'	,'SCHEMA');
INSERT IndexMap Values('F','foreign key', 'galSpecLine', 	'specObjid',	'SpecObjAll(specObjid)'	,'SCHEMA');
*/
--
--------------------------------------------------
-- Indexes for PHOTO
--------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'Field', 'field,camcol,run,rerun', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'Field', 'run,camcol,field,rerun', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'Frame', 'field,camcol,run,zoom,rerun', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'Frame', 'htmID,zoom,cx,cy,cz,a,b,c,d,e,f,node,incl', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'Mask', 'htmID,ra,dec,cx,cy,cz', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
--
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'mode,cy,cx,cz,htmID,type,flags,ra,dec,u,g,r,i,z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'htmID,cx,cy,cz,type,mode,flags,ra,dec,u,g,r,i,z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'htmID,run,camcol,field,rerun,type,mode,flags,cx,cy,cz,g,r', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'field,run,rerun,camcol,type,mode,flags,rowc,colc,ra,dec,u,g,r,i,z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'fieldID,objID,ra,dec,r,type,flags', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'SpecObjID,cx,cy,cz,mode,type,flags,ra,dec,u,g,r,i,z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'cx,cy,cz,htmID,mode,type,flags,ra,dec,u,g,r,i,z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'run,mode,type,flags,u,g,r,i,z,Err_u,Err_g,Err_r,Err_i,Err_z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'run,camcol,rerun,type,mode,flags,ra,dec,fieldID,field,u,g,r,i,z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'run,camcol,field,mode,parentID,q_r,q_g,u_r,u_g,fiberMag_u,fiberMag_g,fiberMag_r,fiberMag_i,fiberMag_z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'run,camcol,type,mode,cx,cy,cz', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'ra,[dec],type,mode,flags,u,g,r,i,z,psfMag_u,psfMag_g,psfMag_r,psfMag_i,psfMag_z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'b,l,type,mode,flags,u,g,r,i,z,psfMag_u,psfMag_g,psfMag_r,psfMag_i,psfMag_z', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'phototag', '', 'SCHEMA', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjAll', 'parentid,mode,type', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PhotoObjDR7', 'dr7objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'thingIndex', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'detectionIndex', 'thingID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'TwoMass', 'ra', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'TwoMass', 'dec', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'TwoMass', 'j', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'TwoMass', 'h', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'TwoMass', 'k', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'TwoMass', 'ccflag', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'TwoMass', 'phqual', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w1mpro', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w2mpro', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w3mpro', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w4mpro', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'n_2mass', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'tmass_key', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'ra,dec', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'glat,glon', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'j_m_2mass', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'h_m_2mass', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'k_m_2mass', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w1rsemi', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'blend_ext_flags', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w1cc_map', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w2cc_map', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w3cc_map', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'w4cc_map', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_xmatch', 'wise_cntr', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'wiseForcedTarget', 'ra,dec,has_wise_phot,treated_as_pointsource', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'zooNoSpec', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'zooVotes', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'zooMirrorBias', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'zooMonochromeBias', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
--
-------------------------------
-- Indexes on SPECTRO
-------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'PlateX', 'htmID,ra,dec,cx,cy,cz', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'SpecObjAll', 'htmID,ra,dec,cx,cy,cz,sciencePrimary', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'SpecObjAll', 'BestObjID,sourceType,sciencePrimary,class,htmID,ra,dec,plate,mjd,fiberid,z,zErr', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'SpecObjAll', 'class,zWarning,z,sciencePrimary,plateId,bestObjID,targetObjId,htmID,ra,dec', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'SpecObjAll', 'targetObjID,sourceType,sciencePrimary,class,htmID,ra,dec', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'SpecObjAll', 'ra,[dec],class, plate, tile, z, zErr, sciencePrimary,plateID, bestObjID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'SpecObjAll', 'fluxObjID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'segueTargetAll', 'segue1_target1, segue2_target1', '', 'SPECTRO', 'page', 'SPEC', 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'apogeeObject', 'apogee_id,j,h,k,j_err,h_err,k_err', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'apogeeVisit', 'apogee_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'apogeeVisit', 'plate,mjd,fiberid', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'apogeeStar', 'apogee_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'apogeeStar', 'htmID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'aspcapStar', 'apstar_id', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'zooSpec', 'objID', '', 'SPECTRO', 'page', 'SPEC', 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'zooConfidence', 'objID', '', 'SPECTRO', 'page', 'SPEC', 0)
--
-------------------------------
-- Indexes on TILES
-----------------------------------------------------
/*
INSERT IndexMap Values('I','index', 		'Target', 	 'bestobjID,regionID,specobjid'			,'','TILES');
INSERT IndexMap Values('I','index', 		'Target', 	 'specobjID,regionID,bestobjID' 		,'','TILES');
INSERT IndexMap Values('I','index', 		'Target', 	 'regionID,bestobjid,specobjid'			,'','TILES');
INSERT IndexMap Values('I','index', 		'Target', 	 'htmID,ra,dec,cx,cy,cz'			,'','TILES');
INSERT IndexMap Values('I','index', 		'TargetInfo', 	 'targetobjID,priority'	,'','TILES');
INSERT IndexMap Values('I','unique index', 	'TargetInfo', 	 'targetID,skyversion,targetobjID'		,'','TILES');
*/
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'unique index', 'sdssTileAll', 'tileRun,tile', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'sdssTileAll', 'htmID,racen,deccen,cx,cy,cz', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'sdssTiledTargetAll', 'htmID,ra,dec,cx,cy,cz', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'unique index', 'sdssTilingInfo', 'targetID,tileRun,collisionGroup', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'unique index', 'sdssTilingInfo', 'tileRun,tid,collisionGroup', '', 'TILES', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'sdssTilingInfo', 'tile,collisionGroup', '', 'TILES', NULL, NULL, 1)

-----------------------------------------------------
-- Indexes on REGION
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'HalfSpace', 'regionID,convexID,x,y,z,c', '', 'REGION', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'RegionPatch', 'htmID,ra,dec,x,y,z,type', '', 'REGION', NULL, NULL, 1)

-----------------------------------------------------
-- Indexes on FINISH
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'WISE_allsky', 'rjce', '', 'FINISH', NULL, NULL, 1)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'SpecPhotoAll', 'objID,sciencePrimary,class,z,targetObjid', '', 'FINISH', NULL, NULL, 0)
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'SpecPhotoAll', 'targetObjID,sciencePrimary,class,z,objid', '', 'FINISH', NULL, NULL, 0)
-----------------------------------------------------
-- Index on META
-----------------------------------------------------
INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'DataConstants', 'value', '', 'META', NULL, NULL, 0)
-----------------------------------------------------
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


--===================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fIndexName]'))
	drop function [dbo].[fIndexName]
GO
--
CREATE FUNCTION fIndexName(
	@code char(1),
	@tablename varchar(100),
	@fieldList varchar(1000),
	@foreignKey varchar(1000)
)
------------------------------------------------
--/H Builds the name of the index from its components
--/A
--/T Used by the index build and check procedures.
--/T <li>If 'K' then pk_Tablename_fieldList
--/T <li>If 'F' then fk_TableName_fieldList_Key
--/T <li>If 'I' then i_TableName_fieldlist,
--/T <br> truncated to 32 characters.
------------------------------------------------
RETURNS varchar(32)
AS BEGIN
	DECLARE @constraint varchar(2000), 
		@head varchar(8),
		@fk varchar(1000);
	--
	SET @head = CASE @code 
		WHEN 'K' THEN 'pk_'
		WHEN 'F' THEN 'fk_'
		WHEN 'I' THEN 'i_'
		END
	--
	SET @fk = replace(replace(replace(@foreignKey,',','_'),')',''),'(','_');
	SET @constraint = @head + @tableName + '_'
		+ replace(replace(@fieldList,' ',''),',','_');
	IF @foreignkey != '' SET @constraint = @constraint + '_' + @fk;
	--
	SET @constraint = substring(@constraint,1,32);
	SET @constraint = replace(replace(@constraint,'[',''),']','')
	RETURN @constraint;
END
GO


--============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexCreate]')) 
	drop procedure spIndexCreate
GO
--
CREATE PROCEDURE spIndexCreate(
	@taskID	int,
	@stepID int,
	@indexmapid int			-- link to IndexMap table
)
-------------------------------------------------------------
--/H Creates primary keys, foreign keys, and indices
--/A  -------------------------------------------------------
--/T Works for all user tables, views, procedures and functions 
--/T The default user is test, default access is U
--/T <BR>
--/T <li> taskID  int   	-- number of task causing this 
--/T <li> stepID  int   	-- number of step causing this 
--/T <li> tableName  varchar(1000)    -- name of table to get index or foreign key
--/T <li> fieldList  varchar(1000)    -- comma separated list of fields in key (no blanks)
--/T <li> foreignkey varchar(1000)    -- foreign key (f(a,b,c))
--/T <br> return value: 0: OK , > 0 : count of errors.
--/T <br> Example<br> 
--/T <samp>
--/T exec spCreateIndex @taskID, @stepID, 32 
--/T </samp>
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @indexName varchar(1000),
		@cmd nvarchar(2000),
		@msg varchar(2000),
		@status varchar(16),
		@fgroup varchar(100),
		@ret int,
		@error int,
		@type varchar(100), 		-- primary key, unique, index, foreign key 
		@code char(1),			-- the character code, 'K','I','F'
		@tableName varchar(100), 	-- table name 'photoObj'
		@fieldList varchar(1000),	-- fields 'u,g,r,i,z'
		@foreignKey varchar(1000);  	-- if foreign key 'SpecObj(SpecObjID)'
	--
	SET @status = 'OK'

	--------------------------------------------------
	-- fetch the parameters needed for spIndexCreate
	--------------------------------------------------
	SELECT @type=type, @code=code, @tablename=tableName, 
		@fieldlist=fieldList, @foreignkey=foreignKey
	    FROM IndexMap WITH (nolock)
	    WHERE indexmapid=@indexmapid;

	------------------------------------------------
	-- get the name of the filegroup for the index
	------------------------------------------------
	set @fgroup = null;
	select @fgroup = coalesce(indexFileGroup,'PRIMARY')
		from FileGroupMap with (nolock)
		where tableName=@tableName;
	--
	IF  @fgroup is null SET @fgroup='PRIMARY';
	SET @fgroup = '['+@fgroup+']';
	--
	set @indexName = dbo.fIndexName(@code,@tablename,@fieldList,@foreignKey)
	set @fieldList  = REPLACE(@fieldList,' ','');
	--
/*
	------------------------------------------------
	-- check the existence of the table first, and 
	-- issue warning and exit if it doesnt exist
	------------------------------------------------
	IF NOT EXISTS (SELECT name FROM sysobjects
        	WHERE xtype='U' AND name = @tableName)
	    BEGIN
		SET @msg = 'Could not create index ' + @indexName + ': table ' 
			+ @tablename + ' does not exist!'
		SET @status = 'WARNING'
		EXEC spNewPhase @taskid, @stepid, 'IndexCreate', @status, @msg 
		-----------------------------------------------------
		RETURN 1	
	    END
*/
	---------------
	-- Primary key
	---------------
	IF (lower(@type) = N'primary key')
	    BEGIN
		set @cmd = N'SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; ALTER TABLE '+@tablename+' ADD CONSTRAINT '
			+@indexName+' PRIMARY KEY CLUSTERED '
			+'('+@fieldList+') '
		--
		set @msg = 'primary key constraint '+@tableName+'('+@fieldList+')'
	    END
	------------------
	-- [unique] index
	------------------
	IF ((lower(@type) = 'index') or (lower(@type) = 'unique index'))
	    BEGIN
		set @cmd = N'SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; CREATE '+upper(@type)+' '+@indexName+' ON '    
			+@tableName+'('+@fieldList+') WITH SORT_IN_TEMPDB';
		--
		if @fgroup is not null set @cmd = @cmd +' ON '+@fgroup;
		--
		set @msg = @type+' '+@tableName+'('+@fieldList+')'
	    END
	---------------
	-- foreign key
	---------------
	IF (lower(@type) = 'foreign key')
	    BEGIN
			set @cmd = N'ALTER TABLE '+@tableName+' WITH NOCHECK ADD CONSTRAINT '+@indexName   
				+' FOREIGN KEY ('+@fieldList+') REFERENCES '+@foreignKey;
			--
			set @msg = 'foreign key constraint '+@tableName 
				+'('+@fieldList+') references '+@foreignKey
	    END
	------------------------
	-- Perform the command
	------------------------
        IF EXISTS (
			SELECT [name] FROM dbo.sysobjects
			WHERE [name] = @tableName
		) 
			BEGIN
				IF NOT EXISTS (	select id from dbo.sysobjects
	    							where [name] = @indexname
	  							union
	    						select id from dbo.sysindexes
	    							where [name] = @indexname 
							  )
	    			BEGIN
						SET @ret = 1;		-- set it to an error value
						BEGIN TRANSACTION
							EXEC @ret=sp_executeSql @cmd 
							SET @error = @@error;
						COMMIT TRANSACTION
    				END
				ELSE 
				    BEGIN	-- index already there
						SET @status = 'OK'
						SET @msg = @msg  + ' already exists.'
						SET @ret = -1		-- signifies special case
					END
			END
		ELSE
			BEGIN
				SET @status = 'ERROR'
				SET @msg = 'Error in '+ @msg + ': Table ' + @tableName + ' does not exist!' 
				SET @ret = 1
			END
	--
	IF (@ret =  0)
	    BEGIN
			SET @status = 'OK'
			SET @msg = 'Created '  + @msg  
	    END

	IF (@ret > 0)
	    BEGIN
			IF (@error is not null)
				BEGIN
					SET @status = 'ERROR'
					DECLARE @sysmsg varchar(1000)
					SELECT @sysmsg = description FROM master.dbo.sysmessages WHERE error = @error
					IF (@sysmsg is null) SET @sysmsg = 'no sysmsg'
					SET @msg = 'Error in '+ @msg + ', ' + cast(@error as varchar(10)) + ': '  + @sysmsg 
				END
			ELSE
				BEGIN
					IF (@status != 'ERROR')
						BEGIN		-- not already marked as error
							SET @status = 'WARNING'
							SET @msg = 'Error in '+ @msg + '.' 
						END
				END
	    END
	-----------------------
	-- Generate log record
	-----------------------
	EXEC spNewPhase @taskid, @stepid, 'IndexCreate', @status, @msg 
	-----------------------------------------------------
	RETURN (case when (@ret < 0) then 0 else @ret end) 
END
GO

--============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexCreate_print]')) 
	drop procedure spIndexCreate_print
GO
CREATE PROCEDURE [dbo].[spIndexCreate_print](
	@taskID	int,
	@stepID int,
	@indexmapid int			-- link to IndexMap table
)
-------------------------------------------------------------
--/H Generates sql to create primary keys, foreign keys, and indices
--/A  -------------------------------------------------------
--/T THIS DOES NOT ACTUALLY GENERATE THE INDEX! 
--/T It just prints the generated sql which can then be run on an ad-hoc basis
--/T Works for all user tables, views, procedures and functions 
--/T The default user is test, default access is U
--/T <BR>
--/T <li> taskID  int   	-- number of task causing this 
--/T <li> stepID  int   	-- number of step causing this 
--/T <li> indexmapid int	-- id of index to generate
--/T 
--/T 
--/T <br> return value: 0: OK , > 0 : count of errors.
--/T <br> Example - generate create index statement for indexmap id = 52<br> 
--/T <samp>
--/T exec spIndexCreate_print 0,0,52
--/T </samp>
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @indexName varchar(1000),
		@cmd nvarchar(2000),
		@msg varchar(2000),
		@status varchar(16),
		@fgroup varchar(100),
		@ret int,
		@error int,
		@type varchar(100), 		-- primary key, unique, index, foreign key 
		@code char(1),			-- the character code, 'K','I','F'
		@tableName varchar(100), 	-- table name 'photoObj'
		@fieldList varchar(1000),	-- fields 'u,g,r,i,z'
		@foreignKey varchar(1000),  	-- if foreign key 'SpecObj(SpecObjID)'
		@compression varchar(4) = null		-- compression type (row, page, or null)
		
	--
	SET @status = 'OK'

	--------------------------------------------------
	-- fetch the parameters needed for spIndexCreate
	--------------------------------------------------
	SELECT @type=type, @code=code, @tablename=tableName, 
		@fieldlist=fieldList, @foreignkey=foreignKey, @compression=[compression], @fgroup=[filegroup]
	    FROM IndexMap WITH (nolock)
	    WHERE indexmapid=@indexmapid;

	------------------------------------------------
	-- get the name of the filegroup for the index
	------------------------------------------------
	--this data is in IndexMap now, not FileGroupMap --sw
	
	--set @fgroup = null;
	--select @fgroup = coalesce(indexFileGroup,'PRIMARY')
	--	from FileGroupMap with (nolock)
	--	where tableName=@tableName;
	--
	IF  @fgroup is null SET @fgroup='PRIMARY';
	SET @fgroup = '['+@fgroup+']';
	--
	set @indexName = dbo.fIndexName(@code,@tablename,@fieldList,@foreignKey)
	set @fieldList  = REPLACE(@fieldList,' ','');
	--
/*
	------------------------------------------------
	-- check the existence of the table first, and 
	-- issue warning and exit if it doesnt exist
	------------------------------------------------
	IF NOT EXISTS (SELECT name FROM sysobjects
        	WHERE xtype='U' AND name = @tableName)
	    BEGIN
		SET @msg = 'Could not create index ' + @indexName + ': table ' 
			+ @tablename + ' does not exist!'
		SET @status = 'WARNING'
		EXEC spNewPhase @taskid, @stepid, 'IndexCreate', @status, @msg 
		-----------------------------------------------------
		RETURN 1	
	    END
*/
	---------------
	-- Primary key
	---------------
	IF (lower(@type) = N'primary key')
	    BEGIN
		set @cmd = N'SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON;
		' + ' ALTER TABLE '+@tablename+' ADD CONSTRAINT '
			 +@indexName+' PRIMARY KEY CLUSTERED '
			 +'('+@fieldList+') '

		if (@compression is not null)
		begin
			set @cmd = @cmd + ' WITH (DATA_COMPRESSION = ' + @compression + ')'
		end

		if (@fgroup is not null)
		begin 
			set @cmd = @cmd + ' ON ' + @fgroup + ''
		end
		--
		set @msg = 'primary key constraint '+@tableName+'('+@fieldList+')' + ' ' + @compression + ' on ' + coalesce(@fgroup, 'PRIMARY')

		--print index create statement
		print @cmd

	    END
	------------------
	-- [unique] index
	------------------
	IF ((lower(@type) = 'index') or (lower(@type) = 'unique index'))
	    BEGIN
		set @cmd = N'SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; 
		CREATE '+upper(@type)+' '+@indexName+' ON '    
			+@tableName+'('+@fieldList+') WITH (SORT_IN_TEMPDB=ON';

		if (@compression is not null)
		begin
			set @cmd = @cmd + ' ,DATA_COMPRESSION = ' + @compression 
		end
		
		set @cmd = @cmd + ')'
		--
		if @fgroup is not null set @cmd = @cmd +' ON '+@fgroup;
		--
		set @msg = @type+' '+@tableName+'('+@fieldList+')'  + ' ' + @compression + ' on ' + coalesce(@fgroup, 'PRIMARY')

		-- print index create statement
		print @cmd
		
	    END
	---------------
	-- foreign key
	---------------
	IF (lower(@type) = 'foreign key')
	    BEGIN
			set @cmd = N'ALTER TABLE '+@tableName+' WITH NOCHECK ADD CONSTRAINT '+@indexName   
				+' FOREIGN KEY ('+@fieldList+') REFERENCES '+@foreignKey;
			--
			set @msg = 'foreign key constraint '+@tableName 
				+'('+@fieldList+') references '+@foreignKey

			print @cmd
	    END
	
	-----------------------
	-- Generate log record
	-----------------------
	--EXEC spNewPhase @taskid, @stepid, 'IndexCreate', @status, @msg 

	-----------------------------------------------------
	set @ret = 0
	RETURN (case when (@ret < 0) then 0 else @ret end) 
END




--========================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexBuildList]')) 
	drop procedure spIndexBuildList
GO
--
CREATE PROCEDURE spIndexBuildList(@taskid int, @stepid int)
-------------------------------------------------------------
--/H Builds the indices from a selection, based upon the #indexmap table
--/A --------------------------------------------------------
--/T It also assumes that we created before an #indexmap temporary table
--/T that has three attributes: id int, indexmapid int, status int.
--/T status values are 0:READY, 1:STARTED, 2:DONE.
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @nextindex int,
		@ret int,
		@type varchar(100),
		@code char(1),
		@tableName varchar(100),
		@fieldList varchar(1000),
		@foreignKey varchar(1000),
		@fileGroup varchar(100),
		@group varchar(100);
	--
	WHILE (1=1)
	BEGIN
		----------------------------------
		-- get the next index to create
		----------------------------------
		SET @nextindex=NULL;
		SELECT @nextindex=indexmapid
		    FROM #indexmap
		    WHERE id in (
			select min(id) from #indexmap WHERE status=0
			);
		----------------------------------
		-- exit if error
		----------------------------------
		IF @@error>0 RETURN(1);
		IF @nextindex IS NULL  RETURN(2);

		----------------------------------
		-- set status to STARTED(1)
		----------------------------------
		UPDATE #indexmap
		    SET status=1
		    WHERE indexmapid=@nextindex;

		--------------------------------------------------
		-- call spIndexCreate
		--------------------------------------------------
		EXEC @ret = spIndexCreate @taskid,@stepid,@nextindex;

		--------------------------------------
		-- if all OK, update status to DONE(2)
		--------------------------------------
		IF @ret=0 
		    UPDATE #indexmap
			SET status=2
			WHERE indexmapid=@nextindex;
		-------------------------------------------------
	END
	RETURN(0);
END
GO


--========================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexDropList]')) 
	drop procedure spIndexDropList
GO
--
CREATE PROCEDURE spIndexDropList(@taskid int, @stepid int)
-------------------------------------------------------------
--/H Drops the indices from a selection, based upon the #indexmap table
--/A --------------------------------------------------------
--/T It also assumes that we created before an #indexmap temporary table
--/T that has three attributes, id int, indexmapid int, status int.
--/T status values are 0:READY, 1:STARTED, 2:DONE
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @nextindex int,
		@ret int,
		@code char(1),
		@cmd nvarchar(4000),
		@msg varchar(4000),
		@status varchar(16),
		@error int,
		@indexName varchar(128),
		@tableName varchar(100);
	--
	SET @status='OK';
	--
	WHILE (1=1)
	BEGIN
		----------------------------------
		-- get the next index to drop
		----------------------------------
		SET @nextindex=NULL;
		SELECT @nextindex=indexmapid
		    FROM #indexmap WITH (nolock)
		    WHERE id in (
			select min(id) from #indexmap WHERE status=0
			);
		----------------------------------
		-- exit if error
		----------------------------------
		IF @@error>0 RETURN(1);
		IF @nextindex IS NULL  RETURN(2);

		----------------------------------
		-- set status to STARTED(1)
		----------------------------------
		UPDATE #indexmap
		    SET status=1
		    WHERE indexmapid=@nextindex;

		--------------------------------------------------
		-- fetch the parameters needed for fIndexName
		--------------------------------------------------
		SELECT  @code=code, @tablename=tableName, 
			@indexName = dbo.fIndexName(code,tablename,fieldList,foreignKey)
		    FROM IndexMap WITH (nolock)
		    WHERE indexmapid=@nextindex;
		-------------------------------------------------
		    SET @cmd = N''
		    SET @msg = 'dropped ';
		    IF (@code = 'K')
			BEGIN
			    -- if indexname is in sysobjects, it is a constraint
			    -- rather than an index (it isnt in sysindexes)
			    IF EXISTS (
				SELECT id FROM dbo.sysobjects 
				WHERE [name] = @indexname
				)
				SELECT 	@msg = @msg + 'primary key constraint ',
					@cmd = N'ALTER TABLE '+@tableName+' DROP CONSTRAINT '+ @indexName
			    ELSE
	   			SELECT  @msg = @msg + 'primary key index ',
					@cmd = N'DROP INDEX  '+@tableName+'.'+@indexName
			END
		    IF (@code = 'F')
			SELECT 	@msg = @msg + 'foreign key constraint ',
				@cmd = N'ALTER TABLE '+@tableName+' DROP CONSTRAINT '+ @indexName
		    IF (@code = 'I')
   			SELECT  @msg = @msg + 'index ',
				@cmd = N'DROP INDEX  '+@tableName+'.'+@indexName
		    --
		    SET @msg = @msg + @tableName+'.'+@indexName;
		    --
		    IF (@cmd='') BREAK;
		    ------------------------------------
		    -- only drop index if it exists
		    ------------------------------------
		    IF EXISTS (	
			select id from dbo.sysobjects
			    where [name] = @indexname
			union
			select id from dbo.sysindexes
			    where [name] = @indexname
			)
		    BEGIN
			BEGIN TRANSACTION
			    SET @ret = 0
		    	    EXEC @ret=sp_executesql @cmd
			    --------------------------------------
			    -- if all OK, update status to DONE(2)
			    --------------------------------------
			    IF (@ret > 0)
			    BEGIN
				SET @error  = @@error;
				SET @status = 'ERROR'
				DECLARE @sysmsg varchar(1000)
				select @sysmsg = description from master.dbo.sysmessages where error = @error
				IF (@sysmsg is null) set @sysmsg = 'no sysmsg'
				SET @msg = 'Error in '+ @msg + '. ' + cast(@error as varchar(10)) + ': '  + @sysmsg 
			    END
			    --
			    IF @ret=0 
			    BEGIN
				UPDATE #indexmap
				    SET status=2
				    WHERE indexmapid=@nextindex;
				--
				EXEC spNewPhase @taskid, @stepid,  
					'IndexDrop','OK',@msg 
				--
			    END
			COMMIT TRANSACTION		
		    END
		-----------------------------------------------------------------
	END
	RETURN(0);
END
GO


--========================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexBuildSelection]')) 
	drop procedure spIndexBuildSelection
GO
--
CREATE PROCEDURE spIndexBuildSelection(@taskid int, @stepid int, @type varchar(128), @group varchar(1024)='')
-------------------------------------------------------------
--/H Builds a set of indexes from a selection given by @type and @group
--/A --------------------------------------------------------
--/T The parameters are the body of a group clause, to be used with IN (...),
--/T separated by comma, like @type = 'F,K,I', @group='PHOTO,TAG,META';
--/T <BR>
--/T <li> @type   varchar(256)  -- a subset of F,K,I 
--/T <br> Here 'F': (foreign key), 'K' (primary key), 'I' index
--/T <li> @group  varchar(256) -- a subset of PHOTO,TAG,SPECTRO,QSO,TILES,META,FINISH,NEIGHBORS,ZONE,MATCH
--/T It will also accept 'ALL' as an alternate argument, it means build all indices. Or one can specify
--/T a comma separated list of tables.
--/T <br> The sp assumes that the parameters are syntactically correct.
--/T Returns 0, if all is well, 1 if an error has occurred, 
--/T and 2, if no more indexes are to be built.
--/T <br><samp>
--/T    exec spIndexBuildSelection 1,1, 'K,I,F', 'PHOTO'
--/T </samp>  
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @ltype varchar(256), 
		@lgroup varchar(4000),
		@ret int,
		@cmd nvarchar(2000);
	--
	SET @ltype  = ''''+REPLACE(@type, ',',''',''')+'''';
	SET @lgroup = ''''+REPLACE(@group,',',''' COLLATE SQL_Latin1_General_CP1_CS_AS,''')
		+''' COLLATE SQL_Latin1_General_CP1_CS_AS';
	--
	IF @type ='' OR @group='' RETURN(1);
	--------------------------------------------------------
	-- insert the list to be built into the table #indexmap,
	--------------------------------------------------------
	CREATE TABLE #indexmap (id int identity(1,1), indexmapid int, status int);

	SET @cmd = N'INSERT #indexmap(indexmapid,status) SELECT indexmapid, 0 status '
		+ 'FROM IndexMap WITH (nolock) '
		+ 'WHERE code IN ('+@ltype+')';
	------------------------------------------------
	-- look for the ALL clause for group selection
	------------------------------------------------
	IF @group NOT LIKE 'ALL%' 
	    BEGIN
		IF (@group NOT IN (SELECT DISTINCT indexgroup FROM IndexMap)) AND
		   (@type = 'F') -- foreign keys for specific table(s) indicated
		    SET @cmd = @cmd + ' and tableName IN ('+@lgroup+')'; 
		ELSE
		    SET @cmd = @cmd + ' and (indexgroup IN ('+@lgroup+')'
			+ ' or tableName IN ('+@lgroup+'))';
	    END
	ELSE
	    -- 'ALL' does not include the special group 'SCHEMA'
            SET @cmd = @cmd + ' and (indexgroup NOT LIKE ''%SCHEMA%'') ';
	------------------------------------------------
	-- order it by code in reverse order, so pk are built first
	------------------------------------------------
	SET @cmd = @cmd + ' ORDER BY code DESC';
	--
	EXEC @ret= sp_executesql @cmd
	IF @ret>0 RETURN(1);

	--------------------------------------------
	-- build the index for the whole list
	--------------------------------------------
	SET @ret = 0;
	EXEC @ret=spIndexBuildList @taskid, @stepid
	--
	RETURN(0);
END
GO


--========================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexDropSelection]')) 
	drop procedure spIndexDropSelection
GO
--
CREATE PROCEDURE spIndexDropSelection(@taskid int, @stepid int, @type varchar(128), @group varchar(1024)='')
-------------------------------------------------------------
--/H Drops a set of indexes from a selection given by @type and @group
--/A --------------------------------------------------------
--/T The procedure uses the IndexMap table to drop the selected indices.
--/T The parameters are the body of a group clause, to be used with IN (...),
--/T separated by comma, like @type = 'F,K,I', @group='PHOTO,TAG,META';
--/T <BR>
--/T <li> @type   varchar(256)  -- a subset of F,K,I 
--/T <br> Here 'F': (foreign key), 'K' (primary key), 'I' index
--/T <li> @group  varchar(256) -- a subset of PHOTO,TAG,SPECTRO,QSO,TILES,META,FINISH,NEIGHBORS,ZONE,MATCH
--/T It will also accept 'ALL' as an alternate argument, it means build all indices. Or one can specify
--/T a comma separated list of tables.
--/T <br> The sp assumes that the parameters are syntactically correct.
--/T Returns 0, if all is well, 1 if an error has occurred, 
--/T and 2, if no more indexes are to be built.
--/T <br><samp>
--/T    exec spIndexDropSelection 1,1, 'K,I,F', 'PHOTO'
--/T </samp>  
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @ltype varchar(256), 
		@lgroup varchar(4000),
		@ret int,
		@cmd nvarchar(2000);
	--
	SET @ltype  = ''''+REPLACE(@type, ',',''',''')+'''';
	SET @lgroup = ''''+REPLACE(@group,',',''' COLLATE SQL_Latin1_General_CP1_CS_AS,''')
		+''' COLLATE SQL_Latin1_General_CP1_CS_AS';
	--
	IF @type ='' OR @group='' RETURN(1);
	--------------------------------------------------------
	-- insert the list to be built into the table #indexmap,
	-- order it by code in reverse order, so pk are built first
	--------------------------------------------------------
	CREATE TABLE #indexmap (id int identity(1,1), indexmapid int, status int);
	SET @cmd = N'INSERT INTO #indexmap(indexmapid, status) SELECT indexmapid, 0 as status '
		+ 'FROM IndexMap WITH (nolock) '
		+ 'WHERE code IN ('+@ltype+') ';
	------------------------------------------------
	-- look for the ALL clause for group selection
	------------------------------------------------
	IF @group NOT LIKE 'ALL%' 
	    BEGIN
		IF (@group NOT IN (SELECT DISTINCT indexgroup FROM IndexMap)) AND
		   (@type = 'F') -- foreign keys for specific table(s) indicated
--		    SET @cmd = @cmd + ' and foreignKey LIKE ''' + @group + '(%''';
		    SET @cmd = @cmd + ' and tableName LIKE ''' + @group + '%''';
		ELSE
		    SET @cmd = @cmd + ' and (indexgroup IN ('+@lgroup+')'
		  	+ ' or tableName IN ('+@lgroup+'))';
	    END
	------------------------------------------------
	-- order it by code in reverse order, so pk are dropped last
	------------------------------------------------
	SET @cmd = @cmd + ' ORDER BY code ASC';
	--
	EXEC @ret= sp_executesql @cmd
	IF @ret>0 RETURN(1);
	--------------------------------------------
	-- loop through the indexes and build them
	--------------------------------------------
	SET @ret = 0;
	EXEC @ret=spIndexDropList @taskid, @stepid
	--
	RETURN(0);
END
GO

/*
exec spIndexBuildSelection 1,1, 'F,K', 'TAG'
exec spIndexBuildSelection 1,1, '', ''
exec spIndexBuildSelection 1,1, 'I,K,F', 'SPECTRO,TILES'
exec spIndexBuildSelection 1,1, 'K,F', 'ZONE'
exec spIndexBuildSelection 1,1, 'K,F', 'NEIGHBORS'
exec spIndexBuildSelection 1,1, 'K', 'ALL'
*/


-----------------------------------------------------
-- Drop all the indices, and foreign keys, primary keys
-----------------------------------------------------

--=============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexDrop]')) 
	drop procedure spIndexDrop
GO
--
CREATE PROCEDURE spIndexDrop(@type varchar(10)) 
-------------------------------------------------------------
--/H Drops all indices of a given type 'F' (foreign key), 'K' (primary key), or 'I' index
--/A --------------------------------------------------------
--/T Uses the information in the sysobjects and sysindexes table to delete the indexes.
--/T These should be called in the sequence 'F', 'K', 'I'
--/T <BR>
--/T <li> type  varchar(16)   -- 'F' (foreign key), 'K' (primary key), or 'I' index
--/T <br><samp>
--/T <br> exec  dbo.spIndexDrop 'F'
--/T </samp>  
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @prevName VARCHAR(256)	-- if drop fails, keep going, do not get hung up
	SET @prevName = ''		-- always go on to next index.
	------------------------------------------
	-- loop through the sysobjects
	-- and eliminate keys of type ('K', 'F') 
	------------------------------------------
	-- never heard of this kind of index
	IF (@type not in ('F', 'K', 'I'))
	BEGIN	
	    PRINT 'Illegal parameter'
	    RETURN 
	END
	------------------------------------
	-- command holds the drop statement
	------------------------------------
	DECLARE @cmd varchar(1000)
	----------------------------------------------------------------
	-- loop over all indices of the given type, dropping each one
	-- (1) begin a transaction, 
	-- (2) fetch next "drop index" or "alter table" command
	-- (3) drop the index.
	-- (4) commit
	-----------------------------------------------------------------
	WHILE (1=1)
	BEGIN
		BEGIN TRANSACTION
		set @cmd = ''
		IF (@type in ('K', 'F')) 
	    		BEGIN
			select 	@cmd = 'ALTER TABLE '+u.name+' DROP CONSTRAINT '+ c.name,
				@prevName = rtrim(c.name) + '.' + rtrim(u.name)
      			from sysobjects u, sysobjects c
      			where u.xtype='U' and (c.type=@type)
				and c.parent_obj= u.id
				and u.name != 'dtproperties'
				and rtrim(c.name) + '.' + rtrim(u.name) > rtrim(@prevName)
				order by rtrim(c.name) + '.' + rtrim(u.name)  desc
	   		 END
		-- This handles "ordinary" 'I' indices
 		IF (@type = 'I')
	   		BEGIN
   			SELECT  @cmd = 'DROP INDEX  '+t.name+'.'+ i.name, 
				@prevName = rtrim(t.name) + '.' + rtrim(i.name)
			FROM sysindexes i, sysobjects t 
  			WHERE 	i.id = t.id 
    				and i.keys is not null
    				and i.name not like '%sys%'
				and rtrim(t.name) + '.' + rtrim(i.name) > @prevName
    				and i.name not in (
  	  				select name from sysobjects
   					where xtype IN ('PK', 'F')
  					   or upper(name) like 'PK_%' 
					   or upper(name) like 'FL_%'
					)
				order by rtrim(t.name) + '.' + rtrim(i.name) desc
	    		END
		IF (@cmd IS NULL) or (@cmd = '') -- we did not find an index
			BEGIN
			COMMIT TRANSACTION
			BREAK			-- and exit
			END
		--PRINT @cmd  
		EXEC (@cmd)			-- execute the drop
		COMMIT TRANSACTION		-- commit the work
	END				-- loop on to next index

	--=========================================================
	-- end of loop,   return.
	RETURN
END
GO


--============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spDropIndexAll]')) 
	drop procedure spDropIndexAll
GO
CREATE PROCEDURE spDropIndexAll
-------------------------------------------------------------
--/H Drops all indices on user tables
--/A
--/T <br><samp>
--/T <br> exec  dbo.spDropIndexAll
--/T </samp>  
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	-- drop foreign keys
	EXEC spIndexDrop 'F'
	-- drop primary keys
	EXEC spIndexDrop 'K'
	-- drop indices
	EXEC spIndexDrop 'I'
	--
	PRINT 'Dropped all indices on user tables'
END
GO



--============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexCreatePhotoTag]')) 
	drop procedure spIndexCreatePhotoTag
GO
CREATE PROCEDURE spIndexCreatePhotoTag(@taskid int, @stepid int)
-------------------------------------------------------------
--/H Create the fat PhotoTag index on PhotoObjAll.
--/A
--/T <br><samp>
--/T <br> exec  dbo.spIndexCreatePhotoTag 0, 0
--/T </samp>  
-------------------------------------------------------------
AS BEGIN
	IF NOT EXISTS (	select id from dbo.sysobjects
	    where [name] = 'i_PhotoObjAll_phototag'
	  	union
		select id from dbo.sysindexes
	    where [name] = 'i_PhotoObjAll_phototag' 
	)
	CREATE NONCLUSTERED INDEX [i_PhotoObjAll_PhotoTag] ON [dbo].[PhotoObjAll] 
	(
		[objID] ASC,
		[htmID] ASC,
		[fieldID] ASC,
		[specObjID] ASC,
		[run] ASC,
		[camcol] ASC,
		[ra] ASC,
		[dec] ASC,
		[cx] ASC,
		[cy] ASC,
		[cz] ASC,
		[flags] ASC,
		[mode] ASC,
		[type] ASC,
		[clean] ASC
	)
	INCLUDE ( [field],
		[obj],
		[resolveStatus],
		[nChild],
		[probPSF],
		[flags_u],
		[flags_g],
		[flags_r],
		[flags_i],
		[flags_z],
		[psfMag_u],
		[psfMag_g],
		[psfMag_r],
		[psfMag_i],
		[psfMag_z],
		[psfMagErr_u],
		[psfMagErr_g],
		[psfMagErr_r],
		[psfMagErr_i],
		[psfMagErr_z],
		[petroMag_u],
		[petroMag_g],
		[petroMag_r],
		[petroMag_i],
		[petroMag_z],
		[petroMagErr_u],
		[petroMagErr_g],
		[petroMagErr_r],
		[petroMagErr_i],
		[petroMagErr_z],
		[petroR50_r],
		[petroR90_r],
		[modelMag_u],
		[modelMag_g],
		[modelMag_r],
		[modelMag_i],
		[modelMag_z],
		[modelMagErr_u],
		[modelMagErr_g],
		[modelMagErr_r],
		[modelMagErr_i],
		[modelMagErr_z],
		[cModelMag_u],
		[cModelMag_g],
		[cModelMag_r],
		[cModelMag_i],
		[cModelMag_z],
		[cModelMagErr_u],
		[cModelMagErr_g],
		[cModelMagErr_r],
		[cModelMagErr_i],
		[cModelMagErr_z],
		[mRrCc_r],
		[mRrCcErr_r],
		[mRrCcPSF_r],
		[fracDeV_u],
		[fracDeV_g],
		[fracDeV_r],
		[fracDeV_i],
		[fracDeV_z],
		[psffwhm_u],
		[psffwhm_g],
		[psffwhm_r],
		[psffwhm_i],
		[psffwhm_z],
		[thingId],
		[balkanId],
		[nObserve],
		[nDetect],
		[calibStatus_u],
		[calibStatus_g],
		[calibStatus_r],
		[calibStatus_i],
		[calibStatus_z],
		[extinction_u],
		[extinction_g],
		[extinction_r],
		[extinction_i],
		[extinction_z]
	)
END
GO



EXEC spSetDefaultFileGroup 'PrimaryFileGroup';
GO

PRINT '[IndexMap.sql]: Index management tables and procedures built'
GO
