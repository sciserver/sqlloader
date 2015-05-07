--=================================================================
--   spBoundary.sql
--   2003-05-14 Alex Szalay, Baltimore
--	 2007-06-02 Alex Szalay, Munich, major overhaul
-------------------------------------------------------------------
-- needs to be run after the spRegion and spCoordinate functions 
-------------------------------------------------------------------
-- History:
--* 2003-06-06 Alex: Added Region.area as a placeholder for later 
--* 2003-06-07 Alex+Adrian: added Region.ismask attribute
--* 2003-06-07 Alex+Adrian: added various boundary classes, still
--*		      missing the fine patches in Stripe 82 CHUNK
--* 2003-08-04 Ani:  Changed TIBOUND->TIGEOM in Region and 
--*                    spCreateBoundary descriptions
--* 2003-08-20 Ani:  Added RegionConvexString table from Jim.
--* 2003-11-19 Ani:  Added scalar components of fGetLonLat & fMuNuFromEq,
--*		      i.e., fGetLon, fGetLat and fMuFromEq, fNuFromEq.
--* 2003-12-12 Ani:  Added fLambdaFromEq, fEtaFromEq and changed
--*                    fMuFromEq and fNuFromEq to take only ra,dec.
--* 2004-02-11 Alex: Fixed problems with the TIGEOM, also modified the
--*		      Region and Convex tables to be more normalized
--* 2004-02-11 Alex: Changed the name of Convex to HalfSpace
--* 2004-03-06 Alex: Fixed a problem with Souther stripe boundaries,
--*		      also inserted extra constraint to delimit stripes
--*		      to a single hemisphere
--* 2004-03-06 Alex: added spMakePrimaryBoundary, and the 'PRIMARY' 
--*		      type to Region
--* 2004-03-12 Jim:  Make convexid start at 0
--* 2004-03-18 Alex: Spawned off stuff to spCoordinate.sql and the
--*		      basic Region tables to RegionSchema.sql
--* 2004-03-25 Alex: Fixed another bug in TIGEOM coordtype=2 nu limits
--* 2004-03-25 Alex: Fixed bug in CAMCOL, only the shifted runs were written
--* 2004-04-28 Alex: Consolidated names to begin with spBoundary*
--* 2004-05-25 Alex: fixed a bug in RUNs. Also removed mu/lambda limits
--*		      from STAVEs, and adjusted PRIMARY accordingly
--* 2004-06-01 Alex: added min/max(d_r) to CAMCOL to improve boundaries,
--*		      changed CHUNK vertical boundaries to match STRIPE
--* 2004-08-25 Alex: added spBoundaryRunBox
--* 2005-01-09 Alex: added spBoundaryRun, and added call from spBoundaryCreate
--* 2005-01-09 Alex: changed spBoundaryTigeom to include lambda limits, also
--*			modified driver in spBoundaryCreate
--* 2005-01-09 Alex: modified spBoundaryStripe to do everything, modifed
--*			spBoundaryCreate
--* 2005-01-18 Alex: fixed lambdamin problem in spBoundaryTiGeom, added 
--*			spBoundaryTiPrimary, and spBoundaryHole.
--* 2005-01-20 Alex: Added proper spNewPhase logging to each of the routines
--* 2005-01-22 Alex: Added HOLEs to TIPRIMARY, fixed ismask bug in TIPRIMARY
--* 2005-01-27 Alex: Linked all HOLEs into contigous blocks, and also added 
--*			TIHOLE type.
--* 2005-02-20 Alex: Removed redundant holes code from spBoundaryTiPrimary.
--*			Also rearranged boundary creation sequence.
--* 2005-03-06 Alex: Dropped spBoundaryRunBox calculation.
--* 2005-03-13 Alex: Dropped spBoundaryRunBox, added spBoundaryFootprint
--* 2005-04-13 Alex: Fixed small type in the comment of spBoundaryFootprint
--* 2012-07-10 Ani:  Updated sector table names (added "sdss" prefix) and
--*                  commented out truncation of region tables.
---------------------------------------------------------------------------------
--* 2007-06-07 Alex: Total overhaul and rewrite to to the switch-over to the
--*			new Spherical library. In the process many small fBoundary* functions
--*			have been added, in order to isolate side effects of local variables
-- 2007-06-11 Alex: Moved PRIMARY generation into spBoundaryStripe, and TIPRIMARY 
--*			into spBoundaryTiGeom, and dropped spBoundaryPrimary, and spBoundaryTiPrimary.
--*			Also added secondary plates and tiles as PLATE2, TILE2.
--===============================================================================
SET NOCOUNT ON;
GO

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- first the fBoundary* functions
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fBoundaryCircle]') )
    drop function [dbo].[fBoundaryCircle]
GO
--
CREATE FUNCTION fBoundaryCircle(
	@ra float, @dec float, @radius float
)
-------------------------------------------------------
--/H Compute the boundary of a circle
--/A --------------------------------------------------
--/T Parameters:
--/T <li> @ra float: ra of center in degrees
--/T <li> @dec float: dec of center in degrees
--/T <li> @radius float: radius in degrees
--/T returns the region binary
-------------------------------------------------------
RETURNS varbinary(max)
AS BEGIN
	--
	DECLARE 
		@bin binary(8000),
		@x  float, 
		@y  float, 
		@z  float,
		@c  float;
	
	---------------------------------------------------------
	-- get the normal vector pointing at (ra,dec)
	---------------------------------------------------------
    SELECT
		@x = COS(RADIANS(@dec))*COS(RADIANS(@ra)), 
		@y = COS(RADIANS(@dec))*SIN(RADIANS(@ra)), 
		@z = SIN(RADIANS(@dec)),
		@c = COS(RADIANS(@radius))
	--SET @bin = NULL;
	SET @bin = dbo.fSphConvexAddHalfspace(NULL,0,@x,@y,@z,@c);
	SET @bin = dbo.fSphSimplifyBinaryAdvanced(@bin,0,0,0,0);
	RETURN @bin;
	---------------------------------------------------------
END
GO


--=============================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fBoundaryField]'))
DROP FUNCTION [dbo].[fBoundaryField]
GO
--
CREATE FUNCTION fBoundaryField(@camcolstave varbinary(max), 
	@node float, @incl float, @eta float, @mumin float, @mumax float)
