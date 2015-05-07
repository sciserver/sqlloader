-- Patch to drop and create spectra tables for DR9

-- First drop the META and SPECTRO FK and covering indices
EXEC dbo.spIndexDropSelection 1,1303,'I,F', 'META'
EXEC dbo.spIndexDropSelection 1,1303,'I,F', 'SPECTRO'

---
--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SpecObjAll')
	DROP TABLE SpecObjAll
GO
--
EXEC spSetDefaultFileGroup 'SpecObjAll'
GO

CREATE TABLE SpecObjAll (
-------------------------------------------------------------------------------
--/H Contains the measured parameters for a spectrum.
--
--/T This is a base table containing <b>ALL</b> the spectroscopic
--/T information, including a lot of duplicate and bad data. Use
--/T the <b>SpecObj</b> view instead, which has the data properly
--/T filtered for cleanliness. These tables contain both the BOSS
--/T and SDSS spectrograph data.
-------------------------------------------------------------------------------
  specObjID       bigint NOT NULL, --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D --/K ID_CATALOG
  bestObjID       bigint NOT NULL, --/D Object ID of photoObj match (position-based) --/K ID_MAIN
  fluxObjID       bigint NOT NULL, --/D Object ID of photoObj match (flux-based) --/K ID_MAIN
  targetObjID     bigint NOT NULL, --/D Object ID of original target --/K ID_CATALOG
  plateID         bigint NOT NULL, --/D Database ID of Plate 
  sciencePrimary  smallint NOT NULL, --/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
  legacyPrimary   smallint NOT NULL, --/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
  seguePrimary    smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE plates --/F specsegue
  segue1Primary   smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue1
  segue2Primary   smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue2
  bossPrimary     smallint NOT NULL, --/D Best version of spectrum at this location, among BOSS plates --/F specboss
  bossSpecObjID   int NOT NULL, --/D Index of BOSS observation in spAll flat file
  firstRelease    varchar(32) NOT NULL, --/D Name of first release this object was associated with
  survey          varchar(32) NOT NULL, --/D Survey name
  instrument      varchar(32) NOT NULL, --/D Instrument used (SDSS or BOSS spectrograph)
  programname     varchar(32) NOT NULL, --/D Program name
  chunk           varchar(32) NOT NULL, --/D Chunk name
  platerun        varchar(32) NOT NULL, --/D Plate drill run name
  mjd             int NOT NULL, --/U days --/D MJD of observation 
  plate           smallint NOT NULL, --/D Plate number 
  fiberID         smallint NOT NULL, --/D Fiber ID 
  run1d           varchar(32) NOT NULL,  --/D 1D Reduction version of spectrum 
  run2d           varchar(32) NOT NULL,  --/D 2D Reduction version of spectrum 
  tile            int NOT NULL, --/D Tile number 
  designID        int NOT NULL, --/D Design ID number 
  legacy_target1   bigint NOT NULL, --/D for Legacy program, target selection information at plate design --/F legacy_target1
  legacy_target2   bigint NOT NULL, --/D for Legacy program target selection information at plate design, secondary/qa/calibration --/F legacy_target2
  special_target1  bigint NOT NULL, --/D for Special program target selection information at plate design --/F special_target1
  special_target2  bigint NOT NULL, --/D for Special program target selection information at plate design, secondary/qa/calibration --/F special_target2
  segue1_target1   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1
  segue1_target2   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection --/F segue1_target2
  segue2_target1   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, primary science selection --/F segue2_target1
  segue2_target2   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, secondary/qa/calib selection --/F segue2_target2
  boss_target1   bigint NOT NULL, --/D BOSS target selection information at plate  --/F boss_target1
  ancillary_target1   bigint NOT NULL, --/D BOSS ancillary science target selection information at plate design --/F ancillary_target1
  ancillary_target2   bigint NOT NULL, --/D BOSS ancillary target selection information at plate design --/F ancillary_target2
  primTarget       bigint NOT NULL, --/D target selection information at plate design, primary science selection (for backwards compatibility)
  secTarget        bigint NOT NULL, --/D target selection information at plate design, secondary/qa/calib selection  (for backwards compatibility)
  spectrographID  smallint NOT NULL, --/D which spectrograph (1,2)  
  sourceType         varchar(128) NOT NULL,  --/D For Legacy, SEGUE-2 and BOSS science targets, type of object targeted as (target bits contain full information and are recommended)
  targetType         varchar(128) NOT NULL,  --/D Nature of target: SCIENCE, STANDARD, or SKY
  ra              float NOT NULL, --/U deg  --/D Right ascension of fiber, J2000    --/F plug_ra
  dec             float NOT NULL, --/U deg  --/D Declination of fiber, J2000     --/F plug_dec
  cx              float   NOT NULL,       --/D x of Normal unit vector in J2000 --/K POS_EQ_CART_X
  cy              float   NOT NULL,       --/D y of Normal unit vector in J2000 --/K POS_EQ_CART_Y
  cz              float   NOT NULL,       --/D z of Normal unit vector in J2000 --/K POS_EQ_CART_Z
  xFocal          real NOT NULL, --/U mm --/D X focal plane position (+RA direction)
  yFocal          real NOT NULL, --/U mm --/D Y focal plane position (+Dec direction)
  lambdaEff       real NOT NULL, --/U Angstroms --/D Effective wavelength that hole was drilled for (accounting for atmopheric refraction)
  blueFiber       int NOT NULL, --/D Set to 1 if this hole was designated a "blue fiber", 0 if designated a "red fiber" (high redshift LRGs are preferentially in "red fibers")
  zOffset         real NOT NULL, --/U microns --/D Washer thickness used (for backstopping BOSS quasar targets, so they are closer to 4000 Angstrom focal plan)
  z               real NOT NULL, --/D Final Redshift 
  zErr            real NOT NULL, --/D Redshift error 
  zWarning        int NOT NULL, --/D Bitmask of warning values; 0 means all is well  
  class           varchar(32) NOT NULL,  --/D Spectroscopic class (GALAXY, QSO, or STAR)
  subClass        varchar(32) NOT NULL,  --/D Spectroscopic subclass 
  rChi2           real NOT NULL, --/D Reduced chi-squared of best fit
  DOF             real NOT NULL, --/D Degrees of freedom in best fit
  rChi2Diff       real NOT NULL, --/D Difference in reduced chi-squared between best and second best fit
  z_noqso         real NOT NULL,  --/D Best redshift when excluding QSO fit (right redshift to use for galaxy targets) --/F z_noqso
  zErr_noqso      real NOT NULL,  --/D Error in "z_noqso" redshift --/F z_err_noqso
  zWarning_noqso   real NOT NULL,  --/D Warnings in "z_noqso" redshift --/F zwarning_noqso
  class_noqso      varchar(32) NOT NULL,  --/D Classification in "z_noqso" redshift --/F class_noqso
  subClass_noqso   varchar(32) NOT NULL,  --/D Sub-classification in "z_noqso" redshift --/F subclass_noqso
  rChi2Diff_noqso  real NOT NULL,  --/D Reduced chi-squared difference from next best redshift, for "z_noqso" redshift  --/F rchi2diff_noqso
  z_person         real NOT NULL,  --/D Person-assigned redshift, if this object has been inspected --/F z_person
  class_person     varchar(32) NOT NULL,  --/D Person-assigned classification, if this object has been inspected --/F class_person
  comments_person  varchar(200) NOT NULL,  --/D Comments from person for inspected objects --/F comments_person
  tFile           varchar(32) NOT NULL, --/D File name of best fit template source 
  tColumn_0       smallint NOT NULL, --/D Which column of the template file corresponds to template #0 --/F tcolumn 0
  tColumn_1       smallint NOT NULL, --/D Which column of the template file corresponds to template #1 --/F tcolumn 1
  tColumn_2       smallint NOT NULL, --/D Which column of the template file corresponds to template #2 --/F tcolumn 2
  tColumn_3       smallint NOT NULL, --/D Which column of the template file corresponds to template #3 --/F tcolumn 3
  tColumn_4       smallint NOT NULL, --/D Which column of the template file corresponds to template #4 --/F tcolumn 4
  tColumn_5       smallint NOT NULL, --/D Which column of the template file corresponds to template #5 --/F tcolumn 5
  tColumn_6       smallint NOT NULL, --/D Which column of the template file corresponds to template #6 --/F tcolumn 6
  tColumn_7       smallint NOT NULL, --/D Which column of the template file corresponds to template #7 --/F tcolumn 7
  tColumn_8       smallint NOT NULL, --/D Which column of the template file corresponds to template #8 --/F tcolumn 8
  tColumn_9       smallint NOT NULL, --/D Which column of the template file corresponds to template #9 --/F tcolumn 9
  nPoly           real NOT NULL, --/D Number of polynomial terms used in the fit
  theta_0         real NOT NULL, --/D Coefficient for template #0 of fit --/F theta 0 
  theta_1         real NOT NULL, --/D Coefficient for template #1 of fit --/F theta 1 
  theta_2         real NOT NULL, --/D Coefficient for template #2 of fit --/F theta 2 
  theta_3         real NOT NULL, --/D Coefficient for template #3 of fit --/F theta 3 
  theta_4         real NOT NULL, --/D Coefficient for template #4 of fit --/F theta 4 
  theta_5         real NOT NULL, --/D Coefficient for template #5 of fit --/F theta 5 
  theta_6         real NOT NULL, --/D Coefficient for template #6 of fit --/F theta 6 
  theta_7         real NOT NULL, --/D Coefficient for template #7 of fit --/F theta 7 
  theta_8         real NOT NULL, --/D Coefficient for template #8 of fit --/F theta 8 
  theta_9         real NOT NULL, --/D Coefficient for template #9 of fit --/F theta 9 
  velDisp         real NOT NULL, --/U km/s --/D Velocity dispersion --/F vdisp
  velDispErr      real NOT NULL, --/U km/s --/D Error in velocity dispersion --/F vdisp_err
  velDispZ        real NOT NULL, --/D Redshift associated with best fit velocity dispersion --/F vdispz
  velDispZErr     real NOT NULL, --/D Error in redshift associated with best fit velocity dispersion --/F vdispz_err
  velDispChi2     real NOT NULL, --/D Chi-squared associated with velocity dispersion fit --/F vdispchi2
  velDispNPix     int NOT NULL, --/D Number of pixels overlapping best template in velocity dispersion fit --/F vdispnpix
  velDispDOF      int NOT NULL, --/D Number of degrees of freedom in velocity dispersion fit --/F vdispdof
  waveMin         real NOT NULL, --/U Angstroms --/D Minimum observed (vacuum) wavelength 
  waveMax         real NOT NULL, --/U Angstroms --/D Maximum observed (vacuum) wavelength 
  wCoverage       real NOT NULL, --/D Coverage in wavelength, in units of log10 wavelength
  snMedian_u      real NOT NULL, --/D Median signal-to-noise over all good pixels in u-band --/F sn_median 0
  snMedian_g      real NOT NULL, --/D Median signal-to-noise over all good pixels in g-band --/F sn_median 1
  snMedian_r      real NOT NULL, --/D Median signal-to-noise over all good pixels in r-band --/F sn_median 2
  snMedian_i      real NOT NULL, --/D Median signal-to-noise over all good pixels in i-band --/F sn_median 3
  snMedian_z      real NOT NULL, --/D Median signal-to-noise over all good pixels in z-band --/F sn_median 4
  snMedian        real NOT NULL, --/D Median signal-to-noise over all good pixels --/F sn_median_all
  chi68p          real NOT NULL, --/D 68-th percentile value of abs(chi) of the best-fit synthetic spectrum to the actual spectrum (around 1.0 for a good fit)
  fracNSigma_1    real NOT NULL, --/D Fraction of pixels deviant by more than 1 sigma relative to best-fit --/F fracnsigma 0
  fracNSigma_2    real NOT NULL, --/D Fraction of pixels deviant by more than 2 sigma relative to best-fit --/F fracnsigma 1
  fracNSigma_3    real NOT NULL, --/D Fraction of pixels deviant by more than 3 sigma relative to best-fit --/F fracnsigma 2
  fracNSigma_4    real NOT NULL, --/D Fraction of pixels deviant by more than 4 sigma relative to best-fit --/F fracnsigma 3
  fracNSigma_5    real NOT NULL, --/D Fraction of pixels deviant by more than 5 sigma relative to best-fit --/F fracnsigma 4
  fracNSigma_6    real NOT NULL, --/D Fraction of pixels deviant by more than 6 sigma relative to best-fit --/F fracnsigma 5
  fracNSigma_7    real NOT NULL, --/D Fraction of pixels deviant by more than 7 sigma relative to best-fit --/F fracnsigma 6
  fracNSigma_8    real NOT NULL, --/D Fraction of pixels deviant by more than 8 sigma relative to best-fit --/F fracnsigma 7
  fracNSigma_9    real NOT NULL, --/D Fraction of pixels deviant by more than 9 sigma relative to best-fit --/F fracnsigma 8
  fracNSigma_10   real NOT NULL, --/D Fraction of pixels deviant by more than 10 sigma relative to best-fit --/F fracnsigma 9
  fracNSigHi_1    real NOT NULL, --/D Fraction of pixels high by more than 1 sigma relative to best-fit --/F fracnsighi 0
  fracNSigHi_2    real NOT NULL, --/D Fraction of pixels high by more than 2 sigma relative to best-fit --/F fracnsighi 1
  fracNSigHi_3    real NOT NULL, --/D Fraction of pixels high by more than 3 sigma relative to best-fit --/F fracnsighi 2
  fracNSigHi_4    real NOT NULL, --/D Fraction of pixels high by more than 4 sigma relative to best-fit --/F fracnsighi 3
  fracNSigHi_5    real NOT NULL, --/D Fraction of pixels high by more than 5 sigma relative to best-fit --/F fracnsighi 4
  fracNSigHi_6    real NOT NULL, --/D Fraction of pixels high by more than 6 sigma relative to best-fit --/F fracnsighi 5
  fracNSigHi_7    real NOT NULL, --/D Fraction of pixels high by more than 7 sigma relative to best-fit --/F fracnsighi 6
  fracNSigHi_8    real NOT NULL, --/D Fraction of pixels high by more than 8 sigma relative to best-fit --/F fracnsighi 7
  fracNSigHi_9    real NOT NULL, --/D Fraction of pixels high by more than 9 sigma relative to best-fit --/F fracnsighi 8
  fracNSigHi_10   real NOT NULL, --/D Fraction of pixels high by more than 10 sigma relative to best-fit --/F fracnsighi 9
  fracNSigLo_1    real NOT NULL, --/D Fraction of pixels low by more than 1 sigma relative to best-fit --/F fracnsiglo 0
  fracNSigLo_2    real NOT NULL, --/D Fraction of pixels low by more than 2 sigma relative to best-fit --/F fracnsiglo 1
  fracNSigLo_3    real NOT NULL, --/D Fraction of pixels low by more than 3 sigma relative to best-fit --/F fracnsiglo 2
  fracNSigLo_4    real NOT NULL, --/D Fraction of pixels low by more than 4 sigma relative to best-fit --/F fracnsiglo 3
  fracNSigLo_5    real NOT NULL, --/D Fraction of pixels low by more than 5 sigma relative to best-fit --/F fracnsiglo 4
  fracNSigLo_6    real NOT NULL, --/D Fraction of pixels low by more than 6 sigma relative to best-fit --/F fracnsiglo 5
  fracNSigLo_7    real NOT NULL, --/D Fraction of pixels low by more than 7 sigma relative to best-fit --/F fracnsiglo 6
  fracNSigLo_8    real NOT NULL, --/D Fraction of pixels low by more than 8 sigma relative to best-fit --/F fracnsiglo 7
  fracNSigLo_9    real NOT NULL, --/D Fraction of pixels low by more than 9 sigma relative to best-fit --/F fracnsiglo 8
  fracNSigLo_10   real NOT NULL, --/D Fraction of pixels low by more than 10 sigma relative to best-fit --/F fracnsiglo 9
  spectroFlux_u   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto u filter  
  spectroFlux_g   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto g filter  
  spectroFlux_r   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto r filter
  spectroFlux_i   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto i filter
  spectroFlux_z   real NOT NULL, --/U nanomaggies --/D Spectrum projected onto z filter
  spectroSynFlux_u  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto u filter
  spectroSynFlux_g  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto g filter
  spectroSynFlux_r  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto r filter
  spectroSynFlux_i  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto i filter
  spectroSynFlux_z  real NOT NULL, --/U nanomaggies --/D Best-fit template spectrum projected onto z filter
  spectroFluxIvar_u real NOT NULL, --/U nanomaggies --/D Inverse variance of spectrum projected onto u filter
  spectroFluxIvar_g real NOT NULL, --/U nanomaggies --/D Inverse variance of spectrum projected onto g filter
  spectroFluxIvar_r real NOT NULL, --/U nanomaggies --/D Inverse variance of spectrum projected onto r filter
  spectroFluxIvar_i real NOT NULL, --/U nanomaggies --/D Inverse variance of spectrum projected onto i filter
  spectroFluxIvar_z real NOT NULL, --/U nanomaggies --/D Inverse variance of spectrum projected onto z filter
  spectroSynFluxIvar_u  real NOT NULL, --/U nanomaggies --/D Inverse variance of best-fit template spectrum projected onto u filter 
  spectroSynFluxIvar_g  real NOT NULL, --/U nanomaggies --/D Inverse variance of best-fit template spectrum projected onto g filter 
  spectroSynFluxIvar_r  real NOT NULL, --/U nanomaggies --/D Inverse variance of best-fit template spectrum projected onto r filter 
  spectroSynFluxIvar_i  real NOT NULL, --/U nanomaggies --/D Inverse variance of best-fit template spectrum projected onto i filter 
  spectroSynFluxIvar_z  real NOT NULL, --/U nanomaggies --/D Inverse variance of best-fit template spectrum projected onto z filter 
  spectroSkyFlux_u      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto u filter
  spectroSkyFlux_g      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto g filter
  spectroSkyFlux_r      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto r filter
  spectroSkyFlux_i      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto i filter
  spectroSkyFlux_z      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto z filter
  anyAndMask            int NOT NULL, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK
  anyOrMask             int NOT NULL, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK 
  plateSN2              real NOT NULL, --/D Overall signal-to-noise-squared measure for plate (only set for SDSS spectrograph)
  deredSN2              real NOT NULL, --/D Dereddened signal-to-noise-squared measure for plate (only set for BOSS spectrograph)
  snTurnoff             real NOT NULL, --/D Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate)
  sn1_g         real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #1 --/F spec1_g 
  sn1_r         real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #1 --/F spec1_r 
  sn1_i         real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #1 --/F spec1_i 
  sn2_g         real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #2 --/F spec2_g 
  sn2_r         real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #2 --/F spec2_r 
  sn2_i         real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #2 --/F spec2_i 
  elodieFileName   varchar(32) NOT NULL, --/D File name for best-fit Elodie star
  elodieObject     varchar(32) NOT NULL, --/D Star name (mostly Henry Draper names)
  elodieSpType     varchar(32) NOT NULL, --/D Spectral type
  elodieBV         real NOT NULL,  --/U mag --/D (B-V) color
  elodieTEff       real NOT NULL,  --/U Kelvin --/D Effective temperature
  elodieLogG       real NOT NULL,  --/D log10(gravity)  
  elodieFeH        real NOT NULL,  --/D Metallicity ([Fe/H])
  elodieZ          real NOT NULL,  --/D Redshift
  elodieZErr       real NOT NULL,  --/D Redshift error (negative for invalid fit)
  elodieZModelErr  real NOT NULL,  --/D Standard deviation in redshift among the 12 best-fit stars
  elodieRChi2      real NOT NULL,  --/D Reduced chi^2
  elodieDOF        real NOT NULL,  --/D Degrees of freedom for fit
  htmID           bigint  NOT NULL,       --/D 20 deep Hierarchical Triangular Mesh ID --/K CODE_HTM --/F NOFITS
  loadVersion     int     NOT NULL,       --/D Load Version --/K ID_TRACER --/F NOFITS
  img		varbinary(max) NOT NULL DEFAULT 0x1111,	--/D Spectrum Image --/K IMAGE? 
)
GO
--
--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PlateX')
	DROP TABLE PlateX
