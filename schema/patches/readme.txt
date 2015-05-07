This directory contains any patches that need to applied to the live DB
schema.  Normally these files can be deleted after the patch has been applied.
A history of patches applied should be fastidiously maintained in this file.

History:

2003-May: Ani+Alex
	  CreatePhotoTagTable.sql and rename.sql applied to DR1 DBs on sdssad6
	  to propagate new PhotoTag and PhotoObj/PhotoObjAll reorganization,
	  and renaming of reddening->extinction everywhere, catID->insideMask
	  in PhotoObjAll/PhotoTag, and fracPSF to fracDeV in PhotoObjAll.

