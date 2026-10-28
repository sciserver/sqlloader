--=====================================================================
-- bcpweblog: tables and procs for the Python loader    (SPEC 4.3, 4.6)
--
-- Run with sqlcmd against the weblog database (or bcpweblog_test):
--     sqlcmd -S <server> -E -C -b -d <db> -i bcpweblog_schema.sql
-- Needs weblogAll and LogSource to exist already (on sdss4c, run
-- bcpweblog_test_setup.sql first).
--
-- Rerunnable: tables are created only if missing (never dropped, so a
-- redeploy can't lose offsets or staged rows); procs are CREATE OR ALTER.
--
-- How a run uses these (one run = one bcpweblog.py invocation):
--
--   1. sqlcmd: EXEC spStartWeblogRun 'incremental' -> runID
--   2. bcp the parsed rows into weblogStage and the new per-file offsets
--      into LogFileStateStage, every row tagged with that runID
--   3. sqlcmd: EXEC spLoadWeblogStage @runID     -> one transaction:
--      weblogAll += rows, LogFileState := offsets, LogSource.tstamp,
--      staged rows of this run removed, LoadRun marked 'loaded'
--
-- Rows and offsets commit together, so a failed run changes nothing and
-- the next run rereads the same bytes: no gaps, no duplicates.
--
-- WHY runID: the staging tables are shared.  Tagging rows by run lets a
-- backfill and the hourly run stage at the same time without mixing, and
-- lets spStartWeblogRun clear what a killed run left behind (bcp done,
-- proc never called) instead of the next run loading it.
--
-- Backfill (@replaceFrom/@replaceTo): the proc first deletes those days
-- from weblogAll for the run's logIDs (in batches, outside the
-- transaction), then loads.  The loader must stage only rows dated
-- inside that range; the proc checks and fails otherwise.  If the load
-- fails after the delete, rerunning the backfill repairs it.
--=====================================================================
SET NOCOUNT ON
GO
PRINT 'bcpweblog_schema.sql on ' + @@SERVERNAME + '.' + DB_NAME()
IF OBJECT_ID('dbo.weblogAll') IS NULL OR OBJECT_ID('dbo.LogSource') IS NULL
	THROW 50000, 'weblogAll / LogSource not found: wrong database?', 1
GO

-- One row per loader run.  The run log: what ran, when, and what it loaded.
IF OBJECT_ID('dbo.LoadRun') IS NULL
CREATE TABLE dbo.LoadRun (
	runID		int IDENTITY NOT NULL CONSTRAINT PK_LoadRun PRIMARY KEY,
	mode		varchar(16) NOT NULL,			-- incremental | backfill
	host		nvarchar(128) NOT NULL CONSTRAINT DF_LoadRun_host DEFAULT HOST_NAME(),
	started		datetime2(0) NOT NULL CONSTRAINT DF_LoadRun_started DEFAULT SYSUTCDATETIME(),
	finished	datetime2(0) NULL,
	status		varchar(16) NOT NULL CONSTRAINT DF_LoadRun_status DEFAULT 'started',
								-- started | loaded | failed | abandoned
	filesLoaded	int NULL,				-- LogFileState rows written
	rowsLoaded	bigint NULL,				-- weblogAll rows inserted
	rowsDeleted	bigint NULL,				-- backfill only
	message		nvarchar(2048) NULL
)
GO

-- Bytes consumed per log file.  byteOffset is always at a line start.
IF OBJECT_ID('dbo.LogFileState') IS NULL
CREATE TABLE dbo.LogFileState (
	logID		int NOT NULL,				-- LogSource.logID
	fileName	varchar(260) NOT NULL,			-- name within LogSource.pathname
	byteOffset	bigint NOT NULL,
	fields		varchar(2000) NULL,			-- #Fields list in effect at byteOffset
	fileDate	date NOT NULL,				-- from the name (yymm -> the 1st)
	updated		datetime2(0) NOT NULL,			-- UTC
	runID		int NOT NULL,				-- run that last moved it
	CONSTRAINT PK_LogFileState PRIMARY KEY (logID, fileName)
)
GO

