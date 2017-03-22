DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'
ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(f.parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(f.parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(f.name) + ';'
FROM sys.foreign_keys f
--join tempdb.dbo.ccitables t
--on f.parent_object_id =object_id(t.table_name)

PRINT @sql;
-- EXEC sp_executesql @sql;


--select * from sys.foreign_keys







ALTER TABLE [dbo].[AtlasOutline] DROP CONSTRAINT [fk_AtlasOutline_objID_PhotoObjAl];
ALTER TABLE [dbo].[Frame] DROP CONSTRAINT [fk_Frame_fieldID_Field_fieldID];
ALTER TABLE [dbo].[Photoz] DROP CONSTRAINT [fk_Photoz_objID_PhotoObjAll_objI];
ALTER TABLE [dbo].[SpecObjAll] DROP CONSTRAINT [fk_SpecObjAll_plateID_PlateX_pla];
ALTER TABLE [dbo].[mangaDrpAll] DROP CONSTRAINT [fk_mangaDrpAll_mangaID_mangaTarg];
ALTER TABLE [dbo].[TargetInfo] DROP CONSTRAINT [fk_TargetInfo_targetID_Target_ta];
ALTER TABLE [dbo].[sdssTileAll] DROP CONSTRAINT [fk_sdssTileAll_tileRun_sdssTilin];
ALTER TABLE [dbo].[sdssTilingGeometry] DROP CONSTRAINT [fk_sdssTilingGeometry_tileRun_sd];
ALTER TABLE [dbo].[RegionPatch] DROP CONSTRAINT [fk_RegionPatch_regionID_Region_r];
ALTER TABLE [dbo].[DBColumns] DROP CONSTRAINT [fk_DBColumns_tablename_DBObjects];
ALTER TABLE [dbo].[DBViewCols] DROP CONSTRAINT [fk_DBViewCols_viewname_DBObjects];
ALTER TABLE [dbo].[IndexMap] DROP CONSTRAINT [fk_IndexMap_tableName_DBObjects_];
ALTER TABLE [dbo].[FileGroupMap] DROP CONSTRAINT [fk_FileGroupMap_tableFileGroup_P];
ALTER TABLE [dbo].[Inventory] DROP CONSTRAINT [fk_Inventory_name_DBObjects_name];

ALTER TABLE [dbo].[PhotoObjAll] DROP CONSTRAINT [fk_PhotoObjAll_fieldID_Field_fie];
ALTER TABLE [dbo].[PhotoProfile] DROP CONSTRAINT [fk_PhotoProfile_objID_PhotoObjAl];
ALTER TABLE [dbo].[detectionIndex] DROP CONSTRAINT [fk_detectionIndex_thingID_thingI];
ALTER TABLE [dbo].[thingIndex] DROP CONSTRAINT [fk_thingIndex_sdssPolygonID_sdss];
ALTER TABLE [dbo].[FieldProfile] DROP CONSTRAINT [fk_FieldProfile_fieldID_Field_fi];
ALTER TABLE [dbo].[ProperMotions] DROP CONSTRAINT [fk_ProperMotions_objID_PhotoObjA];
ALTER TABLE [dbo].[MaskedObject] DROP CONSTRAINT [fk_MaskedObject_objID_PhotoObjAl];
ALTER TABLE [dbo].[MaskedObject] DROP CONSTRAINT [fk_MaskedObject_maskID_Mask_mask];
ALTER TABLE [dbo].[zoo2MainSpecz] DROP CONSTRAINT [fk_zoo2MainSpecz_dr8objid_PhotoO];
ALTER TABLE [dbo].[zoo2Stripe82Coadd1] DROP CONSTRAINT [fk_zoo2Stripe82Coadd1_dr8objid_P];
ALTER TABLE [dbo].[zoo2Stripe82Coadd2] DROP CONSTRAINT [fk_zoo2Stripe82Coadd2_dr8objid_P];
ALTER TABLE [dbo].[zoo2Stripe82Normal] DROP CONSTRAINT [fk_zoo2Stripe82Normal_dr8objid_P];
ALTER TABLE [dbo].[sdssTilingInfo] DROP CONSTRAINT [fk_sdssTilingInfo_tileRun_sdssTi];
ALTER TABLE [dbo].[HalfSpace] DROP CONSTRAINT [fk_HalfSpace_regionID_Region_reg];
ALTER TABLE [dbo].[RegionArcs] DROP CONSTRAINT [fk_RegionArcs_regionID_Region_re];
ALTER TABLE [dbo].[Zone] DROP CONSTRAINT [fk_Zone_objID_PhotoObjAll_objID];
ALTER TABLE [dbo].[neighbors] DROP CONSTRAINT [fk_Neighbors_objID_PhotoObjAll_o];
ALTER TABLE [dbo].[SpecPhotoAll] DROP CONSTRAINT [fk_SpecPhotoAll_specObjID_SpecOb];
