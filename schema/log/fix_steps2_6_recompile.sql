--=====================================================================
-- "Hourly Weblog Update2" (lumberjack): seek instead of scan in steps 2 and 6.
-- Fixes #0 and #1 in lumberjack_steps1_2_findings.md.
--
--   step 2  spCopySqlLogs        DELETE SqlLogAll ... gets a yy/mm/dd
--                                predicate + OPTION (RECOMPILE).
--                                Measured (logID 2177): 252,491 -> 117 reads.
--   step 6  spUpdateTrafficStats the SqlLogAll hourly count gets
--                                OPTION (RECOMPILE).
--                                Measured: ~120 GB full index scan -> 37k reads,
--                                0.7 s.  This scan runs at :13-:17, which is
--                                when the turblog particlecount blocking happens.
--
-- Nothing else in either proc changes; same rows deleted, same counts.
-- RECOMPILE costs about a second of compile per run, which is nothing next
-- to the scans.
--
-- Run section 1, check the output, then run section 2 between :20 and :55
-- (the job runs :00 to about :17).  After the next run, use section 3.
--
-- ROLLBACK: run section 4.  It puts back the exact text deployed before
-- this change (spCopySqlLogs 2018-11-14, spUpdateTrafficStats 2013-06-18).
--=====================================================================
USE weblog
GO

---------------------------------------------------------------
-- 1. Look first.
--    a) Both procs must still be the versions this script was written
--       against.  If a checksum differs, STOP: someone changed the proc,
--       and section 4 would no longer be a true rollback.
SELECT name, modify_date,
       checksum(OBJECT_DEFINITION(object_id)) AS cks,
       CASE name WHEN 'spCopySqlLogs'        THEN 238352324
                 WHEN 'spUpdateTrafficStats' THEN 2029706600 END AS expected_cks
FROM   sys.procedures
WHERE  name IN ('spCopySqlLogs', 'spUpdateTrafficStats')
--    b) The job must not be running (want 0 rows).
SELECT j.name, a.start_execution_date
FROM   msdb.dbo.sysjobactivity a
JOIN   msdb.dbo.sysjobs j ON j.job_id = a.job_id
WHERE  j.name = 'Hourly Weblog Update2'
  AND  a.session_id = (SELECT max(session_id) FROM msdb.dbo.syssessions)
  AND  a.start_execution_date IS NOT NULL AND a.stop_execution_date IS NULL
--    c) Baseline: step 2 and step 6 durations over the last 24 runs.
SELECT h.step_id, count(*) AS runs,
       avg((h.run_duration/10000)*3600 + (h.run_duration/100%100)*60 + h.run_duration%100) AS avg_s,
       max((h.run_duration/10000)*3600 + (h.run_duration/100%100)*60 + h.run_duration%100) AS max_s
FROM   msdb.dbo.sysjobhistory h
JOIN   msdb.dbo.sysjobs j ON j.job_id = h.job_id
WHERE  j.name = 'Hourly Weblog Update2' AND h.step_id IN (2, 6)
  AND  msdb.dbo.agent_datetime(h.run_date, h.run_time) > dateadd(hour, -24, getdate())
GROUP BY h.step_id
GO

---------------------------------------------------------------
-- 2. Deploy.  Remove the /* and */ lines to run it.
/*
ALTER PROCEDURE [dbo].[spCopySqlLogs] AS
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
				-- 2026-10-16: also match on the yy/mm/dd key columns, so the delete seeks
				-- instead of reading every row this logID has ever logged.
				AND (    yy > datepart(yyyy,@tStamp)
				     or (yy = datepart(yyyy,@tStamp) and mm > datepart(mm,@tStamp))
				     or (yy = datepart(yyyy,@tStamp) and mm = datepart(mm,@tStamp) and dd >= datepart(dd,@tStamp)) )
			OPTION (RECOMPILE)	-- needed: without it the yy/mm/dd seek is not used
 	
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
					-- print 'updated ' + @pathname
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
	--EXEC spCopyLocalCasJobsSqlLogs
    --===========================================================
    -- weblog copy is complete.
    --===========================================================
    end

GO

--
ALTER PROCEDURE spUpdateTrafficStats AS
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
    	INSERT trafficBase (yy, mm, dd, hh, hits, English, German, Hungarian, Japanese, Spanish, Portuguese, Project,SkyServer, SkyService, SQL) 
	SELECT yy, mm, dd, hh , 
		count(*) as hits, 
		sum(case when command   like '%/en/%'     then 1 else 0 end),
		sum(case when command   like '%/de/%'     then 1 else 0 end),
		sum(case when command   like '%/hu/%'     then 1 else 0 end),
		sum(case when command   like '%/jp/%'     then 1 else 0 end),
		sum(case when command   like '%/sp/%'     then 1 else 0 end),
		sum(case when command   like '%/pt/%'     then 1 else 0 end),
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
	-- 2026-10-16: RECOMPILE lets this seek on the clustered yy/mm/dd key; without it
	-- the plan scans all of I_SQLlogAll_LogID (~120 GB) every hour.
	OPTION (RECOMPILE)
	
	----------------------------------------------------
	-- update the timestamp of the most recent traffic update
    	UPDATE LogSource set tstamp = @newDate
	 WHERE  service = 'TRAFFIC' and method = 'TSQL'
    ---------------------------------------------------------
    --completion message
    PRINT '*** Traffic Update completed succesfully'
end  

GO
*/

