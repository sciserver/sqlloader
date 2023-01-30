--=========================================================
--  DataConstants.sql
--
--  2001-11-07	Alex Szalay
-----------------------------------------------------------
--  Various Constants and enumerated types for SkyServer
--  Unit conversions also go here
--
--  DataConstants
--	PhotoMode		enum
--	MaskType		enum
--	PhotoType		enum
--	InsideMask		bits
--	PhotoStatus		bits
--	PhotoFlags		bits
--	CalibStatus		bits
--	FieldQuality		enum
--	PspStatus		enum
--	FrameStatus		enum
--	ImageStatus		bits
--	ResolveStatus		enum
--	PrimTarget		bits
--	SecTarget		bits
--	SpecialTarget1		bits
--	Segue1Target1		bits
--	Segue2Target1		bits
--	BossTarget1		bits
--	AncillaryTarget1	bits
--	AncillaryTarget2	bits
--	ApogeeTarget1		bits
--	ApogeeTarget2		bits
--	ApogeeStarFlag		bits
--	ApogeeApcapFlag		bits
--	ApogeeParamFlag		bits
--	ApogeeExtraTarg		bits
--	EbossTarget0		bits
--	SpecZWarning		bits
--	SpecPixMask		bits
--	HoleType		enum
--	SourceType		enum
--	ProgramType		enum
--	CoordType		enum
--	TiMask			bits
--  sdssvBossTarget0	bits
--  SDSSConstants
--  StripeDefs
--  RunShift
--  ProfileDefs
----------------------------------------------------------------------------------
-- History:
--* 2001-11-09	Jim: changed the order of fields for SpecLineNames
--* 2001-11-10	Alex: added functions to support primTarget and secTarget
--* 2001-11-10	Alex: reinserted the SDSSConstants and StripeDefs
--* 2001-11-19	Alex: fixed bugs in PhotoFlags values and added missing items
--* 2001-11-23	Alex: changed the DataConstants value type to binary(8),
--*		and SDSSConstants value to float, and added views,
--*		plus more access functions. revised fPhotoDescription.
--* 2001-11-23	Jim+Alex: include fMjdToGMT time conversion routine
--* 2001-12-02	Alex: changed PrimTargetFlags->primTarget, SecTargetFlags->SecTarget 
--*		and fixed the leading zeroes in SpecZWarning.
--* 2001-12-29	Jim: CR -> COSMIC_RAY
--* 2002-05-01	Ani: Incorporated Adrian's tiling changes (PR 2433)
--* 2002-07-10	Jim: added arcSecPerPixel, arcSecPerPixelErr to SDSS constants
--*              corrected errors in ProfileDefs
--* 2002-08-10	Adrian: updated tiling changes
--* 2002-08-12	Ani: Added MaskType enum (for Mask table).
--* 2002-08-19	Adrian: updated tiling changes, added unmapped fiber flags to zwarning
--* 2002-10-22	Alex: added the photoMode values and added V4 photoFlags
--* 2003-01-16	Alex: fixed ProfileDefs per Robert's definitions
--* 2003-01-16	Alex: fixed HoleType enum as pointed out by Adrian Pope
--* 2003-02-19	Alex: added values for framesStatus (from RHL)
--* 2003-05-05	Ani:  updated TiMask bit mask values as per PR #5272.
--* 2003-06-04  Alex: Added InsideMask values,
--*                   changed FieldStatus->PspStatus, and
--*                   added Runshift table and values.
--* 2003-07-30  Ani: Added missing photoflags descriptions provided by RHL (PR 5529)
--*		     and replaced "centre" with "center" for consistency.
--*  2003-08-18  Ani: Added asinh softening params to SDSSConstants (PR 5559),
--*                  and fixed spelling of Angstrom (it was Angstroem).
--*  2003-10-31  Ani: Added ABLINE_CAII to SpecZStatus as per PR #5741 .
--*                   Modified line names (SpecLineNames) as per PR #5741 .
--*  2003-12-02  Ani: Fixed typo in LOADER_MAPPED description.
--*  2005-04-26  Ani: Updated TiMask values as per PR #6429 (moved them to
--*                   upper 4 bytes by removing cast to int).
--*  2005-09-12  Ani: Updated InsideMask enumerated values to reflect the
--*                   MaskType values (PR #6609).
--*  2006-01-19  Ani: Added new StripeDefs for SEGUE stripes from Brian
--*                   and Svetlana (PR #7073).  Might change later.
--*  2006-03-01  Ani: Fixed PR #6904, SpecClass UNKNOWN description.
--*  2006-03-06  Ani: Fixed name of NeVI_3427 line to NeV_3427 in 
--*                   SpecLineNames (PR #6915).
--*  2006-08-10  Ani: Added PhotoMode value 5 ('HOLE'), see PR #7088.
--*  2007-01-08  Ani: Fixed hex values in PspStatus (PR #6940).
--*  2007-01-15  Ani: Made SEGUE stripedefs conditional on DB_NAME(),
--*                   so they wont be inserted for main DB.
--*  2007-01-17  Ani: Added foreign key deletions for the tables to 
--*                   error when the tables are dropped.
--*  2007-03-30  Ani: Added ubercal calib status bits in UberCalibStatus.
--*  2007-04-24  Ani: Updated descriptions for UberCalibStatus flags.
--*  2007-05-07  Ani: Updated description of UberCalibStatus NO_UBERCAL as 
--*                   per suggestion from Nikhil.
--*  2007-05-07  Ani: Updated description of specClass HIZ_QSO to clarify
--*                   distinction between other z > 2.3 quasars and those
--*                   classified as HIZ_QSO (in response to a helpdesk 
--*                   question).
--*  2007-11-30  Ani: Fixed Lyman-alpha lineid in SpecLineNames, shd be
--*                   1216 not 1215 (PR #6573).
--*  2007-12-06  Ani: Added expTime to SDSSConstants (PR #7400).
--*  2008-08-07  Ani: Fix for PR #7088, PhotoMode set to 5 for objects in holes.
--*  2011-09-22  Ani: Replaced UberCalibStatus with CalibStatus.
--*  2011-09-27  Ani: Added bit 31 to PrimTarget/SecTarget, and added bitmasks
--*                   SpecialTarget1, Segue1Target1, Segue2Target1, ImageStatus.
--*                   Also added descriptions for PrimTarget/SecTarget and 
--*                   updated CalibStatus descriptions (PR #1444).  
--*  2011-09-28  Ani: Deleted FieldMask, SpecClass and SpecZStatus, 
--*                   updated SpeczWarning with new DR8 values.
--*  2011-09-29  Ani: Added SpecPixMask.
--*                   Added first special entry for all fields in DataConstants
--*                   that contains the description of that field and name=''.
--*                   Removed TARGET_ prefix from names of Prim/SecTarget flags.
--*  2011-09-30  Ani: Updated description for DataConstants table and removed
--*                   index management from drop table commands.
--*  2011-10-04  Ani: Added ResolveStatus for PhotoObjAll.resolveStatus.
--*                   Qualified description for PhotoStatus as SDSS-II only. 
--*  2011-10-05  Ani: Changed PspStatus size to 16 (smallint) from 32 (int).
--*                   Fixed ImageStatus and ResolveStatus bit values.
--*  2012-05-23  Ani: Changed ObjType to SourceType.
--*  2013-05-24  Ani: Added Segue1Target2, Segue2Target2, BossTarget1, 
--*                   AncillaryTarget1, AncillaryTarget2, ApogeeTarget1
--*                   and ApogeeTarget2.
--*  2013-06-06  Ani: Finished adding all APOGEE flags, also added 
--*                   SpecialTarget2 flags.
--*  2013-06-12  Ani: Fixed description of ASPCAP flag group.
--*  2013-07-05  Ani: Updated APOGEE flags with latest changes, and made
--*                   all values 64-bit so they will display correctly in
--*                   Casjobs schema browser.
--*  2013-07-08  Ani: Added LegacyTarget[12] to Prim/SecTarget descriptions.
--*  2013-07-08  Ani: Commented out bitmask values of PspStatus since these
--*                   are not used and they are not displayed correctly.
--*  2013-07-08  Ani: Fixed ResolveStatus values. 
--*  2013-07-16  Ani: Fixed ApogeeTarget2 values. 
--*  2013-07-16  Ani: Fixed typo in ApogeeTarget2 value. 
--*  2014-02-07  Ani: Removed trailing whitespaces from ApogeePixMask names.
--*  2014-09-05  Ani: Fixed typo in DataConstants short description.
--*  2014-09-05  Ani: Fixed typo in Segue1Target2 last value (extra 0).
--*  2014-10-23  Ani: Removed ApogeePixMask (PR #1979).
--*  2014-11-25  Ani: Added ApogeeExtraTarg for DR12, updated description of
--*                   ApogeeParamFlag.
--*  2014-11-26  Ani: Added references to Algorithms entries for bitmasks.
--*  2015-02-09  Ani: Added EBOSS_TARGET0 (EbossTarget0) flag values.
--*  2015-02-13  Ani: Fixed typos in EBOSS_TARGET0 flag values.
--*  2015-02-15  Ani: Fixed one more typo in EBOSS_TARGET0 flag values.
--*  2015-03-04  Ani: Added additional AncillaryTarget2 flag values for DR12.
--*  2023-01-12  Ani: Added sdssvBossTarget0 flag values for DR18.
--=================================================================================
SET NOCOUNT ON
GO

--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[DataConstants]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [DataConstants]
GO
--
CREATE TABLE DataConstants (
------------------------------------------------------------
--/H The table stores the values of various enumerated and bitmask columns.
------------------------------------------------------------
	[field]		varchar(128) 	not null,	--/D Field Name --/K METADATA_NAME
	[name]		varchar(128) 	not null,	--/D Constant Name --/K METADATA_NAME
	[value]		binary(8)	not null,	--/D Type value --/K CODE_MISC
	[description]	varchar(2000)	not null	--/D Short description --/K METADATA_DESCRIPTION
)
GO
--

--===========================================================
-- Constants related to the survey geometry, etc.
--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[SDSSConstants]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [SDSSConstants]
GO
--
CREATE TABLE SDSSConstants(
-------------------------------------------------------------------------------
--/H This table contains most relevant survey constants and their physical units
-------------------------------------------------------------------------------
	[name]		varchar(32)	not null,	--/D Name of the constant --/K METADATA_NAME
	[value]		float 		not null,	--/D The numerical value in float --/K NUMBER
	[unit]		varchar(32)	not null,	--/D Its physical unit --/K METADATA_UNIT
	[description]	varchar(2000)	not null	--/D Short description --/K METADATA_DESCRIPTION
)
GO
--

--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[StripeDefs]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [StripeDefs]
GO
--
CREATE TABLE StripeDefs(
-------------------------------------------------------------------------------
--/H This table contains the definitions of the survey layout as planned
-------------------------------------------------------------------------------
--/T The lower and upper limits of the actual stripes may differ from these
--/T values. The actual numbers are found in the Segment and Chunk tables.
-------------------------------------------------------------------------------
	[stripe]	int 	not null,	--/D Stripe number --/K EXTENSION_AREA
	hemisphere	varchar(64) not null,	--/D Which hemisphere (N|S) --/K EXTENSION_AREA
	eta		float	not null,	--/D Survey eta for the center of stripe --/U deg --/K POS_SDSS_ETA
	lambdaMin	float	not null,	--/D Survey lambda lower limit of the stripe --/U deg --/K POS_SDSS_LAMBDA POS_LIMIT
	lambdaMax	float	not null,	--/D Survey lambda upper limit of the stripe --/U deg --/K POS_SDSS_LAMBDA POS_LIMIT
	htmArea		varchar(1024) not null	--/D HTM area descriptor string  --/K ???
)
GO
--



--=========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[RunShift]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [RunShift]
GO
--
CREATE TABLE RunShift (
------------------------------------------------------------
--/H The table contains values of the various manual nu shifts for runs
--
--/T In the early runs the telescope was sometimes not tracking
--/T correctly. The boundaries of some of the runs had thus to be shifted
--/T by a small amount, determined by hand. This table contains
--/T these manual corrections. These should be applied to the
--/T nu values derived for these runs. Only those runs are here,
--/T for which such a correction needs to be applied.
------------------------------------------------------------
	[run]		int 	not null,	--/D Run id --/K 
	[shift]		float 	not null	--/D The nu shift applied --/U deg --/K POS_OFFSET
)
GO
--


--===============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[ProfileDefs]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [ProfileDefs]
GO
--
CREATE TABLE ProfileDefs(
-------------------------------------------------------------------------------
--/H This table contains the radii for the Profiles table
-------------------------------------------------------------------------------
--/T Radii of boundaries of annuli, and number of pixels involved. 
--/T aAnn is the area of the annulus, and aDisk is the area of 
--/T the disk out to rOuter. The second column gives the first 
--/T cell in the annulus, and the third indicates if the values in 
--/T that annulus are derived from sinc shifting the image to center
--/T it on a pixel.<br>
--/T for details see http://www.astro.princeton.edu/~rhl/photomisc/profiles.ps
-------------------------------------------------------------------------------
	bin		int 	not null,	--/D bin --/K EXTENSION
	cell		int 	not null,	--/D the first cell in the annulus --/K EXTENSION
	sinc		int	not null,	--/D sinc shift (0:no, 1:yes) --/K CODE_MISC
	rInner		float	not null,	--/D Inner radius of the bin --/U arcsec --/K EXTENSION_RAD
	rOuter		float	not null,	--/D Outer radius of the bin --/U srcsec --/K EXTENSION_RAD
	aAnn		float	not null,	--/D The area of the annulus --/U arcsec^2 --/K EXTENSION_AREA
	aDisk		float	not null	--/D The area of the disk to outerRadius --/U arcsec^2 --/K EXTENSION_AREA
)
GO
--

--==============================
-- Insert the values
--==============================
-- PhotoMode 8 (3 values)
Insert DataConstants values  ('PhotoMode', '',			0, 'Indicates whether photo observation is primary, secondary or other.')
Insert DataConstants values  ('PhotoMode', 'PRIMARY',		1, 'Primary object')
Insert DataConstants values  ('PhotoMode', 'SECONDARY',		2, 'Secondary object')
Insert DataConstants values  ('PhotoMode', 'FAMILY',		3, 'Family object')
Insert DataConstants values  ('PhotoMode', 'OUTSIDE',		4, 'Object outside chunk boundary')
Insert DataConstants values  ('PhotoMode', 'HOLE',		5, 'Object within hole (Field.quality=5)')
GO

-- MaskType 16 (5 values)
Insert DataConstants values  ('MaskType', '',			0, 'Enumerated type of mask.')
Insert DataConstants values  ('MaskType', 'BLEEDING',		0, 'Bleeding mask.')
Insert DataConstants values  ('MaskType', 'BRIGHT_STAR',	1, 'Bright star mask.')
Insert DataConstants values  ('MaskType', 'TRAIL',		2, 'Trail mask.')
Insert DataConstants values  ('MaskType', 'HOLE',		3, 'Hole mask.')
Insert DataConstants values  ('MaskType', 'SEEING',		4, 'Seeing mask.')
GO

-- PhotoType 16 (10 values)
Insert DataConstants values  ('PhotoType', '',			0, 'Type classification of the object (star, galaxy, cosmic ray, etc.)')
Insert DataConstants values  ('PhotoType', 'UNKNOWN',		0, 'Unknown: Object type is not known.')
Insert DataConstants values  ('PhotoType', 'COSMIC_RAY',	1, 'Cosmic-ray track (not used).')
Insert DataConstants values  ('PhotoType', 'DEFECT',		2, 'Defect: Object is caused by a defect in the telescope or processing pipeline. (not used)')
Insert DataConstants values  ('PhotoType', 'GALAXY',		3, 'Galaxy: An extended object composed of many stars and other matter.')
Insert DataConstants values  ('PhotoType', 'GHOST', 		4, 'Ghost:  Object created by reflected or refracted light. (not used)')
Insert DataConstants values  ('PhotoType', 'KNOWNOBJ',		5, 'KnownObject: Object came from some other catalog (not the SDSS catalog).  (not yet used)')
Insert DataConstants values  ('PhotoType', 'STAR',		6, 'Star: A a self-luminous gaseous celestial body. ')
Insert DataConstants values  ('PhotoType', 'TRAIL',		7, 'Trail: A satellite or asteriod or meteor trail. (not yet used)')
Insert DataConstants values  ('PhotoType', 'SKY',		8, 'Sky: Blank sky spectogram (no objects in this arcsecond area).')
Insert DataConstants values  ('PhotoType', 'NOTATYPE',		9, 'NotAType:')
GO 


-- InsideMask 8 (7 values)
Insert DataConstants values  ('InsideMask', '',				0x00, 'Indicates whether object is inside a mask and if so, why.')
Insert DataConstants values  ('InsideMask', 'INMASK_NOT_IN_MASK',	0x00, 'Not inside a mask.')
Insert DataConstants values  ('InsideMask', 'INMASK_BLEEDING',		0x01, 'Bleeding trail.')
Insert DataConstants values  ('InsideMask', 'INMASK_BRIGHT_STAR',	0x02, 'Object is bright star or near one.')
Insert DataConstants values  ('InsideMask', 'INMASK_TRAIL',		0x04, 'Object masked due to nearby trail.')
Insert DataConstants values  ('InsideMask', 'INMASK_HOLE',		0x08, 'Hole mask.')
Insert DataConstants values  ('InsideMask', 'INMASK_POOR_SEEING',	0x10, 'Seeing > 1.7".')
Insert DataConstants values  ('InsideMask', 'INMASK_BAD_SEEING',	0x20, 'Seeing > 2.0".')
GO

-- PhotoStatus 32 (12 values, EDR 12)
Insert DataConstants values  ('PhotoStatus', '',  	   	0, 		'SDSS-II (DR1-7): Status of the object in the survey.')
Insert DataConstants values  ('PhotoStatus', 'SET',  	   	0x00000001, 	'Object''s status has been set in reference to its own run')
Insert DataConstants values  ('PhotoStatus', 'GOOD', 	   	0x00000002, 	'Object is good as determined by its object flags. Absence implies bad.')
Insert DataConstants values  ('PhotoStatus', 'DUPLICATE',  	0x00000004, 	'Object has one or more duplicate detections in an adjacent field of the same Frames Pipeline Run.')
Insert DataConstants values  ('PhotoStatus', 'OK_RUN',	   	0x00000010, 	'Object is usable, it is located within the primary range of rows for this field. ')
Insert DataConstants values  ('PhotoStatus', 'RESOLVED',   	0x00000020, 	'Object has been resolved against other runs.')
Insert DataConstants values  ('PhotoStatus', 'PSEGMENT',   	0x00000040, 	'Object Belongs to a PRIMARY segment. This does not imply that this is a primary object. ')
Insert DataConstants values  ('PhotoStatus', 'FIRST_FIELD', 	0x00000100, 	'Object belongs to the first field in its segment. Used to distinguish objects in fields shared by two segments.')
Insert DataConstants values  ('PhotoStatus', 'OK_SCANLINE', 	0x00000200, 	'Object lies within valid nu range for its scanline.')
Insert DataConstants values  ('PhotoStatus', 'OK_STRIPE',   	0x00000400, 	'Object lies within valid eta range for its stripe.')
Insert DataConstants values  ('PhotoStatus', 'SECONDARY',   	0x00001000, 	'This is a secondary survey object.')
Insert DataConstants values  ('PhotoStatus', 'PRIMARY',	   	0x00002000, 	'This is a primary survey object.')
Insert DataConstants values  ('PhotoStatus', 'TARGET',	   	0x00004000, 	'This is a spectroscopic target.')
GO

-- PhotoFlags 64 (54 values , EDR 50)
Insert DataConstants values  ('PhotoFlags','',		0, 'In the flat-files, the photo flags are split into two 32-bit variables (objc_flags1 and objc_flags2). In the CAS, these are combined into a single 64-bit column "flags". Please see the FLAGS1 and FLAGS2 entries in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('PhotoFlags','CANONICAL_CENTER',		0x0000000000000001, 'Measurements used the center in r*, rather than the locally determined center.')
Insert DataConstants values  ('PhotoFlags','BRIGHT',			0x0000000000000002, 'Object detected in first, bright object-finding; generally r*<17.5')
Insert DataConstants values  ('PhotoFlags','EDGE',			0x0000000000000004, 'Object is too close to edge of frame')
Insert DataConstants values  ('PhotoFlags','BLENDED',			0x0000000000000008, 'Object had multiple peaks detected within it; was thus a candidate to be a deblending parent.')
Insert DataConstants values  ('PhotoFlags','CHILD',  			0x0000000000000010, 'Object is the product of an attempt to deblend a BLENDED object.')
Insert DataConstants values  ('PhotoFlags','PEAKCENTER',		0x0000000000000020, 'Given center is position of peak pixel, rather than based on the maximum-likelihood estimator.')
Insert DataConstants values  ('PhotoFlags','NODEBLEND',			0x0000000000000040, 'No deblending was attempted on this object, even though it is BLENDED.')
Insert DataConstants values  ('PhotoFlags','NOPROFILE',			0x0000000000000080, 'Object was too small or too close to the edge to estimate a radial profile.')
Insert DataConstants values  ('PhotoFlags','NOPETRO',			0x0000000000000100, 'No valid Petrosian radius was found for this object.')
Insert DataConstants values  ('PhotoFlags','MANYPETRO',			0x0000000000000200, 'More than one Petrosian radius was found.')
Insert DataConstants values  ('PhotoFlags','NOPETRO_BIG',		0x0000000000000400, 'Petrosian radius is beyond the last point in the radial profile.')
Insert DataConstants values  ('PhotoFlags','DEBLEND_TOO_MANY_PEAKS', 	0x0000000000000800, 'There were more than 25 peaks in this object to deblend; deblended brightest 25.')
Insert DataConstants values  ('PhotoFlags','COSMIC_RAY',		0x0000000000001000, 'Contains a pixel interpreted to be part of a cosmic ray.')
Insert DataConstants values  ('PhotoFlags','MANYR50',			0x0000000000002000, 'Object has more than one 50% light radius.')
Insert DataConstants values  ('PhotoFlags','MANYR90',			0x0000000000004000, 'Object has more than one 90% light radius.')
Insert DataConstants values  ('PhotoFlags','BAD_RADIAL',		0x0000000000008000, 'Some of the points in the given radial profile have negative signal-to-noise ratio. Not a significant parameter.')
Insert DataConstants values  ('PhotoFlags','INCOMPLETE_PROFILE',	0x0000000000010000, 'Petrosian radius intersects the edge of the frame.')
Insert DataConstants values  ('PhotoFlags','INTERP', 			0x0000000000020000, 'Object contains one or more pixels whose values were determined by interpolation.')
Insert DataConstants values  ('PhotoFlags','SATURATED',			0x0000000000040000, 'Object contains one or more saturated pixels')
Insert DataConstants values  ('PhotoFlags','NOTCHECKED',		0x0000000000080000, 'There are pixels in the object which were not checked to see if they included a local peak, such as cores of saturated stars.')
Insert DataConstants values  ('PhotoFlags','SUBTRACTED',		0x0000000000100000, 'This BRIGHT object had its wings subtracted from the frame')
Insert DataConstants values  ('PhotoFlags','NOSTOKES',			0x0000000000200000, 'Object has no measured Stokes params')
Insert DataConstants values  ('PhotoFlags','BADSKY', 			0x0000000000400000, 'The sky level is so bad that the highest pixel in the object is very negative; far more so than a mere non-detection. No further analysis is attempted.')
Insert DataConstants values  ('PhotoFlags','PETROFAINT',		0x0000000000800000, 'At least one possible Petrosian radius was rejected as the surface brightness at r_P was too low. If NOPETRO is not set, a different, acceptable Petrosian radius was found.')
Insert DataConstants values  ('PhotoFlags','TOO_LARGE',			0x0000000001000000, 'The object is too large for us to measure its profile (it extends beyond a radius of approximately 260), or at least one child is larger than half a frame.')
Insert DataConstants values  ('PhotoFlags','DEBLENDED_AS_PSF',		0x0000000002000000, 'Deblender treated obj as PSF')
Insert DataConstants values  ('PhotoFlags','DEBLEND_PRUNED', 		0x0000000004000000, 'At least one child was removed because its image was too similar to a supposedly different child.')
Insert DataConstants values  ('PhotoFlags','ELLIPFAINT',		0x0000000008000000, 'Object center is fainter than the isophote whose shape is desired, so the isophote properties are not measured. Also flagged if profile is incomplete.')
Insert DataConstants values  ('PhotoFlags','BINNED1',			0x0000000010000000, 'Object was detected in 1x1 binned image')
Insert DataConstants values  ('PhotoFlags','BINNED2',			0x0000000020000000, 'Object was detected in 2x2 binned image, after unbinned detections are replaced by background.')
Insert DataConstants values  ('PhotoFlags','BINNED4',			0x0000000040000000, 'Object was detected in 4x4 binned image')
Insert DataConstants values  ('PhotoFlags','MOVED',  			0x0000000080000000, 'The deblender identified this object as possibly moving.')
Insert DataConstants values  ('PhotoFlags','DEBLENDED_AS_MOVING',	0x0000000100000000, 'A MOVED object that the deblender treated as moving.')
Insert DataConstants values  ('PhotoFlags','NODEBLEND_MOVING',		0x0000000200000000, 'A MOVED object that the deblender did not treat as moving.')
Insert DataConstants values  ('PhotoFlags','TOO_FEW_DETECTIONS',	0x0000000400000000, 'A child of this object was not detected in enough bands to reliably deblend as moving.')
Insert DataConstants values  ('PhotoFlags','BAD_MOVING_FIT', 		0x0000000800000000, 'Moving fit too poor to be believable.')
Insert DataConstants values  ('PhotoFlags','STATIONARY',		0x0000001000000000, 'This object was consistent with being stationary.')
Insert DataConstants values  ('PhotoFlags','PEAKS_TOO_CLOSE',		0x0000002000000000, 'At least some peaks within this object were too close to be deblended, thus they were merged into a single peak.')
Insert DataConstants values  ('PhotoFlags','MEDIAN_CENTER',  		0x0000004000000000, 'Center given is of median-smoothed image.')
Insert DataConstants values  ('PhotoFlags','LOCAL_EDGE',		0x0000008000000000, 'Center in at least one band is too close to an edge.')
Insert DataConstants values  ('PhotoFlags','BAD_COUNTS_ERROR',		0x0000010000000000, 'An object containing interpolated pixels had too few good pixels to form a reliable estimate of its error; the quoted error may be underestimated.')
Insert DataConstants values  ('PhotoFlags','BAD_MOVING_FIT_CHILD',   	0x0000020000000000, 'A possible moving child''s velocity fit was too poor, so it was discarded and the parent was not deblended as moving.')
Insert DataConstants values  ('PhotoFlags','DEBLEND_UNASSIGNED_FLUX',	0x0000040000000000, 'After deblending, a significant fraction of flux was not assigned to any children.')
Insert DataConstants values  ('PhotoFlags','SATUR_CENTER',   		0x0000080000000000, 'Object center is close to at least one saturated pixel.')
Insert DataConstants values  ('PhotoFlags','INTERP_CENTER',  		0x0000100000000000, 'Object center is close to at least one interpolated pixel.')
Insert DataConstants values  ('PhotoFlags','DEBLENDED_AT_EDGE',		0x0000200000000000, 'An object close enough to the edge of the frame normally not deblended, is deblended anyway. Only set for objects large enough to be EDGE in all fields/strips.')
Insert DataConstants values  ('PhotoFlags','DEBLEND_NOPEAK', 		0x0000400000000000, 'There was no detected peak within this child in at least one band.')
Insert DataConstants values  ('PhotoFlags','PSF_FLUX_INTERP',		0x0000800000000000, 'Greater than 20% of the PSF flux is from interpolated pixels.')
Insert DataConstants values  ('PhotoFlags','TOO_FEW_GOOD_DETECTIONS',	0x0001000000000000, 'A child of this object had too few good detections to be deblended as moving.')
Insert DataConstants values  ('PhotoFlags','CENTER_OFF_AIMAGE',		0x0002000000000000, 'At least one peak''s center lay off of the atlas image. This can happen when the object is deblended as moving, or if the astrometry is bad.')
Insert DataConstants values  ('PhotoFlags','DEBLEND_DEGENERATE',	0x0004000000000000, 'Two or more candidate children were essentially identical; one one was retained.')
Insert DataConstants values  ('PhotoFlags','BRIGHTEST_GALAXY_CHILD',	0x0008000000000000, 'This child is the brightest family member (in this band) that is classified as a galaxy.')
Insert DataConstants values  ('PhotoFlags','CANONICAL_BAND',		0x0010000000000000, 'This is the ''canonical'' band; r unless the object is undetected in the r filter.')
Insert DataConstants values  ('PhotoFlags','AMOMENT_FAINT',		0x0020000000000000, 'Object was too faint to measure weighted moments such as mE1_g; unweighted values are reported.')
Insert DataConstants values  ('PhotoFlags','AMOMENT_SHIFT',		0x0040000000000000, 'Centroid shift too large when measuring adaptive moments. Row/Column shifts are reported in mE1, mE2.')
Insert DataConstants values  ('PhotoFlags','AMOMENT_MAXITER',		0x0080000000000000, 'Maximum number of iterations exceeded measuring e.g. mE2_g; unweighted values are reported.')
Insert DataConstants values  ('PhotoFlags','MAYBE_CR',			0x0100000000000000, 'There is reasonable suspicion that this object is actually a cosmic ray.')
Insert DataConstants values  ('PhotoFlags','MAYBE_EGHOST',		0x0200000000000000, 'There is reasonable suspicion that this object is actually a ghost produced by the CCD electronics.')
Insert DataConstants values  ('PhotoFlags','NOTCHECKED_CENTER',		0x0400000000000000, 'The center of this object lies in a region that was not searched for objects.')
Insert DataConstants values  ('PhotoFlags','OBJECT2_HAS_SATUR_DN',	0x0800000000000000, 'The electrons in this saturated object''s bleed trails have been included in its estimated flux.')
Insert DataConstants values  ('PhotoFlags','OBJECT2_DEBLEND_PEEPHOLE',	0x1000000000000000, 'Deblend was modified by the deblender''s peephole optimiser.')
Insert DataConstants values  ('PhotoFlags','GROWN_MERGED',   		0x2000000000000000, 'Growing led to a merger')
Insert DataConstants values  ('PhotoFlags','HAS_CENTER',		0x4000000000000000, 'Object has a canonical center')
Insert DataConstants values  ('PhotoFlags','RESERVED', 			0x8000000000000000, 'Not used')
GO

-- CalibStatus 32 (12 values)
Insert DataConstants values  ('CalibStatus','',				0x0000, 'Calibration status for an SDSS image. Please see the CALIB_STATUS entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('CalibStatus','PHOTOMETRIC',		0x0001, 'Photometric observations')
Insert DataConstants values  ('CalibStatus','UNPHOT_OVERLAP',		0x0002, 'Unphotometric observations, calibrated based on overlaps with clear, ubercalibrated data; done on a field-by-field basis. Use with caution.')
Insert DataConstants values  ('CalibStatus','UNPHOT_EXTRAP_CLEAR',	0x0004, 'Extrapolate the solution from the clear part of a night (that was ubercalibrated) to the cloudy part. Not recommended for use.')
Insert DataConstants values  ('CalibStatus','UNPHOT_EXTRAP_CLOUDY',	0x0008, 'Extrapolate the solution from a cloudy part of the night (where there is overlap) to a region of no overlap. Not recommended for use.')
Insert DataConstants values  ('CalibStatus','UNPHOT_DISJOINT',		0x0010, 'Data is disjoint from the rest of the survey (even though conditions may be photometric), the calibration is suspect. Not recommended for use.')
Insert DataConstants values  ('CalibStatus','INCREMENT_CALIB',		0x0020, 'Incrementally calibrated by considering overlaps with ubercalibrated data')
Insert DataConstants values  ('CalibStatus','RESERVED2',		0x0040, 'Reserved for future use')
Insert DataConstants values  ('CalibStatus','RESERVED3',		0x0080, 'Reserved for future use')
Insert DataConstants values  ('CalibStatus','PT_CLEAR',			0x0100, '[Internal use only in DR8 and later] PT calibration for clear data')
Insert DataConstants values  ('CalibStatus','PT_CLOUDY',		0x0200, '[Internal use only in DR8 and later] PT calibration for cloudy data')
Insert DataConstants values  ('CalibStatus','DEFAULT',			0x0400, '[Internal use only in DR8 and later] A default calibration is applied (no PT or ubercal)')
Insert DataConstants values  ('CalibStatus','NO_UBERCAL',		0x0800, '[Internal use only in DR8 and later] Not uber-calibrated.')
GO

-- FieldQuality (5 values, EDR 5)
Insert DataConstants values  ('FieldQuality',	'',			0, 'Enumerated quality indicator for SDSS field (based on "score").')
Insert DataConstants values  ('FieldQuality',	'BAD',			1, 'Not acceptable for the survey')
Insert DataConstants values  ('FieldQuality',	'ACCEPTABLE', 		2, 'Barely acceptable for the survey')
Insert DataConstants values  ('FieldQuality',	'GOOD',			3, 'Fully acceptable -- no desire for better data')
Insert DataConstants values  ('FieldQuality',	'MISSING',		4, 'No objects in the field, because data is missing. We accept the field into the survey as a HOLE')
Insert DataConstants values  ('FieldQuality',	'HOLE',			5, 'Data in this field is not acceptable, but we will put the field into the survey as a HOLE, meaning none of the objects in the field are part of the survey')
GO

-- PspStatus 16 (10 values, EDR FieldStatus 4)
Insert DataConstants values  ('PspStatus',	'',			0,	'Maximum value of PSP (Postage Stamp Pipeline) status over all 5 filters.')
-- Insert DataConstants values  ('PspStatus',	'FIELD_UNKNOWN',	0xFFFF, 'This should never happen')
Insert DataConstants values  ('PspStatus',	'FIELD_OK',		0,	'Everything OK')
Insert DataConstants values  ('PspStatus',	'FIELD_PSF22',		1,	'Forced to take linear PSF across field')
Insert DataConstants values  ('PspStatus',	'FIELD_PSF11',		2,	'Forced to take constant PSF across field')
Insert DataConstants values  ('PspStatus',	'FIELD_NOPSF',		3,	'Forced to take default PSF')
Insert DataConstants values  ('PspStatus',	'FIELD_ABORTED',	4,	'Aborted processing')
Insert DataConstants values  ('PspStatus',	'FIELD_MISSING',	5,	'Missing (dummy) field')
Insert DataConstants values  ('PspStatus',	'FIELD_OE_TRANSIENT',	6,	'Field with odd/even bias level transient')
-- Insert DataConstants values  ('PspStatus',	'FIELD_EXTENDED_KL',	0x0020, 'Window for KL stars was extended')
-- Insert DataConstants values  ('PspStatus',	'FIELD_SPARSE',		0x0040, 'Field is sparsely populated with KL stars')
GO

-- FramesStatus 32 (4 values)
INSERT DataConstants VALUES ('FramesStatus',	'',		0,	'Frames processing status bitmask.')
INSERT DataConstants VALUES ('FramesStatus',	'OK',		0,	'status is OK')
INSERT DataConstants VALUES ('FramesStatus',	'ABORTED',	1,	'status is ABORTED')
INSERT DataConstants VALUES ('FramesStatus',	'MISSING',	2,	'status is MISSING')
INSERT DataConstants VALUES ('FramesStatus',	'TOO_LONG',	3,	'status is TOO_LONG')
GO
--

-- ImageStatus 32 (10 values)
Insert DataConstants values  ('ImageStatus',	'',		0,	'Sky and instrument conditions of SDSS image. Please see the IMAGE_STATUS entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ImageStatus',	'CLEAR',	0x00000001,	'Clear skies')
Insert DataConstants values  ('ImageStatus',	'CLOUDY',	0x00000002,	'Cloudy skies (unphotometric)')
Insert DataConstants values  ('ImageStatus',	'UNKNOWN',	0x00000004,	'Sky conditions unknown (unphotometric)')
Insert DataConstants values  ('ImageStatus',	'BAD_ROTATOR',	0x00000008,	'Rotator problems (set score=0)')
Insert DataConstants values  ('ImageStatus',	'BAD_ASTROM',	0x00000010,	'Astrometry problems (set score=0)')
Insert DataConstants values  ('ImageStatus',	'BAD_FOCUS',	0x00000020,	'Focus bad (set score=0)')
Insert DataConstants values  ('ImageStatus',	'SHUTTERS',	0x00000040,	'Shutter out of place (set score=0)')
Insert DataConstants values  ('ImageStatus',	'FF_PETALS',	0x00000080,	'Flat-field petals out of place (unphotometric)')
Insert DataConstants values  ('ImageStatus',	'DEAD_CCD',	0x00000100,	'CCD bad (unphotometric)')
Insert DataConstants values  ('ImageStatus',	'NOISY_CCD',	0x00000200,	'CCD noisy (unphotometric)')
GO

-- ResolveStatus 32 (13 values)
Insert DataConstants values  ('ResolveStatus',	'',			0,	'Resolve status of object. Please see the RESOLVE_STATUS entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ResolveStatus',	'RUN_PRIMARY',		0x0000000000000001,	'primary within the objects own run (but not necessarily for the survey as a whole)')
Insert DataConstants values  ('ResolveStatus',	'RUN_RAMP',		0x0000000000000002,	'in what would be the overlap area of a field, but with no neighboring field')
Insert DataConstants values  ('ResolveStatus',	'RUN_OVERLAPONLY',	0x0000000000000004,	'only appears in the overlap between two fields')
Insert DataConstants values  ('ResolveStatus',	'RUN_IGNORE',		0x0000000000000008,	'bright or parent object that should be ignored')
Insert DataConstants values  ('ResolveStatus',	'RUN_EDGE',		0x0000000000000010,	'near lowest or highest column')
Insert DataConstants values  ('ResolveStatus',	'RUN_DUPLICATE',	0x0000000000000020,	'duplicate measurement of same pixels in two different fields')
Insert DataConstants values  ('ResolveStatus',	'SURVEY_PRIMARY',	0x0000000000000100,	'Primary observation within the full survey, where it appears in the primary observation of this part of the sky')
Insert DataConstants values  ('ResolveStatus',	'SURVEY_BEST',		0x0000000000000200,	'Best observation within the full survey, but it does not appear in the primary observation of this part of the sky')
Insert DataConstants values  ('ResolveStatus',	'SURVEY_SECONDARY',	0x0000000000000400,	'Repeat (independent) observation of an object that has a different primary or best observation')
Insert DataConstants values  ('ResolveStatus',	'SURVEY_BADFIELD',	0x0000000000000800,	'In field with score=0')
Insert DataConstants values  ('ResolveStatus',	'SURVEY_EDGE',		0x0000000000001000,	'Not kept as secondary because it is RUN_RAMP or RUN_EDGE object')
GO

-- PrimTarget 32 (31 values, EDR 30)
Insert DataConstants values  ('PrimTarget',	'',			0x0000000000000000, 'Primary target mask bits in SDSS-I, -II (for LEGACY_TARGET1 or PRIMTARGET).')
Insert DataConstants values  ('PrimTarget',	'QSO_HIZ',		0x0000000000000001, 'High-redshift (griz) QSO target')
Insert DataConstants values  ('PrimTarget',	'QSO_CAP',		0x0000000000000002, 'ugri-selected quasar at high Galactic latitude')
Insert DataConstants values  ('PrimTarget',	'QSO_SKIRT',		0x0000000000000004, 'ugri-selected quasar at low Galactic latitude')
Insert DataConstants values  ('PrimTarget',	'QSO_FIRST_CAP',	0x0000000000000008, 'FIRST source with stellar colors at high Galactic latitude')
Insert DataConstants values  ('PrimTarget',	'QSO_FIRST_SKIRT',	0x0000000000000010, 'FIRST source with stellar colors at low Galactic latitude')
Insert DataConstants values  ('PrimTarget',	'GALAXY_RED',		0x0000000000000020, 'Luminous Red Galaxy target (any criteria)')
Insert DataConstants values  ('PrimTarget',	'GALAXY',		0x0000000000000040, 'Main sample galaxy')
Insert DataConstants values  ('PrimTarget',	'GALAXY_BIG',		0x0000000000000080, 'Low-surface brightness main sample galaxy (mu50>23 in r-band)')
Insert DataConstants values  ('PrimTarget',	'GALAXY_BRIGHT_CORE',	0x0000000000000100, 'Galaxy targets who fail all the surface brightness selection limits but have r-band fiber magnitudes brighter than 19')
Insert DataConstants values  ('PrimTarget',	'ROSAT_A',		0x0000000000000200, 'ROSAT All-Sky Survey match, also a radio source')
Insert DataConstants values  ('PrimTarget',	'ROSAT_B',		0x0000000000000400, 'ROSAT All-Sky Survey match, have SDSS colors of AGNs or quasars')
Insert DataConstants values  ('PrimTarget',	'ROSAT_C',		0x0000000000000800, 'ROSAT All-Sky Survey match, fall in a broad intermediate category that includes stars that are bright, moderately blue, or both')
Insert DataConstants values  ('PrimTarget',	'ROSAT_D',		0x0000000000001000, 'ROSAT All-Sky Survey match, are otherwise bright enough for SDSS spectroscopy')
Insert DataConstants values  ('PrimTarget',	'STAR_BHB',		0x0000000000002000, 'blue horizontal-branch stars')
Insert DataConstants values  ('PrimTarget',	'STAR_CARBON',		0x0000000000004000, 'dwarf and giant carbon stars')
Insert DataConstants values  ('PrimTarget',	'STAR_BROWN_DWARF',	0x0000000000008000, 'brown dwarfs (note this sample is tiled)')
Insert DataConstants values  ('PrimTarget',	'STAR_SUB_DWARF',	0x0000000000010000, 'low-luminosity subdwarfs')
Insert DataConstants values  ('PrimTarget',	'STAR_CATY_VAR',	0x0000000000020000, 'cataclysmic variables')
Insert DataConstants values  ('PrimTarget',	'STAR_RED_DWARF',	0x0000000000040000, 'red dwarfs')
Insert DataConstants values  ('PrimTarget',	'STAR_WHITE_DWARF',	0x0000000000080000, 'hot white dwarfs')
Insert DataConstants values  ('PrimTarget',	'SERENDIP_BLUE',	0x0000000000100000, 'lying outside the stellar locus in color space')
Insert DataConstants values  ('PrimTarget',	'SERENDIP_FIRST',	0x0000000000200000, 'coincident with FIRST sources but fainter than the equivalent in quasar target selection (also includes non-PSF sources')
Insert DataConstants values  ('PrimTarget',	'SERENDIP_RED',		0x0000000000400000, 'lying outside the stellar locus in color space')
Insert DataConstants values  ('PrimTarget',	'SERENDIP_DISTANT',	0x0000000000800000, 'lying outside the stellar locus in color space')
Insert DataConstants values  ('PrimTarget',	'SERENDIP_MANUAL',	0x0000000001000000, 'manual serendipity flag')
Insert DataConstants values  ('PrimTarget',	'QSO_FAINT',		0x0000000002000000, 'Stellar outlier; too faint or too bright to be targeted')
Insert DataConstants values  ('PrimTarget',	'GALAXY_RED_II',	0x0000000004000000, 'Luminous Red Galaxy target (Cut II criteria)')
Insert DataConstants values  ('PrimTarget',	'ROSAT_E',		0x0000000008000000, 'ROSAT All-Sky Survey match, but too faint or too bright for SDSS spectroscopy')
Insert DataConstants values  ('PrimTarget',	'STAR_PN',		0x0000000010000000, 'central stars of planetary nebulae')
Insert DataConstants values  ('PrimTarget',	'QSO_REJECT',		0x0000000020000000, 'Object in explicitly excluded region of color space, therefore not targeted at QSO')
Insert DataConstants values  ('PrimTarget',	'SOUTHERN_SURVEY',	0x0000000080000000, 'Set in primtarget if this is a special program target')
GO

-- SecTarget (11 values, EDR 10)
Insert DataConstants values  ('SecTarget',	'',				0x0000000000000000, 'Secondary target mask bits in SDSS-I, -II (for LEGACY_TARGET2 or SECTARGET).')
Insert DataConstants values  ('SecTarget',	'LIGHT_TRAP',		0x0000000000000001, 'hole drilled for bright star, to avoid scattered light')
Insert DataConstants values  ('SecTarget',	'REDDEN_STD',		0x0000000000000002, 'reddening standard star')
Insert DataConstants values  ('SecTarget',	'TEST_TARGET',		0x0000000000000004, 'a test target')
Insert DataConstants values  ('SecTarget',	'QA',			0x0000000000000008, 'quality assurance target')
Insert DataConstants values  ('SecTarget',	'SKY',			0x0000000000000010, 'sky target')
Insert DataConstants values  ('SecTarget',	'SPECTROPHOTO_STD',	0x0000000000000020, 'spectrophotometry standard (typically an F-star)')
Insert DataConstants values  ('SecTarget',	'GUIDE_STAR',		0x0000000000000040, 'guide star hole')
Insert DataConstants values  ('SecTarget',	'BUNDLE_HOLE',		0x0000000000000080, 'fiber bundle hole')
Insert DataConstants values  ('SecTarget',	'QUALITY_HOLE',		0x0000000000000100, 'hole drilled for plate shop quality measurements')
Insert DataConstants values  ('SecTarget',	'HOT_STD',		0x0000000000000200, 'hot standard star')
Insert DataConstants values  ('SecTarget',	'SEGUE2_CLUSTER',	0x0000000000000400, 'SEGUE-2 stellar cluster target')
Insert DataConstants values  ('SecTarget',	'SEGUE2_STETSON',	0x0000000000000800, 'SEGUE-2 Stetson standard target')
Insert DataConstants values  ('SecTarget',	'SOUTHERN_SURVEY',	0x0000000080000000, 'SEGUE-2 checked object or a SEGUE-1/southern survey target')
GO

-- Segue1Target1 (19 values)
Insert DataConstants values  ('Segue1Target1',	'',			0x0000000000000000,	'SEGUE-1 primary target bits. Please see the SEGUE1_TARGET1 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_FG',		0x0000000000000200,	'F and G stars, based on g-r color (0.2 < g-r < 0.48 and 14 < g < 20.2)')
Insert DataConstants values  ('Segue1Target1',	'SEG1LOW_KG',		0x0000000000000400,	'low latitude selection of K-giant stars')
Insert DataConstants values  ('Segue1Target1',	'SEG1LOW_TO',		0x0000000000000800,	'low latitude selection of bluetip stars')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_MSWD',		0x0000000000001000,	'main-sequence, white dwarf pair')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_BHB',		0x0000000000002000,	'blue horizontal branch star')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_KG',		0x0000000000004000,	'K-giants (l and red)')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_KD',		0x0000000000008000,	'K-dwarfs')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_LM',		0x0000000000010000,	'low metallicity star')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_CWD',		0x0000000000020000,	'cool white dwarf')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_GD',		0x0000000000040000,	'G-dwarf')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_WD',		0x0000000000080000,	'white dwarf')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_MPMSTO',	0x0000000000100000,	'metal-poor main sequence turn-off')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_BD',		0x0000000000200000,	'brown dwarfs')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_SDM',		0x0000000000400000,	'M sub-dwarfs')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_AGB',		0x0000000000800000,	'asympototic giant branch stars')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_MAN',		0x0000000001000000,	'manual selection')
Insert DataConstants values  ('Segue1Target1',	'SEG1LOW_AGB',		0x0000000008000000,	'low latitude selection of AGB stars')
Insert DataConstants values  ('Segue1Target1',	'SEGUE1_CHECKED',	0x0000000080000000,	'was a checked object')
GO

-- Segue1Target2 (5 values)
Insert DataConstants values  ('Segue1Target2',	'',			0x0000000000000000,	'SEGUE-1 secondary target bits. Please see the SEGUE1_TARGET2 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('Segue1Target2',	'SCIENCE',		0x0000000000000002,	'Science Target')
Insert DataConstants values  ('Segue1Target2',	'SEGUE1_REDDENING',	0x0000000000000004,	'Reddening standard')
Insert DataConstants values  ('Segue1Target2',	'SEGUE1_QA*',		0x0000000000000008,	'QA Duplicate Observations')
Insert DataConstants values  ('Segue1Target2',	'SKY',			0x0000000000000010,	'Empty area for sky subtraction')
Insert DataConstants values  ('Segue1Target2',	'SEGUE1_SPECPHOTO',	0x0000000000000200,	'Spectrophotometric standard star')
GO

-- Segue2Target1 (12 values)
Insert DataConstants values  ('Segue2Target1',	'',			0x0000000000000000,	'SEGUE-2 primary target bits. Please see the SEGUE2_TARGET1 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_MSTO',		0x0000000000000000,	'Main-sequence turnoff')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_REDKG',		0x0000000000000002,	'Red K-giant stars')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_LKG',		0x0000000000000004,	'K-giant star identified by l-color')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_PMKG',		0x0000000000000008,	'K-giant star identified by proper motions')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_LM',		0x0000000000000010,	'Low metallicity')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_HVS',		0x0000000000000020,	'hyper velocity candidate')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_XDM',		0x0000000000000040,	'extreme sdM star')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_MII',		0x0000000000000080,	'M giant')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_HHV',		0x0000000000000100,	'High-velocity halo star candidate')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_BHB',		0x0000000000000200,	'Blue horizontal branch star')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_CWD',		0x0000000000000400,	'Cool white dwarf')
Insert DataConstants values  ('Segue2Target1',	'SEGUE2_CHECKED',	0x0000000080000000,	'was a checked object')
GO

