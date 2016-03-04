--=================================================================
--   spSphericalLib.sql
--	 2007-06-11 Tamas Budavari, Alex Szalay
-------------------------------------------------------------------
-- needs to be run after the spSphericalDeploy.sql
-------------------------------------------------------------------
-- History:
-------------------------------------------------------------------

-- CREATE SCHEMA [sph] AUTHORIZATION [dbo]

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetVersion]') )
    drop function [dbo].[fGetVersion]
GO
--
CREATE FUNCTION dbo.fGetVersion()
-------------------------------------------------------
--/H Returns the version string as in the assembly.
--/U --------------------------------------------------
RETURNS nvarchar(4000)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetVersion
GO

--====================================================================

if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetVersions]') )
    drop function [dbo].[fGetVersions]
GO
--
CREATE FUNCTION dbo.fGetVersions()
-------------------------------------------------------
--/H Returns the version strings of the relevant assemblies.
--/U --------------------------------------------------
RETURNS TABLE (AssemblyName nvarchar(128), Version nvarchar(64), Debuggable bit, JitOptimized bit)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetVersions
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetArea]') )
    drop function [dbo].[fGetArea]
GO
--
CREATE FUNCTION dbo.fGetArea(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the area of region stored in the specified blob.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS float
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetArea
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetRegionStringBin]') )
    drop function [dbo].[fGetRegionStringBin]
GO
--
CREATE FUNCTION dbo.fGetRegionStringBin(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the regionstring in a blob. Used internally.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T see dbo.fGetRegionString.
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetString
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fConvexAddHalfspace]') )
    drop function [dbo].[fConvexAddHalfspace]
GO
--
CREATE FUNCTION dbo.fConvexAddHalfspace(@bin varbinary(max), 
	@cidx int, @x float, @y float, @z float, @c float)
-------------------------------------------------------
--/H Adds the specified halfspaces to a given convex and returns the new region blob. 
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @cidx int: convex index
--/T <li> @x float: halfspace vector's X coordinate
--/T <li> @y float: halfspace vector's y coordinate
--/T <li> @z float: halfspace vector's Z coordinate
--/T <li> @c float: halfspace offset
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
SphericalSql.[Spherical.Sql.UserDefinedFunctions].ConvexAddHalfspace;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fSimplifyBinary]') )
    drop function [dbo].[fSimplifyBinary]
GO
--
CREATE FUNCTION dbo.fSimplifyBinary(@bin varbinary(max))
-------------------------------------------------------
--/H Simplifies the region in the specified blob created w/ dbo.fConvexAddHalfspace().
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyBinary;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fSimplifyBinaryAdvanced]') )
    drop function [dbo].[fSimplifyBinaryAdvanced]
GO
--
CREATE FUNCTION dbo.fSimplifyBinaryAdvanced(@bin varbinary(max), 
	@simple_simplify bit, @convex_eliminate bit, 
	@convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Simplifies the region in the specified blob created with dbo.fConvexAddHalfspace
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @simple_simplify bit: determines whether to run trivial convex simplification
--/T <li> @convex_eliminate bit: determines whether to attempt eliminating convexes
--/T <li> @convex_disjoint bit: determines whether to make convexes disjoint
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyBinaryAdvanced;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fSimplifyString]') )
    drop function [dbo].[fSimplifyString]
GO
--
CREATE FUNCTION dbo.fSimplifyString(@str nvarchar(max))
-------------------------------------------------------
--/H Simplifies the region in the specified string and returns its blob.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @str nvarchar(max): region string
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyString;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fSimplifyStringAdvanced]') )
    drop function [dbo].[fSimplifyStringAdvanced]
GO
--
CREATE FUNCTION dbo.fSimplifyStringAdvanced(@str nvarchar(max), @simple_simplify bit, 
	@convex_eliminate bit, @convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Simplifies the region in the specified string and returns its blob.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @str nvarchar(max): region string
--/T <li> @simple_simplify bit: determines whether to run trivial convex simplification
--/T <li> @convex_eliminate bit: determines whether to attempt eliminating convexes
--/T <li> @convex_disjoint bit: determines whether to make convexes disjoint
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyStringAdvanced;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fSimplifyQuery]') )
    drop function [dbo].[fSimplifyQuery]
