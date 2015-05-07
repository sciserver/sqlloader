--=========================================================
--   spRegion.sql
--
--   2004-01-10 Jim Gray, Alex Szalay, Gyorgy Fekete
--	 2007-06-11 Alex Szalay, major overhaul
-----------------------------------------------------------
--  SkyServer Region based functions and procedures
--  Uses the tables: Region, RegionConvex, HalfSpace
-----------------------------------------------------------
--  Token manipulation functions:
-----------------------------------
--	fTokenNext				-- get next token in string
--	fTokenAdvance			-- get offset of next token in string
--	fTokenStringToTable		-- returns a table of tokens in string
--	fNormalizeString		-- cleans up a string into normal form
-----------------------------------
--  Region core functions:
-----------------------------------
--  fRegionFuzz				-- compute tilted halfpane for buffer
--  fRegionOverlapId		-- overlap of two existing regions
--  spRegionAnd				-- create new region with intersection
--  spRegionCopy			-- create new region from copy
--  spRegionDelete			-- clear region and associated tables
--  spRegionIntersect		-- intersect first region with second
--  spRegionNew				-- create new empty region
--  spRegionSubtract		-- subtract second region from first
--  spRegionSync			-- sync up teh RegionPacth table
-----------------------------------
-- Region-based search functions:
-----------------------------------
--	fRegionContainsPointEq		-- true if region contains point
--	fRegionContainsPointXYZ		-- true if region contains point
--	fRegionGetObjectsFromRegionId	-- fetch objects from region
--	fRegionGetObjectsFromString	-- fetch objects from region
--	fRegionsContainingPointEq	-- list regions containing point
--	fRegionsContainingPointXYZ	-- list regions containing point
----------------------------------------------------------------------------------
-- History:
--* 2004-03-25 Jim: replace RegionConvexString with RegionConvex table. 
--* 2004-02-12 Jim: started
--* 2004-02-07 Jim: revised to conform to Region-Convex design
--* 2004-03-01 Jim & Alex: revised root code, many small changes.
--* 		    Ignores isMask flag on regions (treates all regions as positive).
--* 2004-03-18 Alex: fixed fRegionToArcs, propsagated bunch of other changes from Jim
--*		    discarded spHtmSiplifyRegionid
--* 2004-03-25 Jim: RegionConvexString -> RegionConvex table
--* 2004-03-29 Alex: retired fRegionsToRootsForExcel and fRegionConvexFromString
--* 2004-03-29 Alex: added fRegionAreaSphTriangle
--* 2004-04-24 Alex: removed fRegionToRoots, fRegionConvexToRoots, replaced them with 
--*		    fRegionConvexStringToArcs, fRegionStringToArcs, fRegionToArcs.
--*		    Added fRegionConvexBCircle
--* 2004-05-06 Alex: Fixed c<=-1 bug in fRegionConvexToArcs
--* 2004-05-06 Alex: merged with spRegionGet.sql
--* 2004-05-20 Alex: added @stripe to spRegionNibbles, to compute
--*		    the orientation of the universe
--* 2004-05-20 Alex: Fixed a bug in the bounding circle part of fRegionConvexToArcs
--* 2004-05-24 Alex: Added fill RegionArcs to spRegionSimplify, and the cleanup
--*		    to spRegionDelete
--* 2004-05-26 Alex: Modified spRegionUnify to update RegionArcs if anything changed.
--* 2004-05-30 Alex: Moved spRegionNibbles to spSector.sql
--* 2004-05-30 Alex+Jim: added arcs copy to end of spRegionCopy
--* 2004-08-25 Alex: added various containment functions
--* 2004-10-21 Alex: moved RegionArcs to top in spRegionDelete to avoid foreign key conflicts.
--* 2004-10-26 Alex: added spRegionCopyFuzz
--* 2004-11-22 Alex: added flag=32 for PhotoObjAll to fRegionGetObjects*.
--* 2004-12-27 Alex: added fRegionSimplifyString call to fRegionStringToArcs
--* 2005-01-02  Alex: fixed a few small bugs in fRegionStringToArcs, now patch number is
--*			correct, and @regionid is set to zero in OR. Also turned fRegionToArcs
--*			into a wrapper for fRegionStringToArcs.
--* 2005-01-02 Alex: added buffer to fRegionFromString, also calls now fRegionSimplifyString.
--*			Modifed RegionGetObjectsFromString and fRegionConvexToArcs accordingly.
--*			Also changed return column names to xy,z from cx,cy,cz.
--* 2005-01-02 Alex: moved arc length computation into fRegionConvexToArcs. Modified 
--*			fRegionStringToArcs and fRegionToArcs accordingly.
--* 2005-01-02 Alex: modified fRegionConvexBCircle
--* 2005-01-03 Alex: changed fRegionSimplifyString to fRegionNormalizeString to reflect more
--*			what the function is doing.
--* 2005-01-03 Alex: changed fRegionsOverlapRegion to fRegionOverlap with a modified
--*			algorithm.
--* 2005-01-04 Alex: renamed fRegionConvexBCircle to fRegionConvex, modifed spRegionSimplify
--*			accordingly.
--* 2005-01-05 Alex: fixed small bug in fRegionConvexToArcs related to removal of almost
--*			identical constraints. Delete redundant constraints now.
--* 2005-01-05 Alex: added fRegionConvexFromString to compute bounding circle dynamically.
--* 2005-01-05 Alex: added rejection of (A-A)=NULL convex to fRegionConvexToArcs.
--* 2005-01-09 Alex: fiex a bug with single circles in fRegionConvex
--* 2005-01-22 Alex: Added fRegionOverlapString function
--* 2005-01-23 Alex: changed tolerance in fRegionsConvexStringToArcs
--* 2005-01-25 Alex: fixed bug in fRegionConvexToArcs where the tsate of a halfspace constraint
--*			was ignored during rejection tests.
--* 2005-01-26 Alex: added fRegionOverlapId
--* 2005-02-01 Alex: fixed Halfspace search bug in fRegionGetObjectsXX
--* 2005-02-02 Alex: modified spRegionContainsPointxxx to improve on the region test, added
--*			bounding circle test to fRegionsContainingPointxxx
--* 2005-03-06 Alex: added TOP 1 clause to the bounding circle generation in
--*			spRegionConvexToArcs
--* 2005-03-10 Alex: Added fRegionBoundingCircle, added patch to RegionConvex, and modified
--*			spRegionSimplify and the fRegionOverlap functions accordingly. Added
--*			test for single circles to fRegionBoundingCircle
--* 2005-03-12 Alex: Fixed triplet elimination bug in fRegionBoundingCircle.
--* 2005-03-13 Alex: Added tentative fFootprintEq function
--* 2005-03-19 Alex+Jim: Added fRegionArcLength and fixed bugs in RegionConvexToArcs
--* 2005-04-02 Alex: added patch to PK on the @convex table in the overlap functions.
--* 2005-04-08 Alex: Fixed small bug in the fRegionOverlap* functions
--* 2005-04-11 Alex: Added area functions: fRegionAreaTriangle, fRegionAreaSemiLune and
--*			fRegionAreaPatch. Also added area calculation to spRegionSimplify.
--* 2005-04-12 Alex: Added test for changes in HalfSpace in spRegionSimplify. If changed,
--*			recompute arcs.
--* 2005-04-13 Alex: added Sector2Tile and Region2Box to spRegionDelete
--* 2005-05-14 Alex: Removed spRegionCopyFuzz, spRegionNewConvex, spRegionNewConvexConstraint.
--*			Inlined call to fDistanceArcminXYZ in fGetRegionsContainingPointXYZ.
--*			Modified spRegionUnify to return change status only, and
--*			moved RegionArcs update entirely to spRegionSimplify.
--* 2006-12-22 Ani: Modified last section of fRegionGetObjectsFromString to
--*                 use a temp table to avoid sql2k5 problem.
--* 2007-01-03 Ani: Replaced call to fHtmLookupXYZ with fHtmXyz (C# equiv.)
--*                 in fRegionBoundingCircle.
--* 2007-01-09 Ani: Replaced fHtmToNormalForm call with the new C# HTM
--*                 equivalent, fHtmRegionToNormalFormString, in 
--*                 fRegionNormalizeString.
--* 2007-01-16 Ani: Modified fRegionFromString to look for region string
--*                 form 'REGION CONVEX CARTESIAN ...' in the C# HTM instead
--*                 of 'REGION CONVEX ...'.  Not sure if the check for
--*                 token 'CONVEX' should be removed or left in (are there
--*                 still some cases of the old syntax?).
--* 2007-01-23 Ani: Added a check to fRegionConvexToArcs for number of new
--*                 roots inserted in WHILE loop, with a break out of the
--*                 if the number is 0 to avoid an infinite loop.  See new
--*                 @newroots variable.  This needs to be checked by the
--*                 experts when the region code is overhauled for SQL 2005.
--* 2007-01-29 Ani: Added TILEBOX/SECTOR/SECTORLET/SKYBOX/WEDGE to list of
--*                 possible region types in function descriptions.
--* 2007-01-31 Ani: Fixed a couple of typos in function descriptions.
--* 2007-06-04 Ani: Applied Svetlana's changes to fRegionAreaSemiLune and
--*                 fRegionBoundingCircle to avoid out of range errors.
--*                 Also changed fHtmCover calls to fHtmCoverRegion.
--* 2007-06-11 Alex: deleted fRegionArcLength, fRegionAreaPatch, fRegionAreaSemilune,
--*				fRegionAreaTrinagle, fRegionBoundingCircle, fRegionConvexIdToString,
--*				fRegionConvexToArcs, fRegionFromString, fRegionIdToString,
--*				fRegionNormalizeString, fRegionNot, fRegionOverlap, fRegionOverlapString,
--*				fRegionPredicate, fRegionStringToArcs, fRegionToArcs, spRegionNot,
--*				spRegionOr, spRegionSimplify, spRegionUnify
--* 2007-08-20 Ani: Fixed typo in spRegionIntersect ("dbp" instead of "dbo").
--* 2011-06-06 Ani: Incorporate Tamas's changes to fix fFootprintEq.
--* 2011-06-08 Ani: Updated fPolygonsContainiingPointXYZ to use temp table
--*                 for HTM range to speed it up a la nearby functions.
--*                 Also removed refs to "sph" schema (replaced with dbo).
--* 2011-11-23 Ani: Added new scalar version of fFootprintEq: fInFootprintEq
--*                 which can be used in the SELECT clause and returns a bit
--*                 value (1 = in SDSS footprint, 0 = not in footprint).
--* 2012-11-15 Ani: Added 2 new fuctions from Alex: fRegionsIntersectingBinary,
--*                 and fRegionsIntersectingString..
--* 2012-12-17 Ani: Added sample usage for fInFootprintEq.
--* 2013-09-16 Ani: Updated fSphGrow call in fPolygonsContainiingPointXYZ to
--*                 specify the search radius in degrees instead of arcmin. 
--* 2013-09-17 Ani: Updated fSphGrow call in fPolygonsContainiingPointXYZ 
--*                 again to include offset for polygon center after 
--*                 checking with Tamas (Budavari).
--* 2013-09-27 Ani: Updated fPolygonsContainiingPointXYZ to remove offset
--*                 in radius passed to fSphGrow.
--* 2013-10-23 Ani: Updated fPolygonsContainingPointXYZ to reinstate offset,
--*                 and did a global replace of "dbo.fSph" with "sph.f" to
--*                 make the Spherical lib calls compatible with the latest
--*                 version. 
--* 2014-12-16 Ani: Updated fFootprintEq and fInFootprintEq with Tamas's
--*                 fix so that only primary area is included.
--=============================================================================
SET NOCOUNT ON
GO

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- string and token manipulation functions
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--====================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fTokenNext]'))
	drop function [dbo].[fTokenNext]
