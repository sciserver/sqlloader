--==============================================================
--   spNearby.sql
--   2000-01-14 Alex Szalay and Jim Gray
----------------------------------------------------------------
-- Functions handling simple proximity queries
----------------------------------------------------------------
--* 2001-05-15 Alex: Changed to HTMIDstart, HTMIDend
--* 2001-11-08 Jim: removed PhotoSpectro table join
--* 2001-11-28 Alex+Jim: documentation 
--* 2001-12-08 Jim: moved *Near* functions to *Near* file.
--*             converted to ASIN() rather than cartesian distance.
--* 2002-06-21 Jim+Alex: Added fGetNearbyMosaicEq, fGetNearbyFrameEq, fGetJpegObjects
--*             for CutOut Service and convereted Mosaic and Frame functions to use
--*             trig rather than dot-product distance. 
--* 2002-09-12 Ani: Fix for skyserver/4233 - replaced "N.*" with "*" in 
--*             fGetNearestObjEq example
--* 2002-09-14 Jim+Alex+Ani:  
--*		Fixed fGetNearest* bug (return nearest object not smalles objID
--*		Added more and better comments to most routines.
--* 		Moved spatial functions here from WebSupport
--*		Added fDistanceArcMinEq and fDistanceArcMinXYZ
--* 		Removed use SkyServerV3
--* 2002-09-26 Alex: commented out fGetJPEGObjects, since there is no specObjID in photoObj
--* 2002-10-26 Alex: removed PRIMARY KEY designator from nearby functions, this caused
--*		incorrect behaviour with respect to order by distance
--* 2002-11-26 Alex: removed Mosaic functions
--* 2003-02-05 Alex: added back the fJpegObjects
--* 2003-02-19 Alex: added fGetNearestFrameidEq
--* 2003-02-23 Alex: added objid to fGetJpegObjects, so that we can join with AtlasOutline
--* 2003-03-03 Alex: added PlateX to fGetJpegObjects
--* 2003-04-06 Alex: modified the upper limit on the search radius for
--*             fGetJpegObjects, set it to 250 arcsec.
--* 2003-07-09 Jim: converted to HTM V2 functions (that do auto-level select
--*             and that use new syntax for cover). Dropped fGetObjectsWWT.
--*             Renamed fGetJpegObjects to fGetObjectsEq
--* 2003-12-03 Jim: for SQL best practices, 
--*		added distance to frame function results
--*             fixed select * and Top 1 orderby problems 
--*             fixed fGetNearbyFrameEq() and fGetNearestFrameEq()
--* 2004-01-11 Ani: Fixed bug in fGetNearbyObjAllXyZ (join with PhotoTag instead of
--*             PhotoPrimary). Also, created fGetNearbyObjAllEq as "all" version of 
--*             fGetNearbyObjEq and changed fGetObjFromRect to call 
--*             that instead.
--* 2004-02-13 Alex: in fGetObjectsEq allowed larger radius for the Plates (flag=16).
--* 2004-02-19 Ani: Fix for PR #5879, set minimum search radius to 0
--*		for fGetNearbyObjEq, fGetNearbyObjAllEq, 
--*             fGetNearbyObjXYZ and fGetNearbyObjAllXYZ (was 0.1 arcmin before).
--* 2004-04-02 Ani: Modified spGetNeighbors to call fGetNearbyObjAllEq instead of
--*             fGetNearbyObjEq, so that all neighbors are returned, not just primaries.
--* 2004-05-27 Ani: Added spGetNeighborsPrim and spGetNeighborsAll to have
--*             2 versions of spGetNeighbors (which is same as 
--*             spGetNeighborsAll) for the crossid to call.  This was
--*             to add "All nearby primary objects" option.
--* 2004-09-15 Alex: added again spGetMatch
--* 2004-11-22 Alex: added flag=32 from PhotoObjAll to fGetObjectsEq
--* 2005-04-15 Ani: Added spGetNeighborsRadius for casjobs variable 
--*            radius searches.
--* 2005-10-11 Ani: added fGetNearestObjAllEq, fGetNearestObjIdAllEq
--*            and fGetObjectsMaskEq, all of which were patched in 
--*            after DR3 but somehow didnt make it here.
--* 2005-12-23 Ani: Created fGetObjFromRectEq as a variant of fGetObjFromRect
--*            that takes the params in the order (ra1,dec1,ra2,dec2) 
--*            instead of (ra1,ra2,dec1,dec2).  See PR #6829.
--* 2006-05-21 Jim: CHanges for C# HTM rountines (SQL 2005 only)
--*            Converted from "string" to direct fHtmCoverCircleXyz() calls
--*            replaced cursors in spGetNeighbors, spGetNeighborsRadius and 
--*            spGetNeighborsPrim(@r) with cross-apply (SQL 2005 only).
--* 2006-12-14 Ani: Added db compatibility and CLR enable commands.
--* 2007-01-24 Ani: Replaced PhotoTag join with PhotoObjAll in 
--*            fGetNearbyObjAllXYZ, because PhotoTag has a covering index
--*            missing which causes the join to be very slow.
--* 2007-02-15 Ani: Added ORDER BY <distance> to each query in 
--*            fGetObjectsEq to speed it up in 2k5.
--* 2007-03-09 Ani: Changed #objects to #upload in spGetNeighbors (was
--*            a typo in 2005 "cross apply" update, see 2006-05-21).
--* 2007-10-02 Ani: Replaced fGetNearbyFrameEq with sql2k5 version from
--*            Alex that was added to patches in July/07.
--* 2008-08-08 Ani: Fix for PR #6906 (correct doc for fGetNearbyObjAllEq).
--* 2008-08-09 Ani: Fix for PR #6913 (correct doc for fGetObjFromRectEq).
--* 2008-10-21 Ani: Added fGetNearby/est SpecObj equivalents (PR #6359).
--* 2010-02-23 Victor: updated fgetnearbyspecobj* functions for changes 
--*            to specobjall schema for SDSS3
--* 2010-05-13 Ani: Added NOT NULL to fGetNearbyObj[All]Eq.objid.
--* 2010-12-10 Ani: Updated fGetNearestSpecObjIdType for string "class".
--* 2010-12-11 Ani: Removed fGetNearestSpecObjIdType.
--* 2010-12-11 Ani: Applied performance enhancement changes as per
--*                 Alex & Deoyani (for SQL Server 2008).
--* 2010-12-14 Ani: Added missing changes for fGetObjectsEq from
--*                 previous.
--* 2011-02-03 Ani: Fixed typo in spGetNeighbors - changed call to
--*                 fGetNearbySpecObjAllEq to fGetNearbyObjAllEq.
--* 2011-02-21 Ani: Added perf tweak to fGetNearbySpecObj[All]XYZ too.
--* 2012-11-15 Ani: Applied fix from Alex to fGetObjectsEq for specobj.
--* 2013-05-10 Ani: Added functions fGetNear[by|est]ApogeeStarEq for
--*                 APOGEE searches.
--* 2013-05-16 Ani: Added ra/dec to fGetNear[by|est]ApogeeStarEq output.
--* 2013-05-16 Ani: Moved fDistanceArcMin* functions to the top.
--* 2013-07-11 Ani: Added dbo qualifier to fDistanceArcMinEq calls, and
--*                 replaced "star" column with apogee_id in APOGEE
--*                 functions.
--* 2016-04-22 Ani: Added functions fGetNear[by|est]MangaObjEq for
--*                 MaNGA searches.
--* 2016-04-26 Ani: Updated data types returned by MaNGA functions
--*                 fGetNear[by|est]MangaObjEq to match the table schema.
--*
--* 2017-04-19 Sue: Added inner loop join to fGetNearbyObjXYZ and fGetNearbyObjAllXYZ
--*                 to fix performance issues with clustered columnstore indexes
--*					Commented out code to set DB compatibility level to SQL2005
--* 2018-03-29 Sue: Fixed spec functions to return numeric(20) instead of bigint
--* 2019-01016 Sue: fGetObjectsEq now returns numeric(20) instead of bigint
--* 2020-02-11 Sue: changed apstar_id from varchar(50) to (64) in  fGetNearbyApogeeStarEq
--* 2023-01-05 Ani: Added fGetNearbyMosTargetEq for DR18.
--* 2023-02-16 Sue: updated fGetNearbyApogeeStarEq and fGetNearbyMosTargetEq for performance 
--*					added fGetNearbyApogeeStarXYZ and fGetNearbyMosTargetXYZ
--*					added fGetNearestMosTargetEq
--* 2023-02-17 Ani: Added fGetNearestMosTargetXYZ, fGetNearestApogeeStar[Eq|XYZ],
--*                 updated documentation text for new functions added for DR18.
--* 2023-02-20 Ani: Added back fGetNear[by|est]MastarEq functions (DR18) with change to
--                  ra,dec column names.
--* 2025-07-03 Sue: Adding fGetNearby and Nearest functions for Allspec, ApogeeDRPAllstar, spAll tables
--=====================================================================
SET NOCOUNT ON;
GO



--===================================================================
IF EXISTS (SELECT name FROM   sysobjects
           WHERE  name = N'fDistanceArcMinEq' )
	DROP FUNCTION fDistanceArcMinEq
GO
--
CREATE FUNCTION fDistanceArcMinEq(@ra1 float, @dec1 float, 
                                  @ra2 float, @dec2 float)
-------------------------------------------------------------
--/H returns distance (arc minutes) between two points (ra1,dec1) and (ra2,dec2)
-------------------------------------------------------------
--/T <br> ra1, dec1, ra2, dec2 are in degrees
--/T <br>
--/T <samp>select top 10 objid, dbo.fDistanceArcMinEq(185,0,ra,dec) from PhotoObj </samp>
-------------------------------------------------------------
RETURNS float as
  BEGIN
	DECLARE @d2r float,@nx1 float,@ny1 float,@nz1 float, @nx2 float,@ny2 float,@nz2 float
	SET @d2r = PI()/180.0
	SET @nx1  = COS(@dec1*@d2r)*COS(@ra1*@d2r)
	SET @ny1  = COS(@dec1*@d2r)*SIN(@ra1*@d2r)
	SET @nz1  = SIN(@dec1*@d2r)
	SET @nx2  = COS(@dec2*@d2r)*COS(@ra2*@d2r)
	SET @ny2  = COS(@dec2*@d2r)*SIN(@ra2*@d2r)
	SET @nz2  = SIN(@dec2*@d2r)

  RETURN ( 2*DEGREES(ASIN(sqrt(power(@nx1-@nx2,2)+power(@ny1-@ny2,2)+power(@nz1-@nz2,2))/2))*60)
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fDistanceArcMinXYZ' )
	DROP FUNCTION fDistanceArcMinXYZ  
GO
--
CREATE FUNCTION fDistanceArcMinXYZ(@nx1 float, @ny1 float, @nz1 float, 
					@nx2 float, @ny2 float, @nz2 float)
-------------------------------------------------------------
--/H returns distance (arc minutes) between two points (x1,y1,z1) and (x2,y2,z2)
-------------------------------------------------------------
--/T <br> the two points are on the unit sphere
--/T <br>
--/T <samp>select top 10 objid, dbo.fDistanceArcMinXYZ(1,0,0,cx,cy,cz) from PhotoObj </samp>   
-------------------------------------------------
RETURNS float as
BEGIN
    DECLARE @d2r float 
    RETURN ( 2*DEGREES(ASIN(sqrt(power(@nx1-@nx2,2)+power(@ny1-@ny2,2)+power(@nz1-@nz2,2))/2))*60) 
END
GO


--===================================================================
/*
select (1.0 - dbo.fDistanceArcMinEq(185,0,185.0, 1.0/60.0))*60
-- ok, .002 arcseconds
 
select (1.0 - dbo.fDistanceArcMinEq(185,0,185+1.0/60.0,0))*60
-- ok, .002 arcseconds

select (30.0 - dbo.fDistanceArcMinEq(185,0,185+30.0/60.0,0))*60
*/


--=======================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearbyObjEq' )
	DROP FUNCTION fGetNearbyObjEq
GO
--
CREATE FUNCTION fGetNearbyObjEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Given an equatorial point (@ra,@dec), returns table of primary objects
--/H within @r arcmins of the point.  There is no limit on @r. 
-------------------------------------------------------------
--/T <br> ra, dec are in degrees, r is in arc minutes.
--/T <br>There is no limit on the number of objects returned, but there are about 40 per sq arcmin.  
--/T <p> returned table:  
--/T <li> objID bigint NOT NULL       -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br>
--/T Sample call to find all the Galaxies within 3 arcminutes of ra,dec 185,0<br>
--/T <samp> 
--/T <br> select * 
--/T <br> from Galaxy                       as G, 
--/T <br>      dbo.fGetNearbyObjEq(185,0,3) as N
--/T <br> where G.objID = N.objID
--/T </samp> 
--/T <br> see also fGetNearestObjEq, fGetNearbyObjXYZ, fGetNearestObjXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    objID bigint NOT NULL,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) 
  AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbyObjXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO


--=======================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearbyObjAllEq' )
	DROP FUNCTION fGetNearbyObjAllEq
