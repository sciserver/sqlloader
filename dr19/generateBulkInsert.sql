

-- ###################
-- 
-- load dr18 csv files 
-- the quick n dirty way
-- 
-- ####################

--select * from filesToLoad

/*
update filesToLoad2
set loadStatus = 9 where id = 59

select count(*) from filestoload2
where loadStatus = 9

update filestoload
set loadSTatus = 0

*/
----------------------------------------------
-- set these!!!!
declare @doExecute bit = 1
declare @truncate bit = 1
-----------------------------------------------

declare @sql nvarchar(4000)
declare @id int
declare @path nvarchar(1000)
declare @prefix nvarchar(1000)
declare @targettable sysname

declare cur cursor fast_forward for 
select id, path, prefix, targettable from filestoload
where loadStatus = 0

open cur
fetch next from cur into @id, @path, @prefix, @targettable
while @@FETCH_STATUS = 0
begin
/*
BULK INSERT Sales.Orders
FROM '\\SystemX\DiskZ\Sales\data\orders.csv'
WITH ( FORMAT = 'CSV');
*/
	declare @fullpath nvarchar(1000)
	set @fullpath = concat(@path, @prefix, @targettable, '.csv')
	
	set @sql = ''
	if @truncate = 1
		set @sql = concat('TRUNCATE TABLE ',@targettable,';')
	--BULK INSERT dr18_allwise FROM 'd:\dr18loading\minidb\csv\minidb.dr18_allwise.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', rowterminator='0x0a');

	
	set @sql = concat(@sql, 'BULK INSERT ', @targettable, ' FROM ''', @fullpath, ''' WITH (DATAFILETYPE=''char'', FIRSTROW=2, FIELDTERMINATOR='','', ROWTERMINATOR=''0x0a'', TABLOCK);','
	')
	print @sql
	if (@doExecute = 1)
	begin
		begin tran
			exec sp_executesql @sql
			set @sql = concat('update filestoload set lastLoadDate=''',GETDATE(),''', loadStatus=2 WHERE id=',@id,'
			')
			print @sql
			exec sp_executesql @sql
		commit tran
	end


	
	fetch next from cur into @id, @path, @prefix, @targettable
	
end

close cur
deallocate cur