GO
--
CREATE FUNCTION dbo.fSimplifyQuery(@cmd nvarchar(max))
-------------------------------------------------------
--/H Simplifies the region defined by the specified query that yields halfspaces.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @cmd nvarchar(max): query string
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyQuery;
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fSimplifyQueryAdvanced]') )
    drop function [dbo].[fSimplifyQueryAdvanced]
GO
--
CREATE FUNCTION dbo.fSimplifyQueryAdvanced(@cmd nvarchar(max), @simple_simplify bit, 
	@convex_eliminate bit, @convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Simplifies the region defined by the specified query that yields halfspaces.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @cmd nvarchar(max): query string
--/T <li> @simple_simplify bit: determines whether to run trivial convex simplification
--/T <li> @convex_eliminate bit: determines whether to attempt eliminating convexes
--/T <li> @convex_disjoint bit: determines whether to make convexes disjoint
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyQueryAdvanced;
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGrowArc]') )
    drop function [dbo].[fGrowArc]
GO
--
CREATE FUNCTION dbo.fGrowArc(@degree float,
	@sx float, @sy float, @sz float, @sNorm bit, 
	@mx float, @my float, @mz float, @mNorm bit, 
	@ex float, @ey float, @ez float, @eNorm bit)
-------------------------------------------------------
--/H Grows a arcn by the given amount and returns the region's blob
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @s...: start point
--/T <li> @m...: middle point
--/T <li> @e...: end point
--/T <li> @degree float: amount of grow
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GrowArc;
GO



--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGrow]') )
    drop function [dbo].[fGrow]
GO
--
CREATE FUNCTION dbo.fGrow(@bin varbinary(max), @degree float)
-------------------------------------------------------
--/H Grows a region by the given amount and returns its blob.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @degree float: amount of grow
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].Grow;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGrowAdvanced]') )
    drop function [dbo].[fGrowAdvanced]
GO
--
CREATE FUNCTION dbo.fGrowAdvanced(@bin varbinary(max), @degree float, 
	@simple_simplify bit, @convex_eliminate bit, 
	@convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Grows a region by the given amount and returns its blob.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @degree float: amount of grow
--/T <li> @simple_simplify bit: determines whether to run trivial convex simplification
--/T <li> @convex_eliminate bit: determines whether to attempt eliminating convexes
--/T <li> @convex_disjoint bit: determines whether to make convexes disjoint
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GrowAdvanced;
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fUnion]') )
    drop function [dbo].[fUnion]
GO
--
CREATE FUNCTION dbo.fUnion(@bin varbinary(max), @bin2 varbinary(max))
-------------------------------------------------------
--/H Derives the union of the given regions.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @bin2 varbinary(max): other blob
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].[Union];
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fIntersect]') )
    drop function [dbo].[fIntersect]
GO
--
CREATE FUNCTION dbo.fIntersect(@bin varbinary(max), @bin2 varbinary(max))
-------------------------------------------------------
--/H Derives the intersection of the given regions.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @bin2 varbinary(max): other blob
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].Intersection;
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fUnionAdvanced]') )
    drop function [dbo].[fUnionAdvanced]
GO
--
CREATE FUNCTION dbo.fUnionAdvanced(@bin varbinary(max), @bin2 varbinary(max), 
	@convex_unify bit)
-------------------------------------------------------
--/H Derives the union of the given regions.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @bin2 varbinary(max): other blob
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].UnionAdvanced;
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fIntersectAdvanced]') )
    drop function [dbo].[fIntersectAdvanced]
GO
--
CREATE FUNCTION dbo.fIntersectAdvanced(@bin varbinary(max), @bin2 varbinary(max), 
	@convex_unify bit)
