--=================================================================
-- CopyDBSubset.sql 
--
-- Author: Jim Gray and Alex Szalay.
-- 
-- Create and populate a sky server database subset
--  either single file or multi-file. 
--  See examples at the end of the script.
-------------------------------------------------
-- History:
--
--* 2004-09-15 Jim: copy all of TilingGeometry, TilingRun, and TileAll
--*                 so region code works 
--* 2004-10-07 Alex, Jim: DR3 starting
--* 2004-11-15 Jim: parameterized it 
--* 2005-01-28 Jim: BestTarget2Sector replaces Best2Sector.
--* 2005-02-01 Jim: Parameterized spCopyDbSimpleTable to allow incrementalcopy 
--*                 based on primary key.  This prevents log explosion and 
--*                 opens the door for restartable copies
--*                 Also fixed spCopyDbSubset to use it on PhotoObj, PhotoTag, PhotoProfile and Frame tables
--* 2005-02-02 Jim: Fixed spCopyDbSimple "partition-key bug" where key is just a prefix of primary key. 
--*                 added batch size parmeter to spCopyDbSimple
--*                 connected the logging to Task/Step/Phase LoadSupport trace mechanism.
--* 2005-02-16 Jim: Converted to CreatePartDB2
--*                 Added copy of RC3 and Stetson
--* 2005-02-21 Jim: Copy ALL Stetson and RC3 (no subsetting)
--* 2005-03-15 Jim: Fixed "bubble sort" bug in incremental spCopyTable (target table has no index so need to use source table. 
--* 2005-04-09 Jim: Changed spCopyDbSubset()  to shrink truncate-only (not move pages) . 
--* 2006-01-28 Jim: Changed spCopyDbSubset()  to create primary keys early so DB is organized (saves time & space).
--* 2006-02-01 Jim: Added copy of Glossary, Algorithm, TableDesc, PhotoAuxAll,USNOB  
--* 2006-05-10 Jim: Added copy of PhotoAuxAll, PhotoZ2, USNOB -> ProperMotions
--*                               QsoBunch, QsoConcordanceAll, QsoCatalotAll, QsoBest, QsoTarget, QsoSpec
--*                               TargRunQA
--* 2010-01-14 Ani: Replaced ObjMask with AtlasOutline.
--=================================================================
--
if exists (select * from dbo.sysobjects where name = 'spCopyDbSimpleTable')
          drop procedure spCopyDbSimpleTable 
go
-------------------------------------------------------
--/H Helper routine for spCopyDbSimple -- copies a table
--/A --------------------------------------------------
--/T @TaskID ID of task used for load support logging
--/T @StepID ID of step used for load support logging
--/T @SourceDbName is the name of the "from" database
--/T @NewDbName is the name of the "to" database.
--/T @tableName is the name of the table to copy
--/T @whereClause is the restriction on the copy or '' if there is none.
--/T @incrementalKey is the optional key (prefix) to control incremental copies.
--/T     if specified,  @batchSize  rows at a time will be copied using that 
--/T     key as the partitioning criterion. 
--/T @batchSize is the optional (default is 5M) number of rows per incremental batch. 
--/T The routine also traces the command and its timestamp and rowcount to the phase table. 
--/T <samp>
--/T exec spCopyDbSimpleTable 'BestDr5', 'MyBestDr5', 'Chunk', ''
--/T exec spCopyDbSimpleTable 'BestDr5', 'MyBestDr5', 'PhotoObjAll', '', 'objID'
--/T </samp>
--/T See also spCopyDbSubset
-------------------------------
create procedure spCopyDbSimpleTable( 	@taskID		int,
					@stepID		int,
					@SourceDbName	 varchar(100),
					@NewDbName	 varchar(100), 
					@tableName	 varchar(100),  
					@whereClause	 varchar(8000),
					@incrementalKey  varchar(100) = '',
					@batchSize       bigint = 5000000  ) 
	as begin
	declare @cmd nvarchar(4000),
		@rows int
	if (@incrementalKey = '')
		begin
		-------------------------------------------------------------------
		-- copy whole table in one transaction. 
		set @cmd = ' insert  '       + @NewDbName    + '.dbo.' + @tableName
			 + ' select * from ' + @SourceDbName + '.dbo.' + @tableName
		if (@whereClause != '')
			set @cmd = @cmd + ' where ' + @whereClause
		execute (@cmd)
		set @rows = @@rowcount
		set @cmd = --'at ' + convert(varchar(30),current_timestamp, 8) + -- hh:mm:ss
		 	  ' inserted ' + cast(@rows as varchar(30)) + ' rows from: ' + @cmd
		exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'TABCOPY', 'OK', @cmd
		end
	else
		-------------------------------------------------------------
		-- incremental copy (5M rows per transaction.
		begin
		declare @maxKey bigint, @baseKey bigint;
		set @rows = @batchSize
		begin transaction
		set @cmd = 'select @baseKey = coalesce(max('+@incrementalKey+'),-1) from '+ @NewDbName + '.dbo.' + @tableName
		execute sp_executesql  @cmd, N'@baseKey bigint output', @baseKey output 
		commit transaction 
		set @maxKey = @baseKey
		-------------------------------------------------------------
		-- copy the table @batchsize rows at a time. 
		-- we can stop when the batchsize is bigger than the number of rows we copied last time.
		while (@rows >= @batchSize)
			begin
			begin transaction
			-------------------------------------
			-- copy the next range
			set @baseKey = @maxKey + 1
			-------------------------------------
			--compute max key for next batch.
			set @cmd = 'select @maxKey = coalesce(max('+@incrementalKey+'),0)  ' 
				 + 'from ( select top ' + cast(@batchSize as varchar(30)) + ' * '
				     + '   from ' + @SourceDbName + '.dbo.' + @tableName
				     + '   where '+@incrementalKey +' >= ' + cast(@baseKey as varchar(30))
			if (@whereClause != '')
			       set @cmd = @cmd + ' and ' + @whereClause
			set @cmd = @cmd + ' order by ' +  @incrementalKey + ' asc) T '
			execute sp_executesql  @cmd, N'@maxKey bigint output', @maxKey output  
			 
			-------------------------------------
			-- set up the incremental copy statement (notice we recopy maxKey)	
			set @cmd = 'insert ' + @NewDbName + '.dbo.' + @tableName
				   + ' select * '
				   + ' from ' + @SourceDbName + '.dbo.' + @tableName
				   + ' where '+@incrementalKey + ' between ' 
				        + cast(@baseKey as varchar(30)) + ' and ' + cast(@maxKey as varchar(30))
			if (@whereClause != '')
			       set @cmd = @cmd + ' and ' + @whereClause
			set @cmd = @cmd + ' order by ' +  @incrementalKey + ' asc '
			--------------------------------------
			-- excecute the batch copy 
			execute (@cmd)
			set @rows = @@rowcount
			commit transaction
			 
 			set @cmd =  --print 'at ' + convert(varchar(30),current_timestamp, 8) +-- hh:mm:ss
		 	   		  ' inserted ' + cast(@rows as varchar(30)) + ' rows from: ' 
			 		+ @SourceDbName + '.dbo.' + @tableName + ' to ' + @NewDbName + '.dbo.' + @tableName
			  		+ ' cmd is: ' + @cmd
			exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'TABCOPY', 'OK', @cmd
			end
		end
	end
go
if exists (select * from dbo.sysobjects where name = 'spCopyDbSubset')
          drop procedure spCopyDbSubset 
go
-------------------------------------------------------
--/H creat a (area restrictd subset) copy of the SDSS database  
--/A --------------------------------------------------
--/T @SourceDbName is the name of the "from" database
--/T @NewDbName is the name of the "new" database.
--/T @NewDbDirectory is the (list of) path names to the new database on disk, directory must exist.
--/T @NewLogDirectory is the (list of) path names to the new database's logs on disk, directory must exist
--/T @AreaRestriction is the restriction on the copy or '' if there is none.
--/T @MultiFile is a flag: if non-zero it requests multiple file groups be configured.  
--/T The routine also prints out the command and its timestamp and rowcount. 
--/T <samp>
--/T 	set @NewDbName = 'MyBestDr5'
--/T 	set @AreaRestriction = 'ra between 193.75 and 196.25 and dec between 1.25 and 3.75'
--/T 	set @SourceDbName = 'BestDr5'
--/T 	set @NewDbDirectory =   'F:\sql_db\'	
--/T 	set @NewLogDirectory =  'F:\sql_db\'	
--/T 	exec spCopyDbSubset 'BESTDR5', 'BEST', @sourceDbName, @NewDbName, 
--/T 	                    @NewDbDirectory, @NewLogDirectory, 
--/T 	                    @AreaRestriction, 0
--/T </samp>
--/T See also spCopyDbSimpleTable
-------------------------------
create procedure spCopyDbSubset( 	@SourceDataSet	 	varchar(100),  -- "BESTDR5" or...
					@SourceDataSetType	 varchar(100), -- "BEST" or "TARGET" or...
					@SourceDbName	 varchar(100),
					@NewDbName	 varchar(100), 
					@NewDbDirectory	 varchar(100), 
					@NewLogDirectory varchar(100), 
					@AreaRestriction varchar(1000),
					@MultiFile       int)
	as begin
	set nocount on;
	set transaction isolation level read uncommitted
	declare @DbDescription  varchar(256),
		@cmd  nvarchar(4000),
		@test varchar(4000),
		@err int,		-- return from command execution
   		@taskid int,
		@stepid int,
		@status varchar(64),
		@stepmsg varchar(2000),
		@phasemsg varchar(2000) 
 
    	--------------------------------------------------------------------------
	-- create the database
	set @test = ''
	set @DbDescription = @NewDbName + ' is a copy of Skyserver DB: ' +@SourceDbName + ' in region ' + @AreaRestriction  
	set @stepmsg = 'spCopyDbSubset: ' + ' ' + @DbDescription
    	exec loadSupport.dbo.spNewTask @NewDbName, @SourceDataSet , @SourceDataSetType, @NewDbDirectory, '', @stepmsg, @taskID output;
    	exec loadSupport.dbo.spNewStep @taskID, 'CopyCreate','OK',  @stepmsg, @stepID output;
    	exec loadSupport.dbo.spNewPhase @taskID, @stepID, 'CopyCreate','OK',  @stepmsg 
    	exec loadSupport.dbo.spNewPhase @taskID, @stepID, 'CopyDelete','OK',  'First deleting old database'
	if (exists (select [name] from master.dbo.sysdatabases where upper(name) = upper(@NewDbName)))
		begin
    		exec loadSupport.dbo.spNewPhase @taskID, @stepID, 'CopyDelete','OK',  'First deleting old database'
		set @cmd = ' drop database ' +@NewDbName
		exec(@cmd)
		end
    	exec loadSupport.dbo.spNewPhase @taskID, @stepID, 'CopyCreate','OK',  'Now Creating new database'
	declare @MillionObjects bigint, @ParmDefinition nvarchar(500)
	set @ParmDefinition = N'@MillionObjects bigint OUTPUT'
	if @areaRestriction != ''
		set @cmd  = 'select @MillionObjects=count_big(*) from ' +@SourceDbName + '.dbo.PhotoObjAll  where ' + @areaRestriction	
	else
		set @cmd  = 'select @MillionObjects=count_big(*) from ' +@SourceDbName + '.dbo.PhotoObjAll ' 	
	
	execute sp_executesql @cmd, @ParmDefinition, @MillionObjects = @MillionObjects OUTPUT  
	set @MillionObjects = 1 +  @MillionObjects /1e6
	set @cmd = 'loadSupport.dbo.spCreatePartDB2 ''' +  @NewDbName 
                        + ''', ''' + @SourceDataSet + ''', ''' + @SourceDataSetType +''', ''' 
			+  @NewDbDirectory + ''' , ''' + @NewLogDirectory + ''' ,  ' 
		 	+ cast(@MillionObjects  as varchar(30)) 
			+ ' , ' + cast (@MultiFile as varchar(5))
		 	+ ' , ''''' -- null list of key types
		   	+ ' , ' +  cast(@taskID as varchar(30))
	exec (@cmd )
	---------------------------------------------------------------------------
	-- inherit taskid from the create step
	--select @taskID = max(taskID) from LoadSupport.dbo.Task	 
    	set @stepmsg = 'spCopyDbSubset created DB, now starting database copy'
    	exec loadSupport.dbo.spNewStep  @taskID, 'COPY','WORKING', @stepmsg, @stepID output;
    	exec loadSupport.dbo.spNewPhase @taskID, @stepID, 'Copy','OK', @stepmsg

	-------======================================================================
	-- declare primary keys so that target DB is loaded in organized way. 
	-- exec spIndexBuildSelection @taskID,@stepID,'K', 'ALL'
	set @cmd =  @NewDbName + '.dbo.spIndexBuildSelection ' 
		  + cast( @taskID as varchar(30)) + ' , ' + cast(@stepID as varchar(30)) + ', ''K'', ''ALL'''
	exec loadSupport.dbo.spNewPhase @taskid, @stepid, 'BUILDK', 'OK', @cmd
	execute( @cmd )
  
	--****************************************************************
	-- truncate table History
	--*****************************************************************
	--
	-- DataConstants already done
	-- DBobjects already done -- 277 rows
	-- DBcolumns already done -- 1652 rows
	-- DBObjDescription  -- 0 ****************
	-- DBViewCols -- 96 rows
	-- insert Algorithm   select * from BestDrN..Algorithm  		--  23 rows  
	-- execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Algorithm', '' 
	-- insert Diagnostics select * from BestDrN..Diagnostics  		-- 483 rows 
	-- execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Diagnostics', '' 
	-- insert FileGroupMap
	--	select tableName, 'PRIMARY', 'PRIMARY', comment 
	--	from BestDrN..FileGroupMap   				-- 46 rows supressed
	-- insert Glossary select * from BestDrN..Glossary  		-- 165 rows  
	-- execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Glossary', '' 
	-- execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TableDesc', '' 
	-- insert History     select * from BestDrN..History  		--  1 rows
	-- insert IndexMap
	--	select code, type, tableName, fieldList, foreignKey, indexGroup 
	--	from BestDrN..IndexMap   				--  161 rows
	-- insert LoadHistory select * from BestDrN..LoadHistory  		--  130 rows 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'LoadHistory', '' 
	-- insert PubHistory  select * from BestDrN..PubHistory  		-- 1496 rows  
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'PubHistory', '' 
	--insert PartitionMap select * from BestDrN..PartitionMap  	--   11 rows set by build
	--insert ProfileDefs select * from BestDrN..ProfileDefs  	--   15 rows set by build 
	--insert RunShift	   select * from BestDrN..RunShift	--    9 rows set by build
	------ SdssConstants						--   42 rows set by build
	--  update siteConstants set value ='Personal Subset DrN' where name = 'DB Type'
	set @cmd = ' update ' + @NewDbName + '.dbo.siteConstants '
		 + '  set value   = ''' + @SourceDbName  + ''''
  		 + ',     comment = ''' + @DbDescription + ''''  
		 + ' where name = ''DB Type'''
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'COPY', 'OK', @cmd
	execute( @cmd )
	-- insert SiteDiagnostics select * from BestDrN..SiteDiagnostics  	--  483 rows  
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'SiteDiagnostics', '' 
	--insert TableDesc select * from BestDrN..TableDesc  		--  87 rows  
	------ DB documenttion and layout
	------
	--insert QueryResults select * from BestDrN..QueryResults  	-- 111 rows
	----
	-- SPECTRA
	if (1 = (select count(*) from tempdb.dbo.sysobjects where name = N'#Objects')) 
		drop table #objects
	create table #Objects(ObjID bigint not null primary key)
	declare @specTest nvarchar(1000)
	set @specTest = ''
	if (@AreaRestriction != '')
		begin
		set @cmd = ' insert #Objects select specObjID ' 
			+  ' from '  + @SourceDbName + '.dbo.SpecObjAll '
			+  ' where ' + @AreaRestriction
		execute (@cmd)
		set @specTest = 'specObjId in (select ObjId from #Objects)'
		end 	
        
	-- insert specObjAll  select * from BestDrN..specObjAll  	-- 806 rows 
	--	where ra between 193.75 and 196.25
	--	and  dec between   1.25 and   3.75
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'specObjAll', @specTest 
	-- insert specLineAll  select * from BestDrN..specLineAll		-- 38,312 rows
	--	where specObjID in (select specObjID from SpecObjAll) 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'specLineAll', @specTest 
	-- insert SpecLineIndex  select * from BestDrN..SpecLineIndex	-- 27,648 rows
	--	where specObjID in (select specObjID from SpecObjAll) 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'SpecLineIndex', @specTest 
	-- 	where specObjID in (select specObjID from SpecObjAll) 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'ElRedshift', @specTest 
	-- insert XCredshift  select * from BestDrN..XCredshift		--40,704 rows
	--	where specObjID in (select specObjID from SpecObjAll) 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'XCredshift', @specTest 
	-- insert SpecPhotoAll select * from BestDrN..SpecPhotoAll	-- 806 rows   
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'SpecPhotoAll', @specTest 
	-- insert PlateX  select * from BestDrN..PlateX			-- 5 rows
	--	where plateID in (select plateID from SpecObjAll)
	if (@AreaRestriction != '')
		set @specTest = ' plateID in (select plateID from ' + @NewDbName + '.dbo.SpecObjAll) '
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'PlateX',  @test 
	-- Done with spectra
	-- hope this reclaims some log space
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )
	-- hope this reclaims some log space
	truncate table #Objects
	-- insert HoleObj     select * from BestDrN..HoleObj		-- 26 rows
	-- 	where ra between 193.75 and 196.25
	-- 	and  dec between   1.25 and   3.75
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'HoleObj', @AreaRestriction 
	-- insert Target select * from BestDrN..Target			-- 2,418  rows  
	-- 	where ra between 193.75 and 196.25
	-- 	and  dec between   1.25 and   3.75
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Target', @AreaRestriction 
	-- insert TargetParam select * from BestDrN..TargetParam	-- 0 rows 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TargetParam', '' 
	-- insert TargetInfo select * from BestDrN..TargetInfo		-- 2,418 rows 
	-- 	where TargetObjID in (select TargetID from target )
	if (@AreaRestriction != '')
		set @test = ' TargetObjID in (select TargetID from ' + @NewDbName + '.dbo.target)'
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TargetInfo',@test  
	-- insert TileAll  select * from BestDrN..TileALL			-- 962 rows 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TileAll', '' 
	--	where tile in (select tile from PlateX)
	-- insert TiledTargetAll  select * from BestDrN..TiledTargetAll	-- 607,360 rows
	-- 	where tile in (select tile from Tile)
	if (@AreaRestriction != '')
		set @test = ' tile in (select tile from ' + @NewDbName + '.dbo.Tile) '
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TiledTargetAll', @test, 'targetID',     5e6  
	-- insert TilingRun  select * from BestDrN..TilingRun		-- 53 rows
	--	where tileRun in (select tileRun from TileAll)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TilingRun', '' 
	-- insert TilingNote  select * from BestDrN..TilingNote		-- 0 rows
	--	where tileRun in (select tileRun from tilingRun)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TilingNote', '' 
	-- insert TilingInfo  select * from BestDrN..TilingInfo		-- 557,647 rows
	--	where tileRun in (select tileRun from tilingRun) 
	if (@AreaRestriction != '')
		set @test =  ' tileRun in (select tileRun from ' + @NewDbName + '.dbo.tilingRun)'
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TilingInfo', @test 
	-- insert TilingGeometry  select * from BestDrN..TilingGeometry	-- 165 rows  
	--	where tileRun in (select tileRun from tilingRun)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TilingGeometry', ''  
	--- shorten the log.
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )
	------ Photo files (incremental copy of PhotoObjAll, PhotoTag, PhotoProfile
	--insert ProfileDefs  select * from BestDrN..ProfileDefs  	-- 15 rows  
	--insert Rmatrix      select * from BestDrN..Rmatrix  		--   6 rows  
	
	-- insert photoObjAll     select * from BestDrN..photoObjAll   	-- 200,276 rows  
	-- 	where ra between 193.75 and 196.25			 
	-- 	and  dec between   1.25 and   3.75	
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
						'photoObjAll', @AreaRestriction , 'objID', 1e6
	-- insert photoTag  select * from BestDrN..photoTag  		-- 200,276 rows   
	-- 	where ra between 193.75 and 196.25			   
	-- 	and  dec between   1.25 and   3.75	
	--- shorten the log.
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
						'photoTag',    @AreaRestriction , 'objID',  5e6
	--- shorten the log.
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )
	if (@AreaRestriction != '')
		begin
		truncate table #Objects
		set @cmd = ' insert #Objects select ObjID ' 
			+  ' from '  + @NewDbName + '.dbo.PhotoTag ' 
		execute (@cmd)
		set @test = ' objID in (select  objID from  #Objects)'
		end
        execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName,
						'PhotoAuxAll', @test, 'objID', 25e6 
	-- insert MaskedObject  select * from BestDrN..MaskedObject	-- 2,100  rows 
	-- 	where objID in (select  objID from PhotoTag)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
						'MaskedObject', @test , 'objID', 20e6  
	-- insert AtlasOutline  select * from BestDrN..AtlasOutline			-- 193,996 rows
	-- 	where objID in (select  objID from PhotoTag)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
						'AtlasOutline',      @test , 'objID', 20e6 
	--insert PhotoProfile  select * from BestDrN..PhotoProfile	-- 6,981,758 rows 
	--	where objID in (select  objID from PhotoTag)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
						'PhotoProfile', @test , 'objID', 25e6 
	-- insert PhotoZ  select * from BestDrN..PhotoZ			-- 0 rows 
	-- 	where objID in (select  objID from PhotoTag)
	--- shorten the log.
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
						'PhotoZ',        @test , 'objID', 10e6
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
						'PhotoZ2',       @test , 'objID', 10e7
	-- insert First  select * from BestDrN..First			-- 163 rows
	-- 	where objID in (select  objID from PhotoTag)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'First', @test 
	-- insert USNO  select * from BestDrN..USNO			-- 21,422 
	-- 	where objID in (select  objID from PhotoTag)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'USNO',  @test 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'ProperMotions', @test, 'objID', 1e7 
	-- insert Rosat  select * from BestDrN..Rosat			-- 323 rows
	-- 	where objID in (select  objID from PhotoTag)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Rosat', @test
	-- copy all of RC3 and Stetson 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'RC3',   '' 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Stetson','' 
	--- shorten the log.
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )
	-- insert zone  select * from BestDrN..zone			-- 162,657 rows
	-- 	where objID in (select  objID from PhotoTag)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
					'Zone', @test, 'zoneID' ,25e6
	-- insert Neighbors  select * from BestDrN..Neighbors		-- 1,057,304 rows
	--	where objID in (select objID from PhotoTag)
	--	and neighborObjID in (select  objID from PhotoTag)
	if (@AreaRestriction != '')
		set @test =  '             objID in (select objID from #Objects) '
		 	   + ' and neighborObjID in (select objID from #Objects) '
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 
					'Neighbors', @test, 'objID', 25e6 
	--- shorten the log.
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )
	-- insert Match  select * from BestDrN..Match			-- 22,276 rows 
	-- 	where objID1 in (select  objID from PhotoTag)
	-- 	  and objID2 in (select  objID from PhotoTag)
	if (@AreaRestriction != '')
		set @test = '     objID1 in (select objID from #Objects) '
		 	  + ' and objID2 in (select objID from #Objects) '
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Match', @test 
	-- insert MatchHead select * from BestDrN..MatchHead  		-- 11,126rows 
	-- 	where objID in (select  matchHead from Match)
	if (@AreaRestriction != '')
		set @test = ' objID in (select matchHead from ' + @NewDbName + '.dbo.Match) '
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'MatchHead', @test 
	-- insert Field  select * from BestDrN..Field			-- 251 rows 
	-- 	where fieldid in (select fieldid from PhotoTag)
	if (@AreaRestriction != '')
		set @test = ' fieldid in (select fieldid from ' + @NewDbName + '.dbo.PhotoTag) '
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Field', @test 
	-- insert RunQA select * from BestDrN..RunQA			-- 251 rows 
	-- 	where fieldID in (select fieldID from Field)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'RunQA',     @test 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'TargRunQA', @test 
	-- insert FieldProfile  select * from BestDrN..FieldProfile	-- 12,408 rows 
	-- 	where fieldID in (select fieldID from Field)'
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'FieldProfile', @test 
	-- insert Frame  select * from BestDrN..Frame			-- 1,004 rows 
	-- 	where fieldID in (select fieldID from Field)
	-- 	and zoom in (0,10,20,30)
	if (@AreaRestriction != '')
		set @test = @test + ' and zoom in (0,10,20,30)'
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Frame', @test, 'fieldID' 
	--- shorten the log.
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )
	-- insert Mask	   select distinct m.* 				-- 18,965  rows  
	-- 		   from field f join BestDrN..Mask m 
	-- 		         on f.run    = m.run
	--        		and f.rerun  = m.rerun
	-- 			and f.camcol = m.camcol
	-- 			and f.field  = m.field
	if (@AreaRestriction != '') 
		set @cmd = ' insert ' + @NewDbName + '.dbo.Mask '
			 + ' select distinct m.* '
			 + ' from ' + @NewDbName + '.dbo.Field f join ' + @SourceDbName + '.dbo.Mask m '
			 + '             on f.run    = m.run '
			 + '            and f.rerun  = m.rerun '
			 + '            and f.camcol = m.camcol '
			 + '            and f.field  = m.field '
	else 
		set @cmd = ' insert ' + @NewDbName + '.dbo.Mask '
			 + ' select distinct m.* '
			 + ' from ' + @SourceDbName + '.dbo.Mask m '		
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'TABCOPY', 'OK', @cmd
	execute( @cmd )
	-- insert Segment  select * from BestDrN..Segment		-- 1248 rows 
	--	where segmentID in (select segmentID from Field)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Segment', '' 
	-- insert Chunk  select * from BestDrN..Chunk			-- 71 rows 
	-- 	where chunkID in (select chunkID from segment) 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Chunk', '' 
	--insert StripeDefs  select * from BestDrN..StripeDefs		-- 3 rows set by spCreateNullDB
	--	where [stripe] in (select [stripe] from chunk) 
	------------Target stuff
	if (@AreaRestriction != '')
		set @test = ' objID in (select objID from #Objects)'
	-- insert BestTarget2Sector  select * from BestDrN..BestTarget2Sector -- 9,256 rows  
	-- 	where objID in (select  objID from PhotoTag)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'BestTarget2Sector', @test 
	-- insert Sector select * from BestDrN..Sector			-- 16,890 rows 
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Sector', ''
	-- insert Region2Box select * from BestDrN..Region2Box		-- 362 rows
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Region2Box', ''

	if (@AreaRestriction != '') drop table #Objects

	--==================================================================
	-- set identity_insert region on					-- 22,101 rows 
	--   insert region (regionID, [id],  type, comment, ismask, area, regionString, sql, xml)
	--     	select regionID, [id],  type, comment, ismask, area, regionString, sql, xml 
	-- 	from  BestDrN..region
	-- 	where regionID in (select regionID from Sector) 
	--  set identity_insert region off	                          
	set @cmd = ' set identity_insert  ' + @NewDbName + '.dbo.region on ; '
	set @cmd = @cmd  
		 + ' insert ' + @NewDbName + '.dbo.region (regionID, [id],  type, comment, ismask, area, regionString, sql, xml)'
		 + ' select regionID, [id],  type, comment, ismask, area, regionString, sql, xml  '
		 + ' from ' + @SourceDbName + '.dbo.region ;'  
	set @cmd = @cmd  
		 + ' set identity_insert  ' + @NewDbName + '.dbo.region off '
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'TABCOPY', 'OK', @cmd
	execute(@cmd)                              
	
	-- insert RegionConvex ( regionID, convexID, type, radius, ra, dec, x,y,z,c, htmID, convexString ) -- 16,571 rows 
	-- 	select regionID, convexID, type, radius, ra, dec, x,y,z,c, htmID, convexString 
	-- 	from BestDrN..RegionConvex					 
	-- 	where regionID in (select regionID from region)
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'RegionConvex', ''
	-- set identity_insert RegionArcs on				-- 105,179 rows  
	-- insert RegionArcs ( regionID, convexID, constraintID, patch, state, draw, ra1, dec1, ra2, dec2, x,y,z,c, length, arcid )
	-- 	select regionID, convexID, constraintID, patch, state, draw, ra1, dec1, ra2, dec2, x,y,z,c, length, arcid
	-- 	from BestDrN..RegionArcs					 
	--	where regionID in (select regionID from region)
	-- set identity_insert RegionArcs off
	set @cmd = ' set identity_insert  ' + @NewDbName + '.dbo.RegionArcs on ; '
	set @cmd = @cmd  
		 + ' insert ' + @NewDbName + '.dbo.RegionArcs  ( regionID, convexID, constraintID, patch, state, draw, ra1, dec1, ra2, dec2, x,y,z,c, length, arcid )'
		 + ' select regionID, convexID, constraintID, patch, state, draw, ra1, dec1, ra2, dec2, x,y,z,c, length, arcid '
		 + ' from ' + @SourceDbName + '.dbo.RegionArcs ;'  
	set @cmd = @cmd  
		 + ' set identity_insert  ' + @NewDbName + '.dbo.RegionArcs off '
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'TABCOPY', 'OK', @cmd
	execute(@cmd) 
	-- set identity_insert HalfSpace on				-- 101,327 rows  
	-- insert HalfSpace ( constraintID, regionID, convexID, x,y,z,c )
	--	select constraintID, regionID, convexID, x,y,z,c 
	--	from BestDrN..HalfSpace					 
	--	where regionID in (select regionID from region)
	--set identity_insert HalfSpace off
	--
	set @cmd = 'set identity_insert  ' + @NewDbName + '.dbo.HalfSpace on ; '
	set @cmd = @cmd  
		 + ' insert ' + @NewDbName + '.dbo.HalfSpace ( constraintID, regionID, convexID, x,y,z,c ) '
		 + ' select constraintID, regionID, convexID, x,y,z,c '
		 + ' from ' + @SourceDbName + '.dbo.HalfSpace ; ' 
	set @cmd = @cmd  
		 + 'set identity_insert  ' + @NewDbName + '.dbo.HalfSpace off '
	exec loadsupport.dbo.spNewPhase @taskID, @stepID, 'TABCOPY', 'OK', @cmd
	execute(@cmd) 
	
	-- insert Sector2Tile select * from BestDrN..Sector2Tile  		-- 65,936 rows   
	-- 	where tile in (select tile from TileAll) 
	if (@AreaRestriction != '')
		set @test = ' tile in (select tile from ' + @NewDbName + '.dbo.TileAll) '
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'Sector2Tile', @test

	------------------------------------------------------------------------------
	---  copy QSO catalogs.			 
	--   insert QsoCatalogAll select * from BestDrN..QsoBunch	 
	-- 	where ra between 193.75 and 196.25			 
	-- 	and  dec between   1.25 and   3.75	
        if @AreaRestriction != '' set @test = ' HeadObjID = 0 or ' + @AreaRestriction
 	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'QsoBunch', @test
	-- insert QsoConcordance select * from BestDrN..QsoConcordance	 
	-- 	where ra between 193.75 and 196.25			 
	-- 	and  dec between   1.25 and   3.75
	if @AreaRestriction != '' set @test = 'HeadObjID = 0 or '
			                    + 'HeadObjID in (select HeadObjID from  ' + @NewDbName + '.dbo.QsoBunch)' 
			     else set @test = ' 1 = 1 ' -- null test
	set @cmd= ' insert ' + @NewDbName + '.dbo.QsoConcordanceAll '
		+ ' select '
		+ '[HeadObjID], [QsoPrimary], [TargetObjID], [SpecObjID], [BestObjID],'
		+ '[TargetQsoTargeted], [SpecQsoConfirmed], [SpecQsoUnknown], [SpecQsoLargeZ], '
		+ '[SpecQsoTargeted], [BestQsoTargeted], [dist_Target_Best], [dist_Target_Spec], '
		+ '[dist_Best_Spec], [psfmag_i_diff], [psfmag_g_i_diff], [SpecRa], [SpecDec], [SpecCx], '
		+ '[SpecCy], [SpecCz], [SpecZ], [SpecZerr], [SpecZConf], [SpecZStatus], [SpecZWarning], '
		+ '[SpecClass], [SpecPlate], [SpecFiberID], [SpecMjd], [SpecSciencePrimary], [SpecPrimTarget], '
		+ '[SpecTargetID], [SpecTargetObjID], [SpecBestObjID], [SpecLineID], [SpecMaxVelocity], [SpecPlateSn1_i], '
		+ '[SpecPlateSn2_i], [targetRa], [targetDec], [targetCx], [targetCy], [targetCz], [targetPsfMag_u], '
		+ '[targetPsfMag_g], [targetPsfMag_r], [targetPsfMag_i], [targetPsfMag_z], [targetPsfMagErr_u], '
		+ '[targetPsfMagErr_g], [targetPsfMagErr_r], [targetPsfMagErr_i], [targetPsfMagErr_z], [targetExtinction_u], '
		+ '[targetExtinction_g], [targetExtinction_r], [targetExtinction_i], [targetExtinction_z], [targetType], '
		+ '[targetMode], [targetStatus], [targetFlags], [targetFlags_u], [targetFlags_g], [targetFlags_r], '
		+ '[targetFlags_i], [targetFlags_z], [targetRowC_i], [targetColC_i], [targetInsideMask], [targetPrimTarget], '
		+ '[targetPriTargHiZ], [targetPriTargLowZ], [targetPriTargFirst], [targetFieldID], [targetFieldMjd], '
		+ '[targetFieldQuality], [targetFieldCulled], [targetSectorID], [targetFirstID], [targetFirstPeak], '
		+ '[targetRosatID], [targetRosatCps], [targetMi], [targetUniform], [bestRa], [bestDec], [bestCx], [bestCy], '
		+ '[bestCz], [bestPsfMag_u], [bestPsfMag_g], [bestPsfMag_r], [bestPsfMag_i], [bestPsfMag_z], [bestPsfMagErr_u],' 
		+ '[bestPsfMagErr_g], [bestPsfMagErr_r], [bestPsfMagErr_i], [bestPsfMagErr_z], [bestExtinction_u], '
		+ '[bestExtinction_g], [bestExtinction_r], [bestExtinction_i], [bestExtinction_z], [bestType], [bestMode], '
		+ '[bestFlags], [bestFlags_u], [bestFlags_g], [bestFlags_r], [bestFlags_i], [bestFlags_z], [bestRowC_i], '
		+ '[bestColC_i], [bestInsideMask], [bestPrimTarget], [bestPriTargHiZ], [bestPriTargLowZ], [bestPriTargFirst], '
		+ '[bestFieldID], [bestFieldMjd], [bestFieldQuality], [bestFieldCulled], [bestFirstID], [bestFirstPeak], '
		+ '[bestRosatID], [bestRosatCps], [bestMi] '
		+ ' from ' + @SourceDbName + '.dbo.QsoConcordanceAll ' 
		+ ' where ' + @test + ' ;'
	execute (@cmd)
	--execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'QsoConcordanceAll', @test 
	if @AreaRestriction != '' set @test = ' HeadObjID in (select HeadObjID from  ' + @NewDbName + '.dbo.QsoBunch)' 
 	set @cmd = ' insert ' + @NewDbName + '.dbo.QsoCatalogAll '
		 + ' select '
		 + ' [HeadObjID],  [QsoPrimary], [HeadObjType], [TargetObjID], [SpecObjID], [BestObjID], [TargetQsoTargeted], '
		 + ' [SpecQsoConfirmed], [SpecQsoUnknown], [SpecQsoLargeZ], [SpecQsoTargeted], [BestQsoTargeted], [dist_Target_Best], '
		 + ' [dist_Target_Spec], [dist_Best_Spec], [psfmag_i_diff], [psfmag_g_i_diff] '
		 + ' from ' + @SourceDbName + '.dbo.QsoCatalogAll ' 
		 + ' where ' + @test + ' ;'
	execute (@cmd)
