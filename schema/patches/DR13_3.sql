-- Replace the spSetVersion procedure
--==================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSetVersion]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spSetVersion]
GO
--
CREATE PROCEDURE spSetVersion(@taskid int, @stepid int,
		@release varchar(8)='4', 
		@dbversion varchar(128)='v4_18', 
		@vname varchar(128)='Initial version of DR', 
		@vnum varchar(8)='.0',
                @vdesc varchar(128)='Incremental load',
                @vtext varchar(4096)=' ',
		@vwho varchar(128) = ' ')
---------------------------------------------------
--/H Update the checksum and set the version info for this DB.
--/A -------------------------------------------------
--/T 
--/T 
--/T 
--/T 
---------------------------------------------------
AS
BEGIN
	-- Check schema skew
	EXEC spCheckDBObjects
	EXEC spCheckDBColumns
	EXEC spCheckDBIndexes

	-- Update statistics for all tables
	EXEC spUpdateStatistics

	-- generate diagnostics and checksum
	EXEC spMakeDiagnostics
	EXEC spUpdateSkyServerCrossCheck
	EXEC spCompareChecksum

	DECLARE @curtime VARCHAR(64), @prev VARCHAR(32)

	SET @curtime=CAST( GETDATE() AS VARCHAR(64) );

	-- update SiteConstants table
        UPDATE siteconstants SET value='http://dr'+@release+'.sdss.org/' WHERE name='DataServerURL'
        UPDATE siteconstants SET value='http://skyserver.sdss.org/dr'+@release+'/en/' WHERE name='WebServerURL'
        UPDATE siteconstants SET value=@release+@vnum WHERE name='DB Version'
        UPDATE siteconstants SET value=@dbversion WHERE name='Schema Version'
        UPDATE siteconstants SET value='DR'+@release+' SkyServer' WHERE name='DB Type'
        UPDATE siteconstants SET comment='from Data Release '+@release+' of the Sloan Digital Sky Survey (http://www.sdss.org/dr'+@release+'/).' WHERE name='Description'

        -- get checksum from site constants and add new entry to Versions       
        DECLARE @checksum VARCHAR(64)
        SELECT @checksum=value FROM siteconstants WHERE [name]='Checksum'
        SELECT TOP 1 @prev=version from Versions order by convert (datetime,[when]) desc

	-- get checksum from site constants and add new entry to Versions
	SELECT @checksum=value FROM siteconstants WHERE [name]='Checksum'
	SELECT TOP 1 @prev=version from Versions order by convert (datetime,[when]) desc

	-- update Versions table with latest version
	INSERT Versions
		VALUES( @vname+@release,@prev,@checksum,@release+@vnum,
			@vdesc, @vtext, @vwho, @curtime)
END
GO




-- Drop META FK indices before 
EXEC spIndexDropSelection 0,0, 'F', 'META'


