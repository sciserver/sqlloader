--=====================================================================
-- spCopyLocalCasJobsSqlLogs2 + staging/state tables    (weblog, lumberjack)
--
-- Replacement for spCopyLocalCasJobsSqlLogs (step 5 of the
-- "Hourly Weblog Update2" Agent job).
--
-- The original deleted and re-inserted every CasJobs row since midnight,
-- every hour, because it copied jobs while they were still running and
-- had to fix them up later.  On 2026-10-07 that was ~253k deletes plus
-- ~253k inserts into SqlLogAll (1.2 TB, fully logged) for 22.7k jobs.
-- It also scanned all 82M rows of batch.jobs each hour (no index on
-- TimeStart), and lost every job started after ~20:00 local (UTC tstamp
-- compared to local TimeStart; 7-20% of each day's rows, since 2020 at
-- least).
--
-- WHY THE OLD DESIGN LOOKED LIKE THAT: it was copied from spCopyWebLogs
-- (2003), written for IIS log files.  Those have no row key, so "delete
-- the day and reload the day's file" was the only duplicate-proof option,
-- and IIS logs are UTC with UTC-midnight rollover, so UTC dates were right
-- there.  Neither holds for CasJobs: batch.jobs has a key (JobID), a
-- "finished" marker (TimeEnd), and LOCAL timestamps.  Don't copy the
-- web-log procs' date logic to a non-IIS source without checking both.
--
-- This version is INSERT-ONLY.  A job is copied once, when it finishes:
--
--  * Every finished job (status 3/4/5) has a TimeEnd, and does not change
--    after that.  Each run copies jobs with
--        @lastEnd < TimeEnd <= @upTo        (@upTo = local now - 5 min)
--    so each job lands in exactly one run's window.  The 5 minutes allows
--    for the TimeEnd update committing slightly after its timestamp.
--
--  * The remote read is a seek on the clustered key, JobID >= @lowJobID.
--    @lowJobID is the oldest job still unfinished at the last run
--    (ignoring jobs submitted over @maxJobDays ago, which are stuck),
--    less @jobIdMargin.  JobID is an identity in submit order, so all
--    unfinished jobs are at or above it.  Re-reading the margin is
--    harmless: the TimeEnd window stops duplicates.
--
--  * Times are compared in local time on both sides.  Assumes lumberjack
--    and the CasJobs server share a time zone (both UTC-4 on 2026-10-09).
--
--  * First run for a LogSource (no state row) is the cut-over: it deletes
--    the last @initHours of that source's rows, which the old proc may have
--    copied mid-run, and reloads finished jobs started in that window.  A
--    job running longer than @initHours at cut-over can end up duplicated
--    (one stale "running" row from the old proc plus the final one).
--
-- @dryRun = 1 stages and reports, touching neither SqlLogAll, LogSource
-- nor the state table.
--=====================================================================
USE weblog
GO

-- Raw-ish copy of the jobs read from CasJobs this run.
IF OBJECT_ID('dbo.CasJobsSqlLogStage') IS NOT NULL
	DROP TABLE dbo.CasJobsSqlLogStage
GO
CREATE TABLE dbo.CasJobsSqlLogStage (
	JobID		bigint NOT NULL PRIMARY KEY,
	TimeSubmit	datetime NULL,
	TimeEnd		datetime NULL,
	yy		smallint NULL,
	mm		tinyint NULL,
	dd		tinyint NULL,
	hh		tinyint NULL,
	mi		tinyint NULL,
	ss		tinyint NULL,
	theTime		datetime NULL,
	clientIP	varchar(256) NOT NULL,
	server		varchar(32) NOT NULL,
	dbname		varchar(32) NULL,
	elapsed		real NOT NULL,
	[rows]		bigint NOT NULL,
	statement	varchar(8000) NULL,
	error		int NOT NULL
)
GO

-- Where each LogSource got to.  Kept apart from LogSource.tstamp, which
-- other procs read and which stays "last run, UTC".
IF OBJECT_ID('dbo.CasJobsCopyState') IS NULL
CREATE TABLE dbo.CasJobsCopyState (
	logID		int NOT NULL PRIMARY KEY,
	lastEnd		datetime NOT NULL,	-- local; jobs ending at/before this are copied
	lowJobID	bigint NOT NULL,	-- next run reads JobID >= this
	lastRunUtc	datetime NOT NULL
)
GO

