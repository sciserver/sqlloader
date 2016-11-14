--=========================================================================
--   spUrlFitsSupport.sql
--   2001-11-01 Alex Szalay
---------------------------------------------------------------------------
-- History:
--* 2001-11-07 Alex: changed names for fGetFieldsObjects to spGet... 
--*		and fGetFiberList to spGetFiberList
--* 2001-12-02 Alex: moved Globe table to ZoomTables.sql, now this is
--*		functions and procedures only, also fixed bug in spGetFiberList
--* 2001-12-08 Jim: moved *Near* functions to *Near* file.
--* 2001-12-23 Alex: Added a whole bunch of Url functions, and MagToFlux conversions.
--* 2002-07-15 Alex: added or revised 	fGetUrlSpecImg, fGetUrlNavId,fGetUrlNavEq,
--*		fGetUrlFitsSpectrum,fGetUrlFitsAtlas, fGetUrlFitsBin, fGetUrlFitsMask, 
--*		fGetUrlFitsCFrame, fGetUrlFitsField,
--* 2002-07-31 Jim: fixed bug in fMjdToGmt (off by 12 hours).
--* 2002-09-14 Jim+Alex+Ani: Moved spatial functions to NearFunctions.sql 
--* 2002-09-26 Alex: Commented out fGetFieldsObjects, since there is no specObjID in PhotoObj any more
--* 2003-02-05 Alex: fixed URL construction in support functions
--* 2003-02-06 Ani: Removed "en/" from URLs so it will be compatible with all
--*		     subdirectories (e.g. v4).
--*		     Updated spSkyServerFunctions to include SPs.
--*		     Changed "imagingRoot" to "imaging" for image FITS URLs
--*		     Changed "spectroRoot" to "spectro" for spSpec URLs
--*		     Changed "1d_10" to "1d_20" for spSpec URLs
--* 2003-05-15 Alex: switched from PhotoObj to PhotoObjAll
--* 2003-06-03 Alex: Changed count(*) to count_big(*) and @@rowcount to rowcount_big();
--*		Moved fMagToFlux* functions to photoTables.sql
--* 2003-10-06 Ani: Fixed URL problem with fGetUrlFitsField (PR #5617).
--* 2003-12-18 Ani: Fix for PR #5809: str()s for ra,dec in fGetUrl*Eq
--*             functions enclosed in ltrim() to remove spaces. 
--*             Also changed "1d_20" to "1d_23" for fGetUrlFitsSpectrum.
--* 2003-12-19 Ani: Fix for PR #5811 (fGetUrlNavEq).
--* 2003-12-22 Ani: Also fixed fGetUrlNavId for same thing as 5811.
--* 2004-09-01 Nolan+Alex: added spExecuteSQL2
--* 2005-02-15 Ani: Added check for crawlers limiting them to x queries/min, 
--*            SQL code for this provided by Jim.
--* 2005-02-18 Ani: Commented out "SET @IOs = ..." line in spExecuteSQL and
--*            spExecuteSQL2 because it was cause arithmetic overflow errors
--*            on DR3 sites (PR #6367).
--* 2005-02-21 Ani: Applied permanent fix for PR #6367 by including casts to
--*            bigint for @@TOTAL_READ and @@TOTAL_WRITE.
--* 2005-02-25 Ani: Added minute-long window to check whether a given
--*            clientIP is submitting more than the max number of queries
--*            in spExecuteSQL.  This is to allow legitimate rapid-fire
--*            queries like RHL's skyserver lookup tables to work fine.
--* 2005-11-28 Ani: Fix for PR #6496, added a STR before cast to VARCHAR
--*            in sec field for fMJDToGMT.
--* 2006-03-07 Ani: Added procedure spSetWebServerUrl to set WebServerUrl in
--*            SiteConstants.
--* 2006-12-27 Alex: separated out the URL and FITS support into 
--*            spUrlFitsSupport.sql
--* 2006-03-07 Ani: Fix for PR #7342, specobj fits link broken due to change
--*            in sp rerun for DR6.  Modified fGetUrlFitsSpectrum to take
--*            the rerun# from the PlateX table so this will not break in 
--*            the future.
--* 2008-08-29 Ani: Fix for PR #7652, DAS URLs for coadd runs not correct in
--*            Stripe 82 DB.
--* 2008-09-18 Ani: Additional changes for PR #7652.
--* 2010-08-24 Ani: Fixed spGetFiberList to use class instead of specClass,
--*            and fixed fGetUrlFitsSpectrum to use ANSI SQL syntax amd to
--*            use run1d,run2d instead of spRerun.
--* 2010-10-28 Naren: Fixed fGetUrlFitsSpectrum to use run1d if run2d is null.
--* 2011-02-11 Weaver: Fixed URLs for data.sdss3.org files.
--* 2011-07-21 Ani: Replaced Segment with Run in fGetUrlFitsField.
--* 2011-07-25 Weaver: Added fGetUrlFitsPlate to return link to spPlate file
--* 2012-06-19 Weaver: Changed URLs for new directory tree layout.
--* 2012-07-18 Ani: Removed startMu from fGetUrlFitsField.
--* 2012-07-25 Ani: Modified fGetUrlFitsField to return photoObj file
--*            instead of photoField file, as instructed by MB.  Also
--*            modified fGetUrlFitsSpectrum to use 4-digit fiber number
--*            (0-padded) instead of 3.
--* 2013-10-30 Ani: Modified fMJDtoGMT to pad all fields with leading
--*            zeros and reduce precision of seconds to 3 decimal places.
--* 2015-01-15 Ani: Updated specById file name in fGetUrlSpecImg.
<<<<<<< HEAD
--*
--* 2016-11-14 Sue: added order by s.FiberID to spGetFiberList
=======
--* 2016-07-29 Ani: Replaced "boss" with "eboss" for SAS file paths.
--* 2016-07-30 Ani: Added fGetUrlMangaCube to return MaNGA data cube URL.
>>>>>>> origin/master
---------------------------------------------------------------------------
SET NOCOUNT ON;
GO 


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetUrlExpEq' )
	DROP FUNCTION fGetUrlExpEq
GO
-- 
CREATE FUNCTION fGetUrlExpEq(@ra float, @dec float)
------------------------------------------------------------------------
--/H  Returns the URL for an ra,dec, measured in degrees.
--/T  <br> returns http://localhost/en/tools/explore/obj.asp?ra=185.000000&dec=0.00000000
--/T  <br> where localhost is filled in from SiteConstants.WebServerURL.
--/T  <br> sample:<br> <samp>select dbo.fGetUrlExpEq(185,0) </samp>
--/T  <br> see also fGetUrlNavEq, fGetUrlNavId, fGetUrlExpId
------------------------------------------------------------------------
returns varchar(256)
	begin
	declare @WebServerURL varchar(500);
	set @WebServerURL = 'http://localhost/';
	select @WebServerURL = cast(value as varchar(500))
		from SiteConstants
		where name ='WebServerURL';
	return @WebServerURL + 'tools/explore/obj.asp?ra=' 
		+ ltrim(str(@ra,10,6)) + '&dec=' + ltrim(str(@dec,10,6))
	end
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetUrlExpId' )
	DROP FUNCTION fGetUrlExpId
GO
-- 
CREATE FUNCTION fGetUrlExpId(@objId bigint)
--------------------------------------------
--/H Returns the URL for an Photo objID.
---------------------------------------------
--/T  <br> returns http://localhost/en/tools/explore/obj.asp?id=2255029915222048
--/T  <br> where localhost is filled in from SiteConstants.WebServerURL.
--/T  <br> sample:<br><samp> select dbo.fGetUrlExpId(2255029915222048) </samp>
--/T  <br> see also fGetUrlNavEq, fGetUrlNavId, fGetUrlExpEq
--------------------------------------------
returns varchar(256)
	begin
	declare @WebServerURL varchar(500);
	declare @ra float;
	declare @dec float;
	set @ra = 0
	set @dec = 0;
	set @WebServerURL = 'http://localhost/';
	select @WebServerURL = cast(value as varchar(500))
		from SiteConstants where name ='WebServerURL'; 
	select @ra = ra, @dec = dec
	from PhotoObjAll
	where objID = @objId;
	return @WebServerURL +'tools/explore/obj.asp?id=' 
		+ cast(@objId as varchar(32))
	end
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetUrlFrameImg' )
	DROP FUNCTION fGetUrlFrameImg
GO
-- 
CREATE FUNCTION fGetUrlFrameImg(@frameId bigint, @zoom int)
------------------------------------------------------------------------
--/H  Returns the URL for a JPG image of the frame
--/T  <br> returns http://localhost/en/get/frameById.asp?id=568688299147264
--/T  <br> where localhost is filled in from SiteConstants.WebServerURL.
--/T  <br> @zoom is an integer from (0,10,15,20,30) corresponding to a
--/T  rescaling of 2^(0.1*@zoom)
--/T  <br> sample:<br> <samp>select dbo.fGetUrlSpecImg(568688299147264,10) </samp>
--/T  <br> see also fGetUrlFrame
------------------------------------------------------------------------
returns varchar(256)
	begin
	declare @WebServerURL varchar(500);
	set @WebServerURL = 'http://localhost/';
	select @WebServerURL = cast(value as varchar(500))
		from SiteConstants
		where name ='WebServerURL';
	return @WebServerURL + 'get/frameById.asp?id=' 
		+ cast(@frameId as varchar(32))
		+ '&zoom=' + cast(@zoom as varchar(6))
	end
GO


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spGetFiberList' )
	DROP PROCEDURE spGetFiberList
GO
-- 
CREATE PROCEDURE spGetFiberList (@plateid bigint)
-------------------------------------------------
--/H Return a list of fibers on a given plate.
-------------------------------------------------
AS 
	select cast(s.specObjID as varchar(20)), s.fiberId, s.class, str(s.z,5,3), s.bestobjid 
	from SpecObjAll s
	where
		plateID=@plateid
		order by s.fiberID;
GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlFitsField]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlFitsField]
GO
--
CREATE FUNCTION fGetUrlFitsField(@fieldId bigint)
-------------------------------------------------
--/H Given a FieldID returns the URL to the FITS file of that field 
-------------------------------------------------
--/T Combines the value of the DataServer URL from the
--/T SiteConstants table and builds up the whole URL 
--/T <br><samp> select dbo.fGetUrlFitsField(568688299343872)</samp>
-------------------------------------------------
RETURNS varchar(256)
BEGIN
	DECLARE @link varchar(256), @run varchar(8), @rerun varchar(8),
		@run6 varchar(10), @stripe varchar(8), @camcol varchar(8), 
		@field varchar(8), @skyVersion varchar(8),
		@dbType varchar(32), @release varchar(8);

	SET @link = (select value from SiteConstants where name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SET @dbType = (select value from SiteConstants where name='DB Type');
	--SET @link = @link + 'imaging/';
	SET @link = @link + 'sas/dr' + @release + '/eboss/photoObj/';
	SELECT @skyVersion=cast(dbo.fSkyVersion(@fieldid) as varchar(8));
	SELECT  @run = cast(f.run as varchar(8)), 
		@rerun=cast(f.rerun as varchar(8)), 
		@stripe=cast(s.[stripe] as varchar(8)),
		@camcol=cast(f.camcol as varchar(8)), 
		@field=cast(f.field as varchar(8))
	    FROM Field f, Run s
	    WHERE f.fieldId=@fieldId and s.run = f.run; 
	IF (@dbType LIKE 'Stripe 82%') AND @run IN ('106','206')
	    BEGIN
	    	-- kludge for coadd runs, which were changed for CAS since the
	    	-- run numbers did not fit in 16 bits (smallint)
	    	SET @run6 = substring(@run,1,1) + '000' + substring(@run,2,2);
		SET @run = @run6;
	    END
	ELSE
	    SET @run6   = substring('000000',1,6-len(@run)) + @run;
	SET @link = @link + @rerun + '/';
	IF (@skyVersion = '0')
	    SET @link = @link + 'inchunk_target/';
	ELSE IF (@skyVersion = '1')
	    SET @link = @link + 'inchunk_best/';
	ELSE
	    SET @link = @link + @run + '/' + @camcol + '/';
	SET @field = substring('0000',1,4-len(@field)) + @field;
	IF (@skyVersion = '15')
	    SET @link = @link + @rerun + '/calibChunks/';
	RETURN @link+'photoObj-'+@run6+'-'+@camcol+'-'+@field+'.fits';
END
GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlFitsCFrame]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlFitsCFrame]
GO
--
CREATE FUNCTION fGetUrlFitsCFrame(@fieldId bigint, @filter varchar(4))
-------------------------------------------------
--/H Get the URL to the FITS file of a corrected frame given the fieldID and band
-------------------------------------------------
--/T Combines the value of the DataServer URL from the
--/T SiteConstants table and builds up the whole URL
--/T from the fieldId (and a u, g, r, i or z filter)
--/T <br><samp> select dbo.fGetUrlFitsCFrame(568688299343872,'r')</samp>
-------------------------------------------------
RETURNS varchar(256)
BEGIN
	DECLARE @link varchar(256), @run varchar(8), @rerun varchar(8),
		@camcol varchar(8), @field varchar(8), @run6 varchar(10),
		@dbType varchar(32), @release varchar(8);
	SET @link = (select value from SiteConstants where name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SET @dbType = (select value from SiteConstants where name='DB Type');
	--SET @link = @link + 'imaging/';
	SET @link = @link + 'sas/dr' + @release + '/eboss/photoObj/frames/';
	SELECT  @run = cast(run as varchar(8)), @rerun=cast(rerun as varchar(8)), 
		@camcol=cast(camcol as varchar(8)), @field=cast(field as varchar(8))
	    FROM Field
	    WHERE fieldId=@fieldId;
	IF (@dbType LIKE 'Stripe 82%') AND @run IN ('106','206')
	    BEGIN
	    	-- kludge for coadd runs, which were changed for CAS since the
	    	-- run numbers did not fit in 16 bits (smallint)
	    	SET @run6 = substring(@run,1,1) + '000' + substring(@run,2,2);
		SET @run = @run6;
	    END
	ELSE
	    SET @run6   = substring('000000',1,6-len(@run)) + @run;
	SET @field = substring('0000',1,4-len(@field)) + @field;
	--RETURN 	 @link + @run + '/' + @rerun + '/corr/'+@camcol+'/fpC-'+@run6+'-'+@filter+@camcol+'-'+@field+'.fit.gz';
	RETURN 	 @link + @rerun + '/' + @run + '/' +@camcol+'/frame-'+@filter+'-'+@run6+'-'+@camcol+'-'+@field+'.fits.bz2';
END
GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlFitsMask]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlFitsMask]
GO
--
CREATE FUNCTION fGetUrlFitsMask(@fieldId bigint, @filter varchar(4))
-------------------------------------------------
--/H Get the URL to the FITS file of a frame mask given the fieldID and band
-------------------------------------------------
--/T Combines the value of the DataServer URL from the
--/T SiteConstants table and builds up the whole URL
--/T from the fieldId (and a u, g, r, i or z filter)
--/T <br><samp> select dbo.fGetUrlFitsMask(568688299343872,'r')</samp>
-------------------------------------------------
RETURNS varchar(256)
BEGIN
	DECLARE @link varchar(256), @run varchar(8), @rerun varchar(8),
		@camcol varchar(8), @field varchar(8), @run6 varchar(10),
		@dbType varchar(32), @release varchar(8);

	SET @link = (select value from SiteConstants where name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SET @dbType = (select value from SiteConstants where name='DB Type');
	--SET @link = @link + 'imaging/';
	SET @link = @link + 'sas/dr' + @release + '/eboss/photo/redux/';
	SELECT  @run = cast(run as varchar(8)), @rerun=cast(rerun as varchar(8)), 
		@camcol=cast(camcol as varchar(8)), @field=cast(field as varchar(8))
	    FROM Field
	    WHERE fieldId=@fieldId;
	IF (@dbType LIKE 'Stripe 82%') AND @run IN ('106','206')
	    BEGIN
	    	-- kludge for coadd runs, which were changed for CAS since the
	    	-- run numbers did not fit in 16 bits (smallint)
	    	SET @run6 = substring(@run,1,1) + '000' + substring(@run,2,2);
		SET @run = @run6;
	    END
	ELSE
	    SET @run6   = substring('000000',1,6-len(@run)) + @run;
	SET @field = substring('0000',1,4-len(@field)) + @field;
	--RETURN 	 @link + @run + '/' + @rerun + '/objcs/'+@camcol+'/fpM-'+@run6+'-'+@filter+@camcol+'-'+@field+'.fit';
	RETURN 	 @link + @rerun + '/' + @run + '/objcs/'+@camcol+'/fpM-'+@run6+'-'+@filter+@camcol+'-'+@field+'.fit.gz';
END
GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlFitsBin]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlFitsBin]
GO
--
CREATE FUNCTION fGetUrlFitsBin(@fieldId bigint, @filter varchar(4))
-------------------------------------------------
--/H Get the URL to the FITS file of a binned frame given FieldID and band.
-------------------------------------------------
--/T Combines the value of the DataServer URL from the
--/T SiteConstants table and builds up the whole URL
--/T from the fieldId (and a u, g, r, i or z filter)
--/T <br><samp> select dbo.fGetUrlFitsBin(568688299343872,'r')</samp>
-------------------------------------------------
RETURNS varchar(256)
BEGIN
	DECLARE @link varchar(256), @run varchar(8), @rerun varchar(8),
		@camcol varchar(8), @field varchar(8), @run6 varchar(10),
		@dbType varchar(32), @release varchar(8);

	SET @link = (select value from SiteConstants where name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SET @dbType = (select value from SiteConstants where name='DB Type');
	--SET @link = @link + 'imaging/';
	SET @link = @link + 'sas/dr' + @release + '/eboss/photo/redux/';
	SELECT  @run = cast(run as varchar(8)), @rerun=cast(rerun as varchar(8)), 
		@camcol=cast(camcol as varchar(8)), @field=cast(field as varchar(8))
	    FROM Field
	    WHERE fieldId=@fieldId;
	IF (@dbType LIKE 'Stripe 82%') AND @run IN ('106','206')
	    BEGIN
	    	-- kludge for coadd runs, which were changed for CAS since the
	    	-- run numbers did not fit in 16 bits (smallint)
	    	SET @run6 = substring(@run,1,1) + '000' + substring(@run,2,2);
		SET @run = @run6;
	    END
	ELSE
	    SET @run6   = substring('000000',1,6-len(@run)) + @run;
	SET @field = substring('0000',1,4-len(@field)) + @field;
	--RETURN 	 @link + @run + '/' + @rerun + '/objcs/'+@camcol+'/fpBIN-'+@run6+'-'+@filter+@camcol+'-'+@field+'.fit';
	RETURN 	 @link + @rerun + '/' + @run + '/objcs/'+@camcol+'/fpBIN-'+@run6+'-'+@filter+@camcol+'-'+@field+'.fit.gz';
END
GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlFitsAtlas]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlFitsAtlas]
GO
--
CREATE FUNCTION fGetUrlFitsAtlas(@fieldId bigint)
-------------------------------------------------
--/H Get the URL to the FITS file of all atlas images in a field
-------------------------------------------------
--/T Combines the value of the DataServer URL from the
--/T SiteConstants table and builds up the whole URL
--/T from the fieldId  
--/T <br><samp> select dbo.fGetUrlFitsAtlas(568688299343872)</samp>
-------------------------------------------------
RETURNS varchar(256)
BEGIN
	DECLARE @link varchar(256), @run varchar(8), @rerun varchar(8),
		@camcol varchar(8), @field varchar(8), @run6 varchar(10),
		@dbType varchar(32), @release varchar(8);
	SET @link = (select value from SiteConstants where name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SET @dbType = (select value from SiteConstants where name='DB Type');
	--SET @link = @link + 'imaging/';
	SET @link = @link + 'sas/dr' + @release + '/eboss/photo/redux/';
	SELECT  @run = cast(run as varchar(8)), @rerun=cast(rerun as varchar(8)), 
		@camcol=cast(camcol as varchar(8)), @field=cast(field as varchar(8))
	    FROM Field
	    WHERE fieldId=@fieldId;
	IF (@dbType LIKE 'Stripe 82%') AND @run IN ('106','206')
	    BEGIN
	    	-- kludge for coadd runs, which were changed for CAS since the
	    	-- run numbers did not fit in 16 bits (smallint)
	    	SET @run6 = substring(@run,1,1) + '000' + substring(@run,2,2);
		SET @run = @run6;
	    END
	ELSE
	    SET @run6   = substring('000000',1,6-len(@run)) + @run;
	SET @field = substring('0000',1,4-len(@field)) + @field;
	--RETURN 	 @link + @run + '/' + @rerun + '/objcs/'+@camcol+'/fpAtlas-'+@run6+'-'+@camcol+'-'+@field+'.fit';
	RETURN 	 @link + @rerun + '/' + @run + '/objcs/'+@camcol+'/fpAtlas-'+@run6+'-'+@camcol+'-'+@field+'.fit';
END
GO


--===================================================================
--if exists (select * from dbo.sysobjects 
--	where id = object_id(N'[dbo].[fGetUrlAtlasImageId]') 
--	and xtype in (N'FN', N'IF', N'TF'))
--	drop function [dbo].[fGetUrlAtlasImageId]
--GO
--
--CREATE FUNCTION fGetUrlAtlasImageId(@objId bigint, @rowc int, @colc int)
-------------------------------------------------
--/H Get the Atlas Image Server URL to the FITS file for a given atlas image
-------------------------------------------------
--/T Combines the value of the Atlas Image Server URL from the
--/T SiteConstants table and builds up the whole URL from other
--/T quantities in PhotoObjAll for the given objID, rowc and colc.  
--/T <br><samp> select dbo.fGetUrlAtlasImageId(568688299343872)</samp>
-------------------------------------------------
--RETURNS varchar(128)
--BEGIN
--	DECLARE @link varchar(128), @run varchar(8), @rerun varchar(8),
--		@camcol varchar(8), @field varchar(8);
--	SELECT @link=value from SiteConstants where name='AtlasImageServerURL';
--	SET @link = 'http://das.sdss.org/cbs/getAtlasImage.pl?';
--	SELECT  @run = ltrim(str(run)), @rerun=ltrim(str(rerun)), 
--		@camcol=ltrim(str(camcol)), @field=ltrim(str(field))
--	FROM dbo.fSDSSfromObjID( @objID )
--	RETURN 	 @link + '?run=' + ltrim(str(dbo.fRun(@objID)))
--		 + '&rerun=' + ltrim(str(dbo.fRerun(@rerun))) + '&camcol='+@camcol+'field='+@field
--		 + '&rowc=' + str(@rowc) + '&colc=' + str(colc);
--END
--GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlFitsPlate]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlFitsPlate]
GO
--
CREATE FUNCTION fGetUrlFitsPlate(@specObjId bigint)
-------------------------------------------------
--/H Get the URL to the spPlate FITS file containing the spectrum given the SpecObjID
-------------------------------------------------
--/T Combines the value of the DataServer URL from the
--/T SiteConstants table and builds up the whole URL
--/T from the specObjId.
--/T <br><samp> select dbo.fGetUrlFitsPlate(75094092974915584)</samp>
-------------------------------------------------
RETURNS varchar(128)
BEGIN
	DECLARE @link varchar(128), @plate varchar(4), @oplate varchar(4), 
	    @mjd varchar(5), @rerun varchar(16), @release varchar(8), @survey varchar(16);
	SET @link = (SELECT value FROM SiteConstants WHERE name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SELECT @rerun = isnull(p.run2d, p.run1d), @survey = p.survey,
	    @mjd = cast(p.mjd as varchar(5)), @plate=cast(p.plate as varchar(4)) 
	    FROM PlateX p JOIN specObjAll s ON p.plateId=s.plateId 
	    WHERE s.specObjID=@specObjId;
    IF @survey != 'boss'
        SET @survey = 'sdss'
    ELSE 
        SET @survey = 'eboss'
    SET @link = @link + 'sas/dr' + @release + '/' + @survey + '/spectro/redux/' +
		@rerun + '/';
    SET @oplate = substring('0000',1,4-len(@plate)) + @plate;
    SET @link = @link + @oplate + '/';
    SET @link = @link + 'spPlate-' + @oplate + '-' + @mjd + '.fits';
    RETURN @link;
END
GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlFitsSpectrum]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlFitsSpectrum]
GO
--
CREATE FUNCTION fGetUrlFitsSpectrum(@specObjId bigint)
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
		@rerun + '/spectra/' + @oplate + '/spec-' + @oplate + '-' + 
		@mjd + '-' + @ofiber + '.fits';
	RETURN @link;
