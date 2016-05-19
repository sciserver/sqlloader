--=========================================================================
--   spSQLSupport.sql
--   2001-11-01 Alex Szalay
---------------------------------------------------------------------------
-- History:
--* 2001-12-02 Jim:  added comments, fixed things
--* 2001-12-24 Jim: Changed parsing in SQL stored procedures
--* 2002-05-10 Ani: Added "limit" parameter to spExecuteSQL,
--*		spSkyServerFormattedQuery, spSkyServerFreeFormQuery so
--*		that 1000-record limit on output can be turned off.
--* 2002-07-04 Jim: Added sql command loging to spExecSQL (statements go to weblog).
--* 2003-01-20 Ani: Added Tanu's changes to spSkyServerTables,
--*		spSkyServerDatabases, spSkyServerFunctions and spSkyServerFreeFormQuery
--* 2003-02-05 Alex: fixed URL construction in support functions
--* 2003-02-06 Ani: Removed "en/" from URLs so it will be compatible with all
--*		     subdirectories (e.g. v4).
--*		     Updated spSkyServerFunctions to include SPs.
--*		     Changed "imagingRoot" to "imaging" for image FITS URLs
--*		     Changed "spectroRoot" to "spectro" for spSpec URLs
--*		     Changed "1d_10" to "1d_20" for spSpec URLs
--* 2003-03-10 Ani: Updated spSkyServerColumns to be same as fDocColumns.
--* 2003-11-11 Jim: Added clientIP, access, webserver... to spExecuteSQL
--*		revectored spSkyServerFreeFormQuery to call spExecuteSQL 
--* 2004-08-31 Alex: changed replacei to fReplace everywhere to conform to naming
--* 2004-09-01 Nolan+Alex: added spExecuteSQL2
--* 2005-02-15 Ani: Added check for crawlers limiting them to x queries/min, 
--*            SQL code for this provided by Jim.
--* 2005-02-18 Ani: Commented out "SET @IOs = ..." line in spExecuteSQL and
--*            spExecuteSQL2 because it was cause arithmetic overflow errors
--*            on DR3 sites (PR #6367).
--* 2005-02-21 Ani: Applied permanent fix for PR #6367 by including casts to
--*            bigint for @@TOTAL_READ and @@TOTAL_WRITE.
--* 2005-02-25 Ani: Added minute-long window to check whether a given
--*            clientIP is submitting more than the max number of queries
--*            in spExecuteSQL.  This is to allow legitimate rapid-fire
--*            queries like RHL's skyserver lookup tables to work fine.
--* 2006-02-07 Ani: Added syntax check capability in spExecuteSql, and also
--*            replaced cr/lf with space/lf so line number can be displayed
--*            for syntax errors (see PR #6880).
--* 2006-03-10 Ani: Added spLogSqlStatement and spLogSqlPerformance for
--*            CasJobs to use.
--* 2007-01-01 Alex: separated out spSQLSupport
--* 2007-08-27 Ani: Added "system" parameter to spExecuteSQL to allow it
--*            to distinuguish queries submitted by CAS tools from user
--*            queries.  Without this, system queries often run into
--*            the max #queries/min limit.
--* 2008-04-21 Ani: Added "maxQueries" parameter to spExecuteSQL so that
--*            the client can pass the throttle value to it.
--* 2015-07-21 Sue: updated spExecuteSql and spExecuteSql2 to use "logger"
--*			   user to log queries to weblog db
--*            updated spExecuteSQL to remove ; when surrounded by spaces
--*
--* 2015-11-05 Sue: updated spExecuteSQL to add optional parameters for
--*	           controlling logging, filtering, and throttling behavior.		
--*
--* 2016-05-19 Sue: changed spExecuteSQL to take varchar(max)
--*					also added fReplaceMax to handle string replacement 
--*					for varchar(max)	
---------------------------------------------------------------------------
SET NOCOUNT ON;
GO 

--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fReplace' )
	DROP FUNCTION fReplace
GO
--
CREATE FUNCTION fReplace(@oldstr VARCHAR(8000), @pattern VARCHAR(1000), @replacement VARCHAR(1000))
------------------------------------------------
--/H Case-insensitve string replacement
------------------------------------------------
--/T Used by the SQL parser stored procedures.
------------------------------------------------
RETURNS varchar(8000) 
AS
BEGIN 
	-------------------------------------
	DECLARE @newstr varchar(8000);
	SET @newstr = '';
	IF (LTRIM(@pattern) = '') GOTO done;
	-----------------------------------
	DECLARE @offset int,
			@patlen int,
			@lowold varchar(8000),
			@lowpat varchar(8000);
	SET @lowold = LOWER(@oldstr);
	SET @lowpat = LOWER(@pattern);
	SET @patlen = LEN(@pattern);
	SET @offset = 0
	--
	WHILE (CHARINDEX(@lowpat,@lowold, 1) != 0 )
	BEGIN
		SET @offset	= CHARINDEX(@lowpat, @lowold, 1);
		SET @newstr	= @newstr + SUBSTRING(@oldstr,1,@offset-1) + @replacement;
		SET @oldstr	= SUBSTRING(@oldstr, @offset+@patlen, LEN(@oldstr)-@offset+@patlen);
		SET @lowold	= SUBSTRING(@lowold, @offset+@patlen, LEN(@lowold)-@offset+@patlen);
	END
	-----------------------------------------
done:	RETURN( @newstr + @oldstr);
END
GO

IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fReplaceMax' )
	DROP FUNCTION fReplaceMax
GO

CREATE FUNCTION fReplaceMax(@oldstr VARCHAR(max), @pattern VARCHAR(1000), @replacement VARCHAR(1000))
------------------------------------------------
--/H Case-insensitve string replacement for varchar(max)
------------------------------------------------
--/T Used by the SQL parser stored procedures.
------------------------------------------------
RETURNS varchar(max) 
AS
BEGIN 
	-------------------------------------
	DECLARE @newstr varchar(max);
	SET @newstr = '';
	IF (LTRIM(@pattern) = '') GOTO done;
	-----------------------------------
	DECLARE @offset int,
			@patlen int,
			@lowold varchar(max),
			@lowpat varchar(max);
	SET @lowold = LOWER(@oldstr);
	SET @lowpat = LOWER(@pattern);
	SET @patlen = LEN(@pattern);
	SET @offset = 0
	--
	WHILE (CHARINDEX(@lowpat,@lowold, 1) != 0 )
	BEGIN
		SET @offset	= CHARINDEX(@lowpat, @lowold, 1);
		SET @newstr	= @newstr + SUBSTRING(@oldstr,1,@offset-1) + @replacement;
		SET @oldstr	= SUBSTRING(@oldstr, @offset+@patlen, LEN(@oldstr)-@offset+@patlen);
		SET @lowold	= SUBSTRING(@lowold, @offset+@patlen, LEN(@lowold)-@offset+@patlen);
	END
	-----------------------------------------
done:	RETURN( @newstr + @oldstr);
END
GO



--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fIsNumbers' )
	DROP FUNCTION fIsNumbers
GO
-- 
CREATE FUNCTION fIsNumbers (@string varchar(8000), @start int, @stop int)
-----------------------------------------------------------------
--/H Check that the substring is a valid number.
--
--/T <br>fIsNumbers(string, start, stop) Returns 
--/T <LI>  -1: REAL (contains decimal point) ([+|-]digits.digits)
--/T <LI>   0: not a number
--/T <LI>   1: BIGINT    ([+|-] 19 digits)
--/T <br>
--/T <samp>  select dbo.fIsNumbers('123;',1,3); 
--/T <br>  select dbo.fIsNumbers('10.11;'1,5);</samp>
-----------------------------------------------------------------
RETURNS INT
AS BEGIN 
	DECLARE @offset int,		-- current offfset in string
		@char	char,		-- current char in string
		@dot	int,		-- flag says we saw a dot.
		@num	int;		-- flag says we saw a digit
	SET @dot = 0;			--
	SET @num = 0;			--
	SET @offset = @start;		-- 
	IF (@stop > len(@string)) RETURN 0;  -- stop if past end
	SET @char = substring(@string,@offset,1); -- handle sign
	IF(@char ='+' or @char='-') SET @offset = @offset + 1;
	------------------
	-- process number
	------------------
	WHILE (@offset <= @stop)			-- loop over digits
	BEGIN								-- get next char
		SET @char = substring(@string,@offset,1);
		IF (@char = '.') 				-- if a decimal point
		BEGIN 							-- reject duplicate
			IF (@dot = 1) RETURN 0;
			SET @dot = 1;	-- set flag
			SET @offset = @offset + 1;  -- advance
		END 		-- end dot case
	 	ELSE IF (@char<'0' or '9' <@char)  -- if not digit
			RETURN 0;					-- reject
		ELSE 							-- it's a digit
		BEGIN							-- advance
		   	SET @offset = @offset + 1;
			SET @num= 1;				-- set digit flag
		END 							-- end digit case
	END 								-- end loop
	----------------------------
	-- test for bigint overflow	
	----------------------------
	IF (@stop-@start > 19) RETURN 0;	-- reject giant numbers
	IF  (@dot = 0 and  @stop-@start >= 19 )
	BEGIN								-- if its a bigint
		IF ( ((@stop-@start)>19) or		-- reject if too big
			('9223372036854775807' > substring(@string,@start,@stop)))
		   RETURN 0;					--
	END 								-- end bigint overflow test
	IF (@num = 0) RETURN 0;				-- complain if no digits
	IF (@dot = 0) RETURN 1; 			-- number ok, is it an int 
	RETURN -1 ;							-- or a float?
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spExecuteSQL' )
	DROP PROCEDURE spExecuteSQL
GO
--
CREATE PROCEDURE [dbo].[spExecuteSQL] (@cmd VARCHAR(MAX), @limit INT = 1000, 
    @webserver      VARCHAR(64) = '',   -- the url
	@winname	VARCHAR(64) = '',   -- the windows name of the server
    @clientIP   VARCHAR(50)  = 0,   -- client IP address 
	@access		VARCHAR(64) = '',    -- subsite of site,  if 'collab' statement 'hidden'
	@system		TINYINT = 0,         -- 1 if this is a system query from a skyserver page 
	@maxQueries	SMALLINT = 60,		-- maximum number of queries per minute
	@log		BIT		 = 1,		-- 1 to log queries in Weblog DB, 0 to omit logging
	@filter		BIT		 = 1,		-- 1 to filter for potentially harmful SQL, 0 to omit filtering
	@throttle	BIT		 = 0		-- 1 to restrict users to @maxQueries per minute, 0 to omit throttling
) 
------------------------------------------------------------------------------- 
--/H Procedure to safely execute an SQL select statement 
------------------------------------------------------------------------------- 
--/T The procedure casts the string to lowercase (this could affect some search statements) 
--/T It rejects strings continuing semicolons; 
--/T It then discards duplicate blanks, xp_, sp_, fn_, and ms_ substrings. 
--/T we are guarding aginst things like "select dbo.xp_cmdshell('format c');" 
--/T Then, if the "limit" parameter is > 0 (true), we insist that the 
--/T   statement have a top x in it for x < 1000, or we add a TOP 1000 clause. 
--/T Once the SELECT statement is transformed, it is executed 
--/T and returns the answer set or an error message.   <br> 
--/T All the SQL statements are journaled into WebLog.dbo.SQLlog. 
--/T <samp>EXEC dbo.spExecuteSQL('Select count(*) from PhotoObj')</samp> 
------------------------------------------------------------------------------- 
AS 
 
        BEGIN 
        SET NOCOUNT ON 
        DECLARE @inputCmd varchar(7800)                 -- safe copy of command for log 
													    -- also, truncated to varchar(7800) for weblog db (why 7800??)
        SET 	@inputCmd = @cmd                            
        --      SET @cmd = LOWER(@cmd)+ ' ';            -- makes parsing easier 
        SET 	@cmd = @cmd + ' '; 
        DECLARE @oldCmd     VARCHAR (MAX);             -- temporary copy of command 
	DECLARE @error      INT;			-- error number
        DECLARE @errorMsg VARCHAR(100), @ipAddr VARCHAR(100);		-- error msg 
	DECLARE @serverName varchar(32);		-- name of this databaes server
	DECLARE @dbName     VARCHAR(32);		-- name of this database
	SET 	@serverName = @@servername;
	SELECT @dbname = [name] FROM master.dbo.sysdatabases WHERE dbid = db_id() 
        DECLARE @i          INT;                        -- token scan offset 
	DECLARE @isVisible  INT;			-- flag says sql is visible to internet queries
	SET @isVisible = 1;
	IF (UPPER(@access) LIKE '%COLLAB%') SET @isVisible = 0;  -- collab is invisible


	--==================================================================================
	-- throttle 
	--==================================================================================
	IF (@throttle = 1)
	BEGIN		
		-- Restrict users to a certain number of queries per minute to
		-- prevent crawlers from hogging the system.
	
		IF (@system = 0)	-- if not a system (internal) query from skyserver
			BEGIN

			DECLARE @ret INT, @nQueries INT
			SET @maxQueries = 60	-- max queries per minute limit.

		
		
			--check to see if RecentQueries exists (compatibility with older DR's)
			if (exists (
				select * from information_schema.tables 
				where table_name = 'RecentQueries' ))
			begin
			-- first delete elements that are older than the window sampled.
			-- RecentRequests will typically have 4 * @maxQueries at peak
			-- times (at a peak rate of 4 queries/second).
			DELETE RecentQueries
				WHERE lastQueryTime < DATEADD(ss,-60,CURRENT_TIMESTAMP)

			-- now check how many queries this IP submitted within the last minute.
			-- if more than @maxQueries, reject the query with an error message
			-- if not, insert IP into recent requests log and run query
				SELECT @nQueries=count(*) FROM RecentQueries WHERE ipAddr=@clientIP
					IF (@nQueries > @maxQueries)
					BEGIN
						SET @errorMsg = 'ERROR: Maximum ' + cast(@maxQueries as varchar(3))
					+ ' queries allowed per minute. Rejected query: '; 
						GOTO bottom; 
					END 
				ELSE
					INSERT RecentQueries VALUES (@clientIP, CURRENT_TIMESTAMP)
				end  -- if RecentQueries exists
			end -- IF (@system = 0)    -- not a system query
		
		END -- if (@throttle = 1) 
		--============================================================================
		--  end throttle 
		--============================================================================ 
		

		--============================================================================
		-- filter
		--============================================================================
		if (@filter = 1)
		BEGIN
			-- parse command to remove dangerous SQL, semi-colons, multiple statements, etc
			DECLARE @top varchar(20); 
			SET @top = ' top '+cast(@limit as varchar(20))+' ';                          
			-------------------------------------------------------------------------- 
			-- Remove potentially dangerous expressions from the string. 
			UNTIL:  BEGIN 
					SET @oldCmd = @cmd; 
					SET @cmd = dbo.fReplaceMax(@cmd, '.xp_',   '#'); -- discard extended SPs               
					SET @cmd = dbo.fReplaceMax(@cmd, '.sp_',   '#'); -- discard stored procedures 
					SET @cmd = dbo.fReplaceMax(@cmd, '.fn_',   '#'); -- discard functions 
					SET @cmd = dbo.fReplaceMax(@cmd, '.ms_',   '#'); -- discard microsoft extensions 
					SET @cmd = dbo.fReplaceMax(@cmd, '.dt_',   '#'); -- discard microsoft extensions 
					SET @cmd = dbo.fReplaceMax(@cmd, ' xp_',   '#'); -- discard extended SPs               
					SET @cmd = dbo.fReplaceMax(@cmd, ' sp_',   '#'); -- discard stored procedures 
					SET @cmd = dbo.fReplaceMax(@cmd, ' fn_',   '#'); -- discard functions 
					SET @cmd = dbo.fReplaceMax(@cmd, ' ms_',   '#'); -- discard microsoft extensions 
					SET @cmd = dbo.fReplaceMax(@cmd, ' dt_',   '#'); -- discard microsoft extensions 
					SET @cmd =      replace(@cmd, '  ' ,   ' '); -- discard duplicate spaces 
					SET @cmd =      replace(@cmd, '  ' ,   ' '); -- discard duplicate spaces 
					set @cmd = dbo.fReplaceMax(@cmd, CHAR(13),  ' '); --discard carraige return
					set @cmd = dbo.fReplaceMax(@cmd, CHAR(10),  ' '); --discard line feed
					SET @cmd=       replace(@cmd,0x0D0A,   0x200A);     -- replace cr/lf with space/lf 
					SET @cmd=       replace(@cmd,  0x09,   ' ');     -- discard tabs				
					SET @cmd =      replace(@cmd,   ' ; ',    '#'); -- discard semicolon
					SET @cmd =      replace(@cmd,   ';',    '#'); -- discard semicolon 
					END 
			IF (@cmd != @oldCmd) GOTO UNTIL;
			
			 declare @l int
			 set @l = len(@cmd)
			--------------------------------------------------------------------------      
				-- Insist that command is a SELECT statement or a syntax check
 			IF (CHARINDEX('set parseonly',LOWER(@cmd),1) = 1)
	 			BEGIN
					-- run the syntax check command and return
					EXEC (@cmd)
					IF (@errorMsg is null)
						SELECT 'Syntax is OK'
					RETURN
				END

			   IF (CHARINDEX('select ',LTRIM(LOWER(@cmd)),1) != 1) 
						BEGIN 
                			SET @errorMsg = 'error: must be a select statement: '; 
                			GOTO bottom; 
						END; 
				SET @i = CHARINDEX('select ',LOWER(@cmd),1) + 7; -- point just past it 
				--------------------------------------------------------------------------      
				-- limit the output to at most 1,000 rows. 
				IF (CHARINDEX('all ',LTRIM(LOWER(substring(@cmd,@i,100)))) = 1)      
						SET @i = CHARINDEX('all ',LOWER(@cmd),1) + 4; -- point just past it 
				IF (CHARINDEX('distinct ',LTRIM(LOWER(substring(@cmd,@i,100)))) = 1) 
						SET @i = CHARINDEX('distinct ',LOWER(@cmd),1) + 9; -- point just past it 
				IF (@limit > 0) 
				   BEGIN 
					 IF (CHARINDEX('top ',LTRIM(LOWER(substring(@cmd,@i,100)))) != 1)   -- if no limit specified  
						BEGIN 
						SET @cmd = STUFF(@cmd,@i,0, @top)  -- add one 
						END 
					 ELSE                                    -- a limit was included 
						BEGIN                           -- assure that it is less than 1000. 
						SET @i = CHARINDEX('top ',LOWER(@cmd),1) + 4 
						DECLARE @count int; 
						DECLARE @len int; 
						SET @i = @i + (LEN(substring(@cmd,@i,1000)) - LEN(LTRIM(substring(@cmd,@i,1000)))); 
						SET @len = CHARINDEX(' ',@cmd + ' ',@i) - @i; 
						IF (dbo.fIsNumbers(@cmd, @i, @i+@len-1) = 1 ) 
								SET @count = CAST(SUBSTRING(@cmd,@i,@len) as int); 
						IF ((@count is null) or (@count < 1 ) or (@count > @limit)) 
								SET @errorMsg = 'error: limit is '+ @top; 
						END     
				   END 
				---------------------------------------------------------------------------
				--------------------------------------------------------------------------- 
				
			-- preventing the execution of more than one select statement (with the exception of select statements that are inside nested queries)
			declare @j int
			SET @j = CHARINDEX('select ',LOWER(@cmd),7) -- point just past the first select
			if( @j > 0)
			begin
				UNTIL2:  
				BEGIN 
					if (SUBSTRING(@cmd,@j-2,2) = '( ' or SUBSTRING(@cmd,@j-1,1) = '(' )
						begin
							SET @j = CHARINDEX('select ',LOWER(@cmd),@j+7)
						end
					else
						begin
							set @cmd = stuff(@cmd,@j-1,1,'#')
							SET @j = CHARINDEX('select ',LOWER(@cmd),@j+7)
						end
							IF (@j > 0) GOTO UNTIL2; 
				END
			end
		end --if (@filter = 1)
		--==============================================================================
		-- end filter
		--==============================================================================
       
-- execute the command, returning the rows. 
bottom: 
	--==============================================================================
	-- execute and log
	--==============================================================================
	if (@log = 1) 
	begin	
							-- Insist that command is a SELECT statement or a syntax check
 			IF (CHARINDEX('set parseonly',LOWER(@cmd),1) = 1)
	 			BEGIN
					-- run the syntax check command and return
					--exec sp_executesql @cmd
					exec (@cmd)
					IF (@errorMsg is null)
						SELECT 'Syntax is OK'
					RETURN
				END
			
			IF (@errorMsg is null) -- if good 
			begin
 
			--- log the command if there is a weblog DB 
			-- variables to track and log SQL performance. 
				declare @startTime datetime, @endTime datetime  
				declare @busyTime bigint, @rows bigint, @IOs bigint 
				if (0 != (select count(*) from master.dbo.sysdatabases where name = 'weblog')) 
					begin 
						set @startTime = getUtcDate();
						set @busyTime = @@CPU_BUSY+@@IO_BUSY 
						set @IOs = cast(@@TOTAL_READ as bigint)+cast(@@TOTAL_WRITE as bigint)
						execute as login = 'logger'
						insert WebLog.dbo.SqlStatementLogUTC 
			values(@startTime,@webserver,@winName, @clientIP, 
					@serverName, @dbName, @access, @inputCmd, @isVisible) 
						revert;
					end --if weblog DB exists 
		


			--======================================================== 
			-- EXECUTE THE COMMAND 
			--EXEC sp_executesql @cmd                             -- return the data 
			exec (@cmd)
			select @rows = @@rowCount, @error = @@error
			------------------------------------------------------ 
			-- record the performance when (if) the command completes. 
			if (@startTime is not null) 
					begin 
					set @endTime = getUtcDate();
					EXECUTE AS login = 'logger'
					insert WebLog.dbo.SqlPerformanceLogUTC 
			values (@startTime,@webserver,@winName, @clientIP,
							datediff(ms, @startTime, @endTime)/1000.0,      -- elapsed time 
							((@@CPU_BUSY+@@IO_BUSY)-@busyTime)/1000.0,      -- busy time 
							@rows, @@procid, 0,'')                                          -- rows returned                
					revert;
			end 
                   
			end             -- end of good command case 
	-------------------------------------------------------------------------
	-- bad input command case
		ELSE                    -- if error 
		BEGIN
				IF (0 != (select count(*) from master.dbo.sysdatabases where name = 'weblog')) 
						begin 
						set @startTime = getUtcDate(); 
			EXECUTE AS login = 'logger'
			insert WebLog.dbo.SqlStatementLogUTC 
				values(@startTime,@webserver,@winName, @clientIP,  
			       		@serverName, @dbName, @access, @inputCmd, @isVisible) 
						insert WebLog.dbo.SqlPerformanceLogUTC   
				values(@startTime,@webserver,@winName, @clientIP,  
				0,0,0,@@procid, -1, @errorMsg)  
						end 
					SELECT @errorMsg + @cmd as error_message; -- return the error message 
			revert;
		END --error case
    
	end --if (@log = 1)
	else --if (@log = 0)
	begin
		--execute statement, do not log
		if (@errorMsg is null) -- good command case
		begin
			--======================================================== 
			-- EXECUTE THE COMMAND 
			-- EXEC sp_executesql @cmd
			exec(@cmd)                             -- return the data 
			select @rows = @@rowCount, @error = @@error
			------------------------------------------------------ 
		end --good command case
		
		else --bad command case
			SELECT @errorMsg + @cmd as error_message; -- return the error message 

	end --if (@log = 0)


END  --end spExecuteSQL
-------------------------------------------------------------------------------------- 

-------------------------------------------------------------------------------------- 

GO





--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spExecuteSQL2' )
	DROP PROCEDURE spExecuteSQL2
GO
--
CREATE PROCEDURE [dbo].[spExecuteSQL2](
	@cmd varchar(8000),
	@webserver varchar(64) = '',   -- the url
	@winname varchar(64)   = '',   -- the windows name of the server
	@clientIP varchar(16)  = '0',   -- client IP address
	@access varchar(64)    = ''    -- subsite of site,  if 'collab' statement 'hidden'
)
-------------------------------------------------------------------------------
--/H Procedure to safely execute an SQL select statement
-------------------------------------------------------------------------------
--/T The procedure runs and logs a query, but does not parse
--/T it. <br>
--/T See also spExecuteSQL
-------------------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON
	--
	DECLARE @error int,		 -- error number
		@errorMsg varchar(100),	 -- error msg
		@serverName varchar(32), -- name of this databaes server
		@dbName varchar(32),	 -- name of this database
		@isVisible int,		 -- flag says sql is visible to internet queries
		@startTime datetime,
		@endTime datetime,
		@busyTime bigint,
		@rows bigint,
		@IOs bigint
	--
	SET @isVisible = 1;
	SET @serverName = @@servername;
	SELECT @dbname = [name] FROM master.dbo.sysdatabases WHERE dbid = db_id();
	------------------------------------------------------------	
	IF (@errorMsg is null)		-- if good,
            BEGIN
		---------------------------------------------
            	--- log the command if there is a weblog DB
		-- variables to track and log SQL performance.
		----------------------------------------------
		if (0 != (select count(*) from master.dbo.sysdatabases where name = 'weblog'))
                  begin
			set @startTime = getUtcDate();
			set @busyTime = @@CPU_BUSY+@@IO_BUSY
                        set @IOs = cast(@@TOTAL_READ as bigint)+cast(@@TOTAL_WRITE as bigint)
			EXECUTE AS login = 'logger'
			insert WebLog.dbo.SqlStatementLogUTC 
				Values(@startTime,@webserver,@winName, @clientIP,
				@serverName, @dbName, @access, @cmd, @isVisible)
			revert;
		  end
		------------------------
		-- execute the command
		------------------------
		exec (@cmd)
		set @rows = @@rowCount
		-----------------------------------------------------------
		-- record the performance when (if) the command completes.
		-----------------------------------------------------------
		if (@startTime is not null)
                    begin
			set @endTime = getUtcDate();
			EXECUTE AS login = 'logger'
			insert WebLog.dbo.SqlPerformanceLogUTC
				values (@startTime,@webserver,@winName, @clientIP,
				datediff(ms, @startTime, @endTime)/1000.0,      -- elapsed time
				((@@CPU_BUSY+@@IO_BUSY)-@busyTime)/1000.0,      -- busy time
				@rows, @@procid, 0,'')				-- rows returned
		    revert;
			end
	    END            -- end of good command case
	-------------------------------------------------------------------------
	-- bad input command case
	ELSE                    -- if error
	    BEGIN
		IF (0 != (select count(*) from master.dbo.sysdatabases where name = 'weblog'))
		    begin
			set @startTime = getUtcDate();
			EXECUTE AS login = 'logger'
			insert WebLog.dbo.SqlStatementLogUTC
				values(@startTime,@webserver,@winName, @clientIP,
				@serverName, @dbName, @access, @cmd, @isVisible)
			insert WebLog.dbo.SqlPerformanceLogUTC
				values(@startTime,@webserver,@winName, @clientIP,
				0,0,0,@@procid, -1, @errorMsg)
		    end
               SELECT @errorMsg + @cmd as error_message; -- return the error message
				revert;
		END
	-------------------------------------------------------------------
END

GO






/*

 (1) have the sql.asp pass the following additonal  params to spExecuteSql()  
        client IP address       -- this allows us to correlate the query with other web log activity 
        webServer               -- the url of the website making this request (gives collab, collabpw, dr1, dr2, ... ) 

 (2) redefine the SQLstatement log to have the following fields 
      go from the two fields (theTime, sql) to the following 
 CREATE  TABLE SqlStatementLog ( 
        yy      int not null,   -- the year 
        mm      int not null,   -- the month 
        dd      int not null,   -- the day 
        hh      int not null,   -- the hour 
        mi      int not null,   -- the minute 
        ss      int not null,   -- the second 
     	seq     int identity(1,1)  -- uniquifier 
        clientIP  char(12)      not null default('',    -- ip address of client 
        WebServer varchar(32)   not null default('',    -- name of webserver   
        DB      varchar(32)     not null default(''),   -- name of database being queried 
	access  varchar(32) 	not null default(''),   -- the kind of access (collab, public,..)
        procID  int             not null default(0),    -- process ID used in cancel query 
        SQL     varchar(7000) not null default(''),             -- the query 
	isVisible bit,
        primary key (yy,mm,dd,hh,mm,ss,seq,clientIP) 
        ) 
*/


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

------------------------------------------------------------------------
PRINT '[spSQLSupport.sql]: SQL Support procs and functions created.'

