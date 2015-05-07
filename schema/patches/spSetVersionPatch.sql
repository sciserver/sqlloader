-- Patch to fix SiteConstants.DataServerURL in spSetVersion.

ALTER PROCEDURE spSetVersion(@taskid int, @stepid int,
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
	UPDATE siteconstants SET value='http://data.sdss3.org/' WHERE name='DataServerURL'
	UPDATE siteconstants SET value='http://skyserver.sdss3.org/dr'+@release+'/en/' WHERE name='WebServerURL'
	UPDATE siteconstants SET value=@dbversion WHERE name='DB Version'
	UPDATE siteconstants SET value='DR'+@release+' SkyServer' WHERE name='DB Type'
	UPDATE siteconstants SET value=@curtime WHERE name='DB Version Date'

	-- get checksum from site constants and add new entry to Versions
	DECLARE @checksum VARCHAR(64)
	SELECT @checksum=value FROM siteconstants WHERE [name]='Checksum'
	SELECT @prev=max(version) from Versions

	-- update Versions table with latest version
	INSERT Versions
		VALUES( @vname+@release,@prev,@checksum,@release+@vnum,
			@vdesc, @vtext, @vwho, @curtime)
END
GO




-- Update the version info
EXECUTE spSetVersion
  0
  ,0
  ,'8'
  ,'127606'
  ,'Update DR'
  ,'.5'
  ,'spSetVersion patch'
  ,'Fixed SiteConstants.DataServerURL setting in spSetVersion'
  ,'A.Thakar'

