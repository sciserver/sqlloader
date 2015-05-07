--====================================================================
--   spNeighbor.sql
--   2004-08-30 Alex Szalay
----------------------------------------------------------------------
-- Moved here various routines from spFinish.
----------------------------------------------------------------------
-- History
--* 2004-08-30 Alex: Moved here spNeighbors and spBuildMatchTables
--* 2004-10-10 Jim+Alex: updated spBuildMatchTables
--* 2004-10-10 Alex+Jim: Tied into load framework to record messages. 
--*		Added code to drop/build indices and foreign keys. 
--*		Optimized triple computation. 
--* 2004-10-12  Jim: fix bug in matchhead computation
--*                 split spMatchBuild and spMatchBuildMiss.
--* 2004-10-15 Alex: separated Zone computation into spZoneCreate.
--* 2004-10-20 Jim: broke spBuildMatchTables into two: spBuildMatch
--*		and spMatchBuildMiss. 
--*             Improved MatchMiss to use a zone algorithm for orphans
--*		Compute Reds using MaskedObject table.
--* 2004-10-20 Alex: renamed spBuildMatch to spMatchBuild and
--*		spMatchBuildTables to spMatchBuildMiss.
--* 2004-11-11 Jim: bypass foreign key build at end of spBuildMatch.
--* 2004-11-12 Jim: added run2 to primary key of orphans in spMatchBuildMiss
--* 2004-11-26 Ani: Added spBuildMatchTables from Jim, need to integrate
--*                 this with the previous version of match table procs.
--* 2004-12-03 Ani: Removed spBuildMatchTables - Alex said Jim made a 
--*                 mistake.
--* 2004-12-04 Alex + Jim:  fixed "red object" computation in spMatchBuildMiss
--*               to build a "private" MaskedObjects table that only 
--*               shows mask-object pairs where the mask and object 
--*               are from different runs. 
--* 2005-01-21 Ani: Deleted first BEGIN TRANSACTION from spNeighbors since
--* 		  it was unmatched.
--* 2005-02-01 Alex: changed spMatchBuild to spMatchCreate for consistency,
--*		also updated spFinish. 
--* 2005-04-09 Jim, Maria:  Fixed two zone problems 
--*                        (1) type in (0, 3, 5, 6)
--*                        (2) objID1<objID2 means testing ra1>0 and ra2>0 is wrong
--* 2005-09-24 Ani: Reinstated commented out code for edges from previous
--*                 bug fix in spNeighbors.
--* 2005-10-03 Ani: Bumped up neoghbor search radius for RUNS DB to 10"
--*                 from 2", because the Match computation is apparently
--*                 not finding corresponding neighbors.  Also added a
--*                 check after the insert into Match table for 0 rows
--*                 inserted which would indicate missing neighbors, so
--*                 as to avoid an infinite loop of "adding x triples".
--* 2005-10-11 Ani: Changed all the spMatchBuild references to 
--*                 spMatchCreate, and added call to spMatchBuildMiss 
--*                 at the end of spMatchCreate.
--* 2005-10-11 Ani: Added "OPTION (MAXDOP 1)" for all update statemnents.
--* 2005-12-14 Jim: Cleaned up margins based on new understanding of 
--*                 distortion: abs(atan(theta/sqrt(cos(dec-theta)cos(dec+theta)))
--*                 (1) in spZoneCreate: dropped left margin from zone table and 
--*                     created #Alpha table and used it to create right margin. 
--*                 (2) in spNeighbors created #Alpha table and used as bias in 
--*                     bias test
--*                 (3) did similar things with orphan handling in spMatchBuildMiss
--* 2005-12-17 Jim: Added zone check to avoid duplicate hits in in orphan
--*                 computation.
--* 2006-10-19 Ani: Moved spMatchBuildMiss definition to before spMatchCreate
--*                 to avoid dependency error message.
--* 2006-10-26 Ani: Commented out debug messages from MatchBuildMiss because
--*                 they were filling up the log (too many of them).
--* 2007-08-17 Ani: Fixed bug in call to fRegionGetObjectsFromString, it
--*                 has a column called 'id' now, not 'objID' (PR #7365).
--* 2007-08-23 Ani: Fixed bug in spMatchBuildMiss - replace substring in
--*                 comment no longer looks for 'CAMCOL' (PR #7374).
--* 2007-08-22 Maria: Added input @zoneHeight in spZoneCreate to make
--*                 independent search radius and zoneHeight.
--*                 Adds function fGetAlpha. This function corrects the bias
--*                 computation in spZoneCreate which was missing sin(@theta).
--* 2007-08-22 Maria: spZoneCreate 
--*                 Uses SELECT * INTO Zone for the main part of the Zone. 
--*                 Buffer uses INSERT. This avoids too much logging.
--*                 Restore 2 arcsec distance match for RunsDB
--* 2007-08-22 Maria: spNeighbors 
--*                 Set @zoneHeight = 30" for 'best' and =15" for 'runs','targ'
--*                 Uses SELECT * INTO Neighbors for the first half of the
--*                 computation to avoid logging.
--*                 Uses the zoneZone table instead of the the WHILE loop
--* 2007-10-11 Ani: Split up insert into Match table from Neighbors into batched
--*                 transactions to avoid excessive log size increase (PR #7405).
--* 2007-10-11 Ani: Also changed 'flags' to 'miss' in Match insert.
--* 2007-10-11 Ani: Fixed minor errors in spMatchCreate.
--* 2007-10-11 Ani: Removed semicolons in spMatchCreate in Match insert.
--* 2008-03-21 Ani: Added exclusion of neighbors from different runs unless
--*                 they are more than 1" apart for RUNS DB.
--* 2008-04-03 Ani: Added 2 more params to spNeighbors that specify the
--*                 search radius and match mode, so it can be configured
--*                 to search for all neighbors in a small radius for
--*                 the building Match tables.
--* 2010-12-10 Ani: Removed Match procedures.
--* 2012-07-26 Ani: Capitalized neighbors table name in spNeighbors.
----------------------------------------------------------------------
SET NOCOUNT ON;
GO

--========================================================
IF  EXISTS (SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME = 'fGetAlpha' and ROUTINE_TYPE = 'FUNCTION')
DROP FUNCTION fGetAlpha
GO

CREATE FUNCTION fGetAlpha(@theta float, @dec float)
----------------------------------------------------------
--/H Compute alpha "expansion" of theta for a given declination
--  ------------------------------------------------------
--/T Declination and theta are in degrees. 
----------------------------------------------------------
RETURNS float
AS BEGIN 
	IF abs(@dec)+ @theta > 89.9 RETURN 180 -- it is a bit generous but this avoids
										   -- adding 1e-9 in the sqrt 
										   -- and in any case doesn't not affect SLOAN						
	RETURN(degrees(atan(abs(
			sin(radians(@theta)) / 
			sqrt(cos(radians(@dec - @theta)) * cos(radians(@dec + @theta))
		)))))
END 
GO

--=============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spZoneCreate' ) 
	DROP PROCEDURE spZoneCreate
GO
--
CREATE PROCEDURE spZoneCreate (
	@taskid int, 
	@stepid int,	
	@radius float,
	@zoneHeight float 
) 
-------------------------------------------------------------
--/H Organizes PhotoObj objects into the Zone table
--/A --------------------------------------------------------
--/T The table holds ALL primary/secondary objects. 
--/T The table contains duplicates of objects which are within @radius distance 
--/T of the 0|360 meridian.
--/T <p> Parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> radius float,   		-- radius in arcseconds
--/T <li> zoneHeight float,   	-- zoneHeight in arcsec
--/T <br>
--/T Sample call for a 2 arcseconds radius and a 1/2 arcminute zoneHeight <br>
--/T <samp> 
--/T <br> exec  spZoneCreate @taskid , @stepid, 2.0, 30.0;
--/T </samp> 
--/T <br>  
-------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @start datetime,
		@ret int,
		@err int,
		@msg varchar(1000);
	--
	SET @start = CURRENT_TIMESTAMP
	SET @err   = 0;

	---------------------------------------------
	-- save the zoneHeight if it does not exist
	---------------------------------------------
	IF EXISTS (select name from SiteConstants where name='zoneHeight')
		UPDATE SiteConstants
		SET value = str(@zoneHeight,20,15)
		WHERE name='zoneHeight'
	ELSE
		INSERT SiteConstants VALUES('zoneHeight',
			str(@zoneHeight,20,15),'zone height in arcsec');

	---------------------------------------------------
	DECLARE @theta float; -- neighborhood radius 
	SET @theta = @radius/3600.000; -- convert arcsec to degrees
	SET @zoneHeight = @zoneHeight/3600.000; -- convert arcsec to degrees

	---------------------------------------------------
	-- Create and populate zone table. Each zone is a 
	-- latitude (dec) band of the celestial sphere with a 
	-- height of @zoneHeight. All objects in that band [dec,dec+@theta) 
	-- are in that zone. In addition, we add each object 
	-- near the edge to the left or right margin, so 
	-- marginal objects are present twice (once with the 
	-- ra +/- 360, and once with ra).

	-- Zone consits of 3 steps. Each step is within a BEGIN/COMMIT TRANSACTION
		-- 1. Creates main body of the Zone with SELECT INTO (Not sure requires B/E T but so be it)
		-- 2. Adds one @theta buffer near 0,360 (on the 360 side)
		-- 3. Builds index and foreign key

	---------------------------------------------------
	EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'OK', 'Starting zone build';

	---------------------------------------------------
	-- drop all existing indices (fix this when load is incremental)
	---------------------------------------------------
	IF  EXISTS (SELECT TABLE_NAME 
				FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_NAME = 'Zone')
	BEGIN
	    EXEC spIndexDropSelection @taskid, @stepid, 'I,F,K', 'ZONE'
		DROP TABLE Zone
	END

	------------------------------------------------
	-- Each mode (1,2) object goes into a zone 
	-- (except non-objects like cosmic rays...)
	------------------------------------------------
    BEGIN TRANSACTION
	------------------------------------------------
	SELECT --count(*)
		cast(floor(([dec]+90.0)/@zoneHeight) as int) zoneID, 
		ra, [dec],objID, type, mode, 
		cx, cy, cz, cast (1 as tinyint) native -- its a native
	INTO Zone
	FROM photoObjAll
	WHERE TYPE IN (0, 3, 5, 6) -- unknown, galaxy, known, star
		-- not cosmic ray, defect, ghost, trail, or sky.
		AND mode IN (1,2)
	
	ALTER TABLE Zone  
			ALTER COLUMN ZoneID int NOT NULL -- The primary key constraint cannot 
											 -- be added if the column is NULL
	COMMIT TRANSACTION

	---------------------------------------------------------
	-- Precompute the “alpha” expansion for each zone based 
	-- on the specified radius. This local temp table will 
	-- be automatically dropped when sp_ completes. 
	-----------------------------------------------------
	--
	CREATE TABLE #Alpha(
				zoneID		int	   NOT NULL primary key,	
				alphaMax	float  NOT NULL					
	)
	--------------------------------------------------
	-- Builds the #Alpha Table
	--------------------------------------------------
	DECLARE @maxZone int, @minZone int, @zoneDec float;
	
	SET @minZone = 0;
	SET @maxZone =  floor(180.0/@zoneHeight);

	SET @zoneDec = @minZone * @zoneHeight -90;
	   
	WHILE @minZone < = @maxZone
	BEGIN   
		INSERT #Alpha VALUES (
				@minZone, 
				CASE WHEN (@zoneDec < 0) AND (ABS(@zoneDec) > ABS(@zoneDec + @zoneHeight))
				  THEN dbo.fGetAlpha(@theta, @zoneDec)
				  ELSE dbo.fGetAlpha(@theta, @zoneDec + @zoneHeight)
				END 
			)
		SET @minZone = @minZone + 1
		SET @zoneDec = @zoneDec + @zoneHeight
	END

	-----------------------------------------------------
	-- add half-open interval right margin  (one radius)
	-----------------------------------------------------
	--
    BEGIN TRANSACTION
	INSERT Zone 
	    select z.zoneID, 
		ra+360.0, [dec], objID, type, mode, 
		cx, cy, cz, 0 -- a visitor, not a native 
		from Zone z join #Alpha a on z.zoneID = a.zoneID
		where 0.0 < ra and ra < a.alphaMax
 
	SET @msg = 'Neighbors zone build time: '
		+ cast(dbo.fDatediffSec(@start,current_timestamp) as varchar(30)) 
		+ ' seconds'
	EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'OK', @msg;
	COMMIT TRANSACTION 

	----------------------------------------
	-- build all indexes for the Zone table 
	----------------------------------------
	BEGIN TRANSACTION
	SET @start = CURRENT_TIMESTAMP
	exec spIndexBuildSelection @taskid, @stepid, 'K,F,I', 'ZONE'
	SET @msg = 'Zone index and foreign key time: '
		+ cast(dbo.fDatediffSec(@start,current_timestamp) as varchar(30)) 
		+ ' seconds'
	EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'OK', @msg ;
	COMMIT TRANSACTION 
	------------------------------------------------------------------------------

	RETURN;
END
GO

--=============================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spNeighbors' ) 
	DROP PROCEDURE spNeighbors
GO
--
CREATE PROCEDURE spNeighbors (
	@taskid int, 
	@stepid int,
	@destinationType varchar(16),
	@destinationDB varchar(32),
	@radius float = 30.0,
	@matchMode tinyint = 1
) 
-------------------------------------------------------------
--/H Computes PhotoObj Neighbors based on nChild
--/A -----------------------------------------------------------
--/T Populate table of nearest neighbor object IDs for quicker 
--/T spatial joins. The table holds ALL star/galaxy objects within 
--/T 1/2 arcmin of each object. Typically each object has 7 such 
--/T neighbors in the SDSS data. If the destinationType is RUNS, 
--/T TARGET, or TILES, then the radius is 3 arcseconds. This is 
--/T the zoned algorithm. When complete, the neighbors and the 
--/T 'native' zone members can be copied to the destination DB.
--/T <p> Parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> destinationType int,   	-- 'best', 'runs','target', 'tiles'
--/T <li> destinationDB int,   		-- destination database name
--/T <li> radius float,			-- search radius in arcsec
--/T <li> matchMode tinyint		-- if true, include multiple
--/T                                    -- observations of same object
--/T                                    -- in its neighbors, so the
--/T                                    -- Match tables can be built 
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call for a 1/2 arcminute radius <br>
--/T <samp> 
--/T <br> exec  spNeighbors @taskid , @stepid, 'best', 'targetDB'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN  
	SET NOCOUNT ON;
	-----------------------------------------------------
	-- Build the neighbors table using a zone-algorithms.
	--  (1) build a zone table
	--  (2) add in the margin
	--  (3) Build 1/2 the neighbors table nested-loops-join of the zones
	--  (4) add in other 1/2
	--  (5) build the index
	-- Prints out times 
	-- This can all be done in parallel.
	--===================================================
	DECLARE @start datetime,
		@begin datetime,
		@ret int,
		@err int,
		@msg varchar(1000);
	--
	SET @start = CURRENT_TIMESTAMP
	SET @begin = @start
	SET @err   = 0;
	---------------------------------------------------
	SET @destinationType = lower(substring(@destinationType,1,4))
	-- compute radius depending on Destination DB type.
	DECLARE @theta float; -- neighborhood radius in degrees
	SET @theta = @radius / 3600.0;
	---------------------------------------------------
	-- if @theta not set then give error and exit
	IF @theta IS NULL
	    BEGIN
		SET @msg = 'spNeighbors parameter: "' + @destinationType 
			+ '" is not in {best, runs, target, tiles, plates}'
		EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'ERROR',@msg;
		RETURN (1);
	    END 
	SET @msg = 'Starting neighbors computation with a radius of ' 
			+ str(round(@radius,0 )) + ' arcSeconds '
	EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'OK', @msg;
	---------------------------------------------------
	-- Declaration and Initialization of global variables 
	DECLARE @notZero float		-- used to prevent division by zero
	SET	@notZero = 1e-9		--
	--
	DECLARE @zoneHeight float  	-- zone height in degrees (==@theta)
	SET @zoneHeight = CASE 
	    WHEN @destinationType = 'best' THEN 30.0 -- 30 arcseconds 
	    WHEN @destinationType in ('runs','targ') THEN  15.0 -- 15" 
										-- That the best performance is achieved 
										-- when @zoneHeight = @theta is a myth. 
										-- If zoneHeight small then the 
										-- performance is not so good.
	END

	--
	DECLARE @count bigint		-- count of records in Neighbors table
	SET 	@count = 0 		--
	--
	DECLARE @began datetime 
	SET 	@began  = @start
	--

	-------------------------
	-- build the Zone table
	-------------------------
	EXEC spZoneCreate @taskid, @stepid, @radius, @zoneHeight;

	SET @zoneHeight = @zoneHeight/3600.0 -- From here we need @zoneHeight in degrees
 	---------------------------------------------------
	--EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'WARNING', 'todo: populate foreigners table using the destination DB and Area';
	---------------------------------------------------
	-- Populate the neighbors table.
	-- Nested loop join zone table with itself -1, 0, +1 (zone).
	-- for the subtable, restrict RA +/- abs(atan(thta/sqrt(cos(dec-theta)cos(dec+theta))))
	--             also resrict outer object to not be marginal.
	--             also restrict dec
	-- 	       also restrict objID1 < objID2 so that we save 1/2 the work.
	-- 	       then do the distance calculation to get the arc distance
	---------------------------------------------------
	SET @start = CURRENT_TIMESTAMP

	BEGIN TRANSACTION
    --------------------------------------------------------------------
	IF  EXISTS (SELECT TABLE_NAME 
				FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_NAME = 'Neighbors')
	BEGIN
		EXEC spIndexDropSelection @taskid, @stepid, 'K,F', 'Neighbors';
		DROP TABLE Neighbors
	END
	COMMIT TRANSACTION
	
	--------------------------------------------------
	-- Builds the #zonesDef Table
	--------------------------------------------------
	CREATE TABLE #ZonesDef(
				zoneID		int NOT NULL,	
				decMin 		float  NOT NULL,	
				decMax 		float  NOT NULL		
	)
	DECLARE @maxZone int, @minZone int, @zoneDec float;
	
	SET @minZone = 0;
	SET @maxZone =  floor(180.0/@zoneHeight);

	SET @zoneDec = @minZone * @zoneHeight -90;
	   
	WHILE @minZone < = @maxZone
	BEGIN   
		INSERT #ZonesDef VALUES (
				@minZone, @zoneDec, @zoneDec + @zoneHeight
			)
		SET @minZone = @minZone + 1
		SET @zoneDec = @zoneDec + @zoneHeight
	END

	--------------------------------------------------
	-- Builds the #zoneZone table to map each zone to zones 
	-- which may have a cross match. 
	--------------------------------------------------
	CREATE TABLE #zoneZone (
		zoneID1	int,
		zoneID2	int,
		alphaMax	float,
		PRIMARY KEY(zoneID1,zoneID2)
	)

	DECLARE @zones int	
	SET @zones = ceiling(@theta/@zoneHeight)

	INSERT INTO #zoneZone 
		SELECT Z1.zoneID, Z2.zoneID,
		  CASE WHEN Z1.decMin < 0 AND (ABS(Z1.decMin) > ABS(Z1.decMin + @zoneHeight))
			    THEN dbo.fGetAlpha(@theta, Z1.decMin) 
				ELSE dbo.fGetAlpha(@theta, Z1.decMax) 
		  END 
		FROM #zonesDef Z1 JOIN #zonesDef Z2  
		  ON Z2.zoneID between Z1.zoneID - @zones AND Z1.zoneID + @zones

	----------------------------------------------------------------------------------
	-- the code is designed to allow zone sizes different from @theta
	-- zone = @r is optimal, but smaller/larger also works (smaller needs more zones)
	--  ^^ this is not always true, if the zoneheight is very small (few arcsec) 
	--     then the performance is very bad. 
	------------------------------------------------------------------------------------
	-- Loop over the zones, computing the neighbors for each one.
	--
	--                   ------
	--                  /  +n   \
	--                 ================ zone
	--                /           \
	--               |      0      |
	--                \           /
	--                ==================zone
	--                  \  -n    /
	--                   -------
	--
	-------------------------------------------------------------
	set @start  = current_timestamp			-- time each zone's construction
	IF @matchMode = 0
	    BEGIN
		-- we don't need matches of objects to itself in the neighbors
		SELECT 
		    o1.objID as objID, 			-- outer object
		    o2.objID as NeighborObjID,   	-- inner object
			2*DEGREES(ASIN(sqrt(			-- distance in arcMinutes
			    power(o1.cx-o2.cx,2)+
			    power(o1.cy-o2.cy,2)+
			    power(o1.cz-o2.cz,2)  )/2))*60 as distance,
				o1.type, o2.type neighborType,			-- type
				o1.mode, o2.mode neighborMode			-- mode
		INTO Neighbors
		FROM #zoneZone zz inner loop join zone o1 on zz.zoneID1 = o1.zoneID
				 inner loop join zone o2 	-- force a nested loops join
	  	    ON zz.zoneID2 = o2.zoneID and 
				o2.ra between o1.ra - zz.alphaMax and o1.ra + zz.alphaMax
	  	WHERE o1.objID < o2.objID	    -- do 1/2 the work now
		    -- don't need self-matches, so exclude neighbors from 
		    -- different runs unless they are more than 1" apart. 
		    -- this is important for RUNSDB, Stripe82DB etc.[ART]
		    and ( (((o1.objID / power(cast(2 as bigint),32)) & 0x0000FFFF) = 
		           ((o2.objID / power(cast(2 as bigint),32)) & 0x0000FFFF))
		        or
		          ((2*DEGREES(ASIN(sqrt(power(o1.cx-o2.cx,2)+
			    	power(o1.cy-o2.cy,2)+
			    	power(o1.cz-o2.cz,2))/2))*3600) > 1.0)
		        ) 
		    and (o1.native + o2.native) > 0		-- objects not both in margin 
		    and o2.dec between o1.dec - @theta and o1.dec + @theta	-- quick filter on dec
		    and 4.0*power(sin(radians(@theta/2.0)),2) >	-- careful distance filter 
			    power(o1.cx-o2.cx,2)+power(o1.cy-o2.cy,2)+power(o1.cz- o2.cz,2)
	    END
	ELSE		-- not RUNS DB
	    BEGIN
		SELECT 
		    o1.objID as objID, 			-- outer object
		    o2.objID as NeighborObjID,   	-- inner object
			2*DEGREES(ASIN(sqrt(			-- distance in arcMinutes
			    power(o1.cx-o2.cx,2)+
			    power(o1.cy-o2.cy,2)+
			    power(o1.cz-o2.cz,2)  )/2))*60 as distance,
				o1.type, o2.type neighborType,			-- type
				o1.mode, o2.mode neighborMode			-- mode
		INTO neighbors
		FROM #zoneZone zz inner loop join zone o1 on zz.zoneID1 = o1.zoneID
				 inner loop join zone o2 	-- force a nested loops join
	  	    ON zz.zoneID2 = o2.zoneID and 
				o2.ra between o1.ra - zz.alphaMax and o1.ra + zz.alphaMax
	  	WHERE o1.objID < o2.objID			    -- do 1/2 the work now
		    and (o1.native + o2.native) > 0		-- objects not both in margin 
		    and o2.dec between o1.dec - @theta and o1.dec + @theta	-- quick filter on dec
		    and 4.0*power(sin(radians(@theta/2.0)),2) >	-- careful distance filter 
			    power(o1.cx-o2.cx,2)+power(o1.cy-o2.cy,2)+power(o1.cz- o2.cz,2)
	    END
	set @msg = 'Compute neighbors: elapsed time for 1/2 the work (o1.objID < o2.objID) is ' 
		+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))  
		+ ' sec, generated ' + cast(rowcount_big() as varchar(30)) + ' rows'
	--
	exec spNewPhase @taskid, @stepid, 'Neighbors', 'OK', @msg ;
	--------------------------------------
	
	--
	BEGIN TRANSACTION
	SET @start = CURRENT_TIMESTAMP		-- time mirroring the neighbors table
	------------------------------------------------
	-- The prior statment just does objID < neighborObjID, 
	-- so now fill in the other half.
	------------------------------------------------
	INSERT Neighbors
	    SELECT NeighborObjID, objID, distance, 
		neighborType,[Type],
		neighborMode, Mode
		FROM  Neighbors 
	------------------------------------------------
	SET @count = 2 * rowcount_big();
	--
	SET @msg = 'elpased time for mirror neighbors is:  '  
		+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))  
		+ ' seconds. Total rows '+ cast(@count as varchar(30)) 
	--
	EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'OK', @msg ;
 	COMMIT TRANSACTION
	--
    BEGIN TRANSACTION
	----------------------------
	-- rebuild indices and foreign keys
	----------------------------
	SET @start = CURRENT_TIMESTAMP
	exec spIndexBuildSelection @taskid, @stepid, 'K,F', 'Neighbors'
	---------------------
	-- print log message
	---------------------
	SET @msg = 'elpased time for index and foreign key on Neighbors table is  ' 
		+ cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))  
		+ ' seconds. Total rows '+ cast(@count as varchar(30)) 
	EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'OK', @msg ;
	COMMIT TRANSACTION

	-----------------------------------------
	-- Record total time..
	SET @msg = 'Computed ' + cast(@count as varchar(20)) + ' neighbors in a total of ' 
			+ cast(dbo.fDatediffSec(@began, current_timestamp) as varchar(30))  
			+ ' seconds'  
	EXEC spNewPhase @taskid, @stepid, 'Neighbors', 'OK', @msg ;
	------------------------------------------------
	RETURN(0);
END	-- End spNeighbors()
GO



PRINT '[spNeighbor.sql]: Neighbor and Match creation procedures created'
GO

