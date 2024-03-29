
USE LamostDR8

-- ###################
-- 
-- load dr18 csv files 
-- the quick n dirty way
-- 
-- ####################

--select * from filesToLoad2

/*
update filesToLoad2
set loadStatus = 9 where id = 59

select count(*) from filestoload2
where loadStatus = 9

update filestoload2
set loadSTatus = 0

*/



----------------------------------------------
-- set these!!!!
declare @doExecute bit = 1
declare @truncate bit = 1
-----------------------------------------------

declare @sql nvarchar(4000)
declare @id int
declare @fname nvarchar(2000)
declare @targettable sysname

declare cur cursor fast_forward for 
select name from sys.tables
where name not like '%plan%' and name not like '%qso%'

open cur
fetch next from cur into @targettable
while @@FETCH_STATUS = 0
begin
/*
BULK INSERT Sales.Orders
FROM '\\SystemX\DiskZ\Sales\data\orders.csv'
WITH ( FORMAT = 'CSV');
*/

	--D:\LAMOST\DR8_v2\dr8_v2.0_    LRS_astellar.csv

	set @fname = concat('D:\LAMOST\DR8_v2\dr8_v2.0_', @targettable, '.csv')

	set @sql = ''
	if @truncate = 1
		set @sql = concat('TRUNCATE TABLE ',@targettable,';')
	--BULK INSERT dr18_allwise FROM 'd:\dr18loading\minidb\csv\minidb.dr18_allwise.csv' WITH (DATAFILETYPE='char', FIRSTROW=2, FIELDTERMINATOR=',', rowterminator='0x0a');

	
	set @sql = concat(@sql, 'BULK INSERT ', @targettable, ' FROM ''', @fname, ''' WITH (DATAFILETYPE=''char'', FIRSTROW=2, FIELDTERMINATOR='','', ROWTERMINATOR=''0x0a'', FIELDQUOTE=''"'', TABLOCK);','
	')
	print @sql
	if (@doExecute = 1)
	begin
		begin tran
			exec sp_executesql @sql
			--set @sql = concat('update filestoload2 set lastLoadDate=''',GETDATE(),''', loadStatus=2 WHERE id=',@id,'
			--')
			--print @sql
			--exec sp_executesql @sql
		commit tran
	end


	
	fetch next from cur into  @targettable
	
end

close cur
deallocate cur