GO
--
CREATE FUNCTION fTokenNext(@s VARCHAR(8000), @i int) 
RETURNS VARCHAR(8000)
-------------------------------------------------------------
--/H Get token starting at offset @i in string @s
-------------------------------------------------------------
--/T Return empty string '' if none found
--/T <br><samp>
--/T <br>select dbo.fTokenNext('REGION CONVEX 3 5 7 ',15 ) 
--/T <br> returns                    '3'
--/T </samp>
--/T <br> see also fTokenAdvance()  
-------------------------------------------------------------
AS
BEGIN
	DECLARE @j INT
	-----------------------------
	-- eliminate multiple blanks
	-----------------------------
	SET @j = charindex(' ',@s,@i)
	IF (@j >0) RETURN ltrim(rtrim(substring(@s,@i,@j-@i)))
	RETURN ''
	END

GO


--=====================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fTokenAdvance]'))
	drop function [dbo].[fTokenAdvance]
GO
--
CREATE FUNCTION fTokenAdvance(@s VARCHAR(8000), @i int) 
RETURNS INT
-------------------------------------------------------------
--/H Get offset of next token after offset @i in string @s
-------------------------------------------------------------
--/T Return 0 if none found.
--/T <br><samp>
--/T <br>select dbo.fTokenNext('REGION CONVEX 3 5 7 ',15 ) 
--/T <br> returns                    '3'
--/T </samp>
--/T <br> see also fTokenNext()  
-------------------------------------------------------------
AS
BEGIN
	DECLARE @j int;
	-----------------------------
	-- eliminate multiple blanks
	-----------------------------
	SET @j = charindex(' ',@s,@i)
	IF (@j >0) RETURN @j+1
	RETURN 0
END
GO


--=====================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fTokenStringToTable]'))
	drop function [dbo].[fTokenStringToTable]