CREATE OR ALTER PROCEDURE dbo.spCopyLocalCasJobsSqlLogs2
	@lagMinutes  int = 5,		-- don't copy jobs that ended this recently
	@maxJobDays  int = 4,		-- unfinished jobs older than this are treated as stuck
	@jobIdMargin int = 1000,	-- extra JobIDs re-read below the low-water mark
	@initHours   int = 12,		-- cut-over window, first run only
	@batchSize   int = 2000,	-- rows per DELETE/INSERT batch
	@dryRun      bit = 0		-- 1 = stage and report only
AS
----------------------------------------------------------
--/H Copies finished CasJobs jobs into SqlLogAll, once each
--/T For each ACTIVE TSQL CasJobs LogSource, reads jobs from the
--/T low-water JobID up, and inserts those that finished since
--/T the last run.  Insert-only after the first (cut-over) run.
--/T Times: CasJobs TimeStart/TimeEnd are LOCAL time, so all cutoffs
--/T here use GETDATE(), not GETUTCDATE() (unlike the web-log procs,
--/T whose IIS sources are UTC).  LogSource.tstamp stays UTC.
--/T A job appears only after it finishes (up to the queue limit late).
----------------------------------------------------------
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	DECLARE @nowUtc datetime = GETUTCDATE(),
		@upTo datetime = DATEADD(minute, -@lagMinutes, GETDATE()),
		@logID int, @pathname varchar(1000), @uri varchar(1000),
		@requestor varchar(32),
		@lastEnd datetime, @lowJobID bigint, @isInit bit,
		@from datetime,		-- cut-over only: reload jobs started at/after this
		@newLow bigint, @maxJobID bigint,
		@cmd nvarchar(max), @staged int, @toInsert int, @toDelete int,
		@rc int, @fromID bigint, @maxID bigint

	DECLARE src CURSOR LOCAL FAST_FORWARD FOR
		SELECT logID, pathname, uri
		FROM   LogSource
		WHERE  [service] = 'CasJobs' AND location = 'JHU' AND method = 'TSQL'
		  AND  isvisible = 1 AND status = 'ACTIVE'

	OPEN src
	FETCH NEXT FROM src INTO @logID, @pathname, @uri
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @requestor = ' ' + @uri + ' '
		SELECT @lastEnd = lastEnd, @lowJobID = lowJobID
		FROM   dbo.CasJobsCopyState WHERE logID = @logID
		SET @isInit = CASE WHEN @@ROWCOUNT = 0 THEN 1 ELSE 0 END

		IF @isInit = 1
		BEGIN
			-- Cut-over: start a generous JobID range back from the newest job.
			SET @from = DATEADD(hour, -@initHours, @upTo)
			SET @lastEnd = @from
			SET @cmd = N'SELECT @maxJobID = MAX(JobID) FROM ' + @pathname
			EXEC sp_executesql @cmd, N'@maxJobID bigint OUTPUT', @maxJobID = @maxJobID OUTPUT
			SET @lowJobID = @maxJobID - 100000	-- ~2-4 days of jobs
		END

		------------------------------------------------------
		-- 1. Read from CasJobs into staging.  Clustered seek on JobID;
		--    only unfinished jobs and jobs that ended since @lastEnd.
		--    No locks on SqlLogAll are held while this runs.
		TRUNCATE TABLE dbo.CasJobsSqlLogStage

		SET @cmd = N'INSERT dbo.CasJobsSqlLogStage (JobID, TimeSubmit, TimeEnd,
			yy, mm, dd, hh, mi, ss, theTime, clientIP, server, dbname,
			elapsed, [rows], statement, error)
		SELECT JobID, TimeSubmit, TimeEnd,
			DATEPART(yyyy, TimeStart), DATEPART(mm, TimeStart), DATEPART(dd, TimeStart),
			DATEPART(hh, TimeStart), DATEPART(mi, TimeStart), DATEPART(ss, TimeStart),
			TimeStart,
			ISNULL(ip, '' ''),
			ISNULL(hostIP, '' ''),
			CASE WHEN target LIKE ''DR%'' THEN ''Best'' + target ELSE target END,
			ISNULL(CASE WHEN DATEDIFF(ss, TimeStart, TimeEnd) < 80000
				THEN DATEDIFF(ms, TimeStart, TimeEnd) / 1000.0
				ELSE DATEDIFF(ss, TimeStart, TimeEnd) END, 0),
			COALESCE([rows], 99999999),
			SUBSTRING(query, 1, 7950),
			CASE WHEN status = 4 THEN 1 ELSE 0 END
		FROM ' + @pathname + N'
		WHERE JobID >= @lowJobID
		  AND (TimeEnd IS NULL OR TimeEnd > @lastEnd)'

		EXEC sp_executesql @cmd,
			N'@lowJobID bigint, @lastEnd datetime',
			@lowJobID = @lowJobID, @lastEnd = @lastEnd
		SET @staged = @@ROWCOUNT

		-- Next run's low-water mark: oldest job not finished by @upTo,
		-- ignoring stuck ones.  With nothing running, the newest job read.
		SELECT @newLow = MIN(JobID) FROM dbo.CasJobsSqlLogStage
		WHERE  (TimeEnd IS NULL OR TimeEnd > @upTo)
		  AND  TimeSubmit >= DATEADD(day, -@maxJobDays, @upTo)
		IF @newLow IS NULL
			SELECT @newLow = MAX(JobID) FROM dbo.CasJobsSqlLogStage
		SET @newLow = ISNULL(@newLow - @jobIdMargin, @lowJobID)
		IF @newLow < @lowJobID SET @newLow = @lowJobID		-- never move backwards

		-- From here on staging holds only the rows to insert: finished in
		-- this run's window, and actually started.
		DELETE dbo.CasJobsSqlLogStage
		WHERE  NOT (TimeEnd > @lastEnd AND TimeEnd <= @upTo AND theTime IS NOT NULL
			    AND (@isInit = 0 OR theTime >= @from))
		SET @toInsert = @staged - @@ROWCOUNT

		IF @dryRun = 1
		BEGIN
			SET @toDelete = 0
			IF @isInit = 1
				SELECT @toDelete = COUNT_BIG(*) FROM SqlLogAll
				WHERE  ((yy > YEAR(@from)) OR (yy = YEAR(@from) AND mm > MONTH(@from))
					OR (yy = YEAR(@from) AND mm = MONTH(@from) AND dd >= DAY(@from)))
				  AND  theTime >= @from AND logID = @logID

			SELECT	@logID AS logID, @isInit AS isCutOver,
				@lowJobID AS readFromJobID, @lastEnd AS afterTimeEnd, @upTo AS upToTimeEnd,
				@staged AS rowsRead, @toDelete AS rowsToDelete, @toInsert AS rowsToInsert,
				@newLow AS nextLowJobID
		END
		ELSE
		BEGIN
			------------------------------------------------------
			-- 2. Write.  One short transaction, batches below the
			--    5000-lock escalation threshold.
			BEGIN TRAN

			IF @isInit = 1
			BEGIN
				SET @rc = 1
				WHILE @rc > 0
				BEGIN
					DELETE TOP (@batchSize) SqlLogAll
					WHERE  ((yy > YEAR(@from)) OR (yy = YEAR(@from) AND mm > MONTH(@from))
						OR (yy = YEAR(@from) AND mm = MONTH(@from) AND dd >= DAY(@from)))
					  AND  theTime >= @from AND logID = @logID
					SET @rc = @@ROWCOUNT
				END
			END

			SET @fromID = 0
			WHILE 1 = 1
			BEGIN
				SELECT @maxID = MAX(JobID) FROM (SELECT TOP (@batchSize) JobID
					FROM dbo.CasJobsSqlLogStage WHERE JobID > @fromID ORDER BY JobID) b
				IF @maxID IS NULL BREAK

				INSERT SqlLogAll (yy, mm, dd, hh, mi, ss, theTime, logID,
					clientIP, requestor, server, dbname, access, elapsed, busy, [rows],
					statement, error, errorMessage, isvisible)
				SELECT	yy, mm, dd, hh, mi, ss, theTime, @logID,
					clientIP, @requestor, server, ISNULL(dbname, ''), 'casjobs', elapsed, 0, [rows],
					ISNULL(statement, ''), error, ' ', 1
				FROM	dbo.CasJobsSqlLogStage
				WHERE	JobID > @fromID AND JobID <= @maxID

				SET @fromID = @maxID
			END

			IF @isInit = 1
				INSERT dbo.CasJobsCopyState (logID, lastEnd, lowJobID, lastRunUtc)
				VALUES (@logID, @upTo, @newLow, @nowUtc)
			ELSE
				UPDATE dbo.CasJobsCopyState
				SET    lastEnd = @upTo, lowJobID = @newLow, lastRunUtc = @nowUtc
				WHERE  logID = @logID

			-- Kept for anything else that reads it: last run, UTC.
			UPDATE LogSource SET tstamp = @nowUtc WHERE logID = @logID

			COMMIT
		END

		FETCH NEXT FROM src INTO @logID, @pathname, @uri
	END
	CLOSE src
	DEALLOCATE src

	IF @dryRun = 0
		TRUNCATE TABLE dbo.CasJobsSqlLogStage
END
GO
