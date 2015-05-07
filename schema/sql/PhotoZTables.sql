--=============================================================================
--   PhotoZTables.sql
--   2009-04-27 Ani Thakar and Robert Beck
-------------------------------------------------------------------------------
--  Photometric Redshifts  Schema for SQL Server
--
--------------------------------------------------------------------
-- History:
--* 2015-02-09  Ani: Moved photo-z tables here from PhotoTables.sql.
--*                  Swapped in schema changes for DR12 from R.Beck.
-------------------------------------------------------------------------------



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'Photoz')
	DROP TABLE Photoz
GO
--
EXEC spSetDefaultFileGroup 'Photoz'
GO

CREATE TABLE Photoz(
-------------------------------------------------------------------------------
--/H The photometrically estimated redshifts for all objects in the GalaxyTag view.
-------------------------------------------------------------------------------
--/T Estimation is based on a robust fit on spectroscopically observed objects
--/T with similar colors and r magnitude.<br>
--/T Please see the <b>Photometric Redshifts</b> entry in Algorithms for more
--/T information about this table. <br>
--/T <i>NOTE: This table may be empty initially because the values
--/T are computed in a separate calculation after the main data release.</i>
-------------------------------------------------------------------------------
	[objID] [bigint] NOT NULL,	--/D unique ID pointing to GalaxyTag table --/K ID_MAIN
	[z] [real] NOT NULL,			--/D photometric redshift; estimated by robust fit to nearest neighbors in a reference set	--/K REDSHIFT_PHOT
	[zErr] [real] NOT NULL,			--/D estimated error of the photometric redshift; if zErr=-9999, the fit failed, but the neighbors' average redshift might still be available --/K REDSHIFT_PHOT ERROR
	[nnCount] [smallint] NOT NULL,		--/D number of nearest neighbors after excluding the outliers; maximal value is 100, a much smaller value indicates a poor estimate 	--/K NUMBER
	[nnVol] [real] NOT NULL,		--/D gives the color space bounding volume of the nnCount nearest neighbors; a large value indicates a poor estimate --/K NUMBER
	[photoErrorClass] [smallint] NOT NULL,	--/D the photometric error class of the galaxy from 1 to 7, 1 being the best; a negative value shows that the object to be estimated is outside of the k-nearest neighbor box; zErr is a reliable estimate only if photoErrorClass=1 --/K CODE_MISC
	[nnObjID] [bigint] NOT NULL,		--/D objID of the (first) nearest neighbor	--/K ID_IDENTIFIER
	[nnSpecz] [real] NOT NULL,		--/D spectroscopic redshift	of the (first) nearest neighbor --/K REDSHIFT
	[nnFarObjID] [bigint] NOT NULL,		--/D objID of the farthest neighbor		--/K ID_IDENTIFIER
	[nnAvgZ] [real] NOT NULL,		--/D average redshift of the nearest neighbors; if significantly different from z, this might be a better estimate than z	--/K REDSHIFT
	[distMod] [real] NOT NULL,		--/D the distance modulus for Omega=0.2739, Lambda=0.726, h=0.705 cosmology	--/K PHOT_DIST-MOD
	[lumDist] [real] NOT NULL,		--/D the luminosity distance in Mpc for Omega=0.2739, Lambda=0.726, h=0.705 cosmology	--/K PHOT_LUM-DIST
	[chisq] [real] NOT NULL,		--/D the chi-square value for the minimum chi-square template fit (non-reduced, 4 degrees of freedom)		--/K STAT_LIKELIHOOD
	[rnorm] [real] NOT NULL,		--/D the residual Euclidean norm value for the minimum chi-square template fit		--/K STAT_MISC
	[bestFitTemplateID] [int] NOT NULL,	--/D identifier of the best-fit template; if bestFitTemplateID=0 all the following columns are invalid and may be filled with the value -9999	--/K ID_IDENTIFIER
	[synthU] [real] NOT NULL,		--/D synthetic u' magnitude calculated from the fitted template --/K PHOT_SYNTH-MAG PHOT_SDSS_U
	[synthG] [real] NOT NULL,		--/D synthetic g' magnitude calculated from the fitted template --/K PHOT_SYNTH-MAG PHOT_SDSS_G
	[synthR] [real] NOT NULL,		--/D synthetic r' magnitude calculated from the fitted template --/K PHOT_SYNTH-MAG PHOT_SDSS_R
	[synthI] [real] NOT NULL,		--/D synthetic i' magnitude calculated from the fitted template --/K PHOT_SYNTH-MAG PHOT_SDSS_I
	[synthZ] [real] NOT NULL,		--/D synthetic z' magnitude calculated from the fitted template --/K PHOT_SYNTH-MAG PHOT_SDSS_Z
	[kcorrU] [real] NOT NULL,		--/D k correction for z=0	--/K PHOT_K-CORRECTION
	[kcorrG] [real] NOT NULL,		--/D k correction for z=0	--/K PHOT_K-CORRECTION
	[kcorrR] [real] NOT NULL,		--/D k correction for z=0	--/K PHOT_K-CORRECTION
	[kcorrI] [real] NOT NULL,		--/D k correction for z=0	--/K PHOT_K-CORRECTION
	[kcorrZ] [real] NOT NULL,		--/D k correction for z=0	--/K PHOT_K-CORRECTION
	[kcorrU01] [real] NOT NULL,		--/D k correction for z=0.1	--/K PHOT_K-CORRECTION
	[kcorrG01] [real] NOT NULL,		--/D k correction for z=0.1	--/K PHOT_K-CORRECTION
	[kcorrR01] [real] NOT NULL,		--/D k correction for z=0.1	--/K PHOT_K-CORRECTION
	[kcorrI01] [real] NOT NULL,		--/D k correction for z=0.1	--/K PHOT_K-CORRECTION
	[kcorrZ01] [real] NOT NULL,		--/D k correction for z=0.1	--/K PHOT_K-CORRECTION
	[absMagU] [real] NOT NULL,		--/D rest frame u' abs magnitude --/K PHOT_ABS-MAG PHOT_SDSS_U
	[absMagG] [real] NOT NULL,		--/D rest frame g' abs magnitude --/K PHOT_ABS-MAG PHOT_SDSS_G
	[absMagR] [real] NOT NULL,		--/D rest frame r' abs magnitude --/K PHOT_ABS-MAG PHOT_SDSS_R
	[absMagI] [real] NOT NULL,		--/D rest frame i' abs magnitude --/K PHOT_ABS-MAG PHOT_SDSS_I
	[absMagZ] [real] NOT NULL		--/D rest frame z' abs magnitude --/K PHOT_ABS-MAG PHOT_SDSS_Z
)
GO
--


