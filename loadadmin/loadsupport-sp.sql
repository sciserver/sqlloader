--=============================================================
-- loadadmin-sp.sql
-- 2002-09-28 Jim Gray + Alex Szalay
--
-- All the stored procedures needed to manage the high level
-- management of the loading process
-- 2002-09-30	Alex: rearrange some of the sp's
-- 2002-11-12	Jim: added end/halt logic to nextStep
--		fixed a potential race condition in NexStep
-- 2002-12-09:	Alex: added support for FINISH task to spNextTask
--		and to spGetNextTask
-- 2002-12-20	Alex: added spNextLoadTask, spNextPubTask, and
--		commented out spNextTask. Also moved the detection
--		of FINISH task into spNextPubTask
-- 2002-12-22	Alex: moved spNextFile to loadsupport-loadutils.sql
-- 2005-01-11   Ani: Fixed spNewPhase calls with extra param in
--              spStartStep and spEndStep.
-- 2009-07-24   Ani: Added case for WINDOW in spNewTask.
-- 2009-08-31   Ani: Added case for SSPP in spNewTask.
-- 2010-08-26   Ani: Modified hostname setting in spGetNextTask,
--              added function fCheckPath.
-- 2010-08-27   Ani: Added @datapath param to spNewTask to pass the
--              base path for task db data files.
-- 2010-11-23   Ani: Added cases for GALSPEC, RESOLVE and PM in spNewTask.
-- 2012-05-09   Ani: Added spStartStep back in, dont know why or when it 
--              was deleted.
-- 2013-04-02   Ani: Added spSetFinishPhase to update FinishPhase.
-- 2013-05-02   Ani: Added cases for GALPROD (galaxy product tables)
--              and WISE xmatch tables.
-- 2016-03-22   Ani: Added MASK and (WISE) FORCED to spNewTask
-- 2016-03-26   Ani: Added MaNGA to spNewTask.
--=============================================================


--==============================
-- Event management
--==============================
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
AS 
BEGIN
	--
	SET NOCOUNT ON
	DECLARE @myHost varchar(1000),
		@loadSupportHost varchar(100);
	--
	--SELECT @myHost = srvName FROM master.dbo.sysservers WHERE srvid = 0;
	SELECT @myHost = @@servername;
	SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver);
	--------------------------------------------------
	IF @phasemsg IS NULL
	    SET @phasemsg = '*********** NULL phaseMsg ***********';
	-------------------------------------------------
	-- call it recursively if it is on a remote server. This avoids distributed transactions
	IF (@myHost != @loadSupportHost)
	    BEGIN
		declare @proc varchar(1000)
		set @proc = @loadSupportHost + '.loadSupport.dbo.spNewPhase '
		execute @proc @taskid, @stepid, @phaseName, @status, @phaseMsg WITH RECOMPILE
		return
	    END
	-------------------------------------------------
	BEGIN TRANSACTION
	    INSERT INTO Phase(taskid,stepid,phasename,status,comment) 
		VALUES(@taskid,@stepid,@phasename,@status,@phasemsg);
	COMMIT TRANSACTION
	-------------------------------------------------
END
GO

--========================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNewStep' AND type = 'P')
    DROP PROCEDURE spNewStep
GO
--
CREATE PROCEDURE spNewStep ( 
---------------------------------------------------
--/H Insert a new Step into the Loadadmin database
---------------------------------------------------
--/T This creates the basic Step in the processing of a Task.
--/T Contains the taskid, the stepname, its status, and
--/T timestamp for the beginning and the end of the Step.
--/T It will also bubble up the state to the Task.
--/T On error it may return stepid=null.
---------------------------------------------------
	@taskid int, 
	@stepname varchar(16), 
	@status varchar(16), 
	@stepmsg varchar(2048),
	@stepid int OUTPUT
)
AS 
BEGIN
    DECLARE @taskstatus varchar(16);
    SET @taskstatus = 'FRAMEWORK_ERROR';

    DECLARE @myHost varchar(1000), @loadSupportHost varchar(100)
    SELECT @myHost = srvName FROM master.dbo.sysservers WHERE srvid = 0
    SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver)

    -- call it recursively if it is on a remote server. This avoids distributed tranasactions
    IF (@myHost != @loadSupportHost)
	BEGIN
	declare @proc varchar(1000)
	set @proc = @loadSupportHost + '.loadSupport.dbo.spNewStep '
	execute @proc @taskid, @stepname, @status, @stepmsg, @stepid OUTPUT WITH RECOMPILE
	RETURN
	END

    BEGIN TRANSACTION
	INSERT INTO Step(taskid,stepname,status,comment) 
	    VALUES(@taskid,@stepname,@status,@stepmsg);
	SELECT @stepid=max(stepid) FROM Step WITH (nolock)
	    WHERE taskid=@taskid;
    COMMIT TRANSACTION

    IF @stepid IS NULL
	BEGIN
	    EXEC dbo.spNewPhase 0,0,'FRAMEWORK_ERROR','FRAMEWORK_ERROR',
		'spNewStep: No stepid found'
	    SET @taskstatus = 'ABORTING';
	END
    ELSE
	BEGIN
	    -- update the status of the Task accordingly
	    SET @taskstatus = 'WORKING'
	    IF @stepname='EXPORT' SET @taskstatus='EXPORTED';
	END

    UPDATE Task	
	SET step=@stepname, 
	taskstatus=@taskstatus,
	tlast = CURRENT_TIMESTAMP 
	WHERE taskid=@taskid;