GO
--
CREATE FUNCTION fTokenStringToTable(@types VARCHAR(8000)) 
RETURNS @tokens TABLE (token VARCHAR(16) NOT NULL)
-------------------------------------------------------------
--/H Returns a table containing the tokens in the input string
-------------------------------------------------------------
--/T Tokens are blank separated.
--/T <samp>select * from dbo.fTokenStringToTable('A B C D E F G H J') 
--/T <br> returns                    a table containing those tokens
--/T </samp>  
-------------------------------------------------------------
AS
BEGIN  
	DECLARE @tokenStart int;
	SET @tokenStart = 1
	SET @types = dbo.fNormalizeString(@types)  
	WHILE (ltrim(dbo.fTokenNext(@types,@tokenStart)) != '')
	BEGIN
		INSERT @tokens VALUES(dbo.fTokenNext(@types,@tokenStart)) 
    	SET    @tokenStart = dbo.fTokenAdvance(@types,@tokenStart)
	END
	RETURN
END
GO


--=====================================================
IF EXISTS ( select * from sysobjects 
	where id = object_id(N'fNormalizeString')) 
	drop  function fNormalizeString
GO
--
CREATE FUNCTION fNormalizeString(@s VARCHAR(8000)) 
RETURNS VARCHAR(8000)
-------------------------------------------------------------
--/H Returns string upshifted, squeezed blanks, trailing zeros 
--/H removed, and blank added on end
-------------------------------------------------------------
--/T <br>select dbo.fNormalizeString('Region Convex   3.0000   5  7') 
--/T <br> returns                    'REGION CONVEX 3.0 5 7 '
--/T </samp>  
-------------------------------------------------------------
AS	
BEGIN
	DECLARE @i int;
	-----------------------------------------------------
	-- discard leading and trailing blanks, and upshift
	-----------------------------------------------------
	SET @s = ltrim(rtrim(upper(@s))) + ' '
	---------------------------
	-- eliminate trailing zeros
	---------------------------
	SET @i = patindex('%00 %', @s)
	----------------------
	-- trim trailing zeros
	----------------------
	WHILE(@i >0)			
 	BEGIN
 		SET @s = replace(@s, '0 ', ' ') 
 		SET @i = patindex('%00 %', @s)
 	END
	----------------------------
	-- eliminate multiple blanks
	----------------------------
	SET @i = patindex('%  %', @s)
	---------------------
	-- trim double blanks
	---------------------
	WHILE(@i >0)			
 	BEGIN
 		SET @s = replace(@s, '  ', ' ')
 		SET @i = patindex('%  %', @s)
 	END
	------------------
	-- drop minus zero
	------------------
 	SET @s = replace(@s, '-0.0 ', '0.0 ') 
	RETURN @s 
END
GO


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Region core routines
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--=========================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRegionFuzz]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fRegionFuzz]
GO
--
CREATE FUNCTION fRegionFuzz(@d float, @buffer float) 
RETURNS float
-------------------------------------------------------------
--/H Returns a displacement that expands a circle by the "buffer"
-------------------------------------------------------------
--/T Buffer is the expansion in arc minutes
--/T Result is range limited to [-1 .. 1]
--/T <br>  The following exampe adds 1 minute fuzz to the hemisphere.
--/T <samp>select dbo.fRegionFuzz(0,1)       
--/T </samp>  
-------------------------------------------------------------
AS  BEGIN 
	DECLARE @fuzzR float;
	SET @fuzzR = RADIANS(@buffer/60.00000000);
	-----------------------------------------
	-- convert it to a normal form (blank separated trailing blank, upper case)
	-----------------------------------------
	IF @d >  1 SET @d = 1
	IF @d < -1 SET @d = -1
	SET @d = CASE 	WHEN ACOS(@d) + @fuzzR <PI() 
		  	THEN COS(ACOS(@d)+@fuzzR) 
		  	ELSE -1 
		 END 
	RETURN @d
END
GO


--============================================
IF  EXISTS (SELECT * FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[fRegionOverlapId]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fRegionOverlapId]
GO
--
CREATE FUNCTION fRegionOverlapId(@regionid bigint,
	@otherid bigint, @buffer float)
--------------------------------------------------------
--/H Returns the overlap of a given region overlapping another one
--/U ---------------------------------------------------
--/T The parameters
--/T <li>@regionid is the region we want to intersect with
--/T <li>@otherid is the region of interest 
--/T <li>@buffer is the amount the regionString is grown in arcmins.</li>
--/T <br>Returns a blob with the overlap region,
--/T <br>NULL if there are no intersections,
--/T <br>NULL if input params are bad.
--/T <samp>
--/T SELECT * from fRegionOverlapId(1049,6078,0.0)
--/T </samp>
--------------------------------------------------------
RETURNS varbinary(max) 
AS BEGIN
	----------------------------------------------------
	-- representation of the input region after the fuzz
	----------------------------------------------------
	RETURN (
		SELECT  sph.fIntersect(a.regionBinary,
			sph.fGrow(b.regionBinary,@buffer/60.0)) bin
		FROM Region a, Region b
		WHERE a.regionid=@regionid
			and b.regionid=@otherid
	)
END
GO


--=====================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'spRegionDelete')) 
	drop  procedure spRegionDelete
GO
--
CREATE PROCEDURE spRegionDelete( @regionID bigint)
-------------------------------------------------------------
--/H Delete a region and all its convexes and constraints
--/A --------------------------------------------------------
--/T Parameters:
--/T <li> regionID bigint     	ID of the region to be deleted
--/T <br>Sample call to delete a region 
--/T <br><samp>
--/T  <br> exec spRegionDelete @regionID 
--/T  </samp>
--/T <br> see also spRegionNew, spRegionDelete,...  
------------------------------------------------------------- 
AS 
BEGIN
	SET NOCOUNT ON;
	--
	DELETE RegionPatch WHERE regionID = @regionID
	DELETE Sector2Tile WHERE regionid=@regionID
	DELETE Region2Box WHERE boxid=@regionID
	DELETE Region WHERE regionID = @regionID
	RETURN 0
END
GO


--=====================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'spRegionNew')) 
	drop  procedure spRegionNew
GO
--
CREATE PROCEDURE spRegionNew (@id bigint, @type varchar(16),
		@comment varchar(8000),@isMask	int)
-------------------------------------------------------------
--/H Create a new region, return value is regionID 
--/A --------------------------------------------------------
--/T <br>Parameters:
--/T <li> id      bigint        key of object in its source table (e.g. TileID)
--/T <li> type    varchar(16)   short description of the region (e.g. stripe)
--/T <li> comment varchar(8000) longer description of the region 
--/T <li> isMask  int           flag says region is negative (a mask)
--/T <br> returns regionID int  the unique ID of the region.
--/T <br>Sample call get a new region 
--/T <br><samp>
--/T  <br> exec @regionID = spRegionNew 12345, 'STRIPE', 'Stripe 12345', 0 
--/T  </samp>
--/T <br> see also fRegionPredicate, spRegionDelete,...  
------------------------------------------------------------- 
AS
BEGIN
	SET NOCOUNT ON;
	--
	INSERT Region VALUES(@id, @type, @comment, @isMask, 0, '', NULL)
	RETURN @@identity
END
GO


--=====================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'spRegionAnd')) 
	drop  procedure spRegionAnd
GO
--
CREATE PROCEDURE spRegionAnd (@id bigint,@d1 bigint, @d2 bigint, 
		@type varchar(16), @comment varchar(8000) )
