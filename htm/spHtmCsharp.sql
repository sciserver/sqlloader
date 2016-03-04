--=================================================================================
--	spHtmCsharpCore.sql 
--   Jim Gray, Alex Szalay, Gyorgy Fekete, Mar 2006
-----------------------------------------------------------------------------------
-- contains the core functions from the C#-based HTM library, which in
-- turn relies on the Spherical library.
-- Defines: 
---- basic HTM trixel related base functions -----
--		fHtmVersion				-- get the current version
--		fHtmEq					-- convert HTM to coordinates or name
--		fHtmXyz
--		fHtmGetString			-- get trixel attributes
--      fHtmGetCenterPoint
--      fHtmGetCornerPoints
---- HTM covers of various shapes ----------------
--		fHtmCoverCircleEq
--		fHtmCoverCircleXyz
--		fHtmCoverRegion
--		fHtmCoverRegionError
--		fHtmCoverRegionSelect
--		fHtmCoverRegionBinary ??
--		fHtmCoverRegionList
------------------------------------
-- these are useful, but not strictly Htm
--
--		fHtmXyzToEq				-- coordinate transforms
--		fHtmEqToXyz
--      fDistanceEq				-- compute distances
--      fDistanceXyz 

------------------------------
-- the rest needs to move to a spHtmSearch module
-- these are not pur C# anyway

--		fHtmCoverTypedRegion
--		fHtmRegionToNormalFormString	-- manipulate region strings
--		fHtmRegionToTable
--      fHtmRegionObjects
--      fHtmNearbyEq
--      fHtmNearbyXYZ
--      fHtmNearestEq
--      fHtmNearestXYZ
----------------------------------------------------------------------------------
-- History:
--* 2005-05-01 Jim:  started
--* 2005-05-02 Jim:  removed fHtmLookup and fHtmLookupError
--*                  added fHtmToString
--* 2005-05-05 GYF:  added .pdb to assembly for symbolic debugging
--*                  added fHtmToName (faster than fHtmToString and reports error)
--* 2005-05-09 Jim:  Added more documentation.  
--*                  Replaced fHtmtoString with fHtmToName
--* 2005-05-11 Jim:  Added fDistanceEq, fDistanceXyz
--*	                 Changed fHtmToPoint to fHtmToCenterPoint
--*                          fHtmToVertices to fHtmToCornerPoints
--*                  Defaulted to release version of library.
--* 2005-05-17 GYF:  Added fHtmLatLon, fDistanceLatLon, fHtmCoverCircleLatLon
--* 2005-05-19 Jim:  Fixed comments re fHtmToPoint,fHtmToCenterPoint 
--* 2005-05-22 Jim:  Replace fHtmCoverError,  fHtmToNormalFormError() 
--                        with fHtmRegionError()
--                   Added LatLon to region syntax comments. 
--                   Added fHtmNearbyLatLon, fHtmNearbyEq, fHtmNearbyXYZ
--                   Added fHtmNearestLatLon, fHtmNearestEq, fHtmNearestXYZ
--* 2005-05-31 GYF:	 Added fHtmXyzToEq, fHtmXyzTolatLon,
--						   fHtmEqToXyz, fHtmLatLonToXyz
--* 2005-06-02 Jim:  Minor changes to comments.
--* 2005-06-04 Jim:  renamed fHtmGetNearbyXXX to fHtmNearbyXXX 
--                       and fHtmNearestXXX  to fHtNearestXXX 
--                     for XXX in {LatLon, Eq, Xyz}
--                   optimized distance test in the "near" routines. 
--* 2005-06-22 GYF:  added (fHtmCoverToHalfspaces see next:)
--* 2005-06-28 GYF:  changed the name to fHtmRegionToTable
--* 2005-06-29 Jim:  fixed code to have new-new function names.
--*                  fixed comments to reflect 21-deep (not 20 deep) HTMs
--* 2005-06-30 Jim:  Added fHtmRegionObjects
--* 2005-07-01 GYF:	 fHtmRegionObjects dropped properly
--* 2005-09-07 GYF:  fHtmCoverList added
--* 2006-08-07 GYF:  All latlon functions moved to spHtmGeoCsharp.sql
--* 2007-06-10 Alex: split package into two parts spHtmCsharp.sql, 
--*				containing only the core and spHtmSearch.sql
------------------------------------------------------------------------

SET NOCOUNT ON
go

if exists (select * from sys.objects where [name] = N'fHtmVersion') 
			drop function  fHtmVersion
