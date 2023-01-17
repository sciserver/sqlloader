--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlFitsSpectrum]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlFitsSpectrum]
GO
--
CREATE FUNCTION fGetUrlFitsSpectrum(@specObjID numeric(20,0))
-------------------------------------------------
--/H Get the URL to the FITS file of the spectrum given the SpecObjID
-------------------------------------------------
--/T Combines the value of the DataServer URL from the
--/T SiteConstants table and builds up the whole URL
--/T from the specObjId.
--/T <br><samp> select dbo.fGetUrlFitsSpectrum(75094092974915584)</samp>
-------------------------------------------------
RETURNS varchar(256)
BEGIN
	DECLARE @link varchar(256), @plate varchar(8), @mjd varchar(8), 
	    @fiber varchar(8), @run2d varchar(16), @release varchar(8), 
	    @survey varchar(16), @oplate varchar(8), @ofiber varchar(8),
		@catid varchar(12), @ocatid varchar(12);
	DECLARE @iplate int, @imjd int, @ifiber int;
	SET @link = (SELECT value FROM SiteConstants WHERE name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SET @survey = 'sdss';	-- survey is always "sdss" as of DR18
	SELECT @iplate=plate, @imjd=mjd, @ifiber=fiber, @run2d=run2d FROM dbo.fSDSSfromSpecID(@specObjID)
	SET @link = @link + 'sas/dr' + @release + '/spectro/' + @survey + '/redux/' + @run2d + '/spectra/lite/';
	IF @iplate < 15000		-- pre-DR18 paths are derived from PlateX
		BEGIN
			SELECT @run2d = isnull(p.run2d, p.run1d), @survey = p.survey,
				@mjd = cast(p.mjd as varchar(8)), @plate=cast(p.plate as varchar(8)), 
				@fiber=cast(s.fiberID as varchar(8)) 
				FROM PlateX p JOIN specObjAll s ON p.plateId=s.plateId 
				WHERE s.specObjID=@specObjId
			IF len(@plate) > 4
				SET @oplate = @plate
			ELSE
				SET @oplate = substring('0000',1,4-len(@plate)) + @plate;
			SET @ofiber = substring( '0000',1,4-len(@fiber)) + @fiber;
			SET @link = @link + @oplate + '/spec-' + @oplate + '-' + @mjd + '-' + @ofiber + '.fits';
		END
	ELSE					-- post-DR18 paths are derived from spAll
		BEGIN		
			SELECT @catid = CAST(catalogid AS varchar(12)) FROM spAll WHERE specobjid = @specObjID;
			SET @ocatid = substring('00000000000',1,11-len(@catid)) + @catid;
			SET @plate = CAST( @iplate AS varchar(8) )
			SET @oplate = CONCAT( @plate, 'p')
			SET @mjd = CAST( @imjd AS varchar(8) )
			SET @fiber = CAST( @ifiber AS varchar(8) )
			SET @ofiber = substring( '0000',1,4-len(@fiber)) + @fiber;
			SET @link = @link + @oplate + '/' + @mjd + '/spec-' + @plate + '-' + @mjd + 
				'-' + @ocatid + '.fits';
		END

--		@run2d + '/spectra/' + @oplate + '/spec-' + @oplate + '-' + 
--		@mjd + '-' + @ofiber + '.fits';
	RETURN @link;
END
GO