--	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'QsoCatalogAll',     @test  
	if @AreaRestriction != '' set @test = 'BestObjID = 0 or '
			                    + 'HeadObjID in (select HeadObjID from  ' + @NewDbName + '.dbo.QsoBunch)' 	
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'QsoBest',           @test  
	if @AreaRestriction != '' set @test = 'TargetObjID = 0 or '
			                    + 'HeadObjID in (select HeadObjID from  ' + @NewDbName + '.dbo.QsoBunch)' 	
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'QsoTarget',         @test  
	if @AreaRestriction != '' set @test = 'SpecObjID = 0 or '
			                    + 'HeadObjID in (select HeadObjID from  ' + @NewDbName + '.dbo.QsoBunch)' 	
	execute spCopyDbSimpleTable  @taskid, @stepid, @SourceDbName, @NewDbName, 'QsoSpec',           @test  
	--- shorten the log.
	exec loadSupport.dbo.spNewPhase @taskid, @stepid, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )

	-------======================================================================
	-- done, build indices 
	-- exec spIndexBuildSelection @taskID,@stepID,'I,F', 'ALL'
	set @cmd =  @NewDbName + '.dbo.spIndexBuildSelection ' 
		  + cast( @taskID as varchar(30)) + ' , ' + cast(@stepID as varchar(30)) + ', ''I'', ''ALL'''
	exec loadSupport.dbo.spNewPhase @taskid, @stepid, 'BUILDI', 'OK', @cmd
	execute( @cmd )
	set @cmd =  @NewDbName + '.dbo.spIndexBuildSelection ' 
		  + cast( @taskID as varchar(30)) + ' , ' + cast(@stepID as varchar(30)) + ', ''F'', ''ALL'''
	exec loadSupport.dbo.spNewPhase @taskid, @stepid, 'BUILDFK', 'OK', @cmd
	execute( @cmd )

	--- shorten the log.
	exec loadSupport.dbo.spNewPhase @taskid, @stepid, 'CHECKPT', 'OK', 'checkpoint'
	set @cmd = 'use  ' + @NewDbName + '; checkpoint '
	execute( @cmd )

	-------======================================================================
	-- reorg anything that is fragmented. (assume things are organized for now)
	--set @cmd =  @NewDbName +'.dbo.spReorg'
	--exec dbo.spNewPhase @taskid, @stepid, 'REORG', 'OK', @cmd
	--execute( @cmd )

	-------======================================================================
	--  Shrink DB (truncating space at the end) -- don't do any disorganization. 
	exec loadSupport.dbo.spNewPhase @taskid, @stepid, 'SHRINK', 'OK', @cmd
	SET @cmd = 'DBCC SHRINKDATABASE  ( N''' + @NewDbName + ''', 1, TRUNCATEONLY )  WITH  NO_INFOMSGS '
	execute( @cmd )

	-- say goodbye
   	EXEC loadsupport.dbo.spEndStep @taskID, @stepID, OK, 'spCopyDbSubset complete.', 'spCopyDbSubset complete.';
   	EXEC loadsupport.dbo.spDone @taskID ;
 
	end
GO
PRINT '[spCopyDbSubset]: spCopyDbSubset installed'
GO