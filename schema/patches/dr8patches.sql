-- Patches for DR8 database

USE BestDR8
GO

-- IndexMap changes:
-- Added indices for detectionIndex/thingIndex
-- Added PKs for external match tables
-- Added segueTargetAll indices
-- Photoz tables


-- Metadata updates:
-- PhotoObjAll.clean flag description (not just point sources)
-- PhotoProfile units from maggies to nanomaggies/arcsec^2

-- Added schema and data for Galaxy Zoo tables

-- Set PlateX.htmID
UPDATE PlateX 
	SET htmId = dbo.fHtmXYZ( cx, cy, cz )


-- Fix sppTargets.objid so skyVersion=1 instead of 2
UPDATE sppTargets
	SET objid=dbo.fObjidFromSDSS( 1,run,rerun,camcol,field,obj)


-- Create index on PhotoObjAll parentid,mode,type and include ugriz etc. in it
USE [BESTDR8]
GO
CREATE NONCLUSTERED INDEX [i_PhotoObjAll_parentid_mode_type] ON [dbo].[PhotoObjAll] 
(
	[parentID] ASC,
	[mode] ASC,
	[type] ASC
)
INCLUDE ( [run],
[rerun],
[camcol],
[field],
[u],
[g],
[r],
[i],
[z]) WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

-- Add IndexMap entry for above index
INSERT IndexMap Values('I','index', 'PhotoObjAll',       'parentid,mode,type'                                   ,'','PHOTO')


-- Fix bugs in fStrip[e]OfRun (replace Segment table with Run table]
ALTER FUNCTION fStripeOfRun(@run int)
-------------------------------------------------------------
--/H returns Stripe containing a particular run 
-------------------------------------------------------------
--/T <br> run is the run number
--/T <br>
--/T <samp>select top 10 objid, dbo.fStripeOfRun(run) from PhotoObj </samp>
-------------------------------------------------------------
RETURNS int as
BEGIN
  RETURN (SELECT TOP 1 [stripe] from Run where run = @run)
END
GO


--
ALTER FUNCTION fStripOfRun(@run int)
-------------------------------------------------------------
--/H returns Strip containing a particular run 
-------------------------------------------------------------
--/T <br> run is the run number
--/T <br>
--/T <samp>select top 10 objid, dbo.fStripOfRun(run) from PhotoObj </samp>
-------------------------------------------------------------
RETURNS int as
BEGIN
  RETURN (SELECT TOP 1 [strip] from Run where run = @run)
END
GO


-- Modify spMakeDiagnostics, spCheckDBObjects, spCheckDBColumns and
-- spCheckDBIndexes so there are no collation conflicts with non-latin
-- collations.
--
ALTER PROCEDURE [dbo].[spMakeDiagnostics]
-----------------------------------------------------------
--/H Creates a full diagnostic view of the database
--/A
--/T The stored procedure checks in all tables, views, functions
--/T and stored procedures into the Diagnostics table,
--/T and counts the number of rows in each table and view.
--/T <PRE> EXEC spMakeDiagnostics </PRE>
-----------------------------------------------------------
AS
BEGIN
    --
    -- clear out the table first
    --
    TRUNCATE TABLE Diagnostics;
    --
    --scan through all the user tables and views, leave out the dynamic stuff, and itself
    --
    INSERT INTO Diagnostics
    SELECT name, type, 0
	FROM sysobjects  
    	WHERE type collate latin1_general_ci_as IN ('U','V')
	    -- Object type of User-table and View
	    AND permissions (id)&4096 <> 0
	    AND name collate latin1_general_ci_as NOT IN ('QueryResults','RecentQueries','Diagnostics','SiteDiagnostics','test')
	    AND substring(name,1,3) collate latin1_general_ci_as NOT IN ('sys','dtp')
	ORDER BY type, name
    --
    -- insert all the functions and stored procedures
    --
    INSERT INTO Diagnostics
    SELECT name, type, 0
	FROM sysobjects  
    	WHERE type collate latin1_general_ci_as IN ('P', 'IF', 'FN', 'TF', 'X')	
	-- Object type of Procedure, scalar UDF, table UDF
	  and permissions (id)&32 <> 0
	  and substring(name,1,3) collate latin1_general_ci_as NOT IN
		('sp_' , 'dt_', 'xp_', 'fn_', 'MS_')
    --
    -- get the foreign keys
    --
    INSERT INTO Diagnostics
    SELECT name, type, 0 FROM sysobjects
	WHERE xtype collate latin1_general_ci_as IN ('F')
    --
    -- get the indices, which are not primary or foreign keys
    --
    INSERT INTO Diagnostics
    SELECT name, 'I' as type, 0	FROM sysindexes
	WHERE  keys is not null
	    and name collate latin1_general_ci_as NOT LIKE '%sys%'
	    and name collate latin1_general_ci_as NOT LIKE ('Statistic_%')
	    and name collate latin1_general_ci_as NOT IN (
	  	  select name from sysobjects
		  where xtype collate latin1_general_ci_as IN ('PK', 'F')
		  )

	CREATE TABLE #trows (
		table_name sysname ,
		row_count varchar(64),
		reserved_size VARCHAR(50),
		data_size VARCHAR(50),
		index_size VARCHAR(50),
		unused_size VARCHAR(50))

	SET NOCOUNT ON
	INSERT #trows 
		EXEC sp_msforeachtable 'sp_spaceused ''?'''
		
	UPDATE d
		SET d.count=CONVERT(bigint,r.row_count)
	FROM Diagnostics d JOIN #trows r on r.table_name collate latin1_general_ci_as=d.name
	WHERE d.type collate latin1_general_ci_as=N'U'    
	--
    -- load all the row counts for the tables
    --
    DECLARE mycursor CURSOR
	FOR
	    select 'UPDATE Diagnostics SET [count] = '+
		' (select count_big(*) from '+name+')'+
		' WHERE name = N''' + name + ''''
	    from Diagnostics 
	    where type collate latin1_general_ci_as = N'V'
    OPEN mycursor
    DECLARE @cmd sysname
    FETCH NEXT FROM mycursor INTO @cmd
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
	EXEC (@cmd)
	FETCH NEXT FROM mycursor INTO @cmd
    END
    DEALLOCATE mycursor
END
GO


ALTER PROCEDURE [dbo].[spCheckDBObjects]
---------------------------------------
--/H Check for a mismatch between the db objects and documentation
--/A
--/T Comapres the all the objects in sysobjects to
--/T the list stored in DBObjects. Returns the number
--/T of mismatches. It has no parameters.
--/T <samp>  exec spCheckDBObjects</samp>
---------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #indbobjects (
		[name] varchar(64),
		type varchar(64),
		found varchar(16)
	)
	--
	CREATE TABLE #diff (
		[name] varchar(64),
		type varchar(64),
		found varchar(16)
	)
	--
	INSERT #indbobjects
	    SELECT name, xtype as type, 'in DB' as found
		FROM sysobjects WITH (nolock)
		WHERE xtype collate latin1_general_ci_as =N'U'   
		    and name collate latin1_general_ci_as not like 'dt%'
	--
	INSERT #indbobjects
	    SELECT name, xtype as type, 'in DB' as found 
		FROM sysobjects WITH (nolock)
		WHERE xtype collate latin1_general_ci_as =N'V' 
		    and name collate latin1_general_ci_as not like N'sys%'
	--
	INSERT #indbobjects
	    SELECT name, xtype as type, 'in DB' as found 
		FROM sysobjects WITH (nolock)
		WHERE xtype=N'P' 
		    and name collate latin1_general_ci_as not like N'dt_%'
	--
	INSERT #indbobjects
	    SELECT name, 'F' as type, 'in DB' as found 
		FROM sysobjects WITH (nolock)
		WHERE xtype collate latin1_general_ci_as  in (N'FN' ,N'TF', N'FS', N'FT')
	--
	INSERT #diff
	SELECT i.name, i.type, found
	    FROM #indbobjects i
	    WHERE i.name collate latin1_general_ci_as not in (
		select name from DBobjects WITH (nolock)
		where type=i.type collate latin1_general_ci_as 
		)
	--
	INSERT #diff
	SELECT o.name, o.type, 'in schema' as found
	    FROM DBObjects o WITH (nolock)
	    WHERE o.name collate latin1_general_ci_as not in (
		select name from #indbobjects
		where type=o.type collate latin1_general_ci_as 
		)
	--
	SELECT * FROM #diff
	    ORDER BY found, type, name
	--
	DECLARE @count int;
	SELECT @count=count(*) FROM #diff
	--
	RETURN @count;
END
GO



ALTER PROCEDURE [dbo].[spCheckDBColumns]
---------------------------------------
--/H Check for a mismatch between the db columns and documentation
--/A
--/T Comapres the columns of tables in syscolumns to
--/T the list stored in DBColumns. Returns the number
--/T of mismatches. It has no parameters.
--/T <samp>  exec spCheckDBColumns</samp>
---------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #indbcolumns (
		tablename varchar(64),
		name	  varchar(64),
		found	varchar(64)
	)
	--
	INSERT #indbcolumns
	SELECT	o.name as tablename, c.name, 'in DB' as found
	    FROM sysobjects o, syscolumns c WITH (nolock)
	    WHERE o.xtype collate latin1_general_ci_as = N'U' 
		AND o.name collate latin1_general_ci_as not like 'dt%'
		AND c.id = o.id
	--
	CREATE TABLE #diff (
		tablename varchar(64),
		name	  varchar(64),
		found	varchar(64)
	)
	--
	INSERT #diff
	SELECT d.tablename as obj, d.name, 'in schema' as found
	    FROM DBColumns d WITH (nolock)
    	    WHERE  d.name collate latin1_general_ci_as not in (
		SELECT name FROM #indbcolumns
		WHERE tablename collate latin1_general_ci_as = d.tablename  collate latin1_general_ci_as
	    )
	------
	INSERT #diff
	SELECT o.tablename as obj, o.name, o.found FROM #indbcolumns o
	    WHERE o.name collate latin1_general_ci_as NOT IN (
		SELECT name FROM DBColumns WITH (nolock)
		WHERE  tableName collate latin1_general_ci_as =o.tablename collate latin1_general_ci_as
	    )

	DECLARE @count int;
	SELECT @count=count(*) FROM #diff
	SELECT * FROM #diff
	RETURN @count;
END
GO


-- Drop FieldQA and RunQA tables
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'FieldQA')
DROP TABLE FieldQA
GO

IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'RunQA')
DROP TABLE RunQA
GO


-- Add SEGUE specObjAll views
--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[segue1SpecObjAll]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[segue1SpecObjAll]
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
CREATE VIEW segue1SpecObjAll
---------------------------------------------------------------
--/H A view of specObjAll that includes only SEGUE1 spectra
--
--/T The view excludes spectra that are not part of the SEGUE1 program.
---------------------------------------------------------------
AS
SELECT s.* 
	FROM specObjAll s JOIN plateX p ON s.plateId = p.plateId
	WHERE p.programName like 'seg%' and p.programName not like 'segue2%'
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[segue2SpecObjAll]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[segue2SpecObjAll]
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
CREATE VIEW segue2SpecObjAll
---------------------------------------------------------------
--/H A view of specObjAll that includes only SEGUE2 spectra
--
--/T The view excludes spectra that are not part of the SEGUE2 program.
---------------------------------------------------------------
AS
SELECT s.* 
	FROM specObjAll s JOIN plateX p ON s.plateId = p.plateId
	WHERE p.programName like 'segue2%'
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[segueSpecObjAll]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[segueSpecObjAll]
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
CREATE VIEW segueSpecObjAll
---------------------------------------------------------------
--/H A view of specObjAll that includes only SEGUE1+SEGUE2 spectra
--
--/T The view excludes spectra that are not part of the SEGUE1
--/T or SEGUE2 programs.
---------------------------------------------------------------
AS
SELECT s.* 
	FROM specObjAll s JOIN plateX p ON s.plateId = p.plateId
	WHERE p.programName like 'seg%'
GO



-- Photozs
If EXISTS (SELECT * FROM dbo.sysobjects 
	WHERE ID = Object_ID(N'[Photoz2]') 
	AND OBJECTPROPERTY(ID, N'IsUserTable') = 1)
DROP TABLE [Photoz2]
GO


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
--/H The photometrically estimated redshifts for all objects in the Galaxy view.
-------------------------------------------------------------------------------
--/T Estimation is based on a robust fit on spectroscopically observed objects
--/T with similar colors and inclination angle.<br>
--/T Please see the <b>Photometric Redshifts</b> entry in Algorithms for more
--/T information about this table. <br>
--/T <i>NOTE: This table may be empty initially because the photoz values
--/T are computed in a separate calculation after the main data release.</i>
-------------------------------------------------------------------------------
	[objID] [bigint] NOT NULL,		--/D unique ID pointing to Galaxy table --/K ID_MAIN
	[z] [real] NOT NULL,			--/D photometric redshift; estimated by robust fit to nearest neighbors in a reference set	--/K REDSHIFT_PHOT
	[zErr] [real] NOT NULL,			--/D estimated error of the photometric redshift; if zErr=-1000, all the proceeding columns are invalid	--/K REDSHIFT_PHOT ERROR
	[nnCount] [smallint] NOT NULL,		--/D nearest neighbors after excluding the outliers; maximal value is 100, much smaller value indicates poor estimate 	--/K NUMBER
	[nnVol] [real] NOT NULL,		--/D gives the color space bounding volume of the nnCount nearest neighbors; large value indicates poor estimate --/K NUMBER
	[nnIsInside] [smallint] NOT NULL,	--/D shows if the object to be estimated is inside of the k-nearest neighbor box; 0 indicates poor estimate	--/K CODE_MISC
	[nnObjID] [bigint] NOT NULL,		--/D objID of the (first) nearest neighbor	--/K ID_IDENTIFIER
	[nnSpecz] [real] NOT NULL,		--/D spectroscopic redshift	of the (first) nearest neighbor --/K REDSHIFT
	[nnFarObjID] [bigint] NOT NULL,		--/D objID of the farthest neighbor		--/K ID_IDENTIFIER
	[nnAvgZ] [real] NOT NULL,		--/D average redshift of the nearest neighbors; if singificantly different from z, this might be a better estimate than z	--/K REDSHIFT
	[distMod] [real] NOT NULL,		--/D the distance modulus for Omega=0.3, Lambda=0.7 cosmology	--/K PHOT_DIST-MOD
	[lumDist] [real] NOT NULL,		--/D the luminosity distance for Omega=0.3, Lambda=0.7 cosmology	--/K PHOT_LUM-DIST
	[chisq] [real] NOT NULL,		--/D the chi-square value for the best NNLS template fit		--/K STAT_LIKELIHOOD
	[rnorm] [real] NOT NULL,		--/D the residual norm value for the best NNLS template fit		--/K STAT_MISC
	[nTemplates] [int] NOT NULL,	--/D number of templates used in the fitting; if nTemplates=0 all the proceeding columns are invalid and may be filled with value -9999	--/K NUMBER
	[synthU] [real] NOT NULL,		--/D synthetic u' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_U
	[synthG] [real] NOT NULL,		--/D synthetic g' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_G
	[synthR] [real] NOT NULL,		--/D synthetic r' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_R
	[synthI] [real] NOT NULL,		--/D synthetic i' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_I
	[synthZ] [real] NOT NULL,		--/D synthetic z' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_Z
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
         WHERE xtype='U' AND name = 'PhotozRF')
	DROP TABLE PhotozRF
GO
--
EXEC spSetDefaultFileGroup 'PhotozRF'
GO

CREATE TABLE PhotozRF(
-------------------------------------------------------------------------------
--/H The photometrically estimated redshifts for all objects in the Galaxy view.
-------------------------------------------------------------------------------
--/T Estimates are based on the Random Forest technique.<br>
--/T Please see the <b>Photometric Redshifts</b> entry in Algorithms for more
--/T information about this table. <br>
--/T <i>NOTE: This table may be empty initially because the photoz values
--/T are computed in a separate calculation after the main data release.</i>
-------------------------------------------------------------------------------
	[objID] [bigint] NOT NULL,		--/D unique ID pointing to Galaxy table --/K ID_MAIN
	[z] [real] NOT NULL,			--/D photometric redshift; estimated by the Random Forest method	--/K REDSHIFT_PHOT
	[zErr] [real] NOT NULL,			--/D estimated error of the photometric redshift	--/K REDSHIFT_PHOT ERROR
	[distMod] [real] NOT NULL,		--/D the distance modulus for Omega=0.3, Lambda=0.7 cosmology	--/K PHOT_DIST-MOD
	[lumDist] [real] NOT NULL,		--/D the luminosity distance for Omega=0.3, Lambda=0.7 cosmology	--/K PHOT_LUM-DIST
	[chisq] [real] NOT NULL,		--/D the chi-square value for the best NNLS template fit		--/K STAT_LIKELIHOOD
	[rnorm] [real] NOT NULL,		--/D the residual norm value for the best NNLS template fit		--/K STAT_MISC
	[nTemplates] [int] NOT NULL,	--/D number of templates used in the fitting; if nTemplates=0 all the proceeding columns are invalid and may be filled with value -9999	--/K NUMBER
	[synthU] [real] NOT NULL,		--/D synthetic u' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_U
	[synthG] [real] NOT NULL,		--/D synthetic g' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_G
	[synthR] [real] NOT NULL,		--/D synthetic r' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_R
	[synthI] [real] NOT NULL,		--/D synthetic i' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_I
	[synthZ] [real] NOT NULL,		--/D synthetic z' magnitude calculated from the fitted templates --/K PHOT_SYNTH-MAG PHOT_SDSS_Z
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
         WHERE xtype='U' AND name = 'PhotozTemplateCoeff')
	DROP TABLE PhotozTemplateCoeff
GO
--
EXEC spSetDefaultFileGroup 'PhotozTemplateCoeff'
GO

CREATE TABLE PhotozTemplateCoeff(
-------------------------------------------------------------------------------
--/H Template coefficients for the Photoz table.<br>
-------------------------------------------------------------------------------
--/T Please see the <b>Photometric Redshifts</b> entry in Algorithms for more
--/T information about this table. <br>
--/T <i>NOTE: This table may be empty initially because the photoz values
--/T are computed in a separate calculation after the main data release.</i>
-------------------------------------------------------------------------------
	[objID] [bigint] NOT NULL,		--/D unique ID pointing to Galaxy table --/K ID_MAIN
	[templateID] [int] NOT NULL,	--/D id for the spectral template --/K ID_IDENTIFIER
	[coeff] [real] NOT NULL		--/D coefficient of the template  --/K NUMBER
)
GO
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PhotozRFTemplateCoeff')
	DROP TABLE PhotozRFTemplateCoeff
GO
--
EXEC spSetDefaultFileGroup 'PhotozRFTemplateCoeff'
GO

CREATE TABLE PhotozRFTemplateCoeff(
-------------------------------------------------------------------------------
--/H Template coefficients for the PhotozRF table.<br>
-------------------------------------------------------------------------------
--/T Please see the <b>Photometric Redshifts</b> entry in Algorithms for more
--/T information about this table. <br>
--/T <i>NOTE: This table may be empty initially because the photoz values
--/T are computed in a separate calculation after the main data release.</i>
-------------------------------------------------------------------------------
	[objID] [bigint] NOT NULL,		--/D unique ID pointing to Galaxy table --/K ID_MAIN
	[templateID] [int] NOT NULL,	--/D id for the spectral template --/K ID_IDENTIFIER
	[coeff] [real] NOT NULL		--/D coefficient of the template  --/K NUMBER
)
GO
--


-- Schema for DR7 cross-match tables.

--=============================================================================
-- IF EXISTS (SELECT name FROM sysobjects
--         WHERE xtype='U' AND name = 'PhotoPrimaryDR7')
--	DROP TABLE PhotoPrimaryDR7
-- GO
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
	[dr7objID] [bigint] NOT NULL,
	[dr8objID] [bigint] NOT NULL,
	[distance] [float] NULL,
	[skyVersion] [tinyint] NULL,
	[run] [smallint] NULL,
	[rerun] [smallint] NULL,
	[camcol] [tinyint] NULL,
	[field] [smallint] NULL,
	[obj] [smallint] NULL,
	[nChild] [smallint] NULL,
	[type] [smallint] NULL,
	[probPSF] [real] NULL,
	[insideMask] [tinyint] NULL,
	[flags] [bigint] NULL,
	[psfMag_u] [real] NULL,
	[psfMag_g] [real] NULL,
	[psfMag_r] [real] NULL,
	[psfMag_i] [real] NULL,
	[psfMag_z] [real] NULL,
	[psfMagErr_u] [real] NULL,
	[psfMagErr_g] [real] NULL,
	[psfMagErr_r] [real] NULL,
	[psfMagErr_i] [real] NULL,
	[psfMagErr_z] [real] NULL,
	[petroMag_u] [real] NULL,
	[petroMag_g] [real] NULL,
	[petroMag_r] [real] NULL,
	[petroMag_i] [real] NULL,
	[petroMag_z] [real] NULL,
	[petroMagErr_u] [real] NULL,
	[petroMagErr_g] [real] NULL,
	[petroMagErr_r] [real] NULL,
	[petroMagErr_i] [real] NULL,
	[petroMagErr_z] [real] NULL,
	[petroR50_r] [real] NULL,
	[petroR90_r] [real] NULL,
	[modelMag_u] [real] NULL,
	[modelMag_g] [real] NULL,
	[modelMag_r] [real] NULL,
	[modelMag_i] [real] NULL,
	[modelMag_z] [real] NULL,
	[modelMagErr_u] [real] NULL,
	[modelMagErr_g] [real] NULL,
	[modelMagErr_r] [real] NULL,
	[modelMagErr_i] [real] NULL,
	[modelMagErr_z] [real] NULL,
	[mRrCc_r] [real] NULL,
	[mRrCcErr_r] [real] NULL,
	[lnLStar_r] [real] NULL,
	[lnLExp_r] [real] NULL,
	[lnLDeV_r] [real] NULL,
	[status] [int] NULL,
	[ra] [float] NULL,
	[dec] [float] NULL,
	[cx] [float] NULL,
	[cy] [float] NULL,
	[cz] [float] NULL,
	[primTarget] [int] NULL,
	[secTarget] [int] NULL,
	[extinction_u] [real] NULL,
	[extinction_g] [real] NULL,
	[extinction_r] [real] NULL,
	[extinction_i] [real] NULL,
	[extinction_z] [real] NULL,
	[htmID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[SpecObjID] [bigint] NULL,
	[size] [real] NULL
)
GO



--=============================================================================
-- IF EXISTS (SELECT name FROM sysobjects
--         WHERE xtype='U' AND name = 'PhotoObjDR7')
--	DROP TABLE PhotoObjDR7
-- GO
--
EXEC spSetDefaultFileGroup 'PhotoObjDR7'
GO
CREATE TABLE PhotoObjDR7 (
-------------------------------------------------------------------------------
--/H Contains the spatial cross-match between DR8 photoobj and DR7 photoobj.
-------------------------------------------------------------------------------
--/T This is a unique match between a DR8 photoobj and a DR7 photoobj, 
--/T and matches are restricted to the same run/camcol/field are allowed.  
--/T The match radius is 1 arcsec, and within this radius preference is
--/T given to a photoprimary match over a secondary.  If no primary match
--/T exists, the nearest secondary match is chosen.  If more than one
--/T match of a given mode exists, the nearest one is chosen.  The table
--/T contains the DR8 and DR7 objids and modes, the distance between them, 
--/T and the DR7 phototag quantities.
-------------------------------------------------------------------------------
	[dr7objid] [bigint] NOT NULL,
	[dr8objid] [bigint] NOT NULL,
	[distance] [float] NULL,
	[modeDR7] [tinyint] NOT NULL,
	[modeDR8] [tinyint] NULL,
	[skyVersion] [tinyint] NULL,
	[run] [smallint] NULL,
	[rerun] [smallint] NULL,
	[camcol] [tinyint] NULL,
	[field] [smallint] NULL,
	[obj] [smallint] NULL,
	[nChild] [smallint] NULL,
	[type] [smallint] NULL,
	[probPSF] [real] NULL,
	[insideMask] [tinyint] NULL,
	[flags] [bigint] NULL,
	[psfMag_u] [real] NULL,
	[psfMag_g] [real] NULL,
	[psfMag_r] [real] NULL,
	[psfMag_i] [real] NULL,
	[psfMag_z] [real] NULL,
	[psfMagErr_u] [real] NULL,
	[psfMagErr_g] [real] NULL,
	[psfMagErr_r] [real] NULL,
	[psfMagErr_i] [real] NULL,
	[psfMagErr_z] [real] NULL,
	[petroMag_u] [real] NULL,
	[petroMag_g] [real] NULL,
	[petroMag_r] [real] NULL,
	[petroMag_i] [real] NULL,
	[petroMag_z] [real] NULL,
	[petroMagErr_u] [real] NULL,
	[petroMagErr_g] [real] NULL,
	[petroMagErr_r] [real] NULL,
	[petroMagErr_i] [real] NULL,
	[petroMagErr_z] [real] NULL,
	[petroR50_r] [real] NULL,
	[petroR90_r] [real] NULL,
	[modelMag_u] [real] NULL,
	[modelMag_g] [real] NULL,
	[modelMag_r] [real] NULL,
	[modelMag_i] [real] NULL,
	[modelMag_z] [real] NULL,
	[modelMagErr_u] [real] NULL,
	[modelMagErr_g] [real] NULL,
	[modelMagErr_r] [real] NULL,
	[modelMagErr_i] [real] NULL,
	[modelMagErr_z] [real] NULL,
	[mRrCc_r] [real] NULL,
	[mRrCcErr_r] [real] NULL,
	[lnLStar_r] [real] NULL,
	[lnLExp_r] [real] NULL,
	[lnLDeV_r] [real] NULL,
	[status] [int] NULL,
	[ra] [float] NULL,
	[dec] [float] NULL,
	[cx] [float] NULL,
	[cy] [float] NULL,
	[cz] [float] NULL,
	[primTarget] [int] NULL,
	[secTarget] [int] NULL,
	[extinction_u] [real] NULL,
	[extinction_g] [real] NULL,
	[extinction_r] [real] NULL,
	[extinction_i] [real] NULL,
	[extinction_z] [real] NULL,
	[htmID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[SpecObjID] [bigint] NULL,
	[size] [real] NULL
)
GO



--=============================================================================
-- IF EXISTS (SELECT name FROM sysobjects
--          WHERE xtype='U' AND name = 'SpecDR7')
--	DROP TABLE SpecDR7
-- GO
--
EXEC spSetDefaultFileGroup 'SpecDR7'
GO
CREATE TABLE SpecDR7 (
-------------------------------------------------------------------------------
--/H Contains the spatial cross-match between DR8 SpecObjAll and DR7 primaries.
-------------------------------------------------------------------------------
--/T This is a unique match between a DR8 SpecObjAll and a DR7 photoprimary 
--/T within 1 arcsec.  DR7 PhotoTag anbd ProperMotions quantities are also
--/T included for convenience.
-------------------------------------------------------------------------------
	[specObjID] [bigint] NOT NULL,
	[dr7ObjID] [bigint] NOT NULL,
	[ra] [float] NOT NULL,
	[dec] [float] NOT NULL,
	[cx] [float] NOT NULL,
	[cy] [float] NOT NULL,
	[cz] [float] NOT NULL,
	[skyVersion] [tinyint] NOT NULL,
	[run] [smallint] NOT NULL,
	[rerun] [smallint] NOT NULL,
	[camcol] [tinyint] NOT NULL,
	[field] [smallint] NOT NULL,
	[obj] [smallint] NOT NULL,
	[nChild] [smallint] NOT NULL,
	[type] [smallint] NOT NULL,
	[probPSF] [real] NOT NULL,
	[insideMask] [tinyint] NOT NULL,
	[flags] [bigint] NOT NULL,
	[psfMag_u] [real] NOT NULL,
	[psfMag_g] [real] NOT NULL,
	[psfMag_r] [real] NOT NULL,
	[psfMag_i] [real] NOT NULL,
	[psfMag_z] [real] NOT NULL,
	[psfMagErr_u] [real] NOT NULL,
	[psfMagErr_g] [real] NOT NULL,
	[psfMagErr_r] [real] NOT NULL,
	[psfMagErr_i] [real] NOT NULL,
	[psfMagErr_z] [real] NOT NULL,
	[petroMag_u] [real] NOT NULL,
	[petroMag_g] [real] NOT NULL,
	[petroMag_r] [real] NOT NULL,
	[petroMag_i] [real] NOT NULL,
	[petroMag_z] [real] NOT NULL,
	[petroMagErr_u] [real] NOT NULL,
	[petroMagErr_g] [real] NOT NULL,
	[petroMagErr_r] [real] NOT NULL,
	[petroMagErr_i] [real] NOT NULL,
	[petroMagErr_z] [real] NOT NULL,
	[petroR50_r] [real] NOT NULL,
	[petroR90_r] [real] NOT NULL,
	[modelMag_u] [real] NOT NULL,
	[modelMag_g] [real] NOT NULL,
	[modelMag_r] [real] NOT NULL,
	[modelMag_i] [real] NOT NULL,
	[modelMag_z] [real] NOT NULL,
	[modelMagErr_u] [real] NOT NULL,
	[modelMagErr_g] [real] NOT NULL,
	[modelMagErr_r] [real] NOT NULL,
	[modelMagErr_i] [real] NOT NULL,
	[modelMagErr_z] [real] NOT NULL,
	[mRrCc_r] [real] NOT NULL,
	[mRrCcErr_r] [real] NOT NULL,
	[lnLStar_r] [real] NOT NULL,
	[lnLExp_r] [real] NOT NULL,
	[lnLDeV_r] [real] NOT NULL,
	[status] [int] NOT NULL,
	[primTarget] [int] NOT NULL,
	[secTarget] [int] NOT NULL,
	[extinction_u] [real] NOT NULL,
	[extinction_g] [real] NOT NULL,
	[extinction_r] [real] NOT NULL,
	[extinction_i] [real] NOT NULL,
	[extinction_z] [real] NOT NULL,
	[htmID] [bigint] NOT NULL,
	[fieldID] [bigint] NOT NULL,
	[size] [real] NOT NULL,
	[pmRa] [real] NOT NULL,
	[pmDec] [real] NOT NULL,
	[pmL] [real] NOT NULL,
	[pmB] [real] NOT NULL,
	[pmRaErr] [real] NOT NULL,
	[pmDecErr] [real] NOT NULL,
	[delta] [real] NOT NULL,
	[match] [int] NOT NULL
)
GO
--



-- Copy data from PhotozDR8Test DB into Photoz* tables
EXECUTE spCopyATable 0,0,'PhotozDR8Test','BestDR8','Photoz',0
EXECUTE spCopyATable 0,0,'PhotozDR8Test','BestDR8','PhotozRF',0
EXECUTE spCopyATable 0,0,'PhotozDR8Test','BestDR8','PhotozTemplateCoeff',0
EXECUTE spCopyATable 0,0,'PhotozDR8Test','BestDR8','PhotozRFTemplateCoeff',0


-- Drop META indices
EXEC spIndexDropSelection 0,0,'F','META'

-- Reload DBObjects table
TRUNCATE TABLE DBObjects 
GO

INSERT DBObjects VALUES('PartitionMap','U','A',' Shows the names of partitions/filegroups and their relative sizes ','  ','0');
INSERT DBObjects VALUES('FileGroupMap','U','A',' For ''big'' databases, maps big tables to their own file groups ',' In big databases we only put core objects in the primary file group.  Other objects are grouped into separate file groups.  For really big files, the indices are put in even different groups.  This table is truncated in the Task databases. ','0');
INSERT DBObjects VALUES('spTruncateFileGroupMap','P','A',' Clear the values in the FileGroupMap table ',' <PRE> EXEC spTruncateFileGroupMap 1</PRE> ','0');
INSERT DBObjects VALUES('spSetDefaultFileGroup','P','A',' Set default file group for table taken from the FileGroupMap table ',' The stored procedure looks up the tableName in the FileGroupMap table.  If it finds a match it sets the default file group as specified   for that table or index. If no mapping is found, the procedure   sets PRIMARY as the default.<br>  If the @mode parameter is ''I'', then it sets the DEFAULT to the  indexFileGroup value for the table, otherwise to the filegroup   of the table itself.<br>  <PRE> EXEC spSetDefaultFileGroup ''photoObjAll'' </PRE> ','0');
INSERT DBObjects VALUES('DataConstants','U','U',' The table is storing various enumerated constants for flags, etc ','','0');
INSERT DBObjects VALUES('SDSSConstants','U','U',' This table contains most relevant survey constants and their physical units ','','0');
INSERT DBObjects VALUES('StripeDefs','U','U',' This table contains the definitions of the survey layout as planned ',' The lower and upper limits of the actual stripes may differ from these  values. The actual numbers are found in the Segment and Chunk tables. ','0');
INSERT DBObjects VALUES('RunShift','U','U',' The table contains values of the various manual nu shifts for runs ',' In the early runs the telescope was sometimes not tracking  correctly. The boundaries of some of the runs had thus to be shifted  by a small amount, determined by hand. This table contains  these manual corrections. These should be applied to the  nu values derived for these runs. Only those runs are here,  for which such a correction needs to be applied. ','0');
INSERT DBObjects VALUES('ProfileDefs','U','U',' This table contains the radii for the Profiles table ',' Radii of boundaries of annuli, and number of pixels involved.   aAnn is the area of the annulus, and aDisk is the area of   the disk out to rOuter. The second column gives the first   cell in the annulus, and the third indicates if the values in   that annulus are derived from sinc shifting the image to center  it on a pixel.<br>  for details see http://www.astro.princeton.edu/~rhl/photomisc/profiles.ps ','0');
INSERT DBObjects VALUES('FieldMask','V','U',' Contains the FieldMask flag values from DataConstants as binary(4) ','','0');
INSERT DBObjects VALUES('PhotoFlags','V','U',' Contains the PhotoFlags flag values from DataConstants as binary(8) ','','0');
INSERT DBObjects VALUES('PhotoStatus','V','U',' Contains the PhotoStatus flag values from DataConstants as binary(4) ','','0');
INSERT DBObjects VALUES('UberCalibStatus','V','U',' Contains the UberCalibStatus flag values from DataConstants as binary(2) ','','0');
INSERT DBObjects VALUES('PrimTarget','V','U',' Contains the PrimTarget flag values from DataConstants as binary(4) ','','0');
INSERT DBObjects VALUES('SecTarget','V','U',' Contains the SecTarget flag values from DataConstants as binary(4) ','','0');
INSERT DBObjects VALUES('InsideMask','V','U',' Contains the InsideMask flag values from DataConstants as binary(1) ','','0');
INSERT DBObjects VALUES('SpecZWarning','V','U',' Contains the SpecZWarning flag values from DataConstants as binary(4) ','','0');
INSERT DBObjects VALUES('ImageMask','V','U',' Contains the ImageMask flag values from DataConstants as binary(4) ','','0');
INSERT DBObjects VALUES('TiMask','V','U',' Contains the TiMask flag values from DataConstants as binary(4) ','','0');
INSERT DBObjects VALUES('PhotoMode','V','U',' Contains the PhotoMode enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('PhotoType','V','U',' Contains the PhotoType enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('MaskType','V','U',' Contains the MaskType enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('FieldQuality','V','U',' Contains the FieldQuality enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('PspStatus','V','U',' Contains the PspStatus enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('FramesStatus','V','U',' Contains the FramesStatus enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('SpecClass','V','U',' Contains the SpecClass enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('SpecLineNames','V','U',' Contains the SpecLineNames enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('SpecZStatus','V','U',' Contains the SpecZStatus enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('HoleType','V','U',' Contains the HoleType enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('ObjType','V','U',' Contains the ObjType enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('ProgramType','V','U',' Contains the ProgramType enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('CoordType','V','U',' Contains the CoordType enumerated values from DataConstants as int ','','0');
INSERT DBObjects VALUES('fPhotoMode','F','U',' Returns the Mode value, indexed by name (Primary, Secondary, Family, Outside) ',' the Mode names can be found with   <br>       Select * from PhotoMode   <br>  Sample call to fPhotoMode  <samp>   <br> select top 10 *    <br> from photoObj  <br> where mode =  dbo.fPhotoMode(''PRIMARY'')  </samp>   <br> see also fPhotoModeN ','0');
INSERT DBObjects VALUES('fPhotoModeN','F','U',' Returns the Mode name, indexed by value () ',' the Mode names can be found with   <br>       Select * from PhotoMode   <br>  Sample call to fPhotoModeN  <samp>   <br> select top 10 *    <br> from photoObj  <br> where mode =  dbo.fPhotoMode(''PRIMARY'')  </samp>   <br> see also fPhotoModeN ','0');
INSERT DBObjects VALUES('fPhotoType','F','U',' Returns the PhotoType value, indexed by name (Galaxy, Star,...) ',' the PhotoType names can be found with   <br>       Select * from PhotoType   <br>  Sample call to fPhotoType.  <samp>   <br> select top 10 *    <br> from photoObj  <br> where type =  dbo.fPhotoType(''Star'')  </samp>   <br> see also fPhotoTypeN ','0');
INSERT DBObjects VALUES('fMaskType','F','U',' Returns the MaskType value, indexed by name  ',' the MaskType names can be found with   <br>       Select * from MaskType   <br>  Sample call to fMaskType.  <samp>   <br> select top 10 *    <br> from Mask  <br> where type =  dbo.fMaskType(''Star'')  </samp>   <br> see also fMaskTypeN ','0');
INSERT DBObjects VALUES('fMaskTypeN','F','U',' Returns the MaskType name, indexed by value (0=Bleeding Mask, 1=Bright Star Mask, etc.) ',' the MaskType values can be found with   <br>       Select * from MaskType   <br>  Sample call to fMaskTypeN.  <samp>   <br> select top 10 m.maskID, o.objID, dbo.fMaskTypeN(m.type) as type   <br> from Mask m JOIN MaskedObject o ON m.maskID=o.maskID  </samp>   <br> see also fMaskType ','0');
INSERT DBObjects VALUES('fPhotoTypeN','F','U',' Returns the PhotoType name, indexed by value (3-> Galaxy, 6-> Star,...) ',' the PhotoType values can be found with   <br>       Select * from PhotoType   <br>  Sample call to fPhotoTypeN.  <samp>   <br> select top 10 objID, dbo.fPhotoTypeN(type) as type   <br> from photoObj  </samp>   <br> see also fPhotoType ','0');
INSERT DBObjects VALUES('fFieldQuality','F','U',' Returns bitmask of named field quality (e.g. ACCEPTABLE, BAD, GOOD, HOLE, MISSING) ',' the fFieldQuality names can be found with   <br>       Select * from FieldQuality   <br>  Sample call to fFieldQuality.  <samp>   <br> select top 10 *    <br> from field  <br> where quality =  dbo.fFieldQuality(''ACCEPTABLE'')  </samp>   <br> see also fFieldQualityN ','0');
INSERT DBObjects VALUES('fFieldQualityN','F','U',' Returns description of quality value (e.g. ACCEPTABLE, BAD, GOOD, HOLE, MISSING) ',' the fFieldQuality values can be found with   <br>       Select * from FieldQuality  <br>  Sample call to fFieldQualityN.  <samp>   <br> select top 10 dbo.fFieldQualityN(quality) as quality  <br> from field  </samp>   <br> see also fFieldQuality ','0');
INSERT DBObjects VALUES('fPspStatus','F','U',' Returns the PspStatus value, indexed by name ',' the  PspStatus values can be found with   <br>       Select * from PspStatus    <br>  Sample call to fPspStatus.  <samp>   <br> select top 10 *  <br> from field  <br> where status_r = dbo.fPspStatus(''PSF_OK'')  </samp>   <br> see also fPspStatusN ','0');
INSERT DBObjects VALUES('fPspStatusN','F','U',' Returns the PspStatus name, indexed by value ',' the  PspStatus values can be found with   <br>       Select * from PspStatus   <br>  Sample call to fPspStatusN.  <samp>   <br> select top 10 dbo.fPspStatusN(status_r) as status_r  <br> from field  </samp>   <br> see also PspStatus ','0');
INSERT DBObjects VALUES('fFramesStatus','F','U',' Returns the FramesStatus value, indexed by name ',' the  FramesStatus values can be found with   <br>       Select * from FramesStatus    <br>  Sample call to fFramesStatus.  <samp>   <br> select top 10 *  <br> from field  <br> where status_r = dbo.fFramesStatus(''OK'')  </samp>   <br> see also fPspStatusN ','0');
INSERT DBObjects VALUES('fFramesStatusN','F','U',' Returns the FramesStatus name, indexed by value ',' the  FramesStatus values can be found with   <br>       Select * from FramesStatus   <br>  Sample call to fFramesStatusN.  <samp>   <br> select top 10 dbo.fFramesStatusN(framesstatus) as framesstatus  <br> from field  </samp>   <br> see also PspStatus ','0');
INSERT DBObjects VALUES('fSpecClass','F','U',' Returns the SpecClass value, indexed by name ',' the  SpecClass values can be found with   <br>       Select * from SpecClass   <br>  Sample call to fSpecClass.  <samp>   <br> select top 10  *  <br> from SpecObj  <br> where specClass = dbo.fSpecClass(''QSO'')  </samp>   <br> see also fSpecClassN ','0');
INSERT DBObjects VALUES('fSpecClassN','F','U',' Returns the SpecClass name, indexed by value ',' the  SpecClass values can be found with   <br>       Select * from SpecClass   <br>  Sample call to fSpecClassN.  <samp>   <br> select top 10 dbo.fSpecClassN(specClass) as specClass  <br> from SpecObj  </samp>   <br> see also fSpecClass ','0');
INSERT DBObjects VALUES('fSpecZStatus','F','U',' Return the SpecZStatus value, indexed by name ',' the  SpecZStatus values can be found with   <br>       Select * from SpecZStatus   <br>  Sample call to fSpecZStatus.  <samp>   <br> select top 10  *  <br> from SpecObj  <br> where zStatus = dbo.fSpecZStatus(''XCORR_LOC'')  </samp>   <br> see also fSpecZStatusN ','0');
INSERT DBObjects VALUES('fSpecZStatusN','F','U',' Return the SpecZStatus name, indexed by value ',' the  SpecZStatus values can be found with   <br>       Select * from SpecZStatus   <br>  Sample call to fSpecZStatusN.  <samp>   <br> select top 10 dbo.fSpecZStatusN(zStatus) as zStatus  <br> from field  </samp>   <br> see also fSpecZStatus ','0');
INSERT DBObjects VALUES('fSpecLineNames','F','U',' Return the SpecLineNames value, indexed by name ',' the  SpecLineNames can be found with   <br>       Select * from SpecLineNames   <br>  Sample call to fSpecLineNames.  <samp>   <br> select top 10  *  <br> from SpecLine  <br> where lineID = dbo.fSpecLineNames(''H_3970'')  </samp>   <br> see also fSpecLineNamesN ','0');
INSERT DBObjects VALUES('fSpecLineNamesN','F','U',' Return the SpecLineNames name, indexed by value ',' the  SpecLineNames can be found with   <br>       Select * from SpecLineNames   <br>  Sample call to fSpecLineNamesN.  <samp>   <br> select top 10 dbo.fSpecLineNamesN(lineID) as lineID  <br> from SpecLine  </samp>   <br> see also fSpecLineNames ','0');
INSERT DBObjects VALUES('fHoleType','F','U',' Return the HoleType value, indexed by name ',' the HoleTypes can be found with   <br>       Select * from HoleType  <br>  Sample call to fHoleType.  <samp>   <br> select top 10  *  <br> from HoleObj  <br> where holeType = dbo.fHoleType(''OBJECT'')  </samp>   <br> see also fHoleTypeN ','0');
INSERT DBObjects VALUES('fHoleTypeN','F','U',' Return the HoleType name, indexed by value ',' the HoleTypes can be found with   <br>       Select * from HoleType  <br>  Sample call to fHoleTypeN.  <samp>   <br> select top 10 dbo.fHoleTypeN(holeType) as holeType  <br> from HoleObj  </samp>   <br> see also fHoleType ','0');
INSERT DBObjects VALUES('fObjType','F','U',' Return the ObjType value, indexed by name ',' the ObjTypes can be found with   <br>       Select * from ObjType  <br>  Sample call to fObjType.  <samp>   <br> select top 10  *  <br> from TiledTarget  <br> where objType = dbo.fObjType(''GALAXY'')  </samp>   <br> see also fObjTypeN ','0');
INSERT DBObjects VALUES('fObjTypeN','F','U',' Return the ObjType name, indexed by value ',' the ObjTypes can be found with   <br>       Select * from ObjType  <br>  Sample call to fObjTypeN.  <samp>   <br> select top 10 dbo.fObjTypeN(objType) as objType  <br> from TiledTarget  </samp>   <br> see also fObjType ','0');
INSERT DBObjects VALUES('fProgramType','F','U',' Return the ProgramType value, indexed by name ',' the ProgramTypes can be found with   <br>       Select * from ProgramType  <br>  Sample call to fProgramType.  <samp>   <br> select top 10  *  <br> from Tile  <br> where programType = dbo.fProgramType(''MAIN'')  </samp>   <br> see also fProgramTypeN ','0');
INSERT DBObjects VALUES('fProgramTypeN','F','U',' Return the ProgramType name, indexed by value ',' the ProgramTypes can be found with   <br>       Select * from ProgramType  <br>  Sample call to fProgramTypeN.  <samp>   <br> select top 10 dbo.fProgramTypeN(programType) as programType  <br> from Tile  </samp>   <br> see also fProgramType ','0');
INSERT DBObjects VALUES('fCoordType','F','U',' Return the CoordType value, indexed by name ',' the CoordTypes can be found with   <br>       Select * from CoordType  <br>  Sample call to fCoordType.  <samp>   <br> select top 10  *  <br> from TilingBoundary  <br> where coordType = dbo.fCoordType(''RA_DEC'')  </samp>   <br> see also fCoordTypeN ','0');
INSERT DBObjects VALUES('fCoordTypeN','F','U',' Return the CoordType name, indexed by value ',' the CoordTypes can be found with   <br>       Select * from CoordType  <br>  Sample call to fCoordTypeN.  <samp>   <br> select top 10 dbo.fCoordTypeN(coordType) as coordType  <br> from TilingBoundary  </samp>   <br> see also fCoordType ','0');
INSERT DBObjects VALUES('fFieldMask','F','U',' Returns mask value for a given name (e.g. ''seeing'') ',' the FieldMask values can be found with Select * from FieldMask.   <br>  Sample call to find fields with good seeing.  <samp>   <br> select top 10 *   <br> from field   <br> where goodMask & dbo.fFieldMask(''Seeing'') > 0   </samp>   <br> see also fFieldMaskN ','0');
INSERT DBObjects VALUES('fFieldMaskN','F','U',' Returns description of mask value (e.g. ''SEEING PSF'') ',' the FieldMask values can be found with Select * from FieldMask.   <br>  Sample call to field masks.  <samp>   <br> select top 10   <br> 	dbo.fFieldMaskN(goodMask) as good,  <br> 	dbo.fFieldMaskN(acceptableMask) as acceptable,   <br> 	dbo.fFieldMaskN(badMask) as bad    <br> from field  </samp>   <br> see also fFieldMask ','0');
INSERT DBObjects VALUES('fPhotoFlags','F','U',' Returns the PhotoFlags value corresponding to a name ',' the photoFlags can be shown with Select * from PhotoFlags   <br>  Sample call to find photo objects with saturated pixels is  <samp>   <br> select top 10 *   <br> from photoObj   <br> where flags & dbo.fPhotoFlags(''SATURATED'') > 0   </samp>   <br> see also fPhotoDescription ','0');
INSERT DBObjects VALUES('fPhotoFlagsN','F','U',' Returns the expanded PhotoFlags corresponding to the status value as a string ',' the photoFlags can be shown with Select * from PhotoFlags   <br>  Sample call to display the flags of some photoObjs  <samp>   <br> select top 10 objID, dbo.fPhotoFlagsN(flags) as flags  <br> from photoObj   </samp>   <br> see also fPhotoFlags ','0');
INSERT DBObjects VALUES('fPhotoStatus','F','U',' Returns the PhotoStatus flag value corresponding to a name ',' the photoStatus values can be shown with Select * from PhotoStatus   <br>  Sample call to find ''good'' photo objects is  <samp>   <br> select top 10 *   <br> from photoObj   <br> where status & dbo.fPhotoStatus(''GOOD'') > 0   </samp>   <br> see also fPhotoStatusN ','0');
INSERT DBObjects VALUES('fPhotoStatusN','F','U',' Returns the string describing to the status flags in words ',' the photoStatus values can be shown with Select * from PhotoStatus    <br>  Sample call to fPhotoStatusN:   <samp>   <br> select top 10 dbo.fPhotoStatusN(status) as status  <br> from photoObj  </samp>   <br> see also fPhotoStatus ','0');
INSERT DBObjects VALUES('fUberCalibStatus','F','U',' Returns the UberCalibStatus flag value corresponding to a name ',' The UberCalibStatus values can be shown with Select * from UberCalibStatus   <br>  Sample call to find photometric objects is  <samp>   <br> select top 10 u.modelMag_r   <br> from PhotoObj p, UberCal u   <br> where p.objID=u.objID AND   <br> <dd><dd>(u.calibStatus_r & dbo.fUberCalibStatus(''PHOTOMETRIC'') > 0)   </samp>   <br> see also fUberCalibStatusN ','0');
INSERT DBObjects VALUES('fUberCalibStatusN','F','U',' Returns the string describing to the ubercal status flags in words ',' The UberCalibStatus values can be shown with Select * from UberCalibStatus    <br>  Sample call to fUberCalibStatusN:   <samp>   <br> select top 10 dbo.fUberCalibStatusN(u.calibStatus_r) as ucalstatus_r  <br> from PhotoObj p, UberCal u where p.objiD=u.objID  </samp>   <br> see also fUberCalibStatus ','0');
INSERT DBObjects VALUES('fPrimTarget','F','U',' Returns the PrimTarget value corresponding to a name ',' the photo and spectro primTarget flags can be shown with Select * from PrimTarget   <br>  Sample call to find photo objects that are Galaxy primary targets  <samp>   <br> select top 10 *   <br> from photoObj   <br> where primTarget & dbo.fPrimTarget(''TARGET_GALAXY'') > 0   </samp>   <br> see also fSecTarget ','0');
INSERT DBObjects VALUES('fPrimTargetN','F','U',' Returns the expanded PrimTarget corresponding to the flag value as a string ',' the photo and spectro primTarget flags can be shown with Select * from PrimTarget   <br>  Sample call to show the target flags of some photoObjects is  <samp>   <br> select top 10 objId, dbo.fPriTargetN(secTarget) as priTarget  <br> from photoObj   </samp>   <br> see also fPrimTarget, fSecTargetN ','0');
INSERT DBObjects VALUES('fSecTarget','F','U',' Returns the SecTarget value corresponding to a name ',' the photo and spectro secTarget flags can be shown with Select * from SecTarget   <br>  Sample call to find photo objects that are Galaxy primary targets  <samp>   <br> select top 10 *   <br> from photoObj   <br> where secTarget & dbo.fsecTarget(''TARGET_SPECTROPHOTO_STD'') > 0   </samp>   <br> see also fPrimTarget, fSecTargetN ','0');
INSERT DBObjects VALUES('fSecTargetN','F','U',' Returns the expanded SecTarget corresponding to the flag value as a string ',' the photo and spectro secTarget flags can be shown with Select * from SecTarget   <br>  Sample call to find photo objects that are Galaxy primary targets  <samp>   <br> select top 10 objId, dbo.fSecTargetN(secTarget) as secTarget  <br> from photoObj   </samp>   <br> see also fSecTarget, fPrimTarget ','0');
INSERT DBObjects VALUES('fInsideMask','F','U',' Returns the InsideMask value corresponding to a name ',' The InsideMask values can be shown with Select * from InsideMask   <br>  Sample call to find photo objects which are masked  <samp>   <br> select top 10 objID, insideMask   <br> from PhotoObj   <br> where (dbo.fInsideMask(''INMASK_BLEEDING'') & insideMask) > 0   </samp>   <br> see also fInsideMaskN ','0');
INSERT DBObjects VALUES('fInsideMaskN','F','U',' Returns the expanded InsideMask corresponding to the bits, as a string ',' the InsideMask can be shown with Select * from InsideMask  <br>  Sample call to display the insideMask setting of some photoObjs  <samp>   <br> select top 10 objID, dbo.fInsideMaskN(insideMask) as mask  <br> from PhotoObj   </samp>   <br> see also fInsideMask ','0');
INSERT DBObjects VALUES('fSpecZWarning','F','U',' Return the SpecZWarning value, indexed by name ',' the specZWarning values can be shown with Select * from SpecZWarning   <br>  Sample call to find spec objects that do not have warnings  <samp>   <br> select top 10 *   <br> from   specObj   <br> where  zWarning = dbo.fSpecZWarning(''OK'')    </samp>   <br> see also fSpecZWarningN ','0');
INSERT DBObjects VALUES('fSpecZWarningN','F','U',' Return the expanded SpecZWarning corresponding to the flag value as a string ',' the specZWarning values can be shown with Select * from SpecZWarning   <br>  Sample call to find the warnings of some Spec objects     <samp>   <br> select top 10 objID,  dbo.fSpecZWarningN(zWarning) as warning  <br> from specObj   </samp>   <br> see also fSpecZWarning ','0');
INSERT DBObjects VALUES('fImageMask','F','U',' Return the ImageMask flag value, indexed by name ',' the ImageMask values can be shown with Select * from ImageMask   <br>  Sample call to fImageMask  <samp>   <br> select top 10 ???  <br> from   ?????   <br> where  ??? = dbo.fImageMask(''SUBTRACTED'')    </samp>   <br> see also fImageMaskN ','0');
INSERT DBObjects VALUES('fImageMaskN','F','U',' Return the expanded ImageMask corresponding to the flag value as a string ',' the ImageMask values can be shown with Select * from ImageMask   <br>  Sample call to fImageMaskN  <samp>   <br> select top 10 objID, dbo.fImageMask(mask) as mask  <br> from   ?????   </samp>   <br> see also fImageMask  ','0');
INSERT DBObjects VALUES('fTiMask','F','U',' Returns the TiMask value corresponding to a name ',' the TiMask values can be found with   <br>       Select * from TiMask  <br>  Sample call to fTiMask.  <samp>   <br> select top 10  *  <br> from TilingInfo  <br> where tiMask = dbo.fTiMask(''AR_TMASK_TILED'')  </samp>   <br> see also fTiMaskN ','0');
INSERT DBObjects VALUES('fTiMaskN','F','U',' Returns the expanded TiMask corresponding to the flag value as a string ',' the TiMask values can be found with   <br>       Select * from TiMask  <br>  Sample call to fTiMaskN.  <samp>   <br> select top 10 dbo.fTiMaskN(tiMask) as tiMask  <br> from TilingInfo  </samp>   <br> see also fTiMask ','0');
INSERT DBObjects VALUES('fPhotoDescription','F','U',' Returns a string indicating Object type and object flags ',' <PRE> select top 10 dbo.fPhotoDescription(objID) from PhotoObj </PRE> ','0');
INSERT DBObjects VALUES('fSpecDescription','F','U',' Returns a string indicating class, status and zWarning for a specObj ',' <PRE> select top 10 dbo.fSpecDescription(specObjID) from SpecObjAll </PRE> ','0');
INSERT DBObjects VALUES('SiteDBs','U','U',' Table containing the list of DBs at this CAS site. ',' The SiteDBs table contains the name, short description   and status of each db available for user access in this   CAS server.  This is used to auto-generate the list of  available user databases on the SkyServer front page  (at least for the collab and astro sites). ','0');
INSERT DBObjects VALUES('QueryResults','U','U',' Store the results of performance tests here ','','0');
INSERT DBObjects VALUES('RecentQueries','U','U',' Record the ipAddr and timestamps of the last n queries ',' Query log table to record last n query IPs and timestamps so   that queries can be restricted to a certain number per minute per  IP to prevent crawlers from hogging the system (see spExecuteSQL). ','0');
INSERT DBObjects VALUES('SiteConstants','U','U',' Table holding site specific constants ','','0');
INSERT DBObjects VALUES('DBObjects','U','U',' Every SkyServer database object has a one line description in this table ','','0');
INSERT DBObjects VALUES('DBColumns','U','U',' Every column of every table has a description in this table ','','0');
INSERT DBObjects VALUES('DBViewCols','U','U',' The columns of each view are stored for the auto-documentation ',' * means that every column from the  parent is propagated. ','0');
INSERT DBObjects VALUES('History','U','U',' Contains the detailed history of schema changes ',' The changes are tracked by module ','0');
INSERT DBObjects VALUES('Inventory','U','U',' Contains the detailed inventory of database objects ',' The objects are tracked by module ','0');
INSERT DBObjects VALUES('Dependency','U','U',' Contains the detailed inventory of database objects ',' The objects are tracked by module ','0');
INSERT DBObjects VALUES('PubHistory','U','A',' This table keeps the record of publishing into a table ',' this table only gets written into if this is a destination database.  The table contains the names of the tables which were published into  The table is wrttien by the publisher. It can be compared at the end  to the contents of the Diagnostics table. ','0');
INSERT DBObjects VALUES('LoadHistory','U','U',' Tracks the loading history of the database ',' Binds the loadversion value to dates and Task names  ','0');
INSERT DBObjects VALUES('Diagnostics','U','A',' This table stores a full diagnostic snapshot of the database. ',' The table contains the names of all the tables, views,  stored procedures and user defined functions in the database.  We leave out the Diagnostics itself, QueryResults and LoadEvents, etc  these can be dynamically updated. We compute the row counts  for each table and view. This is generated by running the  stored procedure spMakeDiagnostics. The table was  replicated upon the creation of the database into SiteDiagnostics. ','0');
INSERT DBObjects VALUES('SiteDiagnostics','U','U',' This table stores the full diagnostic snapshot after the last revision ',' The table contains the names of all the tables, views,  stored procedures and user defined functions in the database.  We leave out the Diagnostics itself, QueryResults and LoadEvents,  these can be dynamically updated. This was generated from the  Diagnostics table when the DB was created. ','0');
INSERT DBObjects VALUES('spNewPhase','P','A',' Wraps the loadsupport spNewPhase procedure for local use ',' If @taskid=0, only prints the message ','0');
INSERT DBObjects VALUES('spStartStep','P','A',' Wraps the loadsupport spStartStep procedure for local use ',' If @taskid=0, only prints the message, and returns 1 as @stepid ','0');
INSERT DBObjects VALUES('spEndStep','P','A',' Wraps the loadsupport spStartStep procedure for local use ',' If @taskid=0, only prints the message ','0');
INSERT DBObjects VALUES('IndexMap','U','A',' Table containing the definition of all indices ',' Contains all information necessary to build the indices  including the list of fields. Drives both index creation   and data validation. ','0');
INSERT DBObjects VALUES('fIndexName','F','A',' Builds the name of the index from its components ',' Used by the index build and check procedures.  <li>If ''K'' then pk_Tablename_fieldList  <li>If ''F'' then fk_TableName_fieldList_Key  <li>If ''I'' then i_TableName_fieldlist,  <br> truncated to 32 characters. ','0');
INSERT DBObjects VALUES('spIndexCreate','P','A',' Creates primary keys, foreign keys, and indices ',' Works for all user tables, views, procedures and functions   The default user is test, default access is U  <BR>  <li> taskID  int   	-- number of task causing this   <li> stepID  int   	-- number of step causing this   <li> tableName  varchar(1000)    -- name of table to get index or foreign key  <li> fieldList  varchar(1000)    -- comma separated list of fields in key (no blanks)  <li> foreignkey varchar(1000)    -- foreign key (f(a,b,c))  <br> return value: 0: OK , > 0 : count of errors.  <br> Example<br>   <samp>  exec spCreateIndex @taskID, @stepID, 32   </samp> ','0');
INSERT DBObjects VALUES('spIndexBuildList','P','A',' Builds the indices from a selection, based upon the #indexmap table ',' It also assumes that we created before an #indexmap temporary table  that has three attributes: id int, indexmapid int, status int.  status values are 0:READY, 1:STARTED, 2:DONE. ','0');
INSERT DBObjects VALUES('spIndexDropList','P','A',' Drops the indices from a selection, based upon the #indexmap table ',' It also assumes that we created before an #indexmap temporary table  that has three attributes, id int, indexmapid int, status int.  status values are 0:READY, 1:STARTED, 2:DONE ','0');
INSERT DBObjects VALUES('spIndexBuildSelection','P','A',' Builds a set of indexes from a selection given by @type and @group ',' The parameters are the body of a group clause, to be used with IN (...),  separated by comma, like @type = ''F,K,I'', @group=''PHOTO,TAG,META'';  <BR>  <li> @type   varchar(256)  -- a subset of F,K,I   <br> Here ''F'': (foreign key), ''K'' (primary key), ''I'' index  <li> @group  varchar(256) -- a subset of PHOTO,TAG,SPECTRO,QSO,TILES,META,FINISH,NEIGHBORS,ZONE,MATCH  It will also accept ''ALL'' as an alternate argument, it means build all indices. Or one can specify  a comma separated list of tables.  <br> The sp assumes that the parameters are syntactically correct.  Returns 0, if all is well, 1 if an error has occurred,   and 2, if no more indexes are to be built.  <br><samp>     exec spIndexBuildSelection 1,1, ''K,I,F'', ''PHOTO''  </samp>   ','0');
INSERT DBObjects VALUES('spIndexDropSelection','P','A',' Drops a set of indexes from a selection given by @type and @group ',' The procedure uses the IndexMap table to drop the selected indices.  The parameters are the body of a group clause, to be used with IN (...),  separated by comma, like @type = ''F,K,I'', @group=''PHOTO,TAG,META'';  <BR>  <li> @type   varchar(256)  -- a subset of F,K,I   <br> Here ''F'': (foreign key), ''K'' (primary key), ''I'' index  <li> @group  varchar(256) -- a subset of PHOTO,TAG,SPECTRO,QSO,TILES,META,FINISH,NEIGHBORS,ZONE,MATCH  It will also accept ''ALL'' as an alternate argument, it means build all indices. Or one can specify  a comma separated list of tables.  <br> The sp assumes that the parameters are syntactically correct.  Returns 0, if all is well, 1 if an error has occurred,   and 2, if no more indexes are to be built.  <br><samp>     exec spIndexDropSelection 1,1, ''K,I,F'', ''PHOTO''  </samp>   ','0');
INSERT DBObjects VALUES('spIndexDrop','P','A',' Drops all indices of a given type ''F'' (foreign key), ''K'' (primary key), or ''I'' index ',' Uses the information in the sysobjects and sysindexes table to delete the indexes.  These should be called in the sequence ''F'', ''K'', ''I''  <BR>  <li> type  varchar(16)   -- ''F'' (foreign key), ''K'' (primary key), or ''I'' index  <br><samp>  <br> exec  dbo.spIndexDrop ''F''  </samp>   ','0');
INSERT DBObjects VALUES('spDropIndexAll','P','A',' Drops all indices on user tables ',' <br><samp>  <br> exec  dbo.spDropIndexAll  </samp>   ','0');
INSERT DBObjects VALUES('Versions','U','U',' Tracks the versioning history of the database ',' This is a log of all major changes that happened to the DB  since its creation.  ','0');
INSERT DBObjects VALUES('Field','U','U',' All the measured parameters and calibrations of a photometric field ',' A field is a 2048x1489 pixel section of a camera column.   This table contains summary results of the photometric   and calibration pipelines for each field. ','0');
INSERT DBObjects VALUES('PhotoObjAll','U','U',' The full photometric catalog quantities for SDSS imaging. ',' This table contains one entry per detection, with the associated   photometric parameters measured by PHOTO, and astrometrically   and photometrically calibrated.   <p>  The table has the following  views:  <ul>  <li> <b>PhotoObj</b>: all primary and secondary objects; essentially this is the view you should use unless you want a specific type of object.  <li> <b>PhotoPrimary</b>: all photo objects that are primary (the best version of the object).  <ul><li> <b>Star</b>: Primary objects that are classified as stars.      <li> <b>Galaxy</b>: Primary objects that are classified as galaxies. 	   <li> <b>Sky</b>:Primary objects which are sky samples.      <li> <b>Unknown</b>:Primary objects which are no0ne of the above</ul>      <li> <b>PhotoSecondary</b>: all photo objects that are secondary (secondary detections)      <li> <b>PhotoFamily</b>: all photo objects which are neither primary nor secondary (blended)  </ul>  <p> The table has indices that cover the popular columns. ','0');
INSERT DBObjects VALUES('Photoz','U','U',' The photometrically estimated redshifts for all objects in the Galaxy view. ',' Estimation is based on a robust fit on spectroscopically observed objects  with similar colors and inclination angle.<br>  Please see the <b>Photometric Redshifts</b> entry in Algorithms for more  information about this table. <br>  <i>NOTE: This table may be empty initially because the photoz values  are computed in a separate calculation after the main data release.</i> ','0');
INSERT DBObjects VALUES('PhotozRF','U','U',' The photometrically estimated redshifts for all objects in the Galaxy view. ',' Estimates are based on the Random Forest technique.<br>  Please see the <b>Photometric Redshifts</b> entry in Algorithms for more  information about this table. <br>  <i>NOTE: This table may be empty initially because the photoz values  are computed in a separate calculation after the main data release.</i> ','0');
INSERT DBObjects VALUES('PhotozTemplateCoeff','U','U',' Template coefficients for the Photoz table.<br> ',' Please see the <b>Photometric Redshifts</b> entry in Algorithms for more  information about this table. <br>  <i>NOTE: This table may be empty initially because the photoz values  are computed in a separate calculation after the main data release.</i> ','0');
INSERT DBObjects VALUES('PhotozRFTemplateCoeff','U','U',' Template coefficients for the PhotozRF table.<br> ',' Please see the <b>Photometric Redshifts</b> entry in Algorithms for more  information about this table. <br>  <i>NOTE: This table may be empty initially because the photoz values  are computed in a separate calculation after the main data release.</i> ','0');
INSERT DBObjects VALUES('ProperMotions','U','U',' Proper motions combining SDSS and recalibrated USNO-B astrometry. ',' These results are based on the technique described in  Munn et al. 2004, AJ, 127, 3034 ','0');
INSERT DBObjects VALUES('FieldProfile','U','U',' The mean PSF profile for the field as determined from bright stars. ',' For the profile radii, see the ProfileDefs table. ','0');
INSERT DBObjects VALUES('Run','U','U',' Contains the basic parameters associated with a run ',' A run corresponds to a single drift scan.  ','0');
INSERT DBObjects VALUES('PhotoProfile','U','U',' The annulus-averaged flux profiles of SDSS photo objects ',' For the profile radii, see the ProfileDefs table. ','0');
INSERT DBObjects VALUES('Mask','U','U',' Contains a record describing the each mask object ',' ','0');
INSERT DBObjects VALUES('MaskedObject','U','U',' Contains the objects inside a specific mask ',' This is a list of all masked objects. Each object may appear  multiple times, if it is masked for multiple reasons. ','0');
INSERT DBObjects VALUES('AtlasOutline','U','U',' Contains a record describing each AtlasOutline object ',' The table contains the outlines of each object over a 4x4 pixel grid,  and the bounding rectangle of the object within the frame. ','0');
INSERT DBObjects VALUES('TwoMass','U','U',' 2MASS point-source catalog quantities for matches to SDSS photometry ',' This table contains one entry for each match between the   SDSS photometric catalog (photoObjAll) and the 2MASS point-source  catalog (PSC). See http://tdc-www.harvard.edu/catalogs/tmc.format.html  for full documentation. ','0');
INSERT DBObjects VALUES('TwoMassXSC','U','U',' 2MASS extended-source catalog quantities for matches to SDSS photometry ',' This table contains one entry for each match between the   SDSS photometric catalog (photoObjAll) and the 2MASS extended-source  catalog (XSC). See http://tdc-www.harvard.edu/catalogs/tmx.format.html   for full documentation. ','0');
INSERT DBObjects VALUES('FIRST','U','U',' SDSS objects that match to FIRST objects have their match parameters stored here ','','0');
INSERT DBObjects VALUES('RC3','U','U',' RC3 information for matches to SDSS photometry ',' All matches to the Third Reference Source Catalog within 6 arcsec are included.  RC3 positions were updated with latest NED positions in 2008. ','0');
INSERT DBObjects VALUES('ROSAT','U','U',' ROSAT All-Sky Survey information for matches to SDSS photometry ',' All matches of SDSS photometric catalog objects to ROSAT All Sky Survey.  Both faint and bright sources used here (indicated as ''faint'' or ''bright''  in CAT column. See detailed documentation at http://www.xray.mpe.mpg.de/rosat/survey/rass-bsc/ ','0');
INSERT DBObjects VALUES('USNO','U','U',' SDSS objects that match to USNO-B objects have their match parameters stored here ',' The source for this is the USNO-B1.0 catalog (Monet et al. 2003, AJ, 125, 984).   This is simply the closest matching USNO-B1.0 object. See the ProperMotions table   for proper motions after recalibrating USNO and SDSS astrometry.   USNO-B contains five imaging surveys, two early epochs from POSS-I,   and three later epochs from POSS-II, SERC and AAO.  ','0');
INSERT DBObjects VALUES('galSpecExtra','U','U',' Estimated physical parameters for all galaxies in the MPA-JHU spectroscopic catalogue. ',' These parameters give the probability distribution of each parameter in terms  of its percent quantiles. These estimates are derived in the manner described  in Brinchmann et al. 2004 ','0');
INSERT DBObjects VALUES('galSpecIndx','U','U',' Index measurements of spectra from the MPA-JHU spectroscopic catalogue. ',' For each index, we give our estimate and error bar.  Measurements  performed as described in Brinchmann et al. 2004. ','0');
INSERT DBObjects VALUES('galSpecInfo','U','U',' General information for the MPA-JHU spectroscopic re-analysis ',' This table contains one entry per spectroscopic observation  It may be joined with the other galSpec tables with the  measurements, or to specObjAll, using specObjId.  Numbers  given here are for the version of data used by the MPA-JHU  and may not be in perfect agreement with specObjAll. ','0');
INSERT DBObjects VALUES('galSpecLine','U','U',' Emission line measurements from MPA-JHU spectroscopic reanalysis ',' The table contains one entry per spectroscopic observation derived as   described in Tremonti et al (2004) and Brinchmann et al (2004). ','0');
INSERT DBObjects VALUES('fSkyVersion','F','U',' Extracts SkyVersion from an SDSS Photo Object ID ',' The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>  <samp> select top 10 objId, dbo.fSkyVersion(objId) as fSkyVersion from Galaxy</samp> ','0');
INSERT DBObjects VALUES('fRerun','F','U',' Extracts Rerun from an SDSS Photo Object ID ',' The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>  <samp> select top 10 objId, dbo.fRerun(objId) as fRerun from Galaxy</samp> ','0');
INSERT DBObjects VALUES('fRun','F','U',' Extracts Run from an SDSS Photo Object ID ',' The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>  <samp> select top 10 objId, dbo.fRun(objId) as fRun from Galaxy</samp> ','0');
INSERT DBObjects VALUES('fCamcol','F','U',' Extracts Camcol from an SDSS Photo Object ID ',' The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>  <samp> select top 10 objId, dbo.fCamcol(objId) as fCamcol from Galaxy</samp> ','0');
INSERT DBObjects VALUES('fField','F','U',' Extracts Field from an SDSS Photo Object ID. ',' The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>  <samp> select top 10 objId, dbo.fField(objId) as fField from Galaxy</samp> ','0');
INSERT DBObjects VALUES('fObj','F','U',' Extracts Obj from an SDSS Photo Object ID. ',' The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>  <samp> select top 10 objId, dbo.fObj(objId) as fObj from Galaxy</samp> ','0');
INSERT DBObjects VALUES('fObjID','F','U',' Match an objID to a PhotoObj and set/unset the first field bit. ',' Given an objID this function determines whether there is a  PhotoObj with a matching (skyversion, run, rerun, camcol, field,   obj) and returns the objID with the first field bit set properly  to correspond to that PhotoObj.  It returns 0 if there is  no corresponding PhotoObj.  It does not matter whether the  first field bit is set or unset in the input objID. ','0');
INSERT DBObjects VALUES('fObjidFromSDSS','F','U',' Computes the long objID from the 5-part SDSS numbers. ',' The bit-fields and their lengths are skyversion[5] + rerun[8] + Run[16] + Camcol[3] + mu[8]+ field[11] + obj[13]<br>  <samp> select dbo.fObjidFromSDSS(752,8,3,300,12) as fObjid</samp> ','0');
INSERT DBObjects VALUES('fObjidFromSDSSWithFF','F','U',' Computes the long objID from the 5-part SDSS numbers plus the firstfield flag. ',' The bit-fields and their lengths are skyversion[5] + rerun[8] + Run[16] + Camcol[3] + mu[8]+ field[11] + obj[13]<br>  <samp> select dbo.fObjidFromSDSS(752,8,3,300,12) as fObjid</samp> ','0');
INSERT DBObjects VALUES('fSDSS','F','U',' Computes the 6-part SDSS numbers from the long objID ',' The bit-fields and their lengths are skyversion[5] + rerun[11] + run[16] + camcol[3] + first[1] + field[12] + obj[16]<br>  <samp> select top 5 dbo.fSDSS(objid) as SDSS from PhotoObj</samp> ','0');
INSERT DBObjects VALUES('fSDSSfromObjID','F','U',' Returns a table pf the 6-part SDSS numbers from the long objID. ',' The returned columns in the output table are:  	skyversion, rerun, run, camcol, firstField, field, obj<br>  <samp> select * from dbo.fSDSSfromObjID(objid)</samp> ','0');
INSERT DBObjects VALUES('fStripeOfRun','F','U',' returns Stripe containing a particular run  ',' <br> run is the run number  <br>  <samp>select top 10 objid, dbo.fStripeOfRun(run) from PhotoObj </samp> ','0');
INSERT DBObjects VALUES('fStripOfRun','F','U',' returns Strip containing a particular run  ',' <br> run is the run number  <br>  <samp>select top 10 objid, dbo.fStripOfRun(run) from PhotoObj </samp> ','0');
INSERT DBObjects VALUES('fDMSbase','F','U',' Base function to convert declination in degrees to +dd:mm:ss.ss notation. ',' @truncate is 0 (default) if decimal digits to be rounded, 1 to be truncated.  <br> @precision is the number of decimal digits, default 2.  <p><samp> select dbo.fDMSbase(87.5,1,4) </samp> <br>  <samp> select dbo.fDMSbase(87.5,default,default) </samp> ','0');
INSERT DBObjects VALUES('fHMSbase','F','U',' Base function to convert right ascension in degrees to +hh:mm:ss.ss notation. ',' @truncate is 0 (default) if decimal digits to be rounded, 1 to be truncated.  <br> @precision is the number of decimal digits, default 2.  <p><samp> select dbo.fHMSBase(187.5,1,3) </samp> <br>  <samp> select dbo.fHMSBase(187.5,default,default) </samp> ','0');
INSERT DBObjects VALUES('fDMS','F','U',' Convert declination in degrees to +dd:mm:ss.ss notation  ',' <i>NOTE: this function should not be used to generate SDSS IAU names,  use fIAUFromEq instead. </i>  <p><samp> select dbo.fDMS(87.5) </samp> ','0');
INSERT DBObjects VALUES('fHMS','F','U',' Convert right ascension in degrees to +hh:mm:ss.ss notation <br> ',' <i>NOTE: this function should not be used to generate SDSS IAU names,  use fIAUFromEq instead. </i>  <p><samp> select dbo.fHMS(187.5) </samp> ','0');
INSERT DBObjects VALUES('fIAUFromEq','F','U',' Convert ra, dec in degrees to extended IAU name ',' Will create a 25 char IAU name as SDSS Jhhmmss.ss+ddmmss.s  <p><samp> select dbo.fIAUFromEq(182.25, -12.5) </samp> ','0');
INSERT DBObjects VALUES('fFirstFieldBit','F','U',' Returns the bit that indicates whether an objID is in the first field of a segment ',' This bit can be added to an objID created with fObjidFromSDSS  to create the correct objID for the case where a PhotoObj  is in the first field of a segment.<br>  <samp> select dbo.fObjidFromSDSS(0,752,8,6,100,300) + dbo.fFirstFieldBit() </samp> ','0');
INSERT DBObjects VALUES('fPrimaryObjID','F','U',' Match an objID to a PhotoPrimary and set/unset the first field bit. ',' Given an objID this function determines whether there is a  PhotoPrimary with a matching  (skyversion, run, rerun, camcol, field, obj)  and returns the objID with the first field bit set properly  to correspond to that PhotoPrimary.  It returns 0 if there is  no corresponding PhotoPrimary.  It does not matter whether the  first field bit is set or unset in the input objID. ','0');
INSERT DBObjects VALUES('fMagToFlux','F','U',' Convert Luptitudes to AB flux in nJy ','  Computes the AB flux for a magnitude given in the   sinh system. The flux is expressed in nanoJy.   Needs the @mag value for the specific band.    @band is 0..4 for u''..z''''.   <br><samp>dbo.fMagToFlux(21.576975,2)</samp>  <br> see also fMagToFluxErr ','0');
INSERT DBObjects VALUES('fMagToFluxErr','F','U',' Convert the error in luptitudes to AB flux in nJy ','  Computes the flux error for a magnitude and its error   expressed in the sinh system. Returns the error in nJy units.   Needs the @mag value as well as the error for the   specific band. @band is 0..4 for u''..z''''.   <br><samp>dbo.fMagToFluxErr(21.576975,0.17968324,2)   </samp>  <br> see also fMagToFlux ','0');
INSERT DBObjects VALUES('fGetPhotoApMag','F','U',' Returns the aperture magnitude and error for the given band (filter) and   aperture. ',' The table returned contains the r-band aperture magnitude and error along  with the PSF magnitude and error, and rowc, colc.  <samp> select apMag_r, apMagErr_r from dbo.fGetPhotoApMag(587726014001184891,''r'',7) </samp> ','0');
INSERT DBObjects VALUES('fPhotoApMag','F','U',' Returns the aperture magnitude for the given filter (band) and aperture. ',' <samp> select TOP 10 objid,                dbo.fPhotoApMag(objid,''r'',7),                dbo.fPhotoApMagErr(objid,''r'',7)         from PhotoObj   </samp> ','0');
INSERT DBObjects VALUES('fPhotoApMagErr','F','U',' Returns the aperture magnitude error for the given filter (band) and  aperture. ',' <samp> select TOP 10 objid,                dbo.fPhotoApMag(objid,''u'',7),                dbo.fPhotoApMagErr(objid,''r'',7)         from PhotoObj   </samp> ','0');
INSERT DBObjects VALUES('fUberCalMag','F','U',' Returns the UberCal corrected magnitude for the given magnitude @mag.  This is intended for magnitudes that do not already have corrected  versions in the UberCal table. ',' <samp> select TOP 10 objid,                dbo.fUberCalMag(objid,expMag_u,''u'') as uberExpMag_u,                dbo.fUberCalMag(objid,expMag_g.''g'') as uberExpMag_g,                dbo.fUberCalMag(objid,expMag_r,''r'') as uberExpMag_r,                dbo.fUberCalMag(objid,expMag_i,''i'') as uberExpMag_i,                dbo.fUberCalMag(objid,expMag_z,''z'') as uberExpMag_z         from PhotoObj   </samp> ','0');
INSERT DBObjects VALUES('detectionIndex','U','U',' Full list of all detections, with associated ''thing'' assignment. ',' Each row in this table corresponds to a single catalog entry,  or ''detection'' in the SDSS imaging. For each one, this table  lists a ''thingId'', which is common among all detections of   the same object in the catalog. ','0');
INSERT DBObjects VALUES('thingIndex','U','U',' Full list of all ''things'': unique objects in the SDSS imaging ',' Each row in this table corresponds to a single ''thing'' observed  by the SDSS imaging survey. By joining with the ''detectionIndex''  table one can retrieve all of the observations of a particular   thing. ','0');
INSERT DBObjects VALUES('Neighbors','U','U',' All PhotoObj pairs within 0.5 arcmins ',' SDSS objects within 0.5 arcmins and their match parameters stored here.   Make sure to filter out unwanted PhotoObj, like secondaries. ','0');
INSERT DBObjects VALUES('Zone','U','U',' Table to organize objects into declination zones ',' In order to speed up all-sky corss-correlations,  this table organizes the PhotoObj into 0.5 arcmin  zones, indexed by the zone number and ra. ','0');
INSERT DBObjects VALUES('PlateX','U','U',' Contains data from a given plate used for spectroscopic observations. ',' Each plate has 640 observed spectra.   WE NEED TO SPECIFY WHERE INFORMATION COMES FROM ','0');
INSERT DBObjects VALUES('SpecObjAll','U','U',' Contains the measured parameters for a spectrum. ',' This is a base table containing <b>ALL</b> the spectroscopic  information, including a lot of duplicate and bad data. Use  the <b>SpecObj</b> view instead, which has the data properly  filtered for cleanliness. ','0');
INSERT DBObjects VALUES('SpecPhotoAll','U','U',' The combined spectro and photo parameters of an object in SpecObjAll ',' This is a precomputed join between the PhotoObjAll and SpecObjAll tables.  The photo attibutes included cover about the same as PhotoTag.  The table also includes certain attributes from Tiles. ','0');
INSERT DBObjects VALUES('fSpecidFromSDSS','F','U',' Computes the long Spec IDs ',' The bit-fields and their lengths are: plate[16] mjd[16] fiber[10] type[6] index[16] <br>  <samp> select dbo.fSpecidFromSDSS(266,51630,145) as specObjID </samp> ','0');
INSERT DBObjects VALUES('fPlate','F','U',' Extracts plate from an SDSS Spec ID ',' The bit-fields and their lengths are: plate[16] mjd[16] fiber[10] type[6] index[16] <br>  <samp> select top 10 dbo.fPlate(plateID) as plate from PlateX </samp> ','0');
INSERT DBObjects VALUES('fMJD','F','U',' Extracts MJD from an SDSS Spec ID ',' The bit-fields and their lengths are: plate[16] mjd[16] fiber[10] type[6] index[16] <br>  <samp> select top 10 dbo.fMJD(plateID) as plate from PlateX </samp> ','0');
INSERT DBObjects VALUES('fFiber','F','U',' Extracts Fiber from an SDSS Spec ID ',' The bit-fields and their lengths are: plate[16] mjd[16] fiber[10] type[6] index[16] <br>  <samp> select top 10 dbo.fFiber(specObjID) as fiber from SpecObj </samp> ','0');
INSERT DBObjects VALUES('spMakeSpecObjAll','P','U','','','0');
INSERT DBObjects VALUES('Target','U','U',' Keeps track of objects chosen by target selection and need to be tiled. ',' Objects are added whenever target selection is run on a new chunk.  Objects are also added when southern target selection is run.  In the case where an object (meaning run,rerun,camcol,field,id) is   targetted more than once, there will be only one row in Target for  that object, but there will multiple entries for that Target in the  TargetInfo table. ','0');
INSERT DBObjects VALUES('TargetInfo','U','U',' Unique information for an object every time it is targetted ',' ','0');
INSERT DBObjects VALUES('sdssTargetParam','U','U',' Contains the parameters used for a version of the target selection code ',' ','0');
INSERT DBObjects VALUES('sdssTileAll','U','U',' Contains information about each individual tile on the sky. ',' Each ''tile'' corresponds to an SDSS-I or -II spectroscopic observation.  The tile covers a region of the 1.49 deg in radius, and corresponds to  one or more observed plates.  At the time the tile was created, all of   the ''tiled target'' categories (galaxies, quasars, and some very special  categories of star) were assigned fibers; later other targets were   assigned fibers on the plate. ','0');
INSERT DBObjects VALUES('sdssTilingRun','U','U',' Contains basic information for a run of tiling  Contains basic information for a run of tiling ','  ','0');
INSERT DBObjects VALUES('sdssTilingGeometry','U','U',' Information about boundary and mask regions in SDSS-I and SDSS-II ',' This table contains both tiling boundary and mask information. ','0');
INSERT DBObjects VALUES('sdssTiledTargetAll','U','U',' Information on all targets run through tiling for SDSS-I and SDSS-II ',' This table is the full list of all targets that were run through  the SDSS tiling routines. targetID refers to the SDSS object  ID associated with the CAS DR7.  ','0');
INSERT DBObjects VALUES('sdssTilingInfo','U','U',' Results of individual tiling runs for each tiled target ',' This table has entry for each time a target was input into  the SDSS tiling routines. targetID refers to the SDSS object  ID associated with the CAS DR7. To get target information,  join this table with sdssTiledTargets on targetID. ','0');
INSERT DBObjects VALUES('Rmatrix','U','U',' Contains various rotation matrices between spherical coordinate systems ','   The mode field is a 3-letter code indicating the transformation:  <ul><li>      S2J - Survey-to-J2000   </li>      <li>      G2J - Galactic-to-J2000 </li>      <li>      J2G - J2000-to-Galactic </li>      <li>      J2S - J2000-to-Survey   </li>  </ul> ','0');
INSERT DBObjects VALUES('Region','U','U',' Definition of the different regions ',' We have various boundaries in the survey, represented  by equations of 3D planes, intersecting the unit sphere,  describing great and small circles, respectively. This  table stores the description of a region, the details  are in the HalfSpace table.  <ul>  <li>CHUNK - the boundary of a given Chunk  <li>STRIPE - the boundary of the whole stripe  <li>STAVE - the unique boundary of the whole stripe,  agrees with STRIPE for Southern stripes  <li>PRIMARY - the primary region of a given CHUNK  <li>SEGMENT - the idealized boundary of a segment  <li>CAMCOL - the real boundary of a segment  <li>PLATE - the boundary of a plate  <li>TILE - the boundary of a circular tile  <li>TIGEOM - the boundary of a Tiling Run, also includes      inverse regions, which must be excluded  <li>RUN - the union of the CAMCOLs making up a Run  <li>WEDGE -- intersection of tiles as booleans.  <li>TILEBOX -- intersection of TIGEOM respecting masks (these are positive convex TIGEOM)  <li>SKYBOX  -- intersection and union of TILEBOX to cover the sky with positive disjoin convex regions.    <li>SECTORLETS -- intersection of Skyboxes with wedges.  These are the areas that have targets.  <li>SECTORS -- collects together all the sectorlets with the same covering (and excluded) tiles.   <br> See also the RegionConvex and Halfspace tables  ','0');
INSERT DBObjects VALUES('RegionPatch','U','U',' Defines the attributes of the patches of a given region ',' Regions are the union of convex hulls and are defined in the Region table.  Convexes are the intersection of halfspaces defined by the HalfSpace table.   Each convex is then broken up into a set of Patches, with their own  bounding circle.  See also the Region table ','0');
INSERT DBObjects VALUES('HalfSpace','U','U',' The contraints for boundaries of the the different regions ',' Boundaries are represented as the equation of a 3D plane,  intersecting the unit sphere. These intersections are  great and small circles. THe representation is in terms  of a 4-vector, (x,y,z,c), where (x,y,z) are the components  of a 3D normal vector pointing along the normal of the plane  into the half-scape inside our boundary, and c is the shift  of the plane along the normal from the origin. Thus, c=0  constraints represent great circles. If c<0, the small circle  contains more than half of the sky.  See also the Region and RegionConvex tables ','0');
INSERT DBObjects VALUES('RegionArcs','U','U',' Contains the arcs of a Region with their endpoints ',' An arc has two endpoints, specified via their equatorial  coordinates, and the equation of the circle (x,y,z,c) of  the arc. The arc is directed, the first point is the  beginning, the second is the end. The arc belongs to a   Region, a Convex and a patch. A patch is a contigous area   of the sky. Within a patch the consecutive arcids represent   a counterclockwise ordering of the vertices. ','0');
INSERT DBObjects VALUES('Sector','U','U',' Stores the information about set of unique Sector regions ',' A Sector is defined as a distinct intersection of tiles and  TilingGeometries, characterized by a unique combination of  intersecting tiles and a list of tilingVersions. The sampling  rate for any targets is unambgously defined by the number of  tiles involved (nTiles) and the combination of targetVersion. ','0');
INSERT DBObjects VALUES('Region2Box','U','U',' Tracks the parentage which regions contribute to which boxes ',' For the sector computation, Region2Box tracks the parentage  of which regions contribute to which boxs.  TileRegions contribute to TileBoxes  TileRegions and TileBoxes contribute to SkyBoxes  Wedges and SkyBoxes contribute to Sectorlets  Sectorlets contribute to Sectors ','0');
INSERT DBObjects VALUES('RegionConvex','V','U',' Emulates the old RegionConvex table for compatibility ',' Implemented as a view, translates patchid to patch ','0');
INSERT DBObjects VALUES('sdssImagingHalfSpaces','U','U',' Half-spaces (caps) describing the SDSS imaging geometry ',' Each row in this table corresponds to a single polygon  in the SDSS imaging data window function. ','0');
INSERT DBObjects VALUES('sdssPolygons','U','U',' Polygons describing SDSS imaging data window function ',' Each row in this table corresponds to a single polygon  in the SDSS imaging data window function. ','0');
INSERT DBObjects VALUES('sdssPolygon2Field','U','U',' Matched list of polygons and fields ',' Each row in this table corresponds to  ','0');
INSERT DBObjects VALUES('sppLines','U','U',' Contains outputs from the SEGUE Stellar Parameter Pipeline (SSPP). ',' Spectra for over 500,000 Galactic stars of all common spectral types are  available with DR8. These Spectra were processed with a pipeline called the  SEGUE Stellar Parameter Pipeline (SSPP, Lee et al. 2008) that computes line indices for a wide  range of common features at the radial velocity of the star in  question. Note that the line indices for TiO5, TiO8, CaH1, CaH2, and CaH3 are calculated following  the prescription given by the Hammer program (Covey et al. 2007). UVCN and BLCN line indices are computed  by he equations given in Smith & Norris (1982), and FeI_4 and FeI_5 indices by the recipe in Friel (1987).  FeI_1, FeI_2, FeI_3, and SrII line indices are only computed from the local continuum.  Thus, these line indices calculated from different methods report the same values for both the local continuum and  the global continuum. These outputs are stored in this table, and indexed on the   specObjID key index parameter for queries joining to other   tables such as specobjall and photoobjall.  See the Sample Queries in  SkyServer for examples of such queries. ','0');
INSERT DBObjects VALUES('sppParams','U','U',' Contains outputs from the SEGUE Stellar Parameter Pipeline (SSPP). ',' Spectra for over 500,000 Galactic stars of all common spectral types are  available with DR8. These Spectra were processed with a pipeline called the  SEGUE Stellar Parameter Pipeline'' (SSPP, Lee et al. 2008) that computes   standard stellar atmospheric parameters such as  [Fe/H], log g and Teff for   each star by a variety of methods. These outputs are stored in this table, and  indexed on the  specObjID'' key index parameter for queries joining to  other tables such as specobjall and photoobjall. bestobjid is also added (and indexed?)  Note that all values of -9999 indicate missing or no values.  See the Sample Queries in SkyServer for examples of such queries.  ','0');
INSERT DBObjects VALUES('sppTargets','U','U',' Derived quantities calculated by the SEGUE-2 target selection pipeline. ',' There are one of these files per plate. The file has one HDU.  That HDU has one row for every object in photoObjAll that is  classified as a star inside a 94.4 arcmin radius of the center of the  plate.  The data for each object are elements of the photoObjAll, specObjAll,   sppPrams and propermotions tables taken unaltered from the CAS and derived   quantities calculated by the segue-2 target selection code.  Appended to the  end are the two target selection bitmasks, segue2_target1 and segue2_target2,   as set by the target selection code.<br> <br>  <i>Columns from OBJID through PSFMAGERR_:</i> <br>  These are taken directly from photoObjAll <br>  <br>  <i>Columns from PLATEID through SEGUE2_TARGET2:</i> <br>  These are taken from the specObjAll and sppParams tables for any  objects in this file that have matches in that specObjAll.  For  objects without matches in specObjAll, values are set to -9999.  The names from SpecObjAll are unchanged. <br> <br>  <i>Columns from MATCH through DIST20: </i><br>  These are taken from the propermotions table, the USNOB proper  motions as recalibrated with the SDSS by Jeff Munn.  For objects  without matches in the ProperMotions table, values are set to -9999.  The names are unchanged from the propermotions table. <br> <br>  <i>Columns from uMAG0 through VTOT_GALRADREST:</i> <br>  These are the derived quanitites calculated  by the procedure  calderivedquantities in derivedquant.pro in the segue-2 target  selection code.  With the addition of these, this file contains all  the quanitites that the selection code operates on when choosing targets.<br> <br>  <i>Columns MG_TOHV through V1SIGMAERR_TOHV:</i> <br>  These were added for the November 2008 drilling run and after.  The earlier files will be retrofit (eventually). ','0');
INSERT DBObjects VALUES('Plate2Target','U','U',' Which objects are in the coverage area of which plates? ',' This table has an entry for each case of a target from the   sppTargets table having been targetable by a given plate.  Can be joined with plateX on the PLATEID column, and with  sppTargets on the OBJID column. Some plates are included  that were never observed; the PLATEID values for these   will not match any entries in the plateX table. ','0');
INSERT DBObjects VALUES('segueTargetAll','U','U',' SEGUE-1 and SEGUE-2 target selection run on all imaging data ',' This table gives the results for SEGUE target selection algorithms  for the full photometric catalog. The target flags in these files   are not the ones actually used for the SEGUE-1 and SEGUE-2 survey.    Instead, they are derived from the final photometric data set from   DR8. Only objects designated RUN_PRIMARY have target selection   flags set.  ','0');
INSERT DBObjects VALUES('Frame','U','U',' Contains JPEG images of fields at various zoom factors, and their astrometry. ',' The frame is the basic image unit. The table contains   false color JPEG images of the fields, and their most  relevant parameters, in particular the coefficients of  the astrometric transformation, and position info.   The images are stored at several zoom levels. ','0');
INSERT DBObjects VALUES('spComputeFrameHTM','P','A',' Compute the HTM and the other params for a Frame. ',' Needs to be run as the last step of the Frame loading.  It should be executed automatically by a DTS script. ','0');
INSERT DBObjects VALUES('spMakeFrame','P','A',' Build the the Frame from the Field table for a given run ',' A support procedure, only used by spLoadZoom. ','0');
INSERT DBObjects VALUES('fTileFileName','F','A',' Builds the filename for Frame, used in spMakeFrame. ',' Another one of the service functions, used only when loading the database. ','0');
INSERT DBObjects VALUES('zooConfidence','U','U',' Measures of classification confidence from Galaxy Zoo. ',' Only galaxies with spectra in DR7 are included (those in the zooSpec table).  This information is identical to that in Galaxy Zoo 1 Table 4.  The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the  data release is described in Lintott et al. 2010. Anyone making use of the   data should cite at least one of these papers in any resulting publications. ','0');
INSERT DBObjects VALUES('zooMirrorBias','U','U',' Results from the bias study using mirrored images from Galaxy Zoo ',' This information is identical to that in Galaxy Zoo 1 Table 5.  The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the  data release is described in Lintott et al. 2010. Anyone making use of the   data should cite at least one of these papers in any resulting publications. ','0');
INSERT DBObjects VALUES('zooMonochromeBias','U','U',' Results from the bias study that introduced monochrome images in Galaxy Zoo. ',' This information is identical to that in Galaxy Zoo 1 Table 6.  The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the  data release is described in Lintott et al. 2010. Anyone making use of the   data should cite at least one of these papers in any resulting publications. ','0');
INSERT DBObjects VALUES('zooNoSpec','U','U',' Morphology classifications of galaxies without spectra from Galaxy Zoo  ',' This information is identical to that in Galaxy Zoo 1 Table 3.   Some objects may have spectroscopic matches in DR8 (though they did   not in DR7) It is not possible to estimate the bias in the sample, and so   only the fraction of the vote in each of the six categories is given.  The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the  data release is described in Lintott et al. 2010. Anyone making use of the   data should cite at least one of these papers in any resulting publications. ','0');
INSERT DBObjects VALUES('zooSpec','U','U',' Morphological classifications of spectroscopic galaxies from Galaxy Zoo ',' This information is identical to that in Galaxy Zoo 1 Table 2.  This table includes galaxies with spectra in SDSS Data Release 7.  The fraction of the vote in each of the six categories is given, along with   debiased votes in elliptical and spiral categories and flags identifying   systems as classified as spiral, elliptical or uncertain.  The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the  data release is described in Lintott et al. 2010. Anyone making use of the   data should cite at least one of these papers in any resulting publications. ','0');
INSERT DBObjects VALUES('zooVotes','U','U',' Vote breakdown in Galaxy Zoo results. ',' Fraction of votes in each of the six categories, combining results from the main   and bias studies. This information is identical to that in Galaxy Zoo 1 Table 7.  The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the  data release is described in Lintott et al. 2010. Anyone making use of the   data should cite at least one of these papers in any resulting publications. ','0');
INSERT DBObjects VALUES('PhotoObj','V','U',' All primary and secondary objects in the PhotoObjAll table, which contains all the attributes of each photometric (image) object.  ',' It selects PhotoObj with mode=1 or 2. ','0');
INSERT DBObjects VALUES('PhotoPrimary','V','U',' These objects are the primary survey objects.  ',' Each physical object   on the sky has only one primary object associated with it. Upon   subsequent observations secondary objects are generated. Since the   survey stripes overlap, there will be secondary objects for over 10%   of all primary objects, and in the southern stripes there will be a   multitude of secondary objects for each primary (i.e. reobservations).  ','0');
INSERT DBObjects VALUES('PhotoSecondary','V','U',' Secondary objects are reobservations of the same primary object. ','','0');
INSERT DBObjects VALUES('PhotoFamily','V','U',' These are in PhotoObj, but neither PhotoPrimary or Photosecondary. ',' These objects are generated if they are neither primary nor   secondary survey objects but a composite object that has been   deblended or the part of an object that has been deblended   wrongfully (like the spiral arms of a galaxy). These objects   are kept to track how the deblender is working. It inherits   all members of the PhotoObj class.  ','0');
INSERT DBObjects VALUES('Star','V','U',' The objects classified as stars from PhotoPrimary ',' The Star view essentially contains the photometric parameters  (no redshifts or spectroscopic parameters) for all primary  point-like objects, including quasars. ','0');
INSERT DBObjects VALUES('Galaxy','V','U',' The objects classified as galaxies from PhotoPrimary. ',' The Galaxy view contains the photometric parameters (no  redshifts or spectroscopic parameters) measured for  resolved primary objects. ','0');
INSERT DBObjects VALUES('PhotoTag','V','U',' The most popular columns from PhotoObjAll. ',' This view contains the most popular columns from the  PhotoObjAll table, and is intended to enable faster  queries if they only request these columns by making   use of the cache.  Performance is also enhanced by  an index covering the columns in this view in the base  table (PhotoObjAll). ','0');
INSERT DBObjects VALUES('StarTag','V','U',' The objects classified as stars from primary PhotoTag objects. ',' The StarTag view essentially contains the abbreviated photometric   parameters from the PhotoTag table (no redshifts or spectroscopic  parameters) for all primary point-like objects, including quasars. ','0');
INSERT DBObjects VALUES('GalaxyTag','V','U',' The objects classified as galaxies from primary PhotoTag objects. ',' The GalaxyTag view essentially contains the abbreviated photometric   parameters from the PhotoTag table (no redshifts or spectroscopic  parameters) for all primary point-like objects, including quasars. ','0');
INSERT DBObjects VALUES('Sky','V','U',' The objects selected as sky samples in PhotoPrimary ','','0');
INSERT DBObjects VALUES('Unknown','V','U',' Everything in PhotoPrimary, which is not a galaxy, star or sky ','','0');
INSERT DBObjects VALUES('SpecPhoto','V','U',' A view of joined Spectro and Photo objects that have the clean spectra. ',' The view includes only those pairs where the SpecObj is a  sciencePrimary, and the BEST PhotoObj is a PRIMARY (mode=1). ','0');
INSERT DBObjects VALUES('SpecObj','V','U',' A view of Spectro objects that just has the clean spectra. ',' The view excludes QA and Sky and duplicates. Use this as the main  way to access the spectro objects. ','0');
INSERT DBObjects VALUES('Columns','V','U',' Aliias the DBColumns table also as Columns, for legacy SkyQuery ','','0');
INSERT DBObjects VALUES('segue1SpecObjAll','V','U',' A view of specObjAll that includes only SEGUE1 spectra ',' The view excludes spectra that are not part of the SEGUE1 program. ','0');
INSERT DBObjects VALUES('segue2SpecObjAll','V','U',' A view of specObjAll that includes only SEGUE2 spectra ',' The view excludes spectra that are not part of the SEGUE2 program. ','0');
INSERT DBObjects VALUES('segueSpecObjAll','V','U',' A view of specObjAll that includes only SEGUE1+SEGUE2 spectra ',' The view excludes spectra that are not part of the SEGUE1  or SEGUE2 programs. ','0');
INSERT DBObjects VALUES('sdssTile','V','U',' A view of sdssTileAll that have untiled=0 ',' The view excludes those sdssTiles that have been untiled. ','0');
INSERT DBObjects VALUES('sdssTilingBoundary','V','U',' A view of sdssTilingGeometry objects that have isMask = 0 ',' The view excludes those sdssTilingGeometry objects that have   isMask = 1.  See also sdssTilingMask. ','0');
INSERT DBObjects VALUES('sdssTilingMask','V','U',' A view of sdssTilingGeometry objects that have isMask = 1 ',' The view excludes those sdssTilingGeometry objects that have   isMask = 0.  See also sdssTilingBoundary. ','0');
INSERT DBObjects VALUES('TableDesc','V','U',' Extract the description and index group of each table in schema. ',' The view extracts the description of each table from the   DBObjects table and the index group from the IndexMap table.  This allows all table descriptions to be viewed in one list. ','0');
INSERT DBObjects VALUES('fSphGetVersion','F','U',' Returns the version string as in the assembly. ','','0');
INSERT DBObjects VALUES('fSphGetArea','F','U',' Returns the area of region stored in the specified blob. ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fSphGetRegionStringBin','F','U',' Returns the regionstring in a blob. Used internally. ',' Parameter(s):  <li> @bin varbinary(max): region blob  see fSphGetRegionString. ','0');
INSERT DBObjects VALUES('fSphConvexAddHalfspace','F','U',' Adds the specified halfspaces to a given convex and returns the new region blob.  ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @cidx int: convex index  <li> @x float: halfspace vector''s X coordinate  <li> @y float: halfspace vector''s y coordinate  <li> @z float: halfspace vector''s Z coordinate  <li> @c float: halfspace offset ','0');
INSERT DBObjects VALUES('fSphSimplifyBinary','F','U',' Simplifies the region in the specified blob created w/ fSphConvexAddHalfspace(). ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fSphSimplifyBinaryAdvanced','F','U',' Simplifies the region in the specified blob created with fSphConvexAddHalfspace ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @simple_simplify bit: determines whether to run trivial convex simplification  <li> @convex_eliminate bit: determines whether to attempt eliminating convexes  <li> @convex_disjoint bit: determines whether to make convexes disjoint  <li> @convex_unify bit: determines whether to attempt stiching convexes ','0');
INSERT DBObjects VALUES('fSphSimplifyString','F','U',' Simplifies the region in the specified string and returns its blob. ',' Parameter(s):  <li> @str nvarchar(max): region string ','0');
INSERT DBObjects VALUES('fSphSimplifyStringAdvanced','F','U',' Simplifies the region in the specified string and returns its blob. ',' Parameter(s):  <li> @str nvarchar(max): region string  <li> @simple_simplify bit: determines whether to run trivial convex simplification  <li> @convex_eliminate bit: determines whether to attempt eliminating convexes  <li> @convex_disjoint bit: determines whether to make convexes disjoint  <li> @convex_unify bit: determines whether to attempt stiching convexes ','0');
INSERT DBObjects VALUES('fSphSimplifyQuery','F','U',' Simplifies the region defined by the specified query that yields halfspaces. ',' Parameter(s):  <li> @cmd nvarchar(max): query string ','0');
INSERT DBObjects VALUES('fSphSimplifyQueryAdvanced','F','U',' Simplifies the region defined by the specified query that yields halfspaces. ',' Parameter(s):  <li> @cmd nvarchar(max): query string  <li> @simple_simplify bit: determines whether to run trivial convex simplification  <li> @convex_eliminate bit: determines whether to attempt eliminating convexes  <li> @convex_disjoint bit: determines whether to make convexes disjoint  <li> @convex_unify bit: determines whether to attempt stiching convexes ','0');
INSERT DBObjects VALUES('fSphGrow','F','U',' Grows a region by the given amount and returns its blob. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @degree float: amount of grow ','0');
INSERT DBObjects VALUES('fSphGrowAdvanced','F','U',' Grows a region by the given amount and returns its blob. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @degree float: amount of grow  <li> @simple_simplify bit: determines whether to run trivial convex simplification  <li> @convex_eliminate bit: determines whether to attempt eliminating convexes  <li> @convex_disjoint bit: determines whether to make convexes disjoint  <li> @convex_unify bit: determines whether to attempt stiching convexes ','0');
INSERT DBObjects VALUES('fSphUnion','F','U',' Derives the union of the given regions. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @bin2 varbinary(max): other blob ','0');
INSERT DBObjects VALUES('fSphIntersect','F','U',' Derives the intersection of the given regions. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @bin2 varbinary(max): other blob ','0');
INSERT DBObjects VALUES('fSphUnionAdvanced','F','U',' Derives the union of the given regions. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @bin2 varbinary(max): other blob  <li> @convex_unify bit: determines whether to attempt stiching convexes ','0');
INSERT DBObjects VALUES('fSphIntersectAdvanced','F','U',' Derives the intersection of the given regions. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @bin2 varbinary(max): other blob  <li> @convex_unify bit: determines whether to attempt stiching convexes ','0');
INSERT DBObjects VALUES('fSphUnionQuery','F','U',' Derives the union of regions returned by the specified query. ',' Parameter(s):  <li> @cmd nvarchar(max): query string  <li> @convex_unify bit: determines whether to attempt stiching convexes  Note: The query should return region blobs. ','0');
INSERT DBObjects VALUES('fSphIntersectQuery','F','U',' Derives the intersection of regions returned by the specified query. ',' Parameter(s):  <li> @cmd nvarchar(max): query string  <li> @convex_unify bit: determines whether to attempt stiching convexes  Note: The query should return region blobs. ','0');
INSERT DBObjects VALUES('fSphDiffAdvanced','F','U',' Derives the difference of the given regions. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @bin2 varbinary(max): other blob  <li> @simple_simplify bit: determines whether to run trivial convex simplification  <li> @convex_eliminate bit: determines whether to attempt eliminating convexes  <li> @convex_disjoint bit: determines whether to make convexes disjoint  <li> @convex_unify bit: determines whether to attempt stiching convexes ','0');
INSERT DBObjects VALUES('fSphDiff','F','U',' Derives the difference of the given regions. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @bin2 varbinary(max): other blob ','0');
INSERT DBObjects VALUES('fSphGetHalfspaces','F','U',' Returns the halfspaces of the specified region blob. ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fSphGetConvexes','F','U',' Returns the convexes of the specified region in separate region blobs. ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fSphGetPatches','F','U',' Returns the patches of the specified region. ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fSphGetArcs','F','U',' Returns the arcs of the specified region. ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fSphGetOutlineArcs','F','U',' Returns the outline arcs of the specified region. ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fSphGetHtmRanges','F','U',' Calculates HTM covers for the specified region. ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fSphGetHtmRangesAdvanced','F','U',' Calculates HTM covers for the specified region. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @frac float: limiting pseudo area fraction (inner/outer)  <li> @seconds float: time limit ','0');
INSERT DBObjects VALUES('fSphRegionContainsXYZ','F','U',' Returns whether the specified region contains the given location. ',' Parameter(s):  <li> @bin varbinary(max): region blob  <li> @x float: direction''s X-coordinate  <li> @y float: direction''s Y-coordinate  <li> @z float: direction''s Z-coordinate ','0');
INSERT DBObjects VALUES('fSphSimplifyAdvanced','F','U',' Simplifies the region defined by the specified ID. ',' Parameter(s):  <li> @id bigint: region id  <li> @simple_simplify bit: determines whether to run trivial convex simplification  <li> @convex_eliminate bit: determines whether to attempt eliminating convexes  <li> @convex_disjoint bit: determines whether to make convexes disjoint  <li> @convex_unify bit: determines whether to attempt stiching convexes ','0');
INSERT DBObjects VALUES('fSphSimplify','F','U',' Simplifies the region defined by the specified ID. ',' Parameter(s):  <li> @id bigint: region id ','0');
INSERT DBObjects VALUES('fSphGetRegionString','F','U',' Returns the regionstring of the specified region. ',' Parameter(s):  <li> @bin varbinary(max): region blob ','0');
INSERT DBObjects VALUES('fHtmVersion','F','U',' Returns version of installed HTM library as a string ',' <samp> select dbo.fHtmVersion() </samp>   ','0');
INSERT DBObjects VALUES('fHtmEq','F','U',' Returns htmid of a given point from an RA and DEC in J2000 ',' <li> @ra float:  J2000 right ascension in degrees  <li> @dec float: J2000 right declination in degrees  <li> returns htmID bigint:  htmid of this point  <br><samp> select dbo.fHtmEq(180,0):14843406974976 /samp>    <br> see also fHtmXyz  ','0');
INSERT DBObjects VALUES('fHtmXyz','F','U',' Returns htmid given x,y,z in cartesian coordinates in J2000 ',' Returns the Hierarchical Triangular Mesh (HTM) ID of a given point,  given x,y,z in cartesian (J2000) reference frame. The vector   (x,y,z) will be normalized to unit vector if non-zero and set to   (1,0,0) if zero. Returns the 21-deep htmid of this object.<br>  Parameters:<br>  <li> @x float, unit vector for ra+dec  <li> @y float, unit vector for ra+dec  <li> @z float, unit vector for ra+dec  <li> returns htmID bigint   <br><samp> select dbo.fHtmXyz(1,0,0) </samp>  <br> gives 17042430230528    <br> see also fHtmEq  ','0');
INSERT DBObjects VALUES('fHtmGetString','F','U','  Converts an HTMID to its string representation  ',' <br>Parameters:  <li>htmid bigint: 21-deep htmid of this point  <li> returns varchar(max) The string format is (N|S)[0..3]*    <br> For example S130000013 is on the second face of the    southern hemisphere, i.e. ra is between 6h and 12h     <samp>print  dbo.fHtmToString(dbo.fHtmEq(195,2.5))   <br> gives: N120131233021223031323 </samp> ','0');
INSERT DBObjects VALUES('fHtmGetCenterPoint','F','U','  Converts an HTMID to a (x,y,z) vector of the HTM centerpoint   ',' <br>Parameters:  <li>@htmid bigint, the htmid of the trixel  <br>Returns VertexTable(x float, y float, z float) of a single  row with the unit vector of the trixel center.   <samp>select * from  fHtmToCenterPoint(dbo.fHtmXyz(.57735,.57735,.57735))   <br> gives: 0.577350269189626, 0.577350269189626, 0.577350269189626    </samp> ','0');
INSERT DBObjects VALUES('fHtmGetCornerPoints','F','U','  Converts an HTMID to the trixel''s vertices as cartesian vectors ',' <br>Parameter:  <li>htmid bigint, htmid of the trixel  <br>Returns VertexTable(x float, y float, z float)   with three rows contining the trixel''s vertices   <samp>select * from  fHtmToCornerPoints(8)   <br> gives:   <br>        1 0 0   <br>        0 0 0   <br>        0 1 0   </samp> ','0');
INSERT DBObjects VALUES('fHtmCoverCircleEq','F','U',' Returns the HTM Cover of a circle with a given ra,dec and radius ',' Returns a table of htmid ranges describing an HTM cover  for a circle centered at J2000 ra,dec (in degrees)  within  @radius arcminutes of that centerpoint.  <br>Parameters:<br>  <li> @ra  float, J2000 right ascension in degrees  <li> @dec float, J2000 declination in degrees  <li> @radius float, radius in arcminutes  <li> returns trixel table(HtmIDStart bigint, HtmIDEnd bigint)  <br><samp> select * from fHtmCoverCircleEq( 190,0,1)</samp>    <br> see also fHtmCoverCircleXyz, fHtmCoverRegioin ','0');
INSERT DBObjects VALUES('fHtmCoverCircleXyz','F','U',' Returns HTM cover for a circle given with cartesian vector (x,y,z), radius ',' Returns a table of HTMID ranges covering a circle centered at CARTESIAN @x,@y,@z   within  @radius arcminutes of that centerpoint  <li> @x float, @y float, @z float, cartesian unit vector for point  <li> @radius float, radius in arcmins   <br> Returns trixel table(HtmIDStart bigint, HtmIDEnd bigint)  <br><samp> select * from fHtmCoverCircleXyz( 1,0,0, 1)</samp>    <br> see also fHtmCoverCircleEq fHtmCoverRegion  ','0');
INSERT DBObjects VALUES('fHtmCoverRegion','F','U',' Returns HTMID range table covering the designated region ',' Regions have the syntax  <pre>  circleSpec  =>     CIRCLE J2000 ra dec  radArcMin  <br>             |       CIRCLE CARTESIAN x y z   radArcMin <br>  rectSpec    =>     RECT J2000      {ra dec }2 <br>             |       RECT CARTESIAN  {x y z  }2 <br>  polySpec    =>     POLY J2000      {ra dec }3+ <br>             |       POLY CARTESIAN  {x y z  }3+ <br>  hullSpec    =>     CHULL J2000     {ra dec }3+ <br>             |       CHULL CARTESIAN {x y z  }3+ <br>  convexSpec	 =>     CONVEX { x y z D}* <br>  coverSpec	 =>     circleSpec | rectSpec | polySpec | hullSpec | convexSpec <br>  regionSpec	 =>     REGION {coverSpec}* | coverspec <br>  for the circle the REGION prefix is optional.  </pre>   <br> returns trixel table(start bigint, end bigint)  <br><samp>  select * from dbo.fHtmCoverRegion(''REGION CIRCLE CARTESIAN -.996 -.1 0 5'')  </samp>    <br>see also fHtmCoverRegionError  ','0');
INSERT DBObjects VALUES('fHtmCoverRegionError','F','U',' Returns an error message describing what is wrong with @region.  ',' Regions have the syntax  <pre>  circleSpec  =>     CIRCLE J2000 ra dec  radArcMin  <br>             |       CIRCLE CARTESIAN x y z   radArcMin <br>  rectSpec    =>     RECT J2000      {ra dec }2 <br>             |       RECT CARTESIAN  {x y z  }2 <br>  polySpec    =>     POLY J2000      {ra dec }3+ <br>             |       POLY CARTESIAN  {x y z  }3+ <br>  hullSpec    =>     CHULL J2000     {ra dec }3+ <br>             |       CHULL CARTESIAN {x y z  }3+ <br>  convexSpec	 =>     CONVEX { x y z D}* <br>  coverSpec	 =>     circleSpec | rectSpec | polySpec | hullSpec | convexSpec <br>  regionSpec	 =>     REGION {coverSpec}* | coverspec <br>  for the circle the REGION prefix is optional.  </pre>   <li> Returns: OK, or string giving the above syntax if the region description is in error.   <br><samp>select dbo.fHtmRegionError(''CIRCLE LATLON 190'')</samp>    <br>see also fHtmCoverRegion ','0');
INSERT DBObjects VALUES('fDistanceEq','F','U',' returns distance (arcmins) between two points (ra1,dec1) and (ra2,dec2) ',' <br> @ra1, @dec1, @ra2, @dec2 are in degrees  <br><samp>select top 10 objid, dbo.fDistanceEq(185,0,ra,dec) from PhotoObj </samp> ','0');
INSERT DBObjects VALUES('fDistanceXyz','F','U',' returns distance (arcmins) between two points (x1,y1,z1) and (x2,y1,z2) ',' <br> x1,y1,z1 and x2,y2,z2 are cartesian unit vectors   <br><samp>select top 10 objid, dbo.fDistanceXyz(1,0,0,cx,cy,cz) from PhotoObj </samp> ','0');
INSERT DBObjects VALUES('fHtmEqToXyz','F','U',' Convert Ra, Dec to Cartesian coordinates (x, y, z) ',' <br>Parameters:  <li>@ra float, Right Ascension  <li>@dec float, Declination  <br>Returns single row table containing the vector (x, y, z)  <samp>select * from dbo.fHtmEqToXyz(-180.0, 0.0)  <br> gives:  x  y  z  <br>        -1  0  0  </samp> ','0');
INSERT DBObjects VALUES('fHtmXyzToEq','F','U',' Convert Cartesian coordinates (x, y, z) to Ra, Dec ',' (x, y, z) will be normalized unless (x, y, z) is close to (0,0,0)  <br>Parameters:  <li>@x float, @y float, @z float, the cartesian normal vector  <br>Returns single row table containing the values (ra, dec)  <samp>select * from dbo.fHtmXyzToEq(0.0, 0.0, -1.0)  <br> gives:  ra  dec  <br>          0  -90  </samp> ','0');
INSERT DBObjects VALUES('fGetNearbyObjEq','F','U',' Given an equatorial point (@ra,@dec), returns table of primary objects  within @r arcmins of the point.  There is no limit on @r.  ',' <br> ra, dec are in degrees, r is in arc minutes.  <br>There is no limit on the number of objects returned, but there are about 40 per sq arcmin.    <p> returned table:    <li> objID bigint NOT NULL       -- Photo primary object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br>  Sample call to find all the Galaxies within 3 arcminutes of ra,dec 185,0<br>  <samp>   <br> select *   <br> from Galaxy                       as G,   <br>      dbo.fGetNearbyObjEq(185,0,3) as N  <br> where G.objID = N.objID  </samp>   <br> see also fGetNearestObjEq, fGetNearbyObjXYZ, fGetNearestObjXYZ ','0');
INSERT DBObjects VALUES('fGetNearbyObjAllEq','F','U',' Given an equatorial point (@ra,@dec), this function returns a table of all   objects within @r arcmins of the point.  There is no limit on @r. ',' <br> ra, dec are in degrees, r is in arc minutes.  <br>There is no limit on the number of objects returned, but there are about 40 per sq arcmin.    <p> returned table:    <li> objID bigint NOT NULL,      -- Photo object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br>  Sample call to find all the Galaxies within 3 arcminutes of ra,dec 185,0<br>  <samp>   <br> select *   <br> from Galaxy                       as G,   <br>      dbo.fGetNearbyObjEq(185,0,3) as N  <br> where G.objID = N.objID  </samp>   <br> see also fGetNearestObjEq, fGetNearbyObjAllXYZ, fGetNearestObjXYZ ','0');
INSERT DBObjects VALUES('spNearestObjEq','P','U',' Returns table containing the nearest primary object within @r arcmins of an Equatorial point (@ra,@dec) ',' <br>For the Navigator. Returns the nearest primary object to a given point  <br> ra, dec are in degrees.  <p> returned table:    <li> run int,           		-- run that observed this primary object     <li> objID bigint,   		-- Photo object identifier  <li> ra varchar(10),   		-- ra rounded to 5 decimal places.  <li> dec varchar(8),   		-- dec rounded to 5 decimal places.  <li> type varchar(8),        	-- type: galaxy, star, sky...   <li> U, G, R, I, Z,  varchar(6), 	-- magnitude/luptitude rounded to 2 digits.  <li> distance varchar(6)        	-- distance in arc minutes to this object from the ra,dec.  <br>  Sample call to find all the Galaxies within 2 arcminutes of ra,dec 185,-0.5  <br>  <samp>   <br> EXEC spNearestObjEq 185.0 -0.5 2  </samp>   <br> see also fGetNearbyObjEq, fGetNearestObjEq, fGetNearbyObjXYZ, fGetNearestObjXYZ ','0');
INSERT DBObjects VALUES('fGetNearestObjEq','F','U',' Returns table holding a record describing the closest primary object within @r arcminutes of (@ra,@dec). ',' <br> ra, dec are in degrees, r is in arc minutes.  <p> returned table:   <li> objID bigint,               -- Photo primary object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br  Sample call to find the PhotoObject within 1 arcminutes of ra,dec 185,0  <br><samp>  <br> select *   <br> from   dbo.fGetNearestObjEq(185,0,1)     </samp>    <br> see also fGetNearbyObjEq, fGetNearbyObjXYZ, fGetNearestObjXYZ ','0');
INSERT DBObjects VALUES('fGetNearestObjAllEq','F','U',' Returns table holding a record describing the closest object within @r arcminutes of (@ra,@dec). ',' <br> ra, dec are in degrees, r is in arc minutes.  <p> returned table:   <li> objID bigint,               -- Photo primary object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br  Sample call to find the PhotoObject within 1 arcminutes of ra,dec 185,0  <br><samp>  <br> select *   <br> from   dbo.fGetNearestObjAllEq(185,0,1)     </samp>    <br> see also fGetNearbyObjAllEq, fGetNearbyObjAllXYZ ','0');
INSERT DBObjects VALUES('fGetNearestObjIdEq','F','U',' Returns the objId of nearest photoPrimary within @r arcmins of ra, dec ',' <br> ra, dec are in degrees, r is in arc minutes.  <br>This scalar function is used for matchups of external catalogs.  <br>It calls  <samp>fGetNearestObjEq(@ra,@dec,@r)</samp>, and selects   the objId (a bigint).   <br>This can be called by a single SELECT from an uploaded (ra,dec) table.  <br>An example:   <br><samp>  <br>  SELECT id, ra,dec, dbo.fGetNearestObjIdEq(ra,dec,3.0) as objId  <br>      FROM #upload  <br>      WHERE dbo.fGetNearestObjIdEq(ra,dec,3.0) IS NOT NULL </samp><p> ','0');
INSERT DBObjects VALUES('fGetNearestObjIdAllEq','F','U',' Returns the objId of nearest photo object within @r arcmins of ra, dec ',' <br> ra, dec are in degrees, r is in arc minutes.  <br>This scalar function is used for matchups of external catalogs.  <br>It calls  <samp>fGetNearestObjAllEq(@ra,@dec,@r)</samp>, and selects   the objId (a bigint).   <br>This can be called by a single SELECT from an uploaded (ra,dec) table.  <br>An example:   <br><samp>  <br>  SELECT id, ra,dec, dbo.fGetNearestObjIdAllEq(ra,dec,3.0) as objId  <br>      FROM #upload  <br>      WHERE dbo.fGetNearestObjIdAllEq(ra,dec,3.0) IS NOT NULL </samp><p> ','0');
INSERT DBObjects VALUES('fGetNearestObjIdEqType','F','U',' Returns the objID of the nearest photPrimary of type @t within @r arcmin ',' <br> ra, dec are in degrees, r is in arc minutes.  <br> t is an integer drawn from the PhotoType table.   <br> popular types are 3: GALAXY, 6: STAR  <br> others: 0: UNKNOWN, 1:COSMIC_RAY  2: DEFECT, 4: GHOST, 5: KNOWNOBJ, 7:TRAIL, 8: SKY   This scalar function is used for matchups of external catalogs.  It calls the <samp>fGetNearbyObjEq(@ra,@dec,@r)</samp>, and selects  the objId (a bigint). This can be called by a single SELECT from an uploaded  (ra,dec) table.  <br>An example:   <br><samp>  <br>  SELECT id, ra,dec, dbo.fGetNearestObjIdEqType(ra,dec,3.0,6) as objId  <br>      FROM #upload  <br>      WHERE dbo.fGetNearestObjIdEqType(ra,dec,3.0,6) IS NOT NULL </samp><p> ','0');
INSERT DBObjects VALUES('fGetNearestObjIdEqMode','F','U',' Returns the objId of nearest @mode PhotoObjAll within @r arcmins of ra, dec ',' <br> ra, dec are in degrees, r is in arc minutes.  <br>This scalar function is used for matchups of external catalogs.  <br>It calls  <samp>fGetNearestObjEq(@ra,@dec,@r)</samp>, and selects   the objId (a bigint).   <br>This can be called by a single SELECT from an uploaded (ra,dec) table.  <br>An example:   <br><samp>  <br>  SELECT id, ra,dec, dbo.fGetNearestObjIdEq(ra,dec,3.0) as objId  <br>      FROM #upload  <br>      WHERE dbo.fGetNearestObjIdEq(ra,dec,3.0) IS NOT NULL </samp><p> ','0');
INSERT DBObjects VALUES('fGetNearbyObjXYZ','F','U',' Returns table of primary objects within @r arcmins of an xyz point (@nx,@ny, @nz). ',' There is no limit on the number of objects returned, but there are about 40 per sq arcmin.  <p>returned table:    <li> objID bigint,               -- Photo primary object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br> Sample call to find PhotoObjects within 5 arcminutes of xyz -.0996,-.1,0  <br><samp>  <br>select *  <br> from  dbo.fGetNearbyObjXYZ(-.996,-.1,0,5)    </samp>    <br>see also fGetNearbyObjEq, fGetNearestObjXYZ, fGetNearestObjXYZ ','0');
INSERT DBObjects VALUES('fGetNearbyObjAllXYZ','F','U',' Returns table of photo objects within @r arcmins of an xyz point (@nx,@ny, @nz). ',' There is no limit on the number of objects returned, but there are about 40 per sq arcmin.  <p>returned table:    <li> objID bigint,               -- Photo primary object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> mode tinyint NOT NULL,      -- mode of photoObj  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br> Sample call to find PhotoObjects within 5 arcminutes of xyz -.0996,-.1,0  <br><samp>  <br>select *  <br> from  dbo.fGetNearbyObjXYZ(-.996,-.1,0,5)    </samp>    <br>see also fGetNearbyObjEq, fGetNearestObjXYZ, fGetNearestObjXYZ ','0');
INSERT DBObjects VALUES('fGetNearestObjXYZ','F','U',' Returns nearest primary object within @r arcminutes of an xyz point (@nx,@ny, @nz). ',' <p> returned table:    <li> objID bigint,               -- Photo primary object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br>  Sample call to find the nearest PhotoObject within 1/2 arcminute  of xyz -.0996,-.1,0   <br><samp>   <br> select *   <br> from  dbo.fGetNearestObjXYZ(-.996,-.1,0,0.5)     </samp>     <br>see also fGetNearbyObjEq, fGetNearestObjEq, fGetNearbyObjXYZ,  ','0');
INSERT DBObjects VALUES('fGetNearestSpecObjIdEq','F','U',' Returns the specObjId of nearest sciencePrimary spectrum within @r arcmins of ra, dec ',' <br> ra, dec are in degrees, r is in arc minutes.  <br>This scalar function is used for matchups of external catalogs.  <br>It calls  <samp>fGetNearestSpecObjEq(@ra,@dec,@r)</samp>, and selects   the specObjId (a bigint).   <br>This can be called by a single SELECT from an uploaded (ra,dec) table.  <br>An example:   <br><samp>  <br>  SELECT id, ra,dec, dbo.fGetNearestSpecObjIdEq(ra,dec,3.0) as specObjId  <br>      FROM #upload  <br>      WHERE dbo.fGetNearestSpecObjIdEq(ra,dec,3.0) IS NOT NULL </samp><p> ','0');
INSERT DBObjects VALUES('fGetNearestSpecObjIdAllEq','F','U',' Returns the specObjID of nearest photo object within @r arcmins of ra, dec ',' <br> ra, dec are in degrees, r is in arc minutes.  <br>This scalar function is used for matchups of external catalogs.  <br>It calls  <samp>fGetNearestSpecObjAllEq(@ra,@dec,@r)</samp>, and selects   the specObjID (a bigint).   <br>This can be called by a single SELECT from an uploaded (ra,dec) table.  <br>An example:   <br><samp>  <br>  SELECT id, ra,dec, dbo.fGetNearestSpecObjIdAllEq(ra,dec,3.0) as specObjID  <br>      FROM #upload  <br>      WHERE dbo.fGetNearestSpecObjIdAllEq(ra,dec,3.0) IS NOT NULL </samp><p> ','0');
INSERT DBObjects VALUES('fGetNearbySpecObjXYZ','F','U',' Returns table of scienceprimary spectrum objects within @r arcmins of an xyz point (@nx,@ny, @nz). ',' There is no limit on the number of objects returned, but there are about 40 per sq arcmin.  <p>returned table:    <li> specObjID bigint,               -- Photo primary object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> mode tinyint NOT NULL,      -- mode of photoObj  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br> Sample call to find SpecObj within 5 arcminutes of xyz -.0996,-.1,0  <br><samp>  <br>select *  <br> from  dbo.fGetNearbySpecObjXYZ(-.996,-.1,0,5)    </samp>    <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearbySpecObjAllXYZ ','0');
INSERT DBObjects VALUES('fGetNearbySpecObjAllXYZ','F','U',' Returns table of all spectrum objects within @r arcmins of an xyz point (@nx,@ny, @nz). ',' There is no limit on the number of objects returned.  <p>returned table:    <li> objID bigint,               -- Photo primary object identifier  <li> run int NOT NULL,           -- run that observed this object     <li> camcol int NOT NULL,        -- camera column that observed the object  <li> field int NOT NULL,         -- field that had the object  <li> rerun int NOT NULL,         -- computer processing run that discovered the object  <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)  <li> mode tinyint NOT NULL,      -- mode of photoObj  <li> cx float NOT NULL,          -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object  <li> distance float              -- distance in arc minutes to this object from the ra,dec.  <br> Sample call to find SpecObj within 0.5 arcminutes of xyz -.0996,-.1,0  <br><samp>  <br>select *  <br> from  dbo.fGetNearbySpecObjAllXYZ(-.996,-.1,0,0.5)    </samp>    <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearestSpecObjXYZ ','0');
INSERT DBObjects VALUES('fGetNearestSpecObjXYZ','F','U',' Returns nearest scienceprimary specobj within @r arcminutes of an xyz point (@nx,@ny, @nz). ',' <p> returned table:    <li>  specObjID bigint,		-- unique spectrum ID  <li>  plate int NOT NULL,		-- spectroscopic plate number  <li>  mjd int NOT NULL,		-- MJD of observation  <li>  fiberID int NOT NULL,	-- fiber number on plate  <li>  z real NOT NULL,		-- final spectroscopic redshift  <li>  zErr real NOT NULL,		-- redshift error  <li>  zWarning int NOT NULL,	-- warning flags  <li>  cx float NOT NULL,		-- x of normal unit vector in J2000  <li>  cy float NOT NULL,		-- y of normal unit vector in J2000  <li>  cz float NOT NULL,		-- z of normal unit vector in J2000  <li>  htmID bigint,		-- 20-deep HTM ID  <li>  distance float		-- distance in arc minutes  <br>  Sample call to find the nearest SpecObj within 1/2 arcminute  of xyz -.0996,-.1,0   <br><samp>   <br> select *   <br> from  dbo.fGetNearestSpecObjXYZ(-.996,-.1,0,0.5)     </samp>     <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjEq, fGetNearbySpecObjXYZ,  ','0');
INSERT DBObjects VALUES('fGetNearestSpecObjAllXYZ','F','U',' Returns nearest specobj within @r arcminutes of an xyz point (@nx,@ny, @nz). ',' <p> returned table:    <li>  specObjID bigint,		-- unique spectrum ID  <li>  plate int NOT NULL,		-- spectroscopic plate number  <li>  mjd int NOT NULL,		-- MJD of observation  <li>  fiberID int NOT NULL,	-- fiber number on plate  <li>  z real NOT NULL,		-- final spectroscopic redshift  <li>  zErr real NOT NULL,		-- redshift error  <li>  zWarning int NOT NULL,	-- warning flags  <li>  sciencePrimary int NOT NULL,	-- deemed to be science-worthy or not  <li>  cx float NOT NULL,		-- x of normal unit vector in J2000  <li>  cy float NOT NULL,		-- y of normal unit vector in J2000  <li>  cz float NOT NULL,		-- z of normal unit vector in J2000  <li>  htmID bigint,		-- 20-deep HTM ID  <li>  distance float		-- distance in arc minutes  <br>  Sample call to find the nearest SpecObj within 1/2 arcminute  of xyz -.0996,-.1,0   <br><samp>   <br> select *   <br> from  dbo.fGetNearestSpecObjAllXYZ(-.996,-.1,0,0.5)     </samp>     <br>see also fGetNearbySpecObjAllEq, fGetNearestSpecObjAllEq, fGetNearbySpecObjAllXYZ,  ','0');
INSERT DBObjects VALUES('fGetNearbySpecObjEq','F','U',' Returns table of spectrum objects within @r arcmins of an equatorial point (@ra, @dec). ',' There is no limit on the number of objects returned.  <p>returned table:    <li>  specObjID bigint,		-- unique spectrum ID  <li>  plate int NOT NULL,		-- spectroscopic plate number  <li>  mjd int NOT NULL,		-- MJD of observation  <li>  fiberID int NOT NULL,	-- fiber number on plate  <li>  z real NOT NULL,		-- final spectroscopic redshift  <li>  zErr real NOT NULL,		-- redshift error  <li>  zWarning int NOT NULL,	-- warning flags  <li>  cx float NOT NULL,		-- x of normal unit vector in J2000  <li>  cy float NOT NULL,		-- y of normal unit vector in J2000  <li>  cz float NOT NULL,		-- z of normal unit vector in J2000  <li>  htmID bigint,		-- 20-deep HTM ID  <li>  distance float		-- distance in arc minutes  <br> Sample call to find SpecObj within 0.5 arcminutes of ra,dec 180.0, -0.5  <br><samp>  <br>select *  <br> from  dbo.fGetNearbySpecObjXYZ(180.0, -0.5, 0,5)    </samp>    <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearestSpecObjXYZ ','0');
INSERT DBObjects VALUES('fGetNearbySpecObjAllEq','F','U',' Returns table of spectrum objects within @r arcmins of an equatorial point (@ra, @dec). ',' There is no limit on the number of objects returned.  <p>returned table:    <li>  specObjID bigint,		-- unique spectrum ID  <li>  plate int NOT NULL,		-- spectroscopic plate number  <li>  mjd int NOT NULL,		-- MJD of observation  <li>  fiberID int NOT NULL,	-- fiber number on plate  <li>  z real NOT NULL,		-- final spectroscopic redshift  <li>  zErr real NOT NULL,		-- redshift error  <li>  zWarning int NOT NULL,	-- warning flags  <li>  sciencePrimary int NOT NULL,	-- deemed to be science-worthy or not  <li>  cx float NOT NULL,		-- x of normal unit vector in J2000  <li>  cy float NOT NULL,		-- y of normal unit vector in J2000  <li>  cz float NOT NULL,		-- z of normal unit vector in J2000  <li>  htmID bigint,		-- 20-deep HTM ID  <li>  distance float		-- distance in arc minutes  <br> Sample call to find SpecObj within 0.5 arcminutes of ra,dec 180.0, -0.5  <br><samp>  <br>select *  <br> from  dbo.fGetNearbySpecObjEq(180.0, -0.5, 0,5)    </samp>    <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjXYZ, fGetNearestSpecObjXYZ ','0');
INSERT DBObjects VALUES('fGetNearestSpecObjEq','F','U',' Returns nearest scienceprimary specobj within @r arcminutes of an equatorial point (@ra,@dec). ',' <p> returned table:    <li>  specObjID bigint,		-- unique spectrum ID  <li>  plate int NOT NULL,		-- spectroscopic plate number  <li>  mjd int NOT NULL,		-- MJD of observation  <li>  fiberID int NOT NULL,	-- fiber number on plate  <li>  z real NOT NULL,		-- final spectroscopic redshift  <li>  zErr real NOT NULL,		-- redshift error  <li>  zWarning int NOT NULL,	-- warning flags  <li>  cx float NOT NULL,		-- x of normal unit vector in J2000  <li>  cy float NOT NULL,		-- y of normal unit vector in J2000  <li>  cz float NOT NULL,		-- z of normal unit vector in J2000  <li>  htmID bigint,		-- 20-deep HTM ID  <li>  distance float		-- distance in arc minutes  <br>  Sample call to find the nearest SpecObj within 1/2 arcminute  of ra,dec 180.0, -0.5, 0.5   <br><samp>   <br> select *   <br> from  dbo.fGetNearestSpecObjEq(180.0,-0.5,0.5)     </samp>     <br>see also fGetNearbySpecObjEq, fGetNearestSpecObjAllEq, fGetNearbySpecObjXYZ,  ','0');
INSERT DBObjects VALUES('fGetNearestSpecObjAllEq','F','U',' Returns nearest specobj within @r arcminutes of an equatorial point (@ra, @dec). ',' <p> returned table:    <li>  specObjID bigint,		-- unique spectrum ID  <li>  plate int NOT NULL,		-- spectroscopic plate number  <li>  mjd int NOT NULL,		-- MJD of observation  <li>  fiberID int NOT NULL,	-- fiber number on plate  <li>  z real NOT NULL,		-- final spectroscopic redshift  <li>  zErr real NOT NULL,		-- redshift error  <li>  zWarning int NOT NULL,	-- warning flags  <li>  sciencePrimary int NOT NULL,	-- deemed to be science-worthy or not  <li>  cx float NOT NULL,		-- x of normal unit vector in J2000  <li>  cy float NOT NULL,		-- y of normal unit vector in J2000  <li>  cz float NOT NULL,		-- z of normal unit vector in J2000  <li>  htmID bigint,		-- 20-deep HTM ID  <li>  distance float		-- distance in arc minutes  <br>  Sample call to find the nearest SpecObj within 1/2 arcminute of ra,dec 180.0, -0.5  <br><samp>   <br> select *   <br> from  dbo.fGetNearestSpecObjAllEq(180.0,-0.5,0.5)     </samp>     <br>see also fGetNearbySpecObjAllEq, fGetNearestSpecObjEq, fGetNearbySpecObjAllXYZ,  ','0');
INSERT DBObjects VALUES('fGetNearbyFrameEq','F','U',' Returns table with a record describing the frames neareby (@ra,@dec) at a given @zoom level. ',' <br> ra, dec are in degrees. Zoom is a value in Frame.Zoom (0, 10, 15, 20, 30).  <br> this rountine is used by the SkyServer Web Server.  <p> returned table is sorted nearest first:    <li> fieldID bigint,                 -- field identifier  <li> a              float NOT NULL , -- abcdef,node, incl astrom transform parameters  <li> b              float NOT NULL ,  <li> c              float NOT NULL ,  <li> d              float NOT NULL ,  <li> e              float NOT NULL ,  <li> f              float NOT NULL ,  <li> node           float NOT NULL ,  <li> incl           float NOT NULL ,  <li> distance	 float NOT NULL   distance in arc minutes to this object from the ra,dec.  <br>  Sample call to find frame nearest to 185,0 and within one arcminute of it.  <br><samp>  <br>select *  <br>from  dbo.fGetNearbyFrameEq(185,0,1)     </samp>     <br>see also fGetNearestFrameEq ','0');
INSERT DBObjects VALUES('fGetNearestFrameEq','F','U',' Returns table with a record describing the nearest frame to (@ra,@dec) at a given @zoom level. ',' <br> ra, dec are in degrees. Zoom is a value in Frame.Zoom (0, 10, 15, 20, 30).  <br> this rountine is used by the SkyServer Web Server.  <p> returned table:    <li> fieldID bigint,                 -- field identifier  <li> a              float NOT NULL , -- abcdef,node, incl astrom transform parameters  <li> b              float NOT NULL ,  <li> c              float NOT NULL ,  <li> d              float NOT NULL ,  <li> e              float NOT NULL ,  <li> f              float NOT NULL ,  <li> node           float NOT NULL ,  <li> incl           float NOT NULL ,  <li> distance	 float NOT NULL   distance in arc minutes to this object from the ra,dec.  <br>  Sample call to find frame nearest to 185,0 and within one arcminute of it.  <br><samp>  <br>select *  <br>from  dbo.fGetNearestFrameEq(185,0,10)     </samp>   ','0');
INSERT DBObjects VALUES('fGetNearestFrameidEq','F','U',' Returns teh fieldid of the nearest frame to (@ra,@dec) at a given @zoom level. ',' <br> ra, dec are in degrees. Zoom is a value in Frame.Zoom (0, 05, 10, 15, 20, 25, 30).  <p> returns the fieldid of the nearest frame  <br>  Sample call to find frameid nearest to 185,0 and within one arcminute of it.  <br><samp>  <br>select *  <br>from  dbo.fGetNearestFrameidEq(185,0,10)     </samp>   ','0');
INSERT DBObjects VALUES('spGetNeighbors','P','U',' Get the neighbors to a list of @ra,@dec pairs in #upload ',' The procedure is used in conjunction with a list upload  service, where the (ra,dec) coordinates of an object list   are put into a temporary table #upload by the web interface.  This table name is hardcoded in the procedure. It then returns  a matchup table, containing the up_id and the SDSS objId.  The result of this is then joined with the PhotoTag table,   to return the attributes of the photometric objects.  <samp>  <br> create table #x (id int,objID bigint)  <br> insert into #x EXEC spGetNeighbors 2.5  </samp> ','0');
INSERT DBObjects VALUES('spGetNeighborsRadius','P','U',' Get the neighbors to a list of @ra,@dec,@r triplets in #upload in photoPrimary ',' The procedure is used in conjunction with a list upload  service, where the (ra,dec) coordinates and the search radius  of an object list are put into a temporary table #upload by   the web interface.  This table name is hardcoded in the procedure.   It then returns a matchup table, containing the up_id and the SDSS   objId. The result of this is then joined with the photoPrimary   table, to return the attributes of the photometric objects.  <samp>  <br> create table #x (id int,objID bigint)  <br> insert into #x EXEC spGetNeighbours   </samp> ','0');
INSERT DBObjects VALUES('spGetNeighborsPrim','P','U',' Get the primary neighbors to a list of @ra,@dec pairs in #upload ',' The procedure is used in conjunction with a list upload  service, where the (ra,dec) coordinates of an object list   are put into a temporary table #upload by the web interface.  This table name is hardcoded in the procedure. It then returns  a matchup table, containing the up_id and the SDSS objId.  The result of this is then joined with the PhotoPrimary table,   to return the attributes of the photometric objects.  <samp>  <br> create table #x (id int,objID bigint)  <br> insert into #x EXEC spGetNeighborsPrim 2.5  </samp> ','0');
INSERT DBObjects VALUES('spGetNeighborsAll','P','U',' Get the neighbors to a list of @ra,@dec pairs in #upload ',' The procedure is used in conjunction with a list upload  service, where the (ra,dec) coordinates of an object list   are put into a temporary table #upload by the web interface.  This table name is hardcoded in the procedure. It then returns  a matchup table, containing the up_id and the SDSS objId.  The result of this is then joined with the PhotoTag table,   to return the attributes of the photometric objects.  <samp>  <br> create table #x (id int,objID bigint)  <br> insert into #x EXEC spGetNeighborsAll 2.5  </samp> ','0');
INSERT DBObjects VALUES('spGetSpecNeighborsRadius','P','U',' Get the spectro scienceprimary neighbors to a list of @ra,@dec,@r triplets in #upload in SpecObj ',' The procedure is used in conjunction with a list upload  service, where the (ra,dec) coordinates and the search radius  of an object list are put into a temporary table #upload by   the web interface.  This table name is hardcoded in the procedure.   It then returns a matchup table, containing the up_id and the SDSS   specObjId. The result of this is then joined with the SpecObj   table, to return the attributes of the photometric objects.  <samp>  <br> create table #x (id int,specObjID bigint)  <br> insert into #x EXEC spGetNeighbours   </samp> ','0');
INSERT DBObjects VALUES('spGetSpecNeighborsPrim','P','U',' Get the scienceprimary spectro neighbors to a list of @ra,@dec pairs in #upload ',' The procedure is used in conjunction with a list upload  service, where the (ra,dec) coordinates of an object list   are put into a temporary table #upload by the web interface.  This table name is hardcoded in the procedure. It then returns  a matchup table, containing the up_id and the SDSS specOobjId.  The result of this is then joined with the SpecObj table,   to return the attributes of the photometric objects.  <samp>  <br> create table #x (id int,specObjID bigint)  <br> insert into #x EXEC spGetSpecNeighborsPrim 2.5  </samp> ','0');
INSERT DBObjects VALUES('spGetSpecNeighborsAll','P','U',' Get the spectro neighbors to a list of @ra,@dec pairs in #upload ',' The procedure is used in conjunction with a list upload  service, where the (ra,dec) coordinates of an object list   are put into a temporary table #upload by the web interface.  This table name is hardcoded in the procedure. It then returns  a matchup table, containing the up_id and the SDSS specObjId.  The result of this is then joined with the SpecObjAll table,   to return the attributes of the photometric objects.  <samp>  <br> create table #x (id int,specObjID bigint)  <br> insert into #x EXEC spGetSpecNeighborsAll 2.5  </samp> ','0');
INSERT DBObjects VALUES('fGetObjFromRect','F','U',' Returns table of objects inside a rectangle defined by two ra,dec pairs.  <br>Note the order of the parameters: @ra1, @ra2, @dec1, @dec2 ',' <br>Assumes dec1<dec2. There is no limit on the number of objects.  <br>Uses level 20 HTM.  <br> returned fields:    <li> objID bigint,             -- id of the object   <li> run int NOT NULL,         -- run that observed the object   <li> camcol int NOT NULL,      -- camera column in run   <li> field int NOT NULL,       -- field in run   <li> rerun int NOT NULL,       -- software rerun that saw the object   <li> type int NOT NULL,        -- type of object (see DataConstants PhotoType)   <li> cx float NOT NULL,        -- xyz of object   <li> cy float NOT NULL,   <li> cz float NOT NULL,   <li> htmID bigint              -- hierarchical triangular mesh ID of object  <br>sample call<br>  <samp> select * from dbo.fGetObjFromRect(185,185.1,0,.1) </samp> ','0');
INSERT DBObjects VALUES('fGetObjFromRectEq','F','U',' Returns table of objects inside a rectangle defined by two ra,dec pairs.  <br>Note the order of the parameters: @ra1, @dec1, @ra2, @dec2 ',' This is a variant of fGetObjFromRect (actually calls it) that takes  the input parameters in a more intuitive order rather than (ra1,ra2,dec1,dec2).  <br>Assumes dec1<dec2. There is no limit on the number of objects.  <br>Uses level 20 HTM.  <br> returned fields:    <li> objID bigint,             -- id of the object   <li> run int NOT NULL,         -- run that observed the object   <li> camcol int NOT NULL,      -- camera column in run   <li> field int NOT NULL,       -- field in run   <li> rerun int NOT NULL,       -- software rerun that saw the object   <li> type int NOT NULL,        -- type of object (see DataConstants PhotoType)   <li> cx float NOT NULL,        -- xyz of object   <li> cy float NOT NULL,   <li> cz float NOT NULL,   <li> htmID bigint              -- hierarchical triangular mesh ID of object  <br>sample call<br>  <samp> select * from dbo.fGetObjFromRectEq(185,0,185.1,0.1) </samp> ','0');
INSERT DBObjects VALUES('fDistanceArcMinEq','F','U',' returns distance (arc minutes) between two points (ra1,dec1) and (ra2,dec2) ',' <br> ra1, dec1, ra2, dec2 are in degrees  <br>  <samp>select top 10 objid, dbo.fDistanceArcMinEq(185,0,ra,dec) from PhotoObj </samp> ','0');
INSERT DBObjects VALUES('fDistanceArcMinXYZ','F','U',' returns distance (arc minutes) between two points (x1,y1,z1) and (x2,y2,z2) ',' <br> the two points are on the unit sphere  <br>  <samp>select top 10 objid, dbo.fDistanceArcMinXYZ(1,0,0,cx,cy,cz) from PhotoObj </samp>    ','0');
INSERT DBObjects VALUES('fGetObjectsEq','F','U',' A helper function for SDSS cutout that returns all objects  within a certain radius of an (ra,dec) ',' Photo objects are filtered to have magnitude greater than      24-1.5*zoom so that the image is not too cluttered      (and the anwswer set is not too large).<br>  (@flag&1)>0 display specObj ...<br>  (@flag&2)>0 display photoPrimary bright enough for zoom<br>  (@flag&4)>0 display Target <br>  (@flag&8)>0 display Mask<br>  (@flag&16)>0 display Plate<br>  (@flag&32)>0 display PhotoObjAll<br>  thus: @flag=7 will display all three of specObj, PhotoObj and Target  the returned objects have            flag = (specobj:1, photoobj:2, target:4, mask:8, plate:16) ','0');
INSERT DBObjects VALUES('fGetObjectsMaskEq','F','U',' A helper function for SDSS cutout that returns all objects  within a certain radius of an (ra,dec) ',' Photo objects are filtered to have magnitude greater than      24-1.5*zoom so that the image is not too cluttered      (and the anwswer set is not too large).<br>  (@flag&1)>0 display specObj ...<br>  (@flag&2)>0 display photoPrimary...<br>  (@flag&4)>0 display Target <br>  (@flag&8)>0 display Mask<br>  (@flag&16)>0 display Plate<br>  thus: @flag=7 will display all three of specObj, PhotoObj and Target  the returned objects have            flag = (specobj:1, photoobj:2, target:4, mask:8, plate:16) ','0');
INSERT DBObjects VALUES('fGetJpegObjects','F','A',' A helper function for SDSS cutout that returns all objects  within a certain radius of an (ra,dec) ',' Photo objects are filtered to have magnitude greater than      24-1.5*zoom so that the image is not too cluttered      (and the anwswer set is not too large).<br>  (@flag&1)>0 display specObj ...<br>  (@flag&2)>0 display photoPrimary...<br>  (@flag&4)>0 display Target <br>  (@flag&8)>0 display Mask<br>  (@flag&16)>0 display Plate<br>  thus: @flag=7 will display all three of specObj, PhotoObj and Target  the returned objects have            flag = (specobj:1, photoobj:2, target:4, mask:8, plate:16) ','0');
INSERT DBObjects VALUES('spGetMatch','P','U',' Get the neighbors to a list of @ra,@dec pairs in #upload in photoPrimary   within @r arcsec . @w is the weight per object. ',' The procedure is used in conjunction with a list upload   service, where the (ra,dec) coordinates of an object list   are put into a temporary table #upload by the web interface.   This table name is hardcoded in the procedure. It then returns   a matchup table, containing the up_id and the SDSS objId.   The result of this is then joined with the photoPrimary table,   to return the attributes of the photometric objects.   @r is measured in arcsec  @w is the weight, it is 1/@sigma^2, where @sigma is in radians  @eps is the chisq threshold  <samp>   <br> create table #x (pk int,id bigint,a float, ax float, ay float, az float)   <br> insert into #x EXEC spGetMatch  2.5, 0.0000001, ...  </samp>  ','0');
INSERT DBObjects VALUES('spTransposeRmatrix','P','A',' Transposes and stores a rotation matrix ','    ','0');
INSERT DBObjects VALUES('spBuildRmatrix','P','A',' Builds the rotation matrices necessary to operate ','    ','0');
INSERT DBObjects VALUES('fRotateV3','F','U',' Rotates a 3-vector by a given rotation matrix ','    ','0');
INSERT DBObjects VALUES('fGetLonLat','F','U',' Converts a 3-vector to longitude-latitude (Galactic or Survey) ',' @mode can be one of the following:  <li> J2S for Survey coordinates  <li> J2G for Galactic coordinates  <br> This is an internal table-valued function that requires a cursor  or variables to specify the coordinates.  Use the scalar functions  fGetLon and fGetLat instead in queries.  ','0');
INSERT DBObjects VALUES('fGetLon','F','U',' Converts a 3-vector to longitude (Galactic or Survey) ',' @mode can be one of the following:  <li> J2S for Survey coordinates,  <li> J2G for Galactic coordinates, e.g.,  <dd> select top 10 dbo.fGetLon(''J2S'',cx,cy,cz) from PhotoTag  <br> Use fGetLat to get latitude. ','0');
INSERT DBObjects VALUES('fGetLat','F','U',' Converts a 3-vector to latitude (Galactic or Survey) ',' @mode can be one of the following:  <li> J2S for Survey coordinates,  <li> J2G for Galactic coordinates, e.g.,  <dd> select top 10 dbo.fGetLat(''J2G'',cx,cy,cz) from PhotoTag  <br>Use fGetLon to get longitude. ','0');
INSERT DBObjects VALUES('fEqFromMuNu','F','U',' Compute Equatorial coordinates from @mu and @nu ',' Compute both ra,dec anmd cx,cy,cz, given @mu,@nu, @node,@incl  all in degrees ','0');
INSERT DBObjects VALUES('fMuNuFromEq','F','U',' Compute stripe coordinates from Equatorial ',' Compute mu, nu from @ra,@dec, @node,@incl ','0');
INSERT DBObjects VALUES('fMuFromEq','F','U',' Returns mu from ra,dec ','','0');
INSERT DBObjects VALUES('fNuFromEq','F','U',' Returns nu from ra,dec ','','0');
INSERT DBObjects VALUES('fCoordsFromEq','F','U',' Returns table of stripe, lambda, eta, mu, nu derived from ra,dec ','','0');
INSERT DBObjects VALUES('fEtaFromEq','F','U',' Returns eta from ra,dec ','','0');
INSERT DBObjects VALUES('fLambdaFromEq','F','U',' Returns lambda from ra,dec ','','0');
INSERT DBObjects VALUES('fEtaToNormal','F','U',' Compute the normal vector from an eta value ','    ','0');
INSERT DBObjects VALUES('fStripeToNormal','F','U',' Compute the normal vector from an eta value ','    ','0');
INSERT DBObjects VALUES('fWedgeV3','F','U',' Compute the wedge product of two vectors ','    ','0');
INSERT DBObjects VALUES('fTokenNext','F','U',' Get token starting at offset @i in string @s ',' Return empty string '''' if none found  <br><samp>  <br>select dbo.fTokenNext(''REGION CONVEX 3 5 7 '',15 )   <br> returns                    ''3''  </samp>  <br> see also fTokenAdvance()   ','0');
INSERT DBObjects VALUES('fTokenAdvance','F','U',' Get offset of next token after offset @i in string @s ',' Return 0 if none found.  <br><samp>  <br>select dbo.fTokenNext(''REGION CONVEX 3 5 7 '',15 )   <br> returns                    ''3''  </samp>  <br> see also fTokenNext()   ','0');
INSERT DBObjects VALUES('fTokenStringToTable','F','U',' Returns a table containing the tokens in the input string ',' Tokens are blank separated.  <samp>select * from dbo.fTokenStringToTable(''A B C D E F G H J'')   <br> returns                    a table containing those tokens  </samp>   ','0');
INSERT DBObjects VALUES('fNormalizeString','F','U',' Returns string upshifted, squeezed blanks, trailing zeros   removed, and blank added on end ',' <br>select dbo.fNormalizeString(''Region Convex   3.0000   5  7'')   <br> returns                    ''REGION CONVEX 3.0 5 7 ''  </samp>   ','0');
INSERT DBObjects VALUES('fRegionFuzz','F','U',' Returns a displacement that expands a circle by the ''buffer'' ',' Buffer is the expansion in arc minutes  Result is range limited to [-1 .. 1]  <br>  The following exampe adds 1 minute fuzz to the hemisphere.  <samp>select dbo.fRegionFuzz(0,1)         </samp>   ','0');
INSERT DBObjects VALUES('fRegionOverlapId','F','U',' Returns the overlap of a given region overlapping another one ',' The parameters  <li>@regionid is the region we want to intersect with  <li>@otherid is the region of interest   <li>@buffer is the amount the regionString is grown in arcmins.</li>  <br>Returns a blob with the overlap region,  <br>NULL if there are no intersections,  <br>NULL if input params are bad.  <samp>  SELECT * from fRegionOverlapId(1049,6078,0.0)  </samp> ','0');
INSERT DBObjects VALUES('spRegionDelete','P','A',' Delete a region and all its convexes and constraints ',' Parameters:  <li> regionID bigint     	ID of the region to be deleted  <br>Sample call to delete a region   <br><samp>   <br> exec spRegionDelete @regionID    </samp>  <br> see also spRegionNew, spRegionDelete,...   ','0');
INSERT DBObjects VALUES('spRegionNew','P','A',' Create a new region, return value is regionID  ',' <br>Parameters:  <li> id      bigint        key of object in its source table (e.g. TileID)  <li> type    varchar(16)   short description of the region (e.g. stripe)  <li> comment varchar(8000) longer description of the region   <li> isMask  int           flag says region is negative (a mask)  <br> returns regionID int  the unique ID of the region.  <br>Sample call get a new region   <br><samp>   <br> exec @regionID = spRegionNew 12345, ''STRIPE'', ''Stripe 12345'', 0    </samp>  <br> see also fRegionPredicate, spRegionDelete,...   ','0');
INSERT DBObjects VALUES('spRegionAnd','P','U',' Create a new region containing intersection (AND) of regions d1 and d2. ',' The new region will contain copies of the intersections of each pair of   convexes in the two original regions.  <br>Parameters:  <li> id bigint        key of object in its source table (e.g. TileID)  <li> d1 bigint        ID of the first region.  <li> d2 bigint        ID of the second region.  <li> type varchar(16)     	short description of the region (e.g. stripe)  <li> comment varchar(8000) longer description of the region    <br> returns regionID int  the unique ID of the new region.  <br>Sample call get intersection of two  regions   <br><samp>   <br> exec @regionID = spRegionAnd @d1, @d2, ''stripe'', ''run 1 2 3''    </samp>  <br> see also spRegionNew, spRegionOr, spRegionNot, spRegionDelete,...   ','0');
INSERT DBObjects VALUES('spRegionIntersect','P','A',' Intersect a base region with a second region   ',' The surviving region contains the intersections of each pair of   convexes in the two regions. The base region is overwritten.  <br>Parameters  <li> @baseID bigint:   regionID of the region to be masked  <li> @interID bigint:  regionID of the masking region.  <br> returns count of convexes in the resulting @baseID  <br>Sample call get intersection of two  regions   <br><samp>   <br> exec @convexes = spRegionIntersect @Tile, @Mask    </samp>  <br> see also spRegionNew, spRegionOr, spRegionNot, spRegionDelete,...   ','0');
INSERT DBObjects VALUES('spRegionSubtract','P','A','  Subtract the areas of one region from a second region, and update first ',' <p> parameters:     <li> @baseID bigint: region to subtract from   <li> @subID bigint:  region to remove from base  <li> returns number of convexes in region.   <br>  Sample call:<br>  <samp>   <br> exec @convexes = spRegionSubtract @RegionID, @maskID  </samp>   <br>   ','0');
INSERT DBObjects VALUES('spRegionCopy','P','A',' Create a new region containing the convexes of region  @regionID    ',' The new region contains a copy of the convexes of the original regions   <br>Parameters:  <li> id  bigint        	key of object in its source table (e.g. TileID)  <li> regionID bigint     	regionID of the  region.  <li> type varchar(16)      short description of the region (e.g. stripe)  <li> comment varchar(8000) longer description of the region    <br> returns regionID int  the unique ID of the new region.  <br>Sample copy of a region regions   <br><samp>   <br> exec @newregionID = spRegionCopy @newID, @oldregionID,  ''stripe'', ''run 1 2 3''     </samp>  <br> see also spRegionNew, spRegionAnd, spRegionNot, spRegionDelete,...   ','0');
INSERT DBObjects VALUES('spRegionSync','P','A',' Will synchronize RegionPatch with the Regions of a certain type ',' Inserts the patches from the regionBinary ','0');
INSERT DBObjects VALUES('fRegionContainsPointXYZ','F','U',' Returns 1 if specified region contains specifed x,y,z   point, else returns zero. ',' There is no limit on the number of objects returned, but   there are about 40 per sq arcmin.    <p> parameters   <li> regionid bigint,     -- Region object identifier  <li> cx float NOT NULL,   -- x,y,z of unit vector to this object  <li> cy float NOT NULL,  <li> cz float NOT NULL,  <br>  Sample call to find if regionID 345 contains the North Pole<br>  <samp>   <br> select dbo.fRegionContainsPointXYZ(7,0,0,1)    </samp>   <br> see also fRegionContainsPointEq   ','0');
INSERT DBObjects VALUES('fRegionContainsPointEq','F','U',' Returns 1 if specified region contains specified ra,dec   point, else returns zero. ',' There is no limit on the number of objects returned,   but there are about 40 per sq arcmin.    <p>  parameters   <li> regionid bigint 	 -- Region object identifier  <li> ra float NOT NULL,     -- Right ascension, --/U degrees  <li> dec float NOT NULL,     -- Declination,     --/U degrees  <br>  Sample call to find if regionID 345 contains the North Pole<br>  <samp>   <br> select dbo.fRegionContainsPointEq(7,0,90)    </samp>   <br> see also fRegionContainsPointXYZ ','0');
INSERT DBObjects VALUES('fRegionGetObjectsFromRegionId','F','U',' Returns various objects within a region given by a regionid ',' <p> returns a table of two columns  <br> objID bigint          -- Object ID from PhotoObjALl,    <br> flag int		-- the flag of the object type<br>  (@flag&1)>0 display specObj<br>  (@flag&2)>0 display photoPrimary<br>  (@flag&4)>0 display Target <br>  (@flag&8)>0 display Mask<br>  (@flag&32)>0 display photoPrimary and secondary<br>  thus: @flag=7 will display all three of specObj, PhotoObj and Target  the returned objects have            flag = (specobj:1, photoobj:2, target:4, mask:8)  <br>Sample call to find all objects in region 75<br>  <samp>   select * from dbo.fRegionGetObjectsFromRegionID(75,15)    </samp>  ','0');
INSERT DBObjects VALUES('fRegionGetObjectsFromString','F','U',' Returns various objects within a region given by a string ',' The parameter @buffer, given in arcmins, corresponds  to an expansion the search region beyond of each   boundary by that amount.  (@flag&1)>0 display specObj ...<br>  (@flag&2)>0 display photoPrimary...<br>  (@flag&4)>0 display Target <br>  (@flag&8)>0 display Mask<br>  (@flag&32)>0 display photoPrimary and secondary<br>  thus: @flag=7 will display all three of specObj, PhotoObj and Target  the returned objects have            flag = (specobj:1, photoobj:2, target:4, mask:8) ','0');
INSERT DBObjects VALUES('fRegionsContainingPointXYZ','F','U',' Returns regions containing a given point  ',' The parameters  <li>@x, @y, @z are unit vector of the point on the J2000 celestial sphere. </li>  <li>@types is a varchar(1000) space-separated string of the desired region types.  <br> Possible types are: SEGMENT STRIPE TIGEOM PLATE CAMCOL RUN STAVE CHUNK TILE TILEBOX SECTOR SECTORLET SKYBOX WEDGE.</li>  <li>@buffer is the ''fuzz'' in arcmins around that poiont.</li>  <br>Returns a table with the coulums  <br>Returns empty table if input params are bad.  <br>RegionID BIGINT NOT NULL PRIMARY KEY  <br>Type     VARCHAR(16) NOT NULL  <samp>  SELECT * from fGetRegionsContainingPointXYZ(0,0,0,''STAVE'',0)  </samp> ','0');
INSERT DBObjects VALUES('fRegionsContainingPointEq','F','U',' Returns regions containing a given point  ',' The parameters  <li>@ra, @dec the equatorial coordinats on the J2000 celestial sphere. </li>  <li>@types is a varchar(1000) space-separated string of the desired region types.  <br> Possible types are: SEGMENT STRIPE TIGEOM PLATE CAMCOL RUN STAVE CHUNK TILE TILEBOX SECTOR SECTORLET SKYBOX WEDGE.</li>  <li>@buffer is the ''fuzz'' in arcmins around that poiont.</li>  <br>Returns a table with the columns  <br>Returns empty table if input params are bad.  <br>regionid bigint NOT NULL PRIMARY KEY  <br>type     varchar(16) NOT NULL  <samp>  SELECT * from dbo.fGetRegionsContainingPointEq(195,2.5,''STAVE'',0)  </samp> ','0');
INSERT DBObjects VALUES('fFootprintEq','F','U',' Determine whether point is inside the survey ',' Returns all regiontypes from CHUNK, PRIMARY, TILE, SECTOR  that contain the given point. NULL indicates that the point  is entirely outside the survey footprint. ','0');
INSERT DBObjects VALUES('spMakeDiagnostics','P','A',' Creates a full diagnostic view of the database ',' The stored procedure checks in all tables, views, functions  and stored procedures into the Diagnostics table,  and counts the number of rows in each table and view.  <PRE> EXEC spMakeDiagnostics </PRE> ','0');
INSERT DBObjects VALUES('spUpdateSkyServerCrossCheck','P','A',' Update the contents of the SiteDiagnostics table ',' This procedure copies the Diagnostics into the  SiteDiagnostics table, then it update the value of  the DB checksum and timestamp.  It is used to cross-check the patches applied to the database  <PRE>EXEC spUpdateSkyServerCrossCheck</PRE> ','0');
INSERT DBObjects VALUES('spCompareChecksum','P','A',' Compares the checksum in Diagnostics to the one in SiteDiagnostics ',' Run this procedure to verify that no changes occured in the  database since the last regular update.  <PRE> spCompareChecksum</PRE> ','0');
INSERT DBObjects VALUES('fGetDiagChecksum','F','A',' Computes the checksum from the Diagnostics table ',' The checksum should be equal to the checksum value in the  SiteConstants table.  <PRE> SELECT dbo.fGetDiagChecksum() </PRE>  ','0');
INSERT DBObjects VALUES('spUpdateStatistics','P','A',' Update the statistics on user tables ',' Update the statistics on the user tables  no parameters  <samp>  exec spUpdateStatistics </samp> ','0');
INSERT DBObjects VALUES('spCheckDBColumns','P','A',' Check for a mismatch between the db columns and documentation ',' Comapres the columns of tables in syscolumns to  the list stored in DBColumns. Returns the number  of mismatches. It has no parameters.  <samp>  exec spCheckDBColumns</samp> ','0');
INSERT DBObjects VALUES('spCheckDBObjects','P','A',' Check for a mismatch between the db objects and documentation ',' Comapres the all the objects in sysobjects to  the list stored in DBObjects. Returns the number  of mismatches. It has no parameters.  <samp>  exec spCheckDBObjects</samp> ','0');
INSERT DBObjects VALUES('spGrantAccess','P','A','  spGrantAccess grants access to DB objects ',' Grants select/execute authority to all user db objects  and to the HTM routines in master  If ''Admin'' is specified, grants the user access to ALL objects.   <p> parameters:     <li> access char(1),   		-- U: grant access to dbObjects.access = ''U'' objects <br> 					-- A: grant access to all dbObjects  <li> user 	varchar(256),   	-- UserID to grant  <br>  Sample call:<br>  <samp>   <br> exec  spGrantAccess ''U'', ''Test''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spCheckDBIndexes','P','A',' Checks all the mismatches ion indexes between the schema and the DB ',' ','0');
INSERT DBObjects VALUES('spTestTimeStart','P','A',' Starts the wall, cpu, and IO clocks for performance testing  ','  parameters are: 	  <li> clock (output):		current 64bit wallclock datetime       <li> cpu (output):		 bigint of cpu milliseconds (wraps frequently so gives bogus answers)       <li> physical_Io (output): bigint count of disk reads and writes   <br>   Here is an example that uses spTestTimeStart and spTestTimeEnd to record the cost of    some SQL statements. The example both records the results in the QueryResults table   and also prints out a message summarizing the test (that is what the 1,1 flags are for.)   <samp>   <br>declare @clock datetime, @cpu bigint, @physical_io bigint,  @elapsed bigint;   <br>exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT   <br>  .... do some SQL work....   <br>exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,    <br>                           ''Q10'', ''1GB buffer pool, read committed'', 1, 1, @@RowCount_big   </samp><p>   see also spTestTimeEnd ','0');
INSERT DBObjects VALUES('spTestTimeEnd','P','A',' Stops the clock for performance testing and optionally records stats in QueryResults and in sysOut.  ','  <p>parameters are (inputs should be set with spTestTimeStart as shown in example):        <li> clock datetime (input)       : current 64bit wallclock datetime        <li> elapsed float (output)       : elapsed milliseconds of wall clock time          <li> cpu fkiat (input, output)    : an int of milliseconds of cpu time (wraps frequently so gives bogus answers)        <li> physical_Io bigint (input, output): count of disk reads and writes        <li> query varchar(10) (input)    : short text string describing the query        <li> commment varchar(100) (input) : longer text string describing the experiment        <li> print (input)       	      : flag, if true prints the output statistics on the console (default =no)        <li> table (input)                 : flag, if true inserts the statistics in the QueryResults table (default = no)        <li> row_Count(input)              : passed in RowCount_big for statistics   Here is an example that uses spTestTimeStart and spTestTimeEnd to record the cost of    some SQL statements. The example both records the results in the QueryResults table   and also prints out a message summarizing the test (that is what the 1,1 flags are for.)   <samp>   <br>declare @clock datetime, @cpu bigint, @physical_io bigint,  @elapsed bigint;   <br>exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT   <br>  .... do some SQL work....   <br>exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,    <br>                          ''Q10'', ''1GB buffer pool, read committed'', 1, 1, @@RowCount_big   </samp><p>   see also spTestTimeStart ','0');
INSERT DBObjects VALUES('spTestQueries','P','A',' Runs the standard 37 SDSS queries and records their performance in QueryResults.  ','  parameters are: 	  <li> @n					The number of times to repeat the query run.    <br>   <samp>   run the queries ten times:   <br>exec spTestQueries 10   </samp><p> ','0');
INSERT DBObjects VALUES('fVarBinToHex','F','U',' Returns hexadecimal string of varbinary input ',' The input is scanned converting nibbles to hex characters  <br>   <sample>            select dbo.fVarBinToHex(0x4532ae1245)  </sample>  ','0');
INSERT DBObjects VALUES('fEnum','F','U',' Converts @value in an enum table to a string ',' Takes a binary(8) value, and converts it first  to a type of given length, then to a string.  It is used by the spDocEnum procedure. ','0');
INSERT DBObjects VALUES('fDocColumns','F','U',' Return the list of Columns in a given table or view ',' Used by the auto-doc interface.  For getting   the ''rank'' column in the DBColumns table,   see fDocColumnsWithRank.  <samp>  select * from dbo.fDocColumns(''Star'')  </samp> ','0');
INSERT DBObjects VALUES('fDocColumnsWithRank','F','U',' Return the list of Columns plus ''rank'' ',' Used by the auto-doc interface and query builder tools.  Also returns the ''rank'' column that is used to order   the columns in query tools.  <samp>  select * from dbo.fDocColumnsWithRank(''PhotoObjAll'')  </samp> ','0');
INSERT DBObjects VALUES('fDocFunctionParams','F','U',' Return the parameters of a function ',' Used by the auto-doc interface. <br> <samp>  select * from dbo.fDocFunctionParams(''fGetNearbyObjEq'') </samp> ','0');
INSERT DBObjects VALUES('spDocEnum','P','U',' Display the properly rendered values from DataConstants  ',' The parameter is the name of the enumerated field in DataConstants.  The type and length is taken from the View of corresponding name.  <br><samp>  exec spDocEnum ''PhotoType'' </samp> ','0');
INSERT DBObjects VALUES('spDocKeySearch','P','U',' Search Columns table for @key ',' @option sets the scope of the search:    <li>1 is Columns,   <li>2 is Constants,  <li>4 is SDSSConstants,   <li>8 is DBObjects  <br>   Returns those rows, which had a hit. They will   have a weblink to the parent table.  <br>  <samp>  exec spDocKeySearch ''lupt'', 1  </samp> ','0');
INSERT DBObjects VALUES('fReplace','F','U',' Case-insensitve string replacement ',' Used by the SQL parser stored procedures. ','0');
INSERT DBObjects VALUES('fIsNumbers','F','U',' Check that the substring is a valid number. ',' <br>fIsNumbers(string, start, stop) Returns   <LI>  -1: REAL (contains decimal point) ([+|-]digits.digits)  <LI>   0: not a number  <LI>   1: BIGINT    ([+|-] 19 digits)  <br>  <samp>  select dbo.fIsNumbers(''123;'',1,3);   <br>  select dbo.fIsNumbers(''10.11;''1,5);</samp> ','0');
INSERT DBObjects VALUES('spExecuteSQL','P','U',' Procedure to safely execute an SQL select statement  ',' The procedure casts the string to lowercase (this could affect some search statements)   It rejects strings continuing semicolons;   It then discards duplicate blanks, xp_, sp_, fn_, and ms_ substrings.   we are guarding aginst things like ''select dbo.xp_cmdshell(''format c'');''   Then, if the ''limit'' parameter is > 0 (true), we insist that the     statement have a top x in it for x < 1000, or we add a TOP 1000 clause.   Once the SELECT statement is transformed, it is executed   and returns the answer set or an error message.   <br>   All the SQL statements are journaled into WebLog.dbo.SQLlog.   <samp>EXEC dbo.spExecuteSQL(''Select count(*) from PhotoObj'')</samp>  ','0');
INSERT DBObjects VALUES('spExecuteSQL2','P','U',' Procedure to safely execute an SQL select statement ',' The procedure runs and logs a query, but does not parse  it. <br>  See also spExecuteSQL ','0');
INSERT DBObjects VALUES('spLogSqlStatement','P','U',' Procedure to log a SQL query to the statement log.  ',' Log the given query and its start time to the SQL statement log.  Note  that we are logging only the start of the query yet, not a completed query.  All the SQL statements are journaled into WebLog.dbo.SQLStatementlog.   <samp>EXEC dbo.spLogSqlStatement(''Select count(*) from PhotoObj'',getutcdate())</samp>   See also spLogSqlPerformance. ','0');
INSERT DBObjects VALUES('spLogSqlPerformance','P','U',' Procedure to log success (or failure) of a SQL query to the performance log. ',' The caller needs to specify the time the query was started, the number of <br>  seconds (bigint) that the CPU was busy during the query execution, the    <br>  time the query ended, the number of rows the query returned, and an error <br>  message if applicable.  The time fields can be 0 if there is an error.  <samp>EXEC dbo.spLogSQLPerformance(''skyserver.sdss.org'','''',,'''',getutcdate())</samp>   See also spLogSqlStatement. ','0');
INSERT DBObjects VALUES('fGetUrlExpEq','F','U','  Returns the URL for an ra,dec, measured in degrees. ','  <br> returns http://localhost/en/tools/explore/obj.asp?ra=185.000000&dec=0.00000000   <br> where localhost is filled in from SiteConstants.WebServerURL.   <br> sample:<br> <samp>select dbo.fGetUrlExpEq(185,0) </samp>   <br> see also fGetUrlNavEq, fGetUrlNavId, fGetUrlExpId ','0');
INSERT DBObjects VALUES('fGetUrlExpId','F','U',' Returns the URL for an Photo objID. ','  <br> returns http://localhost/en/tools/explore/obj.asp?id=2255029915222048   <br> where localhost is filled in from SiteConstants.WebServerURL.   <br> sample:<br><samp> select dbo.fGetUrlExpId(2255029915222048) </samp>   <br> see also fGetUrlNavEq, fGetUrlNavId, fGetUrlExpEq ','0');
INSERT DBObjects VALUES('fGetUrlFrameImg','F','U','  Returns the URL for a JPG image of the frame ','  <br> returns http://localhost/en/get/frameById.asp?id=568688299147264   <br> where localhost is filled in from SiteConstants.WebServerURL.   <br> @zoom is an integer from (0,10,15,20,30) corresponding to a   rescaling of 2^(0.1*@zoom)   <br> sample:<br> <samp>select dbo.fGetUrlSpecImg(568688299147264,10) </samp>   <br> see also fGetUrlFrame ','0');
INSERT DBObjects VALUES('spGetFiberList','P','U',' Return a list of fibers on a given plate. ','','0');
INSERT DBObjects VALUES('fGetUrlFitsField','F','U',' Given a FieldID returns the URL to the FITS file of that field  ',' Combines the value of the DataServer URL from the  SiteConstants table and builds up the whole URL   <br><samp> select dbo.fGetUrlFitsField(568688299343872)</samp> ','0');
INSERT DBObjects VALUES('fGetUrlFitsCFrame','F','U',' Get the URL to the FITS file of a corrected frame given the fieldID and band ',' Combines the value of the DataServer URL from the  SiteConstants table and builds up the whole URL  from the fieldId (and a u, g, r, i or z filter)  <br><samp> select dbo.fGetUrlFitsCFrame(568688299343872,''r'')</samp> ','0');
INSERT DBObjects VALUES('fGetUrlFitsMask','F','U',' Get the URL to the FITS file of a frame mask given the fieldID and band ',' Combines the value of the DataServer URL from the  SiteConstants table and builds up the whole URL  from the fieldId (and a u, g, r, i or z filter)  <br><samp> select dbo.fGetUrlFitsMask(568688299343872,''r'')</samp> ','0');
INSERT DBObjects VALUES('fGetUrlFitsBin','F','U',' Get the URL to the FITS file of a binned frame given FieldID and band. ',' Combines the value of the DataServer URL from the  SiteConstants table and builds up the whole URL  from the fieldId (and a u, g, r, i or z filter)  <br><samp> select dbo.fGetUrlFitsBin(568688299343872,''r'')</samp> ','0');
INSERT DBObjects VALUES('fGetUrlFitsAtlas','F','U',' Get the URL to the FITS file of all atlas images in a field ',' Combines the value of the DataServer URL from the  SiteConstants table and builds up the whole URL  from the fieldId    <br><samp> select dbo.fGetUrlFitsAtlas(568688299343872)</samp> ','0');
INSERT DBObjects VALUES('fGetUrlFitsSpectrum','F','U',' Get the URL to the FITS file of the spectrum given the SpecObjID ',' Combines the value of the DataServer URL from the  SiteConstants table and builds up the whole URL  from the specObjId.  <br><samp> select dbo.fGetUrlFitsSpectrum(75094092974915584)</samp> ','0');
INSERT DBObjects VALUES('fGetUrlNavEq','F','U','  Returns the URL for an ra,dec, measured in degrees. ','  <br> gets the URL of the navigator frame containing the given ra,dec (in degrees)   <br> returns http://localhost/en/tools/navi/getFrame.asp?zoom=1&ra=185.000000&dec=0.00000000   <br> where localhost is filled in from SiteConstants.WebServerURL.   <br> sample:<br> <samp>select dbo.fGetUrlNavEq(185,0) </samp>   <br> see also fGetUrlNavId, fGetUrlExpEq, fGetUrlExpId ','0');
INSERT DBObjects VALUES('fGetUrlNavId','F','U',' Returns the Navigator URL for an Photo objID. ','  <br> returns http://localhost/en/tools/navi/getFrame.asp?zoom=1&ra=184.028935&dec=-1.1259095   <br> where localhost is filled in from SiteConstants.WebServerURL.   <br> sample:<br><samp> select dbo.fGetUrlId(2255029915222048) </samp>   <br> see also fGetUrlNavEq, fGetUrlExpEq, fGetUrlExpId ','0');
INSERT DBObjects VALUES('fGetUrlSpecImg','F','U','  Returns the URL for a GIF image of the spectrum given the SpecObjID ','  <br> returns http://localhost/en/get/specById.asp?id=0x011fcb379dc00000   <br> where localhost is filled in from SiteConstants.WebServerURL.   <br> sample:<br> <samp>select dbo.fGetUrlSpecImg(0x011fcb379dc00000) </samp>   <br> see also fGetUrlFrame ','0');
INSERT DBObjects VALUES('spSetWebServerUrl','P','U',' Set the WebServerUrl value in SiteConstants based on the given site name.  ',' The WebServerUrl in the SiteConstants table is set to:            ''http://cas.sdss.org/''+@siteName+''/en/''  e.g.,            ''http://cas.sdss.org/dr5/en/''   when @siteName = ''dr5''. ','0');
INSERT DBObjects VALUES('fMJDToGMT','F','U',' Computes the String of a Modified Julian Date.  ',' From http://serendipity.magnet.ch/hermetic/cal_stud/jdn.htm   String has the format yyyy-mm-dd:hh:mm:ss.sssss   <PRE>select dbo.fMjdToGMT(49987.0)</PRE> ','0');
INSERT DBObjects VALUES('fGetAlpha','F','U',' Compute alpha ''expansion'' of theta for a given declination ',' Declination and theta are in degrees.  ','0');
INSERT DBObjects VALUES('spZoneCreate','P','A',' Organizes PhotoObj objects into the Zone table ',' The table holds ALL primary/secondary objects.   The table contains duplicates of objects which are within @radius distance   of the 0|360 meridian.  <p> Parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> radius float,   		-- radius in arcseconds  <li> zoneHeight float,   	-- zoneHeight in arcsec  <br>  Sample call for a 2 arcseconds radius and a 1/2 arcminute zoneHeight <br>  <samp>   <br> exec  spZoneCreate @taskid , @stepid, 2.0, 30.0;  </samp>   <br>   ','0');
INSERT DBObjects VALUES('spNeighbors','P','A',' Computes PhotoObj Neighbors based on nChild ',' Populate table of nearest neighbor object IDs for quicker   spatial joins. The table holds ALL star/galaxy objects within   1/2 arcmin of each object. Typically each object has 7 such   neighbors in the SDSS data. If the destinationType is RUNS,   TARGET, or TILES, then the radius is 3 arcseconds. This is   the zoned algorithm. When complete, the neighbors and the   ''native'' zone members can be copied to the destination DB.  <p> Parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationType int,   	-- ''best'', ''runs'',''target'', ''tiles''  <li> destinationDB int,   		-- destination database name  <li> radius float,			-- search radius in arcsec  <li> matchMode tinyint		-- if true, include multiple                                     -- observations of same object                                     -- in its neighbors, so the                                     -- Match tables can be built   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call for a 1/2 arcminute radius <br>  <samp>   <br> exec  spNeighbors @taskid , @stepid, ''best'', ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spFillMaskedObject','P','A',' Fills the MaskedObject table  ',' Will loop through the Mask table, and  for each mask with type<4 or seeing>1.7  in the r filter will find all objects in  PhotoObjAll that are inside a mask. These  are inserted into the MaskedObject table. ','0');
INSERT DBObjects VALUES('spSetInsideMask','P','A',' Update the insideMask value in Photo tables ',' @mode=0  -- run on the TaskDB  @mode>0  -- run it on the whole PubDB, also update PhotoTag ','0');
INSERT DBObjects VALUES('spSetPhotoClean','P','A',' Update the clean photometry flag for point sources in PhotoObjAll ',' The PhotoObjAll.clean value is 1 if certain conditions are  met for point source objects.  This signifies our best   judgement of ''clean'' photometry for these objects.  The  same logic is not applicable to extended objects. ','0');
INSERT DBObjects VALUES('spTargetInfoTargetObjID','P','A',' Set TargetInfo.targetObjID ',' Connect TargetInfo to photo objects in Target   Designed to run in the target database.  <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <br>  Sample call   <br>  <br> <samp>   exec spTargetInfoTargetObjID @taskid , @stepid    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spSetLoadVersion','P','A',' Update the loadVersion for various tables ',' Part of the loading process ','0');
INSERT DBObjects VALUES('spSetValues','P','A',' Compute the remaining attributes after bulk insert ',' Part of the loading process: it computes first  the HTMID for the Frame table, then the easy magnitudes  then sets the boundaries for a given chunk. Writes log  into the loadadmin database. ','0');
INSERT DBObjects VALUES('spTestHtm','P','A',' Tests 1000 htms to see if they match the ''local'' algorithm ',' <p> parameters:    <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> table varchar() NOT NULL,   	-- name of source table to test the htm field  <li> errorMsg varchar() NOT NULL,  -- error message if key not unique  <br>   Tests 100 Table(htmID) to match SkyServer function          Returns @error = 0 if almost all keys match   		@error > 0  more than 1% of keys needed fixing.        In the failure case it inserts messages in the load measage log        describing the first 10 failing htmIDs.    Sample call to test photoObjAll.htm <br>  <samp>   <br> exec spTestHtm @taskid , @stepid, ''photoObjAll'',  @error output  </samp>   <br> see also spGenericTest, spTestPrimaryKey,  ','0');
INSERT DBObjects VALUES('fDatediffSec','F','U',' fDatediffSec(start,now) returns the difference in seconds as a float ',' <p> parameters:    <li> start datetime,   		-- start time  <li> now datetime,   		-- end time  <li> returns float 	   	-- elapsed time in seconds.   <br>  sample use: <samp>        declare @start datetime        set @start  = current_timestamp       do something        print ''elapsed time was '' + str(dbo.fDatediffSec(@start, current_timestamp),10,3) + '' seconds''  </samp>  ','0');
INSERT DBObjects VALUES('spGenericTest','P','A',' Tests a generic SQL Statement, gives error if test produces any records ','      tests to see that no values violate the test   	the test must have the syntax:  		select <your key> as badKey 		into test         	from <your tests>      	if the <test> table is not empty, we print out the error message.          Returns @error = 0 if all keys unique    		@error >0  if duplicate keys (in which case it is the count of duplicate keys).        In the failure case it inserts messages in the load measage log        describing the first failing key.   <p> parameters:    <li> taskid int,   		-- task identifier  <li> stepid int,   		-- step identifier  <li> command varchar() NOT NULL,   -- sql command select... into test where....   <li> testType varchar() NOT NULL,  -- what are we testing   <li> errorMsg varchar() NOT NULL,  -- error message if test is not empty  <li> error int NOT NULL,         	-- output: 0 if OK (test is empty), non zero if output is not empty  <br>  Sample call to test that r is not too small <br>  <samp>   <br> exec spGenericTest @taskid, @stepid, ''select objID into test from objID where r < -99999'', ''testing r''  <br> 			''r is too small'', @error output  </samp>   <br> see also spTestUniqueKey, spTestForeignKey,  ','0');
INSERT DBObjects VALUES('spTestUniqueKey','P','A',' Tests a unique key, gives error if test finds non unique key ','     tests to see that sourceTable(key)is a unique key      key can involve multipe fields as in neighbors (objID, neighborObjID)        Returns @error = 0 if all keys unique   	@error >0  if duplicate keys (in which case it is the count of duplicate keys.      In the failure case it inserts messages in the phase table   <p> parameters:    <li> taskid bigint,   		-- task identifier  <li> stepid bigint,   		-- step identifier  <li> table varchar() NOT NULL,   	-- name of table to test   <li> key varchar() NOT NULL,   	-- name of key in table to test  <li> error int NOT NULL,         	-- output: 0 if OK (key is unique), non zero if key not unique  <br>  Sample call to test that photoObjAll.Objid is unique <br>  <samp>   <br> exec spTestUniqueKey @taskid, @stepid, ''photoObjAll'', ''ObjID'', @error output  </samp>   <br> see also spGenericTest, spTestForeignKey,  ','0');
INSERT DBObjects VALUES('spTestForeignKey','P','A',' Tests a foreign key, gives error if test finds an orphan record ',' spTestForeignKey (taskID, stepID, sourceTable, targetTable, key, error output)      tests to see that all values in sourceTable(key) are in targetTable(key)        Returns @error = 0 if foreigh key is OK 		@error >0  if foreign key has a mismatch (in which case it is the count.   In the failure case it inserts messages in the load measage log    describing the first 10 distinct failing keys.    <p> parameters:    <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> SourceTable varchar() NOT NULL, -- name of source table to test  <li> destinationTable varchar() NOT NULL, -- name of destination table to test    <li> key varchar() NOT NULL,   	-- name of foreign key in table to test  <li> error int NOT NULL,         	-- output: 0 if OK (is a foreign key), non zero find orphan  <br>  Sample call to test that PhotoProfile.Objid is a foreign key to photoObjAll <br>  <samp>   <br> exec spTestForeignKey @taskid, @stepID, ''PhotoProfile'', ''photoObjAll'',''ObjID'',  @error output  </samp>   <br> see also spGenericTest, spTestPrimaryKey,  ','0');
INSERT DBObjects VALUES('spTestPhotoParentID','P','A',' Tests that photoObjAll.nChild matches the number of children of each PhotoObj ',' Test that a parent with nChild has in fact n Children  <p> parameters:    <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> returns  0 if OK (nChild is correct), non zero if nChild is wrong    <br>  Sample call   <br>  <samp>   <br> exec @error = spTestPhotoParentID @taskid , @stepid   </samp>   <br> see also spGenericTest, spTestPrimaryKey,  ','0');
INSERT DBObjects VALUES('spComputePhotoParentID','P','A',' Computes photoObjAll.ParentID based on nChild ',' Scans photoObjAll table.     if nChild >0 then the next ''nChild'' nodes are children of this node.        unless one of them has nChild>0 in which case we recurse  <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> returns  0 if OK, non zero if something wrong    <br>  Sample call   <br>  <samp>   <br> exec  spComputePhotoParentID @taskid, @stepid   </samp>   <br> see also spTestPhotoParentID   ','0');
INSERT DBObjects VALUES('spValidatePhoto','P','A','  Validate Photo object of a given type   ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> targetType int,   		-- ''best'', ''runs'',''target'', ''tiling''    <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spValidatePhoto @taskid , @stepid, ''best'', ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spValidatePlates','P','A','  Validate Spectro object   ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spValidatePlates @taskid , @stepid, ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spValidateGalSpec','P','A','  Validate GalSpec tables   ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spValidateGalSpec @taskid , @stepid, ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spValidateTiles','P','A','  Validate Tiles   ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spValidateTiles @taskid , @stepid, ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spValidateWindow','P','A','  Validate Window tables   ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spValidateWindow @taskid , @stepid, ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spValidateSspp','P','A','  Validate sspp tables   ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spValidateSspp @taskid , @stepid, ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spValidatePm','P','A','  Validate pm tables   ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spValidatePm @taskid , @stepid, ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spValidateResolve','P','A','  Validate resolve tables   ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spValidateResolve @taskid , @stepid, ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spValidateStep','P','A',' Validation step, checks and augments Photo or Spectro data before publication ',' <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  The data has been placed in the local DB.  Most of the step parameters are extracted from the task table (see code)  It is destined for task.dbName  It is a task.type dataload (type in (target|best|runs|plates|galspec|sspp|tiling|window))  The validation step writes many messages in the Phase table.  It returns stepid and either:   	0 on success (no serious problems found)     1 on failure (serious problems found). ','0');
INSERT DBObjects VALUES('spBackupStep','P','A',' Backup step, shrinks, backs-up, and then detaches the database ',' <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  The data is in the local DB.  Most of the step parameters are extracted from the task table (see code)  It is a task.type dataload (type in (target|best|runs|plates|tiling))  The backup step writes  messages in the Phase table.  It returns stepid and either:   	0 on success (no serious problems found)     1 on failure (serious problems found). ','0');
INSERT DBObjects VALUES('spCleanupStep','P','A',' Cleanup step, deletes the database ',' <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  The data is in the local DB.  Most of the step parameters are extracted from the task table (see code)  It is a task.type dataload (type in (target|best|runs|plates|tiling))  The backup step writes  messages in the Phase table.  It returns stepid and either:   	0 on success (no serious problems found)     1 on failure (serious problems found). ','0');
INSERT DBObjects VALUES('spShrinkDB','P','A',' RShrinks each of the database files to minimum size ','  Jim Gray, Oct 2004  Largely copied from the DBCC books online ','0');
INSERT DBObjects VALUES('spReorg','P','A',' Reorganize and defragment database tables ','  Jim Gray, Nov 2002  Largely copied from the DBCC books online  Reorganize a database, reclustering tables and indices.  Fist collect a list of statistics about each table and index  then reindex anything with more than 30% extent fragmentation  Largely copied from the DBCC books online ','0');
INSERT DBObjects VALUES('spCopyATable','P','A',' Copies a table from one db to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <br><samp> exec spCopyATable 1,1,''SkyServerV4'', ''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishPhoto','P','A',' Publishes the Photo tables of one DB to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <samp> spPublishPhoto 1,1,''SkyServerV4'',''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishPlates','P','A',' Publishes the Plates tables of one DB to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.plates)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <br><samp> spPublishPlates 1,1,''SkyServerV4'',''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishTiling','P','A',' Publishes the Tiling tables of one DB to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <samp> spPublishTiling 1,1,''SkyServerV4'',''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishWindow','P','A',' Publishes the Window Function tables of one DB to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <samp> spPublishWindow 1,1,''BestDR7'',''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishGalSpec','P','A',' Publishes the galspec tables of one DB to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <samp> spPublishGalSpec 1,1,''BestDR7'',''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishSspp','P','A',' Publishes the sspp Function tables of one DB to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <samp> spPublishsspp 1,1,''BestDR7'',''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishPm','P','A',' Publishes the sspp Function tables of one DB to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <samp> spPublishsspp 1,1,''BestDR7'',''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishResolve','P','A',' Publishes the sspp Function tables of one DB to another  ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> fromDB varchar(100),   	-- source DB (e.g. verify.photo)  <li> toDB varchar(100),   		-- destination DB (e.g. dr1.best)  <li> firstTime int 		-- if 1, creates target table.  <li> returns  0 if OK, non zero if something wrong    <samp> spPublishsspp 1,1,''BestDR7'',''tempDB'', 1 </samp> ','0');
INSERT DBObjects VALUES('spPublishStep','P','A',' Publish step, publishes validated Photo or Spectro data   ',' <li> taskid int,                   -- Task identifier   The data has been imported to a DB, verified and backed up    This task attaches the database, and then pulls its data into the local database.  Most of the step parameters are extracted from the task table (see code)   Data is copied to the ''local'' database tables   It is a task.type dataload (type in (target|best|runs|plates|tiling))   The publish step writes many messages in the Phase table.   It returns either:      0 on success (no serious problems found)      1 on failure (serious problems found).   <br><samp> spPublish @taskId </samp> ','0');
INSERT DBObjects VALUES('spRunSQLScript','P','A',' Executes an SQL script and logs the output string ',' Returns the status of the error, and inserts   error message into the Phase table ','0');
INSERT DBObjects VALUES('spLoadScienceTables','P','A',' Loads the data needed for science with the SDSS. ',' Insert data into RC3, Stetson, QSOCatalog  and other science data tables. ','0');
INSERT DBObjects VALUES('spSetVersion','P','A',' Update the checksum and set the version info for this DB. ','        ','0');
INSERT DBObjects VALUES('spSyncSchema','P','A',' Synchronizes the on-disk schema with the one in the pub db. ',' Reload the metadata tables and the schema files so that  the schema in the pub db is synchronized with the version  on disk (sqlLoader/schema/sql).  This is mainly needed  for incremental loading. ','0');
INSERT DBObjects VALUES('spRunPatch','P','A',' Run the patch contained in the given patch file. ',' Execute the patch from the given file and update the DB  diagnostics and version information accordingly.  The  @versionUpdate parameter allows selection of ''major'' or  ''minor'' (default) update type so that the version number  is incremented accordingly.  Hence a major update will   increase version 3.1 to 3.2, whereas minor update will   increase version 3.1 to 3.1.1. ','0');
INSERT DBObjects VALUES('spLoadMetaData','P','A',' Loads the Metadata about the schema ',' Insert metadata into the database, where it is  located in the UNC path @metadir. Only log if  @taskid>0. Returns >0, if errors occurred.  It will drop and rebuild the indices on the   META index group.  <samp>exec spLoadMetaData 0,0, ''\\SDSSDB\c$\sqlLoader\schema\csv\'' </samp> ','0');
INSERT DBObjects VALUES('spRemoveTaskFromTable','P','A',' Removes rows from table linked to PhotoObj corresponding to a given   task (as specified by a value of the loadversion). ',' Assumes that there is a table called ObjIds, which   contains the bigint PKs of all objects to be removed.  Parameters:  <li> @tableName: the name of the table to be cleaned  <li> @pk: the name of the primary key link  <li> @reinsert: 1 if objects need to be reinserted,    0 if just to be removed.  Default is 0  <li> @countsOnly: 1 if only counts, no actual deletion desired;    0 if deletion to go ahead.  Default is 1 (non-destructive).  <samp>  	exec spRemoveTaskFromTable ''Rosat'', ''objID''  </samp> ','0');
INSERT DBObjects VALUES('spRemoveTaskPhoto','P','A',' Remove objects related to a given @loadversion (i.e. taskID). ',' This script only works on a database without the FINISH step.  Parameters:  <li> @loadversion: the loadversion of the Task to be removed  <li> @reinsert: 1 if objects need to be reinserted,    0 if just to be removed. Default is 0.  <li> @countsOnly: 1 if we only want counts of objects that will    be deleted without actually deleting them; 0 if objects are    to be deleted.  Default is 1 (only return counts for checking). ','0');
INSERT DBObjects VALUES('spRemovePlate','P','A',' Remove spectro objects corresponding to a given plate or plates. ',' This script only works on a database without the FINISH step.  Parameters:  <li> @plate: the plate number of the plate to be deleted              if 0, then multiple plates are to be deleted              and the plate list is assumed to be in PlateIds              table, and specobj list in SpecObjIds table.  <li> @mjd: MJD of plate to be removed  <li> @countsOnly: 1 if we only want counts of objects that will    be deleted without actually deleting them; 0 if objects are    to be deleted.  Default is 1 (only return counts for checking). ','0');
INSERT DBObjects VALUES('spRemoveTaskSpectro','P','A',' Remove spectro objects related to a given @loadversion (i.e. taskID). ',' This script only works on a database without the FINISH step.  Parameters:  <li> @loadversion: the loadversion of the Task to be removed  <li> @countsOnly: 1 if we only want counts of objects that will    be deleted without actually deleting them; 0 if objects are    to be deleted.  Default is 1 (only return counts for checking). ','0');
INSERT DBObjects VALUES('spRemovePlateList','P','A',' Remove spectro objects related to the plate list in the given file. ',' This script only works on a database without the FINISH step.  Parameters:  <li> @fileName: name of file on disk containing list of plate#s     and MJDs  <li> @countsOnly: 1 if we only want counts of objects that will    be deleted without actually deleting them; 0 if objects are    to be deleted.  Default is 1 (only return counts for checking). ','0');
INSERT DBObjects VALUES('spTableCopy','P','A',' Incremental copies @source to @target table based on ObjID range ',' <br>Copies about 100,000 rows at a time in a transaction.   <br>This avoids log overflow and is restartable.  <br>The two tables should exist and have the same schema.  <br>Both tables should have a primary clustring key on ObjID  <br>If the max objID in the target table is not null (not an empty table)  <br> then it is assumed that all source records less than that ObjID are already in the target.  <p> parameters:    <li> @sourceTable 	nvarchar(1000), -- Source table: e.g. BestDr1.dbo.PhotoObj  <li> @targetTable 	nvarchar(1000), -- Target table: e.g. temp.dbo.PhotoObj  <br>  Sample call to copy PhotoObj from BestDr1 to Temp  <samp>   <br> exec spTableCopy N''bestDr1.dbo.PhotoObj'',N''Temp.dbo.PhotoObj''  </samp>     ','0');
INSERT DBObjects VALUES('spBuildSpecPhotoAll','P','A',' Collect the combined spectro and photo parameters of an object in SpecObjAll ',' This is a precomputed join between the PhotoObjAll and SpecObjAll tables.  The photo attibutes included cover about the same as PhotoTag.  The table also includes certain attributes from Tiles. ','0');
INSERT DBObjects VALUES('spSegue2SpectroPhotoMatch','P','A',' Computes PhotoObj corresponding to new SEGUE2 spectra ',' Connect SEGUE2 spectra to photo objects in Best   Designed to run in the Best database.  <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> returns  0 if OK, non zero if something wrong    <br>  Sample call   <br>  <br> <samp>   exec spSegue2SpectroPhotoMatch @taskid , @stepid    </samp>   <br>   ','0');
INSERT DBObjects VALUES('fGetNearbyTiledTargetsEq','F','A',' Returns table of tiled targets within @r arcmins of an Equatorial point (@ra,@dec) ',' <br> ra, dec are in degrees, r is in arc minutes.   <p> returned table:    <li> tile smallint,               -- tile number  <li> targetid bigint,             -- id of target  <li> ra float,                    -- ra (degrees)  <li> dec float,                   -- dec (degrees)  <li> objType int                  -- type of object fiber  <br> ','0');
INSERT DBObjects VALUES('spTiledTargetDuplicates','P','A','  procedure to mark duplicate tiled targets ','   ','0');
INSERT DBObjects VALUES('spSynchronize','P','A','  Finish Spectro object (do photo Spectro matchup) ',' <p> parameters:     <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  <li> destinationDB int,   		-- Name of destination DB   <li> returns  0 if OK, non zero if something wrong    <br>  Sample call:<br>  <samp>   <br> exec  spFinishPlates @taskid , @stepid, ''targetDB''    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spFixTargetVersion','P','A',' Fixes targetVersion in TilingGeometry before running sectors. ',' <li> returns  0 if OK, non zero if something wrong    <br>  Sample call   <br>  <br> <samp>   exec spFixTargetVersion @taskid , @stepid    </samp>   <br>   ','0');
INSERT DBObjects VALUES('spSdssPolygonRegions','P','A',' Create regions of a type ''POLYGON'' during FINISH stage ',' Create the polygon regions for main survey and set the areas  using regionBinary. ','0');
INSERT DBObjects VALUES('spLoadPhotoTag','P','A',' Populate the PhotoTag table ',' This contains the popular fields from the PhotoObjAll table. ','0');
INSERT DBObjects VALUES('spLoadPatches','P','A',' Run any patches that may have accumulated during the loading  process. ',' Run the patches recorded in the nextReleasePatches.sql file  in the patches directory. ','0');
INSERT DBObjects VALUES('spCreateWeblogDB','P','A',' Run any patches that may have accumulated during the loading  process. ',' Run the patches recorded in the nextReleasePatches.sql file  in the patches directory. ','0');
INSERT DBObjects VALUES('spFinishDropIndices','P','A',' Drops the F and I indices in the Finish step, and also the  K indices if the FINISH task comment field contains the   string ''DROP_PK_INDICES''. ',' A wrapper with logging to be called by spFinishStep ','0');
INSERT DBObjects VALUES('spFinishStep','P','A',' Finish step, polishes published Photo or Spectro   ',' <li> taskid int,   		-- Task identifier  <li> stepid int,   		-- Step identifier  The data has been placed in the destination DB.  Neighbors are computed for the photo data  Best PhotoObjects are computed for sciencPrimary Spectro objects   	0 on success (no serious problems found)     1 on failure (serious problems found). ','0');
INSERT DBObjects VALUES('spCopyDbSimpleTable','P','U','','','0');
INSERT DBObjects VALUES('spCopyDbSubset','P','U','','','0');
INSERT DBObjects VALUES('fCosmoZfromDl','F','U',' Returns the redshift at a given luminosity distance.<br> ',' Parameters:<br>  <li> @LuminosityDistance float: luminosity distance in Mpc.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns redshift float  <br><samp> select dbo.fCosmoZfromDl(460.365188862815,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoZfromDl(460.365188862815,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 0.1 and 0.1  <br> see also fCosmoDl ','0');
INSERT DBObjects VALUES('fCosmoZfromDa','F','U',' Returns a row with the first and second solution for the redshift, given an angular diameter distance.<br> ',' Parameters:<br>  <li> @AngularDiamDist float: angular diameter distance in Mpc.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns table (z1 float, z2 float): one row table where z1 and z2 are the first and second solutions, and z1<=z2.  <br><samp> select * from dbo.fCosmoZfromDa(380.467098233731,0.27891507,0.721,8.493e-5,-1,0.701); select * from dbo.fCosmoZfromDa(380.467098233731,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return the rows 0.0999999999999999	29.5344556200345 and 0.0999999999999999	29.5344556200345  <br> see also fCosmoDa ','0');
INSERT DBObjects VALUES('fCosmoZfromDm','F','U',' Returns the redshift for a given transverse comoving distance.<br> ',' Parameters:<br>  <li> @ComovDistTransverse float: transverse comoving distance in Mpc.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns redshift float  <br><samp> select dbo.fCosmoZfromDm(418.513808057105,0.27891507,0.721,8.493e-5,-1,0.701); select dbo.fCosmoZfromDm(418.513808057105,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 0.1 and 0.1  <br> see also fCosmoDm ','0');
INSERT DBObjects VALUES('fCosmoZfromDc','F','U',' Returns the redshift at a given line of sight comoving distance.<br> ',' Parameters:<br>  <li> @ComovDistLineOfSight float: line of sight comoving distance in MPc.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns redshift float  <br><samp> select dbo.fCosmoZfromDc(418.513808057105,0.27891507,0.721,8.493e-5,-1,0.701); select dbo.fCosmoZfromDc(418.513808057105,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 0.1 and 0.1  <br> see also fCosmoDc ','0');
INSERT DBObjects VALUES('fCosmoZfromAgeOfUniverse','F','U',' Returns the redshift at a given age of the universe.<br> ',' Parameters:<br>  <li> @AgeOfUniverse float: Age of the universe in Gyr.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns redshift float  <br><samp> select dbo.fCosmoZfromAgeOfUniverse(12.4160780396264,0.27891507,0.721,8.493e-5,-1,0.701); select dbo.fCosmoZfromAgeOfUniverse(12.4160780396264,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 0.0999999999999961 and 0.0999999999999961  <br> see also fCosmoZfromLookBackTime,fCosmoAgeOfUniverse ','0');
INSERT DBObjects VALUES('fCosmoZfromLookBackTime','F','U',' Returns the redshift at a given look back time.<br> ',' Parameters:<br>  <li> @LookBackTime float: look back time in Gyr.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns redshift float  <br><samp> select dbo.fCosmoZfromLookBackTime(1.30147821902424,0.27891507,0.721,8.493e-5,-1,0.701); select dbo.fCosmoZfromLookBackTime(1.30147821902424,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 0.100000000000001 and 0.100000000000001  <br> see also fCosmoZfromAgeOfUniverse,fCosmoLookBackTime ','0');
INSERT DBObjects VALUES('fCosmoLookBackTime','F','U',' Returns the time interval between the present time and a particular redshift.<br> ',' Parameters:<br>  <li> @z float: redshift   <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns LookBackTime float: look back time in GYr.  <br><samp> select dbo.fCosmoLookBackTime(0.1,0.27891507,0.721,8.493e-5,-1,0.701); select dbo.fCosmoLookBackTime(0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT)  </samp>  <br> return 1.30147821902424 and 1.30147821902424  <br> see also fCosmoAgeOfUniverse and fCosmoTimeInterval ','0');
INSERT DBObjects VALUES('fCosmoAgeOfUniverse','F','U',' Returns the time interval between a particular redshift and the beginning of the universe.<br> ',' Parameters:<br>  <li> @z float: redshift   <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns AgeOfUniverse float: age of the universe in GYr.  <br><samp> select dbo.fCosmoAgeOfUniverse(0.1,0.27891507,0.721,8.493e-5,-1,0.701); select dbo.fCosmoAgeOfUniverse(0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT)  </samp>  <br> return 12.4160780396264 and 12.4160780396264  <br> see also fCosmoLookBackTime and fCosmoTimeInterval ','0');
INSERT DBObjects VALUES('fCosmoTimeInterval','F','U',' Returns the time interval between redshifts zMin and zMax.<br> ',' Parameters:<br>  <li> @zMin float: redshift  <li> @zMax float: redshift  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> Returns TimeInterval float: time interval in GYr.  <br><samp> select dbo.fCosmoTimeInterval(0.1,5,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoTimeInterval(0.1,5,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 11.2234721194364 and 11.2234721194364  <br> see also fCosmoLookBackTime and fCosmoAgeOfUniverse ','0');
INSERT DBObjects VALUES('fCosmoHubbleDistance','F','U',' Returns the Hubble Distance.<br> ',' Parameters:<br>  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc])  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> Returns HubbleDistance float: hubble distance in Mpc.  <br><samp> select dbo.fCosmoHubbleDistance(0.701); select dbo.fCosmoHubbleDistance(DEFAULT) </samp>  <br> return 4276.63991440799 and 4276.63991440799 ','0');
INSERT DBObjects VALUES('fCosmoDl','F','U',' Returns the luminosity distance at a given redshift.<br> ',' Parameters:<br>  <li> @z float: redshift  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns Dl float: luminosity distance in MPc.  <br><samp> select dbo.fCosmoDl(0.1,0.27891507,0.721,8.493e-5,-1,0.701); select dbo.fCosmoDl(0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 460.365188862815 and 460.365188862815  <br> see also fCosmoZfromDl ','0');
INSERT DBObjects VALUES('fCosmoDc','F','U',' Returns the line of sight comoving distance at a given redshift.<br> ',' Parameters:<br>  <li> @z float: redshift  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns Dc float: line of sight comoving distance in MPc.  <br><samp> select dbo.fCosmoDc(0.1,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoDc(0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 418.513808057104 and 418.513808057104  <br> see also fCosmoZfromDc ','0');
INSERT DBObjects VALUES('fCosmoComovDist2ObjectsRADEC','F','U',' Returns the comoving distance between 2 objects at different redshifts and locations in the sphere.<br> ',' Parameters:<br>  <li> @Redshift1 float: redshift of object 1.  <li> @Ra1 float: right asension of object 1 in degrees.  <li> @Dec1 float: declination of object 1 in degrees.  <li> @Redshift2 float: redshift of object 2.  <li> @Ra2 float: right asension of object 2 in degrees.  <li> @Dec2 float: declination of object 2 in degrees.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns ComovDist float: comoving distance between the two objects.  <br><samp> select dbo.fCosmoComovDist2ObjectsRADEC(0.1,0,90,0.1,0,-90,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoComovDist2ObjectsRADEC(0.1,0,90,0.1,0,-90,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 837.027616114209 and 837.027616114209  <br> see also fCosmoZfromDc ','0');
INSERT DBObjects VALUES('fCosmoComovDist2ObjectsXYZ','F','U',' Returns the comoving distance between 2 objects at different redshifts locations in the sphere.<br> ',' Parameters:<br>  <li> @Redshift1 float: redshift of object 1.  <li> @x1 float: x-coordinate of object 1.  <li> @y1 float: y-coordinate of object 1.  <li> @z1 float: z-coordinate of object 1.  <li> @Redshift2 float: redshift of object 2.  <li> @x2 float: x-coordinate of object 2.  <li> @y2 float: y-coordinate of object 2.  <li> @z2 float: z-coordinate of object 2.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns ComovDist float: comoving distance between the two objects.  <br><samp> select dbo.fCosmoComovDist2ObjectsXYZ(0.1,0,0,1,0.1,0,0,-1,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoComovDist2ObjectsXYZ(0.1,0,0,1,0.1,0,0,-1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 837.027616114209 and 837.027616114209   <br> see also fCosmoZfromDc ','0');
INSERT DBObjects VALUES('fCosmoDa','F','U',' Returns the angular diameter distance at a given redshift.<br> ',' Parameters:<br>  <li> @z float: redshift  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns Da float: angular diameter distance in MPc.  <br><samp> select dbo.fCosmoDa(0.1,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoDa(0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT);select dbo.fCosmoDa(29.5344556200345,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoDa(29.5344556200345,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 380.467098233731 and 380.467098233731 and 380.467098233731 and 380.467098233731  <br> see also fCosmoZfromDa ','0');
INSERT DBObjects VALUES('fCosmoDm','F','U',' Returns the transverse comoving distance at a given redshift.<br> ',' Parameters:<br>  <li> @z float: redshift  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns Dm float: transverse comoving distance in MPc.  <br><samp> select dbo.fCosmoDm(0.1,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoDm(0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 418.513808057104 and 418.513808057104  <br> see also fCosmoZfromDm ','0');
INSERT DBObjects VALUES('fCosmoComovingVolume','F','U',' Returns the comoving volume between here and a given redshift.<br> ',' Parameters:<br>  <li> @z float: redshift  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns ComoVingVolume float: Comoving Volume in GPc^3.  <br><samp> select dbo.fCosmoComovingVolume(0.1,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoComovingVolume(0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 0.307056279299776 and 0.307056279299776  <br> see also fCosmoComovVolumeFromDl ','0');
INSERT DBObjects VALUES('fCosmoAbsMag','F','U',' Returns the absolute magnitude of a galaxy at a particular redshift.<br> ',' Parameters:<br>  <li> @m float: aparent magnitude of the object  <li> @z float: redshift  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns AbsMag: absolute magnitude  <br><samp> select dbo.fCosmoAbsMag(17.5,0.1,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoAbsMag(17.5,0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return -20.8155123821697 and -20.8155123821697  <br> see also fCosmoDistanceModulus ','0');
INSERT DBObjects VALUES('fCosmoDistanceModulus','F','U',' Returns the distance modulus at a particular redshift.<br> ',' Parameters:<br>  <li> @z float: redshift  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns DistanceModulus: distance modulus   <br><samp> select dbo.fCosmoDistanceModulus(0.1,0.27891507,0.721,8.493e-5,-1,0.701);select dbo.fCosmoDistanceModulus(0.1,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp>  <br> return 38.3155123821697 and 38.3155123821697  <br> see also fCosmoAbsMag ','0');
INSERT DBObjects VALUES('fCosmoQuantities','F','U',' Returns a table of redshifts and the corresponding values of the cosmological distances,comoving volume and time intervals.<br> ',' Parameters:<br>  <li> @zMin float: redshift lower bound  <li> @zMax float: redshift upper bound  <li> @NumBin int: number of bins, at whose boundaries all the values are evaluated. Number of rows returned = @NUmBin + 1.  <li> @OmegaM float: matter density. If set as DEFAULT, then 0.27891507  <li> @OmegaL float: dark energy density. If set as DEFAULT, then 0.721  <li> @OmegaR float: radiation density. If set as DEFAULT, then 8.493e-5  <li> @omega0 float: dark energy state equation. If set as DEFAULT, then -1  <li> @h_0 float: (hubble constant[Km/s/MPc])/(100[Km/s/MPc]). If set as DEFAULT, then 0.701  Reference:  http://lambda.gsfc.nasa.gov/product/map/dr3/pub_papers/fiveyear/cosmology/wmap_5yr_cosmo.pdf <br>  <li> returns table (z float, Dc float, Dm float, Da float, Dl float, Dh float, ComVol float, LookBackTime float, AgeOfUniverse float) where  <li> z: redshift   <li> Dc: line of sight comoving distance in MPc.  <li> Dm: transverse comoving distance in MPc.   <li> Da: angular diameter distance in MPc.  <li> Dl: luminosity distance in MPc.  <li> Dh: hubble distance in MPc.  <li> ComVol: comoving volume in GPc^3.  <li> LookBackTime: look back time at z in GYr.  <li> AgeOfUniverse: age of the universe at z in GYr.  <br><samp> select * from fCosmoQuantities(0,5,1000,0.27891507,0.721,8.493e-5,-1,0.701);select * from fCosmoQuantities(0,5,1000,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT) </samp> ','0');
INSERT DBObjects VALUES('fMathGetBin','F','U',' Returns the value at the center of the bin where @x falls in, given a grid of @NumBin bins in the interval @x1 to @x2.<br> ',' Parameters:<br>  <li> @x float: value of the variable.  <li> @x1 float: lower bound of the interval.  <li> @x2 float: upper bound of the interval.  <li> @NumBin int: number of bins in which the inteval is partitioned.  <li> @HasOpenUpperBound bit: true if the bins have open upper bounds (and closed lower bounds); false if the bins have open lower bounds (and closed upper bounds).  <li> returns BinCenter float: the center of the bin, where @x falls in.   <br><samp> select dbo.fMathGetBin( s.z,0.1,0.7,24,0) as BinCenter, count(*) as Counts from SpecPhoto as s where primtarget&(0x04000020)!=0 and primtarget&(64|128|256)=0 and z between 0.1 and 0.7 group by dbo.fMathGetBin(s.z,0.1,0.7,24,0) order by dbo.fMathGetBin(s.z,0.1,0.7,24,0) </samp>  <br> see also spMathHistogramNDim ','0');

GO
----------------------------- 
PRINT '472 lines inserted into DBObjects '
----------------------------- 


-- Reload DBColumns table
TRUNCATE TABLE DBColumns 
GO

INSERT DBColumns VALUES('PartitionMap','fileGroupName','','','','name of table or index','0');
INSERT DBColumns VALUES('PartitionMap','size','','','','size in GB/million objects','0');
INSERT DBColumns VALUES('PartitionMap','comment','','','','explanation','0');
INSERT DBColumns VALUES('FileGroupMap','tableName','','','','name of table or index','0');
INSERT DBColumns VALUES('FileGroupMap','tableFileGroup','','','','name of filegroup','0');
INSERT DBColumns VALUES('FileGroupMap','indexFileGroup','','','','name of the index filegroup','0');
INSERT DBColumns VALUES('FileGroupMap','comment','','','','explanation','0');
INSERT DBColumns VALUES('DataConstants','field','','METADATA_NAME','','Field Name','0');
INSERT DBColumns VALUES('DataConstants','name','','METADATA_NAME','','Constant Name','0');
INSERT DBColumns VALUES('DataConstants','value','','CODE_MISC','','Type value','0');
INSERT DBColumns VALUES('DataConstants','description','','METADATA_DESCRIPTION','','Short description','0');
INSERT DBColumns VALUES('SDSSConstants','name','','METADATA_NAME','','Name of the constant','0');
INSERT DBColumns VALUES('SDSSConstants','value','','NUMBER','','The numerical value in float','0');
INSERT DBColumns VALUES('SDSSConstants','unit','','METADATA_UNIT','','Its physical unit','0');
INSERT DBColumns VALUES('SDSSConstants','description','','METADATA_DESCRIPTION','','Short description','0');
INSERT DBColumns VALUES('StripeDefs','stripe','','EXTENSION_AREA','','Stripe number','0');
INSERT DBColumns VALUES('StripeDefs','hemisphere','','EXTENSION_AREA','','Which hemisphere (N|S)','0');
INSERT DBColumns VALUES('StripeDefs','eta','deg','POS_SDSS_ETA','','Survey eta for the center of stripe','0');
INSERT DBColumns VALUES('StripeDefs','lambdaMin','deg','POS_SDSS_LAMBDA POS_LIMIT','','Survey lambda lower limit of the stripe','0');
INSERT DBColumns VALUES('StripeDefs','lambdaMax','deg','POS_SDSS_LAMBDA POS_LIMIT','','Survey lambda upper limit of the stripe','0');
INSERT DBColumns VALUES('StripeDefs','htmArea','','???','','HTM area descriptor string','0');
INSERT DBColumns VALUES('RunShift','run','','','','Run id','0');
INSERT DBColumns VALUES('RunShift','shift','deg','POS_OFFSET','','The nu shift applied','0');
INSERT DBColumns VALUES('ProfileDefs','bin','','EXTENSION','','bin','0');
INSERT DBColumns VALUES('ProfileDefs','cell','','EXTENSION','','the first cell in the annulus','0');
INSERT DBColumns VALUES('ProfileDefs','sinc','','CODE_MISC','','sinc shift (0:no, 1:yes)','0');
INSERT DBColumns VALUES('ProfileDefs','rInner','arcsec','EXTENSION_RAD','','Inner radius of the bin','0');
INSERT DBColumns VALUES('ProfileDefs','rOuter','srcsec','EXTENSION_RAD','','Outer radius of the bin','0');
INSERT DBColumns VALUES('ProfileDefs','aAnn','arcsec^2','EXTENSION_AREA','','The area of the annulus','0');
INSERT DBColumns VALUES('ProfileDefs','aDisk','arcsec^2','EXTENSION_AREA','','The area of the disk to outerRadius','0');
INSERT DBColumns VALUES('SiteDBs','dbname','','','','Name of the database','0');
INSERT DBColumns VALUES('SiteDBs','description','','','','Short one-line description','0');
INSERT DBColumns VALUES('SiteDBs','active','','','','Is it active/visible?','0');
INSERT DBColumns VALUES('QueryResults','query','','','','query name','0');
INSERT DBColumns VALUES('QueryResults','cpu_sec','sec','','','CPU time','0');
INSERT DBColumns VALUES('QueryResults','elapsed_time','sec','','','elapsed time','0');
INSERT DBColumns VALUES('QueryResults','physical_IO','','','','Physical IO','0');
INSERT DBColumns VALUES('QueryResults','row_count','','','','row count','0');
INSERT DBColumns VALUES('QueryResults','time','','','','timestamp','0');
INSERT DBColumns VALUES('QueryResults','comment','','','','comment describing test paraeters','0');
INSERT DBColumns VALUES('RecentQueries','ipAddr','','','','','0');
INSERT DBColumns VALUES('RecentQueries','lastQueryTime','','','','','0');
INSERT DBColumns VALUES('SiteConstants','name','','ID_IDENTIFIER','','Name','0');
INSERT DBColumns VALUES('SiteConstants','value','','DATA','','Value','0');
INSERT DBColumns VALUES('SiteConstants','comment','','METADATA_DESCRIPTION','','Description','0');
INSERT DBColumns VALUES('DBObjects','name','','ID_IDENTIFIER','','Name of the object','0');
INSERT DBColumns VALUES('DBObjects','type','','ID_GROUP','','Its system type','0');
INSERT DBColumns VALUES('DBObjects','access','','ID_GROUP','','Defines user or admin access','0');
INSERT DBColumns VALUES('DBObjects','description','','METADATA_DESCRIPTION','','One line description of contents','0');
INSERT DBColumns VALUES('DBObjects','text','','METADATA_DESCRIPTION','','Detailed description of contents','0');
INSERT DBColumns VALUES('DBObjects','rank','','ID_TABLE','','Optional position of column in table display','0');
INSERT DBColumns VALUES('DBColumns','tablename','','ID_TABLE','','The name of the parent table','0');
INSERT DBColumns VALUES('DBColumns','name','','ID_IDENTIFIER','','The name of column','0');
INSERT DBColumns VALUES('DBColumns','unit','','METADATA_UNIT','','Optional description of units','0');
INSERT DBColumns VALUES('DBColumns','ucd','','ID_IDENTIFIER','','Optional UCD definition','0');
INSERT DBColumns VALUES('DBColumns','enum','','ID_TABLE','','Optional link to an enumerated table','0');
INSERT DBColumns VALUES('DBColumns','description','','METADATA_DESCRIPTION','','One line description of column','0');
INSERT DBColumns VALUES('DBColumns','rank','','ID_TABLE','','Optional position of column in table column display','0');
INSERT DBColumns VALUES('DBViewCols','name','','ID_IDENTIFIER','','The name of column','0');
INSERT DBColumns VALUES('DBViewCols','viewname','','ID_TABLE','','The name of the view','0');
INSERT DBColumns VALUES('DBViewCols','parent','','ID_TABLE','','The name of the parent','0');
INSERT DBColumns VALUES('History','id','','ID_IDENTIFIER','','The unique key for entry','0');
INSERT DBColumns VALUES('History','filename','','ID_IDENTIFIER','','The name of the sql file','0');
INSERT DBColumns VALUES('History','date','','DATE','','Date of change','0');
INSERT DBColumns VALUES('History','name','','ID_IDENTIFIER','','Name of person making the change','0');
INSERT DBColumns VALUES('History','description','','METADATA_DESCRIPTION','','Detailed description of changes','0');
INSERT DBColumns VALUES('Inventory','filename','','ID_IDENTIFIER','','The name of the sql file','0');
INSERT DBColumns VALUES('Inventory','name','','ID_IDENTIFIER','','Name of DBObject','0');
INSERT DBColumns VALUES('Inventory','type','','METADATA_DESCRIPTION','','Detailed description of changes','0');
INSERT DBColumns VALUES('Dependency','filename','','ID_IDENTIFIER','','The name of the sql file','0');
INSERT DBColumns VALUES('Dependency','parent','','ID_IDENTIFIER','','Name of caller','0');
INSERT DBColumns VALUES('Dependency','child','','ID_IDENTIFIER','','Name of called function','0');
INSERT DBColumns VALUES('PubHistory','name','','','','the name of the table we publish into','0');
INSERT DBColumns VALUES('PubHistory','nrows','','','','the number of rows published','0');
INSERT DBColumns VALUES('PubHistory','tend','','','','the time the table was published','0');
INSERT DBColumns VALUES('PubHistory','loadversion','','','','the taskid where it came from','0');
INSERT DBColumns VALUES('LoadHistory','loadversion','','','','','0');
INSERT DBColumns VALUES('LoadHistory','tstart','','','','','0');
INSERT DBColumns VALUES('LoadHistory','tend','','','','','0');
INSERT DBColumns VALUES('LoadHistory','dbname','','','','','0');
INSERT DBColumns VALUES('Diagnostics','name','','ID_IDENTIFIER','','Name of object','0');
INSERT DBColumns VALUES('Diagnostics','type','','CODE_MISc','','System type of the object (U:table, V:view, F: function, P: stored proc)','0');
INSERT DBColumns VALUES('Diagnostics','count','','NUMBER','','Optional row count, where applicable','0');
INSERT DBColumns VALUES('SiteDiagnostics','name','','ID_IDENTIFIER','','Name of object','0');
INSERT DBColumns VALUES('SiteDiagnostics','type','','???','','System type of the object (U:table, V:view, F: function, P: stored proc)','0');
INSERT DBColumns VALUES('SiteDiagnostics','count','','NUMBER','','Optional row count, where applicable','0');
INSERT DBColumns VALUES('IndexMap','indexmapid','','CODE_MISC','','unique primary key for the indexmap','0');
INSERT DBColumns VALUES('IndexMap','code','','CODE_MISC','','one char designator of index category for lookup (''K''|''F''|''I'')','0');
INSERT DBColumns VALUES('IndexMap','type','','CODE_MISC','','index type, one of (''primary key''|''foreign key''|''index''|''unique index'')','0');
INSERT DBColumns VALUES('IndexMap','tableName','','CODE_MISC','','the name of the table the index is built on','0');
INSERT DBColumns VALUES('IndexMap','fieldList','','CODE_MISC','','the list of columns to be included in the index','0');
INSERT DBColumns VALUES('IndexMap','foreignKey','','CODE_MISC','','the definition of the foreign Key if any','0');
INSERT DBColumns VALUES('IndexMap','indexgroup','','CODE_MISC','','the group id, one of (''PHOTO''|''TAG''|''SPECTRO''|''QSO''|''META''|''TILES''|''FINISH'')','0');
INSERT DBColumns VALUES('Versions','event','','ID_IDENITIFIER','','The event that happened','0');
INSERT DBColumns VALUES('Versions','previous','','ID_TRACER','','Version before the patch','0');
INSERT DBColumns VALUES('Versions','checksum','','NUMBER','','Checksum before the patch','0');
INSERT DBColumns VALUES('Versions','version','','ID_TRACER','','Version after the patch','0');
INSERT DBColumns VALUES('Versions','description','','METADATA_DESCRIPTION','','Summary of changes','0');
INSERT DBColumns VALUES('Versions','text','','METADATA_DESCRIPTION','','Details of changes in HTML form','0');
INSERT DBColumns VALUES('Versions','who','','ID_HUMAN','','Person(s) responsible','0');
INSERT DBColumns VALUES('Versions','when','','TIME_DATE','','When it happened','0');
INSERT DBColumns VALUES('Field','fieldID','','','','Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field].','0');
INSERT DBColumns VALUES('Field','skyVersion','','','','Layer of catalog (currently only one layer, 0; 0-15 available)','0');
INSERT DBColumns VALUES('Field','run','','','','Run number','0');
INSERT DBColumns VALUES('Field','rerun','','','','Rerun number','0');
INSERT DBColumns VALUES('Field','camcol','','','','Camera column','0');
INSERT DBColumns VALUES('Field','field','','','','Field number','0');
INSERT DBColumns VALUES('Field','nTotal','','','','Number of total objects in the field','0');
INSERT DBColumns VALUES('Field','nObjects','','','','Number of non-bright objects in the field','0');
INSERT DBColumns VALUES('Field','nChild','','','','Number of "child" objects in the field','0');
INSERT DBColumns VALUES('Field','nGalaxy','','','','Number of objects classified as "galaxy"','0');
INSERT DBColumns VALUES('Field','nStars','','','','Number of objects classified as "star"','0');
INSERT DBColumns VALUES('Field','nCR_u','','','','Number of cosmics in u-band','0');
INSERT DBColumns VALUES('Field','nCR_g','','','','Number of cosmics in g-band','0');
INSERT DBColumns VALUES('Field','nCR_r','','','','Number of cosmics in r-band','0');
INSERT DBColumns VALUES('Field','nCR_i','','','','Number of cosmics in i-band','0');
INSERT DBColumns VALUES('Field','nCR_z','','','','Number of cosmics in z-band','0');
INSERT DBColumns VALUES('Field','nBrightObj_u','','','','Number of bright objects in u-band','0');
INSERT DBColumns VALUES('Field','nBrightObj_g','','','','Number of bright objects in g-band','0');
INSERT DBColumns VALUES('Field','nBrightObj_r','','','','Number of bright objects in r-band','0');
INSERT DBColumns VALUES('Field','nBrightObj_i','','','','Number of bright objects in i-band','0');
INSERT DBColumns VALUES('Field','nBrightObj_z','','','','Number of bright objects in z-band','0');
INSERT DBColumns VALUES('Field','nFaintObj_u','','','','Number of faint objects in u-band','0');
INSERT DBColumns VALUES('Field','nFaintObj_g','','','','Number of faint objects in g-band','0');
INSERT DBColumns VALUES('Field','nFaintObj_r','','','','Number of faint objects in r-band','0');
INSERT DBColumns VALUES('Field','nFaintObj_i','','','','Number of faint objects in i-band','0');
INSERT DBColumns VALUES('Field','nFaintObj_z','','','','Number of faint objects in z-band','0');
INSERT DBColumns VALUES('Field','quality','','','','Quality of field','0');
INSERT DBColumns VALUES('Field','mjd_u','','','','MJD(TAI) when row 0 of u-band field was read','0');
INSERT DBColumns VALUES('Field','mjd_g','','','','MJD(TAI) when row 0 of g-band field was read','0');
INSERT DBColumns VALUES('Field','mjd_r','','','','MJD(TAI) when row 0 of r-band field was read','0');
INSERT DBColumns VALUES('Field','mjd_i','','','','MJD(TAI) when row 0 of i-band field was read','0');
INSERT DBColumns VALUES('Field','mjd_z','','','','MJD(TAI) when row 0 of z-band field was read','0');
INSERT DBColumns VALUES('Field','a_u','','','','a term in astrometry for u-band','0');
INSERT DBColumns VALUES('Field','a_g','','','','a term in astrometry for g-band','0');
INSERT DBColumns VALUES('Field','a_r','','','','a term in astrometry for r-band','0');
INSERT DBColumns VALUES('Field','a_i','','','','a term in astrometry for i-band','0');
INSERT DBColumns VALUES('Field','a_z','','','','a term in astrometry for z-band','0');
INSERT DBColumns VALUES('Field','b_u','','','','b term in astrometry for u-band','0');
INSERT DBColumns VALUES('Field','b_g','','','','b term in astrometry for g-band','0');
INSERT DBColumns VALUES('Field','b_r','','','','b term in astrometry for r-band','0');
INSERT DBColumns VALUES('Field','b_i','','','','b term in astrometry for i-band','0');
INSERT DBColumns VALUES('Field','b_z','','','','b term in astrometry for z-band','0');
INSERT DBColumns VALUES('Field','c_u','','','','c term in astrometry for u-band','0');
INSERT DBColumns VALUES('Field','c_g','','','','c term in astrometry for g-band','0');
INSERT DBColumns VALUES('Field','c_r','','','','c term in astrometry for r-band','0');
INSERT DBColumns VALUES('Field','c_i','','','','c term in astrometry for i-band','0');
INSERT DBColumns VALUES('Field','c_z','','','','c term in astrometry for z-band','0');
INSERT DBColumns VALUES('Field','d_u','','','','d term in astrometry for u-band','0');
INSERT DBColumns VALUES('Field','d_g','','','','d term in astrometry for g-band','0');
INSERT DBColumns VALUES('Field','d_r','','','','d term in astrometry for r-band','0');
INSERT DBColumns VALUES('Field','d_i','','','','d term in astrometry for i-band','0');
INSERT DBColumns VALUES('Field','d_z','','','','d term in astrometry for z-band','0');
INSERT DBColumns VALUES('Field','e_u','','','','e term in astrometry for u-band','0');
INSERT DBColumns VALUES('Field','e_g','','','','e term in astrometry for g-band','0');
INSERT DBColumns VALUES('Field','e_r','','','','e term in astrometry for r-band','0');
INSERT DBColumns VALUES('Field','e_i','','','','e term in astrometry for i-band','0');
INSERT DBColumns VALUES('Field','e_z','','','','e term in astrometry for z-band','0');
INSERT DBColumns VALUES('Field','f_u','','','','f term in astrometry for u-band','0');
INSERT DBColumns VALUES('Field','f_g','','','','f term in astrometry for g-band','0');
INSERT DBColumns VALUES('Field','f_r','','','','f term in astrometry for r-band','0');
INSERT DBColumns VALUES('Field','f_i','','','','f term in astrometry for i-band','0');
INSERT DBColumns VALUES('Field','f_z','','','','f term in astrometry for z-band','0');
INSERT DBColumns VALUES('Field','dRow0_u','','','','Zero-order row distortion coefficient in u-band','0');
INSERT DBColumns VALUES('Field','dRow0_g','','','','Zero-order row distortion coefficient in g-band','0');
INSERT DBColumns VALUES('Field','dRow0_r','','','','Zero-order row distortion coefficient in r-band','0');
INSERT DBColumns VALUES('Field','dRow0_i','','','','Zero-order row distortion coefficient in i-band','0');
INSERT DBColumns VALUES('Field','dRow0_z','','','','Zero-order row distortion coefficient in z-band','0');
INSERT DBColumns VALUES('Field','dRow1_u','','','','First-order row distortion coefficient in u-band','0');
INSERT DBColumns VALUES('Field','dRow1_g','','','','First-order row distortion coefficient in g-band','0');
INSERT DBColumns VALUES('Field','dRow1_r','','','','First-order row distortion coefficient in r-band','0');
INSERT DBColumns VALUES('Field','dRow1_i','','','','First-order row distortion coefficient in i-band','0');
INSERT DBColumns VALUES('Field','dRow1_z','','','','First-order row distortion coefficient in z-band','0');
INSERT DBColumns VALUES('Field','dRow2_u','','','','Second-order row distortion coefficient in u-band','0');
INSERT DBColumns VALUES('Field','dRow2_g','','','','Second-order row distortion coefficient in g-band','0');
INSERT DBColumns VALUES('Field','dRow2_r','','','','Second-order row distortion coefficient in r-band','0');
INSERT DBColumns VALUES('Field','dRow2_i','','','','Second-order row distortion coefficient in i-band','0');
INSERT DBColumns VALUES('Field','dRow2_z','','','','Second-order row distortion coefficient in z-band','0');
INSERT DBColumns VALUES('Field','dRow3_u','','','','Third-order row distortion coefficient in u-band','0');
INSERT DBColumns VALUES('Field','dRow3_g','','','','Third-order row distortion coefficient in g-band','0');
INSERT DBColumns VALUES('Field','dRow3_r','','','','Third-order row distortion coefficient in r-band','0');
INSERT DBColumns VALUES('Field','dRow3_i','','','','Third-order row distortion coefficient in i-band','0');
INSERT DBColumns VALUES('Field','dRow3_z','','','','Third-order row distortion coefficient in z-band','0');
INSERT DBColumns VALUES('Field','dCol0_u','','','','Zero-order column distortion coefficient in u-band','0');
INSERT DBColumns VALUES('Field','dCol0_g','','','','Zero-order column distortion coefficient in g-band','0');
INSERT DBColumns VALUES('Field','dCol0_r','','','','Zero-order column distortion coefficient in r-band','0');
INSERT DBColumns VALUES('Field','dCol0_i','','','','Zero-order column distortion coefficient in i-band','0');
INSERT DBColumns VALUES('Field','dCol0_z','','','','Zero-order column distortion coefficient in z-band','0');
INSERT DBColumns VALUES('Field','dCol1_u','','','','First-order column distortion coefficient in u-band','0');
INSERT DBColumns VALUES('Field','dCol1_g','','','','First-order column distortion coefficient in g-band','0');
INSERT DBColumns VALUES('Field','dCol1_r','','','','First-order column distortion coefficient in r-band','0');
INSERT DBColumns VALUES('Field','dCol1_i','','','','First-order column distortion coefficient in i-band','0');
INSERT DBColumns VALUES('Field','dCol1_z','','','','First-order column distortion coefficient in z-band','0');
INSERT DBColumns VALUES('Field','dCol2_u','','','','Second-order column distortion coefficient in u-band','0');
INSERT DBColumns VALUES('Field','dCol2_g','','','','Second-order column distortion coefficient in g-band','0');
INSERT DBColumns VALUES('Field','dCol2_r','','','','Second-order column distortion coefficient in r-band','0');
INSERT DBColumns VALUES('Field','dCol2_i','','','','Second-order column distortion coefficient in i-band','0');
INSERT DBColumns VALUES('Field','dCol2_z','','','','Second-order column distortion coefficient in z-band','0');
INSERT DBColumns VALUES('Field','dCol3_u','','','','Third-order column distortion coefficient in u-band','0');
INSERT DBColumns VALUES('Field','dCol3_g','','','','Third-order column distortion coefficient in g-band','0');
INSERT DBColumns VALUES('Field','dCol3_r','','','','Third-order column distortion coefficient in r-band','0');
INSERT DBColumns VALUES('Field','dCol3_i','','','','Third-order column distortion coefficient in i-band','0');
INSERT DBColumns VALUES('Field','dCol3_z','','','','Third-order column distortion coefficient in z-band','0');
INSERT DBColumns VALUES('Field','csRow_u','','','','Slope in row DCR correction for blue objects (u-band)','0');
INSERT DBColumns VALUES('Field','csRow_g','','','','Slope in row DCR correction for blue objects (g-band)','0');
INSERT DBColumns VALUES('Field','csRow_r','','','','Slope in row DCR correction for blue objects (r-band)','0');
INSERT DBColumns VALUES('Field','csRow_i','','','','Slope in row DCR correction for blue objects (i-band)','0');
INSERT DBColumns VALUES('Field','csRow_z','','','','Slope in row DCR correction for blue objects (z-band)','0');
INSERT DBColumns VALUES('Field','csCol_u','','','','Slope in column DCR correction for blue objects (u-band)','0');
INSERT DBColumns VALUES('Field','csCol_g','','','','Slope in column DCR correction for blue objects (g-band)','0');
INSERT DBColumns VALUES('Field','csCol_r','','','','Slope in column DCR correction for blue objects (r-band)','0');
INSERT DBColumns VALUES('Field','csCol_i','','','','Slope in column DCR correction for blue objects (i-band)','0');
INSERT DBColumns VALUES('Field','csCol_z','','','','Slope in column DCR correction for blue objects (z-band)','0');
INSERT DBColumns VALUES('Field','ccRow_u','','','','Constant row DCR correction for blue objects (u-band)','0');
INSERT DBColumns VALUES('Field','ccRow_g','','','','Constant row DCR correction for blue objects (g-band)','0');
INSERT DBColumns VALUES('Field','ccRow_r','','','','Constant row DCR correction for blue objects (r-band)','0');
INSERT DBColumns VALUES('Field','ccRow_i','','','','Constant row DCR correction for blue objects (i-band)','0');
INSERT DBColumns VALUES('Field','ccRow_z','','','','Constant row DCR correction for blue objects (z-band)','0');
INSERT DBColumns VALUES('Field','ccCol_u','','','','Constant column DCR correction for blue objects (u-band)','0');
INSERT DBColumns VALUES('Field','ccCol_g','','','','Constant column DCR correction for blue objects (g-band)','0');
INSERT DBColumns VALUES('Field','ccCol_r','','','','Constant column DCR correction for blue objects (r-band)','0');
INSERT DBColumns VALUES('Field','ccCol_i','','','','Constant column DCR correction for blue objects (i-band)','0');
INSERT DBColumns VALUES('Field','ccCol_z','','','','Constant column DCR correction for blue objects (z-band)','0');
INSERT DBColumns VALUES('Field','riCut_u','','','','r-i cutoff between blue and red objects (for u-band astrometry)','0');
INSERT DBColumns VALUES('Field','riCut_g','','','','r-i cutoff between blue and red objects (for g-band astrometry)','0');
INSERT DBColumns VALUES('Field','riCut_r','','','','r-i cutoff between blue and red objects (for r-band astrometry)','0');
INSERT DBColumns VALUES('Field','riCut_i','','','','r-i cutoff between blue and red objects (for i-band astrometry)','0');
INSERT DBColumns VALUES('Field','riCut_z','','','','r-i cutoff between blue and red objects (for z-band astrometry)','0');
INSERT DBColumns VALUES('Field','airmass_u','mag','','','Airmass for star at frame center (midway through u-band exposure)','0');
INSERT DBColumns VALUES('Field','airmass_g','mag','','','Airmass for star at frame center (midway through g-band exposure)','0');
INSERT DBColumns VALUES('Field','airmass_r','mag','','','Airmass for star at frame center (midway through r-band exposure)','0');
INSERT DBColumns VALUES('Field','airmass_i','mag','','','Airmass for star at frame center (midway through i-band exposure)','0');
INSERT DBColumns VALUES('Field','airmass_z','mag','','','Airmass for star at frame center (midway through z-band exposure)','0');
INSERT DBColumns VALUES('Field','muErr_u','arcsec','','','Error in mu in astrometric calibration (for u-band)','0');
INSERT DBColumns VALUES('Field','muErr_g','arcsec','','','Error in mu in astrometric calibration (for g-band)','0');
INSERT DBColumns VALUES('Field','muErr_r','arcsec','','','Error in mu in astrometric calibration (for r-band)','0');
INSERT DBColumns VALUES('Field','muErr_i','arcsec','','','Error in mu in astrometric calibration (for i-band)','0');
INSERT DBColumns VALUES('Field','muErr_z','arcsec','','','Error in mu in astrometric calibration (for z-band)','0');
INSERT DBColumns VALUES('Field','nuErr_u','arcsec','','','Error in nu in astrometric calibration (for u-band)','0');
INSERT DBColumns VALUES('Field','nuErr_g','arcsec','','','Error in nu in astrometric calibration (for g-band)','0');
INSERT DBColumns VALUES('Field','nuErr_r','arcsec','','','Error in nu in astrometric calibration (for r-band)','0');
INSERT DBColumns VALUES('Field','nuErr_i','arcsec','','','Error in nu in astrometric calibration (for i-band)','0');
INSERT DBColumns VALUES('Field','nuErr_z','arcsec','','','Error in nu in astrometric calibration (for z-band)','0');
INSERT DBColumns VALUES('Field','raMin','deg','','','Minimum RA of field','0');
INSERT DBColumns VALUES('Field','raMax','deg','','','Maximum RA of field','0');
INSERT DBColumns VALUES('Field','decMin','deg','','','Minimum Dec of field','0');
INSERT DBColumns VALUES('Field','decMax','deg','','','Maximum Dec of field','0');
INSERT DBColumns VALUES('Field','pixScale','arcsec/pix','','','Mean size of pixel (r-band)','0');
INSERT DBColumns VALUES('Field','primaryArea','deg^2','','','Area covered by primary part of field','0');
INSERT DBColumns VALUES('Field','photoStatus','','','','Frames processing status bitmask','0');
INSERT DBColumns VALUES('Field','rowOffset_u','pix','','','Offset to add to transformed row coordinates (u-band)','0');
INSERT DBColumns VALUES('Field','rowOffset_g','pix','','','Offset to add to transformed row coordinates (g-band)','0');
INSERT DBColumns VALUES('Field','rowOffset_r','pix','','','Offset to add to transformed row coordinates (r-band)','0');
INSERT DBColumns VALUES('Field','rowOffset_i','pix','','','Offset to add to transformed row coordinates (i-band)','0');
INSERT DBColumns VALUES('Field','rowOffset_z','pix','','','Offset to add to transformed row coordinates (z-band)','0');
INSERT DBColumns VALUES('Field','colOffset_u','pix','','','Offset to add to transformed row coordinates (u-band)','0');
INSERT DBColumns VALUES('Field','colOffset_g','pix','','','Offset to add to transformed row coordinates (g-band)','0');
INSERT DBColumns VALUES('Field','colOffset_r','pix','','','Offset to add to transformed row coordinates (r-band)','0');
INSERT DBColumns VALUES('Field','colOffset_i','pix','','','Offset to add to transformed row coordinates (i-band)','0');
INSERT DBColumns VALUES('Field','colOffset_z','pix','','','Offset to add to transformed row coordinates (z-band)','0');
INSERT DBColumns VALUES('Field','saturationLevel_u','counts','','','Saturation level in u-band','0');
INSERT DBColumns VALUES('Field','saturationLevel_g','counts','','','Saturation level in g-band','0');
INSERT DBColumns VALUES('Field','saturationLevel_r','counts','','','Saturation level in r-band','0');
INSERT DBColumns VALUES('Field','saturationLevel_i','counts','','','Saturation level in i-band','0');
INSERT DBColumns VALUES('Field','saturationLevel_z','counts','','','Saturation level in z-band','0');
INSERT DBColumns VALUES('Field','nEffPsf_u','pix','','','Effective area of PSF (u-band)','0');
INSERT DBColumns VALUES('Field','nEffPsf_g','pix','','','Effective area of PSF (g-band)','0');
INSERT DBColumns VALUES('Field','nEffPsf_r','pix','','','Effective area of PSF (r-band)','0');
INSERT DBColumns VALUES('Field','nEffPsf_i','pix','','','Effective area of PSF (i-band)','0');
INSERT DBColumns VALUES('Field','nEffPsf_z','pix','','','Effective area of PSF (z-band)','0');
INSERT DBColumns VALUES('Field','skyPsp_u','nmgy/arcsec^2','','','Sky estimate from PSP (u-band)','0');
INSERT DBColumns VALUES('Field','skyPsp_g','nmgy/arcsec^2','','','Sky estimate from PSP (g-band)','0');
INSERT DBColumns VALUES('Field','skyPsp_r','nmgy/arcsec^2','','','Sky estimate from PSP (r-band)','0');
INSERT DBColumns VALUES('Field','skyPsp_i','nmgy/arcsec^2','','','Sky estimate from PSP (i-band)','0');
INSERT DBColumns VALUES('Field','skyPsp_z','nmgy/arcsec^2','','','Sky estimate from PSP (z-band)','0');
INSERT DBColumns VALUES('Field','skyFrames_u','nmgy/arcsec^2','','','Frames sky value','0');
INSERT DBColumns VALUES('Field','skyFrames_g','nmgy/arcsec^2','','','Frames sky value','0');
INSERT DBColumns VALUES('Field','skyFrames_r','nmgy/arcsec^2','','','Frames sky value','0');
INSERT DBColumns VALUES('Field','skyFrames_i','nmgy/arcsec^2','','','Frames sky value','0');
INSERT DBColumns VALUES('Field','skyFrames_z','nmgy/arcsec^2','','','Frames sky value','0');
INSERT DBColumns VALUES('Field','skyFramesSub_u','nmgy/arcsec^2','','','Frames sky value after object subtraction','0');
INSERT DBColumns VALUES('Field','skyFramesSub_g','nmgy/arcsec^2','','','Frames sky value after object subtraction','0');
INSERT DBColumns VALUES('Field','skyFramesSub_r','nmgy/arcsec^2','','','Frames sky value after object subtraction','0');
INSERT DBColumns VALUES('Field','skyFramesSub_i','nmgy/arcsec^2','','','Frames sky value after object subtraction','0');
INSERT DBColumns VALUES('Field','skyFramesSub_z','nmgy/arcsec^2','','','Frames sky value after object subtraction','0');
INSERT DBColumns VALUES('Field','sigPix_u','nmgy/arcsec^2','','','Sigma of pixel values in u-band frame (clipped)','0');
INSERT DBColumns VALUES('Field','sigPix_g','nmgy/arcsec^2','','','Sigma of pixel values in g-band frame (clipped)','0');
INSERT DBColumns VALUES('Field','sigPix_r','nmgy/arcsec^2','','','Sigma of pixel values in r-band frame (clipped)','0');
INSERT DBColumns VALUES('Field','sigPix_i','nmgy/arcsec^2','','','Sigma of pixel values in i-band frame (clipped)','0');
INSERT DBColumns VALUES('Field','sigPix_z','nmgy/arcsec^2','','','Sigma of pixel values in z-band frame (clipped)','0');
INSERT DBColumns VALUES('Field','devApCorrection_u','','','','deV aperture correction (u-band)','0');
INSERT DBColumns VALUES('Field','devApCorrection_g','','','','deV aperture correction (g-band)','0');
INSERT DBColumns VALUES('Field','devApCorrection_r','','','','deV aperture correction (r-band)','0');
INSERT DBColumns VALUES('Field','devApCorrection_i','','','','deV aperture correction (i-band)','0');
INSERT DBColumns VALUES('Field','devApCorrection_z','','','','deV aperture correction (z-band)','0');
INSERT DBColumns VALUES('Field','devApCorrectionErr_u','','','','Error in deV aperture correction (u-band)','0');
INSERT DBColumns VALUES('Field','devApCorrectionErr_g','','','','Error in deV aperture correction (g-band)','0');
INSERT DBColumns VALUES('Field','devApCorrectionErr_r','','','','Error in deV aperture correction (r-band)','0');
INSERT DBColumns VALUES('Field','devApCorrectionErr_i','','','','Error in deV aperture correction (i-band)','0');
INSERT DBColumns VALUES('Field','devApCorrectionErr_z','','','','Error in deV aperture correction (z-band)','0');
INSERT DBColumns VALUES('Field','expApCorrection_u','','','','exponential aperture correction (u-band)','0');
INSERT DBColumns VALUES('Field','expApCorrection_g','','','','exponential aperture correction (g-band)','0');
INSERT DBColumns VALUES('Field','expApCorrection_r','','','','exponential aperture correction (r-band)','0');
INSERT DBColumns VALUES('Field','expApCorrection_i','','','','exponential aperture correction (i-band)','0');
INSERT DBColumns VALUES('Field','expApCorrection_z','','','','exponential aperture correction (z-band)','0');
INSERT DBColumns VALUES('Field','expApCorrectionErr_u','','','','Error in exponential aperture correction (u-band)','0');
INSERT DBColumns VALUES('Field','expApCorrectionErr_g','','','','Error in exponential aperture correction (g-band)','0');
INSERT DBColumns VALUES('Field','expApCorrectionErr_r','','','','Error in exponential aperture correction (r-band)','0');
INSERT DBColumns VALUES('Field','expApCorrectionErr_i','','','','Error in exponential aperture correction (i-band)','0');
INSERT DBColumns VALUES('Field','expApCorrectionErr_z','','','','Error in exponential aperture correction (z-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrection_u','','','','model aperture correction, for deV case (u-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrection_g','','','','model aperture correction, for deV case (g-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrection_r','','','','model aperture correction, for deV case (r-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrection_i','','','','model aperture correction, for deV case (i-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrection_z','','','','model aperture correction, for deV case (z-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrectionErr_u','','','','Error in model aperture correction, for deV case (u-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrectionErr_g','','','','Error in model aperture correction, for deV case (g-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrectionErr_r','','','','Error in model aperture correction, for deV case (r-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrectionErr_i','','','','Error in model aperture correction, for deV case (i-band)','0');
INSERT DBColumns VALUES('Field','devModelApCorrectionErr_z','','','','Error in model aperture correction, for deV case (z-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrection_u','','','','model aperture correction, for exponential case (u-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrection_g','','','','model aperture correction, for exponential case (g-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrection_r','','','','model aperture correction, for exponential case (r-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrection_i','','','','model aperture correction, for exponential case (i-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrection_z','','','','model aperture correction, for exponential case (z-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrectionErr_u','','','','Error in model aperture correction, for exponential case (u-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrectionErr_g','','','','Error in model aperture correction, for exponential case (g-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrectionErr_r','','','','Error in model aperture correction, for exponential case (r-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrectionErr_i','','','','Error in model aperture correction, for exponential case (i-band)','0');
INSERT DBColumns VALUES('Field','expModelApCorrectionErr_z','','','','Error in model aperture correction, for exponential case (z-band)','0');
INSERT DBColumns VALUES('Field','medianFiberColor_u','','','','Median fiber magnitude of objects (u-band)','0');
INSERT DBColumns VALUES('Field','medianFiberColor_g','','','','Median fiber magnitude of objects (g-band)','0');
INSERT DBColumns VALUES('Field','medianFiberColor_r','','','','Median fiber magnitude of objects (r-band)','0');
INSERT DBColumns VALUES('Field','medianFiberColor_i','','','','Median fiber magnitude of objects (i-band)','0');
INSERT DBColumns VALUES('Field','medianFiberColor_z','','','','Median fiber magnitude of objects (z-band)','0');
INSERT DBColumns VALUES('Field','medianPsfColor_u','','','','Median PSF magnitude of objects (u-band)','0');
INSERT DBColumns VALUES('Field','medianPsfColor_g','','','','Median PSF magnitude of objects (g-band)','0');
INSERT DBColumns VALUES('Field','medianPsfColor_r','','','','Median PSF magnitude of objects (r-band)','0');
INSERT DBColumns VALUES('Field','medianPsfColor_i','','','','Median PSF magnitude of objects (i-band)','0');
INSERT DBColumns VALUES('Field','medianPsfColor_z','','','','Median PSF magnitude of objects (z-band)','0');
INSERT DBColumns VALUES('Field','q_u','','','','Means Stokes Q parameter in u-band frame','0');
INSERT DBColumns VALUES('Field','q_g','','','','Means Stokes Q parameter in g-band frame','0');
INSERT DBColumns VALUES('Field','q_r','','','','Means Stokes Q parameter in r-band frame','0');
INSERT DBColumns VALUES('Field','q_i','','','','Means Stokes Q parameter in i-band frame','0');
INSERT DBColumns VALUES('Field','q_z','','','','Means Stokes Q parameter in z-band frame','0');
INSERT DBColumns VALUES('Field','u_u','','','','Means Stokes U parameter in u-band frame','0');
INSERT DBColumns VALUES('Field','u_g','','','','Means Stokes U parameter in g-band frame','0');
INSERT DBColumns VALUES('Field','u_r','','','','Means Stokes U parameter in r-band frame','0');
INSERT DBColumns VALUES('Field','u_i','','','','Means Stokes U parameter in i-band frame','0');
INSERT DBColumns VALUES('Field','u_z','','','','Means Stokes U parameter in z-band frame','0');
INSERT DBColumns VALUES('Field','pspStatus','','','','Maximum value of status over all 5 filters','0');
INSERT DBColumns VALUES('Field','sky_u','nmgy/arcsec^2','','','PSP estimate of sky in u-band','0');
INSERT DBColumns VALUES('Field','sky_g','nmgy/arcsec^2','','','PSP estimate of sky in g-band','0');
INSERT DBColumns VALUES('Field','sky_r','nmgy/arcsec^2','','','PSP estimate of sky in r-band','0');
INSERT DBColumns VALUES('Field','sky_i','nmgy/arcsec^2','','','PSP estimate of sky in i-band','0');
INSERT DBColumns VALUES('Field','sky_z','nmgy/arcsec^2','','','PSP estimate of sky in z-band','0');
INSERT DBColumns VALUES('Field','skySig_u','mag','','','Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5','0');
INSERT DBColumns VALUES('Field','skySig_g','mag','','','Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5','0');
INSERT DBColumns VALUES('Field','skySig_r','mag','','','Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5','0');
INSERT DBColumns VALUES('Field','skySig_i','mag','','','Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5','0');
INSERT DBColumns VALUES('Field','skySig_z','mag','','','Fractional Sigma of Sky Value Distribution, expressed as magnitude. Sky noise = skySig * sky * ln(10)/2.5','0');
INSERT DBColumns VALUES('Field','skyErr_u','nmgy/arcsec^2','','','Error in PSP estimate of sky in u-band','0');
INSERT DBColumns VALUES('Field','skyErr_g','nmgy/arcsec^2','','','Error in PSP estimate of sky in g-band','0');
INSERT DBColumns VALUES('Field','skyErr_r','nmgy/arcsec^2','','','Error in PSP estimate of sky in r-band','0');
INSERT DBColumns VALUES('Field','skyErr_i','nmgy/arcsec^2','','','Error in PSP estimate of sky in i-band','0');
INSERT DBColumns VALUES('Field','skyErr_z','nmgy/arcsec^2','','','Error in PSP estimate of sky in z-band','0');
INSERT DBColumns VALUES('Field','skySlope_u','nmgy/arcsec^2/field','','','Rate of change in sky value along columns (u-band)','0');
INSERT DBColumns VALUES('Field','skySlope_g','nmgy/arcsec^2/field','','','Rate of change in sky value along columns (g-band)','0');
INSERT DBColumns VALUES('Field','skySlope_r','nmgy/arcsec^2/field','','','Rate of change in sky value along columns (r-band)','0');
INSERT DBColumns VALUES('Field','skySlope_i','nmgy/arcsec^2/field','','','Rate of change in sky value along columns (i-band)','0');
INSERT DBColumns VALUES('Field','skySlope_z','nmgy/arcsec^2/field','','','Rate of change in sky value along columns (z-band)','0');
INSERT DBColumns VALUES('Field','lbias_u','ADUs','','','Left-hand amplifier bias level (u-band)  XXX make sure to apply DSCALE, counts or ADU?','0');
INSERT DBColumns VALUES('Field','lbias_g','ADUs','','','Left-hand amplifier bias level (g-band)','0');
INSERT DBColumns VALUES('Field','lbias_r','ADUs','','','Left-hand amplifier bias level (r-band)','0');
INSERT DBColumns VALUES('Field','lbias_i','ADUs','','','Left-hand amplifier bias level (i-band)','0');
INSERT DBColumns VALUES('Field','lbias_z','ADUs','','','Left-hand amplifier bias level (z-band)','0');
INSERT DBColumns VALUES('Field','rbias_u','ADUs','','','Right-hand amplifier bias level (u-band)','0');
INSERT DBColumns VALUES('Field','rbias_g','ADUs','','','Right-hand amplifier bias level (g-band)','0');
INSERT DBColumns VALUES('Field','rbias_r','ADUs','','','Right-hand amplifier bias level (r-band)','0');
INSERT DBColumns VALUES('Field','rbias_i','ADUs','','','Right-hand amplifier bias level (i-band)','0');
INSERT DBColumns VALUES('Field','rbias_z','ADUs','','','Right-hand amplifier bias level (z-band)','0');
INSERT DBColumns VALUES('Field','nProf_u','','','','Number of bins in PSF profile (in fieldProfile table)','0');
INSERT DBColumns VALUES('Field','nProf_g','','','','Number of bins in PSF profile (in fieldProfile table)','0');
INSERT DBColumns VALUES('Field','nProf_r','','','','Number of bins in PSF profile (in fieldProfile table)','0');
INSERT DBColumns VALUES('Field','nProf_i','','','','Number of bins in PSF profile (in fieldProfile table)','0');
INSERT DBColumns VALUES('Field','nProf_z','','','','Number of bins in PSF profile (in fieldProfile table)','0');
INSERT DBColumns VALUES('Field','psfNStar_u','','','','Number of stars used in PSF measurement (u-band)','0');
INSERT DBColumns VALUES('Field','psfNStar_g','','','','Number of stars used in PSF measurement (g-band)','0');
INSERT DBColumns VALUES('Field','psfNStar_r','','','','Number of stars used in PSF measurement (r-band)','0');
INSERT DBColumns VALUES('Field','psfNStar_i','','','','Number of stars used in PSF measurement (i-band)','0');
INSERT DBColumns VALUES('Field','psfNStar_z','','','','Number of stars used in PSF measurement (z-band)','0');
INSERT DBColumns VALUES('Field','psfApCorrectionErr_u','mag','','','Photometric uncertainty due to imperfect PSF model (u-band)','0');
INSERT DBColumns VALUES('Field','psfApCorrectionErr_g','mag','','','Photometric uncertainty due to imperfect PSF model (g-band)','0');
INSERT DBColumns VALUES('Field','psfApCorrectionErr_r','mag','','','Photometric uncertainty due to imperfect PSF model (r-band)','0');
INSERT DBColumns VALUES('Field','psfApCorrectionErr_i','mag','','','Photometric uncertainty due to imperfect PSF model (i-band)','0');
INSERT DBColumns VALUES('Field','psfApCorrectionErr_z','mag','','','Photometric uncertainty due to imperfect PSF model (z-band)','0');
INSERT DBColumns VALUES('Field','psfSigma1_u','arcsec','','','Inner gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma1_g','arcsec','','','Inner gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma1_r','arcsec','','','Inner gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma1_i','arcsec','','','Inner gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma1_z','arcsec','','','Inner gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma2_u','arcsec','','','Outer gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma2_g','arcsec','','','Outer gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma2_r','arcsec','','','Outer gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma2_i','arcsec','','','Outer gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfSigma2_z','arcsec','','','Outer gaussian sigma for composite fit','0');
INSERT DBColumns VALUES('Field','psfB_u','','','','Ratio of inner to outer components at origin (composite fit)','0');
INSERT DBColumns VALUES('Field','psfB_g','','','','Ratio of inner to outer components at origin (composite fit)','0');
INSERT DBColumns VALUES('Field','psfB_r','','','','Ratio of inner to outer components at origin (composite fit)','0');
INSERT DBColumns VALUES('Field','psfB_i','','','','Ratio of inner to outer components at origin (composite fit)','0');
INSERT DBColumns VALUES('Field','psfB_z','','','','Ratio of inner to outer components at origin (composite fit)','0');
INSERT DBColumns VALUES('Field','psfP0_u','','','','Value of power law at origin in composite fit  XXX','0');
INSERT DBColumns VALUES('Field','psfP0_g','','','','Value of power law at origin in composite fit  XXX','0');
INSERT DBColumns VALUES('Field','psfP0_r','','','','Value of power law at origin in composite fit  XXX','0');
INSERT DBColumns VALUES('Field','psfP0_i','','','','Value of power law at origin in composite fit  XXX','0');
INSERT DBColumns VALUES('Field','psfP0_z','','','','Value of power law at origin in composite fit  XXX','0');
INSERT DBColumns VALUES('Field','psfBeta_u','','','','Slope of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfBeta_g','','','','Slope of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfBeta_r','','','','Slope of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfBeta_i','','','','Slope of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfBeta_z','','','','Slope of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfSigmaP_u','','','','Width of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfSigmaP_g','','','','Width of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfSigmaP_r','','','','Width of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfSigmaP_i','','','','Width of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfSigmaP_z','','','','Width of power law in composite fit','0');
INSERT DBColumns VALUES('Field','psfWidth_u','arcsec','','','Effective PSF width from 2-Gaussian fit (u-band)','0');
INSERT DBColumns VALUES('Field','psfWidth_g','arcsec','','','Effective PSF width from 2-Gaussian fit (g-band)','0');
INSERT DBColumns VALUES('Field','psfWidth_r','arcsec','','','Effective PSF width from 2-Gaussian fit (r-band)','0');
INSERT DBColumns VALUES('Field','psfWidth_i','arcsec','','','Effective PSF width from 2-Gaussian fit (i-band)','0');
INSERT DBColumns VALUES('Field','psfWidth_z','arcsec','','','Effective PSF width from 2-Gaussian fit (z-band)','0');
INSERT DBColumns VALUES('Field','psfPsfCounts_u','counts','','','Flux via fit to PSF (u-band) XXX','0');
INSERT DBColumns VALUES('Field','psfPsfCounts_g','counts','','','Flux via fit to PSF (g-band) XXX','0');
INSERT DBColumns VALUES('Field','psfPsfCounts_r','counts','','','Flux via fit to PSF (r-band) XXX','0');
INSERT DBColumns VALUES('Field','psfPsfCounts_i','counts','','','Flux via fit to PSF (i-band) XXX','0');
INSERT DBColumns VALUES('Field','psfPsfCounts_z','counts','','','Flux via fit to PSF (z-band) XXX','0');
INSERT DBColumns VALUES('Field','psf2GSigma1_u','arcsec','','','Sigma of inner gaussian in 2-Gaussian fit (u-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma1_g','arcsec','','','Sigma of inner gaussian in 2-Gaussian fit (g-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma1_r','arcsec','','','Sigma of inner gaussian in 2-Gaussian fit (r-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma1_i','arcsec','','','Sigma of inner gaussian in 2-Gaussian fit (i-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma1_z','arcsec','','','Sigma of inner gaussian in 2-Gaussian fit (z-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma2_u','arcsec','','','Sigma of outer gaussian in 2-Gaussian fit (u-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma2_g','arcsec','','','Sigma of outer gaussian in 2-Gaussian fit (g-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma2_r','arcsec','','','Sigma of outer gaussian in 2-Gaussian fit (r-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma2_i','arcsec','','','Sigma of outer gaussian in 2-Gaussian fit (i-band)','0');
INSERT DBColumns VALUES('Field','psf2GSigma2_z','arcsec','','','Sigma of outer gaussian in 2-Gaussian fit (z-band)','0');
INSERT DBColumns VALUES('Field','psf2GB_u','','','','Ratio of inner to outer components at origin (2-Gaussian fit)','0');
INSERT DBColumns VALUES('Field','psf2GB_g','','','','Ratio of inner to outer components at origin (2-Gaussian fit)','0');
INSERT DBColumns VALUES('Field','psf2GB_r','','','','Ratio of inner to outer components at origin (2-Gaussian fit)','0');
INSERT DBColumns VALUES('Field','psf2GB_i','','','','Ratio of inner to outer components at origin (2-Gaussian fit)','0');
INSERT DBColumns VALUES('Field','psf2GB_z','','','','Ratio of inner to outer components at origin (2-Gaussian fit)','0');
INSERT DBColumns VALUES('Field','psfCounts_u','counts','','','PSF counts XXX','0');
INSERT DBColumns VALUES('Field','psfCounts_g','counts','','','PSF counts XXX','0');
INSERT DBColumns VALUES('Field','psfCounts_r','counts','','','PSF counts XXX','0');
INSERT DBColumns VALUES('Field','psfCounts_i','counts','','','PSF counts XXX','0');
INSERT DBColumns VALUES('Field','psfCounts_z','counts','','','PSF counts XXX','0');
INSERT DBColumns VALUES('Field','gain_u','electrons/DN','','','Gain averaged over amplifiers','0');
INSERT DBColumns VALUES('Field','gain_g','electrons/DN','','','Gain averaged over amplifiers','0');
INSERT DBColumns VALUES('Field','gain_r','electrons/DN','','','Gain averaged over amplifiers','0');
INSERT DBColumns VALUES('Field','gain_i','electrons/DN','','','Gain averaged over amplifiers','0');
INSERT DBColumns VALUES('Field','gain_z','electrons/DN','','','Gain averaged over amplifiers','0');
INSERT DBColumns VALUES('Field','darkVariance_u','','','','Dark variance','0');
INSERT DBColumns VALUES('Field','darkVariance_g','','','','Dark variance','0');
INSERT DBColumns VALUES('Field','darkVariance_r','','','','Dark variance','0');
INSERT DBColumns VALUES('Field','darkVariance_i','','','','Dark variance','0');
INSERT DBColumns VALUES('Field','darkVariance_z','','','','Dark variance','0');
INSERT DBColumns VALUES('Field','score','','','','Quality of field (0-1)','0');
INSERT DBColumns VALUES('Field','aterm_u','nmgy/count','','','nanomaggies per count due to instrument','0');
INSERT DBColumns VALUES('Field','aterm_g','nmgy/count','','','nanomaggies per count due to instrument','0');
INSERT DBColumns VALUES('Field','aterm_r','nmgy/count','','','nanomaggies per count due to instrument','0');
INSERT DBColumns VALUES('Field','aterm_i','nmgy/count','','','nanomaggies per count due to instrument','0');
INSERT DBColumns VALUES('Field','aterm_z','nmgy/count','','','nanomaggies per count due to instrument','0');
INSERT DBColumns VALUES('Field','kterm_u','','','','atmospheric k-term at reference time in calibration','0');
INSERT DBColumns VALUES('Field','kterm_g','','','','atmospheric k-term at reference time in calibration','0');
INSERT DBColumns VALUES('Field','kterm_r','','','','atmospheric k-term at reference time in calibration','0');
INSERT DBColumns VALUES('Field','kterm_i','','','','atmospheric k-term at reference time in calibration','0');
INSERT DBColumns VALUES('Field','kterm_z','','','','atmospheric k-term at reference time in calibration','0');
INSERT DBColumns VALUES('Field','kdot_u','1/second','','','linear time variation of atmospheric k-term','0');
INSERT DBColumns VALUES('Field','kdot_g','1/second','','','linear time variation of atmospheric k-term','0');
INSERT DBColumns VALUES('Field','kdot_r','1/second','','','linear time variation of atmospheric k-term','0');
INSERT DBColumns VALUES('Field','kdot_i','1/second','','','linear time variation of atmospheric k-term','0');
INSERT DBColumns VALUES('Field','kdot_z','1/second','','','linear time variation of atmospheric k-term','0');
INSERT DBColumns VALUES('Field','reftai_u','second','','','reference TAI used for k-term','0');
INSERT DBColumns VALUES('Field','reftai_g','second','','','reference TAI used for k-term','0');
INSERT DBColumns VALUES('Field','reftai_r','second','','','reference TAI used for k-term','0');
INSERT DBColumns VALUES('Field','reftai_i','second','','','reference TAI used for k-term','0');
INSERT DBColumns VALUES('Field','reftai_z','second','','','reference TAI used for k-term','0');
INSERT DBColumns VALUES('Field','tai_u','second','','','TAI used for k-term','0');
INSERT DBColumns VALUES('Field','tai_g','second','','','TAI used for k-term','0');
INSERT DBColumns VALUES('Field','tai_r','second','','','TAI used for k-term','0');
INSERT DBColumns VALUES('Field','tai_i','second','','','TAI used for k-term','0');
INSERT DBColumns VALUES('Field','tai_z','second','','','TAI used for k-term','0');
INSERT DBColumns VALUES('Field','nStarsOffset_u','','','','number of stars used for fieldOffset determination','0');
INSERT DBColumns VALUES('Field','nStarsOffset_g','','','','number of stars used for fieldOffset determination','0');
INSERT DBColumns VALUES('Field','nStarsOffset_r','','','','number of stars used for fieldOffset determination','0');
INSERT DBColumns VALUES('Field','nStarsOffset_i','','','','number of stars used for fieldOffset determination','0');
INSERT DBColumns VALUES('Field','nStarsOffset_z','','','','number of stars used for fieldOffset determination','0');
INSERT DBColumns VALUES('Field','fieldOffset_u','mag','','','offset of field from initial calibration (final minus initial magnitudes)','0');
INSERT DBColumns VALUES('Field','fieldOffset_g','mag','','','offset of field from initial calibration (final minus initial magnitudes)','0');
INSERT DBColumns VALUES('Field','fieldOffset_r','mag','','','offset of field from initial calibration (final minus initial magnitudes)','0');
INSERT DBColumns VALUES('Field','fieldOffset_i','mag','','','offset of field from initial calibration (final minus initial magnitudes)','0');
INSERT DBColumns VALUES('Field','fieldOffset_z','mag','','','offset of field from initial calibration (final minus initial magnitudes)','0');
INSERT DBColumns VALUES('Field','calibStatus_u','','','','calibration status bitmask','0');
INSERT DBColumns VALUES('Field','calibStatus_g','','','','calibration status bitmask','0');
INSERT DBColumns VALUES('Field','calibStatus_r','','','','calibration status bitmask','0');
INSERT DBColumns VALUES('Field','calibStatus_i','','','','calibration status bitmask','0');
INSERT DBColumns VALUES('Field','calibStatus_z','','','','calibration status bitmask','0');
INSERT DBColumns VALUES('Field','imageStatus_u','','','','image status bitmask','0');
INSERT DBColumns VALUES('Field','imageStatus_g','','','','image status bitmask','0');
INSERT DBColumns VALUES('Field','imageStatus_r','','','','image status bitmask','0');
INSERT DBColumns VALUES('Field','imageStatus_i','','','','image status bitmask','0');
INSERT DBColumns VALUES('Field','imageStatus_z','','','','image status bitmask','0');
INSERT DBColumns VALUES('Field','nMgyPerCount_u','nmgy/count','','','nanomaggies per count in u-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCount_g','nmgy/count','','','nanomaggies per count in g-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCount_r','nmgy/count','','','nanomaggies per count in r-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCount_i','nmgy/count','','','nanomaggies per count in i-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCount_z','nmgy/count','','','nanomaggies per count in z-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCountIvar_u','(nmgy/count)^{-2}','','','Inverse variance of nanomaggies per count in u-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCountIvar_g','(nmgy/count)^{-2}','','','Inverse variance of nanomaggies per count in g-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCountIvar_r','(nmgy/count)^{-2}','','','Inverse variance of nanomaggies per count in r-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCountIvar_i','(nmgy/count)^{-2}','','','Inverse variance of nanomaggies per count in i-band','0');
INSERT DBColumns VALUES('Field','nMgyPerCountIvar_z','(nmgy/count)^{-2}','','','Inverse variance of nanomaggies per count in z-band','0');
INSERT DBColumns VALUES('Field','ifield','','','','field id used by resolve pipeline','0');
INSERT DBColumns VALUES('Field','muStart','deg','','','start of field in stripe coords (parallel to scan direction)','0');
INSERT DBColumns VALUES('Field','muEnd','deg','','','end of field in stripe coords (parallel to scan direction)','0');
INSERT DBColumns VALUES('Field','nuStart','deg','','','start of field in stripe coords (perpendicular to scan direction)','0');
INSERT DBColumns VALUES('Field','nuEnd','deg','','','end of field in stripe coords (perpendicular to scan direction)','0');
INSERT DBColumns VALUES('Field','ifindx','','','','first entry for this field in the "findx" table matching fields and balkans','0');
INSERT DBColumns VALUES('Field','nBalkans','','','','number of balkans contained in this field (and corresponding number of entries in the "findx" table)','0');
INSERT DBColumns VALUES('Field','loadVersion','','','','Load Version','0');
INSERT DBColumns VALUES('PhotoObjAll','objID','','','','Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].','0');
INSERT DBColumns VALUES('PhotoObjAll','skyVersion','','','','Layer of catalog (currently only one layer, 0; 0-15 available)','0');
INSERT DBColumns VALUES('PhotoObjAll','run','','','','Run number','0');
INSERT DBColumns VALUES('PhotoObjAll','rerun','','','','Rerun number','0');
INSERT DBColumns VALUES('PhotoObjAll','camcol','','','','Camera column','0');
INSERT DBColumns VALUES('PhotoObjAll','field','','','','Field number','0');
INSERT DBColumns VALUES('PhotoObjAll','obj','','','','The object id within a field. Usually changes between reruns of the same field','0');
INSERT DBColumns VALUES('PhotoObjAll','mode','','','','1: primary, 2: secondary, 3: other','0');
INSERT DBColumns VALUES('PhotoObjAll','nChild','','','','Number of children if this is a composite object that has been deblended. BRIGHT (in a flags sense) objects also have nchild == 1, the non-BRIGHT sibling.','0');
INSERT DBColumns VALUES('PhotoObjAll','type','','','','Type classification of the object (star, galaxy, cosmic ray, etc.)','0');
INSERT DBColumns VALUES('PhotoObjAll','clean','','','','Clean photometry flag (1=clean, 0=unclean).','0');
INSERT DBColumns VALUES('PhotoObjAll','probPSF','','','','Probability that the object is a star. Currently 0 if type == 3 (galaxy), 1 if type == 6 (star).','0');
INSERT DBColumns VALUES('PhotoObjAll','insideMask','','','','Flag to indicate whether object is inside a mask and why','0');
INSERT DBColumns VALUES('PhotoObjAll','flags','','','','Photo Object Attribute Flags','0');
INSERT DBColumns VALUES('PhotoObjAll','rowc','pix','','','Row center position (r-band coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','rowcErr','pix','','','Row center position error (r-band coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','colc','pix','','','Column center position (r-band coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','colcErr','pix','','','Column center position error (r-band coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','rowv','deg/day','','','Row-component of object''s velocity','0');
INSERT DBColumns VALUES('PhotoObjAll','rowvErr','deg/day','','','Row-component of object''s velocity error','0');
INSERT DBColumns VALUES('PhotoObjAll','colv','deg/day','','','Column-component of object''s velocity','0');
INSERT DBColumns VALUES('PhotoObjAll','colvErr','deg/day','','','Column-component of object''s velocity error','0');
INSERT DBColumns VALUES('PhotoObjAll','rowc_u','pix','','','Row center, u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowc_g','pix','','','Row center, g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowc_r','pix','','','Row center, r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowc_i','pix','','','Row center, i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowc_z','pix','','','Row center, z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowcErr_u','pix','','','ERROR Row center error, u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowcErr_g','pix','','','ERROR Row center error, g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowcErr_r','pix','','','ERROR Row center error, r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowcErr_i','pix','','','ERROR Row center error, i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','rowcErr_z','pix','','','ERROR Row center error, z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colc_u','pix','','','Column center, u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colc_g','pix','','','Column center, g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colc_r','pix','','','Column center, r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colc_i','pix','','','Column center, i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colc_z','pix','','','Column center, z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colcErr_u','pix','','','Column center error, u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colcErr_g','pix','','','Column center error, g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colcErr_r','pix','','','Column center error, r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colcErr_i','pix','','','Column center error, i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','colcErr_z','pix','','','Column center error, z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','sky_u','nanomaggies/arcsec^2','','','Sky flux at the center of object (allowing for siblings if blended).','0');
INSERT DBColumns VALUES('PhotoObjAll','sky_g','nanomaggies/arcsec^2','','','Sky flux at the center of object (allowing for siblings if blended).','0');
INSERT DBColumns VALUES('PhotoObjAll','sky_r','nanomaggies/arcsec^2','','','Sky flux at the center of object (allowing for siblings if blended).','0');
INSERT DBColumns VALUES('PhotoObjAll','sky_i','nanomaggies/arcsec^2','','','Sky flux at the center of object (allowing for siblings if blended).','0');
INSERT DBColumns VALUES('PhotoObjAll','sky_z','nanomaggies/arcsec^2','','','Sky flux at the center of object (allowing for siblings if blended).','0');
INSERT DBColumns VALUES('PhotoObjAll','skyIvar_u','nanomaggies/arcsec^2','','','Sky flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','skyIvar_g','nanomaggies/arcsec^2','','','Sky flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','skyIvar_r','nanomaggies/arcsec^2','','','Sky flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','skyIvar_i','nanomaggies/arcsec^2','','','Sky flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','skyIvar_z','nanomaggies/arcsec^2','','','Sky flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMag_u','mag','','','PSF magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMag_g','mag','','','PSF magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMag_r','mag','','','PSF magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMag_i','mag','','','PSF magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMag_z','mag','','','PSF magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMagErr_u','mag','','','PSF magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMagErr_g','mag','','','PSF magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMagErr_r','mag','','','PSF magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMagErr_i','mag','','','PSF magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','psfMagErr_z','mag','','','PSF magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMag_u','mag','','','Magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMag_g','mag','','','Magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMag_r','mag','','','Magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMag_i','mag','','','Magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMag_z','mag','','','Magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMagErr_u','mag','','','Error in magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMagErr_g','mag','','','Error in magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMagErr_r','mag','','','Error in magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMagErr_i','mag','','','Error in magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberMagErr_z','mag','','','Error in magnitude in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Mag_u','mag','','','Magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Mag_g','mag','','','Magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Mag_r','mag','','','Magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Mag_i','mag','','','Magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Mag_z','mag','','','Magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2MagErr_u','mag','','','Error in magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2MagErr_g','mag','','','Error in magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2MagErr_r','mag','','','Error in magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2MagErr_i','mag','','','Error in magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2MagErr_z','mag','','','Error in magnitude in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMag_u','mag','','','Petrosian magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMag_g','mag','','','Petrosian magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMag_r','mag','','','Petrosian magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMag_i','mag','','','Petrosian magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMag_z','mag','','','Petrosian magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMagErr_u','mag','','','Petrosian magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMagErr_g','mag','','','Petrosian magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMagErr_r','mag','','','Petrosian magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMagErr_i','mag','','','Petrosian magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroMagErr_z','mag','','','Petrosian magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFlux_u','nanomaggies','','','PSF flux','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFlux_g','nanomaggies','','','PSF flux','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFlux_r','nanomaggies','','','PSF flux','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFlux_i','nanomaggies','','','PSF flux','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFlux_z','nanomaggies','','','PSF flux','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFluxIvar_u','nanomaggies^{-2}','','','PSF flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFluxIvar_g','nanomaggies^{-2}','','','PSF flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFluxIvar_r','nanomaggies^{-2}','','','PSF flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFluxIvar_i','nanomaggies^{-2}','','','PSF flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','psfFluxIvar_z','nanomaggies^{-2}','','','PSF flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFlux_u','nanomaggies','','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFlux_g','nanomaggies','','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFlux_r','nanomaggies','','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFlux_i','nanomaggies','','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFlux_z','nanomaggies','','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFluxIvar_u','nanomaggies^{-2}','','','Inverse variance in flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFluxIvar_g','nanomaggies^{-2}','','','Inverse variance in flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFluxIvar_r','nanomaggies^{-2}','','','Inverse variance in flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFluxIvar_i','nanomaggies^{-2}','','','Inverse variance in flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiberFluxIvar_z','nanomaggies^{-2}','','','Inverse variance in flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Flux_u','nanomaggies','','','Flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Flux_g','nanomaggies','','','Flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Flux_r','nanomaggies','','','Flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Flux_i','nanomaggies','','','Flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2Flux_z','nanomaggies','','','Flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2FluxIvar_u','nanomaggies^{-2}','','','Inverse variance in flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2FluxIvar_g','nanomaggies^{-2}','','','Inverse variance in flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2FluxIvar_r','nanomaggies^{-2}','','','Inverse variance in flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2FluxIvar_i','nanomaggies^{-2}','','','Inverse variance in flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','fiber2FluxIvar_z','nanomaggies^{-2}','','','Inverse variance in flux in 2 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFlux_u','nanomaggies','','','Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFlux_g','nanomaggies','','','Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFlux_r','nanomaggies','','','Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFlux_i','nanomaggies','','','Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFlux_z','nanomaggies','','','Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFluxIvar_u','nanomaggies^{-2}','','','Petrosian flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFluxIvar_g','nanomaggies^{-2}','','','Petrosian flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFluxIvar_r','nanomaggies^{-2}','','','Petrosian flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFluxIvar_i','nanomaggies^{-2}','','','Petrosian flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','petroFluxIvar_z','nanomaggies^{-2}','','','Petrosian flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRad_u','arcsec','','','Petrosian radius','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRad_g','arcsec','','','Petrosian radius','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRad_r','arcsec','','','Petrosian radius','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRad_i','arcsec','','','Petrosian radius','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRad_z','arcsec','','','Petrosian radius','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRadErr_u','arcsec','','','Petrosian radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRadErr_g','arcsec','','','Petrosian radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRadErr_r','arcsec','','','Petrosian radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRadErr_i','arcsec','','','Petrosian radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroRadErr_z','arcsec','','','Petrosian radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50_u','arcsec','','','Radius containing 50% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50_g','arcsec','','','Radius containing 50% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50_r','arcsec','','','Radius containing 50% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50_i','arcsec','','','Radius containing 50% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50_z','arcsec','','','Radius containing 50% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50Err_u','arcsec','','','Error in radius with 50% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50Err_g','arcsec','','','Error in radius with 50% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50Err_r','arcsec','','','Error in radius with 50% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50Err_i','arcsec','','','Error in radius with 50% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR50Err_z','arcsec','','','Error in radius with 50% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90_u','arcsec','','','Radius containing 90% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90_g','arcsec','','','Radius containing 90% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90_r','arcsec','','','Radius containing 90% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90_i','arcsec','','','Radius containing 90% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90_z','arcsec','','','Radius containing 90% of Petrosian flux','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90Err_u','arcsec','','','Error in radius with 90% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90Err_g','arcsec','','','Error in radius with 90% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90Err_r','arcsec','','','Error in radius with 90% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90Err_i','arcsec','','','Error in radius with 90% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','petroR90Err_z','arcsec','','','Error in radius with 90% of Petrosian flux error','0');
INSERT DBColumns VALUES('PhotoObjAll','q_u','','','','Stokes Q parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','q_g','','','','Stokes Q parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','q_r','','','','Stokes Q parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','q_i','','','','Stokes Q parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','q_z','','','','Stokes Q parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','qErr_u','','','','Stokes Q parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','qErr_g','','','','Stokes Q parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','qErr_r','','','','Stokes Q parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','qErr_i','','','','Stokes Q parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','qErr_z','','','','Stokes Q parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','u_u','','','','Stokes U parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','u_g','','','','Stokes U parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','u_r','','','','Stokes U parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','u_i','','','','Stokes U parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','u_z','','','','Stokes U parameter','0');
INSERT DBColumns VALUES('PhotoObjAll','uErr_u','','','','Stokes U parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','uErr_g','','','','Stokes U parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','uErr_r','','','','Stokes U parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','uErr_i','','','','Stokes U parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','uErr_z','','','','Stokes U parameter error','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1_u','','','','Adaptive E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1_g','','','','Adaptive E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1_r','','','','Adaptive E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1_i','','','','Adaptive E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1_z','','','','Adaptive E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2_u','','','','Adaptive E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2_g','','','','Adaptive E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2_r','','','','Adaptive E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2_i','','','','Adaptive E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2_z','','','','Adaptive E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E1Err_u','','','','Covariance in E1/E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E1Err_g','','','','Covariance in E1/E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E1Err_r','','','','Covariance in E1/E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E1Err_i','','','','Covariance in E1/E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E1Err_z','','','','Covariance in E1/E1 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E2Err_u','','','','Covariance in E1/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E2Err_g','','','','Covariance in E1/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E2Err_r','','','','Covariance in E1/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E2Err_i','','','','Covariance in E1/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1E2Err_z','','','','Covariance in E1/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2E2Err_u','','','','Covariance in E2/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2E2Err_g','','','','Covariance in E2/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2E2Err_r','','','','Covariance in E2/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2E2Err_i','','','','Covariance in E2/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2E2Err_z','','','','Covariance in E2/E2 shape measure (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCc_u','','','','Adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCc_g','','','','Adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCc_r','','','','Adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCc_i','','','','Adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCc_z','','','','Adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcErr_u','','','','Error in adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcErr_g','','','','Error in adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcErr_r','','','','Error in adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcErr_i','','','','Error in adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcErr_z','','','','Error in adaptive ( + ) (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4_u','','','','Adaptive fourth moment of object (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4_g','','','','Adaptive fourth moment of object (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4_r','','','','Adaptive fourth moment of object (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4_i','','','','Adaptive fourth moment of object (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4_z','','','','Adaptive fourth moment of object (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1PSF_u','','','','Adaptive E1 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1PSF_g','','','','Adaptive E1 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1PSF_r','','','','Adaptive E1 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1PSF_i','','','','Adaptive E1 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE1PSF_z','','','','Adaptive E1 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2PSF_u','','','','Adaptive E2 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2PSF_g','','','','Adaptive E2 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2PSF_r','','','','Adaptive E2 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2PSF_i','','','','Adaptive E2 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mE2PSF_z','','','','Adaptive E2 for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcPSF_u','','','','Adaptive ( + ) for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcPSF_g','','','','Adaptive ( + ) for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcPSF_r','','','','Adaptive ( + ) for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcPSF_i','','','','Adaptive ( + ) for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mRrCcPSF_z','','','','Adaptive ( + ) for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4PSF_u','','','','Adaptive fourth moment for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4PSF_g','','','','Adaptive fourth moment for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4PSF_r','','','','Adaptive fourth moment for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4PSF_i','','','','Adaptive fourth moment for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','mCr4PSF_z','','','','Adaptive fourth moment for PSF (pixel coordinates)','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRad_u','arcsec','','','de Vaucouleurs fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRad_g','arcsec','','','de Vaucouleurs fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRad_r','arcsec','','','de Vaucouleurs fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRad_i','arcsec','','','de Vaucouleurs fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRad_z','arcsec','','','de Vaucouleurs fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRadErr_u','arcsec','','','Error in de Vaucouleurs fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRadErr_g','arcsec','','','Error in de Vaucouleurs fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRadErr_r','arcsec','','','Error in de Vaucouleurs fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRadErr_i','arcsec','','','Error in de Vaucouleurs fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVRadErr_z','arcsec','','','Error in de Vaucouleurs fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVAB_u','','','','de Vaucouleurs fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','deVAB_g','','','','de Vaucouleurs fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','deVAB_r','','','','de Vaucouleurs fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','deVAB_i','','','','de Vaucouleurs fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','deVAB_z','','','','de Vaucouleurs fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','deVABErr_u','','','','de Vaucouleurs fit a/b error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVABErr_g','','','','de Vaucouleurs fit a/b error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVABErr_r','','','','de Vaucouleurs fit a/b error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVABErr_i','','','','de Vaucouleurs fit a/b error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVABErr_z','','','','de Vaucouleurs fit a/b error','0');
INSERT DBColumns VALUES('PhotoObjAll','deVPhi_u','de Vaucouleurs fit position angle (+N thru E)','','','deg','0');
INSERT DBColumns VALUES('PhotoObjAll','deVPhi_g','de Vaucouleurs fit position angle (+N thru E)','','','deg','0');
INSERT DBColumns VALUES('PhotoObjAll','deVPhi_r','de Vaucouleurs fit position angle (+N thru E)','','','deg','0');
INSERT DBColumns VALUES('PhotoObjAll','deVPhi_i','de Vaucouleurs fit position angle (+N thru E)','','','deg','0');
INSERT DBColumns VALUES('PhotoObjAll','deVPhi_z','de Vaucouleurs fit position angle (+N thru E)','','','deg','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMag_u','de Vaucouleurs magnitude fit','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMag_g','de Vaucouleurs magnitude fit','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMag_r','de Vaucouleurs magnitude fit','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMag_i','de Vaucouleurs magnitude fit','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMag_z','de Vaucouleurs magnitude fit','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMagErr_u','de Vaucouleurs magnitude fit error','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMagErr_g','de Vaucouleurs magnitude fit error','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMagErr_r','de Vaucouleurs magnitude fit error','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMagErr_i','de Vaucouleurs magnitude fit error','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVMagErr_z','de Vaucouleurs magnitude fit error','','','mag','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFlux_u','de Vaucouleurs magnitude fit','','','nanomaggies','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFlux_g','de Vaucouleurs magnitude fit','','','nanomaggies','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFlux_r','de Vaucouleurs magnitude fit','','','nanomaggies','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFlux_i','de Vaucouleurs magnitude fit','','','nanomaggies','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFlux_z','de Vaucouleurs magnitude fit','','','nanomaggies','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFluxIvar_u','de Vaucouleurs magnitude fit inverse variance','','','nanomaggies^{-2}','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFluxIvar_g','de Vaucouleurs magnitude fit inverse variance','','','nanomaggies^{-2}','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFluxIvar_r','de Vaucouleurs magnitude fit inverse variance','','','nanomaggies^{-2}','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFluxIvar_i','de Vaucouleurs magnitude fit inverse variance','','','nanomaggies^{-2}','0');
INSERT DBColumns VALUES('PhotoObjAll','deVFluxIvar_z','de Vaucouleurs magnitude fit inverse variance','','','nanomaggies^{-2}','0');
INSERT DBColumns VALUES('PhotoObjAll','expRad_u','arcsec','','','Exponential fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','expRad_g','arcsec','','','Exponential fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','expRad_r','arcsec','','','Exponential fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','expRad_i','arcsec','','','Exponential fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','expRad_z','arcsec','','','Exponential fit scale radius','0');
INSERT DBColumns VALUES('PhotoObjAll','expRadErr_u','arcsec','','','Exponential fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','expRadErr_g','arcsec','','','Exponential fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','expRadErr_r','arcsec','','','Exponential fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','expRadErr_i','arcsec','','','Exponential fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','expRadErr_z','arcsec','','','Exponential fit scale radius error','0');
INSERT DBColumns VALUES('PhotoObjAll','expAB_u','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expAB_g','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expAB_r','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expAB_i','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expAB_z','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expABErr_u','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expABErr_g','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expABErr_r','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expABErr_i','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expABErr_z','','','','Exponential fit a/b','0');
INSERT DBColumns VALUES('PhotoObjAll','expPhi_u','deg','','','Exponential fit position angle (+N thru E)','0');
INSERT DBColumns VALUES('PhotoObjAll','expPhi_g','deg','','','Exponential fit position angle (+N thru E)','0');
INSERT DBColumns VALUES('PhotoObjAll','expPhi_r','deg','','','Exponential fit position angle (+N thru E)','0');
INSERT DBColumns VALUES('PhotoObjAll','expPhi_i','deg','','','Exponential fit position angle (+N thru E)','0');
INSERT DBColumns VALUES('PhotoObjAll','expPhi_z','deg','','','Exponential fit position angle (+N thru E)','0');
INSERT DBColumns VALUES('PhotoObjAll','expMag_u','mag','','','Exponential fit magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','expMag_g','mag','','','Exponential fit magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','expMag_r','mag','','','Exponential fit magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','expMag_i','mag','','','Exponential fit magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','expMag_z','mag','','','Exponential fit magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','expMagErr_u','mag','','','Exponential fit magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','expMagErr_g','mag','','','Exponential fit magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','expMagErr_r','mag','','','Exponential fit magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','expMagErr_i','mag','','','Exponential fit magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','expMagErr_z','mag','','','Exponential fit magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMag_u','mag','','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMag_g','mag','','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMag_r','mag','','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMag_i','mag','','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMag_z','mag','','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMagErr_u','mag','','','Error in better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMagErr_g','mag','','','Error in better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMagErr_r','mag','','','Error in better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMagErr_i','mag','','','Error in better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelMagErr_z','mag','','','Error in better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMag_u','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMag_g','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMag_r','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMag_i','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMag_z','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMagErr_u','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMagErr_g','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMagErr_r','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMagErr_i','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelMagErr_z','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('PhotoObjAll','expFlux_u','nanomaggies','','','Exponential fit flux','0');
INSERT DBColumns VALUES('PhotoObjAll','expFlux_g','nanomaggies','','','Exponential fit flux','0');
INSERT DBColumns VALUES('PhotoObjAll','expFlux_r','nanomaggies','','','Exponential fit flux','0');
INSERT DBColumns VALUES('PhotoObjAll','expFlux_i','nanomaggies','','','Exponential fit flux','0');
INSERT DBColumns VALUES('PhotoObjAll','expFlux_z','nanomaggies','','','Exponential fit flux','0');
INSERT DBColumns VALUES('PhotoObjAll','expFluxIvar_u','nanomaggies^{-2}','','','Exponential fit flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','expFluxIvar_g','nanomaggies^{-2}','','','Exponential fit flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','expFluxIvar_r','nanomaggies^{-2}','','','Exponential fit flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','expFluxIvar_i','nanomaggies^{-2}','','','Exponential fit flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','expFluxIvar_z','nanomaggies^{-2}','','','Exponential fit flux inverse variance','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFlux_u','nanomaggies','','','better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFlux_g','nanomaggies','','','better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFlux_r','nanomaggies','','','better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFlux_i','nanomaggies','','','better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFlux_z','nanomaggies','','','better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFluxIvar_u','nanomaggies^{-2}','','','Inverse variance in better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFluxIvar_g','nanomaggies^{-2}','','','Inverse variance in better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFluxIvar_r','nanomaggies^{-2}','','','Inverse variance in better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFluxIvar_i','nanomaggies^{-2}','','','Inverse variance in better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','modelFluxIvar_z','nanomaggies^{-2}','','','Inverse variance in better of DeV/Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFlux_u','nanomaggies','','','better of DeV+Exp flux','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFlux_g','nanomaggies','','','better of DeV+Exp flux','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFlux_r','nanomaggies','','','better of DeV+Exp flux','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFlux_i','nanomaggies','','','better of DeV+Exp flux','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFlux_z','nanomaggies','','','better of DeV+Exp flux','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFluxIvar_u','nanomaggies^{-2}','','','Inverse variance in DeV+Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFluxIvar_g','nanomaggies^{-2}','','','Inverse variance in DeV+Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFluxIvar_r','nanomaggies^{-2}','','','Inverse variance in DeV+Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFluxIvar_i','nanomaggies^{-2}','','','Inverse variance in DeV+Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','cModelFluxIvar_z','nanomaggies^{-2}','','','Inverse variance in DeV+Exp flux fit','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7_u','nanomaggies','','','Aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7_g','nanomaggies','','','Aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7_r','nanomaggies','','','Aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7_i','nanomaggies','','','Aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7_z','nanomaggies','','','Aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7Ivar_u','nanomaggies^{-2}','','','Inverse variance of aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7Ivar_g','nanomaggies^{-2}','','','Inverse variance of aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7Ivar_r','nanomaggies^{-2}','','','Inverse variance of aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7Ivar_i','nanomaggies^{-2}','','','Inverse variance of aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','aperFlux7Ivar_z','nanomaggies^{-2}','','','Inverse variance of aperture flux within 7.3 arcsec','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLStar_u','','','','Star ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLStar_g','','','','Star ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLStar_r','','','','Star ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLStar_i','','','','Star ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLStar_z','','','','Star ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLExp_u','','','','Exponential disk fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLExp_g','','','','Exponential disk fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLExp_r','','','','Exponential disk fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLExp_i','','','','Exponential disk fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLExp_z','','','','Exponential disk fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLDeV_u','','','','de Vaucouleurs fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLDeV_g','','','','de Vaucouleurs fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLDeV_r','','','','de Vaucouleurs fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLDeV_i','','','','de Vaucouleurs fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','lnLDeV_z','','','','de Vaucouleurs fit ln(likelihood)','0');
INSERT DBColumns VALUES('PhotoObjAll','fracDeV_u','','','','Weight of deV component in deV+Exp model','0');
INSERT DBColumns VALUES('PhotoObjAll','fracDeV_g','','','','Weight of deV component in deV+Exp model','0');
INSERT DBColumns VALUES('PhotoObjAll','fracDeV_r','','','','Weight of deV component in deV+Exp model','0');
INSERT DBColumns VALUES('PhotoObjAll','fracDeV_i','','','','Weight of deV component in deV+Exp model','0');
INSERT DBColumns VALUES('PhotoObjAll','fracDeV_z','','','','Weight of deV component in deV+Exp model','0');
INSERT DBColumns VALUES('PhotoObjAll','flags_u','','','','Object detection flags per band','0');
INSERT DBColumns VALUES('PhotoObjAll','flags_g','','','','Object detection flags per band','0');
INSERT DBColumns VALUES('PhotoObjAll','flags_r','','','','Object detection flags per band','0');
INSERT DBColumns VALUES('PhotoObjAll','flags_i','','','','Object detection flags per band','0');
INSERT DBColumns VALUES('PhotoObjAll','flags_z','','','','Object detection flags per band','0');
INSERT DBColumns VALUES('PhotoObjAll','type_u','','','','Object type classification per band','0');
INSERT DBColumns VALUES('PhotoObjAll','type_g','','','','Object type classification per band','0');
INSERT DBColumns VALUES('PhotoObjAll','type_r','','','','Object type classification per band','0');
INSERT DBColumns VALUES('PhotoObjAll','type_i','','','','Object type classification per band','0');
INSERT DBColumns VALUES('PhotoObjAll','type_z','','','','Object type classification per band','0');
INSERT DBColumns VALUES('PhotoObjAll','probPSF_u','','','','Probablity object is a star in each filter.','0');
INSERT DBColumns VALUES('PhotoObjAll','probPSF_g','','','','Probablity object is a star in each filter.','0');
INSERT DBColumns VALUES('PhotoObjAll','probPSF_r','','','','Probablity object is a star in each filter.','0');
INSERT DBColumns VALUES('PhotoObjAll','probPSF_i','','','','Probablity object is a star in each filter.','0');
INSERT DBColumns VALUES('PhotoObjAll','probPSF_z','','','','Probablity object is a star in each filter.','0');
INSERT DBColumns VALUES('PhotoObjAll','ra','deg','','','J2000 Right Ascension (r-band)','0');
INSERT DBColumns VALUES('PhotoObjAll','dec','deg','','','J2000 Declination (r-band)','0');
INSERT DBColumns VALUES('PhotoObjAll','cx','','','','unit vector for ra+dec','0');
INSERT DBColumns VALUES('PhotoObjAll','cy','','','','unit vector for ra+dec','0');
INSERT DBColumns VALUES('PhotoObjAll','cz','','','','unit vector for ra+dec','0');
INSERT DBColumns VALUES('PhotoObjAll','raErr','arcsec','','','Error in RA (* cos(Dec), that is, proper units)','0');
INSERT DBColumns VALUES('PhotoObjAll','decErr','arcsec','','','Error in Dec','0');
INSERT DBColumns VALUES('PhotoObjAll','b','deg','','','Galactic latitude','0');
INSERT DBColumns VALUES('PhotoObjAll','l','deg','','','Galactic longitude','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetRa_u','arcsec','','','filter position RA minus final RA (* cos(Dec), that is, proper units)','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetRa_g','arcsec','','','filter position RA minus final RA (* cos(Dec), that is, proper units)','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetRa_r','arcsec','','','filter position RA minus final RA (* cos(Dec), that is, proper units)','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetRa_i','arcsec','','','filter position RA minus final RA (* cos(Dec), that is, proper units)','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetRa_z','arcsec','','','filter position RA minus final RA (* cos(Dec), that is, proper units)','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetDec_u','arcsec','','','filter position Dec minus final Dec','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetDec_g','arcsec','','','filter position Dec minus final Dec','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetDec_r','arcsec','','','filter position Dec minus final Dec','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetDec_i','arcsec','','','filter position Dec minus final Dec','0');
INSERT DBColumns VALUES('PhotoObjAll','offsetDec_z','arcsec','','','filter position Dec minus final Dec','0');
INSERT DBColumns VALUES('PhotoObjAll','extinction_u','mag','','','Extinction in u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','extinction_g','mag','','','Extinction in g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','extinction_r','mag','','','Extinction in r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','extinction_i','mag','','','Extinction in i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','extinction_z','mag','','','Extinction in z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','psffwhm_u','arcsec','','','FWHM in u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','psffwhm_g','arcsec','','','FWHM in g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','psffwhm_r','arcsec','','','FWHM in r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','psffwhm_i','arcsec','','','FWHM in i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','psffwhm_z','arcsec','','','FWHM in z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','mjd','days','','','Date of observation','0');
INSERT DBColumns VALUES('PhotoObjAll','airmass_u','','','','Airmass at time of observation in u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','airmass_g','','','','Airmass at time of observation in g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','airmass_r','','','','Airmass at time of observation in r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','airmass_i','','','','Airmass at time of observation in i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','airmass_z','','','','Airmass at time of observation in z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','phioffset_u','deg','','','Degrees to add to CCD-aligned angle to convert to E of N','0');
INSERT DBColumns VALUES('PhotoObjAll','phioffset_g','deg','','','Degrees to add to CCD-aligned angle to convert to E of N','0');
INSERT DBColumns VALUES('PhotoObjAll','phioffset_r','deg','','','Degrees to add to CCD-aligned angle to convert to E of N','0');
INSERT DBColumns VALUES('PhotoObjAll','phioffset_i','deg','','','Degrees to add to CCD-aligned angle to convert to E of N','0');
INSERT DBColumns VALUES('PhotoObjAll','phioffset_z','deg','','','Degrees to add to CCD-aligned angle to convert to E of N','0');
INSERT DBColumns VALUES('PhotoObjAll','nProf_u','','','','Number of Profile Bins','0');
INSERT DBColumns VALUES('PhotoObjAll','nProf_g','','','','Number of Profile Bins','0');
INSERT DBColumns VALUES('PhotoObjAll','nProf_r','','','','Number of Profile Bins','0');
INSERT DBColumns VALUES('PhotoObjAll','nProf_i','','','','Number of Profile Bins','0');
INSERT DBColumns VALUES('PhotoObjAll','nProf_z','','','','Number of Profile Bins','0');
INSERT DBColumns VALUES('PhotoObjAll','loadVersion','','','','Load Version','0');
INSERT DBColumns VALUES('PhotoObjAll','htmID','','','','20-deep hierarchical trangular mesh ID of this object','0');
INSERT DBColumns VALUES('PhotoObjAll','fieldID','','','','Link to the field this object is in','0');
INSERT DBColumns VALUES('PhotoObjAll','parentID','','','','Pointer to parent (if object deblended) or BRIGHT detection (if object has one), else 0','0');
INSERT DBColumns VALUES('PhotoObjAll','specObjID','','','','Pointer to the spectrum of object, if exists, else 0','0');
INSERT DBColumns VALUES('PhotoObjAll','u','mag','','','Shorthand alias for modelMag','0');
INSERT DBColumns VALUES('PhotoObjAll','g','mag','','','Shorthand alias for modelMag','0');
INSERT DBColumns VALUES('PhotoObjAll','r','mag','','','Shorthand alias for modelMag','0');
INSERT DBColumns VALUES('PhotoObjAll','i','mag','','','Shorthand alias for modelMag','0');
INSERT DBColumns VALUES('PhotoObjAll','z','mag','','','Shorthand alias for modelMag','0');
INSERT DBColumns VALUES('PhotoObjAll','err_u','mag','','','Error in modelMag alias','0');
INSERT DBColumns VALUES('PhotoObjAll','err_g','mag','','','Error in modelMag alias','0');
INSERT DBColumns VALUES('PhotoObjAll','err_r','mag','','','Error in modelMag alias','0');
INSERT DBColumns VALUES('PhotoObjAll','err_i','mag','','','Error in modelMag alias','0');
INSERT DBColumns VALUES('PhotoObjAll','err_z','mag','','','Error in modelMag alias','0');
INSERT DBColumns VALUES('PhotoObjAll','dered_u','mag','','','Simplified mag, corrected for extinction: modelMag-extinction','0');
INSERT DBColumns VALUES('PhotoObjAll','dered_g','mag','','','Simplified mag, corrected for extinction: modelMag-extinction','0');
INSERT DBColumns VALUES('PhotoObjAll','dered_r','mag','','','Simplified mag, corrected for extinction: modelMag-extinction','0');
INSERT DBColumns VALUES('PhotoObjAll','dered_i','mag','','','Simplified mag, corrected for extinction: modelMag-extinction','0');
INSERT DBColumns VALUES('PhotoObjAll','dered_z','mag','','','Simplified mag, corrected for extinction: modelMag-extinction','0');
INSERT DBColumns VALUES('PhotoObjAll','cloudCam_u','','','','Cloud camera status for observation in u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','cloudCam_g','','','','Cloud camera status for observation in g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','cloudCam_r','','','','Cloud camera status for observation in r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','cloudCam_i','','','','Cloud camera status for observation in i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','cloudCam_z','','','','Cloud camera status for observation in z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','resolveStatus','','','','Resolve status of object','0');
INSERT DBColumns VALUES('PhotoObjAll','thingId','','','','Unique identifier from global resolve','0');
INSERT DBColumns VALUES('PhotoObjAll','balkanId','','','','What balkan object is in from window','0');
INSERT DBColumns VALUES('PhotoObjAll','nObserve','','','','Number of observations of this object','0');
INSERT DBColumns VALUES('PhotoObjAll','nDetect','','','','Number of detections of this object','0');
INSERT DBColumns VALUES('PhotoObjAll','nEdge','','','','Number of observations of this object near an edge','0');
INSERT DBColumns VALUES('PhotoObjAll','score','','','','Quality of field (0-1)','0');
INSERT DBColumns VALUES('PhotoObjAll','calibStatus_u','','','','Calibration status in u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','calibStatus_g','','','','Calibration status in g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','calibStatus_r','','','','Calibration status in r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','calibStatus_i','','','','Calibration status in i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','calibStatus_z','','','','Calibration status in z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','nMgyPerCount_u','nmgy/count','','','nanomaggies per count in u-band','0');
INSERT DBColumns VALUES('PhotoObjAll','nMgyPerCount_g','nmgy/count','','','nanomaggies per count in g-band','0');
INSERT DBColumns VALUES('PhotoObjAll','nMgyPerCount_r','nmgy/count','','','nanomaggies per count in r-band','0');
INSERT DBColumns VALUES('PhotoObjAll','nMgyPerCount_i','nmgy/count','','','nanomaggies per count in i-band','0');
INSERT DBColumns VALUES('PhotoObjAll','nMgyPerCount_z','nmgy/count','','','nanomaggies per count in z-band','0');
INSERT DBColumns VALUES('PhotoObjAll','TAI_u','sec','','','time of observation (TAI) in each filter','0');
INSERT DBColumns VALUES('PhotoObjAll','TAI_g','sec','','','time of observation (TAI) in each filter','0');
INSERT DBColumns VALUES('PhotoObjAll','TAI_r','sec','','','time of observation (TAI) in each filter','0');
INSERT DBColumns VALUES('PhotoObjAll','TAI_i','sec','','','time of observation (TAI) in each filter','0');
INSERT DBColumns VALUES('PhotoObjAll','TAI_z','sec','','','time of observation (TAI) in each filter','0');
INSERT DBColumns VALUES('Photoz','objID','','ID_MAIN','','unique ID pointing to Galaxy table','0');
INSERT DBColumns VALUES('Photoz','z','','REDSHIFT_PHOT','','photometric redshift; estimated by robust fit to nearest neighbors in a reference set','0');
INSERT DBColumns VALUES('Photoz','zErr','','REDSHIFT_PHOT ERROR','','estimated error of the photometric redshift; if zErr=-1000, all the proceeding columns are invalid','0');
INSERT DBColumns VALUES('Photoz','nnCount','','NUMBER','','nearest neighbors after excluding the outliers; maximal value is 100, much smaller value indicates poor estimate','0');
INSERT DBColumns VALUES('Photoz','nnVol','','NUMBER','','gives the color space bounding volume of the nnCount nearest neighbors; large value indicates poor estimate','0');
INSERT DBColumns VALUES('Photoz','nnIsInside','','CODE_MISC','','shows if the object to be estimated is inside of the k-nearest neighbor box; 0 indicates poor estimate','0');
INSERT DBColumns VALUES('Photoz','nnObjID','','ID_IDENTIFIER','','objID of the (first) nearest neighbor','0');
INSERT DBColumns VALUES('Photoz','nnSpecz','','REDSHIFT','','spectroscopic redshift	of the (first) nearest neighbor','0');
INSERT DBColumns VALUES('Photoz','nnFarObjID','','ID_IDENTIFIER','','objID of the farthest neighbor','0');
INSERT DBColumns VALUES('Photoz','nnAvgZ','','REDSHIFT','','average redshift of the nearest neighbors; if singificantly different from z, this might be a better estimate than z','0');
INSERT DBColumns VALUES('Photoz','distMod','','PHOT_DIST-MOD','','the distance modulus for Omega=0.3, Lambda=0.7 cosmology','0');
INSERT DBColumns VALUES('Photoz','lumDist','','PHOT_LUM-DIST','','the luminosity distance for Omega=0.3, Lambda=0.7 cosmology','0');
INSERT DBColumns VALUES('Photoz','chisq','','STAT_LIKELIHOOD','','the chi-square value for the best NNLS template fit','0');
INSERT DBColumns VALUES('Photoz','rnorm','','STAT_MISC','','the residual norm value for the best NNLS template fit','0');
INSERT DBColumns VALUES('Photoz','nTemplates','','NUMBER','','number of templates used in the fitting; if nTemplates=0 all the proceeding columns are invalid and may be filled with value -9999','0');
INSERT DBColumns VALUES('Photoz','synthU','','PHOT_SYNTH-MAG PHOT_SDSS_U','','synthetic u'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('Photoz','synthG','','PHOT_SYNTH-MAG PHOT_SDSS_G','','synthetic g'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('Photoz','synthR','','PHOT_SYNTH-MAG PHOT_SDSS_R','','synthetic r'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('Photoz','synthI','','PHOT_SYNTH-MAG PHOT_SDSS_I','','synthetic i'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('Photoz','synthZ','','PHOT_SYNTH-MAG PHOT_SDSS_Z','','synthetic z'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('Photoz','kcorrU','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('Photoz','kcorrG','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('Photoz','kcorrR','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('Photoz','kcorrI','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('Photoz','kcorrZ','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('Photoz','kcorrU01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('Photoz','kcorrG01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('Photoz','kcorrR01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('Photoz','kcorrI01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('Photoz','kcorrZ01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('Photoz','absMagU','','PHOT_ABS-MAG PHOT_SDSS_U','','rest frame u'' abs magnitude','0');
INSERT DBColumns VALUES('Photoz','absMagG','','PHOT_ABS-MAG PHOT_SDSS_G','','rest frame g'' abs magnitude','0');
INSERT DBColumns VALUES('Photoz','absMagR','','PHOT_ABS-MAG PHOT_SDSS_R','','rest frame r'' abs magnitude','0');
INSERT DBColumns VALUES('Photoz','absMagI','','PHOT_ABS-MAG PHOT_SDSS_I','','rest frame i'' abs magnitude','0');
INSERT DBColumns VALUES('Photoz','absMagZ','','PHOT_ABS-MAG PHOT_SDSS_Z','','rest frame z'' abs magnitude','0');
INSERT DBColumns VALUES('PhotozRF','objID','','ID_MAIN','','unique ID pointing to Galaxy table','0');
INSERT DBColumns VALUES('PhotozRF','z','','REDSHIFT_PHOT','','photometric redshift; estimated by the Random Forest method','0');
INSERT DBColumns VALUES('PhotozRF','zErr','','REDSHIFT_PHOT ERROR','','estimated error of the photometric redshift','0');
INSERT DBColumns VALUES('PhotozRF','distMod','','PHOT_DIST-MOD','','the distance modulus for Omega=0.3, Lambda=0.7 cosmology','0');
INSERT DBColumns VALUES('PhotozRF','lumDist','','PHOT_LUM-DIST','','the luminosity distance for Omega=0.3, Lambda=0.7 cosmology','0');
INSERT DBColumns VALUES('PhotozRF','chisq','','STAT_LIKELIHOOD','','the chi-square value for the best NNLS template fit','0');
INSERT DBColumns VALUES('PhotozRF','rnorm','','STAT_MISC','','the residual norm value for the best NNLS template fit','0');
INSERT DBColumns VALUES('PhotozRF','nTemplates','','NUMBER','','number of templates used in the fitting; if nTemplates=0 all the proceeding columns are invalid and may be filled with value -9999','0');
INSERT DBColumns VALUES('PhotozRF','synthU','','PHOT_SYNTH-MAG PHOT_SDSS_U','','synthetic u'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('PhotozRF','synthG','','PHOT_SYNTH-MAG PHOT_SDSS_G','','synthetic g'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('PhotozRF','synthR','','PHOT_SYNTH-MAG PHOT_SDSS_R','','synthetic r'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('PhotozRF','synthI','','PHOT_SYNTH-MAG PHOT_SDSS_I','','synthetic i'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('PhotozRF','synthZ','','PHOT_SYNTH-MAG PHOT_SDSS_Z','','synthetic z'' magnitude calculated from the fitted templates','0');
INSERT DBColumns VALUES('PhotozRF','kcorrU','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('PhotozRF','kcorrG','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('PhotozRF','kcorrR','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('PhotozRF','kcorrI','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('PhotozRF','kcorrZ','','PHOT_K-CORRECTION','','k correction for z=0','0');
INSERT DBColumns VALUES('PhotozRF','kcorrU01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('PhotozRF','kcorrG01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('PhotozRF','kcorrR01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('PhotozRF','kcorrI01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('PhotozRF','kcorrZ01','','PHOT_K-CORRECTION','','k correction for z=0.1','0');
INSERT DBColumns VALUES('PhotozRF','absMagU','','PHOT_ABS-MAG PHOT_SDSS_U','','rest frame u'' abs magnitude','0');
INSERT DBColumns VALUES('PhotozRF','absMagG','','PHOT_ABS-MAG PHOT_SDSS_G','','rest frame g'' abs magnitude','0');
INSERT DBColumns VALUES('PhotozRF','absMagR','','PHOT_ABS-MAG PHOT_SDSS_R','','rest frame r'' abs magnitude','0');
INSERT DBColumns VALUES('PhotozRF','absMagI','','PHOT_ABS-MAG PHOT_SDSS_I','','rest frame i'' abs magnitude','0');
INSERT DBColumns VALUES('PhotozRF','absMagZ','','PHOT_ABS-MAG PHOT_SDSS_Z','','rest frame z'' abs magnitude','0');
INSERT DBColumns VALUES('PhotozTemplateCoeff','objID','','ID_MAIN','','unique ID pointing to Galaxy table','0');
INSERT DBColumns VALUES('PhotozTemplateCoeff','templateID','','ID_IDENTIFIER','','id for the spectral template','0');
INSERT DBColumns VALUES('PhotozTemplateCoeff','coeff','','NUMBER','','coefficient of the template','0');
INSERT DBColumns VALUES('PhotozRFTemplateCoeff','objID','','ID_MAIN','','unique ID pointing to Galaxy table','0');
INSERT DBColumns VALUES('PhotozRFTemplateCoeff','templateID','','ID_IDENTIFIER','','id for the spectral template','0');
INSERT DBColumns VALUES('PhotozRFTemplateCoeff','coeff','','NUMBER','','coefficient of the template','0');
INSERT DBColumns VALUES('ProperMotions','delta','arcsec','POS_ANG_DIST_GENERAL','','Distance between this object and the nearest matching USNO-B object.','0');
INSERT DBColumns VALUES('ProperMotions','match','','CODE_MISC','','Number of objects in USNO-B which matched this object within a 1 arcsec radius.  If negative, then the nearest matching USNO-B object itself matched more than 1 SDSS object.','0');
INSERT DBColumns VALUES('ProperMotions','pmL','mas/year','POS_PM','','Proper motion in galactic longitude.','0');
INSERT DBColumns VALUES('ProperMotions','pmB','mas/year','POS_PM','','Proper motion in galactic latitude.','0');
INSERT DBColumns VALUES('ProperMotions','pmRa','mas/year','POS_PM_RA','','Proper motion in right ascension.','0');
INSERT DBColumns VALUES('ProperMotions','pmDec','mas/year','POS_PM_DEC','','Proper motion in declination.','0');
INSERT DBColumns VALUES('ProperMotions','pmRaErr','mas/year','POS_PM_RA_ERR','','Error in proper motion in right ascension.','0');
INSERT DBColumns VALUES('ProperMotions','pmDecErr','mas/year','POS_PM_DEC_ERR','','Error in proper motion in declination.','0');
INSERT DBColumns VALUES('ProperMotions','sigRa','mas','CODE_MISC','','RMS residual for the proper motion fit in r.a.','0');
INSERT DBColumns VALUES('ProperMotions','sigDec','mas','CODE_MISC','','RMS residual for the proper motion fit in dec.','0');
INSERT DBColumns VALUES('ProperMotions','nFit','','CODE_MISC','','Number of detections used in the fit including the SDSS detection (thus, the number of plates the object was detected on in USNO-B plus one).','0');
INSERT DBColumns VALUES('ProperMotions','O','mag','PHOT_MAG_G','','Recalibrated USNO-B O magnitude,  recalibrated to SDSS g','0');
INSERT DBColumns VALUES('ProperMotions','E','mag','PHOT_MAG_R','','Recalibrated USNO-B E magnitude,  recalibrated to SDSS r','0');
INSERT DBColumns VALUES('ProperMotions','J','mag','PHOT_MAG_G','','Recalibrated USNO-B J magnitude,  recalibrated to SDSS g','0');
INSERT DBColumns VALUES('ProperMotions','F','mag','PHOT_MAG_R','','Recalibrated USNO-B F magnitude,  recalibrated to SDSS r','0');
INSERT DBColumns VALUES('ProperMotions','N','mag','PHOT_MAG_I','','Recalibrated USNO-B N magnitude,  recalibrated to SDSS i','0');
INSERT DBColumns VALUES('ProperMotions','dist20','arcsec','POS_ANG_DIST','','Distance to the nearest neighbor with g < 20','0');
INSERT DBColumns VALUES('ProperMotions','dist22','arcsec','POS_ANG_DIST','','Distance to the nearest neighbor with g < 22','0');
INSERT DBColumns VALUES('ProperMotions','objid','','ID_MAIN','','unique id, points to photoObj','0');
INSERT DBColumns VALUES('FieldProfile','bin','','ID_NUMBER','','bin number (0..14)','0');
INSERT DBColumns VALUES('FieldProfile','band','','ID_NUMBER','','u,g,r,i,z (0..4)','0');
INSERT DBColumns VALUES('FieldProfile','profMean','nmgy/arcsec^2','PHOT_FLUX_OPTICAL','','Mean pixel flux in annulus','0');
INSERT DBColumns VALUES('FieldProfile','profMed','nmgy/arcsec^2','PHOT_FLUX_OPTICAL STAT_MEDIAN','','Median profile','0');
INSERT DBColumns VALUES('FieldProfile','profSig','nmgy/arcsec^2','PHOT_FLUX_OPTICAL STAT_STDEV','','Sigma of profile','0');
INSERT DBColumns VALUES('FieldProfile','fieldID','','ID_CATALOG','','links to the field object','0');
INSERT DBColumns VALUES('Run','skyVersion','','CODE_MISC','','0 = OPDB target, 1 = OPDB best XXX','0');
INSERT DBColumns VALUES('Run','run','','OBS_RUN','','Run number','0');
INSERT DBColumns VALUES('Run','rerun','','CODE_MISC','','Rerun number','0');
INSERT DBColumns VALUES('Run','mjd','days','','','MJD of observation','0');
INSERT DBColumns VALUES('Run','datestring','','','','Human-readable date of observation','0');
INSERT DBColumns VALUES('Run','stripe','','ID_FIELD','','Stripe number','0');
INSERT DBColumns VALUES('Run','strip','','','','Strip (N or S)','0');
INSERT DBColumns VALUES('Run','xBore','deg','','','boresight offset perpendicular to great circle','0');
INSERT DBColumns VALUES('Run','fieldRef','','ID_FIELD','','Starting field number of full run (what MU_REF, MJD_REF refer to)','0');
INSERT DBColumns VALUES('Run','lastField','','NUMBER','','last field of full run','0');
INSERT DBColumns VALUES('Run','flavor','','','','type of drift scan (from apacheraw, bias, calibration, engineering, ignore, and science)','0');
INSERT DBColumns VALUES('Run','xBin','pix','','','binning amount perpendicular to scan direction','0');
INSERT DBColumns VALUES('Run','yBin','pix','','','binning amount in scan direction','0');
INSERT DBColumns VALUES('Run','nRow','pix','','','number of rows in output idR','0');
INSERT DBColumns VALUES('Run','mjdRef','days','','','MJD at row 0 of reference frame','0');
INSERT DBColumns VALUES('Run','muRef','deg','','','mu value at row 0 of reference field','0');
INSERT DBColumns VALUES('Run','lineStart','microsec','','','linestart rate betweeen each (binned) row','0');
INSERT DBColumns VALUES('Run','tracking','arcsec/sec','','','tracking rate','0');
INSERT DBColumns VALUES('Run','node','','','','node of great circle, that is, its RA on the J2000 equator','0');
INSERT DBColumns VALUES('Run','incl','','','','inclination of great circle relative to J2000 equator','0');
INSERT DBColumns VALUES('Run','comments','','','','comments on the run','0');
INSERT DBColumns VALUES('Run','qterm','arcsec/hr^2','','','quadratic term in coarse astrometric solution','0');
INSERT DBColumns VALUES('Run','maxMuResid','arcsec','','','maximum residual from great circle in scan direction','0');
INSERT DBColumns VALUES('Run','maxNuResid','arcsec','','','maximum residual from great circle perpendicular to scan direction','0');
INSERT DBColumns VALUES('Run','startField','','','','starting field for reduced data','0');
INSERT DBColumns VALUES('Run','endField','','','','ending field for reduced data','0');
INSERT DBColumns VALUES('Run','photoVersion','','','','photo version used','0');
INSERT DBColumns VALUES('Run','dervishVersion','','','','dervish version used','0');
INSERT DBColumns VALUES('Run','astromVersion','','','','astrom version used','0');
INSERT DBColumns VALUES('Run','sasVersion','','','','version of SAS used to produce CSV for this run','0');
INSERT DBColumns VALUES('PhotoProfile','bin','','ID_NUMBER','','bin number (0..14)','0');
INSERT DBColumns VALUES('PhotoProfile','band','','ID_NUMBER','','u,g,r,i,z (0..4)','0');
INSERT DBColumns VALUES('PhotoProfile','profMean','nanomaggies/arcsec^2','PHOT_FLUX_OPTICAL','','Mean flux in annulus','0');
INSERT DBColumns VALUES('PhotoProfile','profErr','nanomaggies/arcsec^2','ERROR PHOT_FLUX_OPTICAL','','Standard deviation of mean pixel flux in annulus','0');
INSERT DBColumns VALUES('PhotoProfile','objID','','ID_MAIN','','links to the photometric object','0');
INSERT DBColumns VALUES('Mask','maskID','','ID_CATALOG','','Unique Id number, composed of skyversion, rerun, run, camcol, field, filter, mask','0');
INSERT DBColumns VALUES('Mask','run','','OBS_RUN','','Run number','0');
INSERT DBColumns VALUES('Mask','rerun','','CODE_MISC','','Rerun number','0');
INSERT DBColumns VALUES('Mask','camcol','','INST_ID','','Camera column','0');
INSERT DBColumns VALUES('Mask','field','','ID_FIELD','','Field number','0');
INSERT DBColumns VALUES('Mask','mask','','ID_NUMBER','','The object id within a field. Usually changes between reruns of the same field.','0');
INSERT DBColumns VALUES('Mask','filter','','INST_ID','','The enumerated filter [0..4]','0');
INSERT DBColumns VALUES('Mask','ra','deg','POS_EQ_RA_MAIN','','J2000 right ascension (r'')','0');
INSERT DBColumns VALUES('Mask','dec','deg','POS_EQ_DEC_MAIN','','J2000 declination (r'')','0');
INSERT DBColumns VALUES('Mask','radius','deg','EXTENSION_RAD','','the radius of the bounding circle','0');
INSERT DBColumns VALUES('Mask','area','','EXTENSION','','Area descriptor for the mask object','0');
INSERT DBColumns VALUES('Mask','type','','CLASS_CODE','MaskType','enumerated type of mask','0');
INSERT DBColumns VALUES('Mask','seeing','arcsecs','INST_SEEING','','seeing width','0');
INSERT DBColumns VALUES('Mask','cx','','POS_EQ_CART_X','','unit vector for ra+dec','0');
INSERT DBColumns VALUES('Mask','cy','','POS_EQ_CART_y','','unit vector for ra+dec','0');
INSERT DBColumns VALUES('Mask','cz','','POS_EQ_CART_Z','','unit vector for ra+dec','0');
INSERT DBColumns VALUES('Mask','htmID','','CODE_HTM','','20-deep hierarchical trangular mesh ID of this object','0');
INSERT DBColumns VALUES('MaskedObject','objid','','ID_MAIN','','pointer to a PhotoObj','0');
INSERT DBColumns VALUES('MaskedObject','maskID','','ID_CATALOG','','Unique maskid','0');
INSERT DBColumns VALUES('MaskedObject','maskType','','CLASS_CODE','MaskType','enumerated type of mask','0');
INSERT DBColumns VALUES('AtlasOutline','objID','','ID_MAIN','','Unique Id number, composed of rerun, run, camcol, field, objid','0');
INSERT DBColumns VALUES('AtlasOutline','size','','NUMBER','','number of spans allocated','0');
INSERT DBColumns VALUES('AtlasOutline','nspan','','NUMBER','','actual number of spans','0');
INSERT DBColumns VALUES('AtlasOutline','row0','','POS_OFFSET','','row offset from parent region','0');
INSERT DBColumns VALUES('AtlasOutline','col0','','POS_OFFSET','','col offset from parent region','0');
INSERT DBColumns VALUES('AtlasOutline','rmin','pix','POS_LIMIT','','bounding box min row','0');
INSERT DBColumns VALUES('AtlasOutline','rmax','pix','POS_LIMIT','','bounding box max row','0');
INSERT DBColumns VALUES('AtlasOutline','cmin','pix','POS_LIMIT','','bounding box min col','0');
INSERT DBColumns VALUES('AtlasOutline','cmax','pix','POS_LIMIT','','bounding box max col','0');
INSERT DBColumns VALUES('AtlasOutline','npix','pix','EXTENSION_AREA','','number of pixels in object','0');
INSERT DBColumns VALUES('AtlasOutline','span','','POS_MAP','','span data as string','0');
INSERT DBColumns VALUES('TwoMass','objID','','','','Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].','0');
INSERT DBColumns VALUES('TwoMass','ra','deg','','','2MASS right ascension, J2000','0');
INSERT DBColumns VALUES('TwoMass','dec','deg','','','2MASS declination, J2000','0');
INSERT DBColumns VALUES('TwoMass','errMaj','arcsec','','','Semi-major axis length of the one sigma position uncertainty ellipse','0');
INSERT DBColumns VALUES('TwoMass','errMin','arcsec','','','Semi-minor axis length of the one sigma position uncertainty ellipse','0');
INSERT DBColumns VALUES('TwoMass','errAng','deg','','','Position angle on the sky of the semi-major axis of the position uncertainty ellipse (East of North)','0');
INSERT DBColumns VALUES('TwoMass','j','mag','','','default J-band apparent magnitude (Vega relative, no Galactic extinction correction','0');
INSERT DBColumns VALUES('TwoMass','jIvar','inverse mag^2','','','inverse variance in J-band apparent magnitude','0');
INSERT DBColumns VALUES('TwoMass','h','mag','','','default H-band apparent magnitude (Vega relative, no Galactic extinction correction','0');
INSERT DBColumns VALUES('TwoMass','hIvar','inverse mag^2','','','inverse variance in H-band apparent magnitude','0');
INSERT DBColumns VALUES('TwoMass','k','mag','','','default K-band apparent magnitude (Vega relative, no Galactic extinction correction','0');
INSERT DBColumns VALUES('TwoMass','kIvar','inverse mag^2','','','inverse variance in K-band apparent magnitude','0');
INSERT DBColumns VALUES('TwoMass','phQual','','','','photometric quality flag (see 2MASS PSC documentation)','0');
INSERT DBColumns VALUES('TwoMass','rdFlag','','','','Read flag. Three character flag, one character per band [JHKs], that indicates the origin of the default magnitudes and uncertainties in each band (see 2MASS PSC documentation)','0');
INSERT DBColumns VALUES('TwoMass','blFlag','','','','Blend flag. Three character flag, one character per band [JHKs], that indicates the number of components that were fit simultaneously when estimating the brightness of a source (see 2MASS PSC documentation)','0');
INSERT DBColumns VALUES('TwoMass','ccFlag','','','','Contamination and confusion flag. Three character flag, one character per band [JHKs], that indicates that the photometry and/or position measurements of a source may be contaminated or biased due to proximity to an image artifact or nearby source of equal or greater brightness. (See 2MASS PSC documentation).','0');
INSERT DBColumns VALUES('TwoMass','nDetectJ','','','','Number of frames on which 2MASS source was detected in J-band','0');
INSERT DBColumns VALUES('TwoMass','nDetectH','','','','Number of frames on which 2MASS source was detected in H-band','0');
INSERT DBColumns VALUES('TwoMass','nDetectK','','','','Number of frames on which 2MASS source was detected in K-band','0');
INSERT DBColumns VALUES('TwoMass','nObserveJ','','','','Number of frames which 2MASS source was within the boundaries of in J-band','0');
INSERT DBColumns VALUES('TwoMass','nObserveH','','','','Number of frames which 2MASS source was within the boundaries of in H-band','0');
INSERT DBColumns VALUES('TwoMass','nObserveK','','','','Number of frames which 2MASS source was within the boundaries of in K-band','0');
INSERT DBColumns VALUES('TwoMass','galContam','','','','Extended source "contamination" flag. A value of gal_contam="0" indicates no contamination. "1" indicates it is probably an extended source itself (this does not detect all such cases!).  "2" indicates it is within the boundary of a large XSC source. (See 2MASS PSC documentation).','0');
INSERT DBColumns VALUES('TwoMass','mpFlag','','','','Minor planet flag. "1" if source associated with known solar system object, "0" otherwise. (See 2MASS PSC documentation).','0');
INSERT DBColumns VALUES('TwoMass','ptsKey','','','','Unique identification number for the PSC source.','0');
INSERT DBColumns VALUES('TwoMass','hemis','','','','Hemisphere code for the 2MASS Observatory from which this source was observed.  "n" means North (Mt. Hopkins); "s" means South (CTIO).','0');
INSERT DBColumns VALUES('TwoMass','jDate','','','','Julian Date of the source measurement accurate to +30 seconds. (See 2MASS PSC documentation).','0');
INSERT DBColumns VALUES('TwoMass','dupSource','','','','Duplicate source flag. Used in conjunction with the use_src flag, this numerical flag indicates whether the source falls in a Tile overlap region, and if so, if it was detected multiple times. (See 2MASS PSC documentation)','0');
INSERT DBColumns VALUES('TwoMass','useSource','','','','Use source flag. Used in conjunction with the dup_src flag, this numerical flag indicates if a source falls within a Tile overlap region, and whether or not it satisfies the unbiased selection rules for multiple source resolution. (See 2MASS PSC documentation).','0');
INSERT DBColumns VALUES('TwoMassXSC','objID','','','','Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].','0');
INSERT DBColumns VALUES('TwoMassXSC','tmassxsc_ra','deg','','','2MASS right ascension, J2000','0');
INSERT DBColumns VALUES('TwoMassXSC','tmassxsc_dec','deg','','','2MASS declination, J2000','0');
INSERT DBColumns VALUES('TwoMassXSC','jDate','','','','Julian Date of the source measurement accurate to +30 seconds. (See 2MASS PSC documentation).','0');
INSERT DBColumns VALUES('TwoMassXSC','designation','','','','Sexagesimal, equatorial position-based source name in the form: hhmmssss+ddmmsss[ABC...].','0');
INSERT DBColumns VALUES('TwoMassXSC','sup_ra','','','','Super-coadd centroid RA (J2000 decimal deg).','0');
INSERT DBColumns VALUES('TwoMassXSC','sup_dec','','','','Super-coadd centroid Dec (J2000 decimal deg).','0');
INSERT DBColumns VALUES('TwoMassXSC','density','','','','Coadd log(density) of stars with k<14 mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','R_K20FE','mag','','','20mag/sq arcsec isophotal K fiducial ell. ap. semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_K20FE','mag','','','J 20mag/sq arcsec isophotal fiducial ell. ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_K20FE','mag','','','J 1-sigma uncertainty in 20mag/sq arcsec iso.fid.ell.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_K20FE','','','','J confusion flag for 20mag/sq arcsec iso. fid. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_K20FE','mag','','','H 20mag/sq arcsec isophotal fiducial ell. ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_K20FE','mag','','','H 1-sigma uncertainty in 20mag/sq arcsec iso.fid.ell.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_K20FE','','','','H confusion flag for 20mag/sq arcsec iso. fid. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_K20FE','mag','','','K 20mag/sq arcsec isophotal fiducial ell. ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_K20FE','mag','','','K 1-sigma uncertainty in 20mag/sq arcsec iso.fid.ell.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_K20FE','','','','K confusion flag for 20mag/sq arcsec iso. fid. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','R_3SIG','arcsec','','','3-sigma K isophotal semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_BA','','','','J minor/major axis ratio fit to the 3-sigma isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_PHI','deg','','','J angle to 3-sigma major axis (E of N).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_BA','','','','H minor/major axis ratio fit to the 3-sigma isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_PHI','deg','','','H angle to 3-sigma major axis (E of N).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_BA','','','','K minor/major axis ratio fit to the 3-sigma isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_PHI','deg','','','K angle to 3-sigma major axis (E of N).','0');
INSERT DBColumns VALUES('TwoMassXSC','SUP_R_3SIG','','','','Super-coadd minor/major axis ratio fit to the 3-sigma isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','SUP_BA','','','','K minor/major axis ratio fit to the 3-sigma isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','SUP_PHI','deg','','','K angle to 3-sigma major axis (E of N).','0');
INSERT DBColumns VALUES('TwoMassXSC','R_FE','','','','K fiducial Kron elliptical aperture semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_FE','mag','','','J fiducial Kron elliptical aperture magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_FE','mag','','','J 1-sigma uncertainty in fiducial Kron ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_FE','','','','J confusion flag for fiducial Kron ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_FE','mag','','','H fiducial Kron elliptical aperture magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_FE','mag','','','H 1-sigma uncertainty in fiducial Kron ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_FE','','','','H confusion flag for fiducial Kron ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_FE','mag','','','K fiducial Kron elliptical aperture magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_FE','mag','','','K 1-sigma uncertainty in fiducial Kron ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_FE','','','','K confusion flag for fiducial Kron ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','R_EXT','arcsec','','','extrapolation/total radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_EXT','mag','','','J mag from fit extrapolation.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_EXT','mag','','','J 1-sigma uncertainty in mag from fit extrapolation.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_PCHI','','','','J chi^2 of fit to rad. profile','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_EXT','mag','','','H mag from fit extrapolation.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_EXT','mag','','','H 1-sigma uncertainty in mag from fit extrapolation.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_PCHI','','','','H chi^2 of fit to rad. profile','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_EXT','mag','','','K mag from fit extrapolation.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_EXT','mag','','','K 1-sigma uncertainty in mag from fit extrapolation.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_PCHI','','','','K chi^2 of fit to rad. profile','0');
INSERT DBColumns VALUES('TwoMassXSC','J_R_EFF','arcsec','','','J half-light (integrated half-flux point) radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MNSURFB_EFF','mag/sq. arcsec','','','J mean surface brightness at the half-light radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_R_EFF','arcsec','','','H half-light (integrated half-flux point) radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MNSURFB_EFF','mag/sq. arcsec','','','H mean surface brightness at the half-light radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_R_EFF','arcsec','','','K half-light (integrated half-flux point) radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MNSURFB_EFF','mag/sq. arcsec','','','K mean surface brightness at the half-light radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_CON_INDX','','','','J concentration index r_75%/r_25%.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_CON_INDX','','','','H concentration index r_75%/r_25%.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_CON_INDX','','','','K concentration index r_75%/r_25%.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_PEAK','mag/sq. arcsec','','','J peak pixel brightness.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_PEAK','mag/sq. arcsec','','','H peak pixel brightness.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_PEAK','mag/sq. arcsec','','','K peak pixel brightness.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_5SURF','mag/sq. arcsec','','','J central surface brightness (r<=5).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_5SURF','mag/sq. arcsec','','','H central surface brightness (r<=5).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_5SURF','mag/sq. arcsec','','','K central surface brightness (r<=5).','0');
INSERT DBColumns VALUES('TwoMassXSC','E_SCORE','','','','extended score: 1(extended) < e_score < 2(point-like).','0');
INSERT DBColumns VALUES('TwoMassXSC','G_SCORE','','','','galaxy score: 1(extended) < g_score < 2(point-like).','0');
INSERT DBColumns VALUES('TwoMassXSC','VC','','','','visual verification score for source.','0');
INSERT DBColumns VALUES('TwoMassXSC','CC_FLG','','','','indicates artifact contamination and/or confusion.','0');
INSERT DBColumns VALUES('TwoMassXSC','IM_NX','','','','size of postage stamp image in pixels.','0');
INSERT DBColumns VALUES('TwoMassXSC','R_K20FC','arcsec','','','20mag/sq arcsec isophotal K fiducial circular ap. radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_K20FC','mag','','','J 20mag/sq arcsec isophotal fiducial circ. ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_K20FC','mag','','','J 1-sigma uncertainty in 20mag/sq arcsec iso.fid.circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_K20FC','','','','J confusion flag for 20mag/sq arcsec iso. fid. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_K20FC','mag','','','H 20mag/sq arcsec isophotal fiducial circ. ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_K20FC','mag','','','H 1-sigma uncertainty in 20mag/sq arcsec iso.fid.circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_K20FC','','','','H confusion flag for 20mag/sq arcsec iso. fid. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_K20FC','mag','','','K 20mag/sq arcsec isophotal fiducial circ. ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_K20FC','mag','','','K 1-sigma uncertainty in 20mag/sq arcsec iso.fid.circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_K20FC','','','','K confusion flag for 20mag/sq arcsec iso. fid. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_R_E','arcsec','','','J Kron elliptical aperture semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_E','mag','','','J Kron elliptical aperture magnitude','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_E','mag','','','J 1-sigma uncertainty in Kron elliptical mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_E','','','','J confusion flag for Kron elliptical mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_R_E','arcsec','','','H Kron elliptical aperture semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_E','mag','','','H Kron elliptical aperture magnitude','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_E','mag','','','H 1-sigma uncertainty in Kron elliptical mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_E','','','','H confusion flag for Kron elliptical mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_R_E','arcsec','','','K Kron elliptical aperture semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_E','mag','','','K Kron elliptical aperture magnitude','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_E','mag','','','K 1-sigma uncertainty in Kron elliptical mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_E','','','','K confusion flag for Kron elliptical mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_R_C','arcsec','','','J Kron circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_C','mag','','','J Kron circular aperture magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_C','mag','','','J 1-sigma uncertainty in Kron circular mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_C','','','','J confusion flag for Kron circular mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_R_C','arcsec','','','H Kron circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_C','mag','','','H Kron circular aperture magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_C','mag','','','H 1-sigma uncertainty in Kron circular mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_C','','','','H confusion flag for Kron circular mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_R_C','arcsec','','','K Kron circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_C','mag','','','K Kron circular aperture magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_C','mag','','','K 1-sigma uncertainty in Kron circular mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_C','','','','K confusion flag for Kron circular mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','R_FC','arcsec','','','K fiducial Kron circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_FC','mag','','','J fiducial Kron circular magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_FC','mag','','','J 1-sigma uncertainty in fiducial Kron circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_FC','','','','J confusion flag for Kron circular mag. confusion flag for fiducial Kron circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_FC','mag','','','H fiducial Kron circular magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_FC','mag','','','H 1-sigma uncertainty in fiducial Kron circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_FC','','','','H confusion flag for Kron circular mag. confusion flag for fiducial Kron circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_FC','mag','','','K fiducial Kron circular magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_FC','mag','','','K 1-sigma uncertainty in fiducial Kron circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_FC','','','','K confusion flag for Kron circular mag. confusion flag for fiducial Kron circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_R_I20E','arcsec','','','J 20mag/sq arcsec isophotal elliptical ap. semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_I20E','mag','','','J 20mag/sq arcsec isophotal elliptical ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_I20E','mag','','','J 1-sigma uncertainty in 20mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_I20E','','','','J confusion flag for 20mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_R_I20E','arcsec','','','H 20mag/sq arcsec isophotal elliptical ap. semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_I20E','mag','','','H 20mag/sq arcsec isophotal elliptical ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_I20E','mag','','','H 1-sigma uncertainty in 20mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_I20E','','','','H confusion flag for 20mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_R_I20E','arcsec','','','K 20mag/sq arcsec isophotal elliptical ap. semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_I20E','mag','','','K 20mag/sq arcsec isophotal elliptical ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_I20E','mag','','','K 1-sigma uncertainty in 20mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_I20E','','','','K confusion flag for 20mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_R_I20C','arcsec','','','J 20mag/sq arcsec isophotal circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_I20C','mag','','','J 20mag/sq arcsec isophotal circular ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_I20C','mag','','','J 1-sigma uncertainty in 20mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_I20C','','','','J confusion flag for 20mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_R_I20C','arcsec','','','H 20mag/sq arcsec isophotal circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_I20C','mag','','','H 20mag/sq arcsec isophotal circular ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_I20C','mag','','','H 1-sigma uncertainty in 20mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_I20C','','','','H confusion flag for 20mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_R_I20C','arcsec','','','K 20mag/sq arcsec isophotal circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_I20C','mag','','','K 20mag/sq arcsec isophotal circular ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_I20C','mag','','','K 1-sigma uncertainty in 20mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_I20C','','','','K confusion flag for 20mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_R_I21E','arcsec','','','J 21mag/sq arcsec isophotal elliptical ap. semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_I21E','mag','','','J 21mag/sq arcsec isophotal elliptical ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_I21E','mag','','','J 1-sigma uncertainty in 21mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_I21E','','','','J confusion flag for 21mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_R_I21E','arcsec','','','H 21mag/sq arcsec isophotal elliptical ap. semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_I21E','mag','','','H 21mag/sq arcsec isophotal elliptical ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_I21E','mag','','','H 1-sigma uncertainty in 21mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_I21E','','','','H confusion flag for 21mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_R_I21E','arcsec','','','K 21mag/sq arcsec isophotal elliptical ap. semi-major axis.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_I21E','mag','','','K 21mag/sq arcsec isophotal elliptical ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_I21E','mag','','','K 1-sigma uncertainty in 21mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_I21E','','','','K confusion flag for 21mag/sq arcsec iso. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','R_J21FE','','','','','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_J21FE','mag','','','J 21mag/sq arcsec isophotal fiducial ell. ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_J21FE','mag','','','J 1-sigma uncertainty in 21mag/sq arcsec iso.fid.ell.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_J21FE','','','','J confusion flag for 21mag/sq arcsec iso. fid. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_J21FE','mag','','','H 21mag/sq arcsec isophotal fiducial ell. ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_J21FE','mag','','','H 1-sigma uncertainty in 21mag/sq arcsec iso.fid.ell.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_J21FE','','','','H confusion flag for 21mag/sq arcsec iso. fid. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_J21FE','mag','','','K 21mag/sq arcsec isophotal fiducial ell. ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_J21FE','mag','','','K 1-sigma uncertainty in 21mag/sq arcsec iso.fid.ell.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_J21FE','','','','K confusion flag for 21mag/sq arcsec iso. fid. ell. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_R_I21C','arcsec','','','J 21mag/sq arcsec isophotal circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_I21C','mag','','','J 21mag/sq arcsec isophotal circular ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_I21C','mag','','','J 1-sigma uncertainty in 21mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_I21C','','','','J confusion flag for 21mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_R_I21C','arcsec','','','H 21mag/sq arcsec isophotal circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_I21C','mag','','','H 21mag/sq arcsec isophotal circular ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_I21C','mag','','','H 1-sigma uncertainty in 21mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_I21C','','','','H confusion flag for 21mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_R_I21C','arcsec','','','K 21mag/sq arcsec isophotal circular aperture radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_I21C','mag','','','K 21mag/sq arcsec isophotal circular ap. magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_I21C','mag','','','K 1-sigma uncertainty in 21mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_I21C','','','','K confusion flag for 21mag/sq arcsec iso. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','R_J21FC','arcsec','','','21mag/sq arcsec isophotal J fiducial circular ap. radius.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_J21FC','mag','','','J 21mag/sq arcsec isophotal fiducial circ. ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_J21FC','mag','','','J 1-sigma uncertainty in 21mag/sq arcsec iso.fid.circ.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_J21FC','','','','J confusion flag for 21mag/sq arcsec iso. fid. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_J21FC','mag','','','H 21mag/sq arcsec isophotal fiducial circ. ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_J21FC','mag','','','H 1-sigma uncertainty in 21mag/sq arcsec iso.fid.circ.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_J21FC','','','','H confusion flag for 21mag/sq arcsec iso. fid. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_J21FC','mag','','','K 21mag/sq arcsec isophotal fiducial circ. ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_J21FC','mag','','','K 1-sigma uncertainty in 21mag/sq arcsec iso.fid.circ.mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_J21FC','','','','K confusion flag for 21mag/sq arcsec iso. fid. circ. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_SYS','mag','','','J system photometry magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_SYS','mag','','','J 1-sigma uncertainty in system photometry mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_SYS','mag','','','H system photometry magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_SYS','mag','','','H 1-sigma uncertainty in system photometry mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_SYS','mag','','','K system photometry magnitude.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_SYS','mag','','','K 1-sigma uncertainty in system photometry mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','SYS_FLG','','','','system flag: 0=no system, 1=nearby galaxy flux incl. in mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','CONTAM_FLG','','','','contamination flag: 0=no stars, 1=stellar flux incl. in mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_5SIG_BA','','','','J minor/major axis ratio fit to the 5-sigma isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_5SIG_PHI','deg','','','J angle to 5-sigma major axis (E of N).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_5SIG_BA','','','','H minor/major axis ratio fit to the 5-sigma isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_5SIG_PHI','deg','','','H angle to 5-sigma major axis (E of N).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_5SIG_BA','','','','K minor/major axis ratio fit to the 5-sigma isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_5SIG_PHI','deg','','','K angle to 5-sigma major axis (E of N).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_D_AREA','sq arcsec','','','J 5-sigma to 3-sigma differential area.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_PERC_DAREA','sq arcsec','','','J 5-sigma to 3-sigma percent area change.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_D_AREA','sq arcsec','','','H 5-sigma to 3-sigma differential area.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_PERC_DAREA','sq arcsec','','','H 5-sigma to 3-sigma percent area change.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_D_AREA','sq arcsec','','','K 5-sigma to 3-sigma differential area.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_PERC_DAREA','sq arcsec','','','K 5-sigma to 3-sigma percent area change.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_BISYM_RAT','','','','J bi-symmetric flux ratio.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_BISYM_CHI','','','','J bi-symmetric cross-correlation chi.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_BISYM_RAT','','','','H bi-symmetric flux ratio.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_BISYM_CHI','','','','H bi-symmetric cross-correlation chi.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_BISYM_RAT','','','','K bi-symmetric flux ratio.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_BISYM_CHI','','','','K bi-symmetric cross-correlation chi.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SH0','','','','J ridge shape (LCSB: BSNR limit).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SIG_SH0','','','','J ridge shape sigma (LCSB: B2SNR limit).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SH0','','','','H ridge shape (LCSB: BSNR limit).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SIG_SH0','','','','H ridge shape sigma (LCSB: B2SNR limit).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SH0','','','','K ridge shape (LCSB: BSNR limit).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SIG_SH0','','','','K ridge shape sigma (LCSB: B2SNR limit).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_MXDN','','','','J mxdn (score) (LCSB: BSNR - block/smoothed SNR)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_SH','','','','J shape (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_WSH','','','','J wsh (score) (LCSB: PSNR - peak raw SNR).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_R23','','','','J r23 (score) (LCSB: TSNR - integrated SNR for r=15).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_1MM','','','','J 1st moment (score) (LCSB: super blk 2,4,8 SNR).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_2MM','','','','J 2nd moment (score) (LCSB: SNRMAX - super SNR max).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_VINT','','','','J vint (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_R1','','','','J r1 (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SC_MSH','','','','J median shape score.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_MXDN','','','','H mxdn (score) (LCSB: BSNR - block/smoothed SNR)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_SH','','','','H shape (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_WSH','','','','H wsh (score) (LCSB: PSNR - peak raw SNR).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_R23','','','','H r23 (score) (LCSB: TSNR - integrated SNR for r=15).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_1MM','','','','H 1st moment (score) (LCSB: super blk 2,4,8 SNR).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_2MM','','','','H 2nd moment (score) (LCSB: SNRMAX - super SNR max).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_VINT','','','','H vint (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_R1','','','','H r1 (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SC_MSH','','','','H median shape score.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_MXDN','','','','K mxdn (score) (LCSB: BSNR - block/smoothed SNR)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_SH','','','','K shape (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_WSH','','','','K wsh (score) (LCSB: PSNR - peak raw SNR).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_R23','','','','K r23 (score) (LCSB: TSNR - integrated SNR for r=15).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_1MM','','','','K 1st moment (score) (LCSB: super blk 2,4,8 SNR).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_2MM','','','','K 2nd moment (score) (LCSB: SNRMAX - super SNR max).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_VINT','','','','K vint (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_R1','','','','K r1 (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SC_MSH','','','','K median shape score.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_CHIF_ELLF','','','','J % chi-fraction for elliptical fit to 3-sig isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_CHIF_ELLF','','','','K % chi-fraction for elliptical fit to 3-sig isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','ELLFIT_FLG','','','','ellipse fitting contamination flag.','0');
INSERT DBColumns VALUES('TwoMassXSC','SUP_CHIF_ELLF','','','','super-coadd % chi-fraction for ellip. fit to 3-sig isophote.','0');
INSERT DBColumns VALUES('TwoMassXSC','N_BLANK','','','','number of blanked source records.','0');
INSERT DBColumns VALUES('TwoMassXSC','N_SUB','','','','number of subtracted source records.','0');
INSERT DBColumns VALUES('TwoMassXSC','BL_SUB_FLG','','','','blanked/subtracted src description flag.','0');
INSERT DBColumns VALUES('TwoMassXSC','ID_FLG','','','','type/galaxy ID flag (0=non-catalog, 1=catalog, 2=LCSB).','0');
INSERT DBColumns VALUES('TwoMassXSC','ID_CAT','','','','matched galaxy catalog name.','0');
INSERT DBColumns VALUES('TwoMassXSC','FG_FLG','','','','flux-growth convergence flag.','0');
INSERT DBColumns VALUES('TwoMassXSC','BLK_FAC','','','','LCSB blocking factor (1, 2, 4, 8).','0');
INSERT DBColumns VALUES('TwoMassXSC','DUP_SRC','','','','Duplicate source flag.','0');
INSERT DBColumns VALUES('TwoMassXSC','USE_SRC','','','','Use source flag.','0');
INSERT DBColumns VALUES('TwoMassXSC','PROX','arcsec','','','Proximity. The distance between this source and its nearest neighbor in the PSC.','0');
INSERT DBColumns VALUES('TwoMassXSC','PXPA','deg','','','The position angle on the sky of the vector from the source to the nearest neighbor in the PSC, East of North.','0');
INSERT DBColumns VALUES('TwoMassXSC','PXCNTR','','','','ext_key value of nearest XSC source.','0');
INSERT DBColumns VALUES('TwoMassXSC','DIST_EDGE_NS','','','','The distance from the source to the nearest North or South scan edge.','0');
INSERT DBColumns VALUES('TwoMassXSC','DIST_EDGE_EW','arcsec','','','The distance from the source to the nearest East or West scan edge.','0');
INSERT DBColumns VALUES('TwoMassXSC','DIST_EDGE_FLG','','','','flag indicating which edges ([n|s][e|w]) are nearest to src.','0');
INSERT DBColumns VALUES('TwoMassXSC','PTS_KEY','','','','key to point source data DB record.','0');
INSERT DBColumns VALUES('TwoMassXSC','MP_KEY','','','','key to minor planet prediction DB record.','0');
INSERT DBColumns VALUES('TwoMassXSC','NIGHT_KEY','','','','key to night data record in "scan DB".','0');
INSERT DBColumns VALUES('TwoMassXSC','SCAN_KEY','','','','key to scan data record in "scan DB".','0');
INSERT DBColumns VALUES('TwoMassXSC','COADD_KEY','','','','key to coadd data record in "scan DB".','0');
INSERT DBColumns VALUES('TwoMassXSC','HEMIS','','','','hemisphere (N/S) of observation. "n" = North/Mt. Hopkins; "s" = South/CTIO.','0');
INSERT DBColumns VALUES('TwoMassXSC','DATE','','','','The observation reference date for this source expressed in ISO standard format.','0');
INSERT DBColumns VALUES('TwoMassXSC','SCAN','','','','scan number (unique within date).','0');
INSERT DBColumns VALUES('TwoMassXSC','COADD','','','','3-digit coadd number (unique within scan).','0');
INSERT DBColumns VALUES('TwoMassXSC','X_COADD','pix','','','x (cross-scan) position (coadd coord.).','0');
INSERT DBColumns VALUES('TwoMassXSC','Y_COADD','pix','','','y (in-scan) position (coadd coord.).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SUBST2','','','','J residual background #2 (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SUBST2','','','','H residual background #2 (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SUBST2','','','','K residual background #2 (score).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_BACK','mag/sq arcsec','','','J coadd median background.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_BACK','mag/sq arcsec','','','H coadd median background.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_BACK','mag/sq arcsec','','','K coadd median background.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_RESID_ANN','mag/sq arcsec','','','J residual annulus background median.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_RESID_ANN','mag/sq arcsec','','','H residual annulus background median.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_RESID_ANN','mag/sq arcsec','','','K residual annulus background median.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_BNDG_PER','','','','J banding Fourier Transf. period on this side of coadd.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_BNDG_AMP','','','','J banding maximum FT amplitude on this side of coadd.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_BNDG_PER','','','','H banding Fourier Transf. period on this side of coadd.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_BNDG_AMP','','','','H banding maximum FT amplitude on this side of coadd.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_BNDG_PER','','','','K banding Fourier Transf. period on this side of coadd.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_BNDG_AMP','','','','K banding maximum FT amplitude on this side of coadd.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_SEETRACK','','','','J band seetracking score.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_SEETRACK','','','','H band seetracking score.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_SEETRACK','','','','K band seetracking score.','0');
INSERT DBColumns VALUES('TwoMassXSC','EXT_KEY','','','','entry counter (key) number (unique within table).','0');
INSERT DBColumns VALUES('TwoMassXSC','TMASSXSC_ID','','','','source ID number (unique within scan, coadd).','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_5','mag','','','J-band circular aperture magnitude (5 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_5','mag','','','error in J-band circular aperture magnitude (5 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_5','','','','J confusion flag for 5 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_7','mag','','','J-band circular aperture magnitude (7 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_7','mag','','','error in J-band circular aperture magnitude (7 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_7','','','','J confusion flag for 7 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_10','mag','','','J-band circular aperture magnitude (10 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_10','mag','','','error in J-band circular aperture magnitude (10 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_10','','','','J confusion flag for 10 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_15','mag','','','J-band circular aperture magnitude (15 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_15','mag','','','error in J-band circular aperture magnitude (15 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_15','','','','J confusion flag for 15 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_20','mag','','','J-band circular aperture magnitude (20 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_20','mag','','','error in J-band circular aperture magnitude (20 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_20','','','','J confusion flag for 20 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_25','mag','','','J-band circular aperture magnitude (25 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_25','mag','','','error in J-band circular aperture magnitude (25 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_25','','','','J confusion flag for 25 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_30','mag','','','J-band circular aperture magnitude (30 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_30','mag','','','error in J-band circular aperture magnitude (30 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_30','','','','J confusion flag for 30 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_40','mag','','','J-band circular aperture magnitude (40 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_40','mag','','','error in J-band circular aperture magnitude (40 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_40','','','','J confusion flag for 40 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_50','mag','','','J-band circular aperture magnitude (50 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_50','mag','','','error in J-band circular aperture magnitude (50 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_50','','','','J confusion flag for 50 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_60','mag','','','J-band circular aperture magnitude (60 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_60','mag','','','error in J-band circular aperture magnitude (60 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_60','','','','J confusion flag for 60 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','J_M_70','mag','','','J-band circular aperture magnitude (70 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_MSIG_70','mag','','','error in J-band circular aperture magnitude (70 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','J_FLG_70','','','','J confusion flag for 70 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_5','mag','','','H-band circular aperture magnitude (5 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_5','mag','','','error in H-band circular aperture magnitude (5 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_5','','','','H confusion flag for 5 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_7','mag','','','H-band circular aperture magnitude (7 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_7','mag','','','error in H-band circular aperture magnitude (7 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_7','','','','H confusion flag for 7 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_10','mag','','','H-band circular aperture magnitude (10 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_10','mag','','','error in H-band circular aperture magnitude (10 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_10','','','','H confusion flag for 10 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_15','mag','','','H-band circular aperture magnitude (15 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_15','mag','','','error in H-band circular aperture magnitude (15 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_15','','','','H confusion flag for 15 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_20','mag','','','H-band circular aperture magnitude (20 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_20','mag','','','error in H-band circular aperture magnitude (20 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_20','','','','H confusion flag for 20 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_25','mag','','','H-band circular aperture magnitude (25 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_25','mag','','','error in H-band circular aperture magnitude (25 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_25','','','','H confusion flag for 25 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_30','mag','','','H-band circular aperture magnitude (30 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_30','mag','','','error in H-band circular aperture magnitude (30 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_30','','','','H confusion flag for 30 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_40','mag','','','H-band circular aperture magnitude (40 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_40','mag','','','error in H-band circular aperture magnitude (40 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_40','','','','H confusion flag for 40 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_50','mag','','','H-band circular aperture magnitude (50 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_50','mag','','','error in H-band circular aperture magnitude (50 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_50','','','','H confusion flag for 50 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_60','mag','','','H-band circular aperture magnitude (60 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_60','mag','','','error in H-band circular aperture magnitude (60 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_60','','','','H confusion flag for 60 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','H_M_70','mag','','','H-band circular aperture magnitude (70 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_MSIG_70','mag','','','error in H-band circular aperture magnitude (70 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','H_FLG_70','','','','H confusion flag for 70 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_5','mag','','','K-band circular aperture magnitude (5 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_5','mag','','','error in K-band circular aperture magnitude (5 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_5','','','','K confusion flag for 5 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_7','mag','','','K-band circular aperture magnitude (7 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_7','mag','','','error in K-band circular aperture magnitude (7 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_7','','','','K confusion flag for 7 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_10','mag','','','K-band circular aperture magnitude (10 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_10','mag','','','error in K-band circular aperture magnitude (10 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_10','','','','K confusion flag for 10 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_15','mag','','','K-band circular aperture magnitude (15 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_15','mag','','','error in K-band circular aperture magnitude (15 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_15','','','','K confusion flag for 15 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_20','mag','','','K-band circular aperture magnitude (20 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_20','mag','','','error in K-band circular aperture magnitude (20 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_20','','','','K confusion flag for 20 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_25','mag','','','K-band circular aperture magnitude (25 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_25','mag','','','error in K-band circular aperture magnitude (25 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_25','','','','K confusion flag for 25 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_30','mag','','','K-band circular aperture magnitude (30 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_30','mag','','','error in K-band circular aperture magnitude (30 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_30','','','','K confusion flag for 30 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_40','mag','','','K-band circular aperture magnitude (40 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_40','mag','','','error in K-band circular aperture magnitude (40 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_40','','','','K confusion flag for 40 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_50','mag','','','K-band circular aperture magnitude (50 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_50','mag','','','error in K-band circular aperture magnitude (50 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_50','','','','K confusion flag for 50 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_60','mag','','','K-band circular aperture magnitude (60 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_60','mag','','','error in K-band circular aperture magnitude (60 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_60','','','','K confusion flag for 60 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('TwoMassXSC','K_M_70','mag','','','K-band circular aperture magnitude (70 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_MSIG_70','mag','','','error in K-band circular aperture magnitude (70 arcsec radius)','0');
INSERT DBColumns VALUES('TwoMassXSC','K_FLG_70','','','','K confusion flag for 70 arcsec circular ap. mag.','0');
INSERT DBColumns VALUES('FIRST','objID','','ID_MAIN','','unique id, points to photoObj','0');
INSERT DBColumns VALUES('FIRST','ra','deg','','','FIRST source right ascension, J2000','0');
INSERT DBColumns VALUES('FIRST','dec','deg','','','FIRST source declination, J2000','0');
INSERT DBColumns VALUES('FIRST','warning','','','','warning in FIRST catalog','0');
INSERT DBColumns VALUES('FIRST','peak','mJy','PHOT_FLUX_RADIO','','Peak FIRST radio flux','0');
INSERT DBColumns VALUES('FIRST','integr','mJy','PHOT_FLUX_RADIO','','Integrated FIRST radio flux','0');
INSERT DBColumns VALUES('FIRST','rms','mJy','PHOT_FLUX_RADIO ERROR','','rms error in flux','0');
INSERT DBColumns VALUES('FIRST','major','arcsec','EXTENSION_RAD','','Major axis (deconvolved)','0');
INSERT DBColumns VALUES('FIRST','minor','arcsec','EXTENSION_SMIN','','Minor axis (deconvolved)','0');
INSERT DBColumns VALUES('FIRST','pa','deg','POS_POS-ANG','','position angle (east of north)','0');
INSERT DBColumns VALUES('FIRST','skyrms','mJy','PHOT_FLUX_RADIO ERROR','','background rms error in flux','0');
INSERT DBColumns VALUES('RC3','objID','','','','Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].','0');
INSERT DBColumns VALUES('RC3','RA','deg  -/D J2000 right ascension in RC3','','','','0');
INSERT DBColumns VALUES('RC3','DEC','deg  -/D J2000 declination in RC3','','','','0');
INSERT DBColumns VALUES('RC3','NAME1','','','','designation #1 (Names or NGC and IC)','0');
INSERT DBColumns VALUES('RC3','NAME2','','','','designation #2 (UGC, ESO, MCG, UGCA, CGCG)','0');
INSERT DBColumns VALUES('RC3','NAME3','','','','designation #3 (other)','0');
INSERT DBColumns VALUES('RC3','PGC','','','','Principal Galaxy Catalog number (Paturel et al. 1989)','0');
INSERT DBColumns VALUES('RC3','HUBBLE','','','','revised Hubble type, coded as in RC2 (Section 3.3.a, page 13).','0');
INSERT DBColumns VALUES('RC3','LOGD_25','','','','mean decimal logarithm of the apparent major isophotal diameter measured at or reduced to surface brightness level mu_B = 25.0 B-mag/arcsec^2, as explained in Section 3.4.a, page 21.  Unit of D is 0.1 arcmin to avoid negative entries.','0');
INSERT DBColumns VALUES('RC3','LOGD_25Q','','','','quality flag for isophotal diameter ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','LOGD_25ERR','','','','error on mean decimal logarithm of the apparent major isophotal diameter','0');
INSERT DBColumns VALUES('RC3','PA','deg','','','position angle (east of north)','0');
INSERT DBColumns VALUES('RC3','BT','mag','','','total (asymptotic) magnitude in the B system','0');
INSERT DBColumns VALUES('RC3','BT_S','','','','source code for BT','0');
INSERT DBColumns VALUES('RC3','BTQ','','','','quality flag total magnitude ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','BTERR','mag','','','error in total (asymptotic) magnitude in the B system','0');
INSERT DBColumns VALUES('RC3','BMVT','mag','','','total (asymptotic) color index in Johnson B-V','0');
INSERT DBColumns VALUES('RC3','BMVTQ','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','BMVTERR','mag','','','error in total (asymptotic) color index in Johnson B-V','0');
INSERT DBColumns VALUES('RC3','BMVE','mag','','','color index within effective aperture in Johnson B-V','0');
INSERT DBColumns VALUES('RC3','BMVEQ','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','BMVEERR','mag','','','error in color index within effective aperture in Johnson B-V','0');
INSERT DBColumns VALUES('RC3','M21','','','','21-cm emission line magnitude, defined by by m_21 = 21.6 - 2.5 log(S_H), where S_H is the measured neutral hydrogen flux density in units of 10^-24 W/m^2.','0');
INSERT DBColumns VALUES('RC3','M21Q','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','M21ERR','','','','error in 21-cm emission line magnitude','0');
INSERT DBColumns VALUES('RC3','V21','km/s','','','mean heliocentric radial velocity from HI observations','0');
INSERT DBColumns VALUES('RC3','V21Q','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','V21ERR','km/s','','','error in heliocentric radial velocity','0');
INSERT DBColumns VALUES('RC3','HUBBLE_SRC','','','','sources of revised type estimate','0');
INSERT DBColumns VALUES('RC3','N_L','','','','number of luminosity class estimates','0');
INSERT DBColumns VALUES('RC3','LOGR_25','','','','mean decimal logarithm of the ratio of the major isophotal diameter, D_25, to the minor isophotal diameter, d_25, measured at or reduced to the surface brightness level mu_B = 25.0 B-mag/arcsec^2.','0');
INSERT DBColumns VALUES('RC3','LOGR_25Q','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','LOGR_25ERR','','','','error in  decimal logarithm of the ratio of the major isophotal diameter to minor','0');
INSERT DBColumns VALUES('RC3','AGB','mag','','','Burstein-Heiles Galactic extinction in B','0');
INSERT DBColumns VALUES('RC3','MB','mag','','','photographic magnitude reduced to B_T system','0');
INSERT DBColumns VALUES('RC3','MBQ','mag','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','MBERR','mag','','','error in photograph magnitude','0');
INSERT DBColumns VALUES('RC3','UMBT','mag','','','total (asymptotic) color index in Johnson U-B','0');
INSERT DBColumns VALUES('RC3','UMBTQ','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','UMBTERR','mag','','','error in total (asymptotic) color index in Johnson U-B','0');
INSERT DBColumns VALUES('RC3','UMBE','mag','','','color index within effective aperture in Johnson U-B','0');
INSERT DBColumns VALUES('RC3','UMBEQ','','','','quality flag ("?" if bad),','0');
INSERT DBColumns VALUES('RC3','UMBEERR','mag','','','error in color index within effective aperture in Johnson U-B','0');
INSERT DBColumns VALUES('RC3','W20','km/s','','','neutral hydrogen line full width (in km/s) measured at the 20% level (I_20/I_max)','0');
INSERT DBColumns VALUES('RC3','W20Q','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','W20ERR','km/s','','','error in W20','0');
INSERT DBColumns VALUES('RC3','VOPT','km/s','','','mean heliocentric radial velocity from optical observations','0');
INSERT DBColumns VALUES('RC3','VOPTQ','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','VOPTERR','km/s','','','error in mean heliocentric radial velocity from optical observations','0');
INSERT DBColumns VALUES('RC3','SGL','deg','','','supergalactic longitude','0');
INSERT DBColumns VALUES('RC3','SGB','deg','','','supergalactic latitude','0');
INSERT DBColumns VALUES('RC3','TYPE','','','','T = mean numerical index of stage along the Hubble sequence in the RC2 system (coded as explained in Section 3.3.c, page 16)','0');
INSERT DBColumns VALUES('RC3','TYPEQ','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','TYPEERR','','','','error in T-type','0');
INSERT DBColumns VALUES('RC3','LOGA_E','','','','decimal logarithm of the apparent diameter (in 0.1 arcmin) of the ``effective aperture,'''' the circle centered on the nucleus within which one-half of the total B-band flux is emitted','0');
INSERT DBColumns VALUES('RC3','LOGA_EQ','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','LOGA_EERR','','','','error in decimal logarithm of the apparent diameter (in 0.1 arcmin)  of the ``effective aperture,''''','0');
INSERT DBColumns VALUES('RC3','AIB','mag','','','internal extinction (for correction to face-on), calcauled from size and T-type','0');
INSERT DBColumns VALUES('RC3','MFIR','','','','far-infrared magnitude calculated from m_FIR = - 20.0 - 2.5 logFIR, where FIR is the far infrared continuum flux measured at 60 and 100 microns as listed in the IRAS Point Source Catalog (1987).','0');
INSERT DBColumns VALUES('RC3','BMVT0','mag','','','total B-V color index corrected for Galactic and internal extinction, and for redshift','0');
INSERT DBColumns VALUES('RC3','MPE','mag/sq arcmin','','','mean B-band surface brightness in magnitudes per square arcmin (B-mag/arcmin^2) within the effective aperture A_e, and its mean error, as given by the relation MPE = B_T + 0.75 + 5logA_e - 5.26.','0');
INSERT DBColumns VALUES('RC3','MPEQ','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','MPEERR','mag/sq arcmin','','','error in  mean B-band surface brightness','0');
INSERT DBColumns VALUES('RC3','W50','km/s','','','neutral hydrogen line full width (in km/s) measured at the 50% level (I_20/I_max)','0');
INSERT DBColumns VALUES('RC3','W50Q','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','W50ERR','km/s','','','error in neutral hydrogen line full width (in km/s) measured at the 50% level (I_20/I_max)','0');
INSERT DBColumns VALUES('RC3','VGSR','km/s','','','the weighted mean of the neutral hydrogen and optical velocities, corrected to the ``Galactic standard of rest''''','0');
INSERT DBColumns VALUES('RC3','L','','','','','0');
INSERT DBColumns VALUES('RC3','LQ','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','LERR','','','','mean numerical luminosity class in the RC2 system','0');
INSERT DBColumns VALUES('RC3','LOGD0','','','','decimal logarithm of the isophotal major diameter corrected to ``face-on'''' (inclination = 0 degrees), and corrected for Galactic extinction to A_g = 0, but not for redshift','0');
INSERT DBColumns VALUES('RC3','SA21','mag','','','HI line self-absorption in magnitudes (for correction to face-on), calculated from logR and T >= 1','0');
INSERT DBColumns VALUES('RC3','BT0','mag','','','B_T^0 = total ``face-on'''' magnitude corrected for Galactic and internal extinction, and for redshift','0');
INSERT DBColumns VALUES('RC3','UMBT0','mag','','','(U-B)_T^0 = total U-B color index corrected for Galactic and internal extinction, and for redshift','0');
INSERT DBColumns VALUES('RC3','MP25','mag/sq arcmin','','','the mean surface brightness in magnitudes per square arcmin (B-mag/arcmin^2) within the mu_B = 25.0 B-mag/arcsec^2 elliptical isophote of major axis D_25 and axis ratio R_25','0');
INSERT DBColumns VALUES('RC3','MP25Q','','','','quality flag ("?" if bad)','0');
INSERT DBColumns VALUES('RC3','MP25ERR','mag/sq arcmin','','','error inthe mean surface brightness within the mu_B = 25.0 B-mag/arcsec^2','0');
INSERT DBColumns VALUES('RC3','HI','','','','corrected neutral hydrogen index, which is the difference m_21^0 - B_T^0 between the corrected (face-on) 21-cm emission line magnitude and the similarly corrected magnitude in the B_T system.','0');
INSERT DBColumns VALUES('RC3','V3K','km/s','','','the weighted mean velocity corrected to the reference frame defined by the 3 K microwave background radiation','0');
INSERT DBColumns VALUES('ROSAT','OBJID','','','','Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].','0');
INSERT DBColumns VALUES('ROSAT','SOURCENAME','','','','name of source in ROSAT','0');
INSERT DBColumns VALUES('ROSAT','RA','deg','','','J2000 right ascension of ROSAT source','0');
INSERT DBColumns VALUES('ROSAT','DEC','deg','','','J2000 declination of ROSAT source','0');
INSERT DBColumns VALUES('ROSAT','RADECERR','arcsec','','','error in coordinates','0');
INSERT DBColumns VALUES('ROSAT','FLAGS','','','','screening flags (see ROSAT documentation)','0');
INSERT DBColumns VALUES('ROSAT','FLAGS2','','','','screening flags (see ROSAT documentation)','0');
INSERT DBColumns VALUES('ROSAT','CPS','','','','counts per second in broad band','0');
INSERT DBColumns VALUES('ROSAT','CPS_ERR','','','','error in count rate','0');
INSERT DBColumns VALUES('ROSAT','BGCPS','','','','counts per second from background','0');
INSERT DBColumns VALUES('ROSAT','EXPTIME','sec','','','exposure time','0');
INSERT DBColumns VALUES('ROSAT','HR1','','','','hardness ratio 1','0');
INSERT DBColumns VALUES('ROSAT','HR1_ERR','','','','error in hardness ratio 1','0');
INSERT DBColumns VALUES('ROSAT','HR2','','','','hardness ratio 2','0');
INSERT DBColumns VALUES('ROSAT','HR2_ERR','','','','error in hardness ratio 2','0');
INSERT DBColumns VALUES('ROSAT','EXT','arcsec','','','source extent','0');
INSERT DBColumns VALUES('ROSAT','EXTL','','','','likelihood of source extent','0');
INSERT DBColumns VALUES('ROSAT','SRCL','','','','likelihood of source detection','0');
INSERT DBColumns VALUES('ROSAT','EXTR','arcsec','','','extraction radius','0');
INSERT DBColumns VALUES('ROSAT','PRIORITY','','','','priority flags (Sliding window detection history using either the background map (M) or the local background (B); 0 = no detection, 1 = detection; order of flags: M-broad, L-broad, M-hard, L-hard, M-soft, L-soft','0');
INSERT DBColumns VALUES('ROSAT','ERANGE','','','','pulse height amplitude range with highest detection likelihood; A: 11-41, B: 52-201, C: 52-90, D: 91-201 '' '' or ''b'' means ''broad'' (11-235)','0');
INSERT DBColumns VALUES('ROSAT','VIGF','','','','vignetting factor','0');
INSERT DBColumns VALUES('ROSAT','ORGDAT','','','','date when source was included (format: yymmdd; 000000: removed)','0');
INSERT DBColumns VALUES('ROSAT','MODDAT','','','','date when source was modified (format: yymmdd; 000000: removed)','0');
INSERT DBColumns VALUES('ROSAT','ID','','','','number of identification candidates in correlation catalog','0');
INSERT DBColumns VALUES('ROSAT','FIELDID','','','','identification number of SASS field','0');
INSERT DBColumns VALUES('ROSAT','SRCNUM','','','','SASS source number in SASS field','0');
INSERT DBColumns VALUES('ROSAT','RCT1','','','','number of nearby RASS detections with distances between 0 and 5 arcmin','0');
INSERT DBColumns VALUES('ROSAT','RCT2','','','','number of nearby RASS detections with distances between 5 and 10 arcmin','0');
INSERT DBColumns VALUES('ROSAT','RCT3','','','','number of nearby RASS detections with distances between 10 and 15 arcmin','0');
INSERT DBColumns VALUES('ROSAT','ITB','','','','start time of observation (yymmdd.ff)','0');
INSERT DBColumns VALUES('ROSAT','ITE','','','','end time of observation (yymmdd.ff)','0');
INSERT DBColumns VALUES('ROSAT','RL','','','','reliability of source detection (0 to 99, with 99 being highest)','0');
INSERT DBColumns VALUES('ROSAT','CAT','','','','which catalog the source is in (faint or bright)','0');
INSERT DBColumns VALUES('USNO','OBJID','','ID_MAIN','','unique id, points to photoObj','0');
INSERT DBColumns VALUES('USNO','RA','deg','','','J2000 right ascension in USNO-B1.0','0');
INSERT DBColumns VALUES('USNO','DEC','deg','','','J2000 declination in USNO-B1.0','0');
INSERT DBColumns VALUES('USNO','RAERR','arcsec','','','error in R.A.','0');
INSERT DBColumns VALUES('USNO','DECERR','arcsec','','','error in Dec','0');
INSERT DBColumns VALUES('USNO','MEANEPOCH','years','','','mean epoch of RA/Dec','0');
INSERT DBColumns VALUES('USNO','MURA','mas/yr','','','proper motion in RA','0');
INSERT DBColumns VALUES('USNO','MUDEC','mas/yr','','','proper motion in Dec','0');
INSERT DBColumns VALUES('USNO','PROPERMOTION','0.01 arcsec/yr','','','total proper motion','0');
INSERT DBColumns VALUES('USNO','ANGLE','deg','','','position angle of proper motion (East of North)','0');
INSERT DBColumns VALUES('USNO','MURAERR','mas/yr','','','error in proper motion in RA','0');
INSERT DBColumns VALUES('USNO','MUDECERR','mas/yr','','','error in proper motion in Dec','0');
INSERT DBColumns VALUES('USNO','MUPROB','','','','probability of proper motion','0');
INSERT DBColumns VALUES('USNO','MUFLAG','','','','proper motion flag (0 no, 1 yes)','0');
INSERT DBColumns VALUES('USNO','SFITRA','mas','','','sigma of individual observations around best fit motion in RA','0');
INSERT DBColumns VALUES('USNO','SFITDEC','mas','','','sigma of individual observations around best fit motion in RA','0');
INSERT DBColumns VALUES('USNO','NFITPT','','','','number of observations used in the fit','0');
INSERT DBColumns VALUES('USNO','MAG_B1','mag','','','','0');
INSERT DBColumns VALUES('USNO','MAG_R1','mag','','','','0');
INSERT DBColumns VALUES('USNO','MAG_B2','mag','','','','0');
INSERT DBColumns VALUES('USNO','MAG_R2','mag','','','','0');
INSERT DBColumns VALUES('USNO','MAG_I2','mag','','','','0');
INSERT DBColumns VALUES('USNO','FLDID_B1','','','','field id in first blue survey','0');
INSERT DBColumns VALUES('USNO','FLDID_R1','','','','field id in first red survey','0');
INSERT DBColumns VALUES('USNO','FLDID_B2','','','','field id in second blue survey','0');
INSERT DBColumns VALUES('USNO','FLDID_R2','','','','field id in second red survey','0');
INSERT DBColumns VALUES('USNO','FLDID_I2','','','','field id in N survey','0');
INSERT DBColumns VALUES('USNO','SG_B1','','','','star/galaxy separation flag in first blue survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar)','0');
INSERT DBColumns VALUES('USNO','SG_R1','','','','star/galaxy separation flag in first red survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar)','0');
INSERT DBColumns VALUES('USNO','SG_B2','','','','star/galaxy separation flag in second blue survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar)','0');
INSERT DBColumns VALUES('USNO','SG_R2','','','','star/galaxy separation flag in second red survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar)','0');
INSERT DBColumns VALUES('USNO','SG_I2','','','','star/galaxy separation flag in N survey (values of 0 to 3 are probably stellar, values of 8 to 11 are probably non-stellar)','0');
INSERT DBColumns VALUES('USNO','FLDEPOCH_B1','','','','epoch of observation in first blue survey','0');
INSERT DBColumns VALUES('USNO','FLDEPOCH_R1','','','','epoch of observation in first red survey','0');
INSERT DBColumns VALUES('USNO','FLDEPOCH_B2','','','','epoch of observation in second blue survey','0');
INSERT DBColumns VALUES('USNO','FLDEPOCH_R2','','','','epoch of observation in second red survey','0');
INSERT DBColumns VALUES('USNO','FLDEPOCH_I2','','','','epoch of observation in N survey','0');
INSERT DBColumns VALUES('galSpecExtra','specObjID','','ID_CATALOG','','Unique ID','0');
INSERT DBColumns VALUES('galSpecExtra','bptclass','','','','Emission line classification based on the BPT diagram using the methodology described in Brinchmann et al (2004). -1 means unclassifiable, 1 is star-forming, 2 means low S/N star-forming, 3 is composite, 4 AGN (excluding liners) and 5 is a low S/N LINER.','0');
INSERT DBColumns VALUES('galSpecExtra','oh_p2p5','','','','The 2.5 percentile of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.','0');
INSERT DBColumns VALUES('galSpecExtra','oh_p16','','','','The 16 percentile of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.','0');
INSERT DBColumns VALUES('galSpecExtra','oh_p50','','','','The median estimate of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.','0');
INSERT DBColumns VALUES('galSpecExtra','oh_p84','','','','The 84th percentile of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.','0');
INSERT DBColumns VALUES('galSpecExtra','oh_p97p5','','','','The 97.5 percentile of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.','0');
INSERT DBColumns VALUES('galSpecExtra','oh_entropy','','','','The entropy (Sum p*lg(p)) of the PDF of 12 + Log O/H','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_tot_p2p5','Log solar masses','','','The 2.5 percentile of the Log total stellar mass PDF using model photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_tot_p16','Log solar masses','','','The 16th percentile of the Log total stellar mass PDF using model photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_tot_p50','Log solar masses','','','The median estimate of the Log total stellar mass PDF using model photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_tot_p84','Log solar masses','','','The 84th percentile of the Log total stellar mass PDF using model photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_tot_p97p5','Log solar masses','','','The 97.5 percentile of the Log total stellar mass PDF using model photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_fib_p2p5','Log solar masses','','','The 2.5 percentile of the Log stellar mass within the fibre PDF using fibre photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_fib_p16','Log solar masses','','','The 16th percentile of the Log stellar mass within the fibre PDF using fibre photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_fib_p50','Log solar masses','','','The median estimate of the Log stellar mass within the fibre PDF using fibre photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_fib_p84','Log solar masses','','','The 84th percentile of the Log stellar mass within the fibre PDF using fibre photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','lgm_fib_p97p5','Log solar masses','','','The 97.5 percentile of the Log stellar mass within the fibre PDF using fibre photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_tot_p2p5','Log Msun/yr','','','The 2.5 percentile of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_tot_p16','Log Msun/yr','','','The 16th percentile of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_tot_p50','Log Msun/yr','','','The median estimate of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_tot_p84','Log Msun/yr','','','The 84th percentile of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_tot_p97p5','Log Msun/yr','','','The 97.5 percentile of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_tot_entropy','','','','The entropy (Sum p*lg(p)) of the PDF of the total SFR','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_fib_p2p5','Log Msun/yr','','','The 2.5 percentile of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_fib_p16','Log Msun/yr','','','The 16th percentile of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_fib_p50','Log Msun/yr','','','The median estimate of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_fib_p84','Log Msun/yr','','','The 84th percentile of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_fib_p97p5','Log Msun/yr','','','The 97.5 percentile of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','sfr_fib_entropy','','','','The entropy (Sum p*lg(p)) of the PDF of the fiber SFR','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_tot_p2p5','Log Msun/yr','','','The 2.5 percentile of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_tot_p16','Log Msun/yr','','','The 16th percentile of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_tot_p50','Log Msun/yr','','','The median estimate of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_tot_p84','Log Msun/yr','','','The 84th percentile of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_tot_p97p5','Log Msun/yr','','','The 97.5 percentile of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry.','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_tot_entropy','','','','The entropy (Sum p*lg(p)) of the PDF of the total SPECSFR','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_fib_p2p5','Log Msun/yr','','','The 2.5 percentile of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_fib_p16','Log Msun/yr','','','The 16th percentile of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_fib_p50','Log Msun/yr','','','The median estimate of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_fib_p84','Log Msun/yr','','','The 84th percentile of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_fib_p97p5','Log Msun/yr','','','The 97.5 percentile of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry..','0');
INSERT DBColumns VALUES('galSpecExtra','specsfr_fib_entropy','','','','The entropy (Sum p*lg(p)) of the PDF of the fiber SPECSFR','0');
INSERT DBColumns VALUES('galSpecIndx','specObjID','','ID_CATALOG','','Unique ID','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn1','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn1_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn1_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn1_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn1_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn2','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn2_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn2_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn2_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_cn2_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4227','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4227_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4227_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4227_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4227_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_g4300','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_g4300_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_g4300_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_g4300_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_g4300_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4383','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4383_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4383_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4383_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4383_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4455','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4455_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4455_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4455_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_ca4455_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4531','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4531_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4531_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4531_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe4531_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_c4668','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_c4668_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_c4668_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_c4668_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_c4668_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hb','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hb_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hb_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hb_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hb_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5015','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5015_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5015_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5015_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5015_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg1','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg1_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg1_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg1_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg1_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg2','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg2_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg2_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg2_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mg2_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mgb','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mgb_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mgb_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mgb_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_mgb_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5270','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5270_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5270_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5270_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5270_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5335','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5335_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5335_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5335_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5335_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5406','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5406_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5406_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5406_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5406_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5709','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5709_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5709_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5709_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5709_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5782','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5782_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5782_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5782_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_fe5782_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_nad','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_nad_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_nad_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_nad_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_nad_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio1','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio1_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio1_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio1_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio1_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio2','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio2_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio2_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio2_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_tio2_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_a','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_a_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_a_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_a_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_a_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_a','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_a_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_a_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_a_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_a_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_f','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_f_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_f_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_f_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hd_f_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_f','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_f_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_f_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_f_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','lick_hg_f_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8498','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8498_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8498_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8498_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8498_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8542','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8542_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8542_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8542_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8542_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8662','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8662_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8662_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8662_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_caii8662_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_mgi8807','A','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_mgi8807_err','A','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_mgi8807_model','A','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_mgi8807_sub','A','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','dtt_mgi8807_sub_err','A','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cnb','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cnb_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cnb_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cnb_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cnb_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hk','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hk_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hk_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hk_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hk_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cai','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cai_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cai_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cai_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_cai_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_g','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_g_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_g_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_g_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_g_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hb','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hb_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hb_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hb_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_hb_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mgg','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mgg_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mgg_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mgg_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mgg_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mh','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mh_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mh_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mh_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_mh_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_fc','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_fc_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_fc_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_fc_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_fc_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_nad','mag','','','Restframe index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_nad_err','mag','','','Error on index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','bh_nad_model','mag','','','Index of best fit model spectrum','0');
INSERT DBColumns VALUES('galSpecIndx','bh_nad_sub','mag','','','Restframe index measurement on the data after subtracting all 3-sigma emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','bh_nad_sub_err','mag','','','Error in the above index measurement','0');
INSERT DBColumns VALUES('galSpecIndx','d4000','','','','4000AA break, Bruzual (1983) definition','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_err','','','','Uncertainty estimate for 4000AA break, Bruzual (1983) definition','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_model','','','','4000AA break, Bruzual (1983) definition measured off best-fit CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_sub','','','','4000AA break, Bruzual (1983) definition after correction for emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_sub_err','','','','Uncertainty estimate for 4000AA break, Bruzual (1983) definition after correction for emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n','','','','4000AA break, Balogh et al (1999) definition','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n_err','','','','Uncertainty estimate for 4000AA break, Balogh et al (1999) definition','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n_model','','','','4000AA break, Balogh et al (1999) definition measured off best-fit CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n_sub','','','','4000AA break, Balogh et al (1999) definition after correction for emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n_sub_err','','','','Uncertainty estimate for 4000AA break, Balogh et al (1999) definition after correction for emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_red','','','','The flux in the red window of the Bruzual (1983) definition of D4000','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_blue','','','','The flux in the blue window of the Bruzual (1983) definition of D4000','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n_red','','','','The flux in the red window of the Balogh et al (1999) definition of D4000','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n_blue','','','','The flux in the blue window of the Balogh et al (1999) definition of D4000','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_sub_red','','','','The flux in the red window of the Bruzual (1983) definition of D4000 after subtraction of emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_sub_blue','','','','The flux in the blue window of the Bruzual (1983) definition of D4000 after subtraction of emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n_sub_red','','','','The flux in the red window of the Balogh et al (1999) definition of D4000 after subtraction of emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','d4000_n_sub_blue','','','','The flux in the blue window of the Balogh et al (1999)q definition of D4000 after subtraction of emission lines','0');
INSERT DBColumns VALUES('galSpecIndx','tauv_model_040','','','','Dust attenuation of the best fit Z=0.004 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','model_coef_040','','','','The scaling coefficients of the best fit Z=0.004 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','model_chisq_040','','','','The chi^2 of the best fit Z=0.004 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','tauv_model_080','','','','Dust attenuation of the best fit Z=0.008 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','model_coef_080','','','','The scaling coefficients of the best fit Z=0.008 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','model_chisq_080','','','','The chi^2 of the best fit Z=0.008 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','tauv_model_170','','','','Dust attenuation of the best fit Z=0.017 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','model_coef_170','','','','The scaling coefficients of the best fit Z=0.017 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','model_chisq_170','','','','The chi^2 of the best fit Z=0.017 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','tauv_model_400','','','','Dust attenuation of the best fit Z=0.04 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','model_coef_400','','','','The scaling coefficients of the best fit Z=0.04 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','model_chisq_400','','','','The chi^2 of the best fit Z=0.04 CB08 model','0');
INSERT DBColumns VALUES('galSpecIndx','best_model_z','','','','Metallicity of best fitting (min chisq) model Z = 0.004 / 0.017 / 0.050 (0.2 1.0, 2.5 x solar)','0');
INSERT DBColumns VALUES('galSpecIndx','tauv_cont','','','','V-band optical depth (TauV = A_V / 1.086) affecting the stars from best fit model (best of 4 Z''s)','0');
INSERT DBColumns VALUES('galSpecIndx','model_coef','','','','Coeficients of best fit model (best of 4 Z''s)','0');
INSERT DBColumns VALUES('galSpecIndx','model_chisq','','','','Reduced chi-squared of best fit model (best of 4 Z''s)','0');
INSERT DBColumns VALUES('galSpecInfo','specObjID','','ID_CATALOG','','Unique ID','0');
INSERT DBColumns VALUES('galSpecInfo','plateid','','','','Plate number','0');
INSERT DBColumns VALUES('galSpecInfo','mjd','','','','Modified Julian Date of plate observation','0');
INSERT DBColumns VALUES('galSpecInfo','fiberid','','','','Fiber number (1 - 640)','0');
INSERT DBColumns VALUES('galSpecInfo','ra','degrees','','','Right Ascention of drilled fiber position','0');
INSERT DBColumns VALUES('galSpecInfo','dec','degrees','','','Declination of drilled fiber position','0');
INSERT DBColumns VALUES('galSpecInfo','primtarget','','','','Primary Target Flag (MAIN galaxy = 64)','0');
INSERT DBColumns VALUES('galSpecInfo','sectarget','','','','Secondary Target Flag (QA = 8)','0');
INSERT DBColumns VALUES('galSpecInfo','targettype','','','','Text version of primary target (GALAXY/QA/QSO/ROSAT_D)','0');
INSERT DBColumns VALUES('galSpecInfo','spectrotype','','','','Schlegel classification of spectrum ... code is only run where this is set to "GALAXY"','0');
INSERT DBColumns VALUES('galSpecInfo','subclass','','','','Schlegel subclass from PCA analysis -- not alwasy correct!! AGN/BROADLINE/STARBURST/STARFORMING','0');
INSERT DBColumns VALUES('galSpecInfo','z','','','','Redshift from Schlegel','0');
INSERT DBColumns VALUES('galSpecInfo','z_err','','','','Redshift error','0');
INSERT DBColumns VALUES('galSpecInfo','z_warning','','','','Bad redshift if this is non-zero -- see Schlegel data model','0');
INSERT DBColumns VALUES('galSpecInfo','v_disp','km/s','','','Velocity dispersion from Schlegel','0');
INSERT DBColumns VALUES('galSpecInfo','v_disp_err','km/s','','','Velocity dispersion error (negative for invalid fit)','0');
INSERT DBColumns VALUES('galSpecInfo','sn_median','','','','Median S/N per pixel of the whole spectrum','0');
INSERT DBColumns VALUES('galSpecInfo','e_bv_sfd','','','','E(B-V) of foreground reddening from SFD maps','0');
INSERT DBColumns VALUES('galSpecInfo','release','','','','Data Release (dr1/dr2/dr3/dr4)','0');
INSERT DBColumns VALUES('galSpecInfo','reliable','','','','has "reliable" line measurements and physical parameters','0');
INSERT DBColumns VALUES('galSpecLine','specObjID','','ID_CATALOG','','Unique ID','0');
INSERT DBColumns VALUES('galSpecLine','sigma_balmer','km/s','','','Velocity dispersion (sigma not FWHM) measured simultaneously in all of the Balmer lines','0');
INSERT DBColumns VALUES('galSpecLine','sigma_balmer_err','km/s','','','Error in the above','0');
INSERT DBColumns VALUES('galSpecLine','sigma_forbidden','km/s','','','Velocity dispersion (sigma not FWHM) measured simultaneously in all the forbidden lines','0');
INSERT DBColumns VALUES('galSpecLine','sigma_forbidden_err','km/s','','','Error in the above','0');
INSERT DBColumns VALUES('galSpecLine','v_off_balmer','km/s','','','Velocity offset of the Balmer lines from the measured redshift','0');
INSERT DBColumns VALUES('galSpecLine','v_off_balmer_err','km/s','','','Error in the above','0');
INSERT DBColumns VALUES('galSpecLine','v_off_forbidden','km/s','','','Velocity offset of the forbidden lines from the measured redshift','0');
INSERT DBColumns VALUES('galSpecLine','v_off_forbidden_err','km/s','','','Error in the above','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','oii_3726_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','oii_3729_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','neiii_3869_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','h_delta_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','h_gamma_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4363_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','h_beta_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_4959_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_5007_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','hei_5876_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','oi_6300_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','nii_6548_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','h_alpha_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','nii_6584_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','sii_6717_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','sii_6731_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_cont','1e-17 erg/s/cm^2/AA','','','Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_cont_err','1e-17 erg/s/cm^2/AA','','','Error in the continuum computed from the variance in the band pass','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_reqw','Ang','','','The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW)','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_reqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_eqw','Ang','','','The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT.','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_eqw_err','Ang','','','Error in the equivalent width described above','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_flux','1e-17 erg/s/cm^2','','','Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically)','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_flux_err','1e-17 erg/s/cm^2','','','Error in the flux','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_inst_res','1e-17 erg/s/cm^2','','','Instrumental resolution at the line center (measured for each spectrum from the ARC lamps)','0');
INSERT DBColumns VALUES('galSpecLine','ariii7135_chisq','1e-17 erg/s/cm^2','','','Reduced chi-squared of the line fit over the bandpass used for the EW measurement','0');
INSERT DBColumns VALUES('galSpecLine','oii_sigma','km/s','','','The width of the [O II] line in a free fit (ie. not tied to other emission lines)','0');
INSERT DBColumns VALUES('galSpecLine','oii_flux','1e-17 erg/s/cm^2','','','The flux of the [O II] doublet from a free fit.','0');
INSERT DBColumns VALUES('galSpecLine','oii_flux_err','1e-17 erg/s/cm^2','','','The estimated uncertainty on OII_FLUX','0');
INSERT DBColumns VALUES('galSpecLine','oii_voff','km/s','','','The velocity offset of the [O II] doublet from a free fit','0');
INSERT DBColumns VALUES('galSpecLine','oii_chi2','','','','chi^2 of the fit to the [O II] line in free fit','0');
INSERT DBColumns VALUES('galSpecLine','oiii_sigma','km/s','','','The width of the [O III]5007 line in a free fit (ie. not tied to other emission lines)','0');
INSERT DBColumns VALUES('galSpecLine','oiii_flux','1e-17 erg/s/cm^2','','','The flux of the [O III]5007 line from a free fit.','0');
INSERT DBColumns VALUES('galSpecLine','oiii_flux_err','1e-17 erg/s/cm^2','','','The estimated uncertainty on OIII_FLUX','0');
INSERT DBColumns VALUES('galSpecLine','oiii_voff','km/s','','','The velocity offset of the [O III]5007 line from a free fit','0');
INSERT DBColumns VALUES('galSpecLine','oiii_chi2','','','','chi^2 of the fit to the [O III]5007 line in free fit','0');
INSERT DBColumns VALUES('galSpecLine','spectofiber','','','','The multiplicative scale factor applied to the original flux and error spectra prior to measurement of the emission lines to improve the spectrophotometric accuracy.  The rescaling insures that a synthetic r-band magnitude computed from the spectrum matches the r-band fiber magnitude measured by the photometric pipeline.','0');
INSERT DBColumns VALUES('detectionIndex','thingId','','','','thing ID number','0');
INSERT DBColumns VALUES('detectionIndex','objId','','','','object ID number (from run, camcol, field, id, rerun)','0');
INSERT DBColumns VALUES('detectionIndex','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('thingIndex','thingId','','','','thing ID number','0');
INSERT DBColumns VALUES('thingIndex','sdssPolygonID','','','','id number of polygon containing object in sdssPolygons','0');
INSERT DBColumns VALUES('thingIndex','fieldID','','','','field identification of primary field','0');
INSERT DBColumns VALUES('thingIndex','objID','','','','id of object for primary (or best) observation','0');
INSERT DBColumns VALUES('thingIndex','isPrimary','','','','Non-zero if there is a detection of this object in the primary field covering this balkan.','0');
INSERT DBColumns VALUES('thingIndex','nDetect','','','','Number of detections of this object.','0');
INSERT DBColumns VALUES('thingIndex','nEdge','','','','Number of fields in which this is a RUN_EDGE object (observation close to edge)','0');
INSERT DBColumns VALUES('thingIndex','ra','','','','Right ascension, J2000 deg','0');
INSERT DBColumns VALUES('thingIndex','dec','','','','Declination, J2000 deg','0');
INSERT DBColumns VALUES('thingIndex','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('Neighbors','objID','','ID_CATALOG','','The unique objId of the center object','0');
INSERT DBColumns VALUES('Neighbors','neighborObjID','','ID_CATALOG','','The objId of the neighbor','0');
INSERT DBColumns VALUES('Neighbors','distance','arcmins','POS_ANG_DIST_GENERAL','','Distance between center and neighbor','0');
INSERT DBColumns VALUES('Neighbors','type','','CLASS_OBJECT','','Object type of the center','0');
INSERT DBColumns VALUES('Neighbors','neighborType','','CLASS_OBJECT','','Object type of the neighbor','0');
INSERT DBColumns VALUES('Neighbors','mode','','CODE_MISC','','object is primary, secondary, family, outside','0');
INSERT DBColumns VALUES('Neighbors','neighborMode','','CODE_MISC','','is neighbor primary, secondary, family, outside','0');
INSERT DBColumns VALUES('Zone','zoneID','','EXTENSION_AREA','','id counts from -90 degrees == 0','0');
INSERT DBColumns VALUES('Zone','ra','deg','POS_EQ_RA_MAIN','','ra of object','0');
INSERT DBColumns VALUES('Zone','dec','deg','POS_EQ_DEC_MAIN','','declination of object','0');
INSERT DBColumns VALUES('Zone','objID','','ID_CATALOG','','object ID','0');
INSERT DBColumns VALUES('Zone','type','','CLASS_OBJECT','','object type (star, galaxy)','0');
INSERT DBColumns VALUES('Zone','mode','','CODE_MISC','','mode is primary, secondary, family, outside','0');
INSERT DBColumns VALUES('Zone','cx','','POS_EQ_CART_X','','Cartesian x of the object','0');
INSERT DBColumns VALUES('Zone','cy','','POS_EQ_CART_Y','','Cartesian y of the object','0');
INSERT DBColumns VALUES('Zone','cz','','POS_EQ_CART_Z','','Cartesian z of the object','0');
INSERT DBColumns VALUES('Zone','native','','CODE_MISC','','true if obj is local, false if from the destination dataset','0');
INSERT DBColumns VALUES('PlateX','plateID','','ID_PLATE','','Unique ID, composite of plate number and MJD','0');
INSERT DBColumns VALUES('PlateX','firstRelease','','','','Name of release that this plate/mjd/rerun was first distributed in','0');
INSERT DBColumns VALUES('PlateX','run2d','','','','2d Reduction rerun of plate','0');
INSERT DBColumns VALUES('PlateX','run1d','','','','1d Reduction rerun of plate','0');
INSERT DBColumns VALUES('PlateX','runsspp','','','','SSPP Reduction rerun of plate  ("none" if not run)','0');
INSERT DBColumns VALUES('PlateX','plate','','','','plate number','0');
INSERT DBColumns VALUES('PlateX','tile','','','','Tile number for SDSS-I, -II plates (-1 for SDSS-III) [from platelist product]','0');
INSERT DBColumns VALUES('PlateX','designID','','','','Design number number for SDSS-III plates (-1 for SDSS-I, -II) [from platelist product]','0');
INSERT DBColumns VALUES('PlateX','locationID','','','','Location number number for SDSS-III plates (-1 for SDSS-I, -II) [from platelist product]','0');
INSERT DBColumns VALUES('PlateX','mjd','days','','','MJD of observation (last)','0');
INSERT DBColumns VALUES('PlateX','mjdList','','','','List of contributing MJDs [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','ra','deg','','','RA, J2000 [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','dec','deg','','','Dec, J2000 [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','iopVersion','','','','IOP Version [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','camVersion','','','','Camera code version  [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','taiHMS','','','','Time in string format [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','dateObs','','','','Date of 1st row [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','timeSys','','','','Time System [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','cx','','','','x of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('PlateX','cy','','','','y of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('PlateX','cz','','','','z of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('PlateX','cartridgeID','','','','ID of cartridge used for the observation [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','tai','sec','','','Mean time (TAI) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','taiBegin','sec','','','Beginning time (TAI) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','taiEnd','sec','','','Ending time (TAI) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','airmass','','','','Airmass at central TAI time [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','mapMjd','days','','','Map MJD [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','mapName','','','','ID of mapping file [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','plugFile','','','','Full name of mapping file [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','expTime','sec','','','Total Exposure time [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','expTimeB1','sec','','','exposure time in B1 spectrograph [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','expTimeB2','sec','','','exposure time in B2 spectrograph [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','expTimeR1','sec','','','exposure time in R1 spectrograph [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','expTimeR2','sec','','','exposure time in R2 spectrograph [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','vers2d','','','','idlspec2d version used during 2d reduction [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','verscomb','','','','idlspec2d version used during combination of multiple exposures [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','vers1d','','','','idlspec2d version used during redshift fitting [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','survey','','','','Name of survey [from platelist product]','0');
INSERT DBColumns VALUES('PlateX','programName','','','','Name of program [from platelist product]','0');
INSERT DBColumns VALUES('PlateX','chunk','','','','Name of tiling chunk  [from platelist product]','0');
INSERT DBColumns VALUES('PlateX','plateRun','','','','Drilling run for plate [from platelist product]','0');
INSERT DBColumns VALUES('PlateX','designComments','','','','Comments on the plate design from plate plans [from platelist product]','0');
INSERT DBColumns VALUES('PlateX','plateQuality','','','','Characterization of plate quality','0');
INSERT DBColumns VALUES('PlateX','qualityComments','','','','Comments on reason for plate quality','0');
INSERT DBColumns VALUES('PlateX','platesn2','','','','Overall signal to noise measure for plate','0');
INSERT DBColumns VALUES('PlateX','snturnoff','','','','Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate)','0');
INSERT DBColumns VALUES('PlateX','nturnoff','','','','Number of MS turnoff stars on plate','0');
INSERT DBColumns VALUES('PlateX','nExp','','','','Number of exposures total [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','nExpB1','','','','Number of exposures in B1 spectrograph  [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','nExpB2','','','','Number of exposures in B2 spectrograph  [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','nExpR1','','','','Number of exposures in R1 spectrograph  [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','nExpR2','','','','Number of exposures in R2 spectrograph  [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','sn1_g','','','','(S/N)^2 at g=20.20 for spectrograph #1 [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','sn1_r','','','','(S/N)^2 at r=20.25 for spectrograph #1 [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','sn1_i','','','','(S/N)^2 at i=19.90 for spectrograph #1 [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','sn2_g','','','','(S/N)^2 at g=20.20 for spectrograph #2 [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','sn2_r','','','','(S/N)^2 at r=20.25 for spectrograph #2 [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','sn2_i','','','','(S/N)^2 at i=19.90 for spectrograph #2 [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','helioRV','km/s','','','Heliocentric velocity correction [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','gOffStd','mag','','','Mean g-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','gRMSStd','mag','','','Stddev of g-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','rOffStd','mag','','','Mean r-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','rRMSStd','mag','','','Stddev of r-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','iOffStd','mag','','','Mean i-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','iRMSStd','mag','','','Stddev of i-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','grOffStd','mag','','','Mean g-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','grRMSStd','mag','','','Stddev of g-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','riOffStd','mag','','','Mean r-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','riRMSStd','mag','','','Stddev of r-band mag difference (spectro - photo) for standards [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','gOffGal','mag','','','Mean g-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','gRMSGal','mag','','','Stddev of g-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','rOffGal','mag','','','Mean r-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','rRMSGal','mag','','','Stddev of r-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','iOffGal','mag','','','Mean i-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','iRMSGal','mag','','','Stddev of i-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','grOffGal','mag','','','Mean g-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','grRMSGal','mag','','','Stddev of g-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','riOffGal','mag','','','Mean r-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','riRMSGal','mag','','','Stddev of r-band mag difference (spectro - photo) for galaxies [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','nGuide','','','','Number of guider camera frames taken during the exposure [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','seeing20','','','','20th-percentile of seeing during exposure (arcsec) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','seeing50','','','','50th-percentile of seeing during exposure (arcsec) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','seeing80','','','','80th-percentile of seeing during exposure (arcsec) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','rmsoff20','','','','20th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','rmsoff50','','','','50th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','rmsoff80','','','','80th-percentile of RMS offset of guide fibers (arcsec) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','airtemp','deg Celsius','','','Air temperature in the dome [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','sfd_used','','','','Were the SFD dust maps applied to the output spectrum? (0 = no, 1 = yes)','0');
INSERT DBColumns VALUES('PlateX','xSigma','','','','sigma of gaussian fit to spatial profile[from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','xSigMin','','','','minimum of xSigma for all exposures [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','xSigMax','','','','maximum of xSigma for all exposures [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','wSigma','','','','sigma of gaussian fit to arc-line profiles in wavelength direction [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','wSigMin','','','','minimum of wSigma for all exposures [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','wSigMax','','','','maximum of wSigma for all exposures [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','xChi2','','','','[from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','xChi2Min','','','','[from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','xChi2Max','','','','[from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','skyChi2','','','','average chi-squared from sky subtraction from all exposures [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','skyChi2Min','','','','minimum skyChi2 over all exposures [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','skyChi2Max','','','','maximum skyChi2 over all exposures [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','fBadPix','','','','Fraction of pixels that are bad (total) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','fBadPix1','','','','Fraction of pixels that are bad (spectrograph #1) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','fBadPix2','','','','Fraction of pixels that are bad (spectrograph #2) [from spPlate header]','0');
INSERT DBColumns VALUES('PlateX','status2d','','','','Status of 2D extraction','0');
INSERT DBColumns VALUES('PlateX','statuscombine','','','','Status of combination of multiple MJDs','0');
INSERT DBColumns VALUES('PlateX','status1d','','','','Status of 1D reductions','0');
INSERT DBColumns VALUES('PlateX','nGalaxy','','','','Number of objects classified as galaxy [calculated from spZbest file]','0');
INSERT DBColumns VALUES('PlateX','nQSO','','','','Number of objects classified as QSO [calculated from spZbest file]','0');
INSERT DBColumns VALUES('PlateX','nStar','','','','Number of objects classified as Star [calculated from spZbest file]','0');
INSERT DBColumns VALUES('PlateX','nSky','','','','Number of sky objects  [calculated from spZbest file]','0');
INSERT DBColumns VALUES('PlateX','nUnknown','','','','Number of objects with zWarning set non-zero (such objects still classified as star, galaxy or QSO) [calculated from spZbest file]','0');
INSERT DBColumns VALUES('PlateX','isBest','','','','is this plateX entry the best observation of the plate','0');
INSERT DBColumns VALUES('PlateX','isPrimary','','','','is this plateX entry both good and the best observation of the plate','0');
INSERT DBColumns VALUES('PlateX','isTile','','','','is this plate the best representative  of its tile (only set for "legacy" program plates)','0');
INSERT DBColumns VALUES('PlateX','ha','deg','POS_EQ_RA','','hour angle of design [from plPlugMapM file]','0');
INSERT DBColumns VALUES('PlateX','mjdDesign','','MJD','','MJD designed for [from plPlugMapM file]','0');
INSERT DBColumns VALUES('PlateX','theta','','POS_POS-ANG','','cartridge position angle [from plPlugMapM file]','0');
INSERT DBColumns VALUES('PlateX','fscanVersion','','','','version of fiber scanning software [from plPlugMapM file]','0');
INSERT DBColumns VALUES('PlateX','fmapVersion','','','','version of fiber mapping software [from plPlugMapM file]','0');
INSERT DBColumns VALUES('PlateX','fscanMode','','','','''slow'', ''fast'', or ''extreme'' [from plPlugMapM file]','0');
INSERT DBColumns VALUES('PlateX','fscanSpeed','','','','speed of scan [from plPlugMapM file]','0');
INSERT DBColumns VALUES('PlateX','htmID','','','','20 deep Hierarchical Triangular Mesh ID','0');
INSERT DBColumns VALUES('PlateX','loadVersion','','','','Load Version','0');
INSERT DBColumns VALUES('SpecObjAll','specObjID','','ID_CATALOG','','Unique database ID based on PLATE, MJD, FIBERID, RUN2D','0');
INSERT DBColumns VALUES('SpecObjAll','bestObjID','','ID_MAIN','','Object ID of photoObj match (flux-based)','0');
INSERT DBColumns VALUES('SpecObjAll','origObjID','','ID_MAIN','','Object ID of photoObj match (position-based)','0');
INSERT DBColumns VALUES('SpecObjAll','targetObjID','','ID_CATALOG','','Object ID of original target','0');
INSERT DBColumns VALUES('SpecObjAll','plateID','','','','Database ID of Plate','0');
INSERT DBColumns VALUES('SpecObjAll','sciencePrimary','','','','Best version of spectrum at this location (defines default view SpecObj)','0');
INSERT DBColumns VALUES('SpecObjAll','legacyPrimary','','','','Best version of spectrum at this location, among Legacy plates','0');
INSERT DBColumns VALUES('SpecObjAll','seguePrimary','','','','Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj)','0');
INSERT DBColumns VALUES('SpecObjAll','firstRelease','','','','Name of first release this object was associated with','0');
INSERT DBColumns VALUES('SpecObjAll','survey','','','','Survey name','0');
INSERT DBColumns VALUES('SpecObjAll','programname','','','','Program name','0');
INSERT DBColumns VALUES('SpecObjAll','chunk','','','','Chunk name','0');
INSERT DBColumns VALUES('SpecObjAll','platerun','','','','Plate drill run name','0');
INSERT DBColumns VALUES('SpecObjAll','mjd','days','','','MJD of observation','0');
INSERT DBColumns VALUES('SpecObjAll','plate','','','','Plate number','0');
INSERT DBColumns VALUES('SpecObjAll','fiberID','','','','Fiber ID','0');
INSERT DBColumns VALUES('SpecObjAll','run1d','','','','1D Reduction version of spectrum','0');
INSERT DBColumns VALUES('SpecObjAll','run2d','','','','2D Reduction version of spectrum','0');
INSERT DBColumns VALUES('SpecObjAll','tile','','','','Tile number','0');
INSERT DBColumns VALUES('SpecObjAll','designID','','','','Design ID number','0');
INSERT DBColumns VALUES('SpecObjAll','primTarget','','','','target selection information at plate design, primary science selection (for backwards compatibility)','0');
INSERT DBColumns VALUES('SpecObjAll','secTarget','','','','target selection information at plate design, secondary/qa/calib selection  (for backwards compatibility)','0');
INSERT DBColumns VALUES('SpecObjAll','legacy_target1','','','','for Legacy program, target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('SpecObjAll','legacy_target2','','','','for Legacy program, target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('SpecObjAll','special_target1','','','','for special programs, target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('SpecObjAll','special_target2','','','','for special programs, target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('SpecObjAll','SEGUE1_target1','','','','SEGUE-1 target selection information at plate design, primary science selection','0');
INSERT DBColumns VALUES('SpecObjAll','SEGUE1_target2','','','','SEGUE-1 target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('SpecObjAll','SEGUE2_target1','','','','SEGUE-2 target selection information at plate design, primary science selection','0');
INSERT DBColumns VALUES('SpecObjAll','SEGUE2_target2','','','','SEGUE-2 target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('SpecObjAll','spectrographID','','','','which spectrograph (1,2)','0');
INSERT DBColumns VALUES('SpecObjAll','objType','','','','type of object targeted as','0');
INSERT DBColumns VALUES('SpecObjAll','class','','','','Spectroscopic class (GALAXY, QSO, or STAR)','0');
INSERT DBColumns VALUES('SpecObjAll','subClass','','','','Spectroscopic subclass','0');
INSERT DBColumns VALUES('SpecObjAll','ra','deg','','','Right ascension of fiber, J2000','0');
INSERT DBColumns VALUES('SpecObjAll','dec','deg','','','Declination of fiber, J2000','0');
INSERT DBColumns VALUES('SpecObjAll','cx','','POS_EQ_CART_X','','x of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('SpecObjAll','cy','','POS_EQ_CART_Y','','y of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('SpecObjAll','cz','','POS_EQ_CART_Z','','z of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('SpecObjAll','xFocal','mm','','','X focal plane position (+RA direction)','0');
INSERT DBColumns VALUES('SpecObjAll','yFocal','mm','','','Y focal plane position (+Dec direction)','0');
INSERT DBColumns VALUES('SpecObjAll','z','','','','Final Redshift','0');
INSERT DBColumns VALUES('SpecObjAll','zErr','','','','Redshift error','0');
INSERT DBColumns VALUES('SpecObjAll','rChi2','','','','Reduced chi-squared of best fit','0');
INSERT DBColumns VALUES('SpecObjAll','DOF','','','','Degrees of freedom in best fit','0');
INSERT DBColumns VALUES('SpecObjAll','rChi2Diff','','','','Difference in reduced chi-squared between best and second best fit','0');
INSERT DBColumns VALUES('SpecObjAll','tFile','','','','File name of best fit template source','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_0','','','','Which column of the template file corresponds to template #0','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_1','','','','Which column of the template file corresponds to template #1','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_2','','','','Which column of the template file corresponds to template #2','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_3','','','','Which column of the template file corresponds to template #3','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_4','','','','Which column of the template file corresponds to template #4','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_5','','','','Which column of the template file corresponds to template #5','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_6','','','','Which column of the template file corresponds to template #6','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_7','','','','Which column of the template file corresponds to template #7','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_8','','','','Which column of the template file corresponds to template #8','0');
INSERT DBColumns VALUES('SpecObjAll','tColumn_9','','','','Which column of the template file corresponds to template #9','0');
INSERT DBColumns VALUES('SpecObjAll','nPoly','','','','Number of polynomial terms used in the fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_0','','','','Coefficient for template #0 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_1','','','','Coefficient for template #1 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_2','','','','Coefficient for template #2 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_3','','','','Coefficient for template #3 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_4','','','','Coefficient for template #4 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_5','','','','Coefficient for template #5 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_6','','','','Coefficient for template #6 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_7','','','','Coefficient for template #7 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_8','','','','Coefficient for template #8 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','theta_9','','','','Coefficient for template #9 of fit','0');
INSERT DBColumns VALUES('SpecObjAll','velDisp','km/s','','','Velocity dispersion','0');
INSERT DBColumns VALUES('SpecObjAll','velDispErr','km/s','','','Error in velocity dispersion','0');
INSERT DBColumns VALUES('SpecObjAll','velDispZ','','','','Redshift associated with best fit velocity dispersion','0');
INSERT DBColumns VALUES('SpecObjAll','velDispZErr','','','','Error in redshift associated with best fit velocity dispersion','0');
INSERT DBColumns VALUES('SpecObjAll','velDispChi2','','','','Chi-squared associated with velocity dispersion fit','0');
INSERT DBColumns VALUES('SpecObjAll','velDispNPix','','','','Number of pixels overlapping best template in velocity dispersion fit','0');
INSERT DBColumns VALUES('SpecObjAll','velDispDOF','','','','Number of degrees of freedom in velocity dispersion fit','0');
INSERT DBColumns VALUES('SpecObjAll','waveMin','Angstroms','','','Minimum observed (vacuum) wavelength','0');
INSERT DBColumns VALUES('SpecObjAll','waveMax','Angstroms','','','Maximum observed (vacuum) wavelength','0');
INSERT DBColumns VALUES('SpecObjAll','wCoverage','','','','Coverage in wavelength, in units of log10 wavelength','0');
INSERT DBColumns VALUES('SpecObjAll','zWarning','','','','Bitmask of warning values; 0 means all is good','0');
INSERT DBColumns VALUES('SpecObjAll','snMedian','','','','Median signal-to-noise over all good pixels','0');
INSERT DBColumns VALUES('SpecObjAll','chi68p','','','','68-th percentile value of abs(chi) of the best-fit synthetic spectrum to the actual spectrum (around 1.0 for a good fit)','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_1','','','','Fraction of pixels deviant by more than 1 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_2','','','','Fraction of pixels deviant by more than 2 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_3','','','','Fraction of pixels deviant by more than 3 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_4','','','','Fraction of pixels deviant by more than 4 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_5','','','','Fraction of pixels deviant by more than 5 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_6','','','','Fraction of pixels deviant by more than 6 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_7','','','','Fraction of pixels deviant by more than 7 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_8','','','','Fraction of pixels deviant by more than 8 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_9','','','','Fraction of pixels deviant by more than 9 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigma_10','','','','Fraction of pixels deviant by more than 10 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_1','','','','Fraction of pixels high by more than 1 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_2','','','','Fraction of pixels high by more than 2 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_3','','','','Fraction of pixels high by more than 3 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_4','','','','Fraction of pixels high by more than 4 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_5','','','','Fraction of pixels high by more than 5 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_6','','','','Fraction of pixels high by more than 6 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_7','','','','Fraction of pixels high by more than 7 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_8','','','','Fraction of pixels high by more than 8 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_9','','','','Fraction of pixels high by more than 9 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigHi_10','','','','Fraction of pixels high by more than 10 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_1','','','','Fraction of pixels low by more than 1 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_2','','','','Fraction of pixels low by more than 2 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_3','','','','Fraction of pixels low by more than 3 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_4','','','','Fraction of pixels low by more than 4 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_5','','','','Fraction of pixels low by more than 5 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_6','','','','Fraction of pixels low by more than 6 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_7','','','','Fraction of pixels low by more than 7 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_8','','','','Fraction of pixels low by more than 8 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_9','','','','Fraction of pixels low by more than 9 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','fracNSigLo_10','','','','Fraction of pixels low by more than 10 sigma relative to best-fit','0');
INSERT DBColumns VALUES('SpecObjAll','spectroFlux_g','nanomaggies','','','Spectrum projected onto g filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroFlux_r','nanomaggies','','','Spectrum projected onto r filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroFlux_i','nanomaggies','','','Spectrum projected onto i filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSynFlux_g','nanomaggies','','','Best-fit template spectrum projected onto g filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSynFlux_r','nanomaggies','','','Best-fit template spectrum projected onto r filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSynFlux_i','nanomaggies','','','Best-fit template spectrum projected onto i filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroFluxIvar_g','nanomaggies','','','Inverse variance of spectrum projected onto g filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroFluxIvar_r','nanomaggies','','','Inverse variance of spectrum projected onto r filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroFluxIvar_i','nanomaggies','','','Inverse variance of spectrum projected onto i filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSynFluxIvar_g','nanomaggies','','','Inverse variance of best-fit template spectrum projected onto g filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSynFluxIvar_r','nanomaggies','','','Inverse variance of best-fit template spectrum projected onto r filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSynFluxIvar_i','nanomaggies','','','Inverse variance of best-fit template spectrum projected onto i filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSkyFlux_g','nanomaggies','','','Sky spectrum projected onto g filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSkyFlux_r','nanomaggies','','','Sky spectrum projected onto r filter','0');
INSERT DBColumns VALUES('SpecObjAll','spectroSkyFlux_i','nanomaggies','','','Sky spectrum projected onto i filter','0');
INSERT DBColumns VALUES('SpecObjAll','anyAndMask','','','','for each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK','0');
INSERT DBColumns VALUES('SpecObjAll','anyOrMask','','','','for each bit, records whether any pixel in the spectrum has that bit set in its ORMASK','0');
INSERT DBColumns VALUES('SpecObjAll','plateSn2','','','','Overall signal to noise measure for plate','0');
INSERT DBColumns VALUES('SpecObjAll','snTurnoff','','','','Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate)','0');
INSERT DBColumns VALUES('SpecObjAll','sn1_g','','','','(S/N)^2 at g=20.20 for spectrograph #1','0');
INSERT DBColumns VALUES('SpecObjAll','sn1_r','','','','(S/N)^2 at r=20.25 for spectrograph #1','0');
INSERT DBColumns VALUES('SpecObjAll','sn1_i','','','','(S/N)^2 at i=19.90 for spectrograph #1','0');
INSERT DBColumns VALUES('SpecObjAll','sn2_g','','','','(S/N)^2 at g=20.20 for spectrograph #2','0');
INSERT DBColumns VALUES('SpecObjAll','sn2_r','','','','(S/N)^2 at r=20.25 for spectrograph #2','0');
INSERT DBColumns VALUES('SpecObjAll','sn2_i','','','','(S/N)^2 at i=19.90 for spectrograph #2','0');
INSERT DBColumns VALUES('SpecObjAll','elodieFileName','','','','File name for best-fit Elodie star','0');
INSERT DBColumns VALUES('SpecObjAll','elodieObject','','','','Star name (mostly Henry Draper names)','0');
INSERT DBColumns VALUES('SpecObjAll','elodieSpType','','','','Spectral type','0');
INSERT DBColumns VALUES('SpecObjAll','elodieBV','mag','','','(B-V) color','0');
INSERT DBColumns VALUES('SpecObjAll','elodieTEff','Kelvin','','','Effective temperature','0');
INSERT DBColumns VALUES('SpecObjAll','elodieLogG','','','','log10(gravity)','0');
INSERT DBColumns VALUES('SpecObjAll','elodieFeH','','','','Metallicity ([Fe/H])','0');
INSERT DBColumns VALUES('SpecObjAll','elodieZ','','','','Redshift','0');
INSERT DBColumns VALUES('SpecObjAll','elodieZErr','','','','Redshift error (negative for invalid fit)','0');
INSERT DBColumns VALUES('SpecObjAll','elodieZModelErr','','','','Standard deviation in redshift among the 12 best-fit stars','0');
INSERT DBColumns VALUES('SpecObjAll','elodieRChi2','','','','Reduced chi^2','0');
INSERT DBColumns VALUES('SpecObjAll','elodieDOF','','','','Degrees of freedom for fit','0');
INSERT DBColumns VALUES('SpecObjAll','htmID','','CODE_HTM','','20 deep Hierarchical Triangular Mesh ID','0');
INSERT DBColumns VALUES('SpecObjAll','loadVersion','','ID_TRACER','','Load Version','0');
INSERT DBColumns VALUES('SpecObjAll','img','','IMAGE?','','Spectrum Image','0');
INSERT DBColumns VALUES('SpecPhotoAll','specObjID','','ID_CATALOG','','Unique ID','0');
INSERT DBColumns VALUES('SpecPhotoAll','mjd','MJD','TIME_DATE','','MJD of observation','0');
INSERT DBColumns VALUES('SpecPhotoAll','plate','','ID_PLATE','','Plate ID','0');
INSERT DBColumns VALUES('SpecPhotoAll','tile','','ID_PLATE','','Tile ID','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberID','','ID_FIBER','','Fiber ID','0');
INSERT DBColumns VALUES('SpecPhotoAll','z','','REDSHIFT','','Final Redshift','0');
INSERT DBColumns VALUES('SpecPhotoAll','zErr','','REDSHIFT ERROR','','Redshift error','0');
INSERT DBColumns VALUES('SpecPhotoAll','class','','','','Spectroscopic class (GALAXY, QSO, or STAR)','0');
INSERT DBColumns VALUES('SpecPhotoAll','subClass','','','','Spectroscopic subclass','0');
INSERT DBColumns VALUES('SpecPhotoAll','zWarning','','CODE_QUALITY','SpeczWarning','Warning Flags','0');
INSERT DBColumns VALUES('SpecPhotoAll','ra','deg','POS_EQ_RA_MAIN','','ra in J2000 from SpecObj','0');
INSERT DBColumns VALUES('SpecPhotoAll','dec','deg','POS_EQ_DEC_MAIN','','dec in J2000 from SpecObj','0');
INSERT DBColumns VALUES('SpecPhotoAll','cx','','POS_EQ_CART_X?','','x of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('SpecPhotoAll','cy','','POS_EQ_CART_Y?','','y of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('SpecPhotoAll','cz','','POS_EQ_CART_Z?','','z of Normal unit vector in J2000','0');
INSERT DBColumns VALUES('SpecPhotoAll','htmID','','CODE_HTM','','20 deep Hierarchical Triangular Mesh ID','0');
INSERT DBColumns VALUES('SpecPhotoAll','sciencePrimary','','','','Best version of spectrum at this location (defines default view SpecObj)','0');
INSERT DBColumns VALUES('SpecPhotoAll','legacyPrimary','','','','Best version of spectrum at this location, among Legacy plates','0');
INSERT DBColumns VALUES('SpecPhotoAll','seguePrimary','','','','Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj)','0');
INSERT DBColumns VALUES('SpecPhotoAll','plateID','','ID_PLATE','','Link to plate on which the spectrum was taken','0');
INSERT DBColumns VALUES('SpecPhotoAll','objType','','CLASS_OBJECT','','type of object targeted as','0');
INSERT DBColumns VALUES('SpecPhotoAll','targetObjID','','ID_CATALOG','','ID of target PhotoObj','0');
INSERT DBColumns VALUES('SpecPhotoAll','objID','','ID_CATALOG','','Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].','0');
INSERT DBColumns VALUES('SpecPhotoAll','skyVersion','','CODE_MISC','','0 = OPDB target, 1 = OPDB best','0');
INSERT DBColumns VALUES('SpecPhotoAll','run','','OBS_RUN','','Run number','0');
INSERT DBColumns VALUES('SpecPhotoAll','rerun','','CODE_MISC','','Rerun number','0');
INSERT DBColumns VALUES('SpecPhotoAll','camcol','','INST_ID','','Camera column','0');
INSERT DBColumns VALUES('SpecPhotoAll','field','','ID_FIELD','','Field number','0');
INSERT DBColumns VALUES('SpecPhotoAll','obj','','ID_NUMBER','','The object id within a field. Usually changes between reruns of the same field.','0');
INSERT DBColumns VALUES('SpecPhotoAll','mode','','CLASS_OBJECT','','1: primary, 2: secondary, 3: family object.','0');
INSERT DBColumns VALUES('SpecPhotoAll','nChild','','NUMBER','','Number of children if this is a deblened composite object. BRIGHT (in a flags sense) objects also have nchild==1, the non-BRIGHT sibling.','0');
INSERT DBColumns VALUES('SpecPhotoAll','type','','CLASS_OBJECT','PhotoType','Morphological type classification of the object.','0');
INSERT DBColumns VALUES('SpecPhotoAll','flags','','CODE_MISC','PhotoFlags','Photo Object Attribute Flags','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMag_u','mag','PHOT_SDSS_U','','PSF flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMag_g','mag','PHOT_SDSS_G','','PSF flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMag_r','mag','PHOT_SDSS_R','','PSF flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMag_i','mag','PHOT_SDSS_I','','PSF flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMag_z','mag','PHOT_SDSS_Z','','PSF flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMagErr_u','mag','PHOT_SDSS_U ERROR','','PSF flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMagErr_g','mag','PHOT_SDSS_G ERROR','','PSF flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMagErr_r','mag','PHOT_SDSS_R ERROR','','PSF flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMagErr_i','mag','PHOT_SDSS_I ERROR','','PSF flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','psfMagErr_z','mag','PHOT_SDSS_Z ERROR','','PSF flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMag_u','mag','PHOT_SDSS_U','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMag_g','mag','PHOT_SDSS_G','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMag_r','mag','PHOT_SDSS_R','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMag_i','mag','PHOT_SDSS_I','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMag_z','mag','PHOT_SDSS_Z','','Flux in 3 arcsec diameter fiber radius','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMagErr_u','mag','PHOT_SDSS_U ERROR','','Flux in 3 arcsec diameter fiber radius error','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMagErr_g','mag','PHOT_SDSS_G ERROR','','Flux in 3 arcsec diameter fiber radius error','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMagErr_r','mag','PHOT_SDSS_R ERROR','','Flux in 3 arcsec diameter fiber radius error','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMagErr_i','mag','PHOT_SDSS_I ERROR','','Flux in 3 arcsec diameter fiber radius error','0');
INSERT DBColumns VALUES('SpecPhotoAll','fiberMagErr_z','mag','PHOT_SDSS_Z ERROR','','Flux in 3 arcsec diameter fiber radius error','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMag_u','mag','PHOT_SDSS_U','','Petrosian flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMag_g','mag','PHOT_SDSS_G','','Petrosian flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMag_r','mag','PHOT_SDSS_R','','Petrosian flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMag_i','mag','PHOT_SDSS_I','','Petrosian flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMag_z','mag','PHOT_SDSS_Z','','Petrosian flux','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMagErr_u','mag','PHOT_SDSS_U ERROR','','Petrosian flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMagErr_g','mag','PHOT_SDSS_G ERROR','','Petrosian flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMagErr_r','mag','PHOT_SDSS_R ERROR','','Petrosian flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMagErr_i','mag','PHOT_SDSS_I ERROR','','Petrosian flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','petroMagErr_z','mag','PHOT_SDSS_Z ERROR','','Petrosian flux error','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMag_u','mag','PHOT_SDSS_U FIT_PARAM','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMag_g','mag','PHOT_SDSS_G FIT_PARAM','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMag_r','mag','PHOT_SDSS_R FIT_PARAM','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMag_i','mag','PHOT_SDSS_I FIT_PARAM','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMag_z','mag','PHOT_SDSS_Z FIT_PARAM','','better of DeV/Exp magnitude fit','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMagErr_u','mag','PHOT_SDSS_U ERROR','','better of DeV/Exp magnitude fit error','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMagErr_g','mag','PHOT_SDSS_G ERROR','','better of DeV/Exp magnitude fit error','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMagErr_r','mag','PHOT_SDSS_R ERROR','','better of DeV/Exp magnitude fit error','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMagErr_i','mag','PHOT_SDSS_I ERROR','','better of DeV/Exp magnitude fit error','0');
INSERT DBColumns VALUES('SpecPhotoAll','modelMagErr_z','mag','PHOT_SDSS_Z ERROR','','better of DeV/Exp magnitude fit error','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMag_u','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMag_g','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMag_r','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMag_i','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMag_z','mag','','','DeV+Exp magnitude','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMagErr_u','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMagErr_g','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMagErr_r','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMagErr_i','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('SpecPhotoAll','cModelMagErr_z','mag','','','DeV+Exp magnitude error','0');
INSERT DBColumns VALUES('SpecPhotoAll','mRrCc_r','','FIT_PARAM','','Adaptive (<r^2> + <c^2>)','0');
INSERT DBColumns VALUES('SpecPhotoAll','mRrCcErr_r','','FIT_PARAM ERROR','','Error in adaptive (<r^2> + <c^2>)','0');
INSERT DBColumns VALUES('SpecPhotoAll','score','','','','Quality of field (0-1)','0');
INSERT DBColumns VALUES('SpecPhotoAll','resolveStatus','','','','Resolve status of object','0');
INSERT DBColumns VALUES('SpecPhotoAll','calibStatus_u','','','','Calibration status in u-band','0');
INSERT DBColumns VALUES('SpecPhotoAll','calibStatus_g','','','','Calibration status in g-band','0');
INSERT DBColumns VALUES('SpecPhotoAll','calibStatus_r','','','','Calibration status in r-band','0');
INSERT DBColumns VALUES('SpecPhotoAll','calibStatus_i','','','','Calibration status in i-band','0');
INSERT DBColumns VALUES('SpecPhotoAll','calibStatus_z','','','','Calibration status in z-band','0');
INSERT DBColumns VALUES('SpecPhotoAll','photoRa','deg','POS_EQ_RA_MAIN','','J2000 right ascension (r'') from Best','0');
INSERT DBColumns VALUES('SpecPhotoAll','photoDec','deg','POS_EQ_DEC_MAIN','','J2000 declination (r'') from Best','0');
INSERT DBColumns VALUES('SpecPhotoAll','extinction_u','mag','PHOT_EXTINCTION_GAL','','Reddening in each filter','0');
INSERT DBColumns VALUES('SpecPhotoAll','extinction_g','mag','PHOT_EXTINCTION_GAL','','Reddening in each filter','0');
INSERT DBColumns VALUES('SpecPhotoAll','extinction_r','mag','PHOT_EXTINCTION_GAL','','Reddening in each filter','0');
INSERT DBColumns VALUES('SpecPhotoAll','extinction_i','mag','PHOT_EXTINCTION_GAL','','Reddening in each filter','0');
INSERT DBColumns VALUES('SpecPhotoAll','extinction_z','mag','PHOT_EXTINCTION_GAL','','Reddening in each filter','0');
INSERT DBColumns VALUES('SpecPhotoAll','fieldID','','ID_FIELD','','Link to the field this object is in','0');
INSERT DBColumns VALUES('SpecPhotoAll','dered_u','mag','PHOT_SDSS_U','','Simplified mag, corrected for reddening: modelMag-reddening','0');
INSERT DBColumns VALUES('SpecPhotoAll','dered_g','mag','PHOT_SDSS_G','','Simplified mag, corrected for reddening: modelMag-reddening','0');
INSERT DBColumns VALUES('SpecPhotoAll','dered_r','mag','PHOT_SDSS_R','','Simplified mag, corrected for reddening: modelMag-reddening','0');
INSERT DBColumns VALUES('SpecPhotoAll','dered_i','mag','PHOT_SDSS_I','','Simplified mag, corrected for reddening: modelMag-reddening','0');
INSERT DBColumns VALUES('SpecPhotoAll','dered_z','mag','PHOT_SDSS_Z','','Simplified mag, corrected for reddening: modelMag-reddening','0');
INSERT DBColumns VALUES('Target','targetID','','ID_CATALOG','','hash of run, rerun, camcol, field, object (skyVersion=0)','0');
INSERT DBColumns VALUES('Target','run','','OBS_RUN','','imaging run','0');
INSERT DBColumns VALUES('Target','rerun','','CODE_MISC','','rerun number','0');
INSERT DBColumns VALUES('Target','camcol','','INST_ID','','imaging camcol','0');
INSERT DBColumns VALUES('Target','field','','ID_FIELD','','imaging field','0');
INSERT DBColumns VALUES('Target','obj','','ID_NUMBER','','imaging object id','0');
INSERT DBColumns VALUES('Target','regionID','','ID_CATALOG','','ID of sector, 0 if unset','0');
INSERT DBColumns VALUES('Target','ra','deg','POS_EQ_RA_MAIN','','right ascension','0');
INSERT DBColumns VALUES('Target','dec','deg','POS_EQ_DEC_MAIN','','declination','0');
INSERT DBColumns VALUES('Target','duplicate','','CODE_MISC','','duplicate spectrum by mistake','0');
INSERT DBColumns VALUES('Target','htmID','','CODE_HTM','','htm index','0');
INSERT DBColumns VALUES('Target','cx','','POS_EQ_CART_X','','x projection of vector on unit sphere','0');
INSERT DBColumns VALUES('Target','cy','','POS_EQ_CART_Y','','y projection of vector on unit sphere','0');
INSERT DBColumns VALUES('Target','cz','','POS_EQ_CART_Z','','z projection of vector on unit sphere','0');
INSERT DBColumns VALUES('Target','bestObjID','','CODE_MISC','','hashed ID of object in best version of the sky','0');
INSERT DBColumns VALUES('Target','specObjID','','CODE_MISC','','hashed ID of specobj in best version of the sky','0');
INSERT DBColumns VALUES('Target','bestMode','','CLASS_OBJECT','','mode from BEST PhotoObj','0');
INSERT DBColumns VALUES('Target','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('TargetInfo','targetObjID','','ID_CATALOG','','ID of object in Target (foreign key to Target.TargetObjID)','0');
INSERT DBColumns VALUES('TargetInfo','targetID','','ID_CATALOG','','ID of entry in Target table','0');
INSERT DBColumns VALUES('TargetInfo','skyVersion','','ID_VERSION','','skyVersion','0');
INSERT DBColumns VALUES('TargetInfo','primTarget','','CODE_MISC','PrimTarget','primTarget from TARGET','0');
INSERT DBColumns VALUES('TargetInfo','secTarget','','CODE_MISC','SecTarget','secTarget from TARGET','0');
INSERT DBColumns VALUES('TargetInfo','priority','','CODE_QUALITY','','target selection priority','0');
INSERT DBColumns VALUES('TargetInfo','programType','','OBS_TYPE','ProgramType','spectroscopic program type','0');
INSERT DBColumns VALUES('TargetInfo','programName','','ID_SURVEY','','character string of program (from plate inventory db)','0');
INSERT DBColumns VALUES('TargetInfo','targetMode','','CLASS_OBJECT','','mode from TARGET PhotoObj','0');
INSERT DBColumns VALUES('TargetInfo','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('sdssTargetParam','targetVersion','','ID_VERSION','','version of target selection software','0');
INSERT DBColumns VALUES('sdssTargetParam','paramFile','','ID_VERSION','','version of target selection software','0');
INSERT DBColumns VALUES('sdssTargetParam','name','','','','parameter name','0');
INSERT DBColumns VALUES('sdssTargetParam','value','','','','value used for the parameter','0');
INSERT DBColumns VALUES('sdssTileAll','tile','','ID_PLATE','','(unique) tile number','0');
INSERT DBColumns VALUES('sdssTileAll','tileRun','','ID_VERSION','','run of the tiling software','0');
INSERT DBColumns VALUES('sdssTileAll','raCen','deg','POS_EQ_RA','','right ascension of tile center','0');
INSERT DBColumns VALUES('sdssTileAll','decCen','deg','POS_EQ_DEC','','declination of the tile center','0');
INSERT DBColumns VALUES('sdssTileAll','htmID','','CODE_HTM','','htm tree info','0');
INSERT DBColumns VALUES('sdssTileAll','cx','','POS_EQ_CART_X','','x projection of vector on unit sphere','0');
INSERT DBColumns VALUES('sdssTileAll','cy','','POS_EQ_CART_Y','','y projection of vector on unit sphere','0');
INSERT DBColumns VALUES('sdssTileAll','cz','','POS_EQ_CART_Z','','z projection of vector on unit sphere','0');
INSERT DBColumns VALUES('sdssTileAll','untiled','','CODE_MISC','','1: this tile later "untiled," releasing targets to be assigned to another tile, 0: otherwise','0');
INSERT DBColumns VALUES('sdssTileAll','nTargets','','NUMBER','','number of targets assigned to this tile','0');
INSERT DBColumns VALUES('sdssTileAll','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('sdssTilingRun','tileRun','','OBS_RUN','','(unique) tiling run number','0');
INSERT DBColumns VALUES('sdssTilingRun','ctileVersion','','ID_VERSION','','version of ctile software','0');
INSERT DBColumns VALUES('sdssTilingRun','tilepId','','OBJ_ID','','unique id for tiling run','0');
INSERT DBColumns VALUES('sdssTilingRun','programName','','OBJ_ID','','character string of program','0');
INSERT DBColumns VALUES('sdssTilingRun','primTargetMask','','CODE_MISC','PrimTarget','bit mask for target types to be tiled','0');
INSERT DBColumns VALUES('sdssTilingRun','secTargetMask','','CODE_MISC','SecTarget','bit mask for target types to be tiled','0');
INSERT DBColumns VALUES('sdssTilingRun','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('sdssTilingGeometry','regionID','','','','unique identifier for this tilingRegion','0');
INSERT DBColumns VALUES('sdssTilingGeometry','tileRun','','OBJ_RUN','','run of tiling software','0');
INSERT DBColumns VALUES('sdssTilingGeometry','stripe','','EXTENSION_AREA','','stripe containing the boundary','0');
INSERT DBColumns VALUES('sdssTilingGeometry','nsbx','','CODE_MISC','','b: official stripe boundaries should be included, x: use the full rectangle','0');
INSERT DBColumns VALUES('sdssTilingGeometry','isMask','','CODE_MISC','','1: tiling mask, 0: tiling boundary','0');
INSERT DBColumns VALUES('sdssTilingGeometry','coordType','','POS_REFERENCE-SYSTEM','CoordType','specifies coordinate system for the boundaries','0');
INSERT DBColumns VALUES('sdssTilingGeometry','lambdamu_0','deg','POS_SDSS POS_LIMIT','','first lower bound','0');
INSERT DBColumns VALUES('sdssTilingGeometry','lambdamu_1','deg','POS_SDSS POS_LIMIT','','first upper bound','0');
INSERT DBColumns VALUES('sdssTilingGeometry','etanu_0','deg','POS_SDSS POS_LIMIT','','second lower bound','0');
INSERT DBColumns VALUES('sdssTilingGeometry','etanu_1','deg','POS_SDSS POS_LIMIT','','second upper bound','0');
INSERT DBColumns VALUES('sdssTilingGeometry','lambdaLimit_0','deg','POS_SDSS POS_LIMIT','','minimum survey latitude for this stripe for region in which primaries are selected (-9999 if no limit)','0');
INSERT DBColumns VALUES('sdssTilingGeometry','lambdaLimit_1','deg','POS_SDSS POS_LIMIT','','maximum survey latitude for this stripe for region in which primaries are selected (-9999 if no limit)','0');
INSERT DBColumns VALUES('sdssTilingGeometry','targetVersion','','ID_VERSION','','version of target software within this boundary','0');
INSERT DBColumns VALUES('sdssTilingGeometry','firstArea','deg^2','EXTENSION_AREA','','area of sky covered by this boundary that was not covered by previous boundaries','0');
INSERT DBColumns VALUES('sdssTilingGeometry','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','targetID','','','','Unique SDSS identifier composed from [skyVersion=0,rerun,run,camcol,field,obj].','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','run','','','','Drift scan run number for targeting','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','rerun','','','','Reprocessing number for targeting','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','camcol','','','','Camera column number for targeting','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','field','','','','Field number for targeting','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','obj','','','','Object id number for targeting','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','ra','deg','POS_EQ_RA','','right ascension','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','dec','deg','POS_EQ_DEC','','declination','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','htmID','','CODE_HTM','','htm tree info','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','cx','','','','x projection of vector on unit sphere','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','cy','','','','y projection of vector on unit sphere','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','cz','','','','z projection of vector on unit sphere','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','primTarget','','','','primary target bitmask','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','secTarget','','','','secondary target bitmask','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','tiPriority','','','','tiling priority level (lower means higher priority)','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','tileAll','','','','First tile number this object was assigned to','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','tiMaskAll','','','','Combined value of tiling results bitmask','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','collisionGroupAll','','','','unique ID of collisionGroup','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','photoObjID','','','','hashed ID of photometric object in best version of the sky','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','specObjID','','','','hashed ID of spectroscopic object in best version of the sky','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','regionID','','','','ID of tiling region, 0 if unset','0');
INSERT DBColumns VALUES('sdssTiledTargetAll','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('sdssTilingInfo','targetID','','','','Unique SDSS identifier composed from [skyVersion=0,rerun,run,camcol,field,obj].','0');
INSERT DBColumns VALUES('sdssTilingInfo','tileRun','','','','Run of tiling software','0');
INSERT DBColumns VALUES('sdssTilingInfo','tid','','','','Unique ID of objects within tiling run','0');
INSERT DBColumns VALUES('sdssTilingInfo','tiMask','','','','Value of tiling results bitmask for this run','0');
INSERT DBColumns VALUES('sdssTilingInfo','collisionGroup','','','','unique ID of collisionGroup in this tiling run','0');
INSERT DBColumns VALUES('sdssTilingInfo','tile','','','','Tile this object was assigned to in this run','0');
INSERT DBColumns VALUES('sdssTilingInfo','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('Rmatrix','mode','','','','','0');
INSERT DBColumns VALUES('Rmatrix','row','','','','','0');
INSERT DBColumns VALUES('Rmatrix','x','','','','','0');
INSERT DBColumns VALUES('Rmatrix','y','','','','','0');
INSERT DBColumns VALUES('Rmatrix','z','','','','','0');
INSERT DBColumns VALUES('Region','regionid','','','','','0');
INSERT DBColumns VALUES('Region','id','','','','key of the region pointing into other tables','0');
INSERT DBColumns VALUES('Region','type','','','','type of the region (STRIPE|STAVE|...)','0');
INSERT DBColumns VALUES('Region','comment','','','','description of the region','0');
INSERT DBColumns VALUES('Region','ismask','','','','0: region, 1: to be excluded','0');
INSERT DBColumns VALUES('Region','area','deg^2','EXTENSION_AREA','','area of region','0');
INSERT DBColumns VALUES('Region','regionString','','','','the string representation of the region','0');
INSERT DBColumns VALUES('Region','regionBinary','','','','the precompiled XML description of region','0');
INSERT DBColumns VALUES('RegionPatch','regionid','','','','Unique Region ID','0');
INSERT DBColumns VALUES('RegionPatch','convexid','','','','Unique Convex ID','0');
INSERT DBColumns VALUES('RegionPatch','patchid','','','','Unique patch number','0');
INSERT DBColumns VALUES('RegionPatch','type','','','','CAMCOL, RUN, STAVE, TILE, TILEBOX, SKYBOX, WEDGE, SECTOR...','0');
INSERT DBColumns VALUES('RegionPatch','radius','arcmin','','','radius of bounding circle centered at ra, dec','0');
INSERT DBColumns VALUES('RegionPatch','ra','deg','','','right ascension of observation','0');
INSERT DBColumns VALUES('RegionPatch','dec','deg','','','declination of observation','0');
INSERT DBColumns VALUES('RegionPatch','x','','','','x of centerpoint Normal unit vector in J2000','0');
INSERT DBColumns VALUES('RegionPatch','y','','','','y of centerpoint Normal unit vector in J2000','0');
INSERT DBColumns VALUES('RegionPatch','z','','','','z of centerpoint Normal unit vector in J2000','0');
INSERT DBColumns VALUES('RegionPatch','c','','','','offset of the equation of plane','0');
INSERT DBColumns VALUES('RegionPatch','htmid','','','','20 deep Hierarchical Triangular Mesh ID of centerpoint','0');
INSERT DBColumns VALUES('RegionPatch','area','deg^2','','','area of the patch','0');
INSERT DBColumns VALUES('RegionPatch','convexString','','','','{x,y,z,c}+ representation of the convex of the patch','0');
INSERT DBColumns VALUES('HalfSpace','constraintid','','','','id for the constraint','0');
INSERT DBColumns VALUES('HalfSpace','regionid','','','','pointer to RegionDefs','0');
INSERT DBColumns VALUES('HalfSpace','convexid','','','','unique id for the convex','0');
INSERT DBColumns VALUES('HalfSpace','x','','','','x component of normal','0');
INSERT DBColumns VALUES('HalfSpace','y','','','','y component of normal','0');
INSERT DBColumns VALUES('HalfSpace','z','','','','z component of normal','0');
INSERT DBColumns VALUES('HalfSpace','c','','','','offset from center along normal','0');
INSERT DBColumns VALUES('RegionArcs','arcid','','','','unique id of the arc','0');
INSERT DBColumns VALUES('RegionArcs','regionid','','','','unique region identifier','0');
INSERT DBColumns VALUES('RegionArcs','convexid','','','','convex identifier','0');
INSERT DBColumns VALUES('RegionArcs','constraintid','','','','id of the constraint','0');
INSERT DBColumns VALUES('RegionArcs','patch','','','','id of the patch','0');
INSERT DBColumns VALUES('RegionArcs','state','','','','state (3: bounding circle, 2:root, 1: hole)','0');
INSERT DBColumns VALUES('RegionArcs','draw','','','','0:hide, 1: draw','0');
INSERT DBColumns VALUES('RegionArcs','ra1','','','','ra of starting point of arc','0');
INSERT DBColumns VALUES('RegionArcs','dec1','','','','dec of starting point of arc','0');
INSERT DBColumns VALUES('RegionArcs','ra2','','','','ra of end point of arc','0');
INSERT DBColumns VALUES('RegionArcs','dec2','','','','dec of end point of arc','0');
INSERT DBColumns VALUES('RegionArcs','x','','','','x of constraint normal vector','0');
INSERT DBColumns VALUES('RegionArcs','y','','','','y of constraint normal vector','0');
INSERT DBColumns VALUES('RegionArcs','z','','','','z of constraint normal vector','0');
INSERT DBColumns VALUES('RegionArcs','c','','','','offset of constraint','0');
INSERT DBColumns VALUES('RegionArcs','length','deg','','','length of arc in degrees','0');
INSERT DBColumns VALUES('Sector','regionID','','ID_CATALOG','','unique, sequential ID','0');
INSERT DBColumns VALUES('Sector','nTiles','','NUMBER','','number of overlapping tiles','0');
INSERT DBColumns VALUES('Sector','tiles','','ID_VERSION','','list of tiles in Sector','0');
INSERT DBColumns VALUES('Sector','targetVersion','','','','the version of target selection ran over the sector -/K ID_VERSION','0');
INSERT DBColumns VALUES('Sector','area','deg^2','EXTENSION_AREA','','area of this overlap region','0');
INSERT DBColumns VALUES('Region2Box','regionType','','','','type of parent, (TIGEOM)','0');
INSERT DBColumns VALUES('Region2Box','id','','','','the object id of the other parent region','0');
INSERT DBColumns VALUES('Region2Box','boxType','','','','type of child (TILEBOX, SKYBOX)','0');
INSERT DBColumns VALUES('Region2Box','boxid','','','','regionid of child','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','sdssPolygonID','','','','integer description of polygon','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','x','','','','x-component of normal vector','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','y','','','','y-component of normal vector','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','z','','','','z-component of normal vector','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','c','','','','offset from center along normal','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','xMangle','','','','mangle version of x-component','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','yMangle','','','','mangle version of y-component','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','zMangle','','','','mangle version of z-component','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','cMangle','','','','mangle version of offset from center','0');
INSERT DBColumns VALUES('sdssImagingHalfSpaces','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('sdssPolygons','sdssPolygonID','','','','integer description of polygon','0');
INSERT DBColumns VALUES('sdssPolygons','nField','','','','number of fields in the polygon','0');
INSERT DBColumns VALUES('sdssPolygons','primaryFieldID','','','','ID of primary field in this polygon','0');
INSERT DBColumns VALUES('sdssPolygons','ra','deg','','','RA (J2000 deg) in approximate center of polygon','0');
INSERT DBColumns VALUES('sdssPolygons','dec','deg','','','Dec (J2000 deg) in approximate center of polygon','0');
INSERT DBColumns VALUES('sdssPolygons','area','square deg','','','area of polygon','0');
INSERT DBColumns VALUES('sdssPolygons','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('sdssPolygon2Field','sdssPolygonID','','','','integer designator of polygon','0');
INSERT DBColumns VALUES('sdssPolygon2Field','fieldID','','','','field identification','0');
INSERT DBColumns VALUES('sdssPolygon2Field','loadVersion','','ID_VERSION','','Load Version','0');
INSERT DBColumns VALUES('sppLines','specObjID','','','','Object ID of specObj','0');
INSERT DBColumns VALUES('sppLines','bestObjID','','ID_MAIN','','Object ID of photoObj match (flux-based)','0');
INSERT DBColumns VALUES('sppLines','targetObjID','','','','Object ID of original target','0');
INSERT DBColumns VALUES('sppLines','sciencePrimary','','','','Best version of spectrum at this location (defines default view SpecObj)','0');
INSERT DBColumns VALUES('sppLines','legacyPrimary','','','','Best version of spectrum at this location, among Legacy plates','0');
INSERT DBColumns VALUES('sppLines','PLATE','','','','Plate number','0');
INSERT DBColumns VALUES('sppLines','MJD','','','','Modified Julian Date','0');
INSERT DBColumns VALUES('sppLines','FIBER','','','','Fiber ID','0');
INSERT DBColumns VALUES('sppLines','RUN2D','','','','Name of 2D rerun','0');
INSERT DBColumns VALUES('sppLines','RUN1D','','','','Name of 1D rerun','0');
INSERT DBColumns VALUES('sppLines','RUNSSPP','','','','Name of SSPP rerun','0');
INSERT DBColumns VALUES('sppLines','H83side','Angstrom','','','Hzeta line index from local continuum at 3889.0 with band widths of 3.0','0');
INSERT DBColumns VALUES('sppLines','H83cont','Angstrom','','','Hzeta line index from global continuum at 3889.0 with band widths of 3.0','0');
INSERT DBColumns VALUES('sppLines','H83err','Angstrom','','','Hzeta line index error in the lind band at 3889.0 with band widths of 3.0','0');
INSERT DBColumns VALUES('sppLines','H83mask','','','','Hzeta pixel quality check, =0 good, =1 bad at 3889.0 with band widths of 3.0','0');
INSERT DBColumns VALUES('sppLines','H812side','Angstrom','','','Hzeta line index from local continuum at 3889.1 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','H812cont','Angstrom','','','Hzeta line index from global continuum at 3889.1 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','H812err','Angstrom','','','Hzeta line index error in the lind band at 3889.1 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','H812mask','','','','Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','H824side','Angstrom','','','Hzeta line index from local continuum at 3889.1 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','H824cont','Angstrom','','','Hzeta line index from global continuum at 3889.1 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','H824err','Angstrom','','','Hzeta line index error in the lind band at 3889.1 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','H824mask','','','','Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','H848side','Angstrom','','','Hzeta line index from local continuum at 3889.1 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','H848cont','Angstrom','','','Hzeta line index from global continuum at 3889.1 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','H848err','Angstrom','','','Hzeta line index error in the lind band at 3889.1 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','H848mask','','','','Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','KP12side','Angstrom','','','Ca II K line index from local continuum at 3933.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','KP12cont','Angstrom','','','Ca II K line index from global continuum at 3933.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','KP12err','Angstrom','','','Ca II K line index error in the lind band at 3933.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','KP12mask','','','','Ca II K pixel quality check, =0 good, =1 bad at 3933.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','KP18side','Angstrom','','','Ca II K line index from local continuum at 3933.7 with band widths of 18.0','0');
INSERT DBColumns VALUES('sppLines','KP18cont','Angstrom','','','Ca II K line index from global continuum at 3933.7 with band widths of 18.0','0');
INSERT DBColumns VALUES('sppLines','KP18err','Angstrom','','','Ca II K line index error in the lind band at 3933.7 with band widths of 18.0','0');
INSERT DBColumns VALUES('sppLines','KP18mask','','','','Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 18.0','0');
INSERT DBColumns VALUES('sppLines','KP6side','Angstrom','','','Ca II K line index from local continuum at 3933.7 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','KP6cont','Angstrom','','','Ca II K line index from global continuum at 3933.7 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','KP6err','Angstrom','','','Ca II K line index error in the lind band at 3933.7 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','KP6mask','','','','Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','CaIIKside','Angstrom','','','Ca II K line index from local continuum at 3933.6 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','CaIIKcont','Angstrom','','','Ca II K line index from global continuum at 3933.6 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','CaIIKerr','Angstrom','','','Ca II K line index error in the lind band at 3933.6 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','CaIIKmask','','','','Ca II K pixel quality check =0, good, =1 bad at 3933.6 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','CaIIHKside','Angstrom','','','Ca II H and K line index from local continuum at 3962.0 with band widths of 75.0','0');
INSERT DBColumns VALUES('sppLines','CaIIHKcont','Angstrom','','','Ca II H and K line index from global continuum at 3962.0 with band widths of 75.0','0');
INSERT DBColumns VALUES('sppLines','CaIIHKerr','Angstrom','','','Ca II H and K line index error in the lind band at 3962.0 with band widths of 75.0','0');
INSERT DBColumns VALUES('sppLines','CaIIHKmask','','','','Ca II H and K pixel quality check =0, good, =1 bad at 3962.0 with band widths of 75.0','0');
INSERT DBColumns VALUES('sppLines','Hepsside','Angstrom','','','Hepsilon line index from local continuum at 3970.0 with band widths of 50.0','0');
INSERT DBColumns VALUES('sppLines','Hepscont','Angstrom','','','Hepsilon line index from global continuum at 3970.0 with band widths of 50.0','0');
INSERT DBColumns VALUES('sppLines','Hepserr','Angstrom','','','Hepsilon line index error in the lind band at 3970.0 with band widths of 50.0','0');
INSERT DBColumns VALUES('sppLines','Hepsmask','','','','Hepsilon pixel quality check =0, good, =1 bad at 3970.0 with band widths of 50.0','0');
INSERT DBColumns VALUES('sppLines','KP16side','Angstrom','','','Ca II K line index from local continuum at 3933.7 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','KP16cont','Angstrom','','','Ca II K line index from global continuum at 3933.7 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','KP16err','Angstrom','','','Ca II K line index error in the lind band at 3933.7 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','KP16mask','','','','Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','SrII1side','Angstrom','','','Sr II line index from local continuum at 4077.0 with band widths of 8.0','0');
INSERT DBColumns VALUES('sppLines','SrII1cont','Angstrom','','','Sr II line index from global continuum at 4077.0 with band widths of 8.0','0');
INSERT DBColumns VALUES('sppLines','SrII1err','Angstrom','','','Sr II line index error in the lind band at 4077.0 with band widths of 8.0','0');
INSERT DBColumns VALUES('sppLines','SrII1mask','','','','Sr II pixel quality check =0, good, =1 bad at 4077.0 with band widths of 8.0','0');
INSERT DBColumns VALUES('sppLines','HeI121side','Angstrom','','','He I line index from local continuum at 4026.2 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','HeI121cont','Angstrom','','','He I line index from global continuum at 4026.2 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','HeI121err','Angstrom','','','He I line index error in the lind band at 4026.2 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','HeI121mask','','','','He I pixel quality check =0, good, =1 bad at 4026.2 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta12side','Angstrom','','','Hdelta line index from local continuum at 4101.8 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta12cont','Angstrom','','','Hdelta line index from global continuum at 4101.8 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta12err','Angstrom','','','Hdelta line index error in the lind band at 4101.8 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta12mask','','','','Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta24side','Angstrom','','','Hdelta line index from local continuum at 4101.8 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta24cont','Angstrom','','','Hdelta line index from global continuum at 4101.8 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta24err','Angstrom','','','Hdelta line index error in the lind band at 4101.8 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta24mask','','','','Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta48side','Angstrom','','','Hdelta line index from local continuum at 4101.8 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta48cont','Angstrom','','','Hdelta line index from global continuum at 4101.8 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta48err','Angstrom','','','Hdelta line index error in the lind band at 4101.8 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hdelta48mask','','','','Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hdeltaside','Angstrom','','','Hdelta line index from local continuum at 4102.0 with band widths of 64.0','0');
INSERT DBColumns VALUES('sppLines','Hdeltacont','Angstrom','','','Hdelta line index from global continuum at 4102.0 with band widths of 64.0','0');
INSERT DBColumns VALUES('sppLines','Hdeltaerr','Angstrom','','','Hdelta line index error in the lind band at 4102.0 with band widths of 64.0','0');
INSERT DBColumns VALUES('sppLines','Hdeltamask','','','','Hdelta pixel quality check =0, good, =1 bad at 4102.0 with band widths of 64.0','0');
INSERT DBColumns VALUES('sppLines','CaI4side','Angstrom','','','Ca I line index from local continuum at 4226.0 with band widths of 4.0','0');
INSERT DBColumns VALUES('sppLines','CaI4cont','Angstrom','','','Ca I line index from global continuum at 4226.0 with band widths of 4.0','0');
INSERT DBColumns VALUES('sppLines','CaI4err','Angstrom','','','Ca I line index error in the lind band at 4226.0 with band widths of 4.0','0');
INSERT DBColumns VALUES('sppLines','CaI4mask','','','','Ca I pixel quality check =0, good, =1 bad at 4226.0 with band widths of 4.0','0');
INSERT DBColumns VALUES('sppLines','CaI12side','Angstrom','','','Ca I line index from local continuum at 4226.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','CaI12cont','Angstrom','','','Ca I line index from global continuum at 4226.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','CaI12err','Angstrom','','','Ca I line index error in the lind band at 4226.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','CaI12mask','','','','Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','CaI24side','Angstrom','','','Ca I line index from local continuum at 4226.7 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','CaI24cont','Angstrom','','','Ca I line index from global continuum at 4226.7 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','CaI24err','Angstrom','','','Ca I line index error in the lind band at 4226.7 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','CaI24mask','','','','Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','CaI6side','Angstrom','','','Ca I line index from local continuum at 4226.7 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','CaI6cont','Angstrom','','','Ca I line index from global continuum at 4226.7 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','CaI6err','Angstrom','','','Ca I line index error in the lind band at 4226.7 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','CaI6mask','','','','Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','Gside','Angstrom','','','G band line index from local continuum at 4305.0 with band widths of 15.0','0');
INSERT DBColumns VALUES('sppLines','Gcont','Angstrom','','','G band line index from global continuum at 4305.0 with band widths of 15.0','0');
INSERT DBColumns VALUES('sppLines','Gerr','Angstrom','','','G band line index error in the lind band at 4305.0 with band widths of 15.0','0');
INSERT DBColumns VALUES('sppLines','Gmask','','','','G band pixel quality check =0, good, =1 bad at 4305.0 with band widths of 15.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma12side','Angstrom','','','Hgamma line index from local continuum at 4340.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma12cont','Angstrom','','','Hgamma line index from global continuum at 4340.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma12err','Angstrom','','','Hgamma line index error in the lind band at 4340.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma12mask','','','','Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma24side','Angstrom','','','Hgamma line index from local continuum at 4340.5 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma24cont','Angstrom','','','Hgamma line index from global continuum at 4340.5 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma24err','Angstrom','','','Hgamma line index error in the lind band at 4340.5 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma24mask','','','','Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma48side','Angstrom','','','Hgamma line index from local continuum at 4340.5 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma48cont','Angstrom','','','Hgamma line index from global continuum at 4340.5 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma48err','Angstrom','','','Hgamma line index error in the lind band at 4340.5 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hgamma48mask','','','','Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hgammaside','Angstrom','','','Hgamma line index from local continuum at 4340.5 with band widths of 54.0','0');
INSERT DBColumns VALUES('sppLines','Hgammacont','Angstrom','','','Hgamma line index from global continuum at 4340.5 with band widths of 54.0','0');
INSERT DBColumns VALUES('sppLines','Hgammaerr','Angstrom','','','Hgamma line index error in the lind band at 4340.5 with band widths of 54.0','0');
INSERT DBColumns VALUES('sppLines','Hgammamask','','','','Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 54.0','0');
INSERT DBColumns VALUES('sppLines','HeI122side','Angstrom','','','He I line index from local continuum at 4471.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','HeI122cont','Angstrom','','','He I line index from global continuum at 4471.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','HeI122err','Angstrom','','','He I line index error in the lind band at 4471.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','HeI122mask','','','','He I pixel quality check =0, good, =1 bad at 4471.7 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Gblueside','Angstrom','','','G band line index from local continuum at 4305.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','Gbluecont','Angstrom','','','G band line index from global continuum at 4305.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','Gblueerr','Angstrom','','','G band line index error in the lind band at 4305.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','Gbluemask','','','','G band pixel quality check =0, good, =1 bad at 4305.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','Gwholeside','Angstrom','','','G band line index from local continuum at 4321.0 with band widths of 28.0','0');
INSERT DBColumns VALUES('sppLines','Gwholecont','Angstrom','','','G band line index from global continuum at 4321.0 with band widths of 28.0','0');
INSERT DBColumns VALUES('sppLines','Gwholeerr','Angstrom','','','G band line index error in the lind band at 4321.0 with band widths of 28.0','0');
INSERT DBColumns VALUES('sppLines','Gwholemask','','','','G band pixel quality check =0, good, =1 bad at 4321.0 with band widths of 28.0','0');
INSERT DBColumns VALUES('sppLines','Baside','Angstrom','','','Ba line index from local continuum at 4554.0 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','Bacont','Angstrom','','','Ba line index from global continuum at 4554.0 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','Baerr','Angstrom','','','Ba line index error in the lind band at 4554.0 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','Bamask','','','','Ba pixel quality check =0, good, =1 bad at 4554.0 with band widths of 6.0','0');
INSERT DBColumns VALUES('sppLines','C12C13side','Angstrom','','','C12C13 band line index from local continuum at 4737.0 with band widths of 36.0','0');
INSERT DBColumns VALUES('sppLines','C12C13cont','Angstrom','','','C12C13 band line index from global continuum at 4737.0 with band widths of 36.0','0');
INSERT DBColumns VALUES('sppLines','C12C13err','Angstrom','','','C12C13 band line index error in the lind band at 4737.0 with band widths of 36.0','0');
INSERT DBColumns VALUES('sppLines','C12C13mask','','','','C12C13 band pixel quality check =0, good, =1 bad at 4737.0 with band widths of 36.0','0');
INSERT DBColumns VALUES('sppLines','CC12side','Angstrom','','','C2 band line index from local continuum at 4618.0 with band widths of 256.0','0');
INSERT DBColumns VALUES('sppLines','CC12cont','Angstrom','','','C2 band line index from global continuum at 4618.0 with band widths of 256.0','0');
INSERT DBColumns VALUES('sppLines','CC12err','Angstrom','','','C2 band line index error in the lind band at 4618.0 with band widths of 256.0','0');
INSERT DBColumns VALUES('sppLines','CC12mask','','','','C2 band pixel quality check =0, good, =1 bad at 4618.0 with band widths of 256.0','0');
INSERT DBColumns VALUES('sppLines','metal1side','Angstrom','','','Metallic line index from local continuum at 4584.0 with band widths of 442.0','0');
INSERT DBColumns VALUES('sppLines','metal1cont','Angstrom','','','Metallic line index from global continuum at 4584.0 with band widths of 442.0','0');
INSERT DBColumns VALUES('sppLines','metal1err','Angstrom','','','Metlllic line index error in the lind band at 4584.0 with band widths of 442.0','0');
INSERT DBColumns VALUES('sppLines','metal1mask','','','','Metal1ic pixel quality check =0, good, =1 bad at 4584.0 with band widths of 442.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta12side','Angstrom','','','Hbeta line index from local continuum at 4862.3 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta12cont','Angstrom','','','Hbeta line index from global continuum at 4862.3 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta12err','Angstrom','','','Hbeta line index error in the lind band at 4862.3 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta12mask','','','','Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta24side','Angstrom','','','Hbeta line index from local continuum at 4862.3 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta24cont','Angstrom','','','Hbeta line index from global continuum at 4862.3 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta24err','Angstrom','','','Hbeta line index error in the lind band at 4862.3 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta24mask','','','','Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta48side','Angstrom','','','Hbeta line index from local continuum at 4862.3 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta48cont','Angstrom','','','Hbeta line index from global continuum at 4862.3 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta48err','Angstrom','','','Hbeta line index error in the lind band at 4862.3 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hbeta48mask','','','','Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Hbetaside','Angstrom','','','Hbeta line index from local continuum at 4862.3 with band widths of 60.0','0');
INSERT DBColumns VALUES('sppLines','Hbetacont','Angstrom','','','Hbeta line index from global continuum at 4862.3 with band widths of 60.0','0');
INSERT DBColumns VALUES('sppLines','Hbetaerr','Angstrom','','','Hbeta line index error in the lind band at 4862.3 with band widths of 60.0','0');
INSERT DBColumns VALUES('sppLines','Hbetamask','','','','Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 60.0','0');
INSERT DBColumns VALUES('sppLines','C2side','Angstrom','','','C2 band line index from local continuum at 5052.0 with band widths of 204.0','0');
INSERT DBColumns VALUES('sppLines','C2cont','Angstrom','','','C2 band line index from global continuum at 5052.0 with band widths of 204.0','0');
INSERT DBColumns VALUES('sppLines','C2err','Angstrom','','','C2 band line index error in the lind band at 5052.0 with band widths of 204.0','0');
INSERT DBColumns VALUES('sppLines','C2mask','','','','C2 band pixel quality check =0, good, =1 bad at 5052.0 with band widths of 204.0','0');
INSERT DBColumns VALUES('sppLines','C2MgIside','Angstrom','','','C2 and Mg I line index from local continuum at 5069.0 with band widths of 238.0','0');
INSERT DBColumns VALUES('sppLines','C2MgIcont','Angstrom','','','C2 and Mg I line index from global continuum at 5069.0 with band widths of 238.0','0');
INSERT DBColumns VALUES('sppLines','C2MgIerr','Angstrom','','','C2 and Mg I line index error in the lind band at 5069.0 with band widths of 238.0','0');
INSERT DBColumns VALUES('sppLines','C2MgImask','','','','C2 and Mg I pixel quality check =0, good, =1 bad at 5069.0 with band widths of 238.0','0');
INSERT DBColumns VALUES('sppLines','MgHMgIC2side','Angstrom','','','MgH, Mg I, and C2 line index from local continuum at 5085.0 with band widths of 270.0','0');
INSERT DBColumns VALUES('sppLines','MgHMgIC2cont','Angstrom','','','MgH, Mg I, and C2 line index from global continuum at 5085.0 with band widths of 270.0','0');
INSERT DBColumns VALUES('sppLines','MgHMgIC2err','Angstrom','','','MgH, Mg I, and C2 line index error in the lind band at 5085.0 with band widths of 270.0','0');
INSERT DBColumns VALUES('sppLines','MgHMgIC2mask','','','','MgH, Mg I, and C2 pixel quality check =0, good, =1 bad at 5085.0 with band widths of 270.0','0');
INSERT DBColumns VALUES('sppLines','MgHMgIside','Angstrom','','','MgH and Mg I line index from local continuum at 5198.0 with band widths of 44.0','0');
INSERT DBColumns VALUES('sppLines','MgHMgIcont','Angstrom','','','MgH and Mg I line index from global continuum at 5198.0 with band widths of 44.0','0');
INSERT DBColumns VALUES('sppLines','MgHMgIerr','Angstrom','','','MgH and Mg I line index error in the lind band at 5198.0 with band widths of 44.0','0');
INSERT DBColumns VALUES('sppLines','MgHMgImask','','','','MgH_MgI pixel quality check =0, good, =1 bad at 5198.0 with band widths of 44.0','0');
INSERT DBColumns VALUES('sppLines','MgHside','Angstrom','','','MgH line index from local continuum at 5210.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','MgHcont','Angstrom','','','MgH line index from global continuum at 5210.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','MgHerr','Angstrom','','','MgH line index error in the lind band at 5210.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','MgHmask','','','','MgH pixel quality check =0, good, =1 bad at 5210.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','CrIside','Angstrom','','','Cr I line index from local continuum at 5206.0 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','CrIcont','Angstrom','','','Cr I line index from global continuum at 5206.0 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','CrIerr','Angstrom','','','Cr I line index error in the lind band at 5206.0 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','CrImask','','','','Cr I pixel quality check =0, good, =1 bad at 5206.0 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','MgIFeIIside','Angstrom','','','Mg I and Fe II line index from local continuum at 5175.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','MgIFeIIcont','Angstrom','','','Mg I and Fe II line index from global continuum at 5175.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','MgIFeIIerr','Angstrom','','','Mg I and Fe II line index error in the lind band at 5175.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','MgIFeIImask','','','','Mg I and Fe II pixel quality check =0, good, =1 bad at 5175.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','MgI2side','Angstrom','','','Mg I line index from local continuum at 5183.0 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','MgI2cont','Angstrom','','','Mg I line index from global continuum at 5183.0 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','MgI2err','Angstrom','','','Mg I line index error in the lind band at 5183.0 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','MgI2mask','','','','Mg I pixel quality check =0, good, =1 bad at 5183.0 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','MgI121side','Angstrom','','','Mg I line index from local continuum at 5170.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','MgI121cont','Angstrom','','','Mg I line index from global continuum at 5170.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','MgI121err','Angstrom','','','Mg I line index error in the lind band at 5170.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','MgI121mask','','','','Mg I pixel quality check =0, good, =1 bad at 5170.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','MgI24side','Angstrom','','','Mg I line index from local continuum at 5176.5 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','MgI24cont','Angstrom','','','Mg I line index from global continuum at 5176.5 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','MgI24err','Angstrom','','','Mg I line index error in the lind band at 5176.5 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','MgI24mask','','','','Mg I pixel quality check =0, good, =1 bad at 5176.5 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','MgI122side','Angstrom','','','Mg I line index from local continuum at 5183.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','MgI122cont','Angstrom','','','Mg I line index from global continuum at 5183.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','MgI122err','Angstrom','','','Mg I line index error in the lind band at 5183.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','MgI122mask','','','','Mg I pixel quality check =0, good, =1 bad at 5183.5 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','NaI20side','Angstrom','','','Na I line index from local continuum at 5890.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','NaI20cont','Angstrom','','','Na I line index from global continuum at 5890.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','NaI20err','Angstrom','','','Na I line index error in the lind band at 5890.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','NaI20mask','','','','Na I pixel quality check =0, good, =1 bad at 5890.0 with band widths of 20.0','0');
INSERT DBColumns VALUES('sppLines','Na12side','Angstrom','','','Na line index from local continuum at 5892.9 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Na12cont','Angstrom','','','Na line index from global continuum at 5892.9 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Na12err','Angstrom','','','Na line index error in the lind band at 5892.9 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Na12mask','','','','Na pixel quality check =0, good, =1 bad at 5892.9 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Na24side','Angstrom','','','Na line index from local continuum at 5892.9 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Na24cont','Angstrom','','','Na line index from global continuum at 5892.9 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Na24err','Angstrom','','','Na line index error in the lind band at 5892.9 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Na24mask','','','','Na pixel quality check =0, good, =1 bad at 5892.9 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Halpha12side','Angstrom','','','Halpha line index from local continuum at 6562.8 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Halpha12cont','Angstrom','','','Halpha line index from global continuum at 6562.8 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Halpha12err','Angstrom','','','Halpha line index error in the lind band at 6562.8 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Halpha12mask','','','','Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 12.0','0');
INSERT DBColumns VALUES('sppLines','Halpha24side','Angstrom','','','Halpha line index from local continuum at 6562.8 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Halpha24cont','Angstrom','','','Halpha line index from global continuum at 6562.8 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Halpha24err','Angstrom','','','Halpha line index error in the lind band at 6562.8 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Halpha24mask','','','','Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 24.0','0');
INSERT DBColumns VALUES('sppLines','Halpha48side','Angstrom','','','Halpha line index from local continuum at 6562.8 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Halpha48cont','Angstrom','','','Halpha line index from global continuum at 6562.8 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Halpha48err','Angstrom','','','Halpha line index error in the lind band at 6562.8 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Halpha48mask','','','','Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 48.0','0');
INSERT DBColumns VALUES('sppLines','Halpha70side','Angstrom','','','Halpha line index from local continuum at 6562.8 with band widths of 70.0','0');
INSERT DBColumns VALUES('sppLines','Halpha70cont','Angstrom','','','Halpha line index from global continuum at 6562.8 with band widths of 70.0','0');
INSERT DBColumns VALUES('sppLines','Halpha70err','Angstrom','','','Halpha line index error in the lind band at 6562.8 with band widths of 70.0','0');
INSERT DBColumns VALUES('sppLines','Halpha70mask','','','','Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 70.0','0');
INSERT DBColumns VALUES('sppLines','CaHside','Angstrom','','','CaH line index from local continuum at 6788.0 with band widths of 505.0','0');
INSERT DBColumns VALUES('sppLines','CaHcont','Angstrom','','','CaH line index from global continuum at 6788.0 with band widths of 505.0','0');
INSERT DBColumns VALUES('sppLines','CaHerr','Angstrom','','','CaH line index error in the lind band at 6788.0 with band widths of 505.0','0');
INSERT DBColumns VALUES('sppLines','CaHmask','','','','CaH pixel quality check =0, good, =1 bad at 6788.0 with band widths of 505.0','0');
INSERT DBColumns VALUES('sppLines','TiOside','Angstrom','','','TiO line index from local continuum at 7209.0 with band widths of 333.3','0');
INSERT DBColumns VALUES('sppLines','TiOcont','Angstrom','','','TiO line index from global continuum at 7209.0 with band widths of 333.3','0');
INSERT DBColumns VALUES('sppLines','TiOerr','Angstrom','','','TiO line index error in the lind band at 7209.0 with band widths of 333.3','0');
INSERT DBColumns VALUES('sppLines','TiOmask','','','','TiO pixel quality check =0, good, =1 bad at 7209.0 with band widths of 333.3','0');
INSERT DBColumns VALUES('sppLines','CNside','Angstrom','','','CN line index from local continuum at 6890.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','CNcont','Angstrom','','','CN line index from global continuum at 6890.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','CNerr','Angstrom','','','CN line index error in the lind band at 6890.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','CNmask','','','','CN pixel quality check =0, good, =1 bad at 6890.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','OItripside','Angstrom','','','O I triplet line index from local continuu at 7775.0 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','OItripcont','Angstrom','','','O I triplet line index from global continuum at 7775.0 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','OItriperr','Angstrom','','','O I triplet line index error in the lind band at 7775.0 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','OItripmask','','','','O I triplet pixel quality check =0, good, =1 bad at 7775.0 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','KI34side','Angstrom','','','K I line index from local continuum at 7687.0 with band widths of 34.0','0');
INSERT DBColumns VALUES('sppLines','KI34cont','Angstrom','','','K I line index from global continuum at 7687.0 with band widths of 34.0','0');
INSERT DBColumns VALUES('sppLines','KI34err','Angstrom','','','K I line index error in the lind band at 7687.0 with band widths of 34.0','0');
INSERT DBColumns VALUES('sppLines','KI34mask','','','','K I pixel quality check =0, good, =1 bad at 7687.0 with band widths of 34.0','0');
INSERT DBColumns VALUES('sppLines','KI95side','Angstrom','','','K I line index from local continuum at 7688.0 with band widths of 95.0','0');
INSERT DBColumns VALUES('sppLines','KI95cont','Angstrom','','','K I line index from global continuum at 7688.0 with band widths of 95.0','0');
INSERT DBColumns VALUES('sppLines','KI95err','Angstrom','','','K I line index error in the lind band at 7688.0 with band widths of 95.0','0');
INSERT DBColumns VALUES('sppLines','KI95mask','','','','K I pixel quality check =0, good, =1 bad at 7688.0 with band widths of 95.0','0');
INSERT DBColumns VALUES('sppLines','NaI15side','Angstrom','','','Na I line index from local continuum at 8187.5 with band widths of 15.0','0');
INSERT DBColumns VALUES('sppLines','NaI15cont','Angstrom','','','Na I line index from global continuum at 8187.5 with band widths of 15.0','0');
INSERT DBColumns VALUES('sppLines','NaI15err','Angstrom','','','Na I line index error in the lind band at 8187.5 with band widths of 15.0','0');
INSERT DBColumns VALUES('sppLines','NaI15mask','','','','Na I pixel quality check =0, good, =1 bad at 8187.5 with band widths of 15.0','0');
INSERT DBColumns VALUES('sppLines','NaIredside','Angstrom','','','Na I line index from local continuum at 8190.2 with band widths of 33.0','0');
INSERT DBColumns VALUES('sppLines','NaIredcont','Angstrom','','','Na I line index from global continuum at 8190.2 with band widths of 33.0','0');
INSERT DBColumns VALUES('sppLines','NaIrederr','Angstrom','','','Na I line index error in the lind band at 8190.2 with band widths of 33.0','0');
INSERT DBColumns VALUES('sppLines','NaIredmask','','','','Na I pixel quality check =0, good, =1 bad at 8190.2 with band widths of 33.0','0');
INSERT DBColumns VALUES('sppLines','CaII26side','Angstrom','','','Ca II triplet line index from local continuum at 8498.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','CaII26cont','Angstrom','','','Ca II triplet line index from global continuum at 8498.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','CaII26err','Angstrom','','','Ca II triplet line index error in the lind band at 8498.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','CaII26mask','','','','Ca II triplet pixel quality check =0, good, =1 bad at 8498.0 with band widths of 26.0','0');
INSERT DBColumns VALUES('sppLines','Paschen13side','Angstrom','','','Paschen line index from local continuum at 8467.5 with band widths of 13.0','0');
INSERT DBColumns VALUES('sppLines','Paschen13cont','Angstrom','','','Paschen line index from global continuum at 8467.5 with band widths of 13.0','0');
INSERT DBColumns VALUES('sppLines','Paschen13err','Angstrom','','','Paschen line index error in the lind band at 8467.5 with band widths of 13.0','0');
INSERT DBColumns VALUES('sppLines','Paschen13mask','','','','Paschen pixel quality check =0, good, =1 bad at 8467.5 with band widths of 13.0','0');
INSERT DBColumns VALUES('sppLines','CaII29side','Angstrom','','','Ca II triplet line index from local continuum at 8498.5 with band widths of 29.0','0');
INSERT DBColumns VALUES('sppLines','CaII29cont','Angstrom','','','Ca II triplet line index from global continuum at 8498.5 with band widths of 29.0','0');
INSERT DBColumns VALUES('sppLines','CaII29err','Angstrom','','','Ca II triplet line index error in the lind band at 8498.5 with band widths of 29.0','0');
INSERT DBColumns VALUES('sppLines','CaII29mask','','','','Ca II triplet pixel quality check =0, good, =1 bad at 8498.5 with band widths of 29.0','0');
INSERT DBColumns VALUES('sppLines','CaII401side','Angstrom','','','Ca II triplet line index from local continuum at 8542.0 with band widths of 40.0','0');
INSERT DBColumns VALUES('sppLines','CaII401cont','Angstrom','','','Ca II triplet line index from global continuum at 8542.0 with band widths of 40.0','0');
INSERT DBColumns VALUES('sppLines','CaII401err','Angstrom','','','Ca II triplet line index error in the lind band at 8542.0 with band widths of 40.0','0');
INSERT DBColumns VALUES('sppLines','CaII401mask','','','','Ca II triplet pixel quality check =0, good, =1 bad at 8542.0 with band widths of 40.0','0');
INSERT DBColumns VALUES('sppLines','CaII161side','Angstrom','','','Ca II triplet_1 line index from local continuum at 8542.0 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','CaII161cont','Angstrom','','','Ca II triplet_1 line index from global continuum at 8542.0 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','CaII161err','Angstrom','','','Ca II triplet_1 line index error in the lind band at 8542.0 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','CaII161mask','','','','Ca II triplet_1 pixel quality check =0, good, =1 bad at 8542.0 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','Paschen421side','Angstrom','','','Paschen line index from local continuum at 8598.0 with band widths of 42.0','0');
INSERT DBColumns VALUES('sppLines','Paschen421cont','Angstrom','','','Paschen line index from global continuum at 8598.0 with band widths of 42.0','0');
INSERT DBColumns VALUES('sppLines','Paschen421err','Angstrom','','','Paschen line index error in the lind band at 8598.0 with band widths of 42.0','0');
INSERT DBColumns VALUES('sppLines','Paschen421mask','','','','Paschen pixel quality check =0, good, =1 bad at 8598.0 with band widths of 42.0','0');
INSERT DBColumns VALUES('sppLines','CaII162side','Angstrom','','','Ca II triplet line index from local continuum at 8662.1 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','CaII162cont','Angstrom','','','Ca II triplet line index from global continuum at 8662.1 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','CaII162err','Angstrom','','','Ca II triplet line index error in the lind band at 8662.1 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','CaII162mask','','','','Ca II triplet pixel quality check =0, good, =1 bad at 8662.1 with band widths of 16.0','0');
INSERT DBColumns VALUES('sppLines','CaII402side','Angstrom','','','Ca II triplet line index from local continuum at 8662.0 with band widths of 40.0','0');
INSERT DBColumns VALUES('sppLines','CaII402cont','Angstrom','','','Ca II triplet line index from global continuum at 8662.0 with band widths of 40.0','0');
INSERT DBColumns VALUES('sppLines','CaII402err','Angstrom','','','Ca II triplet line index error in the lind band at 8662.0 with band widths of 40.0','0');
INSERT DBColumns VALUES('sppLines','CaII402mask','','','','Ca II triplet pixel quality check =0, good, =1 bad at 8662.0 with band widths of 40.0','0');
INSERT DBColumns VALUES('sppLines','Paschen422side','Angstrom','','','Paschen line index from local continuum at 8751.0 with band widths of 42.0','0');
INSERT DBColumns VALUES('sppLines','Paschen422cont','Angstrom','','','Paschen line index from global continuum at 8751.0 with band widths of 42.0','0');
INSERT DBColumns VALUES('sppLines','Paschen422err','Angstrom','','','Paschen line index error in the lind band at 8751.0 with band widths of 42.0','0');
INSERT DBColumns VALUES('sppLines','Paschen422mask','','','','Paschen pixel quality check =0, good, =1 bad at 8751.0 with band widths of 42.0','0');
INSERT DBColumns VALUES('sppLines','TiO5side','','','','TiO5 line index from local continuum at 7134.4 with band widths of 5.0','0');
INSERT DBColumns VALUES('sppLines','TiO5cont','','','','TiO5 line index from global continuum at 7134.4 with band widths of 5.0','0');
INSERT DBColumns VALUES('sppLines','TiO5err','','','','TiO5 line index error in the lind band at 7134.4 with band widths of 5.0','0');
INSERT DBColumns VALUES('sppLines','TiO5mask','','','','TiO5 pixel quality check =0, good, =1 bad at 7134.4 with band widths of 5.0','0');
INSERT DBColumns VALUES('sppLines','TiO8side','','','','TiO8 line index from local continuum at 8457.3 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','TiO8cont','','','','TiO8 line index from global continuum at 8457.3 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','TiO8err','','','','TiO8 line index error in the lind band at 8457.3 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','TiO8mask','','','','TiO8 pixel quality check =0, good, =1 bad at 8457.3 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','CaH1side','','','','CaH1 line index from local continuum at 6386.7 with band widths of 10.0','0');
INSERT DBColumns VALUES('sppLines','CaH1cont','','','','CaH1 line index from global continuum at 6386.7 with band widths of 10.0','0');
INSERT DBColumns VALUES('sppLines','CaH1err','','','','CaH1 line index error in the lind band at 6386.7 with band widths of 10.0','0');
INSERT DBColumns VALUES('sppLines','CaH1mask','','','','CaH1 pixel quality check =0, good, =1 bad at 6386.7 with band widths of 10.0','0');
INSERT DBColumns VALUES('sppLines','CaH2side','','','','CaH2 line index from local continuum at 6831.9 with band widths of 32.0','0');
INSERT DBColumns VALUES('sppLines','CaH2cont','','','','CaH2 line index from global continuum at 6831.9 with band widths of 32.0','0');
INSERT DBColumns VALUES('sppLines','CaH2err','','','','CaH2 line index error in the lind band at 6831.9 with band widths of 32.0','0');
INSERT DBColumns VALUES('sppLines','CaH2mask','','','','CaH2 pixel quality check =0, good, =1 bad at 6831.9 with band widths of 32.0','0');
INSERT DBColumns VALUES('sppLines','CaH3side','','','','CaH3 line index from local continuum at 6976.9 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','CaH3cont','','','','CaH3 line index from global continuum at 6976.9 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','CaH3err','','','','CaH3 line index error in the lind band at 6976.9 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','CaH3mask','','','','CaH3 pixel quality check =0, good, =1 bad at 6976.9 with band widths of 30.0','0');
INSERT DBColumns VALUES('sppLines','UVCNside','','','','CN line index at 3839','0');
INSERT DBColumns VALUES('sppLines','UVCNcont','','','','CN line index at 3839','0');
INSERT DBColumns VALUES('sppLines','UVCNerr','','','','CN line index error at 3829','0');
INSERT DBColumns VALUES('sppLines','UVCNmask','','','','CN pixel quality check =0, good, =1 bad at 3839','0');
INSERT DBColumns VALUES('sppLines','BLCNside','','','','CN line index at 4142','0');
INSERT DBColumns VALUES('sppLines','BLCNcont','','','','CN line index at 4142','0');
INSERT DBColumns VALUES('sppLines','BLCNerr','','','','CN line index error at 4142','0');
INSERT DBColumns VALUES('sppLines','BLCNmask','','','','CN pixel quality check =0, good, =1 bad at 4142','0');
INSERT DBColumns VALUES('sppLines','FEI1side','Angstrom','','','Fe I line index at 4045.8 with band widths of 2.5','0');
INSERT DBColumns VALUES('sppLines','FEI1cont','Angstrom','','','Fe I line index at 4045.8 with band widths of 2.5','0');
INSERT DBColumns VALUES('sppLines','FEI1err','Angstrom','','','Fe I line index error at 4045.8 with band widths of 2.5','0');
INSERT DBColumns VALUES('sppLines','FEI1mask','','','','Fe I pixel quality check =0, good, =1 bad at 4045.8 with band widths of 2.5','0');
INSERT DBColumns VALUES('sppLines','FEI2side','Angstrom','','','Fe I line index at 4063.6 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','FEI2cont','Angstrom','','','Fe I line index at 4063.6 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','FEI2err','Angstrom','','','Fe I line index error at 4063.6 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','FEI2mask','','','','Fe I pixel quality check =0, good, =1 bad at 4063.6 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','FEI3side','Angstrom','','','Fe I line index at 4071.7 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','FEI3cont','Angstrom','','','Fe I line index at 4071.7 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','FEI3err','Angstrom','','','Fe I line index error at 4071.7 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','FEI3mask','','','','Fe I pixel quality check =0, good, =1 bad at 4071.7 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','SRII2side','Angstrom','','','Sr II line index at 4077.7 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','SRII2cont','Angstrom','','','Sr II line index at 4077.7 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','SRII2err','Angstrom','','','Sr II line index error at 4077.7 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','SRII2mask','','','','Sr II pixel quality check =0, good, =1 bad at 4077.7 with band widths of 2.0','0');
INSERT DBColumns VALUES('sppLines','FEI4side','','','','Fe I line index at 4679.5 with band widths of 87.0','0');
INSERT DBColumns VALUES('sppLines','FEI4cont','','','','Fe I line index at 4679.5 with band widths of 87.0','0');
INSERT DBColumns VALUES('sppLines','FEI4err','','','','Fe I line index error at 4679.5 with band widths of 87.0','0');
INSERT DBColumns VALUES('sppLines','FEI4mask','','','','Fe I pixel quality check =0, good, =1 bad at 4679.5 with band widths of 87.0','0');
INSERT DBColumns VALUES('sppLines','FEI5side','','','','Fe I line index at 5267.4 with band widths of 38.8','0');
INSERT DBColumns VALUES('sppLines','FEI5cont','','','','Fe I line index at 5267.4 with band widths of 38.8','0');
INSERT DBColumns VALUES('sppLines','FEI5err','','','','Fe I line index error at 5267.4 with band widths of 38.8','0');
INSERT DBColumns VALUES('sppLines','FEI5mask','','','','Fe I pixel quality check =0, good, =1 bad at 5267.4 with band widths of 38.8','0');
INSERT DBColumns VALUES('sppParams','specObjID','','','','id number, match in specObjAll','0');
INSERT DBColumns VALUES('sppParams','bestObjID','','ID_MAIN','','Object ID of best PhotoObj match (flux-based)','0');
INSERT DBColumns VALUES('sppParams','origObjID','','ID_MAIN','','Object ID of best PhotoObj match (position-based)','0');
INSERT DBColumns VALUES('sppParams','targetObjID','','','','Object ID of original target','0');
INSERT DBColumns VALUES('sppParams','plateID','','','','Database ID of Plate (match in plateX)','0');
INSERT DBColumns VALUES('sppParams','sciencePrimary','','','','Best version of spectrum at this location (defines default view SpecObj)','0');
INSERT DBColumns VALUES('sppParams','legacyPrimary','','','','Best version of spectrum at this location, among Legacy plates','0');
INSERT DBColumns VALUES('sppParams','seguePrimary','','','','Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj)','0');
INSERT DBColumns VALUES('sppParams','firstRelease','','','','Name of first release this object was associated with','0');
INSERT DBColumns VALUES('sppParams','SURVEY','','','','Survey name','0');
INSERT DBColumns VALUES('sppParams','PROGRAMNAME','','','','Program name','0');
INSERT DBColumns VALUES('sppParams','CHUNK','','','','Chunk name','0');
INSERT DBColumns VALUES('sppParams','PLATERUN','','','','Plate drill run name','0');
INSERT DBColumns VALUES('sppParams','MJD','','','','Modified Julian Date of observation','0');
INSERT DBColumns VALUES('sppParams','PLATE','','','','Plate number','0');
INSERT DBColumns VALUES('sppParams','FIBERID','','','','Fiber number (1-640)','0');
INSERT DBColumns VALUES('sppParams','RUN2D','','','','Name of 2D rerun','0');
INSERT DBColumns VALUES('sppParams','RUN1D','','','','Name of 1D rerun','0');
INSERT DBColumns VALUES('sppParams','RUNSSPP','','','','Name of SSPP rerun','0');
INSERT DBColumns VALUES('sppParams','TARGETSTRING','','','','ASCII translation of target selection information as determined at the time the plate was designed','0');
INSERT DBColumns VALUES('sppParams','PRIMTARGET','','','','Target selection information at plate design, primary science selection (for backwards compatibility)','0');
INSERT DBColumns VALUES('sppParams','SECTARGET','','','','Target selection information at plate design, secondary/qa/calib selection  (for backwards compatibility)','0');
INSERT DBColumns VALUES('sppParams','LEGACY_TARGET1','','','','Legacy target selection information at plate design, primary science selection','0');
INSERT DBColumns VALUES('sppParams','LEGACY_TARGET2','','','','Legacy target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('sppParams','SPECIAL_TARGET1','','','','Special program target selection information at plate design, primary science selection','0');
INSERT DBColumns VALUES('sppParams','SPECIAL_TARGET2','','','','Special program target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('sppParams','SEGUE1_TARGET1','','','','SEGUE-1 target selection information at plate design, primary science selection','0');
INSERT DBColumns VALUES('sppParams','SEGUE1_TARGET2','','','','SEGUE-1 target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('sppParams','SEGUE2_TARGET1','','','','SEGUE-2 target selection information at plate design, primary science selection','0');
INSERT DBColumns VALUES('sppParams','SEGUE2_TARGET2','','','','SEGUE-2 target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('sppParams','SPECTYPEHAMMER','','','','Spectral Type from HAMMER','0');
INSERT DBColumns VALUES('sppParams','SPECTYPEELODIE','','','','Spectral Type from ELODIE templates','0');
INSERT DBColumns VALUES('sppParams','FLAG','','','','Flag with combination of four letters among BCdDEgGhHlnNSV, n=normal','0');
INSERT DBColumns VALUES('sppParams','TEFFADOP','Kelvin','','','Adopted Teff, bi-weigth average of estimators with indicator variable of 1','0');
INSERT DBColumns VALUES('sppParams','TEFFADOPN','Kelvin','','','Number of estimators used in bi-weight average','0');
INSERT DBColumns VALUES('sppParams','TEFFADOPUNC','Kelvin','','','Error in the adopted temperature','0');
INSERT DBColumns VALUES('sppParams','TEFFHA24','Kelvin','','','Teff estimate from HA24','0');
INSERT DBColumns VALUES('sppParams','TEFFHD24','Kelvin','','','Teff estimate from HD24','0');
INSERT DBColumns VALUES('sppParams','TEFFTK','Kelvin','','','Teff estimate from TKurucz','0');
INSERT DBColumns VALUES('sppParams','TEFFTG','Kelvin','','','Teff estimate from TGirardi','0');
INSERT DBColumns VALUES('sppParams','TEFFTI','Kelvin','','','Teff estimate from TIveciz','0');
INSERT DBColumns VALUES('sppParams','TEFFNGS1','Kelvin','','','Teff estimate from NGS1','0');
INSERT DBColumns VALUES('sppParams','TEFFANNSR','Kelvin','','','Teff estimate from ANNSR','0');
INSERT DBColumns VALUES('sppParams','TEFFANNRR','Kelvin','','','Teff estimate from ANNRR','0');
INSERT DBColumns VALUES('sppParams','TEFFWBG','Kelvin','','','Teff estimate from WBG','0');
INSERT DBColumns VALUES('sppParams','TEFFK24','Kelvin','','','Teff estimate from k24','0');
INSERT DBColumns VALUES('sppParams','TEFFKI13','Kelvin','','','Teff estimate from ki13','0');
INSERT DBColumns VALUES('sppParams','TEFFHA24IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFHD24IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFTKIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFTGIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFTIIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFNGS1IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFANNSRIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFANNRRIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFWBGIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFK24IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFKI13IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','TEFFHA24UNC','Kelvin','','','Error in Teff estimate from HA24','0');
INSERT DBColumns VALUES('sppParams','TEFFHD24UNC','Kelvin','','','Error in Teff estimate from HD24','0');
INSERT DBColumns VALUES('sppParams','TEFFTKUNC','Kelvin','','','Error in Teff estimate from TKurucz','0');
INSERT DBColumns VALUES('sppParams','TEFFTGUNC','Kelvin','','','Error in Teff estimate from TGirardi','0');
INSERT DBColumns VALUES('sppParams','TEFFTIUNC','Kelvin','','','Error in Teff estimate from TIveciz','0');
INSERT DBColumns VALUES('sppParams','TEFFNGS1UNC','Kelvin','','','Error in Teff estimate from NGS1','0');
INSERT DBColumns VALUES('sppParams','TEFFANNSRUNC','Kelvin','','','Error in Teff estimate from ANNSR','0');
INSERT DBColumns VALUES('sppParams','TEFFANNRRUNC','Kelvin','','','Error in Teff estimate from ANNRR','0');
INSERT DBColumns VALUES('sppParams','TEFFWBGUNC','Kelvin','','','Error in Teff estimate from WBG','0');
INSERT DBColumns VALUES('sppParams','TEFFK24UNC','Kelvin','','','Error in Teff estimate from k24','0');
INSERT DBColumns VALUES('sppParams','TEFFKI13UNC','Kelvin','','','Error in Teff estimate from ki13','0');
INSERT DBColumns VALUES('sppParams','LOGGADOP','dex','','','Adopted log g, bi-weigth average of estimators with indicator variable of 2','0');
INSERT DBColumns VALUES('sppParams','LOGGADOPN','','','','Number of log g estimators in used bi-weight average','0');
INSERT DBColumns VALUES('sppParams','LOGGADOPUNC','dex','','','Error in the adopted log g','0');
INSERT DBColumns VALUES('sppParams','LOGGNGS2','dex','','','log g estimate from NGS2','0');
INSERT DBColumns VALUES('sppParams','LOGGNGS1','dex','','','log g estimate from NGS1','0');
INSERT DBColumns VALUES('sppParams','LOGGANNSR','dex','','','log g estimate from ANNSR','0');
INSERT DBColumns VALUES('sppParams','LOGGANNRR','dex','','','log g estimate from ANNRR','0');
INSERT DBColumns VALUES('sppParams','LOGGCAI1','dex','','','log g estimate from CaI1','0');
INSERT DBColumns VALUES('sppParams','LOGGCAI2','dex','','','log g estimate from CaI2','0');
INSERT DBColumns VALUES('sppParams','LOGGMGH','dex','','','log g estimate from MgH','0');
INSERT DBColumns VALUES('sppParams','LOGGWBG','dex','','','log g estimate from WBG','0');
INSERT DBColumns VALUES('sppParams','LOGGK24','dex','','','log g estimate from k24','0');
INSERT DBColumns VALUES('sppParams','LOGGKI13','dex','','','log g estimate from ki13','0');
INSERT DBColumns VALUES('sppParams','LOGGNGS2IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGNGS1IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGANNSRIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGANNRRIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGCAI1IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGCAI2IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGMGHIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGWBGIND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGK24IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGKI13IND','','','','Indicator variable, = 0 bad, = 1 good','0');
INSERT DBColumns VALUES('sppParams','LOGGNGS2UNC','dex','','','Error in log g estimate from NGS2','0');
INSERT DBColumns VALUES('sppParams','LOGGNGS1UNC','dex','','','Error in log g estimate from NGS1','0');
INSERT DBColumns VALUES('sppParams','LOGGANNSRUNC','dex','','','Error in log g estimate from ANNSR','0');
INSERT DBColumns VALUES('sppParams','LOGGANNRRUNC','dex','','','Error in log g estimate from ANNRR','0');
INSERT DBColumns VALUES('sppParams','LOGGCAI1UNC','dex','','','Error in log g estimate from CaI1','0');
INSERT DBColumns VALUES('sppParams','LOGGCAI2UNC','dex','','','Error in log g estimate from CaI2','0');
INSERT DBColumns VALUES('sppParams','LOGGMGHUNC','dex','','','Error in log g estimate from MgH','0');
INSERT DBColumns VALUES('sppParams','LOGGWBGUNC','dex','','','Error in log g estimate from WBG','0');
INSERT DBColumns VALUES('sppParams','LOGGK24UNC','dex','','','Error in log g estimate from k24','0');
INSERT DBColumns VALUES('sppParams','LOGGKI13UNC','dex','','','Error in log g estimate from ki13','0');
INSERT DBColumns VALUES('sppParams','FEHADOP','dex','','','Adopted [Fe/H], bi-weigth average of estimators with indicator variable of 2','0');
INSERT DBColumns VALUES('sppParams','FEHADOPN','','','','Number of estimators used in bi-weight average','0');
INSERT DBColumns VALUES('sppParams','FEHADOPUNC','dex','','','Error in the adopted [Fe/H]','0');
INSERT DBColumns VALUES('sppParams','FEHNGS2','dex','','','[Fe/H] estimate from NGS2','0');
INSERT DBColumns VALUES('sppParams','FEHNGS1','dex','','','[Fe/H] estimate from NGS1','0');
INSERT DBColumns VALUES('sppParams','FEHANNSR','dex','','','[Fe/H] estimate from ANNSR','0');
INSERT DBColumns VALUES('sppParams','FEHANNRR','dex','','','[Fe/H] estimate from ANNRR','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK1','dex','','','[Fe/H] estimate from CaIIK1','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK2','dex','','','[Fe/H] estimate from CaIIK2','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK3','dex','','','[Fe/H] estimate from CaIIK3','0');
INSERT DBColumns VALUES('sppParams','FEHACF','dex','','','[Fe/H] estimate from ACF','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIT','dex','','','[Fe/H] estimate from CaIIT','0');
INSERT DBColumns VALUES('sppParams','FEHWBG','dex','','','[Fe/H] estimate from WBG','0');
INSERT DBColumns VALUES('sppParams','FEHK24','dex','','','[Fe/H] estimate from k24','0');
INSERT DBColumns VALUES('sppParams','FEHKI13','dex','','','[Fe/H] estimate from ki13','0');
INSERT DBColumns VALUES('sppParams','FEHNGS2IND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHNGS1IND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHANNSRIND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHANNRRIND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK1IND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK2IND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK3IND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHACFIND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHCAIITIND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHWBGIND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHK24IND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHKI13IND','','','','Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good','0');
INSERT DBColumns VALUES('sppParams','FEHNGS2UNC','dex','','','Error in [Fe/H] estimate from NGS2','0');
INSERT DBColumns VALUES('sppParams','FEHNGS1UNC','dex','','','Error in [Fe/H] estimate from NGS1','0');
INSERT DBColumns VALUES('sppParams','FEHANNSRUNC','dex','','','Error in [Fe/H] estimate from ANNSR','0');
INSERT DBColumns VALUES('sppParams','FEHANNRRUNC','dex','','','Error in [Fe/H] estimate from ANNRR','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK1UNC','dex','','','Error in [Fe/H] estiimate from CaIIK1','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK2UNC','dex','','','Error in [Fe/H] estimate from CaIIK2','0');
INSERT DBColumns VALUES('sppParams','FEHCAIIK3UNC','dex','','','Error in [Fe/H] estimate from CaIIK3','0');
INSERT DBColumns VALUES('sppParams','FEHACFUNC','dex','','','Error in [Fe/H] estimate from ACF','0');
INSERT DBColumns VALUES('sppParams','FEHCAIITUNC','dex','','','Error in [Fe/H] estimate from CaIIT','0');
INSERT DBColumns VALUES('sppParams','FEHWBGUNC','dex','','','Error in [Fe/H] estimate from WBG','0');
INSERT DBColumns VALUES('sppParams','FEHK24UNC','dex','','','Error in [Fe/H] estimate from k24','0');
INSERT DBColumns VALUES('sppParams','FEHKI13UNC','dex','','','Error in [Fe/H] estimate from ki13','0');
INSERT DBColumns VALUES('sppParams','SNR','','','','Average S/N per pixel over 4000 - 8000 A','0');
INSERT DBColumns VALUES('sppParams','QA','','','','Quality check on spectrum, depending on S/N','0');
INSERT DBColumns VALUES('sppParams','CCCAHK','','','','Correlation coefficient over 3850-4250 A','0');
INSERT DBColumns VALUES('sppParams','CCMGH','','','','Correlation coefficient over 4500-5500 A','0');
INSERT DBColumns VALUES('sppParams','TEFFSPEC','Kelvin','','','Spectroscopically determined Teff, color independent','0');
INSERT DBColumns VALUES('sppParams','TEFFSPECN','','','','Number of estimators used in average','0');
INSERT DBColumns VALUES('sppParams','TEFFSPECUNC','Kelvin','','','Error in the spectroscopically determined Teff','0');
INSERT DBColumns VALUES('sppParams','LOGGSPEC','dex','','','Spectroscopically determined log g, color independent','0');
INSERT DBColumns VALUES('sppParams','LOGGSPECN','','','','Number of estimators used in average','0');
INSERT DBColumns VALUES('sppParams','LOGGSPECUNC','dex','','','Error in the spectroscopically determined log g','0');
INSERT DBColumns VALUES('sppParams','FEHSPEC','dex','','','Spectroscopically determined [Fe/H], color independent','0');
INSERT DBColumns VALUES('sppParams','FEHSPECN','','','','Number of estimators used in average','0');
INSERT DBColumns VALUES('sppParams','FEHSPECUNC','dex','','','Error in the spectroscopically determined [Fe/H]','0');
INSERT DBColumns VALUES('sppParams','TEFFCOL','Kelvin','','','Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','TEFFCOLUNC','Kelvin','','','Error in Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','FEHTFIXNGS2','dex','','','[Fe/H] estimate from NGS2 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','FEHTFIXNGS1','dex','','','[Fe/H] estimate from NGS1 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','LOGGTFIXNGS2','dex','','','log g estimate from NGS2 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','LOGGTFIXNGS1','dex','','','log g estimate from NGS1 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','FEHTFIXNGS2UNC','dex','','','Error in [Fe/H] from NGS2 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','FEHTFIXNGS1UNC','dex','','','Error in [Fe/H] from NGS1 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','LOGGTFIXNGS2UNC','dex','','','Error in log g from NGS2 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','LOGGTFIXNGS1UNC','dex','','','Error in log g from NGS1 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','FEHTFIXCAIIK1','dex','','','[Fe/H] from CaIIK1 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','FEHTFIXCAIIK1UNC','dex','','','Error in [Fe/H] from CaIIK1 with fixed Teff from g-z color-Teff relation','0');
INSERT DBColumns VALUES('sppParams','ACF1','','','','Auto-Correlation Function over 4000-4086/4116-4325/4355-4500','0');
INSERT DBColumns VALUES('sppParams','ACF1SNR','','','','Average signal-to-noise ratio in Auto-Correlation Function 1 (ACF1)','0');
INSERT DBColumns VALUES('sppParams','ACF2','','','','Auto-Correlation Functioin over 4000-4086/4116-4280/4280-4500','0');
INSERT DBColumns VALUES('sppParams','ACF2SNR','','','','Average signal-to-noise ratio in Auto-Correlation Function 2 (ACF2)','0');
INSERT DBColumns VALUES('sppParams','INSPECT','','','','Flag with combination of six letters among FTtMmCn, for inspecting spectra','0');
INSERT DBColumns VALUES('sppParams','ELODIERVFINAL','km/s','','','Velocity as measured by Elodie library templates, converted to km/s and with the empirical 7.3 km/s offset applied (see Yanny et al. 2009, AJ, 137, 4377)','0');
INSERT DBColumns VALUES('sppParams','ELODIERVFINALERR','km/s','','','Uncertainty in the measured Elodie RV, as determined from the chisq template-fitting routine.  See the discussion of empirically-determined velocity errors in Yanny et al. 2009, AJ, 137, 4377','0');
INSERT DBColumns VALUES('sppParams','ZWARNING','','','','Warning flags about velocity/redshift determinations','0');
INSERT DBColumns VALUES('sppTargets','OBJID','','','','Object ID matching DR8','0');
INSERT DBColumns VALUES('sppTargets','RUN','','','','Run number','0');
INSERT DBColumns VALUES('sppTargets','RERUN','','','','Rerun number','0');
INSERT DBColumns VALUES('sppTargets','CAMCOL','','','','Camera column number','0');
INSERT DBColumns VALUES('sppTargets','FIELD','','','','Field number','0');
INSERT DBColumns VALUES('sppTargets','OBJ','','','','Object','0');
INSERT DBColumns VALUES('sppTargets','RA','degree','','','RA','0');
INSERT DBColumns VALUES('sppTargets','DEC','degree','','','Dec','0');
INSERT DBColumns VALUES('sppTargets','L','degree','','','Galactic longitude','0');
INSERT DBColumns VALUES('sppTargets','B','degree','','','Galactic latitude','0');
INSERT DBColumns VALUES('sppTargets','FIBERMAG_u','mag','','','u band fiber magnitudue','0');
INSERT DBColumns VALUES('sppTargets','FIBERMAG_g','mag','','','g band fiber magnitudue','0');
INSERT DBColumns VALUES('sppTargets','FIBERMAG_r','mag','','','r band fiber magnitudue','0');
INSERT DBColumns VALUES('sppTargets','FIBERMAG_i','mag','','','i band fiber magnitudue','0');
INSERT DBColumns VALUES('sppTargets','FIBERMAG_z','mag','','','z band fiber magnitudue','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_u','mag','','','u band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_g','mag','','','g band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_r','mag','','','r band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_i','mag','','','i band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_z','mag','','','z band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','EXTINCTION_u','mag','','','u band extinction','0');
INSERT DBColumns VALUES('sppTargets','EXTINCTION_g','mag','','','g band extinction','0');
INSERT DBColumns VALUES('sppTargets','EXTINCTION_r','mag','','','r band extinction','0');
INSERT DBColumns VALUES('sppTargets','EXTINCTION_i','mag','','','i band extinction','0');
INSERT DBColumns VALUES('sppTargets','EXTINCTION_z','mag','','','z band extinction','0');
INSERT DBColumns VALUES('sppTargets','ROWC','pix','','','row centroid','0');
INSERT DBColumns VALUES('sppTargets','COLC','pix','','','column centroid','0');
INSERT DBColumns VALUES('sppTargets','TYPE','','','','object type from photometric reductions','0');
INSERT DBColumns VALUES('sppTargets','FLAGS','','','','combined flags from all bands','0');
INSERT DBColumns VALUES('sppTargets','FLAGS_u','','','','u band flag','0');
INSERT DBColumns VALUES('sppTargets','FLAGS_g','','','','g band flag','0');
INSERT DBColumns VALUES('sppTargets','FLAGS_r','','','','r band flag','0');
INSERT DBColumns VALUES('sppTargets','FLAGS_i','','','','i band flag','0');
INSERT DBColumns VALUES('sppTargets','FLAGS_z','','','','z band flag','0');
INSERT DBColumns VALUES('sppTargets','PSFMAGERR_u','mag','','','Error in u band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PSFMAGERR_g','mag','','','Error in u band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PSFMAGERR_r','mag','','','Error in u band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PSFMAGERR_i','mag','','','Error in u band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PSFMAGERR_z','mag','','','Error in u band PSF magnitude','0');
INSERT DBColumns VALUES('sppTargets','PLATEID','','','','Hash of plate and MJD','0');
INSERT DBColumns VALUES('sppTargets','SPECOBJID','','','','Spectroscopic object ID','0');
INSERT DBColumns VALUES('sppTargets','PLATE','','','','Plate number','0');
INSERT DBColumns VALUES('sppTargets','MJD','','','','Modified Julian Date','0');
INSERT DBColumns VALUES('sppTargets','FIBERID','','','','Fiber number','0');
INSERT DBColumns VALUES('sppTargets','ORIGINALPLATEID','','','','Original plate ID hash (if targeted based on previous spectrum)','0');
INSERT DBColumns VALUES('sppTargets','ORIGINALSPECOBJID','','','','Original spectroscopic object ID (if targeted based on previous spectrum)','0');
INSERT DBColumns VALUES('sppTargets','ORIGINALPLATE','','','','Original plate number   (if targeted based on previous spectrum)','0');
INSERT DBColumns VALUES('sppTargets','ORIGINALMJD','','','','Original Modified Julian Date   (if targeted based on previous spectrum)','0');
INSERT DBColumns VALUES('sppTargets','ORIGINALFIBERID','','','','Original fiber number    (if targeted based on previous spectrum)(if targeted based on previous spectrum)','0');
INSERT DBColumns VALUES('sppTargets','BESTOBJID','','','','Best object ID','0');
INSERT DBColumns VALUES('sppTargets','TARGETOBJID','','','','Target object ID','0');
INSERT DBColumns VALUES('sppTargets','PRIMTARGET','','','','Primary target','0');
INSERT DBColumns VALUES('sppTargets','SECTARGET','','','','Secondary target','0');
INSERT DBColumns VALUES('sppTargets','SEGUE1_TARGET1','','','','SEGUE-1 target selection information at plate design, primary science selection','0');
INSERT DBColumns VALUES('sppTargets','SEGUE1_TARGET2','','','','SEGUE-1 target selection information at plate design, secondary/qa/calib selection','0');
INSERT DBColumns VALUES('sppTargets','SEGUE2_TARGET1','','','','bitmask that records the category or categories for which this object passed the selection criteria','0');
INSERT DBColumns VALUES('sppTargets','SEGUE2_TARGET2','','','','bitmask that records the category or categories of "standards" for the pipeline, special calibration targets like Stetson standards or globular cluster stars, for which this object passed the selection criteria','0');
INSERT DBColumns VALUES('sppTargets','MATCH','','','','??','0');
INSERT DBColumns VALUES('sppTargets','DELTA','','','','??','0');
INSERT DBColumns VALUES('sppTargets','PML','mas/year?','','','Proper motion in Galactic longitude?','0');
INSERT DBColumns VALUES('sppTargets','PMB','mas/year?','','','Proper motion in Galactic latitude?','0');
INSERT DBColumns VALUES('sppTargets','PMRA','mas/year?','','','Proper motion in RA','0');
INSERT DBColumns VALUES('sppTargets','PMDEC','mas/year?','','','Proper motion in DEC','0');
INSERT DBColumns VALUES('sppTargets','PMRAERR','mas/year?','','','Proper motion error in RA','0');
INSERT DBColumns VALUES('sppTargets','PMDECERR','mas/year?','','','Proper motion error in DEC','0');
INSERT DBColumns VALUES('sppTargets','PMSIGRA','mas/year?','','','','0');
INSERT DBColumns VALUES('sppTargets','PMSIGDEC','mas/year?','','','','0');
INSERT DBColumns VALUES('sppTargets','NFIT','','','','','0');
INSERT DBColumns VALUES('sppTargets','DIST22','','','','','0');
INSERT DBColumns VALUES('sppTargets','DIST20','','','','','0');
INSERT DBColumns VALUES('sppTargets','uMAG0','mag','','','u extinction-corrected (SFD 98) psf magnitude','0');
INSERT DBColumns VALUES('sppTargets','gMAG0','mag','','','g extinction-corrected (SFD 98) psf magnitude','0');
INSERT DBColumns VALUES('sppTargets','rMAG0','mag','','','r extinction-corrected (SFD 98) psf magnitude','0');
INSERT DBColumns VALUES('sppTargets','iMAG0','mag','','','i extinction-corrected (SFD 98) psf magnitude','0');
INSERT DBColumns VALUES('sppTargets','zMAG0','mag','','','z extinction-corrected (SFD 98) psf magnitude','0');
INSERT DBColumns VALUES('sppTargets','umg0','mag','','','u-g, extinction corrected magnitudes','0');
INSERT DBColumns VALUES('sppTargets','gmr0','mag','','','g-r, extinction corrected magnitudes','0');
INSERT DBColumns VALUES('sppTargets','rmi0','mag','','','r-i, extinction corrected magnitudes','0');
INSERT DBColumns VALUES('sppTargets','imz0','mag','','','i-z, extinction corrected magnitudes','0');
INSERT DBColumns VALUES('sppTargets','gmi0','mag','','','g-i, extinction corrected magnitudes','0');
INSERT DBColumns VALUES('sppTargets','umgERR','mag','','','PSFMAGERR_u and PSFMAGERR_g added in quadrature','0');
INSERT DBColumns VALUES('sppTargets','gmrERR','mag','','','PSFMAGERR_g and PSFMAGERR_r added in quadrature','0');
INSERT DBColumns VALUES('sppTargets','rmiERR','mag','','','PSFMAGERR_r and PSFMAGERR_i added in quadrature','0');
INSERT DBColumns VALUES('sppTargets','imzERR','mag','','','PSFMAGERR_i and PSFMAGERR_z added in quadrature','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_umg','mag','','','psfmag_u-psfmag_g, no extinction correction','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_gmr','mag','','','psfmag_g-psfmag_r, no extinction correction','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_rmi','mag','','','psfmag_r-psfmag_i, no extinction correction','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_imz','mag','','','psfmag_i-psfmag_z, no extinction correction','0');
INSERT DBColumns VALUES('sppTargets','PSFMAG_gmi','mag','','','psfmag_g-psfmag_i, no extinction correction','0');
INSERT DBColumns VALUES('sppTargets','lcolor','mag','','','-0.436*uMag+1.129*gMag-0.119*rMag-0.574*iMag+0.1984 (Lenz et al.1998)','0');
INSERT DBColumns VALUES('sppTargets','scolor','mag','','','-0.249*uMag+0.794*gMag-0.555*rMag+0.234+0.011*p1s-0.010 (Helmi et al. 2003) used in SEGUE-1 target selection, unused in SEGUE-2','0');
INSERT DBColumns VALUES('sppTargets','p1s','mag','','','0.91*umg+0.415*umg-1.280 (Helmi et al. 2003) used in SEGUE-1 target selection, unused in SEGUE-2','0');
INSERT DBColumns VALUES('sppTargets','TOTALPM','mas/year','','','sqrt(PMRA*PMRA+PMDEC*PMDEC), in mas/year','0');
INSERT DBColumns VALUES('sppTargets','Hg','mag','','','reduced proper motion, gMag+5*log10(TOTALPM/1000)+5','0');
INSERT DBColumns VALUES('sppTargets','Mi','mag','','','4.471+7.907*imz-0.837*imz*imz used in SEGUE-1 target selection, unused in SEGUE-2','0');
INSERT DBColumns VALUES('sppTargets','DISTi','mag','','','10^((iMag-Mi+5)/5.0) used in SEGUE-1 target selection, unused in SEGUE-2','0');
INSERT DBColumns VALUES('sppTargets','Hr','mag','','','reduced pm (uncorr r): PSFMAG_r+5*log10(TOTALPM/1000)+5','0');
INSERT DBColumns VALUES('sppTargets','VMI_TRANS1','mag','','','V-I from VMAG_TRANS-(iMag-0.337*rmi-0.37)','0');
INSERT DBColumns VALUES('sppTargets','VMI_TRANS2','mag','','','V-I from 0.877*gmr+0.358','0');
INSERT DBColumns VALUES('sppTargets','VMAG_TRANS','mag','','','V mag from gMag - 0.587*gmr -0.011','0');
INSERT DBColumns VALUES('sppTargets','MV_TRANS','mag','','','not stuffed','0');
INSERT DBColumns VALUES('sppTargets','DISTV_KPC','kpc','','','10^(dmV/5.-2.) where VMAG_TRANS-(3.37*VMI_TRANS1+2.89)','0');
INSERT DBColumns VALUES('sppTargets','VTRANS_GALREST','km/s','','','transvere velocity, km/s, derived from TOTALPM and DISTV_KPC, in a frame at rest w.r.t the Galaxy','0');
INSERT DBColumns VALUES('sppTargets','MUTRANS_GALRADREST','mas/year','','','derived PM (mas/year) perpendicular to the Galactocentric radial vector, assuming all motion is along a Galactocentric radial vector, in a frame at rest w.r.t the Galaxy','0');
INSERT DBColumns VALUES('sppTargets','MURAD_GALRADREST','mas/year','','','derived PM (mas/year) along the Galactocentric radial vector, assuming all motion is along a Galactocentric radial vector, in a frame at rest w.r.t the Galaxy','0');
INSERT DBColumns VALUES('sppTargets','VTOT_GALRADREST','km/s','','','total velocioty, km/s, derived from TOTALPM and DISTV_KPC, in a frame at rest w.r.t the Galaxy','0');
INSERT DBColumns VALUES('sppTargets','MG_TOHV','mag','','','5.7 + 10.0*(GMR - 0.375)','0');
INSERT DBColumns VALUES('sppTargets','VTRANS_TOHV','km/s','','','transverse velocity in Galactocentric coords, using the distance estimate from MG_TOHV which is appropriate for old stars near the MSTO and corrected for peculiar solar motion 16.6 km/s toward RA,Dec 267.5,28.1','0');
INSERT DBColumns VALUES('sppTargets','PM1SIGMA_TOHV','mas/year','','','Estimate of the 1-sigma error in total proper motion at this r magnitude.  Formula is sqrt(4.56*4.56 + frate*2.30*2.30), where frate is 10^(0.4*(rMag-19.5)).  The constants come from the Munn et al. 2004 (AJ, 127, 3034) paper describing the recalibration of USNOB with SDSS.','0');
INSERT DBColumns VALUES('sppTargets','V1SIGMAERR_TOHV','km/s','','','The corresponding 1-sigma error in the transverse velocity based on PM1SIGMA_TOHV and the the distance estimate using MG_TOHV','0');
INSERT DBColumns VALUES('sppTargets','TARGET_VERSION','','','','version of target used','0');
INSERT DBColumns VALUES('Plate2Target','plate2targetid','','','','primary key','0');
INSERT DBColumns VALUES('Plate2Target','plate','','','','plate number','0');
INSERT DBColumns VALUES('Plate2Target','plateid','','','','plate identification number in plateX','0');
INSERT DBColumns VALUES('Plate2Target','objid','','','','object identification number in sppTargets','0');
INSERT DBColumns VALUES('Plate2Target','loadVersion','','','','Load Version','0');
INSERT DBColumns VALUES('segueTargetAll','objid','','ID_MAIN','','unique id, points to photoObj','0');
INSERT DBColumns VALUES('segueTargetAll','segue1_target1','','ID_MAIN','','SEGUE-1 primary target selection flag','0');
INSERT DBColumns VALUES('segueTargetAll','segue1_target2','','ID_MAIN','','SEGUE-1 secondary target selection flag','0');
INSERT DBColumns VALUES('segueTargetAll','segue2_target1','','ID_MAIN','','SEGUE-2 primary target selection flag','0');
INSERT DBColumns VALUES('segueTargetAll','segue2_target2','','ID_MAIN','','SEGUE-2 secondary target selection flag','0');
INSERT DBColumns VALUES('segueTargetAll','lcolor','mag','','','SEGUE-1 and -2 target selection color: -0.436*uMag+1.129*gMag-0.119*rMag-0.574*iMag+0.1984 (Lenz et al.1998)','0');
INSERT DBColumns VALUES('segueTargetAll','scolor','mag','','','SEGUE-1 target selection color: -0.249*uMag+0.794*gMag-0.555*rMag+0.234+0.011*p1s-0.010 (Helmi et al. 2003)','0');
INSERT DBColumns VALUES('segueTargetAll','p1s','mag','','','SEGUE-1 target selection color: 0.91*umg+0.415*umg-1.280 (Helmi et al. 2003)','0');
INSERT DBColumns VALUES('segueTargetAll','totalpm','mas/year','','','sqrt(PMRA*PMRA+PMDEC*PMDEC), in mas/year','0');
INSERT DBColumns VALUES('segueTargetAll','hg','mag','','','reduced proper motion, gMag+5*log10(TOTALPM/1000)+5','0');
INSERT DBColumns VALUES('segueTargetAll','Mi','mag','','','4.471+7.907*imz-0.837*imz*imz used in SEGUE-1 target selection, unused in SEGUE-2','0');
INSERT DBColumns VALUES('segueTargetAll','disti','mag','','','10^((iMag-Mi+5)/5.0) used in SEGUE-1 target selection, unused in SEGUE-2','0');
INSERT DBColumns VALUES('segueTargetAll','Hr','mag','','','reduced pm (uncorr r): PSFMAG_r+5*log10(TOTALPM/1000)+5','0');
INSERT DBColumns VALUES('segueTargetAll','vmi_trans1','mag','','','V-I from VMAG_TRANS-(iMag-0.337*rmi-0.37)','0');
INSERT DBColumns VALUES('segueTargetAll','vmi_trans2','mag','','','V-I from 0.877*gmr+0.358','0');
INSERT DBColumns VALUES('segueTargetAll','vmag_trans','mag','','','V mag from gMag - 0.587*gmr -0.011','0');
INSERT DBColumns VALUES('segueTargetAll','Mv_trans','mag','','','','0');
INSERT DBColumns VALUES('segueTargetAll','distv_kpc','kpc','','','10^(dmV/5.-2.) where VMAG_TRANS-(3.37*VMI_TRANS1+2.89)','0');
INSERT DBColumns VALUES('segueTargetAll','vtrans_galrest','km/s','','','transvere velocity, km/s, derived from TOTALPM and DISTV_KPC, in a frame at rest w.r.t the Galaxy','0');
INSERT DBColumns VALUES('segueTargetAll','mutrans_galradrest','mas/year','','','derived PM (mas/year) perpendicular to the Galactocentric radial vector, assuming all motion is along a Galactocentric radial vector, in a frame at rest w.r.t the Galaxy','0');
INSERT DBColumns VALUES('segueTargetAll','murad_galradrest','mas/year','','','derived PM (mas/year) along the Galactocentric radial vector, assuming all motion is along a Galactocentric radial vector, in a frame at rest w.r.t the Galaxy','0');
INSERT DBColumns VALUES('segueTargetAll','vtot_galradrest','km/s','','','total velocity, km/s, derived from TOTALPM and DISTV_KPC, in a frame at rest w.r.t the Galaxy','0');
INSERT DBColumns VALUES('segueTargetAll','mg_tohv','mag','','','5.7 + 10.0*(GMR - 0.375)','0');
INSERT DBColumns VALUES('segueTargetAll','vtrans_tohv','km/s','','','transverse velocity in Galactocentric coords, using the distance estimate from MG_TOHV which is appropriate for old stars near the MSTO and corrected for peculiar solar motion 16.6 km/s toward RA,Dec 267.5,28.1','0');
INSERT DBColumns VALUES('segueTargetAll','pm1sigma_tohv','mas/year','','','Estimate of the 1-sigma error in total proper motion at this r magnitude.  Formula is sqrt(4.56*4.56 + frate*2.30*2.30), where frate is 10^(0.4*(rMag-19.5)).  The constants come from the Munn et al. 2004 (AJ, 127, 3034) paper describing the recalibration of USNOB with SDSS.','0');
INSERT DBColumns VALUES('segueTargetAll','v1sigmaerr_tohv','km/s','','','The corresponding 1-sigma error in the transverse velocity based on PM1SIGMA_TOHV and the the distance estimate using MG_TOHV','0');
INSERT DBColumns VALUES('Frame','fieldID','','ID_FIELD','','Link to the field table','0');
INSERT DBColumns VALUES('Frame','zoom','','INST_SCALE','','Zoom level 2^(zoom/10)','0');
INSERT DBColumns VALUES('Frame','run','','OBS_RUN','','Run number','0');
INSERT DBColumns VALUES('Frame','rerun','','ID_NUMBER','','Rerun number','0');
INSERT DBColumns VALUES('Frame','camcol','','INST_ID','','Camera column','0');
INSERT DBColumns VALUES('Frame','field','','ID_FIELD','','Field number','0');
INSERT DBColumns VALUES('Frame','stripe','','ID_AREA','','Stripe number','0');
INSERT DBColumns VALUES('Frame','strip','','ID_AREA','','Strip number (N or S)','0');
INSERT DBColumns VALUES('Frame','a','deg','POS_TRANS_PARAM','','Astrometric coefficient','0');
INSERT DBColumns VALUES('Frame','b','deg/pix','POS_TRANS_PARAM','','Astrometric coefficient','0');
INSERT DBColumns VALUES('Frame','c','deg/pix','POS_TRANS_PARAM','','Astrometric coefficient','0');
INSERT DBColumns VALUES('Frame','d','deg','POS_TRANS_PARAM','','Astrometric coefficient','0');
INSERT DBColumns VALUES('Frame','e','deg/pix','POS_TRANS_PARAM','','Astrometric coefficient','0');
INSERT DBColumns VALUES('Frame','f','deg/pix','POS_TRANS_PARAM','','Astrometric coefficient','0');
INSERT DBColumns VALUES('Frame','node','deg','POS_TRANS_PARAM','','Astrometric coefficient','0');
INSERT DBColumns VALUES('Frame','incl','deg','POS_INCLIN','','Astrometric coefficient','0');
INSERT DBColumns VALUES('Frame','raMin','deg','POS_EQ_RA_OTHER','','Min of ra','0');
INSERT DBColumns VALUES('Frame','raMax','deg','POS_EQ_RA_OTHER','','Max of ra','0');
INSERT DBColumns VALUES('Frame','decMin','deg','POS_EQ_DEC_OTHER','','Min of dec','0');
INSERT DBColumns VALUES('Frame','decMax','deg','POS_EQ_DEC_OTHER','','Max of dec','0');
INSERT DBColumns VALUES('Frame','mu','deg','POS_SDSS_MU','','Survey mu of frame center','0');
INSERT DBColumns VALUES('Frame','nu','deg','POS_SDSS_NU','','Survey nu of frame center','0');
INSERT DBColumns VALUES('Frame','ra','deg','POS_EQ_RA_MAIN','','Ra of frame center','0');
INSERT DBColumns VALUES('Frame','dec','deg','POS_EQ_RA_MAIN','','Dec of frame center','0');
INSERT DBColumns VALUES('Frame','cx','','POS_EQ_CART_X','','Cartesian x of frame center','0');
INSERT DBColumns VALUES('Frame','cy','','POS_EQ_CART_Y','','Cartesian y of frame center','0');
INSERT DBColumns VALUES('Frame','cz','','POS_EQ_CART_Z','','Cartesian z of frame center','0');
INSERT DBColumns VALUES('Frame','htmID','','CODE_MISC','','The htmID for point at frame center','0');
INSERT DBColumns VALUES('Frame','img','','IMAGE?','','The image in JPEG format','0');
INSERT DBColumns VALUES('zooConfidence','specobjid','','','','match to DR8 spectrum object','0');
INSERT DBColumns VALUES('zooConfidence','objid','','','','DR8 ObjID','0');
INSERT DBColumns VALUES('zooConfidence','dr7objid','','','','DR7 ObjID','0');
INSERT DBColumns VALUES('zooConfidence','ra','','','','Right Ascension, J2000 deg','0');
INSERT DBColumns VALUES('zooConfidence','dec','','','','Declination, J2000 deg','0');
INSERT DBColumns VALUES('zooConfidence','rastring','','','','Right ascension in sexagesimal','0');
INSERT DBColumns VALUES('zooConfidence','decstring','','','','Declination in sexagesimal','0');
INSERT DBColumns VALUES('zooConfidence','f_unclass_clean','','','','fraction of galaxies in same bin that are unclassified, clean condition','0');
INSERT DBColumns VALUES('zooConfidence','f_misclass_clean','','','','fraction of galaxies in same bin that are misclassified, clean condition','0');
INSERT DBColumns VALUES('zooConfidence','avcorr_clean','','','','average bias correction in bin, clean condition','0');
INSERT DBColumns VALUES('zooConfidence','stdcorr_clean','','','','std dev of bias corrections in bin, clean condition','0');
INSERT DBColumns VALUES('zooConfidence','f_misclass_greater','','','','fraction of galaxies in same bin that are misclassified, greater condition','0');
INSERT DBColumns VALUES('zooConfidence','avcorr_greater','','','','average bias correction in bin, greater condition','0');
INSERT DBColumns VALUES('zooConfidence','stdcorr_greater','','','','std dev of bias corrections in bin, greater condition','0');
INSERT DBColumns VALUES('zooMirrorBias','specobjid','','','','match to DR8 spectrum object','0');
INSERT DBColumns VALUES('zooMirrorBias','objid','','','','DR8 ObjID','0');
INSERT DBColumns VALUES('zooMirrorBias','dr7objid','','','','DR7 ObjID','0');
INSERT DBColumns VALUES('zooMirrorBias','ra','','','','Right Ascension, J2000 deg','0');
INSERT DBColumns VALUES('zooMirrorBias','dec','','','','Declination, J2000 deg','0');
INSERT DBColumns VALUES('zooMirrorBias','rastring','','','','Right ascension in sexagesimal','0');
INSERT DBColumns VALUES('zooMirrorBias','decstring','','','','Declination in sexagesimal','0');
INSERT DBColumns VALUES('zooMirrorBias','nvote_mr1','','','','number of votes, vertical mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_el_mr1','','','','fraction of votes for elliptical, vertical mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_cw_mr1','','','','fraction of votes for clockwise spiral, vertical mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_acw_mr1','','','','fraction of votes for anticlockwise spiral, vertical mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_edge_mr1','','','','fraction of votes for edge-on disk, vertical mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_dk_mr1','','','','fraction of votes for don''t know, vertical mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_mg_mr1','','','','fraction of votes for merger, vertical mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_cs_mr1','','','','fraction of votes for combined spiral, vertical mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','nvote_mr2','','','','number of votes, diagonal mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_el_mr2','','','','fraction of votes for elliptical, diagonal mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_cw_mr2','','','','fraction of votes for clockwise spiral, diagonal mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_acw_mr2','','','','fraction of votes for anticlockwise spiral, diagonal mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_edge_mr2','','','','fraction of votes for edge-on disk, diagonal mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_dk_mr2','','','','fraction of votes for don''t know, diagonal mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_mg_mr2','','','','fraction of votes for merger, diagonal mirroring','0');
INSERT DBColumns VALUES('zooMirrorBias','p_cs_mr2','','','','fraction of votes for combined spiral, diagonal mirroring','0');
INSERT DBColumns VALUES('zooMonochromeBias','specobjid','','','','match to DR8 spectrum object','0');
INSERT DBColumns VALUES('zooMonochromeBias','objid','','','','DR8 ObjID','0');
INSERT DBColumns VALUES('zooMonochromeBias','dr7objid','','','','DR7 ObjID','0');
INSERT DBColumns VALUES('zooMonochromeBias','ra','','','','Right Ascension, J2000 deg','0');
INSERT DBColumns VALUES('zooMonochromeBias','dec','','','','Declination, J2000 deg','0');
INSERT DBColumns VALUES('zooMonochromeBias','rastring','','','','Right ascension in sexagesimal','0');
INSERT DBColumns VALUES('zooMonochromeBias','decstring','','','','Declination in sexagesimal','0');
INSERT DBColumns VALUES('zooMonochromeBias','nvote_mon','','','','number of votes, monochrome','0');
INSERT DBColumns VALUES('zooMonochromeBias','p_el_mon','','','','fraction of votes for elliptical, monochrome','0');
INSERT DBColumns VALUES('zooMonochromeBias','p_cw_mon','','','','fraction of votes for clockwise spiral, monochrome','0');
INSERT DBColumns VALUES('zooMonochromeBias','p_acw_mon','','','','fraction of votes for anticlockwise spiral, monochrome','0');
INSERT DBColumns VALUES('zooMonochromeBias','p_edge_mon','','','','fraction of votes for edge-on disk, monochrome','0');
INSERT DBColumns VALUES('zooMonochromeBias','p_dk_mon','','','','fraction of votes for don''t know, monochrome','0');
INSERT DBColumns VALUES('zooMonochromeBias','p_mg_mon','','','','fraction of votes for merger, monochrome','0');
INSERT DBColumns VALUES('zooMonochromeBias','p_cs_mon','','','','fraction of votes for combined spiral (cw + acw + edge-on), monochrome','0');
INSERT DBColumns VALUES('zooNoSpec','specobjid','','','','match to DR8 spectrum object','0');
INSERT DBColumns VALUES('zooNoSpec','objid','','','','DR8 ObjID','0');
INSERT DBColumns VALUES('zooNoSpec','dr7objid','','','','DR7 ObjID','0');
INSERT DBColumns VALUES('zooNoSpec','ra','','','','Right Ascension, J2000 deg','0');
INSERT DBColumns VALUES('zooNoSpec','dec','','','','Declination, J2000 deg','0');
INSERT DBColumns VALUES('zooNoSpec','rastring','','','','Right ascension in sexagesimal','0');
INSERT DBColumns VALUES('zooNoSpec','nvote','','','','number of votes','0');
INSERT DBColumns VALUES('zooNoSpec','p_el','','','','fraction of votes for elliptical','0');
INSERT DBColumns VALUES('zooNoSpec','p_cw','','','','fraction of votes for clockwise spiral','0');
INSERT DBColumns VALUES('zooNoSpec','p_acw','','','','fraction of votes for anticlockwise spiral','0');
INSERT DBColumns VALUES('zooNoSpec','p_edge','','','','fraction of votes for edge-on disk','0');
INSERT DBColumns VALUES('zooNoSpec','p_dk','','','','fraction of votes for don''t know','0');
INSERT DBColumns VALUES('zooNoSpec','p_mg','','','','fraction of votes for merger','0');
INSERT DBColumns VALUES('zooNoSpec','p_cs','','','','fraction of votes for combined spiral - cw + acw + edge-on','0');
INSERT DBColumns VALUES('zooSpec','specobjid','','','','match to DR8 spectrum object','0');
INSERT DBColumns VALUES('zooSpec','objid','','','','DR8 ObjID','0');
INSERT DBColumns VALUES('zooSpec','dr7objid','','','','DR7 ObjID','0');
INSERT DBColumns VALUES('zooSpec','ra','','','','Right Ascension, J2000 deg','0');
INSERT DBColumns VALUES('zooSpec','dec','','','','Declination, J2000 deg','0');
INSERT DBColumns VALUES('zooSpec','rastring','','','','Right ascension in sexagesimal','0');
INSERT DBColumns VALUES('zooSpec','decstring','','','','Declination in sexagesimal','0');
INSERT DBColumns VALUES('zooSpec','nvote','','','','number of votes','0');
INSERT DBColumns VALUES('zooSpec','p_el','','','','fraction of votes for elliptical','0');
INSERT DBColumns VALUES('zooSpec','p_cw','','','','fraction of votes for clockwise spiral','0');
INSERT DBColumns VALUES('zooSpec','p_acw','','','','fraction of votes for anticlockwise spiral','0');
INSERT DBColumns VALUES('zooSpec','p_edge','','','','fraction of votes for edge-on disk','0');
INSERT DBColumns VALUES('zooSpec','p_dk','','','','fraction of votes for don''t know','0');
INSERT DBColumns VALUES('zooSpec','p_mg','','','','fraction of votes for merger','0');
INSERT DBColumns VALUES('zooSpec','p_cs','','','','fraction of votes for combined spiral - cw + acw + edge-on','0');
INSERT DBColumns VALUES('zooSpec','p_el_debiased','','','','debiased fraction of votes for elliptical','0');
INSERT DBColumns VALUES('zooSpec','p_cs_debiased','','','','debiased fraction of votes for combined spiral','0');
INSERT DBColumns VALUES('zooSpec','spiral','','','','flag for combined spiral - 1 if debiased spiral fraction > 0.8, 0 otherwise','0');
INSERT DBColumns VALUES('zooSpec','elliptical','','','','flag for elliptical - 1 if debiased elliptical fraction > 0.8, 0 otherwise','0');
INSERT DBColumns VALUES('zooSpec','uncertain','','','','flag for uncertain type - 1 if both spiral and elliptical flags are 0','0');
INSERT DBColumns VALUES('zooVotes','specobjid','','','','match to DR8 spectrum object','0');
INSERT DBColumns VALUES('zooVotes','objid','','','','DR8 ObjID','0');
INSERT DBColumns VALUES('zooVotes','dr7objid','','','','DR7 ObjID','0');
INSERT DBColumns VALUES('zooVotes','ra','','','','Right Ascension, J2000 deg','0');
INSERT DBColumns VALUES('zooVotes','dec','','','','Declination, J2000 deg','0');
INSERT DBColumns VALUES('zooVotes','rastring','','','','Right ascension in sexagesimal','0');
INSERT DBColumns VALUES('zooVotes','decstring','','','','Declination in sexagesimal','0');
INSERT DBColumns VALUES('zooVotes','nvote_tot','','','','Total votes','0');
INSERT DBColumns VALUES('zooVotes','nvote_std','','','','Total votes for the standard classification','0');
INSERT DBColumns VALUES('zooVotes','nvote_mr1','','','','Total votes for the vertical mirrored classification','0');
INSERT DBColumns VALUES('zooVotes','nvote_mr2','','','','Total votes for the diagonally mirrored classification','0');
INSERT DBColumns VALUES('zooVotes','nvote_mon','','','','Total votes for the monochrome classification','0');
INSERT DBColumns VALUES('zooVotes','p_el','','','','Fraction of votes for elliptical','0');
INSERT DBColumns VALUES('zooVotes','p_cw','','','','Fraction of votes for clockwise spiral','0');
INSERT DBColumns VALUES('zooVotes','p_acw','','','','Fraction of votes for anticlockwise spiral','0');
INSERT DBColumns VALUES('zooVotes','p_edge','','','','Fraction of votes for edge-on disk','0');
INSERT DBColumns VALUES('zooVotes','p_dk','','','','Fraction of votes for don''t know','0');
INSERT DBColumns VALUES('zooVotes','p_mg','','','','Fraction of votes for merger','0');
INSERT DBColumns VALUES('zooVotes','p_cs','','','','Fraction of votes for combined spiral - cw + acw + edge-on','0');

GO
----------------------------- 
PRINT '3697 lines inserted into DBColumns '
----------------------------- 

-- Reload DBViewCols table
TRUNCATE TABLE DBViewcols
GO

INSERT DBViewCols VALUES('name','FieldMask','DataConstants ');
INSERT DBViewCols VALUES('value','FieldMask','DataConstants ');
INSERT DBViewCols VALUES('description','FieldMask','DataConstants ');
INSERT DBViewCols VALUES('name','PhotoFlags','DataConstants ');
INSERT DBViewCols VALUES('value','PhotoFlags','DataConstants ');
INSERT DBViewCols VALUES('description','PhotoFlags','DataConstants ');
INSERT DBViewCols VALUES('name','PhotoStatus','DataConstants ');
INSERT DBViewCols VALUES('value','PhotoStatus','DataConstants ');
INSERT DBViewCols VALUES('description','PhotoStatus','DataConstants ');
INSERT DBViewCols VALUES('name','UberCalibStatus','DataConstants ');
INSERT DBViewCols VALUES('value','UberCalibStatus','DataConstants ');
INSERT DBViewCols VALUES('description','UberCalibStatus','DataConstants ');
INSERT DBViewCols VALUES('name','PrimTarget','DataConstants ');
INSERT DBViewCols VALUES('value','PrimTarget','DataConstants ');
INSERT DBViewCols VALUES('description','PrimTarget','DataConstants ');
INSERT DBViewCols VALUES('name','SecTarget','DataConstants ');
INSERT DBViewCols VALUES('value','SecTarget','DataConstants ');
INSERT DBViewCols VALUES('description','SecTarget','DataConstants ');
INSERT DBViewCols VALUES('name','InsideMask','DataConstants ');
INSERT DBViewCols VALUES('value','InsideMask','DataConstants ');
INSERT DBViewCols VALUES('description','InsideMask','DataConstants ');
INSERT DBViewCols VALUES('name','SpecZWarning','DataConstants ');
INSERT DBViewCols VALUES('value','SpecZWarning','DataConstants ');
INSERT DBViewCols VALUES('description','SpecZWarning','DataConstants ');
INSERT DBViewCols VALUES('name','ImageMask','DataConstants ');
INSERT DBViewCols VALUES('value','ImageMask','DataConstants ');
INSERT DBViewCols VALUES('description','ImageMask','DataConstants ');
INSERT DBViewCols VALUES('name','TiMask','DataConstants ');
INSERT DBViewCols VALUES('value','TiMask','DataConstants ');
INSERT DBViewCols VALUES('description','TiMask','DataConstants ');
INSERT DBViewCols VALUES('name','PhotoMode','DataConstants ');
INSERT DBViewCols VALUES('value','PhotoMode','DataConstants ');
INSERT DBViewCols VALUES('description','PhotoMode','DataConstants ');
INSERT DBViewCols VALUES('name','PhotoType','DataConstants ');
INSERT DBViewCols VALUES('value','PhotoType','DataConstants ');
INSERT DBViewCols VALUES('description','PhotoType','DataConstants ');
INSERT DBViewCols VALUES('name','MaskType','DataConstants ');
INSERT DBViewCols VALUES('value','MaskType','DataConstants ');
INSERT DBViewCols VALUES('description','MaskType','DataConstants ');
INSERT DBViewCols VALUES('name','FieldQuality','DataConstants ');
INSERT DBViewCols VALUES('value','FieldQuality','DataConstants ');
INSERT DBViewCols VALUES('description','FieldQuality','DataConstants ');
INSERT DBViewCols VALUES('name','PspStatus','DataConstants ');
INSERT DBViewCols VALUES('value','PspStatus','DataConstants ');
INSERT DBViewCols VALUES('description','PspStatus','DataConstants ');
INSERT DBViewCols VALUES('name','FramesStatus','DataConstants ');
INSERT DBViewCols VALUES('value','FramesStatus','DataConstants ');
INSERT DBViewCols VALUES('description','FramesStatus','DataConstants ');
INSERT DBViewCols VALUES('name','SpecClass','DataConstants ');
INSERT DBViewCols VALUES('value','SpecClass','DataConstants ');
INSERT DBViewCols VALUES('description','SpecClass','DataConstants ');
INSERT DBViewCols VALUES('name','SpecLineNames','DataConstants ');
INSERT DBViewCols VALUES('value','SpecLineNames','DataConstants ');
INSERT DBViewCols VALUES('description','SpecLineNames','DataConstants ');
INSERT DBViewCols VALUES('name','SpecZStatus','DataConstants ');
INSERT DBViewCols VALUES('value','SpecZStatus','DataConstants ');
INSERT DBViewCols VALUES('description','SpecZStatus','DataConstants ');
INSERT DBViewCols VALUES('name','HoleType','DataConstants ');
INSERT DBViewCols VALUES('value','HoleType','DataConstants ');
INSERT DBViewCols VALUES('description','HoleType','DataConstants ');
INSERT DBViewCols VALUES('name','ObjType','DataConstants ');
INSERT DBViewCols VALUES('value','ObjType','DataConstants ');
INSERT DBViewCols VALUES('description','ObjType','DataConstants ');
INSERT DBViewCols VALUES('name','ProgramType','DataConstants ');
INSERT DBViewCols VALUES('value','ProgramType','DataConstants ');
INSERT DBViewCols VALUES('description','ProgramType','DataConstants ');
INSERT DBViewCols VALUES('name','CoordType','DataConstants ');
INSERT DBViewCols VALUES('value','CoordType','DataConstants ');
INSERT DBViewCols VALUES('description','CoordType','DataConstants ');
INSERT DBViewCols VALUES('AS','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('type','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('radius','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('ra','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('dec','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('x','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('y','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('z','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('c','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('htmid','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('convexString','RegionConvex','RegionPatch ');
INSERT DBViewCols VALUES('*','PhotoObj','PhotoObjAll ');
INSERT DBViewCols VALUES('*','PhotoPrimary','PhotoObjAll ');
INSERT DBViewCols VALUES('*','PhotoSecondary','PhotoObjAll ');
INSERT DBViewCols VALUES('*','PhotoFamily','PhotoObjAll ');
INSERT DBViewCols VALUES('*','Star','PhotoPrimary ');
INSERT DBViewCols VALUES('*','Galaxy','PhotoPrimary ');
INSERT DBViewCols VALUES('objID','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('skyVersion','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('run','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('rerun','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('camcol','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('field','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('obj','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('mode','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('nChild','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('type','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('probPSF','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('insideMask','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('flags','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('flags_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('flags_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('flags_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('flags_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('flags_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMag_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMag_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMag_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMag_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMag_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMagErr_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMagErr_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMagErr_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMagErr_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psfMagErr_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMag_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMag_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMag_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMag_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMag_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMagErr_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMagErr_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMagErr_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMagErr_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroMagErr_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroR50_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('petroR90_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMag_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMag_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMag_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMag_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMag_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMagErr_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMagErr_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMagErr_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMagErr_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cModelMagErr_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('mRrCc_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('mRrCcErr_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('mRrCcPsf_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('fracDeV_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('fracDeV_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('fracDeV_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('fracDeV_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('fracDeV_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psffwhm_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psffwhm_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psffwhm_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psffwhm_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('psffwhm_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('resolveStatus','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('thingId','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('balkanId','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('nObserve','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('nDetect','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('calibStatus_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('calibStatus_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('calibStatus_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('calibStatus_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('calibStatus_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('ra','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('dec','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cx','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cy','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('cz','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('extinction_u','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('extinction_g','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('extinction_r','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('extinction_i','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('extinction_z','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('htmID','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('fieldID','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('specObjID','PhotoTag','PhotoObjAll ');
INSERT DBViewCols VALUES('*','StarTag','PhotoTag ');
INSERT DBViewCols VALUES('*','GalaxyTag','PhotoTag ');
INSERT DBViewCols VALUES('*','Sky','PhotoPrimary ');
INSERT DBViewCols VALUES('*','Unknown','PhotoPrimary ');
INSERT DBViewCols VALUES('*','SpecPhoto','SpecPhotoAll ');
INSERT DBViewCols VALUES('*','SpecObj','specObjAll ');
INSERT DBViewCols VALUES('*','Columns','DBColumns ');
INSERT DBViewCols VALUES('s.*','segue1SpecObjAll','specObjAll  p ON s.plateId = p.plateId ');
INSERT DBViewCols VALUES('s.*','segue2SpecObjAll','specObjAll  p ON s.plateId = p.plateId ');
INSERT DBViewCols VALUES('s.*','segueSpecObjAll','specObjAll  p ON s.plateId = p.plateId ');
INSERT DBViewCols VALUES('*','sdssTile','sdssTileAll ');
INSERT DBViewCols VALUES('*','sdssTilingBoundary','sdssTilingGeometry ');
INSERT DBViewCols VALUES('*','sdssTilingMask','sdssTilingGeometry ');
INSERT DBViewCols VALUES('AS','TableDesc','DBObjects o LEFT OUTER JOIN IndexMap i ON o.name=i.tableName  ');
INSERT DBViewCols VALUES('type','TableDesc','DBObjects o LEFT OUTER JOIN IndexMap i ON o.name=i.tableName  ');
INSERT DBViewCols VALUES('text','TableDesc','DBObjects o LEFT OUTER JOIN IndexMap i ON o.name=i.tableName  ');

GO
----------------------------- 
PRINT '188 lines inserted into DBViewcols'
----------------------------- 

-- Reload Inventory table
TRUNCATE TABLE Inventory
GO
--

INSERT Inventory VALUES('FileGroups','PartitionMap','U');
INSERT Inventory VALUES('FileGroups','FileGroupMap','U');
INSERT Inventory VALUES('FileGroups','spTruncateFileGroupMap','P');
INSERT Inventory VALUES('FileGroups','spSetDefaultFileGroup','P');
INSERT Inventory VALUES('DataConstants','DataConstants','U');
INSERT Inventory VALUES('DataConstants','SDSSConstants','U');
INSERT Inventory VALUES('DataConstants','StripeDefs','U');
INSERT Inventory VALUES('DataConstants','RunShift','U');
INSERT Inventory VALUES('DataConstants','ProfileDefs','U');
INSERT Inventory VALUES('ConstantSupport','FieldMask','V');
INSERT Inventory VALUES('ConstantSupport','PhotoFlags','V');
INSERT Inventory VALUES('ConstantSupport','PhotoStatus','V');
INSERT Inventory VALUES('ConstantSupport','UberCalibStatus','V');
INSERT Inventory VALUES('ConstantSupport','PrimTarget','V');
INSERT Inventory VALUES('ConstantSupport','SecTarget','V');
INSERT Inventory VALUES('ConstantSupport','InsideMask','V');
INSERT Inventory VALUES('ConstantSupport','SpecZWarning','V');
INSERT Inventory VALUES('ConstantSupport','ImageMask','V');
INSERT Inventory VALUES('ConstantSupport','TiMask','V');
INSERT Inventory VALUES('ConstantSupport','PhotoMode','V');
INSERT Inventory VALUES('ConstantSupport','PhotoType','V');
INSERT Inventory VALUES('ConstantSupport','MaskType','V');
INSERT Inventory VALUES('ConstantSupport','FieldQuality','V');
INSERT Inventory VALUES('ConstantSupport','PspStatus','V');
INSERT Inventory VALUES('ConstantSupport','FramesStatus','V');
INSERT Inventory VALUES('ConstantSupport','SpecClass','V');
INSERT Inventory VALUES('ConstantSupport','SpecLineNames','V');
INSERT Inventory VALUES('ConstantSupport','SpecZStatus','V');
INSERT Inventory VALUES('ConstantSupport','HoleType','V');
INSERT Inventory VALUES('ConstantSupport','ObjType','V');
INSERT Inventory VALUES('ConstantSupport','ProgramType','V');
INSERT Inventory VALUES('ConstantSupport','CoordType','V');
INSERT Inventory VALUES('ConstantSupport','fPhotoMode','F');
INSERT Inventory VALUES('ConstantSupport','fPhotoModeN','F');
INSERT Inventory VALUES('ConstantSupport','fPhotoType','F');
INSERT Inventory VALUES('ConstantSupport','fMaskType','F');
INSERT Inventory VALUES('ConstantSupport','fMaskTypeN','F');
INSERT Inventory VALUES('ConstantSupport','fPhotoTypeN','F');
INSERT Inventory VALUES('ConstantSupport','fFieldQuality','F');
INSERT Inventory VALUES('ConstantSupport','fFieldQualityN','F');
INSERT Inventory VALUES('ConstantSupport','fPspStatus','F');
INSERT Inventory VALUES('ConstantSupport','fPspStatusN','F');
INSERT Inventory VALUES('ConstantSupport','fFramesStatus','F');
INSERT Inventory VALUES('ConstantSupport','fFramesStatusN','F');
INSERT Inventory VALUES('ConstantSupport','fSpecClass','F');
INSERT Inventory VALUES('ConstantSupport','fSpecClassN','F');
INSERT Inventory VALUES('ConstantSupport','fSpecZStatus','F');
INSERT Inventory VALUES('ConstantSupport','fSpecZStatusN','F');
INSERT Inventory VALUES('ConstantSupport','fSpecLineNames','F');
INSERT Inventory VALUES('ConstantSupport','fSpecLineNamesN','F');
INSERT Inventory VALUES('ConstantSupport','fHoleType','F');
INSERT Inventory VALUES('ConstantSupport','fHoleTypeN','F');
INSERT Inventory VALUES('ConstantSupport','fObjType','F');
INSERT Inventory VALUES('ConstantSupport','fObjTypeN','F');
INSERT Inventory VALUES('ConstantSupport','fProgramType','F');
INSERT Inventory VALUES('ConstantSupport','fProgramTypeN','F');
INSERT Inventory VALUES('ConstantSupport','fCoordType','F');
INSERT Inventory VALUES('ConstantSupport','fCoordTypeN','F');
INSERT Inventory VALUES('ConstantSupport','fFieldMask','F');
INSERT Inventory VALUES('ConstantSupport','fFieldMaskN','F');
INSERT Inventory VALUES('ConstantSupport','fPhotoFlags','F');
INSERT Inventory VALUES('ConstantSupport','fPhotoFlagsN','F');
INSERT Inventory VALUES('ConstantSupport','fPhotoStatus','F');
INSERT Inventory VALUES('ConstantSupport','fPhotoStatusN','F');
INSERT Inventory VALUES('ConstantSupport','fUberCalibStatus','F');
INSERT Inventory VALUES('ConstantSupport','fUberCalibStatusN','F');
INSERT Inventory VALUES('ConstantSupport','fPrimTarget','F');
INSERT Inventory VALUES('ConstantSupport','fPrimTargetN','F');
INSERT Inventory VALUES('ConstantSupport','fSecTarget','F');
INSERT Inventory VALUES('ConstantSupport','fSecTargetN','F');
INSERT Inventory VALUES('ConstantSupport','fInsideMask','F');
INSERT Inventory VALUES('ConstantSupport','fInsideMaskN','F');
INSERT Inventory VALUES('ConstantSupport','fSpecZWarning','F');
INSERT Inventory VALUES('ConstantSupport','fSpecZWarningN','F');
INSERT Inventory VALUES('ConstantSupport','fImageMask','F');
INSERT Inventory VALUES('ConstantSupport','fImageMaskN','F');
INSERT Inventory VALUES('ConstantSupport','fTiMask','F');
INSERT Inventory VALUES('ConstantSupport','fTiMaskN','F');
INSERT Inventory VALUES('ConstantSupport','fPhotoDescription','F');
INSERT Inventory VALUES('ConstantSupport','fSpecDescription','F');
INSERT Inventory VALUES('MetadataTables','SiteDBs','U');
INSERT Inventory VALUES('MetadataTables','QueryResults','U');
INSERT Inventory VALUES('MetadataTables','RecentQueries','U');
INSERT Inventory VALUES('MetadataTables','SiteConstants','U');
INSERT Inventory VALUES('MetadataTables','DBObjects','U');
INSERT Inventory VALUES('MetadataTables','DBColumns','U');
INSERT Inventory VALUES('MetadataTables','DBViewCols','U');
INSERT Inventory VALUES('MetadataTables','History','U');
INSERT Inventory VALUES('MetadataTables','Inventory','U');
INSERT Inventory VALUES('MetadataTables','Dependency','U');
INSERT Inventory VALUES('MetadataTables','PubHistory','U');
INSERT Inventory VALUES('MetadataTables','LoadHistory','U');
INSERT Inventory VALUES('MetadataTables','Diagnostics','U');
INSERT Inventory VALUES('MetadataTables','SiteDiagnostics','U');
INSERT Inventory VALUES('IndexMap','spNewPhase','P');
INSERT Inventory VALUES('IndexMap','spStartStep','P');
INSERT Inventory VALUES('IndexMap','spEndStep','P');
INSERT Inventory VALUES('IndexMap','IndexMap','U');
INSERT Inventory VALUES('IndexMap','fIndexName','F');
INSERT Inventory VALUES('IndexMap','spIndexCreate','P');
INSERT Inventory VALUES('IndexMap','spIndexBuildList','P');
INSERT Inventory VALUES('IndexMap','spIndexDropList','P');
INSERT Inventory VALUES('IndexMap','spIndexBuildSelection','P');
INSERT Inventory VALUES('IndexMap','spIndexDropSelection','P');
INSERT Inventory VALUES('IndexMap','spIndexDrop','P');
INSERT Inventory VALUES('IndexMap','spDropIndexAll','P');
INSERT Inventory VALUES('Versions','Versions','U');
INSERT Inventory VALUES('PhotoTables','Field','U');
INSERT Inventory VALUES('PhotoTables','PhotoObjAll','U');
INSERT Inventory VALUES('PhotoTables','Photoz','U');
INSERT Inventory VALUES('PhotoTables','PhotozRF','U');
INSERT Inventory VALUES('PhotoTables','PhotozTemplateCoeff','U');
INSERT Inventory VALUES('PhotoTables','PhotozRFTemplateCoeff','U');
INSERT Inventory VALUES('PhotoTables','ProperMotions','U');
INSERT Inventory VALUES('PhotoTables','FieldProfile','U');
INSERT Inventory VALUES('PhotoTables','Run','U');
INSERT Inventory VALUES('PhotoTables','PhotoProfile','U');
INSERT Inventory VALUES('PhotoTables','Mask','U');
INSERT Inventory VALUES('PhotoTables','MaskedObject','U');
INSERT Inventory VALUES('PhotoTables','AtlasOutline','U');
INSERT Inventory VALUES('PhotoTables','TwoMass','U');
INSERT Inventory VALUES('PhotoTables','TwoMassXSC','U');
INSERT Inventory VALUES('PhotoTables','FIRST','U');
INSERT Inventory VALUES('PhotoTables','RC3','U');
INSERT Inventory VALUES('PhotoTables','ROSAT','U');
INSERT Inventory VALUES('PhotoTables','USNO','U');
INSERT Inventory VALUES('galSpecTables','galSpecExtra','U');
INSERT Inventory VALUES('galSpecTables','galSpecIndx','U');
INSERT Inventory VALUES('galSpecTables','galSpecInfo','U');
INSERT Inventory VALUES('galSpecTables','galSpecLine','U');
INSERT Inventory VALUES('spPhoto','fSkyVersion','F');
INSERT Inventory VALUES('spPhoto','fRerun','F');
INSERT Inventory VALUES('spPhoto','fRun','F');
INSERT Inventory VALUES('spPhoto','fCamcol','F');
INSERT Inventory VALUES('spPhoto','fField','F');
INSERT Inventory VALUES('spPhoto','fObj','F');
INSERT Inventory VALUES('spPhoto','fObjID','F');
INSERT Inventory VALUES('spPhoto','fObjidFromSDSS','F');
INSERT Inventory VALUES('spPhoto','fObjidFromSDSSWithFF','F');
INSERT Inventory VALUES('spPhoto','fSDSS','F');
INSERT Inventory VALUES('spPhoto','fSDSSfromObjID','F');
INSERT Inventory VALUES('spPhoto','fStripeOfRun','F');
INSERT Inventory VALUES('spPhoto','fStripOfRun','F');
INSERT Inventory VALUES('spPhoto','fDMSbase','F');
INSERT Inventory VALUES('spPhoto','fHMSbase','F');
INSERT Inventory VALUES('spPhoto','fDMS','F');
INSERT Inventory VALUES('spPhoto','fHMS','F');
INSERT Inventory VALUES('spPhoto','fIAUFromEq','F');
INSERT Inventory VALUES('spPhoto','fFirstFieldBit','F');
INSERT Inventory VALUES('spPhoto','fPrimaryObjID','F');
INSERT Inventory VALUES('spPhoto','fMagToFlux','F');
INSERT Inventory VALUES('spPhoto','fMagToFluxErr','F');
INSERT Inventory VALUES('spPhoto','fGetPhotoApMag','F');
INSERT Inventory VALUES('spPhoto','fPhotoApMag','F');
INSERT Inventory VALUES('spPhoto','fPhotoApMagErr','F');
INSERT Inventory VALUES('spPhoto','fUberCalMag','F');
INSERT Inventory VALUES('resolveTables','detectionIndex','U');
INSERT Inventory VALUES('resolveTables','thingIndex','U');
INSERT Inventory VALUES('NeighborTables','Neighbors','U');
INSERT Inventory VALUES('NeighborTables','Zone','U');
INSERT Inventory VALUES('SpectroTables','PlateX','U');
INSERT Inventory VALUES('SpectroTables','SpecObjAll','U');
INSERT Inventory VALUES('SpectroTables','SpecPhotoAll','U');
INSERT Inventory VALUES('spSpectro','fSpecidFromSDSS','F');
INSERT Inventory VALUES('spSpectro','fPlate','F');
INSERT Inventory VALUES('spSpectro','fMJD','F');
INSERT Inventory VALUES('spSpectro','fFiber','F');
INSERT Inventory VALUES('spSpectro','spMakeSpecObjAll','P');
INSERT Inventory VALUES('TilingTables','Target','U');
INSERT Inventory VALUES('TilingTables','TargetInfo','U');
INSERT Inventory VALUES('TilingTables','sdssTargetParam','U');
INSERT Inventory VALUES('TilingTables','sdssTileAll','U');
INSERT Inventory VALUES('TilingTables','sdssTilingRun','U');
INSERT Inventory VALUES('TilingTables','sdssTilingGeometry','U');
INSERT Inventory VALUES('TilingTables','sdssTiledTargetAll','U');
INSERT Inventory VALUES('TilingTables','sdssTilingInfo','U');
INSERT Inventory VALUES('RegionTables','Rmatrix','U');
INSERT Inventory VALUES('RegionTables','Region','U');
INSERT Inventory VALUES('RegionTables','RegionPatch','U');
INSERT Inventory VALUES('RegionTables','HalfSpace','U');
INSERT Inventory VALUES('RegionTables','RegionArcs','U');
INSERT Inventory VALUES('RegionTables','Sector','U');
INSERT Inventory VALUES('RegionTables','Region2Box','U');
INSERT Inventory VALUES('RegionTables','RegionConvex','V');
INSERT Inventory VALUES('WindowTables','sdssImagingHalfSpaces','U');
INSERT Inventory VALUES('WindowTables','sdssPolygons','U');
INSERT Inventory VALUES('WindowTables','sdssPolygon2Field','U');
INSERT Inventory VALUES('ssppTables','sppLines','U');
INSERT Inventory VALUES('ssppTables','sppParams','U');
INSERT Inventory VALUES('ssppTables','sppTargets','U');
INSERT Inventory VALUES('ssppTables','Plate2Target','U');
INSERT Inventory VALUES('ssppTables','segueTargetAll','U');
INSERT Inventory VALUES('FrameTables','Frame','U');
INSERT Inventory VALUES('FrameTables','spComputeFrameHTM','P');
INSERT Inventory VALUES('FrameTables','spMakeFrame','P');
INSERT Inventory VALUES('FrameTables','fTileFileName','F');
INSERT Inventory VALUES('GalaxyZooTables','zooConfidence','U');
INSERT Inventory VALUES('GalaxyZooTables','zooMirrorBias','U');
INSERT Inventory VALUES('GalaxyZooTables','zooMonochromeBias','U');
INSERT Inventory VALUES('GalaxyZooTables','zooNoSpec','U');
INSERT Inventory VALUES('GalaxyZooTables','zooSpec','U');
INSERT Inventory VALUES('GalaxyZooTables','zooVotes','U');
INSERT Inventory VALUES('Views','PhotoObj','V');
INSERT Inventory VALUES('Views','PhotoPrimary','V');
INSERT Inventory VALUES('Views','PhotoSecondary','V');
INSERT Inventory VALUES('Views','PhotoFamily','V');
INSERT Inventory VALUES('Views','Star','V');
INSERT Inventory VALUES('Views','Galaxy','V');
INSERT Inventory VALUES('Views','PhotoTag','V');
INSERT Inventory VALUES('Views','StarTag','V');
INSERT Inventory VALUES('Views','GalaxyTag','V');
INSERT Inventory VALUES('Views','Sky','V');
INSERT Inventory VALUES('Views','Unknown','V');
INSERT Inventory VALUES('Views','SpecPhoto','V');
INSERT Inventory VALUES('Views','SpecObj','V');
INSERT Inventory VALUES('Views','Columns','V');
INSERT Inventory VALUES('Views','segue1SpecObjAll','V');
INSERT Inventory VALUES('Views','segue2SpecObjAll','V');
INSERT Inventory VALUES('Views','segueSpecObjAll','V');
INSERT Inventory VALUES('Views','sdssTile','V');
INSERT Inventory VALUES('Views','sdssTilingBoundary','V');
INSERT Inventory VALUES('Views','sdssTilingMask','V');
INSERT Inventory VALUES('Views','TableDesc','V');
INSERT Inventory VALUES('spSphericalLib','fSphGetVersion','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetArea','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetRegionStringBin','F');
INSERT Inventory VALUES('spSphericalLib','fSphConvexAddHalfspace','F');
INSERT Inventory VALUES('spSphericalLib','fSphSimplifyBinary','F');
INSERT Inventory VALUES('spSphericalLib','fSphSimplifyBinaryAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphSimplifyString','F');
INSERT Inventory VALUES('spSphericalLib','fSphSimplifyStringAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphSimplifyQuery','F');
INSERT Inventory VALUES('spSphericalLib','fSphSimplifyQueryAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphGrow','F');
INSERT Inventory VALUES('spSphericalLib','fSphGrowAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphUnion','F');
INSERT Inventory VALUES('spSphericalLib','fSphIntersect','F');
INSERT Inventory VALUES('spSphericalLib','fSphUnionAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphIntersectAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphUnionQuery','F');
INSERT Inventory VALUES('spSphericalLib','fSphIntersectQuery','F');
INSERT Inventory VALUES('spSphericalLib','fSphDiffAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphDiff','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetHalfspaces','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetConvexes','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetPatches','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetArcs','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetOutlineArcs','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetHtmRanges','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetHtmRangesAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphRegionContainsXYZ','F');
INSERT Inventory VALUES('spSphericalLib','fSphSimplifyAdvanced','F');
INSERT Inventory VALUES('spSphericalLib','fSphSimplify','F');
INSERT Inventory VALUES('spSphericalLib','fSphGetRegionString','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmVersion','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmEq','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmXyz','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmGetString','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmGetCenterPoint','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmGetCornerPoints','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmCoverCircleEq','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmCoverCircleXyz','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmCoverRegion','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmCoverRegionError','F');
INSERT Inventory VALUES('spHtmCSharp','fDistanceEq','F');
INSERT Inventory VALUES('spHtmCSharp','fDistanceXyz','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmEqToXyz','F');
INSERT Inventory VALUES('spHtmCSharp','fHtmXyzToEq','F');
INSERT Inventory VALUES('spNearby','fGetNearbyObjEq','F');
INSERT Inventory VALUES('spNearby','fGetNearbyObjAllEq','F');
INSERT Inventory VALUES('spNearby','spNearestObjEq','P');
INSERT Inventory VALUES('spNearby','fGetNearestObjEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestObjAllEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestObjIdEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestObjIdAllEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestObjIdEqType','F');
INSERT Inventory VALUES('spNearby','fGetNearestObjIdEqMode','F');
INSERT Inventory VALUES('spNearby','fGetNearbyObjXYZ','F');
INSERT Inventory VALUES('spNearby','fGetNearbyObjAllXYZ','F');
INSERT Inventory VALUES('spNearby','fGetNearestObjXYZ','F');
INSERT Inventory VALUES('spNearby','fGetNearestSpecObjIdEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestSpecObjIdAllEq','F');
INSERT Inventory VALUES('spNearby','fGetNearbySpecObjXYZ','F');
INSERT Inventory VALUES('spNearby','fGetNearbySpecObjAllXYZ','F');
INSERT Inventory VALUES('spNearby','fGetNearestSpecObjXYZ','F');
INSERT Inventory VALUES('spNearby','fGetNearestSpecObjAllXYZ','F');
INSERT Inventory VALUES('spNearby','fGetNearbySpecObjEq','F');
INSERT Inventory VALUES('spNearby','fGetNearbySpecObjAllEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestSpecObjEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestSpecObjAllEq','F');
INSERT Inventory VALUES('spNearby','fGetNearbyFrameEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestFrameEq','F');
INSERT Inventory VALUES('spNearby','fGetNearestFrameidEq','F');
INSERT Inventory VALUES('spNearby','spGetNeighbors','P');
INSERT Inventory VALUES('spNearby','spGetNeighborsRadius','P');
INSERT Inventory VALUES('spNearby','spGetNeighborsPrim','P');
INSERT Inventory VALUES('spNearby','spGetNeighborsAll','P');
INSERT Inventory VALUES('spNearby','spGetSpecNeighborsRadius','P');
INSERT Inventory VALUES('spNearby','spGetSpecNeighborsPrim','P');
INSERT Inventory VALUES('spNearby','spGetSpecNeighborsAll','P');
INSERT Inventory VALUES('spNearby','fGetObjFromRect','F');
INSERT Inventory VALUES('spNearby','fGetObjFromRectEq','F');
INSERT Inventory VALUES('spNearby','fDistanceArcMinEq','F');
INSERT Inventory VALUES('spNearby','fDistanceArcMinXYZ','F');
INSERT Inventory VALUES('spNearby','fGetObjectsEq','F');
INSERT Inventory VALUES('spNearby','fGetObjectsMaskEq','F');
INSERT Inventory VALUES('spNearby','fGetJpegObjects','F');
INSERT Inventory VALUES('spNearby','spGetMatch','P');
INSERT Inventory VALUES('spCoordinate','spTransposeRmatrix','P');
INSERT Inventory VALUES('spCoordinate','spBuildRmatrix','P');
INSERT Inventory VALUES('spCoordinate','fRotateV3','F');
INSERT Inventory VALUES('spCoordinate','fGetLonLat','F');
INSERT Inventory VALUES('spCoordinate','fGetLon','F');
INSERT Inventory VALUES('spCoordinate','fGetLat','F');
INSERT Inventory VALUES('spCoordinate','fEqFromMuNu','F');
INSERT Inventory VALUES('spCoordinate','fMuNuFromEq','F');
INSERT Inventory VALUES('spCoordinate','fMuFromEq','F');
INSERT Inventory VALUES('spCoordinate','fNuFromEq','F');
INSERT Inventory VALUES('spCoordinate','fCoordsFromEq','F');
INSERT Inventory VALUES('spCoordinate','fEtaFromEq','F');
INSERT Inventory VALUES('spCoordinate','fLambdaFromEq','F');
INSERT Inventory VALUES('spCoordinate','fEtaToNormal','F');
INSERT Inventory VALUES('spCoordinate','fStripeToNormal','F');
INSERT Inventory VALUES('spCoordinate','fWedgeV3','F');
INSERT Inventory VALUES('spRegion','fTokenNext','F');
INSERT Inventory VALUES('spRegion','fTokenAdvance','F');
INSERT Inventory VALUES('spRegion','fTokenStringToTable','F');
INSERT Inventory VALUES('spRegion','fNormalizeString','F');
INSERT Inventory VALUES('spRegion','fRegionFuzz','F');
INSERT Inventory VALUES('spRegion','fRegionOverlapId','F');
INSERT Inventory VALUES('spRegion','spRegionDelete','P');
INSERT Inventory VALUES('spRegion','spRegionNew','P');
INSERT Inventory VALUES('spRegion','spRegionAnd','P');
INSERT Inventory VALUES('spRegion','spRegionIntersect','P');
INSERT Inventory VALUES('spRegion','spRegionSubtract','P');
INSERT Inventory VALUES('spRegion','spRegionCopy','P');
INSERT Inventory VALUES('spRegion','spRegionSync','P');
INSERT Inventory VALUES('spRegion','fRegionContainsPointXYZ','F');
INSERT Inventory VALUES('spRegion','fRegionContainsPointEq','F');
INSERT Inventory VALUES('spRegion','fRegionGetObjectsFromRegionId','F');
INSERT Inventory VALUES('spRegion','fRegionGetObjectsFromString','F');
INSERT Inventory VALUES('spRegion','fRegionsContainingPointXYZ','F');
INSERT Inventory VALUES('spRegion','fRegionsContainingPointEq','F');
INSERT Inventory VALUES('spRegion','fFootprintEq','F');
INSERT Inventory VALUES('spCheckDB','spMakeDiagnostics','P');
INSERT Inventory VALUES('spCheckDB','spUpdateSkyServerCrossCheck','P');
INSERT Inventory VALUES('spCheckDB','spCompareChecksum','P');
INSERT Inventory VALUES('spCheckDB','fGetDiagChecksum','F');
INSERT Inventory VALUES('spCheckDB','spUpdateStatistics','P');
INSERT Inventory VALUES('spCheckDB','spCheckDBColumns','P');
INSERT Inventory VALUES('spCheckDB','spCheckDBObjects','P');
INSERT Inventory VALUES('spCheckDB','spGrantAccess','P');
INSERT Inventory VALUES('spCheckDB','spCheckDBIndexes','P');
INSERT Inventory VALUES('spTestQueries','spTestTimeStart','P');
INSERT Inventory VALUES('spTestQueries','spTestTimeEnd','P');
INSERT Inventory VALUES('spTestQueries','spTestQueries','P');
INSERT Inventory VALUES('spDocSupport','fVarBinToHex','F');
INSERT Inventory VALUES('spDocSupport','fEnum','F');
INSERT Inventory VALUES('spDocSupport','fDocColumns','F');
INSERT Inventory VALUES('spDocSupport','fDocColumnsWithRank','F');
INSERT Inventory VALUES('spDocSupport','fDocFunctionParams','F');
INSERT Inventory VALUES('spDocSupport','spDocEnum','P');
INSERT Inventory VALUES('spDocSupport','spDocKeySearch','P');
INSERT Inventory VALUES('spSQLSupport','fReplace','F');
INSERT Inventory VALUES('spSQLSupport','fIsNumbers','F');
INSERT Inventory VALUES('spSQLSupport','spExecuteSQL','P');
INSERT Inventory VALUES('spSQLSupport','spExecuteSQL2','P');
INSERT Inventory VALUES('spSQLSupport','spLogSqlStatement','P');
INSERT Inventory VALUES('spSQLSupport','spLogSqlPerformance','P');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlExpEq','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlExpId','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlFrameImg','F');
INSERT Inventory VALUES('spUrlFitsSupport','spGetFiberList','P');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlFitsField','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlFitsCFrame','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlFitsMask','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlFitsBin','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlFitsAtlas','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlFitsSpectrum','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlNavEq','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlNavId','F');
INSERT Inventory VALUES('spUrlFitsSupport','fGetUrlSpecImg','F');
INSERT Inventory VALUES('spUrlFitsSupport','spSetWebServerUrl','P');
INSERT Inventory VALUES('spUrlFitsSupport','fMJDToGMT','F');
INSERT Inventory VALUES('spNeighbor','fGetAlpha','F');
INSERT Inventory VALUES('spNeighbor','spZoneCreate','P');
INSERT Inventory VALUES('spNeighbor','spNeighbors','P');
INSERT Inventory VALUES('spSetValues','spFillMaskedObject','P');
INSERT Inventory VALUES('spSetValues','spSetInsideMask','P');
INSERT Inventory VALUES('spSetValues','spSetPhotoClean','P');
INSERT Inventory VALUES('spSetValues','spTargetInfoTargetObjID','P');
INSERT Inventory VALUES('spSetValues','spSetLoadVersion','P');
INSERT Inventory VALUES('spSetValues','spSetValues','P');
INSERT Inventory VALUES('spValidate','spTestHtm','P');
INSERT Inventory VALUES('spValidate','fDatediffSec','F');
INSERT Inventory VALUES('spValidate','spGenericTest','P');
INSERT Inventory VALUES('spValidate','spTestUniqueKey','P');
INSERT Inventory VALUES('spValidate','spTestForeignKey','P');
INSERT Inventory VALUES('spValidate','spTestPhotoParentID','P');
INSERT Inventory VALUES('spValidate','spComputePhotoParentID','P');
INSERT Inventory VALUES('spValidate','spValidatePhoto','P');
INSERT Inventory VALUES('spValidate','spValidatePlates','P');
INSERT Inventory VALUES('spValidate','spValidateGalSpec','P');
INSERT Inventory VALUES('spValidate','spValidateTiles','P');
INSERT Inventory VALUES('spValidate','spValidateWindow','P');
INSERT Inventory VALUES('spValidate','spValidateSspp','P');
INSERT Inventory VALUES('spValidate','spValidatePm','P');
INSERT Inventory VALUES('spValidate','spValidateResolve','P');
INSERT Inventory VALUES('spValidate','spValidateStep','P');
INSERT Inventory VALUES('spPublish','spBackupStep','P');
INSERT Inventory VALUES('spPublish','spCleanupStep','P');
INSERT Inventory VALUES('spPublish','spShrinkDB','P');
INSERT Inventory VALUES('spPublish','spReorg','P');
INSERT Inventory VALUES('spPublish','spCopyATable','P');
INSERT Inventory VALUES('spPublish','spPublishPhoto','P');
INSERT Inventory VALUES('spPublish','spPublishPlates','P');
INSERT Inventory VALUES('spPublish','spPublishTiling','P');
INSERT Inventory VALUES('spPublish','spPublishWindow','P');
INSERT Inventory VALUES('spPublish','spPublishGalSpec','P');
INSERT Inventory VALUES('spPublish','spPublishSspp','P');
INSERT Inventory VALUES('spPublish','spPublishPm','P');
INSERT Inventory VALUES('spPublish','spPublishResolve','P');
INSERT Inventory VALUES('spPublish','spPublishStep','P');
INSERT Inventory VALUES('spFinish','spRunSQLScript','P');
INSERT Inventory VALUES('spFinish','spLoadScienceTables','P');
INSERT Inventory VALUES('spFinish','spSetVersion','P');
INSERT Inventory VALUES('spFinish','spSyncSchema','P');
INSERT Inventory VALUES('spFinish','spRunPatch','P');
INSERT Inventory VALUES('spFinish','spLoadMetaData','P');
INSERT Inventory VALUES('spFinish','spRemoveTaskFromTable','P');
INSERT Inventory VALUES('spFinish','spRemoveTaskPhoto','P');
INSERT Inventory VALUES('spFinish','spRemovePlate','P');
INSERT Inventory VALUES('spFinish','spRemoveTaskSpectro','P');
INSERT Inventory VALUES('spFinish','spRemovePlateList','P');
INSERT Inventory VALUES('spFinish','spTableCopy','P');
INSERT Inventory VALUES('spFinish','spBuildSpecPhotoAll','P');
INSERT Inventory VALUES('spFinish','spSegue2SpectroPhotoMatch','P');
INSERT Inventory VALUES('spFinish','fGetNearbyTiledTargetsEq','F');
INSERT Inventory VALUES('spFinish','spTiledTargetDuplicates','P');
INSERT Inventory VALUES('spFinish','spSynchronize','P');
INSERT Inventory VALUES('spFinish','spFixTargetVersion','P');
INSERT Inventory VALUES('spFinish','spSdssPolygonRegions','P');
INSERT Inventory VALUES('spFinish','spLoadPhotoTag','P');
INSERT Inventory VALUES('spFinish','spLoadPatches','P');
INSERT Inventory VALUES('spFinish','spCreateWeblogDB','P');
INSERT Inventory VALUES('spFinish','spFinishDropIndices','P');
INSERT Inventory VALUES('spFinish','spFinishStep','P');
INSERT Inventory VALUES('spCopyDbSubset','spCopyDbSimpleTable','P');
INSERT Inventory VALUES('spCopyDbSubset','spCopyDbSubset','P');
INSERT Inventory VALUES('spCosmology','fCosmoZfromDl','F');
INSERT Inventory VALUES('spCosmology','fCosmoZfromDa','F');
INSERT Inventory VALUES('spCosmology','fCosmoZfromDm','F');
INSERT Inventory VALUES('spCosmology','fCosmoZfromDc','F');
INSERT Inventory VALUES('spCosmology','fCosmoZfromAgeOfUniverse','F');
INSERT Inventory VALUES('spCosmology','fCosmoZfromLookBackTime','F');
INSERT Inventory VALUES('spCosmology','fCosmoLookBackTime','F');
INSERT Inventory VALUES('spCosmology','fCosmoAgeOfUniverse','F');
INSERT Inventory VALUES('spCosmology','fCosmoTimeInterval','F');
INSERT Inventory VALUES('spCosmology','fCosmoHubbleDistance','F');
INSERT Inventory VALUES('spCosmology','fCosmoDl','F');
INSERT Inventory VALUES('spCosmology','fCosmoDc','F');
INSERT Inventory VALUES('spCosmology','fCosmoComovDist2ObjectsRADEC','F');
INSERT Inventory VALUES('spCosmology','fCosmoComovDist2ObjectsXYZ','F');
INSERT Inventory VALUES('spCosmology','fCosmoDa','F');
INSERT Inventory VALUES('spCosmology','fCosmoDm','F');
INSERT Inventory VALUES('spCosmology','fCosmoComovingVolume','F');
INSERT Inventory VALUES('spCosmology','fCosmoAbsMag','F');
INSERT Inventory VALUES('spCosmology','fCosmoDistanceModulus','F');
INSERT Inventory VALUES('spCosmology','fCosmoQuantities','F');
INSERT Inventory VALUES('spCosmology','fMathGetBin','F');
GO

------------------------------------
PRINT '472 lines inserted into Inventory'
------------------------------------
GO

-- Reload History table
TRUNCATE TABLE History
GO
--

INSERT History VALUES('FileGroups','2003-05-15','Alex','added truncate command for now ');
INSERT History VALUES('FileGroups','2003-05-22','Alex','fixed a bunch of updates to Tiling,  separated off the index assignments ');
INSERT History VALUES('FileGroups','2003-05-28','Alex','added support for indexFileGroup ');
INSERT History VALUES('FileGroups','2004-09-15','Alex','filled in the values for the PartitionMap table ');
INSERT History VALUES('FileGroups','2005-02-02','Alex','reduced the size of PhotoProfile from 0.900 to 0.450 ');
INSERT History VALUES('FileGroups','2005-12-13','Ani','Commented out Photoz table, not loaded any more. ');
INSERT History VALUES('FileGroups','2006-02-01','Ani','Put Photoz table back in, tho'' there will likely be more than one now so this will have to be changed. ');
INSERT History VALUES('FileGroups','2006-05-15','Ani','Added Photoz2, TargRunQA and QSO tables. ');
INSERT History VALUES('FileGroups','2007-01-17','Ani','Added foreign key deletions for the tables to  error when the tables are dropped. ');
INSERT History VALUES('DataConstants','2001-11-09','Jim','changed the order of fields for SpecLineNames ');
INSERT History VALUES('DataConstants','2001-11-10','Alex','added functions to support primTarget and secTarget ');
INSERT History VALUES('DataConstants','2001-11-10','Alex','reinserted the SDSSConstants and StripeDefs ');
INSERT History VALUES('DataConstants','2001-11-19','Alex','fixed bugs in PhotoFlags values and added missing items ');
INSERT History VALUES('DataConstants','2001-11-23','Alex','changed the DataConstants value type to binary(8), and SDSSConstants value to float, and added views, plus more access functions. revised fPhotoDescription. ');
INSERT History VALUES('DataConstants','2001-11-23','Jim+Alex','include fMjdToGMT time conversion routine ');
INSERT History VALUES('DataConstants','2001-12-02','Alex','changed PrimTargetFlags->primTarget, SecTargetFlags->SecTarget  and fixed the leading zeroes in SpecZWarning. ');
INSERT History VALUES('DataConstants','2001-12-29','Jim','CR -> COSMIC_RAY ');
INSERT History VALUES('DataConstants','2002-05-01','Ani','Incorporated Adrian''s tiling changes (PR 2433) ');
INSERT History VALUES('DataConstants','2002-07-10','Jim','added arcSecPerPixel, arcSecPerPixelErr to SDSS constants corrected errors in ProfileDefs ');
INSERT History VALUES('DataConstants','2002-08-10','Adrian','updated tiling changes ');
INSERT History VALUES('DataConstants','2002-08-12','Ani','Added MaskType enum (for Mask table). ');
INSERT History VALUES('DataConstants','2002-08-19','Adrian','updated tiling changes, added unmapped fiber flags to zwarning ');
INSERT History VALUES('DataConstants','2002-10-22','Alex','added the photoMode values and added V4 photoFlags ');
INSERT History VALUES('DataConstants','2003-01-16','Alex','fixed ProfileDefs per Robert''s definitions ');
INSERT History VALUES('DataConstants','2003-01-16','Alex','fixed HoleType enum as pointed out by Adrian Pope ');
INSERT History VALUES('DataConstants','2003-02-19','Alex','added values for framesStatus (from RHL) ');
INSERT History VALUES('DataConstants','2003-05-05','Ani','updated TiMask bit mask values as per PR #5272. ');
INSERT History VALUES('DataConstants','2003-06-04','Alex','Added InsideMask values, changed FieldStatus->PspStatus, and added Runshift table and values. ');
INSERT History VALUES('DataConstants','2003-07-30','Ani','Added missing photoflags descriptions provided by RHL (PR 5529) and replaced "centre" with "center" for consistency. ');
INSERT History VALUES('DataConstants','2003-08-18','Ani','Added asinh softening params to SDSSConstants (PR 5559), and fixed spelling of Angstrom (it was Angstroem). ');
INSERT History VALUES('DataConstants','2003-10-31','Ani','Added ABLINE_CAII to SpecZStatus as per PR #5741 . Modified line names (SpecLineNames) as per PR #5741 . ');
INSERT History VALUES('DataConstants','2003-12-02','Ani','Fixed typo in LOADER_MAPPED description. ');
INSERT History VALUES('DataConstants','2005-04-26','Ani','Updated TiMask values as per PR #6429 (moved them to upper 4 bytes by removing cast to int). ');
INSERT History VALUES('DataConstants','2005-09-12','Ani','Updated InsideMask enumerated values to reflect the MaskType values (PR #6609). ');
INSERT History VALUES('DataConstants','2006-01-19','Ani','Added new StripeDefs for SEGUE stripes from Brian and Svetlana (PR #7073).  Might change later. ');
INSERT History VALUES('DataConstants','2006-03-01','Ani','Fixed PR #6904, SpecClass UNKNOWN description. ');
INSERT History VALUES('DataConstants','2006-03-06','Ani','Fixed name of NeVI_3427 line to NeV_3427 in  SpecLineNames (PR #6915). ');
INSERT History VALUES('DataConstants','2006-08-10','Ani','Added PhotoMode value 5 (''HOLE''), see PR #7088. ');
INSERT History VALUES('DataConstants','2007-01-08','Ani','Fixed hex values in PspStatus (PR #6940). ');
INSERT History VALUES('DataConstants','2007-01-15','Ani','Made SEGUE stripedefs conditional on DB_NAME(), so they wont be inserted for main DB. ');
INSERT History VALUES('DataConstants','2007-01-17','Ani','Added foreign key deletions for the tables to  error when the tables are dropped. ');
INSERT History VALUES('DataConstants','2007-03-30','Ani','Added ubercal calib status bits in UberCalibStatus. ');
INSERT History VALUES('DataConstants','2007-04-24','Ani','Updated descriptions for UberCalibStatus flags. ');
INSERT History VALUES('DataConstants','2007-05-07','Ani','Updated description of UberCalibStatus NO_UBERCAL as  per suggestion from Nikhil. ');
INSERT History VALUES('DataConstants','2007-05-07','Ani','Updated description of specClass HIZ_QSO to clarify distinction between other z > 2.3 quasars and those classified as HIZ_QSO (in response to a helpdesk  question). ');
INSERT History VALUES('DataConstants','2007-11-30','Ani','Fixed Lyman-alpha lineid in SpecLineNames, shd be 1216 not 1215 (PR #6573). ');
INSERT History VALUES('DataConstants','2007-12-06','Ani','Added expTime to SDSSConstants (PR #7400). ');
INSERT History VALUES('DataConstants','2008-08-07','Ani','Fix for PR #7088, PhotoMode set to 5 for objects in holes. ');
INSERT History VALUES('ConstantSupport','2001-11-09','Jim','changed the order of fields for SpecLineNames ');
INSERT History VALUES('ConstantSupport','2001-11-10','Alex','added functions to support primTarget and secTarget ');
INSERT History VALUES('ConstantSupport','2001-11-10','Alex','reinserted the SDSSConstants and StripeDefs ');
INSERT History VALUES('ConstantSupport','2001-11-19','Alex','fixed bugs in PhotoFlags values and added missing items ');
INSERT History VALUES('ConstantSupport','2001-11-23','Alex','changed the DataConstants value type to binary(8), and SDSSConstants value to float, and added views, plus more access functions. revised fPhotoDescription. ');
INSERT History VALUES('ConstantSupport','2001-11-23','Jim+Alex','include fMjdToGMT time conversion routine ');
INSERT History VALUES('ConstantSupport','2001-12-02','Alex','changed PrimTargetFlags->primTarget, SecTargetFlags->SecTarget  and fixed the leading zeroes in SpecZWarning. ');
INSERT History VALUES('ConstantSupport','2001-12-27','Alex','separated the tables from the functions and views ');
INSERT History VALUES('ConstantSupport','2002-04-09','Jim','added sample calls to functions, fixed fSpecDescription bug ');
INSERT History VALUES('ConstantSupport','2002-08-10','Adrian','added bits/enums views/functions for tiling changes ');
INSERT History VALUES('ConstantSupport','2002-08-22','Ani','Removed duplicate fSpecZWarningN definition, and also fixed some errors in the descriptions/comments. ');
INSERT History VALUES('ConstantSupport','2002-08-26','Ani','Added descriptions to tiling views/functions. ');
INSERT History VALUES('ConstantSupport','2002-10-22','Alex','Added support to PhotoMode functions ');
INSERT History VALUES('ConstantSupport','2003-01-27','Ani','Renamed TileInfo to TilingInfo as per PR# 4702, and renamed TileBoundary (table) to TilingBoundary (view). ');
INSERT History VALUES('ConstantSupport','2003-02-19','Alex','added support for FramesStatus ');
INSERT History VALUES('ConstantSupport','2003-02-20','Alex','added support for MaskType ');
INSERT History VALUES('ConstantSupport','2003-06-04','Alex','added support for InsideMask added ''coalesce'' to functions returning names indexed by value  ');
INSERT History VALUES('ConstantSupport','2003-07-18','Ani','Fixed example for fInsideMask (param missing) ');
INSERT History VALUES('ConstantSupport','2005-04-21','Ani','Fixed ImageMask view (needed cast to binary(4), not (2)). ');
INSERT History VALUES('ConstantSupport','2006-12-01','Ani','Fix for PR #6119, fSpecZWarningN not handling 0 and NULL zwarning values correctly. ');
INSERT History VALUES('ConstantSupport','2007-03-30','Ani','Added view UberCalibStatus for ubercal calib status values. ');
INSERT History VALUES('ConstantSupport','2007-04-25','Ani','Fixed bug in fUberCalibStatusN (overflow). ');
INSERT History VALUES('ConstantSupport','2008-08-08','Ani','Fixed examples for fMaskType and fMaskTypeN (PR #6554). ');
INSERT History VALUES('ConstantSupport','2008-08-08','Ani','Fixed fInsideMask doc (PR #6555). ');
INSERT History VALUES('MetadataTables','2001-05-15','Alex','Omitted sx from names and changed FOREIGN KEYs 2001-11-03 Jim : Added site constants. ');
INSERT History VALUES('MetadataTables','2001-11-23','Alex','Eliminated sql_variant, switched to varchar(..) ');
INSERT History VALUES('MetadataTables','2001-12-09','Jim','Documentation (v.3.36), & 3.36  history changes Changed spUpdateStatistcs to spUpdateSkyServerCrossCheck ');
INSERT History VALUES('MetadataTables','2002-09-20','Alex','Added UCDs ');
INSERT History VALUES('MetadataTables','2002-11-05','Alex','Moved Primary keys to spManageIndices.sql ');
INSERT History VALUES('MetadataTables','2002-11-05','Alex','Created LoadHistory table ');
INSERT History VALUES('MetadataTables','2002-11-25','Alex','spGrantAccess-- updated from script in spManageIndices.sql ');
INSERT History VALUES('MetadataTables','2002-11-26','Alex','Changed Columns->DBColumns, ViewCol->DBViewCols ');
INSERT History VALUES('MetadataTables','2002-12-27','Alex','Added PubHistory ');
INSERT History VALUES('MetadataTables','2003-05-26','Alex','Moved spUpdateStatistics here ');
INSERT History VALUES('MetadataTables','2003-06-03','Alex','Changed count(*) to count_big(*) ');
INSERT History VALUES('MetadataTables','2003-07-21','Ani','Updated glossary table - added "name" column ');
INSERT History VALUES('MetadataTables','2003-07-24','Ani','Added Algorithm table for algorithm descriptions ');
INSERT History VALUES('MetadataTables','2003-08-07','Ani','Added TableDesc table for table descriptions. ');
INSERT History VALUES('MetadataTables','2003-08-20','Ani','Updated SiteConstants for DR2 testload. ');
INSERT History VALUES('MetadataTables','2003-08-21','Ani','Automated setting of DB version in SiteConstants (PR 5599). ');
INSERT History VALUES('MetadataTables','2004-04-25','Ani','Commented out DBObjectDescription table definition. ');
INSERT History VALUES('MetadataTables','2004-08-27','Alex','Moved spGrantAccess here from IndexMap.sql ');
INSERT History VALUES('MetadataTables','2004-08-31','Alex','moved QueryResults here from MyTimeX.sql ');
INSERT History VALUES('MetadataTables','2004-09-10','Alex','moved spCheckDBIndexes from here to IndexMap.sql ');
INSERT History VALUES('MetadataTables','2004-09-16','Alex','fixed bug with master access in spGrantAccess, renamed History to Versions and moved it to Versions.sql, and created new History, Inventory and Dependency tables ');
INSERT History VALUES('MetadataTables','2004-09-17','Alex','moved all CheckDB and Diagnostic procs and  spGrantAccess to spCheckDB.sql ');
INSERT History VALUES('MetadataTables','2004-11-12','Jim','added zoneHeight site constant. ');
INSERT History VALUES('MetadataTables','2005-02-04','Jim','made QueryResults.Time not null so it can be part of primary key ');
INSERT History VALUES('MetadataTables','2005-02-15','Ani','added RecentRequests table to restrict queries/min. ');
INSERT History VALUES('MetadataTables','2005-02-25','Ani','replaced RecentRequests with RecentQueries. ');
INSERT History VALUES('MetadataTables','2005-03-19','Jim','Added SiteDBs table ');
INSERT History VALUES('MetadataTables','2005-04-12','Ani','Documented SiteDBs and added code to populate it. ');
INSERT History VALUES('MetadataTables','2005-04-14','Ani','Changed description for RecentQueries. ');
INSERT History VALUES('MetadataTables','2005-04-15','Ani','Added rank to DBObjects amd DBColumns (PR # 6405). ');
INSERT History VALUES('MetadataTables','2005-04-18','Ani','Updated SiteConstants values for DR3. ');
INSERT History VALUES('MetadataTables','2005-09-13','Ani','Updated SiteConstants values for DR4. ');
INSERT History VALUES('MetadataTables','2007-09-26','Ani','Changed SiteDiagnostics into a U table (not admin). ');
INSERT History VALUES('MetadataTables','2010-11-16','Ani','Removed TableDesc table - it is now a view.  Also removed Glossary and Algorithm tables. ');
INSERT History VALUES('MetadataTables','2010-12-10','Ani','Changed PubHistory.nrows to bigint from int. ');
INSERT History VALUES('IndexMap','2002-07-08','Jim','modified to V4 schema for PhotoProfile. dropped extra neighbor foreign key, added field->segment forign key, added segment->chunk forign key, added chunk->stripeDefs foreign key, added fieldProfile->Field, added PhotoProfile-PhotoObj, added Mosaic foreign keys. ');
INSERT History VALUES('IndexMap','2001-11-01','Jan','created from system dump ');
INSERT History VALUES('IndexMap','2001-11-08','Alex','manual edits for concise naming convention ');
INSERT History VALUES('IndexMap','2001-11-09','Alex','total count of indices is 21 ');
INSERT History VALUES('IndexMap','2002-10-12','Alex','commented out Extinction, Mosaic, made other V4 changes ');
INSERT History VALUES('IndexMap','2002-10-12','Alex','commented out Synonym and Crossid, need to add tiling stuff later ');
INSERT History VALUES('IndexMap','2002-10-22','Alex+Jim','distanceMin-> Distance in Neighbors, isPrimary->mode in neighbors. Added sp''s to drop and add indices. ');
INSERT History VALUES('IndexMap','2002-10-28','Alex+Jim','Revised index definitions to match new (V4) column names, best and target IDs in spectra, sciencePrimary and so on. ');
INSERT History VALUES('IndexMap','2002-10-26','Alex','merged with index management ');
INSERT History VALUES('IndexMap','2002-10-26','Alex','modified spGrantExec to manage access rights ');
INSERT History VALUES('IndexMap','2002-10-28','Jim','made drop index transactional. merged spManageIndices and spBuildIndices ');
INSERT History VALUES('IndexMap','2002-11-08','Jim','fixed bug in drop index ');
INSERT History VALUES('IndexMap','2002-11-24','Jim','tied to load enviroment (generate phase messages) converted to spCreateIndex() ');
INSERT History VALUES('IndexMap','2002-11-25','Alex','moved spGrantAccess to separate file ');
INSERT History VALUES('IndexMap','2002-11-30','Jim','recovered lost files (from Windows File loss), added Tiles key and foreign key creates. ');
INSERT History VALUES('IndexMap','2002-12-08','Alex','commented out SpecObjAll ''TargetObjID,objType,....'' ');
INSERT History VALUES('IndexMap','2002-12-10','Alex','moved Sector stuff into @buildall=1 ');
INSERT History VALUES('IndexMap','2002-12-19','Alex','added skyVersion to TargetInfo PK ');
INSERT History VALUES('IndexMap','2003-01-27','Ani','Made changes to tiling schema as per PR# 4702: renamed TileRegion to TilingRegion, renamed TileInfo to TilingInfo, renamed TileNotes to TilingNotes, renamed TileBoundary to TilingGeometry, change the primary key of TilingInfo from (tileRun,tid) to (tileRun,targetID) removed TiBound2TsChunk and Target2Sector ');
INSERT History VALUES('IndexMap','2003-01-28','Alex','commented out the indices on the PhotoObj table,  they will move to PhotoTag ');
INSERT History VALUES('IndexMap','2003-01-28','Jim','fixed primary index create to have ''with sort_in_tempdb ');
INSERT History VALUES('IndexMap','2003-02-23','Alex','added HTM index to specObj, Target, Mask ');
INSERT History VALUES('IndexMap','2003-05-15','Alex','changed PhotoObj to PhotoObjAll for now ');
INSERT History VALUES('IndexMap','2003-05-21','Adrian+Alex','changed pk for Tiling tables, to reflect updates ');
INSERT History VALUES('IndexMap','2003-05-23','Alex','changed it to use the IndexMap table ');
INSERT History VALUES('IndexMap','2003-05-26','Alex','moved spUpdateStatistics to metadataTables ');
INSERT History VALUES('IndexMap','2003-05-28','Alex','added IndexMap table, modified procedures to work with this. ');
INSERT History VALUES('IndexMap','2003-06-05','Alex','fixed filegroup assignment in spCreateIndex ');
INSERT History VALUES('IndexMap','2003-06-07','Alex','added fIndexName function, also QSo* indexes ');
INSERT History VALUES('IndexMap','2003-08-06','Ani','Fixed pk creation for PhotoObjAll (PR #5542) the IndexGroup shd have been PHOTO, not PHOTOOBJ ');
INSERT History VALUES('IndexMap','2003-08-20','Ani','Added RegionConvexString and TileContains. ');
INSERT History VALUES('IndexMap','2003-08-22','Ani','Changed RegionConvexString and TileContains to FINISH category. ');
INSERT History VALUES('IndexMap','2003-12-04','Jim','fixed drop primary key bug in spDropIndex ');
INSERT History VALUES('IndexMap','2004-08-13','Ani','added phase message to spBuildPrimaryKeys. ');
INSERT History VALUES('IndexMap','2004-09-02','Alex','removed index on DBObjectDescription, the table has been dropped ');
INSERT History VALUES('IndexMap','2004-09-03','Alex','remove TileContains and RegionConvexString references, both obsolete ');
INSERT History VALUES('IndexMap','2004-09-06','Alex','added two more foreign keys related to Match->MatchHead,  and PlateX->TileAll ');
INSERT History VALUES('IndexMap','2004-09-10','Alex','moved here spCheckDBIndexes from MetadataTables.sql ');
INSERT History VALUES('IndexMap','2004-09-10','Alex','changed the names spCreateIndex->spIndexCreate, and spBuildNextIndex->spIndexBuildNext, spDropIndex->spIndexDrop, spBuildIndex -> spIndexBuild. Also the procedures spBuildIndices, spBuildForeignKeys, spBuildPrimaryKeys, spIndexBuildNext and spIndexFinish were removed. ');
INSERT History VALUES('IndexMap','2004-09-17','Alex','added pk/fk for the new tables: Versions, History, Inventory, Dependency ');
INSERT History VALUES('IndexMap','2004-09-17','Alex','changed spIndexBuild to spIndexBuildSelection, and added spIndexDropSelection and move spCheckDBIndexes to spCheckDB.sql ');
INSERT History VALUES('IndexMap','2004-10-09','Jim+Alex','added local version of spNewPhase ');
INSERT History VALUES('IndexMap','2004-10-11','Alex+Jim','added case sensitivity and tableName to spIndex*Selection ');
INSERT History VALUES('IndexMap','2004-11-11','Alex','added local wrappers for spStartStep and spEndStep ');
INSERT History VALUES('IndexMap','2004-12-02','Ani','added RC3 and Stetson clustered indices. ');
INSERT History VALUES('IndexMap','2005-01-13','Ani','Fixed stepid problem in spStartStep - made it OUTPUT in loadsupport call and made sure it only returns stepid=1 for taskid=0. ');
INSERT History VALUES('IndexMap','2005-02-01','Ani','Fixed a bug in error-handling in spIndexCreate that caused errors to be lost (was checking @@error instead of @error); also added a check and warning message for a nonexistent table in the same procedure. ');
INSERT History VALUES('IndexMap','2005-02-03','Ani','Backed out check for nonexistent table to force one-one match between IndexMap and current schema. ');
INSERT History VALUES('IndexMap','2005-02-04','Alex','removed info messages about redundant index operations ');
INSERT History VALUES('IndexMap','2005-02-05','Ani','Added check for pk constraint being a pk index previously in spIndexDropList.  If it is an index, drop the index not the constraint. ');
INSERT History VALUES('IndexMap','2005-02-06','Jim','added time to QueryResutlts primary key ');
INSERT History VALUES('IndexMap','2005-03-06','Alex','changed primary key for Region2Box, reflecting regionid->id change. ');
INSERT History VALUES('IndexMap','2005-03-10','Alex','added patch to PK columns in RegionConvex ');
INSERT History VALUES('IndexMap','2005-03-12','Alex','changed FK Sector2Tile.regionid to point to Region ');
INSERT History VALUES('IndexMap','2005-03-15','Jim','added stetson index map entries for ra, dec ');
INSERT History VALUES('IndexMap','2005-03-30','Ani','Added PK and FK for USNOB. ');
INSERT History VALUES('IndexMap','2005-04-02','Ani','Added PK and FK for QuasarCatalog. ');
INSERT History VALUES('IndexMap','2005-07-13','Ani','Added indices for PhotoAuxAll table. ');
INSERT History VALUES('IndexMap','2005-10-22','Ani','Renamed USNOB to ProperMotions (PR #6638). ');
INSERT History VALUES('IndexMap','2005-12-13','Ani','Commented out Photoz table entries, not loaded any more. ');
INSERT History VALUES('IndexMap','2005-12-20','Ani','Added index on Match.matchhead (PR #6820). ');
INSERT History VALUES('IndexMap','2006-02-02','Ani','Reinstated Photoz table entries. 2006-02-09 Ani/Jim: Added ra/dec index for PhotoObjAll, PhotoTag and SpecObjAll. ');
INSERT History VALUES('IndexMap','2006-03-08','Ani','Added TargRunQA PK index. ');
INSERT History VALUES('IndexMap','2006-04-09','Ani','Updated QsoCatalogAll entries, replaced QsoConcordance with QsoConcordanceAll, added entries for QsoBunch, QsoBest, QsoTarget and QsoSpec. ');
INSERT History VALUES('IndexMap','2006-05-11','Ani','Added K and F entries for Photoz2 table. ');
INSERT History VALUES('IndexMap','2006-12-20','Ani','Made indices for Photoz, Photoz2 and ProperMotions conditional (only creeated if this is not a TARGDRx DB). ');
INSERT History VALUES('IndexMap','2006-12-26','Ani','Made SPECTRO, QSO, TILES indices also conditional. ');
INSERT History VALUES('IndexMap','2006-01-08','Ani','Removed indices for PhotoAuxAll table (it''s a view now, see PR #7000). ');
INSERT History VALUES('IndexMap','2007-01-08','Ani','Modified spIndexCreate to print an error message if the table doesn''t exist. ');
INSERT History VALUES('IndexMap','2007-01-17','Ani','Modified spIndexBuildSelection and spIndexDropSelection to handle FKs for a given table (needed to drop and recreate specific FKs before and after a schema sync. ');
INSERT History VALUES('IndexMap','2007-01-24','Ani','Added covering index to PhotoTag similar to PhotoObjAll index on htmid,run,camcol,..., because without it the joins in some of the nearby functions were very slow. ');
INSERT History VALUES('IndexMap','2007-01-31','Ani','Added "untiled" to htmid index on TiledTargetAll to fix a performance problem with fGetNearbyTiledTargetsEq. ');
INSERT History VALUES('IndexMap','2007-04-12','Ani','Added PK, FK indices for Ap7Mag and UberCal tables. ');
INSERT History VALUES('IndexMap','2007-06-14','Ani','Renamed QuasarCatalog to DR3QuasarCatalog, added indices for DR5QuasarCatalog. ');
INSERT History VALUES('IndexMap','2007-06-15','Ani','Added PKs for sppLines and sppParams. ');
INSERT History VALUES('IndexMap','2007-06-15','Ani','Added RegionPatch indices. ');
INSERT History VALUES('IndexMap','2007-08-25','Ani','Commented out RegionConvex indices - it''s a view now. Also commented out ProperMotions FK. ');
INSERT History VALUES('IndexMap','2007-08-25','Ani','Added search on tablename for foreign keys in  spIndexBuildSelection. ');
INSERT History VALUES('IndexMap','2008-03-20','Ani','Added PK index for PsObjAll (PR #7014). ');
INSERT History VALUES('IndexMap','2008-08-31','Ani','Added indices for OrigField, OrigPhotoObjAll and UberAstro. ');
INSERT History VALUES('IndexMap','2008-10-10','Ani','Added PK entry for FieldQA table. ');
INSERT History VALUES('IndexMap','2009-08-14','Ani','SDSS-III changes: removed tables that no longer exist, and columns that have been removed or renamed.  Removed isoA_r,  isoB_r from PhotoObjAll indices. ');
INSERT History VALUES('IndexMap','2009-12-30','Ani','Added PKs for sppParams, sppLines, galSpec tables (in SPECTRO group) and window function tables (in REGION group). ');
INSERT History VALUES('IndexMap','2010-01-14','Ani','Replaced ObjMask with AtlasOutline. ');
INSERT History VALUES('IndexMap','2010-02-09','Ani','Added PK for sppTargets (but commented out for now). ');
INSERT History VALUES('IndexMap','2010-07-16','Naren','uncommented sppTargets PK. ');
INSERT History VALUES('IndexMap','2010-07-28','Ani','Commented out sppTargets PK again. ');
INSERT History VALUES('IndexMap','2010-11-16','Ani','Removed Glossary, Algorithm and TableDesc tables, and adeed resolve table indices. ');
INSERT History VALUES('IndexMap','2010-11-18','Ani','Went through and cleaned up discontinued tables, etc. ');
INSERT History VALUES('IndexMap','2010-11-26','Ani','Deleted detectionIndex PK and added FKs for resolve tables. ');
INSERT History VALUES('IndexMap','2010-11-30','Ani','Deleted Region2Box PK. ');
INSERT History VALUES('IndexMap','2010-12-03','Ani','Deleted obsolete SpecPhotoAll index on targetid. ');
INSERT History VALUES('IndexMap','2010-12-08','Ani','Deleted indices for segueTargetAll. ');
INSERT History VALUES('IndexMap','2010-12-09','Ani','Renamed TargetParam to sdssTargetParam. ');
INSERT History VALUES('IndexMap','2010-12-10','Ani','Changed detectionIndex objid to PK from FK. ');
INSERT History VALUES('IndexMap','2010-12-11','Ani','Removed PhotoTag indices. ');
INSERT History VALUES('IndexMap','2010-12-11','Ani','Added paramFile to sdssTargetParam PK. ');
INSERT History VALUES('IndexMap','2010-12-11','Ani','Added dummy entry for i_PhotoObjAll_phototag fat index. ');
INSERT History VALUES('IndexMap','2010-12-20','Ani','Added (non-unique) index on objID for thingIndex. ');
INSERT History VALUES('IndexMap','2010-12-21','Ani','Added PK indices for xmatch tables and nonclustered index on thingID for detectionIndex table. ');
INSERT History VALUES('IndexMap','2011-02-23','Ani','Added PK/FK indices for Photoz* tables. ');
INSERT History VALUES('PhotoTables','2009-04-27','Ani','Swapped in updated schema for photo tables for SDSS-III. Added new table Run. ');
INSERT History VALUES('PhotoTables','2009-05-05','Ani','Added loadVersion to Field table. ');
INSERT History VALUES('PhotoTables','2009-06-11','Ani','Added nProf_[ugriz] to Field table. ');
INSERT History VALUES('PhotoTables','2009-08-14','Ani','Removed status, primTarget and secTarget columns from PhotoTag (they are no longer in PhotoObjAll). ');
INSERT History VALUES('PhotoTables','2009-12-09','Ani','Changed Run.comments to varchar(128) from varchar(32). ');
INSERT History VALUES('PhotoTables','2010-01-13','Victor','Updated Table name ''Objmask'' to ''AtlasOutline''. Also on dependencies (dbo.spsetvalues) 2010-06-17  Naren/Vamsi/Ani : Added external catalog tables. ');
INSERT History VALUES('PhotoTables','2010-07-02','Ani','Fixed FLDEPOCH column names (added survey suffixes) in USNO table. ');
INSERT History VALUES('PhotoTables','2010-07-08','Ani','Removed duplicate definition of First table. ');
INSERT History VALUES('PhotoTables','2010-07-14','Ani','For consistency (acronym) changed table name First->FIRST. ');
INSERT History VALUES('PhotoTables','2010-11-17','Ani','Replaced ProperMotions schema with sas-sql version. ');
INSERT History VALUES('PhotoTables','2010-11-18','Ani','Changed AtlasOutline.span to varchar(max) from text. ');
INSERT History VALUES('PhotoTables','2010-12-10','Ani','Removed PhotoTag table definition (view now). ');
INSERT History VALUES('PhotoTables','2010-12-22','Ani','Updated PhotoObjAll.clean flag description (not just for point sources now) and PhotoProfile units (nanomaggies/arcsec^2 instead if maggies/arcsec^2). ');
INSERT History VALUES('PhotoTables','2011-01-26','Ani','Removed Photoz2 table. ');
INSERT History VALUES('PhotoTables','2011-01-26','Ani','Made minor format change to Photoz description. ');
INSERT History VALUES('PhotoTables','2011-02-07','Ani','Removed Photoz2 reference from description of Photoz. ');
INSERT History VALUES('PhotoTables','2011-02-18','Ani','Added Photoz* tables from Istvan Csabai.   ');
INSERT History VALUES('PhotoTables','2011-05-20','Ani','Added schema for DR7 xmatch tables. ');
INSERT History VALUES('PhotoTables','2011-05-26','Ani','Deleted FieldQA and RunQA tables. ');
INSERT History VALUES('galSpecTables','2009-12-29','Ani','Adapted from sas-sql. ');
INSERT History VALUES('spPhoto','2004-12-17','Ani','Moved sps and functions here from PhotoTables.sql. ');
INSERT History VALUES('spPhoto','2005-01-02','Ani','Added ''top 1'' to fStrip[e]OfRun so they wont bomb on runs that have multiple entries in Segment (fix for PR #6289).  ');
INSERT History VALUES('spPhoto','2005-04-08','Ani','Added fObjID. ');
INSERT History VALUES('spPhoto','2005-10-11','Ani','Added fObjIdFromSDSSWithFF to include firstfield flag in objid components. ');
INSERT History VALUES('spPhoto','2006-01-31','Ani','Fixed sample calls to fHMSBase. ');
INSERT History VALUES('spPhoto','2007-04-12','Ani','Added aperture mag functions (PR 7169). ');
INSERT History VALUES('spPhoto','2007-04-24','Ani','Added fUberCal function to return UberCal corrected mags. ');
INSERT History VALUES('spPhoto','2007-06-04','Ani','Fixed bug in fPhotoApMag* functions - missing objid. ');
INSERT History VALUES('spPhoto','2007-12-31','Ani','Fixes to aperture mag functions to include aperture mags in all bands (see PRs #7390 and 7426).  2208-01-10  Ani: Fixed typos in fGetPhotoApMag and fPhotoApMagErr. ');
INSERT History VALUES('spPhoto','2008-08-16','Ani','Added fSDSSfromObjID to return a table of objid components. ');
INSERT History VALUES('spPhoto','2008-09-05','Ani','Fixed typos in fSDSSfromObjID. ');
INSERT History VALUES('resolveTables','2010-11-12','Ani','Copied in schema for tables from sas-sql. ');
INSERT History VALUES('resolveTables','2010-11-24','Ani','Changed thingIndex.objID to bigint. ');
INSERT History VALUES('NeighborTables','2003-05-15','Alex','split off from the photoTables.sql ');
INSERT History VALUES('NeighborTables','2003-05-19','Jim','added Match and MatchHead tables ');
INSERT History VALUES('NeighborTables','2003-07-08','Ani','Removed references to MatchMiss table from Match/MatchHead text (PR 5464). ');
INSERT History VALUES('NeighborTables','2004-08-26','Alex','updated Match and MatchHead ');
INSERT History VALUES('NeighborTables','2010-11-18','Ani','Removed Match/MatchHead tables. ');
INSERT History VALUES('SpectroTables','2001-04-15','Jim+Alex','go to uniform names. return from varchar to tile in SpecObj table. ');
INSERT History VALUES('SpectroTables','2001-05-25','Jim','objType-> type, fiberCounts -> fiberMag ');
INSERT History VALUES('SpectroTables','2001-08-15','Jim','replaced SpecObj with SpecObjAll  (some spectra are QA or dups.) Added objID to specObjAll Changed procedure name from getFiberList() to fGetFiberList() ');
INSERT History VALUES('SpectroTables','2001-11-06','Alex','changed the way primary keys are laid out, added comments ');
INSERT History VALUES('SpectroTables','2001-11-06','Alex','moved specLineNames to the Constants.sql script ');
INSERT History VALUES('SpectroTables','2002-04-24','Ani','added loadVersion to Plate and SpecObjAll tables, and commented out USE statement (isqlw specifies DB name now). Also added taiHMS field to Plate table. ');
INSERT History VALUES('SpectroTables','2002-05-01','Ani','incorporated Adrian''s tiling changes (PR 2433) ');
INSERT History VALUES('SpectroTables','2002-08-11','Adrian','modified tiling schema to work with versioned DB ');
INSERT History VALUES('SpectroTables','2002-08-20','Adrian','modified HoleObj ');
INSERT History VALUES('SpectroTables','2002-09-20','Alex','fixed unit names, also changed tile name in specobj to img ');
INSERT History VALUES('SpectroTables','2002-09-20','Alex','Added UCDs to the schema ');
INSERT History VALUES('SpectroTables','2002-09-24','Ani','Moved Target and TargetInfo to photoTables.sql Moved primary key creation to primaryKeys.sql ');
INSERT History VALUES('SpectroTables','2002-11-01','Alex','changed loadVersion type to int ');
INSERT History VALUES('SpectroTables','2002-11-07','Alex','Changed SpecLine to SpecLineAll ');
INSERT History VALUES('SpectroTables','2002-11-16','Alex','added spRerun to PlateX ');
INSERT History VALUES('SpectroTables','2002-12-03','Alex','changed Sector2Tile.tile to smallint ');
INSERT History VALUES('SpectroTables','2003-01-27','Ani','Made changes to tiling schema as per PR# 4702: renamed TileRegion to TilingRegion renamed TileInfo to TilingInfo renamed TileNotes to TilingNotes renamed TileBoundary to TilingGeometry added tinyint "isMask" to TilingGeometry removed TiBound2TsChunk removed Target2Sector ');
INSERT History VALUES('SpectroTables','2003-01-24','Jim','added file group mapping ');
INSERT History VALUES('SpectroTables','2003-01-27','Ani','Made changes to tiling schema as per PR# 4702: renamed TileRegion to TilingRegion renamed TileInfo to TilingInfo renamed TileNotes to TilingNotes renamed TileBoundary to TilingGeometry added tinyint "isMask" to TilingGeometry removed TiBound2TsChunk removed Target2Sector 2003-01-28:	Alex: changed PlateX.version to varchar(32) ');
INSERT History VALUES('SpectroTables','2003-01-30','Ani','Increased varchars from 20 to 64 chars in PlateX ');
INSERT History VALUES('SpectroTables','2003-02-21','Ani','Added duplicate to TiledTarget (PR #4487). ');
INSERT History VALUES('SpectroTables','2003-03-21','Ani','Fix for PR #5016 (Signal-to-noise descriptions in PlateX) ');
INSERT History VALUES('SpectroTables','2003-05-05','Ani','Added positional info to TiledTarget (PR #5276). ');
INSERT History VALUES('SpectroTables','2003-05-05','Ani','Changed "reddening" to "extinction" in PlateX and Tile, as per PR #5277. ');
INSERT History VALUES('SpectroTables','2003-05-16','Ani','Added functions to extract components of specObjIDs (supplied by Adrian Pope). ');
INSERT History VALUES('SpectroTables','2003-05-20','Adrian+Alex','move Sector, Best2Sector, Sector2Tile, TargetParam, TilingRegion, TilingNotes, TilingGeometry, Tile, TiledTarget, TilingInfo to tilingTables.sql ');
INSERT History VALUES('SpectroTables','2003-06-02','Alex','added SpecPhotoAll table ');
INSERT History VALUES('SpectroTables','2003-06-04','Adrian+Alex','added SpecPhotoAll.targetMode, SpecPhotoAll.mode ');
INSERT History VALUES('SpectroTables','2003-06-07','Jim','added QSO support tables ');
INSERT History VALUES('SpectroTables','2003-06-23','Ani','Fixed error in SpecLineAll.category description. ');
INSERT History VALUES('SpectroTables','2003-06-26','Ani','Fixed spelling of Angstroem->Angstrom ');
INSERT History VALUES('SpectroTables','2003-10-24','Ani','Fixed UCDs of specObjID and bestObjID (PR #5724). ');
INSERT History VALUES('SpectroTables','2003-11-12','Ani','DR2 spectro changes (PR #5741). ');
INSERT History VALUES('SpectroTables','2004-07-14','Ani','Fix for PR #6088 (QSO catalog descriptions). ');
INSERT History VALUES('SpectroTables','2004-12-17','Ani','Moved functions/sps to spSpectro.sql. ');
INSERT History VALUES('SpectroTables','2005-04-02','Ani','Added QuasarCatalog table. ');
INSERT History VALUES('SpectroTables','2005-05-02','Ani','Updated description of PlateX.plateID. ');
INSERT History VALUES('SpectroTables','2006-04-09','Ani','Updated schema of QSO catalogs for DR5 (from Jim). Replaced QsoConcordance with QsoConcordanceAll, added QsoBunch, QsoBest, QsoTarget and QsoSpec. ');
INSERT History VALUES('SpectroTables','2006-04-10','Ani','Fixed bug in QSO schema - added extinction for all  bands in QsoBest and QsoTarget. ');
INSERT History VALUES('SpectroTables','2006-05-15','Ani','Shortened description of QsoCatalogAll so it would not overflow the varchar for it in DBObjects. ');
INSERT History VALUES('SpectroTables','2006-06-08','Ani','Updated QuasarCatalog description. ');
INSERT History VALUES('SpectroTables','2006-07-31','Ani','Removed PK defs for QsoCatalog tables. ');
INSERT History VALUES('SpectroTables','2006-08-02','Ani','Added SEGUE and other target flags to SpecObjAll for DR6 (PR # 6998). ');
INSERT History VALUES('SpectroTables','2007-06-14','Ani','Renamed QuasarCatalog to DR3QuasarCatalog, added new table DR5QuasarCatalog. ');
INSERT History VALUES('SpectroTables','2007-06-15','Ani','Added sppLines and sppParams. ');
INSERT History VALUES('SpectroTables','2007-12-05','Ani','Fix for PR #7428 (12C13* column names enclosed in []). ');
INSERT History VALUES('SpectroTables','2008-07-21','Ani','Removed identity type for column "QsoPrimary" in  QsoConcordanceAll as part of fix for PR #7629. ');
INSERT History VALUES('SpectroTables','2008-09-25','Ani','Removed last two columns for new sppLines table (PR #7648).  ');
INSERT History VALUES('SpectroTables','2008-10-16','Ani','Added metadata for sppParams from Brian Yanny (PR #7660).  ');
INSERT History VALUES('SpectroTables','2009-06-04','Ani','Updated schema for SDSS-III. ');
INSERT History VALUES('SpectroTables','2009-06-10','Ani','Removed PlateX.programName. ');
INSERT History VALUES('SpectroTables','2009-08-13','Ani','Renamed specClass to class and bestPrimTarget,bestSecTarget to primTarget, secTarget in SpecPhotoAll for SDSS-III. ');
INSERT History VALUES('SpectroTables','2009-10-01','Ani','Replaced spec2dRerun and ssppRerun with run2d, run1d and runsspp in PlateX, and replaced spec2dRerun with run2d and  run1d in SpecObjAll. ');
INSERT History VALUES('SpectroTables','2007-06-15','Ani','Deleted sppLines and sppParams - these are in ssppTables.sql now. ');
INSERT History VALUES('SpectroTables','2009-10-13','Ani','Reinstateed PlateX.programName because CSV file has it. ');
INSERT History VALUES('SpectroTables','2009-10-29','Ani','Increased length of PlateX.designComments from 32 to 128. ');
INSERT History VALUES('SpectroTables','2010-01-07','Ani','Increased length of PlateX.mjdList from 32 to 512. ');
INSERT History VALUES('SpectroTables','2010-06-21','Naren','Added column "img" for SpecObjAll. ');
INSERT History VALUES('SpectroTables','2010-07-08','Ani','Added default value to SpecObjAll.img column. ');
INSERT History VALUES('SpectroTables','2010-09-16','Ani','Synced SpecObjAll with sas-sql, deleted tables ELRedshift, XCRedshift and HoleObj. ');
INSERT History VALUES('SpectroTables','2010-10-12','Ani','Synced Platex with sas-sql version. ');
INSERT History VALUES('SpectroTables','2010-11-04','Ani','Synced Platex and SpecObjAll with sas-sql version. ');
INSERT History VALUES('SpectroTables','2010-11-18','Ani','Removed SpecLine* tables. ');
INSERT History VALUES('SpectroTables','2010-12-02','Ani','Modified SpecPhotoAll schema as per Mike Blanton. ');
INSERT History VALUES('spSpectro','2004-12-17','Ani','Moved here from SpectroTables.sql. 2010-06-29  Ani/Naren/Vamsi : Added spMakeSpecObjAll stored procedure for loading Spectrum images on to database.  ');
INSERT History VALUES('TilingTables','2010-12-10','Ani','Removed "dbo." from spMakeSpecObjAll. 2003-05-21 Adrian and Alex: changed Tile to TileAll,  took out htmSupport, added untiled ');
INSERT History VALUES('TilingTables','2003-05-21','Adrian+Alex','modified Sector table, switched to regionId, dropped htmInfo and htmSupport ');
INSERT History VALUES('TilingTables','2003-05-21','Adrian+Alex','changed TargetParam to name,value ');
INSERT History VALUES('TilingTables','2003-05-21','Adrian+Alex','changed TilingRegion to TilingRun ');
INSERT History VALUES('TilingTables','2003-05-21','Adrian+Alex','changed TilingNotes to TIlingNote, and TileNoteID to TilingNoteID, TileNotes to TilingNote ');
INSERT History VALUES('TilingTables','2003-05-21','Adrian+Alex','changed TilingGeometry.tileBoundID to tilingGeometryID, removed htm* ');
INSERT History VALUES('TilingTables','2003-05-21','Adrian+Alex','changed TiledTarget to TiledTargetAll,  added untiled ');
INSERT History VALUES('TilingTables','2003-05-21','Adrian+Alex','changed Best2Sector.bestObjID to objID ');
INSERT History VALUES('TilingTables','2003-05-21','Adrian+Alex','moved views Tile, TiledTarget, TilingBoundary,  TilingMask to this file ');
INSERT History VALUES('TilingTables','2003-06-04','Adrian+Alex','added Target.bestMode, TargetInfo.targetMode ');
INSERT History VALUES('TilingTables','2003-06-06','Ani','Renamed Tile->TileAll and TiledTarget->TiledTargetAll, added unTiled to both tables (PR #5305). ');
INSERT History VALUES('TilingTables','2003-08-20','Ani','Added TileContains for region/convex/wedges stuff. ');
INSERT History VALUES('TilingTables','2003-11-12','Ani','Added lambdaLimits to TilingGeometry (PR #5742). ');
INSERT History VALUES('TilingTables','2004-08-30','Alex','moved tiling views to Views.sql 2004-09--2 Alex: removed TileContains, it is obsolete ');
INSERT History VALUES('TilingTables','2009-08-11','Ani','Removed TilingNote, renamed tables for SDSS-III and  swapped in schema changes. ');
INSERT History VALUES('TilingTables','2010-11-24','Ani','Changed sdssTilingInfo.tid to int from smallint. ');
INSERT History VALUES('TilingTables','2010-12-07','Ani','Renamed TargetParam to sdssTargetParam and updated schema for it. ');
INSERT History VALUES('TilingTables','2010-12-07','Ani','Changed sdssTargetParam.value to varchar(512). ');
INSERT History VALUES('RegionTables','2004-03-18','Alex','moved here from spBoundary ');
INSERT History VALUES('RegionTables','2004-03-25','Jim','dropped RegionConvexString, added RegionConvex,  added comments re sectors etc ');
INSERT History VALUES('RegionTables','2004-03-30','Alex','changed column names in RegionConvex ');
INSERT History VALUES('RegionTables','2004-03-31','Alex','added RegionArcs table ');
INSERT History VALUES('RegionTables','2004-05-06','Alex','merged with SectorSchema.sql ');
INSERT History VALUES('RegionTables','2004-05-06','Alex','added spSetDefaultFileGroup commands ');
INSERT History VALUES('RegionTables','2004-08-27','Alex','moved here the Rmatrix table ');
INSERT History VALUES('RegionTables','2004-10-08','Ani','added mode doc for Rmatrix. ');
INSERT History VALUES('RegionTables','2004-12-22','Alex+Adrian','added more fields to Best2Sector ');
INSERT History VALUES('RegionTables','2005-01-28','Alex','Changed Best2Sector to BestTarget2Sector ');
INSERT History VALUES('RegionTables','2005-03-06','Alex','changed Region2Box.regionid->id, added type to Sector2Tile ');
INSERT History VALUES('RegionTables','2005-03-10','Alex','added patch column to RegionConvex ');
INSERT History VALUES('RegionTables','2005-03-13','Alex','added targetVersion column to Sector ');
INSERT History VALUES('RegionTables','2005-10-22','Ani','added command to revert to primary filegroup at the end. ');
INSERT History VALUES('RegionTables','2007-06-08','Alex','modified RegionConvex to RegionPatch, added view. Also added area to RegionPatch ');
INSERT History VALUES('RegionTables','2010-12-10','Ani','deleted BestTarget2Sector and Sector2Tile. ');
INSERT History VALUES('WindowTables','2009-07-30','Ani','Adapted from sas-sql/sdssWindow.sql. ');
INSERT History VALUES('WindowTables','2009-10-07','Ani','Changed REAL to FLOAT for coords. ');
INSERT History VALUES('WindowTables','2010-01-18','Ani','Updated descriptions of mangle coords in sdssImagingHalfSpaces. ');
INSERT History VALUES('ssppTables','2009-08-28','Ani','Copied in schema for tables from sas-sql. ');
INSERT History VALUES('ssppTables','2009-08-31','Ani','Adapted sppTargets from sas/sql/seguetsObjSetAll.sql. ');
INSERT History VALUES('ssppTables','2009-10-30','Ani','Added run1d, run2d and runsspp sppParams and sppLines. ');
INSERT History VALUES('ssppTables','2009-10-30','Ani','Added specObjID to sppLines, sppParams and objID to appTargets. ');
INSERT History VALUES('ssppTables','2010-02-02','Ani','Updated sppTargets schema from sas-sql. ');
INSERT History VALUES('ssppTables','2010-02-09','Ani','Changed ra,dec and l,b in sppParams to float (from real). ');
INSERT History VALUES('ssppTables','2010-02-09','Ani','Added column bestObjID to sppParams. 2010-07-16  Naren/vamsi : Implemented SEGUE-2 schema changes to  sppLines, sppParams and sppTargets Tables. 2010-07-20  Naren/vamsi: Synchronized the schema with SAS/sql for SEGUE2. ');
INSERT History VALUES('ssppTables','2010-07-25','Ani','Changed segueTsObjSetAll to sppTargets. ');
INSERT History VALUES('ssppTables','2010-07-28','Ani','Fixed sppTargets description (created short description for --/H tag and changed tag to --/T for long description. ');
INSERT History VALUES('ssppTables','2010-07-29','Ani','Moved sppTargets column provenance comments up to the  table description so they get properly displayed in the schema browser. ');
INSERT History VALUES('ssppTables','2010-11-04','Ani','Synced sppLines and sppParams with sas-sql version. ');
INSERT History VALUES('ssppTables','2010-11-24','Ani','Fixed OBJID column in sppTargets (no newline before it). ');
INSERT History VALUES('ssppTables','2010-11-24','Ani','Changes Plate2Target.plateID to bigint. ');
INSERT History VALUES('ssppTables','2010-11-25','Ani','Commented out sppLines.seguePrimary for now. ');
INSERT History VALUES('ssppTables','2010-12-08','Ani','Added segueTargetAll table schema. ');
INSERT History VALUES('FrameTables','2001-04-10','Jim','Moved index creation to happen after load. ');
INSERT History VALUES('FrameTables','2001-05-15','Alex','changed spMakeFrame to join to Segment ');
INSERT History VALUES('FrameTables','2001-11-06','Alex','added bunch of comments, plus separate PRIMARYKEYs ');
INSERT History VALUES('FrameTables','2001-11-10','Alex+Jan','changed SP''s from fXXX to spXX, also fixed  TilingPlan primary key constraint ');
INSERT History VALUES('FrameTables','2001-12-02','Alex','moved the Globe table here ');
INSERT History VALUES('FrameTables','2002-09-10','Alex','changed fTileFileName and spMakeFrame ');
INSERT History VALUES('FrameTables','2002-09-20','Alex','changed tile in Globe, Frame and Mosaic to img to avoid confusion ');
INSERT History VALUES('FrameTables','2002-09-20','Alex','fixed units, added UCDs ');
INSERT History VALUES('FrameTables','2002-10-26','Alex','moved PK''s to separate file ');
INSERT History VALUES('FrameTables','2002-11-26','Alex','removed Mosaic related functions and Tables ');
INSERT History VALUES('FrameTables','2003-01-26','Jim','added Frame File group mapping ');
INSERT History VALUES('FrameTables','2003-05-15','Alex','added reset filegroup to primary to the end ');
INSERT History VALUES('FrameTables','2003-05-25','Alex','moved fEqFromMuNu and fMuNuFromEq to boundary.sql ');
INSERT History VALUES('FrameTables','2003-05-28','Alex','removed Globe table ');
INSERT History VALUES('FrameTables','2003-12-04','Jim','for SQL best practices   put FOR UPDATE clause in frames_cursor of spComputeFrame 2010-04-20  Ani/Naren: SDSS-III updates - Frame table schema changes, spMakeFrame replaced with JPEG 2000 version and fTileFileName updated (do not use DTS any more). ');
INSERT History VALUES('FrameTables','2010-12-11','Ani','Removed "dbo." from fTileFileName. ');
INSERT History VALUES('GalaxyZooTables','2011-01-14','Ani','Copied in schema for tables from sas-sql. ');
INSERT History VALUES('Views','2001-05-15','Alex','removed parent from PhotoObj and PrimaryObjects ');
INSERT History VALUES('Views','2001-05-15','Alex','changed objType to type in where clauses ');
INSERT History VALUES('Views','2001-05-15','Alex','fixed Tag attribute names ');
INSERT History VALUES('Views','2001-05-25','Alex','fixed a bug in PrimaryObjects-- ugriz-Err  was mapped onto the magnitudes instead of the errors ');
INSERT History VALUES('Views','2001-05-25','Alex','fixed a bug in Galaxies -- type was 6, now is 3 ');
INSERT History VALUES('Views','2001-11-05','Alex','added PhotoPrimary, PhotoSecondary, PhotoFamily views ');
INSERT History VALUES('Views','2002-09-17','Ani','Changed SpecObj view to use sciencePrimary instead of isPrimary ');
INSERT History VALUES('Views','2003-01-27','Ani','Added views TilingBoundary and TilingMask (PR #4702) ');
INSERT History VALUES('Views','2003-05-15','Alex','Changed PhotoObj-> PhotoObjAll ');
INSERT History VALUES('Views','2003-05-21','Adrian+Alex','move TilingBoundary and TilingMask views to tilingTables.sql ');
INSERT History VALUES('Views','2003-06-04','Alex','reverted PhotObj to mode=(1,2), dropped Tag ');
INSERT History VALUES('Views','2003-11-17','Ani','Defined view Columns to alias DBColumns for SkyQuery. ');
INSERT History VALUES('Views','2004-06-04','Ani','Added clarifications to Star and Galaxy views as per PR #6054. ');
INSERT History VALUES('Views','2004-07-08','Ani','Changed "unresolved" to "resolved" in Galaxy view description. ');
INSERT History VALUES('Views','2004-08-30','Alex','Moved here various views frim TilingTables ');
INSERT History VALUES('Views','2004-10-08','Ani','Made minor update to PhotoObj description. ');
INSERT History VALUES('Views','2005-06-02','Ani','Added PhotoAux view of new PhotoAuxAll table. ');
INSERT History VALUES('Views','2005-06-11','Ani','Added Run view of Segment table. ');
INSERT History VALUES('Views','2006-03-09','Ani','Added StarTag, GalaxyTag views of primary PhotoTag analogous to Star and Galaxy from PhotoPrimary (PR #5940). ');
INSERT History VALUES('Views','2006-04-09','Ani','Added views for QsoCatalog and QsoConcordance. ');
INSERT History VALUES('Views','2006-08-02','Ani','Added PhotoAuxAll view for DR6 (PR #7000). ');
INSERT History VALUES('Views','2006-08-02','Ani','Added views for TargPhotoObjAll (PR #6866). ');
INSERT History VALUES('Views','2006-12-01','Ani','Removed ref. to OK_RUN in PhotoPrimary doc (PR #6090). ');
INSERT History VALUES('Views','2007-01-24','Ani','Added NOLOCK hints to all table views (PR #7140). ');
INSERT History VALUES('Views','2007-08-21','Ani','Added spbsParams view (PR #7345). ');
INSERT History VALUES('Views','2009-04-27','Ani','Deleted view Run (replaced by table Run) for SDSS-III. Also removed TargPhotoObjAll and PhotoAux views. ');
INSERT History VALUES('Views','2009-05-05','Ani','Commented out columns in spbsParams that do not exist in base table sppParams, for SDSS-III. ');
INSERT History VALUES('Views','2010-11-16','Ani','Added view for TableDesc (no longer a table). ');
INSERT History VALUES('Views','2010-11-18','Ani','Removed SpecLine view - underlying table is gone. ');
INSERT History VALUES('Views','2010-11-18','Ani','Renamed tiling views to add "sdss" prefix. ');
INSERT History VALUES('Views','2010-11-18','Ani','Modified view for TableDesc to make IndexMap an outer join. ');
INSERT History VALUES('Views','2010-11-19','Ani','Commented out spbsParams view until it is fixed. ');
INSERT History VALUES('Views','2010-11-25','Ani','Commented out sdssTiledTarget view (broken, no unTiled col). ');
INSERT History VALUES('Views','2010-12-10','Ani','Added PhotoTag view. ');
INSERT History VALUES('Views','2010-12-12','Ani','Added missing GO after PhotoTag view definition. ');
INSERT History VALUES('Views','2010-12-23','Ani','Added SEGUE specObjAll views. ');
INSERT History VALUES('spSphericalLib','2009-12-16','Ani','updated fSphSimplifyAdvanced as per Tamas''s  changes for SDSS-III. ');
INSERT History VALUES('spHtmCSharp','2005-05-01','Jim','started ');
INSERT History VALUES('spHtmCSharp','2005-05-02','Jim','removed fHtmLookup and fHtmLookupError added fHtmToString ');
INSERT History VALUES('spHtmCSharp','2005-05-05','GYF','added .pdb to assembly for symbolic debugging added fHtmToName (faster than fHtmToString and reports error) ');
INSERT History VALUES('spHtmCSharp','2005-05-09','Jim','Added more documentation.   Replaced fHtmtoString with fHtmToName ');
INSERT History VALUES('spHtmCSharp','2005-05-11','Jim','Added fDistanceEq, fDistanceXyz Changed fHtmToPoint to fHtmToCenterPoint fHtmToVertices to fHtmToCornerPoints Defaulted to release version of library. ');
INSERT History VALUES('spHtmCSharp','2005-05-17','GYF','Added fHtmLatLon, fDistanceLatLon, fHtmCoverCircleLatLon ');
INSERT History VALUES('spHtmCSharp','2005-05-19','Jim','Fixed comments re fHtmToPoint,fHtmToCenterPoint  ');
INSERT History VALUES('spHtmCSharp','2005-05-22','Jim','Replace fHtmCoverError,  fHtmToNormalFormError()  ');
INSERT History VALUES('spHtmCSharp','2005-05-31','GYF','Added fHtmXyzToEq, fHtmXyzTolatLon, ');
INSERT History VALUES('spHtmCSharp','2005-06-02','Jim','Minor changes to comments. ');
INSERT History VALUES('spHtmCSharp','2005-06-04','Jim','renamed fHtmGetNearbyXXX to fHtmNearbyXXX  ');
INSERT History VALUES('spHtmCSharp','2005-06-22','GYF','added (fHtmCoverToHalfspaces see next:) ');
INSERT History VALUES('spHtmCSharp','2005-06-28','GYF','changed the name to fHtmRegionToTable ');
INSERT History VALUES('spHtmCSharp','2005-06-29','Jim','fixed code to have new-new function names. fixed comments to reflect 21-deep (not 20 deep) HTMs ');
INSERT History VALUES('spHtmCSharp','2005-06-30','Jim','Added fHtmRegionObjects ');
INSERT History VALUES('spHtmCSharp','2005-07-01','GYF','fHtmRegionObjects dropped properly ');
INSERT History VALUES('spHtmCSharp','2005-09-07','GYF','fHtmCoverList added ');
INSERT History VALUES('spHtmCSharp','2006-08-07','GYF','All latlon functions moved to spHtmGeoCsharp.sql ');
INSERT History VALUES('spHtmCSharp','2007-06-10','Alex','split package into two parts spHtmCsharp.sql,  containing only the core and spHtmSearch.sql ');
INSERT History VALUES('spHtmCSharp','2008-06-25','Ani','Fixed fHtmCoverRegion description so that the syntax is displayed with newlines rather than as one very long line. ');
INSERT History VALUES('spHtmCSharp','2008-09-29','Ani','Incorporated comment changes from latest HTM rebuild. ');
INSERT History VALUES('spNearby','2001-05-15','Alex','Changed to HTMIDstart, HTMIDend ');
INSERT History VALUES('spNearby','2001-11-08','Jim','removed PhotoSpectro table join ');
INSERT History VALUES('spNearby','2001-11-28','Alex+Jim','documentation  ');
INSERT History VALUES('spNearby','2001-12-08','Jim','moved *Near* functions to *Near* file. converted to ASIN() rather than cartesian distance. ');
INSERT History VALUES('spNearby','2002-06-21','Jim+Alex','Added fGetNearbyMosaicEq, fGetNearbyFrameEq, fGetJpegObjects for CutOut Service and convereted Mosaic and Frame functions to use trig rather than dot-product distance.  ');
INSERT History VALUES('spNearby','2002-09-12','Ani','Fix for skyserver/4233 - replaced "N.*" with "*" in  fGetNearestObjEq example ');
INSERT History VALUES('spNearby','2002-09-14','Jim+Alex+Ani',' Fixed fGetNearest* bug (return nearest object not smalles objID Added more and better comments to most routines. Moved spatial functions here from WebSupport Added fDistanceArcMinEq and fDistanceArcMinXYZ Removed use SkyServerV3 ');
INSERT History VALUES('spNearby','2002-09-26','Alex','commented out fGetJPEGObjects, since there is no specObjID in photoObj ');
INSERT History VALUES('spNearby','2002-10-26','Alex','removed PRIMARY KEY designator from nearby functions, this caused incorrect behaviour with respect to order by distance ');
INSERT History VALUES('spNearby','2002-11-26','Alex','removed Mosaic functions ');
INSERT History VALUES('spNearby','2003-02-05','Alex','added back the fJpegObjects ');
INSERT History VALUES('spNearby','2003-02-19','Alex','added fGetNearestFrameidEq ');
INSERT History VALUES('spNearby','2003-02-23','Alex','added objid to fGetJpegObjects, so that we can join with AtlasOutline ');
INSERT History VALUES('spNearby','2003-03-03','Alex','added PlateX to fGetJpegObjects ');
INSERT History VALUES('spNearby','2003-04-06','Alex','modified the upper limit on the search radius for fGetJpegObjects, set it to 250 arcsec. ');
INSERT History VALUES('spNearby','2003-07-09','Jim','converted to HTM V2 functions (that do auto-level select and that use new syntax for cover). Dropped fGetObjectsWWT. Renamed fGetJpegObjects to fGetObjectsEq ');
INSERT History VALUES('spNearby','2003-12-03','Jim','for SQL best practices,  added distance to frame function results fixed select * and Top 1 orderby problems  fixed fGetNearbyFrameEq() and fGetNearestFrameEq() ');
INSERT History VALUES('spNearby','2004-01-11','Ani','Fixed bug in fGetNearbyObjAllXyZ (join with PhotoTag instead of PhotoPrimary). Also, created fGetNearbyObjAllEq as "all" version of  fGetNearbyObjEq and changed fGetObjFromRect to call  that instead. ');
INSERT History VALUES('spNearby','2004-02-13','Alex','in fGetObjectsEq allowed larger radius for the Plates (flag=16). ');
INSERT History VALUES('spNearby','2004-02-19','Ani','Fix for PR #5879, set minimum search radius to 0 for fGetNearbyObjEq, fGetNearbyObjAllEq,  fGetNearbyObjXYZ and fGetNearbyObjAllXYZ (was 0.1 arcmin before). ');
INSERT History VALUES('spNearby','2004-04-02','Ani','Modified spGetNeighbors to call fGetNearbyObjAllEq instead of fGetNearbyObjEq, so that all neighbors are returned, not just primaries. ');
INSERT History VALUES('spNearby','2004-05-27','Ani','Added spGetNeighborsPrim and spGetNeighborsAll to have 2 versions of spGetNeighbors (which is same as  spGetNeighborsAll) for the crossid to call.  This was to add "All nearby primary objects" option. ');
INSERT History VALUES('spNearby','2004-09-15','Alex','added again spGetMatch ');
INSERT History VALUES('spNearby','2004-11-22','Alex','added flag=32 from PhotoObjAll to fGetObjectsEq ');
INSERT History VALUES('spNearby','2005-04-15','Ani','Added spGetNeighborsRadius for casjobs variable  radius searches. ');
INSERT History VALUES('spNearby','2005-10-11','Ani','added fGetNearestObjAllEq, fGetNearestObjIdAllEq and fGetObjectsMaskEq, all of which were patched in  after DR3 but somehow didnt make it here. ');
INSERT History VALUES('spNearby','2005-12-23','Ani','Created fGetObjFromRectEq as a variant of fGetObjFromRect that takes the params in the order (ra1,dec1,ra2,dec2)  instead of (ra1,ra2,dec1,dec2).  See PR #6829. ');
INSERT History VALUES('spNearby','2006-05-21','Jim','CHanges for C# HTM rountines (SQL 2005 only) Converted from "string" to direct fHtmCoverCircleXyz() calls replaced cursors in spGetNeighbors, spGetNeighborsRadius and  spGetNeighborsPrim(@r) with cross-apply (SQL 2005 only). ');
INSERT History VALUES('spNearby','2006-12-14','Ani','Added db compatibility and CLR enable commands. ');
INSERT History VALUES('spNearby','2007-01-24','Ani','Replaced PhotoTag join with PhotoObjAll in  fGetNearbyObjAllXYZ, because PhotoTag has a covering index missing which causes the join to be very slow. ');
INSERT History VALUES('spNearby','2007-02-15','Ani','Added ORDER BY <distance> to each query in  fGetObjectsEq to speed it up in 2k5. ');
INSERT History VALUES('spNearby','2007-03-09','Ani','Changed #objects to #upload in spGetNeighbors (was a typo in 2005 "cross apply" update, see 2006-05-21). ');
INSERT History VALUES('spNearby','2007-10-02','Ani','Replaced fGetNearbyFrameEq with sql2k5 version from Alex that was added to patches in July/07. ');
INSERT History VALUES('spNearby','2008-08-08','Ani','Fix for PR #6906 (correct doc for fGetNearbyObjAllEq). ');
INSERT History VALUES('spNearby','2008-08-09','Ani','Fix for PR #6913 (correct doc for fGetObjFromRectEq). ');
INSERT History VALUES('spNearby','2008-10-21','Ani','Added fGetNearby/est SpecObj equivalents (PR #6359). ');
INSERT History VALUES('spNearby','2010-02-23','Victor','updated fgetnearbyspecobj* functions for changes  to specobjall schema for SDSS3 ');
INSERT History VALUES('spNearby','2010-05-13','Ani','Added NOT NULL to fGetNearbyObj[All]Eq.objid. ');
INSERT History VALUES('spNearby','2010-12-10','Ani','Updated fGetNearestSpecObjIdType for string "class". ');
INSERT History VALUES('spNearby','2010-12-11','Ani','Removed fGetNearestSpecObjIdType. ');
INSERT History VALUES('spNearby','2010-12-11','Ani','Applied performance enhancement changes as per Alex & Deoyani (for SQL Server 2008). ');
INSERT History VALUES('spNearby','2010-12-14','Ani','Added missing changes for fGetObjectsEq from previous. ');
INSERT History VALUES('spNearby','2011-02-03','Ani','Fixed typo in spGetNeighbors - changed call to fGetNearbySpecObjAllEq to fGetNearbyObjAllEq. ');
INSERT History VALUES('spNearby','2011-02-21','Ani','Added perf tweak to fGetNearbySpecObj[All]XYZ too. ');
INSERT History VALUES('spCoordinate','2004-02-13','Ani','Fixed bugs in fCoordsFromEq, fLambdaFromEq and fEtaFromEq (PR #5865). ');
INSERT History VALUES('spCoordinate','2004-03-18','Alex','extracted coordinate related stuff from spBoundary.sql ');
INSERT History VALUES('spCoordinate','2004-06-10','Alex','added support for Galactic coordinates ');
INSERT History VALUES('spCoordinate','2004-08-27','Alex','Moved Rmatrix to the RegionTables.sql module ');
INSERT History VALUES('spCoordinate','2004-10-08','Ani','Updated description of fGetLonLat, fGetLon and fGetLat. ');
INSERT History VALUES('spRegion','2004-03-25','Jim','replace RegionConvexString with RegionConvex table.  ');
INSERT History VALUES('spRegion','2004-02-12','Jim','started ');
INSERT History VALUES('spRegion','2004-02-07','Jim','revised to conform to Region-Convex design 2004-03-01 Jim & Alex: revised root code, many small changes. Ignores isMask flag on regions (treates all regions as positive). ');
INSERT History VALUES('spRegion','2004-03-18','Alex','fixed fRegionToArcs, propsagated bunch of other changes from Jim discarded spHtmSiplifyRegionid ');
INSERT History VALUES('spRegion','2004-03-25','Jim','RegionConvexString -> RegionConvex table ');
INSERT History VALUES('spRegion','2004-03-29','Alex','retired fRegionsToRootsForExcel and fRegionConvexFromString ');
INSERT History VALUES('spRegion','2004-03-29','Alex','added fRegionAreaSphTriangle ');
INSERT History VALUES('spRegion','2004-04-24','Alex','removed fRegionToRoots, fRegionConvexToRoots, replaced them with  fRegionConvexStringToArcs, fRegionStringToArcs, fRegionToArcs. Added fRegionConvexBCircle ');
INSERT History VALUES('spRegion','2004-05-06','Alex','Fixed c<=-1 bug in fRegionConvexToArcs ');
INSERT History VALUES('spRegion','2004-05-06','Alex','merged with spRegionGet.sql ');
INSERT History VALUES('spRegion','2004-05-20','Alex','added @stripe to spRegionNibbles, to compute the orientation of the universe ');
INSERT History VALUES('spRegion','2004-05-20','Alex','Fixed a bug in the bounding circle part of fRegionConvexToArcs ');
INSERT History VALUES('spRegion','2004-05-24','Alex','Added fill RegionArcs to spRegionSimplify, and the cleanup to spRegionDelete ');
INSERT History VALUES('spRegion','2004-05-26','Alex','Modified spRegionUnify to update RegionArcs if anything changed. ');
INSERT History VALUES('spRegion','2004-05-30','Alex','Moved spRegionNibbles to spSector.sql ');
INSERT History VALUES('spRegion','2004-05-30','Alex+Jim','added arcs copy to end of spRegionCopy ');
INSERT History VALUES('spRegion','2004-08-25','Alex','added various containment functions ');
INSERT History VALUES('spRegion','2004-10-21','Alex','moved RegionArcs to top in spRegionDelete to avoid foreign key conflicts. ');
INSERT History VALUES('spRegion','2004-10-26','Alex','added spRegionCopyFuzz ');
INSERT History VALUES('spRegion','2004-11-22','Alex','added flag=32 for PhotoObjAll to fRegionGetObjects*. ');
INSERT History VALUES('spRegion','2004-12-27','Alex','added fRegionSimplifyString call to fRegionStringToArcs ');
INSERT History VALUES('spRegion','2005-01-02','Alex','fixed a few small bugs in fRegionStringToArcs, now patch number is correct, and @regionid is set to zero in OR. Also turned fRegionToArcs into a wrapper for fRegionStringToArcs. ');
INSERT History VALUES('spRegion','2005-01-02','Alex','added buffer to fRegionFromString, also calls now fRegionSimplifyString. Modifed RegionGetObjectsFromString and fRegionConvexToArcs accordingly. Also changed return column names to xy,z from cx,cy,cz. ');
INSERT History VALUES('spRegion','2005-01-02','Alex','moved arc length computation into fRegionConvexToArcs. Modified  fRegionStringToArcs and fRegionToArcs accordingly. ');
INSERT History VALUES('spRegion','2005-01-02','Alex','modified fRegionConvexBCircle ');
INSERT History VALUES('spRegion','2005-01-03','Alex','changed fRegionSimplifyString to fRegionNormalizeString to reflect more what the function is doing. ');
INSERT History VALUES('spRegion','2005-01-03','Alex','changed fRegionsOverlapRegion to fRegionOverlap with a modified algorithm. ');
INSERT History VALUES('spRegion','2005-01-04','Alex','renamed fRegionConvexBCircle to fRegionConvex, modifed spRegionSimplify accordingly. ');
INSERT History VALUES('spRegion','2005-01-05','Alex','fixed small bug in fRegionConvexToArcs related to removal of almost identical constraints. Delete redundant constraints now. ');
INSERT History VALUES('spRegion','2005-01-05','Alex','added fRegionConvexFromString to compute bounding circle dynamically. ');
INSERT History VALUES('spRegion','2005-01-05','Alex','added rejection of (A-A)=NULL convex to fRegionConvexToArcs. ');
INSERT History VALUES('spRegion','2005-01-09','Alex','fiex a bug with single circles in fRegionConvex ');
INSERT History VALUES('spRegion','2005-01-22','Alex','Added fRegionOverlapString function ');
INSERT History VALUES('spRegion','2005-01-23','Alex','changed tolerance in fRegionsConvexStringToArcs ');
INSERT History VALUES('spRegion','2005-01-25','Alex','fixed bug in fRegionConvexToArcs where the tsate of a halfspace constraint was ignored during rejection tests. ');
INSERT History VALUES('spRegion','2005-01-26','Alex','added fRegionOverlapId ');
INSERT History VALUES('spRegion','2005-02-01','Alex','fixed Halfspace search bug in fRegionGetObjectsXX ');
INSERT History VALUES('spRegion','2005-02-02','Alex','modified spRegionContainsPointxxx to improve on the region test, added bounding circle test to fRegionsContainingPointxxx ');
INSERT History VALUES('spRegion','2005-03-06','Alex','added TOP 1 clause to the bounding circle generation in spRegionConvexToArcs ');
INSERT History VALUES('spRegion','2005-03-10','Alex','Added fRegionBoundingCircle, added patch to RegionConvex, and modified spRegionSimplify and the fRegionOverlap functions accordingly. Added test for single circles to fRegionBoundingCircle ');
INSERT History VALUES('spRegion','2005-03-12','Alex','Fixed triplet elimination bug in fRegionBoundingCircle. ');
INSERT History VALUES('spRegion','2005-03-13','Alex','Added tentative fFootprintEq function ');
INSERT History VALUES('spRegion','2005-03-19','Alex+Jim','Added fRegionArcLength and fixed bugs in RegionConvexToArcs ');
INSERT History VALUES('spRegion','2005-04-02','Alex','added patch to PK on the @convex table in the overlap functions. ');
INSERT History VALUES('spRegion','2005-04-08','Alex','Fixed small bug in the fRegionOverlap* functions ');
INSERT History VALUES('spRegion','2005-04-11','Alex','Added area functions: fRegionAreaTriangle, fRegionAreaSemiLune and fRegionAreaPatch. Also added area calculation to spRegionSimplify. ');
INSERT History VALUES('spRegion','2005-04-12','Alex','Added test for changes in HalfSpace in spRegionSimplify. If changed, recompute arcs. ');
INSERT History VALUES('spRegion','2005-04-13','Alex','added Sector2Tile and Region2Box to spRegionDelete ');
INSERT History VALUES('spRegion','2005-05-14','Alex','Removed spRegionCopyFuzz, spRegionNewConvex, spRegionNewConvexConstraint. Inlined call to fDistanceArcminXYZ in fGetRegionsContainingPointXYZ. Modified spRegionUnify to return change status only, and moved RegionArcs update entirely to spRegionSimplify. ');
INSERT History VALUES('spRegion','2006-12-22','Ani','Modified last section of fRegionGetObjectsFromString to use a temp table to avoid sql2k5 problem. ');
INSERT History VALUES('spRegion','2007-01-03','Ani','Replaced call to fHtmLookupXYZ with fHtmXyz (C# equiv.) in fRegionBoundingCircle. ');
INSERT History VALUES('spRegion','2007-01-09','Ani','Replaced fHtmToNormalForm call with the new C# HTM equivalent, fHtmRegionToNormalFormString, in  fRegionNormalizeString. ');
INSERT History VALUES('spRegion','2007-01-16','Ani','Modified fRegionFromString to look for region string form ''REGION CONVEX CARTESIAN ...'' in the C# HTM instead of ''REGION CONVEX ...''.  Not sure if the check for token ''CONVEX'' should be removed or left in (are there still some cases of the old syntax?). ');
INSERT History VALUES('spRegion','2007-01-23','Ani','Added a check to fRegionConvexToArcs for number of new roots inserted in WHILE loop, with a break out of the if the number is 0 to avoid an infinite loop.  See new @newroots variable.  This needs to be checked by the experts when the region code is overhauled for SQL 2005. ');
INSERT History VALUES('spRegion','2007-01-29','Ani','Added TILEBOX/SECTOR/SECTORLET/SKYBOX/WEDGE to list of possible region types in function descriptions. ');
INSERT History VALUES('spRegion','2007-01-31','Ani','Fixed a couple of typos in function descriptions. ');
INSERT History VALUES('spRegion','2007-06-04','Ani','Applied Svetlana''s changes to fRegionAreaSemiLune and fRegionBoundingCircle to avoid out of range errors. Also changed fHtmCover calls to fHtmCoverRegion. ');
INSERT History VALUES('spRegion','2007-06-11','Alex','deleted fRegionArcLength, fRegionAreaPatch, fRegionAreaSemilune, fRegionAreaTrinagle, fRegionBoundingCircle, fRegionConvexIdToString, fRegionConvexToArcs, fRegionFromString, fRegionIdToString, fRegionNormalizeString, fRegionNot, fRegionOverlap, fRegionOverlapString, fRegionPredicate, fRegionStringToArcs, fRegionToArcs, spRegionNot, spRegionOr, spRegionSimplify, spRegionUnify ');
INSERT History VALUES('spRegion','2007-08-20','Ani','Fixed typo in spRegionIntersect ("dbp" instead of "dbo"). ');
INSERT History VALUES('spCheckDB','2004-09-17','Alex','moved here all the spCheckDB* and Diagnostic procs as well as spGrantAccess ');
INSERT History VALUES('spCheckDB','2004-09-17','Alex','moved here spCheckDBIndexes from IndexMap.sql ');
INSERT History VALUES('spCheckDB','2004-11-11','Alex','added tableName output to the spCheckDBIndexes, making it easier to debug differences. ');
INSERT History VALUES('spCheckDB','2005-10-11','Ani','spCheckDBIndexes also returns the row count now. ');
INSERT History VALUES('spCheckDB','2006-06-18','Ani','Fixed bug in spCheckDBIndexes that was referencing temp table #diff after it had been dropped. ');
INSERT History VALUES('spCheckDB','2006-06-20','Ani','Added RecentQueries to the list of dynamic tables  excluded from diagnostics in spMakeDiagnostics. ');
INSERT History VALUES('spCheckDB','2007-01-26','Ani','Removed xp_varbintohexstr from spGrantAccess.  ');
INSERT History VALUES('spCheckDB','2007-08-24','Ani','Added access for function/SP viewing and IndexMap to spGrantAccess. ');
INSERT History VALUES('spCheckDB','2008-06-25','Ani','Added function type strings ''FS'' and ''FT'' to spGrantAccess for scalar and table-valued functions  in sql2k5 and beyond (fix for PR #7618). ');
INSERT History VALUES('spCheckDB','2010-12-11','Ani','Modified spMakeDiagnostics to use sp_spaceused so table row counts are done faster. ');
INSERT History VALUES('spTestQueries','2003-06-03','Alex','changed row_count from int to bigint, changed row_count() to rowcount_big(). ');
INSERT History VALUES('spTestQueries','2004-08-30','Alex','move QueryResults to MetadataTables.sql ');
INSERT History VALUES('spTestQueries','2004-08-31','Jim+Alex','adapted ad hoc script to a sp ');
INSERT History VALUES('spTestQueries','2005-03-09','Jim','fixed radians() bug in query 12,  moved other queies to Personal Skyserver Area. ');
INSERT History VALUES('spTestQueries','2005-12-13','Ani','Commented out Q19 since Photoz not loaded any more. ');
INSERT History VALUES('spTestQueries','2006-05-17','Ani','Reinstated Q19, Photoz back in for DR5. ');
INSERT History VALUES('spTestQueries','2007-06-10','Ani','Changed fHtmCover to fHtmCoverRegion. ');
INSERT History VALUES('spTestQueries','2008-02-10','Ani','Added ABS in Query 2 (needed for SEGUE queries). ');
INSERT History VALUES('spTestQueries','2009-05-05','Ani','Commented out queries usiing isophotal columns for SDSS-III. ');
INSERT History VALUES('spTestQueries','2009-08-13','Ani','Replaced specClass with class for specobj. ');
INSERT History VALUES('spTestQueries','2010-08-24','Ani','Removed reference to zconf from Query #9. ');
INSERT History VALUES('spDocSupport','2001-12-02','Jim','added comments, fixed things ');
INSERT History VALUES('spDocSupport','2002-11-16','Alex','Switched to Columns->DBColumns, ViewCol->DBViewCols ');
INSERT History VALUES('spDocSupport','2003-02-20','Alex','added fEnum() and spDocEnum to render the enumerated data types correctly ');
INSERT History VALUES('spDocSupport','2003-06-26','Ani','Updated fEnum() to handle small and tiny ints. ');
INSERT History VALUES('spDocSupport','2005-04-12','Ani','Added fDocColumnsWithRank to return table columns with rank for ordered column display in query builder tools (PR #6405). ');
INSERT History VALUES('spDocSupport','2007-01-01','Alex','modified fDocColumns, fDocColumnsWithRank and  fDocFunctionParams to work with SQL2005''s catalog view sys tables ');
INSERT History VALUES('spDocSupport','2007-01-01','Alex+Jim','added fVarBinToHex function to replace  xp_varbintohextstr procedure ');
INSERT History VALUES('spDocSupport','2007-07-20','Ani','Changed call to fVarBintoHex with call to built-in function master.dbo.fn_varbintohexstr in fEnum to fix PR #7339 (UberCalibStatus values wrong). ');
INSERT History VALUES('spSQLSupport','2001-12-02','Jim','added comments, fixed things ');
INSERT History VALUES('spSQLSupport','2001-12-24','Jim','Changed parsing in SQL stored procedures ');
INSERT History VALUES('spSQLSupport','2002-05-10','Ani','Added "limit" parameter to spExecuteSQL, spSkyServerFormattedQuery, spSkyServerFreeFormQuery so that 1000-record limit on output can be turned off. ');
INSERT History VALUES('spSQLSupport','2002-07-04','Jim','Added sql command loging to spExecSQL (statements go to weblog). ');
INSERT History VALUES('spSQLSupport','2003-01-20','Ani','Added Tanu''s changes to spSkyServerTables, spSkyServerDatabases, spSkyServerFunctions and spSkyServerFreeFormQuery ');
INSERT History VALUES('spSQLSupport','2003-02-05','Alex','fixed URL construction in support functions ');
INSERT History VALUES('spSQLSupport','2003-02-06','Ani','Removed "en/" from URLs so it will be compatible with all subdirectories (e.g. v4). Updated spSkyServerFunctions to include SPs. Changed "imagingRoot" to "imaging" for image FITS URLs Changed "spectroRoot" to "spectro" for spSpec URLs Changed "1d_10" to "1d_20" for spSpec URLs ');
INSERT History VALUES('spSQLSupport','2003-03-10','Ani','Updated spSkyServerColumns to be same as fDocColumns. ');
INSERT History VALUES('spSQLSupport','2003-11-11','Jim','Added clientIP, access, webserver... to spExecuteSQL revectored spSkyServerFreeFormQuery to call spExecuteSQL  ');
INSERT History VALUES('spSQLSupport','2004-08-31','Alex','changed replacei to fReplace everywhere to conform to naming ');
INSERT History VALUES('spSQLSupport','2004-09-01','Nolan+Alex','added spExecuteSQL2 ');
INSERT History VALUES('spSQLSupport','2005-02-15','Ani','Added check for crawlers limiting them to x queries/min,  SQL code for this provided by Jim. ');
INSERT History VALUES('spSQLSupport','2005-02-18','Ani','Commented out "SET @IOs = ..." line in spExecuteSQL and spExecuteSQL2 because it was cause arithmetic overflow errors on DR3 sites (PR #6367). ');
INSERT History VALUES('spSQLSupport','2005-02-21','Ani','Applied permanent fix for PR #6367 by including casts to bigint for @@TOTAL_READ and @@TOTAL_WRITE. ');
INSERT History VALUES('spSQLSupport','2005-02-25','Ani','Added minute-long window to check whether a given clientIP is submitting more than the max number of queries in spExecuteSQL.  This is to allow legitimate rapid-fire queries like RHL''s skyserver lookup tables to work fine. ');
INSERT History VALUES('spSQLSupport','2006-02-07','Ani','Added syntax check capability in spExecuteSql, and also replaced cr/lf with space/lf so line number can be displayed for syntax errors (see PR #6880). ');
INSERT History VALUES('spSQLSupport','2006-03-10','Ani','Added spLogSqlStatement and spLogSqlPerformance for CasJobs to use. ');
INSERT History VALUES('spSQLSupport','2007-01-01','Alex','separated out spSQLSupport ');
INSERT History VALUES('spSQLSupport','2007-08-27','Ani','Added "system" parameter to spExecuteSQL to allow it to distinuguish queries submitted by CAS tools from user queries.  Without this, system queries often run into the max #queries/min limit. ');
INSERT History VALUES('spSQLSupport','2008-04-21','Ani','Added "maxQueries" parameter to spExecuteSQL so that the client can pass the throttle value to it. ');
INSERT History VALUES('spUrlFitsSupport','2001-11-07','Alex','changed names for fGetFieldsObjects to spGet...  and fGetFiberList to spGetFiberList ');
INSERT History VALUES('spUrlFitsSupport','2001-12-02','Alex','moved Globe table to ZoomTables.sql, now this is functions and procedures only, also fixed bug in spGetFiberList ');
INSERT History VALUES('spUrlFitsSupport','2001-12-08','Jim','moved *Near* functions to *Near* file. ');
INSERT History VALUES('spUrlFitsSupport','2001-12-23','Alex','Added a whole bunch of Url functions, and MagToFlux conversions. ');
INSERT History VALUES('spUrlFitsSupport','2002-07-15','Alex','added or revised 	fGetUrlSpecImg, fGetUrlNavId,fGetUrlNavEq, fGetUrlFitsSpectrum,fGetUrlFitsAtlas, fGetUrlFitsBin, fGetUrlFitsMask,  fGetUrlFitsCFrame, fGetUrlFitsField, ');
INSERT History VALUES('spUrlFitsSupport','2002-07-31','Jim','fixed bug in fMjdToGmt (off by 12 hours). ');
INSERT History VALUES('spUrlFitsSupport','2002-09-14','Jim+Alex+Ani','Moved spatial functions to NearFunctions.sql  ');
INSERT History VALUES('spUrlFitsSupport','2002-09-26','Alex','Commented out fGetFieldsObjects, since there is no specObjID in PhotoObj any more ');
INSERT History VALUES('spUrlFitsSupport','2003-02-05','Alex','fixed URL construction in support functions ');
INSERT History VALUES('spUrlFitsSupport','2003-02-06','Ani','Removed "en/" from URLs so it will be compatible with all subdirectories (e.g. v4). Updated spSkyServerFunctions to include SPs. Changed "imagingRoot" to "imaging" for image FITS URLs Changed "spectroRoot" to "spectro" for spSpec URLs Changed "1d_10" to "1d_20" for spSpec URLs ');
INSERT History VALUES('spUrlFitsSupport','2003-05-15','Alex','switched from PhotoObj to PhotoObjAll ');
INSERT History VALUES('spUrlFitsSupport','2003-06-03','Alex','Changed count(*) to count_big(*) and @@rowcount to rowcount_big(); Moved fMagToFlux* functions to photoTables.sql ');
INSERT History VALUES('spUrlFitsSupport','2003-10-06','Ani','Fixed URL problem with fGetUrlFitsField (PR #5617). ');
INSERT History VALUES('spUrlFitsSupport','2003-12-18','Ani','Fix for PR #5809: str()s for ra,dec in fGetUrl*Eq functions enclosed in ltrim() to remove spaces.  Also changed "1d_20" to "1d_23" for fGetUrlFitsSpectrum. ');
INSERT History VALUES('spUrlFitsSupport','2003-12-19','Ani','Fix for PR #5811 (fGetUrlNavEq). ');
INSERT History VALUES('spUrlFitsSupport','2003-12-22','Ani','Also fixed fGetUrlNavId for same thing as 5811. ');
INSERT History VALUES('spUrlFitsSupport','2004-09-01','Nolan+Alex','added spExecuteSQL2 ');
INSERT History VALUES('spUrlFitsSupport','2005-02-15','Ani','Added check for crawlers limiting them to x queries/min,  SQL code for this provided by Jim. ');
INSERT History VALUES('spUrlFitsSupport','2005-02-18','Ani','Commented out "SET @IOs = ..." line in spExecuteSQL and spExecuteSQL2 because it was cause arithmetic overflow errors on DR3 sites (PR #6367). ');
INSERT History VALUES('spUrlFitsSupport','2005-02-21','Ani','Applied permanent fix for PR #6367 by including casts to bigint for @@TOTAL_READ and @@TOTAL_WRITE. ');
INSERT History VALUES('spUrlFitsSupport','2005-02-25','Ani','Added minute-long window to check whether a given clientIP is submitting more than the max number of queries in spExecuteSQL.  This is to allow legitimate rapid-fire queries like RHL''s skyserver lookup tables to work fine. ');
INSERT History VALUES('spUrlFitsSupport','2005-11-28','Ani','Fix for PR #6496, added a STR before cast to VARCHAR in sec field for fMJDToGMT. ');
INSERT History VALUES('spUrlFitsSupport','2006-03-07','Ani','Added procedure spSetWebServerUrl to set WebServerUrl in SiteConstants. ');
INSERT History VALUES('spUrlFitsSupport','2006-12-27','Alex','separated out the URL and FITS support into  spUrlFitsSupport.sql ');
INSERT History VALUES('spUrlFitsSupport','2006-03-07','Ani','Fix for PR #7342, specobj fits link broken due to change in sp rerun for DR6.  Modified fGetUrlFitsSpectrum to take the rerun# from the PlateX table so this will not break in  the future. ');
INSERT History VALUES('spUrlFitsSupport','2008-08-29','Ani','Fix for PR #7652, DAS URLs for coadd runs not correct in Stripe 82 DB. ');
INSERT History VALUES('spUrlFitsSupport','2008-09-18','Ani','Additional changes for PR #7652. ');
INSERT History VALUES('spUrlFitsSupport','2010-08-24','Ani','Fixed spGetFiberList to use class instead of specClass, and fixed fGetUrlFitsSpectrum to use ANSI SQL syntax amd to use run1d,run2d instead of spRerun. ');
INSERT History VALUES('spUrlFitsSupport','2010-10-28','Naren','Fixed fGetUrlFitsSpectrum to use run1d if run2d is null. ');
INSERT History VALUES('spUrlFitsSupport','2011-02-11','Weaver','Fixed URLs for data.sdss3.org files. ');
INSERT History VALUES('spNeighbor','2004-08-30','Alex','Moved here spNeighbors and spBuildMatchTables ');
INSERT History VALUES('spNeighbor','2004-10-10','Jim+Alex','updated spBuildMatchTables ');
INSERT History VALUES('spNeighbor','2004-10-10','Alex+Jim','Tied into load framework to record messages.  Added code to drop/build indices and foreign keys.  Optimized triple computation.  ');
INSERT History VALUES('spNeighbor','2004-10-12','Jim','fix bug in matchhead computation split spMatchBuild and spMatchBuildMiss. ');
INSERT History VALUES('spNeighbor','2004-10-15','Alex','separated Zone computation into spZoneCreate. ');
INSERT History VALUES('spNeighbor','2004-10-20','Jim','broke spBuildMatchTables into two: spBuildMatch and spMatchBuildMiss.  Improved MatchMiss to use a zone algorithm for orphans Compute Reds using MaskedObject table. ');
INSERT History VALUES('spNeighbor','2004-10-20','Alex','renamed spBuildMatch to spMatchBuild and spMatchBuildTables to spMatchBuildMiss. ');
INSERT History VALUES('spNeighbor','2004-11-11','Jim','bypass foreign key build at end of spBuildMatch. ');
INSERT History VALUES('spNeighbor','2004-11-12','Jim','added run2 to primary key of orphans in spMatchBuildMiss ');
INSERT History VALUES('spNeighbor','2004-11-26','Ani','Added spBuildMatchTables from Jim, need to integrate this with the previous version of match table procs. ');
INSERT History VALUES('spNeighbor','2004-12-03','Ani','Removed spBuildMatchTables - Alex said Jim made a  mistake. 2004-12-04 Alex + Jim:  fixed "red object" computation in spMatchBuildMiss to build a "private" MaskedObjects table that only  shows mask-object pairs where the mask and object  are from different runs.  ');
INSERT History VALUES('spNeighbor','2005-01-21','Ani','Deleted first BEGIN TRANSACTION from spNeighbors since it was unmatched. ');
INSERT History VALUES('spNeighbor','2005-02-01','Alex','changed spMatchBuild to spMatchCreate for consistency, also updated spFinish.  2005-04-09 Jim, Maria:  Fixed two zone problems  (1) type in (0, 3, 5, 6) (2) objID1<objID2 means testing ra1>0 and ra2>0 is wrong ');
INSERT History VALUES('spNeighbor','2005-09-24','Ani','Reinstated commented out code for edges from previous bug fix in spNeighbors. ');
INSERT History VALUES('spNeighbor','2005-10-03','Ani','Bumped up neoghbor search radius for RUNS DB to 10" from 2", because the Match computation is apparently not finding corresponding neighbors.  Also added a check after the insert into Match table for 0 rows inserted which would indicate missing neighbors, so as to avoid an infinite loop of "adding x triples". ');
INSERT History VALUES('spNeighbor','2005-10-11','Ani','Changed all the spMatchBuild references to  spMatchCreate, and added call to spMatchBuildMiss  at the end of spMatchCreate. ');
INSERT History VALUES('spNeighbor','2005-10-11','Ani','Added "OPTION (MAXDOP 1)" for all update statemnents. ');
INSERT History VALUES('spNeighbor','2005-12-14','Jim','Cleaned up margins based on new understanding of  distortion: abs(atan(theta/sqrt(cos(dec-theta)cos(dec+theta))) (1) in spZoneCreate: dropped left margin from zone table and  created #Alpha table and used it to create right margin.  (2) in spNeighbors created #Alpha table and used as bias in  bias test (3) did similar things with orphan handling in spMatchBuildMiss ');
INSERT History VALUES('spNeighbor','2005-12-17','Jim','Added zone check to avoid duplicate hits in in orphan computation. ');
INSERT History VALUES('spNeighbor','2006-10-19','Ani','Moved spMatchBuildMiss definition to before spMatchCreate to avoid dependency error message. ');
INSERT History VALUES('spNeighbor','2006-10-26','Ani','Commented out debug messages from MatchBuildMiss because they were filling up the log (too many of them). ');
INSERT History VALUES('spNeighbor','2007-08-17','Ani','Fixed bug in call to fRegionGetObjectsFromString, it has a column called ''id'' now, not ''objID'' (PR #7365). ');
INSERT History VALUES('spNeighbor','2007-08-23','Ani','Fixed bug in spMatchBuildMiss - replace substring in comment no longer looks for ''CAMCOL'' (PR #7374). ');
INSERT History VALUES('spNeighbor','2007-08-22','Maria','Added input @zoneHeight in spZoneCreate to make independent search radius and zoneHeight. Adds function fGetAlpha. This function corrects the bias computation in spZoneCreate which was missing sin(@theta). ');
INSERT History VALUES('spNeighbor','2007-08-22','Maria','spZoneCreate  Uses SELECT * INTO Zone for the main part of the Zone.  Buffer uses INSERT. This avoids too much logging. Restore 2 arcsec distance match for RunsDB ');
INSERT History VALUES('spNeighbor','2007-08-22','Maria','spNeighbors  Set @zoneHeight = 30" for ''best'' and =15" for ''runs'',''targ'' Uses SELECT * INTO Neighbors for the first half of the computation to avoid logging. Uses the zoneZone table instead of the the WHILE loop ');
INSERT History VALUES('spNeighbor','2007-10-11','Ani','Split up insert into Match table from Neighbors into batched transactions to avoid excessive log size increase (PR #7405). ');
INSERT History VALUES('spNeighbor','2007-10-11','Ani','Also changed ''flags'' to ''miss'' in Match insert. ');
INSERT History VALUES('spNeighbor','2007-10-11','Ani','Fixed minor errors in spMatchCreate. ');
INSERT History VALUES('spNeighbor','2007-10-11','Ani','Removed semicolons in spMatchCreate in Match insert. ');
INSERT History VALUES('spNeighbor','2008-03-21','Ani','Added exclusion of neighbors from different runs unless they are more than 1" apart for RUNS DB. ');
INSERT History VALUES('spNeighbor','2008-04-03','Ani','Added 2 more params to spNeighbors that specify the search radius and match mode, so it can be configured to search for all neighbors in a small radius for the building Match tables. ');
INSERT History VALUES('spNeighbor','2010-12-10','Ani','Removed Match procedures. ');
INSERT History VALUES('spSetValues','2002-11-29','Alex','split off loadversion updates to simplify ');
INSERT History VALUES('spSetValues','2002-12-10','Alex','removed TiledTarget patch ');
INSERT History VALUES('spSetValues','2002-12-10','Alex','removed chunkid patch ');
INSERT History VALUES('spSetValues','2002-12-10','Alex','removed ObjMask patch ');
INSERT History VALUES('spSetValues','2002-12-10','Alex','added test for TargetInfo.targetobjid=0 ');
INSERT History VALUES('spSetValues','2003-05-05','Ani','Changed "reddening" to "extinction" for dered values, as per PR #5277. ');
INSERT History VALUES('spSetValues','2003-05-15','Alex','Changed PhotoObj-> PhotoObjAll ');
INSERT History VALUES('spSetValues','2003-06-03','Alex','Changed count(*) to count_big(*), and @@rowcount  to rowcount_big() ');
INSERT History VALUES('spSetValues','2003-06-13','Adrian','added spTargetInfoTargetObjID  ');
INSERT History VALUES('spSetValues','2003-07-17','Ani','Fixed bug in call to spTargetInfoTargetObjID (PR #5491) - procedure was being called without params taskid and stepid ');
INSERT History VALUES('spSetValues','2003-07-17','Ani','Fixed bug in spTargetInfoTargetObjID (PR #5492), join on PhotoTag replaced with PhotoObjAll, because PhotoTag has not been created at this point ');
INSERT History VALUES('spSetValues','2003-08-15','Ani','Fixed tiling table names as per PRs #5561 and 5565: Tile -> TileAll TiledTarget -> TiledTargetAll TileRegion -> TilingRun TileBoundary -> TilingGeometry TileInfo -> TilingInfo ');
INSERT History VALUES('spSetValues','2004-08-27','Alex','added spFillMaskedObject and spSetInsideMask ');
INSERT History VALUES('spSetValues','2004-08-30','Alex+Ani','moved spFillMaskedObject into spSetValues ');
INSERT History VALUES('spSetValues','2004-11-11','Alex','repointed spNewPhase, spStartStep and spEndStep to  local wrappers ');
INSERT History VALUES('spSetValues','2004-11-14','Jim','added spSectorFillBest2Sector  ');
INSERT History VALUES('spSetValues','2004-11-22','Alex','changed flag to 32 in spFillMaskedObject for PhotoObjAll. ');
INSERT History VALUES('spSetValues','2004-12-03','Alex+Jim','changed spFillMaskedObject to take only those PhotoObj which are in the same field as the Mask. Also left maskType in MaskedObject as it is an Mask, and only  raise to 2^m in spSetInsideMask. ');
INSERT History VALUES('spSetValues','2004-12-09','Jim+Alex','set the test in spFillMaskedObject to be ==  pattern, not != pattern ');
INSERT History VALUES('spSetValues','2005-01-06','Ani','Added creation of PhotoObjAll.htmID index to spFillMaskedObject to speed it up. ');
INSERT History VALUES('spSetValues','2005-02-04','Alex','Updated spSectorFillBest2Sector  ');
INSERT History VALUES('spSetValues','2005-04-15','Jim','removed comment on 	DROP TABLE BestTargetTable in spSectorFillBestToSector ');
INSERT History VALUES('spSetValues','2005-05-17','Alex','moved spSectorFillBestToSector to spSector.sql ');
INSERT History VALUES('spSetValues','2005-09-13','Ani','Fixed bugs in spSetInsideMask as per Tamas and Jim''s changes (PR #6609). ');
INSERT History VALUES('spSetValues','2007-04-18','Ani','Added code to spSetValues to set RA,dec errors and  galactic coordinates (PR #7267). ');
INSERT History VALUES('spSetValues','2007-08-17','Ani','Fixed bug in call to fRegionGetObjectsFromString, it has a column called ''id'' now, not ''objID'' (PR #7365). ');
INSERT History VALUES('spSetValues','2007-12-13','Svetlana','added option (maxdop 1) for UPDATE-stmt in  spSetInsideMask. ');
INSERT History VALUES('spSetValues','2007-12-19','Ani','Fixed call to fRegionGetObjectsFromString in  spFillMaskedObject to add "J2000" to area string (fix for PR #7458). ');
INSERT History VALUES('spSetValues','2008-08-06','Ani','Added spSetPhotoClean to set clean flag value in Photo tables (PR #7401). ');
INSERT History VALUES('spSetValues','2008-09-18','Ani','Moved ra/dec error computation to new SP spComputeRaDecErr. ');
INSERT History VALUES('spSetValues','2009-05-05','Ani','Removed spComputeRaDecErr for SDSS-III and removed  references to nonexistent tables in spLoadVersion. ');
INSERT History VALUES('spSetValues','2009-07-10','Ani','Added computation of PhotoObjAll htmID to spSetValues.  ');
INSERT History VALUES('spSetValues','2009-08-12','Ani','Updated names of tiling tables for SDSS-III. ');
INSERT History VALUES('spSetValues','2009-10-30','Ani','Added cases to spSetValues for plates and sspp. ');
INSERT History VALUES('spSetValues','2009-11-10','Ani','Commented out ugriz and Err_ugriz code in the simplified magnitudes section of spSetValues.  Updated log messages. ');
INSERT History VALUES('spSetValues','2009-12-23','Ani','Removed code to set sppLines.specObjId and sppParams.specObjId for sspp. ');
INSERT History VALUES('spSetValues','2010-01-13','Victor','Updated Table name ''ObjMask'' to ''AtlasOutline'' ');
INSERT History VALUES('spSetValues','2010-08-03','Ani','Removed sppTargets.objID setting from spSetValues. ');
INSERT History VALUES('spSetValues','2010-11-10','Naren','Removed cast of AtlasOutline.span to varchar(1000) in spSetValues - it is varchar(max) now. ');
INSERT History VALUES('spSetValues','2010-11-22','Ani','Removed reference to HoleObj in spSetLoadversion. ');
INSERT History VALUES('spSetValues','2010-12-23','Ani','Added PlateX.htmid setting to spSetValues. ');
INSERT History VALUES('spValidate','2002-10-29','Jim','split spValidate and spFinish  (finish does neighbors and photo-spectro matchup). removed references to sdssdr1. ');
INSERT History VALUES('spValidate','2002-11-02','Jim','sped up by creating indexes for unique test. left keys/indices in place on the theory that they do not hurt. 2002-11-07   Jim change to specLineAll ');
INSERT History VALUES('spValidate','2002-11-10','Jim','added test of frame zoom levels (commentend out for now) ');
INSERT History VALUES('spValidate','2002-11-22','Jim','added remaining Unique Key tests ');
INSERT History VALUES('spValidate','2002-11-13','Alex','fixed bug in TargetInfo PK test, insert Jim''s Mask validation ');
INSERT History VALUES('spValidate','2002-11-30','Jim','recover from lost file added many tile key and foreign key tests ');
INSERT History VALUES('spValidate','2003-01-27','Ani','Made changes to tiling schema as per PR# 4702: renamed TileRegion to TilingRegion renamed TileInfo to TilingInfo renamed TileNotes to TilingNotes renamed TileBoundary to TilingGeometry change the primary key of TilingInfo from (tileRun,tid) to (tileRun,targetID) ');
INSERT History VALUES('spValidate','2003-05-15','Alex','Changed PhotoObj-> PhotoObjAll ');
INSERT History VALUES('spValidate','2003-06-03','Alex','Changed some of the count(*) to count_big(*), @@rowcount to rowcount_big() ');
INSERT History VALUES('spValidate','2003-07-15','Ani','Fixed typo in TargetParam unique key test (PR #5490) - changed paramName to name. ');
INSERT History VALUES('spValidate','2003-08-14','Ani','Fixed tiling table names/columns as per PR #5561: Tile -> TileAll TiledTarget -> TiledTargetAll TilingRegion -> TilingRun TilingNotes ->TilingNote TilingNotes.tileNoteID -> TilingNote.tilingNoteID TileBoundary.tileBoundID -> TilingGeometry.tilingGeometryID ');
INSERT History VALUES('spValidate','2003-12-04','Jim','for SQL best practices put an ORDER BY in the  SELECT TOP 100 ... of spTestPhotoParentID put FOR UPDATE clause in PhotoCusror of spValidate ');
INSERT History VALUES('spValidate','2004-02-13','Ani','Replaced fHTM_Lookup with fHTMLookup. ');
INSERT History VALUES('spValidate','2004-11-11','Alex','repointed spNewPhase, spStartStep and spEndStep to  local wrappers ');
INSERT History VALUES('spValidate','2005-01-06','Ani','Fixed fHtmLookup call in spTestHtm to drop ''L''  in level number, i.e. changes ''J2000 L20 ...'' to ''J2000 20 ...''. ');
INSERT History VALUES('spValidate','2005-12-13','Ani','Commented out Photoz table, not loaded any more. ');
INSERT History VALUES('spValidate','2006-10-19','Ani','Replaced group by on ValidatorParents.objID with one on kid.parentID in spTestPhotoParentID to avoid sql2k5 error. ');
INSERT History VALUES('spValidate','2007-01-03','Ani','Replaced call to fHtmLookup with fHtmEq in spTestHtm. ');
INSERT History VALUES('spValidate','2007-01-05','Ani','Fixed bug in call to fHtmEq in spTestHtm. ');
INSERT History VALUES('spValidate','2007-05-15','Ani','Made zoom levels check conditional (only do it if not RUNS DB. ');
INSERT History VALUES('spValidate','2009-05-18','Ani','Deleted tables phased out for SDSS-III. ');
INSERT History VALUES('spValidate','2009-06-14','Ani','Removed HTM tests from photo/spectro validation. ');
INSERT History VALUES('spValidate','2009-07-09','Ani','Deleted HTMID test in spValidatePhoto, changed  Field.nObjects check to Field.nTotal, commented out zoom levels check. ');
INSERT History VALUES('spValidate','2009-08-12','Ani','Updated names of tiling tables for SDSS-III and removed TilingNote. ');
INSERT History VALUES('spValidate','2009-10-30','Ani','Added call to spValidateSspp, and added unique key tests to spValidateSspp. ');
INSERT History VALUES('spValidate','2009-12-31','Ani','Added spValidateGalSpec for galspec export. ');
INSERT History VALUES('spValidate','2010-01-14','Ani','Replaced ObjMask with AtlasOutline. ');
INSERT History VALUES('spValidate','2010-10-20','Ani','Removed discontinued spectro tables from validation. ');
INSERT History VALUES('spValidate','2010-11-23','Ani','Added spValidatePm and spValidateResolve. ');
INSERT History VALUES('spValidate','2010-12-08','Ani','Added segueTargetAll.objid uniqueness test to  spValidateSspp. ');
INSERT History VALUES('spPublish','2002-11-08','Jim','added INIT clause to backup ');
INSERT History VALUES('spPublish','2002-11-10','Jim','commented out detach, reserved DONE status for the end of the step. added spPublishTiling, changed spPublish to spPublishStep, add insert to load history ');
INSERT History VALUES('spPublish','2002-11-13','Jim','fixed transaction scope bug in CopyTable ');
INSERT History VALUES('spPublish','2002-11-14','Jim','added to spPublishPhoto Mask,MosaicLayout,Mosaic,ObjMask, Target,TargetInfo.  Added to spPublishPlate Best2Sector, HoleObj, Sector, Sector2Tile,Target2Sector Added to spPublishTiling TargetParam, TiBound2tsChunk, Tile, TileBoundary, TiledTarget, TileInfo, TileNotes (commented out right now for IDENTITY problem) TileRegion, TilingPlan. ');
INSERT History VALUES('spPublish','2002-11-30','Alex','added spReorg  ');
INSERT History VALUES('spPublish','2002-12-28','Alex','added publish log into PubHistory ');
INSERT History VALUES('spPublish','2003-01-27','Ani','Made changes to tiling schema as per PR# 4702 renamed TileRegion to TilingRegion renamed TileInfo to TilingInfo renamed TileNotes to TilingNotes renamed TileBoundary to TilingGeometry ');
INSERT History VALUES('spPublish','2003-05-15','Alex','changed PhotoObj to PhotoObjAll ');
INSERT History VALUES('spPublish','2003-06-03','Alex','Changed @@rowcount to rowcount_big() ');
INSERT History VALUES('spPublish','2003-08-14','Ani','Fixed tablenames in spPublishTiling as per PR #5561. ');
INSERT History VALUES('spPublish','2003-08-15','Ani','Made @fromDB, @toDB in spPublishStep to varchar(100) as per PR #5564. ');
INSERT History VALUES('spPublish','2003-09-22','Ani','Moved publish of TilingRun table to the top so that foreign-key constraints for other tiling tables would not be an issue (PR #5675). ');
INSERT History VALUES('spPublish','2004-08-31','Alex','Moved here spBackupStep and spCleanupStep ');
INSERT History VALUES('spPublish','2004-11-11','Alex','repointed spNewPhase, spStartStep and spEndStep to local wrappers ');
INSERT History VALUES('spPublish','2005-12-13','Ani','Commented out Photoz table, not loaded any more. ');
INSERT History VALUES('spPublish','2007-12-11','Svetlana','added comments in spPublishStep do not rebuild the filenames before attaching the db. ');
INSERT History VALUES('spPublish','2008-06-16','Ani','Added PsObjAll to spPublishPhoto. ');
INSERT History VALUES('spPublish','2009-08-12','Ani','SDSS-III changes: Deleted PsObjAll, USNO, Rosat, added Run to spPublishPhoto.  Renamed tiling table names in spPublishTiling, and added spPublishWindow to publish window task dbs. ');
INSERT History VALUES('spPublish','2009-08-31','Victor','Added spPublishSspp to publish window task dbs. ');
INSERT History VALUES('spPublish','2009-10-30','Ani','Added call to spPublishSspp iin spPublishStep, and corrected sspp table names in spPublishSspp. ');
INSERT History VALUES('spPublish','2009-12-31','Ani','Added spPublishGalSpec for galspec export. ');
INSERT History VALUES('spPublish','2010-01-14','Ani','Replaced ObjMask with AtlasOutline. ');
INSERT History VALUES('spPublish','2010-01-16','Ani','Removed publishing of Segment table. 2010-06-29  Ani/Naren/Vamsi: Added External Catalog Tables to spPublishPhoto. ');
INSERT History VALUES('spPublish','2010-07-14','Ani','Fixed names for TwoMASS and TwoMASSXSC (from 2MASS, 2MASSXSC). ');
INSERT History VALUES('spPublish','2010-11-23','Ani','Added spPublishPm and spPublishResolve. ');
INSERT History VALUES('spPublish','2010-12-08','Ani','Added sdssTargetParam to spPublishTiling, and added Plate2Target, segueTargetAll to spPublishSspp. ');
INSERT History VALUES('spFinish','2002-10-29','Jim','split spValidate and spFinish  (finish does neighbors and photo-spectro matchup). removed references to sdssdr1. ');
INSERT History VALUES('spFinish','2002-11-25','Jim','added index build ');
INSERT History VALUES('spFinish','2002-12-01','Jim','support *-pub types in spNeighbors ');
INSERT History VALUES('spFinish','2002-12-03','Jim','added copy target, targetInfo to spFinishPlates and set SpecObjAll.SciencePrimary ');
INSERT History VALUES('spFinish','2002-12-08','Alex','added spDropIndexAll before creating all indices ');
INSERT History VALUES('spFinish','2003-01-28','Alex','eliminated the redundant spFinishPhoto ');
INSERT History VALUES('spFinish','2003-01-28','Alex','changed spFinishPlates to spSynchronize ');
INSERT History VALUES('spFinish','2003-01-29','Jim','fixed bug in negative dec (should be cos(abs(dec))) fixed bug in native flag of zone (was always 1) this should fix the non-unique neighbors bug. ');
INSERT History VALUES('spFinish','2003-02-04','Alex','fixed a bug in SpectroPhotoMatch, the update of PhotoObj had an incorrect join, should be P.objid=PS.PhotoObjId ');
INSERT History VALUES('spFinish','2003-05-15','Alex','changed some of the occurrences of PhotoObj to PhotoObjAll ');
INSERT History VALUES('spFinish','2003-05-15','Alex','changed neighborObjType to neighborType, etc. ');
INSERT History VALUES('spFinish','2003-05-25','Alex','changed zone table to select only mode=(1,2) and  type=(3,5,6). ');
INSERT History VALUES('spFinish','2003-05-26','Jim','only right margin needed in neighbor computation added code to drop Neighbor/Zone indices if they exist added spBuildMatchTables modified spFinish to call spBuildMatchTables if it is a BEST database. modified neighbors code to use spBuildIndex ');
INSERT History VALUES('spFinish','2003-06-03','Alex','changed count(*) to count_big(*), and @@rowcount to rowcount_big() ');
INSERT History VALUES('spFinish','2003-06-06','Alex+Adrian','added spMatchTargetBest, updated  spSpectroPhotoMatch, added spBuildSpecPhotoAll ');
INSERT History VALUES('spFinish','2003-06-13','Adrian','updated assignments of sciencePrimary ');
INSERT History VALUES('spFinish','2003-06-13','Adrian','added fGetNearbyTiledTargetsEq and  spTiledTargetDuplicates ');
INSERT History VALUES('spFinish','2003-08-18','Ani','added truncation of Match/MatchHead tables to spBuildMatchTables (see PRs 5571, 5572). ');
INSERT History VALUES('spFinish','2003-08-19','Ani','Removed "distinct" from select in MatchHead table update, to fix PR #5592 (matchCount not being set). ');
INSERT History VALUES('spFinish','2003-08-20','Ani','Added spLoadPhotoTag to populate PhotoTag table (PR #5573). ');
INSERT History VALUES('spFinish','2003-08-20','Ani','Added RegionsSectorsWedges to do regions, sectors and wedges computation (PR #5588). ');
INSERT History VALUES('spFinish','2003-08-21','Ani','Fixed bugs in spLoadPhotoTag. ');
INSERT History VALUES('spFinish','2003-09-23','Ani','Added FINISH group index creation (PR #5677) ');
INSERT History VALUES('spFinish','2003-10-12','Ani','Added call to spBuildSpecPhotoAll (PR #5698) ');
INSERT History VALUES('spFinish','2004-01-16','Ani','Fixed bugs in spRegionsSectorsWedges (#tile creation). ');
INSERT History VALUES('spFinish','2004-01-22','Ani','Fixed bug in TiledTargetDuplicates code (PR #) -  removed refs to bestdr1 from spTiledTargetDuplicates and replaced fHTM_Cover call in fGetNearbyTiledTargetsEq by fHTMCover (HTM v2). ');
INSERT History VALUES('spFinish','2004-02-12','Ani','Added @err to spRegionsSectorsWedges to track errors. ');
INSERT History VALUES('spFinish','2004-08-27','Alex','Added spTableCopy, written by Jim ');
INSERT History VALUES('spFinish','2004-08-30','Alex','removed spRegionsSectorsWedges, now done in spSector, also moved spBuildMatchTables and spNeighbors to spNeighbor.sql. ');
INSERT History VALUES('spFinish','2004-09-10','Alex','changed the calls to spBuildPrimaryKeys and  spBuildForeignKeys to spBuildIndex. Then changed the call from spBuildIndex to spIndexBuild ');
INSERT History VALUES('spFinish','2004-09-17','Alex','changed spIndexBuild to spIndexBuildSelection ');
INSERT History VALUES('spFinish','2004-09-20','Alex','added spRunSQLScript and spLoadMetadata  ');
INSERT History VALUES('spFinish','2004-10-11','Alex','repointed spNewPhase, spStartStep and spEndStep to local wrappers ');
INSERT History VALUES('spFinish','2004-11-08','Ani','Added spRemoveTaskPhoto and spRemoveTaskFromTable, to back out a given chunk. ');
INSERT History VALUES('spFinish','2004-12-05','Ani','Added spLoadScienceTables to load RC3, Stetson etc. ');
INSERT History VALUES('spFinish','2005-01-15','Ani','Put the match tables and sectors back in with calls to new procedures spMatchBuild and spSectorCreate. ');
INSERT History VALUES('spFinish','2005-01-17','Ani','Commented out update statistics call - it''s giving an error (can''t upd stats inside multiple transactions), and changed spDone to loadsupport.dbo.spDone (no spDone proc in pub dbs). ');
INSERT History VALUES('spFinish','2005-01-21','Ani','Made @counts an output param in spTiledTargetDuplicates so spSynchronize can print how many duplicates were found. Fixed HTM CIRCLE call in fGetNearbyTiledTargetsEq to drop  the L before the level number. Also updated spLoadScienceTables to truncate RC3 and Stetson before reloading them, and removed setting RC3.objid to matching photoobj objid (RC3.objid is RC3 seq number). Call to spFinishDropIndices had last 2 parameters missing. Finally, set Target.bestObjID to 0 in spSynchronize so that  spMatchTargetBest will later set the bestObjID. ');
INSERT History VALUES('spFinish','2005-01-22','Ani','Added FirstRow=2 for Stetson bulk insert in spLoadScienceTables. ');
INSERT History VALUES('spFinish','2005-02-01','Alex','changed spMatchBuild to spMatchCreate ');
INSERT History VALUES('spFinish','2005-02-06','Ani','Modified spSyncSchema to take list of schena files from schema/sql/xsyncschema.txt, and added call to spSyncSchema in spFinishStep.  Also added spLoadPatches and corresponding call in spFinishStep to apply patches piled up during the loading process. ');
INSERT History VALUES('spFinish','2005-03-17','Ani','Updated spLoadMetaData to work with taskid=0 and enforced order F,I,K of index dropping to ensure success. ');
INSERT History VALUES('spFinish','2005-03-18','Ani','Fixed bug in spSyncSchema (deleted @isPartitioned reference). ');
INSERT History VALUES('spFinish','2005-03-25','Ani','Modified spFinishDropIndices to call  spIndexDropSelection instead of spDropIndexAll. ');
INSERT History VALUES('spFinish','2005-04-12','Jim','Modified spMatchTargetBest to  set Target.specObjID from SpecObj.targetID ');
INSERT History VALUES('spFinish','2005-05-02','Ani','Added spRemoveTaskSpectro and spRemovePlate to back out spectro data (see PR #6444). ');
INSERT History VALUES('spFinish','2005-05-10','Ani','Modified spLoadPatches to make the failure to load/find the patch file a warning, not an error. ');
INSERT History VALUES('spFinish','2005-05-18','Ani','Added call to spSectorSetTargetRegionID in spFinishStep. ');
INSERT History VALUES('spFinish','2005-05-24','Ani','Added spRemovePlateList to delete list of plates from a CSV file. ');
INSERT History VALUES('spFinish','2005-05-25','Ani','Updated spRemovePlateList to drop tables in case of error so it can be run repeatedly. ');
INSERT History VALUES('spFinish','2005-05-31','Ani','Fixed small bug in spFinishStep that was causing it to skip past builPrimaryKeys step when invoked for that step. ');
INSERT History VALUES('spFinish','2005-06-04','Ani','Changed spFinishPlate messages to spSynchronize. ');
INSERT History VALUES('spFinish','2005-06-09','Ani','Added RUNS-PUB check where applicable to FINISH steps will also be executed for RUNS finish. ');
INSERT History VALUES('spFinish','2005-08-09','Ani','Created spSetVersion to set a DB''s version info. ');
INSERT History VALUES('spFinish','2005-09-13','Ani','Added spRunPatch to formalize patch application. ');
INSERT History VALUES('spFinish','2005-09-19','Ani','Added truncation of Match/MatchHead tables before  rebuilding foreign keys for complete FINISH rerun, so ALTER TABLE conflicts would be avoided.  ');
INSERT History VALUES('spFinish','2005-09-22','Ani','Changed nextReleasePatches.sql dir to the patches directory instead of the sql directory because it causes duplicate entries in the metadata loading scripts. ');
INSERT History VALUES('spFinish','2005-10-05','Ani','Updated FINISH step start message in spFinishStep to indicate if it is run in single-step or resume mode, and which step it it starting on. ');
INSERT History VALUES('spFinish','2005-10-08','Ani','Added "OPTION (MAXDOP 1)" for all update and delete operations to ensure max degree of  parallelism is  set to 1. ');
INSERT History VALUES('spFinish','2005-10-09','Ani','Fixed problem with specobjids not getting set in PhotoTag/PhotoObjAll after spectrophotomatch  during incremental load (PR #6631). ');
INSERT History VALUES('spFinish','2005-10-10','Ani','Cloned spCreateWeblogDB from spLoadPatches and  added call to it in spFinishStep so Weblog DB will be automatically created if it doesnt exist. Also modified spRunSqlScript to take two optional parameters - dbname and logname - for the DB on which to run the script and the log file to send output to. ');
INSERT History VALUES('spFinish','2005-10-10','Ani','Kludged spFinishDropIndices to look for the string "DROP_PK_INDICES" in the FINISH task comment field before dropping PK indices, otherwise PK indices are not dropped. ');
INSERT History VALUES('spFinish','2005-10-13','Ani','Made PhotoTag load incremental also and changed comment that causes campaign load to be ''CAMPAIGN LOAD''. ');
INSERT History VALUES('spFinish','2005-10-15','Ani','Truncated filegroupmap in spFinishDropIndices if sysfilegroups has only primary filegroup. This is to prevent index creation from barfing on invalid filegroups. ');
INSERT History VALUES('spFinish','2005-10-21','Ani','Moved filegroupmap truncation to spFinishStep. ');
INSERT History VALUES('spFinish','2005-10-22','Ani','Moved spLoadPatches call after spSyncSchema in spFinishStep. ');
INSERT History VALUES('spFinish','2005-10-22','Ani','Added parameter to spLoadMetadata to make index dropping and recreation optional, since this is not needed if FINISH is started at the beginning. ');
INSERT History VALUES('spFinish','2005-12-02','Ani','Added step to spFinishStep to do the masks. ');
INSERT History VALUES('spFinish','2005-12-05','Ani','Fixed bug in spFinishStep that caused it to start at the beginning (drop indices!) even if an  invalid phase name was specified (PR #6795). ');
INSERT History VALUES('spFinish','2005-12-07','Ani','Updated spFinishStep to delete Target/TargetInfo tables only in case of campaign load or full finish, and made Target/TargetInfo incremental in spSynchronize. ');
INSERT History VALUES('spFinish','2005-12-09','Ani','Added spFixTargetVersion to correct targetVersion in TilingGeometry (PR #6799) and call to it in sectors section of spFinishStep. ');
INSERT History VALUES('spFinish','2006-01-06','Ani','Added call to spSectorFillBest2Sector in spFinishStep. ');
INSERT History VALUES('spFinish','2006-01-18','Ani','Created wrapper for sector routines, spSectors. ');
INSERT History VALUES('spFinish','2006-06-19','Ani','Fixed bug in spSectors (@ret declare missing). ');
INSERT History VALUES('spFinish','2006-06-19','Ani','Added call to spUpdateStatistics in spSetVersion. ');
INSERT History VALUES('spFinish','2006-06-19','Ani','Added CAS, DAS URL params to spSetVersion. ');
INSERT History VALUES('spFinish','2006-06-20','Ani','Added calls to spCheckDB procs in spSetVersion. ');
INSERT History VALUES('spFinish','2006-07-12','Ani','Added calls to diagnostics procs in spRunPatch. ');
INSERT History VALUES('spFinish','2006-08-01','Ani','Added TargPhotoObjAll update to spSynchronize  (PR #6866). ');
INSERT History VALUES('spFinish','2006-08-18','Ani','Corrected typo in spFinishStep - @phasName instead @phaseName (fix for PR #7053). ');
INSERT History VALUES('spFinish','2006-09-28','Ani','Flipped the order of match tables and sectors steps (fix for PR #7122). ');
INSERT History VALUES('spFinish','2006-12-13','Ani','Changed spSyncSchema to load different list of schema files for TARG DB, since the TARG DB doesn''t have the schema updates for DR6 and beyond. ');
INSERT History VALUES('spFinish','2006-12-13','Ani','Added command to set DB compatibility level to 2k5, so cross apply works properly. ');
INSERT History VALUES('spFinish','2006-12-14','Ani','Fixed bug in spSyncSchema change to read in  different list of schema files for TARG DB. 2006-12-18 Yanny/Svetlana: moving sp_dbcmptlevel @dbName, 90  to outside of procedure. ');
INSERT History VALUES('spFinish','2007-01-02','Ani','Changed Match pk to ObjID1 from ObjID and added a call to spRemoveTaskFromTable for Match.ObjID2 in spRemoveTaskPhoto. ');
INSERT History VALUES('spFinish','2007-01-02','Ani','Added check for BEST-PUB to matchTargetBest and insideMask steps, they should not be done for TARG and RUNS DBs. ');
INSERT History VALUES('spFinish','2007-01-03','Ani','Fixed typos in spSyncSchema related to @targ. ');
INSERT History VALUES('spFinish','2007-01-04','Ani','Swapped the actual order of code for steps regionsSectorsWedges and buildMatchTables, this was a bug in PR #7122 fix (thanks, Svetlana!). ');
INSERT History VALUES('spFinish','2007-01-17','Ani','Made foreign key deletion for the metadata tables  mandatory (not dependent on @dropIndices param) in spLoadMetaData. ');
INSERT History VALUES('spFinish','2007-01-17','Ani','Undid above change, instead made spSyncSchema call spLoadMetadata with @dropIndices = 1 to force dropping and recreation of all META indices. ');
INSERT History VALUES('spFinish','2007-06-04','Ani','Applied Svetlana''s change to fGetNearbyTiledTargetsEq to increase STR length for r. ');
INSERT History VALUES('spFinish','2007-06-10','Ani','Changed fHtmCover to fHtmCoverRegion. ');
INSERT History VALUES('spFinish','2008-04-03','Ani','Broke up neighbors computation into 2 steps for RUNSDB - first do a 2" neighbors so Match tables can be built, then do 10" neighbors after the Match tables are built but exclude self-matches. ');
INSERT History VALUES('spFinish','2008-08-06','Ani','Added call to spSetPhotoClean to set the clean  photometry flag in spFinishStep (PR #7401). ');
INSERT History VALUES('spFinish','2009-08-14','Ani','Changes for SDSS-III: changed targetId to targetObjId where applicable, removed setting of specObjALL.targetObjId from spSynchronize; deleted status, primTarget and secTarget from spLoadPhotoTag (columns no longer in PhotoObjAll). ');
INSERT History VALUES('spFinish','2010-01-14','Ani','Replaced ObjMask with AtlasOutline. ');
INSERT History VALUES('spFinish','2010-01-19','Ani','Replaced spSectors with spSdssPolygonRegions to create polygon regions for the main surveu in SDSS-III. ');
INSERT History VALUES('spFinish','2010-02-10','Ani','Cloned spSegue2SpectroPhotoMatch from spSpectroPhotoMatch. This will be used to match SEGUE2 spectra to BestDR7  photometry but won''t be part of regular FINISH processing. ');
INSERT History VALUES('spFinish','2010-08-18','Ani','Deleted spSpectroPhotoMatch. ');
INSERT History VALUES('spFinish','2010-11-29','Ani','Deleted outdated steps in spFinishStep. ');
INSERT History VALUES('spFinish','2010-12-02','Ani','Replaced SpecPhotoAll schema with updated one from  Mike Blanton. ');
INSERT History VALUES('spFinish','2010-12-02','Ani','Removed specObjAll.tileID from SpecPhotoAll schema. ');
INSERT History VALUES('spFinish','2010-12-09','Ani','Removed Algorithms, Glossary and TableDesc from spLoadMetadata. ');
INSERT History VALUES('spFinish','2010-12-11','Ani','Updated spSetVersion for SDSS-III. ');
INSERT History VALUES('spFinish','2010-12-11','Ani','Updated fGetNearbyTiledTargetsEq as per Deoyani/Alex. ');
INSERT History VALUES('spFinish','2011-01-04','Ani','Removed code at top setting SQL compatibility level to 90 (SQL 2005).  ');
INSERT History VALUES('spFinish','2011-02-11','Ani','Fixed DataServerUrl value in SiteConstants. ');
INSERT History VALUES('spCopyDbSubset','2004-09-15','Jim','copy all of TilingGeometry, TilingRun, and TileAll so region code works  2004-10-07 Alex, Jim: DR3 starting ');
INSERT History VALUES('spCopyDbSubset','2004-11-15','Jim','parameterized it  ');
INSERT History VALUES('spCopyDbSubset','2005-01-28','Jim','BestTarget2Sector replaces Best2Sector. ');
INSERT History VALUES('spCopyDbSubset','2005-02-01','Jim','Parameterized spCopyDbSimpleTable to allow incrementalcopy  based on primary key.  This prevents log explosion and  opens the door for restartable copies Also fixed spCopyDbSubset to use it on PhotoObj, PhotoTag, PhotoProfile and Frame tables ');
INSERT History VALUES('spCopyDbSubset','2005-02-02','Jim','Fixed spCopyDbSimple "partition-key bug" where key is just a prefix of primary key.  added batch size parmeter to spCopyDbSimple connected the logging to Task/Step/Phase LoadSupport trace mechanism. ');
INSERT History VALUES('spCopyDbSubset','2005-02-16','Jim','Converted to CreatePartDB2 Added copy of RC3 and Stetson ');
INSERT History VALUES('spCopyDbSubset','2005-02-21','Jim','Copy ALL Stetson and RC3 (no subsetting) ');
INSERT History VALUES('spCopyDbSubset','2005-03-15','Jim','Fixed "bubble sort" bug in incremental spCopyTable (target table has no index so need to use source table.  ');
INSERT History VALUES('spCopyDbSubset','2005-04-09','Jim','Changed spCopyDbSubset()  to shrink truncate-only (not move pages) .  ');
INSERT History VALUES('spCopyDbSubset','2006-01-28','Jim','Changed spCopyDbSubset()  to create primary keys early so DB is organized (saves time & space). ');
INSERT History VALUES('spCopyDbSubset','2006-02-01','Jim','Added copy of Glossary, Algorithm, TableDesc, PhotoAuxAll,USNOB   ');
INSERT History VALUES('spCopyDbSubset','2006-05-10','Jim','Added copy of PhotoAuxAll, PhotoZ2, USNOB -> ProperMotions QsoBunch, QsoConcordanceAll, QsoCatalotAll, QsoBest, QsoTarget, QsoSpec TargRunQA ');
INSERT History VALUES('spCopyDbSubset','2010-01-14','Ani','Replaced ObjMask with AtlasOutline. ');
INSERT History VALUES('spCosmology','2008-10-30','Ani','Incorporated into sqlLoader2k5. ');
INSERT History VALUES('spCosmology','2008-11-07','Ani','Updated with latest version from Manu  (distance modulus function added too). ');
INSERT History VALUES('spCosmology','2010-08-24','Ani','Deleted actualy assembly binary string from commented out ALTER ASSEMBLY command.  This was causing an error in loader. ');
GO

------------------------------------
PRINT '876 lines inserted into History'
------------------------------------
GO

-- Reload Dependency table
TRUNCATE TABLE Dependency
GO
--

INSERT Dependency VALUES('ConstantSupport','fPhotoDescription','fPhotoFlagsN');
INSERT Dependency VALUES('ConstantSupport','fPhotoDescription','fPhotoStatusN');
INSERT Dependency VALUES('ConstantSupport','fSpecDescription','fSpecClassN');
INSERT Dependency VALUES('ConstantSupport','fSpecDescription','fSpecZStatusN');
INSERT Dependency VALUES('ConstantSupport','fSpecDescription','fSpecZWarningN');
INSERT Dependency VALUES('FrameTables','spComputeFrameHTM','fEqFromMuNu');
INSERT Dependency VALUES('FrameTables','spComputeFrameHTM','fHtmXyz');
INSERT Dependency VALUES('FrameTables','spComputeFrameHTM','fMuNuFromEq');
INSERT Dependency VALUES('FrameTables','spMakeFrame','fTileFileName');
INSERT Dependency VALUES('IndexMap','spDropIndexAll','spIndexDrop');
INSERT Dependency VALUES('IndexMap','spEndStep','spEndStep');
INSERT Dependency VALUES('IndexMap','spEndStep','spNewPhase');
INSERT Dependency VALUES('IndexMap','spIndexBuildList','spIndexCreate');
INSERT Dependency VALUES('IndexMap','spIndexBuildSelection','spIndexBuildList');
INSERT Dependency VALUES('IndexMap','spIndexCreate','fIndexName');
INSERT Dependency VALUES('IndexMap','spIndexCreate','spNewPhase');
INSERT Dependency VALUES('IndexMap','spIndexDropList','fIndexName');
INSERT Dependency VALUES('IndexMap','spIndexDropList','spNewPhase');
INSERT Dependency VALUES('IndexMap','spIndexDropSelection','spIndexDropList');
INSERT Dependency VALUES('IndexMap','spNewPhase','spNewPhase');
INSERT Dependency VALUES('IndexMap','spStartStep','spNewPhase');
INSERT Dependency VALUES('IndexMap','spStartStep','spStartStep');
INSERT Dependency VALUES('spCheckDB','spCheckDBIndexes','fIndexName');
INSERT Dependency VALUES('spCheckDB','spCompareChecksum','fGetDiagChecksum');
INSERT Dependency VALUES('spCheckDB','spUpdateSkyServerCrossCheck','fGetDiagChecksum');
INSERT Dependency VALUES('spCoordinate','fEtaToNormal','fRotateV3');
INSERT Dependency VALUES('spCoordinate','fGetLat','fRotateV3');
INSERT Dependency VALUES('spCoordinate','fGetLon','fRotateV3');
INSERT Dependency VALUES('spCoordinate','fGetLonLat','fRotateV3');
INSERT Dependency VALUES('spCoordinate','fStripeToNormal','fRotateV3');
INSERT Dependency VALUES('spCoordinate','spBuildRmatrix','spTransposeRmatrix');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSimpleTable','spNewPhase');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSubset','spCopyDbSimpleTable');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSubset','spCreatePartDB2');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSubset','spDone');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSubset','spEndStep');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSubset','spIndexBuildSelection');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSubset','spNewPhase');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSubset','spNewStep');
INSERT Dependency VALUES('spCopyDbSubset','spCopyDbSubset','spNewTask');
INSERT Dependency VALUES('spCosmology','fCosmoDistanceModulus','fCosmoDl');
INSERT Dependency VALUES('spDocSupport','fEnum','fn_varbintohexstr');
INSERT Dependency VALUES('spDocSupport','spDocEnum','fEnum');
INSERT Dependency VALUES('spFinish','fGetNearbyTiledTargetsEq','fHTMCoverRegion');
INSERT Dependency VALUES('spFinish','spCreateWeblogDB','spNewPhase');
INSERT Dependency VALUES('spFinish','spCreateWeblogDB','spRunSQLScript');
INSERT Dependency VALUES('spFinish','spFinishDropIndices','spIndexDropSelection');
INSERT Dependency VALUES('spFinish','spFinishDropIndices','spNewPhase');
INSERT Dependency VALUES('spFinish','spFinishStep','spCreateWeblogDB');
INSERT Dependency VALUES('spFinish','spFinishStep','spDone');
INSERT Dependency VALUES('spFinish','spFinishStep','spEndStep');
INSERT Dependency VALUES('spFinish','spFinishStep','spFillMaskedObject');
INSERT Dependency VALUES('spFinish','spFinishStep','spFinishDropIndices');
INSERT Dependency VALUES('spFinish','spFinishStep','spIndexBuildSelection');
INSERT Dependency VALUES('spFinish','spFinishStep','spLoadPatches');
INSERT Dependency VALUES('spFinish','spFinishStep','spLoadPhotoTag');
INSERT Dependency VALUES('spFinish','spFinishStep','spNeighbors');
INSERT Dependency VALUES('spFinish','spFinishStep','spNewPhase');
INSERT Dependency VALUES('spFinish','spFinishStep','spSdssPolygonRegions');
INSERT Dependency VALUES('spFinish','spFinishStep','spSetInsideMask');
INSERT Dependency VALUES('spFinish','spFinishStep','spStartStep');
INSERT Dependency VALUES('spFinish','spFinishStep','spSynchronize');
INSERT Dependency VALUES('spFinish','spFinishStep','spSyncSchema');
INSERT Dependency VALUES('spFinish','spFinishStep','spTruncateFileGroupMap');
INSERT Dependency VALUES('spFinish','spFixTargetVersion','spNewPhase');
INSERT Dependency VALUES('spFinish','spLoadMetaData','spIndexBuildSelection');
INSERT Dependency VALUES('spFinish','spLoadMetaData','spIndexDropSelection');
INSERT Dependency VALUES('spFinish','spLoadMetaData','spNewPhase');
INSERT Dependency VALUES('spFinish','spLoadMetaData','spRunSQLScript');
INSERT Dependency VALUES('spFinish','spLoadPatches','spNewPhase');
INSERT Dependency VALUES('spFinish','spLoadPatches','spRunSQLScript');
INSERT Dependency VALUES('spFinish','spLoadPhotoTag','spNewPhase');
INSERT Dependency VALUES('spFinish','spLoadScienceTables','fGetNearestObjIdEq');
INSERT Dependency VALUES('spFinish','spRemovePlate','spIndexBuildSelection');
INSERT Dependency VALUES('spFinish','spRemovePlate','spIndexDropSelection');
INSERT Dependency VALUES('spFinish','spRemovePlateList','spRemovePlate');
INSERT Dependency VALUES('spFinish','spRemoveTaskPhoto','spRemoveTaskFromTable');
INSERT Dependency VALUES('spFinish','spRemoveTaskSpectro','spRemovePlate');
INSERT Dependency VALUES('spFinish','spRunPatch','spCompareChecksum');
INSERT Dependency VALUES('spFinish','spRunPatch','spMakeDiagnostics');
INSERT Dependency VALUES('spFinish','spRunPatch','spRunSqlScript');
INSERT Dependency VALUES('spFinish','spRunPatch','spUpdateSkyServerCrossCheck');
INSERT Dependency VALUES('spFinish','spRunPatch','spUpdateStatistics');
INSERT Dependency VALUES('spFinish','spRunSQLScript','spNewPhase');
INSERT Dependency VALUES('spFinish','spSdssPolygonRegions','fSphGetArea');
INSERT Dependency VALUES('spFinish','spSdssPolygonRegions','fSphSimplifyAdvanced');
INSERT Dependency VALUES('spFinish','spSdssPolygonRegions','spIndexBuildSelection');
INSERT Dependency VALUES('spFinish','spSdssPolygonRegions','spIndexDropSelection');
INSERT Dependency VALUES('spFinish','spSdssPolygonRegions','spNewPhase');
INSERT Dependency VALUES('spFinish','spSegue2SpectroPhotoMatch','fGetNearestObjIdEqMode');
INSERT Dependency VALUES('spFinish','spSegue2SpectroPhotoMatch','spNewPhase');
INSERT Dependency VALUES('spFinish','spSegue2SpectroPhotoMatch','sppParams');
INSERT Dependency VALUES('spFinish','spSetVersion','spCheckDBColumns');
INSERT Dependency VALUES('spFinish','spSetVersion','spCheckDBIndexes');
INSERT Dependency VALUES('spFinish','spSetVersion','spCheckDBObjects');
INSERT Dependency VALUES('spFinish','spSetVersion','spCompareChecksum');
INSERT Dependency VALUES('spFinish','spSetVersion','spMakeDiagnostics');
INSERT Dependency VALUES('spFinish','spSetVersion','spUpdateSkyServerCrossCheck');
INSERT Dependency VALUES('spFinish','spSetVersion','spUpdateStatistics');
INSERT Dependency VALUES('spFinish','spSynchronize','fDatediffSec');
INSERT Dependency VALUES('spFinish','spSynchronize','spBuildSpecPhotoAll');
INSERT Dependency VALUES('spFinish','spSynchronize','spNewPhase');
INSERT Dependency VALUES('spFinish','spSyncSchema','spLoadMetaData');
INSERT Dependency VALUES('spFinish','spSyncSchema','spNewPhase');
INSERT Dependency VALUES('spFinish','spSyncSchema','spRunSQLScript');
INSERT Dependency VALUES('spFinish','spTiledTargetDuplicates','fgetNearbyTiledTargetsEq');
INSERT Dependency VALUES('spFinish','spTiledTargetDuplicates','fObjType');
INSERT Dependency VALUES('spHtmCSharp','fDistanceEq','SphericalHTM.[Spherical.Htm.Sql.fDistanceEq');
INSERT Dependency VALUES('spHtmCSharp','fDistanceXyz','SphericalHTM.[Spherical.Htm.Sql.fDistanceXyz');
INSERT Dependency VALUES('spHtmCSharp','fHtmCoverCircleEq','SphericalHTM.[Spherical.Htm.Sql.fHtmCoverCircleEq');
INSERT Dependency VALUES('spHtmCSharp','fHtmCoverCircleXyz','SphericalHTM.[Spherical.Htm.Sql.fHtmCoverCircleXyz');
INSERT Dependency VALUES('spHtmCSharp','fHtmCoverRegion','SphericalHTM.[Spherical.Htm.Sql.fHtmCoverRegion');
INSERT Dependency VALUES('spHtmCSharp','fHtmCoverRegionError','SphericalHTM.[Spherical.Htm.Sql.fHtmCoverRegionError');
INSERT Dependency VALUES('spHtmCSharp','fHtmEq','SphericalHTM.[Spherical.Htm.Sql.fHtmEq');
INSERT Dependency VALUES('spHtmCSharp','fHtmEqToXyz','SphericalHTM.[Spherical.Htm.Sql.fHtmEqToXyz');
INSERT Dependency VALUES('spHtmCSharp','fHtmGetCenterPoint','SphericalHTM.[Spherical.Htm.Sql.fHtmGetCenterPoint');
INSERT Dependency VALUES('spHtmCSharp','fHtmGetCornerPoints','SphericalHTM.[Spherical.Htm.Sql.fHtmGetCornerPoints');
INSERT Dependency VALUES('spHtmCSharp','fHtmGetString','SphericalHTM.[Spherical.Htm.Sql.fHtmGetString');
INSERT Dependency VALUES('spHtmCSharp','fHtmVersion','SphericalHTM.[Spherical.Htm.Sql.fHtmVersion');
INSERT Dependency VALUES('spHtmCSharp','fHtmXyz','SphericalHTM.[Spherical.Htm.Sql.fHtmXyz');
INSERT Dependency VALUES('spHtmCSharp','fHtmXyzToEq','SphericalHTM.[Spherical.Htm.Sql.fHtmXyzToEq');
INSERT Dependency VALUES('spNearby','fGetJpegObjects','fGetObjectsEq');
INSERT Dependency VALUES('spNearby','fGetNearbyFrameEq','fHtmCoverCircleXyz');
INSERT Dependency VALUES('spNearby','fGetNearbyObjAllEq','fGetNearbyObjAllXYZ');
INSERT Dependency VALUES('spNearby','fGetNearbyObjAllXYZ','fHtmCoverCircleXyz');
INSERT Dependency VALUES('spNearby','fGetNearbyObjEq','fGetNearbyObjXYZ');
INSERT Dependency VALUES('spNearby','fGetNearbyObjXYZ','fHtmCoverCircleXyz');
INSERT Dependency VALUES('spNearby','fGetNearbySpecObjAllEq','fGetNearbySpecObjAllXYZ');
INSERT Dependency VALUES('spNearby','fGetNearbySpecObjAllXYZ','fHtmCoverCircleXyz');
INSERT Dependency VALUES('spNearby','fGetNearbySpecObjEq','fGetNearbySpecObjXYZ');
INSERT Dependency VALUES('spNearby','fGetNearbySpecObjXYZ','fHtmCoverCircleXyz');
INSERT Dependency VALUES('spNearby','fGetNearestFrameidEq','fGetNearestFrameEq');
INSERT Dependency VALUES('spNearby','fGetNearestObjAllEq','fGetNearbyObjAllXYZ');
INSERT Dependency VALUES('spNearby','fGetNearestObjEq','fGetNearbyObjXYZ');
INSERT Dependency VALUES('spNearby','fGetNearestObjIdAllEq','fGetNearestObjAllEq');
INSERT Dependency VALUES('spNearby','fGetNearestObjIdEq','fGetNearestObjEq');
INSERT Dependency VALUES('spNearby','fGetNearestObjIdEqMode','fGetNearbyObjAllXYZ');
INSERT Dependency VALUES('spNearby','fGetNearestObjIdEqType','fGetNearbyObjEq');
INSERT Dependency VALUES('spNearby','fGetNearestObjXYZ','fGetNearbyObjXYZ');
INSERT Dependency VALUES('spNearby','fGetNearestSpecObjAllEq','fGetNearbySpecObjAllXYZ');
INSERT Dependency VALUES('spNearby','fGetNearestSpecObjAllXYZ','fGetNearbySpecObjAllXYZ');
INSERT Dependency VALUES('spNearby','fGetNearestSpecObjEq','fGetNearbySpecObjXYZ');
INSERT Dependency VALUES('spNearby','fGetNearestSpecObjIdAllEq','fGetNearestSpecObjAllEq');
INSERT Dependency VALUES('spNearby','fGetNearestSpecObjIdEq','fGetNearestSpecObjEq');
INSERT Dependency VALUES('spNearby','fGetNearestSpecObjXYZ','fGetNearbySpecObjXYZ');
INSERT Dependency VALUES('spNearby','fGetObjectsEq','fHtmCoverCircleXyz');
INSERT Dependency VALUES('spNearby','fGetObjectsMaskEq','fHtmCoverCircleXyz');
INSERT Dependency VALUES('spNearby','fGetObjFromRect','fGetNearbyObjEq');
INSERT Dependency VALUES('spNearby','fGetObjFromRectEq','fGetObjFromRect');
INSERT Dependency VALUES('spNearby','spGetMatch','fGetNearbyObjXYZ');
INSERT Dependency VALUES('spNearby','spGetNeighbors','fGetNearbyObjAllEq');
INSERT Dependency VALUES('spNearby','spGetNeighborsAll','fGetNearbyObjAllEq');
INSERT Dependency VALUES('spNearby','spGetNeighborsPrim','fGetNearbyObjEq');
INSERT Dependency VALUES('spNearby','spGetNeighborsRadius','fGetNearbyObjAllEq');
INSERT Dependency VALUES('spNearby','spGetSpecNeighborsAll','fGetNearbySpecObjAllEq');
INSERT Dependency VALUES('spNearby','spGetSpecNeighborsPrim','fGetNearbySpecObjEq');
INSERT Dependency VALUES('spNearby','spGetSpecNeighborsRadius','fGetNearbySpecObjAllEq');
INSERT Dependency VALUES('spNearby','spNearestObjEq','fPhotoTypeN');
INSERT Dependency VALUES('spNeighbor','spNeighbors','fDatediffSec');
INSERT Dependency VALUES('spNeighbor','spNeighbors','fGetAlpha');
INSERT Dependency VALUES('spNeighbor','spNeighbors','spIndexBuildSelection');
INSERT Dependency VALUES('spNeighbor','spNeighbors','spIndexDropSelection');
INSERT Dependency VALUES('spNeighbor','spNeighbors','spNewPhase');
INSERT Dependency VALUES('spNeighbor','spNeighbors','spZoneCreate');
INSERT Dependency VALUES('spNeighbor','spZoneCreate','fDatediffSec');
INSERT Dependency VALUES('spNeighbor','spZoneCreate','fGetAlpha');
INSERT Dependency VALUES('spNeighbor','spZoneCreate','spIndexBuildSelection');
INSERT Dependency VALUES('spNeighbor','spZoneCreate','spIndexDropSelection');
INSERT Dependency VALUES('spNeighbor','spZoneCreate','spNewPhase');
INSERT Dependency VALUES('spPhoto','fDMS','fDMSbase');
INSERT Dependency VALUES('spPhoto','fHMS','fHMSbase');
INSERT Dependency VALUES('spPhoto','fIAUFromEq','fDMSbase');
INSERT Dependency VALUES('spPhoto','fIAUFromEq','fHMSbase');
INSERT Dependency VALUES('spPhoto','fMagToFluxErr','fMagToFlux');
INSERT Dependency VALUES('spPhoto','fSDSS','fCamcol');
INSERT Dependency VALUES('spPhoto','fSDSS','fField');
INSERT Dependency VALUES('spPhoto','fSDSS','fObj');
INSERT Dependency VALUES('spPhoto','fSDSS','fRerun');
INSERT Dependency VALUES('spPhoto','fSDSS','fRun');
INSERT Dependency VALUES('spPhoto','fSDSS','fSkyVersion');
INSERT Dependency VALUES('spPublish','spBackupStep','spEndStep');
INSERT Dependency VALUES('spPublish','spBackupStep','spNewPhase');
INSERT Dependency VALUES('spPublish','spBackupStep','spStartStep');
INSERT Dependency VALUES('spPublish','spCopyATable','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishGalSpec','spCopyATable');
INSERT Dependency VALUES('spPublish','spPublishGalSpec','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishPhoto','spCopyATable');
INSERT Dependency VALUES('spPublish','spPublishPhoto','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishPlates','spCopyATable');
INSERT Dependency VALUES('spPublish','spPublishPlates','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishPm','spCopyATable');
INSERT Dependency VALUES('spPublish','spPublishPm','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishResolve','spCopyATable');
INSERT Dependency VALUES('spPublish','spPublishResolve','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishSspp','spCopyATable');
INSERT Dependency VALUES('spPublish','spPublishSspp','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishStep','spEndStep');
INSERT Dependency VALUES('spPublish','spPublishStep','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishStep','spPublishGalSpec');
INSERT Dependency VALUES('spPublish','spPublishStep','spPublishPhoto');
INSERT Dependency VALUES('spPublish','spPublishStep','spPublishPlates');
INSERT Dependency VALUES('spPublish','spPublishStep','spPublishPm');
INSERT Dependency VALUES('spPublish','spPublishStep','spPublishResolve');
INSERT Dependency VALUES('spPublish','spPublishStep','spPublishSspp');
INSERT Dependency VALUES('spPublish','spPublishStep','spPublishTiling');
INSERT Dependency VALUES('spPublish','spPublishStep','spPublishWindow');
INSERT Dependency VALUES('spPublish','spPublishStep','spStartStep');
INSERT Dependency VALUES('spPublish','spPublishTiling','spCopyATable');
INSERT Dependency VALUES('spPublish','spPublishTiling','spNewPhase');
INSERT Dependency VALUES('spPublish','spPublishWindow','spCopyATable');
INSERT Dependency VALUES('spPublish','spPublishWindow','spNewPhase');
INSERT Dependency VALUES('spRegion','fFootprintEq','fRegionsContainingPointEq');
INSERT Dependency VALUES('spRegion','fRegionGetObjectsFromRegionId','fHtmCoverRegion');
INSERT Dependency VALUES('spRegion','fRegionGetObjectsFromString','fHtmCoverRegion');
INSERT Dependency VALUES('spRegion','fRegionGetObjectsFromString','fSphGetHalfspaces');
INSERT Dependency VALUES('spRegion','fRegionGetObjectsFromString','fSphGetRegionString');
INSERT Dependency VALUES('spRegion','fRegionGetObjectsFromString','fSphGrow');
INSERT Dependency VALUES('spRegion','fRegionGetObjectsFromString','fSphSimplifyString');
INSERT Dependency VALUES('spRegion','fRegionOverlapId','fSphGrow');
INSERT Dependency VALUES('spRegion','fRegionOverlapId','fSphIntersect');
INSERT Dependency VALUES('spRegion','fRegionsContainingPointEq','fRegionsContainingPointXYZ');
INSERT Dependency VALUES('spRegion','fRegionsContainingPointXYZ','fSphGrow');
INSERT Dependency VALUES('spRegion','fRegionsContainingPointXYZ','fSphRegionContainsXYZ');
INSERT Dependency VALUES('spRegion','fRegionsContainingPointXYZ','fTokenStringToTable');
INSERT Dependency VALUES('spRegion','fTokenStringToTable','fNormalizeString');
INSERT Dependency VALUES('spRegion','fTokenStringToTable','fTokenAdvance');
INSERT Dependency VALUES('spRegion','fTokenStringToTable','fTokenNext');
INSERT Dependency VALUES('spRegion','spRegionAnd','fSphGetArea');
INSERT Dependency VALUES('spRegion','spRegionAnd','fSphGetRegionString');
INSERT Dependency VALUES('spRegion','spRegionAnd','fSphIntersectAdvanced');
INSERT Dependency VALUES('spRegion','spRegionIntersect','fSphGetArea');
INSERT Dependency VALUES('spRegion','spRegionIntersect','fSphGetPatches');
INSERT Dependency VALUES('spRegion','spRegionIntersect','fSphGetRegionString');
INSERT Dependency VALUES('spRegion','spRegionIntersect','fSphIntersect');
INSERT Dependency VALUES('spRegion','spRegionIntersect','spRegionDelete');
INSERT Dependency VALUES('spRegion','spRegionSubtract','fSphDiff');
INSERT Dependency VALUES('spRegion','spRegionSubtract','fSphGetArea');
INSERT Dependency VALUES('spRegion','spRegionSubtract','fSphGetPatches');
INSERT Dependency VALUES('spRegion','spRegionSubtract','fSphGetRegionString');
INSERT Dependency VALUES('spRegion','spRegionSubtract','spRegionDelete');
INSERT Dependency VALUES('spRegion','spRegionSync','fSphGetPatches');
INSERT Dependency VALUES('spSetValues','spFillMaskedObject','fRegionGetObjectsFromString');
INSERT Dependency VALUES('spSetValues','spFillMaskedObject','spEndStep');
INSERT Dependency VALUES('spSetValues','spFillMaskedObject','spIndexCreate');
INSERT Dependency VALUES('spSetValues','spFillMaskedObject','spIndexDropSelection');
INSERT Dependency VALUES('spSetValues','spFillMaskedObject','spNewPhase');
INSERT Dependency VALUES('spSetValues','spSetInsideMask','spEndStep');
INSERT Dependency VALUES('spSetValues','spSetInsideMask','spNewPhase');
INSERT Dependency VALUES('spSetValues','spSetLoadVersion','spEndStep');
INSERT Dependency VALUES('spSetValues','spSetLoadVersion','spNewPhase');
INSERT Dependency VALUES('spSetValues','spSetPhotoClean','spNewPhase');
INSERT Dependency VALUES('spSetValues','spSetValues','fHtmXYZ');
INSERT Dependency VALUES('spSetValues','spSetValues','spanREPLACE');
INSERT Dependency VALUES('spSetValues','spSetValues','spComputeFrameHTM');
INSERT Dependency VALUES('spSetValues','spSetValues','spEndStep');
INSERT Dependency VALUES('spSetValues','spSetValues','spFillMaskedObject');
INSERT Dependency VALUES('spSetValues','spSetValues','spNewPhase');
INSERT Dependency VALUES('spSetValues','spSetValues','spSetInsideMask');
INSERT Dependency VALUES('spSetValues','spSetValues','spSetLoadVersion');
INSERT Dependency VALUES('spSetValues','spSetValues','spTargetInfoTargetObjid');
INSERT Dependency VALUES('spSetValues','spTargetInfoTargetObjID','ffirstfieldbit');
INSERT Dependency VALUES('spSetValues','spTargetInfoTargetObjID','spNewPhase');
INSERT Dependency VALUES('spSphericalLib','fSphGetArcs','SphericalSql.[Spherical.Sql.UserDefinedFunctions.GetArcs');
INSERT Dependency VALUES('spSphericalLib','fSphGetConvexes','SphericalSql.[Spherical.Sql.UserDefinedFunctions.GetConvexes');
INSERT Dependency VALUES('spSphericalLib','fSphGetHalfspaces','SphericalSql.[Spherical.Sql.UserDefinedFunctions.GetHalfspaces');
INSERT Dependency VALUES('spSphericalLib','fSphGetHtmRanges','SphericalSql.[Spherical.Sql.UserDefinedFunctions.GetHtmRanges');
INSERT Dependency VALUES('spSphericalLib','fSphGetHtmRangesAdvanced','SphericalSql.[Spherical.Sql.UserDefinedFunctions.GetHtmRangesAdvanced');
INSERT Dependency VALUES('spSphericalLib','fSphGetOutlineArcs','SphericalSql.[Spherical.Sql.UserDefinedFunctions.GetOutlineArcs');
INSERT Dependency VALUES('spSphericalLib','fSphGetPatches','SphericalSql.[Spherical.Sql.UserDefinedFunctions.GetPatches');
INSERT Dependency VALUES('spSphericalLib','fSphGetRegionString','fSphGetRegionStringBin');
INSERT Dependency VALUES('spSphericalLib','fSphRegionContainsXYZ','SphericalSql.[Spherical.Sql.UserDefinedFunctions.ContainsXYZ');
INSERT Dependency VALUES('spSphericalLib','fSphSimplify','fSphSimplifyAdvanced');
INSERT Dependency VALUES('spSphericalLib','fSphSimplifyAdvanced','fSphSimplifyQueryAdvanced');
INSERT Dependency VALUES('spSQLSupport','spExecuteSQL','fIsNumbers');
INSERT Dependency VALUES('spSQLSupport','spExecuteSQL','fReplace');
INSERT Dependency VALUES('spTestQueries','spTestQueries','fGetNearbyObjEq');
INSERT Dependency VALUES('spTestQueries','spTestQueries','fHtmCoverRegion');
INSERT Dependency VALUES('spTestQueries','spTestQueries','fPhotoFlags');
INSERT Dependency VALUES('spTestQueries','spTestQueries','fPhotoType');
INSERT Dependency VALUES('spTestQueries','spTestQueries','fSpecClass');
INSERT Dependency VALUES('spTestQueries','spTestQueries','spTestTimeEnd');
INSERT Dependency VALUES('spTestQueries','spTestQueries','spTestTimeStart');
INSERT Dependency VALUES('spUrlFitsSupport','fGetUrlFitsField','fSkyVersion');
INSERT Dependency VALUES('spValidate','spComputePhotoParentID','spNewPhase');
INSERT Dependency VALUES('spValidate','spGenericTest','spNewPhase');
INSERT Dependency VALUES('spValidate','spTestForeignKey','spNewPhase');
INSERT Dependency VALUES('spValidate','spTestHtm','fHtmEq');
INSERT Dependency VALUES('spValidate','spTestHtm','spNewPhase');
INSERT Dependency VALUES('spValidate','spTestPhotoParentID','spNewPhase');
INSERT Dependency VALUES('spValidate','spTestUniqueKey','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidateGalSpec','fDatediffSec');
INSERT Dependency VALUES('spValidate','spValidateGalSpec','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidateGalSpec','spTestUniqueKey');
INSERT Dependency VALUES('spValidate','spValidatePhoto','fDatediffSec');
INSERT Dependency VALUES('spValidate','spValidatePhoto','spComputePhotoParentID');
INSERT Dependency VALUES('spValidate','spValidatePhoto','spGenericTest');
INSERT Dependency VALUES('spValidate','spValidatePhoto','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidatePhoto','spTestForeignKey');
INSERT Dependency VALUES('spValidate','spValidatePhoto','spTestPhotoParentID');
INSERT Dependency VALUES('spValidate','spValidatePhoto','spTestUniqueKey');
INSERT Dependency VALUES('spValidate','spValidatePlates','fDatediffSec');
INSERT Dependency VALUES('spValidate','spValidatePlates','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidatePlates','spTestForeignKey');
INSERT Dependency VALUES('spValidate','spValidatePlates','spTestUniqueKey');
INSERT Dependency VALUES('spValidate','spValidatePm','fDatediffSec');
INSERT Dependency VALUES('spValidate','spValidatePm','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidatePm','spTestUniqueKey');
INSERT Dependency VALUES('spValidate','spValidateResolve','fDatediffSec');
INSERT Dependency VALUES('spValidate','spValidateResolve','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidateResolve','spTestUniqueKey');
INSERT Dependency VALUES('spValidate','spValidateSspp','fDatediffSec');
INSERT Dependency VALUES('spValidate','spValidateSspp','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidateSspp','spTestUniqueKey');
INSERT Dependency VALUES('spValidate','spValidateStep','spEndStep');
INSERT Dependency VALUES('spValidate','spValidateStep','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidateStep','spStartStep');
INSERT Dependency VALUES('spValidate','spValidateStep','spValidateGalSpec');
INSERT Dependency VALUES('spValidate','spValidateStep','spValidatePhoto');
INSERT Dependency VALUES('spValidate','spValidateStep','spValidatePlates');
INSERT Dependency VALUES('spValidate','spValidateStep','spValidatePm');
INSERT Dependency VALUES('spValidate','spValidateStep','spValidateResolve');
INSERT Dependency VALUES('spValidate','spValidateStep','spValidateSspp');
INSERT Dependency VALUES('spValidate','spValidateStep','spValidateTiles');
INSERT Dependency VALUES('spValidate','spValidateStep','spValidateWindow');
INSERT Dependency VALUES('spValidate','spValidateTiles','fDatediffSec');
INSERT Dependency VALUES('spValidate','spValidateTiles','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidateTiles','spTestForeignKey');
INSERT Dependency VALUES('spValidate','spValidateTiles','spTestUniqueKey');
INSERT Dependency VALUES('spValidate','spValidateWindow','fDatediffSec');
INSERT Dependency VALUES('spValidate','spValidateWindow','spNewPhase');
INSERT Dependency VALUES('spValidate','spValidateWindow','spTestUniqueKey');
GO

------------------------------------
PRINT '331 lines inserted into Dependency'
------------------------------------
GO


-- Rebuild META indices
EXEC spIndexBuildSelection 0,0,'F','META'


-- Add Photoz indices to IndexMap
INSERT IndexMap Values('K','primary key', 'Photoz', 	 	'objID'	,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'PhotozRF',           'objID' ,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'PhotozTemplateCoeff',	'objID,templateID'	,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'PhotozRFTemplateCoeff',	'objID,templateID' ,'','PHOTO');
INSERT IndexMap Values('F','foreign key', 'Photoz', 	 	'objID'		,'PhotoObjAll(objID)'	,'PHOTO');
INSERT IndexMap Values('F','foreign key', 'PhotozRF',            'objID'		,'PhotoObjAll(objID)'   ,'PHOTO');


-- Remove duplicate rows from RC3 and ROSAT
SELECT DISTINCT * INTO #rc3 FROM RC3
TRUNCATE TABLE RC3
INSERT RC3 SELECT * FROM #rc3

SELECT DISTINCT * INTO #rosat FROM ROSAT
TRUNCATE TABLE ROSAT
INSERT ROSAT SELECT * FROM #rosat

-- Make sure all META PKs are created
EXEC spIndexBuildSelection 0,0,'K','META'

-- Drop discontinued function fGetUrlAtlasImageId
IF EXISTS (SELECT name FROM   sysobjects
           WHERE  name = N'fGetUrlAtlasImageId' )
DROP FUNCTION fGetUrlAtlasImageId

-- Add PK indices for external match tables (if they dont exist)
DELETE IndexMap WHERE tableName IN (N'First',N'RC3',N'Rosat',N'USNO',N'TwoMass',N'TwoMassXSC')
INSERT IndexMap Values('K','primary key', 'First', 		'objID'			,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'RC3', 		'objID'			,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'Rosat', 		'objID'			,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'USNO', 		'objID'			,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'TwoMass', 		'objID'			,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'TwoMassXSC',		'objID'			,'','PHOTO');

-- Add indices for thingIndex and detectionIndex tables
DELETE IndexMap WHERE tableName IN (N'thingIndex',N'detectionIndex')
INSERT IndexMap Values('K','primary key', 'thingIndex', 	'thingId'		,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'detectionIndex', 	'objID'			,'','PHOTO');
INSERT IndexMap Values('F','foreign key', 'detectionIndex', 	'thingID'	,'thingIndex(thingID)'	,'PHOTO');
INSERT IndexMap Values('F','foreign key', 'thingIndex', 	'sdssPolygonID'	,'sdssPolygons(sdssPolygonID)'	,'PHOTO');
INSERT IndexMap Values('I','index', 'thingIndex', 	 'objID'					,'','PHOTO')
INSERT IndexMap Values('I','index', 'detectionIndex', 	 'thingID'					,'','PHOTO')


-- Delete FK index in FIRST table
DELETE FROM IndexMap WHERE tablename='FIRST' AND code='F'	
ALTER TABLE FIRST DROP CONSTRAINT fk_First_objID_PhotoObjAll_objID

-- Build Photoz and other remaining photo indices
EXEC spIndexBuildSelection 0,0,'K','PHOTO'
EXEC spIndexBuildSelection 0,0,'F','PHOTO'
EXEC spIndexBuildSelection 0,0,'I','PHOTO'

-- Update the version info
EXECUTE spSetVersion
  0
  ,0
  ,'8'
  ,'124469'
  ,'Update DR'
  ,'.2'
  ,'DR7 xmatch'
  ,'Added DR7 spatial cross-match tables PhotoPrimaryDR7, PhotoObjDR7 and SpecDR7'
  ,'M.Blanton,N.Buddana,V.Paul,A.Thakar,V.Vakiti'