-- Update DBObjects entries by deleting old versions and inserting new ones.
DELETE DBObjects
WHERE [name] in ('fApogeeTarget1','fApogeeTarget1N','fApogeeTarget2','fApogeeTarget2N','fApogeeStarFlag','fApogeeAspcapFlag','fApogeeParamFlag','fApogeeParamFlagN','fApogeeExtraTarg','fGetUrlMangaCube')
INSERT DBObjects VALUES('fApogeeTarget1','F','U',' Returns the ApogeeTarget1 value corresponding to a name ',' the spectro apogeeTarget1 flags can be shown with Select * from ApogeeTarget1   <br>  Sample call to find APOGEE extended objects  <samp>   <br> select top 10 *   <br> from apogeeStar   <br> where apogee_target1 & dbo.fApogeeTarget1(''APOGEE_EXTENDED'') > 0   </samp>   <br> see also fApogeeTarget1N. fApogeeTarget2 ','0');
INSERT DBObjects VALUES('fApogeeTarget1N','F','U',' Returns the expanded ApogeeTarget1 corresponding to the flag value as a string ',' The spectro apogeeTarget1 flags can be shown with Select * from ApogeeTarget1   <br>  Sample call to show the apogee target flags of some APOGEE objects is  <samp>   <br> select top 10 apogee_id, dbo.fApogeeTarget1N(apogee_target1) as apogeeTarget1  <br> from apogeeVisit  </samp>   <br> see also fApogeeTarget1, fApogeeTarget2 ','0');
INSERT DBObjects VALUES('fApogeeTarget2','F','U',' Returns the ApogeeTarget2 value corresponding to a name ',' the spectro ApogeeTarget2 flags can be shown with Select * from ApogeeTarget2   <br>  Sample call to find radial velocity standard apogee spectra  <samp>   <br> select top 10 *   <br> from apogeeStar  <br> where apogee_target2 & dbo.fApogeeTarget2(''APOGEE_RV_STANDARD'') > 0   </samp>   <br> see also fApogeeTarget2N, fApogeeTarget1 ','0');
INSERT DBObjects VALUES('fApogeeTarget2N','F','U',' Returns the expanded ApogeeTarget2 corresponding to the flag value as a string ',' The spectro apogeeTarget2 flags can be shown with Select * from ApogeeTarget2   <br>  Sample call to show the apogee target flags of some APOGEEobjects is  <samp>   <br> select top 10 aogee_id, dbo.fApogeeTarget2N(apogee_target2) as apogeeTarget2  <br> from apogeeVisit  </samp>   <br> see also fApogeeTarget2, fApogeeTarget1N ','0');
INSERT DBObjects VALUES('fApogeeStarFlag','F','U',' Returns the ApogeeStarFlag value corresponding to a name ',' the spectro ApogeeStarFlag flags can be shown with Select * from ApogeeStarFlag   <br>  Sample call to find APOGEE   <samp>   <br> select top 10 *   <br> from apogeeStar  <br> where starFlag & dbo.fApogeeStarFlag(''LOW_SNR'') > 0   </samp>   <br> see also fApogeeTarget1 ','0');
INSERT DBObjects VALUES('fApogeeAspcapFlag','F','U',' Returns the ApogeeAspcapFlag value corresponding to a name ',' the spectro ApogeeAspcapFlag flags can be shown with Select * from ApogeeAspcapFlag   <br>  Sample call to find APOGEE   <samp>   <br> select top 10 *   <br> from aspcapStar  <br> where ApogeeAspcapFlag & dbo.fApogeeAspcapFlag(''CHI2_BAD'') > 0   </samp>   <br> see also fApogeeTarget1 ','0');
INSERT DBObjects VALUES('fApogeeParamFlag','F','U',' Returns the ApogeeParamFlag value corresponding to a name ',' The spectro ApogeeParamFlag flags can be shown with Select * from ApogeeParamFlag   <br>  Sample call to find APOGEE aspcapStar objects with one of the parameters  (alpha_m) might have unreliable calibration:  <samp>   <br> select top 10 apStar_id, dbo.fApogeeParamFlagN(alpha_m_flag) as flags  <br> from aspcapStar  <br> where alpha_m_flag & dbo.fApogeeParamFlag(''CALRANGE_WARN'') > 0   </samp>   <br> see also fApogeeParamFlagN ','0');
INSERT DBObjects VALUES('fApogeeParamFlagN','F','U',' Returns the expanded ApogeeParamFlag names corresponding to the flag  value as a string ',' The spectro ApogeeParamFlag flags can be shown with Select * from ApogeeParamFlag   <br>  Sample call to show the param flags of aspcapStar objects:  <samp>   <br> select top 10 apstar_id, dbo.fApogeeParamFlagN(alpha_m_flag) as a  <br> from aspcapStar  </samp>   <br> see also fApogeeParamFlag ','0');
INSERT DBObjects VALUES('fApogeeExtraTarg','F','U',' Returns the ApogeeExtraTarg value corresponding to a name ',' the spectro ApogeeExtraTarg flags can be shown with Select * from ApogeeExtraTarg   <br>  Sample call to find APOGEE   <samp>   <br> select top 10 *   <br> from apogeeVisit  <br> where extraTarg & dbo.fApogeeExtraTarg(''TELLURIC'') > 0   </samp>   <br> see also fApogeeExtraTargN, fApogeeTarget1 ','0');
INSERT DBObjects VALUES('fGetUrlMangaCube','F','U',' Get the URL of the MaNGA data cube of the specified type (LIN/LOG) ',' Combines the value of the DataServer URL from the SiteConstants  table and builds up the whole URL from the plateIFU and data cube  type (''LIN'' or ''LOG''), along with the version string (versdp3 from  the mangaDrpAll entry.  <br><samp> select TOP 10 dbo.fGetUrlMangaCube(plateIFU,''LIN'')              FROM mangaDrpAll </samp> ','0');

-- Add inventory and history entries
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlMangaCube','F');
INSERT History VALUES('ConstantSupport','2016-07-30','Ani','Fixed APOGEE flag function descriptions. ');
INSERT History VALUES('spUrlFitsSupport','2016-07-29','Ani','Replaced "boss" with "eboss" for SAS file paths. ');
INSERT History VALUES('spUrlFitsSupport','2016-07-30','Ani','Added fGetUrlMangaCube to return MaNGA data cube URL. ');
INSERT History VALUES('spFinish','2016-07-30','Ani','Fixed DataServerURL setting in spSetVersion  (sdss3.org->sdss.org). ');

-- Recreate the META FK indices
EXEC spIndexBuildSelection 0,0, 'F', 'META'



-- Now apply fixes to fGetUrl* functions to replace "boss" with "eboss".
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


-- Add new function to get MaNGA data cube URL.
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




-- Set the DB version to 13.3
EXECUTE spSetVersion
  0
  ,0
  ,'13'
  ,'53a57f8cfee9563ae3d361c93aaf2bc428ce6851'
  ,'Update DR'
  ,'.3'
  ,'Pre-release update'
  ,'Added fGetUrlMangaCube, updated APOGEE flag function descriptions, updated DataServerURL setting in SiteConstants in spSetVersion'
  ,'A.Thakar'
GO
