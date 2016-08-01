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


-- Set the DB version to 13.3
