--=====================================================================
-- bcpweblog_test on sdss4c: a scratch copy of the weblog tables the
-- loader touches.  TEST ONLY; never run this on lumberjack.
--
--     sqlcmd -S sdss4c -E -C -b -i bcpweblog_test_setup.sql
--     sqlcmd -S sdss4c -E -C -b -d bcpweblog_test -i bcpweblog_schema.sql
--
-- weblogAll and LogSource match lumberjack's weblog (read 2026-10-28)
-- except for the constraint names.  weblogAll starts empty.  sdss4c's
-- other weblog databases (weblog, dev_weblog, weblog_old, Weblog_Rescue)
-- are not touched.
--=====================================================================
SET NOCOUNT ON
GO
IF @@SERVERNAME NOT LIKE 'SDSS4C%'
	THROW 50000, 'bcpweblog_test_setup.sql is for sdss4c only', 1
GO
IF DB_ID('bcpweblog_test') IS NULL
BEGIN
	CREATE DATABASE bcpweblog_test COLLATE SQL_Latin1_General_CP1_CI_AS
	ALTER DATABASE bcpweblog_test SET RECOVERY SIMPLE
	ALTER DATABASE bcpweblog_test SET READ_COMMITTED_SNAPSHOT ON	-- as weblog
END
GO
USE bcpweblog_test
GO

IF OBJECT_ID('dbo.LogSource') IS NULL
BEGIN
	CREATE TABLE dbo.LogSource (
		logID		int NOT NULL CONSTRAINT PK_LogSource PRIMARY KEY,
		location	varchar(32) NOT NULL,
		service		varchar(32) NOT NULL,
		instance	varchar(32) NOT NULL,
		uri		varchar(1024) NOT NULL,
		framework	varchar(32) NOT NULL,
		product		varchar(32) NOT NULL,
		method		varchar(16) NOT NULL,
		pathname	varchar(1024) NOT NULL,
		tstamp		smalldatetime NOT NULL,
		isvisible	tinyint NOT NULL,
		status		varchar(32) NOT NULL
	)
	CREATE UNIQUE INDEX i_LogSource ON dbo.LogSource (location, service, instance, product)
END
GO

IF OBJECT_ID('dbo.weblogAll') IS NULL
CREATE TABLE dbo.weblogAll (
	yy		smallint NOT NULL,
	mm		tinyint NOT NULL,
	dd		tinyint NOT NULL,
	hh		tinyint NOT NULL,
	mi		tinyint NOT NULL,
	ss		tinyint NOT NULL,
	seq		bigint IDENTITY NOT NULL,
	theTime		datetime NOT NULL,
	logID		int NOT NULL CONSTRAINT DF_weblogAll_logID DEFAULT 0,
	clientIP	varchar(256) NOT NULL CONSTRAINT DF_weblogAll_clientIP DEFAULT '0.0.0.0',
	op		char(8) NOT NULL CONSTRAINT DF_weblogAll_op DEFAULT '',
	command		varchar(7000) NOT NULL CONSTRAINT DF_weblogAll_command DEFAULT '',
	error		int NOT NULL CONSTRAINT DF_weblogAll_error DEFAULT 0,
	browser		varchar(2000) NOT NULL CONSTRAINT DF_weblogAll_browser DEFAULT '',
	isvisible	tinyint NOT NULL CONSTRAINT DF_weblogAll_isvisible DEFAULT 0,
	referer		varchar(500) NOT NULL CONSTRAINT DF_weblogAll_referer DEFAULT ' ',
	bytesOut	bigint NOT NULL CONSTRAINT DF_weblogAll_bytesOut DEFAULT 0,
	bytesIn		int NOT NULL CONSTRAINT DF_weblogAll_bytesIn DEFAULT 0,
	elapsed		int NOT NULL CONSTRAINT DF_weblogAll_elapsed DEFAULT -1,
	CONSTRAINT PK_weblogAll PRIMARY KEY CLUSTERED
		(yy DESC, mm DESC, dd DESC, hh DESC, mi DESC, ss DESC, seq DESC, theTime, logID)
)
GO

-- Test sources.  method 'TAIL' = the new loader (SPEC 4.2, name not
-- agreed yet).  logID 4 is lumberjack's own dsa001 row, for parity
-- checks; 3001-3003 are made-up IDs (free on lumberjack 2026-10-28).
MERGE dbo.LogSource AS t
USING (VALUES
	(4,    'V15',        'DR1',    '\\dsa001\LogFiles\W3SVC1858982642\'),
	(3001, 'idieswww01', 'W3SVC2', '\\idieswww01\LogFiles\W3SVC2\'),
	(3002, 'idieswww02', 'W3SVC2', '\\idieswww02\LogFiles\W3SVC2\'),
	(3003, 'idieswww03', 'W3SVC2', '\\idieswww03\LogFiles\W3SVC2\')
) AS s (logID, instance, product, pathname)
ON t.logID = s.logID
WHEN NOT MATCHED THEN
	INSERT (logID, location, service, instance, uri, framework, product, method, pathname, tstamp, isvisible, status)
	VALUES (s.logID, 'JHU', 'SKYSERVER', s.instance, '', 'IIS', s.product, 'TAIL', s.pathname,
		'2000-01-01', 1, 'ACTIVE');
GO

SELECT logID, instance, product, method, status, pathname FROM dbo.LogSource ORDER BY logID
GO
