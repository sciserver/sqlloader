--=================================================================================
--   spSector.sql
--   Jim Gray, Alex Szalay, Adrian Pope, Gyorgy Fekete, Jan-Feb 2004
--	 Major rewrite by Alex Szalay, 2007-06-07
-----------------------------------------------------------------------------------
--  SkyServer Sector creation code 
--
--  Creates procedures
--	spSectorCleanup				-- cleanup region etc tables for certain type
--	spSectorCreateWedges 		-- boolean intersections of tiles
--	spSectorCreateTileBoxes		-- disjoint positive convexes tiling a tilerun
--	spSectorCreateSkyBoxes		-- disjoint positive convexes tiling all tileruns
--	spSectorCreateSectorlets	-- Wedges masked by SkyBoxes
--	spSectorCreateSectors 		-- sets of sectorlets with common tiles and targeting
--	spSectorSubtractHoles		-- subtract holes from sectors
--	spSectorFillCompatibility	-- fill Halfspace and RegionArcs table
--	spSectorCreate 				-- driver for the other routines
--	spSectorLayerAssemble		-- assemble polygons in each layer into regions
--	spSectorLayerPartition		-- partition layer into disjoint polygons
--	spSectorSetTargetRegionID	-- sets Target.regionid
--	spSectorFillBest2Sector		-- fills the sdssBestTarget2Sector table 
--	
--	Along the way the Sector, sector2tile, and Region2Box tables are populated
----------------------------------------------------------------------------------
-- History:
--* 2004-01-01 Jim:  started
--* 2004-03-12 Jim:  first limping version.
--* 2004-03-22 Jim:  first really working version.
--* 2004-03-27 Jim:  cleanup
--* 2004-03-28 Alex: more cleanup, merge with rest of region schema
--* 2004-05-08 Jim:  changed the spSectorCreateWedges algorithm
--* 2004-05-20 Alex: added @stripe to spRegionNibbles to improve orientation
--* 2004-05-23 Alex: added WedgeID as the ID for the Sectorlets
--* 2004-05-30 Jim:  changed spRegionNibbles to spSectorNibbles, and moved it here
--* 2004-06-03 Alex: fixed last sector bug in spSectorCreateSectors
--* 2004-09-08 Jim+Alex:  modified cleanup in spSectorCreateSkyBoxes
--* 2004-10-09 Jim+Alex: tying module to the load utilities
--* 2004-12-29 Jim:  added better comments to wedge region descriptor: now has plate list.
--* 2004-10-29 Jim:  Fixed sectorlet computation to not record wedge tiles that are not
--*			part of the SkyBox^wedge sectorlet if the tile is not from one 
--*			of the SkyBox's tiling runs. 
--* 2004-12-31 Jim:  Redid the design to only use tiles INDSIDE their tiling geometry
--*			(i.e. the part of a tile outside its tiling geometry does not 
--*			enter into any wedge or sectorlet computations.  This was a subtle bug)
--* 2005-01-27 Jim+Alex: Added holes (in addition to tiling masks) in building tileBoxes.
--* 2005-01-27 Jim+Alex: Converted to spRegionOverlapID() for null tests.
--* 2005-01-28 Alex: Switched from HOLE to TIHOLE in spSectorTileBox. Also dropped Foreign keys
--*			at the beginning of sector creation and rebuilt them at the end.
--* 2005-03-02 Alex: Put in explicit ordering in the cursors for spSectorCreateTileboxes, thus
--*			eliminating dependence on the statistics.
--* 2005-03-03 Alex: Added TilingGeometryID and targetVersion to sectorlet comment, added
--*			spSectorCleanup for consistent cleanup of regions. Added count to log message.
--*			Execute Tilebox and SkyBox computations first.
--* 2005-03-06 Alex: Changed Region2Box.regionid to Region2Box.id, to correctly represent its meaning.
--*			Eiminated the dependence of everything on the Sector table. Added type to
--*			sector2tile, and modifed the scripts accordingly.
--* 2005-03-08 Alex: Modified Sectorlet to carry the tilinggeometryid in its ID field in Region.
--* 2005-03-12 Alex: spSectorCreateSectors now requires matching tiles and targetVersion. 
--*			Removed the Sector table everywhere, except the end of spSectorCreateSector.
--*			Changed the @stepid parameter from output to input.
--* 2005-04-01 Alex: Fixed bug in spSectorCreateSkyboxes. Also made use of the fact that TPRIMARY is
--*			always inside a STAVE.
--* 2005-04-06 Alex: Modified spSectorCreateSectorlets to make use of bounding circles, also cleaned
--*			up problems due to incorrect handling of different targetVersions.
--* 2005-04-06 Alex: Rewrote spSectorCreateSectors to handle multiple targetVersions
--* 2005-04-07 Alex: Switched spRegionIntersect with stripe to spRegionSimplify, and
--*			removed stale @id in spRegionCreateTileBoxes
--* 2005-04-13 Alex: Added spSectorCreateHoles and modified spSectorCreate accordingly
--=======================================================================================
--* 2007-06-07 Alex: total overhaul when switching over to the Spherical library
--* 2007-06-11 Alex: Added spSectorLayerAssemble and spSectorLayerPartition to separate
--*			common patterns in the new code base
--* 2007-06-11 Alex: modified code of spSectorFillBest2Sector to speed things up
--* 2009-09-17 Victor: renamed tables for SDSS-III - tiling tables
--* 2012-03-07 Ani: Updated sector table names to add "sdss" prefix.
--* 2012-06-11 Ani: Replaced sdssTilingGeometryID with regionID.
--* 2012-06-12 Ani: Replaces Sector with sdssSector in spSectorCreateSectors
--*            and spSectorSubtractHoles.
----------------------------------------------------------------------------------------
SET NOCOUNT ON
GO

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCleanup' )
	DROP PROCEDURE spSectorCleanup
