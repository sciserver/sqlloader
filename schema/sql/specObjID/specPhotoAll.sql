USE [BestDR13_Compressed]
GO

/****** Object:  Table [dbo].[SpecPhotoAll]    Script Date: 3/10/2017 2:43:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SpecPhotoAll2](
	[specObjID] numeric(20) NOT NULL,
	[mjd] [int] NOT NULL,
	[plate] [smallint] NOT NULL,
	[tile] [smallint] NOT NULL,
	[fiberID] [smallint] NOT NULL,
	[z] [real] NOT NULL,
	[zErr] [real] NOT NULL,
	[class] [varchar](32) NOT NULL,
	[subClass] [varchar](32) NOT NULL,
	[zWarning] [int] NOT NULL,
	[ra] [float] NOT NULL,
	[dec] [float] NOT NULL,
	[cx] [float] NOT NULL,
	[cy] [float] NOT NULL,
	[cz] [float] NOT NULL,
	[htmID] [bigint] NOT NULL,
	[sciencePrimary] [smallint] NOT NULL,
	[legacyPrimary] [smallint] NOT NULL,
	[seguePrimary] [smallint] NOT NULL,
	[segue1Primary] [smallint] NOT NULL,
	[segue2Primary] [smallint] NOT NULL,
	[bossPrimary] [smallint] NOT NULL,
	[sdssPrimary] [smallint] NOT NULL,
	[survey] [varchar](32) NOT NULL,
	[programname] [varchar](32) NOT NULL,
	[legacy_target1] [bigint] NOT NULL,
	[legacy_target2] [bigint] NOT NULL,
	[special_target1] [bigint] NOT NULL,
	[special_target2] [bigint] NOT NULL,
	[segue1_target1] [bigint] NOT NULL,
	[segue1_target2] [bigint] NOT NULL,
	[segue2_target1] [bigint] NOT NULL,
	[segue2_target2] [bigint] NOT NULL,
	[boss_target1] [bigint] NOT NULL,
	[ancillary_target1] [bigint] NOT NULL,
	[ancillary_target2] [bigint] NOT NULL,
	[plateID] [bigint] NOT NULL,
	[sourceType] [varchar](32) NOT NULL,
	[targetObjID] [bigint] NOT NULL,
	[objID] [bigint] NULL,
	[skyVersion] [int] NULL,
	[run] [int] NULL,
	[rerun] [int] NULL,
	[camcol] [int] NULL,
	[field] [int] NULL,
	[obj] [int] NULL,
	[mode] [int] NULL,
	[nChild] [int] NULL,
	[type] [int] NULL,
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
	[fiberMag_u] [real] NULL,
	[fiberMag_g] [real] NULL,
	[fiberMag_r] [real] NULL,
	[fiberMag_i] [real] NULL,
	[fiberMag_z] [real] NULL,
	[fiberMagErr_u] [real] NULL,
	[fiberMagErr_g] [real] NULL,
	[fiberMagErr_r] [real] NULL,
	[fiberMagErr_i] [real] NULL,
	[fiberMagErr_z] [real] NULL,
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
	[cModelMag_u] [real] NULL,
	[cModelMag_g] [real] NULL,
	[cModelMag_r] [real] NULL,
	[cModelMag_i] [real] NULL,
	[cModelMag_z] [real] NULL,
	[cModelMagErr_u] [real] NULL,
	[cModelMagErr_g] [real] NULL,
	[cModelMagErr_r] [real] NULL,
	[cModelMagErr_i] [real] NULL,
	[cModelMagErr_z] [real] NULL,
	[mRrCc_r] [real] NULL,
	[mRrCcErr_r] [real] NULL,
	[score] [real] NULL,
	[resolveStatus] [int] NULL,
	[calibStatus_u] [int] NULL,
	[calibStatus_g] [int] NULL,
	[calibStatus_r] [int] NULL,
	[calibStatus_i] [int] NULL,
	[calibStatus_z] [int] NULL,
	[photoRa] [float] NULL,
	[photoDec] [float] NULL,
	[extinction_u] [real] NULL,
	[extinction_g] [real] NULL,
	[extinction_r] [real] NULL,
	[extinction_i] [real] NULL,
	[extinction_z] [real] NULL,
	[fieldID] [bigint] NULL,
	[dered_u] [real] NULL,
	[dered_g] [real] NULL,
	[dered_r] [real] NULL,
	[dered_i] [real] NULL,
	[dered_z] [real] NULL,
 CONSTRAINT [pk_SpecPhotoAll2_specObjID] PRIMARY KEY CLUSTERED 
(
	[specObjID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION=PAGE) ON [SPEC]
) ON [SPEC]

GO


dbcc traceon(610)
insert specPhotoAll2 with (tablock)
select * from SpecPhotoAll
order by SpecObjID

drop table SpecPhotoAll

exec sp_rename 'SpecPhotoAll2', 'SpecPhotoAll'


CREATE NONCLUSTERED INDEX [i_SpecPhotoAll_objID_sciencePrim] ON [dbo].[SpecPhotoAll](objID ASC, sciencePrimary ASC, class ASC, z ASC, targetObjID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, 
IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 
CREATE NONCLUSTERED INDEX [i_SpecPhotoAll_targetObjID_scien] ON [dbo].[SpecPhotoAll](targetObjID ASC, sciencePrimary ASC, class ASC, z ASC, objID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, 
IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 


 CREATE NONCLUSTERED INDEX [i_SpecObjAll_fluxObjID] ON [dbo].[SpecObjAll](fluxObjID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 
CREATE NONCLUSTERED INDEX [i_SpecObjAll_htmID_ra_dec_cx_cy_] ON [dbo].[SpecObjAll](htmID ASC, ra ASC, dec ASC, cx ASC, cy ASC, cz ASC, sciencePrimary ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 
CREATE NONCLUSTERED INDEX [i_SpecObjAll_ra_dec_class_plat] ON [dbo].[SpecObjAll](ra ASC, dec ASC, class ASC, plate ASC, tile ASC, z ASC, zErr ASC, sciencePrimary ASC, plateID ASC, bestObjID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 
CREATE NONCLUSTERED INDEX [i_SpecObjAll_targetObjID_sourceT] ON [dbo].[SpecObjAll](targetObjID ASC, sourceType ASC, sciencePrimary ASC, class ASC, htmID ASC, ra ASC, dec ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB = ON, FILLFACTOR = 100) ON [SPEC];
 
