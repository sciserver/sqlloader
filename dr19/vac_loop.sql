
	declare @tablename sysname
	declare @sql nvarchar(2000)
	declare @fieldlist nvarchar(200)
	declare @doExecute bit

	set @doExecute=0

	declare cur cursor for

	select tablename from tables_sue
		--SELECT
		--	  sOBJ.name AS [TableName]
		--	  --, SUM(sdmvPTNS.row_count) AS [RowCount]
		--FROM
		--	  sys.objects AS sOBJ
		--	  INNER JOIN sys.dm_db_partition_stats AS sdmvPTNS
		--			ON sOBJ.object_id = sdmvPTNS.object_id
		--WHERE 
		--	  sOBJ.type = 'U'
		--	  AND sOBJ.is_ms_shipped = 0x0
		--	  AND sdmvPTNS.index_id < 2
	
		--GROUP BY
		--	  sOBJ.schema_id
		--	  , sOBJ.name
		--having SUM(sdmvPTNS.row_count) > 750
		----ORDER BY [RowCount] desc

	open cur
	fetch next from cur into @tablename

	while @@FETCH_STATUS = 0
	begin
		

		-- drop existing
		--set @sql = 'DROP TABLE IF EXISTS BestDR19.dbo.' + @tablename
		--print @sql
		--if @doExecute=1
		--	exec sp_executesql @sql

		---- create table
		--set @sql = concat('SELECT * into BestDR19.dbo.',@tablename,' FROM ',@tablename ,' where 0=1')
		--print @sql
		--if @doExecute=1
		--	exec sp_executesql @sql


		--select @fieldlist = fieldlist from IndexMap where tableName = @tablename
		---- create index
		--set @sql = concat('ALTER TABLE BestDR19.dbo.', @tablename,' ADD CONSTRAINT pk_',@tablename,
		--	' PRIMARY KEY CLUSTERED (',@fieldlist,') WITH (DATA_COMPRESSION=PAGE) ON SPEC')
		--print @sql
		--if @doExecute=1
		--	exec sp_executesql @sql

		-- insert / select
		set @sql = concat('insert BestDR19.dbo.',@tablename,' with (tablock)
		select * from ',@tablename)
		print @sql
		print ''
		print ''
		if @doExecute=1
			exec sp_executesql @sql


		FETCH NEXT FROM cur into @tablename
	end

	close cur
deallocate cur



	

