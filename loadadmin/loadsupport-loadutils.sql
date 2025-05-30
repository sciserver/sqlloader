--========================================================
-- loadsupport-loadutils.sql
-- 2002-12-22	Alex Szalay
----------------------------------------------------------
-- separated off of loadsupport-utils.sql
-- 2002-12-22	Alex: moved here the spNextFile proc
----------------------------------------------------------
-- 2010-06-21 Naren: Modified spLoadZoom,spLoadSpecobj to run without DTS

--========================================================

SET NOCOUNT ON;
GO


--========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spTestRowCount]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spTestRowCount]
GO

CREATE PROCEDURE spTestRowCount(
	@taskid int,
	@stepid int,
	@dbname varchar(64)
)
-------------------------------------------------------------
--/H Test whether all rows have been loaded in @dbname
--/A
--/T Part of the loading process
-------------------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
	@cmd nvarchar(2048),
	@msg varchar(2048);
    --
    DECLARE @files TABLE ([name] varchar(32), nlines bigint);
    --
    INSERT @files
	SELECT 	targettable as [name], 
		sum(cast(nlines as bigint)) as nlines
	    FROM Files with (nolock)
	    WHERE taskid=@taskid
	    and targettable != 'Frame'
	    GROUP BY targettable;
    --
    SET @cmd = N'CREATE VIEW taskdb AS '
	+ 'SELECT i.name, i.rows FROM '
	+ @dbname + '.dbo.sysindexes i, '
	+ @dbname+'.dbo.sysobjects o '
	+ 'WHERE i.name = o.name and o.xtype=''U''';
    EXEC sp_executesql @cmd;
    --
    SET @msg = '';
    SELECT @msg = @msg+i.[name]+'('
	+cast(f.[nlines] as varchar(16))
	+':'
	+cast(i.[rows] as varchar(16))
	+') '
	FROM taskdb i, @files f
	WHERE f.name=i.name
	    and i.rows != f.nlines
    --
    DROP VIEW taskdb;

    IF @msg != ''
	BEGIN
	    SET @msg = 'Not all rows are loaded: '+@msg;
	    EXEC loadSupport.dbo.spNewPhase @taskID, @stepID, 
		'CSV load','WARNING', @msg;
	END
    ELSE
	    EXEC loadSupport.dbo.spNewPhase @taskid, @stepid,  
		'CSV load','OK', 'All rows have been loaded';
END
GO

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- procedures for file loading
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNextFile' AND type = 'P')
    DROP PROCEDURE spNextFile
GO
--
CREATE PROCEDURE spNextFile (
	@stepid int, 
	@thread int
) 
-----------------------------------------------
--/H Grab the next file of the task/step for bulk insert loading
--/A
--/T Run a transaction, which sets the thread to the number 
--/T provided. If the transaction fails, nothing is set.
-----------------------------------------------
AS BEGIN
    SET NOCOUNT ON
    DECLARE @myHost varchar(1000),
	    @loadSupportHost varchar(100);
    --
    SELECT @myHost = @@servername;
    SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver);
    -------------------------------------------------
    -- call it recursively if it is on a remote server. This avoids distributed transactions
    IF (@myHost != @loadSupportHost)
	BEGIN
		declare @proc varchar(1000)
		set @proc = @loadSupportHost + '.loadSupport.dbo.spNextFile '
		execute @proc @stepid, @thread WITH RECOMPILE
		return
	END
    -------------------------------------------------
    BEGIN TRANSACTION
	DECLARE @fileid int;
	SELECT @fileid=min(fileid) 
	    FROM Files WITH (nolock)
	    WHERE stepid=@stepid 
		and status='READY'
	--
	IF @fileid IS NULL 
	    BEGIN
		COMMIT TRANSACTION
		RETURN(-1)
	    END
	--
	UPDATE Files
	    SET thread = @thread,
		status = 'QUEUED'
	    WHERE fileid=@fileid
    COMMIT TRANSACTION
    RETURN(0);
END
GO


