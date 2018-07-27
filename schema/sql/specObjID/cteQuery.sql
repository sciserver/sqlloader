SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName',
			c.system_type_id
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%SpecObjID%'
and c.system_type_id = 127
ORDER BY    TableName
            ,ColumnName;


			with cteIndexes(TableName, IndexName, IndexType, ColType)
as (
SELECT 
     TableName = t.name,
     IndexName = ind.name,
	 IndexType = ind.type,
	 ColType = col.system_type_id

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
	 --and ind.type = 5  --clustered columnstore index
	-- and col.system_type_id = 127  --127 is bigint
)
select ctei.Tablename
--select @sql = 'ALTER TABLE ' + ctei.TableName + ' ALTER COLUMN [SpecObjID] NUMERIC(20) NOT NULL'
from cteIndexes ctei
--where ctei.IndexType = 5
 where ctei.colType = 127