GO
--
EXEC spSetDefaultFileGroup 'PlateX'
GO

CREATE TABLE PlateX (
-------------------------------------------------------------------------------
--/H Contains data from a given plate used for spectroscopic observations.
--
--/T Each SDSS spectrograph plate has 640 observed spectra, whereas each BOSS 
--/T spectrograph plate has 1000 observed spectra. 
-------------------------------------------------------------------------------
	plateID         bigint  NOT NULL,	--/D Unique ID, composite of plate number and MJD --/K ID_PLATE
	firstRelease	varchar(32) NOT NULL,	--/D Name of release that this plate/mjd/rerun was first distributed in 
	plate           smallint NOT NULL,      --/D Plate number 
	mjd             int     NOT NULL,       --/D MJD of observation (last) --/U days
	mjdList         varchar(512) NOT NULL,  --/D List of contributing MJDs [from spPlate header]
	survey          varchar(32) NOT NULL,   --/D Name of survey [from platelist product]
	programName     varchar(32) NOT NULL,   --/D Name of program [from platelist product]
	instrument      varchar(32) NOT NULL,   --/D Instrument used (SDSS or BOSS spectrograph)
	chunk           varchar(32) NOT NULL,   --/D Name of tiling chunk  [from platelist product]
	plateRun        varchar(32) NOT NULL,   --/D Drilling run for plate [from platelist product]
	designComments  varchar(128) NOT NULL,  --/D Comments on the plate design from plate plans [from platelist product]
	plateQuality    varchar(32) NOT NULL,   --/D Characterization of plate quality
	qualityComments varchar(100) NOT NULL,  --/D Comments on reason for plate quality  
	plateSN2        real NOT NULL,          --/D Overall signal to noise measure for plate (only set for SDSS plates)
	deredSN2        real NOT NULL,          --/D Dereddened overall signal to noise measure for plate (only set for BOSS plates)
	ra              float   NOT NULL,       --/D RA, J2000 [from spPlate header] --/U deg  --/F racen
	dec             float   NOT NULL,       --/D Dec, J2000 [from spPlate header]  --/U deg  --/F deccen
	run2d		varchar(32) NOT NULL,	--/D 2D reduction rerun of plate
	run1d		varchar(32) NOT NULL,	--/D 1D reduction rerun of plate  
	runsspp		varchar(32) NOT NULL,	--/D SSPP reduction rerun of plate  ("none" if not run)  
	tile            smallint NOT NULL,      --/D Tile number for SDSS-I, -II plates (-1 for SDSS-III) [from platelist product]
	designID        int NOT NULL,           --/D Design number number for SDSS-III plates (-1 for SDSS-I, -II) [from platelist product]
	locationID        int NOT NULL,         --/D Location number number for SDSS-III plates (-1 for SDSS-I, -II) [from platelist product]
	iopVersion      varchar(64) NOT NULL,   --/D IOP Version [from spPlate header]
	camVersion      varchar(64) NOT NULL,   --/D Camera code version  [from spPlate header]
	taiHMS          varchar(64) NOT NULL,   --/D Time in string format [from spPlate header]
	dateObs         varchar(32) NOT NULL,   --/D Date of 1st row [from spPlate header]
	timeSys         varchar(8)  NOT NULL,   --/D Time System [from spPlate header]
	cx              float   NOT NULL,       --/D x of Normal unit vector in J2000 
	cy              float   NOT NULL,       --/D y of Normal unit vector in J2000 
	cz              float   NOT NULL,       --/D z of Normal unit vector in J2000 
	cartridgeID     smallint NOT NULL,      --/D ID of cartridge used for the observation [from spPlate header] --/F cartid
	tai             float   NOT NULL,       --/D Mean time (TAI) [from spPlate header] --/U sec 
	taiBegin        float   NOT NULL,       --/D Beginning time (TAI) [from spPlate header] --/U sec --/F tai_beg
	taiEnd          float   NOT NULL,       --/D Ending time (TAI) [from spPlate header] --/U sec --/F tai_end
	airmass         real NOT NULL,          --/D Airmass at central TAI time [from spPlate header]
	mapMjd          int     NOT NULL,       --/D Map MJD [from spPlate header] --/U days
	mapName         varchar(32) NOT NULL,   --/D ID of mapping file [from spPlate header]
	plugFile        varchar(32) NOT NULL,   --/D Full name of mapping file [from spPlate header]
	expTime         real    NOT NULL,       --/D Total Exposure time [from spPlate header] --/U sec 
	expTimeB1       real    NOT NULL,       --/D exposure time in B1 spectrograph [from spPlate header] --/U sec --/F expt_b1
	expTimeB2       real    NOT NULL,       --/D exposure time in B2 spectrograph [from spPlate header] --/U sec --/F expt_b2
	expTimeR1       real    NOT NULL,       --/D exposure time in R1 spectrograph [from spPlate header] --/U sec --/F expt_r1
	expTimeR2       real    NOT NULL,       --/D exposure time in R2 spectrograph [from spPlate header] --/U sec --/F expt_r2
	vers2d          varchar(32) NOT NULL,   --/D idlspec2d version used during 2d reduction [from spPlate header]
	verscomb        varchar(32) NOT NULL,   --/D idlspec2d version used during combination of multiple exposures [from spPlate header]
	vers1d          varchar(32) NOT NULL,   --/D idlspec2d version used during redshift fitting [from spPlate header]
	snturnoff       real NOT NULL,          --/D Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate)
	nturnoff        real NOT NULL,          --/D Number of MS turnoff stars on plate 
	nExp            smallint NOT NULL,      --/D Number of exposures total [from spPlate header]
	nExpB1          smallint NOT NULL,      --/D Number of exposures in B1 spectrograph  [from spPlate header]
	nExpB2          smallint NOT NULL,      --/D Number of exposures in B2 spectrograph  [from spPlate header]
	nExpR1          smallint NOT NULL,      --/D Number of exposures in R1 spectrograph  [from spPlate header]
	nExpR2          smallint NOT NULL,      --/D Number of exposures in R2 spectrograph  [from spPlate header]
	sn1_g           real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #1 [from spPlate header] --/F sn2_g1 
	sn1_r           real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #1 [from spPlate header] --/F sn2_r1 
	sn1_i           real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #1 [from spPlate header] --/F sn2_i1 
	sn2_g           real NOT NULL, --/D (S/N)^2 at g=20.20 for spectrograph #2 [from spPlate header] --/F sn2_g2 
	sn2_r           real NOT NULL, --/D (S/N)^2 at r=20.25 for spectrograph #2 [from spPlate header] --/F sn2_r2 
	sn2_i           real NOT NULL, --/D (S/N)^2 at i=19.90 for spectrograph #2 [from spPlate header] --/F sn2_i2 
	dered_sn1_g     real NOT NULL, --/D Dereddened (S/N)^2 at g=20.20 for spectrograph #1 [from spPlate header] --/F dered_sn2_g1 
	dered_sn1_r     real NOT NULL, --/D Dereddened (S/N)^2 at r=20.25 for spectrograph #1 [from spPlate header] --/F dered_sn2_r1 
	dered_sn1_i     real NOT NULL, --/D Dereddened (S/N)^2 at i=19.90 for spectrograph #1 [from spPlate header] --/F dered_sn2_i1 
	dered_sn2_g     real NOT NULL, --/D Dereddened (S/N)^2 at g=20.20 for spectrograph #2 [from spPlate header] --/F dered_sn2_g2 
	dered_sn2_r     real NOT NULL, --/D Dereddened (S/N)^2 at r=20.25 for spectrograph #2 [from spPlate header] --/F dered_sn2_r2 
	dered_sn2_i     real NOT NULL, --/D Dereddened (S/N)^2 at i=19.90 for spectrograph #2 [from spPlate header] --/F dered_sn2_i2 
	helioRV         real    NOT NULL,       --/D Heliocentric velocity correction [from spPlate header] --/U km/s
	gOffStd         real NOT NULL,          --/D Mean g-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	gRMSStd         real NOT NULL,          --/D Standard deviation of g-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	rOffStd         real NOT NULL,          --/D Mean r-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	rRMSStd         real NOT NULL,          --/D Standard deviation of r-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	iOffStd         real NOT NULL,          --/D Mean i-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	iRMSStd         real NOT NULL,          --/D Standard deviation of i-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	grOffStd         real NOT NULL,          --/D Mean g-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	grRMSStd         real NOT NULL,          --/D Standard deviation of g-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	riOffStd         real NOT NULL,          --/D Mean r-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	riRMSStd         real NOT NULL,          --/D Standard deviation of r-band mag difference (spectro - photo) for standards [from spPlate header] --/U mag
	gOffGal         real NOT NULL,          --/D Mean g-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	gRMSGal         real NOT NULL,          --/D Standard deviation of g-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	rOffGal         real NOT NULL,          --/D Mean r-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	rRMSGal         real NOT NULL,          --/D Standard deviation of r-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	iOffGal         real NOT NULL,          --/D Mean i-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	iRMSGal         real NOT NULL,          --/D Standard deviation of i-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	grOffGal         real NOT NULL,          --/D Mean g-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	grRMSGal         real NOT NULL,          --/D Standard deviation of g-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	riOffGal         real NOT NULL,          --/D Mean r-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	riRMSGal         real NOT NULL,          --/D Standard deviation of r-band mag difference (spectro - photo) for galaxies [from spPlate header] --/U mag
	nGuide           int NOT NULL,           --/D Number of guider camera frames taken during the exposure [from spPlate header]
	seeing20         real NOT NULL,          --/D 20th-percentile of seeing during exposure (arcsec) [from spPlate header]
	seeing50         real NOT NULL,          --/D 50th-percentile of seeing during exposure (arcsec) [from spPlate header]
	seeing80         real NOT NULL,          --/D 80th-percentile of seeing during exposure (arcsec) [from spPlate header]
	rmsoff20         real NOT NULL,          --/D 20th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]
	rmsoff50         real NOT NULL,          --/D 50th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]
	rmsoff80         real NOT NULL,          --/D 80th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]
	airtemp          real NOT NULL,          --/U deg Celsius  --/D Air temperature in the dome [from spPlate header]
	sfd_used         tinyint NOT NULL,       --/D Were the SFD dust maps applied to the output spectrum? (0 = no, 1 = yes) --/F sfd_used
	xSigma           real NOT NULL,         --/D sigma of gaussian fit to spatial profile[from spPlate header] 
	xSigMin          real NOT NULL,         --/D minimum of xSigma for all exposures [from spPlate header] 
	xSigMax          real NOT NULL,         --/D maximum of xSigma for all exposures [from spPlate header] 
	wSigma           real NOT NULL,         --/D sigma of gaussian fit to arc-line profiles in wavelength direction [from spPlate header] 
	wSigMin          real NOT NULL,         --/D minimum of wSigma for all exposures [from spPlate header] 
	wSigMax          real NOT NULL,         --/D maximum of wSigma for all exposures [from spPlate header] 
	xChi2            real NOT NULL,         --/D [from spPlate header] 
	xChi2Min         real NOT NULL,         --/D [from spPlate header] 
	xChi2Max         real NOT NULL,         --/D [from spPlate header] 
	skyChi2          real NOT NULL,         --/D average chi-squared from sky subtraction from all exposures [from spPlate header] 
	skyChi2Min       real NOT NULL,         --/D minimum skyChi2 over all exposures [from spPlate header] --/F schi2min
	skyChi2Max       real NOT NULL,         --/D maximum skyChi2 over all exposures [from spPlate header] --/F schi2max
	fBadPix          real NOT NULL,         --/D Fraction of pixels that are bad (total) [from spPlate header]
	fBadPix1         real NOT NULL,         --/D Fraction of pixels that are bad (spectrograph #1) [from spPlate header]
	fBadPix2         real NOT NULL,         --/D Fraction of pixels that are bad (spectrograph #2) [from spPlate header]
	status2d         varchar(32) NOT NULL,  --/D Status of 2D extraction
	statuscombine    varchar(32) NOT NULL,  --/D Status of combination of multiple MJDs
	status1d         varchar(32) NOT NULL,  --/D Status of 1D reductions
	nTotal           int NOT NULL,         --/D Number of objects total [calculated from spZbest file]
	nGalaxy          int NOT NULL,         --/D Number of objects classified as galaxy [calculated from spZbest file]
	nQSO             int NOT NULL,         --/D Number of objects classified as QSO [calculated from spZbest file]
	nStar            int NOT NULL,         --/D Number of objects classified as Star [calculated from spZbest file]
	nSky             int NOT NULL,          --/D Number of sky objects  [calculated from spZbest file]
	nUnknown         int NOT NULL,         --/D Number of objects with zWarning set non-zero (such objects still classified as star, galaxy or QSO) [calculated from spZbest file]
	isBest           tinyint NOT NULL,       --/D is this plateX entry the best observation of the plate 
	isPrimary        tinyint NOT NULL,      --/D is this plateX entry both good and the best observation of the plate 
	isTile           tinyint NOT NULL,         --/D is this plate the best representative  of its tile (only set for "legacy" program plates)
	ha               real NOT NULL,             --/D hour angle of design [from plPlugMapM file] --/U deg --/K POS_EQ_RA  
	mjdDesign        int NOT NULL,           --/D MJD designed for [from plPlugMapM file] --/K MJD  
	theta            real NOT NULL,          --/D cartridge position angle [from plPlugMapM file] --/K POS_POS-ANG  
	fscanVersion     varchar(32) NOT NULL,   --/D version of fiber scanning software [from plPlugMapM file] 
	fmapVersion      varchar(32) NOT NULL,   --/D version of fiber mapping software [from plPlugMapM file] 
	fscanMode        varchar(32) NOT NULL,   --/D 'slow', 'fast', or 'extreme' [from plPlugMapM file] 
	fscanSpeed       int NOT NULL,           --/D speed of scan [from plPlugMapM file] 
	htmID            bigint  NOT NULL,       --/D 20 deep Hierarchical Triangular Mesh ID --/F NOFITS
	loadVersion      int NOT NULL            --/D Load Version --/F NOFITS
)
GO
--

--=============================================================================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sppLines')
	DROP TABLE sppLines
GO
--
EXEC spSetDefaultFileGroup 'sppLines'
GO
CREATE TABLE sppLines (
-------------------------------------------------------------------------------
--/H Contains outputs from the SEGUE Stellar Parameter Pipeline (SSPP).
-------------------------------------------------------------------------------
--/T Spectra for over 500,000 Galactic stars of all common spectral types are
--/T available with DR8. These Spectra were processed with a pipeline called the
--/T SEGUE Stellar Parameter Pipeline (SSPP, Lee et al. 2008) that computes line indices for a wide
--/T range of common features at the radial velocity of the star in
--/T question. Note that the line indices for TiO5, TiO8, CaH1, CaH2, and CaH3 are calculated following
--/T the prescription given by the Hammer program (Covey et al. 2007). UVCN and BLCN line indices are computed
--/T by he equations given in Smith & Norris (1982), and FeI_4 and FeI_5 indices by the recipe in Friel (1987).
--/T FeI_1, FeI_2, FeI_3, and SrII line indices are only computed from the local continuum.
--/T Thus, these line indices calculated from different methods report the same values for both the local continuum and
--/T the global continuum. These outputs are stored in this table, and indexed on the 
--/T specObjID key index parameter for queries joining to other 
--/T tables such as specobjall and photoobjall.  See the Sample Queries in
--/T SkyServer for examples of such queries.
-------------------------------------------------------------------------------
 SPECOBJID            bigint NOT NULL,                        --/D id number
 bestObjID       bigint NOT NULL, --/D Object ID of photoObj match (flux-based) --/K ID_MAIN
 TARGETOBJID          bigint NOT NULL,                      --/D targeted object ID
 sciencePrimary  smallint NOT NULL, --/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
 legacyPrimary  smallint NOT NULL, --/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
 seguePrimary  smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj) --/F specsegue
 PLATE                bigint NOT NULL,                        --/D Plate number
 MJD                  bigint NOT NULL,                        --/D Modified Julian Date                                                                        
 FIBER                bigint NOT NULL,                        --/D Fiber ID                                                                   
 RUN2D               varchar(32) NOT NULL,                     --/D Name of 2D rerun
 RUN1D               varchar(32) NOT NULL,                     --/D Name of 1D rerun
 RUNSSPP             varchar(32) NOT NULL,                     --/D Name of SSPP rerun
 H83side              real NOT NULL,      --/U Angstrom             --/D Hzeta line index from local continuum at 3889.0 with band widths of 3.0     
 H83cont              real NOT NULL,      --/U Angstrom             --/D Hzeta line index from global continuum at 3889.0 with band widths of 3.0     
 H83err               real NOT NULL,      --/U Angstrom             --/D Hzeta line index error in the lind band at 3889.0 with band widths of 3.0     
 H83mask              tinyint NOT NULL,                             --/D Hzeta pixel quality check, =0 good, =1 bad at 3889.0 with band widths of 3.0     
 H812side             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from local continuum at 3889.1 with band widths of 12.0     
 H812cont             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from global continuum at 3889.1 with band widths of 12.0     
 H812err              real NOT NULL,      --/U Angstrom             --/D Hzeta line index error in the lind band at 3889.1 with band widths of 12.0     
 H812mask             tinyint NOT NULL,                             --/D Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 12.0     
 H824side             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from local continuum at 3889.1 with band widths of 24.0     
 H824cont             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from global continuum at 3889.1 with band widths of 24.0     
 H824err              real NOT NULL,      --/U Angstrom             --/D Hzeta line index error in the lind band at 3889.1 with band widths of 24.0     
 H824mask             tinyint NOT NULL,                             --/D Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 24.0     
 H848side             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from local continuum at 3889.1 with band widths of 48.0     
 H848cont             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from global continuum at 3889.1 with band widths of 48.0     
 H848err              real NOT NULL,      --/U Angstrom             --/D Hzeta line index error in the lind band at 3889.1 with band widths of 48.0     
 H848mask             tinyint NOT NULL,                             --/D Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 48.0     
 KP12side             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from local continuum at 3933.7 with band widths of 12.0     
 KP12cont             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from global continuum at 3933.7 with band widths of 12.0     
 KP12err              real NOT NULL,      --/U Angstrom             --/D Ca II K line index error in the lind band at 3933.7 with band widths of 12.0     
 KP12mask             tinyint NOT NULL,                             --/D Ca II K pixel quality check, =0 good, =1 bad at 3933.7 with band widths of 12.0     
 KP18side             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from local continuum at 3933.7 with band widths of 18.0     
 KP18cont             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from global continuum at 3933.7 with band widths of 18.0     
 KP18err              real NOT NULL,      --/U Angstrom             --/D Ca II K line index error in the lind band at 3933.7 with band widths of 18.0     
 KP18mask             tinyint NOT NULL,                             --/D Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 18.0     
 KP6side              real NOT NULL,      --/U Angstrom             --/D Ca II K line index from local continuum at 3933.7 with band widths of 6.0     
 KP6cont              real NOT NULL,      --/U Angstrom             --/D Ca II K line index from global continuum at 3933.7 with band widths of 6.0     
 KP6err               real NOT NULL,      --/U Angstrom             --/D Ca II K line index error in the lind band at 3933.7 with band widths of 6.0     
 KP6mask              tinyint NOT NULL,                             --/D Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 6.0     
 CaIIKside             real NOT NULL,      --/U Angstrom           --/D Ca II K line index from local continuum at 3933.6 with band widths of 30.0     
 CaIIKcont             real NOT NULL,      --/U Angstrom           --/D Ca II K line index from global continuum at 3933.6 with band widths of 30.0     
 CaIIKerr              real NOT NULL,      --/U Angstrom           --/D Ca II K line index error in the lind band at 3933.6 with band widths of 30.0     
 CaIIKmask             tinyint NOT NULL,                           --/D Ca II K pixel quality check =0, good, =1 bad at 3933.6 with band widths of 30.0     
 CaIIHKside            real NOT NULL,      --/U Angstrom           --/D Ca II H and K line index from local continuum at 3962.0 with band widths of 75.0     
 CaIIHKcont            real NOT NULL,      --/U Angstrom           --/D Ca II H and K line index from global continuum at 3962.0 with band widths of 75.0     
 CaIIHKerr             real NOT NULL,      --/U Angstrom           --/D Ca II H and K line index error in the lind band at 3962.0 with band widths of 75.0     
 CaIIHKmask            tinyint NOT NULL,                           --/D Ca II H and K pixel quality check =0, good, =1 bad at 3962.0 with band widths of 75.0     
 Hepsside              real NOT NULL,      --/U Angstrom           --/D Hepsilon line index from local continuum at 3970.0 with band widths of 50.0     
 Hepscont              real NOT NULL,      --/U Angstrom           --/D Hepsilon line index from global continuum at 3970.0 with band widths of 50.0     
 Hepserr               real NOT NULL,      --/U Angstrom           --/D Hepsilon line index error in the lind band at 3970.0 with band widths of 50.0     
 Hepsmask              tinyint NOT NULL,                           --/D Hepsilon pixel quality check =0, good, =1 bad at 3970.0 with band widths of 50.0     
 KP16side             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from local continuum at 3933.7 with band widths of 16.0     
 KP16cont             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from global continuum at 3933.7 with band widths of 16.0     
 KP16err              real NOT NULL,      --/U Angstrom             --/D Ca II K line index error in the lind band at 3933.7 with band widths of 16.0     
 KP16mask             tinyint NOT NULL,                             --/D Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 16.0     
 SrII1side            real NOT NULL,      --/U Angstrom             --/D Sr II line index from local continuum at 4077.0 with band widths of 8.0     
 SrII1cont            real NOT NULL,      --/U Angstrom             --/D Sr II line index from global continuum at 4077.0 with band widths of 8.0     
 SrII1err             real NOT NULL,      --/U Angstrom             --/D Sr II line index error in the lind band at 4077.0 with band widths of 8.0     
 SrII1mask            tinyint NOT NULL,                             --/D Sr II pixel quality check =0, good, =1 bad at 4077.0 with band widths of 8.0     
 HeI121side          real NOT NULL,      --/U Angstrom        --/D He I line index from local continuum at 4026.2 with band widths of 12.0     
 HeI121cont          real NOT NULL,      --/U Angstrom        --/D He I line index from global continuum at 4026.2 with band widths of 12.0     
 HeI121err           real NOT NULL,      --/U Angstrom        --/D He I line index error in the lind band at 4026.2 with band widths of 12.0     
 HeI121mask          tinyint NOT NULL,                        --/D He I pixel quality check =0, good, =1 bad at 4026.2 with band widths of 12.0     
 Hdelta12side         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from local continuum at 4101.8 with band widths of 12.0     
 Hdelta12cont         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from global continuum at 4101.8 with band widths of 12.0     
 Hdelta12err          real NOT NULL,      --/U Angstrom        --/D Hdelta line index error in the lind band at 4101.8 with band widths of 12.0     
 Hdelta12mask         tinyint NOT NULL,                        --/D Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 12.0     
 Hdelta24side         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from local continuum at 4101.8 with band widths of 24.0     
 Hdelta24cont         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from global continuum at 4101.8 with band widths of 24.0     
 Hdelta24err          real NOT NULL,      --/U Angstrom        --/D Hdelta line index error in the lind band at 4101.8 with band widths of 24.0     
 Hdelta24mask         tinyint NOT NULL,                        --/D Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 24.0     
 Hdelta48side         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from local continuum at 4101.8 with band widths of 48.0     
 Hdelta48cont         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from global continuum at 4101.8 with band widths of 48.0     
 Hdelta48err          real NOT NULL,      --/U Angstrom        --/D Hdelta line index error in the lind band at 4101.8 with band widths of 48.0     
 Hdelta48mask         tinyint NOT NULL,                        --/D Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 48.0     
 Hdeltaside            real NOT NULL,      --/U Angstrom       --/D Hdelta line index from local continuum at 4102.0 with band widths of 64.0     
 Hdeltacont            real NOT NULL,      --/U Angstrom       --/D Hdelta line index from global continuum at 4102.0 with band widths of 64.0     
 Hdeltaerr             real NOT NULL,      --/U Angstrom       --/D Hdelta line index error in the lind band at 4102.0 with band widths of 64.0     
 Hdeltamask            tinyint NOT NULL,                       --/D Hdelta pixel quality check =0, good, =1 bad at 4102.0 with band widths of 64.0     
 CaI4side             real NOT NULL,      --/U Angstrom       --/D Ca I line index from local continuum at 4226.0 with band widths of 4.0     
 CaI4cont             real NOT NULL,      --/U Angstrom       --/D Ca I line index from global continuum at 4226.0 with band widths of 4.0     
 CaI4err              real NOT NULL,      --/U Angstrom       --/D Ca I line index error in the lind band at 4226.0 with band widths of 4.0     
 CaI4mask             tinyint NOT NULL,                       --/D Ca I pixel quality check =0, good, =1 bad at 4226.0 with band widths of 4.0     
 CaI12side            real NOT NULL,      --/U Angstrom       --/D Ca I line index from local continuum at 4226.7 with band widths of 12.0     
 CaI12cont            real NOT NULL,      --/U Angstrom       --/D Ca I line index from global continuum at 4226.7 with band widths of 12.0     
 CaI12err             real NOT NULL,      --/U Angstrom       --/D Ca I line index error in the lind band at 4226.7 with band widths of 12.0     
 CaI12mask            tinyint NOT NULL,                       --/D Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 12.0     
 CaI24side            real NOT NULL,      --/U Angstrom       --/D Ca I line index from local continuum at 4226.7 with band widths of 24.0     
 CaI24cont            real NOT NULL,      --/U Angstrom       --/D Ca I line index from global continuum at 4226.7 with band widths of 24.0     
 CaI24err             real NOT NULL,      --/U Angstrom       --/D Ca I line index error in the lind band at 4226.7 with band widths of 24.0     
 CaI24mask            tinyint NOT NULL,                       --/D Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 24.0     
 CaI6side             real NOT NULL,      --/U Angstrom       --/D Ca I line index from local continuum at 4226.7 with band widths of 6.0     
 CaI6cont             real NOT NULL,      --/U Angstrom       --/D Ca I line index from global continuum at 4226.7 with band widths of 6.0     
 CaI6err              real NOT NULL,      --/U Angstrom       --/D Ca I line index error in the lind band at 4226.7 with band widths of 6.0     
 CaI6mask             tinyint NOT NULL,                       --/D Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 6.0     
 Gside                 real NOT NULL,      --/U Angstrom       --/D G band line index from local continuum at 4305.0 with band widths of 15.0     
 Gcont                 real NOT NULL,      --/U Angstrom       --/D G band line index from global continuum at 4305.0 with band widths of 15.0     
 Gerr                  real NOT NULL,      --/U Angstrom       --/D G band line index error in the lind band at 4305.0 with band widths of 15.0     
 Gmask                 tinyint NOT NULL,                       --/D G band pixel quality check =0, good, =1 bad at 4305.0 with band widths of 15.0     
 Hgamma12side         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from local continuum at 4340.5 with band widths of 12.0     
 Hgamma12cont         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from global continuum at 4340.5 with band widths of 12.0     
 Hgamma12err          real NOT NULL,      --/U Angstrom       --/D Hgamma line index error in the lind band at 4340.5 with band widths of 12.0     
 Hgamma12mask         tinyint NOT NULL,                       --/D Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 12.0     
 Hgamma24side         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from local continuum at 4340.5 with band widths of 24.0     
 Hgamma24cont         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from global continuum at 4340.5 with band widths of 24.0     
 Hgamma24err          real NOT NULL,      --/U Angstrom       --/D Hgamma line index error in the lind band at 4340.5 with band widths of 24.0     
 Hgamma24mask         tinyint NOT NULL,                       --/D Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 24.0     
 Hgamma48side         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from local continuum at 4340.5 with band widths of 48.0     
 Hgamma48cont         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from global continuum at 4340.5 with band widths of 48.0     
 Hgamma48err          real NOT NULL,      --/U Angstrom       --/D Hgamma line index error in the lind band at 4340.5 with band widths of 48.0     
 Hgamma48mask         tinyint NOT NULL,                       --/D Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 48.0     
 Hgammaside            real NOT NULL,      --/U Angstrom       --/D Hgamma line index from local continuum at 4340.5 with band widths of 54.0     
 Hgammacont            real NOT NULL,      --/U Angstrom       --/D Hgamma line index from global continuum at 4340.5 with band widths of 54.0     
 Hgammaerr             real NOT NULL,      --/U Angstrom       --/D Hgamma line index error in the lind band at 4340.5 with band widths of 54.0     
 Hgammamask            tinyint NOT NULL,                       --/D Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 54.0     
 HeI122side          real NOT NULL,      --/U Angstrom       --/D He I line index from local continuum at 4471.7 with band widths of 12.0     
 HeI122cont          real NOT NULL,      --/U Angstrom       --/D He I line index from global continuum at 4471.7 with band widths of 12.0     
 HeI122err           real NOT NULL,      --/U Angstrom       --/D He I line index error in the lind band at 4471.7 with band widths of 12.0     
 HeI122mask          tinyint NOT NULL,                       --/D He I pixel quality check =0, good, =1 bad at 4471.7 with band widths of 12.0     
 Gblueside            real NOT NULL,      --/U Angstrom        --/D G band line index from local continuum at 4305.0 with band widths of 26.0     
 Gbluecont            real NOT NULL,      --/U Angstrom        --/D G band line index from global continuum at 4305.0 with band widths of 26.0     
 Gblueerr             real NOT NULL,      --/U Angstrom        --/D G band line index error in the lind band at 4305.0 with band widths of 26.0     
 Gbluemask            tinyint NOT NULL,                        --/D G band pixel quality check =0, good, =1 bad at 4305.0 with band widths of 26.0     
 Gwholeside           real NOT NULL,      --/U Angstrom        --/D G band line index from local continuum at 4321.0 with band widths of 28.0     
 Gwholecont           real NOT NULL,      --/U Angstrom        --/D G band line index from global continuum at 4321.0 with band widths of 28.0     
 Gwholeerr            real NOT NULL,      --/U Angstrom        --/D G band line index error in the lind band at 4321.0 with band widths of 28.0     
 Gwholemask           tinyint NOT NULL,                        --/D G band pixel quality check =0, good, =1 bad at 4321.0 with band widths of 28.0     
 Baside                real NOT NULL,      --/U Angstrom        --/D Ba line index from local continuum at 4554.0 with band widths of 6.0     
 Bacont                real NOT NULL,      --/U Angstrom        --/D Ba line index from global continuum at 4554.0 with band widths of 6.0     
 Baerr                 real NOT NULL,      --/U Angstrom        --/D Ba line index error in the lind band at 4554.0 with band widths of 6.0     
 Bamask                tinyint NOT NULL,                        --/D Ba pixel quality check =0, good, =1 bad at 4554.0 with band widths of 6.0     
 C12C13side            real NOT NULL,      --/U Angstrom        --/D C12C13 band line index from local continuum at 4737.0 with band widths of 36.0     
 C12C13cont            real NOT NULL,      --/U Angstrom        --/D C12C13 band line index from global continuum at 4737.0 with band widths of 36.0     
 C12C13err             real NOT NULL,      --/U Angstrom        --/D C12C13 band line index error in the lind band at 4737.0 with band widths of 36.0     
 C12C13mask            tinyint NOT NULL,                        --/D C12C13 band pixel quality check =0, good, =1 bad at 4737.0 with band widths of 36.0     
 CC12side              real NOT NULL,      --/U Angstrom        --/D C2 band line index from local continuum at 4618.0 with band widths of 256.0     
 CC12cont              real NOT NULL,      --/U Angstrom        --/D C2 band line index from global continuum at 4618.0 with band widths of 256.0     
 CC12err               real NOT NULL,      --/U Angstrom        --/D C2 band line index error in the lind band at 4618.0 with band widths of 256.0     
 CC12mask              tinyint NOT NULL,                        --/D C2 band pixel quality check =0, good, =1 bad at 4618.0 with band widths of 256.0     
 metal1side            real NOT NULL,      --/U Angstrom        --/D Metallic line index from local continuum at 4584.0 with band widths of 442.0     
 metal1cont            real NOT NULL,      --/U Angstrom        --/D Metallic line index from global continuum at 4584.0 with band widths of 442.0     
 metal1err             real NOT NULL,      --/U Angstrom        --/D Metlllic line index error in the lind band at 4584.0 with band widths of 442.0     
 metal1mask            tinyint NOT NULL,                        --/D Metal1ic pixel quality check =0, good, =1 bad at 4584.0 with band widths of 442.0     
 Hbeta12side          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from local continuum at 4862.3 with band widths of 12.0     
 Hbeta12cont          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from global continuum at 4862.3 with band widths of 12.0     
 Hbeta12err           real NOT NULL,      --/U Angstrom        --/D Hbeta line index error in the lind band at 4862.3 with band widths of 12.0     
 Hbeta12mask          tinyint NOT NULL,                        --/D Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 12.0     
 Hbeta24side          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from local continuum at 4862.3 with band widths of 24.0     
 Hbeta24cont          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from global continuum at 4862.3 with band widths of 24.0     
 Hbeta24err           real NOT NULL,      --/U Angstrom        --/D Hbeta line index error in the lind band at 4862.3 with band widths of 24.0     
 Hbeta24mask          tinyint NOT NULL,                        --/D Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 24.0     
 Hbeta48side          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from local continuum at 4862.3 with band widths of 48.0     
 Hbeta48cont          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from global continuum at 4862.3 with band widths of 48.0     
 Hbeta48err           real NOT NULL,      --/U Angstrom        --/D Hbeta line index error in the lind band at 4862.3 with band widths of 48.0     
 Hbeta48mask          tinyint NOT NULL,                        --/D Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 48.0     
 Hbetaside             real NOT NULL,      --/U Angstrom        --/D Hbeta line index from local continuum at 4862.3 with band widths of 60.0     
 Hbetacont             real NOT NULL,      --/U Angstrom        --/D Hbeta line index from global continuum at 4862.3 with band widths of 60.0     
 Hbetaerr              real NOT NULL,      --/U Angstrom        --/D Hbeta line index error in the lind band at 4862.3 with band widths of 60.0     
 Hbetamask             tinyint NOT NULL,                        --/D Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 60.0     
 C2side                real NOT NULL,      --/U Angstrom        --/D C2 band line index from local continuum at 5052.0 with band widths of 204.0     
 C2cont                real NOT NULL,      --/U Angstrom        --/D C2 band line index from global continuum at 5052.0 with band widths of 204.0     
 C2err                 real NOT NULL,      --/U Angstrom        --/D C2 band line index error in the lind band at 5052.0 with band widths of 204.0     
 C2mask                tinyint NOT NULL,                        --/D C2 band pixel quality check =0, good, =1 bad at 5052.0 with band widths of 204.0     
 C2MgIside            real NOT NULL,      --/U Angstrom        --/D C2 and Mg I line index from local continuum at 5069.0 with band widths of 238.0     
 C2MgIcont            real NOT NULL,      --/U Angstrom        --/D C2 and Mg I line index from global continuum at 5069.0 with band widths of 238.0     
 C2MgIerr             real NOT NULL,      --/U Angstrom        --/D C2 and Mg I line index error in the lind band at 5069.0 with band widths of 238.0     
 C2MgImask            tinyint NOT NULL,                         --/D C2 and Mg I pixel quality check =0, good, =1 bad at 5069.0 with band widths of 238.0     
 MgHMgIC2side        real NOT NULL,      --/U Angstrom        --/D MgH, Mg I, and C2 line index from local continuum at 5085.0 with band widths of 270.0     
 MgHMgIC2cont        real NOT NULL,      --/U Angstrom        --/D MgH, Mg I, and C2 line index from global continuum at 5085.0 with band widths of 270.0     
 MgHMgIC2err         real NOT NULL,      --/U Angstrom        --/D MgH, Mg I, and C2 line index error in the lind band at 5085.0 with band widths of 270.0     
 MgHMgIC2mask        tinyint NOT NULL,                        --/D MgH, Mg I, and C2 pixel quality check =0, good, =1 bad at 5085.0 with band widths of 270.0   
 MgHMgIside           real NOT NULL,      --/U Angstrom        --/D MgH and Mg I line index from local continuum at 5198.0 with band widths of 44.0     
 MgHMgIcont           real NOT NULL,      --/U Angstrom        --/D MgH and Mg I line index from global continuum at 5198.0 with band widths of 44.0     
 MgHMgIerr            real NOT NULL,      --/U Angstrom        --/D MgH and Mg I line index error in the lind band at 5198.0 with band widths of 44.0     
 MgHMgImask           tinyint NOT NULL,                        --/D MgH_MgI pixel quality check =0, good, =1 bad at 5198.0 with band widths of 44.0     
 MgHside               real NOT NULL,      --/U Angstrom        --/D MgH line index from local continuum at 5210.0 with band widths of 20.0     
 MgHcont               real NOT NULL,      --/U Angstrom        --/D MgH line index from global continuum at 5210.0 with band widths of 20.0     
 MgHerr                real NOT NULL,      --/U Angstrom        --/D MgH line index error in the lind band at 5210.0 with band widths of 20.0     
 MgHmask               tinyint NOT NULL,                        --/D MgH pixel quality check =0, good, =1 bad at 5210.0 with band widths of 20.0     
 CrIside               real NOT NULL,      --/U Angstrom        --/D Cr I line index from local continuum at 5206.0 with band widths of 12.0     
 CrIcont               real NOT NULL,      --/U Angstrom        --/D Cr I line index from global continuum at 5206.0 with band widths of 12.0     
 CrIerr                real NOT NULL,      --/U Angstrom        --/D Cr I line index error in the lind band at 5206.0 with band widths of 12.0     
 CrImask               tinyint NOT NULL,                        --/D Cr I pixel quality check =0, good, =1 bad at 5206.0 with band widths of 12.0     
 MgIFeIIside          real NOT NULL,      --/U Angstrom        --/D Mg I and Fe II line index from local continuum at 5175.0 with band widths of 20.0     
 MgIFeIIcont          real NOT NULL,      --/U Angstrom        --/D Mg I and Fe II line index from global continuum at 5175.0 with band widths of 20.0     
 MgIFeIIerr           real NOT NULL,      --/U Angstrom        --/D Mg I and Fe II line index error in the lind band at 5175.0 with band widths of 20.0     
 MgIFeIImask          tinyint NOT NULL,                        --/D Mg I and Fe II pixel quality check =0, good, =1 bad at 5175.0 with band widths of 20.0     
 MgI2side             real NOT NULL,      --/U Angstrom        --/D Mg I line index from local continuum at 5183.0 with band widths of 2.0     
 MgI2cont             real NOT NULL,      --/U Angstrom        --/D Mg I line index from global continuum at 5183.0 with band widths of 2.0     
 MgI2err              real NOT NULL,      --/U Angstrom        --/D Mg I line index error in the lind band at 5183.0 with band widths of 2.0     
 MgI2mask             tinyint NOT NULL,                        --/D Mg I pixel quality check =0, good, =1 bad at 5183.0 with band widths of 2.0     
 MgI121side          real NOT NULL,      --/U Angstrom        --/D Mg I line index from local continuum at 5170.5 with band widths of 12.0     
 MgI121cont          real NOT NULL,      --/U Angstrom        --/D Mg I line index from global continuum at 5170.5 with band widths of 12.0     
 MgI121err           real NOT NULL,      --/U Angstrom        --/D Mg I line index error in the lind band at 5170.5 with band widths of 12.0     
 MgI121mask          tinyint NOT NULL,                        --/D Mg I pixel quality check =0, good, =1 bad at 5170.5 with band widths of 12.0     
 MgI24side            real NOT NULL,      --/U Angstrom        --/D Mg I line index from local continuum at 5176.5 with band widths of 24.0     
 MgI24cont            real NOT NULL,      --/U Angstrom        --/D Mg I line index from global continuum at 5176.5 with band widths of 24.0     
 MgI24err             real NOT NULL,      --/U Angstrom        --/D Mg I line index error in the lind band at 5176.5 with band widths of 24.0     
 MgI24mask            tinyint NOT NULL,                        --/D Mg I pixel quality check =0, good, =1 bad at 5176.5 with band widths of 24.0     
 MgI122side          real NOT NULL,      --/U Angstrom        --/D Mg I line index from local continuum at 5183.5 with band widths of 12.0     
 MgI122cont          real NOT NULL,      --/U Angstrom        --/D Mg I line index from global continuum at 5183.5 with band widths of 12.0     
 MgI122err           real NOT NULL,      --/U Angstrom        --/D Mg I line index error in the lind band at 5183.5 with band widths of 12.0     
 MgI122mask          tinyint NOT NULL,                        --/D Mg I pixel quality check =0, good, =1 bad at 5183.5 with band widths of 12.0     
 NaI20side            real NOT NULL,      --/U Angstrom        --/D Na I line index from local continuum at 5890.0 with band widths of 20.0     
 NaI20cont            real NOT NULL,      --/U Angstrom        --/D Na I line index from global continuum at 5890.0 with band widths of 20.0     
 NaI20err             real NOT NULL,      --/U Angstrom        --/D Na I line index error in the lind band at 5890.0 with band widths of 20.0     
 NaI20mask            tinyint NOT NULL,                        --/D Na I pixel quality check =0, good, =1 bad at 5890.0 with band widths of 20.0     
 Na12side             real NOT NULL,      --/U Angstrom        --/D Na line index from local continuum at 5892.9 with band widths of 12.0     
 Na12cont             real NOT NULL,      --/U Angstrom        --/D Na line index from global continuum at 5892.9 with band widths of 12.0     
 Na12err              real NOT NULL,      --/U Angstrom        --/D Na line index error in the lind band at 5892.9 with band widths of 12.0     
 Na12mask             tinyint NOT NULL,                        --/D Na pixel quality check =0, good, =1 bad at 5892.9 with band widths of 12.0     
 Na24side             real NOT NULL,      --/U Angstrom        --/D Na line index from local continuum at 5892.9 with band widths of 24.0     
 Na24cont             real NOT NULL,      --/U Angstrom        --/D Na line index from global continuum at 5892.9 with band widths of 24.0     
 Na24err              real NOT NULL,      --/U Angstrom        --/D Na line index error in the lind band at 5892.9 with band widths of 24.0     
 Na24mask             tinyint NOT NULL,                        --/D Na pixel quality check =0, good, =1 bad at 5892.9 with band widths of 24.0     
 Halpha12side         real NOT NULL,      --/U Angstrom         --/D Halpha line index from local continuum at 6562.8 with band widths of 12.0     
 Halpha12cont         real NOT NULL,      --/U Angstrom         --/D Halpha line index from global continuum at 6562.8 with band widths of 12.0     
 Halpha12err          real NOT NULL,      --/U Angstrom         --/D Halpha line index error in the lind band at 6562.8 with band widths of 12.0     
 Halpha12mask         tinyint NOT NULL,                         --/D Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 12.0     
 Halpha24side         real NOT NULL,      --/U Angstrom         --/D Halpha line index from local continuum at 6562.8 with band widths of 24.0     
 Halpha24cont         real NOT NULL,      --/U Angstrom         --/D Halpha line index from global continuum at 6562.8 with band widths of 24.0     
 Halpha24err          real NOT NULL,      --/U Angstrom         --/D Halpha line index error in the lind band at 6562.8 with band widths of 24.0     
 Halpha24mask         tinyint NOT NULL,                         --/D Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 24.0     
 Halpha48side         real NOT NULL,      --/U Angstrom         --/D Halpha line index from local continuum at 6562.8 with band widths of 48.0     
 Halpha48cont         real NOT NULL,      --/U Angstrom         --/D Halpha line index from global continuum at 6562.8 with band widths of 48.0     
 Halpha48err          real NOT NULL,      --/U Angstrom         --/D Halpha line index error in the lind band at 6562.8 with band widths of 48.0     
 Halpha48mask         tinyint NOT NULL,                         --/D Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 48.0     
 Halpha70side         real NOT NULL,      --/U Angstrom         --/D Halpha line index from local continuum at 6562.8 with band widths of 70.0     
 Halpha70cont         real NOT NULL,      --/U Angstrom         --/D Halpha line index from global continuum at 6562.8 with band widths of 70.0     
 Halpha70err          real NOT NULL,      --/U Angstrom         --/D Halpha line index error in the lind band at 6562.8 with band widths of 70.0     
 Halpha70mask         tinyint NOT NULL,                         --/D Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 70.0     
 CaHside               real NOT NULL,      --/U Angstrom         --/D CaH line index from local continuum at 6788.0 with band widths of 505.0     
 CaHcont               real NOT NULL,      --/U Angstrom         --/D CaH line index from global continuum at 6788.0 with band widths of 505.0     
 CaHerr                real NOT NULL,      --/U Angstrom         --/D CaH line index error in the lind band at 6788.0 with band widths of 505.0     
 CaHmask               tinyint NOT NULL,                         --/D CaH pixel quality check =0, good, =1 bad at 6788.0 with band widths of 505.0     
 TiOside               real NOT NULL,      --/U Angstrom         --/D TiO line index from local continuum at 7209.0 with band widths of 333.3     
 TiOcont               real NOT NULL,      --/U Angstrom         --/D TiO line index from global continuum at 7209.0 with band widths of 333.3     
 TiOerr                real NOT NULL,      --/U Angstrom         --/D TiO line index error in the lind band at 7209.0 with band widths of 333.3     
 TiOmask               tinyint NOT NULL,                         --/D TiO pixel quality check =0, good, =1 bad at 7209.0 with band widths of 333.3     
 CNside                real NOT NULL,      --/U Angstrom         --/D CN line index from local continuum at 6890.0 with band widths of 26.0     
 CNcont                real NOT NULL,      --/U Angstrom         --/D CN line index from global continuum at 6890.0 with band widths of 26.0     
 CNerr                 real NOT NULL,      --/U Angstrom         --/D CN line index error in the lind band at 6890.0 with band widths of 26.0     
 CNmask                tinyint NOT NULL,                         --/D CN pixel quality check =0, good, =1 bad at 6890.0 with band widths of 26.0     
 OItripside            real NOT NULL,      --/U Angstrom         --/D O I triplet line index from local continuu at 7775.0 with band widths of 30.0     
 OItripcont            real NOT NULL,      --/U Angstrom         --/D O I triplet line index from global continuum at 7775.0 with band widths of 30.0     
 OItriperr             real NOT NULL,      --/U Angstrom         --/D O I triplet line index error in the lind band at 7775.0 with band widths of 30.0     
 OItripmask            tinyint NOT NULL,                         --/D O I triplet pixel quality check =0, good, =1 bad at 7775.0 with band widths of 30.0     
 KI34side             real NOT NULL,      --/U Angstrom         --/D K I line index from local continuum at 7687.0 with band widths of 34.0     
 KI34cont             real NOT NULL,      --/U Angstrom         --/D K I line index from global continuum at 7687.0 with band widths of 34.0     
 KI34err              real NOT NULL,      --/U Angstrom         --/D K I line index error in the lind band at 7687.0 with band widths of 34.0     
 KI34mask             tinyint NOT NULL,                         --/D K I pixel quality check =0, good, =1 bad at 7687.0 with band widths of 34.0     
 KI95side             real NOT NULL,      --/U Angstrom         --/D K I line index from local continuum at 7688.0 with band widths of 95.0     
 KI95cont             real NOT NULL,      --/U Angstrom         --/D K I line index from global continuum at 7688.0 with band widths of 95.0     
 KI95err              real NOT NULL,      --/U Angstrom         --/D K I line index error in the lind band at 7688.0 with band widths of 95.0     
 KI95mask             tinyint NOT NULL,                         --/D K I pixel quality check =0, good, =1 bad at 7688.0 with band widths of 95.0     
 NaI15side            real NOT NULL,      --/U Angstrom         --/D Na I line index from local continuum at 8187.5 with band widths of 15.0     
 NaI15cont            real NOT NULL,      --/U Angstrom         --/D Na I line index from global continuum at 8187.5 with band widths of 15.0     
 NaI15err             real NOT NULL,      --/U Angstrom         --/D Na I line index error in the lind band at 8187.5 with band widths of 15.0     
 NaI15mask            tinyint NOT NULL,                         --/D Na I pixel quality check =0, good, =1 bad at 8187.5 with band widths of 15.0     
 NaIredside            real NOT NULL,      --/U Angstrom         --/D Na I line index from local continuum at 8190.2 with band widths of 33.0     
 NaIredcont            real NOT NULL,      --/U Angstrom         --/D Na I line index from global continuum at 8190.2 with band widths of 33.0     
 NaIrederr             real NOT NULL,      --/U Angstrom         --/D Na I line index error in the lind band at 8190.2 with band widths of 33.0     
 NaIredmask            tinyint NOT NULL,                         --/D Na I pixel quality check =0, good, =1 bad at 8190.2 with band widths of 33.0     
 CaII26side           real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8498.0 with band widths of 26.0     
 CaII26cont           real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8498.0 with band widths of 26.0     
 CaII26err            real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8498.0 with band widths of 26.0     
 CaII26mask           tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8498.0 with band widths of 26.0     
 Paschen13side        real NOT NULL,      --/U Angstrom      --/D Paschen line index from local continuum at 8467.5 with band widths of 13.0     
 Paschen13cont        real NOT NULL,      --/U Angstrom      --/D Paschen line index from global continuum at 8467.5 with band widths of 13.0     
 Paschen13err         real NOT NULL,      --/U Angstrom      --/D Paschen line index error in the lind band at 8467.5 with band widths of 13.0     
 Paschen13mask        tinyint NOT NULL,                      --/D Paschen pixel quality check =0, good, =1 bad at 8467.5 with band widths of 13.0     
 CaII29side           real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8498.5 with band widths of 29.0     
 CaII29cont           real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8498.5 with band widths of 29.0     
 CaII29err            real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8498.5 with band widths of 29.0     
 CaII29mask           tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8498.5 with band widths of 29.0     
 CaII401side         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8542.0 with band widths of 40.0     
 CaII401cont         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8542.0 with band widths of 40.0     
 CaII401err          real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8542.0 with band widths of 40.0     
 CaII401mask         tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8542.0 with band widths of 40.0     
 CaII161side         real NOT NULL,      --/U Angstrom      --/D Ca II triplet_1 line index from local continuum at 8542.0 with band widths of 16.0     
 CaII161cont         real NOT NULL,      --/U Angstrom      --/D Ca II triplet_1 line index from global continuum at 8542.0 with band widths of 16.0     
 CaII161err          real NOT NULL,      --/U Angstrom      --/D Ca II triplet_1 line index error in the lind band at 8542.0 with band widths of 16.0     
 CaII161mask         tinyint NOT NULL,                      --/D Ca II triplet_1 pixel quality check =0, good, =1 bad at 8542.0 with band widths of 16.0     
 Paschen421side      real NOT NULL,      --/U Angstrom      --/D Paschen line index from local continuum at 8598.0 with band widths of 42.0     
 Paschen421cont      real NOT NULL,      --/U Angstrom      --/D Paschen line index from global continuum at 8598.0 with band widths of 42.0     
 Paschen421err       real NOT NULL,      --/U Angstrom      --/D Paschen line index error in the lind band at 8598.0 with band widths of 42.0     
 Paschen421mask      tinyint NOT NULL,                      --/D Paschen pixel quality check =0, good, =1 bad at 8598.0 with band widths of 42.0     
 CaII162side         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8662.1 with band widths of 16.0     
 CaII162cont         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8662.1 with band widths of 16.0     
 CaII162err          real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8662.1 with band widths of 16.0     
 CaII162mask         tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8662.1 with band widths of 16.0     
 CaII402side         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8662.0 with band widths of 40.0     
 CaII402cont         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8662.0 with band widths of 40.0     
 CaII402err          real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8662.0 with band widths of 40.0     
 CaII402mask         tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8662.0 with band widths of 40.0     
 Paschen422side      real NOT NULL,      --/U Angstrom      --/D Paschen line index from local continuum at 8751.0 with band widths of 42.0     
 Paschen422cont      real NOT NULL,      --/U Angstrom      --/D Paschen line index from global continuum at 8751.0 with band widths of 42.0     
 Paschen422err       real NOT NULL,      --/U Angstrom      --/D Paschen line index error in the lind band at 8751.0 with band widths of 42.0     
 Paschen422mask      tinyint NOT NULL,                      --/D Paschen pixel quality check =0, good, =1 bad at 8751.0 with band widths of 42.0     
 TiO5side              real NOT NULL,                       --/D TiO5 line index from local continuum at 7134.4 with band widths of 5.0     
 TiO5cont              real NOT NULL,                       --/D TiO5 line index from global continuum at 7134.4 with band widths of 5.0     
 TiO5err               real NOT NULL,                       --/D TiO5 line index error in the lind band at 7134.4 with band widths of 5.0     
 TiO5mask              tinyint NOT NULL,                    --/D TiO5 pixel quality check =0, good, =1 bad at 7134.4 with band widths of 5.0     
 TiO8side              real NOT NULL,                       --/D TiO8 line index from local continuum at 8457.3 with band widths of 30.0     
 TiO8cont              real NOT NULL,                       --/D TiO8 line index from global continuum at 8457.3 with band widths of 30.0     
 TiO8err               real NOT NULL,                       --/D TiO8 line index error in the lind band at 8457.3 with band widths of 30.0     
 TiO8mask              tinyint NOT NULL,                    --/D TiO8 pixel quality check =0, good, =1 bad at 8457.3 with band widths of 30.0     
 CaH1side              real NOT NULL,                       --/D CaH1 line index from local continuum at 6386.7 with band widths of 10.0     
 CaH1cont              real NOT NULL,                       --/D CaH1 line index from global continuum at 6386.7 with band widths of 10.0     
 CaH1err               real NOT NULL,                       --/D CaH1 line index error in the lind band at 6386.7 with band widths of 10.0     
 CaH1mask              tinyint NOT NULL,                    --/D CaH1 pixel quality check =0, good, =1 bad at 6386.7 with band widths of 10.0     
 CaH2side              real NOT NULL,                       --/D CaH2 line index from local continuum at 6831.9 with band widths of 32.0     
 CaH2cont              real NOT NULL,                       --/D CaH2 line index from global continuum at 6831.9 with band widths of 32.0     
 CaH2err               real NOT NULL,                       --/D CaH2 line index error in the lind band at 6831.9 with band widths of 32.0     
 CaH2mask              tinyint NOT NULL,                    --/D CaH2 pixel quality check =0, good, =1 bad at 6831.9 with band widths of 32.0     
 CaH3side              real NOT NULL,                       --/D CaH3 line index from local continuum at 6976.9 with band widths of 30.0     
 CaH3cont              real NOT NULL,                       --/D CaH3 line index from global continuum at 6976.9 with band widths of 30.0     
 CaH3err               real NOT NULL,                       --/D CaH3 line index error in the lind band at 6976.9 with band widths of 30.0     
 CaH3mask              tinyint NOT NULL,                            --/D CaH3 pixel quality check =0, good, =1 bad at 6976.9 with band widths of 30.0     
 UVCNside              real NOT NULL,                               --/D CN line index at 3839  
 UVCNcont              real NOT NULL,                               --/D CN line index at 3839                                     
 UVCNerr               real NOT NULL,                               --/D CN line index error at 3829                              
 UVCNmask              tinyint NOT NULL,                            --/D CN pixel quality check =0, good, =1 bad at 3839         
 BLCNside              real NOT NULL,                               --/D CN line index at 4142                                  
 BLCNcont              real NOT NULL,                               --/D CN line index at 4142                                     
 BLCNerr               real NOT NULL,                               --/D CN line index error at 4142                              
 BLCNmask              tinyint NOT NULL,                            --/D CN pixel quality check =0, good, =1 bad at 4142              
 FEI1side              real NOT NULL,      --/U Angstrom            --/D Fe I line index at 4045.8 with band widths of 2.5         
 FEI1cont              real NOT NULL,      --/U Angstrom            --/D Fe I line index at 4045.8 with band widths of 2.5        
 FEI1err               real NOT NULL,      --/U Angstrom            --/D Fe I line index error at 4045.8 with band widths of 2.5  
 FEI1mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 4045.8 with band widths of 2.5
 FEI2side              real NOT NULL,      --/U Angstrom            --/D Fe I line index at 4063.6 with band widths of 2.0         
 FEI2cont              real NOT NULL,      --/U Angstrom            --/D Fe I line index at 4063.6 with band widths of 2.0        
 FEI2err               real NOT NULL,      --/U Angstrom            --/D Fe I line index error at 4063.6 with band widths of 2.0  
 FEI2mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 4063.6 with band widths of 2.0 
 FEI3side              real NOT NULL,     --/U Angstrom             --/D Fe I line index at 4071.7 with band widths of 2.0         
 FEI3cont              real NOT NULL,     --/U Angstrom             --/D Fe I line index at 4071.7 with band widths of 2.0        
 FEI3err               real NOT NULL,     --/U Angstrom             --/D Fe I line index error at 4071.7 with band widths of 2.0   
 FEI3mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 4071.7 with band widths of 2.0 
 SRII2side              real NOT NULL,     --/U Angstrom             --/D Sr II line index at 4077.7 with band widths of 2.0        
 SRII2cont              real NOT NULL,     --/U Angstrom             --/D Sr II line index at 4077.7 with band widths of 2.0        
 SRII2err               real NOT NULL,     --/U Angstrom             --/D Sr II line index error at 4077.7 with band widths of 2.0   
 SRII2mask              tinyint NOT NULL,                            --/D Sr II pixel quality check =0, good, =1 bad at 4077.7 with band widths of 2.0
 FEI4side              real NOT NULL,                               --/D Fe I line index at 4679.5 with band widths of 87.0        
 FEI4cont              real NOT NULL,                               --/D Fe I line index at 4679.5 with band widths of 87.0        
 FEI4err               real NOT NULL,                               --/D Fe I line index error at 4679.5 with band widths of 87.0   
 FEI4mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 4679.5 with band widths of 87.0
 FEI5side              real NOT NULL,                               --/D Fe I line index at 5267.4 with band widths of 38.8        
 FEI5cont              real NOT NULL,                               --/D Fe I line index at 5267.4 with band widths of 38.8        
 FEI5err               real NOT NULL,                               --/D Fe I line index error at 5267.4 with band widths of 38.8   
 FEI5mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 5267.4 with band widths of 38.8
)