-------------------------------------------------------------
--/H Create a new region containing intersection (AND) of regions d1 and d2.
-------------------------------------------------------------
--/T The new region will contain copies of the intersections of each pair of 
--/T convexes in the two original regions.
--/T <br>Parameters:
--/T <li> id bigint        key of object in its source table (e.g. TileID)
--/T <li> d1 bigint        ID of the first region.
--/T <li> d2 bigint        ID of the second region.
--/T <li> type varchar(16)     	short description of the region (e.g. stripe)
--/T <li> comment varchar(8000) longer description of the region  
--/T <br> returns regionID int  the unique ID of the new region.
--/T <br>Sample call get intersection of two  regions 
--/T <br><samp>
--/T  <br> exec @regionID = spRegionAnd @d1, @d2, 'stripe', 'run 1 2 3' 
--/T  </samp>
--/T <br> see also spRegionNew, spRegionOr, spRegionNot, spRegionDelete,...  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @regionid bigint;
	-----------------------------------
	INSERT Region(id,type,comment,isMask,area,regionString,regionBinary)
	SELECT @id, @type, @comment, 0,
		sph.fGetArea(bin),
		sph.fGetRegionString(bin), bin
	FROM (
		select sph.fIntersectAdvanced(
			r1.regionBinary,r2.regionBinary,0) bin
		from Region r1, Region r2
		where r1.regionid=@d1
		  and r2.regionid=@d2
		) q
	WHERE bin is not null;
	SET @regionid=@@identity;
	-------------------------------
	IF (@regionid is null) RETURN 0;
	--------------------------------
	RETURN @regionid;
END
GO


--=====================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'spRegionIntersect')) 
	drop  procedure spRegionIntersect
GO
--
CREATE PROCEDURE spRegionIntersect(@baseID bigint,@interID bigint)
-------------------------------------------------------------
--/H Intersect a base region with a second region  
--/A -----------------------------------------------------------
--/T The surviving region contains the intersections of each pair of 
--/T convexes in the two regions. The base region is overwritten.
--/T <br>Parameters
--/T <li> @baseID bigint:   regionID of the region to be masked
--/T <li> @interID bigint:  regionID of the masking region.
--/T <br> returns count of convexes in the resulting @baseID
--/T <br>Sample call get intersection of two  regions 
--/T <br><samp>
--/T  <br> exec @convexes = spRegionIntersect @Tile, @Mask 
--/T  </samp>
--/T <br> see also spRegionNew, spRegionOr, spRegionNot, spRegionDelete,...  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON;
	-----------------------------------
	UPDATE Region
		SET area = sph.fGetArea(q.bin),
			regionString=sph.fGetRegionString(q.bin),
			regionBinary=bin
	FROM Region r, (
			select a.regionid, 
				sph.fIntersect(a.regionBinary,i.regionBinary) bin
			from Region a, Region i
			where a.regionid=@baseid
			  and i.regionid=@interID
		) q
	WHERE r.regionid=@baseID
	  and q.regionid=@baseid
	  and q.bin is not null;
	-------------------------------
	-- test, if empty
	-------------------------------
	IF (@@rowcount=0)
	BEGIN
		EXEC spRegionDelete @baseID;
		RETURN 0;
	END
	-------------------------------------
	-- synchronize
	-------------------------------------
	DECLARE @count int;
	SELECT	@count=count(distinct p.convexid)
	  FROM Region r CROSS APPLY sph.fGetPatches(regionBinary) p
	  WHERE r.regionid=@baseID;
END
GO


--=====================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'spRegionSubtract')) 
	drop procedure spRegionSubtract 
GO
--
CREATE PROCEDURE spRegionSubtract(@baseID  bigint,@subID bigint)
-------------------------------------------------------------
--/H  Subtract the areas of one region from a second region, and update first
--/A --------------------------------------------------------
--/T <p> parameters:   
--/T <li> @baseID bigint: region to subtract from 
--/T <li> @subID bigint:  region to remove from base
--/T <li> returns number of convexes in region. 
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec @convexes = spRegionSubtract @RegionID, @maskID
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS
BEGIN
	SET NOCOUNT ON;
	-----------------------
	-- update the Region
	-----------------------
	UPDATE r
		SET area = coalesce(sph.fGetArea(bin),-1),
		regionString =sph.fGetRegionString(bin), 
		regionBinary = bin
	FROM Region r, (
		select sph.fDiff(r1.regionBinary,r2.regionBinary) bin
		from Region r1, Region r2
		where r1.regionid=@baseID
		  and r2.regionid=@subID
		) q
	WHERE r.regionid = @baseID
	  and q.bin is not null;
	-------------------------------
	-- test, if empty
	-------------------------------
	IF (@@rowcount=0)
	BEGIN
		EXEC spRegionDelete @baseID;
		RETURN 0;
	END
	-----------------------------
	-- get count of convexes
	-----------------------------
	DECLARE @count int;
	SELECT	@count=count(distinct p.convexid)
	FROM Region r CROSS APPLY sph.fGetPatches(regionBinary) p
	WHERE r.regionid=@baseID;
	RETURN  @count;
END
GO


--=====================================================
IF EXISTS (select * from sysobjects 
	where id = object_id(N'spRegionCopy')) 
	drop  procedure spRegionCopy
GO
--
CREATE PROCEDURE spRegionCopy (
				@id bigint,
				@regionID  bigint, 
				@type varchar(16), 
				@comment varchar(8000)
)
-------------------------------------------------------------
--/H Create a new region containing the convexes of region  @regionID   
--/A --------------------------------------------------------
--/T The new region contains a copy of the convexes of the original regions 
--/T <br>Parameters:
--/T <li> id  bigint        	key of object in its source table (e.g. TileID)
--/T <li> regionID bigint     	regionID of the  region.
--/T <li> type varchar(16)      short description of the region (e.g. stripe)
--/T <li> comment varchar(8000) longer description of the region  
--/T <br> returns regionID int  the unique ID of the new region.
--/T <br>Sample copy of a region regions 
--/T <br><samp>
--/T  <br> exec @newregionID = spRegionCopy @newID, @oldregionID,  'stripe', 'run 1 2 3'  
--/T  </samp>
--/T <br> see also spRegionNew, spRegionAnd, spRegionNot, spRegionDelete,...  
------------------------------------------------------------- 
AS 
BEGIN 
	SET NOCOUNT ON;
	DECLARE @newid bigint;
	--
	INSERT Region
	SELECT @id, @type, @comment, isMask, area, regionString, regionBinary
	FROM Region
	WHERE regionid = @regionid;
	SET @newid=@@identity;
	-------------------------------
	IF (@newid is null) RETURN 0;
	---------------------
	RETURN  @newid;
END
GO

--========================================================
IF  EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[spRegionSync]') 
		AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[spRegionSync]
