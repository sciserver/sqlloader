USE [BESTDR9]
GO
/****** Object:  UserDefinedFunction [dbo].[fGetObjectsEq]    Script Date: 10/26/2012 16:28:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

SELECT GETDATE()
GO
--
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
--                FROM @htmTemp H join PhotoPrimary WITH (INDEX(i_PhotoObjAll_htmID_cx_cy_cz_typ),nolock)
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

