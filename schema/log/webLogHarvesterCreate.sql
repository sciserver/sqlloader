--==================================================
-- weblogHarvesterCreate.sql
-- 2003-10-03 Jim Gray, Alex Szalay
-- 2005-09-07 Ani Thakar - renamed weblogDBCreate.sql 
--                         to weblogHarvesterCreate.sql
----------------------------------------------------
-- Modifications:
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
-- 2005-10-11 Ani:  Added call to InsertFNALWeblog in spCopyWebLogs.
--                  Also added more logsources to InsertFNALWeblogs. 
-- 2005-10-17 Ani:  Added Hungarian and Spanish branches.
-- 2006-01-23 Ani:  Added fields required by VO logging data model
--                  (referer, bytesOut, bytesIn, elapsed) to webLogAll
--                  and webLogTemp.
-- 2006-07-05 Ani:  Edited MonthlyTraffic view to use leading zero for
--                  the month so that order by desc is correct for 
--                  2-digit months (10,11,12).
-- 2006-08-18 Ani:  Modified spCopyWeblogs and InsertFNALWeblogs to
--                  truncate command string if it contains password
--                  in clear.
-- 2008-09-15 Ani:  Modified spCopySqlLogs to test linked server connection before harvesting
--                  a server, so it doesnt stop harvesting if there is a link error.  Also added
--                  new table ErrorLog to record errors encountered with linked servers etc.
-- 2018-11-14 Sue:  Added error handling try/catch to spCopySqlLogs.  Also set page_verify to checksum
--					instead of torn_page
-- 2018-11-14 Sue:  Added spCopyLocalCasJobsSqlLogs to this file
--==================================================
-- Create WebLog DB
CREATE DATABASE [weblog]  ON 
  (NAME = N'weblog_Data1', FILENAME = N'C:\sql_db\weblog_Data1.MDF' , SIZE = 1000, FILEGROWTH = 0%), 
  (NAME = N'weblog_Data2', FILENAME = N'D:\sql_db\weblog_Data2.MDF' , SIZE = 20000, FILEGROWTH = 10%) 
  LOG ON (NAME = N'weblog_Log', FILENAME = N'D:\sql_db\weblog_Log.LDF' , SIZE = 10000, FILEGROWTH = 10%)
  COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'weblog', N'autoclose', N'false'
GO

exec sp_dboption N'weblog', N'bulkcopy', N'false'
GO

exec sp_dboption N'weblog', N'trunc. log', N'true'
GO


alter database weblog set page_verify checksum
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
	logID		int	      NOT NULL DEFAULT (0),	--/D unique ID of log used as foreign key
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
if exists (select * from dbo.sysobjects where name = N'privacy') 
	drop table privacy
GO
--
CREATE TABLE privacy (
------------------------------------------------------------
--/H The privacy setting of certain virtual directories
--
--/T The entries here can correspond to virtual directory names
------------------------------------------------------------
	location	varchar(32) NOT NULL default(''),	--/D The location of the server
	website 	varchar(32) NOT NULL default(''),	--/D The name of the website, empty for database
	dirname		varchar(32) NOT NULL default(''),	--/D The name of the virtual directory
	privacy		varchar(32) NOT NULL default(''),	--/D The privacy flag for the LogSource (PUBLIC|COLLAB|...)
	PRIMARY KEY(location,website,dirname)
	)
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
	browser 	varchar(1024) 	NOT NULL DEFAULT (''), 		--/D the browser type
	referer		varchar(1024) 	NOT NULL DEFAULT (''), 		--/D who inboked the command
	bytesOut	bigint		NOT NULL DEFAULT (0),		--/D bytes returned by request
	bytesIn		int		NOT NULL DEFAULT (0),		--/D bytes in request
	elapsed 	int       	NOT NULL DEFAULT (0), 		--/D the time it took to execute request --/U sec
	isVisible 	tinyint       	NOT NULL DEFAULT (0), 		--/D should this event be visible (0:no, 1:yes)
	PRIMARY KEY (yy desc ,mm desc,dd desc,hh desc,mi desc,ss  desc,seq desc,logID)
) 

GO
ALTER TABLE  weblogAll NOCHECK CONSTRAINT ALL
--
 

-----------------------------------------------------
if exists (select * from dbo.sysobjects  where name =  N'weblogTemp') 
	drop table weblogTemp 
GO
-----------------------------------------------------
--/H Working table to hold newly arrived weblog data
--/T
------------------------------------------------------------
CREATE TABLE weblogTemp (
	YY		int		NOT NULL,    		--/D Year
	MM		int		NOT NULL,    		--/D Month 
	DD		int		NOT NULL,    		--/D The location of the server
	Seq		bigint		NOT NULL,    		--/D sequence number in day's weblog
	[Second]	char(8)		NOT NULL DEFAULT(''),	--/D timestamp to second in 00:00:00 fomat
	clientIP	varchar(256)	NOT NULL DEFAULT('0.0.0.0'),--/D sequence number in day's weblog
	op		char(8)		NOT NULL DEFAULT(''), 	--/D HTTP operation like GET | POST |...
	command		varchar(7000)	NOT NULL DEFAULT('') ,	--/D HTTP command
	error		int		NOT NULL DEFAULT(0), 	--/D HTTP error number associated with this request
	browser		varchar(1024)	NOT NULL DEFAULT(''),	--/D browser or program making the request
	referer		varchar(1024)	NOT NULL DEFAULT (''), 		--/D who inboked the command
	bytesOut	bigint		NOT NULL DEFAULT (0),		--/D bytes returned by request
	bytesIn		int		NOT NULL DEFAULT (0),		--/D bytes in request
	elapsed		int       	NOT NULL DEFAULT (0), 		--/D the time it took to execute request --/U sec
	isVisible	tinyint      	NOT NULL DEFAULT (0), 		--/D should this event be visible (0:no, 1:yes)
	CONSTRAINT pk_weblogtemp PRIMARY KEY  CLUSTERED( YY, MM, DD, Seq)  
)
GO

--==========================================================
if exists (select * from dbo.sysobjects where name = N'trafficBase') 
	drop table trafficBase
