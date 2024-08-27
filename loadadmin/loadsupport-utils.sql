--========================================================
-- loadsupport-utils.sql
-- 2002-10-04	Alex Szalay and Jim Gray
----------------------------------------------------------
--* 2002-11-25 Alex: added spBulkInsertCsvFile
--* 2002-12-01 Alex: changed spCreatePubDB to use the new
--*		metadata scripts instead of DTS load
--* 2003-05-15 Alex: added RECOVERY BULK_LOGGED option to DB
--* 2003-06-03 Ani: Replaced 'loadagent' with variable @loadagent.
--* 2003-07-08 Ani: Fixed bug in loadagent variable declare - needs to
--*             be local to each procedure; also commented out 
--*		transaction stuff in spCreateSqlAgentJob.
--* 2003-08-20 Ani: Region functions added.
--* 2003-12-03 Jim: SpCreateDatabase modified to use AlterDB and to 
--*		use settings as per SQL Best Practices analyzer.
--* 2004-09-17 Alex: created new spLoadMetaData, and modified spCreateNullDB,
--*		and spCreatePubDb
--* 2004-09-23 Alex: move spLoadMetaData over to the main database schema
--* 2004-09-27 Alex: added support for Filegroups in spCreateSchema, 
--*		added spRunShellScript, token manipulation functions,
--* 		and spCreateFileGroups;
--* 2004-09-27 Alex: created spCreatePartitonsDB
--* 2004-12-03 Alex+Jim: patched path for root database directory in spCreatePartDB,
--*		and added creation of default data and log directories if they do
--*		not exist.
--* 2005-01-15 Ani: Changed owner of load/pub sql agent jobs to 'sa' instead
--*            of user running the loader.
--* 2005-02-17 Alex+Jim: added CeateFileGroups2 to unify DB create procedures
--* 2005-03-19 Jim: Fixed CreateFileGroups2 to create a log that is 10% of DB (not 10,000% :) )
--* 2005-04-09 Jim: Fixed CreateFileGroups2 to skip log growth if there is no growth (avoids error)
--* 2005-05-18 Ani: Updated spNewFinishStep to include the step name in
--*            the new task it creates, so the task will start at that step.
--* 2006-07-28 Ani: Modified spCreateDatabase to print warning if data or log file size is 0, and
--*            also to print the actual SQL Server error description to the log if the create fails.
--* 2006-11-22 Ani: Modified spCreateSchema to add the dbtype to the name of
--*            file that contains the list of schema files for TARG db.
--* 2006-11-28 Ani: Fix for PR #7167: removed extra comma from spNewFinishStep
--*		    declaration and removed 'phase' and 'mode' from Task
--*		    table insert command.
--* 2007-12-13 Svetlana: added code to deploy spherical assembly in spCreateSchema 
--* 2024-08-27 Sue: got rid of sp_dboption stuff
--========================================================
SET NOCOUNT ON
GO

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- service routines for parsing
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fNormalizeString]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fNormalizeString]
GO
--
CREATE FUNCTION fNormalizeString(@s VARCHAR(8000)) 
RETURNS VARCHAR(8000)
-------------------------------------------------------------
--/H Returns string upshifted, squeezed blanks, trailing zeros 
--/H removed, and blank added on end
-------------------------------------------------------------
--/T <br>select dbo.fNormalizeString('Region Convex   3.0000   5  7') 
--/T <br> returns                    'REGION CONVEX 3.0 5 7 '
--/T </samp>  
-------------------------------------------------------------
AS	
BEGIN
	DECLARE @i int;
	-----------------------------------------------------
	-- discard leading and trailing blanks, and upshift
	-----------------------------------------------------
	SET @s = ltrim(rtrim(upper(@s))) + ' '
	---------------------------
	-- replace comma with blank
	---------------------------
	SET @s = replace(@s, ',', ' ');
	---------------------------
	-- eliminate trailing zeros
	---------------------------
	SET @i = patindex('%00 %', @s)
	----------------------
	-- trim trailing zeros
	----------------------
	WHILE(@i >0)			
 		BEGIN
 		SET @s = replace(@s, '0 ', ' ') 
 		SET @i = patindex('%00 %', @s)
 		END
	----------------------------
	-- eliminate multiple blanks
	----------------------------
	SET @i = patindex('%  %', @s)
	---------------------
	-- trim double blanks
	---------------------
	WHILE(@i >0)			
 		BEGIN
 		SET @s = replace(@s, '  ', ' ')
 		SET @i = patindex('%  %', @s)
 		END
	------------------
	-- drop minus zero
	------------------
 	SET @s = replace(@s, '-0.0 ', '0.0 ') 
	RETURN @s 
END

GO

--==========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fTokenAdvance]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fTokenAdvance]
GO
--
CREATE FUNCTION fTokenAdvance(@s VARCHAR(8000), @i int) 
RETURNS INT
-------------------------------------------------------------
--/H Get offset of next token after offset @i in string @s
-------------------------------------------------------------
--/T Return 0 if none found.
--/T <br><samp>
--/T <br>select dbo.fTokenNext('REGION CONVEX 3 5 7 ',15 ) 
--/T <br> returns                    '3'
--/T </samp>
--/T <br> see also fTokenNext()  
-------------------------------------------------------------
AS
BEGIN
	DECLARE @j int;

	-----------------------------
	-- eliminate multiple blanks
	-----------------------------
	SET @j = charindex(' ',@s,@i)
	IF (@j >0) RETURN @j+1
	RETURN 0
END
GO


--============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fTokenNext]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fTokenNext]
GO
--
CREATE FUNCTION fTokenNext(@s VARCHAR(8000), @i int) 
RETURNS VARCHAR(8000)
-------------------------------------------------------------
--/H Get token starting at offset @i in string @s
-------------------------------------------------------------
--/T Return empty string '' if none found
--/T <br><samp>
--/T <br>select dbo.fTokenNext('REGION CONVEX 3 5 7 ',15 ) 
--/T <br> returns                    '3'
--/T </samp>
--/T <br> see also fTokenAdvance()  
-------------------------------------------------------------
AS
BEGIN
	DECLARE @j INT
	-- eliminate multiple blanks
	SET @j = charindex(' ',@s,@i)
	IF (@j >0) RETURN ltrim(rtrim(substring(@s,@i,@j-@i)))
	RETURN ''
	END
GO


--===============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fTokenStringToTable]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fTokenStringToTable]
GO

--
CREATE FUNCTION fTokenStringToTable(@types VARCHAR(8000)) 
RETURNS @tokens TABLE (token VARCHAR(256) NOT NULL)
-------------------------------------------------------------
--/H Returns a table containing the tokens in the input string
-------------------------------------------------------------
--/T Tokens are blank or comma separated.
--/T <samp>select * from dbo.fTokenStringToTable('A B C D') 
--/T <br> returns                    a table containing those tokens
--/T </samp>  
-------------------------------------------------------------
AS
BEGIN  
	DECLARE @tokenStart int;
	SET @tokenStart = 1
	SET @types = dbo.fNormalizeString(@types)  
	WHILE (ltrim(dbo.fTokenNext(@types,@tokenStart)) != '')
	    BEGIN
		INSERT @tokens VALUES(dbo.fTokenNext(@types,@tokenStart)) 
    		SET    @tokenStart = dbo.fTokenAdvance(@types,@tokenStart)
	    END
	RETURN
END
GO


--===================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spRunShellScript]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spRunShellScript]
GO
--
CREATE PROCEDURE spRunShellScript(
	@taskid int,
	@stepid int,
	@phase varchar(64),
	@cmd nvarchar(4000)
)
---------------------------------------------------
--/H Executes a shell script and logs the output string
---------------------------------------------------
--/T Returns the status of the error, and inserts 
--/T error message into the Phase table
---------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE 
	@msg varchar(8000), 
	@status varchar(16), 
	@ret int;
    --
    CREATE TABLE #scriptMsg (msg varchar(2048));
    --
    INSERT INTO #scriptMsg EXEC @ret=master.dbo.xp_cmdshell @cmd;
    --
    SET @msg = '';
    SELECT @msg = @msg+' '+msg FROM #scriptMsg 
	WHERE msg is not null and msg not like '%DEFAULT%'
    --
    SET @status = CASE WHEN @ret=0 THEN 'OK' ELSE 'ERROR' END;
    --
    SET @msg = LEFT(@msg,2048);
    IF @msg = '' SET @msg = cast(@cmd as varchar(2048));
    EXEC loadsupport.dbo.spNewPhase @taskid, @stepid,
	    @phase, @status, @msg;
    --
    DROP TABLE #scriptMsg
    RETURN @ret;
END
GO


--===================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spRunSQLScript]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spRunSQLScript]
GO
--
CREATE PROCEDURE spRunSQLScript(@taskid int, @stepid int,
	@phase varchar(64),
	@dbname varchar(64), 
	@path varchar(128), 
	@script varchar(256))
---------------------------------------------------
--/H Executes an sql script and logs the output string
---------------------------------------------------
--/T Returns the status of the error, and inserts 
--/T error message into the Phase table
---------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE @cmd nvarchar(4000), @ret int;
    --
    SET @cmd = N'osql -d'+@dbname+' -E -n -i'+@path+'\'+@script;
    EXEC @ret = spRunShellScript @taskid, @stepid, @phase, @cmd;
    --
    RETURN(@ret);
END
GO


