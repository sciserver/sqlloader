-- Script to sync DR9 testload db, invokes dr8testloadPatches.sql too. [ART]

USE BESTDR9
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
 
EXEC spIndexDropSelection 1, 1303, 'F','META'
EXEC spIndexDropSelection 1, 1303, 'I','META'
EXEC spIndexDropSelection 1, 1303, 'K','META'


EXEC spRunSQLScript 1, 1303, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'DataConstants.sql','BESTDR9','C:\temp\BESTDR9schemaSync.txt' 
EXEC spRunSQLScript 1, 1303, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'ConstantSupport.sql','BESTDR9','C:\temp\BESTDR9schemaSync.txt' 
EXEC spRunSQLScript 1, 1303, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'IndexMap.sql','BESTDR9','C:\temp\BESTDR9schemaSync.txt'
EXEC spRunSQLScript 1, 1303, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'spSpectro.sql','BESTDR9','C:\temp\BESTDR9schemaSync.txt'
EXEC spRunSQLScript 1, 1303, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'spValidate.sql','BESTDR9','C:\temp\BESTDR9schemaSync.txt'
EXEC spRunSQLScript 1, 1303, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'spFinish.sql','BESTDR9','C:\temp\BESTDR9schemaSync.txt'
EXEC spRunSQLScript 1, 1303, 'Sync Schema', 'C:\sqlLoader\schema\patches', 'SpecPlateSSPPlinesDR9.sql','BESTDR9','C:\temp\BESTDR9schemaSync.txt'


-- Reload the metadata tables
EXEC spLoadMetaData 1, 1303, 'C:\sqlLoader\schema\csv\', 0

EXEC spIndexBuildSelection 1, 1303, 'K','META'
EXEC spIndexBuildSelection 1, 1303, 'I','META'
EXEC spIndexBuildSelection 1, 1303, 'F','META'

 
-- To disable the feature.
EXEC sp_configure 'xp_cmdshell', 0
GO

-- To update the currently configured value for this feature.
RECONFIGURE
GO