GO
--
CREATE TABLE trafficBase (
-----------------------------------------------
--/H Contains an aggregate of the traffic in an hourly breakdown
--/U
--/T Currently the traffic is broken down into four branches.
--/T Later different granularities will also be considered.
-----------------------------------------------
	yy 		int NOT NULL,			--/D the year of the events
	mm 		int NOT NULL,			--/D the month of the events
	dd 		int NOT NULL,			--/D the day of the events
	hh 		int NOT NULL,			--/D the hour of the events
	hits 		int NOT NULL DEFAULT(0),	--/D the total number of hits
	English 	int NOT NULL DEFAULT(0),	--/D the no of hits on the English branch
	German 		int NOT NULL DEFAULT(0),	--/D the no of hits on the German branch
	Hungarian 	int NOT NULL DEFAULT(0),	--/D the no of hits on the Hungarian branch
	Japanese 	int NOT NULL DEFAULT(0),	--/D the no of hits on the Japanese branch
	Spanish		int NOT NULL DEFAULT(0),	--/D the no of hits on the Spanish branch
	Project 	int NOT NULL DEFAULT(0),	--/D the no of hits on the Project branch
	SkyServer 	int NOT NULL DEFAULT(0),	--/D the no of hits on the SkyServer
	SkyService 	int NOT NULL DEFAULT(0), 	--/D the no of hits on the SkyService
	SQL		int NOT NULL DEFAULT(0) 	--/D the no of SQL comands processed
) 
GO
--
ALTER TABLE trafficBase WITH NOCHECK ADD CONSTRAINT [pk_trafficBase] PRIMARY KEY  CLUSTERED 
	(yy,mm,dd,hh)
GO

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

--==========================================================
if exists (select * from dbo.sysobjects where name = N'DailyTraffic') 
	drop view DailyTraffic
GO
--
CREATE VIEW DailyTraffic 
AS
----------------------------------------------------------
--/H A view for the daily aggregate of the traffic
--/U
--/T 
----------------------------------------------------------
    SELECT top 10000    (str(yy,4) + '/' 
		+ replace(str(mm,2),' ','0') +  '/' 
--		+ ltrim(str(mm,2)) +  '/' 
		+ ltrim(str(dd,2))) as date, 
		sum(hits) 	as hits,
		sum(English) 	as English,
		sum(German) 	as German,
		sum(Hungarian) 	as Hungarian,
		sum(Japanese) 	as Japanese,
		sum(Spanish) 	as Spanish,
		sum(Project) 	as Project,
	        sum(SkyServer) 	as SkyServer,
	        sum(SkyService) as SkyService,
	        sum(SQL) 	as SQL  
    FROM  trafficBase with(nolock)
    WHERE hh is not null  -- supress any rollup rows
    GROUP BY yy,mm,dd 
    ORDER BY yy desc,mm desc,dd desc
GO

-----------------------------------------------------------
if exists (select * from dbo.sysobjects where name = N'MonthlyTraffic') 
	drop view MonthlyTraffic
GO
--
CREATE VIEW MonthlyTraffic 
----------------------------------------------------------
--/H A monthly aggregation of the traffic
--/U
--/T
----------------------------------------------------------
AS
    SELECT TOP 30  (str(yy,4) + '/' + replace(str(mm,2),' ','0')) as month, 
		sum(hits) 	as hits,
		sum(English) 	as English,
		sum(German) 	as German,
		sum(Japanese) 	as Japanese,
		sum(Project) 	as Project,
	        sum(SkyServer) 	as SkyServer,
	        sum(SkyService) as SkyService,
	        sum(SQL) 	as SQL  
     FROM  trafficBase  with(nolock)
     WHERE hh is not null  -- suppress any rollup rows
     GROUP BY yy,mm 
     ORDER BY yy DESC, mm DESC 
GO

--------------------------------------------------------------------
if exists (select * from dbo.sysobjects where name = N'TotalTraffic') 
	drop view TotalTraffic
GO
--
CREATE VIEW TotalTraffic 
----------------------------------------------------------
--/H Yearly  view of the traffic 
--/U
--/T
----------------------------------------------------------
AS
	SELECT TOP 30  str(yy,4) as date, 
		sum(hits) 	as hits,
		sum(English) 	as English,
		sum(German) 	as German,
		sum(Japanese) 	as Japanese,
		sum(Project) 	as Project,
	        sum(SkyServer) 	as SkyServer,
	        sum(SkyService) as SkyService,
	        sum(SQL) 	as SQL  
	FROM  trafficBase  with(nolock)
	WHERE hh is not null  -- supress any rollup rows
	GROUP BY yy  
	ORDER BY yy DESC  
GO

--==============================================================================
if exists (select * from dbo.sysobjects where name = N'SQLlogAll') 
	drop table SQLlogAll
GO
CREATE TABLE SQLlogAll (
-----------------------------------------------
--/H Contains an entry for each SQL statement that has been executed and for each CAS job
--/U
--/T Currently the traffic is broken down into four branches.
--/T Later different granularities will also be considered.
-----------------------------------------------
-----------------------------------------------
	yy 		smallint 	NOT NULL,	--/D the year of the event
	mm 		tinyint  	NOT NULL,	--/D the month of the event
	dd 		tinyint  	NOT NULL,	--/D the day of the event
	hh	        tinyint  	NOT NULL, 	--/D the hour of the event
	mi 	      	tinyint  	NOT NULL, 	--/D the minute of the event
	ss		tinyint 	NOT NULL,	--/D the second of the event
	seq		bigint IDENTITY(1,1),		--/D a uniqueifier
	theTime		datetime	NOT NULL,	--/D the timestamp version yy-mm-dd hh-mm-ss.ssss
	logID		int	      	NOT NULL DEFAULT (0),		--/D unique ID of log foreign key LogSource.logID
	clientIP 	varchar(256)    NOT NULL DEFAULT ('0.0.0.0') , 	--/D the IP address of the client
	requestor 	varchar(32)     NOT NULL DEFAULT ('') , 	--/D typically the web server name
	server		varchar(32)	NOT NULL DEFAULT (''),		--/D the name of the database server
	dbname		varchar(32)	NOT NULL DEFAULT (''),		--/D the name of the database 
	access		varchar(32)	NOT NULL DEFAULT (''),		--/D the kind of access (collab, web, cas,...)
	elapsed 	real 		NOT NULL DEFAULT (0.0),		--/D the lapse time of the query
	busy 		real 		NOT NULL DEFAULT (0.0),		--/D the total CPU time of the query
	[rows] 		bigint 		NOT NULL DEFAULT (0),		--/D the number of rows generated
	totalIO 	bigint 		NOT NULL DEFAULT (0),		--/D the number of IOs (reads and writes) generated
	statement 	varchar(8000) 	NOT NULL DEFAULT (''),		--/D the command executed
	error 		int 	      	NOT NULL DEFAULT (0) ,		--/D the error code if any
	errorMessage 	varchar(1000) 	NOT NULL DEFAULT (''), 		--/D the error message if any
	isvisible 	tinyint       	NOT NULL DEFAULT (0), 		--/D should this event be visible (0:no, 1:yes)
	primary key (yy desc , mm desc, dd desc, hh desc , mi desc, ss desc, seq desc, theTime, logID, clientIP,requestor, server)
) 
GO
--==============================================================================
if exists (select * from dbo.sysobjects where name = N'SQLlog') 
	drop view SQLlog 