if exists (select * from sys.objects where [name] = N'fHtmEq') 
			drop function  fHtmEq
if exists (select * from sys.objects where [name] = N'fHtmXyz') 
			drop function  fHtmXyz
if exists (select * from sys.objects where [name] = N'fHtmToString') 
			drop function  fHtmToString 
if exists (select * from sys.objects where [name] = N'fHtmXyzToEq') 
			drop function fHtmXyzToEq
if exists (select * from sys.objects where [name] = N'fHtmEqToXyz') 
			drop function fHtmEqToXyz
if exists (select * from sys.objects where [name] = N'fDistanceEq') 
			drop function fDistanceEq
if exists (select * from sys.objects where [name] = N'fDistanceXyz') 
			drop function fDistanceXyz
if exists (select * from sys.objects where [name] = N'fHtmIDToSquareArcmin') 
			drop function fHtmIDToSquareArcmin
if exists (select * from sys.objects where [name] = N'fHtmToCenterPoint') 
			drop function fHtmToCenterPoint
if exists (select * from sys.objects where [name] = N'fHtmToCornerPoints') 
			drop function fHtmToCornerPoints
if exists (select * from sys.objects where [name] = N'fHtmCoverCircleEq') 
			drop function  fHtmCoverCircleEq
if exists (select * from sys.objects where [name] = N'fHtmCoverCircleXyz') 
			drop function  fHtmCoverCircleXyz
if exists (select * from sys.objects where [name] = N'fHtmCoverRegion') 
			drop function  fHtmCoverRegion
if exists (select * from sys.objects where [name] = N'fHtmCoverTypedRegion') 
			drop function  fHtmCoverTypedRegion
if exists (select * from sys.objects where [name] = N'fHtmCoverRegionSelect') 
			drop function  fHtmCoverRegionSelect
if exists (select * from sys.objects where [name] = N'fHtmRegionToNormalFormString') 
			drop function fHtmRegionToNormalFormString
if exists (select * from sys.objects where [name] = N'fHtmCoverList') 
			drop function fHtmCoverList
if exists (select * from sys.objects where [name] = N'fHtmRegionToTable') 
			drop function fHtmRegionToTable
if exists (select * from sys.objects where [name] = N'fHtmRegionError') 
			drop function fHtmRegionError
if exists (select * from sys.objects where [name] = N'fHtmRegionObjects')
			drop function fHtmRegionObjects
if exists (select * from sys.objects where [name] = N'fHtmNearbyEq') 
			drop function fHtmNearbyEq
if exists (select * from sys.objects where [name] = N'fHtmNearbyXYZ') 
			drop function fHtmNearbyXYZ
if exists (select * from sys.objects where [name] = N'fHtmNearestEq') 
			drop function fHtmNearestEq
if exists (select * from sys.objects where [name] = N'fHtmNearestXYZ') 
			drop function fHtmNearestXYZ
if exists (select * from sys.objects where [name] = N'fHtmMagic') 
			drop function fHtmMagic
if exists (select * from sys.objects where [name] = N'fHtmGetString') 
			drop function fHtmGetString
if exists (select * from sys.objects where [name] = N'fHtmGetCornerPoints') 
			drop function fHtmGetCornerPoints
if exists (select * from sys.objects where [name] = N'fHtmGetCenterPoint') 
			drop function fHtmGetCenterPoint
if exists (select * from sys.objects where [name] = N'fHtmCoverRegionError')
			drop function fHtmCoverRegionError
if exists (select * from sys.objects where [name] = N'fHtmCoverRegionAdvanced')
			drop function fHtmCoverRegionAdvanced
if exists (select * from sys.objects where [name] = N'fHtmCoverBinaryAdvanced')
			drop function fHtmCoverBinaryAdvanced
go
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- various support functions, giving access to trixel properties
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--
CREATE FUNCTION fHtmVersion()
------------------------------------------------------------- 
--/H Returns version of installed HTM library as a string
--/U -------------------------------------------------------- 
--/T <samp> select dbo.fHtmVersion() </samp>  
------------------------------------------------------------- 
RETURNS nvarchar(max)
AS	external name SphericalHTM.[Spherical.Htm.Sql].fHtmVersion
GO


