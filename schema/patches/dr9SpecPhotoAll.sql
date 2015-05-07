-- Patch to update SpecPhotoAll schema - add spec.sdssPrimary. [ART]

--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SpecPhotoAll')
	DROP TABLE SpecPhotoAll
GO
--
EXEC spSetDefaultFileGroup 'SpecPhotoAll'
GO
CREATE TABLE SpecPhotoAll (
-------------------------------------------------------------------------------
--/H The combined spectro and photo parameters of an object in SpecObjAll
--
--/T This is a precomputed join between the PhotoObjAll and SpecObjAll tables.
--/T The photo attibutes included cover about the same as PhotoTag.
--/T The table also includes certain attributes from Tiles.
-------------------------------------------------------------------------------
	specObjID	bigint NOT NULL,	--/D Unique ID --/K ID_CATALOG
	mjd		int NOT NULL,		--/D MJD of observation --/U MJD --/K TIME_DATE
	plate		smallint NOT NULL, 	--/D Plate ID --/K ID_PLATE
	tile		smallint NOT NULL,  	--/D Tile ID --/K ID_PLATE
	fiberID		smallint NOT NULL,	--/D Fiber ID --/K ID_FIBER
	z		real NOT NULL,		--/D Final Redshift --/K REDSHIFT
	zErr		real NOT NULL,		--/D Redshift error --/K REDSHIFT ERROR
	class		varchar(32) NOT NULL,	--/D Spectroscopic class (GALAXY, QSO, or STAR)
	subClass	varchar(32) NOT NULL,	--/D Spectroscopic subclass
	zWarning	int NOT NULL,		--/D Warning Flags --/R SpeczWarning --/K CODE_QUALITY
	ra		float NOT NULL,		--/D ra in J2000 from SpecObj --/U deg --/K POS_EQ_RA_MAIN
	dec		float NOT NULL,		--/D dec in J2000 from SpecObj --/U deg --/K POS_EQ_DEC_MAIN
	cx 		float 	NOT NULL,	--/D x of Normal unit vector in J2000 --/K POS_EQ_CART_X?
	cy 		float 	NOT NULL,  	--/D y of Normal unit vector in J2000 --/K POS_EQ_CART_Y?
	cz 		float 	NOT NULL,  	--/D z of Normal unit vector in J2000 --/K POS_EQ_CART_Z?
	htmID 		bigint 	NOT NULL, 	--/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM
	sciencePrimary	smallint NOT NULL,	--/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
	legacyPrimary	smallint NOT NULL,	--/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
	seguePrimary	smallint NOT NULL,	--/D Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj) --/F specsegue
	segue1Primary	smallint NOT NULL,	--/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue1
	segue2Primary	smallint NOT NULL,	--/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue2
	bossPrimary	smallint NOT NULL,	--/D Best version of spectrum at this location, among BOSS plates --/F specboss
	sdssPrimary     smallint NOT NULL,	--/D Best version of spectrum at this location among SDSS plates --/F specsdss
	survey	varchar(32) NOT NULL,		--/D Survey name
	programname	varchar(32) NOT NULL,	--/D Program name
	legacy_target1	bigint NOT NULL,	--/D for Legacy program, target selection information at plate design --/F legacy_target1
	legacy_target2	bigint NOT NULL,	--/D for Legacy program target selection information at plate design, secondary/qa/calibration --/F legacy_target2
	special_target1	bigint NOT NULL,	--/D for Special program target selection information at plate design --/F special_target1
	special_target2	bigint NOT NULL,	--/D for Special program target selection information at plate design, secondary/qa/calibration --/F special_target2
	segue1_target1	bigint NOT NULL,	--/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1
	segue1_target2	bigint NOT NULL,	--/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection --/F segue1_target2
	segue2_target1	bigint NOT NULL,	--/D SEGUE-2 target selection information at plate design, primary science selection --/F segue2_target1
	segue2_target2	bigint NOT NULL,	--/D SEGUE-2 target selection information at plate design, secondary/qa/calib selection --/F segue2_target2
	boss_target1	bigint NOT NULL,	--/D BOSS target selection information at plate  --/F boss_target1
	ancillary_target1	bigint NOT NULL,	--/D BOSS ancillary science target selection information at plate design --/F ancillary_target1
	ancillary_target2	bigint NOT NULL,	--/D BOSS ancillary target selection information at plate design --/F ancillary_target2
	plateID		bigint NOT NULL,	--/D Link to plate on which the spectrum was taken --/K ID_PLATE
	sourceType	varchar(32) NOT NULL,	--/D type of object targeted as --/R ObjType --/K CLASS_OBJECT
	targetObjID	bigint NOT NULL,	--/D ID of target PhotoObj --/K ID_CATALOG
