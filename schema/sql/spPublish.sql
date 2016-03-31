--================================================================================
--   spPublish.sql
--   2002-11-07   Jim Gray
----------------------------------------------------------------------------------
-- Publish the contents of a database into another
-- 	pulls data from a verified database and inserts it into this database, 
-- 	The premise is that the data has been validated and is ready to publish.
----------------------------------------------------------------------------------
-- History:
--* 2002-11-08 Jim: added INIT clause to backup
--* 2002-11-10 Jim: commented out detach,
--*		reserved DONE status for the end of the step.
--*		added spPublishTiling,
--*		changed spPublish to spPublishStep,
--*		add insert to load history
--* 2002-11-13 Jim: fixed transaction scope bug in CopyTable
--* 2002-11-14 Jim: added to spPublishPhoto Mask,MosaicLayout,Mosaic,ObjMask,
--*		Target,TargetInfo. 
--*		Added to spPublishPlate Best2Sector, HoleObj, Sector, Sector2Tile,Target2Sector
--*  		Added to spPublishTiling TargetParam, TiBound2tsChunk, Tile, TileBoundary,
--*	  	TiledTarget, TileInfo, TileNotes (commented out right now for IDENTITY problem)
--*	 	TileRegion, TilingPlan.
--* 2002-11-30 Alex: added spReorg 
--* 2002-12-28 Alex: added publish log into PubHistory
--* 2003-01-27 Ani: Made changes to tiling schema as per PR# 4702
--*		renamed TileRegion to TilingRegion
--*		renamed TileInfo to TilingInfo
--*		renamed TileNotes to TilingNotes
--*		renamed TileBoundary to TilingGeometry
--* 2003-05-15 Alex: changed PhotoObj to PhotoObjAll
--* 2003-06-03 Alex: Changed @@rowcount to rowcount_big()
--* 2003-08-14 Ani: Fixed tablenames in spPublishTiling as per PR #5561.
--* 2003-08-15 Ani: Made @fromDB, @toDB in spPublishStep to varchar(100)
--*             as per PR #5564.
--* 2003-09-22 Ani: Moved publish of TilingRun table to the top so that
--*             foreign-key constraints for other tiling tables would
--*             not be an issue (PR #5675).
--* 2004-08-31 Alex: Moved here spBackupStep and spCleanupStep
--* 2004-11-11 Alex: repointed spNewPhase, spStartStep and spEndStep to local wrappers
--* 2005-12-13  Ani: Commented out Photoz table, not loaded any more.
--* 2007-12-11  Svetlana: added comments in spPublishStep do not rebuild the filenames before attaching the db.
--* 2008-06-16  Ani: Added PsObjAll to spPublishPhoto.
--* 2009-08-12  Ani: SDSS-III changes: Deleted PsObjAll, USNO, Rosat, added Run to spPublishPhoto.  Renamed
--*             tiling table names in spPublishTiling, and added spPublishWindow to publish window task dbs.
--* 2009-08-31  Victor: Added spPublishSspp to publish window task dbs.
--* 2009-10-30  Ani: Added call to spPublishSspp iin spPublishStep, and
--*             corrected sspp table names in spPublishSspp.
--* 2009-12-31  Ani: Added spPublishGalSpec for galspec export.
--* 2010-01-14  Ani: Replaced ObjMask with AtlasOutline.
--* 2010-01-16  Ani: Removed publishing of Segment table.
--* 2010-06-29  Ani/Naren/Vamsi: Added External Catalog Tables to spPublishPhoto.
--* 2010-07-14  Ani: Fixed names for TwoMASS and TwoMASSXSC (from 2MASS, 2MASSXSC).
--* 2010-11-23  Ani: Added spPublishPm and spPublishResolve.
--* 2010-12-08  Ani: Added sdssTargetParam to spPublishTiling, and
--*             added Plate2Target, segueTargetAll to spPublishSspp.
--* 2012-05-18  Ani: Removed all tables from spPublishPlates except for
--*             PlateX and SpecObjAll.
--* 2012-05-31  Ani: Added galaxy product tables to spPublishPlates.
--* 2012-06-19  Ani: Updated galaxy product table names in spPublishPlates.
--* 2013-03-25  Ani: Added spPublishApogee.
--* 2013-05-03  Ani: Added spPublishGalProd, moved galprod tables to new
--*             SP from spPublishPlates and updated table names.
--* 2013-05-20  Ani: Added spPublishWise.
--* 2013-05-22  Ani: Added aspcapStarCovar to spPublishApogee.
--* 2013-07-04  Ani: Added apogeeObject, apogeeField and apogeeDesign to
--*             spPublishApogee.
--* 2013-07-09 Ani: Added apogeeStarVisit and apogeeStarAllVisit.
--* 2016-03-03 Ani: Added spPublishMask.
--^ 2016-03-22 Ani: Added wiseForced in spPublishWise, and added type 
--*                "forced" in  spPublish.
--* 2016-03-25 Ani: Fixed typo in spPublishStep, changed duplicate
--*                "sspp" case to "resolve".
--* 2016-03-29 Ani: Added spPublishManga.
----------------------------------------------------------------------
-- We are not copying 
-- DBcolumns, DBObjects, DBViewCols, DataConstants, Globe,Glossary, 
-- History, PhotoSpec, SDSSconstants, SiteConstants, SiteDiagnostics
-- LoadHistory, PubHistory
--=====================================================




--========================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spBackupStep' )
	DROP PROCEDURE spBackupStep
GO
--
CREATE PROCEDURE spBackupStep (@taskid int, @stepID int output) 
----------------------------------------------------------------------
--/H Backup step, shrinks, backs-up, and then detaches the database
--/A 
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T The data is in the local DB.
--/T Most of the step parameters are extracted from the task table (see code)
--/T It is a task.type dataload (type in (target|best|runs|plates|tiling))
--/T The backup step writes  messages in the Phase table.
--/T It returns stepid and either:
--/T  	0 on success (no serious problems found)
--/T    1 on failure (serious problems found).
----------------------------------------------------------------------
AS
BEGIN
	---------------------------------------------------------------------------------------------
 	-- parameters from task table
	DECLARE 
		@type varchar(16),	-- (target|best|runs|plates|tiling)  
		@id varchar(16), 	-- ID of the CSV data export task from the Linux side
		@BackupFileName varchar(256) --  File to hold back of this database
	-- Get the task parameters.  
	SELECT  
		@type=type, 
		@id=[id], 
		@BackupFileName = backupfilename
		FROM loadsupport.dbo.Task WITH (nolock)
		WHERE taskid = @taskID

	IF @BackupFileName IS NULL
		RETURN(0);
	---------------------------------------------------------------------------------------------
	-- local variables
	DECLARE @stepName varchar(16),
		@DBname varchar (100),
		@msg varchar(2048),
		@status varchar(32),
		@cmd varchar(2000),
		@err int,		 -- return from the helper procs (0 is good, 1 is fatal)
		@ret int

	SET @err = 0;

	-- register the step.
	SET @stepName = 'BACKUP'  
	SET @msg = 'Backing up ' + @type + ' database ' + @id + ' to ' + @BackupFileName
	EXEC spStartStep @taskID, @stepID OUTPUT, @stepName, 'WORKING', @msg, @msg;

	-- if step create fails, complain and return.
	IF @stepid IS NULL
	    BEGIN
		SET @msg = 'Could not create backup step for task '  
			+ str(@taskID) + ' database ' + @id
	 	EXEC spNewPhase 0, 0, 'Framework Error', 'ERROR', @msg;
		RETURN(1);
	    END
 
	------------------------------------------------------
	-- Checkpoint will shrink the log.
	CHECKPOINT
	EXEC spNewPhase @taskid, @stepid, 'Checkpoint', 'OK', 'Checkpoint done';
	------------------------------------------------------
	-- shrink will reclaim any space (and truncate the log)
	--- REALLY OUGHT TO DO A SHRINKFILE... but I am too lazy.
	set @DBname = db_name()
	DBCC SHRINKDATABASE (@DBname )
	EXEC spNewPhase @taskid, @stepid, 'ShrinkDB', 'OK', 'Shrink DB done';
	------------------------------------------------------
	-- second checkpoint just for good measure.
	CHECKPOINT
	EXEC spNewPhase @taskid, @stepid, 'Checkpoint', 'OK', 'Checkpoint done';
	------------------------------------------------------
	-- Backup Database
	BACKUP DATABASE @DBname to DISK = @BackupFileName WITH INIT
	IF @@error>0 SET @err = 1;

	-- verify that file exists
	SET @cmd = 'DIR '+@BackupFileName;
	EXEC @ret = master.dbo.xp_cmdshell @cmd, no_output;
	SET @err = @err + @ret;

	IF @err>0
	    BEGIN
		SET @msg = 'Backup of ' + @DBname 
			+ ' to file ' + @BackupFileName+ ' failed'
		EXEC spNewPhase @taskid, @stepid, 'Create backup', 'WARNING', @msg;

		-- set Task backupfilename to empty string
		UPDATE loadsupport.dbo.Task
		     SET backupfilename=''
		WHERE taskid=@taskid
	    END
	ELSE
	    BEGIN
		SET @msg = 'Backed up Database ' + @DBname 
			+ ' done' + ' to file ' + @BackupFileName;
		EXEC spNewPhase @taskid, @stepid, 'Backup', 'OK', @msg;
	    END
	------------------------------------------------------
	-- create final logs (writes to phase table, and step table)
	IF @err = 0
	    BEGIN
	    	EXEC spEndStep @taskID, @stepID, 'DONE', @msg, @msg;
	    END
    	ELSE
	    BEGIN
    		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
	    END
    RETURN @err
END

--===========================================================
GO
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spCleanupStep' )
	DROP PROCEDURE spCleanupStep
GO


CREATE PROCEDURE spCleanupStep (@taskid int, @stepID int OUTPUT) 
----------------------------------------------------------------------
--/H Cleanup step, deletes the database
--/A 
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T The data is in the local DB.
--/T Most of the step parameters are extracted from the task table (see code)
--/T It is a task.type dataload (type in (target|best|runs|plates|tiling))
--/T The backup step writes  messages in the Phase table.
--/T It returns stepid and either:
--/T  	0 on success (no serious problems found)
--/T    1 on failure (serious problems found).
----------------------------------------------------------------------
AS
BEGIN
    ---------------------------------------------------------------------------------------------
    DECLARE @dbname varchar(64)
    --
    SELECT @dbname=dbname 
	FROM loadsupport.dbo.Task WITH (nolock)
	WHERE taskid = @taskID
    ---------------------------------------------------------------------------------------------
    -- local variables
    DECLARE
	@cmd varchar(1024),
	@ret	int	
    ------------------------------------------------------
    SET  @cmd = 'DROP DATABASE '+@dbname;
    EXEC @ret = sp_executesql @cmd;
    --
    RETURN(@ret);
END
--===========================================================
GO


--========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spShrinkDB]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spShrinkDB]
GO
--
CREATE PROCEDURE spShrinkDB
----------------------------------------------------
--/H RShrinks each of the database files to minimum size
--/A
--/T  Jim Gray, Oct 2004
--/T Largely copied from the DBCC books online
--------------------------------------------------------------------------
AS BEGIN 
    SET NOCOUNT ON;
    DECLARE
	@fileName nvarchar(1000), 
	@cmd nvarchar(1000);
    --
    DECLARE fileCursor cursor for select  Name from sysfiles
    OPEN fileCursor
    WHILE (1=1)
      BEGIN
	FETCH fileCursor INTO @fileName
	IF (@@Fetch_Status <> 0) BREAK
	SET @cmd = 'DBCC SHRINKFILE ( N''' + rtrim(@fileName) 
		+ ''' , 1)  WITH  NO_INFOMSGS '
	EXECUTE (@cmd)
	PRINT @cmd
      END
    CLOSE fileCursor
    DEALLOCATE fileCursor 
END
GO


--========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spReorg]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spReorg]
GO
--
CREATE PROCEDURE spReorg
----------------------------------------------------
--/H Reorganize and defragment database tables
--/A
--/T  Jim Gray, Nov 2002
--/T Largely copied from the DBCC books online
--/T Reorganize a database, reclustering tables and indices.
--/T Fist collect a list of statistics about each table and index
--/T then reindex anything with more than 30% extent fragmentation
--/T Largely copied from the DBCC books online
--------------------------------------------------------------------------
AS BEGIN 
	-- Declare variables
	SET NOCOUNT ON
	DECLARE @tablename VARCHAR (128)
	DECLARE @indexname VARCHAR (128)
	DECLARE @objectid  BIGINT		-- Object Identifier from catalog
	DECLARE @execstr   VARCHAR(256)		-- DBCC execution string
	DECLARE @indexId   BIGINT		-- index ID
	DECLARE @maxFrag   INT			-- max fragmentation to allow
	DECLARE @minDensity INT
	DECLARE @frag      INT			-- actual fragmentation of an object
	DECLARE @density   INT			-- Scan density (extents vs switches)

	-- Decide on the maximum fragmentation to allow
	SET @maxfrag 	= 20 		-- 20%	-- out of order pages
	SET @minDensity = 90		-- 90%	-- in order extents
 
	-- Declare cursor fir all our base tables (user tables only)
	DECLARE tables CURSOR FOR
	   SELECT TABLE_NAME
	   FROM INFORMATION_SCHEMA.TABLES
	   WHERE TABLE_TYPE = 'BASE TABLE'

	-- Create the table
	CREATE TABLE #fraglist (
	   ObjectName CHAR (255),
	   ObjectId INT,
	   IndexName CHAR (255),
	   IndexId INT,
	   Lvl 	INT,
	   CountPages INT,	-- often null
	   CountRows INT,	-- often null
	   MinRecSize INT,	-- often null
	   MaxRecSize INT,	-- often null
	   AvgRecSize INT,	-- often null
	   ForRecCount INT,	-- often null
	   Extents INT,		-- often 0  
	   ExtentSwitches INT,	-- sometimes zero, sometimes big
	   AvgFreeBytes INT,	-- often null
	   AvgPageDensity INT,	-- often null
	   ScanDensity DECIMAL, -- we want this to be 100%
			-- this is the ratio of extent switches to extents
	   BestCount INT,	-- often null
	   ActualCount INT,	-- not sure what this is
	   LogicalFrag DECIMAL,	-- we want this to be zero
	   ExtentFrag DECIMAL)	-- often null

/*
Statistic Description  from books online
Pages Scanned 		Number of pages in the table or index. 
Extents Scanned 	Number of extents in the table or index. 
Extent Switches 	Number of times the DBCC statement moved from 
			one extent to another while it traversed the pages 
			of the table or index. 
Avg. Pages per Extent 	Number of pages per extent in the page chain. 
Scan Density 		[Best Count: Actual Count] 
			Best count is the ideal number of extent changes 
			if everything is contiguously linked. 
			Actual count is the actual number of extent changes. 
			The number in scan density is 100 if everything is contiguous; 
			if it is less than 100, some fragmentation exists. 
			Scan density is a percentage. 
Logical Scan Fragmentation Percentage of out-of-order pages returned from scanning 
			the leaf pages of an index. This number is not relevant to 
			heaps and text indexes. An out of order page is one for which the
			next page indicated in an IAM is a different page than the page 
			pointed to by the next page pointer in the leaf page. 
Extent Scan Fragmentation Percentage of out-of-order extents in scanning the leaf pages 
			of an index. This number is not relevant to heaps. An out-of-order 
			extent is one for which the extent containing the current page 
			for an index is not physically the next extent after the extent 
			containing the previous page for an index. 
Avg. Bytes free per page Average number of free bytes on the pages scanned. The higher the number, 
			the less full the pages are. Lower numbers are better. This number is 
			also affected by row size; a large row size can result in a higher number. 
Avg. Page density (full) Average page density (as a percentage). This value takes into account row size, 
			so it is a more accurate indication of how full your pages are. The higher 
			the percentage, the better. 
*/

	-- Open the cursor
	OPEN tables

	-- For each user table in the database
	FETCH NEXT
	   FROM tables
	   INTO @tablename

	WHILE @@FETCH_STATUS = 0
	BEGIN
	   -- Do the showcontig of all indexes of the table, this populates the #fraglist table
	   INSERT INTO #fraglist 
	   EXEC ('DBCC SHOWCONTIG (''' + @tablename + ''') 
	      WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS')
	   FETCH NEXT
	      FROM tables
 	     INTO @tablename
	END

	-- Close and deallocate the cursor
	CLOSE tables
	DEALLOCATE tables
 
	--=========================================================
	-- use the #fraglist table to drive reorg.
	--

	-- Declare cursor for list of indexes to be defragged
	DECLARE indexes CURSOR FOR
	   SELECT rtrim(ObjectName), rtrim(IndexName), ObjectId, IndexId, LogicalFrag, ScanDensity
	   FROM #fraglist
	   WHERE (LogicalFrag >=  @maxfrag  or scandensity < @minDensity) 
	     AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0
	     AND countPages > 1
  
	-- Open the cursor
	OPEN indexes
 
	-- For each index that needs to be defragged.
 
	--- The LOOP (breaks when fetch fails)
	WHILE (1 = 1)
	BEGIN
	   FETCH NEXT
	   	FROM indexes
	   	INTO @tablename, @IndexName, @objectid, @indexid, @frag, @density
	   IF (@@FETCH_STATUS != 0) BREAK
	   PRINT 'Executing DBCC INDEXDEFRAG (0, ' + RTRIM(@tablename) + ','
	  	+ RTRIM(@indexid) + ') - (== ' + @tablename + '.' +  @indexname 
		+ ' ) fragmentation was ' + RTRIM(@frag) + '%'
		+ ' density was ' + RTRIM(@density) + '%'
	   SELECT @execstr = 'DBCC INDEXDEFRAG (0, ' + RTRIM(@objectid) + ','
	         + RTRIM(@indexid) + ') WITH NO_INFOMSGS '
	   -- DO IT!
	   EXEC (@execstr)
	END

	-- Close and deallocate the cursor
	CLOSE indexes
	DEALLOCATE indexes

	-- Delete the temporary table
	DROP TABLE #fraglist
END
GO




---  Comment the following line when you when you want to use the FirstTime flag = 1
--- SQL cannot create tables in remote databases (I have reported this bug).
--- So the firstTime flag == 1 does not work with host names.
--  set @toDB = /*  @publishHost  + '.' + */  @publishDB  
--
--=============================================================
-- copy a table from one DB to another.


--======================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spCopyATable' AND  type = 'P')
    DROP PROCEDURE spCopyATable
GO
--
CREATE PROCEDURE spCopyATable(
	@taskid int, 
	@stepID int, 
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@table varchar(100), 
	@firstTime int)
--------------------------------------------------------------
--/H Copies a table from one db to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br><samp> exec spCopyATable 1,1,'SkyServerV4', 'tempDB', 1 </samp>
--------------------------------------------------------------
AS BEGIN
    --
    SET NOCOUNT ON
    --
    DECLARE @statement varchar(1000),
	@rows bigint,
	@message varchar(1000)

	IF (@firstTime = 1) 
	    begin 
		set @statement = 'select * into ' + @toDB   + '.dbo.' + @table 
                                      + ' from ' + @fromDB + '.dbo.' + @table 
	    end 
	ELSE 
	    begin 
		set @statement =  'insert into     ' + @toDB   + '.dbo.' + @table 
                                + ' with (tablock) select * from ' + @fromDB + '.dbo.' + @table 
	    end 

	--print @statement
	BEGIN TRANSACTION
	    --
	    EXEC (@statement) 
	    SET @rows = rowcount_big();
	    --
	    INSERT PubHistory
		VALUES(@table,@rows,current_timestamp,@taskid)
	    --
	COMMIT TRANSACTION
	SET @message = ' published ' + cast(@rows as varchar) 
		+ ' rows of table ' + @fromDB + '.dbo.' + @table 
		+ ' to table ' + @toDB   + '.dbo.' + @table 
	EXEC spNewPhase @taskID, @stepID, 'TableCopy', 'OK', @message;
        RETURN(0);
END 
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishPhoto' AND  type = 'P')
    DROP PROCEDURE spPublishPhoto
GO
--
CREATE PROCEDURE spPublishPhoto(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the Photo tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishPhoto 1,1,'SkyServerV4','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Starting spPublishPhoto';
	exec spNewPhase @taskID, @stepID, 'spPublishPhoto', 'OK', @message;

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Run', @firstTime 
	set @summary = @summary + @err 

--	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Segment', @firstTime 
--	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Field', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Frame', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'FieldProfile', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'PhotoObjAll', @firstTime 
	set @summary = @summary + @err 

--	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'PsObjAll', @firstTime 
--	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'PhotoProfile', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Neighbors', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'PhotoZ', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'FIRST', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'ROSAT', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'USNO', @firstTime 
	set @summary = @summary + @err 
	
	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'TwoMASS', @firstTime 
	set @summary = @summary + @err 
	
	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'TwoMASSXSC', @firstTime 
	set @summary = @summary + @err 
	
	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'RC3', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Mask', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'AtlasOutline', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Target', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'TargetInfo', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'TargetParam', @firstTime 
	set @summary = @summary + @err 

	--------------------------------------------------
	set @message = 'Publish of database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if  @summary = 0 set @status = 'OK' else set @status = 'ABORTING' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishPhoto', @status, 'Published Photo Tables';
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishMask' AND  type = 'P')
    DROP PROCEDURE spPublishMask
GO
--
CREATE PROCEDURE spPublishMask(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the Mask tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishMask 1,1,'SkyServerV4','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Starting spPublishMask';
	exec spNewPhase @taskID, @stepID, 'spPublishMask', 'OK', @message;

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Mask', @firstTime 
	set @summary = @summary + @err 

	--------------------------------------------------
	set @message = 'Publish of database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if  @summary = 0 set @status = 'OK' else set @status = 'ABORTING' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishMask', @status, 'Published Mask Tables';
	--
	return @summary
END   -- END spPublishMask
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishMask' AND  type = 'P')
    DROP PROCEDURE spPublishManga
GO
--
CREATE PROCEDURE spPublishManga(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the MaNGA tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishManga 1,1,'SkyServerV4','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Starting spPublishManga';
	exec spNewPhase @taskID, @stepID, 'spPublishManga', 'OK', @message;

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'mangaDrpAll', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'mangaTarget', @firstTime 
	set @summary = @summary + @err 

	--------------------------------------------------
	set @message = 'Publish of database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if  @summary = 0 set @status = 'OK' else set @status = 'ABORTING' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishManga', @status, 'Published MaNGA Tables';
	--
	return @summary
END   -- END spPublishManga
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishPlates' AND  type = 'P')
    DROP PROCEDURE spPublishPlates
GO
--
CREATE PROCEDURE spPublishPlates(
	@taskID int,
	@stepID int, 
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the Plates tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.plates)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br><samp> spPublishPlates 1,1,'SkyServerV4','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN 
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 

	set @summary = 0 
	SET @message = 'publishing plates started for ' + @fromDB 
	exec spNewPhase @taskID, @stepID, 'spPublishPlates', 'STARTING', @message;

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'plateX', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'specObjAll', @firstTime 
	set @summary = @summary + @err 

	--------------------------------------------------------------
	set @message = 'Publish of database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'ABORTING' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishPlates', @status, 'Published Spectro Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishGalProd' AND  type = 'P')
    DROP PROCEDURE spPublishGalProd
GO
--
CREATE PROCEDURE spPublishGalProd(
	@taskID int,
	@stepID int, 
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the GalProd tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.plates)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br><samp> spPublishGalProd 1,1,'SkyServerV4','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN 
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 

	set @summary = 0 
	SET @message = 'publishing plates started for ' + @fromDB 
	exec spNewPhase @taskID, @stepID, 'spPublishGalProd', 'STARTING', @message;


	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'emissionLinesPort', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'stellarMassFSPSGranEarlyDust', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'stellarMassFSPSGranEarlyNoDust', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'stellarMassFSPSGranWideDust', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'stellarMassFSPSGranWideNoDust', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'stellarMassPCAWiscBC03', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'stellarMassPCAWiscM11', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'stellarMassStarformingPort', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'stellarMassPassivePort', @firstTime 
	set @summary = @summary + @err 

	--------------------------------------------------------------
	set @message = 'Publish of database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'ABORTING' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishGalProd', @status, 'Published Spectro Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishTiling' AND  type = 'P')
    DROP PROCEDURE spPublishTiling
GO
--
CREATE PROCEDURE spPublishTiling(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the Tiling tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishTiling 1,1,'SkyServerV4','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Publishing Tiling Database started for database ' + @fromDB

	exec spNewPhase @taskID, @stepID, 'spPublishTiling', 'STARTING', @message 

-- NOTE: TilingRun has to be published first because of foreign key constraint.
	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssTilingRun', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssTileAll', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssTilingGeometry', @firstTime 
	set @summary = @summary + @err

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssTiledTargetAll', @firstTime 
	set @summary = @summary + @err  

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssTilingInfo', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssTargetParam', @firstTime 
	set @summary = @summary + @err 

	---------------------------------------------------------
	set @message = 'Publish of tile database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'FAILED' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishTiling', @status, 'Published Tile Tables' 
	--
	return @summary
END
GO

--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishWindow' AND  type = 'P')
    DROP PROCEDURE spPublishWindow
GO
--
CREATE PROCEDURE spPublishWindow(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the Window Function tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishWindow 1,1,'BestDR7','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Publishing Window Function Database started for database ' + @fromDB

	exec spNewPhase @taskID, @stepID, 'spPublishWindow', 'STARTING', @message 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssImagingHalfSpaces', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssPolygons', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sdssPolygon2Field', @firstTime 
	set @summary = @summary + @err

	---------------------------------------------------------
	set @message = 'Publish of Window Function database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'FAILED' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishWindow', @status, 'Published Window Function Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishGalSpec' AND  type = 'P')
    DROP PROCEDURE spPublishGalSpec
GO
--
CREATE PROCEDURE spPublishGalSpec(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the galspec tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishGalSpec 1,1,'BestDR7','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Publishing GalSpec database started for database ' + @fromDB

	exec spNewPhase @taskID, @stepID, 'spPublishGalSpec', 'STARTING', @message 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'galSpecExtra', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'galSpecIndx', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'galSpecInfo', @firstTime 
	set @summary = @summary + @err

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'galSpecLine', @firstTime 
	set @summary = @summary + @err

	---------------------------------------------------------
	set @message = 'Publish of GalSpec database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'FAILED' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishGalSpec', @status, 'Published GalSpec Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishSspp' AND  type = 'P')
    DROP PROCEDURE spPublishSspp
GO
--
CREATE PROCEDURE spPublishSspp(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the sspp Function tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishSspp 1,1,'BestDR7','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Publishing sspp database started for database ' + @fromDB

	exec spNewPhase @taskID, @stepID, 'spPublishSspp', 'STARTING', @message 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'Plate2Target', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sppLines', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sppParams', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'sppTargets', @firstTime 
	set @summary = @summary + @err

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'segueTargetAll', @firstTime 
	set @summary = @summary + @err

	---------------------------------------------------------
	set @message = 'Publish of sspp database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'FAILED' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishSspp', @status, 'Published sspp Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishPm' AND  type = 'P')
    DROP PROCEDURE spPublishPm
GO
--
CREATE PROCEDURE spPublishPm(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the proper motion tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishPm 1,1,'BestDR7','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Publishing pm database started for database ' + @fromDB

	exec spNewPhase @taskID, @stepID, 'spPublishPm', 'STARTING', @message 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'properMotions', @firstTime 
	set @summary = @summary + @err

	---------------------------------------------------------
	set @message = 'Publish of pm database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'FAILED' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishPm', @status, 'Published pm Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishResolve' AND  type = 'P')
    DROP PROCEDURE spPublishResolve
GO
--
CREATE PROCEDURE spPublishResolve(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the resolve tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishResolve 1,1,'BestDR7','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Publishing resolve database started for database ' + @fromDB

	exec spNewPhase @taskID, @stepID, 'spPublishResolve', 'STARTING', @message 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'thingIndex', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'detectionIndex', @firstTime 
	set @summary = @summary + @err

	---------------------------------------------------------
	set @message = 'Publish of resolve database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'FAILED' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishResolve', @status, 'Published resolve Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishApogee' AND  type = 'P')
    DROP PROCEDURE spPublishApogee
GO
--
CREATE PROCEDURE spPublishApogee(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the APOGEE tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishApogee 1,1,'BestDR7','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Publishing APOGEE database started for database ' + @fromDB

	exec spNewPhase @taskID, @stepID, 'spPublishApogee', 'STARTING', @message 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'apogeeVisit', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'apogeeStar', @firstTime 
	set @summary = @summary + @err

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'aspcapStar', @firstTime 
	set @summary = @summary + @err

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'apogeePlate', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'aspcapStarCovar', @firstTime 
	set @summary = @summary + @err

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'apogeeDesign', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'apogeeField', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'apogeeObject', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'apogeeStarVisit', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'apogeeStarAllVisit', @firstTime 
	set @summary = @summary + @err 

	---------------------------------------------------------
	set @message = 'Publish of APOGEE database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'FAILED' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishApogee', @status, 'Published APOGEE Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
    WHERE  name = N'spPublishWise' AND  type = 'P')
    DROP PROCEDURE spPublishWise
GO
--
CREATE PROCEDURE spPublishWise(
	@taskID int, 
	@stepID int,
	@fromDB varchar(100), 
	@toDB varchar(100), 
	@firstTime int) 
---------------------------------------------------------------
--/H Publishes the WISE tables of one DB to another 
--/A
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)
--/T <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)
--/T <li> firstTime int 		-- if 1, creates target table.
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp> spPublishWise 1,1,'BestDR8','tempDB', 1 </samp>
---------------------------------------------------------------
AS BEGIN
	set nocount on
	declare @err int, @summary int 
	declare @message varchar(1000) 
	declare @status  varchar(16) 
	set @summary = 0 

	set @message = 'Publishing WISE database started for database ' + @fromDB

	exec spNewPhase @taskID, @stepID, 'spPublishWise', 'STARTING', @message 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'WISE_xmatch', @firstTime 
	set @summary = @summary + @err 

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'WISE_allsky', @firstTime 
	set @summary = @summary + @err

	exec @err = spCopyATable @taskid, @stepID, @fromDB, @toDB, 'wiseForced', @firstTime 
	set @summary = @summary + @err

	---------------------------------------------------------
	set @message = 'Publish of WISE database ' + @fromDB + ' to database ' + @toDB + ' found ' + str(@summary) + ' errors.' 
	if @summary = 0 set @status = 'OK' else set @status = 'FAILED' 
	--
	exec spNewPhase @taskID, @stepID, 'spPublishWise', @status, 'Published APOGEE Tables' 
	--
	return @summary
END
GO


--=============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
    WHERE  [name] = N'spPublishStep' ) 
    DROP PROCEDURE spPublishStep
GO
--
CREATE PROCEDURE spPublishStep (@taskid int) 
---------------------------------------------------------------------- 
--/H Publish step, publishes validated Photo or Spectro data  
--/A
--/T <li> taskid int,                   -- Task identifier 
--/T The data has been imported to a DB, verified and backed up  
--/T This task attaches the database, and then pulls its data into the local database.
--/T Most of the step parameters are extracted from the task table (see code) 
--/T Data is copied to the "local" database tables 
--/T It is a task.type dataload (type in (target|best|runs|plates|tiling)) 
--/T The publish step writes many messages in the Phase table. 
--/T It returns either: 
--/T    0 on success (no serious problems found) 
--/T    1 on failure (serious problems found). 
--/T <br><samp> spPublish @taskId </samp>
---------------------------------------------------------------------- 
AS 
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE 
        @hostname varchar(32),  -- name of this node 
        @DBname varchar(32),    -- name of the validation database.
	@publishtaskID int,
        @publishHost varchar(100), 
        @publishDB varchar(100),
	@datafilename varchar(128),
	@logfilename varchar(128),
	@id varchar(64),
        @type varchar(16)      -- (target|best|runs|plates|tiling)  
    --------------------------------------------------------------------------------------------- 
    -- Get the task parameters.  
    SELECT  
	@hostname=hostname,
	@DBname=dbname,
	@publishtaskID=publishtaskid, 
	@publishHost = rtrim(publishHost), 
	@publishDB = rtrim(publishDB),
	@datafilename = rtrim(datafilename),
	@logfilename = rtrim(logfilename),
	@id = [id],
        @type=type
        FROM loadsupport.dbo.Task WITH (NOLOCK) 
        WHERE taskid = @taskID
    ---------------------------------------------------------
    -- local variables 
    DECLARE 
	@stepid int,		-- 
	@publishstepID int, 
        @stepMsg varchar(2048), -- holds messages to Step table 
        @phaseMsg varchar(2048), -- holds messages to Phase table 
	@fromDB varchar(100),
	@toDB varchar(100),
	@firstTime int,			-- flag says this is the first time so create tables.
	@publishStart datetime,
        @err int                -- return from the helper procs (0 is good, 1 is fatal) 

    SET @firstTime = 0 			-- assume this is not the first time.
    SET @fromDB = @hostname+'.'+ @DBname;
    SET @toDB =   @publishHost  + '.' +  @publishDB 

    --------------------------------------------------------------------------------------------- 
    -- register the step. 
    SET @stepMsg = 'Publishing '+@type+' '+@fromDB+' to '+@toDB
    EXEC spStartStep @taskID, @stepID OUTPUT, 'PUBLISH','WORKING', @stepMsg, @stepMsg;

    -- if step create fails, complain and return. 
    IF @stepid IS NULL 
        BEGIN 
            SET @phaseMsg = 'Could not create publish step for task '  
		+ str(@taskID) + ' database ' + @fromDB 
            EXEC spNewPhase 0, 0, 'Framework Error', 'ERROR', @phaseMsg;
            RETURN(1); 
        END

    -- register the step also on the publisher Task
    EXEC spStartStep @publishtaskID, @publishstepID OUTPUT, 'PUBLISH','WORKING', @stepMsg, @stepMsg;

    -- if step create fails, complain and return. 
    IF @publishstepid IS NULL 
        BEGIN 
            SET @phaseMsg = 'Could not create publish step for task '  
		+ str(@taskID) + ' database ' + @toDB 
            EXEC spNewPhase 0, 0, 'Framework Error', 'ERROR', @phaseMsg;
            RETURN(1); 
        END

    --------------------------------------------------------------------------------------------- 
    -- first figure out whether it is a network attach

    -- rebuild the filename
   -- SET @datafilename = '\\'+@hostname+'\'+REPLACE(@datafilename,':','$');
   -- SET @logfilename = '\\'+@hostname+'\'+REPLACE(@logfilename,':','$');

    -- set the trace flag for attaching networked volumes

    DBCC TRACEON(1807);


    -- Attach the source data base
    EXEC @err = sp_attach_db @DBname, @filename1=@datafilename, @filename2=@logfilename;
    IF @err = 1
   	BEGIN
	    SET @stepMsg =  'Failed to attach DB' + @fromDB 
            SET @phaseMsg = 'Failed to attach DB ' + @fromDB 
	    EXEC spNewPhase @taskID, @stepID, 'Attach', 'ABORTING', @phaseMsg;
	    EXEC spNewPhase @publishtaskID, @publishstepID, 'Attach', 'ABORTING', @phaseMsg;
            GOTO commonExit 
        END
    SET @phaseMsg = 'Successfully attached ' + @fromDB  + ' in file: ' + @datafilename
    EXEC spNewPhase @taskID, @stepID, 'Attach', 'OK', @phaseMsg;
    EXEC spNewPhase @publishtaskID, @publishstepID, 'Attach', 'OK', @phaseMsg;

    --------------------------------------------------------------------------------------------
    --
    SET @publishStart = CURRENT_TIMESTAMP

    --------------------------------------------------------------------------------------------- 
    -- Handle spectro databases 
    IF @type = 'plates' 
        begin 
        exec @err = spPublishPlates @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg  = 'Published plate ' + @fromDB 
                set @phaseMsg = 'Published plate ' + @fromDB 
                end 
        else 
                begin 
                set @stepMsg  = 'Failed to publish plate ' + @fromDB 
                set @phaseMsg = 'Failed to publish plate ' + @fromDB 
                end 
        goto commonExit 
        end 
    --------------------------------------------------------------------------------------------- 
    -- Handle galspec databases 
    IF @type = 'galspec' 
        begin 
        exec @err = spPublishGalSpec @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg  = 'Published galspec ' + @fromDB 
                set @phaseMsg = 'Published galspec ' + @fromDB 
                end 
        else 
                begin 
                set @stepMsg  = 'Failed to publish galspec ' + @fromDB 
                set @phaseMsg = 'Failed to publish galspec ' + @fromDB 
                end 
        goto commonExit 
        end 
    --------------------------------------------------------------------------------------------- 
    -- Handle galprod databases 
    IF @type = 'galprod' 
        begin 
        exec @err = spPublishGalProd @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg  = 'Published galprod ' + @fromDB 
                set @phaseMsg = 'Published galprod ' + @fromDB 
                end 
        else 
                begin 
                set @stepMsg  = 'Failed to publish galprod ' + @fromDB 
                set @phaseMsg = 'Failed to publish galprod ' + @fromDB 
                end 
        goto commonExit 
        end 
    --------------------------------------------------------------------------------------------- 
    -- Handle photo databases 
    IF @type in ( 'best', 'target', 'runs') 
        begin 
        exec @err = spPublishPhoto @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg  = 'Published Photo ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published Photo ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg  = 'Failed to publish photo ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish photo ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 

    --------------------------------------------------------------------------------------------- 
    -- Handle tiling databases 
    IF @type in ('tiles') 
        begin 
        exec @err = spPublishTiling @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published tiles ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published tiles ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish tiles ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish tiles ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 

    --------------------------------------------------------------------------------------------- 
    -- Handle window databases 
    IF @type in ('window') 
        begin 
        exec @err = spPublishWindow @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published window ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published window ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish window ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish window ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 

    --------------------------------------------------------------------------------------------- 
    -- Handle sspp databases 
    IF @type in ('sspp') 
        begin 
        exec @err = spPublishSspp @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published sspp ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published sspp ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish sspp ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish sspp ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 


    --------------------------------------------------------------------------------------------- 
    -- Handle properMotions databases 
    IF @type in ('pm') 
        begin 
        exec @err = spPublishPm @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published pm ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published pm ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish pm ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish pm ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 


    --------------------------------------------------------------------------------------------- 
    -- Handle mask databases 
    IF @type in ('mask') 
        begin 
        exec @err = spPublishMask @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published mask ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published mask ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish mask ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish mask ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 


    --------------------------------------------------------------------------------------------- 
    -- Handle mask databases 
    IF @type in ('manga') 
        begin 
        exec @err = spPublishManga @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published MaNGA ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published MaNGA ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish MaNGA ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish MaNGA ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 


    --------------------------------------------------------------------------------------------- 
    -- Handle resolve databases 
    IF @type in ('resolve') 
        begin 
        exec @err = spPublishResolve @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published resolve ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published resolve ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish resolve ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish resolve ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 


    --------------------------------------------------------------------------------------------- 
    -- Handle APOGEE databases 
    IF @type in ('apogee') 
        begin 
        exec @err = spPublishApogee @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published APOGEE ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published APOGEE ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish APOGEE ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish APOGEE ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 


    --------------------------------------------------------------------------------------------- 
    -- Handle WISE databases 
    IF @type in ('wise','forced') 
        begin 
        exec @err = spPublishWise @taskID, @stepID, @DBname, @publishDB, @firstTime 
        if @err = 0 
                begin 
                set @stepMsg =  'Published WISE ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Published WISE ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        else 
                begin 
                set @stepMsg =  'Failed to publish WISE ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                set @phaseMsg = 'Failed to publish WISE ' + @type + ' from: ' + @fromDB + ' to: ' + @toDB 
                end 
        goto commonExit 
        end 


    --------------------------------------------------------------------------------------------- 
    -- if got here then we do not recognize the type (not plates, best, runs, target, tiling 
    -- give error message 
    SET @err = 1 
    SET @stepMsg =  'Failed to publish ' + @type + ' db id: ' + @id + ' name: ' + @fromDB + ' because type: ' + @type + ' is unknown' 
    SET @phaseMsg = 'Failed to publish ' + @type + ' db id: ' + @id + ' name: ' + @fromDB + ' because type: ' + @type + ' is unknown' 

    -- detach the database, we are done with it.
    --     EXEC  sp_detach_db @DBname    
    --------------------------------------------------------------------------------------------- 
    -- Common exit to end the step (based on err setting)
    commonExit: 
    -- create final logs (writes to phase table, and step table) 
    IF @err = 0 
        BEGIN 
	    -- record load in load history
	    INSERT loadHistory (loadVersion, tstart, tend, dbname) 
		VALUES(@taskID, @publishStart, CURRENT_TIMESTAMP, @dbName)
	    --
            EXEC spEndStep @taskID, @stepID, 'DONE', @stepMsg, @phaseMsg;
            EXEC spEndStep @publishtaskID, @publishstepID, 'DONE', @stepMsg, @phaseMsg;
        END 
    ELSE 
        BEGIN 
	    EXEC spEndStep @taskID, @stepID, 'ABORTING', @stepMsg, @phaseMsg;
	    EXEC spEndStep @publishtaskID, @publishstepID, 'ABORTING', @stepMsg, @phaseMsg;

        END 

    RETURN @err 
END 
GO
 
PRINT '[spPublish]: spPublishStep installed'
GO