GO
--
CREATE  PROCEDURE spSectorCleanup(@taskid int, @stepid int, @type varchar(16))
----------------------------------------------------------------
--/H Cleanup the Region tables from regions of a certain type
--/A -----------------------------------------------------------
--/T Parameters:
--/T <li> @taskid, @stepid -- job control parameters
--/T <li> @type varchar(16) -- region type
--/T <samp>exec spSectorCleanup 0,0, 'WEDGE'</samp>
--/T------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @msg VARCHAR(1000)
	--
	DELETE RegionPatch WHERE regionID in
	    (select RegionID from Region where type=@type)
	DELETE sdssSector2tile WHERE regionID in
	    (select RegionID from Region where type=@type)
	DELETE Region2Box WHERE boxType=@type
	DELETE Region WHERE type=@type
	--------------------------------------------
	-- eliminate all empty regions of any type
	--------------------------------------------
	SELECT regionid
	INTO #empty
	FROM Region
	WHERE area=-1
	--	  
	DELETE RegionPatch WHERE regionid in
		(select regionid from #empty)
	DELETE Region2Box WHERE boxid in
		(select regionid from #empty)
	DELETE Region WHERE regionid in
		(select regionid from #empty)
	----------------------------------------------------
	SET @msg =  'Cleaning up old '+ @type + ' regions';
	EXEC spNewPhase @taskid, @stepid, 'Sectors', 'OK', @msg 
END
GO


--================================================================
IF  EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].spSectorLayerAssemble') 
		AND type in (N'P', N'PC'))
		DROP PROCEDURE [dbo].spSectorLayerAssemble
GO
--
CREATE PROCEDURE spSectorLayerAssemble(@taskid int, @stepid int)
----------------------------------------------------------------
--/H Assembles layers of regions consisting of tiles and masks
--/A -----------------------------------------------------------
--/T Expects the existence of a temporary table #regionlist, which 
--/T has to have at least four columns:<br>
--/T <li>layer int: unique identifier each layer
--/T <li>isMask int: 0: positive region, 1: it is a mask, must be subtracted
--/T <li>regionid bigint: a unique identifier of the incoming region
--/T <li>bin varbinary(max): the regionBinary from the particular region
--/T <br>The incoming regions are assumed to be single convexes
--/T <br>Returns a list of regions (not neccessarily convexes which 
--/T distinctly cover their layers.<br>
--/T <br><samp>exec spSectorAssembleLayer 0,0, 1</samp>
----------------------------------------------------------------
AS BEGIN
		---------------------------------------------
		-- build a queue for recursive processing
		---------------------------------------------
		SELECT layer, 
			ROW_NUMBER() OVER(
				PARTITION BY layer ORDER BY isMask, regionid
			) id, isMask, regionid, bin
		INTO #queue
		FROM #regionlist
		ORDER BY layer, id;
		---------------------------------------------------------
		-- collect the regionids for comment using cross apply
		---------------------------------------------------------
		SELECT	t.layer,
				comment = LEFT(o.list, LEN(o.list)) 
		INTO #comment
		FROM ( select distinct layer from #queue) t
		CROSS APPLY (
			select case isMask
					when 0 then ' +'
					when 1 then  ' -'
				end +cast(q.regionid as varchar(30)) AS [text()]
			from (  select id, isMask, regionid from #queue
					where layer=t.layer
				) q
			order by q.id
			for XML PATH('')
		) o (list)
		ORDER BY t.layer;
		-----------------------------------------
		-- do the recursive SphDiff		
		-----------------------------------------
		WITH CTE (layer, id, bin) AS
		(
			-----------------------------------------
			-- get first region 
			-----------------------------------------
			select layer, id, bin from #queue where id=1
			----------
			union all
			----------
			select b.layer, b.id, 
				case isMask
					when 0 then dbo.fSphUnion(a.bin, b.bin) 
					when 1 then dbo.fSphDiff(a.bin,b.bin)
				end bin
				from CTE a, #queue b
				where a.id+1=b.id
				  and a.layer=b.layer
		)
		-------------------------------------------------------
		-- now execute the CTE and get only the last recursion
		-- for each layer
		-------------------------------------------------------
		SELECT s.layer, c.comment, s.bin
		INTO #stack
		FROM CTE s join #comment c on s.layer=c.layer
		CROSS APPLY (
			select max(id) id
			from #queue
			where layer=s.layer
		) m
		WHERE s.id=m.id 
		ORDER BY s.layer
		--------------------------
		-- generate the output
		--------------------------
		SELECT	s.layer, s.comment, s.bin
		FROM #stack s
		ORDER BY layer
		----------------------------------
END
GO


--============================================================
IF  EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[spSectorLayerPartition]') 
		AND type in (N'P', N'PC'))
		DROP PROCEDURE [dbo].[spSectorLayerPartition]
GO
--
CREATE PROCEDURE spSectorLayerPartition(@taskid int, @stepid int, @trace int=0)
-----------------------------------------------------------------------------
--/H Partition a set of layers into polygons, distinct within their layer
--/A --------------------------------------------------------------------------
--/T Expects the existence of a temporary table #regionlist, which has to have
--/T at least three columns:<br>
--/T <li>layer int: unique identifier each layer
--/T <li>regionid bigint: a unique identifier of the incoming region
--/T <li>bin varbinary(max): the regionBinary from the particular region
--/T <br> The incoming regions are assumed to be single convexes
--/T <br> Returns a list of regions which uniquely tile their respective layers.
--/T <br> The columns of the output table are the following:<br>
--/T <li>stackid int identity(1,1) NOT NULL,
--/T <li>layer int,
--/T <li>comment varchar(1000),
--/T <li>flag int,
--/T <li>bin varbinary(max)
--/T <br>
--/T @trace (default 0) specifies whether only the final regions should be 
--/T returned or we want a stack trace of the whole algorithm.
--/T <br><samp>exec spSectorPartitionLayer 0,0, 1</samp>
--------------------------------------------------------------------------------
AS BEGIN
		SET NOCOUNT ON;
		--
		DECLARE @layer int, 
				@qid int, 
				@stackid int,
				@qname varchar(32),
				@sname varchar(32),
				@tbin varbinary(max),
				@sbin varbinary(max),
				@TandS varbinary(max),
				@msg varchar(1000)
		--
		DECLARE @stacklist TABLE (stackid int)
		------------------------------------------------
		-- test the existence of the #regionlist table
		------------------------------------------------
		IF NOT EXISTS (select * from tempdb.dbo.sysobjects 
			where name like N'#regionlist%' )
		BEGIN
			PRINT 'no #regionlist table found'
			RETURN 0;
		END
		------------------------------
		-- the #stack table
		------------------------------
		CREATE TABLE #stack (
			stackid int identity(1,1) NOT NULL,
			layer int,
			comment varchar(1000),
			flag int,
			bin varbinary(max)
		)
		-----------------------------
		-- the #fragment table
		-----------------------------
		CREATE TABLE #fragment (
			fragid int identity(1,1),
			layer int,
			comment varchar(1000),
			stackid int,
			bin varbinary(max)
		)
		------------------------------
		-- the #queue table
		------------------------------
		CREATE TABLE #queue (
			layer int,
			id int,
			regionid bigint,
			bin varbinary(max)
		)
		--
		INSERT #queue
		SELECT	layer, 
			ROW_NUMBER() OVER( PARTITION BY layer ORDER BY regionid) id,
			regionid, bin
		FROM #regionlist
		ORDER BY layer, id
		------------------------------
		-- is there any data?
		------------------------------
		IF (@@rowcount=0)
		BEGIN
			PRINT 'no data in #regionlist table'
			RETURN 1
		END
		-------------------------------
		-- start loop though the queue
		-------------------------------
		DECLARE TB cursor read_only FOR
			select layer, id, bin from #queue
		OPEN TB
		WHILE(1=1)
		BEGIN
			-----------------------------------
			-- fetch the next TILE
			-----------------------------------
			FETCH NEXT FROM TB INTO @layer, @qid, @tbin;
			IF (@@fetch_status<0) BREAK;
			--
			SET @qname = 'Q['+cast(@qid as varchar(8))+']';
			------------------------
			-- save it in #fragment
			------------------------
			TRUNCATE TABLE #fragment
			INSERT #fragment SELECT @layer, @qname, 1, @tbin;
			-------------------------------------
			-- take everything alive in the #stack
			-------------------------------------
			DELETE @stacklist;
			INSERT @stacklist
			SELECT stackid FROM #stack WHERE flag=1 and layer=@layer
			---------------------------------------
			-- if nothing in #stack, insert
			---------------------------------------
			IF (@@rowcount=0) 
			BEGIN
				INSERT #stack
				SELECT @layer,@qname,1,@tbin;
				CONTINUE
			END
			--
			DECLARE SB cursor read_only FOR
				select s.stackid, bin from #stack s, @stacklist k
				where s.stackid=k.stackid and layer=@layer
				  and flag=1
			OPEN SB
			--
			WHILE(1=1)
			BEGIN
				FETCH NEXT FROM SB INTO @stackid, @sbin;
				IF (@@fetch_status<0) BREAK;
				-------------------------
				-- do they intersect?
				-------------------------
				SET @TandS = dbo.fSphIntersect(@tbin,@sbin);
				-------------------------
				-- no, they don't
				-------------------------
				IF (@TandS is null) CONTINUE;
				-----------------------------------------
				-- yes, insert first T.S
				-----------------------------------------
				SET @sname = 'S['+cast(@stackid as varchar(8))+']';
				INSERT #stack
				SELECT @layer,@sname+'.'+@qname,1,@TandS;
				-------------------------------------
				-- next, insert convexes from S-T into #skybox
				-------------------------------------
				INSERT #stack
				SELECT @layer, @sname+'-'+@qname+':'+cast(convexid as varchar(8)),
					1,regionBinary 
					FROM dbo.fSphGetConvexes(dbo.fSphDiff(@sbin,@tbin))
				WHERE regionBinary is not null;
				--------------------------------
				-- update #fragment from last
				--------------------------------
				INSERT #fragment
				SELECT TOP 1 @layer, comment+'-'+@sname, @stackid, dbo.fSphDiff(bin,@sbin)
				FROM #fragment WHERE layer=@layer
				ORDER BY fragid desc
				---------------------------
				-- delete S from the #stack
				---------------------------
				UPDATE #stack 
					SET flag=0, comment=comment+'@'+@qname
				WHERE stackid=@stackid;
				----------------------------------------------------------
			END
			CLOSE SB
			DEALLOCATE SB
			----------------------------------------------
			-- insert convexes from #fragment into #stack
			----------------------------------------------
			INSERT #stack
			SELECT @layer,comment+':'+cast(convexid as varchar(8)),
				1,c.regionBinary 
				FROM (
					select top 1 fragid, comment, bin
					from #fragment
					where layer=@layer
					order by fragid desc
				) f CROSS APPLY dbo.fSphGetConvexes(f.bin) c
			WHERE f.bin is not null;
			-------------------------------------------
		END
		CLOSE TB
		DEALLOCATE TB
		--------------------------------------
		-- return output, all for @trace=1
		--------------------------------------
		SELECT * FROM #stack WHERE flag>=(1-@trace);
		--
		RETURN
END
GO


--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateTileBoxes' )
	DROP PROCEDURE spSectorCreateTileBoxes
GO
--
CREATE PROCEDURE spSectorCreateTileBoxes (@taskid int, @stepID int)
-------------------------------------------------------
--/H Partition each TileRegion into positive TILEBOX quadrangles  
--/A --------------------------------------------------
--/T TilingRuns produce positive regions and masks that represent
--/T the areas covered by tiling.  This procedure produces a set of 
--/T TILEBOX regions that are disjoint quadrangles that cover
--/T all the positive areas of the region. All TileBoxes are done 
--/T relative to a stave. If a Tiling region covers more than one 
--/T stave, it will be decomposed into stave-local regions. 
--/T spCreateTileBoxes also populates the Region2Box table with 
--/T entries of the form (TIPRIMARY, R, TILEBOX, T).
--/T spCreateTileBoxes is based on the observations that:
--/T (1) Tile regions within a tile run are disjoint quadrangles.
--/T (2) Masks are quadrangles.
--/T (3) If T is a tile and M is a mask with sides 
--/T <br> top, bottom, left, right 
--/T <br> then the positive area is T-left, T-right, T+left+right-top, 
--/T T+left+right-bottom.
--/T Along the way, it maintains the Region2Box map. 
--/T <p> Parameters:   
--/T <li> taskid int,   -- Task identifier
--/T <li> stepid int,   -- Step identifier
--/T <li> returns  0 if OK, non-zero if something wrong  
--/T <samp>EXEC spSectorCreateTileBoxes 0,0  </samp>
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON
	DECLARE @msg VARCHAR(1000), @count int, @type varchar(12);
	SET @type='TILEBOX';
	------------------------------------
	SET @msg =  'Starting '+@type+' computation'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	------------------------------------
	-- delete the previous stuff
	------------------------------------
	EXEC spSectorCleanup @taskid, @stepid, @type;
	---------------------------------------
		-- the list of TIPRIMARY regions 
		-----------------------------------
		CREATE TABLE #tiprimary(
			stripe int,
			tileRun int,
			isMask int,
			tid bigint,
			regionid bigint, 
			bin varbinary(max),
			primary key (stripe,tileRun,regionid) 
		)
		--
		INSERT #tiprimary
		SELECT	t.stripe, t.tileRun, t.isMask,
				t.regionID tid,
				r.regionid, r.regionBinary
			FROM Region r, sdssTilingGeometry t
			WHERE r.type='TIPRIMARY'
			  and r.id =t.regionID
			ORDER BY t.stripe, t.tileRun, r.regionid
		--------------------------------------------
		-- create distinct layers grouped by
		-- stripe and tilerun and tid of the
		-- positive regions
		--------------------------------------------
		CREATE TABLE #layer (
			layer int identity(1,1),
			stripe int,
			tileRun int,
			tid bigint
		)
		--
		INSERT #layer
		SELECT distinct stripe, tileRun, tid
		FROM #tiprimary
		WHERE isMask=0
		ORDER BY stripe, tileRun, tid
		-----------------------------------------------
		-- build a list of positive regions for the assembly
		-----------------------------------------------
		SELECT l.layer, t.isMask, t.regionid, t.bin
		INTO #regionlist
		FROM #tiprimary t, #layer l
		WHERE t.isMask=0
		  and l.stripe=t.stripe
		  and l.tilerun=t.tilerun
		  and l.tid=t.tid
		----------------------------------------------
		-- now include the isMask=1 regions in every
		-- layer with the same stripe and tileRun
		----------------------------------------------
		INSERT #regionlist
		SELECT l.layer, t.isMask, t.regionid, t.bin
		FROM #tiprimary t, #layer l
		WHERE t.isMask=1
		  and l.stripe=t.stripe
		  and l.tilerun=t.tilerun
		------------------------------------------------
		-- run the assembly code to build the #tilebox
		------------------------------------------------
		CREATE TABLE #tbox (
			layer int,
			comment varchar(2000),
			bin varbinary(max)
		)
		--
		INSERT INTO #tbox
		EXEC spSectorLayerAssemble 0,0;
		---------------------------
		-- unpack into convexes
		---------------------------
		SELECT	s.layer, c.convexid,
				s.comment+':'+cast(c.convexid as varchar(12)) comment, 
				c.regionBinary bin
		INTO #tilebox
		FROM #tbox s CROSS APPLY dbo.fSphGetConvexes(s.bin) c
		ORDER BY layer
		------------------------------------
		-- insert into the Region table
		------------------------------------
		INSERT Region
		SELECT tid as id,'TILEBOX' as type,comment, 0 isMask, 
			dbo.fSphGetArea(bin) area, 
			dbo.fSphGetRegionString(bin) regionString,
			bin as regionBinary
		FROM (	select l.layer, l.tid,
					'stripe '+LTRIM(cast(l.stripe as varchar(12)))
					+ ', tileRun '+cast(l.tileRun as varchar(30))
					+ ', TIPRIMARY'+t.comment as comment, 
					t.bin
				from #tilebox t, #layer l
				where t.layer=l.layer
			) a
		ORDER BY a.layer
		-----------------------------------
		-- insert into RegionPatch table
		-----------------------------------
		EXEC spRegionSync @type;
		-------------------------------------------------
		-- log it into the Region2Box table
		-------------------------------------------------
		INSERT Region2Box
		SELECT 'TIPRIMARY',id,@type, regionid
		FROM Region
		WHERE type=@type
	------------------------------------
	SELECT @count=count(*) FROM Region with (nolock) WHERE type=@type
	SET @msg =  'Finished computation of '
		+ cast(@count as varchar(30))+ ' '+@type+' regions'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	--	
