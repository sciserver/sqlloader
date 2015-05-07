-- Add index on SpecObjAll.fluxObjID (PR #2130).

-- add the entry to IndexMap
INSERT IndexMap Values('I','index',             'SpecObjAll',    'fluxObjID','','SPECTRO'); 

-- then run the index creation SP to create the index
EXEC spIndexBuildSelection 0, 0, 'I', 'SPECTRO'