END
GO


--=======================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNewTask' AND type = 'P')
    DROP PROCEDURE spNewTask
GO
--
CREATE PROCEDURE spNewTask ( 
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
	@loadSupportHost varchar(64),
	@publishtaskid int,
	@publishhost varchar(64), 
	@publishdb varchar(64),
	@backupfilename varchar(256),
	@pubtype varchar(32);
    
    -- build the new dbname
    -- clean out the '-' characters from the id name
    SET @dbname = @dataset+'_'+upper(substring(@type,1,4))
	+REPLACE(cast(@id as varchar(32)),'-','_');
    --
    --
    --SELECT @myHost = srvName FROM master.dbo.sysservers WHERE srvid = 0
    SELECT @myHost = @@servername;
    --
    SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver)
    -- call it recursively if it is on a remote server. This avoids distributed tranasactions
    IF (@myHost != @loadSupportHost)
	BEGIN
	    declare @proc varchar(1000)
	    set @proc = @loadSupportHost + '.loadSupport.dbo.spNewTask'
	    execute @proc @id, @dataset, @type, @path, @user, @datapath, @comment, @taskid OUTPUT WITH RECOMPILE
	RETURN
	END

    IF UPPER(@type) IN ('BEST', 'PLATES', 'TILES', 'MASK', 'WINDOW', 'WISE', 'SSPP', 'GALPROD', 'GALSPEC', 'RESOLVE', 'PM', 'APOGEE', 'FORCED', 'MaNGA')
	SET @pubtype='BEST-PUB'
    ELSE
	SET @pubtype=UPPER(@type)+'-PUB'
  
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

    SELECT @backupfilename=value FROM Constants WITH (nolock)
	WHERE name='backuppath';
    SET @backupfilename = @backupfilename+@dbname+'_backup.dat'

    BEGIN TRANSACTION
	INSERT INTO Task(dbname,step,taskstatus,dataset,type,[id],path,[user],
		tstart,tlast,publishtaskid,publishdb,publishhost,backupfilename,datafilename,comment) 
	    VALUES(@dbname,'','',@dataset,@type,@id,@path,@user,
		CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,
		@publishtaskid,@publishdb,@publishhost,@backupfilename,@datapath,@comment);
	SELECT @taskid=max(taskid) FROM Task WITH (nolock)
	    WHERE dbname=@dbname;
    COMMIT TRANSACTION

    -- create a new step, to indicate EXPORT
    EXEC spNewStep @taskid,'EXPORT','DONE','Exported task', @stepid OUTPUT;

END
GO

--=======================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spStartStep' AND type = 'P')
    DROP PROCEDURE spStartStep
