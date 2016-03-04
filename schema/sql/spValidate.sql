--====================================================================
--   spValidate.sql
--   2002-10-04	Jim Gray
----------------------------------------------------------------------
-- This set of routines validates Photo and Spectro tables.
-- The premise is that the data has been loaded from the CSV.
-- The goal is to sniff test the data before it is published.
-- This includes testing key uniqueness, foreign keys, 
--   testing that HTMs are computed correctly,
--   testing that cardinalites are right and that parents are right.
-----------------------------------------------------------------------
-- History:
--* 2002-10-29   Jim: split spValidate and spFinish 
--*   		     (finish does neighbors and photo-spectro matchup).
--*			 removed references to sdssdr1.
--* 2002-11-02   Jim: sped up by creating indexes for unique test.
--*			left keys/indices in place on the theory that they do not hurt.
--* 2002-11-07   Jim change to specLineAll
--* 2002-11-10   Jim: added test of frame zoom levels (commentend out for now)
--* 2002-11-22	Jim: added remaining Unique Key tests
--* 2002-11-13	Alex: fixed bug in TargetInfo PK test, insert Jim's Mask validation
--* 2002-11-30   Jim: recover from lost file
--*			added many tile key and foreign key tests
--* 2003-01-27   Ani: Made changes to tiling schema as per PR# 4702:
--*		     renamed TileRegion to TilingRegion
--*		     renamed TileInfo to TilingInfo
--*		     renamed TileNotes to TilingNotes
--*		     renamed TileBoundary to TilingGeometry
--*		     change the primary key of TilingInfo from (tileRun,tid)
--*		        to (tileRun,targetID)
--* 2003-05-15	Alex: Changed PhotoObj-> PhotoObjAll
--* 2003-06-03	Alex: Changed some of the count(*) to count_big(*), @@rowcount to rowcount_big()
--* 2003-07-15   Ani: Fixed typo in TargetParam unique key test (PR #5490)
--*                   - changed paramName to name.
--* 2003-08-14   Ani: Fixed tiling table names/columns as per PR #5561:
--*                 Tile -> TileAll
--*                 TiledTarget -> TiledTargetAll
--*                 TilingRegion -> TilingRun
--*                 TilingNotes ->TilingNote
--*                 TilingNotes.tileNoteID -> TilingNote.tilingNoteID
--*                 TileBoundary.tileBoundID -> TilingGeometry.tilingGeometryID
--* 2003-12-04   Jim: for SQL best practices put an ORDER BY in the 
--*                 SELECT TOP 100 ... of spTestPhotoParentID
--*                 put FOR UPDATE clause in PhotoCusror of spValidate
--* 2004-02-13   Ani: Replaced fHTM_Lookup with fHTMLookup.
--* 2004-11-11  Alex: repointed spNewPhase, spStartStep and spEndStep to 
--*                  local wrappers
--* 2005-01-06   Ani: Fixed fHtmLookup call in spTestHtm to drop 'L' 
--*                   in level number, i.e. changes 'J2000 L20 ...' to
--*                   'J2000 20 ...'.
--* 2005-12-13  Ani: Commented out Photoz table, not loaded any more.
--* 2006-10-19  Ani: Replaced group by on ValidatorParents.objID with
--*                  one on kid.parentID in spTestPhotoParentID to avoid
--*                  sql2k5 error.
--* 2007-01-03  Ani: Replaced call to fHtmLookup with fHtmEq in spTestHtm.
--* 2007-01-05  Ani: Fixed bug in call to fHtmEq in spTestHtm.
--* 2007-05-15  Ani: Made zoom levels check conditional (only do it if
--*                  not RUNS DB.
--* 2009-05-18  Ani: Deleted tables phased out for SDSS-III.
--* 2009-06-14  Ani: Removed HTM tests from photo/spectro validation.
--* 2009-07-09  Ani: Deleted HTMID test in spValidatePhoto, changed 
--*                  Field.nObjects check to Field.nTotal, commented
--*                  out zoom levels check.
--* 2009-08-12  Ani: Updated names of tiling tables for SDSS-III and
--*             removed TilingNote.
--* 2009-10-30  Ani: Added call to spValidateSspp, and added unique
--*                  key tests to spValidateSspp.
--* 2009-12-31  Ani: Added spValidateGalSpec for galspec export.
--* 2010-01-14  Ani: Replaced ObjMask with AtlasOutline.
--* 2010-10-20  Ani: Removed discontinued spectro tables from validation.
--* 2010-11-23  Ani: Added spValidatePm and spValidateResolve.
--* 2010-12-08  Ani: Added segueTargetAll.objid uniqueness test to 
--*                  spValidateSspp.
--* 2012-05-17  Ani: Removed SpecLine* tables for Plates, reinstated
--*                  htmID test for SpecObjAll.
--* 2013-03-20  Ani: Added spValidateApogee
--* 2013-05-03  Ani: Added spValidateGalProd for galprod export.
--* 2013-05-20  Ani: Added spValidateWise for WISE tables.
--* 2013-07-03  Ani: Added reduction_id to apogeeStar PK test.
--* 2013-07-03  Ani: Added apogeeObject PK test to spValidateApogee,
--*                  and removed reduction_id from apogeeStar test.
--* 2013-07-09 Ani: Added apogeeStarVisit and apogeeStarAllVisit.
--^ 2016-01-11 Ani: Commented out Target tables in spValidatePhoto.
--^ 2016-01-11 Ani: Added spValidateMask.
--====================================================================
SET NOCOUNT ON;
GO


--======================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE [name]= N'spTestHtm' ) 
	DROP PROCEDURE spTestHtm
GO
--
CREATE PROCEDURE spTestHtm(
	@taskid int, @stepid int,
	@Table varchar(256), 		
	@error bigint OUTPUT
)
-------------------------------------------------------------
--/H Tests 1000 htms to see if they match the "local" algorithm
--/A 
--/T <p> parameters:  
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> table varchar() NOT NULL,   	-- name of source table to test the htm field
--/T <li> errorMsg varchar() NOT NULL,  -- error message if key not unique
--/T <br>
--/T  Tests 100 Table(htmID) to match SkyServer function
--/T  
--/T      Returns @error = 0 if almost all keys match  
--/T		@error > 0  more than 1% of keys needed fixing.
--/T
--/T      In the failure case it inserts messages in the load measage log 
--/T      describing the first 10 failing htmIDs. 
--/T
--/T Sample call to test photoObjAll.htm <br>
--/T <samp> 
--/T <br> exec spTestHtm @taskid , @stepid, 'photoObjAll',  @error output
--/T </samp> 
--/T <br> see also spGenericTest, spTestPrimaryKey, 
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @errorMsg varchar(1000), @errorVerb varchar(16),
		@mismatch bigint, @command varchar(1000);

	-- The test table holds the stored and computed HTM IDs
	IF ((select count_big(*) from dbo.sysobjects where [name] like  N'test') > 0) 
		DROP TABLE test; 
	-- Populate the test table
	SET @command =  'select top 100 HtmID as HTMstored ,'  
--		+  ' dbo.fHTMLookup(''J2000 20 '' + str(ra,15,9) + str(dec,15,9)) as HTMcomputed '
		+  ' dbo.fHtmEq(ra,dec) as HTMcomputed '
 		+  ' into test' 
		+  ' from ' + @Table
	EXEC (@command);
 	
	-- if count the number of times HTMstored != HTMcomputed
	SELECT @error = count_big(*) 
	   FROM test
	   WHERE HTMstored != HTMcomputed
 
	-- If count is non-zero we have a problem
 	IF (@error > 0)  
	    BEGIN
		SET @errorVerb = case when @error < 10 then 'WARNING' else 'ERROR' end 
   		SET @errorMsg = 'HTM test failed on '+ cast(@error as varchar(30)) 
			+ ' of 1000 HTM IDs in table ' + @Table + '(htmID)'      
	   	EXEC spNewPhase @taskid, @stepid, 'HTM test', 'ERROR', @errorMsg 
		IF @error < 10 SET @error = 0;
    	    END 
	ELSE	-- if count is zero, evrything is wonderful.
   	    BEGIN
	   	SET @errorMsg = 'HTM test passed on table: ' + @Table     
	    	EXEC spNewPhase @taskid, @stepid, 'HTM test', 'OK', @errorMsg 
	    END
 	--
	DROP TABLE test 
	RETURN @error
END		-- End spTestHtm()
GO

--======================================================
IF EXISTS (SELECT [name] FROM   sysobjects 
	WHERE  [name]= N'fDatediffSec' )
	DROP FUNCTION fDatediffSec
GO
--
CREATE FUNCTION  fDatediffSec(@start datetime, @now datetime) 
-------------------------------------------------------------
--/H fDatediffSec(start,now) returns the difference in seconds as a float
-----
--/T <p> parameters:  
--/T <li> start datetime,   		-- start time
--/T <li> now datetime,   		-- end time
--/T <li> returns float 	   	-- elapsed time in seconds. 
--/T <br>
--/T sample use: <samp> 
--/T      declare @start datetime 
--/T      set @start  = current_timestamp
--/T      do something 
--/T      print 'elapsed time was ' + str(dbo.fDatediffSec(@start, current_timestamp),10,3) + ' seconds'
--/T </samp> 
-------------------------------------------------------------
RETURNS float
AS
BEGIN
  RETURN(datediff(millisecond, @start, @now)/1000.0)
END   			-- End fDatediffSec()
GO

  
--======================================================
IF EXISTS (SELECT [name] FROM   sysobjects 
	WHERE  [name]= N'spGenericTest' )
	DROP PROCEDURE spGenericTest
GO
--
CREATE PROCEDURE spGenericTest( 
	@taskid int,
	@stepid int,
	@command varchar(8000), 
	@testType varchar(100),		
	@ErrorMsg varchar(2048), 
	@error bigint OUTPUT
)
-------------------------------------------------------------
--/H Tests a generic SQL Statement, gives error if test produces any records
--/A 
--/T      tests to see that no values violate the test 
--/T 	the test must have the syntax:
--/T 		select <your key> as badKey
--/T		into test
--/T        	from <your tests>
--/T     	if the <test> table is not empty, we print out the error message.
--/T  
--/T      Returns @error = 0 if all keys unique  
--/T 		@error >0  if duplicate keys (in which case it is the count of duplicate keys).
--/T
--/T      In the failure case it inserts messages in the load measage log 
--/T      describing the first failing key. 
--/T <p> parameters:  
--/T <li> taskid int,   		-- task identifier
--/T <li> stepid int,   		-- step identifier
--/T <li> command varchar() NOT NULL,   -- sql command select... into test where.... 
--/T <li> testType varchar() NOT NULL,  -- what are we testing 
--/T <li> errorMsg varchar() NOT NULL,  -- error message if test is not empty
--/T <li> error int NOT NULL,         	-- output: 0 if OK (test is empty), non zero if output is not empty
--/T <br>
--/T Sample call to test that r is not too small <br>
--/T <samp> 
--/T <br> exec spGenericTest @taskid, @stepid, 'select objID into test from objID where r < -99999', 'testing r'
--/T <br> 			'r is too small', @error output
--/T </samp> 
--/T <br> see also spTestUniqueKey, spTestForeignKey, 
-------------------------------------------------------------
AS BEGIN 
	SET NOCOUNT ON;
	-- The test table holds the failing objects, drop it if it is left around.
	IF EXISTS (SELECT [name] FROM   sysobjects 
		WHERE  [name]= N'test' )
		DROP TABLE test; 
	--
	-- execute the generic test that populates the test table
	-- 
	EXEC (@command)
	--
	-- if table is not empty, we have a problem.
	--
	SELECT @error = count_big(*) FROM test;
	IF (@error > 0) 
	    BEGIN
   		SET @errorMsg = @errorMsg + ' for task '  + str(@taskID) 
			+ ' step ' + str(@stepid) +' for test:' + @testType
			+ ' failed ' + cast(@error as varchar (10)) + ' times. '   
		EXEC spNewPhase @taskid, @stepid, @testType, 'ERROR', @errorMsg 
	    END
	ELSE	-- if table is empty, the test passed.
   	    BEGIN
		SET @errorMsg = 'Passed ' + @testType + ' test '  
	    	EXEC spNewPhase @taskid, @stepid, @testType, 'OK', @errorMsg    
	    END

	-- drop test table on exit
	DROP TABLE test

	RETURN @error
END			-- End spGenericTest()
GO
	


--======================================================
IF EXISTS (SELECT [name]FROM sysobjects
	WHERE  [name]= N'spTestUniqueKey' ) 
	drop procedure spTestUniqueKey
GO
--
CREATE PROCEDURE spTestUniqueKey(
	@taskid int, 
	@stepid int,
	@Table varchar(256), 		
	@fields varchar(256), 
	@error bigint OUTPUT
)
-------------------------------------------------------------
--/H Tests a unique key, gives error if test finds non unique key
--/A 
--/T
--/T    tests to see that sourceTable(key)is a unique key 
--/T    key can involve multipe fields as in neighbors (objID, neighborObjID)
--/T  
--/T    Returns @error = 0 if all keys unique  
--/T	@error >0  if duplicate keys (in which case it is the count of duplicate keys.
--/T
--/T    In the failure case it inserts messages in the phase table 
--/T <p> parameters:  
--/T <li> taskid bigint,   		-- task identifier
--/T <li> stepid bigint,   		-- step identifier
--/T <li> table varchar() NOT NULL,   	-- name of table to test 
--/T <li> key varchar() NOT NULL,   	-- name of key in table to test
--/T <li> error int NOT NULL,         	-- output: 0 if OK (key is unique), non zero if key not unique
--/T <br>
--/T Sample call to test that photoObjAll.Objid is unique <br>
--/T <samp> 
--/T <br> exec spTestUniqueKey @taskid, @stepid, 'photoObjAll', 'ObjID', @error output
--/T </samp> 
--/T <br> see also spGenericTest, spTestForeignKey, 
-------------------------------------------------------------
AS BEGIN 
	SET NOCOUNT ON;
	DECLARE @errorMsg varchar(1000), @command varchar(1000);

	-- drop test table if it was left behind by other tests.
	IF EXISTS (SELECT [name]FROM   sysobjects 
		WHERE  [name]= N'test' )
		DROP TABLE test; 

	-- create an index to make things go fast
	DECLARE @indexName varchar (100)
	set @indexName = @table + '_index_' +  cast(cast(rand()*100000000 as int)as varchar(100))  
	
	SET @command = 'CREATE INDEX ' + @indexName + ' ON ' 
			+ @Table + '(' + @fields + ')'
	-- print @command
	EXEC (@command)

	-- test uniqueness
	SET @command = 	' select '+ @fields + 
 			' into test '  +
			' from ' + @Table  +
			' group by ' + @fields +   
  			' having count_big(*) > 1';
	EXEC (@command)

	-- test table is empty if keys are unique.
	SELECT @error = count_big(*) FROM test;
	IF (@error > 0) 
	    BEGIN
		SET @errorMsg = 'Unique key test on '+ @Table + '(' + @fields + ')'
			+ ' failed ' + cast(@error as varchar (10)) + ' times. '         
	   	EXEC spNewPhase @taskid, @stepid, 'Unique key test', 'ERROR', @errorMsg 
	    END
	ELSE
	    BEGIN
		SET @errorMsg = 'Unique key test passed on '+ @Table + '(' + @fields + ')'   
	    	EXEC spNewPhase @taskid, @stepid, 'Unique key test', 'OK', @errorMsg 
	    END

	-- clean up test table on exit.
	DROP TABLE test
	RETURN @error
END		-- End spTestUniqueKey()
--===========================================================
GO


--======================================================
IF EXISTS (SELECT [name]FROM   sysobjects 
	WHERE  [name]= N'spTestForeignKey' ) 
	DROP PROCEDURE spTestForeignKey
GO
--
CREATE PROCEDURE spTestForeignKey(
	@taskid int, 
	@stepid int,
	@SourceTable varchar(256), 
	@DestinationTable varchar(256), 		
	@field varchar(256), 
	@error bigint OUTPUT
)
-------------------------------------------------------------
--/H Tests a foreign key, gives error if test finds an orphan record
--/A 
--/T spTestForeignKey (taskID, stepID, sourceTable, targetTable, key, error output)
--/T
--/T    tests to see that all values in sourceTable(key) are in targetTable(key)
--/T  
--/T    Returns @error = 0 if foreigh key is OK
--/T		@error >0  if foreign key has a mismatch (in which case it is the count.
--/T
--/T In the failure case it inserts messages in the load measage log 
--/T  describing the first 10 distinct failing keys. 
--/T
--/T <p> parameters:  
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> SourceTable varchar() NOT NULL, -- name of source table to test
--/T <li> destinationTable varchar() NOT NULL, -- name of destination table to test  
--/T <li> key varchar() NOT NULL,   	-- name of foreign key in table to test
--/T <li> error int NOT NULL,         	-- output: 0 if OK (is a foreign key), non zero find orphan
--/T <br>
--/T Sample call to test that PhotoProfile.Objid is a foreign key to photoObjAll <br>
--/T <samp> 
--/T <br> exec spTestForeignKey @taskid, @stepID, 'PhotoProfile', 'photoObjAll','ObjID',  @error output
--/T </samp> 
--/T <br> see also spGenericTest, spTestPrimaryKey, 
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON
	DECLARE @errorMsg varchar(1000), @command varchar(1000);

	-- if test table left over from previous tests, drop it.
	IF EXISTS (SELECT [name]FROM   sysobjects 
		WHERE  [name]= N'test' )
		DROP TABLE test; 

	-- the foreign key test populates test table with failing keys.
	SET @command = 'select distinct ' + @field  
 		+ ' into test ' 
		+ ' from ' + @SourceTable  
		+ ' where ' + @field + ' not in ' 
  		+ '    (select ' + @field + ' from ' + @DestinationTable + ')';
	--print @command;
	EXEC (@command)

	-- if test table is not empty, we have a problem.
	SELECT @error = count_big(*) FROM test;
	IF (@error > 0) 
	    BEGIN
		SET @errorMsg = 'Foreign key test test failed: ' + cast(@error as varchar (10)) 
			+ ' times on  table ' 
			+ @sourceTable + '(' + @field + ') ->' + @DestinationTable      
		EXEC spNewPhase @taskid, @stepid, 'Foreign key test', 'ERROR', @errorMsg 
	    END
	ELSE		-- if test is empty, then test passed.
	    BEGIN
		SET @errorMsg = 'Foreign key test passed on table: ' 
			+ @sourceTable + '(' + @field + ') ->' + @DestinationTable      
	    	EXEC spNewPhase @taskid, @stepid, 'Foreign key test',  'OK', @errorMsg 
	    END

	-- clean up (drop test table) and return.
	DROP TABLE test 
	RETURN @error
END		-- End spTestForeignKey()
GO



--======================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spTestPhotoParentID' ) 
	DROP PROCEDURE spTestPhotoParentID
GO
--
CREATE PROCEDURE spTestPhotoParentID (@taskid int, @stepid int)
-------------------------------------------------------------
--/H Tests that photoObjAll.nChild matches the number of children of each PhotoObj
--/A 
--/T Test that a parent with nChild has in fact n Children
--/T <p> parameters:  
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> returns  0 if OK (nChild is correct), non zero if nChild is wrong  
--/T <br>
--/T Sample call   <br>
--/T <samp> 
--/T <br> exec @error = spTestPhotoParentID @taskid , @stepid 
--/T </samp> 
--/T <br> see also spGenericTest, spTestPrimaryKey, 
-------------------------------------------------------------  
AS BEGIN
	SET NOCOUNT ON
	DECLARE @error int, @errorMsg varchar(100)
	SET @error = 0

	--===========================================================================
	--- Find 100 parents and their kid counts and store them in the parents table
	-- if test table left over from previous tests, drop it.
	IF EXISTS (SELECT [name]FROM   sysobjects 
		WHERE  [name]= N'ValidatorParents' )
		DROP TABLE ValidatorParents; 
	CREATE TABLE ValidatorParents ( objID bigint not null primary key, 
			nChild bigint not null, 
			nChildActual bigint null   -- note: allows nulls
		);
	
	-- find first 100 parents
	INSERT ValidatorParents
		SELECT TOP 100 objID, nChild, 0
		FROM photoObjAll
		WHERE nChild != 0
		ORDER BY ObjID

	-- if there are less than 100 parents, something is wrong.
	IF (rowcount_big() < 100)
	    BEGIN
		SET @errorMsg = 'Photo Parent Test failed: less than 100 parents in this run, something is wrong '
	   	EXEC spNewPhase @taskid, @stepid, 'Photo Parent test', 'ERROR', @errorMsg   
	   	GOTO bottom
	    END

	-- index the photoObjAll.Parent records to make the following join go fast.
	IF EXISTS (SELECT * from sysindexes where name = 'Parent' and id = object_id( 'photoObjAll')) 
			DROP INDEX photoObjAll.Parent
	CREATE UNIQUE INDEX Parent ON photoObjAll(parentID, objID)

	-- compute the actual kid population
	UPDATE ValidatorParents
	SET nChildActual =  (
		select count_big(*)
		from photoObjAll kid  
		where kid.parentID = ValidatorParents.objID
--		group by ValidatorParents.objID)
-- replaced this with group by on kid.parentID for sql2k5
		group by kid.parentID)

	-- now test to make sure that there are 100 good ones
	DECLARE @pop bigint
	SET @pop = (	select count_big(*) 
			from ValidatorParents
			where nChild != coalesce(nChildActual,0))
	-- if there are some parents with the wrong counts then...
	IF (@pop != 0) 	
	    BEGIN
		SET @errorMsg = 'photoObjAll Parent test failed: ' + cast(@pop as varchar (10)) + ' times out of 100'
   		EXEC spNewPhase @taskid, @stepid, 'Photo Parent test', 'ERROR', @errorMsg   
		SET @error = 1;
   	    END
	ELSE	-- if all the parents have the right counts...
	    BEGIN
		SET @errorMsg = 'photoObjAll Parent test succeeded'  
   		EXEC spNewPhase @taskid, @stepid, 'Photo Parent test', 'OK', @errorMsg   
		SET @error = 0;
   	    END

    -- common exit
    bottom: 
	-- clean up indices we created.
	DROP TABLE ValidatorParents
	IF EXISTS (SELECT * from sysindexes where name = 'Parent' and id = object_id( 'photoObjAll')) 
			DROP INDEX photoObjAll.Parent
	-- return status.
	RETURN @error
END			-- End spTestPhotoParentID()
GO


---------------------------------------------------------------------------------------
-- spComputePhotoParent
-- If the ParentID is not exported you can recompute it from nChild.
--  if an object 10 has 3 children, then  they are objects 11, 12, 13.
--   Unless of course, 12 has 3 children in which case recursion is needed.
--   This guy does the recursion.

--======================================================
IF EXISTS (SELECT [name]FROM   sysobjects 
	WHERE  [name]= N'spComputePhotoParentID' ) 
	DROP PROCEDURE spComputePhotoParentID
GO
--
CREATE PROCEDURE spComputePhotoParentID (@taskid int, @stepid int)
-------------------------------------------------------------
--/H Computes photoObjAll.ParentID based on nChild
--/A 
--/T Scans photoObjAll table.
--/T    if nChild >0 then the next "nChild" nodes are children of this node.
--/T       unless one of them has nChild>0 in which case we recurse
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call   <br>
--/T <samp> 
--/T <br> exec  spComputePhotoParentID @taskid, @stepid 
--/T </samp> 
--/T <br> see also spTestPhotoParentID  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON;
	declare @errorMsg varchar(1000)
	declare @error int
	set @error = 0
	--===========================================================================
	DECLARE	photoCursor CURSOR 
	FOR SELECT nChild, ObjID 
            FROM photoObjAll 
            FOR UPDATE OF parentID
              
	DECLARE @nChild INT;
	DECLARE @nChild1 INT;
	DECLARE @ParentID  BIGINT;
	DECLARE @ChildID   BIGINT;
	DECLARE @stack     varchar(100);
	SET @stack = '';

	OPEN photoCursor
		FETCH NEXT FROM photoCursor INTO  @nChild, @ParentID  
	--print 'Fetched AT 1 nChild:' + STR(@nChild) + ' ParentID:'+str(@ParentID);
	WHILE (@@fetch_status = 0 )
	  BEGIN
	    WHILE (@nChild > 0)
	      BEGIN
		FETCH NEXT FROM photoCursor INTO  @nChild1, @ChildID 
		--print 'Fetched AT 2 nChild:' + STR(@nChild1) + ' ChildID:'+str(@childID);
		IF ((@@fetch_status <> 0))
		  BEGIN
		    PRINT 'fetch failed, nChild Count is wrong';
		    EXEC spNewPhase @taskid, @stepid, 'Compute Photo Parent', 'ERROR',
			'Compute Photo Parent fetch failed, nChild Count is wrong'   
		    SET @error = @error + 1
		    BREAK;
		  END
		    --INSERT INTO photoObjAllExtension VALUES (@ChildID, @ParentID,null)
		    --print 'parent: '+str(@parentID,3)+' kid: '+str(@ChildID,3)+'child count: '+str(@nChild,3)
		UPDATE photoObjAll
			SET parentID = @ParentID
			WHERE CURRENT OF photoCursor;
		SET @nChild = @nChild-1;
		IF (@nChild1 > 0)
		    BEGIN
		  	SET @stack = str(@ParentID,20,0) + str(@nChild,20,0) + @stack;
			SET @ParentID = @ChildID;
			SET @nChild = @nChild1;
		    END
		ELSE WHILE ((@nChild = 0) AND (@stack != ''))
		    BEGIN
			SET @ParentID = cast(substring(@stack,1,20) as bigint);
			SET @nChild = cast(substring(@stack,21,20) as int);
			SET @stack = substring(@stack,41,Datalength(@stack)-40);
			--print ':' +@stack + ':'
		    END
		END
		FETCH NEXT FROM photoCursor INTO  @nChild, @ParentID 
 		--print 'Fetched AT 3 nChild:' + STR(@nChild) + ' ChildID:'+str(@ParentID);  
	END
	CLOSE photoCursor

	DECLARE @count bigint;
	SELECT @count = count_big(*) from photoObjAll where parentID != 0

	DEALLOCATE photoCursor
	IF @error = 0 
	    BEGIN
		SET @errorMsg = 'Compute Photo Parent: ' + cast(@count as varchar(20)) + ' child-parent relationships.'
		EXEC spNewPhase @taskid, @stepid, 'Compute Photo Parent', 'OK', @errorMsg  
	    END
	RETURN @error
END			-- End spComputePhotoParentID()
GO


--======================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE  [name]= N'spValidatePhoto') 
	drop procedure spValidatePhoto
GO
--
CREATE PROCEDURE spValidatePhoto (
	@taskid int, 
	@stepid int,
	@type varchar(16),
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate Photo object of a given type  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> targetType int,   		-- 'best', 'runs','target', 'tiling'  
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidatePhoto @taskid , @stepid, 'best', 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    --
    SET NOCOUNT ON;
    --- setup  
    DECLARE 
	@summary bigint, 
	@error bigint,
	@start datetime,
	@errorMsg varchar(1000),
	@verb varchar(16),
	@command varchar (1000)

    SET @start = current_timestamp
    SET @summary = 0

    -- Greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidatePhoto', 'OK', 'spValidatePhoto called'
  
	--------------------------
	--- Test Photo uniqueness
	--------------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'StripeDefs',    	'stripe',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'Field',		'FieldID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'FieldProfile',	'fieldID, bin, band', @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'Frame',		'FieldID,Zoom',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'PhotoObjAll',	'objID',	@error OUTPUT
	set @summary = @summary + @error; 
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'PhotoProfile',  	'objID, bin, band', @error OUTPUT
	set @summary = @summary + @error;
--	exec dbo.spTestUniqueKey  @taskid , @stepid,  'PhotoZ',        	'objID',	@error OUTPUT
--	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'First',		'objID',	@error OUTPUT
	set @summary = @summary + @error;
--	exec dbo.spTestUniqueKey  @taskid , @stepid,  'Rosat',         	'objID',	@error OUTPUT
--	set @summary = @summary + @error;
--	exec dbo.spTestUniqueKey  @taskid , @stepid,  'USNO',          	'objID',	@error OUTPUT
--	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'Mask',          	'maskID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'AtlasOutline',        'objID',	@error OUTPUT
	set @summary = @summary + @error;
/* Commented out tests for Target tables - these tables are empty or deleted.
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'Target',         'targetID',	@error OUTPUT
	set @summary = @summary + @error;
	-- remove the next if Southern Imaging
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'TargetInfo',    	'targetObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'TargetInfo',    	'skyVersion,targetID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'TargetParam',    'targetVersion,name',	@error OUTPUT
	set @summary = @summary + @error;
 */
 
	--select 'Photo uniqueness summary is ' + cast(@summary as varchar(20)) 
  
	----------------------------------
	--- Test the photoObjAll foreign Keys
	---------------------------------- 
	exec dbo.spTestForeignKey @taskid , @stepid,  'Frame',        'Field',      'fieldID', @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestForeignKey @taskid , @stepid,  'FieldProfile', 'Field',      'fieldID', @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestForeignKey @taskid , @stepid,  'PhotoObjAll',     'Field',      'fieldID', @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestForeignKey @taskid , @stepid,  'PhotoProfile', 'photoObjAll',   'ObjID',   @error OUTPUT
	set @summary = @summary + @error;
--	exec dbo.spTestForeignKey @taskid , @stepid,  'PhotoZ',       'photoObjAll',   'ObjID',   @error OUTPUT
--	set @summary = @summary + @error;
	exec dbo.spTestForeignKey @taskid , @stepid,  'AtlasOutline',      'photoObjAll',   'ObjID',   @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestForeignKey @taskid , @stepid,  'First',        'photoObjAll',   'ObjID',   @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestForeignKey @taskid , @stepid,  'TargetInfo',    'Target',   'targetID', @error OUTPUT
	set @summary = @summary + @error;

	--===============
	-- Mask test
	--===============
	set @command =	'SELECT maskid INTO Test FROM Mask m '
		+ ' WHERE NOT EXISTS '
		+ '  (select fieldid from Field f '
		+ '   where m.run    = f.run '
		+ '     and m.rerun  = f.rerun '
		+ '     and m.camcol = f.camcol '
		+ '     and m.field  = f.field ) ';
	exec dbo.spGenericTest  @taskid , @stepid,  @command,        
		'Test Mask is in Field',
		'Mask objects do not match corresponding Field table',
		@error OUTPUT
	set @summary = @summary + @error;

	--====================
	-- Test cardinalities
	--====================
      -- testing Field.nTotal
	set @command = 	'select F.fieldID as BadKey, nTotal, count_big(*) as nTotalReal ' +
		'into test ' +
		'from Field as F join photoObjAll as P on F.fieldID = P.fieldID ' +
		'group by F.fieldID, nTotal ' +
		'having nTotal != count_big(*) '
	exec dbo.spGenericTest  @taskid , @stepid,  @command,        
		'Test Field.nTotal',
		'Field.nTotal does not match corresponding photoObjAll table',
		@error OUTPUT
	set @summary = @summary + @error;

/* Omit the zoom levels test for SDSS-III, will probably put it back in later [ART]
	-- do the zoom levels check only if this is not RUNS db
	if (@type != 'runs')
	    begin
		set @command = 	'SELECT field.fieldID, COUNT(DISTINCT  zoom) as zooms ' +
			'into test ' +
			'FROM field LEFT OUTER JOIN frame ON  field.fieldID = frame.fieldID ' +
			'GROUP BY field.fieldID ' +
			'HAVING COALESCE(COUNT(DISTINCT  zoom),-1) != 7 '
		exec dbo.spGenericTest  @taskid , @stepid,  @command,        
			'Test Field zoom levels',
			'some fields do not have seven zoom levels.',
			@error OUTPUT
		set @summary = @summary + @error;
	    end
*/

        -- testing photoObjAll.Nprofiles
	set @command =  'select top 10 P.objID as badKey, ' +
		'(nProf_u + nProf_g + nProf_r + nProf_i + nProf_z ) as nProf, ' +
		'count_big(*) as nProfReal ' +
		'into test ' +
		'from photoObjAll as P join PhotoProfile as PP on P.objID = PP.objID ' +
		'group by  P.objID,(nProf_u + nProf_g + nProf_r + nProf_i + nProf_z ) ' +
		'having (nProf_u + nProf_g + nProf_r + nProf_i + nProf_z ) != count_big(*) '
	exec dbo.spGenericTest  @taskid , @stepid,  @command,        
		'Test photoObjAll.nProf_ugriz',
		'photoObjAll.nProf_ugriz does not match corresponding PhotoProfile table',
		@error OUTPUT
	set @summary = @summary + @error;

/* Omit the HTM test for SDSS-III [ART]
	--===============
	-- Test the HTMs
	--===============
	exec dbo.spTestHtm  @taskid , @stepid,  'Frame',   @error OUTPUT   
	set @summary = @summary + @error;

	exec dbo.spTestHtm  @taskid , @stepid,  'Mask',   @error OUTPUT
	set @summary = @summary + @error;

	exec dbo.spTestHtm  @taskid , @stepid,  'photoObjAll',   @error OUTPUT
	set @summary = @summary + @error;
*/

	--=======================================================================
	-- test the parents, if there are problems, compute them.
	EXEC @error = dbo.spTestPhotoParentID @taskid , @stepid
	IF @error != 0
	    BEGIN 
		EXEC @error = dbo.spComputePhotoParentID @taskid , @stepid
 	    END
	SET @summary = @summary + @error

	--=======================================================================
	-- Clean up
	-- EXEC spDropIndexAll  -- IF YOU REALLY WANT TO CLEAN up the DB
	--=======================================================================

	-- give final summary of Step.
	IF @summary = 0 
	    BEGIN
		SET @errorMsg = 'Photo validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE
	    BEGIN
		SET @errorMsg = 'Photo validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidatePhoto', @verb, @errorMsg ;
	 
	--=======================================================================
	-- common exit.
	SET @error = @summary
	RETURN @error
END	-- End spValidatePhoto()
go

------------------------------------
-- Validate the Spectroscopic data
------------------------------------


--======================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidatePlates' ) 
	drop procedure spValidatePlates
GO
--
CREATE PROCEDURE spValidatePlates (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate Spectro object  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidatePlates @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON

	--- Globals
	DECLARE @start datetime, 
		@summary bigint, 
		@error bigint,
		@errorMsg varchar(1000), 
		@verb varchar(16)

	-- Put out step greeting.
	EXEC spNewPhase @taskid, @stepid, 'spValidatePlates', 'OK', 'spValidatePlates called'; 

	-------------------------------------
	SET @start  = current_timestamp
	SET @summary = 0

	--------------------
	-- test unique keys
	--------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'PlateX',       'PlateID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'SpecObjAll',   'SpecObjID',	@error OUTPUT
	set @summary = @summary + @error;

  	----------------------------------
	--- Test the SpecObj foreign Keys 
	---------------------------------- 
	exec dbo.spTestForeignKey @taskid , @stepid,  'SpecObjAll',   'PlateX',      'PlateID',   @error OUTPUT
	set @summary = @summary + @error;

	-- test the HTMs
	exec dbo.spTestHtm  @taskid , @stepid,  'SpecObjAll',   @error OUTPUT
	set @summary = @summary + @error;

	-- generate completion message.
	SET @error = @summary
	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'Spectro validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'Spectro validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidatePlates', @verb, @errorMsg ;	
	RETURN @error	-- return
END		-- End spValidatePlates()
GO


--======================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateGalSpec' ) 
	drop procedure spValidateGalSpec
GO
--
CREATE PROCEDURE spValidateGalSpec (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate GalSpec tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateGalSpec @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON

	--- Globals
	DECLARE @start datetime, 
		@summary bigint, 
		@error bigint,
		@errorMsg varchar(1000), 
		@verb varchar(16)

	-- Put out step greeting.
	EXEC spNewPhase @taskid, @stepid, 'spValidateGalSpec', 'OK', 'spValidateGalSpec called'; 

	-------------------------------------
	SET @start  = current_timestamp
	SET @summary = 0

	--------------------
	-- test unique keys
	--------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'galSpecExtra',  'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'galSpecIndx',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'galSpecInfo',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'galSpecLine',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;

	-- generate completion message.
	SET @error = @summary
	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'GalSpec validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'GalSpec validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateGalSpec', @verb, @errorMsg ;	
	RETURN @error	-- return
END		-- End spValidateGalSpec()
GO


--======================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateGalProd' ) 
	drop procedure spValidateGalProd
GO
--
CREATE PROCEDURE spValidateGalProd (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate galaxy product tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateGalProd @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON

	--- Globals
	DECLARE @start datetime, 
		@summary bigint, 
		@error bigint,
		@errorMsg varchar(1000), 
		@verb varchar(16)

	-- Put out step greeting.
	EXEC spNewPhase @taskid, @stepid, 'spValidateGalProd', 'OK', 'spValidateGalProd called'; 

	-------------------------------------
	SET @start  = current_timestamp
	SET @summary = 0

	--------------------
	-- test unique keys
	--------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'emissionLinesPort',  'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'stellarMassFSPSGranEarlyDust',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'stellarMassFSPSGranEarlyNoDust',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'stellarMassFSPSGranWideDust',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'stellarMassFSPSGranWideNoDust',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'stellarMassPassivePort',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'stellarMassPCAWiscBC03',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'stellarMassPCAWiscM11',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'stellarMassStarformingPort',   'specObjID',	@error OUTPUT
	set @summary = @summary + @error;

	-- generate completion message.
	SET @error = @summary
	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'GalProd validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'GalProd validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateGalProd', @verb, @errorMsg ;	
	RETURN @error	-- return
END		-- End spValidateGalProd()
GO


--======================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateTiles' ) 
	drop procedure spValidateTiles
GO
--
CREATE PROCEDURE spValidateTiles (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate Tiles  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateTiles @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    	--
    	SET NOCOUNT ON

    	--- Globals
    	DECLARE	@start datetime,
		@summary bigint,
		@error bigint,
		@errorMsg varchar(1000),
		@verb varchar(16)

    -- Put out step greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidateTiles', 'OK', 'spValidateTiles called'; 

    -------------------------------------
    SET @start  = current_timestamp
    SET @summary = 0

	---------------------
	-- test unique keys
	---------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sdssTileAll', 'tile', @error OUTPUT
	set @summary = @summary + @error;
--	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sdssTilingGeometry', 'regionID', @error OUTPUT
--	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sdssTiledTargetAll', 'targetID', @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sdssTilingInfo', 'tileRun, targetID', @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sdssTilingRun', 'tileRun', @error OUTPUT
	set @summary = @summary + @error;
  
	----------------------------------
	--- Test the Tiles foreign Keys 
	---------------------------------- 
	exec dbo.spTestForeignKey  @taskid , @stepid, 'sdssTileAll',  'sdssTilingRun',	'tileRun',   @error OUTPUT
	set @summary = @summary + @error; 
	exec dbo.spTestForeignKey  @taskid , @stepid, 'sdssTilingGeometry',	'sdssTilingRun',   'tileRun', @error OUTPUT
	set @summary = @summary + @error;	 
	exec dbo.spTestForeignKey  @taskid , @stepid, 'sdssTilingGeometry',	'StripeDefs',   'stripe',  @error OUTPUT
	set @summary = @summary + @error; 
	exec dbo.spTestForeignKey  @taskid , @stepid, 'sdssTilingInfo',	'sdssTilingRun',   'tileRun',  @error OUTPUT
	set @summary = @summary + @error;
--	exec dbo.spTestForeignKey  @taskid , @stepid, 'sdssTiledTargetAll',	'sdssTileAll',         'tile',     @error OUTPUT
--	set @summary = @summary + @error;
 
	-- generate completion message.

	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'Tiles validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'Tiles validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateTiles', @verb, @errorMsg ;
	
	RETURN @summary
END		-- End spValidateTiles()
--======================================
go


--======================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateWindow' ) 
	drop procedure spValidateWindow
GO
--
CREATE PROCEDURE spValidateWindow (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate Window tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateWindow @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    	--
    	SET NOCOUNT ON

    	--- Globals
    	DECLARE	@start datetime,
		@summary bigint,
		@error bigint,
		@errorMsg varchar(1000),
		@verb varchar(16)

    -- Put out step greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidateWindow', 'OK', 'spValidateWindow called'; 

    -------------------------------------
    SET @start  = current_timestamp
    SET @summary = 0

	---------------------
	-- test unique keys
	---------------------
--	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sdssImagingHalfSpaces' , 'sdssPolygonID', @error OUTPUT
--	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sdssPolygons', 'sdssPolygonID', @error OUTPUT
	set @summary = @summary + @error;
--	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sdssPolygon2Field', 'sdssPolygonID', @error OUTPUT
--	set @summary = @summary + @error;
 
	-- generate completion message.

	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'Window function tables validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'Window function tables validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateWindow', @verb, @errorMsg ;
	
	RETURN @summary
END		-- End spValidateWindow()
--======================================
go

IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateSspp' ) 
	drop procedure spValidateSspp
GO
--
CREATE PROCEDURE spValidateSspp (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate sspp tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateSspp @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    	--
    	SET NOCOUNT ON

    	--- Globals
    	DECLARE	@start datetime,
		@summary bigint,
		@error bigint,
		@errorMsg varchar(1000),
		@verb varchar(16)

    -- Put out step greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidateSspp', 'OK', 'spValidateSspp called'; 

    -------------------------------------
    SET @start  = current_timestamp
    SET @summary = 0

	---------------------
	-- test unique keys
	---------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sppLines', 'specObjID', @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'sppParams', 'specObjID', @error OUTPUT
	set @summary = @summary + @error;
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'segueTargetAll', 'objID', @error OUTPUT
	set @summary = @summary + @error;
 
	-- generate completion message.

	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'sspp tables validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'sspp tables validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateSspp', @verb, @errorMsg ;
	
	RETURN @summary
END		-- End spValidateSspp()
--======================================
go


IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidatePm' ) 
	drop procedure spValidatePm
GO
--
CREATE PROCEDURE spValidatePm (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate pm tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidatePm @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    	--
    	SET NOCOUNT ON

    	--- Globals
    	DECLARE	@start datetime,
		@summary bigint,
		@error bigint,
		@errorMsg varchar(1000),
		@verb varchar(16)

    -- Put out step greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidatePm', 'OK', 'spValidatePm called'; 

    -------------------------------------
    SET @start  = current_timestamp
    SET @summary = 0

	---------------------
	-- test unique keys
	---------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'properMotions', 'objID', @error OUTPUT
	set @summary = @summary + @error;
 
	-- generate completion message.

	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'pm tables validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'pm tables validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidatePm', @verb, @errorMsg ;
	
	RETURN @summary
END		-- End spValidatePm()
--======================================
go



IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateMask' ) 
	drop procedure spValidateMask
GO
--
CREATE PROCEDURE spValidateMask (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate Mask tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateMask @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    	--
    	SET NOCOUNT ON

    	--- Globals
    	DECLARE	@start datetime,
		@summary bigint,
		@error bigint,
		@errorMsg varchar(1000),
		@verb varchar(16)

    -- Put out step greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidateMask', 'OK', 'spValidateMask called'; 

    -------------------------------------
    SET @start  = current_timestamp
    SET @summary = 0

	---------------------
	-- test unique keys
	---------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'Mask',          	'maskID',	@error OUTPUT
	set @summary = @summary + @error;
 
	-- generate completion message.

	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'mask tables validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'mask tables validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateMask', @verb, @errorMsg ;
	
	RETURN @summary
END		-- End spValidateMask()
--======================================
go



IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateResolve' ) 
	drop procedure spValidateResolve
GO
--
CREATE PROCEDURE spValidateResolve (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate resolve tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateResolve @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    	--
    	SET NOCOUNT ON

    	--- Globals
    	DECLARE	@start datetime,
		@summary bigint,
		@error bigint,
		@errorMsg varchar(1000),
		@verb varchar(16)

    -- Put out step greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidateResolve', 'OK', 'spValidateResolve called'; 

    -------------------------------------
    SET @start  = current_timestamp
    SET @summary = 0

	---------------------
	-- test unique keys
	---------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'thingIndex', 'thingID', @error OUTPUT
	set @summary = @summary + @error;

	-- generate completion message.
	IF @summary = 0
            BEGIN
		select @error = count(thingID) 
		from thingIndex 
		where thingId NOT IN (select thingId from detectionIndex)
	    
		set @summary = @summary + @error;
                
		IF @summary > 0 
		    BEGIN
		        SET @errorMsg =   'resolve tables validation found ' +str(@summary) + ' thingIDs in thingIndex that were not in detectionIndex ' 
		        SET @verb = 'ERROR'
			EXEC spNewPhase @taskid, @stepid, 'spValidateResolve', @verb, @errorMsg ;
	            END
            END

	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'resolve tables validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'resolve tables validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateResolve', @verb, @errorMsg ;
	
	RETURN @summary
END		-- End spValidateResolve()
--======================================
go


IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateApogee' ) 
	drop procedure spValidateApogee
GO
--
CREATE PROCEDURE spValidateApogee (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate resolve tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateApogee @taskid , @stepid, 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    	--
    	SET NOCOUNT ON

    	--- Globals
    	DECLARE	@start datetime,
		@summary bigint,
		@error bigint,
		@errorMsg varchar(1000),
		@verb varchar(16)

    -- Put out step greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidateApogee', 'OK', 'spValidateApogee called'; 

    -------------------------------------
    SET @start  = current_timestamp
    SET @summary = 0

	---------------------
	-- test unique keys
	---------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'apogeeVisit', 'visit_id', @error OUTPUT
	set @summary = @summary + @error;

	-- generate completion message.
	IF @summary = 0
            BEGIN
	    	exec dbo.spTestUniqueKey  @taskid , @stepid,  'apogeeStar', 'apstar_id', @error OUTPUT
		set @summary = @summary + @error;
            END

                
	IF @summary = 0
            BEGIN
	    	exec dbo.spTestUniqueKey  @taskid , @stepid,  'aspcapStar', 'aspcap_id', @error OUTPUT
		set @summary = @summary + @error;
            END

                
	IF @summary = 0
            BEGIN
	    	exec dbo.spTestUniqueKey  @taskid , @stepid,  'apogeePlate', 'plate_visit_id', @error OUTPUT
		set @summary = @summary + @error;
            END

                
	IF @summary = 0
            BEGIN
	    	exec dbo.spTestUniqueKey  @taskid , @stepid,  'apogeeObject', 'target_id', @error OUTPUT
		set @summary = @summary + @error;
            END

                
	IF @summary = 0
            BEGIN
	    	exec dbo.spTestUniqueKey  @taskid , @stepid,  'apogeeStarVisit', 'visit_id', @error OUTPUT
		set @summary = @summary + @error;
            END

                
	IF @summary = 0
            BEGIN
	    	exec dbo.spTestUniqueKey  @taskid , @stepid,  'apogeeStarAllVisit', 'visit_id,apstar_id', @error OUTPUT
		set @summary = @summary + @error;
            END

                
	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'APOGEE tables validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'APOGEE tables validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateApogee', @verb, @errorMsg ;
	
	RETURN @summary
END		-- End spValidateApogee()
--======================================
go


IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name]= N'spValidateWise' ) 
	drop procedure spValidateWise
GO
--
CREATE PROCEDURE spValidateWise (
	@taskid int, 
	@stepid int,
	@destinationDB varchar(16)
)
-------------------------------------------------------------
--/H  Validate resolve tables  
--/A 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationDB int,   		-- Name of destination DB 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spValidateWise @taskid , @stepid, 'BestDR8'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
    	--
    	SET NOCOUNT ON

    	--- Globals
    	DECLARE	@start datetime,
		@summary bigint,
		@error bigint,
		@errorMsg varchar(1000),
		@verb varchar(16)

    -- Put out step greeting
    EXEC spNewPhase @taskid, @stepid, 'spValidateWise', 'OK', 'spValidateWise called'; 

    -------------------------------------
    SET @start  = current_timestamp
    SET @summary = 0

	---------------------
	-- test unique keys
	---------------------
	exec dbo.spTestUniqueKey  @taskid , @stepid,  'wise_allsky', 'cntr', @error OUTPUT
	set @summary = @summary + @error;

	-- generate completion message.
	IF @summary = 0 
	    BEGIN
		SET @errorMsg =   'WISE tables validated in '  
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))+ ' seconds'
		SET @verb = 'OK'
	    END
	ELSE 	
	    BEGIN
		SET @errorMsg =   'WISE tables validation found ' +str(@summary) + ' errors in ' 
			+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30)) + ' seconds'
		SET @verb = 'ERROR'
	    END

	EXEC spNewPhase @taskid, @stepid, 'spValidateWise', @verb, @errorMsg ;
	
	RETURN @summary
END		-- End spValidateWise()
--======================================
go


--======================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spValidateStep' )
	DROP PROCEDURE spValidateStep
GO
--
CREATE PROCEDURE spValidateStep (@taskid int, @stepID int output) 
----------------------------------------------------------------------
--/H Validation step, checks and augments Photo or Spectro data before publication
--/A 
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T The data has been placed in the local DB.
--/T Most of the step parameters are extracted from the task table (see code)
--/T It is destined for task.dbName
--/T It is a task.type dataload (type in (target|best|runs|plates|galspec|sspp|tiling|window))
--/T The validation step writes many messages in the Phase table.
--/T It returns stepid and either:
--/T  	0 on success (no serious problems found)
--/T    1 on failure (serious problems found).
----------------------------------------------------------------------
AS
BEGIN
	-- parameters from task table
	DECLARE 
		@type varchar(16),	-- (target|best|runs|plates|galspec|sspp|tiling|window)  
		@destinationDBbname varchar(32), -- name of the destination database.
		@id varchar(16) 	-- ID of the CSV data export task from the Linux side

        -------------------------------------------------------------------------------------
	-- Get the task parameters.  
	SELECT  
		@type=type, 
		@destinationDBbname=dbname,
		@id=[id]
		FROM loadsupport.dbo.Task WITH (nolock)
		WHERE taskid = @taskID

	-------------------------------------------------------------------------------------
	-- local variables
	DECLARE 
		@stepName varchar(16),
		@stepMsg varchar(2048),  -- holds messages to Step table
		@phaseMsg varchar(2048), -- holds messages to Phase table
		@err	int		 -- return from the helper procs (0 is good, 1 is fatal)

	-- register the step.
	SET @stepName = 'VALIDATE'  
	SET @stepMsg = 'Validating ' + @type + ' database ' + @id
	EXEC spStartStep @taskID, @stepID OUTPUT, @stepName, 'WORKING', @stepMsg, @stepMsg;

	-- if step create fails, complain and return.
	IF @stepid IS NULL
	    BEGIN
		SET @phaseMsg = 'Could not create validation step for task '  
			+ str(@taskID) + ' database ' + @id
	 	EXEC spNewPhase 0, 0, 'Framework Error', 'ERROR', @phaseMsg;
		RETURN(1);
	    END
	---------------------------------------------------------------------------------------------

	IF @type = 'plates'
	    BEGIN
		EXEC @err = spValidatePlates @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated plates ' + @id
			set @phaseMsg = 'Validated plates ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate plates ' + @id
			SET @phaseMsg = 'Failed to validate plates ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'galprod'
	    BEGIN
		EXEC @err = spValidateGalProd @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated galprod ' + @id
			set @phaseMsg = 'Validated galprod ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate galprod ' + @id
			SET @phaseMsg = 'Failed to validate galprod ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'galspec'
	    BEGIN
		EXEC @err = spValidateGalSpec @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated galspec ' + @id
			set @phaseMsg = 'Validated galspec ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate galspec ' + @id
			SET @phaseMsg = 'Failed to validate galspec ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'sspp'
	    BEGIN
		EXEC @err = spValidateSspp @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated sspp ' + @id
			set @phaseMsg = 'Validated sspp ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate sspp ' + @id
			SET @phaseMsg = 'Failed to validate sspp ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'tiles'
	    BEGIN
		EXEC @err = spValidateTiles @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated tiles ' + @id
			set @phaseMsg = 'Validated tiles ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate tiles ' + @id
			SET @phaseMsg = 'Failed to validate tiles ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'window'
	    BEGIN
		EXEC @err = spValidateWindow @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated window tables ' + @id
			set @phaseMsg = 'Validated window tables ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate window tables ' + @id
			SET @phaseMsg = 'Failed to validate window tables ' + @id
		    END
		GOTO commonExit
	    END

	IF @type = 'pm'
	    BEGIN
		EXEC @err = spValidatePm @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated pm ' + @id
			set @phaseMsg = 'Validated pm ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate pm ' + @id
			SET @phaseMsg = 'Failed to validate pm ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'mask'
	    BEGIN
		EXEC @err = spValidateMask @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated mask ' + @id
			set @phaseMsg = 'Validated mask ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate mask ' + @id
			SET @phaseMsg = 'Failed to validate mask ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'resolve'
	    BEGIN
		EXEC @err = spValidateResolve @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated resolve ' + @id
			set @phaseMsg = 'Validated resolve ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate resolve ' + @id
			SET @phaseMsg = 'Failed to validate resolve ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'apogee'
	    BEGIN
		EXEC @err = spValidateApogee @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated APOGEE ' + @id
			set @phaseMsg = 'Validated APOGEE ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate APOGEE ' + @id
			SET @phaseMsg = 'Failed to validate APOGEE ' + @id
		    END
		GOTO commonExit
	    END


	IF @type = 'wise'
	    BEGIN
		EXEC @err = spValidateWise @taskID, @stepID, @destinationDBbname 
	        IF @err = 0
		    BEGIN 
	   		set @stepMsg = 'Validated WISE ' + @id
			set @phaseMsg = 'Validated WISE ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg = 'Failed to validate WISE ' + @id
			SET @phaseMsg = 'Failed to validate WISE ' + @id
		    END
		GOTO commonExit
	    END


	IF @type in ( 'best', 'target', 'runs')
	    BEGIN
		EXEC @err = spValidatePhoto @taskID, @stepID, @type , @destinationDBbname 
	        IF @err = 0
		    BEGIN 
			SET @stepMsg =  'Validated photo ' + @type + ' id: ' + @id
			SET @phaseMsg = 'Validated photo ' + @type + ' id: ' + @id
		    END
		ELSE
		    BEGIN
		   	SET @stepMsg =  'Failed to validate photo ' + @type + ' id: ' + @id
			SET @phaseMsg = 'Failed to validate photo ' + @type + ' id: ' + @id
		    END
		GOTO commonExit
	    END

	-- if got here then we do not recognize the type 
	-- not in ('plates', 'best', 'runs', 'target', 'tiles'), give error message

	SET @err = 1
	SET @stepMsg =  'Failed to validate id: ' + @id + ' because type: ' + @type + ' is unknown'
	SET @phaseMsg = 'Failed to validate id: ' + @id + ' because type: ' + @type + ' is unknown'
   
	commonExit:	-- Common exit to end the step (based on err setting)

	-- create final logs (writes to phase table, and step table)
	IF @err = 0
	    BEGIN
	    	EXEC spEndStep @taskID, @stepID, 'DONE', @stepMsg, @phaseMsg;
		END
	ELSE
	    BEGIN
	    	EXEC spEndStep @taskID, @stepID, 'ABORTING', @stepMsg, @phaseMsg;
	    END

    RETURN @err
END
--===========================================================
GO

PRINT '[spValidate.sql]: Data validation procedures created'
GO
