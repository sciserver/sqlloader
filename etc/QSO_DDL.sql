--=========================================================================================================
-- QsoConcordance table 
--==================================================
if exists (select * from dbo.sysobjects where id = object_id(N'QsoCatalogAll')) drop table [QsoCatalogAll]
GO
Create table QsoCatalogAll(
-------------------------------------------------------------------------------
--/H A concordance of all the objects from Spectro, Best, or Target that "smell" like a QSO
--/
--/T This table is derived from the SpecObj, Best.PhotoObj, and Target.PhotoObj tables.
--/T Any SpecObj with SpecClass in QSO or HiZ_QSO is recorded
--/T Any PhotoObj in Best or Target with and of the following primary Target Flags set
--/T                       QSO_HIZ, QSO_CAP, QSO_SKIRT, QSO_FIRST_CAP,QSO_FIRST_SKIRT
--/T this list is first "culled" to discard objects that have multiple observations.
--/T The "primary" (photoObj) or sciencePrimary (SpecObj) is retained.
--/T If no primay is available, the highest ObjID of the set wins.
--/T Then the three lists are merged into a single list, matching by (ra,dec) with a 1 arcsecond radius.
--/T That is, if a photo and spectro object have centers that are within 1 arcsecond, 
--/T then they are considered to be observations of the same object. 	
--/T This step produces 72319 items on the SdssDr1 dataset with the following population statistics:
--/T <code>
--/T   SpecObj     bestObj    targetObj   pop         
--/T  ----------- ----------- ----------- ----------- 
--/T     1           0           1        20225
--/T     1           1           0        17513
--/T     1           0           0        16518
--/T     0           0           0        11517
--/T     0           1           1        4044
--/T     0           1           0        2350
--/T     0           0           1        152
--/T </code>
--/T Now a sequence of spatial lookups tries to identify the 20,225 best objects 
--/T that are missing from the first row.
--/T Those objects were probably observed, but were not flagged as QSO candidates.
--/T After a fair amount of heuristics, most of these corresponding entries are identified.
--/T We end up with counts that look more like:
--/T <code>
--/T   SpecObj     bestObj    targetObj   pop         
--/T  ----------- ----------- ---------- ------- 
--/T     0           1           1       35023
--/T     1           1           1       29798
--/T     0           1           0        6075
--/T     0           0           1        1346
--/T     1           0           1          76
--/T     1           0           0           1
--/T </code>
--/T The first two rows are great: SpecObjs with matching Best and Target objects.
--/T or a matching best and target pair that are likely a QSO 
--/T but have not yet observed with the spectrograph.
--/T The remaining rows are a reminder that this is real data.
--/T For example the last row represents a spectrogram with unknown ra,dec.
--/T The third and second to last rows represent processing holes 
--/T in the Best database output (target areas not included in Best.)
--/T 
--/T All this information is recorded in the QsoCatalogAll table along with
--/T <ul> 
--/T <li> Confidence: a confidence indicator whihc is Specobj.Zconf if it is SpecClass QSO or HiZ_QSO and 1-Zconf if it is in some other SpecClass.
--/T <li> ra, dec: the average ra,dec of the group.
--/T <li> zone: the 1 arcminute zone size used for quick spatial searches.
--/T <li> specObjQso, bestObjQso, targetObjOso: flags that indicate if the corresponding object was flagged as a QSO.
--/T      (some objIDs are added because other observations of the object "said" QSO, but the objID did not.
--/T </ul>
--/T <br>
               SpecObjID 	bigint not null, --/D Unique ID of spectrographic object
               bestObjID 	bigint not null, --/D Unique SDSS identifier in Best DB composed from [rerun,run,camcol,field,obj], or 0 if there is none.
               targetObjID 	bigint not null, --/D Unique SDSS identifier in Target DB composed from [rerun,run,camcol,field,obj], or 0 if there is none.
               zone 		int not null,	 --/D 1 arcminute zone used for spatial joins floor((dec+90)*60*60)
               ra 		float not null,  --/D J2000 right ascension (r') 			--/U degrees in J2000
               dec 		float not null,  --/D J2000 right declination (r') 			--/U degrees in J2000
               Confidence 	float not null,  --/D a number between 0..1. If this has a SpecObj, then it is the QSO Zconf (see table definition). If no specobj, it is .3*(BestObjFlagedQso+TargetObjFlagedQso)
               SpecObjQso 	tinyint not null, --/D Flag (0 / 1): 1 means this SpecObj is SpecClass QSO or HiX_QSO
               BestObjQso 	tinyint not null, --/D Flag (0 / 1): 1 PhotoObjID was flagged as a QSO in the target flags.
               TargetObjQso 	tinyint not null, --/D Flag (0 / 1): 1 PhotoObjID was flagged as a QSO in the target flags.
		primary key (zone,ra,SpecObjID, bestObjID,TargetObjID)
		)

--=========================================================================================================
-- QsoConcordance table 
--==================================================
if exists (select * from dbo.sysobjects where id = object_id(N'QsoConcodance')) drop table [QsoConcodance]
GO
CREATE TABLE QsoConcodance (
-------------------------------------------------------------------------------
--/H A concordance of all the objects from Spectro, Best, or Target that "smell" like a QSO
--/
--/T This table is derived from the SpecObj, Best.PhotoObj, and Target.PhotoObj tables.
--/T Any SpecObj with SpecClass in QSO or HiZ_QSO is recorded
--/T Any PhotoObj in Best or Target with and of the following primary Target Flags set
--/T                       QSO_HIZ, QSO_CAP, QSO_SKIRT, QSO_FIRST_CAP,QSO_FIRST_SKIRT
--/T this list is first "culled" to discard objects that have multiple observations.
--/T The "primary" (photoObj) or sciencePrimary (SpecObj) is retained.
--/T If no primay is available, the highest ObjID of the set wins.
--/T Then the three lists are merged into a single list, matching by (ra,dec) with a 1 arcsecond radius.
--/T That is, if a photo and spectro object have centers that are within 1 arcsecond, 
--/T then they are considered to be observations of the same object. 	
--/T This step produces 72319 items on the SdssDr1 dataset with the following population statistics:
--/T <code>
--/T   SpecObj     bestObj    targetObj   pop         
--/T  ----------- ----------- ----------- ----------- 
--/T     1           0           1        20225
--/T     1           1           0        17513
--/T     1           0           0        16518
--/T     0           0           0        11517
--/T     0           1           1        4044
--/T     0           1           0        2350
--/T     0           0           1        152
--/T </code>
--/T Now a sequence of spatial lookups tries to identify the 20,225 best objects 
--/T that are missing from the first row.
--/T Those objects were probably observed, but were not flagged as QSO candidates.
--/T After a fair amount of heuristics, most of these corresponding entries are identified.
--/T We end up with counts that look more like:
--/T <code>
--/T   SpecObj     bestObj    targetObj   pop         
--/T  ----------- ----------- ---------- ------- 
--/T     0           1           1       35023
--/T     1           1           1       29798
--/T     0           1           0        6075
--/T     0           0           1        1346
--/T     1           0           1          76
--/T     1           0           0           1
--/T </code>
--/T The first two rows are great: SpecObjs with matching Best and Target objects.
--/T or a matching best and target pair that are likely a QSO 
--/T but have not yet observed with the spectrograph.
--/T The remaining rows are a reminder that this is real data.
--/T For example the last row represents a spectrogram with unknown ra,dec.
--/T The third and second to last rows represent processing holes 
--/T in the Best database output (target areas not included in Best.)
--/T 
--/T All this information is recorded in the QsoCatalogAll table along with
--/T <ul> 
--/T <li> Confidence: a confidence indicator whihc is Specobj.Zconf if it is SpecClass QSO or HiZ_QSO and 1-Zconf if it is in some other SpecClass.
--/T <li> ra, dec: the average ra,dec of the group.
--/T <li> zone: the 1 arcminute zone size used for quick spatial searches.
--/T <li> specObjQso, bestObjQso, targetObjOso: flags that indicate if the corresponding object was flagged as a QSO.
--/T      (some objIDs are added because other observations of the object "said" QSO, but the objID did not.
--/T </ul>
--/T <br>
--/T Now the QsoConcordence is built from QSOCatalogAll.  
--/T It is a collection of popular fields from the three different databases (Spectro, Best, Target).
--/T Its fields are itemized and documented below.
--/T See also the QsoCatalogAll  table description. 
-------------------------------------------------------------------------------
	       RowC 		real not null,	--/D Row center position (r' coordinates)     		--/U pixels
               ColC 		real not null,  --/D Column center position (r' coordinates) 		--/U pixels
               RowC_i 		real not null,  --/D i band Row center position (r' coordinates) 	--/U pixels
               ColC_i 		real not null,  --/D i band Column center position (r' coordinates) 	--/U pixels
               extinction_u 	real not null,  --/D Reddening in each filter 				--/U magnitudes
               extinction_g 	real not null,  --/D Reddening in each filter 				--/U magnitudes
               extinction_r 	real not null,  --/D Reddening in each filter 				--/U magnitudes
               extinction_i 	real not null,  --/D Reddening in each filter 				--/U magnitudes
               extinction_z 	real not null,  --/D Reddening in each filter				--/U magnitudes
               bestObjID 	bigint not null, --/D Unique SDSS identifier in Best DB composed from [rerun,run,camcol,field,obj], or 0 if there is none.
               targetObjID 	bigint not null, --/D Unique SDSS identifier in Target DB composed from [rerun,run,camcol,field,obj], or 0 if there is none.
               SpecObjID 	bigint not null, --/D Unique ID of spectrographic object
               zone 		int not null,	 --/D 1 arcminute zone used for spatial joins floor((dec+90)*60*60)
               ra 		float not null,  --/D J2000 right ascension (r') 			--/U degrees in J2000
               dec 		float not null,  --/D J2000 right declination (r') 			--/U degrees in J2000
               QsoConfidence 	float not null,  --/D a number between 0..1. If this has a SpecObj, then it is the QSO Zconf (see table definition). If no specobj, it is .3*(BestObjFlagedQso+TargetObjFlagedQso)
               SpecObjFlagedQso tinyint not null, --/D Flag (0 / 1): 1 means this SpecObj is SpecClass QSO or HiX_QSO
               BestObjFlagedQso tinyint not null, --/D Flag (0 / 1): 1 PhotoObjID was flagged as a QSO in the target flags.
               TargetObjFlagedQso tinyint not null, --/D Flag (0 / 1): 1 PhotoObjID was flagged as a QSO in the target flags.

	       sZ    		real 	not null, --/D 0 or specObj.Z Final Redshift
	       sZerr		real 	not null, --/D 0 or specObj.Zerr  Redshift error
	       szConf		real 	not null, --/D 0 or specObj.zConf  Redshift confidence
	       szWarning	int 	not null, --/D 0 or specObj.Warning Flags --/R SpeczWarning
	       sZStatus 	int not null,     --/D 0 or specObj.Zstatus  Redshift status --/R SpecZStatus
               sSpecClass 	int not null,	  --/D 0 or specObj.SpecClass Spectral Classification --/R SpecClass 
	       splate 		int 	not null, --/D 0 or specObj.plate Link to plate on which the spectrum was taken
               SFiberID 	int 	not null, --/D 0 or specObj.Fiber ID
	       sMjd		int 	not null, --/D 0 or specObj.MJD of observation
               sPrimTarget 	int not null,     --/D 0 or specObj.PrimTarget Bit mask of primary target categories the object was selected in. --/R PrimTarget 
	      
               bType 		int not null,	  --/D 0 or best PhotoObj.type Morphological type classification of the object. --/R PhotoType
               tType 		int not null,	  --/D 0 or target PhotoObj.type Morphological type classification of the object. --/R PhotoType
               bFlags 		bigint not null,  --/D 0 or best PhotoObj.Flags    Object detection flags  --/R PhotoFlags
               tFlags 		bigint not null,  --/D 0 or target PhotoObj.flags  Object detection flags  --/R PhotoFlags
               bPrimTarget 	int not null,     --/D 0 or best PhotoObj.PrimTarget  Bit mask of primary target categories the object was selected in. --/R PrimTarget
               tPrimTarget 	int not null,     --/D 0 or target PhotoObj.PrimTarget Bit mask of primary target categories the object was selected in. --/R PrimTarget
               bPsfMag_u 	real not null,    --/D 0 or best PhotoObj.PsfMag_u PSF flux  --/U luptitudes
               bPsfMag_g 	real not null,    --/D 0 or best PhotoObj.PsfMag_g PSF flux  --/U luptitudes
               bPsfMag_r 	real not null,    --/D 0 or best PhotoObj.PsfMag_r PSF flux  --/U luptitudes
               bPsfMag_i 	real not null,    --/D 0 or best PhotoObj.PsfMag_i PFS flux  --/U luptitudes
               bPsfMag_z 	real not null,    --/D 0 or best PhotoObj.PsfMag_z PFS flux  --/U luptitudes
               bPsfMagErr_u 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_u PSF flux error --/U luptitudes
               bPsfMagErr_g 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_g PSF flux error --/U luptitudes
               bPsfMagErr_r 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_r PSF flux error --/U luptitudes
               bPsfMagErr_i 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_i PSF flux error --/U luptitudes
               bPsfMagErr_z 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_z PSF flux error --/U luptitudes
               tPsfMag_u 	real not null,    --/D 0 or target PhotoObj.PsfMag_u PSF flux  --/U luptitudes
               tPsfMag_g 	real not null,    --/D 0 or target PhotoObj.PsfMag_g PSF flux  --/U luptitudes
               tPsfMag_r 	real not null,    --/D 0 or target PhotoObj.PsfMag_r PSF flux  --/U luptitudes
               tPsfMag_i 	real not null,    --/D 0 or target PhotoObj.PsfMag_i PSF flux  --/U luptitudes
               tPsfMag_z 	real not null,    --/D 0 or target PhotoObj.PsfMag_z PSF flux  --/U luptitudes
               tPsfMagErr_u 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_u PSF flux error --/U luptitudes
               tPsfMagErr_g 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_g PSF flux error --/U luptitudes
               tPsfMagErr_r 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_r PSF flux error --/U luptitudes
               tPsfMagErr_i 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_i PSF flux error --/U luptitudes
               tPsfMagErr_z 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_z PSF flux error --/U luptitudes
	       primary key(zone,ra,dec,specObjID, bestObjID, targetObjID)
		)
   



   