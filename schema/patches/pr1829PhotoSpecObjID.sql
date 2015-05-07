-- Patch to fix PR #1829, PhotoObjAll.specObjID not set correctly.

USE BestDR10
GO

EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE with override
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE with override
GO


DECLARE @taskID INT, @stepID INT, @ret INT, @msg varchar(1024)


IF EXISTS (SELECT * FROM sys.databases WHERE name='loadadmin')
   BEGIN
      SET @taskID=1
      SELECT @stepID=MAX(stepID) FROM loadadmin.dbo.Phase WHERE taskID=1
   END
ELSE
   BEGIN
      SET @taskID=0
      SET @stepID=0
   END


-- First refresh the metadata tables
EXEC spLoadMetaData @taskID, @stepID, 'C:\sqlLoader\schema\csv\', 1

-- Next, set all specobjid links in PhotoObjAll to 0
EXEC spNewPhase @taskID, @stepID, 'PR #1829 patch', 'OK', 'Setting specobjid=0 in PhotoObjAll';
------------------------------------------------------
DECLARE @rows BIGINT
BEGIN TRANSACTION
    UPDATE p
	SET p.specobjid=0
	FROM PhotoObjAll p WITH (tablock)
	WHERE 
	    p.specobjid != 0
	OPTION (MAXDOP 1)	
    SET  @rows = rowcount_big();
COMMIT TRANSACTION
SET  @msg = 'Set specobjid to 0 for ' + str(@rows) + ' PhotoObjAll rows.'
EXEC spNewPhase @taskID, @stepID, 'PR #1829 patch', 'OK', @msg;
BEGIN TRANSACTION
    UPDATE p
	SET p.specobjid=s.specobjid
	FROM PhotoObjAll p WITH (tablock)
	     JOIN SpecObjAll s ON p.objid=s.bestobjid
	WHERE
	    p.specobjid=0
	OPTION (MAXDOP 1)	
    SET  @rows = rowcount_big();
COMMIT TRANSACTION
SET  @msg = 'Updated unset specObjID links for ' + str(@rows) + ' PhotoObjAll rows.'
EXEC spNewPhase @taskID, @stepID, 'PR #1829 patch', 'OK', @msg;
GO

-- To disable the cmd shell.
EXEC sp_configure 'xp_cmdshell', 0
GO

-- To update the currently configured value for this feature.
RECONFIGURE with override
GO

-- Now update the DB version
EXECUTE spSetVersion
  0
  ,0
  ,'10'
  ,'149309'
  ,'Update DR'
  ,'.5'
  ,'pr1829 patch'
  ,'Reset PhotoObjAll.specobjid'
  ,'A.Thakar'
GO

-- Finally, set the previous version column value for latest version.
update Versions
set previous='10.4'
where version='10.5'
GO