------------------------------------------------------------
--/H Creates the boundary of a field or a set of fields
--/A -------------------------------------------------------
--/T We take the intersection of the appropriate camcol
--/T and stave, and cut it by the mu boundaries of the
--/T primary part of the block of fields.
--/T @fieldid bigint: the fieldid of the first field in the sequence
--/T @camcolstave varbinary(max): the region given by the SEGMENT/CAMCOL,
--/T possibly intersected by the appropriate STAVE
--/T @node, @incl float: determine the actual alignment of a stripe
--/T @eta float: the main scan angle of the idealized stripe
--/T @mumin, @mumax float: the mu limits for the set of fields
------------------------------------------------------------
RETURNS varbinary(8000)
AS BEGIN
	DECLARE 
		@x  float, @y  float, @z  float,    -- normal vector pointing at mu
		@x1 float, @y1 float, @z1 float,    -- normal vector of the stripe equator
        @bin binary(8000);
		--
		SET @bin = @camcolstave;
		-------------------------------------------------------
		-- get the nominal normal vector for the stripe (x1,y1,z1)
		-------------------------------------------------------
		SELECT @x1=x, @y1=y, @z1=z 
		FROM dbo.fEtaToNormal(@eta);
		---------------------------------------------------------
		-- get the normal vector pointing at the mumin direction
		-- in the plane of the stripe equator
		-- this should be pointing towards increasing mu
		---------------------------------------------------------
		SELECT	
			@x = COS(RADIANS(dec))*COS(RADIANS(ra)), 
			@y = COS(RADIANS(dec))*SIN(RADIANS(ra)), 
			@z = SIN(RADIANS(dec))
		FROM dbo.fEqFromMuNu(@mumin,0,@node, @incl);
		-------------------------------------------------
        SELECT @bin = dbo.fSphConvexAddHalfspace(@bin,0,x,y,z,0)
		FROM dbo.fWedgeV3(@x,@y,@z, @x1,@y1,@z1);
		---------------------------------------------------------
		-- get the normal vector pointing at the mumax direction
		-- this should be pointing towards decreasing mu
		---------------------------------------------------------
		SELECT	
			@x = COS(RADIANS(dec))*COS(RADIANS(ra)), 
			@y = COS(RADIANS(dec))*SIN(RADIANS(ra)), 
			@z = SIN(RADIANS(dec))
		FROM dbo.fEqFromMuNu(@mumax,0,@node, @incl);
		--------------------------------------------------
        SELECT @bin = dbo.fSphConvexAddHalfspace(@bin,0,-x,-y,-z,0)
		FROM dbo.fWedgeV3(@x,@y,@z, @x1,@y1,@z1);
		--
		RETURN dbo.fSphSimplifyBinaryAdvanced(@bin, 0, 0, 0, 0);        
END
GO


--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'fBoundaryPrimary') )
	drop function [fBoundaryPrimary]
GO
--
CREATE FUNCTION fBoundaryPrimary(
	@stripeno int, 
	@chunk bigint, 
	@stripe bigint, 
	@stave bigint
)
-------------------------------------------------------
--/H Computes the boundary of the primary region of a chunk
--/A --------------------------------------------------
--/T Will compute the intersection of the chunk boundaries
--/T and the stave boundaries from the corresponding stripe.
--/T It will take into account that the Southern staves have
--/T eta boundaries. It is ran at the end of boundary creation.
-------------------------------------------------------
RETURNS varbinary(max)
AS BEGIN
	DECLARE @bin binary(8000), @b1 varbinary(max), @b2 varbinary(max);
	--------------------------------------
	-- fetch the Chunk regionBinary
	--------------------------------------
	SELECT @bin = regionBinary
	FROM Region
	WHERE regionid=@chunk;
    --------------------------------------------------------
    -- add both the STRIPE and STAVE limits if in the North
    --------------------------------------------------------
    IF (@stripeno<50)
    BEGIN
		SELECT @b1 = regionBinary
		  FROM Region WHERE regionid=@stripe;
		SELECT @b2 = regionBinary
		  FROM Region WHERE regionid=@stave;
		--
		SET @bin = dbo.fSphIntersect(@bin,@b1);
		SET @bin = dbo.fSphIntersect(@bin,@b2);
		SET @bin = dbo.fSphSimplifyBinaryAdvanced(@bin, 0,0,0,0);
    END
	RETURN @bin;
END
GO

--==========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fBoundaryRun]') )
	drop function [dbo].[fBoundaryRun]
GO
--
CREATE FUNCTION fBoundaryRun(@run int)
-------------------------------------------------------
--/H Compute the boundary of a particular run
--/A --------------------------------------------------
--/T Inserts the constraints corresponding to the Run
--/T boundary into the Region table, using the existing
--/T definitions of the CAMCOLs. It computes the UNION
--/T of all the CAMCOL regions in a given run.
-------------------------------------------------------
RETURNS varbinary(max)
AS BEGIN
	--
	DECLARE @bin varbinary(max);
	--
	SET @bin = NULL;
	---------------------------------
	-- build up the UNION of CAMCOLs
	---------------------------------
	SELECT @bin = dbo.fSphUnion(@bin,s.regionBinary)
	FROM Region s, Segment q
	WHERE s.type='CAMCOL'
	  and q.segmentid=s.id
      and q.run = @run
	--
	RETURN dbo.fSphSimplifyBinaryAdvanced(@bin,0,0,0,0);
END
GO 

--=========================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fBoundarySegment]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fBoundarySegment]
GO
--
CREATE FUNCTION fBoundarySegment(
	@type varchar(16), @eta float, @rnode  float, @rincl float,
	@mumin float, @mumax float, @numin float, @numax float
)
-------------------------------------------------------
--/H Compute the boundary of a Segment/Camcol 
--/A --------------------------------------------------
--/T Inserts the constraints corresponding to the boundary 
--/T into the Boundary table. The union of SEGMENTs should 
--/T recover the outline of the parent Chunk. Segments are 
--/T separated algorithmically in nu. A few Segments are 
--/T shifted slightly -- these corrections were captured 
--/T in the Runshift table, and propagated here. Camcol 
--/T outlines are computed from the actual astrometry.
--/T The union of the CAMCOLs of a given Run should return 
--/T the correct outline of all pixels in that Run.<br>
--/T Parameters:<br>
--/T <li>@type is the type (SEGMENT|CAMCOL)
--/T <samp>select dbo.fBoundarySegment('SEGMENT',id)</samp>
-------------------------------------------------------
RETURNS varbinary(max)
AS BEGIN
	--
		DECLARE 
			@cid int,							-- regionid and convexid
			@c float, 							-- small circle offset    
			@node float,  @incl float,			-- the expected node and incl
			@x  float, @y  float, @z  float,    -- normal vector pointing at mu
			@x1 float, @y1 float, @z1 float,    -- normal vector of the stripe equator
			@shift float;						-- shift 
		DECLARE @bin varbinary(max);  
		-----------------------------------
		-- build the @halfspace table
		-----------------------------------
		DECLARE @halfspace TABLE (
			id int identity(1,1) PRIMARY KEY,
			convexid int,
			x float,
			y float,
			z float,
			c float
		)
		SET @cid=0;
		-------------------------------------------------------
		-- get the nominal normal vector for stripe (x1,y1,z1)
		-------------------------------------------------------
		SET @incl = @eta + 32.5;
		SET @node = 95.0;
		SELECT @x1=x, @y1=y, @z1=z FROM dbo.fEtaToNormal(@eta);
		--------------------------------------------------
		-- if CAMCOL get the real normal vector for stripe
		--------------------------------------------------
		IF (@type='CAMCOL')
	 	  BEGIN
		    SELECT  
				@x = -SIN(RADIANS(@rincl))*SIN(RADIANS(@rnode)),
			    @y =  SIN(RADIANS(@rincl))*COS(RADIANS(@rnode)),
			    @z = -COS(RADIANS(@rincl));
		  END
		ELSE	-- it is a SEGMENT
		  BEGIN
		    SELECT @x=@x1, @y=@y1, @z=@z1;
		  END
		----------------------------------------
		-- insert the upper/lower nu boundaries
		----------------------------------------
		SET @c = -SIN(RADIANS(@numax));
		INSERT @halfspace
		SELECT @cid, @x, @y, @z, @c;
		--
		SET @c = SIN(RADIANS(@numin));
		INSERT @halfspace
		SELECT @cid, -@x, -@y, -@z, @c;
		---------------------------------------------------------
		-- get the normal vector pointing at the mumin direction
		-- in the plane of the stripe equator
		-- this should be pointing towards increasing mu
		---------------------------------------------------------
		SELECT	
			@x = COS(RADIANS(dec))*COS(RADIANS(ra)), 
			@y = COS(RADIANS(dec))*SIN(RADIANS(ra)), 
			@z = SIN(RADIANS(dec))
		FROM dbo.fEqFromMuNu(@mumin,0,@node, @incl);
		--
		INSERT @halfspace
		SELECT @cid,x,y,z,0.0
		FROM dbo.fWedgeV3(@x,@y,@z, @x1, @y1, @z1);
		---------------------------------------------------------
		-- get the normal vector pointing at the mumax direction
		-- this should be pointing towards decreasing mu
		---------------------------------------------------------
		SELECT	
			@x = COS(RADIANS(dec))*COS(RADIANS(ra)), 
			@y = COS(RADIANS(dec))*SIN(RADIANS(ra)), 
			@z = SIN(RADIANS(dec))
		FROM dbo.fEqFromMuNu(@mumax,0,@node, @incl);
		--
		INSERT @halfspace
		SELECT @cid,x,y,z,0.0
		FROM dbo.fWedgeV3(@x1,@y1,@z1, @x, @y, @z);
		----------------------------------------------------
		-- now build the region from the #halfspace table
		----------------------------------------------------
		WITH CTE (id, bin) AS
		(
			select b.id, dbo.fSphSimplifyBinary(
					dbo.fSphConvexAddHalfspace(NULL,
					0,b.x,b.y,b.z,b.c) ) bin
				from @halfspace b where id=1
			union all
			select b.id, dbo.fSphSimplifyBinary(
					dbo.fSphConvexAddHalfspace(a.bin,
					0,b.x,b.y,b.z,b.c) ) bin
				from CTE a, @halfspace b
				where a.id+1=b.id
		)
		--
		SELECT top 1 @bin=s.bin from CTE s order by s.id desc;
		-----------------------------------------
		RETURN @bin
