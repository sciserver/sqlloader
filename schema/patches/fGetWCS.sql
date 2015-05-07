-- Patch to add function that extracts WCS info from Field and Run tables
-- (courtesy of Alex Szalay).

SELECT GETDATE()
GO
--
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetWCS]'))
	drop function [dbo].[fGetWCS]
GO
CREATE FUNCTION fGetWCS(@fieldid bigint)
-------------------------------------------------------------------------------
--/H Builds the relevant part of the FITS header with the WCS info
-------------------------------------------------------------------------------
--/T Input parameter is the fieldid
--/T <samp>
--/T       PRINT dbo.fGetWCS(1237671956445462528)
--/T <br>  SELECT TOP 10 dbo.fGetWCS( fieldid ) FROM Field
--/T </samp>
-------------------------------------------------------------------------------
RETURNS varchar(2000)
AS BEGIN
	DECLARE @out varchar(2000)
	SELECT @out  = '	NAXIS   =                    2
	NAXIS1  =                 2048
	NAXIS2  =                 1489
	ORIGIN  = ''SDSS    ''
	TELESCOP= ''2.5m    ''
	OBSERVER= ''observer''           / Observer
	EQUINOX =              2000.00 /	
	CTYPE1  = ''RA---TAN''           /Coordinate type
	CTYPE2  = ''DEC--TAN''           /Coordinate type
	CRPIX1  =        1025.00000000 /X of reference pixel
	CRPIX2  =        745.000000000 /Y of reference pixel';
	------------------------------------------
	-- append the ra and dec of the center
	------------------------------------------
	SELECT @out =  @out
			+CHAR(10)
			+'    CRVAL1  ='+STR(b.ra,22,10)
			+' /RA of reference pixel (deg)'
			+CHAR(10)
			+'    CRVAL2  ='+STR(b.dec,22,10)
			+' /Dec of reference pixel (deg)'
			+CHAR(10)
	FROM (
		SELECT	
			a_r+b_r*744.5+c_r*1024.5 mu,
			d_r+e_r*744.5+f_r*1024.5 nu,
			r.node, r.incl
		FROM Field f
		    JOIN Run r ON f.run=r.run
		WHERE 
		    f.fieldID=@fieldid
	) a CROSS APPLY dbo.fEqFromMuNu(mu,nu,node,incl) b
	--
	RETURN @out;
END
GO

