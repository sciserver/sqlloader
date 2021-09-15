-- Patch to fix spectrum FITS path (DR14 onwards).

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--
ALTER FUNCTION [dbo].[fGetUrlFitsSpectrum](@specObjID numeric(20,0))
-------------------------------------------------
--/H Get the URL to the FITS file of the spectrum given the SpecObjID
-------------------------------------------------
--/T Combines the value of the DataServer URL from the
--/T SiteConstants table and builds up the whole URL
--/T from the specObjId.
--/T <br><samp> select dbo.fGetUrlFitsSpectrum(75094092974915584)</samp>
-------------------------------------------------
RETURNS varchar(128)
BEGIN
	DECLARE @link varchar(128), @plate varchar(8), @mjd varchar(8), 
	    @fiber varchar(8), @rerun varchar(16), @release varchar(8), 
	    @survey varchar(16), @oplate varchar(8), @ofiber varchar(8);
	SET @link = (SELECT value FROM SiteConstants WHERE name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SELECT @rerun = isnull(p.run2d, p.run1d), @survey = p.survey,
	    @mjd = cast(p.mjd as varchar(8)), @plate=cast(p.plate as varchar(8)), 
	    @fiber=cast(s.fiberID as varchar(8)) 
	    FROM PlateX p JOIN specObjAll s ON p.plateId=s.plateId 
	    WHERE s.specObjID=@specObjId;
	IF @survey != 'boss'
            SET @survey = 'sdss'
	ELSE
	    SET @survey = 'eboss'
	SET @oplate = substring('0000',1,4-len(@plate)) + @plate;
	SET @ofiber = substring( '0000',1,4-len(@fiber)) + @fiber;
	SET @link = @link + 'sas/dr' + @release + '/' + @survey + '/spectro/redux/' +
		@rerun + '/spectra/';
    IF @survey = 'eboss'
                SET @link = @link + 'full/';    -- path is different for eboss                                                                           
        SET @link = @link + @oplate + '/spec-' + @oplate + '-' + @mjd + '-' + @ofiber + '.fits';
 	RETURN @link;
END

GO