--=================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spLoadSpecobj]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spLoadSpecobj]
GO
--
CREATE PROCEDURE [dbo].[spLoadSpecobj] (
	@fileid int
)
AS BEGIN
    SET NOCOUNT ON;
    DECLARE
	@cmd nvarchar(2048),
	@loadserver varchar(128),
	@dbname varchar(128),
	@CsvPath varchar(256),
	@ImagePath varchar(256),
	@taskid int,
	@ret int;
    ------------------------------------------------    
-- get the name of the loadserver
	SELECT 
		@loadserver=value 
	FROM 
		loadsupport.dbo.Constants WITH (nolock)
	WHERE 
		[name]='loadserver';
		
--get csv and Image Paths
	SELECT 
		  @taskid= taskid
		--, @csvid= stepid
		, @csvpath = fname
	FROM 
		loadsupport.dbo.Files WITH (nolock)
	WHERE 
		fileid=@fileid		

-- Get Database Name
	SELECT 
		@dbname = dbname
	FROM 
		Task WITH (nolock)
	WHERE 
		taskid =@taskid 

--This depends if the paths for both csv and images are the same? :: Re-verify this !!!!!!!!!!!!!!!!!!!!!!!
	Set @imagePath = substring(@csvpath,1,(len(@csvpath)-(charindex('\',(REVERSE(@csvpath)),1)-1)))+'Img\';

-- run spMakeSpecObjAll
	SET @cmd = N'EXEC '+@dbname+'.dbo.'	+ 'spMakeSpecObjAll '+
	+ cast(@dbname as varchar(256))+','
	+ ''''+cast(@csvpath as varchar(256))+ '''' +','
	+ ''''+cast(@ImagePath as varchar(256))+ '''' ;	

    EXEC @ret = sp_executesql @cmd;  
    RETURN(@ret);
END

GO



--CREATE PROCEDURE spLoadSpecobj (
--	@fileid int
--)
--AS BEGIN
--    SET NOCOUNT ON;
--    DECLARE
--	@cmd varchar(2048),
--	@loadserver varchar(128),
--	@dtspath varchar(256),
--	@ret int;
--    ------------------------------------------------
--    -- get the name of the loadserver
--    SELECT @loadserver=value FROM Constants WITH (nolock)
--	WHERE [name]='loadserver';
--    SELECT @dtspath=value  FROM Constants WITH (nolock)
--	WHERE [name]='dtsdir';
--    ------------------------------------------------
--    -- insert the specobj
--    SET @cmd = 'dtsrun /F '+ @dtspath+'LoadSpecObj.dts'
--	+ ' /A fileid:3='+cast(@fileid as varchar(16))
--    --
--    EXEC @ret=master.dbo.xp_cmdshell @cmd, NO_OUTPUT
--    RETURN(@ret);
--END
--GO


--=================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spLoadZoom]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spLoadZoom]
GO
--
CREATE PROCEDURE [dbo].[spLoadZoom] (
	@fileid int
)
AS BEGIN
    SET NOCOUNT ON;
   
  DECLARE
	@cmd nvarchar(2048),
	@loadserver varchar(128),
	@dtspath varchar(256),
	@zoom int,
	@ret int,
	@run int,
	@dbname varchar(256),
	@path varchar(256),
	@charcount int,
	@zoomdir varchar(256);

    
    SELECT 
    @zoomdir = f.fname
    ,@dbname = t.dbname 
	FROM 
	loadsupport.dbo.Files f
	,loadsupport.dbo.Task t  WITH (nolock)
	WHERE 
	t.taskid=f.taskid 
	and 
	f.fileid=@fileid
    

--Getting the Run value from the path of zoom directory
    Set @path = @zoomdir;     
    Set @charcount = CHARINDEX('\zoom',@path,1);    
    Set @path = SUBSTRING(@path,1,@charcount-1);    
    Set @charcount=CHARINDEX('\',reverse(@path),1);   
    Set @path = SUBSTRING(@path,len(@path)-(@charcount-1)+1,LEN(@path));
    Set @run = CAST(@path as int);
    
 -- run spMakeFrame
	SET @cmd = N'EXEC '+@dbname+'.dbo.'	+ 'spMakeFrame '+
	+ ''''+cast(@dbname as varchar(256))+ '''' +','
	+ ''''+cast(@zoomdir as varchar(256))+ '''' +','
	+ cast(@run as varchar(16));	

    EXEC @ret = sp_executesql @cmd;         
    RETURN(@ret);
END

GO
--CREATE PROCEDURE spLoadZoom (
--	@fileid int
--)
--AS BEGIN
--    SET NOCOUNT ON;
--    DECLARE
--	@cmd varchar(2048),
--	@loadserver varchar(128),
--	@dtspath varchar(256),
--	@zoom int,
--	@ret int;
--    -----------------------------------------------
--    -- get the name of the loadserver
--    SELECT @loadserver=value FROM Constants WITH (nolock)
--	WHERE [name]='loadserver';
--    SELECT @dtspath=value  FROM Constants WITH (nolock)
--	WHERE [name]='dtsdir';
--    ------------------------------------------------
--    SET @zoom = 30;
--    WHILE(@zoom>=0)
--	BEGIN
--	    -- insert the zoom files
--	    SET @cmd = 'dtsrun /F '+ @dtspath+'LoadOneZoom.dts'
--		+ ' /A fileid:3='+cast(@fileid as varchar(16))
--		+ ' /A zoom:3='+cast(@zoom as varchar(16))
--	    --
--	    EXEC @ret=master.dbo.xp_cmdshell @cmd, NO_OUTPUT
--   	    IF @ret>0 RETURN(@ret);
--	    SET @zoom = @zoom -5;
--	END
--    -----------------------------------------------
--    RETURN(@ret);
--END
--GO


--=================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spLoadCsv]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spLoadCsv]
GO
--
CREATE PROCEDURE spLoadCsv (
	@fileid int,
	@options varchar(256)='FIRSTROW=2,'
)
---------------------------------------------------
--/H Load a single CSV file to the TaskDB
---------------------------------------------------
--/T
---------------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    DECLARE
	@taskid int,
	@stepid int,
	@ret int,
	@targettable varchar(32),
	@fname varchar(256),
	@nlines int,
	@cmd nvarchar(2048),
	@dbname varchar(64);
    --
    SELECT
	@taskid=f.taskid, 
	@stepid=f.stepid,
	@targettable=f.targettable,
	@fname=f.fname,
	@nlines=f.nlines,
	@dbname=t.dbname
	FROM Files f, Task t WITH (nolock)
	WHERE t.taskid=f.taskid 
	   AND f.fileid=@fileid;
    --
    IF @taskid IS NULL RETURN(1);
    --
    IF @nlines=0 RETURN(0);
    --
    SET @cmd = N'BULK INSERT '+@dbname+'.dbo.'+@targettable
	+ ' FROM '''+@fname+''' WITH ('
    + ' FORMAT = ''CSV'', '	
	+ ' DATAFILETYPE = ''char'','
	+ ' FIELDTERMINATOR = '','','
	+ ' ROWTERMINATOR = ''\n'','
	+ ' BATCHSIZE =10000,'
	+ ' CODEPAGE = ''RAW'','
	+ @options + ' TABLOCK)';
    --
    EXEC @ret=sp_executesql @cmd;
    --
    RETURN(@ret);
END
GO


--=================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spFileLoop]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spFileLoop]
GO
--
CREATE PROCEDURE spFileLoop(
	@taskid int,
	@stepid int,
	@thread int
)
---------------------------------------------------------------
--/H Load all files corresponding to a given Task
--/A
--/T Takes a given thread
---------------------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
	@csvid int, 
	@fileid int,
	@status varchar(16),
	@fname varchar(256),
	@loadmethod varchar(32),
	@msg varchar(2048),
	@ret int
    SET @ret = 0;
    --------------------------------------------------------
    -- do a phase log
    EXEC spNewPhase @taskid, @stepid,
	'CSV load',
	'OK',
	'Starting File load';
    --
    SELECT @csvid = max(stepid) FROM Step WITH (nolock)
	WHERE stepname='CHECK'
	    and taskid = @taskid;
     ------------------------------------------------------
     -- start file loop
     WHILE (1=1)
     BEGIN
	EXEC spNextFile @csvid, @thread
	--
	SET @fileid = null;
	SELECT top 1 
	    @fileid = f.fileid,
	    @fname  = f.fname,
	    @loadmethod = f.loadmethod
	    FROM Files f, Step s WITH (nolock)
	    WHERE   f.stepid=s.stepid
		and f.status='QUEUED' 
		and s.stepid=@csvid
		and f.thread=@thread
	--
	IF @fileid IS NULL BREAK;
	--
	UPDATE Files
	    SET status= 'WORKING',
		tstart = CURRENT_TIMESTAMP,
		tstop  = CURRENT_TIMESTAMP
		WHERE fileid= @fileid;
	--
	IF @loadmethod='specobj'
          BEGIN
	    EXEC spNewPhase @taskid, @stepid,
		'spLoadSpecObj',
		'OK',
		'Loading SpecObj';
	    EXEC @ret = spLoadSpecobj @fileid;
	  END
	ELSE IF @loadmethod='zoom'
	    EXEC @ret = spLoadZoom @fileid;
	ELSE IF @loadmethod='default'
	    EXEC @ret = spLoadCSV @fileid;
	ELSE
	    SET @ret = 1 ;
	-- log return status with the file
	SET @status = 'DONE';
	IF @ret>0
	   SET @status='ERROR';
	--
	UPDATE Files
	    SET status=@status,
	    tstop=CURRENT_TIMESTAMP
	    WHERE fileid=@fileid;

	IF @ret>0
	  BEGIN
	    SET @msg = 'Error in loading file '+@fname;
	    EXEC spEndStep @taskid, @stepid,
		'ABORTING',
		@msg, @msg;
	    RETURN(@ret);
	  END
    END
    ------------------------------------------------
    EXEC spNewPhase @taskid, @stepid,
	'CSV load',
	'OK',
	'Finished File load';
    -----------------------------------------------
    -- test whether all files have been loaded
    SELECT @ret=count(*) FROM Files WITH (nolock)
	WHERE taskid=@taskid
	and status !='DONE'

    IF @ret>0
	BEGIN
	    SET @msg = 'Not all files are loaded';
	    EXEC spEndStep @taskID, @stepID, 
			'ABORTING', 
			@msg,
			@msg;
	    RETURN(1);
	END
    ELSE
	BEGIN
	    EXEC spNewPhase @taskid, @stepid,  
		'CSV load',
		'OK', 
		'All files are loaded';
	END
    -----------------------------------------------

    RETURN(0);
END
GO

--========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spPreloadStep]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spPreloadStep]
GO
--
CREATE PROCEDURE spPreloadStep(@taskid int, @stepid int)
-------------------------------------------------------------
--/H Execute the PRELOAD step on this database
--/A
--/T Part of the loading process
-------------------------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    -----------------------------------------------------
    -- local variables
    DECLARE 
	@thread int,
	@hostname varchar(32),
	@dbname varchar(128),
	@cmd nvarchar(2048),
	@msg varchar(2048),  -- holds messages to Step table
	@ret int
    --
    SET @thread = 1;
    -----------------------------------------------------
    -- get the dbname and server for the Task
    SELECT @hostname = hostname, @dbname=dbname
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;
    -----------------------------------------------------
    EXEC @ret = spFileLoop @taskid, @stepid, @thread;
    IF @ret>0 RETURN(1);
    -----------------------------------------------
    -- check the row counts
    EXEC @ret = spTestRowCount @taskid, @stepid, @dbname;
    IF @ret>0 RETURN(1);
    -----------------------------------------------
    -- run spSetValues
    SET @cmd = N'EXEC '+@dbname+'.dbo.'
	+ 'spSetValues '+
	+ cast(@taskid as varchar(16))+','
	+ cast(@stepid as varchar(16));
    EXEC @ret = sp_executesql @cmd;
    IF @ret>0 RETURN(1);
    --------------------------------------------------------------------
    SET @msg = 'Finished SQL preload';
    EXEC loadSupport.dbo.spEndStep @taskID, @stepID, 
	'DONE', @msg, @msg;
    RETURN(0);
    --
END
GO





PRINT cast(getdate() as varchar(64)) + '  -- Loadsupport-loadutils created'
