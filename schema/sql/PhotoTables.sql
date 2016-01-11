--=============================================================================
--   PhotoTables.sql
--   2009-04-27 Ani Thakar and Mike Blanton
-------------------------------------------------------------------------------
--  SDSS III Photo Schema for SQL Server
--
--------------------------------------------------------------------
-- History:
--* 2009-04-27  Ani: Swapped in updated schema for photo tables for SDSS-III.
--*                  Added new table Run.
--* 2009-05-05  Ani: Added loadVersion to Field table.
--* 2009-06-11  Ani: Added nProf_[ugriz] to Field table.
--* 2009-08-14  Ani: Removed status, primTarget and secTarget columns from
--*             PhotoTag (they are no longer in PhotoObjAll).
--* 2009-12-09  Ani: Changed Run.comments to varchar(128) from varchar(32).
--* 2010-01-13  Victor: Updated Table name 'Objmask' to 'AtlasOutline'. Also on dependencies (dbo.spsetvalues)
--* 2010-06-17  Naren/Vamsi/Ani : Added external catalog tables.
--* 2010-07-02  Ani: Fixed FLDEPOCH column names (added survey suffixes) in USNO table.
--* 2010-07-08  Ani: Removed duplicate definition of First table.
--* 2010-07-14  Ani: For consistency (acronym) changed table name First->FIRST.
--* 2010-11-17  Ani: Replaced ProperMotions schema with sas-sql version.
--* 2010-11-18  Ani: Changed AtlasOutline.span to varchar(max) from text.
--* 2010-12-10  Ani: Removed PhotoTag table definition (view now).
--* 2010-12-22  Ani: Updated PhotoObjAll.clean flag description (not just
--*                  for point sources now) and PhotoProfile units
--*                  (nanomaggies/arcsec^2 instead if maggies/arcsec^2).
--* 2011-01-26  Ani: Removed Photoz2 table.
--* 2011-01-26  Ani: Made minor format change to Photoz description.
--* 2011-02-07  Ani: Removed Photoz2 reference from description of Photoz.
--* 2011-02-18  Ani: Added Photoz* tables from Istvan Csabai.  
--* 2011-05-20  Ani: Added schema for DR7 xmatch tables.
--* 2011-05-26  Ani: Deleted FieldQA and RunQA tables.
--* 2011-06-08  Ani: Added column descriptions for PhotoPrimaryDR7 and
--*                  PhotoObjDR7 from DR7 schema.
--* 2011-09-27  Ani: Reinstated --/R tags for enumerated and bit columns,
--*                  as per per PR #1444.  Added new --/R links for
--*                  CalibStatus and ImageStatus in Field table.
--* 2011-09-29  Ani: Added Postage Stamp Pipeline to description of 
--*                  Field.pspStatus.
--* 2011-10-11  Ani: Added (center) ra,dec columns to Field table.
--* 2012-02-16  Ani: Added schema for astromDR9 and ProperMotionsDR9 tables.
--* 2012-07-12  Ani: Changed exp/deV a/b to b/a in descriptions.
--* 2012-07-27  Ani: Changed units for muStart, muEnd, nuStart, nuEnd in 
--*                  Field, added "64 pixel clipped" to description.
--* 2012-07-29  Ani: Deleted astromDR9 and ProperMotionsDR9.
--* 2012-08-15  Ani: Fixed swapped units and descriptions in some columns
--*                  of PhotoObjAll (PR #1606).
--* 2013-05-14  Ani: Added WISE tables.
--* 2013-05-21  Ani: Made all WISE columns NOT NULL.
--* 2013-07-25  Ani: Swapped in WISE table and column metadata.
--* 2013-08-07  Ani: Replaced "<", ">" with " < ", " > " resp. in WISE column
--*                  descriptions.
--* 2013-08-16  Ani: Updated descriptions of exponential and de Vaucouleurs
--*                  fit scale radii to indicate they are half-light radii.
--* 2013-10-30  Ani: Added computed column rjce to WISE_allsky to get the
--*                  dereddening index for APOGEE target selection (PR #1909). 
--* 2014-02-10  Ani: Added glat, glon columns to WISE_allsky (PR #1913).
--* 2015-02-09  Ani: Moved Photoz tables to new PhotoZTables.sql file.
--* 2016-01-11  Ani: Added history entry for previous change: modified Field
--*                  tables to change fieldOffset_[ugriz] columns from INT to
--*                  REAL.
--=============================================================================
SET NOCOUNT ON
GO
--


--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'Field')
	DROP TABLE Field
GO
--
EXEC spSetDefaultFileGroup 'Field'
GO
CREATE TABLE Field (
-------------------------------------------------------------------------------
--/H All the measured parameters and calibrations of a photometric field
-------------------------------------------------------------------------------
--/T A field is a 2048x1489 pixel section of a camera column. 
--/T This table contains summary results of the photometric 
--/T and calibration pipelines for each field.
-------------------------------------------------------------------------------
	fieldID			bigint NOT NULL,	--/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field].
	skyVersion		tinyint NOT NULL,	--/D Layer of catalog (currently only one layer, 0; 0-15 available)
	run			smallint NOT NULL,	--/D Run number
	rerun			smallint NOT NULL,	--/D Rerun number
	camcol			tinyint NOT NULL,	--/D Camera column
	field			smallint NOT NULL,	--/D Field number
	nTotal			smallint NOT NULL,	--/D Number of total objects in the field
	nObjects		smallint NOT NULL,	--/D Number of non-bright objects in the field
	nChild			smallint NOT NULL,	--/D Number of "child" objects in the field
	nGalaxy			smallint NOT NULL,	--/D Number of objects classified as "galaxy" --/F ngals
	nStars			smallint NOT NULL,	--/D Number of objects classified as "star"
	nCR_u			smallint NOT NULL,	--/D Number of cosmics in u-band 
	nCR_g			smallint NOT NULL,	--/D Number of cosmics in g-band 
	nCR_r			smallint NOT NULL,	--/D Number of cosmics in r-band 
	nCR_i			smallint NOT NULL,	--/D Number of cosmics in i-band 
	nCR_z			smallint NOT NULL,	--/D Number of cosmics in z-band 
	nBrightObj_u		smallint NOT NULL,	--/D Number of bright objects in u-band 
	nBrightObj_g		smallint NOT NULL,	--/D Number of bright objects in g-band 
	nBrightObj_r		smallint NOT NULL,	--/D Number of bright objects in r-band 
	nBrightObj_i		smallint NOT NULL,	--/D Number of bright objects in i-band 
	nBrightObj_z		smallint NOT NULL,	--/D Number of bright objects in z-band 
	nFaintObj_u		smallint NOT NULL,	--/D Number of faint objects in u-band 
	nFaintObj_g		smallint NOT NULL,	--/D Number of faint objects in g-band 
	nFaintObj_r		smallint NOT NULL,	--/D Number of faint objects in r-band 
	nFaintObj_i		smallint NOT NULL,	--/D Number of faint objects in i-band 
	nFaintObj_z		smallint NOT NULL,	--/D Number of faint objects in z-band 
	quality			[int] NOT NULL,		--/D Quality of field --/R FieldQuality 
	mjd_u			float NOT NULL,		--/D MJD(TAI) when row 0 of u-band field was read
	mjd_g			float NOT NULL,		--/D MJD(TAI) when row 0 of g-band field was read
	mjd_r			float NOT NULL,		--/D MJD(TAI) when row 0 of r-band field was read
	mjd_i			float NOT NULL,		--/D MJD(TAI) when row 0 of i-band field was read
	mjd_z			float NOT NULL,		--/D MJD(TAI) when row 0 of z-band field was read
	a_u			real NOT NULL,		--/D a term in astrometry for u-band
	a_g			real NOT NULL,		--/D a term in astrometry for g-band
	a_r			real NOT NULL,		--/D a term in astrometry for r-band
	a_i			real NOT NULL,		--/D a term in astrometry for i-band
	a_z			real NOT NULL,		--/D a term in astrometry for z-band
	b_u			real NOT NULL,		--/D b term in astrometry for u-band
	b_g			real NOT NULL,		--/D b term in astrometry for g-band
	b_r			real NOT NULL,		--/D b term in astrometry for r-band
	b_i			real NOT NULL,		--/D b term in astrometry for i-band
	b_z			real NOT NULL,		--/D b term in astrometry for z-band
	c_u			real NOT NULL,		--/D c term in astrometry for u-band
	c_g			real NOT NULL,		--/D c term in astrometry for g-band
	c_r			real NOT NULL,		--/D c term in astrometry for r-band
	c_i			real NOT NULL,		--/D c term in astrometry for i-band
	c_z			real NOT NULL,		--/D c term in astrometry for z-band
	d_u			real NOT NULL,		--/D d term in astrometry for u-band
	d_g			real NOT NULL,		--/D d term in astrometry for g-band
	d_r			real NOT NULL,		--/D d term in astrometry for r-band
	d_i			real NOT NULL,		--/D d term in astrometry for i-band
	d_z			real NOT NULL,		--/D d term in astrometry for z-band
	e_u			real NOT NULL,		--/D e term in astrometry for u-band
	e_g			real NOT NULL,		--/D e term in astrometry for g-band
	e_r			real NOT NULL,		--/D e term in astrometry for r-band
	e_i			real NOT NULL,		--/D e term in astrometry for i-band
	e_z			real NOT NULL,		--/D e term in astrometry for z-band
	f_u			real NOT NULL,		--/D f term in astrometry for u-band
	f_g			real NOT NULL,		--/D f term in astrometry for g-band
	f_r			real NOT NULL,		--/D f term in astrometry for r-band
	f_i			real NOT NULL,		--/D f term in astrometry for i-band
	f_z			real NOT NULL,		--/D f term in astrometry for z-band
	dRow0_u			real NOT NULL,		--/D Zero-order row distortion coefficient in u-band
	dRow0_g			real NOT NULL,		--/D Zero-order row distortion coefficient in g-band
	dRow0_r			real NOT NULL,		--/D Zero-order row distortion coefficient in r-band
	dRow0_i			real NOT NULL,		--/D Zero-order row distortion coefficient in i-band
	dRow0_z			real NOT NULL,		--/D Zero-order row distortion coefficient in z-band
	dRow1_u			real NOT NULL,		--/D First-order row distortion coefficient in u-band
	dRow1_g			real NOT NULL,		--/D First-order row distortion coefficient in g-band
	dRow1_r			real NOT NULL,		--/D First-order row distortion coefficient in r-band
	dRow1_i			real NOT NULL,		--/D First-order row distortion coefficient in i-band
	dRow1_z			real NOT NULL,		--/D First-order row distortion coefficient in z-band
	dRow2_u			real NOT NULL,		--/D Second-order row distortion coefficient in u-band
	dRow2_g			real NOT NULL,		--/D Second-order row distortion coefficient in g-band
	dRow2_r			real NOT NULL,		--/D Second-order row distortion coefficient in r-band
	dRow2_i			real NOT NULL,		--/D Second-order row distortion coefficient in i-band
	dRow2_z			real NOT NULL,		--/D Second-order row distortion coefficient in z-band
	dRow3_u			real NOT NULL,		--/D Third-order row distortion coefficient in u-band
	dRow3_g			real NOT NULL,		--/D Third-order row distortion coefficient in g-band
	dRow3_r			real NOT NULL,		--/D Third-order row distortion coefficient in r-band
	dRow3_i			real NOT NULL,		--/D Third-order row distortion coefficient in i-band
	dRow3_z			real NOT NULL,		--/D Third-order row distortion coefficient in z-band
	dCol0_u			real NOT NULL,		--/D Zero-order column distortion coefficient in u-band
	dCol0_g			real NOT NULL,		--/D Zero-order column distortion coefficient in g-band
	dCol0_r			real NOT NULL,		--/D Zero-order column distortion coefficient in r-band
	dCol0_i			real NOT NULL,		--/D Zero-order column distortion coefficient in i-band
	dCol0_z			real NOT NULL,		--/D Zero-order column distortion coefficient in z-band
	dCol1_u			real NOT NULL,		--/D First-order column distortion coefficient in u-band
	dCol1_g			real NOT NULL,		--/D First-order column distortion coefficient in g-band
	dCol1_r			real NOT NULL,		--/D First-order column distortion coefficient in r-band
	dCol1_i			real NOT NULL,		--/D First-order column distortion coefficient in i-band
	dCol1_z			real NOT NULL,		--/D First-order column distortion coefficient in z-band
	dCol2_u			real NOT NULL,		--/D Second-order column distortion coefficient in u-band
	dCol2_g			real NOT NULL,		--/D Second-order column distortion coefficient in g-band
	dCol2_r			real NOT NULL,		--/D Second-order column distortion coefficient in r-band
	dCol2_i			real NOT NULL,		--/D Second-order column distortion coefficient in i-band
	dCol2_z			real NOT NULL,		--/D Second-order column distortion coefficient in z-band
	dCol3_u			real NOT NULL,		--/D Third-order column distortion coefficient in u-band
	dCol3_g			real NOT NULL,		--/D Third-order column distortion coefficient in g-band
	dCol3_r			real NOT NULL,		--/D Third-order column distortion coefficient in r-band
	dCol3_i			real NOT NULL,		--/D Third-order column distortion coefficient in i-band
	dCol3_z			real NOT NULL,		--/D Third-order column distortion coefficient in z-band
	csRow_u			real NOT NULL,		--/D Slope in row DCR correction for blue objects (u-band)
	csRow_g			real NOT NULL,		--/D Slope in row DCR correction for blue objects (g-band)
	csRow_r			real NOT NULL,		--/D Slope in row DCR correction for blue objects (r-band)
	csRow_i			real NOT NULL,		--/D Slope in row DCR correction for blue objects (i-band)
	csRow_z			real NOT NULL,		--/D Slope in row DCR correction for blue objects (z-band)
	csCol_u			real NOT NULL,		--/D Slope in column DCR correction for blue objects (u-band)
	csCol_g			real NOT NULL,		--/D Slope in column DCR correction for blue objects (g-band)
	csCol_r			real NOT NULL,		--/D Slope in column DCR correction for blue objects (r-band)
	csCol_i			real NOT NULL,		--/D Slope in column DCR correction for blue objects (i-band)
	csCol_z			real NOT NULL,		--/D Slope in column DCR correction for blue objects (z-band)
	ccRow_u			real NOT NULL,		--/D Constant row DCR correction for blue objects (u-band)
	ccRow_g			real NOT NULL,		--/D Constant row DCR correction for blue objects (g-band)
	ccRow_r			real NOT NULL,		--/D Constant row DCR correction for blue objects (r-band)
	ccRow_i			real NOT NULL,		--/D Constant row DCR correction for blue objects (i-band)
	ccRow_z			real NOT NULL,		--/D Constant row DCR correction for blue objects (z-band)
	ccCol_u			real NOT NULL,		--/D Constant column DCR correction for blue objects (u-band)
	ccCol_g			real NOT NULL,		--/D Constant column DCR correction for blue objects (g-band)
	ccCol_r			real NOT NULL,		--/D Constant column DCR correction for blue objects (r-band)
	ccCol_i			real NOT NULL,		--/D Constant column DCR correction for blue objects (i-band)
	ccCol_z			real NOT NULL,		--/D Constant column DCR correction for blue objects (z-band)
	riCut_u			real NOT NULL,		--/D r-i cutoff between blue and red objects (for u-band astrometry)
	riCut_g			real NOT NULL,		--/D r-i cutoff between blue and red objects (for g-band astrometry)
	riCut_r			real NOT NULL,		--/D r-i cutoff between blue and red objects (for r-band astrometry)
	riCut_i			real NOT NULL,		--/D r-i cutoff between blue and red objects (for i-band astrometry)
	riCut_z			real NOT NULL,		--/D r-i cutoff between blue and red objects (for z-band astrometry)
	airmass_u		real NOT NULL,		--/U mag --/D	Airmass for star at frame center (midway through u-band exposure)
	airmass_g		real NOT NULL,		--/U mag --/D	Airmass for star at frame center (midway through g-band exposure)
	airmass_r		real NOT NULL,		--/U mag --/D	Airmass for star at frame center (midway through r-band exposure)
	airmass_i		real NOT NULL,		--/U mag --/D	Airmass for star at frame center (midway through i-band exposure)
	airmass_z		real NOT NULL,		--/U mag --/D	Airmass for star at frame center (midway through z-band exposure)
	muErr_u			real NOT NULL,		--/U arcsec --/D Error in mu in astrometric calibration (for u-band)
	muErr_g			real NOT NULL,		--/U arcsec --/D Error in mu in astrometric calibration (for g-band)
	muErr_r			real NOT NULL,		--/U arcsec --/D Error in mu in astrometric calibration (for r-band)
	muErr_i			real NOT NULL,		--/U arcsec --/D Error in mu in astrometric calibration (for i-band)
	muErr_z			real NOT NULL,		--/U arcsec --/D Error in mu in astrometric calibration (for z-band)
	nuErr_u			real NOT NULL,		--/U arcsec --/D Error in nu in astrometric calibration (for u-band)
	nuErr_g			real NOT NULL,		--/U arcsec --/D Error in nu in astrometric calibration (for g-band)
	nuErr_r			real NOT NULL,		--/U arcsec --/D Error in nu in astrometric calibration (for r-band)
	nuErr_i			real NOT NULL,		--/U arcsec --/D Error in nu in astrometric calibration (for i-band)
	nuErr_z			real NOT NULL,		--/U arcsec --/D Error in nu in astrometric calibration (for z-band)
	ra   			float NOT NULL,		--/U deg --/D Center RA of field
	dec   			float NOT NULL,		--/U deg --/D Center Dec of field
	raMin			float NOT NULL,		--/U deg --/D Minimum RA of field
	raMax			float NOT NULL,		--/U deg --/D Maximum RA of field
	decMin			float NOT NULL,		--/U deg --/D Minimum Dec of field
	decMax			float NOT NULL,		--/U deg --/D Maximum Dec of field
	pixScale		float NOT NULL,		--/U arcsec/pix --/D Mean size of pixel (r-band)
	primaryArea		float NOT NULL,		--/U deg^2 --/D Area covered by primary part of field
	photoStatus		[int] NOT NULL,		--/D Frames processing status bitmask --/R FrameStatus 
	rowOffset_u		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (u-band)
	rowOffset_g		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (g-band)
	rowOffset_r		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (r-band)
	rowOffset_i		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (i-band)
	rowOffset_z		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (z-band)
	colOffset_u		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (u-band)
	colOffset_g		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (g-band)
	colOffset_r		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (r-band)
	colOffset_i		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (i-band)
	colOffset_z		real NOT NULL, 		--/U pix --/D Offset to add to transformed row coordinates (z-band)
	saturationLevel_u	[int] NOT NULL, 	--/U counts --/D Saturation level in u-band
	saturationLevel_g	[int] NOT NULL, 	--/U counts --/D Saturation level in g-band
	saturationLevel_r	[int] NOT NULL, 	--/U counts --/D Saturation level in r-band
	saturationLevel_i	[int] NOT NULL, 	--/U counts --/D Saturation level in i-band
	saturationLevel_z	[int] NOT NULL,		--/U counts --/D Saturation level in z-band
	nEffPsf_u		real NOT NULL,		--/U pix --/D Effective area of PSF (u-band)
	nEffPsf_g		real NOT NULL,		--/U pix --/D Effective area of PSF (g-band)
	nEffPsf_r		real NOT NULL,		--/U pix --/D Effective area of PSF (r-band)
	nEffPsf_i		real NOT NULL,		--/U pix --/D Effective area of PSF (i-band)
	nEffPsf_z		real NOT NULL,		--/U pix --/D Effective area of PSF (z-band)
	skyPsp_u		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sky estimate from PSP (u-band) 
	skyPsp_g		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sky estimate from PSP (g-band) 
	skyPsp_r		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sky estimate from PSP (r-band) 
	skyPsp_i		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sky estimate from PSP (i-band) 
	skyPsp_z		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sky estimate from PSP (z-band) 
	skyFrames_u		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value 
	skyFrames_g		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value 
	skyFrames_r		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value 
	skyFrames_i		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value 
	skyFrames_z		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value 
	skyFramesSub_u		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value after object subtraction 
	skyFramesSub_g		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value after object subtraction 
	skyFramesSub_r		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value after object subtraction 
	skyFramesSub_i		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value after object subtraction 
	skyFramesSub_z		real NOT NULL,		--/U nmgy/arcsec^2 --/D Frames sky value after object subtraction 
	sigPix_u		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sigma of pixel values in u-band frame (clipped)
	sigPix_g		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sigma of pixel values in g-band frame (clipped)
	sigPix_r		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sigma of pixel values in r-band frame (clipped)
	sigPix_i		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sigma of pixel values in i-band frame (clipped)
	sigPix_z		real NOT NULL,		--/U nmgy/arcsec^2 --/D Sigma of pixel values in z-band frame (clipped)
	devApCorrection_u	real NOT NULL,		--/D deV aperture correction (u-band)
	devApCorrection_g	real NOT NULL,		--/D deV aperture correction (g-band)
	devApCorrection_r	real NOT NULL,		--/D deV aperture correction (r-band)
	devApCorrection_i	real NOT NULL,		--/D deV aperture correction (i-band)
	devApCorrection_z	real NOT NULL,		--/D deV aperture correction (z-band)
	devApCorrectionErr_u	real NOT NULL,		--/D Error in deV aperture correction (u-band)
	devApCorrectionErr_g	real NOT NULL,		--/D Error in deV aperture correction (g-band)
	devApCorrectionErr_r	real NOT NULL,		--/D Error in deV aperture correction (r-band)
	devApCorrectionErr_i	real NOT NULL,		--/D Error in deV aperture correction (i-band)
	devApCorrectionErr_z	real NOT NULL,		--/D Error in deV aperture correction (z-band)
	expApCorrection_u	real NOT NULL,		--/D exponential aperture correction (u-band)
	expApCorrection_g	real NOT NULL,		--/D exponential aperture correction (g-band)
	expApCorrection_r	real NOT NULL,		--/D exponential aperture correction (r-band)
	expApCorrection_i	real NOT NULL,		--/D exponential aperture correction (i-band)
	expApCorrection_z	real NOT NULL,		--/D exponential aperture correction (z-band)
	expApCorrectionErr_u	real NOT NULL,		--/D Error in exponential aperture correction (u-band)
	expApCorrectionErr_g	real NOT NULL,		--/D Error in exponential aperture correction (g-band)
	expApCorrectionErr_r	real NOT NULL,		--/D Error in exponential aperture correction (r-band)
	expApCorrectionErr_i	real NOT NULL,		--/D Error in exponential aperture correction (i-band)
	expApCorrectionErr_z	real NOT NULL,		--/D Error in exponential aperture correction (z-band)
	devModelApCorrection_u	real NOT NULL,		--/D model aperture correction, for deV case (u-band)
	devModelApCorrection_g	real NOT NULL,		--/D model aperture correction, for deV case (g-band)
	devModelApCorrection_r	real NOT NULL,		--/D model aperture correction, for deV case (r-band)
	devModelApCorrection_i	real NOT NULL,		--/D model aperture correction, for deV case (i-band)
	devModelApCorrection_z	real NOT NULL,		--/D model aperture correction, for deV case (z-band)
	devModelApCorrectionErr_u	real NOT NULL,	--/D Error in model aperture correction, for deV case (u-band)
	devModelApCorrectionErr_g	real NOT NULL,	--/D Error in model aperture correction, for deV case (g-band)
	devModelApCorrectionErr_r	real NOT NULL,	--/D Error in model aperture correction, for deV case (r-band)
	devModelApCorrectionErr_i	real NOT NULL,	--/D Error in model aperture correction, for deV case (i-band)
	devModelApCorrectionErr_z	real NOT NULL,	--/D Error in model aperture correction, for deV case (z-band)
	expModelApCorrection_u	real NOT NULL,		--/D model aperture correction, for exponential case (u-band)
	expModelApCorrection_g	real NOT NULL,		--/D model aperture correction, for exponential case (g-band)
	expModelApCorrection_r	real NOT NULL,		--/D model aperture correction, for exponential case (r-band)
	expModelApCorrection_i	real NOT NULL,		--/D model aperture correction, for exponential case (i-band)
	expModelApCorrection_z	real NOT NULL,		--/D model aperture correction, for exponential case (z-band)
	expModelApCorrectionErr_u	real NOT NULL,	--/D Error in model aperture correction, for exponential case (u-band)
	expModelApCorrectionErr_g	real NOT NULL,	--/D Error in model aperture correction, for exponential case (g-band)
	expModelApCorrectionErr_r	real NOT NULL,	--/D Error in model aperture correction, for exponential case (r-band)
	expModelApCorrectionErr_i	real NOT NULL,	--/D Error in model aperture correction, for exponential case (i-band)
	expModelApCorrectionErr_z	real NOT NULL,	--/D Error in model aperture correction, for exponential case (z-band)
	medianFiberColor_u	real NOT NULL,		--/D Median fiber magnitude of objects (u-band)
	medianFiberColor_g	real NOT NULL,		--/D Median fiber magnitude of objects (g-band)
	medianFiberColor_r	real NOT NULL,		--/D Median fiber magnitude of objects (r-band)
	medianFiberColor_i	real NOT NULL,		--/D Median fiber magnitude of objects (i-band)
	medianFiberColor_z	real NOT NULL,		--/D Median fiber magnitude of objects (z-band)
	medianPsfColor_u	real NOT NULL,		--/D Median PSF magnitude of objects (u-band)
	medianPsfColor_g	real NOT NULL,		--/D Median PSF magnitude of objects (g-band)
	medianPsfColor_r	real NOT NULL,		--/D Median PSF magnitude of objects (r-band)
	medianPsfColor_i	real NOT NULL,		--/D Median PSF magnitude of objects (i-band)
	medianPsfColor_z	real NOT NULL,		--/D Median PSF magnitude of objects (z-band)
	q_u			real NOT NULL,		--/D Means Stokes Q parameter in u-band frame
	q_g			real NOT NULL,		--/D Means Stokes Q parameter in g-band frame
	q_r			real NOT NULL,		--/D Means Stokes Q parameter in r-band frame
	q_i			real NOT NULL,		--/D Means Stokes Q parameter in i-band frame
	q_z			real NOT NULL,		--/D Means Stokes Q parameter in z-band frame
	u_u			real NOT NULL,		--/D Means Stokes U parameter in u-band frame
	u_g			real NOT NULL,		--/D Means Stokes U parameter in g-band frame
	u_r			real NOT NULL,		--/D Means Stokes U parameter in r-band frame
	u_i			real NOT NULL,		--/D Means Stokes U parameter in i-band frame
	u_z			real NOT NULL,		--/D Means Stokes U parameter in z-band frame
	pspStatus		smallint NOT NULL,	--/D Maximum value of PSP (Postage Stamp Pipeline) status over all 5 filters --/R PspStatus 
	sky_u			real NOT NULL,		--/U nmgy/arcsec^2 --/D PSP estimate of sky in u-band 
	sky_g			real NOT NULL,		--/U nmgy/arcsec^2 --/D PSP estimate of sky in g-band 
	sky_r			real NOT NULL,		--/U nmgy/arcsec^2 --/D PSP estimate of sky in r-band 
	sky_i			real NOT NULL,		--/U nmgy/arcsec^2 --/D PSP estimate of sky in i-band 
	sky_z			real NOT NULL,		--/U nmgy/arcsec^2 --/D PSP estimate of sky in z-band 
	skySig_u		real NOT NULL,		--/U mag --/D 	Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5
	skySig_g		real NOT NULL,		--/U mag --/D 	Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5
	skySig_r		real NOT NULL,		--/U mag --/D 	Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5
	skySig_i		real NOT NULL,		--/U mag --/D 	Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5
	skySig_z		real NOT NULL,		--/U mag --/D 	Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5
	skyErr_u		real NOT NULL,		--/U nmgy/arcsec^2 --/D Error in PSP estimate of sky in u-band 
	skyErr_g		real NOT NULL,		--/U nmgy/arcsec^2 --/D Error in PSP estimate of sky in g-band 
	skyErr_r		real NOT NULL,		--/U nmgy/arcsec^2 --/D Error in PSP estimate of sky in r-band 
	skyErr_i		real NOT NULL,		--/U nmgy/arcsec^2 --/D Error in PSP estimate of sky in i-band 
	skyErr_z		real NOT NULL,		--/U nmgy/arcsec^2 --/D Error in PSP estimate of sky in z-band 
	skySlope_u		real NOT NULL,		--/U nmgy/arcsec^2/field --/D Rate of change in sky value along columns (u-band)
	skySlope_g		real NOT NULL,		--/U nmgy/arcsec^2/field --/D Rate of change in sky value along columns (g-band)
	skySlope_r		real NOT NULL,		--/U nmgy/arcsec^2/field --/D Rate of change in sky value along columns (r-band)
	skySlope_i		real NOT NULL,		--/U nmgy/arcsec^2/field --/D Rate of change in sky value along columns (i-band)
	skySlope_z		real NOT NULL,		--/U nmgy/arcsec^2/field --/D Rate of change in sky value along columns (z-band)
	lbias_u			real NOT NULL,		--/U ADUs --/D Left-hand amplifier bias level (u-band)		XXX make sure to apply DSCALE, counts or ADU?
	lbias_g			real NOT NULL,		--/U ADUs --/D Left-hand amplifier bias level (g-band) 
	lbias_r			real NOT NULL,		--/U ADUs --/D Left-hand amplifier bias level (r-band) 
	lbias_i			real NOT NULL,		--/U ADUs --/D Left-hand amplifier bias level (i-band) 
	lbias_z			real NOT NULL,		--/U ADUs --/D Left-hand amplifier bias level (z-band) 
	rbias_u			real NOT NULL,		--/U ADUs --/D Right-hand amplifier bias level (u-band) 
	rbias_g			real NOT NULL,		--/U ADUs --/D Right-hand amplifier bias level (g-band) 
	rbias_r			real NOT NULL,		--/U ADUs --/D Right-hand amplifier bias level (r-band) 
	rbias_i			real NOT NULL,		--/U ADUs --/D Right-hand amplifier bias level (i-band) 
	rbias_z			real NOT NULL,		--/U ADUs --/D Right-hand amplifier bias level (z-band) 
	nProf_u			[int] NOT NULL,		--/D Number of bins in PSF profile (in fieldProfile table) --/F prof_nprof 0
	nProf_g			[int] NOT NULL,		--/D Number of bins in PSF profile (in fieldProfile table) --/F prof_nprof 1
	nProf_r			[int] NOT NULL,		--/D Number of bins in PSF profile (in fieldProfile table) --/F prof_nprof 2
	nProf_i			[int] NOT NULL,		--/D Number of bins in PSF profile (in fieldProfile table) --/F prof_nprof 3
	nProf_z			[int] NOT NULL,		--/D Number of bins in PSF profile (in fieldProfile table) --/F prof_nprof 4
	psfNStar_u		[int] NOT NULL,		--/D Number of stars used in PSF measurement (u-band)
	psfNStar_g		[int] NOT NULL,		--/D Number of stars used in PSF measurement (g-band)
	psfNStar_r		[int] NOT NULL,		--/D Number of stars used in PSF measurement (r-band)
	psfNStar_i		[int] NOT NULL,		--/D Number of stars used in PSF measurement (i-band)
	psfNStar_z		[int] NOT NULL,		--/D Number of stars used in PSF measurement (z-band)
	psfApCorrectionErr_u	real NOT NULL,		--/U mag  --/D Photometric uncertainty due to imperfect PSF model (u-band)
	psfApCorrectionErr_g	real NOT NULL,		--/U mag  --/D Photometric uncertainty due to imperfect PSF model (g-band)
	psfApCorrectionErr_r	real NOT NULL,		--/U mag  --/D Photometric uncertainty due to imperfect PSF model (r-band)
	psfApCorrectionErr_i	real NOT NULL,		--/U mag  --/D Photometric uncertainty due to imperfect PSF model (i-band)
	psfApCorrectionErr_z	real NOT NULL,		--/U mag  --/D Photometric uncertainty due to imperfect PSF model (z-band)
	psfSigma1_u		real NOT NULL,		--/U arcsec --/D Inner gaussian sigma for composite fit 
	psfSigma1_g		real NOT NULL,		--/U arcsec --/D Inner gaussian sigma for composite fit 
	psfSigma1_r		real NOT NULL,		--/U arcsec --/D Inner gaussian sigma for composite fit
	psfSigma1_i		real NOT NULL,		--/U arcsec --/D Inner gaussian sigma for composite fit
	psfSigma1_z		real NOT NULL,		--/U arcsec --/D Inner gaussian sigma for composite fit
	psfSigma2_u		real NOT NULL,		--/U arcsec --/D Outer gaussian sigma for composite fit 
	psfSigma2_g		real NOT NULL,		--/U arcsec --/D Outer gaussian sigma for composite fit 
	psfSigma2_r		real NOT NULL,		--/U arcsec --/D Outer gaussian sigma for composite fit
	psfSigma2_i		real NOT NULL,		--/U arcsec --/D Outer gaussian sigma for composite fit
	psfSigma2_z		real NOT NULL,		--/U arcsec --/D Outer gaussian sigma for composite fit
	psfB_u			real NOT NULL,		--/D Ratio of inner to outer components at origin (composite fit)
	psfB_g			real NOT NULL,		--/D Ratio of inner to outer components at origin (composite fit)
	psfB_r			real NOT NULL,		--/D Ratio of inner to outer components at origin (composite fit)
	psfB_i			real NOT NULL,		--/D Ratio of inner to outer components at origin (composite fit)
	psfB_z			real NOT NULL,		--/D Ratio of inner to outer components at origin (composite fit)
	psfP0_u			real NOT NULL,		--/D Value of power law at origin in composite fit  XXX
	psfP0_g			real NOT NULL,		--/D Value of power law at origin in composite fit  XXX
	psfP0_r			real NOT NULL,          --/D Value of power law at origin in composite fit  XXX
	psfP0_i			real NOT NULL,          --/D Value of power law at origin in composite fit  XXX
	psfP0_z			real NOT NULL,          --/D Value of power law at origin in composite fit  XXX
	psfBeta_u		real NOT NULL,          --/D Slope of power law in composite fit 
	psfBeta_g		real NOT NULL,          --/D Slope of power law in composite fit 
	psfBeta_r		real NOT NULL,          --/D Slope of power law in composite fit 
	psfBeta_i		real NOT NULL,          --/D Slope of power law in composite fit 
	psfBeta_z		real NOT NULL,          --/D Slope of power law in composite fit 
	psfSigmaP_u		real NOT NULL,          --/D Width of power law in composite fit 
	psfSigmaP_g		real NOT NULL,          --/D Width of power law in composite fit 
	psfSigmaP_r		real NOT NULL,          --/D Width of power law in composite fit 
	psfSigmaP_i		real NOT NULL,          --/D Width of power law in composite fit 
	psfSigmaP_z		real NOT NULL,          --/D Width of power law in composite fit 
	psfWidth_u		real NOT NULL,		--/U arcsec --/D Effective PSF width from 2-Gaussian fit (u-band)
	psfWidth_g		real NOT NULL,		--/U arcsec --/D Effective PSF width from 2-Gaussian fit (g-band)
	psfWidth_r		real NOT NULL,		--/U arcsec --/D Effective PSF width from 2-Gaussian fit (r-band)
	psfWidth_i		real NOT NULL,		--/U arcsec --/D Effective PSF width from 2-Gaussian fit (i-band)
	psfWidth_z		real NOT NULL,		--/U arcsec --/D Effective PSF width from 2-Gaussian fit (z-band)
	psfPsfCounts_u		real NOT NULL,		--/U counts --/D Flux via fit to PSF (u-band) XXX 
	psfPsfCounts_g		real NOT NULL,		--/U counts --/D Flux via fit to PSF (g-band) XXX
	psfPsfCounts_r		real NOT NULL,		--/U counts --/D Flux via fit to PSF (r-band) XXX
	psfPsfCounts_i		real NOT NULL,		--/U counts --/D Flux via fit to PSF (i-band) XXX
	psfPsfCounts_z		real NOT NULL,		--/U counts --/D Flux via fit to PSF (z-band) XXX
	psf2GSigma1_u		real NOT NULL,		--/U arcsec --/D Sigma of inner gaussian in 2-Gaussian fit (u-band) --/F psf_sigma1_2g
	psf2GSigma1_g		real NOT NULL,		--/U arcsec --/D Sigma of inner gaussian in 2-Gaussian fit (g-band) --/F psf_sigma1_2g
	psf2GSigma1_r		real NOT NULL,		--/U arcsec --/D Sigma of inner gaussian in 2-Gaussian fit (r-band) --/F psf_sigma1_2g
	psf2GSigma1_i		real NOT NULL,		--/U arcsec --/D Sigma of inner gaussian in 2-Gaussian fit (i-band) --/F psf_sigma1_2g
	psf2GSigma1_z		real NOT NULL,		--/U arcsec --/D Sigma of inner gaussian in 2-Gaussian fit (z-band) --/F psf_sigma1_2g
	psf2GSigma2_u		real NOT NULL,		--/U arcsec --/D Sigma of outer gaussian in 2-Gaussian fit (u-band) --/F psf_sigma2_2g
	psf2GSigma2_g		real NOT NULL,		--/U arcsec --/D Sigma of outer gaussian in 2-Gaussian fit (g-band) --/F psf_sigma2_2g
	psf2GSigma2_r		real NOT NULL,		--/U arcsec --/D Sigma of outer gaussian in 2-Gaussian fit (r-band) --/F psf_sigma2_2g
	psf2GSigma2_i		real NOT NULL,		--/U arcsec --/D Sigma of outer gaussian in 2-Gaussian fit (i-band) --/F psf_sigma2_2g
	psf2GSigma2_z		real NOT NULL,		--/U arcsec --/D Sigma of outer gaussian in 2-Gaussian fit (z-band) --/F psf_sigma2_2g
	psf2GB_u		real NOT NULL,		--/D Ratio of inner to outer components at origin (2-Gaussian fit) --/F psf_b_2g
	psf2GB_g		real NOT NULL,		--/D Ratio of inner to outer components at origin (2-Gaussian fit) --/F psf_b_2g
	psf2GB_r		real NOT NULL,		--/D Ratio of inner to outer components at origin (2-Gaussian fit) --/F psf_b_2g
	psf2GB_i		real NOT NULL,		--/D Ratio of inner to outer components at origin (2-Gaussian fit) --/F psf_b_2g
	psf2GB_z		real NOT NULL,		--/D Ratio of inner to outer components at origin (2-Gaussian fit) --/F psf_b_2g
	psfCounts_u		real NOT NULL,		--/U counts --/D PSF counts XXX
	psfCounts_g		real NOT NULL,		--/U counts --/D PSF counts XXX
	psfCounts_r		real NOT NULL,		--/U counts --/D PSF counts XXX
	psfCounts_i		real NOT NULL,		--/U counts --/D PSF counts XXX
	psfCounts_z		real NOT NULL,		--/U counts --/D PSF counts XXX
	gain_u			real NOT NULL,		--/U electrons/DN --/D Gain averaged over amplifiers 
	gain_g			real NOT NULL,		--/U electrons/DN --/D Gain averaged over amplifiers 
	gain_r			real NOT NULL,		--/U electrons/DN --/D Gain averaged over amplifiers 
	gain_i			real NOT NULL,		--/U electrons/DN --/D Gain averaged over amplifiers 
	gain_z			real NOT NULL,		--/U electrons/DN --/D Gain averaged over amplifiers 
	darkVariance_u		real NOT NULL,		--/D Dark variance
	darkVariance_g		real NOT NULL,		--/D Dark variance
	darkVariance_r		real NOT NULL,		--/D Dark variance
	darkVariance_i		real NOT NULL,		--/D Dark variance
	darkVariance_z		real NOT NULL,		--/D Dark variance
	score			real NOT NULL, --/D Quality of field (0-1)
	aterm_u			real NOT NULL, --/U nmgy/count --/D nanomaggies per count due to instrument
	aterm_g			real NOT NULL, --/U nmgy/count --/D nanomaggies per count due to instrument
	aterm_r			real NOT NULL, --/U nmgy/count --/D nanomaggies per count due to instrument
	aterm_i			real NOT NULL, --/U nmgy/count --/D nanomaggies per count due to instrument
	aterm_z			real NOT NULL, --/U nmgy/count --/D nanomaggies per count due to instrument
	kterm_u			real NOT NULL, --/D atmospheric k-term at reference time in calibration
	kterm_g			real NOT NULL, --/D atmospheric k-term at reference time in calibration
	kterm_r			real NOT NULL, --/D atmospheric k-term at reference time in calibration
	kterm_i			real NOT NULL, --/D atmospheric k-term at reference time in calibration
	kterm_z			real NOT NULL, --/D atmospheric k-term at reference time in calibration
	kdot_u			real NOT NULL, --/U 1/second --/D linear time variation of atmospheric k-term 
	kdot_g			real NOT NULL, --/U 1/second --/D linear time variation of atmospheric k-term 
	kdot_r			real NOT NULL, --/U 1/second --/D linear time variation of atmospheric k-term 
	kdot_i			real NOT NULL, --/U 1/second --/D linear time variation of atmospheric k-term 
	kdot_z			real NOT NULL, --/U 1/second --/D linear time variation of atmospheric k-term 
	reftai_u		float NOT NULL, --/U second --/D reference TAI used for k-term
	reftai_g		float NOT NULL, --/U second --/D reference TAI used for k-term
	reftai_r		float NOT NULL, --/U second --/D reference TAI used for k-term
	reftai_i		float NOT NULL, --/U second --/D reference TAI used for k-term
	reftai_z		float NOT NULL, --/U second --/D reference TAI used for k-term
	tai_u			float NOT NULL, --/U second --/D TAI used for k-term
	tai_g			float NOT NULL, --/U second --/D TAI used for k-term
	tai_r			float NOT NULL, --/U second --/D TAI used for k-term
	tai_i			float NOT NULL, --/U second --/D TAI used for k-term
	tai_z			float NOT NULL, --/U second --/D TAI used for k-term
	nStarsOffset_u		[int] NOT NULL, --/D number of stars used for fieldOffset determination
	nStarsOffset_g		[int] NOT NULL, --/D number of stars used for fieldOffset determination
	nStarsOffset_r		[int] NOT NULL, --/D number of stars used for fieldOffset determination
	nStarsOffset_i		[int] NOT NULL, --/D number of stars used for fieldOffset determination
	nStarsOffset_z		[int] NOT NULL, --/D number of stars used for fieldOffset determination
	fieldOffset_u		[real] NOT NULL, --/U mag --/D offset of field from initial calibration (final minus initial magnitudes)
	fieldOffset_g		[real] NOT NULL, --/U mag --/D offset of field from initial calibration (final minus initial magnitudes)
	fieldOffset_r		[real] NOT NULL, --/U mag --/D offset of field from initial calibration (final minus initial magnitudes)
	fieldOffset_i		[real] NOT NULL, --/U mag --/D offset of field from initial calibration (final minus initial magnitudes)
	fieldOffset_z		[real] NOT NULL, --/U mag --/D offset of field from initial calibration (final minus initial magnitudes)
	calibStatus_u		[int] NOT NULL, --/D calibration status bitmask --/R CalibStatus
	calibStatus_g		[int] NOT NULL, --/D calibration status bitmask --/R CalibStatus
	calibStatus_r		[int] NOT NULL, --/D calibration status bitmask --/R CalibStatus
	calibStatus_i		[int] NOT NULL, --/D calibration status bitmask --/R CalibStatus
	calibStatus_z		[int] NOT NULL, --/D calibration status bitmask --/R CalibStatus
	imageStatus_u		[int] NOT NULL, --/D image status bitmask --/R ImageStatus
	imageStatus_g		[int] NOT NULL, --/D image status bitmask --/R ImageStatus
	imageStatus_r		[int] NOT NULL, --/D image status bitmask --/R ImageStatus
	imageStatus_i		[int] NOT NULL, --/D image status bitmask --/R ImageStatus
	imageStatus_z		[int] NOT NULL, --/D image status bitmask --/R ImageStatus
	nMgyPerCount_u		real NOT NULL, --/U nmgy/count --/D nanomaggies per count in u-band
	nMgyPerCount_g		real NOT NULL, --/U nmgy/count --/D nanomaggies per count in g-band
	nMgyPerCount_r		real NOT NULL, --/U nmgy/count --/D nanomaggies per count in r-band
	nMgyPerCount_i		real NOT NULL, --/U nmgy/count --/D nanomaggies per count in i-band
	nMgyPerCount_z		real NOT NULL, --/U nmgy/count --/D nanomaggies per count in z-band
	nMgyPerCountIvar_u	real NOT NULL, --/U (nmgy/count)^{-2} --/D Inverse variance of nanomaggies per count in u-band
	nMgyPerCountIvar_g	real NOT NULL, --/U (nmgy/count)^{-2} --/D Inverse variance of nanomaggies per count in g-band
	nMgyPerCountIvar_r	real NOT NULL, --/U (nmgy/count)^{-2} --/D Inverse variance of nanomaggies per count in r-band
	nMgyPerCountIvar_i	real NOT NULL, --/U (nmgy/count)^{-2} --/D Inverse variance of nanomaggies per count in i-band
	nMgyPerCountIvar_z	real NOT NULL, --/U (nmgy/count)^{-2} --/D Inverse variance of nanomaggies per count in z-band
	ifield			[int] NOT NULL,		---/D field id used by resolve pipeline
	muStart			float NOT NULL,		--/U arcsec --/D start of field in stripe coords (parallel to scan direction, 64 pixels clipped)
	muEnd			float NOT NULL,		--/U arcsec --/D end of field in stripe coords (parallel to scan direction, 64 pixels clipped)
	nuStart			float NOT NULL,		--/U arcsec --/D start of field in stripe coords (perpendicular to scan direction, 64 pixels clipped)
	nuEnd			float NOT NULL,		--/U arcsec --/D end of field in stripe coords (perpendicular to scan direction, 64 pixels clipped)
	ifindx			[int] NOT NULL,		--/D first entry for this field in the "findx" table matching fields and balkans
	nBalkans		[int] NOT NULL,			--/D number of balkans contained in this field (and corresponding number of entries in the "findx" table)
	loadVersion		[int] NOT NULL,		--/D Load Version  --/F NOFITS
)
GO
--


--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotoObjAll')
	DROP TABLE PhotoObjAll
GO
--
EXEC spSetDefaultFileGroup 'PhotoObjAll'
GO
CREATE TABLE PhotoObjAll (
-------------------------------------------------------------------------------
--/H The full photometric catalog quantities for SDSS imaging.
-------------------------------------------------------------------------------
--/T This table contains one entry per detection, with the associated 
--/T photometric parameters measured by PHOTO, and astrometrically 
--/T and photometrically calibrated. 
--/T <p>
--/T The table has the following  views:
--/T <ul>
--/T <li> <b>PhotoObj</b>: all primary and secondary objects; essentially this is the view you should use unless you want a specific type of object.
--/T <li> <b>PhotoPrimary</b>: all photo objects that are primary (the best version of the object).
--/T <ul><li> <b>Star</b>: Primary objects that are classified as stars.
--/T     <li> <b>Galaxy</b>: Primary objects that are classified as galaxies.
--/T	   <li> <b>Sky</b>:Primary objects which are sky samples.
--/T     <li> <b>Unknown</b>:Primary objects which are no0ne of the above</ul>
--/T     <li> <b>PhotoSecondary</b>: all photo objects that are secondary (secondary detections)
--/T     <li> <b>PhotoFamily</b>: all photo objects which are neither primary nor secondary (blended)
--/T </ul>
--/T <p> The table has indices that cover the popular columns.
-------------------------------------------------------------------------------
	objID            bigint NOT NULL,     --/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].
	skyVersion       tinyint NOT NULL,    --/D Layer of catalog (currently only one layer, 0; 0-15 available)
	run              smallint NOT NULL,   --/D Run number
	rerun            smallint NOT NULL,   --/D Rerun number
	camcol           tinyint NOT NULL,    --/D Camera column
	field            smallint NOT NULL,   --/D Field number
	obj              smallint NOT NULL,   --/D The object id within a field. Usually changes between reruns of the same field --/F id
	mode             tinyint NOT NULL,    --/D 1: primary, 2: secondary, 3: other --/R PhotoMode 
	nChild           smallint NOT NULL,   --/D Number of children if this is a composite object that has been deblended. BRIGHT (in a flags sense) objects also have nchild == 1, the non-BRIGHT sibling.
	type             smallint NOT NULL,   --/D Type classification of the object (star, galaxy, cosmic ray, etc.)  --/R PhotoType --/F objc_type
	clean            [int] NOT NULL,        --/D Clean photometry flag (1=clean, 0=unclean).
	probPSF          real NOT NULL,       --/D Probability that the object is a star. Currently 0 if type == 3 (galaxy), 1 if type == 6 (star).  --/F objc_prob_psf
	insideMask       tinyint NOT NULL,    --/D Flag to indicate whether object is inside a mask and why --/R InsideMask --/F NOFITS
	flags            bigint NOT NULL,     --/D Photo Object Attribute Flags --/R PhotoFlags --/F objc_flags
	rowc             real NOT NULL,       --/U pix --/D Row center position (r-band coordinates) --/F objc_rowc
	rowcErr          real NOT NULL,       --/U pix --/D Row center position error (r-band coordinates) --/F objc_rowcerr
	colc             real NOT NULL,       --/U pix --/D Column center position (r-band coordinates) --/F objc_colc
	colcErr          real NOT NULL,       --/U pix --/D Column center position error (r-band coordinates) --/F objc_colcerr
	rowv             real NOT NULL,       --/U deg/day --/D  Row-component of object's velocity --/F rowvdeg
	rowvErr          real NOT NULL,       --/U deg/day --/D Row-component of object's velocity error --/F rowvdegerr
	colv             real NOT NULL,       --/U deg/day --/D Column-component of object's velocity	--/F colvdeg
	colvErr          real NOT NULL,       --/U deg/day --/D Column-component of object's velocity error --/F colvdegerr
	rowc_u           real NOT NULL,       --/U pix --/D Row center, u-band
	rowc_g           real NOT NULL,       --/U pix --/D Row center, g-band
	rowc_r           real NOT NULL,       --/U pix --/D Row center, r-band
	rowc_i           real NOT NULL,       --/U pix --/D Row center, i-band
	rowc_z           real NOT NULL,       --/U pix --/D Row center, z-band
	rowcErr_u        real NOT NULL,       --/U pix --/D ERROR Row center error, u-band
	rowcErr_g        real NOT NULL,       --/U pix --/D ERROR Row center error, g-band
	rowcErr_r        real NOT NULL,       --/U pix --/D ERROR Row center error, r-band
	rowcErr_i        real NOT NULL,       --/U pix --/D ERROR Row center error, i-band
	rowcErr_z        real NOT NULL,       --/U pix --/D ERROR Row center error, z-band
	colc_u           real NOT NULL,       --/U pix --/D Column center, u-band
	colc_g           real NOT NULL,       --/U pix --/D Column center, g-band
	colc_r           real NOT NULL,       --/U pix --/D Column center, r-band
	colc_i           real NOT NULL,       --/U pix --/D Column center, i-band
	colc_z           real NOT NULL,       --/U pix --/D Column center, z-band
	colcErr_u        real NOT NULL,       --/U pix --/D Column center error, u-band
	colcErr_g        real NOT NULL,       --/U pix --/D Column center error, g-band
	colcErr_r        real NOT NULL,       --/U pix --/D Column center error, r-band
	colcErr_i        real NOT NULL,       --/U pix --/D Column center error, i-band
	colcErr_z        real NOT NULL,       --/U pix --/D Column center error, z-band
	sky_u            real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux at the center of object (allowing for siblings if blended). --/F skyflux
	sky_g            real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux at the center of object (allowing for siblings if blended). --/F skyflux
	sky_r            real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux at the center of object (allowing for siblings if blended). --/F skyflux
	sky_i            real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux at the center of object (allowing for siblings if blended). --/F skyflux
	sky_z            real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux at the center of object (allowing for siblings if blended). --/F skyflux
	skyIvar_u         real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux inverse variance --/F skyflux_ivar
	skyIvar_g         real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux inverse variance --/F skyflux_ivar
	skyIvar_r         real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux inverse variance --/F skyflux_ivar
	skyIvar_i         real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux inverse variance --/F skyflux_ivar
	skyIvar_z         real NOT NULL,       --/U nanomaggies/arcsec^2  --/D Sky flux inverse variance --/F skyflux_ivar
	psfMag_u         real NOT NULL,       --/U mag --/D PSF magnitude
	psfMag_g         real NOT NULL,       --/U mag --/D PSF magnitude
	psfMag_r         real NOT NULL,       --/U mag --/D PSF magnitude
	psfMag_i         real NOT NULL,       --/U mag --/D PSF magnitude
	psfMag_z         real NOT NULL,       --/U mag --/D PSF magnitude
	psfMagErr_u      real NOT NULL,       --/U mag --/D PSF magnitude error
	psfMagErr_g      real NOT NULL,       --/U mag --/D PSF magnitude error
	psfMagErr_r      real NOT NULL,       --/U mag --/D PSF magnitude error
	psfMagErr_i      real NOT NULL,       --/U mag --/D PSF magnitude error
	psfMagErr_z      real NOT NULL,       --/U mag --/D PSF magnitude error
	fiberMag_u       real NOT NULL,       --/U mag --/D Magnitude in 3 arcsec diameter fiber radius
	fiberMag_g       real NOT NULL,       --/U mag --/D Magnitude in 3 arcsec diameter fiber radius
	fiberMag_r       real NOT NULL,       --/U mag --/D Magnitude in 3 arcsec diameter fiber radius
	fiberMag_i       real NOT NULL,       --/U mag --/D Magnitude in 3 arcsec diameter fiber radius
	fiberMag_z       real NOT NULL,       --/U mag --/D Magnitude in 3 arcsec diameter fiber radius
	fiberMagErr_u    real NOT NULL,     --/U mag --/D Error in magnitude in 3 arcsec diameter fiber radius 
	fiberMagErr_g    real NOT NULL,     --/U mag --/D Error in magnitude in 3 arcsec diameter fiber radius 
	fiberMagErr_r    real NOT NULL,     --/U mag --/D Error in magnitude in 3 arcsec diameter fiber radius 
	fiberMagErr_i    real NOT NULL,     --/U mag --/D Error in magnitude in 3 arcsec diameter fiber radius 
	fiberMagErr_z    real NOT NULL,     --/U mag --/D Error in magnitude in 3 arcsec diameter fiber radius 
	fiber2Mag_u      real NOT NULL,       --/U mag --/D Magnitude in 2 arcsec diameter fiber radius
	fiber2Mag_g      real NOT NULL,       --/U mag --/D Magnitude in 2 arcsec diameter fiber radius
	fiber2Mag_r      real NOT NULL,       --/U mag --/D Magnitude in 2 arcsec diameter fiber radius
	fiber2Mag_i      real NOT NULL,       --/U mag --/D Magnitude in 2 arcsec diameter fiber radius
	fiber2Mag_z      real NOT NULL,       --/U mag --/D Magnitude in 2 arcsec diameter fiber radius
	fiber2MagErr_u   real NOT NULL,     --/U mag --/D Error in magnitude in 2 arcsec diameter fiber radius 
	fiber2MagErr_g   real NOT NULL,     --/U mag --/D Error in magnitude in 2 arcsec diameter fiber radius 
	fiber2MagErr_r   real NOT NULL,     --/U mag --/D Error in magnitude in 2 arcsec diameter fiber radius 
	fiber2MagErr_i   real NOT NULL,     --/U mag --/D Error in magnitude in 2 arcsec diameter fiber radius 
	fiber2MagErr_z   real NOT NULL,     --/U mag --/D Error in magnitude in 2 arcsec diameter fiber radius 
	petroMag_u       real NOT NULL,       --/U mag --/D Petrosian magnitude
	petroMag_g       real NOT NULL,       --/U mag --/D Petrosian magnitude
	petroMag_r       real NOT NULL,       --/U mag --/D Petrosian magnitude
	petroMag_i       real NOT NULL,       --/U mag --/D Petrosian magnitude
	petroMag_z       real NOT NULL,       --/U mag --/D Petrosian magnitude
	petroMagErr_u    real NOT NULL,      --/U mag --/D Petrosian magnitude error
	petroMagErr_g    real NOT NULL,      --/U mag --/D Petrosian magnitude error
	petroMagErr_r    real NOT NULL,      --/U mag --/D Petrosian magnitude error
	petroMagErr_i    real NOT NULL,      --/U mag --/D Petrosian magnitude error
	petroMagErr_z    real NOT NULL,      --/U mag --/D Petrosian magnitude error
	psfFlux_u        real NOT NULL,      --/U nanomaggies --/D PSF flux 
	psfFlux_g        real NOT NULL,      --/U nanomaggies --/D PSF flux
	psfFlux_r        real NOT NULL,      --/U nanomaggies --/D PSF flux
	psfFlux_i        real NOT NULL,      --/U nanomaggies --/D PSF flux
	psfFlux_z        real NOT NULL,      --/U nanomaggies --/D PSF flux
	psfFluxIvar_u    real NOT NULL,      --/U nanomaggies^{-2}  --/D PSF flux inverse variance
	psfFluxIvar_g    real NOT NULL,      --/U nanomaggies^{-2}  --/D PSF flux inverse variance
	psfFluxIvar_r    real NOT NULL,      --/U nanomaggies^{-2}  --/D PSF flux inverse variance
	psfFluxIvar_i    real NOT NULL,      --/U nanomaggies^{-2}  --/D PSF flux inverse variance
	psfFluxIvar_z    real NOT NULL,      --/U nanomaggies^{-2}  --/D PSF flux inverse variance
	fiberFlux_u      real NOT NULL,   --/U nanomaggies --/D Flux in 3 arcsec diameter fiber radius
	fiberFlux_g      real NOT NULL,   --/U nanomaggies --/D Flux in 3 arcsec diameter fiber radius
	fiberFlux_r      real NOT NULL,   --/U nanomaggies --/D Flux in 3 arcsec diameter fiber radius
	fiberFlux_i      real NOT NULL,   --/U nanomaggies --/D Flux in 3 arcsec diameter fiber radius
	fiberFlux_z      real NOT NULL,   --/U nanomaggies --/D Flux in 3 arcsec diameter fiber radius
	fiberFluxIvar_u  real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 3 arcsec diameter fiber radius
	fiberFluxIvar_g  real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 3 arcsec diameter fiber radius
	fiberFluxIvar_r  real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 3 arcsec diameter fiber radius
	fiberFluxIvar_i  real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 3 arcsec diameter fiber radius
	fiberFluxIvar_z  real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 3 arcsec diameter fiber radius
	fiber2Flux_u     real NOT NULL,   --/U nanomaggies --/D Flux in 2 arcsec diameter fiber radius
	fiber2Flux_g     real NOT NULL,   --/U nanomaggies --/D Flux in 2 arcsec diameter fiber radius
	fiber2Flux_r     real NOT NULL,   --/U nanomaggies --/D Flux in 2 arcsec diameter fiber radius
	fiber2Flux_i     real NOT NULL,   --/U nanomaggies --/D Flux in 2 arcsec diameter fiber radius
	fiber2Flux_z     real NOT NULL,   --/U nanomaggies --/D Flux in 2 arcsec diameter fiber radius
	fiber2FluxIvar_u real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 2 arcsec diameter fiber radius 
	fiber2FluxIvar_g real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 2 arcsec diameter fiber radius 
	fiber2FluxIvar_r real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 2 arcsec diameter fiber radius
	fiber2FluxIvar_i real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 2 arcsec diameter fiber radius
	fiber2FluxIvar_z real NOT NULL,   --/U nanomaggies^{-2}  --/D Inverse variance in flux in 2 arcsec diameter fiber radius
	petroFlux_u      real NOT NULL,   --/U nanomaggies --/D Petrosian flux
	petroFlux_g      real NOT NULL,   --/U nanomaggies --/D Petrosian flux
	petroFlux_r      real NOT NULL,   --/U nanomaggies --/D Petrosian flux
	petroFlux_i      real NOT NULL,   --/U nanomaggies --/D Petrosian flux
	petroFlux_z      real NOT NULL,   --/U nanomaggies --/D Petrosian flux
	petroFluxIvar_u  real NOT NULL,   --/U nanomaggies^{-2}  --/D Petrosian flux inverse variance
	petroFluxIvar_g  real NOT NULL,   --/U nanomaggies^{-2}  --/D Petrosian flux inverse variance
	petroFluxIvar_r  real NOT NULL,   --/U nanomaggies^{-2}  --/D Petrosian flux inverse variance
	petroFluxIvar_i  real NOT NULL,   --/U nanomaggies^{-2}  --/D Petrosian flux inverse variance
	petroFluxIvar_z  real NOT NULL,   --/U nanomaggies^{-2}  --/D Petrosian flux inverse variance
	petroRad_u       real NOT NULL,   --/U arcsec  --/D Petrosian radius --/F petrotheta
	petroRad_g       real NOT NULL,   --/U arcsec  --/D Petrosian radius --/F petrotheta
	petroRad_r       real NOT NULL,   --/U arcsec  --/D Petrosian radius --/F petrotheta
	petroRad_i       real NOT NULL,   --/U arcsec  --/D Petrosian radius --/F petrotheta
	petroRad_z       real NOT NULL,   --/U arcsec  --/D Petrosian radius --/F petrotheta
	petroRadErr_u    real NOT NULL,   --/U arcsec  --/D Petrosian radius error --/F petrothetaerr
	petroRadErr_g    real NOT NULL,   --/U arcsec  --/D Petrosian radius error --/F petrothetaerr
	petroRadErr_r    real NOT NULL,   --/U arcsec  --/D Petrosian radius error --/F petrothetaerr
	petroRadErr_i    real NOT NULL,   --/U arcsec  --/D Petrosian radius error --/F petrothetaerr
	petroRadErr_z    real NOT NULL,   --/U arcsec  --/D Petrosian radius error --/F petrothetaerr
	petroR50_u       real NOT NULL,   --/U arcsec  --/D Radius containing 50% of Petrosian flux --/F petroth50
	petroR50_g       real NOT NULL,   --/U arcsec  --/D Radius containing 50% of Petrosian flux --/F petroth50
	petroR50_r       real NOT NULL,   --/U arcsec  --/D Radius containing 50% of Petrosian flux --/F petroth50
	petroR50_i       real NOT NULL,   --/U arcsec  --/D Radius containing 50% of Petrosian flux --/F petroth50
	petroR50_z       real NOT NULL,   --/U arcsec  --/D Radius containing 50% of Petrosian flux --/F petroth50
	petroR50Err_u    real NOT NULL,   --/U arcsec  --/D Error in radius with 50% of Petrosian flux error --/F petroth50err
	petroR50Err_g    real NOT NULL,   --/U arcsec  --/D Error in radius with 50% of Petrosian flux error --/F petroth50err
	petroR50Err_r    real NOT NULL,   --/U arcsec  --/D Error in radius with 50% of Petrosian flux error --/F petroth50err
	petroR50Err_i    real NOT NULL,   --/U arcsec  --/D Error in radius with 50% of Petrosian flux error --/F petroth50err
	petroR50Err_z    real NOT NULL,   --/U arcsec  --/D Error in radius with 50% of Petrosian flux error --/F petroth50err
	petroR90_u       real NOT NULL,   --/U arcsec  --/D Radius containing 90% of Petrosian flux --/F petroth90
	petroR90_g       real NOT NULL,   --/U arcsec  --/D Radius containing 90% of Petrosian flux --/F petroth90
	petroR90_r       real NOT NULL,   --/U arcsec  --/D Radius containing 90% of Petrosian flux --/F petroth90
	petroR90_i       real NOT NULL,   --/U arcsec  --/D Radius containing 90% of Petrosian flux --/F petroth90
	petroR90_z       real NOT NULL,   --/U arcsec  --/D Radius containing 90% of Petrosian flux --/F petroth90
	petroR90Err_u    real NOT NULL,   --/U arcsec  --/D Error in radius with 90% of Petrosian flux error --/F petroth90err
	petroR90Err_g    real NOT NULL,   --/U arcsec  --/D Error in radius with 90% of Petrosian flux error --/F petroth90err
	petroR90Err_r    real NOT NULL,   --/U arcsec  --/D Error in radius with 90% of Petrosian flux error --/F petroth90err
	petroR90Err_i    real NOT NULL,   --/U arcsec  --/D Error in radius with 90% of Petrosian flux error --/F petroth90err
	petroR90Err_z    real NOT NULL,   --/U arcsec  --/D Error in radius with 90% of Petrosian flux error --/F petroth90err
	q_u              real NOT NULL,   --/D Stokes Q parameter
	q_g              real NOT NULL,   --/D Stokes Q parameter
	q_r              real NOT NULL,   --/D Stokes Q parameter
	q_i              real NOT NULL,   --/D Stokes Q parameter
	q_z              real NOT NULL,   --/D Stokes Q parameter
	qErr_u           real NOT NULL,   --/D Stokes Q parameter error
	qErr_g           real NOT NULL,   --/D Stokes Q parameter error
	qErr_r           real NOT NULL,   --/D Stokes Q parameter error
	qErr_i           real NOT NULL,   --/D Stokes Q parameter error
	qErr_z           real NOT NULL,   --/D Stokes Q parameter error
	u_u              real NOT NULL,   --/D Stokes U parameter
	u_g              real NOT NULL,   --/D Stokes U parameter
	u_r              real NOT NULL,   --/D Stokes U parameter
	u_i              real NOT NULL,   --/D Stokes U parameter
	u_z              real NOT NULL,   --/D Stokes U parameter
	uErr_u           real NOT NULL,   --/D Stokes U parameter error
	uErr_g           real NOT NULL,   --/D Stokes U parameter error
	uErr_r           real NOT NULL,   --/D Stokes U parameter error
	uErr_i           real NOT NULL,   --/D Stokes U parameter error
	uErr_z           real NOT NULL,   --/D Stokes U parameter error
	mE1_u            real NOT NULL,   --/D Adaptive E1 shape measure (pixel coordinates)
	mE1_g            real NOT NULL,   --/D Adaptive E1 shape measure (pixel coordinates)
	mE1_r            real NOT NULL,   --/D Adaptive E1 shape measure (pixel coordinates)
	mE1_i            real NOT NULL,   --/D Adaptive E1 shape measure (pixel coordinates)
	mE1_z            real NOT NULL,   --/D Adaptive E1 shape measure (pixel coordinates)
	mE2_u            real NOT NULL,   --/D Adaptive E2 shape measure (pixel coordinates)
	mE2_g            real NOT NULL,   --/D Adaptive E2 shape measure (pixel coordinates)
	mE2_r            real NOT NULL,   --/D Adaptive E2 shape measure (pixel coordinates)
	mE2_i            real NOT NULL,   --/D Adaptive E2 shape measure (pixel coordinates)
	mE2_z            real NOT NULL,   --/D Adaptive E2 shape measure (pixel coordinates)
	mE1E1Err_u       real NOT NULL,   --/D Covariance in E1/E1 shape measure (pixel coordinates)
	mE1E1Err_g       real NOT NULL,   --/D Covariance in E1/E1 shape measure (pixel coordinates)
	mE1E1Err_r       real NOT NULL,   --/D Covariance in E1/E1 shape measure (pixel coordinates)
	mE1E1Err_i       real NOT NULL,   --/D Covariance in E1/E1 shape measure (pixel coordinates)
	mE1E1Err_z       real NOT NULL,   --/D Covariance in E1/E1 shape measure (pixel coordinates)
	mE1E2Err_u       real NOT NULL,   --/D Covariance in E1/E2 shape measure (pixel coordinates)
	mE1E2Err_g       real NOT NULL,   --/D Covariance in E1/E2 shape measure (pixel coordinates)
	mE1E2Err_r       real NOT NULL,   --/D Covariance in E1/E2 shape measure (pixel coordinates)
	mE1E2Err_i       real NOT NULL,   --/D Covariance in E1/E2 shape measure (pixel coordinates)
	mE1E2Err_z       real NOT NULL,   --/D Covariance in E1/E2 shape measure (pixel coordinates)
	mE2E2Err_u       real NOT NULL,   --/D Covariance in E2/E2 shape measure (pixel coordinates)
	mE2E2Err_g       real NOT NULL,   --/D Covariance in E2/E2 shape measure (pixel coordinates)
	mE2E2Err_r       real NOT NULL,   --/D Covariance in E2/E2 shape measure (pixel coordinates)
	mE2E2Err_i       real NOT NULL,   --/D Covariance in E2/E2 shape measure (pixel coordinates)
	mE2E2Err_z       real NOT NULL,   --/D Covariance in E2/E2 shape measure (pixel coordinates)
	mRrCc_u          real NOT NULL,   --/D Adaptive ( + ) (pixel coordinates)
	mRrCc_g          real NOT NULL,   --/D Adaptive ( + ) (pixel coordinates)
	mRrCc_r          real NOT NULL,   --/D Adaptive ( + ) (pixel coordinates)
	mRrCc_i          real NOT NULL,   --/D Adaptive ( + ) (pixel coordinates)
	mRrCc_z          real NOT NULL,   --/D Adaptive ( + ) (pixel coordinates)
	mRrCcErr_u       real NOT NULL,   --/D Error in adaptive ( + ) (pixel coordinates)
	mRrCcErr_g       real NOT NULL,   --/D Error in adaptive ( + ) (pixel coordinates)
	mRrCcErr_r       real NOT NULL,   --/D Error in adaptive ( + ) (pixel coordinates)
	mRrCcErr_i       real NOT NULL,   --/D Error in adaptive ( + ) (pixel coordinates)
	mRrCcErr_z       real NOT NULL,   --/D Error in adaptive ( + ) (pixel coordinates)
	mCr4_u           real NOT NULL,   --/D Adaptive fourth moment of object (pixel coordinates)
	mCr4_g           real NOT NULL,   --/D Adaptive fourth moment of object (pixel coordinates)
	mCr4_r           real NOT NULL,   --/D Adaptive fourth moment of object (pixel coordinates)
	mCr4_i           real NOT NULL,   --/D Adaptive fourth moment of object (pixel coordinates)
	mCr4_z           real NOT NULL,   --/D Adaptive fourth moment of object (pixel coordinates)
	mE1PSF_u         real NOT NULL,   --/D Adaptive E1 for PSF (pixel coordinates)
	mE1PSF_g         real NOT NULL,   --/D Adaptive E1 for PSF (pixel coordinates)
	mE1PSF_r         real NOT NULL,   --/D Adaptive E1 for PSF (pixel coordinates)
	mE1PSF_i         real NOT NULL,   --/D Adaptive E1 for PSF (pixel coordinates)
	mE1PSF_z         real NOT NULL,   --/D Adaptive E1 for PSF (pixel coordinates)
	mE2PSF_u         real NOT NULL,   --/D Adaptive E2 for PSF (pixel coordinates)
	mE2PSF_g         real NOT NULL,   --/D Adaptive E2 for PSF (pixel coordinates)
	mE2PSF_r         real NOT NULL,   --/D Adaptive E2 for PSF (pixel coordinates)
	mE2PSF_i         real NOT NULL,   --/D Adaptive E2 for PSF (pixel coordinates)
	mE2PSF_z         real NOT NULL,   --/D Adaptive E2 for PSF (pixel coordinates)
	mRrCcPSF_u       real NOT NULL,   --/D Adaptive ( + ) for PSF (pixel coordinates)
	mRrCcPSF_g       real NOT NULL,   --/D Adaptive ( + ) for PSF (pixel coordinates)
	mRrCcPSF_r       real NOT NULL,   --/D Adaptive ( + ) for PSF (pixel coordinates)
	mRrCcPSF_i       real NOT NULL,   --/D Adaptive ( + ) for PSF (pixel coordinates)
	mRrCcPSF_z       real NOT NULL,   --/D Adaptive ( + ) for PSF (pixel coordinates)
	mCr4PSF_u        real NOT NULL,   --/D Adaptive fourth moment for PSF (pixel coordinates)
	mCr4PSF_g        real NOT NULL,   --/D Adaptive fourth moment for PSF (pixel coordinates)
	mCr4PSF_r        real NOT NULL,   --/D Adaptive fourth moment for PSF (pixel coordinates)
	mCr4PSF_i        real NOT NULL,   --/D Adaptive fourth moment for PSF (pixel coordinates)
	mCr4PSF_z        real NOT NULL,   --/D Adaptive fourth moment for PSF (pixel coordinates)
	deVRad_u         real NOT NULL,   --/U arcsec  --/D de Vaucouleurs fit scale radius, here defined to be the same as the half-light radius, also called the effective radius.  --/F theta_dev
	deVRad_g         real NOT NULL,   --/U arcsec  --/D de Vaucouleurs fit scale radius, here defined to be the same as the half-light radius, also called the effective radius.  --/F theta_dev
	deVRad_r         real NOT NULL,   --/U arcsec  --/D de Vaucouleurs fit scale radius, here defined to be the same as the half-light radius, also called the effective radius.  --/F theta_dev
	deVRad_i         real NOT NULL,   --/U arcsec  --/D de Vaucouleurs fit scale radius, here defined to be the same as the half-light radius, also called the effective radius.  --/F theta_dev
	deVRad_z         real NOT NULL,   --/U arcsec  --/D de Vaucouleurs fit scale radius, here defined to be the same as the half-light radius, also called the effective radius.  --/F theta_dev
	deVRadErr_u      real NOT NULL,   --/U arcsec  --/D Error in de Vaucouleurs fit scale radius error  --/F theta_deverr
	deVRadErr_g      real NOT NULL,   --/U arcsec  --/D Error in de Vaucouleurs fit scale radius error  --/F theta_deverr
	deVRadErr_r      real NOT NULL,   --/U arcsec  --/D Error in de Vaucouleurs fit scale radius error  --/F theta_deverr
	deVRadErr_i      real NOT NULL,   --/U arcsec  --/D Error in de Vaucouleurs fit scale radius error  --/F theta_deverr
	deVRadErr_z      real NOT NULL,   --/U arcsec  --/D Error in de Vaucouleurs fit scale radius error  --/F theta_deverr
	deVAB_u          real NOT NULL,   --/D de Vaucouleurs fit b/a --/F ab_dev
	deVAB_g          real NOT NULL,   --/D de Vaucouleurs fit b/a --/F ab_dev
	deVAB_r          real NOT NULL,   --/D de Vaucouleurs fit b/a --/F ab_dev
	deVAB_i          real NOT NULL,   --/D de Vaucouleurs fit b/a --/F ab_dev
	deVAB_z          real NOT NULL,   --/D de Vaucouleurs fit b/a --/F ab_dev
	deVABErr_u       real NOT NULL,   --/D de Vaucouleurs fit b/a error --/F ab_deverr
	deVABErr_g       real NOT NULL,   --/D de Vaucouleurs fit b/a error --/F ab_deverr
	deVABErr_r       real NOT NULL,   --/D de Vaucouleurs fit b/a error --/F ab_deverr
	deVABErr_i       real NOT NULL,   --/D de Vaucouleurs fit b/a error --/F ab_deverr
	deVABErr_z       real NOT NULL,   --/D de Vaucouleurs fit b/a error --/F ab_deverr
	deVPhi_u         real NOT NULL,   --/U deg --/D de Vaucouleurs fit position angle (+N thru E)  --/F phi_dev_deg
	deVPhi_g         real NOT NULL,   --/U deg --/D de Vaucouleurs fit position angle (+N thru E)  --/F phi_dev_deg
	deVPhi_r         real NOT NULL,   --/U deg --/D de Vaucouleurs fit position angle (+N thru E)  --/F phi_dev_deg
	deVPhi_i         real NOT NULL,   --/U deg --/D de Vaucouleurs fit position angle (+N thru E)  --/F phi_dev_deg
	deVPhi_z         real NOT NULL,   --/U deg --/D de Vaucouleurs fit position angle (+N thru E)  --/F phi_dev_deg
	deVMag_u         real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit
	deVMag_g         real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit
	deVMag_r         real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit
	deVMag_i         real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit
	deVMag_z         real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit
	deVMagErr_u      real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit error
	deVMagErr_g      real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit error
	deVMagErr_r      real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit error
	deVMagErr_i      real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit error
	deVMagErr_z      real NOT NULL,   --/U mag --/D de Vaucouleurs magnitude fit error
	deVFlux_u        real NOT NULL,   --/U nanomaggies --/D de Vaucouleurs magnitude fit
	deVFlux_g        real NOT NULL,   --/U nanomaggies --/D de Vaucouleurs magnitude fit
	deVFlux_r        real NOT NULL,   --/U nanomaggies --/D de Vaucouleurs magnitude fit
	deVFlux_i        real NOT NULL,   --/U nanomaggies --/D de Vaucouleurs magnitude fit
	deVFlux_z        real NOT NULL,   --/U nanomaggies --/D de Vaucouleurs magnitude fit
	deVFluxIvar_u    real NOT NULL,   --/U nanomaggies^{-2} --/D de Vaucouleurs magnitude fit inverse variance
	deVFluxIvar_g    real NOT NULL,   --/U nanomaggies^{-2} --/D de Vaucouleurs magnitude fit inverse variance
	deVFluxIvar_r    real NOT NULL,   --/U nanomaggies^{-2} --/D de Vaucouleurs magnitude fit inverse variance
	deVFluxIvar_i    real NOT NULL,   --/U nanomaggies^{-2} --/D de Vaucouleurs magnitude fit inverse variance
	deVFluxIvar_z    real NOT NULL,   --/U nanomaggies^{-2} --/D de Vaucouleurs magnitude fit inverse variance
	expRad_u         real NOT NULL,   --/U arcsec --/D Exponential fit scale radius, here defined to be the same as the half-light radius, also called the effective radius. --/F theta_exp
	expRad_g         real NOT NULL,   --/U arcsec --/D Exponential fit scale radius, here defined to be the same as the half-light radius, also called the effective radius. --/F theta_exp
	expRad_r         real NOT NULL,   --/U arcsec --/D Exponential fit scale radius, here defined to be the same as the half-light radius, also called the effective radius. --/F theta_exp
	expRad_i         real NOT NULL,   --/U arcsec --/D Exponential fit scale radius, here defined to be the same as the half-light radius, also called the effective radius. --/F theta_exp
	expRad_z         real NOT NULL,   --/U arcsec --/D Exponential fit scale radius, here defined to be the same as the half-light radius, also called the effective radius. --/F theta_exp
	expRadErr_u      real NOT NULL,   --/U arcsec --/D Exponential fit scale radius error --/F theta_experr
	expRadErr_g      real NOT NULL,   --/U arcsec --/D Exponential fit scale radius error --/F theta_experr
	expRadErr_r      real NOT NULL,   --/U arcsec --/D Exponential fit scale radius error --/F theta_experr
	expRadErr_i      real NOT NULL,   --/U arcsec --/D Exponential fit scale radius error --/F theta_experr
	expRadErr_z      real NOT NULL,   --/U arcsec --/D Exponential fit scale radius error --/F theta_experr
	expAB_u          real NOT NULL,	--/D Exponential fit b/a --/F ab_exp
	expAB_g          real NOT NULL,	--/D Exponential fit b/a --/F ab_exp
	expAB_r          real NOT NULL,	--/D Exponential fit b/a --/F ab_exp
	expAB_i          real NOT NULL,	--/D Exponential fit b/a --/F ab_exp
	expAB_z          real NOT NULL,	--/D Exponential fit b/a --/F ab_exp
	expABErr_u       real NOT NULL,	--/D Exponential fit b/a --/F ab_experr
	expABErr_g       real NOT NULL,	--/D Exponential fit b/a --/F ab_experr
	expABErr_r       real NOT NULL,	--/D Exponential fit b/a --/F ab_experr
	expABErr_i       real NOT NULL,	--/D Exponential fit b/a --/F ab_experr
	expABErr_z       real NOT NULL,	--/D Exponential fit b/a --/F ab_experr
	expPhi_u         real NOT NULL, --/U deg --/D Exponential fit position angle (+N thru E)  --/F phi_exp_deg
	expPhi_g         real NOT NULL, --/U deg --/D Exponential fit position angle (+N thru E)  --/F phi_exp_deg
	expPhi_r         real NOT NULL, --/U deg --/D Exponential fit position angle (+N thru E)  --/F phi_exp_deg
	expPhi_i         real NOT NULL, --/U deg --/D Exponential fit position angle (+N thru E)  --/F phi_exp_deg
	expPhi_z         real NOT NULL, --/U deg --/D Exponential fit position angle (+N thru E)  --/F phi_exp_deg
	expMag_u         real NOT NULL, --/U mag --/D Exponential fit magnitude
	expMag_g         real NOT NULL, --/U mag --/D Exponential fit magnitude
	expMag_r         real NOT NULL, --/U mag --/D Exponential fit magnitude
	expMag_i         real NOT NULL, --/U mag --/D Exponential fit magnitude
	expMag_z         real NOT NULL, --/U mag --/D Exponential fit magnitude
	expMagErr_u      real NOT NULL, --/U mag --/D Exponential fit magnitude error
	expMagErr_g      real NOT NULL, --/U mag --/D Exponential fit magnitude error
	expMagErr_r      real NOT NULL, --/U mag --/D Exponential fit magnitude error
	expMagErr_i      real NOT NULL, --/U mag --/D Exponential fit magnitude error
	expMagErr_z      real NOT NULL, --/U mag --/D Exponential fit magnitude error
	modelMag_u       real NOT NULL, --/U mag --/D better of DeV/Exp magnitude fit
	modelMag_g       real NOT NULL, --/U mag --/D better of DeV/Exp magnitude fit
	modelMag_r       real NOT NULL, --/U mag --/D better of DeV/Exp magnitude fit
	modelMag_i       real NOT NULL, --/U mag --/D better of DeV/Exp magnitude fit
	modelMag_z       real NOT NULL, --/U mag --/D better of DeV/Exp magnitude fit
	modelMagErr_u    real NOT NULL, --/U mag --/D Error in better of DeV/Exp magnitude fit 
	modelMagErr_g    real NOT NULL, --/U mag --/D Error in better of DeV/Exp magnitude fit 
	modelMagErr_r    real NOT NULL, --/U mag --/D Error in better of DeV/Exp magnitude fit 
	modelMagErr_i    real NOT NULL, --/U mag --/D Error in better of DeV/Exp magnitude fit 
	modelMagErr_z    real NOT NULL, --/U mag --/D Error in better of DeV/Exp magnitude fit 
	cModelMag_u      real NOT NULL, --/U mag --/D DeV+Exp magnitude 
	cModelMag_g      real NOT NULL, --/U mag --/D DeV+Exp magnitude 
	cModelMag_r      real NOT NULL, --/U mag --/D DeV+Exp magnitude 
	cModelMag_i      real NOT NULL, --/U mag --/D DeV+Exp magnitude 
	cModelMag_z      real NOT NULL, --/U mag --/D DeV+Exp magnitude 
	cModelMagErr_u   real NOT NULL, --/U mag --/D DeV+Exp magnitude error
	cModelMagErr_g   real NOT NULL, --/U mag --/D DeV+Exp magnitude error
	cModelMagErr_r   real NOT NULL, --/U mag --/D DeV+Exp magnitude error
	cModelMagErr_i   real NOT NULL, --/U mag --/D DeV+Exp magnitude error
	cModelMagErr_z   real NOT NULL, --/U mag --/D DeV+Exp magnitude error
	expFlux_u        real NOT NULL, --/U nanomaggies --/D Exponential fit flux
	expFlux_g        real NOT NULL, --/U nanomaggies --/D Exponential fit flux
	expFlux_r        real NOT NULL, --/U nanomaggies --/D Exponential fit flux
	expFlux_i        real NOT NULL, --/U nanomaggies --/D Exponential fit flux
	expFlux_z        real NOT NULL, --/U nanomaggies --/D Exponential fit flux
	expFluxIvar_u    real NOT NULL, --/U nanomaggies^{-2} --/D Exponential fit flux inverse variance
	expFluxIvar_g    real NOT NULL, --/U nanomaggies^{-2} --/D Exponential fit flux inverse variance
	expFluxIvar_r    real NOT NULL, --/U nanomaggies^{-2} --/D Exponential fit flux inverse variance
	expFluxIvar_i    real NOT NULL, --/U nanomaggies^{-2} --/D Exponential fit flux inverse variance
	expFluxIvar_z    real NOT NULL, --/U nanomaggies^{-2} --/D Exponential fit flux inverse variance
	modelFlux_u      real NOT NULL, --/U nanomaggies --/D better of DeV/Exp flux fit
	modelFlux_g      real NOT NULL, --/U nanomaggies --/D better of DeV/Exp flux fit
	modelFlux_r      real NOT NULL, --/U nanomaggies --/D better of DeV/Exp flux fit
	modelFlux_i      real NOT NULL, --/U nanomaggies --/D better of DeV/Exp flux fit
	modelFlux_z      real NOT NULL, --/U nanomaggies --/D better of DeV/Exp flux fit
	modelFluxIvar_u  real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in better of DeV/Exp flux fit 
	modelFluxIvar_g  real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in better of DeV/Exp flux fit 
	modelFluxIvar_r  real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in better of DeV/Exp flux fit 
	modelFluxIvar_i  real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in better of DeV/Exp flux fit 
	modelFluxIvar_z  real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in better of DeV/Exp flux fit 
	cModelFlux_u     real NOT NULL, --/U nanomaggies --/D better of DeV+Exp flux 
	cModelFlux_g     real NOT NULL, --/U nanomaggies --/D better of DeV+Exp flux 
	cModelFlux_r     real NOT NULL, --/U nanomaggies --/D better of DeV+Exp flux 
	cModelFlux_i     real NOT NULL, --/U nanomaggies --/D better of DeV+Exp flux 
	cModelFlux_z     real NOT NULL, --/U nanomaggies --/D better of DeV+Exp flux 
	cModelFluxIvar_u real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in DeV+Exp flux fit 
	cModelFluxIvar_g real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in DeV+Exp flux fit 
	cModelFluxIvar_r real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in DeV+Exp flux fit 
	cModelFluxIvar_i real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in DeV+Exp flux fit 
	cModelFluxIvar_z real NOT NULL, --/U nanomaggies^{-2}  --/D Inverse variance in DeV+Exp flux fit 
	aperFlux7_u      real NOT NULL, --/U nanomaggies --/D Aperture flux within 7.3 arcsec --/F aperflux 6
	aperFlux7_g      real NOT NULL, --/U nanomaggies --/D Aperture flux within 7.3 arcsec --/F aperflux 14
	aperFlux7_r      real NOT NULL, --/U nanomaggies --/D Aperture flux within 7.3 arcsec --/F aperflux 22
	aperFlux7_i      real NOT NULL, --/U nanomaggies --/D Aperture flux within 7.3 arcsec --/F aperflux 30
	aperFlux7_z      real NOT NULL, --/U nanomaggies --/D Aperture flux within 7.3 arcsec --/F aperflux 38
	aperFlux7Ivar_u  real NOT NULL, --/U nanomaggies^{-2} --/D Inverse variance of aperture flux within 7.3 arcsec --/F aperflux_ivar 6 
	aperFlux7Ivar_g  real NOT NULL, --/U nanomaggies^{-2} --/D Inverse variance of aperture flux within 7.3 arcsec --/F aperflux_ivar 14
	aperFlux7Ivar_r  real NOT NULL, --/U nanomaggies^{-2} --/D Inverse variance of aperture flux within 7.3 arcsec --/F aperflux_ivar 22
	aperFlux7Ivar_i  real NOT NULL, --/U nanomaggies^{-2} --/D Inverse variance of aperture flux within 7.3 arcsec --/F aperflux_ivar 30 
	aperFlux7Ivar_z  real NOT NULL, --/U nanomaggies^{-2} --/D Inverse variance of aperture flux within 7.3 arcsec --/F aperflux_ivar 38
	lnLStar_u        real NOT NULL,	--/D Star ln(likelihood) --/F star_lnl
	lnLStar_g        real NOT NULL,	--/D Star ln(likelihood) --/F star_lnl
	lnLStar_r        real NOT NULL,	--/D Star ln(likelihood) --/F star_lnl
	lnLStar_i        real NOT NULL,	--/D Star ln(likelihood) --/F star_lnl
	lnLStar_z        real NOT NULL,	--/D Star ln(likelihood) --/F star_lnl
	lnLExp_u         real NOT NULL,	--/D Exponential disk fit ln(likelihood) --/F exp_lnl
	lnLExp_g         real NOT NULL,	--/D Exponential disk fit ln(likelihood)  --/F exp_lnl
	lnLExp_r         real NOT NULL,	--/D Exponential disk fit ln(likelihood)  --/F exp_lnl
	lnLExp_i         real NOT NULL,	--/D Exponential disk fit ln(likelihood)  --/F exp_lnl
	lnLExp_z         real NOT NULL,	--/D Exponential disk fit ln(likelihood)  --/F exp_lnl
	lnLDeV_u         real NOT NULL,	--/D de Vaucouleurs fit ln(likelihood) --/F dev_lnl
	lnLDeV_g         real NOT NULL,	--/D de Vaucouleurs fit ln(likelihood) --/F dev_lnl
	lnLDeV_r         real NOT NULL,	--/D de Vaucouleurs fit ln(likelihood) --/F dev_lnl
	lnLDeV_i         real NOT NULL,	--/D de Vaucouleurs fit ln(likelihood) --/F dev_lnl
	lnLDeV_z         real NOT NULL,	--/D de Vaucouleurs fit ln(likelihood) --/F dev_lnl
	fracDeV_u        real NOT NULL,	--/D Weight of deV component in deV+Exp model
	fracDeV_g        real NOT NULL,	--/D Weight of deV component in deV+Exp model
	fracDeV_r        real NOT NULL,	--/D Weight of deV component in deV+Exp model
	fracDeV_i        real NOT NULL,	--/D Weight of deV component in deV+Exp model
	fracDeV_z        real NOT NULL, --/D Weight of deV component in deV+Exp model
	flags_u          bigint NOT NULL, --/D Object detection flags per band 
	flags_g          bigint NOT NULL, --/D Object detection flags per band 
	flags_r          bigint NOT NULL, --/D Object detection flags per band 
	flags_i          bigint NOT NULL, --/D Object detection flags per band 
	flags_z          bigint NOT NULL, --/D Object detection flags per band 
	type_u           [int] NOT NULL, --/D Object type classification per band
	type_g           [int] NOT NULL, --/D Object type classification per band
	type_r           [int] NOT NULL, --/D Object type classification per band
	type_i           [int] NOT NULL, --/D Object type classification per band
	type_z           [int] NOT NULL, --/D Object type classification per band
	probPSF_u        real NOT NULL, --/D  Probablity object is a star in each filter.
	probPSF_g        real NOT NULL, --/D  Probablity object is a star in each filter.
	probPSF_r        real NOT NULL, --/D  Probablity object is a star in each filter.
	probPSF_i        real NOT NULL, --/D  Probablity object is a star in each filter.
	probPSF_z        real NOT NULL, --/D  Probablity object is a star in each filter.
	ra               float NOT NULL, --/U deg --/D J2000 Right Ascension (r-band)
	dec              float NOT NULL, --/U deg --/D J2000 Declination (r-band)
	cx               float NOT NULL, --/D unit vector for ra+dec
	cy               float NOT NULL, --/D unit vector for ra+dec
	cz               float NOT NULL, --/D unit vector for ra+dec
	raErr            float NOT NULL, --/U arcsec --/D Error in RA (* cos(Dec), that is, proper units)
	decErr           float NOT NULL, --/U arcsec  --/D Error in Dec
	b                float NOT NULL, --/U deg --/D Galactic latitude
	l                float NOT NULL, --/U deg --/D Galactic longitude
	offsetRa_u       real NOT NULL, --/U arcsec --/D filter position RA minus final RA (* cos(Dec), that is, proper units)
	offsetRa_g       real NOT NULL, --/U arcsec --/D filter position RA minus final RA (* cos(Dec), that is, proper units)
	offsetRa_r       real NOT NULL, --/U arcsec --/D filter position RA minus final RA (* cos(Dec), that is, proper units)
	offsetRa_i       real NOT NULL, --/U arcsec --/D filter position RA minus final RA (* cos(Dec), that is, proper units)
	offsetRa_z       real NOT NULL, --/U arcsec --/D filter position RA minus final RA (* cos(Dec), that is, proper units)
	offsetDec_u      real NOT NULL, --/U arcsec --/D filter position Dec minus final Dec
	offsetDec_g      real NOT NULL, --/U arcsec --/D filter position Dec minus final Dec
	offsetDec_r      real NOT NULL, --/U arcsec --/D filter position Dec minus final Dec
	offsetDec_i      real NOT NULL, --/U arcsec --/D filter position Dec minus final Dec
	offsetDec_z      real NOT NULL, --/U arcsec --/D filter position Dec minus final Dec
	extinction_u     real NOT NULL, --/U mag --/D Extinction in u-band
	extinction_g     real NOT NULL, --/U mag --/D Extinction in g-band
	extinction_r     real NOT NULL, --/U mag --/D Extinction in r-band
	extinction_i     real NOT NULL, --/U mag --/D Extinction in i-band
	extinction_z     real NOT NULL, --/U mag --/D Extinction in z-band
	psffwhm_u        real NOT NULL, --/U arcsec --/D FWHM in u-band
	psffwhm_g        real NOT NULL, --/U arcsec --/D FWHM in g-band
	psffwhm_r        real NOT NULL, --/U arcsec --/D FWHM in r-band
	psffwhm_i        real NOT NULL, --/U arcsec --/D FWHM in i-band
	psffwhm_z        real NOT NULL, --/U arcsec --/D FWHM in z-band
	mjd              [int] NOT NULL, --/U days --/D Date of observation
	airmass_u        real NOT NULL, --/D Airmass at time of observation in u-band
	airmass_g        real NOT NULL, --/D Airmass at time of observation in g-band
	airmass_r        real NOT NULL, --/D Airmass at time of observation in r-band
	airmass_i        real NOT NULL, --/D Airmass at time of observation in i-band
	airmass_z        real NOT NULL, --/D Airmass at time of observation in z-band
	phioffset_u      real NOT NULL, --/U deg --/D Degrees to add to CCD-aligned angle to convert to E of N
	phioffset_g      real NOT NULL, --/U deg --/D Degrees to add to CCD-aligned angle to convert to E of N
	phioffset_r      real NOT NULL, --/U deg --/D Degrees to add to CCD-aligned angle to convert to E of N
	phioffset_i      real NOT NULL, --/U deg --/D Degrees to add to CCD-aligned angle to convert to E of N
	phioffset_z      real NOT NULL, --/U deg --/D Degrees to add to CCD-aligned angle to convert to E of N
	nProf_u          [int] NOT NULL, --/D Number of Profile Bins
	nProf_g          [int] NOT NULL, --/D Number of Profile Bins
	nProf_r          [int] NOT NULL, --/D Number of Profile Bins
	nProf_i          [int] NOT NULL, --/D Number of Profile Bins
	nProf_z          [int] NOT NULL, --/D Number of Profile Bins
	loadVersion      [int] NOT NULL, --/D Load Version  --/F NOFITS
	htmID            bigint NOT NULL, --/D 20-deep hierarchical trangular mesh ID of this object --/F NOFITS
	fieldID          bigint NOT NULL, --/D Link to the field this object is in
	parentID         bigint NOT NULL DEFAULT 0, --/D Pointer to parent (if object deblended) or BRIGHT detection (if object has one), else 0
	specObjID        bigint NOT NULL DEFAULT 0, --/D Pointer to the spectrum of object, if exists, else 0 --/F NOFITS
	u                real NOT NULL, --/U mag --/D Shorthand alias for modelMag --/F modelmag
	g                real NOT NULL, --/U mag --/D Shorthand alias for modelMag --/F modelmag
	r                real NOT NULL, --/U mag --/D Shorthand alias for modelMag --/F modelmag
	i                real NOT NULL, --/U mag --/D Shorthand alias for modelMag --/F modelmag
	z                real NOT NULL, --/U mag --/D Shorthand alias for modelMag --/F modelmag
	err_u            real NOT NULL, --/U mag --/D Error in modelMag alias --/F modelmagerr
	err_g            real NOT NULL, --/U mag --/D Error in modelMag alias --/F modelmagerr
	err_r            real NOT NULL, --/U mag --/D Error in modelMag alias --/F modelmagerr
	err_i            real NOT NULL, --/U mag --/D Error in modelMag alias --/F modelmagerr
	err_z            real NOT NULL, --/U mag --/D Error in modelMag alias --/F modelmagerr
	dered_u          real NOT NULL, --/U mag --/D Simplified mag, corrected for extinction: modelMag-extinction --/F NOFITS
	dered_g          real NOT NULL, --/U mag --/D Simplified mag, corrected for extinction: modelMag-extinction --/F NOFITS
	dered_r          real NOT NULL, --/U mag --/D Simplified mag, corrected for extinction: modelMag-extinction --/F NOFITS
	dered_i          real NOT NULL, --/U mag --/D Simplified mag, corrected for extinction: modelMag-extinction --/F NOFITS
	dered_z          real NOT NULL, --/U mag --/D Simplified mag, corrected for extinction: modelMag-extinction --/F NOFITS
	cloudCam_u       [int] NOT NULL, --/D Cloud camera status for observation in u-band
	cloudCam_g       [int] NOT NULL, --/D Cloud camera status for observation in g-band
	cloudCam_r       [int] NOT NULL, --/D Cloud camera status for observation in r-band
	cloudCam_i       [int] NOT NULL, --/D Cloud camera status for observation in i-band
	cloudCam_z       [int] NOT NULL, --/D Cloud camera status for observation in z-band
	resolveStatus    [int] NOT NULL, --/D Resolve status of object --/R ResolveStatus
	thingId          [int] NOT NULL, --/D Unique identifier from global resolve
	balkanId         [int] NOT NULL, --/D What balkan object is in from window
	nObserve         [int] NOT NULL, --/D Number of observations of this object
	nDetect          [int] NOT NULL, --/D Number of detections of this object
	nEdge            [int] NOT NULL, --/D Number of observations of this object near an edge
	score            real NOT NULL, --/D Quality of field (0-1)
	calibStatus_u    [int] NOT NULL, --/D Calibration status in u-band --/R CalibStatus
	calibStatus_g    [int] NOT NULL, --/D Calibration status in g-band --/R CalibStatus
	calibStatus_r    [int] NOT NULL, --/D Calibration status in r-band --/R CalibStatus
	calibStatus_i    [int] NOT NULL, --/D Calibration status in i-band --/R CalibStatus
	calibStatus_z    [int] NOT NULL, --/D Calibration status in z-band --/R CalibStatus
	nMgyPerCount_u   real NOT NULL, --/U nmgy/count --/D nanomaggies per count in u-band
	nMgyPerCount_g   real NOT NULL, --/U nmgy/count --/D nanomaggies per count in g-band
	nMgyPerCount_r   real NOT NULL, --/U nmgy/count --/D nanomaggies per count in r-band
	nMgyPerCount_i   real NOT NULL, --/U nmgy/count --/D nanomaggies per count in i-band
	nMgyPerCount_z   real NOT NULL, --/U nmgy/count --/D nanomaggies per count in z-band
	TAI_u            float NOT NULL, --/U sec --/D time of observation (TAI) in each filter
	TAI_g            float NOT NULL, --/U sec --/D time of observation (TAI) in each filter
	TAI_r            float NOT NULL, --/U sec --/D time of observation (TAI) in each filter
	TAI_i            float NOT NULL, --/U sec --/D time of observation (TAI) in each filter
	TAI_z            float NOT NULL, --/U sec --/D time of observation (TAI) in each filter
)
GO
--



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'ProperMotions')
	DROP TABLE ProperMotions