GO
--
CREATE FUNCTION fGetNearbyObjAllEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Given an equatorial point (@ra,@dec), this function returns a table of all 
--/H objects within @r arcmins of the point.  There is no limit on @r.
-------------------------------------------------------------
--/T <br> ra, dec are in degrees, r is in arc minutes.
--/T <br>There is no limit on the number of objects returned, but there are about 40 per sq arcmin.  
--/T <p> returned table:  
--/T <li> objID bigint NOT NULL,      -- Photo object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br>
--/T Sample call to find all the Galaxies within 3 arcminutes of ra,dec 185,0<br>
--/T <samp> 
--/T <br> select * 
--/T <br> from Galaxy                       as G, 
--/T <br>      dbo.fGetNearbyObjEq(185,0,3) as N
--/T <br> where G.objID = N.objID
--/T </samp> 
--/T <br> see also fGetNearestObjEq, fGetNearbyObjAllXYZ, fGetNearestObjXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    objID bigint NOT NULL,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    mode tinyint NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) 
  AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbyObjAllXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spNearestObjEq' )
	DROP PROCEDURE spNearestObjEq
GO
--
CREATE PROCEDURE spNearestObjEq
	@ra  float, 
	@dec float, 
	@r   float
------------------------------------------------------------------
--/H Returns table containing the nearest primary object within @r arcmins of an Equatorial point (@ra,@dec)
--/T <br>For the Navigator. Returns the nearest primary object to a given point
--/T <br> ra, dec are in degrees.
-------------------------------------------------------------
--/T <p> returned table:  
--/T <li> run int,           		-- run that observed this primary object   
--/T <li> objID bigint,   		-- Photo object identifier
--/T <li> ra varchar(10),   		-- ra rounded to 5 decimal places.
--/T <li> dec varchar(8),   		-- dec rounded to 5 decimal places.
--/T <li> type varchar(8),        	-- type: galaxy, star, sky... 
--/T <li> U, G, R, I, Z,  varchar(6), 	-- magnitude/luptitude rounded to 2 digits.
--/T <li> distance varchar(6)        	-- distance in arc minutes to this object from the ra,dec.
--/T <br>
--/T Sample call to find all the Galaxies within 2 arcminutes of ra,dec 185,-0.5  <br>
--/T <samp> 
--/T <br> EXEC spNearestObjEq 185.0 -0.5 2
--/T </samp> 
--/T <br> see also fGetNearbyObjEq, fGetNearestObjEq, fGetNearbyObjXYZ, fGetNearestObjXYZ
------------------------------------------------------------------
AS
    SELECT TOP 1
	P.run,
	P.[objID] AS 'id',
	LTRIM(STR(P.ra,10,5))as ra,
	LTRIM(STR(P.dec,8,5)) as dec,
	dbo.fPhotoTypeN(P.type) as 'type',
	LTRIM(STR(P.u,6,2)) AS 'u', 
	LTRIM(STR(P.g,6,2)) AS 'g', 
 	LTRIM(STR(P.r,6,2)) AS 'r', 
	LTRIM(STR(P.i,6,2)) AS 'i',
	LTRIM(STR(P.z,6,2)) AS 'z',
 	LTRIM(STR(distance*60,7,3)) AS 'dist'
    FROM fGetNearbyObjEq (@ra, @dec, @r) as H, PhotoPrimary as P
    WHERE H.objID = P.objID
	AND P.i>0
	ORDER BY H.distance ASC 
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestObjEq')
	DROP FUNCTION fGetNearestObjEq
GO
--
CREATE FUNCTION fGetNearestObjEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table holding a record describing the closest primary object within @r arcminutes of (@ra,@dec).
--/T <br> ra, dec are in degrees, r is in arc minutes.
-------------------------------------------------------------
--/T <p> returned table: 
--/T <li> objID bigint,               -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br
--/T Sample call to find the PhotoObject within 1 arcminutes of ra,dec 185,0
--/T <br><samp>
--/T <br> select * 
--/T <br> from   dbo.fGetNearestObjEq(185,0,1)   
--/T </samp>  
--/T <br> see also fGetNearbyObjEq, fGetNearbyObjXYZ, fGetNearestObjXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    objID bigint,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float,@nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT top 1 * 
	FROM dbo.fGetNearbyObjXYZ(@nx,@ny,@nz,@r)
	ORDER BY distance ASC   -- order by needed to get the closest one.
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestObjAllEq')
	DROP FUNCTION fGetNearestObjAllEq
GO
--
CREATE FUNCTION fGetNearestObjAllEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table holding a record describing the closest object within @r arcminutes of (@ra,@dec).
--/T <br> ra, dec are in degrees, r is in arc minutes.
-------------------------------------------------------------
--/T <p> returned table: 
--/T <li> objID bigint,               -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br
--/T Sample call to find the PhotoObject within 1 arcminutes of ra,dec 185,0
--/T <br><samp>
--/T <br> select * 
--/T <br> from   dbo.fGetNearestObjAllEq(185,0,1)   
--/T </samp>  
--/T <br> see also fGetNearbyObjAllEq, fGetNearbyObjAllXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    objID bigint,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    mode int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float,@nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT top 1 * 
	FROM dbo.fGetNearbyObjAllXYZ(@nx,@ny,@nz,@r)
	ORDER BY distance ASC   -- order by needed to get the closest one.
  RETURN
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestObjIdEq')
	DROP FUNCTION fGetNearestObjIdEq
GO
--
CREATE FUNCTION fGetNearestObjIdEq(@ra float, @dec float, @r float)
-------------------------------------------------
--/H Returns the objId of nearest photoPrimary within @r arcmins of ra, dec
--/T <br> ra, dec are in degrees, r is in arc minutes.
-------------------------------------------------
--/T <br>This scalar function is used for matchups of external catalogs.
--/T <br>It calls  <samp>fGetNearestObjEq(@ra,@dec,@r)</samp>, and selects 
--/T the objId (a bigint). 
--/T <br>This can be called by a single SELECT from an uploaded (ra,dec) table.
--/T <br>An example: 
--/T <br><samp>
--/T <br>  SELECT id, ra,dec, dbo.fGetNearestObjIdEq(ra,dec,3.0) as objId
--/T <br>      FROM #upload
--/T <br>      WHERE dbo.fGetNearestObjIdEq(ra,dec,3.0) IS NOT NULL
--/T</samp><p>
-------------------------------------------------
RETURNS bigint
AS BEGIN
    RETURN (select objID from dbo.fGetNearestObjEq(@ra,@dec,@r)) 
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestObjIdAllEq' )
	DROP FUNCTION fGetNearestObjIdAllEq
GO
--
CREATE FUNCTION fGetNearestObjIdAllEq(@ra float, @dec float, @r float)
-------------------------------------------------
--/H Returns the objId of nearest photo object within @r arcmins of ra, dec
--/T <br> ra, dec are in degrees, r is in arc minutes.
-------------------------------------------------
--/T <br>This scalar function is used for matchups of external catalogs.
--/T <br>It calls  <samp>fGetNearestObjAllEq(@ra,@dec,@r)</samp>, and selects 
--/T the objId (a bigint). 
--/T <br>This can be called by a single SELECT from an uploaded (ra,dec) table.
--/T <br>An example: 
--/T <br><samp>
--/T <br>  SELECT id, ra,dec, dbo.fGetNearestObjIdAllEq(ra,dec,3.0) as objId
--/T <br>      FROM #upload
--/T <br>      WHERE dbo.fGetNearestObjIdAllEq(ra,dec,3.0) IS NOT NULL
--/T</samp><p>
-------------------------------------------------
RETURNS bigint
AS BEGIN
    RETURN (select objID from dbo.fGetNearestObjAllEq(@ra,@dec,@r)) 
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestObjIdEqType' )
	DROP FUNCTION fGetNearestObjIdEqType
GO
--
CREATE FUNCTION fGetNearestObjIdEqType (@ra float, @dec float, @r float, @t int)
-------------------------------------------------------------
--/H Returns the objID of the nearest photPrimary of type @t within @r arcmin
--/T <br> ra, dec are in degrees, r is in arc minutes.
--/T <br> t is an integer drawn from the PhotoType table. 
--/T <br> popular types are 3: GALAXY, 6: STAR
--/T <br> others: 0: UNKNOWN, 1:COSMIC_RAY  2: DEFECT, 4: GHOST, 5: KNOWNOBJ, 7:TRAIL, 8: SKY 
-------------------------------------------------------------
--/T This scalar function is used for matchups of external catalogs.
--/T It calls the <samp>fGetNearbyObjEq(@ra,@dec,@r)</samp>, and selects
--/T the objId (a bigint). This can be called by a single SELECT from an uploaded
--/T (ra,dec) table.
--/T <br>An example: 
--/T <br><samp>
--/T <br>  SELECT id, ra,dec, dbo.fGetNearestObjIdEqType(ra,dec,3.0,6) as objId
--/T <br>      FROM #upload
--/T <br>      WHERE dbo.fGetNearestObjIdEqType(ra,dec,3.0,6) IS NOT NULL
--/T</samp><p>
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
    RETURN (	select top 1 objID 
		from dbo.fGetNearbyObjEq(@ra,@dec,@r)
		where type=@t 
		order by distance asc ) 
END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearestObjIdEqMode' ) 
	DROP FUNCTION fGetNearestObjIdEqMode
GO
--
CREATE FUNCTION fGetNearestObjIdEqMode(@ra float, @dec float, 
					@r float, @mode int)
-------------------------------------------------
--/H Returns the objId of nearest @mode PhotoObjAll within @r arcmins of ra, dec
--/T <br> ra, dec are in degrees, r is in arc minutes.
-------------------------------------------------
--/T <br>This scalar function is used for matchups of external catalogs.
--/T <br>It calls  <samp>fGetNearestObjEq(@ra,@dec,@r)</samp>, and selects 
--/T the objId (a bigint). 
--/T <br>This can be called by a single SELECT from an uploaded (ra,dec) table.
--/T <br>An example: 
--/T <br><samp>
--/T <br>  SELECT id, ra,dec, dbo.fGetNearestObjIdEq(ra,dec,3.0) as objId
--/T <br>      FROM #upload
--/T <br>      WHERE dbo.fGetNearestObjIdEq(ra,dec,3.0) IS NOT NULL
--/T</samp><p>
-------------------------------------------------
RETURNS bigint
AS BEGIN
    DECLARE @nx float, @ny float, @nz float;
    SET @nx = cos(radians(@dec))*cos(radians(@ra));
    SET @ny = cos(radians(@dec))*sin(radians(@ra));
    SET @nz = sin(radians(@dec));
    RETURN (
	select top 1 objID 
	from dbo.fGetNearbyObjAllXYZ(@nx,@ny,@nz,@r)
	where mode = @mode
	order by distance asc) 
END
GO



--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearbyObjXYZ')
	DROP FUNCTION fGetNearbyObjXYZ
