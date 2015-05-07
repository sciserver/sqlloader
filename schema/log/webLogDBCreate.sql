--==================================================
-- webLogDBCreate.sql
-- 2003-10-03 Jim Gray, Alex Szalay
----------------------------------------------------
-- Modificatdions:
-- 2003-10-04 Alex: Added extra columns to weblog
-- 2003-10-04 Alex: Added extra columns to Sql***Log
-- 2003-10-26 Jim:  went from null to default
-- 			change "null" to "not null default 0"
--					Weblog.error
-- 					weblog.isVisible
--			change "null" to "not null default ''"	for 
--					Weblog.second
--					Weblog.framework
--					Weblog.product
--					Weblog.op
--					Weblog.command
--					Weblog.browser
--			Weblog.clientIP  not null default value 0.0.0.0
--			let the command length be 7KB to catch odd things. 
--	     		permuted weblog columns (book-keeping last)
--				added hh, mi, ss to weblog and dropped sec.
--			Added WeblogAll base table (to replace weblog)
--			Made WebLog a view.  
-- 2003-10-26 Alex: Added LogSource and privacy table
-- 2003-10-26 Jim:  Added weblogTemp table
-- 2003-10-29 Jim:  changed weblog.op from char(6) to char(8)
--		    changed weblog.command from char(256) to char(7000)
--    		    changed weblog.browser from char(256) to char(2000)
-- 	   	    added weblog.hh, mi, ss and dropped second
--		    added LogSource.weblog -- the name of the log file == name of web server
--		    added TrafficBase.SkyServer
--		    added TrafficBase.SkyService
--		    changed WebLog to WebLogAll and added WebLog view
--                  added SqlLogAll and converted all sql logging to UTC 
--		    added spCopySqlLog and spCopyWebLog
--		    fixed spUpdateTrafficBase to be simpler and to track SQL counters.
--		    appended populating logSource table. 
-- 		    extensive rewrite of code to be driven by LogSource table.
-- 2004-04-01 Ani:  Updated schema of WebLogAll, WebLogTemp and SqlLogAll tables to bump up
--                  seq to bigint (from int) and clientIP to varchar(256) (from char(16)).
--
-- 2004-05-19 Ani:  Added creation of Weblog DB.
-- 2004-11-17 Ani:  Replaced bcpWeblog.js call with bcpWeblog.exe (C# 
--                  version) in spCopyWeblogs.
-- 2004-12-02 Ani:  Made small change to DailyTraffic view so the month
--                  is zero-padded on the left and hence the descending
--                  order in the daily traffic display works correctly.
-- 2005-02-22 Ani:  Added totalIO to SqlLogAll table.
-- 2005-04-13 Ani:  Added new weblog columns to InsertFNALWeblog and
--                  cast the referer to varchar(500) pending a change
--                  to WebLogAll to expand it to bigger size.
-- 2005-09-07 Ani:  Copied original version of this file to 
--                  webLogHarvesterCreate.sql, and took the harvester
--                  schema out of here so this script can be run to
--                  create a new weblog DB on a production SDSS server.
-- 2005-09-07 Ani:  Fixed bug (syntax error) in create db call.
-- 2005-11-09 Ani:  Removed data file creation on C: drive since this was
--                  causing problems at FNAL.  Entire DB is on D: now.
-- 2006-01-18 Ani:  Added seq identity column to sql logs to guarantee
--                  PK uniqueness and avoid PK violations for queries
--                  submitted in quick succession (PR # 6809).
--* 2006-06-19 Ani: Moved spLogSqlStatement and spLogSqlPerformance here
--*                 from ../sql/spWebSupport.sql.
--* 2011-01-11 Ani: Updates for SDSS-III servers, changed test to skyuser.
--==================================================
-- Create WebLog DB
CREATE DATABASE [weblog]  ON 
  (NAME = N'weblog_Data', FILENAME = N'C:\data\data1\sql_db\weblog_Data.MDF' , SIZE = 2000, FILEGROWTH = 10%)
  LOG ON (NAME = N'weblog_Log', FILENAME = N'C:\data\data1\sql_db\weblog_Log.LDF' , SIZE = 1000, FILEGROWTH = 10%)
  COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'weblog', N'autoclose', N'false'
GO

exec sp_dboption N'weblog', N'bulkcopy', N'false'
GO

exec sp_dboption N'weblog', N'trunc. log', N'true'
GO

exec sp_dboption N'weblog', N'torn page detection', N'true'
GO

exec sp_dboption N'weblog', N'read only', N'false'
GO

exec sp_dboption N'weblog', N'dbo use', N'false'
GO

exec sp_dboption N'weblog', N'single', N'false'
GO

exec sp_dboption N'weblog', N'autoshrink', N'false'
GO

exec sp_dboption N'weblog', N'ANSI null default', N'false'
GO

exec sp_dboption N'weblog', N'recursive triggers', N'false'
GO

exec sp_dboption N'weblog', N'ANSI nulls', N'false'
GO

exec sp_dboption N'weblog', N'concat null yields null', N'false'
GO

exec sp_dboption N'weblog', N'cursor close on commit', N'false'
GO

exec sp_dboption N'weblog', N'default to local cursor', N'false'
GO

exec sp_dboption N'weblog', N'quoted identifier', N'false'
GO

exec sp_dboption N'weblog', N'ANSI warnings', N'false'
GO

exec sp_dboption N'weblog', N'auto create statistics', N'true'
GO

exec sp_dboption N'weblog', N'auto update statistics', N'true'
GO
GO

------------------------
-- Create Web Log Tables
------------------------
USE WebLog

--==========================================================
if exists (select * from dbo.sysobjects where name =(N'LogSource')) 
	drop table LogSource
GO
--
CREATE TABLE LogSource (
------------------------------------------------------------
--/H The basic information about sites to be harvested
--
--/T The entries here can correspond to websites and database servers
--/T The weblogs of active servers are copied to the WebLog database every hour
--/T and summary statistics are computed. 
--/T The tstamp field gives the time of the most recent update. 
------------------------------------------------------------
	logID		int	      NOT NULL DEFAULT(0),	--/D unique ID of log used as foreign key
	location	varchar(32)   NOT NULL DEFAULT (''),	--/D the location of the site (FNAL, JHU,..
	service 	varchar(32)   NOT NULL DEFAULT (''),	--/D type of service (SKYSERVER, SKYSERVICE, SKYQUERY,...)
	instance	varchar(32)   NOT NULL default (''),	--/D The log underneath the service (V1, V2,.. ) 
	uri		varchar(32)   NOT NULL default (''),	--/D The url or other ID for this service. 
	framework 	varchar(32)   NOT NULL DEFAULT (''),	--/D the calling framework (ASP,ASPX,HTML,QA,SOAP,...)
	product 	varchar(32)   NOT NULL DEFAULT (''),	--/D the type of product acessed (EDR, DR1, DR2,...
	method		varchar(16)   NOT NULL default(''),	--/D Harvesting method (XCOPY|WGET|SQL)
	pathname	varchar(1024) NOT NULL default(''),	--/D The path of the log LogSource (UNC|URL)
	tstamp		datetime      NOT NULL default Current_timestamp,	--/D The time of the last harvesting
	isvisible 	tinyint       NOT NULL default(1),	--/D should this log be visible in the event log (0:no, 1:yes)
	status		varchar(32)   NOT NULL default(''),	--/D The current state (ACTIVE|DISABLED)
	PRIMARY KEY(logID)
)
GO
ALTER TABLE LogSource ADD CONSTRAINT [ak_LogSource] UNIQUE 
	(location, service, instance)
GO

--==========================================================
if exists (select * from dbo.sysobjects where name = N'weblogAll') 
	drop table weblogAll
GO
--
CREATE TABLE weblogAll (
------------------------------------------------------------
--/H The weblog information -- contains both visible and invisible log records.
--
--/T The information is parsed from the W3C format weblog 
--/T files, generated on each web server by IIS. A record is
--/T considered to be invisible until its flag is set to 1.
------------------------------------------------------------
	yy 		smallint 	NOT NULL,	--/D the year of the event
	mm 		tinyint  	NOT NULL,	--/D the month of the event
	dd 		tinyint  	NOT NULL,	--/D the day of the event
	hh	        tinyint  	NOT NULL, 	--/D the hour of the event
	mi 	      	tinyint  	NOT NULL, 	--/D the minute of the event
	ss		tinyint 	NOT NULL,	--/D the second of the event
	seq 		bigint     	IDENTITY(1,1),	--/D sequence number to uniquify the event
	logID		int	      	NOT NULL DEFAULT(0) foreign key references LogSource(logID),		--/D unique ID of log foreign key LogSource.logID
	clientIP 	char(256)      	NOT NULL DEFAULT ('0.0.0.0') , 	--/D the IP address of the client
	op 		char(8)       	NOT NULL DEFAULT (''),		--/D the operation (GET,POST,...) 
	command 	varchar(7000) 	NOT NULL DEFAULT (''),		--/D the command executed
	error 		int 	      	NOT NULL DEFAULT (0) ,		--/D the error code if any
	browser 	varchar(2000) 	NOT NULL DEFAULT (''), 		--/D the browser type
	isvisible 	tinyint       	NOT NULL DEFAULT (0), 		--/D should this event be visible (0:no, 1:yes)
	PRIMARY KEY (yy desc ,mm desc,dd desc,hh desc,mi desc,ss  desc,seq desc,logID)
) 

GO
ALTER TABLE  weblogAll NOCHECK CONSTRAINT ALL
--
 

--==========================================================
-- Web Log Views
--==========================================================
if exists (select * from dbo.sysobjects where name = N'weblog' )
	 drop view weblog 
GO
 
CREATE VIEW weblog  (
------------------------------------------------------------
--/H The weblog information -- contains visible log records.
--
--/T The information is parsed from the W3C format weblog 
--/T files, generated on each web server by IIS. 
------------------------------------------------------------
	yy 		,		--/D the year of the event
	mm 		,		--/D the month of the event
	dd 		,		--/D the day of the event
	hh	        , 		--/D the hour of the event
	mi 	      	, 		--/D the minute of the event
	ss		,		--/D the second of the event
	logID		,		--/D the log that this came from, foreign key: LogSource.logID	
	seq 		,		--/D sequence number
	clientIP 	,		--/D the IP address of the client
	op 		,		--/D the operation (GET,POST,...) 
	command 	,		--/D the command executed
	error 		,		--/D the error code if any
	browser 	, 		--/D the browser type
	location	,		--/D the location of the site (FNAL, JHU,..
	service 	,		--/D type of service (SKYSERVER, SKYSERVICE, SKYQUERY,...)
	instance	,		--/D The log underneath the service (V1, V2,.. ) 
	uri		,		--/D The url or other ID for this service. 
	framework 	,		--/D the calling framework (ASP,ASPX,HTML,QA,SOAP,...)
	product 	 		--/D the type of product acessed (EDR, DR1, DR2,...
) AS
SELECT  yy,mm,dd,hh,mi,ss, w.logID, seq, clientIP, op, command, error, browser,
	location, service, instance, uri, framework, product   
	from WebLogAll w with(nolock) left outer join logSource ls on w.logID = ls.logID
	where w.isVisible = 1  

GO


--===============================================================================
-- SQL log tables and views.
---------------------------------------------------------------------------------

--==========================================================
if exists (select * from dbo.sysobjects where name = N'SqlStatementLogUTC') 
	drop table SqlStatementLogUTC
GO
--
CREATE TABLE SqlStatementLogUTC (
-----------------------------------------------
--/H The SQL statements submitted directly by end users (rather than website generated ones)
--/U
--/T Records are inserted at the start of the query. 
--/T At the end of the query, a corresponding SqlPerfomrnceLog record is generated. 
-----------------------------------------------
	theTime 	datetime 	NOT NULL DEFAULT (getUTCdate()),--/D the timestamp
        webserver       varchar(64) 	NOT NULL DEFAULT(''),   	-- the url
	winname		varchar(64) 	NOT NULL DEFAULT(''),   	-- the windows name of the server
        clientIP       	varchar(16) 	NOT NULL DEFAULT(''),    	-- client IP address 
	seq		int		identity(1,1) NOT NULL,		-- sequence number to guarantee uniqueness of PK
	server		varchar(32)	NOT NULL DEFAULT(''),		--/D the name of the database server
	dbname		varchar(32)	NOT NULL DEFAULT(''),		--/D the name of the database 
	access		varchar(32)	NOT NULL DEFAULT(''),		--/D The website DR1, collab,...
	sql 		varchar(7800) 	NOT NULL DEFAULT(''), 		--/D the SQL statement
	isVisible	int		NOT NULL DEFAULT(1),		--/D flag says statement visible on intenet
									--/D collab activity is logged but not public
	PRIMARY KEY CLUSTERED (theTime,webserver,winname,clientIP,seq)
)  
GO

--==========================================================
if exists (select * from dbo.sysobjects where name = N'SqlPerformanceLogUTC') 
	drop table SqlPerformanceLogUTC
GO
--
CREATE TABLE SqlPerformanceLogUTC (
-----------------------------------------------
--/H The cost of the SQL statements submitted directly by end users  
--/U
--/T When a query compleltes the time, row count,and other attributes of the query are added to the log.  
--/T The corresponding SqlQueryLog tells what the statement is and where it came from.  
-----------------------------------------------
	theTime 	datetime 	NOT NULL DEFAULT (getUTCdate()),	--/D the timestamp
        webserver       varchar(64) 	NOT NULL DEFAULT(''),   	-- the url
	winname		varchar(64) 	NOT NULL DEFAULT(''),   	-- the windows name of the server
        clientIP       	varchar(16) 	NOT NULL DEFAULT(''),    	-- client IP address
	seq		int		identity(1,1) NOT NULL,		-- sequence number to guarantee uniqueness of PK
	elapsed 	real 		NOT NULL DEFAULT (0.0),		--/D the lapse time of the query
	busy 		real 		NOT NULL DEFAULT (0.0),		--/D the total CPU time of the query
	[rows] 		bigint 		NOT NULL DEFAULT (0),		--/D the number of rows generated
	procid		int 		NOT NULL DEFAULT(0),		--/D the processid of the query
	error		int		NOT NULL DEFAULT(0),		--/D 0 if ok, otherwise the sql error #, negative numbers are generated by the procedure
	errorMessage	varchar(2000)	NOT NULL DEFAULT(''),		--/D the error message.
	PRIMARY KEY CLUSTERED (theTime,webserver,winname,clientIP,seq)
) 
GO



--==========================================================
if exists (select * from dbo.sysobjects where name = N'SqlLogUTC') 
	drop view SqlLogUTC
GO
--
CREATE VIEW SqlLogUTC
----------------------------------------------------------
--/H The view joining the two SQL logs
--/U
--/T
----------------------------------------------------------
AS     SELECT s.theTime, s.webserver, s.winname, s.clientIP, s.server, s.dbname, 
	       elapsed, busy, rows,  
	       sql, access, isVisible, procID, error, errorMessage
	FROM SqlStatementLogUTC s  with(nolock), SqlPerformanceLogUTC p  with(nolock)
	WHERE s.theTime = p.theTime 
	  and s.webserver=p.webserver 
	  and s.winName = p.winName
	  and s.clientIP = p.clientIP

GO


--==============================================================================
if exists (select * from dbo.sysobjects where name = N'SQLlogAll') 
	drop view SQLlogAll 
GO
CREATE VIEW SQLlogAll AS
	SELECT * 
	FROM SqlLogUtc
GO
--==============================================================================

--==============================================================================
if exists (select * from dbo.sysobjects where name = N'SQLlog') 
	drop view SQLlog 
GO
CREATE VIEW SQLlog AS
	SELECT * 
	FROM SqlLogUtc
	WHERE isVisible = 1
GO
--==============================================================================

--==============================================================================
if exists (select * from dbo.sysobjects where name = N'SQLStatementLog') 
	drop view SQLStatementLog 
GO
CREATE VIEW SQLStatementLog AS
	SELECT * 
	FROM SqlStatementLogUtc
	WHERE isVisible = 1
GO
--==============================================================================

--==============================================================================
if exists (select * from dbo.sysobjects where name = N'SQLPerformanceLog') 
	drop view SQLPerformanceLog 
GO
CREATE VIEW SQLPerformanceLog AS
	SELECT * 
	FROM SqlPerformanceLogUtc
GO
--==============================================================================


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spLogSqlStatement' )
	DROP PROCEDURE spLogSqlStatement
GO
--
CREATE PROCEDURE spLogSqlStatement (
	@cmd VARCHAR(8000) OUTPUT, 
        @webserver      VARCHAR(64) = '',   -- the url
	@winname	VARCHAR(64) = '',   -- the windows name of the server
        @clientIP       VARCHAR(16)  = 0,   -- client IP address 
	@access		VARCHAR(64) = '',   -- subsite of site,  if 'collab' statement 'hidden' 
	@startTime	datetime            -- time the query was started
) 
------------------------------------------------------------------------------- 
--/H Procedure to log a SQL query to the statement log. 
------------------------------------------------------------------------------- 
--/T Log the given query and its start time to the SQL statement log.  Note
--/T that we are logging only the start of the query yet, not a completed query.
--/T All the SQL statements are journaled into WebLog.dbo.SQLStatementlog. 
--/T <samp>EXEC dbo.spLogSqlStatement('Select count(*) from PhotoObj',getutcdate())</samp> 
--/T See also spLogSqlPerformance.
------------------------------------------------------------------------------- 
AS 
    BEGIN 
        SET NOCOUNT ON 
	DECLARE @error      INT;			-- error number
	DECLARE @serverName varchar(32);		-- name of this databaes server
	DECLARE @dbName     VARCHAR(32);		-- name of this database
	SET 	@serverName = @@servername;
	SELECT @dbname = [name] FROM master.dbo.sysdatabases WHERE dbid = db_id() 
	DECLARE @isVisible  INT;			-- flag says sql is visible to internet queries
	SET @isVisible = 1;
	IF (UPPER(@access) LIKE '%COLLAB%') SET @isVisible = 0;  -- collab is invisible
        -------------------------------------------------------------------------- 
        --- log the command if there is a weblog DB 
        if (0 != (select count(*) from master.dbo.sysdatabases where name = 'weblog')) 
            begin 
                insert WebLog.dbo.SqlStatementLogUTC 
                values(@startTime,@webserver,@winName, @clientIP, 
		       @serverName, @dbName, @access, @cmd, @isVisible) 
            end 
    END
GO



--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spLogSqlPerformance' )
	DROP PROCEDURE spLogSqlPerformance
GO
--
CREATE PROCEDURE spLogSqlPerformance (
        @webserver      VARCHAR(64) = '',   -- the url
	@winname	VARCHAR(64) = '',   -- the windows name of the server
        @clientIP       VARCHAR(16)  = 0,   -- client IP address 
	@access		VARCHAR(64) = '',   -- subsite of site,  if 'collab' statement 'hidden' 
	@startTime	datetime,           -- time the query was started
	@busyTime	bigint      = 0,    -- time the CPU was busy during query execution
	@endTime	datetime    = 0,    -- time the query finished
	@rows           bigint      = 0,    -- number of rows returned by the query
	@errorMsg	VARCHAR(1024) = ''  -- error message if applicable
) 
------------------------------------------------------------------------------- 
--/H Procedure to log success (or failure) of a SQL query to the performance log.
------------------------------------------------------------------------------- 
--/T The caller needs to specify the time the query was started, the number of <br>
--/T seconds (bigint) that the CPU was busy during the query execution, the    <br>
--/T time the query ended, the number of rows the query returned, and an error <br>
--/T message if applicable.  The time fields can be 0 if there is an error.
--/T <samp>EXEC dbo.spLogSQLPerformance('skyserver.sdss.org','',,'',getutcdate())</samp> 
--/T See also spLogSqlStatement.
------------------------------------------------------------------------------- 
AS 
    BEGIN 
        SET NOCOUNT ON 
        ------------------------------------------------------ 
        -- record the performance when (if) the command completes. 
        IF ( (@startTime IS NOT NULL) AND (@startTime != 0) AND 
             (@busyTime != 0) AND (@endTime != 0) AND (LEN(@errorMsg) = 0) ) 
            BEGIN 
                INSERT WebLog.dbo.SqlPerformanceLogUTC 
	        VALUES (@startTime,@webserver,@winName, @clientIP,
                        DATEDIFF(ms, @startTime, @endTime)/1000.0,      -- elapsed time 
                        ((@@CPU_BUSY+@@IO_BUSY)-@busyTime)/1000.0,      -- busy time 
                        @rows, @@PROCID, 0,'')                                          -- rows returned                
            END
	ELSE
            BEGIN 
                IF ( (@startTime IS NULL) OR (@startTime = 0) )
                    SET @startTime = GETUTCDATE();
                INSERT WebLog.dbo.SqlPerformanceLogUTC 
	        VALUES (@startTime,@webserver,@winName, @clientIP,
			0,0,0, @@PROCID, -1, @errorMsg)  
            END
     END
GO




--===============
-- user stuff
--===============

if not exists (select * from dbo.sysusers 
	where name = N'skyuser' and uid < 16382)
	EXEC sp_grantdbaccess N'skyuser', N'skyuser'
exec sp_addrolemember N'db_datareader', N'skyuser'
GO
if not exists (select * from dbo.sysusers 
	where name = N'internet' and uid < 16382)
	EXEC sp_grantdbaccess N'internet', N'internet'
exec sp_addrolemember N'db_datareader', N'internet'
--
EXEC sp_adduser N'skyuser', N'SKYUSER'
GO
EXEC sp_change_users_login N'UPDATE_ONE', N'skyuser', N'skyuser'
GO
--

GRANT  SELECT, INSERT 	ON SqlPerformanceLogUTC 	TO weblog
GRANT  SELECT, INSERT 	ON SqlStatementLogUTC	 	TO weblog
GRANT  SELECT  		ON weblog 			TO weblog
GRANT  SELECT  		ON SqlLog			TO weblog
GRANT  SELECT  		ON SqlLogAll			TO weblog
GRANT  SELECT  		ON SqlLogUTC			TO weblog
GO
GRANT  SELECT, INSERT 	ON SqlPerformanceLogUTC	 	TO skyuser
GRANT  SELECT, INSERT 	ON SqlStatementLogUTC	 	TO skyuser
GRANT  SELECT	 	ON SqlPerformanceLog	 	TO skyuser
GRANT  SELECT	 	ON SqlStatementLog	 	TO skyuser
GRANT  SELECT  		ON weblog 			TO skyuser
GRANT  SELECT  		ON SqlLog 			TO skyuser
GO
GRANT  SELECT, INSERT 	ON SqlPerformanceLogUTC	 	TO internet
GRANT  SELECT, INSERT 	ON SqlStatementLogUTC	 	TO internet
GRANT  SELECT	 	ON SqlPerformanceLog	 	TO internet
GRANT  SELECT	 	ON SqlStatementLog	 	TO internet
GRANT  SELECT  		ON weblog 			TO internet
GRANT  SELECT  		ON SqlLog 			TO internet
GRANT  SELECT  		ON SqlLogUTC			TO internet
GO