GO
--
CREATE PROCEDURE spStartStep (
	@taskid int, 
	@stepid int OUTPUT,
	@stepname varchar(16), 
	@status varchar(16), 
	@stepmsg varchar(2048), 
	@phasemsg varchar(2048)
)
AS
BEGIN
    IF @taskid IS NULL
	BEGIN
	DECLARE @msg varchar(1000)
	set @msg = @phasemsg + '; taskID ' + 'spStartStep called on taskID: ' + str(@taskid) + ' but that task does not exist' 
	EXEC spNewPhase 0, 0, @stepname, @status, @msg
	RETURN(1);
	END

    DECLARE @myHost varchar(1000), @loadSupportHost varchar(100)
    SELECT @myHost = srvName FROM master.dbo.sysservers WHERE srvid = 0
    SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver)
    -- call it recursively if it is on a remote server. This avoids distributed tranasactions
    IF (@myHost != @loadSupportHost)
	BEGIN
	declare @proc varchar(1000)
	set @proc = @loadSupportHost + '.loadSupport.dbo.spStartStep'
	execute @proc @taskid,  @stepID OUTPUT, @stepname, @status, @stepmsg, @phasemsg
	RETURN
	END

    -- log the beginning of work (for example start of validation)
    EXEC spNewStep @taskid, @stepname, @status, @stepmsg, @stepID OUTPUT;

    IF @stepid IS NULL
	RETURN(1);

    -- record a message that we just started the step

    EXEC spNewPhase @taskID, @stepID, 'STARTING', 'START', @phasemsg

END
GO


--====================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spEndStep' AND type = 'P')
    DROP PROCEDURE spEndStep
GO
--
CREATE PROCEDURE spEndStep (
	@taskid int, 
	@stepid int,
	@status varchar(16), 
	@stepmsg varchar(2048), 
	@phasemsg varchar(2048)
)
AS
BEGIN
    DECLARE @stepname varchar(16), @phasestatus varchar(16), @taskstatus varchar(16);

    -- this will catch parameter errors in program logic
    SET @taskstatus = 'FRAMEWORK_ERROR';

    -- fetch the stepname
    SELECT @stepname=stepname FROM Step WITH (nolock)
	WHERE stepid=@stepid and taskid=@taskid;

    IF @stepname IS NULL
	BEGIN
	DECLARE @msg varchar(1000)
	set @msg = @phasemsg + '; spEndStep: taskID, stepID (' + str(@taskid) +',' +STR(@stepid)+ ') does not exist'
	EXEC spNewPhase 0, 0, 'FRAMEWORK ERROR', 'ERROR', @msg
	RETURN(1);
	END

    DECLARE @myHost varchar(1000), @loadSupportHost varchar(100)
    SELECT @myHost = srvName FROM master.dbo.sysservers WHERE srvid = 0
    SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver)
    -- call it recursively if it is on a remote server. This avoids distributed tranasactions
    IF (@myHost != @loadSupportHost)
	BEGIN
	declare @proc varchar(1000)
	set @proc = @loadSupportHost + '.loadSupport.dbo.spEndStep'
	execute @proc @taskid,  @stepID, @status, @stepmsg, @phasemsg
	RETURN
	END

    BEGIN TRANSACTION

	-- init phasestatus
	IF @status<>'DONE' SET @phasestatus='ERROR' ELSE SET @phasestatus='DONE';

	-- record a message about how things are going.
	EXEC spNewPhase @taskID, @stepID, 'FINISHING', @phasestatus, @phasemsg

	-- log the beginning of work (for example start of validation)
	UPDATE Step
	    SET status=@status, tstop=CURRENT_TIMESTAMP, comment=@stepmsg
	    WHERE stepid=@stepid

	-- update the Task
	IF @status = 'ABORTING' SET @taskstatus=@status
	IF @status = 'DONE' SET @taskstatus='WORKING'

	UPDATE Task
	    SET taskstatus=@taskstatus, 
	    step = @stepname, 
	    tlast=CURRENT_TIMESTAMP
	    WHERE taskid=@taskid

    COMMIT TRANSACTION

END
GO


--=====================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spKillTask' AND type = 'P')
    DROP PROCEDURE spKillTask
GO
--
CREATE PROCEDURE spKillTask(@taskid int) as 
------------------------------------------------------
--/H ### THIS NEEDS LOTS MORE WORK, it needs to drive the graph backwards
------------------------------------------------------
--/T ### IT ALSO NEEDS TO THINK ABOUT THE NAST CASE WHERE A STEP OF THE TASK IS EXECUTING.
------------------------------------------------------
BEGIN
    UPDATE Task
	SET taskstatus='KILLED'
	WHERE taskid=@taskid;
END
GO

--=========================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spUndoStep' AND type = 'P')
    DROP PROCEDURE spUndoStep
