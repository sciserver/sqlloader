-- Schema patches for the next data release.  
-- NOTE: This file SHOULD NEVER CONTAIN DESTRUCTIVE CHANGES that might not
-- be valid in upcoming releases.  This script is invoked AUTOMATICALLY 
-- for each release (by the FINISH step), so BEWARE of what you put in here!

-- Photo schema updates
--=================================================
if exists (select * from sysobjects 
	where name like N'Match') 
	drop table Match
GO
--
--=================================================
if exists (select * from sysobjects 
	where name like N'MatchHead') 
	drop table MatchHead
GO
--

--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'Chunk')
	DROP TABLE Chunk
GO
--
--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'Segment')
	DROP TABLE Segment
GO
--
--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'OrigField')
	DROP TABLE OrigField
GO
--
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'OrigPhotoObjAll')
	DROP TABLE OrigPhotoObjAll
GO
--
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'TargPhotoObjAll')
	DROP TABLE TargPhotoObjAll
GO
--
IF EXISTS (SELECT name FROM sysobjects
        WHERE xtype='U' AND name = 'TargPhotoTag')
	DROP TABLE TargPhotoTag
GO
--
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'UberCal')
	DROP TABLE UberCal
GO
--
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'UberAstro')
	DROP TABLE UberAstro
GO
--
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'PsObjAll')
	DROP TABLE PsObjAll
GO
--

-- Spectro schema updates
--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SpecLineIndex')
	DROP TABLE SpecLineIndex
GO
--
--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'SpecLineAll')
	DROP TABLE SpecLineAll
GO
--
--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'XCRedshift')
	DROP TABLE XCRedshift
GO
--

--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'ELRedShift')
	DROP TABLE ELRedShift
GO
--

--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'HoleObj')
	DROP TABLE HoleObj
GO
--

--==================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'QsoCatalogAll')) 
	drop table [QsoCatalogAll]
GO


--==================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'QsoConcordanceAll')) 
	drop table [QsoConcordanceAll]
GO
 
IF EXISTS(SELECT * FROM sysobjects WHERE name = N'QsoTarget') 
          DROP TABLE QsoTarget
GO


IF EXISTS(SELECT * FROM sysobjects WHERE name = N'QsoBunch') 
     DROP TABLE QsoBunch
GO


IF EXISTS(SELECT * FROM sysobjects WHERE name = N'QsoBest') 
          DROP TABLE QsoBest
GO


IF EXISTS(SELECT * FROM sysobjects WHERE name = N'QsoSpec') 
          DROP TABLE QsoSpec
GO

if exists (select * from dbo.sysobjects 
	where id = object_id(N'DR3QuasarCatalog')) 
	drop table [DR3QuasarCatalog]
GO


if exists (select * from dbo.sysobjects 
	where id = object_id(N'DR5QuasarCatalog')) 
	drop table [DR5QuasarCatalog]
GO


if exists (select * from dbo.sysobjects 
	where id = object_id(N'[TableDesc]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TableDesc]
GO


If Exists (Select * From Dbo.Sysobjects 
	Where Id = Object_Id(N'[FieldQA ]') 
	And OBJECTPROPERTY(Id, N'IsUserTable') = 1)
Drop Table [FieldQA ]
GO


If Exists (Select * From Dbo.Sysobjects 
	Where Id = Object_Id(N'[Photoz2]') 
	And OBJECTPROPERTY(Id, N'IsUserTable') = 1)
Drop Table [Photoz2]
GO


If Exists (Select * From Dbo.Sysobjects 
	Where Id = Object_Id(N'[RunQA]') 
	And OBJECTPROPERTY(Id, N'IsUserTable') = 1)
Drop Table [RunQA]
GO


if exists (select * from dbo.sysobjects 
	where id = object_id(N'[BestTarget2Sector]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [BestTarget2Sector]
GO


if exists (select * from dbo.sysobjects 
	where id = object_id(N'[Sector2Tile]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Sector2Tile]
GO



--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCleanup' )
	DROP PROCEDURE spSectorCleanup
GO
--

--================================================================
IF  EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].spSectorLayerAssemble') 
		AND type in (N'P', N'PC'))
		DROP PROCEDURE [dbo].spSectorLayerAssemble
GO
--

--============================================================
IF  EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[spSectorLayerPartition]') 
		AND type in (N'P', N'PC'))
		DROP PROCEDURE [dbo].[spSectorLayerPartition]
GO
--

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateTileBoxes' )
	DROP PROCEDURE spSectorCreateTileBoxes
GO
--

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateSkyBoxes' )
	DROP PROCEDURE spSectorCreateSkyBoxes
GO
--


--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateWedges' )
	DROP PROCEDURE spSectorCreateWedges
GO
--

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateSectorlets' )
	DROP PROCEDURE spSectorCreateSectorlets
GO
--

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorCreateSectors' )
	DROP PROCEDURE spSectorCreateSectors
GO
--

--==================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].spSectorSubtractHoles') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].spSectorSubtractHoles
GO
--

--============================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = N'spSectorFillCompatibility' )
	DROP PROCEDURE spSectorFillCompatibility
GO
--

--=============================================
IF EXISTS (select * from dbo.sysobjects 
	where name = N'spSectorCreate' )
	drop procedure spSectorCreate
GO
--

--=================================================
if exists (select * from dbo.sysobjects
        where id = object_id(N'[dbo].[spSectorSetTargetRegionID]')
        and OBJECTPROPERTY(id, N'IsProcedure') = 1)
        drop procedure [dbo].[spSectorSetTargetRegionID]
GO
--

--=================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSectorFillBest2Sector]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spSectorFillBest2Sector]
GO
--


--===================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fGetNearestSpecObjIdEqType' )
	DROP FUNCTION fGetNearestSpecObjIdEqType
GO
--
