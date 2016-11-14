



declare @sql nvarchar(max)
declare @tablename sysname
declare @indexname sysname

declare cur cursor for
select tablename from indexmap2
where code = 'K' and compression = 'page'

open cur

fetch next from cur into @tablename 
while @@FETCH_STATUS=0
begin
	




	set @sql = 'create clustered columnstore index ' +@indexname + ' on ' + @tablename + ' with (DROP_EXISTING = ON)'
	
	print @sql
	exec sp_executesql @sql


	fetch next from cur into @tablename
end

close cur
deallocate cur