END
GO

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateSkyBoxes' )
	DROP PROCEDURE spSectorCreateSkyBoxes
GO
--
CREATE PROCEDURE spSectorCreateSkyBoxes (@taskid int, @stepID int)
-------------------------------------------------------
--/H Cover the sky with positive disjoint SKYBOX quadrangles 
--/H that cover all TILEBOXes
--/A --------------------------------------------------
--/T Tiling Runs produce positive regions and masks that represent the
--/T areas covered by tiling.  spCreateSectorTileBoxes produces a set of 
--/T TILEBOX regions that are disjoint quadrangles within their own 
--/T tileruns, and that cover all the positive areas of the region. Since 
--/T these different layers overlap, this procedure combines the overlapping 
--/T TILEBOX quadrangles into disjoint SKYBOX components. <br>
--/T spSectorCreateSkyBoxes also populates the Region2Box table with 
--/T entries of the form (TIPRIMARY,R,SKYBOX,S) and (TILEBOX,T,SKYBOX,S). 
--/T spSectorCreateSkyBoxes is based on the observation that:
--/T <li>(1) TILEBOXES disjoint quadrangles within a tileRun (and it's staves). 
--/T <li>(2) If TB is a new tilebox, and SB(i) are the set of existing SKYBOXes,
--/T then the new set of tileboxes are the following:
--/T <li><li>(2.a) Each SB[i] which does not intersect with TB is left intact.
--/T <li><li>(2.b) Each SB[i] which intersects with TB is replaced by new
--/T regions, namely SB[i].TB, and SB[i]-TB, where "." is intersection, "-" is
--/T difference in the spatial sense. 
--/T <li><li>(2.c)Finally TB-union(SB[*]) is addded to the list of SKYBOXes.
--/T Each region added to the SKYBOX list is a simple convex. MOre complex
--/T regions are broken into their cenvexes before the addition takes place. 
--/T This is done by spSectorLayerPartition.<br> 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp>EXEC spSectorCreateSkyBoxes 0,0  </samp>
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON
	DECLARE @msg VARCHAR(1000), @count int, @type varchar(12);
	SET @type='SKYBOX';
	-----------------------------------------------------------
	SET @msg =  'Starting '+@type+' computation'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	-----------------------------------------------------------
	-- delete the TEMP, SKYBOX and empty regions 
	-----------------------------------------------------------
	EXEC spSectorCleanup @taskid, @stepid, @type;
	--------------------------------------
	-- collect the info from the TILEBOXes
	--------------------------------------
	CREATE TABLE #tilebox (
		regionid bigint NOT NULL,
		tid bigint,
		stripe int,
		tileRun int,
		targetVersion varchar(32),
		area float,
		bin varbinary(max),
		PRIMARY KEY(regionid)
	)
	--
	INSERT #tilebox
	SELECT	r.regionid, r.id as tid, t.stripe, t.tilerun, 
			t.targetVersion, r.area, r.regionBinary bin
	FROM Region r, sdssTilingGeometry t
	WHERE r.type='TILEBOX'
	  and r.id  = t.regionID
	----------------------------------------------
	-- create a table of layers for bookkeeping
	----------------------------------------------
	CREATE TABLE #layers (
		layer int identity(1,1),
		stripe int
	)
	--
	INSERT #layers
	SELECT distinct stripe
	FROM #tilebox
	ORDER BY stripe
	--
	SELECT	t.stripe, t.area, l.layer,
		ROW_NUMBER() OVER ( order by t.tid desc) as regionid,
			t.bin
	INTO #regionlist
	FROM #tilebox t, #layers l
	WHERE t.stripe=l.stripe
	order by t.tid desc
	---------------------------------------------
	-- capture the output into #skybox
	---------------------------------------------
	CREATE TABLE #skybox (
		stackid int,
		layer int,
		comment varchar(1000),
		flag int,
		bin varbinary(max)
	)
	--
	INSERT INTO #skybox EXEC spSectorLayerPartition @taskid, @stepid;
	--------------------------------------------------------------
	-- compute overlaps with #tiprimary, in the stripes only,
	-- since SKYBOXes and TILEBOXes do not reach beyond a stipe
	---------------------------------------------------------------
	SELECT l.stripe, s.stackid, t.tileRun, t.tid, t.regionid, t.targetVersion
	INTO #overlaps
	FROM #skybox s, #layers l, #tilebox t
	WHERE s.layer=l.layer
	  and l.stripe=t.stripe
	  and dbo.fSphIntersect(t.bin,s.bin) is not null
	----------------------------------------
	-- build the comment for each SKYBOX
	-- derived from the #overlaps
	----------------------------------------
	SELECT t.stackid,comment = 'from TILEBOX '+LEFT(o.list, LEN(o.list)) 
		+'  ['+LTRIM(cast(stackid as varchar(20)))+']'
	INTO #comment
	FROM #skybox t--OIN #layers l on t.layer=l.layer 
	CROSS APPLY (
		select '+'+cast(regionid as varchar(30)) AS [text()]
		from ( select stackid, regionid
				from #overlaps
				where stackid=t.stackid
			 ) q
		order by q.stackid
		for XML PATH('')
		) o (list)
	ORDER BY t.stackid
	------------------------------------
	-- insert into the Region table
	------------------------------------
	INSERT Region
	SELECT tid as id,'SKYBOX' as type,comment,cast(0 as int) isMask, 
		dbo.fSphGetArea(bin) area, 
		dbo.fSphGetRegionString(bin) regionString,
		bin as regionBinary
	FROM (	select q.tid, s.stackid, c.comment, s.bin
			from #skybox s join #comment c on s.stackid=c.stackid
			cross apply 
			(select min(tid) as tid from #overlaps where stackid=s.stackid) q
		) a
	ORDER BY a.stackid
	------------------------------------------
	-- also insert into the RegionPatch table
	------------------------------------------
	EXEC spRegionSync @type;
	------------------------------------------
	-- retrieve the regionid's for Region2Box
	------------------------------------------
	SELECT r.regionid, c.stackid
	INTO #region2stack
	FROM Region r, #comment c
	WHERE r.type=@type
	  and r.comment=c.comment
	-----------------------------------
	-- write the info into Region2Box
	-----------------------------------
	INSERT Region2Box
	SELECT distinct 'TIPRIMARY', o.tid as id, @type, s.regionid
	FROM #region2stack s, #overlaps o
	WHERE s.stackid=o.stackid
	--
	INSERT Region2Box
	SELECT distinct 'TILEBOX', o.regionid as id, @type, s.regionid
	FROM #region2stack s, #overlaps o
	WHERE s.stackid=o.stackid
	------------------------------------
	-- Skyboxes computed
	------------------------------------
	SELECT @count=count(*) FROM Region with (nolock) WHERE type=@type
	SET @msg =  'Finished computation of '+ cast(@count as varchar(30))
		+ ' '+@type+' regions'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	------------------------------------
END
GO



--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateWedges' )
	DROP PROCEDURE spSectorCreateWedges
GO
--
CREATE PROCEDURE spSectorCreateWedges (@taskid int, @stepid int, @type varchar(12)='WEDGE') 
-------------------------------------------------------
--/H Create Wedges: all intersections of tiles
--/A --------------------------------------------------
--/T For each tile T<br>
--/T 	For each wedge W<br>
--/T	    Add T as a new wedge<br> 
--/T        If TW is not null<br>
--/T 	        Split W into two new wedges WT and W-T<br>
--/T 	    Subtract W from the T wedge<br>
--/T Along the way, maintain the sdssSector2tile map and the Sector table. 
--/T <p>Parameters:   
--/T <li> @taskid int   		-- Task identifier
--/T <li> @stepid int   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br><samp> spSectorCreateWedges 0,0  </samp>
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @msg VARCHAR(1000);
	--
	IF (@type not in ('WEDGE','WEDGE2') ) RETURN;
	--------------------------------------------------------
	SET @msg =  'Starting '+@type+' computation'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	--------------------------------------------------------
	EXEC spSectorCleanup @taskid, @stepid, @type;
	-------------------------
	-- Variable declares
	-------------------------
	DECLARE 
		@tile    		int,		-- ID of the tile
		@tileRegionID 	bigint,		-- Region ID of TileRegion
		@notTileRegionID bigint,	-- Region ID of complement of TileRegion
		@tileRun 		int,		-- Tiling run that generated tile
		@ra	 			float, 		-- center of tile (ra, dec)
		@dec 	 		float,		--	
		@count			int,
		@distance 		float, 		-- tile radius
		@isMask	 		int,		-- flag says tile is a mask for this wedge
		@ExclusiveID	bigint,		-- ID of a Exclusive wedge for the current tile
		@commonWedgeID	bigint,		-- ID of wedge that is base + next
		@wedgeRegionID	bigint, 	-- ID of next wedge  
		@tiletype		varchar(12),-- type of relevant tiles (TILE or TILE2)
		@comment		varchar(1000);  -- comment on tile
	DECLARE @bin varbinary(8000);
	-----------------------------------------------
	-- grab a distinct list of the relevant tiles
	-----------------------------------------------
	SELECT @tiletype = CASE @type when 'WEDGE' then 'TILE' else 'TILE2' end;
	--
	CREATE TABLE #tiles(
		regionid bigint,
		tile int,
		cx float,
		cy float,
		cz float,
		flag tinyint,
		PRIMARY KEY(regionid, tile)
	)
	INSERT #tiles
	SELECT 	max(regionid) regionid, tile,
		max(cx), max(cy), max(cz),1
		FROM Region R, sdssTileAll T
		WHERE R.type = @tiletype
		  and R.id = T.tile
		GROUP BY tile
	------------------------------------------
	-- Get the max distance between centers 
	-- of two overlapping tiles
	------------------------------------------
	SELECT @distance=RADIANS(2*value) 
	    FROM SDSSConstants WHERE name='tileRadius'
	--------------------------------------
	-- Precompute the tile overlap pairs
	--------------------------------------
	CREATE TABLE #TileOverlapPairs( 
		tile1 int, 
		tile2 int, 
		distance float,	-- arcsec
		flag tinyint,
		PRIMARY KEY ( tile1, tile2)
	    )
	--
	INSERT #TileOverlapPairs
	SELECT distinct h1.tile, h2.tile, 
		3600*degrees(2*asin(sqrt(
			power(h1.cx-h2.cx,2)+power(h1.cy-h2.cy,2)
			+power(h1.cz-h2.cz,2))/2)) as distance, 1
	    FROM #tiles h1, #tiles h2
	    WHERE h1.tile != h2.tile
  	      and case when (sqrt(  power(h1.cx-h2.cx,2)
				+ power(h1.cy-h2.cy,2)
				+ power(h1.cz-h2.cz,2))/2)<1
		then 2*asin(sqrt( power(h1.cx-h2.cx,2)
				+ power(h1.cy-h2.cy,2)
				+ power(h1.cz-h2.cz,2))/2) 
		else PI() 
		end  <= @distance
	-------------------------------------------
	-- set flags of overlapping tiles to 0
	-- for WEDGE2 computations only
	-------------------------------------------
	IF (@type='WEDGE2')
	BEGIN
		-----------------------------------------------------------
		-- flag tiles which are exact duplicates of another one
		-- with a lower tile number
		-- flag=1 are the distinct tiles
		-----------------------------------------------------------
		UPDATE #tiles
		  SET flag = 0
		  WHERE tile in (
			select distinct tile2
			from #tileoverlappairs
			where distance <20
			  and tile1<tile2
			)
		-----------------------------------------------------------
		-- reset flag to 0 for pairs which are not distinct tiles
		-----------------------------------------------------------
		UPDATE #tileoverlappairs
		  SET flag = 0
		  WHERE tile1 in (select tile from #tiles where flag=0)
			or  tile2 in (select tile from #tiles where flag=0)
	END
	-----------------------------------
	-- wedges that overlap this wedge
	-----------------------------------
	CREATE TABLE #overlaps ( regionID bigint);
	------------------------------------------------
	-- Compute the wedges as follows.
	-- the first tile is the first candidate wedge. 
	-- 	add it to Sector and sdssSector2tile
	-- for each subsequent tile region T
	-- and for {W} = {W | T is an overlaping tile}
	--  T_exclusive = T - {W} is a wedge
	--  {W} and T is a wedge 
	--  {W} -T is a wedge 
	--  limit the search to wedges inside tiles that overlap T
	--  for each tile T
	--  make a region copy of it, called A 
	--	for each such wedge W overlapping T
	-- 		make a new common wedge 
	--		C = W and T 
	--		A = A - W  
	-- 		W = W - T
	-----------------------------------------------------------
	-- Here is the iterator over all Tiles T ordered by tile #
	-----------------------------------------------------------
	DECLARE tile CURSOR READ_ONLY FOR 	
	SELECT regionID, tile FROM #tiles WHERE flag=1 ORDER BY tile
	------------------------------------------------------
	-- Main loop: handle each tile once around the loop.
	------------------------------------------------------
	SET CURSOR_CLOSE_ON_COMMIT OFF
	BEGIN TRANSACTION
	OPEN tile
	FETCH NEXT FROM tile INTO @tileRegionID, @tile 
	--
	WHILE (@@fetch_status = 0)
	BEGIN
		--------------------------------------------------
		-- this creates the "exclusive" T area called A.
		--------------------------------------------------
		SET @comment = 'Exclusive region for: ' + cast(@tile as varchar(20))
		EXEC @ExclusiveID = spRegionCopy @tile, @tileRegionID,@type, @comment
		--
		INSERT sdssSector2tile VALUES(@ExclusiveID,@type,@tile, 0)
		--------------------------------------------------------
		-- cursor to get all wedges that overlap this tile
		-- we maintain sectors and sdssSector2tile inside the loop,  
		--------------------------------------------------------
		TRUNCATE TABLE #overlaps;	-- clear out old values
		INSERT #overlaps 
		    SELECT DISTINCT ST.RegionID 
			FROM #TileOverlapPairs TP, sdssTileAll T, sdssSector2tile ST  --, Region S  
			WHERE TP.tile1 = @tile
			  and TP.tile2 = T.tile
		 	  and T.tile = ST.tile
			  and ST.isMask = 0
			  and ST.type = @type
			  and TP.flag = 1;
		--------	
 		DECLARE overlaps cursor for select regionID from #overlaps 
		OPEN overlaps
		------------------------------------
		-- loop to intersect wedge W with Tile T. 
		------------------------------------
		WHILE (1=1)
		    BEGIN
			------------------
			-- get next wedge
			------------------
			FETCH NEXT FROM overlaps INTO @wedgeRegionID 
			IF (@@fetch_status < 0) BREAK;
			------------------------------------
			-- create a new "common" wedge that 
			-- is the AND of the two
			------------------------------------
			EXEC @commonWedgeID = spRegionAnd 0, 
				@tileRegionID, @wedgeRegionID, @type, ''
			-----------------------------------
			-- if wedge and tile have nothing 
			-- in common then skip this wedge
			-----------------------------------
			IF (@commonWedgeID=0) CONTINUE;
			-----------------------------------------
			-- else add this new wedge to the sector 
			-- list and record the covering tiles 
			-----------------------------------------
			INSERT sdssSector2tile VALUES(@commonWedgeID,@type,@tile, 0)
			INSERT sdssSector2tile 
			    SELECT @commonWedgeID, @type, tile, isMask 
				FROM sdssSector2tile 
				WHERE regionID = @wedgeRegionID
			----------------------------------------
			-- supress negative regions that do 
			-- not form an edge of the tile 
			----------------------------------------


			DELETE sdssSector2tile 		
			    WHERE isMask = 1				-- sdssSector2tile says its a mask
				and regionID = @commonWedgeID 	-- MUST be an arc of simplified wedge
				and not exists (
					-------------------------------------
					-- if you cant find such an edge, 
					-- then sdssSector2tile is redundant.
					------------------------------------
					select H.halfspaceid 
					from sdssTileAll T, 
						( 
						select a.halfspaceid, a.x, a.y, a.z 
						from Region r  cross apply 
							dbo.fSphGetHalfspaces(r.regionBinary) a
						where r.regionid=sdssSector2tile.regionid
						) H
					where T.tile = sdssSector2tile.tile
					  and (abs(T.cx+H.x)+abs(T.cy+H.y)+abs(T.cz+H.z))<1e-6
				)
			-------------------------------------------------
			-- Now subtract the tile from the existing wedge
			-------------------------------------------------
 			EXEC spRegionSubtract @wedgeRegionID, @tileRegionID
			INSERT sdssSector2tile VALUES(@wedgeRegionID,@type,@tile, 1)
			------------------------------------
			-- Now subtract common part from the
			-- "exclusive part" of the tile
			------------------------------------
			EXEC spRegionSubtract @ExclusiveID, @commonWedgeID 
			------------------------------------
			-- Subtract the positive parts of the 
			-- common wedge from the Exclusive part
			---------------------------------------
			INSERT sdssSector2tile 	-- 0->1 1->0
			    SELECT @ExclusiveID,@type,tile, 1 
				FROM sdssSector2tile 
				WHERE regionID = @commonWedgeID
				  and isMask = 0
				  and tile not in (
				    select tile 	-- avoid dups
				    from sdssSector2tile
				    where regionID =@ExclusiveID
				  )
			---------------------------------------------------
			-- if a tile constraint does not participate 
			-- in a wedge (is not in its 1/2 space)
			--  then eliminate it from sdssSector2tile. 
			-- Note, that the negative constraints have 
			-- their vectors negated so 
			-- T.xyz + H.xyz should be zero if NotT 
			-- is in the 1/2 space.
			------------------------------------
			DELETE sdssSector2tile 
			WHERE isMask = 1
			  and regionID in(@ExclusiveID,  @commonWedgeID)
			  and not exists (
				select H.halfspaceid from sdssF T, ( 
					select a.halfspaceid, a.x, a.y, a.z 
					from Region r  cross apply 
						dbo.fSphGetHalfspaces(r.regionBinary) a
					where r.regionid=sdssSector2tile.regionid
					) H
				  where T.tile = sdssSector2tile.tile
				  and (abs(T.cx+H.x)+ abs(T.cy+H.y)
				   + abs(T.cz+H.z)) < 1e-6
			    )  	
 		    END
		CLOSE overlaps
		DEALLOCATE overlaps
		-----------------------
		--delete empty sectors
		-----------------------
		SELECT regionID INTO #emptyWedge
		  FROM Region
		  WHERE type = @type
			and area=-1
		---
		DELETE sdssSector2tile WHERE regionID in 
		    (select regionID from #emptyWedge) 
		----
		DELETE Region WHERE regionID in 
		    (select regionID from #emptyWedge)
		--
		DROP TABLE #emptyWedge
		-------------------------------------------
		-- also delete stale sdssSector2tile entries
		-------------------------------------------
		DELETE sdssSector2tile 
		  WHERE type=@type
			and regionID  not in (
				select regionid from Region where type=@type
			)
		--
	    COMMIT TRANSACTION
	    --
	    BEGIN TRANSACTION
		FETCH NEXT FROM tile INTO @tileRegionID, @tile
	END   
	------------------------------------
 	CLOSE tile
	DEALLOCATE tile
	COMMIT TRANSACTION 
	----------------------------------------------------
	-- insert overlaps into sdssSector2tile, WEDGE2 only
	----------------------------------------------------
--	IF (@type='WEDGE2')
--	BEGIN
--		----------------------------------------------------
--		-- collect new info that should go into sdssSector2tile
--		----------------------------------------------------
--		SELECT distinct s.regionid, p.tile2 as tile, s.isMask
--		INTO #news2t
--		  FROM sdssSector2tile s, Region r, #tileoverlappairs p
--		  WHERE s.regionid=r.regionid
--			and r.type='WEDGE2'
--			and p.tile1<p.tile2
--			and p.tile1 = s.tile
--			and p.flag=0
--		---------------------------------
--		-- delete if it already exists
--		---------------------------------
--		DELETE n
--		FROM #news2t n, sdssSector2tile s
--		where n.regionid=s.regionid
--		  and n.tile=s.tile
--		  and n.isMask=s.isMask
--		----------------------------
--		-- insert into sdssSector2tile
--		----------------------------
--		--INSERT sdssSector2tile
--		SELECT regionid, 'WEDGE2', tile, isMask
--		FROM #news2t
--	END
	------------------------------------
	-- Fix the wedge region comment to say: 
	-- "Wedge tiles: +75-86" or something
	------------------------------------
	DECLARE @tileList varchar(1000);
	DECLARE wedges cursor for 
		select regionid from Region 
		where type =@type
		for update of comment
	OPEN wedges
	WHILE(1=1)
	BEGIN
		FETCH NEXT FROM wedges INTO @wedgeRegionid
		IF (@@Fetch_Status  <0) break;
		SET @tileList = ''
		SELECT @tileList = @tileList 
			+ case when isMask = 0 then '+' else '-' end
			+ ltrim(cast(s.tile as varchar(30)))
		  FROM  sdssSector2tile s  
		  WHERE s.regionid = @wedgeRegionid
		  ORDER BY isMask asc
		--
		UPDATE Region  
		  SET comment = 'tiles: '+ @tileList 
		  WHERE regionid = @wedgeRegionid
	END
	CLOSE wedges;
	DEALLOCATE wedges;
	---------------------------------
	-- insert into RegionPatch
	---------------------------------
	EXEC spRegionSync @type;
	------------------------------------
	-- Wedges done
	------------------------------------
	SELECT @count=count(*) FROM Region with (nolock) WHERE type=@type;
	--
	SET @msg = 'Finished computation of '
		+ cast(@count as varchar(30)) +' '+
		+ @type+ ' regions'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
END
GO


--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateSectorlets' )
	DROP PROCEDURE spSectorCreateSectorlets
GO
--
CREATE PROCEDURE spSectorCreateSectorlets (@taskid int, @stepID int)
-------------------------------------------------------
--/H Compute sectorlets as intersection of SKYBOXes and WEDGEs 
--/A --------------------------------------------------
--/T SKYBOXes are disjoint convex regions that tile the survey.
--/T Each SKYBOX is built from tiling regions. WEDGEs are disjoint 
--/T convex regions built from Boolean intersections of the primary 
--/T TILEs. SECTORLETs are non-null intersections of SKYBOXes and 
--/T WEDGEs which have at least one tileRun in common.
--/T <br> 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br><samp> spSectorCreateSectorlets 1,1  </samp>
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON
	DECLARE @msg varchar(1000), @count int, @type varchar(12);
	SET @type='SECTORLET';
	---------------------------------------------------
	SET @msg =  'Starting '+@type+' computation '
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	------------------------------------
	-- delete the temp and Skybox and empty regions 
	------------------------------------
	EXEC spSectorCleanup @taskid, @stepid, @type;
	--------------------------------------------
	-- get all the pairs of WEDGEs and SKYBOXes
	-- whose bounding circles intersect
	--------------------------------------------
	CREATE TABLE #pairs (
		skyboxid bigint,
		wedgeid bigint,
		PRIMARY KEY(skyboxid, wedgeid)
	)
	--
	INSERT #pairs
	SELECT DISTINCT 
		h1.regionid as skyboxid, 
		h2.regionid as wedgeid
		FROM RegionPatch h1, RegionPatch h2
		WHERE h2.type='WEDGE'
		  and h1.type='SKYBOX'
		  and case when (sqrt(
				power(h1.x-h2.x,2)
				+power(h1.y-h2.y,2)
				+power(h1.z-h2.z,2))/2)<1
			then 2*asin(sqrt(power(h1.x-h2.x,2)
				+power(h1.y-h2.y,2)
				+power(h1.z-h2.z,2))/2) 
			else PI() end < RADIANS(h1.radius/60)+RADIANS(h2.radius/60)
		ORDER BY skyboxid, wedgeid
	----------------------------------------
	-- now compute the true intersection
	----------------------------------------
	SELECT	skyboxid, wedgeid, 
			'Sectorlet from'
			+ ' SKYBOX ' + cast(skyboxid as varchar(30)) 
			+ ' and WEDGE ' + cast(wedgeid as varchar(30))
			+ ' from targetVersion ' comment,
			dbo.fSphIntersect(w.regionBinary, s.regionBinary) bin
	INTO #intersection
	FROM #pairs i, Region w, Region s
	WHERE  i.wedgeid=w.regionid
	  and i.skyboxid=s.regionid
	  and dbo.fSphIntersect(w.regionBinary, s.regionBinary) is not null
	----------------------------------------
	-- collect SKYBOXes with their tileruns
	----------------------------------------
	CREATE TABLE #skybox (
		skyboxid bigint,
		id bigint,
		tileRun int,
		targetVersion varchar(32),
		PRIMARY KEY(skyboxid, tileRun)
	)
	--
	INSERT #skybox
	SELECT b.boxid, b.id, t.tileRun, t.targetVersion
	  FROM Region2Box b, sdssTilingGeometry t
	  WHERE b.boxType='SKYBOX'
	    and b.id=t.regionID
	----------------------------------------
	-- collect the WEDGEs with their tileRun
	----------------------------------------
	CREATE TABLE #wedge (
		wedgeid bigint,
		tile int,
		tileRun int,
		PRIMARY KEY(wedgeid, tileRun, tile)
	)
	INSERT #wedge
	SELECT w.regionid, s.tile, a.tileRun
	  FROM Region w, sdssSector2tile s, sdssTileAll a
	  WHERE w.type='WEDGE'
	    and w.regionid=s.regionid
	    and s.isMask = 0
	    and s.tile=a.tile
	---------------------------------------------------
	-- Put together the possible candidates
	-- and their targetVersions and tileRuns.
	-- These pairs must be from the same tilerun!
	---------------------------------------------------
	CREATE TABLE #sectorlets (
		skyboxid bigint,
		wedgeid bigint,
		tile int,
		id bigint,
		tilerun int,
		targetVersion varchar(32)
	)
	--
	INSERT #sectorlets
	SELECT 	
		i.skyboxid, i.wedgeid, w.tile,
		s.id, s.tileRun, s.targetVersion
	  FROM #intersection i, #wedge w, #skybox s
	  WHERE i.wedgeid  = w.wedgeid
	    and i.skyboxid = s.skyboxid
	    and w.tileRun  = s.tileRun
	ORDER BY i.skyboxid,i.wedgeid
	--------------------------------------------
	-- collect the targetVersion for each pair
	-- using cross apply
	--------------------------------------------
	SELECT	distinct s.skyboxid, s.wedgeid,
			targetVersion = LEFT(o.list, LEN(o.list)-1) 
	INTO #tversion
	FROM #sectorlets s
	CROSS APPLY (
		select targetVersion + ' ' AS [text()]
		from #sectorlets
		where skyboxid=s.skyboxid
		  and wedgeid=s.wedgeid
		order by targetVersion
		for XML PATH('')
	) o (list)
	order by s.skyboxid, s.wedgeid
	-------------------------------------------------
	-- insert the distinct sectorlets into Region
	-- distinctness is enforced by #tversion
	-------------------------------------------------
	INSERT Region(id,type,comment,ismask,area,regionString,regionBinary)
	SELECT  wedgeid as id, @type, comment,
			0, dbo.fSphGetArea(bin),
			dbo.fSphGetRegionString(bin), bin
	FROM (
		select	s.wedgeid, s.skyboxid, s.bin,
				s.comment+v.targetVersion comment
		from #intersection s, #tversion v
		where s.skyboxid= v.skyboxid
		  and s.wedgeid = v.wedgeid 
		) q
	-----------------------------------------------------
	-- copy over the sdssSector2tile record from the WEDGE
	-----------------------------------------------------
	INSERT sdssSector2tile
	SELECT r.regionid, @type, t.tile, t.isMask
	FROM Region r, #intersection i
	CROSS APPLY (
		select tile, isMask 
		from sdssSector2tile
		where regionID = i.wedgeID 
		) t	
	WHERE r.type=@type
	  and r.id=i.wedgeid
	  and r.comment like i.comment+'%'
	ORDER BY r.regionid
	--------------------------
	-- update Region2Box
	--------------------------
	INSERT Region2Box
	SELECT 'TIPRIMARY', t.id, @type, r.regionid
	FROM Region r, #intersection i
	CROSS APPLY (
		select distinct id
		from #sectorlets
		where wedgeid  = i.wedgeid
		  and skyboxid = i.skyboxid
		) t	
	WHERE r.type=@type
	  and r.id=i.wedgeid
	  and r.comment like i.comment+'%'
	ORDER BY r.regionid
	-----------------------------------
	-- insert into RegionPatch table
	-----------------------------------
	EXEC spRegionSync @type;
	------------------------------------
	-- Sectorlets computed. 
	------------------------------------
	SELECT @count=count(*) FROM Region WHERE type=@type
	--
	SET @msg =  'Finished computation of '
		+ cast(@count as varchar(30))
		+ ' '+@type+' regions'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	------------------------------------	