--==================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spCreateSchema]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spCreateSchema]
GO
--
CREATE PROCEDURE spCreateSchema(@taskid int, @stepid int, @isPartitioned int=0)
---------------------------------------------------
--/H Builds the schema in the database related to @taskid
---------------------------------------------------
--/T The value of the @isPartitioned will set the
--/T behaviour:<br>
--/T <li> 0: the database is a single partition
--/T <li> 1: only run the FileGroup.sql part of the schema
--/T <li> 2: run the rest of the schema, except FileGroup.sql
--/T <br> This way we can run the code to create partitions
--/T with their correct sizes between the two phases
---------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE 
	@dbname varchar(64), 
	@dbtype varchar(8),
	@type varchar(64),
	@msg varchar(1024), 
	@sqldir varchar(64), 
	@fname varchar(80),
	@status varchar(80),
	@cmd nvarchar(4000),
	@err int, 
	@ret int;
    --
    SELECT @dbname=dbname,
	   @type=type from Task WITH (nolock)
	WHERE taskid=@taskid;

    -- set dbtype='targ' if it is TARG DB
    IF (@type ='TARGET')
	SET @dbtype = 'targ'
    ELSE
	SET @dbtype = '';
    ------------------------------
    -- log the beginning
    ------------------------------
    SET @msg   = 'Starting schema creation for ' + @dbname 
	+ ' with partitioning=' + cast(@isPartitioned as varchar(3));
    EXEC spNewPhase @taskid, @stepid, 
	'Schema', 'OK', @msg;

    ------------------------------------
    -- get list of SQL files to execute
    ------------------------------------
    SELECT @sqldir=value from Constants WHERE name='sqldir'
    --
    CREATE TABLE #msg (id int identity(1,1), s varchar(2048));
    SET @cmd = N'type '+@sqldir+'xschema'+@dbtype+'.txt';
    INSERT INTO #msg EXEC @ret=master.dbo.xp_cmdshell @cmd;

    -----------------------------------
    -- check for error 
    -----------------------------------
    IF EXISTS (select id from #msg where s like '%cannot find%')
      BEGIN
	SET @err    = 1;
	SET @status = 'ABORTING';
	SET @msg    = 'Cannot find xschema.txt file';
	GOTO exitwithlog
      END
    ELSE
      BEGIN
	SET @err    = 0;
	SET @status = 'OK';
	SET @msg    = 'Schema created for ' + @dbname 
		+ ' with isPartitioned=' + cast(@isPartitioned as varchar(2));
      END

    -------------------------------------------------------------------
    -- cursor for file loop
    -- ignore comments and blank lines, only consider *.sql file names
    -------------------------------------------------------------------
    DECLARE fc CURSOR READ_ONLY
	FOR SELECT s FROM #msg with (nolock)
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
	BEGIN
        ----------------------------------------------------
        -- create spherical assembly  in db
        ------------------------------------------------------------------
       IF (@fname='spSphericalLib.sql')
        BEGIN
          CREATE TABLE #output (id int identity(1,1), msg varchar(2048));
          SET @msg = 'Created Spherical assembly in database '+@dbname;
          SET @cmd = REPLACE( @sqldir, 'schema\sql', 'htm')
                 + 'deploy.bat localhost ' + @dbname;
           --
          INSERT INTO #output EXEC @ret=master.dbo.xp_cmdshell @cmd;
          if exists(select * from #output where msg like '%Created assembly%')
               EXEC spNewPhase @taskid, @stepid, 'Schema', 'OK', @msg;
          else
           begin
                 SET @msg = 'Error creating Spherical assembly in database '+@dbname;
                 EXEC spEndStep @taskid, @stepid, 'ABORTED', @msg, @msg;
                 RETURN(1)
          end
        END
        --  
	    ------------------------------------------------------------------
	    IF (@isPartitioned=0)
	      BEGIN
		EXEC @ret = spRunSqlScript @taskid, @stepid, 
			'Schema', @dbname, @sqldir, @fname;
		-----------------------------------
		-- truncate the FileGroupMap table
		-- before going further
		-----------------------------------
		IF (@fname='FileGroups.sql')
		  BEGIN
		    SET @cmd = N'EXEC '+@dbname+'.dbo.spTruncateFileGroupMap;'
		    EXEC sp_executesql @cmd;
		  END
	      END
	    IF (@isPartitioned=1)
	      BEGIN
		EXEC @ret = spRunSqlScript @taskid, @stepid, 
			'Schema', @dbname, @sqldir, @fname;
		--------------------------------
		-- break after FileGroups.sql
		--------------------------------
		IF (@fname='FileGroups.sql') BREAK;		
	      END
	    IF (@isPartitioned=2 and @fname!='FileGroups.sql')    
	      BEGIN
		EXEC @ret = spRunSqlScript @taskid, @stepid, 
			'Schema', @dbname, @sqldir, @fname;
	      END
	    ------------------------------------------------------------------
	END
	FETCH NEXT FROM fc INTO @fname
    END
    --
    CLOSE fc
    DEALLOCATE fc
    ----------------------------------------------
    IF @err > 0
	BEGIN
	    SET @status = 'ABORTING';
	    SET @msg = 'Errors in schema creation for ' + @dbname;
	END
    -----------------------------------------------
    exitwithlog:
    --
    EXEC spNewPhase @taskid, @stepid, 'Schema', @status, @msg;
    RETURN(@err);
END
GO


--=================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spCreateDatabase]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spCreateDatabase]
GO
--
CREATE PROCEDURE spCreateDatabase (
	@taskid int,
	@stepid int,
	@dbname varchar(64),
	@datapath varchar(64),
	@logpath varchar(64),
	@datasize int,
	@logsize int,
	@dataset varchar(16),
	@type varchar(16)
)
---------------------------------------------------
--/H Create a database corresponding to the @taskid
---------------------------------------------------
--/T Takes setup parameters from the caller, and it will
--/T insert the appropriate parameters into the Task
--/T table, corresponding to @taskid. The log messages
--/T are logged using @taskid, @stepid. 
--/T This procedure MUST be run on the same machine that
--/T the database will be on.
--/T The other parameters are: <br>
--/T @hostname -- the name of the server
---------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE 
	@hostname varchar(64),
	@dname varchar(64), 
	@lname varchar(64),
	@dsize varchar(64),
	@lsize varchar(64),
	@cmd nvarchar(2048), 
	@msg varchar(1024),
	@desc varchar(512),
	@ret int,
	@err int;

    SET @err = 0;
    SET @ret = 0;

    -- drop the database if it exists already
    SET @cmd = N'DROP DATABASE ['+@dbname+']';
    IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @dbname)
	EXEC @ret=sp_executesql @cmd;

    SET  @err = @err + @ret;
    -- meybe test for @ret value ???
    IF @err>0
	BEGIN
	    SELECT top 1 @desc=description
            FROM master.dbo.sysmessages WHERE error=@ret
	    SET @msg = 'Cannot create database '+@dbname+': '+@desc;
	    EXEC spEndStep @taskid, @stepid, 'ABORTED', @msg, @msg;
	    RETURN(1)
	END

    -- get host name
    SELECT @hostname = srvName FROM master.dbo.sysservers WHERE srvid = 0;

    -- build the filenames
    SET @dname=RTRIM(@datapath)+@dbname+'_Data.MDF' 
    SET @lname=RTRIM(@logpath) +@dbname+'_Log.LDF' 

    -- get the default database/log size from the Task itself
    SELECT @dsize=',SIZE='+cast(@datasize as varchar(16))+',';
    SELECT @lsize=',SIZE='+cast(@logsize  as varchar(16))+',';

    -- update Task with hostname, and filenames
    UPDATE Task 
	SET hostname	 = @hostname,
	    dbname	 = @dbname,
	    datafilename = @dname,
	    logfilename  = @lname,
	    datasize     = @datasize,
	    logsize	 = @logsize,
	    dataset	 = @dataset,
	    type	 = @type
	WHERE taskid=@taskid;

    -- delete the database files if already there
    SET  @cmd = 'IF EXIST '+@dname+ ' del /Q '+@dname;
    EXEC @ret = master.dbo.xp_cmdshell @cmd;
    SET  @err = @err + @ret;
    IF @err>0
	BEGIN
--	    SELECT top 1 @desc=description
--            FROM master.dbo.sysmessages WHERE error=@ret
	    SET @msg = 'Cannot create database '+@dbname+', cmd failed: '+@cmd;
	    EXEC spEndStep @taskid, @stepid, 'ABORTED', @msg, @msg;
	    RETURN(1)
	END

    --
    SET  @cmd = 'IF EXIST '+@lname+ ' del /Q '+@lname;
    EXEC @ret = master.dbo.xp_cmdshell @cmd;
    SET  @err = @err + @ret;
    IF @err>0
	BEGIN
--	    SELECT top 1 @desc=description
--            FROM master.dbo.sysmessages WHERE error=@ret
--	    SET @msg = 'Cannot create database '+@dbname+': '+@desc;
	    SET @msg = 'Cannot create database '+@dbname+', cmd failed: '+@cmd;
	    EXEC spEndStep @taskid, @stepid, 'ABORTED', @msg, @msg;
	    RETURN(1)
	END

    --
    -- create the data directory if it does not exist
    SET  @cmd = 'IF NOT EXIST '+@datapath+ ' mkdir '+@datapath;
    EXEC @ret = master.dbo.xp_cmdshell @cmd;
    SET  @err = @err + @ret;
    IF @err>0
	BEGIN