-- Parsed rows, weblogTemp's columns plus runID and logID in front.
-- Column ORDER is the bcp -c field order (bcpweblog.py COLUMNS); empty
-- fields load the column default.
IF OBJECT_ID('dbo.weblogStage') IS NULL
BEGIN
	CREATE TABLE dbo.weblogStage (
		runID		int NOT NULL,
		logID		int NOT NULL,
		YY		int NOT NULL,
		MM		int NOT NULL,
		DD		int NOT NULL,
		Seq		bigint NOT NULL,		-- byte offset of the line in its file
		Second		char(8) NOT NULL CONSTRAINT DF_weblogStage_Second DEFAULT '',
		clientIP	varchar(256) NOT NULL CONSTRAINT DF_weblogStage_clientIP DEFAULT '0.0.0.0',
		op		char(8) NOT NULL CONSTRAINT DF_weblogStage_op DEFAULT '',
		command		varchar(7000) NOT NULL CONSTRAINT DF_weblogStage_command DEFAULT '',
		error		int NOT NULL CONSTRAINT DF_weblogStage_error DEFAULT 0,
		browser		varchar(2000) NOT NULL CONSTRAINT DF_weblogStage_browser DEFAULT '',
		referer		varchar(500) NOT NULL CONSTRAINT DF_weblogStage_referer DEFAULT ' ',
		bytesOut	bigint NOT NULL CONSTRAINT DF_weblogStage_bytesOut DEFAULT 0,
		bytesIn		int NOT NULL CONSTRAINT DF_weblogStage_bytesIn DEFAULT 0,
		elapsed		int NOT NULL CONSTRAINT DF_weblogStage_elapsed DEFAULT 0
	)
	CREATE CLUSTERED INDEX CI_weblogStage ON dbo.weblogStage (runID)
END
GO

-- New offsets for the files a run read (only files whose offset moved).
IF OBJECT_ID('dbo.LogFileStateStage') IS NULL
CREATE TABLE dbo.LogFileStateStage (
	runID		int NOT NULL,
	logID		int NOT NULL,
	fileName	varchar(260) NOT NULL,
	byteOffset	bigint NOT NULL,
	fields		varchar(2000) NULL,
	fileDate	date NOT NULL,
	CONSTRAINT PK_LogFileStateStage PRIMARY KEY (runID, logID, fileName)
)
GO

--=====================================================================
-- spStartWeblogRun: open a run, return its runID.  Also clears staged
-- rows left by runs that never reached spLoadWeblogStage.
--=====================================================================
CREATE OR ALTER PROCEDURE dbo.spStartWeblogRun
	@mode		varchar(16),
	@staleHours	int = 12		-- a 'started' run older than this was killed
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	IF @mode NOT IN ('incremental', 'backfill')
		THROW 50001, 'spStartWeblogRun: @mode must be incremental or backfill', 1

	DECLARE @stale TABLE (runID int PRIMARY KEY)
	UPDATE dbo.LoadRun
		SET status = 'abandoned', finished = SYSUTCDATETIME(),
		    message = 'never loaded; staged rows removed by a later run'
		OUTPUT inserted.runID INTO @stale
		WHERE status = 'started'
		  AND started < DATEADD(hour, -@staleHours, SYSUTCDATETIME())
	DELETE s FROM dbo.weblogStage s JOIN @stale x ON x.runID = s.runID
	DELETE s FROM dbo.LogFileStateStage s JOIN @stale x ON x.runID = s.runID

	INSERT dbo.LoadRun (mode) VALUES (@mode)
	SELECT CAST(SCOPE_IDENTITY() AS int) AS runID
END
GO