END
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fBoundaryStripe]') )
    drop function [dbo].[fBoundaryStripe]
GO
--
CREATE FUNCTION fBoundaryStripe(
	@type varchar(16), @sid bigint, @stripe int, @lmumin float,@lmumax float
)
-------------------------------------------------------
--/H Computes the boundary of a Stripe/Stave/Chunk 
--/A --------------------------------------------------
--/T Parameters:
--/T <li> @type varchar(16): one of 'CHUNK', 'STAVE' and 'STRIPE'
--/T <li> @sid bigint: the is of the parent object
--/T <li> @stripe int: the stripe number
--/T <li> @lmumin, @lmumax float: the scan limits
-------------------------------------------------------
RETURNS varbinary(max)
AS BEGIN
	--
	IF @type NOT IN ('STRIPE','STAVE','CHUNK') RETURN(NULL);
	--
	DECLARE 
		@bin binary(8000),
		@cid int,
		@c float, @incl float,
		@eta float,
		@eta1 float, @eta2 float,
		@nu1 float, @nu2 float,
		@x  float, @y  float, @z  float,
		@x1 float, @y1 float, @z1 float;

	-----------------------------
	-- stuff CHUNK/STRIPE/STAVE
	-----------------------------
	BEGIN
		-------------------------------------------------------
		-- get the normal vector for the stripe, pointing down
		-------------------------------------------------------
		SET @eta = (@stripe-10)*2.5 -32.5;
		IF  @stripe>50  SET @eta = (@stripe-82)*2.5 -32.5;
		--
		SET @incl = @eta + 32.5;
		SELECT @x1=x, @y1=y, @z1=z FROM dbo.fEtaToNormal(@eta);
		-----------------------------
		-- first create a new Region
		-----------------------------
		SET @bin = NULL;
		SET @cid  = 0;
		--------------------------------------------------
		-- for the Southern Chunks we have nu boundaries
		-- we do not include the shifted boundaries yet,
		-- we will patch those later
		--------------------------------------------------
		-- Northern Stripes
		--------------------
		IF ( (@type in ('STRIPE','CHUNK') ) 
		  OR (@type in ('STAVE') and @stripe>50))
		BEGIN 
		    -- insert the upper/lower nu boundaries
		    SET @nu2 =  1.25;
		    SET @nu1 = -1.25;
		    --
		    SET @c = SIN(RADIANS(@nu1));
			SET @bin = dbo.fSphConvexAddHalfSpace(@bin,@cid,@x1,@y1,@z1,@c);
		    --	
		    SET @c = SIN(RADIANS(@nu2));
			SET @bin = dbo.fSphConvexAddHalfSpace(@bin,@cid,-@x1,-@y1,-@z1,-@c);
		END
		--------------------------------------------
		ELSE IF (@type in ('STAVE') and @stripe<50) 
		BEGIN
		    --------------------------------
		    -- do the upper eta bound first
		    --------------------------------
			SELECT @bin = dbo.fSphConvexAddHalfSpace(@bin,@cid,x,y,z,0.0)
		    FROM dbo.fEtaToNormal(@eta+1.25);
		    --------------------------
		    -- do the lower eta bound
		    --------------------------
			SELECT @bin = dbo.fSphConvexAddHalfSpace(@bin,@cid,-x,-y,-z,0.0)
			FROM dbo.fEtaToNormal(@eta-1.25);
		END
		-----------------------------------------------------------
		-- now come the delimiters along the scan direction
		-----------------------------------------------------------
		IF ( @type = 'CHUNK')
		BEGIN
		    ---------------------------------------------------------
		    -- get the normal vector pointing at the mumin direction
		    ---------------------------------------------------------
		    SELECT
				@x = COS(RADIANS(dec))*COS(RADIANS(ra)), 
				@y = COS(RADIANS(dec))*SIN(RADIANS(ra)), 
				@z = SIN(RADIANS(dec))
			FROM dbo.fEqFromMuNu(@lmumin,0,95.0, @incl);
		    -------------------------------------------------
		    -- this should be pointing towards increasing mu
		    -------------------------------------------------
			SELECT @bin = dbo.fSphConvexAddHalfSpace(@bin,@cid,x,y,z,0.0)
			FROM dbo.fWedgeV3(@x,@y,@z, @x1, @y1, @z1);
		    ---------------------------------------------------------
		    -- get the normal vector pointing at the mumax direction
		    ---------------------------------------------------------
		    SELECT
				@x = COS(RADIANS(dec))*COS(RADIANS(ra)), 
				@y = COS(RADIANS(dec))*SIN(RADIANS(ra)), 
				@z = SIN(RADIANS(dec))
			FROM dbo.fEqFromMuNu(@lmumax,0,95.0, @incl);
		    -------------------------------------------------
		    -- this should be pointing towards decreasing mu
		    -------------------------------------------------
			SELECT @bin = dbo.fSphConvexAddHalfSpace(@bin,@cid,x,y,z,0.0)
				FROM dbo.fWedgeV3(@x1,@y1,@z1, @x, @y, @z);
		END
		-----------------------------------------
		-- not a chunk, we have a lambda boundary
		-----------------------------------------
		ELSE
		BEGIN
		    -------------------------------------
		    -- get the normal vector pointing 
		    -- at the survey z-direction
		    -------------------------------------
		    SELECT
				@x = COS(RADIANS(0.0))*COS(RADIANS(95.0)), 
				@y = COS(RADIANS(0.0))*SIN(RADIANS(95.0)), 
				@z = SIN(RADIANS(0.0));
		    -------------------------------------
		    -- get the normal vector pointing 
		    -- to the survey x-axis
		    -------------------------------------
		    SELECT
			@x1 = x, @y1 = y, @z1 = z
			FROM Rmatrix
			WHERE mode='J2S' and row=1
		    --
		    IF (@stripe<50)
		      BEGIN
				IF (@type='STRIPE')
				BEGIN
					SET @c = -SIN(RADIANS(@lmumin));
					SET @bin = dbo.fSphConvexAddHalfSpace(
						@bin, @cid,-@x,-@y,-@z,-@c);
				    --
				    SET @c = -SIN(RADIANS(@lmumax));
					SET @bin = dbo.fSphConvexAddHalfSpace(
						@bin, @cid,@x,@y,@z,@c);
				    ------------------------------------------------
				    -- add a delimiter for the Northern Hemisphere
				    ------------------------------------------------	
				    SET @c = 0;
					SET @bin = dbo.fSphConvexAddHalfSpace(
						@bin,@cid,@x1,@y1,@z1,@c);
				END
				-----------------------------------------------
				-- add a delimiter for the Northern Hemisphere
				-----------------------------------------------
				SET @c = COS(RADIANS(80.0));
				SET @bin = dbo.fSphConvexAddHalfSpace(
					@bin,@cid,@x1,@y1,@z1,@c);
		    END
		    ELSE
		    -----------------------
		    -- we are in the South
		    -----------------------
		    BEGIN
				IF (@type='STRIPE')
				BEGIN
					SET @c = SIN(RADIANS(@lmumax));
					SET @bin = dbo.fSphConvexAddHalfSpace(
						@bin,@cid,@x,@y,@z,@c);
					--
					SET @c = SIN(RADIANS(@lmumin));
					SET @bin = dbo.fSphConvexAddHalfSpace(
						@bin,@cid,-@x,-@y,-@z,-@c);
				END
				-----------------------------------------------
				-- add a delimiter for the Southern Hemisphere
				-----------------------------------------------
				SET @c = COS(RADIANS(80.0));
				SET @bin = dbo.fSphConvexAddHalfSpace(
					@bin,@cid,-@x1,-@y1,-@z1,@c);
		    END
		END
		--------------
		-- simplify
		--------------
		RETURN dbo.fSphSimplifyBinaryAdvanced(@bin, 0,0,0,0);
	END
	---------------------------------------------------------