GO
--
CREATE PROCEDURE spRegionSync(@type varchar(12))
--------------------------------------------------------------------------
--/H Will synchronize RegionPatch with the Regions of a certain type
--/A ---------------------------------------------------------------------
--/T Inserts the patches from the regionBinary
------------------------------------------------------
AS
BEGIN
	--------------------------------------------
	-- delete the old RegionPatch entries
	--------------------------------------------
	DELETE RegionPatch WHERE type=@type;
	-------------------------------------------------
	-- get the regionBinary, and insert the convexes
	-------------------------------------------------
	INSERT RegionPatch
	SELECT	r.regionid, p.convexid, p.patchid, r.type, 
			p.radius, p.ra, p.dec,
			p.x, p.y, p.z, p.c, p.htmid,p.area,
			cast(p.convexString as varchar(max)) convexString
	FROM Region r CROSS APPLY sph.fGetPatches(regionBinary) p
	WHERE r.type=@type;
	--------------------------------
	RETURN @@rowcount;
END
GO


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- High level spatial search functions
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


--==================================================
if exists (select name FROM sysobjects 
	where name = N'fRegionContainsPointXYZ' )
	drop function fRegionContainsPointXYZ
GO
--
CREATE FUNCTION fRegionContainsPointXYZ(@regionID bigint,@cx float,@cy float,@cz float)
-------------------------------------------------------------
--/H Returns 1 if specified region contains specifed x,y,z 
--/H point, else returns zero.
-- -----------------------------------------------------------
--/T There is no limit on the number of objects returned, but 
--/T there are about 40 per sq arcmin.  
--/T <p> parameters 
--/T <li> regionid bigint,     -- Region object identifier
--/T <li> cx float NOT NULL,   -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <br>
--/T Sample call to find if regionID 345 contains the North Pole<br>
--/T <samp> 
--/T <br> select dbo.fRegionContainsPointXYZ(7,0,0,1)  
--/T </samp> 
--/T <br> see also fRegionContainsPointEq  
-------------------------------------------------------------
RETURNS bit 
AS  
BEGIN	
	IF EXISTS (
		select convexid from Halfspace
		where regionid=@regionid
		  and convexid not in (
			select convexid from HalfSpace h
			where regionid=@regionid
			and @cx*h.x+@cy*h.y+@cz*h.z<h.c 
			)
	) RETURN 1
	--
	RETURN 0
END
GO

--==========================================
if exists (select name FROM sysobjects 
	where  name = N'fRegionContainsPointEq' )
	drop function fRegionContainsPointEq
GO
--
CREATE FUNCTION fRegionContainsPointEq(@regionID  bigint, @ra float,@dec float)
-------------------------------------------------------------
--/H Returns 1 if specified region contains specified ra,dec 
--/H point, else returns zero.
-- ----------------------------------------------------------
--/T There is no limit on the number of objects returned, 
--/T but there are about 40 per sq arcmin.  
--/T <p>  parameters 
--/T <li> regionid bigint 	 -- Region object identifier
--/T <li> ra float NOT NULL,     -- Right ascension, --/U degrees
--/T <li> dec float NOT NULL,     -- Declination,     --/U degrees
--/T <br>
--/T Sample call to find if regionID 345 contains the North Pole<br>
--/T <samp> 
--/T <br> select dbo.fRegionContainsPointEq(7,0,90)  
--/T </samp> 
--/T <br> see also fRegionContainsPointXYZ
------------------------------------------------------------- 
RETURNS bit 
AS  
BEGIN
	DECLARE @cx float,@cy float,@cz float;
	SET @cx  = COS(RADIANS(@dec))*COS(RADIANS(@ra))
	SET @cy  = COS(RADIANS(@dec))*SIN(RADIANS(@ra))
	SET @cz  = SIN(RADIANS(@dec))	
	IF EXISTS (
		select convexid from Halfspace
		where regionid=@regionid
		  and convexid not in (
			select convexid from HalfSpace h
			where regionid=@regionid
			and @cx*h.x+@cy*h.y+@cz*h.z<h.c 
			)
	) RETURN 1
	--
	RETURN 0
END
GO
--


--======================================================
if exists (select name FROM sysobjects 
	where  name = N'fRegionGetObjectsFromRegionId' )
	drop function fRegionGetObjectsFromRegionId
GO
--
CREATE FUNCTION fRegionGetObjectsFromRegionId( @regionID  bigint, @flag int)
-------------------------------------------------------------
--/H Returns various objects within a region given by a regionid
--/U ---------------------------------------------------
--/T <p> returns a table of two columns
--/T <br> objID bigint          -- Object ID from PhotoObjALl,  
--/T <br> flag int		-- the flag of the object type<br>
--/T (@flag&1)>0 display specObj<br>
--/T (@flag&2)>0 display photoPrimary<br>
--/T (@flag&4)>0 display Target <br>
--/T (@flag&8)>0 display Mask<br>
--/T (@flag&32)>0 display photoPrimary and secondary<br>
--/T thus: @flag=7 will display all three of specObj, PhotoObj and Target
--/T the returned objects have 
--/T          flag = (specobj:1, photoobj:2, target:4, mask:8)
--/T <br>Sample call to find all objects in region 75<br>
--/T <samp> 
--/T select * from dbo.fRegionGetObjectsFromRegionID(75,15)  
--/T </samp> 
--------------------------------------------------------
RETURNS  @objects table (id bigint NOT NULL, flag int NOT NULL, PRIMARY KEY(flag,id) )
AS  
BEGIN	
		DECLARE @area varchar(8000);
		------------------------------------
		-- fetch the regionString
		------------------------------------
		SELECT @area = regionString FROM Region with (nolock)
		WHERE regionid = @regionid;
		------------------------------------
		-- extract HTMrange for Cover
		------------------------------------
		DECLARE @htmrange TABLE (
			htmidstart bigint,
			htmidend bigint
		)
		INSERT @htmrange
		  SELECT * 
		  FROM dbo.fHtmCoverRegion(@area)
		------------------------------------
		-- extract Halfspace of region
		------------------------------------
		DECLARE @halfspace TABLE (
			convexid int,
			x float,
			y float,
			z float,
			c float 
		)
		--
		INSERT @halfspace	
		SELECT convexid, x,y,z,c 
		FROM Halfspace
		WHERE regionid=@regionid
		-----------------------------
		-- the objects from cover
		-----------------------------
		DECLARE @prefetch TABLE (
			id bigint,
			cx float,
			cy float,
			cz float,
			flag tinyint
		)
		------------------------------------
		-- ready to execute the query
		------------------------------------
		IF ( (@flag & 1)>0 )  -- specObj
		BEGIN
			INSERT @prefetch
			SELECT q.specobjid as id, q.cx, q.cy, q.cz,1
			FROM @htmrange c, SpecObj q with (nolock)
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
		END
		-----------------------------------------
		IF ( (@flag & 2) > 0 )  -- photoObj
		BEGIN
			INSERT @prefetch
			SELECT q.objid as id, q.cx, q.cy, q.cz, 2
  			FROM @htmrange c, PhotoPrimary q 
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
		END
		-----------------------------------------
		IF ( (@flag & 4) > 0 )  -- target
		BEGIN
			INSERT @prefetch
			SELECT q.targetid as id, q.cx, q.cy, q.cz, 4
  			FROM @htmrange c, Target q 
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
		END
		-----------------------------------------
		IF ( (@flag & 8) > 0 )  -- mask
		BEGIN
			INSERT @prefetch
			SELECT q.maskid as id, q.cx, q.cy, q.cz, 8
  			FROM @htmrange c, Mask q
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
		END
		-----------------------------------------
		IF ( (@flag & 32) > 0 )  -- photoPrimary and Secondary
		BEGIN
			INSERT @prefetch
			SELECT q.objid as id, q.cx, q.cy, q.cz, 32
  			FROM @htmrange c, PhotoObjAll q
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
			  and q.mode in (1,2)
		END
		----------------------------------------------
		-- now filter objects on the correct boundary
		----------------------------------------------
		INSERT @Objects
		SELECT	o.id, o.flag
		    FROM @prefetch o
		    WHERE exists (
				select convexid from @halfspace
				where convexid not in (
					select convexid from @halfspace h
					where o.cx*h.x+o.cy*h.y+o.cz*h.z<h.c 
					)
			)
		---------------------------------------------
		RETURN  
