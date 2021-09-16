-- Measures tables size (in kilobytes)
-- Tested in MS SQL Server 2008 R2

declare @t table (
name nvarchar(100), [rows] int, [reserved] nvarchar(100), [data] nvarchar(100), [index_size] nvarchar(100), [unused] nvarchar(100)
)
declare @name nvarchar(100)
declare @created datetime

declare tt cursor for
Select name from sys.tables order by create_date desc
open tt

fetch next from tt into @name
while @@FETCH_STATUS = 0
begin
  insert into @t
  exec sp_spaceused @name
  fetch next from tt into @name
end

close tt
deallocate tt

select name as table_name, [rows] as rows_count, data + [index] as total_size, data as data_size, [index] as index_size
into tableSizes
from (select name,
[rows],
cast (LEFT(data, LEN(data)-3) as int) data,
cast (LEFT(index_size, LEN(index_size)-3) as int) [index]
 from @t
) x
-- order by 3 desc, 1

select * from tableSizes