-- Segue2Target2 (13 values)
Insert DataConstants values  ('Segue2Target2',	'',			0x0000000000000000,	'SEGUE-2 secondary target bits. Please see the SEGUE2_TARGET2 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('Segue2Target2',	'LIGHT_TRAP',		0x0000000000000001,	'light trap hole')
Insert DataConstants values  ('Segue2Target2',	'SEGUE2_REDDENING',	0x0000000000000002,	'reddening standard')
Insert DataConstants values  ('Segue2Target2',	'SEGUE2_TEST',		0x0000000000000004,	'test target')
Insert DataConstants values  ('Segue2Target2',	'SEGUE2_QA*',		0x0000000000000008,	'repeat target across plates')
Insert DataConstants values  ('Segue2Target2',	'SKY',			0x0000000000000010,	'empty area for sky-subtraction')
Insert DataConstants values  ('Segue2Target2',	'SEGUE2_SPECPHOTO',	0x0000000000000020,	'spectrophotometric star')
Insert DataConstants values  ('Segue2Target2',	'GUIDE_STAR',		0x0000000000000040,	'guide star')
Insert DataConstants values  ('Segue2Target2',	'BUNDLE_HOLE',		0x0000000000000080,	'bundle hole')
Insert DataConstants values  ('Segue2Target2',	'QUALITY_HOLE',		0x0000000000000100,	'quality hole')
Insert DataConstants values  ('Segue2Target2',	'HOT_STD',		0x0000000000000200,	'hot standard')
Insert DataConstants values  ('Segue2Target2',	'SEGUE2_CLUSTER',	0x0000000000000400,	'SEGUE-2 stellar cluster target')
Insert DataConstants values  ('Segue2Target2',	'SEGUE2_STETSON',	0x0000000000000800,	'Stetson standard target')
Insert DataConstants values  ('Segue2Target2',	'SEGUE2_CHECKED',	0x0000000080000000,	'was a checked object')
GO

-- SpecialTarget1 (39 values)
Insert DataConstants values  ('SpecialTarget1',	'',			0x0000000000000000,	'SDSS special program target bits. Please see the SPECIAL_TARGET1 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('SpecialTarget1',	'APBIAS',		0x0000000000000001,	'aperture bias target')
Insert DataConstants values  ('SpecialTarget1',	'LOWZ_ANNIS',		0x0000000000000002,	'low-redshift cluster galaxy')
Insert DataConstants values  ('SpecialTarget1',	'QSO_M31',		0x0000000000000004,	'QSO in M31')
Insert DataConstants values  ('SpecialTarget1',	'COMMISSIONING_STAR',	0x0000000000000008,	'star in commissioning')
Insert DataConstants values  ('SpecialTarget1',	'DISKSTAR',		0x0000000000000010,	'thin/thick disk star')
Insert DataConstants values  ('SpecialTarget1',	'FSTAR',		0x0000000000000020,	'F-stars')
Insert DataConstants values  ('SpecialTarget1',	'HYADES_MSTAR',		0x0000000000000040,	'M-star in Hyades')
Insert DataConstants values  ('SpecialTarget1',	'LOWZ_GALAXY',		0x0000000000000080,	'low-redshift galaxy')
Insert DataConstants values  ('SpecialTarget1',	'DEEP_GALAXY_RED',	0x0000000000000100,	'deep LRG')
Insert DataConstants values  ('SpecialTarget1',	'DEEP_GALAXY_RED_II',	0x0000000000000200,	'deep LRG')
Insert DataConstants values  ('SpecialTarget1',	'BCG',			0x0000000000000400,	'brightest cluster galaxy')
Insert DataConstants values  ('SpecialTarget1',	'MSTURNOFF',		0x0000000000000800,	'main sequence turnoff')
Insert DataConstants values  ('SpecialTarget1',	'ORION_BD',		0x0000000000001000,	'Brown dwarf in Orion')
Insert DataConstants values  ('SpecialTarget1',	'ORION_MSTAR_EARLY',	0x0000000000002000,	'Early-type M-star (M0-3) in Orion')
Insert DataConstants values  ('SpecialTarget1',	'ORION_MSTAR_LATE',	0x0000000000004000,	'Late-type M-star (M4-) in Orion')
Insert DataConstants values  ('SpecialTarget1',	'SPECIAL_FILLER',	0x0000000000008000,	'filler from completeTile, check primtarget for details')
Insert DataConstants values  ('SpecialTarget1',	'PHOTOZ_GALAXY',	0x0000000000010000,	'test galaxy for photometric redshifts')
Insert DataConstants values  ('SpecialTarget1',	'PREBOSS_QSO',		0x0000000000020000,	'QSO for pre-BOSS observations')
Insert DataConstants values  ('SpecialTarget1',	'PREBOSS_LRG',		0x0000000000040000,	'QSO for pre-BOSS observations')
Insert DataConstants values  ('SpecialTarget1',	'PREMARVELS',		0x0000000000080000,	'pre-MARVELS stellar target')
Insert DataConstants values  ('SpecialTarget1',	'SOUTHERN_EXTENDED',	0x0000000000100000,	'simple extension of southern targets')
Insert DataConstants values  ('SpecialTarget1',	'SOUTHERN_COMPLETE',	0x0000000000200000,	'completion in south of main targets')
Insert DataConstants values  ('SpecialTarget1',	'U_PRIORITY',		0x0000000000400000,	'priority u-band target')
Insert DataConstants values  ('SpecialTarget1',	'U_EXTRA',		0x0000000000800000,	'extra u-band target')
Insert DataConstants values  ('SpecialTarget1',	'U_EXTRA2',		0x0000000001000000,	'extra u-band target')
Insert DataConstants values  ('SpecialTarget1',	'FAINT_LRG',		0x0000000002000000,	'faint LRG in south')
Insert DataConstants values  ('SpecialTarget1',	'FAINT_QSO',		0x0000000004000000,	'faint QSO in south')
Insert DataConstants values  ('SpecialTarget1',	'BENT_RADIO',		0x0000000008000000,	'bent double-lobed radio source')
Insert DataConstants values  ('SpecialTarget1',	'STRAIGHT_RADIO',	0x0000000010000000,	'straight double-lobed radio source')
Insert DataConstants values  ('SpecialTarget1',	'VARIABLE_HIPRI',	0x0000000020000000,	'high priority variable')
Insert DataConstants values  ('SpecialTarget1',	'VARIABLE_LOPRI',	0x0000000040000000,	'low priority variable')
Insert DataConstants values  ('SpecialTarget1',	'ALLPSF',		0x0000000080000000,	'i < 19.1 point sources')
Insert DataConstants values  ('SpecialTarget1',	'ALLPSF_NONSTELLAR',	0x0000000100000000,	'i < 19.1 point sources off stellar locus')
Insert DataConstants values  ('SpecialTarget1',	'ALLPSF_STELLAR',	0x0000000200000000,	'i < 19.1 point sources on stellar locus')
Insert DataConstants values  ('SpecialTarget1',	'HIPM',			0x0000000400000000,	'high proper motion')
Insert DataConstants values  ('SpecialTarget1',	'TAURUS_STAR',		0x0000000800000000,	'star on taurus or reddening plate')
Insert DataConstants values  ('SpecialTarget1',	'TAURUS_GALAXY',	0x0000001000000000,	'galaxy on taurus or reddening plate')
Insert DataConstants values  ('SpecialTarget1',	'PERSEUS',		0x0000002000000000,	'galaxy in perseus-pisces')
Insert DataConstants values  ('SpecialTarget1',	'LOWZ_LOVEDAY',		0x0000004000000000,	'low redshift galaxy selected by Loveday')
GO


-- SpecialTarget2 (11 values)
Insert DataConstants values  ('SpecialTarget2',	'',			0x0000000000000000,	'Secondary target mask bits in SDSS-I, -II. Please see the SPECIAL_TARGET2 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('SpecialTarget2',	'LIGHT_TRAP',		0x0000000000000001,	'hole drilled for bright star, to avoid scattered light')
Insert DataConstants values  ('SpecialTarget2',	'REDDEN_STD',		0x0000000000000002,	'reddening standard star')
Insert DataConstants values  ('SpecialTarget2',	'TEST_TARGET',		0x0000000000000004,	'a test target')
Insert DataConstants values  ('SpecialTarget2',	'QA',			0x0000000000000008,	'quality assurance target')
Insert DataConstants values  ('SpecialTarget2',	'SKY',			0x0000000000000010,	'sky target')
Insert DataConstants values  ('SpecialTarget2',	'SPECTROPHOTO_STD',	0x0000000000000020,	'spectrophotometry standard (typically an F-star)')
Insert DataConstants values  ('SpecialTarget2',	'GUIDE_STAR',		0x0000000000000040,	'guide star hole')
Insert DataConstants values  ('SpecialTarget2',	'BUNDLE_HOLE',		0x0000000000000080,	'fiber bundle hole')
Insert DataConstants values  ('SpecialTarget2',	'QUALITY_HOLE',		0x0000000000000100,	'hole drilled for plate shop quality measurements')
Insert DataConstants values  ('SpecialTarget2',	'HOT_STD',		0x0000000000000200,	'hot standard star')
Insert DataConstants values  ('SpecialTarget2',	'SOUTHERN_SURVEY',	0x0000000080000000,	'a segue or southern survey target')
GO


-- BossTarget1 (39 values)
Insert DataConstants values  ('BossTarget1',	'',			0x0000000000000000,	'BOSS primary target selection flags. Please see the BOSS_TARGET1 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('BossTarget1',	'GAL_LOZ',		0x0000000000000001,	'low-z lrgs')
Insert DataConstants values  ('BossTarget1',	'GAL_CMASS',		0x0000000000000002,	'dperp > 0.55, color-mag cut')
Insert DataConstants values  ('BossTarget1',	'GAL_CMASS_COMM',	0x0000000000000004,	'dperp > 0.55, commissioning color-mag cut')
Insert DataConstants values  ('BossTarget1',	'GAL_CMASS_SPARSE',	0x0000000000000008,	'GAL_CMASS_COMM & (!GAL_CMASS) & (i < 19.9) sparsely sampled')
Insert DataConstants values  ('BossTarget1',	'SDSS_KNOWN',		0x0000000000000040,	'Matches a known SDSS spectra')
Insert DataConstants values  ('BossTarget1',	'GAL_CMASS_ALL',	0x0000000000000080,	'GAL_CMASS and the entire sparsely sampled region')
Insert DataConstants values  ('BossTarget1',	'GAL_IFIBER2_FAINT',	0x0000000000000100,	'ifiber2 > 21.5, extinction corrected. Used after Nov 2010')
Insert DataConstants values  ('BossTarget1',	'QSO_CORE',		0x0000000000000400,	'restrictive qso selection: commissioning only')
Insert DataConstants values  ('BossTarget1',	'QSO_BONUS',		0x0000000000000800,	'permissive qso selection: commissioning only')
Insert DataConstants values  ('BossTarget1',	'QSO_KNOWN_MIDZ',	0x0000000000001000,	'known qso between [2.2,9.99]')
Insert DataConstants values  ('BossTarget1',	'QSO_KNOWN_LOHIZ',	0x0000000000002000,	'known qso outside of miz range. never target')
Insert DataConstants values  ('BossTarget1',	'QSO_NN',		0x0000000000004000,	'Neural Net that match to sweeps/pass cuts')
Insert DataConstants values  ('BossTarget1',	'QSO_UKIDSS',		0x0000000000008000,	'UKIDSS stars that match sweeps/pass flag cuts')
Insert DataConstants values  ('BossTarget1',	'QSO_KDE_COADD',	0x0000000000010000,	'kde targets from the stripe82 coadd')
Insert DataConstants values  ('BossTarget1',	'QSO_LIKE',		0x0000000000020000,	'likelihood method')
Insert DataConstants values  ('BossTarget1',	'QSO_FIRST_BOSS',	0x0000000000040000,	'FIRST radio match')
Insert DataConstants values  ('BossTarget1',	'QSO_KDE',		0x0000000000080000,	'selected by kde+chi2')
Insert DataConstants values  ('BossTarget1',	'STD_FSTAR',		0x0000000000100000,	'standard f-stars')
Insert DataConstants values  ('BossTarget1',	'STD_WD',		0x0000000000200000,	'white dwarfs')
Insert DataConstants values  ('BossTarget1',	'STD_QSO',		0x0000000000400000,	'qso')
Insert DataConstants values  ('BossTarget1',	'TEMPLATE_GAL_PHOTO',	0x0000000100000000,	'galaxy templates')
Insert DataConstants values  ('BossTarget1',	'TEMPLATE_QSO_SDSS1',	0x0000000200000000,	'QSO templates')
Insert DataConstants values  ('BossTarget1',	'TEMPLATE_STAR_PHOTO',	0x0000000400000000,	'stellar templates')
Insert DataConstants values  ('BossTarget1',	'TEMPLATE_STAR_SPECTRO',0x0000000800000000,	'stellar templates (spectroscopically known)')
Insert DataConstants values  ('BossTarget1',	'QSO_CORE_MAIN',	0x0000010000000000,	'Main survey core sample')
Insert DataConstants values  ('BossTarget1',	'QSO_BONUS_MAIN',	0x0000020000000000,	'Main survey bonus sample')
Insert DataConstants values  ('BossTarget1',	'QSO_CORE_ED',		0x0000040000000000,	'Extreme Deconvolution in Core')
Insert DataConstants values  ('BossTarget1',	'QSO_CORE_LIKE',	0x0000080000000000,	'Likelihood that make it into core')
Insert DataConstants values  ('BossTarget1',	'QSO_KNOWN_SUPPZ',	0x0000100000000000,	'known qso between [1.8,2.15]')
GO

-- AncillaryTarget1 (63 values)
Insert DataConstants values  ('AncillaryTarget1',	'',			0x0000000000000000,	'Objects selected as BOSS ancillary targets. Please see the ANCILLARY_TARGET1 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('AncillaryTarget1',	'AMC',			0x0000000000000001,	'Candidate Am CVn variables in Stripe 82')
Insert DataConstants values  ('AncillaryTarget1',	'FLARE1',		0x0000000000000002,	'Flaring M stars in Stripe 82 (year 1 targets)')
Insert DataConstants values  ('AncillaryTarget1',	'FLARE2',		0x0000000000000004,	'Flaring M stars in Stripe 82 (year 2 targets)')
Insert DataConstants values  ('AncillaryTarget1',	'HPM',			0x0000000000000008,	'High Proper Motion stars in Stripe 82')
Insert DataConstants values  ('AncillaryTarget1',	'LOW_MET',		0x0000000000000010,	'Low-metallicity M dwarfs in Stripe 82')
Insert DataConstants values  ('AncillaryTarget1',	'VARS',			0x0000000000000020,	'Unusual variable objects (colors outside the stellar and quasar loci) in Stripe 82')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZGVAR',		0x0000000000000040,	'A flag used in a pilot version of the ancillary targeting program High-Energy Blazars and Optical Counterparts to Gamma-Ray Sources; no longer used')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZR',		0x0000000000000080,	'A flag used in a pilot version of the ancillary targeting program High-Energy Blazars and Optical Counterparts to Gamma-Ray Sources; no longer used')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZXR',		0x0000000000000100,	'A target that might have a match with a Fermi source, but which is now below the detection limits of the early Fermi source catalogs')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZXRSAM',		0x0000000000000200,	'A flag used in a pilot version of the ancillary targeting program High-Energy Blazars and Optical Counterparts to Gamma-Ray Sources; no longer used')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZXRVAR',		0x0000000000000400,	'A flag used in a pilot version of the ancillary targeting program High-Energy Blazars and Optical Counterparts to Gamma-Ray Sources; no longer used')
Insert DataConstants values  ('AncillaryTarget1',	'XMMBRIGHT',		0x0000000000000800,	'An object that matches a serendipitous x-ray source from the Second XMM-Newton Serendipitous Source Catalog (2XMMi), with bright i magnitudes (i < 20.5) and bright 2-12 keV fluxes (f2-12 keV > 5 x 10-14 erg*cm-2*s-1)')
Insert DataConstants values  ('AncillaryTarget1',	'XMMGRIZ',		0x0000000000001000,	'An object that matches a serendipitous x-ray source from the Second XMM-Newton Serendipitous Source Catalog (2XMMi), with outlier SDSS colors (g - r > 1.2 or r - i > 1.0 or i - z > 1.4)')
Insert DataConstants values  ('AncillaryTarget1',	'XMMHR',		0x0000000000002000,	'An object that matches a serendipitous x-ray source from the Second XMM-Newton Serendipitous Source Catalog (2XMMi), with unusual hardness ratios in the HR2-HR3 plane')
Insert DataConstants values  ('AncillaryTarget1',	'XMMRED',		0x0000000000004000,	'An object that matches a serendipitous x-ray source from the Second XMM-Newton Serendipitous Source Catalog (2XMMi) with highly red SDSS colors (g - i > 1.0)')
Insert DataConstants values  ('AncillaryTarget1',	'FBQSBAL',		0x0000000000008000,	'Broad absorption line (BAL) quasar with spectrum from the FIRST Bright Quasar Survey')
Insert DataConstants values  ('AncillaryTarget1',	'LBQSBAL',		0x0000000000010000,	'Broad absorption line (BAL) quasar with spectrum from the Large Bright Quasar Survey')
Insert DataConstants values  ('AncillaryTarget1',	'ODDBAL',		0x0000000000020000,	'Broad absorption line (BAL) quasar with various unusual properties (selected by hand)')
Insert DataConstants values  ('AncillaryTarget1',	'OTBAL',		0x0000000000040000,	'Photometrically-selected overlapping-trough (OT) broad absorption line (BAL) quasar')
Insert DataConstants values  ('AncillaryTarget1',	'PREVBAL',		0x0000000000080000,	'Broad absorption line (BAL) quasar with prior spectrum from SDSS-I/-II')
Insert DataConstants values  ('AncillaryTarget1',	'VARBAL',		0x0000000000100000,	'Photometrically-selected candidate broad absorption line (BAL) quasar')
Insert DataConstants values  ('AncillaryTarget1',	'BRIGHTGAL',		0x0000000000200000,	'Bright (r < 16) galaxies whose spectra were missed by the original SDSS spectroscopic survey')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_AAL',		0x0000000000400000,	'Radio-quiet variable quasar candidates with one absorption system associated with the quasar (v = 5000 km/s in the quasar rest frame)')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_AALS',		0x0000000000800000,	'Radio-quiet variable quasar candidates with multiple absorption systems (associated and/or intervening)')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_IAL',		0x0000000001000000,	'Radio-quiet variable quasar candidates with one absorption system in the intervening space along our line-of-sight (v > 5000 km/s in the quasar rest frame)')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_RADIO',		0x0000000002000000,	'Radio-loud variable quasar candidates with multiple absorption systems (associated and/or intervening)')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_RADIO_AAL',	0x0000000004000000,	'Radio-loud variable quasar candidates with one absorption system associated with the quasar (v = 5000 km/s in the quasar rest frame)')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_RADIO_IAL',	0x0000000008000000,	'Radio-loud variable quasar candidates with one absorption system in the intervening space along our line-of-sight (v > 5000 km/s in the quasar rest frame)')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_NOAALS',		0x0000000010000000,	'Radio-quiet variable quasar candidates with no associated absorption systems and multiple intervening absorption systems')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_GRI',		0x0000000020000000,	'Candidate high-redshift quasar (z > 3.6), selected in gri color space')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_HIZ',		0x0000000040000000,	'Candidate high-redshift quasar (z > 5.6), detected only in SDSS i and z filters.')
Insert DataConstants values  ('AncillaryTarget1',	'QSO_RIZ',		0x0000000080000000,	'Candidate high-redshift quasar (z > 4.5), selected in riz color space')
Insert DataConstants values  ('AncillaryTarget1',	'RQSS_SF',		0x0000000100000000,	'Candidate reddened quasar ( E(B-V)) > 0.5 ), selected from an SDSS primary catalog object matched with FIRST catalog data')
Insert DataConstants values  ('AncillaryTarget1',	'RQSS_SFC',		0x0000000200000000,	'Candidate reddened quasar ( E(B-V)) > 0.5 ), selected from an SDSS child catalog object matched with FIRST catalog data')
Insert DataConstants values  ('AncillaryTarget1',	'RQSS_STM',		0x0000000400000000,	'Candidate reddened quasar (E(B-V)) > 0.5 ), selected from an SDSS primary catalog object matched with 2MASS catalog data')
Insert DataConstants values  ('AncillaryTarget1',	'RQSS_STMC',		0x0000000800000000,	'Candidate reddened quasar (E(B-V)) > 0.5 ), selected from an SDSS child catalog object matched with 2MASS catalog data')
Insert DataConstants values  ('AncillaryTarget1',	'SN_GAL1',		0x0000001000000000,	'Likely host galaxy for an SDSS-II supernova, with the BOSS fiber assigned to the galaxy closest to the supernova''s position')
Insert DataConstants values  ('AncillaryTarget1',	'SN_GAL2',		0x0000002000000000,	'Likely host galaxy for an SDSS-II supernova, with the BOSS fiber assigned to the second-closest galaxy')
Insert DataConstants values  ('AncillaryTarget1',	'SN_GAL3',		0x0000004000000000,	'Likely host galaxy for an SDSS-II supernova, with the BOSS fiber assigned to the third-closest galaxy')
Insert DataConstants values  ('AncillaryTarget1',	'SN_LOC',		0x0000008000000000,	'Likely host galaxy for an SDSS-II supernova, with the BOSS fiber assigned to the position of the original supernova')
Insert DataConstants values  ('AncillaryTarget1',	'SPEC_SN',		0x0000010000000000,	'Likely host galaxy for an SDSS-II supernova, where the original supernova was identified from SDSS spectroscopic data')
Insert DataConstants values  ('AncillaryTarget1',	'SPOKE',		0x0000020000000000,	'Widely-separated binary systems in which both stars are low-mass (spectral class M)')
Insert DataConstants values  ('AncillaryTarget1',	'WHITEDWARF_NEW',	0x0000040000000000,	'White dwarf candidate whose spectrum had not been observed previously by the SDSS')
Insert DataConstants values  ('AncillaryTarget1',	'WHITEDWARF_SDSS',	0x0000080000000000,	'White dwarf candidate with a pre-existing SDSS spectrum')
Insert DataConstants values  ('AncillaryTarget1',	'BRIGHTERL',		0x0000100000000000,	'Bright L dwarf candidate (iPSF < 19.5, iPSF - zPSF) > 1.14)')
Insert DataConstants values  ('AncillaryTarget1',	'BRIGHTERM',		0x0000200000000000,	'Bright M dwarf candidate (iPSF < 19.5, iPSF - zPSF) < 1.14)')
Insert DataConstants values  ('AncillaryTarget1',	'FAINTERL',		0x0000400000000000,	'Faint L dwarf candidate (iPSF > 19.5, iPSF - zPSF) > 1.14)')
Insert DataConstants values  ('AncillaryTarget1',	'FAINTERM',		0x0000800000000000,	'Faint M dwarf candidate (iPSF > 19.5, iPSF - zPSF) < 1.14)')
Insert DataConstants values  ('AncillaryTarget1',	'RED_KG',		0x0001000000000000,	'Giant star in the Milky Way outer halo')
Insert DataConstants values  ('AncillaryTarget1',	'RVTEST',		0x0002000000000000,	'Known giant star selected as a test of radial velocity measurement techniques')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZGRFLAT',		0x0004000000000000,	'Candidate optical counterpart to a Fermi gamma-ray source, within 2" of a CRATES radio source and within a Fermi error ellipse')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZGRQSO',		0x0008000000000000,	'Candidate optical counterpart to a Fermi gamma-ray source, within 2" of a FIRST radio source and within a Fermi error ellipse')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZGX',		0x0010000000000000,	'Candidate optical counterpart to a Fermi gamma-ray source, within 1'' of a ROSAT All-Sky Survey x-ray source and within a Fermi error ellipse, and without typical signs of blazar activity')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZGXQSO',		0x0020000000000000,	'Candidate optical counterpart to a Fermi gamma-ray source, within 1'' of a ROSAT All-Sky Survey x-ray source and within a Fermi error ellipse')
Insert DataConstants values  ('AncillaryTarget1',	'BLAZGXR',		0x0040000000000000,	'Candidate optical counterpart to a Fermi gamma-ray source, with matches in both radio and x-ray wavelengths: within 1'' of a ROSAT All-Sky Survey x-ray source, within 2" of a FIRST radio source, and within a Fermi error ellipse')
Insert DataConstants values  ('AncillaryTarget1',	'BLUE_RADIO',		0x0100000000000000,	'Likely star-forming AGN: blue galaxies that match with FIRST radio sources')
Insert DataConstants values  ('AncillaryTarget1',	'CHANDRAV1',		0x0200000000000000,	'An object with a Chandra match that is likely to be a star-forming galaxy with black hole accretion')
Insert DataConstants values  ('AncillaryTarget1',	'CXOBRIGHT',		0x0400000000000000,	'An object that matches a serendipitous x-ray source from the Chandra Source Catalog, with bright i magnitudes (i < 20.0) and bright 2-8 keV fluxes (f2-8 keV > 5 x 10-14 erg*cm-2*s-1)')
Insert DataConstants values  ('AncillaryTarget1',	'CXOGRIZ',		0x0800000000000000,	'An object that matches a serendipitous x-ray source from the Chandra Source Catalog, with outlier SDSS colors (g - r > 1.2 or r - i > 1.0 or i - z > 1.4)')
Insert DataConstants values  ('AncillaryTarget1',	'CXORED',		0x1000000000000000,	'An object that matches a serendipitous x-ray source from the Chandra Source Catalog, with highly red SDSS colors (g - i > 1.0)')
Insert DataConstants values  ('AncillaryTarget1',	'ELG',			0x2000000000000000,	'Luminous blue galaxy with gPSF < 22.5')
Insert DataConstants values  ('AncillaryTarget1',	'GAL_NEAR_QSO',		0x4000000000000000,	'A galaxy that lies between 0.006'' and 1'' of the line-of-sight for a spectroscopically-confirmed quasar')
Insert DataConstants values  ('AncillaryTarget1',	'MTEMP',		0x80000000000000000,	'Template M-stars observed as a comparison sample in Stripe 82')
GO

