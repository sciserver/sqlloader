
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
	) ON [SPEC];
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2) ON [SPEC];
	
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