-------------------------------------------------------
--/H Derives the intersection of the given regions.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @bin2 varbinary(max): other blob
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
SphericalSql.[Spherical.Sql.UserDefinedFunctions].IntersectionAdvanced;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fUnionQuery]') )
    drop function [dbo].[fUnionQuery]
GO
--
CREATE FUNCTION dbo.fUnionQuery(@cmd nvarchar(max), @convex_unify bit)
-------------------------------------------------------
--/H Derives the union of regions returned by the specified query.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @cmd nvarchar(max): query string
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
--/T Note: The query should return region blobs.
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
SphericalSql.[Spherical.Sql.UserDefinedFunctions].UnionQuery;
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fIntersectQuery]') )
    drop function [dbo].[fIntersectQuery]
GO
--
CREATE FUNCTION dbo.fIntersectQuery(@cmd nvarchar(max), @convex_unify bit)
-------------------------------------------------------
--/H Derives the intersection of regions returned by the specified query.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @cmd nvarchar(max): query string
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
--/T Note: The query should return region blobs.
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].IntersectionQuery;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fDiffAdvanced]') )
    drop function [dbo].[fDiffAdvanced]
GO
--
CREATE FUNCTION dbo.fDiffAdvanced(@bin varbinary(max), @bin2 varbinary(max), 
	@simple_simplify bit, @convex_eliminate bit, 
	@convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Derives the difference of the given regions.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @bin2 varbinary(max): other blob
--/T <li> @simple_simplify bit: determines whether to run trivial convex simplification
--/T <li> @convex_eliminate bit: determines whether to attempt eliminating convexes
--/T <li> @convex_disjoint bit: determines whether to make convexes disjoint
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].DifferenceAdvanced;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fDiff]') )
    drop function [dbo].[fDiff]
GO
--
CREATE FUNCTION dbo.fDiff(@bin varbinary(max), @bin2 varbinary(max))
-------------------------------------------------------
--/H Derives the difference of the given regions.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @bin2 varbinary(max): other blob
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
SphericalSql.[Spherical.Sql.UserDefinedFunctions].[Difference];
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetHalfspaces]') )
    drop function [dbo].[fGetHalfspaces]