-- AncillaryTarget2 (63 values)
Insert DataConstants values  ('AncillaryTarget2',	'',			0x0000000000000000,	'More objects selected as BOSS ancillary targets. Please see the ANCILLARY_TARGET2 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('AncillaryTarget2',	'HIZQSO82',		0x0000000000000001,	'High-redshift quasar candidate selected from color cuts in SDSS ugriz and UKIDSS YJHK photometry')
Insert DataConstants values  ('AncillaryTarget2',	'HIZQSOIR',		0x0000000000000002,	'High-redshift quasar candidate selected from color cuts in SDSS ugriz and UKIDSS YJHK photometry in the Stripe 82 footprint')
Insert DataConstants values  ('AncillaryTarget2',	'KQSO_BOSS',		0x0000000000000004,	'Quasar candidate selected from UKIDSS K-band photometry')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_VAR',		0x0000000000000008,	'Candidate quasar in Stripe 82 survey area, selected from variability alone')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_VAR_FPG',		0x0000000000000010,	'Candidate quasar in Stripe 82 survey area, selected from variability alone')
Insert DataConstants values  ('AncillaryTarget2',	'RADIO_2LOBE_QSO',	0x0000000000000020,	'SDSS point source object near the midpoint of double-lobed objects identified in FIRST Catalogs')
Insert DataConstants values  ('AncillaryTarget2',	'STRIPE82BCG',		0x0000000000000040,	'The brightest cluster member of a galaxy cluster or group identified in the Stripe 82 survey area')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_SUPPZ',		0x0000000000000080,	'Supplemental quasar target (not used in public DR12 data)')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_VAR_SDSS',		0x0000000000000100,	'Supplemental variabile quasar target (not used in public DR12 data)')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_WISE_SUPP',	0x0000000000000200,	'Supplemental WISE-selected quasar target (not used in public DR12 data)')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_WISE_FULL_SKY',	0x0000000000000400,	'Quasar selected from the WISE All-Sky Survey')
Insert DataConstants values  ('AncillaryTarget2',	'XMMSDSS',		0x0000000000000800,	'Hard x-ray-selected AGN from XMM')
Insert DataConstants values  ('AncillaryTarget2',	'IAMASERS',		0x0000000000001000,	'Known or potential maser')
Insert DataConstants values  ('AncillaryTarget2',	'DISKEMITTER_REPEAT',	0x0000000000002000,	'Candidate massive binary black hole pair')
Insert DataConstants values  ('AncillaryTarget2',	'WISE_BOSS_QSO',	0x0000000000004000,	'Quasar identified in the WISE All-Sky Survey')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_XD_KDE_PAIR',	0x0000000000008000,	'Candidate closely-separated quasar pair')
Insert DataConstants values  ('AncillaryTarget2',	'CLUSTER_MEMBER',	0x0000000000010000,	'Member of a galaxy cluster selected from ROSAT All-Sky Survey data')
Insert DataConstants values  ('AncillaryTarget2',	'SPOKE2',		0x0000000000020000,	'Candidate binary pair in which one star is an M dwarf')
Insert DataConstants values  ('AncillaryTarget2',	'FAINT_ELG',		0x0000000000040000,	'Blue star-forming galaxy selected from CFHT-LS photometry')
Insert DataConstants values  ('AncillaryTarget2',	'PTF_GAL',		0x0000000000080000,	'A nearby galaxy identified in PTF imaging with an SDSS counterpart')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_STD',		0x0000000000100000,	'A standard star targeted to improve BOSS spectrophotometric calibration')
Insert DataConstants values  ('AncillaryTarget2',	'HIZ_LRG',		0x0000000000200000,	'A candidate z > 0.6 LRG, selected using a narrower r-i color constraint and observed at higher priority')
Insert DataConstants values  ('AncillaryTarget2',	'LRG_ROUND3',		0x0000000000400000,	'A candidate z > 0.6 LRG, selected using a broader r-i color constraint and observed at lower priority')
Insert DataConstants values  ('AncillaryTarget2',	'WISE_COMPLETE',	0x0000000000800000,	'Galaxy in the same redshift range as the BOSS CMASS sample, but selected with a more relaxed color cut')
Insert DataConstants values  ('AncillaryTarget2',	'TDSS_PILOT',		0x0000000001000000,	'Objects identified from PanSTARRS imaging selected by variability')
Insert DataConstants values  ('AncillaryTarget2',	'SPIDERS_PILOT',	0x0000000002000000,	'Objects identified by cross-matching SDSS imaging with XMM-Newton x-ray imaging')
Insert DataConstants values  ('AncillaryTarget2',	'TDSS_SPIDERS_PILOT',	0x0000000004000000,	'Objects identified by both TDSS and SPIDERS selection criteria')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_VAR_LF',		0x0000000008000000,	'Candidate quasar in stripe 82, selected by color and variability')
Insert DataConstants values  ('AncillaryTarget2',	'TDSS_PILOT_PM',	0x0000000010000000,	'Objects identified using X-ray imaging that has high proper motions')
Insert DataConstants values  ('AncillaryTarget2',	'TDSS_PILOT_SNHOST',	0x0000000020000000,	'Objects identified in PanSTARRS imaging that showed transient behavior in extended objects')
Insert DataConstants values  ('AncillaryTarget2',	'FAINT_HIZ_LRG',	0x0000000040000000,	'Candidate galaxy in the redshift range 0.6 < z 0.9, defined by color cuts')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_EBOSS_W3_ADM',	0x0000000080000000,	'Candidate quasar, defined by one of the complex color cuts recorded in the W3bitmask parameter of the original targeting file')
Insert DataConstants values  ('AncillaryTarget2',	'XMM_PRIME',		0x0000000100000000,	'Candidate AGN identified from the XMM-XXL survey observed at higher priority')
Insert DataConstants values  ('AncillaryTarget2',	'XMM_SECOND',		0x0000000200000000,	'Candidate AGN identified from the XMM-XXL survey observed at lower priority')
Insert DataConstants values  ('AncillaryTarget2',	'SEQUELS_ELG',		0x0000000400000000,	'Emission-line galaxy targeted by the SEQUELS program')	
Insert DataConstants values  ('AncillaryTarget2',	'GES',			0x0000000800000000,	'Star observed by the Gaia/ESO Survey (GES)')
Insert DataConstants values  ('AncillaryTarget2',	'SEGUE1',		0x0000001000000000,	'Star observed by the prior SDSS spectroscopic SEGUE-1 survey')
Insert DataConstants values  ('AncillaryTarget2',	'SEGUE2',		0x0000002000000000,	'Star observed by SEGUE-2')
Insert DataConstants values  ('AncillaryTarget2',	'SDSSFILLER',		0x0000004000000000,	'Star in the GES survey area, targeted from prior SDSS photometry')
Insert DataConstants values  ('AncillaryTarget2',	'SEQUELS_ELG_LOWP',	0x0000008000000000,	'Emission-line galaxy targeted by the SEQUELS program at lower priority')	
Insert DataConstants values  ('AncillaryTarget2',	'25ORI_WISE',		0x0000010000000000,	'WISE-selected target near the star 25 Ori')
Insert DataConstants values  ('AncillaryTarget2',	'25ORI_WISE_W3',	0x0000020000000000,	'WISE-selected target near the star 25 Ori, selected from data in the W3 band')	
Insert DataConstants values  ('AncillaryTarget2',	'KOEKAP_STAR',		0x0000040000000000,	'WISE-selected source in the star-forming region Kappa Ori, selected from WISE infrared excess')
Insert DataConstants values  ('AncillaryTarget2',	'KOE2023_STAR',		0x0000080000000000,	'WISE-selected source in the star-forming region NGC 2023, selected from WISE infrared excess')
Insert DataConstants values  ('AncillaryTarget2',	'KOE2068_STAR',		0x0000100000000000,	'WISE-selected source in the star-forming region NGC 2068, selected from WISE infrared excess')
Insert DataConstants values  ('AncillaryTarget2',	'KOE2023BSTAR',		0x0000200000000000,	'Other WISE-selected source in the star-forming region NGC 2023')
Insert DataConstants values  ('AncillaryTarget2',	'KOE2068BSTAR',		0x0000400000000000,	'Other WISE-selected source in the star-forming region NGC 2068')
Insert DataConstants values  ('AncillaryTarget2',	'KOEKAPBSTAR',		0x0000800000000000,	'Other WISE-selected source in the star-forming region Kappa Ori')
Insert DataConstants values  ('AncillaryTarget2',	'COROTGESAPOG',		0x0001000000000000,	'Star observed by both the CoRoT survey and by APOGEE')
Insert DataConstants values  ('AncillaryTarget2',	'COROTGES',		0x0002000000000000,	'Star observed by both CoRoT and GES')
Insert DataConstants values  ('AncillaryTarget2',	'APOGEE',		0x0004000000000000,	'Star in the CoRoT survey area, not observed by CoRoT but with an APOGEE spectrum')
Insert DataConstants values  ('AncillaryTarget2',	'2MASSFILL',		0x0008000000000000,	'Star in the CoRoT survey area targeted from 2MASS photometry')
Insert DataConstants values  ('AncillaryTarget2',	'TAU_STAR',		0x0010000000000000,	'Spitzer-selected source in the Taurus Heiles 2 molecular cloud')
Insert DataConstants values  ('AncillaryTarget2',	'SEQUELS_TARGET',	0x0020000000000000,	'A target from the SEQUELS program (no longer used, replaced by EBOSS_TARGET0 flag)')
Insert DataConstants values  ('AncillaryTarget2',	'RM_TILE1',		0x0040000000000000,	'AGN selected for reverberation mapping study at high priority')
Insert DataConstants values  ('AncillaryTarget2',	'RM_TILE2',		0x0080000000000000,	'AGN selected for reverberation mapping study at lower priority')
Insert DataConstants values  ('AncillaryTarget2',	'QSO_DEEP',		0x0100000000000000,	'Candidate quasar selected by time variability')
Insert DataConstants values  ('AncillaryTarget2',	'LBG',			0x0200000000000000,	'Candidate Lyman-break galaxy selected by color')
Insert DataConstants values  ('AncillaryTarget2',	'ELAIS_N1_LOFAR',	0x0400000000000000,	'LOFAR source selected with RMS noise criteria')
Insert DataConstants values  ('AncillaryTarget2',	'ELAIS_N1_FIRST',	0x0800000000000000,	'Source detected in the FIRST radio catalog')
Insert DataConstants values  ('AncillaryTarget2',	'ELAIS_N1_GMRT_GARN',	0x1000000000000000,	'Source identified from deeper GMRT radio data')
Insert DataConstants values  ('AncillaryTarget2',	'ELAIS_N1_GMRT_TAYLOR',	0x2000000000000000,	'Fainter source identified from deeper GMRT radio data')
Insert DataConstants values  ('AncillaryTarget2',	'ELAIS_N1_JVLA',	0x4000000000000000,	'Very faint source detected in JVLA radio data')
GO



