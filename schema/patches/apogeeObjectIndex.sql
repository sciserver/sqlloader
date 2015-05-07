-- Patch to add and create index on apogeeObject.apogee_id, to speed up
-- Explore queries.

USE BestDR10
GO

-- First add the index to IndexMap
INSERT IndexMap Values('I','index', 		'apogeeObject',		'apogee_id,j,h,k,j_err,h_err,k_err'		,'','SPECTRO');
GO

-- Then create the index
EXEC spIndexBuildSelection 0,0, 'I', 'apogeeObject'
GO

-- Now update the DB version
EXECUTE spSetVersion
  0
  ,0
  ,'10'
  ,'149222'
  ,'Update DR'
  ,'.4'
  ,'apogeeObject index patch'
  ,'Added index on apogeeObject.apogee_id'
  ,'A.Thakar'
GO

-- Finally, set the previous version column value for latest version.
update Versions
set previous='10.3'
where version='10.4'
GO