--	    SELECT top 1 @desc=description
--            FROM master.dbo.sysmessages WHERE error=@ret
--	    SET @msg = 'Cannot create database '+@dbname+': '+@desc;
	    SET @msg = 'Cannot create database '+@dbname+', cmd failed: '+@cmd;
	    EXEC spEndStep @taskid, @stepid, 'ABORTED', @msg, @msg;
	    RETURN(1)
	END

    --
    -- create the log directory if it does not exist
    SET  @cmd = 'IF NOT EXIST '+@logpath+ ' mkdir '+@logpath;
    EXEC @ret = master.dbo.xp_cmdshell @cmd;
    SET  @err = @err + @ret;
    IF @err>0
	BEGIN
--	    SELECT top 1 @desc=description
--            FROM master.dbo.sysmessages WHERE error=@ret
--	    SET @msg = 'Cannot create database '+@dbname+': '+@desc;
	    SET @msg = 'Cannot create database '+@dbname+', cmd failed: '+@cmd;
	    EXEC spEndStep @taskid, @stepid, 'ABORTED', @msg, @msg;
	    RETURN(1)
	END

    -- 
    -- check to see if data or log file size is 0, and issue warning if so
    IF (@datasize=0) OR (@logsize=0)
	BEGIN
	    SET @msg = 'Data or log file size is 0';
	    EXEC spNewPhase @taskid, @stepid,'Database', 'WARNING', @msg;
	END
    --
    -- this command will create the database with the given name
    SET @cmd ='CREATE DATABASE ['+@dbname+'] ON (NAME='''+@dbname+'_Data'',';
    SET @cmd = @cmd + 'FILENAME='''+@dname+''''+@dsize+'FILEGROWTH=10%) ';
    SET @cmd = @cmd + ' LOG ON (NAME='''+@dbname+'_Log'',';
    SET @cmd = @cmd + 'FILENAME='''+@lname+''''+@lsize+'FILEGROWTH=10%) ';
    --
    SET @msg = 'Starting database creation';
    EXEC spNewPhase @taskid, @stepid,'Database', 'OK', @msg;
    --
    EXEC @ret=sp_executesql @cmd;
    SET  @err = @err + @ret;
    --
    IF @@ERROR<>0 OR @ret>0
	BEGIN
	    SELECT top 1 @desc=description
            FROM master.dbo.sysmessages WHERE error=@ret
	    SET @msg = 'Cannot create database '+@dbname+': '+@desc;
	    EXEC spEndStep @taskid, @stepid, 'ABORTED', @msg, @msg;
	    RETURN(1)
	END
    SET @msg = 'Created database ' + @dbname;
    EXEC spNewPhase @taskid, @stepid,'Database', 'OK', @msg;
    --
    --
    IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @dbname)
    BEGIN
	
	set @cmd = N'ALTER DATABASE ' + @dbname +' SET '
	                                 + ' ANSI_NULLS              ON, '
                                         + ' ANSI_PADDING            ON, '
                                         + ' ANSI_WARNINGS           ON, '
                                         + ' ARITHABORT              ON, '
                                         + ' CONCAT_NULL_YIELDS_NULL ON, '
                                         + ' QUOTED_IDENTIFIER       ON, '
                                         + ' CURSOR_CLOSE_ON_COMMIT  OFF,'
                                         + ' AUTO_CREATE_STATISTICS  ON, '
                                         + ' AUTO_UPDATE_STATISTICS  ON, '  
                                         + ' RECURSIVE_TRIGGERS      OFF,' 
                                         + ' PAGE_VERIFY		CHECKSUM,'
                                         + ' RECOVERY SIMPLE,       '    
                                         + ' CURSOR_DEFAULT GLOBAL       '
	exec sp_executesql @cmd;
    END
    --
    IF @@error<>0 
	BEGIN
	    SET @msg = 'Cannot configure database ' + @dbname;
	    EXEC spEndStep @taskid, @stepid, 'ABORTED', @msg, @msg; 
	    RETURN(1);
	END
    --
    SET @msg = 'Configured database ' + @dbname;
    EXEC spNewPhase @taskid, @stepid,'Database', 'OK', @msg;
    --
    RETURN(@err);
END
GO


--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spCreateFileGroups]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spCreateFileGroups]
GO
--
CREATE PROCEDURE spCreateFileGroups (
------------------------------------------------------------
--/H Create the partitions for a PUBDB
------------------------------------------------------------
--/T Requires a list of different physical volumes, and a 
--/T flag that enables filegroups. The database size is
--/T calculated from the @megaobj parameter and the values
--/T stored in the PartitionMap table. The datapath is a
--/T comma-separated list of disk volumes. The first item
--/T on the list is used also for the PRIMARY partition.
--/T <samp> 
--/T EXEC spCreateFileGroups 'test','BEST','d:\sql_db\,e:','e:\sql_db\' 
--/T </samp>
------------------------------------------------------------
	@taskid int,
	@stepid int,
	@dbname varchar(64),
	@datapath varchar(1024),
	@logpath varchar(1024),
	@megaobj real
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE 
	@ret int,
	@id int,
	@msg varchar(2048),
	@cmd nvarchar(4000),
	@fgroup varchar(256),
	@path varchar(256),
	@fname varchar(256),
	@datasize int,
	@logsize int,
	@total real,
	@fsize real;

    ------------------------------------------
    -- build table of volumes and create them
    ------------------------------------------
    SELECT distinct token as path, 'D' as type, cast(0 as int) id 
	INTO #datapath FROM dbo.fTokenStringToTable(@datapath);
    SET @id = 0;
    --
    UPDATE #datapath
	SET id = @id,
	@id = @id+1;
    --
    SELECT distinct token as path, 'L' as type, cast(0 as int) id
	INTO #logpath FROM dbo.fTokenStringToTable(@logpath);
    --
    SET @id = 0;
    UPDATE #logpath
	SET id = @id,
	@id = @id+1;
    --
    ----------------------
    -- create the volumes
    ----------------------
    SELECT distinct path INTO #path FROM (
	select path from #datapath
	union
	select path from #logpath
    ) q
    --
    DECLARE mycursor CURSOR READ_ONLY
    FOR SELECT path+@dbname FROM #path
    --
    OPEN mycursor
    FETCH NEXT FROM mycursor INTO @path
    WHILE (@@fetch_status <> -1)
    BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	    SET @cmd  = N'IF NOT EXIST '+@path+' mkdir '+@path
	    EXEC @ret=spRunShellScript @taskid, @stepid, 'Database', @cmd;
	    IF @ret>0 
	    BEGIN
		SET @msg = 'Directory create failed in '+ @path;
		GOTO exitpoint
	    END
	END
	FETCH NEXT FROM mycursor INTO @path
    END
    --
    CLOSE mycursor
    DEALLOCATE mycursor
    --
    DROP TABLE #path;

    -------------------------------------------------------
    -- create tables of filegroup names and partition sizes
    -------------------------------------------------------
    CREATE TABLE #partitionmap (fgroup varchar(100), fsize real)
    --
    SET @cmd = N'select fileGroupName as fgroup, size as fsize '
	+ ' from '+ @dbname+'..PartitionMap';
    INSERT INTO #partitionmap EXEC @ret=sp_executesql @cmd;
    IF @ret>0
    BEGIN
	SET @msg = 'Could not access Partitionmap in '+ @dbname;
	GOTO exitpoint
    END

    --------------------------------------
    -- get an estimate of the total size.
    -- and update the Task table
    --------------------------------------
    SELECT @total = sum(fsize) FROM #partitionmap;
    SET @total    = @total * @megaobj * 1000.0;
    SET @datasize = cast(@total as int)+1;
    SET @logsize  = cast(0.1 * @total as int)+1;
    --
    UPDATE Task 
	SET datasize     = @datasize,
	    logsize	 = @logsize
	WHERE taskid=@taskid;

    -----------------------------------------------
    -- delete the PRIMARY partition from the table
    -----------------------------------------------
    DELETE #partitionmap
	WHERE fgroup='PRIMARY';
    
    -------------------------
    -- create the filegroups
    -------------------------
    DECLARE mycursor CURSOR READ_ONLY
    FOR SELECT fgroup FROM #partitionmap
    --
    OPEN mycursor
    FETCH NEXT FROM mycursor INTO @fgroup
    WHILE (@@fetch_status <> -1)
    BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	    SET @cmd  = N'ALTER DATABASE ' + @dbname 
		+ ' ADD FILEGROUP ' + @fgroup;
	    EXEC @ret=sp_executesql @cmd;
	    --
	    IF (@ret=0)
	    BEGIN
	    	SET @msg = 'Added filegroup '+@fgroup;
		EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
			'Database', 'OK', @msg;
	    END
	    ELSE
	    BEGIN
	    	SET @msg = 'Could not add filegroup '+@fgroup;
		GOTO exitpoint
	    END
	END
	FETCH NEXT FROM mycursor INTO @fgroup
    END
    --
    CLOSE mycursor
    DEALLOCATE mycursor

    ---------------------------------------------------
    -- for each filegroup and volume, create the files
    ---------------------------------------------------
    SELECT @id = count(*) from #datapath;

    SELECT f.fgroup, p.path+@dbname+'\' as path,
	@dbname+'_'+f.fgroup+'_'+ltrim(cast(p.id as varchar(3))) as fname,
	cast(@megaobj*1000.0*f.fsize/@id + 1 as int) fsize
	INTO #files
	FROM #datapath p, #partitionmap f
    --
    DECLARE mycursor CURSOR READ_ONLY
    FOR SELECT fgroup, path, fname, fsize FROM #files
    --
    OPEN mycursor
    FETCH NEXT FROM mycursor INTO @fgroup, @path, @fname, @fsize
    WHILE (@@fetch_status <> -1)
    BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	SET @cmd  = N'ALTER DATABASE ' + @dbname 
		+ ' ADD FILE ' 
		+ '( NAME='+@fname + ', FILENAME='''+@path+@fname+'.ndf'''+
		+ ', SIZE='+CAST(@fsize as varchar(16))+'MB'
		+ ', FILEGROWTH=10%' 
		+ ') TO FILEGROUP ' + @fgroup
	    EXEC @ret=sp_executesql @cmd;
	    IF (@ret=0)
	    BEGIN
	    	SET @msg = 'Added file '+@path+@fname +' to '+@fgroup;
		EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
			'Database', 'OK', @msg;
	    END
	    ELSE
	    BEGIN
	    	SET @msg = 'Could not add file '+@path+@fname +' to '+ @fgroup;
		GOTO exitpoint
	    END
	END
	FETCH NEXT FROM mycursor INTO @fgroup, @path, @fname, @fsize
    END
    --
    CLOSE mycursor
    DEALLOCATE mycursor

    ------------------------------------------
    -- for each volume, create the log files
    ------------------------------------------

    ---------------------------------------------------
    -- figure out the best estimate for the log file
    -- 10 percent total, spread out among the partitions
    ----------------------------------------------------
    SELECT @id = count(*) from #logpath;
    --
    SELECT path+@dbname+'\' as path,
	@dbname+'_LOG_'+ltrim(cast(id as varchar(3))) as fname,
	cast(0.1* @total/@id + 1 as int) fsize
	INTO #logfiles
	FROM #logpath
    --
    DECLARE mycursor CURSOR READ_ONLY
    FOR SELECT path, fname, fsize FROM #logfiles
    --
    OPEN mycursor
    FETCH NEXT FROM mycursor INTO @path, @fname, @fsize
    WHILE (@@fetch_status <> -1)
    BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	SET @cmd  = N'ALTER DATABASE ' + @dbname 
		+ ' ADD LOG FILE ' 
		+ '( NAME='+@fname + ', FILENAME='''+@path+@fname+'.ndf'''+
		+ ', SIZE='+CAST(@fsize as varchar(16))+'MB'
		+ ', FILEGROWTH=10%)' 
	    EXEC @ret=sp_executesql @cmd;
	    IF (@ret=0)
	    BEGIN
	    	SET @msg = 'Added log file '+@path+@fname;
		EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
			'Database', 'OK', @msg;
	    END
	    ELSE
	    BEGIN
	    	SET @msg = 'Could not add logfile '+@path+@fname;
		GOTO exitpoint
	    END

	END
	FETCH NEXT FROM mycursor INTO @path, @fname, @fsize
    END
    --
    CLOSE mycursor
    DEALLOCATE mycursor
    --
    exitpoint:
    IF @ret >0
      BEGIN
	EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
		'Database', 'ABORTING', @msg;	
      END
    ELSE
      BEGIN
	EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
		'Database', 'OK', 'Filegroups created successfully';	
      END

    RETURN (@ret);
