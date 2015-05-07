--========================================================
-- loadsupport-steps.sql
-- 2002-10-04 Alex Szalay and Jim Gray
----------------------------------------------------------
-- The actual high level steps executed by the framework
-- 2003-01-11	Alex: modified spFinish to handle missing
--	destination databases
-- 2005-10-13   Ani: Added check for existence of each of
--                   the pub DBs before attempting FINISH
--                   on them.  Also set phase to 'ALL'.
-- 2005-10-22   Ani: Made failure of spFinishStep on a
--		     given pub-db non-fatal so it will go
--                   on to the next one.  This will enable
--                   it to finish BEST even if TARG doesnt
--                   exist, etc.
-- 2006-08-21   Ani: Added printing of SQL server error
--                   message if spFinishStep fails.
-- 2006-11-28	Ani: Fix for PR #7167: added existence 
--		     check for spUploadFinishStep.
-- 2009-11-11	Ani: Updated spBuild to use task data and
--                   log file paths for task db if they 
--                   exist in Constants table. 
-- 2010-08-27   Ani: Updated spBuild to use task.datafilename
--                   as the initial task db data directory 
--                   path that it passes to spCreateDatabase.
-- 2010-08-31   Ani: Added @datapath param to spUploadTask to
--                   pass the task db file directory path to
--                   spNewTask.
--========================================================
SET NOCOUNT ON
GO

--==========================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spCheck' AND type = 'P')
    DROP PROCEDURE spCheck
GO
--
CREATE PROCEDURE spCheck (@taskid int) 
----------------------------------------------------------------------
--/H Perform the CSV checking
----------------------------------------------------------------------
--/T Runs the VBScript task to perform the CSV checking
----------------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1)
    ------------------------------------------
    DECLARE 
	@vbsdir varchar(64),
	@cmd varchar(1024),
	@taskstatus varchar(32),
	@stepid int,
	@loadserver varchar(64),
	@ret int;
    --
    EXEC spStartStep @taskid, @stepid OUTPUT,
	'CHECK',
	'WORKING',
	'Starting CSV check',
	'Starting CSV check';
    --
    IF @stepid IS NULL RETURN(1);
    -----------------------------------------------
    SELECT @vbsdir=value FROM Constants WITH (nolock) 
	WHERE name='vbsdir'

    SELECT @loadserver=name FROM LoadServer;
    SET @cmd = 'cscript '+@vbsdir+'csvrobot.vbs '
	+ cast(@taskid as varchar(8)) + ' -S'+@loadserver;

    EXEC @ret=master.dbo.xp_cmdshell @cmd, NO_OUTPUT
    -----------------------------------------------
    -- create final logs (writes to phase table)
    SELECT
	@taskstatus=taskstatus
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;

    -- if step failed, the script has already closed the step
    IF @taskstatus='WORKING'
	EXEC spEndStep @taskid, @stepid,
		'DONE', 
		'Finished CSV checking', 
		'Finished CSV checking' 
    RETURN(0);
    --
END
GO


