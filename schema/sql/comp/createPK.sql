



declare @sql nvarchar(max)
declare @tablename sysname
declare @indexname sysname
declare @fieldlist sysname

declare cur cursor for
--select tablename from indexmap2
--where code = 'K' and compression = 'page'
----and indexmapid > 104

	select t.name, i2.fieldlist from sys.indexes i
	join sys.tables t
	on t.object_id=i.object_id
	join indexmap2 i2 on i2.tablename = t.name
	where i2.compression = 'page' and i2.code = 'K'
	and i.type_desc = 'HEAP'

open cur

fetch next from cur into @tablename, @fieldlist
while @@FETCH_STATUS=0
begin
	

	set @fieldList  = REPLACE(@fieldList,' ','')

	--set @sql = 'create clustered columnstore index cci_' +@tablename + ' on ' + @tablename 
	set @sql = 'alter table ' + @tablename + ' add constraint pk_' + @tablename +  ' primary key clustered ('+ @fieldlist +') with (data_compression = page)'
	
	print @sql
	exec sp_executesql @sql


	fetch next from cur into @tablename, @fieldlist
end

close cur
deallocate cur