GO
--
CREATE FUNCTION fGetNearbyObjXYZ(@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns table of primary objects within @r arcmins of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> objID bigint,               -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find PhotoObjects within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyObjXYZ(-.996,-.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyObjEq, fGetNearestObjXYZ, fGetNearestObjXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    objID bigint,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);

	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	
	IF (@r<0) RETURN
	INSERT @proxtab	SELECT 
	    objID, 
	    run,
	    camcol,
	    field,
	    rerun,
	    type,
	    cx,
	    cy,
	    cz,
	    htmID,
 	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 
	    
	    FROM @htmTemp H  inner loop join PhotoPrimary P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
	
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbyObjAllXYZ' ) 
	DROP FUNCTION fGetNearbyObjAllXYZ
GO
--
CREATE FUNCTION fGetNearbyObjAllXYZ (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns table of photo objects within @r arcmins of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> objID bigint,               -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> mode tinyint NOT NULL,      -- mode of photoObj
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find PhotoObjects within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyObjXYZ(-.996,-.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyObjEq, fGetNearestObjXYZ, fGetNearestObjXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    objID bigint,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    mode int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);

	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	INSERT @proxtab	SELECT 
	    objID, 
	    run,
	    camcol,
	    field,
	    rerun,
	    type,
	    mode,
	    cx,
	    cy,
	    cz,
	    htmID,
 	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 
	    --sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/@d2r*60 
	    FROM @htmTemp H inner loop join PhotoObjAll P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	    AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)< @lim
	    ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
  RETURN
  END
GO



--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestObjXYZ')
	DROP FUNCTION fGetNearestObjXYZ
GO
--
CREATE FUNCTION fGetNearestObjXYZ (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns nearest primary object within @r arcminutes of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T <p> returned table:  
--/T <li> objID bigint,               -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br>
--/T Sample call to find the nearest PhotoObject within 1/2 arcminute  of xyz -.0996,-.1,0 
--/T <br><samp>
--/T  <br> select *
--/T  <br> from  dbo.fGetNearestObjXYZ(-.996,-.1,0,0.5)  
--/T  </samp>  
--/T  <br>see also fGetNearbyObjEq, fGetNearestObjEq, fGetNearbyObjXYZ, 
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    objID bigint,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	INSERT @proxtab	
	SELECT top 1 * 
	FROM dbo.fGetNearbyObjXYZ(@nx,@ny,@nz,@r)
	ORDER BY distance ASC
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestSpecObjIdEq')
	DROP FUNCTION fGetNearestSpecObjIdEq
GO
--
CREATE FUNCTION fGetNearestSpecObjIdEq(@ra float, @dec float, @r float)
-------------------------------------------------
--/H Returns the specObjId of nearest sciencePrimary spectrum within @r arcmins of ra, dec
--/T <br> ra, dec are in degrees, r is in arc minutes.
-------------------------------------------------
--/T <br>This scalar function is used for matchups of external catalogs.
--/T <br>It calls  <samp>fGetNearestSpecObjEq(@ra,@dec,@r)</samp>, and selects 
--/T the specObjId (a bigint). 
--/T <br>This can be called by a single SELECT from an uploaded (ra,dec) table.
--/T <br>An example: 
--/T <br><samp>
--/T <br>  SELECT id, ra,dec, dbo.fGetNearestSpecObjIdEq(ra,dec,3.0) as specObjId
--/T <br>      FROM #upload
--/T <br>      WHERE dbo.fGetNearestSpecObjIdEq(ra,dec,3.0) IS NOT NULL
--/T</samp><p>
-------------------------------------------------
RETURNS numeric(20)
AS BEGIN
    RETURN (select specObjID from dbo.fGetNearestSpecObjEq(@ra,@dec,@r)) 
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestSpecObjIdAllEq' )
	DROP FUNCTION fGetNearestSpecObjIdAllEq
GO
--
CREATE FUNCTION fGetNearestSpecObjIdAllEq(@ra float, @dec float, @r float)
-------------------------------------------------
--/H Returns the specObjID of nearest photo object within @r arcmins of ra, dec
--/T <br> ra, dec are in degrees, r is in arc minutes.
-------------------------------------------------
--/T <br>This scalar function is used for matchups of external catalogs.
--/T <br>It calls  <samp>fGetNearestSpecObjAllEq(@ra,@dec,@r)</samp>, and selects 
--/T the specObjID (a bigint). 
--/T <br>This can be called by a single SELECT from an uploaded (ra,dec) table.
--/T <br>An example: 
--/T <br><samp>
--/T <br>  SELECT id, ra,dec, dbo.fGetNearestSpecObjIdAllEq(ra,dec,3.0) as specObjID
--/T <br>      FROM #upload
--/T <br>      WHERE dbo.fGetNearestSpecObjIdAllEq(ra,dec,3.0) IS NOT NULL
--/T</samp><p>
-------------------------------------------------
RETURNS numeric(20)
AS BEGIN
    RETURN (select specObjID from dbo.fGetNearestSpecObjAllEq(@ra,@dec,@r)) 
END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbySpecObjXYZ' ) 
	DROP FUNCTION fGetNearbySpecObjXYZ
GO
--
CREATE FUNCTION fGetNearbySpecObjXYZ (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns table of scienceprimary spectrum objects within @r arcmins of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> specObjID numeric(20),               -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> mode tinyint NOT NULL,      -- mode of photoObj
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find SpecObj within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbySpecObjXYZ(-.996,-.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearbySpecObjAllXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    specObjID numeric(20),
    plate int NOT NULL,
    mjd int NOT NULL,
    fiberID int NOT NULL,
    z real NOT NULL,
    zErr real NOT NULL,
    zWarning int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	INSERT @proxtab	SELECT 
	    specObjID, 
	    plate,
	    mjd,
	    fiberID,
	    z,
	    zErr,
	    zWarning,
	    cx,
	    cy,
	    cz,
	    htmID,
 	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 
	    --sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/@d2r*60 
	    FROM @htmTemp H join SpecObj S
	             ON  (S.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	    AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)< @lim
	    ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbySpecObjAllXYZ' ) 
	DROP FUNCTION fGetNearbySpecObjAllXYZ
GO
--
CREATE FUNCTION fGetNearbySpecObjAllXYZ (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns table of all spectrum objects within @r arcmins of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> objID bigint,               -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> mode tinyint NOT NULL,      -- mode of photoObj
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find SpecObj within 0.5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbySpecObjAllXYZ(-.996,-.1,0,0.5)  
--/T </samp>  
--/T <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearestSpecObjXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    specObjID numeric(20),
    plate int NOT NULL,
    mjd int NOT NULL,
    fiberID int NOT NULL,
    z real NOT NULL,
    zErr real NOT NULL,
    zWarning int NOT NULL,
    sciencePrimary int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);

	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	INSERT @proxtab	SELECT 
	    specObjID, 
	    plate,
	    mjd,
	    fiberID,
	    z,
	    zErr,
	    zWarning,
	    sciencePrimary,
	    cx,
	    cy,
	    cz,
	    htmID,
 	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 
	    --sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/@d2r*60 
	    FROM @htmTemp H  join SpecObjAll S
	             ON  (S.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	    AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)< @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestSpecObjXYZ')
	DROP FUNCTION fGetNearestSpecObjXYZ
GO
--
CREATE FUNCTION fGetNearestSpecObjXYZ (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns nearest scienceprimary specobj within @r arcminutes of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T <p> returned table:  
--/T <li>  specObjID numeric(20),		-- unique spectrum ID
--/T <li>  plate int NOT NULL,		-- spectroscopic plate number
--/T <li>  mjd int NOT NULL,		-- MJD of observation
--/T <li>  fiberID int NOT NULL,	-- fiber number on plate
--/T <li>  z real NOT NULL,		-- final spectroscopic redshift
--/T <li>  zErr real NOT NULL,		-- redshift error
--/T <li>  zWarning int NOT NULL,	-- warning flags
--/T <li>  cx float NOT NULL,		-- x of normal unit vector in J2000
--/T <li>  cy float NOT NULL,		-- y of normal unit vector in J2000
--/T <li>  cz float NOT NULL,		-- z of normal unit vector in J2000
--/T <li>  htmID bigint,		-- 20-deep HTM ID
--/T <li>  distance float		-- distance in arc minutes
--/T <br>
--/T Sample call to find the nearest SpecObj within 1/2 arcminute  of xyz -.0996,-.1,0 
--/T <br><samp>
--/T  <br> select *
--/T  <br> from  dbo.fGetNearestSpecObjXYZ(-.996,-.1,0,0.5)  
--/T  </samp>  
--/T  <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjEq, fGetNearbySpecObjXYZ, 
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    specObjID numeric(20),
    plate int NOT NULL,
    mjd int NOT NULL,
    fiberID int NOT NULL,
    z real NOT NULL,
    zErr real NOT NULL,
    zWarning int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	INSERT @proxtab	
	SELECT top 1 * 
	FROM dbo.fGetNearbySpecObjXYZ(@nx,@ny,@nz,@r)
	ORDER BY distance ASC
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestSpecObjAllXYZ')
	DROP FUNCTION fGetNearestSpecObjAllXYZ
GO
--
CREATE FUNCTION fGetNearestSpecObjAllXYZ (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns nearest specobj within @r arcminutes of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T <p> returned table:  
--/T <li>  specObjID numeric(20),		-- unique spectrum ID
--/T <li>  plate int NOT NULL,		-- spectroscopic plate number
--/T <li>  mjd int NOT NULL,		-- MJD of observation
--/T <li>  fiberID int NOT NULL,	-- fiber number on plate
--/T <li>  z real NOT NULL,		-- final spectroscopic redshift
--/T <li>  zErr real NOT NULL,		-- redshift error
--/T <li>  zWarning int NOT NULL,	-- warning flags
--/T <li>  sciencePrimary int NOT NULL,	-- deemed to be science-worthy or not
--/T <li>  cx float NOT NULL,		-- x of normal unit vector in J2000
--/T <li>  cy float NOT NULL,		-- y of normal unit vector in J2000
--/T <li>  cz float NOT NULL,		-- z of normal unit vector in J2000
--/T <li>  htmID bigint,		-- 20-deep HTM ID
--/T <li>  distance float		-- distance in arc minutes
--/T <br>
--/T Sample call to find the nearest SpecObj within 1/2 arcminute  of xyz -.0996,-.1,0 
--/T <br><samp>
--/T  <br> select *
--/T  <br> from  dbo.fGetNearestSpecObjAllXYZ(-.996,-.1,0,0.5)  
--/T  </samp>  
--/T  <br>see also fGetNearbySpecObjAllEq, fGetNearestSpecObjAllEq, fGetNearbySpecObjAllXYZ, 
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    specObjID numeric(20),
    plate int NOT NULL,
    mjd int NOT NULL,
    fiberID int NOT NULL,
    z real NOT NULL,
    zErr real NOT NULL,
    zWarning int NOT NULL,
    sciencePrimary int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	INSERT @proxtab	
	SELECT top 1 * 
	FROM dbo.fGetNearbySpecObjAllXYZ(@nx,@ny,@nz,@r)
	ORDER BY distance ASC
  RETURN
  END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbySpecObjEq' ) 
	DROP FUNCTION fGetNearbySpecObjEq
GO
--
CREATE FUNCTION fGetNearbySpecObjEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of spectrum objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li>  specObjID numeric(20),		-- unique spectrum ID
--/T <li>  plate int NOT NULL,		-- spectroscopic plate number
--/T <li>  mjd int NOT NULL,		-- MJD of observation
--/T <li>  fiberID int NOT NULL,	-- fiber number on plate
--/T <li>  z real NOT NULL,		-- final spectroscopic redshift
--/T <li>  zErr real NOT NULL,		-- redshift error
--/T <li>  zWarning int NOT NULL,	-- warning flags
--/T <li>  cx float NOT NULL,		-- x of normal unit vector in J2000
--/T <li>  cy float NOT NULL,		-- y of normal unit vector in J2000
--/T <li>  cz float NOT NULL,		-- z of normal unit vector in J2000
--/T <li>  htmID bigint,		-- 20-deep HTM ID
--/T <li>  distance float		-- distance in arc minutes
--/T <br> Sample call to find SpecObj within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbySpecObjXYZ(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearestSpecObjXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    specObjID numeric(20),
    plate int NOT NULL,
    mjd int NOT NULL,
    fiberID int NOT NULL,
    z real NOT NULL,
    zErr real NOT NULL,
    zWarning int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbySpecObjXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbySpecObjAllEq' ) 
	DROP FUNCTION fGetNearbySpecObjAllEq
GO
--
CREATE FUNCTION fGetNearbySpecObjAllEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of spectrum objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li>  specObjID numeric(20),		-- unique spectrum ID
--/T <li>  plate int NOT NULL,		-- spectroscopic plate number
--/T <li>  mjd int NOT NULL,		-- MJD of observation
--/T <li>  fiberID int NOT NULL,	-- fiber number on plate
--/T <li>  z real NOT NULL,		-- final spectroscopic redshift
--/T <li>  zErr real NOT NULL,		-- redshift error
--/T <li>  zWarning int NOT NULL,	-- warning flags
--/T <li>  sciencePrimary int NOT NULL,	-- deemed to be science-worthy or not
--/T <li>  cx float NOT NULL,		-- x of normal unit vector in J2000
--/T <li>  cy float NOT NULL,		-- y of normal unit vector in J2000
--/T <li>  cz float NOT NULL,		-- z of normal unit vector in J2000
--/T <li>  htmID bigint,		-- 20-deep HTM ID
--/T <li>  distance float		-- distance in arc minutes
--/T <br> Sample call to find SpecObj within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbySpecObjEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearestSpecObjXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    specObjID numeric(20),
    plate int NOT NULL,
    mjd int NOT NULL,
    fiberID int NOT NULL,
    z real NOT NULL,
    zErr real NOT NULL,
    zWarning int NOT NULL,
    sciencePrimary int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbySpecObjAllXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestSpecObjEq')
	DROP FUNCTION fGetNearestSpecObjEq
GO
--
CREATE FUNCTION fGetNearestSpecObjEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns nearest scienceprimary specobj within @r arcminutes of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T <p> returned table:  
--/T <li>  specObjID numeric(20),		-- unique spectrum ID
--/T <li>  plate int NOT NULL,		-- spectroscopic plate number
--/T <li>  mjd int NOT NULL,		-- MJD of observation
--/T <li>  fiberID int NOT NULL,	-- fiber number on plate
--/T <li>  z real NOT NULL,		-- final spectroscopic redshift
--/T <li>  zErr real NOT NULL,		-- redshift error
--/T <li>  zWarning int NOT NULL,	-- warning flags
--/T <li>  cx float NOT NULL,		-- x of normal unit vector in J2000
--/T <li>  cy float NOT NULL,		-- y of normal unit vector in J2000
--/T <li>  cz float NOT NULL,		-- z of normal unit vector in J2000
--/T <li>  htmID bigint,		-- 20-deep HTM ID
--/T <li>  distance float		-- distance in arc minutes
--/T <br>
--/T Sample call to find the nearest SpecObj within 1/2 arcminute  of ra,dec 180.0, -0.5, 0.5 
--/T <br><samp>
--/T  <br> select *
--/T  <br> from  dbo.fGetNearestSpecObjEq(180.0,-0.5,0.5)  
--/T  </samp>  
--/T  <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjAllEq, fGetNearbySpecObjXYZ, 
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    specObjID numeric(20),
    plate int NOT NULL,
    mjd int NOT NULL,
    fiberID int NOT NULL,
    z real NOT NULL,
    zErr real NOT NULL,
    zWarning int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	    SELECT top 1 * 
	    FROM dbo.fGetNearbySpecObjXYZ(@nx,@ny,@nz,@r) 
	    ORDER BY distance ASC
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestSpecObjAllEq')
	DROP FUNCTION fGetNearestSpecObjAllEq
GO
--
CREATE FUNCTION fGetNearestSpecObjAllEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns nearest specobj within @r arcminutes of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T <p> returned table:  
--/T <li>  specObjID numeric(20),		-- unique spectrum ID
--/T <li>  plate int NOT NULL,		-- spectroscopic plate number
--/T <li>  mjd int NOT NULL,		-- MJD of observation
--/T <li>  fiberID int NOT NULL,	-- fiber number on plate
--/T <li>  z real NOT NULL,		-- final spectroscopic redshift
--/T <li>  zErr real NOT NULL,		-- redshift error
--/T <li>  zWarning int NOT NULL,	-- warning flags
--/T <li>  sciencePrimary int NOT NULL,	-- deemed to be science-worthy or not
--/T <li>  cx float NOT NULL,		-- x of normal unit vector in J2000
--/T <li>  cy float NOT NULL,		-- y of normal unit vector in J2000
--/T <li>  cz float NOT NULL,		-- z of normal unit vector in J2000
--/T <li>  htmID bigint,		-- 20-deep HTM ID
--/T <li>  distance float		-- distance in arc minutes
--/T <br>
--/T Sample call to find the nearest SpecObj within 1/2 arcminute of ra,dec 180.0, -0.5
--/T <br><samp>
--/T  <br> select *
--/T  <br> from  dbo.fGetNearestSpecObjAllEq(180.0,-0.5,0.5)  
--/T  </samp>  
--/T  <br>see also fGetNearbySpecObjAllEq, fGetNearestSpecObjEq, fGetNearbySpecObjAllXYZ, 
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    specObjID numeric(20),
    plate int NOT NULL,
    mjd int NOT NULL,
    fiberID int NOT NULL,
    z real NOT NULL,
    zErr real NOT NULL,
    zWarning int NOT NULL,
    sciencePrimary int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	    SELECT top 1 * 
	    FROM dbo.fGetNearbySpecObjAllXYZ(@nx,@ny,@nz,@r) 
	    ORDER BY distance ASC
  RETURN
  END
GO



IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbyApogeeStarXYZ' ) 
	DROP FUNCTION fGetNearbyApogeeStarXYZ
GO
--======================================================================
--
CREATE FUNCTION [dbo].[fGetNearbyApogeeStarXYZ](@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns table of APOGEE spectrum objects within @r arcmins of an xyz point (@nx,@ny,@nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> apstar_id varchar(50) NOT NULL,      -- Combined star spectrum unique ID
--/T <li> star varchar(32) NOT NULL,           -- 2MASS-style star id
--/T <li> ra float NOT NULL,            -- Right Ascension
--/T <li> dec float NOT NULL,		-- declination
--/T <li> glon float NOT NULL,          -- Galactic longitude 
--/T <li> glat float NOT NULL,		-- Galactic latitude 
--/T <li> vhelio_avg real NOT NULL	-- S/N-weighted average of heliocentric radial velocity
--/T <li> vscatter real NOT NULL	-- stdev of scatter of visit RVs around average
--/T <li> distance float NOT NULL    -- distance in arcmin from specified equatorial point
--/T <li> htmID bigint NOT NULL		-- Hierarchical Trangular Mesh id of this star
--/T <br> Sample call to find APOGEE star within 5 arcminutes of xyz -0.904,-0.287,0.316
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyApogeeStarXYZ(-0.904,-0.287,0.316, 5)  
--/T </samp>  
--/T <br>see also fGetNearbyApogeeStarEq, fGetNearestApogeeStarEq, fGetNearestApogeeStarXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    apstar_id varchar(64) NOT NULL,
    apogee_id varchar(32) NOT NULL,
    ra float NOT NULL,
    dec float NOT NULL,
    glon float NOT NULL,
    glat float NOT NULL,
    vhelio_avg real NOT NULL,
    vscatter real NOT NULL,
	distance float NOT NULL,
	htmID bigint NOT NULL

  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	IF (@r<0) RETURN
	INSERT @proxtab	SELECT 
	    apstar_id, 
	    apogee_id,
	    ra,
	    dec,
	    glon,
	    glat,
	    vhelio_avg,
	    vscatter,
 	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 as distance,
		htmID
	    FROM @htmTemp H  inner loop join apogeeStar P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbyApogeeStarEq' ) 
	DROP FUNCTION fGetNearbyApogeeStarEq
GO
--

-------------------------------------------------------------
CREATE FUNCTION [dbo].[fGetNearbyApogeeStarEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of APOGEE spectrum objects within @r arcmins of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> apstar_id varchar(50) NOT NULL,      -- Combined star spectrum unique ID
--/T <li> star varchar(32) NOT NULL,           -- 2MASS-style star id
--/T <li> ra float NOT NULL,            -- Right Ascension
--/T <li> dec float NOT NULL,		-- declination
--/T <li> glon float NOT NULL,          -- Galactic longitude 
--/T <li> glat float NOT NULL,		-- Galactic latitude 
--/T <li> vhelio_avg real NOT NULL	-- S/N-weighted average of heliocentric radial velocity
--/T <li> vscatter real NOT NULL	-- stdev of scatter of visit RVs around average
--/T <li> distance float NOT NULL    -- distance in arcmin from specified equatorial point
--/T <li> htmID bigint NOT NULL		-- Hierarchical Trangular Mesh id of this star
--/T <br> Sample call to find APOGEE star within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyApogeeStarEq(180.0,-0.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyApogeeStarXYZ, fGetNearestApogeeStarEq, fGetNearestApogeeStarXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    apstar_id varchar(64) NOT NULL,
    apogee_id varchar(32) NOT NULL,
    ra float NOT NULL,
    dec float NOT NULL,
    glon float NOT NULL,
    glat float NOT NULL,
    vhelio_avg real NOT NULL,
    vscatter real NOT NULL,
	distance float NOT NULL,
    htmID bigint NOT NULL
  ) AS 
BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbyApogeeStarXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearestApogeeStarXYZ' ) 
	DROP FUNCTION fGetNearestApogeeStarXYZ
GO
--
CREATE FUNCTION fGetNearestApogeeStarXYZ (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns nearest APOGEE star spectrum within @r arcmins of an xyz point (@nx,@ny,@nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> apstar_id varchar(64) NOT NULL,      -- Combined star spectrum unique ID
--/T <li> star varchar(32) NOT NULL,           -- 2MASS-style star id
--/T <li> ra float NOT NULL,            -- Right Ascension
--/T <li> dec float NOT NULL,		-- declination
--/T <li> glon float NOT NULL,          -- Galactic longitude 
--/T <li> glat float NOT NULL,		-- Galactic latitude 
--/T <li> vhelio_avg real NOT NULL	-- S/N-weighted average of heliocentric radial velocity
--/T <li> vscatter real NOT NULL	-- stdev of scatter of visit RVs around average
--/T <li> distance float NOT NULL    -- distance in arcmin from specified equatorial point
--/T <li> htmID bigint NOT NULL		-- Hierarchical Trangular Mesh id of this star
--/T <br> Sample call to find APOGEE star within 5 arcminutes of xyz -0.904,-0.287,0.316
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearestApogeeStarXYZ(-0.904,-0.287,0.316, 5)  
--/T </samp>  
--/T <br>see also fGetNearbyApogeeStarEq, fGetNearbyApogeeStarXYZ, fGetNearestApogeeStarEq
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    apstar_id varchar(64) NOT NULL,
    apogee_id varchar(32) NOT NULL,
    ra float NOT NULL,
    dec float NOT NULL,
    glon float NOT NULL,
    glat float NOT NULL,
    vhelio_avg real NOT NULL,
    vscatter real NOT NULL,
	distance float NOT NULL,
    htmID bigint NOT NULL
  ) AS 
BEGIN
	INSERT @proxtab	
	    SELECT TOP 1 *
	    FROM dbo.fGetNearbyApogeeStarXYZ(@nx, @ny, @nz, @r)
	    ORDER BY distance ASC
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearestApogeeStarEq' ) 
	DROP FUNCTION fGetNearestApogeeStarEq
GO
--
CREATE FUNCTION fGetNearestApogeeStarEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns nearest APOGEE star spectrum within @r arcmins of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> apstar_id varchar(64) NOT NULL,      -- Combined star spectrum unique ID
--/T <li> star varchar(32) NOT NULL,           -- 2MASS-style star id
--/T <li> ra float NOT NULL,            -- Right Ascension
--/T <li> dec float NOT NULL,		-- declination
--/T <li> glon float NOT NULL,          -- Galactic longitude 
--/T <li> glat float NOT NULL,		-- Galactic latitude 
--/T <li> vhelio_avg real NOT NULL	-- S/N-weighted average of heliocentric radial velocity
--/T <li> vscatter real NOT NULL	-- stdev of scatter of visit RVs around average
--/T <li> distance float NOT NULL    -- distance in arcmin from specified equatorial point
--/T <li> htmID bigint NOT NULL		-- Hierarchical Trangular Mesh id of this star
--/T <br> Sample call to find APOGEE star within 5 arcminutes of equatorial point 180.0, -0.1
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearestApogeeStarEq(180.0,-0.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyApogeeStarEq, fGetNearbyApogeeStarXYZ, fGetNearestApogeeStarXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    apstar_id varchar(64) NOT NULL,
    apogee_id varchar(32) NOT NULL,
    ra float NOT NULL,
    dec float NOT NULL,
    glon float NOT NULL,
    glat float NOT NULL,
    vhelio_avg real NOT NULL,
    vscatter real NOT NULL,
	distance float NOT NULL,
    htmID bigint NOT NULL
  ) AS 
BEGIN
	INSERT @proxtab	
	    SELECT TOP 1 *
	    FROM dbo.fGetNearbyApogeeStarEq(@ra, @dec, @r)
	    ORDER BY distance ASC
  RETURN
  END
GO




--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbyMangaObjEq' ) 
	DROP FUNCTION fGetNearbyMangaObjEq
GO
--
CREATE FUNCTION fGetNearbyMangaObjEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of MaNGA objects within @r arcmins of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> plateIFU varchar(20) NOT NULL,   -- MaNGA unique ID
--/T <li> mangaid varchar(20) NOT NULL,    -- MaNGA target id
--/T <li> objra float NOT NULL,            -- Right Ascension
--/T <li> objdec float NOT NULL,	   -- declination
--/T <li> ifura float NOT NULL,            -- Right Ascension
--/T <li> ifudec float NOT NULL,	   -- declination
--/T <li> drp3qual bigint NOT NULL,	   -- Quality bitmask
--/T <li> bluesn2 real NOT NULL, 	   -- Total blue SN2 across all nexp exposures
--/T <li> redsn2 real NOT NULL,	   -- Total red SN2 across all nexp exposures
--/T <li> mjdmax int NOT NULL,	   	   --/D Maximum MJD across all exposures
--/T <li> mngtarg1 bigint NOT NULL,	   --/D Manga-target1 maskbit for galaxy target catalog
--/T <li> mngtarg2 bigint NOT NULL,	   --/D Manga-target2 maskbit for galaxy target catalog
--/T <li> mngtarg3 bigint NOT NULL,	   --/D Manga-target3 maskbit for galaxy target catalog
--/T <li> htmID bigint NOT NULL		   -- Hierarchical Trangular Mesh id of this objetc
--/T <br> Sample call to find MaNGA object within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyMangaObjEq(180.0,-0.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearestMangaObjEq
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    plateIFU varchar(20) NOT NULL,
    mangaid varchar(20) NOT NULL,
    objra float NOT NULL,
    objdec float NOT NULL,
    ifura float NOT NULL,
    ifudec float NOT NULL,
    drp3qual bigint NOT NULL,
    bluesn2 real NOT NULL,
    redsn2 real NOT NULL,
    mjdmax int NOT NULL,
    mngtarg1 bigint NOT NULL,
    mngtarg2 bigint NOT NULL,
    mngtarg3 bigint NOT NULL,
    htmID bigint NOT NULL
  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleEq(@ra,@dec,@r)
	DECLARE @lim float;
	INSERT @proxtab	SELECT 
	    plateIFU, 
	    mangaid,
	    objra,
	    objdec,
	    ifura,
	    ifudec,
	    drp3qual,
	    bluesn2,
	    redsn2,
	    mjdmax,
	    mngtarg1,
	    mngtarg2,
	    mngtarg3,
	    htmID
	    FROM @htmTemp H join mangaDrpAll M
	             ON  (M.htmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	    AND dbo.fDistanceArcMinEq(@ra,@dec,ifura,ifudec) < @r
  RETURN
  END
GO




--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearestMangaObjEq' ) 
	DROP FUNCTION fGetNearestMangaObjEq
GO
--
CREATE FUNCTION fGetNearestMangaObjEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns nearest MaNGA object within @r arcmins of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> plateIFU varchar(20) NOT NULL,      -- MaNGA unique ID
--/T <li> mangaid varchar(20) NOT NULL,       -- MaNGA target id
--/T <li> objra float NOT NULL,     -- Right Ascension
--/T <li> objdec float NOT NULL,    -- declination
--/T <li> ifura float NOT NULL,     -- Right Ascension
--/T <li> ifudec float NOT NULL,    -- declination
--/T <li> drp3qual bigint NOT NULL, -- Quality bitmask
--/T <li> bluesn2 real NOT NULL,   -- Total blue SN2 across all nexp exposures
--/T <li> redsn2 real NOT NULL,    -- Total red SN2 across all nexp exposures
--/T <li> mjdmax int NOT NULL,   --/D Maximum MJD across all exposures
--/T <li> mngtarg1 bigint NOT NULL, --/D Manga-target1 maskbit for galaxy target catalog
--/T <li> mngtarg2 bigint NOT NULL, --/D Manga-target2 maskbit for galaxy target catalog
--/T <li> mngtarg3 bigint NOT NULL, --/D Manga-target3 maskbit for galaxy target catalog
--/T <li> htmID bigint NOT NULL	    -- Hierarchical Trangular Mesh id of this object
--/T <br> Sample call to find MaNGA object within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearestMangaObjEq(180.0,-0.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyMangaObjEq
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    plateIFU varchar(20) NOT NULL,
    mangaid varchar(20) NOT NULL,
    objra float NOT NULL,
    objdec float NOT NULL,
    ifura float NOT NULL,
    ifudec float NOT NULL,
    drp3qual bigint NOT NULL,
    bluesn2 real NOT NULL,
    redsn2 real NOT NULL,
    mjdmax int NOT NULL,
    mngtarg1 bigint NOT NULL,
    mngtarg2 bigint NOT NULL,
    mngtarg3 bigint NOT NULL,
    htmID bigint NOT NULL
  ) AS 
BEGIN
	INSERT @proxtab	
	    SELECT TOP 1 *
	    FROM dbo.fGetNearbyMangaObjEq(@ra, @dec, @r) n
	    ORDER BY dbo.fDistanceArcMinEq(@ra, @dec, ifura, ifudec) ASC, n.bluesn2 DESC
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbyMastarObjEq' ) 
	DROP FUNCTION fGetNearbyMastarObjEq
GO
--
CREATE FUNCTION [dbo].[fGetNearbyMaStarObjEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of MaStar objects within @r arcmins of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> mangaid varchar(20) NOT NULL,    -- MaNGA target id
--/T <li> objra float NOT NULL,            -- Right Ascension
--/T <li> objdec float NOT NULL,	   -- declination
--/T <li> htmID bigint NOT NULL		   -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float NOT NULL		-- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find MaStar object within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select * from [dbo].[fGetNearbyMaStarObjEq](38.7, 47.4, 1)  
--/T </samp>  
--/T <br>see also fGetNearestMastarObjEq
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    mangaid varchar(20) NOT NULL,
    objra float NOT NULL,
    objdec float NOT NULL,
    htmID bigint NOT NULL,
	distance float not null
  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleEq(@ra,@dec,@r)
	DECLARE @lim float;
	INSERT @proxtab	SELECT 
	    mangaid,
	    ra,
	    [dec],
	    dbo.fHtmEq(ra, [dec]),
		dbo.fDistanceEq(@ra,@dec, ra, [dec])
	    FROM @htmTemp H join mastar_goodstars M
	             ON  (dbo.fHtmEq(ra, [dec]) BETWEEN H.HtmIDstart AND H.HtmIDend )
	    AND dbo.fDistanceEq(@ra,@dec,ra, [dec]) < @r
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearestMastarObjEq' ) 
	DROP FUNCTION fGetNearestMastarObjEq
GO
--
CREATE FUNCTION [dbo].[fGetNearestMastarObjEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of MaNGA objects within @r arcmins of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> mangaid varchar(20) NOT NULL,    -- MaNGA target id
--/T <li> objra float NOT NULL,            -- Right Ascension
--/T <li> objdec float NOT NULL,	   -- declination
--/T <li> htmID bigint NOT NULL		   -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float NOT NULL		-- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find MaNGA object within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select * from dbo.[fGetNearestMastarEq](38.7, 47.4, 1) 
--/T </samp>  
--/T <br>see also fGetNearbystarObjEq
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    mangaid varchar(20) NOT NULL,
    objra float NOT NULL,
    objdec float NOT NULL,
    htmID bigint NOT NULL, 
	distance float not null
  ) AS 
BEGIN
	INSERT @proxtab
		SELECT TOP 1 *
		FROM dbo.fGetNearbyMaStarObjEq(@ra, @dec, @r) n
		order by dbo.fDistanceEq(@ra, @dec, n.objra, n.objdec) ASC
	RETURN
  END
GO



--=======================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearbyMosTargetXYZ' )
	DROP FUNCTION fGetNearbyMosTargetXYZ
GO


 CREATE FUNCTION [dbo].[fGetNearbyMosTargetXYZ] (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns table of mos_target objects within @r arcmins of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> target_pk biginit NOT NULL, -- primary object identifier
--/T <li> catalogid bigint NULL,      -- id in mos_catalog   
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination
--/T <li> epoch real NULL,            -- 
--/T <li> parallax NULL,              -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target objects within 5 arcminutes of xyz -0.904,-0.287,0.316
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyMosTargetXYZ(-0.904,-0.287,0.316,5)  
--/T </samp>  
--/T <br>see also fGetNearbyMosTargetEq, fGetNearestMosTargetEq, fGetNearestMosTargetXyz
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    target_pk bigint NOT NULL,
    catalogid bigint NULL,
    ra float NULL,
    [dec] float NULL,
    epoch real NULL,
    parallax real NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	INSERT @proxtab	SELECT 
	    target_pk, 
	    catalogid,
	    ra,
	    [dec],
	    epoch,
		parallax,
	    htmID,
	    2*DEGREES(ASIN(sqrt(power(@nx-( COS([dec]) * COS(ra) ),2)+power(@ny-( COS([dec]) * SIN(ra) ),2)+power(@nz-( SIN([dec]) ),2))/2))*60 
	    FROM @htmTemp H  inner loop join mos_target P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO



--=======================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearbyMosTargetEq' )
	DROP FUNCTION fGetNearbyMosTargetEq
GO
--
CREATE FUNCTION [dbo].[fGetNearbyMosTargetEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of mos_target objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> target_pk biginit NOT NULL, -- primary object identifier
--/T <li> catalogid bigint NULL,      -- id in mos_catalog   
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination
--/T <li> epoch real NULL,            -- 
--/T <li> parallax NULL,              -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyMosTargetEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyMosTargetXyz, fGetNearestMosTargetEq, fGetNearestMosTargetXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    target_pk bigint NOT NULL,
	catalogid bigint NULL,
    ra float NULL,
	[dec] float NULL,
    epoch real NULL,
    parallax real NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbyMosTargetXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO



--=======================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestMosTargetXyz' )
	DROP FUNCTION fGetNearestMosTargetXyz
GO
--
CREATE FUNCTION [dbo].[fGetNearestMosTargetXYZ] (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns inormation for  the nearest mos_target object
--H/ within @r arcmins of an xyz point (@nx,@ny,@nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> target_pk biginit NOT NULL, -- primary object identifier
--/T <li> catalogid bigint NULL,      -- id in mos_catalog   
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination
--/T <li> epoch real NULL,            -- 
--/T <li> parallax NULL,              -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find the nearest mos_target object within 5 arcminutes of xyz -0.904,-0.287,0.316
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearestMosTargetXYZ(-0.904,-0.287,0.316, 5)  
--/T </samp>  
--/T <br>see also fGetNearbyMosTargetEq, fGetNearbyMosTargetXYZ, fGetNearestMosTargetEq
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    target_pk bigint NOT NULL,
	catalogid bigint NULL,
    ra float NULL,
	[dec] float NULL,
    epoch real NULL,
    parallax real NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	INSERT @proxtab	
	    SELECT TOP 1 *
	    FROM dbo.fGetNearbyMosTargetXyz(@nx, @ny, @nz, @r)
	    ORDER BY distance ASC
  RETURN
  END
GO



--=======================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestMosTargetEq' )
	DROP FUNCTION fGetNearestMosTargetEq
GO
--
CREATE FUNCTION [dbo].[fGetNearestMosTargetEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns inormation for  the nearest mos_target object
--H/ within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> target_pk biginit NOT NULL, -- primary object identifier
--/T <li> catalogid bigint NULL,      -- id in mos_catalog   
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination
--/T <li> epoch real NULL,            -- 
--/T <li> parallax NULL,              -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find the nearest mos_target object within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearestMosTargetEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyMosTargetEq, fGetNearbyMosTargetXYZ, fGetNearestMosTargetXYZ
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    target_pk bigint NOT NULL,
	catalogid bigint NULL,
    ra float NULL,
	[dec] float NULL,
    epoch real NULL,
    parallax real NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	INSERT @proxtab	
	    SELECT TOP 1 *
	    FROM dbo.fGetNearbyMosTargetEq(@ra, @dec, @r)
	    ORDER BY distance ASC
  RETURN
  END
GO



------------------------------------------------
-- some new UDFs for image navigation
-------------------------------------------------

--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearbyFrameEq' )
	DROP FUNCTION fGetNearbyFrameEq
GO
--
CREATE FUNCTION fGetNearbyFrameEq (@ra float, @dec float, 
					@radius float, @zoom int)
-------------------------------------------------
--/H Returns table with a record describing the frames neareby (@ra,@dec) at a given @zoom level.
--/T <br> ra, dec are in degrees. Zoom is a value in Frame.Zoom (0, 10, 15, 20, 30).
--/T <br> this rountine is used by the SkyServer Web Server.
-------------------------------------------------------------
--/T <p> returned table is sorted nearest first:  
--/T <li> fieldID bigint,                 -- field identifier
--/T <li> a              float NOT NULL , -- abcdef,node, incl astrom transform parameters
--/T <li> b              float NOT NULL ,
--/T <li> c              float NOT NULL ,
--/T <li> d              float NOT NULL ,
--/T <li> e              float NOT NULL ,
--/T <li> f              float NOT NULL ,
--/T <li> node           float NOT NULL ,
--/T <li> incl           float NOT NULL ,
--/T <li> distance	 float NOT NULL   distance in arc minutes to this object from the ra,dec.
--/T <br>
--/T Sample call to find frame nearest to 185,0 and within one arcminute of it.
--/T <br><samp>
--/T <br>select *
--/T <br>from  dbo.fGetNearbyFrameEq(185,0,1)  
--/T  </samp>  
--/T  <br>see also fGetNearestFrameEq
-------------------------------------------------
  RETURNS @proxtab TABLE (
	fieldID 	bigint NOT NULL,
	a 		    float NOT NULL ,
	b 		    float NOT NULL ,
	c 		    float NOT NULL ,
	d 		    float NOT NULL ,
	e 		    float NOT NULL ,
	f 		    float NOT NULL ,
	node 		float NOT NULL ,
	incl 		float NOT NULL ,
    distance    float NOT NULL		-- distance in arc minutes 
  ) 
AS BEGIN
	--
	DECLARE @nx float,@ny float,@nz float 
	SET @nx  = COS(RADIANS(@dec))*COS(RADIANS(@ra))
	SET @ny  = COS(RADIANS(@dec))*SIN(RADIANS(@ra))
	SET @nz  = SIN(RADIANS(@dec))
	-------------------
	-- get htm ranges
	-------------------
	DECLARE @cover TABLE (
		htmidStart bigint, htmidEnd bigint
	)
	INSERT @cover
	SELECT htmidStart, htmidEnd
	FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@radius);
	--
	
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@radius/120)),2);
	
	--
	INSERT @proxtab	
	SELECT  fieldID,a,b,c,d,e,f,node,incl, 
	(2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60)
	FROM @cover H  join Frame F
	ON  (F.HtmID BETWEEN H.htmidStart AND H.htmidEnd )
	WHERE zoom = @zoom
	AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestFrameEq' )
	DROP FUNCTION fGetNearestFrameEq
GO
--
CREATE FUNCTION fGetNearestFrameEq (@ra float, @dec float, @zoom int)
-------------------------------------------------
--/H Returns table with a record describing the nearest frame to (@ra,@dec) at a given @zoom level.
--/T <br> ra, dec are in degrees. Zoom is a value in Frame.Zoom (0, 10, 15, 20, 30).
--/T <br> this rountine is used by the SkyServer Web Server.
-------------------------------------------------------------
--/T <p> returned table:  
--/T <li> fieldID bigint,                 -- field identifier
--/T <li> a              float NOT NULL , -- abcdef,node, incl astrom transform parameters
--/T <li> b              float NOT NULL ,
--/T <li> c              float NOT NULL ,
--/T <li> d              float NOT NULL ,
--/T <li> e              float NOT NULL ,
--/T <li> f              float NOT NULL ,
--/T <li> node           float NOT NULL ,
--/T <li> incl           float NOT NULL ,
--/T <li> distance	 float NOT NULL   distance in arc minutes to this object from the ra,dec.
--/T <br>
--/T Sample call to find frame nearest to 185,0 and within one arcminute of it.
--/T <br><samp>
--/T <br>select *
--/T <br>from  dbo.fGetNearestFrameEq(185,0,10)  
--/T  </samp>  
-------------------------------------------------
  RETURNS @proxtab TABLE (
	fieldID 	bigint NOT NULL,
	a 		float NOT NULL ,
	b 		float NOT NULL ,
	c 		float NOT NULL ,
	d 		float NOT NULL ,
	e 		float NOT NULL ,
	f 		float NOT NULL ,
	node 		float NOT NULL ,
	incl 		float NOT NULL ,
        distance        float NOT NULL		-- distance in arc minutes 
  ) AS BEGIN
	INSERT @proxtab	
	    SELECT TOP 1 fieldID, a, b, c, d, e, f, node, incl, distance  -- look up to 81
	    FROM fGetNearbyFrameEq (@ra , @dec, 81, @zoom )	-- arcmin away from center.
            ORDER BY distance ASC   
  RETURN
  END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestFrameidEq' )
	DROP FUNCTION fGetNearestFrameidEq
GO
--
CREATE FUNCTION fGetNearestFrameidEq (@ra float, @dec float, @zoom int)
-------------------------------------------------
--/H Returns teh fieldid of the nearest frame to (@ra,@dec) at a given @zoom level.
--/T <br> ra, dec are in degrees. Zoom is a value in Frame.Zoom (0, 05, 10, 15, 20, 25, 30).
-------------------------------------------------------------
--/T <p> returns the fieldid of the nearest frame
--/T <br>
--/T Sample call to find frameid nearest to 185,0 and within one arcminute of it.
--/T <br><samp>
--/T <br>select *
--/T <br>from  dbo.fGetNearestFrameidEq(185,0,10)  
--/T  </samp>  
-------------------------------------------------
RETURNS bigint
AS BEGIN
  RETURN (select fieldID from dbo.fGetNearestFrameEq(@ra, @dec, @zoom) );
END
GO
--

--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spGetNeighbors' )
	DROP PROCEDURE spGetNeighbors
GO
--
CREATE PROCEDURE spGetNeighbors(@r float)
-------------------------------------------------------------------
--/H Get the neighbors to a list of @ra,@dec pairs in #upload
-------------------------------------------------------------------
--/T The procedure is used in conjunction with a list upload
--/T service, where the (ra,dec) coordinates of an object list 
--/T are put into a temporary table #upload by the web interface.
--/T This table name is hardcoded in the procedure. It then returns
--/T a matchup table, containing the up_id and the SDSS objId.
--/T The result of this is then joined with the PhotoTag table, 
--/T to return the attributes of the photometric objects.
--/T <samp>
--/T <br> create table #x (id int,objID bigint)
--/T <br> insert into #x EXEC spGetNeighbors 2.5
--/T </samp>
-------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	select up_ID, objID
	from #upload cross apply dbo.fGetNearbyObjAllEq(up_ra,up_dec,@r)
END
GO


--===================================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spGetNeighborsRadius' ) 
	DROP PROCEDURE spGetNeighborsRadius
GO
--

CREATE  PROCEDURE spGetNeighborsRadius
-------------------------------------------------------------------
--/H Get the neighbors to a list of @ra,@dec,@r triplets in #upload in photoPrimary
-------------------------------------------------------------------
--/T The procedure is used in conjunction with a list upload
--/T service, where the (ra,dec) coordinates and the search radius
--/T of an object list are put into a temporary table #upload by 
--/T the web interface.  This table name is hardcoded in the procedure. 
--/T It then returns a matchup table, containing the up_id and the SDSS 
--/T objId. The result of this is then joined with the photoPrimary 
--/T table, to return the attributes of the photometric objects.
--/T <samp>
--/T <br> create table #x (id int,objID bigint)
--/T <br> insert into #x EXEC spGetNeighbours 
--/T </samp>
-------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	SELECT up_ID, objID
	FROM  #upload cross apply dbo.fGetNearbyObjAllEq(up_ra,up_dec,up_rad)
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spGetNeighborsPrim' )
	DROP PROCEDURE spGetNeighborsPrim
GO
--
CREATE PROCEDURE spGetNeighborsPrim(@r float)
-------------------------------------------------------------------
--/H Get the primary neighbors to a list of @ra,@dec pairs in #upload
-------------------------------------------------------------------
--/T The procedure is used in conjunction with a list upload
--/T service, where the (ra,dec) coordinates of an object list 
--/T are put into a temporary table #upload by the web interface.
--/T This table name is hardcoded in the procedure. It then returns
--/T a matchup table, containing the up_id and the SDSS objId.
--/T The result of this is then joined with the PhotoPrimary table, 
--/T to return the attributes of the photometric objects.
--/T <samp>
--/T <br> create table #x (id int,objID bigint)
--/T <br> insert into #x EXEC spGetNeighborsPrim 2.5
--/T </samp>
-------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	SELECT up_ID, objID
	FROM  #upload cross apply dbo.fGetNearbyObjEq(up_ra,up_dec,@r)
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spGetNeighborsAll' )
	DROP PROCEDURE spGetNeighborsAll
GO
--
CREATE PROCEDURE spGetNeighborsAll(@r float)
-------------------------------------------------------------------
--/H Get the neighbors to a list of @ra,@dec pairs in #upload
-------------------------------------------------------------------
--/T The procedure is used in conjunction with a list upload
--/T service, where the (ra,dec) coordinates of an object list 
--/T are put into a temporary table #upload by the web interface.
--/T This table name is hardcoded in the procedure. It then returns
--/T a matchup table, containing the up_id and the SDSS objId.
--/T The result of this is then joined with the PhotoTag table, 
--/T to return the attributes of the photometric objects.
--/T <samp>
--/T <br> create table #x (id int,objID bigint)
--/T <br> insert into #x EXEC spGetNeighborsAll 2.5
--/T </samp>
-------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	SELECT up_ID, objID
	FROM  #upload cross apply dbo.fGetNearbyObjAllEq(up_ra,up_dec,@r)
END
GO


--===================================================================
IF EXISTS (SELECT [name] FROM sysobjects 
	WHERE  [name] = N'spGetSpecNeighborsRadius' ) 
	DROP PROCEDURE spGetSpecNeighborsRadius
GO
--

CREATE  PROCEDURE spGetSpecNeighborsRadius
-------------------------------------------------------------------
--/H Get the spectro scienceprimary neighbors to a list of @ra,@dec,@r triplets in #upload in SpecObj
-------------------------------------------------------------------
--/T The procedure is used in conjunction with a list upload
--/T service, where the (ra,dec) coordinates and the search radius
--/T of an object list are put into a temporary table #upload by 
--/T the web interface.  This table name is hardcoded in the procedure. 
--/T It then returns a matchup table, containing the up_id and the SDSS 
--/T specObjId. The result of this is then joined with the SpecObj 
--/T table, to return the attributes of the photometric objects.
--/T <samp>
--/T <br> create table #x (id int,specObjID numeric(20))
--/T <br> insert into #x EXEC spGetNeighbours 
--/T </samp>
-------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	SELECT up_ID, specObjID
	FROM  #upload cross apply dbo.fGetNearbySpecObjAllEq(up_ra,up_dec,up_rad)
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spGetSpecNeighborsPrim' )
	DROP PROCEDURE spGetSpecNeighborsPrim
GO
--
CREATE PROCEDURE spGetSpecNeighborsPrim(@r float)
-------------------------------------------------------------------
--/H Get the scienceprimary spectro neighbors to a list of @ra,@dec pairs in #upload
-------------------------------------------------------------------
--/T The procedure is used in conjunction with a list upload
--/T service, where the (ra,dec) coordinates of an object list 
--/T are put into a temporary table #upload by the web interface.
--/T This table name is hardcoded in the procedure. It then returns
--/T a matchup table, containing the up_id and the SDSS specOobjId.
--/T The result of this is then joined with the SpecObj table, 
--/T to return the attributes of the photometric objects.
--/T <samp>
--/T <br> create table #x (id int,specObjID numeric(20))
--/T <br> insert into #x EXEC spGetSpecNeighborsPrim 2.5
--/T </samp>
-------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	SELECT up_ID, specObjID
	FROM  #upload cross apply dbo.fGetNearbySpecObjEq(up_ra,up_dec,@r)
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spGetSpecNeighborsAll' )
	DROP PROCEDURE spGetSpecNeighborsAll
GO
--
CREATE PROCEDURE spGetSpecNeighborsAll(@r float)
-------------------------------------------------------------------
--/H Get the spectro neighbors to a list of @ra,@dec pairs in #upload
-------------------------------------------------------------------
--/T The procedure is used in conjunction with a list upload
--/T service, where the (ra,dec) coordinates of an object list 
--/T are put into a temporary table #upload by the web interface.
--/T This table name is hardcoded in the procedure. It then returns
--/T a matchup table, containing the up_id and the SDSS specObjId.
--/T The result of this is then joined with the SpecObjAll table, 
--/T to return the attributes of the photometric objects.
--/T <samp>
--/T <br> create table #x (id int,specObjID numeric(20))
--/T <br> insert into #x EXEC spGetSpecNeighborsAll 2.5
--/T </samp>
-------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON;
	SELECT up_ID, specObjID
	FROM  #upload cross apply dbo.fGetNearbySpecObjAllEq(up_ra,up_dec,@r)
END
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetObjFromRect' )
	DROP FUNCTION fGetObjFromRect
GO
--
CREATE FUNCTION fGetObjFromRect (@ra1 float, @ra2 float, 
				 @dec1 float, @dec2 float)
---------------------------------------------------------------------------
--/H Returns table of objects inside a rectangle defined by two ra,dec pairs.
--/H <br>Note the order of the parameters: @ra1, @ra2, @dec1, @dec2
--
--/T <br>Assumes dec1<dec2. There is no limit on the number of objects.
--/T <br>Uses level 20 HTM.
--/T <br> returned fields: 
--/T  <li> objID bigint,             -- id of the object
--/T  <li> run int NOT NULL,         -- run that observed the object
--/T  <li> camcol int NOT NULL,      -- camera column in run
--/T  <li> field int NOT NULL,       -- field in run
--/T  <li> rerun int NOT NULL,       -- software rerun that saw the object
--/T  <li> type int NOT NULL,        -- type of object (see DataConstants PhotoType)
--/T  <li> cx float NOT NULL,        -- xyz of object
--/T  <li> cy float NOT NULL,
--/T  <li> cz float NOT NULL,
--/T  <li> htmID bigint              -- hierarchical triangular mesh ID of object
--/T <br>sample call<br>
--/T <samp> select * from dbo.fGetObjFromRect(185,185.1,0,.1) </samp>
---------------------------------------------------------------------------
RETURNS @proxtab TABLE (
    objID bigint,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint
)
AS BEGIN
	declare @d2r float, @cmd varchar(1000), @radius float, 
	    @dot float, @d1 float, @d2 float,
	    @level int, @shift bigint, @ra float, @dec float,
	    @nx1 float, @ny1 float, @nz1 float,
	    @nx2 float, @ny2 float, @nz2 float,
	    @nx float, @ny float, @nz float
	-- calculate approximate center
	set @ra  = (@ra1+@ra2)/2;
	set @dec = (@dec1+@dec2)/2;
	--
	set @d2r  = PI()/180.0;
	-- n1 is the normal vector to the plane of great circle 1
	set @nx1  = SIN(@ra1*@d2r) * COS(@dec1*@d2r);
	set @ny1  = COS(@ra1*@d2r) * COS(@dec1*@d2r);
	set @nz1  = SIN(@dec1*@d2r);
	--
	set @nx2  = SIN(@ra2*@d2r) * COS(@dec2*@d2r);
	set @ny2  = COS(@ra2*@d2r) * COS(@dec2*@d2r);
	set @nz2  = SIN(@dec2*@d2r);
	--
	set @nx  = SIN(@ra*@d2r) * COS(@dec*@d2r);
	set @ny  = COS(@ra*@d2r) * COS(@dec*@d2r);
	set @nz  = SIN(@dec*@d2r);
	--
	set @d1 = @nx1*@nx+@ny1*@ny+@nz1*@nz;
	set @d2 = @nx2*@nx+@ny2*@ny+@nz2*@nz;
	if @d1<@d2 SET @dot=@d1 ELSE SET @dot=@d2
	set @radius = ACOS(@dot)/@d2r*60.0;
	INSERT @proxtab SELECT
	    objID, run, camcol, field, rerun, type,
	    cx, cy, cz, htmID
	from fGetNearbyObjEq(@ra,@dec,@radius)
	    WHERE (cz>@nz1) AND (cz<@nz2) 
		AND (-cx*@nx1+cy*@ny1>0)
		AND (cx*@nx2-cy*@ny2)>0 
  RETURN
  END 
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetObjFromRectEq' )
	DROP FUNCTION fGetObjFromRectEq
GO
--
CREATE FUNCTION fGetObjFromRectEq (@ra1 float, @dec1 float, 
				   @ra2 float, @dec2 float)
---------------------------------------------------------------------------
--/H Returns table of objects inside a rectangle defined by two ra,dec pairs.
--/H <br>Note the order of the parameters: @ra1, @dec1, @ra2, @dec2
--
--/T This is a variant of fGetObjFromRect (actually calls it) that takes
--/T the input parameters in a more intuitive order rather than (ra1,ra2,dec1,dec2).
--/T <br>Assumes dec1<dec2. There is no limit on the number of objects.
--/T <br>Uses level 20 HTM.
--/T <br> returned fields: 
--/T  <li> objID bigint,             -- id of the object
--/T  <li> run int NOT NULL,         -- run that observed the object
--/T  <li> camcol int NOT NULL,      -- camera column in run
--/T  <li> field int NOT NULL,       -- field in run
--/T  <li> rerun int NOT NULL,       -- software rerun that saw the object
--/T  <li> type int NOT NULL,        -- type of object (see DataConstants PhotoType)
--/T  <li> cx float NOT NULL,        -- xyz of object
--/T  <li> cy float NOT NULL,
--/T  <li> cz float NOT NULL,
--/T  <li> htmID bigint              -- hierarchical triangular mesh ID of object
--/T <br>sample call<br>
--/T <samp> select * from dbo.fGetObjFromRectEq(185,0,185.1,0.1) </samp>
---------------------------------------------------------------------------
RETURNS @proxtab TABLE (
    objID bigint,
    run int NOT NULL,
    camcol int NOT NULL,
    field int NOT NULL,
    rerun int NOT NULL,
    type int NOT NULL,
    cx float NOT NULL,
    cy float NOT NULL,
    cz float NOT NULL,
    htmID bigint
)
AS BEGIN
  -- call original function with params in different order
  INSERT @proxtab SELECT * FROM fGetObjFromRect(@ra1, @ra2, @dec1, @dec2)
  RETURN
  END 
GO



--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
           WHERE  name = N'fGetObjectsEq' ) 
	DROP FUNCTION fGetObjectsEq
GO
--
CREATE  FUNCTION [dbo].[fGetObjectsEq](@flag int, @ra float, 
				@dec float, @r float, @zoom float)
-------------------------------------------------------------
--/H A helper function for SDSS cutout that returns all objects
--/H within a certain radius of an (ra,dec)
-------------------------------------------------------------
--/T Photo objects are filtered to have magnitude greater than
--/T     24-1.5*zoom so that the image is not too cluttered
--/T     (and the anwswer set is not too large).<br>
--/T (@flag&1)>0 display specObj ...<br>
--/T (@flag&2)>0 display photoPrimary bright enough for zoom<br>
--/T (@flag&4)>0 display Target <br>
--/T (@flag&8)>0 display Mask<br>
--/T (@flag&16)>0 display Plate<br>
--/T (@flag&32)>0 display PhotoObjAll<br>
--/T thus: @flag=7 will display all three of specObj, PhotoObj and Target
--/T the returned objects have 
--/T          flag = (specobj:1, photoobj:2, target:4, mask:8, plate:16)
-------------------------------------------------
RETURNS @obj table (ra float, [dec] float, flag int, objid numeric(20))
AS BEGIN
        DECLARE		@nx float,
                @ny float,
                @nz float,
                @rad float,
                @mag float
                
	set @rad = @r;
        if (@rad > 250) set @rad = 250      -- limit to 4.15 degrees == 250 arcminute radius
        set @nx  = COS(RADIANS(@dec))*COS(RADIANS(@ra));
        set @ny  = COS(RADIANS(@dec))*SIN(RADIANS(@ra));
        set @nz  = SIN(RADIANS(@dec));
        set @mag =  25 - 1.5* @zoom;  -- magnitude reduction.
        
	declare @htmTemp table (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);

	insert @htmTemp select * from dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@rad)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@rad/120)),2);
	
	if ( (@flag & 1) > 0 )  -- specObj
            begin
                INSERT @obj
--                SELECT ra, dec,  @flag as flag, specobjid as objid
                SELECT ra, dec,  1 as flag, specobjid as objid
                FROM @htmTemp H join SpecObj WITH (nolock)
				-- FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@rad) H inner loop join SpecObj WITH (nolock)
	            ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
				ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
            end
            
            

        if ( (@flag & 2) > 0 )  -- photoObj
            begin
                INSERT @obj
                SELECT ra, dec, 2 as flag, objid
                FROM @htmTemp H join PhotoPrimary WITH (nolock)
				--FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@rad) H inner loop join PhotoPrimary WITH (nolock)
	            ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
                AND (r <= @mag )
				ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
            end

        if ( (@flag & 4) > 0 )  -- target
            begin
                INSERT @obj
                SELECT ra, dec, 4 as flag, targetid as objid
                FROM @htmTemp H join Target WITH (nolock)
				--FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@rad) H inner loop join Target WITH (nolock)
	             ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
				ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
            end

        if ( (@flag & 8) > 0 )  -- mask
            begin
                INSERT @obj
                SELECT ra, dec, 8 as flag, maskid as objid
                FROM @htmTemp H join Mask WITH (nolock)
				--FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@rad) H inner loop join Mask WITH (nolock)
	             ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
				ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
            end

        if ( (@flag & 16) > 0 ) -- plate
            begin
                SET @rad = @r + 89.4;   -- add the tile radius
                INSERT @obj
                SELECT ra, dec, 16 as flag, plateid as objid
                FROM @htmTemp H join PlateX WITH (nolock)
                --FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@rad) H inner loop join PlateX WITH (nolock)
	             ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
				ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
            end

        if ( (@flag & 32) > 0 )  -- photoPrimary and secondary
            begin
                INSERT @obj
                SELECT ra, dec, 2 as flag, objid
                FROM @htmTemp H join PhotoObjAll WITH (nolock)
				--FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@rad) H inner loop join PhotoObjAll WITH (nolock)
	             ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
		        AND mode in (1,2)
				ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
            end
        --
        RETURN
END
GO

--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
           WHERE  name = N'fGetObjectsMaskEq' ) 
	DROP FUNCTION fGetObjectsMaskEq
GO
--
CREATE   FUNCTION fGetObjectsMaskEq(@flag int, @ra float, @dec float, @r float, @zoom float)
-------------------------------------------------------------
--/H A helper function for SDSS cutout that returns all objects
--/H within a certain radius of an (ra,dec)
-------------------------------------------------------------
--/T Photo objects are filtered to have magnitude greater than
--/T     24-1.5*zoom so that the image is not too cluttered
--/T     (and the anwswer set is not too large).<br>
--/T (@flag&1)>0 display specObj ...<br>
--/T (@flag&2)>0 display photoPrimary...<br>
--/T (@flag&4)>0 display Target <br>
--/T (@flag&8)>0 display Mask<br>
--/T (@flag&16)>0 display Plate<br>
--/T thus: @flag=7 will display all three of specObj, PhotoObj and Target
--/T the returned objects have 
--/T          flag = (specobj:1, photoobj:2, target:4, mask:8, plate:16)
-------------------------------------------------
RETURNS @obj table (ra float, [dec] float, flag int, objid bigint)
AS BEGIN
         DECLARE @nx float,
                @ny float,
                @nz float,
                @rad float,
                @mag float
	set @rad = @r;
        if (@rad > 250) set @rad = 250      -- limit to 4.15 degrees == 250 arcminute radius
        set @nx  = COS(RADIANS(@dec))*COS(RADIANS(@ra));
        set @ny  = COS(RADIANS(@dec))*SIN(RADIANS(@ra));
        set @nz  = SIN(RADIANS(@dec));
        set @mag =  25 - 1.5* @zoom;  -- magnitude reduction.
        
   --
	declare @htmTemp table (
	HtmIdStart bigint,
	HtmIdEnd bigint
	);

	insert @htmTemp select * from dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
   --
	DECLARE @lim float;	
	SET @lim = POWER(2*SIN(RADIANS(@rad/120)),2);
	
   --

        if ( (@flag & 1) > 0 )  -- specObj
            begin
                INSERT @obj
                SELECT ra, dec,  1 as flag, specobjid as objid
				FROM @htmTemp H  join SpecObj WITH (nolock)
	             ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)< @lim
            end

        if ( (@flag & 2) > 0 )  -- photoObj
            begin
                INSERT @obj
                SELECT ra, dec, 2 as flag, objid
				FROM @htmTemp H  join PhotoPrimary WITH (nolock)
	             ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)< @lim
                and (r <= @mag )
            end

        if ( (@flag & 4) > 0 )  -- target
            begin
                INSERT @obj
                SELECT ra, dec, 4 as flag, targetid as objid
				FROM @htmTemp H  join Target WITH (nolock)
	             ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)< @lim
            end

        if ( (@flag & 8) > 0 )  -- mask
            begin
                INSERT @obj
                SELECT ra, dec, 8 as flag, maskid as objid
				FROM @htmTemp H  join Mask WITH (nolock)
	            ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE ((2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60)< (@rad+radius))
            end

        if ( (@flag & 16) > 0 ) -- plate
            begin
                SET @rad = @r + 89.4;   -- add the tile radius
                INSERT @obj
                SELECT ra, dec, 16 as flag, plateid as objid
                FROM @htmTemp H  join PlateX WITH (nolock)
	            ON  ( HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
                WHERE power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)< @lim
            end
        --
        RETURN