-------------------------------------------------------------------------------
	objID		bigint ,	--/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj]. --/K ID_CATALOG
	skyVersion	int ,	--/D 0 = OPDB target, 1 = OPDB best --/K CODE_MISC
	run		int ,	--/D Run number --/K OBS_RUN
	rerun		int ,	--/D Rerun number --/K CODE_MISC
	camcol		int ,	--/D Camera column --/K INST_ID
	field		int ,	--/D Field number --/K ID_FIELD
	obj		int ,	--/D The object id within a field. Usually changes between reruns of the same field. --/K ID_NUMBER
	mode		int ,	--/D  1: primary, 2: secondary, 3: family object. --/K CLASS_OBJECT
	nChild		int ,	--/D Number of children if this is a deblened composite object. BRIGHT (in a flags sense) objects also have nchild==1, the non-BRIGHT sibling. --/K NUMBER
	type		int ,	--/D Morphological type classification of the object. --/R PhotoType --/K CLASS_OBJECT
	flags		bigint ,	--/D Photo Object Attribute Flags  --/R PhotoFlags --/K CODE_MISC
	psfMag_u	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_U
	psfMag_g	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_G
	psfMag_r	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_R
	psfMag_i	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_I
	psfMag_z	real ,	--/D PSF flux --/U mag --/K PHOT_SDSS_Z
	psfMagErr_u	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_U ERROR
	psfMagErr_g	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_G ERROR
	psfMagErr_r	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_R ERROR
	psfMagErr_i	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_I ERROR
	psfMagErr_z	real ,	--/D PSF flux error --/U mag --/K PHOT_SDSS_Z ERROR
	fiberMag_u	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_U
	fiberMag_g	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_G
	fiberMag_r	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_R
	fiberMag_i	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_I
	fiberMag_z	real ,	--/D Flux in 3 arcsec diameter fiber radius --/U mag --/K PHOT_SDSS_Z
	fiberMagErr_u	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_U ERROR
	fiberMagErr_g	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_G ERROR
	fiberMagErr_r	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_R ERROR
	fiberMagErr_i	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_I ERROR
	fiberMagErr_z	real ,	--/D Flux in 3 arcsec diameter fiber radius error --/U mag --/K PHOT_SDSS_Z ERROR
	petroMag_u	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_U
	petroMag_g	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_G
	petroMag_r	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_R
	petroMag_i	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_I
	petroMag_z	real ,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_Z
	petroMagErr_u	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_U ERROR
	petroMagErr_g	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_G ERROR
	petroMagErr_r	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_R ERROR
	petroMagErr_i	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_I ERROR
	petroMagErr_z	real ,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_Z ERROR
	modelMag_u	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_U FIT_PARAM
	modelMag_g	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_G FIT_PARAM
	modelMag_r	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_R FIT_PARAM
	modelMag_i	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_I FIT_PARAM
	modelMag_z	real ,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_Z FIT_PARAM
	modelMagErr_u	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_U ERROR
	modelMagErr_g	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_G ERROR
	modelMagErr_r	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_R ERROR
	modelMagErr_i	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_I ERROR
	modelMagErr_z	real ,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_Z ERROR
	cModelMag_u     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMag_g     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMag_r     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMag_i     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMag_z     real ,	--/U mag --/D DeV+Exp magnitude 
	cModelMagErr_u  real ,	--/U mag --/D DeV+Exp magnitude error
	cModelMagErr_g  real ,	--/U mag --/D DeV+Exp magnitude error
	cModelMagErr_r  real ,	--/U mag --/D DeV+Exp magnitude error
	cModelMagErr_i  real ,	--/U mag --/D DeV+Exp magnitude error
	cModelMagErr_z  real ,	--/U mag --/D DeV+Exp magnitude error
	mRrCc_r		real ,	--/D Adaptive (<r^2> + <c^2>) --/K FIT_PARAM
	mRrCcErr_r	real ,	--/D Error in adaptive (<r^2> + <c^2>) --/K FIT_PARAM ERROR
	score           real ,	--/D Quality of field (0-1)
	resolveStatus   int ,	--/D Resolve status of object
	calibStatus_u   int ,	--/D Calibration status in u-band
	calibStatus_g   int ,	--/D Calibration status in g-band
	calibStatus_r   int ,	--/D Calibration status in r-band
	calibStatus_i   int ,	--/D Calibration status in i-band
	calibStatus_z   int ,	--/D Calibration status in z-band
	photoRa		float ,	--/D J2000 right ascension (r') from Best --/U deg --/K POS_EQ_RA_MAIN
	photoDec	float ,	--/D J2000 declination (r') from Best --/U deg --/K POS_EQ_DEC_MAIN
	extinction_u	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_g	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_r	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_i	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_z	real ,	--/D Reddening in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	fieldID 	bigint ,	--/D Link to the field this object is in --/K ID_FIELD
	dered_u		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_U
	dered_g		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_G
	dered_r		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_R
	dered_i		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_I
	dered_z		real ,	--/D Simplified mag, corrected for reddening: modelMag-reddening --/U mag --/K PHOT_SDSS_Z
)
GO