END
GO

--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'fBoundaryTiGeom') )
    drop function fBoundaryTiGeom
GO
--
CREATE FUNCTION fBoundaryTiGeom(@sid bigint)
-------------------------------------------------------
--/H Compute the boundary of a TilingGeometry object
--/A --------------------------------------------------
--/T Inserts the constraints corresponding to the
--/T TilingGeometry into the Region and HalfaSpace tables.
--/T Parameters:
--/T <li>@sid is the tilinggeometryid of the object
-------------------------------------------------------
RETURNS varbinary(max)
AS BEGIN
	DECLARE
		@bin binary(8000),
		@count int,
		@type varchar(16), 
		@stripe int, 
		@ismask tinyint,
		@nsbx char(1), 
		@coordType int,
		@lmumin float, 
		@lmumax float,
		@enumin float, 
		@enumax float,
		@lambdamin float,
		@lambdamax float,
		@msg varchar(1024);
	-----------------------------------------
	DECLARE 
		@id int, @cid int,
		@staveid bigint, @c float,
		@incl float, @eta float, 
		@x  float, @y  float, @z  float,
		@x1 float, @y1 float, @z1 float,
		@x2 float, @y2 float, @z2 float;
	-----------------------------------------
	-- fetch the whole record
	--------------------------
	SELECT 	
		@type='TIGEOM', 
		@stripe=stripe, @ismask=isMask,
		@nsbx=nsbx, @coordType=coordType,
		@lmumin=lambdamu_0, @lmumax=lambdamu_1,
		@enumin=etanu_0, @enumax=etanu_1,
		@lambdamin=lambdaLimit_0,
		@lambdamax=lambdaLimit_1
	  FROM TilingGeometry
	  WHERE tilinggeometryid=@sid;
	--
	IF (@coordType=0) RETURN(NULL);
	--
	SET @bin = NULL;
	SET @cid = 0;
	--
	IF (@nsbx='B')	
	    ------------------------------------------------------
	    -- insert the stave boundaries first along the height
	    ------------------------------------------------------
	    BEGIN
			SELECT @bin = regionBinary FROM Region with (nolock)
		    WHERE id=@stripe and type='STAVE';
	    END
	--
	SET @eta = (@stripe-10)*2.5 -32.5;
	IF  @stripe>50  SET @eta = (@stripe-82)*2.5 -32.5;
	--
	SET @incl = @eta + 32.5;
	-----------------------------------------------
	-- normal vector for the stripe, pointing down
	-----------------------------------------------
	SELECT @x1=x, @y1=y, @z1=z FROM dbo.fEtaToNormal(@eta);
	--------------------------------------------
	-- The vertical TIGEOM boundaries (eta|nu)
	--------------------------------------------
	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	-- DO THE COORDTYPE=0 LATER!
	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	IF ( @coordType = 2)	-- nu boundaries
	  BEGIN 
	    ---------------------------------------------------------
	    -- insert the upper/lower nu boundaries, parallel to eta
	    ---------------------------------------------------------
	    SET @c = SIN(RADIANS(@enumin));
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,-@x1,-@y1,-@z1,@c);
	    --	
	    SET @c = SIN(RADIANS(@enumax));
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,@x1,@y1,@z1,-@c);
	  END
	-------------------------------------
	-- eta boundaries (coordType 1 or 3)
	-------------------------------------
	ELSE IF (@coordType in (1,3))		
	  BEGIN
	    --------------------------------
	    -- do the upper eta bound first
	    --------------------------------
	    SELECT @x=x, @y=y, @z=z FROM dbo.fEtaToNormal(@enumax);
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,@x,@y,@z,0.0);
	    --------------------------
	    -- do the lower eta bound
	    --------------------------
	    SELECT @x=x, @y=y, @z=z FROM dbo.fEtaToNormal(@enumin);
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,-@x,-@y,-@z,0.0);
	  END
	------------------------------------------------------------
	-- The horizontal TIGEOM boundaries (lambda|mu)
	-------------------------------------------------------------
		--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		-- DO THE COORDTYPE=0 LATER!
		--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	IF (@coordtype=1) 	-- we have a lambda boundary
	  BEGIN
	    ---------------------------------------------------------
	    -- the normal vector pointing at the survey z-direction
	    ---------------------------------------------------------
	    SELECT
			@x = COS(RADIANS(0.0))*COS(RADIANS(95.0)), 
			@y = COS(RADIANS(0.0))*SIN(RADIANS(95.0)), 
			@z = SIN(RADIANS(0.0));
	    --
		SET @c = -SIN(RADIANS(@lmumin));
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,-@x,-@y,-@z,-@c);
		--
		SET @c = -SIN(RADIANS(@lmumax));
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,@x,@y,@z,@c);
		--
	  END
	ELSE IF (@coordtype in (2,3) )	
	  -------------------------
	  -- we have a mu boundary
	  -------------------------
	  BEGIN
	    -----------------------------------------------------
	    -- the normal vector pointing at the mumin direction
	    -----------------------------------------------------
    	SELECT
			@x = COS(RADIANS(dec))*COS(RADIANS(ra)), 
			@y = COS(RADIANS(dec))*SIN(RADIANS(ra)), 
			@z = SIN(RADIANS(dec))
		FROM dbo.fEqFromMuNu(@lmumin,0,95.0, @incl);
	    -------------------------------------------------
	    -- this should be pointing towards increasing mu
	    -------------------------------------------------
	    SELECT @x2=x, @y2=y, @z2=z 
		FROM dbo.fWedgeV3(@x,@y,@z, @x1, @y1, @z1);
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,@x2,@y2,@z2,0.0);
	    -----------------------------------------------------
	    -- the normal vector pointing at the mumax direction
	    -----------------------------------------------------
	    SELECT
			@x = COS(RADIANS(dec))*COS(RADIANS(ra)), 
			@y = COS(RADIANS(dec))*SIN(RADIANS(ra)), 
			@z = SIN(RADIANS(dec))
		FROM dbo.fEqFromMuNu(@lmumax,0,95.0, @incl);
	    -------------------------------------------------
	    -- this should be pointing towards decreasing mu
	    -------------------------------------------------
	    SELECT @x2=x, @y2=y, @z2=z 
		FROM dbo.fWedgeV3(@x1,@y1,@z1, @x, @y, @z);
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,@x2,@y2,@z2,0.0);
	  END
	--------------------------------------
	-- insert lambda limits, if they exist
	--------------------------------------
	-- normal to the z-axis
	--------------------------
	SELECT
	    @x = COS(RADIANS(0.0))*COS(RADIANS(95.0)), 
	    @y = COS(RADIANS(0.0))*SIN(RADIANS(95.0)), 
	    @z = SIN(RADIANS(0.0));
	--
	IF (@lambdamin>-9900)
	  BEGIN
	    SET @c = -SIN(RADIANS(@lambdamin));
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,-@x,-@y,-@z,-@c);
	  END
	IF (@lambdamax>-9900)
	  BEGIN
	    SET @c = -SIN(RADIANS(@lambdamax));
		SET @bin = dbo.fSphConvexAddHalfspace(
			@bin,@cid,@x,@y,@z,@c);
	  END
	--
	RETURN dbo.fSphSimplifyBinaryAdvanced(@bin,0,0,0,0);