--===========================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmEq]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmEq]
GO
--
CREATE FUNCTION fHtmEq(@ra float, @dec float) 
---------------------------------------------------------------- 
--/H Returns htmid of a given point from an RA and DEC in J2000
--/U ----------------------------------------------------------- 
--/T <li> @ra float:  J2000 right ascension in degrees
--/T <li> @dec float: J2000 right declination in degrees
--/T <li> returns htmID bigint:  htmid of this point
--/T <br><samp> select dbo.fHtmEq(180,0):14843406974976 /samp>  
--/T <br> see also fHtmXyz 
---------------------------------------------------------------- 
RETURNS bigint
AS external name SphericalHTM.[Spherical.Htm.Sql].fHtmEq
GO


--===========================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmXyz]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmXyz]
GO
--
CREATE FUNCTION fHtmXyz(@x float, @y float, @z float) 
----------------------------------------------------------------- 
--/H Returns htmid given x,y,z in cartesian coordinates in J2000
--/U ------------------------------------------------------------ 
--/T Returns the Hierarchical Triangular Mesh (HTM) ID of a given point,
--/T given x,y,z in cartesian (J2000) reference frame. The vector 
--/T (x,y,z) will be normalized to unit vector if non-zero and set to 
--/T (1,0,0) if zero. Returns the 21-deep htmid of this object.<br>
--/T Parameters:<br>
--/T <li> @x float, unit vector for ra+dec
--/T <li> @y float, unit vector for ra+dec
--/T <li> @z float, unit vector for ra+dec
--/T <li> returns htmID bigint 
--/T <br><samp> select dbo.fHtmXyz(1,0,0) </samp>
--/T <br> gives 17042430230528  
--/T <br> see also fHtmEq 
---------------------------------------------------------------- 
RETURNS bigint
AS external name SphericalHTM.[Spherical.Htm.Sql].fHtmXyz
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmGetString]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmGetString]
GO
--
CREATE FUNCTION fHtmGetString (@htmid bigint)
---------------------------------------------------------------------
--/H  Converts an HTMID to its string representation 
--/U ----------------------------------------------------------------
--/T <br>Parameters:
--/T <li>htmid bigint: 21-deep htmid of this point
--/T <li> returns varchar(max) The string format is (N|S)[0..3]* 
--/T  <br> For example S130000013 is on the second face of the 
--/T  southern hemisphere, i.e. ra is between 6h and 12h  
--/T  <samp>print  dbo.fHtmToString(dbo.fHtmEq(195,2.5))
--/T  <br> gives: N120131233021223031323 </samp>
--------------------------------------------------------------------- 
RETURNS nvarchar(max)
AS	external name SphericalHTM.[Spherical.Htm.Sql].fHtmGetString
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmGetCenterPoint]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmGetCenterPoint]
GO
--
CREATE FUNCTION fHtmGetCenterPoint(@htmid bigint)
---------------------------------------------------------------------
--/H  Converts an HTMID to a (x,y,z) vector of the HTM centerpoint  
---------------------------------------------------------------------
--/T <br>Parameters:
--/T <li>@htmid bigint, the htmid of the trixel
--/T <br>Returns VertexTable(x float, y float, z float) of a single
--/T row with the unit vector of the trixel center.
--/T  <samp>select * from  fHtmToCenterPoint(dbo.fHtmXyz(.57735,.57735,.57735))
--/T  <br> gives: 0.577350269189626, 0.577350269189626, 0.577350269189626 
--/T  </samp>
----------------------------------------------------- 
RETURNS	table (x float, y float, z float)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmGetCenterPoint
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmGetCornerPoints]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmGetCornerPoints]
GO
--
CREATE FUNCTION fHtmGetCornerPoints(@htmid bigint)
---------------------------------------------------------------------
--/H  Converts an HTMID to the trixel's vertices as cartesian vectors
---------------------------------------------------------------------
--/T <br>Parameter:
--/T <li>htmid bigint, htmid of the trixel
--/T <br>Returns VertexTable(x float, y float, z float) 
--/T with three rows contining the trixel's vertices
--/T  <samp>select * from  fHtmToCornerPoints(8)
--/T  <br> gives:
--/T  <br>        1 0 0
--/T  <br>        0 0 0
--/T  <br>        0 1 0
--/T  </samp>
----------------------------------------------------- 
RETURNS	table (x float, y float, z float)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmGetCornerPoints
GO


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- the various cover related functions
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmCoverCircleEq]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmCoverCircleEq]
GO
--
CREATE FUNCTION fHtmCoverCircleEq (@ra float, @dec float, @radius float) 
------------------------------------------------------------- 
--/H Returns the HTM Cover of a circle with a given ra,dec and radius
--/U -------------------------------------------------------- 
--/T Returns a table of htmid ranges describing an HTM cover
--/T for a circle centered at J2000 ra,dec (in degrees)
--/T within  @radius arcminutes of that centerpoint.
--/T <br>Parameters:<br>
--/T <li> @ra  float, J2000 right ascension in degrees
--/T <li> @dec float, J2000 declination in degrees
--/T <li> @radius float, radius in arcminutes
--/T <li> returns trixel table(HtmIDStart bigint, HtmIDEnd bigint)
--/T <br><samp> select * from fHtmCoverCircleEq( 190,0,1)</samp>  
--/T <br> see also fHtmCoverCircleXyz, fHtmCoverRegioin
------------------------------------------------------------- 
RETURNS table(HtmIDStart bigint, HtmIDEnd bigint)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverCircleEq 
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmCoverCircleXyz]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmCoverCircleXyz]
GO
--
CREATE FUNCTION fHtmCoverCircleXyz(@x float, @y float, @z float, @radius float)
---------------------------------------------------------------------------------
--/H Returns HTM cover for a circle given with cartesian vector (x,y,z), radius
--/U ----------------------------------------------------------------------------
--/T Returns a table of HTMID ranges covering a circle centered at CARTESIAN @x,@y,@z 
--/T within  @radius arcminutes of that centerpoint
--/T <li> @x float, @y float, @z float, cartesian unit vector for point
--/T <li> @radius float, radius in arcmins 
--/T <br> Returns trixel table(HtmIDStart bigint, HtmIDEnd bigint)
--/T <br><samp> select * from fHtmCoverCircleXyz( 1,0,0, 1)</samp>  
--/T <br> see also fHtmCoverCircleEq fHtmCoverRegion 
--------------------------------------------------------------------------------- 
RETURNS table  (HtmIDStart bigint, HtmIDEnd bigint)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverCircleXyz
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmCoverRegion]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmCoverRegion]
GO
--
CREATE FUNCTION fHtmCoverRegion(@region nvarchar(max)) 
---------------------------------------------------------------------
--/H Returns HTMID range table covering the designated region
--/U ----------------------------------------------------------------
--/T Regions have the syntax
--/T <pre>
--/T circleSpec  =>     CIRCLE J2000 ra dec  radArcMin  
--/T            |       CIRCLE CARTESIAN x y z   radArcMin
--/T rectSpec    =>     RECT J2000      {ra dec }2
--/T            |       RECT CARTESIAN  {x y z  }2
--/T polySpec    =>     POLY J2000      {ra dec }3+
--/T            |       POLY CARTESIAN  {x y z  }3+
--/T hullSpec    =>     CHULL J2000     {ra dec }3+
--/T            |       CHULL CARTESIAN {x y z  }3+
--/T convexSpec	 =>     CONVEX { x y z D}*
--/T coverSpec	 =>     circleSpec | rectSpec | polySpec | hullSpec | convexSpec
--/T regionSpec	 =>     REGION {coverSpec}* | coverspec 
--/T <br> for the circle the REGION prefix is optional.
--/T </pre> 
--/T <br> returns trixel table(start bigint, end bigint)
--/T <br><samp>
--/T select * from dbo.fHtmCoverRegion('REGION CIRCLE CARTESIAN -.996 -.1 0 5')
--/T </samp>  
--/T <br>see also fHtmCoverRegionError 
--------------------------------------------------------------------
RETURNS	table  (HtmIDStart bigint, HtmIDEnd bigint)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverRegion
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmCoverRegionError]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmCoverRegionError]
GO
--
CREATE FUNCTION fHtmCoverRegionError(@region nvarchar(max))
---------------------------------------------------------------------
--/H Returns an error message describing what is wrong with @region. 
-------------------------------------------------------------
--/T Regions have the syntax
--/T <pre>
--/T circleSpec  =>     CIRCLE J2000 ra dec  radArcMin  
--/T            |       CIRCLE CARTESIAN x y z   radArcMin
--/T rectSpec    =>     RECT J2000      {ra dec }2
--/T            |       RECT CARTESIAN  {x y z  }2
--/T polySpec    =>     POLY J2000      {ra dec }3+
--/T            |       POLY CARTESIAN  {x y z  }3+
--/T hullSpec    =>     CHULL J2000     {ra dec }3+
--/T            |       CHULL CARTESIAN {x y z  }3+
--/T convexSpec	 =>     CONVEX { x y z D}*
--/T coverSpec	 =>     circleSpec | rectSpec | polySpec | hullSpec | convexSpec
--/T regionSpec	 =>     REGION {coverSpec}* | coverspec 
--/T <br> for the circle the REGION prefix is optional.
--/T </pre> 
--/T <li> Returns: OK, or string giving the above syntax if the region description is in error. 
--/T <br><samp>select dbo.fHtmRegionError('CIRCLE LATLON 190')</samp>  
--/T <br>see also fHtmCoverRegion
--------------------------------------------------------------
RETURNS nvarchar(max)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverRegionError
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmCoverBinaryAdvanced]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmCoverBinaryAdvanced]
GO
--
/*
CREATE FUNCTION fHtmCoverBinaryAdvanced(@bin varbinary(max)) 
---------------------------------------------------------------------
--/H Returns table of htmid ranges with a flag designating inner or outer
--/U -------------------------------------------------------
--/T Returns table of HTMID ranges covering a region with an
--/T existing regionBinary. Saves the need to recompute the region
--/T if it has already been done.<br>
--/T The code generates two different types of cover, indicated by its status
--/T <li> 0: OUTER, which fully covers the region,
--/T <li> 1: INNER, which contains trixels fully inside the region.
--/T For the region syntax see the description of fHtmCoverRegion.
--/T <br>Returns table:
--/T <li>htmidStart bigint, 21-deep HtmID range start
--/T <li>htmidEnd   bigint, 21-deep HtmID range end
--/T <li>innerFlag int, 0:outer, 1:inner
--/T <br><samp>
--/T select * from fHtmCoverBinaryAdvanced(@regionBinary)  
--/T </samp>  
--/T <br>see also fHtmCoverRegion, fHtmCoverRegionError 
-----------------------------------------------------------------
RETURNS	table  (htmidStart bigint, htmidEnd bigint, innerFlag int)
AS		as external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverRegionBinary
*/
GO

	--dbo.fSphSimplifyString('circle j2000 180 0 )

--=======================================================
CREATE FUNCTION fHtmCoverBinaryAdvanced(@bin varbinary(max))
RETURNS	table  (htmidStart bigint, htmidEnd bigint, innerFlag bit)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverBinaryAdvanced
GO

CREATE FUNCTION fHtmCoverRegionAdvanced(@region nvarchar(max)) 
---------------------------------------------------------------------------------
--/H Returns tables of HTMID ranges with flags designating inner/oouter status 
--/U ----------------------------------------------------------------------------
--/T Returns table of HTMID ranges covering a designated region.
--/T The code generates two different types of cover, indicated by its status
--/T <li> 0: OUTER, which fully covers the region,
--/T <li> 1: INNER, which contains trixels fully inside the region.
--/T For the region syntax see the description of fHtmCoverRegion.
--/T <br>Returns table:
--/T <li>htmidStart bigint, 21-deep HtmID range start
--/T <li>htmidEnd   bigint, 21-deep HtmID range end
--/T <li>innerFlag int, 0:outer, 1:inner
--/T <br><samp>
--/T <br>select * from fHtmCoverRegionAdvanced('REGION CIRCLE CARTESIAN -.996 -.1 0 5')  
--/T </samp>  
--/T <br>see also fHtmCoverRegion, fHtmCoverRegionError 
RETURNS	table  (htmidStart bigint, htmidEnd bigint, innerFlag bit)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverRegionAdvanced
GO


--=======================================================
--
/*
CREATE FUNCTION fHtmCoverRegionList(@region nvarchar(max)) 
---------------------------------------------------------------------
--/H Returns table of HTM Trixels with iinner and outer covers of a designated region
--/U ----------------------------------------------------------------
--/T The code generates two different types of cover, indicated by its status
--/T <li> 0: OUTER, which fully covers the region,
--/T <li> 1: INNER, which contains trixels fully inside the region.
--/T For the region syntax see the description of fHtmCoverRegion.
--/T <br>Returns table:
--/T <li>htmid bigint, 21-deep HtmID
--/T <li>innerFlag int, 0:outer, 1:inner
--/T <br><samp>
--/T select * from fHtmCoverRegionList('REGION CIRCLE CARTESIAN -.996 -.1 0 5')  
--/T </samp>  
--/T <br>see also fHtmCoverRegion, fHtmCoverRegionError 
RETURNS	table  (htmid bigint, innerFlag int)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverList
*/
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmCoverRegionSelect]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmCoverRegionSelect]
GO
--
/*
CREATE FUNCTION fHtmCoverRegionSelect(@region nvarchar(max),@type nvarchar(max)) 
---------------------------------------------------------------------
--/H Returns table of htmid ranges with a flag designating inner or outer
--/U -------------------------------------------------------
--/T Returns table of HTMID ranges covering a designated region. 
--/T The code can generate different types of cover: 
--/T <li> 1: OUTER, which fully covers the region,
--/T <li> 2: INNER, which contains trixels fully inside the region
--/T <li> 3: generate both covers with a single call
--/T For the region syntax see the description of fHtmCoverRegion.
--/T <br> Returns trixel table(start bigint, end bigint)
--/T <br><samp>
--/T select * from fHtmCoverRegionSelect('REGION CIRCLE CARTESIAN -.996 -.1 0 5',3)  
--/T </samp>  
--/T <br>see also fHtmCoverRegion, fHtmCoverRegionError 
-----------------------------------------------------------------
RETURNS	table  (HtmIDStart bigint, HtmIDEnd bigint)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmCoverRegionSelect
*/
GO





