-- Patch to fix sciencePrimary values and add column sdssPrimary in SpecObjAll
-- Assumes that the patch CSV has been ingested into a new table called
-- specObjAllPatchPrimary.

-- Add a new column 'sdssPrimary' to SpecObjAll
ALTER TABLE SpecObjAll
	ADD sdssPrimary smallint DEFAULT 0 NOT NULL
GO

-- Update sciencePrimary and sdssPrimary values from patch file
UPDATE s
	SET s.sciencePrimary = p.sciencePrimary,
	    s.sdssPrimary = p.sdssPrimary
FROM SpecObjAll s 
     JOIN specObjAllPatchPrimary p ON s.specobjid = p.specobjid
GO