GO
--
EXEC spSetDefaultFileGroup 'ProperMotions'
GO
CREATE TABLE ProperMotions (
-------------------------------------------------------------------------------
--/H Proper motions combining SDSS and recalibrated USNO-B astrometry.
--/T These results are based on the technique described in
--/T Munn et al. 2004, AJ, 127, 3034
-------------------------------------------------------------------------------
      delta real NOT NULL,	--/D Distance between this object and the nearest matching USNO-B object. --/U arcsec --/K POS_ANG_DIST_GENERAL --/F pm_delta
      match int NOT NULL,	--/D Number of objects in USNO-B which matched this object within a 1 arcsec radius.  If negative, then the nearest matching USNO-B object itself matched more than 1 SDSS object. --/K CODE_MISC --/F pm_match
      pmL real NOT NULL,	--/D Proper motion in galactic longitude.  --/U mas/year --/K POS_PM
      pmB real NOT NULL,	--/D Proper motion in galactic latitude. --/U mas/year  --/K POS_PM
      pmRa real NOT NULL,	--/D Proper motion in right ascension. --/U mas/year --/K POS_PM_RA
      pmDec real NOT NULL,	--/D Proper motion in declination. --/U mas/year --/K POS_PM_DEC
      pmRaErr real NOT NULL,	--/D Error in proper motion in right ascension. --/U mas/year --/K POS_PM_RA_ERR
      pmDecErr real NOT NULL,	--/D Error in proper motion in declination. --/U mas/year --/K POS_PM_DEC_ERR
      sigRa real NOT NULL,	--/D RMS residual for the proper motion fit in r.a. --/U mas --/K CODE_MISC --/F pm_sigra
      sigDec real NOT NULL,	--/D RMS residual for the proper motion fit in dec. --/U mas --/K CODE_MISC --/F pm_sigdec
      nFit int NOT NULL,	--/D Number of detections used in the fit including the SDSS detection (thus, the number of plates the object was detected on in USNO-B plus one).  --/K CODE_MISC --/F pm_nfit
      O real NOT NULL,		--/D Recalibrated USNO-B O magnitude,  recalibrated to SDSS g --/U mag --/K PHOT_MAG_G --/F pm_usnomag 0
      E real NOT NULL,		--/D Recalibrated USNO-B E magnitude,  recalibrated to SDSS r --/U mag --/K PHOT_MAG_R --/F pm_usnomag 1
      J real NOT NULL,		--/D Recalibrated USNO-B J magnitude,  recalibrated to SDSS g --/U mag --/K PHOT_MAG_G --/F pm_usnomag 2
      F real NOT NULL,		--/D Recalibrated USNO-B F magnitude,  recalibrated to SDSS r --/U mag --/K PHOT_MAG_R --/F pm_usnomag 3
      N real NOT NULL,		--/D Recalibrated USNO-B N magnitude,  recalibrated to SDSS i --/U mag --/K PHOT_MAG_I --/F pm_usnomag 4
      dist20 real NOT NULL,	--/D Distance to the nearest neighbor with g < 20 --/U arcsec --/K POS_ANG_DIST --/F pm_dist20
      dist22 real NOT NULL,	--/D Distance to the nearest neighbor with g < 22 --/U arcsec --/K POS_ANG_DIST --/F pm_dist22
      objid bigint NOT NULL	--/D unique id, points to photoObj --/K ID_MAIN
)
GO



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'FieldProfile')
	DROP TABLE FieldProfile