GO
CREATE VIEW SQLlog AS
	SELECT * 
	FROM SqlLogAll
	WHERE isVisible = 1
GO
--==============================================================================

--==========================================================
if exists (select * from dbo.sysobjects where name = N'SqlStatementLog') 
	drop table SqlStatementLog
GO
--
CREATE TABLE SqlStatementLog (
-----------------------------------------------
--/H The SQL statements submitted directly by end users (rather than website generated ones)
--/U
--/T Records are inserted at the start of the query. 
--/T At the end of the query, a corresponding SqlPerfomrnceLog record is generated. 
-----------------------------------------------
	theTime 	datetime 	NOT NULL DEFAULT (getdate()),	--/D the timestamp
	procid		smallint 	NOT NULL DEFAULT(0),		--/D the processid of the query
	server		varchar(32)	NOT NULL DEFAULT(''),		--/D the name of the database server
	dbname		varchar(32)	NOT NULL DEFAULT(''),		--/D the name of the database 
	sql 		varchar(7800) 	NOT NULL DEFAULT('')		--/D the SQL statement
) 
GO
--
ALTER TABLE SqlStatementLog WITH NOCHECK ADD 
	CONSTRAINT [pk_SqlStatementLog] PRIMARY KEY  CLUSTERED 
	(theTime,server,dbname)
GO

--==========================================================
if exists (select * from dbo.sysobjects where name = N'SqlPerformanceLog') 
	drop table SqlPerformanceLog
GO
--
CREATE TABLE SqlPerformanceLog (
-----------------------------------------------
--/H The cost of the SQL statements submitted directly by end users  
--/U
--/T When a query compleltes the time, row count,and other attributes of the query are added to the log.  
--/T The corresponding SqlQueryLog tells what the statement is and where it came from.  
-----------------------------------------------
	theTime datetime 	NOT NULL DEFAULT (getdate()),	--/D the timestamp
	elapsed real 		NOT NULL DEFAULT (0.0),		--/D the lapse time of the query
	busy 	real 		NOT NULL DEFAULT (0.0),		--/D the total CPU time of the query
	procid	smallint 	NOT NULL DEFAULT(0),		--/D the processid of the query
	server	varchar(32)	NOT NULL DEFAULT(''),		--/D the name of the database server
	dbname	varchar(32)	NOT NULL DEFAULT(''),		--/D the name of the database 
	[rows] 	bigint 		NOT NULL DEFAULT (0)		--/D the number of rows generated
) 
GO
--
ALTER TABLE SqlPerformanceLog WITH NOCHECK ADD 
	CONSTRAINT [pk_SqlPerformanceLog ] PRIMARY KEY CLUSTERED 
	(theTime,server,dbname)
GO

--
--===============================================================================
-- SQL log tables and views.
---------------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where name = N'SqlLog') 
	drop view SqlLogLocal
GO

CREATE VIEW SqlLogLocal 
----------------------------------------------------------
--/H The view joining the two SQL logs
--/U
--/T
----------------------------------------------------------
AS
	SELECT s.theTime, 
	    sql,
	    elapsed,
	    busy,
	    rows
	FROM SqlStatementLog s  with(nolock), SqlPerformanceLog p  with(nolock)
	WHERE s.theTime = p.theTime
GO
---------------------------------------------------------------------
-- new version of SQL Logs used by spExecute to record more info. 
--==============================================================================
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
	server		varchar(32)	NOT NULL DEFAULT(''),		--/D the name of the database server
	dbname		varchar(32)	NOT NULL DEFAULT(''),		--/D the name of the database 
	access		varchar(32)	NOT NULL DEFAULT(''),		--/D The website DR1, collab,...
	sql 		varchar(7800) 	NOT NULL DEFAULT(''), 		--/D the SQL statement
	isVisible	int		NOT NULL DEFAULT(1),		--/D flag says statement visible on intenet
									--/D collab activity is logged but not public
	PRIMARY KEY CLUSTERED (theTime,webserver,winname,clientIP)
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
	elapsed 	real 		NOT NULL DEFAULT (0.0),		--/D the lapse time of the query
	busy 		real 		NOT NULL DEFAULT (0.0),		--/D the total CPU time of the query
	[rows] 		bigint 		NOT NULL DEFAULT (0),		--/D the number of rows generated
	procid		int 		NOT NULL DEFAULT(0),		--/D the processid of the query
	error		int		NOT NULL DEFAULT(0),		--/D 0 if ok, otherwise the sql error #, negative numbers are generated by the procedure
	errorMessage	varchar(2000)	NOT NULL DEFAULT(''),		--/D the error message.
	PRIMARY KEY CLUSTERED (theTime,webserver,winname,clientIP)
) 
GO


--==========================================================
if exists (select * from dbo.sysobjects where name = N'ErrorLog') 
	drop table ErrorLog
GO
--
CREATE TABLE ErrorLog (
----------------------------------------------------------
--/H Errors encountered by the harvester are logged here.
--/U
--/T
----------------------------------------------------------
	currentTime datetime NOT NULL,
	context varchar(64) NOT NULL,
	errorMsg varchar(512) NOT NULL
)
GO
--


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


----------------------
-- Procedures
----------------------

