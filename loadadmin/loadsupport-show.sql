--=============================================================
-- loadadmin-show.sql
-- 2002-09-30 Alex Szalay
---------------------------------------------------------------
-- All the views and stored procedures needed to display 
-- the load status on the web interface
---------------------------------------------------------------
-- 2002-12-19	Alex: added spShowErrors
-- 2004-03-04   Ani: Added average time output to spShowStepStats and 
--                   spShowFileStats.
-- 2004-11-07	Ani: Made task lists descending on taskid in spShowTask
--                   and included -PUB tasks in active tasks.  Also
--                   made phase listing in spShowPhase descending.
-- 2005-03-28   Ani: Modified spShowTask to show all *-PUB tasks (tasks
--                   1,2,3) in Active tasks regardless of status,
--                   include finished *-PUB tasks in Finished list. 
-- 2012-06-07   Ani: spShowTask now does not list TARG db tasks.
-- 2016-03-31   Ani: Increased length of table name to 64 from 16 in
--                   spShowFileStats.
--=============================================================
SET NOCOUNT ON
GO

--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spShowErrors' AND type = 'P')
    DROP PROCEDURE spShowErrors
GO
--
CREATE PROCEDURE spShowErrors (@flag int=0)
---------------------------------------------------
--/H Display phase messages that contain ERROR or WARNING
---------------------------------------------------
--/T @flag=0 : ERROR
--/T @flag=1 : WARNING
---------------------------------------------------
AS BEGIN
    DECLARE @errtype varchar(16);
    SET @errtype = 'ERROR';
    IF @flag=1 SET @errtype='WARNING';

    SELECT p.taskid, p.stepid, p.phaseid,
	s.stepname, p.phasename, p.status,
	p.tstop, p.comment
	FROM Phase p, Step s, Task t
	WHERE p.stepid=s.stepid and s.taskid=t.taskid
--	    and p.status IN ('ERROR','WARNING')
	    and p.status=@errtype
	    and t.taskstatus !='KILLED'
END
GO

--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spShowPhase' AND type = 'P')
    DROP PROCEDURE spShowPhase
GO
--
CREATE PROCEDURE spShowPhase (@taskid int)
---------------------------------------------------
--/H Display the status of the files for the task
---------------------------------------------------
--/T
---------------------------------------------------
AS
BEGIN
    SELECT p.taskid, p.stepid, p.phaseid,
	s.stepname, p.phasename, p.status,
	p.tstop, p.comment
	FROM Phase p, Step s
	WHERE p.taskid=@taskid and p.stepid=s.stepid
	ORDER BY p.phaseid DESC
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spShowFiles' AND type = 'P')
    DROP PROCEDURE spShowFiles
GO
--
CREATE PROCEDURE spShowFiles (@taskid int)
---------------------------------------------------
--/H Display the status of the files for the task
---------------------------------------------------
--/T
---------------------------------------------------
AS
BEGIN
    SELECT f.fileid, f.taskid, f.stepid, f.status, 
	coalesce(DATEDIFF(s,f.tstart,f.tstop),0) as 'elapsed', 
	f.nlines, f.targettable, f.loadmethod, f.thread, f.tstart, f.fname
	FROM Files f, 
    	(select max(stepid) as stepid from files where taskid=@taskid) s
    where f.stepid=s.stepid
END
GO


--=============================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fStepid]') 
	and xtype in (N'FN', N'IF', N'TF'))
    DROP FUNCTION [dbo].[fStepid]
GO
--
CREATE FUNCTION fStepid(@taskid int, @stepname varchar(16) )
RETURNS int
AS 
BEGIN
    DECLARE @stepid int;
    select @stepid=max(stepid) from Step 
	where taskid=@taskid and stepname=@stepname
    RETURN coalesce(@stepid,0);
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spShowTask' AND type = 'P')
    DROP PROCEDURE spShowTask
