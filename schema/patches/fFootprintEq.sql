-- Patch to fix the footprint function for DR8.
/*
    Tamas Budavari 2011-05-28
    
	Notes:
	======
	- The sdssPolygons are very different from the previous regions
	  e.g., max(radius of bounding circles) is < 7.85 arcmins -->
	       We can use this to speed things up!	  
	- Old functions work with Region TYPE that doesn't exist anymore	  
	  We should depricate fRegionContainingPointXYZ() and ..Eq()
	  No meaningful Type + we can do faster w/the size limit if needed	
	- Development on SDSS3A
	  
	Warning:
	========
	- The maximum radius of the polygon bounding circles (7.85') is hardwired
	  for efficiency. Have to check that when new polygons are loaded. 
	  Alternatively we could save it in the constants table...

	Changes:	
	========
	- Populate RegionPatch and create HtmID index for fast searches
	- Create dbo.fPolygonsContainingPointXYZ() using HTM
	- Create ...Eq() inline wrapper
	- Drop and create inline dbo.fFootprintEq()

	Possible improvements:
	======================
	- Check if buffer is 0 and don't grow the region
	- Search radii and finer HTM cover

    Revision History:
       2011-06-07  Ani: Adapted for sqlLoader - replaced explicit index
                   creation code with calls to spIndex* procedures, etc.
       2011-06-08  Ani: Reverted to dbo.fSph* from sph.f*, and applied 
                   performance tweak a la nearby funcs (use @htmTemp)
                   to fPolygonsContainingPointXYZ.
*/

SET STATISTICS TIME OFF;
SET NOCOUNT ON;
GO


-- Drop all indices for RegionPatch table.
EXEC spIndexDropSelection 0,0, 'I','RegionPatch'
EXEC spIndexDropSelection 0,0, 'F','RegionPatch'
EXEC spIndexDropSelection 0,0, 'K','RegionPatch'


--
-- [Re-]Populate RegionPatch
--
TRUNCATE TABLE RegionPatch
GO
--
SET STATISTICS TIME ON;
SET NOCOUNT OFF;
GO

-- Fill table w/o ConvexString
INSERT RegionPatch WITH (TABLOCKX)
SELECT r.RegionID, p.ConvexID, p.PatchID, r.type, p.Radius, p.RA,p.Dec, p.X,p.Y,p.Z,p.C, p.HtmID, p.Area, NULL
FROM Region r with (nolock) cross apply dbo.fSphGetPatches(RegionBinary) p
ORDER BY r.RegionID -- PK anyway
GO
--
SET STATISTICS TIME OFF;
SET NOCOUNT ON;
GO

GO

-- Rebuild the indices for RegionPatch.
EXEC spIndexBuildSelection 0,0, 'K','RegionPatch'
EXEC spIndexBuildSelection 0,0, 'F','RegionPatch'
EXEC spIndexBuildSelection 0,0, 'I','RegionPatch'


--
UPDATE STATISTICS RegionPatch;
GO
--
select top 10 cos(radians(radius/60)), c from RegionPatch -- check radius in arcmin
select MAX(radius) from RegionPatch -- 7.8479549502096 [arcmin] 


declare @max_arcmin float = (select MAX(radius) from RegionPatch);
PRINT 'The maxinum radius is '+convert(varchar(64),@max_arcmin)+' arcmins';


--
-- Create fPolygonsContainingPointXYZ()
--
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
	WHERE dbo.fSphRegionContainsXYZ(dbo.fSphGrow(r.regionBinary,@buffer_arcmin),@x,@y,@z)=1;
	
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
	SELECT DISTINCT 'POLYGON' as [Type] 
	FROM dbo.fPolygonsContainingPointEq(@ra,@dec,@radius_arcmin)
)
GO

select * from dbo.fFootprintEq(180,0,0)


-- Update the metadata tables.
INSERT DBObjects VALUES('fPolygonsContainingPointXYZ','F','U',' Returns regions containing a given point  ',' The parameters  <li>@x, @y, @z are unit vector of the point on the J2000 celestial sphere. </li>  <li>@buffer_arcmin </li>  <br>Returns empty table if input params are bad.  <br>Returns a table with the columns  <br>RegionID BIGINT NOT NULL PRIMARY KEY  <samp>  SELECT * from fPolygonsContainingPointXYZ(1,0,0)  </samp> ','0');
INSERT DBObjects VALUES('fPolygonsContainingPointEq','F','U',' Returns regions containing a given point  ',' The parameters  <li>@ra, @dec are the J2000 coordinates of the point. </li>  <br>Returns empty table if input params are bad.  <br>Returns a table with the columns  <br>RegionID BIGINT NOT NULL PRIMARY KEY  <samp>  SELECT * from fPolygonsContainingPointEq(180,-2,0)  </samp> ','0');
UPDATE DBObjects 
   SET access='U',description=' Determines whether a point is inside the survey footprint ',text=' Returns regiontype POLYGON if inside (to be backward compatible with earlier releases)  that contain the given point. Empty indicates that the point  is entirely outside the survey footprint. '
   WHERE name='fFootprintEq'
INSERT Inventory VALUES('spRegion','fPolygonsContainingPointXYZ','F');
INSERT Inventory VALUES('spRegion','fPolygonsContainingPointEq','F');
INSERT History VALUES('spSphericalLib','2011-06-03','Ani','Switched back to dbo schema from sph. ');
INSERT History VALUES('spHtmCSharp','2011-06-06','Ani','Incorporated changes from latest version from Tamas. ');
INSERT History VALUES('spRegion','2011-06-06','Ani','Incorporate Tamas''s changes to fix fFootprintEq. ');
INSERT History VALUES('spRegion','2011-06-08','Ani','Updated fPolygonsContainiingPointXYZ to use temp table for HTM range to speed it up a la nearby functions. Also removed refs to "sph" schema (replaced with dbo). ');


/*
-- Update the version info
EXECUTE spSetVersion
  0
  ,0
  ,'8'
  ,'124469'
  ,'Update DR'
  ,'.3'
  ,'Flags and footprint function patches'
  ,'Flags2 patch, spherical library upgrade and fix for fFootprintEq'
  ,'T.Budavari,N.Buddana,A.Thakar'
*/