GO
--
CREATE FUNCTION dbo.fGetHalfspaces(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the halfspaces of the specified region blob.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS  TABLE (
	ConvexID int,
	HalfspaceID int,
	X float,
	Y float,
	Z float,
	C float
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetHalfspaces
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetConvexes]') )
    drop function [dbo].[fGetConvexes]
GO
--
CREATE FUNCTION dbo.fGetConvexes(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the convexes of the specified region in separate region blobs.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS  TABLE (
	ConvexID int,
	RegionBinary varbinary(max)
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetConvexes
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetPatches]') )
    drop function [dbo].[fGetPatches]
GO
--
CREATE FUNCTION dbo.fGetPatches(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the patches of the specified region.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS  TABLE (
	ConvexID int,
	PatchID int,
	RA float,
	Dec float,
	Radius float,
	X float,
	Y float,
	Z float,
	C float,
	HtmID bigint,
	Area float,
	ConvexString varbinary(max)
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetPatches
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetArcs]') )
    drop function [dbo].[fGetArcs]
GO
--
CREATE FUNCTION dbo.fGetArcs(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the arcs of the specified region.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS  TABLE (
	ConvexID int, PatchID int, ArcID int,
	X float, Y float, Z float, C float,
    X1 float, Y1 float, Z1 float, RA1 float, Dec1 float,
    X2 float, Y2 float, Z2 float, RA2 float, Dec2 float,
    Draw bit, Length float
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetArcs
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetOutlineArcs]') )
    drop function [dbo].[fGetOutlineArcs]
GO
--
CREATE FUNCTION dbo.fGetOutlineArcs(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the outline arcs of the specified region.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS  TABLE (
	ConvexID int, PatchID int, ArcID int,
	X float, Y float, Z float, C float,
    X1 float, Y1 float, Z1 float, RA1 float, Dec1 float,
    X2 float, Y2 float, Z2 float, RA2 float, Dec2 float,
    Draw bit, Length float
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetOutlineArcs
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetHtmRanges]') )
    drop function [dbo].[fGetHtmRanges]
GO
--
CREATE FUNCTION dbo.fGetHtmRanges(@bin varbinary(max))
-------------------------------------------------------
--/H Calculates HTM covers for the specified region.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS  TABLE (
	FullOnly bit,
	HtmIdStart bigint,
	HtmIdEnd bigint
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetHtmRanges
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetHtmRangesAdvanced]') )
    drop function [dbo].[fGetHtmRangesAdvanced]
GO
--
CREATE FUNCTION dbo.fGetHtmRangesAdvanced(@bin varbinary(max), @frac float, @seconds float)
-------------------------------------------------------
--/H Calculates HTM covers for the specified region.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @frac float: limiting pseudo area fraction (inner/outer)
--/T <li> @seconds float: time limit
-------------------------------------------------------
RETURNS  TABLE (
	FullOnly bit,
	HtmIdStart bigint,
	HtmIdEnd bigint
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetHtmRangesAdvanced
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fRegionContainsXYZ]') )
    drop function [dbo].[fRegionContainsXYZ]
GO
--
CREATE FUNCTION dbo.fRegionContainsXYZ(@bin varbinary(max), 
		@x float, @y float, @z float)
-------------------------------------------------------
--/H Returns whether the specified region contains the given location.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T <li> @x float: direction's X-coordinate
--/T <li> @y float: direction's Y-coordinate
--/T <li> @z float: direction's Z-coordinate
-------------------------------------------------------
RETURNS BIT
WITH EXECUTE AS CALLER AS EXTERNAL 
NAME SphericalSql.[Spherical.Sql.UserDefinedFunctions].ContainsXYZ;
GO

-- SQL --

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fSimplifyAdvanced]') )
    drop function [dbo].[fSimplifyAdvanced]
GO
--
CREATE FUNCTION dbo.fSimplifyAdvanced(@id bigint, 
	@simple_simplify bit, @convex_eliminate bit, 
	@convex_disjoint bit, @convex_unify bit)
------------------------------------------------------
--/H Simplifies the region defined by the specified ID.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @id bigint: region id
--/T <li> @simple_simplify bit: determines whether to run trivial convex simplification
--/T <li> @convex_eliminate bit: determines whether to attempt eliminating convexes
--/T <li> @convex_disjoint bit: determines whether to make convexes disjoint
--/T <li> @convex_unify bit: determines whether to attempt stiching convexes
-------------------------------------------------------
RETURNS varbinary(max)
AS 
BEGIN
	DECLARE @cmd nvarchar(1024);
	SET @cmd = 'SELECT convert(int,ConvexID), X, Y, Z, C 
                FROM Halfspace 
                WHERE RegionID=' + convert(varchar(128),@id) + ' 
                ORDER BY ConvexID';
	RETURN dbo.fSimplifyQueryAdvanced(@cmd, @simple_simplify, 
			@convex_eliminate, @convex_disjoint, @convex_unify);
END
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fSimplify]') )
    drop function [dbo].[fSimplify]
GO
--
CREATE FUNCTION dbo.fSimplify(@id bigint)
------------------------------------------------------
--/H Simplifies the region defined by the specified ID.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @id bigint: region id
-------------------------------------------------------
RETURNS varbinary(max)
AS 
BEGIN
	RETURN dbo.fSimplifyAdvanced(@id, 1, 1, 1, 0);
END
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetRegionString]') )
    drop function [dbo].[fGetRegionString]
GO
--
CREATE FUNCTION dbo.fGetRegionString(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the regionstring of the specified region.
--/U --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS varchar(max)
AS 
BEGIN 
	RETURN CONVERT(varchar(max),dbo.fGetRegionStringBin(@bin))
END
GO

-------------------------------------
declare @version varchar(max)
select @version = dbo.fGetVersion()
----------------------------------------------------------------------------------------------
PRINT '[spSphericalLib.sql]: Versions: '
PRINT @version
----------------------------------------------------------------------------------------------
