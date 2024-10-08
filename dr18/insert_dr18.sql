
USE BestDR17
-- ###################
-- 
-- load dr18 tables from minidb2 
-- the quick n dirty way
-- 
-- ####################

--select * from filesToLoad2

/*
update filesToLoad2
set loadStatus = 9 where id = 59

select count(*) from filestoload2
where loadStatus = 9

update minidb2.dbo.filestoload2
set loadSTatus = 0

*/
----------------------------------------------
-- set these!!!!
declare @doExecute bit = 1
declare @truncate bit = 0
-----------------------------------------------

declare @sql nvarchar(4000)
declare @id int
declare @fname nvarchar(2000)
declare @targettable sysname
declare @dr18table sysname


declare cur cursor fast_forward for 
select id, fname, targettable from minidb2.dbo.filestoload2
where loadStatus = 0

open cur
fetch next from cur into @id, @fname, @targettable
while @@FETCH_STATUS = 0
begin

set @dr18table = replace(@targettable, 'dr18_', 'mos_')

/*
BULK INSERT Sales.Orders
FROM '\\SystemX\DiskZ\Sales\data\orders.csv'
WITH ( FORMAT = 'CSV');
*/
	set @sql = ''
	if @truncate = 1
		set @sql = concat('TRUNCATE TABLE ',@dr18table,';')
	--BULK INSERT dr18_allwise FROM 'd:\dr18loading\minidb\csv\minidb.dr18_allwise.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', rowterminator='0x0a');

	set @sql = concat(@sql, 'INSERT ', @dr18table, ' WITH (TABLOCK) SELECT * FROM minidb2.dbo.' ,@targettable)
	--set @sql = concat(@sql, 'BULK INSERT ', @targettable, ' FROM ''', @fname, ''' WITH (DATAFILETYPE=''char'', FIRSTROW=2, FIELDTERMINATOR='','', ROWTERMINATOR=''0x0a'', TABLOCK);','
	--')
	print @sql
	if (@doExecute = 1)
	begin
		begin tran
			exec sp_executesql @sql
			set @sql = concat('update minidb2.dbo.filestoload2 set lastLoadDate=''',GETDATE(),''', loadStatus=2 WHERE id=',@id,'
			')
			print @sql
			exec sp_executesql @sql
		commit tran
	end


	
	fetch next from cur into @id, @fname, @targettable
	
end

close cur
deallocate cur