END
GO

if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spCreateFileGroups2]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spCreateFileGroups2]
GO
--
CREATE PROCEDURE spCreateFileGroups2 (
	@taskid int,
	@stepid int,
	@dbname varchar(64),
	@datapath varchar(1024),
	@logpath varchar(1024),
	@megaobj real,
	@filegroups int=1
)
------------------------------------------------------------
--/H Create the partitions for a PUBDB
------------------------------------------------------------
--/T Requires a list of different physical volumes, and a 
--/T flag that enables filegroups. The database size is
--/T calculated from the @megaobj parameter and the values
--/T stored in the PartitionMap table. The datapath is a
--/T comma-separated list of disk volumes. The first item
--/T on the list is used also for the PRIMARY partition.
--/T <br>Parameters:
--/T <li>@taskid int, the taskid
--/T <li>@stepid int, the stepid
--/T <li>@dbname varchar(64), the name of the database
--/T <li>@datapath varchar(1024), list of data volumes
--/T <li>@logpath varchar(1024), list of log volumes
--/T <li>@megaobj real, the number of objects
--/T <li>@filegroups int 0:no filegroups, 1:build filegroups
--/T <samp> 
--/T EXEC spCreateFileGroups 'test','BEST','d:\sql_db\,e:','e:\sql_db\',0.1,0 
--/T </samp>
------------------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE 
	@ret int,
	@id int,
	@msg varchar(2048),
	@cmd nvarchar(4000),
	@fgroup varchar(256),
	@path varchar(256),
	@fname varchar(256),
	@datasize int,
	@logsize int,
	@total real,
	@fsize real;

    ------------------------------------------
    -- build table of volumes and create them
    ------------------------------------------
    SELECT distinct token as path, 'D' as type, cast(0 as int) id 
	INTO #datapath FROM dbo.fTokenStringToTable(@datapath);
    SET @id = 0;
    --
    UPDATE #datapath
	SET id = @id,
	@id = @id+1;
    --
    SELECT distinct token as path, 'L' as type, cast(0 as int) id
	INTO #logpath FROM dbo.fTokenStringToTable(@logpath);
    --
    SET @id = 0;
    UPDATE #logpath
	SET id = @id,
	@id = @id+1;
    --
    EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
	'Database', 'OK', 'Creating directories for database';	
    ----------------------
    -- create the volumes
    ----------------------
    SELECT distinct path INTO #path FROM (
	select path from #datapath
	union
	select path from #logpath
    ) q
    --
    DECLARE mycursor CURSOR READ_ONLY
    FOR SELECT path+@dbname FROM #path
    --
    OPEN mycursor
    FETCH NEXT FROM mycursor INTO @path
    WHILE (@@fetch_status <> -1)
    BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	    SET @cmd  = N'IF NOT EXIST '+@path+' mkdir '+@path
	    EXEC @ret=spRunShellScript @taskid, @stepid, 'Database', @cmd;
	    IF @ret>0 
	    BEGIN
		SET @msg = 'Directory create failed in '+ @path;
		GOTO exitpoint
	    END
	END
	FETCH NEXT FROM mycursor INTO @path
    END
    --
    CLOSE mycursor
    DEALLOCATE mycursor
    --
    DROP TABLE #path;

    -------------------------------------------------------
    -- create tables of filegroup names and partition sizes
    -------------------------------------------------------
    CREATE TABLE #partitionmap (fgroup varchar(100), fsize real)
    --
    SET @cmd = N'select fileGroupName as fgroup, size as fsize '
	+ ' from '+ @dbname+'..PartitionMap';
    INSERT INTO #partitionmap EXEC @ret=sp_executesql @cmd;
    IF @ret>0
    BEGIN
	SET @msg = 'Could not access Partitionmap in '+ @dbname;
	GOTO exitpoint
    END
    --------------------------------------
    -- get an estimate of the total size.
    -- and update the Task table
    --------------------------------------
    SELECT @total = sum(fsize) FROM #partitionmap;
    SET @total    = @total * @megaobj * 1000.0;
    SET @datasize = cast(@total as int)+1;
    SET @logsize  = cast(0.1 * @total as int)+1;
	    --
    UPDATE Task 
	SET datasize = @datasize,
	    logsize  = @logsize
	WHERE taskid = @taskid;

    IF @filegroups=1
    BEGIN    
	EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
		'Database', 'OK', 'Adding filegroups';	
	-----------------------------------------------
	-- delete the PRIMARY partition from the table
	-----------------------------------------------
	DELETE #partitionmap
	    WHERE fgroup='PRIMARY';
	-------------------------
	-- create the filegroups
	-------------------------
	DECLARE mycursor CURSOR READ_ONLY
	FOR SELECT fgroup FROM #partitionmap
	--
	OPEN mycursor
	FETCH NEXT FROM mycursor INTO @fgroup
	WHILE (@@fetch_status <> -1)
	BEGIN
	    IF (@@fetch_status <> -2)
	    BEGIN
		SET @cmd  = N'ALTER DATABASE ' + @dbname 
		    + ' ADD FILEGROUP ' + @fgroup;
		EXEC @ret=sp_executesql @cmd;
		--
		IF (@ret=0)
		BEGIN
		    SET @msg = 'Added filegroup '+@fgroup;
		    EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
			'Database', 'OK', @msg;
		END
		ELSE
		BEGIN
		    SET @msg = 'Could not add filegroup '+@fgroup;
		    GOTO exitpoint
		END
	    END
	    FETCH NEXT FROM mycursor INTO @fgroup
	END
	--
	CLOSE mycursor
	DEALLOCATE mycursor
    END
    ELSE
    BEGIN
	---------------------------
	-- PRIMARY filegroup only
	---------------------------
	EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
		'Database', 'OK', 'Resizing database';	
	SELECT @total = sum(fsize) FROM #partitionmap;
	--
	UPDATE #partitionmap
	    SET fsize = @total
	    WHERE fgroup='PRIMARY'
	--
	DELETE #partitionmap
	    WHERE fgroup !='PRIMARY'
	--
    END

    ---------------------------------------------------
    -- for each filegroup and volume, create the files
    ---------------------------------------------------
    SELECT @id = count(*) from #datapath;
    --
    CREATE TABLE #files (
	fgroup varchar(16),
	path varchar(128),
	fname varchar(128),
	fsize int,
	id int
    )
    --
    IF @filegroups=1
    BEGIN    
	INSERT #files
	SELECT 	f.fgroup, 
		p.path+@dbname+'\' as path,
		@dbname+'_'+f.fgroup+'_'+ltrim(cast(p.id as varchar(3))) as fname,
		cast(@megaobj*1000.0*f.fsize/@id + 10 as int) fsize,
		p.id
	FROM #datapath p, #partitionmap f
    END
    ELSE
    BEGIN
	INSERT #files
	SELECT f.fgroup, p.path+@dbname+'\' as path,
		@dbname+'_Data'
		+CASE WHEN p.id>1 THEN '_'+ltrim(cast(p.id as varchar(3)))
		  ELSE '' END as fname,
		cast(@megaobj*1000.0*f.fsize/@id + 10 as int) fsize,
		p.id
	FROM #datapath p, #partitionmap f
    END
    --

    EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
	'Database', 'OK', 'Creating data files';	

    DECLARE mycursor CURSOR READ_ONLY
    FOR SELECT fgroup, path, fname, fsize, id FROM #files
    --
    OPEN mycursor
    FETCH NEXT FROM mycursor INTO @fgroup, @path, @fname, @fsize, @id
    WHILE (@@fetch_status <> -1)
    BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	    SET @cmd  = N'ALTER DATABASE ' + @dbname
			+ ' ADD FILE '
			+ '( NAME='+@fname 
			+ ',FILENAME='''+@path+@fname+'.ndf'''+
			+ ', SIZE='+CAST(@fsize as varchar(16))+'MB'
			+ ', FILEGROWTH=10%' 
			+ ')';
	    IF @fgroup!='PRIMARY'
		SET @cmd = @cmd + ' TO FILEGROUP ' + @fgroup
	    ---------------------------------
	    -- if no filegroups and PRIMARY
	    ---------------------------------
	    IF @filegroups=0 and @id=1
	        SET @cmd  = N'ALTER DATABASE ' + @dbname
			+ ' MODIFY FILE '
			+ '( NAME='+@fname 
			+ ', SIZE='+CAST(@fsize as varchar(16))+'MB'
			+ ')'
	    --
	    EXEC @ret=sp_executesql @cmd;
	    IF (@ret=0)
	    BEGIN
	    	SET @msg = 'Added file '+@path+@fname +' to '+@fgroup;
		EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
			'Database', 'OK', @msg;
	    END
	    ELSE
	    BEGIN
	    	SET @msg = 'Could not add file '+@path+@fname +' to '+ @fgroup;
		GOTO exitpoint
	    END
	END
	FETCH NEXT FROM mycursor INTO @fgroup, @path, @fname, @fsize, @id
    END
    --
    CLOSE mycursor
    DEALLOCATE mycursor

    ---------------------------------------------------
    -- figure out the best estimate for the log file
    -- 10 percent total, spread out among the partitions
    ----------------------------------------------------
    SELECT @id = count(*) from #logpath;
    --
    DELETE #files
    --
    INSERT #files
    SELECT '' as fgroup, path+@dbname+'\' as path,
	    @dbname+'_Log'+
	    CASE WHEN id>1 THEN '_'+ltrim(cast(id as varchar(3)))
	    ELSE '' END as fname,
 	    cast(0.1* @total/@id + 10 as int) fsize, id -- log is 10% of DB
