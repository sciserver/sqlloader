

DECLARE @indexName NVARCHAR(128)
DECLARE @dropIndexSql NVARCHAR(4000)
declare @tablename sysname
declare @indid int



declare tablecursor cursor for
select table_name from tempdb.dbo.ccitables

open tablecursor
fetch next from tablecursor into @tablename
while @@fetch_status = 0
begin



DECLARE tableIndexes CURSOR FOR
SELECT name, indid FROM sysindexes
WHERE id = OBJECT_ID(@tablename) AND 
  indid > 0 AND indid < 255 AND
  INDEXPROPERTY(id, name, 'IsStatistics') = 0
ORDER BY indid DESC



OPEN tableIndexes
FETCH NEXT FROM tableIndexes INTO @indexName, @indid
WHILE @@fetch_status = 0
BEGIN
  if (@indid = 1)
	set @dropIndexSql = 'ALTER TABLE ' + @tablename + ' DROP CONSTRAINT ' + @indexname
else 
  SET @dropIndexSql = N'DROP INDEX '+@tablename+'.' + @indexName
  --EXEC sp_executesql @dropIndexSql
  print @dropIndexSql

  FETCH NEXT FROM tableIndexes INTO @indexName, @indid
END
CLOSE tableIndexes
DEALLOCATE tableIndexes
fetch next from tablecursor into @tablename
end


close tablecursor
deallocate tablecursor



