--====================================================================
--   spFinish.sql
--   2002-10-29 Jim Gray
----------------------------------------------------------------------
-- This set of routines Finishes Photo and Spectro data newly published
-- to the destination database. The premise is that the data has been 
-- verified and published to destination DB that has primary keys defined 
-- (and perhaps other keys) defined on the tables. The goal is to "finish" 
-- the published objects. This includes matching spectro (sciencePrimary) 
-- objects to the Best PhotoObj and it includes computing the neighbors 
-- for the new objects. 
----------------------------------------------------------------------
-- History:
--* 2002-10-29 Jim: split spValidate and spFinish 
--*   		     (finish does neighbors and photo-spectro matchup).
--*			 removed references to sdssdr1.
--* 2002-11-25 Jim: added index build
--* 2002-12-01 Jim: support *-pub types in spNeighbors
--* 2002-12-03 Jim: added copy target, targetInfo to spFinishPlates
--*			and set SpecObjAll.SciencePrimary
--* 2002-12-08 Alex: added spDropIndexAll before creating all indices
--* 2003-01-28 Alex: eliminated the redundant spFinishPhoto
--* 2003-01-28 Alex: changed spFinishPlates to spSynchronize
--* 2003-01-29 Jim:  fixed bug in negative dec (should be cos(abs(dec)))
--*                    fixed bug in native flag of zone (was always 1)
--*                    this should fix the non-unique neighbors bug.
--* 2003-02-04 Alex: fixed a bug in SpectroPhotoMatch, the update of PhotoObj
--*		      had an incorrect join, should be P.objid=PS.PhotoObjId
--* 2003-05-15 Alex: changed some of the occurrences of PhotoObj to PhotoObjAll
--* 2003-05-15 Alex: changed neighborObjType to neighborType, etc.
--* 2003-05-25 Alex: changed zone table to select only mode=(1,2) and 
--*                  type=(3,5,6).
--* 2003-05-26 Jim:  only right margin needed in neighbor computation
--*                    added code to drop Neighbor/Zone indices if they exist
--*                    added spBuildMatchTables
--*                    modified spFinish to call spBuildMatchTables if it is
--*                    a BEST database.
--*		      modified neighbors code to use spBuildIndex
--* 2003-06-03 Alex: changed count(*) to count_big(*), and @@rowcount to
--*                  rowcount_big()
--* 2003-06-06 Alex+Adrian: added spMatchTargetBest, updated 
--*                         spSpectroPhotoMatch,
--*		      added spBuildSpecPhotoAll
--* 2003-06-13 Adrian: updated assignments of sciencePrimary
--* 2003-06-13 Adrian: added fGetNearbyTiledTargetsEq and 
--*                      spTiledTargetDuplicates
--* 2003-08-18 Ani: added truncation of Match/MatchHead tables to
--*                   spBuildMatchTables (see PRs 5571, 5572).
--* 2003-08-19 Ani: Removed "distinct" from select in MatchHead table
--*                   update, to fix PR #5592 (matchCount not being set).
--* 2003-08-20 Ani: Added spLoadPhotoTag to populate PhotoTag table (PR #5573).
--* 2003-08-20 Ani: Added RegionsSectorsWedges to do regions, sectors and
--*                   wedges computation (PR #5588).
--* 2003-08-21 Ani: Fixed bugs in spLoadPhotoTag.
--* 2003-09-23 Ani: Added FINISH group index creation (PR #5677)
--* 2003-10-12 Ani: Added call to spBuildSpecPhotoAll (PR #5698)
--* 2004-01-16 Ani: Fixed bugs in spRegionsSectorsWedges (#tile creation).
--* 2004-01-22 Ani: Fixed bug in TiledTargetDuplicates code (PR #) - 
--*		     removed refs to bestdr1 from spTiledTargetDuplicates and
--*                   replaced fHTM_Cover call in fGetNearbyTiledTargetsEq
--*                   by fHTMCover (HTM v2).
--* 2004-02-12 Ani: Added @err to spRegionsSectorsWedges to track errors.
--* 2004-08-27 Alex: Added spTableCopy, written by Jim
--* 2004-08-30 Alex: removed spRegionsSectorsWedges, now done in spSector,
--* 		also moved spBuildMatchTables and spNeighbors to spNeighbor.sql.
--* 2004-09-10 Alex: changed the calls to spBuildPrimaryKeys and 
--*                  spBuildForeignKeys to spBuildIndex. Then changed the call
--*		     from spBuildIndex to spIndexBuild
--* 2004-09-17 Alex: changed spIndexBuild to spIndexBuildSelection
--* 2004-09-20 Alex: added spRunSQLScript and spLoadMetadata 
--* 2004-10-11 Alex: repointed spNewPhase, spStartStep and spEndStep to local
--*                  wrappers
--* 2004-11-08 Ani: Added spRemoveTaskPhoto and spRemoveTaskFromTable, to
--*                 back out a given chunk.
--* 2004-12-05 Ani: Added spLoadScienceTables to load RC3, Stetson etc.
--* 2005-01-15 Ani: Put the match tables and sectors back in with calls
--*            to new procedures spMatchBuild and spSectorCreate.
--* 2005-01-17 Ani: Commented out update statistics call - it's giving
--*            an error (can't upd stats inside multiple transactions),
--*            and changed spDone to loadsupport.dbo.spDone (no spDone
--*            proc in pub dbs).
--* 2005-01-21 Ani: Made @counts an output param in spTiledTargetDuplicates
--*            so spSynchronize can print how many duplicates were found.
--*	       Fixed HTM CIRCLE call in fGetNearbyTiledTargetsEq to drop 
--*            the L before the level number.
--*	       Also updated spLoadScienceTables to truncate RC3 and Stetson
--*	       before reloading them, and removed setting RC3.objid to
--*            matching photoobj objid (RC3.objid is RC3 seq number).
--*	       Call to spFinishDropIndices had last 2 parameters missing.
--*	       Finally, set Target.bestObjID to 0 in spSynchronize so that 
--*            spMatchTargetBest will later set the bestObjID.
--* 2005-01-22 Ani: Added FirstRow=2 for Stetson bulk insert in
--*            spLoadScienceTables.
--* 2005-02-01 Alex: changed spMatchBuild to spMatchCreate
--* 2005-02-06 Ani: Modified spSyncSchema to take list of schena files
--*            from schema/sql/xsyncschema.txt, and added call to
--*            spSyncSchema in spFinishStep.  Also added spLoadPatches
--*            and corresponding call in spFinishStep to apply patches
--*            piled up during the loading process.
--* 2005-03-17 Ani: Updated spLoadMetaData to work with taskid=0 and
--*            enforced order F,I,K of index dropping to ensure success.
--* 2005-03-18 Ani: Fixed bug in spSyncSchema (deleted @isPartitioned
--*            reference).
--* 2005-03-25 Ani: Modified spFinishDropIndices to call 
--*            spIndexDropSelection instead of spDropIndexAll.
--* 2005-04-12 Jim: Modified spMatchTargetBest to 
--*                 set Target.specObjID from SpecObj.targetID
--* 2005-05-02 Ani: Added spRemoveTaskSpectro and spRemovePlate
--*                 to back out spectro data (see PR #6444).
--* 2005-05-10 Ani: Modified spLoadPatches to make the failure to
--*                 load/find the patch file a warning, not an error.
--* 2005-05-18 Ani: Added call to spSectorSetTargetRegionID in spFinishStep.
--* 2005-05-24 Ani: Added spRemovePlateList to delete list of plates from
--*                 a CSV file.
--* 2005-05-25 Ani: Updated spRemovePlateList to drop tables in case of
--*                 error so it can be run repeatedly.
--* 2005-05-31 Ani: Fixed small bug in spFinishStep that was causing it
--*                 to skip past builPrimaryKeys step when invoked for
--*                 that step.
--* 2005-06-04 Ani: Changed spFinishPlate messages to spSynchronize.
--* 2005-06-09 Ani: Added RUNS-PUB check where applicable to FINISH
--*                 steps will also be executed for RUNS finish.
--* 2005-08-09 Ani: Created spSetVersion to set a DB's version info.
--* 2005-09-13 Ani: Added spRunPatch to formalize patch application.
--* 2005-09-19 Ani: Added truncation of Match/MatchHead tables before 
--*                 rebuilding foreign keys for complete FINISH rerun,
--*                 so ALTER TABLE conflicts would be avoided. 
--* 2005-09-22 Ani: Changed nextReleasePatches.sql dir to the patches
--*                 directory instead of the sql directory because it
--*                 causes duplicate entries in the metadata loading
--*                 scripts.
--* 2005-10-05 Ani: Updated FINISH step start message in spFinishStep
--*                 to indicate if it is run in single-step or
--*                 resume mode, and which step it it starting on.
--* 2005-10-08 Ani: Added "OPTION (MAXDOP 1)" for all update and delete
--*                 operations to ensure max degree of  parallelism is 
--*                 set to 1.
--* 2005-10-09 Ani: Fixed problem with specobjids not getting set in
--*                 PhotoTag/PhotoObjAll after spectrophotomatch 
--*                 during incremental load (PR #6631).
--* 2005-10-10 Ani: Cloned spCreateWeblogDB from spLoadPatches and 
--*                 added call to it in spFinishStep so Weblog DB
--*                 will be automatically created if it doesnt exist.
--*                 Also modified spRunSqlScript to take two optional
--*                 parameters - dbname and logname - for the DB on
--*                 which to run the script and the log file to send
--*                 output to.
--* 2005-10-10 Ani: Kludged spFinishDropIndices to look for the
--*                 string "DROP_PK_INDICES" in the FINISH task
--*                 comment field before dropping PK indices,
--*                 otherwise PK indices are not dropped.
--* 2005-10-13 Ani: Made PhotoTag load incremental also and changed
--*                 comment that causes campaign load to be
--*                 'CAMPAIGN LOAD'.
--* 2005-10-15 Ani: Truncated filegroupmap in spFinishDropIndices
--*                 if sysfilegroups has only primary filegroup.
--*                 This is to prevent index creation from barfing
--*                 on invalid filegroups.
--* 2005-10-21 Ani: Moved filegroupmap truncation to spFinishStep.
--* 2005-10-22 Ani: Moved spLoadPatches call after spSyncSchema in
--*                 spFinishStep.
--* 2005-10-22 Ani: Added parameter to spLoadMetadata to make index
--*                 dropping and recreation optional, since this is
--*                 not needed if FINISH is started at the beginning.
--* 2005-12-02 Ani: Added step to spFinishStep to do the masks.
--* 2005-12-05 Ani: Fixed bug in spFinishStep that caused it to start
--*                 at the beginning (drop indices!) even if an 
--*                 invalid phase name was specified (PR #6795).
--* 2005-12-07 Ani: Updated spFinishStep to delete Target/TargetInfo
--*                 tables only in case of campaign load or full
--*                 finish, and made Target/TargetInfo incremental
--*                 in spSynchronize.
--* 2005-12-09 Ani: Added spFixTargetVersion to correct targetVersion
--*                 in TilingGeometry (PR #6799) and call to it in
--*                 sectors section of spFinishStep.
--* 2006-01-06 Ani: Added call to spSectorFillBest2Sector in spFinishStep.
--* 2006-01-18 Ani: Created wrapper for sector routines, spSectors.
--* 2006-06-19 Ani: Fixed bug in spSectors (@ret declare missing).
--* 2006-06-19 Ani: Added call to spUpdateStatistics in spSetVersion.
--* 2006-06-19 Ani: Added CAS, DAS URL params to spSetVersion.
--* 2006-06-20 Ani: Added calls to spCheckDB procs in spSetVersion.
--* 2006-07-12 Ani: Added calls to diagnostics procs in spRunPatch.
--* 2006-08-01 Ani: Added TargPhotoObjAll update to spSynchronize 
--*                 (PR #6866).
--* 2006-08-18 Ani: Corrected typo in spFinishStep - @phasName instead
--*                 @phaseName (fix for PR #7053).
--* 2006-09-28 Ani: Flipped the order of match tables and sectors steps
--*                 (fix for PR #7122).
--* 2006-12-13 Ani: Changed spSyncSchema to load different list of
--*                 schema files for TARG DB, since the TARG DB doesn't
--*                 have the schema updates for DR6 and beyond.
--* 2006-12-13 Ani: Added command to set DB compatibility level to 2k5,
--*                 so cross apply works properly.
--* 2006-12-14 Ani: Fixed bug in spSyncSchema change to read in 
--*                 different list of schema files for TARG DB.
--* 2006-12-18 Yanny/Svetlana: moving sp_dbcmptlevel @dbName, 90  to outside
--*         		of procedure.
--* 2007-01-02 Ani: Changed Match pk to ObjID1 from ObjID and added a
--*                 call to spRemoveTaskFromTable for Match.ObjID2 in
--*                 spRemoveTaskPhoto.
--* 2007-01-02 Ani: Added check for BEST-PUB to matchTargetBest and
--*		    insideMask steps, they should not be done for
--*                 TARG and RUNS DBs.
--* 2007-01-03 Ani: Fixed typos in spSyncSchema related to @targ.
--* 2007-01-04 Ani: Swapped the actual order of code for steps
--*                 regionsSectorsWedges and buildMatchTables, this was
--*                 a bug in PR #7122 fix (thanks, Svetlana!).
--* 2007-01-17 Ani: Made foreign key deletion for the metadata tables 
--*                 mandatory (not dependent on @dropIndices param) in
--*                 spLoadMetaData.
--* 2007-01-17 Ani: Undid above change, instead made spSyncSchema call
--*                 spLoadMetadata with @dropIndices = 1 to force
--*                 dropping and recreation of all META indices.
--* 2007-06-04 Ani: Applied Svetlana's change to fGetNearbyTiledTargetsEq
--*                 to increase STR length for r.
--* 2007-06-10 Ani: Changed fHtmCover to fHtmCoverRegion.
--* 2008-04-03 Ani: Broke up neighbors computation into 2 steps for
--*                 RUNSDB - first do a 2" neighbors so Match tables
--*                 can be built, then do 10" neighbors after the Match
--*                 tables are built but exclude self-matches.
--* 2008-08-06 Ani: Added call to spSetPhotoClean to set the clean 
--*                 photometry flag in spFinishStep (PR #7401).
--* 2009-08-14 Ani: Changes for SDSS-III: changed targetId to targetObjId
--*            where applicable, removed setting of specObjALL.targetObjId
--*            from spSynchronize; deleted status, primTarget and secTarget
--*            from spLoadPhotoTag (columns no longer in PhotoObjAll).
--* 2010-01-14 Ani: Replaced ObjMask with AtlasOutline.
--* 2010-01-19 Ani: Replaced spSectors with spSdssPolygonRegions to create
--*                 polygon regions for the main surveu in SDSS-III.
--* 2010-02-10 Ani: Cloned spSegue2SpectroPhotoMatch from spSpectroPhotoMatch.
--*                 This will be used to match SEGUE2 spectra to BestDR7 
--*                 photometry but won't be part of regular FINISH processing.
--* 2010-08-18 Ani: Deleted spSpectroPhotoMatch.
--* 2010-11-29 Ani: Deleted outdated steps in spFinishStep.
--* 2010-12-02 Ani: Replaced SpecPhotoAll schema with updated one from 
--*                 Mike Blanton.
--* 2010-12-02 Ani: Removed specObjAll.tileID from SpecPhotoAll schema.
--* 2010-12-09 Ani: Removed Algorithms, Glossary and TableDesc from
--*                 spLoadMetadata.
--* 2010-12-11 Ani: Updated spSetVersion for SDSS-III.
--* 2010-12-11 Ani: Updated fGetNearbyTiledTargetsEq as per Deoyani/Alex.
--* 2011-01-04 Ani: Removed code at top setting SQL compatibility level
--*                 to 90 (SQL 2005). 
--* 2011-02-11 Ani: Fixed DataServerUrl value in SiteConstants.
--* 2012-05-23 Ani: Changed "objType" to "sourceType".
--* 2012-06-05 Ani: Added message to spRunSqlScript.
--* 2012-06-08 Ani: Added columns to SpecPhotoAll for DR9, cleaned up
--*                 spSynchronize, and added phase messages to 
--*                 spBuildSpecPhotoAll (addded params taskid, stepid). 
--* 2012-07-10 Ani: Added COALESCE to fSphGetArea call in
--*                 spSdssPolygonRegions to avoid null area values.
--* 2012-07-16 Ani: Added spec.sdssPrimary to SpecPhotoAll.
--* 2013-03-27 Ani: Commented out references to PhotoTag table.
--* 2013-04-02 Ani: Added completion message for metadata refresh in
--*                 spSyncSchema.
--* 2013-04-02 Ani: Added logic to resume FINISH at the given phase.
--*                 This includes calls to the new loadsupport procedure
--*                 spSetFinishPhase to register last phase started.
--* 2013-07-10 Ani: Added code to spFinishStep to read in the list of
--*                 phases to skip from new metadata table 
--*                 SkipFinishPhases and then skip those phases.
--* 2013-07-10 Ani: Added phase message to spFinishStep to display the 
--*                 list of phases being skipped.
--* 2013-07-10 Ani: Moved skipped phases display to proper place.
--* 2013-07-10 Ani: Reinstated spFinishDropIndices to previous version.
--* 2013-07-10 Ani: Updated spFinishDropIndices to only drop F indices
--*                 for incremental FINISH.
--* 2013-07-10 Ani: Added index drop/recreate to spBuildSpecPhotoAll.
--* 2013-07-11 Ani: Added more phase messages in spFinishStep.
--* 2013-07-11 Ani: Added more phase messages and fixed spSynchronize
--*                 call in spFinishStep.
--* 2013-08-08 Ani: Modified spSynchronize to zero out all PhotoObjAll
--*                 specObjIDs prior to setting them.  Also added
--*                 tablocks to update statements.
--* 2013-08-09 Ani: Added check for taskid=0 in spSynchronize so it
--*                 doesn't fail on nonexistence of loadsupport db. 
--* 2013-09-20 Ani: Fixed previous version setting in spSetVersion.
--* 2014-12-05 Ani: Updated row counting for spectro sync steps.
--* 2015-03-06 Ani: Modified spSetVersion to distinguish between DB
--*                 version and schema version.
--* 2015-03-12 Ani: Fixed typo in spSynchronize.
--* 2015-03-18 Ani: Updated spSetVersion to include DB description in
--*                 SiteConstants.
--* 2015-05-28 Ani: Updated DataServerURL template in spSetVersion.
--* 2016-03-22 Ani: Deleted duplicate declaration of @checksum from
--*                 spSetVersion.
--* 2016-03-28 Ani: Created spFixDetectionIndex to add isPrimary column
--*                 to detectionIndex table and set its value.
--* 2016-05-18 Ani: Fixed typo in spFixDetectionIndex.
--* 2016-07-30 Ani: Fixed DataServerURL setting in spSetVersion 
--*                 (sdss3.org->sdss.org).
--* 2016-08-16 Ani: Added call to spRegionSync in spSdssPolygonRegions
--*                 to fix bug in f[In]FootprintEq after polygons were
--*                 recomputed for DR13 (fix as per T.Budavari).
--* 2017-05-15 Ani: Updated spFinishStep to skip loadPatches if it is
--*                 listed in SkipFinishPhases.
--* 2017-07-10 Ani: Commented out call to spNeighbors as precaution.
--* 2017-07-11 Ani: Updated spBuildSpecPhotoAll for compressed version.
--*                 Added support for "commonExit" as a valid resume
--*                 mode phase in spFinishStep.
--* 2018-07-30 Sue: Updated spSetVersion with option to not update all statistics,
--*		    Call with @updateAllStats bit = 0 to skip update.  
---====================================================================
SET NOCOUNT ON;
GO



--===================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spFixDetectionIndex]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spFixDetectionIndex]
GO
--
CREATE PROCEDURE spFixDetectionIndex(@taskid int, @stepid int, @phase varchar(64))
---------------------------------------------------
--/H Adds isPrimary column to detectionIndex table and sets its value.
--/A -------------------------------------------------
--/T Adds the new TINYINT column isPrimary to the detectionIndex table 
--/T and sets its value depending on whether the detection is the primary
--/T detection of the object or not.
---------------------------------------------------
AS
BEGIN
	--
	SET NOCOUNT ON;
	--
	DECLARE @msg varchar(8000), 
		@cmd nvarchar(2048), 
		@status varchar(16), 
		@ret int;
	--
	EXEC loadsupport.dbo.spSetFinishPhase 'detectionIndex'
	SET @msg = 'Adding isPrimary to detectionIndex ';

	IF EXISTS (SELECT name FROM DBColumns WHERE tablename = 'detectionIndex' AND name = 'isPrimary')
	   SET @ret = 0
	ELSE
		BEGIN
	   		ALTER TABLE detectionIndex ADD isPrimary TINYINT NOT NULL DEFAULT 0

	        SET @cmd = 'UPDATE d SET d.isPrimary = 1 FROM detectionIndex d LEFT OUTER JOIN thingIndex t ON d.thingid=t.thingid AND d.objid=t.objid WHERE t.objid is not null'  
			EXEC @ret=sp_executesql @cmd;
			IF @ret = 0 AND (@@ROWCOUNT = 0)
			   SET @ret = 1
		END

	IF (@ret = 0) 
		BEGIN
			SET @status = 'OK'
			SET @msg = @msg + ' completed successfully '
		END
	ELSE
		BEGIN
			SET @status ='WARNING'
			SET @msg = @msg + ' set isPrimary for 0 rows '
		END

	INSERT DBColumns VALUES('detectionIndex','isPrimary','','','','1 if object is primary, 0 if not',0)

	-------------------------------
	-- write log message
	-------------------------------
	SET @msg = LEFT(@msg,2048);
	EXEC spNewPhase @taskid,@stepid,@phase,@status,@msg;
	--
	--
	RETURN(@ret);
END
GO


--===================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spRunSQLScript]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spRunSQLScript]
GO
--
CREATE PROCEDURE spRunSQLScript(@taskid int, @stepid int, @phase varchar(64),
	@path varchar(128), @script varchar(256),
	@dbname varchar(64) = ' ', @logname varchar(128) = ' ')
---------------------------------------------------
--/H Executes an SQL script and logs the output string
--/A -------------------------------------------------
--/T Returns the status of the error, and inserts 
--/T error message into the Phase table
---------------------------------------------------
AS
BEGIN
	--
	SET NOCOUNT ON;
	--
	DECLARE @msg varchar(8000), 
		@cmd nvarchar(2048), 
		@status varchar(16), 
		@ret int;
	--
	IF (@dbname = ' ') SELECT @dbname = DB_NAME();
	--
	CREATE TABLE #scriptMsg (msg varchar(2048));
	--
	SET @cmd = N'osql -S '+@@servername+' -d'+@dbname+' -E -n -i'+@path+'\'+@script;
	IF (@logname != ' ') 
	    SET @cmd = @cmd + ' >> ' + @logname;
	SET @msg = 'Ran SQL script ' + @cmd;
	INSERT INTO #scriptMsg EXEC @ret=master.dbo.xp_cmdshell @cmd;
	--
	SELECT @msg = @msg+' '+msg FROM #scriptMsg WHERE msg is not null;
	SET @status = CASE WHEN @ret=0 THEN 'OK' ELSE 'ERROR' END;
	--
	-------------------------------
	-- write log message
	-------------------------------
	SET @msg = LEFT(@msg,2048);
	EXEC spNewPhase @taskid,@stepid,@phase,@status,@msg;
	--
	DROP TABLE #scriptMsg
	--
	RETURN(@ret);
END
GO


--==================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spLoadScienceTables]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spLoadScienceTables]
GO
--
CREATE PROCEDURE spLoadScienceTables(@taskid int, @stepid int)
---------------------------------------------------
--/H Loads the data needed for science with the SDSS.
--/A -------------------------------------------------
--/T Insert data into RC3, Stetson, QSOCatalog
--/T and other science data tables.
---------------------------------------------------
AS
BEGIN
	--
	SET NOCOUNT ON;
	--
	DECLARE @msg varchar(8000), 
		@cmd nvarchar(2048), 
		@status varchar(16), 
		@ret int;
	--
	SET @ret = 0;
	DECLARE @metadir varchar(128);
	TRUNCATE TABLE RC3
	TRUNCATE TABLE Stetson
	SELECT @metadir=value 
		FROM loadsupport..Constants WITH (nolock)
	WHERE name='metadir';
	SET @cmd = N'BULK INSERT RC3 FROM '''+@metadir+'\\rc3.csv'' WITH ('
		+ ' DATAFILETYPE = ''char'','
		+ ' FIELDTERMINATOR = '','','
		+ ' ROWTERMINATOR = ''\n'','
		+ ' BATCHSIZE =10000,'
		+ ' CODEPAGE = ''RAW'','
		+ ' TABLOCK)';
	--
	EXEC @ret=sp_executesql @cmd;
	IF @ret != 0
		RETURN(@ret);
	--
	SET @cmd = N'BULK INSERT Stetson FROM '''+@metadir+'\\stetson.csv'' WITH ('
		+ ' DATAFILETYPE = ''char'','
		+ ' FIELDTERMINATOR = '','','
		+ ' FIRSTROW = 2,'
		+ ' ROWTERMINATOR = ''\n'','
		+ ' BATCHSIZE =10000,'
		+ ' CODEPAGE = ''RAW'','
		+ ' TABLOCK)';
	--
	EXEC @ret=sp_executesql @cmd;
	--
	IF @ret = 0
	    BEGIN
		UPDATE Stetson
		   SET objid = dbo.fGetNearestObjIdEq(ra, dec, 0.1)
	    END
	--
	RETURN(@ret);
END
GO


--==================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSetVersion]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spSetVersion]
GO
--
CREATE PROCEDURE spSetVersion(@taskid int, @stepid int,
		@release varchar(8)='4', 
		@dbversion varchar(128)='v4_18', 
		@vname varchar(128)='Initial version of DR', 
		@vnum varchar(8)='.0',
                @vdesc varchar(128)='Incremental load',
                @vtext varchar(4096)=' ',
		@vwho varchar(128) = ' ',
		@updateAllStats bit = 1)
---------------------------------------------------
--/H Update the checksum and set the version info for this DB.
--/A -------------------------------------------------
--/T 
--/T 
--/T 
--/T 
---------------------------------------------------
AS
BEGIN
	-- Check schema skew
	EXEC spCheckDBObjects
	EXEC spCheckDBColumns
	EXEC spCheckDBIndexes

	
	if (@updateAllStats = 1)
		-- Update statistics for all tables
		EXEC spUpdateStatistics

	-- generate diagnostics and checksum
	EXEC spMakeDiagnostics
	EXEC spUpdateSkyServerCrossCheck
	EXEC spCompareChecksum

	DECLARE @curtime VARCHAR(64), @prev VARCHAR(32)

	SET @curtime=CAST( GETDATE() AS VARCHAR(64) );

	-- update SiteConstants table
        UPDATE siteconstants SET value='http://dr'+@release+'.sdss.org/' WHERE name='DataServerURL'
        UPDATE siteconstants SET value='http://skyserver.sdss.org/dr'+@release+'/en/' WHERE name='WebServerURL'
        UPDATE siteconstants SET value=@release+@vnum WHERE name='DB Version'
        UPDATE siteconstants SET value=@dbversion WHERE name='Schema Version'
        UPDATE siteconstants SET value='DR'+@release+' SkyServer' WHERE name='DB Type'
        UPDATE siteconstants SET comment='from Data Release '+@release+' of the Sloan Digital Sky Survey (http://www.sdss.org/dr'+@release+'/).' WHERE name='Description'

        -- get checksum from site constants and add new entry to Versions       
        DECLARE @checksum VARCHAR(64)
        SELECT @checksum=value FROM siteconstants WHERE [name]='Checksum'
        SELECT TOP 1 @prev=version from Versions order by convert (datetime,[when]) desc

	-- get checksum from site constants and add new entry to Versions
	SELECT @checksum=value FROM siteconstants WHERE [name]='Checksum'
	SELECT TOP 1 @prev=version from Versions order by convert (datetime,[when]) desc

	-- update Versions table with latest version
	INSERT Versions
		VALUES( @vname+@release,@prev,@checksum,@release+@vnum,
			@vdesc, @vtext, @vwho, @curtime)
END
GO



--==================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSyncSchema]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spSyncSchema]
GO
--
CREATE PROCEDURE spSyncSchema(@taskid int, @stepid int,
		@dbname varchar(128)='', @metadir varchar(128)='', 
		@sqldir varchar(128)='', @vbsdir varchar(128)='')
---------------------------------------------------
--/H Synchronizes the on-disk schema with the one in the pub db.
--/A -------------------------------------------------
--/T Reload the metadata tables and the schema files so that
--/T the schema in the pub db is synchronized with the version
--/T on disk (sqlLoader/schema/sql).  This is mainly needed
--/T for incremental loading.
---------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @err int, @ret int, 
	    @fname varchar(80), @status varchar(80), @dbtype varchar(32),
	    @msg varchar(1024), @cmd nvarchar(2048), @targ varchar(8);
    --
    SET @err = 0;
    SET @targ = '';
    EXEC loadsupport.dbo.spSetFinishPhase 'syncSchema'
    ------------------------------
    -- log the beginning
    ------------------------------
    SET @msg   = 'Starting schema synchronization for ' + @dbname ;
    IF @taskid > 0
	EXEC spNewPhase @taskid, @stepid, 
		'SyncSchema', 'OK', @msg;
    ELSE
	PRINT @msg;
    ------------------------------------
    IF @dbname = ''
	    SELECT @dbname=dbname, @dbtype=type 
		FROM loadsupport..Task WITH (nolock)
		WHERE taskid=@taskid;
    ELSE
	    SELECT @dbtype=type 
		FROM loadsupport..Task WITH (nolock)
		WHERE taskid=@taskid;

    IF @metadir = ''
        BEGIN	
	    SELECT @metadir=value 
		FROM loadsupport..Constants WITH (nolock)
		WHERE name='metadir';
	    SELECT @sqldir=value 
		FROM loadsupport..Constants WITH (nolock)
		WHERE name='sqldir';
	    SELECT @vbsdir=value 
		FROM loadsupport..Constants WITH (nolock)
		WHERE name='vbsdir';
	END
    --
    CREATE TABLE #sync (id int identity(1,1), s varchar(2048));
    IF @dbtype LIKE 'TARG%'
	SET @targ = 'targ';
    SET @cmd = N'type '+@sqldir+'xsyncschema' + @targ + '.txt';

    INSERT INTO #sync EXEC @ret=master.dbo.xp_cmdshell @cmd;
    -----------------------------------
    -- check for error 
    -----------------------------------
    IF EXISTS (select id from #sync where s like '%cannot find%')
      BEGIN
	SET @err    = 1;
	SET @status = 'WARNING';
	SET @msg    = 'Cannot find xsyncschema.txt file';
      END
    ELSE
      BEGIN
	SET @err    = 0;
	SET @status = 'OK';
	SET @msg    = 'Schema synced for ' + @dbname 
      END
    --
    IF @err = 0
	BEGIN
	    -------------------------------------------------------------------
	    -- cursor for file loop
	    -- ignore comments and blank lines, only consider *.sql file names
	    -------------------------------------------------------------------
	    DECLARE fc CURSOR READ_ONLY
		FOR SELECT s FROM #sync with (nolock)
		WHERE s LIKE '%.sql' 
		  and s not like '--%' 
		  and s is not null
		  order by id
	    ----------------------------------------------
	    OPEN fc
	    FETCH NEXT FROM fc INTO @fname
	    WHILE (@@fetch_status <> -1)
	    BEGIN
		IF (@@fetch_status <> -2)
		    EXEC @ret = spRunSQLScript @taskid, @stepid, 
			'SyncSchema', @sqldir, @fname;
		FETCH NEXT FROM fc INTO @fname
	    END
	    --
	    CLOSE fc
	    DEALLOCATE fc
	    ----------------------------------------------
	END
    ELSE
	BEGIN
	    EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
			'SyncSchema', @sqldir, 'IndexMap.sql' 
	    IF @ret != 0 
		BEGIN
		    SET @msg =  'Script ' + @sqldir + 'IndexMap.sql returned ' 
				+ cast(@ret as varchar(16));
		    IF @taskid>0
			EXEC spNewPhase @taskID, @stepID, 'SyncSchema','WARNING',@msg;
		    ELSE
			PRINT @msg;
		END
	END
    SET @err = @err+@ret;
    --
    SET @cmd = @vbsdir + 'runAll.bat ' + @vbsdir + ' ' + @targ;
    EXEC @ret=master.dbo.xp_cmdshell @cmd, no_output
    IF @ret != 0 
	BEGIN
	    SET @msg =  'Script ' + @vbsdir + 'runAll.bat returned ' 
			+ cast(@ret as varchar(16));
	    IF @taskid>0
		EXEC spNewPhase @taskID, @stepID, 'SyncSchema','WARNING',@msg;
	    ELSE
		PRINT @msg;
	END
    --
    SET @cmd = N'EXEC '+@dbname+'.dbo.spLoadMetaData '
	+ cast(@taskid as varchar(16)) + ', '
	+ cast(@stepid as varchar(16)) + ', '''
	+ @metadir + ''', 1';
    --
    EXEC @ret=sp_executesql @cmd;
    IF @ret = 0 
	BEGIN
	    -- give phase message telling of success.
	    SET @status = 'OK';
	    SET @msg =  'spLoadMetadata done';
	END
    ELSE
	BEGIN
	    SET @status = 'WARNING';
	    SET @msg =  'spLoadMetadata did not execute cleanly';
	END
    IF @taskid>0
	EXEC spNewPhase @taskID, @stepID, 'spSyncSchema', @status, @msg;
    ELSE
	PRINT 'spSyncSchema: ' + @msg;
    SET @err = @err+@ret;
    RETURN @err
END
GO


--=============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spRunPatch' ) 
	DROP PROCEDURE spRunPatch
GO
--
CREATE PROCEDURE spRunPatch( @patchName VARCHAR(32), 
			     @patchFileName VARCHAR(64),
			     @versionUpdate VARCHAR(8) = 'minor',
			     @patchFileDir VARCHAR(128) = '',
			     @patchDesc VARCHAR(2000) = '',
			     @patchAuth VARCHAR(256) = ''
)
-------------------------------------------------------------
--/H Run the patch contained in the given patch file.
--/A -----------------------------------------------------------
--/T Execute the patch from the given file and update the DB
--/T diagnostics and version information accordingly.  The
--/T @versionUpdate parameter allows selection of 'major' or
--/T 'minor' (default) update type so that the version number
--/T is incremented accordingly.  Hence a major update will 
--/T increase version 3.1 to 3.2, whereas minor update will 
--/T increase version 3.1 to 3.1.1.
------------------------------------------------------------- 
AS BEGIN
   DECLARE @patchFilePath VARCHAR(256), @checkSum VARCHAR(64),
	   @patchDate VARCHAR(256), @nextVersion VARCHAR(32),
	   @prevVersion VARCHAR(32), @cmd VARCHAR(256)
   DECLARE @pos1 SMALLINT, @pos2 SMALLINT, @majorVersion INT, 
           @minorVersion INT, @ret INT, @test TINYINT

   SET NOCOUNT ON
   SET @test = 0	-- set to non-zero for debugging purposes

   -- Construct path for path file, default is C:\sqlLoader\...
   IF @patchFileDir = '' 
      SET @patchFileDir = 'C:\sqlLoader\schema\patches\'
   SET @patchFilePath = @patchFileDir + @patchFileName
   SET @ret = 0

   SET @cmd = 'DIR '+@patchFilePath;
   EXEC @ret = master.dbo.xp_cmdshell @cmd, no_output;
   IF @ret != 0
      BEGIN
         PRINT 'Problem with loading patches - file '+@patchFilePath+' not found.'
         RETURN 1;
      END

   -- Run the patch from the given patch file.
   IF @test = 0
      EXEC @ret = spRunSqlScript 0, 0, 'RunPatch', @patchFileDir, @patchFileName

   -- If patch ran fine, update the DB diagnostics and version info.
   IF @ret = 0
      BEGIN
	 -- Bump up the version number.  The version number needs to be of
         -- the form 2.1 or 2.1.1.
	 SELECT @prevVersion=max(version) FROM Versions
		WHERE ISNUMERIC(version)=1
   			OR ISNUMERIC( SUBSTRING(version,CHARINDEX('.',version,1)+1,
			LEN(version)-CHARINDEX('.',version,1)) )=1
	 SET @pos1 = CHARINDEX('.', @prevVersion, 1)
         IF @pos1 = 0
            BEGIN
		PRINT 'Problem with running patch - previous version number is not valid: '+@prevVersion
		RETURN 1;
            END
	 SET @pos2 = CHARINDEX('.', @prevVersion, @pos1+1 )
	 IF @pos2=0
            BEGIN
               IF @versionUpdate = 'minor'
                  SET @nextVersion = @prevVersion + '.1'
	       ELSE
                  SET @nextVersion=CAST( (CAST(@prevVersion AS REAL) + 0.1) AS VARCHAR(10) )
            END
	 ELSE
	    BEGIN
	       SET @majorVersion=CAST( SUBSTRING(@prevVersion,@pos1+1,@pos2-@pos1-1) AS INT )
	       IF @versionUpdate = 'minor'
                  SET @minorVersion=CAST( SUBSTRING(@prevVersion,@pos2+1,LEN(@prevVersion)-@pos2) AS INT ) + 1
	       ELSE
		  BEGIN
		     SET @majorVersion = @majorVersion + 1
		     SET @minorVersion = 0
		  END
	       SET @nextVersion = SUBSTRING(@prevVersion,1,@pos1-1)+ '.' + 
		   CAST(@majorVersion AS VARCHAR(2)) + '.' +
		   CAST(@minorVersion AS VARCHAR(2));
	    END

	 -- Compute the checksum and save it in SiteConstants.
         IF @test = 0
            BEGIN
		-- Update statistics for all tables
		EXEC spUpdateStatistics

		-- generate diagnostics and checksum
		EXEC spMakeDiagnostics
		EXEC spUpdateSkyServerCrossCheck
		EXEC spCompareChecksum
	    END
	 SELECT @checkSum=value FROM SiteConstants WHERE name='Checksum'
	 SELECT @patchDate=value FROM SiteConstants 
		WHERE name='DB Version Date'

	 -- Add the latest version info to the Versions table.
         IF @test = 0
            INSERT INTO Versions Values (
		'Applied patch '+@patchName,@prevVersion,@checkSum,@nextVersion,
		'Patch loaded from file '+@patchFilePath,
		@patchDesc, @patchAuth, @patchDate 
		)
         ELSE
            SELECT
		'Applied patch '+@patchName,@prevVersion,@checkSum,@nextVersion,
		'Patch loaded from file '+@patchFilePath,
		@patchDesc, @patchAuth, @patchDate 
      END
   ELSE
      PRINT 'Problem with patch file ... patch did not run successfully.'

   RETURN @ret
END
GO



--==================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spLoadMetaData]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spLoadMetaData]
GO
--
CREATE PROCEDURE spLoadMetaData(@taskid int, @stepid int,
	@metadir varchar(128), @dropIndices int = 0)
---------------------------------------------------
--/H Loads the Metadata about the schema
--/A -------------------------------------------------
--/T Insert metadata into the database, where it is
--/T located in the UNC path @metadir. Only log if
--/T @taskid>0. Returns >0, if errors occurred.
--/T It will drop and rebuild the indices on the 
--/T META index group.
--/T <samp>exec spLoadMetaData 0,0, '\\SDSSDB\c$\sqlLoader\schema\csv\' </samp>
---------------------------------------------------
AS
BEGIN
	--
	SET NOCOUNT ON;
	--
    	DECLARE @ret int,
		@err int,
		@dbname varchar(64),
		@msg varchar(1024),
		@cmd nvarchar(1024),
		@fname varchar(128);

	--------------------------------------
	-- write log message
	--------------------------------------
	SET @msg =  'Starting to load metadata';
	IF @taskID > 0
		EXEC spNewPhase @taskID, @stepID,
			'Metadata','OK',@msg;
	ELSE
		PRINT @msg;
	--
	SET @ret=0;
	SET @err=0;

	--------------------------------------------------
	-- verify that directory exists and it has files
	--------------------------------------------------
	CREATE TABLE #msg (id int identity(1,1), s varchar(2048));
	SET @cmd = N'dir '+@metadir+ '*.sql /B';
	INSERT INTO #msg EXEC @ret=master.dbo.xp_cmdshell @cmd;
	SELECT @ret = count(*) FROM #msg
	    WHERE  s like '%cannot find%' 
		or s like '%Not Found%' 
		or s like '%incorrect%'
		and s is not NULL
	--
	IF @ret>0 
	BEGIN
		SET @msg =  'The directory '+ @metadir +' not found';
		IF @taskid > 0
		    EXEC spNewPhase @taskID, @stepID, 'Metadata','ABORTING',@msg;
		ELSE
		    PRINT @msg;
		RETURN @ret
	END

	-------------------------------------------------
	-- first drop all the primary/foreign keys and indices
	-------------------------------------------------
	IF (@dropIndices != 0)
	    BEGIN
		EXEC spIndexDropSelection @taskid, @stepid, 'F','META'
		EXEC spIndexDropSelection @taskid, @stepid, 'I','META'
		EXEC spIndexDropSelection @taskid, @stepid, 'K','META'
	    END

    	--
	EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
		'Metadata', @metadir, 'loaddbobjects.sql' 
	SET @err = @err+@ret;
	--
	EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
		'Metadata', @metadir, 'loaddbviewcols.sql' 
	SET @err = @err+@ret;
	--
	EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
		'Metadata', @metadir, 'loaddbcolumns.sql' 
	SET @err = @err+@ret;
	--
	EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
		'Metadata', @metadir, 'loadinventory.sql' 
	SET @err = @err+@ret;
	--
	EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
		'Metadata', @metadir, 'loaddependency.sql' 
	SET @err = @err+@ret;
	--
	EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
		'Metadata', @metadir, 'loadhistory.sql' 
	SET @err = @err+@ret;
	--
	
	-----------------------------------------
	-- rebuild the indices on the META group if necessary
	-----------------------------------------
	IF (@dropIndices != 0)
	    BEGIN
		EXEC spIndexBuildSelection @taskid, @stepid, 'K','META'
		EXEC spIndexBuildSelection @taskid, @stepid, 'I','META'
		EXEC spIndexBuildSelection @taskid, @stepid, 'F','META'
	    END	
	--
	RETURN @err;
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects 
	WHERE id = object_id(N'[dbo].[spRemoveTaskFromTable]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spRemoveTaskFromTable]
GO
--
CREATE PROCEDURE spRemoveTaskFromTable(
	@tablename varchar(64),
	@pk varchar(64),
	@reinsert int = 0,
	@countsOnly int = 1
)
-------------------------------------------------------
--/H Removes rows from table linked to PhotoObj corresponding to a given 
--/H task (as specified by a value of the loadversion).
--/A
--/T Assumes that there is a table called ObjIds, which 
--/T contains the bigint PKs of all objects to be removed.
--/T Parameters:
--/T <li> @tableName: the name of the table to be cleaned
--/T <li> @pk: the name of the primary key link
--/T <li> @reinsert: 1 if objects need to be reinserted,
--/T   0 if just to be removed.  Default is 0
--/T <li> @countsOnly: 1 if only counts, no actual deletion desired;
--/T   0 if deletion to go ahead.  Default is 1 (non-destructive).
--/T <samp>
--/T 	exec spRemoveTaskFromTable 'Rosat', 'objID'
--/T </samp>
-------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @cmd nvarchar(4000),
		@msg varchar(4000),
		@total bigint,
		@this bigint,
		@objCount int,
		@ret int;
	--
	SET @ret = 0;

--	CREATE TABLE ObjCount (	nrows INT NOT NULL );

	---------------------
	-- count duplicates
	---------------------
	SELECT @total = count_big(*) FROM ObjIds;

	--------------------
	-- save corresponding objects
	--------------------
--	SET @cmd = N'INSERT ObjCount SELECT COUNT(*) FROM '+ @tableName +
--		+  ' WHERE '+ @pk + ' in (select ID from ObjIds)';
	SET @cmd = N'SELECT * INTO MyObjs FROM '+ @tableName +
		+  ' WHERE '+ @pk + ' in (select ID from ObjIds)';
	--
	EXEC @ret=sp_executesql @cmd;	

--	SELECT @objCount=nrows FROM ObjCount
	SELECT @objCount=COUNT(*) FROM MyObjs
	SET @msg = CAST(@objCount AS VARCHAR(10))
		+ ' rows will be deleted from table ' + @tableName + '.';
	PRINT @msg;
--	DROP TABLE ObjCount
	--------------------------------
	-- check if only counts desired
	--------------------------------
	IF @countsOnly = 1
 	    BEGIN
	    	GOTO finalexit
	    END

	---------------------------------------
	-- do the rest only if countsOnly is 0
	---------------------------------------
	IF (@reinsert=1)
	   BEGIN
--		SET @cmd = N'SELECT * INTO MyObjs FROM '+ @tableName +
--			+  ' WHERE '+ @pk + ' in (select ID from ObjIds)';
		--
--		EXEC @ret=sp_executesql @cmd;	
		----------------------------------------
		-- are duplicate rows really identical?
		----------------------------------------
		SET @cmd = N'SELECT '+@pk+' INTO #x FROM ' + @tableName + ' GROUP BY '+@pk
			+  ' HAVING';
		SELECT @cmd = @cmd + ' min('+name+')-max('+name+') !=0 or'
	 	   FROM DBColumns
	  	  WHERE tableName = @tableName;
		SET @cmd = @cmd + ' (1=0)';

		EXEC @ret=sp_executesql @cmd;
		SELECT @objCount=COUNT(*) FROM #x
		DROP TABLE #x 
		IF (@objCount != 0) 
		   BEGIN 
			SET @msg = 'Error: ' + @tableName +'does not have exact duplicates.'
			SET @ret = 1;
	    		GOTO finalexit
		   END
	   END
	--
	-------------------------------
	-- delete the extra objects
	-------------------------------

	SET @cmd = N'DELETE ' + @tableName + ' WHERE '+@pk+' IN (select ID from ObjIds)';
	EXEC @ret=sp_executesql @cmd;

	-------------------------------------------------------------------
	-- if this is a case of identical duplicate rows, then reinsert one
	-- instance of each duplicate row.
	-------------------------------------------------------------------
	IF (@reinsert=1)
	BEGIN
		---------------------------------------------
		-- re-insert one representative of each pair
		---------------------------------------------
		SET @cmd = N'INSERT '+@tableName 
			+  ' SELECT ';
		SELECT @cmd = @cmd + ' min('+name+') '+name+','
		    FROM DBColumns
		    WHERE tableName = @tableName;
		---------------------
		-- remove last comma
		---------------------
		SET @cmd = SUBSTRING(@cmd,1, LEN(@cmd)-1);
		SET @cmd = @cmd + ' FROM MyObjs GROUP BY '+ @pk;
		EXEC @ret=sp_executesql @cmd;
		--
	END
	--

	SET @msg  = 'Objects were successfully deleted from '+ @tableName;
	finalexit: 
	------------------------------
	-- clean up by dropping MyObjs
	------------------------------
--	IF (@reinsert=1)
	IF EXISTS (select * from dbo.sysobjects 
		where id = object_id(N'[MyObjs]')
		and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		DROP TABLE MyObjs

	----------------------------------------------------------
	-- proper error handler with spNewPhase should come here
	----------------------------------------------------------
	-- PRINT @msg;
	--
	RETURN @ret;
END
GO


--============================================================
IF EXISTS (SELECT * FROM dbo.sysobjects 
	WHERE id = object_id(N'[dbo].[spRemoveTaskPhoto]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spRemoveTaskPhoto]
GO
--
CREATE PROCEDURE spRemoveTaskPhoto (@loadversion int, 
				    @reinsert int=0,
				    @countsOnly int=1)
------------------------------------------------------
--/H Remove objects related to a given @loadversion (i.e. taskID).
--/A
--/T This script only works on a database without the FINISH step.
--/T Parameters:
--/T <li> @loadversion: the loadversion of the Task to be removed
--/T <li> @reinsert: 1 if objects need to be reinserted,
--/T   0 if just to be removed. Default is 0.
--/T <li> @countsOnly: 1 if we only want counts of objects that will
--/T   be deleted without actually deleting them; 0 if objects are
--/T   to be deleted.  Default is 1 (only return counts for checking).
------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @objCount INT, @msg VARCHAR(4000);
	--
	CREATE TABLE ObjIds (
		ID bigint NOT NULL PRIMARY KEY
	)
	CREATE TABLE FieldIds (
		ID bigint NOT NULL PRIMARY KEY
	)

	--------------------------------------
	-- linked to Field
	--------------------------------------
	INSERT FieldIds
	    SELECT fieldID as ID
	    FROM Field
	    WHERE loadversion = @loadversion
	IF @countsOnly = 1
	    BEGIN
		SELECT @objCount=COUNT(*) FROM FieldIds
		SET @msg = CAST(@objCount AS VARCHAR(10))
		    + ' fieldIDs matched loadversion ' + CAST(@loadversion AS VARCHAR(10));
		PRINT @msg;
	    END
	--
	INSERT ObjIds 
	SELECT * FROM FieldIds
 	exec spRemoveTaskFromTable 'Frame', 'fieldID', @reinsert, @countsOnly
 	exec spRemoveTaskFromTable 'FieldProfile', 'fieldID', @reinsert, @countsOnly

	--------------------------------------
	-- linked to PhotoObjAll
	--------------------------------------
	TRUNCATE TABLE ObjIds
	INSERT ObjIds
	    SELECT objID as ID
	    FROM PhotoObjAll 
	    WHERE loadversion = @loadversion
	IF @countsOnly = 1
	    BEGIN
		SELECT @objCount=COUNT(*) FROM ObjIds
		SET @msg = CAST(@objCount AS VARCHAR(10))
			+ ' objIDs matched loadversion ' + CAST(@loadversion AS VARCHAR(10));
		PRINT @msg;
	    END
	--
 	exec spRemoveTaskFromTable 'PhotoProfile', 'objID', @reinsert, @countsOnly
 	exec spRemoveTaskFromTable 'AtlasOutline', 'objID', @reinsert, @countsOnly
 	exec spRemoveTaskFromTable 'USNO', 'objID', @reinsert, @countsOnly
 	exec spRemoveTaskFromTable 'First', 'objID', @reinsert, @countsOnly
 	exec spRemoveTaskFromTable 'Rosat', 'objID', @reinsert, @countsOnly
-- 	exec spRemoveTaskFromTable 'PhotoTag', 'objID', @reinsert, @countsOnly
 	exec spRemoveTaskFromTable 'Neighbors', 'objID', @reinsert, @countsOnly
 	exec spRemoveTaskFromTable 'Zone', 'objID', @reinsert, @countsOnly

	---------------------------
	-- special case for Mask
	---------------------------
	SELECT DISTINCT maskid as ID
	INTO #x2
		FROM Mask
		WHERE (maskid & 0xFFFFFFFFFFF0000) IN (SELECT id FROM FieldIds)

	TRUNCATE TABLE ObjIds
	--
	INSERT ObjIds
	SELECT * FROM #x2

 	exec spRemoveTaskFromTable 'Mask', 'maskID', @reinsert, @countsOnly
	
	IF @countsOnly = 0 
	    BEGIN	
		--------------------------------------
		-- handle the tables with loadversion
		--------------------------------------
		DELETE Field WHERE loadversion=@loadversion;
		DELETE Chunk WHERE loadversion=@loadversion;
		DELETE Segment WHERE loadversion=@loadversion;
		DELETE Target WHERE loadversion=@loadversion;
		DELETE TargetInfo WHERE loadversion=@loadversion;
		DELETE PhotoObjAll WHERE loadversion=@loadversion;
	    END
	ELSE
	    BEGIN
		--------------------------------------
		-- return counts from the tables with loadversion
		--------------------------------------
		SELECT @objCount=COUNT(*) FROM Field WHERE loadversion=@loadversion;
		SET @msg = CAST(@objCount AS varchar(10)) +' rows to be deleted from Field';
		PRINT @msg;
		SELECT @objCount=COUNT(*) FROM Chunk WHERE loadversion=@loadversion;
		SET @msg = CAST(@objCount AS varchar(10)) +' rows to be deleted from Chunk';
		PRINT @msg;
		SELECT @objCount=COUNT(*) FROM Segment WHERE loadversion=@loadversion;
		SET @msg = CAST(@objCount AS varchar(10)) +' rows to be deleted from Segment';
		PRINT @msg;
		SELECT @objCount=COUNT(*) FROM Target WHERE loadversion=@loadversion;
		SET @msg = CAST(@objCount AS varchar(10)) +' rows to be deleted from Target';
		PRINT @msg;
		SELECT @objCount=COUNT(*) FROM TargetInfo WHERE loadversion=@loadversion;
		SET @msg = CAST(@objCount AS varchar(10)) +' rows to be deleted from TargetInfo';
		PRINT @msg;
		SELECT @objCount=COUNT(*) FROM PhotoObjAll WHERE loadversion=@loadversion;
		SET @msg = CAST(@objCount AS varchar(10)) +' rows to be deleted from PhotoObjAll';
		PRINT @msg;
	    END
	--
	DROP TABLE FieldIds
	DROP TABLE ObjIds
	RETURN 0;
END
GO

-- test spRemoveTaskPhoto with the following command:
-- exec spRemoveTaskPhoto 305,0,1



--============================================================
IF EXISTS (SELECT * FROM dbo.sysobjects 
	WHERE id = object_id(N'[dbo].[spRemovePlate]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spRemovePlate]
GO
--
CREATE PROCEDURE spRemovePlate (@plate int, @mjd int,
			        @countsOnly int=1)
------------------------------------------------------
--/H Remove spectro objects corresponding to a given plate or plates.
--/A
--/T This script only works on a database without the FINISH step.
--/T Parameters:
--/T <li> @plate: the plate number of the plate to be deleted
--/T             if 0, then multiple plates are to be deleted
--/T             and the plate list is assumed to be in PlateIds
--/T             table, and specobj list in SpecObjIds table.
--/T <li> @mjd: MJD of plate to be removed
--/T <li> @countsOnly: 1 if we only want counts of objects that will
--/T   be deleted without actually deleting them; 0 if objects are
--/T   to be deleted.  Default is 1 (only return counts for checking).
------------------------------------------------------
AS
BEGIN
	DECLARE @objCount INT, @msg VARCHAR(4000);
	DECLARE @created tinyint, @nPlates INT;
	SET @created = 0;

	IF NOT EXISTS (SELECT name FROM sysobjects
        	 	WHERE xtype='U' AND name = 'PlateIds')
	    BEGIN
		CREATE TABLE SpecObjIds (
			specObjID numeric(20,0) NOT NULL PRIMARY KEY
		)
		CREATE TABLE PlateIds (
			plateID numeric(20,0) NOT NULL PRIMARY KEY
		)
		SET @created = 1;
	    END

	IF (@plate != 0) AND (@mjd != 0)
	    BEGIN
		--------------------------------------
		-- single plate to be deleted create 
 		-- list of plateIDs and specobjIDs.
		--------------------------------------
		INSERT PlateIds 
			SELECT plateID FROM PlateX 
			WHERE plate=@plate AND mjd=@mjd
		INSERT SpecObjIds
			SELECT specObjID FROM SpecObjAll s, PlateIds p
			WHERE s.plateID = p.plateID 
	    END

	SELECT @nPlates=count(*) FROM PlateIds
	IF @nPlates = 0
	    BEGIN
		SET @msg = 'No matching plates found to delete.'
		PRINT @msg
		RETURN 1
	    END
	
	IF @countsOnly = 0 
	    BEGIN	
		--------------------------------------
		-- first drop the FK indices
		--------------------------------------
		EXEC spIndexDropSelection 0, 0, 'F','SPECTRO'

		--------------------------------------
		-- delete records from all spec tables 
		-- corresponding to given plate(s)
		--------------------------------------
		DELETE p
		FROM SpecPhotoAll p, SpecObjIds o
		WHERE p.specObjID = o.specObjID
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows deleted from SpecPhotoAll.'
		PRINT @msg

		DELETE l
		FROM SpecLineAll l, SpecObjIds o
		WHERE l.specObjID = o.specObjID
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows deleted from SpecLineAll.'
		PRINT @msg

		DELETE l
		FROM SpecLineIndex l, SpecObjIds o
		WHERE l.specObjID = o.specObjID
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows deleted from SpecLineIndex.'
		PRINT @msg

		DELETE r
		FROM ELRedshift r, SpecObjIds o
		WHERE r.specObjID = o.specObjID
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows deleted from ELRedshift.'
		PRINT @msg

		DELETE r
		FROM XCRedshift r, SpecObjIds o
		WHERE r.specObjID = o.specObjID
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows deleted from XCRedshift.'
		PRINT @msg

		DELETE h
		FROM HoleObj h, PlateIds p
		WHERE h.plateID = p.plateID
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows deleted from HoleObj.'
		PRINT @msg

		--------------------------------------
		-- delete records from PhotoObjAll 
		-- corresponding to given plate(s)
		--------------------------------------
		UPDATE PhotoObjAll
		SET specObjID = 0
		WHERE specObjID IN (SELECT specObjID FROM SpecObjIds)
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows updated in PhotoObjAll.'
		PRINT @msg

/*
		UPDATE PhotoTag
		SET specObjID = 0
		WHERE specObjID IN (SELECT specObjID FROM SpecObjIds)
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows updated in PhotoTag.'
		PRINT @msg
*/

		UPDATE Target
		SET specObjID = 0
		WHERE specObjID IN (SELECT specObjID FROM SpecObjIds)
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows updated in Target.'
		PRINT @msg

		--------------------------------------
		-- finally delete specobjall and plates
		--------------------------------------
		DELETE p
		FROM SpecObjAll p, SpecObjIds o
		WHERE p.specObjID = o.specObjID
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows deleted from SpecObjAll.'
		PRINT @msg

		DELETE p1
		FROM PlateX p1, PlateIds p2
		WHERE p1.plateID = p2.plateID
		OPTION (MAXDOP 1)
		SET @msg = CAST(@@rowCount AS VARCHAR(10)) 
				+ ' rows deleted from PlateX.'
		PRINT @msg

		--------------------------------------
		-- rebuild the FK indices
		--------------------------------------	
		EXEC spIndexBuildSelection 0, 0, 'F','SPECTRO'
	    END
	ELSE
	    BEGIN
		--------------------------------------
		-- return counts from the tables with loadversion
		--------------------------------------
		SELECT @objCount=COUNT(*)
		FROM SpecPhotoAll p, SpecObjIds o
		WHERE p.specObjID = o.specObjID
		SET @msg = CAST(@objCount AS varchar(10)) 
				+' rows to be deleted from SpecPhotoAll';
		PRINT @msg;

		SELECT @objCount=COUNT(*)
		FROM SpecLineAll l, SpecObjIds o
		WHERE l.specObjID = o.specObjID
		SET @msg = CAST(@objCount AS varchar(10)) 
				+' rows to be deleted from SpecLineAll';
		PRINT @msg;

		SELECT @objCount=COUNT(*)
		FROM SpecLineIndex l, SpecObjIds o
		WHERE l.specObjID = o.specObjID
		SET @msg = CAST(@objCount AS varchar(10)) 
				+' rows to be deleted from SpecLineIndex';
		PRINT @msg;

		SELECT @objCount=COUNT(*)
		FROM ELRedshift r, SpecObjIds o
		WHERE r.specObjID = o.specObjID
		SET @msg = CAST(@objCount AS varchar(10)) 
				+' rows to be deleted from ELRedshift';
		PRINT @msg;

		SELECT @objCount=COUNT(*)
		FROM XCRedshift r, SpecObjIds o
		WHERE r.specObjID = o.specObjID
		SET @msg = CAST(@objCount AS varchar(10)) 
				+' rows to be deleted from XCRedshift';
		PRINT @msg;

		SELECT @objCount=COUNT(*)
		FROM HoleObj h, PlateIds p
		WHERE h.plateID = p.plateID
		SET @msg = CAST(@objCount AS varchar(10)) 
				+' rows to be deleted from HoleObj';
		PRINT @msg;

		SELECT @objCount=COUNT(*)
		FROM SpecObjAll p, SpecObjIds o
		WHERE p.specObjID = o.specObjID
		SET @msg = CAST(@objCount AS varchar(10)) 
				+' rows to be deleted from SpecObjAll';
		PRINT @msg;

		SELECT @objCount=COUNT(*)
		FROM PlateX p1, PlateIds p2
		WHERE p1.plateID = p2.plateID
		SET @msg = CAST(@objCount AS varchar(10)) 
				+' rows to be deleted from PlateX';
		PRINT @msg;

	    END
	--
	IF @created = 1  
	    BEGIN
		-- we created these tables, so delete them
		DROP TABLE PlateIds
		DROP TABLE SpecObjIds
	    END
	RETURN 0;
END
GO

-- test spRemovePlate with the following command:
-- exec spRemovePlate 275,51910,1



--============================================================
IF EXISTS (SELECT * FROM dbo.sysobjects 
	WHERE id = object_id(N'[dbo].[spRemoveTaskSpectro]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spRemoveTaskSpectro]
GO
--
CREATE PROCEDURE spRemoveTaskSpectro (@loadversion int, 
				      @countsOnly int=1)
------------------------------------------------------
--/H Remove spectro objects related to a given @loadversion (i.e. taskID).
--/A
--/T This script only works on a database without the FINISH step.
--/T Parameters:
--/T <li> @loadversion: the loadversion of the Task to be removed
--/T <li> @countsOnly: 1 if we only want counts of objects that will
--/T   be deleted without actually deleting them; 0 if objects are
--/T   to be deleted.  Default is 1 (only return counts for checking).
------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @objCount INT, @msg VARCHAR(4000);
	--
	CREATE TABLE SpecObjIds (
		specObjID numeric(20,0) NOT NULL PRIMARY KEY
	)
	CREATE TABLE PlateIds (
		plateID numeric(20,0) NOT NULL PRIMARY KEY
	)

	--------------------------------------
	-- linked to Field
	--------------------------------------
	INSERT PlateIds
	    SELECT plateID
	    FROM PlateX
	    WHERE loadversion = @loadversion
	IF @countsOnly = 1
	    BEGIN
		SELECT @objCount=COUNT(*) FROM PlateIds
		SET @msg = CAST(@objCount AS VARCHAR(10))
		    + ' Plates matched loadversion ' + CAST(@loadversion AS VARCHAR(10));
		PRINT @msg;
	    END
	--
	INSERT SpecObjIds 
	SELECT specObjID FROM SpecObjAll s, PlateIds p
	WHERE s.plateID = p.plateID
	--
	EXEC spRemovePlate 0, 0, @countsOnly
	--
	DROP TABLE PlateIds
	DROP TABLE SpecObjIds
	RETURN 0;
END
GO

-- test spRemoveTaskSpectro with the following command:
-- exec spRemoveTaskSpectro 305,1


--============================================================
IF EXISTS (SELECT * FROM dbo.sysobjects 
	WHERE id = object_id(N'[dbo].[spRemovePlateList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spRemovePlateList]
GO
--
CREATE PROCEDURE spRemovePlateList (@fileName VARCHAR(128), 
			            @countsOnly int=1)
------------------------------------------------------
--/H Remove spectro objects related to the plate list in the given file.
--/A
--/T This script only works on a database without the FINISH step.
--/T Parameters:
--/T <li> @fileName: name of file on disk containing list of plate#s 
--/T   and MJDs
--/T <li> @countsOnly: 1 if we only want counts of objects that will
--/T   be deleted without actually deleting them; 0 if objects are
--/T   to be deleted.  Default is 1 (only return counts for checking).
------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @objCount INT, @msg VARCHAR(4000);
	DECLARE @ret INT, @cmd nvarchar(2048);
	--
	SET @cmd = 'DIR '+@fileName;
	EXEC @ret = master.dbo.xp_cmdshell @cmd, no_output;
	IF @ret != 0
	    BEGIN
		SET @msg = 'Problem with loading plate list - file '+@fileName+' not found.';
		PRINT @msg;
		RETURN @ret;
	    END

	CREATE TABLE PlateList (
		plate INT NOT NULL,
		mjd INT NOT NULL
	)

	-- read in the plate numbers and MJDs from the file
	SET @cmd = N'BULK INSERT PlateList FROM ['+@fileName+'] WITH ('
		+ ' DATAFILETYPE = ''char'','
		+ ' FIELDTERMINATOR = '','','
		+ ' ROWTERMINATOR = ''\n'','
		+ ' BATCHSIZE =10000,'
		+ ' CODEPAGE = ''RAW'','
		+ ' TABLOCK)';
	--
	EXEC @ret=sp_executesql @cmd;
	IF @ret != 0
	    BEGIN
		DROP TABLE PlateList
		SET @msg = 'Problem with inserting file: '+@fileName+' into table.';
		PRINT @msg;
		RETURN @ret;
	    END

	------------------------------------------------
	-- create tables to hold plateids and specobjids
	------------------------------------------------
	CREATE TABLE PlateIds (
		plateID numeric(20,0) NOT NULL PRIMARY KEY
	)
	CREATE TABLE SpecObjIds (
		specObjID numeric(20,0) NOT NULL PRIMARY KEY
	)

	INSERT PlateIds
	    SELECT p.plateID
	    FROM PlateX p, PlateList l
	    WHERE p.plate = l.plate and p.mjd = l.mjd
	IF @countsOnly = 1
	    BEGIN
		SELECT @objCount=COUNT(*) FROM PlateIds
		SET @msg = CAST(@objCount AS VARCHAR(10))
		    + ' plates will be deleted.';
		PRINT @msg;
	    END
	--
	INSERT SpecObjIds 
	    SELECT specObjID FROM SpecObjAll s, PlateIds p
	    WHERE s.plateID = p.plateID
	--
	EXEC spRemovePlate 0, 0, @countsOnly
	--
	DROP TABLE PlateIds
	DROP TABLE SpecObjIds
	DROP TABLE PlateList
	RETURN 0;
END
GO

-- test spRemovePlateList with the following command:
-- exec spRemovePlateList 'c:\temp\platelist.csv',1


--==================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spTableCopy' )
	DROP PROCEDURE spTableCopy
GO
--
CREATE PROCEDURE spTableCopy (@sourceTable nvarchar(1000), @targetTable nvarchar(1000))
-------------------------------------------------------------
--/H Incremental copies @source to @target table based on ObjID range
--/A -------------------------------------------------------------
--/T <br>Copies about 100,000 rows at a time in a transaction. 
--/T <br>This avoids log overflow and is restartable.
--/T <br>The two tables should exist and have the same schema.
--/T <br>Both tables should have a primary clustring key on ObjID
--/T <br>If the max objID in the target table is not null (not an empty table)
--/T <br> then it is assumed that all source records less than that ObjID are already in the target.
--/T <p> parameters:  
--/T <li> @sourceTable 	nvarchar(1000), -- Source table: e.g. BestDr1.dbo.PhotoObj
--/T <li> @targetTable 	nvarchar(1000), -- Target table: e.g. temp.dbo.PhotoObj
--/T <br>
--/T Sample call to copy PhotoObj from BestDr1 to Temp
--/T <samp> 
--/T <br> exec spTableCopy N'bestDr1.dbo.PhotoObj',N'Temp.dbo.PhotoObj'
--/T </samp> 
--/T  
AS
BEGIN
	DECLARE @base 		bigint, 		-- copy from this objID  
	        @limit 		bigint, 		-- to @limit ObjID
	        @delta 		bigint, 		-- the objID range to copy
	        @i 		int, 			-- transaction counter 
	        @rows 		bigint, 		-- rows copied so far
	        @deltaRows 	bigint,			-- rows copied in this step
		@minBaseCmd  	nvarchar(1000),		-- SQL command to compute min ObjID to copy
		@CopyCmd  	nvarchar(1000)		-- actual copy command
	
	------------------------------
	-- initalize loop variables
	------------------------------
	SET @i 		= 0				-- transaction count = 0	
	set @rows 	= 0				-- no rows moved yet
	set @delta 	= 1000000			-- move less than 1M rows at a time 
	set @base 	= 0 				-- base ObjID
	
	--------------------------------
	-- this is the top of the loop
	again:
	
	if (@@trancount > 0 ) commit transaction
	begin transaction

	----------------------------------------------
	-- Compute the starting ObjID for the copy.
	-- It should be bigger than the largest objID 
	-- in the target table.
	----------------------------------------------
	set @minBaseCmd = 'select @base = coalesce(max(objID),0) from ' + @targetTable 
 	exec sp_executesql  @minBaseCmd,   N'@base  bigint OUTPUT',  @base OUTPUT
	------------------------------------------------------
	-- this looks in source and gets the next larger objID
	------------------------------------------------------
	set @minBaseCmd = 'select @base = min(objID) from ' + @sourceTable + ' where objID > @base'
 	exec sp_executesql  @minBaseCmd,   N'@base  bigint OUTPUT',  @base OUTPUT
	---------------------------------------------------------	
	-- exit the loop and return if there is no such objectID
	---------------------------------------------------------
	if @base is null 
		begin
		commit transaction
		return
		end

	----------------------------------------
	-- OK, we have base, set limit and 
	-- do the copy as one transaction
	----------------------------------------
	set @limit = @base + @delta
	set @CopyCmd =  ' insert ' +  @targetTable +
			' select * from ' + @sourceTable  +
			' where objID between @base and @limit'
	exec sp_executesql  @CopyCmd,   N'@base bigint, @limit bigint',  @base, @limit  	
	set @deltaRows = @@rowcount
	set @rows = @rows + @deltaRows
	
	--------------------------------------------------------
	-- copy complete, commit transaction and print message 
	--------------------------------------------------------
	COMMIT TRANSACTION
	IF (@@trancount > 0 ) COMMIT TRANSACTION
	PRINT 'did transaction: ' + str(@i) 
				+ ' base: '  + cast(@base  as varchar(25)) 
				+ ' limit: ' + cast(@limit as varchar(25)) 
				+ ' Rows: '  + cast(@rows  as varchar(25))	
	------------------------------
	-- go to the top of the loop. 
	------------------------------
	goto again
END
GO


--============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spBuildSpecPhotoAll' )
	DROP PROCEDURE spBuildSpecPhotoAll
GO
--
CREATE PROCEDURE spBuildSpecPhotoAll (
	@taskid int, 
	@stepid int 
)
-------------------------------------------------------------------------------
--/H Collect the combined spectro and photo parameters of an object in SpecObjAll
--/A --------------------------------------------------------------------------
--/T This is a precomputed join between the PhotoObjAll and SpecObjAll tables.
--/T The photo attibutes included cover about the same as PhotoTag.
--/T The table also includes certain attributes from Tiles.
-------------------------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	------------------------------------------------------
	-- Put out step greeting.
	EXEC spNewPhase @taskid, @stepid, 'SpecPhotoAll', 'OK', 'spBuildSpecPhotoAll called';
	------------------------------------------------------
	--
	DECLARE @rows bigint,
		@msg varchar(1000)
	EXEC spIndexDropSelection @taskid, @stepid, 'F', 'SpecPhotoAll'
	EXEC spIndexDropSelection @taskid, @stepid, 'I', 'SpecPhotoAll'
	BEGIN TRANSACTION
	    TRUNCATE TABLE SpecPhotoAll
	    --
		DBCC TRACEON(610)
	    INSERT SpecPhotoAll WITH (TABLOCK)
 	    SELECT
	 	s.specObjID,     
		s.mjd,
		s.plate,
		s.tile,
		s.fiberID,
		s.z,
		s.zErr,
		s.class,
		s.subclass,
		s.zWarning,
		s.ra,
		s.[dec],
		s.cx,
		s.cy,
		s.cz,
		s.htmid,
		s.sciencePrimary,
		s.legacyPrimary,
		s.seguePrimary,
		s.segue1Primary,
		s.segue2Primary,
		s.bossPrimary,
		s.sdssPrimary,
		s.survey,
		s.programName,
		s.legacy_target1,
		s.legacy_target2,
		s.special_target1,
		s.special_target2,
		s.segue1_target1,
		s.segue1_target2,
		s.segue2_target1,
		s.segue2_target2,
		s.boss_target1,
		s.ancillary_target1,
		s.ancillary_target2,
		s.plateID,
		s.sourceType,
		s.targetObjID,
		p.objID,
		p.skyVersion,
		p.run,
		p.rerun,
		p.camcol,
		p.field,
		p.obj,
		p.mode,
		p.nChild,
		p.type,
		p.flags,
		p.psfMag_u,
		p.psfMag_g,
		p.psfMag_r,
		p.psfMag_i,
		p.psfMag_z,
		p.psfMagErr_u,
		p.psfMagErr_g,
		p.psfMagErr_r,
		p.psfMagErr_i,
		p.psfMagErr_z,
		p.fiberMag_u,
		p.fiberMag_g,
		p.fiberMag_r,
		p.fiberMag_i,
		p.fiberMag_z,
		p.fiberMagErr_u,
		p.fiberMagErr_g,
		p.fiberMagErr_r,
		p.fiberMagErr_i,
		p.fiberMagErr_z,
		p.petroMag_u,
		p.petroMag_g,
		p.petroMag_r,
		p.petroMag_i,
		p.petroMag_z,
		p.petroMagErr_u,
		p.petroMagErr_g,
		p.petroMagErr_r,
		p.petroMagErr_i,
		p.petroMagErr_z,
		p.modelMag_u,
		p.modelMag_g,
		p.modelMag_r,
		p.modelMag_i,
		p.modelMag_z,
		p.modelMagErr_u,
		p.modelMagErr_g,
		p.modelMagErr_r,
		p.modelMagErr_i,
		p.modelMagErr_z,
		p.cModelMag_u,
		p.cModelMag_g,
		p.cModelMag_r,
		p.cModelMag_i,
		p.cModelMag_z,
		p.cModelMagErr_u,
		p.cModelMagErr_g,
		p.cModelMagErr_r,
		p.cModelMagErr_i,
		p.cModelMagErr_z,
		p.mRrCc_r,
		p.mRrCcErr_r,
		p.score,
		p.resolvestatus,
		p.calibstatus_u,
		p.calibstatus_g,
		p.calibstatus_r,
		p.calibstatus_i,
		p.calibstatus_z,
		p.ra as photoRa,
		p.[dec] as photoDec,
		p.extinction_u,
		p.extinction_g,
		p.extinction_r,
		p.extinction_i,
		p.extinction_z,
		p.fieldID,
		p.dered_u,
		p.dered_g,
		p.dered_r,
		p.dered_i,
		p.dered_z
	    FROM SpecObjAll s WITH (NOLOCK)
	    LEFT OUTER JOIN PhotoObjAll p WITH (NOLOCK) ON s.bestObjid=p.objid
	    ORDER BY s.specobjid
	    SET  @rows = ROWCOUNT_BIG();
		DBCC TRACEOFF(610)
	COMMIT TRANSACTION
	-- generate completion message.
	EXEC spIndexBuildSelection @taskid, @stepid, 'I', 'SpecPhotoAll'
	EXEC spIndexBuildSelection @taskid, @stepid, 'F', 'SpecPhotoAll'
	SET @msg = 'spBuildSpecPhotoAll done, '  
	    + cast(@rows as varchar(10))
	    + ' rows inserted into SpecPhotoAll';

	EXEC spNewPhase @taskid, @stepid, 'SpecPhotoAll', 'OK', @msg;
	------------------------------------------------------
	RETURN(0);
END
GO



--=========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSegue2SpectroPhotoMatch]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spSegue2SpectroPhotoMatch]
GO
--
CREATE PROCEDURE spSegue2SpectroPhotoMatch (
	@taskid int, 
	@stepid int 
)
-------------------------------------------------------------
--/H Computes PhotoObj corresponding to new SEGUE2 spectra
--/A --------------------------------------------------------
--/T Connect SEGUE2 spectra to photo objects in Best 
--/T Designed to run in the Best database.
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call   <br>
--/T <br> <samp> 
--/T exec spSegue2SpectroPhotoMatch @taskid , @stepid  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON
	-----------------------------------------------------
	-- local table variable to hold the specobjects
	CREATE TABLE #PhotoSpec (
		PhotoObjID 		bigint,
	 	mode			tinyint,
		SpecObjID		bigint PRIMARY KEY,
		sciencePrimary	tinyint,
		ra				float,
		[dec]			float,
		cX				float,
		cY				float,
		cZ				float,
		Distance		float
	) 
	--
	DECLARE @rows bigint,
		@msg varchar(1000)
	-----------------------------------------------------
	-- give phase start message 
	SET @msg =  'Starting heuristic match of SEGUE2 '
	    + 'Spectro & Photo objects on BEST-PUB'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	-----------------------------------------------------
	-- fill in spectro info for objects with positions
	INSERT 	#PhotoSpec
	SELECT 	NULL, 0,
		SpecObjID, sciencePrimary, ra, [dec],
		cx, cy, cz, -1
	FROM BESTSEGUE2.dbo.SpecObjAll WITH(nolock)
	WHERE BestObjID = 0
	AND ra between 0 and 360
	AND [dec] between -90 and 90
	-----------------------------------------------------
	-- give phase start message 
	SET @msg =  'Starting SEGUE2 spatial matchup'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	-- find lowest mode, nearest objid within 1.0"
	DECLARE @mode tinyint;
	SET @mode = 1;
	WHILE (@mode <= 4)
	BEGIN
		UPDATE	#PhotoSpec
		SET 	PhotoObjID = dbo.fGetNearestObjIdEqMode(ra,[dec],1.0/60.0,@mode),
			mode = @mode
		WHERE	PhotoObjID IS NULL
		OPTION (MAXDOP 1)
		SET @mode = @mode + 1;
	END
	-----------------------------------------------------
	-- delete orphans (no match)
	DELETE #PhotoSpec
	    WHERE PhotoObjID IS NULL
	-----------------------------------------------------
	SET @msg =  'Starting SEGUE2 SpecObjAll update'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	-- Set SpecObj.ObjID from PhotoSpectro
	BEGIN TRANSACTION
	    UPDATE BESTSEGUE2.dbo.SpecobjAll
		SET    BestObjId = PS.PhotoObjID
		FROM   SpecObjAll S, #PhotoSpec PS
		WHERE  S.SpecObjID = PS.SpecObjID
		OPTION (MAXDOP 1)
	COMMIT TRANSACTION
	-----------------------------------------------------
	-- Set PhotoObjAll.SpecObjID from PhotoSpectro
	SET @msg =  'Starting PhotoObjAll update for SEGUE2'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	--
	BEGIN TRANSACTION
	    UPDATE PhotoObjAll
		SET    	specObjID = PS.specObjID
		FROM   	photoObjAll P, #PhotoSpec PS
		WHERE  	P.objID = PS.PhotoObjID
		AND 	PS.sciencePrimary = 1
		OPTION (MAXDOP 1)
	COMMIT TRANSACTION

/*
	-----------------------------------------------------
	-- Set PhotoTag.SpecObjID from PhotoSpectro
	SET @msg =  'Starting PhotoTag update for SEGUE2'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	--
	BEGIN TRANSACTION
	    UPDATE PhotoTag
		SET    	specObjID = PS.specObjID
		FROM   	photoTag P WITH(NOLOCK), #PhotoSpec PS
		WHERE  	P.objID = PS.PhotoObjID
		AND 	PS.sciencePrimary = 1
		OPTION (MAXDOP 1)
	COMMIT TRANSACTION
*/
	-----------------------------------------------------
	-- Set sppParams.bestObjID from SpecObjAll
	SET @msg =  'Starting sppParams bestObjID update for SEGUE2'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	--
	BEGIN TRANSACTION
	    UPDATE P
		SET    	P.BESTOBJID = S.bestObjID
		FROM   	sppParams P WITH(NOLOCK) 
			JOIN SpecObjAll S ON P.specObjID=S.specObjID
		OPTION (MAXDOP 1)
	COMMIT TRANSACTION
	-----------------------------------------------------
	SELECT @rows = count_big(*) from #PhotoSpec
	SET @msg = 'spSegue2SpectroPhotoMatch found ' 
	    + cast(@rows as varchar(20)) + ' matches'
	-----------------------------------------------------
	-- give phase message telling of success.
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	-----------------------------------------------------
	DROP TABLE #PhotoSpec
	RETURN(0);
END	-- end spSegue2SpectroPhotoMatch
GO


--===============================================================
IF EXISTS (SELECT * FROM dbo.sysobjects 
	WHERE id = object_id(N'[dbo].[fGetNearbyTiledTargetsEq]') 
	      AND xtype IN (N'FN', N'IF', N'TF'))
	DROP FUNCTION [dbo].[fGetNearbyTiledTargetsEq]
GO
--
CREATE  FUNCTION fGetNearbyTiledTargetsEq(@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of tiled targets within @r arcmins of an Equatorial point (@ra,@dec)
--/A -----------------------------------------------------------
--/T <br> ra, dec are in degrees, r is in arc minutes. 
--/T <p> returned table:  
--/T <li> tile smallint,               -- tile number
--/T <li> targetid bigint,             -- id of target
--/T <li> ra float,                    -- ra (degrees)
--/T <li> dec float,                   -- dec (degrees)
--/T <li> sourceType int               -- type of object fiber
--/T <br>
-------------------------------------------------
RETURNS @obj table (tile smallint, targetID bigint, ra float, [dec] float, sourceType int)
AS BEGIN
          DECLARE @nx float,
                @ny float,
                @nz float,
                @cmd varchar(1000),
                @level int,
                @rad float,
                @shift bigint

        if (@r > 250) set @r = 250      -- limit to 4.15 degrees == 250 arcminute radius
        set @nx  = COS(RADIANS(@dec))*COS(RADIANS(@ra));
        set @ny  = COS(RADIANS(@dec))*SIN(RADIANS(@ra));
        set @nz  = SIN(RADIANS(@dec));
        set @level = CONVERT(int,(13- FLOOR(LOG(@r)/LOG(2.0))));
        if (@level<5)  set @level=5;
        if (@level>13) set @level=13;
        set @shift = CONVERT(int,POWER(4.,20-@level)); -- 4 = 2^2 and 2 bits per htm level
        set @cmd = 'CIRCLE CARTESIAN '+str(@level)+' '+str(@ra,22,15)+' '+str(@dec,22,15)+' '+str(@r,10,3);
        
        DECLARE @lim float;
		SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);

        INSERT @obj
        SELECT tile, targetID, ra, [dec], sourceType
        	FROM dbo.fHTMCoverRegion(@cmd) , TiledTarget WITH (nolock)
	        WHERE (HTMID BETWEEN  HTMIDstart*@shift AND HTMIDend*@shift)
        	AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
        --
        RETURN
END
GO



--===========================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spTiledTargetDuplicates' ) 
	drop procedure spTiledTargetDuplicates
GO
--
CREATE PROCEDURE spTiledTargetDuplicates (@counts int OUTPUT)
-------------------------------------------------------------
--/H  procedure to mark duplicate tiled targets
--/A --------------------------------------------------------
--/T  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @tile smallint, @ra float, @dec float, @r float;
	DECLARE @qa int, @sky int, @spectrophoto_std int;
	set @qa = (select dbo.fSourceType('QA'));
	set @sky = (select dbo.fSourceType('SKY'));
	set @spectrophoto_std = (select dbo.fSourceType('SPECTROPHOTO_STD'));
	DECLARE tt_cursor CURSOR
		FOR SELECT tt.tile,tt.ra,tt.[dec]
		FROM TiledTarget tt, TargetInfo ti, Tile
		WHERE tt.sourcetype not in (@qa,@sky,@spectrophoto_std)
		AND tt.tile = Tile.tile
		AND Tile.programType = 0
		AND tt.targetID = ti.targetID
		AND ti.skyVersion = 0
		AND ti.targetMode = 1
	set @r = 0.5/60.0;
	OPEN tt_cursor;
	WHILE (1 = 1)
	BEGIN
	    FETCH NEXT FROM tt_cursor
		INTO  	@tile, @ra, @dec
	    IF (@@FETCH_STATUS != 0) BREAK;
	    SET @counts = (	select count(*) 
		from dbo.fgetNearbyTiledTargetsEq(@ra,@dec,@r) ntt, targetinfo ti, Tile
		where ntt.sourcetype not in (@qa,@sky,@spectrophoto_std)
		and ntt.tile = Tile.tile
		and Tile.programType = 0
		and ntt.tile < @tile
		and ntt.targetID = ti.targetID
		and ti.skyVersion = 0
		and ti.targetMode = 1);
	    IF (@counts > 0)
		BEGIN
			UPDATE 	TiledTarget
			SET	TiledTarget.duplicate = 1
			WHERE CURRENT OF tt_cursor;
		END
	END
	CLOSE tt_cursor;
	DEALLOCATE tt_cursor;
END
GO



--===========================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spSynchronize' ) 
	drop procedure spSynchronize
GO
--
CREATE PROCEDURE spSynchronize (
	@taskid int, 
	@stepid int
)
-------------------------------------------------------------
--/H  Finish Spectro object (do photo Spectro matchup)
--/A --------------------------------------------------------
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int	   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spSynchronize @taskid , @stepid  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON
	------------------------------------------------------
	--- Globals
	DECLARE @start datetime,
		@ret int, 
		@cmd varchar(8000),
		@msg varchar(1024),
		@targetDBname varchar(1000),
		@rows  bigint,
		@ttDupCount int 
	SET @start  = current_timestamp;
	IF (@taskid != 0) EXEC loadsupport.dbo.spSetFinishPhase 'syncSpectro'
	------------------------------------------------------
	-- Put out step greeting.
	EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', 'spSynchronize called';
	------------------------------------------------------
	--- First set PhotoObjAll.specobjid to 0 
	BEGIN TRANSACTION
	    UPDATE p
		SET p.specobjid=0
		FROM PhotoObjAll p WITH (tablock)
		WHERE 
		    p.specobjid != 0
		OPTION (MAXDOP 1)	
	    SET  @rows = ROWCOUNT_BIG();
	COMMIT TRANSACTION
	SET  @msg = 'Set specobjid to 0 for ' + str(@rows) + ' PhotoObjAll rows.'
	EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', @msg;
	BEGIN TRANSACTION
	    UPDATE p
		SET p.specobjid=s.specobjid
		FROM PhotoObjAll p WITH (tablock)
		     JOIN SpecObjAll s ON p.objid=s.bestobjid
		WHERE
		    p.specobjid=0
		OPTION (MAXDOP 1)	
	    SET  @rows = ROWCOUNT_BIG();
	COMMIT TRANSACTION
	IF (@rows = 0)
	   SELECT @rows=COUNT(*) FROM PhotoObjAll WHERE specobjid != 0
	SET  @msg = 'Updated unset specObjID links for ' + str(@rows) + ' PhotoObjAll rows.'
	EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', @msg;
	-----------------------------------------------------
	EXEC spBuildSpecPhotoAll @taskid, @stepid

	-- generate completion message.
	SET @msg = 'spSynchronize finished in '  
	    + cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))
	    + ' seconds';

	EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', @msg;
	------------------------------------------------------
	RETURN(0);
END	-- End spSynchronize()
GO



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spFixTargetVersion]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spFixTargetVersion]
GO
--
CREATE PROCEDURE spFixTargetVersion ( @taskid int, @stepid int )
-------------------------------------------------------------
--/H Fixes targetVersion in TilingGeometry before running sectors.
--/A --------------------------------------------------------
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call   <br>
--/T <br> <samp> 
--/T exec spFixTargetVersion @taskid , @stepid  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    SET NOCOUNT ON
    DECLARE @msg varchar(1024)
    -------------------------------------------------
    -- execute TargetVersion patch on TilingGeometry
    -------------------------------------------------
    UPDATE TilingGeometry
	SET targetVersion=REPLACE(targetVersion,'ts_','')
	WHERE targetVersion LIKE 'ts_%'

    UPDATE TilingGeometry
	SET targetversion =
	    SUBSTRING(targetVersion,1,PATINDEX('%[a-uw-z]%',targetVersion)-1)
	WHERE PATINDEX('%[a-uw-z]%',targetVersion)>0
	    AND targetVersion LIKE 'v%'

    -- generate completion message.
    SET @msg = 'Fixed targetVersion in TilingGeometry';

    EXEC spNewPhase @taskid, @stepid, 'FixTargetVersion', 'OK', @msg;
	------------------------------------------------------
    RETURN(0);
END
GO



--========================================================
IF  EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[spSdssPolygonRegions]') 
		AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[spSdssPolygonRegions]
GO
--
CREATE PROCEDURE spSdssPolygonRegions(	
	@taskid int, 
	@stepid int 
)
--------------------------------------------------------------------------
--/H Create regions of a type 'POLYGON' during FINISH stage
--/A ---------------------------------------------------------------------
--/T Create the polygon regions for main survey and set the areas
--/T using regionBinary.
------------------------------------------------------
AS
BEGIN
	DECLARE @msg varchar(1000)
	-----------------------------------------------------
	-- give phase start message 
	SET @msg =  'Starting creation of SDSS polygon regions '
	EXEC spNewPhase @taskID, @stepID, 'spSdssPolygonRegions', 'OK', @msg;
	-----------------------------------------------------
	EXEC dbo.spIndexDropSelection @taskID, @stepID, 'F', 'REGION'
	EXEC dbo.spIndexDropSelection @taskID, @stepID, 'F', 'SECTOR'
	TRUNCATE TABLE Region
	INSERT Region WITH (tablock)
	    SELECT sdsspolygonid AS id, 'POLYGON' AS TYPE, '' AS comment,
		   0 AS ismask, -1 AS area, NULL AS regionstring,
		   sph.fSimplifyQueryAdvanced('SELECT 0, X,Y,Z, C FROM SdssImagingHalfspaces WHERE SdssPolygonID=' + convert(varchar(128),SdssPolygonID), 0,0,0,0) AS regionBinary
--		   dbo.fSphSimplifyQueryAdvanced('SELECT 0, X,Y,Z, C FROM SdssImagingHalfspaces WHERE SdssPolygonID=' + convert(varchar(128),SdssPolygonID), 0,0,0,0) AS regionBinary
		FROM sdssPolygons WITH (NOLOCK)
	UPDATE Region SET area = COALESCE(sph.fGetArea(regionbinary), -1)
--	UPDATE Region SET area = COALESCE(dbo.fSphGetArea(regionbinary), -1)

	-- Sync the RegionPatch table with Region
	EXEC spRegionSync 'POLYGON'
  
	EXEC dbo.spIndexBuildSelection @taskID, @stepID, 'F', 'SECTOR'
	EXEC dbo.spIndexBuildSelection @taskID, @stepID, 'F', 'REGION'
	------------------------------------------------------
	-- generate completion message.
	SET @msg = 'Created SDSS Polygon regions';
	EXEC spNewPhase @taskid, @stepid, 'spSdssPolygonRegions', 'OK', @msg;
	------------------------------------------------------
    RETURN(0);
END
GO



--============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spLoadPhotoTag' )
	DROP PROCEDURE spLoadPhotoTag
GO
--
CREATE PROCEDURE spLoadPhotoTag (@taskID INT, @stepID INT, 
				 @incremental tinyint = 1)
-------------------------------------------------------------------------------
--/H Create the PhotoTag index in PhotoObjAll
--/A --------------------------------------------------------------------------
--/T This index contains the popular fields from the PhotoObjAll table.
-------------------------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @msg VARCHAR(256), @ret int
	SET @ret = 0
	EXEC loadsupport.dbo.spSetFinishPhase 'loadPhotoTag'
	--
	EXEC @ret = dbo.spIndexCreatePhotoTag @taskID, @stepID
/*
	IF (@incremental = 0)
	    BEGIN
		-- if campaign load, delete existing contents of table
		TRUNCATE TABLE PhotoTag
		-- insert the contents ordered on objid for efficient scans
		INSERT PhotoTag
		SELECT 	objID,
			skyVersion,
			run,
			rerun,
			camcol,
			field,
			obj,
			mode,
			nChild,
			type,
			probPSF,
			insideMask,
			flags,
			psfMag_u,psfMag_g,psfMag_r,psfMag_i,psfMag_z,
			psfMagErr_u,psfMagErr_g,psfMagErr_r,psfMagErr_i,psfMagErr_z,
			petroMag_u,petroMag_g,petroMag_r,petroMag_i,petroMag_z,
			petroMagErr_u,petroMagErr_g,petroMagErr_r,petroMagErr_i,petroMagErr_z,
			petroR50_r,
			petroR90_r,
			modelMag_u,modelMag_g,modelMag_r,modelMag_i,modelMag_z,
			modelMagErr_u,modelMagErr_g,modelMagErr_r,modelMagErr_i,modelMagErr_z,
			mRrCc_r,
			mRrCcErr_r,
			lnLStar_r,
			lnLExp_r,
			lnLDeV_r,
			ra,[dec],
			cx,cy,cz,
			extinction_u,extinction_g,extinction_r,extinction_i,extinction_z,
			htmID,
			fieldID,
			SpecObjID,
			( case when mRrCc_r > 0 then SQRT(mRrCc_r/2.0)else 0 end) as size
		FROM PhotoObjAll
		ORDER BY objID
		OPTION (MAXDOP 1)
		EXEC spNewPhase @taskID, @stepID, 'Load PhotoTag', 'OK', 'Loaded PhotoTag table';
	    END
	ELSE
	    BEGIN
		-- for incremental loading, only insert objects not already
		-- in the table, and dont bother to order on objid
		INSERT PhotoTag
		SELECT 	objID,
			skyVersion,
			run,
			rerun,
			camcol,
			field,
			obj,
			mode,
			nChild,
			type,
			probPSF,
			insideMask,
			flags,
			psfMag_u,psfMag_g,psfMag_r,psfMag_i,psfMag_z,
			psfMagErr_u,psfMagErr_g,psfMagErr_r,psfMagErr_i,psfMagErr_z,
			petroMag_u,petroMag_g,petroMag_r,petroMag_i,petroMag_z,
			petroMagErr_u,petroMagErr_g,petroMagErr_r,petroMagErr_i,petroMagErr_z,
			petroR50_r,
			petroR90_r,
			modelMag_u,modelMag_g,modelMag_r,modelMag_i,modelMag_z,
			modelMagErr_u,modelMagErr_g,modelMagErr_r,modelMagErr_i,modelMagErr_z,
			mRrCc_r,
			mRrCcErr_r,
			lnLStar_r,
			lnLExp_r,
			lnLDeV_r,
			ra,[dec],
			cx,cy,cz,
			extinction_u,extinction_g,extinction_r,extinction_i,extinction_z,
			htmID,
			fieldID,
			SpecObjID,
			( case when mRrCc_r > 0 then SQRT(mRrCc_r/2.0)else 0 end) as size
		FROM PhotoObjAll
		WHERE objid NOT IN (SELECT objid FROM PhotoTag)
		OPTION (MAXDOP 1)
		SET @msg = 'Loaded '+cast(@@rowcount as varchar(10))+' rows into the PhotoTag table';
		EXEC spNewPhase @taskID, @stepID, 'Load PhotoTag', 'OK', @msg
	    END
*/
    SET @msg = 'Created PhotoTag index in PhotoObjAll';
    EXEC spNewPhase @taskID, @stepID, 'Load PhotoTag', 'OK', @msg
    RETURN(@ret)
END
GO




--============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spLoadPatches' )
	DROP PROCEDURE spLoadPatches
GO
--
CREATE PROCEDURE spLoadPatches (@taskID INT, @stepID INT)
----------------------------------------------------------------
--/H Run any patches that may have accumulated during the loading
--/H process.
--/A -----------------------------------------------------------
--/T Run the patches recorded in the nextReleasePatches.sql file
--/T in the patches directory.
----------------------------------------------------------------
AS
BEGIN
    DECLARE @ret int, @sqldir varchar(128), @status varchar(32),
	    @msg varchar(2048), @patchFileName varchar(256),
	    @cmd nvarchar(2048);
    EXEC loadsupport.dbo.spSetFinishPhase 'loadPatches'
    SELECT @sqldir=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='sqldir';
    SET @patchFileName = '..\patches\nextReleasePatches.sql';
    SET @cmd = 'DIR '+@sqldir+@patchFileName;
    EXEC @ret = master.dbo.xp_cmdshell @cmd, no_output;
    IF @ret = 0
	BEGIN
	    EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
		'Patches', @sqldir, @patchFileName
    	    IF @ret = 0
		BEGIN
		    SET @status = 'OK';
		    SET @msg = 'Loaded patches since last release';
		END
	    ELSE
		BEGIN
		    SET @status = 'WARNING';
		    SET @msg = 'Problem with loading patches - script '+@sqldir+@patchFileName+' failed.';
		END
	END
    ELSE
	BEGIN
	    SET @status = 'WARNING';
	    SET @msg = 'Problem with loading patches - file '+@sqldir+@patchFileName+' not found.';
	END
 
    -- give phase message telling of success.
    EXEC spNewPhase @taskID, @stepID, 'spLoadPatches', @status, @msg;
    -----------------------------------------------------
    RETURN (@ret);
END
GO


--============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spCreateWeblogDB' )
	DROP PROCEDURE spCreateWeblogDB
GO
--
CREATE PROCEDURE spCreateWeblogDB (@taskID INT, @stepID INT)
----------------------------------------------------------------
--/H Run any patches that may have accumulated during the loading
--/H process.
--/A -----------------------------------------------------------
--/T Run the patches recorded in the nextReleasePatches.sql file
--/T in the patches directory.
----------------------------------------------------------------
AS
BEGIN
    DECLARE @ret int, @sqldir varchar(128), @status varchar(32),
	    @msg varchar(2048), @weblogFileName varchar(256),
	    @cmd nvarchar(2048);
    IF EXISTS (SELECT [name] FROM master.dbo.sysdatabases
		WHERE [name] = N'weblog' )
	BEGIN
	    SET @status = 'OK';
	    SET @msg = 'Weblog DB already exists.';
	END
    ELSE
        BEGIN
	    SELECT @sqldir=value 
		FROM loadsupport..Constants WITH (nolock)
		WHERE name='sqldir';
	    SET @weblogFileName = '..\log\webLogDBCreate.sql';
	    SET @cmd = 'DIR '+@sqldir+@weblogFileName;
	    EXEC @ret = master.dbo.xp_cmdshell @cmd, no_output;
	    IF @ret = 0
		BEGIN
		    EXEC @ret=dbo.spRunSQLScript @taskid, @stepid,
			'Create Weblog DB', @sqldir, @weblogFileName,
			'master', 'C:\temp\weblogDBCreateLog.txt'
	    	    IF @ret = 0
			BEGIN
			    SET @status = 'OK';
			    SET @msg = 'Weblog DB created successfully.';
			END
		    ELSE
			BEGIN
			    SET @status = 'WARNING';
			    SET @msg = 'Problem with creating Weblog DB - script '
					+ @sqldir + @weblogFileName + ' failed.';
			END
		END
	    ELSE
		BEGIN
		    SET @status = 'WARNING';
		    SET @msg = 'Problem with creating Weblog DB - file '+@sqldir+@weblogFileName+' not found.';
		END
	END
 
    -- give phase message telling of success.
    EXEC spNewPhase @taskID, @stepID, 'spCreateWeblogDB', @status, @msg;
    -----------------------------------------------------
    RETURN (@ret);
END
GO


--============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spFinishDropIndices' )
	DROP PROCEDURE spFinishDropIndices
GO
--
CREATE PROCEDURE spFinishDropIndices (@taskID INT, @stepID INT, 
				      @destinationDBname VARCHAR(32), 
				      @incremental tinyint = 1,
				      @msg VARCHAR(2048) OUTPUT)
----------------------------------------------------------------
--/H Drops the F and I indices in the Finish step, and also the
--/H K indices if the FINISH task comment field contains the 
--/H string "DROP_PK_INDICES".
--/A -----------------------------------------------------------
--/T A wrapper with logging to be called by spFinishStep
----------------------------------------------------------------
AS
BEGIN
	DECLARE @ret INT,
		@comment VARCHAR(256)

	SET @ret = 0;
	EXEC loadsupport.dbo.spSetFinishPhase 'dropIndices'
	IF (@incremental = 0)
	    BEGIN
		-- we should drop all the indices to begin with
		EXEC spNewPhase @taskID, @stepID, 'Drop indices', 'OK','Starting to drop all indices';
		--
		EXEC @ret = dbo.spIndexDropSelection @taskid, @stepid, 'F,I,K', 'ALL'
		IF @ret = 0
		    EXEC spNewPhase @taskID, @stepID, 'Drop indices', 'OK', 'Dropped all indices';
	    END
	ELSE
	    BEGIN
		-- we should drop only the F  indices, not K and I
		EXEC spNewPhase @taskID, @stepID, 'Drop FK indices', 'OK','Starting to drop all F indices';
		--
		EXEC @ret = dbo.spIndexDropSelection @taskid, @stepid, 'F', 'ALL'
		IF @ret = 0
		    EXEC spNewPhase @taskID, @stepID, 'Drop FK indices', 'OK', 'Dropped all F indices';
	    END

	IF @ret != 0
	    SET @msg = 'Cannot drop indices in ' + @destinationDBname;
	RETURN @ret;
END
GO


--============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spFinishStep' )
	DROP PROCEDURE spFinishStep
GO
--
CREATE PROCEDURE spFinishStep (@taskid int, @stepID int output,
			       @phaseName varchar(64) = 'ALL', 
			       @execMode varchar(32) = 'resume')
----------------------------------------------------------------------
--/H Finish step, polishes published Photo or Spectro  
--/A 
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T The data has been placed in the destination DB.
--/T Neighbors are computed for the photo data
--/T Best PhotoObjects are computed for sciencPrimary Spectro objects
--/T  	0 on success (no serious problems found)
--/T    1 on failure (serious problems found).
----------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	-------------------
	-- local variables
	-------------------
	DECLARE @msg varchar(2048),
		@status varchar(16), @finishStatus varchar(32),
		@ret	int,
		@fgroups int,
		@err	int,
		@destinationDBname varchar(32), -- name of the destination database.
		@type varchar(16),	-- (target|best|runs|plates|tiles)  
		@comment VARCHAR(256),
		@incremental TINYINT,
		@id varchar(16) 	-- ID of the CSV data export task from the Linux side
	SET  @err = 0;

	-------------------------------------------------
	-- get the necessary parameters from task table
	-------------------------------------------------
	SELECT 	@comment=comment 
		FROM loadsupport.dbo.Task WITH (nolock)
		WHERE taskid = (
		  select max(taskid) from loadsupport.dbo.Task WITH (nolock)
		  where type='FINISH' AND taskstatus='WORKING')
	
	
	IF (@comment = '%CAMPAIGN LOAD%')
	    BEGIN
		IF (@phaseName != N'ALL')
		    BEGIN
			SET  @msg  = 'Step ' + @phaseName + ' invalid, must be ALL for campaign load'
			SET @ret = 1
			GOTO commonExit
		    END
	        SET @incremental = 0
	    END
	ELSE
	    BEGIN
	    	SET @incremental = 1
		-- 
		SELECT @phaseName = name
			FROM loadsupport.dbo.FinishPhase
	    END 
	--
	SELECT  @destinationDBname=dbname,
		@type=type, 
		@id=[id]
		FROM loadsupport.dbo.Task WITH (nolock)
		WHERE taskid = @taskID
	----------------------
	-- register the step.
	----------------------
	IF ( @phaseName = 'ALL' )
	    SET  @msg  = 'Starting FINISH step on ' + UPPER(@type) + ' database ' + @id
	ELSE 
	    BEGIN
		IF (@execMode = 'resume')
	    	    SET  @msg  = 'Resuming FINISH step at phase ' + @phaseName + ' on ' + UPPER(@type) + ' database ' + @id
		ELSE
		    SET  @msg  = 'Executing FINISH step phase ' + @phaseName + ' on ' + UPPER(@type) + ' database ' + @id
	    END
	EXEC spStartStep @taskID, @stepID OUTPUT, 'FINISH', 'WORKING', @msg, @msg;
	----------------------------------------------
	-- if step create fails, complain and return.
	----------------------------------------------
	IF @stepid IS NULL
	    BEGIN
		SET @msg = 'Could not create finish step for task '  
			+ str(@taskID) + ' database ' + @id
	 	EXEC spNewPhase 0, 0, 'Framework Error', 'ERROR', @msg;
		RETURN(1);
	    END
	--------------------------------------------------------
	-- Read in names of any phases to be skipped into temp table
	CREATE TABLE #skipPhases (
	    phase VARCHAR(32) NOT NULL
	)
	IF EXISTS (SELECT [name] FROM sysobjects 
	   WHERE  [name] = N'SkipFinishPhases' and xtype='U')
	    BEGIN
	        INSERT #skipPhases SELECT phase FROM SkipFinishPhases
		SET @msg = 'Skipping phases '
		SELECT @msg = @msg + phase + ' ' FROM #skipPhases
		SET @msg = @msg + 'from FINISH processing.'
	 	EXEC spNewPhase @taskid, @stepid, 'Start FINISH', 'OK', @msg;
	    END
	--------------------------------------------------------------
	-- if a particular step is to be executed, go to it directly
	--------------------------------------------------------------
	IF (@phaseName='ALL')                  GOTO allSteps
	IF (@phaseName='dropIndices')          GOTO dropIndices
	IF (@phaseName='syncSchema')           GOTO syncSchema
	IF (@phaseName='loadPhotoTag')         GOTO loadPhotoTag
	IF (@phaseName='buildPrimaryKeys')     GOTO buildPrimaryKeys
	IF (@phaseName='buildIndices')         GOTO buildIndices
	IF (@phaseName='buildForeignKeys')     GOTO buildForeignKeys
	IF (@phaseName='computeNeighbors')     GOTO computeNeighbors
	IF (@phaseName='regions')              GOTO regions
	IF (@phaseName='syncSpectro')          GOTO syncSpectro
	IF (@phaseName='fixDetectionIndex')     GOTO fixDetectionIndex
	IF (@phaseName='buildFinishIndices')   GOTO buildFinishIndices
	IF (@phaseName='setInsideMask')        GOTO setInsideMask
	IF (@phaseName='loadPatches')          GOTO loadPatches
	IF (@phaseName='createWeblogDB')       GOTO createWeblogDB
	IF (@phaseName='commonExit')           GOTO commonExit
	-- if the phase name doesnt match any of the above, exit with error
	SET @err = 1;
	SET @ret = 1;
	SET @msg = 'Invalid step name specified: ' + @phaseName;
	GOTO commonExit	
	--------------------------------------------------------
	-- do the stuff that needs to be done for start of a full
	-- (all steps) finish run
	allSteps:
	EXEC loadsupport.dbo.spSetFinishPhase 'ALL'
	--------------------------------------------------------
	-- we should drop all the indices to begin with
	dropIndices:
	IF ('dropIndices' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
		EXEC @ret = dbo.spFinishDropIndices @taskid, @stepid, @destinationDBname, @incremental, @msg OUTPUT
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	--------------------------------------------------------
	-- if there are schema changes to be sync-ed with, do it now
	syncSchema:
	IF ('syncSchema' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
	    	EXEC @ret = dbo.spSyncSchema @taskid, @stepid, @destinationDBname
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	--------------------------------------------------------
	-- Apply patches accumulated during the loading
	loadPatches:
	EXEC @ret = dbo.spLoadPatches @taskID, @stepID 
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	------------------------------------------------------
	-- if there are no filegroups except PRIMARY in sysfilegroups,
	-- ensure that FileGroupMap table is empty after schema sync
	SELECT @fgroups=COUNT(*) FROM sysfilegroups
	IF (@fgroups = 1) 
	    EXEC spTruncateFileGroupMap
	--------------------------------------------------------
	-- Create the PhotoTag index in PhotoObjAll
	loadPhotoTag:
	IF ('loadPhotoTag' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
	    	EXEC @ret = dbo.spLoadPhotoTag @taskID, @stepID
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	--------------------------------------------------------
	-- Build the indices on the database
	buildPrimaryKeys:
	SET @msg = 'Starting to build primary keys.'
 	EXEC spNewPhase @taskid, @stepid, 'buildPrimaryKeys', 'OK', @msg;
	EXEC loadsupport.dbo.spSetFinishPhase 'buildPrimaryKeys'
	EXEC @ret = dbo.spIndexBuildSelection @taskID, @stepID, 'K', 'ALL';
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	--------------------------------------------------------
	buildIndices:
	SET @msg = 'Starting to build indices.'
 	EXEC spNewPhase @taskid, @stepid, 'buildIndices', 'OK', @msg;
	EXEC loadsupport.dbo.spSetFinishPhase 'buildIndices'
	EXEC @ret = dbo.spIndexBuildSelection @taskID, @stepID, 'I', 'ALL'
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	--------------------------------------------------------
	buildForeignKeys:
	SET @msg = 'Starting to build foreign keys.'
 	EXEC spNewPhase @taskid, @stepid, 'buildForeignKeys', 'OK', @msg;
	EXEC loadsupport.dbo.spSetFinishPhase 'buildForeignKeys'
	EXEC @ret = dbo.spIndexBuildSelection @taskID, @stepID, 'F', 'ALL'
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	--------------------------------------------------------
	-- Build the neighbors
	computeNeighbors:
	IF ('computeNeighbors' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
	     	SET @msg = 'Starting to compute neighbors.'
			EXEC spNewPhase @taskid, @stepid, 'computeNeighbors', 'OK', @msg;
	   		EXEC loadsupport.dbo.spSetFinishPhase 'computeNeighbors'
			-- Call to spNeighbors commented out as a precaution
			-- EXEC @ret = dbo.spNeighbors @taskID, @stepID, @type, @destinationDBname, 30.0, 1
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	---------------------------------------------------------
	-- Do the Regions 
	regions:
	IF ('regions' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
	     	SET @msg = 'Starting to compute regions.'
		EXEC spNewPhase @taskid, @stepid, 'regions', 'OK', @msg;
	    	EXEC loadsupport.dbo.spSetFinishPhase 'regions'
	    	EXEC @ret = dbo.spSdssPolygonRegions @taskID, @stepID
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	---------------------------------------------------------
	-- Handle the spectro part, only if BEST-PUB
	syncSpectro:
	IF ('syncSpectro' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
	     	SET @msg = 'Starting to synchronize spectro and photo.'
		EXEC spNewPhase @taskid, @stepid, 'syncSpectro', 'OK', @msg;
		EXEC @ret = dbo.spSynchronize @taskID, @stepID
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	---------------------------------------------------------
	-- Fix detectioIndex table, only if BEST-PUB
	fixDetectionIndex:
	IF ('fixDetectionIndex' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
	     	SET @msg = 'Starting to fix detectionIndex.'
		EXEC spNewPhase @taskid, @stepid, 'detectionIndex', 'OK', @msg;
		EXEC @ret = dbo.spFixDetectionIndex @taskID, @stepID, 'detectionIndex'
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	------------------------------------------------------
	-- Build the FINISH group indices in each category
	buildFinishIndices:
	SET @msg = 'Starting to build FINISH indices.'
 	EXEC spNewPhase @taskid, @stepid, 'buildFinishIndices', 'OK', @msg;
	EXEC loadsupport.dbo.spSetFinishPhase 'buildFinishIndices'
	EXEC @ret = dbo.spIndexBuildSelection @taskID, @stepID, 'K,I,F', 'FINISH' 
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	------------------------------------------------------
	-- Fill the MaskedObject table and set PhotoObj.insideMask
	setInsideMask:
	IF ('setInsideMask' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
	    	SET @msg = 'Starting to set InsideMask.'
 		EXEC spNewPhase @taskid, @stepid, 'setInsideMask', 'OK', @msg;
	    	EXEC loadsupport.dbo.spSetFinishPhase 'setInsideMask'
	  	EXEC @ret = dbo.spFillMaskedObject @taskID, @stepID
		IF (@ret = 0)
		    EXEC @ret = dbo.spSetInsideMask @taskID, @stepID, 1 
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	------------------------------------------------------
	-- Create Weblog DB if necessary.
	createWeblogDB:
	IF ('createWeblogDB' NOT IN (SELECT phase FROM #skipPhases))
	    BEGIN
	    	EXEC loadsupport.dbo.spSetFinishPhase 'createWeblogDB'
		EXEC @ret = dbo.spCreateWeblogDB @taskID, @stepID 
	    END
	IF (@ret != 0) OR (@execMode != 'resume') GOTO commonExit
	------------------------------------------------------
	commonExit:
	----------------------------------------------------
	-- create final logs 
	EXEC loadsupport.dbo.spSetFinishPhase 'commonExit'
	IF  @execMode = 'resume'
	    BEGIN
		IF @err = 0
	    	    BEGIN

			-- Update the statistics on all the tables
			EXEC dbo.spUpdateStatistics
			EXEC spNewPhase @taskID, @stepID, 
				'Statistics', 
				'WARNING', 
				'Updated the statistics on all tables' 
			----------------------------------------------------

			SET @status = 'DONE'
			EXEC loadsupport.dbo.spSetFinishPhase 'ALL'
			SET @msg =  'Completed finish of ' + @id;
		    END
		ELSE
		    BEGIN
	    	    	SET @status = 'ABORTING'
		    END
		EXEC spEndStep @taskID, @stepID, @status, @msg, @msg;
		EXEC loadsupport.dbo.spDone @taskid;
	    END
	---------------------------------------------------
	RETURN @ret;
END
GO

PRINT '[spFinish.sql]: spFinish procedures created'
GO