END
GO

--===================================================================
IF EXISTS (SELECT * FROM dbo.sysobjects 
	WHERE id = object_id(N'[dbo].[fGetJpegObjects]') 
	AND xtype IN (N'FN', N'IF', N'TF'))
	DROP FUNCTION [dbo].[fGetJpegObjects]
GO
--
CREATE  FUNCTION fGetJpegObjects(@flag int, @ra float, 
				       @dec float, @r float, @zoom float)
-------------------------------------------------------------
--/H A helper function for SDSS cutout that returns all objects
--/H within a certain radius of an (ra,dec)
-------------------------------------------------------------
--/T Photo objects are filtered to have magnitude greater than
--/T     24-1.5*zoom so that the image is not too cluttered
--/T     (and the anwswer set is not too large).<br>
--/T (@flag&1)>0 display specObj ...<br>
--/T (@flag&2)>0 display photoPrimary...<br>
--/T (@flag&4)>0 display Target <br>
--/T (@flag&8)>0 display Mask<br>
--/T (@flag&16)>0 display Plate<br>
--/T thus: @flag=7 will display all three of specObj, PhotoObj and Target
--/T the returned objects have 
--/T          flag = (specobj:1, photoobj:2, target:4, mask:8, plate:16)
-------------------------------------------------
--/A legacy: use fGetObjectsEq)
RETURNS @obj TABLE (ra float, [dec] float, flag int, objid bigint)
AS 
BEGIN
  INSERT @obj SELECT * from fGetObjectsEq(@flag, @ra, @dec, @r, @zoom)
  RETURN
