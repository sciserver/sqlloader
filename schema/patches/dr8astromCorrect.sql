-- Patch to add DR9 astrom tables to DR8.

USE BESTDR8
GO

-- Enable command shell execution
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

-- Drop meta indices to avoid FK conflicts etc.
EXEC spIndexDropSelection 0, 0, 'F','META'
EXEC spIndexDropSelection 0, 0, 'I','META'
EXEC spIndexDropSelection 0, 0, 'K','META'

-- Add PK indices for astromDR9 and ProperMotionsDR9 tables.
INSERT IndexMap Values('K','primary key', 'astromDR9',		'objID'			,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'ProperMotionsDR9',	'objID'			,'','PHOTO');

-- Refresh the metadata tables
EXEC spLoadMetaData 0,0, 'C:\sqlLoader\schema\csv\', 0

-- Recreate the meta indices
EXEC spIndexBuildSelection 0, 0, 'K','META'
EXEC spIndexBuildSelection 0, 0, 'I','META'
EXEC spIndexBuildSelection 0, 0, 'F','META'

 
-- To disable the feature.
EXEC sp_configure 'xp_cmdshell', 0
GO

-- To update the currently configured value for this feature.
RECONFIGURE
GO

-- Update the version info
EXECUTE spSetVersion
  0
  ,0
  ,'8'
  ,'130648'
  ,'Update DR'
  ,'.6'
  ,'astrom patch'
  ,'Added astrom correction tables from DR9: astromDR9 and ProperMotionsDR9'
  ,'M.Blanton, N.Buddana, A.Thakar'

