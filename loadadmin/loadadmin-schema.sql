--================================================
-- loadadmin-schema.sql
-- 2002-06-03 Alex Szalay
--------------------------------------------------
-- the basic schema for the loadadmin database
--------------------------------------------------
-- 2002-08-14	Alex: split it into loadadmin and loadsupport
-- 2002-09-03	Alex: removed csvlog and sqllog, substituted with LoadLog
-- 2002-09-19	Jim: state varchar(16)
--                 added status(16)
--                 added some comments
--		   moved to task, step, phase model
--		   moved to nextStep state table model (rather than procedure)
-- 2002-09-27	Alex+Jim: synchronize
-- 2002-10-10	Alex: added steps for destination task states for NextStep
-- 2002-11-06	Alex: added table GlobalRunState, for flow control
-- 2002-11-16	Alex: added new column runat to NextStep to capture server role
-- 2002-11-18	Alex: added new column dataset to Task 
-- 2002-12-03	Alex: added acronym to NextStep for website
-- 2009-10-29	Ani: added datapath, logpath for pub and task dbs to
--                   Constants table.
--================================================
--
SET NOCOUNT ON
GO

--================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Task]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [Task]
GO
--
CREATE TABLE Task (
--------------------------------------------------
--/H Tracks the state of each task
--------------------------------------------------
--/T This is the parent record of each task.
--/T Tasks have steps and steps have phases.
--/T Requires a pmt string containing path,
--/T the type, user on creation.
--/T Auto-generates taskid and dbname. The dbname and taskid are
--/T needed later to change the state of the task.
--/T State is (EXPORTED|WAITING|WORKING|ABORTING|DONE|ABORTED|KILLED|)
--/T hostname and dbsize are updated later in the processing.
--/T The destination database is PUBLISHHOST.PUBLISHDB.dbo.xxxtablenamexxx
--/T
--------------------------------------------------
	taskid 		int PRIMARY KEY IDENTITY(0,1),	--/D unique id, created automatically
	hostname	varchar(32) default(null), 	--/D name of the database host
	dbname		varchar(32) not null,		--/D name of the database
	datasize	int not null default(0),	--/D default size of the database
	logsize		int not null default(0),	--/D default size of the log file
	step		varchar(16) not null,		--/D current step of processing
	taskstatus	varchar(16) not null, 		--/D task status
	dataset		varchar(16) not null,		--/D name of the dataset (DR1, DR2,...)
 	type 		varchar(16) not null,		--/D type: (target|best|runs|plates|tiling)
	[id]		varchar(32) not null,		--/D unique id of the run/chunk/...
	path 		varchar(256) not null, 		--/D UNC path to the root of source data
	[user]		varchar(32) not null,		--/D name of user/process making entry
	tstart		datetime default(CURRENT_TIMESTAMP),	--/D when defined
	tlast		datetime default(CURRENT_TIMESTAMP),	--/D timestamp of last change
	prevtaskid	int default(null),			--/D link to a previous version of task
	publishtaskid	int not null default(0),		--/D taaskid of the destination database
	publishdb	varchar(64) not null default(''),	--/D name of db to publish into
	publishhost	varchar(32) not null default(''),	--/D name of host to publish to
	datafilename	varchar(64) not null default(''),	--/D name of the data file
	logfilename	varchar(64) not null default(''),	--/D name of the log file
	backupfilename	varchar(256) not null default(''),	--/D UNC path to backup
	comment		varchar(2048) not null default('')	--/D comment
)
GO


--================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Step]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [Step]
GO
--
CREATE TABLE Step (
--------------------------------------------------
--/H Records any change in the state of a task
--------------------------------------------------
--/T Requires valid taskid
--/T 
--------------------------------------------------
	taskid		int not null,			--/D task that started this step.
	stepid		int IDENTITY(0,1),		--/D step ID within this task
	stepname	varchar(16) not null, 		--/D short name of the step (e.g. LOAD, VALIDATE,...)
	status		varchar(16) not null, 		--/D task status: (WORKING|ABORTING|DONE)
	tstart		datetime  default(CURRENT_TIMESTAMP),	--/D start timestamp of Step
	tstop		datetime  default(CURRENT_TIMESTAMP),	--/D stop timestamp of Step
	comment		varchar(2048) not null default(''),	--/D short diagnostic comment
	PRIMARY KEY (taskid, stepid)
)
GO