--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spBuild]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spBuild]
GO
--
CREATE PROCEDURE spBuild (@taskid int)
------------------------------------------------------------
--/H Build a TaskDB
------------------------------------------------------------
--/T <samp> 
--/T EXEC spBuild @taskid
--/T </samp>
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1)
    ------------------------------------------
    DECLARE
	@dbname varchar(64), 
	@hostname varchar(64),
	@dataset varchar(16),
	@type varchar(16),
	@dpath varchar(64), 
	@datasize int,
	@logsize int
    SELECT
	@dbname=dbname, 
	@hostname=hostname,
	@dataset=dataset,
	@type=type,
	@dpath=datafilename,
	@datasize=datasize, 
	@logsize=logsize
	FROM Task WITH (nolock) 
	WHERE taskid=@taskid;
    ------------------------------------------
    DECLARE
	@stepid int,
	@status varchar(64),
	@lpath varchar(64),
	@phasemsg varchar(256),
	@err int,
	@ret int;
    --
    SET @err  = 0;
    --
    EXEC spStartStep @taskid, @stepid OUTPUT,
	'BUILD',
	'WORKING',
	'Starting DB build',
	'Starting DB build';
    --
    IF @stepid IS NULL RETURN(1);
    ------------------------------------------

	-- @dpath contains the value of the datafilename column in Task table.
    -- if datafilename column is set in Task table, a taskdatapath was selected
    -- use that as the directory path for the data and log files
    IF @dpath = ''
		BEGIN
		    IF EXISTS (SELECT value FROM Constants WHERE name='taskdatapath')
				BEGIN
					SELECT @dpath=value FROM Constants WHERE name='taskdatapath'
    				SELECT @lpath=value FROM Constants WHERE name='taskdatapath'
				END
			ELSE
				BEGIN
					SELECT @dpath=value FROM Constants WHERE name='datapath'
    				SELECT @lpath=value FROM Constants WHERE name='logpath'
				END
		END
	ELSE
		SET @lpath = @dpath
    --
	DBCC TRACEON(1807)		-- turn on flag that allows writing db files on remote shares
    EXEC @ret = spCreateDatabase @taskid, @stepid, @dbname,
	@dpath, @lpath, @datasize, @logsize, @dataset, @type
    IF @ret>0
	RETURN(1);
    --
    EXEC @ret = spCreateSchema @taskid, @stepid
    SET  @err = @err + @ret;

    -------------------------------------------
    IF @err = 0 
	BEGIN
	    SET @phasemsg = 'Finished building DB';
	    SET @status = 'DONE';
	END
    ELSE
	BEGIN
	    SET @phasemsg = 'Failed to build DB';
	    SET @status = 'ABORTING';
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

--==========================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spPreload]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spPreload]
GO
--
CREATE PROCEDURE spPreload(@taskid int)
------------------------------------------------------------
--/H Runs the DTS LoadTask package on the loadadmin server
------------------------------------------------------------
--/T Very crude, needs work. 
------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	--
	IF @taskid IS NULL RETURN(1);
	--
	DECLARE @ret int,
		@stepid int, 
		@msg varchar(2048),
		@cmd varchar(1000), 
		@server varchar(64)
	SET @ret = 0;
	-------------------------------------------------------------
	-- register the step.
	SET @msg  = 'Starting SQL Preload';
	EXEC loadSupport.dbo.spStartStep @taskID, @stepID OUTPUT,
		'PRELOAD',	
		'WORKING',
		@msg, @msg

	-- if step create fails, complain and return.
	IF @stepid IS NULL
	    BEGIN
		SET @msg = 'Could not create Preload step for task '  
			+ str(@taskID)
	 	EXEC loadSupport.dbo.spNewPhase 0, 0,  
			'Framework Error',  
			'ERROR',  
			@msg 
		RETURN(1);
	    END
	------------------------------------------------------------
	EXEC @ret = spPreLoadStep @taskid, @stepid;

	RETURN(@ret);
END
GO




--===========================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spValidate]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spValidate]
GO
--
CREATE PROCEDURE spValidate(@taskid int)
------------------------------------------------------------
--/H Runs the spValidate package on the loadadmin server
------------------------------------------------------------
--/T Very crude, needs work. 
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1);
    -----------------------------------------
    DECLARE
	@dbname varchar(64)

    SELECT
	@dbname=dbname 
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;
    -----------------------------------------
    DECLARE
	@cmd nvarchar(1000), 
	@ret int;
    -----------------------------------------

    SET @cmd = N'DECLARE @stepid int;
    EXEC '+@dbname+'.dbo.spValidateStep '
	+ cast(@taskid as varchar(16))
	+ ', @stepid OUTPUT';
    EXEC @ret=sp_executesql @cmd;

    -----------------------------------------
    IF @@error>0
	RETURN(1);

    RETURN(@ret);