END
GO


--==================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spGetMatch]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spGetMatch]
GO
--
CREATE  PROCEDURE spGetMatch(@r float, @w float, @eps float) 
------------------------------------------------------------------- 
--/H Get the neighbors to a list of @ra,@dec pairs in #upload in photoPrimary 
--/H within @r arcsec . @w is the weight per object.
--/U 
--/T The procedure is used in conjunction with a list upload 
--/T service, where the (ra,dec) coordinates of an object list 
--/T are put into a temporary table #upload by the web interface. 
--/T This table name is hardcoded in the procedure. It then returns 
--/T a matchup table, containing the up_id and the SDSS objId. 
--/T The result of this is then joined with the photoPrimary table, 
--/T to return the attributes of the photometric objects. 
--/T @r is measured in arcsec
--/T @w is the weight, it is 1/@sigma^2, where @sigma is in radians
--/T @eps is the chisq threshold
--/T <samp> 
--/T <br> create table #x (pk int,id bigint,a float, ax float, ay float, az float) 
--/T <br> insert into #x EXEC spGetMatch  2.5, 0.0000001, ...
--/T </samp> 
------------------------------------------------------------------- 
AS 
BEGIN 
        SET NOCOUNT ON; 
        SET IMPLICIT_TRANSACTIONS ON; 
        DECLARE @pk int, @a float, @ax FLOAT, @ay FLOAT, @az FLOAT, 
		@qx float, @qy float, @qz float, @b FLOAT, @rr float, 
		@FETCH_STATUS INT; 
        DECLARE ObjCursor CURSOR 
           FOR SELECT  pk, xmatch_a, xmatch_ax, xmatch_ay, xmatch_az  
		FROM #upload; 
        SET @FETCH_STATUS = 0; 
        CREATE TABLE #x ( 
                pk  int, 
                id bigint,
		chisq float, 
		a float,
		ax float, 
		ay float, 
		az float
                ); 
        OPEN ObjCursor; 
        WHILE (@FETCH_STATUS = 0) 
          BEGIN 
            WHILE(@FETCH_STATUS = 0) 
              BEGIN 
                FETCH NEXT FROM Objcursor INTO @pk, @a, @ax, @ay, @az; 
		SET @b  = @a*SQRT((@ax*@ax + @ay*@ay + @az*@az)/(@a*@a)+0.00000001);
		SET @qx = @ax/@b;
		SET @qy = @ay/@b;
		SET @qz = @az/@b;
		SET @rr = @r /60;
                SET @FETCH_STATUS = @@FETCH_STATUS; 
                IF (@FETCH_STATUS != 0) BREAK; 
                INSERT INTO #x 
                SELECT @pk as pk, 
		    objID as id,
		    @a+@w-sqrt(power(@ax+@w*cx,2)+power(@ay+@w*cy,2)+power(@az+@w*cz,2)) as chisq,
		    @a  + @w as a,
		    @ax + @w*cx as ax,
		    @ay + @w*cy as ay,
		    @az + @w*cz as az
                    FROM dbo.fGetNearbyObjXYZ(@qx,@qy,@qz,@rr) 
		    WHERE
			 @a+@w-sqrt(power(@ax+@w*cx,2)+power(@ay+@w*cy,2)+power(@az+@w*cz,2)) < @eps
              END; 
          END; 
        CLOSE ObjCursor; 
        DEALLOCATE ObjCursor; 
        SELECT * FROM #x 