GO
--
CREATE PROCEDURE spShowTask (@flag varchar(32))
---------------------------------------------------
--/H Display the state of the active/all tasks
---------------------------------------------------
--/T The parameter @flag determines whether just the
--/T active, or all tasks are displayed. The default
--/T is to show the active tasks only. The tasks
--/T are ordered by their order of progress.
---------------------------------------------------
AS
BEGIN
    IF (@flag = 'Active')
	SELECT t.taskid, t.dbname, t.step, s.status,
		t.taskstatus, t.type, t.tlast, t.hostname
	   FROM Task t, Step s WITH (nolock)
	   WHERE t.taskid=s.taskid and t.step=s.stepname
		and s.stepid = dbo.fStepid(t.taskid,t.step) 
		and (taskstatus not in ('KILLED','DONE') or type like '%-PUB')
		and t.dbname not like 'targ%'
--		and taskstatus in ('WORKING','ABORTING')
--		and type not like '%-PUB'
	   ORDER BY t.taskid DESC

    ELSE IF (@flag = 'Finished')
	SELECT t.taskid, t.dbname, t.step, s.status,
		t.taskstatus, t.type, t.tlast, t.hostname
	   FROM Task t, Step s WITH (nolock)
	   WHERE t.taskid=s.taskid and t.step=s.stepname
		and s.stepid = dbo.fStepid(t.taskid,t.step) 
		and taskstatus = 'DONE'
		and t.dbname not like 'targ%'
--		and type not like '%-PUB'
	   ORDER BY t.taskid DESC

    ELSE IF (@flag ='Destination') 
	SELECT t.taskid, t.dbname, t.step, s.status,
		t.taskstatus, t.type, t.tlast, t.hostname
	   FROM Task t, Step s WITH (nolock)
	   WHERE t.taskid=s.taskid 
		and t.step=s.stepname
		and s.stepid = dbo.fStepid(t.taskid,t.step) 
		and taskstatus not in ('KILLED','ABORTED')
		and t.dbname not like 'targ%'
		and type like '%-PUB%'
	   ORDER BY t.taskid DESC

    ELSE IF (@flag ='Killed') 
	SELECT t.taskid, t.dbname, t.step, s.status,
		t.taskstatus, t.type, t.tlast, t.hostname
	   FROM Task t, Step s WITH (nolock)
	   WHERE t.taskid=s.taskid 
		and t.step=s.stepname
		and s.stepid = dbo.fStepid(t.taskid,t.step) 
		and t.dbname not like 'targ%'
		and taskstatus='KILLED'
	   ORDER BY t.taskid DESC

    ELSE IF (@flag ='All') 
	SELECT t.taskid, t.dbname, t.step, s.status,
		t.taskstatus, t.type, t.tlast, t.hostname
	   FROM Task t, Step s WITH (nolock)
	   WHERE t.taskid=s.taskid 
		and t.step=s.stepname
		and t.dbname not like 'targ%'
		and s.stepid = dbo.fStepid(t.taskid,t.step) 
	   ORDER BY t.taskid DESC

    ELSE IF (@flag ='Null') 
	SELECT t.taskid, t.dbname, t.step, s.status,
		t.taskstatus, t.type, t.tlast, t.hostname
	   FROM Task t, Step s WITH (nolock)
	   WHERE t.taskid=s.taskid 
		and t.taskid=0
	   ORDER BY t.taskid DESC
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spShowSteps' AND type = 'P')
    DROP PROCEDURE spShowSteps
GO
--
CREATE PROCEDURE spShowSteps(@taskid int)
---------------------------------------------------
--/H Show the step history of a given Task
---------------------------------------------------
--/T Displays all the steps related to a given Task,
--/T in chronological order.
---------------------------------------------------
AS
BEGIN
    SELECT taskid, stepid, stepname, status,
	coalesce(DATEDIFF(s,tstart,tstop),0) as 'elapsed',
	tstart, tstop, comment
	FROM Step
	WHERE taskid=@taskid
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spShowStepStats' AND type = 'P')
    DROP PROCEDURE spShowStepStats