END
GO

--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spBackup]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spBackup]
GO
--
CREATE PROCEDURE spBackup(@taskid int)
------------------------------------------------------------
--/H Runs the spBackup package on the loadadmin server
------------------------------------------------------------
--/T Very crude, needs work. 
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1);
    ------------------------------------
    DECLARE
	@dbname varchar(64)
    SELECT
	@dbname=dbname 
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;
    ------------------------------------
    DECLARE
	@cmd nvarchar(1000),
	@phasemsg varchar(1024),
	@stepid int,
	@ret int
    ------------------------------------

    SET @cmd = N'DECLARE @stepid int;
    EXEC '+@dbname+'.dbo.spBackupStep '
	+cast(@taskid as varchar(16))
	+', @stepid OUTPUT';
    EXEC @ret=sp_executesql @cmd;

    -------------------------------------
    RETURN(@ret);
END
GO


--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spDetach]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spDetach]
GO
--
CREATE PROCEDURE spDetach(@taskid int)
------------------------------------------------------------
--/H Runs the spDetach step on the loadadmin server
------------------------------------------------------------
--/T Very crude, needs work. 
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1);
    ----------------------------------------------
    DECLARE 
	@dbname varchar(64)
    SELECT
	@dbname=dbname 
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;
    -----------------------------------------------
    DECLARE
	@cmd nvarchar(1000),
	@status varchar(16),
	@msg varchar(1024),
	@stepid int,
	@ret int;

    EXEC spStartStep @taskid, @stepid OUTPUT,
	'DETACH',
	'WORKING',
	'Starting DB detach',
	'Starting DB detach';
    --
    IF @stepid IS NULL RETURN(1);
    ------------------------------------------------------
    -- Detach Database  and skip the update statistics task.
    EXEC @ret=sp_detach_db @dbname , 'true' 
    IF @ret=0 
	BEGIN
	    SET @status = 'DONE';
	    SET @msg = 'Detached Database ' + @dbname;
	END
    ELSE
	BEGIN
	    SET @status = 'ABORTING';
	    SET @msg = 'Could not detach database ' + @dbname;
	END
    -----------------------------------------------
    -- create final log
    EXEC spEndStep @taskID, @stepID, 
		@status,@msg, @msg;
    --
    RETURN(@ret);
END
GO


--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spPublish]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spPublish]
GO
--
CREATE PROCEDURE spPublish(@taskid int)
------------------------------------------------------------
--/H Runs the spPublish step on the loadsupport database
------------------------------------------------------------
--/T Calls the spPublishStep procedure on the destination database
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1);
    ----------------------------------------------------
    DECLARE 
	@dbname varchar(64),
	@publishdb varchar(64),
	@publishhost varchar(64)

    SELECT
	@dbname=dbname,
	@publishdb=publishdb, 
	@publishhost=publishhost 
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;

    IF (@publishhost IS NULL) OR (@publishdb IS NULL) RETURN(1);
    -----------------------------------------------------
    DECLARE
	@cmd nvarchar(1000),
	@ret int;

    -----------------------------------------------------
    -- run the publish step
    SET @cmd = 'EXEC '+@publishhost+'.'
	+ @publishdb+'.dbo.spPublishStep '
	+ cast(@taskid as varchar(32));
    EXEC @ret=sp_executesql @cmd;
    -----------------------------------------------------

    RETURN(@ret);
END
GO


