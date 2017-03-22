--add files and filegroups
--requires SueDB.dbo.DR13CompFiles

--select * from DR13CompFiles

--select  [filegroup], count([filename])
--from suedb.dbo.DR13CompFiles
--group by [filegroup]


declare @sql nvarchar(max)
declare @dbname sysname
declare @fgname sysname
declare @datadir nvarchar(1000)
declare @divisor int
declare @nfiles int

declare @doExecute bit

set @doExecute = 0

set @dbname = 'BESTTEST_DR14'
set @datadir = 'D:\data1\sql_db\BESTTEST_DR14\'
set @divisor = 50 --divide file sizes by 50 to get approx 500GB db

set nocount on

declare fgcur cursor for 
select  [filegroup], count([filename])
from suedb.dbo.DR13CompFiles
where [filegroup] != 'PRIMARY'
and fileType = 'Data'
group by [filegroup]

open fgcur
fetch next from fgcur into @fgname, @nfiles

while (@@FETCH_STATUS = 0)
begin
	
	declare @origSize numeric(18,2)
	declare @fsize int

	select top 1  @origSize = TotalMB 
	from sueDB.dbo.DR13CompFiles
	where Filegroup=@fgname

	set @fsize = floor(@origSize/@divisor)

	--create filegroup
	set @sql = 'ALTER DATABASE ' + @dbname + ' ADD FILEGROUP ' + @fgname
	print @sql
	if (@doExecute = 1)
		exec sp_executesql @sql
	print '----'


	--add files to FG
	declare @i int
	declare @filename sysname
	
	set @i = 1
	while (@i < @nfiles)
	begin
		set @filename = @fgname + '_' +  right('00'+convert(varchar(2), @i), 2)
		set @sql = 'ALTER DATABASE ' + @dbname + ' ADD FILE (
			NAME = '+@filename+',
			FILENAME = ''' + @datadir + @filename + '.ndf'',
			SIZE = ' + cast(@fsize as nvarchar) +'MB,
			FILEGROWTH=100MB
			)
		TO FILEGROUP ' + @fgname

		print @sql

		if (@doExecute = 1)
		exec sp_executesql @sql	

		set @i = @i + 1
	end

	print '---------'

	fetch next from fgcur into @fgname, @nfiles
end
close fgcur
deallocate fgcur