END
GO


--================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fBoundaryTiPrimary]') )
	drop function [dbo].[fBoundaryTiPrimary]
GO
--
CREATE FUNCTION fBoundaryTiPrimary(
	@tigeomid bigint, @staveid bigint, @stripeid bigint, @stripeno int)
-------------------------------------------------------
--/H Compute the boundary of the primary region of a TilingGeometry region
--/A --------------------------------------------------
--/T Will compute the intersection of the stripe and stave boundaries
--/T with the relevant TIGEOM region.
--/T It will take into account that the Southern staves have
--/T eta boundaries. It is ran at the end of boundary creation.
-------------------------------------------------------
RETURNS varbinary(max)
AS BEGIN
	DECLARE @bin binary(8000), @b1 binary(8000);
	-----------------------------
	-- fetch TIGEOM and STAVE
	-----------------------------
	SELECT @bin = regionBinary FROM Region
	WHERE regionid = @tigeomid;
	--
	SELECT @b1 = regionBinary FROM Region
	WHERE type='STAVE' and regionid=@staveid;
	--------------------------
	-- compute intersection
	--------------------------
	SET @bin = dbo.fSphIntersect(@bin,@b1);
    -----------------------------------------------------
    -- if stripe=10, add the STRIPE constraints
    -----------------------------------------------------
    IF @stripeno=10
    BEGIN
		SELECT @b1 = regionBinary FROM Region
		WHERE type='STRIPE' and regionid=@stripeid;
		--
		SET @bin = dbo.fSphIntersect(@bin,@b1);
    END
	--
	RETURN dbo.fSphSimplifyBinaryAdvanced(@bin,0,0,0,0);
END
GO

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- the stored procedures for boundary generation
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[spBoundaryStripe]') 
    and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure [dbo].[spBoundaryStripe]
GO
--
CREATE PROCEDURE spBoundaryStripe(@taskid int, @stepid int, @type varchar(16))
-------------------------------------------------------
--/H Insert the boundary of Stripe/Stave/Chunks into the db
--/A --------------------------------------------------
--/T Parameters:
--/T <li> @type varchar(16): one of 'CHUNK', 'STAVE' and 'STRIPE'
--/T Inserts the constraints corresponding to the
--/T boundary into the Boundary table.
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	IF @type NOT IN ('STRIPE','STAVE','CHUNK','PRIMARY') RETURN(1);
	------------------------
	-- clean up old version
	------------------------
	DELETE Region WHERE type=@type;
	DELETE RegionPatch WHERE type=@type;
	---------------------------------------------------
	DECLARE @count int, @msg varchar(1024);
	----------------------------------
	-- create temp tables
	----------------------------------
	CREATE TABLE #region (
		sid bigint,
		comment varchar(1000),
		bin varbinary(max)
	)
	--
	CREATE TABLE #stripetab (
		sid bigint,
		stripe int,
		comment varchar(1000),
		lmumin float,
		lmumax float
	)
	-----------------------------------------
	-- PRIMARY
	-----------------------------------------
	IF (@type='PRIMARY')
	BEGIN
		-------------------------
		-- create the temp tables
		-------------------------
		SELECT c.stripe as stripeno, r.id as sid,
			r.regionid as chunkid, s.regionid as staveid, 
			q.regionid as stripeid, 'primary region of chunk '
			+ LTRIM(cast(r.regionid as varchar(20)))+', stripe '
			+ LTRIM(cast(c.stripe as varchar(10))) comment
		INTO #chunk
		FROM Region r, Chunk c, Region s, Region q with (nolock)
		WHERE r.id=c.chunkid 
		  and r.type='CHUNK'
		  and s.type='STAVE'
		  and q.type='STRIPE'
		  and s.id = c.stripe
		  and q.id = c.stripe
		--
		IF (@@rowcount = 0)
		BEGIN
			SET @msg = 'spBoundaryPrimary needs CHUNK, STAVE and STRIPE'
			EXEC spNewPhase @taskID, @stepID, 'Boundary', 'ERROR', @msg;
			RETURN
		END
		--
		INSERT #region
		SELECT	sid, comment,
				dbo.fBoundaryPrimary(stripeno,chunkid,stripeid,staveid) as bin
		FROM #chunk
	END
	ELSE
	BEGIN
		-----------------------------------------------------
		-- CHUNK, STAVE or STRIPE
		-----------------------------------------------------
		-- CHUNK
		--------------------
		IF (@type='CHUNK')
		  BEGIN
			INSERT #stripetab
			SELECT	cast(chunkid as bigint) as sid, stripe,
					'from stripe '+cast(stripe as varchar(8)) comment,
					startmu/3600. as lmumin, endmu/3600. lmumax
			FROM Chunk
		  END
		--------------------
		-- STRIPE or STAVE
		--------------------
		IF (@type='STRIPE' OR @type='STAVE')
		  BEGIN
			INSERT #stripetab
			SELECT	stripe as sid, stripe, 
					'from stripe '+cast(stripe as varchar(8)) comment,
					lambdaMin lmumin, lambdaMax lmumax 
			FROM StripeDefs
		  END
		--------------------------
		-- save into #region
		--------------------------
		INSERT #region
		SELECT sid, comment,
				dbo.fBoundaryStripe(@type,sid,stripe,lmumin,lmumax) as bin
		FROM #stripetab
	END
	----------------------------------------------
	-- insert into the Region table
	----------------------------------------------
	INSERT Region
	SELECT sid, @type, comment, 0, dbo.fSphGetArea(bin), 
		dbo.fSphGetRegionString(bin), bin
	FROM (select sid, comment, bin from #region) q
	------------------------------------------
	-- also insert into the RegionPatch table
	------------------------------------------
	EXEC spRegionSync @type;
	------------------------------------------
	-- write the log message with the count
	------------------------------------------
	SELECT @count = count(*) FROM Region
	WHERE type=@type;
	--
	SET @msg = 'spBoundaryStripe created '+cast(@count as varchar(8))
		+' '+@type+' regions'
	EXEC spNewPhase @taskID, @stepID, 'Boundary', 'OK', @msg;
END
GO


--======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'spBoundaryPlate') 
    and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure spBoundaryPlate
