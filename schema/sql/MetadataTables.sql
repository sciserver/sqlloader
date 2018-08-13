------------------------------------------------------------------
-- MetadataTables.sql
-- 2001-05-10 Alex Szalay
------------------------------------------------------------------
-- SkyServer MetaData tables
--
-- These tables have data that describes the Sky Server data tables.
-- To install these on your system, you must change the web server URL.
--    from 'http://skyserver.sdss.org/' to your WebServer URL.
-------------------------------------------------------------------
-- History:
--
--* 2001-05-15 Alex: Omitted sx from names and changed FOREIGN KEYs
--* 2001-11-03 Jim : Added site constants.
--* 2001-11-23 Alex: Eliminated sql_variant, switched to varchar(..)
--* 2001-12-09 Jim:  Documentation (v.3.36), & 3.36  history changes
--*                  Changed spUpdateStatistcs to spUpdateSkyServerCrossCheck
--* 2002-09-20 Alex: Added UCDs
--* 2002-11-05 Alex: Moved Primary keys to spManageIndices.sql
--* 2002-11-05 Alex: Created LoadHistory table
--* 2002-11-25 Alex: spGrantAccess-- updated from script in spManageIndices.sql
--* 2002-11-26 Alex: Changed Columns->DBColumns, ViewCol->DBViewCols
--* 2002-12-27 Alex: Added PubHistory
--* 2003-05-26 Alex: Moved spUpdateStatistics here
--* 2003-06-03 Alex: Changed count(*) to count_big(*)
--* 2003-07-21 Ani:  Updated glossary table - added "name" column
--* 2003-07-24 Ani:  Added Algorithm table for algorithm descriptions
--* 2003-08-07 Ani:  Added TableDesc table for table descriptions.
--* 2003-08-20 Ani:  Updated SiteConstants for DR2 testload.
--* 2003-08-21 Ani:  Automated setting of DB version in SiteConstants (PR 5599).
--* 2004-04-25 Ani:  Commented out DBObjectDescription table definition.
--* 2004-08-27 Alex: Moved spGrantAccess here from IndexMap.sql
--* 2004-08-31 Alex: moved QueryResults here from MyTimeX.sql
--* 2004-09-10 Alex: moved spCheckDBIndexes from here to IndexMap.sql
--* 2004-09-16 Alex: fixed bug with master access in spGrantAccess,
--*		renamed History to Versions and moved it to Versions.sql,
--*		and created new History, Inventory and Dependency tables
--* 2004-09-17 Alex: moved all CheckDB and Diagnostic procs and 
--*		spGrantAccess to spCheckDB.sql
--* 2004-11-12 Jim: added zoneHeight site constant.
--* 2005-02-04 Jim: made QueryResults.Time not null so it can be part of primary key
--* 2005-02-15 Ani: added RecentRequests table to restrict queries/min.
--* 2005-02-25 Ani: replaced RecentRequests with RecentQueries.
--* 2005-03-19 Jim: Added SiteDBs table
--* 2005-04-12 Ani: Documented SiteDBs and added code to populate it.
--* 2005-04-14 Ani: Changed description for RecentQueries.
--* 2005-04-15 Ani: Added rank to DBObjects amd DBColumns (PR # 6405).
--* 2005-04-18 Ani: Updated SiteConstants values for DR3.
--* 2005-09-13 Ani: Updated SiteConstants values for DR4.
--* 2007-09-26 Ani: Changed SiteDiagnostics into a U table (not admin).
--* 2010-11-16 Ani: Removed TableDesc table - it is now a view.  Also
--*                 removed Glossary and Algorithm tables.
--* 2010-12-10 Ani: Changed PubHistory.nrows to bigint from int.
--* 2013-07-10 Ani: Added admin table SkipFinishPhases.
--* 2018-08-13 Sue: Removing QueryResults table, moving to weblog db
--=================================================================
SET NOCOUNT ON;
GO


--============================================================
IF EXISTS (SELECT * FROM dbo.sysobjects
	WHERE id=object_id(N'[SiteDBs]')
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [SiteDBs]
GO
--
CREATE TABLE SiteDBs ( 	
-------------------------------------------------------
--/H Table containing the list of DBs at this CAS site.
-------------------------------------------------------
--/T The SiteDBs table contains the name, short description 
--/T and status of each db available for user access in this 
--/T CAS server.  This is used to auto-generate the list of
--/T available user databases on the SkyServer front page
--/T (at least for the collab and astro sites).
-------------------------------------------------------
	dbname 		VARCHAR(64) NOT NULL,	--/D Name of the database
	description 	VARCHAR(128) NOT NULL, 	--/D Short one-line description
	active 	    	CHAR(1) NOT NULL	--/D Is it active/visible?
)
GO


-- Insert intial values into SiteDBs, these can be turned on or off by
-- changing the active value to 'N'.
INSERT SiteDBs
   SELECT [name],'The best version photo (imaging), spectro and tiling data','Y' FROM master.dbo.sysdatabases
   WHERE [name] LIKE 'BEST%'
INSERT SiteDBs
   SELECT [name],'The version of the photo (imaging) data that target selection was run on','Y' FROM master.dbo.sysdatabases
   WHERE [name] LIKE 'TARG%'
INSERT SiteDBs
   SELECT [name],'The Early Data Release data','Y' FROM master.dbo.sysdatabases
   WHERE [name] LIKE 'SkyServer%'





--================================================================
IF EXISTS (SELECT name FROM  sysobjects 
	   WHERE  name = N'RecentQueries' )
DROP TABLE [RecentQueries]
GO
--
CREATE TABLE RecentQueries (
-------------------------------------------------------------------------------
--/H Record the ipAddr and timestamps of the last n queries
-------------------------------------------------------------------------------
--/T Query log table to record last n query IPs and timestamps so 
--/T that queries can be restricted to a certain number per minute per
--/T IP to prevent crawlers from hogging the system (see spExecuteSQL).
-----------------------------------------------------------------------------
	ipAddr VARCHAR(30) NOT NULL,
	lastQueryTime DATETIME NOT NULL
)
GO


--================================================================
IF EXISTS (SELECT name FROM  sysobjects 
	   WHERE  name = N'SkipFinishPhases' )
DROP TABLE [SkipFinishPhases]
GO
--
CREATE TABLE SkipFinishPhases (
-------------------------------------------------------------------------------
--/H List the FINISH step phases that should be skipped
--/A
--/T For various reasons (especially in incremental loading mode), it
--/T is necessary to skip one or more phases in spFinishStep.  This
--/T table provides a way to do that by listing those phase names here.
--/T This is an admin-only table, not for user consumption.
-----------------------------------------------------------------------------
	phase VARCHAR(32) NOT NULL
)
GO


--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[SiteConstants]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [SiteConstants]
GO
--
CREATE TABLE SiteConstants (
-------------------------------------------------------------------------------
--/H Table holding site specific constants
-----------------------------------------------------------------------------
	name		varchar(64) 	NOT NULL,	--/D Name --/K ID_IDENTIFIER
	value		varchar(64) 	NOT NULL,	--/D Value --/K DATA
	comment		varchar(256) 	NOT NULL	--/D Description --/K METADATA_DESCRIPTION
)
GO
--

DECLARE @version VARCHAR(32);
SET @version = (SELECT value FROM loadsupport..Constants WHERE [name]='version');
Insert into SiteConstants values ('DB Version',     @version,'The database schema version ')
Insert into SiteConstants values ('DataServerURL',  'http://das.sdss.org/DR4/data/', 'The URL of the data archive server for this DB')
Insert into SiteConstants values ('WebServerURL',   'http://cas.sdss.org/dr4/en/', 'The name of the web server for data services this DB')
Insert into SiteConstants values ('DB Type', 	    'DR4 SkyServer','The contents of the database')
Insert into SiteConstants values ('DB Version Date', cast(Current_TimeStamp as varchar(64)),'The date the schema was last updated')
Insert into SiteConstants values ('Checksum', 	     '0', 'Checksum to validate the DB')
insert into SiteConstants values ('zoneHeight',      '0.008333300000000',   'zone height in degrees')
GO
--

--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[DBObjects]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [DBObjects]
GO
--
CREATE TABLE DBObjects (
-------------------------------------------------------------------------------
--/H Every SkyServer database object has a one line description in this table
-------------------------------------------------------------------------------
	[name]		varchar(128) 	NOT NULL,	--/D Name of the object --/K ID_IDENTIFIER
	[type]		varchar(64)	NOT NULL,	--/D Its system type --/K ID_GROUP
	[access]	varchar(8)	NOT NULL,	--/D Defines user or admin access --/K ID_GROUP
	[description]	varchar(256)	NOT NULL,	--/D One line description of contents --/K METADATA_DESCRIPTION
	[text]		varchar(7200)	NOT NULL,	--/D Detailed description of contents --/K METADATA_DESCRIPTION
	[rank]		int 	NOT NULL DEFAULT 0	--/D Optional position of column in table display --/K ID_TABLE
)
GO
--

--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[DBColumns]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [DBColumns]
GO
--
CREATE TABLE DBColumns (	
-------------------------------------------------------------------------------
--/H Every column of every table has a description in this table
-------------------------------------------------------------------------------
	[tablename]	varchar(128) 	NOT NULL,	--/D The name of the parent table --/K ID_TABLE
	[name]		varchar(64) 	NOT NULL,	--/D The name of column --/K ID_IDENTIFIER
	[unit]		varchar(64) 	NOT NULL,	--/D Optional description of units --/K METADATA_UNIT
	[ucd]		varchar(128)	NOT NULL,	--/D Optional UCD definition --/K ID_IDENTIFIER 
	[enum]		varchar(64) 	NOT NULL,	--/D Optional link to an enumerated table --/K ID_TABLE
	[description]	varchar(2000) 	NOT NULL,	--/D One line description of column --/K METADATA_DESCRIPTION
	[rank]		int 	NOT NULL DEFAULT 0	--/D Optional position of column in table column display --/K ID_TABLE
)
GO
--


--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[DBViewCols]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [DBViewCols]
GO
--
CREATE TABLE DBViewCols (	
-------------------------------------------------------------------------------
--/H The columns of each view are stored for the auto-documentation
--
--/T * means that every column from the
--/T parent is propagated.
-------------------------------------------------------------------------------
	[name]		varchar(64) 	NOT NULL,	--/D The name of column --/K ID_IDENTIFIER
	[viewname]	varchar(128) 	NOT NULL,	--/D The name of the view --/K ID_TABLE
	[parent]	varchar(128)	NOT NULL	--/D The name of the parent --/K ID_TABLE
)
GO
--



--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[History]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [History]
GO
--
CREATE TABLE History (
-------------------------------------------------------------------------------
--/H Contains the detailed history of schema changes
-------------------------------------------------------------------------------
--/T The changes are tracked by module
-------------------------------------------------------------------------------
	[id]		int identity(1,1) NOT NULL,	--/D The unique key for entry --/K ID_IDENTIFIER
	[filename]	varchar(128) 	NOT NULL,	--/D The name of the sql file --/K ID_IDENTIFIER
	[date]		varchar(64) 	NOT NULL,	--/D Date of change --/K DATE
	[name]		varchar(64) 	NOT NULL,	--/D Name of person making the change --/K ID_IDENTIFIER
	[description]	varchar(7200) 	NOT NULL	--/D Detailed description of changes --/K METADATA_DESCRIPTION
)
GO
--


--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Inventory]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [Inventory]
GO
--
CREATE TABLE Inventory (
-------------------------------------------------------------------------------
--/H Contains the detailed inventory of database objects
-------------------------------------------------------------------------------
--/T The objects are tracked by module
-------------------------------------------------------------------------------
	[filename]	varchar(128) 	NOT NULL,	--/D The name of the sql file --/K ID_IDENTIFIER
	[name]		varchar(128) 	NOT NULL,	--/D Name of DBObject --/K ID_IDENTIFIER
	[type]		varchar(2) 	NOT NULL	--/D Detailed description of changes --/K METADATA_DESCRIPTION
)
GO
--


--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Dependency]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [Dependency]
GO
--
CREATE TABLE Dependency (
-------------------------------------------------------------------------------
--/H Contains the detailed inventory of database objects
-------------------------------------------------------------------------------
--/T The objects are tracked by module
-------------------------------------------------------------------------------
	[filename]	varchar(128) 	NOT NULL,	--/D The name of the sql file --/K ID_IDENTIFIER
	[parent]	varchar(128) 	NOT NULL,	--/D Name of caller --/K ID_IDENTIFIER
	[child]		varchar(128) 	NOT NULL	--/D Name of called function --/K ID_IDENTIFIER
)
GO
--