GO
--
CREATE PROCEDURE spUndoStep(@taskid int, @msg varchar(256)) AS
---------------------------------------------------
--/H Undo the last processing step of a given task, or kill the task
--/T This actually sets the state up for UNDO so that the "next step"
--/T will be the actual undo step (the undo stored procedure).
---------------------------------------------------
--/T Only the taskname needs to be specified. The
--/T procedure calls UNDO of the current step of the task.
--/T to one lower than the last processing step.
--/T It will insert an UNDO event into the Event table.
---------------------------------------------------
BEGIN

    BEGIN TRANSACTION
    DECLARE @err int, 
	@dbname varchar(32), 
	@step varchar(16),
	@newStep varchar(16), 
	@stepID int, 
	@status varchar(16) 
    SET @err =0;
    COMMIT TRANSACTION
    RETURN(0);
END
GO

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- procedures driving the state machine
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'spNextStep' AND type = 'P')
	DROP PROCEDURE spNextStep
GO
--
CREATE PROCEDURE spNextStep(@taskid int)
-----------------------------------------------------
--/H Executes next step based upon the NextStep table
-----------------------------------------------------
--/T Input parameter is the @taskid
-----------------------------------------------------
AS BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE
	@currentstep varchar(32), 
	@stepstatus varchar(32), 
	@taskstatus varchar(32), 
	@doSP varchar(64),
	@nextstep varchar(32),
	@cmd nvarchar(1024), 
	@stepid int, 
	@ret int;

    IF @taskid IS NULL
	RETURN(1);

    -- get the parameters of the step we are at now
    SELECT 
	@currentstep=t.step, 
	@stepstatus=s.status,
	@taskstatus=t.taskstatus
	FROM Task t, Step s WITH (nolock)
	WHERE t.taskid=s.taskid and t.step=s.stepname
		and s.stepid = dbo.fStepid(t.taskid,t.step) 
		and t.taskid=@taskid;

    IF @stepstatus != 'DONE'
	RETURN(1);

    -- end of processing?
    IF @taskstatus = 'DONE'
	RETURN (10);

    -- get next step
    SELECT @doSP=doSP, @nextstep=nextstep FROM NextStep WITH (nolock)
	WHERE step=@currentstep;


    -- do the next step
    SET @cmd = N'EXEC dbo.'+@doSP+' '+cast(@taskid as varchar(16));
    EXEC @ret=sp_executesql @cmd;
    RETURN(@ret);

END
GO