GO
--
CREATE PROCEDURE spBoundaryPlate(@taskid int, @stepid int, @type varchar(16))
-------------------------------------------------------
--/H Insert the boundary of a Plate/Tile into the db
--/A --------------------------------------------------
--/T Inserts the constraints corresponding to the
--/T boundary into the Boundary table. It handles primary
--/T and secondary plates and tiles separately.
--/T <ul>
--/T <li>@type is the type (PLATE|TILE|PLATE2|TILE2),
--/T <li>@sid is the sqlid of the object, or 0, if abstract,
--/T <li>@platetile is the plate or tile number,
--/T <li>@ra is the righ ascension of the center,
--/T <li>@dec is the declination of the center,
--/T <li>@radius is the radius,</ul>
--/T all measured in degrees.
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	IF @type NOT IN ('PLATE', 'TILE', 'PLATE2','TILE2') RETURN(1);
	---------------------------------------------
	-- clean up Region tables before anything
	---------------------------------------------
	DELETE Region WHERE type=@type;
	DELETE RegionPatch WHERE type=@type;
	---------------------------------------------
	DECLARE @radius float, @msg varchar(1024), @count int;
	SELECT @radius=value FROM SDSSConstants WHERE name='tileRadius'
	--
	CREATE TABLE #platetab (
		type varchar(16),
		sid bigint,
		platetile smallint,
		ra float,
		dec float,
		radius float,
		isPrimary int,
		comment varchar(64)
	)
	--
	IF (@type='PLATE' OR @type='PLATE2')
	  BEGIN
	    INSERT #platetab
	    SELECT	@type as type, 
				plateid as sid, 
				plate as platetile,  
				ra, [dec],
				@radius as radius,
				isPrimary,
				@type + ' ' + cast(plate as varchar(8))
	    FROM PlateX
	  END
	--
	IF (@type='TILE' or @type='TILE2')
	  BEGIN
	    INSERT #platetab
	    SELECT	@type as type, 
				t.tile as sid, 
				t.tile as platetile,  
				t.raCen as ra, t.decCen as dec,
				@radius as radius,
				p.isPrimary,
				@type + ' ' + cast(t.tile as varchar(8))
	    FROM TileAll t, PlateX p
	    WHERE t.tile = p.tile
	  END
	---------------------------
	-- PRIMARY vs SECONDARY
	---------------------------
	IF (CHARINDEX('2',@type)=0)					-- primary
		DELETE #platetab WHERE isPrimary!=1
	ELSE										-- secondary
		DELETE #platetab WHERE isPrimary=1
	-----------------------------
	-- insert into Region
	-----------------------------
	INSERT Region(id,type,comment,ismask,area,regionString,regionBinary)
	SELECT	sid, @type, comment, 0, dbo.fSphGetArea(bin), 
			dbo.fSphGetRegionString(bin), bin
	FROM ( 
		select sid, platetile,comment,
			dbo.fBoundaryCircle(ra,dec,radius) as bin
		from #platetab
		) q
	------------------------------------------
	-- also insert into the RegionPatch table
	------------------------------------------
	EXEC spRegionSync @type;
	------------------------------------------
	SELECT @count=count(*) FROM Region WHERE type=@type;
	--
	SET @msg = 'spBoundaryPlate created '+cast(@count as varchar(8))
		+' '+@type +' regions'
	EXEC spNewPhase @taskID, @stepID, 'Boundary', 'OK', @msg;
	------------------------------------------
END
GO

--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'spBoundaryTiGeom') 
    and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure spBoundaryTiGeom
GO
--
CREATE PROCEDURE spBoundaryTiGeom(@taskid int, @stepid int, @type varchar(12))
-------------------------------------------------------
--/H Insert the boundary of all TilingGeometry objects
--/A --------------------------------------------------
--/T Inserts the constraints corresponding to the
--/T TilingGeometry into the Region and RegionPatch tables.
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @count int, @msg varchar(1024);
	--
	IF @type NOT IN ('TIGEOM','TIPRIMARY') RETURN(1);
	--
	DECLARE @tigeom TABLE (
		regionid bigint,
		sid bigint,
		ismask int,
		stave bigint,
		stripe bigint,
		stripeno int,
		comment varchar(1024)
	)
	--
	IF (@type='TIGEOM')
	BEGIN
		INSERT Region(id,type,comment,ismask,area,regionString,regionBinary)
		SELECT 
			sid, @type, comment,
			ismask, dbo.fSphGetArea(bin), dbo.fSphGetRegionString(bin),
			bin
		FROM ( select tilingGeometryid as sid, ismask, 
			@type + ' from  stripe '+cast(stripe as varchar(8)) comment,
			dbo.fBoundaryTiGeom(tilingGeometryId) as bin
			from TilingGeometry 
		) q
	END
	--
	IF (@type='TIPRIMARY')
	BEGIN
		SELECT @count = count(*)
		FROM REGION
		WHERE type='TIGEOM';
		--
		IF @count=0
		BEGIN
			SET @msg = 'TIPRIMARY cannot be run since no TIGEOM found';
			EXEC spNewPhase @taskID, @stepID, 'Boundary', 'WARNING', @msg;
			RETURN(1);
		END

		INSERT @tigeom
		SELECT 	r.regionid,
			r.id as sid,
			r.ismask,
			s.regionid as stave, 
			q.regionid as stripe,
			c.stripe as stripeno,
			'primary region of TIGEOM '
			+ LTRIM(cast(r.id as varchar(32)))+', stripe '
			+ LTRIM(cast(c.stripe as varchar(8))) comment
		FROM Region r, TilingGeometry c, Region s , Region q with (nolock)
		WHERE r.id=c.tilinggeometryid 
		  and r.type='TIGEOM'
	      and s.type='STAVE'
	      and q.type='STRIPE'
	      and s.id = c.stripe
	      and q.id = c.stripe;
		-------------------------
		INSERT Region(id,type,comment,ismask,area,regionString,regionBinary)
		SELECT 
			sid, @type, comment,
			ismask, dbo.fSphGetArea(bin), dbo.fSphGetRegionString(bin),
			bin
		FROM ( select sid, ismask, comment,
			dbo.fBoundaryTiPrimary(regionid,stave,stripe,stripeno) as bin
			from @tigeom
			) q
		WHERE q.bin is NOT NULL
	END
	------------------------------------------
	-- also insert into the RegionPatch table
	------------------------------------------
	EXEC spRegionSync @type;
	------------------------------------------
	-- write the log message with the count
	------------------------------------------
	SELECT @count = count(*) FROM Region
	WHERE type=@type;
	--
	SET @msg = 'spBoundaryTiGeom created '+cast(@count as varchar(8))
		+ ' ' + @type + ' regions';
	EXEC spNewPhase @taskID, @stepID, 'Boundary', 'OK', @msg;
END
GO

