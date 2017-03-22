

DECLARE @indexName NVARCHAR(128)
DECLARE @sql NVARCHAR(4000)
declare @tablename sysname
declare @indid int



declare tablecursor cursor for
select table_name from tempdb.dbo.ccitables

open tablecursor
fetch next from tablecursor into @tablename
while @@fetch_status = 0
begin



	set @sql = 'create clustered columnstore index cci_' +@tablename + ' on ' + @tablename
	print @sql
	exec sp_executesql @sql

fetch next from tablecursor into @tablename
end


close tablecursor
deallocate tablecursor



