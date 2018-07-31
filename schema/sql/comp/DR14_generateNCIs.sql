


DECLARE @indexName varchar(1000),
		@cmd nvarchar(4000),
		@msg varchar(2000),
		@status varchar(16),
		@fgroup varchar(100),
		@ret int,
		@error int,
		@type varchar(100), 		-- primary key, unique, index, foreign key 
		@code char(1),			-- the character code, 'K','I','F'
		@tableName varchar(100), 	-- table name 'photoObj'
		@fieldList varchar(1000),	-- fields 'u,g,r,i,z'
		@foreignKey varchar(1000),  	-- if foreign key 'SpecObj(SpecObjID)'
		@compression varchar(4) = null,		-- compression type (row, page, or null)
		@filegroup sysname
	--
	SET @status = 'OK'

	drop table  ##indextab

select t1.* 
into ##indextab
from IndexMapFG t1
join sueDB.dbo.indexPrimary t2
on t2.objectName = t1.tableName
where t1.code='I'



--select * from ##indextab

declare cur cursor for
select code, type, tableName, fieldList, compression, filegroup
from ##indextab

open cur
fetch next from cur into @code, @type, @tablename, @fieldlist, @compression, @filegroup

while @@FETCH_STATUS = 0
begin
	
	set @indexName = dbo.fIndexName(@code,@tablename,@fieldList,@foreignKey)
	--print @indexName

	IF ((lower(@type) = 'index') or (lower(@type) = 'unique index'))
	    BEGIN
		set @cmd = N'SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; CREATE '+upper(@type)+' '+@indexName+' ON '    
			+@tableName+'('+@fieldList+') WITH (SORT_IN_TEMPDB=ON';

		if (@compression is not null)
		begin
			set @cmd = @cmd + ' ,DATA_COMPRESSION = ' + @compression 
		end
		
		set @cmd = @cmd + ')'
		--

		
	    END
		set @cmd = @cmd + ' ON ['+@filegroup +']'
		--


		print @cmd

		fetch next from cur into @code, @type, @tablename, @fieldlist, @compression, @filegroup
end

close cur
deallocate cur

