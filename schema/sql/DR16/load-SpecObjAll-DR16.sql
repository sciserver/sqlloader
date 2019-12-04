



drop table SpecObjAll
go

CREATE TABLE SpecObjAll (
-------------------------------------------------------------------------------
--/H Contains the measured parameters for a spectrum.
--
--/T This is a base table containing <b>ALL</b> the spectroscopic
--/T information, including a lot of duplicate and bad data. Use
--/T the <b>SpecObj</b> view instead, which has the data properly
--/T filtered for cleanliness. These tables contain both the BOSS
--/T and SDSS spectrograph data.
--/T NOTE: The RA and Dec in this table refer to the DR8 coordinates,
--/T which have errors in the region north of 41 deg in Dec.
--/T This change does not affect the matching to the photometric
--/T catalog.

-------------------------------------------------------------------------------
  specObjID       numeric(20,0) NOT NULL, --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D --/K ID_CATALOG
  bestObjID       bigint NOT NULL, --/D Object ID of photoObj match (position-based) --/K ID_MAIN
  fluxObjID       bigint NOT NULL, --/D Object ID of photoObj match (flux-based) --/K ID_MAIN
  targetObjID     bigint NOT NULL, --/D Object ID of original target --/K ID_CATALOG
  plateID         numeric(20,0) NOT NULL, --/D Database ID of Plate 
  sciencePrimary  smallint NOT NULL, --/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
  sdssPrimary     smallint NOT NULL, --/D Best version of spectrum at this location among SDSS plates (defines default view SpecObj) --/F specsdss
  legacyPrimary   smallint NOT NULL, --/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
  seguePrimary    smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE plates --/F specsegue
  segue1Primary   smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE-1 plates --/F specsegue1
  segue2Primary   smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE-2 plates --/F specsegue2
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
  legacy_target1   bigint NOT NULL, --/D for Legacy program, target selection information at plate design --/F legacy_target1  --/R PrimTarget
  legacy_target2   bigint NOT NULL, --/D for Legacy program target selection information at plate design, secondary/qa/calibration --/F legacy_target2  --/R SecTarget
  special_target1  bigint NOT NULL, --/D for Special program target selection information at plate design --/F special_target1  --/R SpecialTarget1
  special_target2  bigint NOT NULL, --/D for Special program target selection information at plate design, secondary/qa/calibration --/F special_target2  --/R SpecialTarget2
  segue1_target1   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1  --/R Segue1Target1
  segue1_target2   bigint NOT NULL, --/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection --/F segue1_target2  --/R Segue1Target2
  segue2_target1   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, primary science selection --/F segue2_target1  --/R Segue2Target1
  segue2_target2   bigint NOT NULL, --/D SEGUE-2 target selection information at plate design, secondary/qa/calib selection --/F segue2_target2  --/R Segue2Target2
  boss_target1   bigint NOT NULL, --/D BOSS target selection information at plate  --/F boss_target1  --/R BossTarget1
  eboss_target0   bigint NOT NULL, --/D EBOSS target selection information, for SEQUELS plates --/F eboss_target0
  eboss_target1   bigint NOT NULL, --/D EBOSS target selection information, for eBOSS plates --/F eboss_target1
  eboss_target2   bigint NOT NULL, --/D EBOSS target selection information, for TDSS, SPIDERS, ELG, etc. plates --/F eboss_target2
  eboss_target_id bigint NOT NULL, --/D EBOSS unique target identifier for every spectroscopic target, --/F eboss_target_id
  ancillary_target1   bigint NOT NULL, --/D BOSS ancillary science target selection information at plate design --/F ancillary_target1  --/R AncillaryTarget1
  ancillary_target2   bigint NOT NULL, --/D BOSS ancillary target selection information at plate design --/F ancillary_target2  --/R AncillaryTarget2
  thing_id_targeting  bigint Not NULL, --/D thing_id value from the version of resolve from which the targeting was created --/F thing_id_targeting
  thing_id            int Not NULL, --/D Unique identifier from global resolve --/F thing_id
  primTarget       bigint NOT NULL, --/D target selection information at plate design, primary science selection (for backwards compatibility)  --/R PrimTarget
  secTarget        bigint NOT NULL, --/D target selection information at plate design, secondary/qa/calib selection  (for backwards compatibility)  --/R SecTarget
  spectrographID  smallint NOT NULL, --/D which spectrograph (1,2)  
  sourceType         varchar(128) NOT NULL,  --/D For Legacy, SEGUE-2 and BOSS science targets, type of object targeted as (target bits contain full information and are recommended)  --/R SourceType
  targetType         varchar(128) NOT NULL,  --/D Nature of target: SCIENCE, STANDARD, or SKY
  ra              float NOT NULL, --/U deg  --/D DR8 Right ascension of fiber, J2000    --/F plug_ra
  dec             float NOT NULL, --/U deg  --/D DR8 Declination of fiber, J2000     --/F plug_dec
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
  zWarning        int NOT NULL, --/D Bitmask of warning values; 0 means all is well --/R SpeczWarning 
  class           varchar(32) NOT NULL,  --/D Spectroscopic class (GALAXY, QSO, or STAR)
  subClass        varchar(32) NOT NULL,  --/D Spectroscopic subclass 
  rChi2           real NOT NULL, --/D Reduced chi-squared of best fit
  DOF             real NOT NULL, --/D Degrees of freedom in best fit
  rChi2Diff       real NOT NULL, --/D Difference in reduced chi-squared between best and second best fit
  z_noqso         real NOT NULL,  --/D Best redshift when excluding QSO fit in BOSS spectra (right redshift to use for galaxy targets) --/F z_noqso
  zErr_noqso      real NOT NULL,  --/D Error in "z_noqso" redshift (BOSS spectra only) --/F z_err_noqso
  zWarning_noqso   int NOT NULL,  --/D Warnings in "z_noqso" redshift (BOSS spectra only) --/F zwarning_noqso  --/R SpeczWarning 
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
  spectroFluxIvar_u real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto u filter
  spectroFluxIvar_g real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto g filter
  spectroFluxIvar_r real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto r filter
  spectroFluxIvar_i real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto i filter
  spectroFluxIvar_z real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of spectrum projected onto z filter
  spectroSynFluxIvar_u  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto u filter 
  spectroSynFluxIvar_g  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto g filter 
  spectroSynFluxIvar_r  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto r filter 
  spectroSynFluxIvar_i  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto i filter 
  spectroSynFluxIvar_z  real NOT NULL, --/U 1/nanomaggies^2 --/D Inverse variance of best-fit template spectrum projected onto z filter 
  spectroSkyFlux_u      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto u filter
  spectroSkyFlux_g      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto g filter
  spectroSkyFlux_r      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto r filter
  spectroSkyFlux_i      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto i filter
  spectroSkyFlux_z      real NOT NULL, --/U nanomaggies --/D Sky spectrum projected onto z filter
  anyAndMask            int NOT NULL, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK  --/R SpecPixMask
  anyOrMask             int NOT NULL, --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK  --/R SpecPixMask
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
  img		varbinary(max) NOT NULL,	--/D Spectrum Image --/K IMAGE? 

CONSTRAINT [pk_specObjAll_specObjID] PRIMARY KEY CLUSTERED 
(
	[specObjID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [SPEC]
) ON [SPEC] TEXTIMAGE_ON [SPEC]
GO

ALTER TABLE [dbo].[SpecObjAll] ADD  DEFAULT (0x1111) FOR [img]
GO



--dbcc traceon(610)
insert [SpecObjAll] with (tablock)
select * from [Besttest].dbo.[SpecObjAll] with (nolock)  --2h 49m  why didn't we put this on an ssd???
order by SpecObjID



 CREATE NONCLUSTERED INDEX [i_SpecObjAll_fluxObjID] ON [dbo].[SpecObjAll](fluxObjID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 
CREATE NONCLUSTERED INDEX [i_SpecObjAll_htmID_ra_dec_cx_cy_] ON [dbo].[SpecObjAll](htmID ASC, ra ASC, dec ASC, cx ASC, cy ASC, cz ASC, sciencePrimary ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 
CREATE NONCLUSTERED INDEX [i_SpecObjAll_ra_dec_class_plat] ON [dbo].[SpecObjAll](ra ASC, dec ASC, class ASC, plate ASC, tile ASC, z ASC, zErr ASC, sciencePrimary ASC, plateID ASC, bestObjID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 
CREATE NONCLUSTERED INDEX [i_SpecObjAll_targetObjID_sourceT] ON [dbo].[SpecObjAll](targetObjID ASC, sourceType ASC, sciencePrimary ASC, class ASC, htmID ASC, ra ASC, dec ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];



ALTER TABLE [dbo].[SpecPhotoAll]  WITH NOCHECK ADD  CONSTRAINT [fk_SpecPhotoAll_specObjID_SpecOb] FOREIGN KEY([specObjID])
REFERENCES [dbo].[SpecObjAll] ([specObjID])
GO

ALTER TABLE [dbo].[SpecPhotoAll] CHECK CONSTRAINT [fk_SpecPhotoAll_specObjID_SpecOb]
GO


update statistics SpecObjAll