-- ApogeeTarget1 (32 values)
Insert DataConstants values  ('ApogeeTarget1',	'',			0x0000000000000000,	'1/2 APOGEE target bits (New for DR10). Please see the APOGEE_TARGET1 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_FAINT',		0x0000000000000001,	'Star selected in faint bin of cohort')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_MEDIUM',	0x0000000000000002,	'Star selected in medium bin of cohort')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_BRIGHT',	0x0000000000000004,	'Star selected in bright bin of cohort')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_IRAC_DERED',	0x0000000000000008,	'Star selected using RJCE-IRAC dereddening')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_WISE_DERED',	0x0000000000000010,	'Star selected using RJCE-WISE dereddening')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_SFD_DERED',	0x0000000000000020,	'Selected using SFD E(B-V) dereddening')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_NO_DERED',	0x0000000000000040,	'Star selected using no dereddening')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_WASH_GIANT',	0x0000000000000080,	'Selected as giant star via Washington+DDO51 photometry')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_WASH_DWARF',	0x0000000000000100,	'Selected as dwarf star via Washington+DDO51 photometry')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_SCI_CLUSTER',	0x0000000000000200,	'Probable stellar cluster member')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_EXTENDED',	0x0000000000000400,	'Extended object')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_SHORT',		0x0000000000000800,	'Short cohort target star')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_INTERMEDIATE',	0x0000000000001000,	'Intermediate cohort target star')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_LONG',		0x0000000000002000,	'Long cohort target star')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_SERENDIPITOUS',	0x0000000000008000,	'Serendipitous interesting target to reobserve')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_FIRST_LIGHT',	0x0000000000010000,	'"First Light" cluster target')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_ANCILLARY',	0x0000000000020000,	'An ancillary program target (particular program specified in other bits, see below)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_M31_CLUSTER',	0x0000000000040000,	'M31 cluster target (ancillary)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_MDWARF',	0x0000000000080000,	'M dwarf star selected for RV/metallicity program (ancillary)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_HIRES',		0x0000000000100000,	'Star with optical hi-res spectra (ancillary)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_OLD_STAR',	0x0000000000200000,	'Selected as old star (ancillary)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_DISK_RED_GIANT',0x0000000000400000,	'Disk red giant star (ancillary)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_KEPLER_EB',	0x0000000000800000,	'Eclipsing binary star from Kepler (ancillary)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_GC_PAL1',	0x0000000001000000,	'Star in Pal1 globular cluster (ancillary)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_MASSIVE_STAR',	0x0000000002000000,	'Massive star (ancillary)')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_SGR_DSPH',	0x0000000004000000,	'Sagittarius dwarf galaxy member')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_KEPLER_SEISMO',	0x0000000008000000,	'Kepler astroseismology program target star')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_KEPLER_HOST',	0x0000000010000000,	'Kepler planet-host program target star')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_FAINT_EXTRA',	0x0000000020000000,	'Selected as faint target for low target density field')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_SEGUE_OVERLAP',	0x0000000040000000,	'Selected because of overlap with SEGUE survey')
Insert DataConstants values  ('ApogeeTarget1',	'APOGEE_CHECKED',	0x0000000080000000,	'This target has been checked.')
GO