END
GO

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateSectors' )
	DROP PROCEDURE spSectorCreateSectors
GO
--
CREATE PROCEDURE spSectorCreateSectors (@taskid int, @stepid int)
-------------------------------------------------------
--/H Compute sectors as union of all sectorlets with the same tile cover
--/A --------------------------------------------------
--/T CreateSectorlets produced disjoint convex regions with a fixed tile coveage
--/T Sectorlets are intersections of wedges and skyboxes. 
--/T Sectors are unions of sectorlets all with the same list of covering tiles
--/T Build a list of tiles covering each sectorlet. 
--/T Then scan that list, producing sectors that contain all sectorlets having the same list.
--/T <br> 
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <samp>EXEC spSectorCreateSectors 0,0  </samp>
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON
	--
	DECLARE @count int, @msg varchar(1024), @type varchar(12);
	SET @type='SECTOR';
	-------------------------------------------------
	SET @msg =  'Starting '+@type+' computation'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	------------------------------------
	-- delete the temp and sector and empty regions 
	------------------------------------
    DELETE sdssSector;
	EXEC spSectorCleanup @taskid, @stepid, @type;
		--------------------------------------------
		-- collect the tiles for each regionid
		-- using cross apply
		--------------------------------------------
		CREATE TABLE #tiles (
			regionid bigint NOT NULL PRIMARY KEY,
			tiles varchar(1000)
		)
		--
		INSERT #tiles
		SELECT	t.regionid,
				tiles = LEFT(o.list, LEN(o.list)) 
		FROM Region t
		CROSS APPLY (
			select case when s.isMask=0 then ' +' else ' -' end 
				+cast(tile as varchar(10))  AS [text()]
			from Region r join  sdssSector2tile s on r.regionid = s.regionid
			where r.regionid = t.regionid 
			order by s.ismask asc, tile asc
			for XML PATH('')
		) o (list)
		WHERE t.type='SECTORLET'
		ORDER BY t.regionid
		--------------------------------------------
		-- collect the targetVersions for each regionid
		-- using cross apply
		--------------------------------------------
		CREATE TABLE #target (
			regionid bigint NOT NULL PRIMARY KEY,
			targetVersion varchar(1000)
		)
		--
		INSERT #target
		SELECT	t.regionid,
				targetVersion = LEFT(o.list, LEN(o.list)) 
		FROM Region t
		CROSS APPLY (
			select ' +'+q.targetVersion AS [text()]
			from ( select distinct targetversion
					from Region2Box b, sdssTilingGeometry g
					where b.id=g.regionID
					and boxid=t.regionid
					 ) q
			order by q.targetVersion
			for XML PATH('')
		) o (list)
		WHERE t.type='SECTORLET'
		ORDER BY t.regionid
		-----------------------------------------
		-- Fill the #sectorlets table for each, 
		-- compute its tilelist and targetVersion.
		-----------------------------------------
		CREATE TABLE #sectorlets (
			tiles varchar(400) NOT NULL,			-- string of tiles
			targetVersion varchar(400) NOT NULL,	-- string of targetVersion
			id int,									-- rank order by group
			regionid bigint NOT NULL,				-- regionid of the SECTORLET
			bin varbinary(max),						-- regionBinary of SECTORLET
			PRIMARY KEY(tiles,targetVersion,regionid)
		)
		--
		INSERT #sectorlets
		SELECT LTRIM(tiles) tiles, LTRIM(targetVersion) targetVersion,
			ROW_NUMBER() OVER( PARTITION BY t.tiles, v.targetversion ORDER BY t.regionid) id,
			t.regionid, r.regionBinary bin
		FROM #tiles t, #target v, Region r
		WHERE t.regionid=v.regionid
		  and t.regionid=r.regionid
		-------------------------------------------
		-- Now for each distinct set of tiles, and 
		-- targetVersion, create a new SECTOR 
		-- by recursively using fSphUnion
		-------------------------------------------
		CREATE TABLE #sectors (
			tiles varchar(400) NOT NULL,		-- string of tiles
			targetVersion varchar(400) NOT NULL,-- string of targetVersion
			sid bigint NOT NULL,				-- regionid of last SECTORLET
			regionid bigint NOT NULL,			-- will point to the REGION table
			bin varbinary(max),					-- binary blob of region
			parents varchar(1000),				-- string of SECTORLET regionids
			PRIMARY KEY (tiles, targetVersion)
		);
		--
		WITH sectorCTE (tiles, targetversion, id, regionid, bin) as
		(
			select tiles, targetversion, id, regionid, bin
				from #sectorlets
				where id=1
			----------
			union all
			----------
			select b.tiles, b.targetversion, b.id, b.regionid,
				dbo.fSphUnion(a.bin,b.bin)
				from sectorCTE a, #sectorlets b
				where a.id+1=b.id
				  and a.tiles=b.tiles
				  and a.targetVersion=b.targetVersion
		)
		-------------------------------------------------------
		-- bin is the regionBinary corresponding to the sector
		-- regionid is the highest regionid 
		-- participating in the sector.
		-------------------------------------------------------
		INSERT #sectors
		SELECT s.tiles, s.targetVersion, s.regionid, 0, s.bin, ''
		FROM sectorCTE s
		CROSS APPLY (
			select max(id) id
			from #sectorlets
			where tiles=s.tiles
			  and targetVersion=s.targetVersion
		) m
		WHERE s.id=m.id 
		ORDER BY s.tiles, s.targetVersion
		--------------------------------------------
		-- collect the parentage for each sequence
		-- using cross apply
		--------------------------------------------
		CREATE TABLE #parents (
			tiles varchar(400) NOT NULL,
			targetVersion varchar(400) NOT NULL,
			parents varchar(400),
			PRIMARY KEY (tiles, targetVersion)
		)
		--
		INSERT #parents
		SELECT	distinct s.tiles, s.targetVersion,
				parents = LEFT(o.list, LEN(o.list)) 
		FROM #sectorlets s
		CROSS APPLY (
			select '+'+cast(regionid as varchar(32))+' ' AS [text()]
			from #sectorlets
			where tiles=s.tiles
			  and targetVersion=s.targetVersion
			order by tiles,targetVersion,regionid
			for XML PATH('')
		) o (list)
		ORDER BY s.tiles, s.targetVersion
		--------------------------------------
		-- now add parents to #sectors
		--------------------------------------
		UPDATE s
			SET s.parents = p.parents
		FROM #parents p, #sectors s
		WHERE p.tiles=s.tiles
		  and p.targetVersion=s.targetVersion
		-------------------------------------
		-- load it into the Region table
		-------------------------------------
		INSERT Region
		SELECT  sid as id, @type, comment,
				0 isMask, dbo.fSphGetArea(bin) area,
				dbo.fSphGetRegionString(bin) regionstring, bin
		FROM (
			select	sid, tiles, targetVersion,
					'from SECTORLETS '+parents as comment, bin
			from #sectors
			) q
		ORDER BY q.tiles, q.targetVersion
		-----------------------------------
		-- insert also into RegionPatch table
		-----------------------------------
		EXEC spRegionSync @type;
		--------------------------------------
		-- capture the regionid into #sectors
		--------------------------------------
		UPDATE s
		  SET regionid = r.regionid
		from Region r, #sectors s
		where r.type=@type
		  and r.id=s.sid
		--------------------------------------
		-- #sectors has all the info we need
		-- to update the rest of the tables.
		-- We will compute the mapping from 
		-- SECTORs back to SECTORLETs
		-------------------------------------- 
		SELECT s.regionid, a.regionid as sectorletid
		INTO #pairs
		FROM #sectors s, #sectorlets a
		WHERE s.tiles = a.tiles
		  and s.targetVersion=a.targetVersion
		ORDER BY s.regionid
		-------------------------------------------
		-- Fill in sdssSector2tile by copying all the 
		-- distinct tiles from the SECTORLETs
		-------------------------------------------
		INSERT sdssSector2tile
		SELECT distinct p.regionid, @type, t.tile, t.isMask
		FROM sdssSector2tile t, #pairs p
		WHERE t.regionid = p.sectorletid
		-------------------------------------------
		-- Fill in Region2Box
		-------------------------------------------
		INSERT Region2Box
		SELECT distinct 'TIPRIMARY', b.id,@type, p.regionid
		FROM Region2Box b, #pairs p
		WHERE b.boxid=p.sectorletid
		-------------------------------------
		-- Insert into the Sector table
		-- get the number of positive tiles
		-- for each SECTOR in the inside loop
		-------------------------------------
		INSERT sdssSector
		SELECT s.regionid,t.nTiles,s.tiles, s.targetVersion,r.area
		FROM #sectors s, Region r, (
			select regionid, count(*) nTiles
			from sdssSector2tile
			where type='SECTOR'
			and isMask = 0
			group by regionid
			) t
		WHERE s.regionid=r.regionid
		  and s.regionid=t.regionid
	---------------------------------------
	-- cleanup complete, Sectors computed
	---------------------------------------
	SELECT @count=count(*) 
	    FROM Region with (nolock) 
	    WHERE type=@type;
	--
	SET @msg =  'Finished computation of '
		+ cast(@count as varchar(30))+ ' '+@type+' regions'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	------------------------------------	