--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spCleanup]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spCleanup]
GO
--
CREATE PROCEDURE spCleanup(@taskid int)
------------------------------------------------------------
--/H Runs the spDetach step on the loadadmin server
------------------------------------------------------------
--/T Very crude, needs work. 
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1);
    ---------------------------------------------------
    DECLARE 
	@dbname varchar(64), 
	@publishdb varchar(128),
	@publishhost varchar(64)

    SELECT
	@dbname=dbname, 
	@publishdb=publishdb, 
	@publishhost=publishhost
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;
    --
    IF (@publishhost IS NULL) OR (@publishdb IS NULL) RETURN(1);
    -------------------------------------------------
    DECLARE
	@msg varchar(1024),
	@status varchar(16),
	@cmd nvarchar(1000),
	@stepid int,
	@ret int;

    EXEC spStartStep @taskid, @stepid OUTPUT,
	'CLEANUP',
	'WORKING',
	'Starting cleanup',
	'Starting cleanup';
    IF @stepid IS NULL RETURN(1);
    ------------------------------------------------------
    -- run the cleanup step
    SET @cmd = N'DROP DATABASE '+@dbname;
    EXEC @ret=master.dbo.sp_executesql @cmd;
    --
    IF @ret=0
	BEGIN
	    SET @status = 'DONE';
	    SET @msg	= 'Deleted db ' + @dbname;
	END
    ELSE
	BEGIN
	    SET @status	= 'ABORTING';
	    SET @msg 	= 'Could not delete db '+@dbname;
	END
    ------------------------------------------------------
    -- create final log
    EXEC spEndStep @taskID, @stepID, 
		@status, @msg, @msg
    --
    RETURN(@ret);
END
GO


--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spDone]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spDone]
GO
--
CREATE PROCEDURE spDone(@taskid int)
------------------------------------------------------------
--/H We are done with processing of the Task
------------------------------------------------------------
--/T Set the task status to DONE
------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1);
    --
    UPDATE Task 
	SET taskstatus='DONE'
	WHERE taskid=@taskid;

    RETURN(0);
END
GO