END
GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlMangaCube]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlMangaCube]
GO
--
CREATE FUNCTION fGetUrlMangaCube(@plateIFU VARCHAR(20), @type VARCHAR(3))
-------------------------------------------------
--/H Get the URL of the MaNGA data cube of the specified type (LIN/LOG)
-------------------------------------------------
--/T Combines the value of the DataServer URL from the SiteConstants
--/T table and builds up the whole URL from the plateIFU and data cube
--/T type ('LIN' or 'LOG'), along with the version string (versdp3 from
--/T the mangaDrpAll entry.
--/T <br><samp> select TOP 10 dbo.fGetUrlMangaCube(plateIFU,'LIN') 
--/T            FROM mangaDrpAll </samp>
-------------------------------------------------
RETURNS varchar(128)
BEGIN
	DECLARE @link varchar(128), @vers VARCHAR(20), 
	    @release varchar(8), @plate INT;
	SET @link = (SELECT value FROM SiteConstants WHERE name='DataServerURL');
	SET @release = (select value from SiteConstants where name='Release');
	SELECT @plate=plate, @vers = versdrp3
	    FROM mangaDrpAll
	    WHERE plateIFU=@plateIFU;
	SET @link = @link + 'sas/dr' + @release + '/manga/spectro/redux/' +
		@vers + '/' + CAST(@plate as VARCHAR) + '/stack/manga-' + 
		@plateIFU + '-' + UPPER(@type) + 'CUBE.fits.gz';
	RETURN @link;
END
GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlNavEq]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlNavEq]
GO
--
CREATE FUNCTION fGetUrlNavEq(@ra float, @dec float)
------------------------------------------------------------------------
--/H  Returns the URL for an ra,dec, measured in degrees.
--/T  <br> gets the URL of the navigator frame containing the given ra,dec (in degrees)
--/T  <br> returns http://localhost/en/tools/navi/getFrame.asp?zoom=1&ra=185.000000&dec=0.00000000
--/T  <br> where localhost is filled in from SiteConstants.WebServerURL.
--/T  <br> sample:<br> <samp>select dbo.fGetUrlNavEq(185,0) </samp>
--/T  <br> see also fGetUrlNavId, fGetUrlExpEq, fGetUrlExpId
------------------------------------------------------------------------
returns varchar(256)
	begin
	declare @WebServerURL varchar(500);
	set @WebServerURL = 'http://localhost/';
	select @WebServerURL = cast(value as varchar(500))
		from SiteConstants
		where name ='WebServerURL';
	return @WebServerURL + 'tools/chart/navi.asp?zoom=1&ra=' 
		+ ltrim(str(@ra,10,6)) + '&dec=' + ltrim(str(@dec,10,6))
	end

GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlNavId]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlNavId]
GO
--
CREATE FUNCTION fGetUrlNavId(@objId bigint)
--------------------------------------------
--/H Returns the Navigator URL for an Photo objID.
---------------------------------------------
--/T  <br> returns http://localhost/en/tools/navi/getFrame.asp?zoom=1&ra=184.028935&dec=-1.1259095
--/T  <br> where localhost is filled in from SiteConstants.WebServerURL.
--/T  <br> sample:<br><samp> select dbo.fGetUrlId(2255029915222048) </samp>
--/T  <br> see also fGetUrlNavEq, fGetUrlExpEq, fGetUrlExpId
--------------------------------------------
returns varchar(256)
	begin
	declare @WebServerURL varchar(500);
	declare @ra float;
	declare @dec float;
	set @ra = 0
	set @dec = 0;
	set @WebServerURL = 'http://localhost/';
	select @WebServerURL = cast(value as varchar(500))
		from SiteConstants where name ='WebServerURL'; 
	select @ra = ra, @dec = dec
	from PhotoObjAll
	where objID = @objId;
	return @WebServerURL +'tools/chart/navi.asp?zoom=1&ra=' 
		+ ltrim(str(@ra,10,10)) + '&dec=' + ltrim(str(@dec,10,10))
	end

