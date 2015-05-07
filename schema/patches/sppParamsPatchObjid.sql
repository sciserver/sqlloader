-- Patch to rename ORIGOBJID to FLUXOBJID in sppParams and updating the values 
-- of FLUXOBJID.
-- Assumes that the patch CSV has been ingested into a new table called
-- sppParamsPatchObjId.

EXEC sp_rename @objname='sppParams.ORIGOBJID', 
	       @newname='FLUXOBJID', 
	       @objtype='COLUMN'
GO

UPDATE s
	SET s.FLUXOBJID=p.FLUXOBJID
FROM sppParams s 
   JOIN sppParamsPatchObjId p ON s.SPECOBJID=p.SPECOBJID
GO




