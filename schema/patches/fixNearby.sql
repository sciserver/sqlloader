--=================================================================
--   fixNearby.sql
--	 2011-04-26 Ani Thakar
-------------------------------------------------------------------
-- Applies SQL2k8 performance fixes to the primitive nearby functions. 
-------------------------------------------------------------------
-- History:
-------------------------------------------------------------------

--====================================================================
PRINT '*** FIX NEARBY FUNCTIONS ***'
--

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
ALTER FUNCTION [dbo].[fGetNearbyObjXYZ](@nx float, @ny float, @nz float, @r float)
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
    distance float              -- distance in arc minutes
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
        INSERT @proxtab SELECT 
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
            
            FROM @htmTemp H  join PhotoPrimary P
                     ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
           AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) < @lim
        ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)  ASC

  RETURN
END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
ALTER FUNCTION [dbo].[fGetNearbyObjAllXYZ] (@nx float, @ny float, @nz float, @r float)
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
    distance float              -- distance in arc minutes
  ) AS 
BEGIN
        DECLARE @htmTemp TABLE (
                HtmIdStart bigint,
                HtmIdEnd bigint
        );

        INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@nx,@ny,@nz,@r)
        DECLARE @lim float;
        SET @lim = POWER(2*SIN(RADIANS(@r/120)),2);
        INSERT @proxtab SELECT 
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
            FROM @htmTemp H join PhotoObjAll P
                     ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
            AND power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2)< @lim
            ORDER BY power(@nx-cx,2)+power(@ny-cy,2)+power(@nz-cz,2) ASC
  RETURN
END
GO



ALTER  FUNCTION fGetObjectsEq(@flag int, @ra float, 
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
RETURNS @obj table (ra float, [dec] float, flag int, objid bigint)
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
                SELECT ra, dec,  @flag as flag, specobjid as objid
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
--



ALTER FUNCTION fGetNearbyFrameEq (@ra float, @dec float, 
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
--
