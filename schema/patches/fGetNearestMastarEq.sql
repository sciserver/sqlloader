USE [BestDR15]
GO


drop function if exists [dbo].[fGetNearestMastarEq] 
go
--
CREATE FUNCTION [dbo].[fGetNearestMastarEq] (@ra float, @dec float, @r float)


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

/*
select * from [dbo].[fGetNearbyMaStarObjEq](38.7, 47.4, 1)
select * from dbo.[fGetNearestMastarEq](38.7, 47.4, 1)
*/

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
		order by dbo.fDistanceArcMinEq(@ra, @dec, n.objra, n.objdec) ASC
	RETURN
  END
GO


