-- Patch to apply Tamas's fix to fFootprintEq so that it only includes
-- the primary footprint,

/****** Object:  UserDefinedFunction [dbo].[fFootprintEq]    Script Date: 12/15/2014 12:03:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--
ALTER FUNCTION [dbo].[fFootprintEq](@ra float, @dec float, @radius_arcmin float)
-----------------------------------------------------------------
--/H Determines whether a point is inside the survey footprint
--
--/T Returns regiontype POLYGON if inside (to be backward compatible with earlier releases)
--/T that contain the given point. Empty indicates that the point
--/T is entirely outside the survey footprint.
-----------------------------------------------------------------
RETURNS table AS RETURN 
(
	SELECT DISTINCT 'POLYGON' as [Type] 
	FROM dbo.fPolygonsContainingPointEq(@ra,@dec,@radius_arcmin) p
	    JOIN Region r ON r.regionid=p.regionid
	    JOIN sdssPolygons s ON r.id=s.sdssPolygonID
	WHERE 
		primaryfieldid in (select fieldid from Field)
)
GO


-- Also updated fInFootprintEq to use the fFootprintEq function intead of
-- fPolygonsContainingPointEq. [ART]

/****** Object:  UserDefinedFunction [dbo].[fInFootprintEq]    Script Date: 12/15/2014 12:03:33 ******/
ALTER FUNCTION [dbo].[fInFootprintEq] (@ra float, @dec float, @rad float)
-----------------------------------------------------------------
--/H Indicates whether the given point is in the SDSS footprint or not.
--/T
--/T Returns 'true' or 'false' depending on whether the given circle
--/T (ra,dec,radius) is in the SDSS footprint or not.  The radius is in
--/T arcmin.
--/T
--/T <samp>
--/T     SELECT dbo.fInFootprintEq( 143.15, -0.7, 2.0 )
--/T </samp>
--/T <br> See also fFootprintEq.
-----------------------------------------------------------------
RETURNS bit
AS BEGIN
	declare @num int, @ret bit;
    
	SELECT @num = COUNT(*) 
	FROM dbo.fFootprintEq(@ra, @dec, @rad)
    
	IF (@num > 0) 
		SET @ret = 1 
	ELSE 
		SET @ret = 0
	RETURN @ret
END
GO



-- get a clean check on schema and indices first
EXEC spCheckDBObjects
EXEC spCheckDBColumns
EXEC spCheckDBIndexes


-- now set the new version; this gets tweaked for each version
EXECUTE spSetVersion
  0
  ,0
  ,'12'
  ,'160038'
  ,'Update DR'
  ,'.1'
  ,'Patch to fix footprint functions'
  ,'Fixed fFootprintEq and fInFootprintEq to include only primary area.'
  ,'T.Budavari,A.Thakar'