GO
--
EXEC spSetDefaultFileGroup 'FieldProfile'
GO
CREATE TABLE FieldProfile (
-------------------------------------------------------------------------------
--/H The mean PSF profile for the field as determined from bright stars.
--
--/T For the profile radii, see the ProfileDefs table.
-------------------------------------------------------------------------------
	bin		tinyint	NOT NULL,	--/D bin number (0..14) --/K ID_NUMBER
	band		tinyint	NOT NULL,	--/D u,g,r,i,z (0..4) --/K ID_NUMBER
	profMean 	real	NOT NULL,	--/D Mean pixel flux in annulus --/U nmgy/arcsec^2 --/K PHOT_FLUX_OPTICAL --/F prof_mean_nmgy
	profMed 	real	NOT NULL,	--/D Median profile --/U nmgy/arcsec^2  --/K PHOT_FLUX_OPTICAL STAT_MEDIAN --/F prof_med_nmgy
	profSig 	real	NOT NULL,	--/D Sigma of profile --/U nmgy/arcsec^2 --/K PHOT_FLUX_OPTICAL STAT_STDEV --/F prof_sig_nmgy
	fieldID 	bigint 	NOT NULL	--/D links to the field object --/K ID_CATALOG
)  
GO
--


--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'Run')
DROP TABLE Run
GO
--
EXEC spSetDefaultFileGroup 'Run'
GO
CREATE TABLE Run (
-------------------------------------------------------------------------------
--/H Contains the basic parameters associated with a run
--
--/T A run corresponds to a single drift scan. 
-------------------------------------------------------------------------------
	skyVersion	tinyint NOT NULL,	--/D 0 = OPDB target, 1 = OPDB best XXX --/K CODE_MISC
	run		smallint NOT NULL,	--/D Run number --/K OBS_RUN
	rerun		smallint NOT NULL,	--/D Rerun number --/K CODE_MISC
	mjd    		int NOT NULL, 		--/U days --/D MJD of observation
	datestring 	varchar(32) NOT NULL, 	--/D Human-readable date of observation
	stripe		int NOT NULL,		--/D Stripe number --/K ID_FIELD
	strip 		varchar(32) NOT NULL,	--/D Strip (N or S) 
	xBore		float NOT NULL, 	--/U deg --/D boresight offset perpendicular to great circle 
	fieldRef 	int NOT NULL,		--/D Starting field number of full run (what MU_REF, MJD_REF refer to) --/K ID_FIELD
	lastField 	int NOT NULL,		--/D last field of full run --/K NUMBER
	flavor		varchar(32) NOT NULL, 	--/D type of drift scan (from apacheraw, bias, calibration, engineering, ignore, and science)
	xBin		int NOT NULL,   	--/U pix --/D binning amount perpendicular to scan direction
	yBin		int NOT NULL,   	--/U pix --/D binning amount in scan direction
	nRow		int NOT NULL,   	--/U pix --/D number of rows in output idR
	mjdRef		float NOT NULL, 	--/U days --/D MJD at row 0 of reference frame
	muRef		float NOT NULL, 	--/U deg --/D mu value at row 0 of reference field
	lineStart	int NOT NULL, 		--/U microsec --/D linestart rate betweeen each (binned) row
	tracking	float NOT NULL, 	--/U arcsec/sec --/D tracking rate 
	node		float NOT NULL, 	--/D node of great circle, that is, its RA on the J2000 equator
	incl		float NOT NULL, 	--/D inclination of great circle relative to J2000 equator
	comments	varchar(128) NOT NULL, 	--/D comments on the run
	qterm		real NOT NULL, 		--/U arcsec/hr^2 --/D quadratic term in coarse astrometric solution
	maxMuResid	real NOT NULL, 		--/U arcsec --/D maximum residual from great circle in scan direction
	maxNuResid	real NOT NULL, 		--/U arcsec --/D maximum residual from great circle perpendicular to scan direction
	startField	int NOT NULL, 		--/D starting field for reduced data 
	endField	int NOT NULL, 		--/D ending field for reduced data 
	photoVersion	varchar(32) NOT NULL, 	--/D photo version used
	dervishVersion	varchar(32) NOT NULL, 	--/D dervish version used
	astromVersion	varchar(32) NOT NULL, 	--/D astrom version used
	sasVersion	varchar(32) NOT NULL, 	--/D version of SAS used to produce CSV for this run
)
GO



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotoProfile')
	DROP TABLE PhotoProfile