-- ApogeeTarget2 (14 values)
Insert DataConstants values  ('ApogeeTarget2',	'',				0x0000000000000000,	'2/2 APOGEE target bits (New for DR10). Please see the APOGEE_TARGET2 entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_FLUX_STANDARD',		0x0000000000000002,	'Flux standard')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_STANDARD_STAR',		0x0000000000000004,	'Stellar abundance and/or parameters standard')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_RV_STANDARD',		0x0000000000000008,	'Stellar radial velocity standard')
Insert DataConstants values  ('ApogeeTarget2',	'SKY',				0x0000000000000010,	'Blank sky position')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_TELLURIC',		0x0000000000000200,	'Hot (telluric) standard star')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_CALIB_CLUSTER',		0x0000000000000400,	'Known calibration cluster member star')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_BULGE_GIANT',		0x0000000000000800,	'Probable giant star in Galactic bulge')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_BULGE_SUPER_GIANT',	0x0000000000001000,	'Probable supergiant star in Galactic bulge')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_EMBEDDEDCLUSTER_STAR',	0x0000000000002000,	'Young embedded cluster member (ancillary)')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_LONGBAR',		0x0000000000004000,	'Probable RC star in long bar (ancillary)')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_EMISSION_STAR',		0x0000000000008000,	'Emission-line star (ancillary)')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_KEPLER_COOLDWARF',	0x0000000000010000,	'Kepler cool dwarf or subgiant (ancillary)')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_MIRCLUSTER_STAR',	0x0000000000020000,	'MIR-detected candidate cluster member (ancillary)')
Insert DataConstants values  ('ApogeeTarget2',	'APOGEE_CHECKED',		0x0000000080000000,	'This bitmask is nonzero.')
GO



