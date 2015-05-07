-- Template SQL script to run a sqlLoader SQL script in the given DB.
-- Tweak as needed.  [ART]
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

-- Modify the following line with taskid, stepid, the name of the script 
-- file, the DB to run the script on, as well as the log output file name.
-- Add more script execution commands as needed.
EXEC spRunSQLScript 0, 0, 'Sync Schema', 'C:\sqlLoader\schema\sql', 'spSetValues.sql','BestDR9','C:\temp\BestDR9schemaSync.txt' 

-- To disable the cmd shell.
EXEC sp_configure 'xp_cmdshell', 0
GO

-- To update the currently configured value for this feature.
RECONFIGURE WITH OVERRIDE
GO
