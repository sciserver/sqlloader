
/****** Object:  UserDefinedFunction [dbo].[fGetNearbyMosTargetXYZ]    Script Date: 1/4/2023 11:47:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--
/* Commenting the XYZ version out for now 
--=======================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearbyMosTargetXyz' )
	DROP FUNCTION fGetNearbyMosTargetXyz
GO
--
CREATE FUNCTION [dbo].[fGetNearbyMosTargetXYZ] (@nx float, @ny float, @nz float, @r float)
-------------------------------------------------------------
--/H Returns table of scienceprimary spectrum objects within @r arcmins of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> target_pk biginit NOT NULL, -- primary object identifier
--/T <li> catalogid bigint NULL,      -- id in mos_catalog   
--/T <li> ra NULL,                    -- position RA
--/T <li> dec NULL,                   -- position declination
--/T <li> epoch real NULL,            -- 
--/T <li> parallax NULL,              -- 
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find mos_target within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyMosTargetXYZ(-.996,-.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyMosTargetEq
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
		-- @cx = ( (COS([dec]) * COS(ra)) / parallax )
		-- @cy = ( (COS([dec]) * SIN(ra)) / parallax )
		-- @cz = ( SIN([dec]) / parallax )
 --	    2*DEGREES(ASIN(sqrt(power(@nx-((COS([dec]) * COS(ra) * 3.26) / parallax),2)+power(@ny-((COS([dec]) * SIN(ra) * 3.26) / parallax),2)+power(@nz-((SIN([dec]) * 5.26) / parallax),2))/2))*60 
	    2*DEGREES(ASIN(sqrt(power(@nx-( COS([dec]) * COS(ra) ),2)+power(@ny-( COS([dec]) * SIN(ra) ),2)+power(@nz-( SIN([dec]) ),2))/2))*60 
	    --sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/@d2r*60 
	    FROM @htmTemp H join mos_target T
	             ON  (T.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
					AND power(@nx-( COS([dec]) * COS(ra) ),2)+power(@ny-( COS([dec]) * SIN(ra) ),2)+power(@nz-( SIN([dec])),2 )< @lim
	    ORDER BY power(@nx-( COS([dec]) * COS(ra) ),2)+power(@ny-( COS([dec]) * SIN(ra) ),2)+power(@nz-( SIN([dec]) ),2) ASC
  RETURN
  END
  GO
  --
  */


--=======================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearbyMosTargetEq' )
	DROP FUNCTION fGetNearbyMosTargetEq
GO
--
CREATE FUNCTION [dbo].[fGetNearbyMosTargetEq] (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of spectrum objects within @r arcmins of an equatorial point (@ra, @dec).
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
--/T <br> Sample call to find SpecObj within 0.5 arcminutes of ra,dec 180.0, -0.5
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbySpecObjXYZ(180.0, -0.5, 0,5)  
--/T </samp>  
--/T <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearestSpecObjXYZ
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
		dbo.fDistanceArcMinEq(@ra,@dec,A.ra,A.[dec])
	    FROM @htmTemp H join mos_target A
	             ON  (A.htmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	    AND dbo.fDistanceArcMinEq(@ra,@dec,A.ra,A.[dec]) < @r
-- 	SELECT * FROM dbo.fGetNearbyMosTargetXYZ(@nx,@ny,@nz,@r) 
  RETURN
  END
  GO
  --

