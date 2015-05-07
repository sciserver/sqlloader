--=================================================================
--   spSphericalLib.sql
--	 2007-06-11 Tamas Budavari, Alex Szalay
-------------------------------------------------------------------
-- needs to be run after the spSphericalDeploy.sql
-------------------------------------------------------------------
-- History:
--		2013-10-22: Umcommented schema creation and added
--                          check for existence.
--		2013-10-22: Fixed schema creation statement.
--		2013-10-23: Enclosed schema name (sph) in [] so
--                          the metadata parsing script can exclude it.
--			    Also made all the functions admin access.
-------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'sph' )
BEGIN
      EXEC ('CREATE SCHEMA [sph] AUTHORIZATION [dbo]')
      PRINT 'Created schema sph'
END

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fGetVersion]') )
    drop function [sph].[fGetVersion]
GO
--
CREATE FUNCTION [sph].fGetVersion()
-------------------------------------------------------
--/H Returns the version string as in the assembly.
--/A --------------------------------------------------
RETURNS nvarchar(4000)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetVersion
GO

--====================================================================

if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fGetVersions]') )
    drop function [sph].[fGetVersions]
GO
--
CREATE FUNCTION [sph].fGetVersions()
-------------------------------------------------------
--/H Returns the version strings of the relevant assemblies.
--/A --------------------------------------------------
RETURNS TABLE (AssemblyName nvarchar(128), Version nvarchar(64), Debuggable bit, JitOptimized bit)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetVersions
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fGetArea]') )
    drop function [sph].[fGetArea]
GO
--
CREATE FUNCTION [sph].fGetArea(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the area of region stored in the specified blob.
--/A --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS float
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetArea
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fGetRegionStringBin]') )
    drop function [sph].[fGetRegionStringBin]
GO
--
CREATE FUNCTION [sph].fGetRegionStringBin(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the regionstring in a blob. Used internally.
--/A --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
--/T see sph.fGetRegionString.
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].GetString
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fConvexAddHalfspace]') )
    drop function [sph].[fConvexAddHalfspace]
GO
--
CREATE FUNCTION [sph].fConvexAddHalfspace(@bin varbinary(max), 
	@cidx int, @x float, @y float, @z float, @c float)
-------------------------------------------------------
--/H Adds the specified halfspaces to a given convex and returns the new region blob. 
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fSimplifyBinary]') )
    drop function [sph].[fSimplifyBinary]
GO
--
CREATE FUNCTION [sph].fSimplifyBinary(@bin varbinary(max))
-------------------------------------------------------
--/H Simplifies the region in the specified blob created w/ sph.fConvexAddHalfspace().
--/A --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyBinary;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fSimplifyBinaryAdvanced]') )
    drop function [sph].[fSimplifyBinaryAdvanced]
GO
--
CREATE FUNCTION [sph].fSimplifyBinaryAdvanced(@bin varbinary(max), 
	@simple_simplify bit, @convex_eliminate bit, 
	@convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Simplifies the region in the specified blob created with sph.fConvexAddHalfspace
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fSimplifyString]') )
    drop function [sph].[fSimplifyString]
GO
--
CREATE FUNCTION [sph].fSimplifyString(@str nvarchar(max))
-------------------------------------------------------
--/H Simplifies the region in the specified string and returns its blob.
--/A --------------------------------------------------
--/T Parameter(s):
--/T <li> @str nvarchar(max): region string
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyString;
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fSimplifyStringAdvanced]') )
    drop function [sph].[fSimplifyStringAdvanced]
GO
--
CREATE FUNCTION [sph].fSimplifyStringAdvanced(@str nvarchar(max), @simple_simplify bit, 
	@convex_eliminate bit, @convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Simplifies the region in the specified string and returns its blob.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fSimplifyQuery]') )
    drop function [sph].[fSimplifyQuery]
