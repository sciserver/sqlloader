


--- script to create tables in DR14x db

--0. make cursor for tablenames and filegroups
declare @sql nvarchar(max)
declare @indexsql nvarchar(max)
declare @pk int
declare @tablename sysname, @fgname sysname
declare @sourceDB sysname, @destDB sysname
declare @doExecute bit

set @sourceDB = 'BestDR13'
set @destDB = 'DR13x'

set @doExecute = 1

/*
select * from suedb.dbo.dr14xIndexInfo

update suedb.dbo.dr14xIndexInfo
set indexStatus = 0

update suedb.dbo.dr14xIndexInfo
set indexStatus = 1
where tablename = 'SpecObjAll'




*/
set nocount on


declare cur cursor fast_forward for 
select pk, tablename, indexsql from suedb.dbo.dr14xIndexInfo
--where sourceFG = 'DATAFG'
where indexID = 1
and indexstatus = 0

open cur
fetch next from cur into @pk, @tablename, @indexsql
while @@FETCH_STATUS = 0
begin
	
	if (@doExecute = 1)
		update sueDB.dbo.dr14xIndexInfo
		set IndexStatus = 1 --in progress
		where pk = @pk
	-------------------------------
	-- 1. create empty tables in new DB using select into
	
	if exists (select * from sys.tables where name = @tablename)
	begin
		set @sql = 'use ' + @destDB +';drop table ' + @tablename
			print @sql
		if @doExecute = 1
			exec sp_executesql @sql
	end

	set @sql = concat('use ', @destDB, ';select * into ',@tablename,' from ' ,@sourceDB,'.dbo.',@tablename,' where 0=1')
	print @sql
	if @doExecute = 1
		exec sp_executesql @sql
	
	------------------------------
	-- 2. put clustered indexes on new table
		set @sql = concat('use ', @destDB, ';',@indexsql)
	print @sql
	if @doExecute = 1
		exec sp_executesql @sql

	-------------------------------
	-- 3. add data to new table
	
	set @sql = concat('use ', @destDB, ';insert ',@tablename,' with (tablock)', 'select * from ' ,@sourceDB,'.dbo.',@tablename,' with (nolock)')
	print @sql
	if @doExecute = 1
		exec sp_executesql @sql

	
	

	---------------------------------
	---- 4. add nonclustered indexes to new table

	--set @sql = concat('use ', @destDB, ';',@indexsql)
	--print @sql
	--if @doExecute = 1
	--	exec sp_executesql @sql 

	--get next table/index
	
	if (@doExecute = 1)

		update sueDB.dbo.DR14xIndexInfo
		set IndexStatus = 2 --done
		where pk = @pk
	
	fetch next from cur into @pk, @tablename,  @indexsql
end

close cur
deallocate cur

/*
declare cur cursor for
select TableName, IndexName, IndexSQL, pk from SueDB.dbo.DR14xIndexInfo
where IndexID > 1
and IndexStatus <> 2

open cur
fetch next from cur
into @TableName, @IndexName, @sql, @pk

while (@@FETCH_STATUS=0) begin

	
		update SueDB.dbo.DR14xIndexInfo
	set IndexStatus = 1 --in progress
	where pk = @pk

	print @sql
	print @pk 
	
	exec sp_executesql @sql

	update sueDB.dbo.SueDB.dbo.DR14xIndexInfo
	set IndexStatus = 2 --done
	where pk = @pk

	print '----'

	fetch next from cur
	into @tableName, @indexName, @sql, @pk
end

close cur
deallocate cur
*/
/*
update suedb.dbo.dr14xindexinfo
set indexstatus = 0

select * from suedb.dbo.dr14xindexinfo
where indexID > 1
where sourceFG = 'SPEC'

update suedb.dbo.dr14xindexinfo
set destFG = 'DATAFG'
where tablename = 'DataConstants'

update suedb.dbo.dr14xindexinfo
set IndexStatus = 0
where tablename = 'SpecObjAll'
and indexID > 1
*/

/*
select * from suedb.dbo.drxtables
where indexgroup = 'SPECTRO'


select dt.tablename, dt.indexgroup, dt.common, di.sourceFG
into #spectab
from suedb.dbo.drxtables dt
join suedb.dbo.Dr14xindexinfo di
on di.tablename = dt.tablename
where di.indexid = 1
and dt.common = 0
and dt.indexgroup = 'SPECTRO'

update suedb.dbo.DR14xindexinfo
set destfg = 'SPEC'
where tablename in
(select tablename from #spectab)

*/