-- ApogeeStarFlag (12 values)
Insert DataConstants values  ('ApogeeStarFlag',	'',				0x0000000000000000,	'APOGEE star level bitmask flag. Please see the APOGEE_STARFLAG entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ApogeeStarFlag',	'BAD_PIXELS',			0x0000000000000001,	'Spectrum has many bad pixels (>40%): BAD')
Insert DataConstants values  ('ApogeeStarFlag',	'COMMISSIONING',		0x0000000000000002,	'Commissioning data (MJD<55761), non-standard configuration, poor LSF: WARN')
Insert DataConstants values  ('ApogeeStarFlag',	'BRIGHT_NEIGHBOR',		0x0000000000000004,	'Star has neighbor more than 10 times brighter: WARN')
Insert DataConstants values  ('ApogeeStarFlag',	'VERY_BRIGHT_NEIGHBOR',		0x0000000000000008,	'Star has neighbor more than 100 times brighter: BAD')
Insert DataConstants values  ('ApogeeStarFlag',	'LOW_SNR',			0x0000000000000010,	'Spectrum has low S/N (S/N<5): BAD')
Insert DataConstants values  ('ApogeeStarFlag',	'PERSIST_HIGH',			0x0000000000000200,	'Spectrum has significant number (>20%) of pixels in high persistence region: WARN')
Insert DataConstants values  ('ApogeeStarFlag',	'PERSIST_MED',			0x0000000000000400,	'Spectrum has significant number (>20%) of pixels in medium persistence region: WARN')
Insert DataConstants values  ('ApogeeStarFlag',	'PERSIST_LOW',			0x0000000000000800,	'Spectrum has significant number (>20%) of pixels in low persistence region: WARN')
Insert DataConstants values  ('ApogeeStarFlag',	'PERSIST_JUMP_POS',		0x0000000000001000,	'Spectrum show obvious positive jump in blue chip: WARN')
Insert DataConstants values  ('ApogeeStarFlag',	'PERSIST_JUMP_NEG',		0x0000000000002000,	'Spectrum show obvious negative jump in blue chip: WARN')
Insert DataConstants values  ('ApogeeStarFlag',	'SUSPECT_RV_COMBINATION',	0x0000000000010000,	'WARNING: RVs from synthetic template differ significantly from those from combined template')
Insert DataConstants values  ('ApogeeStarFlag',	'SUSPECT_BROAD_LINES',		0x0000000000020000,	'WARNING: cross-correlation peak with template significantly broader than autocorrelation of template')
GO