if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fCheckPath]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fCheckPath]
GO
--
CREATE FUNCTION fCheckPath( @path VARCHAR(128), @hostname VARCHAR(128) )
-----------------------------------------------------
--/H Checks the CSV path and extracts host name if it is a share
-----------------------------------------------------
--/T To make sure that CSVs are loaded locally as far as possible,
--/T this function checks the CSV path to see if it is a network
--/T share, and if so, extracts the host name from the first part.
--/T The calling function then resets the host name to this one.
--/T Input parameter is the CSV path (@path) and current host name.
-----------------------------------------------------
RETURNS VARCHAR(128)
AS 
BEGIN
	DECLARE @servername VARCHAR(128), @location VARCHAR(128)

	IF SUBSTRING(@path,1,2) = '\\'
		BEGIN
			SET @servername = SUBSTRING(@path, 3, CHARINDEX('\',@path,3)-3)
			IF @servername != @hostname
				SET @location = @servername
			ELSE
				SET @location = @hostname
		END
	ELSE
		SET @location = @hostname

	RETURN (@location)
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spGetNextTask' AND type = 'P')
    DROP PROCEDURE spGetNextTask
GO
--
CREATE PROCEDURE spGetNextTask(@hostname varchar(32)) 
-----------------------------------------------
--/H Grab the next task for loading 
--
--/T Run a transaction, which sets the task status to 
--/T QUEUED, and the name of the hostname to @hostname
-----------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @myHost varchar(1000),
		@loadSupportHost varchar(100);
	--
	--SELECT @myHost = srvName FROM master.dbo.sysservers WHERE srvid = 0;
	SELECT @myHost = @@servername;
	SET @loadSupportHost = (select top 1 [name] from loadsupport..loadserver);
	--------------------------------------------------
	-- call it recursively if it is on a remote server. This avoids distributed transactions
	IF (@myHost != @loadSupportHost)
	    BEGIN
		declare @proc varchar(1000)
		set @proc = @loadSupportHost + '.loadSupport.dbo.spGetNextTask ';
		execute @proc @hostname WITH RECOMPILE
		return
	    END
	-------------------------------------------------

   BEGIN TRANSACTION
	DECLARE @taskid int;
retry:
	-------------------------------------------
	-- look for a Task past the CHECK step
	SET @taskid = null;
	SELECT @taskid=min(t.taskid)
	    FROM Task t, Step s WITH (nolock)
	    WHERE t.taskid=s.taskid
		and t.step='CHECK' 
		and t.taskstatus='WORKING'
		and s.stepname='CHECK'
		and s.status='DONE'
	--------------------------------------------
	-- if still nothing, exit gracefully
	IF @taskid IS NULL
	    goto commonExit;

	--------------------------------------------
	-- we found something, set status to QUEUED
	UPDATE Task
	    SET taskstatus='QUEUED',	
--		hostname = @hostname
		hostname = 		dbo.fCheckPath(path, @hostname )		-- ensure that data path is local
	    WHERE taskid=@taskid
      	      and taskstatus='WORKING'	-- Make sure it is still waiting for work.
	--
	IF (@@rowcount = 0)		-- if Update was a no-op, some other node
	    BEGIN			-- got there first, so retry.
		COMMIT TRANSACTION
		GOTO retry;
	    END
    ---------------------------------------
    commonExit:
    COMMIT TRANSACTION
    RETURN(0)
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNextPubTask' AND type = 'P')
    DROP PROCEDURE spNextPubTask
GO
--
CREATE PROCEDURE spNextPubTask 
-----------------------------------------------
--/H Grab the next task for loading in the PUB role
--/A
--/T Run a transaction, which sets the task status to QUEUED, and
--/T the name of the hostname to the current server
-----------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    --
    DECLARE
	@taskid int,
	@role varchar(16),
	@nextrole varchar(16),
	@ret int,
	@global varchar(8),
	@local  varchar(8);
    --
    SET @local = null;
    --
    -- Get global run state
    SELECT @global = max(runState)
	FROM ServerState WITH (nolock)
	WHERE srvname='GLOBAL';
    -- get Local run state
    SELECT @local  = max(runState)
	FROM ServerState WITH (nolock)
	WHERE role='PUB' and srvname=@@servername;
    --
    IF @local IS null RETURN(0);
  
    -- do not start new task if we are being told to HALT or END
    IF (@local IN ('HALT', 'END')) OR (@global IN ('HALT','END'))
	RETURN(0);

    SET @taskid = null;
    -------------------------------------------------------
    -- we have the PUB role
    SET @role='PUB';

    -- look for a Task to be loaded, 
    -- that needs us as a publisher of the right type, 
    -- and is at the PUB steps
    SELECT @taskid=t.taskid 
	FROM Task t, Step s, NextStep n
	WITH (nolock)
	WHERE s.stepid = dbo.fStepid(t.taskid, t.step)
	    AND t.step = n.step
	    AND t.step != 'READY'
	    AND t.taskstatus='WORKING'
	    AND t.type NOT LIKE '%-PUB'
	    AND s.status='DONE'
	    AND n.runat='PUB'
	    AND t.publishhost=HOST_NAME();
    --
    -------------------------------------------
    IF @taskid IS NULL
	BEGIN
	    -- but make sure that there is nothing else there!!
	    SELECT @taskid=min(t.taskid)
		FROM Task t, Step s WITH (nolock)
		WHERE t.taskid=s.taskid
			and t.type!='FINISH'
			and t.type NOT LIKE '%-PUB'
			and t.taskstatus='WORKING'
	    IF @taskid IS NOT NULL
		RETURN(0);

	    -- nothing there, look for FINISH Task in READY state
	    SELECT @taskid=min(t.taskid)
		FROM Task t, Step s WITH (nolock)
		WHERE t.taskid=s.taskid
			and t.step='READY'
			and t.type='FINISH'
			and t.taskstatus='WORKING'
			and s.stepname='READY'
			and s.status='DONE'
	END
    -- if still nothing, exit
    IF @taskid IS NULL
	RETURN(0);
    -------------------------------------------------------
    -- start loop, until reached the end
    SET @ret = 0;
    WHILE (@ret = 0)
	BEGIN

	    -- stop work if this node is in the halt state
	    -- Get global run state
	    SELECT @global = max(runState)
		FROM ServerState WITH (nolock)
		WHERE srvname='GLOBAL';
	    -- get Local run state
	    SELECT @local  = max(runState)
		FROM ServerState WITH (nolock)
		WHERE role='PUB' and srvname=@@servername;
	    --
	    -- this node is being told to stop working
	    IF (@local = 'HALT' or @global = 'HALT')
		RETURN(0);

	    -- do the next step
	    EXEC @ret=spNextStep @taskid

	    -- is the next step still in the same role as @role?
	    -- if not, exit gracefully
	    IF NOT EXISTS (
		SELECT n.runat FROM NextStep n, Task t 
		    WITH (nolock)
		    WHERE t.step = n.step 
			and t.taskid=@taskid
			and n.runat = @role 
		)
		RETURN(0);
	END
    RETURN(0);
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNextLoadTask' AND type = 'P')
    DROP PROCEDURE spNextLoadTask
GO
--
CREATE PROCEDURE spNextLoadTask 
-----------------------------------------------
--/H Grab the next task for loading 
--
--/T Run a transaction, which sets the task status to QUEUED, and
--/T the name of the hostname to the current server
-----------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    --
    DECLARE
	@taskid int,
	@role varchar(16),
	@nextrole varchar(16),
	@ret int,
	@global varchar(8),
	@local varchar(8);

    SET @local = null;

    -- Get global run state
    SELECT @global = max(runState)
	FROM ServerState WITH (nolock)
	WHERE srvname='GLOBAL';
    -- get Local run state
    SELECT @local  = max(runState)
	FROM ServerState WITH (nolock)
	WHERE role='LOAD' and srvname=@@servername; 

    IF @local IS null RETURN(0);
       
    -- do not start new task if we are being told to HALT or END
    IF (@local IN ('HALT', 'END')) OR (@global IN ('HALT','END'))
	RETURN(0);

    SET @taskid = null;
    -------------------------------------------------------

    -- we have the LOAD role
    SET @role='LOAD';

    SELECT @taskid=t.taskid 
	FROM Task t, Step s, NextStep n
	WITH (nolock)
	WHERE s.stepid = dbo.fStepid(t.taskid, t.step)
		AND t.step = n.step
		AND t.step != 'CREATE'
		AND t.taskstatus='WORKING'
		AND t.type NOT LIKE '%-PUB'
		AND s.status='DONE'
		AND n.runat='LOAD'
		AND t.hostname=HOST_NAME();
    --
    IF @taskid IS NOT NULL
	GOTO loop

    -------------------------------------------------------
    -- if none found so far, and we have LOAD role,
    -- get a new Task from loadadmin, if in LOAD role
    EXEC spGetNextTask @@servername;
    --  Move an export task from working to queued
    SELECT @taskid = min(taskid) 
	FROM Task WITH (nolock)
	WHERE hostname=@@servername
	    and taskstatus='QUEUED';
    --
    IF @taskid IS NULL
	RETURN(0);

    -------------------------------------------------------
loop:

    -- start loop, until reached the end
    -- or need a new server role
    SET @ret = 0;
    WHILE (@ret = 0)
	BEGIN

	    -- stop work if this node is in the halt state
	    -- Get global run state
	    SELECT @global = max(runState)
		FROM ServerState WITH (nolock)
		WHERE srvname='GLOBAL';
	    -- get Local run state
	    SELECT @local  = max(runState)
		FROM ServerState WITH (nolock)
		WHERE role='LOAD' and srvname=@@servername;

	    -- this node is being told to stop work
	    IF (@local = 'HALT' or @global = 'HALT')
		RETURN(0);

	    -- do the next step
	    EXEC @ret=spNextStep @taskid

	    -- is the next step still in the same role as @role?
	    -- if not, exit gracefully
	    IF NOT EXISTS (
		SELECT n.runat FROM NextStep n, Task t 
		    WITH (nolock)
		    WHERE t.step = n.step 
			and t.taskid=@taskid
			and n.runat = @role 
		)
		RETURN(0);
	END
    RETURN(0);
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spSetFinishPhase' AND type = 'P')
    DROP PROCEDURE spSetFinishPhase
GO
--
CREATE PROCEDURE spSetFinishPhase( @phase VARCHAR(32) )
-----------------------------------------------
--/H Grab the next task for loading 
--
--/T Run a transaction, which sets the task status to QUEUED, and
--/T the name of the hostname to the current server
-----------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    --
    UPDATE FinishPhase SET name = @phase
END
GO


PRINT cast(getdate() as varchar(64)) + '  -- Loadsupport-sp stored procedures created'