-- Jim	    cast(0.1* @megaobj*1000.0*@total/@id + 10 as int) fsize, id
	FROM #logpath

    ------------------------------------------
    -- for each volume, create the log files
    ------------------------------------------
    EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
	'Database', 'OK', 'Creating Log files';	
    --
        DECLARE mycursor CURSOR READ_ONLY
    FOR SELECT path, fname, fsize, id FROM #files
    --
    OPEN mycursor  
    WHILE (1=1)
	BEGIN 
	FETCH NEXT FROM mycursor INTO @path, @fname, @fsize, @id
	IF (@@fetch_status < 0 ) break
	---------------------------------
	IF @id=1
	    BEGIN
		if @fsize = 10 continue -- jim: avoid error if no change in file size.
		SET @cmd  = N'ALTER DATABASE ' + @dbname 
		  + ' MODIFY FILE ' 
		  + '( NAME='+@fname 
		  + ', SIZE='+CAST(@fsize as varchar(16))+'MB'
		  + ')' 
	    END
	ELSE
	    BEGIN
		SET @cmd  = N'ALTER DATABASE ' + @dbname 
		  + ' ADD LOG FILE ' 
		  + '( NAME='+@fname + ', FILENAME='''+@path+@fname+'.ndf'''+
		  + ', SIZE='+CAST(@fsize as varchar(16))+'MB'
		  + ', FILEGROWTH=10%)' 
	    END
	--
	EXEC @ret=sp_executesql @cmd;
	IF (@ret=0)
		BEGIN
		SET @msg = 'Added log file '+@path+@fname;
		EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
			'Database', 'OK', @msg;
		END
	ELSE
		BEGIN
		SET @msg = 'Could not add logfile '+@path+@fname;
		GOTO exitpoint
		END
	END
    --
    CLOSE mycursor
    DEALLOCATE mycursor
    --
    exitpoint:
    IF @ret >0
      BEGIN
	EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
		'Database', 'ABORTING', @msg;	
      END
    ELSE
      BEGIN
	EXEC loadsupport.dbo.spNewPhase @taskid, @stepid, 
		'Database', 'OK', 'Filegroups created successfully';	
      END

    RETURN (@ret);
END
GO