--=====================================================================
-- spLoadWeblogStage: move one run's staged rows into weblogAll.
-- Same column rules as spCopyWebLogs: hh/mi/ss and theTime from Second,
-- anything after 'password=' cut off, isvisible = 0 for /collab URLs.
--=====================================================================
CREATE OR ALTER PROCEDURE dbo.spLoadWeblogStage
	@runID		int,
	@replaceFrom	date = NULL,		-- backfill: delete these days first
	@replaceTo	date = NULL,
	@deleteBatch	int = 100000
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	DECLARE @rows bigint, @files int, @deleted bigint = 0, @n int,
		@day date, @logID int, @msg nvarchar(2048)

	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM dbo.LoadRun WHERE runID = @runID AND status = 'started')
			THROW 50002, 'spLoadWeblogStage: no started run with this runID', 1
		IF (@replaceFrom IS NULL AND @replaceTo IS NOT NULL)
		   OR (@replaceFrom IS NOT NULL AND @replaceTo IS NULL)
		   OR @replaceFrom > @replaceTo
			THROW 50003, 'spLoadWeblogStage: give both @replaceFrom and @replaceTo, from <= to', 1

		IF @replaceFrom IS NOT NULL
		BEGIN
			-- Rows outside the range would duplicate days the delete didn't clear.
			IF EXISTS (SELECT 1 FROM dbo.weblogStage
					WHERE runID = @runID
					  AND DATEFROMPARTS(YY, MM, DD) NOT BETWEEN @replaceFrom AND @replaceTo)
				THROW 50004, 'spLoadWeblogStage: staged rows fall outside @replaceFrom..@replaceTo', 1

			-- One day and logID at a time, so each delete seeks the yy/mm/dd
			-- prefix of weblogAll's key; batches keep the log small.
			DECLARE days CURSOR LOCAL FAST_FORWARD FOR
				SELECT d.day, l.logID
				FROM (SELECT DISTINCT logID FROM dbo.weblogStage WHERE runID = @runID) l
				CROSS JOIN (SELECT DATEADD(day, v.n, @replaceFrom) AS day
					    FROM (SELECT TOP (DATEDIFF(day, @replaceFrom, @replaceTo) + 1)
							ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
						  FROM sys.all_objects) v) d
			OPEN days
			FETCH NEXT FROM days INTO @day, @logID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @n = 1
				WHILE @n > 0
				BEGIN
					DELETE TOP (@deleteBatch) dbo.weblogAll
						WHERE yy = YEAR(@day) AND mm = MONTH(@day) AND dd = DAY(@day)
						  AND logID = @logID
					SET @n = @@ROWCOUNT
					SET @deleted += @n
				END
				FETCH NEXT FROM days INTO @day, @logID
			END
			CLOSE days
			DEALLOCATE days
		END

		BEGIN TRANSACTION

		INSERT dbo.weblogAll WITH (TABLOCK)
			(yy, mm, dd, hh, mi, ss, theTime, logID, clientIP, op, command,
			 error, browser, isvisible, referer, bytesOut, bytesIn, elapsed)
		SELECT s.YY, s.MM, s.DD, t.hh, t.mi, t.ss,
			DATETIMEFROMPARTS(s.YY, s.MM, s.DD, t.hh, t.mi, t.ss, 0),
			s.logID, s.clientIP, s.op,
			CASE WHEN s.command LIKE '%password=%'
				THEN SUBSTRING(s.command, 1, PATINDEX('%password=%', s.command) + 8)
				ELSE s.command END,
			s.error, s.browser,
			CASE WHEN s.command LIKE '/collab%' THEN 0 ELSE 1 END,
			s.referer, s.bytesOut, s.bytesIn, s.elapsed
		FROM dbo.weblogStage s
		CROSS APPLY (SELECT CAST(SUBSTRING(s.Second, 1, 2) AS tinyint) AS hh,
				    CAST(SUBSTRING(s.Second, 4, 2) AS tinyint) AS mi,
				    CAST(SUBSTRING(s.Second, 7, 2) AS tinyint) AS ss) t
		WHERE s.runID = @runID
		SET @rows = @@ROWCOUNT

		UPDATE f
			SET byteOffset = s.byteOffset, fields = s.fields, fileDate = s.fileDate,
			    updated = SYSUTCDATETIME(), runID = @runID
			FROM dbo.LogFileState f
			JOIN dbo.LogFileStateStage s ON s.logID = f.logID AND s.fileName = f.fileName
			WHERE s.runID = @runID
		INSERT dbo.LogFileState (logID, fileName, byteOffset, fields, fileDate, updated, runID)
			SELECT s.logID, s.fileName, s.byteOffset, s.fields, s.fileDate, SYSUTCDATETIME(), @runID
			FROM dbo.LogFileStateStage s
			WHERE s.runID = @runID
			  AND NOT EXISTS (SELECT 1 FROM dbo.LogFileState f
					  WHERE f.logID = s.logID AND f.fileName = s.fileName)
		SELECT @files = COUNT(*) FROM dbo.LogFileStateStage WHERE runID = @runID

		-- tstamp = "this source was read", as before.  It moves even when no
		-- rows were found; check LoadRun / weblogAll rows, not tstamp.
		UPDATE dbo.LogSource SET tstamp = GETUTCDATE()
			WHERE logID IN (SELECT logID FROM dbo.LogFileStateStage WHERE runID = @runID
					UNION SELECT logID FROM dbo.weblogStage WHERE runID = @runID)

		DELETE dbo.weblogStage WHERE runID = @runID
		DELETE dbo.LogFileStateStage WHERE runID = @runID

		UPDATE dbo.LoadRun
			SET status = 'loaded', finished = SYSUTCDATETIME(),
			    filesLoaded = @files, rowsLoaded = @rows, rowsDeleted = @deleted
			WHERE runID = @runID

		COMMIT
		SELECT @runID AS runID, @files AS filesLoaded, @rows AS rowsLoaded, @deleted AS rowsDeleted
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK
		IF CURSOR_STATUS('local', 'days') >= -1
		BEGIN
			IF CURSOR_STATUS('local', 'days') >= 0 CLOSE days
			DEALLOCATE days
		END
		SET @msg = LEFT(CONCAT('error ', ERROR_NUMBER(), ' line ', ERROR_LINE(), ': ', ERROR_MESSAGE()), 2048)
		-- The run's staged rows go too: the next run rereads from the old offsets.
		DELETE dbo.weblogStage WHERE runID = @runID
		DELETE dbo.LogFileStateStage WHERE runID = @runID
		UPDATE dbo.LoadRun
			SET status = 'failed', finished = SYSUTCDATETIME(), rowsDeleted = @deleted, message = @msg
			WHERE runID = @runID AND status = 'started';
		THROW
	END CATCH
END
GO
