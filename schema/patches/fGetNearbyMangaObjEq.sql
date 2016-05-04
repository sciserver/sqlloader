-- Patch to create search functions for MaNGA objects.

--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearbyMangaObjEq' ) 
	DROP FUNCTION fGetNearbyMangaObjEq
GO
--
CREATE FUNCTION fGetNearbyMangaObjEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns table of MaNGA objects within @r arcmins of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> plateIFU varchar(20) NOT NULL,   -- MaNGA unique ID
--/T <li> mangaid varchar(20) NOT NULL,    -- MaNGA target id
--/T <li> objra float NOT NULL,            -- Right Ascension
--/T <li> objdec float NOT NULL,	   -- declination
--/T <li> ifura float NOT NULL,            -- Right Ascension
--/T <li> ifudec float NOT NULL,	   -- declination
--/T <li> drp3qual bigint NOT NULL,	   -- Quality bitmask
--/T <li> bluesn2 real NOT NULL, 	   -- Total blue SN2 across all nexp exposures
--/T <li> redsn2 real NOT NULL,	   -- Total red SN2 across all nexp exposures
--/T <li> mjdmax int NOT NULL,	   	   --/D Maximum MJD across all exposures
--/T <li> mngtarg1 bigint NOT NULL,	   --/D Manga-target1 maskbit for galaxy target catalog
--/T <li> mngtarg2 bigint NOT NULL,	   --/D Manga-target2 maskbit for galaxy target catalog
--/T <li> mngtarg3 bigint NOT NULL,	   --/D Manga-target3 maskbit for galaxy target catalog
--/T <li> htmID bigint NOT NULL		   -- Hierarchical Trangular Mesh id of this objetc
--/T <br> Sample call to find MaNGA object within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyMangaObjEq(180.0,-0.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearestMangaObjEq
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    plateIFU varchar(20) NOT NULL,
    mangaid varchar(20) NOT NULL,
    objra float NOT NULL,
    objdec float NOT NULL,
    ifura float NOT NULL,
    ifudec float NOT NULL,
    drp3qual bigint NOT NULL,
    bluesn2 real NOT NULL,
    redsn2 real NOT NULL,
    mjdmax int NOT NULL,
    mngtarg1 bigint NOT NULL,
    mngtarg2 bigint NOT NULL,
    mngtarg3 bigint NOT NULL,
    htmID bigint NOT NULL
  ) AS 
BEGIN
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);
	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleEq(@ra,@dec,@r)
	DECLARE @lim float;
	INSERT @proxtab	SELECT 
	    plateIFU, 
	    mangaid,
	    objra,
	    objdec,
	    ifura,
	    ifudec,
	    drp3qual,
	    bluesn2,
	    redsn2,
	    mjdmax,
	    mngtarg1,
	    mngtarg2,
	    mngtarg3,
	    htmID
	    FROM @htmTemp H join mangaDrpAll M
	             ON  (M.htmID BETWEEN H.HtmIDstart AND H.HtmIDend )
	    AND dbo.fDistanceArcMinEq(@ra,@dec,ifura,ifudec) < @r
  RETURN
  END
GO




--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fGetNearestMangaObjEq' ) 
	DROP FUNCTION fGetNearestMangaObjEq
GO
--
CREATE FUNCTION fGetNearestMangaObjEq (@ra float, @dec float, @r float)
-------------------------------------------------------------
--/H Returns nearest MaNGA object within @r arcmins of an equatorial point (@ra,@dec).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> plateIFU varchar(20) NOT NULL,      -- MaNGA unique ID
--/T <li> mangaid varchar(20) NOT NULL,       -- MaNGA target id
--/T <li> objra float NOT NULL,     -- Right Ascension
--/T <li> objdec float NOT NULL,    -- declination
--/T <li> ifura float NOT NULL,     -- Right Ascension
--/T <li> ifudec float NOT NULL,    -- declination
--/T <li> drp3qual bigint NOT NULL, -- Quality bitmask
--/T <li> bluesn2 real NOT NULL,   -- Total blue SN2 across all nexp exposures
--/T <li> redsn2 real NOT NULL,    -- Total red SN2 across all nexp exposures
--/T <li> mjdmax int NOT NULL,   --/D Maximum MJD across all exposures
--/T <li> mngtarg1 bigint NOT NULL, --/D Manga-target1 maskbit for galaxy target catalog
--/T <li> mngtarg2 bigint NOT NULL, --/D Manga-target2 maskbit for galaxy target catalog
--/T <li> mngtarg3 bigint NOT NULL, --/D Manga-target3 maskbit for galaxy target catalog
--/T <li> htmID bigint NOT NULL	    -- Hierarchical Trangular Mesh id of this object
--/T <br> Sample call to find MaNGA object within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearestMangaObjEq(180.0,-0.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyMangaObjEq
-------------------------------------------------------------
  RETURNS @proxtab TABLE (
    plateIFU varchar(20) NOT NULL,
    mangaid varchar(20) NOT NULL,
    objra float NOT NULL,
    objdec float NOT NULL,
    ifura float NOT NULL,
    ifudec float NOT NULL,
    drp3qual bigint NOT NULL,
    bluesn2 real NOT NULL,
    redsn2 real NOT NULL,
    mjdmax int NOT NULL,
    mngtarg1 bigint NOT NULL,
    mngtarg2 bigint NOT NULL,
    mngtarg3 bigint NOT NULL,
    htmID bigint NOT NULL
  ) AS 
BEGIN
	INSERT @proxtab	
	    SELECT TOP 1 *
	    FROM dbo.fGetNearbyMangaObjEq(@ra, @dec, @r) n
	    ORDER BY dbo.fDistanceArcMinEq(@ra, @dec, ifura, ifudec) ASC, n.bluesn2 DESC
  RETURN
  END
GO



