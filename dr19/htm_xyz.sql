/*
alter table dr19_target
add htmid as dbo.fhtmeq(ra, dec) persisted

create nonclustered index ix_target_htmid
on dr19_target(htmid)

alter table dr19_target
add cx float


alter table dr19_target
add cy float

alter table dr19_target
add cz float
*/

declare @doExecute bit

set @doExecute = 0

declare @tablename sysname
declare @sql nvarchar(1000)

declare cur cursor for 
SELECT    distinct TABLE_NAME AS  'TableName'
FROM        INFORMATION_SCHEMA.COLUMNS
WHERE       COLUMN_NAME LIKE 'ra' or column_name like 'dec'
and table_name not like 'dr19_target'
and table_name not like 'dr19_best_brightest'
and table_name not like 'dr19_allwise'
ORDER BY    TableName

open cur
fetch next from cur into @tablename

while @@fetch_status = 0
begin
	select @sql = concat('alter table ', @tablename ,' add htmid as dbo.fhtmeq(ra, dec) persisted')
	print @sql
	if (@doExecute=1)
		exec sp_executesql @sql

	select @sql = concat('create nonclustered index ix_', @tablename,'_htmid on ',@tablename,'(htmid)')
	print @sql
	if (@doExecute=1)
		exec sp_executesql @sql
/*
	select @sql = concat('alter table ',@tablename,' add cx float')
	print @sql
	if (@doExecute=1)
		exec sp_executesql @sql

	select @sql = concat('alter table ',@tablename,' add cy float')
	print @sql
	if (@doExecute=1)
		exec sp_executesql @sql

	select @sql = concat('alter table ',@tablename,' add cz float')
	print @sql
	if (@doExecute=1)
		exec sp_executesql  @sql
*/

	fetch next from cur into @tablename
end

close cur
deallocate cur