--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[PubHistory]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [PubHistory]
GO
--
CREATE TABLE PubHistory (
------------------------------------------------
--/H This table keeps the record of publishing into a table
--/A
--/T this table only gets written into if this is a destination database.
--/T The table contains the names of the tables which were published into
--/T The table is wrttien by the publisher. It can be compared at the end
--/T to the contents of the Diagnostics table.
------------------------------------------------
	[name]		varchar(64) NOT NULL,	--/D the name of the table we publish into
	[nrows]		bigint NOT NULL,	--/D the number of rows published
	[tend]		datetime NOT NULL,	--/D the time the table was published
	[loadversion]	int NOT NULL		--/D the taskid where it came from
)
GO


--================================================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'LoadHistory' )
DROP TABLE LoadHistory
GO
--
CREATE TABLE LoadHistory (
-----------------------------------------------------------
--/H Tracks the loading history of the database
--
--/T Binds the loadversion value to dates and Task names
--/T
-----------------------------------------------------------
	[loadversion]	int NOT NULL,
	[tstart]	datetime NOT NULL,
	[tend]		datetime NOT NULL,
	[dbname]	varchar(64) NOT NULL
)
GO

--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Diagnostics]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Diagnostics]
GO
--
CREATE TABLE Diagnostics (
------------------------------------------------
--/H This table stores a full diagnostic snapshot of the database.
--/A
--/T The table contains the names of all the tables, views,
--/T stored procedures and user defined functions in the database.
--/T We leave out the Diagnostics itself, QueryResults and LoadEvents, etc
--/T these can be dynamically updated. We compute the row counts
--/T for each table and view. This is generated by running the
--/T stored procedure spMakeDiagnostics. The table was
--/T replicated upon the creation of the database into SiteDiagnostics.
-------------------------------------------------
	[name]	varchar(64)	not null,	--/D Name of object --/K ID_IDENTIFIER
	[type]	varchar(8)	not null,	--/D System type of the object (U:table, V:view, F: function, P: stored proc) --/K CODE_MISc
	[count] bigint				--/D Optional row count, where applicable  --/K NUMBER
)
GO

--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[SiteDiagnostics]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [SiteDiagnostics]
GO
--
CREATE TABLE [SiteDiagnostics] (
------------------------------------------------
--/H This table stores the full diagnostic snapshot after the last revision
--
--/T The table contains the names of all the tables, views,
--/T stored procedures and user defined functions in the database.
--/T We leave out the Diagnostics itself, QueryResults and LoadEvents,
--/T these can be dynamically updated. This was generated from the
--/T Diagnostics table when the DB was created.
-------------------------------------------------
	[name]	varchar(64)	not null,	--/D Name of object --/K ID_IDENTIFIER
	[type]	varchar(8)	not null,	--/D System type of the object (U:table, V:view, F: function, P: stored proc) --/K ???
	[count] bigint				--/D Optional row count, where applicable --/K NUMBER
)
GO
--


PRINT '[MetadataTables.sql]: MetaData tables created'
GO