GO
--
EXEC spSetDefaultFileGroup 'PhotoProfile'
GO
CREATE TABLE PhotoProfile (
-------------------------------------------------------------------------------
--/H The annulus-averaged flux profiles of SDSS photo objects
--
--/T For the profile radii, see the ProfileDefs table.
-------------------------------------------------------------------------------
	bin		tinyint	NOT NULL,	--/D bin number (0..14) --/K ID_NUMBER
	band		tinyint	NOT NULL,	--/D u,g,r,i,z (0..4) --/K ID_NUMBER
	profMean 	real	NOT NULL,	--/D Mean flux in annulus --/U nanomaggies/arcsec^2 --/K PHOT_FLUX_OPTICAL --/F profmean_nmgy
	profErr 	real	NOT NULL, 	--/D Standard deviation of mean pixel flux in annulus --/U nanomaggies/arcsec^2 --/K ERROR PHOT_FLUX_OPTICAL --/F proferr_nmgy
	objID 		bigint 	NOT NULL	--/D links to the photometric object --/K ID_MAIN
)  
GO
--



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'Mask')
	DROP TABLE Mask
GO
--
EXEC spSetDefaultFileGroup 'Mask'
GO
CREATE TABLE Mask (
-------------------------------------------------------------------------------
--/H Contains a record describing the each mask object
--
--/T
-------------------------------------------------------------------------------
	maskID 		bigint NOT NULL,--/D Unique Id number, composed of skyversion, rerun, run, camcol, field, filter, mask --/K ID_CATALOG
	run		smallint NOT NULL,	--/D Run number --/K OBS_RUN
	rerun		smallint NOT NULL,	--/D Rerun number --/K CODE_MISC
	camcol		tinyint NOT NULL,	--/D Camera column --/K INST_ID
	field		smallint NOT NULL,	--/D Field number --/K ID_FIELD
	mask		smallint NOT NULL,	--/D The object id within a field. Usually changes between reruns of the same field. --/K ID_NUMBER
	filter		tinyint NOT NULL, --/D The enumerated filter [0..4] --/K INST_ID
	ra		float NOT NULL,	--/D J2000 right ascension (r') --/U deg --/K POS_EQ_RA_MAIN
	[dec]		float NOT NULL,	--/D J2000 declination (r') --/U deg --/K POS_EQ_DEC_MAIN
	radius		float NOT NULL, --/D the radius of the bounding circle --/U deg --/K EXTENSION_RAD
	area		varchar(4096) NOT NULL, --/D Area descriptor for the mask object --/K EXTENSION
	type		int NOT NULL, --/D enumerated type of mask --/R MaskType --/K CLASS_CODE
	seeing		real NOT NULL, --/D seeing width --/U arcsecs --/K INST_SEEING
	cx		float NOT NULL default(0), --/D unit vector for ra+dec --/K POS_EQ_CART_X
	cy		float NOT NULL default(0), --/D unit vector for ra+dec --/K POS_EQ_CART_y
	cz		float NOT NULL default(0), --/D unit vector for ra+dec --/K POS_EQ_CART_Z
	htmID 		bigint NOT NULL default(0) --/D 20-deep hierarchical trangular mesh ID of this object --/K CODE_HTM
)
--



--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
        WHERE xtype='U' AND name = 'MaskedObject')
	DROP TABLE MaskedObject
GO
--
EXEC spSetDefaultFileGroup 'MaskedObject'
GO
CREATE TABLE MaskedObject (
-------------------------------------------------------------------------------
--/H Contains the objects inside a specific mask
--
--/T This is a list of all masked objects. Each object may appear
--/T multiple times, if it is masked for multiple reasons.
-------------------------------------------------------------------------------
	objid		bigint NOT NULL,	--/D pointer to a PhotoObj --/K ID_MAIN
	maskID 		bigint NOT NULL,	--/D Unique maskid --/K ID_CATALOG
	maskType	int NOT NULL 		--/D enumerated type of mask --/R MaskType --/K CLASS_CODE
)
GO
--


--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'AtlasOutline')
	DROP TABLE AtlasOutline
GO
--
EXEC spSetDefaultFileGroup 'AtlasOutline'
GO
CREATE TABLE AtlasOutline (
-------------------------------------------------------------------------------
--/H Contains a record describing each AtlasOutline object
-------------------------------------------------------------------------------
--/T The table contains the outlines of each object over a 4x4 pixel grid,
--/T and the bounding rectangle of the object within the frame.
-------------------------------------------------------------------------------
	objID 		bigint NOT NULL,--/D Unique Id number, composed of rerun, run, camcol, field, objid --/K ID_MAIN
	[size]		int NOT NULL,	--/D number of spans allocated  --/K NUMBER
	nspan		int NOT NULL,	--/D actual number of spans --/K NUMBER
	row0		int NOT NULL,	--/D row offset from parent region --/K POS_OFFSET
	col0		int NOT NULL,	--/D col offset from parent region --/K POS_OFFSET
	rmin		int NOT NULL,	--/D bounding box min row --/U pix --/K POS_LIMIT
	rmax		int NOT NULL,	--/D bounding box max row --/U pix --/K POS_LIMIT
	cmin		int NOT NULL,	--/D bounding box min col --/U pix --/K POS_LIMIT
	cmax		int NOT NULL,	--/D bounding box max col --/U pix --/K POS_LIMIT
	npix		int NOT NULL,	--/D number of pixels in object --/U pix --/K EXTENSION_AREA
	span		varchar(max) NOT NULL	--/D span data as string --/K POS_MAP
)
GO
--


--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotoPrimaryDR7')
	DROP TABLE PhotoPrimaryDR7