---------------------------------------------------------------
-- 3. Verify, after the next hourly run.
--    a) Step durations since the change: step 2 was ~150-1500 s and
--       step 6 ~200 s.  Both should drop a lot.  Step 1 is unchanged (~640 s).
SELECT msdb.dbo.agent_datetime(h.run_date, h.run_time) AS started, h.step_id,
       (h.run_duration/10000)*3600 + (h.run_duration/100%100)*60 + h.run_duration%100 AS secs,
       h.run_status
FROM   msdb.dbo.sysjobhistory h
JOIN   msdb.dbo.sysjobs j ON j.job_id = h.job_id
WHERE  j.name = 'Hourly Weblog Update2' AND h.step_id IN (1, 2, 5, 6)
  AND  msdb.dbo.agent_datetime(h.run_date, h.run_time) > dateadd(hour, -3, getdate())
ORDER BY started, h.step_id
--    b) Step 6 still gets the right answer: trafficBase.sql for today
--       must match a fresh count (differences only in the current hour,
--       which is still loading).
DECLARE @d date = getutcdate()
SELECT t.hh, t.sql AS trafficBase_sql, s.n AS fresh_count, t.sql - s.n AS diff
FROM   trafficBase t
JOIN  (SELECT hh, count(*) AS n FROM SqlLogAll
       WHERE yy = year(@d) AND mm = month(@d) AND dd = day(@d)
       GROUP BY hh) s ON s.hh = t.hh
WHERE  t.yy = year(@d) AND t.mm = month(@d) AND t.dd = day(@d)
ORDER BY t.hh
OPTION (RECOMPILE)
--    c) Step 2 still logged no new connection failures beyond the four
--       known dead servers (SDSS3U, SDSS3V, SDSS4A, SDSS4I).
SELECT errorMsg, count(*) AS n, max(currentTime) AS last_seen
FROM   ErrorLog
WHERE  context = 'spCopySqlLogs' AND currentTime > dateadd(hour, -3, getdate())
GROUP BY errorMsg
--    d) turblog blocking at :13-:17: check sql-monitor's blocking trend for
--       lumberjack over the next day.  It was 35-650 events/day.
GO

---------------------------------------------------------------
-- 4. Rollback: the original text of both procs, exactly as deployed
--    before this change.  Remove the /* and */ lines to run it.
/*
ALTER PROCEDURE [dbo].[spCopySqlLogs] AS
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
					-- print 'updated ' + @pathname
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
	--EXEC spCopyLocalCasJobsSqlLogs
    --===========================================================
    -- weblog copy is complete.
    --===========================================================
    end

GO

--
ALTER PROCEDURE spUpdateTrafficStats AS
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
    	INSERT trafficBase (yy, mm, dd, hh, hits, English, German, Hungarian, Japanese, Spanish, Portuguese, Project,SkyServer, SkyService, SQL) 
	SELECT yy, mm, dd, hh , 
		count(*) as hits, 
		sum(case when command   like '%/en/%'     then 1 else 0 end),
		sum(case when command   like '%/de/%'     then 1 else 0 end),
		sum(case when command   like '%/hu/%'     then 1 else 0 end),
		sum(case when command   like '%/jp/%'     then 1 else 0 end),
		sum(case when command   like '%/sp/%'     then 1 else 0 end),
		sum(case when command   like '%/pt/%'     then 1 else 0 end),
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
*/