END
GO

--==================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].spSectorSubtractHoles') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].spSectorSubtractHoles
GO
--
CREATE PROCEDURE spSectorSubtractHoles (@taskid int, @stepID int)
-------------------------------------------------------
--/H Subtract TIHOLEs from the SECTORs
--/A --------------------------------------------------
--/T Some SECTORs intersect with field later declared to be
--/T holes, by setting their quality=5. TIHOLEs are the intersections
--/T of these HOLE fields with the appropriate boundaries of the
--/T PRIMARY regions. This procedure with first determine which
--/T SECTORs will intersect TIHOLEs, and then subtracts those
--/T from the SECTORs, so that the area covered by the holes
--/T is excluded.
--/T <p> Parameters:   
--/T <li> taskid int,   -- Task identifier
--/T <li> stepid int,   -- Step identifier
--/T <li> returns  0 if OK, non-zero if something wrong  
--/T <samp>EXEC spSectorSubtractHoles 0,0  </samp>
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON
	DECLARE @msg VARCHAR(1000), @count int;
	-------------------------------------------------------
	SET @msg =  'Starting SECTOR-TIHOLES computation'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	-------------------------------------------------
		-- compute all the SECTOR,TIHOLE pairs
		---------------------------------------------
		CREATE TABLE #intersect (
			holeid bigint,
			regionid bigint,
			PRIMARY KEY (regionid, holeid)
		)
		--
		INSERT #intersect
		SELECT	distinct h1.regionid as holeid,
				h2.regionid
			FROM RegionPatch h1, RegionPatch h2
			WHERE h1.type='TIHOLE' 
			  and h2.type='SECTOR'
			  and case when (sqrt(
					power(h1.x-h2.x,2)
					+power(h1.y-h2.y,2)
					+power(h1.z-h2.z,2))/2)<1
				then 2*asin(sqrt(power(h1.x-h2.x,2)
					+power(h1.y-h2.y,2)
					+power(h1.z-h2.z,2))/2) 
				else PI() end < RADIANS(h1.radius/60)+RADIANS(h2.radius/60)
		--
		DELETE #intersect
		WHERE dbo.fRegionOverlapId(holeid, regionid,0) is null
		----------------------------------------------------
		-- create distinct layers grouped by the regionid
		-- of the sectors
		----------------------------------------------------
		CREATE TABLE #layer (
			layer int identity(1,1),
			regionid bigint
		)
		--
		INSERT #layer
		SELECT distinct regionid
		FROM #intersect
		ORDER BY regionid
		---------------------------------------------
		-- build regionlist table
		-- first insert the sectors to be processed
		---------------------------------------------
		SELECT l.layer, cast(0 as int) isMask, l.regionid, r.regionBinary bin
		INTO #regionlist
		FROM (select distinct regionid from #intersect) t, #layer l, Region r
		WHERE l.regionid=t.regionid
		  and l.regionid=r.regionid
		---------------------------------------------
		-- next, insert the masks with isMask=1
		---------------------------------------------
		INSERT #regionlist
		SELECT l.layer, cast(1 as int) isMask, r.regionid, r.regionBinary bin
		FROM #intersect i, #layer l, Region r
		WHERE i.regionid=l.regionid
		  and i.holeid=r.regionid
		-------------------------------------------
		-- get result from spSectorLayerAssemble
		-------------------------------------------
		CREATE TABLE #update (
			layer int,
			txt varchar(2000),
			bin varbinary(max)
		)
		--
		INSERT INTO #update
		EXEC spSectorLayerAssemble 0,0
		-----------------------------------------------------------------
		-- delete all RegionPatch involved, since the patches will be all new
		-----------------------------------------------------------------
		DELETE RegionPatch WHERE regionid in (
			select regionid from #update u, #layer l
			where u.layer=l.layer
			)
		---------------------------------------------
		-- delete Regions which became NULL
		---------------------------------------------
		SELECT regionid INTO #empty 
		FROM #update u, #layer l
		WHERE u.layer=l.layer
		  and u.bin is null
		DELETE #update WHERE bin is null
		--
		DELETE Region WHERE regionid in (select regionid from #empty)
		DELETE Region2Box WHERE boxid in (select regionid from #empty)
		DELETE sdssSector2tile WHERE regionid in (select regionid from #empty)
		DELETE sdssSector WHERE regionid in (select regionid from #empty)
		----------------------------------------------
		-- update those Regions which are not NULL
		----------------------------------------------
		UPDATE r
			SET regionBinary=a.bin,
				area = dbo.fSphGetArea(a.bin),
				regionString = dbo.fSphGetRegionString(a.bin),
				comment = comment + ' -TIHOLES'+txt
		FROM Region r, (
			select regionid, txt, bin 
			from #update u, #layer l
			where u.layer=l.layer	
		) a
		WHERE r.regionid=a.regionid
		----------------------------------------
		-- update the Sector area as well
		----------------------------------------
		UPDATE r
			SET area = dbo.fSphGetArea(a.bin)
		FROM sdssSector r, (
			select regionid, txt, bin 
			from #update u, #layer l
			where u.layer=l.layer	
		) a
		WHERE r.regionid=a.regionid
		-----------------------------
		-- reinsert RegionPatch
		-----------------------------
 		INSERT RegionPatch
		SELECT r.regionid, p.convexid, p.patchid, r.type, 
				p.radius, p.ra, p.dec,
				p.x, p.y, p.z, p.c, p.htmid,p.area,
				cast(p.convexString as varchar(max)) convexString
		FROM Region r JOIN #layer l on r.regionid=l.regionid
			JOIN #update u on  u.layer=l.layer
		CROSS APPLY dbo.fSphGetPatches(r.regionBinary) p
	------------------------------------------------------------
	-- we are done with subtracting the TIHOLEs from SECTORS
	------------------------------------------------------------
	SELECT @count=count(*) FROM #update
	--
	SET @msg =  'Finished subtraction of TIHOLES from SECTORS. Updated '
		+ cast(@count as varchar(30))+ ' SECTORs'
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', @msg 
	------------------------------------------------------------	
END
GO

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorFillCompatibility' )
	DROP PROCEDURE spSectorFillCompatibility
GO
--
CREATE  PROCEDURE spSectorFillCompatibility(@taskid int, @stepid int)
----------------------------------------------------------------
--/H Fills in the Halfspace and RegionArcs tables for compatibility
--/A -----------------------------------------------------------
--/T Parameters:
--/T <li> @taskid, @stepid -- job control parameters
--/T <samp>exec spSectorFillCompatibility 0,0</samp>
--/T------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	TRUNCATE TABLE Halfspace
	TRUNCATE TABLE RegionArcs
	--------------------------------------------
	-- fill in all Halfspaces
	--------------------------------------------
	INSERT Halfspace
	SELECT r.regionid, h.convexid, h.x, h.y,h.z,h.c
	FROM Region r
	CROSS APPLY dbo.fSphGetHalfspaces(r.regionBinary) h
	ORDER BY r.regionid, h.convexid
	-------------------------------------------------------
	-- fill in all RegionArcs, convert length to degrees
	-------------------------------------------------------
	INSERT RegionArcs
	SELECT	r.regionid, a.convexid, a.arcid as constraintid, a.patchid patch, 2 state,
			draw,ra1,dec1,ra2,dec2,x,y,z,c,DEGREES(length)
	FROM Region r
	CROSS APPLY dbo.fSphGetArcs(r.regionBinary) a
	ORDER BY r.regionid, a.convexid,a.arcid 
	----------------------------------------------------
	DECLARE @hcount int, @acount int, @msg varchar(1000);
	SELECT @hcount=count(*) FROM Halfspace;
	SELECT @acount=count(*) FROM RegionArcs;
	--
	SET @msg =  'Filled in '+cast(@hcount as varchar(30))
		+' Halfspaces and '+cast(@acount as varchar(30))
		+' RegionArcs for compatibility';
	EXEC spNewPhase @taskid, @stepid, 'Sectors', 'OK', @msg 
END
GO


--=============================================
IF EXISTS (select * from dbo.sysobjects 
	where name = N'spSectorCreate' )
	drop procedure spSectorCreate
GO
--
CREATE PROCEDURE spSectorCreate (@taskid int, @stepid int)
-------------------------------------------------------
--/H Create sectors, wedges, skyboxes, and tileboxes  
--/A --------------------------------------------------
--/T  Drives the subsidiary procedures to do the work
--/T <samp>EXEC spSectorCreate 0,0</samp>
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	------------------------------------
 	-- Clear the tables to start
	------------------------------------
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', 'Clearing Sector tables'
	--------------------------
	-- drop all foreign keys
	--------------------------
	EXEC spIndexDropSelection @taskid, @stepid, 'F', 'REGION'
	EXEC spIndexDropSelection @taskid, @stepid, 'K', 'Region2Box'
	--
	DELETE sdssBestTarget2Sector
	--
	EXEC spIndexBuildSelection @taskid, @stepid, 'K','REGION'
	EXEC spIndexBuildSelection @taskid, @stepid, 'I','REGION'
	------------------------------------
 	-- Create the different Region types
	------------------------------------
	EXEC spSectorCreateTileBoxes @taskID, @stepID 
	EXEC spSectorCreateSkyBoxes @taskID, @stepID
	EXEC spSectorCreateWedges @taskID, @stepID
	EXEC spSectorCreateWedges @taskID, @stepID, 'WEDGE2';
	EXEC spSectorCreateSectorlets @taskID, @stepID
	EXEC spSectorCreateSectors @taskID, @stepID
	EXEC spSectorSubtractHoles @taskID, @stepID
	-----------------------------------------------------
	-- fill Halfspace and RegionArcs for compatibility
	-----------------------------------------------------
	EXEC spSectorFillCompatibility @taskID, @stepID
	------------------------------
	-- rebuild the Foreign keys
	------------------------------
	EXEC spIndexBuildSelection @taskid, @stepid, 'F', 'REGION';
	------------------------------------
 	-- Created the Sectors 
	------------------------------------
	EXEC spNewPhase @taskID, @stepID, 'Sectors', 'OK', 'spSectorCreate completed'
	---------------------------------
END
GO


--=================================================
if exists (select * from dbo.sysobjects
        where id = object_id(N'[dbo].[spSectorSetTargetRegionID]')
        and OBJECTPROPERTY(id, N'IsProcedure') = 1)
        drop procedure [dbo].[spSectorSetTargetRegionID]
GO
--
CREATE PROCEDURE spSectorSetTargetRegionID(@taskid int, @stepid int)
------------------------------------------------
--/H Sets Target.regionID
--/A -------------------------------------------
--/T For each sector S in the Sector table, and
--/T for each Target object T inside S
--/T set T.regionID = S.regionID.
--/T <samp>exec spSectorSetTargetRegionID 0,0</samp>
------------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    DECLARE @regionid bigint,       -- regionID of sector
            @area varchar(7500),    -- region string
            @count bigint,          -- sector counter
            @objects bigint,        -- object counter
			@cmd varchar(8000),
			@msg varchar(1024),
			@targetDBname varchar(1000),
			@rows  bigint;
    --
    SET @msg = 'Begin spSectorSetTargetRegionID';
    EXEC spNewPhase @taskid, @stepid, 'SetTargetRegionID', 'OK', @msg;
	-----------------------------------
	--- Get TARGET-PUB name
	SELECT @targetDBname = him.dbname
	    FROM loadsupport.dbo.Task me,loadsupport.dbo.Task him
	    WHERE me.taskID = @taskID
		and me.dataset = him.dataset
		and him.type = 'TARGET-PUB'
	--	
	IF (@targetDbName is NULL)
	    BEGIN
		SET @msg = 'Cannot find TARGET-PUB database and so cannot copy target tables';
	 	EXEC spNewPhase @taskid, @stepid, 'SetTargetRegionID', 'WARNING', @msg;
	    END
 	------------------------------------------------------
	-- copy the Target table first
	SET  @cmd = 'INSERT Target SELECT * FROM ' + @targetDBname +  '.dbo.Target WHERE targetID NOT IN (SELECT targetID FROM Target)'
	EXEC (@cmd)
	SET  @rows = rowcount_big();
	SET  @msg = 'Copied ' +str(@rows) + ' rows to Target from ' + @targetDBname +  '.dbo.Target'
	EXEC spNewPhase @taskid, @stepid, 'SetTargetRegionID', 'OK', @msg;

 	------------------------------------------------------
	-- copy TargetInfo table
	SET  @cmd = 'INSERT targetInfo SELECT * FROM ' + @targetDBname +  '.dbo.targetInfo WHERE targetObjID NOT IN (SELECT targetObjID FROM TargetInfo)'
	EXEC (@cmd)
	SET  @rows = rowcount_big();
	SET  @msg = 'Copied ' +str(@rows) + ' rows to TargetInfo from ' + @targetDBname +  '.dbo.TargetInfo'
	EXEC spNewPhase @taskid, @stepid, 'SetTargetRegionID', 'OK', @msg;

	----------------------------------------------
	--Drop indices on this table for extra speed
	----------------------------------------------
	EXEC spIndexDropSelection 0,0, 'F', 'Target'
	EXEC spIndexDropSelection 0,0, 'I', 'Target'
	--
	-------------------------------------------------
	-- create a small table for the relevant objects
	-------------------------------------------------
	SELECT	q.targetid, q.htmid, q.cx, q.cy, q.cz
	INTO #SmallTargetTable 
  	    FROM Target q with (nolock)
	--
	ALTER TABLE #SmallTargetTable
	ADD CONSTRAINT pk_smalltargets PRIMARY KEY CLUSTERED (htmid,targetid)
	--
	SET @msg = 'Precomputed SmallTargetTable';
	EXEC spNewPhase @taskid, @stepid, 'SetTargetRegionID', 'OK', @msg;
	--
	------------------------------------
	-- create HTMrange for Cover
	------------------------------------
	DECLARE @htmrange TABLE (
		htmidstart bigint,
		htmidend bigint
	)
	------------------------------------
	-- create Halfspace for prefetch
	------------------------------------
	DECLARE @halfspace TABLE (
		convexid int,
		x float,
		y float,
		z float,
		c float 
	)
	---------------------------------------------
        DECLARE sector_cursor cursor read_only
        FOR     select regionid, regionString
                from Region
                where type= 'SECTOR'
        -------------------
        -- for each sector
        -------------------
        SET @count = 0;
        OPEN sector_cursor
        --
        WHILE(1=1)
        BEGIN
                FETCH NEXT from sector_cursor into @regionid, @area
                IF (@@fetch_status < 0) break
                SET @count=@count+1;
				-------------------------
				-- get halfspace
				-------------------------
				DELETE @halfspace;
				INSERT @halfspace	
				SELECT convexid, x,y,z,c 
				  FROM Halfspace WHERE regionid=@regionid
				-------------------------
				-- get cover
				-------------------------
				DELETE @htmrange;
				INSERT @htmrange SELECT * FROM dbo.fHtmCoverRegion(@area)
				---------------------------------------------------
				--Update Target.regionID for Targets in this sector
				---------------------------------------------------
                UPDATE t with (tablock)
                SET regionID = @regionid
                FROM Target t, (
                        select q.targetID, q.cx, q.cy, q.cz
                        from @htmrange c, #SmallTargetTable q
                        where q.htmID between c.HtmIdStart and c.HtmIdEnd
                        ) as o
                WHERE exists (
						select convexid from @halfspace
						where convexid not in (
								select convexid from @halfSpace h
                                where o.cx*h.x+o.cy*h.y+o.cz*h.z<h.c
                                )
                        )
				  and t.targetID = o.targetID
				--------------------------------------
				SET @objects = @objects+@@rowcount;
        END
        --------------------
        -- close the cursor
        --------------------
        CLOSE sector_cursor
        DEALLOCATE sector_cursor
    -----------------------
	--Rebuild the indices
	-----------------------
    EXEC spIndexBuildSelection 0,0, 'F', 'Target'
	EXEC spIndexBuildSelection 0,0, 'I', 'Target'
	------------------------------------------------------------------
	SET @msg =  LTRIM(STR(@objects, 20))
		+ ' objects in Target assigned to '
		+ LTRIM(STR(@count,20)) +' sectors';
	--
    EXEC spNewPhase @taskid, @stepid, 'SetTargetRegionID', 'OK', @msg;
    ------------------------------------------------------------------
    RETURN(0);
END
GO


--=================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSectorFillBest2Sector]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spSectorFillBest2Sector]
GO
--
CREATE PROCEDURE spSectorFillBest2Sector(@taskid int, @stepid int)
------------------------------------------------
--/H Fills the sdssBestTarget2Sector table 
--/A -------------------------------------------
--/T For each sector S in the Sector  table, and
--/T for each PhotoPrimary object P inside S 
--/T Insert (P,S) into the sdssBestTarget2Sector table.
--/T <samp>exec spSectorFillBest2Sector 0,0</samp>
------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE	@regionid bigint,	-- regionID of sector
			@area varchar(7500),	-- region string 
			@count bigint,		-- sector counter
			@objects bigint,	-- object counter
			@msg varchar(1000)  
	-----------------------------------------------------------------
	SET @msg = 'Begin spSectorFillBest2Sector';
	EXEC spNewPhase @taskid, @stepid, 'sdssBestTarget2Sector', 'OK', @msg;
	-------------------------------
	-- clesanup, drop foreign keys
	-------------------------------
	EXEC spIndexDropSelection 0,0, 'F', 'sdssBestTarget2Sector'
	DELETE sdssBestTarget2Sector
	-------------------------------------------------
	-- create a small table for the relevant objects
	-------------------------------------------------
	IF EXISTS (select * from dbo.sysobjects 
		where id = object_id(N'[BestTargetTable]') 
		and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	    DROP TABLE [BestTargetTable]
	--
	SELECT	q.objid, q.htmid, q.cx, q.cy, q.cz, q.status,
		s.primTarget, s.secTarget, q.petroMag_r,
		q.extinction_r
	INTO BestTargetTable 
  	    FROM PhotoTag q with (nolock)
		JOIN SpecObjAll s ON s.bestobjid=q.objid
	    WHERE q.mode=1 
	     and (q.status & 0x00004000>0) 	-- is TARGET
	--
	ALTER TABLE BestTargetTable
	ADD CONSTRAINT pk_besttargets PRIMARY KEY CLUSTERED (htmid,objid)
	-----------------
	-- log message
	-----------------
	SET @msg = 'Precomputed BestTargetTable';
	EXEC spNewPhase @taskid, @stepid, 'sdssBestTarget2Sector', 'OK', @msg;
	------------------------------------
	-- create HTMrange for Cover
	------------------------------------
	DECLARE @htmrange TABLE (
		htmidstart bigint,
		htmidend bigint
	)
	------------------------------------
	-- create Halfspace for prefetch
	------------------------------------
	DECLARE @halfspace TABLE (
		convexid int,
		x float,
		y float,
		z float,
		c float 
	)
	-----------------------------
	-- the objects from cover
	-----------------------------
	DECLARE @prefetch TABLE (
		objid bigint,
		cx float,
		cy float,
		cz float,
		status int,
		primTarget int,
		secTarget int, 
		petroMag_r real,
		extinction_r real
	)
	---------------------------------------------------------------
		DECLARE sector_cursor cursor read_only  
		FOR 	select regionid, regionString
				from Region 
 				where type= 'SECTOR'
		-------------------
		-- for each sector
		-------------------
		SET @count = 0;
		OPEN sector_cursor
		--
		WHILE(1=1)
		BEGIN
			FETCH NEXT from sector_cursor into @regionid, @area
			IF (@@fetch_status < 0) break
			SET @count=@count+1;
			-------------------------
			-- get halfspace
			-------------------------
			DELETE @halfspace;
			INSERT @halfspace	
			SELECT convexid, x,y,z,c 
			  FROM Halfspace
			  WHERE regionid=@regionid
			-------------------------
			-- get cover
			-------------------------
			DELETE @htmrange;
			INSERT @htmrange
			  SELECT * FROM dbo.fHtmCoverRegion(@area)
			-------------------------
			-- prefetch from cover
			-------------------------
			DELETE @prefetch;
			INSERT @prefetch
			  SELECT q.objid, q.cx, q.cy, q.cz, q.status,
					 q.primTarget, q.secTarget, 
					 q.petroMag_r, q.extinction_r
		  	  FROM BestTargetTable q, @htmrange c
			  WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
			-----------------------------------------------
			-- add PhotoPrimary if any targetflags are set
			-----------------------------------------------
			INSERT sdssBestTarget2Sector with (tablock)
			SELECT	
				o.objid, @regionid as regionid, o.status, o.primTarget, 
				o.secTarget, o.petroMag_r, o.extinction_r
			FROM @prefetch o
			WHERE exists (
				select convexid from @halfspace
				where convexid not in (
					select convexid from @halfspace h
					where o.cx*h.x+o.cy*h.y+o.cz*h.z<h.c 
					)
				)
			SET @objects = @objects+@@rowcount;
		END
		-----------------------------
		-- close the cursor and end.
		----------------------------
		CLOSE sector_cursor
		DEALLOCATE sector_cursor
	--------------------------------------------
  	DROP TABLE BestTargetTable
	--
	EXEC spIndexBuildSelection 0,0, 'F', 'sdssBestTarget2Sector'
	-------------------------------------------------------------------
	SET @msg =  LTRIM(STR(@objects, 20))
		+ ' rows loaded into sdssBestTarget2Sector from'
		+ LTRIM(STR(@count,20)) +' sectors';
	EXEC spNewPhase @taskid, @stepid, 'sdssBestTarget2Sector', 'OK', @msg;
	-------------------------------------------------------------------
	RETURN
END
GO

-------------------------------------------------------
PRINT '[spSector.sql]: Sector create procedures built'
-------------------------------------------------------
GO
