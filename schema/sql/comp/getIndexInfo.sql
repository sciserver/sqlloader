


select schema_name(t.schema_id) [schema_name], t.name as tablename, ix.name as indexname,
 case when ix.is_unique = 1 then 'UNIQUE ' else '' END 
 , ix.type_desc,
 case when ix.is_padded=1 then 'PAD_INDEX = ON, ' else 'PAD_INDEX = OFF, ' end
 + case when ix.allow_page_locks=1 then 'ALLOW_PAGE_LOCKS = ON, ' else 'ALLOW_PAGE_LOCKS = OFF, ' end
 + case when ix.allow_row_locks=1 then  'ALLOW_ROW_LOCKS = ON, ' else 'ALLOW_ROW_LOCKS = OFF, ' end
 + case when INDEXPROPERTY(t.object_id, ix.name, 'IsStatistics') = 1 then 'STATISTICS_NORECOMPUTE = ON, ' else 'STATISTICS_NORECOMPUTE = OFF, ' end
 + case when ix.ignore_dup_key=1 then 'IGNORE_DUP_KEY = ON, ' else 'IGNORE_DUP_KEY = OFF, ' end
 + 'DROP_EXISTING = ON, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE'  AS IndexOptions
 , ix.is_disabled , FILEGROUP_NAME(ix.data_space_id) FileGroupName,
 p.data_compression_desc as [Compression]
 from sys.tables t 
 inner join sys.indexes ix on t.object_id=ix.object_id
 inner join sys.partitions p on t.object_id = p.object_id and ix.index_id = p.index_id
 where 
 --ix.type>0 
 ix.type >= 1
 --ix.type = 1
 --and ix.is_primary_key=0 and ix.is_unique_constraint=0 
 --and schema_name(tb.schema_id)= @SchemaName and tb.name=@TableName

 and t.is_ms_shipped=0 and t.name<>'sysdiagrams'
 --and FILEGROUP_NAME(ix.data_space_id) = @srcFG
 order by schema_name(t.schema_id), t.name, ix.name


 select * from suedb.dbo.DR15_IndexMap2
 where code = 'K'
 and indexgroup <> 'META'