--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spFinishOne]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spFinishOne]
GO
--
CREATE PROCEDURE spFinishOne(
	@taskid int,
	@stepid int,
	@dataset varchar(16),
	@pubtype varchar(16),
	@phasename varchar(64),
	@execmode varchar(16),
	@mustrun int,
	@run int OUTPUT
)
------------------------------------------------------------
--/H Runs the spFinishStep on a single destination database
------------------------------------------------------------
--/T Calls the spFinishStep procedure on the destination database
--/T of type @pubtype, that belongs to @dataset.
--/T @mustrun = 1 means that it needs to run, because of dependencies.
------------------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    ----------------------------------------------------
    DECLARE
	@finishid int,
	@dbname varchar(128),
	@hostname varchar(64),
	@status varchar(16),
	@desc varchar(256),
	@stepname varchar(32)
    --
    SET @run = 0;
    --
    SELECT @dataset=dataset
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;
    --
    IF (@dataset IS NULL) RETURN(1);
    --------------------------------------------------
    DECLARE
	@cmd nvarchar(1000),
	@msg varchar(1024),
	@qid int,
	@ret int;
    --
    SET @ret = 0;
    --------------------------------------------------
    -- get the properties of the destination task
    --
    SET @finishid = null;
    SELECT
	@finishid  = t.taskid,
	@dbname	   = t.dbname,
	@hostname  = t.hostname,
	@stepname  = t.step,
	@status	   = s.status
	FROM Task t, Step s WITH (nolock)
	WHERE dataset=@dataset
	and taskstatus NOT IN ('KILLED', 'ABORTING')
	and UPPER(type)=@pubtype;
    --
    -- if target does not exist, then exit
    IF (@finishid IS NULL)
	BEGIN
	    SET @msg = 'Could not find '+@pubtype+' database';
	    EXEC spNewPhase @taskid, @stepid,  
		'Finish', 'OK', @msg ;
	    RETURN(0);
	END
    --
    -- check whether destination is in FINISH state
    IF (@stepname='FINISH' and @status='DONE' and @mustrun=0)
	BEGIN
	    SET @msg = @pubtype+' database is in FINISH state';
	    EXEC spNewPhase @taskid, @stepid,  
		'Finish', 'OK', @msg ;
	    RETURN(0);
	END

    -- otherwise execute the spFinishStep
    SET @cmd = 'DECLARE @qid int;EXEC '+@hostname+'.'+@dbname+'.dbo.spFinishStep '+

	cast(@finishid as varchar(32)) + ', @qid OUTPUT,''' + @phasename + ''',''' + @execmode + ''''
    EXEC @ret=sp_executesql @cmd;
    --
    IF @ret>0 
	BEGIN
	    SET @msg = 'spFinishStep failed on '+@hostname+'.'+@dbname;
    	    IF @@ERROR<>0 OR @ret>0
		BEGIN
		    SELECT top 1 @desc=description
            	    FROM master.dbo.sysmessages WHERE error=@ret
	    	    SET @msg = @msg + '; SQL returned ERROR: '+@desc;
		END

--	    EXEC spEndStep @taskID, @stepID, 
--		'ABORTING', @msg, @msg;
	    EXEC spNewPhase @taskID, @stepID, 
		'Finish', 'WARNING', @msg;
	END
    ELSE
	BEGIN
	    SET @msg = 'spFinishStep completed on '+@hostname+'.'+@dbname;
	    EXEC spNewPhase @taskid, @stepid,  
		'Finish', 'OK', @msg ;
	END
    --
    RETURN(@ret);
END
GO

--==============================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'[dbo].[spFinish]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spFinish]
GO
--
CREATE PROCEDURE spFinish(@taskid int)
------------------------------------------------------------
--/H Runs the spFinish step on the loadsupport database
------------------------------------------------------------
--/T Calls the spFinishStep procedure on the destination databases
--/T First we need to run spFinishStep on a TARGET-PUB type,
--/T then on a BEST-PUB type, and if exists, on a RUNS-PUB type.
------------------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    --
    IF @taskid IS NULL RETURN(1);
    ----------------------------------------------------
    DECLARE @dataset varchar(16), @phase varchar(64), 
	    @type varchar(32), @xmode varchar(16);
    --
    SELECT @dataset=dataset,
	   @phase=step,
	   @type=type,
	   @xmode=path
	FROM Task WITH (nolock)
	WHERE taskid=@taskid;
    --
    IF (@dataset IS NULL) RETURN(1);
    --------------------------------------------------
    DECLARE
	@stepid int,
	@mustrun int,
	@run int,
	@ret int;
    --
    SET @ret = 0;
    SET @run = 0;
    SET @mustrun = 0;
--    IF @xmode = '\\' 
	SET @xmode = 'resume';
    SET @phase = 'ALL'
    --------------------------------------------------
    EXEC spStartStep @taskid, @stepid OUTPUT,
	'FINISH',
	'WORKING',
	'Starting Finish step',
	'Starting Finish step';
    --
    IF @stepid IS NULL RETURN(1);
    --------------------------------------------------
    -- run the finish step on BEST-PUB
    --
    IF ((@phase = 'ALL') OR (@type = 'BEST-PUB'))
	AND EXISTS (SELECT [name] FROM master.dbo.sysdatabases WHERE [name] LIKE '%BEST%')
	BEGIN
	    EXEC @ret = spFinishOne @taskid, @stepid, @dataset, 
		'BEST-PUB', @phase, @xmode, @mustrun, @run OUTPUT;
	    --
--	    IF (@ret>1) RETURN(1);
	    IF (@ret = 0)	
		EXEC spNewPhase @taskid, @stepid, 'FINISH', 'WORKING', 'spFinishOne done BEST-PUB';
	    --
	    SET @mustrun = @mustrun + @run;
	    IF @xmode = N'single step' RETURN(0);
	END
    --------------------------------------------------
    -- run the finish step on RUNS-PUB
    --
    IF EXISTS (SELECT [name] FROM master.dbo.sysdatabases WHERE [name] LIKE '%RUNS%')
	BEGIN
	    EXEC @ret = spFinishOne @taskid, @stepid, @dataset, 
		'RUNS-PUB', @phase, @xmode, @mustrun, @run OUTPUT;
	    --
	    IF (@ret>1) RETURN(1);
	    EXEC spNewPhase @taskid, @stepid, 'FINISH', 'WORKING', 'spFinishOne done RUNS-PUB';
	    --
	    SET @mustrun = @mustrun + @run;
	END
    --------------------------------------------------
commonExit:
    EXEC spEndStep @taskID, @stepID, 
	'DONE',
	'Finish completed',
	'Finish completed';
    --
    EXEC spDone @taskid;
    --
    RETURN(0);
END
GO


--=======================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spUploadTask' AND type = 'P')
    DROP PROCEDURE spUploadTask
GO
--
CREATE PROCEDURE spUploadTask ( 
---------------------------------------------------
--/H Insert a new Task into the Loadadmin database
---------------------------------------------------
--/T This creates the parent record of a new Task.
--/T Contains the task type, its unique id, and the
--/T location of the CSV files specified by the host
--/T and the path fields. The name of the user 
--/T submitting this task for processing must also
--/T be specified. An optional comment can also be
--/T given. This record is always updated with the
--/T current state of the task. The timestamp is 
--/T updated after each step as well. The original 
--/T creation date is carried by the create CSV event.
--/T The procedure will also build a unique name for 
--/T the  database. In the end, it returns the
--/T taskid.
---------------------------------------------------
	@id varchar(32), 
	@dataset varchar(16),
	@type varchar(16), 
	@path varchar(256), 
	@user varchar(32),
	@datapath varchar(128),
	@comment varchar(2048)
)
AS 
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE 
	@taskid int,
	@ret int;
    -------------------------------------------------
    IF UPPER(@type)='FINISH'
	EXEC @ret = dbo.spNewFinishTask @id, @dataset, @user, @comment, @taskid OUTPUT;
    ELSE
	EXEC @ret = dbo.spNewTask @id, @dataset, @type, @path, @user, @datapath, @comment, @taskid OUTPUT;
    --
    IF @ret>0
	BEGIN
	    SELECT 'Upload has failed';
	    RETURN(@ret);
	END
    --
    SELECT 'Upload successful';
    -------------------------------------------------
    IF UPPER(@type)!='FINISH'
	EXEC @ret = dbo.spCheck @taskid;

    RETURN(0);

END
GO


-----------------------------------------------------
IF EXISTS (SELECT name FROM   sysobjects 
           WHERE  name = N'spUploadFinishStep' AND type = 'P')
    DROP PROCEDURE spUploadFinishStep
GO
--
CREATE PROCEDURE spUploadFinishStep ( 
---------------------------------------------------
--/H Run a step in the FINISH Task already in the Loadadmin database
---------------------------------------------------
--/T This assumes that the FINISH task already exists, and runs the 
--/T specified step (actually phase, not step, in sqlLoader jargon)
--/T in the task.  Depending on the value of xmode, it then stops
--/T (xmode='onestep') or continues with the rest of the FINISH
--/T phases (xmode='resume').
---------------------------------------------------
	@taskID varchar(32), 
	@dataset varchar(16),
	@user varchar(32),
	@type varchar(16), 
	@step varchar(64), 
	@xmode varchar(32), 
	@comment varchar(2048)
)
AS 
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE 
	@stepid int, @newtaskid int,
	@ret int;
    -------------------------------------------------
    SET @type = @type + '-PUB';
    EXEC @ret = dbo.spNewFinishStep @taskid, @dataset, @user, @type, 
			@step, @xmode, @comment;
    IF @ret>0
	BEGIN
	    SELECT 'FINISH upload has failed';
	    RETURN(@ret);
	END
    ELSE
	BEGIN
	    SELECT 'FINISH upload successful';
	END
    --
    SELECT 'FINISH Upload successful';
    -------------------------------------------------
    RETURN(0);
END
GO




print cast(getdate() as varchar(64)) 
    + '  -- Loadsupport-steps stored procedures created'
