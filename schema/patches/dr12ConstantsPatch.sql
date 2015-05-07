-- Patch to load AnicllargyTarget2 values and fix fAncillaryTarget?N
-- functions for DR12.

USE [BestDR12]
GO

-- reload DataConstants table (to include new AncillaryTarget2 bits)
EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE WITH OVERRIDE
GO
-- To enable the cmd shell.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE WITH OVERRIDE
GO

-- Reload the data constants and support functions
EXEC spRunSQLScript 0, 0, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'DataConstants.sql','BestDR12','C:\temp\BestDR12schemaSync.txt' 
EXEC spRunSQLScript 0, 0, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'ConstantSupport.sql','BestDR12','C:\temp\BestDR12schemaSync.txt' 
EXEC spRunSQLScript 0, 0, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'spFinish.sql','BestDR12','C:\temp\BestDR12schemaSync.txt' 
EXEC spIndexBuildSelection 0,0, 'K', 'PHOTO'	-- for stripeDefs index


-- Refresh metadata tables
EXEC spLoadMetaData 0,0, 'C:\sqlLoader\schema\csv\', 1



-- To disable the cmd shell.
EXEC sp_configure 'xp_cmdshell', 0
GO

-- To update the currently configured value for this feature.
RECONFIGURE WITH OVERRIDE
GO

-- Now update the DB version
EXECUTE spSetVersion
  0
  ,0
  ,'12'
  ,'161710'
  ,'Update DR'
  ,'.5'
  ,'DR12 constantss patch'
  ,'Update DataConstants for AncillaryTarget values and functions'
  ,'A.Thakar'
GO