--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spCreatePubDB]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spCreatePubDB]
GO
--
CREATE PROCEDURE spCreatePubDB (
	@dbname varchar(64),
	@dataset varchar(16),
	@type varchar(16),
	@datapath varchar(64),
	@logpath varchar(64),
	@datasize int,
	@logsize int
)
------------------------------------------------------------
--/H Build a publishDB 
------------------------------------------------------------
--/T <samp> 
--/T EXEC spCreatePubDB 'test','BEST','d:\sql_db\','e:\sql_db\',20,10
--/T </samp>
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE @loadagent varchar(128);
    SELECT @loadagent=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='loadagent';
    --
    DECLARE
	@hostname varchar(32),
	@taskid int,
	@stepid int,
	@status varchar(64),
	@phasemsg varchar(256),
	@comment varchar(2048),
	@err int,
	@ret int

    SET @comment = 'Destination DB for ' + @type;
    SET @type = UPPER(@type)+'-PUB';
    SET @err  = 0;
    -------------------
    -- get host name
    -------------------
    SELECT @hostname = @@servername;
    --
    INSERT INTO Task (hostname,dbname,datasize,logsize,step,taskstatus,
		dataset,type,[id],path,[user],publishdb, publishhost,comment) 
	VALUES(@hostname,@dbname,@datasize,@logsize,'CREATE','WAITING',
		@dataset,@type,@dbname,'',@loadagent,'','',@comment)
    --
    SELECT @taskid=max(taskid) FROM Task WITH (nolock)
	WHERE dbname=@dbname
    -- spStartStep
    EXEC spStartStep @taskid, @stepid OUTPUT,
	'CREATE','WORKING', 'Starting to create pubDB', 'Starting to create pubDB';
    --
    IF @stepid IS NULL RETURN(1);
    -------------------------------------------------
    EXEC @ret = spCreateDatabase @taskid, @stepid,@dbname,@datapath,
	@logpath,@datasize,@logsize,@dataset,@type
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint
    --
    EXEC @ret = spCreateSchema @taskid, @stepid
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint
    --
    DECLARE @metadir varchar(128);
    SELECT @metadir=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='metadir';
    --
    DECLARE @cmd nvarchar(2048);
    SET @cmd = N'EXEC '+@dbname+'.dbo.spLoadMetaData '
	+ cast(@taskid as varchar(16)) + ', '
	+ cast(@stepid as varchar(16)) + ', '''
	+ @metadir+'''';
    --
    EXEC @ret=sp_executesql @cmd;
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint
    -------------------------------------------------
    exitpoint:

    IF @err=0
	BEGIN
	    SET @phaseMsg = 'Created ' + @dbname;
	    SET @status   = 'DONE'
	END
    ELSE
	BEGIN
	    SET @phaseMsg = 'Failed to create ' + @dbname;
	    SET @status   = 'ABORTING'
	END

    EXEC spEndStep @taskID, @stepID, 
		@status,
		@phaseMsg,
		@phaseMsg
    --
    RETURN(@err);
    --
END
GO


--==============================================================

if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spCreatePartDB]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spCreatePartDB]
GO
--
CREATE PROCEDURE spCreatePartDB (
	@dbname varchar(64),
	@dataset varchar(16),
	@type varchar(16),
	@datapath varchar(1024),
	@logpath varchar(1024),
	@megaobj real
)
------------------------------------------------------------
--/H Build a publishDB with partitioning
------------------------------------------------------------
--/T Requires a list of different physical volumes, and a 
--/T flag that enables filegroups. The database size is
--/T calculated from the @megaobj parameter and the values
--/T stored in the PartitionMap table. The datapath is a
--/T comma-separated list of disk volumes. The first item
--/T on the list is used also for the PRIMARY partition.
--/T <samp> 
--/T EXEC spCreatePartDB 'NullTest','BEST','PUB','d:\sql_db\,e:\sql_db\','f:\sql_db\', 1.25
--/T </samp>
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE @loadagent varchar(128);
    SELECT @loadagent=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='loadagent';
    --
    DECLARE
	@hostname varchar(32),
	@taskid int,
	@stepid int,
	@status varchar(64),
	@phasemsg varchar(256),
	@comment varchar(2048),
	@datasize int,
	@logsize int,
	@path varchar(128),
	@err int,
	@ret int;


    SET @comment = 'Destination DB for ' + @type;
    SET @type = UPPER(@type)+'-PUB';
    SET @err  = 0;

    -------------------------------------------------
    -- get host name, and default data and log sizes
    -------------------------------------------------
    SELECT @hostname = @@servername;
    SET @datasize = 10;
    SET @logsize  = 10;
    --
    INSERT INTO Task (hostname,dbname,datasize,logsize,step,taskstatus,
		dataset,type,[id],path,[user],publishdb, publishhost,comment) 
	VALUES(@hostname,@dbname,@datasize,@logsize,'CREATE','WAITING',
		@dataset,@type,@dbname,'',@loadagent,'','',@comment)
    --
    SELECT @taskid=max(taskid) FROM Task WITH (nolock)
	WHERE dbname=@dbname
    --
    EXEC spStartStep @taskid, @stepid OUTPUT,
	'CREATE','WORKING', 'Starting to create pubDB', 'Starting to create pubDB';
    --
    IF @stepid IS NULL RETURN(1);

    ------------------------------------------------------------
    -- get the first entry in the @datapath list
    ------------------------------------------------------------
    SELECT @path=(select top 1 token from dbo.fTokenStringToTable(@datapath));
    SET @path = @path+@dbname+'\';

    -----------------------
    -- create the database
    -----------------------
    EXEC @ret = spCreateDatabase @taskid, @stepid,
	@dbname, @path, @path, @datasize, @logsize, @dataset, @type
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint

    ---------------------------------------------------------------
    -- create the FileGroupMap part of the schema only (in PRIMARY)
    ---------------------------------------------------------------
    EXEC @ret = spCreateSchema @taskid, @stepid, 1
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint

    --------------------------------------------------
    -- now we can figure out how much space is needed,
    -- and what partitions we need to create
    --------------------------------------------------
    EXEC @ret = spCreateFileGroups @taskid, @stepid,
	@dbname, @datapath, @logpath, @megaobj;

    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint

    ------------------------------------------------------
    -- create the rest of the schema
    ------------------------------------------------------
    EXEC @ret = spCreateSchema @taskid, @stepid, 2
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint
    -----------------------
    -- load the metadata
    -----------------------
    DECLARE @metadir varchar(128);
    SELECT @metadir=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='metadir';
    --
    DECLARE @cmd nvarchar(2048);
    SET @cmd = N'EXEC '+@dbname+'.dbo.spLoadMetaData '
	+ cast(@taskid as varchar(16)) + ', '
	+ cast(@stepid as varchar(16)) + ', '''
	+ @metadir+'''';
    --
    EXEC @ret=sp_executesql @cmd;
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint

    ---------------------------------------------------
    -- create all the indices, except the foreign keys
    ---------------------------------------------------
    SET @cmd = N'EXEC '+@dbname+'.dbo.spIndexBuildSelection '
		+ cast(@taskID as varchar(12))+','
		+ cast(@stepid as varchar(12))+', ''K,I'', ''ALL'' ';
    EXEC @ret=dbo.sp_executesql @cmd;
    SET  @err = @err + @ret;
    IF (@err != 0) GOTO exitpoint
    --
    EXEC loadSupport.dbo.spNewPhase @taskID, @stepID,  
	'Index build', 'OK', 'Built all indices';

    -------------------------------------------------
    exitpoint:

    IF @err=0
	BEGIN
	    SET @phaseMsg = 'Created ' + @dbname;
	    SET @status   = 'DONE'
	END
    ELSE
	BEGIN
	    SET @phaseMsg = 'Failed to create ' + @dbname;
	    SET @status   = 'ABORTING'
	END

    EXEC spEndStep @taskID, @stepID, 
		@status,
		@phaseMsg,
		@phaseMsg;
    --
    RETURN(@err);
END
GO
--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spCreatePartDB2]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spCreatePartDB2]
GO
--
CREATE PROCEDURE spCreatePartDB2 (
	@dbname varchar(64),
	@dataset varchar(16),
	@type varchar(16),
	@datapath varchar(1024),
	@logpath varchar(1024),
	@megaobj real,
	@filegroups int,
	@indextype varchar(128),
	@taskid int OUTPUT
)
------------------------------------------------------------
--/H Build a publishDB with partitioning
------------------------------------------------------------
--/T Requires a list of different physical volumes, and a 
--/T flag that enables filegroups. The database size is
--/T calculated from the @megaobj parameter and the values
--/T stored in the PartitionMap table. The datapath is a
--/T comma-separated list of disk volumes. The first item
--/T on the list is used also for the PRIMARY partition.
--/T Parameters:
--/T <li>@dbname varchar(64)	the name of the database
--/T <li>@dataset varchar(16)   like 'DR3', 'TEST'
--/T <li>@type varchar(16)	one of 'BEST', 'TARG', 'TEST'
--/T <li>@datapath varchar(1024)  comma separated list of volumes
--/T <li>@logpath varchar(1024)   comma separated list of volumes
--/T <li>@megaobj real		size in megaobjects
--/T <li>@filegroups int	0: no filegroups, 1:use filegroups
--/T <li>@indextype varchar(128) a subset of 'K,I,F' for primary keys, indices and foreign keys
--/T <samp> 
--/T DECLARE @taskid int;EXEC spCreatePartDB2 'NullTest','DR4','BEST','d:\sql_db\,e:\sql_db\','f:\sql_db\', 0.05, 1, 'K', @taskid OUTPUT
--/T </samp>
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE @loadagent varchar(128);
    SELECT @loadagent=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='loadagent';
    --
    DECLARE
	@hostname varchar(32),
	@stepid int,
	@status varchar(64),
	@phasemsg varchar(256),
	@comment varchar(2048),
	@cmd nvarchar(4000),
	@datasize int,
	@logsize int,
	@path varchar(128),
	@path2 varchar(128),
	@err int,
	@ret int;
    --
    SET @comment = 'Destination DB for ' + @type;
    SET @type = UPPER(@type)+'-PUB';
    SET @err  = 0;

    -------------------------------------------------
    -- get host name, and default data and log sizes
    -------------------------------------------------
    SET @hostname = @@servername;
    SET @datasize    = 10;
    SET @logsize     = 10;
    --
    if (@taskID is null) --<jim: 205-02-17>
 	begin
 	exec spNewTask  [id], @dataset, @type, @dbname,'', @comment, @taskID output 
 	end
 
    /* -- <jim: 205-02-17>
    INSERT INTO Task (hostname,dbname,datasize,logsize,step,taskstatus,
		dataset,type,[id],path,[user],publishdb, publishhost,comment) 
	VALUES(@hostname,@dbname,@datasize,@logsize,'CREATE','WAITING',
		@dataset,@type,@dbname,'',@loadagent,'','',@comment)
    --
    SELECT @taskid=max(taskid) FROM Task WITH (nolock)
	WHERE dbname=@dbname
    -- <jim: 205-02-17> */
    --
    EXEC spStartStep @taskid, @stepid OUTPUT,
	'CREATE','WORKING', 'Starting to create pubDB', 
	'Starting to create pubDB';
    --
    IF @stepid IS NULL RETURN(1);

    ---------------------------------------------
    -- get the first entry in the @datapath list
    ---------------------------------------------
    SELECT @path  = (select top 1 token from dbo.fTokenStringToTable(@datapath));
    SELECT @path2 = (select top 1 token from dbo.fTokenStringToTable(@logpath));
    SET @path     = @path  + @dbname+'\';
    SET @path2    = @path2 + @dbname+'\';
    -----------------------
    -- create the database
    -----------------------
    EXEC @ret = spCreateDatabase @taskid, @stepid,
	@dbname, @path, @path2, @datasize, @logsize, @dataset, @type
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint

    ---------------------------------------------------------------
    -- create the FileGroupMap part of the schema only (in PRIMARY)
    ---------------------------------------------------------------
    EXEC @ret = spCreateSchema @taskid, @stepid, 1
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint
    -------------------------------------------
    -- remove filegroup info, if not required
    -------------------------------------------
    IF @filegroups=0
    BEGIN
	SET @cmd = N'EXEC '+@dbname+'.dbo.spTruncateFileGroupMap;'
	EXEC sp_executesql @cmd;
    END
    --------------------------------------------------
    -- now we can figure out how much space is needed,
    -- and what partitions we need to create
    --------------------------------------------------
    EXEC @ret = spCreateFileGroups2 @taskid, @stepid,
	@dbname, @datapath, @logpath, @megaobj, @filegroups;
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint
    ------------------------------------------------------
    -- create the rest of the schema
    ------------------------------------------------------
    EXEC @ret = spCreateSchema @taskid, @stepid, 2
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint
    -----------------------
    -- load the metadata
    -----------------------
    DECLARE @metadir varchar(128);
    SELECT @metadir=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='metadir';
    --
    SET @cmd = N'EXEC '+@dbname+'.dbo.spLoadMetaData '
	+ cast(@taskid as varchar(16)) + ', '
	+ cast(@stepid as varchar(16)) + ', '''
	+ @metadir+'''';
    --
    EXEC @ret=sp_executesql @cmd;
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint
    -----------------------
    -- create primary keys
    -----------------------
    IF @indexType like '%K%'
    BEGIN
	SET @cmd = N'EXEC '+@dbname+'.dbo.spIndexBuildSelection '
		+ cast(@taskID as varchar(12))+','
		+ cast(@stepid as varchar(12))+', ''K'', ''ALL'' ';
	EXEC @ret=dbo.sp_executesql @cmd;
	SET  @err = @err + @ret;
	IF (@err != 0) GOTO exitpoint
	--
	EXEC loadSupport.dbo.spNewPhase @taskID, @stepID,  
		'Index build', 'OK', 'Built all primary keys';
    END
    ----------------------
    -- create all indexes
    ----------------------
    IF @indexType like '%I%'
    BEGIN
	SET @cmd = N'EXEC '+@dbname+'.dbo.spIndexBuildSelection '
		+ cast(@taskID as varchar(12))+','
		+ cast(@stepid as varchar(12))+', ''I'', ''ALL'' ';
	EXEC @ret=dbo.sp_executesql @cmd;
	SET  @err = @err + @ret;
	IF (@err != 0) GOTO exitpoint
	--
	EXEC loadSupport.dbo.spNewPhase @taskID, @stepID,  
		'Index build', 'OK', 'Built all indices';
    END
    ---------------------------
    -- create all foreign keys
    ---------------------------
    IF @indexType like '%F%'
    BEGIN
	SET @cmd = N'EXEC '+@dbname+'.dbo.spIndexBuildSelection '
		+ cast(@taskID as varchar(12))+','
		+ cast(@stepid as varchar(12))+', ''F'', ''ALL'' ';
	EXEC @ret=dbo.sp_executesql @cmd;
	SET  @err = @err + @ret;
	IF (@err != 0) GOTO exitpoint
	--
	EXEC loadSupport.dbo.spNewPhase @taskID, @stepID,  
		'Index build', 'OK', 'Built all foreign keys';
    END
    -------------------------------------------------
    exitpoint:
    --
    IF @err=0
	BEGIN
	    SET @phaseMsg = 'Created ' + @dbname;
	    SET @status   = 'DONE'
	END
    ELSE
	BEGIN
	    SET @phaseMsg = 'Failed to create ' + @dbname;
	    SET @status   = 'ABORTING'
	END

    EXEC spEndStep @taskID, @stepID, 
		@status,
		@phaseMsg,
		@phaseMsg;
    --
    RETURN(@err);
END
GO


--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spCreateNullDB]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spCreateNullDB]
GO
--
CREATE PROCEDURE spCreateNullDB (
	@dbname varchar(64),
	@path varchar(64)
)
------------------------------------------------------------
--/H Build a NullDB 
------------------------------------------------------------
--/T <samp> 
--/T EXEC spCreateNullDB 'NULLDB','e:\sql_db\'
--/T </samp>
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    ---------------------------------------
    -- initialize parameters
    DECLARE
	@dataset varchar(16),
	@type varchar(16),
	@datapath varchar(64),
	@logpath varchar(64),
	@datasize int,
	@logsize int;

    SET @dataset	= 'NULL';
    SET @type		= 'BEST';
    SET @datapath	= @path;
    SET @logpath 	= @path;
    SET @datasize	= 5;
    SET @logsize 	= 1;
    ---------------------------------------
    DECLARE @loadagent VARCHAR(128);
    SELECT @loadagent=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='loadagent';

    DECLARE
	@hostname varchar(32),
	@taskid int,
	@stepid int,
	@status varchar(64),
	@msg varchar(256),
	@comment varchar(2048),
	@err int,
	@ret int

    SET @comment = 'Destination DB for ' + @type;
    SET @type = UPPER(@type)+'-PUB';
    SET @err  = 0;

    -- get host name
    SELECT @hostname = @@servername;

    INSERT INTO Task (hostname,dbname,datasize,logsize,step,taskstatus,
		dataset,type,[id],path,[user],publishdb, publishhost,comment) 
	VALUES(@hostname,@dbname,@datasize,@logsize,'CREATE','WAITING',
		@dataset,@type,@dbname,'',@loadagent,'','',@comment)

    SELECT @taskid=max(taskid) FROM Task WITH (nolock)
	WHERE dbname=@dbname

    -- spStartStep
    EXEC spStartStep @taskid, @stepid OUTPUT,
	'CREATE','WORKING',
	'Starting to create pubDB',
	'Starting to create pubDB';
    --
    IF @stepid IS NULL RETURN(1);
    -------------------------------------------------
    EXEC @ret = spCreateDatabase @taskid, @stepid,@dbname,@datapath,
	@logpath,@datasize,@logsize,@dataset,@type
    SET  @err = @err + @ret;
    --
    IF @err>0 GOTO exitpoint
    --
    EXEC @ret = spCreateSchema @taskid, @stepid
    SET  @err = @err + @ret;
    IF   @err>0 GOTO exitpoint
    --
    DECLARE @metadir varchar(128);
    SELECT @metadir=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='metadir';
    --
    DECLARE @cmd nvarchar(2048);
    SET @cmd = N'EXEC '+@dbname+'.dbo.spLoadMetaData '
	+ cast(@taskid as varchar(16)) + ', '
	+ cast(@stepid as varchar(16)) + ', '''
	+ @metadir + '''';
    --
    EXEC @ret=sp_executesql @cmd;
    SET  @err = @err + @ret;
    IF @err>0 GOTO exitpoint

    DECLARE @server varchar(64)
    -------------------------------------------------
    -- create all the indices 
    ------------------------------------------------
	-- In any case, build the indices on the database
	SET @cmd = N'EXEC '+@dbname+'.dbo.spIndexBuildSelection '
		+ cast(@taskID as varchar(12))+','
		+ cast(@stepid as varchar(12))+', ''K,F,I'', ''ALL'' ';
	EXEC @ret=dbo.sp_executesql @cmd;
	SET  @err = @err + @ret;
	IF (@err != 0) GOTO exitpoint
	--
	EXEC loadSupport.dbo.spNewPhase @taskID, @stepID,  
	    'Index build', 'OK', 'Built all indices';
	---------------------------------------------------------------------------------------------

    exitpoint:

    IF @err=0
	BEGIN
	    SET @msg = 'Created ' + @dbname;
	    SET @status   = 'DONE'
	END
    ELSE
	BEGIN
	    SET @msg = 'Failed to create ' + @dbname;
	    SET @status   = 'ABORTING'
	END

    EXEC spEndStep @taskID, @stepID, 
		@status,
		@msg,
		@msg
    --
    RETURN(@err);
    --
END
GO


--=======================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNewFinishTask' AND type = 'P')
    DROP PROCEDURE spNewFinishTask
GO
--
CREATE PROCEDURE spNewFinishTask ( 
---------------------------------------------------
--/H Insert a new FINISH Task into the Loadadmin database
---------------------------------------------------
--/T This creates the parent record of a new Task.
--/T Specific to creating a FINISH Task only
--/T In the end, it returns the taskid.
---------------------------------------------------
	@id varchar(32), 
	@dataset varchar(16),
	@user varchar(32),
	@comment varchar(2048),
	@taskid int OUTPUT
)
AS 
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE 
	@dbname varchar(64),
	@stepid int,
	@myHost varchar(64),
	@type varchar(16),
	@path varchar(128),
	@loadSupportHost varchar(64),
	@publishtaskid int,
	@publishhost varchar(64), 
	@publishdb varchar(64),
	@backupfilename varchar(256),
	@pubtype varchar(32);
    
    SET @dbname = @dataset+'_FINI'+@id;
    SELECT @myHost = @@servername;
    --
    SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver)
    -- call it recursively if it is on a remote server. This avoids distributed tranasactions
    IF (@myHost != @loadSupportHost)
	BEGIN
	    declare @proc varchar(1000)
	    set @proc = @loadSupportHost + '.loadSupport.dbo.spNewFinishTask'
	    execute @proc @id, @dataset, @user, @comment, @taskid OUTPUT WITH RECOMPILE
	RETURN
	END
    --
    SET @type	= 'FINISH';
    SET @path   = '\\';
    SET @pubtype='BEST-PUB'
    --
    SELECT TOP 1 
	@publishtaskid=taskid, @publishhost=hostname, @publishdb=dbname 
	FROM Task WITH (nolock)
-- 	WHERE type=@pubtype and dataset=@dataset 
	WHERE type IN ('BEST-PUB','TARGET-PUB','RUNS-PUB') and dataset=@dataset 
	ORDER BY id

    IF @publishtaskid IS NULL
	BEGIN
	    PRINT 'ERROR: need a publish database'
	    RETURN(1);		
	END

    SET @backupfilename='';

    BEGIN TRANSACTION
	INSERT INTO Task(dbname,step,taskstatus,dataset,type,[id],path,[user],
		tstart,tlast,publishtaskid,publishdb,publishhost,backupfilename,comment) 
	    VALUES(@dbname,'','',@dataset,@type,@id,@path,@user,
		CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,
		@publishtaskid,@publishdb,@publishhost,@backupfilename,@comment);
	SELECT @taskid=max(taskid) FROM Task WITH (nolock)
	    WHERE dbname=@dbname;
    COMMIT TRANSACTION

    -- create a new step, to indicate EXPORT
    EXEC spNewStep @taskid,'READY','DONE','Ready to do finish', @stepid OUTPUT;
    --
END
GO



--=======================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNewFinishStep' AND type = 'P')
    DROP PROCEDURE spNewFinishStep
GO
--
CREATE PROCEDURE spNewFinishStep ( 
---------------------------------------------------
--/H Insert a new FINISH-step task into the Loadadmin database
---------------------------------------------------
--/T This creates the parent record of a new Task.
--/T Specific to creating a task for a FINISH step only
--/T In the end, it returns the taskid.
---------------------------------------------------
	@id varchar(32), 
	@dataset varchar(16),
	@user varchar(32),
	@type varchar(16),
	@phase varchar(16),
	@xmode varchar(16),
	@comment varchar(2048)
)
AS 
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE 
	@dbname varchar(64),
	@stepid int,
	@taskid int,
	@myHost varchar(64),
	@path varchar(128),
	@loadSupportHost varchar(64),
	@publishtaskid int,
	@publishhost varchar(64), 
	@publishdb varchar(64),
	@backupfilename varchar(256),
	@pubtype varchar(32);
    
    SET @dbname = @dataset+'_FINI'+@id;
    SELECT @myHost = @@servername;
    --
    SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver)
    -- call it recursively if it is on a remote server. This avoids distributed tranasactions
    IF (@myHost != @loadSupportHost)
	BEGIN
	    declare @proc varchar(1000)
	    set @proc = @loadSupportHost + '.loadSupport.dbo.spNewFinishStep'
	    execute @proc @id, @dataset, @user, @comment, @taskid OUTPUT WITH RECOMPILE
	RETURN
	END
    --
    SET @pubtype=@type;
    SET @type	= 'FINISH';
    SET @path   = @xmode;
    --
    SELECT TOP 1 
	@publishtaskid=taskid, @publishhost=hostname, @publishdb=dbname 
	FROM Task WITH (nolock)
	WHERE type=@pubtype and dataset=@dataset 
	ORDER BY id

    IF @publishtaskid IS NULL
	BEGIN
	    PRINT 'ERROR: need a publish database'
	    RETURN(1);		
	END

    SET @backupfilename='';

    BEGIN TRANSACTION
	INSERT INTO Task(dbname,step,taskstatus,dataset,type,[id],path,[user],
--		tstart,tlast,publishtaskid,publishdb,publishhost,backupfilename,comment,phase,mode) 
		tstart,tlast,publishtaskid,publishdb,publishhost,backupfilename,comment) 
	    VALUES(@dbname,@phase,'',@dataset,@type,@id,@path,@user,
		CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,
		@publishtaskid,@publishdb,@publishhost,@backupfilename,@comment);
--		@publishtaskid,@publishdb,@publishhost,@backupfilename,@comment,@phase,@xmode);
	SELECT @taskid=max(taskid) FROM Task WITH (nolock)
	    WHERE dbname=@dbname;
    COMMIT TRANSACTION

    -- create a new step, to indicate EXPORT
    EXEC spNewStep @taskid,'READY','DONE','Ready to do finish', @stepid OUTPUT;
    --
END
GO



--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spGrantExec' AND type = 'P')
    DROP PROCEDURE spGrantExec
GO

CREATE PROCEDURE spGrantExec (@user varchar(16) = 'Test')
----------------------------------------------------------
--/H Grant SELECT and EXECUTE access to a given user
----------------------------------------------------------
--/T Works for all user tables, views, procedures and functions 
----------------------------------------------------------
AS BEGIN
    DECLARE  OurFunctions CURSOR READ_ONLY FOR 
	select name, xType from sysobjects 
	where uid=1 and xtype in ('FN','P','TF','U','V') 
	    and name not like 'dt_%' 
        order by xtype 

    DECLARE @name varchar(250), @type varchar(10) 
    OPEN OurFunctions 
    --
    FETCH NEXT FROM OurFunctions INTO @name, @type 
    WHILE (@@fetch_status <> -1) 
    BEGIN 
	IF (@@fetch_status <> -2) 
	  BEGIN 
	    -- print 'granting access to: ' + @name + ':'+ @type 
	    if (@type in ('FN', 'P')) 
		execute ('GRANT EXECUTE ON '+  @name + ' to '+@user) 
	    else 
		execute ('GRANT SELECT  ON '+  @name + ' to '+@user) 
	  END 
	FETCH NEXT FROM OurFunctions INTO @name, @type 
    END 
    CLOSE OurFunctions 
    DEALLOCATE OurFunctions 
END
GO 


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spCreateSqlAgentJob' AND type = 'P')
    DROP PROCEDURE spCreateSqlAgentJob
GO

CREATE PROCEDURE spCreateSqlAgentJob(@role varchar(8))
-----------------------------------------------------
--/H Creates and configures a SqlAgent in PUB or LOAD role
-----------------------------------------------------
--/T Fetches the @user from the loadadmin database
-----------------------------------------------------
AS BEGIN

--  BEGIN TRANSACTION            

    DECLARE @loadagent VARCHAR(128);
    SELECT @loadagent=value 
	FROM loadsupport..Constants WITH (nolock)
	WHERE name='loadagent';

    DECLARE
	@jobID 	  binary(16),
	@jobname  nvarchar(32),
	@desc	  nvarchar(256),
	@user	  nvarchar(64),
	@stepname nvarchar(64),
	@cmd	  nvarchar(256),
	@msg	  nvarchar(2048),
	@ret 	  int    

    SET @ret = 0;

    -- get the username
    SELECT @user=CAST(value as nvarchar(64)) 
	FROM Constants WITH (nolock)
	WHERE name=@loadagent;

    IF (@role = 'PUB')
      BEGIN
	SET @jobname  	= N'PUB';
	SET @desc	= N'Publish task';
	SET @stepname 	= N'Pub';
	SET @cmd	= N'EXEC spNextPubTask';
      END

    ELSE IF (@role = 'LOAD')
      BEGIN
	SET @jobname  	= N'LOAD';
	SET @desc	= N'Load task';
	SET @stepname 	= N'Load';
	SET @cmd	= N'EXEC spNextLoadTask';
      END

    ELSE
      BEGIN
	RAISERROR (N'Role not PUB or LOAD.', 16, 1) ;
--	GOTO QuitWithRollback
      END


    IF (SELECT COUNT(*) FROM msdb.dbo.syscategories 
	WHERE name = N'[Uncategorized (Local)]') < 1 
  	EXECUTE msdb.dbo.sp_add_category @name = N'[Uncategorized (Local)]'

    -- Delete the job with the same name (if it exists)
    
    SELECT @jobID = job_id FROM   msdb.dbo.sysjobs    
	WHERE (name = @jobname)       

    IF (@jobID IS NOT NULL)    
      BEGIN  
	-- Check if the job is a multi-server job  
	IF (EXISTS (SELECT * FROM msdb.dbo.sysjobservers 
              WHERE (job_id = @jobID) AND (server_id <> 0)) ) 
	  BEGIN 

	    -- There is, so abort the script
	    SET @msg = N'Unable to import job '+ @jobname + 
		' since there is already a multi-server job with this name.'
	    RAISERROR ( @msg, 16, 1) ;
--	    GOTO QuitWithRollback

	  END 

	ELSE
	  BEGIN
	    -- Delete the [local] job 
	    EXECUTE msdb.dbo.sp_delete_job @job_name = @jobname; 
	  END
	SELECT @jobID = NULL
      END 


  BEGIN 

    -------------------------
    -- Add the job
    -------------------------

    EXECUTE @ret = msdb.dbo.sp_add_job 
	@job_id 		= @jobID OUTPUT, 
	@job_name 		= @jobname, 
	@owner_login_name 	= 'sa', 
	@description 		= @desc, 
	@category_name 		= N'[Uncategorized (Local)]', 
	@enabled 		= 1, 
	@notify_level_email    	= 0, 
	@notify_level_page     	= 0, 
	@notify_level_netsend  	= 0, 
	@notify_level_eventlog 	= 2, 
	@delete_level          	= 0

--    IF (@@ERROR <> 0 OR @ret <> 0) GOTO QuitWithRollback 

    -------------------------
    -- Add the job steps
    -------------------------

    EXECUTE @ret = msdb.dbo.sp_add_jobstep
	@job_id    		= @jobID, 
	@step_id   		= 1, 
	@step_name 		= @stepname, 
	@command   		= @cmd, 
	@database_name 		= N'loadsupport', 
	@server    		= N'', 
	@database_user_name   	= N'', 
	@subsystem 		= N'TSQL', 
	@cmdexec_success_code 	= 0, 
	@flags              	= 0, 
	@retry_attempts     	= 0, 
	@retry_interval     	= 1, 
	@output_file_name   	= N'', 
	@on_success_step_id 	= 0, 
	@on_success_action  	= 1, 
	@on_fail_step_id    	= 0, 
	@on_fail_action     	= 2

--    IF (@@ERROR <> 0 OR @ret <> 0) GOTO QuitWithRollback
 

    EXECUTE @ret = msdb.dbo.sp_update_job 
	@job_id = @JobID, 
	@start_step_id = 1 

--    IF (@@ERROR <> 0 OR @ret <> 0) GOTO QuitWithRollback 

    -------------------------
    -- Add the job schedules
    -------------------------

    EXECUTE @ret = msdb.dbo.sp_add_jobschedule 
	@job_id    		= @jobID, 
	@name      		= N'oneminute', 
	@enabled   		= 1, 
	@freq_type 		= 4, 
	@active_start_date 	= 20030102, 
	@active_start_time 	= 000000, 
	@freq_interval     	= 1, 
	@freq_subday_type  	= 4, 
	@freq_subday_interval   = 1, 
	@freq_relative_interval = 0, 
	@freq_recurrence_factor = 0, 
	@active_end_date        = 99991231, 
	@active_end_time        = 235959

--    IF (@@ERROR <> 0 OR @ret <> 0) GOTO QuitWithRollback 

    -------------------------
    -- Add the Target Servers
    -------------------------

    EXECUTE @ret = msdb.dbo.sp_add_jobserver 
	@job_id = @jobID, 
	@server_name = N'(local)' 

--    IF (@@ERROR <> 0 OR @ret <> 0) GOTO QuitWithRollback 

  END

--    COMMIT TRANSACTION          
--    GOTO   EndSave              


--    QuitWithRollback:
--
--	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 

--    EndSave: 

END
GO


PRINT cast(getdate() as varchar(64)) + '  -- Loadsupport-utils stored procedures created'
go
