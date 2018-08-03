
declare @tablename sysname
set @tablename = 'PhotoObjAll'

declare @out TABLE (
	[enum]		varchar(64),
	[name]		varchar(64),
	[type] 		varchar(32),
	[length]	int,
	[unit]		varchar(64),
	[ucd]		varchar(64),
	[description]	varchar(2048),
	[columnID]		int primary key
)

	---------------------------------
	-- get the objectid of DBObject,
	-- and its system type
	---------------------------------
	DECLARE @oid bigint, @type varchar(3);
	SELECT @oid=object_id, @type=type
	FROM sys.objects
	WHERE name=@tablename

	
	--Test to see if 'PhotoObjAll' is a table or view in this DB
	declare @photoType varchar(3)
	
	select @photoType = o.type
	from sys.objects o
	where o.name = 'PhotoObjAll'

	if (@photoType = 'V') --if PhotoObjAll is a view, we're in a DRx db
	begin
		--test if @tablename is 'common' and needs special handling
		declare @common bit
		select @common=common from IndexMap where tablename=@tablename and code = 'K'
		if (@common = 1) --it's a view but let's treat it like a table, special case code at end
		set @type = 'X'
	end

	

	-------------------
	-- handle views
	-------------------
	IF (@type='V')
	BEGIN
		-- 
		-- figure out if the referenced object is in the same db or different db
		--declare @sourceServer sysname, @sourceDB sysname, @sourceTable sysname, @sourceSchema sysname
		/*
		declare @sTab table (sourceServer sysname null, sourceDB sysname null, sourceSchema sysname null, sourceTable sysname null)
		insert @sTab 
		SELECT 
			referenced_server_name,referenced_database_name, referenced_schema_name,  
			 referenced_entity_name
		FROM sys.sql_expression_dependencies AS sed  
		INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id  
		WHERE referencing_id = @oid;  

		select * from @sTab

		--if sourceDB IS NOT NULL, handle as if it's a table, but get 
		--data out of DBColumns table in sourceDB
		--handle this by calling fDocColumns in sourceDB and getting the result
		--have to use dynamic sql i guess yuck
		--crap can't use dynamic sql in a function
		--why is this a function and not a stored procedure ughhh
	*/

	--WAIT THIS MIGHT BE EASIER
	--TREAT STUFF WHERE COMMON=0 LIKE TABLES


		---------------------------------------------------
		-- extract distinct parent-child relationships
		-- from the sys.sql_dependencies table, ignoring
		-- the column information first
		---------------------------------------------------
		DECLARE @meta TABLE (
			tableName varchar(128),
			name varchar(64),
			unit varchar(64),
			ucd varchar(128),
			enum varchar(64),
			description varchar(2000)
		)
		DECLARE @depends table (
			child varchar(32),
			parent varchar(32),
			type varchar(32)
		)
		--
		INSERT @depends
		SELECT distinct d.VIEW_NAME as child, d.TABLE_NAME as parent, o.TABLE_TYPE as type
		FROM INFORMATION_SCHEMA.VIEW_COLUMN_USAGE d, INFORMATION_SCHEMA.TABLES o
		WHERE d.TABLE_NAME=o.TABLE_NAME;
		-----------------------------------------------
		-- extract the parent objects, by tracking
		-- them on the dependency tree, until we get
		-- to user tables
		-----------------------------------------------
		WITH Next (child, parent, type, level)
		AS
		( select child, parent, type, 0
			from @depends where child=@tablename
		UNION ALL
		  select p.child, p.parent, p.type, level+1
			from @depends p inner join
			Next A ON A.parent = p.child
		)
		----------------------------------------------
		-- get distinct names of columns that we depend on
		----------------------------------------------
		INSERT @meta
		SELECT m.tablename, m.name, m.unit, m.ucd, m.enum, m.description
		FROM Next p, INFORMATION_SCHEMA.VIEW_COLUMN_USAGE d, DBColumns m
		WHERE p.child = d.VIEW_NAME
		  and p.parent= d.TABLE_NAME
		  and p.type  ='BASE TABLE'
		  and d.TABLE_NAME  = m.tableName
		  and d.COLUMN_NAME = m.name
		-------------------------------------
		-- Get list of columns in the view
		-- and all their relevant properties.
		-- Need the sys.columns, since only 
		-- this has only the max_length in bytes
		-------------------------------------
		INSERT @out
		SELECT '', c.name, t.name as type, c.max_length as length,
			'','','',c.column_id
		FROM sys.columns c, sys.types t, sys.objects o
		WHERE c.system_type_id = t.system_type_id
		  and c.object_id = o.object_id
		  and o.name = @tablename
		ORDER BY c.column_id
		---------------------------------------
		-- insert back if there is easy match
		---------------------------------------
		UPDATE o
		SET enum = m.enum,
			unit = m.unit,
			ucd  = m.ucd,
			description = m.description
		FROM @out o, @meta m
		WHERE o.name = m.name
		------------------------------------------------
		-- one could do better by looking for leftovers
		-- but do not want to go there now
		------------------------------------------------
	END
	---------------------------
	-- handle a table
	---------------------------
	IF (@type='U')
	BEGIN
	---------------------------
		INSERT @out
		SELECT m.enum, c.name, t.name as type, c.max_length as length,
			m.unit, m.ucd, m.description, c.column_id
		FROM sys.objects o, sys.columns c, sys.types t, DBColumns m
		WHERE o.object_id=c.object_id
		  and o.type_desc='USER_TABLE'
		  and m.tablename = o.name
		  and c.name = m.name
		  and c.system_type_id = t.system_type_id
		  and o.name=@tablename
		  order by c.column_id
	END
	--------------------------

	--------------------------
	-- handle a view that should be treated like a table
	-- in a DRx / multi-DR DB
	--------------------------
	if (@type = 'X')
	BEGIN
			INSERT @out
		SELECT m.enum, c.name, t.name as type, c.max_length as length,
			m.unit, m.ucd, m.description, c.column_id
		FROM sys.objects o, sys.columns c, sys.types t, DBColumns m
		WHERE o.object_id=c.object_id
		  and o.type_desc='VIEW'
		  and m.tablename = o.name
		  and c.name = m.name
		  and c.system_type_id = t.system_type_id
		  and o.name=@tablename
		  order by c.column_id
	END
	--------------------------


	
select * from @out

