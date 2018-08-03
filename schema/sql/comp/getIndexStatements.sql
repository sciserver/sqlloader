declare @SchemaName varchar(100)declare @TableName varchar(256)
declare @IndexName varchar(256)
declare @ColumnName varchar(100)
declare @is_unique varchar(100)
declare @IndexTypeDesc varchar(100)
declare @FileGroupName varchar(100)
declare @is_disabled varchar(100)
declare @IndexOptions varchar(max)
declare @IndexColumnId int
declare @IsDescendingKey int 
declare @IsIncludedColumn int
declare @TSQLScripCreationIndex varchar(max)
declare @TSQLScripDisableIndex varchar(max)


declare @srcFG sysname
declare @destFG sysname

set @srcFG =  'PRIMARY'
set @destFG = 'SPEC'

declare CursorIndex cursor for
 select schema_name(t.schema_id) [schema_name], t.name, ix.name,
 case when ix.is_unique = 1 then 'UNIQUE ' else '' END 
 , ix.type_desc,
 case when ix.is_padded=1 then 'PAD_INDEX = ON, ' else 'PAD_INDEX = OFF, ' end
 + case when ix.allow_page_locks=1 then 'ALLOW_PAGE_LOCKS = ON, ' else 'ALLOW_PAGE_LOCKS = OFF, ' end
 + case when ix.allow_row_locks=1 then  'ALLOW_ROW_LOCKS = ON, ' else 'ALLOW_ROW_LOCKS = OFF, ' end
 + case when INDEXPROPERTY(t.object_id, ix.name, 'IsStatistics') = 1 then 'STATISTICS_NORECOMPUTE = ON, ' else 'STATISTICS_NORECOMPUTE = OFF, ' end
 + case when ix.ignore_dup_key=1 then 'IGNORE_DUP_KEY = ON, ' else 'IGNORE_DUP_KEY = OFF, ' end
 + 'DROP_EXISTING = ON, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE'  AS IndexOptions
 , ix.is_disabled , FILEGROUP_NAME(ix.data_space_id) FileGroupName
 from sys.tables t 
 inner join sys.indexes ix on t.object_id=ix.object_id
 where 
 --ix.type>0 
 --ix.type > 1
 ix.type >= 1
 --and ix.is_primary_key=0 and ix.is_unique_constraint=0 
 --and schema_name(tb.schema_id)= @SchemaName and tb.name=@TableName
 and t.is_ms_shipped=0 and t.name<>'sysdiagrams'
 and FILEGROUP_NAME(ix.data_space_id) = @srcFG
 order by schema_name(t.schema_id), t.name, ix.name

open CursorIndex
fetch next from CursorIndex into  @SchemaName, @TableName, @IndexName, @is_unique, @IndexTypeDesc, @IndexOptions,@is_disabled, @FileGroupName

while (@@fetch_status=0)
begin
 declare @IndexColumns varchar(max)
 declare @IncludedColumns varchar(max)
 
 set @IndexColumns=''
 set @IncludedColumns=''
 
 declare CursorIndexColumn cursor for 
  select col.name, ixc.is_descending_key, ixc.is_included_column
  from sys.tables tb 
  inner join sys.indexes ix on tb.object_id=ix.object_id
  inner join sys.index_columns ixc on ix.object_id=ixc.object_id and ix.index_id= ixc.index_id
  inner join sys.columns col on ixc.object_id =col.object_id  and ixc.column_id=col.column_id
  where ix.type>0 and (ix.is_primary_key=0 or ix.is_unique_constraint=0)
  and schema_name(tb.schema_id)=@SchemaName and tb.name=@TableName and ix.name=@IndexName
  order by ixc.index_column_id
 
 open CursorIndexColumn 
 fetch next from CursorIndexColumn into  @ColumnName, @IsDescendingKey, @IsIncludedColumn
 
 while (@@fetch_status=0)
 begin
  if @IsIncludedColumn=0 
   set @IndexColumns=@IndexColumns + @ColumnName  + case when @IsDescendingKey=1  then ' DESC, ' else  ' ASC, ' end
  else 
   set @IncludedColumns=@IncludedColumns  + @ColumnName  +', ' 

  fetch next from CursorIndexColumn into @ColumnName, @IsDescendingKey, @IsIncludedColumn
 end

 close CursorIndexColumn
 deallocate CursorIndexColumn

 set @IndexColumns = substring(@IndexColumns, 1, len(@IndexColumns)-1)
 set @IncludedColumns = case when len(@IncludedColumns) >0 then substring(@IncludedColumns, 1, len(@IncludedColumns)-1) else '' end
 --  print @IndexColumns
 --  print @IncludedColumns

 set @TSQLScripCreationIndex =''
 set @TSQLScripDisableIndex =''
 set @TSQLScripCreationIndex='CREATE '+ @is_unique  +@IndexTypeDesc + ' INDEX ' +QUOTENAME(@IndexName)+' ON ' + QUOTENAME(@SchemaName) +'.'+ QUOTENAME(@TableName)+ '('+@IndexColumns+') '+ 
  case when len(@IncludedColumns)>0 then CHAR(13) +'INCLUDE (' + @IncludedColumns+ ')' else '' end + CHAR(13)+'WITH (' + @IndexOptions+ ') ON ' + QUOTENAME(@destFG) + ';'  

 if @is_disabled=1 
  set  @TSQLScripDisableIndex=  CHAR(13) +'ALTER INDEX ' +QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@SchemaName) +'.'+ QUOTENAME(@TableName) + ' DISABLE;' + CHAR(13) 

 print @TSQLScripCreationIndex
 print @TSQLScripDisableIndex

 fetch next from CursorIndex into  @SchemaName, @TableName, @IndexName, @is_unique, @IndexTypeDesc, @IndexOptions,@is_disabled, @FileGroupName