GO
--
EXEC spSetDefaultFileGroup 'PhotoPrimaryDR7'
GO
CREATE TABLE PhotoPrimaryDR7 (
-------------------------------------------------------------------------------
--/H Contains the spatial cross-match between DR8 primaries and DR7 primaries.
-------------------------------------------------------------------------------
--/T This is a unique match between a DR8 photoprimary and a DR7 photoprimary, 
--/T and matches between different run/camcol/field are allowed.  The match
--/T radius is 1 arcsec.  The table contains the DR8 and DR7 objids, the
--/T distance between them and the DR7 phototag quantities.
-------------------------------------------------------------------------------
	dr7objID	bigint NOT NULL,	--/D Unique DR7 identifier composed from [skyVersion,rerun,run,camcol,field,obj]. --/K ID_MAIN
	dr8objID	bigint NOT NULL,	--/D Unique DR8 identifier composed from [skyVersion,rerun,run,camcol,field,obj]. --/K ID_MAIN
	distance	float NULL,		--/D Distance in arcmin between the DR7 and DR8 positions
	skyVersion	tinyint NOT NULL,	--/D 0 = OPDB target, 1 = OPDB best --/K CODE_MISC
	run		smallint NOT NULL,	--/D Run number --/K OBS_RUN
	rerun		smallint NOT NULL,	--/D Rerun number --/K CODE_MISC
	camcol		tinyint NOT NULL,	--/D Camera column --/K INST_ID
	field		smallint NOT NULL,	--/D Field number --/K ID_FIELD
	obj		smallint NOT NULL,	--/D The object id within a field. Usually changes between reruns of the same field. --/K ID_NUMBER
	nChild		smallInt NOT NULL,	--/D Number of children if this is a composite object that has been deblended. BRIGHT (in a flags sense) objects also have nchild == 1, the non-BRIGHT sibling. --/K NUMBER
	[type]		smallint NOT NULL,	--/D Morphological type classification of the object. --/R PhotoType --/K CLASS_OBJECT
	probPSF		real NOT NULL,		--/D Probability that the object is a star. Currently 0 if type == 3 (galaxy), 1 if type == 6 (star). --/K STAT_PROBABILITY
	insideMask	tinyint NOT NULL,	--/D Flag to indicate whether object is inside a mask and why --/R InsideMask --/K CODE_MISC
	flags		bigint NOT NULL, --/D Photo Object Attribute Flags  --/R PhotoFlags --/K CODE_MISC
	psfMag_u	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_U
	psfMag_g	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_G
	psfMag_r	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_R
	psfMag_i	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_I
	psfMag_z	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_Z
	psfMagErr_u	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_U ERROR
	psfMagErr_g	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_G ERROR
	psfMagErr_r	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_R ERROR
	psfMagErr_i	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_I ERROR
	psfMagErr_z	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_Z ERROR
	petroMag_u	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_U
	petroMag_g	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_G
	petroMag_r	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_R
	petroMag_i	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_I
	petroMag_z	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_Z
	petroMagErr_u	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_U ERROR
	petroMagErr_g	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_G ERROR
	petroMagErr_r	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_R ERROR
	petroMagErr_i	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_I ERROR
	petroMagErr_z	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_Z ERROR
	petroR50_r	real NOT NULL,	--/D Radius containing 50% of Petrosian flux --/U arcsec --/K EXTENSION_RAD
	petroR90_r	real NOT NULL,	--/D Radius containing 90% of Petrosian flux --/U arcsec --/K EXTENSION_RAD
	modelMag_u	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_U FIT_PARAM
	modelMag_g	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_G FIT_PARAM
	modelMag_r	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_R FIT_PARAM
	modelMag_i	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_I FIT_PARAM
	modelMag_z	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_Z FIT_PARAM
	modelMagErr_u	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_U ERROR
	modelMagErr_g	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_G ERROR
	modelMagErr_r	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_R ERROR
	modelMagErr_i	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_I ERROR
	modelMagErr_z	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_Z ERROR
	mRrCc_r		real NOT NULL,	--/D Adaptive (<r^2> + <c^2>) --/K FIT_PARAM
	mRrCcErr_r	real NOT NULL,	--/D Error in adaptive (<r^2> + <c^2>) --/K FIT_PARAM ERROR
--
	lnLStar_r	real NOT NULL,	--/D Star ln(likelihood) --/K FIT_GOODNESS
	lnLExp_r	real NOT NULL,	--/D Exponential disk fit ln(likelihood) --/K FIT_GOODNESS
	lnLDeV_r	real NOT NULL,	--/D DeVaucouleurs fit ln(likelihood) --/K FIT_GOODNESS
	status		int NOT NULL,	--/D Status of the object in the survey --/R PhotoStatus --/K CODE_MISC
	ra		float NOT NULL,	--/D J2000 right ascension (r') --/U deg --/K POS_EQ_RA_MAIN
	[dec]		float NOT NULL,	--/D J2000 declination (r') --/U deg --/K POS_EQ_DEC_MAIN
	cx		float NOT NULL, --/D unit vector for ra+dec --/K POS_EQ_CART_X
	cy		float NOT NULL, --/D unit vector for ra+dec --/K POS_EQ_CART_Y
	cz		float NOT NULL, --/D unit vector for ra+dec --/K POS_EQ_CART_Z
--
	primTarget	int NOT NULL,	--/D Bit mask of primary target categories the object was selected in. --/R PrimTarget  --/K CODE_MISC
	secTarget	int NOT NULL,	--/D Bit mask of secondary target categories the object was selected in. --/R SecTarget --/K CODE_MISC
--
	extinction_u	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_g	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_r	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_i	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_z	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	htmID 		bigint NOT NULL, --/D 20-deep hierarchical trangular mesh ID of this object --/K CODE_HTM
	fieldID 	bigint NOT NULL, --/D Link to the field this object is in --/K ID_FIELD
	specObjID 	bigint NOT NULL default 0, --/D Pointer to the spectrum of object, if exists, else 0  --/K ID_CATALOG
	[size]		real NOT NULL default -9999  --/D computed: =SQRT(mRrCc_r/2.0)
)
GO



--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotoObjDR7')
	DROP TABLE PhotoObjDR7
GO
--
EXEC spSetDefaultFileGroup 'PhotoObjDR7'
GO
CREATE TABLE PhotoObjDR7 (
-------------------------------------------------------------------------------
--/H Contains the spatial cross-match between DR8 photoobj and DR7 photoobj.
-------------------------------------------------------------------------------
--/T This is a unique match between a DR8 photoobj and a DR7 photoobj, 
--/T and matches are restricted to the same run/camcol/field.  
--/T The match radius is 1 arcsec, and within this radius preference is
--/T given to a photoprimary match over a secondary.  If no primary match
--/T exists, the nearest secondary match is chosen.  If more than one
--/T match of a given mode exists, the nearest one is chosen.  The table
--/T contains the DR8 and DR7 objids and modes, the distance between them, 
--/T and the DR7 phototag quantities.
-------------------------------------------------------------------------------
	dr7objID	bigint NOT NULL,	--/D Unique DR7 identifier composed from [skyVersion,rerun,run,camcol,field,obj]. --/K ID_MAIN
	dr8objID	bigint NOT NULL,	--/D Unique DR8 identifier composed from [skyVersion,rerun,run,camcol,field,obj]. --/K ID_MAIN
	distance	float NULL,		--/D Distance in arcmin between the DR7 and DR8 positions
	modeDR7 	tinyint NOT NULL,	--/D DR7 mode, 1: primary, 2: secondary, 3: family object. --/K CLASS_OBJECT
	modeDR8		tinyint NULL,		--/D DR8 mode, 1: primary, 2: secondary, 3: family object. --/K CLASS_OBJECT
	skyVersion	tinyint NOT NULL,	--/D 0 = OPDB target, 1 = OPDB best --/K CODE_MISC
	run		smallint NOT NULL,	--/D Run number --/K OBS_RUN
	rerun		smallint NOT NULL,	--/D Rerun number --/K CODE_MISC
	camcol		tinyint NOT NULL,	--/D Camera column --/K INST_ID
	field		smallint NOT NULL,	--/D Field number --/K ID_FIELD
	obj		smallint NOT NULL,	--/D The object id within a field. Usually changes between reruns of the same field. --/K ID_NUMBER
	nChild		smallInt NOT NULL,	--/D Number of children if this is a composite object that has been deblended. BRIGHT (in a flags sense) objects also have nchild == 1, the non-BRIGHT sibling. --/K NUMBER
	[type]		smallint NOT NULL,	--/D Morphological type classification of the object. --/R PhotoType --/K CLASS_OBJECT
	probPSF		real NOT NULL,		--/D Probability that the object is a star. Currently 0 if type == 3 (galaxy), 1 if type == 6 (star). --/K STAT_PROBABILITY
	insideMask	tinyint NOT NULL,	--/D Flag to indicate whether object is inside a mask and why --/R InsideMask --/K CODE_MISC
	flags		bigint NOT NULL, --/D Photo Object Attribute Flags  --/R PhotoFlags --/K CODE_MISC
	psfMag_u	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_U
	psfMag_g	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_G
	psfMag_r	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_R
	psfMag_i	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_I
	psfMag_z	real NOT NULL,	--/D PSF flux --/U mag --/K PHOT_SDSS_Z
	psfMagErr_u	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_U ERROR
	psfMagErr_g	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_G ERROR
	psfMagErr_r	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_R ERROR
	psfMagErr_i	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_I ERROR
	psfMagErr_z	real NOT NULL,	--/D PSF flux error --/U mag --/K PHOT_SDSS_Z ERROR
	petroMag_u	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_U
	petroMag_g	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_G
	petroMag_r	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_R
	petroMag_i	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_I
	petroMag_z	real NOT NULL,	--/D Petrosian flux --/U mag --/K PHOT_SDSS_Z
	petroMagErr_u	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_U ERROR
	petroMagErr_g	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_G ERROR
	petroMagErr_r	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_R ERROR
	petroMagErr_i	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_I ERROR
	petroMagErr_z	real NOT NULL,	--/D Petrosian flux error --/U mag --/K PHOT_SDSS_Z ERROR
	petroR50_r	real NOT NULL,	--/D Radius containing 50% of Petrosian flux --/U arcsec --/K EXTENSION_RAD
	petroR90_r	real NOT NULL,	--/D Radius containing 90% of Petrosian flux --/U arcsec --/K EXTENSION_RAD
	modelMag_u	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_U FIT_PARAM
	modelMag_g	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_G FIT_PARAM
	modelMag_r	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_R FIT_PARAM
	modelMag_i	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_I FIT_PARAM
	modelMag_z	real NOT NULL,	--/D better of DeV/Exp magnitude fit --/U mag --/K PHOT_SDSS_Z FIT_PARAM
	modelMagErr_u	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_U ERROR
	modelMagErr_g	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_G ERROR
	modelMagErr_r	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_R ERROR
	modelMagErr_i	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_I ERROR
	modelMagErr_z	real NOT NULL,	--/D better of DeV/Exp magnitude fit error --/U mag --/K PHOT_SDSS_Z ERROR
	mRrCc_r		real NOT NULL,	--/D Adaptive (<r^2> + <c^2>) --/K FIT_PARAM
	mRrCcErr_r	real NOT NULL,	--/D Error in adaptive (<r^2> + <c^2>) --/K FIT_PARAM ERROR
--
	lnLStar_r	real NOT NULL,	--/D Star ln(likelihood) --/K FIT_GOODNESS
	lnLExp_r	real NOT NULL,	--/D Exponential disk fit ln(likelihood) --/K FIT_GOODNESS
	lnLDeV_r	real NOT NULL,	--/D DeVaucouleurs fit ln(likelihood) --/K FIT_GOODNESS
	status		int NOT NULL,	--/D Status of the object in the survey --/R PhotoStatus --/K CODE_MISC
	ra		float NOT NULL,	--/D J2000 right ascension (r') --/U deg --/K POS_EQ_RA_MAIN
	[dec]		float NOT NULL,	--/D J2000 declination (r') --/U deg --/K POS_EQ_DEC_MAIN
	cx		float NOT NULL, --/D unit vector for ra+dec --/K POS_EQ_CART_X
	cy		float NOT NULL, --/D unit vector for ra+dec --/K POS_EQ_CART_Y
	cz		float NOT NULL, --/D unit vector for ra+dec --/K POS_EQ_CART_Z
--
	primTarget	int NOT NULL,	--/D Bit mask of primary target categories the object was selected in. --/R PrimTarget  --/K CODE_MISC
	secTarget	int NOT NULL,	--/D Bit mask of secondary target categories the object was selected in. --/R SecTarget --/K CODE_MISC
--
	extinction_u	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_g	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_r	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_i	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	extinction_z	real NOT NULL,	--/D Extinction in each filter --/U mag --/K PHOT_EXTINCTION_GAL
	htmID 		bigint NOT NULL, --/D 20-deep hierarchical trangular mesh ID of this object --/K CODE_HTM
	fieldID 	bigint NOT NULL, --/D Link to the field this object is in --/K ID_FIELD
	specObjID 	bigint NOT NULL default 0, --/D Pointer to the spectrum of object, if exists, else 0  --/K ID_CATALOG
	[size]		real NOT NULL default -9999  --/D computed: =SQRT(mRrCc_r/2.0)
)
GO


--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'TwoMass')
	DROP TABLE TwoMass
GO
--
EXEC spSetDefaultFileGroup 'TwoMass'
GO
CREATE TABLE TwoMass (
-------------------------------------------------------------------------------
--/H 2MASS point-source catalog quantities for matches to SDSS photometry
--/T This table contains one entry for each match between the 
--/T SDSS photometric catalog (photoObjAll) and the 2MASS point-source
--/T catalog (PSC). See http://tdc-www.harvard.edu/catalogs/tmc.format.html
--/T for full documentation.
-------------------------------------------------------------------------------
	objID		bigint NOT NULL,	--/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].
	ra		float NOT NULL,		--/D 2MASS right ascension, J2000 --/U deg --/F tmass_ra
	dec 		float NOT NULL,		--/D 2MASS declination, J2000 --/U deg --/F tmass_dec
	errMaj		real NOT NULL,		--/U arcsec --/D Semi-major axis length of the one sigma position uncertainty ellipse  --/F tmass_err_maj       
	errMin		real NOT NULL,		--/U arcsec --/D Semi-minor axis length of the one sigma position uncertainty ellipse	--/F tmass_err_min      
	errAng		real NOT NULL,		--/U deg --/D  Position angle on the sky of the semi-major axis of the position uncertainty ellipse (East of North)	--/F tmass_err_ang      
	j		real NOT NULL,		--/U mag    --/D default J-band apparent magnitude (Vega relative, no Galactic extinction correction 	--/F tmass_j            
	jIvar		real NOT NULL,		--/U inverse mag^2 --/D inverse variance in J-band apparent magnitude 	--/F tmass_j_ivar       
	h		real NOT NULL,		--/U mag --/D default H-band apparent magnitude (Vega relative, no Galactic extinction correction 	--/F tmass_h            
	hIvar		real NOT NULL,		--/U inverse mag^2 --/D inverse variance in H-band apparent magnitude --/F tmass_h_ivar       
	k		real NOT NULL,		--/U mag --/D default K-band apparent magnitude (Vega relative, no Galactic extinction correction 	--/F tmass_k            
	kIvar		real NOT NULL,		--/U inverse mag^2 --/D inverse variance in K-band apparent magnitude --/F tmass_k_ivar       
	phQual		varchar(32) NOT NULL,	--/D photometric quality flag (see 2MASS PSC documentation)	--/F tmass_ph_qual     
	rdFlag		varchar(32) NOT NULL,	--/D Read flag. Three character flag, one character per band [JHKs], that indicates the origin of the default magnitudes and uncertainties in each band (see 2MASS PSC documentation)	--/F tmass_rd_flg      
	blFlag		varchar(32) NOT NULL,	--/D Blend flag. Three character flag, one character per band [JHKs], that indicates the number of components that were fit simultaneously when estimating the brightness of a source (see 2MASS PSC documentation)		--/F tmass_bl_flg      
	ccFlag		varchar(32) NOT NULL,	--/D Contamination and confusion flag. Three character flag, one character per band [JHKs], that indicates that the photometry and/or position measurements of a source may be contaminated or biased due to proximity to an image artifact or nearby source of equal or greater brightness. (See 2MASS PSC documentation). 	--/F tmass_cc_flg       
	nDetectJ	tinyint NOT NULL,	--/D Number of frames on which 2MASS source was detected in J-band		--/F tmass_ndetect 0    
	nDetectH	tinyint NOT NULL,	--/D Number of frames on which 2MASS source was detected in H-band		--/F tmass_ndetect 1    
	nDetectK	tinyint NOT NULL,	--/D Number of frames on which 2MASS source was detected in K-band		--/F tmass_ndetect 2    
	nObserveJ	tinyint NOT NULL,	--/D Number of frames which 2MASS source was within the boundaries of in J-band	--/F tmass_nobserve 0  
	nObserveH	tinyint NOT NULL,	--/D Number of frames which 2MASS source was within the boundaries of in H-band		--/F tmass_nobserve 1   
	nObserveK	tinyint NOT NULL,	--/D Number of frames which 2MASS source was within the boundaries of in K-band		--/F tmass_nobserve 2   
	galContam	tinyint NOT NULL,	--/D Extended source "contamination" flag. A value of gal_contam="0" indicates no contamination. "1" indicates it is probably an extended source itself (this does not detect all such cases!).  "2" indicates it is within the boundary of a large XSC source. (See 2MASS PSC documentation).	--/F tmass_gal_contam   
	mpFlag		tinyint NOT NULL,	--/D Minor planet flag. "1" if source associated with known solar system object, "0" otherwise. (See 2MASS PSC documentation). 		--/F tmass_mp_flg      
	ptsKey		int NOT NULL,		--/D Unique identification number for the PSC source.	--/F tmass_pts_key      
	hemis		varchar(32) NOT NULL,	--/D Hemisphere code for the 2MASS Observatory from which this source was observed.  "n" means North (Mt. Hopkins); "s" means South (CTIO).		--/F tmass_hemis        
	jDate		float NOT NULL,		--/D Julian Date of the source measurement accurate to +30 seconds. (See 2MASS PSC documentation).		--/F tmass_jdate        
	dupSource	tinyint NOT NULL,	--/D Duplicate source flag. Used in conjunction with the use_src flag, this numerical flag indicates whether the source falls in a Tile overlap region, and if so, if it was detected multiple times. (See 2MASS PSC documentation)		--/F tmass_dup_src      
	useSource	tinyint NOT NULL	--/D Use source flag. Used in conjunction with the dup_src flag, this numerical flag indicates if a source falls within a Tile overlap region, and whether or not it satisfies the unbiased selection rules for multiple source resolution. (See 2MASS PSC documentation).		--/F tmass_use_src      
)

GO
--


--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'TwoMassXSC')
	DROP TABLE TwoMassXSC
GO
--
EXEC spSetDefaultFileGroup 'TwoMassXSC'
GO
CREATE TABLE TwoMassXSC (
-----------------------------------------------------------------------------------
--/H 2MASS extended-source catalog quantities for matches to SDSS photometry
--/T This table contains one entry for each match between the 
--/T SDSS photometric catalog (photoObjAll) and the 2MASS extended-source
--/T catalog (XSC). See http://tdc-www.harvard.edu/catalogs/tmx.format.html 
--/T for full documentation.
-----------------------------------------------------------------------------------
	objID 		bigint NOT NULL,	--/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj]. 
	tmassxsc_ra	float NOT NULL,		--/D 2MASS right ascension, J2000 --/U deg
	tmassxsc_dec	float NOT NULL,		--/D 2MASS declination, J2000 --/U deg 
	jDate		float NOT NULL,		--/D Julian Date of the source measurement accurate to +30 seconds. (See 2MASS PSC documentation).
	designation	varchar(100) NOT NULL,	--/D Sexagesimal, equatorial position-based source name in the form: hhmmssss+ddmmsss[ABC...].
	sup_ra		float NOT NULL,		--/D Super-coadd centroid RA (J2000 decimal deg).
	sup_dec		float NOT NULL,		--/D Super-coadd centroid Dec (J2000 decimal deg).
	density		real NOT NULL,		--/D Coadd log(density) of stars with k<14 mag.
	R_K20FE		real NOT NULL,		--/U mag --/D 20mag/sq arcsec isophotal K fiducial ell. ap. semi-major axis.
	J_M_K20FE	real NOT NULL,		--/U mag --/D J 20mag/sq arcsec isophotal fiducial ell. ap. magnitude.
	J_MSIG_K20FE	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in 20mag/sq arcsec iso.fid.ell.mag.
	J_FLG_K20FE	smallint NOT NULL,	--/D J confusion flag for 20mag/sq arcsec iso. fid. ell. mag.
	H_M_K20FE	real NOT NULL,		--/U mag --/D H 20mag/sq arcsec isophotal fiducial ell. ap. magnitude.
	H_MSIG_K20FE	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in 20mag/sq arcsec iso.fid.ell.mag.
	H_FLG_K20FE	smallint NOT NULL,	--/D H confusion flag for 20mag/sq arcsec iso. fid. ell. mag.
	K_M_K20FE	real NOT NULL,		--/U mag --/D K 20mag/sq arcsec isophotal fiducial ell. ap. magnitude.
	K_MSIG_K20FE	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in 20mag/sq arcsec iso.fid.ell.mag.
	K_FLG_K20FE	smallint NOT NULL,	--/D K confusion flag for 20mag/sq arcsec iso. fid. ell. mag.
	R_3SIG		real NOT NULL,		--/U arcsec --/D 3-sigma K isophotal semi-major axis.
	J_BA		real NOT NULL,		--/D J minor/major axis ratio fit to the 3-sigma isophote.
	J_PHI		smallint NOT NULL,	--/U deg --/D J angle to 3-sigma major axis (E of N).
	H_BA		real NOT NULL,		--/D H minor/major axis ratio fit to the 3-sigma isophote.
	H_PHI		smallint NOT NULL,	--/U deg --/D H angle to 3-sigma major axis (E of N).
	K_BA		real NOT NULL,		--/D K minor/major axis ratio fit to the 3-sigma isophote.
	K_PHI		smallint NOT NULL,	--/U deg --/D K angle to 3-sigma major axis (E of N).
	SUP_R_3SIG	real NOT NULL,		--/D Super-coadd minor/major axis ratio fit to the 3-sigma isophote.
	SUP_BA		real NOT NULL,		--/D K minor/major axis ratio fit to the 3-sigma isophote.
	SUP_PHI		smallint NOT NULL,	--/U deg --/D K angle to 3-sigma major axis (E of N).
	R_FE		real NOT NULL,		--/D K fiducial Kron elliptical aperture semi-major axis.
	J_M_FE		real NOT NULL,		--/U mag --/D J fiducial Kron elliptical aperture magnitude.
	J_MSIG_FE	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in fiducial Kron ell. mag.
	J_FLG_FE	smallint NOT NULL,	--/D J confusion flag for fiducial Kron ell. mag.
	H_M_FE		real NOT NULL,		--/U mag --/D H fiducial Kron elliptical aperture magnitude.
	H_MSIG_FE	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in fiducial Kron ell. mag.
	H_FLG_FE	smallint NOT NULL,	--/D H confusion flag for fiducial Kron ell. mag.
	K_M_FE		real NOT NULL,		--/U mag --/D K fiducial Kron elliptical aperture magnitude.
	K_MSIG_FE	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in fiducial Kron ell. mag.
	K_FLG_FE	smallint NOT NULL,	--/D K confusion flag for fiducial Kron ell. mag.
	R_EXT		real NOT NULL,		--/U arcsec --/D extrapolation/total radius.
	J_M_EXT		real NOT NULL,		--/U mag --/D J mag from fit extrapolation.
	J_MSIG_EXT	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in mag from fit extrapolation.
	J_PCHI		real NOT NULL,		--/D J chi^2 of fit to rad. profile
	H_M_EXT		real NOT NULL,		--/U mag --/D H mag from fit extrapolation.
	H_MSIG_EXT	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in mag from fit extrapolation.
	H_PCHI		real NOT NULL,		--/D H chi^2 of fit to rad. profile
	K_M_EXT		real NOT NULL,		--/U mag --/D K mag from fit extrapolation.
	K_MSIG_EXT	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in mag from fit extrapolation.
	K_PCHI		real NOT NULL,		--/D K chi^2 of fit to rad. profile
	J_R_EFF		real NOT NULL,		--/U arcsec --/D J half-light (integrated half-flux point) radius. 
	J_MNSURFB_EFF	real NOT NULL,		--/U mag/sq. arcsec --/D J mean surface brightness at the half-light radius. 
	H_R_EFF		real NOT NULL,		--/U arcsec --/D H half-light (integrated half-flux point) radius. 
	H_MNSURFB_EFF	real NOT NULL,		--/U mag/sq. arcsec --/D H mean surface brightness at the half-light radius. 
	K_R_EFF		real NOT NULL,		--/U arcsec --/D K half-light (integrated half-flux point) radius. 
	K_MNSURFB_EFF	real NOT NULL,		--/U mag/sq. arcsec --/D K mean surface brightness at the half-light radius. 
	J_CON_INDX	real NOT NULL,		--/D J concentration index r_75%/r_25%.
	H_CON_INDX	real NOT NULL,		--/D H concentration index r_75%/r_25%.
	K_CON_INDX	real NOT NULL,		--/D K concentration index r_75%/r_25%.
	J_PEAK		real NOT NULL,		--/U mag/sq. arcsec --/D J peak pixel brightness.
	H_PEAK		real NOT NULL,		--/U mag/sq. arcsec --/D H peak pixel brightness.
	K_PEAK		real NOT NULL,		--/U mag/sq. arcsec --/D K peak pixel brightness.
	J_5SURF		real NOT NULL,		--/U mag/sq. arcsec --/D J central surface brightness (r<=5).
	H_5SURF		real NOT NULL,		--/U mag/sq. arcsec --/D H central surface brightness (r<=5).
	K_5SURF		real NOT NULL,		--/U mag/sq. arcsec --/D K central surface brightness (r<=5).
	E_SCORE		real NOT NULL,		--/D extended score: 1(extended) < e_score < 2(point-like).
	G_SCORE		real NOT NULL,		--/D galaxy score: 1(extended) < g_score < 2(point-like).
	VC		smallint NOT NULL,	--/D visual verification score for source.
	CC_FLG		varchar(100) NOT NULL,	--/D indicates artifact contamination and/or confusion.
	IM_NX		smallint NOT NULL,	--/D size of postage stamp image in pixels.
	R_K20FC		real NOT NULL,		--/U arcsec --/D 20mag/sq arcsec isophotal K fiducial circular ap. radius.
	J_M_K20FC	real NOT NULL,		--/U mag --/D J 20mag/sq arcsec isophotal fiducial circ. ap. mag.
	J_MSIG_K20FC	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in 20mag/sq arcsec iso.fid.circ. mag.
	J_FLG_K20FC	smallint NOT NULL,	--/D J confusion flag for 20mag/sq arcsec iso. fid. circ. mag.
	H_M_K20FC	real NOT NULL,		--/U mag --/D H 20mag/sq arcsec isophotal fiducial circ. ap. mag.
	H_MSIG_K20FC	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in 20mag/sq arcsec iso.fid.circ. mag.
	H_FLG_K20FC	smallint NOT NULL,	--/D H confusion flag for 20mag/sq arcsec iso. fid. circ. mag.
	K_M_K20FC	real NOT NULL,		--/U mag --/D K 20mag/sq arcsec isophotal fiducial circ. ap. mag.
	K_MSIG_K20FC	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in 20mag/sq arcsec iso.fid.circ. mag.
	K_FLG_K20FC	smallint NOT NULL,	--/D K confusion flag for 20mag/sq arcsec iso. fid. circ. mag.
	J_R_E		real NOT NULL,		--/U arcsec --/D J Kron elliptical aperture semi-major axis.
	J_M_E		real NOT NULL,		--/U mag --/D 	J Kron elliptical aperture magnitude
	J_MSIG_E	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in Kron elliptical mag.
	J_FLG_E		smallint NOT NULL,	--/D J confusion flag for Kron elliptical mag.
	H_R_E		real NOT NULL,		--/U arcsec --/D H Kron elliptical aperture semi-major axis.
	H_M_E		real NOT NULL,		--/U mag --/D 	H Kron elliptical aperture magnitude
	H_MSIG_E	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in Kron elliptical mag.
	H_FLG_E		smallint NOT NULL,	--/D H confusion flag for Kron elliptical mag.
	K_R_E		real NOT NULL,		--/U arcsec --/D K Kron elliptical aperture semi-major axis.
	K_M_E		real NOT NULL,		--/U mag --/D 	K Kron elliptical aperture magnitude
	K_MSIG_E	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in Kron elliptical mag.
	K_FLG_E		smallint NOT NULL,	--/D K confusion flag for Kron elliptical mag.
	J_R_C		real NOT NULL,		--/U arcsec --/D J Kron circular aperture radius.
	J_M_C		real NOT NULL,		--/U mag --/D J Kron circular aperture magnitude.
	J_MSIG_C	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in Kron circular mag.
	J_FLG_C		smallint NOT NULL,	--/D J confusion flag for Kron circular mag.
	H_R_C		real NOT NULL,		--/U arcsec --/D H Kron circular aperture radius.
	H_M_C		real NOT NULL,		--/U mag --/D H Kron circular aperture magnitude.
	H_MSIG_C	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in Kron circular mag.
	H_FLG_C		smallint NOT NULL,	--/D H confusion flag for Kron circular mag.
	K_R_C		real NOT NULL,		--/U arcsec --/D K Kron circular aperture radius.
	K_M_C		real NOT NULL,		--/U mag --/D K Kron circular aperture magnitude.
	K_MSIG_C	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in Kron circular mag.
	K_FLG_C		smallint NOT NULL,	--/D K confusion flag for Kron circular mag.
	R_FC		real NOT NULL,		--/U arcsec --/D K fiducial Kron circular aperture radius.
	J_M_FC		real NOT NULL,		--/U mag --/D J fiducial Kron circular magnitude.
	J_MSIG_FC	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in fiducial Kron circ. mag.
	J_FLG_FC	smallint NOT NULL,	--/D J confusion flag for Kron circular mag. confusion flag for fiducial Kron circ. mag.
	H_M_FC		real NOT NULL,		--/U mag --/D H fiducial Kron circular magnitude.
	H_MSIG_FC	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in fiducial Kron circ. mag.
	H_FLG_FC	smallint NOT NULL,	--/D H confusion flag for Kron circular mag. confusion flag for fiducial Kron circ. mag.
	K_M_FC		real NOT NULL,		--/U mag --/D K fiducial Kron circular magnitude.
	K_MSIG_FC	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in fiducial Kron circ. mag.
	K_FLG_FC	smallint NOT NULL,	--/D K confusion flag for Kron circular mag. confusion flag for fiducial Kron circ. mag.
	J_R_I20E	real NOT NULL,		--/U arcsec --/D J 20mag/sq arcsec isophotal elliptical ap. semi-major axis.
	J_M_I20E	real NOT NULL,		--/U mag --/D J 20mag/sq arcsec isophotal elliptical ap. magnitude.
	J_MSIG_I20E	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in 20mag/sq arcsec iso. ell. mag.
	J_FLG_I20E	smallint NOT NULL,	--/D J confusion flag for 20mag/sq arcsec iso. ell. mag.
	H_R_I20E	real NOT NULL,		--/U arcsec --/D H 20mag/sq arcsec isophotal elliptical ap. semi-major axis.
	H_M_I20E	real NOT NULL,		--/U mag --/D H 20mag/sq arcsec isophotal elliptical ap. magnitude.
	H_MSIG_I20E	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in 20mag/sq arcsec iso. ell. mag.
	H_FLG_I20E	smallint NOT NULL,	--/D H confusion flag for 20mag/sq arcsec iso. ell. mag.
	K_R_I20E	real NOT NULL,		--/U arcsec --/D K 20mag/sq arcsec isophotal elliptical ap. semi-major axis.
	K_M_I20E	real NOT NULL,		--/U mag --/D K 20mag/sq arcsec isophotal elliptical ap. magnitude.
	K_MSIG_I20E	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in 20mag/sq arcsec iso. ell. mag.
	K_FLG_I20E	smallint NOT NULL,	--/D K confusion flag for 20mag/sq arcsec iso. ell. mag.
	J_R_I20C	real NOT NULL,		--/U arcsec --/D J 20mag/sq arcsec isophotal circular aperture radius.
	J_M_I20C	real NOT NULL,		--/U mag --/D J 20mag/sq arcsec isophotal circular ap. magnitude.
	J_MSIG_I20C	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in 20mag/sq arcsec iso. circ. mag.
	J_FLG_I20C	smallint NOT NULL,	--/D J confusion flag for 20mag/sq arcsec iso. circ. mag.
	H_R_I20C	real NOT NULL,		--/U arcsec --/D H 20mag/sq arcsec isophotal circular aperture radius.
	H_M_I20C	real NOT NULL,		--/U mag --/D H 20mag/sq arcsec isophotal circular ap. magnitude.
	H_MSIG_I20C	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in 20mag/sq arcsec iso. circ. mag.
	H_FLG_I20C	smallint NOT NULL,	--/D H confusion flag for 20mag/sq arcsec iso. circ. mag.
	K_R_I20C	real NOT NULL,		--/U arcsec --/D K 20mag/sq arcsec isophotal circular aperture radius.
	K_M_I20C	real NOT NULL,		--/U mag --/D K 20mag/sq arcsec isophotal circular ap. magnitude.
	K_MSIG_I20C	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in 20mag/sq arcsec iso. circ. mag.
	K_FLG_I20C	smallint NOT NULL,	--/D K confusion flag for 20mag/sq arcsec iso. circ. mag.
	J_R_I21E	real NOT NULL,		--/U arcsec --/D J 21mag/sq arcsec isophotal elliptical ap. semi-major axis.
	J_M_I21E	real NOT NULL,		--/U mag --/D J 21mag/sq arcsec isophotal elliptical ap. magnitude.
	J_MSIG_I21E	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in 21mag/sq arcsec iso. ell. mag.
	J_FLG_I21E	smallint NOT NULL,	--/D J confusion flag for 21mag/sq arcsec iso. ell. mag.
	H_R_I21E	real NOT NULL,		--/U arcsec --/D H 21mag/sq arcsec isophotal elliptical ap. semi-major axis.
	H_M_I21E	real NOT NULL,		--/U mag --/D H 21mag/sq arcsec isophotal elliptical ap. magnitude.
	H_MSIG_I21E	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in 21mag/sq arcsec iso. ell. mag.
	H_FLG_I21E	smallint NOT NULL,	--/D H confusion flag for 21mag/sq arcsec iso. ell. mag.
	K_R_I21E	real NOT NULL,		--/U arcsec --/D K 21mag/sq arcsec isophotal elliptical ap. semi-major axis.
	K_M_I21E	real NOT NULL,		--/U mag --/D K 21mag/sq arcsec isophotal elliptical ap. magnitude.
	K_MSIG_I21E	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in 21mag/sq arcsec iso. ell. mag.
	K_FLG_I21E	smallint NOT NULL,	--/D K confusion flag for 21mag/sq arcsec iso. ell. mag.
	R_J21FE		real NOT NULL,		--/ 21mag/sq arcsec isophotal J fiducial ell. ap. semi-major axis.
	J_M_J21FE	real NOT NULL,		--/U mag --/D J 21mag/sq arcsec isophotal fiducial ell. ap. magnitude.
	J_MSIG_J21FE	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in 21mag/sq arcsec iso.fid.ell.mag.
	J_FLG_J21FE	smallint NOT NULL,	--/D J confusion flag for 21mag/sq arcsec iso. fid. ell. mag.
	H_M_J21FE	real NOT NULL,		--/U mag --/D H 21mag/sq arcsec isophotal fiducial ell. ap. magnitude.
	H_MSIG_J21FE	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in 21mag/sq arcsec iso.fid.ell.mag.
	H_FLG_J21FE	smallint NOT NULL,	--/D H confusion flag for 21mag/sq arcsec iso. fid. ell. mag.
	K_M_J21FE	real NOT NULL,		--/U mag --/D K 21mag/sq arcsec isophotal fiducial ell. ap. magnitude.
	K_MSIG_J21FE	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in 21mag/sq arcsec iso.fid.ell.mag.
	K_FLG_J21FE	smallint NOT NULL,	--/D K confusion flag for 21mag/sq arcsec iso. fid. ell. mag.
	J_R_I21C	real NOT NULL,		--/U arcsec --/D J 21mag/sq arcsec isophotal circular aperture radius.
	J_M_I21C	real NOT NULL,		--/U mag --/D J 21mag/sq arcsec isophotal circular ap. magnitude.
	J_MSIG_I21C	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in 21mag/sq arcsec iso. circ. mag.
	J_FLG_I21C	smallint NOT NULL,	--/D J confusion flag for 21mag/sq arcsec iso. circ. mag.
	H_R_I21C	real NOT NULL,		--/U arcsec --/D H 21mag/sq arcsec isophotal circular aperture radius.
	H_M_I21C	real NOT NULL,		--/U mag --/D H 21mag/sq arcsec isophotal circular ap. magnitude.
	H_MSIG_I21C	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in 21mag/sq arcsec iso. circ. mag.
	H_FLG_I21C	smallint NOT NULL,	--/D H confusion flag for 21mag/sq arcsec iso. circ. mag.
	K_R_I21C	real NOT NULL,		--/U arcsec --/D K 21mag/sq arcsec isophotal circular aperture radius.
	K_M_I21C	real NOT NULL,		--/U mag --/D K 21mag/sq arcsec isophotal circular ap. magnitude.
	K_MSIG_I21C	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in 21mag/sq arcsec iso. circ. mag.
	K_FLG_I21C	smallint NOT NULL,	--/D K confusion flag for 21mag/sq arcsec iso. circ. mag.
	R_J21FC		real NOT NULL,		--/U arcsec --/D 21mag/sq arcsec isophotal J fiducial circular ap. radius.
	J_M_J21FC	real NOT NULL,		--/U mag --/D J 21mag/sq arcsec isophotal fiducial circ. ap. mag.
	J_MSIG_J21FC	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in 21mag/sq arcsec iso.fid.circ.mag.
	J_FLG_J21FC	smallint NOT NULL,	--/D J confusion flag for 21mag/sq arcsec iso. fid. circ. mag.
	H_M_J21FC	real NOT NULL,		--/U mag --/D H 21mag/sq arcsec isophotal fiducial circ. ap. mag.
	H_MSIG_J21FC	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in 21mag/sq arcsec iso.fid.circ.mag.
	H_FLG_J21FC	smallint NOT NULL,	--/D H confusion flag for 21mag/sq arcsec iso. fid. circ. mag.
	K_M_J21FC	real NOT NULL,		--/U mag --/D K 21mag/sq arcsec isophotal fiducial circ. ap. mag.
	K_MSIG_J21FC	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in 21mag/sq arcsec iso.fid.circ.mag.
	K_FLG_J21FC	smallint NOT NULL,	--/D K confusion flag for 21mag/sq arcsec iso. fid. circ. mag.
	J_M_SYS		real NOT NULL,		--/U mag --/D J system photometry magnitude.
	J_MSIG_SYS	real NOT NULL,		--/U mag --/D J 1-sigma uncertainty in system photometry mag.
	H_M_SYS		real NOT NULL,		--/U mag --/D H system photometry magnitude.
	H_MSIG_SYS	real NOT NULL,		--/U mag --/D H 1-sigma uncertainty in system photometry mag.
	K_M_SYS		real NOT NULL,		--/U mag --/D K system photometry magnitude.
	K_MSIG_SYS	real NOT NULL,		--/U mag --/D K 1-sigma uncertainty in system photometry mag.
	SYS_FLG		smallint NOT NULL,	--/D system flag: 0=no system, 1=nearby galaxy flux incl. in mag.
	CONTAM_FLG	smallint NOT NULL,	--/D contamination flag: 0=no stars, 1=stellar flux incl. in mag.
	J_5SIG_BA	real NOT NULL,		--/D J minor/major axis ratio fit to the 5-sigma isophote.
	J_5SIG_PHI	smallint NOT NULL,	--/U deg --/D J angle to 5-sigma major axis (E of N).
	H_5SIG_BA	real NOT NULL,		--/D H minor/major axis ratio fit to the 5-sigma isophote.
	H_5SIG_PHI	smallint NOT NULL,	--/U deg --/D H angle to 5-sigma major axis (E of N).
	K_5SIG_BA	real NOT NULL,		--/D K minor/major axis ratio fit to the 5-sigma isophote.
	K_5SIG_PHI	smallint NOT NULL,	--/U deg --/D K angle to 5-sigma major axis (E of N).
	J_D_AREA	smallint NOT NULL,	--/U sq arcsec --/D J 5-sigma to 3-sigma differential area.
	J_PERC_DAREA	smallint NOT NULL,	--/U sq arcsec --/D J 5-sigma to 3-sigma percent area change.
	H_D_AREA	smallint NOT NULL,	--/U sq arcsec --/D H 5-sigma to 3-sigma differential area.
	H_PERC_DAREA	smallint NOT NULL,	--/U sq arcsec --/D H 5-sigma to 3-sigma percent area change.
	K_D_AREA	smallint NOT NULL,	--/U sq arcsec --/D K 5-sigma to 3-sigma differential area.
	K_PERC_DAREA	smallint NOT NULL,	--/U sq arcsec --/D K 5-sigma to 3-sigma percent area change.
	J_BISYM_RAT	real NOT NULL,		--/D J bi-symmetric flux ratio.
	J_BISYM_CHI	real NOT NULL,		--/D J bi-symmetric cross-correlation chi.
	H_BISYM_RAT	real NOT NULL,		--/D H bi-symmetric flux ratio.
	H_BISYM_CHI	real NOT NULL,		--/D H bi-symmetric cross-correlation chi.
	K_BISYM_RAT	real NOT NULL,		--/D K bi-symmetric flux ratio.
	K_BISYM_CHI	real NOT NULL,		--/D K bi-symmetric cross-correlation chi.
	J_SH0		real NOT NULL,		--/D J ridge shape (LCSB: BSNR limit).
	J_SIG_SH0	real NOT NULL,		--/D J ridge shape sigma (LCSB: B2SNR limit).
	H_SH0		real NOT NULL,		--/D H ridge shape (LCSB: BSNR limit).
	H_SIG_SH0	real NOT NULL,		--/D H ridge shape sigma (LCSB: B2SNR limit).
	K_SH0		real NOT NULL,		--/D K ridge shape (LCSB: BSNR limit).
	K_SIG_SH0	real NOT NULL,		--/D K ridge shape sigma (LCSB: B2SNR limit).
	J_SC_MXDN	real NOT NULL,		--/D J mxdn (score) (LCSB: BSNR - block/smoothed SNR)
	J_SC_SH		real NOT NULL,		--/D J shape (score).
	J_SC_WSH	real NOT NULL,		--/D J wsh (score) (LCSB: PSNR - peak raw SNR).
	J_SC_R23	real NOT NULL,		--/D J r23 (score) (LCSB: TSNR - integrated SNR for r=15).
	J_SC_1MM	real NOT NULL,		--/D J 1st moment (score) (LCSB: super blk 2,4,8 SNR).
	J_SC_2MM	real NOT NULL,		--/D J 2nd moment (score) (LCSB: SNRMAX - super SNR max).
	J_SC_VINT	real NOT NULL,		--/D J vint (score).
	J_SC_R1		real NOT NULL,		--/D J r1 (score).
	J_SC_MSH	real NOT NULL,		--/D J median shape score.
	H_SC_MXDN	real NOT NULL,		--/D H mxdn (score) (LCSB: BSNR - block/smoothed SNR)
	H_SC_SH		real NOT NULL,		--/D H shape (score).
	H_SC_WSH	real NOT NULL,		--/D H wsh (score) (LCSB: PSNR - peak raw SNR).
	H_SC_R23	real NOT NULL,		--/D H r23 (score) (LCSB: TSNR - integrated SNR for r=15).
	H_SC_1MM	real NOT NULL,		--/D H 1st moment (score) (LCSB: super blk 2,4,8 SNR).
	H_SC_2MM	real NOT NULL,		--/D H 2nd moment (score) (LCSB: SNRMAX - super SNR max).
	H_SC_VINT	real NOT NULL,		--/D H vint (score).
	H_SC_R1		real NOT NULL,		--/D H r1 (score).
	H_SC_MSH	real NOT NULL,		--/D H median shape score.
	K_SC_MXDN	real NOT NULL,		--/D K mxdn (score) (LCSB: BSNR - block/smoothed SNR)
	K_SC_SH		real NOT NULL,		--/D K shape (score).
	K_SC_WSH	real NOT NULL,		--/D K wsh (score) (LCSB: PSNR - peak raw SNR).
	K_SC_R23	real NOT NULL,		--/D K r23 (score) (LCSB: TSNR - integrated SNR for r=15).
	K_SC_1MM	real NOT NULL,		--/D K 1st moment (score) (LCSB: super blk 2,4,8 SNR).
	K_SC_2MM	real NOT NULL,		--/D K 2nd moment (score) (LCSB: SNRMAX - super SNR max).
	K_SC_VINT	real NOT NULL,		--/D K vint (score).
	K_SC_R1		real NOT NULL,		--/D K r1 (score).
	K_SC_MSH	real NOT NULL,		--/D K median shape score.
	J_CHIF_ELLF	real NOT NULL,		--/D J % chi-fraction for elliptical fit to 3-sig isophote.
	K_CHIF_ELLF	real NOT NULL,		--/D K % chi-fraction for elliptical fit to 3-sig isophote.
	ELLFIT_FLG	smallint NOT NULL,	--/D ellipse fitting contamination flag.
	SUP_CHIF_ELLF	real NOT NULL,		--/D super-coadd % chi-fraction for ellip. fit to 3-sig isophote.
	N_BLANK		smallint NOT NULL,	--/D number of blanked source records.
	N_SUB		smallint NOT NULL,	--/D number of subtracted source records.
	BL_SUB_FLG	smallint NOT NULL,	--/D blanked/subtracted src description flag.
	ID_FLG		smallint NOT NULL,	--/D type/galaxy ID flag (0=non-catalog, 1=catalog, 2=LCSB).
	ID_CAT		varchar(100) NOT NULL,	--/D matched galaxy catalog name.
	FG_FLG		varchar(100) NOT NULL,	--/D flux-growth convergence flag.
	BLK_FAC		smallint NOT NULL,	--/D LCSB blocking factor (1, 2, 4, 8).
	DUP_SRC		smallint NOT NULL,	--/D Duplicate source flag.
	USE_SRC		smallint NOT NULL,	--/D Use source flag. 
	PROX		real NOT NULL,		--/U arcsec --/D Proximity. The distance between this source and its nearest neighbor in the PSC. 
	PXPA		smallint NOT NULL,	--/U deg --/D The position angle on the sky of the vector from the source to the nearest neighbor in the PSC, East of North.
	PXCNTR		int NOT NULL,		--/D ext_key value of nearest XSC source.
	DIST_EDGE_NS	int NOT NULL,		--/D The distance from the source to the nearest North or South scan edge. 
	DIST_EDGE_EW	smallint NOT NULL,	--/U arcsec --/D The distance from the source to the nearest East or West scan edge. 
	DIST_EDGE_FLG	varchar(100) NOT NULL,	--/D flag indicating which edges ([n|s][e|w]) are nearest to src.
	PTS_KEY		int NOT NULL,		--/D key to point source data DB record.
	MP_KEY		int NOT NULL,		--/D key to minor planet prediction DB record.
	NIGHT_KEY	smallint NOT NULL,	--/D key to night data record in "scan DB".
	SCAN_KEY	int NOT NULL,		--/D 	key to scan data record in "scan DB".
	COADD_KEY	int NOT NULL,		--/D key to coadd data record in "scan DB".
	HEMIS		varchar(100) NOT NULL,	--/D hemisphere (N/S) of observation. "n" = North/Mt. Hopkins; "s" = South/CTIO. 
	DATE		varchar(100) NOT NULL,	--/D The observation reference date for this source expressed in ISO standard format. 
	SCAN		smallint NOT NULL,	--/D scan number (unique within date).
	COADD		smallint NOT NULL,	--/D 	3-digit coadd number (unique within scan).
	X_COADD		real NOT NULL,		--/U pix --/D x (cross-scan) position (coadd coord.).
	Y_COADD		real NOT NULL,		--/U pix --/D y (in-scan) position (coadd coord.).
	J_SUBST2	real NOT NULL,		--/D J residual background #2 (score).
	H_SUBST2	real NOT NULL,		--/D H residual background #2 (score).
	K_SUBST2	real NOT NULL,		--/D K residual background #2 (score).
	J_BACK		real NOT NULL,		--/U mag/sq arcsec --/D J coadd median background.
	H_BACK		real NOT NULL,		--/U mag/sq arcsec --/D H coadd median background.
	K_BACK		real NOT NULL,		--/U mag/sq arcsec --/D K coadd median background.
	J_RESID_ANN	real NOT NULL,		--/U mag/sq arcsec --/D J residual annulus background median.
	H_RESID_ANN	real NOT NULL,		--/U mag/sq arcsec --/D H residual annulus background median.
	K_RESID_ANN	real NOT NULL,		--/U mag/sq arcsec --/D K residual annulus background median.
	J_BNDG_PER	int NOT NULL,		--/D J banding Fourier Transf. period on this side of coadd.
	J_BNDG_AMP	real NOT NULL,		--/D J banding maximum FT amplitude on this side of coadd.
	H_BNDG_PER	int NOT NULL,		--/D H banding Fourier Transf. period on this side of coadd.
	H_BNDG_AMP	real NOT NULL,		--/D H banding maximum FT amplitude on this side of coadd.
	K_BNDG_PER	int NOT NULL,		--/D K banding Fourier Transf. period on this side of coadd.
	K_BNDG_AMP	real NOT NULL,		--/D K banding maximum FT amplitude on this side of coadd.
	J_SEETRACK	real NOT NULL,		--/D J band seetracking score.
	H_SEETRACK	real NOT NULL,		--/D H band seetracking score.
	K_SEETRACK	real NOT NULL,		--/D K band seetracking score.
	EXT_KEY		int NOT NULL,		--/D entry counter (key) number (unique within table).
	TMASSXSC_ID	int NOT NULL,		--/D source ID number (unique within scan, coadd).
	J_M_5		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (5 arcsec radius) --/F j_m 0
	J_MSIG_5	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (5 arcsec radius) --/F j_msig 0
	J_FLG_5		smallint NOT NULL,	--/D J confusion flag for 5 arcsec circular ap. mag. --/F j_flg 0
	J_M_7		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (7 arcsec radius) --/F j_m 1
	J_MSIG_7	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (7 arcsec radius) --/F j_msig 1
	J_FLG_7		smallint NOT NULL,	--/D J confusion flag for 7 arcsec circular ap. mag. --/F j_flg 1
	J_M_10		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (10 arcsec radius) --/F j_m 2
	J_MSIG_10	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (10 arcsec radius) --/F j_msig 2
	J_FLG_10	smallint NOT NULL,	--/D J confusion flag for 10 arcsec circular ap. mag. --/F j_flg 2
	J_M_15		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (15 arcsec radius) --/F j_m 3
	J_MSIG_15	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (15 arcsec radius) --/F j_msig 3
	J_FLG_15	smallint NOT NULL,	--/D J confusion flag for 15 arcsec circular ap. mag. --/F j_flg 3
	J_M_20		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (20 arcsec radius) --/F j_m 4
	J_MSIG_20	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (20 arcsec radius) --/F j_msig 4
	J_FLG_20	smallint NOT NULL,	--/D J confusion flag for 20 arcsec circular ap. mag. --/F j_flg 4
	J_M_25		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (25 arcsec radius) --/F j_m 5
	J_MSIG_25	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (25 arcsec radius) --/F j_msig 5
	J_FLG_25	smallint NOT NULL,	--/D J confusion flag for 25 arcsec circular ap. mag. --/F j_flg 5
	J_M_30		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (30 arcsec radius) --/F j_m 6
	J_MSIG_30	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (30 arcsec radius) --/F j_msig 6
	J_FLG_30	smallint NOT NULL,	--/D J confusion flag for 30 arcsec circular ap. mag. --/F j_flg 6
	J_M_40		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (40 arcsec radius) --/F j_m 7
	J_MSIG_40	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (40 arcsec radius) --/F j_msig 7
	J_FLG_40	smallint NOT NULL,	--/D J confusion flag for 40 arcsec circular ap. mag. --/F j_flg 7
	J_M_50		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (50 arcsec radius) --/F j_m 8
	J_MSIG_50	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (50 arcsec radius) --/F j_msig 8
	J_FLG_50	smallint NOT NULL,	--/D J confusion flag for 50 arcsec circular ap. mag. --/F j_flg 8
	J_M_60		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (60 arcsec radius) --/F j_m 9
	J_MSIG_60	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (60 arcsec radius) --/F j_msig 9
	J_FLG_60	smallint NOT NULL,	--/D J confusion flag for 60 arcsec circular ap. mag. --/F j_flg 9
	J_M_70		real NOT NULL,		--/U mag --/D J-band circular aperture magnitude (70 arcsec radius) --/F j_m 10
	J_MSIG_70	real NOT NULL,		--/U mag --/D error in J-band circular aperture magnitude (70 arcsec radius) --/F j_msig 10
	J_FLG_70	smallint NOT NULL,	--/D J confusion flag for 70 arcsec circular ap. mag. --/F j_flg 10
	H_M_5		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (5 arcsec radius) --/F h_m 0
	H_MSIG_5	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (5 arcsec radius) --/F h_msig 0
	H_FLG_5		smallint NOT NULL,	--/D H confusion flag for 5 arcsec circular ap. mag. --/F h_flg 0
	H_M_7		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (7 arcsec radius) --/F h_m 1
	H_MSIG_7	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (7 arcsec radius) --/F h_msig 1
	H_FLG_7		smallint NOT NULL,	--/D H confusion flag for 7 arcsec circular ap. mag. --/F h_flg 1
	H_M_10		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (10 arcsec radius) --/F h_m 2
	H_MSIG_10	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (10 arcsec radius) --/F h_msig 2
	H_FLG_10	smallint NOT NULL,	--/D H confusion flag for 10 arcsec circular ap. mag. --/F h_flg 2
	H_M_15		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (15 arcsec radius) --/F h_m 3
	H_MSIG_15	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (15 arcsec radius) --/F h_msig 3
	H_FLG_15	smallint NOT NULL,	--/D H confusion flag for 15 arcsec circular ap. mag. --/F h_flg 3
	H_M_20		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (20 arcsec radius) --/F h_m 4
	H_MSIG_20	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (20 arcsec radius) --/F h_msig 4
	H_FLG_20	smallint NOT NULL,	--/D H confusion flag for 20 arcsec circular ap. mag. --/F h_flg 4
	H_M_25		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (25 arcsec radius) --/F h_m 5
	H_MSIG_25	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (25 arcsec radius) --/F h_msig 5
	H_FLG_25	smallint NOT NULL,	--/D H confusion flag for 25 arcsec circular ap. mag. --/F h_flg 5
	H_M_30		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (30 arcsec radius) --/F h_m 6
	H_MSIG_30	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (30 arcsec radius) --/F h_msig 6
	H_FLG_30	smallint NOT NULL,	--/D H confusion flag for 30 arcsec circular ap. mag. --/F h_flg 6
	H_M_40		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (40 arcsec radius) --/F h_m 7
	H_MSIG_40	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (40 arcsec radius) --/F h_msig 7
	H_FLG_40	smallint NOT NULL,	--/D H confusion flag for 40 arcsec circular ap. mag. --/F h_flg 7
	H_M_50		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (50 arcsec radius) --/F h_m 8
	H_MSIG_50	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (50 arcsec radius) --/F h_msig 8
	H_FLG_50	smallint NOT NULL,	--/D H confusion flag for 50 arcsec circular ap. mag. --/F h_flg 8
	H_M_60		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (60 arcsec radius) --/F h_m 9
	H_MSIG_60	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (60 arcsec radius) --/F h_msig 9
	H_FLG_60	smallint NOT NULL,	--/D H confusion flag for 60 arcsec circular ap. mag. --/F h_flg 9
	H_M_70		real NOT NULL,		--/U mag --/D H-band circular aperture magnitude (70 arcsec radius) --/F h_m 10
	H_MSIG_70	real NOT NULL,		--/U mag --/D error in H-band circular aperture magnitude (70 arcsec radius) --/F h_msig 10
	H_FLG_70	smallint NOT NULL,	--/D H confusion flag for 70 arcsec circular ap. mag. --/F h_flg 10
	K_M_5		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (5 arcsec radius) --/F k_m 0
	K_MSIG_5	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (5 arcsec radius) --/F k_msig 0
	K_FLG_5		smallint NOT NULL,	--/D K confusion flag for 5 arcsec circular ap. mag. --/F k_flg 0 
	K_M_7		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (7 arcsec radius) --/F k_m 1
	K_MSIG_7	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (7 arcsec radius) --/F k_msig 1
	K_FLG_7		smallint NOT NULL,	--/D K confusion flag for 7 arcsec circular ap. mag. --/F k_flg 1
	K_M_10		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (10 arcsec radius) --/F k_m 2
	K_MSIG_10	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (10 arcsec radius) --/F k_msig 2
	K_FLG_10	smallint NOT NULL,	--/D K confusion flag for 10 arcsec circular ap. mag. --/F k_flg 2
	K_M_15		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (15 arcsec radius) --/F k_m 3
	K_MSIG_15	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (15 arcsec radius) --/F k_msig 3
	K_FLG_15	smallint NOT NULL,	--/D K confusion flag for 15 arcsec circular ap. mag. --/F k_flg 3
	K_M_20		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (20 arcsec radius) --/F k_m 4
	K_MSIG_20	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (20 arcsec radius) --/F k_msig 4
	K_FLG_20	smallint NOT NULL,	--/D K confusion flag for 20 arcsec circular ap. mag. --/F k_flg 4
	K_M_25		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (25 arcsec radius) --/F k_m 5
	K_MSIG_25	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (25 arcsec radius) --/F k_msig 5
	K_FLG_25	smallint NOT NULL,	--/D K confusion flag for 25 arcsec circular ap. mag. --/F k_flg 5
	K_M_30		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (30 arcsec radius) --/F k_m 6
	K_MSIG_30	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (30 arcsec radius) --/F k_msig 6
	K_FLG_30	smallint NOT NULL,	--/D K confusion flag for 30 arcsec circular ap. mag. --/F k_flg 6
	K_M_40		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (40 arcsec radius) --/F k_m 7
	K_MSIG_40	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (40 arcsec radius) --/F k_msig 7
	K_FLG_40	smallint NOT NULL,	--/D K confusion flag for 40 arcsec circular ap. mag. --/F k_flg 7
	K_M_50		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (50 arcsec radius) --/F k_m 8
	K_MSIG_50	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (50 arcsec radius) --/F k_msig 8
	K_FLG_50	smallint NOT NULL,	--/D K confusion flag for 50 arcsec circular ap. mag. --/F k_flg 8
	K_M_60		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (60 arcsec radius) --/F k_m 9
	K_MSIG_60	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (60 arcsec radius) --/F k_msig 9
	K_FLG_60	smallint NOT NULL,	--/D K confusion flag for 60 arcsec circular ap. mag. --/F k_flg 9
	K_M_70		real NOT NULL,		--/U mag --/D K-band circular aperture magnitude (70 arcsec radius) --/F k_m 10
	K_MSIG_70	real NOT NULL,		--/U mag --/D error in K-band circular aperture magnitude (70 arcsec radius) --/F k_msig 10
	K_FLG_70	smallint NOT NULL,	--/D K confusion flag for 70 arcsec circular ap. mag. --/F k_flg 10
)

GO
--


--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'FIRST')
	DROP TABLE FIRST
GO
--
EXEC spSetDefaultFileGroup 'FIRST'
GO
CREATE TABLE FIRST (
-------------------------------------------------------------------------------
--/H SDSS objects that match to FIRST objects have their match parameters stored here
-------------------------------------------------------------------------------
	objID		bigint 	NOT NULL,	--/D unique id, points to photoObj --/K ID_MAIN
	ra		float NOT NULL,		--/U deg --/D FIRST source right ascension, J2000 --/F first_ra
	dec		float NOT NULL,		--/U deg --/D FIRST source declination, J2000 --/F first_dec
	warning		varchar(50) NOT NULL,	--/D warning in FIRST catalog --/F first_warning
	peak 		real 	NOT NULL,	--/D Peak FIRST radio flux --/U mJy --/K PHOT_FLUX_RADIO --/F first_fpeak
	integr 		real 	NOT NULL,	--/D Integrated FIRST radio flux --/U mJy  --/K PHOT_FLUX_RADIO --/F first_fint
	rms 		real 	NOT NULL,	--/D rms error in flux --/U mJy  --/K PHOT_FLUX_RADIO ERROR --/F first_rms
	major 		real 	NOT NULL,	--/D Major axis (deconvolved) --/U arcsec --/K EXTENSION_RAD --/F first_maj
	minor 		real 	NOT NULL,	--/D Minor axis (deconvolved) --/U arcsec --/K EXTENSION_SMIN --/F first_min
	pa 		real 	NOT NULL,	--/D position angle (east of north) --/U deg --/K POS_POS-ANG --/F first_pa
	skyrms 		real 	NOT NULL,	--/D background rms error in flux --/U mJy  --/K PHOT_FLUX_RADIO ERROR --/F first_skyrms
)

GO
--


--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'RC3')
	DROP TABLE RC3
GO
--
EXEC spSetDefaultFileGroup 'RC3'
GO
CREATE TABLE RC3 (
-----------------------------------------------------------------------------------
--/H RC3 information for matches to SDSS photometry
--/T All matches to the Third Reference Source Catalog within 6 arcsec are included.
--/T RC3 positions were updated with latest NED positions in 2008.
-----------------------------------------------------------------------------------
	objID		bigint NOT NULL, 		--/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj]. 
	RA		float NOT NULL,			--/U deg  -/D J2000 right ascension in RC3 --/F RC3_RA
	DEC     	float NOT NULL,			--/U deg  -/D J2000 declination in RC3 --/F RC3_DEc
	NAME1		varchar(100) NOT NULL,		--/D designation #1 (Names or NGC and IC) --/F RC3_NAME1
	NAME2		varchar(100) NOT NULL,		--/D designation #2 (UGC, ESO, MCG, UGCA, CGCG) --/F RC3_NAME2
	NAME3		varchar(100) NOT NULL,		--/D designation #3 (other) --/F RC3_NAME3
	PGC		varchar(100) NOT NULL,		--/D Principal Galaxy Catalog number (Paturel et al. 1989) --/F RC3_PGC
	HUBBLE		varchar(100) NOT NULL,		--/D revised Hubble type, coded as in RC2 (Section 3.3.a, page 13). --/F RC3_HUBBLE
	LOGD_25		real NOT NULL,			--/D mean decimal logarithm of the apparent major isophotal diameter measured at or reduced to surface brightness level mu_B = 25.0 B-mag/arcsec^2, as explained in Section 3.4.a, page 21.  Unit of D is 0.1 arcmin to avoid negative entries. --/F RC3_LOGD_25
	LOGD_25Q	varchar(100) NOT NULL,		--/D quality flag for isophotal diameter ("?" if bad) --/F RC3_LOGD_25Q
	LOGD_25ERR	real NOT NULL,			--/D error on mean decimal logarithm of the apparent major isophotal diameter  --/F RC3_LOGD_25ERR
	PA		real NOT NULL,			--/U deg --/D position angle (east of north) --/F RC3_PA
	BT		real NOT NULL,			--/U mag --/D total (asymptotic) magnitude in the B system --/F RC3_BT
	BT_S		varchar(100) NOT NULL,		--/D source code for BT --/F RC3_BT_S
	BTQ		varchar(100) NOT NULL,		--/D quality flag total magnitude ("?" if bad) --/F RC3_BTQ
	BTERR		real NOT NULL,			--/U mag --/D error in total (asymptotic) magnitude in the B system --/F RC3_BTERR
	BMVT		real NOT NULL,			--/U mag --/D total (asymptotic) color index in Johnson B-V  --/F RC3_BMVT
	BMVTQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_BMVTQ
	BMVTERR		real NOT NULL,			--/U mag --/D error in total (asymptotic) color index in Johnson B-V  --/F RC3_BMVTERR
	BMVE		real NOT NULL,			--/U mag --/D color index within effective aperture in Johnson B-V  --/F RC3_BMVE
	BMVEQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_BMVEQ
	BMVEERR		real NOT NULL,			--/U mag --/D error in color index within effective aperture in Johnson B-V  --/F RC3_BMVEERR
	M21		real NOT NULL,			--/D 21-cm emission line magnitude, defined by by m_21 = 21.6 - 2.5 log(S_H), where S_H is the measured neutral hydrogen flux density in units of 10^-24 W/m^2. --/F RC3_M21
	M21Q		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_M21Q
	M21ERR		real NOT NULL,			--/D error in 21-cm emission line magnitude --/F RC3_M21ERR
	V21		real NOT NULL,			--/U km/s --/D mean heliocentric radial velocity from HI observations --/F RC3_V21
	V21Q		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_V21Q
	V21ERR		real NOT NULL,			--/U km/s --/D error in heliocentric radial velocity --/F RC3_V21ERR
	HUBBLE_SRC	varchar(100) NOT NULL,		--/D sources of revised type estimate --/F RC3_HUBBLE_SRC
	N_L 		smallint NOT NULL,		--/D number of luminosity class estimates --/F RC3_N_L
	LOGR_25		real NOT NULL,			--/D mean decimal logarithm of the ratio of the major isophotal diameter, D_25, to the minor isophotal diameter, d_25, measured at or reduced to the surface brightness level mu_B = 25.0 B-mag/arcsec^2. --/F RC3_LOGR_25
	LOGR_25Q	varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_LOGR_25Q
	LOGR_25ERR	real NOT NULL,			--/D error in  decimal logarithm of the ratio of the major isophotal diameter to minor --/F RC3_LOGR_25ERR
	AGB		real NOT NULL,			--/U mag --/D Burstein-Heiles Galactic extinction in B --/F RC3_AGB
	MB		real NOT NULL,			--/U mag --/D photographic magnitude reduced to B_T system --/F RC3_MB
	MBQ		varchar(100) NOT NULL,		--/U mag --/D quality flag ("?" if bad) --/F RC3_MBQ
	MBERR		real NOT NULL,			--/U mag --/D error in photograph magnitude --/F RC3_MBERR
	UMBT		real NOT NULL,			--/U mag --/D total (asymptotic) color index in Johnson U-B  --/F RC3_UMBT
	UMBTQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_UMBTQ
	UMBTERR		real NOT NULL,			--/U mag --/D error in total (asymptotic) color index in Johnson U-B  --/F RC3_UMBTERR
	UMBE		real NOT NULL,			--/U mag --/D color index within effective aperture in Johnson U-B --/F RC3_UMBE
	UMBEQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad), --/F RC3_UMBEQ
	UMBEERR		real NOT NULL,			--/U mag --/D error in color index within effective aperture in Johnson U-B --/F RC3_UMBEERR
	W20		real NOT NULL,			--/U km/s --/D neutral hydrogen line full width (in km/s) measured at the 20% level (I_20/I_max) --/F RC3_W20
	W20Q		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_W20Q
	W20ERR		real NOT NULL,			--/U km/s --/D error in W20 --/F RC3_W20ERR
	VOPT		real NOT NULL,			--/U km/s --/D mean heliocentric radial velocity from optical observations --/F RC3_VOPT
	VOPTQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_VOPTQ
	VOPTERR		real NOT NULL,			--/U km/s --/D error in mean heliocentric radial velocity from optical observations --/F RC3_VOPTERR
	SGL		float NOT NULL,			--/U deg --/D supergalactic longitude --/F RC3_SGL
	SGB		float NOT NULL,			--/U deg --/D supergalactic latitude --/F RC3_SGB
	TYPE		real NOT NULL,			--/D T = mean numerical index of stage along the Hubble sequence in the RC2 system (coded as explained in Section 3.3.c, page 16) --/F RC3_TYPE
	TYPEQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_TYPEQ
	TYPEERR		real NOT NULL,			--/D error in T-type --/F RC3_TYPEERR
	LOGA_E		real NOT NULL,			--/D decimal logarithm of the apparent diameter (in 0.1 arcmin) of the ``effective aperture,'' the circle centered on the nucleus within which one-half of the total B-band flux is emitted --/F RC3_LOGA_E
	LOGA_EQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad)  --/F RC3_LOGA_EQ
	LOGA_EERR	real NOT NULL,			--/D error in decimal logarithm of the apparent diameter (in 0.1 arcmin)  of the ``effective aperture,'' --/F RC3_LOGA_EERR
	AIB		real NOT NULL,			--/U mag --/D internal extinction (for correction to face-on), calcauled from size and T-type --/F RC3_AIB
	MFIR		real NOT NULL,			--/D far-infrared magnitude calculated from m_FIR = - 20.0 - 2.5 logFIR, where FIR is the far infrared continuum flux measured at 60 and 100 microns as listed in the IRAS Point Source Catalog (1987). --/F RC3_MFIR
	BMVT0		real NOT NULL,			--/U mag --/D total B-V color index corrected for Galactic and internal extinction, and for redshift --/F RC3_BMVT0
	MPE		real NOT NULL,			--/U mag/sq arcmin --/D  mean B-band surface brightness in magnitudes per square arcmin (B-mag/arcmin^2) within the effective aperture A_e, and its mean error, as given by the relation MPE = B_T + 0.75 + 5logA_e - 5.26. --/F RC3_MPE
	MPEQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_MPEQ
	MPEERR		real NOT NULL,			--/U mag/sq arcmin --/D error in  mean B-band surface brightness  --/F RC3_MPEERR
	W50		real NOT NULL,			--/U km/s --/D neutral hydrogen line full width (in km/s) measured at the 50% level (I_20/I_max) --/F RC3_W50
	W50Q		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_W50Q
	W50ERR		real NOT NULL,			--/U km/s --/D error in neutral hydrogen line full width (in km/s) measured at the 50% level (I_20/I_max) --/F RC3_W50ERR
	VGSR		real NOT NULL,			--/U km/s --/D  the weighted mean of the neutral hydrogen and optical velocities, corrected to the ``Galactic standard of rest'' --/F RC3_VGSR
	L		real NOT NULL,			--/F RC3_L
	LQ		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_LQ
	LERR		real NOT NULL,			--/D mean numerical luminosity class in the RC2 system  --/F RC3_LERR
	LOGD0		real NOT NULL,			--/D decimal logarithm of the isophotal major diameter corrected to ``face-on'' (inclination = 0 degrees), and corrected for Galactic extinction to A_g = 0, but not for redshift --/F RC3_LOGD0
	SA21		real NOT NULL, 			--/U mag --/D  HI line self-absorption in magnitudes (for correction to face-on), calculated from logR and T >= 1 --/F RC3_SA21
	BT0		real NOT NULL,			--/U mag --/D B_T^0 = total ``face-on'' magnitude corrected for Galactic and internal extinction, and for redshift --/F RC3_BT0
	UMBT0		real NOT NULL,			--/U mag --/D (U-B)_T^0 = total U-B color index corrected for Galactic and internal extinction, and for redshift --/F RC3_UMBT0
	MP25		real NOT NULL, 			--/U mag/sq arcmin --/D  the mean surface brightness in magnitudes per square arcmin (B-mag/arcmin^2) within the mu_B = 25.0 B-mag/arcsec^2 elliptical isophote of major axis D_25 and axis ratio R_25 --/F RC3_MP25
	MP25Q		varchar(100) NOT NULL,		--/D quality flag ("?" if bad) --/F RC3_MP25Q
	MP25ERR		real NOT NULL,			--/U mag/sq arcmin --/D  error inthe mean surface brightness within the mu_B = 25.0 B-mag/arcsec^2  --/F RC3_MP25ERR
	HI		real NOT NULL,			--/D corrected neutral hydrogen index, which is the difference m_21^0 - B_T^0 between the corrected (face-on) 21-cm emission line magnitude and the similarly corrected magnitude in the B_T system.  --/F RC3_HI
	V3K		real NOT NULL,			--/U km/s --/D the weighted mean velocity corrected to the reference frame defined by the 3 K microwave background radiation --/F RC3_V3K
)
GO
--


