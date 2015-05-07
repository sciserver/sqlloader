-- patches from dr8patches.sql to apply to testload db. [ART]

USE BESTTEST
GO

-- Set PlateX.htmID
UPDATE PlateX 
	SET htmId = dbo.fHtmXYZ( cx, cy, cz )


-- Fix sppTargets.objid so skyVersion=1 instead of 2
UPDATE sppTargets
	SET objid=dbo.fObjidFromSDSS( 1,run,rerun,camcol,field,obj)


-- Create index on PhotoObjAll parentid,mode,type and include ugriz etc. in it
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

-- Remove duplicate rows from RC3 and ROSAT
SELECT DISTINCT * INTO #rc3 FROM RC3
TRUNCATE TABLE RC3
INSERT RC3 SELECT * FROM #rc3

SELECT DISTINCT * INTO #rosat FROM ROSAT
TRUNCATE TABLE ROSAT
INSERT ROSAT SELECT * FROM #rosat


-- Drop discontinued function fGetUrlAtlasImageId
IF EXISTS (SELECT name FROM   sysobjects
           WHERE  name = N'fGetUrlAtlasImageId' )
DROP FUNCTION fGetUrlAtlasImageId

-- Build Photoz and other remaining photo indices
EXEC spIndexBuildSelection 0,0,'K','PHOTO'
EXEC spIndexBuildSelection 0,0,'F','PHOTO'
EXEC spIndexBuildSelection 0,0,'I','PHOTO'

