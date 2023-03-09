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

-- check functions, sp's, and views against schema
EXEC spCheckObjects with recompile


-- now set the new version; this gets tweaked for each version
EXECUTE spSetVersion
  0
  ,0
  ,'16'
  ,'eb1130f8746c2e5d6fc95268957105ab36b9d56b'
  ,'Update DR'
  ,'.1'
  ,'Miscellaneous schema updates and fixes'
  ,'Rebuilt SpecPhotoAll, updated APOGEE functions, fixed spMakeDiagnostics, recreated Views'
  ,'S.Werner, A.Thakar'
  ,0



