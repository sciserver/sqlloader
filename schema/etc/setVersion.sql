EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE WITH OVERRIDE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE WITH OVERRIDE
GO

EXEC spLoadMetaData 0,0, 'C:\sqlLoader\schema\csv\', 1
EXEC spRunSQLScript 0,0, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'IndexMap.sql','BESTDR10','C:\temp\BESTDR10schemaSync.txt'

-- To disable the feature.
EXEC sp_configure 'xp_cmdshell', 0
GO

-- To update the currently configured value for this feature.
RECONFIGURE WITH OVERRIDE
GO

-- build any remaining indices from IndexMap update
EXEC spIndexBuildSelection 0,0,'F','ALL'
EXEC spIndexBuildSelection 0,0,'I','ALL'
EXEC spIndexBuildSelection 0,0,'K','ALL'

-- get a clean check on schema and indices first
EXEC spCheckDBObjects
EXEC spCheckDBColumns
EXEC spCheckDBIndexes


-- now set the new version; this gets tweaked for each version
EXECUTE spSetVersion
  0
  ,0
  ,'10'
  ,'154989'
  ,'Update DR'
  ,'.7'
  ,'Schema updates for WISE_allsky and TwoMASS'
  ,'Added columns to WISE_allsky and indices to TwoMASS, PRs 1900,1909,1913'
  ,'D.Muna,A.Thakar'