END
GO


--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRegionGetObjectsFromString]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fRegionGetObjectsFromString]
GO
--
CREATE FUNCTION fRegionGetObjectsFromString(
	@poly varchar(max), @flag int, @buffer float
)
--------------------------------------------------------
--/H Returns various objects within a region given by a string
--/U ---------------------------------------------------
--/T The parameter @buffer, given in arcmins, corresponds
--/T to an expansion the search region beyond of each 
--/T boundary by that amount.
--/T (@flag&1)>0 display specObj ...<br>
--/T (@flag&2)>0 display photoPrimary...<br>
--/T (@flag&4)>0 display Target <br>
--/T (@flag&8)>0 display Mask<br>
--/T (@flag&32)>0 display photoPrimary and secondary<br>
--/T thus: @flag=7 will display all three of specObj, PhotoObj and Target
--/T the returned objects have 
--/T          flag = (specobj:1, photoobj:2, target:4, mask:8)
--------------------------------------------------------
RETURNS  @objects table(id bigint NOT NULL,flag int NOT NULL,PRIMARY KEY(flag,id))
AS BEGIN
		DECLARE @bin varbinary(max);
		------------------------
		-- get the regionBinary
		------------------------
		SELECT @bin=sph.fGrow(
			sph.fSimplifyString(@poly),@buffer/60)
		------------------------------------
		-- extract Halfspace of region
		------------------------------------
		DECLARE @halfspace TABLE (
			convexid int,
			x float,
			y float,
			z float,
			c float 
		)
		INSERT @halfspace
		  SELECT convexid,x,y,z,c 
		  FROM sph.fGetHalfspaces(@bin)
		------------------------------------
		-- extract HTMrange for Cover
		------------------------------------
		DECLARE @htmrange TABLE (
			htmidstart bigint,
			htmidend bigint
		)
		INSERT @htmrange
		  SELECT * 
		  FROM dbo.fHtmCoverRegion(sph.fGetRegionString(@bin))
		-----------------------------
		-- the objects from cover
		-----------------------------
		DECLARE @prefetch TABLE (
			id bigint,
			cx float,
			cy float,
			cz float,
			flag tinyint
		)
		------------------------------------
		-- ready to execute the query
		------------------------------------
		IF ( (@flag & 1)>0 )  -- specObj
		BEGIN
			INSERT @prefetch
			SELECT q.specobjid as id, q.cx, q.cy, q.cz,1
			FROM @htmrange c, SpecObj q with (nolock)
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
		END
		-----------------------------------------
		IF ( (@flag & 2) > 0 )  -- photoObj
		BEGIN
			INSERT @prefetch
			SELECT q.objid as id, q.cx, q.cy, q.cz, 2
  			FROM @htmrange c, PhotoPrimary q 
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
		END
		-----------------------------------------
		IF ( (@flag & 4) > 0 )  -- target
		BEGIN
			INSERT @prefetch
			SELECT q.targetid as id, q.cx, q.cy, q.cz, 4
  			FROM @htmrange c, Target q 
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
		END
		-----------------------------------------
		IF ( (@flag & 8) > 0 )  -- mask
		BEGIN
			INSERT @prefetch
			SELECT q.maskid as id, q.cx, q.cy, q.cz, 8
  			FROM @htmrange c, Mask q
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
		END
		-----------------------------------------
		IF ( (@flag & 32) > 0 )  -- photoPrimary and Secondary
		BEGIN
			INSERT @prefetch
			SELECT q.objid as id, q.cx, q.cy, q.cz, 32
  			FROM @htmrange c, PhotoObjAll q
			WHERE q.htmID between c.HtmIdStart and c.HtmIdEnd
			  and q.mode in (1,2)
		END
		----------------------------------------------
		-- now filter objects on the correct boundary
		----------------------------------------------
		INSERT @Objects
		SELECT	o.id, o.flag
		    FROM @prefetch o
		    WHERE exists (
				select convexid from @halfspace
				where convexid not in (
					select convexid from @halfspace h
					where o.cx*h.x+o.cy*h.y+o.cz*h.z<h.c 
					)
			)
		---------------------------------------------
		RETURN  
END
GO


--====================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRegionsContainingPointXYZ]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fRegionsContainingPointXYZ]
GO
--
CREATE FUNCTION fRegionsContainingPointXYZ(
	@x float, @y float, @z float, 
	@types VARCHAR(1000), @buffer float
)
--------------------------------------------------------
--/H Returns regions containing a given point 
--/U ---------------------------------------------------
--/T The parameters
--/T <li>@x, @y, @z are unit vector of the point on the J2000 celestial sphere. </li>
--/T <li>@types is a varchar(1000) space-separated string of the desired region types.
--/T <br> Possible types are: SEGMENT STRIPE TIGEOM PLATE CAMCOL RUN STAVE CHUNK TILE TILEBOX SECTOR SECTORLET SKYBOX WEDGE.</li>
--/T <li>@buffer is the "fuzz" in arcmins around that poiont.</li>
--/T <br>Returns a table with the coulums
--/T <br>Returns empty table if input params are bad.
--/T <br>RegionID BIGINT NOT NULL PRIMARY KEY
--/T <br>Type     VARCHAR(16) NOT NULL
--/T <samp>
--/T SELECT * from fGetRegionsContainingPointXYZ(0,0,0,'STAVE',0)
--/T </samp>
--------------------------------------------------------
RETURNS @Objects TABLE(	
		regionid 	bigint PRIMARY KEY, 
		type 		varchar(16) NOT NULL
	)
