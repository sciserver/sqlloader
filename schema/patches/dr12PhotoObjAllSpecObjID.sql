-- DR12 patch to reset PhotoObjAll.specobjid after reload of specobjall
USE BESTDR12
GO

EXEC spNewPhase 0, 0, 'PhotoObjAll.specObjID patch', 'OK', 'Setting specobjid=0 in PhotoObjAll';
GO
------------------------------------------------------
DECLARE @rows BIGINT, @msg varchar(1024)

BEGIN TRANSACTION
    UPDATE p
	SET p.specobjid=0
	FROM PhotoObjAll p WITH (tablock)
	WHERE 
	    p.specobjid != 0
-- 	OPTION (MAXDOP 1)	
    SET  @rows = rowcount_big();
COMMIT TRANSACTION
SET  @msg = 'Set specobjid to 0 for ' + str(@rows) + ' PhotoObjAll rows.'
EXEC spNewPhase 0, 0, 'PhotoObjAll.specObjID patch', 'OK', @msg;
BEGIN TRANSACTION
    UPDATE p
	SET p.specobjid=s.specobjid
	FROM PhotoObjAll p WITH (tablock)
	     JOIN SpecObjAll s ON p.objid=s.bestobjid
	WHERE
	    p.specobjid=0
-- 	OPTION (MAXDOP 1)	
    SET  @rows = rowcount_big();
COMMIT TRANSACTION
SET  @msg = 'Updated unset specObjID links for ' + str(@rows) + ' PhotoObjAll rows.'
EXEC spNewPhase 0, 0, 'PhotoObjAll.specObjID patch', 'OK', @msg;
GO


-- now set the new version; this gets tweaked for each version
EXECUTE spSetVersion
  0
  ,0
  ,'12'
  ,'161043'
  ,'Update DR'
  ,'.4'
  ,'Updated PhotoObjAll.specObjID'
  ,'Patch (similar to PR #1829 patch) applied to update PhotoObjAll.specobjid links'
  ,'A.Thakar'
