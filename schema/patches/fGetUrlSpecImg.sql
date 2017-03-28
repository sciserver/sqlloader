-- Patch to fix the specById file name in the URL - it's .ashx now, not .asp.

/****** Object:  UserDefinedFunction [dbo].[fGetUrlSpecImg]    Script Date: 01/12/2015 15:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--
ALTER FUNCTION [dbo].[fGetUrlSpecImg](@specObjID numeric(20,0))
------------------------------------------------------------------------
--/H  Returns the URL for a GIF image of the spectrum given the SpecObjID
--/T  <br> returns http://localhost/en/get/specById.asp?id=0x011fcb379dc00000
--/T  <br> where localhost is filled in from SiteConstants.WebServerURL.
--/T  <br> sample:<br> <samp>select dbo.fGetUrlSpecImg(0x011fcb379dc00000) </samp>
--/T  <br> see also fGetUrlFrame
------------------------------------------------------------------------
returns varchar(256)
	begin
	declare @WebServerURL varchar(500);
	set @WebServerURL = 'http://localhost/';
	select @WebServerURL = cast(value as varchar(500))
		from SiteConstants
		where name ='WebServerURL';
	return @WebServerURL + 'get/specById.ashx?id=' 
		+ cast(coalesce(@specObjId,0) as varchar(32))
	end
GO



EXECUTE spSetVersion
  0
  ,0
  ,'12'
  ,'160616'
  ,'Update DR'
  ,'.2'
  ,'Patch to fix fGetUrlSpecImg'
  ,'Fixed the specById filename in spec img URL'
  ,'A.Thakar'
Go