----------------------------------------------------------------
-- 
-- imports recent weblogs, and updates statistics
-- first deletes weblog entries newer than the mindate.
-- also deletes corresponding elements in aggregate table (TrafficBase).
-- then imports weblogs since the min date (INCLUSIVE).
-- then recomputes aggregates.
 
----------------------------------------------------------------------
if exists (select * from dbo.sysobjects where name = N'spCopyWebLogs') 
	drop procedure  spCopyWebLogs 
GO
--
CREATE PROCEDURE spCopyWebLogs AS
----------------------------------------------------------
--/H Copies recent weblogs from web servers to the database
--/U
--/T Looks in the LogSource table for weblogs that are 
--/T  ACTIVE and XCOPY
--/T For each such weblog, it 
--/T   deletes entries from that log created since the minday of that log. 
--/T   copies each such log to the weblog
--/T   advances the minday timestamp of that weblog.
----------------------------------------------------------
BEGIN
	SET NOCOUNT ON
	TRUNCATE TABLE  WebLogTemp			-- clean out the scratch table
	DECLARE @date varchar(32),  @newDate datetime,	-- old date (when log was current)
							-- new date (bringing log up to date)
		@logID 	int, 				-- the id of this log source
		@MinYY int, @minMM int, @minDD int,	-- yy mm dd verson of date
	 	@command varchar(256),			-- command to do file copy 
	 	@location VARCHAR(32),			-- site that has log (e.g. JHU
		@service VARCHAR(32), 			-- service: SKYSERVER, SKYSERVICE, SQL,...
		@instance VARCHAR(32), 			-- Which one V1, V2, ... 
		@framework VARCHAR(32), 		-- .NET, ASP+, SQL,... 	
		@product VARCHAR(32), 			-- EDR, DR1, DR2,
		@pathname VARCHAR(1000), 		-- name to find log
		@tstamp DATETIME			-- how current is the database (last update time)
	---------------------------------------
	-- Get dates
	SET @newDate = GETUTCDATE()
	SELECT 	@tstamp = min(tstamp),
		@MinYY = datepart(yyyy,min(tstamp)),
		@MinMM = datepart(mm,  min(tstamp)),
		@MinDD = datepart(dd,  min(tstamp)),
		@date  = convert(varchar(10),min(tstamp),120) -- get yyyy-mm-dd
	FROM  LogSource
	WHERE  method = 'XCOPY' and isvisible = 1 and status = 'ACTIVE'	 
 	 DELETE weblogAll 
	 	  WHERE  (  (yy > @MinYY) or
	      		    (yy = @MinYY and mm > @MinMM) or   
	      		    (yy = @MinYY and mm = @MinMM and dd >= @MinDD)
			 ) and logID in (select logid FROM LogSource
					WHERE method = 'XCOPY' 
					  and isvisible = 1 
					  and status = 'ACTIVE'
					)
	----------------------------------------------
	-- for each Active-Xcopy LogSource, copy its log across.
	DECLARE WebLogs CURSOR   
	  FOR	SELECT logID, location, service, instance, framework, product, pathname 
		FROM LogSource
		WHERE method = 'XCOPY' and isvisible = 1 and status = 'ACTIVE'
	  FOR   UPDATE of tstamp
	OPEN WebLogs
	FETCH NEXT FROM WebLogs INTO @logID, @location, @service, @instance, @framework, @product, @pathname  
	WHILE (@@fetch_status = 0)
		BEGIN 
		----------------------------------------------
		-- clean out the weblogs since the min time we have seen. 
		-- PRINT 'LogSource ' + @location + ' ' + @service + ' '  + @instance + ' ' + @date
--		set @command = 'cscript c:\WebLogImport\bcpWeblog.js ' + @pathname + ' ' +  @date
		set @command = 'c:\WebLogImport\bcpWeblog.exe ' + @pathname + ' ' +  @date
	     	print '*** doing bcp: ' + @command
	     	exec master..xp_cmdshell @command
		insert weblogAll 
			(yy, mm, dd, hh, mi, ss, logID, clientIP,  op, command, error, browser, isVisible)
		   select  yy,mm,dd,  
			coalesce(cast(substring(second,1,2) as int),0) as hh,
			coalesce(cast(substring(second,4,2) as int),0) as mi,
			coalesce(cast(substring(second,7,2) as int),0) as ss,
			@logID, clientIP, op, 
			-- if password is in clear in the command string, truncate it so that
			-- password is deleted
			(case when command like '%password=%' 
			    then substring(command, 1, patindex('%password=%', command)+8)
			    else command end) as command, 
			error, browser,  
			case when command like '/collab%' then 0 else 1 end  as isVisible
			from WebLogTemp 
			order by yy desc, mm desc, dd desc, hh desc, mi desc, ss desc  
		truncate table WebLogTemp
	 
		--- mark that LogSource as current as of that time. 
	 	UPDATE LogSource set tstamp = @newDate WHERE CURRENT OF WebLogs	 
		-- get next LogSource
		FETCH NEXT FROM WebLogs INTO @logID, @location, @service, @instance, @framework, @product, @pathname 
		END
	-- all resorces copied, close cursor and return. 
	CLOSE WebLogs
	DEALLOCATE WebLogs
	SELECT 	@tstamp = min(tstamp),
		@MinYY = datepart(yyyy,min(tstamp)),
		@MinMM = datepart(mm,  min(tstamp)),
		@MinDD = datepart(dd,  min(tstamp))
	FROM  LogSource
	WHERE  location='FNAL' and service='SKYSERVER' and isvisible = 1 and status = 'ACTIVE'	
	EXEC InsertFNALWeblog @MinYY, @MinMM, @MinDD
 	UPDATE LogSource set tstamp = @newDate 
	WHERE  location='FNAL' and service='SKYSERVER' and isvisible = 1 and status = 'ACTIVE'	
    --===========================================================
    -- weblog copy is complete.
    --===========================================================
    end
GO
----------------------------------------------------------------------
if exists (select * from dbo.sysobjects where name = N'spUpdateTrafficStats') 
	drop procedure spUpdateTrafficStats
GO
--
CREATE PROCEDURE spUpdateTrafficStats AS
----------------------------------------------------------
--/H Compute the recent log statistics (SQL and web)
--/U
--/T Looks in the LogSource table to find the last update time. 
--/T deletes trafficBase entries created since the start of that day. 
--/T computes the new values and inserts them in traffic base. 
--/T then updetes the LogSource table to reflect that new time. 
----------------------------------------------------------
 	BEGIN
	SET NOCOUNT ON
    	-- update statiscs	
	DECLARE @newDate DATETIME,			-- the new time if update works
		@MinYY INT, @minMM INT, @minDD INT  	-- the old time
	SET @newDate = GETUTCDATE()			-- get the new time
	SELECT 	@MinYY = datepart(yyyy,min(tstamp)),	-- get the old time
		@MinMM = datepart(mm,  min(tstamp)),
		@MinDD = datepart(dd,  min(tstamp)) 
	FROM  LogSource
	WHERE  service = 'TRAFFIC' and method = 'TSQL' 
 
    	-------------------------------------------------------------
    	-- truncating traffic base more recent that the min age
     	DELETE trafficBase 
	 WHERE (yy >  @minYY)
	    or (yy =  @minYY and mm > @minMM)
	    or (yy =  @minYY and mm = @minMM and dd >= @minDD)
   
    	--------------------------------------------------------------
    	-- updating the aggregate functions
    	INSERT trafficBase (yy, mm, dd, hh, hits, English, German, Japanese, Project,SkyServer, SkyService, SQL) 
	SELECT yy, mm, dd, hh , 
		count(*) as hits, 
		sum(case when command   like '%/en/%'     then 1 else 0 end),
		sum(case when command   like '%/de/%'     then 1 else 0 end),
		sum(case when command   like '%/jp/%'     then 1 else 0 end),
		sum(case when command   like '%/proj/%'   then 1 else 0 end),
		sum(case when service   =    'SKYSERVER'  then 1 else 0 end),
		sum(case when service   =    'SKYSERVICE' then 1 else 0 end),
		0 					-- SQL  
	 FROM  weblogAll w join LogSource  l on w.logID=l.logID
	 WHERE (yy > @minYY)
	    or (yy = @minYY and mm > @minMM)
	    or (yy = @minYY and mm = @minMM and dd >=  @minDD)
	GROUP BY yy, mm, dd, hh  --with rollup
	ORDER BY yy, mm, dd, hh  asc

	---------------------------------------------------------------
	-- compute the SQL traffic
	update trafficbase 
	set sql = s.SQL
	from trafficbase t join (
				select yy,mm,dd,hh, count(*) as SQL 
				from SqlLogAll
				where (yy > @minYY)
				   or (yy = @minYY and mm > @minMM)
				   or (yy = @minYY and mm = @minMM and dd >=  @minDD)
				group by yy,mm,dd,hh) as s 
		on t.yy=s.yy and t.mm=s.mm and t.dd=s.dd and t.hh=s.hh
	
	----------------------------------------------------
	-- update the timestamp of the most recent traffic update
    	UPDATE LogSource set tstamp = @newDate
	 WHERE  service = 'TRAFFIC' and method = 'TSQL'
    ---------------------------------------------------------
    --completion message
    PRINT '*** Traffic Update completed succesfully'
end  
GO
----------------------------------------------------------------------
if exists (select * from dbo.sysobjects where name = N'spCopySqlLogs') 
	drop procedure  spCopySqlLogs  
GO
--
CREATE   PROCEDURE [dbo].[spCopySqlLogs] AS
----------------------------------------------------------
--/H Copies recent SQL logs from SQL servers to the database
--/U
--/T Looks in the LogSource table for SQL logs that are 
--/T  ACTIVE and accessible via the TSQL method
--/T For each such weblog, it 
--/T   deletes entries from that log created since the min-day of that log. 
--/T   copies sql log records since then to the central SQL log.
--/T   advances the minday timestamp of that sqllog in the logsource table.
----------------------------------------------------------
BEGIN
	SET NOCOUNT ON
	DECLARE 
		@newDate datetime,			-- new date (bringing log up to date)
		@logID 	int, 				-- the id of this log source
	 	@command varchar(8000),			-- command to do file copy 
		@instance VARCHAR(32), 			-- Which one V1, V2, ... 
		@pathname VARCHAR(1000), 		-- name to find log
		@tstamp DATETIME			-- how current is the database (last update time)
	---------------------------------------
	-- Get dates
	SET @newDate = GETUTCDATE()
	DECLARE SqlLogs CURSOR 
	  FOR	SELECT logID, instance, pathname, tstamp  
		FROM  LogSource
		WHERE instance != 'CasJobs' and 
			([service] = 'SQL' and method = 'TSQL' and isvisible = 1 and [status] = 'ACTIVE')
	  FOR   UPDATE of tstamp
	OPEN SqlLogs 
	FETCH NEXT FROM SqlLogs INTO @logID, @instance, @pathname, @tstamp 
	WHILE (@@fetch_status = 0)
		BEGIN 
	----------------------------------------------
	-- clean out the sqllog for this source since the min time we have seen. 

		DELETE SqlLogAll 
			WHERE
				logid = @logID
				AND theTime > cast(@tStamp as varchar(35))
 	
	----------------------------------------------
	-- for each Active-TSQL LogSource, copy its log across.
	-- test linked server connections
		declare @ret int, @srv sysname, @len int, @end int, @msg varchar(128)
		set @ret = -1 		
		set @srv = @instance
		begin try
			exec @ret = sys.sp_testlinkedserver @srv
			--print @srv + ' ok!'
			set @ret = 0
		end try
		begin catch
			
			set @ret=sign(@@error);
			set @msg = 'Failed to connect to server ' + @srv;
			INSERT ErrorLog VALUES( getdate(), 'spCopySqlLogs', @msg ); 
			--print 'caught error:' + @msg
			--print error_message()
		end catch
		--linked server worked.  try to copy weblog.
		if (@ret=0)
		begin
			
				set @command = 	'Insert SqlLogAll '
	     			+  ' Select '
				+  ' DATEPART (yyyy , theTime ) as yy,'
	      		+  ' DATEPART (  mm , theTime ) as mm,'
	      		+  ' DATEPART (  dd , theTime ) as dd,'
	      		+  ' DATEPART (  hh , theTime ) as hh,'
	      		+  ' DATEPART (  mi , theTime ) as mi,'
				+  ' DATEPART (  ss , theTime ) as ss,'
				+  ' theTime, '
				+  cast(@logID as varchar(10)) + ' as logid,'
				+  ' clientIP, '
				+  ' webserver, '
				+  ' server,'
				+  ' dbname,'
				+  ' access,'
				+  ' coalesce(elapsed, 99999999) as elapsed,' 
				+  ' coalesce(busy, 99999999) as busy,'
				+  ' coalesce(rows, 99999999) as rows,'
				+  ' left(sql,7950) as statement, '
				+  ' coalesce(error, -2) as error, '
				+  ' coalesce(left(errorMessage,1000),''timeout'') as errorMesssage,'
				+  ' isVisible'
				+  ' from ' + @pathname + '.dbo.sqlLogUtc '
				+  ' where theTime > ''' + cast(@tStamp as varchar(35))
				+  ''' order by theTime desc ' ;
				-- print @command
				begin try
	    			exec (@command)
					--- mark that LogSource as current as of that time.
					UPDATE LogSource set tstamp = @newDate WHERE CURRENT OF SqlLogs
					
				end try
				begin catch
					set @ret=sign(@@error);					
					set @msg = error_message()
					INSERT ErrorLog VALUES( getdate(), 'spCopySqlLogs', @msg );	
					--print @msg
	 			end catch
		END
		--get next LogSource
		FETCH NEXT FROM SqlLogs INTO @logID, @instance, @pathname, @tstamp
	END
		-- all SQL Logs copied, close cursor and return. 
	CLOSE SqlLogs
	DEALLOCATE SqlLogs
	EXEC spCopyLocalCasJobsSqlLogs
    --===========================================================
    -- weblog copy is complete.
    --===========================================================
    end
go


--==============================================================================
drop procedure if exists [dbo].[spCopyLocalCasJobsSqlLogs]
go

CREATE PROCEDURE [dbo].[spCopyLocalCasJobsSqlLogs] AS
----------------------------------------------------------
--/H Copies recent SQL logs from the local CasJobs to the database
--/U
--/T Looks in the LogSource table for SQL logs that are 
--/T  ACTIVE and accessible via the TSQL method
--/T For each such weblog, it 
--/T   deletes entries from that log created since the min-day of that log. 
--/T   copies sql log records since then to the central SQL log.
--/T   advances the minday timestamp of that sqllog in the logsource table.
----------------------------------------------------------
BEGIN


	SET NOCOUNT ON
	DECLARE @date varchar(32),			-- old date (when log was current)
		@newDate datetime,			-- new date (bringing log up to date)
		@logID 	int, 				-- the id of this log source
		@MinYY int, @minMM int, @minDD int,	-- yy mm dd verson of date
	 	@command nvarchar(1000),			-- command to do file copy 
		@instance VARCHAR(32), 			-- Which one V1, V2, ... 
		@pathname VARCHAR(1000), 		-- name to find log
		@uri VARCHAR(1000), 		-- URI of casjobs service to use as requestor for log entry
		@adminHost VARCHAR(64),		-- currently online CasJobs admin server
		@tstamp DATETIME			-- how current is the database (last update time)
	---------------------------------------
	-- Get dates
	SET @newDate = GETUTCDATE()
	SELECT TOP 1 @adminHost = instance FROM LogSource WHERE [service] = 'CasJobs' and location='JHU' and status='ACTIVE'
--	SET @command = 'SELECT @adminHost = host FROM ' + @instance + '.batchadmin.dbo.servers WHERE name = ''batch'' '
--	EXEC sp_executesql @command, N'@adminHost varchar(32) output', @adminHost output 
	SELECT 	@tstamp = min(tstamp),
		@MinYY = datepart(yyyy,min(tstamp)),
		@MinMM = datepart(mm,  min(tstamp)),
		@MinDD = datepart(dd,  min(tstamp)),
		@date  = convert(varchar(10),min(tstamp),120) -- get yyyy-mm-dd
	FROM   LogSource
	WHERE  [service]='CasJobs' and location ='JHU' and method = 'TSQL' and isvisible = 1 and status = 'ACTIVE'
       and instance = @adminHost 

	----------------------------------------------
	-- clean out the weblogs since the min time we have seen. 
	
	DELETE SqlLogAll 
	   WHERE ( (yy > @MinYY) or
	          (yy = @MinYY and mm > @MinMM) or   
	          (yy = @MinYY and mm = @MinMM and dd >= @MinDD) )
	   AND logid IN
		  (SELECT logid 
		   FROM LOGSOURCE
		   WHERE [service]='CasJobs' and location = 'JHU' and method = 'TSQL' and isvisible = 1 and status = 'ACTIVE')
	

	----------------------------------------------
	-- for each Active-TSQL LogSource, copy its log across.
	declare @msg varchar(128)
	DECLARE SqlLogs CURSOR 
	  FOR	SELECT logID, instance, pathname, uri  
		FROM  LogSource
		WHERE [service]='CasJobs' and location= 'JHU' and method = 'TSQL' and isvisible = 1 and status = 'ACTIVE'
	  FOR   UPDATE of tstamp
	OPEN SqlLogs 
	FETCH NEXT FROM SqlLogs INTO @logID, @instance, @pathname, @uri  
	WHILE (@@fetch_status = 0)
		BEGIN 
		set @command = 	'Insert SqlLogAll '
	     	+  ' Select '
		+  ' DATEPART (yyyy , timeStart ) as yy,'
	      	+  ' DATEPART (  mm , timeStart ) as mm,'
	      	+  ' DATEPART (  dd , timeStart ) as dd,'
	      	+  ' DATEPART (  hh , timeStart ) as hh,'
	      	+  ' DATEPART (  mi , timeStart ) as mi,'
	      	+  ' DATEPART (  ss , timeStart ) as ss,'
	      	+  ' timeStart as theTime, '
		+  cast(@logID as varchar(10)) + ' as logid,'
		+  ' isnull(ip,'' '') as clientIP, '
		+  ' '' ' + @uri + ' '' ' + ' as requestor, '
		+  ' isnull(hostIP,'' '') as server,'
		+  ' (case when target like ''DR%'' then ''Best''+target else target end) as dbname,'
		+  ' ''casjobs'' as access,'
		+  ' isnull((case when (datediff(ss,timeStart,timeEnd) < 80000) then datediff(ms,timeStart,timeEnd)/1000.0
       else datediff(ss,timeStart,timeEnd) end),0) as elapsed,' 
		+  ' 0 as busy,'
		+  ' coalesce(rows, 99999999) as rows,'
		+  ' substring(query,1,7950) as statement, '
		+  ' (case when status=4 then 1 else 0 end) as error, '
		+  ' '' '' as errorMesssage,'
		+  ' 1 as isVisible'
		+  ' from ' + @pathname
		+  ' where timeStart > ''' + substring(cast(@tStamp as varchar(35)),1,11) + ' 00:00:00'''
		+  ' order by theTime desc ' ;
		-- print @command
	    begin try
			exec (@command)
	 		--- mark that LogSource as current as of that time. 
	 		UPDATE LogSource set tstamp = @newDate WHERE CURRENT OF SqlLogs
		end try
		begin catch 						
			set @msg = error_message()
			INSERT ErrorLog VALUES( getdate(), 'spCopyLocalCasJobsSqlLogs', @msg );	
	 	end catch	 
		-- get next LogSource
		FETCH NEXT FROM SqlLogs INTO @logID, @instance, @pathname, @uri
		END
	-- all SQL Logs copied, close cursor and return. 
	CLOSE SqlLogs
	DEALLOCATE SqlLogs
    --===========================================================
    -- weblog copy is complete.
    --===========================================================
    end

go

----------------------------------------------------------------------
if exists (select * from dbo.sysobjects where name = N'InsertFNALWeblog') 
	drop procedure  InsertFNALWeblog  
GO
--
CREATE  PROCEDURE InsertFNALWeblog( @minYY int, @minMM int, @minDD int ) AS
----------------------------------------------------------
--/H Copies recent weblogs from FNAL public web server to the database
--/U
--/T For now, copies logs directly from server at FNAL.
--/T DR3 hits are marked as logID=8 for convenience, DR2 logID=7.
----------------------------------------------------------
BEGIN
 	DELETE weblogAll 
	 	  WHERE  (  (yy > @minYY) or
	      		    (yy = @minYY and mm > @minMM) or   
	      		    (yy = @minYY and mm = @minMM and dd >= @minDD)
			 ) and logID IN (7,8,9,10,11,12,13)
	INSERT weblogAll 
	(yy, mm, dd, hh, mi, ss, logID, clientIP,  op, command, error, browser, isVisible, referer, bytesOut, bytesIn, elapsed)
   		select  yy,mm,dd,  
			coalesce(cast(substring(second,1,2) as int),0) as hh,
			coalesce(cast(substring(second,4,2) as int),0) as mi,
			coalesce(cast(substring(second,7,2) as int),0) as ss,
			case when command like '%dr3%' then 8 else 7 end as logID, 
			clientIP, op, 
			-- if password is in clear in the command string, truncate it so that
			-- password is deleted
			(case when command like '%password=%' 
			    then substring(command, 1, patindex('%password=%', command)+8)
			    else command end) as command, 
			error, browser,  
			case when command like '/collab%' then 0 else 1 end  as isVisible,
			cast(referer as varchar(500)), bytesOut, bytesIn, elapsed
			from [SDSSSQL004.FNAL.GOV].Weblog.dbo.WebLog
			where ( (yy > @minYY) OR
				(yy = @minYY AND mm > @minMM) OR
				(yy = @minYY AND mm = @minMM AND dd >= @minDD) 
			      )
			order by yy desc ,mm desc,dd desc,hh desc,mi desc,ss  desc  
END
GO

--===============
-- user stuff
--===============
exec sp_addrole N'weblog'

if not exists (select * from dbo.sysusers 
	where name = N'weblog' and uid < 16382)
	EXEC sp_grantdbaccess N'weblog', N'weblog'
exec sp_addrolemember N'db_datareader', N'weblog'
GO
if not exists (select * from dbo.sysusers 
	where name = N'test' and uid < 16382)
	EXEC sp_grantdbaccess N'test', N'test'
exec sp_addrolemember N'db_datareader', N'test'
GO
if not exists (select * from dbo.sysusers 
	where name = N'internet' and uid < 16382)
	EXEC sp_grantdbaccess N'internet', N'internet'
exec sp_addrolemember N'db_datareader', N'internet'
--
exec sp_addrolemember N'db_datareader', N'weblog'
GO
--
GRANT  SELECT, INSERT 	ON SqlPerformanceLog 	TO weblog
GRANT  SELECT, INSERT 	ON SqlStatementLog 	TO weblog
GRANT  SELECT  		ON trafficBase 		TO weblog
GRANT  SELECT  		ON weblog 		TO weblog
GRANT  SELECT  		ON DailyTraffic 	TO weblog
GRANT  SELECT  		ON MonthlyTraffic 	TO weblog
GRANT  SELECT  		ON SqlLog		TO weblog
GRANT  SELECT  		ON TotalTraffic 	TO weblog
go
GRANT  SELECT  		ON trafficBase 		TO test
GRANT  SELECT  		ON weblog 		TO test
GRANT  SELECT  		ON DailyTraffic 	TO test
GRANT  SELECT  		ON MonthlyTraffic 	TO test
GRANT  SELECT  		ON SqlLog 		TO test
GRANT  SELECT  		ON TotalTraffic 	TO test
GO
GRANT  SELECT  		ON trafficBase 		TO internet
GRANT  SELECT  		ON weblog 		TO internet
GRANT  SELECT  		ON DailyTraffic 	TO internet
GRANT  SELECT  		ON MonthlyTraffic 	TO internet
GRANT  SELECT  		ON SqlLog 		TO internet
GRANT  SELECT  		ON TotalTraffic 	TO internet
GO
--================================================================================
-- PopulateLogSource.sql
-- 2003-10-26 Alex Szalay
-- Load the values of the LogSource and privacy tables
-- so that we know where to harvest from
-- 2003-10-29 jim: added weblog values
--================================================================================
SET NOCOUNT ON
delete LogSource
GO
--================<SKYSERVER weblogs>===================
-- skyserver.fnal.gov
INSERT LogSource VALUES(1, 'FNAL', 'SKYSERVER', 'EDR','skyserver.fnal.gov',    'ASP',  'EDR', 'WGET',
	'???? ', '2001-01-01', 1, 'ACTIVE');
-- skyserver.pha.jhu.edu
INSERT LogSource VALUES(2, 'JHU', 'SKYSERVER', 'EDR', 'skyserver.pha.jhu.edu', 'ASP',  'EDR', 'XCOPY',
	'\\skyserver\LogFiles\W3SVC1\', '2001-01-01', 1, 'INACTIVE');
-- skyserver.pha.jhu.edu
INSERT LogSource VALUES(3, 'JHU', 'SKYSERVER', 'V1', 'skyserver.pha.jhu.edu', 'ASP',  'EDR', 'XCOPY',
	'\\skyserver\LogFiles\W3SVC1\', '2001-01-01', 1, 'ACTIVE');
-- www.skyserver.org
INSERT LogSource VALUES(4, 'JHU', 'SKYSERVER', 'V3', 'www.skyserver.org',     'ASP+', 'DR1', 'XCOPY',
	'\\skyserver\LogFiles\W3SVC3\', '2001-01-01', 1, 'ACTIVE');
-- skyserver.sdss.org
INSERT LogSource VALUES(5, 'JHU', 'SKYSERVER', 'V4', 'skyserver.sdss.org',     'ASP+', 'DR1', 'XCOPY',
	'\\skyserver\LogFiles\W3SVC4\', '2001-01-01', 1, 'ACTIVE');
--  skyserver.sdss.org
INSERT LogSource VALUES(6, 'JHU', 'SKYSERVER', 'V5', 'skyserver.sdss.org',    'ASP+', 'DR1', 'XCOPY',
	'\\skyserver\LogFiles\W3SVC5\', '2001-01-01', 1, 'ACTIVE');
INSERT LogSource VALUES(7, 'FNAL', 'SKYSERVER', 'DR2', 'cas.sdss.org',        'ASP+', 'DR2', 'WGET', 
	'????', '2001-01-01', 1, 'ACTIVE');
INSERT LogSource VALUES(8, 'FNAL', 'SKYSERVER', 'DR3', 'cas.sdss.org',        'ASP+', 'DR3', 'WGET',
	'????', '2001-01-01', 1, 'ACTIVE');

--================<SKYSERVICE weblogs>===================
-- this is the skyservice.pha.jhu.edu
INSERT LogSource VALUES(1001, 'JHU', 'SKYSERVICE', 'V1', 'skyservice.pha.jhu.edu', '.NET', 'DR1', 'XCOPY',
	'\\skyservice\LogFiles\W3SVC1\', '2001-01-01', 1, 'ACTIVE');
-- voservices.org
INSERT LogSource VALUES(1002, 'JHU', 'SKYSERVICE', 'V2', 'voservices.org',         '.NET', 'DR1', 'XCOPY',
	'\\skyservice\LogFiles\W3SVC2\', '2001-01-01', 1, 'ACTIVE');
-- voservices.net
INSERT LogSource VALUES(1003, 'JHU','SKYSERVICE',  'V3', 'voservices.net',         '.NET', 'DR1', 'XCOPY',
	'\\skyservice\LogFiles\W3SVC3\', '2001-01-01', 1, 'ACTIVE');
-- skyquery.net
INSERT LogSource VALUES(1004, 'JHU','SKYSERVICE', 'V4', 'skyquery.net',            '.NET', 'DR1', 'XCOPY',
	'\\skyservice\LogFiles\W3SVC4\', '2001-01-01', 1, 'ACTIVE');
-- skyquery.org
INSERT LogSource VALUES(1005, 'JHU','SKYSERVICE', 'V5', 'skyquery.org',            '.NET', 'DR1', 'XCOPY',
	'\\skyservice\LogFiles\W3SVC5\', '2001-01-01', 1, 'ACTIVE');
-- photo-z.net
INSERT LogSource VALUES(1006, 'JHU','SKYSERVICE', 'V7', 'photo-z.net',             '.NET', 'DR1', 'XCOPY',
	'\\skyservice\LogFiles\W3SVC7\', '2001-01-01', 1, 'ACTIVE');

--================<SQL LOG Update>===================
INSERT LogSource VALUES(2001, 'FNAL','SQL',     'EDR',  'skyserver.fnal.gov/weblog', 'SQL',  'EDR',     'WSQL',
	'FNAL-EDR.WebLog.', '2001-01-01', 1, 'ACTIVE');
INSERT LogSource VALUES(2002, 'JHU','SQL',     'EDR',  'skyserver.pha.jhu.edu/weblog', 'SQL',  'EDR',     'WSQL',
	'FNAL-EDR.WebLog.', '2001-01-01', 1, 'INACTIVE');
-- SDSSDR1
INSERT LogSource VALUES(2003, 'JHU', 'SQL',     'SDSSDR1', 'SDSSDR1.weblog',       'SQL',  'DR1', 'TSQL',
	'SdssDr1.weblog', '2001-01-01', 1, 'ACTIVE');
-- SDSSAD2
INSERT LogSource VALUES(2004, 'JHU', 'SQL',     'SDSSAD2', 'SDSSAD2.weblog',       'SQL',  'DR1', 'TSQL',
	'SdssAD2.weblog', '2001-01-01', 1, 'ACTIVE');
-- SDSSAD3 -- NONE
-- SDSSAD4 -- NONE
-- SDSSAD5 -- NONE
-- SDSSAD6  
INSERT LogSource VALUES(2005, 'JHU', 'SQL',     'SDSSAD6', 'SDSSAD6.weblog',       'SQL',  'DR1', 'TSQL',
	'SdssAD6.weblog', '2001-01-01', 1, 'ACTIVE');
-- LIBERTY -- NONE

--================<TrafficUpdate>===================
INSERT LogSource VALUES(9001, 'JHU', 'TRAFFIC', 'V1',   'skyserver.sdss.org', 	    'ASP+', 'ALL', 'TSQL',
	'SdssAd2.weblog.dbo', '2001-01-01', 1, 'ACTIVE');
GO

------------------------------------------------------------------------
DELETE privacy
GO
INSERT privacy VALUES('JHU','skyserver.sdss.org',   'collab',  'COLLAB');
INSERT privacy VALUES('JHU','skyserver.pha.jhu.edu','collab',  'COLLAB');
INSERT privacy VALUES('JHU','skyserver.sdss.org',   'collabpw','COLLAB');
INSERT privacy VALUES('JHU','skyserver.pha.jhu.edu','collabpw','COLLAB');
GO
 
 