GO


--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fGetUrlSpecImg]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fGetUrlSpecImg]
GO
--
CREATE FUNCTION fGetUrlSpecImg(@specObjId bigint)
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



--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spSetWebServerUrl' )
	DROP PROCEDURE spSetWebServerUrl
GO
--
CREATE PROCEDURE spSetWebServerUrl( @siteName VARCHAR(32) )
------------------------------------------------------
--/H Set the WebServerUrl value in SiteConstants based on the given site name. 
--
--/T The WebServerUrl in the SiteConstants table is set to:
--/T           'http://cas.sdss.org/'+@siteName+'/en/'
--/T e.g.,
--/T           'http://cas.sdss.org/dr5/en/' 
--/T when @siteName = 'dr5'.
------------------------------------------------------
AS BEGIN
    UPDATE SiteConstants
	SET value='http://cas.sdss.org/collabdr5/en/'
	WHERE [name]='WebServerUrl'
    PRINT 'WebServerUrl set to http://cas.sdss.org/'+@siteName+'/en/'
END
GO
--


--=================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fMJDToGMT' )
	DROP FUNCTION fMJDToGMT
GO
--
CREATE FUNCTION fMJDToGMT(@mjd float)
-------------------------------------------------------------- 
--/H Computes the String of a Modified Julian Date. 
-------------------------------------------------------------------------------
--/T From http://serendipity.magnet.ch/hermetic/cal_stud/jdn.htm 
--/T String has the format yyyy-mm-dd:hh:mm:ss.sssss 
--/T <PRE>select dbo.fMjdToGMT(49987.0)</PRE>
-- 
-- test cases
-- select dbo.fMjdToGMT(0)     		-- 1858-11-17:0:0:0
-- select dbo.fMjdToGMT(0.5)   		-- 1858-11-17:12:0:0
-- select dbo.fMjdToGMT(15020)   	-- 1900-1-1:0:0:0
-- select dbo.fMjdToGMT(51543)   	-- 1999-12-31:0:0:0
-- select dbo.fMjdToGMT(51544)   	-- 2000-1-1:0:0:0
-- select dbo.fMjdToGMT(99999) 		-- 2132-8-31:0:0:0
-- select dbo.fMjdToGMT(99999.5) 	-- 2132-8-31:12:0:0
-- select dbo.fMjdToGMT(100000)		-- 2132-9-1:0:0:0
-- change history: fixed "off by 12 hours" bug  2002-8-9
----------------------------------------------------------------
RETURNS varchar(32)
AS BEGIN 
    DECLARE @jd int, @l int, @n int,@i int, @j int,
	    @rem real, @days bigint, @d int ,@m int,
	    @y int, @hr int, @min int, @sec float; 
    SET @jd = @mjd + 2400000.5 + .5   -- convert from MDJ to JD  (the .5 fudge makes it work).
    SET @l = @jd + 68569; 
    SET @n = ( 4 * @l ) / 146097;
    SET @l = @l - ( 146097 * @n + 3 ) / 4;
    SET @i = ( 4000 * ( @l + 1 ) ) / 1461001 ;
    SET @l = @l - ( 1461 * @i ) / 4 + 31 ;
    SET @j = ( 80 * @l ) / 2447;
    SET @d = (@l - ( 2447 * @j ) / 80);  
    SET @l = @j / 11;
    SET @m = @j + 2 - ( 12 * @l );
    SET @y = 100 * ( @n - 49 ) + @i + @l;
    SET @rem =  @mjd - floor(@mjd) -- extract hh:mm:ss.sssssss  
    SET @hr = 24*@rem 
    SET @min = 60*(24*@rem -@hr) 
    SET @sec = 60*(60*(24*@rem -@hr)-@min) 
    RETURN (cast(@y as varchar(4)) + '-' + 
                right('00'+cast(@m as varchar(2)),2) + '-' + 
                right('00'+cast(@d as varchar(2)),2) + ' ' + 
                right('00'+cast(@hr as varchar(2)),2) + ':' + 
                right('00'+cast(@min as varchar(2)),2) + ':' + 
                right('000000'+ltrim(cast(str(@sec,5,3) as varchar(6))),6)); 
END 
GO

--
Print '[spUrlFitsSupport.sql]: URL and FITS support procs and functions created.'

