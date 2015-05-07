------------------------------------------------------------------
-- Versions.sql
-- 2004-09-18 Alex Szalay
------------------------------------------------------------------
-- Tracking SkyServer versions
--
-- 2005-01-15 Ani: Added DR3 v3.0 and v3.1 entries.
-- 2005-09-13 Ani: Added DR4 v4.0 entry.
--------------------------------------------------
SET NOCOUNT ON
GO

--================================================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Versions' )
DROP TABLE Versions
GO
--
CREATE TABLE Versions (
----------------------------------------------------------
--/H Tracks the versioning history of the database
----------------------------------------------------------
--/T This is a log of all major changes that happened to the DB
--/T since its creation. 
----------------------------------------------------------
	[event]		varchar(256)	not null,	--/D The event that happened --/K ID_IDENITIFIER
	[previous]	varchar(64)	not null,	--/D Version before the patch --/K ID_TRACER
	[checksum]	varchar(64)	not null,	--/D Checksum before the patch --/K NUMBER
	[version]	varchar(64)	not null,	--/D Version after the patch  --/K ID_TRACER
	[description]	varchar(256)	not null,	--/D Summary of changes --/K METADATA_DESCRIPTION
	[text]		varchar(2000)	not null,	--/D Details of changes in HTML form --/K METADATA_DESCRIPTION
	[who]		varchar(256)	not null,	--/D Person(s) responsible --/K ID_HUMAN
	[when]		varchar(256)	not null	--/D When it happened --/K TIME_DATE
)
GO
--

INSERT INTO Versions Values (
	'Create DR1','0.0',0,'1.0',
	'Created DR1 from scratch',
	'Contains Photo5.3 outputs.'
	+' Uses schema substantially changed from the EDR version.',
	'Ani Thakar, Jim Gray, Alex Szalay, Adrian Pope, Jan Vandenberg',
	'Jun 03 2003 12:00PM'
)
GO

INSERT INTO Versions Values (
	'Create DR2','0.0',0,'2.0',
	'Created DR2 from DR1',
	'Contains Photo5.4 outputs.'
	+' Uses schema with minor changes from the DR1 version.',
	'Ani Thakar, Jim Gray, Alex Szalay, Adrian Pope, Jan Vandenberg',
	'Nov 1 2003 12:00PM'
)
GO


INSERT INTO Versions Values (
	'Create DR3','0.0',0,'3.0',
	'Created DR3 from DR2',
	'Contains Photo5.4 outputs.'
	+' Uses schema with minor changes from the DR2 version.',
	'Ani Thakar, Jim Gray, Alex Szalay, Adrian Pope, Jan Vandenberg',
	'Mar 15 2004 12:00PM'
)
GO


INSERT INTO Versions Values (
	'Update DR3','3.0',11617548285,'3.1',
	'Updates to DR3',
	'Contains results of sector computation, metadata updates and '
	+'bug fixes, and new USNOB and QuasarCatalog tables.',
	'Ani Thakar, Jim Gray, Alex Szalay, Adrian Pope, Jan Vandenberg',
	'Apr 3 2005 3:50PM'
)
GO


INSERT INTO Versions Values (
	'Create DR4','3.1',15223449363,'4.0',
	'Created DR4 from DR3',
	'Contains incrementally loaded DR4 data',
	'Ani Thakar, Jim Gray, Alex Szalay, Adrian Pope, Jan Vandenberg',
	'June 29, 2005 12:00PM'
)
GO


PRINT '[Versions.sql]: Versions table created'
GO