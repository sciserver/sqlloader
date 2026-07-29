-------------------------------------------------------------------------------
--  fix_nearby_distance.sql
--
--  These 4 functions computed the returned `distance` from ra/dec using
--  COS()/SIN() without converting degrees to radians, while @nx/@ny/@nz were
--  built WITH the conversion. The row filter uses cx/cy/cz, so correct rows
--  came back in correct order -- only the reported distance was wrong
--  (9825 arcmin for a zero-separation self-match).
--
--  Replaced with the cx/cy/cz form the other 5 fGetNearby*XYZ already use.
--  Extracted from BestDR20 on sdss4c after the fix was verified there.
--
--  Safe to re-run. ALTER FUNCTION preserves permissions and dependencies.
--
--  Suzanne Werner, 2026-07-28
-------------------------------------------------------------------------------
USE BestDR20;
GO

-- ---- fGetNearbyMosTargetXYZ --------------------------------------


 ALTER FUNCTION [dbo].[fGetNearbyMosTargetXYZ] (@nx float, @ny float, @nz float, @r float)
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
	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 
	    FROM @htmTemp H  inner loop join mos_target P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO

-- ---- fGetNearbyAllspecXYZ ----------------------------------------
--
 ALTER FUNCTION [dbo].[fGetNearbyAllspecXYZ] (@nx float, @ny float, @nz float, @r float)

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
	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 
	    FROM @htmTemp H  inner loop join Allspec P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO

-- ---- fGetNearbyApogeeDrpAllstarXYZ -------------------------------
 ALTER FUNCTION [dbo].[fGetNearbyApogeeDrpAllstarXYZ] (@nx float, @ny float, @nz float, @r float)

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

	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 
	    FROM @htmTemp H  inner loop join apogee_drp_allstar P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO

-- ---- fGetNearbySpAllXYZ ------------------------------------------
 ALTER FUNCTION [dbo].[fGetNearbySpAllXYZ] (@nx float, @ny float, @nz float, @r float)

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
	    2*DEGREES(ASIN(sqrt(power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2))/2))*60 
	    FROM @htmTemp H  inner loop join SpAll P
	             ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	   AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
	ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC
  RETURN
  END
GO

-- verify: no broken expression left
SELECT o.name AS still_broken
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.name LIKE 'fGetNearby%XYZ' AND m.definition LIKE '%COS([%' AND m.definition NOT LIKE '%@nx-cx%';
GO