--	SET IMPLICIT_TRANSACTIONS OFF
END 
GO


drop function if exists fGetNearbyAllspecEq
GO

CREATE FUNCTION [dbo].[fGetNearbyAllspecEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of Allspec objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> allspec_id varchar(128) NOT NULL, -- 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> mangaid varchar(10) not null,      -- 
--/T <li> apogee_id varchar(32) not null,      -- 
--/T <li> visit_id varchar(40) not null,      -- 
--/T <li> specobjid numeric(30) null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetAllspecEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyAllspecXyz, fGetNearestAllspecEq, fGetNearestAllspecXYZ
  RETURNS @proxtab TABLE (
	allspec_id varchar(128) NOT NULL,
	sdss_id bigint NOT NULL,
	mangaid varchar(10) not null,
	apogee_id varchar(32) not null,
    specobjid numeric(30)  NULL,
	visit_id varchar(40) not null,	
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbyAllspecXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO

USE [BestDR19]
GO

/****** Object:  UserDefinedFunction [dbo].[fGetNearbyMosTargetXYZ]    Script Date: 6/30/2025 11:52:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


drop function if exists fGetNearbyAllspecXYZ
go
 CREATE FUNCTION [dbo].[fGetNearbyAllspecXYZ] (@nx float, @ny float, @nz float, @r float)

-------------------------------------------------------------
--/H Returns table of Allspec objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> allspec_id varchar(128) NOT NULL, -- 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> mangaid varchar(10) not null,      -- 
--/T <li> apogee_id varchar(32) not null,      -- 
--/T <li> visit_id varchar(40) not null,      -- 
--/T <li> specobjid numeric(30) null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetAllspecEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyAllspecXyz, fGetNearestAllspecEq, fGetNearestAllspecXYZ

  RETURNS @proxtab TABLE (
	allspec_id varchar(128) NOT NULL,
	sdss_id bigint NOT NULL,
	mangaid varchar(10) not null,
	apogee_id varchar(32) not null,
    specobjid numeric(30)  NULL,
	visit_id varchar(40) not null,	
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
)
AS
BEGIN



	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	
	INSERT @proxtab	SELECT
		allspec_id,
		sdss_id,
		mangaid,
		apogee_id,
	    specobjid,
		visit_id,
	    ra,
	    [dec],

	    htmID,
	    2*DEGREES(ASIN(sqrt(power(@nx-( COS([dec]) * COS(ra) ),2)+power(@ny-( COS([dec]) * SIN(ra) ),2)+power(@nz-( SIN([dec]) ),2))/2))*60 
	    FROM @htmTemp H  inner loop join Allspec P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO



drop function if exists fGetNearestAllspecEq
go

CREATE FUNCTION [dbo].[fGetNearestAllspecEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of Allspec objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> allspec_id varchar(128) NOT NULL, -- 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> mangaid varchar(10) not null,      -- 
--/T <li> apogee_id varchar(32) not null,      -- 
--/T <li> visit_id varchar(40) not null,      -- 
--/T <li> specobjid numeric(30) null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find Allspec objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetAllspecEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyAllspecXyz, fGetNearestAllspecEq, fGetNearestAllspecXYZ
 RETURNS @proxtab TABLE (
	allspec_id varchar(128) NOT NULL,
	sdss_id bigint NOT NULL,
	mangaid varchar(10) not null,
	apogee_id varchar(32) not null,
    specobjid numeric(30)  NULL,
	visit_id varchar(40) not null,	
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
)
AS
BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT top 1 * FROM dbo.fGetNearbyAllspecXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO


drop function if exists fGetNearestAllspecXYZ
go
CREATE FUNCTION [dbo].[fGetNearestAllspecXYZ] (@nx float, @ny float, @nz float, @r float)
 -------------------------------------------------------------
 --/H Returns nearest Allspec object within @r arcminutes of an xyz point (@nx,@ny, @nz).
 -------------------------------------------------------------
--/T <li> allspec_id varchar(128) NOT NULL, -- 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> mangaid varchar(10) not null,      -- 
--/T <li> apogee_id varchar(32) not null,      -- 
--/T <li> visit_id varchar(40) not null,      -- 
--/T <li> specobjid numeric(30) null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find Allspec objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetAllspecEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyAllspecXyz, fGetNearestAllspecEq, fGetNearestAllspecXYZ
 RETURNS @proxtab TABLE (
	allspec_id varchar(128) NOT NULL,
	sdss_id bigint NOT NULL,
	mangaid varchar(10) not null,
	apogee_id varchar(32) not null,
    specobjid numeric(30)  NULL,
	visit_id varchar(40) not null,	
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
)
AS
BEGIN
	INSERT @proxtab	
	SELECT top 1 * 
	FROM dbo.fGetNearbyAllspecXYZ(@nx,@ny,@nz,@r)
	ORDER BY distance ASC
  RETURN
  END
GO


drop function if exists fGetNearbyApogeeDrpAllstarEq
GO

CREATE FUNCTION [dbo].[fGetNearbyApogeeDrpAllstarEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of ApogeeDrpAllstar objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> 	PK bigint not null, 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> apogee_id varchar(32) not null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetApogeeDrpAllstarEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyApogeeDrpAllstarXyz, fGetNearestApogeeDrpAllstarEq, fGetNearestApogeeDrpAllstarXYZ
  RETURNS @proxtab TABLE (
	PK bigint not null,
	sdss_id bigint NOT NULL,
	apogee_id varchar(32) not null,
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbyApogeeDrpAllstarXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO

USE [BestDR19]
GO

/****** Object:  UserDefinedFunction [dbo].[fGetNearbyMosTargetXYZ]    Script Date: 6/30/2025 11:52:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


drop function if exists fGetNearbyApogeeDrpAllstarXYZ
go
 CREATE FUNCTION [dbo].[fGetNearbyApogeeDrpAllstarXYZ] (@nx float, @ny float, @nz float, @r float)

-------------------------------------------------------------
--/H Returns table of ApogeeDrpAllstar objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li>PK bigint not null -- 
--/T <li> sdss_id bigint not null,      --  
--/T <li> apogee_id varchar(32) not null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetApogeeDrpAllstarEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyMosTargetXyz, fGetNearestMosTargetEq, fGetNearestMosTargetXYZ

  RETURNS @proxtab TABLE (
	PK bigint not null,
	sdss_id bigint NOT NULL,
	apogee_id varchar(32) not null,
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
)
AS
BEGIN



	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	
	INSERT @proxtab	SELECT
		PK,
		sdss_id,
		apogee_id,
		ra,
		[dec],
		htmid,

	    2*DEGREES(ASIN(sqrt(power(@nx-( COS([dec]) * COS(ra) ),2)+power(@ny-( COS([dec]) * SIN(ra) ),2)+power(@nz-( SIN([dec]) ),2))/2))*60 
	    FROM @htmTemp H  inner loop join apogee_drp_allstar P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO



drop function if exists fGetNearestApogeeDrpAllstarEq
go

CREATE FUNCTION [dbo].[fGetNearestApogeeDrpAllstarEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of ApogeeDrpAllstar objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li>PK bigint not null -- 
--/T <li> sdss_id bigint not null,      --  
--/T <li> apogee_id varchar(32) not null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find ApogeeDrpAllstar objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetApogeeDrpAllstarEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyApogeeDrpAllstarXyz, fGetNearestApogeeDrpAllstarEq, fGetNearestApogeeDrpAllstarXYZ
 RETURNS @proxtab TABLE (
	PK bigint not null,
	sdss_id bigint NOT NULL,
	apogee_id varchar(32) not null,
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float	-- distance in arc minutes
	)
AS
BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT top 1 * FROM dbo.fGetNearbyApogeeDrpAllstarXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO


drop function if exists fGetNearestApogeeDrpAllstarXYZ
go
CREATE FUNCTION [dbo].[fGetNearestApogeeDrpAllstarXYZ] (@nx float, @ny float, @nz float, @r float)
 -------------------------------------------------------------
 --/H Returns nearest ApogeeDrpAllstar object within @r arcminutes of an xyz point (@nx,@ny, @nz).
 -------------------------------------------------------------
--/T <li>PK bigint not null -- 
--/T <li> sdss_id bigint not null,      --  
--/T <li> apogee_id varchar(32) not null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find ApogeeDrpAllstar objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetApogeeDrpAllstarEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyApogeeDrpAllstarXyz, fGetNearestApogeeDrpAllstarEq, fGetNearestApogeeDrpAllstarXYZ
 RETURNS @proxtab TABLE (
	PK bigint not null,
	sdss_id bigint NOT NULL,
	apogee_id varchar(32) not null,
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float	-- distance in arc minutes
	
)
AS
BEGIN
	INSERT @proxtab	
	SELECT top 1 * 
	FROM dbo.fGetNearbyApogeeDrpAllstarXYZ(@nx,@ny,@nz,@r)
	ORDER BY distance ASC
  RETURN
  END
GO



drop function if exists fGetNearbySpAllEq
GO

CREATE FUNCTION [dbo].[fGetNearbySpAllEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of SpAll objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> specobjid numeric(30) NOT NULL, -- 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetSpAllEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbySpAllXyz, fGetNearestSpAllEq, fGetNearestSpAllXYZ
  RETURNS @proxtab TABLE (
    specobjid numeric(30)  NULL,
	sdss_id bigint NOT NULL,
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT * FROM dbo.fGetNearbySpAllXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO

USE [BestDR19]
GO

/****** Object:  UserDefinedFunction [dbo].[fGetNearbyMosTargetXYZ]    Script Date: 6/30/2025 11:52:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


drop function if exists fGetNearbySpAllXYZ
go
 CREATE FUNCTION [dbo].[fGetNearbySpAllXYZ] (@nx float, @ny float, @nz float, @r float)

-------------------------------------------------------------
--/H Returns table of SpAll objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> specobjid numeric(30)  NULL, -- 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetSpAllEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyMosTargetXyz, fGetNearestMosTargetEq, fGetNearestMosTargetXYZ

  RETURNS @proxtab TABLE (
    specobjid numeric(30)  NULL,
	sdss_id bigint NOT NULL,
    ra float NULL,
    [dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS 
BEGIN



	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
	
	INSERT @proxtab	SELECT 
	    specobjid,
		sdss_id,
	    racat,
	    [deccat],

	    htmID,
	    2*DEGREES(ASIN(sqrt(power(@nx-( COS([deccat]) * COS(racat) ),2)+power(@ny-( COS([deccat]) * SIN(racat) ),2)+power(@nz-( SIN([deccat]) ),2))/2))*60 
	    FROM @htmTemp H  inner loop join SpAll P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO



drop function if exists fGetNearestSpAllEq
go

CREATE FUNCTION [dbo].[fGetNearestSpAllEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of SpAll objects within @r arcmins of an equatorial point (@ra, @dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned.
--/T <p>returned table:  
--/T <li> specobjid numeric(30)  NULL, -- 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find SpAll objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetSpAllEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbySpAllXyz, fGetNearestSpAllEq, fGetNearestSpAllXYZ
  RETURNS @proxtab TABLE (
    specobjid numeric(30)  NULL,
	sdss_id bigint NOT NULL,
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
  ) AS BEGIN
	DECLARE @d2r float, @nx float,@ny float,@nz float 
	set @d2r = PI()/180.0
	if (@r<0) RETURN
	set @nx  = COS(@dec*@d2r)*COS(@ra*@d2r)
	set @ny  = COS(@dec*@d2r)*SIN(@ra*@d2r)
	set @nz  = SIN(@dec*@d2r)
	INSERT @proxtab	
	SELECT top 1 * FROM dbo.fGetNearbySpAllXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
GO


drop function if exists fGetNearestSpAllXYZ
go
CREATE FUNCTION [dbo].[fGetNearestSpAllXYZ] (@nx float, @ny float, @nz float, @r float)
 -------------------------------------------------------------
 --/H Returns nearest SpAll object within @r arcminutes of an xyz point (@nx,@ny, @nz).
 -------------------------------------------------------------
 --/T <p>returned table:  
--/T <li> specobjid numeric(30)  NULL, -- 
--/T <li> sdss_id bigint not null,      -- 
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination           -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find SpAll objects within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetSpAllEq(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbySpAllXyz, fGetNearestSpAllEq, fGetNearestSpAllXYZ
  RETURNS @proxtab TABLE (
    specobjid numeric(30)  NULL,
	sdss_id bigint NOT NULL,
    ra float NULL,
	[dec] float NULL,
    htmID bigint,
    distance float		-- distance in arc minutes
	) AS BEGIN
	INSERT @proxtab	
	SELECT top 1 * 
	FROM dbo.fGetNearbySpAllXYZ(@nx,@ny,@nz,@r)
	ORDER BY distance ASC
  RETURN
  END
GO



 /* 

test cases


declare @ra float,@dec float
select @ra = min(ra), @dec = min(dec) 
 from ( select top 1 ra,dec 
	from photoObj)  as t
  	select * from dbo.fGetJpegObjects( 1, @ra,@dec,  10, 10)
	select * from dbo.fGetJpegObjects( 1, @ra,@dec,  10,  0)
	select * from dbo.fGetJpegObjects( 7, @ra,@dec, 100, 10)
	select * from dbo.fGetJpegObjects( 7, @ra,@dec, 150, 20)
*/

--===================================================================
PRINT '[spNearby.sql]: Proximity functions created'
GO
