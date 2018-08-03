declare @sql nvarchar(max)
declare @tablename sysname
declare @indexname sysname

declare cur cursor for

select tablename, indexname
from tempdb.dbo.specPKs

--SELECT      c.name  AS 'ColumnName'
--            ,t.name AS 'TableName'
--			--c.system_type_id
--FROM        sys.columns c
--JOIN        sys.tables  t   ON c.object_id = t.object_id
--WHERE       c.name LIKE 'SpecObjID%'
--and t.name not like '%DR7%'
--and c.system_type_id = 127
--ORDER BY    TableName
--            ,ColumnName;



/*
exec sp_whoisactive

DROP INDEX [dbo].[zooConfidence].[i_zooConfidence_objID]
DROP INDEX [dbo].[zooSpec].[i_zooSpec_objID]
*/

open cur
fetch next from cur into @tablename, @indexname 
while (@@FETCH_STATUS=0)
begin

	set @sql = 'ALTER TABLE [' + @tablename + '] drop constraint ' + @indexname

	print @sql

	set @sql = 'ALTER TABLE [' + @tablename +']  ALTER COLUMN [SpecObjID] NUMERIC(20) NOT NULL'

	print @sql

	fetch next from cur into @tablename, @indexname
end

close cur
deallocate cur