GO
--
CREATE FUNCTION [sph].fSimplifyQuery(@cmd nvarchar(max))
-------------------------------------------------------
--/H Simplifies the region defined by the specified query that yields halfspaces.
--/A --------------------------------------------------
--/T Parameter(s):
--/T <li> @cmd nvarchar(max): query string
-------------------------------------------------------
RETURNS varbinary(max)
WITH EXECUTE AS CALLER AS EXTERNAL NAME 
	SphericalSql.[Spherical.Sql.UserDefinedFunctions].RegionSimplifyQuery;
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fSimplifyQueryAdvanced]') )
    drop function [sph].[fSimplifyQueryAdvanced]
GO
--
CREATE FUNCTION [sph].fSimplifyQueryAdvanced(@cmd nvarchar(max), @simple_simplify bit, 
	@convex_eliminate bit, @convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Simplifies the region defined by the specified query that yields halfspaces.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGrowArc]') )
    drop function [sph].[fGrowArc]
GO
--
CREATE FUNCTION [sph].fGrowArc(@degree float,
	@sx float, @sy float, @sz float, @sNorm bit, 
	@mx float, @my float, @mz float, @mNorm bit, 
	@ex float, @ey float, @ez float, @eNorm bit)
-------------------------------------------------------
--/H Grows a arcn by the given amount and returns the region's blob
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGrow]') )
    drop function [sph].[fGrow]
GO
--
CREATE FUNCTION [sph].fGrow(@bin varbinary(max), @degree float)
-------------------------------------------------------
--/H Grows a region by the given amount and returns its blob.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGrowAdvanced]') )
    drop function [sph].[fGrowAdvanced]
GO
--
CREATE FUNCTION [sph].fGrowAdvanced(@bin varbinary(max), @degree float, 
	@simple_simplify bit, @convex_eliminate bit, 
	@convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Grows a region by the given amount and returns its blob.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fUnion]') )
    drop function [sph].[fUnion]
GO
--
CREATE FUNCTION [sph].fUnion(@bin varbinary(max), @bin2 varbinary(max))
-------------------------------------------------------
--/H Derives the union of the given regions.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fIntersect]') )
    drop function [sph].[fIntersect]
GO
--
CREATE FUNCTION [sph].fIntersect(@bin varbinary(max), @bin2 varbinary(max))
-------------------------------------------------------
--/H Derives the intersection of the given regions.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fUnionAdvanced]') )
    drop function [sph].[fUnionAdvanced]
GO
--
CREATE FUNCTION [sph].fUnionAdvanced(@bin varbinary(max), @bin2 varbinary(max), 
	@convex_unify bit)
-------------------------------------------------------
--/H Derives the union of the given regions.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fIntersectAdvanced]') )
    drop function [sph].[fIntersectAdvanced]
GO
--
CREATE FUNCTION [sph].fIntersectAdvanced(@bin varbinary(max), @bin2 varbinary(max), 
	@convex_unify bit)
-------------------------------------------------------
--/H Derives the intersection of the given regions.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fUnionQuery]') )
    drop function [sph].[fUnionQuery]
GO
--
CREATE FUNCTION [sph].fUnionQuery(@cmd nvarchar(max), @convex_unify bit)
-------------------------------------------------------
--/H Derives the union of regions returned by the specified query.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fIntersectQuery]') )
    drop function [sph].[fIntersectQuery]
GO
--
CREATE FUNCTION [sph].fIntersectQuery(@cmd nvarchar(max), @convex_unify bit)
-------------------------------------------------------
--/H Derives the intersection of regions returned by the specified query.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fDiffAdvanced]') )
    drop function [sph].[fDiffAdvanced]
GO
--
CREATE FUNCTION [sph].fDiffAdvanced(@bin varbinary(max), @bin2 varbinary(max), 
	@simple_simplify bit, @convex_eliminate bit, 
	@convex_disjoint bit, @convex_unify bit)
-------------------------------------------------------
--/H Derives the difference of the given regions.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fDiff]') )
    drop function [sph].[fDiff]
