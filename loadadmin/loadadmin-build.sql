--=================================================
-- loadadmin-build.sql
-- 2002-09-28	Alex Szalay
---------------------------------------------------
-- build the loadadmin database, install logins,
-- grant the appropriate permissions to 'loadagent'
---------------------------------------------------
-- 2002-11-28	Alex: set loadadmin logging to full
-- 2003-01-02	Alex+Jan: remobved loadagent references
-- 2003-12-03   Jim: added AlterDB rather than DB options and 
--                   set options as per SQL Best Practices Advisor
--=================================================

SET NOCOUNT ON
GO

IF EXISTS (SELECT name 
	FROM master.dbo.sysdatabases 
	WHERE name = N'loadadmin')
	DROP DATABASE [loadadmin]
GO
--
CREATE DATABASE [loadadmin] 
ON  (	NAME = N'LoadAdmin_Data1', 
	FILENAME = N'C:\sql_db\LoadAdmin_Data1.MDF' , 
	SIZE = 100, 
	FILEGROWTH = 10%
	)   
LOG ON 
   (	NAME = N'LoadAdmin_Log', 
	FILENAME = N'C:\sql_db\LoadAdmin_Log.LDF' , 
	SIZE = 10, 
	FILEGROWTH = 10%
   )
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO
--
PRINT CAST(getdate() as varchar(64)) + '  -- Loadadmin database created'


USE master
GO
-------------------------------------------------
-- turn on trace flag 1807 -- enable NAS attach
-------------------------------------------------
DBCC TRACEON(1807)
PRINT CAST(getdate() as varchar(64)) + '  -- Turned on Trace Flag(1807)'
GO

------------------------------------------------
-- set database options
------------------------------------------------
ALTER DATABASE LoadAdmin        SET
	 ANSI_NULLS              ON,
         ANSI_PADDING            ON,
         ANSI_WARNINGS           ON,
         ARITHABORT              ON,
         CONCAT_NULL_YIELDS_NULL ON, 
         QUOTED_IDENTIFIER       ON,
         CURSOR_CLOSE_ON_COMMIT  ON,
         AUTO_CREATE_STATISTICS  ON,
         AUTO_UPDATE_STATISTICS  ON,  
         RECURSIVE_TRIGGERS     OFF, 
         TORN_PAGE_DETECTION     ON,
         RECOVERY FULL,      
         CURSOR_DEFAULT GLOBAL  
GO
 

Print CAST(getdate() as varchar(64)) + '  -- Database options set'
