
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
	) ON [SPEC];
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2) ON [SPEC];
	
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