--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotozErrorMap')
	DROP TABLE PhotozErrorMap
GO
--
EXEC spSetDefaultFileGroup 'PhotozErrorMap'
GO


CREATE TABLE PhotozErrorMap(
-------------------------------------------------------------------------------
--/H The error map of the photometric redshift estimation
-------------------------------------------------------------------------------
--/T This is a supplementary table to the <b>Photoz</b> table, providing information about
--/T the dependence of estimation errors on the location in color/magnitude space.<br>
--/T All numbers are based on the results of the training set, 
--/T and evaluated on a grid in r magnitude, and g-r, r-i colors. <br>
--/T <i>NOTE: This table may be empty initially because the values
--/T are computed in a separate calculation after the main data release.</i>
-------------------------------------------------------------------------------
	[CellID] [int] NOT NULL,		--/D unique ID of the cell in the grid --/K ID_MAIN
	[rMag] [real],					--/D center of the cell in the cModelMag_r magnitude, with dereddening; linear size of a cell: 0.5 	--/K PHOT_SDSS_R
	[gMag_Minus_rMag] [real],		--/D center of the cell in g-r color, using modelMag magnitudes with dereddening; linear size of a cell: 0.01 --/K PHOT_SDSS_GR_COLOR
	[rMag_Minus_iMag] [real],		--/D center of the cell in r-i color, using modelMag magnitudes with dereddening; linear size of a cell: 0.01	--/K PHOT_SDSS_RI_COLOR
	[countInCell] [int],			--/D number of training set objects in the cell; if 0, all following values are filled with -9999 --/K NUMBER
	[avgPhotoZ] [real],				--/D average of photometric redshift estimate for training set objects in the cell	--/K REDSHIFT_PHOT
	[avgSpectroZ] [real], 			--/D average of spectroscopic redshift for training set objects in the cell	--/K REDSHIFT
	[avgRMS] [real],				--/D square root of average squared error in photometric redshift estimation (PhotoZ-SpectroZ), for training set objects in the cell --/K REDSHIFT ERROR
	[avgEstimatedError] [real],		--/D average of the estimated photometric redshift error (zErr), for training set objects in the cell --/K REDSHIFT ERROR
	[avgNeighborZStDev] [real]		--/D average of the standard deviation of the k nearest neighbors' redshift, for training set objects in the cell	--/K REDSHIFT ERROR
)
GO
--



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotozRF')
	DROP TABLE PhotozRF
GO
--
EXEC spSetDefaultFileGroup 'PhotozRF'
GO


--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotozTemplateCoeff')
	DROP TABLE PhotozTemplateCoeff
GO
--
EXEC spSetDefaultFileGroup 'PhotozTemplateCoeff'
GO


--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotozRFTemplateCoeff')
	DROP TABLE PhotozRFTemplateCoeff
GO
--
EXEC spSetDefaultFileGroup 'PhotozRFTemplateCoeff'
GO

--

PRINT '[PhotoZTables.sql]: Photometric redshifts tables created'
GO