--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- utility functions, should eventually be renamed and moved
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fDistanceEq]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fDistanceEq]
GO
--
CREATE FUNCTION fDistanceEq(@ra1 float, @dec1 float, @ra2 float, @dec2 float) 
----------------------------------------------------------------------------------
--/H returns distance (arcmins) between two points (ra1,dec1) and (ra2,dec2)
--/U -----------------------------------------------------------------------------
--/T <br> @ra1, @dec1, @ra2, @dec2 are in degrees
--/T <br><samp>select top 10 objid, dbo.fDistanceEq(185,0,ra,dec) from PhotoObj </samp>
-------------------------------------------------------------
RETURNS	float
AS		external name SphericalHTM.[Spherical.Htm.Sql].fDistanceEq
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fDistanceXyz]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fDistanceXyz]
GO
--
CREATE FUNCTION fDistanceXyz(
	@x1 float, @y1 float, @z1 float, 
	@x2 float, @y2 float, @z2 float ) 
-------------------------------------------------------------------------------
--/H returns distance (arcmins) between two points (x1,y1,z1) and (x2,y1,z2)
--/U --------------------------------------------------------------------------
--/T <br> x1,y1,z1 and x2,y2,z2 are cartesian unit vectors 
--/T <br><samp>select top 10 objid, dbo.fDistanceXyz(1,0,0,cx,cy,cz) from PhotoObj </samp>
-------------------------------------------------------------
RETURNS float
AS external name SphericalHTM.[Spherical.Htm.Sql].fDistanceXyz
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmEqToXyz]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmEqToXyz]
GO
--
CREATE FUNCTION fHtmEqToXyz(@ra float, @dec float)
------------------------------------------------------------------
--/H Convert Ra, Dec to Cartesian coordinates (x, y, z)
------------------------------------------------------------------
--/T <br>Parameters:
--/T <li>@ra float, Right Ascension
--/T <li>@dec float, Declination
--/T <br>Returns single row table containing the vector (x, y, z)
--/T <samp>select * from dbo.fHtmEqToXyz(-180.0, 0.0)
--/T <br> gives:  x  y  z
--/T <br>        -1  0  0
--/T </samp>
-----------------------------------------------------------------
RETURNS table (x float, y float, z float)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmEqToXyz
GO


--=======================================================
IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[fHtmXyzToEq]') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fHtmXyzToEq]
GO
--
CREATE FUNCTION fHtmXyzToEq(@x float, @y float, @z float) 
------------------------------------------------------------------
--/H Convert Cartesian coordinates (x, y, z) to Ra, Dec
--/U -------------------------------------------------------------
--/T (x, y, z) will be normalized unless (x, y, z) is close to (0,0,0)
--/T <br>Parameters:
--/T <li>@x float, @y float, @z float, the cartesian normal vector
--/T <br>Returns single row table containing the values (ra, dec)
--/T <samp>select * from dbo.fHtmXyzToEq(0.0, 0.0, -1.0)
--/T <br> gives:  ra  dec
--/T <br>          0  -90
--/T </samp>
-----------------------------------------------------------------
RETURNS table (ra float, dec float)
AS		external name SphericalHTM.[Spherical.Htm.Sql].fHtmXyzToEq
GO



-------------------------------------
declare @version varchar(max)
select @version = dbo.fHtmVersion()
----------------------------------------------------------------------------------------------
PRINT '[spHtmCsharp.sql]: Version: ' + @version + ' of the HTM library successfully installed.'
----------------------------------------------------------------------------------------------
GO 
