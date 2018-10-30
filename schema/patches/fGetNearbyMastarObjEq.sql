

/****** Object:  UserDefinedFunction [dbo].[fGetNearbyMaStarObjEq]    Script Date: 10/10/2018 1:29:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


drop function if exists [dbo].[fGetNearbyMaStarObjEq]
go
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
	    objra,
	    objdec,
	    dbo.fHtmEq(M.catalogra, M.catalogdec),
		dbo.fDistanceArcMinEq(@ra,@dec, M.catalogra, M.catalogdec)
	    FROM @htmTemp H join mastar_goodstars M
	             ON  (dbo.fHtmEq(M.objra, M.objdec) BETWEEN H.HtmIDstart AND H.HtmIDend )
	    AND dbo.fDistanceArcMinEq(@ra,@dec,
		M.catalogra, M.catalogdec) < @r
  RETURN
  END

GO