end
close CursorIndex
deallocate CursorIndex

/*
-- create CIs on new FG


CREATE UNIQUE CLUSTERED INDEX [pk_apogeePlate_plate_visit_id] ON [dbo].[apogeePlate](plate_visit_id ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_DataConstants_field_name] ON [dbo].[DataConstants](field ASC, name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_DBColumns_tableName_name] ON [dbo].[DBColumns](tablename ASC, name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_DBObjects_name] ON [dbo].[DBObjects](name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_DBViewCols_viewName_name] ON [dbo].[DBViewCols](name ASC, viewname ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_Dependency_parent_child] ON [dbo].[Dependency](parent ASC, child ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_Diagnostics_name] ON [dbo].[Diagnostics](name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_FileGroupMap_tableName] ON [dbo].[FileGroupMap](tableName ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_History_id] ON [dbo].[History](id ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_IndexMap_indexmapid] ON [dbo].[IndexMap](indexmapid ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_Inventory_filename_name] ON [dbo].[Inventory](filename ASC, name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_LoadHistory_loadVersion_tStar] ON [dbo].[LoadHistory](loadversion ASC, tstart ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_mangaDrpAll_plateIFU] ON [dbo].[mangaDrpAll](plateifu ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_mangaTarget_mangaID] ON [dbo].[mangatarget](mangaID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_marvelsStar_STARNAME_PLATE] ON [dbo].[marvelsStar](STARNAME ASC, Plate ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_PartitionMap_fileGroupName] ON [dbo].[PartitionMap](fileGroupName ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_Photoz_objID] ON [dbo].[Photoz](objID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_PlateX_plateID] ON [dbo].[PlateX](plateID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_ProfileDefs_bin] ON [dbo].[ProfileDefs](bin ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_PubHistory_name_loadversion] ON [dbo].[PubHistory](name ASC, loadversion ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_qsoVarPTF_VAR_OBJID] ON [dbo].[qsoVarPTF](VAR_OBJID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_qsoVarStripe_VAR_OBJID] ON [dbo].[qsoVarStripe](VAR_OBJID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_QueryResults_query_time] ON [dbo].[QueryResults](query ASC, time ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_RC3_objID] ON [dbo].[RC3](objID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_RecentQueries_ipAddr_lastQuer] ON [dbo].[RecentQueries](ipAddr ASC, lastQueryTime ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_Region_regionId] ON [dbo].[Region](regionid ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_RegionPatch_regionid_convexid] ON [dbo].[RegionPatch](regionid ASC, convexid ASC, patchid ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_RMatrix_mode_row] ON [dbo].[Rmatrix](mode ASC, row ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_Rosat_objID] ON [dbo].[ROSAT](OBJID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_RunShift_run] ON [dbo].[RunShift](run ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_SDSSConstants_name] ON [dbo].[SDSSConstants](name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_sdssImagingHalfspaces_sdssPol] ON [dbo].[sdssImagingHalfSpaces](sdssPolygonID ASC, x ASC, y ASC, z ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_sdssTargetParam_targetVersion] ON [dbo].[sdssTargetParam](targetVersion ASC, paramFile ASC, name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_sdssTileAll_tile] ON [dbo].[sdssTileAll](tile ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_sdssTilingGeometry_tilingGeom] ON [dbo].[sdssTilingGeometry](tilingGeometryID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_sdssTilingRun_tileRun] ON [dbo].[sdssTilingRun](tileRun ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_SiteConstants_name] ON [dbo].[SiteConstants](name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_SiteDiagnostics_name] ON [dbo].[SiteDiagnostics](name ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_StripeDefs_stripe] ON [dbo].[StripeDefs](stripe ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_Target_targetID] ON [dbo].[Target](targetID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_TargetInfo_skyVersion_targetI] ON [dbo].[TargetInfo](targetID ASC, skyVersion ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_Versions_version] ON [dbo].[Versions](version ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_zooMirrorBias_dr7objid] ON [dbo].[zooMirrorBias](dr7objid ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_zooMonochromeBias_dr7objid] ON [dbo].[zooMonochromeBias](dr7objid ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 
CREATE UNIQUE CLUSTERED INDEX [pk_zooNoSpec_dr7objid] ON [dbo].[zooNoSpec](dr7objid ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [DATA];
 

*/