--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'ROSAT')
	DROP TABLE ROSAT
GO
--
EXEC spSetDefaultFileGroup 'ROSAT'
GO
CREATE TABLE ROSAT (
-----------------------------------------------------------------------------------
--/H ROSAT All-Sky Survey information for matches to SDSS photometry
--/T All matches of SDSS photometric catalog objects to ROSAT All Sky Survey.
--/T Both faint and bright sources used here (indicated as "faint" or "bright"
--/T in CAT column. See detailed documentation at http://www.xray.mpe.mpg.de/rosat/survey/rass-bsc/
-----------------------------------------------------------------------------------
	OBJID bigint NOT NULL,			--/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj]. 
	SOURCENAME varchar(100) NOT NULL,	--/D name of source in ROSAT --/F ROSAT_SOURCENAME 
	RA float NOT NULL,			--/U deg --/D J2000 right ascension of ROSAT source --/F ROSAT_RA 
	DEC float NOT NULL,			--/U deg --/D J2000 declination of ROSAT source --/F ROSAT_DEC 
	RADECERR real NOT NULL,			--/U arcsec --/D error in coordinates --/F ROSAT_RADECERR 
	FLAGS varchar(100) NOT NULL,		--/D screening flags (see ROSAT documentation)--/F ROSAT_FLAGS 
	FLAGS2 varchar(100) NOT NULL,		--/D screening flags (see ROSAT documentation)--/F ROSAT_FLAGS2 
	CPS real NOT NULL,			--/D counts per second in broad band --/F ROSAT_CPS 
	CPS_ERR real NOT NULL,			--/D error in count rate --/F ROSAT_CPS_ERR 
	BGCPS real NOT NULL,			--/D counts per second from background --/F ROSAT_BGCPS 
	EXPTIME real NOT NULL,			--/U sec --/D exposure time --/F ROSAT_EXPTIME 
	HR1 real NOT NULL,			--/D hardness ratio 1 --/F ROSAT_HR1 
	HR1_ERR real NOT NULL,			--/D error in hardness ratio 1 --/F ROSAT_HR1_ERR 
	HR2 real NOT NULL,			--/D hardness ratio 2 --/F ROSAT_HR2 
	HR2_ERR real NOT NULL,			--/D error in hardness ratio 2 --/F ROSAT_HR2_ERR 
	EXT real NOT NULL,			--/U arcsec --/D source extent --/F ROSAT_EXT 
	EXTL real NOT NULL,			--/D likelihood of source extent --/F ROSAT_EXTL 
	SRCL real NOT NULL,			--/D likelihood of source detection --/F ROSAT_SRCL 
	EXTR real NOT NULL,			--/U arcsec --/D extraction radius --/F ROSAT_EXTR 
	PRIORITY varchar(100) NOT NULL,		--/D priority flags (Sliding window detection history using either the background map (M) or the local background (B); 0 = no detection, 1 = detection; order of flags: M-broad, L-broad, M-hard, L-hard, M-soft, L-soft --/F ROSAT_PRIORITY 
	ERANGE varchar(100) NOT NULL,		--/D pulse height amplitude range with highest detection likelihood; A: 11-41, B: 52-201, C: 52-90, D: 91-201 ' ' or 'b' means 'broad' (11-235) --/F ROSAT_ERANGE  
	VIGF real NOT NULL,			--/D vignetting factor --/F ROSAT_VIGF 
	ORGDAT varchar(100) NOT NULL,		--/D date when source was included (format: yymmdd; 000000: removed) --/F ROSAT_ORGDAT 
	MODDAT varchar(100) NOT NULL,		--/D date when source was modified (format: yymmdd; 000000: removed)--/F ROSAT_MODDAT 
	[ID] int NOT NULL,			--/D number of identification candidates in correlation catalog --/F ROSAT_ID 
	FIELDID int NOT NULL,			--/D identification number of SASS field --/F ROSAT_FIELDID 
	SRCNUM int NOT NULL,			--/D SASS source number in SASS field --/F ROSAT_SRCNUM 
	RCT1 smallint NOT NULL,			--/D number of nearby RASS detections with distances between 0 and 5 arcmin --/F ROSAT_RCT1 
	RCT2 smallint NOT NULL,			--/D number of nearby RASS detections with distances between 5 and 10 arcmin --/F ROSAT_RCT2 
	RCT3 smallint NOT NULL,			--/D number of nearby RASS detections with distances between 10 and 15 arcmin --/F ROSAT_RCT3 
	ITB varchar(100) NOT NULL,		--/D start time of observation (yymmdd.ff) --/F ROSAT_ITB 
	ITE varchar(100) NOT NULL,		--/D end time of observation (yymmdd.ff) --/F ROSAT_ITE 
	RL smallint NOT NULL,			--/D reliability of source detection (0 to 99, with 99 being highest) --/F ROSAT_RL 
	CAT varchar(100) NOT NULL,		--/D which catalog the source is in (faint or bright) --/F ROSAT_CAT 
)
GO
--

--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'USNO')
	DROP TABLE USNO
GO
--
EXEC spSetDefaultFileGroup 'USNO'
GO
CREATE TABLE USNO (
-----------------------------------------------------------------------------------
--/H SDSS objects that match to USNO-B objects have their match parameters stored here
--/T The source for this is the USNO-B1.0 catalog (Monet et al. 2003, AJ, 125, 984). 
--/T This is simply the closest matching USNO-B1.0 object. See the ProperMotions table 
--/T for proper motions after recalibrating USNO and SDSS astrometry. 
--/T USNO-B contains five imaging surveys, two early epochs from POSS-I, 
--/T and three later epochs from POSS-II, SERC and AAO. 
-----------------------------------------------------------------------------------
	OBJID bigint NOT NULL,		--/D unique id, points to photoObj --/K ID_MAIN
	RA float NOT NULL,		--/U deg --/D J2000 right ascension in USNO-B1.0    --/F USNO_RA 
	DEC float NOT NULL,		--/U deg --/D J2000 declination in USNO-B1.0		--/F USNO_DEC 
	RAERR float NOT NULL,		--/U arcsec --/D error in R.A.		--/F USNO_RAERR 
	DECERR float NOT NULL,		--/U arcsec --/D error in Dec		--/F USNO_DECERR 
	MEANEPOCH float NOT NULL,	--/U years --/D mean epoch of RA/Dec --/F USNO_MEANEPOCH 
	MURA real NOT NULL,		--/U mas/yr --/D proper motion in RA --/F USNO_MURA 
	MUDEC real NOT NULL,		--/U mas/yr --/D proper motion in Dec --/F USNO_MUDEC 
	PROPERMOTION real NOT NULL,	--/U 0.01 arcsec/yr --/D total proper motion --/F USNO_PROPERMOTION 
	ANGLE real NOT NULL,		--/U deg --/D position angle of proper motion (East of North) --/F USNO_ANGLE 
	MURAERR real NOT NULL,		--/U mas/yr --/D error in proper motion in RA --/F USNO_MURAERR 
	MUDECERR real NOT NULL,		--/U mas/yr --/D error in proper motion in Dec --/F USNO_MUDECERR 
	MUPROB real NOT NULL,		--/D probability of proper motion --/F USNO_MUPROB 
	MUFLAG int NOT NULL,		--/D proper motion flag (0 no, 1 yes) --/F USNO_MUFLAG 
	SFITRA real NOT NULL,		--/U mas --/D sigma of individual observations around best fit motion in RA --/F USNO_SFITRA 
	SFITDEC real NOT NULL,		--/U mas --/D sigma of individual observations around best fit motion in RA --/F USNO_SFITDEC 
	NFITPT int NOT NULL,		--/D number of observations used in the fit --/F USNO_NFITPT 
	MAG_B1 real NOT NULL,		--/U mag --/U magnitude in first blue survey (103a-O) --/F USNO_MAG 0
	MAG_R1 real NOT NULL,		--/U mag --/U magnitude in first red survey (103a-E) --/F USNO_MAG 1
	MAG_B2 real NOT NULL,		--/U mag --/U magnitude in second blue survey (IIIa-J) --/F USNO_MAG 2
	MAG_R2 real NOT NULL,		--/U mag --/U magnitude in second red survey (IIIa-F) --/F USNO_MAG 3
	MAG_I2 real NOT NULL,		--/U mag --/U magnitude in N survey (IV-N) --/F USNO_MAG 4
	FLDID_B1 smallint NOT NULL,	--/D field id in first blue survey --/F USNO_FLDID 0
	FLDID_R1 smallint NOT NULL,	--/D field id in first red survey --/F USNO_FLDID 1
	FLDID_B2 smallint NOT NULL,	--/D field id in second blue survey --/F USNO_FLDID 2
	FLDID_R2 smallint NOT NULL,	--/D field id in second red survey --/F USNO_FLDID 3
	FLDID_I2 smallint NOT NULL,	--/D field id in N survey --/F USNO_FLDID 4
	SG_B1 tinyint NOT NULL,		--/D star/galaxy separation flag in first blue survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar) --/F USNO_SG 0
	SG_R1 tinyint NOT NULL,		--/D star/galaxy separation flag in first red survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar) --/F USNO_SG 1
	SG_B2 tinyint NOT NULL,		--/D star/galaxy separation flag in second blue survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar) --/F USNO_SG 2
	SG_R2 tinyint NOT NULL,		--/D star/galaxy separation flag in second red survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar) --/F USNO_SG 3
	SG_I2 tinyint NOT NULL,		--/D star/galaxy separation flag in N survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar) --/F USNO_SG 4
	FLDEPOCH_B1 real NOT NULL,		--/D epoch of observation in first blue survey --/F USNO_FLDEPOCH 0
	FLDEPOCH_R1 real NOT NULL,		--/D epoch of observation in first red survey --/F USNO_FLDEPOCH 1
	FLDEPOCH_B2 real NOT NULL,		--/D epoch of observation in second blue survey --/F USNO_FLDEPOCH 2
	FLDEPOCH_R2 real NOT NULL,		--/D epoch of observation in second red survey --/F USNO_FLDEPOCH 3
	FLDEPOCH_I2 real NOT NULL,		--/D epoch of observation in N survey --/F USNO_FLDEPOCH 4
)
GO
--



--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'WISE_xmatch')
	DROP TABLE WISE_xmatch
GO
--
EXEC spSetDefaultFileGroup 'WISE_xmatch'
GO
CREATE TABLE WISE_xmatch (
-----------------------------------------------------------------------------------
--/H Astrometric cross-matches between SDSS and WISE objects.
--
--/T This is a "join table" which contains "pointers" to the matched objects
--/T in the SDSS and WISE tables.  The SDSS objects appear in the PhotoObjAll,
--/T PhotoObj,and PhotoTag tables.  The WISE objects appear in the WISE_allsky
--/T table.
--/T Eg, to get r- and W1-band magnitudes of matched objects:
--/T  "select s.psfmag_r as r, w.w1mpro as w1 from wise_xmatch as xm join
--/T photoObjAll as s on xm.sdss_objid = s.objid join wise_allsky as w on
--/T xm.wise_cntr  = w.cntr"
-----------------------------------------------------------------------------------
      sdss_objid BIGINT , --/D SDSS ObjectID of matched SDSS object (foreign key, PhotoObjAll / PhotoObj / PhotoTag . objId)
      wise_cntr  BIGINT , --/D WISE unique ID of matched WISE object (foreign key, WISE_allsky . cntr)
      match_dist REAL     --/D Distance in arcsec between SDSS object RA,Dec and WISE object RA,Dec --/U arcsec
)
GO
--


                                              
--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'WISE_AllSky')
	DROP TABLE WISE_AllSky