AS BEGIN
	----------------------------------------------------
	DECLARE @typesTable TABLE (
		type varchar(16) 
		COLLATE SQL_Latin1_General_CP1_CI_AS 
		NOT NULL  PRIMARY KEY
	);
	----------------------------------------------------
	SET @types = REPLACE(@types,',',' ');
	INSERT @typesTable (type)
	    SELECT * FROM dbo.fTokenStringToTable(@types) 
	IF (@@rowcount = 0) RETURN
	----------------------------------------
	-- this contains the prefetched convexes
	-- matching the type constraint
	----------------------------------------
	DECLARE @region TABLE (
		regionid bigint PRIMARY KEY,
		type varchar(16)
	)
	----------------------------
	-- bounding circle test
	----------------------------
	INSERT @region
	SELECT regionid, min(type)
	FROM (
	    select regionid, convexId, patch, type 
	    from RegionConvex with (nolock)
	    where type in (select type from @typesTable)
 	      and 2*DEGREES(ASIN(sqrt(
			power(@x-x,2)+power(@y-y,2)+power(@z-z,2)
			)/2)) <(radius+@buffer)/60
	    ) o
	GROUP BY regionid
	----------------------------
	-- do the proper test
	----------------------------
	INSERT @objects
	SELECT a.regionid,a.type
	FROM Region r, @region a
	WHERE r.regionid=a.regionid
	  and sph.fRegionContainsXYZ(
		sph.fGrow(r.regionBinary,@buffer/60), @x,@y,@z)=1
	------------------------------------------
	RETURN
END
GO


--=========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRegionsContainingPointEq]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fRegionsContainingPointEq]
GO
--
CREATE FUNCTION fRegionsContainingPointEq(
	@ra float, @dec float, 
	@types varchar(1000), @buffer float)
--------------------------------------------------------
--/H Returns regions containing a given point 
--/U ---------------------------------------------------
--/T The parameters
--/T <li>@ra, @dec the equatorial coordinats on the J2000 celestial sphere. </li>
--/T <li>@types is a varchar(1000) space-separated string of the desired region types.
--/T <br> Possible types are: SEGMENT STRIPE TIGEOM PLATE CAMCOL RUN STAVE CHUNK TILE TILEBOX SECTOR SECTORLET SKYBOX WEDGE.</li>
--/T <li>@buffer is the "fuzz" in arcmins around that poiont.</li>
--/T <br>Returns a table with the columns
--/T <br>Returns empty table if input params are bad.
--/T <br>regionid bigint NOT NULL PRIMARY KEY
--/T <br>type     varchar(16) NOT NULL
--/T <samp>
--/T SELECT * from dbo.fGetRegionsContainingPointEq(195,2.5,'STAVE',0)
--/T </samp>
--------------------------------------------------------
RETURNS @Objects TABLE(	regionid bigint PRIMARY KEY, 
			type 	 varchar(16) NOT NULL)
AS BEGIN
	--------------------------------
	-- transform to xyz coordinates
	--------------------------------
	DECLARE @x float, @y float, @z float;
	SET @x  = COS(RADIANS(@dec))*COS(RADIANS(@ra))
	SET @y  = COS(RADIANS(@dec))*SIN(RADIANS(@ra))
	SET @z  = SIN(RADIANS(@dec))
	-- call the xyz function
	INSERT @Objects
	    SELECT * FROM dbo.fRegionsContainingPointXYZ(@x,@y,@z,@types,@buffer)
	RETURN
END
GO



--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fPolygonsContainingPointXYZ]') 
	and xtype in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	drop function [dbo].[fPolygonsContainingPointXYZ]
GO
--
CREATE FUNCTION fPolygonsContainingPointXYZ(@x float, @y float, @z float, @buffer_arcmin float)
--------------------------------------------------------
--/H Returns regions containing a given point 
--/U ---------------------------------------------------
--/T The parameters
--/T <li>@x, @y, @z are unit vector of the point on the J2000 celestial sphere. </li>
--/T <li>@buffer_arcmin </li>
--/T <br>Returns empty table if input params are bad.
--/T <br>Returns a table with the columns
--/T <br>RegionID BIGINT NOT NULL PRIMARY KEY
--/T <samp>
--/T SELECT * from fPolygonsContainingPointXYZ(1,0,0)
--/T </samp>
--------------------------------------------------------
RETURNS @region TABLE(RegionID bigint PRIMARY KEY)
AS BEGIN
	DECLARE @arcmin float=7.85 + @buffer_arcmin; -- max radius of polygons
	DECLARE @degree float=@arcmin/60;
	--
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);

	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@x,@y,@z,@arcmin)
	DECLARE @found table (regionid bigint not null, 
		x float not null, y float not null, z float not null, 
		c float not null, dec float not null);
	--
	INSERT @found 
	SELECT regionid, x, y, z, c, dec 
	FROM @htmTemp c 
	INNER JOIN RegionPatch p ON p.HtmID BETWEEN c.HtmIDStart and c.HtmIDEnd;
	--
	DELETE @found WHERE x*@x + y*@y + z*@z < c;
	--
	INSERT @region SELECT p.regionid
	FROM @found p inner join Region r on r.regionid=p.regionid
	WHERE sph.fRegionContainsXYZ(sph.fGrow(r.regionBinary,@degree),@x,@y,@z)=1;
	
	RETURN
END
GO



--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fPolygonsContainingPointEq]') 
	and xtype in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	drop function [dbo].[fPolygonsContainingPointEq]
GO
--
CREATE FUNCTION fPolygonsContainingPointEq(@ra float, @dec float, @buffer_arcmin float)
--------------------------------------------------------
--/H Returns regions containing a given point 
--/U ---------------------------------------------------
--/T The parameters
--/T <li>@ra, @dec are the J2000 coordinates of the point. </li>
--/T <br>Returns empty table if input params are bad.
--/T <br>Returns a table with the columns
--/T <br>RegionID BIGINT NOT NULL PRIMARY KEY
--/T <samp>
--/T SELECT * from fPolygonsContainingPointEq(180,-2,0)
--/T </samp>
--------------------------------------------------------
RETURNS table AS 
RETURN (
	SELECT regionid 
	FROM dbo.fPolygonsContainingPointXYZ
				(cos(radians(@dec))*cos(radians(@ra)),
				 cos(radians(@dec))*sin(radians(@ra)),
				 sin(radians(@dec)), @buffer_arcmin )
)
GO



--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fFootprintEq]') 
	and xtype in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	drop function [dbo].[fFootprintEq]
GO
--
CREATE FUNCTION fFootprintEq(@ra float, @dec float, @radius_arcmin float)
-----------------------------------------------------------------
--/H Determines whether a point is inside the survey footprint
--
--/T Returns regiontype POLYGON if inside (to be backward compatible with earlier releases)
--/T that contain the given point. Empty indicates that the point
--/T is entirely outside the survey footprint.
-----------------------------------------------------------------
RETURNS table AS RETURN 
(
(
	SELECT DISTINCT 'POLYGON' as [Type] 
	FROM dbo.fPolygonsContainingPointEq(@ra,@dec,@radius_arcmin) p
	    JOIN Region r ON r.regionid=p.regionid
	    JOIN sdssPolygons s ON r.id=s.sdssPolygonID
	WHERE 
		primaryfieldid in (select fieldid from Field)
)
)
GO



--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRegionsIntersectingBinary]') 
	and xtype in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	drop function [dbo].[fRegionsIntersectingBinary]
