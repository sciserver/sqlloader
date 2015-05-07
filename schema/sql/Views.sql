--==================================================================
--    Views.sql
--    2001-05-15 Alex Szalay
--------------------------------------------------------------------
--  Views on the SkyServer database  
--  They hide non-primary objects and give "old" views of the data.
--------------------------------------------------------------------
-- History
--* 2001-05-15 Alex: removed parent from PhotoObj and PrimaryObjects
--* 2001-05-15 Alex: changed objType to type in where clauses
--* 2001-05-15 Alex: fixed Tag attribute names
--* 2001-05-25 Alex: fixed a bug in PrimaryObjects-- ugriz-Err 
--*		was mapped onto the magnitudes instead of the errors
--* 2001-05-25 Alex: fixed a bug in Galaxies -- type was 6, now is 3
--* 2001-11-05 Alex: added PhotoPrimary, PhotoSecondary, PhotoFamily views
--* 2002-09-17 Ani: Changed SpecObj view to use sciencePrimary instead of
--*             isPrimary
--* 2003-01-27 Ani: Added views TilingBoundary and TilingMask (PR #4702)
--* 2003-05-15 Alex: Changed PhotoObj-> PhotoObjAll
--* 2003-05-21 Adrian+Alex: move TilingBoundary and TilingMask views to tilingTables.sql
--* 2003-06-04 Alex: reverted PhotObj to mode=(1,2), dropped Tag
--* 2003-11-17 Ani: Defined view Columns to alias DBColumns for SkyQuery.
--* 2004-06-04 Ani: Added clarifications to Star and Galaxy views as
--*             per PR #6054.
--* 2004-07-08 Ani: Changed "unresolved" to "resolved" in Galaxy view description.
--* 2004-08-30 Alex: Moved here various views frim TilingTables
--* 2004-10-08 Ani: Made minor update to PhotoObj description.
--* 2005-06-02 Ani: Added PhotoAux view of new PhotoAuxAll table.
--* 2005-06-11 Ani: Added Run view of Segment table.
--* 2006-03-09 Ani: Added StarTag, GalaxyTag views of primary PhotoTag
--*            analogous to Star and Galaxy from PhotoPrimary (PR #5940).
--* 2006-04-09 Ani: Added views for QsoCatalog and QsoConcordance.
--* 2006-08-02 Ani: Added PhotoAuxAll view for DR6 (PR #7000).
--* 2006-08-02 Ani: Added views for TargPhotoObjAll (PR #6866).
--* 2006-12-01 Ani: Removed ref. to OK_RUN in PhotoPrimary doc (PR #6090).
--* 2007-01-24 Ani: Added NOLOCK hints to all table views (PR #7140).
--* 2007-08-21 Ani: Added spbsParams view (PR #7345).
--* 2009-04-27 Ani: Deleted view Run (replaced by table Run) for SDSS-III.
--*                 Also removed TargPhotoObjAll and PhotoAux views.
--* 2009-05-05 Ani: Commented out columns in spbsParams that do not exist in
--*                 base table sppParams, for SDSS-III.
--* 2010-11-16 Ani: Added view for TableDesc (no longer a table).
--* 2010-11-18 Ani: Removed SpecLine view - underlying table is gone.
--* 2010-11-18 Ani: Renamed tiling views to add "sdss" prefix.
--* 2010-11-18 Ani: Modified view for TableDesc to make IndexMap an outer join.
--* 2010-11-19 Ani: Commented out spbsParams view until it is fixed.
--* 2010-11-25 Ani: Commented out sdssTiledTarget view (broken, no unTiled col).
--* 2010-12-10 Ani: Added PhotoTag view.
--* 2010-12-12 Ani: Added missing GO after PhotoTag view definition.
--* 2010-12-23 Ani: Added SEGUE specObjAll views.
--* 2013-04-02 Ani: Added "clean" photometry flag to Phototag view.
--==================================================================
SET NOCOUNT ON
GO

--============================================
-- redefined views of the PhotObj table
--============================================


--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[PhotoObj]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[PhotoObj]
GO
--
CREATE VIEW PhotoObj
----------------------------------------------------------------------
--/H All primary and secondary objects in the PhotoObjAll table, which contains all the attributes of each photometric (image) object. 
--
--/T It selects PhotoObj with mode=1 or 2.
----------------------------------------------------------------------
AS
SELECT * FROM PhotoObjAll WITH(NOLOCK)
	WHERE mode in (1,2)
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[PhotoPrimary]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[PhotoPrimary]
GO
--
CREATE VIEW PhotoPrimary 
----------------------------------------------------------------------
--/H These objects are the primary survey objects. 
--
--/T Each physical object 
--/T on the sky has only one primary object associated with it. Upon 
--/T subsequent observations secondary objects are generated. Since the 
--/T survey stripes overlap, there will be secondary objects for over 10% 
--/T of all primary objects, and in the southern stripes there will be a 
--/T multitude of secondary objects for each primary (i.e. reobservations). 
----------------------------------------------------------------------
AS
SELECT * FROM PhotoObjAll WITH(NOLOCK)
    WHERE mode=1
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[PhotoSecondary]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[PhotoSecondary]
GO
--
CREATE VIEW PhotoSecondary
----------------------------------------------------------------------
--/H Secondary objects are reobservations of the same primary object.
----------------------------------------------------------------------
AS
SELECT * FROM PhotoObjAll WITH(NOLOCK)
    WHERE mode=2
--status & 0x00001000 > 0 
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[PhotoFamily]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[PhotoFamily]
GO
--
CREATE VIEW PhotoFamily
----------------------------------------------------------------------
--/H These are in PhotoObj, but neither PhotoPrimary or Photosecondary.
--
--/T These objects are generated if they are neither primary nor 
--/T secondary survey objects but a composite object that has been 
--/T deblended or the part of an object that has been deblended 
--/T wrongfully (like the spiral arms of a galaxy). These objects 
--/T are kept to track how the deblender is working. It inherits 
--/T all members of the PhotoObj class. 
----------------------------------------------------------------------
AS
SELECT * FROM PhotoObjAll WITH(NOLOCK)
    WHERE mode=3

--(status & 0x00001000 = 0)  -- not a secondary
--	and NOT ( (status & 0x00002000>0) and (status & 0x0010 >0)) -- not a primary either
GO



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[Star]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[Star]
GO
--
CREATE VIEW Star
--------------------------------------------------------------
--/H The objects classified as stars from PhotoPrimary
--
--/T The Star view essentially contains the photometric parameters
--/T (no redshifts or spectroscopic parameters) for all primary
--/T point-like objects, including quasars.
--------------------------------------------------------------
AS
SELECT * 
    FROM PhotoPrimary
    WHERE type = 6
GO



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[Galaxy]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[Galaxy]
GO
--
CREATE VIEW Galaxy
---------------------------------------------------------------
--/H The objects classified as galaxies from PhotoPrimary.
--
--/T The Galaxy view contains the photometric parameters (no
--/T redshifts or spectroscopic parameters) measured for
--/T resolved primary objects.
---------------------------------------------------------------
AS
SELECT * 
    FROM PhotoPrimary
    WHERE type = 3
GO



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[PhotoTag]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[PhotoTag]
GO
--
CREATE VIEW PhotoTag
--------------------------------------------------------------
--/H The most popular columns from PhotoObjAll.
--
--/T This view contains the most popular columns from the
--/T PhotoObjAll table, and is intended to enable faster
--/T queries if they only request these columns by making 
--/T use of the cache.  Performance is also enhanced by
--/T an index covering the columns in this view in the base
--/T table (PhotoObjAll).
--------------------------------------------------------------
AS
SELECT [objID]
      ,[skyVersion]
      ,[run]
      ,[rerun]
      ,[camcol]
      ,[field]
      ,[obj]
      ,[mode]
      ,[nChild]
      ,[type]
      ,[clean]
      ,[probPSF]
      ,[insideMask]
      ,[flags]
      ,[flags_u]
      ,[flags_g]
      ,[flags_r]
      ,[flags_i]
      ,[flags_z]
      ,[psfMag_u]
      ,[psfMag_g]
      ,[psfMag_r]
      ,[psfMag_i]
      ,[psfMag_z]
      ,[psfMagErr_u]
      ,[psfMagErr_g]
      ,[psfMagErr_r]
      ,[psfMagErr_i]
      ,[psfMagErr_z]
      ,[petroMag_u]
      ,[petroMag_g]
      ,[petroMag_r]
      ,[petroMag_i]
      ,[petroMag_z]
      ,[petroMagErr_u]
      ,[petroMagErr_g]
      ,[petroMagErr_r]
      ,[petroMagErr_i]
      ,[petroMagErr_z]
      ,[petroR50_r]
      ,[petroR90_r]
      ,u as [modelMag_u]
      ,g as [modelMag_g]
      ,r as [modelMag_r]
      ,i as [modelMag_i]
      ,z as [modelMag_z]
      ,err_u  as [modelMagErr_u] 
      ,err_g  as [modelMagErr_g]
      ,err_r  as [modelMagErr_r]
      ,err_i  as [modelMagErr_i]
      ,err_z  as [modelMagErr_z]
      ,[cModelMag_u]
      ,[cModelMag_g]
      ,[cModelMag_r]
      ,[cModelMag_i]
      ,[cModelMag_z]
      ,[cModelMagErr_u]
      ,[cModelMagErr_g]
      ,[cModelMagErr_r]
      ,[cModelMagErr_i]
      ,[cModelMagErr_z]
      ,[mRrCc_r]
      ,[mRrCcErr_r]
      ,[mRrCcPsf_r]
      ,[fracDeV_u]
      ,[fracDeV_g]
      ,[fracDeV_r]
      ,[fracDeV_i]
      ,[fracDeV_z]
      ,[psffwhm_u]
      ,[psffwhm_g]
      ,[psffwhm_r]
      ,[psffwhm_i]
      ,[psffwhm_z]
      ,[resolveStatus]
      ,[thingId]
      ,[balkanId]
      ,[nObserve]
      ,[nDetect]
      ,[calibStatus_u]
      ,[calibStatus_g]
      ,[calibStatus_r]
      ,[calibStatus_i]
      ,[calibStatus_z]
      ,[ra]
      ,[dec]
      ,[cx]
      ,[cy]
      ,[cz]
      ,[extinction_u]
      ,[extinction_g]
      ,[extinction_r]
      ,[extinction_i]
      ,[extinction_z]
      ,[htmID]
      ,[fieldID]
      ,[specObjID]
      ,( case when mRrCc_r > 0 then SQRT(mRrCc_r/2.0)else 0 end) as size
  FROM PhotoObjAll
GO



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[StarTag]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[StarTag]
GO
--
CREATE VIEW StarTag
--------------------------------------------------------------
--/H The objects classified as stars from primary PhotoTag objects.
--
--/T The StarTag view essentially contains the abbreviated photometric 
--/T parameters from the PhotoTag table (no redshifts or spectroscopic
--/T parameters) for all primary point-like objects, including quasars.
--------------------------------------------------------------
AS
SELECT * 
    FROM PhotoTag WITH(NOLOCK)
    WHERE type = 6 and mode=1
GO



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[GalaxyTag]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[GalaxyTag]
GO
--
CREATE VIEW GalaxyTag
---------------------------------------------------------------
--/H The objects classified as galaxies from primary PhotoTag objects.
--
--/T The GalaxyTag view essentially contains the abbreviated photometric 
--/T parameters from the PhotoTag table (no redshifts or spectroscopic
--/T parameters) for all primary point-like objects, including quasars.
---------------------------------------------------------------
AS
SELECT * 
    FROM PhotoTag WITH(NOLOCK)
    WHERE type = 3 and mode=1
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[Sky]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[Sky]
GO
--
CREATE VIEW Sky
---------------------------------------------------------------
--/H The objects selected as sky samples in PhotoPrimary
---------------------------------------------------------------
AS
SELECT * 
    FROM PhotoPrimary
    WHERE type = 8
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[Unknown]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[Unknown]
GO
--
CREATE VIEW Unknown
---------------------------------------------------------------------
--/H Everything in PhotoPrimary, which is not a galaxy, star or sky
--------------------------------------------------------------------
AS
SELECT * 
    FROM PhotoPrimary
    WHERE type not in (3,6,8)
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spbsParams]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[spbsParams]
GO
--


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[SpecPhoto]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[SpecPhoto]
GO
--
CREATE VIEW SpecPhoto 
---------------------------------------------------------------
--/H A view of joined Spectro and Photo objects that have the clean spectra.
--
--/T The view includes only those pairs where the SpecObj is a
--/T sciencePrimary, and the BEST PhotoObj is a PRIMARY (mode=1).
---------------------------------------------------------------
AS
SELECT * 
    FROM SpecPhotoAll WITH(NOLOCK)
    WHERE sciencePrimary = 1 and mode=1
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[SpecObj]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[SpecObj]
GO
--
CREATE VIEW SpecObj 
---------------------------------------------------------------
--/H A view of Spectro objects that just has the clean spectra.
--
--/T The view excludes QA and Sky and duplicates. Use this as the main
--/T way to access the spectro objects.
---------------------------------------------------------------
AS
SELECT * 
    FROM specObjAll WITH(NOLOCK)
    WHERE sciencePrimary = 1 
GO



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[Columns]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[Columns]
GO
--
CREATE VIEW Columns 
---------------------------------------------------------------
--/H Aliias the DBColumns table also as Columns, for legacy SkyQuery
---------------------------------------------------------------
AS
SELECT * 
    FROM DBColumns WITH(NOLOCK)
GO




---------------------------------
--  views related to SEGUE
---------------------------------

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
	FROM specObjAll 
	   AS s JOIN plateX AS p ON s.plateId = p.plateId
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
	FROM specObjAll 
	   AS s JOIN plateX AS p ON s.plateId = p.plateId
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
	FROM specObjAll 
	   AS s JOIN plateX AS p ON s.plateId = p.plateId
	WHERE p.programName like 'seg%'
GO



---------------------------------
--  views related to Tiles
---------------------------------

--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[sdssTile]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[sdssTile]
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
CREATE VIEW sdssTile
---------------------------------------------------------------
--/H A view of sdssTileAll that have untiled=0
--
--/T The view excludes those sdssTiles that have been untiled.
---------------------------------------------------------------
AS
SELECT * 
    FROM sdssTileAll WITH(NOLOCK)
    WHERE untiled = 0
GO



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[sdssTiledTarget]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[sdssTiledTarget]
GO
--



--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[sdssTilingBoundary]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[sdssTilingBoundary]
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
CREATE VIEW sdssTilingBoundary
---------------------------------------------------------------
--/H A view of sdssTilingGeometry objects that have isMask = 0
--
--/T The view excludes those sdssTilingGeometry objects that have 
--/T isMask = 1.  See also sdssTilingMask.
---------------------------------------------------------------
AS
SELECT * 
    FROM sdssTilingGeometry WITH(NOLOCK)
    WHERE isMask = 0
GO


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[sdssTilingMask]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[sdssTilingMask]
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
CREATE VIEW sdssTilingMask
---------------------------------------------------------------
--/H A view of sdssTilingGeometry objects that have isMask = 1
--
--/T The view excludes those sdssTilingGeometry objects that have 
--/T isMask = 0.  See also sdssTilingBoundary.
---------------------------------------------------------------
AS
SELECT * 
    FROM sdssTilingGeometry WITH(NOLOCK)
    WHERE isMask = 1
GO
--


--=============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[TableDesc]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view [dbo].[TableDesc]
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
CREATE VIEW TableDesc 
---------------------------------------------------------------
--/H Extract the description and index group of each table in schema.
--
--/T The view extracts the description of each table from the 
--/T DBObjects table and the index group from the IndexMap table.
--/T This allows all table descriptions to be viewed in one list.
---------------------------------------------------------------
AS 
SELECT DISTINCT o.name AS [key], 
	ISNULL(i.indexgroup,' ') as type, 
	(o.description+'<br>'+o.text) as text 
FROM DBObjects o LEFT OUTER JOIN IndexMap i ON o.name=i.tableName 
WHERE o.type='U'	-- type is table
GO
--


PRINT '[Views.sql]: Views created'
GO
