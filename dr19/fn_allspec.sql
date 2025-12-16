
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
	) ON [SPEC];
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
	DECLARE @lim float;
	SET @lim = POWER(2*SIN(RADIANS(@r/120)),2) ON [SPEC];
	
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

