-- Script to sync DR9 testload db, invokes dr8testloadPatches.sql too. [ART]

USE BESTTEST
GO

-- Modify spDocEnum to only print data values for name != ''.
ALTER PROCEDURE spDocEnum(@fieldname varchar(64))
------------------------------------------------------
--/H Display the properly rendered values from DataConstants 
--
--/T The parameter is the name of the enumerated field in DataConstants.
--/T The type and length is taken from the View of corresponding name.
--/T <br><samp>
--/T exec spDocEnum 'PhotoType'
--/T</samp>
------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @type varchar(32),
		@length int;

	SELECT	@type=t.name,
		@length=c.length
	FROM syscolumns c WITH (nolock), 
		 sysobjects o WITH (nolock),
		 systypes t WITH (nolock)
	WHERE c.[id] = o.[id]
	  and o.xtype  = 'V'
	  and t.xtype  = c.xtype
	  and c.[name] = 'value'
	  and o.[name] = @fieldname;
	--
	SELECT	name, 
		dbo.fEnum(value,@type, @length) as value,
		description
	FROM DataConstants WITH (nolock)
	WHERE field=@fieldname
           AND name != ''
	ORDER BY value
END
GO

EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO

EXEC spIndexDropSelection 0, 0, 'F','META'
EXEC spIndexDropSelection 0, 0, 'I','META'
EXEC spIndexDropSelection 0, 0, 'K','META'

-- Delete SpecClass and SpecZStatus, rename UberCalibStatus with CalibStatus,
-- add descriptions to PrimTarget and SecTarget, and add new fields for
-- SpecialTarget1, Segue1Target1, Segue2Target1 and ImageStatus.

DELETE FROM DataConstants
	WHERE field in ('FieldMask','UberCalibStatus','SpecClass','SpecZStatus','SpecLineNames')

IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fImageMask' )
      DROP FUNCTION fImageMask
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fImageMaskN' )
      DROP FUNCTION fImageMaskN
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fSpecClass' )
      DROP FUNCTION fSpecClass
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fSpecClassN' )
      DROP FUNCTION fSpecClassN
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fSpecLineNames' )
      DROP FUNCTION fSpecLineNames
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fSpecLineNamesN' )
      DROP FUNCTION fSpecLineNamesN
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fSpecZStatus' )
      DROP FUNCTION fSpecZStatus
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fSpecZStatusN' )
      DROP FUNCTION fSpecZStatusN
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fUberCalibStatus' )
      DROP FUNCTION fUberCalibStatus
IF EXISTS (SELECT name FROM sysobjects
      WHERE  name = N'fUberCalibStatusN' )
      DROP FUNCTION fUberCalibStatusN
IF EXISTS (SELECT Name FROM Sysobjects
      WHERE  Name = N'FieldMask' )
      DROP VIEW FieldMask
IF EXISTS (SELECT Name FROM Sysobjects
      WHERE  Name = N'ImageMask' )
      DROP VIEW ImageMask
IF EXISTS (SELECT Name FROM Sysobjects
      WHERE  Name = N'SpecClass' )
      DROP VIEW SpecClass
IF EXISTS (SELECT Name FROM Sysobjects
      WHERE  Name = N'SpecLineNames' )
      DROP VIEW SpecLineNames
IF EXISTS (SELECT Name FROM Sysobjects
      WHERE  Name = N'SpecZStatus' )
      DROP VIEW SpecZStatus
IF EXISTS (SELECT Name FROM Sysobjects
      WHERE  Name = N'UberCalibStatus' )
      DROP VIEW UberCalibStatus


EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'DataConstants.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt' 
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'ConstantSupport.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt' 
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'GalaxyZooTables.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt'
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'resolveTables.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt'
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'ssppTables.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt'
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'TilingTables.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt'
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'IndexMap.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt'
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'spSpectro.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt'
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'spValidate.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt'
EXEC spRunSQLScript 1,2, 'Sync Schema', 'C:\sqlLoader\schema\patches', 'dr8testloadPatches.sql','BESTTEST','C:\temp\BESTTESTschemaSync.txt'


-- Reload the metadata tables
EXEC spLoadMetaData 1,2, 'C:\sqlLoader\schema\csv\', 0

EXEC spIndexBuildSelection 0, 0, 'K','META'
EXEC spIndexBuildSelection 0, 0, 'I','META'
EXEC spIndexBuildSelection 0, 0, 'F','META'

 
-- To disable the feature.
EXEC sp_configure 'xp_cmdshell', 0
GO

-- To update the currently configured value for this feature.
RECONFIGURE
GO