--================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Phase]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [Phase]
GO
--
CREATE TABLE Phase (
---------------------------------------------------
--/H List of phases of a step
---------------------------------------------------
--/T 
---------------------------------------------------
	taskid		int not null,			--/D task that started this step.
	stepid		int not null,			--/D step ID within this task
	phaseid		int IDENTITY(1,1),		--/D Unique id for the phase
	phasename	varchar(16) NOT NULL,		--/D phase type (eg. Check HTM).
	status		varchar(16) NOT NULL,		--/D status (OK|DONE|WARNING|ERROR)
	tstop		datetime  default(CURRENT_TIMESTAMP),	--/D stop timestamp of Phase
 	comment		varchar(2048) not null default(''), 	--/D message
	PRIMARY KEY (taskid, stepid, phaseid)
)
GO


--================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Files]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [Files]
GO
--
CREATE TABLE Files (
---------------------------------------------------
--/H List of all files to be loaded 
---------------------------------------------------
--/T 
---------------------------------------------------
	fileid		int PRIMARY KEY IDENTITY(1,1),	--/D Unique ID to file
	taskid		int NOT NULL, 		--/D link to the task
	stepid		int not null,		--/D link to the current step
	status		varchar(15) NOT NULL, 	--/D (READY, QUEUED, WORKING, DONE, WARNING, ERROR)
	tinsert		datetime NOT NULL default(CURRENT_TIMESTAMP),	--/D insert timestamp
	tstart		datetime,		--/D begin timestamp
	tstop		datetime,		--/D end timestamp
	fname		varchar(256) NOT NULL,	--/D filename, including the path
	nlines		int NOT NULL,		--/D number of lines in the file
	targettable	varchar(32) NOT NULL,	--/D name of table to load into
	loadmethod	varchar(32) NOT NULL,	--/D how is the file to be loaded
	thread		int default(0) NOT NULL --/D the id of the thread doing the loading
)
GO

-- insert null task and null step

INSERT INTO Task  ( dbname,step,taskstatus,dataset,type,[id],path,[user],comment) 
	Values('NULL_TASK','NULL_TASK','ABORTED','NULL','NULL','loadadmin_error',
	'','loadagent','Null task for framework errors')

INSERT INTO Step ( taskid,stepname, status,comment) 
	Values(0,'NULL_STEP','ABORTED','Null step for framework errors')


GO


-----------------------------------------------------
-- Enum tables
-----------------------------------------------------