GO
--
CREATE FUNCTION fRegionsIntersectingBinary(@types varchar(1000), @rBinary varbinary(max))
-------------------------------------------------------------
--/H Search for regions intersecting a given region,
--/H specified by a regionBinary.
-------------------------------------------------------------
--/T Regions are found within the RegionPatch table using the HTM 
--/T index. If @rBinary is present, @rString is ignored.
--/T Returns the regionid and the type.
--/T <samp>
--/T select * from dbo.fRegionsIntersectingBinary('STRIPE, STAVE, TILE', @bin)
--/T </samp>
-------------------------------------------------
RETURNS @out TABLE (
	regionid bigint NOT NULL, 
	isMask tinyint NOT NULL,
	type varchar(16) NOT NULL,
	comment varchar(1024) NOT NULL
	)
AS BEGIN
	--
	DECLARE @bin varbinary(max), @a float, @radius float;
	------------------------------
	-- check if region valid
	------------------------------
	IF (@rBinary is not null)
	BEGIN
		IF (coalesce(sph.fGetArea(@rBinary),0) = 0) RETURN;
	END
	---------------------------
	-- parse the types
	---------------------------
	DECLARE @typesTable TABLE (
		type varchar(16) 
		COLLATE SQL_Latin1_General_CP1_CI_AS 
		NOT NULL  PRIMARY KEY,
		radius float NOT NULL
	);
	----------------------------------------------------
	SET @types = REPLACE(@types,',',' ');
	INSERT @typesTable (type, radius)
	    SELECT *, 0 FROM dbo.fTokenStringToTable(@types) 
	IF (@@rowcount = 0) RETURN
	--
	UPDATE @typesTable
		SET radius = q.radius
	FROM @typesTable t, RegionTypes q
	WHERE t.type=q.type
	--
	DECLARE @htm TABLE (
		HtmIdStart bigint not null,
		HtmIdEnd bigint not null
	);

	DECLARE @region TABLE (
		regionid bigint NOT NULL
		);

	----------------------------------------
	-- fetch the POLYGONs through HTM
	----------------------------------------
	IF EXISTS (select * from @typesTable where type='POLYGON')
	BEGIN
		SELECT @radius = radius/60 
		FROM RegionTypes
		WHERE type='POLYGON'
		--
		SELECT @bin = sph.fGrow(@rBinary,@radius);
		--
		DELETE @htm;
		--
		INSERT @htm 
		SELECT htmIdStart, htmIdEnd 
		FROM dbo.fHtmCoverBinaryAdvanced(@rBinary)
		--
		INSERT @region
		SELECT distinct r.regionid
		FROM @htm h, RegionPatch r WITH (nolock)
		WHERE htmid BETWEEN h.htmIdStart AND h.htmIdEnd
		  and r.type='POLYGON'
		--
		DELETE @typesTable where type='POLYGON';
		--
	END
	----------------------------------------
	-- fetch the TILE etc through HTM
	----------------------------------------
	IF EXISTS (select * from @typesTable where type in ('PLATE', 'PLATEALL', 'TILE', 'TILEALL'))
	BEGIN
		--
		SELECT @radius = radius/60 
		FROM RegionTypes
		WHERE type='TILE'
		--
		SELECT @bin = sph.fGrow(@rBinary,@radius);
		--
		DELETE @htm;
		--
		INSERT @htm 
		SELECT htmIdStart, htmIdEnd 
		FROM dbo.fHtmCoverBinaryAdvanced(@rBinary)
		--
		INSERT @region
		SELECT distinct r.regionid
		FROM @htm h, RegionPatch r WITH (nolock)
		WHERE htmid BETWEEN h.htmIdStart AND h.htmIdEnd
		  and r.type in ('PLATE', 'PLATEALL', 'TILE', 'TILEALL')
		  and r.type in (select type from @typesTable)
		--
		DELETE @typesTable where type in ('PLATE', 'PLATEALL', 'TILE', 'TILEALL');
	END
	--------------------------------------------------
	-- Insert the remaining region types to be tested
	-- Use RegionPatch because of the type index.
	--------------------------------------------------
	INSERT @region
	SELECT distinct r.regionid
	FROM RegionPatch r, @typesTable t
	WHERE r.type=t.type
	-------------------------------
	-- add the remaining types
	-- to be searched
	-------------------------------
	INSERT @out
	SELECT r.regionid, r.isMask, r.type, r.comment
	FROM @region h, Region r
	WHERE r.regionid=h.regionid
		  and sph.fIntersect(r.regionBinary,@rBinary) is not null
	
	RETURN
END
GO



--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRegionsIntersectingString]') 
	and xtype in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	drop function [dbo].[fRegionsIntersectingString]
GO
--
CREATE FUNCTION fRegionsIntersectingString(@types varchar(1000), @rString varchar(max))
-------------------------------------------------------------
--/H Search for regions intersecting a given region,
--/H specified by a regionString.
-------------------------------------------------------------
--/T Regions are found within the RegionPatch table using the HTM 
--/T index. If @rBinary is present, @rString is ignored.
--/T Returns the regionid and the type.
--/T <samp>
--/T select * from dbo.fRegionsIntersectingString('STRIPE, STAVE, TILE', @str)
--/T </samp>
-------------------------------------------------
RETURNS @out TABLE (
	regionid bigint PRIMARY KEY, 
	isMask tinyint,
	type varchar(16),
	comment varchar(1024)
	)
AS BEGIN
	--
	DECLARE @rBinary varbinary(max), @a float;
	------------------------------
	-- check if region valid
	------------------------------
	IF (@rString = '') RETURN;
	--
	SELECT @rBinary = sph.fSimplifyString(@rString);
	IF (@rBinary is not null)
	BEGIN
		SELECT @a = sph.fGetArea(@rBinary);
		IF (@a is null or @a=0) RETURN;
	END
	-----------------------------------------------------
	-- call the function with the regionBinary argument
	-----------------------------------------------------
	INSERT @out
	SELECT * FROM dbo.fRegionsIntersectingBinary(@types, @rBinary);
	--
	RETURN
END
GO



--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fInFootprintEq]') 
	and xtype in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	drop function [dbo].[fInFootprintEq]
GO
--
CREATE FUNCTION fInFootprintEq (@ra float, @dec float, @rad float)
-----------------------------------------------------------------
--/H Indicates whether the given point is in the SDSS footprint or not.
--/T
--/T Returns 'true' or 'false' depending on whether the given circle
--/T (ra,dec,radius) is in the SDSS footprint or not.  The radius is in
--/T arcmin.
--/T
--/T <samp>
--/T     SELECT dbo.fInFootprintEq( 143.15, -0.7, 2.0 )
--/T </samp>
--/T <br> See also fFootprintEq.
-----------------------------------------------------------------
RETURNS bit
AS BEGIN
	declare @num int, @ret bit;
    
	SELECT @num = COUNT(*) 
	FROM dbo.fFootprintEq(@ra, @dec, @rad)
    
	IF (@num > 0) 
		SET @ret = 1 
	ELSE 
		SET @ret = 0
	RETURN @ret
END
GO



--===============================================================================
PRINT '[spRegion.sql]: Created functions and procedures for the Region package'
--===============================================================================
