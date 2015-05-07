-- Patch to fix PR #1665, PhotoObjAll specobjID not updated for DR9.
DECLARE @rows BIGINT, @msg VARCHAR(256), @taskid INT, @stepid INT
SET @taskid=0		-- Change it to loader pub task taskid as necssary
SET @stepid=0		-- Change it to loader pub task stepid as necssary

BEGIN TRANSACTION
    UPDATE p
	SET p.specobjid=s.specobjid
	FROM photoobjall p, specobj s
	WHERE p.objid=s.bestobjid
	    AND p.specobjid=0
	OPTION (MAXDOP 1)	
	SET  @rows = rowcount_big();
COMMIT TRANSACTION
SET  @msg = 'Updated unset specObjID links for ' + str(@rows) + ' PhotoObjAll.'
EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', @msg;
-----------------------------------------------------
--- compute best photo object for spec Objects that are sciencePrimary.
BEGIN TRANSACTION
    UPDATE p
	SET p.specobjid=s.specobjid
	FROM photoobjall p, specobjall s
	WHERE p.objid=s.bestobjid
	    AND p.specobjid=0
	OPTION (MAXDOP 1)	
	SET  @rows = rowcount_big();
COMMIT TRANSACTION
SET  @msg = 'Updated unset specObjID links for ' + str(@rows) + ' PhotoObjAll.'
EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', @msg;