--==================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spBoundarySegment]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spBoundarySegment]
GO
--
CREATE PROCEDURE spBoundarySegment(@taskid int, @stepid int, @type varchar(16))
-------------------------------------------------------
--/H Insert the boundary of a Segment/Camcol into the db
--/A --------------------------------------------------
--/T Inserts the constraints corresponding to the boundary 
--/T into the Boundary table. The union of SEGMENTs should 
--/T recover the outline of the parent Chunk. Segments are 
--/T separated algorithmically in nu. A few Segments are 
--/T shifted slightly -- these corrections were captured 
--/T in the Runshift table, and propagated here. Camcol 
--/T outlines are computed from the actual astrometry.
--/T The union of the CAMCOLs of a given Run should return 
--/T the correct outline of all pixels in that Run.<br>
--/T Parameters:<br>
--/T <li>@type is the type (SEGMENT|CAMCOL|RUN)
--/T <samp>exec spBoundarySegment 0,0,'SEGMENT'</samp>
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @msg varchar(1024), @count int;
	DECLARE @psize float, @scan float;
	--
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	--
	IF @type NOT IN ('CAMCOL','RUN') RETURN(1);
	---------------------------------
	-- declare a #region table
	---------------------------------
	CREATE TABLE #region (
		id bigint,
		type varchar(12),
		comment varchar(1000),
		isMask int,
		area float,
		regionString varchar(max),
		regionBinary varbinary(max)
	)
	--------------------------------------------
	-- handle SEGMENT and CAMCOL first
	--------------------------------------------
	IF (@type='CAMCOL')
	BEGIN
		----------------------------------------
		-- fetch various constants
		----------------------------------------
		SELECT  @scan=value from SDSSConstants
			WHERE name='scanSeparation';
		SELECT  @psize=2048*value/3600.00 from SDSSConstants
			WHERE name='arcsecPerPixel';
		-------------------------------
		-- define temp table for pmts
		-------------------------------
		CREATE TABLE #segments (
			segmentid bigint PRIMARY KEY,
			comment varchar(1000),
			eta float,
			node float,	incl float,
			mumin float,mumax float,
			numin float,numax float
		)
		------------------------------------------
		-- use the actual numin of the CAMCOL
		------------------------------------------
		INSERT #segments
		SELECT 
			s.segmentid,
			'from stripe ' + cast(s.stripe as varchar(8)) 
			+ ' run ' + cast(s.run as varchar(8))
			+ ' camcol ' + cast(s.camcol as varchar(8)) comment,
			d.eta, s.node,s.incl,	
			s.startmu/3600.0 mumin,
			s.endmu / 3600.0 mumax,
			f.numin,
			f.numax
		FROM StripeDefs d, Segment s, (
			select	run, camcol, min(d_r) as numin, 
					max(d_r)+@psize as numax
			from Field group by run,camcol
		) f
		WHERE d.stripe=s.stripe
		  and s.run=f.run
		  and s.camcol=f.camcol
		ORDER BY s.segmentid
		----------------------------------
		-- insert into Region
		----------------------------------
		INSERT #region
		SELECT sid, @type, comment,0, dbo.fSphGetArea(bin), 
				dbo.fSphGetRegionString(bin),bin
		FROM ( select segmentid as sid, comment,
				dbo.fBoundarySegment(
					@type,eta,node,incl,
					mumin,mumax,numin,numax) as bin
			from #segments
		)q
		WHERE bin IS NOT NULL
	END
	--
	IF (@type = 'RUN')
	BEGIN
		DECLARE @runs TABLE (run int);
		--
		INSERT @runs
		SELECT distinct run
		FROM Segment
		--
		INSERT #region
		SELECT sid, @type, comment,
			0, 
			dbo.fSphGetArea(bin), dbo.fSphGetRegionString(bin),
			bin
		FROM ( select run as sid,
				'Run '+CAST(run as varchar(8)) comment,
				dbo.fBoundaryRun(run) as bin
			from @runs 
		)q
		WHERE bin IS NOT NULL
	END
	--------------------------
	-- into Region
	--------------------------
	INSERT Region
	SELECT * FROM #region
	------------------------------------------
	-- also insert into the RegionPatch table
	------------------------------------------
	EXEC spRegionSync @type;
	------------------------------------------
	-- write the log message with the count
	------------------------------------------
	--
	SELECT @count = count(*) FROM Region
	WHERE type=@type;
	--
	SET @msg = 'spBoundarySegment created '+cast(@count as varchar(8))
		+' '+@type +' regions'
	EXEC spNewPhase @taskID, @stepID, 'Boundary', 'OK', @msg;
	----------------------------------------------------
END
GO

--=================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[spBoundaryHole]') 
	AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[spBoundaryHole]
