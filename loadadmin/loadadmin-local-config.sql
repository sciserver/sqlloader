--================================================
-- loadadmin-local-config.sql
-- 2002-06-03 Alex Szalay
--------------------------------------------------
-- the custom parameters for the loadadmin database
--------------------------------------------------
-- 2002-11-28	Alex: split it from loadadmin-schema.sql
-- 2005-03-18   Ani: Added checks to see if Constants table
--                   exists, and if so to replace certain
--                   constants for incremental loading.
--================================================
--
SET NOCOUNT ON
GO

--------------------------------------------------
-- configure these for a new server setup
--------------------------------------------------
DECLARE @version VARCHAR(32);

SET @version = '$Name$';
SET @version = REPLACE( @version, '$', ' ');
SET @version = SUBSTRING( @version, 8, 20 );

IF EXISTS (SELECT [name] FROM Constants WHERE [name]='backuppath')
   DELETE Constants WHERE [name]='backuppath'
IF EXISTS (SELECT [name] FROM Constants WHERE [name]='loadagent')
   DELETE Constants WHERE [name]='loadagent'
IF EXISTS (SELECT [name] FROM Constants WHERE [name]='version')
   DELETE Constants WHERE [name]='version'

-- Modify the values of csvpath, backuppath and loadagent for local setup.
INSERT INTO Constants VALUES('csvpath','c:\data\staging\sdss3\casload\');
INSERT INTO Constants VALUES('csvpath','c:\data\publish\sdss3\casload\');

INSERT INTO Constants VALUES('backuppath','\\sdss4c\taskdbbackup\');
INSERT INTO Constants VALUES('loadagent','SDSS\mssql');
INSERT INTO constants VALUES('Taskdatapath','c:\data\task1\sql_db\');
INSERT INTO constants VALUES('Taskdatapath','c:\data\task2\sql_db\');
INSERT INTO constants VALUES('Taskdatapath','c:\data\task3\sql_db\');
INSERT INTO constants VALUES('Taskdatapath','c:\data\task4\sql_db\');

-- Update the db file paths for publish and task dbs.
IF EXISTS (SELECT [name] FROM Constants WHERE [name]='pubdatapath')
   UPDATE Constants SET value='c:\data\publish\sql_db\' WHERE [name]='pubdatapath'
IF EXISTS (SELECT [name] FROM Constants WHERE [name]='publogpath')
   UPDATE Constants SET value='c:\data\publish\sql_db\' WHERE [name]='publogpath'

-- Set the version.
INSERT INTO Constants VALUES('version',@version);

print cast(getdate() as varchar(64)) + '  -- Local loadadmin params configured'

