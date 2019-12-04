


checkpoint;
go


print '-----------------------------------------------'
print '-------------clustered and insert--------------'
print '-----------------------------------------------'


---------------------------------
declare @sql varchar(max)
declare @id int
declare @tablename sysname
declare @code varchar(2)

declare cur cursor for 
select indexmapid, tablename, code from indexMap
where (tableName like 'apogee%'
or tablename like 'aspcap%')
and code = 'K'
order by tablename


open cur
fetch next from cur into @id, @tablename, @code

while @@fetch_status = 0
begin
	exec spIndexCreate_print 0,0,@id

		
	print ''
	print 'insert [BestDR16].[dbo].[' + @tablename + '] with (tablock) ' +
	' select * from [BESTTEST].[dbo].[' +@tablename + '] '

	print ''
	print ''
	fetch next from cur into @id, @tablename, @code
end
close cur
deallocate cur
go


print '-----------------------------------------------'
print '--------------- non clustered -----------------'
print '-----------------------------------------------'


---------------------------------
declare @sql varchar(max)
declare @id int
declare @tablename sysname
declare @code varchar(2)

declare cur cursor for 
select indexmapid, tablename, code from indexMap
where (tableName like 'apogee%'
or tablename like 'aspcap%')
and code = 'I'
order by tablename


open cur
fetch next from cur into @id, @tablename, @code

while @@fetch_status = 0
begin
	exec spIndexCreate_print 0,0,@id

	fetch next from cur into @id, @tablename, @code
end
close cur
deallocate cur


----------------------------------