GO
--
CREATE PROCEDURE spBoundaryHole(@taskid int, @stepid int, @type varchar(16))
-------------------------------------------------------
--/H Compute the boundary of a field declared as a HOLE
--/A --------------------------------------------------
--/T If HOLE, will compute the intersection of the SEGMENT 
--/T boundaries, delimited by the upper and lower mu values 
--/T of the field primary region. If TIHOLE, it will also
--/T add the STAVE boundaries.
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @count int, @msg varchar(1024);
	--
	IF @type not in ('HOLE', 'TIHOLE') RETURN
	--
	IF (@type='HOLE')
	BEGIN
		------------------------------------------
		-- collect all the fields with quality=5
		------------------------------------------
		SELECT 	field, fieldid, segmentid,
				a_r+b_r*64 as mu1, 
				a_r+b_r*(1489-64) as mu2
		INTO #holes
		FROM Field
		WHERE quality=5
		ORDER BY segmentid
		------------------------------------------
		-- get pairs of consecutive hole fields
		------------------------------------------
		SELECT	h1.fieldid as f1, 
				h2.fieldid as f2,
				h1.segmentid
		INTO #pairs
		FROM #holes h1, #holes h2
		WHERE h1.segmentid=h2.segmentid
		  and h1.field+1=h2.field
		------------------------------------------
		-- find the heads of the runs
		------------------------------------------
		SELECT	identity(int,1,1) as id, 
				segmentid,fieldid, mu1, field
		INTO #head
		FROM #holes
		WHERE fieldid not in (select f2 from #pairs)
		ORDER BY segmentid, field
		------------------------------------------
		-- find the trailers of the runs
		------------------------------------------
		SELECT	identity(int,1,1) as id, 
				segmentid, fieldid, mu2, field
		INTO #trail
		FROM #holes
		WHERE fieldid  not in (select f1 from #pairs)
		ORDER BY segmentid, field
		----------------------------------
		-- assemble them into pairs
		----------------------------------
		SELECT h.segmentid, h.fieldid, h.mu1, t.mu2
		INTO #hruns
		FROM #head h, #trail t
		WHERE h.id=t.id
		----------------------------------
		-- collect the relevant regionids
		----------------------------------
		SELECT
			h.fieldid,
			s.node,s.incl,d.eta,
			h.mu1,h.mu2,
			r.regionBinary as segment,
			'from '
				+ LTRIM(cast(h.fieldid as varchar(24)))+', stripe '
				+ LTRIM(cast(s.stripe as varchar(8))) as comment
		INTO #holeset
		FROM #hruns h, Segment s, StripeDefs d, Region r
		WHERE h.segmentid=s.segmentid
		  and s.stripe = d.stripe
		  and r.type='SEGMENT'
		  and r.id = s.segmentid
		-------------------------------------
		-- now insert into the Region table
		-------------------------------------
		INSERT Region(id,type,comment,ismask,area,regionString,regionBinary)
		SELECT sid, 'HOLE', comment,
			0, 
			dbo.fSphGetArea(bin), dbo.fSphGetRegionString(bin),
			bin
		FROM ( select fieldid as sid,comment,
				dbo.fBoundaryField(segment,node,incl,eta,mu1,mu2) as bin
			from #holeset 
		)q
		WHERE bin IS NOT NULL
	END
	-----------------------
	-- END of HOLE branch
	-----------------------

	IF (@type='TIHOLE')
	BEGIN
		------------------------------------------------------
		-- get the holes and intersect them with their STAVE
		------------------------------------------------------
		SELECT f.fieldid, dbo.fSphIntersect(r.regionBinary,q.regionBinary) bin,
			r.comment
		INTO #tiholes
		FROM Region r, Field f, Segment s, Region q
		WHERE r.type='HOLE'
		  and r.id=f.fieldid
		  and f.segmentid=s.segmentid
		  and q.type='STAVE'
		  and q.id = s.stripe
		-------------------------------------
		-- now insert into the Region table
		-------------------------------------
		INSERT Region(id,type,comment,ismask,area,regionString,regionBinary)
		SELECT sid, 'TIHOLE', comment,
			0, 
			dbo.fSphGetArea(bin), dbo.fSphGetRegionString(bin),
			bin
		FROM ( 
			select fieldid as sid, bin, comment
			from #tiholes
			where bin is not null
			)q
	END

	------------------------------------------
	-- also insert into the RegionPatch table
	------------------------------------------
	EXEC spRegionSync @type;
	---------------------------------------------
	-- write diagnostic message
	---------------------------------------------
	SELECT @count=count(*) from Region with (nolock)
	WHERE type=@type;
	--
	SET @msg = 'spBoundaryHole created '+cast(@count as varchar(8))
		+' '+@type +' regions'
	EXEC spNewPhase @taskID, @stepID, 'Boundary', 'OK', @msg;
END
GO

--=============================================
IF EXISTS (select * from dbo.sysobjects 
	where name = N'spBoundaryFootprint' )
	drop procedure spBoundaryFootprint
GO
--
CREATE PROCEDURE spBoundaryFootprint(@taskid int, @stepid int)
-------------------------------------------------------------------------------
--/H Creates a footprint as the union of the PRIMARY regions
--/A --------------------------------------------------------------------------
--/T The regions consist of the primary areas of each CHUNK, and
--/T represent the footprint of the photometric primaries.
--/T <samp>EXEC spBoundary Footprint 0,0</samp>
-------------------------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @msg varchar(1024), @count int, @type varchar(12);
	SET @type='FOOTPRINT';
	-------------
	-- clean up
	-------------
	DELETE Region WHERE type=@type;
	DELETE RegionPatch WHERE type=@type;
		---------------------------------------------
		-- extract PRIMARY regions for recursion
		---------------------------------------------
		SELECT identity(int,1,1) id, regionBinary as bin
		INTO #queue FROM Region WHERE type='PRIMARY';
		------------------------------------
		-- recursive UNION into #footprint
		------------------------------------
		WITH CTE (id, bin) AS (
			select id, bin from #queue where id=1
			union all
			select b.id, dbo.fSphUnion(a.bin,b.bin) bin
			  from CTE a, #queue b where a.id+1=b.id
			)
		SELECT bin INTO #footprint
		FROM CTE WHERE id in (select max(id) from #queue)
		OPTION (MAXRECURSION 300)
		------------------------------------
		-- insert into the Region table
		------------------------------------
		INSERT Region
		SELECT 0,@type,'union of all PRIMARY',0,
			dbo.fSphGetArea(bin), dbo.fSphGetRegionString(bin), bin
		FROM #footprint
		------------------------------------------
		-- also insert into the RegionPatch table
		------------------------------------------
		EXEC spRegionSync @type;
	--------------------------------------------------------------------
	SELECT @count=count(*) FROM Region WHERE type=@type;
	--
	SET @msg = 'spBoundaryFootprint created '+cast(@count as varchar(8))
		+' '+@type+' regions'	
	EXEC spNewPhase @taskID, @stepID, 'Boundary', 'OK', @msg;
	--------------------------------------------------------------------
END
GO

--=====================================================
IF  EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[spBoundaryCreate]') 
		AND type in (N'P', N'PC'))
		DROP PROCEDURE [dbo].[spBoundaryCreate]
GO
--
CREATE PROCEDURE spBoundaryCreate(@taskid int, @stepid int)
-------------------------------------------------------
--/H Insert all boundaries in the survey into the Region and HalfSpace tables
--/A --------------------------------------------------
--/T Inserts the constraints corresponding to the
--/T boundary into the Region table. It goes through
--/T all of CHUNK, SEGMENT, CAMCOL, PLATE, TILE, TIGEOM
-------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	--
	EXEC spNewPhase @taskID, @stepID, 'Boundary', 'OK', 
		'Clearing Region/Sector tables'
	-----------------------------------
	-- delete F, I, keep K indices
	-----------------------------------
	EXEC spIndexDropSelection @taskid,@stepid,'F','REGION'
	EXEC spIndexDropSelection @taskid,@stepid,'I','REGION'
	EXEC spIndexBuildSelection @taskid,@stepid,'K','REGION'
	-----------------------------------------
	-- first make sure that we start clean
	-----------------------------------------
--	TRUNCATE TABLE Region
--	TRUNCATE TABLE RegionPatch
    TRUNCATE TABLE sdssSector
    TRUNCATE TABLE sdssSector2Tile
    TRUNCATE TABLE Region2Box
	TRUNCATE TABLE sdssBestTarget2Sector
	-------------------------------
	-- Init the rotation matrix
	-------------------------------
	DELETE RMatrix
	EXEC spBuildRmatrix
	-----------------------------------
	-- build all the basic boundaries
	-----------------------------------
	    ---------------------------------------------------------
	    -- The 'CHUNK', 'STRIPE', 'STAVE' boundaries and
	    -- the intersection of CHUNKs and STAVEs: 'PRIMARY'
	    ---------------------------------------------------------
		exec spBoundaryStripe 0,0, 'STRIPE';
		exec spBoundaryStripe 0,0, 'STAVE';
		exec spBoundaryStripe 0,0, 'CHUNK';
		exec spBoundaryStripe 0,0, 'PRIMARY'
	    ------------------------------------
	    -- build all PLATE and TILE regions
	    ------------------------------------
		exec spBoundaryPlate 0,0,'PLATE';
		exec spBoundaryPlate 0,0,'TILE';
		exec spBoundaryPlate 0,0,'PLATE2';
		exec spBoundaryPlate 0,0,'TILE2';
	    -----------------------------
	    -- build the TIGEOM objects
	    -----------------------------
		exec spBoundaryTiGeom 0,0, 'TIGEOM';
		exec spBoundaryTiGeom 0,0, 'TIPRIMARY';
	    --------------------------
	    -- SEGMENTs,CAMCOLs RUNs
	    --------------------------	
		exec spBoundarySegment 0,0,'SEGMENT';
		exec spBoundarySegment 0,0,'CAMCOL';
		exec spBoundarySegment 0,0,'RUN';
	    ---------------------------------
	    -- build HOLEs from the CAMCOLs
	    ---------------------------------
		exec spBoundaryHole 0,0, 'HOLE';
		exec spBoundaryHole 0,0, 'TIHOLE';
	    ---------------------------------
	    -- build FOOTPRINT
	    ---------------------------------
		exec spBoundaryFootprint 0,0;
	-------------------------------------------------------
	EXEC spNewPhase @taskID, @stepID, 'Boundary', 'OK', 
		'Boundary creation finished'
	----------------------------------------------------------
END
GO

--------------------------------------------------------
PRINT '[spBoundary.sql]: Boundary procedures created'
--------------------------------------------------------
GO