GO
--
---====================================================================================================================================

IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sppParams')
	DROP TABLE sppParams
GO
--
EXEC spSetDefaultFileGroup 'sppParams'
GO
CREATE TABLE sppParams (
-------------------------------------------------------------------------------
--/H Contains outputs from the SEGUE Stellar Parameter Pipeline (SSPP).
-------------------------------------------------------------------------------
--/T Spectra for over 500,000 Galactic stars of all common spectral types are
--/T available with DR8. These Spectra were processed with a pipeline called the
--/T SEGUE Stellar Parameter Pipeline' (SSPP, Lee et al. 2008) that computes 
--/T standard stellar atmospheric parameters such as  [Fe/H], log g and Teff for 
--/T each star by a variety of methods. These outputs are stored in this table, and
--/T indexed on the  specObjID' key index parameter for queries joining to
--/T other tables such as specobjall and photoobjall. bestobjid is also added (and indexed?)
--/T Note that all values of -9999 indicate missing or no values.
--/T See the Sample Queries in SkyServer for examples of such queries. 
-------------------------------------------------------------------------------
  SPECOBJID            bigint NOT NULL,                      --/D id number, match in specObjAll
  BESTOBJID       bigint NOT NULL, --/D Object ID of best PhotoObj match (flux-based) --/K ID_MAIN
  ORIGOBJID       bigint NOT NULL, --/D Object ID of best PhotoObj match (position-based) --/K ID_MAIN
  TARGETOBJID            bigint NOT NULL,                      --/D targeted object ID
  PLATEID         bigint NOT NULL, --/D Database ID of Plate (match in plateX)
  sciencePrimary  smallint NOT NULL, --/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
  legacyPrimary  smallint NOT NULL, --/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
  seguePrimary  smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj) --/F specsegue
  FIRSTRELEASE    varchar(32) NOT NULL, --/D Name of first release this object was associated with
  SURVEY          varchar(32) NOT NULL, --/D Survey name
  PROGRAMNAME     varchar(32) NOT NULL, --/D Program name
  CHUNK           varchar(32) NOT NULL, --/D Chunk name
  PLATERUN        varchar(32) NOT NULL, --/D Plate drill run name
  MJD               bigint NOT NULL,                        --/D Modified Julian Date of observation                                  
  PLATE             bigint NOT NULL,                        --/D Plate number                                                
  FIBERID           bigint NOT NULL,                        --/D Fiber number (1-640) --/F fiber
  RUN2D             varchar(32) NOT NULL,                   --/D Name of 2D rerun
  RUN1D             varchar(32) NOT NULL,                   --/D Name of 1D rerun
  RUNSSPP           varchar(32) NOT NULL,                   --/D Name of SSPP rerun
  TARGETSTRING     varchar(32) NOT NULL,                   --/D ASCII translation of target selection information as determined at the time the plate was designed --/F prim_target     
  PRIMTARGET       bigint NOT NULL,                        --/D Target selection information at plate design, primary science selection (for backwards compatibility) --/F primtarget
  SECTARGET        bigint NOT NULL,                        --/D Target selection information at plate design, secondary/qa/calib selection  (for backwards compatibility)
  LEGACY_TARGET1   bigint NOT NULL,                        --/D Legacy target selection information at plate design, primary science selection --/F legacy_target1
  LEGACY_TARGET2   bigint NOT NULL,                        --/D Legacy target selection information at plate design, secondary/qa/calib selection  --/F legacy_target2
  SPECIAL_TARGET1   bigint NOT NULL,                        --/D Special program target selection information at plate design, primary science selection --/F special_target1
  SPECIAL_TARGET2   bigint NOT NULL,                        --/D Special program target selection information at plate design, secondary/qa/calib selection  --/F special_target2
  SEGUE1_TARGET1   bigint NOT NULL,                        --/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1
  SEGUE1_TARGET2   bigint NOT NULL,                        --/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection  --/F segue1_target2
  SEGUE2_TARGET1   bigint NOT NULL,                        --/D SEGUE-2 target selection information at plate design, primary science selection --/F segue2_target1
  SEGUE2_TARGET2   bigint NOT NULL,                        --/D SEGUE-2 target selection information at plate design, secondary/qa/calib selection  --/F segue2_target2
  SPECTYPEHAMMER    varchar(32) NOT NULL,                   --/D Spectral Type from HAMMER                                                 
  SPECTYPESUBCLASS  varchar(32) NOT NULL,                   --/D SpecBS sub-classification                                       
  FLAG              varchar(32) NOT NULL,                   --/D Flag with combination of four letters among BCdDEgGhHlnNSV, n=normal      
  TEFFADOP          real NOT NULL,          --/U Kelvin     --/D Adopted Teff, bi-weigth average of estimators with indicator variable of 1    
  TEFFADOPN         tinyint NOT NULL,       --/U Kelvin     --/D Number of estimators used in bi-weight average
  TEFFADOPUNC       real NOT NULL,          --/U Kelvin     --/D Error in the adopted temperature                            
  TEFFHA24          real NOT NULL,          --/U Kelvin     --/D Teff estimate from HA24                                     
  TEFFHD24          real NOT NULL,          --/U Kelvin     --/D Teff estimate from HD24                                     
  TEFFNGS1          real NOT NULL,          --/U Kelvin     --/D Teff estimate from NGS1                                     
  TEFFANNSR         real NOT NULL,          --/U Kelvin     --/D Teff estimate from ANNSR                                    
  TEFFANNRR         real NOT NULL,          --/U Kelvin     --/D Teff estimate from ANNRR                                    
  TEFFWBG           real NOT NULL,          --/U Kelvin     --/D Teff estimate from WBG                                      
  TEFFK24           real NOT NULL,          --/U Kelvin     --/D Teff estimate from k24                                      
  TEFFKI13          real NOT NULL,          --/U Kelvin     --/D Teff estimate from ki13                                     
  TEFFHA24IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good
  TEFFHD24IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                       
  TEFFNGS1IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFANNSRIND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFANNRRIND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFWBGIND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFK24IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFKI13IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFHA24UNC       real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from HA24                            
  TEFFHD24UNC       real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from HD24                            
  TEFFNGS1UNC       real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from NGS1                            
  TEFFANNSRUNC      real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from ANNSR                           
  TEFFANNRRUNC      real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from ANNRR                           
  TEFFWBGUNC        real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from WBG                             
  TEFFK24UNC        real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from k24                             
  TEFFKI13UNC       real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from ki13                            
  LOGGADOP          real NOT NULL,          --/U dex        --/D Adopted log g, bi-weigth average of estimators with indicator variable of 2   
  LOGGADOPN         tinyint NOT NULL,                       --/D Number of log g estimators in used bi-weight average                         
  LOGGADOPUNC       real NOT NULL,          --/U dex        --/D Error in the adopted log g                                  
  LOGGNGS2          real NOT NULL,          --/U dex        --/D log g estimate from NGS2                                    
  LOGGNGS1          real NOT NULL,          --/U dex        --/D log g estimate from NGS1                                    
  LOGGANNSR         real NOT NULL,          --/U dex        --/D log g estimate from ANNSR                        
  LOGGANNRR         real NOT NULL,          --/U dex        --/D log g estimate from ANNRR                                   
  LOGGCAI1          real NOT NULL,          --/U dex        --/D log g estimate from CaI1                                    
  LOGGWBG           real NOT NULL,          --/U dex        --/D log g estimate from WBG                                     
  LOGGK24           real NOT NULL,          --/U dex        --/D log g estimate from k24                                     
  LOGGKI13          real NOT NULL,          --/U dex        --/D log g estimate from ki13                                    
  LOGGNGS2IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGNGS1IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGANNSRIND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGANNRRIND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGCAI1IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGWBGIND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGK24IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                         
  LOGGKI13IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGNGS2UNC       real NOT NULL,          --/U dex        --/D Error in log g estimate from NGS2                           
  LOGGNGS1UNC       real NOT NULL,          --/U dex        --/D Error in log g estimate from NGS1                           
  LOGGANNSRUNC      real NOT NULL,          --/U dex        --/D Error in log g estimate from ANNSR                          
  LOGGANNRRUNC      real NOT NULL,          --/U dex        --/D Error in log g estimate from ANNRR                          
  LOGGCAI1UNC       real NOT NULL,          --/U dex        --/D Error in log g estimate from CaI1                           
  LOGGWBGUNC        real NOT NULL,          --/U dex        --/D Error in log g estimate from WBG                            
  LOGGK24UNC        real NOT NULL,          --/U dex        --/D Error in log g estimate from k24                            
  LOGGKI13UNC       real NOT NULL,          --/U dex        --/D Error in log g estimate from ki13                           
  FEHADOP           real NOT NULL,          --/U dex        --/D Adopted [Fe/H], bi-weigth average of estimators with indicator variable of 2
  FEHADOPN          tinyint NOT NULL,                       --/D Number of estimators used in bi-weight average                                
  FEHADOPUNC        real NOT NULL,          --/U dex        --/D Error in the adopted [Fe/H]                                 
  FEHNGS2           real NOT NULL,          --/U dex        --/D [Fe/H] estimate from NGS2                                   
  FEHNGS1           real NOT NULL,          --/U dex        --/D [Fe/H] estimate from NGS1                                   
  FEHANNSR          real NOT NULL,          --/U dex        --/D [Fe/H] estimate from ANNSR                                  
  FEHANNRR          real NOT NULL,          --/U dex        --/D [Fe/H] estimate from ANNRR                                  
  FEHCAIIK1         real NOT NULL,          --/U dex        --/D [Fe/H] estimate from CaIIK1                                 
  FEHCAIIK2         real NOT NULL,          --/U dex        --/D [Fe/H] estimate from CaIIK2                                 
  FEHCAIIK3         real NOT NULL,          --/U dex        --/D [Fe/H] estimate from CaIIK3                                 
  FEHWBG            real NOT NULL,          --/U dex        --/D [Fe/H] estimate from WBG                                    
  FEHK24            real NOT NULL,          --/U dex        --/D [Fe/H] estimate from k24                                    
  FEHKI13           real NOT NULL,          --/U dex        --/D [Fe/H] estimate from ki13                                   
  FEHNGS2IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHNGS1IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHANNSRIND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHANNRRIND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHCAIIK1IND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHCAIIK2IND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHCAIIK3IND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHWBGIND         tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHK24IND         tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good 
  FEHKI13IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good
  FEHNGS2UNC        real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from NGS2                          
  FEHNGS1UNC        real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from NGS1                          
  FEHANNSRUNC       real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from ANNSR                         
  FEHANNRRUNC       real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from ANNRR                         
  FEHCAIIK1UNC      real NOT NULL,          --/U dex        --/D Error in [Fe/H] estiimate from CaIIK1                       
  FEHCAIIK2UNC      real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from CaIIK2                        
  FEHCAIIK3UNC      real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from CaIIK3                        
  FEHWBGUNC         real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from WBG                           
  FEHK24UNC         real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from k24                           
  FEHKI13UNC        real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from ki13                          
  SNR               real NOT NULL,                          --/D Average S/N per pixel over 4000 - 8000 A                    
  QA                tinyint NOT NULL,                       --/D Quality check on spectrum, depending on S/N 
  CCCAHK            real NOT NULL,                          --/D Correlation coefficient over 3850-4250 A                    
  CCMGH             real NOT NULL,                          --/D Correlation coefficient over 4500-5500 A                  
  TEFFSPEC          real NOT NULL,          --/U Kelvin     --/D Spectroscopically determined Teff, color independent   
  TEFFSPECN         tinyint NOT NULL,                       --/D Number of estimators used in average                   
  TEFFSPECUNC       real NOT NULL,          --/U Kelvin     --/D Error in the spectroscopically determined Teff         
  LOGGSPEC          real NOT NULL,          --/U dex        --/D Spectroscopically determined log g, color independent  
  LOGGSPECN         tinyint NOT NULL,                       --/D Number of estimators used in average                   
  LOGGSPECUNC       real NOT NULL,          --/U dex        --/D Error in the spectroscopically determined log g        
  FEHSPEC           real NOT NULL,          --/U dex        --/D Spectroscopically determined [Fe/H], color independent 
  FEHSPECN          tinyint NOT NULL,                       --/D Number of estimators used in average                   
  FEHSPECUNC        real NOT NULL,          --/U dex        --/D Error in the spectroscopically determined [Fe/H]       
  ACF1              real NOT NULL,                          --/D Auto-Correlation Function over 4000-4086/4116-4325/4355-4500         
  ACF1SNR           real NOT NULL,                          --/D Average signal-to-noise ratio in Auto-Correlation Function 1 (ACF1)      
  ACF2              real NOT NULL,                          --/D Auto-Correlation Functioin over 4000-4086/4116-4280/4280-4500         
  ACF2SNR           real NOT NULL,                          --/D Average signal-to-noise ratio in Auto-Correlation Function 2 (ACF2)      
  INSPECT           varchar(32) NOT NULL,                   --/D Flag with combination of six letters among FTtMmCn, for inspecting spectra  
  ELODIERVFINAL     real NOT NULL,            --/U km/s      --/D Velocity as measured by Elodie library templates, converted to km/s and with the empirical 7.3 km/s offset applied (see Yanny et al. 2009, AJ, 137, 4377)
  ELODIERVFINALERR  real NOT NULL,            --/U km/s      --/D Uncertainty in the measured Elodie RV, as determined from the chisq template-fitting routine.  See the discussion of empirically-determined velocity errors in Yanny et al. 2009, AJ, 137, 4377
  ZWARNING          bigint NOT NULL,                         --/D Warning flags about velocity/redshift determinations 
  TEFFIRFM           real NOT NULL,            --/U Kelvin    --/D Teff from Infrared Flux Methods (IRFM)
  TEFFIRFMIND       tinyint NOT NULL,                        --/D Indicator variable, = 0 bad, = 1 good
  TEFFIRFMUNC       real NOT NULL,            --/U dex       --/D Error in Teff estimate from IRFM
  LOGGNGS1IRFM      real NOT NULL,           --/U dex       --/D log g estimate from NGS1 while fixing Teff from IRFM 
  LOGGNGS1IRFMIND  tinyint NOT NULL,                      --/D Indicator variable, = 0 bad, =1 good
  LOGGNGS1IRFMUNC  real NOT NULL,            --/U dex     --/D Error in log g from NGS1 while fixing Teff from IRFM
  FEHNGS1IRFM       real NOT NULL,           --/U dex      --/D [Fe/H] estimate from NGS1 while fixing Teff from IRFM
  FEHNGS1IRFMIND   tinyint NOT NULL,                      --/D Indicator variable, =0 bad, = 1 good
  FEHNGS1IRFMUNC   real NOT NULL,            --/U dex     --/D  Error in [Fe/H] from NGS1 while fixing Teff from IRFM
  LOGGCAI1IRFM      real NOT NULL,            --/U dex     --/D log g estimate from CAI1 with fixed IRFM Teff
  LOGGCAI1IRFMIND  tinyint NOT NULL,                      --/D Indicator variable,  =0 bad, = 1 good
  LOGGCAI1IRFMUNC  real NOT NULL,            --/U dex     --/D Error in log g from CAI1 with fixed IRFM Teff
  FEHCAIIK1IRFM     real NOT NULL,            --/U dex     --/D [Fe/H] from CaIIK1 with fixed IRFM Teff
  FEHCAIIK1IRFMIND tinyint NOT NULL,                      --/D Indicator variable, =0 bad, = 1 good
  FEHCAIIK1IRFMUNC real NOT NULL,            --/U dex     --/D Error in [Fe/H] from CaIIK1 with fixed IRFM Teff
)                                                                                                     
GO