if exists (select * from dbo.sysobjects 
	where id = object_id(N'[NextStep]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [NextStep]
GO


CREATE TABLE NextStep (
---------------------------------------------------
--/H State Transition Diagram for Loader
---------------------------------------------------
--/T There is one row for each node of the state transition graph.
--/T One edge goes forward, the other is an UNDO edge.
---------------------------------------------------
	id		int identity(1,1),
	step		varchar(16) not null,		--/D current step.
	nextStep	varchar(16) not null,		--/D Type of next step.
	doSP		varchar(32) not null,		--/D stored procedure that get to next step
	runat		varchar(32) not null,		--/D server type to run at (LOAD|PUB)
	acronym		varchar(8) not null,		--/D short acronym for web page
	undoStep	varchar(16) not null,		--/D Step to roll back to
	undoSP		varchar(32) not null,		--/D stored procedure that undoes this step
	killSP		varchar(32) not null,		--/D stored procedure to get to kill step
 	comment		varchar(1000) not null default(''), --/D comment on this state transition
	PRIMARY KEY (step, nextStep)
)
GO

INSERT INTO NextStep Values('KILLED','','','','',
	'NULL','NULL',
	'NULL','KILLED is a final state with no return');
INSERT INTO NextStep Values('EXPORT','CHECK','spCheck','LOAD','EXP',
	'NULL','NULL',
	'spKillTask','The CSV data for the task is available in the path')
INSERT INTO NextStep Values('CHECK','BUILD','spBuild','LOAD','CHK',
	'NULL','NULL',
	'spKillTask','The CSV data has been checked and is ready for preload')
INSERT INTO NextStep Values('BUILD','PRELOAD','spPreload','LOAD','BLD',
	'NULL','NULL',
	'spKillTask','The Task DB has been created')
INSERT INTO NextStep Values('PRELOAD','VALIDATE','spValidate','LOAD','SQL',
	'NULL','NULL',
	'spKillTask','Loaded the CSV data to SQL')
INSERT INTO NextStep Values('VALIDATE','BACKUP','spBackup','LOAD','VAL',
	'NULL','NULL',
	'spKillTask','The preloaded SQL data has been validated')
INSERT INTO NextStep Values('BACKUP','DETACH','spDetach','LOAD','BCK',
	'NULL','NULL',
	'spKillTask','The preloaded SQL data has been backed up')
INSERT INTO NextStep Values('DETACH','PUBLISH','spPublish','PUB','DTC',
	'NULL','NULL','spKillTask','The Task DB has been detached')
INSERT INTO NextStep Values('PUBLISH','CLEANUP','spCleanup','PUB','PUB',
	'NULL','NULL',
	'spKillTask','The data has been published to the main DB')
INSERT INTO NextStep Values('CLEANUP','DONE','spDone','PUB','CLN',
	'NULL','NULL',
	'spKillTask','The TaskDB has been deleted')

INSERT INTO NextStep Values('READY','FINISH','spFinish','PUB','FIN',
	'NULL','NULL',
	'spKillTask','The TaskDB has been deleted')
INSERT INTO NextStep Values('FINISH','DONE','spDone','PUB','FIN',
	'NULL','NULL',
	'spKillTask','The TaskDB has been deleted')
INSERT INTO NextStep Values('DONE','','','PUB','DONE',
	'NULL','NULL',
	'spKillTask','Task completed successfully')

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- still need the spReorg, also the step to start from the backups
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*

INSERT INTO NextStep Values('CREATE','BUILD','spBuild','PUB','CRE','NULL',
	'NULL','spKillTask','The task for destination db has been created')
INSERT INTO NextStep Values('BUILD','DONE','NULL',PUB','BLD','BLD','NULL',
	'NULL','spKillTask','The task is ready for publishing')
INSERT INTO NextStep Values('FINISH','DONE','spDone','PUB','FIN','BUILD',
	'NULL','spKillTask','The destination SQL database has been completed')

*/
--

--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[ServerState]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [ServerState]
GO
CREATE TABLE ServerState (
	[srvid]		int NOT NULL,		--/D unique id for server role
	[srvname]	varchar(32) NOT NULL,	--/D the name of the server
	[role]		varchar(16) NOT NULL,	--/D the role(s) of this server (LOAD|PUB)
	[runState]	varchar(16) NOT NULL	--/D the run state, one of (RUN|HALT|END)
)	
GO

INSERT INTO ServerState VALUES(0,'GLOBAL','','RUN');
GO

--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Constants]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [Constants]
GO
--
CREATE TABLE Constants (
	id		int PRIMARY KEY IDENTITY(1,1),
	[name]		varchar(16),
	value		varchar(64)
)
GO

-------------------------------------
-- set up the default parameters
-------------------------------------
DECLARE @loadserver varchar(64), @root varchar(128);
SET @loadserver = @@servername;
SET @root = '\\'+@@servername +'\root\';
--
INSERT INTO Constants VALUES('loadserver', @loadserver);
INSERT INTO Constants VALUES('datapath','d:\sql_db\');
INSERT INTO Constants VALUES('logpath', 'd:\sql_db\'); 
INSERT INTO Constants VALUES('pubdatapath','d:\sql_db\');
INSERT INTO Constants VALUES('publogpath', 'd:\sql_db\'); 
INSERT INTO Constants VALUES('taskdatapath','d:\sql_db\'); 
INSERT INTO Constants VALUES('metadir', @root+'schema\csv\');
INSERT INTO Constants VALUES('sqldir',  @root+'schema\sql\');
INSERT INTO Constants VALUES('vbsdir',  @root+'vbs\');
INSERT INTO Constants VALUES('dtsdir',  @root+'dts\');
INSERT INTO Constants VALUES('datasize','5000');
INSERT INTO Constants VALUES('logsize', '500');
--
INSERT INTO Constants VALUES('dataset','TEST');
INSERT INTO Constants VALUES('dataset','SEGUE2');
INSERT INTO Constants VALUES('dataset','DR8');
--
GO

print cast(getdate() as varchar(64)) + '  -- Loadadmin tables created'

