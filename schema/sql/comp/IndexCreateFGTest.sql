DECLARE @indexName varchar(1000),
		@cmd nvarchar(2000),
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
		@compression varchar(4) = null		-- compression type (row, page, or null)
		
	--
	SET @status = 'OK'


	----
	-- for testing
	---
	declare @indexmapid int
	set @indexmapid = 82
	
	--------------------------------------------------
	-- fetch the parameters needed for spIndexCreate
	--------------------------------------------------
	SELECT @type=type, @code=code, @tablename=tableName, 
		@fieldlist=fieldList, @foreignkey=foreignKey, @compression=[compression], @fgroup=[filegroup]
	    FROM DR15_IndexMap2 WITH (nolock)
	    WHERE indexmapid=@indexmapid;

	------------------------------------------------
	-- get the name of the filegroup for the index
	------------------------------------------------
	--this data is in IndexMap now, not FileGroupMap --sw
	
	--set @fgroup = null;
	--select @fgroup = coalesce(indexFileGroup,'PRIMARY')
	--	from FileGroupMap with (nolock)
	--	where tableName=@tableName;
	--
	IF  @fgroup is null SET @fgroup='PRIMARY';
	SET @fgroup = '['+@fgroup+']';
	--
	set @indexName = dbo.fIndexName(@code,@tablename,@fieldList,@foreignKey)
	set @fieldList  = REPLACE(@fieldList,' ','');
	--
/*
	------------------------------------------------
	-- check the existence of the table first, and 
	-- issue warning and exit if it doesnt exist
	------------------------------------------------
	IF NOT EXISTS (SELECT name FROM sysobjects
        	WHERE xtype='U' AND name = @tableName)
	    BEGIN
		SET @msg = 'Could not create index ' + @indexName + ': table ' 
			+ @tablename + ' does not exist!'
		SET @status = 'WARNING'
		EXEC spNewPhase @taskid, @stepid, 'IndexCreate', @status, @msg 
		-----------------------------------------------------
		RETURN 1	
	    END
*/
	---------------
	-- Primary key
	---------------
	IF (lower(@type) = N'primary key')
	    BEGIN
		set @cmd = N'SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; ALTER TABLE '+@tablename+' ADD CONSTRAINT '
			+@indexName+' PRIMARY KEY CLUSTERED '
			+'('+@fieldList+') '

		if (@compression is not null)
		begin
			set @cmd = @cmd + ' WITH (DATA_COMPRESSION = ' + @compression + ')'
		end

		if (@fgroup is not null)
		begin 
			set @cmd = @cmd + ' ON ' + @fgroup + ''
		end
		--
		set @msg = 'primary key constraint '+@tableName+'('+@fieldList+')' + ' ' + @compression + ' on ' + coalesce(@fgroup, 'PRIMARY')

		print @cmd

	    END
	------------------
	-- [unique] index
	------------------
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
		if @fgroup is not null set @cmd = @cmd +' ON '+@fgroup;
		--
		set @msg = @type+' '+@tableName+'('+@fieldList+')'  + ' ' + @compression + ' on ' + coalesce(@fgroup, 'PRIMARY')


		print @cmd
		
	    END