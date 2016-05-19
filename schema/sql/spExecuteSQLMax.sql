--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spExecuteSQLMax' )
	DROP PROCEDURE spExecuteSQLMax
GO
--
CREATE PROCEDURE [dbo].[spExecuteSQLMax] (@cmd VARCHAR(MAX), @limit INT = 1000, 
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
			--EXEC sp_executesql @cmd
			exec(@cmd)                             -- return the data 
			select @rows = @@rowCount, @error = @@error
			------------------------------------------------------ 
		end --good command case
		
		else --bad command case
			SELECT @errorMsg + @cmd as error_message; -- return the error message 

	end --if (@log = 0)


END  --end spExecuteSQLMax
-------------------------------------------------------------------------------------- 

-------------------------------------------------------------------------------------- 
GO
--