-- ApogeeAspcapFlag (26 values)
Insert DataConstants values  ('ApogeeAspcapFlag',	'',			0x0000000000000000,	'APOGEE ASPCAP bitmask flag. Please see the APOGEE_ASPCAPFLAG entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ApogeeAspcapFlag',	'TEFF_WARN',		0x0000000000000001,	'WARNING on effective temperature (see PARAMFLAG[0] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'LOGG_WARN',		0x0000000000000002,	'WARNING on log g (see PARAMFLAG[1] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'VMICRO_WARN',		0x0000000000000004,	'WARNING on vmicro (see PARAMFLAG[2] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'METALS_WARN',		0x0000000000000008,	'WARNING on metals (see PARAMFLAG[3] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'ALPHAFE_WARN',		0x0000000000000010,	'WARNING on [alpha/Fe] (see PARAMFLAG[4] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'CFE_WARN',		0x0000000000000020,	'WARNING on [C/Fe] (see PARAMFLAG[5] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'NFE_WARN',		0x0000000000000040,	'WARNING on [N/Fe] (see PARAMFLAG[6] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'STAR_WARN',		0x0000000000000080,	'WARNING overall for star: set if any of TEFF, LOGG, CHI2, COLORTE, ROTATION, SN warn are set')
Insert DataConstants values  ('ApogeeAspcapFlag',	'CHI2_WARN',		0x0000000000000100,	'Somewhat high chi^2 for derived parameters (WARN)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'COLORTE_WARN',		0x0000000000000200,	'Somewhat odd effective temperature given dereddened color (WARN)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'ROTATION_WARN',	0x0000000000000400,	'Spectrum has broad lines, with possible bad effects (WARN)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'SN_WARN',		0x0000000000000800,	'Spectrum has lower S/N than desired (WARN)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'TEFF_BAD',		0x0000000000010000,	'BAD effective temperature (see PARAMFLAG[0] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'LOGG_BAD',		0x0000000000020000,	'BAD log g (see PARAMFLAG[1] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'VMICRO_BAD',		0x0000000000040000,	'BAD vmicro (see PARAMFLAG[2] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'METALS_BAD',		0x0000000000080000,	'BAD metals (see PARAMFLAG[3] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'ALPHAFE_BAD',		0x0000000000100000,	'BAD [alpha/Fe] (see PARAMFLAG[4] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'CFE_BAD',		0x0000000000200000,	'BAD [C/Fe] (see PARAMFLAG[5] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'NFE_BAD',		0x0000000000400000,	'BAD [N/Fe] (see PARAMFLAG[6] for details)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'STAR_BAD',		0x0000000000800000,	'BAD overall for star: set if any of TEFF, LOGG, CHI2, COLORTE, ROTATION, SN error are set, or any parameter is near grid edge (GRIDEDGE_BAD is set in any PARAMFLAG)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'CHI2_BAD',		0x0000000001000000,	'High chi^2 for derived parameters(BAD)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'COLORTE_BAD',		0x0000000002000000,	'Odd effective temperature given dereddened color(BAD)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'ROTATION_BAD',		0x0000000004000000,	'Spectrum has broad lines, with likely bad effects(BAD)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'SN_BAD',		0x0000000008000000,	'Spectrum has lower S/N than required(BAD)')
Insert DataConstants values  ('ApogeeAspcapFlag',	'NO_ASPCAP_RESULT',	0x0000000080000000,	'No ASPCAP result	')
GO

-- ApogeeParamFlag (7 values)
Insert DataConstants values  ('ApogeeParamFlag',	'',			0x0000000000000000,	'APOGEE parameter/element bitmask flag. Please see the APOGEE_PARAMFLAG entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ApogeeParamFlag',	'GRIDEDGE_BAD',		0x0000000000000001,	'Parameter within 1/8 grid spacing of grid edge')
Insert DataConstants values  ('ApogeeParamFlag',	'CALRANGE_BAD',		0x0000000000000002,	'Parameter outside valid range of calibration determination')
Insert DataConstants values  ('ApogeeParamFlag',	'OTHER_BAD',		0x0000000000000004,	'Other error condition')
Insert DataConstants values  ('ApogeeParamFlag',	'GRIDEDGE_WARN',	0x0000000000000100,	'Parameter within 1/2 grid spacing of grid edge')
Insert DataConstants values  ('ApogeeParamFlag',	'CALRANGE_WARN',	0x0000000000000200,	'Parameter in possibly unreliable range of calibration determination')
Insert DataConstants values  ('ApogeeParamFlag',	'OTHER_WARN',		0x0000000000000400,	'Other warning condition')
Insert DataConstants values  ('ApogeeParamFlag',	'PARAM_FIXED',		0x0000000000010000,	'Parameter set at fixed value, not fit')
GO

-- ApogeeExtraTarg (5 values)
Insert DataConstants values  ('ApogeeExtraTarg',	'',			0x0000000000000000,	'APOGEE Extra Targeting Bits (new for DR12). This bit mask provides a convenient way to select only main survey targets (EXTRATARG==0) and identifies the main classes of other targets. Please see the APOGEE_EXTRATARG entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ApogeeExtraTarg',        'NOT_MAIN',		0x0000000000000001,	'Not main survey target.')
Insert DataConstants values  ('ApogeeExtraTarg',        'COMMISSIONING',	0x0000000000000002,	'Commissioning data.')
Insert DataConstants values  ('ApogeeExtraTarg',        'TELLURIC',		0x0000000000000004,	'Telluric target.')
Insert DataConstants values  ('ApogeeExtraTarg',        'APO1M',		0x0000000000000008,	'1m observation.')
Insert DataConstants values  ('ApogeeExtraTarg',        'DUPLICATE',		0x0000000000000010,	'Duplicate observation.')

-- EbossTarget0 (23 values)
Insert DataConstants values  ('EbossTarget0',	'',			0x0000000000000000,	'An object whose EBOSS_TARGET0 value includes one or more of the bitmasks in the following table was targeted for spectroscopy as part of this ancillary target program.')
Insert DataConstants values  ('EbossTarget0',	'DO_NOT_OBSERVE',	0x0000000000000001,	'Do not put a fiber on this object')
Insert DataConstants values  ('EbossTarget0',	'LRG_IZW',		0x0000000000000002,	'LRG selection in i/z/W plane (11,778 fibers)')
Insert DataConstants values  ('EbossTarget0',	'LRG_RIW',		0x0000000000000004,	'LRG selection in r/i/W plane with (i-z) cut (11,687 fibers)')
Insert DataConstants values  ('EbossTarget0',	'QSO_EBOSS_CORE',	0x0000000000000400,	'QSOs in XDQSOz+WISE selection for clustering (19,461 fibers)')
Insert DataConstants values  ('EbossTarget0',	'QSO_PTF',	  	0x0000000000000800,	'QSOs with variability in PTF imaging (13,232 fibers)')
Insert DataConstants values  ('EbossTarget0',	'QSO_REOBS',		0x0000000000001000,	'QSOs from BOSS to be reobserved (1,368 fibers)')
Insert DataConstants values  ('EbossTarget0',	'QSO_EBOSS_KDE',		0x0000000000002000,	'KDE-selected QSOs (SEQUELS only) (11,843)')
Insert DataConstants values  ('EbossTarget0',	'QSO_EBOSS_FIRST',	0x0000000000004000,	'Objects with FIRST radio matches (293 fibers)')
Insert DataConstants values  ('EbossTarget0',	'QSO_BAD_BOSS',		0x0000000000008000,	'QSOs from BOSS with bad spectra (59)')
Insert DataConstants values  ('EbossTarget0',	'QSO_BOSS_TARGET',	0x0000000000010000,	'Known TARGETS from BOSS with spectra (59 fibers)')
Insert DataConstants values  ('EbossTarget0',	'QSO_SDSS_TARGET',	0x0000000000020000,	'Known TARGETS from SDSS with spectra')
Insert DataConstants values  ('EbossTarget0',	'QSO_KNOWN',		0x0000000000040000,	'Known QSOs from previous surveys')
Insert DataConstants values  ('EbossTarget0',	'DR9_CALIB_TARGET',	0x0000000000080000,	'Target found in DR9-calibrated imaging (28,602 fibers)')
Insert DataConstants values  ('EbossTarget0',	'SPIDERS_RASS_AGN',	0x0000000000100000,	'RASS AGN sources (162 fibers)')
Insert DataConstants values  ('EbossTarget0',	'SPIDERS_RASS_CLUS',	0x0000000000200000,	'RASS cluster sources')
Insert DataConstants values  ('EbossTarget0',	'TDSS_A',		0x0000000040000000,	'Main PanSTARRS selection for TDSS (9,418 fibers)')
Insert DataConstants values  ('EbossTarget0',	'TDSS_FES_DE',		0x0000000080000000,	'TDSS Few epoch spectroscopy (42 fibers)')
Insert DataConstants values  ('EbossTarget0',	'TDSS_FES_DWARFC',	0x0000000100000000,	'TDSS Few epoch spectroscopy (19 fibers)')
Insert DataConstants values  ('EbossTarget0',	'TDSS_FES_NQHISN',	0x0000000200000000,	'TDSS Few epoch spectroscopy (74 fibers)')
Insert DataConstants values  ('EbossTarget0',	'TDSS_FES_MGII',		0x0000000400000000,	'TDSS Few epoch spectroscopy (1 target)')
Insert DataConstants values  ('EbossTarget0',	'TDSS_FES_VARBAL',	0x0000000800000000,	'TDSS Few epoch spectroscopy (62 fibers)')
Insert DataConstants values  ('EbossTarget0',	'SEQUELS_PTF_VARIABLE',	0x0000010000000000,	'Variability objects from PTF (701 fibers)')
Insert DataConstants values  ('EbossTarget0',	'SEQUELS_COLLIDED',	0x0000020000000000,	'Collided galaxies from BOSS')


-- SpeczWarning 32 (8 values)
Insert DataConstants values  ('SpeczWarning',	'',   	0,	'Spectra with zWarning equal to zero have no known problems. If MANY_OUTLIERS is set, that usually indicates a high signal-to-noise spectrum or broad emission lines in a galaxy; that is, MANY_OUTLIERS only rarely signifies a real error. Please see the ZWARNING entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('SpeczWarning',	'OK',   			0x0000000000000000, 'No warnings.')
Insert DataConstants values  ('SpeczWarning',	'SKY',   			0x0000000000000001, 'sky fiber')
Insert DataConstants values  ('SpeczWarning',	'LITTLE_COVERAGE',   		0x0000000000000002, 'too little wavelength coverage (WCOVERAGE < 0.18)')
Insert DataConstants values  ('SpeczWarning',	'SMALL_DELTA_CHI2',   		0x0000000000000004, 'chi-squared of best fit is too close to that of second best (< 0.01 in reduced chi-sqaured)')
Insert DataConstants values  ('SpeczWarning',	'NEGATIVE_MODEL',   		0x0000000000000008, 'synthetic spectrum is negative (only set for stars and QSOs)')
Insert DataConstants values  ('SpeczWarning',	'MANY_OUTLIERS',   		0x0000000000000010, 'fraction of points more than 5 sigma away from best model is too large (> 0.05)')
Insert DataConstants values  ('SpeczWarning',	'Z_FITLIMIT',   		0x0000000000000020, 'chi-squared minimum at edge of the redshift fitting range (Z_ERR set to -1)')
Insert DataConstants values  ('SpeczWarning',	'NEGATIVE_EMISSION',   		0x0000000000000040, 'a QSO line exhibits negative emission, triggered only in QSO spectra, if C_IV, C_III, Mg_II, H_beta, or H_alpha has LINEAREA + 3 * LINEAREA_ERR < 0')
Insert DataConstants values  ('SpeczWarning',	'UNPLUGGED',   			0x0000000000000080, 'the fiber was unplugged, so no spectrum obtained')
GO


-- SpecPixMask (26 values)
Insert DataConstants values  ('SpecPixMask',	'',			0x0000000000000000,	'Each of these bits is set for each fiber and each pixel. 0-15 indicate something about the fiber; 16-31 indicate something about that particular pixel.')
Insert DataConstants values  ('SpecPixMask',	'NOPLUG',		0x0000000000000001,	'Fiber not listed in plugmap file')
Insert DataConstants values  ('SpecPixMask',	'BADTRACE',		0x0000000000000002,	'Bad trace from routine TRACE320CRUDE')
Insert DataConstants values  ('SpecPixMask',	'BADFLAT',		0x0000000000000004,	'Low counts in fiberflat')
Insert DataConstants values  ('SpecPixMask',	'BADARC',		0x0000000000000008,	'Bad arc solution')
Insert DataConstants values  ('SpecPixMask',	'MANYBADCOLUMNS',	0x0000000000000010,	'More than 10% of pixels are bad columns')
Insert DataConstants values  ('SpecPixMask',	'MANYREJECTED',		0x0000000000000020,	'More than 10% of pixels are rejected in extraction')
Insert DataConstants values  ('SpecPixMask',	'LARGESHIFT',		0x0000000000000040,	'Large spatial shift between flat and object position')
Insert DataConstants values  ('SpecPixMask',	'BADSKYFIBER',		0x0000000000000080,	'Sky fiber shows extreme residuals')
Insert DataConstants values  ('SpecPixMask',	'NEARWHOPPER',		0x0000000000000100,	'Within 2 fibers of a whopping fiber (exclusive)')
Insert DataConstants values  ('SpecPixMask',	'WHOPPER',		0x0000000000000200,	'Whopping fiber, with a very bright source.')
Insert DataConstants values  ('SpecPixMask',	'SMEARIMAGE',		0x0000000000000400,	'Smear available for red and blue cameras')
Insert DataConstants values  ('SpecPixMask',	'SMEARHIGHSN',		0x0000000000000800,	'S/N sufficient for full smear fit')
Insert DataConstants values  ('SpecPixMask',	'SMEARMEDSN',		0x0000000000001000,	'S/N only sufficient for scaled median fit')
Insert DataConstants values  ('SpecPixMask',	'NEARBADPIXEL',		0x0000000000010000,	'Bad pixel within 3 pixels of trace.')
Insert DataConstants values  ('SpecPixMask',	'LOWFLAT',		0x0000000000020000,	'Flat field less than 0.5')
Insert DataConstants values  ('SpecPixMask',	'FULLREJECT',		0x0000000000040000,	'Pixel fully rejected in extraction (INVVAR=0)')
Insert DataConstants values  ('SpecPixMask',	'PARTIALREJECT',	0x0000000000080000,	'Some pixels rejected in extraction')
Insert DataConstants values  ('SpecPixMask',	'SCATTEREDLIGHT',	0x0000000000100000,	'Scattered light significant')
Insert DataConstants values  ('SpecPixMask',	'CROSSTALK',		0x0000000000200000,	'Cross-talk significant')
Insert DataConstants values  ('SpecPixMask',	'NOSKY',		0x0000000000400000,	'Sky level unknown at this wavelength (INVVAR=0)')
Insert DataConstants values  ('SpecPixMask',	'BRIGHTSKY',		0x0000000000800000,	'Sky level > flux + 10*(flux_err) AND sky > 1.25 * median(sky,99 pixels)')
Insert DataConstants values  ('SpecPixMask',	'NODATA',		0x0000000001000000,	'No data available in combine B-spline (INVVAR=0)')
Insert DataConstants values  ('SpecPixMask',	'COMBINEREJ',		0x0000000002000000,	'Rejected in combine B-spline')
Insert DataConstants values  ('SpecPixMask',	'BADFLUXFACTOR',	0x0000000004000000,	'Low flux-calibration or flux-correction factor')
Insert DataConstants values  ('SpecPixMask',	'BADSKYCHI',		0x0000000008000000,	'Relative ?2 > 3 in sky residuals at this wavelength')
Insert DataConstants values  ('SpecPixMask',	'REDMONSTER',		0x0000000010000000,	'Contiguous region of bad ?2 in sky residuals (with threshhold of relative ?2 > 3).')
GO



-- sdssvBossTarget0 (63 values)
Insert DataConstants values  ('sdssvBossTarget0',	'SKY',						0x0000000000000001,	'empty sky fiber for calibrating night sky emission')
Insert DataConstants values  ('sdssvBossTarget0',	'OPS_STD_EBOSS',				0x0000000000000002,	'spectrophotometric flux standard from eBOSS survey. Includes BOSS F dwarf flux standard selected at narrower magnitude range and wider color range,  QSOs, and White Dwarfs')
Insert DataConstants values  ('sdssvBossTarget0',	'OPS_STD_BOSS',					0x0000000000000004,	'spectrophotometric flux standard selected via Gaia color-mag cuts designed to emulate prior SDSS-photometry based selection of F dwarf flux standards')
Insert DataConstants values  ('sdssvBossTarget0',	'OPS_STD_BOSS-RED',				0x0000000000000008,	'spectrophotometric flux standard selected via de-reddened Gaia-2MASS color/mag/reduced proper motion cuts (designed to provide F star flux standards even in highly reddened regions)')
Insert DataConstants values  ('sdssvBossTarget0',	'OPS_STD_BOSS_TIC',				0x0000000000000010,	'spectrophotometric flux standard F-dwarf targets selected from the TIC catalogue, based on Teff and logg, plus GAIA magnitudes')
Insert DataConstants values  ('sdssvBossTarget0',	'OPS_SKY_BOSS-NOTDB',				0x0000000000000020,	'empty sky fiber chosen by platedesign pipeline')
Insert DataConstants values  ('sdssvBossTarget0',	'OPS_SKY_2MASS',				0x0000000000000040,	'empty sky fiber obtained with SDSS-IV Apogee method')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE1',					0x0000000000000080,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_RM_CORE',					0x0000000000000100,	'Selected as a target of Black Hole Mappers (BHM) Reverberation Mapping (RM) sample  targets selected by  a QSO classification and photoz regression algorithm based on multi-dimensional Skew-t functions.')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_RM_KNOWN-SPEC',				0x0000000000000200,	'Selected as a target of Black Hole Mappers (BHM) Reverberation Mapping (RM) sample  targets selected because they have existing spectroscopic confirmations')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_RM_VAR',					0x0000000000000400,	'Selected as a target of Black Hole Mappers (BHM) Reverberation Mapping (RM) sample  targets selected by optical variability (DES, PS1) properties')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_RM_ANCILLARY',				0x0000000000000800,	'Selected as a target of Black Hole Mappers (BHM) Reverberation Mapping (RM) sample  targets selected by WISE colours or by the XDQSO algorithm')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE2',					0x0000000000001000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE3',					0x0000000000002000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_AQMES_MED',				0x0000000000004000,	'Selected as a target of BHMs Apache Point Observatory Quasar Multi-Epoch Survey (AQMES) Medium cadence sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_AQMES_MED-FAINT',				0x0000000000008000,	'Selected as a target of BHMs AQMES Medium cadence faint object sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_AQMES_WIDE3',				0x0000000000010000,	'Selected as a target of BHMs AQMES wide 3-epoch cadence sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_AQMES_WIDE3-FAINT',			0x0000000000020000,	'Selected as a target of BHMs AQMES wide 3-epoch cadence faint object sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_AQMES_WIDE2',				0x0000000000040000,	'Selected as a target of BHMs AQMES wide 2-epoch cadence sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_AQMES_WIDE2-FAINT',			0x0000000000080000,	'Selected as a target of BHMs AQMES wide 2-epoch cadence faint object sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_AQMES_BONUS-DARK',				0x0000000000100000,	'Selected as a target of BHMs AQMES bonus dark-time sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_AQMES_BONUS-BRIGHT',			0x0000000000200000,	'Selected as a target of BHMs AQMES bonus bright-time sample')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE4',					0x0000000000400000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE5',					0x0000000000800000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_SPIDERS_CLUSTERS-EFEDS-SDSS-REDMAPPER',	0x0000000001000000,	'Selected as a target of BHMs SPIDERS clusters eFEDS RedMapper sample using SDSS photometry')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_SPIDERS_CLUSTERS-EFEDS-HSC-REDMAPPER',	0x0000000002000000,	'Selected as a target of BHMs SPIDERS clusters eFEDS RedMapper sample using HyperSuprimeCam photometry')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_SPIDERS_CLUSTERS-EFEDS-LS-REDMAPPER',	0x0000000004000000,	'Selected as a target of BHMs SPIDERS clusters eFEDS RedMapper sample using LegacySurvey photometry')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_SPIDERS_CLUSTERS-EFEDS-EROSITA',		0x0000000008000000,	'Selected as a target of BHMs SPIDERS clusters eFEDS eROSITA sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_SPIDERS_AGN-EFEDS',			0x0000000010000000,	'Selected as a target of BHMs SPIDERS AGN eFEDS sample')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE6',					0x0000000020000000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE7',					0x0000000040000000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_CSC_BOSS-DARK',				0x0000000080000000,	'Selected as a target of BHMs Chandra Source Catalog (CSC) dark-time sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_CSC_BOSS-BRIGHT',				0x0000000100000000,	'Selected as a target of BHMs Chandra Source Catalog (CSC) bright-time sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_GUA_DARK',					0x0000000200000000,	'Selected as a target of BHMs Gaia/UnWISE AGN dark-time sample')
Insert DataConstants values  ('sdssvBossTarget0',	'BHM_GUA_BRIGHT',				0x0000000400000000,	'Selected as a target of BHMs Gaia/UnWISE AGN brght-time sample')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE8',					0x0000000800000000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE9',					0x0000001000000000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_SNC_100PC',				0x0000002000000000,	'Selected as a target of the MWMs Solar Neighborhood Census (SNC) 100pc sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CB_300PC',					0x0000004000000000,	'Selected as a target of the MWMs Compact Binary (CB) 300pc sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CB_CVCANDIDATES',				0x0000008000000000,	'Selected as a target of the MWMs CB Cataclysmic Variable candidate sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CB_GAIAGALEX',				0x0000010000000000,	'Selected as a target of the MWMs CB Gaia-Galex sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CB_UVEX1',					0x0000020000000000,	'Selected as a target of the MWMs CB UV-selected sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_WD',					0x0000040000000000,	'Selected as a target of the MWMs White Dwarf sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_SNC_250PC',				0x0000080000000000,	'Selected as a target of the MWMs SNC 250pc sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CV_FAINT',					0x0000100000000000,	'Selected as a target of the MWMs faint Cataclysmic variable (CV) sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CV_GREY',					0x0000200000000000,	'Selected as a target of the MWMs grey-time Cataclysmic variable (CV) sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CV_BRIGHT',				0x0000400000000000,	'Selected as a target of the MWMs bright CV sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_HALO_BB',					0x0000800000000000,	'Selected as a target of the MWMs Halo Star Best & Brightest sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_HALO_SM',					0x0001000000000000,	'Selected as a target of the MWMs Halo Star SM sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_YSO_S1',					0x0002000000000000,	'Selected as a target of the MWMs YSO Optically visible Class I/II sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_YSO_S3',					0x0004000000000000,	'Selected as a target of the MWMs YSO Optically variable Class III sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_YSO_CLUSTER',				0x0008000000000000,	'Selected as a target of the MWMs YSO Clustering selected sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_OB',					0x0010000000000000,	'Selected as a target of the MWMs OB star sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_OB_CEPHEIDS',				0x0020000000000000,	'Selected as a target of the MWMs OB Cepheid star sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_LEGACY_IR2OPT',				0x0040000000000000,	'Selected as a target of the MWMs APOGEE legacy observations')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CB_UVEX2',					0x0080000000000000,	'Selected as a target of the MWMs CB UV-selected sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CB_UVEX3',					0x0100000000000000,	'Selected as a target of the MWMs CB UV-selected sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CB_UVEX4',					0x0200000000000000,	'Selected as a target of the MWMs CB UV-selected sample')
Insert DataConstants values  ('sdssvBossTarget0',	'MWM_CB_UVEX5',					0x0400000000000000,	'Selected as a target of the MWMs CB UV-selected sample')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE10',					0x0800000000000000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE11',					0x1000000000000000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE12',					0x2000000000000000,	'')
Insert DataConstants values  ('sdssvBossTarget0',	'SPARE13',					0x4000000000000000,	'')



--plPlugMap HoleType
INSERT DataConstants VALUES('HoleType',	'',			0,	'plPlugMap hole type (SDSS-II).')
INSERT DataConstants VALUES ('HoleType',	'OBJECT',	0,	'')
INSERT DataConstants VALUES ('HoleType',	'COHERENT_SKY',	1,	'')
INSERT DataConstants VALUES ('HoleType',	'GUIDE',	2,	'')
INSERT DataConstants VALUES ('HoleType',	'LIGHT_TRAP',	3,	'')
INSERT DataConstants VALUES ('HoleType',	'ALIGNMENT',	4,	'')
INSERT DataConstants VALUES ('HoleType',	'QUALITY',	5,	'')
GO
--

--plPlugMap ObjType
INSERT DataConstants VALUES('SourceType',	'',			0,	'plPlugMap object type (SDSS-II).')
INSERT DataConstants VALUES('SourceType',	'GALAXY',		0,	'')
INSERT DataConstants VALUES('SourceType',	'QSO',			1,	'')
INSERT DataConstants VALUES('SourceType',	'STAR_BHB',		2,	'')
INSERT DataConstants VALUES('SourceType',	'STAR_CARBON',		3,	'')
INSERT DataConstants VALUES('SourceType',	'STAR_BROWN_DWARF',	4,	'')
INSERT DataConstants VALUES('SourceType',	'STAR_SUB_DWARF',	5,	'')
INSERT DataConstants VALUES('SourceType',	'STAR_CATY_VAR',	6,	'')
INSERT DataConstants VALUES('SourceType',	'STAR_RED_DWARF',	7,	'')
INSERT DataConstants VALUES('SourceType',	'STAR_WHITE_DWARF',	8,	'')
INSERT DataConstants VALUES('SourceType',	'REDDEN_STD',		9,	'')
INSERT DataConstants VALUES('SourceType',	'SPECTROPHOTO_STD',	10,	'')
INSERT DataConstants VALUES('SourceType',	'HOT_STD',		11,	'')
INSERT DataConstants VALUES('SourceType',	'ROSAT_A',		12,	'')
INSERT DataConstants VALUES('SourceType',	'ROSAT_B',		13,	'')
INSERT DataConstants VALUES('SourceType',	'ROSAT_C',		14,	'')
INSERT DataConstants VALUES('SourceType',	'ROSAT_D',		15,	'')
INSERT DataConstants VALUES('SourceType',	'SERENDIPITY_BLUE',	16,	'')
INSERT DataConstants VALUES('SourceType',	'SERENDIPITY_FIRST',	17,	'')
INSERT DataConstants VALUES('SourceType',	'SERENDIPITY_RED',	18,	'')
INSERT DataConstants VALUES('SourceType',	'SERENDIPITY_DISTANT',	19,	'')
INSERT DataConstants VALUES('SourceType',	'SERENDIPITY_MANUAL',	20,	'')
INSERT DataConstants VALUES('SourceType',	'QA',			21,	'Quality assurance (assigned to more than one tile)')
INSERT DataConstants VALUES('SourceType',	'SKY',			22,	'Blank sky')
INSERT DataConstants VALUES('SourceType',	'NA',			23,	'Not applicable (not an OBJECT hole)')
INSERT DataConstants VALUES('SourceType',	'STAR_PN',		24,	'')
GO
--

--spectroscopic programs
INSERT DataConstants VALUES('ProgramType',	'',		0,	'Spectroscopic program types.')
INSERT DataConstants VALUES('ProgramType',	'Main',		0,	'')
INSERT DataConstants VALUES('ProgramType',	'Other',	1,	'')
INSERT DataConstants VALUES('ProgramType',	'South',	2,	'')
GO
--

--tiling boundary coordinate types
INSERT DataConstants VALUES('CoordType',	'',		0,	'Tiling boundary coordinate types.')
INSERT DataConstants VALUES('CoordType',	'RA_DEC',	0,	'')
INSERT DataConstants VALUES('CoordType',	'LAMBDA_ETA',	1,	'')
INSERT DataConstants VALUES('CoordType',	'MU_NU',	2,	'')
INSERT DataConstants VALUES('CoordType',	'MU_ETA',	3,	'')
GO

--flags for results of tiling run
INSERT DataConstants VALUES('TiMask',	'',			0x0000000000000000,	'Tiling results bitmask.')
INSERT DataConstants VALUES('TiMask',	'AR_TMASK_TILED',	0x0000000000000001,	'Assigned to tile')
INSERT DataConstants VALUES('TiMask',	'AR_TMASK_DECOLLIDED',	0x0000000000000002,	'The object in its collision group which may be assigned a fiber.')
INSERT DataConstants VALUES('TiMask',	'AR_TMASK_COVERED',	0x0000000000000004,	'In area covered by a tile.')
INSERT DataConstants VALUES('TiMask',	'AR_TMASK_REMOVED',	0x0000000000000008,	'Removed from tile due to collision with plate center, quality, or light trap hole.')
INSERT DataConstants VALUES('TiMask',	'AR_TMASK_CULLED',	0x0000000000000010,	'Culled from this tiling run.')
GO
--

Insert StripeDefs VALUES ( 1,'N',-55.0,-35.5, 7.1,'')
Insert StripeDefs VALUES ( 2,'N',-52.5,-42.8,19.8,'')
Insert StripeDefs VALUES ( 3,'N',-50.0,-47.2,28.3,'')
Insert StripeDefs VALUES ( 4,'N',-47.5,-50.4,34.7,'')
Insert StripeDefs VALUES ( 5,'N',-45.0,-52.8,39.6,'')
Insert StripeDefs VALUES ( 6,'N',-42.5,-54.6,43.6,'')
Insert StripeDefs VALUES ( 7,'N',-40.0,-56.1,46.8,'')
Insert StripeDefs VALUES ( 8,'N',-37.5,-57.6,49.4,'')
Insert StripeDefs VALUES ( 9,'N',-35.0,-58.8,51.7,'')
Insert StripeDefs VALUES (10,'N',-32.5,-59.6,53.6,'')
Insert StripeDefs VALUES (11,'N',-30.0,-60.4,55.2,'')
Insert StripeDefs VALUES (12,'N',-27.5,-61.2,56.6,'')
Insert StripeDefs VALUES (13,'N',-25.0,-61.9,57.8,'')
Insert StripeDefs VALUES (14,'N',-22.5,-62.4,58.9,'')
Insert StripeDefs VALUES (15,'N',-20.0,-62.8,59.8,'')
Insert StripeDefs VALUES (16,'N',-17.5,-63.1,60.6,'')
Insert StripeDefs VALUES (17,'N',-15.0,-63.4,61.2,'')
Insert StripeDefs VALUES (18,'N',-12.5,-63.6,61.8,'')
Insert StripeDefs VALUES (19,'N',-10.0,-63.7,62.3,'')
Insert StripeDefs VALUES (20,'N', -7.5,-63.8,62.7,'')
Insert StripeDefs VALUES (21,'N', -5.0,-63.7,63.1,'')
Insert StripeDefs VALUES (22,'N', -2.5,-63.7,63.3,'')
Insert StripeDefs VALUES (23,'N',  0.0,-63.5,63.5,'')
Insert StripeDefs VALUES (24,'N',  2.5,-63.3,63.7,'')
Insert StripeDefs VALUES (25,'N',  5.0,-63.1,63.7,'')
Insert StripeDefs VALUES (26,'N',  7.5,-62.7,63.8,'')
Insert StripeDefs VALUES (27,'N', 10.0,-62.3,63.7,'')
Insert StripeDefs VALUES (28,'N', 12.5,-61.8,63.6,'')
Insert StripeDefs VALUES (29,'N', 15.0,-61.2,63.4,'')
Insert StripeDefs VALUES (30,'N', 17.5,-60.6,63.1,'')
Insert StripeDefs VALUES (31,'N', 20.0,-59.8,62.8,'')
Insert StripeDefs VALUES (32,'N', 22.5,-58.9,62.4,'')
Insert StripeDefs VALUES (33,'N', 25.0,-57.8,61.9,'')
Insert StripeDefs VALUES (34,'N', 27.5,-56.6,61.2,'')
Insert StripeDefs VALUES (35,'N', 30.0,-55.2,60.4,'')
Insert StripeDefs VALUES (36,'N', 32.5,-53.6,59.6,'')
Insert StripeDefs VALUES (37,'N', 35.0,-51.7,58.8,'')
Insert StripeDefs VALUES (38,'N', 37.5,-49.4,57.6,'')
Insert StripeDefs VALUES (39,'N', 40.0,-46.8,56.1,'')
Insert StripeDefs VALUES (40,'N', 42.5,-43.6,54.6,'')
Insert StripeDefs VALUES (41,'N', 45.0,-39.6,52.8,'')
Insert StripeDefs VALUES (42,'N', 47.5,-34.7,50.4,'')
Insert StripeDefs VALUES (43,'N', 50.0,-28.3,47.2,'')
Insert StripeDefs VALUES (44,'N', 52.5,-19.8,42.8,'')
Insert StripeDefs VALUES (45,'N', 55.0, -7.1,35.5,'')
Insert StripeDefs VALUES (76,'S',-47.5,126.0,-152,'')
Insert StripeDefs VALUES (82,'S',-32.5,126.0,-126,'')
Insert StripeDefs VALUES (86,'S',-22.5,126.0,-126,'')
-- New defs for SEGUE stripes from Brian & Svetlana 1/19/06
IF DB_NAME() LIKE '%SEGUE%'
    BEGIN
	Insert StripeDefs VALUES (72,'S',-57.5,-180,180,'')
	Insert StripeDefs VALUES (79,'S',-40.0,-180,180,'')
	Insert StripeDefs VALUES (90,'S',-37.5,-180,180,'')
	Insert StripeDefs VALUES (1020,'N',34.9501,242.3,277.3,'')
	Insert StripeDefs VALUES (1062,'N',27.1917,247.4,312.4,'')
	Insert StripeDefs VALUES (1100,'N',31.7023,252,332,'')
	Insert StripeDefs VALUES (1140,'N',44.7538,257.1,337.1,'')
	Insert StripeDefs VALUES (1188,'N',64.4976,249.06,384.06,'')
	Insert StripeDefs VALUES (1220,'N',78.5114,269.6,349.6,'')
	Insert StripeDefs VALUES (1260,'N',276.287,33.8,128.8,'')
	Insert StripeDefs VALUES (1300,'N',293.89,41.1,121.1,'')
	Insert StripeDefs VALUES (1356,'N',316.856,14.2,129.2,'')
	Insert StripeDefs VALUES (1374,'N',323.166,66.5,131.5,'')
	Insert StripeDefs VALUES (1406,'N',331.241,70.5,135.5,'')
	Insert StripeDefs VALUES (1458,'N',328.784,94.8,146.8,'')
	Insert StripeDefs VALUES (1540,'N',61.0638,152.8,187.8,'')
	Insert StripeDefs VALUES (1600,'N',87.3909,171.68,198.68,'')
	Insert StripeDefs VALUES (1660,'N',113.89,183.89,215.89,'')
	Insert StripeDefs VALUES (205,'N',35,354,248,'')
	Insert StripeDefs VALUES (290,'N',43.2,-180,180,'')
	Insert StripeDefs VALUES (291,'N',50.81,299,172,'')
	Insert StripeDefs VALUES (293,'N',60.1,24.6,39.6,'')
	Insert StripeDefs VALUES (294,'N',63.9,22.7,37.7,'')
	Insert StripeDefs VALUES (295,'N',58.2,25.5,40.5,'')
	Insert StripeDefs VALUES (296,'N',65.8,21.7,36.7,'')
	Insert StripeDefs VALUES (297,'N',67.5677,352,367,'')
	Insert StripeDefs VALUES (298,'N',56.3,26.4,41.4,'')
	Insert StripeDefs VALUES (299,'N',67.7,20.7,35.7,'')
	Insert StripeDefs VALUES (300,'N',62,23.7,38.7,'')
	Insert StripeDefs VALUES (301,'N',64.229,286,302,'')
    END
GO
--

Insert SDSSConstants values ('siteLongitude',	    105.8198305,  'deg',	'Site geodesic WEST longitude')
Insert SDSSConstants values ('siteLatitude',	     32.7797556,  'deg',	'Site Geodetic NORTH latitude')
Insert SDSSConstants values ('siteAltitude',		2797.0,   'm',  	'Altitude above sea level') 		
Insert SDSSConstants values ('surveyCenterRa',		185.0, 	  'deg', 	'RA of survey center') 
Insert SDSSConstants values ('surveyCenterDec',		32.5,	  'deg', 	'Dec of survey center')
Insert SDSSConstants values ('surveyEquinox',		2000.0,	  'y',   	'Survey equinox')
--
Insert SDSSConstants values ('lambdaMin',		-65.0,	  'deg', 	'Survey longitude minimum')
Insert SDSSConstants values ('lambdaMax',	 	65.0,	  'deg', 	'Survey longitude maximum')
Insert SDSSConstants values ('etaMin',			-57.5,	  'deg', 	'Survey latitude minimum')
Insert SDSSConstants values ('etaMax',		 	55.0,	  'deg', 	'Survey latitude maximum') 
--
Insert SDSSConstants values ('stripeWidth',	  	2.5,	  'deg', 	'The width of stripes')
Insert SDSSConstants values ('scanSeparation',	       0.2097744, 'deg', 	'The separation between the N and S scanlines')
Insert SDSSConstants values ('stripeSeparation',	2.5,	  'deg', 	'The separation of stripes')
Insert SDSSConstants values ('brickLength',	 	2.0,	  'deg', 	'Length of imaging bricks') 
Insert SDSSConstants values ('ccdColSep',		0.418333, 'deg', 	'CCD column separation')
Insert SDSSConstants values ('northMajor',      	65.0,	  'deg', 	'Major axis radius north area')
Insert SDSSConstants values ('northMinor',		55.0,	  'deg', 	'Minor axis radius north area')
Insert SDSSConstants values ('northPA',         	20.0,	  'deg', 	'Position angle of north area') 
--
Insert SDSSConstants values ('telescopeSize',	 	2.5,	  'm',  	'Size of the telescope primary mirror')
Insert SDSSConstants values ('fieldOfView',      	3.0,	  'deg', 	'Telescope field of view')
Insert SDSSConstants values ('chipPixelX',		2048,	  'pix',  	'X dimension of CCD chips')
Insert SDSSConstants values ('chipPixelY',      	2048,	  'pix',  	'Y dimension of CCD chips')
--
Insert SDSSConstants values ('nFilters',	   	5,	  '',	     	'Number of filters, their names are u'', g'', r'', i'', z''')
Insert SDSSConstants values ('nChipsPerFilter',	   	6,	  '',	     	'Number of CCDs per Filter')
Insert SDSSConstants values ('refBand', 		2,	  '',	     	'The filter used as the astrometric reference is r''')
--
Insert SDSSConstants values ('effectiveLambda_u', 	3540.,   'Angstrom',	'Center wavelength of the u'' filter')
Insert SDSSConstants values ('effectiveLambda_g', 	4760.,   'Angstrom',	'Center wavelength of the g'' filter')
Insert SDSSConstants values ('effectiveLambda_r', 	6280.,   'Angstrom',	'Center wavelength of the r'' filter')
Insert SDSSConstants values ('effectiveLambda_i', 	7690.,   'Angstrom',	'Center wavelength of the i'' filter')
Insert SDSSConstants values ('effectiveLambda_z', 	9250.,   'Angstrom',	'Center wavelength of the z'' filter')
Insert SDSSConstants values ('limitingMagnitudes_u', 	22.3,	 'magnitudes', 	'Limiting magnitude in the u'' filter')
Insert SDSSConstants values ('limitingMagnitudes_g', 	23.3, 	 'magnitudes', 	'Limiting magnitude in the g'' filter')
Insert SDSSConstants values ('limitingMagnitudes_r', 	23.1, 	 'magnitudes', 	'Limiting magnitude in the r'' filter')
Insert SDSSConstants values ('limitingMagnitudes_i', 	22.3,	 'magnitudes', 	'Limiting magnitude in the i'' filter')
Insert SDSSConstants values ('limitingMagnitudes_z', 	20.8,	 'magnitudes', 	'Limiting magnitude in the z'' filter')
--
Insert SDSSConstants values ( 'tileRadius',		1.49,	 'deg',  	'The tile diameter for spectroscopic observations')
Insert SDSSConstants values ( 'specPerPlate',		640,	 '',	     	'Number of spectra observed on a single plate')
Insert SDSSConstants values ( 'specLowerLimit',		3900.,	 'Angstrom',	'Lower wavelength limit of the spectrograph')
Insert SDSSConstants values ( 'specUpperLimit',		9200.,   'Angstrom',	'Upper wavelength limit of the spectrograph')
Insert SDSSConstants values ( 'resolution',		2000.,   '',  	     	'Resolution of the spectrograph')
Insert SDSSConstants values ( 'arcSecPerPixel',		0.39598, 'arcsec/pix', 'Linear size of the photographic pixels.')
Insert SDSSConstants values ( 'arcSecPerPixelErr',	0.0003,  'arcsec', 'Variation in size of the photographic pixels.')
Insert SDSSConstants values ( 'bPrime_u', 		1.4e-10, 'maggies', 'asinh softening parameter in u band.')
Insert SDSSConstants values ( 'bPrime_g', 		0.9e-10, 'maggies', 'asinh softening parameter in g band.')
Insert SDSSConstants values ( 'bPrime_r', 		1.2e-10, 'maggies', 'asinh softening parameter in r band.')
Insert SDSSConstants values ( 'bPrime_i', 		1.8e-10, 'maggies', 'asinh softening parameter in i band.')
Insert SDSSConstants values ( 'bPrime_z', 		7.4e-10, 'maggies', 'asinh softening parameter in z band.')
Insert SDSSConstants values ( 'expTime', 		53.907456, 'seconds', 'Nominal exposure time that is put in and taken out of the measured counts while calibrating.')

GO


Insert RunShift values (   94,	 0.015	);
Insert RunShift values (  125,	 0.015	);
Insert RunShift values ( 1033,	-0.024	);
Insert RunShift values ( 1056,	-0.024	);
Insert RunShift values ( 1350,	 0.005	);
Insert RunShift values ( 1402,	 0.005	);
Insert RunShift values ( 1412,	 0.005	);
Insert RunShift values ( 1450,	 0.005	);
Insert RunShift values ( 2206,	 0.005	);
GO


--------------------------------------------------------------------------
--                       bin,cell,sinc, rInner, rOuter,   aAnn,   aDisk 
--------------------------------------------------------------------------
INSERT ProfileDefs VALUES( 0,   0,   1,   0.00,   0.56,      1,       1 );
INSERT ProfileDefs VALUES( 1,   1,   1,   0.56,   1.69,      8,       9 );
INSERT ProfileDefs VALUES( 2,  13,   1,   1.69,   2.59,     12,      21 );
INSERT ProfileDefs VALUES( 3,  25,   1,   2.59,   4.41,     40,      61 );
INSERT ProfileDefs VALUES( 4,  37,   1,   4.41,   7.51,    116,     176 );
INSERT ProfileDefs VALUES( 5,  49,   1,   7.51,  11.58,    244,     421 );
INSERT ProfileDefs VALUES( 6,  61,   0,  11.58,  18.58,    664,    1085 );
INSERT ProfileDefs VALUES( 7,  73,   0,  18.58,  28.55,   1476,    2561 );
INSERT ProfileDefs VALUES( 8,  85,   0,  28.55,  45.50,   3944,    6505 );
INSERT ProfileDefs VALUES( 9,  97,   0,  45.50,  70.51,   9114,   15619 );
INSERT ProfileDefs VALUES(10, 109,   0,  70.51, 110.53,  22762,   38381 );
INSERT ProfileDefs VALUES(11, 121,   0, 110.53, 172.49,  55094,   93475 );
INSERT ProfileDefs VALUES(12, 133,   0, 172.49, 269.52, 134732,  228207 );
INSERT ProfileDefs VALUES(13, 145,   0, 269.52, 420.51, 327318,  555525 );
INSERT ProfileDefs VALUES(14, 157,   0, 420.51, 652.50, 782028, 1337553 );
--======================================================================
GO

DECLARE @scale float;
SELECT @scale=value FROM sdssConstants WITH (nolock)
    WHERE name = 'arcSecPerPixel'
UPDATE  ProfileDefs
    SET rInner = rInner * @scale,
	rOuter = rOuter * @scale,
	aAnn   = aAnn  * @scale * @scale,
	aDisk  = aDisk * @scale * @scale;
GO

PRINT '[DataConstants.sql]: Constant tables created'
GO