GO
--
CREATE FUNCTION [sph].fDiff(@bin varbinary(max), @bin2 varbinary(max))
-------------------------------------------------------
--/H Derives the difference of the given regions.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGetHalfspaces]') )
    drop function [sph].[fGetHalfspaces]
GO
--
CREATE FUNCTION [sph].fGetHalfspaces(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the halfspaces of the specified region blob.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGetConvexes]') )
    drop function [sph].[fGetConvexes]
GO
--
CREATE FUNCTION [sph].fGetConvexes(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the convexes of the specified region in separate region blobs.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGetPatches]') )
    drop function [sph].[fGetPatches]
GO
--
CREATE FUNCTION [sph].fGetPatches(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the patches of the specified region.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGetArcs]') )
    drop function [sph].[fGetArcs]
GO
--
CREATE FUNCTION [sph].fGetArcs(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the arcs of the specified region.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGetOutlineArcs]') )
    drop function [sph].[fGetOutlineArcs]
GO
--
CREATE FUNCTION [sph].fGetOutlineArcs(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the outline arcs of the specified region.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGetHtmRanges]') )
    drop function [sph].[fGetHtmRanges]
GO
--
CREATE FUNCTION [sph].fGetHtmRanges(@bin varbinary(max))
-------------------------------------------------------
--/H Calculates HTM covers for the specified region.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fGetHtmRangesAdvanced]') )
    drop function [sph].[fGetHtmRangesAdvanced]
GO
--
CREATE FUNCTION [sph].fGetHtmRangesAdvanced(@bin varbinary(max), @frac float, @seconds float)
-------------------------------------------------------
--/H Calculates HTM covers for the specified region.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fRegionContainsXYZ]') )
    drop function [sph].[fRegionContainsXYZ]
GO
--
CREATE FUNCTION [sph].fRegionContainsXYZ(@bin varbinary(max), 
		@x float, @y float, @z float)
-------------------------------------------------------
--/H Returns whether the specified region contains the given location.
--/A --------------------------------------------------
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
    where id = object_id(N'[sph].[fSimplifyAdvanced]') )
    drop function [sph].[fSimplifyAdvanced]
GO
--
CREATE FUNCTION [sph].fSimplifyAdvanced(@id bigint, 
	@simple_simplify bit, @convex_eliminate bit, 
	@convex_disjoint bit, @convex_unify bit)
------------------------------------------------------
--/H Simplifies the region defined by the specified ID.
--/A --------------------------------------------------
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
	RETURN sph.fSimplifyQueryAdvanced(@cmd, @simple_simplify, 
			@convex_eliminate, @convex_disjoint, @convex_unify);
END
GO


--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fSimplify]') )
    drop function [sph].[fSimplify]
GO
--
CREATE FUNCTION [sph].fSimplify(@id bigint)
------------------------------------------------------
--/H Simplifies the region defined by the specified ID.
--/A --------------------------------------------------
--/T Parameter(s):
--/T <li> @id bigint: region id
-------------------------------------------------------
RETURNS varbinary(max)
AS 
BEGIN
	RETURN sph.fSimplifyAdvanced(@id, 1, 1, 1, 0);
END
GO

--====================================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[sph].[fGetRegionString]') )
    drop function [sph].[fGetRegionString]
GO
--
CREATE FUNCTION [sph].fGetRegionString(@bin varbinary(max))
-------------------------------------------------------
--/H Returns the regionstring of the specified region.
--/A --------------------------------------------------
--/T Parameter(s):
--/T <li> @bin varbinary(max): region blob
-------------------------------------------------------
RETURNS varchar(max)
AS 
BEGIN 
	RETURN CONVERT(varchar(max),sph.fGetRegionStringBin(@bin))
END
GO

-------------------------------------
declare @version varchar(max)
select @version = sph.fGetVersion()
----------------------------------------------------------------------------------------------
PRINT '[spSphericalLib.sql]: Versions: '
PRINT @version
----------------------------------------------------------------------------------------------
