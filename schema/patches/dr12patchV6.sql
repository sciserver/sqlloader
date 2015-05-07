-- Patch for v6 (12.6) of DR12 db.

-- Create new function fSDSSfromSpecID (PR #2257) as inverse of 
-- fSpecIDfromSDSS.

--===============================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSDSSfromSpecID' )
	DROP FUNCTION fSDSSfromSpecID
GO
--
CREATE FUNCTION fSDSSfromSpecID(@specID bigint)
-------------------------------------------------------------------------------
--/H Returns a table pf the 3-part SDSS numbers from the long specObjID.
--
--/T The returned columns in the output table are: 
--/T	plate, mjd, fiber<br>
--/T <samp> select * from dbo.fSDSSfromSpecID(865922932356966400)</samp>
-------------------------------------------------------------------------------
RETURNS @sdssSpecID TABLE (
	plate INT,
	mjd INT,
	fiber INT
)
AS BEGIN
    INSERT @sdssSpecID 
	SELECT
	    cast( (@specID / power(cast(2 as bigint),50)) AS INT ) AS plate,
	    cast( (((@specID & 0x0000003FFFFFFFFF)/ power(cast(2 as bigint),24)) + 50000) AS INT ) AS mjd,
	    cast( (((@specID & 0x0003FFFFFFFFFFFF) / power(cast(2 as bigint),38))) AS INT) AS fiber
    RETURN
END
GO
--


-- Modify spSetVersion so that it updates the Description and URL fields
-- correctly based on the current DR.

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

	-- update Versions table with latest version
	INSERT Versions
		VALUES( @vname+@release,@prev,@checksum,@release+@vnum,
			@vdesc, @vtext, @vwho, @curtime)
END
GO


-- Now update the DB version

EXECUTE spSetVersion
  0
  ,0
  ,'12'
  ,'161628'
  ,'Update DR'
  ,'.6'
  ,'DR12 patch for v6'
  ,'Add fSDSSfromSpecID (PR 2257) and update spSetVersion'
  ,'A.Thakar'
GO


