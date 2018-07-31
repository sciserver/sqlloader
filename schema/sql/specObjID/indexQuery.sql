SELECT 
     TableName = t.name,
     IndexName = ind.name,
     IndexId = ind.index_id,
     ColumnId = ic.index_column_id,
     ColumnName = col.name,
     ind.*,
     ic.*,
     col.* 
FROM 
     sys.indexes ind 
INNER JOIN 
     sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN 
     sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN 
     sys.tables t ON ind.object_id = t.object_id 
WHERE 
     --ind.is_primary_key = 0 
     --AND ind.is_unique = 0 
     --AND ind.is_unique_constraint = 0 
     t.is_ms_shipped = 0 
	 --and t.name = 'PhotoObjAll'
	 and col.name like 'SpecObjID'
	 and ind.type = 5  --clustered columnstore index
	 and col.system_type_id = 127  --127 is bigint
ORDER BY 
     t.name, ind.name, ind.index_id, ic.index_column_id;