GO
--
EXEC spSetDefaultFileGroup 'WISE_AllSky'
GO
CREATE TABLE WISE_allsky (
-----------------------------------------------------------------------------------
--/H WISE All-Sky Data Release catalog
--
--/T The WISE catalog.  The columns have mostly been copied without
--/T modification from the WISE catalog distributed by IRSA, so that
--/T documentation (mostly copied here) largely applies;
--/T http://wise2.ipac.caltech.edu/docs/release/allsky/expsup/sec2_2a.html
--/T
--/T Exceptions include some gratuitous column renames:
--/T   w*sigsk -> w*sigsky
--/T   w*gerr  -> w*siggmag
--/T
--/T And some WISE columns have been combined:
--/T   ext_bit, na, nb  ->  blend_ext_flags
--/T   ph_qual, det_bit ->  phqual_det_*
--/T
--/T And some WISE columns have been unpacked into 4 columns, one per band:
--/T   var_flg, moon_lev, satnum
--/T 
--/T Null values are represented with:
--/T   w*mjd{min,max,mean}: -9999
--/T   w*snr: -9999
--/T   w*{flux,sky}: -9999
--/T   all others: 9999
-----------------------------------------------------------------------------------                                           
    cntr        BIGINT NOT NULL, --/D WISE primary key ('counter')
    ra          FLOAT NOT NULL, --/U deg J2000 --/D RA (right ascension, J2000)
    dec         FLOAT NOT NULL, --/U deg J2000 --/D Dec (declination, J2000)
    sigra       REAL NOT NULL, --/U arcsec --/D uncertainty in RA
    sigdec      REAL NOT NULL, --/U arcsec --/D uncertainty in DEC
    sigradec    REAL NOT NULL, --/U arcsec --/D uncertainty cross-term
    wx          REAL NOT NULL, --/U pixels --/D The x-pixel coordinate of this source on the Atlas Image.
    wy          REAL NOT NULL, --/U pixels --/D The y-pixel coordinate of this source on the Atlas Image.
    glat        float NOT NULL, --/U deg --/D Galactic latitude
    glon        float NOT NULL, --/U deg --/D Galactic longitude
    coadd_id    VARCHAR(13) NOT NULL, --/D Atlas Tile identifier from which source was extracted.
    src         INT NOT NULL, --/D Sequential number of this source extraction in the Atlas Tile from which this source was extracted, in approximate descending order of W1 source brightness.
    rchi2       REAL NOT NULL, --/D Combine reduced chi-squared of the profile-fit photometry measurement in all bands
    xsc_prox    REAL NOT NULL, --/U arcsec --/F xscprox --/D 2MASS Extended Source Catalog (XSC) proximity. This column gives the distance between the WISE source position and the position of a nearby 2MASS XSC source, if the separation is less than 1.1 times the Ks isophotal radius size of the XSC source.
    tmass_key   INT NOT NULL, --/D 2MASS PSC association. Unique identifier of the closest source in the 2MASS Point Source Catalog (PSC) that falls within 3" of the position of this WISE source.
    r_2mass     REAL NOT NULL, --/U arcsec --/D Distance separating the positions of the WISE source and associated 2MASS PSC source within 3"
    pa_2mass    REAL NOT NULL, --/U deg --/D Position angle (degrees E of N) of the vector from the WISE source to the associated 2MASS PSC source
    n_2mass     TINYINT NOT NULL, --/D The number of 2MASS PSC entries found within a 3" radius of the WISE source position
    j_m_2mass   REAL NOT NULL, --/U mag --/D 2MASS J-band magnitude or magnitude upper limit of the associated 2MASS PSC source
    j_msig_2mass REAL NOT NULL, --/U mag --/D 2MASS J-band corrected photometric uncertainty of the associated 2MASS PSC source
    h_m_2mass   REAL NOT NULL, --/U mag --/D 2MASS H-band magnitude or magnitude upper limit of the associated 2MASS PSC source
    h_msig_2mass REAL NOT NULL, --/U mag --/D 2MASS H-band corrected photometric uncertainty of the associated 2MASS PSC source
    k_m_2mass   REAL NOT NULL, --/U mag --/D 2MASS Ks-band magnitude or magnitude upper limit of the associated 2MASS PSC source
    k_msig_2mass REAL NOT NULL, --/U mag --/D 2MASS Ks-band corrected photometric uncertainty of the associated 2MASS PSC source
    rho12       SMALLINT NOT NULL, --/U percent --/D The correlation coefficient between the W1 and W2 single-exposure flux measurements.  Negative values indicate anticorrelation.
    rho23       SMALLINT NOT NULL, --/U percent --/D The correlation coefficient between the W2 and W3 single-exposure flux measurements.  Negative values indicate anticorrelation.
    rho34       SMALLINT NOT NULL, --/U percent --/D The correlation coefficient between the W3 and W4 single-exposure flux measurements.  Negative values indicate anticorrelation.
    q12         TINYINT NOT NULL, --/D Correlation significance between W1 and W2. The value is -log10(Q2(rho12)), where Q2 is the two-tailed fraction of all cases expected to show at least this much apparent positive or negative correlation when in fact there is no correlation. The value is clipped at 9.
    q23         TINYINT NOT NULL, --/D Correlation significance between W2 and W3. The value is -log10(Q2(rho12)), where Q2 is the two-tailed fraction of all cases expected to show at least this much apparent positive or negative correlation when in fact there is no correlation. The value is clipped at 9.
    q34         TINYINT NOT NULL, --/D Correlation significance between W3 and W4. The value is -log10(Q2(rho12)), where Q2 is the two-tailed fraction of all cases expected to show at least this much apparent positive or negative correlation when in fact there is no correlation. The value is clipped at 9.
    blend_ext_flags  TINYINT NOT NULL, --/D Combination of WISE "ext_flg", "na", and "nb" columns.  Bit 5 (32 / 0x20): The profile-fit photometry goodness-of-fit, w?rchi2, is  > 3.0 in one or more bands.  Bit 6 (64 / 0x40): The source falls within the extrapolated isophotal footprint of a 2MASS XSC source.  Bit 7 (128 / 0x80): The source position falls within 5" of a 2MASS XSC source.  Bit 4 (16 / 0x10): WISE "na" column: Active deblending flag. Indicates if a single detection was split into multiple sources in the process of profile-fitting.  Bottom four bits (mask 0xf): WISE "nb" column: Number of PSF components used simultaneously in the profile-fitting for this source. This number includes the source itself, so the minimum value of nb is "1". Nb is greater than "1" when the source is fit concurrently with other nearby detections (passive deblending), or when a single source is split into two components during the fitting process (active deblending).
    w1mpro      REAL NOT NULL, --/U mag --/D W1 magnitude measured with profile-fitting photometry, or the magnitude of the 95% confidence brightness upper limit if the W1 flux measurement has SNR < 2. This column is null if the source is nominally detected in W1, but no useful brightness estimate could be made.
    w1sigmpro   REAL NOT NULL, --/U mag --/D W1 profile-fit photometric measurement uncertainty in mag units. This column is null if the W1 profile-fit magnitude is a 95% confidence upper limit or if the source is not measurable.
    w1snr       REAL NOT NULL, --/D W1 profile-fit measurement signal-to-noise ratio. This value is the ratio of the flux (w1flux) to flux uncertainty (w1sigflux)in the W1 profile-fit photometry measurement. This column is null if w1flux is negative, or if w1flux or w1sigflux are null.
    w1rchi2     REAL NOT NULL, --/D Reduced chi-squared of the W1 profile-fit photometry measurement. This column is null if the W1 magnitude is a 95% confidence upper limit (i.e. the source is not detected).
    w1sat       REAL NOT NULL, --/D Saturated pixel fraction, W1. The fraction of all pixels within the profile-fitting area in the stack of single-exposure images used to characterize this source that are flagged as saturated. A value larger than 0.0 indicates one or more pixels of saturation. Saturation begins to occur for point sources brighter than [W1]~8 mag. Saturation may occur in fainter sources because of a charged particle strike.
    w1nm        TINYINT NOT NULL, --/D Integer frame detection count. This column gives the number of individual 7.7s exposures on which this source was detected with SNR > 3 in the W1 profile-fit measurement. This number can be zero for sources that are well-detected on the coadded Atlas Image, but too faint for detection on the single exposures.
    w1m         TINYINT NOT NULL, --/D Integer frame coverage. This column gives the number of individual 7.7s W1 exposures on which a profile-fit measurement of this source was possible.  This number can differ between the four bands because band-dependent criteria are used to select individual frames for inclusion in the coadded Atlas Images.
    w1cov       REAL NOT NULL, --/D Mean pixel coverage in W1. This column gives the mean pixel value from the W1 Atlas Tile Coverage Map within the "standard" aperture, a circular area with a radius of 8.25" centered on the position of this source.  W1cov may differ from the integer frame coverage value given in w1m for two reasons. First, individual pixels in the measurement area may be masked or otherwise unusable, reducing the effective pixel count and thus the mean coverage value. Second, the effective sky area sampled by a pixels in single-exposure image varies across the focal plane because of field distortion. Distortion is corrected when coadding to generate the Atlas Images. Therefore, the effective number of pixels contributing to a pixel in the Atlas Coverage Map may be slightly smaller or larger than expected if there was no distortion.
    w1frtr      REAL NOT NULL, --/D Fraction of pixels affected by transients. This column gives the fraction of all W1 pixels in the stack of individual W1 exposures used to characterize this source that may be affected by transient events. This number is computed by counting the number of pixels in the single exposure Bit Mask images with value "21" that are present within the profile-fitting area, a circular region with radius of 7.25", centered on the position of this source, and dividing by the total number of pixels in the same area that are available for measurement.
    w1flux      REAL NOT NULL, --/U DN --/D The "raw" W1 source flux measured in profile-fit photometry in units of digital numbers. This value may be negative. This column is null if no useful profile-fit measurement of the source is possible because of masked or otherwise unusable pixels.
    w1sigflux   REAL NOT NULL, --/U DN --/D Uncertainty in the "raw" W1 source flux measurement in profile-fit photometry in units of digital numbers. This column is null if no useful profile-fit measurement of the source is possible because of masked or otherwise unusable pixels.
    w1sky       REAL NOT NULL, --/U DN --/D The trimmed average of the W1 sky background value in digital numbers measured in an annulus with an inner radius of 50" and outer radius of 70". Both profile-fit and aperture photometry source brightness measurements are made relative to this sky background value.  For profile-fit photometry, the sky background is measured on the individual single-exposure images that are used for source characterization. For aperture photometry, the sky background is measured on the Atlas Image.
    w1sigsky    REAL NOT NULL, --/U DN --/F w1sigsk --/D  The uncertainty in the W1 sky background value in units of digital numbers measured in an annulus with an inner radius of 50" and outer radius of 70".
    w1conf      REAL NOT NULL, --/U DN --/D Estimated confusion noise in the W1 sky background annulus, in digital numbers. This number is the difference between the measured noise in the sky background w1sigsk and the noise measured in the same region on the Atlas Uncertainty Maps.
    w1mag       REAL NOT NULL, --/U mag --/D W1 "standard" aperture magnitude. This is the curve-of-growth corrected source brightness measured in an 8.25" radius circular aperture centered on the source position on the Atlas Image. If the source is not detected in the aperture measurement, this is the 95% confidence upper limit to the brightness. The background sky reference level is measured in an annular region with inner radius of 50" and outer radius of 70". The curve-of-growth correction is given in w1mcor.  This column is null if an aperture measurement was not possible in W1.
    w1sigmag    REAL NOT NULL, --/U mag --/F w1sigm --/D Uncertainty in the W1 "standard" aperture magnitude.  This column is null if the W1 "standard" aperture magnitude is an upper limit, or if an aperture measurement was not possible.
    w1mcor      REAL NOT NULL, --/U mag --/D W1 aperture curve-of-growth correction, in magnitudes. This correction is subtracted from the nominal 8.25" aperture photometry brightness, w1mag_2, to give the "standard-aperture" magnitude.
    w1magp      REAL NOT NULL, --/U mag --/D Inverse-variance-weighted mean W1 magnitude computed from profile-fit measurements on the w1m individual frames covering this source. This differs from w1mpro in that it is computed by combining the profile-fit measurements from individual frames, whereas w1mpro is computed by fitting all W1 frames simultaneously and incorporating a robust error model.  This column is "null" if w1m=0, the mean flux is negative or if no individual frame measurements are possible.  CAUTION: This is not a robust measurement of source brightness. It is provided as an internal repeatability diagnostic only. Users should always defer to w1mpro for the optimal flux measurement for point sources.
    w1sigp1     REAL NOT NULL, --/U mag --/D Standard deviation of the population of W1 fluxes measured on the w1m individual frames covering this source, in magnitudes. This provides a measure of the characteristic uncertainty of the measurement of this source on individual frames.  This column is "null" if w1m < 2 or if no individual frame measurements are possible.
    w1sigp2     REAL NOT NULL, --/U mag --/D Standard deviation of the mean of the distribution of W1 fluxes (w1magp) computed from profile-fit measurements on the w1m individual frames covering this source, in magnitudes. This is equivalent to w1sigp1/sqrt(w1m).  This column is "null" if w1m < 2 or if no individual frame measurements are possible.
    w1dmag      REAL NOT NULL, --/U mag --/D Difference between maximum and minimum magnitude of the source from all usable single-exposure frames, W1. Single-exposure measurements with w1rchi2 values greater than 3.0 times the median are rejected from this computation.
    w1mjdmin    FLOAT NOT NULL, --/U MJD --/D The earliest modified Julian Date (mJD) of the W1 single-exposures covering the source.
    w1mjdmax    FLOAT NOT NULL, --/U MJD --/D The latest modified Julian Date (mJD) of the W1 single-exposures covering the source.
    w1mjdmean   FLOAT NOT NULL, --/U MJD --/D The average modified Julian Date (mJD) of the W1 single-exposures covering the source.
    w1rsemi     REAL NOT NULL, --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W1.
    w1ba        REAL NOT NULL, --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W1.
    w1pa        REAL NOT NULL, --/U deg --/D Position angle (degrees E of N) of the elliptical aperture major axis used to measure source in W1.
    w1gmag      REAL NOT NULL, --/U mag --/D W1 magnitude of source measured in the elliptical aperture described by w1rsemi, w1ba, and w1pa.
    w1siggmag   REAL NOT NULL, --/U mag --/F w1gerr --/D Uncertainty in the W1 magnitude of source measured in elliptical aperture.  ("w1gerr" in WISE catalog)
    w1flg       TINYINT NOT NULL, --/D W1 "standard" aperture measurement quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag value is an integer that is the combination of one or more of the following values that signify different conditions: 0 - No contamination; 1 - Source confusion - another source falls within the measurement aperture; 2 - Presence of bad pixels in the measurement aperture; 4 - Non-zero bit flag tripped (other than 2 or 18); 8 - All pixels are flagged as unusable, or the aperture flux is negative. In the former case, the aperture magnitude is "null". In the latter case, the aperture magnitude is a 95% confidence upper limit; 16 - Saturation - there are one or more saturated pixels in the measurement aperture; 32 - The magnitude is a 95% confidence upper limit.
    w1gflg      TINYINT NOT NULL, --/D W1 elliptical aperture measurement quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag values are as described for the "standard" aperture photometry quality flag, w1flg.
    ph_qual_det1 TINYINT NOT NULL, --/F phqual_det_1 --/D Combination of WISE "PH_QUAL" and "DET_BIT" columns.  Bit 0 (1, 0x1): (ph_qual = A) - Source is detected in this band with a flux signal-to-noise ratio w1snr > 10; Bit 1 (2, 0x2): (ph_qual = B) - Source is detected in this band with a flux signal-to-noise ratio 3 < w1snr < 10; Bit 2 (4, 0x4): (ph_qual = C): Source is detected in this band with a flux signal-to-noise ratio 2 < w1snr < 3; Bit 3 (8, 0x8): (ph_qual = D): ??; Bit 4 (16, 0x10): (ph_qual = U): Upper limit on magnitude. Source measurement has w1snr < 2. The profile-fit magnitude w1mpro is a 95% confidence upper limit; Bit 5 (32, 0x20): (ph_qual = X): A profile-fit measurement was not possible at this location in this band. The value of w1mpro and w1sigmpro will be "null" in this band; Bit 6 (64, 0x40): (ph_qual = Z) A profile-fit source flux measurement was made at this location, but the flux uncertainty could not be measured. The value of w1sigmpro will be "null" in this band. The value of w1mpro will be "null" if the measured flux is negative, but will not be "null" if the flux is positive. If a non-null magnitude is presented, it should be treated as a brightness upper limit. This occurs in rare circumstances for very bright, heavily saturated sources; Bit 7 (128, 0x80): "DET_BIT" column: Was the source detected at w1snr  >  2?
    w1ndf       TINYINT NOT NULL, --/D Number of degrees of freedom in the flux variability chi-square, W1.
    w1mlq       TINYINT NOT NULL, --/D Probability measure that the source is variable in W1 flux. The value is -log10(Q), where Q = 1 - P(chi-suared). P is the cumulative chi-square distribution probability for the flux sample measured on the individual single-exposure images. The value is clipped at 9.  The Q value is the fraction of all cases to be expected to be at least as large as that observed if the null hypothesis is true. The null hypothesis is that the flux is emitted by a non-variable astrophysical object. It may be false because the object is a true variable. It may also be false because the flux measurement is corrupted by artifacts such as cosmic rays, scattered light, etc. The smaller the Q value, the more implausible the null hypothesis, i.e., the more likely it is that the flux is either variable or corrupted or both.
    w1cc_map    TINYINT NOT NULL, --/D Contamination and confusion map for this source in W1. This column contains the integer equivalent of the 9-bit binary number that specifies if the W1 measurement is believed to be contaminated by or a spurious detection of an image artifact. The elements of the binary array are:  [S  0  0  0  G  H  0  P  D].  The leftmost bit, S, differentiates whether the band-detection is believed to be a real detection contaminated by an artifact ("0") or a spurious detection of an artifact ("1"). The remaining bits are set to "1" to denote contamination by different types of artifacts according to the letters: D - Diffraction spike. Source may be a spurious detection of or contaminated by a diffraction spike a nearby bright star on the same image.  P - Persistence. Source may be a spurious detection of or contaminated by a short-term latent (persistence) image left by a bright source.  H - Halo. Source may be a spurious detection of or contaminated by the scattered light halo associated with a bright star.  G - Optical ghost. Source may be a spurious detection of or contaminated by an optical ghost image caused by a nearby bright source on the same image.
    var_flg1    TINYINT NOT NULL, --/F var_1     --/D Variability flag for W1.  Related to the probability that the source flux measured on the individual WISE exposures was not constant with time. The probability calculation uses the standard deviation of the single exposure flux measurements, w?sigp1, as well as the band-to-band flux correlation significance, q12,q23,q34.  The probability is computed for a band only when there are at least six single-exposure measurements available that satisfy minimum quality criteria. A value of 16 indicates insufficient or inadequate data to make a determination of possible variability. Values of 0 through 9 indicate increasing probabilities of variation. Values of 0 through 5 are most likely not variables. Sources with values of 6 and 7 are likely flux variables, but are the most susceptible to false-positive variability. Var_flg values greater than 7 have the highest probability of being true flux variables in a band.  CAUTION: Estimation of flux variability is unreliable for sources that are extended (ext_flg > 0), and sources whose measurements are contaminated by image artifacts in a band (cc_flags[b] != '0').
    moon_lev1   TINYINT NOT NULL, --/F moonlev_1 --/D  Scattered moonlight contamination flag; the fraction of single-exposure frames on which the source was measured that were possibly contaminated by scattered moonlight.  The value is given by [ceiling(#frmmoon/#frames*10)], with a maximum value of 9, where #frmmoon is the number of affected frames and #frames is the total number of frames on which the source was measured.
    satnum1     TINYINT NOT NULL, --/F satnum_1  --/D  Minimum sample at which saturation occurs; indicates the minimum SUTR sample in which any pixel in the profile-fitting area in all of the single-exposure images used to characterize this source was flagged as having reached the saturation level in the on-board WISE payload processing. If no pixels are flagged as saturated, the value is 0.
    w2mpro      REAL NOT NULL, --/U mag --/D W2 magnitude measured with profile-fitting photometry, or the magnitude of the 95% confidence brightness upper limit if the W2 flux measurement has SNR < 2. This column is null if the source is nominally detected in W2, but no useful brightness estimate could be made.
    w2sigmpro   REAL NOT NULL, --/U mag --/D W2 profile-fit photometric measurement uncertainty in mag units. This column is null if the W2 profile-fit magnitude is a 95% confidence upper limit or if the source is not measurable.
    w2snr       REAL NOT NULL, --/D W2 profile-fit measurement signal-to-noise ratio. This value is the ratio of the flux (w2flux) to flux uncertainty (w2sigflux)in the W2 profile-fit photometry measurement. This column is null if w2flux is negative, or if w2flux or w2sigflux are null.
    w2rchi2     REAL NOT NULL, --/D Reduced chi-squared of the W2 profile-fit photometry measurement. This column is null if the W2 magnitude is a 95% confidence upper limit (i.e. the source is not detected).
    w2sat       REAL NOT NULL, --/D Saturated pixel fraction, W2. The fraction of all pixels within the profile-fitting area in the stack of single-exposure images used to characterize this source that are flagged as saturated. A value larger than 0.0 indicates one or more pixels of saturation. Saturation begins to occur for point sources brighter than [W2]~8 mag. Saturation may occur in fainter sources because of a charged particle strike.
    w2nm        TINYINT NOT NULL, --/D Integer frame detection count. This column gives the number of individual 7.7s exposures on which this source was detected with SNR > 3 in the W2 profile-fit measurement. This number can be zero for sources that are well-detected on the coadded Atlas Image, but too faint for detection on the single exposures.
    w2m         TINYINT NOT NULL, --/D Integer frame coverage. This column gives the number of individual 7.7s W2 exposures on which a profile-fit measurement of this source was possible.  This number can differ between the four bands because band-dependent criteria are used to select individual frames for inclusion in the coadded Atlas Images.
    w2cov       REAL NOT NULL, --/D Mean pixel coverage in W2. This column gives the mean pixel value from the W2 Atlas Tile Coverage Map within the "standard" aperture, a circular area with a radius of 8.25" centered on the position of this source.  W2cov may differ from the integer frame coverage value given in w2m for two reasons. First, individual pixels in the measurement area may be masked or otherwise unusable, reducing the effective pixel count and thus the mean coverage value. Second, the effective sky area sampled by a pixels in single-exposure image varies across the focal plane because of field distortion. Distortion is corrected when coadding to generate the Atlas Images. Therefore, the effective number of pixels contributing to a pixel in the Atlas Coverage Map may be slightly smaller or larger than expected if there was no distortion.
    w2frtr      REAL NOT NULL, --/D Fraction of pixels affected by transients. This column gives the fraction of all W2 pixels in the stack of individual W2 exposures used to characterize this source that may be affected by transient events. This number is computed by counting the number of pixels in the single exposure Bit Mask images with value "21" that are present within the profile-fitting area, a circular region with radius of 7.25", centered on the position of this source, and dividing by the total number of pixels in the same area that are available for measurement.
    w2flux      REAL NOT NULL, --/U DN --/D The "raw" W2 source flux measured in profile-fit photometry in units of digital numbers. This value may be negative. This column is null if no useful profile-fit measurement of the source is possible because of masked or otherwise unusable pixels.
    w2sigflux   REAL NOT NULL, --/U DN --/D Uncertainty in the "raw" W2 source flux measurement in profile-fit photometry in units of digital numbers. This column is null if no useful profile-fit measurement of the source is possible because of masked or otherwise unusable pixels.
    w2sky       REAL NOT NULL, --/U DN --/D The trimmed average of the W2 sky background value in digital numbers measured in an annulus with an inner radius of 50" and outer radius of 70". Both profile-fit and aperture photometry source brightness measurements are made relative to this sky background value.  For profile-fit photometry, the sky background is measured on the individual single-exposure images that are used for source characterization. For aperture photometry, the sky background is measured on the Atlas Image.
    w2sigsky    REAL NOT NULL, --/U DN --/F w2sigsk --/D  The uncertainty in the W2 sky background value in units of digital numbers measured in an annulus with an inner radius of 50" and outer radius of 70".
    w2conf      REAL NOT NULL, --/U DN --/D Estimated confusion noise in the W2 sky background annulus, in digital numbers. This number is the difference between the measured noise in the sky background w2sigsk and the noise measured in the same region on the Atlas Uncertainty Maps.
    w2mag       REAL NOT NULL, --/U mag --/D W2 "standard" aperture magnitude. This is the curve-of-growth corrected source brightness measured in an 8.25" radius circular aperture centered on the source position on the Atlas Image. If the source is not detected in the aperture measurement, this is the 95% confidence upper limit to the brightness. The background sky reference level is measured in an annular region with inner radius of 50" and outer radius of 70". The curve-of-growth correction is given in w2mcor.  This column is null if an aperture measurement was not possible in W2.
    w2sigmag    REAL NOT NULL, --/U mag --/F w2sigm --/D Uncertainty in the W2 "standard" aperture magnitude.  This column is null if the W2 "standard" aperture magnitude is an upper limit, or if an aperture measurement was not possible.
    w2mcor      REAL NOT NULL, --/U mag --/D W2 aperture curve-of-growth correction, in magnitudes. This correction is subtracted from the nominal 8.25" aperture photometry brightness, w2mag_2, to give the "standard-aperture" magnitude.
    w2magp      REAL NOT NULL, --/U mag --/D Inverse-variance-weighted mean W2 magnitude computed from profile-fit measurements on the w2m individual frames covering this source. This differs from w2mpro in that it is computed by combining the profile-fit measurements from individual frames, whereas w2mpro is computed by fitting all W2 frames simultaneously and incorporating a robust error model.  This column is "null" if w2m=0, the mean flux is negative or if no individual frame measurements are possible.  CAUTION: This is not a robust measurement of source brightness. It is provided as an internal repeatability diagnostic only. Users should always defer to w2mpro for the optimal flux measurement for point sources.
    w2sigp1     REAL NOT NULL, --/U mag --/D Standard deviation of the population of W2 fluxes measured on the w2m individual frames covering this source, in magnitudes. This provides a measure of the characteristic uncertainty of the measurement of this source on individual frames.  This column is "null" if w2m < 2 or if no individual frame measurements are possible.
    w2sigp2     REAL NOT NULL, --/U mag --/D Standard deviation of the mean of the distribution of W2 fluxes (w2magp) computed from profile-fit measurements on the w2m individual frames covering this source, in magnitudes. This is equivalent to w2sigp1/sqrt(w2m).  This column is "null" if w2m < 2 or if no individual frame measurements are possible.
    w2dmag      REAL NOT NULL, --/U mag --/D Difference between maximum and minimum magnitude of the source from all usable single-exposure frames, W2. Single-exposure measurements with w2rchi2 values greater than 3.0 times the median are rejected from this computation.
    w2mjdmin    FLOAT NOT NULL, --/U MJD --/D The earliest modified Julian Date (mJD) of the W2 single-exposures covering the source.
    w2mjdmax    FLOAT NOT NULL, --/U MJD --/D The latest modified Julian Date (mJD) of the W2 single-exposures covering the source.
    w2mjdmean   FLOAT NOT NULL, --/U MJD --/D The average modified Julian Date (mJD) of the W2 single-exposures covering the source.
    w2rsemi     REAL NOT NULL, --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W2.
    w2ba        REAL NOT NULL, --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W2.
    w2pa        REAL NOT NULL, --/U deg --/D Position angle (degrees E of N) of the elliptical aperture major axis used to measure source in W2.
    w2gmag      REAL NOT NULL, --/U mag --/D W2 magnitude of source measured in the elliptical aperture described by w2rsemi, w2ba, and w2pa.
    w2siggmag   REAL NOT NULL, --/U mag --/F w2gerr --/D Uncertainty in the W2 magnitude of source measured in elliptical aperture.  ("w2gerr" in WISE catalog)
    w2flg       TINYINT NOT NULL, --/D W2 "standard" aperture measurement quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag value is an integer that is the combination of one or more of the following values that signify different conditions: 0 - No contamination; 1 - Source confusion - another source falls within the measurement aperture; 2 - Presence of bad pixels in the measurement aperture; 4 - Non-zero bit flag tripped (other than 2 or 18); 8 - All pixels are flagged as unusable, or the aperture flux is negative. In the former case, the aperture magnitude is "null". In the latter case, the aperture magnitude is a 95% confidence upper limit; 16 - Saturation - there are one or more saturated pixels in the measurement aperture; 32 - The magnitude is a 95% confidence upper limit.
    w2gflg      TINYINT NOT NULL, --/D W2 elliptical aperture measurement quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag values are as described for the "standard" aperture photometry quality flag, w2flg.
    ph_qual_det2 TINYINT NOT NULL, --/F phqual_det_2 --/D Combination of WISE "PH_QUAL" and "DET_BIT" columns.  Bit 0 (1, 0x1): (ph_qual = A) - Source is detected in this band with a flux signal-to-noise ratio w2snr > 10; Bit 1 (2, 0x2): (ph_qual = B) - Source is detected in this band with a flux signal-to-noise ratio 3 < w2snr < 10; Bit 2 (4, 0x4): (ph_qual = C): Source is detected in this band with a flux signal-to-noise ratio 2 < w2snr < 3; Bit 3 (8, 0x8): (ph_qual = D): ??; Bit 4 (16, 0x10): (ph_qual = U): Upper limit on magnitude. Source measurement has w2snr < 2. The profile-fit magnitude w2mpro is a 95% confidence upper limit; Bit 5 (32, 0x20): (ph_qual = X): A profile-fit measurement was not possible at this location in this band. The value of w2mpro and w2sigmpro will be "null" in this band; Bit 6 (64, 0x40): (ph_qual = Z) A profile-fit source flux measurement was made at this location, but the flux uncertainty could not be measured. The value of w2sigmpro will be "null" in this band. The value of w2mpro will be "null" if the measured flux is negative, but will not be "null" if the flux is positive. If a non-null magnitude is presented, it should be treated as a brightness upper limit. This occurs in rare circumstances for very bright, heavily saturated sources; Bit 7 (128, 0x80): "DET_BIT" column: Was the source detected at w2snr  >  2?
    w2ndf       TINYINT NOT NULL, --/D Number of degrees of freedom in the flux variability chi-square, W2.
    w2mlq       TINYINT NOT NULL, --/D Probability measure that the source is variable in W2 flux. The value is -log10(Q), where Q = 1 - P(chi-suared). P is the cumulative chi-square distribution probability for the flux sample measured on the individual single-exposure images. The value is clipped at 9.  The Q value is the fraction of all cases to be expected to be at least as large as that observed if the null hypothesis is true. The null hypothesis is that the flux is emitted by a non-variable astrophysical object. It may be false because the object is a true variable. It may also be false because the flux measurement is corrupted by artifacts such as cosmic rays, scattered light, etc. The smaller the Q value, the more implausible the null hypothesis, i.e., the more likely it is that the flux is either variable or corrupted or both.
    w2cc_map    TINYINT NOT NULL, --/D Contamination and confusion map for this source in W2. This column contains the integer equivalent of the 9-bit binary number that specifies if the W2 measurement is believed to be contaminated by or a spurious detection of an image artifact. The elements of the binary array are:  [S  0  0  0  G  H  0  P  D].  The leftmost bit, S, differentiates whether the band-detection is believed to be a real detection contaminated by an artifact ("0") or a spurious detection of an artifact ("1"). The remaining bits are set to "1" to denote contamination by different types of artifacts according to the letters: D - Diffraction spike. Source may be a spurious detection of or contaminated by a diffraction spike a nearby bright star on the same image.  P - Persistence. Source may be a spurious detection of or contaminated by a short-term latent (persistence) image left by a bright source.  H - Halo. Source may be a spurious detection of or contaminated by the scattered light halo associated with a bright star.  G - Optical ghost. Source may be a spurious detection of or contaminated by an optical ghost image caused by a nearby bright source on the same image.
    var_flg2    TINYINT NOT NULL, --/F var_2     --/D Variability flag for W2.  Related to the probability that the source flux measured on the individual WISE exposures was not constant with time. The probability calculation uses the standard deviation of the single exposure flux measurements, w?sigp1, as well as the band-to-band flux correlation significance, q12,q23,q34.  The probability is computed for a band only when there are at least six single-exposure measurements available that satisfy minimum quality criteria. A value of 16 indicates insufficient or inadequate data to make a determination of possible variability. Values of 0 through 9 indicate increasing probabilities of variation. Values of 0 through 5 are most likely not variables. Sources with values of 6 and 7 are likely flux variables, but are the most susceptible to false-positive variability. Var_flg values greater than 7 have the highest probability of being true flux variables in a band.  CAUTION: Estimation of flux variability is unreliable for sources that are extended (ext_flg > 0), and sources whose measurements are contaminated by image artifacts in a band (cc_flags[b] != '0').
    moon_lev2   TINYINT NOT NULL, --/F moonlev_2 --/D  Scattered moonlight contamination flag; the fraction of single-exposure frames on which the source was measured that were possibly contaminated by scattered moonlight.  The value is given by [ceiling(#frmmoon/#frames*10)], with a maximum value of 9, where #frmmoon is the number of affected frames and #frames is the total number of frames on which the source was measured.
    satnum2     TINYINT NOT NULL, --/F satnum_2  --/D  Minimum sample at which saturation occurs; indicates the minimum SUTR sample in which any pixel in the profile-fitting area in all of the single-exposure images used to characterize this source was flagged as having reached the saturation level in the on-board WISE payload processing. If no pixels are flagged as saturated, the value is 0.
    w3mpro      REAL NOT NULL, --/U mag --/D W3 magnitude measured with profile-fitting photometry, or the magnitude of the 95% confidence brightness upper limit if the W3 flux measurement has SNR < 2. This column is null if the source is nominally detected in W3, but no useful brightness estimate could be made.
    w3sigmpro   REAL NOT NULL, --/U mag --/D W3 profile-fit photometric measurement uncertainty in mag units. This column is null if the W3 profile-fit magnitude is a 95% confidence upper limit or if the source is not measurable.
    w3snr       REAL NOT NULL, --/D W3 profile-fit measurement signal-to-noise ratio. This value is the ratio of the flux (w3flux) to flux uncertainty (w3sigflux)in the W3 profile-fit photometry measurement. This column is null if w3flux is negative, or if w3flux or w3sigflux are null.
    w3rchi2     REAL NOT NULL, --/D Reduced chi-squared of the W3 profile-fit photometry measurement. This column is null if the W3 magnitude is a 95% confidence upper limit (i.e. the source is not detected).
    w3sat       REAL NOT NULL, --/D Saturated pixel fraction, W3. The fraction of all pixels within the profile-fitting area in the stack of single-exposure images used to characterize this source that are flagged as saturated. A value larger than 0.0 indicates one or more pixels of saturation. Saturation begins to occur for point sources brighter than [W3]~8 mag. Saturation may occur in fainter sources because of a charged particle strike.
    w3nm        TINYINT NOT NULL, --/D Integer frame detection count. This column gives the number of individual 7.7s exposures on which this source was detected with SNR > 3 in the W3 profile-fit measurement. This number can be zero for sources that are well-detected on the coadded Atlas Image, but too faint for detection on the single exposures.
    w3m         TINYINT NOT NULL, --/D Integer frame coverage. This column gives the number of individual 7.7s W3 exposures on which a profile-fit measurement of this source was possible.  This number can differ between the four bands because band-dependent criteria are used to select individual frames for inclusion in the coadded Atlas Images.
    w3cov       REAL NOT NULL, --/D Mean pixel coverage in W3. This column gives the mean pixel value from the W3 Atlas Tile Coverage Map within the "standard" aperture, a circular area with a radius of 8.25" centered on the position of this source.  W3cov may differ from the integer frame coverage value given in w3m for two reasons. First, individual pixels in the measurement area may be masked or otherwise unusable, reducing the effective pixel count and thus the mean coverage value. Second, the effective sky area sampled by a pixels in single-exposure image varies across the focal plane because of field distortion. Distortion is corrected when coadding to generate the Atlas Images. Therefore, the effective number of pixels contributing to a pixel in the Atlas Coverage Map may be slightly smaller or larger than expected if there was no distortion.
    w3frtr      REAL NOT NULL, --/D Fraction of pixels affected by transients. This column gives the fraction of all W3 pixels in the stack of individual W3 exposures used to characterize this source that may be affected by transient events. This number is computed by counting the number of pixels in the single exposure Bit Mask images with value "21" that are present within the profile-fitting area, a circular region with radius of 7.25", centered on the position of this source, and dividing by the total number of pixels in the same area that are available for measurement.
    w3flux      REAL NOT NULL, --/U DN --/D The "raw" W3 source flux measured in profile-fit photometry in units of digital numbers. This value may be negative. This column is null if no useful profile-fit measurement of the source is possible because of masked or otherwise unusable pixels.
    w3sigflux   REAL NOT NULL, --/U DN --/D Uncertainty in the "raw" W3 source flux measurement in profile-fit photometry in units of digital numbers. This column is null if no useful profile-fit measurement of the source is possible because of masked or otherwise unusable pixels.
    w3sky       REAL NOT NULL, --/U DN --/D The trimmed average of the W3 sky background value in digital numbers measured in an annulus with an inner radius of 50" and outer radius of 70". Both profile-fit and aperture photometry source brightness measurements are made relative to this sky background value.  For profile-fit photometry, the sky background is measured on the individual single-exposure images that are used for source characterization. For aperture photometry, the sky background is measured on the Atlas Image.
    w3sigsky    REAL NOT NULL, --/U DN --/F w3sigsk --/D  The uncertainty in the W3 sky background value in units of digital numbers measured in an annulus with an inner radius of 50" and outer radius of 70".
    w3conf      REAL NOT NULL, --/U DN --/D Estimated confusion noise in the W3 sky background annulus, in digital numbers. This number is the difference between the measured noise in the sky background w3sigsk and the noise measured in the same region on the Atlas Uncertainty Maps.
    w3mag       REAL NOT NULL, --/U mag --/D W3 "standard" aperture magnitude. This is the curve-of-growth corrected source brightness measured in an 8.25" radius circular aperture centered on the source position on the Atlas Image. If the source is not detected in the aperture measurement, this is the 95% confidence upper limit to the brightness. The background sky reference level is measured in an annular region with inner radius of 50" and outer radius of 70". The curve-of-growth correction is given in w3mcor.  This column is null if an aperture measurement was not possible in W3.
    w3sigmag    REAL NOT NULL, --/U mag --/F w3sigm --/D Uncertainty in the W3 "standard" aperture magnitude.  This column is null if the W3 "standard" aperture magnitude is an upper limit, or if an aperture measurement was not possible.
    w3mcor      REAL NOT NULL, --/U mag --/D W3 aperture curve-of-growth correction, in magnitudes. This correction is subtracted from the nominal 8.25" aperture photometry brightness, w3mag_2, to give the "standard-aperture" magnitude.
    w3magp      REAL NOT NULL, --/U mag --/D Inverse-variance-weighted mean W3 magnitude computed from profile-fit measurements on the w3m individual frames covering this source. This differs from w3mpro in that it is computed by combining the profile-fit measurements from individual frames, whereas w3mpro is computed by fitting all W3 frames simultaneously and incorporating a robust error model.  This column is "null" if w3m=0, the mean flux is negative or if no individual frame measurements are possible.  CAUTION: This is not a robust measurement of source brightness. It is provided as an internal repeatability diagnostic only. Users should always defer to w3mpro for the optimal flux measurement for point sources.
    w3sigp1     REAL NOT NULL, --/U mag --/D Standard deviation of the population of W3 fluxes measured on the w3m individual frames covering this source, in magnitudes. This provides a measure of the characteristic uncertainty of the measurement of this source on individual frames.  This column is "null" if w3m < 2 or if no individual frame measurements are possible.
    w3sigp2     REAL NOT NULL, --/U mag --/D Standard deviation of the mean of the distribution of W3 fluxes (w3magp) computed from profile-fit measurements on the w3m individual frames covering this source, in magnitudes. This is equivalent to w3sigp1/sqrt(w3m).  This column is "null" if w3m < 2 or if no individual frame measurements are possible.
    w3dmag      REAL NOT NULL, --/U mag --/D Difference between maximum and minimum magnitude of the source from all usable single-exposure frames, W3. Single-exposure measurements with w3rchi2 values greater than 3.0 times the median are rejected from this computation.
    w3mjdmin    FLOAT NOT NULL, --/U MJD --/D The earliest modified Julian Date (mJD) of the W3 single-exposures covering the source.
    w3mjdmax    FLOAT NOT NULL, --/U MJD --/D The latest modified Julian Date (mJD) of the W3 single-exposures covering the source.
    w3mjdmean   FLOAT NOT NULL, --/U MJD --/D The average modified Julian Date (mJD) of the W3 single-exposures covering the source.
    w3rsemi     REAL NOT NULL, --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W3.
    w3ba        REAL NOT NULL, --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W3.
    w3pa        REAL NOT NULL, --/U deg --/D Position angle (degrees E of N) of the elliptical aperture major axis used to measure source in W3.
    w3gmag      REAL NOT NULL, --/U mag --/D W3 magnitude of source measured in the elliptical aperture described by w3rsemi, w3ba, and w3pa.
    w3siggmag   REAL NOT NULL, --/U mag --/F w3gerr --/D Uncertainty in the W3 magnitude of source measured in elliptical aperture.  ("w3gerr" in WISE catalog)
    w3flg       TINYINT NOT NULL, --/D W3 "standard" aperture measurement quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag value is an integer that is the combination of one or more of the following values that signify different conditions: 0 - No contamination; 1 - Source confusion - another source falls within the measurement aperture; 2 - Presence of bad pixels in the measurement aperture; 4 - Non-zero bit flag tripped (other than 2 or 18); 8 - All pixels are flagged as unusable, or the aperture flux is negative. In the former case, the aperture magnitude is "null". In the latter case, the aperture magnitude is a 95% confidence upper limit; 16 - Saturation - there are one or more saturated pixels in the measurement aperture; 32 - The magnitude is a 95% confidence upper limit.
    w3gflg      TINYINT NOT NULL, --/D W3 elliptical aperture measurement quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag values are as described for the "standard" aperture photometry quality flag, w3flg.
    ph_qual_det3 TINYINT NOT NULL, --/F phqual_det_3 --/D Combination of WISE "PH_QUAL" and "DET_BIT" columns.  Bit 0 (1, 0x1): (ph_qual = A) - Source is detected in this band with a flux signal-to-noise ratio w3snr > 10; Bit 1 (2, 0x2): (ph_qual = B) - Source is detected in this band with a flux signal-to-noise ratio 3 < w3snr < 10; Bit 2 (4, 0x4): (ph_qual = C): Source is detected in this band with a flux signal-to-noise ratio 2 < w3snr < 3; Bit 3 (8, 0x8): (ph_qual = D): ??; Bit 4 (16, 0x10): (ph_qual = U): Upper limit on magnitude. Source measurement has w3snr < 2. The profile-fit magnitude w3mpro is a 95% confidence upper limit; Bit 5 (32, 0x20): (ph_qual = X): A profile-fit measurement was not possible at this location in this band. The value of w3mpro and w3sigmpro will be "null" in this band; Bit 6 (64, 0x40): (ph_qual = Z) A profile-fit source flux measurement was made at this location, but the flux uncertainty could not be measured. The value of w3sigmpro will be "null" in this band. The value of w3mpro will be "null" if the measured flux is negative, but will not be "null" if the flux is positive. If a non-null magnitude is presented, it should be treated as a brightness upper limit. This occurs in rare circumstances for very bright, heavily saturated sources; Bit 7 (128, 0x80): "DET_BIT" column: Was the source detected at w3snr  >  2?
    w3ndf       TINYINT NOT NULL, --/D Number of degrees of freedom in the flux variability chi-square, W3.
    w3mlq       TINYINT NOT NULL, --/D Probability measure that the source is variable in W3 flux. The value is -log10(Q), where Q = 1 - P(chi-suared). P is the cumulative chi-square distribution probability for the flux sample measured on the individual single-exposure images. The value is clipped at 9.  The Q value is the fraction of all cases to be expected to be at least as large as that observed if the null hypothesis is true. The null hypothesis is that the flux is emitted by a non-variable astrophysical object. It may be false because the object is a true variable. It may also be false because the flux measurement is corrupted by artifacts such as cosmic rays, scattered light, etc. The smaller the Q value, the more implausible the null hypothesis, i.e., the more likely it is that the flux is either variable or corrupted or both.
    w3cc_map    TINYINT NOT NULL, --/D Contamination and confusion map for this source in W3. This column contains the integer equivalent of the 9-bit binary number that specifies if the W3 measurement is believed to be contaminated by or a spurious detection of an image artifact. The elements of the binary array are:  [S  0  0  0  G  H  0  P  D].  The leftmost bit, S, differentiates whether the band-detection is believed to be a real detection contaminated by an artifact ("0") or a spurious detection of an artifact ("1"). The remaining bits are set to "1" to denote contamination by different types of artifacts according to the letters: D - Diffraction spike. Source may be a spurious detection of or contaminated by a diffraction spike a nearby bright star on the same image.  P - Persistence. Source may be a spurious detection of or contaminated by a short-term latent (persistence) image left by a bright source.  H - Halo. Source may be a spurious detection of or contaminated by the scattered light halo associated with a bright star.  G - Optical ghost. Source may be a spurious detection of or contaminated by an optical ghost image caused by a nearby bright source on the same image.
    var_flg3    TINYINT NOT NULL, --/F var_3     --/D Variability flag for W3.  Related to the probability that the source flux measured on the individual WISE exposures was not constant with time. The probability calculation uses the standard deviation of the single exposure flux measurements, w?sigp1, as well as the band-to-band flux correlation significance, q12,q23,q34.  The probability is computed for a band only when there are at least six single-exposure measurements available that satisfy minimum quality criteria. A value of 16 indicates insufficient or inadequate data to make a determination of possible variability. Values of 0 through 9 indicate increasing probabilities of variation. Values of 0 through 5 are most likely not variables. Sources with values of 6 and 7 are likely flux variables, but are the most susceptible to false-positive variability. Var_flg values greater than 7 have the highest probability of being true flux variables in a band.  CAUTION: Estimation of flux variability is unreliable for sources that are extended (ext_flg > 0), and sources whose measurements are contaminated by image artifacts in a band (cc_flags[b] != '0').
    moon_lev3   TINYINT NOT NULL, --/F moonlev_3 --/D  Scattered moonlight contamination flag; the fraction of single-exposure frames on which the source was measured that were possibly contaminated by scattered moonlight.  The value is given by [ceiling(#frmmoon/#frames*10)], with a maximum value of 9, where #frmmoon is the number of affected frames and #frames is the total number of frames on which the source was measured.
    satnum3     TINYINT NOT NULL, --/F satnum_3  --/D  Minimum sample at which saturation occurs; indicates the minimum SUTR sample in which any pixel in the profile-fitting area in all of the single-exposure images used to characterize this source was flagged as having reached the saturation level in the on-board WISE payload processing. If no pixels are flagged as saturated, the value is 0.
    w4mpro      REAL NOT NULL, --/U mag --/D W4 magnitude measured with profile-fitting photometry, or the magnitude of the 95% confidence brightness upper limit if the W4 flux measurement has SNR < 2. This column is null if the source is nominally detected in W4, but no useful brightness estimate could be made.
    w4sigmpro   REAL NOT NULL, --/U mag --/D W4 profile-fit photometric measurement uncertainty in mag units. This column is null if the W4 profile-fit magnitude is a 95% confidence upper limit or if the source is not measurable.
    w4snr       REAL NOT NULL, --/D W4 profile-fit measurement signal-to-noise ratio. This value is the ratio of the flux (w4flux) to flux uncertainty (w4sigflux)in the W4 profile-fit photometry measurement. This column is null if w4flux is negative, or if w4flux or w4sigflux are null.
    w4rchi2     REAL NOT NULL, --/D Reduced chi-squared of the W4 profile-fit photometry measurement. This column is null if the W4 magnitude is a 95% confidence upper limit (i.e. the source is not detected).
    w4sat       REAL NOT NULL, --/D Saturated pixel fraction, W4. The fraction of all pixels within the profile-fitting area in the stack of single-exposure images used to characterize this source that are flagged as saturated. A value larger than 0.0 indicates one or more pixels of saturation. Saturation begins to occur for point sources brighter than [W4]~8 mag. Saturation may occur in fainter sources because of a charged particle strike.
    w4nm        TINYINT NOT NULL, --/D Integer frame detection count. This column gives the number of individual 7.7s exposures on which this source was detected with SNR > 3 in the W4 profile-fit measurement. This number can be zero for sources that are well-detected on the coadded Atlas Image, but too faint for detection on the single exposures.
    w4m         TINYINT NOT NULL, --/D Integer frame coverage. This column gives the number of individual 7.7s W4 exposures on which a profile-fit measurement of this source was possible.  This number can differ between the four bands because band-dependent criteria are used to select individual frames for inclusion in the coadded Atlas Images.
    w4cov       REAL NOT NULL, --/D Mean pixel coverage in W4. This column gives the mean pixel value from the W4 Atlas Tile Coverage Map within the "standard" aperture, a circular area with a radius of 8.25" centered on the position of this source.  W4cov may differ from the integer frame coverage value given in w4m for two reasons. First, individual pixels in the measurement area may be masked or otherwise unusable, reducing the effective pixel count and thus the mean coverage value. Second, the effective sky area sampled by a pixels in single-exposure image varies across the focal plane because of field distortion. Distortion is corrected when coadding to generate the Atlas Images. Therefore, the effective number of pixels contributing to a pixel in the Atlas Coverage Map may be slightly smaller or larger than expected if there was no distortion.
    w4frtr      REAL NOT NULL, --/D Fraction of pixels affected by transients. This column gives the fraction of all W4 pixels in the stack of individual W4 exposures used to characterize this source that may be affected by transient events. This number is computed by counting the number of pixels in the single exposure Bit Mask images with value "21" that are present within the profile-fitting area, a circular region with radius of 7.25", centered on the position of this source, and dividing by the total number of pixels in the same area that are available for measurement.
    w4flux      REAL NOT NULL, --/U DN --/D The "raw" W4 source flux measured in profile-fit photometry in units of digital numbers. This value may be negative. This column is null if no useful profile-fit measurement of the source is possible because of masked or otherwise unusable pixels.
    w4sigflux   REAL NOT NULL, --/U DN --/D Uncertainty in the "raw" W4 source flux measurement in profile-fit photometry in units of digital numbers. This column is null if no useful profile-fit measurement of the source is possible because of masked or otherwise unusable pixels.
    w4sky       REAL NOT NULL, --/U DN --/D The trimmed average of the W4 sky background value in digital numbers measured in an annulus with an inner radius of 50" and outer radius of 70". Both profile-fit and aperture photometry source brightness measurements are made relative to this sky background value.  For profile-fit photometry, the sky background is measured on the individual single-exposure images that are used for source characterization. For aperture photometry, the sky background is measured on the Atlas Image.
    w4sigsky    REAL NOT NULL, --/U DN --/F w4sigsk --/D  The uncertainty in the W4 sky background value in units of digital numbers measured in an annulus with an inner radius of 50" and outer radius of 70".
    w4conf      REAL NOT NULL, --/U DN --/D Estimated confusion noise in the W4 sky background annulus, in digital numbers. This number is the difference between the measured noise in the sky background w4sigsk and the noise measured in the same region on the Atlas Uncertainty Maps.
    w4mag       REAL NOT NULL, --/U mag --/D W4 "standard" aperture magnitude. This is the curve-of-growth corrected source brightness measured in an 8.25" radius circular aperture centered on the source position on the Atlas Image. If the source is not detected in the aperture measurement, this is the 95% confidence upper limit to the brightness. The background sky reference level is measured in an annular region with inner radius of 50" and outer radius of 70". The curve-of-growth correction is given in w4mcor.  This column is null if an aperture measurement was not possible in W4.
    w4sigmag    REAL NOT NULL, --/U mag --/F w4sigm --/D Uncertainty in the W4 "standard" aperture magnitude.  This column is null if the W4 "standard" aperture magnitude is an upper limit, or if an aperture measurement was not possible.
    w4mcor      REAL NOT NULL, --/U mag --/D W4 aperture curve-of-growth correction, in magnitudes. This correction is subtracted from the nominal 8.25" aperture photometry brightness, w4mag_2, to give the "standard-aperture" magnitude.
    w4magp      REAL NOT NULL, --/U mag --/D Inverse-variance-weighted mean W4 magnitude computed from profile-fit measurements on the w4m individual frames covering this source. This differs from w4mpro in that it is computed by combining the profile-fit measurements from individual frames, whereas w4mpro is computed by fitting all W4 frames simultaneously and incorporating a robust error model.  This column is "null" if w4m=0, the mean flux is negative or if no individual frame measurements are possible.  CAUTION: This is not a robust measurement of source brightness. It is provided as an internal repeatability diagnostic only. Users should always defer to w4mpro for the optimal flux measurement for point sources.
    w4sigp1     REAL NOT NULL, --/U mag --/D Standard deviation of the population of W4 fluxes measured on the w4m individual frames covering this source, in magnitudes. This provides a measure of the characteristic uncertainty of the measurement of this source on individual frames.  This column is "null" if w4m < 2 or if no individual frame measurements are possible.
    w4sigp2     REAL NOT NULL, --/U mag --/D Standard deviation of the mean of the distribution of W4 fluxes (w4magp) computed from profile-fit measurements on the w4m individual frames covering this source, in magnitudes. This is equivalent to w4sigp1/sqrt(w4m).  This column is "null" if w4m < 2 or if no individual frame measurements are possible.
    w4dmag      REAL NOT NULL, --/U mag --/D Difference between maximum and minimum magnitude of the source from all usable single-exposure frames, W4. Single-exposure measurements with w4rchi2 values greater than 3.0 times the median are rejected from this computation.
    w4mjdmin    FLOAT NOT NULL, --/U MJD --/D The earliest modified Julian Date (mJD) of the W4 single-exposures covering the source.
    w4mjdmax    FLOAT NOT NULL, --/U MJD --/D The latest modified Julian Date (mJD) of the W4 single-exposures covering the source.
    w4mjdmean   FLOAT NOT NULL, --/U MJD --/D The average modified Julian Date (mJD) of the W4 single-exposures covering the source.
    w4rsemi     REAL NOT NULL, --/U arcsec --/D Semi-major axis of the elliptical aperture used to measure source in W4.
    w4ba        REAL NOT NULL, --/D Axis ratio (b/a) of the elliptical aperture used to measure source in W4.
    w4pa        REAL NOT NULL, --/U deg --/D Position angle (degrees E of N) of the elliptical aperture major axis used to measure source in W4.
    w4gmag      REAL NOT NULL, --/U mag --/D W4 magnitude of source measured in the elliptical aperture described by w4rsemi, w4ba, and w4pa.
    w4siggmag   REAL NOT NULL, --/U mag --/F w4gerr --/D Uncertainty in the W4 magnitude of source measured in elliptical aperture.  ("w4gerr" in WISE catalog)
    w4flg       TINYINT NOT NULL, --/D W4 "standard" aperture measurement quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag value is an integer that is the combination of one or more of the following values that signify different conditions: 0 - No contamination; 1 - Source confusion - another source falls within the measurement aperture; 2 - Presence of bad pixels in the measurement aperture; 4 - Non-zero bit flag tripped (other than 2 or 18); 8 - All pixels are flagged as unusable, or the aperture flux is negative. In the former case, the aperture magnitude is "null". In the latter case, the aperture magnitude is a 95% confidence upper limit; 16 - Saturation - there are one or more saturated pixels in the measurement aperture; 32 - The magnitude is a 95% confidence upper limit.
    w4gflg      TINYINT NOT NULL, --/D W4 elliptical aperture measurement quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag values are as described for the "standard" aperture photometry quality flag, w4flg.
    ph_qual_det4 TINYINT NOT NULL, --/F phqual_det_4 --/D Combination of WISE "PH_QUAL" and "DET_BIT" columns.  Bit 0 (1, 0x1): (ph_qual = A) - Source is detected in this band with a flux signal-to-noise ratio w4snr > 10; Bit 1 (2, 0x2): (ph_qual = B) - Source is detected in this band with a flux signal-to-noise ratio 3 < w4snr < 10; Bit 2 (4, 0x4): (ph_qual = C): Source is detected in this band with a flux signal-to-noise ratio 2 < w4snr < 3; Bit 3 (8, 0x8): (ph_qual = D): ??; Bit 4 (16, 0x10): (ph_qual = U): Upper limit on magnitude. Source measurement has w4snr < 2. The profile-fit magnitude w4mpro is a 95% confidence upper limit; Bit 5 (32, 0x20): (ph_qual = X): A profile-fit measurement was not possible at this location in this band. The value of w4mpro and w4sigmpro will be "null" in this band; Bit 6 (64, 0x40): (ph_qual = Z) A profile-fit source flux measurement was made at this location, but the flux uncertainty could not be measured. The value of w4sigmpro will be "null" in this band. The value of w4mpro will be "null" if the measured flux is negative, but will not be "null" if the flux is positive. If a non-null magnitude is presented, it should be treated as a brightness upper limit. This occurs in rare circumstances for very bright, heavily saturated sources; Bit 7 (128, 0x80): "DET_BIT" column: Was the source detected at w4snr  >  2?
    w4ndf       TINYINT NOT NULL, --/D Number of degrees of freedom in the flux variability chi-square, W4.
    w4mlq       TINYINT NOT NULL, --/D Probability measure that the source is variable in W4 flux. The value is -log10(Q), where Q = 1 - P(chi-suared). P is the cumulative chi-square distribution probability for the flux sample measured on the individual single-exposure images. The value is clipped at 9.  The Q value is the fraction of all cases to be expected to be at least as large as that observed if the null hypothesis is true. The null hypothesis is that the flux is emitted by a non-variable astrophysical object. It may be false because the object is a true variable. It may also be false because the flux measurement is corrupted by artifacts such as cosmic rays, scattered light, etc. The smaller the Q value, the more implausible the null hypothesis, i.e., the more likely it is that the flux is either variable or corrupted or both.
    w4cc_map    TINYINT NOT NULL, --/D Contamination and confusion map for this source in W4. This column contains the integer equivalent of the 9-bit binary number that specifies if the W4 measurement is believed to be contaminated by or a spurious detection of an image artifact. The elements of the binary array are:  [S  0  0  0  G  H  0  P  D].  The leftmost bit, S, differentiates whether the band-detection is believed to be a real detection contaminated by an artifact ("0") or a spurious detection of an artifact ("1"). The remaining bits are set to "1" to denote contamination by different types of artifacts according to the letters: D - Diffraction spike. Source may be a spurious detection of or contaminated by a diffraction spike a nearby bright star on the same image.  P - Persistence. Source may be a spurious detection of or contaminated by a short-term latent (persistence) image left by a bright source.  H - Halo. Source may be a spurious detection of or contaminated by the scattered light halo associated with a bright star.  G - Optical ghost. Source may be a spurious detection of or contaminated by an optical ghost image caused by a nearby bright source on the same image.
    var_flg4    TINYINT NOT NULL, --/F var_4     --/D Variability flag for W4.  Related to the probability that the source flux measured on the individual WISE exposures was not constant with time. The probability calculation uses the standard deviation of the single exposure flux measurements, w?sigp1, as well as the band-to-band flux correlation significance, q12,q23,q34.  The probability is computed for a band only when there are at least six single-exposure measurements available that satisfy minimum quality criteria. A value of 16 indicates insufficient or inadequate data to make a determination of possible variability. Values of 0 through 9 indicate increasing probabilities of variation. Values of 0 through 5 are most likely not variables. Sources with values of 6 and 7 are likely flux variables, but are the most susceptible to false-positive variability. Var_flg values greater than 7 have the highest probability of being true flux variables in a band.  CAUTION: Estimation of flux variability is unreliable for sources that are extended (ext_flg > 0), and sources whose measurements are contaminated by image artifacts in a band (cc_flags[b] != '0').
    moon_lev4   TINYINT NOT NULL, --/F moonlev_4 --/D  Scattered moonlight contamination flag; the fraction of single-exposure frames on which the source was measured that were possibly contaminated by scattered moonlight.  The value is given by [ceiling(#frmmoon/#frames*10)], with a maximum value of 9, where #frmmoon is the number of affected frames and #frames is the total number of frames on which the source was measured.
    satnum4     TINYINT NOT NULL, --/F satnum_4  --/D  Minimum sample at which saturation occurs; indicates the minimum SUTR sample in which any pixel in the profile-fitting area in all of the single-exposure images used to characterize this source was flagged as having reached the saturation level in the on-board WISE payload processing. If no pixels are flagged as saturated, the value is 0.
    w1mag_1     REAL NOT NULL, --/U mag --/D W1 5.5" radius aperture magnitude. This is the calibrated source brightness measured in a 5.5" radius circular aperture centered on the source position on the Atlas Image. If the source is not detected in the aperture measurement, this is the 95% confidence upper limit to the brightness. The background sky reference level is measured in an annular region with inner radius of 50" and outer radius of 70". No curve-of-growth correction has been applied.  This column is null if an aperture measurement was not possible in W1.
    w1sigmag_1  REAL NOT NULL, --/U mag --/F w1sigm_1 --/D  Uncertainty in the W1 5.5" radius aperture magnitude.  This column is null if the the 5.5" radius aperture magnitude is an upper limit, or if an aperture measurement was not possible.
    w1flg_1     TINYINT NOT NULL, --/D W1 5.5" radius aperture magnitude quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag values are as described for the standard aperture photometry quality flag, w1flg.
    w1mag_2     REAL NOT NULL, --/U mag --/D Like w1mag_1 but with 8.25" aperture.
    w1sigmag_2  REAL NOT NULL, --/U mag --/F w1sigm_2 --/D Like w1sigmag_1
    w1flg_2     TINYINT NOT NULL, --/D Like w1flg_1
    w1mag_3     REAL NOT NULL, --/U mag --/D Like w1mag_1 but with 11" aperture.
    w1sigmag_3  REAL NOT NULL, --/U mag --/F w1sigm_2 --/D Like w1sigmag_1
    w1flg_3     TINYINT NOT NULL, --/D Like w1flg_1
    w1mag_4     REAL NOT NULL, --/U mag --/D Like w1mag_1 but with 13.75" aperture.
    w1sigmag_4  REAL NOT NULL, --/U mag --/F w1sigm_2 --/D Like w1sigmag_1
    w1flg_4     TINYINT NOT NULL, --/D Like w1flg_1
    w1mag_5     REAL NOT NULL, --/U mag --/D Like w1mag_1 but with 16.5" aperture.
    w1sigmag_5  REAL NOT NULL, --/U mag --/F w1sigm_2 --/D Like w1sigmag_1
    w1flg_5     TINYINT NOT NULL, --/D Like w1flg_1
    w1mag_6     REAL NOT NULL, --/U mag --/D Like w1mag_1 but with 19.25" aperture.
    w1sigmag_6  REAL NOT NULL, --/U mag --/F w1sigm_2 --/D Like w1sigmag_1
    w1flg_6     TINYINT NOT NULL, --/D Like w1flg_1
    w1mag_7     REAL NOT NULL, --/U mag --/D Like w1mag_1 but with 22" aperture.
    w1sigmag_7  REAL NOT NULL, --/U mag --/F w1sigm_2 --/D Like w1sigmag_1
    w1flg_7     TINYINT NOT NULL, --/D Like w1flg_1
    w1mag_8     REAL NOT NULL, --/U mag --/D Like w1mag_1 but with 24.75" aperture.
    w1sigmag_8  REAL NOT NULL, --/U mag --/F w1sigm_2 --/D Like w1sigmag_1
    w1flg_8     TINYINT NOT NULL, --/D Like w1flg_1
    w2mag_1     REAL NOT NULL, --/U mag --/D W2 5.5" radius aperture magnitude. This is the calibrated source brightness measured in a 5.5" radius circular aperture centered on the source position on the Atlas Image. If the source is not detected in the aperture measurement, this is the 95% confidence upper limit to the brightness. The background sky reference level is measured in an annular region with inner radius of 50" and outer radius of 70". No curve-of-growth correction has been applied.  This column is null if an aperture measurement was not possible in W2.
    w2sigmag_1  REAL NOT NULL, --/U mag --/F w2sigm_1 --/D  Uncertainty in the W2 5.5" radius aperture magnitude.  This column is null if the the 5.5" radius aperture magnitude is an upper limit, or if an aperture measurement was not possible.
    w2flg_1     TINYINT NOT NULL, --/D W2 5.5" radius aperture magnitude quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag values are as described for the standard aperture photometry quality flag, w2flg.
    w2mag_2     REAL NOT NULL, --/U mag --/D Like w2mag_1 but with 8.25" aperture.
    w2sigmag_2  REAL NOT NULL, --/U mag --/F w2sigm_2 --/D Like w2sigmag_1
    w2flg_2     TINYINT NOT NULL, --/D Like w2flg_1
    w2mag_3     REAL NOT NULL, --/U mag --/D Like w2mag_1 but with 11" aperture.
    w2sigmag_3  REAL NOT NULL, --/U mag --/F w2sigm_2 --/D Like w2sigmag_1
    w2flg_3     TINYINT NOT NULL, --/D Like w2flg_1
    w2mag_4     REAL NOT NULL, --/U mag --/D Like w2mag_1 but with 13.75" aperture.
    w2sigmag_4  REAL NOT NULL, --/U mag --/F w2sigm_2 --/D Like w2sigmag_1
    w2flg_4     TINYINT NOT NULL, --/D Like w2flg_1
    w2mag_5     REAL NOT NULL, --/U mag --/D Like w2mag_1 but with 16.5" aperture.
    w2sigmag_5  REAL NOT NULL, --/U mag --/F w2sigm_2 --/D Like w2sigmag_1
    w2flg_5     TINYINT NOT NULL, --/D Like w2flg_1
    w2mag_6     REAL NOT NULL, --/U mag --/D Like w2mag_1 but with 19.25" aperture.
    w2sigmag_6  REAL NOT NULL, --/U mag --/F w2sigm_2 --/D Like w2sigmag_1
    w2flg_6     TINYINT NOT NULL, --/D Like w2flg_1
    w2mag_7     REAL NOT NULL, --/U mag --/D Like w2mag_1 but with 22" aperture.
    w2sigmag_7  REAL NOT NULL, --/U mag --/F w2sigm_2 --/D Like w2sigmag_1
    w2flg_7     TINYINT NOT NULL, --/D Like w2flg_1
    w2mag_8     REAL NOT NULL, --/U mag --/D Like w2mag_1 but with 24.75" aperture.
    w2sigmag_8  REAL NOT NULL, --/U mag --/F w2sigm_2 --/D Like w2sigmag_1
    w2flg_8     TINYINT NOT NULL, --/D Like w2flg_1
    w3mag_1     REAL NOT NULL, --/U mag --/D W3 5.5" radius aperture magnitude. This is the calibrated source brightness measured in a 5.5" radius circular aperture centered on the source position on the Atlas Image. If the source is not detected in the aperture measurement, this is the 95% confidence upper limit to the brightness. The background sky reference level is measured in an annular region with inner radius of 50" and outer radius of 70". No curve-of-growth correction has been applied.  This column is null if an aperture measurement was not possible in W3.
    w3sigmag_1  REAL NOT NULL, --/U mag --/F w3sigm_1 --/D  Uncertainty in the W3 5.5" radius aperture magnitude.  This column is null if the the 5.5" radius aperture magnitude is an upper limit, or if an aperture measurement was not possible.
    w3flg_1     TINYINT NOT NULL, --/D W3 5.5" radius aperture magnitude quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag values are as described for the standard aperture photometry quality flag, w3flg.
    w3mag_2     REAL NOT NULL, --/U mag --/D Like w3mag_1 but with 8.25" aperture.
    w3sigmag_2  REAL NOT NULL, --/U mag --/F w3sigm_2 --/D Like w3sigmag_1
    w3flg_2     TINYINT NOT NULL, --/D Like w3flg_1
    w3mag_3     REAL NOT NULL, --/U mag --/D Like w3mag_1 but with 11" aperture.
    w3sigmag_3  REAL NOT NULL, --/U mag --/F w3sigm_2 --/D Like w3sigmag_1
    w3flg_3     TINYINT NOT NULL, --/D Like w3flg_1
    w3mag_4     REAL NOT NULL, --/U mag --/D Like w3mag_1 but with 13.75" aperture.
    w3sigmag_4  REAL NOT NULL, --/U mag --/F w3sigm_2 --/D Like w3sigmag_1
    w3flg_4     TINYINT NOT NULL, --/D Like w3flg_1
    w3mag_5     REAL NOT NULL, --/U mag --/D Like w3mag_1 but with 16.5" aperture.
    w3sigmag_5  REAL NOT NULL, --/U mag --/F w3sigm_2 --/D Like w3sigmag_1
    w3flg_5     TINYINT NOT NULL, --/D Like w3flg_1
    w3mag_6     REAL NOT NULL, --/U mag --/D Like w3mag_1 but with 19.25" aperture.
    w3sigmag_6  REAL NOT NULL, --/U mag --/F w3sigm_2 --/D Like w3sigmag_1
    w3flg_6     TINYINT NOT NULL, --/D Like w3flg_1
    w3mag_7     REAL NOT NULL, --/U mag --/D Like w3mag_1 but with 22" aperture.
    w3sigmag_7  REAL NOT NULL, --/U mag --/F w3sigm_2 --/D Like w3sigmag_1
    w3flg_7     TINYINT NOT NULL, --/D Like w3flg_1
    w3mag_8     REAL NOT NULL, --/U mag --/D Like w3mag_1 but with 24.75" aperture.
    w3sigmag_8  REAL NOT NULL, --/U mag --/F w3sigm_2 --/D Like w3sigmag_1
    w3flg_8     TINYINT NOT NULL, --/D Like w3flg_1
    w4mag_1     REAL NOT NULL, --/U mag --/D W4 11" radius aperture magnitude. This is the calibrated source brightness measured in a 5.5" radius circular aperture centered on the source position on the Atlas Image. If the source is not detected in the aperture measurement, this is the 95% confidence upper limit to the brightness. The background sky reference level is measured in an annular region with inner radius of 50" and outer radius of 70". No curve-of-growth correction has been applied.  This column is null if an aperture measurement was not possible in W4.
    w4sigmag_1  REAL NOT NULL, --/U mag --/F w4sigm_1 --/D  Uncertainty in the W4 5.5" radius aperture magnitude.  This column is null if the the 5.5" radius aperture magnitude is an upper limit, or if an aperture measurement was not possible.
    w4flg_1     TINYINT NOT NULL, --/D W4 5.5" radius aperture magnitude quality flag. This flag indicates if one or more image pixels in the measurement aperture for this band is confused with nearby objects, is contaminated by saturated or otherwise unusable pixels, or is an upper limit. The flag values are as described for the standard aperture photometry quality flag, w4flg.
    w4mag_2     REAL NOT NULL, --/U mag --/D Like w4mag_1 but with 16.5" aperture.
    w4sigmag_2  REAL NOT NULL, --/U mag --/F w4sigm_2 --/D Like w4sigmag_1
    w4flg_2     TINYINT NOT NULL, --/D Like w4flg_1
    w4mag_3     REAL NOT NULL, --/U mag --/D Like w4mag_1 but with 22" aperture.
    w4sigmag_3  REAL NOT NULL, --/U mag --/F w4sigm_2 --/D Like w4sigmag_1
    w4flg_3     TINYINT NOT NULL, --/D Like w4flg_1
    w4mag_4     REAL NOT NULL, --/U mag --/D Like w4mag_1 but with 27.5" aperture.
    w4sigmag_4  REAL NOT NULL, --/U mag --/F w4sigm_2 --/D Like w4sigmag_1
    w4flg_4     TINYINT NOT NULL, --/D Like w4flg_1
    w4mag_5     REAL NOT NULL, --/U mag --/D Like w4mag_1 but with 33" aperture.
    w4sigmag_5  REAL NOT NULL, --/U mag --/F w4sigm_2 --/D Like w4sigmag_1
    w4flg_5     TINYINT NOT NULL, --/D Like w4flg_1
    w4mag_6     REAL NOT NULL, --/U mag --/D Like w4mag_1 but with 38.5" aperture.
    w4sigmag_6  REAL NOT NULL, --/U mag --/F w4sigm_2 --/D Like w4sigmag_1
    w4flg_6     TINYINT NOT NULL, --/D Like w4flg_1
    w4mag_7     REAL NOT NULL, --/U mag --/D Like w4mag_1 but with 44" aperture.
    w4sigmag_7  REAL NOT NULL, --/U mag --/F w4sigm_2 --/D Like w4sigmag_1
    w4flg_7     TINYINT NOT NULL, --/D Like w4flg_1
    w4mag_8     REAL NOT NULL, --/U mag --/D Like w4mag_1 but with 49.5" aperture.
    w4sigmag_8  REAL NOT NULL, --/U mag --/F w4sigm_2 --/D Like w4sigmag_1
    w4flg_8     TINYINT NOT NULL, --/D Like w4flg_1

    rjce AS j_m_2mass - k_m_2mass - 1.377 * (h_m_2mass - w2mag - 0.05) PERSISTED NOT NULL	--/D Dereddening index - computed column used in APOGEE target selection
)
GO


--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[PhotoTables.sql]: Photo tables created'
GO