GO
--
CREATE PROCEDURE spShowStepStats
---------------------------------------------------
--/H Show the total and averafe elapsed time for finished tasks per step
---------------------------------------------------
--/T Displays all the steps in the workflow and the
--/T total lapse time in seconds
---------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE @total real, @average real;
    DECLARE @stat TABLE (step varchar(16), [total] int, [average] int)
    --
    INSERT @stat
    SELECT 
	min(n.step) as step, 
	sum(coalesce(DATEDIFF(s,s.tstart,s.tstop),0) ) as [total],
	avg(coalesce(DATEDIFF(s,s.tstart,s.tstop),0) ) as [average]
	FROM Task t, Step s, NextStep n WITH (nolock)
	WHERE t.taskid=s.taskid
		AND s.stepname=n.step
		AND t.taskstatus='DONE'
		GROUP BY n.id
		ORDER BY n.id
    --
    IF @@rowcount=0 
	BEGIN
	   SELECT * FROM @stat
	   RETURN(0);
	END
    --
    SELECT @total = sum([total]) FROM @stat;
    SELECT @average = avg([average]) FROM @stat;
    INSERT @stat VALUES('TOTAL', @total, @average);
    --
    SELECT step, [total], [average], str(100*[total]/@total,6,0) as [percent] FROM @stat;
    --
END
GO


--=============================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spShowFileStats' AND type = 'P')
    DROP PROCEDURE spShowFileStats
GO
--
CREATE PROCEDURE spShowFileStats
---------------------------------------------------
--/H Show the total lapse time for finished tasks per step
---------------------------------------------------
--/T Displays all the steps in the workflow and the
--/T total lapse time in seconds
---------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE @total real, @average real;
    DECLARE @stat TABLE ([table] varchar(64), [total] int, [average] int)
    --
    INSERT @stat
    SELECT
	f.targettable as [table],
	sum(coalesce(DATEDIFF(s,f.tstart,f.tstop),0) ) as [total],
	avg(coalesce(DATEDIFF(s,f.tstart,f.tstop),0) ) as [average]
	FROM Files f, Task t WITH (nolock)
	WHERE f.taskid=t.taskid AND t.taskstatus='DONE'
	GROUP BY f.targettable
	ORDER BY f.targettable
    --
    IF @@rowcount=0 
	BEGIN
	   SELECT * FROM @stat
	   RETURN(0);
	END
    --
    SELECT @total = sum([total]) FROM @stat;
    SELECT @average = avg([average]) FROM @stat;
    INSERT @stat VALUES('TOTAL', @total, @average);
    --
    SELECT [table], [total], [average], str(100*[total]/@total,6,0) as [percent] FROM @stat;
    --

END
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spShowServers]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spShowServers]
GO
--
CREATE PROCEDURE spShowServers
--------------------------------------------------
--/H Show the role and state of all servers
--------------------------------------------------
--/T Currently only works for the loadadmin server
--------------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    --
    SELECT srvname as [name], role, runState as state FROM ServerState
	ORDER BY srvid
END
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSetServer]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spSetServer]
GO
--
CREATE PROCEDURE spSetServer(
	@srvname varchar(64), 
	@role varchar(16), 
	@state varchar(16))
------------------------------------------
--/H Set run state of server in a given role
------------------------------------------
AS BEGIN
    --
    SET NOCOUNT ON;
    DECLARE @cmd nvarchar(256), @ret int;
    --
    IF @state NOT IN ('RUN','HALT','END')
	RETURN(1);
    --
    IF @srvname='GLOBAL'
	BEGIN
	    UPDATE ServerState
		SET runState=@state
	    RETURN(0);
	END
    --
    IF @role NOT IN ('LOAD','PUB')
	RETURN(1);
    --
    UPDATE ServerState
	SET runState=@state
	WHERE srvname=@srvname and role = @role;
    --
    RETURN(0);
END
GO

print cast(getdate() as varchar(64)) + '  -- Loadsupport-show stored procedures created'
GO

EXEC dbo.spGrantExec webagent
GO

print cast(getdate() as varchar(64)) + '  -- Stored procs authenticated for webagent'
GO


